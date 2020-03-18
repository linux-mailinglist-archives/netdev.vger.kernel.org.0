Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11267189702
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCRI1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:27:18 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33866 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgCRI1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:27:17 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so10875984plm.1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q67Jyo84FepUkmWaE2l8NSTdFx5oALdllapMnZWigOw=;
        b=wHavSO3dYWfl8aL69jLUhaa20mvMeN5gq65qxD00+zKON5m2BDMlFYBJIKejkHQT5d
         j87RoCEVWiPjqj4LMYZo2t0KyrYu0ME88f3cfVO0aJuaRtkz1gTosPNTzcsi3TSf5Gfb
         NEUxLdLi/BUiOv8AWH0ISIMvf+JfgjYJ1L5jqM47FbX302UU0xMdaCvzMR47pHxPzKvM
         esUYSGbNR1cot3O/3gxiTWJdidYafGQkr5fyxK2UPGv60YswB4m9JduicFRB3CifQHvN
         WZjDLT5oO0Wqjrzy6pP6Tv/PkZ4xaX364PxxnLugVt9nEUFwGvk4me/n/cr2byJLcdHB
         825Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q67Jyo84FepUkmWaE2l8NSTdFx5oALdllapMnZWigOw=;
        b=sVrM/yoLiSC67SJKGDybPU/j8zagv8jS+R12K1/76PdPOUeKDdvZnDglCOnts7gh7X
         6ntimZaCdLTcWpUFOR7Y2a++sYhXWrvZp5nkKAqpv09iTLNHD2vwEOtEAt3AThmVBpPd
         VGY3d/FYdu7R4QFnJbAOWZNLgBl+glrmHIRuU63VcI3HxaRNHe34NRSV35yJYtkAF7mk
         FzZJKWP4gUn9yMueO6kcF+J81jHubnbZA25QcTW0gfgKTPZzuM+QJsMuKuat5qXfLRTF
         xQDbd6SYfhnz6lqxdRmK3kA1JNXdJxVsnQQ+GElEcdQuyi5dghChehaIsOEfRaP0PX3T
         aqgA==
X-Gm-Message-State: ANhLgQ2n+WtNN9gd5HKlRk49fGYSsYhP5nWhQ5jxKweVuNMVuoraYLLl
        +iTUX2/Jbwkufj8XeAeWr+tsFg==
X-Google-Smtp-Source: ADFU+vv2OTPgHhQTQt1hhMqYhaFSeGVb5tFFleZIVG/GUUbGBVVXxMBNdJQBOh55SIWNsHqiVtnBaQ==
X-Received: by 2002:a17:90a:1946:: with SMTP id 6mr405387pjh.42.1584520034178;
        Wed, 18 Mar 2020 01:27:14 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-126.HINET-IP.hinet.net. [59.127.47.126])
        by smtp.gmail.com with ESMTPSA id 18sm5492148pfj.140.2020.03.18.01.27.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Mar 2020 01:27:13 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH 2/2] rtl8xxxu: Feed current txrate information for mac80211
Date:   Wed, 18 Mar 2020 16:27:00 +0800
Message-Id: <20200318082700.71875-3-chiu@endlessm.com>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200318082700.71875-1-chiu@endlessm.com>
References: <20200318082700.71875-1-chiu@endlessm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nl80211 commands such as 'iw link' can't get current txrate
information from the driver. This commit fills in the tx rate
information from the C2H RA report in the sta_statistics function.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  | 12 ++-
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 75 ++++++++++++++++++-
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 86d1d50511a8..e6fd1ecaca9c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1183,13 +1183,16 @@ struct rtl8723bu_c2h {
 		} __packed bt_info;
 		struct {
 			u8 rate:7;
-			u8 dummy0_0:1;
+			u8 sgi:1;
 			u8 macid;
 			u8 ldpc:1;
 			u8 txbf:1;
 			u8 noisy_state:1;
 			u8 dummy2_0:5;
 			u8 dummy3_0;
+			u8 dummy4_0;
+			u8 dummy5_0;
+			u8 bw;
 		} __packed ra_report;
 	};
 };
@@ -1269,6 +1272,12 @@ struct rtl8xxxu_btcoex {
 #define RTL8XXXU_SNR_THRESH_HIGH	50
 #define RTL8XXXU_SNR_THRESH_LOW	20
 
+struct rtl8xxxu_ra_report {
+	struct rate_info txrate;
+	u32 bit_rate;
+	u8 desc_rate;
+};
+
 struct rtl8xxxu_priv {
 	struct ieee80211_hw *hw;
 	struct usb_device *udev;
@@ -1384,6 +1393,7 @@ struct rtl8xxxu_priv {
 	struct sk_buff_head c2hcmd_queue;
 	spinlock_t c2hcmd_lock;
 	struct rtl8xxxu_btcoex bt_coex;
+	struct rtl8xxxu_ra_report ra_report;
 };
 
 struct rtl8xxxu_rx_urb {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 511a3b4ed72a..49dfa32b572a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5389,6 +5389,35 @@ void rtl8723bu_handle_bt_info(struct rtl8xxxu_priv *priv)
 	}
 }
 
+static struct ieee80211_rate rtl8xxxu_legacy_ratetable[] = {
+	{.bitrate = 10, .hw_value = 0x00,},
+	{.bitrate = 20, .hw_value = 0x01,},
+	{.bitrate = 55, .hw_value = 0x02,},
+	{.bitrate = 110, .hw_value = 0x03,},
+	{.bitrate = 60, .hw_value = 0x04,},
+	{.bitrate = 90, .hw_value = 0x05,},
+	{.bitrate = 120, .hw_value = 0x06,},
+	{.bitrate = 180, .hw_value = 0x07,},
+	{.bitrate = 240, .hw_value = 0x08,},
+	{.bitrate = 360, .hw_value = 0x09,},
+	{.bitrate = 480, .hw_value = 0x0a,},
+	{.bitrate = 540, .hw_value = 0x0b,},
+};
+
+void rtl8xxxu_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
+{
+	if (rate <= DESC_RATE_54M)
+		return;
+
+	if (rate >= DESC_RATE_MCS0 && rate <= DESC_RATE_MCS15) {
+		if (rate < DESC_RATE_MCS8)
+			*nss = 1;
+		else
+			*nss = 2;
+		*mcs = rate - DESC_RATE_MCS0;
+	}
+}
+
 static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
@@ -5397,9 +5426,14 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 	unsigned long flags;
 	u8 bt_info = 0;
 	struct rtl8xxxu_btcoex *btcoex;
+	struct rtl8xxxu_ra_report *rarpt;
+	u8 rate, sgi, bw;
+	u32 bit_rate;
+	u8 mcs = 0, nss = 0;
 
 	priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
 	btcoex = &priv->bt_coex;
+	rarpt = &priv->ra_report;
 
 	if (priv->rf_paths > 1)
 		goto out;
@@ -5422,6 +5456,34 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 			}
 			rtl8723bu_handle_bt_info(priv);
 			break;
+		case C2H_8723B_RA_REPORT:
+			rarpt->txrate.flags = 0;
+			rate = c2h->ra_report.rate;
+			sgi = c2h->ra_report.sgi;
+			bw = c2h->ra_report.bw;
+
+			if (rate < DESC_RATE_MCS0) {
+				rarpt->txrate.legacy =
+					rtl8xxxu_legacy_ratetable[rate].bitrate;
+			} else {
+				rtl8xxxu_desc_to_mcsrate(rate, &mcs, &nss);
+				rarpt->txrate.flags |= RATE_INFO_FLAGS_MCS;
+
+				rarpt->txrate.mcs = mcs;
+				rarpt->txrate.nss = nss;
+
+				if (sgi) {
+					rarpt->txrate.flags |=
+						RATE_INFO_FLAGS_SHORT_GI;
+				}
+
+				if (bw == RATE_INFO_BW_20)
+					rarpt->txrate.bw |= RATE_INFO_BW_20;
+			}
+			bit_rate = cfg80211_calculate_bitrate(&rarpt->txrate);
+			rarpt->bit_rate = bit_rate;
+			rarpt->desc_rate = rate;
+			break;
 		default:
 			break;
 		}
@@ -5465,7 +5527,7 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 	case C2H_8723B_RA_REPORT:
 		dev_dbg(dev,
 			"C2H RA RPT: rate %02x, unk %i, macid %02x, noise %i\n",
-			c2h->ra_report.rate, c2h->ra_report.dummy0_0,
+			c2h->ra_report.rate, c2h->ra_report.sgi,
 			c2h->ra_report.macid, c2h->ra_report.noisy_state);
 		break;
 	default:
@@ -6069,6 +6131,16 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 
+static void
+rtl8xxxu_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta, struct station_info *sinfo)
+{
+	struct rtl8xxxu_priv *priv = hw->priv;
+
+	sinfo->txrate = priv->ra_report.txrate;
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
+}
+
 static u8 rtl8xxxu_signal_to_snr(int signal)
 {
 	if (signal < RTL8XXXU_NOISE_FLOOR_MIN)
@@ -6371,6 +6443,7 @@ static const struct ieee80211_ops rtl8xxxu_ops = {
 	.sw_scan_complete = rtl8xxxu_sw_scan_complete,
 	.set_key = rtl8xxxu_set_key,
 	.ampdu_action = rtl8xxxu_ampdu_action,
+	.sta_statistics = rtl8xxxu_sta_statistics,
 };
 
 static int rtl8xxxu_parse_usb(struct rtl8xxxu_priv *priv,
-- 
2.20.1

