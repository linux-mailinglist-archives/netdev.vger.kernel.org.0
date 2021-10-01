Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BA841F086
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354984AbhJAPIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:46 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:2731 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354913AbhJAPIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:38 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95671596"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 02 Oct 2021 00:06:53 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 440CE4351834;
        Sat,  2 Oct 2021 00:06:50 +0900 (JST)
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
Subject: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
Date:   Fri,  1 Oct 2021 16:06:29 +0100
Message-Id: <20211001150636.7500-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car supports network control queue whereas RZ/G2L does not support
it. Add nc_queue to struct ravb_hw_info, so that NC queue is handled
only by R-Car.

This patch also renames ravb_rcar_dmac_init to ravb_dmac_init_rcar
to be consistent with the naming convention used in sh_eth driver.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
RFC->v1:
 * Handled NC queue only for R-Car.
---
 drivers/net/ethernet/renesas/ravb.h      |   3 +-
 drivers/net/ethernet/renesas/ravb_main.c | 140 +++++++++++++++--------
 2 files changed, 94 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index a33fbcb4aac3..c91e93e5590f 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -986,7 +986,7 @@ struct ravb_hw_info {
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
 	void (*set_rate)(struct net_device *ndev);
 	int (*set_feature)(struct net_device *ndev, netdev_features_t features);
-	void (*dmac_init)(struct net_device *ndev);
+	int (*dmac_init)(struct net_device *ndev);
 	void (*emac_init)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
@@ -1002,6 +1002,7 @@ struct ravb_hw_info {
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
 	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
+	unsigned nc_queue:1;		/* AVB-DMAC has NC queue */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index dc7654abfe55..8bf13586e90a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -461,10 +461,24 @@ static void ravb_emac_init(struct net_device *ndev)
 	info->emac_init(ndev);
 }
 
-static void ravb_rcar_dmac_init(struct net_device *ndev)
+static int ravb_dmac_init_rcar(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
+	int error;
+
+	error = ravb_ring_init(ndev, RAVB_BE);
+	if (error)
+		return error;
+	error = ravb_ring_init(ndev, RAVB_NC);
+	if (error) {
+		ravb_ring_free(ndev, RAVB_BE);
+		return error;
+	}
+
+	/* Descriptor format */
+	ravb_ring_format(ndev, RAVB_BE);
+	ravb_ring_format(ndev, RAVB_NC);
 
 	/* Set AVB RX */
 	ravb_write(ndev,
@@ -491,6 +505,8 @@ static void ravb_rcar_dmac_init(struct net_device *ndev)
 	ravb_write(ndev, RIC2_QFE0 | RIC2_QFE1 | RIC2_RFFE, RIC2);
 	/* Frame transmitted, timestamp FIFO updated */
 	ravb_write(ndev, TIC_FTE0 | TIC_FTE1 | TIC_TFUE, TIC);
+
+	return 0;
 }
 
 /* Device init function for Ethernet AVB */
@@ -505,20 +521,9 @@ static int ravb_dmac_init(struct net_device *ndev)
 	if (error)
 		return error;
 
-	error = ravb_ring_init(ndev, RAVB_BE);
+	error = info->dmac_init(ndev);
 	if (error)
 		return error;
-	error = ravb_ring_init(ndev, RAVB_NC);
-	if (error) {
-		ravb_ring_free(ndev, RAVB_BE);
-		return error;
-	}
-
-	/* Descriptor format */
-	ravb_ring_format(ndev, RAVB_BE);
-	ravb_ring_format(ndev, RAVB_NC);
-
-	info->dmac_init(ndev);
 
 	/* Setting the control will start the AVB-DMAC process. */
 	ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_OPERATION);
@@ -859,6 +864,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev = dev_id;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	irqreturn_t result = IRQ_NONE;
 	u32 iss;
 
@@ -875,8 +881,13 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 			result = IRQ_HANDLED;
 
 		/* Network control and best effort queue RX/TX */
-		for (q = RAVB_NC; q >= RAVB_BE; q--) {
-			if (ravb_queue_interrupt(ndev, q))
+		if (info->nc_queue) {
+			for (q = RAVB_NC; q >= RAVB_BE; q--) {
+				if (ravb_queue_interrupt(ndev, q))
+					result = IRQ_HANDLED;
+			}
+		} else {
+			if (ravb_queue_interrupt(ndev, RAVB_BE))
 				result = IRQ_HANDLED;
 		}
 	}
@@ -1000,7 +1011,8 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 
 	/* Receive error message handling */
 	priv->rx_over_errors =  priv->stats[RAVB_BE].rx_over_errors;
-	priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
+	if (info->nc_queue)
+		priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
 	if (priv->rx_over_errors != ndev->stats.rx_over_errors)
 		ndev->stats.rx_over_errors = priv->rx_over_errors;
 	if (priv->rx_fifo_errors != ndev->stats.rx_fifo_errors)
@@ -1208,11 +1220,14 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 				   struct ethtool_stats *estats, u64 *data)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
+	int num_rx_q;
 	int i = 0;
 	int q;
 
+	num_rx_q = info->nc_queue ? NUM_RX_QUEUE : 1;
 	/* Device-specific stats */
-	for (q = RAVB_BE; q < NUM_RX_QUEUE; q++) {
+	for (q = RAVB_BE; q < num_rx_q; q++) {
 		struct net_device_stats *stats = &priv->stats[q];
 
 		data[i++] = priv->cur_rx[q];
@@ -1287,7 +1302,8 @@ static int ravb_set_ringparam(struct net_device *ndev,
 
 		/* Free all the skb's in the RX queue and the DMA buffers. */
 		ravb_ring_free(ndev, RAVB_BE);
-		ravb_ring_free(ndev, RAVB_NC);
+		if (info->nc_queue)
+			ravb_ring_free(ndev, RAVB_NC);
 	}
 
 	/* Set new parameters */
@@ -1403,7 +1419,8 @@ static int ravb_open(struct net_device *ndev)
 	int error;
 
 	napi_enable(&priv->napi[RAVB_BE]);
-	napi_enable(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		napi_enable(&priv->napi[RAVB_NC]);
 
 	if (!info->multi_irqs) {
 		error = request_irq(ndev->irq, ravb_interrupt, IRQF_SHARED,
@@ -1477,7 +1494,8 @@ static int ravb_open(struct net_device *ndev)
 out_free_irq:
 	free_irq(ndev->irq, ndev);
 out_napi_off:
-	napi_disable(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
 	return error;
 }
@@ -1526,7 +1544,8 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	}
 
 	ravb_ring_free(ndev, RAVB_BE);
-	ravb_ring_free(ndev, RAVB_NC);
+	if (info->nc_queue)
+		ravb_ring_free(ndev, RAVB_NC);
 
 	/* Device init */
 	error = ravb_dmac_init(ndev);
@@ -1698,28 +1717,38 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 
 	nstats = &ndev->stats;
 	stats0 = &priv->stats[RAVB_BE];
-	stats1 = &priv->stats[RAVB_NC];
 
 	if (info->tx_counters) {
 		nstats->tx_dropped += ravb_read(ndev, TROCR);
 		ravb_write(ndev, 0, TROCR);	/* (write clear) */
 	}
 
-	nstats->rx_packets = stats0->rx_packets + stats1->rx_packets;
-	nstats->tx_packets = stats0->tx_packets + stats1->tx_packets;
-	nstats->rx_bytes = stats0->rx_bytes + stats1->rx_bytes;
-	nstats->tx_bytes = stats0->tx_bytes + stats1->tx_bytes;
-	nstats->multicast = stats0->multicast + stats1->multicast;
-	nstats->rx_errors = stats0->rx_errors + stats1->rx_errors;
-	nstats->rx_crc_errors = stats0->rx_crc_errors + stats1->rx_crc_errors;
-	nstats->rx_frame_errors =
-		stats0->rx_frame_errors + stats1->rx_frame_errors;
-	nstats->rx_length_errors =
-		stats0->rx_length_errors + stats1->rx_length_errors;
-	nstats->rx_missed_errors =
-		stats0->rx_missed_errors + stats1->rx_missed_errors;
-	nstats->rx_over_errors =
-		stats0->rx_over_errors + stats1->rx_over_errors;
+	nstats->rx_packets = stats0->rx_packets;
+	nstats->tx_packets = stats0->tx_packets;
+	nstats->rx_bytes = stats0->rx_bytes;
+	nstats->tx_bytes = stats0->tx_bytes;
+	nstats->multicast = stats0->multicast;
+	nstats->rx_errors = stats0->rx_errors;
+	nstats->rx_crc_errors = stats0->rx_crc_errors;
+	nstats->rx_frame_errors = stats0->rx_frame_errors;
+	nstats->rx_length_errors = stats0->rx_length_errors;
+	nstats->rx_missed_errors = stats0->rx_missed_errors;
+	nstats->rx_over_errors = stats0->rx_over_errors;
+	if (info->nc_queue) {
+		stats1 = &priv->stats[RAVB_NC];
+
+		nstats->rx_packets += stats1->rx_packets;
+		nstats->tx_packets += stats1->tx_packets;
+		nstats->rx_bytes += stats1->rx_bytes;
+		nstats->tx_bytes += stats1->tx_bytes;
+		nstats->multicast += stats1->multicast;
+		nstats->rx_errors += stats1->rx_errors;
+		nstats->rx_crc_errors += stats1->rx_crc_errors;
+		nstats->rx_frame_errors += stats1->rx_frame_errors;
+		nstats->rx_length_errors += stats1->rx_length_errors;
+		nstats->rx_missed_errors += stats1->rx_missed_errors;
+		nstats->rx_over_errors += stats1->rx_over_errors;
+	}
 
 	return nstats;
 }
@@ -1784,12 +1813,14 @@ static int ravb_close(struct net_device *ndev)
 	}
 	free_irq(ndev->irq, ndev);
 
-	napi_disable(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
 
 	/* Free all the skb's in the RX queue and the DMA buffers. */
 	ravb_ring_free(ndev, RAVB_BE);
-	ravb_ring_free(ndev, RAVB_NC);
+	if (info->nc_queue)
+		ravb_ring_free(ndev, RAVB_NC);
 
 	return 0;
 }
@@ -2007,7 +2038,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
 	.set_feature = ravb_set_features_rcar,
-	.dmac_init = ravb_rcar_dmac_init,
+	.dmac_init = ravb_dmac_init_rcar,
 	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
@@ -2019,6 +2050,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.tx_counters = 1,
 	.multi_irqs = 1,
 	.ccc_gac = 1,
+	.nc_queue = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2028,7 +2060,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
 	.set_feature = ravb_set_features_rcar,
-	.dmac_init = ravb_rcar_dmac_init,
+	.dmac_init = ravb_dmac_init_rcar,
 	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
@@ -2038,6 +2070,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
 	.gptp = 1,
+	.nc_queue = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -2192,8 +2225,11 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
 	priv->num_rx_ring[RAVB_BE] = BE_RX_RING_SIZE;
-	priv->num_tx_ring[RAVB_NC] = NC_TX_RING_SIZE;
-	priv->num_rx_ring[RAVB_NC] = NC_RX_RING_SIZE;
+	if (info->nc_queue) {
+		priv->num_tx_ring[RAVB_NC] = NC_TX_RING_SIZE;
+		priv->num_rx_ring[RAVB_NC] = NC_RX_RING_SIZE;
+	}
+
 	priv->addr = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->addr)) {
 		error = PTR_ERR(priv->addr);
@@ -2323,7 +2359,8 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 
 	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
-	netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
+	if (info->nc_queue)
+		netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
 
 	/* Network device register */
 	error = register_netdev(ndev);
@@ -2341,7 +2378,9 @@ static int ravb_probe(struct platform_device *pdev)
 	return 0;
 
 out_napi_del:
-	netif_napi_del(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		netif_napi_del(&priv->napi[RAVB_NC]);
+
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
 out_dma_free:
@@ -2380,7 +2419,8 @@ static int ravb_remove(struct platform_device *pdev)
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
 	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
-	netif_napi_del(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
 	pm_runtime_disable(&pdev->dev);
@@ -2394,6 +2434,7 @@ static int ravb_remove(struct platform_device *pdev)
 static int ravb_wol_setup(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 
 	/* Disable interrupts by clearing the interrupt masks. */
 	ravb_write(ndev, 0, RIC0);
@@ -2402,7 +2443,8 @@ static int ravb_wol_setup(struct net_device *ndev)
 
 	/* Only allow ECI interrupts */
 	synchronize_irq(priv->emac_irq);
-	napi_disable(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
 	ravb_write(ndev, ECSIPR_MPDIP, ECSIPR);
 
@@ -2415,9 +2457,11 @@ static int ravb_wol_setup(struct net_device *ndev)
 static int ravb_wol_restore(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int ret;
 
-	napi_enable(&priv->napi[RAVB_NC]);
+	if (info->nc_queue)
+		napi_enable(&priv->napi[RAVB_NC]);
 	napi_enable(&priv->napi[RAVB_BE]);
 
 	/* Disable MagicPacket */
-- 
2.17.1

