Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C312426037
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbhJGXKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:15518 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233716AbhJGXKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340359"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340359"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344333"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 06/12] ice: allow changing lan_en and lb_en on dflt rules
Date:   Thu,  7 Oct 2021 16:06:14 -0700
Message-Id: <20211007230620.3413290-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

There is no way to change default lan_en and lb_en flags while
adding new rule. Add function that allows changing these flags
on ICE_SW_LKUP_DFLT recipe and any rule id.

lan_en allows packet to go outside if rule is matched. Clearing
this bit will block packet from sending it outside.

lb_en allows packet to be forwarded to other VSI. Clearing
this bit will block packet from forwarding it to other VSI.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c   | 80 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fltr.h   |  7 ++
 drivers/net/ethernet/intel/ice/ice_switch.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_switch.h |  6 ++
 4 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index 2418d4fff037..c2e78eaf4ccb 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -395,3 +395,83 @@ enum ice_status ice_fltr_remove_eth(struct ice_vsi *vsi, u16 ethertype,
 	return ice_fltr_prepare_eth(vsi, ethertype, flag, action,
 				    ice_fltr_remove_eth_list);
 }
+
+/**
+ * ice_fltr_update_rule_flags - update lan_en/lb_en flags
+ * @hw: pointer to hw
+ * @rule_id: id of rule being updated
+ * @recipe_id: recipe id of rule
+ * @act: current action field
+ * @type: Rx or Tx
+ * @src: source VSI
+ * @new_flags: combinations of lb_en and lan_en
+ */
+static enum ice_status
+ice_fltr_update_rule_flags(struct ice_hw *hw, u16 rule_id, u16 recipe_id,
+			   u32 act, u16 type, u16 src, u32 new_flags)
+{
+	struct ice_aqc_sw_rules_elem *s_rule;
+	enum ice_status err;
+	u32 flags_mask;
+
+	s_rule = kzalloc(ICE_SW_RULE_RX_TX_NO_HDR_SIZE, GFP_KERNEL);
+	if (!s_rule)
+		return ICE_ERR_NO_MEMORY;
+
+	flags_mask = ICE_SINGLE_ACT_LB_ENABLE | ICE_SINGLE_ACT_LAN_ENABLE;
+	act &= ~flags_mask;
+	act |= (flags_mask & new_flags);
+
+	s_rule->pdata.lkup_tx_rx.recipe_id = cpu_to_le16(recipe_id);
+	s_rule->pdata.lkup_tx_rx.index = cpu_to_le16(rule_id);
+	s_rule->pdata.lkup_tx_rx.act = cpu_to_le32(act);
+
+	if (type & ICE_FLTR_RX) {
+		s_rule->pdata.lkup_tx_rx.src =
+			cpu_to_le16(hw->port_info->lport);
+		s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
+
+	} else {
+		s_rule->pdata.lkup_tx_rx.src = cpu_to_le16(src);
+		s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
+	}
+
+	err = ice_aq_sw_rules(hw, s_rule, ICE_SW_RULE_RX_TX_NO_HDR_SIZE, 1,
+			      ice_aqc_opc_update_sw_rules, NULL);
+
+	kfree(s_rule);
+	return err;
+}
+
+/**
+ * ice_fltr_build_action - build action for rule
+ * @vsi_id: id of VSI which is use to build action
+ */
+static u32 ice_fltr_build_action(u16 vsi_id)
+{
+	return ((vsi_id << ICE_SINGLE_ACT_VSI_ID_S) & ICE_SINGLE_ACT_VSI_ID_M) |
+		ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_VALID_BIT;
+}
+
+/**
+ * ice_fltr_update_flags_dflt_rule - update flags on default rule
+ * @vsi: pointer to VSI
+ * @rule_id: id of rule
+ * @direction: Tx or Rx
+ * @new_flags: flags to update
+ *
+ * Function updates flags on default rule with ICE_SW_LKUP_DFLT.
+ *
+ * Flags should be a combination of ICE_SINGLE_ACT_LB_ENABLE and
+ * ICE_SINGLE_ACT_LAN_ENABLE.
+ */
+enum ice_status
+ice_fltr_update_flags_dflt_rule(struct ice_vsi *vsi, u16 rule_id, u8 direction,
+				u32 new_flags)
+{
+	u32 action = ice_fltr_build_action(vsi->vsi_num);
+	struct ice_hw *hw = &vsi->back->hw;
+
+	return ice_fltr_update_rule_flags(hw, rule_id, ICE_SW_LKUP_DFLT, action,
+					  direction, vsi->vsi_num, new_flags);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.h b/drivers/net/ethernet/intel/ice/ice_fltr.h
index 361cb4da9b43..949e38ce016c 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.h
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.h
@@ -36,4 +36,11 @@ enum ice_status
 ice_fltr_remove_eth(struct ice_vsi *vsi, u16 ethertype, u16 flag,
 		    enum ice_sw_fwd_act_type action);
 void ice_fltr_remove_all(struct ice_vsi *vsi);
+
+enum ice_status
+ice_fltr_update_flags(struct ice_vsi *vsi, u16 rule_id, u16 recipe_id,
+		      u32 new_flags);
+enum ice_status
+ice_fltr_update_flags_dflt_rule(struct ice_vsi *vsi, u16 rule_id, u8 direction,
+				u32 new_flags);
 #endif
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 3b6c1420aa7b..1e86a6dba454 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -518,7 +518,7 @@ ice_aq_alloc_free_vsi_list(struct ice_hw *hw, u16 *vsi_list_id,
  *
  * Add(0x02a0)/Update(0x02a1)/Remove(0x02a2) switch rules commands to firmware
  */
-static enum ice_status
+enum ice_status
 ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
 		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd *cd)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index c5db8d56133f..e6eeffb3dde9 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -14,6 +14,9 @@
 #define ICE_VSI_INVAL_ID 0xffff
 #define ICE_INVAL_Q_HANDLE 0xFFFF
 
+#define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr))
+
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
 	u16 vsi_num;
@@ -251,4 +254,7 @@ u16 ice_get_hw_vsi_num(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status ice_replay_vsi_all_fltr(struct ice_hw *hw, u16 vsi_handle);
 void ice_rm_all_sw_replay_rule_info(struct ice_hw *hw);
 
+enum ice_status
+ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
+		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd *cd);
 #endif /* _ICE_SWITCH_H_ */
-- 
2.31.1

