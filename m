Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3441645E4E3
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357663AbhKZChe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357466AbhKZCfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A2D611BD;
        Fri, 26 Nov 2021 02:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893930;
        bh=mdW5oRne/lsIVeTx12xheTMsO1H4lDBPQrs5Z/6yx28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTttSsZGuEJRvcxt+QxfJP4Xxge+vvPtSnIvlJaFg+gQduLG2Dheu/cxkdWekbQ36
         +HpaAUvnQCq36sLX3EU9NSLh6r4pNRaEDYV9kvhx6V+PLWXI1ohixX0xZBfsNKIG9Z
         tLXEOWpkb/NtGjJFZaiFmep9hn684imYN+O7lMpcubG28pHlLkiFqmcMn4LSFbhXx3
         ziotazOgSOjEwPVzPHrdVx/MbgnXKxIQGqB3g6TLXaW6Zao2uKtAmpbebCqOYYgYeF
         kamp8gv+dDU+oHsThRReeZm/Uxn0nhcySU1Grz4Jxd2e6eqDlML4Ly/L50tEmeTmuA
         rqOOPxSEo1yZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/39] mac80211: fix throughput LED trigger
Date:   Thu, 25 Nov 2021 21:31:24 -0500
Message-Id: <20211126023156.441292-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 30f6cf96912b638d0ddfc325204b598f94efddc2 ]

The codepaths for rx with decap offload and tx with itxq were not updating
the counters for the throughput led trigger.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20211113063415.55147-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/led.h |  8 ++++----
 net/mac80211/rx.c  |  7 ++++---
 net/mac80211/tx.c  | 34 +++++++++++++++-------------------
 3 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/led.h b/net/mac80211/led.h
index fb3aaa3c56069..b71a1428d883c 100644
--- a/net/mac80211/led.h
+++ b/net/mac80211/led.h
@@ -72,19 +72,19 @@ static inline void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
 #endif
 
 static inline void
-ieee80211_tpt_led_trig_tx(struct ieee80211_local *local, __le16 fc, int bytes)
+ieee80211_tpt_led_trig_tx(struct ieee80211_local *local, int bytes)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	if (ieee80211_is_data(fc) && atomic_read(&local->tpt_led_active))
+	if (atomic_read(&local->tpt_led_active))
 		local->tpt_led_trigger->tx_bytes += bytes;
 #endif
 }
 
 static inline void
-ieee80211_tpt_led_trig_rx(struct ieee80211_local *local, __le16 fc, int bytes)
+ieee80211_tpt_led_trig_rx(struct ieee80211_local *local, int bytes)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	if (ieee80211_is_data(fc) && atomic_read(&local->tpt_led_active))
+	if (atomic_read(&local->tpt_led_active))
 		local->tpt_led_trigger->rx_bytes += bytes;
 #endif
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ba3b82a72a604..bd5fb7e8d16db 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4874,6 +4874,7 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	WARN_ON_ONCE(softirq_count() == 0);
 
@@ -4970,9 +4971,9 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	if (!(status->flag & RX_FLAG_8023))
 		skb = ieee80211_rx_monitor(local, skb, rate);
 	if (skb) {
-		ieee80211_tpt_led_trig_rx(local,
-					  ((struct ieee80211_hdr *)skb->data)->frame_control,
-					  skb->len);
+		if ((status->flag & RX_FLAG_8023) ||
+			ieee80211_is_data_present(hdr->frame_control))
+			ieee80211_tpt_led_trig_rx(local, skb->len);
 
 		if (status->flag & RX_FLAG_8023)
 			__ieee80211_rx_handle_8023(hw, pubsta, skb, list);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8921088a5df65..0527bf41a32c7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1720,21 +1720,19 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
 static bool __ieee80211_tx(struct ieee80211_local *local,
-			   struct sk_buff_head *skbs, int led_len,
-			   struct sta_info *sta, bool txpending)
+			   struct sk_buff_head *skbs, struct sta_info *sta,
+			   bool txpending)
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_vif *vif;
 	struct sk_buff *skb;
 	bool result;
-	__le16 fc;
 
 	if (WARN_ON(skb_queue_empty(skbs)))
 		return true;
 
 	skb = skb_peek(skbs);
-	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
 	info = IEEE80211_SKB_CB(skb);
 	sdata = vif_to_sdata(info->control.vif);
 	if (sta && !sta->uploaded)
@@ -1768,8 +1766,6 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 
 	result = ieee80211_tx_frags(local, vif, sta, skbs, txpending);
 
-	ieee80211_tpt_led_trig_tx(local, fc, led_len);
-
 	WARN_ON_ONCE(!skb_queue_empty(skbs));
 
 	return result;
@@ -1919,7 +1915,6 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	bool result = true;
-	int led_len;
 
 	if (unlikely(skb->len < 10)) {
 		dev_kfree_skb(skb);
@@ -1927,7 +1922,6 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* initialises tx */
-	led_len = skb->len;
 	res_prepare = ieee80211_tx_prepare(sdata, &tx, sta, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
@@ -1950,8 +1944,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 		return true;
 
 	if (!invoke_tx_handlers_late(&tx))
-		result = __ieee80211_tx(local, &tx.skbs, led_len,
-					tx.sta, txpending);
+		result = __ieee80211_tx(local, &tx.skbs, tx.sta, txpending);
 
 	return result;
 }
@@ -4174,6 +4167,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct sk_buff *next;
+	int len = skb->len;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		kfree_skb(skb);
@@ -4220,10 +4214,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		}
 	} else {
 		/* we cannot process non-linear frames on this path */
-		if (skb_linearize(skb)) {
-			kfree_skb(skb);
-			goto out;
-		}
+		if (skb_linearize(skb))
+			goto out_free;
 
 		/* the frame could be fragmented, software-encrypted, and other
 		 * things so we cannot really handle checksum offload with it -
@@ -4257,7 +4249,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	goto out;
  out_free:
 	kfree_skb(skb);
+	len = 0;
  out:
+	if (len)
+		ieee80211_tpt_led_trig_tx(local, len);
 	rcu_read_unlock();
 }
 
@@ -4395,8 +4390,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 }
 
 static bool ieee80211_tx_8023(struct ieee80211_sub_if_data *sdata,
-			      struct sk_buff *skb, int led_len,
-			      struct sta_info *sta,
+			      struct sk_buff *skb, struct sta_info *sta,
 			      bool txpending)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -4409,6 +4403,8 @@ static bool ieee80211_tx_8023(struct ieee80211_sub_if_data *sdata,
 	if (sta)
 		sk_pacing_shift_update(skb->sk, local->hw.tx_sk_pacing_shift);
 
+	ieee80211_tpt_led_trig_tx(local, skb->len);
+
 	if (ieee80211_queue_skb(local, sdata, sta, skb))
 		return true;
 
@@ -4497,7 +4493,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	if (key)
 		info->control.hw_key = &key->conf;
 
-	ieee80211_tx_8023(sdata, skb, skb->len, sta, false);
+	ieee80211_tx_8023(sdata, skb, sta, false);
 
 	return;
 
@@ -4636,7 +4632,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		if (IS_ERR(sta) || (sta && !sta->uploaded))
 			sta = NULL;
 
-		result = ieee80211_tx_8023(sdata, skb, skb->len, sta, true);
+		result = ieee80211_tx_8023(sdata, skb, sta, true);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -4646,7 +4642,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		result = __ieee80211_tx(local, &skbs, skb->len, sta, true);
+		result = __ieee80211_tx(local, &skbs, sta, true);
 	}
 
 	return result;
-- 
2.33.0

