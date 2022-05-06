Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223B251D7EB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392075AbiEFMgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392067AbiEFMgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:36:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078B869488;
        Fri,  6 May 2022 05:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE7761FED;
        Fri,  6 May 2022 12:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B7BC385B3;
        Fri,  6 May 2022 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840312;
        bh=tRD9Tqg15HkPfzwCdyKm3RnNZT7LidDawk/NckaU7/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YA31paLlmy4HWIhbZt2Cn5zjxOEYra5eM5uUuuDcbJQxx5qJLrTDTuVjviA2V5onS
         jFtJa9sRW2fb18btX+hMQoUmb5YpjdzAX44+o0QOBO16SvyL+iHetHBdHZULI2CXOp
         CmncH0gDacLVqlDvCqSV4rmh9gBM/XTZoRa9hAHmyamjkwhUVdsJtsoAAF4W6VrP/K
         BnsKQRYzscks9G+NQ7SMCABcNpMZgJ6c+c9I+ZQb0f5BXl3T1i8NwiQvCnqSxs7pMU
         6pqL1udseVVrNbFdirxXIC2KpPrvPfy/MkIubG+xBU4JKew9GaT2tttnhl6CfyIWkh
         Cp7CetNTvJJAA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 14/14] net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset
Date:   Fri,  6 May 2022 14:30:31 +0200
Message-Id: <11779867f45cfe78213eaa6bfe9e19c4ffd6e6aa.1651839494.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651839494.git.lorenzo@kernel.org>
References: <cover.1651839494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for mt7986-eth driver available on mt7986 soc.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 29 ++++++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 18 +++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f5da7e10c62e..99b1d48896f3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -45,6 +45,17 @@ static const u32 mtk_reg_map[] = {
 	[MTK_PDMA_RSS_GLO_BASE]			= 0x3000,
 };
 
+static const u32 mt7986_reg_map[] = {
+	[MTK_PDMA_BASE]				= 0x6000,
+	[MTK_PDMA_LRO_CTRL]			= 0x6408,
+	[MTK_PDMA_ALT_SCORE_DELTA_BASE]		= 0x641c,
+	[MTK_PDMA_LRO_RX_RING_DIP_BASE]		= 0x6414,
+	[MTK_PDMA_LRO_RX_RING_CTRL_BASE]	= 0x6438,
+	[MTK_QDMA_BASE]				= 0x4400,
+	[MTK_GDM1_TX_STAT_BASE]			= 0x1c00,
+	[MTK_PDMA_RSS_GLO_BASE]			= 0x6800,
+};
+
 /* strings used by ethtool */
 static const struct mtk_ethtool_stats {
 	char str[ETH_GSTRING_LEN];
@@ -68,7 +79,7 @@ static const char * const mtk_clks_source_name[] = {
 	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "trgpll",
 	"sgmii_tx250m", "sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb",
 	"sgmii2_tx250m", "sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb",
-	"sgmii_ck", "eth2pll",
+	"sgmii_ck", "eth2pll", "wocpu0", "wocpu1", "netsys0", "netsys1"
 };
 
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg)
@@ -3674,6 +3685,21 @@ static const struct mtk_soc_data mt7629_data = {
 	},
 };
 
+static const struct mtk_soc_data mt7986_data = {
+	.reg_map = mt7986_reg_map,
+	.ana_rgc3 = 0x128,
+	.caps = MT7986_CAPS,
+	.required_clks = MT7986_CLKS_BITMAP,
+	.required_pctl = false,
+	.txrx = {
+		.txd_size = sizeof(struct mtk_tx_dma_v2),
+		.rxd_size = sizeof(struct mtk_rx_dma_v2),
+		.rx_irq_done_mask = MTK_RX_DONE_INT_V2,
+		.dma_max_len = MTK_TX_DMA_BUF_LEN_V2,
+		.dma_len_offset = 8,
+	},
+};
+
 static const struct mtk_soc_data rt5350_data = {
 	.reg_map = mtk_reg_map,
 	.caps = MT7628_CAPS,
@@ -3696,6 +3722,7 @@ const struct of_device_id of_mtk_match[] = {
 	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data},
 	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data},
 	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data},
+	{ .compatible = "mediatek,mt7986-eth", .data = &mt7986_data},
 	{ .compatible = "ralink,rt5350-eth", .data = &rt5350_data},
 	{},
 };
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 58c448f165e5..5cae2905e11e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -766,6 +766,10 @@ enum mtk_clks_map {
 	MTK_CLK_SGMII2_CDR_FB,
 	MTK_CLK_SGMII_CK,
 	MTK_CLK_ETH2PLL,
+	MTK_CLK_WOCPU0,
+	MTK_CLK_WOCPU1,
+	MTK_CLK_NETSYS0,
+	MTK_CLK_NETSYS1,
 	MTK_CLK_MAX
 };
 
@@ -796,6 +800,16 @@ enum mtk_clks_map {
 				 BIT(MTK_CLK_SGMII2_CDR_FB) | \
 				 BIT(MTK_CLK_SGMII_CK) | \
 				 BIT(MTK_CLK_ETH2PLL) | BIT(MTK_CLK_SGMIITOP))
+#define MT7986_CLKS_BITMAP	(BIT(MTK_CLK_FE) | BIT(MTK_CLK_GP2) | BIT(MTK_CLK_GP1) | \
+				 BIT(MTK_CLK_WOCPU1) | BIT(MTK_CLK_WOCPU0) | \
+				 BIT(MTK_CLK_SGMII_TX_250M) | \
+				 BIT(MTK_CLK_SGMII_RX_250M) | \
+				 BIT(MTK_CLK_SGMII_CDR_REF) | \
+				 BIT(MTK_CLK_SGMII_CDR_FB) | \
+				 BIT(MTK_CLK_SGMII2_TX_250M) | \
+				 BIT(MTK_CLK_SGMII2_RX_250M) | \
+				 BIT(MTK_CLK_SGMII2_CDR_REF) | \
+				 BIT(MTK_CLK_SGMII2_CDR_FB))
 
 enum mtk_dev_state {
 	MTK_HW_INIT,
@@ -996,6 +1010,10 @@ enum mkt_eth_capabilities {
 		      MTK_MUX_U3_GMAC2_TO_QPHY | \
 		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA)
 
+#define MT7986_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | \
+		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA | \
+		      MTK_SRAM | MTK_NETSYS_V2 | MTK_RSTCTRL_PPE1)
+
 struct mtk_tx_dma_desc_info {
 	dma_addr_t addr;
 	u32 size;
-- 
2.35.1

