Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7C6429509
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhJKRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:01:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:22639 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233129AbhJKRBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 13:01:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="250312411"
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="250312411"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 09:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="591405466"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2021 09:59:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 6/9] ice: cleanup rules info
Date:   Mon, 11 Oct 2021 09:57:39 -0700
Message-Id: <20211011165742.1144861-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
References: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

Change ICE_SW_LKUP_LAST to ICE_MAX_NUM_RECIPES as for now there also can
be recipes other than the default.

Free all structures created for advanced recipes in cleanup function.
Write a function to clean allocated structures on advanced rule info.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 41 +++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_switch.c | 28 +++++++++++++-
 2 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index bff4c09dfa5f..152a1405e353 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -595,17 +595,42 @@ static void ice_cleanup_fltr_mgmt_struct(struct ice_hw *hw)
 		list_del(&v_pos_map->list_entry);
 		devm_kfree(ice_hw_to_dev(hw), v_pos_map);
 	}
-	recps = hw->switch_info->recp_list;
-	for (i = 0; i < ICE_SW_LKUP_LAST; i++) {
-		struct ice_fltr_mgmt_list_entry *lst_itr, *tmp_entry;
+	recps = sw->recp_list;
+	for (i = 0; i < ICE_MAX_NUM_RECIPES; i++) {
+		struct ice_recp_grp_entry *rg_entry, *tmprg_entry;
 
 		recps[i].root_rid = i;
-		mutex_destroy(&recps[i].filt_rule_lock);
-		list_for_each_entry_safe(lst_itr, tmp_entry,
-					 &recps[i].filt_rules, list_entry) {
-			list_del(&lst_itr->list_entry);
-			devm_kfree(ice_hw_to_dev(hw), lst_itr);
+		list_for_each_entry_safe(rg_entry, tmprg_entry,
+					 &recps[i].rg_list, l_entry) {
+			list_del(&rg_entry->l_entry);
+			devm_kfree(ice_hw_to_dev(hw), rg_entry);
 		}
+
+		if (recps[i].adv_rule) {
+			struct ice_adv_fltr_mgmt_list_entry *tmp_entry;
+			struct ice_adv_fltr_mgmt_list_entry *lst_itr;
+
+			mutex_destroy(&recps[i].filt_rule_lock);
+			list_for_each_entry_safe(lst_itr, tmp_entry,
+						 &recps[i].filt_rules,
+						 list_entry) {
+				list_del(&lst_itr->list_entry);
+				devm_kfree(ice_hw_to_dev(hw), lst_itr->lkups);
+				devm_kfree(ice_hw_to_dev(hw), lst_itr);
+			}
+		} else {
+			struct ice_fltr_mgmt_list_entry *lst_itr, *tmp_entry;
+
+			mutex_destroy(&recps[i].filt_rule_lock);
+			list_for_each_entry_safe(lst_itr, tmp_entry,
+						 &recps[i].filt_rules,
+						 list_entry) {
+				list_del(&lst_itr->list_entry);
+				devm_kfree(ice_hw_to_dev(hw), lst_itr);
+			}
+		}
+		if (recps[i].root_buf)
+			devm_kfree(ice_hw_to_dev(hw), recps[i].root_buf);
 	}
 	ice_rm_all_sw_replay_rule_info(hw);
 	devm_kfree(ice_hw_to_dev(hw), sw->recp_list);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 81dee4ba2dc3..0d07547b40f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2682,6 +2682,27 @@ ice_rem_sw_rule_info(struct ice_hw *hw, struct list_head *rule_head)
 	}
 }
 
+/**
+ * ice_rem_adv_rule_info
+ * @hw: pointer to the hardware structure
+ * @rule_head: pointer to the switch list structure that we want to delete
+ */
+static void
+ice_rem_adv_rule_info(struct ice_hw *hw, struct list_head *rule_head)
+{
+	struct ice_adv_fltr_mgmt_list_entry *tmp_entry;
+	struct ice_adv_fltr_mgmt_list_entry *lst_itr;
+
+	if (list_empty(rule_head))
+		return;
+
+	list_for_each_entry_safe(lst_itr, tmp_entry, rule_head, list_entry) {
+		list_del(&lst_itr->list_entry);
+		devm_kfree(ice_hw_to_dev(hw), lst_itr->lkups);
+		devm_kfree(ice_hw_to_dev(hw), lst_itr);
+	}
+}
+
 /**
  * ice_cfg_dflt_vsi - change state of VSI to set/clear default
  * @hw: pointer to the hardware structure
@@ -5183,12 +5204,15 @@ void ice_rm_all_sw_replay_rule_info(struct ice_hw *hw)
 	if (!sw)
 		return;
 
-	for (i = 0; i < ICE_SW_LKUP_LAST; i++) {
+	for (i = 0; i < ICE_MAX_NUM_RECIPES; i++) {
 		if (!list_empty(&sw->recp_list[i].filt_replay_rules)) {
 			struct list_head *l_head;
 
 			l_head = &sw->recp_list[i].filt_replay_rules;
-			ice_rem_sw_rule_info(hw, l_head);
+			if (!sw->recp_list[i].adv_rule)
+				ice_rem_sw_rule_info(hw, l_head);
+			else
+				ice_rem_adv_rule_info(hw, l_head);
 		}
 	}
 }
-- 
2.31.1

