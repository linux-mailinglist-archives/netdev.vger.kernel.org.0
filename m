Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA82C323CFA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhBXNBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234772AbhBXM5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C9BD64F3C;
        Wed, 24 Feb 2021 12:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171143;
        bh=gOJ4KNBRe1gQ0EC8G3x8EkpMv27fqxU7e0yNcEZW3AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2O88S4+qn21cakRlKoitMcjaTFYP4WsM7eXWa+xZoquCr/VL4A3LCyW5MrmyyUE+
         ChA3KFIq8cZmjnKJhO4XPztkDRb6RSBu8Xo8U/lJWbSyZSfpp0g52zJjP02Xq8tgo7
         Im58/QDxGBw7bMPjlDvWhF7X7LuJSpUVFzQknTVaM8L2jSbPz71/7KXVRcyPfIo60J
         ZPcjiMPhgIvlZumb6hZQKWAxlp7P0ESnIJckiL7BUTYYDhsxYg9ZQXAOP/Jo5cLxcr
         r1yQInQNb0Mz3V5ZOEOrVP5zuff2de8ZZoareCjRCU8xYHlVdUKgOc5hVqPBkxy4Y/
         090KQLSJbhcpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 08/56] mt76: mt7615: reset token when mac_reset happens
Date:   Wed, 24 Feb 2021 07:51:24 -0500
Message-Id: <20210224125212.482485-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit a6275e934605646ef81b02d8d1164f21343149c9 ]

Reset token in mt7615_mac_reset_work() to avoid possible leakege.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 20 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  2 +-
 .../wireless/mediatek/mt76/mt7615/pci_init.c  | 12 +----------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 3d62fda067e44..f1f954ff46856 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2098,6 +2098,23 @@ void mt7615_dma_reset(struct mt7615_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt7615_dma_reset);
 
+void mt7615_tx_token_put(struct mt7615_dev *dev)
+{
+	struct mt76_txwi_cache *txwi;
+	int id;
+
+	spin_lock_bh(&dev->token_lock);
+	idr_for_each_entry(&dev->token, txwi, id) {
+		mt7615_txp_skb_unmap(&dev->mt76, txwi);
+		if (txwi->skb)
+			dev_kfree_skb_any(txwi->skb);
+		mt76_put_txwi(&dev->mt76, txwi);
+	}
+	spin_unlock_bh(&dev->token_lock);
+	idr_destroy(&dev->token);
+}
+EXPORT_SYMBOL_GPL(mt7615_tx_token_put);
+
 void mt7615_mac_reset_work(struct work_struct *work)
 {
 	struct mt7615_phy *phy2;
@@ -2141,6 +2158,9 @@ void mt7615_mac_reset_work(struct work_struct *work)
 
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_PDMA_STOPPED);
 
+	mt7615_tx_token_put(dev);
+	idr_init(&dev->token);
+
 	if (mt7615_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
 		mt7615_dma_reset(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 6a9f9187f76ac..5b06294d654aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -619,7 +619,7 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  struct mt76_tx_info *tx_info);
 
 void mt7615_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue_entry *e);
-
+void mt7615_tx_token_put(struct mt7615_dev *dev);
 void mt7615_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
 void mt7615_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index 06a0f8f7bc893..7b81aef3684ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -153,9 +153,7 @@ int mt7615_register_device(struct mt7615_dev *dev)
 
 void mt7615_unregister_device(struct mt7615_dev *dev)
 {
-	struct mt76_txwi_cache *txwi;
 	bool mcu_running;
-	int id;
 
 	mcu_running = mt7615_wait_for_mcu_init(dev);
 
@@ -165,15 +163,7 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 		mt7615_mcu_exit(dev);
 	mt7615_dma_cleanup(dev);
 
-	spin_lock_bh(&dev->token_lock);
-	idr_for_each_entry(&dev->token, txwi, id) {
-		mt7615_txp_skb_unmap(&dev->mt76, txwi);
-		if (txwi->skb)
-			dev_kfree_skb_any(txwi->skb);
-		mt76_put_txwi(&dev->mt76, txwi);
-	}
-	spin_unlock_bh(&dev->token_lock);
-	idr_destroy(&dev->token);
+	mt7615_tx_token_put(dev);
 
 	tasklet_disable(&dev->irq_tasklet);
 
-- 
2.27.0

