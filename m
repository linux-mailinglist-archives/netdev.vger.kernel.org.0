Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D357842A98D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhJLQid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:38:33 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:43323 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231356AbhJLQid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:38:33 -0400
X-IronPort-AV: E=Sophos;i="5.85,368,1624287600"; 
   d="scan'208";a="96963645"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 13 Oct 2021 01:36:30 +0900
Received: from localhost.localdomain (unknown [10.226.92.46])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 63CB440AA553;
        Wed, 13 Oct 2021 01:36:27 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next v3 03/14] ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
Date:   Tue, 12 Oct 2021 17:36:02 +0100
Message-Id: <20211012163613.30030-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fillup ravb_alloc_rx_desc_gbeth() function to support RZ/G2L.

This patch also renames ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
to be consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v2->v3:
 * No change
V1->v2:
 * No change
RFC->V1:
 * No Change. Added Sergey's Rb tag
RFC:
 * started allocating 1 rx queue for "gbeth_rx_ring"
 * Moved gbeth_rx_ring near to rx_ring in priv structure
 * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 30 ++++++++++++++++++------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index b147c4a0dc0b..ed771ead61b9 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1038,6 +1038,7 @@ struct ravb_private {
 	struct ravb_desc *desc_bat;
 	dma_addr_t rx_desc_dma[NUM_RX_QUEUE];
 	dma_addr_t tx_desc_dma[NUM_TX_QUEUE];
+	struct ravb_rx_desc *gbeth_rx_ring;
 	struct ravb_ex_rx_desc *rx_ring[NUM_RX_QUEUE];
 	struct ravb_tx_desc *tx_ring[NUM_TX_QUEUE];
 	void *tx_align[NUM_TX_QUEUE];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index fe3449fb4135..c6bab0dfd3bc 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -385,11 +385,18 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 
 static void *ravb_alloc_rx_desc_gbeth(struct net_device *ndev, int q)
 {
-	/* Place holder */
-	return NULL;
+	struct ravb_private *priv = netdev_priv(ndev);
+	unsigned int ring_size;
+
+	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
+
+	priv->gbeth_rx_ring = dma_alloc_coherent(ndev->dev.parent, ring_size,
+						 &priv->rx_desc_dma[q],
+						 GFP_KERNEL);
+	return priv->gbeth_rx_ring;
 }
 
-static void *ravb_alloc_rx_desc(struct net_device *ndev, int q)
+static void *ravb_alloc_rx_desc_rcar(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	unsigned int ring_size;
@@ -1084,16 +1091,25 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = napi->dev;
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
+	bool gptp = info->gptp || info->ccc_gac;
+	struct ravb_rx_desc *desc;
 	unsigned long flags;
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
+	unsigned int entry;
 
+	if (!gptp) {
+		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->gbeth_rx_ring[entry];
+	}
 	/* Processing RX Descriptor Ring */
 	/* Clear RX interrupt */
 	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-	if (ravb_rx(ndev, &quota, q))
-		goto out;
+	if (gptp || desc->die_dt != DT_FEMPTY) {
+		if (ravb_rx(ndev, &quota, q))
+			goto out;
+	}
 
 	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -2175,7 +2191,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
 static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free,
 	.rx_ring_format = ravb_rx_ring_format,
-	.alloc_rx_desc = ravb_alloc_rx_desc,
+	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
@@ -2200,7 +2216,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_free = ravb_rx_ring_free,
 	.rx_ring_format = ravb_rx_ring_format,
-	.alloc_rx_desc = ravb_alloc_rx_desc,
+	.alloc_rx_desc = ravb_alloc_rx_desc_rcar,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate_rcar,
 	.set_feature = ravb_set_features_rcar,
-- 
2.17.1

