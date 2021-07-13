Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A83C73D4
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhGMQKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE422C061786;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wKmXz6DWd7BpdvLNDrNuZdtlhNtIRqIOTmMrLF8x1dA=; b=WhYhbZ6g5DR32kA3lB9GWaRmr+
        DKWPL8hqVMTqbeXumn/TWAzdP4ztgwt/m37xjUhJ1P4nX1uTt/Jz1tavnOpH5VsMUXvdftSwKNDaK
        fuHEkL16NBTkB7Zqf664ZMt6TqHjVPOKi5DCLSJK+j1rdBWktwGCX3DVcPUUCaY4WVm4=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwo-0008TX-27; Tue, 13 Jul 2021 18:07:50 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 7/7] mt76: mt7915: add Wireless Ethernet Dispatch support
Date:   Tue, 13 Jul 2021 18:07:45 +0200
Message-Id: <20210713160745.59707-8-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210713160745.59707-1-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is used to support hardware flow offloading from Ethernet to WLAN

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |  97 +++++++++++++-
 drivers/net/wireless/mediatek/mt76/mac80211.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mmio.c     |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  30 ++++-
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt7615/dma.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   4 +-
 .../net/wireless/mediatek/mt76/mt7915/dma.c   |  38 +++++-
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 123 +++++++++++++++---
 .../net/wireless/mediatek/mt76/mt7915/mac.h   |   2 +
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  32 +++++
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |   4 +
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |   1 +
 .../net/wireless/mediatek/mt76/mt7915/pci.c   |  96 +++++++++++---
 .../net/wireless/mediatek/mt76/mt7915/regs.h  |  19 ++-
 .../net/wireless/mediatek/mt76/mt7921/dma.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       |  14 +-
 17 files changed, 422 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index ccdc020f72e5..10b924217a6c 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -7,9 +7,31 @@
 #include "mt76.h"
 #include "dma.h"
 
-#define Q_READ(_dev, _q, _field)		readl(&(_q)->regs->_field)
-#define Q_WRITE(_dev, _q, _field, _val)		writel(_val, &(_q)->regs->_field)
-
+#define Q_READ(_dev, _q, _field) ({					\
+	u32 _offset = offsetof(struct mt76_queue_regs, _field);		\
+	u32 _val;							\
+	if (IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED) &&			\
+	    (_q)->flags & MT_QFLAG_WED)					\
+		_val = mtk_wed_device_reg_read(&(_dev)->mmio.wed,	\
+					       ((_q)->wed_regs +	\
+					        _offset));		\
+	else								\
+		_val = readl(&(_q)->regs->_field);			\
+	_val;								\
+})
+
+#define Q_WRITE(_dev, _q, _field, _val)	do {				\
+	u32 _offset = offsetof(struct mt76_queue_regs, _field);		\
+	if (IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED) &&			\
+	    (_q)->flags & MT_QFLAG_WED)					\
+		mtk_wed_device_reg_write(&(_dev)->mmio.wed,		\
+					 ((_q)->wed_regs + _offset),	\
+					 _val);				\
+	else								\
+		writel(_val, &(_q)->regs->_field);			\
+} while (0)
+
+static int mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q);
 
 static struct mt76_txwi_cache *
 mt76_alloc_txwi(struct mt76_dev *dev)
@@ -109,12 +131,52 @@ mt76_dma_queue_reset(struct mt76_dev *dev, struct mt76_queue *q)
 	mt76_dma_sync_idx(dev, q);
 }
 
+static int
+mt76_dma_wed_setup(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	struct mtk_wed_device *wed = &dev->mmio.wed;
+	int ret, type, ring;
+	u8 flags = q->flags;
+
+	if (!mtk_wed_device_active(wed))
+		q->flags &= ~MT_QFLAG_WED;
+
+	if (!(q->flags & MT_QFLAG_WED))
+		return 0;
+
+	type = FIELD_GET(MT_QFLAG_WED_TYPE, q->flags);
+	ring = FIELD_GET(MT_QFLAG_WED_RING, q->flags);
+
+	switch (type) {
+	case MT76_WED_Q_TX:
+		ret = mtk_wed_device_tx_ring_setup(wed, ring, q->regs);
+		if (!ret)
+			q->wed_regs = wed->tx_ring[ring].reg_base;
+		break;
+	case MT76_WED_Q_TXFREE:
+		/* WED txfree queue needs ring to be initialized before setup */
+		q->flags = 0;
+		mt76_dma_queue_reset(dev, q);
+		mt76_dma_rx_fill(dev, q);
+		q->flags = flags;
+
+		ret = mtk_wed_device_txfree_ring_setup(wed, q->regs);
+		if (!ret)
+			q->wed_regs = wed->txfree_ring.reg_base;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static int
 mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize,
 		     u32 ring_base)
 {
-	int size;
+	int ret, size;
 
 	spin_lock_init(&q->lock);
 	spin_lock_init(&q->cleanup_lock);
@@ -134,7 +196,12 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	if (!q->entry)
 		return -ENOMEM;
 
-	mt76_dma_queue_reset(dev, q);
+	ret = mt76_dma_wed_setup(dev, q);
+	if (ret)
+		return ret;
+
+	if (q->flags != MT_WED_Q_TXFREE)
+		mt76_dma_queue_reset(dev, q);
 
 	return 0;
 }
@@ -556,14 +623,29 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
 static int
 mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 {
-	int len, data_len, done = 0;
+	int len, data_len, done = 0, dma_idx;
 	struct sk_buff *skb;
 	unsigned char *data;
+	bool check_ddone = false;
 	bool more;
 
+	if (IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED) &&
+	    q->flags == MT_WED_Q_TXFREE) {
+		dma_idx = Q_READ(dev, q, dma_idx);
+		check_ddone = true;
+	}
+
 	while (done < budget) {
 		u32 info;
 
+		if (check_ddone) {
+			if (q->tail == dma_idx)
+				dma_idx = Q_READ(dev, q, dma_idx);
+
+			if (q->tail == dma_idx)
+				break;
+		}
+
 		data = mt76_dma_dequeue(dev, q, false, &len, &info, &more);
 		if (!data)
 			break;
@@ -699,5 +781,8 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 	}
 
 	mt76_free_pending_txwi(dev);
+
+	if (mtk_wed_device_active(&dev->mmio.wed))
+		mtk_wed_device_detach(&dev->mmio.wed);
 }
 EXPORT_SYMBOL_GPL(mt76_dma_cleanup);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ba8b06acace3..bc77bff047a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1321,7 +1321,7 @@ EXPORT_SYMBOL_GPL(mt76_get_antenna);
 
 struct mt76_queue *
 mt76_init_queue(struct mt76_dev *dev, int qid, int idx, int n_desc,
-		int ring_base)
+		int ring_base, u32 flags)
 {
 	struct mt76_queue *hwq;
 	int err;
@@ -1330,6 +1330,8 @@ mt76_init_queue(struct mt76_dev *dev, int qid, int idx, int n_desc,
 	if (!hwq)
 		return ERR_PTR(-ENOMEM);
 
+	hwq->flags = flags;
+
 	err = dev->queue_ops->alloc(dev, hwq, idx, n_desc, 0, ring_base);
 	if (err < 0)
 		return ERR_PTR(err);
diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 26353b6bce97..86e3d2ac4d0d 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -73,8 +73,13 @@ void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr,
 	spin_lock_irqsave(&dev->mmio.irq_lock, flags);
 	dev->mmio.irqmask &= ~clear;
 	dev->mmio.irqmask |= set;
-	if (addr)
-		mt76_mmio_wr(dev, addr, dev->mmio.irqmask);
+	if (addr) {
+		if (mtk_wed_device_active(&dev->mmio.wed))
+			mtk_wed_device_irq_set_mask(&dev->mmio.wed,
+						    dev->mmio.irqmask);
+		else
+			mt76_mmio_wr(dev, addr, dev->mmio.irqmask);
+	}
 	spin_unlock_irqrestore(&dev->mmio.irq_lock, flags);
 }
 EXPORT_SYMBOL_GPL(mt76_set_irq_mask);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 840778ffe8ea..f100c32cf33f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -13,6 +13,7 @@
 #include <linux/leds.h>
 #include <linux/usb.h>
 #include <linux/average.h>
+#include <linux/soc/mediatek/mtk_wed.h>
 #include <net/mac80211.h>
 #include "util.h"
 #include "testmode.h"
@@ -26,6 +27,16 @@
 
 #define MT76_TOKEN_FREE_THR	64
 
+#define MT_QFLAG_WED_RING	GENMASK(1, 0)
+#define MT_QFLAG_WED_TYPE	GENMASK(3, 2)
+#define MT_QFLAG_WED		BIT(4)
+
+#define __MT_WED_Q(_type, _n)	(MT_QFLAG_WED | \
+				 FIELD_PREP(MT_QFLAG_WED_TYPE, _type) | \
+				 FIELD_PREP(MT_QFLAG_WED_RING, _n))
+#define MT_WED_Q_TX(_n)		__MT_WED_Q(MT76_WED_Q_TX, _n)
+#define MT_WED_Q_TXFREE		__MT_WED_Q(MT76_WED_Q_TXFREE, 0)
+
 struct mt76_dev;
 struct mt76_phy;
 struct mt76_wcid;
@@ -41,6 +52,11 @@ enum mt76_bus_type {
 	MT76_BUS_SDIO,
 };
 
+enum mt76_wed_type {
+	MT76_WED_Q_TX,
+	MT76_WED_Q_TXFREE,
+};
+
 struct mt76_bus_ops {
 	u32 (*rr)(struct mt76_dev *dev, u32 offset);
 	void (*wr)(struct mt76_dev *dev, u32 offset, u32 val);
@@ -161,6 +177,9 @@ struct mt76_queue {
 	u8 buf_offset;
 	u8 hw_idx;
 	u8 qid;
+	u8 flags;
+
+	u32 wed_regs;
 
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
@@ -511,6 +530,8 @@ struct mt76_mmio {
 	void __iomem *regs;
 	spinlock_t irq_lock;
 	u32 irqmask;
+
+	struct mtk_wed_device wed;
 };
 
 struct mt76_rx_status {
@@ -680,6 +701,7 @@ struct mt76_dev {
 
 	spinlock_t token_lock;
 	struct idr token;
+	u16 wed_token_count;
 	u16 token_count;
 	u16 token_size;
 
@@ -881,13 +903,13 @@ int mt76_get_of_eeprom(struct mt76_dev *dev, void *data, int offset, int len);
 
 struct mt76_queue *
 mt76_init_queue(struct mt76_dev *dev, int qid, int idx, int n_desc,
-		int ring_base);
+		int ring_base, u32 flags);
 static inline int mt76_init_tx_queue(struct mt76_phy *phy, int qid, int idx,
-				     int n_desc, int ring_base)
+				     int n_desc, int ring_base, u32 flags)
 {
 	struct mt76_queue *q;
 
-	q = mt76_init_queue(phy->dev, qid, idx, n_desc, ring_base);
+	q = mt76_init_queue(phy->dev, qid, idx, n_desc, ring_base, flags);
 	if (IS_ERR(q))
 		return PTR_ERR(q);
 
@@ -902,7 +924,7 @@ static inline int mt76_init_mcu_queue(struct mt76_dev *dev, int qid, int idx,
 {
 	struct mt76_queue *q;
 
-	q = mt76_init_queue(dev, qid, idx, n_desc, ring_base);
+	q = mt76_init_queue(dev, qid, idx, n_desc, ring_base, 0);
 	if (IS_ERR(q))
 		return PTR_ERR(q);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 415ea17b9be6..89acebcfe61c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -173,13 +173,13 @@ int mt7603_dma_init(struct mt7603_dev *dev)
 
 	for (i = 0; i < ARRAY_SIZE(wmm_queue_map); i++) {
 		ret = mt76_init_tx_queue(&dev->mphy, i, wmm_queue_map[i],
-					 MT7603_TX_RING_SIZE, MT_TX_RING_BASE);
+					 MT7603_TX_RING_SIZE, MT_TX_RING_BASE, 0);
 		if (ret)
 			return ret;
 	}
 
 	ret = mt76_init_tx_queue(&dev->mphy, MT_TXQ_PSD, MT_TX_HW_QUEUE_MGMT,
-				 MT7603_PSD_RING_SIZE, MT_TX_RING_BASE);
+				 MT7603_PSD_RING_SIZE, MT_TX_RING_BASE, 0);
 	if (ret)
 		return ret;
 
@@ -189,12 +189,12 @@ int mt7603_dma_init(struct mt7603_dev *dev)
 		return ret;
 
 	ret = mt76_init_tx_queue(&dev->mphy, MT_TXQ_BEACON, MT_TX_HW_QUEUE_BCN,
-				 MT_MCU_RING_SIZE, MT_TX_RING_BASE);
+				 MT_MCU_RING_SIZE, MT_TX_RING_BASE, 0);
 	if (ret)
 		return ret;
 
 	ret = mt76_init_tx_queue(&dev->mphy, MT_TXQ_CAB, MT_TX_HW_QUEUE_BMC,
-				 MT_MCU_RING_SIZE, MT_TX_RING_BASE);
+				 MT_MCU_RING_SIZE, MT_TX_RING_BASE, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/dma.c b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
index 00aefea1bf61..3a79a2d4f288 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
@@ -26,14 +26,14 @@ mt7622_init_tx_queues_multi(struct mt7615_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(wmm_queue_map); i++) {
 		ret = mt76_init_tx_queue(&dev->mphy, i, wmm_queue_map[i],
 					 MT7615_TX_RING_SIZE / 2,
-					 MT_TX_RING_BASE);
+					 MT_TX_RING_BASE, 0);
 		if (ret)
 			return ret;
 	}
 
 	ret = mt76_init_tx_queue(&dev->mphy, MT_TXQ_PSD, MT7622_TXQ_MGMT,
 				 MT7615_TX_MGMT_RING_SIZE,
-				 MT_TX_RING_BASE);
+				 MT_TX_RING_BASE, 0);
 	if (ret)
 		return ret;
 
@@ -55,7 +55,7 @@ mt7615_init_tx_queues(struct mt7615_dev *dev)
 		return mt7622_init_tx_queues_multi(dev);
 
 	ret = mt76_init_tx_queue(&dev->mphy, 0, 0, MT7615_TX_RING_SIZE,
-				 MT_TX_RING_BASE);
+				 MT_TX_RING_BASE, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index b50084bbe83d..7de91f8db9dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -191,13 +191,13 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		ret = mt76_init_tx_queue(&dev->mphy, i, mt76_ac_to_hwq(i),
 					 MT76x02_TX_RING_SIZE,
-					 MT_TX_RING_BASE);
+					 MT_TX_RING_BASE, 0);
 		if (ret)
 			return ret;
 	}
 
 	ret = mt76_init_tx_queue(&dev->mphy, MT_TXQ_PSD, MT_TX_HW_QUEUE_MGMT,
-				 MT76x02_PSD_RING_SIZE, MT_TX_RING_BASE);
+				 MT76x02_PSD_RING_SIZE, MT_TX_RING_BASE, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index 9182568f95c7..ae271968b60c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -7,9 +7,16 @@
 
 int mt7915_init_tx_queues(struct mt7915_phy *phy, int idx, int n_desc)
 {
+	u32 base = MT_TX_RING_BASE;
 	int i, err;
 
-	err = mt76_init_tx_queue(phy->mt76, 0, idx, n_desc, MT_TX_RING_BASE);
+	if (mtk_wed_device_active(&phy->dev->mt76.mmio.wed)) {
+		base = MT_WED_TX_RING_BASE;
+		idx -= MT7915_TXQ_BAND0;
+	}
+
+	err = mt76_init_tx_queue(phy->mt76, 0, idx, n_desc, base,
+				 MT_WED_Q_TX(idx));
 	if (err < 0)
 		return err;
 
@@ -79,6 +86,9 @@ void mt7915_dma_prefetch(struct mt7915_dev *dev)
 
 int mt7915_dma_init(struct mt7915_dev *dev)
 {
+	u32 irq_mask = MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_MCU |
+		       MT_INT_MCU_CMD;
+	u32 wa_rx_base = MT_RX_EVENT_RING_BASE;
 	u32 hif1_ofs = 0;
 	int ret;
 
@@ -112,6 +122,15 @@ int mt7915_dma_init(struct mt7915_dev *dev)
 		mt76_wr(dev, MT_WFDMA1_PRI_DLY_INT_CFG0 + hif1_ofs, 0);
 	}
 
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed)) {
+		mt76_set(dev, MT_WFDMA_HOST_CONFIG, MT_WFDMA_HOST_CONFIG_WED);
+
+		mt76_wr(dev, MT_WFDMA_WED_RING_CONTROL,
+			FIELD_PREP(MT_WFDMA_WED_RING_CONTROL_TX0, 18) |
+			FIELD_PREP(MT_WFDMA_WED_RING_CONTROL_TX1, 19) |
+			FIELD_PREP(MT_WFDMA_WED_RING_CONTROL_RX1, 1));
+	}
+
 	/* configure perfetch settings */
 	mt7915_dma_prefetch(dev);
 
@@ -147,9 +166,13 @@ int mt7915_dma_init(struct mt7915_dev *dev)
 		return ret;
 
 	/* event from WA */
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed)) {
+		wa_rx_base = MT_WED_RX_RING_BASE;
+		dev->mt76.q_rx[MT_RXQ_MCU_WA].flags = MT_WED_Q_TXFREE;
+	}
 	ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MCU_WA],
 			       MT7915_RXQ_MCU_WA, MT7915_RX_MCU_RING_SIZE,
-			       MT_RX_BUF_SIZE, MT_RX_EVENT_RING_BASE);
+			       MT_RX_BUF_SIZE, wa_rx_base);
 	if (ret)
 		return ret;
 
@@ -227,9 +250,16 @@ int mt7915_dma_init(struct mt7915_dev *dev)
 			 MT_WFDMA_HOST_CONFIG_PDMA_BAND);
 	}
 
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed)) {
+		u32 wed_irq_mask = irq_mask;
+
+		wed_irq_mask |= MT_INT_TX_DONE_BAND0 | MT_INT_TX_DONE_BAND1;
+		mt76_wr(dev, MT_INT_WED_MASK_CSR, wed_irq_mask);
+		mtk_wed_device_start(&dev->mt76.mmio.wed, wed_irq_mask);
+	}
+
 	/* enable interrupts for TX/RX rings */
-	mt7915_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_MCU |
-			  MT_INT_MCU_CMD);
+	mt7915_irq_enable(dev, irq_mask);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 2462704094b0..a216c68fe132 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1065,6 +1065,29 @@ int mt7915_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	return 0;
 }
 
+u32 mt7915_wed_init_buf(void *ptr, dma_addr_t phys, int token_id)
+{
+	struct mt7915_txp *txp = ptr + MT_TXD_SIZE;
+	__le32 *txwi = ptr;
+	u32 val;
+
+	memset(ptr, 0, MT_TXD_SIZE + sizeof(*txp));
+
+	val = FIELD_PREP(MT_TXD0_TX_BYTES, MT_TXD_SIZE) |
+	      FIELD_PREP(MT_TXD0_PKT_FMT, MT_TX_TYPE_CT);
+	txwi[0] = cpu_to_le32(val);
+
+	val = MT_TXD1_LONG_FORMAT |
+	      FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_3);
+	txwi[1] = cpu_to_le32(val);
+
+	txp->token = cpu_to_le16(token_id);
+	txp->nbuf = 1;
+	txp->buf[0] = cpu_to_le32(phys + MT_TXD_SIZE + sizeof(*txp));
+
+	return MT_TXD_SIZE + sizeof(*txp);
+}
+
 static void
 mt7915_tx_check_aggr(struct ieee80211_sta *sta, __le32 *txwi)
 {
@@ -1107,6 +1130,8 @@ mt7915_txwi_free(struct mt7915_dev *dev, struct mt76_txwi_cache *t,
 		 struct ieee80211_sta *sta, struct list_head *free_list)
 {
 	struct mt76_dev *mdev = &dev->mt76;
+	struct mt7915_sta *msta;
+	struct mt7915_phy *phy;
 	struct mt76_wcid *wcid;
 	__le32 *txwi;
 	u16 wcid_idx;
@@ -1119,13 +1144,27 @@ mt7915_txwi_free(struct mt7915_dev *dev, struct mt76_txwi_cache *t,
 	if (sta) {
 		wcid = (struct mt76_wcid *)sta->drv_priv;
 		wcid_idx = wcid->idx;
-
-		if (likely(t->skb->protocol != cpu_to_be16(ETH_P_PAE)))
-			mt7915_tx_check_aggr(sta, txwi);
 	} else {
 		wcid_idx = FIELD_GET(MT_TXD1_WLAN_IDX, le32_to_cpu(txwi[1]));
+		wcid = rcu_dereference(dev->mt76.wcid[wcid_idx]);
+
+		if (wcid && wcid->sta) {
+			msta = container_of(wcid, struct mt7915_sta, wcid);
+			sta = container_of((void *)msta, struct ieee80211_sta,
+					  drv_priv);
+			phy = msta->vif->phy;
+			spin_lock_bh(&dev->sta_poll_lock);
+			if (list_empty(&msta->stats_list))
+				list_add_tail(&msta->stats_list, &phy->stats_list);
+			if (list_empty(&msta->poll_list))
+				list_add_tail(&msta->poll_list, &dev->sta_poll_list);
+			spin_unlock_bh(&dev->sta_poll_lock);
+		}
 	}
 
+	if (sta && likely(t->skb->protocol != cpu_to_be16(ETH_P_PAE)))
+		mt7915_tx_check_aggr(sta, txwi);
+
 	__mt76_tx_complete_skb(mdev, wcid_idx, t->skb, free_list);
 
 out:
@@ -1134,17 +1173,10 @@ mt7915_txwi_free(struct mt7915_dev *dev, struct mt76_txwi_cache *t,
 }
 
 static void
-mt7915_mac_tx_free(struct mt7915_dev *dev, struct sk_buff *skb)
+mt7915_mac_tx_free_prepare(struct mt7915_dev *dev)
 {
-	struct mt7915_tx_free *free = (struct mt7915_tx_free *)skb->data;
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt76_phy *mphy_ext = mdev->phy2;
-	struct mt76_txwi_cache *txwi;
-	struct ieee80211_sta *sta = NULL;
-	LIST_HEAD(free_list);
-	struct sk_buff *tmp;
-	u8 i, count;
-	bool wake = false;
 
 	/* clean DMA queues and unmap buffers first */
 	mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[MT_TXQ_PSD], false);
@@ -1153,6 +1185,41 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, struct sk_buff *skb)
 		mt76_queue_tx_cleanup(dev, mphy_ext->q_tx[MT_TXQ_PSD], false);
 		mt76_queue_tx_cleanup(dev, mphy_ext->q_tx[MT_TXQ_BE], false);
 	}
+}
+
+static void
+mt7915_mac_tx_free_done(struct mt7915_dev *dev, struct sk_buff *skb,
+			struct list_head *free_list, bool wake)
+{
+	struct sk_buff *tmp;
+
+	mt7915_mac_sta_poll(dev);
+
+	if (wake)
+		mt76_set_tx_blocked(&dev->mt76, false);
+
+	mt76_worker_schedule(&dev->mt76.tx_worker);
+
+	napi_consume_skb(skb, 1);
+
+	list_for_each_entry_safe(skb, tmp, free_list, list) {
+		skb_list_del_init(skb);
+		napi_consume_skb(skb, 1);
+	}
+}
+
+static void
+mt7915_mac_tx_free(struct mt7915_dev *dev, struct sk_buff *skb)
+{
+	struct mt7915_tx_free *free = (struct mt7915_tx_free *)skb->data;
+	struct mt76_dev *mdev = &dev->mt76;
+	struct mt76_txwi_cache *txwi;
+	struct ieee80211_sta *sta = NULL;
+	LIST_HEAD(free_list);
+	u8 i, count;
+	bool wake = false;
+
+	mt7915_mac_tx_free_prepare(dev);
 
 	/*
 	 * TODO: MT_TX_FREE_LATENCY is msdu time from the TXD is queued into PLE,
@@ -1202,19 +1269,34 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, struct sk_buff *skb)
 		mt7915_txwi_free(dev, txwi, sta, &free_list);
 	}
 
-	mt7915_mac_sta_poll(dev);
+	mt7915_mac_tx_free_done(dev, skb, &free_list, wake);
+}
 
-	if (wake)
-		mt76_set_tx_blocked(&dev->mt76, false);
+static void
+mt7915_mac_tx_free_v0(struct mt7915_dev *dev, struct sk_buff *skb)
+{
+	struct mt7915_tx_free *free = (struct mt7915_tx_free *)skb->data;
+	struct mt76_dev *mdev = &dev->mt76;
+	__le16 *info = (__le16 *)free->info;
+	LIST_HEAD(free_list);
+	bool wake = false;
+	u8 i, count;
 
-	mt76_worker_schedule(&dev->mt76.tx_worker);
+	mt7915_mac_tx_free_prepare(dev);
 
-	napi_consume_skb(skb, 1);
+	count = FIELD_GET(MT_TX_FREE_MSDU_CNT_V0, le16_to_cpu(free->ctrl));
+	for (i = 0; i < count; i++) {
+		struct mt76_txwi_cache *txwi;
+		u16 msdu = le16_to_cpu(info[i]);
 
-	list_for_each_entry_safe(skb, tmp, &free_list, list) {
-		skb_list_del_init(skb);
-		napi_consume_skb(skb, 1);
+		txwi = mt76_token_release(mdev, msdu, &wake);
+		if (!txwi)
+			continue;
+
+		mt7915_txwi_free(dev, txwi, NULL, &free_list);
 	}
+
+	mt7915_mac_tx_free_done(dev, skb, &free_list, wake);
 }
 
 static bool
@@ -1308,6 +1390,9 @@ void mt7915_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	case PKT_TYPE_TXRX_NOTIFY:
 		mt7915_mac_tx_free(dev, skb);
 		break;
+	case PKT_TYPE_TXRX_NOTIFY_V0:
+		mt7915_mac_tx_free_v0(dev, skb);
+		break;
 	case PKT_TYPE_RX_EVENT:
 		mt7915_mcu_rx_event(dev, skb);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.h b/drivers/net/wireless/mediatek/mt76/mt7915/mac.h
index eb1885f4bd8e..83c457eb5cc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.h
@@ -23,6 +23,7 @@ enum rx_pkt_type {
 	PKT_TYPE_RETRIEVE,
 	PKT_TYPE_TXRX_NOTIFY,
 	PKT_TYPE_RX_EVENT,
+	PKT_TYPE_TXRX_NOTIFY_V0 = 0x18,
 };
 
 /* RXD DW1 */
@@ -295,6 +296,7 @@ struct mt7915_tx_free {
 } __packed __aligned(4);
 
 #define MT_TX_FREE_MSDU_CNT		GENMASK(9, 0)
+#define MT_TX_FREE_MSDU_CNT_V0	GENMASK(6, 0)
 #define MT_TX_FREE_WLAN_ID		GENMASK(23, 14)
 #define MT_TX_FREE_LATENCY		GENMASK(12, 0)
 /* 0: success, others: dropped */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index c25f8da590dd..7d29e23e823a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1032,6 +1032,37 @@ static void mt7915_sta_set_decap_offload(struct ieee80211_hw *hw,
 	mt7915_mcu_sta_update_hdr_trans(dev, vif, sta);
 }
 
+static int
+mt7915_net_fill_forward_path(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta,
+			     struct net_device_path_ctx *ctx,
+			     struct net_device_path *path)
+{
+	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
+	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
+	struct mt7915_dev *dev = mt7915_hw_dev(hw);
+	struct mt7915_phy *phy = mt7915_hw_phy(hw);
+	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
+
+	if (!mtk_wed_device_active(wed))
+		return -ENODEV;
+
+	if (msta->wcid.idx > 0xff)
+		return -EIO;
+
+	path->type = DEV_PATH_MTK_WDMA;
+	path->dev = ctx->dev;
+	path->mtk_wdma.wdma_idx = wed->wdma_idx;
+	path->mtk_wdma.bss = mvif->omac_idx;
+	path->mtk_wdma.wcid = msta->wcid.idx;
+	path->mtk_wdma.queue = phy != &dev->phy;
+
+	ctx->dev = NULL;
+
+	return 0;
+}
+
 const struct ieee80211_ops mt7915_ops = {
 	.tx = mt7915_tx,
 	.start = mt7915_start,
@@ -1072,4 +1103,5 @@ const struct ieee80211_ops mt7915_ops = {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.sta_add_debugfs = mt7915_sta_add_debugfs,
 #endif
+	.net_fill_forward_path = mt7915_net_fill_forward_path,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 863aa18b3024..444db639e9a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3011,6 +3011,10 @@ int mt7915_mcu_init(struct mt7915_dev *dev)
 		return ret;
 
 	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
+
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed))
+		mt7915_mcu_wa_cmd(dev, MCU_WA_PARAM_CMD(CAPABILITY), 0, 0, 0);
+
 	mt7915_mcu_fw_log_2_host(dev, 0);
 	mt7915_mcu_set_mwds(dev, 1);
 	mt7915_mcu_wa_cmd(dev, MCU_WA_PARAM_CMD(SET), MCU_WA_PARAM_RED, 0, 0);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 0652b711ae81..2dc5a4154155 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -294,6 +294,7 @@ extern const struct ieee80211_ops mt7915_ops;
 extern const struct mt76_testmode_ops mt7915_testmode_ops;
 
 u32 mt7915_reg_map(struct mt7915_dev *dev, u32 addr);
+u32 mt7915_wed_init_buf(void *ptr, dma_addr_t phys, int token_id);
 
 int mt7915_register_device(struct mt7915_dev *dev);
 void mt7915_unregister_device(struct mt7915_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 5e93620195da..164ccab556f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -97,15 +97,21 @@ mt7915_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 static void mt7915_irq_tasklet(struct tasklet_struct *t)
 {
 	struct mt7915_dev *dev = from_tasklet(dev, t, irq_tasklet);
+	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
 	u32 intr, intr1, mask;
 
-	mt76_wr(dev, MT_INT_MASK_CSR, 0);
-	if (dev->hif2)
-		mt76_wr(dev, MT_INT1_MASK_CSR, 0);
-
-	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
-	intr &= dev->mt76.mmio.irqmask;
-	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
+	if (mtk_wed_device_active(wed)) {
+		mtk_wed_device_irq_set_mask(wed, 0);
+		intr = mtk_wed_device_irq_get(wed, dev->mt76.mmio.irqmask);
+	} else {
+		mt76_wr(dev, MT_INT_MASK_CSR, 0);
+		if (dev->hif2)
+			mt76_wr(dev, MT_INT1_MASK_CSR, 0);
+
+		intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
+		intr &= dev->mt76.mmio.irqmask;
+		mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
+	}
 
 	if (dev->hif2) {
 		intr1 = mt76_rr(dev, MT_INT1_SOURCE_CSR);
@@ -156,10 +162,15 @@ static void mt7915_irq_tasklet(struct tasklet_struct *t)
 static irqreturn_t mt7915_irq_handler(int irq, void *dev_instance)
 {
 	struct mt7915_dev *dev = dev_instance;
-
-	mt76_wr(dev, MT_INT_MASK_CSR, 0);
-	if (dev->hif2)
-		mt76_wr(dev, MT_INT1_MASK_CSR, 0);
+	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
+
+	if (mtk_wed_device_active(wed)) {
+		mtk_wed_device_irq_set_mask(wed, 0);
+	} else {
+		mt76_wr(dev, MT_INT_MASK_CSR, 0);
+		if (dev->hif2)
+			mt76_wr(dev, MT_INT1_MASK_CSR, 0);
+	}
 
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mphy.state))
 		return IRQ_NONE;
@@ -216,6 +227,36 @@ static int mt7915_pci_hif2_probe(struct pci_dev *pdev)
 	return 0;
 }
 
+static int mt7915_wed_offload_enable(struct mtk_wed_device *wed)
+{
+	struct mt7915_dev *dev;
+	int ret;
+
+	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
+
+	spin_lock_bh(&dev->mt76.token_lock);
+	dev->mt76.token_size = wed->wlan.token_start;
+	spin_unlock_bh(&dev->mt76.token_lock);
+
+	ret = wait_event_timeout(dev->mt76.tx_wait,
+				 !dev->mt76.wed_token_count, HZ);
+	if (!ret)
+		return -EAGAIN;
+
+	return 0;
+}
+
+static void mt7915_wed_offload_disable(struct mtk_wed_device *wed)
+{
+	struct mt7915_dev *dev;
+
+	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
+
+	spin_lock_bh(&dev->mt76.token_lock);
+	dev->mt76.token_size = MT7915_TOKEN_SIZE;
+	spin_unlock_bh(&dev->mt76.token_lock);
+}
+
 static int mt7915_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -237,8 +278,10 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 		.sta_remove = mt7915_mac_sta_remove,
 		.update_survey = mt7915_update_channel,
 	};
+	struct mtk_wed_device *wed;
 	struct mt7915_dev *dev;
 	struct mt76_dev *mdev;
+	int irq;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -267,10 +310,6 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 
 	dev = container_of(mdev, struct mt7915_dev, mt76);
 
-	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
-	if (ret < 0)
-		goto free;
-
 	ret = mt7915_mmio_init(mdev, pcim_iomap_table(pdev)[0]);
 	if (ret)
 		goto error;
@@ -279,10 +318,30 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 
 	mt76_wr(dev, MT_INT_MASK_CSR, 0);
 
+	wed = &mdev->mmio.wed;
+	wed->wlan.pci_dev = pdev;
+	wed->wlan.wpdma_phys = pci_resource_start(pdev, 0) +
+			       MT_WFDMA_EXT_CSR_BASE;
+	wed->wlan.nbuf = 4096;
+	wed->wlan.token_start = MT7915_TOKEN_SIZE - wed->wlan.nbuf - 1;
+	wed->wlan.init_buf = mt7915_wed_init_buf;
+	wed->wlan.offload_enable = mt7915_wed_offload_enable;
+	wed->wlan.offload_disable = mt7915_wed_offload_disable;
+
+	if (mtk_wed_device_attach(wed) == 0) {
+		irq = wed->irq;
+	} else {
+		ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+		if (ret < 0)
+			goto free;
+
+		irq = pdev->irq;
+	}
+
 	/* master switch of PCIe tnterrupt enable */
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 
-	ret = devm_request_irq(mdev->dev, pdev->irq, mt7915_irq_handler,
+	ret = devm_request_irq(mdev->dev, irq, mt7915_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (ret)
 		goto error;
@@ -297,7 +356,10 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 free_irq:
 	devm_free_irq(mdev->dev, pdev->irq, dev);
 error:
-	pci_free_irq_vectors(pdev);
+	if (mtk_wed_device_active(wed))
+		mtk_wed_device_detach(wed);
+	else
+		pci_free_irq_vectors(pdev);
 free:
 	mt76_free_device(&dev->mt76);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index a213b5cb82f8..633a63bef433 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -334,7 +334,9 @@
 
 /* WFDMA CSR */
 #define MT_WFDMA_EXT_CSR_BASE		0xd7000
+#define MT_WFDMA_EXT_CSR_PHYS_BASE	0x18027000
 #define MT_WFDMA_EXT_CSR(ofs)		(MT_WFDMA_EXT_CSR_BASE + (ofs))
+#define MT_WFDMA_EXT_CSR_PHYS(ofs)	(MT_WFDMA_EXT_CSR_PHYS_BASE + (ofs))
 
 #define MT_INT_SOURCE_CSR		MT_WFDMA_EXT_CSR(0x10)
 #define MT_INT_MASK_CSR			MT_WFDMA_EXT_CSR(0x14)
@@ -359,19 +361,30 @@
 					 MT_INT_TX_DONE_MCU_WM |	\
 					 MT_INT_TX_DONE_FWDL)
 
-#define MT_WFDMA_HOST_CONFIG		MT_WFDMA_EXT_CSR(0x30)
+#define MT_WFDMA_HOST_CONFIG		MT_WFDMA_EXT_CSR_PHYS(0x30)
 #define MT_WFDMA_HOST_CONFIG_PDMA_BAND	BIT(0)
+#define MT_WFDMA_HOST_CONFIG_WED	BIT(1)
 
-#define MT_WFDMA_EXT_CSR_HIF_MISC	MT_WFDMA_EXT_CSR(0x44)
+#define MT_WFDMA_WED_RING_CONTROL	MT_WFDMA_EXT_CSR_PHYS(0x34)
+#define MT_WFDMA_WED_RING_CONTROL_TX0	GENMASK(4, 0)
+#define MT_WFDMA_WED_RING_CONTROL_TX1	GENMASK(12, 8)
+#define MT_WFDMA_WED_RING_CONTROL_RX1	GENMASK(20, 16)
+
+#define MT_WFDMA_EXT_CSR_HIF_MISC	MT_WFDMA_EXT_CSR_PHYS(0x44)
 #define MT_WFDMA_EXT_CSR_HIF_MISC_BUSY	BIT(0)
 
 #define MT_INT1_SOURCE_CSR		MT_WFDMA_EXT_CSR(0x88)
 #define MT_INT1_MASK_CSR		MT_WFDMA_EXT_CSR(0x8c)
 
-#define MT_PCIE_RECOG_ID		MT_WFDMA_EXT_CSR(0x90)
+#define MT_PCIE_RECOG_ID		MT_WFDMA_EXT_CSR_PHYS(0x90)
 #define MT_PCIE_RECOG_ID_MASK		GENMASK(30, 0)
 #define MT_PCIE_RECOG_ID_SEM		BIT(31)
 
+#define MT_INT_WED_MASK_CSR		MT_WFDMA_EXT_CSR(0x204)
+
+#define MT_WED_TX_RING_BASE		MT_WFDMA_EXT_CSR(0x300)
+#define MT_WED_RX_RING_BASE		MT_WFDMA_EXT_CSR(0x400)
+
 /* WFDMA0 PCIE1 */
 #define MT_WFDMA0_PCIE1_BASE			0xd8000
 #define MT_WFDMA0_PCIE1(ofs)			(MT_WFDMA0_PCIE1_BASE + (ofs))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index 7d7d43a5422f..b99be1cbb866 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -9,7 +9,7 @@ int mt7921_init_tx_queues(struct mt7921_phy *phy, int idx, int n_desc)
 {
 	int i, err;
 
-	err = mt76_init_tx_queue(phy->mt76, 0, idx, n_desc, MT_TX_RING_BASE);
+	err = mt76_init_tx_queue(phy->mt76, 0, idx, n_desc, MT_TX_RING_BASE, 0);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 9c6d26f4c795..86eb22711956 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -687,6 +687,7 @@ EXPORT_SYMBOL_GPL(__mt76_set_tx_blocked);
 
 int mt76_token_consume(struct mt76_dev *dev, struct mt76_txwi_cache **ptxwi)
 {
+	struct mtk_wed_device *wed = &dev->mmio.wed;
 	int token;
 
 	spin_lock_bh(&dev->token_lock);
@@ -695,6 +696,10 @@ int mt76_token_consume(struct mt76_dev *dev, struct mt76_txwi_cache **ptxwi)
 	if (token >= 0)
 		dev->token_count++;
 
+	if (mtk_wed_device_active(wed) &&
+	    token >= wed->wlan.token_start)
+		dev->wed_token_count++;
+
 	if (dev->token_count >= dev->token_size - MT76_TOKEN_FREE_THR)
 		__mt76_set_tx_blocked(dev, true);
 
@@ -707,14 +712,21 @@ EXPORT_SYMBOL_GPL(mt76_token_consume);
 struct mt76_txwi_cache *
 mt76_token_release(struct mt76_dev *dev, int token, bool *wake)
 {
+	struct mtk_wed_device *wed = &dev->mmio.wed;
 	struct mt76_txwi_cache *txwi;
 
 	spin_lock_bh(&dev->token_lock);
 
 	txwi = idr_remove(&dev->token, token);
-	if (txwi)
+	if (txwi) {
 		dev->token_count--;
 
+		if (mtk_wed_device_active(wed) &&
+		    token >= wed->wlan.token_start &&
+		    --dev->wed_token_count == 0)
+			wake_up(&dev->tx_wait);
+	}
+
 	if (dev->token_count < dev->token_size - MT76_TOKEN_FREE_THR &&
 	    dev->phy.q_tx[0]->blocked)
 		*wake = true;
-- 
2.30.1

