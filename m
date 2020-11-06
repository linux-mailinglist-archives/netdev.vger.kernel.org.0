Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346D42A9FD8
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgKFWSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728887AbgKFWSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:18 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 427922087E;
        Fri,  6 Nov 2020 22:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701097;
        bh=ejrB3sfP8Vhn5+VAUXi+L6LpDodKnVmFjv0rU9L8csY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/hvgIT92Bk0M83Xab3GbNkl+xpVG4NHaBN01+8U6H+Er1kiG4YsX3i4m4ZP00e2y
         2mkHLMu1fUhv43aUCI7R9In7ltd2PSh6WT6PJ7Fex8Xg8/YNd0P6InD5wUyOKpnuDY
         Utxsq02pbsuZJdJjZeYJsUConVTbwpD/SQvJysOI=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 08/28] tulip: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:23 +0100
Message-Id: <20201106221743.3271965-9-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The tulip driver has a debugging method over ioctl built-in, but it
does not actually check the command type, which may end up leading
to random behavior when trying to run other ioctls on it.

Change the driver to use ndo_siocdevprivate and limit the execution
further to the first private command code. If anyone still has tools
to run these debugging commands, they might have to be patched for
it if they pass different ioctl command.

The function has existed in this form since the driver was merged in
Linux-1.1.86.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 683e328b5461..59a85f5b35fb 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -902,7 +902,7 @@ static int     de4x5_close(struct net_device *dev);
 static struct  net_device_stats *de4x5_get_stats(struct net_device *dev);
 static void    de4x5_local_stats(struct net_device *dev, char *buf, int pkt_len);
 static void    set_multicast_list(struct net_device *dev);
-static int     de4x5_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int     de4x5_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd);
 
 /*
 ** Private functions
@@ -1084,7 +1084,7 @@ static const struct net_device_ops de4x5_netdev_ops = {
     .ndo_start_xmit	= de4x5_queue_pkt,
     .ndo_get_stats	= de4x5_get_stats,
     .ndo_set_rx_mode	= set_multicast_list,
-    .ndo_do_ioctl	= de4x5_ioctl,
+    .ndo_siocdevprivate	= de4x5_siocdevprivate,
     .ndo_set_mac_address= eth_mac_addr,
     .ndo_validate_addr	= eth_validate_addr,
 };
@@ -5357,7 +5357,7 @@ de4x5_dbg_rx(struct sk_buff *skb, int len)
 ** this function is only used for my testing.
 */
 static int
-de4x5_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+de4x5_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
 {
     struct de4x5_private *lp = netdev_priv(dev);
     struct de4x5_ioctl *ioc = (struct de4x5_ioctl *) &rq->ifr_ifru;
@@ -5371,6 +5371,9 @@ de4x5_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
     } tmp;
     u_long flags = 0;
 
+    if (cmd != SIOCDEVPRIVATE || in_compat_syscall())
+	    return -EOPNOTSUPP;
+
     switch(ioc->cmd) {
     case DE4X5_GET_HWADDR:           /* Get the hardware address */
 	ioc->len = ETH_ALEN;
-- 
2.27.0

