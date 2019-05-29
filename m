Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0882D4F8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfE2FDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:03:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34288 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfE2FDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:03:49 -0400
Received: by mail-pl1-f196.google.com with SMTP id w7so526042plz.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 22:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3wyOV68ZqRXmH5ten4NJjlbdUd/q5u/HMqupec8c9Q=;
        b=NoOhn2OdqytmY/CbSgoOo6diyqIGQTgHXIqGcpwH6Hx64Ec1DBlaCiQQ0A9kzS17kN
         DLZdH2wCAFbAf2NDvvbto3TDOSxapwOy5FagsLvwv4hhT9zE4iJzLqhTYty6G5c3Q9hS
         RnvTik3IEVoo9T0a6+cFLa6mEBf4Y+4NTaUBoU/2pfKj4XRXsaZXm4BJ3BmWe8B1xbow
         7uBTCEHOulqOMW5BrIErT7tVDWMrUzCyL43btvJkRigsGQqyWUHQSNB1RUI17pu2ae7m
         zmCL/CXqiP325UTlIqiawBYMVTS7YQWbyMrh1fHKETBEMH5p1w/66TcvSHzNPcot1jFx
         qutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3wyOV68ZqRXmH5ten4NJjlbdUd/q5u/HMqupec8c9Q=;
        b=GHeSUFiwm8eniOqUbE57DRH93dtqHms+heWq9WiXJ6JrxupSqKL2+uXYjv9QjH+PVF
         DIyD/s4uMHewTvNg/Vb+Os/em+8wrUNB92clrJguE+U+3dAx9gOPA7mKYPvVbeLvSn7C
         ehk9ZV+HMmPxsrg7fduff8uJyjw/p5ZaQOe9u7d7JjqIfvH4o+gC00Gft+/tvjZ1hSid
         6xTjqfNRDRWFiF4zekAL4mDD5QPsbrFyF1ryYt9r/L3gwLzqRsMOSP6icRoUj67d3W+F
         7YROKa3ISANI0a4oKdBA1UbeFrrN6pV2r8Eyml282+o9Qmhdwt4zBVC+9dSHgmW5BVPO
         kSVQ==
X-Gm-Message-State: APjAAAWB87snnIq2O9JdXd1JqbcewzYJrA7nTkHAM0V17+m3DCtWVoQa
        ZlDE6o5V+aP1ZhalVgTS8b9TBg==
X-Google-Smtp-Source: APXvYqygK0oyZ5UxiIy4useFI5p/ram0qsCyra3nbavXqdlMLMyO93u9F5x7uVqfMVUTRr0fwiCjow==
X-Received: by 2002:a17:902:b70b:: with SMTP id d11mr26052304pls.84.1559106227959;
        Tue, 28 May 2019 22:03:47 -0700 (PDT)
Received: from localhost.localdomain (220-133-8-225.HINET-IP.hinet.net. [220.133.8.225])
        by smtp.gmail.com with ESMTPSA id m123sm17312188pfm.39.2019.05.28.22.03.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 22:03:46 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     jes.sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [RFC PATCH v3] rtl8xxxu: Improve TX performance of RTL8723BU on rtl8xxxu driver
Date:   Wed, 29 May 2019 13:03:35 +0800
Message-Id: <20190529050335.72061-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have 3 laptops which connect the wifi by the same RTL8723BU.
The PCI VID/PID of the wifi chip is 10EC:B720 which is supported.
They have the same problem with the in-kernel rtl8xxxu driver, the
iperf (as a client to an ethernet-connected server) gets ~1Mbps.
Nevertheless, the signal strength is reported as around -40dBm,
which is quite good. From the wireshark capture, the tx rate for each
data and qos data packet is only 1Mbps. Compare to the driver from
https://github.com/lwfinger/rtl8723bu, the same iperf test gets ~12
Mbps or more. The signal strength is reported similarly around
-40dBm. That's why we want to improve.

After reading the source code of the rtl8xxxu driver and Larry's, the
major difference is that Larry's driver has a watchdog which will keep
monitoring the signal quality and updating the rate mask just like the
rtl8xxxu_gen2_update_rate_mask() does if signal quality changes.
And this kind of watchdog also exists in rtlwifi driver of some specific
chips, ex rtl8192ee, rtl8188ee, rtl8723ae, rtl8821ae...etc. They have
the same member function named dm_watchdog and will invoke the
corresponding dm_refresh_rate_adaptive_mask to adjust the tx rate
mask.

With this commit, the tx rate of each data and qos data packet will
be 39Mbps (MCS4) with the 0xF00000 as the tx rate mask. The 20th bit
to 23th bit means MCS4 to MCS7. It means that the firmware still picks
the lowest rate from the rate mask and explains why the tx rate of
data and qos data is always lowest 1Mbps because the default rate mask
passed is always 0xFFFFFFF ranges from the basic CCK rate, OFDM rate,
and MCS rate. However, with Larry's driver, the tx rate observed from
wireshark under the same condition is almost 65Mbps or 72Mbps.

I believe the firmware of RTL8723BU may need fix. And I think we
can still bring in the dm_watchdog as rtlwifi to improve from the
driver side. Please leave precious comments for my commits and
suggest what I can do better. Or suggest if there's any better idea
to fix this. Thanks.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---


Notes:
  v2:
   - Fix errors and warnings complained by checkpatch.pl
   - Replace data structure rate_adaptive by 2 member variables
   - Make rtl8xxxu_wireless_mode non-static
   - Runs refresh_rate_mask() only in station mode
  v3:
   - Remove ugly rtl8xxxu_watchdog data structure
   - Make sure only one vif exists


 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  49 ++++++
 .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         | 145 ++++++++++++++++++
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |  80 +++++++++-
 3 files changed, 273 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 8828baf26e7b..42e9227f4d19 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1195,6 +1195,44 @@ struct rtl8723bu_c2h {
 
 struct rtl8xxxu_fileops;
 
+/*mlme related.*/
+enum wireless_mode {
+	WIRELESS_MODE_UNKNOWN = 0,
+	/* Sub-Element */
+	WIRELESS_MODE_B = BIT(0),
+	WIRELESS_MODE_G = BIT(1),
+	WIRELESS_MODE_A = BIT(2),
+	WIRELESS_MODE_N_24G = BIT(3),
+	WIRELESS_MODE_N_5G = BIT(4),
+	WIRELESS_AUTO = BIT(5),
+	WIRELESS_MODE_AC = BIT(6),
+	WIRELESS_MODE_MAX = 0x7F,
+};
+
+/* from rtlwifi/wifi.h */
+enum ratr_table_mode_new {
+	RATEID_IDX_BGN_40M_2SS = 0,
+	RATEID_IDX_BGN_40M_1SS = 1,
+	RATEID_IDX_BGN_20M_2SS_BN = 2,
+	RATEID_IDX_BGN_20M_1SS_BN = 3,
+	RATEID_IDX_GN_N2SS = 4,
+	RATEID_IDX_GN_N1SS = 5,
+	RATEID_IDX_BG = 6,
+	RATEID_IDX_G = 7,
+	RATEID_IDX_B = 8,
+	RATEID_IDX_VHT_2SS = 9,
+	RATEID_IDX_VHT_1SS = 10,
+	RATEID_IDX_MIX1 = 11,
+	RATEID_IDX_MIX2 = 12,
+	RATEID_IDX_VHT_3SS = 13,
+	RATEID_IDX_BGN_3SS = 14,
+};
+
+#define RTL8XXXU_RATR_STA_INIT 0
+#define RTL8XXXU_RATR_STA_HIGH 1
+#define RTL8XXXU_RATR_STA_MID  2
+#define RTL8XXXU_RATR_STA_LOW  3
+
 struct rtl8xxxu_priv {
 	struct ieee80211_hw *hw;
 	struct usb_device *udev;
@@ -1299,6 +1337,14 @@ struct rtl8xxxu_priv {
 	u8 pi_enabled:1;
 	u8 no_pape:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
+	u8 ratr_index;
+	u8 rssi_level;
+	/*
+	 * Single virtual interface permitted since the driver supports STATION
+	 * mode only.
+	 */
+	struct ieee80211_vif *vif;
+	struct delayed_work ra_watchdog;
 };
 
 struct rtl8xxxu_rx_urb {
@@ -1335,6 +1381,8 @@ struct rtl8xxxu_fileops {
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
 				  u32 ramask, int sgi);
+	void (*refresh_rate_mask) (struct rtl8xxxu_priv *priv, int signal,
+				   struct ieee80211_sta *sta);
 	void (*report_connect) (struct rtl8xxxu_priv *priv,
 				u8 macid, bool connect);
 	void (*fill_txdesc) (struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
@@ -1445,6 +1493,7 @@ void rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 			     struct rtl8xxxu_txdesc32 *tx_desc32, bool sgi,
 			     bool short_preamble, bool ampdu_enable,
 			     u32 rts_rate);
+u16 rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta);
 
 extern struct rtl8xxxu_fileops rtl8192cu_fops;
 extern struct rtl8xxxu_fileops rtl8192eu_fops;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index 26b674aca125..7a510bc22a60 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1645,6 +1645,150 @@ static void rtl8723bu_init_statistics(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
 }
 
+static u8 rtl8723b_signal_to_rssi(int signal)
+{
+	if (signal < -95)
+		signal = -95;
+	return (u8)(signal + 95);
+}
+
+static void rtl8723b_refresh_rate_mask(struct rtl8xxxu_priv *priv,
+				       int signal, struct ieee80211_sta *sta)
+{
+	struct ieee80211_hw *hw = priv->hw;
+	u16 wireless_mode;
+	u8 rssi_level, ratr_index;
+	u8 txbw_40mhz;
+	u8 rssi, rssi_thresh_high, rssi_thresh_low;
+
+	rssi_level = priv->rssi_level;
+	rssi = rtl8723b_signal_to_rssi(signal);
+	ratr_index = priv->ratr_index;
+	txbw_40mhz = (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40) ? 1 : 0;
+
+	switch (rssi_level) {
+	case RTL8XXXU_RATR_STA_HIGH:
+		rssi_thresh_high = 50;
+		rssi_thresh_low = 20;
+		break;
+	case RTL8XXXU_RATR_STA_MID:
+		rssi_thresh_high = 55;
+		rssi_thresh_low = 20;
+		break;
+	case RTL8XXXU_RATR_STA_LOW:
+		rssi_thresh_high = 60;
+		rssi_thresh_low = 25;
+		break;
+	default:
+		rssi_thresh_high = 50;
+		rssi_thresh_low = 20;
+		break;
+	}
+
+	if (rssi > rssi_thresh_high)
+		rssi_level = RTL8XXXU_RATR_STA_HIGH;
+	else if (rssi > rssi_thresh_low)
+		rssi_level = RTL8XXXU_RATR_STA_MID;
+	else
+		rssi_level = RTL8XXXU_RATR_STA_LOW;
+
+	if (rssi_level != priv->rssi_level) {
+		int sgi = 0;
+		u32 rate_bitmap = 0;
+
+		rcu_read_lock();
+		rate_bitmap = (sta->supp_rates[0] & 0xfff) |
+				(sta->ht_cap.mcs.rx_mask[0] << 12) |
+				(sta->ht_cap.mcs.rx_mask[1] << 20);
+		if (sta->ht_cap.cap &
+		    (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))
+			sgi = 1;
+		rcu_read_unlock();
+
+		wireless_mode = rtl8xxxu_wireless_mode(hw, sta);
+		switch (wireless_mode) {
+		case WIRELESS_MODE_B:
+			ratr_index = RATEID_IDX_B;
+			if (rate_bitmap & 0x0000000c)
+				rate_bitmap &= 0x0000000d;
+			else
+				rate_bitmap &= 0x0000000f;
+			break;
+		case WIRELESS_MODE_A:
+		case WIRELESS_MODE_G:
+			ratr_index = RATEID_IDX_G;
+			if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
+				rate_bitmap &= 0x00000f00;
+			else
+				rate_bitmap &= 0x00000ff0;
+			break;
+		case (WIRELESS_MODE_B | WIRELESS_MODE_G):
+			ratr_index = RATEID_IDX_BG;
+			if (rssi_level == RTL8XXXU_RATR_STA_HIGH)
+				rate_bitmap &= 0x00000f00;
+			else if (rssi_level == RTL8XXXU_RATR_STA_MID)
+				rate_bitmap &= 0x00000ff0;
+			else
+				rate_bitmap &= 0x00000ff5;
+			break;
+		case WIRELESS_MODE_N_24G:
+		case WIRELESS_MODE_N_5G:
+		case (WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
+		case (WIRELESS_MODE_A | WIRELESS_MODE_N_5G):
+			if (priv->tx_paths == 2 && priv->rx_paths == 2)
+				ratr_index = RATEID_IDX_GN_N2SS;
+			else
+				ratr_index = RATEID_IDX_GN_N1SS;
+		case (WIRELESS_MODE_B | WIRELESS_MODE_G | WIRELESS_MODE_N_24G):
+		case (WIRELESS_MODE_B | WIRELESS_MODE_N_24G):
+			if (txbw_40mhz) {
+				if (priv->tx_paths == 2 && priv->rx_paths == 2)
+					ratr_index = RATEID_IDX_BGN_40M_2SS;
+				else
+					ratr_index = RATEID_IDX_BGN_40M_1SS;
+			} else {
+				if (priv->tx_paths == 2 && priv->rx_paths == 2)
+					ratr_index = RATEID_IDX_BGN_20M_2SS_BN;
+				else
+					ratr_index = RATEID_IDX_BGN_20M_1SS_BN;
+			}
+
+			if (priv->tx_paths == 2 && priv->rx_paths == 2) {
+				if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
+					rate_bitmap &= 0x0f8f0000;
+				} else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
+					rate_bitmap &= 0x0f8ff000;
+				} else {
+					if (txbw_40mhz)
+						rate_bitmap &= 0x0f8ff015;
+					else
+						rate_bitmap &= 0x0f8ff005;
+				}
+			} else {
+				if (rssi_level == RTL8XXXU_RATR_STA_HIGH) {
+					rate_bitmap &= 0x000f0000;
+				} else if (rssi_level == RTL8XXXU_RATR_STA_MID) {
+					rate_bitmap &= 0x000ff000;
+				} else {
+					if (txbw_40mhz)
+						rate_bitmap &= 0x000ff015;
+					else
+						rate_bitmap &= 0x000ff005;
+				}
+			}
+			break;
+		default:
+			ratr_index = RATEID_IDX_BGN_40M_2SS;
+			rate_bitmap &= 0x0fffffff;
+			break;
+		}
+
+		priv->ratr_index = ratr_index;
+		priv->rssi_level = rssi_level;
+		priv->fops->update_rate_mask(priv, rate_bitmap, sgi);
+	}
+}
+
 struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.parse_efuse = rtl8723bu_parse_efuse,
 	.load_firmware = rtl8723bu_load_firmware,
@@ -1665,6 +1809,7 @@ struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.usb_quirks = rtl8xxxu_gen2_usb_quirks,
 	.set_tx_power = rtl8723b_set_tx_power,
 	.update_rate_mask = rtl8xxxu_gen2_update_rate_mask,
+	.refresh_rate_mask = rtl8723b_refresh_rate_mask,
 	.report_connect = rtl8xxxu_gen2_report_connect,
 	.fill_txdesc = rtl8xxxu_fill_txdesc_v2,
 	.writeN_block_size = 1024,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 039e5ca9d2e4..2d612c2df5b2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4345,7 +4345,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
 
 	h2c.ramask.arg = 0x80;
-	h2c.b_macid_cfg.data1 = 0;
+	h2c.b_macid_cfg.data1 = priv->ratr_index;
 	if (sgi)
 		h2c.b_macid_cfg.data1 |= BIT(7);
 
@@ -4485,6 +4485,40 @@ static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
 	rtl8xxxu_write8(priv, REG_INIRTS_RATE_SEL, rate_idx);
 }
 
+u16
+rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
+{
+	u16 network_type = WIRELESS_MODE_UNKNOWN;
+	u32 rate_mask;
+
+	rate_mask = (sta->supp_rates[0] & 0xfff) |
+		    (sta->ht_cap.mcs.rx_mask[0] << 12) |
+		    (sta->ht_cap.mcs.rx_mask[0] << 20);
+
+	if (hw->conf.chandef.chan->band == NL80211_BAND_5GHZ) {
+		if (sta->vht_cap.vht_supported)
+			network_type = WIRELESS_MODE_AC;
+		else if (sta->ht_cap.ht_supported)
+			network_type = WIRELESS_MODE_N_5G;
+
+		network_type |= WIRELESS_MODE_A;
+	} else {
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
@@ -4527,6 +4561,10 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				sgi = 1;
 			rcu_read_unlock();
 
+			priv->vif = vif;
+			priv->ratr_index = RATEID_IDX_BGN_40M_2SS;
+			priv->rssi_level = RTL8XXXU_RATR_STA_INIT;
+
 			priv->fops->update_rate_mask(priv, ramask, sgi);
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
@@ -5471,6 +5509,10 @@ static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
+		if (!priv->vif)
+			priv->vif = vif;
+		else
+			return -EOPNOTSUPP;
 		rtl8xxxu_stop_tx_beacon(priv);
 
 		val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
@@ -5779,6 +5821,37 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return 0;
 }
 
+static void rtl8xxxu_watchdog_callback(struct work_struct *work)
+{
+	struct ieee80211_vif *vif;
+	struct rtl8xxxu_priv *priv;
+
+	priv = container_of(work, struct rtl8xxxu_priv, ra_watchdog.work);
+	vif = priv->vif;
+
+	if (vif && vif->type == NL80211_IFTYPE_STATION) {
+		int signal;
+		struct ieee80211_sta *sta;
+
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+		if (!sta) {
+			struct device *dev = &priv->udev->dev;
+
+			dev_info(dev, "%s: no sta found\n", __func__);
+			rcu_read_unlock();
+			return;
+		}
+		rcu_read_unlock();
+
+		signal = ieee80211_ave_rssi(vif);
+		if (priv->fops->refresh_rate_mask)
+			priv->fops->refresh_rate_mask(priv, signal, sta);
+	}
+
+	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
+}
+
 static int rtl8xxxu_start(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
@@ -5835,6 +5908,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
 	}
+
+	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
 exit:
 	/*
 	 * Accept all data and mgmt frames
@@ -6058,6 +6133,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
 	spin_lock_init(&priv->rx_urb_lock);
 	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
+	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
 
 	usb_set_intfdata(interface, hw);
 
@@ -6183,6 +6259,8 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
 	mutex_destroy(&priv->usb_buf_mutex);
 	mutex_destroy(&priv->h2c_mutex);
 
+	cancel_delayed_work_sync(&priv->ra_watchdog);
+
 	if (priv->udev->state != USB_STATE_NOTATTACHED) {
 		dev_info(&priv->udev->dev,
 			 "Device still attached, trying to reset\n");
-- 
2.21.0

