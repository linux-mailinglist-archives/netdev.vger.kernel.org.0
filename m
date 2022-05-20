Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045A252F243
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349864AbiETSNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352478AbiETSNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:13:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02DB18DAC9;
        Fri, 20 May 2022 11:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE7A60FF1;
        Fri, 20 May 2022 18:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237DAC385A9;
        Fri, 20 May 2022 18:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070391;
        bh=E8tljpchCGmJskUxuHASB8oeOunLLFM4mfYDUlKkfUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSVJtNXtKKTRpmFiZQ5fxnbktiLDrKGXjQOW/ju9nFLwyVuAVC+pK0v592yrnoDWd
         xtHF71AutTyBcQKLbpN6vcUB+YAeB9oj5ws7L6fCFjaFPXrE601tRidDyCnBXJBXof
         xAHPorJ0vslCWMHMjIXr23bN0nU6oHM9HbCvA/TulhinuMXaabHZ00xoQ4/HZsiMhX
         1CckL4ah/bUv3KLKB76pcuAmrewuIyXrhtQ4UrgIYhho9AutoZ7DMBxCbyX/TgGHSY
         tV5ny4tFvsuM49/PsYqboAfCgKD/Em8I7zypSz9BdP+Mds8/dQVyNelYZYBtkfJPr2
         A1WyoVWKAUXaw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 16/16] net: ethernet: mtk_eth_soc: introduce support for mt7986 chipset
Date:   Fri, 20 May 2022 20:11:39 +0200
Message-Id: <7bafe3ef8140b8743add6350ee2f8faefc858f1c.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 55 ++++++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 18 +++++++
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c034fd90dbdc..a9d4fd8945bb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -87,6 +87,43 @@ static const struct mtk_reg_map mt7628_reg_map = {
 	},
 };
 
+static const struct mtk_reg_map mt7986_reg_map = {
+	.tx_irq_mask		= 0x461c,
+	.tx_irq_status		= 0x4618,
+	.pdma = {
+		.rx_ptr		= 0x6100,
+		.rx_cnt_cfg	= 0x6104,
+		.pcrx_ptr	= 0x6108,
+		.glo_cfg	= 0x6204,
+		.rst_idx	= 0x6208,
+		.delay_irq	= 0x620c,
+		.irq_status	= 0x6220,
+		.irq_mask	= 0x6228,
+		.int_grp	= 0x6250,
+	},
+	.qdma = {
+		.qtx_cfg	= 0x4400,
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
+	},
+	.gdm1_cnt		= 0x1c00,
+};
+
 /* strings used by ethtool */
 static const struct mtk_ethtool_stats {
 	char str[ETH_GSTRING_LEN];
@@ -110,7 +147,7 @@ static const char * const mtk_clks_source_name[] = {
 	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "trgpll",
 	"sgmii_tx250m", "sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb",
 	"sgmii2_tx250m", "sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb",
-	"sgmii_ck", "eth2pll",
+	"sgmii_ck", "eth2pll", "wocpu0", "wocpu1", "netsys0", "netsys1"
 };
 
 void mtk_w32(struct mtk_eth *eth, u32 val, unsigned reg)
@@ -3694,6 +3731,21 @@ static const struct mtk_soc_data mt7629_data = {
 	},
 };
 
+static const struct mtk_soc_data mt7986_data = {
+	.reg_map = &mt7986_reg_map,
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
 	.reg_map = &mt7628_reg_map,
 	.caps = MT7628_CAPS,
@@ -3716,6 +3768,7 @@ const struct of_device_id of_mtk_match[] = {
 	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data},
 	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data},
 	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data},
+	{ .compatible = "mediatek,mt7986-eth", .data = &mt7986_data},
 	{ .compatible = "ralink,rt5350-eth", .data = &rt5350_data},
 	{},
 };
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 67482124de2a..0a632896451a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -627,6 +627,10 @@ enum mtk_clks_map {
 	MTK_CLK_SGMII2_CDR_FB,
 	MTK_CLK_SGMII_CK,
 	MTK_CLK_ETH2PLL,
+	MTK_CLK_WOCPU0,
+	MTK_CLK_WOCPU1,
+	MTK_CLK_NETSYS0,
+	MTK_CLK_NETSYS1,
 	MTK_CLK_MAX
 };
 
@@ -657,6 +661,16 @@ enum mtk_clks_map {
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
@@ -855,6 +869,10 @@ enum mkt_eth_capabilities {
 		      MTK_MUX_U3_GMAC2_TO_QPHY | \
 		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA)
 
+#define MT7986_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | \
+		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA | \
+		      MTK_NETSYS_V2 | MTK_RSTCTRL_PPE1)
+
 struct mtk_tx_dma_desc_info {
 	dma_addr_t	addr;
 	u32		size;
-- 
2.35.3

