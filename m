Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B886C2FB
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbfGQWFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:05:36 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:55064 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727606AbfGQWFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:05:35 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2019 18:05:34 EDT
Received: from nis-sj1-27.broadcom.com (nis-sj1-27.lvn.broadcom.net [10.75.144.136])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id C9E1A30C31D;
        Wed, 17 Jul 2019 14:59:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com C9E1A30C31D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1563400746;
        bh=dh0eGGXwADQ+KWKDA7NpayuoFELiQe1yMV4qNMkG3vs=;
        h=From:To:Cc:Subject:Date:From;
        b=miMGdUdzbxEvLlSwMJillD8uKUi4US+WN+Fb6GDLTgWOm3XgVWYzP/dSVMXhMEF+0
         Zm/7S3c69w1sPJ20XiopjeyT2rLpzAYGy2Av4PQi+XH1UPko638W1PYMRw9pvLEhb8
         N8RNTcVgs5qCUO4eFBeTvEnBuWA7RhA2vOxNXNFA=
Received: from stbirv-lnx-2.igp.broadcom.net (stbirv-lnx-2.igp.broadcom.net [10.67.48.34])
        by nis-sj1-27.broadcom.com (Postfix) with ESMTP id 710CFAC0761;
        Wed, 17 Jul 2019 14:59:07 -0700 (PDT)
Received: by stbirv-lnx-2.igp.broadcom.net (Postfix, from userid 47169)
        id 5C0E927FA27; Wed, 17 Jul 2019 14:59:07 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        f.fainelli@gmail.com, opendmb@gmail.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH] net: bcmgenet: use promisc for unsupported filters
Date:   Wed, 17 Jul 2019 14:58:53 -0700
Message-Id: <1563400733-39451-1-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

Currently we silently ignore filters if we cannot meet the filter
requirements. This will lead to the MAC dropping packets that are
expected to pass. A better solution would be to set the NIC to promisc
mode when the required filters cannot be met.

Also correct the number of MDF filters supported. It should be 17,
not 16.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 57 ++++++++++++--------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 34466b8..a2b5780 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3083,39 +3083,42 @@ static void bcmgenet_timeout(struct net_device *dev)
 	netif_tx_wake_all_queues(dev);
 }
 
-#define MAX_MC_COUNT	16
+#define MAX_MDF_FILTER	17
 
 static inline void bcmgenet_set_mdf_addr(struct bcmgenet_priv *priv,
 					 unsigned char *addr,
-					 int *i,
-					 int *mc)
+					 int *i)
 {
-	u32 reg;
-
 	bcmgenet_umac_writel(priv, addr[0] << 8 | addr[1],
 			     UMAC_MDF_ADDR + (*i * 4));
 	bcmgenet_umac_writel(priv, addr[2] << 24 | addr[3] << 16 |
 			     addr[4] << 8 | addr[5],
 			     UMAC_MDF_ADDR + ((*i + 1) * 4));
-	reg = bcmgenet_umac_readl(priv, UMAC_MDF_CTRL);
-	reg |= (1 << (MAX_MC_COUNT - *mc));
-	bcmgenet_umac_writel(priv, reg, UMAC_MDF_CTRL);
 	*i += 2;
-	(*mc)++;
 }
 
 static void bcmgenet_set_rx_mode(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct netdev_hw_addr *ha;
-	int i, mc;
+	int i, nfilter;
 	u32 reg;
 
 	netif_dbg(priv, hw, dev, "%s: %08X\n", __func__, dev->flags);
 
-	/* Promiscuous mode */
+	/* Number of filters needed */
+	nfilter = netdev_uc_count(dev) + netdev_mc_count(dev) + 2;
+
+	/*
+	 * Turn on promicuous mode for three scenarios
+	 * 1. IFF_PROMISC flag is set
+	 * 2. IFF_ALLMULTI flag is set
+	 * 3. The number of filters needed exceeds the number filters
+	 *    supported by the hardware.
+	*/
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
-	if (dev->flags & IFF_PROMISC) {
+	if ((dev->flags & (IFF_PROMISC | IFF_ALLMULTI)) ||
+	    (nfilter > MAX_MDF_FILTER)) {
 		reg |= CMD_PROMISC;
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 		bcmgenet_umac_writel(priv, 0, UMAC_MDF_CTRL);
@@ -3125,32 +3128,24 @@ static void bcmgenet_set_rx_mode(struct net_device *dev)
 		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
 	}
 
-	/* UniMac doesn't support ALLMULTI */
-	if (dev->flags & IFF_ALLMULTI) {
-		netdev_warn(dev, "ALLMULTI is not supported\n");
-		return;
-	}
-
 	/* update MDF filter */
 	i = 0;
-	mc = 0;
 	/* Broadcast */
-	bcmgenet_set_mdf_addr(priv, dev->broadcast, &i, &mc);
+	bcmgenet_set_mdf_addr(priv, dev->broadcast, &i);
 	/* my own address.*/
-	bcmgenet_set_mdf_addr(priv, dev->dev_addr, &i, &mc);
-	/* Unicast list*/
-	if (netdev_uc_count(dev) > (MAX_MC_COUNT - mc))
-		return;
+	bcmgenet_set_mdf_addr(priv, dev->dev_addr, &i);
 
-	if (!netdev_uc_empty(dev))
-		netdev_for_each_uc_addr(ha, dev)
-			bcmgenet_set_mdf_addr(priv, ha->addr, &i, &mc);
-	/* Multicast */
-	if (netdev_mc_empty(dev) || netdev_mc_count(dev) >= (MAX_MC_COUNT - mc))
-		return;
+	/* Unicast */
+	netdev_for_each_uc_addr(ha, dev)
+		bcmgenet_set_mdf_addr(priv, ha->addr, &i);
 
+	/* Multicast */
 	netdev_for_each_mc_addr(ha, dev)
-		bcmgenet_set_mdf_addr(priv, ha->addr, &i, &mc);
+		bcmgenet_set_mdf_addr(priv, ha->addr, &i);
+
+	/* Enable filters */
+	reg = GENMASK(MAX_MDF_FILTER - 1, MAX_MDF_FILTER - nfilter);
+	bcmgenet_umac_writel(priv, reg, UMAC_MDF_CTRL);
 }
 
 /* Set the hardware MAC address. */
-- 
2.7.4

