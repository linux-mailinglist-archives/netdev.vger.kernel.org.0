Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F243D2560
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhGVNeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:19 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:54735 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232332AbhGVNeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:00 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414752"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:15 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id D78C9401224A;
        Thu, 22 Jul 2021 23:14:11 +0900 (JST)
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
Subject: [PATCH net-next 05/18] ravb: Replace chip type with a structure for driver data
Date:   Thu, 22 Jul 2021 15:13:38 +0100
Message-Id: <20210722141351.13668-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to
Ethernet AVB. With few changes in driver we can support both the IP.

This patch is in preparation for supporting the same by replacing chip
type by a structure with values, feature bits and function pointers.

Currently only values is added to structure and later patches will add
features and function pointers.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 14 +++++
 drivers/net/ethernet/renesas/ravb_main.c | 76 +++++++++++++++++-------
 2 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 80e62ca2e3d3..0ed21262f26b 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -988,6 +988,18 @@ enum ravb_chip_id {
 	RCAR_GEN3,
 };
 
+struct ravb_drv_data {
+	netdev_features_t net_features;
+	netdev_features_t net_hw_features;
+	const char (*gstrings_stats)[ETH_GSTRING_LEN];
+	size_t gstrings_size;
+	size_t stats_len;
+	u32 num_gstat_queue;
+	size_t skb_sz;
+	u8 num_tx_desc;
+	enum ravb_chip_id chip_id;
+};
+
 struct ravb_private {
 	struct net_device *ndev;
 	struct platform_device *pdev;
@@ -1040,6 +1052,8 @@ struct ravb_private {
 	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	int num_tx_desc;		/* TX descriptors per packet */
+
+	const struct ravb_drv_data *info;
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 805397088850..84ebd6fef711 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -339,6 +339,7 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 static int ravb_ring_init(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int num_tx_desc = priv->num_tx_desc;
 	struct sk_buff *skb;
 	int ring_size;
@@ -353,7 +354,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 		goto error;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		skb = netdev_alloc_skb(ndev, RX_BUF_SZ + RAVB_ALIGN - 1);
+		skb = netdev_alloc_skb(ndev, info->skb_sz);
 		if (!skb)
 			goto error;
 		ravb_set_buffer_align(skb);
@@ -1133,13 +1134,14 @@ static const char ravb_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"rx_queue_1_over_errors",
 };
 
-#define RAVB_STATS_LEN	ARRAY_SIZE(ravb_gstrings_stats)
-
 static int ravb_get_sset_count(struct net_device *netdev, int sset)
 {
+	struct ravb_private *priv = netdev_priv(netdev);
+	const struct ravb_drv_data *info = priv->info;
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return RAVB_STATS_LEN;
+		return info->stats_len;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1149,11 +1151,12 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 				   struct ethtool_stats *estats, u64 *data)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int i = 0;
 	int q;
 
 	/* Device-specific stats */
-	for (q = RAVB_BE; q < NUM_RX_QUEUE; q++) {
+	for (q = RAVB_BE; q < info->num_gstat_queue; q++) {
 		struct net_device_stats *stats = &priv->stats[q];
 
 		data[i++] = priv->cur_rx[q];
@@ -1176,9 +1179,12 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 
 static void ravb_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
+
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, ravb_gstrings_stats, sizeof(ravb_gstrings_stats));
+		memcpy(data, info->gstrings_stats, info->gstrings_size);
 		break;
 	}
 }
@@ -1924,12 +1930,36 @@ static int ravb_mdio_release(struct ravb_private *priv)
 	return 0;
 }
 
+static const struct ravb_drv_data ravb_gen3_data = {
+	.net_features = NETIF_F_RXCSUM,
+	.net_hw_features = NETIF_F_RXCSUM,
+	.gstrings_stats = ravb_gstrings_stats,
+	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
+	.num_gstat_queue = NUM_RX_QUEUE,
+	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
+	.num_tx_desc = NUM_TX_DESC_GEN3,
+	.chip_id = RCAR_GEN3,
+};
+
+static const struct ravb_drv_data ravb_gen2_data = {
+	.net_features = NETIF_F_RXCSUM,
+	.net_hw_features = NETIF_F_RXCSUM,
+	.gstrings_stats = ravb_gstrings_stats,
+	.gstrings_size = sizeof(ravb_gstrings_stats),
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
+	.num_gstat_queue = NUM_RX_QUEUE,
+	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
+	.num_tx_desc = NUM_TX_DESC_GEN2,
+	.chip_id = RCAR_GEN2,
+};
+
 static const struct of_device_id ravb_match_table[] = {
-	{ .compatible = "renesas,etheravb-r8a7790", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,etheravb-r8a7794", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,etheravb-rcar-gen2", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,etheravb-r8a7795", .data = (void *)RCAR_GEN3 },
-	{ .compatible = "renesas,etheravb-rcar-gen3", .data = (void *)RCAR_GEN3 },
+	{ .compatible = "renesas,etheravb-r8a7790", .data = &ravb_gen2_data },
+	{ .compatible = "renesas,etheravb-r8a7794", .data = &ravb_gen2_data },
+	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_data },
+	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_data },
+	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);
@@ -2034,8 +2064,8 @@ static void ravb_set_delay_mode(struct net_device *ndev)
 static int ravb_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	const struct ravb_drv_data *info;
 	struct ravb_private *priv;
-	enum ravb_chip_id chip_id;
 	struct net_device *ndev;
 	int error, irq, q;
 	struct resource *res;
@@ -2052,15 +2082,15 @@ static int ravb_probe(struct platform_device *pdev)
 	if (!ndev)
 		return -ENOMEM;
 
-	ndev->features = NETIF_F_RXCSUM;
-	ndev->hw_features = NETIF_F_RXCSUM;
+	info = of_device_get_match_data(&pdev->dev);
+
+	ndev->features = info->net_features;
+	ndev->hw_features = info->net_hw_features;
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
-
-	if (chip_id == RCAR_GEN3)
+	if (info->chip_id == RCAR_GEN3)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
 		irq = platform_get_irq(pdev, 0);
@@ -2073,6 +2103,7 @@ static int ravb_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	priv = netdev_priv(ndev);
+	priv->info = info;
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
@@ -2099,7 +2130,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->avb_link_active_low =
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
-	if (chip_id == RCAR_GEN3) {
+	if (info->chip_id == RCAR_GEN3) {
 		irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
@@ -2124,7 +2155,7 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->chip_id = chip_id;
+	priv->chip_id = info->chip_id;
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
@@ -2142,8 +2173,7 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-	priv->num_tx_desc = chip_id == RCAR_GEN2 ?
-		NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
+	priv->num_tx_desc = info->num_tx_desc;
 
 	/* Set function */
 	ndev->netdev_ops = &ravb_netdev_ops;
@@ -2184,7 +2214,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (info->chip_id != RCAR_GEN2)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2232,7 +2262,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (info->chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
-- 
2.17.1

