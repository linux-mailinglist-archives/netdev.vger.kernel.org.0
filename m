Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6913AB02B
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbhFQJv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:26 -0400
Received: from first.geanix.com ([116.203.34.67]:41892 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231845AbhFQJvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:25 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id A788A4C325D;
        Thu, 17 Jun 2021 09:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923355; bh=IoCXtXJsUbap8V+xD8LLq4yWJQOOPHd9bY+uNZyTmtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=h92R3X3MIoTX+PyZqVzLxvBcdkD9GKH6GJ7/sHPVE04LX2p90vqLAiUUgbpMqI2Yl
         YrdTQVDr25wqG+xiaAVpB6tD28va4qsT2RQF3XKq1uAau3JOuCcem60SynoZc/dLse
         mxXn2PDauo1QI30FVclAO7RkLgNuUBpKuY2Phr9M66a2/M/xRJjDy3eINUD6x1WuLi
         znjGB5DCELW7KQNvDX/P0Fi1tWubgX/wXVpGYaZg/z8S6KJURSvE29/HAHQ2i1D9h1
         qp7djyr0eawQLGYXQguaVs/iwuTd9OjkZE5P+Htj1GmJSJQuC4XR3Z7ZhbTy0r4eSi
         JV0S4PNlBR2Wg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/6] net: gianfar: Convert to ndo_get_stats64 interface
Date:   Thu, 17 Jun 2021 11:49:15 +0200
Message-Id: <f719751ac96a1b64c1d9cf5d3e5e40f91995e1df.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
References: <cover.1623922686.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No reason to produce the legacy net_device_stats struct, only to have it
converted to rtnl_link_stats64.  And as a bonus, this allows for improving
counter size to 64 bit.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 25 +++++++-----------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index f2945abdb041..a0277fe8cc60 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -274,32 +274,21 @@ static void gfar_configure_coalescing_all(struct gfar_private *priv)
 	gfar_configure_coalescing(priv, 0xFF, 0xFF);
 }
 
-static struct net_device_stats *gfar_get_stats(struct net_device *dev)
+static void gfar_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct gfar_private *priv = netdev_priv(dev);
-	unsigned long rx_packets = 0, rx_bytes = 0, rx_dropped = 0;
-	unsigned long tx_packets = 0, tx_bytes = 0;
 	int i;
 
 	for (i = 0; i < priv->num_rx_queues; i++) {
-		rx_packets += priv->rx_queue[i]->stats.rx_packets;
-		rx_bytes   += priv->rx_queue[i]->stats.rx_bytes;
-		rx_dropped += priv->rx_queue[i]->stats.rx_dropped;
+		stats->rx_packets += priv->rx_queue[i]->stats.rx_packets;
+		stats->rx_bytes   += priv->rx_queue[i]->stats.rx_bytes;
+		stats->rx_dropped += priv->rx_queue[i]->stats.rx_dropped;
 	}
 
-	dev->stats.rx_packets = rx_packets;
-	dev->stats.rx_bytes   = rx_bytes;
-	dev->stats.rx_dropped = rx_dropped;
-
 	for (i = 0; i < priv->num_tx_queues; i++) {
-		tx_bytes += priv->tx_queue[i]->stats.tx_bytes;
-		tx_packets += priv->tx_queue[i]->stats.tx_packets;
+		stats->tx_bytes += priv->tx_queue[i]->stats.tx_bytes;
+		stats->tx_packets += priv->tx_queue[i]->stats.tx_packets;
 	}
-
-	dev->stats.tx_bytes   = tx_bytes;
-	dev->stats.tx_packets = tx_packets;
-
-	return &dev->stats;
 }
 
 /* Set the appropriate hash bit for the given addr */
@@ -3157,7 +3146,7 @@ static const struct net_device_ops gfar_netdev_ops = {
 	.ndo_set_rx_mode = gfar_set_multi,
 	.ndo_tx_timeout = gfar_timeout,
 	.ndo_do_ioctl = gfar_ioctl,
-	.ndo_get_stats = gfar_get_stats,
+	.ndo_get_stats64 = gfar_get_stats64,
 	.ndo_change_carrier = fixed_phy_change_carrier,
 	.ndo_set_mac_address = gfar_set_mac_addr,
 	.ndo_validate_addr = eth_validate_addr,
-- 
2.32.0

