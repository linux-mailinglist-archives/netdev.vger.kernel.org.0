Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B80E429507
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhJKRBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:01:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:61105 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhJKRBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 13:01:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="224335717"
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="224335717"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 09:59:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="591405462"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2021 09:59:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Shivanshu Shukla <shivanshu.shukla@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com, Dan Nowlin <dan.nowlin@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 5/9] ice: allow deleting advanced rules
Date:   Mon, 11 Oct 2021 09:57:38 -0700
Message-Id: <20211011165742.1144861-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
References: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shivanshu Shukla <shivanshu.shukla@intel.com>

To remove advanced rule the same protocols list like in adding should be
send to function. Based on this information list of advanced rules is
searched to find the correct rule id.

Remove advanced rule if it forwards to only one VSI. If it forwards
to list of VSI remove only input VSI from this list.

Introduce function to remove rule by id. It is used in case rule needs to
be removed even if it forwards to the list of VSI.

Allow removing all advanced rules from a particular VSI. It is useful in
rebuilding VSI path.

Co-developed-by: Dan Nowlin <dan.nowlin@intel.com>
Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Signed-off-by: Shivanshu Shukla <shivanshu.shukla@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 223 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_switch.h |   6 +
 2 files changed, 229 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 4042d91de06c..81dee4ba2dc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4922,6 +4922,229 @@ ice_replay_vsi_fltr(struct ice_hw *hw, u16 vsi_handle, u8 recp_id,
 	return status;
 }
 
+/**
+ * ice_adv_rem_update_vsi_list
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: VSI handle of the VSI to remove
+ * @fm_list: filter management entry for which the VSI list management needs to
+ *	     be done
+ */
+static enum ice_status
+ice_adv_rem_update_vsi_list(struct ice_hw *hw, u16 vsi_handle,
+			    struct ice_adv_fltr_mgmt_list_entry *fm_list)
+{
+	struct ice_vsi_list_map_info *vsi_list_info;
+	enum ice_sw_lkup_type lkup_type;
+	enum ice_status status;
+	u16 vsi_list_id;
+
+	if (fm_list->rule_info.sw_act.fltr_act != ICE_FWD_TO_VSI_LIST ||
+	    fm_list->vsi_count == 0)
+		return ICE_ERR_PARAM;
+
+	/* A rule with the VSI being removed does not exist */
+	if (!test_bit(vsi_handle, fm_list->vsi_list_info->vsi_map))
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	lkup_type = ICE_SW_LKUP_LAST;
+	vsi_list_id = fm_list->rule_info.sw_act.fwd_id.vsi_list_id;
+	status = ice_update_vsi_list_rule(hw, &vsi_handle, 1, vsi_list_id, true,
+					  ice_aqc_opc_update_sw_rules,
+					  lkup_type);
+	if (status)
+		return status;
+
+	fm_list->vsi_count--;
+	clear_bit(vsi_handle, fm_list->vsi_list_info->vsi_map);
+	vsi_list_info = fm_list->vsi_list_info;
+	if (fm_list->vsi_count == 1) {
+		struct ice_fltr_info tmp_fltr;
+		u16 rem_vsi_handle;
+
+		rem_vsi_handle = find_first_bit(vsi_list_info->vsi_map,
+						ICE_MAX_VSI);
+		if (!ice_is_vsi_valid(hw, rem_vsi_handle))
+			return ICE_ERR_OUT_OF_RANGE;
+
+		/* Make sure VSI list is empty before removing it below */
+		status = ice_update_vsi_list_rule(hw, &rem_vsi_handle, 1,
+						  vsi_list_id, true,
+						  ice_aqc_opc_update_sw_rules,
+						  lkup_type);
+		if (status)
+			return status;
+
+		memset(&tmp_fltr, 0, sizeof(tmp_fltr));
+		tmp_fltr.flag = fm_list->rule_info.sw_act.flag;
+		tmp_fltr.fltr_rule_id = fm_list->rule_info.fltr_rule_id;
+		fm_list->rule_info.sw_act.fltr_act = ICE_FWD_TO_VSI;
+		tmp_fltr.fltr_act = ICE_FWD_TO_VSI;
+		tmp_fltr.fwd_id.hw_vsi_id =
+			ice_get_hw_vsi_num(hw, rem_vsi_handle);
+		fm_list->rule_info.sw_act.fwd_id.hw_vsi_id =
+			ice_get_hw_vsi_num(hw, rem_vsi_handle);
+		fm_list->rule_info.sw_act.vsi_handle = rem_vsi_handle;
+
+		/* Update the previous switch rule of "MAC forward to VSI" to
+		 * "MAC fwd to VSI list"
+		 */
+		status = ice_update_pkt_fwd_rule(hw, &tmp_fltr);
+		if (status) {
+			ice_debug(hw, ICE_DBG_SW, "Failed to update pkt fwd rule to FWD_TO_VSI on HW VSI %d, error %d\n",
+				  tmp_fltr.fwd_id.hw_vsi_id, status);
+			return status;
+		}
+		fm_list->vsi_list_info->ref_cnt--;
+
+		/* Remove the VSI list since it is no longer used */
+		status = ice_remove_vsi_list_rule(hw, vsi_list_id, lkup_type);
+		if (status) {
+			ice_debug(hw, ICE_DBG_SW, "Failed to remove VSI list %d, error %d\n",
+				  vsi_list_id, status);
+			return status;
+		}
+
+		list_del(&vsi_list_info->list_entry);
+		devm_kfree(ice_hw_to_dev(hw), vsi_list_info);
+		fm_list->vsi_list_info = NULL;
+	}
+
+	return status;
+}
+
+/**
+ * ice_rem_adv_rule - removes existing advanced switch rule
+ * @hw: pointer to the hardware structure
+ * @lkups: information on the words that needs to be looked up. All words
+ *         together makes one recipe
+ * @lkups_cnt: num of entries in the lkups array
+ * @rinfo: Its the pointer to the rule information for the rule
+ *
+ * This function can be used to remove 1 rule at a time. The lkups is
+ * used to describe all the words that forms the "lookup" portion of the
+ * rule. These words can span multiple protocols. Callers to this function
+ * need to pass in a list of protocol headers with lookup information along
+ * and mask that determines which words are valid from the given protocol
+ * header. rinfo describes other information related to this rule such as
+ * forwarding IDs, priority of this rule, etc.
+ */
+static enum ice_status
+ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
+		 u16 lkups_cnt, struct ice_adv_rule_info *rinfo)
+{
+	struct ice_adv_fltr_mgmt_list_entry *list_elem;
+	struct ice_prot_lkup_ext lkup_exts;
+	enum ice_status status = 0;
+	bool remove_rule = false;
+	struct mutex *rule_lock; /* Lock to protect filter rule list */
+	u16 i, rid, vsi_handle;
+
+	memset(&lkup_exts, 0, sizeof(lkup_exts));
+	for (i = 0; i < lkups_cnt; i++) {
+		u16 count;
+
+		if (lkups[i].type >= ICE_PROTOCOL_LAST)
+			return ICE_ERR_CFG;
+
+		count = ice_fill_valid_words(&lkups[i], &lkup_exts);
+		if (!count)
+			return ICE_ERR_CFG;
+	}
+
+	rid = ice_find_recp(hw, &lkup_exts);
+	/* If did not find a recipe that match the existing criteria */
+	if (rid == ICE_MAX_NUM_RECIPES)
+		return ICE_ERR_PARAM;
+
+	rule_lock = &hw->switch_info->recp_list[rid].filt_rule_lock;
+	list_elem = ice_find_adv_rule_entry(hw, lkups, lkups_cnt, rid, rinfo);
+	/* the rule is already removed */
+	if (!list_elem)
+		return 0;
+	mutex_lock(rule_lock);
+	if (list_elem->rule_info.sw_act.fltr_act != ICE_FWD_TO_VSI_LIST) {
+		remove_rule = true;
+	} else if (list_elem->vsi_count > 1) {
+		remove_rule = false;
+		vsi_handle = rinfo->sw_act.vsi_handle;
+		status = ice_adv_rem_update_vsi_list(hw, vsi_handle, list_elem);
+	} else {
+		vsi_handle = rinfo->sw_act.vsi_handle;
+		status = ice_adv_rem_update_vsi_list(hw, vsi_handle, list_elem);
+		if (status) {
+			mutex_unlock(rule_lock);
+			return status;
+		}
+		if (list_elem->vsi_count == 0)
+			remove_rule = true;
+	}
+	mutex_unlock(rule_lock);
+	if (remove_rule) {
+		struct ice_aqc_sw_rules_elem *s_rule;
+		u16 rule_buf_sz;
+
+		rule_buf_sz = ICE_SW_RULE_RX_TX_NO_HDR_SIZE;
+		s_rule = kzalloc(rule_buf_sz, GFP_KERNEL);
+		if (!s_rule)
+			return ICE_ERR_NO_MEMORY;
+		s_rule->pdata.lkup_tx_rx.act = 0;
+		s_rule->pdata.lkup_tx_rx.index =
+			cpu_to_le16(list_elem->rule_info.fltr_rule_id);
+		s_rule->pdata.lkup_tx_rx.hdr_len = 0;
+		status = ice_aq_sw_rules(hw, (struct ice_aqc_sw_rules *)s_rule,
+					 rule_buf_sz, 1,
+					 ice_aqc_opc_remove_sw_rules, NULL);
+		if (!status || status == ICE_ERR_DOES_NOT_EXIST) {
+			struct ice_switch_info *sw = hw->switch_info;
+
+			mutex_lock(rule_lock);
+			list_del(&list_elem->list_entry);
+			devm_kfree(ice_hw_to_dev(hw), list_elem->lkups);
+			devm_kfree(ice_hw_to_dev(hw), list_elem);
+			mutex_unlock(rule_lock);
+			if (list_empty(&sw->recp_list[rid].filt_rules))
+				sw->recp_list[rid].adv_rule = false;
+		}
+		kfree(s_rule);
+	}
+	return status;
+}
+
+/**
+ * ice_rem_adv_rule_by_id - removes existing advanced switch rule by ID
+ * @hw: pointer to the hardware structure
+ * @remove_entry: data struct which holds rule_id, VSI handle and recipe ID
+ *
+ * This function is used to remove 1 rule at a time. The removal is based on
+ * the remove_entry parameter. This function will remove rule for a given
+ * vsi_handle with a given rule_id which is passed as parameter in remove_entry
+ */
+enum ice_status
+ice_rem_adv_rule_by_id(struct ice_hw *hw,
+		       struct ice_rule_query_data *remove_entry)
+{
+	struct ice_adv_fltr_mgmt_list_entry *list_itr;
+	struct list_head *list_head;
+	struct ice_adv_rule_info rinfo;
+	struct ice_switch_info *sw;
+
+	sw = hw->switch_info;
+	if (!sw->recp_list[remove_entry->rid].recp_created)
+		return ICE_ERR_PARAM;
+	list_head = &sw->recp_list[remove_entry->rid].filt_rules;
+	list_for_each_entry(list_itr, list_head, list_entry) {
+		if (list_itr->rule_info.fltr_rule_id ==
+		    remove_entry->rule_id) {
+			rinfo = list_itr->rule_info;
+			rinfo.sw_act.vsi_handle = remove_entry->vsi_handle;
+			return ice_rem_adv_rule(hw, list_itr->lkups,
+						list_itr->lkups_cnt, &rinfo);
+		}
+	}
+	/* either list is empty or unable to find rule */
+	return ICE_ERR_DOES_NOT_EXIST;
+}
+
 /**
  * ice_replay_vsi_all_fltr - replay all filters stored in bookkeeping lists
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 5175371f7ae9..34b7f74b1ab8 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -342,6 +342,12 @@ enum ice_status
 ice_set_vlan_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 			 bool rm_vlan_promisc);
 
+enum ice_status
+ice_rem_adv_rule_for_vsi(struct ice_hw *hw, u16 vsi_handle);
+enum ice_status
+ice_rem_adv_rule_by_id(struct ice_hw *hw,
+		       struct ice_rule_query_data *remove_entry);
+
 enum ice_status ice_init_def_sw_recp(struct ice_hw *hw);
 u16 ice_get_hw_vsi_num(struct ice_hw *hw, u16 vsi_handle);
 
-- 
2.31.1

