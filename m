Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FBD3F700A
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbhHYHDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:24 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:13589 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239175AbhHYHDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:10 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91716478"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:18 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id C001E4202725;
        Wed, 25 Aug 2021 16:02:15 +0900 (JST)
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
Subject: [PATCH net-next 05/13] ravb: Factorise ravb_ring_free function
Date:   Wed, 25 Aug 2021 08:01:46 +0100
Message-Id: <20210825070154.14336-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car uses extended descriptor in RX, whereas RZ/G2L uses normal
descriptor. Factorise ravb_ring_free function so that it can
support later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 47 +++++++++++++++---------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 209e030935aa..7cb30319524a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -980,6 +980,7 @@ struct ravb_ptp {
 };
 
 struct ravb_hw_info {
+	void (*rx_ring_free)(struct net_device *ndev, int q);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 883db1049882..dc388a32496a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -216,31 +216,42 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 	return free_num;
 }
 
+static void ravb_rx_ring_free(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	unsigned int ring_size;
+	unsigned int i;
+
+	if (!priv->rx_ring[q])
+		return;
+
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
+
+		if (!dma_mapping_error(ndev->dev.parent,
+				       le32_to_cpu(desc->dptr)))
+			dma_unmap_single(ndev->dev.parent,
+					 le32_to_cpu(desc->dptr),
+					 RX_BUF_SZ,
+					 DMA_FROM_DEVICE);
+	}
+	ring_size = sizeof(struct ravb_ex_rx_desc) *
+		    (priv->num_rx_ring[q] + 1);
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
+			  priv->rx_desc_dma[q]);
+	priv->rx_ring[q] = NULL;
+}
+
 /* Free skb's and DMA buffers for Ethernet AVB */
 static void ravb_ring_free(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	unsigned int num_tx_desc = priv->num_tx_desc;
 	unsigned int ring_size;
 	unsigned int i;
 
-	if (priv->rx_ring[q]) {
-		for (i = 0; i < priv->num_rx_ring[q]; i++) {
-			struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
-
-			if (!dma_mapping_error(ndev->dev.parent,
-					       le32_to_cpu(desc->dptr)))
-				dma_unmap_single(ndev->dev.parent,
-						 le32_to_cpu(desc->dptr),
-						 RX_BUF_SZ,
-						 DMA_FROM_DEVICE);
-		}
-		ring_size = sizeof(struct ravb_ex_rx_desc) *
-			    (priv->num_rx_ring[q] + 1);
-		dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
-				  priv->rx_desc_dma[q]);
-		priv->rx_ring[q] = NULL;
-	}
+	info->rx_ring_free(ndev, q);
 
 	if (priv->tx_ring[q]) {
 		ravb_tx_free(ndev, q, false);
@@ -1937,6 +1948,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 }
 
 static const struct ravb_hw_info ravb_gen3_hw_info = {
+	.rx_ring_free = ravb_rx_ring_free,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -1950,6 +1962,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
+	.rx_ring_free = ravb_rx_ring_free,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

