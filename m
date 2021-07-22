Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71083D25B7
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhGVNso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhGVNsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FE1A6101E;
        Thu, 22 Jul 2021 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626964157;
        bh=zM04WpA1f7iRwT47P4olhNDO3hfO6UH/Gt2Ynkv7aOQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cqbniFsd8XOi4XfrJjOLuySlDUQ7CBCdF3SdSpwbfun3l4gP0pHz9Wd5SRJfmw01D
         rciF8Kv7FW46A5EwjsN3Vyf/5Rvh5E4R1qbfRkNj4Ah7m15FA70xcCyR2lJGOf7ydu
         jIYTxKhsUR7/+TFmf1JMvzJem8QxdQDfXl9JoKgQvi8CA3aKTBIcT5vNSJ16PLNIQn
         2iB22HcT9QKEsx04GsH092Gr337HqpBpxy1s9QDpdG8P/ZwhVhh5Akiv/OktZiNros
         oQ4kaV5Pav2/o+o+R2LAoMB29VqRD9QNkOwZ0w8PFM5LeRC8/XOeJCgqB1Y3+bIYtV
         oT1Qe8xs2kF/Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH net-next v6 0/6] remove compat_alloc_user_space()
Date:   Thu, 22 Jul 2021 16:28:57 +0200
Message-Id: <20210722142903.213084-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This is the fifth version of my series, now spanning four patches
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
correct. This has led to a series of ~30 additional patches
that I am not including here but will post separately, fixing
a number of bugs in SIOCDEVPRIVATE ioctls, removing dead
code, and splitting ndo_do_ioctl into multiple new ndo callbacks
for private and ethernet specific commands.

      Arnd

Link: https://lore.kernel.org/netdev/20201124151828.169152-1-arnd@kernel.org/

Changes in v6:
 - Split out and expand linux/compat.h rework
 - Split ifconf change into two patches
 - Rebase on latest net-next/master

Changes in v5:
 - Rebase to v5.14-rc2
 - Fix a few build issues

Changes in v4:
 - build fix without CONFIG_INET
 - build fix without CONFIG_COMPAT
 - style fixes pointed out by hch

Changes in v3:
 - complete rewrite of the series

Arnd Bergmann (6):
  compat: make linux/compat.h available everywhere
  ethtool: improve compat ioctl handling
  net: socket: rework SIOC?IFMAP ioctls
  net: socket: remove register_gifconf
  net: socket: simplify dev_ifconf handling
  net: socket: rework compat_ifreq_ioctl()

 arch/arm64/include/asm/compat.h   |  14 +-
 arch/mips/include/asm/compat.h    |  24 ++-
 arch/parisc/include/asm/compat.h  |  14 +-
 arch/powerpc/include/asm/compat.h |  11 --
 arch/s390/include/asm/compat.h    |  14 +-
 arch/sparc/include/asm/compat.h   |  14 +-
 arch/x86/include/asm/compat.h     |  14 +-
 arch/x86/include/asm/signal.h     |   1 +
 include/asm-generic/compat.h      |  17 ++
 include/linux/compat.h            |  32 ++--
 include/linux/ethtool.h           |   4 -
 include/linux/inetdevice.h        |   9 +
 include/linux/netdevice.h         |  12 +-
 net/appletalk/ddp.c               |   4 +-
 net/core/dev_ioctl.c              | 153 +++++++++-------
 net/ethtool/ioctl.c               | 136 ++++++++++++--
 net/ieee802154/socket.c           |   4 +-
 net/ipv4/af_inet.c                |   6 +-
 net/ipv4/devinet.c                |   4 +-
 net/qrtr/qrtr.c                   |   4 +-
 net/socket.c                      | 292 +++++++-----------------------
 21 files changed, 352 insertions(+), 431 deletions(-)

-- 
2.29.2

Cc: Al Viro <viro@zeniv.linux.org.uk> 
Cc: Andrew Lunn <andrew@lunn.ch> 
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Ahern <dsahern@kernel.org> 
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org> 
Cc: Jakub Kicinski <kuba@kernel.org> 
Cc: Kees Cook <keescook@chromium.org> 
Cc: Marco Elver <elver@google.com> 
Cc: linux-kernel@vger.kernel.org 
Cc: linux-arch@vger.kernel.org 
Cc: netdev@vger.kernel.org 
