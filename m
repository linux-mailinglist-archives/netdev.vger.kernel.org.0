Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD66416C7
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 14:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiLCNG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 08:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLCNGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 08:06:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0358410FF5
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 05:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93EDF60C44
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 13:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8E8C433C1;
        Sat,  3 Dec 2022 13:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670072810;
        bh=Vo3fkvSX826mwP9UMcYTnSSxWbHto2AxWbY9D8FrhE8=;
        h=From:To:Cc:Subject:Date:From;
        b=pCWqkVUAAMsY0ORtsK6/be3JPJTgouUFckrZx9lJKA6EN385RJAHBToH5t2UgY9CU
         Dbkcx1WeHLAqDHAEDRofrvIdCWMUadXbs6blk6eQB67oPdTki5r0rv6C90ujt2AxBG
         PRi48j1XlBbo53VEuRMg7aonJAsCYNUwVB6ly6Z/USILAybKIGiywlNK/0qrqQzVHe
         6YSvqCzDU6M9PA28x/y0YIEgl9LMUoFbXSr00xTFKws0+dgMPSPjXG9Ll7xMdRc+C3
         I6zkL1nK4fXwGucnN/8d9bwlBi6GyXciQX8h1b5nQx2KbDXndbPXsbaw8KKegd2fDR
         GW0dB4+us6LRw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, sujuan.chen@mediatek.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_wed: add reset to rx_ring_setup callback
Date:   Sat,  3 Dec 2022 14:06:30 +0100
Message-Id: <26fa16f2f212bff5edfdbe8a4f41dba7a132b0be.1670072570.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Introduce reset parameter to mtk_wed_rx_ring_setup signature.
This is a preliminary patch to add Wireless Ethernet Dispatcher reset
support.

Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c  | 20 +++++++++++++-------
 drivers/net/wireless/mediatek/mt76/dma.c |  2 +-
 include/linux/soc/mediatek/mtk_wed.h     |  8 ++++----
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 6352abd4157e..b1ec3f353b66 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1216,7 +1216,8 @@ mtk_wed_wdma_rx_ring_setup(struct mtk_wed_device *dev, int idx, int size,
 }
 
 static int
-mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size)
+mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size,
+			   bool reset)
 {
 	u32 desc_size = sizeof(struct mtk_wdma_desc) * dev->hw->version;
 	struct mtk_wed_ring *wdma;
@@ -1225,8 +1226,8 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 		return -EINVAL;
 
 	wdma = &dev->tx_wdma[idx];
-	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size,
-			       true))
+	if (!reset && mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE,
+					 desc_size, true))
 		return -ENOMEM;
 
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_BASE,
@@ -1236,6 +1237,9 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_CPU_IDX, 0);
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_DMA_IDX, 0);
 
+	if (reset)
+		mtk_wed_ring_reset(wdma, MTK_WED_WDMA_RING_SIZE, true);
+
 	if (!idx)  {
 		wed_w32(dev, MTK_WED_WDMA_RING_TX + MTK_WED_RING_OFS_BASE,
 			wdma->desc_phys);
@@ -1577,18 +1581,20 @@ mtk_wed_txfree_ring_setup(struct mtk_wed_device *dev, void __iomem *regs)
 }
 
 static int
-mtk_wed_rx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs)
+mtk_wed_rx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs,
+		      bool reset)
 {
 	struct mtk_wed_ring *ring = &dev->rx_ring[idx];
 
 	if (WARN_ON(idx >= ARRAY_SIZE(dev->rx_ring)))
 		return -EINVAL;
 
-	if (mtk_wed_ring_alloc(dev, ring, MTK_WED_RX_RING_SIZE,
-			       sizeof(*ring->desc), false))
+	if (!reset && mtk_wed_ring_alloc(dev, ring, MTK_WED_RX_RING_SIZE,
+					 sizeof(*ring->desc), false))
 		return -ENOMEM;
 
-	if (mtk_wed_wdma_tx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
+	if (mtk_wed_wdma_tx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE,
+				       reset))
 		return -ENOMEM;
 
 	ring->reg_base = MTK_WED_RING_RX_DATA(idx);
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 3f8c0845fcca..f795548562f5 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -648,7 +648,7 @@ mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q)
 			q->wed_regs = wed->txfree_ring.reg_base;
 		break;
 	case MT76_WED_Q_RX:
-		ret = mtk_wed_device_rx_ring_setup(wed, ring, q->regs);
+		ret = mtk_wed_device_rx_ring_setup(wed, ring, q->regs, false);
 		if (!ret)
 			q->wed_regs = wed->rx_ring[ring].reg_base;
 		break;
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index beb190449704..a0746d4aec20 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -160,7 +160,7 @@ struct mtk_wed_ops {
 	int (*tx_ring_setup)(struct mtk_wed_device *dev, int ring,
 			     void __iomem *regs, bool reset);
 	int (*rx_ring_setup)(struct mtk_wed_device *dev, int ring,
-			     void __iomem *regs);
+			     void __iomem *regs, bool reset);
 	int (*txfree_ring_setup)(struct mtk_wed_device *dev,
 				 void __iomem *regs);
 	int (*msg_update)(struct mtk_wed_device *dev, int cmd_id,
@@ -228,8 +228,8 @@ mtk_wed_get_rx_capa(struct mtk_wed_device *dev)
 	(_dev)->ops->irq_get(_dev, _mask)
 #define mtk_wed_device_irq_set_mask(_dev, _mask) \
 	(_dev)->ops->irq_set_mask(_dev, _mask)
-#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) \
-	(_dev)->ops->rx_ring_setup(_dev, _ring, _regs)
+#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs, _reset) \
+	(_dev)->ops->rx_ring_setup(_dev, _ring, _regs, _reset)
 #define mtk_wed_device_ppe_check(_dev, _skb, _reason, _hash) \
 	(_dev)->ops->ppe_check(_dev, _skb, _reason, _hash)
 #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) \
@@ -249,7 +249,7 @@ static inline bool mtk_wed_device_active(struct mtk_wed_device *dev)
 #define mtk_wed_device_reg_write(_dev, _reg, _val) do {} while (0)
 #define mtk_wed_device_irq_get(_dev, _mask) 0
 #define mtk_wed_device_irq_set_mask(_dev, _mask) do {} while (0)
-#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs) -ENODEV
+#define mtk_wed_device_rx_ring_setup(_dev, _ring, _regs, _reset) -ENODEV
 #define mtk_wed_device_ppe_check(_dev, _skb, _reason, _hash)  do {} while (0)
 #define mtk_wed_device_update_msg(_dev, _id, _msg, _len) -ENODEV
 #define mtk_wed_device_stop(_dev) do {} while (0)
-- 
2.38.1

