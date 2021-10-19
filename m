Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA353433E7B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhJSSee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:34:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:51642 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234424AbhJSSea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:34:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="226058563"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="226058563"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 11:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="444602716"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2021 11:32:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 06/10] ice: Manage act flags for switchdev offloads
Date:   Tue, 19 Oct 2021 11:30:23 -0700
Message-Id: <20211019183027.2820413-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
References: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Currently it is not possible to set/unset lb_en and lan_en flags
for advanced rules during their creation. Both flags are enabled
by default. In case of switchdev offloads for egress traffic we
need lb_en to be disabled. Because of that, we work around it by
updating the rule immediately after its creation.

This change allows us to set/unset those flags right away and it
gets rid of old workaround as well. Using ice_adv_rule_flags_info
structure we can pass info about flags we want to be set for
a given advanced rule. Flags are stored in flags_info.act.
Values from act would be used only if act_valid was set to true,
otherwise default values would be used.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c   | 127 --------------------
 drivers/net/ethernet/intel/ice/ice_fltr.h   |   4 -
 drivers/net/ethernet/intel/ice/ice_switch.c |   9 +-
 drivers/net/ethernet/intel/ice/ice_switch.h |  11 ++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c |   8 +-
 5 files changed, 21 insertions(+), 138 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index f8c59df4ff9c..c2e78eaf4ccb 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -453,133 +453,6 @@ static u32 ice_fltr_build_action(u16 vsi_id)
 		ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_VALID_BIT;
 }
 
-/**
- * ice_fltr_find_adv_entry - find advanced rule
- * @rules: list of rules
- * @rule_id: id of wanted rule
- */
-static struct ice_adv_fltr_mgmt_list_entry *
-ice_fltr_find_adv_entry(struct list_head *rules, u16 rule_id)
-{
-	struct ice_adv_fltr_mgmt_list_entry *entry;
-
-	list_for_each_entry(entry, rules, list_entry) {
-		if (entry->rule_info.fltr_rule_id == rule_id)
-			return entry;
-	}
-
-	return NULL;
-}
-
-/**
- * ice_fltr_update_adv_rule_flags - update flags on advanced rule
- * @vsi: pointer to VSI
- * @recipe_id: id of recipe
- * @entry: advanced rule entry
- * @new_flags: flags to update
- */
-static enum ice_status
-ice_fltr_update_adv_rule_flags(struct ice_vsi *vsi, u16 recipe_id,
-			       struct ice_adv_fltr_mgmt_list_entry *entry,
-			       u32 new_flags)
-{
-	struct ice_adv_rule_info *info = &entry->rule_info;
-	struct ice_sw_act_ctrl *act = &info->sw_act;
-	u32 action;
-
-	if (act->fltr_act != ICE_FWD_TO_VSI)
-		return ICE_ERR_NOT_SUPPORTED;
-
-	action = ice_fltr_build_action(act->fwd_id.hw_vsi_id);
-
-	return ice_fltr_update_rule_flags(&vsi->back->hw, info->fltr_rule_id,
-					  recipe_id, action, info->sw_act.flag,
-					  act->src, new_flags);
-}
-
-/**
- * ice_fltr_find_regular_entry - find regular rule
- * @rules: list of rules
- * @rule_id: id of wanted rule
- */
-static struct ice_fltr_mgmt_list_entry *
-ice_fltr_find_regular_entry(struct list_head *rules, u16 rule_id)
-{
-	struct ice_fltr_mgmt_list_entry *entry;
-
-	list_for_each_entry(entry, rules, list_entry) {
-		if (entry->fltr_info.fltr_rule_id == rule_id)
-			return entry;
-	}
-
-	return NULL;
-}
-
-/**
- * ice_fltr_update_regular_rule - update flags on regular rule
- * @vsi: pointer to VSI
- * @recipe_id: id of recipe
- * @entry: regular rule entry
- * @new_flags: flags to update
- */
-static enum ice_status
-ice_fltr_update_regular_rule(struct ice_vsi *vsi, u16 recipe_id,
-			     struct ice_fltr_mgmt_list_entry *entry,
-			     u32 new_flags)
-{
-	struct ice_fltr_info *info = &entry->fltr_info;
-	u32 action;
-
-	if (info->fltr_act != ICE_FWD_TO_VSI)
-		return ICE_ERR_NOT_SUPPORTED;
-
-	action = ice_fltr_build_action(info->fwd_id.hw_vsi_id);
-
-	return ice_fltr_update_rule_flags(&vsi->back->hw, info->fltr_rule_id,
-					  recipe_id, action, info->flag,
-					  info->src, new_flags);
-}
-
-/**
- * ice_fltr_update_flags - update flags on rule
- * @vsi: pointer to VSI
- * @rule_id: id of rule
- * @recipe_id: id of recipe
- * @new_flags: flags to update
- *
- * Function updates flags on regular and advance rule.
- *
- * Flags should be a combination of ICE_SINGLE_ACT_LB_ENABLE and
- * ICE_SINGLE_ACT_LAN_ENABLE.
- */
-enum ice_status
-ice_fltr_update_flags(struct ice_vsi *vsi, u16 rule_id, u16 recipe_id,
-		      u32 new_flags)
-{
-	struct ice_adv_fltr_mgmt_list_entry *adv_entry;
-	struct ice_fltr_mgmt_list_entry *regular_entry;
-	struct ice_hw *hw = &vsi->back->hw;
-	struct ice_sw_recipe *recp_list;
-	struct list_head *fltr_rules;
-
-	recp_list = &hw->switch_info->recp_list[recipe_id];
-	if (!recp_list)
-		return ICE_ERR_DOES_NOT_EXIST;
-
-	fltr_rules = &recp_list->filt_rules;
-	regular_entry = ice_fltr_find_regular_entry(fltr_rules, rule_id);
-	if (regular_entry)
-		return ice_fltr_update_regular_rule(vsi, recipe_id,
-						    regular_entry, new_flags);
-
-	adv_entry = ice_fltr_find_adv_entry(fltr_rules, rule_id);
-	if (adv_entry)
-		return ice_fltr_update_adv_rule_flags(vsi, recipe_id,
-						      adv_entry, new_flags);
-
-	return ICE_ERR_DOES_NOT_EXIST;
-}
-
 /**
  * ice_fltr_update_flags_dflt_rule - update flags on default rule
  * @vsi: pointer to VSI
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.h b/drivers/net/ethernet/intel/ice/ice_fltr.h
index 949e38ce016c..8eec4febead1 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.h
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.h
@@ -36,10 +36,6 @@ enum ice_status
 ice_fltr_remove_eth(struct ice_vsi *vsi, u16 ethertype, u16 flag,
 		    enum ice_sw_fwd_act_type action);
 void ice_fltr_remove_all(struct ice_vsi *vsi);
-
-enum ice_status
-ice_fltr_update_flags(struct ice_vsi *vsi, u16 rule_id, u16 recipe_id,
-		      u32 new_flags);
 enum ice_status
 ice_fltr_update_flags_dflt_rule(struct ice_vsi *vsi, u16 rule_id, u8 direction,
 				u32 new_flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 0d07547b40f1..a4a299012f9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4783,7 +4783,14 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
 	if (!s_rule)
 		return ICE_ERR_NO_MEMORY;
-	act |= ICE_SINGLE_ACT_LB_ENABLE | ICE_SINGLE_ACT_LAN_ENABLE;
+	if (!rinfo->flags_info.act_valid) {
+		act |= ICE_SINGLE_ACT_LAN_ENABLE;
+		act |= ICE_SINGLE_ACT_LB_ENABLE;
+	} else {
+		act |= rinfo->flags_info.act & (ICE_SINGLE_ACT_LAN_ENABLE |
+						ICE_SINGLE_ACT_LB_ENABLE);
+	}
+
 	switch (rinfo->sw_act.fltr_act) {
 	case ICE_FWD_TO_VSI:
 		act |= (rinfo->sw_act.fwd_id.hw_vsi_id <<
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 34b7f74b1ab8..d4c0a3b594af 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -160,11 +160,22 @@ struct ice_rule_query_data {
 	u16 vsi_handle;
 };
 
+/* This structure allows to pass info about lb_en and lan_en
+ * flags to ice_add_adv_rule. Values in act would be used
+ * only if act_valid was set to true, otherwise default
+ * values would be used.
+ */
+struct ice_adv_rule_flags_info {
+	u32 act;
+	u8 act_valid;		/* indicate if flags in act are valid */
+};
+
 struct ice_adv_rule_info {
 	struct ice_sw_act_ctrl sw_act;
 	u32 priority;
 	u8 rx; /* true means LOOKUP_RX otherwise LOOKUP_TX */
 	u16 fltr_rule_id;
+	struct ice_adv_rule_flags_info flags_info;
 };
 
 /* A collection of one or more four word recipe */
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 4c1daa1a02a1..1dccfd116bc9 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -274,6 +274,8 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
 		rule_info.sw_act.src = vsi->idx;
 		rule_info.rx = false;
+		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
+		rule_info.flags_info.act_valid = true;
 	}
 
 	/* specify the cookie as filter_rule_id */
@@ -296,12 +298,6 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	fltr->rid = rule_added.rid;
 	fltr->rule_id = rule_added.rule_id;
 
-	if (fltr->direction == ICE_ESWITCH_FLTR_EGRESS) {
-		if (ice_fltr_update_flags(vsi, fltr->rule_id, fltr->rid,
-					  ICE_SINGLE_ACT_LAN_ENABLE))
-			ice_rem_adv_rule_by_id(hw, &rule_added);
-	}
-
 exit:
 	kfree(list);
 	return ret;
-- 
2.31.1

