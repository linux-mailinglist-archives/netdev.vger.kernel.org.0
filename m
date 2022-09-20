Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D455BE2C6
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiITKMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiITKMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:12:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A885580;
        Tue, 20 Sep 2022 03:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C40D061E94;
        Tue, 20 Sep 2022 10:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D03C433D7;
        Tue, 20 Sep 2022 10:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663668752;
        bh=R2AYcF/nU5TD6bf+bx9mVNCUa0KQ9vMUt5I61crKGkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njueBl2VLaZYqGFhWJdIr30qb73Vsni6CUkhWWOFymRlNsxm4y1Nv8YMySEbp1XHd
         XIjBwibBXYvO3ISdPjBCruaGy29E1cQ0koYwAYNo9ZXGDVgAp4mRbODPCXZJnA+lFd
         MO4qvmzBsAV9v/lFLzsmpVR8RoUsGXcBXkeSy9a+TE5xZOAylBLiI0bwTMu7r13TTM
         A54i5w2TmaWBD24dmG/u6GU6Pg6cgx1/fIH7VsdeLSwm+9eU2Zp7xvVqWOBTspEbWN
         QgXCBXR6GLgi6ShLmsKV0Wl9uzO21Q+z5GykAWUULhcraTiZfwSP3IWXSHUA+hX2Rv
         dxOZvH6Ir8Rxg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v3 net-next 10/11] net: ethernet: mtk_eth_wed: add axi bus support
Date:   Tue, 20 Sep 2022 12:11:22 +0200
Message-Id: <989299df16d1bf37689ae95843f8ca23c1041ef2.1663668204.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663668203.git.lorenzo@kernel.org>
References: <cover.1663668203.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other than pcie bus, introduce support for axi bus to mtk wed driver.
Axi bus is used to connect mt7986-wmac soc chip available on mt7986
device.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 104 +++++++++++++------
 drivers/net/ethernet/mediatek/mtk_wed_regs.h |   2 +
 include/linux/soc/mediatek/mtk_wed.h         |  11 +-
 3 files changed, 85 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index e261858a5647..099b6e0df619 100644
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
 
-	hw = hw_list[pci_domain_nr(dev->wlan.pci_dev->bus)];
-	if (!hw || hw->wed_dev)
-		return NULL;
+		if (!hw->wed_dev)
+			goto out;
 
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
+
+	return NULL;
+
+out:
 	hw->wed_dev = dev;
 	return hw;
 }
@@ -322,7 +342,6 @@ mtk_wed_stop(struct mtk_wed_device *dev)
 static void
 mtk_wed_detach(struct mtk_wed_device *dev)
 {
-	struct device_node *wlan_node = dev->wlan.pci_dev->dev.of_node;
 	struct mtk_wed_hw *hw = dev->hw;
 
 	mutex_lock(&hw_lock);
@@ -337,9 +356,14 @@ mtk_wed_detach(struct mtk_wed_device *dev)
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
@@ -356,33 +380,47 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 static void
 mtk_wed_bus_init(struct mtk_wed_device *dev)
 {
-	struct device_node *np = dev->hw->eth->dev->of_node;
-	struct regmap *regs;
-
-	regs = syscon_regmap_lookup_by_phandle(np, "mediatek,wed-pcie");
-	if (IS_ERR(regs))
-		return;
+	switch (dev->wlan.bus_type) {
+	case MTK_WED_BUS_PCIE: {
+		struct device_node *np = dev->hw->eth->dev->of_node;
+		struct regmap *regs;
+
+		regs = syscon_regmap_lookup_by_phandle(np,
+						       "mediatek,wed-pcie");
+		if (IS_ERR(regs))
+			break;
 
-	regmap_update_bits(regs, 0, BIT(0), BIT(0));
+		regmap_update_bits(regs, 0, BIT(0), BIT(0));
 
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
 
-	wed_w32(dev, MTK_WED_PCIE_CFG_INTM, PCIE_BASE_ADDR0 | 0x180);
-	wed_w32(dev, MTK_WED_PCIE_CFG_BASE, PCIE_BASE_ADDR0 | 0x184);
+		wed_w32(dev, MTK_WED_PCIE_CFG_INTM, PCIE_BASE_ADDR0 | 0x180);
+		wed_w32(dev, MTK_WED_PCIE_CFG_BASE, PCIE_BASE_ADDR0 | 0x184);
 
-	/* pcie interrupt status trigger register */
-	wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER, BIT(24));
-	wed_r32(dev, MTK_WED_PCIE_INT_TRIGGER);
+		/* pcie interrupt status trigger register */
+		wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER, BIT(24));
+		wed_r32(dev, MTK_WED_PCIE_INT_TRIGGER);
 
-	/* pola setting */
-	wed_set(dev, MTK_WED_PCIE_INT_CTRL, MTK_WED_PCIE_INT_CTRL_MSK_EN_POLA);
+		/* pola setting */
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
@@ -793,12 +831,14 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	__releases(RCU)
 {
 	struct mtk_wed_hw *hw;
+	struct device *device;
 	int ret = 0;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
 			 "mtk_wed_attach without holding the RCU read lock");
 
-	if (pci_domain_nr(dev->wlan.pci_dev->bus) > 1 ||
+	if ((dev->wlan.bus_type == MTK_WED_BUS_PCIE &&
+	     pci_domain_nr(dev->wlan.pci_dev->bus) > 1) ||
 	    !try_module_get(THIS_MODULE))
 		ret = -ENODEV;
 
@@ -816,8 +856,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 		goto out;
 	}
 
-	dev_info(&dev->wlan.pci_dev->dev,
-		 "attaching wed device %d version %d\n",
+	device = dev->wlan.bus_type == MTK_WED_BUS_PCIE
+		? &dev->wlan.pci_dev->dev
+		: &dev->wlan.platform_dev->dev;
+	dev_info(device, "attaching wed device %d version %d\n",
 		 hw->index, hw->version);
 
 	dev->hw = hw;
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index 5dd78e3e3f14..e270fb336143 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -198,6 +198,8 @@ struct mtk_wdma_desc {
 
 #define MTK_WED_WPDMA_INT_CTRL				0x520
 #define MTK_WED_WPDMA_INT_CTRL_SUBRT_ADV		BIT(21)
+#define MTK_WED_WPDMA_INT_CTRL_SIG_SRC			BIT(22)
+#define MTK_WED_WPDMA_INT_CTRL_SRC_SEL			GENMASK(17, 16)
 
 #define MTK_WED_WPDMA_INT_MASK				0x524
 
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 592221a7149b..4450c8b7a1cb 100644
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
@@ -43,7 +48,11 @@ struct mtk_wed_device {
 
 	/* filled by driver: */
 	struct {
-		struct pci_dev *pci_dev;
+		union {
+			struct platform_device *platform_dev;
+			struct pci_dev *pci_dev;
+		};
+		enum mtk_wed_bus_tye bus_type;
 
 		u32 wpdma_phys;
 		u32 wpdma_int;
-- 
2.37.3

