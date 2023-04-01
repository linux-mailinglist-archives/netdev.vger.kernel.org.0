Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242DD6D2CED
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 03:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjDABoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 21:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbjDABoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 21:44:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FBF1D2DA;
        Fri, 31 Mar 2023 18:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36D9AB832F8;
        Sat,  1 Apr 2023 01:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C62C433EF;
        Sat,  1 Apr 2023 01:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313400;
        bh=3l5a76GquH+vwdO1zyT2Wr837bfO5e5wQGOwPjqJ4oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRBhNwT72Uysv4qpDbPWIIqK9f+CkPvwFWVtR0AQRvuEjfL8B3RS46Wo2InWpeFRZ
         hJgM6NmHJNfIrwHhnlXgQIyGS9eK9NvpLg8v2HsZmRRGKixfVLwOFlbZhygZO3w77h
         dAot6FOyefmpDDvAEv9jk8wghbVmpVCj3etqcoq+/Vv/B2wRZzjn1ANYlh4aR/rXub
         VNSnEOe1lxnwY/6odPjnkejxhHftDq0Sw82d9lrwFHIsUehpRgQfpaIw4ncES9DE4g
         Br6TYL95RObphOM/CZ20w83dM/q6o0bCOefc09vSWHNpfFh7S5xR0pD9hOSm35mVx0
         qZzc47T+W55eA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Benjamin Berg <benjamin.berg@intel.com>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        Sasha Levin <sashal@kernel.org>, gregory.greenman@intel.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        miriam.rachel.korenblit@intel.com, avraham.stern@intel.com,
        shaul.triebitz@intel.com, quic_srirrama@quicinc.com,
        daniel.lezcano@linaro.org, ilan.peer@intel.com,
        haim.dreyfuss@intel.com, keescook@chromium.org,
        yedidya.ben.shimol@intel.com, ayala.barazani@intel.com,
        mordechay.goodstein@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/24] wifi: iwlwifi: mvm: fix mvmtxq->stopped handling
Date:   Fri, 31 Mar 2023 21:42:35 -0400
Message-Id: <20230401014242.3356780-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
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

[ Upstream commit b58e3d4311b54b6dd0e37165277965da0c9eb21d ]

This could race if the queue is redirected while full, then
the flushing internally would start it while it's not yet
usable again. Fix it by using two state bits instead of just
one.

Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Tested-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 4 ++--
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8464c9b7baf1f..23e1413ef4719 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -729,7 +729,10 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 
 	rcu_read_lock();
 	do {
-		while (likely(!mvmtxq->stopped &&
+		while (likely(!test_bit(IWL_MVM_TXQ_STATE_STOP_FULL,
+					&mvmtxq->state) &&
+			      !test_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT,
+					&mvmtxq->state) &&
 			      !test_bit(IWL_MVM_STATUS_IN_D3, &mvm->status))) {
 			skb = ieee80211_tx_dequeue(hw, txq);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1ccb3cad7cdc1..b5089349ebb7a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -729,7 +729,9 @@ struct iwl_mvm_txq {
 	struct list_head list;
 	u16 txq_id;
 	atomic_t tx_request;
-	bool stopped;
+#define IWL_MVM_TXQ_STATE_STOP_FULL	0
+#define IWL_MVM_TXQ_STATE_STOP_REDIRECT	1
+	unsigned long state;
 };
 
 static inline struct iwl_mvm_txq *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5b8e9a06f6d4a..79e151512fe73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1680,7 +1680,10 @@ static void iwl_mvm_queue_state_change(struct iwl_op_mode *op_mode,
 
 		txq = sta->txq[tid];
 		mvmtxq = iwl_mvm_txq_from_mac80211(txq);
-		mvmtxq->stopped = !start;
+		if (start)
+			clear_bit(IWL_MVM_TXQ_STATE_STOP_FULL, &mvmtxq->state);
+		else
+			set_bit(IWL_MVM_TXQ_STATE_STOP_FULL, &mvmtxq->state);
 
 		if (start && mvmsta->sta_state != IEEE80211_STA_NOTEXIST)
 			iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index cbd8053a9e35a..41b1b8b6c1e1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -692,7 +692,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 			    queue, iwl_mvm_ac_to_tx_fifo[ac]);
 
 	/* Stop the queue and wait for it to empty */
-	txq->stopped = true;
+	set_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	ret = iwl_trans_wait_tx_queues_empty(mvm->trans, BIT(queue));
 	if (ret) {
@@ -735,7 +735,7 @@ static int iwl_mvm_redirect_queue(struct iwl_mvm *mvm, int queue, int tid,
 
 out:
 	/* Continue using the queue */
-	txq->stopped = false;
+	clear_bit(IWL_MVM_TXQ_STATE_STOP_REDIRECT, &txq->state);
 
 	return ret;
 }
-- 
2.39.2

