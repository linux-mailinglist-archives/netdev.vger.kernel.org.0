Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0197C3F7004
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhHYHDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:16 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:21353 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239157AbhHYHDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:06 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91678687"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:11 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id AD1604202746;
        Wed, 25 Aug 2021 16:02:08 +0900 (JST)
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
Subject: [PATCH net-next 03/13] ravb: Add no_ptp_cfg_active to struct ravb_hw_info
Date:   Wed, 25 Aug 2021 08:01:44 +0100
Message-Id: <20210825070154.14336-4-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some H/W differences for the gPTP feature between
R-Car Gen3, R-Car Gen2, and RZ/G2L as below.

1) On R-Car Gen2, gPTP support is not active in config mode.
2) On R-Car Gen3, gPTP support is active in config mode.
3) RZ/G2L does not support the gPTP feature.

Add a no_ptp_cfg_active hw feature bit to struct ravb_hw_info for
handling gPTP for R-Car Gen2.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index da486e06b322..9ecf1a8c3ca8 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -998,6 +998,7 @@ struct ravb_hw_info {
 	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
+	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 28b8dcae57a8..e33b836218f0 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1205,6 +1205,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 			      struct ethtool_ringparam *ring)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	int error;
 
 	if (ring->tx_pending > BE_TX_RING_MAX ||
@@ -1218,7 +1219,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		netif_device_detach(ndev);
 		/* Stop PTP Clock driver */
-		if (priv->chip_id == RCAR_GEN2)
+		if (info->no_ptp_cfg_active)
 			ravb_ptp_stop(ndev);
 		/* Wait for DMA stopping */
 		error = ravb_stop_dma(ndev);
@@ -1250,7 +1251,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 		ravb_emac_init(ndev);
 
 		/* Initialise PTP Clock driver */
-		if (priv->chip_id == RCAR_GEN2)
+		if (info->no_ptp_cfg_active)
 			ravb_ptp_init(ndev, priv->pdev);
 
 		netif_device_attach(ndev);
@@ -1390,7 +1391,7 @@ static int ravb_open(struct net_device *ndev)
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->no_ptp_cfg_active)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1404,7 +1405,7 @@ static int ravb_open(struct net_device *ndev)
 
 out_ptp_stop:
 	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->no_ptp_cfg_active)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
 	if (!info->multi_irqs)
@@ -1445,13 +1446,14 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 {
 	struct ravb_private *priv = container_of(work, struct ravb_private,
 						 work);
+	const struct ravb_hw_info *info = priv->info;
 	struct net_device *ndev = priv->ndev;
 	int error;
 
 	netif_tx_stop_all_queues(ndev);
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->no_ptp_cfg_active)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
@@ -1486,7 +1488,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 
 out:
 	/* Initialise PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->no_ptp_cfg_active)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1695,7 +1697,7 @@ static int ravb_close(struct net_device *ndev)
 	ravb_write(ndev, 0, TIC);
 
 	/* Stop PTP Clock driver */
-	if (priv->chip_id == RCAR_GEN2)
+	if (info->no_ptp_cfg_active)
 		ravb_ptp_stop(ndev);
 
 	/* Set the config mode to stop the AVB-DMAC's processes */
@@ -1956,6 +1958,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
+	.no_ptp_cfg_active = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -1996,8 +1999,9 @@ static int ravb_set_gti(struct net_device *ndev)
 static void ravb_set_config_mode(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 
-	if (priv->chip_id == RCAR_GEN2) {
+	if (info->no_ptp_cfg_active) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
-- 
2.17.1

