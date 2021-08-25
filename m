Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F48A3F7007
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbhHYHDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:22 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:1587 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239213AbhHYHDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:12 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91716496"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:26 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id EA6674202144;
        Wed, 25 Aug 2021 16:02:22 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH net-next 07/13] ravb: Factorise ravb_ring_init function
Date:   Wed, 25 Aug 2021 08:01:48 +0100
Message-Id: <20210825070154.14336-8-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ravb_ring_init function uses an extended descriptor in RX for
R-Car and normal descriptor for RZ/G2L. Add a helper function
for RX ring buffer allocation to support later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index dbf114d2ceef..39df045b1a0b 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -982,6 +982,7 @@ struct ravb_ptp {
 struct ravb_hw_info {
 	void (*rx_ring_free)(struct net_device *ndev, int q);
 	void (*rx_ring_format)(struct net_device *ndev, int q);
+	void *(*alloc_rx_desc)(struct net_device *ndev, int q);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e52e36ccd1c6..148c974499b4 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -355,6 +355,19 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	desc->dptr = cpu_to_le32((u32)priv->tx_desc_dma[q]);
 }
 
+static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	unsigned int ring_size;
+
+	ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
+
+	priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
+					      &priv->rx_desc_dma[q],
+					      GFP_KERNEL);
+	return priv->rx_ring[q];
+}
+
 /* Init skb and descriptor buffer for Ethernet AVB */
 static int ravb_ring_init(struct net_device *ndev, int q)
 {
@@ -390,11 +403,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	}
 
 	/* Allocate all RX descriptors. */
-	ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
-	priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
-					      &priv->rx_desc_dma[q],
-					      GFP_KERNEL);
-	if (!priv->rx_ring[q])
+	if (!info->alloc_rx_desc(ndev, q))
 		goto error;
 
 	priv->dirty_rx[q] = 0;
@@ -1959,6 +1968,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free,
 	.rx_ring_format = ravb_rx_ring_format,
+	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -1974,6 +1984,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free,
 	.rx_ring_format = ravb_rx_ring_format,
+	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

