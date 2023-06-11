Return-Path: <netdev+bounces-9861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F9F572AFDD
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E4AE281404
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3518D10E9;
	Sun, 11 Jun 2023 00:44:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216547F0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:44:26 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2BA35B0;
	Sat, 10 Jun 2023 17:44:24 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1q89Bs-0005Gv-2F;
	Sun, 11 Jun 2023 00:44:20 +0000
Date: Sun, 11 Jun 2023 01:43:37 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: [PATCH net-next 8/8] net: ethernet: mtk_eth_soc: add basic support
 for MT7988 SoC
Message-ID: <ZIUYubFtVGYHhlMt@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce support for ethernet chip available in MT7988 SoC to
mtk_eth_soc driver. As a first step support only the first GMAC which
is hard-wired to the internal DSA switch having 4 built-in gigabit
Ethernet PHYs.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_path.c |  11 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 205 +++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  |  85 +++++++-
 3 files changed, 279 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 34ac492e047cb..bc8e7e3121ac4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -42,8 +42,8 @@ static const char *mtk_eth_path_name(u64 path)
 
 static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, u64 path)
 {
+	u32 val, mask, set, reg;
 	bool updated = true;
-	u32 val, mask, set;
 
 	switch (path) {
 	case MTK_ETH_PATH_GMAC1_SGMII:
@@ -59,10 +59,15 @@ static int set_mux_gdm1_to_gmac1_esw(struct mtk_eth *eth, u64 path)
 		break;
 	}
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3))
+		reg = MTK_MAC_MISC_V3;
+	else
+		reg = MTK_MAC_MISC;
+
 	if (updated) {
-		val = mtk_r32(eth, MTK_MAC_MISC);
+		val = mtk_r32(eth, reg);
 		val = (val & mask) | set;
-		mtk_w32(eth, val, MTK_MAC_MISC);
+		mtk_w32(eth, val, reg);
 	}
 
 	dev_dbg(eth->dev, "path %s in %s updated = %d\n",
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d516917effca6..b2e674e3e3c49 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -152,6 +152,54 @@ static const struct mtk_reg_map mt7986_reg_map = {
 	.pse_oq_sta		= 0x01a0,
 };
 
+static const struct mtk_reg_map mt7988_reg_map = {
+	.tx_irq_mask		= 0x461c,
+	.tx_irq_status		= 0x4618,
+	.pdma = {
+		.rx_ptr		= 0x6900,
+		.rx_cnt_cfg	= 0x6904,
+		.pcrx_ptr	= 0x6908,
+		.glo_cfg	= 0x6a04,
+		.rst_idx	= 0x6a08,
+		.delay_irq	= 0x6a0c,
+		.irq_status	= 0x6a20,
+		.irq_mask	= 0x6a28,
+		.adma_rx_dbg0	= 0x6a38,
+		.int_grp	= 0x6a50,
+	},
+	.qdma = {
+		.qtx_cfg	= 0x4400,
+		.qtx_sch	= 0x4404,
+		.rx_ptr		= 0x4500,
+		.rx_cnt_cfg	= 0x4504,
+		.qcrx_ptr	= 0x4508,
+		.glo_cfg	= 0x4604,
+		.rst_idx	= 0x4608,
+		.delay_irq	= 0x460c,
+		.fc_th		= 0x4610,
+		.int_grp	= 0x4620,
+		.hred		= 0x4644,
+		.ctx_ptr	= 0x4700,
+		.dtx_ptr	= 0x4704,
+		.crx_ptr	= 0x4710,
+		.drx_ptr	= 0x4714,
+		.fq_head	= 0x4720,
+		.fq_tail	= 0x4724,
+		.fq_count	= 0x4728,
+		.fq_blen	= 0x472c,
+		.tx_sch_rate	= 0x4798,
+	},
+	.gdm1_cnt		= 0x1c00,
+	.gdma_to_ppe		= 0x3333,
+	.ppe_base		= 0x2200,
+	.wdma_base = {
+		[0]		= 0x4800,
+		[1]		= 0x4c00,
+	},
+	.pse_iq_sta		= 0x0180,
+	.pse_oq_sta		= 0x01a0,
+};
+
 /* strings used by ethtool */
 static const struct mtk_ethtool_stats {
 	char str[ETH_GSTRING_LEN];
@@ -179,10 +227,54 @@ static const struct mtk_ethtool_stats {
 };
 
 static const char * const mtk_clks_source_name[] = {
-	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "trgpll",
-	"sgmii_tx250m", "sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb",
-	"sgmii2_tx250m", "sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb",
-	"sgmii_ck", "eth2pll", "wocpu0", "wocpu1", "netsys0", "netsys1"
+	"ethif",
+	"sgmiitop",
+	"esw",
+	"gp0",
+	"gp1",
+	"gp2",
+	"gp3",
+	"xgp1",
+	"xgp2",
+	"xgp3",
+	"crypto",
+	"fe",
+	"trgpll",
+	"sgmii_tx250m",
+	"sgmii_rx250m",
+	"sgmii_cdr_ref",
+	"sgmii_cdr_fb",
+	"sgmii2_tx250m",
+	"sgmii2_rx250m",
+	"sgmii2_cdr_ref",
+	"sgmii2_cdr_fb",
+	"sgmii_ck",
+	"eth2pll",
+	"wocpu0",
+	"wocpu1",
+	"netsys0",
+	"netsys1",
+	"ethwarp_wocpu2",
+	"ethwarp_wocpu1",
+	"ethwarp_wocpu0",
+	"top_usxgmii0_sel",
+	"top_usxgmii1_sel",
+	"top_sgm0_sel",
+	"top_sgm1_sel",
+	"top_xfi_phy0_xtal_sel",
+	"top_xfi_phy1_xtal_sel",
+	"top_eth_gmii_sel",
+	"top_eth_refck_50m_sel",
+	"top_eth_sys_200m_sel",
+	"top_eth_sys_sel",
+	"top_eth_xgmii_sel",
+	"top_eth_mii_sel",
+	"top_netsys_sel",
+	"top_netsys_500m_sel",
+	"top_netsys_pao_2x_sel",
+	"top_netsys_sync_250m_sel",
+	"top_netsys_ppefb_250m_sel",
+	"top_netsys_warp_sel",
 };
 
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg)
@@ -425,6 +517,23 @@ static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth,
 	mtk_w32(eth, tck, TRGMII_TCK_CTRL);
 }
 
+static void mtk_setup_bridge_switch(struct mtk_eth *eth)
+{
+	int val;
+
+	/* Force Port1 XGMAC Link Up */
+	val = mtk_r32(eth, MTK_XGMAC_STS(MTK_GMAC1_ID));
+	mtk_w32(eth, val | MTK_XGMAC_FORCE_LINK(MTK_GMAC1_ID),
+		MTK_XGMAC_STS(MTK_GMAC1_ID));
+
+	/* Adjust GSW bridge IPG to 11 */
+	val = mtk_r32(eth, MTK_GSW_CFG);
+	val &= ~(GSWTX_IPG_MASK | GSWRX_IPG_MASK);
+	val |= (GSW_IPG_11 << GSWTX_IPG_SHIFT) |
+	       (GSW_IPG_11 << GSWRX_IPG_SHIFT);
+	mtk_w32(eth, val, MTK_GSW_CFG);
+}
+
 static struct phylink_pcs *mtk_mac_select_pcs(struct phylink_config *config,
 					      phy_interface_t interface)
 {
@@ -484,6 +593,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 					goto init_err;
 			}
 			break;
+		case PHY_INTERFACE_MODE_INTERNAL:
+			break;
 		default:
 			goto err_phy;
 		}
@@ -562,6 +673,15 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		return;
 	}
 
+	/* Setup gmac */
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3) &&
+	    mac->interface == PHY_INTERFACE_MODE_INTERNAL) {
+		mtk_w32(mac->hw, MTK_GDMA_XGDM_SEL, MTK_GDMA_EG_CTRL(mac->id));
+		mtk_w32(mac->hw, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(mac->id));
+
+		mtk_setup_bridge_switch(eth);
+	}
+
 	return;
 
 err_phy:
@@ -807,10 +927,20 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 	}
 	divider = min_t(unsigned int, DIV_ROUND_UP(MDC_MAX_FREQ, max_clk), 63);
 
-	/* Configure MDC Divider */
+	/* Configure MDC Turbo Mode */
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3)) {
+		val = mtk_r32(eth, MTK_MAC_MISC_V3);
+		val |= MISC_MDC_TURBO;
+		mtk_w32(eth, val, MTK_MAC_MISC_V3);
+	}
 	val = mtk_r32(eth, MTK_PPSC);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1) ||
+	    MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		val |= PPSC_MDC_TURBO;
+
+	/* Configure MDC Divider */
 	val &= ~PPSC_MDC_CFG;
-	val |= FIELD_PREP(PPSC_MDC_CFG, divider) | PPSC_MDC_TURBO;
+	val |= FIELD_PREP(PPSC_MDC_CFG, divider);
 	mtk_w32(eth, val, MTK_PPSC);
 
 	dev_dbg(eth->dev, "MDC is running on %d Hz\n", MDC_MAX_FREQ / divider);
@@ -1272,10 +1402,19 @@ static void mtk_tx_set_dma_desc_v2(struct net_device *dev, void *txd,
 		data |= TX_DMA_LS0;
 	WRITE_ONCE(desc->txd3, data);
 
-	if (mac->id == MTK_GMAC3_ID)
-		data = PSE_GDM3_PORT;
-	else
-		data = (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
+	 /* set forward port */
+	switch (mac->id) {
+	case MTK_GMAC1_ID:
+		data = PSE_GDM1_PORT << TX_DMA_FPORT_SHIFT_V2;
+		break;
+	case MTK_GMAC2_ID:
+		data = PSE_GDM2_PORT << TX_DMA_FPORT_SHIFT_V2;
+		break;
+	case MTK_GMAC3_ID:
+		data = PSE_GDM3_PORT << TX_DMA_FPORT_SHIFT_V2;
+		break;
+	}
+
 	data |= TX_DMA_SWC_V2 | QID_BITS_V2(info->qid);
 	WRITE_ONCE(desc->txd4, data);
 
@@ -4475,6 +4614,17 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 			  mac->phylink_config.supported_interfaces);
 	}
 
+	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_NETSYS_V3_BIT) &&
+	    MTK_HAS_CAPS(mac->hw->soc->caps, MTK_ESW_BIT) &&
+	    id == MTK_GMAC1_ID) {
+		mac->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
+						       MAC_SYM_PAUSE |
+						       MAC_10000FD;
+		phy_interface_zero(mac->phylink_config.supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  mac->phylink_config.supported_interfaces);
+	}
+
 	phylink = phylink_create(&mac->phylink_config,
 				 of_fwnode_handle(mac->of_node),
 				 phy_mode, &mtk_phylink_ops);
@@ -5018,6 +5168,24 @@ static const struct mtk_soc_data mt7986_data = {
 	},
 };
 
+static const struct mtk_soc_data mt7988_data = {
+	.reg_map = &mt7988_reg_map,
+	.ana_rgc3 = 0x128,
+	.caps = MT7988_CAPS,
+	.hw_features = MTK_HW_FEATURES,
+	.required_clks = MT7988_CLKS_BITMAP,
+	.required_pctl = false,
+	.num_devs = 3,
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
 static const struct mtk_soc_data rt5350_data = {
 	.reg_map = &mt7628_reg_map,
 	.caps = MT7628_CAPS,
@@ -5036,14 +5204,15 @@ static const struct mtk_soc_data rt5350_data = {
 };
 
 const struct of_device_id of_mtk_match[] = {
-	{ .compatible = "mediatek,mt2701-eth", .data = &mt2701_data},
-	{ .compatible = "mediatek,mt7621-eth", .data = &mt7621_data},
-	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data},
-	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data},
-	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data},
-	{ .compatible = "mediatek,mt7981-eth", .data = &mt7981_data},
-	{ .compatible = "mediatek,mt7986-eth", .data = &mt7986_data},
-	{ .compatible = "ralink,rt5350-eth", .data = &rt5350_data},
+	{ .compatible = "mediatek,mt2701-eth", .data = &mt2701_data },
+	{ .compatible = "mediatek,mt7621-eth", .data = &mt7621_data },
+	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data },
+	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data },
+	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data },
+	{ .compatible = "mediatek,mt7981-eth", .data = &mt7981_data },
+	{ .compatible = "mediatek,mt7986-eth", .data = &mt7986_data },
+	{ .compatible = "mediatek,mt7988-eth", .data = &mt7988_data },
+	{ .compatible = "ralink,rt5350-eth", .data = &rt5350_data },
 	{},
 };
 MODULE_DEVICE_TABLE(of, of_mtk_match);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index b941a136eb7e0..7279ac7dc37a2 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -117,7 +117,8 @@
 #define MTK_CDMP_EG_CTRL	0x404
 
 /* GDM Exgress Control Register */
-#define MTK_GDMA_FWD_CFG(x)	(0x500 + (x * 0x1000))
+#define MTK_GDMA_FWD_CFG(x)	({ typeof(x) _x = (x); (_x == MTK_GMAC3_ID) ?	\
+				   0x540 : 0x500 + (_x * 0x1000); })
 #define MTK_GDMA_SPECIAL_TAG	BIT(24)
 #define MTK_GDMA_ICS_EN		BIT(22)
 #define MTK_GDMA_TCS_EN		BIT(21)
@@ -126,6 +127,11 @@
 #define MTK_GDMA_TO_PDMA	0x0
 #define MTK_GDMA_DROP_ALL       0x7777
 
+/* GDM Egress Control Register */
+#define MTK_GDMA_EG_CTRL(x)	({ typeof(x) _x = (x); (_x == MTK_GMAC3_ID) ?	\
+				   0x544 : 0x504 + (_x * 0x1000); })
+#define MTK_GDMA_XGDM_SEL	BIT(31)
+
 /* Unicast Filter MAC Address Register - Low */
 #define MTK_GDMA_MAC_ADRL(x)	(0x508 + (x * 0x1000))
 
@@ -389,7 +395,26 @@
 #define PHY_IAC_TIMEOUT		HZ
 
 #define MTK_MAC_MISC		0x1000c
+#define MTK_MAC_MISC_V3		0x10010
 #define MTK_MUX_TO_ESW		BIT(0)
+#define MISC_MDC_TURBO		BIT(4)
+
+/* XMAC status registers */
+#define MTK_XGMAC_STS(x)	(((x) == MTK_GMAC3_ID) ? 0x1001C : 0x1000C)
+#define MTK_XGMAC_FORCE_LINK(x)	(((x) == MTK_GMAC2_ID) ? BIT(31) : BIT(15))
+#define MTK_USXGMII_PCS_LINK	BIT(8)
+#define MTK_XGMAC_RX_FC		BIT(5)
+#define MTK_XGMAC_TX_FC		BIT(4)
+#define MTK_USXGMII_PCS_MODE	GENMASK(3, 1)
+#define MTK_XGMAC_LINK_STS	BIT(0)
+
+/* GSW bridge registers */
+#define MTK_GSW_CFG		(0x10080)
+#define GSWTX_IPG_MASK		GENMASK(19, 16)
+#define GSWTX_IPG_SHIFT		16
+#define GSWRX_IPG_MASK		GENMASK(3, 0)
+#define GSWRX_IPG_SHIFT		0
+#define GSW_IPG_11		11
 
 /* Mac control registers */
 #define MTK_MAC_MCR(x)		(0x10100 + (x * 0x100))
@@ -654,6 +679,11 @@ enum mtk_clks_map {
 	MTK_CLK_GP0,
 	MTK_CLK_GP1,
 	MTK_CLK_GP2,
+	MTK_CLK_GP3,
+	MTK_CLK_XGP1,
+	MTK_CLK_XGP2,
+	MTK_CLK_XGP3,
+	MTK_CLK_CRYPTO,
 	MTK_CLK_FE,
 	MTK_CLK_TRGPLL,
 	MTK_CLK_SGMII_TX_250M,
@@ -670,6 +700,27 @@ enum mtk_clks_map {
 	MTK_CLK_WOCPU1,
 	MTK_CLK_NETSYS0,
 	MTK_CLK_NETSYS1,
+	MTK_CLK_ETHWARP_WOCPU2,
+	MTK_CLK_ETHWARP_WOCPU1,
+	MTK_CLK_ETHWARP_WOCPU0,
+	MTK_CLK_TOP_USXGMII_SBUS_0_SEL,
+	MTK_CLK_TOP_USXGMII_SBUS_1_SEL,
+	MTK_CLK_TOP_SGM_0_SEL,
+	MTK_CLK_TOP_SGM_1_SEL,
+	MTK_CLK_TOP_XFI_PHY_0_XTAL_SEL,
+	MTK_CLK_TOP_XFI_PHY_1_XTAL_SEL,
+	MTK_CLK_TOP_ETH_GMII_SEL,
+	MTK_CLK_TOP_ETH_REFCK_50M_SEL,
+	MTK_CLK_TOP_ETH_SYS_200M_SEL,
+	MTK_CLK_TOP_ETH_SYS_SEL,
+	MTK_CLK_TOP_ETH_XGMII_SEL,
+	MTK_CLK_TOP_ETH_MII_SEL,
+	MTK_CLK_TOP_NETSYS_SEL,
+	MTK_CLK_TOP_NETSYS_500M_SEL,
+	MTK_CLK_TOP_NETSYS_PAO_2X_SEL,
+	MTK_CLK_TOP_NETSYS_SYNC_250M_SEL,
+	MTK_CLK_TOP_NETSYS_PPEFB_250M_SEL,
+	MTK_CLK_TOP_NETSYS_WARP_SEL,
 	MTK_CLK_MAX
 };
 
@@ -723,6 +774,36 @@ enum mtk_clks_map {
 				 BIT_ULL(MTK_CLK_SGMII2_RX_250M) | \
 				 BIT_ULL(MTK_CLK_SGMII2_CDR_REF) | \
 				 BIT_ULL(MTK_CLK_SGMII2_CDR_FB))
+#define MT7988_CLKS_BITMAP	(BIT_ULL(MTK_CLK_FE) | BIT_ULL(MTK_CLK_ESW) | \
+				 BIT_ULL(MTK_CLK_GP1) | BIT_ULL(MTK_CLK_GP2) | \
+				 BIT_ULL(MTK_CLK_GP3) | BIT_ULL(MTK_CLK_XGP1) | \
+				 BIT_ULL(MTK_CLK_XGP2) | BIT_ULL(MTK_CLK_XGP3) | \
+				 BIT_ULL(MTK_CLK_CRYPTO) | \
+				 BIT_ULL(MTK_CLK_SGMII_TX_250M) | \
+				 BIT_ULL(MTK_CLK_SGMII_RX_250M) | \
+				 BIT_ULL(MTK_CLK_SGMII2_TX_250M) | \
+				 BIT_ULL(MTK_CLK_SGMII2_RX_250M) | \
+				 BIT_ULL(MTK_CLK_ETHWARP_WOCPU2) | \
+				 BIT_ULL(MTK_CLK_ETHWARP_WOCPU1) | \
+				 BIT_ULL(MTK_CLK_ETHWARP_WOCPU0) | \
+				 BIT_ULL(MTK_CLK_TOP_USXGMII_SBUS_0_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_USXGMII_SBUS_1_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_SGM_0_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_SGM_1_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_XFI_PHY_0_XTAL_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_XFI_PHY_1_XTAL_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_ETH_GMII_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_ETH_REFCK_50M_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_ETH_SYS_200M_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_ETH_SYS_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_ETH_XGMII_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_ETH_MII_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_NETSYS_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_NETSYS_500M_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_NETSYS_PAO_2X_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_NETSYS_SYNC_250M_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_NETSYS_PPEFB_250M_SEL) | \
+				 BIT_ULL(MTK_CLK_TOP_NETSYS_WARP_SEL))
 
 enum mtk_dev_state {
 	MTK_HW_INIT,
@@ -981,6 +1062,8 @@ enum mkt_eth_capabilities {
 		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA | \
 		      MTK_NETSYS_V2 | MTK_RSTCTRL_PPE1)
 
+#define MT7988_CAPS  (MTK_GDM1_ESW | MTK_QDMA | MTK_NETSYS_V3 | MTK_RSTCTRL_PPE1)
+
 struct mtk_tx_dma_desc_info {
 	dma_addr_t	addr;
 	u32		size;
-- 
2.41.0


