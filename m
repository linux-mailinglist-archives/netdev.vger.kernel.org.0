Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7193F0B8E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhHRTJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:09:16 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:22399 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233283AbhHRTIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:08:49 -0400
X-IronPort-AV: E=Sophos;i="5.84,332,1620658800"; 
   d="scan'208";a="91033551"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 19 Aug 2021 04:08:14 +0900
Received: from localhost.localdomain (unknown [10.226.93.61])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B908A40D5D67;
        Thu, 19 Aug 2021 04:08:10 +0900 (JST)
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
Subject: [PATCH net-next v3 2/9] ravb: Add struct ravb_hw_info to driver data
Date:   Wed, 18 Aug 2021 20:07:53 +0100
Message-Id: <20210818190800.20191-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
References: <20210818190800.20191-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
similar to the R-Car Ethernet AVB IP. With a few changes in the driver we
can support both IPs.

This patch adds the struct ravb_hw_info to hold hw features, driver data
and function pointers to support both the IPs. It also replaces the driver
data chip type with struct ravb_hw_info by moving chip type to it.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v2->v3:
 * Retained Rb tag from Andrew, since there is no functionality change
   apart from just splitting the patch into 2. Also updated the commit
   description.
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      |  6 ++++
 drivers/net/ethernet/renesas/ravb_main.c | 35 +++++++++++++++---------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 85ece16134c9..6ff0b2626708 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -988,6 +988,10 @@ enum ravb_chip_id {
 	RCAR_GEN3,
 };
 
+struct ravb_hw_info {
+	enum ravb_chip_id chip_id;
+};
+
 struct ravb_private {
 	struct net_device *ndev;
 	struct platform_device *pdev;
@@ -1040,6 +1044,8 @@ struct ravb_private {
 	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	unsigned int num_tx_desc;	/* TX descriptors per packet */
+
+	const struct ravb_hw_info *info;
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 94eb9136752d..b6554e5e13af 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1924,12 +1924,20 @@ static int ravb_mdio_release(struct ravb_private *priv)
 	return 0;
 }
 
+static const struct ravb_hw_info ravb_gen3_hw_info = {
+	.chip_id = RCAR_GEN3,
+};
+
+static const struct ravb_hw_info ravb_gen2_hw_info = {
+	.chip_id = RCAR_GEN2,
+};
+
 static const struct of_device_id ravb_match_table[] = {
-	{ .compatible = "renesas,etheravb-r8a7790", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,etheravb-r8a7794", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,etheravb-rcar-gen2", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,etheravb-r8a7795", .data = (void *)RCAR_GEN3 },
-	{ .compatible = "renesas,etheravb-rcar-gen3", .data = (void *)RCAR_GEN3 },
+	{ .compatible = "renesas,etheravb-r8a7790", .data = &ravb_gen2_hw_info },
+	{ .compatible = "renesas,etheravb-r8a7794", .data = &ravb_gen2_hw_info },
+	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
+	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
+	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);
@@ -2023,8 +2031,8 @@ static void ravb_set_delay_mode(struct net_device *ndev)
 static int ravb_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	const struct ravb_hw_info *info;
 	struct ravb_private *priv;
-	enum ravb_chip_id chip_id;
 	struct net_device *ndev;
 	int error, irq, q;
 	struct resource *res;
@@ -2047,9 +2055,9 @@ static int ravb_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
+	info = of_device_get_match_data(&pdev->dev);
 
-	if (chip_id == RCAR_GEN3)
+	if (info->chip_id == RCAR_GEN3)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
 		irq = platform_get_irq(pdev, 0);
@@ -2062,6 +2070,7 @@ static int ravb_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	priv = netdev_priv(ndev);
+	priv->info = info;
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
@@ -2088,7 +2097,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->avb_link_active_low =
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
-	if (chip_id == RCAR_GEN3) {
+	if (info->chip_id == RCAR_GEN3) {
 		irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
@@ -2113,7 +2122,7 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->chip_id = chip_id;
+	priv->chip_id = info->chip_id;
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
@@ -2131,7 +2140,7 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-	priv->num_tx_desc = chip_id == RCAR_GEN2 ?
+	priv->num_tx_desc = info->chip_id == RCAR_GEN2 ?
 		NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
 
 	/* Set function */
@@ -2173,7 +2182,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (info->chip_id != RCAR_GEN2)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2221,7 +2230,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (info->chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
-- 
2.17.1

