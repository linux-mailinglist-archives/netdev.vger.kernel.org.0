Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91170380200
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhENCaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhENCaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:30:24 -0400
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA1CC061574;
        Thu, 13 May 2021 19:29:13 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-0005TM-NC; Fri, 14 May 2021 04:05:03 +0200
Received: from [2a02:168:6182:1:4ea5:a8cc:a141:509c] (helo=ryzen2700.home.reto-schneider.ch)
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-000L6T-KA; Fri, 14 May 2021 04:05:03 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/7] rtl8xxxu: add handle for mac80211 get_txpower
Date:   Fri, 14 May 2021 04:04:37 +0200
Message-Id: <20210514020442.946-3-code@reto-schneider.ch>
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

add .get_txpower handle for mac80211 operations for `iw` and `wext`
tools to get the underlying tx power (max limit).

Signed-off-by: Chris Chiu <chiu@endlessos.org>
(cherry picked from commit 2295263455630bd53eb51379e6e745b943d5017d)
Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  3 +
 .../realtek/rtl8xxxu/rtl8xxxu_8192c.c         |  1 +
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 72 ++++++++++++++++++-
 3 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index c15e4a52b9e5..3d16d6c9ff39 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1319,6 +1319,7 @@ struct rtl8xxxu_priv {
 	struct rtl8723au_idx ht20_tx_power_diff[RTL8723B_TX_COUNT];
 	struct rtl8723au_idx ht40_tx_power_diff[RTL8723B_TX_COUNT];
 	struct rtl8xxxu_power_base *power_base;
+	u8 cur_cck_txpwridx, cur_ofdm24g_txpwridx;
 	u32 chip_cut:4;
 	u32 rom_rev:4;
 	u32 is_multi_func:1;
@@ -1427,6 +1428,7 @@ struct rtl8xxxu_fileops {
 	void (*disable_rf) (struct rtl8xxxu_priv *priv);
 	void (*usb_quirks) (struct rtl8xxxu_priv *priv);
 	u8 (*dbm_to_txpwridx)(struct rtl8xxxu_priv *priv, u16 mode, int dbm);
+	int (*get_tx_power)(struct rtl8xxxu_priv *priv);
 	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
@@ -1513,6 +1515,7 @@ u8 rtl8xxxu_gen1_dbm_to_txpwridx(struct rtl8xxxu_priv *priv,
 				 u16 mode, int dbm);
 void rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv,
 				int channel, bool ht40);
+int rtl8xxxu_gen1_get_tx_power(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw);
 void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw);
 void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
index bb6df8cac82f..54f41af1015e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -558,6 +558,7 @@ struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
 	.dbm_to_txpwridx = rtl8xxxu_gen1_dbm_to_txpwridx,
 	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
+	.get_tx_power = rtl8xxxu_gen1_get_tx_power,
 	.update_rate_mask = rtl8xxxu_update_rate_mask,
 	.report_connect = rtl8xxxu_gen1_report_connect,
 	.fill_txdesc = rtl8xxxu_fill_txdesc_v1,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e8459cb6035f..585018383712 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1414,6 +1414,55 @@ rtl8xxxu_gen1_dbm_to_txpwridx(struct rtl8xxxu_priv *priv, u16 mode, int dbm)
 	return txpwridx;
 }
 
+static int
+rtl8xxxu_gen1_txpwridx_to_dbm(struct rtl8xxxu_priv *priv, u16 mode, u8 idx)
+{
+	int offset;
+	int pwrout_dbm;
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
+	pwrout_dbm = idx / 2 + offset;
+
+	return pwrout_dbm;
+}
+
+int
+rtl8xxxu_gen1_get_tx_power(struct rtl8xxxu_priv *priv)
+{
+	u8 txpwr_level;
+	int txpwr_dbm;
+
+	txpwr_level = priv->cur_cck_txpwridx;
+	txpwr_dbm = rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_B,
+						  txpwr_level);
+	txpwr_level = priv->cur_ofdm24g_txpwridx +
+		      priv->ofdm_tx_power_index_diff[1].a;
+
+	if (rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_G, txpwr_level)
+	    > txpwr_dbm)
+		txpwr_dbm = rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_G,
+							  txpwr_level);
+	txpwr_level = priv->cur_ofdm24g_txpwridx;
+	if (rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_N_24G,
+					  txpwr_level) > txpwr_dbm)
+		txpwr_dbm = rtl8xxxu_gen1_txpwridx_to_dbm(priv,
+							  WIRELESS_MODE_N_24G,
+							  txpwr_level);
+
+	return txpwr_dbm;
+}
+
 void
 rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
@@ -4540,6 +4589,19 @@ rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
 	return network_type;
 }
 
+static int rtl8xxxu_get_txpower(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif, int *dbm)
+{
+	struct rtl8xxxu_priv *priv = hw->priv;
+
+	if (!priv->fops->get_tx_power)
+		return -EOPNOTSUPP;
+
+	*dbm = priv->fops->get_tx_power(priv);
+
+	return 0;
+}
+
 static void rtl8xxxu_update_txpower(struct rtl8xxxu_priv *priv, int power)
 {
 	bool ht40 = false;
@@ -4569,10 +4631,12 @@ static void rtl8xxxu_update_txpower(struct rtl8xxxu_priv *priv, int power)
 	ofdm_txpwridx = priv->fops->dbm_to_txpwridx(priv, WIRELESS_MODE_N_24G,
 						    power);
 
-	if (ofdm_txpwridx - priv->ofdm_tx_power_index_diff[1].a > 0)
+	if (ofdm_txpwridx - priv->ofdm_tx_power_index_diff[1].a > 0) {
+		/* refer to rtlefuse->legacy_ht_txpowerdiff in vendor driver */
 		ofdm_txpwridx -= priv->ofdm_tx_power_index_diff[1].a;
-	else
+	} else {
 		ofdm_txpwridx = 0;
+	}
 
 	group = rtl8xxxu_gen1_channel_to_group(channel);
 
@@ -4586,6 +4650,9 @@ static void rtl8xxxu_update_txpower(struct rtl8xxxu_priv *priv, int power)
 		priv->ht40_1s_tx_power_index_B[i] = ofdm_txpwridx;
 	}
 
+	priv->cur_cck_txpwridx = priv->cck_tx_power_index_A[group];
+	priv->cur_ofdm24g_txpwridx = priv->ht40_1s_tx_power_index_A[group];
+
 	priv->fops->set_tx_power(priv, channel, ht40);
 }
 
@@ -6542,6 +6609,7 @@ static const struct ieee80211_ops rtl8xxxu_ops = {
 	.set_key = rtl8xxxu_set_key,
 	.ampdu_action = rtl8xxxu_ampdu_action,
 	.sta_statistics = rtl8xxxu_sta_statistics,
+	.get_txpower = rtl8xxxu_get_txpower,
 };
 
 static int rtl8xxxu_parse_usb(struct rtl8xxxu_priv *priv,
-- 
2.29.2

