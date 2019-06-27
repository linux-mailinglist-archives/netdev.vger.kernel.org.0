Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49320575B7
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfF0Abt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfF0Abr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:47 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C9E22083B;
        Thu, 27 Jun 2019 00:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595506;
        bh=DMqbglHczQUbFpxbS6oqWVek22jHR8khubzyZS+CpQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFs8Sylb8+G50sbOzxMZ2QJ6NN7YtEK2EOroZ1eGdGG7CYVYxJ7oZ9k+3cHjR001j
         XQb888dLIfezhxExGuwKq8q1x5cjcg3OvFTxOaVXFGtj+X5uii5G2MUOdBeEDZJMAd
         m92Z9sQ5pAF77Twk280FUqcr0ja8VTJqsZn1PXD8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 25/95] iwlwifi: fix load in rfkill flow for unified firmware
Date:   Wed, 26 Jun 2019 20:29:10 -0400
Message-Id: <20190627003021.19867-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit b3500b472c880b5abe90ffd5c4a25aa736f906ad ]

When we have a single image (same firmware image for INIT and
OPERATIONAL), we couldn't load the driver and register to the
stack if we had hardware RF-Kill asserted.

Fix this. This required a few changes:

1) Run the firmware as part of the INIT phase even if its
   ucode_type is not IWL_UCODE_INIT.
2) Send the commands that are sent to the unified image in
   INIT flow even in RF-Kill.
3) Don't ask the transport to stop the hardware upon RF-Kill
   interrupt if the RF-Kill is asserted.
4) Allow the RF-Kill interrupt to take us out of L1A so that
   the RF-Kill interrupt will be received by the host (to
   enable the radio).

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 23 ++++++++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 17 ++++++++++----
 .../wireless/intel/iwlwifi/pcie/internal.h    |  2 +-
 5 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index ab68b5d53ec9..153717587aeb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -311,6 +311,8 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	int ret;
 	enum iwl_ucode_type old_type = mvm->fwrt.cur_fw_img;
 	static const u16 alive_cmd[] = { MVM_ALIVE };
+	bool run_in_rfkill =
+		ucode_type == IWL_UCODE_INIT || iwl_mvm_has_unified_ucode(mvm);
 
 	if (ucode_type == IWL_UCODE_REGULAR &&
 	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE) &&
@@ -328,7 +330,12 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 				   alive_cmd, ARRAY_SIZE(alive_cmd),
 				   iwl_alive_fn, &alive_data);
 
-	ret = iwl_trans_start_fw(mvm->trans, fw, ucode_type == IWL_UCODE_INIT);
+	/*
+	 * We want to load the INIT firmware even in RFKILL
+	 * For the unified firmware case, the ucode_type is not
+	 * INIT, but we still need to run it.
+	 */
+	ret = iwl_trans_start_fw(mvm->trans, fw, run_in_rfkill);
 	if (ret) {
 		iwl_fw_set_current_image(&mvm->fwrt, old_type);
 		iwl_remove_notification(&mvm->notif_wait, &alive_wait);
@@ -433,7 +440,8 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	 * commands
 	 */
 	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(SYSTEM_GROUP,
-						INIT_EXTENDED_CFG_CMD), 0,
+						INIT_EXTENDED_CFG_CMD),
+				   CMD_SEND_IN_RFKILL,
 				   sizeof(init_cfg), &init_cfg);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to run init config command: %d\n",
@@ -457,7 +465,8 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	}
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, WIDE_ID(REGULATORY_AND_NVM_GROUP,
-						NVM_ACCESS_COMPLETE), 0,
+						NVM_ACCESS_COMPLETE),
+				   CMD_SEND_IN_RFKILL,
 				   sizeof(nvm_complete), &nvm_complete);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to run complete NVM access: %d\n",
@@ -482,6 +491,8 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		}
 	}
 
+	mvm->rfkill_safe_init_done = true;
+
 	return 0;
 
 error:
@@ -526,7 +537,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (WARN_ON_ONCE(mvm->calibrating))
+	if (WARN_ON_ONCE(mvm->rfkill_safe_init_done))
 		return 0;
 
 	iwl_init_notification_wait(&mvm->notif_wait,
@@ -576,7 +587,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 		goto remove_notif;
 	}
 
-	mvm->calibrating = true;
+	mvm->rfkill_safe_init_done = true;
 
 	/* Send TX valid antennas before triggering calibrations */
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
@@ -612,7 +623,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 remove_notif:
 	iwl_remove_notification(&mvm->notif_wait, &calib_wait);
 out:
-	mvm->calibrating = false;
+	mvm->rfkill_safe_init_done = false;
 	if (iwlmvm_mod_params.init_dbg && !mvm->nvm_data) {
 		/* we want to debug INIT and we have no NVM - fake */
 		mvm->nvm_data = kzalloc(sizeof(struct iwl_nvm_data) +
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6a3b11dd2edf..4ddf620c267d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1211,7 +1211,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	mvm->scan_status = 0;
 	mvm->ps_disabled = false;
-	mvm->calibrating = false;
+	mvm->rfkill_safe_init_done = false;
 
 	/* just in case one was running */
 	iwl_mvm_cleanup_roc_te(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index a50dc53df086..b698d55ace1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -877,7 +877,7 @@ struct iwl_mvm {
 	struct iwl_mvm_vif *bf_allowed_vif;
 
 	bool hw_registered;
-	bool calibrating;
+	bool rfkill_safe_init_done;
 	bool support_umac_log;
 
 	u32 ampdu_ref;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 13681b03c10e..20115770e75a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1222,7 +1222,8 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
 static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	bool calibrating = READ_ONCE(mvm->calibrating);
+	bool rfkill_safe_init_done = READ_ONCE(mvm->rfkill_safe_init_done);
+	bool unified = iwl_mvm_has_unified_ucode(mvm);
 
 	if (state)
 		set_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
@@ -1231,15 +1232,23 @@ static bool iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 
 	iwl_mvm_set_rfkill_state(mvm);
 
-	/* iwl_run_init_mvm_ucode is waiting for results, abort it */
-	if (calibrating)
+	 /* iwl_run_init_mvm_ucode is waiting for results, abort it. */
+	if (rfkill_safe_init_done)
 		iwl_abort_notification_waits(&mvm->notif_wait);
 
+	/*
+	 * Don't ask the transport to stop the firmware. We'll do it
+	 * after cfg80211 takes us down.
+	 */
+	if (unified)
+		return false;
+
 	/*
 	 * Stop the device if we run OPERATIONAL firmware or if we are in the
 	 * middle of the calibrations.
 	 */
-	return state && (mvm->fwrt.cur_fw_img != IWL_UCODE_INIT || calibrating);
+	return state && (mvm->fwrt.cur_fw_img != IWL_UCODE_INIT ||
+			 rfkill_safe_init_done);
 }
 
 static void iwl_mvm_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 59213164f35e..2afce5c41322 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -948,7 +948,7 @@ static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 					   MSIX_HW_INT_CAUSES_REG_RF_KILL);
 	}
 
-	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_9000) {
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_9000) {
 		/*
 		 * On 9000-series devices this bit isn't enabled by default, so
 		 * when we power down the device we need set the bit to allow it
-- 
2.20.1

