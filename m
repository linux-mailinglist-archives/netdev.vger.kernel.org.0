Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE54B3BCD60
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhGFLVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233104AbhGFLUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 880EB61C50;
        Tue,  6 Jul 2021 11:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570228;
        bh=K4AOJIFpRTGYyamlo1wY6uqNsUfHfvpWx9teuCvboKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDrWBi3dkkH8hBdjLQULNh8+TNmAf3nSMA3Lwu/9GqIHd0OzZQnHnqOnMWqsuMIWG
         A4HeIXEnCVaKx/pNwz9zBo0lnSPGa26DHDW9RGTO5f7Bs6eSvURCKDF5tQc2FBw31M
         LQMwRV3DgY1/iOrlWiL9p7UE0UCnQa+Pz28mtS6sFWwfXskdbM/FbhOfIWKM7ik9hM
         BBRkpUfjF4Ks/r4vwlBwb7aAsYo4eNpmub49dW0TGRLft1H50DDPVzFXpW21/CcLje
         XXF7DhgO6wr5UhFCc/zEA7erk6TpXh0dZ0hnLVB8/zxD09PGuhl/3no/l/Rkc+Zi2d
         Zv2ga9gCQf9nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "Deren . Wu" <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 133/189] mt76: mt7921: enable hw offloading for wep keys
Date:   Tue,  6 Jul 2021 07:13:13 -0400
Message-Id: <20210706111409.2058071-133-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a60951d4faa0ef2e475797dd217c2eaee32ed1c2 ]

Enable wep key hw offloading for sta mode. This patch fixes
WoW support for wep connections.

Tested-by: Deren.Wu <deren.wu@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 22 ++++++++++++++-----
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 97a0ef331ac3..032122317855 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -429,6 +429,10 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
 		wcid_keyidx = &wcid->hw_key_idx2;
 		break;
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (!mvif->wep_sta)
+			return -EOPNOTSUPP;
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
@@ -436,8 +440,6 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case WLAN_CIPHER_SUITE_GCMP_256:
 	case WLAN_CIPHER_SUITE_SMS4:
 		break;
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -455,6 +457,12 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			    cmd == SET_KEY ? key : NULL);
 
 	err = mt7921_mcu_add_key(dev, vif, msta, key, cmd);
+	if (err)
+		goto out;
+
+	if (key->cipher == WLAN_CIPHER_SUITE_WEP104 ||
+	    key->cipher == WLAN_CIPHER_SUITE_WEP40)
+		err = mt7921_mcu_add_key(dev, vif, mvif->wep_sta, key, cmd);
 out:
 	mt7921_mutex_release(dev);
 
@@ -661,9 +669,12 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
-		mt76_connac_mcu_uni_add_bss(&dev->mphy, vif, &mvif->sta.wcid,
-					    true);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		mvif->wep_sta = msta;
+		if (!sta->tdls)
+			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
+						    &mvif->sta.wcid, true);
+	}
 
 	mt7921_mac_wtbl_update(dev, idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
@@ -693,6 +704,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 
+		mvif->wep_sta = NULL;
 		ewma_rssi_init(&mvif->rssi);
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 03bcb210c357..434601388a6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -100,6 +100,8 @@ struct mt7921_vif {
 	struct mt76_vif mt76; /* must be first */
 
 	struct mt7921_sta sta;
+	struct mt7921_sta *wep_sta;
+
 	struct mt7921_phy *phy;
 
 	struct ewma_rssi rssi;
-- 
2.30.2

