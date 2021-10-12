Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF18642A99F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhJLQjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:39:04 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:4059 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231586AbhJLQjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:39:03 -0400
X-IronPort-AV: E=Sophos;i="5.85,368,1624287600"; 
   d="scan'208";a="96963688"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 13 Oct 2021 01:37:01 +0900
Received: from localhost.localdomain (unknown [10.226.92.46])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id D48A140AA558;
        Wed, 13 Oct 2021 01:36:57 +0900 (JST)
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
Subject: [PATCH net-next v3 11/14] ravb: Rename "nc_queue" feature bit
Date:   Tue, 12 Oct 2021 17:36:10 +0100
Message-Id: <20211012163613.30030-12-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the feature bit "nc_queue" with "nc_queues" as AVB DMAC has
RX and TX NC queues.

There is no functional change.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
v2->v3:
 * Added Sergey's Rb tag.
v1->v2:
 * No change
v1:
 * New patch.
---
 drivers/net/ethernet/renesas/ravb.h      |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 36 ++++++++++++------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 99d666a5fb49..5d07732ef35a 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1023,7 +1023,7 @@ struct ravb_hw_info {
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
-	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
+	unsigned nc_queues:1;		/* AVB-DMAC has RX and TX NC queues */
 	unsigned magic_pkt:1;		/* E-MAC supports magic packet detection */
 	unsigned half_duplex:1;		/* E-MAC supports half duplex mode */
 };
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 95ce92eff7eb..21fb83f209d5 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1176,7 +1176,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 			result = IRQ_HANDLED;
 
 		/* Network control and best effort queue RX/TX */
-		if (info->nc_queue) {
+		if (info->nc_queues) {
 			for (q = RAVB_NC; q >= RAVB_BE; q--) {
 				if (ravb_queue_interrupt(ndev, q))
 					result = IRQ_HANDLED;
@@ -1315,7 +1315,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 
 	/* Receive error message handling */
 	priv->rx_over_errors =  priv->stats[RAVB_BE].rx_over_errors;
-	if (info->nc_queue)
+	if (info->nc_queues)
 		priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
 	if (priv->rx_over_errors != ndev->stats.rx_over_errors)
 		ndev->stats.rx_over_errors = priv->rx_over_errors;
@@ -1566,7 +1566,7 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 	int i = 0;
 	int q;
 
-	num_rx_q = info->nc_queue ? NUM_RX_QUEUE : 1;
+	num_rx_q = info->nc_queues ? NUM_RX_QUEUE : 1;
 	/* Device-specific stats */
 	for (q = RAVB_BE; q < num_rx_q; q++) {
 		struct net_device_stats *stats = &priv->stats[q];
@@ -1643,7 +1643,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 
 		/* Free all the skb's in the RX queue and the DMA buffers. */
 		ravb_ring_free(ndev, RAVB_BE);
-		if (info->nc_queue)
+		if (info->nc_queues)
 			ravb_ring_free(ndev, RAVB_NC);
 	}
 
@@ -1763,7 +1763,7 @@ static int ravb_open(struct net_device *ndev)
 	int error;
 
 	napi_enable(&priv->napi[RAVB_BE]);
-	if (info->nc_queue)
+	if (info->nc_queues)
 		napi_enable(&priv->napi[RAVB_NC]);
 
 	if (!info->multi_irqs) {
@@ -1838,7 +1838,7 @@ static int ravb_open(struct net_device *ndev)
 out_free_irq:
 	free_irq(ndev->irq, ndev);
 out_napi_off:
-	if (info->nc_queue)
+	if (info->nc_queues)
 		napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
 	return error;
@@ -1888,7 +1888,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	}
 
 	ravb_ring_free(ndev, RAVB_BE);
-	if (info->nc_queue)
+	if (info->nc_queues)
 		ravb_ring_free(ndev, RAVB_NC);
 
 	/* Device init */
@@ -2088,7 +2088,7 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 	nstats->rx_length_errors = stats0->rx_length_errors;
 	nstats->rx_missed_errors = stats0->rx_missed_errors;
 	nstats->rx_over_errors = stats0->rx_over_errors;
-	if (info->nc_queue) {
+	if (info->nc_queues) {
 		stats1 = &priv->stats[RAVB_NC];
 
 		nstats->rx_packets += stats1->rx_packets;
@@ -2169,13 +2169,13 @@ static int ravb_close(struct net_device *ndev)
 	}
 	free_irq(ndev->irq, ndev);
 
-	if (info->nc_queue)
+	if (info->nc_queues)
 		napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
 
 	/* Free all the skb's in the RX queue and the DMA buffers. */
 	ravb_ring_free(ndev, RAVB_BE);
-	if (info->nc_queue)
+	if (info->nc_queues)
 		ravb_ring_free(ndev, RAVB_NC);
 
 	return 0;
@@ -2415,7 +2415,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.tx_counters = 1,
 	.multi_irqs = 1,
 	.ccc_gac = 1,
-	.nc_queue = 1,
+	.nc_queues = 1,
 	.magic_pkt = 1,
 };
 
@@ -2438,7 +2438,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_max_buf_size = SZ_2K,
 	.aligned_tx = 1,
 	.gptp = 1,
-	.nc_queue = 1,
+	.nc_queues = 1,
 	.magic_pkt = 1,
 };
 
@@ -2618,7 +2618,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
 	priv->num_rx_ring[RAVB_BE] = BE_RX_RING_SIZE;
-	if (info->nc_queue) {
+	if (info->nc_queues) {
 		priv->num_tx_ring[RAVB_NC] = NC_TX_RING_SIZE;
 		priv->num_rx_ring[RAVB_NC] = NC_RX_RING_SIZE;
 	}
@@ -2754,7 +2754,7 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 
 	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
-	if (info->nc_queue)
+	if (info->nc_queues)
 		netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
 
 	/* Network device register */
@@ -2773,7 +2773,7 @@ static int ravb_probe(struct platform_device *pdev)
 	return 0;
 
 out_napi_del:
-	if (info->nc_queue)
+	if (info->nc_queues)
 		netif_napi_del(&priv->napi[RAVB_NC]);
 
 	netif_napi_del(&priv->napi[RAVB_BE]);
@@ -2814,7 +2814,7 @@ static int ravb_remove(struct platform_device *pdev)
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
 	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
-	if (info->nc_queue)
+	if (info->nc_queues)
 		netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
@@ -2838,7 +2838,7 @@ static int ravb_wol_setup(struct net_device *ndev)
 
 	/* Only allow ECI interrupts */
 	synchronize_irq(priv->emac_irq);
-	if (info->nc_queue)
+	if (info->nc_queues)
 		napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
 	ravb_write(ndev, ECSIPR_MPDIP, ECSIPR);
@@ -2855,7 +2855,7 @@ static int ravb_wol_restore(struct net_device *ndev)
 	const struct ravb_hw_info *info = priv->info;
 	int ret;
 
-	if (info->nc_queue)
+	if (info->nc_queues)
 		napi_enable(&priv->napi[RAVB_NC]);
 	napi_enable(&priv->napi[RAVB_BE]);
 
-- 
2.17.1

