Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361493F7006
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239174AbhHYHDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:18 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:1587 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239159AbhHYHDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:06 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91716467"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:15 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 34D0D4202725;
        Wed, 25 Aug 2021 16:02:12 +0900 (JST)
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
Subject: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct ravb_hw_info
Date:   Wed, 25 Aug 2021 08:01:45 +0100
Message-Id: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some H/W differences for the gPTP feature between
R-Car Gen3, R-Car Gen2, and RZ/G2L as below.

1) On R-Car Gen3, gPTP support is active in config mode.
2) On R-Car Gen2, gPTP support is not active in config mode.
3) RZ/G2L does not support the gPTP feature.

Add a ptp_cfg_active hw feature bit to struct ravb_hw_info for
supporting gPTP active in config mode for R-Car Gen3.
This patch also removes enum ravb_chip_id, chip_id from both
struct ravb_hw_info and struct ravb_private, as it is unused.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  8 +-------
 drivers/net/ethernet/renesas/ravb_main.c | 12 +++++-------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9ecf1a8c3ca8..209e030935aa 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -979,17 +979,11 @@ struct ravb_ptp {
 	struct ravb_ptp_perout perout[N_PER_OUT];
 };
 
-enum ravb_chip_id {
-	RCAR_GEN2,
-	RCAR_GEN3,
-};
-
 struct ravb_hw_info {
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
 	netdev_features_t net_features;
-	enum ravb_chip_id chip_id;
 	int stats_len;
 	size_t max_rx_len;
 	unsigned aligned_tx: 1;
@@ -999,6 +993,7 @@ struct ravb_hw_info {
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
 	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
+	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in config mode */
 };
 
 struct ravb_private {
@@ -1042,7 +1037,6 @@ struct ravb_private {
 	int msg_enable;
 	int speed;
 	int emac_irq;
-	enum ravb_chip_id chip_id;
 	int rx_irqs[NUM_RX_QUEUE];
 	int tx_irqs[NUM_TX_QUEUE];
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e33b836218f0..883db1049882 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1941,12 +1941,12 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
 	.net_features = NETIF_F_RXCSUM,
-	.chip_id = RCAR_GEN3,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
+	.ptp_cfg_active = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -1954,7 +1954,6 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
 	.net_features = NETIF_F_RXCSUM,
-	.chip_id = RCAR_GEN2,
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
@@ -2152,8 +2151,6 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->chip_id = info->chip_id;
-
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		error = PTR_ERR(priv->clk);
@@ -2216,7 +2213,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (info->chip_id != RCAR_GEN2)
+	if (info->ptp_cfg_active)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2264,7 +2261,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (info->chip_id != RCAR_GEN2)
+	if (info->ptp_cfg_active)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
@@ -2280,9 +2277,10 @@ static int ravb_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id != RCAR_GEN2)
+	if (info->ptp_cfg_active)
 		ravb_ptp_stop(ndev);
 
 	clk_disable_unprepare(priv->refclk);
-- 
2.17.1

