Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B001A4D7D3D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiCNIIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiCNIHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:07:49 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685B73F8B9;
        Mon, 14 Mar 2022 01:05:34 -0700 (PDT)
X-UUID: 056b96e514c940ab8c284bf0a31f8b3b-20220314
X-UUID: 056b96e514c940ab8c284bf0a31f8b3b-20220314
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 978099276; Mon, 14 Mar 2022 15:57:21 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 14 Mar 2022 15:57:20 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Mar 2022 15:57:19 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <angelogioacchino.delregno@collabora.com>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Subject: [PATCH net-next v13 3/7] stmmac: dwmac-mediatek: re-arrange clock setting
Date:   Mon, 14 Mar 2022 15:57:09 +0800
Message-ID: <20220314075713.29140-4-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220314075713.29140-1-biao.huang@mediatek.com>
References: <20220314075713.29140-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rmii_internal clock is needed only when PHY
interface is RMII, and reference clock is from MAC.

Re-arrange the clock setting as following:
1. the optional "rmii_internal" is controlled by devm_clk_get(),
2. other clocks still be configured by devm_clk_bulk_get().

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 71 +++++++++++++------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 8747aa4403e8..b2507a2ba326 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -49,12 +49,12 @@ struct mac_delay_struct {
 struct mediatek_dwmac_plat_data {
 	const struct mediatek_dwmac_variant *variant;
 	struct mac_delay_struct mac_delay;
+	struct clk *rmii_internal_clk;
 	struct clk_bulk_data *clks;
-	struct device_node *np;
 	struct regmap *peri_regmap;
+	struct device_node *np;
 	struct device *dev;
 	phy_interface_t phy_mode;
-	int num_clks_to_config;
 	bool rmii_clk_from_mac;
 	bool rmii_rxc;
 };
@@ -74,7 +74,7 @@ struct mediatek_dwmac_variant {
 
 /* list of clocks required for mac */
 static const char * const mt2712_dwmac_clk_l[] = {
-	"axi", "apb", "mac_main", "ptp_ref", "rmii_internal"
+	"axi", "apb", "mac_main", "ptp_ref"
 };
 
 static int mt2712_set_interface(struct mediatek_dwmac_plat_data *plat)
@@ -83,23 +83,12 @@ static int mt2712_set_interface(struct mediatek_dwmac_plat_data *plat)
 	int rmii_rxc = plat->rmii_rxc ? RMII_CLK_SRC_RXC : 0;
 	u32 intf_val = 0;
 
-	/* The clock labeled as "rmii_internal" in mt2712_dwmac_clk_l is needed
-	 * only in RMII(when MAC provides the reference clock), and useless for
-	 * RGMII/MII/RMII(when PHY provides the reference clock).
-	 * num_clks_to_config indicates the real number of clocks should be
-	 * configured, equals to (plat->variant->num_clks - 1) in default for all the case,
-	 * then +1 for rmii_clk_from_mac case.
-	 */
-	plat->num_clks_to_config = plat->variant->num_clks - 1;
-
 	/* select phy interface in top control domain */
 	switch (plat->phy_mode) {
 	case PHY_INTERFACE_MODE_MII:
 		intf_val |= PHY_INTF_MII;
 		break;
 	case PHY_INTERFACE_MODE_RMII:
-		if (plat->rmii_clk_from_mac)
-			plat->num_clks_to_config++;
 		intf_val |= (PHY_INTF_RMII | rmii_rxc | rmii_clk_from_mac);
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
@@ -314,18 +303,34 @@ static int mediatek_dwmac_config_dt(struct mediatek_dwmac_plat_data *plat)
 static int mediatek_dwmac_clk_init(struct mediatek_dwmac_plat_data *plat)
 {
 	const struct mediatek_dwmac_variant *variant = plat->variant;
-	int i, num = variant->num_clks;
+	int i, ret;
 
-	plat->clks = devm_kcalloc(plat->dev, num, sizeof(*plat->clks), GFP_KERNEL);
+	plat->clks = devm_kcalloc(plat->dev, variant->num_clks, sizeof(*plat->clks), GFP_KERNEL);
 	if (!plat->clks)
 		return -ENOMEM;
 
-	for (i = 0; i < num; i++)
+	for (i = 0; i < variant->num_clks; i++)
 		plat->clks[i].id = variant->clk_list[i];
 
-	plat->num_clks_to_config = variant->num_clks;
+	ret = devm_clk_bulk_get(plat->dev, variant->num_clks, plat->clks);
+	if (ret)
+		return ret;
 
-	return devm_clk_bulk_get(plat->dev, num, plat->clks);
+	/* The clock labeled as "rmii_internal" is needed only in RMII(when
+	 * MAC provides the reference clock), and useless for RGMII/MII or
+	 * RMII(when PHY provides the reference clock).
+	 * So, "rmii_internal" clock is got and configured only when
+	 * reference clock of RMII is from MAC.
+	 */
+	if (plat->rmii_clk_from_mac) {
+		plat->rmii_internal_clk = devm_clk_get(plat->dev, "rmii_internal");
+		if (IS_ERR(plat->rmii_internal_clk))
+			ret = PTR_ERR(plat->rmii_internal_clk);
+	} else {
+		plat->rmii_internal_clk = NULL;
+	}
+
+	return ret;
 }
 
 static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
@@ -350,35 +355,55 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
 		}
 	}
 
-	ret = clk_bulk_prepare_enable(plat->num_clks_to_config, plat->clks);
+	ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
 	if (ret) {
 		dev_err(plat->dev, "failed to enable clks, err = %d\n", ret);
 		return ret;
 	}
 
+	ret = clk_prepare_enable(plat->rmii_internal_clk);
+	if (ret) {
+		dev_err(plat->dev, "failed to enable rmii internal clk, err = %d\n", ret);
+		goto err_clk;
+	}
+
 	return 0;
+
+err_clk:
+	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
+	return ret;
 }
 
 static void mediatek_dwmac_exit(struct platform_device *pdev, void *priv)
 {
 	struct mediatek_dwmac_plat_data *plat = priv;
+	const struct mediatek_dwmac_variant *variant = plat->variant;
 
-	clk_bulk_disable_unprepare(plat->num_clks_to_config, plat->clks);
+	clk_disable_unprepare(plat->rmii_internal_clk);
+	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
 }
 
 static int mediatek_dwmac_clks_config(void *priv, bool enabled)
 {
 	struct mediatek_dwmac_plat_data *plat = priv;
+	const struct mediatek_dwmac_variant *variant = plat->variant;
 	int ret = 0;
 
 	if (enabled) {
-		ret = clk_bulk_prepare_enable(plat->num_clks_to_config, plat->clks);
+		ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
 		if (ret) {
 			dev_err(plat->dev, "failed to enable clks, err = %d\n", ret);
 			return ret;
 		}
+
+		ret = clk_prepare_enable(plat->rmii_internal_clk);
+		if (ret) {
+			dev_err(plat->dev, "failed to enable rmii internal clk, err = %d\n", ret);
+			return ret;
+		}
 	} else {
-		clk_bulk_disable_unprepare(plat->num_clks_to_config, plat->clks);
+		clk_disable_unprepare(plat->rmii_internal_clk);
+		clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
 	}
 
 	return ret;
-- 
2.25.1

