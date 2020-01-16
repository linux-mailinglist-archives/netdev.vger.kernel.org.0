Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2148913F771
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbgAPRAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387664AbgAPRAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3835520728;
        Thu, 16 Jan 2020 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194007;
        bh=Bc4a90GgNt+53UllOU4U/kOkUJVjCw2i0sdjNuCUjNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ee61mccV7pamxZN8MHNcycecMu2ToPTyStAqIqoPs0l/KrWaEjhnOUSNqI8ClycAV
         PSZ/mn71wCPYDB8RYUGxXanrKUCRScfLuBadufaWyOnExIxDb2LYWkgwWQlbnm51SL
         NtUdXXyEvCzllyt+3PevW5g6Fqlmrbpf4ZID+KUA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 132/671] iwlwifi: mvm: avoid possible access out of array.
Date:   Thu, 16 Jan 2020 11:50:41 -0500
Message-Id: <20200116165940.10720-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit b0d795a9ae558209656b18930c2b4def5f8fdfb8 ]

The value in txq_id can be out of array scope,
validate it before accessing the array.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: cf961e16620f ("iwlwifi: mvm: support dqa-mode agg on non-shared queue")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e850aa504b60..69057701641e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2462,7 +2462,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
 	u16 normalized_ssn;
-	int txq_id;
+	u16 txq_id;
 	int ret;
 
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
@@ -2506,17 +2506,24 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 */
 	txq_id = mvmsta->tid_data[tid].txq_id;
 	if (txq_id == IWL_MVM_INVALID_QUEUE) {
-		txq_id = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
-						 IWL_MVM_DQA_MIN_DATA_QUEUE,
-						 IWL_MVM_DQA_MAX_DATA_QUEUE);
-		if (txq_id < 0) {
-			ret = txq_id;
+		ret = iwl_mvm_find_free_queue(mvm, mvmsta->sta_id,
+					      IWL_MVM_DQA_MIN_DATA_QUEUE,
+					      IWL_MVM_DQA_MAX_DATA_QUEUE);
+		if (ret < 0) {
 			IWL_ERR(mvm, "Failed to allocate agg queue\n");
 			goto release_locks;
 		}
 
+		txq_id = ret;
+
 		/* TXQ hasn't yet been enabled, so mark it only as reserved */
 		mvm->queue_info[txq_id].status = IWL_MVM_QUEUE_RESERVED;
+	} else if (WARN_ON(txq_id >= IWL_MAX_HW_QUEUES)) {
+		ret = -ENXIO;
+		IWL_ERR(mvm, "tid_id %d out of range (0, %d)!\n",
+			tid, IWL_MAX_HW_QUEUES - 1);
+		goto out;
+
 	} else if (unlikely(mvm->queue_info[txq_id].status ==
 			    IWL_MVM_QUEUE_SHARED)) {
 		ret = -ENXIO;
-- 
2.20.1

