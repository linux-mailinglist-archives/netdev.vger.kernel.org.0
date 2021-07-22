Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0A83D2571
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhGVNen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:43 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:24216 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232336AbhGVNeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:00 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414766"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:29 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 81643401224A;
        Thu, 22 Jul 2021 23:14:26 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next 09/18] ravb: Factorise ravb_ring_free function
Date:   Thu, 22 Jul 2021 15:13:42 +0100
Message-Id: <20210722141351.13668-10-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended descriptor support in RX is available for R-Car where as it
is a normal descriptor for RZ/G2L. Factorise ravb_ring_free function
so that it can support later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  5 +++
 drivers/net/ethernet/renesas/ravb_main.c | 49 ++++++++++++++++--------
 2 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index a474ed68db22..3a9cf6e8671a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -988,7 +988,12 @@ enum ravb_chip_id {
 	RCAR_GEN3,
 };
 
+struct ravb_ops {
+	void (*ring_free)(struct net_device *ndev, int q);
+};
+
 struct ravb_drv_data {
+	const struct ravb_ops *ravb_ops;
 	netdev_features_t net_features;
 	netdev_features_t net_hw_features;
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4ef2565534d2..a3b8b243fd54 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -247,30 +247,39 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 }
 
 /* Free skb's and DMA buffers for Ethernet AVB */
-static void ravb_ring_free(struct net_device *ndev, int q)
+static void ravb_ring_free_rx(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_tx_desc = priv->num_tx_desc;
 	int ring_size;
 	int i;
 
-	if (priv->rx_ring[q]) {
-		for (i = 0; i < priv->num_rx_ring[q]; i++) {
-			struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
 
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
+		if (!dma_mapping_error(ndev->dev.parent,
+				       le32_to_cpu(desc->dptr)))
+			dma_unmap_single(ndev->dev.parent,
+					 le32_to_cpu(desc->dptr),
+					 RX_BUF_SZ,
+					 DMA_FROM_DEVICE);
 	}
+	ring_size = sizeof(struct ravb_ex_rx_desc) *
+		    (priv->num_rx_ring[q] + 1);
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
+			  priv->rx_desc_dma[q]);
+	priv->rx_ring[q] = NULL;
+}
+
+static void ravb_ring_free(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
+	int num_tx_desc = priv->num_tx_desc;
+	int ring_size;
+	int i;
+
+	if (priv->rx_ring[q])
+		info->ravb_ops->ring_free(ndev, q);
 
 	if (priv->tx_ring[q]) {
 		ravb_tx_free(ndev, q, false);
@@ -1987,7 +1996,12 @@ static int ravb_mdio_release(struct ravb_private *priv)
 	return 0;
 }
 
+static const struct ravb_ops ravb_gen3_ops = {
+	.ring_free = ravb_ring_free_rx,
+};
+
 static const struct ravb_drv_data ravb_gen3_data = {
+	.ravb_ops = &ravb_gen3_ops,
 	.net_features = NETIF_F_RXCSUM,
 	.net_hw_features = NETIF_F_RXCSUM,
 	.gstrings_stats = ravb_gstrings_stats,
@@ -2001,6 +2015,7 @@ static const struct ravb_drv_data ravb_gen3_data = {
 };
 
 static const struct ravb_drv_data ravb_gen2_data = {
+	.ravb_ops = &ravb_gen3_ops,
 	.net_features = NETIF_F_RXCSUM,
 	.net_hw_features = NETIF_F_RXCSUM,
 	.gstrings_stats = ravb_gstrings_stats,
-- 
2.17.1

