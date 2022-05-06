Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1061C51D7E9
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376945AbiEFMgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391985AbiEFMfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8887C69499;
        Fri,  6 May 2022 05:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C4361FE6;
        Fri,  6 May 2022 12:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF03C385A8;
        Fri,  6 May 2022 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651840306;
        bh=ERPlfUu7VtuohtPnwUkOy7C+W1XhpcE2U9qZL3NXtvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lG3+BMccJOZgmelgGI1ij9N0EY2n0lliO4SEys/39R9ult8GxyeeyrtMh740S5Ss3
         IawnwaT5GzjquoeKsm8JboQjSDqkqRZbsEOvV1jNnd8puG6SFfW5oBP69JpvbK/qoL
         oxGdyKAnK+O+aeUCuolgQqdoRfPaLUcEn9mu5cShJVeQitIT0ju8J8bZLMCk5gmhLO
         7zPMuGufS0fuJW32+8UFDuzZloj5A3DExeiNNOoarjpqamE/rZkoMAEr7ZpkBpmohg
         t5PxGgHAYrF7NYPIRnGh7I6r9It0spXat+DJ0NDMNnzlPY0xIwyXceZMvcJffmMlMl
         e9+W1G/xCeskQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: [PATCH net-next 12/14] net: ethernet: mtk_eth_soc: introduce device register map
Date:   Fri,  6 May 2022 14:30:29 +0200
Message-Id: <74c40f91f99bd3d035f7625090795b5d697b87eb.1651839494.git.lorenzo@kernel.org>
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

Introduce reg_map structure to add the capability to support different
register definitions.
This is a preliminary patch to introduce mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  17 +++
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 160 +++++++++++++-------
 2 files changed, 121 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 68ef9b8d30ce..30f649d6f921 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -34,6 +34,17 @@ MODULE_PARM_DESC(msg_level, "Message level (-1=defaults,0=none,...,16=all)");
 #define MTK_ETHTOOL_STAT(x) { #x, \
 			      offsetof(struct mtk_hw_stats, x) / sizeof(u64) }
 
+static const u32 mtk_reg_map[] = {
+	[MTK_PDMA_BASE]				= 0x0800,
+	[MTK_PDMA_LRO_CTRL]			= 0x0980,
+	[MTK_PDMA_ALT_SCORE_DELTA_BASE]		= 0x0a4c,
+	[MTK_PDMA_LRO_RX_RING_DIP_BASE]		= 0x0b04,
+	[MTK_PDMA_LRO_RX_RING_CTRL_BASE]	= 0x0b28,
+	[MTK_QDMA_BASE]				= 0x1800,
+	[MTK_GDM1_TX_STAT_BASE]			= 0x2400,
+	[MTK_PDMA_RSS_GLO_BASE]			= 0x3000,
+};
+
 /* strings used by ethtool */
 static const struct mtk_ethtool_stats {
 	char str[ETH_GSTRING_LEN];
@@ -3409,6 +3420,7 @@ static int mtk_remove(struct platform_device *pdev)
 }
 
 static const struct mtk_soc_data mt2701_data = {
+	.reg_map = mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
@@ -3420,6 +3432,7 @@ static const struct mtk_soc_data mt2701_data = {
 };
 
 static const struct mtk_soc_data mt7621_data = {
+	.reg_map = mtk_reg_map,
 	.caps = MT7621_CAPS,
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7621_CLKS_BITMAP,
@@ -3432,6 +3445,7 @@ static const struct mtk_soc_data mt7621_data = {
 };
 
 static const struct mtk_soc_data mt7622_data = {
+	.reg_map = mtk_reg_map,
 	.ana_rgc3 = 0x2028,
 	.caps = MT7622_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
@@ -3445,6 +3459,7 @@ static const struct mtk_soc_data mt7622_data = {
 };
 
 static const struct mtk_soc_data mt7623_data = {
+	.reg_map = mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
@@ -3457,6 +3472,7 @@ static const struct mtk_soc_data mt7623_data = {
 };
 
 static const struct mtk_soc_data mt7629_data = {
+	.reg_map = mtk_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7629_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
@@ -3469,6 +3485,7 @@ static const struct mtk_soc_data mt7629_data = {
 };
 
 static const struct mtk_soc_data rt5350_data = {
+	.reg_map = mtk_reg_map,
 	.caps = MT7628_CAPS,
 	.hw_features = MTK_HW_FEATURES_MT7628,
 	.required_clks = MT7628_CLKS_BITMAP,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 1919e6db9275..f49ff0e2ef87 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -19,6 +19,18 @@
 #include <linux/dim.h>
 #include "mtk_ppe.h"
 
+enum mtk_reg_base {
+	MTK_PDMA_BASE,
+	MTK_PDMA_LRO_CTRL,
+	MTK_PDMA_ALT_SCORE_DELTA_BASE,
+	MTK_PDMA_LRO_RX_RING_DIP_BASE,
+	MTK_PDMA_LRO_RX_RING_CTRL_BASE,
+	MTK_PDMA_RSS_GLO_BASE,
+	MTK_GDM1_TX_STAT_BASE,
+	MTK_QDMA_BASE,
+	__MT_BASE_MAX,
+};
+
 #define MTK_QDMA_PAGE_SIZE	2048
 #define MTK_MAX_RX_LENGTH	1536
 #define MTK_MAX_RX_LENGTH_2K	2048
@@ -103,43 +115,67 @@
 #define MTK_ETH_SRAM_OFFSET	0x40000
 
 /* PDMA RX Base Pointer Register */
-#define MTK_PRX_BASE_PTR0	0x900
+#define MTK_PRX_BASE_PTR0	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x100)
 #define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10))
 
 /* PDMA RX Maximum Count Register */
-#define MTK_PRX_MAX_CNT0	0x904
+#define MTK_PRX_MAX_CNT0	(MTK_PRX_BASE_PTR0 + 0x04)
 #define MTK_PRX_MAX_CNT_CFG(x)	(MTK_PRX_MAX_CNT0 + (x * 0x10))
 
 /* PDMA RX CPU Pointer Register */
-#define MTK_PRX_CRX_IDX0	0x908
+#define MTK_PRX_CRX_IDX0	(MTK_PRX_BASE_PTR0 + 0x08)
 #define MTK_PRX_CRX_IDX_CFG(x)	(MTK_PRX_CRX_IDX0 + (x * 0x10))
 
+/* PDMA RX DMA Pointer Register */
+#define MTK_PRX_DRX_IDX0	(MTK_PRX_BASE_PTR0 + 0x0c)
+#define MTK_PRX_DRX_IDX_CFG(x)	(MTK_PRX_DRX_IDX0 + (x * 0x10))
+
 /* PDMA HW LRO Control Registers */
-#define MTK_PDMA_LRO_CTRL_DW0	0x980
+#define MTK_PDMA_LRO_CTRL_DW0		(eth->soc->reg_map[MTK_PDMA_LRO_CTRL])
 #define MTK_LRO_EN			BIT(0)
 #define MTK_L3_CKS_UPD_EN		BIT(7)
 #define MTK_LRO_ALT_PKT_CNT_MODE	BIT(21)
 #define MTK_LRO_RING_RELINQUISH_REQ	(0x7 << 26)
 #define MTK_LRO_RING_RELINQUISH_DONE	(0x7 << 29)
 
-#define MTK_PDMA_LRO_CTRL_DW1	0x984
-#define MTK_PDMA_LRO_CTRL_DW2	0x988
-#define MTK_PDMA_LRO_CTRL_DW3	0x98c
+#define MTK_PDMA_LRO_CTRL_DW1	(eth->soc->reg_map[MTK_PDMA_LRO_CTRL] + 0x04)
+#define MTK_PDMA_LRO_CTRL_DW2	(eth->soc->reg_map[MTK_PDMA_LRO_CTRL] + 0x08)
+#define MTK_PDMA_LRO_CTRL_DW3	(eth->soc->reg_map[MTK_PDMA_LRO_CTRL] + 0x0c)
 #define MTK_ADMA_MODE		BIT(15)
 #define MTK_LRO_MIN_RXD_SDL	(MTK_HW_LRO_SDL_REMAIN_ROOM << 16)
 
+/* PDMA RSS Control Registers */
+#define MTK_RSS_EN			BIT(0)
+#define MTK_RSS_CFG_REQ			BIT(2)
+#define MTK_RSS_IPV6_STATIC_HASH	(0x7 << 8)
+#define MTK_RSS_IPV4_STATIC_HASH	(0x7 << 12)
+#define MTK_RSS_INDR_TABLE_DW0		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x50)
+#define MTK_RSS_INDR_TABLE_DW1		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x54)
+#define MTK_RSS_INDR_TABLE_DW2		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x58)
+#define MTK_RSS_INDR_TABLE_DW3		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x5c)
+#define MTK_RSS_INDR_TABLE_DW4		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x60)
+#define MTK_RSS_INDR_TABLE_DW5		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x64)
+#define MTK_RSS_INDR_TABLE_DW6		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x68)
+#define MTK_RSS_INDR_TABLE_DW7		(eth->soc->reg_map[MTK_PDMA_RSS_GLO_BASE] + 0x6c)
+#define MTK_RSS_INDR_TABLE_SIZE4	0x44444444
+
 /* PDMA Global Configuration Register */
-#define MTK_PDMA_GLO_CFG	0xa04
+#define MTK_PDMA_GLO_CFG	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x204)
 #define MTK_MULTI_EN		BIT(10)
 #define MTK_PDMA_SIZE_8DWORDS	(1 << 4)
 
+/* PDMA Global Configuration Register */
+#define MTK_PDMA_RX_CFG		(eth->soc->reg_map[MTK_PDMA_BASE] + 0x210)
+#define MTK_PDMA_LRO_SDL	0x3000
+#define MTK_RX_CFG_SDL_OFFSET	16
+
 /* PDMA Reset Index Register */
-#define MTK_PDMA_RST_IDX	0xa08
+#define MTK_PDMA_RST_IDX	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x208)
 #define MTK_PST_DRX_IDX0	BIT(16)
 #define MTK_PST_DRX_IDX_CFG(x)	(MTK_PST_DRX_IDX0 << (x))
 
 /* PDMA Delay Interrupt Register */
-#define MTK_PDMA_DELAY_INT		0xa0c
+#define MTK_PDMA_DELAY_INT		(eth->soc->reg_map[MTK_PDMA_BASE] + 0x20c)
 #define MTK_PDMA_DELAY_RX_MASK		GENMASK(15, 0)
 #define MTK_PDMA_DELAY_RX_EN		BIT(15)
 #define MTK_PDMA_DELAY_RX_PINT_SHIFT	8
@@ -154,27 +190,34 @@
 #define MTK_PDMA_DELAY_PTIME_MASK	0xff
 
 /* PDMA Interrupt Status Register */
-#define MTK_PDMA_INT_STATUS	0xa20
+#define MTK_PDMA_INT_STATUS	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x220)
 
 /* PDMA Interrupt Mask Register */
-#define MTK_PDMA_INT_MASK	0xa28
+#define MTK_PDMA_INT_MASK	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x228)
 
 /* PDMA HW LRO Alter Flow Delta Register */
-#define MTK_PDMA_LRO_ALT_SCORE_DELTA	0xa4c
+#define MTK_PDMA_LRO_ALT_SCORE_DELTA	(eth->soc->reg_map[MTK_PDMA_ALT_SCORE_DELTA_BASE])
 
 /* PDMA Interrupt grouping registers */
-#define MTK_PDMA_INT_GRP1	0xa50
-#define MTK_PDMA_INT_GRP2	0xa54
+#define MTK_PDMA_INT_GRP1	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x250)
+#define MTK_PDMA_INT_GRP2	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x254)
 
 /* PDMA HW LRO IP Setting Registers */
-#define MTK_LRO_RX_RING0_DIP_DW0	0xb04
+#define MTK_LRO_RX_RING0_DIP_DW0	(eth->soc->reg_map[MTK_PDMA_LRO_RX_RING_DIP_BASE])
 #define MTK_LRO_DIP_DW0_CFG(x)		(MTK_LRO_RX_RING0_DIP_DW0 + (x * 0x40))
 #define MTK_RING_MYIP_VLD		BIT(9)
 
+/* PDMA HW LRO ALT Debug Registers */
+#define MTK_LRO_ALT_DBG			(eth->soc->reg_map[MTK_PDMA_BASE] + 0x440)
+#define MTK_LRO_ALT_INDEX_OFFSET	(8)
+
+/* PDMA HW LRO ALT Data Registers */
+#define MTK_LRO_ALT_DBG_DATA		(eth->soc->reg_map[MTK_PDMA_BASE] + 0x444)
+
 /* PDMA HW LRO Ring Control Registers */
-#define MTK_LRO_RX_RING0_CTRL_DW1	0xb28
-#define MTK_LRO_RX_RING0_CTRL_DW2	0xb2c
-#define MTK_LRO_RX_RING0_CTRL_DW3	0xb30
+#define MTK_LRO_RX_RING0_CTRL_DW1	(eth->soc->reg_map[MTK_PDMA_LRO_RX_RING_CTRL_BASE])
+#define MTK_LRO_RX_RING0_CTRL_DW2	(eth->soc->reg_map[MTK_PDMA_LRO_RX_RING_CTRL_BASE] + 0x4)
+#define MTK_LRO_RX_RING0_CTRL_DW3	(eth->soc->reg_map[MTK_PDMA_LRO_RX_RING_CTRL_BASE] + 0x8)
 #define MTK_LRO_CTRL_DW1_CFG(x)		(MTK_LRO_RX_RING0_CTRL_DW1 + (x * 0x40))
 #define MTK_LRO_CTRL_DW2_CFG(x)		(MTK_LRO_RX_RING0_CTRL_DW2 + (x * 0x40))
 #define MTK_LRO_CTRL_DW3_CFG(x)		(MTK_LRO_RX_RING0_CTRL_DW3 + (x * 0x40))
@@ -187,26 +230,29 @@
 #define MTK_RING_MAX_AGG_CNT_H		((MTK_HW_LRO_MAX_AGG_CNT >> 6) & 0x3)
 
 /* QDMA TX Queue Configuration Registers */
-#define MTK_QTX_CFG(x)		(0x1800 + (x * 0x10))
+#define MTK_QTX_CFG(x)		(eth->soc->reg_map[MTK_QDMA_BASE] + ((x) * 0x10))
 #define QDMA_RES_THRES		4
 
 /* QDMA TX Queue Scheduler Registers */
-#define MTK_QTX_SCH(x)		(0x1804 + (x * 0x10))
+#define MTK_QTX_SCH(x)		(eth->soc->reg_map[MTK_QDMA_BASE] + 4 + ((x) * 0x10))
 
 /* QDMA RX Base Pointer Register */
-#define MTK_QRX_BASE_PTR0	0x1900
+#define MTK_QRX_BASE_PTR0	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x100)
+#define MTK_QRX_BASE_PTR_CFG(x)	(MTK_QRX_BASE_PTR0 + ((x) * 0x10))
 
 /* QDMA RX Maximum Count Register */
-#define MTK_QRX_MAX_CNT0	0x1904
+#define MTK_QRX_MAX_CNT0	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x104)
+#define MTK_QRX_MAX_CNT_CFG(x)	(MTK_QRX_MAX_CNT0 + ((x) * 0x10))
 
 /* QDMA RX CPU Pointer Register */
-#define MTK_QRX_CRX_IDX0	0x1908
+#define MTK_QRX_CRX_IDX0	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x108)
+#define MTK_QRX_CRX_IDX_CFG(x)	(MTK_QRX_CRX_IDX0 + ((x) * 0x10))
 
 /* QDMA RX DMA Pointer Register */
-#define MTK_QRX_DRX_IDX0	0x190C
+#define MTK_QRX_DRX_IDX0	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x10c)
 
 /* QDMA Global Configuration Register */
-#define MTK_QDMA_GLO_CFG	0x1A04
+#define MTK_QDMA_GLO_CFG	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x204)
 #define MTK_RX_2B_OFFSET	BIT(31)
 #define MTK_RX_BT_32DWORDS	(3 << 11)
 #define MTK_NDP_CO_PRO		BIT(10)
@@ -219,19 +265,19 @@
 #define MTK_DMA_BUSY_TIMEOUT_US	1000000
 
 /* QDMA Reset Index Register */
-#define MTK_QDMA_RST_IDX	0x1A08
+#define MTK_QDMA_RST_IDX	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x208)
 
 /* QDMA Delay Interrupt Register */
-#define MTK_QDMA_DELAY_INT	0x1A0C
+#define MTK_QDMA_DELAY_INT	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x20c)
 
 /* QDMA Flow Control Register */
-#define MTK_QDMA_FC_THRES	0x1A10
+#define MTK_QDMA_FC_THRES	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x210)
 #define FC_THRES_DROP_MODE	BIT(20)
 #define FC_THRES_DROP_EN	(7 << 16)
 #define FC_THRES_MIN		0x4444
 
 /* QDMA Interrupt Status Register */
-#define MTK_QDMA_INT_STATUS	0x1A18
+#define MTK_QDMA_INT_STATUS	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x218)
 #define MTK_RX_DONE_DLY		BIT(30)
 #define MTK_TX_DONE_DLY		BIT(28)
 #define MTK_RX_DONE_INT3	BIT(19)
@@ -246,55 +292,55 @@
 #define MTK_TX_DONE_INT		MTK_TX_DONE_DLY
 
 /* QDMA Interrupt grouping registers */
-#define MTK_QDMA_INT_GRP1	0x1a20
-#define MTK_QDMA_INT_GRP2	0x1a24
+#define MTK_QDMA_INT_GRP1	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x220)
+#define MTK_QDMA_INT_GRP2	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x224)
 #define MTK_RLS_DONE_INT	BIT(0)
 
 /* QDMA Interrupt Status Register */
-#define MTK_QDMA_INT_MASK	0x1A1C
+#define MTK_QDMA_INT_MASK	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x21c)
 
 /* QDMA Interrupt Mask Register */
-#define MTK_QDMA_HRED2		0x1A44
+#define MTK_QDMA_HRED2		(eth->soc->reg_map[MTK_QDMA_BASE] + 0x244)
 
 /* QDMA TX Forward CPU Pointer Register */
-#define MTK_QTX_CTX_PTR		0x1B00
+#define MTK_QTX_CTX_PTR		(eth->soc->reg_map[MTK_QDMA_BASE] + 0x300)
 
 /* QDMA TX Forward DMA Pointer Register */
-#define MTK_QTX_DTX_PTR		0x1B04
+#define MTK_QTX_DTX_PTR		(eth->soc->reg_map[MTK_QDMA_BASE] + 0x304)
 
 /* QDMA TX Release CPU Pointer Register */
-#define MTK_QTX_CRX_PTR		0x1B10
+#define MTK_QTX_CRX_PTR		(eth->soc->reg_map[MTK_QDMA_BASE] + 0x310)
 
 /* QDMA TX Release DMA Pointer Register */
-#define MTK_QTX_DRX_PTR		0x1B14
+#define MTK_QTX_DRX_PTR		(eth->soc->reg_map[MTK_QDMA_BASE] + 0x314)
 
 /* QDMA FQ Head Pointer Register */
-#define MTK_QDMA_FQ_HEAD	0x1B20
+#define MTK_QDMA_FQ_HEAD	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x320)
 
 /* QDMA FQ Head Pointer Register */
-#define MTK_QDMA_FQ_TAIL	0x1B24
+#define MTK_QDMA_FQ_TAIL	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x324)
 
 /* QDMA FQ Free Page Counter Register */
-#define MTK_QDMA_FQ_CNT		0x1B28
+#define MTK_QDMA_FQ_CNT		(eth->soc->reg_map[MTK_QDMA_BASE] + 0x328)
 
 /* QDMA FQ Free Page Buffer Length Register */
-#define MTK_QDMA_FQ_BLEN	0x1B2C
+#define MTK_QDMA_FQ_BLEN	(eth->soc->reg_map[MTK_QDMA_BASE] + 0x32c)
 
 /* GMA1 counter / statics register */
-#define MTK_GDM1_RX_GBCNT_L	0x2400
-#define MTK_GDM1_RX_GBCNT_H	0x2404
-#define MTK_GDM1_RX_GPCNT	0x2408
-#define MTK_GDM1_RX_OERCNT	0x2410
-#define MTK_GDM1_RX_FERCNT	0x2414
-#define MTK_GDM1_RX_SERCNT	0x2418
-#define MTK_GDM1_RX_LENCNT	0x241c
-#define MTK_GDM1_RX_CERCNT	0x2420
-#define MTK_GDM1_RX_FCCNT	0x2424
-#define MTK_GDM1_TX_SKIPCNT	0x2428
-#define MTK_GDM1_TX_COLCNT	0x242c
-#define MTK_GDM1_TX_GBCNT_L	0x2430
-#define MTK_GDM1_TX_GBCNT_H	0x2434
-#define MTK_GDM1_TX_GPCNT	0x2438
+#define MTK_GDM1_RX_GBCNT_L	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE])
+#define MTK_GDM1_RX_GBCNT_H	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x4)
+#define MTK_GDM1_RX_GPCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x8)
+#define MTK_GDM1_RX_OERCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x10)
+#define MTK_GDM1_RX_FERCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x14)
+#define MTK_GDM1_RX_SERCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x18)
+#define MTK_GDM1_RX_LENCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x1c)
+#define MTK_GDM1_RX_CERCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x20)
+#define MTK_GDM1_RX_FCCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x24)
+#define MTK_GDM1_TX_SKIPCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x28)
+#define MTK_GDM1_TX_COLCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x2c)
+#define MTK_GDM1_TX_GBCNT_L	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x30)
+#define MTK_GDM1_TX_GBCNT_H	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x34)
+#define MTK_GDM1_TX_GPCNT	(eth->soc->reg_map[MTK_GDM1_TX_STAT_BASE] + 0x38)
 #define MTK_STAT_OFFSET		0x40
 
 #define MTK_WDMA0_BASE		0x2800
@@ -862,6 +908,7 @@ struct mtk_tx_dma_desc_info {
 
 /* struct mtk_eth_data -	This is the structure holding all differences
  *				among various plaforms
+ * @reg_map:			Device register map
  * @ana_rgc3:                   The offset for register ANA_RGC3 related to
  *				sgmiisys syscon
  * @caps			Flags shown the extra capability for the SoC
@@ -874,6 +921,7 @@ struct mtk_tx_dma_desc_info {
  * @rxd_size			RX DMA descriptor size.
  */
 struct mtk_soc_data {
+	const u32	*reg_map;
 	u32             ana_rgc3;
 	u32		caps;
 	u32		required_clks;
-- 
2.35.1

