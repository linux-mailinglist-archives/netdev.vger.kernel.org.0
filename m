Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8781C5B26E1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiIHTfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIHTfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAACC7F139;
        Thu,  8 Sep 2022 12:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4990761C50;
        Thu,  8 Sep 2022 19:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1BBC433D7;
        Thu,  8 Sep 2022 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665740;
        bh=752XwboePlTgd5LMLUTiln4ykmNZ+AAr+03QFf+D4kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKVkHNret/9b+jHZiFr1tMtIWgDLSvBx+UxcPtFCQTFCpN26c8YiyvZlUMLumzAbB
         6fIZ7PQnPRFpXKbkNCRDsknnmDC6P7BH44sjzjvUfXl9Yl/cCfweGyJE5+PksMwLUA
         Keare6zQiKvzGk/ATVS0hUdcnQlZhcWOY1KAfMlzmBpoemuBrneLosvNMMu9NuoxU7
         L8Iq7L2gP/o+VjLjuAxDcEgzFJkN8V6kq8tyi/N1Ne4z5qZCfgWjuR5vYs2Q3WoyRW
         S3AXg5x2GTiW3thSeNsYpvYYCJSsjQm3JF3LSZhnfzBIY7SAYMH01hqZnjk8637rtm
         ThEIIvLNx/jbg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 10/12] net: ethernet: mtk_eth_wed: add wed support for mt7986 chipset
Date:   Thu,  8 Sep 2022 21:33:44 +0200
Message-Id: <1600f04403768df24a1aa377af7ec342c889a3c2.1662661555.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662661555.git.lorenzo@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce Wireless Etherne Dispatcher support on transmission side
for mt7986 chipset

Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  48 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   7 +
 drivers/net/ethernet/mediatek/mtk_wed.c       | 362 ++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_wed.h       |   8 +-
 .../net/ethernet/mediatek/mtk_wed_debugfs.c   |   3 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h  |  77 +++-
 include/linux/soc/mediatek/mtk_wed.h          |   8 +
 7 files changed, 418 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8aa0a61b35fc..7dae650c4586 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3944,6 +3944,7 @@ void mtk_eth_set_dma_device(struct mtk_eth *eth, struct device *dma_dev)
 
 static int mtk_probe(struct platform_device *pdev)
 {
+	struct resource *res = NULL;
 	struct device_node *mac_np;
 	struct mtk_eth *eth;
 	int err, i;
@@ -4024,16 +4025,31 @@ static int mtk_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0;; i++) {
-		struct device_node *np = of_parse_phandle(pdev->dev.of_node,
-							  "mediatek,wed", i);
-		void __iomem *wdma;
-
-		if (!np || i >= ARRAY_SIZE(eth->soc->reg_map->wdma_base))
-			break;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res)
+			return -EINVAL;
+	}
 
-		wdma = eth->base + eth->soc->reg_map->wdma_base[i];
-		mtk_wed_add_hw(np, eth, wdma, i);
+	if (eth->soc->offload_version) {
+		for (i = 0;; i++) {
+			struct device_node *np;
+			phys_addr_t wdma_phy;
+			u32 wdma_base;
+
+			if (i >= ARRAY_SIZE(eth->soc->reg_map->wdma_base))
+				break;
+
+			np = of_parse_phandle(pdev->dev.of_node,
+					      "mediatek,wed", i);
+			if (!np)
+				break;
+
+			wdma_base = eth->soc->reg_map->wdma_base[i];
+			wdma_phy = res ? res->start + wdma_base : 0;
+			mtk_wed_add_hw(np, eth, eth->base + wdma_base,
+				       wdma_phy, i);
+		}
 	}
 
 	for (i = 0; i < 3; i++) {
@@ -4282,6 +4298,13 @@ static const struct mtk_soc_data mt7622_data = {
 			.dst_port = GENMASK(7, 5),
 		},
 	},
+	.wed = {
+		.desc_ctrl_len1 = GENMASK(14, 0),
+		.desc_ctrl_last_seg1 = BIT(15),
+		.tx_bm_tkid_addr = 0x088,
+		.tx_bm_dyn_thr_lo = GENMASK(6, 0),
+		.tx_bm_dyn_thr_hi = GENMASK(22, 16),
+	},
 };
 
 static const struct mtk_soc_data mt7623_data = {
@@ -4355,6 +4378,13 @@ static const struct mtk_soc_data mt7986_data = {
 	.foe = {
 		.hash_offset = 4,
 	},
+	.wed = {
+		.desc_ctrl_len1 = GENMASK(13, 0),
+		.desc_ctrl_last_seg1 = BIT(14),
+		.tx_bm_tkid_addr = 0x0c8,
+		.tx_bm_dyn_thr_lo = GENMASK(8, 0),
+		.tx_bm_dyn_thr_hi = GENMASK(24, 16),
+	},
 };
 
 static const struct mtk_soc_data rt5350_data = {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 6d0b080c2048..e40ad480513d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1011,6 +1011,13 @@ struct mtk_soc_data {
 			u16 dst_port;
 		} ib2;
 	} foe;
+	struct {
+		u32 desc_ctrl_len1;
+		u32 desc_ctrl_last_seg1;
+		u32 tx_bm_tkid_addr;
+		u32 tx_bm_dyn_thr_lo;
+		u32 tx_bm_dyn_thr_hi;
+	} wed;
 };
 
 /* currently no SoC has more than 2 macs */
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index d1ef5b563ddf..3ec891f05fa7 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -25,6 +25,11 @@
 
 #define MTK_WED_TX_RING_SIZE		2048
 #define MTK_WED_WDMA_RING_SIZE		1024
+#define MTK_WED_MAX_GROUP_SIZE		0x100
+#define MTK_WED_VLD_GROUP_SIZE		0x40
+#define MTK_WED_PER_GROUP_PKT		128
+
+#define MTK_WED_FBUF_SIZE		128
 
 static struct mtk_wed_hw *hw_list[2];
 static DEFINE_MUTEX(hw_lock);
@@ -92,11 +97,13 @@ mtk_wed_assign(struct mtk_wed_device *dev)
 static int
 mtk_wed_buffer_alloc(struct mtk_wed_device *dev)
 {
+	struct mtk_eth *eth = dev->hw->eth;
 	struct mtk_wdma_desc *desc;
 	dma_addr_t desc_phys;
 	void **page_list;
 	int token = dev->wlan.token_start;
 	int ring_size;
+	u32 last_seg;
 	int n_pages;
 	int i, page_idx;
 
@@ -118,6 +125,9 @@ mtk_wed_buffer_alloc(struct mtk_wed_device *dev)
 	dev->buf_ring.desc = desc;
 	dev->buf_ring.desc_phys = desc_phys;
 
+	last_seg = dev->hw->version == 1 ? MTK_WDMA_DESC_CTRL_LAST_SEG1
+					 : MTK_WDMA_DESC_CTRL_LAST_SEG0;
+
 	for (i = 0, page_idx = 0; i < ring_size; i += MTK_WED_BUF_PER_PAGE) {
 		dma_addr_t page_phys, buf_phys;
 		struct page *page;
@@ -150,11 +160,12 @@ mtk_wed_buffer_alloc(struct mtk_wed_device *dev)
 
 			desc->buf0 = cpu_to_le32(buf_phys);
 			desc->buf1 = cpu_to_le32(buf_phys + txd_size);
+
 			ctrl = FIELD_PREP(MTK_WDMA_DESC_CTRL_LEN0, txd_size) |
-			       FIELD_PREP(MTK_WDMA_DESC_CTRL_LEN1,
-					  MTK_WED_BUF_SIZE - txd_size) |
-			       MTK_WDMA_DESC_CTRL_LAST_SEG1;
-			desc->ctrl = cpu_to_le32(ctrl);
+			       MTK_FIELD_PREP(eth->soc->wed.desc_ctrl_len1,
+					      MTK_WED_BUF_SIZE - txd_size);
+
+			desc->ctrl = cpu_to_le32(ctrl | last_seg);
 			desc->info = 0;
 			desc++;
 
@@ -209,7 +220,7 @@ mtk_wed_free_ring(struct mtk_wed_device *dev, struct mtk_wed_ring *ring)
 	if (!ring->desc)
 		return;
 
-	dma_free_coherent(dev->hw->dev, ring->size * sizeof(*ring->desc),
+	dma_free_coherent(dev->hw->dev, ring->size * ring->desc_size,
 			  ring->desc, ring->desc_phys);
 }
 
@@ -229,6 +240,14 @@ mtk_wed_set_ext_int(struct mtk_wed_device *dev, bool en)
 {
 	u32 mask = MTK_WED_EXT_INT_STATUS_ERROR_MASK;
 
+	if (dev->hw->version == 1)
+		mask |= MTK_WED_EXT_INT_STATUS_TX_DRV_R_RESP_ERR;
+	else
+		mask |= MTK_WED_EXT_INT_STATUS_RX_FBUF_LO_TH |
+			MTK_WED_EXT_INT_STATUS_RX_FBUF_HI_TH |
+			MTK_WED_EXT_INT_STATUS_RX_DRV_COHERENT |
+			MTK_WED_EXT_INT_STATUS_TX_DMA_W_RESP_ERR;
+
 	if (!dev->hw->num_flows)
 		mask &= ~MTK_WED_EXT_INT_STATUS_TKID_WO_PYLD;
 
@@ -236,6 +255,20 @@ mtk_wed_set_ext_int(struct mtk_wed_device *dev, bool en)
 	wed_r32(dev, MTK_WED_EXT_INT_MASK);
 }
 
+static void
+mtk_wed_set_512_support(struct mtk_wed_device *dev, bool enable)
+{
+	if (enable) {
+		wed_w32(dev, MTK_WED_TXDP_CTRL, MTK_WED_TXDP_DW9_OVERWR);
+		wed_w32(dev, MTK_WED_TXP_DW1,
+			FIELD_PREP(MTK_WED_WPDMA_WRITE_TXP, 0x0103));
+	} else {
+		wed_w32(dev, MTK_WED_TXP_DW1,
+			FIELD_PREP(MTK_WED_WPDMA_WRITE_TXP, 0x0100));
+		wed_clr(dev, MTK_WED_TXDP_CTRL, MTK_WED_TXDP_DW9_OVERWR);
+	}
+}
+
 static void
 mtk_wed_dma_disable(struct mtk_wed_device *dev)
 {
@@ -249,12 +282,22 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
 		MTK_WED_GLO_CFG_TX_DMA_EN |
 		MTK_WED_GLO_CFG_RX_DMA_EN);
 
-	regmap_write(dev->hw->mirror, dev->hw->index * 4, 0);
 	wdma_m32(dev, MTK_WDMA_GLO_CFG,
 		 MTK_WDMA_GLO_CFG_TX_DMA_EN |
 		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES, 0);
+		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES, 0);
+
+	if (dev->hw->version == 1) {
+		regmap_write(dev->hw->mirror, dev->hw->index * 4, 0);
+		wdma_m32(dev, MTK_WDMA_GLO_CFG,
+			 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES, 0);
+	} else {
+		wed_clr(dev, MTK_WED_WPDMA_GLO_CFG,
+			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_PKT_PROC |
+			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_CRX_SYNC);
+
+		mtk_wed_set_512_support(dev, false);
+	}
 }
 
 static void
@@ -293,7 +336,7 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 	mtk_wed_free_buffer(dev);
 	mtk_wed_free_tx_rings(dev);
 
-	if (of_dma_is_coherent(wlan_node))
+	if (of_dma_is_coherent(wlan_node) && hw->hifsys)
 		regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP,
 				   BIT(hw->index), BIT(hw->index));
 
@@ -308,14 +351,71 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 	mutex_unlock(&hw_lock);
 }
 
+#define PCIE_BASE_ADDR0		0x11280000
+static void
+mtk_wed_bus_init(struct mtk_wed_device *dev)
+{
+	struct device_node *node;
+	void __iomem *base_addr;
+	u32 val;
+
+	node = of_parse_phandle(dev->hw->node, "mediatek,wed_pcie", 0);
+	if (!node)
+		return;
+
+	base_addr = of_iomap(node, 0);
+	val = BIT(0) | readl(base_addr);
+	writel(val, base_addr);
+
+	wed_w32(dev, MTK_WED_PCIE_INT_CTRL,
+		FIELD_PREP(MTK_WED_PCIE_INT_CTRL_POLL_EN, 2));
+
+	/* pcie interrupt control: pola/source selection */
+	wed_set(dev, MTK_WED_PCIE_INT_CTRL,
+		MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA |
+		FIELD_PREP(MTK_WED_PCIE_INT_CTRL_SRC_SEL, 1));
+	wed_r32(dev, MTK_WED_PCIE_INT_CTRL);
+
+	val = wed_r32(dev, MTK_WED_PCIE_CFG_INTM);
+	val = wed_r32(dev, MTK_WED_PCIE_CFG_BASE);
+	wed_w32(dev, MTK_WED_PCIE_CFG_INTM, PCIE_BASE_ADDR0 | 0x180);
+	wed_w32(dev, MTK_WED_PCIE_CFG_BASE, PCIE_BASE_ADDR0 | 0x184);
+
+	val = wed_r32(dev, MTK_WED_PCIE_CFG_INTM);
+	val = wed_r32(dev, MTK_WED_PCIE_CFG_BASE);
+
+	/* pcie interrupt status trigger register */
+	wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER, BIT(24));
+	wed_r32(dev, MTK_WED_PCIE_INT_TRIGGER);
+
+	/* pola setting */
+	val = wed_r32(dev, MTK_WED_PCIE_INT_CTRL);
+	wed_set(dev, MTK_WED_PCIE_INT_CTRL, MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA);
+}
+
+static void
+mtk_wed_set_wpdma(struct mtk_wed_device *dev)
+{
+	if (dev->hw->version == 1) {
+		wed_w32(dev, MTK_WED_WPDMA_CFG_BASE,  dev->wlan.wpdma_phys);
+	} else {
+		mtk_wed_bus_init(dev);
+
+		wed_w32(dev, MTK_WED_WPDMA_CFG_BASE,  dev->wlan.wpdma_int);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_INT_MASK,  dev->wlan.wpdma_mask);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_TX,  dev->wlan.wpdma_tx);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_TX_FREE,  dev->wlan.wpdma_txfree);
+	}
+}
+
 static void
 mtk_wed_hw_init_early(struct mtk_wed_device *dev)
 {
 	u32 mask, set;
-	u32 offset;
 
 	mtk_wed_stop(dev);
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
+	mtk_wed_set_wpdma(dev);
 
 	mask = MTK_WED_WDMA_GLO_CFG_BT_SIZE |
 	       MTK_WED_WDMA_GLO_CFG_DYNAMIC_DMAD_RECYCLE |
@@ -325,22 +425,40 @@ mtk_wed_hw_init_early(struct mtk_wed_device *dev)
 	      MTK_WED_WDMA_GLO_CFG_IDLE_DMAD_SUPPLY;
 	wed_m32(dev, MTK_WED_WDMA_GLO_CFG, mask, set);
 
-	wdma_set(dev, MTK_WDMA_GLO_CFG,
-		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
+	if (dev->hw->version == 1) {
+		u32 offset = dev->hw->index ? 0x04000400 : 0;
 
-	offset = dev->hw->index ? 0x04000400 : 0;
-	wed_w32(dev, MTK_WED_WDMA_OFFSET0, 0x2a042a20 + offset);
-	wed_w32(dev, MTK_WED_WDMA_OFFSET1, 0x29002800 + offset);
+		wdma_set(dev, MTK_WDMA_GLO_CFG,
+			 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
+			 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
+			 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
 
-	wed_w32(dev, MTK_WED_PCIE_CFG_BASE, MTK_PCIE_BASE(dev->hw->index));
-	wed_w32(dev, MTK_WED_WPDMA_CFG_BASE, dev->wlan.wpdma_phys);
+		wed_w32(dev, MTK_WED_WDMA_OFFSET0, 0x2a042a20 + offset);
+		wed_w32(dev, MTK_WED_WDMA_OFFSET1, 0x29002800 + offset);
+		wed_w32(dev, MTK_WED_PCIE_CFG_BASE,
+			MTK_PCIE_BASE(dev->hw->index));
+	} else {
+		wed_w32(dev, MTK_WED_WDMA_CFG_BASE, dev->hw->wdma_phy);
+		wed_set(dev, MTK_WED_CTRL, MTK_WED_CTRL_ETH_DMAD_FMT);
+		wed_w32(dev, MTK_WED_WDMA_OFFSET0,
+			FIELD_PREP(MTK_WED_WDMA_OFST0_GLO_INTS,
+				   MTK_WDMA_INT_STATUS) |
+			FIELD_PREP(MTK_WED_WDMA_OFST0_GLO_CFG,
+				   MTK_WDMA_GLO_CFG));
+
+		wed_w32(dev, MTK_WED_WDMA_OFFSET1,
+			FIELD_PREP(MTK_WED_WDMA_OFST1_TX_CTRL,
+				   MTK_WDMA_RING_TX(0)) |
+			FIELD_PREP(MTK_WED_WDMA_OFST1_RX_CTRL,
+				   MTK_WDMA_RING_RX(0)));
+	}
 }
 
 static void
 mtk_wed_hw_init(struct mtk_wed_device *dev)
 {
+	struct mtk_eth *eth = dev->hw->eth;
+
 	if (dev->init_done)
 		return;
 
@@ -355,37 +473,57 @@ mtk_wed_hw_init(struct mtk_wed_device *dev)
 
 	wed_w32(dev, MTK_WED_TX_BM_BASE, dev->buf_ring.desc_phys);
 
-	wed_w32(dev, MTK_WED_TX_BM_TKID,
+	wed_w32(dev, MTK_WED_TX_BM_BUF_LEN, MTK_WED_PKT_SIZE);
+
+	wed_w32(dev, eth->soc->wed.tx_bm_tkid_addr,
 		FIELD_PREP(MTK_WED_TX_BM_TKID_START,
 			   dev->wlan.token_start) |
 		FIELD_PREP(MTK_WED_TX_BM_TKID_END,
-			   dev->wlan.token_start + dev->wlan.nbuf - 1));
-
-	wed_w32(dev, MTK_WED_TX_BM_BUF_LEN, MTK_WED_PKT_SIZE);
-
+			   dev->wlan.token_start +
+			   dev->wlan.nbuf - 1));
 	wed_w32(dev, MTK_WED_TX_BM_DYN_THR,
-		FIELD_PREP(MTK_WED_TX_BM_DYN_THR_LO, 1) |
-		MTK_WED_TX_BM_DYN_THR_HI);
+		MTK_FIELD_PREP(eth->soc->wed.tx_bm_dyn_thr_lo,
+			       dev->hw->version == 1) |
+		eth->soc->wed.tx_bm_dyn_thr_hi);
+
+	if (dev->hw->version > 1) {
+		wed_w32(dev, MTK_WED_TX_TKID_CTRL,
+			MTK_WED_TX_TKID_CTRL_PAUSE |
+			FIELD_PREP(MTK_WED_TX_TKID_CTRL_VLD_GRP_NUM,
+				   dev->buf_ring.size / 128) |
+			FIELD_PREP(MTK_WED_TX_TKID_CTRL_RSV_GRP_NUM,
+				   dev->buf_ring.size / 128));
+		wed_w32(dev, MTK_WED_TX_TKID_DYN_THR,
+			FIELD_PREP(MTK_WED_TX_TKID_DYN_THR_LO, 0) |
+			MTK_WED_TX_TKID_DYN_THR_HI);
+	}
 
 	mtk_wed_reset(dev, MTK_WED_RESET_TX_BM);
 
-	wed_set(dev, MTK_WED_CTRL,
-		MTK_WED_CTRL_WED_TX_BM_EN |
-		MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
+	if (dev->hw->version == 1)
+		wed_set(dev, MTK_WED_CTRL,
+			MTK_WED_CTRL_WED_TX_BM_EN |
+			MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
+	else
+		wed_clr(dev, MTK_WED_TX_TKID_CTRL, MTK_WED_TX_TKID_CTRL_PAUSE);
 
 	wed_clr(dev, MTK_WED_TX_BM_CTRL, MTK_WED_TX_BM_CTRL_PAUSE);
 }
 
 static void
-mtk_wed_ring_reset(struct mtk_wdma_desc *desc, int size)
+mtk_wed_ring_reset(struct mtk_wed_ring *ring, int size)
 {
+	void *head = (void *)ring->desc;
 	int i;
 
 	for (i = 0; i < size; i++) {
-		desc[i].buf0 = 0;
-		desc[i].ctrl = cpu_to_le32(MTK_WDMA_DESC_CTRL_DMA_DONE);
-		desc[i].buf1 = 0;
-		desc[i].info = 0;
+		struct mtk_wdma_desc *desc;
+
+		desc = (struct mtk_wdma_desc *)(head + i * ring->desc_size);
+		desc->buf0 = 0;
+		desc->ctrl = cpu_to_le32(MTK_WDMA_DESC_CTRL_DMA_DONE);
+		desc->buf1 = 0;
+		desc->info = 0;
 	}
 }
 
@@ -436,12 +574,10 @@ mtk_wed_reset_dma(struct mtk_wed_device *dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dev->tx_ring); i++) {
-		struct mtk_wdma_desc *desc = dev->tx_ring[i].desc;
-
-		if (!desc)
+		if (!dev->tx_ring[i].desc)
 			continue;
 
-		mtk_wed_ring_reset(desc, MTK_WED_TX_RING_SIZE);
+		mtk_wed_ring_reset(&dev->tx_ring[i], MTK_WED_TX_RING_SIZE);
 	}
 
 	if (mtk_wed_poll_busy(dev))
@@ -498,16 +634,16 @@ mtk_wed_reset_dma(struct mtk_wed_device *dev)
 
 static int
 mtk_wed_ring_alloc(struct mtk_wed_device *dev, struct mtk_wed_ring *ring,
-		   int size)
+		   int size, u32 desc_size)
 {
-	ring->desc = dma_alloc_coherent(dev->hw->dev,
-					size * sizeof(*ring->desc),
+	ring->desc = dma_alloc_coherent(dev->hw->dev, size * desc_size,
 					&ring->desc_phys, GFP_KERNEL);
 	if (!ring->desc)
 		return -ENOMEM;
 
+	ring->desc_size = desc_size;
 	ring->size = size;
-	mtk_wed_ring_reset(ring->desc, size);
+	mtk_wed_ring_reset(ring, size);
 
 	return 0;
 }
@@ -515,9 +651,10 @@ mtk_wed_ring_alloc(struct mtk_wed_device *dev, struct mtk_wed_ring *ring,
 static int
 mtk_wed_wdma_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 {
+	u32 desc_size = sizeof(struct mtk_wdma_desc) * dev->hw->version;
 	struct mtk_wed_ring *wdma = &dev->tx_wdma[idx];
 
-	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE))
+	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size))
 		return -ENOMEM;
 
 	wdma_w32(dev, MTK_WDMA_RING_RX(idx) + MTK_WED_RING_OFS_BASE,
@@ -546,16 +683,41 @@ mtk_wed_configure_irq(struct mtk_wed_device *dev, u32 irq_mask)
 		MTK_WED_CTRL_WED_TX_BM_EN |
 		MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
 
-	wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER,
-		MTK_WED_PCIE_INT_TRIGGER_STATUS);
+	if (dev->hw->version == 1) {
+		wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER,
+			MTK_WED_PCIE_INT_TRIGGER_STATUS);
 
-	wed_w32(dev, MTK_WED_WPDMA_INT_TRIGGER,
-		MTK_WED_WPDMA_INT_TRIGGER_RX_DONE |
-		MTK_WED_WPDMA_INT_TRIGGER_TX_DONE);
+		wed_w32(dev, MTK_WED_WPDMA_INT_TRIGGER,
+			MTK_WED_WPDMA_INT_TRIGGER_RX_DONE |
+			MTK_WED_WPDMA_INT_TRIGGER_TX_DONE);
+
+		wed_clr(dev, MTK_WED_WDMA_INT_CTRL, wdma_mask);
+	} else {
+		/* initail tx interrupt trigger */
+		wed_w32(dev, MTK_WED_WPDMA_INT_CTRL_TX,
+			MTK_WED_WPDMA_INT_CTRL_TX0_DONE_EN |
+			MTK_WED_WPDMA_INT_CTRL_TX0_DONE_CLR |
+			MTK_WED_WPDMA_INT_CTRL_TX1_DONE_EN |
+			MTK_WED_WPDMA_INT_CTRL_TX1_DONE_CLR |
+			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_TX0_DONE_TRIG,
+				   dev->wlan.tx_tbit[0]) |
+			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_TX1_DONE_TRIG,
+				   dev->wlan.tx_tbit[1]));
+
+		/* initail txfree interrupt trigger */
+		wed_w32(dev, MTK_WED_WPDMA_INT_CTRL_TX_FREE,
+			MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_EN |
+			MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_CLR |
+			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_TRIG,
+				   dev->wlan.txfree_tbit));
+
+		wed_w32(dev, MTK_WED_WDMA_INT_CLR, wdma_mask);
+		wed_set(dev, MTK_WED_WDMA_INT_CTRL,
+			FIELD_PREP(MTK_WED_WDMA_INT_CTRL_POLL_SRC_SEL,
+				   dev->wdma_idx));
+	}
 
-	/* initail wdma interrupt agent */
 	wed_w32(dev, MTK_WED_WDMA_INT_TRIGGER, wdma_mask);
-	wed_clr(dev, MTK_WED_WDMA_INT_CTRL, wdma_mask);
 
 	wdma_w32(dev, MTK_WDMA_INT_MASK, wdma_mask);
 	wdma_w32(dev, MTK_WDMA_INT_GRP2, wdma_mask);
@@ -580,14 +742,28 @@ mtk_wed_dma_enable(struct mtk_wed_device *dev)
 	wdma_set(dev, MTK_WDMA_GLO_CFG,
 		 MTK_WDMA_GLO_CFG_TX_DMA_EN |
 		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
+		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES);
+
+	if (dev->hw->version == 1) {
+		wdma_set(dev, MTK_WDMA_GLO_CFG,
+			 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
+	} else {
+		wed_set(dev, MTK_WED_WPDMA_CTRL,
+			MTK_WED_WPDMA_CTRL_SDL1_FIXED);
+
+		wed_set(dev, MTK_WED_WPDMA_GLO_CFG,
+			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_PKT_PROC |
+			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_CRX_SYNC);
+
+		wed_clr(dev, MTK_WED_WPDMA_GLO_CFG,
+			MTK_WED_WPDMA_GLO_CFG_TX_TKID_KEEP |
+			MTK_WED_WPDMA_GLO_CFG_TX_DMAD_DW3_PREV);
+	}
 }
 
 static void
 mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 {
-	u32 val;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
@@ -598,14 +774,17 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 	mtk_wed_configure_irq(dev, irq_mask);
 
 	mtk_wed_set_ext_int(dev, true);
-	val = dev->wlan.wpdma_phys |
-	      MTK_PCIE_MIRROR_MAP_EN |
-	      FIELD_PREP(MTK_PCIE_MIRROR_MAP_WED_ID, dev->hw->index);
 
-	if (dev->hw->index)
-		val |= BIT(1);
-	val |= BIT(0);
-	regmap_write(dev->hw->mirror, dev->hw->index * 4, val);
+	if (dev->hw->version == 1) {
+		u32 val = dev->wlan.wpdma_phys | MTK_PCIE_MIRROR_MAP_EN |
+			  FIELD_PREP(MTK_PCIE_MIRROR_MAP_WED_ID,
+				     dev->hw->index);
+
+		val |= BIT(0) | (BIT(1) * !!dev->hw->index);
+		regmap_write(dev->hw->mirror, dev->hw->index * 4, val);
+	} else {
+		mtk_wed_set_512_support(dev, true);
+	}
 
 	mtk_wed_dma_enable(dev);
 	dev->running = true;
@@ -639,7 +818,9 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 		goto out;
 	}
 
-	dev_info(&dev->wlan.pci_dev->dev, "attaching wed device %d\n", hw->index);
+	dev_info(&dev->wlan.pci_dev->dev,
+		 "attaching wed device %d version %d\n",
+		 hw->index, hw->version);
 
 	dev->hw = hw;
 	dev->dev = hw->dev;
@@ -657,7 +838,9 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	}
 
 	mtk_wed_hw_init_early(dev);
-	regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP, BIT(hw->index), 0);
+	if (hw->hifsys)
+		regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP,
+				   BIT(hw->index), 0);
 
 out:
 	mutex_unlock(&hw_lock);
@@ -684,7 +867,8 @@ mtk_wed_tx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs)
 
 	BUG_ON(idx >= ARRAY_SIZE(dev->tx_ring));
 
-	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_TX_RING_SIZE))
+	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_TX_RING_SIZE,
+			       sizeof(*ring->desc)))
 		return -ENOMEM;
 
 	if (mtk_wed_wdma_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
@@ -711,21 +895,21 @@ static int
 mtk_wed_txfree_ring_setup(struct mtk_wed_device *dev, void __iomem *regs)
 {
 	struct mtk_wed_ring *ring = &dev->txfree_ring;
-	int i;
+	int i, index = dev->hw->version == 1;
 
 	/*
 	 * For txfree event handling, the same DMA ring is shared between WED
 	 * and WLAN. The WLAN driver accesses the ring index registers through
 	 * WED
 	 */
-	ring->reg_base = MTK_WED_RING_RX(1);
+	ring->reg_base = MTK_WED_RING_RX(index);
 	ring->wpdma = regs;
 
 	for (i = 0; i < 12; i += 4) {
 		u32 val = readl(regs + i);
 
-		wed_w32(dev, MTK_WED_RING_RX(1) + i, val);
-		wed_w32(dev, MTK_WED_WPDMA_RING_RX(1) + i, val);
+		wed_w32(dev, MTK_WED_RING_RX(index) + i, val);
+		wed_w32(dev, MTK_WED_WPDMA_RING_RX(index) + i, val);
 	}
 
 	return 0;
@@ -734,11 +918,19 @@ mtk_wed_txfree_ring_setup(struct mtk_wed_device *dev, void __iomem *regs)
 static u32
 mtk_wed_irq_get(struct mtk_wed_device *dev, u32 mask)
 {
-	u32 val;
+	u32 val, ext_mask = MTK_WED_EXT_INT_STATUS_ERROR_MASK;
+
+	if (dev->hw->version == 1)
+		ext_mask |= MTK_WED_EXT_INT_STATUS_TX_DRV_R_RESP_ERR;
+	else
+		ext_mask |= MTK_WED_EXT_INT_STATUS_RX_FBUF_LO_TH |
+			    MTK_WED_EXT_INT_STATUS_RX_FBUF_HI_TH |
+			    MTK_WED_EXT_INT_STATUS_RX_DRV_COHERENT |
+			    MTK_WED_EXT_INT_STATUS_TX_DMA_W_RESP_ERR;
 
 	val = wed_r32(dev, MTK_WED_EXT_INT_STATUS);
 	wed_w32(dev, MTK_WED_EXT_INT_STATUS, val);
-	val &= MTK_WED_EXT_INT_STATUS_ERROR_MASK;
+	val &= ext_mask;
 	if (!dev->hw->num_flows)
 		val &= ~MTK_WED_EXT_INT_STATUS_TKID_WO_PYLD;
 	if (val && net_ratelimit())
@@ -813,7 +1005,8 @@ void mtk_wed_flow_remove(int index)
 }
 
 void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
-		    void __iomem *wdma, int index)
+		    void __iomem *wdma, phys_addr_t wdma_phy,
+		    int index)
 {
 	static const struct mtk_wed_ops wed_ops = {
 		.attach = mtk_wed_attach,
@@ -860,26 +1053,33 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	hw = kzalloc(sizeof(*hw), GFP_KERNEL);
 	if (!hw)
 		goto unlock;
+
 	hw->node = np;
 	hw->regs = regs;
 	hw->eth = eth;
 	hw->dev = &pdev->dev;
+	hw->wdma_phy = wdma_phy;
 	hw->wdma = wdma;
 	hw->index = index;
 	hw->irq = irq;
-	hw->mirror = syscon_regmap_lookup_by_phandle(eth_np,
-						     "mediatek,pcie-mirror");
-	hw->hifsys = syscon_regmap_lookup_by_phandle(eth_np,
-						     "mediatek,hifsys");
-	if (IS_ERR(hw->mirror) || IS_ERR(hw->hifsys)) {
-		kfree(hw);
-		goto unlock;
-	}
+	hw->version = MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2) ? 2 : 1;
+
+	if (hw->version == 1) {
+		hw->mirror = syscon_regmap_lookup_by_phandle(eth_np,
+				"mediatek,pcie-mirror");
+		hw->hifsys = syscon_regmap_lookup_by_phandle(eth_np,
+				"mediatek,hifsys");
+		if (IS_ERR(hw->mirror) || IS_ERR(hw->hifsys)) {
+			kfree(hw);
+			goto unlock;
+		}
 
-	if (!index) {
-		regmap_write(hw->mirror, 0, 0);
-		regmap_write(hw->mirror, 4, 0);
+		if (!index) {
+			regmap_write(hw->mirror, 0, 0);
+			regmap_write(hw->mirror, 4, 0);
+		}
 	}
+
 	mtk_wed_hw_add_debugfs(hw);
 
 	hw_list[index] = hw;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
index 981ec613f4b0..ae420ca01a48 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed.h
@@ -18,11 +18,13 @@ struct mtk_wed_hw {
 	struct regmap *hifsys;
 	struct device *dev;
 	void __iomem *wdma;
+	phys_addr_t wdma_phy;
 	struct regmap *mirror;
 	struct dentry *debugfs_dir;
 	struct mtk_wed_device *wed_dev;
 	u32 debugfs_reg;
 	u32 num_flows;
+	u8 version;
 	char dirname[5];
 	int irq;
 	int index;
@@ -101,14 +103,16 @@ wpdma_txfree_w32(struct mtk_wed_device *dev, u32 reg, u32 val)
 }
 
 void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
-		    void __iomem *wdma, int index);
+		    void __iomem *wdma, phys_addr_t wdma_phy,
+		    int index);
 void mtk_wed_exit(void);
 int mtk_wed_flow_add(int index);
 void mtk_wed_flow_remove(int index);
 #else
 static inline void
 mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
-	       void __iomem *wdma, int index)
+	       void __iomem *wdma, phys_addr_t wdma_phy,
+	       int index)
 {
 }
 static inline void
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index a81d3fd1a439..f420f187e837 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -116,6 +116,9 @@ wed_txinfo_show(struct seq_file *s, void *data)
 		DUMP_WDMA(WDMA_GLO_CFG),
 		DUMP_WDMA_RING(WDMA_RING_RX(0)),
 		DUMP_WDMA_RING(WDMA_RING_RX(1)),
+
+		DUMP_STR("TX FREE"),
+		DUMP_WED(WED_RX_MIB(0)),
 	};
 	struct mtk_wed_hw *hw = s->private;
 	struct mtk_wed_device *dev = hw->wed_dev;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index eec22daebd30..ecd925fbd451 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -41,6 +41,7 @@ struct mtk_wdma_desc {
 #define MTK_WED_CTRL_RESERVE_EN				BIT(12)
 #define MTK_WED_CTRL_RESERVE_BUSY			BIT(13)
 #define MTK_WED_CTRL_FINAL_DIDX_READ			BIT(24)
+#define MTK_WED_CTRL_ETH_DMAD_FMT			BIT(25)
 #define MTK_WED_CTRL_MIB_READ_CLEAR			BIT(28)
 
 #define MTK_WED_EXT_INT_STATUS				0x020
@@ -57,7 +58,8 @@ struct mtk_wdma_desc {
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_INIT_WDMA_EN	BIT(19)
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_BM_DMAD_COHERENT	BIT(20)
 #define MTK_WED_EXT_INT_STATUS_TX_DRV_R_RESP_ERR	BIT(21)
-#define MTK_WED_EXT_INT_STATUS_TX_DRV_W_RESP_ERR	BIT(22)
+#define MTK_WED_EXT_INT_STATUS_TX_DMA_R_RESP_ERR	BIT(22)
+#define MTK_WED_EXT_INT_STATUS_TX_DMA_W_RESP_ERR	BIT(23)
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_DMA_RECYCLE	BIT(24)
 #define MTK_WED_EXT_INT_STATUS_ERROR_MASK		(MTK_WED_EXT_INT_STATUS_TF_LEN_ERR | \
 							 MTK_WED_EXT_INT_STATUS_TKID_WO_PYLD | \
@@ -65,8 +67,7 @@ struct mtk_wdma_desc {
 							 MTK_WED_EXT_INT_STATUS_RX_DRV_R_RESP_ERR | \
 							 MTK_WED_EXT_INT_STATUS_RX_DRV_W_RESP_ERR | \
 							 MTK_WED_EXT_INT_STATUS_RX_DRV_INIT_WDMA_EN | \
-							 MTK_WED_EXT_INT_STATUS_TX_DRV_R_RESP_ERR | \
-							 MTK_WED_EXT_INT_STATUS_TX_DRV_W_RESP_ERR)
+							 MTK_WED_EXT_INT_STATUS_TX_DMA_R_RESP_ERR)
 
 #define MTK_WED_EXT_INT_MASK				0x028
 
@@ -96,6 +97,22 @@ struct mtk_wdma_desc {
 #define MTK_WED_TX_BM_DYN_THR_LO			GENMASK(6, 0)
 #define MTK_WED_TX_BM_DYN_THR_HI			GENMASK(22, 16)
 
+#define MTK_WED_TX_TKID_CTRL				0x0c0
+#define MTK_WED_TX_TKID_CTRL_VLD_GRP_NUM		GENMASK(6, 0)
+#define MTK_WED_TX_TKID_CTRL_RSV_GRP_NUM		GENMASK(22, 16)
+#define MTK_WED_TX_TKID_CTRL_PAUSE			BIT(28)
+
+#define MTK_WED_TX_TKID_DYN_THR				0x0e0
+#define MTK_WED_TX_TKID_DYN_THR_LO			GENMASK(6, 0)
+#define MTK_WED_TX_TKID_DYN_THR_HI			GENMASK(22, 16)
+
+#define MTK_WED_TXP_DW0					0x120
+#define MTK_WED_TXP_DW1					0x124
+#define MTK_WED_WPDMA_WRITE_TXP				GENMASK(31, 16)
+#define MTK_WED_TXDP_CTRL				0x130
+#define MTK_WED_TXDP_DW9_OVERWR				BIT(9)
+#define MTK_WED_RX_BM_TKID_MIB				0x1cc
+
 #define MTK_WED_INT_STATUS				0x200
 #define MTK_WED_INT_MASK				0x204
 
@@ -125,6 +142,7 @@ struct mtk_wdma_desc {
 #define MTK_WED_RESET_IDX_RX				GENMASK(17, 16)
 
 #define MTK_WED_TX_MIB(_n)				(0x2a0 + (_n) * 4)
+#define MTK_WED_RX_MIB(_n)				(0x2e0 + (_n) * 4)
 
 #define MTK_WED_RING_TX(_n)				(0x300 + (_n) * 0x10)
 
@@ -155,21 +173,62 @@ struct mtk_wdma_desc {
 #define MTK_WED_WPDMA_GLO_CFG_BYTE_SWAP			BIT(29)
 #define MTK_WED_WPDMA_GLO_CFG_RX_2B_OFFSET		BIT(31)
 
+/* CONFIG_MEDIATEK_NETSYS_V2 */
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_PKT_PROC	BIT(4)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_R1_PKT_PROC	BIT(5)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_CRX_SYNC	BIT(6)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_R1_CRX_SYNC	BIT(7)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_EVENT_PKT_FMT_VER	GENMASK(18, 16)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_UNSUPPORT_FMT	BIT(19)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DRV_UEVENT_PKT_FMT_CHK BIT(20)
+#define MTK_WED_WPDMA_GLO_CFG_RX_DDONE2_WR		BIT(21)
+#define MTK_WED_WPDMA_GLO_CFG_TX_TKID_KEEP		BIT(24)
+#define MTK_WED_WPDMA_GLO_CFG_TX_DMAD_DW3_PREV		BIT(28)
+
 #define MTK_WED_WPDMA_RESET_IDX				0x50c
 #define MTK_WED_WPDMA_RESET_IDX_TX			GENMASK(3, 0)
 #define MTK_WED_WPDMA_RESET_IDX_RX			GENMASK(17, 16)
 
+#define MTK_WED_WPDMA_CTRL				0x518
+#define MTK_WED_WPDMA_CTRL_SDL1_FIXED			BIT(31)
+
 #define MTK_WED_WPDMA_INT_CTRL				0x520
 #define MTK_WED_WPDMA_INT_CTRL_SUBRT_ADV		BIT(21)
 
 #define MTK_WED_WPDMA_INT_MASK				0x524
 
+#define MTK_WED_WPDMA_INT_CTRL_TX			0x530
+#define MTK_WED_WPDMA_INT_CTRL_TX0_DONE_EN		BIT(0)
+#define MTK_WED_WPDMA_INT_CTRL_TX0_DONE_CLR		BIT(1)
+#define MTK_WED_WPDMA_INT_CTRL_TX0_DONE_TRIG		GENMASK(6, 2)
+#define MTK_WED_WPDMA_INT_CTRL_TX1_DONE_EN		BIT(8)
+#define MTK_WED_WPDMA_INT_CTRL_TX1_DONE_CLR		BIT(9)
+#define MTK_WED_WPDMA_INT_CTRL_TX1_DONE_TRIG		GENMASK(14, 10)
+
+#define MTK_WED_WPDMA_INT_CTRL_RX			0x534
+
+#define MTK_WED_WPDMA_INT_CTRL_TX_FREE			0x538
+#define MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_EN		BIT(0)
+#define MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_CLR		BIT(1)
+#define MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_TRIG	GENMASK(6, 2)
+
 #define MTK_WED_PCIE_CFG_BASE				0x560
 
+#define MTK_WED_PCIE_CFG_BASE				0x560
+#define MTK_WED_PCIE_CFG_INTM				0x564
+#define MTK_WED_PCIE_CFG_MSIS				0x568
 #define MTK_WED_PCIE_INT_TRIGGER			0x570
 #define MTK_WED_PCIE_INT_TRIGGER_STATUS			BIT(16)
 
+#define MTK_WED_PCIE_INT_CTRL				0x57c
+#define MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA		BIT(20)
+#define MTK_WED_PCIE_INT_CTRL_SRC_SEL			GENMASK(17, 16)
+#define MTK_WED_PCIE_INT_CTRL_POLL_EN			GENMASK(13, 12)
+
 #define MTK_WED_WPDMA_CFG_BASE				0x580
+#define MTK_WED_WPDMA_CFG_INT_MASK			0x584
+#define MTK_WED_WPDMA_CFG_TX				0x588
+#define MTK_WED_WPDMA_CFG_TX_FREE			0x58c
 
 #define MTK_WED_WPDMA_TX_MIB(_n)			(0x5a0 + (_n) * 4)
 #define MTK_WED_WPDMA_TX_COHERENT_MIB(_n)		(0x5d0 + (_n) * 4)
@@ -203,15 +262,24 @@ struct mtk_wdma_desc {
 #define MTK_WED_WDMA_RESET_IDX_RX			GENMASK(17, 16)
 #define MTK_WED_WDMA_RESET_IDX_DRV			GENMASK(25, 24)
 
+#define MTK_WED_WDMA_INT_CLR				0xa24
+#define MTK_WED_WDMA_INT_CLR_RX_DONE			GENMASK(17, 16)
+
 #define MTK_WED_WDMA_INT_TRIGGER			0xa28
 #define MTK_WED_WDMA_INT_TRIGGER_RX_DONE		GENMASK(17, 16)
 
 #define MTK_WED_WDMA_INT_CTRL				0xa2c
 #define MTK_WED_WDMA_INT_CTRL_POLL_SRC_SEL		GENMASK(17, 16)
 
+#define MTK_WED_WDMA_CFG_BASE				0xaa0
 #define MTK_WED_WDMA_OFFSET0				0xaa4
 #define MTK_WED_WDMA_OFFSET1				0xaa8
 
+#define MTK_WED_WDMA_OFST0_GLO_INTS			GENMASK(15, 0)
+#define MTK_WED_WDMA_OFST0_GLO_CFG			GENMASK(31, 16)
+#define MTK_WED_WDMA_OFST1_TX_CTRL			GENMASK(15, 0)
+#define MTK_WED_WDMA_OFST1_RX_CTRL			GENMASK(31, 16)
+
 #define MTK_WED_WDMA_RX_MIB(_n)				(0xae0 + (_n) * 4)
 #define MTK_WED_WDMA_RX_RECYCLE_MIB(_n)			(0xae8 + (_n) * 4)
 #define MTK_WED_WDMA_RX_PROCESSED_MIB(_n)		(0xaf0 + (_n) * 4)
@@ -221,6 +289,7 @@ struct mtk_wdma_desc {
 #define MTK_WED_RING_OFS_CPU_IDX			0x08
 #define MTK_WED_RING_OFS_DMA_IDX			0x0c
 
+#define MTK_WDMA_RING_TX(_n)				(0x000 + (_n) * 0x10)
 #define MTK_WDMA_RING_RX(_n)				(0x100 + (_n) * 0x10)
 
 #define MTK_WDMA_GLO_CFG				0x204
@@ -234,6 +303,8 @@ struct mtk_wdma_desc {
 #define MTK_WDMA_RESET_IDX_TX				GENMASK(3, 0)
 #define MTK_WDMA_RESET_IDX_RX				GENMASK(17, 16)
 
+#define MTK_WDMA_INT_STATUS				0x220
+
 #define MTK_WDMA_INT_MASK				0x228
 #define MTK_WDMA_INT_MASK_TX_DONE			GENMASK(3, 0)
 #define MTK_WDMA_INT_MASK_RX_DONE			GENMASK(17, 16)
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 7e00cca06709..592221a7149b 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -14,6 +14,7 @@ struct mtk_wdma_desc;
 struct mtk_wed_ring {
 	struct mtk_wdma_desc *desc;
 	dma_addr_t desc_phys;
+	u32 desc_size;
 	int size;
 
 	u32 reg_base;
@@ -45,10 +46,17 @@ struct mtk_wed_device {
 		struct pci_dev *pci_dev;
 
 		u32 wpdma_phys;
+		u32 wpdma_int;
+		u32 wpdma_mask;
+		u32 wpdma_tx;
+		u32 wpdma_txfree;
 
 		u16 token_start;
 		unsigned int nbuf;
 
+		u8 tx_tbit[MTK_WED_TX_QUEUES];
+		u8 txfree_tbit;
+
 		u32 (*init_buf)(void *ptr, dma_addr_t phys, int token_id);
 		int (*offload_enable)(struct mtk_wed_device *wed);
 		void (*offload_disable)(struct mtk_wed_device *wed);
-- 
2.37.3

