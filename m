Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD6642950A
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhJKRBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:01:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:22639 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233249AbhJKRBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 13:01:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="250312413"
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="250312413"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 09:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="591405470"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2021 09:59:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 7/9] ice: Allow changing lan_en and lb_en on all kinds of filters
Date:   Mon, 11 Oct 2021 09:57:40 -0700
Message-Id: <20211011165742.1144861-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
References: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

There is no way to change default lan_en and lb_en flags while
adding new rule. Add function that allows changing these flags
on rule determined by rule id and recipe id.

Function checks if the rule is presented on regular rules list or
advance rules list and call the appropriate function to update
rule entry.

As rules with ICE_SW_LKUP_DFLT recipe aren't tracked in a list,
implement function which updates flags without searching for rules
based only on rule id.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c | 127 ++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index c2e78eaf4ccb..f8c59df4ff9c 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -453,6 +453,133 @@ static u32 ice_fltr_build_action(u16 vsi_id)
 		ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_VALID_BIT;
 }
 
+/**
+ * ice_fltr_find_adv_entry - find advanced rule
+ * @rules: list of rules
+ * @rule_id: id of wanted rule
+ */
+static struct ice_adv_fltr_mgmt_list_entry *
+ice_fltr_find_adv_entry(struct list_head *rules, u16 rule_id)
+{
+	struct ice_adv_fltr_mgmt_list_entry *entry;
+
+	list_for_each_entry(entry, rules, list_entry) {
+		if (entry->rule_info.fltr_rule_id == rule_id)
+			return entry;
+	}
+
+	return NULL;
+}
+
+/**
+ * ice_fltr_update_adv_rule_flags - update flags on advanced rule
+ * @vsi: pointer to VSI
+ * @recipe_id: id of recipe
+ * @entry: advanced rule entry
+ * @new_flags: flags to update
+ */
+static enum ice_status
+ice_fltr_update_adv_rule_flags(struct ice_vsi *vsi, u16 recipe_id,
+			       struct ice_adv_fltr_mgmt_list_entry *entry,
+			       u32 new_flags)
+{
+	struct ice_adv_rule_info *info = &entry->rule_info;
+	struct ice_sw_act_ctrl *act = &info->sw_act;
+	u32 action;
+
+	if (act->fltr_act != ICE_FWD_TO_VSI)
+		return ICE_ERR_NOT_SUPPORTED;
+
+	action = ice_fltr_build_action(act->fwd_id.hw_vsi_id);
+
+	return ice_fltr_update_rule_flags(&vsi->back->hw, info->fltr_rule_id,
+					  recipe_id, action, info->sw_act.flag,
+					  act->src, new_flags);
+}
+
+/**
+ * ice_fltr_find_regular_entry - find regular rule
+ * @rules: list of rules
+ * @rule_id: id of wanted rule
+ */
+static struct ice_fltr_mgmt_list_entry *
+ice_fltr_find_regular_entry(struct list_head *rules, u16 rule_id)
+{
+	struct ice_fltr_mgmt_list_entry *entry;
+
+	list_for_each_entry(entry, rules, list_entry) {
+		if (entry->fltr_info.fltr_rule_id == rule_id)
+			return entry;
+	}
+
+	return NULL;
+}
+
+/**
+ * ice_fltr_update_regular_rule - update flags on regular rule
+ * @vsi: pointer to VSI
+ * @recipe_id: id of recipe
+ * @entry: regular rule entry
+ * @new_flags: flags to update
+ */
+static enum ice_status
+ice_fltr_update_regular_rule(struct ice_vsi *vsi, u16 recipe_id,
+			     struct ice_fltr_mgmt_list_entry *entry,
+			     u32 new_flags)
+{
+	struct ice_fltr_info *info = &entry->fltr_info;
+	u32 action;
+
+	if (info->fltr_act != ICE_FWD_TO_VSI)
+		return ICE_ERR_NOT_SUPPORTED;
+
+	action = ice_fltr_build_action(info->fwd_id.hw_vsi_id);
+
+	return ice_fltr_update_rule_flags(&vsi->back->hw, info->fltr_rule_id,
+					  recipe_id, action, info->flag,
+					  info->src, new_flags);
+}
+
+/**
+ * ice_fltr_update_flags - update flags on rule
+ * @vsi: pointer to VSI
+ * @rule_id: id of rule
+ * @recipe_id: id of recipe
+ * @new_flags: flags to update
+ *
+ * Function updates flags on regular and advance rule.
+ *
+ * Flags should be a combination of ICE_SINGLE_ACT_LB_ENABLE and
+ * ICE_SINGLE_ACT_LAN_ENABLE.
+ */
+enum ice_status
+ice_fltr_update_flags(struct ice_vsi *vsi, u16 rule_id, u16 recipe_id,
+		      u32 new_flags)
+{
+	struct ice_adv_fltr_mgmt_list_entry *adv_entry;
+	struct ice_fltr_mgmt_list_entry *regular_entry;
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_sw_recipe *recp_list;
+	struct list_head *fltr_rules;
+
+	recp_list = &hw->switch_info->recp_list[recipe_id];
+	if (!recp_list)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	fltr_rules = &recp_list->filt_rules;
+	regular_entry = ice_fltr_find_regular_entry(fltr_rules, rule_id);
+	if (regular_entry)
+		return ice_fltr_update_regular_rule(vsi, recipe_id,
+						    regular_entry, new_flags);
+
+	adv_entry = ice_fltr_find_adv_entry(fltr_rules, rule_id);
+	if (adv_entry)
+		return ice_fltr_update_adv_rule_flags(vsi, recipe_id,
+						      adv_entry, new_flags);
+
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
 /**
  * ice_fltr_update_flags_dflt_rule - update flags on default rule
  * @vsi: pointer to VSI
-- 
2.31.1

