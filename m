Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBA13F392
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436964AbgAPSmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:42:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389810AbgAPRLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC4C24690;
        Thu, 16 Jan 2020 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194681;
        bh=r6eCXRPPZwo5bYbTTW30XCpH68ldk4y6LUJDchpW7g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj1A0PeXni2kd3881r8WJzdxHxbFxFJGd8PQOiw23TgOg0jabNg1032ZLngdy0Pnn
         6Fs+sS5XFyXO46PuaVokStQpRpmcr+zQGragU6rifNnhDoB0u1pwQV2ieURo8f+zd/
         euFO0DlxGkQfbMz8XcI6t0JUr2cmI1rScdcM3JZ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 526/671] wcn36xx: use dynamic allocation for large variables
Date:   Thu, 16 Jan 2020 12:02:44 -0500
Message-Id: <20200116170509.12787-263-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 355cf31912014e6ff1bb1019ae4858cad12c68cf ]

clang triggers a warning about oversized stack frames that gcc does not
notice because of slightly different inlining decisions:

ath/wcn36xx/smd.c:1409:5: error: stack frame size of 1040 bytes in function 'wcn36xx_smd_config_bss' [-Werror,-Wframe-larger-than=]
ath/wcn36xx/smd.c:640:5: error: stack frame size of 1032 bytes in function 'wcn36xx_smd_start_hw_scan' [-Werror,-Wframe-larger-than=]

Basically the wcn36xx_hal_start_scan_offload_req_msg,
wcn36xx_hal_config_bss_req_msg_v1, and wcn36xx_hal_config_bss_req_msg
structures are too large to be put on the kernel stack, but small
enough that gcc does not warn about them.

Use kzalloc() to allocate them all. There are similar structures in other
parts of this driver, but they are all smaller, with the next largest
stack frame at 480 bytes for wcn36xx_smd_send_beacon.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 186 ++++++++++++++-----------
 1 file changed, 105 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 00098f24116d..6cd113b3b3e4 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -641,52 +641,58 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 			      struct cfg80211_scan_request *req)
 {
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
-	struct wcn36xx_hal_start_scan_offload_req_msg msg_body;
+	struct wcn36xx_hal_start_scan_offload_req_msg *msg_body;
 	int ret, i;
 
 	if (req->ie_len > WCN36XX_MAX_SCAN_IE_LEN)
 		return -EINVAL;
 
 	mutex_lock(&wcn->hal_mutex);
-	INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_SCAN_OFFLOAD_REQ);
+	msg_body = kzalloc(sizeof(*msg_body), GFP_KERNEL);
+	if (!msg_body) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	msg_body.scan_type = WCN36XX_HAL_SCAN_TYPE_ACTIVE;
-	msg_body.min_ch_time = 30;
-	msg_body.max_ch_time = 100;
-	msg_body.scan_hidden = 1;
-	memcpy(msg_body.mac, vif->addr, ETH_ALEN);
-	msg_body.bss_type = vif_priv->bss_type;
-	msg_body.p2p_search = vif->p2p;
+	INIT_HAL_MSG((*msg_body), WCN36XX_HAL_START_SCAN_OFFLOAD_REQ);
 
-	msg_body.num_ssid = min_t(u8, req->n_ssids, ARRAY_SIZE(msg_body.ssids));
-	for (i = 0; i < msg_body.num_ssid; i++) {
-		msg_body.ssids[i].length = min_t(u8, req->ssids[i].ssid_len,
-						sizeof(msg_body.ssids[i].ssid));
-		memcpy(msg_body.ssids[i].ssid, req->ssids[i].ssid,
-		       msg_body.ssids[i].length);
+	msg_body->scan_type = WCN36XX_HAL_SCAN_TYPE_ACTIVE;
+	msg_body->min_ch_time = 30;
+	msg_body->max_ch_time = 100;
+	msg_body->scan_hidden = 1;
+	memcpy(msg_body->mac, vif->addr, ETH_ALEN);
+	msg_body->bss_type = vif_priv->bss_type;
+	msg_body->p2p_search = vif->p2p;
+
+	msg_body->num_ssid = min_t(u8, req->n_ssids, ARRAY_SIZE(msg_body->ssids));
+	for (i = 0; i < msg_body->num_ssid; i++) {
+		msg_body->ssids[i].length = min_t(u8, req->ssids[i].ssid_len,
+						sizeof(msg_body->ssids[i].ssid));
+		memcpy(msg_body->ssids[i].ssid, req->ssids[i].ssid,
+		       msg_body->ssids[i].length);
 	}
 
-	msg_body.num_channel = min_t(u8, req->n_channels,
-				     sizeof(msg_body.channels));
-	for (i = 0; i < msg_body.num_channel; i++)
-		msg_body.channels[i] = req->channels[i]->hw_value;
+	msg_body->num_channel = min_t(u8, req->n_channels,
+				     sizeof(msg_body->channels));
+	for (i = 0; i < msg_body->num_channel; i++)
+		msg_body->channels[i] = req->channels[i]->hw_value;
 
-	msg_body.header.len -= WCN36XX_MAX_SCAN_IE_LEN;
+	msg_body->header.len -= WCN36XX_MAX_SCAN_IE_LEN;
 
 	if (req->ie_len > 0) {
-		msg_body.ie_len = req->ie_len;
-		msg_body.header.len += req->ie_len;
-		memcpy(msg_body.ie, req->ie, req->ie_len);
+		msg_body->ie_len = req->ie_len;
+		msg_body->header.len += req->ie_len;
+		memcpy(msg_body->ie, req->ie, req->ie_len);
 	}
 
-	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
+	PREPARE_HAL_BUF(wcn->hal_buf, (*msg_body));
 
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
 		    "hal start hw-scan (channels: %u; ssids: %u; p2p: %s)\n",
-		    msg_body.num_channel, msg_body.num_ssid,
-		    msg_body.p2p_search ? "yes" : "no");
+		    msg_body->num_channel, msg_body->num_ssid,
+		    msg_body->p2p_search ? "yes" : "no");
 
-	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
+	ret = wcn36xx_smd_send_and_wait(wcn, msg_body->header.len);
 	if (ret) {
 		wcn36xx_err("Sending hal_start_scan_offload failed\n");
 		goto out;
@@ -698,6 +704,7 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 		goto out;
 	}
 out:
+	kfree(msg_body);
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
 }
@@ -1257,96 +1264,104 @@ int wcn36xx_smd_config_sta(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 static int wcn36xx_smd_config_bss_v1(struct wcn36xx *wcn,
 			const struct wcn36xx_hal_config_bss_req_msg *orig)
 {
-	struct wcn36xx_hal_config_bss_req_msg_v1 msg_body;
-	struct wcn36xx_hal_config_bss_params_v1 *bss = &msg_body.bss_params;
-	struct wcn36xx_hal_config_sta_params_v1 *sta = &bss->sta;
+	struct wcn36xx_hal_config_bss_req_msg_v1 *msg_body;
+	struct wcn36xx_hal_config_bss_params_v1 *bss;
+	struct wcn36xx_hal_config_sta_params_v1 *sta;
+	int ret;
+
+	msg_body = kzalloc(sizeof(*msg_body), GFP_KERNEL);
+	if (!msg_body)
+		return -ENOMEM;
+
+	INIT_HAL_MSG((*msg_body), WCN36XX_HAL_CONFIG_BSS_REQ);
 
-	INIT_HAL_MSG(msg_body, WCN36XX_HAL_CONFIG_BSS_REQ);
+	bss = &msg_body->bss_params;
+	sta = &bss->sta;
 
 	/* convert orig to v1 */
-	memcpy(&msg_body.bss_params.bssid,
+	memcpy(&msg_body->bss_params.bssid,
 	       &orig->bss_params.bssid, ETH_ALEN);
-	memcpy(&msg_body.bss_params.self_mac_addr,
+	memcpy(&msg_body->bss_params.self_mac_addr,
 	       &orig->bss_params.self_mac_addr, ETH_ALEN);
 
-	msg_body.bss_params.bss_type = orig->bss_params.bss_type;
-	msg_body.bss_params.oper_mode = orig->bss_params.oper_mode;
-	msg_body.bss_params.nw_type = orig->bss_params.nw_type;
+	msg_body->bss_params.bss_type = orig->bss_params.bss_type;
+	msg_body->bss_params.oper_mode = orig->bss_params.oper_mode;
+	msg_body->bss_params.nw_type = orig->bss_params.nw_type;
 
-	msg_body.bss_params.short_slot_time_supported =
+	msg_body->bss_params.short_slot_time_supported =
 		orig->bss_params.short_slot_time_supported;
-	msg_body.bss_params.lla_coexist = orig->bss_params.lla_coexist;
-	msg_body.bss_params.llb_coexist = orig->bss_params.llb_coexist;
-	msg_body.bss_params.llg_coexist = orig->bss_params.llg_coexist;
-	msg_body.bss_params.ht20_coexist = orig->bss_params.ht20_coexist;
-	msg_body.bss_params.lln_non_gf_coexist =
+	msg_body->bss_params.lla_coexist = orig->bss_params.lla_coexist;
+	msg_body->bss_params.llb_coexist = orig->bss_params.llb_coexist;
+	msg_body->bss_params.llg_coexist = orig->bss_params.llg_coexist;
+	msg_body->bss_params.ht20_coexist = orig->bss_params.ht20_coexist;
+	msg_body->bss_params.lln_non_gf_coexist =
 		orig->bss_params.lln_non_gf_coexist;
 
-	msg_body.bss_params.lsig_tx_op_protection_full_support =
+	msg_body->bss_params.lsig_tx_op_protection_full_support =
 		orig->bss_params.lsig_tx_op_protection_full_support;
-	msg_body.bss_params.rifs_mode = orig->bss_params.rifs_mode;
-	msg_body.bss_params.beacon_interval = orig->bss_params.beacon_interval;
-	msg_body.bss_params.dtim_period = orig->bss_params.dtim_period;
-	msg_body.bss_params.tx_channel_width_set =
+	msg_body->bss_params.rifs_mode = orig->bss_params.rifs_mode;
+	msg_body->bss_params.beacon_interval = orig->bss_params.beacon_interval;
+	msg_body->bss_params.dtim_period = orig->bss_params.dtim_period;
+	msg_body->bss_params.tx_channel_width_set =
 		orig->bss_params.tx_channel_width_set;
-	msg_body.bss_params.oper_channel = orig->bss_params.oper_channel;
-	msg_body.bss_params.ext_channel = orig->bss_params.ext_channel;
+	msg_body->bss_params.oper_channel = orig->bss_params.oper_channel;
+	msg_body->bss_params.ext_channel = orig->bss_params.ext_channel;
 
-	msg_body.bss_params.reserved = orig->bss_params.reserved;
+	msg_body->bss_params.reserved = orig->bss_params.reserved;
 
-	memcpy(&msg_body.bss_params.ssid,
+	memcpy(&msg_body->bss_params.ssid,
 	       &orig->bss_params.ssid,
 	       sizeof(orig->bss_params.ssid));
 
-	msg_body.bss_params.action = orig->bss_params.action;
-	msg_body.bss_params.rateset = orig->bss_params.rateset;
-	msg_body.bss_params.ht = orig->bss_params.ht;
-	msg_body.bss_params.obss_prot_enabled =
+	msg_body->bss_params.action = orig->bss_params.action;
+	msg_body->bss_params.rateset = orig->bss_params.rateset;
+	msg_body->bss_params.ht = orig->bss_params.ht;
+	msg_body->bss_params.obss_prot_enabled =
 		orig->bss_params.obss_prot_enabled;
-	msg_body.bss_params.rmf = orig->bss_params.rmf;
-	msg_body.bss_params.ht_oper_mode = orig->bss_params.ht_oper_mode;
-	msg_body.bss_params.dual_cts_protection =
+	msg_body->bss_params.rmf = orig->bss_params.rmf;
+	msg_body->bss_params.ht_oper_mode = orig->bss_params.ht_oper_mode;
+	msg_body->bss_params.dual_cts_protection =
 		orig->bss_params.dual_cts_protection;
 
-	msg_body.bss_params.max_probe_resp_retry_limit =
+	msg_body->bss_params.max_probe_resp_retry_limit =
 		orig->bss_params.max_probe_resp_retry_limit;
-	msg_body.bss_params.hidden_ssid = orig->bss_params.hidden_ssid;
-	msg_body.bss_params.proxy_probe_resp =
+	msg_body->bss_params.hidden_ssid = orig->bss_params.hidden_ssid;
+	msg_body->bss_params.proxy_probe_resp =
 		orig->bss_params.proxy_probe_resp;
-	msg_body.bss_params.edca_params_valid =
+	msg_body->bss_params.edca_params_valid =
 		orig->bss_params.edca_params_valid;
 
-	memcpy(&msg_body.bss_params.acbe,
+	memcpy(&msg_body->bss_params.acbe,
 	       &orig->bss_params.acbe,
 	       sizeof(orig->bss_params.acbe));
-	memcpy(&msg_body.bss_params.acbk,
+	memcpy(&msg_body->bss_params.acbk,
 	       &orig->bss_params.acbk,
 	       sizeof(orig->bss_params.acbk));
-	memcpy(&msg_body.bss_params.acvi,
+	memcpy(&msg_body->bss_params.acvi,
 	       &orig->bss_params.acvi,
 	       sizeof(orig->bss_params.acvi));
-	memcpy(&msg_body.bss_params.acvo,
+	memcpy(&msg_body->bss_params.acvo,
 	       &orig->bss_params.acvo,
 	       sizeof(orig->bss_params.acvo));
 
-	msg_body.bss_params.ext_set_sta_key_param_valid =
+	msg_body->bss_params.ext_set_sta_key_param_valid =
 		orig->bss_params.ext_set_sta_key_param_valid;
 
-	memcpy(&msg_body.bss_params.ext_set_sta_key_param,
+	memcpy(&msg_body->bss_params.ext_set_sta_key_param,
 	       &orig->bss_params.ext_set_sta_key_param,
 	       sizeof(orig->bss_params.acvo));
 
-	msg_body.bss_params.wcn36xx_hal_persona =
+	msg_body->bss_params.wcn36xx_hal_persona =
 		orig->bss_params.wcn36xx_hal_persona;
-	msg_body.bss_params.spectrum_mgt_enable =
+	msg_body->bss_params.spectrum_mgt_enable =
 		orig->bss_params.spectrum_mgt_enable;
-	msg_body.bss_params.tx_mgmt_power = orig->bss_params.tx_mgmt_power;
-	msg_body.bss_params.max_tx_power = orig->bss_params.max_tx_power;
+	msg_body->bss_params.tx_mgmt_power = orig->bss_params.tx_mgmt_power;
+	msg_body->bss_params.max_tx_power = orig->bss_params.max_tx_power;
 
 	wcn36xx_smd_convert_sta_to_v1(wcn, &orig->bss_params.sta,
-				      &msg_body.bss_params.sta);
+				      &msg_body->bss_params.sta);
 
-	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
+	PREPARE_HAL_BUF(wcn->hal_buf, (*msg_body));
 
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
 		    "hal config bss v1 bssid %pM self_mac_addr %pM bss_type %d oper_mode %d nw_type %d\n",
@@ -1358,7 +1373,10 @@ static int wcn36xx_smd_config_bss_v1(struct wcn36xx *wcn,
 		    sta->bssid, sta->action, sta->sta_index,
 		    sta->bssid_index, sta->aid, sta->type, sta->mac);
 
-	return wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
+	ret = wcn36xx_smd_send_and_wait(wcn, msg_body->header.len);
+	kfree(msg_body);
+
+	return ret;
 }
 
 
@@ -1410,16 +1428,21 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta, const u8 *bssid,
 			   bool update)
 {
-	struct wcn36xx_hal_config_bss_req_msg msg;
+	struct wcn36xx_hal_config_bss_req_msg *msg;
 	struct wcn36xx_hal_config_bss_params *bss;
 	struct wcn36xx_hal_config_sta_params *sta_params;
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
 	int ret;
 
 	mutex_lock(&wcn->hal_mutex);
-	INIT_HAL_MSG(msg, WCN36XX_HAL_CONFIG_BSS_REQ);
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	INIT_HAL_MSG((*msg), WCN36XX_HAL_CONFIG_BSS_REQ);
 
-	bss = &msg.bss_params;
+	bss = &msg->bss_params;
 	sta_params = &bss->sta;
 
 	WARN_ON(is_zero_ether_addr(bssid));
@@ -1514,11 +1537,11 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 		    sta_params->mac);
 
 	if (!wcn36xx_is_fw_version(wcn, 1, 2, 2, 24)) {
-		ret = wcn36xx_smd_config_bss_v1(wcn, &msg);
+		ret = wcn36xx_smd_config_bss_v1(wcn, msg);
 	} else {
-		PREPARE_HAL_BUF(wcn->hal_buf, msg);
+		PREPARE_HAL_BUF(wcn->hal_buf, (*msg));
 
-		ret = wcn36xx_smd_send_and_wait(wcn, msg.header.len);
+		ret = wcn36xx_smd_send_and_wait(wcn, msg->header.len);
 	}
 	if (ret) {
 		wcn36xx_err("Sending hal_config_bss failed\n");
@@ -1534,6 +1557,7 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 		goto out;
 	}
 out:
+	kfree(msg);
 	mutex_unlock(&wcn->hal_mutex);
 	return ret;
 }
-- 
2.20.1

