Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456D3667199
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjALMFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjALME3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:04:29 -0500
Received: from exchange.fintech.ru (e10edge.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251D254D8B;
        Thu, 12 Jan 2023 03:59:07 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Thu, 12 Jan
 2023 14:59:05 +0300
Received: from localhost (10.0.253.157) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 12 Jan
 2023 14:59:05 +0300
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        <lvc-project@linuxtesting.org>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>
Subject: [PATCH 5.10 1/1] mt76: move mt76_init_tx_queue in common code
Date:   Thu, 12 Jan 2023 03:58:50 -0800
Message-ID: <20230112115850.9208-2-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112115850.9208-1-n.zhandarovich@fintech.ru>
References: <20230112115850.9208-1-n.zhandarovich@fintech.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.157]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit b671da33d1c5973f90f098ff66a91953691df582 upstream.

Move mt76_init_tx_queue in mac80211.c since it is shared by all
drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 21 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 ++
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 10 +---
 .../net/wireless/mediatek/mt76/mt7615/dma.c   | 50 +++++++------------
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 10 +---
 .../net/wireless/mediatek/mt76/mt7915/dma.c   | 48 +++++-------------
 6 files changed, 58 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 2bc1ef1cbfea..d48f09a3c539 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1213,3 +1213,24 @@ int mt76_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_get_antenna);
+
+int mt76_init_tx_queue(struct mt76_dev *dev, int qid, int idx,
+		       int n_desc, int ring_base)
+{
+	struct mt76_queue *hwq;
+	int err;
+
+	hwq = devm_kzalloc(dev->dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return -ENOMEM;
+
+	err = dev->queue_ops->alloc(dev, hwq, idx, n_desc, 0, ring_base);
+	if (err < 0)
+		return err;
+
+	hwq->qid = qid;
+	dev->q_tx[qid] = hwq;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_init_tx_queue);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 34b6d32ea1ec..63549a7806cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -134,6 +134,7 @@ struct mt76_queue {
 
 	u8 buf_offset;
 	u8 hw_idx;
+	u8 qid;
 
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
@@ -778,6 +779,9 @@ void mt76_seq_puts_array(struct seq_file *file, const char *str,
 int mt76_eeprom_init(struct mt76_dev *dev, int len);
 void mt76_eeprom_override(struct mt76_dev *dev);
 
+int mt76_init_tx_queue(struct mt76_dev *dev, int qid, int idx,
+		       int n_desc, int ring_base);
+
 static inline struct mt76_phy *
 mt76_dev_phy(struct mt76_dev *dev, bool phy_ext)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index d60d00f6f6a0..05a5801646d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -7,19 +7,13 @@
 static int
 mt7603_init_tx_queue(struct mt7603_dev *dev, int qid, int idx, int n_desc)
 {
-	struct mt76_queue *hwq;
 	int err;
 
-	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
-	if (!hwq)
-		return -ENOMEM;
-
-	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
+	err = mt76_init_tx_queue(&dev->mt76, qid, idx, n_desc,
+				 MT_TX_RING_BASE);
 	if (err < 0)
 		return err;
 
-	dev->mt76.q_tx[qid] = hwq;
-
 	mt7603_irq_enable(dev, MT_INT_TX_DONE(idx));
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/dma.c b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
index bf8ae14121db..333254734ac5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
@@ -11,25 +11,6 @@
 #include "../dma.h"
 #include "mac.h"
 
-static int
-mt7615_init_tx_queue(struct mt7615_dev *dev, int qid, int idx, int n_desc)
-{
-	struct mt76_queue *hwq;
-	int err;
-
-	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
-	if (!hwq)
-		return -ENOMEM;
-
-	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
-	if (err < 0)
-		return err;
-
-	dev->mt76.q_tx[qid] = hwq;
-
-	return 0;
-}
-
 static int
 mt7622_init_tx_queues_multi(struct mt7615_dev *dev)
 {
@@ -43,20 +24,22 @@ mt7622_init_tx_queues_multi(struct mt7615_dev *dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wmm_queue_map); i++) {
-		ret = mt7615_init_tx_queue(dev, i, wmm_queue_map[i],
-					   MT7615_TX_RING_SIZE / 2);
+		ret = mt76_init_tx_queue(&dev->mt76, i, wmm_queue_map[i],
+					 MT7615_TX_RING_SIZE / 2,
+					 MT_TX_RING_BASE);
 		if (ret)
 			return ret;
 	}
 
-	ret = mt7615_init_tx_queue(dev, MT_TXQ_PSD,
-				   MT7622_TXQ_MGMT, MT7615_TX_MGMT_RING_SIZE);
+	ret = mt76_init_tx_queue(&dev->mt76, MT_TXQ_PSD, MT7622_TXQ_MGMT,
+				 MT7615_TX_MGMT_RING_SIZE,
+				 MT_TX_RING_BASE);
 	if (ret)
 		return ret;
 
-	ret = mt7615_init_tx_queue(dev, MT_TXQ_MCU,
-				   MT7622_TXQ_MCU, MT7615_TX_MCU_RING_SIZE);
-	return ret;
+	return mt76_init_tx_queue(&dev->mt76, MT_TXQ_MCU, MT7622_TXQ_MCU,
+				  MT7615_TX_MCU_RING_SIZE,
+				  MT_TX_RING_BASE);
 }
 
 static int
@@ -64,25 +47,26 @@ mt7615_init_tx_queues(struct mt7615_dev *dev)
 {
 	int ret, i;
 
-	ret = mt7615_init_tx_queue(dev, MT_TXQ_FWDL,
-				   MT7615_TXQ_FWDL,
-				   MT7615_TX_FWDL_RING_SIZE);
+	ret = mt76_init_tx_queue(&dev->mt76, MT_TXQ_FWDL, MT7615_TXQ_FWDL,
+				 MT7615_TX_FWDL_RING_SIZE,
+				 MT_TX_RING_BASE);
 	if (ret)
 		return ret;
 
 	if (!is_mt7615(&dev->mt76))
 		return mt7622_init_tx_queues_multi(dev);
 
-	ret = mt7615_init_tx_queue(dev, 0, 0, MT7615_TX_RING_SIZE);
+	ret = mt76_init_tx_queue(&dev->mt76, 0, 0, MT7615_TX_RING_SIZE,
+				 MT_TX_RING_BASE);
 	if (ret)
 		return ret;
 
 	for (i = 1; i < MT_TXQ_MCU; i++)
 		dev->mt76.q_tx[i] = dev->mt76.q_tx[0];
 
-	ret = mt7615_init_tx_queue(dev, MT_TXQ_MCU, MT7615_TXQ_MCU,
-				   MT7615_TX_MCU_RING_SIZE);
-	return 0;
+	return mt76_init_tx_queue(&dev->mt76, MT_TXQ_MCU, MT7615_TXQ_MCU,
+				  MT7615_TX_MCU_RING_SIZE,
+				  MT_TX_RING_BASE);
 }
 
 static int mt7615_poll_tx(struct napi_struct *napi, int budget)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 67911c021633..82f65fa1a39d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -106,19 +106,13 @@ EXPORT_SYMBOL_GPL(mt76x02e_init_beacon_config);
 static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, int qid, int idx, int n_desc)
 {
-	struct mt76_queue *hwq;
 	int err;
 
-	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
-	if (!hwq)
-		return -ENOMEM;
-
-	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
+	err = mt76_init_tx_queue(&dev->mt76, qid, idx, n_desc,
+				 MT_TX_RING_BASE);
 	if (err < 0)
 		return err;
 
-	dev->mt76.q_tx[qid] = hwq;
-
 	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index 33c42ecef2a4..7c9fe142ed41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -6,41 +6,16 @@
 #include "mac.h"
 
 static int
-mt7915_init_tx_queues(struct mt7915_dev *dev, int n_desc)
+mt7915_init_tx_queues(struct mt7915_dev *dev, int idx, int n_desc)
 {
-	struct mt76_queue *hwq;
-	int err, i;
+	int i, err;
 
-	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
-	if (!hwq)
-		return -ENOMEM;
-
-	err = mt76_queue_alloc(dev, hwq, MT7915_TXQ_BAND0, n_desc, 0,
-			       MT_TX_RING_BASE);
+	err = mt76_init_tx_queue(&dev->mt76, 0, idx, n_desc, MT_TX_RING_BASE);
 	if (err < 0)
 		return err;
 
 	for (i = 0; i < MT_TXQ_MCU; i++)
-		dev->mt76.q_tx[i] = hwq;
-
-	return 0;
-}
-
-static int
-mt7915_init_mcu_queue(struct mt7915_dev *dev, int qid, int idx, int n_desc)
-{
-	struct mt76_queue *hwq;
-	int err;
-
-	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
-	if (!hwq)
-		return -ENOMEM;
-
-	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
-	if (err < 0)
-		return err;
-
-	dev->mt76.q_tx[qid] = hwq;
+		dev->mt76.q_tx[i] = dev->mt76.q_tx[0];
 
 	return 0;
 }
@@ -262,25 +237,26 @@ int mt7915_dma_init(struct mt7915_dev *dev)
 	mt76_wr(dev, MT_WFDMA1_PRI_DLY_INT_CFG0, 0);
 
 	/* init tx queue */
-	ret = mt7915_init_tx_queues(dev, MT7915_TX_RING_SIZE);
+	ret = mt7915_init_tx_queues(dev, MT7915_TXQ_BAND0,
+				    MT7915_TX_RING_SIZE);
 	if (ret)
 		return ret;
 
 	/* command to WM */
-	ret = mt7915_init_mcu_queue(dev, MT_TXQ_MCU, MT7915_TXQ_MCU_WM,
-				    MT7915_TX_MCU_RING_SIZE);
+	ret = mt76_init_tx_queue(&dev->mt76, MT_TXQ_MCU, MT7915_TXQ_MCU_WM,
+				 MT7915_TX_MCU_RING_SIZE, MT_TX_RING_BASE);
 	if (ret)
 		return ret;
 
 	/* command to WA */
-	ret = mt7915_init_mcu_queue(dev, MT_TXQ_MCU_WA, MT7915_TXQ_MCU_WA,
-				    MT7915_TX_MCU_RING_SIZE);
+	ret = mt76_init_tx_queue(&dev->mt76, MT_TXQ_MCU_WA, MT7915_TXQ_MCU_WA,
+				 MT7915_TX_MCU_RING_SIZE, MT_TX_RING_BASE);
 	if (ret)
 		return ret;
 
 	/* firmware download */
-	ret = mt7915_init_mcu_queue(dev, MT_TXQ_FWDL, MT7915_TXQ_FWDL,
-				    MT7915_TX_FWDL_RING_SIZE);
+	ret = mt76_init_tx_queue(&dev->mt76, MT_TXQ_FWDL, MT7915_TXQ_FWDL,
+				 MT7915_TX_FWDL_RING_SIZE, MT_TX_RING_BASE);
 	if (ret)
 		return ret;
 
-- 
2.25.1

