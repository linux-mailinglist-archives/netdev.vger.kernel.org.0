Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7964869F4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242873AbiAFSbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:31:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:21736 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242861AbiAFSbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 13:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641493867; x=1673029867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mu/X19UJ9AtQj2+J/+JSX6miVTurDNaLAydt8sCTEA8=;
  b=HZaYLHKz2hW2tpMeWH5yyaosPHbMVhkoFEflWtVcA/J2zTuLT1m5ABsC
   lDRv1uBrAernI0da+xP3wE9c0KWs/gs9AW5qI4gcF18kYUyoj3qY7Uf4Y
   k1kMp01oHXTFinHTbVlrjThuBg0u/QpQwGNKktJzvhyx9+VCBjjv1k2Tv
   oLF2bISCu8ItVv7o2cGWgi+Q5M3doHfJ8SFpEvziZ08B2s0mdBVh+rhXQ
   ALHnAqXAAMBUhsPkf9J04namopy/+qyp0Zbsq3kBPLrBo6XIBGdhUvKSr
   kKn1fhYcTrl47yJiF6Ef//tgWUDI5bYMOQ+0GF17VQSRjLa1pobhhztFN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242666611"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242666611"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:30:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="489024734"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2022 10:30:49 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 1/5] ice: replay advanced rules after reset
Date:   Thu,  6 Jan 2022 10:30:09 -0800
Message-Id: <20220106183013.3777622-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
References: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

ice_replay_vsi_adv_rule will replay advanced rules for a given VSI.
Exit this function when list of rules for given recipe is empty.
Do not add rule when given vsi_handle does not match vsi_handle
from the rule info.

Use ICE_MAX_NUM_RECIPES instead of ICE_SW_LKUP_LAST in order to find
advanced rules as well.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c | 41 +++++++++++++++++++--
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2a1ee60e85f4..408d15a5b0e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4603,7 +4603,7 @@ static int ice_replay_pre_init(struct ice_hw *hw)
 	 * will allow adding rules entries back to filt_rules list,
 	 * which is operational list.
 	 */
-	for (i = 0; i < ICE_SW_LKUP_LAST; i++)
+	for (i = 0; i < ICE_MAX_NUM_RECIPES; i++)
 		list_replace_init(&sw->recp_list[i].filt_rules,
 				  &sw->recp_list[i].filt_replay_rules);
 	ice_sched_replay_agg_vsi_preinit(hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index e477c2b1d5bb..996274c6b73c 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5651,6 +5651,38 @@ ice_rem_adv_rule_by_id(struct ice_hw *hw,
 	return -ENOENT;
 }
 
+/**
+ * ice_replay_vsi_adv_rule - Replay advanced rule for requested VSI
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: driver VSI handle
+ * @list_head: list for which filters need to be replayed
+ *
+ * Replay the advanced rule for the given VSI.
+ */
+static int
+ice_replay_vsi_adv_rule(struct ice_hw *hw, u16 vsi_handle,
+			struct list_head *list_head)
+{
+	struct ice_rule_query_data added_entry = { 0 };
+	struct ice_adv_fltr_mgmt_list_entry *adv_fltr;
+	int status = 0;
+
+	if (list_empty(list_head))
+		return status;
+	list_for_each_entry(adv_fltr, list_head, list_entry) {
+		struct ice_adv_rule_info *rinfo = &adv_fltr->rule_info;
+		u16 lk_cnt = adv_fltr->lkups_cnt;
+
+		if (vsi_handle != rinfo->sw_act.vsi_handle)
+			continue;
+		status = ice_add_adv_rule(hw, adv_fltr->lkups, lk_cnt, rinfo,
+					  &added_entry);
+		if (status)
+			break;
+	}
+	return status;
+}
+
 /**
  * ice_replay_vsi_all_fltr - replay all filters stored in bookkeeping lists
  * @hw: pointer to the hardware structure
@@ -5661,14 +5693,17 @@ ice_rem_adv_rule_by_id(struct ice_hw *hw,
 int ice_replay_vsi_all_fltr(struct ice_hw *hw, u16 vsi_handle)
 {
 	struct ice_switch_info *sw = hw->switch_info;
-	int status = 0;
+	int status;
 	u8 i;
 
-	for (i = 0; i < ICE_SW_LKUP_LAST; i++) {
+	for (i = 0; i < ICE_MAX_NUM_RECIPES; i++) {
 		struct list_head *head;
 
 		head = &sw->recp_list[i].filt_replay_rules;
-		status = ice_replay_vsi_fltr(hw, vsi_handle, i, head);
+		if (!sw->recp_list[i].adv_rule)
+			status = ice_replay_vsi_fltr(hw, vsi_handle, i, head);
+		else
+			status = ice_replay_vsi_adv_rule(hw, vsi_handle, head);
 		if (status)
 			return status;
 	}
-- 
2.31.1

