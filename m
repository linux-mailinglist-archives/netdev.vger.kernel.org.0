Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278F23BCDB5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhGFLXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233394AbhGFLUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF3261CBA;
        Tue,  6 Jul 2021 11:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570252;
        bh=3cAvlyliElTdZCBJoTGyt2k+dShk1FBrC6SP8aQZuwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hkbg5XA0NIeRhEy2ZRXLsoZXaGbRdpMeqLDwp4Z1UpzlzHx/0RWin57xB9AaPNZHm
         emJJuuI4epJkAb47cCKPGQIYH5w31odJ0f3n04AiqjiCgl7M3/4J7ZzTSJUvcEvu/D
         e5Ndl0ty/LoRZHKHzR70v6h7nbSaoKCHPvwSvtdMrvfU7/fpbkAAWx0pi/yg5VkfZN
         lzZN+A+j/5OSYH4XzIrmtdFUN2hRDhtuB/SkyZKPIIkg5G3D32Rgg/ebWhwyyUvXTm
         vPOoqreY4mTUU2JR1v7ZFmSBWHEH+FJ1QZFBAZ0+SZpOTwyVx4JHxJ/raHveKIbhc3
         Q1IbCmiE55TpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 150/189] iwlwifi: mvm: apply RX diversity per PHY context
Date:   Tue,  6 Jul 2021 07:13:30 -0400
Message-Id: <20210706111409.2058071-150-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a171399fd687a7d2fa56a10c9a2d7084a647677d ]

SMPS requests may differ per interfaces due to e.g. Bluetooth
only interfering on 2.4 GHz, so if that's the case we should,
in the case of multiple PHY contexts, still allow RX diversity
on PHY context that have no interfaces with SMPS requests.

Fix the code to pass through the PHY context in question and
skip interfaces with non-matching PHY context while iterating.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210617100544.123c6b05809d.I992e3d1c6a29850d02eeec01712b5b685b963a87@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +-
 .../net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 15 ++++++----
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 28 ++++++++++++++-----
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4d9d4d6892fc..02cf52133857 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1827,7 +1827,8 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				enum iwl_mvm_smps_type_request req_type,
 				enum ieee80211_smps_mode smps_request);
-bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm);
+bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm,
+				  struct iwl_mvm_phy_ctxt *ctxt);
 
 /* Low latency */
 int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 0fd51f6aa206..4ed2338027d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2020 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -76,6 +76,7 @@ static void iwl_mvm_phy_ctxt_cmd_hdr(struct iwl_mvm_phy_ctxt *ctxt,
 }
 
 static void iwl_mvm_phy_ctxt_set_rxchain(struct iwl_mvm *mvm,
+					 struct iwl_mvm_phy_ctxt *ctxt,
 					 __le32 *rxchain_info,
 					 u8 chains_static,
 					 u8 chains_dynamic)
@@ -93,7 +94,7 @@ static void iwl_mvm_phy_ctxt_set_rxchain(struct iwl_mvm *mvm,
 	 * between the two antennas is sufficiently different to impact
 	 * performance.
 	 */
-	if (active_cnt == 1 && iwl_mvm_rx_diversity_allowed(mvm)) {
+	if (active_cnt == 1 && iwl_mvm_rx_diversity_allowed(mvm, ctxt)) {
 		idle_cnt = 2;
 		active_cnt = 2;
 	}
@@ -113,6 +114,7 @@ static void iwl_mvm_phy_ctxt_set_rxchain(struct iwl_mvm *mvm,
  * Add the phy configuration to the PHY context command
  */
 static void iwl_mvm_phy_ctxt_cmd_data_v1(struct iwl_mvm *mvm,
+					 struct iwl_mvm_phy_ctxt *ctxt,
 					 struct iwl_phy_context_cmd_v1 *cmd,
 					 struct cfg80211_chan_def *chandef,
 					 u8 chains_static, u8 chains_dynamic)
@@ -123,7 +125,7 @@ static void iwl_mvm_phy_ctxt_cmd_data_v1(struct iwl_mvm *mvm,
 	/* Set the channel info data */
 	iwl_mvm_set_chan_info_chandef(mvm, &cmd->ci, chandef);
 
-	iwl_mvm_phy_ctxt_set_rxchain(mvm, &tail->rxchain_info,
+	iwl_mvm_phy_ctxt_set_rxchain(mvm, ctxt, &tail->rxchain_info,
 				     chains_static, chains_dynamic);
 
 	tail->txchain_info = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
@@ -133,6 +135,7 @@ static void iwl_mvm_phy_ctxt_cmd_data_v1(struct iwl_mvm *mvm,
  * Add the phy configuration to the PHY context command
  */
 static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
+				      struct iwl_mvm_phy_ctxt *ctxt,
 				      struct iwl_phy_context_cmd *cmd,
 				      struct cfg80211_chan_def *chandef,
 				      u8 chains_static, u8 chains_dynamic)
@@ -143,7 +146,7 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	/* Set the channel info data */
 	iwl_mvm_set_chan_info_chandef(mvm, &cmd->ci, chandef);
 
-	iwl_mvm_phy_ctxt_set_rxchain(mvm, &cmd->rxchain_info,
+	iwl_mvm_phy_ctxt_set_rxchain(mvm, ctxt, &cmd->rxchain_info,
 				     chains_static, chains_dynamic);
 }
 
@@ -170,7 +173,7 @@ static int iwl_mvm_phy_ctxt_apply(struct iwl_mvm *mvm,
 		iwl_mvm_phy_ctxt_cmd_hdr(ctxt, &cmd, action);
 
 		/* Set the command data */
-		iwl_mvm_phy_ctxt_cmd_data(mvm, &cmd, chandef,
+		iwl_mvm_phy_ctxt_cmd_data(mvm, ctxt, &cmd, chandef,
 					  chains_static,
 					  chains_dynamic);
 
@@ -186,7 +189,7 @@ static int iwl_mvm_phy_ctxt_apply(struct iwl_mvm *mvm,
 					 action);
 
 		/* Set the command data */
-		iwl_mvm_phy_ctxt_cmd_data_v1(mvm, &cmd, chandef,
+		iwl_mvm_phy_ctxt_cmd_data_v1(mvm, ctxt, &cmd, chandef,
 					     chains_static,
 					     chains_dynamic);
 		ret = iwl_mvm_send_cmd_pdu(mvm, PHY_CONTEXT_CMD,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index c566be99a4c7..a89eb7c40ee7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -683,23 +683,37 @@ void iwl_mvm_accu_radio_stats(struct iwl_mvm *mvm)
 	mvm->accu_radio_stats.on_time_scan += mvm->radio_stats.on_time_scan;
 }
 
+struct iwl_mvm_diversity_iter_data {
+	struct iwl_mvm_phy_ctxt *ctxt;
+	bool result;
+};
+
 static void iwl_mvm_diversity_iter(void *_data, u8 *mac,
 				   struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	bool *result = _data;
+	struct iwl_mvm_diversity_iter_data *data = _data;
 	int i;
 
+	if (mvmvif->phy_ctxt != data->ctxt)
+		return;
+
 	for (i = 0; i < NUM_IWL_MVM_SMPS_REQ; i++) {
 		if (mvmvif->smps_requests[i] == IEEE80211_SMPS_STATIC ||
-		    mvmvif->smps_requests[i] == IEEE80211_SMPS_DYNAMIC)
-			*result = false;
+		    mvmvif->smps_requests[i] == IEEE80211_SMPS_DYNAMIC) {
+			data->result = false;
+			break;
+		}
 	}
 }
 
-bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
+bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm,
+				  struct iwl_mvm_phy_ctxt *ctxt)
 {
-	bool result = true;
+	struct iwl_mvm_diversity_iter_data data = {
+		.ctxt = ctxt,
+		.result = true,
+	};
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -711,9 +725,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	ieee80211_iterate_active_interfaces_atomic(
 			mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-			iwl_mvm_diversity_iter, &result);
+			iwl_mvm_diversity_iter, &data);
 
-	return result;
+	return data.result;
 }
 
 void iwl_mvm_send_low_latency_cmd(struct iwl_mvm *mvm,
-- 
2.30.2

