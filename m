Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE85C3D255E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhGVNeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:13 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:32869 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232105AbhGVNdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:33:44 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88463942"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:18 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 7931A401224A;
        Thu, 22 Jul 2021 23:14:15 +0900 (JST)
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
Subject: [PATCH net-next 06/18] ravb: Factorise ptp feature
Date:   Thu, 22 Jul 2021 15:13:39 +0100
Message-Id: <20210722141351.13668-7-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gptp is active in CONFIG mode for R-Car Gen3, where as it is not
active in CONFIG mode for R-Car Gen2. Add feature bits to handle
both cases.

RZ/G2L does not support ptp feature. Factorise ptp feature
specific to R-Car.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 81 ++++++++++++++++--------
 2 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 0ed21262f26b..a474ed68db22 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -998,6 +998,7 @@ struct ravb_drv_data {
 	size_t skb_sz;
 	u8 num_tx_desc;
 	enum ravb_chip_id chip_id;
+	u32 features;
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 84ebd6fef711..e966b76df32c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -40,6 +40,14 @@
 		 NETIF_MSG_RX_ERR | \
 		 NETIF_MSG_TX_ERR)
 
+#define RAVB_PTP_CONFIG_ACTIVE		BIT(0)
+#define RAVB_PTP_CONFIG_INACTIVE	BIT(1)
+
+#define RAVB_PTP	(RAVB_PTP_CONFIG_ACTIVE | RAVB_PTP_CONFIG_INACTIVE)
+
+#define RAVB_RCAR_GEN3_FEATURES	RAVB_PTP_CONFIG_ACTIVE
+#define RAVB_RCAR_GEN2_FEATURES	RAVB_PTP_CONFIG_INACTIVE
+
 static const char *ravb_rx_irqs[NUM_RX_QUEUE] = {
 	"ch0", /* RAVB_BE */
 	"ch1", /* RAVB_NC */
@@ -804,6 +812,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev = dev_id;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	irqreturn_t result = IRQ_NONE;
 	u32 iss;
 
@@ -839,7 +848,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 	}
 
 	/* gPTP interrupt status summary */
-	if (iss & ISS_CGIS) {
+	if ((info->features & RAVB_PTP) && (iss & ISS_CGIS)) {
 		ravb_ptp_interrupt(ndev);
 		result = IRQ_HANDLED;
 	}
@@ -1204,6 +1213,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 			      struct ethtool_ringparam *ring)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int error;
 
 	if (ring->tx_pending > BE_TX_RING_MAX ||
@@ -1217,7 +1227,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		netif_device_detach(ndev);
 		/* Stop PTP Clock driver */
-		if (priv->chip_id == RCAR_GEN2)
+		if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 			ravb_ptp_stop(ndev);
 		/* Wait for DMA stopping */
 		error = ravb_stop_dma(ndev);
@@ -1249,7 +1259,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 		ravb_emac_init(ndev);
 
 		/* Initialise PTP Clock driver */
-		if (priv->chip_id == RCAR_GEN2)
+		if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 			ravb_ptp_init(ndev, priv->pdev);
 
 		netif_device_attach(ndev);
@@ -1262,6 +1272,7 @@ static int ravb_get_ts_info(struct net_device *ndev,
 			    struct ethtool_ts_info *info)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *data = priv->info;
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_SOFTWARE |
@@ -1275,7 +1286,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
 		(1 << HWTSTAMP_FILTER_NONE) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 		(1 << HWTSTAMP_FILTER_ALL);
-	info->phc_index = ptp_clock_index(priv->ptp.clock);
+	if (data->features & RAVB_PTP)
+		info->phc_index = ptp_clock_index(priv->ptp.clock);
 
 	return 0;
 }
@@ -1340,6 +1352,7 @@ static inline int ravb_hook_irq(unsigned int irq, irq_handler_t handler,
 static int ravb_open(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	struct platform_device *pdev = priv->pdev;
 	struct device *dev = &pdev->dev;
 	int error;
@@ -1388,7 +1401,7 @@ static int ravb_open(struct net_device *ndev)
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1402,7 +1415,7 @@ static int ravb_open(struct net_device *ndev)
 
 out_ptp_stop:
 	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
 	if (priv->chip_id == RCAR_GEN2)
@@ -1443,13 +1456,14 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 {
 	struct ravb_private *priv = container_of(work, struct ravb_private,
 						 work);
+	const struct ravb_drv_data *info = priv->info;
 	struct net_device *ndev = priv->ndev;
 	int error;
 
 	netif_tx_stop_all_queues(ndev);
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
@@ -1484,7 +1498,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 
 out:
 	/* Initialise PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1681,6 +1695,7 @@ static int ravb_close(struct net_device *ndev)
 {
 	struct device_node *np = ndev->dev.parent->of_node;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	struct ravb_tstamp_skb *ts_skb, *ts_skb2;
 
 	netif_tx_stop_all_queues(ndev);
@@ -1691,7 +1706,7 @@ static int ravb_close(struct net_device *ndev)
 	ravb_write(ndev, 0, TIC);
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_INACTIVE)
 		ravb_ptp_stop(ndev);
 
 	/* Set the config mode to stop the AVB-DMAC's processes */
@@ -1940,6 +1955,7 @@ static const struct ravb_drv_data ravb_gen3_data = {
 	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.num_tx_desc = NUM_TX_DESC_GEN3,
 	.chip_id = RCAR_GEN3,
+	.features = RAVB_RCAR_GEN3_FEATURES,
 };
 
 static const struct ravb_drv_data ravb_gen2_data = {
@@ -1952,6 +1968,7 @@ static const struct ravb_drv_data ravb_gen2_data = {
 	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.num_tx_desc = NUM_TX_DESC_GEN2,
 	.chip_id = RCAR_GEN2,
+	.features = RAVB_RCAR_GEN2_FEATURES,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -1992,14 +2009,20 @@ static int ravb_set_gti(struct net_device *ndev)
 static void ravb_set_config_mode(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 
-	if (priv->chip_id == RCAR_GEN2) {
+	switch (info->features & RAVB_PTP) {
+	case RAVB_PTP_CONFIG_INACTIVE:
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
-	} else {
+		break;
+	case RAVB_PTP_CONFIG_ACTIVE:
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG |
 			    CCC_GAC | CCC_CSEL_HPB);
+		break;
+	default:
+		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 	}
 }
 
@@ -2182,13 +2205,15 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	error = ravb_set_gti(ndev);
-	if (error)
-		goto out_disable_refclk;
+	if (info->features & RAVB_PTP) {
+		/* Set GTI value */
+		error = ravb_set_gti(ndev);
+		if (error)
+			goto out_disable_refclk;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (priv->chip_id != RCAR_GEN2) {
 		ravb_parse_delay_mode(np, ndev);
@@ -2214,7 +2239,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (info->chip_id != RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_ACTIVE)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2262,7 +2287,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (info->chip_id != RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_ACTIVE)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
@@ -2278,9 +2303,10 @@ static int ravb_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id != RCAR_GEN2)
+	if (info->features & RAVB_PTP_CONFIG_ACTIVE)
 		ravb_ptp_stop(ndev);
 
 	clk_disable_unprepare(priv->refclk);
@@ -2363,6 +2389,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int ret = 0;
 
 	/* If WoL is enabled set reset mode to rearm the WoL logic */
@@ -2377,13 +2404,15 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	ret = ravb_set_gti(ndev);
-	if (ret)
-		return ret;
+	if (info->features & RAVB_PTP) {
+		/* Set GTI value */
+		ret = ravb_set_gti(ndev);
+		if (ret)
+			return ret;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (priv->chip_id != RCAR_GEN2)
 		ravb_set_delay_mode(ndev);
-- 
2.17.1

