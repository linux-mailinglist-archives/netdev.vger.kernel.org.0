Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D35B790C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiIMSBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiIMSAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:00:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E678AB42C;
        Tue, 13 Sep 2022 10:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A05F9B81034;
        Tue, 13 Sep 2022 17:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AB8C433D6;
        Tue, 13 Sep 2022 17:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663088531;
        bh=qkxhtcvBAO1XclLBNizkRDUrtA1+szeD4zqXFcHQDvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGDuRZI5rk5I4MkZtPZiXUWREiFT/580D5XeiIKDOslimvUqHB+qyXoElVet0dGVh
         M7LnOpKPuMQo60JrnEyf9Vip55we3ESG2F2NFA1p4X68KBVEIE+EiCvRIfBjrOgcue
         A5JuuFqWWIGLvGaE48i1pLQStbs2LPJS4C7VGksHeeGvfZ/YsTwesnnH1jP1evsAXw
         AP51EH+Zco7dBsyLGSC+lmPNDNYPfy2nTardwlBp1332bv4JQSpekY/thJ4lhAw3zH
         Nb/noxVwFl0yyeQN9fA6pa+XOqCqKcxxYQsfZAubif4wJuo+sB/s/Jnznp+n5ABNeV
         GIXT74MB1uQ0A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 08/11] net: ethernet: mtk_eth_wed: add mtk_wed_configure_irq and mtk_wed_dma_{enable/disable}
Date:   Tue, 13 Sep 2022 19:00:58 +0200
Message-Id: <0256b773ebf332f2daf15f2debad8721bfa8008e.1663087836.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663087836.git.lorenzo@kernel.org>
References: <cover.1663087836.git.lorenzo@kernel.org>
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

Introduce mtk_wed_configure_irq, mtk_wed_dma_enable and mtk_wed_dma_disable
utility routines.
This is a preliminary patch to introduce mt7986 wed support.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 87 +++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_wed_regs.h |  6 +-
 2 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 29be2fcafea3..d1ef5b563ddf 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -237,9 +237,30 @@ mtk_wed_set_ext_int(struct mtk_wed_device *dev, bool en)
 }
 
 static void
-mtk_wed_stop(struct mtk_wed_device *dev)
+mtk_wed_dma_disable(struct mtk_wed_device *dev)
 {
+	wed_clr(dev, MTK_WED_WPDMA_GLO_CFG,
+		MTK_WED_WPDMA_GLO_CFG_TX_DRV_EN |
+		MTK_WED_WPDMA_GLO_CFG_RX_DRV_EN);
+
+	wed_clr(dev, MTK_WED_WDMA_GLO_CFG, MTK_WED_WDMA_GLO_CFG_RX_DRV_EN);
+
+	wed_clr(dev, MTK_WED_GLO_CFG,
+		MTK_WED_GLO_CFG_TX_DMA_EN |
+		MTK_WED_GLO_CFG_RX_DMA_EN);
+
 	regmap_write(dev->hw->mirror, dev->hw->index * 4, 0);
+	wdma_m32(dev, MTK_WDMA_GLO_CFG,
+		 MTK_WDMA_GLO_CFG_TX_DMA_EN |
+		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
+		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
+		 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES, 0);
+}
+
+static void
+mtk_wed_stop(struct mtk_wed_device *dev)
+{
+	mtk_wed_dma_disable(dev);
 	mtk_wed_set_ext_int(dev, false);
 
 	wed_clr(dev, MTK_WED_CTRL,
@@ -252,15 +273,6 @@ mtk_wed_stop(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_INT_MASK, 0);
 	wdma_w32(dev, MTK_WDMA_INT_GRP2, 0);
 	wed_w32(dev, MTK_WED_WPDMA_INT_MASK, 0);
-
-	wed_clr(dev, MTK_WED_GLO_CFG,
-		MTK_WED_GLO_CFG_TX_DMA_EN |
-		MTK_WED_GLO_CFG_RX_DMA_EN);
-	wed_clr(dev, MTK_WED_WPDMA_GLO_CFG,
-		MTK_WED_WPDMA_GLO_CFG_TX_DRV_EN |
-		MTK_WED_WPDMA_GLO_CFG_RX_DRV_EN);
-	wed_clr(dev, MTK_WED_WDMA_GLO_CFG,
-		MTK_WED_WDMA_GLO_CFG_RX_DRV_EN);
 }
 
 static void
@@ -313,7 +325,10 @@ mtk_wed_hw_init_early(struct mtk_wed_device *dev)
 	      MTK_WED_WDMA_GLO_CFG_IDLE_DMAD_SUPPLY;
 	wed_m32(dev, MTK_WED_WDMA_GLO_CFG, mask, set);
 
-	wdma_set(dev, MTK_WDMA_GLO_CFG, MTK_WDMA_GLO_CFG_RX_INFO_PRERES);
+	wdma_set(dev, MTK_WDMA_GLO_CFG,
+		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
+		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
+		 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
 
 	offset = dev->hw->index ? 0x04000400 : 0;
 	wed_w32(dev, MTK_WED_WDMA_OFFSET0, 0x2a042a20 + offset);
@@ -520,43 +535,38 @@ mtk_wed_wdma_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 }
 
 static void
-mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
+mtk_wed_configure_irq(struct mtk_wed_device *dev, u32 irq_mask)
 {
-	u32 wdma_mask;
-	u32 val;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
-		if (!dev->tx_wdma[i].desc)
-			mtk_wed_wdma_ring_setup(dev, i, 16);
-
-	wdma_mask = FIELD_PREP(MTK_WDMA_INT_MASK_RX_DONE, GENMASK(1, 0));
-
-	mtk_wed_hw_init(dev);
+	u32 wdma_mask = FIELD_PREP(MTK_WDMA_INT_MASK_RX_DONE, GENMASK(1, 0));
 
+	/* wed control cr set */
 	wed_set(dev, MTK_WED_CTRL,
 		MTK_WED_CTRL_WDMA_INT_AGENT_EN |
 		MTK_WED_CTRL_WPDMA_INT_AGENT_EN |
 		MTK_WED_CTRL_WED_TX_BM_EN |
 		MTK_WED_CTRL_WED_TX_FREE_AGENT_EN);
 
-	wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER, MTK_WED_PCIE_INT_TRIGGER_STATUS);
+	wed_w32(dev, MTK_WED_PCIE_INT_TRIGGER,
+		MTK_WED_PCIE_INT_TRIGGER_STATUS);
 
 	wed_w32(dev, MTK_WED_WPDMA_INT_TRIGGER,
 		MTK_WED_WPDMA_INT_TRIGGER_RX_DONE |
 		MTK_WED_WPDMA_INT_TRIGGER_TX_DONE);
 
-	wed_set(dev, MTK_WED_WPDMA_INT_CTRL,
-		MTK_WED_WPDMA_INT_CTRL_SUBRT_ADV);
-
+	/* initail wdma interrupt agent */
 	wed_w32(dev, MTK_WED_WDMA_INT_TRIGGER, wdma_mask);
 	wed_clr(dev, MTK_WED_WDMA_INT_CTRL, wdma_mask);
 
 	wdma_w32(dev, MTK_WDMA_INT_MASK, wdma_mask);
 	wdma_w32(dev, MTK_WDMA_INT_GRP2, wdma_mask);
-
 	wed_w32(dev, MTK_WED_WPDMA_INT_MASK, irq_mask);
 	wed_w32(dev, MTK_WED_INT_MASK, irq_mask);
+}
+
+static void
+mtk_wed_dma_enable(struct mtk_wed_device *dev)
+{
+	wed_set(dev, MTK_WED_WPDMA_INT_CTRL, MTK_WED_WPDMA_INT_CTRL_SUBRT_ADV);
 
 	wed_set(dev, MTK_WED_GLO_CFG,
 		MTK_WED_GLO_CFG_TX_DMA_EN |
@@ -567,6 +577,26 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 	wed_set(dev, MTK_WED_WDMA_GLO_CFG,
 		MTK_WED_WDMA_GLO_CFG_RX_DRV_EN);
 
+	wdma_set(dev, MTK_WDMA_GLO_CFG,
+		 MTK_WDMA_GLO_CFG_TX_DMA_EN |
+		 MTK_WDMA_GLO_CFG_RX_INFO1_PRERES |
+		 MTK_WDMA_GLO_CFG_RX_INFO2_PRERES |
+		 MTK_WDMA_GLO_CFG_RX_INFO3_PRERES);
+}
+
+static void
+mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
+{
+	u32 val;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
+		if (!dev->tx_wdma[i].desc)
+			mtk_wed_wdma_ring_setup(dev, i, 16);
+
+	mtk_wed_hw_init(dev);
+	mtk_wed_configure_irq(dev, irq_mask);
+
 	mtk_wed_set_ext_int(dev, true);
 	val = dev->wlan.wpdma_phys |
 	      MTK_PCIE_MIRROR_MAP_EN |
@@ -577,6 +607,7 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 	val |= BIT(0);
 	regmap_write(dev->hw->mirror, dev->hw->index * 4, val);
 
+	mtk_wed_dma_enable(dev);
 	dev->running = true;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index 0a0465ea58b4..eec22daebd30 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -224,7 +224,11 @@ struct mtk_wdma_desc {
 #define MTK_WDMA_RING_RX(_n)				(0x100 + (_n) * 0x10)
 
 #define MTK_WDMA_GLO_CFG				0x204
-#define MTK_WDMA_GLO_CFG_RX_INFO_PRERES			GENMASK(28, 26)
+#define MTK_WDMA_GLO_CFG_TX_DMA_EN			BIT(0)
+#define MTK_WDMA_GLO_CFG_RX_DMA_EN			BIT(2)
+#define MTK_WDMA_GLO_CFG_RX_INFO3_PRERES		BIT(26)
+#define MTK_WDMA_GLO_CFG_RX_INFO2_PRERES		BIT(27)
+#define MTK_WDMA_GLO_CFG_RX_INFO1_PRERES		BIT(28)
 
 #define MTK_WDMA_RESET_IDX				0x208
 #define MTK_WDMA_RESET_IDX_TX				GENMASK(3, 0)
-- 
2.37.3

