Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3315B26E3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiIHTgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiIHTfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AE2B3B03;
        Thu,  8 Sep 2022 12:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6487B8223E;
        Thu,  8 Sep 2022 19:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FC0C43140;
        Thu,  8 Sep 2022 19:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665744;
        bh=+p1Jq55Ye3mbrWOIaQolx7j7TEqwSNIGToayfN0ifMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5ImYnGwwbXMqENVbYphstevlvt4O2CahS8loj4Q1uQHX9H+AEsm/j88iSr+LebK6
         5VQZ9qXDJaBPKgtgkWIi2DnKp+kShX6JNBHqkBfOZKNbuP86OAOKPewCg7/hvW+m32
         p/Osbjdhwgcql7WqXCP5cqpFFtOd2i8v/aK42D33s9FNu+X6SfLsgYMSLkooE47ELC
         nBkvjGYxbjAUkcM9aPE/ThdkUHT5nqPAqBisuYTVCVyvzF7/rMwvXHnkh9PiQTMLUy
         /XseBdznhW4Fv2mxjELtHOkOouhx324sGNYFVxHtvgHypVEmMOSafdW8uNEZqbs6Oz
         yA/rpICiCqY6w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 11/12] net: ethernet: mtk_eth_wed: add axi bus support
Date:   Thu,  8 Sep 2022 21:33:45 +0200
Message-Id: <09011397a0f4d6ba017abc0dc396e8be990e72aa.1662661555.git.lorenzo@kernel.org>
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

Other than pcie bus, introduce support for axi bus to mtk wed driver.
Axi bus is used to connect mt7986-wmac soc chip available on mt7986
device.

Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 112 +++++++++++++------
 drivers/net/ethernet/mediatek/mtk_wed_regs.h |   2 +
 include/linux/soc/mediatek/mtk_wed.h         |   7 ++
 3 files changed, 84 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 3ec891f05fa7..48c638c49355 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -85,11 +85,31 @@ static struct mtk_wed_hw *
 mtk_wed_assign(struct mtk_wed_device *dev)
 {
 	struct mtk_wed_hw *hw;
+	int i;
+
+	if (dev->wlan.bus_type == MTK_WED_BUS_PCIE) {
+		hw = hw_list[pci_domain_nr(dev->wlan.pci_dev->bus)];
+		if (!hw)
+			return NULL;
+
+		if (!hw->wed_dev)
+			goto out;
+
+		if (hw->version == 1)
+			return NULL;
+
+		/* MT7986 WED devices do not have any pcie slot restrictions */
+	}
+	/* MT7986 PCIE or AXI */
+	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
+		hw = hw_list[i];
+		if (hw && !hw->wed_dev)
+			goto out;
+	}
 
-	hw = hw_list[pci_domain_nr(dev->wlan.pci_dev->bus)];
-	if (!hw || hw->wed_dev)
-		return NULL;
+	return NULL;
 
+out:
 	hw->wed_dev = dev;
 	return hw;
 }
@@ -321,7 +341,6 @@ mtk_wed_stop(struct mtk_wed_device *dev)
 static void
 mtk_wed_detach(struct mtk_wed_device *dev)
 {
-	struct device_node *wlan_node = dev->wlan.pci_dev->dev.of_node;
 	struct mtk_wed_hw *hw = dev->hw;
 
 	mutex_lock(&hw_lock);
@@ -336,9 +355,14 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 	mtk_wed_free_buffer(dev);
 	mtk_wed_free_tx_rings(dev);
 
-	if (of_dma_is_coherent(wlan_node) && hw->hifsys)
-		regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP,
-				   BIT(hw->index), BIT(hw->index));
+	if (dev->wlan.bus_type == MTK_WED_BUS_PCIE) {
+		struct device_node *wlan_node;
+
+		wlan_node = dev->wlan.pci_dev->dev.of_node;
+		if (of_dma_is_coherent(wlan_node) && hw->hifsys)
+			regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP,
+					   BIT(hw->index), BIT(hw->index));
+	}
 
 	if (!hw_list[!hw->index]->wed_dev &&
 	    hw->eth->dma_dev != hw->eth->dev)
@@ -355,42 +379,55 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 static void
 mtk_wed_bus_init(struct mtk_wed_device *dev)
 {
-	struct device_node *node;
-	void __iomem *base_addr;
-	u32 val;
-
-	node = of_parse_phandle(dev->hw->node, "mediatek,wed_pcie", 0);
-	if (!node)
-		return;
+	switch (dev->wlan.bus_type) {
+	case MTK_WED_BUS_PCIE: {
+		struct device_node *node;
+		void __iomem *base_addr;
+		u32 val;
+
+		node = of_parse_phandle(dev->hw->node, "mediatek,wed_pcie", 0);
+		if (!node)
+			break;
 
-	base_addr = of_iomap(node, 0);
-	val = BIT(0) | readl(base_addr);
-	writel(val, base_addr);
+		base_addr = of_iomap(node, 0);
+		val = BIT(0) | readl(base_addr);
+		writel(val, base_addr);
 
-	wed_w32(dev, MTK_WED_PCIE_INT_CTRL,
-		FIELD_PREP(MTK_WED_PCIE_INT_CTRL_POLL_EN, 2));
+		wed_w32(dev, MTK_WED_PCIE_INT_CTRL,
+			FIELD_PREP(MTK_WED_PCIE_INT_CTRL_POLL_EN, 2));
 
-	/* pcie interrupt control: pola/source selection */
-	wed_set(dev, MTK_WED_PCIE_INT_CTRL,
-		MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA |
-		FIELD_PREP(MTK_WED_PCIE_INT_CTRL_SRC_SEL, 1));
-	wed_r32(dev, MTK_WED_PCIE_INT_CTRL);
+		/* pcie interrupt control: pola/source selection */
+		wed_set(dev, MTK_WED_PCIE_INT_CTRL,
+			MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA |
+			FIELD_PREP(MTK_WED_PCIE_INT_CTRL_SRC_SEL, 1));
+		wed_r32(dev, MTK_WED_PCIE_INT_CTRL);
 
-	val = wed_r32(dev, MTK_WED_PCIE_CFG_INTM);
-	val = wed_r32(dev, MTK_WED_PCIE_CFG_BASE);
-	wed_w32(dev, MTK_WED_PCIE_CFG_INTM, PCIE_BASE_ADDR0 | 0x180);
-	wed_w32(dev, MTK_WED_PCIE_CFG_BASE, PCIE_BASE_ADDR0 | 0x184);
+		val = wed_r32(dev, MTK_WED_PCIE_CFG_INTM);
+		val = wed_r32(dev, MTK_WED_PCIE_CFG_BASE);
+		wed_w32(dev, MTK_WED_PCIE_CFG_INTM, PCIE_BASE_ADDR0 | 0x180);
+		wed_w32(dev, MTK_WED_PCIE_CFG_BASE, PCIE_BASE_ADDR0 | 0x184);
 
-	val = wed_r32(dev, MTK_WED_PCIE_CFG_INTM);
-	val = wed_r32(dev, MTK_WED_PCIE_CFG_BASE);
+		val = wed_r32(dev, MTK_WED_PCIE_CFG_INTM);
+		val = wed_r32(dev, MTK_WED_PCIE_CFG_BASE);
 
-	/* pcie interrupt status trigger register */
-	wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER, BIT(24));
-	wed_r32(dev, MTK_WED_PCIE_INT_TRIGGER);
+		/* pcie interrupt status trigger register */
+		wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER, BIT(24));
+		wed_r32(dev, MTK_WED_PCIE_INT_TRIGGER);
 
-	/* pola setting */
-	val = wed_r32(dev, MTK_WED_PCIE_INT_CTRL);
-	wed_set(dev, MTK_WED_PCIE_INT_CTRL, MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA);
+		/* pola setting */
+		val = wed_r32(dev, MTK_WED_PCIE_INT_CTRL);
+		wed_set(dev, MTK_WED_PCIE_INT_CTRL,
+			MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA);
+		break;
+	}
+	case MTK_WED_BUS_AXI:
+		wed_set(dev, MTK_WED_WPDMA_INT_CTRL,
+			MTK_WED_WPDMA_INT_CTRL_SIG_SRC |
+			FIELD_PREP(MTK_WED_WPDMA_INT_CTRL_SRC_SEL, 0));
+		break;
+	default:
+		break;
+	}
 }
 
 static void
@@ -800,7 +837,8 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
 			 "mtk_wed_attach without holding the RCU read lock");
 
-	if (pci_domain_nr(dev->wlan.pci_dev->bus) > 1 ||
+	if ((dev->wlan.bus_type == MTK_WED_BUS_PCIE &&
+	     pci_domain_nr(dev->wlan.pci_dev->bus) > 1) ||
 	    !try_module_get(THIS_MODULE))
 		ret = -ENODEV;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index ecd925fbd451..1e2aafc10f4c 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -194,6 +194,8 @@ struct mtk_wdma_desc {
 
 #define MTK_WED_WPDMA_INT_CTRL				0x520
 #define MTK_WED_WPDMA_INT_CTRL_SUBRT_ADV		BIT(21)
+#define MTK_WED_WPDMA_INT_CTRL_SIG_SRC			BIT(22)
+#define MTK_WED_WPDMA_INT_CTRL_SRC_SEL			GENMASK(17, 16)
 
 #define MTK_WED_WPDMA_INT_MASK				0x524
 
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 592221a7149b..f2ae5bd140a1 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -11,6 +11,11 @@
 struct mtk_wed_hw;
 struct mtk_wdma_desc;
 
+enum mtk_wed_bus_tye {
+	MTK_WED_BUS_PCIE,
+	MTK_WED_BUS_AXI,
+};
+
 struct mtk_wed_ring {
 	struct mtk_wdma_desc *desc;
 	dma_addr_t desc_phys;
@@ -45,6 +50,8 @@ struct mtk_wed_device {
 	struct {
 		struct pci_dev *pci_dev;
 
+		enum mtk_wed_bus_tye bus_type;
+
 		u32 wpdma_phys;
 		u32 wpdma_int;
 		u32 wpdma_mask;
-- 
2.37.3

