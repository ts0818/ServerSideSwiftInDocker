# swift入りのUbuntuだと、vaporのインストールが失敗する...っていうか何でApple公式のimageで失敗するのか謎
# base-image(https://hub.docker.com/_/swift)
FROM swift:5.1.2-bionic

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes
RUN apt-get clean
RUN apt-get update && apt-get -y install \
vim \
wget \
apt-transport-https \
ca-certificates \
curl \
git \
zlib1g-dev

# swift がインストールされてるか確認
RUN swift --version

# Swift 5.1.2:bionic だとエラーになる
# RUN /bin/bash -c "$(wget -qO- https://apt.vapor.sh)"
# RUN apt-get -y install vapor

RUN git clone https://github.com/vapor/toolbox.git

WORKDIR /toolbox
# RUN cd toolbox
RUN git checkout master
# RUN git checkout vapor-4
RUN swift build -c release --disable-sandbox
RUN mv .build/release/vapor /usr/local/bin

# パス通ってるかも知らんが、一応
ENV PATH $PATH:/usr/local/bin/.build/release/vapor

# Vapor Toolboxがインストールされてるか確認
RUN vapor --help

# vaporの雛型（ブランクプロジェクト）の作成
RUN vapor new app --template=web -n

# RUN vapor new app --template=web
# RUN vapor-beta new app -n

WORKDIR /app
# ↓Xcodeで開くってことらしい、「open: not found」ってなるんだけど...
# RUN open Package.swift
# RUN swift build
RUN vapor build

ENTRYPOINT ./Run serve -e prod -b 0.0.0.0