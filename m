Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794BD128A4
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfECHWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:22:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40995 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfECHWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 03:22:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id 188so2451530pfd.8
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 00:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+K/EPrRwJYA/6OJXirOV4eTRe2XFeDDtoM1Pl8CCtSU=;
        b=h5hDb+TuN+4GP3QgCwbIt3yGPCBrN1CfD/xeB3WDEDH5O1Y9HxEsgS0t2wzOxj02DL
         9wd/Ko3mux8myOpEFeIMXcfMXKPPGpEK5rFp0KaDEMZl4gSsYzLRyjKz3k419INZ0S98
         zshKNlDxRT37h986qpQ06z9wrvIpYRPWvI+FiQZ9zV5cv6GbJBSOm2UCDN4EaGaKaJL8
         /KvWuTIqYWo3FkFSnb1cSHV8J7eOPtSC5enQFGjSH09N7Q/FD6JLhmLDLK1QqvJrWHUi
         fwjr4rGNqi01HHW4R0qbUHwQGminiOkISvfX6FTVanfBvbfl5d+53q6yXNG7p7wnBOY5
         0i7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+K/EPrRwJYA/6OJXirOV4eTRe2XFeDDtoM1Pl8CCtSU=;
        b=YaE4qGLxWvxg3isHbJw0XuUIdD/ddLoK2sGRLg0I6u2BrlJX5qguUnTKGasT2Y2Koq
         iK7z07mCkRzGrMA86FP8nxxm4O5qMQA3sT6jDnhNR5h0VUcL8S9TeopVTLTISBorYE9w
         nqskdvclJCdQA4VIpo7rEBaQDvJVQutvZPGu7m+t8j8Qwj221f50BWeQsmSv1JxJ+guE
         60nCAXInUmjj++jIMyrafGQBVO7I05hq+EzXqM9+bWVBfcYSoSl2Hq2XR3fqyD0yXPa4
         xazktRzoFkAdXp1wOZUG+0MxfMwUp5XKNaiiTeF9MhuNXvvslAohmn15R1CmMBNMJt8Q
         7xQA==
X-Gm-Message-State: APjAAAWF25wLOQbMwJcuXutv04NjYIkryQR8z7Imj+hv9HicV/kOL6hd
        uGLqM+sbxFn5jfxHgQwXCW1uvg==
X-Google-Smtp-Source: APXvYqxQXHnVlc8mHVPPI1QVKgJSe7MmX7BopihH8hOm8wh0Ojj05kXDLpWvLZ3SCXJeh59qwJ0E7g==
X-Received: by 2002:a65:44c6:: with SMTP id g6mr8313478pgs.157.1556868119853;
        Fri, 03 May 2019 00:21:59 -0700 (PDT)
Received: from localhost.localdomain (220-133-8-232.HINET-IP.hinet.net. [220.133.8.232])
        by smtp.gmail.com with ESMTPSA id u5sm2671465pfb.60.2019.05.03.00.21.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 00:21:59 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     jes.sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Chris Chiu <chiu@endlessm.com>
Subject: [RFC PATCH 1/2] rtl8xxxu: Add rate adaptive related data
Date:   Fri,  3 May 2019 15:21:45 +0800
Message-Id: <20190503072146.49999-2-chiu@endlessm.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20190503072146.49999-1-chiu@endlessm.com>
References: <20190503072146.49999-1-chiu@endlessm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add wireless mode, signal strength level, and rate table index
to tell the firmware that we need to adjust the tx rate bitmap
accordingly.
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  | 45 +++++++++++++++++++
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 45 ++++++++++++++++++-
 2 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 8828baf26e7b..771f58aa7cae 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1195,6 +1195,50 @@ struct rtl8723bu_c2h {
 
 struct rtl8xxxu_fileops;
 
+/*mlme related.*/
+enum wireless_mode {
+	WIRELESS_MODE_UNKNOWN = 0,
+	//Sub-Element
+	WIRELESS_MODE_B = BIT(0), // tx: cck only , rx: cck only, hw: cck
+	WIRELESS_MODE_G = BIT(1), // tx: ofdm only, rx: ofdm & cck, hw: cck & ofdm
+	WIRELESS_MODE_A = BIT(2), // tx: ofdm only, rx: ofdm only, hw: ofdm only
+	WIRELESS_MODE_N_24G = BIT(3), // tx: MCS only, rx: MCS & cck, hw: MCS & cck
+	WIRELESS_MODE_N_5G = BIT(4), // tx: MCS only, rx: MCS & ofdm, hw: ofdm only
+	WIRELESS_AUTO = BIT(5),
+	WIRELESS_MODE_AC = BIT(6),
+	WIRELESS_MODE_MAX = (WIRELESS_MODE_B|WIRELESS_MODE_G|WIRELESS_MODE_A|WIRELESS_MODE_N_24G|WIRELESS_MODE_N_5G|WIRELESS_MODE_AC),
+};
+
+/* from rtlwifi/wifi.h */
+enum ratr_table_mode_new {
+        RATEID_IDX_BGN_40M_2SS = 0,
+        RATEID_IDX_BGN_40M_1SS = 1,
+        RATEID_IDX_BGN_20M_2SS_BN = 2,
+        RATEID_IDX_BGN_20M_1SS_BN = 3,
+        RATEID_IDX_GN_N2SS = 4,
+        RATEID_IDX_GN_N1SS = 5,
+        RATEID_IDX_BG = 6,
+        RATEID_IDX_G = 7,
+        RATEID_IDX_B = 8,
+        RATEID_IDX_VHT_2SS = 9,
+        RATEID_IDX_VHT_1SS = 10,
+        RATEID_IDX_MIX1 = 11,
+        RATEID_IDX_MIX2 = 12,
+        RATEID_IDX_VHT_3SS = 13,
+        RATEID_IDX_BGN_3SS = 14,
+};
+
+#define RTL8XXXU_RATR_STA_INIT 0
+#define RTL8XXXU_RATR_STA_HIGH 1
+#define RTL8XXXU_RATR_STA_MID  2
+#define RTL8XXXU_RATR_STA_LOW  3
+
+struct rtl8xxxu_rate_adaptive {
+	u16 wireless_mode;
+	u8 ratr_index;
+	u8 rssi_level;		/* INIT, HIGH, MIDDLE, LOW */
+} __packed;
+
 struct rtl8xxxu_priv {
 	struct ieee80211_hw *hw;
 	struct usb_device *udev;
@@ -1299,6 +1343,7 @@ struct rtl8xxxu_priv {
 	u8 pi_enabled:1;
 	u8 no_pape:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
+	struct rtl8xxxu_rate_adaptive ra_info;
 };
 
 struct rtl8xxxu_rx_urb {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 039e5ca9d2e4..360e9bd837e5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4345,7 +4345,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
 
 	h2c.ramask.arg = 0x80;
-	h2c.b_macid_cfg.data1 = 0;
+	h2c.b_macid_cfg.data1 = priv->ra_info.ratr_index;
 	if (sgi)
 		h2c.b_macid_cfg.data1 |= BIT(7);
 
@@ -4485,6 +4485,43 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
 	rtl8xxxu_write8(priv, REG_INIRTS_RATE_SEL, rate_idx);
 }
 
+static u16
+rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
+{
+	u16 network_type = WIRELESS_MODE_UNKNOWN;
+	u32 rate_mask;
+
+	rate_mask = (sta->supp_rates[0] & 0xfff) |
+		    (sta->ht_cap.mcs.rx_mask[0] << 12) |
+		    (sta->ht_cap.mcs.rx_mask[0] << 20);
+
+	if (hw->conf.chandef.chan->band == NL80211_BAND_5GHZ)
+	{
+		if (sta->vht_cap.vht_supported)
+			network_type = WIRELESS_MODE_AC;
+		else if (sta->ht_cap.ht_supported)
+			network_type = WIRELESS_MODE_N_5G;
+
+		network_type |= WIRELESS_MODE_A;
+	}
+	else
+	{
+		if (sta->vht_cap.vht_supported)
+			network_type = WIRELESS_MODE_AC;
+		else if (sta->ht_cap.ht_supported)
+			network_type = WIRELESS_MODE_N_24G;
+
+		if (sta->supp_rates[0] <= 0xf)
+			network_type |= WIRELESS_MODE_B;
+		else if (sta->supp_rates[0] & 0xf)
+			network_type |= (WIRELESS_MODE_B | WIRELESS_MODE_G);
+		else
+			network_type |= WIRELESS_MODE_G;
+	}
+
+	return network_type;
+}
+
 static void
 rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf, u32 changed)
@@ -4503,6 +4540,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (bss_conf->assoc) {
 			u32 ramask;
 			int sgi = 0;
+			struct rtl8xxxu_rate_adaptive *ra;
 
 			rcu_read_lock();
 			sta = ieee80211_find_sta(vif, bss_conf->bssid);
@@ -4527,6 +4565,11 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				sgi = 1;
 			rcu_read_unlock();
 
+			ra = &priv->ra_info;
+			ra->wireless_mode = rtl8xxxu_wireless_mode(hw, sta);
+			ra->ratr_index = RATEID_IDX_BGN_40M_2SS;
+			ra->rssi_level = RTL8XXXU_RATR_STA_INIT;
+
 			priv->fops->update_rate_mask(priv, ramask, sgi);
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
-- 
2.21.0

