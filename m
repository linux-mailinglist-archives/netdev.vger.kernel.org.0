Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7743DD39E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhHBK1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:27:21 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:25382 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231357AbhHBK1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:27:20 -0400
X-IronPort-AV: E=Sophos;i="5.84,288,1620658800"; 
   d="scan'208";a="89548922"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 02 Aug 2021 19:27:10 +0900
Received: from localhost.localdomain (unknown [10.226.92.138])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id BC0CD40083D9;
        Mon,  2 Aug 2021 19:27:04 +0900 (JST)
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
Subject: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver data
Date:   Mon,  2 Aug 2021 11:26:47 +0100
Message-Id: <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
similar to the R-Car Ethernet AVB IP. With a few changes in the driver we
can support both IPs.

Currently a runtime decision based on the chip type is used to distinguish
the HW differences between the SoC families.

The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2 and
RZ/G2L it is 2. For cases like this it is better to select the number of
TX descriptors by using a structure with a value, rather than a runtime
decision based on the chip type.

This patch adds the num_tx_desc variable to struct ravb_hw_info and also
replaces the driver data chip type with struct ravb_hw_info by moving chip
type to it.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
v2:
 * Incorporated Andrew and Sergei's review comments for making it smaller patch
   and provided detailed description.
---
 drivers/net/ethernet/renesas/ravb.h      |  7 +++++
 drivers/net/ethernet/renesas/ravb_main.c | 38 +++++++++++++++---------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 80e62ca2e3d3..cfb972c05b34 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -988,6 +988,11 @@ enum ravb_chip_id {
 	RCAR_GEN3,
 };
 
+struct ravb_hw_info {
+	enum ravb_chip_id chip_id;
+	int num_tx_desc;
+};
+
 struct ravb_private {
 	struct net_device *ndev;
 	struct platform_device *pdev;
@@ -1040,6 +1045,8 @@ struct ravb_private {
 	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	int num_tx_desc;		/* TX descriptors per packet */
+
+	const struct ravb_hw_info *info;
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index f4dfe9f71d06..ffbd224d8780 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1924,12 +1924,22 @@ static int ravb_mdio_release(struct ravb_private *priv)
 	return 0;
 }
 
+static const struct ravb_hw_info ravb_gen3_hw_info = {
+	.chip_id = RCAR_GEN3,
+	.num_tx_desc = NUM_TX_DESC_GEN3,
+};
+
+static const struct ravb_hw_info ravb_gen2_hw_info = {
+	.chip_id = RCAR_GEN2,
+	.num_tx_desc = NUM_TX_DESC_GEN2,
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
@@ -2034,8 +2044,8 @@ static void ravb_set_delay_mode(struct net_device *ndev)
 static int ravb_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	const struct ravb_hw_info *info;
 	struct ravb_private *priv;
-	enum ravb_chip_id chip_id;
 	struct net_device *ndev;
 	int error, irq, q;
 	struct resource *res;
@@ -2058,9 +2068,9 @@ static int ravb_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
+	info = of_device_get_match_data(&pdev->dev);
 
-	if (chip_id == RCAR_GEN3)
+	if (info->chip_id == RCAR_GEN3)
 		irq = platform_get_irq_byname(pdev, "ch22");
 	else
 		irq = platform_get_irq(pdev, 0);
@@ -2073,6 +2083,7 @@ static int ravb_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	priv = netdev_priv(ndev);
+	priv->info = info;
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
@@ -2099,7 +2110,7 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->avb_link_active_low =
 		of_property_read_bool(np, "renesas,ether-link-active-low");
 
-	if (chip_id == RCAR_GEN3) {
+	if (info->chip_id == RCAR_GEN3) {
 		irq = platform_get_irq_byname(pdev, "ch24");
 		if (irq < 0) {
 			error = irq;
@@ -2124,7 +2135,7 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
-	priv->chip_id = chip_id;
+	priv->chip_id = info->chip_id;
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
@@ -2142,8 +2153,7 @@ static int ravb_probe(struct platform_device *pdev)
 	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
 	ndev->min_mtu = ETH_MIN_MTU;
 
-	priv->num_tx_desc = chip_id == RCAR_GEN2 ?
-		NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
+	priv->num_tx_desc = info->num_tx_desc;
 
 	/* Set function */
 	ndev->netdev_ops = &ravb_netdev_ops;
@@ -2184,7 +2194,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (info->chip_id != RCAR_GEN2)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2232,7 +2242,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (chip_id != RCAR_GEN2)
+	if (info->chip_id != RCAR_GEN2)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
-- 
2.17.1

