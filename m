Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142FE416099
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbhIWOJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:09:59 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:4209 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241591AbhIWOJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:09:58 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94936067"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:26 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 015D9437F0B4;
        Thu, 23 Sep 2021 23:08:22 +0900 (JST)
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
Subject: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active" and "ptp_cfg_active"
Date:   Thu, 23 Sep 2021 15:07:57 +0100
Message-Id: <20210923140813.13541-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the variable "no_ptp_cfg_active" with "no_gptp" with inverted
checks and "ptp_cfg_active" with "ccc_gac".

There is no functional change.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 drivers/net/ethernet/renesas/ravb.h      |  4 ++--
 drivers/net/ethernet/renesas/ravb_main.c | 25 ++++++++++++------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 7363abae6e59..0ce0c13ef8cb 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1000,8 +1000,8 @@ struct ravb_hw_info {
 	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
-	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
-	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in config mode */
+	unsigned no_gptp:1;		/* AVB-DMAC does not support gPTP feature */
+	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 8f2358caef34..2422e74d9b4f 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1274,7 +1274,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		netif_device_detach(ndev);
 		/* Stop PTP Clock driver */
-		if (info->no_ptp_cfg_active)
+		if (!info->no_gptp && !info->ccc_gac)
 			ravb_ptp_stop(ndev);
 		/* Wait for DMA stopping */
 		error = ravb_stop_dma(ndev);
@@ -1306,7 +1306,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 		ravb_emac_init(ndev);
 
 		/* Initialise PTP Clock driver */
-		if (info->no_ptp_cfg_active)
+		if (!info->no_gptp && !info->ccc_gac)
 			ravb_ptp_init(ndev, priv->pdev);
 
 		netif_device_attach(ndev);
@@ -1446,7 +1446,7 @@ static int ravb_open(struct net_device *ndev)
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (!info->no_gptp && !info->ccc_gac)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1460,7 +1460,7 @@ static int ravb_open(struct net_device *ndev)
 
 out_ptp_stop:
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (!info->no_gptp && !info->ccc_gac)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
 	if (!info->multi_irqs)
@@ -1508,7 +1508,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	netif_tx_stop_all_queues(ndev);
 
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (!info->no_gptp && !info->ccc_gac)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
@@ -1543,7 +1543,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 
 out:
 	/* Initialise PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (!info->no_gptp && !info->ccc_gac)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1752,7 +1752,7 @@ static int ravb_close(struct net_device *ndev)
 	ravb_write(ndev, 0, TIC);
 
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (!info->no_gptp && !info->ccc_gac)
 		ravb_ptp_stop(ndev);
 
 	/* Set the config mode to stop the AVB-DMAC's processes */
@@ -2018,7 +2018,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
-	.ptp_cfg_active = 1,
+	.ccc_gac = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2037,7 +2037,6 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
-	.no_ptp_cfg_active = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -2080,7 +2079,7 @@ static void ravb_set_config_mode(struct net_device *ndev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
-	if (info->no_ptp_cfg_active) {
+	if (!info->no_gptp && !info->ccc_gac) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
@@ -2301,7 +2300,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2349,7 +2348,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
@@ -2369,7 +2368,7 @@ static int ravb_remove(struct platform_device *pdev)
 	const struct ravb_hw_info *info = priv->info;
 
 	/* Stop PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
 
 	clk_disable_unprepare(priv->refclk);
-- 
2.17.1

