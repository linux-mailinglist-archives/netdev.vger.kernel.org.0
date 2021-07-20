Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460DD3CFC0B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239426AbhGTNpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239219AbhGTNoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0CF61186;
        Tue, 20 Jul 2021 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791080;
        bh=33FmweyIjGpVwxzS1gA3HQJS3T8GqGsOi0jCBxqYN30=;
        h=From:To:Cc:Subject:Date:From;
        b=YK4PZQq/OzfDxHeNyj17714LT48vsbniEwjfJNGXPs92nfuczOGbz/n+ah08bZbfG
         MpOGGYM1vqv5JXWRt359XrF8JfvHQ1GBUgsLW4b3uyZbtqV96stVh5pG9+CBTgNW6e
         vkX9zE/tEsMbqv40HhdMZc1hkM+9pLVld8RXoLMIFzeOMrw/U9ZYjakNdIpGLLGDH5
         rmumfStwrIiWu37FSJmkl8ZeVWgw/G1dv6gLxsp2A5u7x+ePLSiKZUiPt/nlQd/mRE
         JV9ps9ufZ2DG7CIYNvn8EM/Yd4M4aI4OpTiCAlv2g9Al+YbZnNO2xx7S32yLtufp8a
         2rftw4HYYmC8w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v5 0/4] remove compat_alloc_user_space()
Date:   Tue, 20 Jul 2021 16:24:32 +0200
Message-Id: <20210720142436.2096733-1-arnd@kernel.org>
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
correct. This has led to a series of 29 additional patches
that I am not including here but will post separately, fixing
a number of bugs in SIOCDEVPRIVATE ioctls, removing dead
code, and splitting ndo_do_ioctl into two new ndo callbacks
for private and ethernet specific commands.

The patches are largely identical to v4 that I sent last
November, with small fixes for issues pointed out by Jakub
and my own randconfig build bot.

      Arnd

Link: https://lore.kernel.org/netdev/20201124151828.169152-1-arnd@kernel.org/

Changes in v5:
 - Rebase to v5.14-rc2
 - Fix a few build issues

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
 net/ethtool/ioctl.c        | 136 +++++++++++++++--
 net/ieee802154/socket.c    |   4 +-
 net/ipv4/af_inet.c         |   6 +-
 net/ipv4/devinet.c         |   4 +-
 net/qrtr/qrtr.c            |   4 +-
 net/socket.c               | 292 +++++++++----------------------------
 12 files changed, 333 insertions(+), 376 deletions(-)

-- 
2.29.2

