Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7575537426D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhEEQqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235684AbhEEQot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:44:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 694EB61920;
        Wed,  5 May 2021 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232527;
        bh=Kd7D8PFW+DSGc8biqFjBqL3PHkhfWns6Z/UBvsA9KEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdWMz8DTkBOC6pJuLeJZjK85Pgqe3MnRPtwfNVkdHutlqM9n1S7qc9I6+VZ4wjFB7
         hfrC3mH7eqoGWpwuIA4noFH3C63Y1U5DGj3BJ1SSIBQWjKGVQ6VT0F5JJu5+xlnG4S
         jeNosnmC2mkntUaKOrpHVO7oeCCCCSCVnECaMKG+7NzGkLbnlV8+wJuOGTahYDUdEM
         YuYh5CfvG00/H6lfWoeEDBF0WZu8YXcu3CdABrzj9nnAOnTZdTE/5euUi4OjV35ok6
         g1aHo1NBz1jC2aV5TDN5h2nZxgkzZ1eGv7783r7ZSMbwuIMyedwFCOByy0sdpClPbM
         S4cX5KaRQW1Yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 051/104] mt76: mt7615: fix key set/delete issues
Date:   Wed,  5 May 2021 12:33:20 -0400
Message-Id: <20210505163413.3461611-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 730d6d0da8d8f5905faafe645a5b3c08ac3f5a8f ]

There were multiple issues in the current key set/remove code:
- deleting a key with the previous key index deletes the current key
- BIP key would only be uploaded correctly initially and corrupted on rekey

Rework the code to better keep track of multiple keys and check for the
key index before deleting the current key

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 97 ++++++++++---------
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 18 ++--
 3 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 3e496a188bf0..deaeff3713f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -221,6 +221,7 @@ struct mt76_wcid {
 
 	u16 idx;
 	u8 hw_key_idx;
+	u8 hw_key_idx2;
 
 	u8 sta:1;
 	u8 ext_phy:1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index fb10a6497ed0..ea17bbeb10f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1031,7 +1031,7 @@ EXPORT_SYMBOL_GPL(mt7615_mac_set_rates);
 static int
 mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key,
-			   enum mt7615_cipher_type cipher,
+			   enum mt7615_cipher_type cipher, u16 cipher_mask,
 			   enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx) + 30 * 4;
@@ -1048,22 +1048,22 @@ mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			memcpy(data + 16, key->key + 24, 8);
 			memcpy(data + 24, key->key + 16, 8);
 		} else {
-			if (cipher != MT_CIPHER_BIP_CMAC_128 && wcid->cipher)
-				memmove(data + 16, data, 16);
-			if (cipher != MT_CIPHER_BIP_CMAC_128 || !wcid->cipher)
+			if (cipher_mask == BIT(cipher))
 				memcpy(data, key->key, key->keylen);
-			else if (cipher == MT_CIPHER_BIP_CMAC_128)
+			else if (cipher != MT_CIPHER_BIP_CMAC_128)
+				memcpy(data, key->key, 16);
+			if (cipher == MT_CIPHER_BIP_CMAC_128)
 				memcpy(data + 16, key->key, 16);
 		}
 	} else {
-		if (wcid->cipher & ~BIT(cipher)) {
-			if (cipher != MT_CIPHER_BIP_CMAC_128)
-				memmove(data, data + 16, 16);
+		if (cipher == MT_CIPHER_BIP_CMAC_128)
 			memset(data + 16, 0, 16);
-		} else {
+		else if (cipher_mask)
+			memset(data, 0, 16);
+		if (!cipher_mask)
 			memset(data, 0, sizeof(data));
-		}
 	}
+
 	mt76_wr_copy(dev, addr, data, sizeof(data));
 
 	return 0;
@@ -1071,7 +1071,7 @@ mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 static int
 mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			  enum mt7615_cipher_type cipher,
+			  enum mt7615_cipher_type cipher, u16 cipher_mask,
 			  int keyidx, enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx), w0, w1;
@@ -1081,20 +1081,23 @@ mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 	w0 = mt76_rr(dev, addr);
 	w1 = mt76_rr(dev, addr + 4);
-	if (cmd == SET_KEY) {
-		w0 |= MT_WTBL_W0_RX_KEY_VALID |
-		      FIELD_PREP(MT_WTBL_W0_RX_IK_VALID,
-				 cipher == MT_CIPHER_BIP_CMAC_128);
-		if (cipher != MT_CIPHER_BIP_CMAC_128 ||
-		    !wcid->cipher)
-			w0 |= FIELD_PREP(MT_WTBL_W0_KEY_IDX, keyidx);
-	}  else {
-		if (!(wcid->cipher & ~BIT(cipher)))
-			w0 &= ~(MT_WTBL_W0_RX_KEY_VALID |
-				MT_WTBL_W0_KEY_IDX);
-		if (cipher == MT_CIPHER_BIP_CMAC_128)
-			w0 &= ~MT_WTBL_W0_RX_IK_VALID;
+
+	if (cipher_mask)
+		w0 |= MT_WTBL_W0_RX_KEY_VALID;
+	else
+		w0 &= ~(MT_WTBL_W0_RX_KEY_VALID | MT_WTBL_W0_KEY_IDX);
+	if (cipher_mask & BIT(MT_CIPHER_BIP_CMAC_128))
+		w0 |= MT_WTBL_W0_RX_IK_VALID;
+	else
+		w0 &= ~MT_WTBL_W0_RX_IK_VALID;
+
+	if (cmd == SET_KEY &&
+	    (cipher != MT_CIPHER_BIP_CMAC_128 ||
+	     cipher_mask == BIT(cipher))) {
+		w0 &= ~MT_WTBL_W0_KEY_IDX;
+		w0 |= FIELD_PREP(MT_WTBL_W0_KEY_IDX, keyidx);
 	}
+
 	mt76_wr(dev, MT_WTBL_RICR0, w0);
 	mt76_wr(dev, MT_WTBL_RICR1, w1);
 
@@ -1107,24 +1110,25 @@ mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 static void
 mt7615_mac_wtbl_update_cipher(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			      enum mt7615_cipher_type cipher,
+			      enum mt7615_cipher_type cipher, u16 cipher_mask,
 			      enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx);
 
-	if (cmd == SET_KEY) {
-		if (cipher != MT_CIPHER_BIP_CMAC_128 || !wcid->cipher)
-			mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
-				 FIELD_PREP(MT_WTBL_W2_KEY_TYPE, cipher));
-	} else {
-		if (cipher != MT_CIPHER_BIP_CMAC_128 &&
-		    wcid->cipher & BIT(MT_CIPHER_BIP_CMAC_128))
-			mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
-				 FIELD_PREP(MT_WTBL_W2_KEY_TYPE,
-					    MT_CIPHER_BIP_CMAC_128));
-		else if (!(wcid->cipher & ~BIT(cipher)))
-			mt76_clear(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE);
+	if (!cipher_mask) {
+		mt76_clear(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE);
+		return;
 	}
+
+	if (cmd != SET_KEY)
+		return;
+
+	if (cipher == MT_CIPHER_BIP_CMAC_128 &&
+	    cipher_mask & ~BIT(MT_CIPHER_BIP_CMAC_128))
+		return;
+
+	mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
+		 FIELD_PREP(MT_WTBL_W2_KEY_TYPE, cipher));
 }
 
 int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
@@ -1133,25 +1137,30 @@ int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
 			      enum set_key_cmd cmd)
 {
 	enum mt7615_cipher_type cipher;
+	u16 cipher_mask = wcid->cipher;
 	int err;
 
 	cipher = mt7615_mac_get_cipher(key->cipher);
 	if (cipher == MT_CIPHER_NONE)
 		return -EOPNOTSUPP;
 
-	mt7615_mac_wtbl_update_cipher(dev, wcid, cipher, cmd);
-	err = mt7615_mac_wtbl_update_key(dev, wcid, key, cipher, cmd);
+	if (cmd == SET_KEY)
+		cipher_mask |= BIT(cipher);
+	else
+		cipher_mask &= ~BIT(cipher);
+
+	mt7615_mac_wtbl_update_cipher(dev, wcid, cipher, cipher_mask, cmd);
+	err = mt7615_mac_wtbl_update_key(dev, wcid, key, cipher, cipher_mask,
+					 cmd);
 	if (err < 0)
 		return err;
 
-	err = mt7615_mac_wtbl_update_pk(dev, wcid, cipher, key->keyidx, cmd);
+	err = mt7615_mac_wtbl_update_pk(dev, wcid, cipher, cipher_mask,
+					key->keyidx, cmd);
 	if (err < 0)
 		return err;
 
-	if (cmd == SET_KEY)
-		wcid->cipher |= BIT(cipher);
-	else
-		wcid->cipher &= ~BIT(cipher);
+	wcid->cipher = cipher_mask;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 56dd0b4e4460..7c631520e8f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -350,7 +350,8 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct mt7615_sta *msta = sta ? (struct mt7615_sta *)sta->drv_priv :
 				  &mvif->sta;
 	struct mt76_wcid *wcid = &msta->wcid;
-	int idx = key->keyidx, err;
+	int idx = key->keyidx, err = 0;
+	u8 *wcid_keyidx = &wcid->hw_key_idx;
 
 	/* The hardware does not support per-STA RX GTK, fallback
 	 * to software mode for these.
@@ -365,6 +366,7 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	/* fall back to sw encryption for unsupported ciphers */
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+		wcid_keyidx = &wcid->hw_key_idx2;
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -382,12 +384,13 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mt7615_mutex_acquire(dev);
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else if (idx == wcid->hw_key_idx) {
-		wcid->hw_key_idx = -1;
-	}
+	if (cmd == SET_KEY)
+		*wcid_keyidx = idx;
+	else if (idx == *wcid_keyidx)
+		*wcid_keyidx = -1;
+	else
+		goto out;
+
 	mt76_wcid_key_setup(&dev->mt76, wcid,
 			    cmd == SET_KEY ? key : NULL);
 
@@ -396,6 +399,7 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	else
 		err = __mt7615_mac_wtbl_set_key(dev, wcid, key, cmd);
 
+out:
 	mt7615_mutex_release(dev);
 
 	return err;
-- 
2.30.2

