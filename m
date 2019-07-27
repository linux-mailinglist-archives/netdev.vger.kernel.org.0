Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A329B777F7
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbfG0JpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:45:02 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:39759 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbfG0JpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 05:45:02 -0400
Received: by mail-wm1-f51.google.com with SMTP id u25so39160225wmc.4
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 02:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1k/1wm+N7shOd9rz5DG/vh07V48TlJQtYdFDDPRdU4Y=;
        b=sN+Esk9AzFuvIU8AxLlGC8BjJWNrmCZDlah/nXmDyJUuQhQqXAbWSIAl5M5jBjnX8V
         cxz2tY19hl2dNqmztBqOW7Z+gjxIBfwW7GH5p4D2nCJ3gREixGfQcyLntum7s8Fh+EWe
         eSQt/zIzkj3FKiSuRnmNfYr85FTG8DsJth/77VAe2sbBme9A75jBpBkRXYkbMlgtsg/K
         Mp6ApGGd+OmnkBZNdwSdQKbUoHukDsGzrHlBNuoErw2WV+61Lc+9H6yA1+Yjn+pM3trr
         SiUkMMmySy0t6JhE9j6MLSklj3+oE+Omrlpd/dhJJNOgokiuvVtIPRW3GOZD5f8D5WOR
         lXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1k/1wm+N7shOd9rz5DG/vh07V48TlJQtYdFDDPRdU4Y=;
        b=WeLlLJBzk6mLj/RQEQ4r8FC+CbjvYjEoDs+cDopTVPRbIDBx72ng88qDOe+TX+Jkhf
         WVoqrKJD5OY0Tor0n9PnYFzu/xU/UNQd2LSXfbg4oKdIeJt6vD5s/qPV3J3aiIqDYyh7
         Z6+LYl6UelV6nhkYK0hONCT1Z/xbwXGgWqkGkKoGAl5ULD8TODpB9IOsBa/xSWO+sWin
         c7SkiVv5rKdsHYvSrE8fahl+V71giVQm9OpxEnK8DZKlzbwgx/4fXqbmxl8Mm4gzRAlF
         4hrD7e7jzdyrPxcu94FLUYLPF16f7oRtkYzh2/xcjgnHJk1xCfvQMtDPP/LVHzCFe731
         BjpA==
X-Gm-Message-State: APjAAAWsU7Ew3waFoUXp/Hj1+9A+qRQKGbjrSmantmw76LKvbmiB96Qj
        /+rZS1HzNK9d50R3HjFxBY4QbdlO
X-Google-Smtp-Source: APXvYqy6TPAUuq0qdWGkuYEInSfZqP8TLWkHlBvNgkpMkyjdhC48xA82s3EmbwjU3vyb7mnEmeS/qg==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr90503471wmj.89.1564220700047;
        Sat, 27 Jul 2019 02:45:00 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id r12sm66191804wrt.95.2019.07.27.02.44.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 02:44:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next 0/3] net: devlink: Finish network namespace support
Date:   Sat, 27 Jul 2019 11:44:56 +0200
Message-Id: <20190727094459.26345-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Devlink from the beginning counts with network namespaces, but the
instances has been fixed to init_net. The first patch allows user
to move existing devlink instances into namespaces:

$ devlink dev
netdevsim/netdevsim1
$ ip netns add ns1
$ devlink dev set netdevsim/netdevsim1 netns ns1
$ devlink -N ns1 dev                                   
netdevsim/netdevsim1

The last patch allows user to create new netdevsim instance directly
inside network namespace of a caller.

Jiri Pirko (3):
  net: devlink: allow to change namespaces
  net: devlink: export devlink net set/get helpers
  netdevsim: create devlink and netdev instances in namespace

 drivers/net/netdevsim/bus.c       |   1 +
 drivers/net/netdevsim/dev.c       |  17 ++--
 drivers/net/netdevsim/netdev.c    |   4 +-
 drivers/net/netdevsim/netdevsim.h |   5 +-
 include/net/devlink.h             |   3 +
 include/uapi/linux/devlink.h      |   4 +
 net/core/devlink.c                | 128 ++++++++++++++++++++++++++++--
 7 files changed, 148 insertions(+), 14 deletions(-)

-- 
2.21.0

