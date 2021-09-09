Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5995D404D73
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345389AbhIIMCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346595AbhIIMAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63CA261407;
        Thu,  9 Sep 2021 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187967;
        bh=ncFFQWBsNb+6B0JOZkfTlATKlsRY4c4KX+ypRW7FOEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSsDS4zLtD77VcAInXPhAlkfeutvU/19h42lgomx5brwq+e0yzOvSGTAw/yJPpfvY
         vzMzmtGfuIB8owbLtg8RLYbJwNntfJ89ierN8tqYqmaagjYazZArjtX4I2LndJ7rPj
         sgvZS5W6UiZ3SyqzGkoe80qJ16AKcqOwW01Dc3dunmZcQlgbCS3D51vjtLNJClhtI2
         /0aKbiWTlowbh6j45d5WR2AtZNBtLYMZJCJdBVLfik+X449l4FaxO4fWtyhIeDmAZ1
         OAa79mTu9ZLNlUxnvV5IAV+rLrvoUQAfBgdCxgk7qQn0IAPnfEVn7galM5WRnKopK6
         jNldGFpUjkcqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 231/252] iwlwifi: mvm: avoid static queue number aliasing
Date:   Thu,  9 Sep 2021 07:40:45 -0400
Message-Id: <20210909114106.141462-231-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c6ce1c74ef2923b8ffd85f7f8b486f804f343b39 ]

When TVQM is enabled (iwl_mvm_has_new_tx_api() is true), then
queue numbers are just sequentially assigned 0, 1, 2, ...
Prior to TVQM, in DQA, there were some statically allocated
queue numbers:
 * IWL_MVM_DQA_AUX_QUEUE == 1,
 * both IWL_MVM_DQA_INJECT_MONITOR_QUEUE and
   IWL_MVM_DQA_P2P_DEVICE_QUEUE == 2, and
 * IWL_MVM_DQA_AP_PROBE_RESP_QUEUE == 9.

Now, these values are assigned to the members mvm->aux_queue,
mvm->snif_queue, mvm->probe_queue and mvm->p2p_dev_queue by
default. Normally, this doesn't really matter, and if TVQM is
in fact available we override them to the real values after
allocating a queue for use there.

However, this allocation doesn't always happen. For example,
for mvm->p2p_dev_queue (== 2) it only happens when the P2P
Device interface is started, if any. If it's not started, the
value in mvm->p2p_dev_queue remains 2. This wouldn't really
matter all that much if it weren't for iwl_mvm_is_static_queue()
which checks a queue number against one of those four static
numbers.

Now, if no P2P Device or monitor interface is added then queue
2 may be dynamically allocated, yet alias mvm->p2p_dev_queue or
mvm->snif_queue, and thus iwl_mvm_is_static_queue() erroneously
returns true for it. If it then gets full, all interface queues
are stopped, instead of just backpressuring against the one TXQ
that's really the only affected one.

This clearly can lead to issues, as everything is stopped even
if just a single TXQ filled its corresponding HW queue, if it
happens to have an appropriate number (2 or 9, AUX is always
reassigned.) Due to a mac80211 bug, this also led to a situation
in which the queues remained stopped across a deauthentication
and then attempts to connect to a new AP started failing, but
that's fixed separately.

Fix all of this by simply initializing the queue numbers to
the invalid value until they're used, if TVQM is enabled, and
also setting them back to that value when the queues are later
freed again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802172232.2e47e623f9e2.I9b0830dafbb68ef35b7b8f0f46160abec02ac7d0@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 24 +++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 30 ++++++++++++--------
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 20e8d343a950..b637cf9d85fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -792,10 +792,26 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	mvm->fw_restart = iwlwifi_mod_params.fw_restart ? -1 : 0;
 
-	mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
-	mvm->snif_queue = IWL_MVM_DQA_INJECT_MONITOR_QUEUE;
-	mvm->probe_queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
-	mvm->p2p_dev_queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+	if (iwl_mvm_has_new_tx_api(mvm)) {
+		/*
+		 * If we have the new TX/queue allocation API initialize them
+		 * all to invalid numbers. We'll rewrite the ones that we need
+		 * later, but that doesn't happen for all of them all of the
+		 * time (e.g. P2P Device is optional), and if a dynamic queue
+		 * ends up getting number 2 (IWL_MVM_DQA_P2P_DEVICE_QUEUE) then
+		 * iwl_mvm_is_static_queue() erroneously returns true, and we
+		 * might have things getting stuck.
+		 */
+		mvm->aux_queue = IWL_MVM_INVALID_QUEUE;
+		mvm->snif_queue = IWL_MVM_INVALID_QUEUE;
+		mvm->probe_queue = IWL_MVM_INVALID_QUEUE;
+		mvm->p2p_dev_queue = IWL_MVM_INVALID_QUEUE;
+	} else {
+		mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
+		mvm->snif_queue = IWL_MVM_DQA_INJECT_MONITOR_QUEUE;
+		mvm->probe_queue = IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
+		mvm->p2p_dev_queue = IWL_MVM_DQA_P2P_DEVICE_QUEUE;
+	}
 
 	mvm->sf_state = SF_UNINIT;
 	if (iwl_mvm_has_unified_ucode(mvm))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9c45a64c5009..252b81b1dc8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -316,8 +316,9 @@ static int iwl_mvm_invalidate_sta_queue(struct iwl_mvm *mvm, int queue,
 }
 
 static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			       int queue, u8 tid, u8 flags)
+			       u16 *queueptr, u8 tid, u8 flags)
 {
+	int queue = *queueptr;
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
 		.action = SCD_CFG_DISABLE_QUEUE,
@@ -326,6 +327,7 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		iwl_trans_txq_free(mvm->trans, queue);
+		*queueptr = IWL_MVM_INVALID_QUEUE;
 
 		return 0;
 	}
@@ -487,6 +489,7 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 	u8 sta_id, tid;
 	unsigned long disable_agg_tids = 0;
 	bool same_sta;
+	u16 queue_tmp = queue;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -509,7 +512,7 @@ static int iwl_mvm_free_inactive_queue(struct iwl_mvm *mvm, int queue,
 		iwl_mvm_invalidate_sta_queue(mvm, queue,
 					     disable_agg_tids, false);
 
-	ret = iwl_mvm_disable_txq(mvm, old_sta, queue, tid, 0);
+	ret = iwl_mvm_disable_txq(mvm, old_sta, &queue_tmp, tid, 0);
 	if (ret) {
 		IWL_ERR(mvm,
 			"Failed to free inactive queue %d (ret=%d)\n",
@@ -1184,6 +1187,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, mvmsta->vif, false, false);
 	int queue = -1;
+	u16 queue_tmp;
 	unsigned long disable_agg_tids = 0;
 	enum iwl_mvm_agg_state queue_state;
 	bool shared_queue = false, inc_ssn;
@@ -1332,7 +1336,8 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	return 0;
 
 out_err:
-	iwl_mvm_disable_txq(mvm, sta, queue, tid, 0);
+	queue_tmp = queue;
+	iwl_mvm_disable_txq(mvm, sta, &queue_tmp, tid, 0);
 
 	return ret;
 }
@@ -1779,7 +1784,7 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 		if (mvm_sta->tid_data[i].txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
-		iwl_mvm_disable_txq(mvm, sta, mvm_sta->tid_data[i].txq_id, i,
+		iwl_mvm_disable_txq(mvm, sta, &mvm_sta->tid_data[i].txq_id, i,
 				    0);
 		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
 	}
@@ -1987,7 +1992,7 @@ static int iwl_mvm_add_int_sta_with_queue(struct iwl_mvm *mvm, int macidx,
 	ret = iwl_mvm_add_int_sta_common(mvm, sta, addr, macidx, maccolor);
 	if (ret) {
 		if (!iwl_mvm_has_new_tx_api(mvm))
-			iwl_mvm_disable_txq(mvm, NULL, *queue,
+			iwl_mvm_disable_txq(mvm, NULL, queue,
 					    IWL_MAX_TID_COUNT, 0);
 		return ret;
 	}
@@ -2060,7 +2065,7 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN_ON_ONCE(mvm->snif_sta.sta_id == IWL_MVM_INVALID_STA))
 		return -EINVAL;
 
-	iwl_mvm_disable_txq(mvm, NULL, mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
+	iwl_mvm_disable_txq(mvm, NULL, &mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->snif_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -2077,7 +2082,7 @@ int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm)
 	if (WARN_ON_ONCE(mvm->aux_sta.sta_id == IWL_MVM_INVALID_STA))
 		return -EINVAL;
 
-	iwl_mvm_disable_txq(mvm, NULL, mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
+	iwl_mvm_disable_txq(mvm, NULL, &mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->aux_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -2173,7 +2178,7 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	int queue;
+	u16 *queueptr, queue;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -2182,10 +2187,10 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
-		queue = mvm->probe_queue;
+		queueptr = &mvm->probe_queue;
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		queue = mvm->p2p_dev_queue;
+		queueptr = &mvm->p2p_dev_queue;
 		break;
 	default:
 		WARN(1, "Can't free bcast queue on vif type %d\n",
@@ -2193,7 +2198,8 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 		return;
 	}
 
-	iwl_mvm_disable_txq(mvm, NULL, queue, IWL_MAX_TID_COUNT, 0);
+	queue = *queueptr;
+	iwl_mvm_disable_txq(mvm, NULL, queueptr, IWL_MAX_TID_COUNT, 0);
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
@@ -2428,7 +2434,7 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	iwl_mvm_flush_sta(mvm, &mvmvif->mcast_sta, true);
 
-	iwl_mvm_disable_txq(mvm, NULL, mvmvif->cab_queue, 0, 0);
+	iwl_mvm_disable_txq(mvm, NULL, &mvmvif->cab_queue, 0, 0);
 
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
 	if (ret)
-- 
2.30.2

