Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B703801EA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhENC1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhENC1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:27:33 -0400
Received: from mxout013.mail.hostpoint.ch (mxout013.mail.hostpoint.ch [IPv6:2a00:d70:0:e::313])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF2EC061574;
        Thu, 13 May 2021 19:26:22 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout013.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCK-000HmU-VR; Fri, 14 May 2021 04:05:04 +0200
Received: from [2a02:168:6182:1:4ea5:a8cc:a141:509c] (helo=ryzen2700.home.reto-schneider.ch)
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCK-000L6T-Ne; Fri, 14 May 2021 04:05:04 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 7/7] rtl8xxxu: Fix ampdu_action to get block ack session work
Date:   Fri, 14 May 2021 04:04:42 +0200
Message-Id: <20210514020442.946-8-code@reto-schneider.ch>
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

The HAS_RATE_CONTROL hw capability needs to be unset for the mac80211
rate control to work. The mac80211 rate control will be in charge
of the TX aggregation related work so the AMPDU TX part in each
driver should be modified accordingly.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
(cherry picked from commit c470f7aed67f223d941e3da6e9d2a464dd0083ee)

Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  1 +
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 35 ++++++++++++-------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 3d16d6c9ff39..65620ecf9ac2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1384,6 +1384,7 @@ struct rtl8xxxu_priv {
 	u8 no_pape:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
 	u8 rssi_level;
+	u8 agg_state_bitmap;
 	/*
 	 * Only one virtual interface permitted because only STA mode
 	 * is supported and no iface_combinations are provided.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 088e007e8bd0..7ce27d1bb27a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5030,6 +5030,8 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u32 rate;
 	u16 rate_flags = tx_info->control.rates[0].flags;
 	u16 seq_number;
@@ -5053,10 +5055,12 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 
 	tx_desc->txdw3 = cpu_to_le32((u32)seq_number << TXDESC32_SEQ_SHIFT);
 
-	if (ampdu_enable)
+	if (ampdu_enable && (priv->agg_state_bitmap & BIT(tid)) &&
+	    (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 		tx_desc->txdw1 |= cpu_to_le32(TXDESC32_AGG_ENABLE);
-	else
+	} else {
 		tx_desc->txdw1 |= cpu_to_le32(TXDESC32_AGG_BREAK);
+	}
 
 	if (ieee80211_is_mgmt(hdr->frame_control)) {
 		tx_desc->txdw5 = cpu_to_le32(rate);
@@ -5101,6 +5105,8 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
 	struct rtl8xxxu_txdesc40 *tx_desc40;
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u32 rate;
 	u16 rate_flags = tx_info->control.rates[0].flags;
 	u16 seq_number;
@@ -5127,10 +5133,13 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 
 	tx_desc40->txdw9 = cpu_to_le32((u32)seq_number << TXDESC40_SEQ_SHIFT);
 
-	if (ampdu_enable)
+	if (ampdu_enable && (priv->agg_state_bitmap & BIT(tid)) &&
+	    (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 		tx_desc40->txdw2 |= cpu_to_le32(TXDESC40_AGG_ENABLE);
-	else
+		tx_desc40->txdw3 |= cpu_to_le32(0x1f << 17);
+	} else {
 		tx_desc40->txdw2 |= cpu_to_le32(TXDESC40_AGG_BREAK);
+	}
 
 	if (ieee80211_is_mgmt(hdr->frame_control)) {
 		tx_desc40->txdw4 = cpu_to_le32(rate);
@@ -6299,6 +6308,7 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct device *dev = &priv->udev->dev;
 	u8 ampdu_factor, ampdu_density;
 	struct ieee80211_sta *sta = params->sta;
+	u16 tid = params->tid;
 	enum ieee80211_ampdu_mlme_action action = params->action;
 
 	switch (action) {
@@ -6311,17 +6321,19 @@ rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		dev_dbg(dev,
 			"Changed HT: ampdu_factor %02x, ampdu_density %02x\n",
 			ampdu_factor, ampdu_density);
-		break;
+		return IEEE80211_AMPDU_TX_START_IMMEDIATE;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
-		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH\n", __func__);
-		rtl8xxxu_set_ampdu_factor(priv, 0);
-		rtl8xxxu_set_ampdu_min_space(priv, 0);
-		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP_FLUSH_CONT\n",
-			 __func__);
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_STOP\n", __func__);
 		rtl8xxxu_set_ampdu_factor(priv, 0);
 		rtl8xxxu_set_ampdu_min_space(priv, 0);
+		priv->agg_state_bitmap &= ~BIT(tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		dev_dbg(dev, "%s: IEEE80211_AMPDU_TX_OPERATIONAL\n", __func__);
+		priv->agg_state_bitmap |= BIT(tid);
 		break;
 	case IEEE80211_AMPDU_RX_START:
 		dev_dbg(dev, "%s: IEEE80211_AMPDU_RX_START\n", __func__);
@@ -6893,7 +6905,6 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	/*
 	 * The firmware handles rate control
 	 */
-	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
-- 
2.29.2

