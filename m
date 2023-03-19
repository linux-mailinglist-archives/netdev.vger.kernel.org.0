Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61A46C01CA
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 13:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjCSM6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCSM6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 08:58:10 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3F71EBE5;
        Sun, 19 Mar 2023 05:58:08 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pdsbu-0001G1-2Z;
        Sun, 19 Mar 2023 13:58:06 +0100
Date:   Sun, 19 Mar 2023 12:56:28 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH net-next v14 1/9] net: ethernet: mtk_eth_soc: add support for
 MT7981 SoC
Message-ID: <0f422ab57b4f4eb31a3a00ab4f033ef7a28cedda.1679230025.git.daniel@makrotopia.org>
References: <cover.1679230025.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1679230025.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MediaTek MT7981 SoC comes with two 1G/2.5G SGMII ports, just like
MT7986.

In addition MT7981 is equipped with a built-in 1000Base-T PHY which can
be used with GMAC1.

As many MT7981 boards make use of inverting SGMII signal polarity, add
new device-tree attribute 'mediatek,pn_swap' to support them.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c | 14 +++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 21 +++++++++++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  | 31 ++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_sgmii.c    | 10 +++++++
 4 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 72648535a14d..317e447f4991 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -96,12 +96,20 @@ static int set_mux_gmac2_gmac0_to_gephy(struct mtk_eth *eth, int path)
 
 static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, int path)
 {
-	unsigned int val = 0;
+	unsigned int val = 0, mask = 0, reg = 0;
 	bool updated = true;
 
 	switch (path) {
 	case MTK_ETH_PATH_GMAC2_SGMII:
-		val = CO_QPHY_SEL;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_U3_COPHY_V2)) {
+			reg = USB_PHY_SWITCH_REG;
+			val = SGMII_QPHY_SEL;
+			mask = QPHY_SEL_MASK;
+		} else {
+			reg = INFRA_MISC2;
+			val = CO_QPHY_SEL;
+			mask = val;
+		}
 		break;
 	default:
 		updated = false;
@@ -109,7 +117,7 @@ static int set_mux_u3_gmac2_to_qphy(struct mtk_eth *eth, int path)
 	}
 
 	if (updated)
-		regmap_update_bits(eth->infra, INFRA_MISC2, CO_QPHY_SEL, val);
+		regmap_update_bits(eth->infra, reg, mask, val);
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
 		mtk_eth_path_name(path), __func__, updated);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 52aa71f0c499..40490197e124 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4846,6 +4846,26 @@ static const struct mtk_soc_data mt7629_data = {
 	},
 };
 
+static const struct mtk_soc_data mt7981_data = {
+	.reg_map = &mt7986_reg_map,
+	.ana_rgc3 = 0x128,
+	.caps = MT7981_CAPS,
+	.hw_features = MTK_HW_FEATURES,
+	.required_clks = MT7981_CLKS_BITMAP,
+	.required_pctl = false,
+	.offload_version = 2,
+	.hash_offset = 4,
+	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma_v2),
+		.rxd_size = sizeof(struct mtk_rx_dma_v2),
+		.rx_irq_done_mask = MTK_RX_DONE_INT_V2,
+		.rx_dma_l4_valid = RX_DMA_L4_VALID_V2,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN_V2,
+		.dma_len_offset = 8,
+	},
+};
+
 static const struct mtk_soc_data mt7986_data = {
 	.reg_map = &mt7986_reg_map,
 	.ana_rgc3 = 0x128,
@@ -4888,6 +4908,7 @@ const struct of_device_id of_mtk_match[] = {
 	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data},
 	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data},
 	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data},
+	{ .compatible = "mediatek,mt7981-eth", .data = &mt7981_data},
 	{ .compatible = "mediatek,mt7986-eth", .data = &mt7986_data},
 	{ .compatible = "ralink,rt5350-eth", .data = &rt5350_data},
 	{},
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 084a6badef6d..adf01f894b02 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -556,11 +556,22 @@
 #define SGMSYS_QPHY_PWR_STATE_CTRL 0xe8
 #define	SGMII_PHYA_PWD		BIT(4)
 
+/* Register to QPHY wrapper control */
+#define SGMSYS_QPHY_WRAP_CTRL	0xec
+#define SGMII_PN_SWAP_MASK	GENMASK(1, 0)
+#define SGMII_PN_SWAP_TX_RX	(BIT(0) | BIT(1))
+#define MTK_SGMII_FLAG_PN_SWAP	BIT(0)
+
 /* Infrasys subsystem config registers */
 #define INFRA_MISC2            0x70c
 #define CO_QPHY_SEL            BIT(0)
 #define GEPHY_MAC_SEL          BIT(1)
 
+/* Top misc registers */
+#define USB_PHY_SWITCH_REG	0x218
+#define QPHY_SEL_MASK		GENMASK(1, 0)
+#define SGMII_QPHY_SEL		0x2
+
 /* MT7628/88 specific stuff */
 #define MT7628_PDMA_OFFSET	0x0800
 #define MT7628_SDM_OFFSET	0x0c00
@@ -741,6 +752,17 @@ enum mtk_clks_map {
 				 BIT(MTK_CLK_SGMII2_CDR_FB) | \
 				 BIT(MTK_CLK_SGMII_CK) | \
 				 BIT(MTK_CLK_ETH2PLL) | BIT(MTK_CLK_SGMIITOP))
+#define MT7981_CLKS_BITMAP	(BIT(MTK_CLK_FE) | BIT(MTK_CLK_GP2) | BIT(MTK_CLK_GP1) | \
+				 BIT(MTK_CLK_WOCPU0) | \
+				 BIT(MTK_CLK_SGMII_TX_250M) | \
+				 BIT(MTK_CLK_SGMII_RX_250M) | \
+				 BIT(MTK_CLK_SGMII_CDR_REF) | \
+				 BIT(MTK_CLK_SGMII_CDR_FB) | \
+				 BIT(MTK_CLK_SGMII2_TX_250M) | \
+				 BIT(MTK_CLK_SGMII2_RX_250M) | \
+				 BIT(MTK_CLK_SGMII2_CDR_REF) | \
+				 BIT(MTK_CLK_SGMII2_CDR_FB) | \
+				 BIT(MTK_CLK_SGMII_CK))
 #define MT7986_CLKS_BITMAP	(BIT(MTK_CLK_FE) | BIT(MTK_CLK_GP2) | BIT(MTK_CLK_GP1) | \
 				 BIT(MTK_CLK_WOCPU1) | BIT(MTK_CLK_WOCPU0) | \
 				 BIT(MTK_CLK_SGMII_TX_250M) | \
@@ -854,6 +876,7 @@ enum mkt_eth_capabilities {
 	MTK_NETSYS_V2_BIT,
 	MTK_SOC_MT7628_BIT,
 	MTK_RSTCTRL_PPE1_BIT,
+	MTK_U3_COPHY_V2_BIT,
 
 	/* MUX BITS*/
 	MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT,
@@ -888,6 +911,7 @@ enum mkt_eth_capabilities {
 #define MTK_NETSYS_V2		BIT(MTK_NETSYS_V2_BIT)
 #define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
 #define MTK_RSTCTRL_PPE1	BIT(MTK_RSTCTRL_PPE1_BIT)
+#define MTK_U3_COPHY_V2		BIT(MTK_U3_COPHY_V2_BIT)
 
 #define MTK_ETH_MUX_GDM1_TO_GMAC1_ESW		\
 	BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT)
@@ -960,6 +984,11 @@ enum mkt_eth_capabilities {
 		      MTK_MUX_U3_GMAC2_TO_QPHY | \
 		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA)
 
+#define MT7981_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | MTK_GMAC2_GEPHY | \
+		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA | \
+		      MTK_MUX_U3_GMAC2_TO_QPHY | MTK_U3_COPHY_V2 | \
+		      MTK_NETSYS_V2 | MTK_RSTCTRL_PPE1)
+
 #define MT7986_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | \
 		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA | \
 		      MTK_NETSYS_V2 | MTK_RSTCTRL_PPE1)
@@ -1073,12 +1102,14 @@ struct mtk_soc_data {
  * @ana_rgc3:          The offset refers to register ANA_RGC3 related to regmap
  * @interface:         Currently configured interface mode
  * @pcs:               Phylink PCS structure
+ * @flags:             Flags indicating hardware properties
  */
 struct mtk_pcs {
 	struct regmap	*regmap;
 	u32             ana_rgc3;
 	phy_interface_t	interface;
 	struct phylink_pcs pcs;
+	u32		flags;
 };
 
 /* struct mtk_sgmii -  This is the structure holding sgmii regmap and its
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 83976dc86887..61bd9986466a 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -91,6 +91,11 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		regmap_update_bits(mpcs->regmap, SGMII_RESERVED_0,
 				   SGMII_SW_RESET, SGMII_SW_RESET);
 
+		if (mpcs->flags & MTK_SGMII_FLAG_PN_SWAP)
+			regmap_update_bits(mpcs->regmap, SGMSYS_QPHY_WRAP_CTRL,
+					   SGMII_PN_SWAP_MASK,
+					   SGMII_PN_SWAP_TX_RX);
+
 		if (interface == PHY_INTERFACE_MODE_2500BASEX)
 			rgc3 = RG_PHY_SPEED_3_125G;
 		else
@@ -186,6 +191,11 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
 
 		ss->pcs[i].ana_rgc3 = ana_rgc3;
 		ss->pcs[i].regmap = syscon_node_to_regmap(np);
+
+		ss->pcs[i].flags = 0;
+		if (of_property_read_bool(np, "mediatek,pnswap"))
+			ss->pcs[i].flags |= MTK_SGMII_FLAG_PN_SWAP;
+
 		of_node_put(np);
 		if (IS_ERR(ss->pcs[i].regmap))
 			return PTR_ERR(ss->pcs[i].regmap);
-- 
2.39.2

