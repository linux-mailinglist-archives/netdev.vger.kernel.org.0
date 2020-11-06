Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F492A9AD3
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbgKFRco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:32:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgKFRco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 12:32:44 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5BC2208C7;
        Fri,  6 Nov 2020 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604683963;
        bh=5G5/+qsfkd03dr/u9VuK6kmwlPcC74OxnFKxdHbYmIw=;
        h=From:To:Cc:Subject:Date:From;
        b=Yt4ZdVGlSocn/CabcrgBRNKDeNavDHJrSKyeYhL8BDuvg3sk4KJP/1ztC9FXS6+7a
         iWNr6OA3sVh2aztUxqjg9nlvGfgmALKxjMvTOnU5B7TRPkjWRYseRIe6L1loKYfM+z
         stBEEvQz41PmdgY89FE89Yx2yRgb4NmgnhdJCBJg=
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
Subject: [PATCH net-next v3 0/4] remove compat_alloc_user_space()
Date:   Fri,  6 Nov 2020 18:32:27 +0100
Message-Id: <20201106173231.3031349-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This is the third version of my seires, now spanning four patches
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

    Arnd

Arnd Bergmann (4):
  ethtool: improve compat ioctl handling
  net: socket: rework SIOC?IFMAP ioctls
  net: socket: simplify dev_ifconf handling
  net: socket: rework compat_ifreq_ioctl()

 include/linux/compat.h     |  18 +--
 include/linux/ethtool.h    |   4 -
 include/linux/inetdevice.h |   8 +
 include/linux/netdevice.h  |  12 +-
 net/appletalk/ddp.c        |   4 +-
 net/core/dev_ioctl.c       | 156 +++++++++++---------
 net/ethtool/ioctl.c        | 143 ++++++++++++++++--
 net/ieee802154/socket.c    |   4 +-
 net/ipv4/af_inet.c         |   6 +-
 net/ipv4/devinet.c         |   4 +-
 net/qrtr/qrtr.c            |   4 +-
 net/socket.c               | 291 +++++++++----------------------------
 12 files changed, 311 insertions(+), 343 deletions(-)

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

