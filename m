Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461178C90A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfHNCNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbfHNCNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA2E820842;
        Wed, 14 Aug 2019 02:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748795;
        bh=m3n4qYP2wjJnIbaUjpskt2z+wMq7OZCU1tih6v4NOTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dOyfsXYFMO1vKiRjR2CODojNBskPNzoldA+ASHEAiDYkkY9tCz/Yhsup+AEB/dAF
         6dElg6q5iiZ1DVsCQWwplt51pYHq5JJJkaZxQcG9yXfnN29LE/Zsltcn/wa5tvQgcA
         BlymuF+75Z3TWePpD0hLb+4reeg6E4rpzKil9PaY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 066/123] iwlwifi: mvm: send LQ command always ASYNC
Date:   Tue, 13 Aug 2019 22:09:50 -0400
Message-Id: <20190814021047.14828-66-sashal@kernel.org>
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

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit cd4d6b0bcd51580efda9ae54ab7b2d630b4147dc ]

The only place where the command was sent as SYNC is during
init and this is not really critical. This change is required
for replacing RS mutex with a spinlock (in the subsequent patch),
since SYNC comamnd requres sleeping and thus the flow cannot
be done when holding a spinlock.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   | 23 ++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  4 ++--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 88af1f0ba3f0f..31c8636b2a3f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1806,7 +1806,7 @@ iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 /* rate scaling */
-int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool sync);
+int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq);
 void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg);
 int rs_pretty_print_rate(char *buf, int bufsz, const u32 rate);
 void rs_update_last_rssi(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 836541caa3167..01b032f18bc8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1326,7 +1326,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			IWL_DEBUG_RATE(mvm,
 				       "Too many rates mismatch. Send sync LQ. rs_state %d\n",
 				       lq_sta->rs_state);
-			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
+			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq);
 		}
 		/* Regardless, ignore this status info for outdated rate */
 		return;
@@ -1388,7 +1388,8 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		if (info->status.ampdu_ack_len == 0)
 			info->status.ampdu_len = 1;
 
-		rs_collect_tlc_data(mvm, mvmsta, tid, curr_tbl, tx_resp_rate.index,
+		rs_collect_tlc_data(mvm, mvmsta, tid, curr_tbl,
+				    tx_resp_rate.index,
 				    info->status.ampdu_len,
 				    info->status.ampdu_ack_len);
 
@@ -1823,7 +1824,7 @@ static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 			       struct iwl_scale_tbl_info *tbl)
 {
 	rs_fill_lq_cmd(mvm, sta, lq_sta, &tbl->rate);
-	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
+	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq);
 }
 
 static bool rs_tweak_rate_tbl(struct iwl_mvm *mvm,
@@ -2925,7 +2926,7 @@ void rs_update_last_rssi(struct iwl_mvm *mvm,
 static void rs_initialize_lq(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta,
 			     struct iwl_lq_sta *lq_sta,
-			     enum nl80211_band band, bool update)
+			     enum nl80211_band band)
 {
 	struct iwl_scale_tbl_info *tbl;
 	struct rs_rate *rate;
@@ -2955,7 +2956,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_lq_cmd(mvm, sta, lq_sta, rate);
 	/* TODO restore station should remember the lq cmd */
-	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, !update);
+	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq);
 }
 
 static void rs_drv_get_rate(void *mvm_r, struct ieee80211_sta *sta,
@@ -3208,7 +3209,7 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
  * Called after adding a new station to initialize rate scaling
  */
 static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			     enum nl80211_band band, bool update)
+			     enum nl80211_band band)
 {
 	int i, j;
 	struct ieee80211_hw *hw = mvm->hw;
@@ -3288,7 +3289,7 @@ static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_reset_frame_stats(mvm);
 #endif
-	rs_initialize_lq(mvm, sta, lq_sta, band, update);
+	rs_initialize_lq(mvm, sta, lq_sta, band);
 }
 
 static void rs_drv_rate_update(void *mvm_r,
@@ -3602,7 +3603,7 @@ static void rs_set_lq_ss_params(struct iwl_mvm *mvm,
 
 		bfersta_ss_params &= ~LQ_SS_BFER_ALLOWED;
 		bfersta_lq_cmd->ss_params = cpu_to_le32(bfersta_ss_params);
-		iwl_mvm_send_lq_cmd(mvm, bfersta_lq_cmd, false);
+		iwl_mvm_send_lq_cmd(mvm, bfersta_lq_cmd);
 
 		ss_params |= LQ_SS_BFER_ALLOWED;
 		IWL_DEBUG_RATE(mvm,
@@ -3768,7 +3769,7 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 
 	if (lq_sta->pers.dbg_fixed_rate) {
 		rs_fill_lq_cmd(mvm, NULL, lq_sta, NULL);
-		iwl_mvm_send_lq_cmd(lq_sta->pers.drv, &lq_sta->lq, false);
+		iwl_mvm_send_lq_cmd(lq_sta->pers.drv, &lq_sta->lq);
 	}
 }
 
@@ -4171,7 +4172,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 		mutex_lock(&mvmsta->lq_sta.rs_drv.mutex);
-		rs_drv_rate_init(mvm, sta, band, update);
+		rs_drv_rate_init(mvm, sta, band);
 		mutex_unlock(&mvmsta->lq_sta.rs_drv.mutex);
 	}
 }
@@ -4203,7 +4204,7 @@ static int rs_drv_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			lq->flags &= ~LQ_FLAG_USE_RTS_MSK;
 	}
 
-	return iwl_mvm_send_lq_cmd(mvm, lq, false);
+	return iwl_mvm_send_lq_cmd(mvm, lq);
 }
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ac9bc65c4d156..22715cdb83171 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2978,7 +2978,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	IWL_DEBUG_HT(mvm, "Tx aggregation enabled on ra = %pM tid = %d\n",
 		     sta->addr, tid);
 
-	return iwl_mvm_send_lq_cmd(mvm, &mvmsta->lq_sta.rs_drv.lq, false);
+	return iwl_mvm_send_lq_cmd(mvm, &mvmsta->lq_sta.rs_drv.lq);
 }
 
 static void iwl_mvm_unreserve_agg_queue(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index cc56ab88fb439..a71277de2e0eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -641,12 +641,12 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
  * this case to clear the state indicating that station creation is in
  * progress.
  */
-int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool sync)
+int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq)
 {
 	struct iwl_host_cmd cmd = {
 		.id = LQ_CMD,
 		.len = { sizeof(struct iwl_lq_cmd), },
-		.flags = sync ? 0 : CMD_ASYNC,
+		.flags = CMD_ASYNC,
 		.data = { lq, },
 	};
 
-- 
2.20.1

