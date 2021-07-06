Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BD33BD045
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhGFLdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235325AbhGFL3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51BD461DA2;
        Tue,  6 Jul 2021 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570456;
        bh=M+rdZuBTSdiNjmTjacg63Tuh3FmubYMkaMqPHhBvxbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzmT+5nK31Ln6QbFb18XPTTI6IkiNFLlWLmExGEMXEyywLSrwXsiI64FI+KAfNDw7
         iBSp4C0Srru8IjJeziOUk51FqQC4Hyr7vC18Pf8AFewVwjjZ1COLXu+3DBFDnJUY39
         pokv3cthHwysyLd8hdBydw1/YnIEUgHKoTWuKBZ7tRar40BrQ5DbdaqZxviIFiIlV2
         Vtm0afk3n8fJYQZu3NcV/bmGhhQsQX+aG8yHg2Qg1Xn64mUmNF+GmHuAZFcMZ2X83m
         /4Tvg3nsq7XRXj7cjSRT2np+BOll+KXdE2G3V7B8kmfamSXbafxq3F6mW808Bh22mL
         qIaqkOeImqxeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryder Lee <ryder.lee@mediatek.com>,
        Xing Song <xing.song@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 111/160] mt76: fix iv and CCMP header insertion
Date:   Tue,  6 Jul 2021 07:17:37 -0400
Message-Id: <20210706111827.2060499-111-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit c368362c36d3d4cedbc9a1c9caa95960912cc429 ]

The iv from RXD is only for TKIP_RSC/CCMP_PN/GCMP_PN, and it needs a
check for CCMP header insertion. Move mt76_cipher_type to mt76.h to
reduce duplicated code.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     | 16 +++++
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 33 +++++++---
 .../net/wireless/mediatek/mt76/mt7603/regs.h  | 12 ----
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 64 +++++++++++++++----
 .../net/wireless/mediatek/mt76/mt7615/mac.h   | 42 ------------
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 28 ++++----
 .../net/wireless/mediatek/mt76/mt76x02_regs.h | 18 +++---
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 29 ++++++---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 30 ++++-----
 .../net/wireless/mediatek/mt76/mt7915/mcu.h   | 23 ++++---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 29 ++++++---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 30 ++++-----
 .../net/wireless/mediatek/mt76/mt7921/mcu.h   | 23 ++++---
 13 files changed, 208 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 36a430f09f64..38abeb273e3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -85,6 +85,22 @@ enum mt76_rxq_id {
 	__MT_RXQ_MAX
 };
 
+enum mt76_cipher_type {
+	MT_CIPHER_NONE,
+	MT_CIPHER_WEP40,
+	MT_CIPHER_TKIP,
+	MT_CIPHER_TKIP_NO_MIC,
+	MT_CIPHER_AES_CCMP,
+	MT_CIPHER_WEP104,
+	MT_CIPHER_BIP_CMAC_128,
+	MT_CIPHER_WEP128,
+	MT_CIPHER_WAPI,
+	MT_CIPHER_CCMP_CCX,
+	MT_CIPHER_CCMP_256,
+	MT_CIPHER_GCMP,
+	MT_CIPHER_GCMP_256,
+};
+
 struct mt76_queue_buf {
 	dma_addr_t addr;
 	u16 len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index cc4e7bc48294..92a7b45fbc15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -564,14 +564,27 @@ mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
 		u8 *data = (u8 *)rxd;
 
 		if (status->flag & RX_FLAG_DECRYPTED) {
-			status->iv[0] = data[5];
-			status->iv[1] = data[4];
-			status->iv[2] = data[3];
-			status->iv[3] = data[2];
-			status->iv[4] = data[1];
-			status->iv[5] = data[0];
-
-			insert_ccmp_hdr = FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+			switch (FIELD_GET(MT_RXD2_NORMAL_SEC_MODE, rxd2)) {
+			case MT_CIPHER_AES_CCMP:
+			case MT_CIPHER_CCMP_CCX:
+			case MT_CIPHER_CCMP_256:
+				insert_ccmp_hdr =
+					FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+				fallthrough;
+			case MT_CIPHER_TKIP:
+			case MT_CIPHER_TKIP_NO_MIC:
+			case MT_CIPHER_GCMP:
+			case MT_CIPHER_GCMP_256:
+				status->iv[0] = data[5];
+				status->iv[1] = data[4];
+				status->iv[2] = data[3];
+				status->iv[3] = data[2];
+				status->iv[4] = data[1];
+				status->iv[5] = data[0];
+				break;
+			default:
+				break;
+			}
 		}
 
 		rxd += 4;
@@ -828,7 +841,7 @@ void mt7603_wtbl_set_rates(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	sta->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 }
 
-static enum mt7603_cipher_type
+static enum mt76_cipher_type
 mt7603_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 {
 	memset(key_data, 0, 32);
@@ -860,7 +873,7 @@ mt7603_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
 			struct ieee80211_key_conf *key)
 {
-	enum mt7603_cipher_type cipher;
+	enum mt76_cipher_type cipher;
 	u32 addr = mt7603_wtbl3_addr(wcid);
 	u8 key_data[32];
 	int key_len = sizeof(key_data);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
index 6741e6907194..3b901090b29c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
@@ -765,16 +765,4 @@ enum {
 #define MT_WTBL1_OR			(MT_WTBL1_BASE + 0x2300)
 #define MT_WTBL1_OR_PSM_WRITE		BIT(31)
 
-enum mt7603_cipher_type {
-	MT_CIPHER_NONE,
-	MT_CIPHER_WEP40,
-	MT_CIPHER_TKIP,
-	MT_CIPHER_TKIP_NO_MIC,
-	MT_CIPHER_AES_CCMP,
-	MT_CIPHER_WEP104,
-	MT_CIPHER_BIP_CMAC_128,
-	MT_CIPHER_WEP128,
-	MT_CIPHER_WAPI,
-};
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 5a63869193f2..b5a9ca53bbe7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -57,6 +57,33 @@ static const struct mt7615_dfs_radar_spec jp_radar_specs = {
 	},
 };
 
+static enum mt76_cipher_type
+mt7615_mac_get_cipher(int cipher)
+{
+	switch (cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		return MT_CIPHER_WEP40;
+	case WLAN_CIPHER_SUITE_WEP104:
+		return MT_CIPHER_WEP104;
+	case WLAN_CIPHER_SUITE_TKIP:
+		return MT_CIPHER_TKIP;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		return MT_CIPHER_BIP_CMAC_128;
+	case WLAN_CIPHER_SUITE_CCMP:
+		return MT_CIPHER_AES_CCMP;
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		return MT_CIPHER_CCMP_256;
+	case WLAN_CIPHER_SUITE_GCMP:
+		return MT_CIPHER_GCMP;
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		return MT_CIPHER_GCMP_256;
+	case WLAN_CIPHER_SUITE_SMS4:
+		return MT_CIPHER_WAPI;
+	default:
+		return MT_CIPHER_NONE;
+	}
+}
+
 static struct mt76_wcid *mt7615_rx_get_wcid(struct mt7615_dev *dev,
 					    u8 idx, bool unicast)
 {
@@ -297,14 +324,27 @@ static int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
 		u8 *data = (u8 *)rxd;
 
 		if (status->flag & RX_FLAG_DECRYPTED) {
-			status->iv[0] = data[5];
-			status->iv[1] = data[4];
-			status->iv[2] = data[3];
-			status->iv[3] = data[2];
-			status->iv[4] = data[1];
-			status->iv[5] = data[0];
-
-			insert_ccmp_hdr = FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+			switch (FIELD_GET(MT_RXD2_NORMAL_SEC_MODE, rxd2)) {
+			case MT_CIPHER_AES_CCMP:
+			case MT_CIPHER_CCMP_CCX:
+			case MT_CIPHER_CCMP_256:
+				insert_ccmp_hdr =
+					FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+				fallthrough;
+			case MT_CIPHER_TKIP:
+			case MT_CIPHER_TKIP_NO_MIC:
+			case MT_CIPHER_GCMP:
+			case MT_CIPHER_GCMP_256:
+				status->iv[0] = data[5];
+				status->iv[1] = data[4];
+				status->iv[2] = data[3];
+				status->iv[3] = data[2];
+				status->iv[4] = data[1];
+				status->iv[5] = data[0];
+				break;
+			default:
+				break;
+			}
 		}
 		rxd += 4;
 		if ((u8 *)rxd - skb->data >= skb->len)
@@ -1037,7 +1077,7 @@ EXPORT_SYMBOL_GPL(mt7615_mac_set_rates);
 static int
 mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key,
-			   enum mt7615_cipher_type cipher, u16 cipher_mask,
+			   enum mt76_cipher_type cipher, u16 cipher_mask,
 			   enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx) + 30 * 4;
@@ -1077,7 +1117,7 @@ mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 static int
 mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			  enum mt7615_cipher_type cipher, u16 cipher_mask,
+			  enum mt76_cipher_type cipher, u16 cipher_mask,
 			  int keyidx, enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx), w0, w1;
@@ -1116,7 +1156,7 @@ mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 static void
 mt7615_mac_wtbl_update_cipher(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			      enum mt7615_cipher_type cipher, u16 cipher_mask,
+			      enum mt76_cipher_type cipher, u16 cipher_mask,
 			      enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx);
@@ -1142,7 +1182,7 @@ int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
 			      struct ieee80211_key_conf *key,
 			      enum set_key_cmd cmd)
 {
-	enum mt7615_cipher_type cipher;
+	enum mt76_cipher_type cipher;
 	u16 cipher_mask = wcid->cipher;
 	int err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
index 169f4e17b5b4..1fb07799671b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
@@ -375,48 +375,6 @@ struct mt7615_dfs_radar_spec {
 	struct mt7615_dfs_pattern radar_pattern[16];
 };
 
-enum mt7615_cipher_type {
-	MT_CIPHER_NONE,
-	MT_CIPHER_WEP40,
-	MT_CIPHER_TKIP,
-	MT_CIPHER_TKIP_NO_MIC,
-	MT_CIPHER_AES_CCMP,
-	MT_CIPHER_WEP104,
-	MT_CIPHER_BIP_CMAC_128,
-	MT_CIPHER_WEP128,
-	MT_CIPHER_WAPI,
-	MT_CIPHER_CCMP_256 = 10,
-	MT_CIPHER_GCMP,
-	MT_CIPHER_GCMP_256,
-};
-
-static inline enum mt7615_cipher_type
-mt7615_mac_get_cipher(int cipher)
-{
-	switch (cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-		return MT_CIPHER_WEP40;
-	case WLAN_CIPHER_SUITE_WEP104:
-		return MT_CIPHER_WEP104;
-	case WLAN_CIPHER_SUITE_TKIP:
-		return MT_CIPHER_TKIP;
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-		return MT_CIPHER_BIP_CMAC_128;
-	case WLAN_CIPHER_SUITE_CCMP:
-		return MT_CIPHER_AES_CCMP;
-	case WLAN_CIPHER_SUITE_CCMP_256:
-		return MT_CIPHER_CCMP_256;
-	case WLAN_CIPHER_SUITE_GCMP:
-		return MT_CIPHER_GCMP;
-	case WLAN_CIPHER_SUITE_GCMP_256:
-		return MT_CIPHER_GCMP_256;
-	case WLAN_CIPHER_SUITE_SMS4:
-		return MT_CIPHER_WAPI;
-	default:
-		return MT_CIPHER_NONE;
-	}
-}
-
 static inline struct mt7615_txp_common *
 mt7615_txwi_to_txp(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 771bad60e1bc..b21edc8e86e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -34,24 +34,24 @@ mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 {
 	memset(key_data, 0, 32);
 	if (!key)
-		return MT_CIPHER_NONE;
+		return MT76X02_CIPHER_NONE;
 
 	if (key->keylen > 32)
-		return MT_CIPHER_NONE;
+		return MT76X02_CIPHER_NONE;
 
 	memcpy(key_data, key->key, key->keylen);
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-		return MT_CIPHER_WEP40;
+		return MT76X02_CIPHER_WEP40;
 	case WLAN_CIPHER_SUITE_WEP104:
-		return MT_CIPHER_WEP104;
+		return MT76X02_CIPHER_WEP104;
 	case WLAN_CIPHER_SUITE_TKIP:
-		return MT_CIPHER_TKIP;
+		return MT76X02_CIPHER_TKIP;
 	case WLAN_CIPHER_SUITE_CCMP:
-		return MT_CIPHER_AES_CCMP;
+		return MT76X02_CIPHER_AES_CCMP;
 	default:
-		return MT_CIPHER_NONE;
+		return MT76X02_CIPHER_NONE;
 	}
 }
 
@@ -63,7 +63,7 @@ int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 	u32 val;
 
 	cipher = mt76x02_mac_get_key_info(key, key_data);
-	if (cipher == MT_CIPHER_NONE && key)
+	if (cipher == MT76X02_CIPHER_NONE && key)
 		return -EOPNOTSUPP;
 
 	val = mt76_rr(dev, MT_SKEY_MODE(vif_idx));
@@ -91,10 +91,10 @@ void mt76x02_mac_wcid_sync_pn(struct mt76x02_dev *dev, u8 idx,
 	eiv = mt76_rr(dev, MT_WCID_IV(idx) + 4);
 
 	pn = (u64)eiv << 16;
-	if (cipher == MT_CIPHER_TKIP) {
+	if (cipher == MT76X02_CIPHER_TKIP) {
 		pn |= (iv >> 16) & 0xff;
 		pn |= (iv & 0xff) << 8;
-	} else if (cipher >= MT_CIPHER_AES_CCMP) {
+	} else if (cipher >= MT76X02_CIPHER_AES_CCMP) {
 		pn |= iv & 0xffff;
 	} else {
 		return;
@@ -112,7 +112,7 @@ int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 	u64 pn;
 
 	cipher = mt76x02_mac_get_key_info(key, key_data);
-	if (cipher == MT_CIPHER_NONE && key)
+	if (cipher == MT76X02_CIPHER_NONE && key)
 		return -EOPNOTSUPP;
 
 	mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
@@ -126,16 +126,16 @@ int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 		pn = atomic64_read(&key->tx_pn);
 
 		iv_data[3] = key->keyidx << 6;
-		if (cipher >= MT_CIPHER_TKIP) {
+		if (cipher >= MT76X02_CIPHER_TKIP) {
 			iv_data[3] |= 0x20;
 			put_unaligned_le32(pn >> 16, &iv_data[4]);
 		}
 
-		if (cipher == MT_CIPHER_TKIP) {
+		if (cipher == MT76X02_CIPHER_TKIP) {
 			iv_data[0] = (pn >> 8) & 0xff;
 			iv_data[1] = (iv_data[0] | 0x20) & 0x7f;
 			iv_data[2] = pn & 0xff;
-		} else if (cipher >= MT_CIPHER_AES_CCMP) {
+		} else if (cipher >= MT76X02_CIPHER_AES_CCMP) {
 			put_unaligned_le16((pn & 0xffff), &iv_data[0]);
 		}
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index 3e722276b5c2..fa7872ac22bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -692,15 +692,15 @@ struct mt76_wcid_key {
 } __packed __aligned(4);
 
 enum mt76x02_cipher_type {
-	MT_CIPHER_NONE,
-	MT_CIPHER_WEP40,
-	MT_CIPHER_WEP104,
-	MT_CIPHER_TKIP,
-	MT_CIPHER_AES_CCMP,
-	MT_CIPHER_CKIP40,
-	MT_CIPHER_CKIP104,
-	MT_CIPHER_CKIP128,
-	MT_CIPHER_WAPI,
+	MT76X02_CIPHER_NONE,
+	MT76X02_CIPHER_WEP40,
+	MT76X02_CIPHER_WEP104,
+	MT76X02_CIPHER_TKIP,
+	MT76X02_CIPHER_AES_CCMP,
+	MT76X02_CIPHER_CKIP40,
+	MT76X02_CIPHER_CKIP104,
+	MT76X02_CIPHER_CKIP128,
+	MT76X02_CIPHER_WAPI,
 };
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 819670767521..be40b0777517 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -404,14 +404,27 @@ int mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 		u8 *data = (u8 *)rxd;
 
 		if (status->flag & RX_FLAG_DECRYPTED) {
-			status->iv[0] = data[5];
-			status->iv[1] = data[4];
-			status->iv[2] = data[3];
-			status->iv[3] = data[2];
-			status->iv[4] = data[1];
-			status->iv[5] = data[0];
-
-			insert_ccmp_hdr = FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+			switch (FIELD_GET(MT_RXD1_NORMAL_SEC_MODE, rxd1)) {
+			case MT_CIPHER_AES_CCMP:
+			case MT_CIPHER_CCMP_CCX:
+			case MT_CIPHER_CCMP_256:
+				insert_ccmp_hdr =
+					FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+				fallthrough;
+			case MT_CIPHER_TKIP:
+			case MT_CIPHER_TKIP_NO_MIC:
+			case MT_CIPHER_GCMP:
+			case MT_CIPHER_GCMP_256:
+				status->iv[0] = data[5];
+				status->iv[1] = data[4];
+				status->iv[2] = data[3];
+				status->iv[3] = data[2];
+				status->iv[4] = data[1];
+				status->iv[5] = data[0];
+				break;
+			default:
+				break;
+			}
 		}
 		rxd += 4;
 		if ((u8 *)rxd - skb->data >= skb->len)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index f069a5a03e14..22c791b084ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -88,28 +88,28 @@ struct mt7915_fw_region {
 #define HE_PHY(p, c)			u8_get_bits(c, IEEE80211_HE_PHY_##p)
 #define HE_MAC(m, c)			u8_get_bits(c, IEEE80211_HE_MAC_##m)
 
-static enum mt7915_cipher_type
+static enum mcu_cipher_type
 mt7915_mcu_get_cipher(int cipher)
 {
 	switch (cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-		return MT_CIPHER_WEP40;
+		return MCU_CIPHER_WEP40;
 	case WLAN_CIPHER_SUITE_WEP104:
-		return MT_CIPHER_WEP104;
+		return MCU_CIPHER_WEP104;
 	case WLAN_CIPHER_SUITE_TKIP:
-		return MT_CIPHER_TKIP;
+		return MCU_CIPHER_TKIP;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		return MT_CIPHER_BIP_CMAC_128;
+		return MCU_CIPHER_BIP_CMAC_128;
 	case WLAN_CIPHER_SUITE_CCMP:
-		return MT_CIPHER_AES_CCMP;
+		return MCU_CIPHER_AES_CCMP;
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		return MT_CIPHER_CCMP_256;
+		return MCU_CIPHER_CCMP_256;
 	case WLAN_CIPHER_SUITE_GCMP:
-		return MT_CIPHER_GCMP;
+		return MCU_CIPHER_GCMP;
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		return MT_CIPHER_GCMP_256;
+		return MCU_CIPHER_GCMP_256;
 	case WLAN_CIPHER_SUITE_SMS4:
-		return MT_CIPHER_WAPI;
+		return MCU_CIPHER_WAPI;
 	default:
 		return MT_CIPHER_NONE;
 	}
@@ -1060,14 +1060,14 @@ mt7915_mcu_sta_key_tlv(struct mt7915_sta *msta, struct sk_buff *skb,
 		sec_key = &sec->key[0];
 		sec_key->cipher_len = sizeof(*sec_key);
 
-		if (cipher == MT_CIPHER_BIP_CMAC_128) {
-			sec_key->cipher_id = MT_CIPHER_AES_CCMP;
+		if (cipher == MCU_CIPHER_BIP_CMAC_128) {
+			sec_key->cipher_id = MCU_CIPHER_AES_CCMP;
 			sec_key->key_id = bip->keyidx;
 			sec_key->key_len = 16;
 			memcpy(sec_key->key, bip->key, 16);
 
 			sec_key = &sec->key[1];
-			sec_key->cipher_id = MT_CIPHER_BIP_CMAC_128;
+			sec_key->cipher_id = MCU_CIPHER_BIP_CMAC_128;
 			sec_key->cipher_len = sizeof(*sec_key);
 			sec_key->key_len = 16;
 			memcpy(sec_key->key, key->key, 16);
@@ -1079,14 +1079,14 @@ mt7915_mcu_sta_key_tlv(struct mt7915_sta *msta, struct sk_buff *skb,
 			sec_key->key_len = key->keylen;
 			memcpy(sec_key->key, key->key, key->keylen);
 
-			if (cipher == MT_CIPHER_TKIP) {
+			if (cipher == MCU_CIPHER_TKIP) {
 				/* Rx/Tx MIC keys are swapped */
 				memcpy(sec_key->key + 16, key->key + 24, 8);
 				memcpy(sec_key->key + 24, key->key + 16, 8);
 			}
 
 			/* store key_conf for BIP batch update */
-			if (cipher == MT_CIPHER_AES_CCMP) {
+			if (cipher == MCU_CIPHER_AES_CCMP) {
 				memcpy(bip->key, key->key, key->keylen);
 				bip->keyidx = key->keyidx;
 			}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index 2d584142c27b..1a865ef81a43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -1023,18 +1023,17 @@ enum {
 	STA_REC_MAX_NUM
 };
 
-enum mt7915_cipher_type {
-	MT_CIPHER_NONE,
-	MT_CIPHER_WEP40,
-	MT_CIPHER_WEP104,
-	MT_CIPHER_WEP128,
-	MT_CIPHER_TKIP,
-	MT_CIPHER_AES_CCMP,
-	MT_CIPHER_CCMP_256,
-	MT_CIPHER_GCMP,
-	MT_CIPHER_GCMP_256,
-	MT_CIPHER_WAPI,
-	MT_CIPHER_BIP_CMAC_128,
+enum mcu_cipher_type {
+	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_WEP104,
+	MCU_CIPHER_WEP128,
+	MCU_CIPHER_TKIP,
+	MCU_CIPHER_AES_CCMP,
+	MCU_CIPHER_CCMP_256,
+	MCU_CIPHER_GCMP,
+	MCU_CIPHER_GCMP_256,
+	MCU_CIPHER_WAPI,
+	MCU_CIPHER_BIP_CMAC_128,
 };
 
 enum {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index a6d2a25b3495..fa135d8a972e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -378,14 +378,27 @@ int mt7921_mac_fill_rx(struct mt7921_dev *dev, struct sk_buff *skb)
 		u8 *data = (u8 *)rxd;
 
 		if (status->flag & RX_FLAG_DECRYPTED) {
-			status->iv[0] = data[5];
-			status->iv[1] = data[4];
-			status->iv[2] = data[3];
-			status->iv[3] = data[2];
-			status->iv[4] = data[1];
-			status->iv[5] = data[0];
-
-			insert_ccmp_hdr = FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+			switch (FIELD_GET(MT_RXD1_NORMAL_SEC_MODE, rxd1)) {
+			case MT_CIPHER_AES_CCMP:
+			case MT_CIPHER_CCMP_CCX:
+			case MT_CIPHER_CCMP_256:
+				insert_ccmp_hdr =
+					FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+				fallthrough;
+			case MT_CIPHER_TKIP:
+			case MT_CIPHER_TKIP_NO_MIC:
+			case MT_CIPHER_GCMP:
+			case MT_CIPHER_GCMP_256:
+				status->iv[0] = data[5];
+				status->iv[1] = data[4];
+				status->iv[2] = data[3];
+				status->iv[3] = data[2];
+				status->iv[4] = data[1];
+				status->iv[5] = data[0];
+				break;
+			default:
+				break;
+			}
 		}
 		rxd += 4;
 		if ((u8 *)rxd - skb->data >= skb->len)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index be88c9f5637a..ee4875765f85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -87,28 +87,28 @@ struct mt7921_fw_region {
 #define to_wcid_lo(id)			FIELD_GET(GENMASK(7, 0), (u16)id)
 #define to_wcid_hi(id)			FIELD_GET(GENMASK(9, 8), (u16)id)
 
-static enum mt7921_cipher_type
+static enum mcu_cipher_type
 mt7921_mcu_get_cipher(int cipher)
 {
 	switch (cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
-		return MT_CIPHER_WEP40;
+		return MCU_CIPHER_WEP40;
 	case WLAN_CIPHER_SUITE_WEP104:
-		return MT_CIPHER_WEP104;
+		return MCU_CIPHER_WEP104;
 	case WLAN_CIPHER_SUITE_TKIP:
-		return MT_CIPHER_TKIP;
+		return MCU_CIPHER_TKIP;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-		return MT_CIPHER_BIP_CMAC_128;
+		return MCU_CIPHER_BIP_CMAC_128;
 	case WLAN_CIPHER_SUITE_CCMP:
-		return MT_CIPHER_AES_CCMP;
+		return MCU_CIPHER_AES_CCMP;
 	case WLAN_CIPHER_SUITE_CCMP_256:
-		return MT_CIPHER_CCMP_256;
+		return MCU_CIPHER_CCMP_256;
 	case WLAN_CIPHER_SUITE_GCMP:
-		return MT_CIPHER_GCMP;
+		return MCU_CIPHER_GCMP;
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		return MT_CIPHER_GCMP_256;
+		return MCU_CIPHER_GCMP_256;
 	case WLAN_CIPHER_SUITE_SMS4:
-		return MT_CIPHER_WAPI;
+		return MCU_CIPHER_WAPI;
 	default:
 		return MT_CIPHER_NONE;
 	}
@@ -577,14 +577,14 @@ mt7921_mcu_sta_key_tlv(struct mt7921_sta *msta, struct sk_buff *skb,
 		sec_key = &sec->key[0];
 		sec_key->cipher_len = sizeof(*sec_key);
 
-		if (cipher == MT_CIPHER_BIP_CMAC_128) {
-			sec_key->cipher_id = MT_CIPHER_AES_CCMP;
+		if (cipher == MCU_CIPHER_BIP_CMAC_128) {
+			sec_key->cipher_id = MCU_CIPHER_AES_CCMP;
 			sec_key->key_id = bip->keyidx;
 			sec_key->key_len = 16;
 			memcpy(sec_key->key, bip->key, 16);
 
 			sec_key = &sec->key[1];
-			sec_key->cipher_id = MT_CIPHER_BIP_CMAC_128;
+			sec_key->cipher_id = MCU_CIPHER_BIP_CMAC_128;
 			sec_key->cipher_len = sizeof(*sec_key);
 			sec_key->key_len = 16;
 			memcpy(sec_key->key, key->key, 16);
@@ -596,14 +596,14 @@ mt7921_mcu_sta_key_tlv(struct mt7921_sta *msta, struct sk_buff *skb,
 			sec_key->key_len = key->keylen;
 			memcpy(sec_key->key, key->key, key->keylen);
 
-			if (cipher == MT_CIPHER_TKIP) {
+			if (cipher == MCU_CIPHER_TKIP) {
 				/* Rx/Tx MIC keys are swapped */
 				memcpy(sec_key->key + 16, key->key + 24, 8);
 				memcpy(sec_key->key + 24, key->key + 16, 8);
 			}
 
 			/* store key_conf for BIP batch update */
-			if (cipher == MT_CIPHER_AES_CCMP) {
+			if (cipher == MCU_CIPHER_AES_CCMP) {
 				memcpy(bip->key, key->key, key->keylen);
 				bip->keyidx = key->keyidx;
 			}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
index 2fdc62367b3f..4028c667bd68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
@@ -214,18 +214,17 @@ struct sta_rec_sec {
 	struct sec_key key[2];
 } __packed;
 
-enum mt7921_cipher_type {
-	MT_CIPHER_NONE,
-	MT_CIPHER_WEP40,
-	MT_CIPHER_WEP104,
-	MT_CIPHER_WEP128,
-	MT_CIPHER_TKIP,
-	MT_CIPHER_AES_CCMP,
-	MT_CIPHER_CCMP_256,
-	MT_CIPHER_GCMP,
-	MT_CIPHER_GCMP_256,
-	MT_CIPHER_WAPI,
-	MT_CIPHER_BIP_CMAC_128,
+enum mcu_cipher_type {
+	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_WEP104,
+	MCU_CIPHER_WEP128,
+	MCU_CIPHER_TKIP,
+	MCU_CIPHER_AES_CCMP,
+	MCU_CIPHER_CCMP_256,
+	MCU_CIPHER_GCMP,
+	MCU_CIPHER_GCMP_256,
+	MCU_CIPHER_WAPI,
+	MCU_CIPHER_BIP_CMAC_128,
 };
 
 enum {
-- 
2.30.2

