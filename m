Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D365F60959A
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiJWS25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiJWS2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A114DF2D;
        Sun, 23 Oct 2022 11:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46DCC60F3C;
        Sun, 23 Oct 2022 18:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EE6C433C1;
        Sun, 23 Oct 2022 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666549721;
        bh=tKus4r7U0EWe2a5vdFYJE3AKpTtp1zuG6zDZAwaruIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgvRq0agY3dwpTM/EyJTPH41qr9+YSRt1mFFKfaz2c9tvIjBJpVad7G2eZJQ3Y6r3
         CiXxTjGya2uUTh6ctizROvvdztLJKibUCMVm7FotoItGJqtQJyIYwXdPeMyViqqZiF
         M8cH+jQqtvTUOGe2VmCxfWAqO4HI5ydUg5flePJN91M7hnVb2Xf+rdtUK+e9dwarF9
         ZEUHx/LYJbwPSPNlGCrmzBKXZc4EMxsNAymt6+cc/eEBWx2dwsPaECXvU8xFZxt8fd
         vxdYMessxCpo7AQlQ5ihwsVGPtZYKICF1mjcC1shwWZaNk3mW9rggi4nwruIxSCxGo
         pMUnEop8DNygg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 5/6] net: ethernet: mtk_wed: add configure wed wo support
Date:   Sun, 23 Oct 2022 20:28:09 +0200
Message-Id: <de532662413cfcfa2239e1f6238266e5dcd53c8e.1666549145.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666549145.git.lorenzo@kernel.org>
References: <cover.1666549145.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable RX Wireless Ethernet Dispatch available on MT7986 Soc.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 572 +++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_wed.h      |  19 +
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c  |  45 +-
 drivers/net/ethernet/mediatek/mtk_wed_regs.h | 128 ++++-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h   |  28 +
 include/linux/soc/mediatek/mtk_wed.h         |  75 ++-
 6 files changed, 816 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 9c9dd17332b6..61d8a193db26 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -23,6 +23,7 @@
 #define MTK_WED_PKT_SIZE		1900
 #define MTK_WED_BUF_SIZE		2048
 #define MTK_WED_BUF_PER_PAGE		(PAGE_SIZE / 2048)
+#define MTK_WED_RX_RING_SIZE		1536
 
 #define MTK_WED_TX_RING_SIZE		2048
 #define MTK_WED_WDMA_RING_SIZE		1024
@@ -31,6 +32,10 @@
 #define MTK_WED_PER_GROUP_PKT		128
 
 #define MTK_WED_FBUF_SIZE		128
+#define MTK_WED_MIOD_CNT		16
+#define MTK_WED_FB_CMD_CNT		1024
+#define MTK_WED_RRO_QUE_CNT		8192
+#define MTK_WED_MIOD_ENTRY_CNT		128
 
 static struct mtk_wed_hw *hw_list[2];
 static DEFINE_MUTEX(hw_lock);
@@ -65,12 +70,76 @@ wdma_set(struct mtk_wed_device *dev, u32 reg, u32 mask)
 	wdma_m32(dev, reg, 0, mask);
 }
 
+static void
+wdma_clr(struct mtk_wed_device *dev, u32 reg, u32 mask)
+{
+	wdma_m32(dev, reg, mask, 0);
+}
+
+static u32
+wifi_r32(struct mtk_wed_device *dev, u32 reg)
+{
+	return readl(dev->wlan.base + reg);
+}
+
+static void
+wifi_w32(struct mtk_wed_device *dev, u32 reg, u32 val)
+{
+	writel(val, dev->wlan.base + reg);
+}
+
 static u32
 mtk_wed_read_reset(struct mtk_wed_device *dev)
 {
 	return wed_r32(dev, MTK_WED_RESET);
 }
 
+static u32
+mtk_wdma_read_reset(struct mtk_wed_device *dev)
+{
+	return wdma_r32(dev, MTK_WDMA_GLO_CFG);
+}
+
+static void
+mtk_wdma_rx_reset(struct mtk_wed_device *dev)
+{
+	u32 status, mask = MTK_WDMA_GLO_CFG_RX_DMA_BUSY;
+	int i;
+
+	wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_RX_DMA_EN);
+	if (readx_poll_timeout(mtk_wdma_read_reset, dev, status,
+			       !(status & mask), 0, 1000))
+		dev_err(dev->hw->dev, "rx reset failed\n");
+
+	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++) {
+		if (dev->rx_wdma[i].desc)
+			continue;
+
+		wdma_w32(dev,
+			 MTK_WDMA_RING_RX(i) + MTK_WED_RING_OFS_CPU_IDX, 0);
+	}
+}
+
+static void
+mtk_wdma_tx_reset(struct mtk_wed_device *dev)
+{
+	u32 status, mask = MTK_WDMA_GLO_CFG_TX_DMA_BUSY;
+	int i;
+
+	wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
+	if (readx_poll_timeout(mtk_wdma_read_reset, dev, status,
+			       !(status & mask), 0, 1000))
+		dev_err(dev->hw->dev, "tx reset failed\n");
+
+	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++) {
+		if (dev->tx_wdma[i].desc)
+			continue;
+
+		wdma_w32(dev,
+			 MTK_WDMA_RING_TX(i) + MTK_WED_RING_OFS_CPU_IDX, 0);
+	}
+}
+
 static void
 mtk_wed_reset(struct mtk_wed_device *dev, u32 mask)
 {
@@ -82,6 +151,50 @@ mtk_wed_reset(struct mtk_wed_device *dev, u32 mask)
 		WARN_ON_ONCE(1);
 }
 
+static void
+mtk_wed_wo_reset(struct mtk_wed_device *dev)
+{
+	unsigned long timeout = jiffies + MTK_WOCPU_TIMEOUT;
+	struct mtk_wed_wo *wo = dev->hw->wed_wo;
+	u8 state = MTK_WED_WO_STATE_DISABLE;
+	void __iomem *reg;
+	u32 val;
+
+	mtk_wdma_tx_reset(dev);
+	mtk_wed_reset(dev, MTK_WED_RESET_WED);
+
+	mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
+			     MTK_WED_WO_CMD_CHANGE_STATE, &state,
+			     sizeof(state), false);
+	do {
+		val = wed_r32(dev,
+			      MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_WO_STATUS);
+		usleep_range(100, 200);
+	} while (val != MTK_WED_WOIF_DISABLE_DONE &&
+		 !time_after(jiffies, timeout));
+
+	reg = ioremap(MTK_WED_WO_CPU_MCUSYS_RESET_ADDR, 4);
+
+	val = readl(reg);
+	switch (dev->hw->index) {
+	case 0:
+		val |= MTK_WED_WO_CPU_WO0_MCUSYS_RESET_MASK;
+		writel(val, reg);
+		val &= ~MTK_WED_WO_CPU_WO0_MCUSYS_RESET_MASK;
+		writel(val, reg);
+		break;
+	case 1:
+		val |= MTK_WED_WO_CPU_WO1_MCUSYS_RESET_MASK;
+		writel(val, reg);
+		val &= ~MTK_WED_WO_CPU_WO1_MCUSYS_RESET_MASK;
+		writel(val, reg);
+		break;
+	default:
+		break;
+	}
+	iounmap(reg);
+}
+
 static struct mtk_wed_hw *
 mtk_wed_assign(struct mtk_wed_device *dev)
 {
@@ -133,16 +246,16 @@ mtk_wed_buffer_alloc(struct mtk_wed_device *dev)
 	if (!page_list)
 		return -ENOMEM;
 
-	dev->buf_ring.size = ring_size;
-	dev->buf_ring.pages = page_list;
+	dev->tx_buf_ring.size = ring_size;
+	dev->tx_buf_ring.pages = page_list;
 
 	desc = dma_alloc_coherent(dev->hw->dev, ring_size * sizeof(*desc),
 				  &desc_phys, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
-	dev->buf_ring.desc = desc;
-	dev->buf_ring.desc_phys = desc_phys;
+	dev->tx_buf_ring.desc = desc;
+	dev->tx_buf_ring.desc_phys = desc_phys;
 
 	for (i = 0, page_idx = 0; i < ring_size; i += MTK_WED_BUF_PER_PAGE) {
 		dma_addr_t page_phys, buf_phys;
@@ -205,8 +318,8 @@ mtk_wed_buffer_alloc(struct mtk_wed_device *dev)
 static void
 mtk_wed_free_buffer(struct mtk_wed_device *dev)
 {
-	struct mtk_wdma_desc *desc = dev->buf_ring.desc;
-	void **page_list = dev->buf_ring.pages;
+	struct mtk_wdma_desc *desc = dev->tx_buf_ring.desc;
+	void **page_list = dev->tx_buf_ring.pages;
 	int page_idx;
 	int i;
 
@@ -216,7 +329,8 @@ mtk_wed_free_buffer(struct mtk_wed_device *dev)
 	if (!desc)
 		goto free_pagelist;
 
-	for (i = 0, page_idx = 0; i < dev->buf_ring.size; i += MTK_WED_BUF_PER_PAGE) {
+	for (i = 0, page_idx = 0; i < dev->tx_buf_ring.size;
+	     i += MTK_WED_BUF_PER_PAGE) {
 		void *page = page_list[page_idx++];
 		dma_addr_t buf_addr;
 
@@ -229,13 +343,46 @@ mtk_wed_free_buffer(struct mtk_wed_device *dev)
 		__free_page(page);
 	}
 
-	dma_free_coherent(dev->hw->dev, dev->buf_ring.size * sizeof(*desc),
-			  desc, dev->buf_ring.desc_phys);
+	dma_free_coherent(dev->hw->dev, dev->tx_buf_ring.size * sizeof(*desc),
+			  desc, dev->tx_buf_ring.desc_phys);
 
 free_pagelist:
 	kfree(page_list);
 }
 
+static int
+mtk_wed_rx_bm_alloc(struct mtk_wed_device *dev)
+{
+	struct mtk_rxbm_desc *desc;
+	dma_addr_t desc_phys;
+
+	dev->rx_buf_ring.size = dev->wlan.rx_nbuf;
+	desc = dma_alloc_coherent(dev->hw->dev,
+				  dev->wlan.rx_nbuf * sizeof(*desc),
+				  &desc_phys, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	dev->rx_buf_ring.desc = desc;
+	dev->rx_buf_ring.desc_phys = desc_phys;
+	dev->wlan.init_rx_buf(dev, dev->wlan.rx_npkt);
+
+	return 0;
+}
+
+static void
+mtk_wed_free_rx_bm(struct mtk_wed_device *dev)
+{
+	struct mtk_rxbm_desc *desc = dev->rx_buf_ring.desc;
+
+	if (!desc)
+		return;
+
+	dev->wlan.release_rx_buf(dev);
+	dma_free_coherent(dev->hw->dev, dev->rx_buf_ring.size * sizeof(*desc),
+			  desc, dev->rx_buf_ring.desc_phys);
+}
+
 static void
 mtk_wed_free_ring(struct mtk_wed_device *dev, struct mtk_wed_ring *ring)
 {
@@ -246,6 +393,13 @@ mtk_wed_free_ring(struct mtk_wed_device *dev, struct mtk_wed_ring *ring)
 			  ring->desc, ring->desc_phys);
 }
 
+static void
+mtk_wed_free_rx_rings(struct mtk_wed_device *dev)
+{
+	mtk_wed_free_rx_bm(dev);
+	mtk_wed_free_ring(dev, &dev->rro.ring);
+}
+
 static void
 mtk_wed_free_tx_rings(struct mtk_wed_device *dev)
 {
@@ -291,6 +445,35 @@ mtk_wed_set_512_support(struct mtk_wed_device *dev, bool enable)
 	}
 }
 
+#define MTK_WFMDA_RX_DMA_EN	BIT(2)
+static void
+mtk_wed_check_wfdma_rx_fill(struct mtk_wed_device *dev, int idx)
+{
+	u32 val;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		u32 cur_idx;
+
+		cur_idx = wed_r32(dev,
+				  MTK_WED_WPDMA_RING_RX_DATA(idx) +
+				  MTK_WED_RING_OFS_CPU_IDX);
+		if (cur_idx == MTK_WED_RX_RING_SIZE - 1)
+			break;
+
+		usleep_range(100000, 200000);
+	}
+
+	if (i == 3) {
+		dev_err(dev->hw->dev, "rx dma enable failed\n");
+		return;
+	}
+
+	val = wifi_r32(dev, dev->wlan.wpdma_rx_glo - dev->wlan.phy_base) |
+	      MTK_WFMDA_RX_DMA_EN;
+	wifi_w32(dev, dev->wlan.wpdma_rx_glo - dev->wlan.phy_base, val);
+}
+
 static void
 mtk_wed_dma_disable(struct mtk_wed_device *dev)
 {
@@ -304,20 +487,25 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
 		MTK_WED_GLO_CFG_TX_DMA_EN |
 		MTK_WED_GLO_CFG_RX_DMA_EN);
 
-	wdma_m32(dev, MTK_WDMA_GLO_CFG,
+	wdma_clr(dev, MTK_WDMA_GLO_CFG,
 		 MTK_WDMA_GLO_CFG_TX_DMA_EN |
 		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
-		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES, 0);
+		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES);
 
 	if (dev->hw->version == 1) {
 		regmap_write(dev->hw->mirror, dev->hw->index * 4, 0);
-		wdma_m32(dev, MTK_WDMA_GLO_CFG,
-			 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES, 0);
+		wdma_clr(dev, MTK_WDMA_GLO_CFG,
+			 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
 	} else {
 		wed_clr(dev, MTK_WED_WPDMA_GLO_CFG,
 			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_PKT_PROC |
 			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_CRX_SYNC);
 
+		wed_clr(dev, MTK_WED_WPDMA_RX_D_GLO_CFG,
+			MTK_WED_WPDMA_RX_D_RX_DRV_EN);
+		wed_clr(dev, MTK_WED_WDMA_GLO_CFG,
+			MTK_WED_WDMA_GLO_CFG_TX_DDONE_CHK);
+
 		mtk_wed_set_512_support(dev, false);
 	}
 }
@@ -338,6 +526,13 @@ mtk_wed_stop(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_INT_MASK, 0);
 	wdma_w32(dev, MTK_WDMA_INT_GRP2, 0);
 	wed_w32(dev, MTK_WED_WPDMA_INT_MASK, 0);
+
+	if (dev->hw->version == 1)
+		return;
+
+	wed_w32(dev, MTK_WED_EXT_INT_MASK1, 0);
+	wed_w32(dev, MTK_WED_EXT_INT_MASK2, 0);
+	wed_clr(dev, MTK_WED_CTRL, MTK_WED_CTRL_WED_RX_BM_EN);
 }
 
 static void
@@ -353,11 +548,21 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
 
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
+	if (mtk_wed_get_rx_capa(dev)) {
+		wdma_clr(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_TX_DMA_EN);
+		wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_TX);
+		wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
+	}
 
 	mtk_wed_free_buffer(dev);
 	mtk_wed_free_tx_rings(dev);
-	if (hw->version != 1)
+
+	if (mtk_wed_get_rx_capa(dev)) {
+		mtk_wed_wo_reset(dev);
+		mtk_wed_free_rx_rings(dev);
 		mtk_wed_wo_deinit(hw);
+		mtk_wdma_rx_reset(dev);
+	}
 
 	if (dev->wlan.bus_type == MTK_WED_BUS_PCIE) {
 		struct device_node *wlan_node;
@@ -434,10 +639,12 @@ mtk_wed_set_wpdma(struct mtk_wed_device *dev)
 	} else {
 		mtk_wed_bus_init(dev);
 
-		wed_w32(dev, MTK_WED_WPDMA_CFG_BASE,  dev->wlan.wpdma_int);
-		wed_w32(dev, MTK_WED_WPDMA_CFG_INT_MASK,  dev->wlan.wpdma_mask);
-		wed_w32(dev, MTK_WED_WPDMA_CFG_TX,  dev->wlan.wpdma_tx);
-		wed_w32(dev, MTK_WED_WPDMA_CFG_TX_FREE,  dev->wlan.wpdma_txfree);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_BASE, dev->wlan.wpdma_int);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_INT_MASK, dev->wlan.wpdma_mask);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_TX, dev->wlan.wpdma_tx);
+		wed_w32(dev, MTK_WED_WPDMA_CFG_TX_FREE, dev->wlan.wpdma_txfree);
+		wed_w32(dev, MTK_WED_WPDMA_RX_GLO_CFG, dev->wlan.wpdma_rx_glo);
+		wed_w32(dev, MTK_WED_WPDMA_RX_RING, dev->wlan.wpdma_rx);
 	}
 }
 
@@ -487,6 +694,67 @@ mtk_wed_hw_init_early(struct mtk_wed_device *dev)
 	}
 }
 
+static void
+mtk_wed_rx_bm_hw_init(struct mtk_wed_device *dev)
+{
+	wed_w32(dev, MTK_WED_RX_BM_RX_DMAD,
+		FIELD_PREP(MTK_WED_RX_BM_RX_DMAD_SDL0, dev->wlan.rx_size));
+	wed_w32(dev, MTK_WED_RX_BM_BASE, dev->rx_buf_ring.desc_phys);
+	wed_w32(dev, MTK_WED_RX_BM_INIT_PTR, MTK_WED_RX_BM_INIT_SW_TAIL |
+		FIELD_PREP(MTK_WED_RX_BM_SW_TAIL, dev->wlan.rx_npkt));
+	wed_w32(dev, MTK_WED_RX_BM_DYN_ALLOC_TH,
+		FIELD_PREP(MTK_WED_RX_BM_DYN_ALLOC_TH_H, 0xffff));
+	wed_set(dev, MTK_WED_CTRL, MTK_WED_CTRL_WED_RX_BM_EN);
+}
+
+static void
+mtk_wed_rro_hw_init(struct mtk_wed_device *dev)
+{
+	wed_w32(dev, MTK_WED_RROQM_MIOD_CFG,
+		FIELD_PREP(MTK_WED_RROQM_MIOD_MID_DW, 0x70 >> 2) |
+		FIELD_PREP(MTK_WED_RROQM_MIOD_MOD_DW, 0x10 >> 2) |
+		FIELD_PREP(MTK_WED_RROQM_MIOD_ENTRY_DW,
+			   MTK_WED_MIOD_ENTRY_CNT >> 2));
+
+	wed_w32(dev, MTK_WED_RROQM_MIOD_CTRL0, dev->rro.miod_phys);
+	wed_w32(dev, MTK_WED_RROQM_MIOD_CTRL1,
+		FIELD_PREP(MTK_WED_RROQM_MIOD_CNT, MTK_WED_MIOD_CNT));
+	wed_w32(dev, MTK_WED_RROQM_FDBK_CTRL0, dev->rro.fdbk_phys);
+	wed_w32(dev, MTK_WED_RROQM_FDBK_CTRL1,
+		FIELD_PREP(MTK_WED_RROQM_FDBK_CNT, MTK_WED_FB_CMD_CNT));
+	wed_w32(dev, MTK_WED_RROQM_FDBK_CTRL2, 0);
+	wed_w32(dev, MTK_WED_RROQ_BASE_L, dev->rro.ring.desc_phys);
+
+	wed_set(dev, MTK_WED_RROQM_RST_IDX,
+		MTK_WED_RROQM_RST_IDX_MIOD |
+		MTK_WED_RROQM_RST_IDX_FDBK);
+
+	wed_w32(dev, MTK_WED_RROQM_RST_IDX, 0);
+	wed_w32(dev, MTK_WED_RROQM_MIOD_CTRL2, MTK_WED_MIOD_CNT - 1);
+	wed_set(dev, MTK_WED_CTRL, MTK_WED_CTRL_RX_RRO_QM_EN);
+}
+
+static void
+mtk_wed_route_qm_hw_init(struct mtk_wed_device *dev)
+{
+	wed_w32(dev, MTK_WED_RESET, MTK_WED_RESET_RX_ROUTE_QM);
+
+	for (;;) {
+		usleep_range(100, 200);
+		if (!(wed_r32(dev, MTK_WED_RESET) & MTK_WED_RESET_RX_ROUTE_QM))
+			break;
+	}
+
+	/* configure RX_ROUTE_QM */
+	wed_clr(dev, MTK_WED_RTQM_GLO_CFG, MTK_WED_RTQM_Q_RST);
+	wed_clr(dev, MTK_WED_RTQM_GLO_CFG, MTK_WED_RTQM_TXDMAD_FPORT);
+	wed_set(dev, MTK_WED_RTQM_GLO_CFG,
+		FIELD_PREP(MTK_WED_RTQM_TXDMAD_FPORT, 0x3 + dev->hw->index));
+	wed_clr(dev, MTK_WED_RTQM_GLO_CFG, MTK_WED_RTQM_Q_RST);
+	/* enable RX_ROUTE_QM */
+	wed_set(dev, MTK_WED_CTRL, MTK_WED_CTRL_RX_ROUTE_QM_EN);
+}
+
 static void
 mtk_wed_hw_init(struct mtk_wed_device *dev)
 {
@@ -498,11 +766,11 @@ mtk_wed_hw_init(struct mtk_wed_device *dev)
 	wed_w32(dev, MTK_WED_TX_BM_CTRL,
 		MTK_WED_TX_BM_CTRL_PAUSE |
 		FIELD_PREP(MTK_WED_TX_BM_CTRL_VLD_GRP_NUM,
-			   dev->buf_ring.size / 128) |
+			   dev->tx_buf_ring.size / 128) |
 		FIELD_PREP(MTK_WED_TX_BM_CTRL_RSV_GRP_NUM,
 			   MTK_WED_TX_RING_SIZE / 256));
 
-	wed_w32(dev, MTK_WED_TX_BM_BASE, dev->buf_ring.desc_phys);
+	wed_w32(dev, MTK_WED_TX_BM_BASE, dev->tx_buf_ring.desc_phys);
 
 	wed_w32(dev, MTK_WED_TX_BM_BUF_LEN, MTK_WED_PKT_SIZE);
 
@@ -529,9 +797,9 @@ mtk_wed_hw_init(struct mtk_wed_device *dev)
 		wed_w32(dev, MTK_WED_TX_TKID_CTRL,
 			MTK_WED_TX_TKID_CTRL_PAUSE |
 			FIELD_PREP(MTK_WED_TX_TKID_CTRL_VLD_GRP_NUM,
-				   dev->buf_ring.size / 128) |
+				   dev->tx_buf_ring.size / 128) |
 			FIELD_PREP(MTK_WED_TX_TKID_CTRL_RSV_GRP_NUM,
-				   dev->buf_ring.size / 128));
+				   dev->tx_buf_ring.size / 128));
 		wed_w32(dev, MTK_WED_TX_TKID_DYN_THR,
 			FIELD_PREP(MTK_WED_TX_TKID_DYN_THR_LO, 0) |
 			MTK_WED_TX_TKID_DYN_THR_HI);
@@ -539,18 +807,28 @@ mtk_wed_hw_init(struct mtk_wed_device *dev)
 
 	mtk_wed_reset(dev, MTK_WED_RESET_TX_BM);
 
-	if (dev->hw->version == 1)
+	if (dev->hw->version == 1) {
 		wed_set(dev, MTK_WED_CTRL,
 			MTK_WED_CTRL_WED_TX_BM_EN |
 			MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
-	else
+	} else {
 		wed_clr(dev, MTK_WED_TX_TKID_CTRL, MTK_WED_TX_TKID_CTRL_PAUSE);
+		/* rx hw init */
+		wed_w32(dev, MTK_WED_WPDMA_RX_D_RST_IDX,
+			MTK_WED_WPDMA_RX_D_RST_CRX_IDX |
+			MTK_WED_WPDMA_RX_D_RST_DRV_IDX);
+		wed_w32(dev, MTK_WED_WPDMA_RX_D_RST_IDX, 0);
+
+		mtk_wed_rx_bm_hw_init(dev);
+		mtk_wed_rro_hw_init(dev);
+		mtk_wed_route_qm_hw_init(dev);
+	}
 
 	wed_clr(dev, MTK_WED_TX_BM_CTRL, MTK_WED_TX_BM_CTRL_PAUSE);
 }
 
 static void
-mtk_wed_ring_reset(struct mtk_wed_ring *ring, int size)
+mtk_wed_ring_reset(struct mtk_wed_ring *ring, int size, bool tx)
 {
 	void *head = (void *)ring->desc;
 	int i;
@@ -560,7 +838,10 @@ mtk_wed_ring_reset(struct mtk_wed_ring *ring, int size)
 
 		desc = (struct mtk_wdma_desc *)(head + i * ring->desc_size);
 		desc->buf0 = 0;
-		desc->ctrl = cpu_to_le32(MTK_WDMA_DESC_CTRL_DMA_DONE);
+		if (tx)
+			desc->ctrl = cpu_to_le32(MTK_WDMA_DESC_CTRL_DMA_DONE);
+		else
+			desc->ctrl = cpu_to_le32(MTK_WFDMA_DESC_CTRL_TO_HOST);
 		desc->buf1 = 0;
 		desc->info = 0;
 	}
@@ -616,7 +897,8 @@ mtk_wed_reset_dma(struct mtk_wed_device *dev)
 		if (!dev->tx_ring[i].desc)
 			continue;
 
-		mtk_wed_ring_reset(&dev->tx_ring[i], MTK_WED_TX_RING_SIZE);
+		mtk_wed_ring_reset(&dev->tx_ring[i], MTK_WED_TX_RING_SIZE,
+				   true);
 	}
 
 	if (mtk_wed_poll_busy(dev))
@@ -634,6 +916,9 @@ mtk_wed_reset_dma(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_RESET_IDX, MTK_WDMA_RESET_IDX_RX);
 	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
 
+	if (mtk_wed_get_rx_capa(dev))
+		mtk_wdma_rx_reset(dev);
+
 	if (busy) {
 		mtk_wed_reset(dev, MTK_WED_RESET_WDMA_INT_AGENT);
 		mtk_wed_reset(dev, MTK_WED_RESET_WDMA_RX_DRV);
@@ -668,12 +953,28 @@ mtk_wed_reset_dma(struct mtk_wed_device *dev)
 			MTK_WED_WPDMA_RESET_IDX_RX);
 		wed_w32(dev, MTK_WED_WPDMA_RESET_IDX, 0);
 	}
+}
 
+static int
+mtk_wed_rro_ring_alloc(struct mtk_wed_device *dev, struct mtk_wed_ring *ring,
+		       int size)
+{
+	ring->desc = dma_alloc_coherent(dev->hw->dev,
+					size * sizeof(*ring->desc),
+					&ring->desc_phys, GFP_KERNEL);
+	if (!ring->desc)
+		return -ENOMEM;
+
+	ring->desc_size = sizeof(*ring->desc);
+	ring->size = size;
+	memset(ring->desc, 0, size);
+
+	return 0;
 }
 
 static int
 mtk_wed_ring_alloc(struct mtk_wed_device *dev, struct mtk_wed_ring *ring,
-		   int size, u32 desc_size)
+		   int size, u32 desc_size, bool tx)
 {
 	ring->desc = dma_alloc_coherent(dev->hw->dev, size * desc_size,
 					&ring->desc_phys, GFP_KERNEL);
@@ -682,18 +983,19 @@ mtk_wed_ring_alloc(struct mtk_wed_device *dev, struct mtk_wed_ring *ring,
 
 	ring->desc_size = desc_size;
 	ring->size = size;
-	mtk_wed_ring_reset(ring, size);
+	mtk_wed_ring_reset(ring, size, tx);
 
 	return 0;
 }
 
 static int
-mtk_wed_wdma_ring_setup(struct mtk_wed_device *dev, int idx, int size)
+mtk_wed_wdma_rx_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 {
 	u32 desc_size = sizeof(struct mtk_wdma_desc) * dev->hw->version;
 	struct mtk_wed_ring *wdma = &dev->tx_wdma[idx];
 
-	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size))
+	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size,
+			       true))
 		return -ENOMEM;
 
 	wdma_w32(dev, MTK_WDMA_RING_RX(idx) + MTK_WED_RING_OFS_BASE,
@@ -710,6 +1012,112 @@ mtk_wed_wdma_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 	return 0;
 }
 
+static int
+mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size)
+{
+	u32 desc_size = sizeof(struct mtk_wdma_desc) * dev->hw->version;
+	struct mtk_wed_ring *wdma = &dev->rx_wdma[idx];
+
+	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size,
+			       true))
+		return -ENOMEM;
+
+	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_BASE,
+		 wdma->desc_phys);
+	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_COUNT,
+		 size);
+	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_CPU_IDX, 0);
+	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_DMA_IDX, 0);
+
+	if (!idx)  {
+		wed_w32(dev, MTK_WED_WDMA_RING_TX + MTK_WED_RING_OFS_BASE,
+			wdma->desc_phys);
+		wed_w32(dev, MTK_WED_WDMA_RING_TX + MTK_WED_RING_OFS_COUNT,
+			size);
+		wed_w32(dev, MTK_WED_WDMA_RING_TX + MTK_WED_RING_OFS_CPU_IDX,
+			0);
+		wed_w32(dev, MTK_WED_WDMA_RING_TX + MTK_WED_RING_OFS_DMA_IDX,
+			0);
+	}
+
+	return 0;
+}
+
+static int
+mtk_wed_rro_alloc(struct mtk_wed_device *dev)
+{
+	struct device_node *np;
+	struct resource res;
+	int ret;
+
+	np = of_parse_phandle(dev->hw->node, "mediatek,wo-dlm", 0);
+	if (!np)
+		return -ENODEV;
+
+	ret = of_address_to_resource(np, 0, &res);
+	if (ret)
+		return ret;
+
+	dev->rro.miod_phys = res.start;
+	dev->rro.fdbk_phys = MTK_WED_MIOD_ENTRY_CNT * MTK_WED_MIOD_CNT +
+			     dev->rro.miod_phys;
+
+	if (mtk_wed_rro_ring_alloc(dev, &dev->rro.ring, MTK_WED_RRO_QUE_CNT))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int
+mtk_wed_rro_cfg(struct mtk_wed_device *dev)
+{
+	struct mtk_wed_wo *wo = dev->hw->wed_wo;
+	struct {
+		struct {
+			u32 base;
+			u32 cnt;
+			u32 unit;
+		} ring[2];
+		u32 wed;
+		u8 version;
+	} req = {
+		.ring[0] = {
+			.base = MTK_WED_WOCPU_VIEW_MIOD_BASE,
+			.cnt = MTK_WED_MIOD_CNT,
+			.unit = MTK_WED_MIOD_ENTRY_CNT,
+		},
+		.ring[1] = {
+			.base = MTK_WED_WOCPU_VIEW_MIOD_BASE +
+				MTK_WED_MIOD_ENTRY_CNT * MTK_WED_MIOD_CNT,
+			.cnt = MTK_WED_FB_CMD_CNT,
+			.unit = 4,
+		},
+	};
+
+	return mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
+				    MTK_WED_WO_CMD_WED_CFG,
+				    &req, sizeof(req), true);
+}
+
+static void
+mtk_wed_ppe_check(struct mtk_wed_device *dev, struct sk_buff *skb,
+		  u32 reason, u32 hash)
+{
+	struct mtk_eth *eth = dev->hw->eth;
+	struct ethhdr *eh;
+
+	if (!skb)
+		return;
+
+	if (reason != MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
+		return;
+
+	skb_set_mac_header(skb, 0);
+	eh = eth_hdr(skb);
+	skb->protocol = eh->h_proto;
+	mtk_ppe_check_skb(eth->ppe[dev->hw->index], skb, hash);
+}
+
 static void
 mtk_wed_configure_irq(struct mtk_wed_device *dev, u32 irq_mask)
 {
@@ -732,6 +1140,8 @@ mtk_wed_configure_irq(struct mtk_wed_device *dev, u32 irq_mask)
 
 		wed_clr(dev, MTK_WED_WDMA_INT_CTRL, wdma_mask);
 	} else {
+		wdma_mask |= FIELD_PREP(MTK_WDMA_INT_MASK_TX_DONE,
+					GENMASK(1, 0));
 		/* initail tx interrupt trigger */
 		wed_w32(dev, MTK_WED_WPDMA_INT_CTRL_TX,
 			MTK_WED_WPDMA_INT_CTRL_TX0_DONE_EN |
@@ -750,6 +1160,16 @@ mtk_wed_configure_irq(struct mtk_wed_device *dev, u32 irq_mask)
 			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_TRIG,
 				   dev->wlan.txfree_tbit));
 
+		wed_w32(dev, MTK_WED_WPDMA_INT_CTRL_RX,
+			MTK_WED_WPDMA_INT_CTRL_RX0_EN |
+			MTK_WED_WPDMA_INT_CTRL_RX0_CLR |
+			MTK_WED_WPDMA_INT_CTRL_RX1_EN |
+			MTK_WED_WPDMA_INT_CTRL_RX1_CLR |
+			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_RX0_DONE_TRIG,
+				   dev->wlan.rx_tbit[0]) |
+			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_RX1_DONE_TRIG,
+				   dev->wlan.rx_tbit[1]));
+
 		wed_w32(dev, MTK_WED_WDMA_INT_CLR, wdma_mask);
 		wed_set(dev, MTK_WED_WDMA_INT_CTRL,
 			FIELD_PREP(MTK_WED_WDMA_INT_CTRL_POLL_SRC_SEL,
@@ -787,9 +1207,15 @@ mtk_wed_dma_enable(struct mtk_wed_device *dev)
 		wdma_set(dev, MTK_WDMA_GLO_CFG,
 			 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
 	} else {
+		int i;
+
 		wed_set(dev, MTK_WED_WPDMA_CTRL,
 			MTK_WED_WPDMA_CTRL_SDL1_FIXED);
 
+		wed_set(dev, MTK_WED_WDMA_GLO_CFG,
+			MTK_WED_WDMA_GLO_CFG_TX_DRV_EN |
+			MTK_WED_WDMA_GLO_CFG_TX_DDONE_CHK);
+
 		wed_set(dev, MTK_WED_WPDMA_GLO_CFG,
 			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_PKT_PROC |
 			MTK_WED_WPDMA_GLO_CFG_RX_DRV_R0_CRX_SYNC);
@@ -797,6 +1223,15 @@ mtk_wed_dma_enable(struct mtk_wed_device *dev)
 		wed_clr(dev, MTK_WED_WPDMA_GLO_CFG,
 			MTK_WED_WPDMA_GLO_CFG_TX_TKID_KEEP |
 			MTK_WED_WPDMA_GLO_CFG_TX_DMAD_DW3_PREV);
+
+		wed_set(dev, MTK_WED_WPDMA_RX_D_GLO_CFG,
+			MTK_WED_WPDMA_RX_D_RX_DRV_EN |
+			FIELD_PREP(MTK_WED_WPDMA_RX_D_RXD_READ_LEN, 0x18) |
+			FIELD_PREP(MTK_WED_WPDMA_RX_D_INIT_PHASE_RXEN_SEL,
+				   0x2));
+
+		for (i = 0; i < MTK_WED_RX_QUEUES; i++)
+			mtk_wed_check_wfdma_rx_fill(dev, i);
 	}
 }
 
@@ -807,7 +1242,7 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 
 	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
 		if (!dev->tx_wdma[i].desc)
-			mtk_wed_wdma_ring_setup(dev, i, 16);
+			mtk_wed_wdma_rx_ring_setup(dev, i, 16);
 
 	mtk_wed_hw_init(dev);
 	mtk_wed_configure_irq(dev, irq_mask);
@@ -822,7 +1257,19 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 		val |= BIT(0) | (BIT(1) * !!dev->hw->index);
 		regmap_write(dev->hw->mirror, dev->hw->index * 4, val);
 	} else {
-		mtk_wed_set_512_support(dev, true);
+		/* driver set mid ready and only once */
+		wed_w32(dev, MTK_WED_EXT_INT_MASK1,
+			MTK_WED_EXT_INT_STATUS_WPDMA_MID_RDY);
+		wed_w32(dev, MTK_WED_EXT_INT_MASK2,
+			MTK_WED_EXT_INT_STATUS_WPDMA_MID_RDY);
+
+		wed_r32(dev, MTK_WED_EXT_INT_MASK1);
+		wed_r32(dev, MTK_WED_EXT_INT_MASK2);
+
+		if (mtk_wed_rro_cfg(dev))
+			return;
+
+		mtk_wed_set_512_support(dev, dev->wlan.wcid_512);
 	}
 
 	mtk_wed_dma_enable(dev);
@@ -856,7 +1303,7 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	if (!hw) {
 		module_put(THIS_MODULE);
 		ret = -ENODEV;
-		goto out;
+		goto unlock;
 	}
 
 	device = dev->wlan.bus_type == MTK_WED_BUS_PCIE
@@ -869,15 +1316,24 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	dev->dev = hw->dev;
 	dev->irq = hw->irq;
 	dev->wdma_idx = hw->index;
+	dev->version = hw->version;
 
 	if (hw->eth->dma_dev == hw->eth->dev &&
 	    of_dma_is_coherent(hw->eth->dev->of_node))
 		mtk_eth_set_dma_device(hw->eth, hw->dev);
 
 	ret = mtk_wed_buffer_alloc(dev);
-	if (ret) {
-		mtk_wed_detach(dev);
+	if (ret)
 		goto out;
+
+	if (mtk_wed_get_rx_capa(dev)) {
+		ret = mtk_wed_rx_bm_alloc(dev);
+		if (ret)
+			goto out;
+
+		ret = mtk_wed_rro_alloc(dev);
+		if (ret)
+			goto out;
 	}
 
 	mtk_wed_hw_init_early(dev);
@@ -886,8 +1342,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 				   BIT(hw->index), 0);
 	else
 		ret = mtk_wed_wo_init(hw);
-
 out:
+	if (ret)
+		mtk_wed_detach(dev);
+unlock:
 	mutex_unlock(&hw_lock);
 
 	return ret;
@@ -910,13 +1368,14 @@ mtk_wed_tx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs)
 	 * WDMA RX.
 	 */
 
-	BUG_ON(idx >= ARRAY_SIZE(dev->tx_ring));
+	if (WARN_ON(idx >= ARRAY_SIZE(dev->tx_ring)))
+		return -EINVAL;
 
 	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_TX_RING_SIZE,
-			       sizeof(*ring->desc)))
+			       sizeof(*ring->desc), true))
 		return -ENOMEM;
 
-	if (mtk_wed_wdma_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
+	if (mtk_wed_wdma_rx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
 		return -ENOMEM;
 
 	ring->reg_base = MTK_WED_RING_TX(idx);
@@ -960,6 +1419,36 @@ mtk_wed_txfree_ring_setup(struct mtk_wed_device *dev, void __iomem *regs)
 	return 0;
 }
 
+static int
+mtk_wed_rx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs)
+{
+	struct mtk_wed_ring *ring = &dev->rx_ring[idx];
+
+	if (WARN_ON(idx >= ARRAY_SIZE(dev->rx_ring)))
+		return -EINVAL;
+
+	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_RX_RING_SIZE,
+			       sizeof(*ring->desc), false))
+		return -ENOMEM;
+
+	if (mtk_wed_wdma_tx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
+		return -ENOMEM;
+
+	ring->reg_base = MTK_WED_RING_RX_DATA(idx);
+	ring->wpdma = regs;
+
+	/* WPDMA ->  WED */
+	wpdma_rx_w32(dev, idx, MTK_WED_RING_OFS_BASE, ring->desc_phys);
+	wpdma_rx_w32(dev, idx, MTK_WED_RING_OFS_COUNT, MTK_WED_RX_RING_SIZE);
+
+	wed_w32(dev, MTK_WED_WPDMA_RING_RX_DATA(idx) + MTK_WED_RING_OFS_BASE,
+		ring->desc_phys);
+	wed_w32(dev, MTK_WED_WPDMA_RING_RX_DATA(idx) + MTK_WED_RING_OFS_COUNT,
+		MTK_WED_RX_RING_SIZE);
+
+	return 0;
+}
+
 static u32
 mtk_wed_irq_get(struct mtk_wed_device *dev, u32 mask)
 {
@@ -1056,7 +1545,9 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	static const struct mtk_wed_ops wed_ops = {
 		.attach = mtk_wed_attach,
 		.tx_ring_setup = mtk_wed_tx_ring_setup,
+		.rx_ring_setup = mtk_wed_rx_ring_setup,
 		.txfree_ring_setup = mtk_wed_txfree_ring_setup,
+		.msg_update = mtk_wed_mcu_msg_update,
 		.start = mtk_wed_start,
 		.stop = mtk_wed_stop,
 		.reset_dma = mtk_wed_reset_dma,
@@ -1065,6 +1556,7 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 		.irq_get = mtk_wed_irq_get,
 		.irq_set_mask = mtk_wed_irq_set_mask,
 		.detach = mtk_wed_detach,
+		.ppe_check = mtk_wed_ppe_check,
 	};
 	struct device_node *eth_np = eth->dev->of_node;
 	struct platform_device *pdev;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
index af656fd31ff9..e012b8a82133 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed.h
@@ -86,6 +86,24 @@ wpdma_tx_w32(struct mtk_wed_device *dev, int ring, u32 reg, u32 val)
 	writel(val, dev->tx_ring[ring].wpdma + reg);
 }
 
+static inline u32
+wpdma_rx_r32(struct mtk_wed_device *dev, int ring, u32 reg)
+{
+	if (!dev->rx_ring[ring].wpdma)
+		return 0;
+
+	return readl(dev->rx_ring[ring].wpdma + reg);
+}
+
+static inline void
+wpdma_rx_w32(struct mtk_wed_device *dev, int ring, u32 reg, u32 val)
+{
+	if (!dev->rx_ring[ring].wpdma)
+		return;
+
+	writel(val, dev->rx_ring[ring].wpdma + reg);
+}
+
 static inline u32
 wpdma_txfree_r32(struct mtk_wed_device *dev, u32 reg)
 {
@@ -128,6 +146,7 @@ static inline int mtk_wed_flow_add(int index)
 static inline void mtk_wed_flow_remove(int index)
 {
 }
+
 #endif
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index e58beda37152..02e6b54a0a1a 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -5,6 +5,7 @@
 #include <linux/of_address.h>
 #include <linux/mfd/syscon.h>
 #include <linux/soc/mediatek/mtk_wed.h>
+#include <asm/unaligned.h>
 
 #include "mtk_wed_regs.h"
 #include "mtk_wed_wo.h"
@@ -60,24 +61,37 @@ void mtk_wed_mcu_rx_event(struct mtk_wed_wo *wo, struct sk_buff *skb)
 	wake_up(&wo->mcu.wait);
 }
 
+static void
+mtk_wed_update_rx_stats(struct mtk_wed_device *wed, struct sk_buff *skb)
+{
+	u32 count = get_unaligned_le32(skb->data);
+	struct mtk_wed_wo_rx_stats *stats;
+	int i;
+
+	if (count * sizeof(*stats) > skb->len - sizeof(u32))
+		return;
+
+	stats = (struct mtk_wed_wo_rx_stats *)(skb->data + sizeof(u32));
+	for (i = 0 ; i < count ; i++)
+		wed->wlan.update_wo_rx_stats(wed, &stats[i]);
+}
+
 void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
 				      struct sk_buff *skb)
 {
 	struct mtk_wed_mcu_hdr *hdr = (struct mtk_wed_mcu_hdr *)skb->data;
 
-	switch (hdr->cmd) {
-	case MTK_WED_WO_EVT_LOG_DUMP: {
-		const char *msg = (const char *)(skb->data + sizeof(*hdr));
+	skb_pull(skb, sizeof(*hdr));
 
-		dev_notice(wo->hw->dev, "%s\n", msg);
+	switch (hdr->cmd) {
+	case MTK_WED_WO_EVT_LOG_DUMP:
+		dev_notice(wo->hw->dev, "%s\n", skb->data);
 		break;
-	}
 	case MTK_WED_WO_EVT_PROFILING: {
-		struct mtk_wed_wo_log_info *info;
-		u32 count = (skb->len - sizeof(*hdr)) / sizeof(*info);
+		struct mtk_wed_wo_log_info *info = (void *)skb->data;
+		u32 count = skb->len / sizeof(*info);
 		int i;
 
-		info = (struct mtk_wed_wo_log_info *)(skb->data + sizeof(*hdr));
 		for (i = 0 ; i < count ; i++)
 			dev_notice(wo->hw->dev,
 				   "SN:%u latency: total=%u, rro:%u, mod:%u\n",
@@ -88,6 +102,7 @@ void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
 		break;
 	}
 	case MTK_WED_WO_EVT_RXCNT_INFO:
+		mtk_wed_update_rx_stats(wo->hw->wed_dev, skb);
 		break;
 	default:
 		break;
@@ -144,6 +159,8 @@ mtk_wed_mcu_parse_response(struct mtk_wed_wo *wo, struct sk_buff *skb,
 	skb_pull(skb, sizeof(*hdr));
 	switch (cmd) {
 	case MTK_WED_WO_CMD_RXCNT_INFO:
+		mtk_wed_update_rx_stats(wo->hw->wed_dev, skb);
+		break;
 	default:
 		break;
 	}
@@ -182,6 +199,18 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
 	return ret;
 }
 
+int mtk_wed_mcu_msg_update(struct mtk_wed_device *dev, int id, void *data,
+			   int len)
+{
+	struct mtk_wed_wo *wo = dev->hw->wed_wo;
+
+	if (dev->hw->version == 1)
+		return 0;
+
+	return mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO, id, data, len,
+				    true);
+}
+
 static int
 mtk_wed_get_memory_region(struct mtk_wed_wo *wo,
 			  struct mtk_wed_wo_memory_region *region)
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index c940b3bb215b..9e39dace95eb 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -4,6 +4,7 @@
 #ifndef __MTK_WED_REGS_H
 #define __MTK_WED_REGS_H
 
+#define MTK_WFDMA_DESC_CTRL_TO_HOST		BIT(8)
 #define MTK_WDMA_DESC_CTRL_LEN1			GENMASK(14, 0)
 #define MTK_WDMA_DESC_CTRL_LEN1_V2		GENMASK(13, 0)
 #define MTK_WDMA_DESC_CTRL_LAST_SEG1		BIT(15)
@@ -28,6 +29,8 @@ struct mtk_wdma_desc {
 #define MTK_WED_RESET_WED_TX_DMA			BIT(12)
 #define MTK_WED_RESET_WDMA_RX_DRV			BIT(17)
 #define MTK_WED_RESET_WDMA_INT_AGENT			BIT(19)
+#define MTK_WED_RESET_RX_RRO_QM				BIT(20)
+#define MTK_WED_RESET_RX_ROUTE_QM			BIT(21)
 #define MTK_WED_RESET_WED				BIT(31)
 
 #define MTK_WED_CTRL					0x00c
@@ -39,8 +42,12 @@ struct mtk_wdma_desc {
 #define MTK_WED_CTRL_WED_TX_BM_BUSY			BIT(9)
 #define MTK_WED_CTRL_WED_TX_FREE_AGENT_EN		BIT(10)
 #define MTK_WED_CTRL_WED_TX_FREE_AGENT_BUSY		BIT(11)
-#define MTK_WED_CTRL_RESERVE_EN				BIT(12)
-#define MTK_WED_CTRL_RESERVE_BUSY			BIT(13)
+#define MTK_WED_CTRL_WED_RX_BM_EN			BIT(12)
+#define MTK_WED_CTRL_WED_RX_BM_BUSY			BIT(13)
+#define MTK_WED_CTRL_RX_RRO_QM_EN			BIT(14)
+#define MTK_WED_CTRL_RX_RRO_QM_BUSY			BIT(15)
+#define MTK_WED_CTRL_RX_ROUTE_QM_EN			BIT(16)
+#define MTK_WED_CTRL_RX_ROUTE_QM_BUSY			BIT(17)
 #define MTK_WED_CTRL_FINAL_DIDX_READ			BIT(24)
 #define MTK_WED_CTRL_ETH_DMAD_FMT			BIT(25)
 #define MTK_WED_CTRL_MIB_READ_CLEAR			BIT(28)
@@ -62,6 +69,9 @@ struct mtk_wdma_desc {
 #define MTK_WED_EXT_INT_STATUS_TX_DMA_R_RESP_ERR	BIT(22)
 #define MTK_WED_EXT_INT_STATUS_TX_DMA_W_RESP_ERR	BIT(23)
 #define MTK_WED_EXT_INT_STATUS_RX_DRV_DMA_RECYCLE	BIT(24)
+#define MTK_WED_EXT_INT_STATUS_RX_DRV_GET_BM_DMAD_SKIP	BIT(25)
+#define MTK_WED_EXT_INT_STATUS_WPDMA_RX_D_DRV_ERR	BIT(26)
+#define MTK_WED_EXT_INT_STATUS_WPDMA_MID_RDY		BIT(27)
 #define MTK_WED_EXT_INT_STATUS_ERROR_MASK		(MTK_WED_EXT_INT_STATUS_TF_LEN_ERR | \
 							 MTK_WED_EXT_INT_STATUS_TKID_WO_PYLD | \
 							 MTK_WED_EXT_INT_STATUS_TKID_TITO_INVALID | \
@@ -71,6 +81,8 @@ struct mtk_wdma_desc {
 							 MTK_WED_EXT_INT_STATUS_TX_DMA_R_RESP_ERR)
 
 #define MTK_WED_EXT_INT_MASK				0x028
+#define MTK_WED_EXT_INT_MASK1				0x02c
+#define MTK_WED_EXT_INT_MASK2				0x030
 
 #define MTK_WED_STATUS					0x060
 #define MTK_WED_STATUS_TX				GENMASK(15, 8)
@@ -151,6 +163,7 @@ struct mtk_wdma_desc {
 #define MTK_WED_RING_TX(_n)				(0x300 + (_n) * 0x10)
 
 #define MTK_WED_RING_RX(_n)				(0x400 + (_n) * 0x10)
+#define MTK_WED_RING_RX_DATA(_n)			(0x420 + (_n) * 0x10)
 
 #define MTK_WED_SCR0					0x3c0
 #define MTK_WED_WPDMA_INT_TRIGGER			0x504
@@ -213,6 +226,12 @@ struct mtk_wdma_desc {
 #define MTK_WED_WPDMA_INT_CTRL_TX1_DONE_TRIG		GENMASK(14, 10)
 
 #define MTK_WED_WPDMA_INT_CTRL_RX			0x534
+#define MTK_WED_WPDMA_INT_CTRL_RX0_EN			BIT(0)
+#define MTK_WED_WPDMA_INT_CTRL_RX0_CLR			BIT(1)
+#define MTK_WED_WPDMA_INT_CTRL_RX0_DONE_TRIG		GENMASK(6, 2)
+#define MTK_WED_WPDMA_INT_CTRL_RX1_EN			BIT(8)
+#define MTK_WED_WPDMA_INT_CTRL_RX1_CLR			BIT(9)
+#define MTK_WED_WPDMA_INT_CTRL_RX1_DONE_TRIG		GENMASK(14, 10)
 
 #define MTK_WED_WPDMA_INT_CTRL_TX_FREE			0x538
 #define MTK_WED_WPDMA_INT_CTRL_TX_FREE_DONE_EN		BIT(0)
@@ -242,11 +261,34 @@ struct mtk_wdma_desc {
 
 #define MTK_WED_WPDMA_RING_TX(_n)			(0x600 + (_n) * 0x10)
 #define MTK_WED_WPDMA_RING_RX(_n)			(0x700 + (_n) * 0x10)
+#define MTK_WED_WPDMA_RING_RX_DATA(_n)			(0x730 + (_n) * 0x10)
+
+#define MTK_WED_WPDMA_RX_D_GLO_CFG			0x75c
+#define MTK_WED_WPDMA_RX_D_RX_DRV_EN			BIT(0)
+#define MTK_WED_WPDMA_RX_D_INIT_PHASE_RXEN_SEL		GENMASK(11, 7)
+#define MTK_WED_WPDMA_RX_D_RXD_READ_LEN			GENMASK(31, 24)
+
+#define MTK_WED_WPDMA_RX_D_RST_IDX			0x760
+#define MTK_WED_WPDMA_RX_D_RST_CRX_IDX			GENMASK(17, 16)
+#define MTK_WED_WPDMA_RX_D_RST_DRV_IDX			GENMASK(25, 24)
+
+#define MTK_WED_WPDMA_RX_GLO_CFG			0x76c
+#define MTK_WED_WPDMA_RX_RING				0x770
+
+#define MTK_WED_WPDMA_RX_D_MIB(_n)			(0x774 + (_n) * 4)
+#define MTK_WED_WPDMA_RX_D_PROCESSED_MIB(_n)		(0x784 + (_n) * 4)
+#define MTK_WED_WPDMA_RX_D_COHERENT_MIB			0x78c
+
+#define MTK_WED_WDMA_RING_TX				0x800
+
+#define MTK_WED_WDMA_TX_MIB				0x810
+
 #define MTK_WED_WDMA_RING_RX(_n)			(0x900 + (_n) * 0x10)
 #define MTK_WED_WDMA_RX_THRES(_n)			(0x940 + (_n) * 0x4)
 
 #define MTK_WED_WDMA_GLO_CFG				0xa04
 #define MTK_WED_WDMA_GLO_CFG_TX_DRV_EN			BIT(0)
+#define MTK_WED_WDMA_GLO_CFG_TX_DDONE_CHK		BIT(1)
 #define MTK_WED_WDMA_GLO_CFG_RX_DRV_EN			BIT(2)
 #define MTK_WED_WDMA_GLO_CFG_RX_DRV_BUSY		BIT(3)
 #define MTK_WED_WDMA_GLO_CFG_BT_SIZE			GENMASK(5, 4)
@@ -291,6 +333,20 @@ struct mtk_wdma_desc {
 #define MTK_WED_WDMA_RX_RECYCLE_MIB(_n)			(0xae8 + (_n) * 4)
 #define MTK_WED_WDMA_RX_PROCESSED_MIB(_n)		(0xaf0 + (_n) * 4)
 
+#define MTK_WED_RX_BM_RX_DMAD				0xd80
+#define MTK_WED_RX_BM_RX_DMAD_SDL0			GENMASK(13, 0)
+
+#define MTK_WED_RX_BM_BASE				0xd84
+#define MTK_WED_RX_BM_INIT_PTR				0xd88
+#define MTK_WED_RX_BM_SW_TAIL				GENMASK(15, 0)
+#define MTK_WED_RX_BM_INIT_SW_TAIL			BIT(16)
+
+#define MTK_WED_RX_PTR					0xd8c
+
+#define MTK_WED_RX_BM_DYN_ALLOC_TH			0xdb4
+#define MTK_WED_RX_BM_DYN_ALLOC_TH_H			GENMASK(31, 16)
+#define MTK_WED_RX_BM_DYN_ALLOC_TH_L			GENMASK(15, 0)
+
 #define MTK_WED_RING_OFS_BASE				0x00
 #define MTK_WED_RING_OFS_COUNT				0x04
 #define MTK_WED_RING_OFS_CPU_IDX			0x08
@@ -301,7 +357,9 @@ struct mtk_wdma_desc {
 
 #define MTK_WDMA_GLO_CFG				0x204
 #define MTK_WDMA_GLO_CFG_TX_DMA_EN			BIT(0)
+#define MTK_WDMA_GLO_CFG_TX_DMA_BUSY			BIT(1)
 #define MTK_WDMA_GLO_CFG_RX_DMA_EN			BIT(2)
+#define MTK_WDMA_GLO_CFG_RX_DMA_BUSY			BIT(3)
 #define MTK_WDMA_GLO_CFG_RX_INFO3_PRERES		BIT(26)
 #define MTK_WDMA_GLO_CFG_RX_INFO2_PRERES		BIT(27)
 #define MTK_WDMA_GLO_CFG_RX_INFO1_PRERES		BIT(28)
@@ -330,4 +388,70 @@ struct mtk_wdma_desc {
 /* DMA channel mapping */
 #define HIFSYS_DMA_AG_MAP				0x008
 
+#define MTK_WED_RTQM_GLO_CFG				0xb00
+#define MTK_WED_RTQM_BUSY				BIT(1)
+#define MTK_WED_RTQM_Q_RST				BIT(2)
+#define MTK_WED_RTQM_Q_DBG_BYPASS			BIT(5)
+#define MTK_WED_RTQM_TXDMAD_FPORT			GENMASK(23, 20)
+
+#define MTK_WED_RTQM_R2H_MIB(_n)			(0xb70 + (_n) * 0x4)
+#define MTK_WED_RTQM_R2Q_MIB(_n)			(0xb78 + (_n) * 0x4)
+#define MTK_WED_RTQM_Q2N_MIB				0xb80
+#define MTK_WED_RTQM_Q2H_MIB(_n)			(0xb84 + (_n) * 0x4)
+
+#define MTK_WED_RTQM_Q2B_MIB				0xb8c
+#define MTK_WED_RTQM_PFDBK_MIB				0xb90
+
+#define MTK_WED_RROQM_GLO_CFG				0xc04
+#define MTK_WED_RROQM_RST_IDX				0xc08
+#define MTK_WED_RROQM_RST_IDX_MIOD			BIT(0)
+#define MTK_WED_RROQM_RST_IDX_FDBK			BIT(4)
+
+#define MTK_WED_RROQM_MIOD_CTRL0			0xc40
+#define MTK_WED_RROQM_MIOD_CTRL1			0xc44
+#define MTK_WED_RROQM_MIOD_CNT				GENMASK(11, 0)
+
+#define MTK_WED_RROQM_MIOD_CTRL2			0xc48
+#define MTK_WED_RROQM_MIOD_CTRL3			0xc4c
+
+#define MTK_WED_RROQM_FDBK_CTRL0			0xc50
+#define MTK_WED_RROQM_FDBK_CTRL1			0xc54
+#define MTK_WED_RROQM_FDBK_CNT				GENMASK(11, 0)
+
+#define MTK_WED_RROQM_FDBK_CTRL2			0xc58
+
+#define MTK_WED_RROQ_BASE_L				0xc80
+#define MTK_WED_RROQ_BASE_H				0xc84
+
+#define MTK_WED_RROQM_MIOD_CFG				0xc8c
+#define MTK_WED_RROQM_MIOD_MID_DW			GENMASK(5, 0)
+#define MTK_WED_RROQM_MIOD_MOD_DW			GENMASK(13, 8)
+#define MTK_WED_RROQM_MIOD_ENTRY_DW			GENMASK(22, 16)
+
+#define MTK_WED_RROQM_MID_MIB				0xcc0
+#define MTK_WED_RROQM_MOD_MIB				0xcc4
+#define MTK_WED_RROQM_MOD_COHERENT_MIB			0xcc8
+#define MTK_WED_RROQM_FDBK_MIB				0xcd0
+#define MTK_WED_RROQM_FDBK_COHERENT_MIB			0xcd4
+#define MTK_WED_RROQM_FDBK_IND_MIB			0xce0
+#define MTK_WED_RROQM_FDBK_ENQ_MIB			0xce4
+#define MTK_WED_RROQM_FDBK_ANC_MIB			0xce8
+#define MTK_WED_RROQM_FDBK_ANC2H_MIB			0xcec
+
+#define MTK_WED_RX_BM_RX_DMAD				0xd80
+#define MTK_WED_RX_BM_BASE				0xd84
+#define MTK_WED_RX_BM_INIT_PTR				0xd88
+#define MTK_WED_RX_BM_PTR				0xd8c
+#define MTK_WED_RX_BM_PTR_HEAD				GENMASK(32, 16)
+#define MTK_WED_RX_BM_PTR_TAIL				GENMASK(15, 0)
+
+#define MTK_WED_RX_BM_BLEN				0xd90
+#define MTK_WED_RX_BM_STS				0xd94
+#define MTK_WED_RX_BM_INTF2				0xd98
+#define MTK_WED_RX_BM_INTF				0xd9c
+#define MTK_WED_RX_BM_ERR_STS				0xda8
+
+#define MTK_WED_WOCPU_VIEW_MIOD_BASE			0x8000
+#define MTK_WED_PCIE_INT_MASK				0x0
+
 #endif
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
index 18c0ffcd8176..b998d03580d5 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
@@ -49,6 +49,10 @@ enum {
 	MTK_WED_WARP_CMD_FLAG_FROM_TO_WO	= BIT(2),
 };
 
+#define MTK_WED_WO_CPU_MCUSYS_RESET_ADDR	0x15194050
+#define MTK_WED_WO_CPU_WO0_MCUSYS_RESET_MASK	0x20
+#define MTK_WED_WO_CPU_WO1_MCUSYS_RESET_MASK	0x1
+
 enum {
 	MTK_WED_WO_REGION_EMI,
 	MTK_WED_WO_REGION_ILM,
@@ -56,6 +60,28 @@ enum {
 	__MTK_WED_WO_REGION_MAX,
 };
 
+enum mtk_wed_wo_state {
+	MTK_WED_WO_STATE_UNDEFINED,
+	MTK_WED_WO_STATE_INIT,
+	MTK_WED_WO_STATE_ENABLE,
+	MTK_WED_WO_STATE_DISABLE,
+	MTK_WED_WO_STATE_HALT,
+	MTK_WED_WO_STATE_GATING,
+	MTK_WED_WO_STATE_SER_RESET,
+	MTK_WED_WO_STATE_WF_RESET,
+};
+
+enum mtk_wed_wo_done_state {
+	MTK_WED_WOIF_UNDEFINED,
+	MTK_WED_WOIF_DISABLE_DONE,
+	MTK_WED_WOIF_TRIGGER_ENABLE,
+	MTK_WED_WOIF_ENABLE_DONE,
+	MTK_WED_WOIF_TRIGGER_GATING,
+	MTK_WED_WOIF_GATING_DONE,
+	MTK_WED_WOIF_TRIGGER_HALT,
+	MTK_WED_WOIF_HALT_DONE,
+};
+
 enum mtk_wed_dummy_cr_idx {
 	MTK_WED_DUMMY_CR_FWDL,
 	MTK_WED_DUMMY_CR_WO_STATUS,
@@ -250,6 +276,8 @@ void mtk_wed_mcu_rx_unsolicited_event(struct mtk_wed_wo *wo,
 				      struct sk_buff *skb);
 int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
 			 const void *data, int len, bool wait_resp);
+int mtk_wed_mcu_msg_update(struct mtk_wed_device *dev, int id, void *data,
+			   int len);
 int mtk_wed_mcu_init(struct mtk_wed_wo *wo);
 int mtk_wed_wo_init(struct mtk_wed_hw *hw);
 void mtk_wed_wo_deinit(struct mtk_wed_hw *hw);
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 2cc2f1e43ba9..8ac6ea13ed7f 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -5,8 +5,12 @@
 #include <linux/rcupdate.h>
 #include <linux/regmap.h>
 #include <linux/pci.h>
+#include <linux/skbuff.h>
 
 #define MTK_WED_TX_QUEUES		2
+#define MTK_WED_RX_QUEUES		2
+
+#define WED_WO_STA_REC			0x6
 
 struct mtk_wed_hw;
 struct mtk_wdma_desc;
@@ -40,6 +44,11 @@ enum mtk_wed_wo_cmd {
 	MTK_WED_WO_CMD_WED_END
 };
 
+struct mtk_rxbm_desc {
+	__le32 buf0;
+	__le32 token;
+} __packed __aligned(4);
+
 enum mtk_wed_bus_tye {
 	MTK_WED_BUS_PCIE,
 	MTK_WED_BUS_AXI,
@@ -55,6 +64,15 @@ struct mtk_wed_ring {
 	void __iomem *wpdma;
 };
 
+struct mtk_wed_wo_rx_stats {
+	__le16 wlan_idx;
+	__le16 tid;
+	__le32 rx_pkt_cnt;
+	__le32 rx_byte_cnt;
+	__le32 rx_err_cnt;
+	__le32 rx_drop_cnt;
+};
+
 struct mtk_wed_device {
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
 	const struct mtk_wed_ops *ops;
@@ -63,17 +81,33 @@ struct mtk_wed_device {
 	bool init_done, running;
 	int wdma_idx;
 	int irq;
+	u8 version;
 
 	struct mtk_wed_ring tx_ring[MTK_WED_TX_QUEUES];
+	struct mtk_wed_ring rx_ring[MTK_WED_RX_QUEUES];
 	struct mtk_wed_ring txfree_ring;
 	struct mtk_wed_ring tx_wdma[MTK_WED_TX_QUEUES];
+	struct mtk_wed_ring rx_wdma[MTK_WED_RX_QUEUES];
 
 	struct {
 		int size;
 		void **pages;
 		struct mtk_wdma_desc *desc;
 		dma_addr_t desc_phys;
-	} buf_ring;
+	} tx_buf_ring;
+
+	struct {
+		int size;
+		struct page_frag_cache rx_page;
+		struct mtk_rxbm_desc *desc;
+		dma_addr_t desc_phys;
+	} rx_buf_ring;
+
+	struct {
+		struct mtk_wed_ring ring;
+		dma_addr_t miod_phys;
+		dma_addr_t fdbk_phys;
+	} rro;
 
 	/* filled by driver: */
 	struct {
@@ -82,22 +116,36 @@ struct mtk_wed_device {
 			struct pci_dev *pci_dev;
 		};
 		enum mtk_wed_bus_tye bus_type;
+		void __iomem *base;
+		u32 phy_base;
 
 		u32 wpdma_phys;
 		u32 wpdma_int;
 		u32 wpdma_mask;
 		u32 wpdma_tx;
 		u32 wpdma_txfree;
+		u32 wpdma_rx_glo;
+		u32 wpdma_rx;
+
+		bool wcid_512;
 
 		u16 token_start;
 		unsigned int nbuf;
+		unsigned int rx_nbuf;
+		unsigned int rx_npkt;
+		unsigned int rx_size;
 
 		u8 tx_tbit[MTK_WED_TX_QUEUES];
+		u8 rx_tbit[MTK_WED_RX_QUEUES];
 		u8 txfree_tbit;
 
 		u32 (*init_buf)(void *ptr, dma_addr_t phys, int token_id);
 		int (*offload_enable)(struct mtk_wed_device *wed);
 		void (*offload_disable)(struct mtk_wed_device *wed);
+		u32 (*init_rx_buf)(struct mtk_wed_device *wed, int size);
+		void (*release_rx_buf)(struct mtk_wed_device *wed);
+		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
+					   struct mtk_wed_wo_rx_stats *stats);
 	} wlan;
 #endif
 };
@@ -106,9 +154,15 @@ struct mtk_wed_ops {
 	int (*attach)(struct mtk_wed_device *dev);
 	int (*tx_ring_setup)(struct mtk_wed_device *dev, int ring,
 			     void __iomem *regs);
+	int (*rx_ring_setup)(struct mtk_wed_device *dev, int ring,
+			     void __iomem *regs);
 	int (*txfree_ring_setup)(struct mtk_wed_device *dev,
 				 void __iomem *regs);
+	int (*msg_update)(struct mtk_wed_device *dev, int cmd_id,
+			  void *data, int len);
 	void (*detach)(struct mtk_wed_device *dev);
+	void (*ppe_check)(struct mtk_wed_device *dev, struct sk_buff *skb,
+			  u32 reason, u32 hash);
 
 	void (*stop)(struct mtk_wed_device *dev);
 	void (*start)(struct mtk_wed_device *dev, u32 irq_mask);
@@ -143,6 +197,16 @@ mtk_wed_device_attach(struct mtk_wed_device *dev)
 	return ret;
 }
 
+static inline bool
+mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
+{
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+	return dev->version != 1;
+#else
+	return false;
+#endif
+}
+
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
 #define mtk_wed_device_active(_dev) !!(_dev)->ops
 #define mtk_wed_device_detach(_dev) (_dev)->ops->detach(_dev)
@@ -159,6 +223,12 @@ mtk_wed_device_attach(struct mtk_wed_device *dev)
 	(_dev)->ops->irq_get(_dev, _mask)
 #define mtk_wed_device_irq_set_mask(_dev, _mask) \
 	(_dev)->ops->irq_set_mask(_dev, _mask)
+#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) \
+	(_dev)->ops->rx_ring_setup(_dev, _ring, _regs)
+#define mtk_wed_device_ppe_check(_dev, _skb, _reason, _hash) \
+	(_dev)->ops->ppe_check(_dev, _skb, _reason, _hash)
+#define mtk_wed_device_update_msg(_dev, _id, _msg, _len) \
+	(_dev)->ops->msg_update(_dev, _id, _msg, _len)
 #else
 static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 {
@@ -172,6 +242,9 @@ static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 #define mtk_wed_device_reg_write(_dev, _reg, _val) do {} while (0)
 #define mtk_wed_device_irq_get(_dev, _mask) 0
 #define mtk_wed_device_irq_set_mask(_dev, _mask) do {} while (0)
+#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) -ENODEV
+#define mtk_wed_device_ppe_check(_dev, _hash)  do {} while (0)
+#define mtk_wed_device_update_msg(_dev, _id, _msg, _len) -ENODEV
 #endif
 
 #endif
-- 
2.37.3

