Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B68E3BCDE7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhGFLYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhGFLVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E528761C68;
        Tue,  6 Jul 2021 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570268;
        bh=y6mFcJdQccM5MhzGdGdi5K6I15C5XktbLFX0Z45HUwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFugLAd1nFFDYkrDkSKo8iKe+DN3l01uKaF/N2F22V6o6b8qup0KyyLZhqwEXiJTw
         rBFYqpAnkZPqO1WWbInkUbzekVCVOjjF+/2MFSu7S5v/9Qci7EgT0WBRiHIX+zLTvv
         qRvhAdrDG3u7nTTvwgNQ5/WPs4VghKFySmyOcddYxfwId0VfJfG8hsUXM7D6EXkqjo
         qYtLu6sjIhIdXkmwjNBzfLS6r/ZATT/tSxjDx0YoDbHpj2tVE50dPtbWRPsns0W7wx
         gZq3M3H1esbTpEahdFqZjnrH+GTiYHXy64fkaqAJFUDo9eLqQnmXdnUYgiTv4D4JAb
         AArzy5vRYMbTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weilun Du <wdu@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 163/189] mac80211_hwsim: add concurrent channels scanning support over virtio
Date:   Tue,  6 Jul 2021 07:13:43 -0400
Message-Id: <20210706111409.2058071-163-sashal@kernel.org>
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

From: Weilun Du <wdu@google.com>

[ Upstream commit 626c30f9e77354301ff9162c3bdddaf92d9b5cf3 ]

This fixed the crash when setting channels to 2 or more when
communicating over virtio.

Signed-off-by: Weilun Du <wdu@google.com>
Link: https://lore.kernel.org/r/20210506180530.3418576-1-wdu@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 48 +++++++++++++++++++++------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7a6fd46d0c6e..ceb089e4a136 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -626,6 +626,7 @@ struct mac80211_hwsim_data {
 	u32 ciphers[ARRAY_SIZE(hwsim_ciphers)];
 
 	struct mac_address addresses[2];
+	struct ieee80211_chanctx_conf *chanctx;
 	int channels, idx;
 	bool use_chanctx;
 	bool destroy_on_close;
@@ -1257,7 +1258,8 @@ static inline u16 trans_tx_rate_flags_ieee2hwsim(struct ieee80211_tx_rate *rate)
 
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
-				       int dst_portid)
+				       int dst_portid,
+				       struct ieee80211_channel *channel)
 {
 	struct sk_buff *skb;
 	struct mac80211_hwsim_data *data = hw->priv;
@@ -1312,7 +1314,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	if (nla_put_u32(skb, HWSIM_ATTR_FLAGS, hwsim_flags))
 		goto nla_put_failure;
 
-	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, data->channel->center_freq))
+	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, channel->center_freq))
 		goto nla_put_failure;
 
 	/* We get the tx control (rate and retries) info*/
@@ -1659,7 +1661,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	_portid = READ_ONCE(data->wmediumd);
 
 	if (_portid || hwsim_virtio_enabled)
-		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid);
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _portid, channel);
 
 	/* NO wmediumd detected, perfect medium simulation */
 	data->tx_pkts++;
@@ -1775,7 +1777,7 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	mac80211_hwsim_monitor_rx(hw, skb, chan);
 
 	if (_pid || hwsim_virtio_enabled)
-		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid, chan);
 
 	mac80211_hwsim_tx_frame_no_nl(hw, skb, chan);
 	dev_kfree_skb(skb);
@@ -2514,6 +2516,11 @@ static int mac80211_hwsim_croc(struct ieee80211_hw *hw,
 static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
 				      struct ieee80211_chanctx_conf *ctx)
 {
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	mutex_lock(&hwsim->mutex);
+	hwsim->chanctx = ctx;
+	mutex_unlock(&hwsim->mutex);
 	hwsim_set_chanctx_magic(ctx);
 	wiphy_dbg(hw->wiphy,
 		  "add channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
@@ -2525,6 +2532,11 @@ static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
 static void mac80211_hwsim_remove_chanctx(struct ieee80211_hw *hw,
 					  struct ieee80211_chanctx_conf *ctx)
 {
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	mutex_lock(&hwsim->mutex);
+	hwsim->chanctx = NULL;
+	mutex_unlock(&hwsim->mutex);
 	wiphy_dbg(hw->wiphy,
 		  "remove channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
 		  ctx->def.chan->center_freq, ctx->def.width,
@@ -2537,6 +2549,11 @@ static void mac80211_hwsim_change_chanctx(struct ieee80211_hw *hw,
 					  struct ieee80211_chanctx_conf *ctx,
 					  u32 changed)
 {
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	mutex_lock(&hwsim->mutex);
+	hwsim->chanctx = ctx;
+	mutex_unlock(&hwsim->mutex);
 	hwsim_check_chanctx_magic(ctx);
 	wiphy_dbg(hw->wiphy,
 		  "change channel context control: %d MHz/width: %d/cfreqs:%d/%d MHz\n",
@@ -3129,6 +3146,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		hw->wiphy->max_remain_on_channel_duration = 1000;
 		data->if_combination.radar_detect_widths = 0;
 		data->if_combination.num_different_channels = data->channels;
+		data->chanctx = NULL;
 	} else {
 		data->if_combination.num_different_channels = 1;
 		data->if_combination.radar_detect_widths =
@@ -3638,6 +3656,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	int frame_data_len;
 	void *frame_data;
 	struct sk_buff *skb = NULL;
+	struct ieee80211_channel *channel = NULL;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
 	    !info->attrs[HWSIM_ATTR_FRAME] ||
@@ -3664,6 +3683,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	if (!data2)
 		goto out;
 
+	if (data2->use_chanctx) {
+		if (data2->tmp_chan)
+			channel = data2->tmp_chan;
+		else if (data2->chanctx)
+			channel = data2->chanctx->def.chan;
+	} else {
+		channel = data2->channel;
+	}
+	if (!channel)
+		goto out;
+
 	if (!hwsim_virtio_enabled) {
 		if (hwsim_net_get_netgroup(genl_info_net(info)) !=
 		    data2->netgroup)
@@ -3675,7 +3705,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* check if radio is configured properly */
 
-	if (data2->idle || !data2->started)
+	if ((data2->idle && !data2->tmp_chan) || !data2->started)
 		goto out;
 
 	/* A frame is received from user space */
@@ -3688,18 +3718,16 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		mutex_lock(&data2->mutex);
 		rx_status.freq = nla_get_u32(info->attrs[HWSIM_ATTR_FREQ]);
 
-		if (rx_status.freq != data2->channel->center_freq &&
-		    (!data2->tmp_chan ||
-		     rx_status.freq != data2->tmp_chan->center_freq)) {
+		if (rx_status.freq != channel->center_freq) {
 			mutex_unlock(&data2->mutex);
 			goto out;
 		}
 		mutex_unlock(&data2->mutex);
 	} else {
-		rx_status.freq = data2->channel->center_freq;
+		rx_status.freq = channel->center_freq;
 	}
 
-	rx_status.band = data2->channel->band;
+	rx_status.band = channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
-- 
2.30.2

