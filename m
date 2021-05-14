Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E383801DD
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhENCWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhENCWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:22:12 -0400
X-Greylist: delayed 953 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 May 2021 19:21:01 PDT
Received: from mxout013.mail.hostpoint.ch (mxout013.mail.hostpoint.ch [IPv6:2a00:d70:0:e::313])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740BC061574;
        Thu, 13 May 2021 19:21:01 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout013.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-000HmN-Gy; Fri, 14 May 2021 04:05:03 +0200
Received: from [2a02:168:6182:1:4ea5:a8cc:a141:509c] (helo=ryzen2700.home.reto-schneider.ch)
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-000L6T-AY; Fri, 14 May 2021 04:05:03 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/7] rtl8xxxu: add code to handle BSS_CHANGED_TXPOWER/IEEE80211_CONF_CHANGE_POWER
Date:   Fri, 14 May 2021 04:04:36 +0200
Message-Id: <20210514020442.946-2-code@reto-schneider.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514020442.946-1-code@reto-schneider.ch>
References: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
 <20210514020442.946-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

The 'iw set txpower' is not handled by the driver. Use the existing
set_tx_power function to apply the tx power change

Signed-off-by: Chris Chiu <chiu@endlessos.org>
(cherry picked from commit 48f8fbccb7dff2d3c5f72a4267313d3c4cfc7df9)
Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  3 +
 .../realtek/rtl8xxxu/rtl8xxxu_8192c.c         |  1 +
 .../realtek/rtl8xxxu/rtl8xxxu_8723a.c         |  1 +
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 90 +++++++++++++++++++
 4 files changed, 95 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index d6d1be4169e5..c15e4a52b9e5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1426,6 +1426,7 @@ struct rtl8xxxu_fileops {
 	void (*enable_rf) (struct rtl8xxxu_priv *priv);
 	void (*disable_rf) (struct rtl8xxxu_priv *priv);
 	void (*usb_quirks) (struct rtl8xxxu_priv *priv);
+	u8 (*dbm_to_txpwridx)(struct rtl8xxxu_priv *priv, u16 mode, int dbm);
 	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
@@ -1508,6 +1509,8 @@ void rtl8xxxu_disabled_to_emu(struct rtl8xxxu_priv *priv);
 int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv);
+u8 rtl8xxxu_gen1_dbm_to_txpwridx(struct rtl8xxxu_priv *priv,
+				 u16 mode, int dbm);
 void rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv,
 				int channel, bool ht40);
 void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index 27c4cb688be4..bb6df8cac82f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -556,6 +556,7 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.enable_rf = rtl8xxxu_gen1_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
+	.dbm_to_txpwridx = rtl8xxxu_gen1_dbm_to_txpwridx,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
index 4f93f88716a9..a5d56f61c4eb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -373,6 +373,7 @@ struct rtl8xxxu_fileops rtl8723au_fops = {
 	.enable_rf = rtl8xxxu_gen1_enable_rf,
 	.disable_rf = rtl8xxxu_gen1_disable_rf,
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
+	.dbm_to_txpwridx = rtl8xxxu_gen1_dbm_to_txpwridx,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5cd7ef3625c5..e8459cb6035f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1382,6 +1382,38 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 	}
 }
 
+#define MAX_TXPWR_IDX_NMODE_92S		63
+
+u8
+rtl8xxxu_gen1_dbm_to_txpwridx(struct rtl8xxxu_priv *priv, u16 mode, int dbm)
+{
+	u8 txpwridx;
+	long offset;
+
+	switch (mode) {
+	case WIRELESS_MODE_B:
+		offset = -7;
+		break;
+	case WIRELESS_MODE_G:
+	case WIRELESS_MODE_N_24G:
+		offset = -8;
+		break;
+	default:
+		offset = -8;
+		break;
+	}
+
+	if ((dbm - offset) > 0)
+		txpwridx = (u8)((dbm - offset) * 2);
+	else
+		txpwridx = 0;
+
+	if (txpwridx > MAX_TXPWR_IDX_NMODE_92S)
+		txpwridx = MAX_TXPWR_IDX_NMODE_92S;
+
+	return txpwridx;
+}
+
 void
 rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
@@ -4508,6 +4540,55 @@ rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
 	return network_type;
 }
 
+static void rtl8xxxu_update_txpower(struct rtl8xxxu_priv *priv, int power)
+{
+	bool ht40 = false;
+	struct ieee80211_hw *hw = priv->hw;
+	int channel = hw->conf.chandef.chan->hw_value;
+	u8 cck_txpwridx, ofdm_txpwridx;
+	int i, group;
+
+	if (!priv->fops->dbm_to_txpwridx)
+		return;
+
+	switch (hw->conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		ht40 = false;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		ht40 = true;
+		break;
+	default:
+		return;
+	}
+
+	// change the power level to power index
+	cck_txpwridx = priv->fops->dbm_to_txpwridx(priv, WIRELESS_MODE_B,
+						   power);
+	ofdm_txpwridx = priv->fops->dbm_to_txpwridx(priv, WIRELESS_MODE_N_24G,
+						    power);
+
+	if (ofdm_txpwridx - priv->ofdm_tx_power_index_diff[1].a > 0)
+		ofdm_txpwridx -= priv->ofdm_tx_power_index_diff[1].a;
+	else
+		ofdm_txpwridx = 0;
+
+	group = rtl8xxxu_gen1_channel_to_group(channel);
+
+	if (cck_txpwridx <= priv->cck_tx_power_index_A[group]) {
+		priv->cck_tx_power_index_A[group] = cck_txpwridx;
+		priv->cck_tx_power_index_B[group] = cck_txpwridx;
+	}
+
+	if (ofdm_txpwridx <= priv->ht40_1s_tx_power_index_A[group]) {
+		priv->ht40_1s_tx_power_index_A[i] = ofdm_txpwridx;
+		priv->ht40_1s_tx_power_index_B[i] = ofdm_txpwridx;
+	}
+
+	priv->fops->set_tx_power(priv, channel, ht40);
+}
+
 static void
 rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *bss_conf, u32 changed)
@@ -4604,6 +4685,12 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		dev_dbg(dev, "Changed BASIC_RATES!\n");
 		rtl8xxxu_set_basic_rates(priv, bss_conf->basic_rates);
 	}
+
+	if (changed & BSS_CHANGED_TXPOWER) {
+		dev_dbg(dev, "Changed TX power!\n");
+		//rtl8xxxu_update_txpower(priv, bss_conf->txpower);	// iterate
+		rtl8xxxu_update_txpower(priv, hw->conf.power_level);
+	}
 error:
 	return;
 }
@@ -5891,6 +5978,9 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 		priv->fops->config_channel(hw);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER)
+		rtl8xxxu_update_txpower(priv, hw->conf.power_level);
+
 exit:
 	return ret;
 }
-- 
2.29.2

