Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40036660FBD
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 16:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjAGPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 10:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjAGPBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 10:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFCE61440;
        Sat,  7 Jan 2023 07:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A61BB81913;
        Sat,  7 Jan 2023 15:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C721C433F0;
        Sat,  7 Jan 2023 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103672;
        bh=0P6rK3Vzvxp2hpgnHM7yHTUWvNy5DAupIdqSG+eXd6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BewC36rIPZb3ApiVfEMxDVmr9mh9S7IcOUhS0cThL8Zos0tciZPYkWJKVGnZ5leHd
         BuHz1YZR2wk0sSwCt77nInLVpnqRsL30K8msI5C7T1CJkJMGJE0e23pMfeMv7Lname
         9tQf2K2N/oHPn2Qx24nsyuSrIb0Z9dRFFamiiM1Fne6W67rXGYoX5Gm7gsT7NDqTnR
         70EgwxWApFkUFqcD0ZQ4iaYZPBi8SNqMcvGaTh9X9VyD3aen3o4dFVYMMx02hP7+eN
         N1yBLdGuLyiH7mTk6vEq6VB9bz97RG6MC411a8CjL0f7wt9m97W76i5EukzPC7Dzme
         B42koUJVyDS4g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH 1/4] wifi: mt76: dma: add reset to mt76_dma_wed_setup signature
Date:   Sat,  7 Jan 2023 16:00:36 +0100
Message-Id: <52004754dac6fe62dc087c5c0bd1e40f4c7629c3.1673103214.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673103214.git.lorenzo@kernel.org>
References: <cover.1673103214.git.lorenzo@kernel.org>
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

From: Sujuan Chen <sujuan.chen@mediatek.com>

Export mt76_dma_wed_setup routine. This is a preliminary patch to
introduce proper wed reset support.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 16 ++++++++++------
 drivers/net/wireless/mediatek/mt76/dma.h |  1 +
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 33e47ea0368e..5629b949fac0 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -634,14 +634,17 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q,
 	return frames;
 }
 
-static int
-mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q)
+int mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q, bool reset)
 {
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
 	struct mtk_wed_device *wed = &dev->mmio.wed;
 	int ret, type, ring;
-	u8 flags = q->flags;
+	u8 flags;
+
+	if (!q || !q->ndesc)
+		return -EINVAL;
 
+	flags = q->flags;
 	if (!mtk_wed_device_active(wed))
 		q->flags &= ~MT_QFLAG_WED;
 
@@ -653,7 +656,7 @@ mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q)
 
 	switch (type) {
 	case MT76_WED_Q_TX:
-		ret = mtk_wed_device_tx_ring_setup(wed, ring, q->regs, false);
+		ret = mtk_wed_device_tx_ring_setup(wed, ring, q->regs, reset);
 		if (!ret)
 			q->wed_regs = wed->tx_ring[ring].reg_base;
 		break;
@@ -669,7 +672,7 @@ mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q)
 			q->wed_regs = wed->txfree_ring.reg_base;
 		break;
 	case MT76_WED_Q_RX:
-		ret = mtk_wed_device_rx_ring_setup(wed, ring, q->regs, false);
+		ret = mtk_wed_device_rx_ring_setup(wed, ring, q->regs, reset);
 		if (!ret)
 			q->wed_regs = wed->rx_ring[ring].reg_base;
 		break;
@@ -682,6 +685,7 @@ mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q)
 	return 0;
 #endif
 }
+EXPORT_SYMBOL_GPL(mt76_dma_wed_setup);
 
 static int
 mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
@@ -712,7 +716,7 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	if (ret)
 		return ret;
 
-	ret = mt76_dma_wed_setup(dev, q);
+	ret = mt76_dma_wed_setup(dev, q, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 53c6ce2528b2..4b9bc7f462b8 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -56,5 +56,6 @@ enum mt76_mcu_evt_type {
 int mt76_dma_rx_poll(struct napi_struct *napi, int budget);
 void mt76_dma_attach(struct mt76_dev *dev);
 void mt76_dma_cleanup(struct mt76_dev *dev);
+int mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q, bool reset);
 
 #endif
-- 
2.39.0

