Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E27660FC5
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 16:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjAGPCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 10:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjAGPB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 10:01:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC645B7;
        Sat,  7 Jan 2023 07:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98DB7B81913;
        Sat,  7 Jan 2023 15:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44F9C433EF;
        Sat,  7 Jan 2023 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103684;
        bh=j1WBXjkpRVy8Ce7/G0GH1BdyVEDIVsDOUnYyyQViOto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orTUoyJYoMaDWKv5LZzSnfO+mrC8YKkpvkjyUyl6apuK3+lun3qk3lbnPE4AnKoa2
         M0dorGZHyhwTGi97k1Gm+J3o7gkRfdYm4SGw6eWBIFkygesvqgz14AxgxsJbBKy9rr
         6t4jIcjEYBLgQiNwx1llsJdViVKXAy2hYFN4DQpy5oPuwZZTHTFOAMY5038OLRLmUJ
         DEca2BK3mwnAaeof2XrHpknRFUgIJpp6wJkrB3aadVt5aSyb5GG0mHaI9yliMGmoLu
         Ha4jvzhMp7Z/ThrxzSb5SHOBYfwOegIOUK4E9ONEUc3ZtOqNpcOXo/1bw9W23tq/7S
         6Aj3Lnnzc8Siw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH 4/4] wifi: mt76: mt7915: complete wed reset support
Date:   Sat,  7 Jan 2023 16:00:39 +0100
Message-Id: <2c3f47b4a276896cc9c410c238d31e9fa973fc54.1673103214.git.lorenzo@kernel.org>
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

Stop Wireless Ethernet Dispatcher during mt7915 reset procedure.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/dma.c   | 30 +++++++++++++++----
 .../net/wireless/mediatek/mt76/mt7915/mac.c   |  6 ++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index a956e2a0be4f..abe17dac9996 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -573,9 +573,18 @@ static void mt7915_dma_wed_reset(struct mt7915_dev *dev)
 		dev_err(dev->mt76.dev, "wed reset complete timeout\n");
 }
 
+static void
+mt7915_dma_reset_tx_queue(struct mt7915_dev *dev, struct mt76_queue *q)
+{
+	mt76_queue_reset(dev, q);
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed))
+		mt76_dma_wed_setup(&dev->mt76, q, true);
+}
+
 int mt7915_dma_reset(struct mt7915_dev *dev, bool force)
 {
 	struct mt76_phy *mphy_ext = dev->mt76.phys[MT_BAND1];
+	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
 	int i;
 
 	/* clean up hw queues */
@@ -595,29 +604,40 @@ int mt7915_dma_reset(struct mt7915_dev *dev, bool force)
 	if (force)
 		mt7915_wfsys_reset(dev);
 
+	if (mtk_wed_device_active(wed))
+		mtk_wed_device_dma_reset(wed);
+
 	mt7915_dma_disable(dev, force);
 	mt7915_dma_wed_reset(dev);
 
 	/* reset hw queues */
 	for (i = 0; i < __MT_TXQ_MAX; i++) {
-		mt76_queue_reset(dev, dev->mphy.q_tx[i]);
+		mt7915_dma_reset_tx_queue(dev, dev->mphy.q_tx[i]);
 		if (mphy_ext)
-			mt76_queue_reset(dev, mphy_ext->q_tx[i]);
+			mt7915_dma_reset_tx_queue(dev, mphy_ext->q_tx[i]);
 	}
 
 	for (i = 0; i < __MT_MCUQ_MAX; i++)
 		mt76_queue_reset(dev, dev->mt76.q_mcu[i]);
 
-	mt76_for_each_q_rx(&dev->mt76, i)
+	mt76_for_each_q_rx(&dev->mt76, i) {
+		if (dev->mt76.q_rx[i].flags == MT_WED_Q_TXFREE)
+			continue;
+
 		mt76_queue_reset(dev, &dev->mt76.q_rx[i]);
+	}
 
 	mt76_tx_status_check(&dev->mt76, true);
 
-	mt7915_dma_enable(dev);
-
 	mt76_for_each_q_rx(&dev->mt76, i)
 		mt76_queue_rx_reset(dev, i);
 
+	if (mtk_wed_device_active(wed) && is_mt7915(&dev->mt76))
+		mt76_rmw(dev, MT_WFDMA0_EXT0_CFG, MT_WFDMA0_EXT0_RXWB_KEEP,
+			 MT_WFDMA0_EXT0_RXWB_KEEP);
+
+	mt7915_dma_enable(dev);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 65727ce6c29e..fb37b2a3274e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1581,6 +1581,12 @@ void mt7915_mac_reset_work(struct work_struct *work)
 	if (!(READ_ONCE(dev->recovery.state) & MT_MCU_CMD_STOP_DMA))
 		return;
 
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed)) {
+		mtk_wed_device_stop(&dev->mt76.mmio.wed);
+		if (!is_mt7986(&dev->mt76))
+			mt76_wr(dev, MT_INT_WED_MASK_CSR, 0);
+	}
+
 	ieee80211_stop_queues(mt76_hw(dev));
 	if (ext_phy)
 		ieee80211_stop_queues(ext_phy->hw);
-- 
2.39.0

