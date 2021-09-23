Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5FA41609F
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbhIWOKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:10:10 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:30888 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241555AbhIWOKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:10:08 -0400
X-IronPort-AV: E=Sophos;i="5.85,316,1624287600"; 
   d="scan'208";a="94816081"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 23 Sep 2021 23:08:36 +0900
Received: from localhost.localdomain (unknown [10.226.92.2])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 92430437F0B6;
        Thu, 23 Sep 2021 23:08:33 +0900 (JST)
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
Subject: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Date:   Thu, 23 Sep 2021 15:08:00 +0100
Message-Id: <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car supports gPTP feature whereas RZ/G2L does not support it.
This patch excludes gtp feature support for RZ/G2L by enabling
no_gptp feature bit.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 46 ++++++++++++++----------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d38fc33a8e93..8663d83507a0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -918,6 +918,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 {
 	struct net_device *ndev = dev_id;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	irqreturn_t result = IRQ_NONE;
 	u32 iss;
 
@@ -953,7 +954,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 	}
 
 	/* gPTP interrupt status summary */
-	if (iss & ISS_CGIS) {
+	if (!info->no_gptp && (iss & ISS_CGIS)) {
 		ravb_ptp_interrupt(ndev);
 		result = IRQ_HANDLED;
 	}
@@ -1378,6 +1379,7 @@ static int ravb_get_ts_info(struct net_device *ndev,
 			    struct ethtool_ts_info *info)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *hw_info = priv->info;
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_SOFTWARE |
@@ -1391,7 +1393,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
 		(1 << HWTSTAMP_FILTER_NONE) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 		(1 << HWTSTAMP_FILTER_ALL);
-	info->phc_index = ptp_clock_index(priv->ptp.clock);
+	if (!hw_info->no_gptp)
+		info->phc_index = ptp_clock_index(priv->ptp.clock);
 
 	return 0;
 }
@@ -2116,6 +2119,7 @@ static const struct ravb_hw_info rgeth_hw_info = {
 	.emac_init = ravb_rgeth_emac_init,
 	.aligned_tx = 1,
 	.tx_counters = 1,
+	.no_gptp = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -2159,13 +2163,15 @@ static void ravb_set_config_mode(struct net_device *ndev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
-	if (!info->no_gptp && !info->ccc_gac) {
+	if (info->no_gptp) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
-		/* Set CSEL value */
-		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
-	} else {
+	} else if (info->ccc_gac) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG |
 			    CCC_GAC | CCC_CSEL_HPB);
+	} else {
+		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
+		/* Set CSEL value */
+		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
 	}
 }
 
@@ -2348,13 +2354,15 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	error = ravb_set_gti(ndev);
-	if (error)
-		goto out_disable_refclk;
+	if (!info->no_gptp) {
+		/* Set GTI value */
+		error = ravb_set_gti(ndev);
+		if (error)
+			goto out_disable_refclk;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (info->internal_delay) {
 		ravb_parse_delay_mode(np, ndev);
@@ -2547,13 +2555,15 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	ret = ravb_set_gti(ndev);
-	if (ret)
-		return ret;
+	if (!info->no_gptp) {
+		/* Set GTI value */
+		ret = ravb_set_gti(ndev);
+		if (ret)
+			return ret;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (info->internal_delay)
 		ravb_set_delay_mode(ndev);
-- 
2.17.1

