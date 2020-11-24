Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21D2C2B10
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbgKXPSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732490AbgKXPSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:18:43 -0500
Received: from threadripper.lan (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4378A206D5;
        Tue, 24 Nov 2020 15:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606231122;
        bh=MnqF57UH63iXjzy798rGPIrvpOmsMor/v8SjKsNmLD4=;
        h=From:To:Cc:Subject:Date:From;
        b=lhCQpvCcczcIJvlOOAtOz0HndDUjPv+GfD3/y5jwU/6MLaqdCbXXBADVC3rvbFGmf
         bQufY7lecmoDsEU6pJdNG31KhIk4QCDA8Kg5BPQV3MH7IXAB7gYjvsnkp8K/8ARlIE
         yibO2D+vhMy1QnhA0RkNw4px2qYhG+s117ZgHgOM=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 0/4] remove compat_alloc_user_space()
Date:   Tue, 24 Nov 2020 16:18:24 +0100
Message-Id: <20201124151828.169152-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This is the fourth version of my series, now spanning four patches
instead of two, with a new approach for handling struct ifreq
compatibility after I realized that my earlier approach introduces
additional problems.

The idea here is to always push down the compat conversion
deeper into the call stack: rather than pretending to be
native mode with a modified copy of the original data on
the user space stack, have the code that actually works on
the data understand the difference between native and compat
versions.

I have spent a long time looking at all drivers that implement
an ndo_do_ioctl callback to verify that my assumptions are
correct. This has led to a series of 29 additional patches
that I am not including here but will post separately, fixing
a number of bugs in SIOCDEVPRIVATE ioctls, removing dead
code, and splitting ndo_do_ioctl into two new ndo callbacks
for private and ethernet specific commands.

The patches are identical to v3 that I sent a few weeks ago,
except this avoids the build failure when CONFIG_COMPAT is
disabled.

      Arnd

Changes in v4:
 - build fix without CONFIG_INET
 - build fix without CONFIG_COMPAT
 - style fixes pointed out by hch

Changes in v3:
 - complete rewrite of the series


Arnd Bergmann (4):
  ethtool: improve compat ioctl handling
  net: socket: rework SIOC?IFMAP ioctls
  net: socket: simplify dev_ifconf handling
  net: socket: rework compat_ifreq_ioctl()

 include/linux/compat.h     |  82 +++++------
 include/linux/ethtool.h    |   4 -
 include/linux/inetdevice.h |   9 ++
 include/linux/netdevice.h  |  12 +-
 net/appletalk/ddp.c        |   4 +-
 net/core/dev_ioctl.c       | 152 ++++++++++---------
 net/ethtool/ioctl.c        | 143 ++++++++++++++++--
 net/ieee802154/socket.c    |   4 +-
 net/ipv4/af_inet.c         |   6 +-
 net/ipv4/devinet.c         |   4 +-
 net/qrtr/qrtr.c            |   4 +-
 net/socket.c               | 289 ++++++++-----------------------------
 12 files changed, 338 insertions(+), 375 deletions(-)

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


-- 
2.27.0

