Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA737414F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhEEQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:37:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhEEQe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7673D61424;
        Wed,  5 May 2021 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232373;
        bh=wxWoUpRdyXYh9izoGPXn5BkYGk3rIvTMA9JbMWgFAe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWpxNL+FEkiCkujFnQTDwS3UBdhqfXNhMGJWrS1WXGpYmgTpkSIDm37iAnBpnhgq8
         tKCaYS5Y7iql2HSKbx0Nio0Ob8JfcF2ssBValLQyZRMAXcj5vVex42dO6g/1Fj7pHu
         PJ/44Xs4CXhLflARSZy4sdaQNHM6VTEheG+iAELLhUAHa24wkSRskYGiHbMopgYIo/
         d8RIWl/zDfqOvn2fHPNTdhkTzCqv37N83ZafXBgw1wGJvsExBMuOMKWoGrP2/RzTK9
         +6FlpMa0xwoBiOzO24+QrdEVgtrsBSreHsncvqXUnHnHvkdwwAE26FdKugM9v/yIEj
         lwQhOCffII88Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 063/116] mt76: mt7921: fix key set/delete issue
Date:   Wed,  5 May 2021 12:30:31 -0400
Message-Id: <20210505163125.3460440-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 60468f7fd7072c804b2613f1cadabace8d77d311 ]

Similar to the mt7915 driver, deleting a key with the previous key index
deletes the current key. Rework the code to better keep track of
multiple keys and check for the key index before deleting the current
key

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 729f6c42cdde..672192e53269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -413,7 +413,8 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct mt7921_sta *msta = sta ? (struct mt7921_sta *)sta->drv_priv :
 				  &mvif->sta;
 	struct mt76_wcid *wcid = &msta->wcid;
-	int idx = key->keyidx;
+	u8 *wcid_keyidx = &wcid->hw_key_idx;
+	int idx = key->keyidx, err = 0;
 
 	/* The hardware does not support per-STA RX GTK, fallback
 	 * to software mode for these.
@@ -429,6 +430,7 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
+		wcid_keyidx = &wcid->hw_key_idx2;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
@@ -443,16 +445,23 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else if (idx == wcid->hw_key_idx) {
-		wcid->hw_key_idx = -1;
-	}
+	mt7921_mutex_acquire(dev);
+
+	if (cmd == SET_KEY)
+		*wcid_keyidx = idx;
+	else if (idx == *wcid_keyidx)
+		*wcid_keyidx = -1;
+	else
+		goto out;
+
 	mt76_wcid_key_setup(&dev->mt76, wcid,
 			    cmd == SET_KEY ? key : NULL);
 
-	return mt7921_mcu_add_key(dev, vif, msta, key, cmd);
+	err = mt7921_mcu_add_key(dev, vif, msta, key, cmd);
+out:
+	mt7921_mutex_release(dev);
+
+	return err;
 }
 
 static int mt7921_config(struct ieee80211_hw *hw, u32 changed)
-- 
2.30.2

