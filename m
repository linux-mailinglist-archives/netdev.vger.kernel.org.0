Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6954E6D2CF1
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 03:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbjDABon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 21:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbjDABoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 21:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B71E716;
        Fri, 31 Mar 2023 18:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C24AC62CF0;
        Sat,  1 Apr 2023 01:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66CCC4339B;
        Sat,  1 Apr 2023 01:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313340;
        bh=pjCcLZxo+EFkCs/lSuGJLRLlxrBSP+qNbohOLc9Q8l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2ViZXf7Il7KS08ofW9BP2iOXHod5PNhXo9mlNfyTQ3NynOyV0wv8MnKni6Mrm7lX
         dNbq+5Eg2pXVT4QFjngudQaPZegKrEcnV67aCVSnr5Ck+p0T20o+UwKMWQvNod53At
         f2AWDEBjDdOBquwNnwICGvqoaRmpY1oRqkCSVvuZFBDSpb9S4LAPVaYbOdHF/Q1GLn
         8Ugi5yeWENQAfqq3V0qA93TbB91U1RNF2ubmn45BEmxlYEKXrwHne0nsgCt67oSqW1
         I/5lGRywK5FkIes7EWpyJm1XsD3+GeZ53hN74Z4rTCcZH3xvyPSVg/qTJGlpZS6XF7
         gzcRbPnG3ThSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Benjamin Berg <benjamin.berg@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Sasha Levin <sashal@kernel.org>, gregory.greenman@intel.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, avraham.stern@intel.com,
        miriam.rachel.korenblit@intel.com, shaul.triebitz@intel.com,
        quic_srirrama@quicinc.com, haim.dreyfuss@intel.com,
        ilan.peer@intel.com, keescook@chromium.org,
        daniel.lezcano@linaro.org, yedidya.ben.shimol@intel.com,
        mordechay.goodstein@intel.com, rostedt@goodmis.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 21/25] wifi: iwlwifi: mvm: protect TXQ list manipulation
Date:   Fri, 31 Mar 2023 21:41:19 -0400
Message-Id: <20230401014126.3356410-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 923bf981eb6ecc027227716e30701bdcc1845fbf ]

Some recent upstream debugging uncovered the fact that in
iwlwifi, the TXQ list manipulation is racy.

Introduce a new state bit for when the TXQ is completely
ready and can be used without locking, and if that's not
set yet acquire the lock to check everything correctly.

Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Tested-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 45 ++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 25 +++++++++--
 4 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5b4974181ff1c..1d46a2b345eb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -760,42 +760,25 @@ static void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_txq *mvmtxq = iwl_mvm_txq_from_mac80211(txq);
 
-	/*
-	 * Please note that racing is handled very carefully here:
-	 * mvmtxq->txq_id is updated during allocation, and mvmtxq->list is
-	 * deleted afterwards.
-	 * This means that if:
-	 * mvmtxq->txq_id != INVALID_QUEUE && list_empty(&mvmtxq->list):
-	 *	queue is allocated and we can TX.
-	 * mvmtxq->txq_id != INVALID_QUEUE && !list_empty(&mvmtxq->list):
-	 *	a race, should defer the frame.
-	 * mvmtxq->txq_id == INVALID_QUEUE && list_empty(&mvmtxq->list):
-	 *	need to allocate the queue and defer the frame.
-	 * mvmtxq->txq_id == INVALID_QUEUE && !list_empty(&mvmtxq->list):
-	 *	queue is already scheduled for allocation, no need to allocate,
-	 *	should defer the frame.
-	 */
-
-	/* If the queue is allocated TX and return. */
-	if (!txq->sta || mvmtxq->txq_id != IWL_MVM_INVALID_QUEUE) {
-		/*
-		 * Check that list is empty to avoid a race where txq_id is
-		 * already updated, but the queue allocation work wasn't
-		 * finished
-		 */
-		if (unlikely(txq->sta && !list_empty(&mvmtxq->list)))
-			return;
-
+	if (likely(test_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state)) ||
+	    !txq->sta) {
 		iwl_mvm_mac_itxq_xmit(hw, txq);
 		return;
 	}
 
-	/* The list is being deleted only after the queue is fully allocated. */
-	if (!list_empty(&mvmtxq->list))
-		return;
+	/* iwl_mvm_mac_itxq_xmit() will later be called by the worker
+	 * to handle any packets we leave on the txq now
+	 */
 
-	list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
-	schedule_work(&mvm->add_stream_wk);
+	spin_lock_bh(&mvm->add_stream_lock);
+	/* The list is being deleted only after the queue is fully allocated. */
+	if (list_empty(&mvmtxq->list) &&
+	    /* recheck under lock */
+	    !test_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state)) {
+		list_add_tail(&mvmtxq->list, &mvm->add_stream_txqs);
+		schedule_work(&mvm->add_stream_wk);
+	}
+	spin_unlock_bh(&mvm->add_stream_lock);
 }
 
 #define CHECK_BA_TRIGGER(_mvm, _trig, _tid_bm, _tid, _fmt...)		\
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 3146b3d02bae8..157de77e129e4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -731,6 +731,7 @@ struct iwl_mvm_txq {
 	atomic_t tx_request;
 #define IWL_MVM_TXQ_STATE_STOP_FULL	0
 #define IWL_MVM_TXQ_STATE_STOP_REDIRECT	1
+#define IWL_MVM_TXQ_STATE_READY		2
 	unsigned long state;
 };
 
@@ -829,6 +830,7 @@ struct iwl_mvm {
 		struct iwl_mvm_tvqm_txq_info tvqm_info[IWL_MAX_TVQM_QUEUES];
 	};
 	struct work_struct add_stream_wk; /* To add streams to queues */
+	spinlock_t add_stream_lock;
 
 	const char *nvm_file_name;
 	struct iwl_nvm_data *nvm_data;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f43e617fb451f..c49a2a1ee4867 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1194,6 +1194,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_DELAYED_WORK(&mvm->scan_timeout_dwork, iwl_mvm_scan_timeout_wk);
 	INIT_WORK(&mvm->add_stream_wk, iwl_mvm_add_new_dqa_stream_wk);
 	INIT_LIST_HEAD(&mvm->add_stream_txqs);
+	spin_lock_init(&mvm->add_stream_lock);
 
 	init_waitqueue_head(&mvm->rx_sync_waitq);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 21ad7b85c434c..9caae77995ca9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -384,8 +384,11 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		struct iwl_mvm_txq *mvmtxq =
 			iwl_mvm_txq_from_tid(sta, tid);
 
-		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_lock_bh(&mvm->add_stream_lock);
 		list_del_init(&mvmtxq->list);
+		clear_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_unlock_bh(&mvm->add_stream_lock);
 	}
 
 	/* Regardless if this is a reserved TXQ for a STA - mark it as false */
@@ -479,8 +482,11 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 			disable_agg_tids |= BIT(tid);
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 
-		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_lock_bh(&mvm->add_stream_lock);
 		list_del_init(&mvmtxq->list);
+		clear_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
+		spin_unlock_bh(&mvm->add_stream_lock);
 	}
 
 	mvmsta->tfd_queue_msk &= ~BIT(queue); /* Don't use this queue anymore */
@@ -1444,12 +1450,22 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 		 * a queue in the function itself.
 		 */
 		if (iwl_mvm_sta_alloc_queue(mvm, txq->sta, txq->ac, tid)) {
+			spin_lock_bh(&mvm->add_stream_lock);
 			list_del_init(&mvmtxq->list);
+			spin_unlock_bh(&mvm->add_stream_lock);
 			continue;
 		}
 
-		list_del_init(&mvmtxq->list);
+		/* now we're ready, any remaining races/concurrency will be
+		 * handled in iwl_mvm_mac_itxq_xmit()
+		 */
+		set_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+
 		local_bh_disable();
+		spin_lock(&mvm->add_stream_lock);
+		list_del_init(&mvmtxq->list);
+		spin_unlock(&mvm->add_stream_lock);
+
 		iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
 		local_bh_enable();
 	}
@@ -1864,8 +1880,11 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 		struct iwl_mvm_txq *mvmtxq =
 			iwl_mvm_txq_from_mac80211(sta->txq[i]);
 
+		spin_lock_bh(&mvm->add_stream_lock);
 		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
 		list_del_init(&mvmtxq->list);
+		clear_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		spin_unlock_bh(&mvm->add_stream_lock);
 	}
 }
 
-- 
2.39.2

