Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3ACA96C69
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbfHTWeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:34:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730971AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6xmEd+6Hcq8tCHf2bxbsh4w1bvWDerPajMW0hPvFl1E=; b=EgVApfMmIc6ZRfTrdjUTXqdN5F
        SrQu0CadGcp5jN6qiKniCqSOoCYQruRm1z803tme/zALp5/Voji85At/jwzKyYcuDc/E+CDZ09Dzc
        0DdC74VRfVRM1TPJRENmKyhs1ALAqnvxTEOQb8uLX2NbA2LgUEEbsPpxYEIQ8w0qkpKNZ264BeXgb
        51KGdeJaEiKhwpK33SH/z3zx7/4LWEIf5O7npSbJBhLYfkNY0vdKNHtbXUdI6NpRJDnrFgKT34Ve9
        hl+p5Fjw+8H9S5SwikZEKgLD5nM6e+jW/7rnBTE9u2HsnzpQgFNsXJj30/tIzVg3sEitH+Qywx7aV
        wSuThaKQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qZ-86; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 11/38] mt76: Convert token IDR to XArray
Date:   Tue, 20 Aug 2019 15:32:32 -0700
Message-Id: <20190820223259.22348-12-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Straightforward conversion; locking is similar.  It may be possible to
change the GFP_ATOMIC to GFP_KERNEL, but I can't tell whether this
context permits sleeping or not.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 .../net/wireless/mediatek/mt76/mt7615/init.c  | 11 ++++-----
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 24 +++++++++----------
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  4 ++--
 3 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 859de2454ec6..459ccb79c9cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -71,8 +71,7 @@ static int mt7615_init_hardware(struct mt7615_dev *dev)
 
 	mt76_wr(dev, MT_INT_SOURCE_CSR, ~0);
 
-	spin_lock_init(&dev->token_lock);
-	idr_init(&dev->token);
+	xa_init_flags(&dev->token, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_BH);
 
 	ret = mt7615_eeprom_init(dev);
 	if (ret < 0)
@@ -266,21 +265,19 @@ int mt7615_register_device(struct mt7615_dev *dev)
 void mt7615_unregister_device(struct mt7615_dev *dev)
 {
 	struct mt76_txwi_cache *txwi;
-	int id;
+	unsigned long id;
 
 	mt76_unregister_device(&dev->mt76);
 	mt7615_mcu_exit(dev);
 	mt7615_dma_cleanup(dev);
 
-	spin_lock_bh(&dev->token_lock);
-	idr_for_each_entry(&dev->token, txwi, id) {
+	xa_for_each(&dev->token, id, txwi) {
 		mt7615_txp_skb_unmap(&dev->mt76, txwi);
 		if (txwi->skb)
 			dev_kfree_skb_any(txwi->skb);
 		mt76_put_txwi(&dev->mt76, txwi);
 	}
-	spin_unlock_bh(&dev->token_lock);
-	idr_destroy(&dev->token);
+	xa_destroy(&dev->token);
 
 	mt76_free_device(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 1eb0e9c9970c..335fc3cdcb86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -238,9 +238,7 @@ void mt7615_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 		txp = (struct mt7615_txp *)(txwi_ptr + MT_TXD_SIZE);
 		dev = container_of(mdev, struct mt7615_dev, mt76);
 
-		spin_lock_bh(&dev->token_lock);
-		t = idr_remove(&dev->token, le16_to_cpu(txp->token));
-		spin_unlock_bh(&dev->token_lock);
+		t = xa_erase_bh(&dev->token, le16_to_cpu(txp->token));
 		e->skb = t ? t->skb : NULL;
 	}
 
@@ -457,7 +455,7 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_vif *vif = info->control.vif;
-	int i, pid, id, nbuf = tx_info->nbuf - 1;
+	int err, i, pid, id, nbuf = tx_info->nbuf - 1;
 	u8 *txwi = (u8 *)txwi_ptr;
 	struct mt76_txwi_cache *t;
 	struct mt7615_txp *txp;
@@ -506,13 +504,15 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	t = (struct mt76_txwi_cache *)(txwi + mdev->drv->txwi_size);
 	t->skb = tx_info->skb;
 
-	spin_lock_bh(&dev->token_lock);
-	id = idr_alloc(&dev->token, t, 0, MT7615_TOKEN_SIZE, GFP_ATOMIC);
-	spin_unlock_bh(&dev->token_lock);
-	if (id < 0)
-		return id;
+	xa_lock_bh(&dev->token);
+	err = __xa_alloc(&dev->token, &id, t,
+			XA_LIMIT(0, MT7615_TOKEN_SIZE - 1), GFP_ATOMIC);
+	if (!err)
+		txp->token = cpu_to_le16(id);
+	xa_unlock_bh(&dev->token);
+	if (err < 0)
+		return err;
 
-	txp->token = cpu_to_le16(id);
 	txp->rept_wds_wcid = 0xff;
 	tx_info->skb = DMA_DUMMY_DATA;
 
@@ -717,9 +717,7 @@ void mt7615_mac_tx_free(struct mt7615_dev *dev, struct sk_buff *skb)
 
 	count = FIELD_GET(MT_TX_FREE_MSDU_ID_CNT, le16_to_cpu(free->ctrl));
 	for (i = 0; i < count; i++) {
-		spin_lock_bh(&dev->token_lock);
-		txwi = idr_remove(&dev->token, le16_to_cpu(free->token[i]));
-		spin_unlock_bh(&dev->token_lock);
+		txwi = xa_erase_bh(&dev->token, le16_to_cpu(free->token[i]));
 
 		if (!txwi)
 			continue;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index f02ffcffe637..5a3ecc6faede 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -6,6 +6,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/ktime.h>
+#include <linux/xarray.h>
 #include "../mt76.h"
 #include "regs.h"
 
@@ -68,8 +69,7 @@ struct mt7615_dev {
 	u32 vif_mask;
 	u32 omac_mask;
 
-	spinlock_t token_lock;
-	struct idr token;
+	struct xarray token;
 };
 
 enum {
-- 
2.23.0.rc1

