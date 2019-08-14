Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEABE8C623
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfHNCNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728125AbfHNCNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9652120842;
        Wed, 14 Aug 2019 02:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748783;
        bh=m9sBYGnmv53rPv9LLP7lEr4T1EH5recboZhvcMtI5ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2wC9ZTqk7yBn8uTOxJyrdwDSi2DgB9VnWM6zDz4RvvCHFkYjtkTWwv7LGjmoOB5u
         ueaFUVQLd7ti5uPUb/qnQj4qLBPm01PBGEIXkhyTBBPVKVqxCd7+v//NFouD2zLZXK
         GUCXOMlSgNjXia2DuycjZrmerHiLYho/XZ2jolzg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 062/123] iwlwifi: mvm: avoid races in rate init and rate perform
Date:   Tue, 13 Aug 2019 22:09:46 -0400
Message-Id: <20190814021047.14828-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 0f8084cdc1f9d4a6693ef4168167febb0918c6f6 ]

Rate perform uses the lq_sta table to calculate the next rate to scale
while rate init resets the same table,

Rate perform is done in soft irq context in parallel to rate init
that can be called in case we are doing changes like AP changes BW
or moving state for auth to assoc.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c  | 42 ++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h  |  7 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  6 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |  1 +
 4 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 63fdb4e68e9d7..836541caa3167 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1197,6 +1197,27 @@ static u8 rs_get_tid(struct ieee80211_hdr *hdr)
 	return tid;
 }
 
+void iwl_mvm_rs_init_wk(struct work_struct *wk)
+{
+	struct iwl_mvm_sta *mvmsta = container_of(wk, struct iwl_mvm_sta,
+						  rs_init_wk);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
+	struct ieee80211_sta *sta;
+
+	rcu_read_lock();
+
+	sta = rcu_dereference(mvmvif->mvm->fw_id_to_mac_id[mvmsta->sta_id]);
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta))) {
+		rcu_read_unlock();
+		return;
+	}
+
+	iwl_mvm_rs_rate_init(mvmvif->mvm, sta, mvmvif->phy_ctxt->channel->band,
+			     true);
+
+	rcu_read_unlock();
+}
+
 void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  int tid, struct ieee80211_tx_info *info, bool ndp)
 {
@@ -1269,7 +1290,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       (unsigned long)(lq_sta->last_tx +
 				       (IWL_MVM_RS_IDLE_TIMEOUT * HZ)))) {
 		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
-		iwl_mvm_rs_rate_init(mvm, sta, info->band, true);
+		schedule_work(&mvmsta->rs_init_wk);
 		return;
 	}
 	lq_sta->last_tx = jiffies;
@@ -1442,16 +1463,24 @@ static void rs_drv_mac80211_tx_status(void *mvm_r,
 	struct iwl_op_mode *op_mode = mvm_r;
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-	if (!iwl_mvm_sta_from_mac80211(sta)->vif)
+	if (!mvmsta->vif)
 		return;
 
 	if (!ieee80211_is_data(hdr->frame_control) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
+	/* If it's locked we are in middle of init flow
+	 * just wait for next tx status to update the lq_sta data
+	 */
+	if (!mutex_trylock(&mvmsta->lq_sta.rs_drv.mutex))
+		return;
+
 	iwl_mvm_rs_tx_status(mvm, sta, rs_get_tid(hdr), info,
 			     ieee80211_is_qos_nullfunc(hdr->frame_control));
+	mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
 }
 
 /*
@@ -4136,10 +4165,15 @@ static const struct rate_control_ops rs_mvm_ops_drv = {
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum nl80211_band band, bool update)
 {
-	if (iwl_mvm_has_tlc_offload(mvm))
+	if (iwl_mvm_has_tlc_offload(mvm)) {
 		rs_fw_rate_init(mvm, sta, band, update);
-	else
+	} else {
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+		mutex_lock(&mvmsta->lq_sta.rs_drv.mutex);
 		rs_drv_rate_init(mvm, sta, band, update);
+		mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
+	}
 }
 
 int iwl_mvm_rate_control_register(void)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index f7eb60dbaf202..086f47e2a4f0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -4,7 +4,7 @@
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * Contact Information:
  *  Intel Linux Wireless <linuxwifi@intel.com>
@@ -376,6 +376,9 @@ struct iwl_lq_sta {
 	/* tx power reduce for this sta */
 	int tpc_reduce;
 
+	/* avoid races of reinit and update table from rx_tx */
+	struct mutex mutex;
+
 	/* persistent fields - initialized only once - keep last! */
 	struct lq_sta_pers {
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -440,6 +443,8 @@ struct iwl_mvm_sta;
 int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			  bool enable);
 
+void iwl_mvm_rs_init_wk(struct work_struct *wk);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm);
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index f545a737a92df..ac9bc65c4d156 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1684,6 +1684,10 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	 */
 	if (iwl_mvm_has_tlc_offload(mvm))
 		iwl_mvm_rs_add_sta(mvm, mvm_sta);
+	else
+		mutex_init(&mvm_sta->lq_sta.rs_drv.mutex);
+
+	INIT_WORK(&mvm_sta->rs_init_wk, iwl_mvm_rs_init_wk);
 
 	iwl_mvm_toggle_tx_ant(mvm, &mvm_sta->tx_ant);
 
@@ -1846,6 +1850,8 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
+	cancel_work_sync(&mvm_sta->rs_init_wk);
+
 	/* flush its queues here since we are freeing mvm_sta */
 	ret = iwl_mvm_flush_sta(mvm, mvm_sta, false, 0);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index b4d4071b865db..6e93c30492b78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -421,6 +421,7 @@ struct iwl_mvm_sta {
 		struct iwl_lq_sta_rs_fw rs_fw;
 		struct iwl_lq_sta rs_drv;
 	} lq_sta;
+	struct work_struct rs_init_wk;
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
-- 
2.20.1

