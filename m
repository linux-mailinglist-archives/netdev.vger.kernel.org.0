Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF89483B1E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiADDkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:40:01 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:59696 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232641AbiADDj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:39:57 -0500
X-UUID: 7ea9ebc704084fbc92e35be3e9b21f8c-20220104
X-UUID: 7ea9ebc704084fbc92e35be3e9b21f8c-20220104
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1752466435; Tue, 04 Jan 2022 11:39:51 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 4 Jan 2022 11:39:50 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Jan 2022 11:39:49 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
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
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: [PATCH net-next v11 5/6] stmmac: dwmac-mediatek: add support for mt8195
Date:   Tue, 4 Jan 2022 11:39:39 +0800
Message-ID: <20220104033940.5497-6-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104033940.5497-1-biao.huang@mediatek.com>
References: <20220104033940.5497-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Ethernet support for MediaTek SoCs from the mt8195 family.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 253 +++++++++++++++++-
 1 file changed, 252 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 8747aa4403e8..bbb94aeee104 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -39,6 +39,33 @@
 #define ETH_FINE_DLY_GTXC	BIT(1)
 #define ETH_FINE_DLY_RXC	BIT(0)
 
+/* Peri Configuration register for mt8195 */
+#define MT8195_PERI_ETH_CTRL0		0xFD0
+#define MT8195_RMII_CLK_SRC_INTERNAL	BIT(28)
+#define MT8195_RMII_CLK_SRC_RXC		BIT(27)
+#define MT8195_ETH_INTF_SEL		GENMASK(26, 24)
+#define MT8195_RGMII_TXC_PHASE_CTRL	BIT(22)
+#define MT8195_EXT_PHY_MODE		BIT(21)
+#define MT8195_DLY_GTXC_INV		BIT(12)
+#define MT8195_DLY_GTXC_ENABLE		BIT(5)
+#define MT8195_DLY_GTXC_STAGES		GENMASK(4, 0)
+
+#define MT8195_PERI_ETH_CTRL1		0xFD4
+#define MT8195_DLY_RXC_INV		BIT(25)
+#define MT8195_DLY_RXC_ENABLE		BIT(18)
+#define MT8195_DLY_RXC_STAGES		GENMASK(17, 13)
+#define MT8195_DLY_TXC_INV		BIT(12)
+#define MT8195_DLY_TXC_ENABLE		BIT(5)
+#define MT8195_DLY_TXC_STAGES		GENMASK(4, 0)
+
+#define MT8195_PERI_ETH_CTRL2		0xFD8
+#define MT8195_DLY_RMII_RXC_INV		BIT(25)
+#define MT8195_DLY_RMII_RXC_ENABLE	BIT(18)
+#define MT8195_DLY_RMII_RXC_STAGES	GENMASK(17, 13)
+#define MT8195_DLY_RMII_TXC_INV		BIT(12)
+#define MT8195_DLY_RMII_TXC_ENABLE	BIT(5)
+#define MT8195_DLY_RMII_TXC_STAGES	GENMASK(4, 0)
+
 struct mac_delay_struct {
 	u32 tx_delay;
 	u32 rx_delay;
@@ -57,11 +84,13 @@ struct mediatek_dwmac_plat_data {
 	int num_clks_to_config;
 	bool rmii_clk_from_mac;
 	bool rmii_rxc;
+	bool mac_wol;
 };
 
 struct mediatek_dwmac_variant {
 	int (*dwmac_set_phy_interface)(struct mediatek_dwmac_plat_data *plat);
 	int (*dwmac_set_delay)(struct mediatek_dwmac_plat_data *plat);
+	void (*dwmac_fix_mac_speed)(void *priv, unsigned int speed);
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -77,6 +106,10 @@ static const char * const mt2712_dwmac_clk_l[] = {
 	"axi", "apb", "mac_main", "ptp_ref", "rmii_internal"
 };
 
+static const char * const mt8195_dwmac_clk_l[] = {
+	"axi", "apb", "mac_cg", "mac_main", "ptp_ref", "rmii_internal"
+};
+
 static int mt2712_set_interface(struct mediatek_dwmac_plat_data *plat)
 {
 	int rmii_clk_from_mac = plat->rmii_clk_from_mac ? RMII_CLK_SRC_INTERNAL : 0;
@@ -267,6 +300,204 @@ static const struct mediatek_dwmac_variant mt2712_gmac_variant = {
 		.tx_delay_max = 17600,
 };
 
+static int mt8195_set_interface(struct mediatek_dwmac_plat_data *plat)
+{
+	int rmii_clk_from_mac = plat->rmii_clk_from_mac ? MT8195_RMII_CLK_SRC_INTERNAL : 0;
+	int rmii_rxc = plat->rmii_rxc ? MT8195_RMII_CLK_SRC_RXC : 0;
+	u32 intf_val = 0;
+
+	/* The clock labeled as "rmii_internal" in mt8195_dwmac_clk_l is needed
+	 * only in RMII(when MAC provides the reference clock), and useless for
+	 * RGMII/MII/RMII(when PHY provides the reference clock).
+	 * num_clks_to_config indicates the real number of clocks should be
+	 * configured, equals to (plat->variant->num_clks - 1) in default for all the case,
+	 * then +1 for rmii_clk_from_mac case.
+	 */
+	plat->num_clks_to_config = plat->variant->num_clks - 1;
+
+	/* select phy interface in top control domain */
+	switch (plat->phy_mode) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val |= FIELD_PREP(MT8195_ETH_INTF_SEL, PHY_INTF_MII);
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (plat->rmii_clk_from_mac)
+			plat->num_clks_to_config++;
+		intf_val |= (rmii_rxc | rmii_clk_from_mac);
+		intf_val |= FIELD_PREP(MT8195_ETH_INTF_SEL, PHY_INTF_RMII);
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		intf_val |= FIELD_PREP(MT8195_ETH_INTF_SEL, PHY_INTF_RGMII);
+		break;
+	default:
+		dev_err(plat->dev, "phy interface not supported\n");
+		return -EINVAL;
+	}
+
+	/* MT8195 only support external PHY */
+	intf_val |= MT8195_EXT_PHY_MODE;
+
+	regmap_write(plat->peri_regmap, MT8195_PERI_ETH_CTRL0, intf_val);
+
+	return 0;
+}
+
+static void mt8195_delay_ps2stage(struct mediatek_dwmac_plat_data *plat)
+{
+	struct mac_delay_struct *mac_delay = &plat->mac_delay;
+
+	/* 290ps per stage */
+	mac_delay->tx_delay /= 290;
+	mac_delay->rx_delay /= 290;
+}
+
+static void mt8195_delay_stage2ps(struct mediatek_dwmac_plat_data *plat)
+{
+	struct mac_delay_struct *mac_delay = &plat->mac_delay;
+
+	/* 290ps per stage */
+	mac_delay->tx_delay *= 290;
+	mac_delay->rx_delay *= 290;
+}
+
+static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
+{
+	struct mac_delay_struct *mac_delay = &plat->mac_delay;
+	u32 gtxc_delay_val = 0, delay_val = 0, rmii_delay_val = 0;
+
+	mt8195_delay_ps2stage(plat);
+
+	switch (plat->phy_mode) {
+	case PHY_INTERFACE_MODE_MII:
+		delay_val |= FIELD_PREP(MT8195_DLY_TXC_ENABLE, !!mac_delay->tx_delay);
+		delay_val |= FIELD_PREP(MT8195_DLY_TXC_STAGES, mac_delay->tx_delay);
+		delay_val |= FIELD_PREP(MT8195_DLY_TXC_INV, mac_delay->tx_inv);
+
+		delay_val |= FIELD_PREP(MT8195_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+		delay_val |= FIELD_PREP(MT8195_DLY_RXC_STAGES, mac_delay->rx_delay);
+		delay_val |= FIELD_PREP(MT8195_DLY_RXC_INV, mac_delay->rx_inv);
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (plat->rmii_clk_from_mac) {
+			/* case 1: mac provides the rmii reference clock,
+			 * and the clock output to TXC pin.
+			 * The egress timing can be adjusted by RMII_TXC delay macro circuit.
+			 * The ingress timing can be adjusted by RMII_RXC delay macro circuit.
+			 */
+			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_TXC_ENABLE,
+						     !!mac_delay->tx_delay);
+			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_TXC_STAGES,
+						     mac_delay->tx_delay);
+			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_TXC_INV,
+						     mac_delay->tx_inv);
+
+			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_RXC_ENABLE,
+						     !!mac_delay->rx_delay);
+			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_RXC_STAGES,
+						     mac_delay->rx_delay);
+			rmii_delay_val |= FIELD_PREP(MT8195_DLY_RMII_RXC_INV,
+						     mac_delay->rx_inv);
+		} else {
+			/* case 2: the rmii reference clock is from external phy,
+			 * and the property "rmii_rxc" indicates which pin(TXC/RXC)
+			 * the reference clk is connected to. The reference clock is a
+			 * received signal, so rx_delay/rx_inv are used to indicate
+			 * the reference clock timing adjustment
+			 */
+			if (plat->rmii_rxc) {
+				/* the rmii reference clock from outside is connected
+				 * to RXC pin, the reference clock will be adjusted
+				 * by RXC delay macro circuit.
+				 */
+				delay_val |= FIELD_PREP(MT8195_DLY_RXC_ENABLE,
+							!!mac_delay->rx_delay);
+				delay_val |= FIELD_PREP(MT8195_DLY_RXC_STAGES,
+							mac_delay->rx_delay);
+				delay_val |= FIELD_PREP(MT8195_DLY_RXC_INV,
+							mac_delay->rx_inv);
+			} else {
+				/* the rmii reference clock from outside is connected
+				 * to TXC pin, the reference clock will be adjusted
+				 * by TXC delay macro circuit.
+				 */
+				delay_val |= FIELD_PREP(MT8195_DLY_TXC_ENABLE,
+							!!mac_delay->rx_delay);
+				delay_val |= FIELD_PREP(MT8195_DLY_TXC_STAGES,
+							mac_delay->rx_delay);
+				delay_val |= FIELD_PREP(MT8195_DLY_TXC_INV,
+							mac_delay->rx_inv);
+			}
+		}
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_ENABLE, !!mac_delay->tx_delay);
+		gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_STAGES, mac_delay->tx_delay);
+		gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_INV, mac_delay->tx_inv);
+
+		delay_val |= FIELD_PREP(MT8195_DLY_RXC_ENABLE, !!mac_delay->rx_delay);
+		delay_val |= FIELD_PREP(MT8195_DLY_RXC_STAGES, mac_delay->rx_delay);
+		delay_val |= FIELD_PREP(MT8195_DLY_RXC_INV, mac_delay->rx_inv);
+
+		break;
+	default:
+		dev_err(plat->dev, "phy interface not supported\n");
+		return -EINVAL;
+	}
+
+	regmap_update_bits(plat->peri_regmap,
+			   MT8195_PERI_ETH_CTRL0,
+			   MT8195_RGMII_TXC_PHASE_CTRL |
+			   MT8195_DLY_GTXC_INV |
+			   MT8195_DLY_GTXC_ENABLE |
+			   MT8195_DLY_GTXC_STAGES,
+			   gtxc_delay_val);
+	regmap_write(plat->peri_regmap, MT8195_PERI_ETH_CTRL1, delay_val);
+	regmap_write(plat->peri_regmap, MT8195_PERI_ETH_CTRL2, rmii_delay_val);
+
+	mt8195_delay_stage2ps(plat);
+
+	return 0;
+}
+
+static void mt8195_fix_mac_speed(void *priv, unsigned int speed)
+{
+	struct mediatek_dwmac_plat_data *priv_plat = priv;
+
+	if ((phy_interface_mode_is_rgmii(priv_plat->phy_mode))) {
+		/* prefer 2ns fixed delay which is controlled by TXC_PHASE_CTRL,
+		 * when link speed is 1Gbps with RGMII interface,
+		 * Fall back to delay macro circuit for 10/100Mbps link speed.
+		 */
+		if (speed == SPEED_1000)
+			regmap_update_bits(priv_plat->peri_regmap,
+					   MT8195_PERI_ETH_CTRL0,
+					   MT8195_RGMII_TXC_PHASE_CTRL |
+					   MT8195_DLY_GTXC_ENABLE |
+					   MT8195_DLY_GTXC_INV |
+					   MT8195_DLY_GTXC_STAGES,
+					   MT8195_RGMII_TXC_PHASE_CTRL);
+		else
+			mt8195_set_delay(priv_plat);
+	}
+}
+
+static const struct mediatek_dwmac_variant mt8195_gmac_variant = {
+	.dwmac_set_phy_interface = mt8195_set_interface,
+	.dwmac_set_delay = mt8195_set_delay,
+	.dwmac_fix_mac_speed = mt8195_fix_mac_speed,
+	.clk_list = mt8195_dwmac_clk_l,
+	.num_clks = ARRAY_SIZE(mt8195_dwmac_clk_l),
+	.dma_bit_mask = 35,
+	.rx_delay_max = 9280,
+	.tx_delay_max = 9280,
+};
+
 static int mediatek_dwmac_config_dt(struct mediatek_dwmac_plat_data *plat)
 {
 	struct mac_delay_struct *mac_delay = &plat->mac_delay;
@@ -307,6 +538,7 @@ static int mediatek_dwmac_config_dt(struct mediatek_dwmac_plat_data *plat)
 	mac_delay->rx_inv = of_property_read_bool(plat->np, "mediatek,rxc-inverse");
 	plat->rmii_rxc = of_property_read_bool(plat->np, "mediatek,rmii-rxc");
 	plat->rmii_clk_from_mac = of_property_read_bool(plat->np, "mediatek,rmii-clk-from-mac");
+	plat->mac_wol = of_property_read_bool(plat->np, "mediatek,mac-wol");
 
 	return 0;
 }
@@ -383,6 +615,7 @@ static int mediatek_dwmac_clks_config(void *priv, bool enabled)
 
 	return ret;
 }
+
 static int mediatek_dwmac_probe(struct platform_device *pdev)
 {
 	struct mediatek_dwmac_plat_data *priv_plat;
@@ -420,7 +653,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 		return PTR_ERR(plat_dat);
 
 	plat_dat->interface = priv_plat->phy_mode;
-	plat_dat->use_phy_wol = 1;
+	plat_dat->use_phy_wol = priv_plat->mac_wol ? 0 : 1;
 	plat_dat->riwt_off = 1;
 	plat_dat->maxmtu = ETH_DATA_LEN;
 	plat_dat->addr64 = priv_plat->variant->dma_bit_mask;
@@ -428,7 +661,23 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	plat_dat->init = mediatek_dwmac_init;
 	plat_dat->exit = mediatek_dwmac_exit;
 	plat_dat->clks_config = mediatek_dwmac_clks_config;
+	if (priv_plat->variant->dwmac_fix_mac_speed)
+		plat_dat->fix_mac_speed = priv_plat->variant->dwmac_fix_mac_speed;
+	plat_dat->safety_feat_cfg = devm_kzalloc(&pdev->dev,
+						 sizeof(*plat_dat->safety_feat_cfg),
+						 GFP_KERNEL);
+	if (!plat_dat->safety_feat_cfg)
+		return -ENOMEM;
 
+	plat_dat->safety_feat_cfg->tsoee = 1;
+	plat_dat->safety_feat_cfg->mrxpee = 0;
+	plat_dat->safety_feat_cfg->mestee = 1;
+	plat_dat->safety_feat_cfg->mrxee = 1;
+	plat_dat->safety_feat_cfg->mtxee = 1;
+	plat_dat->safety_feat_cfg->epsi = 0;
+	plat_dat->safety_feat_cfg->edpp = 1;
+	plat_dat->safety_feat_cfg->prtyen = 1;
+	plat_dat->safety_feat_cfg->tmouten = 1;
 	mediatek_dwmac_init(pdev, priv_plat);
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
@@ -443,6 +692,8 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 static const struct of_device_id mediatek_dwmac_match[] = {
 	{ .compatible = "mediatek,mt2712-gmac",
 	  .data = &mt2712_gmac_variant },
+	{ .compatible = "mediatek,mt8195-gmac",
+	  .data = &mt8195_gmac_variant },
 	{ }
 };
 
-- 
2.25.1

