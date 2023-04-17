Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315EC6E4412
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDQJiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjDQJh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:37:59 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E80526D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681724246; x=1713260246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GuJQiD6RkDYJhyVrZJC0Sje4NKSxONjJUI+NB333rdI=;
  b=ka6/oLqE1tl1jPhy369dwiBDDVb067mq9hiV3LWU0N+Ls1RuDKv4y6AT
   EdN01Dx1GDtgeHscEolrazLpfMThgbGpMK8CIlUgiGGUSdbdqpMI4vkCq
   AJB4Motm5mUC/vWToJHoJcqD8R/Nw4sGEIeOkQPTJSMxKoC1pxsMWCwQP
   mIofytXozJHHHRIlxe60Zo4G4q0MsHGMk4poHzB0P5f5U6R9x2vHvq6wm
   IQuv5CDvCLV4DdxjyVrsTdZExa4tt9mR20/2QOHralZbX4a2CWpf6Iwyz
   p0ltAJA0mmhB8Nv9msCCRTFQ9YS0PZXt+RDm4zpIWjPvQz+P9fxSDfTld
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333644090"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333644090"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 02:35:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640899261"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="640899261"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 02:35:21 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id C3DB237F56;
        Mon, 17 Apr 2023 10:35:20 +0100 (IST)
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        david.m.ertman@intel.com, michal.swiatkowski@linux.intel.com,
        marcin.szycik@linux.intel.com, pawel.chmielewski@intel.com,
        sridhar.samudrala@intel.com
Subject: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in switchdev
Date:   Mon, 17 Apr 2023 11:34:06 +0200
Message-Id: <20230417093412.12161-7-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417093412.12161-1-wojciech.drewek@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@intel.com>

Introduce new "guard" rule upon FDB entry creation.

It matches on src_mac, has valid bit unset, allow_pass_l2 set
and has a nop action.

Previously introduced "forward" rule matches on dst_mac, has valid
bit set, need_pass_l2 set and has a forward action.

With these rules, a packet will be offloaded only if FDB exists in both
directions (RX and TX).

Let's assume link partner sends a packet to VF1: src_mac = LP_MAC,
dst_mac = is VF1_MAC. Bridge adds FDB, two rules are created:
1. Guard rule matching on src_mac == LP_MAC
2. Forward rule matching on dst_mac == LP_MAC
Now VF1 responds with src_mac = VF1_MAC, dst_mac = LP_MAC. Before this
change, only one rule with dst_mac == LP_MAC would have existed, and the
packet would have been offloaded, meaning the bridge wouldn't add FDB in
the opposite direction. Now, the forward rule matches (dst_mac == LP_MAC),
but it has need_pass_l2 set an there is no guard rule with
src_mac == VF1_MAC, so the packet goes through slow-path and the bridge
adds FDB. Two rules are created:
1. Guard rule matching on src_mac == VF1_MAC
2. Forward rule matching on dst_mac == VF1_MAC
Further packets in both directions will be offloaded.

The same example is true in opposite direction (i.e. VF1 is the first to
send a packet out).

Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
---
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 66 ++++++++++++++++++-
 .../net/ethernet/intel/ice/ice_eswitch_br.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 45 ++++++++++---
 drivers/net/ethernet/intel/ice/ice_switch.h   |  5 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
 5 files changed, 109 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 4008665d5383..82b5eb2020cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -116,6 +116,8 @@ ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, u16 vsi_idx, int port_type,
 		goto err_add_rule;
 	}
 
+	rule_info.need_pass_l2 = true;
+
 	rule_info.sw_act.fltr_act = ICE_FWD_TO_VSI;
 
 	err = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, rule);
@@ -134,11 +136,56 @@ ice_eswitch_br_fwd_rule_create(struct ice_hw *hw, u16 vsi_idx, int port_type,
 	return ERR_PTR(err);
 }
 
+static struct ice_rule_query_data *
+ice_eswitch_br_guard_rule_create(struct ice_hw *hw, u16 vsi_idx,
+				 const unsigned char *mac)
+{
+	struct ice_adv_rule_info rule_info = { 0 };
+	struct ice_rule_query_data *rule;
+	struct ice_adv_lkup_elem *list;
+	const u16 lkups_cnt = 1;
+	int err;
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule) {
+		err = -ENOMEM;
+		goto err_exit;
+	}
+
+	list = kcalloc(lkups_cnt, sizeof(*list), GFP_ATOMIC);
+	if (!list) {
+		err = -ENOMEM;
+		goto err_list_alloc;
+	}
+
+	list[0].type = ICE_MAC_OFOS;
+	ether_addr_copy(list[0].h_u.eth_hdr.src_addr, mac);
+	eth_broadcast_addr(list[0].m_u.eth_hdr.src_addr);
+
+	rule_info.allow_pass_l2 = true;
+	rule_info.sw_act.vsi_handle = vsi_idx;
+	rule_info.sw_act.fltr_act = ICE_NOP;
+	rule_info.priority = 5;
+
+	err = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, rule);
+	if (err)
+		goto err_add_rule;
+
+	return rule;
+
+err_add_rule:
+	kfree(list);
+err_list_alloc:
+	kfree(rule);
+err_exit:
+	return ERR_PTR(err);
+}
+
 static struct ice_esw_br_flow *
 ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
 			   int port_type, const unsigned char *mac)
 {
-	struct ice_rule_query_data *fwd_rule;
+	struct ice_rule_query_data *fwd_rule, *guard_rule;
 	struct ice_esw_br_flow *flow;
 	int err;
 
@@ -155,10 +202,22 @@ ice_eswitch_br_flow_create(struct device *dev, struct ice_hw *hw, u16 vsi_idx,
 		goto err_fwd_rule;
 	}
 
+	guard_rule = ice_eswitch_br_guard_rule_create(hw, vsi_idx, mac);
+	if (IS_ERR(guard_rule)) {
+		err = PTR_ERR(guard_rule);
+		dev_err(dev, "Failed to create eswitch bridge %sgress guard rule, err: %d\n",
+			port_type == ICE_ESWITCH_BR_UPLINK_PORT ? "e" : "in",
+			err);
+		goto err_guard_rule;
+	}
+
 	flow->fwd_rule = fwd_rule;
+	flow->guard_rule = guard_rule;
 
 	return flow;
 
+err_guard_rule:
+	ice_eswitch_br_rule_delete(hw, fwd_rule);
 err_fwd_rule:
 	kfree(flow);
 
@@ -188,6 +247,11 @@ ice_eswitch_br_flow_delete(struct ice_pf *pf, struct ice_esw_br_flow *flow)
 		dev_err(dev, "Failed to delete FDB forward rule, err: %d\n",
 			err);
 
+	err = ice_eswitch_br_rule_delete(&pf->hw, flow->guard_rule);
+	if (err)
+		dev_err(dev, "Failed to delete FDB guard rule, err: %d\n",
+			err);
+
 	kfree(flow);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
index 4069eb45617e..73ad81bad655 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.h
@@ -13,6 +13,7 @@ struct ice_esw_br_fdb_data {
 
 struct ice_esw_br_flow {
 	struct ice_rule_query_data *fwd_rule;
+	struct ice_rule_query_data *guard_rule;
 };
 
 enum {
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 2ea9e1ae5517..6fbed7ccc5a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2277,6 +2277,10 @@ ice_get_recp_frm_fw(struct ice_hw *hw, struct ice_sw_recipe *recps, u8 rid,
 		/* Propagate some data to the recipe database */
 		recps[idx].is_root = !!is_root;
 		recps[idx].priority = root_bufs.content.act_ctrl_fwd_priority;
+		recps[idx].need_pass_l2 = root_bufs.content.act_ctrl &
+					  ICE_AQ_RECIPE_ACT_NEED_PASS_L2;
+		recps[idx].allow_pass_l2 = root_bufs.content.act_ctrl &
+					   ICE_AQ_RECIPE_ACT_ALLOW_PASS_L2;
 		bitmap_zero(recps[idx].res_idxs, ICE_MAX_FV_WORDS);
 		if (root_bufs.content.result_indx & ICE_AQ_RECIPE_RESULT_EN) {
 			recps[idx].chain_idx = root_bufs.content.result_indx &
@@ -4624,7 +4628,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
  */
 static u16
 ice_find_recp(struct ice_hw *hw, struct ice_prot_lkup_ext *lkup_exts,
-	      enum ice_sw_tunnel_type tun_type)
+	      struct ice_adv_rule_info *rinfo)
 {
 	bool refresh_required = true;
 	struct ice_sw_recipe *recp;
@@ -4685,9 +4689,12 @@ ice_find_recp(struct ice_hw *hw, struct ice_prot_lkup_ext *lkup_exts,
 			}
 			/* If for "i"th recipe the found was never set to false
 			 * then it means we found our match
-			 * Also tun type of recipe needs to be checked
+			 * Also tun type and *_pass_l2 of recipe needs to be
+			 * checked
 			 */
-			if (found && recp[i].tun_type == tun_type)
+			if (found && recp[i].tun_type == rinfo->tun_type &&
+			    recp[i].need_pass_l2 == rinfo->need_pass_l2 &&
+			    recp[i].allow_pass_l2 == rinfo->allow_pass_l2)
 				return i; /* Return the recipe ID */
 		}
 	}
@@ -5075,6 +5082,14 @@ ice_add_sw_recipe(struct ice_hw *hw, struct ice_sw_recipe *rm,
 		set_bit(buf[recps].recipe_indx,
 			(unsigned long *)buf[recps].recipe_bitmap);
 		buf[recps].content.act_ctrl_fwd_priority = rm->priority;
+
+		if (rm->need_pass_l2)
+			buf[recps].content.act_ctrl |=
+				ICE_AQ_RECIPE_ACT_NEED_PASS_L2;
+
+		if (rm->allow_pass_l2)
+			buf[recps].content.act_ctrl |=
+				ICE_AQ_RECIPE_ACT_ALLOW_PASS_L2;
 		recps++;
 	}
 
@@ -5225,6 +5240,8 @@ ice_add_sw_recipe(struct ice_hw *hw, struct ice_sw_recipe *rm,
 		recp->priority = buf[buf_idx].content.act_ctrl_fwd_priority;
 		recp->n_grp_count = rm->n_grp_count;
 		recp->tun_type = rm->tun_type;
+		recp->need_pass_l2 = rm->need_pass_l2;
+		recp->allow_pass_l2 = rm->allow_pass_l2;
 		recp->recp_created = true;
 	}
 	rm->root_buf = buf;
@@ -5393,6 +5410,9 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	/* set the recipe priority if specified */
 	rm->priority = (u8)rinfo->priority;
 
+	rm->need_pass_l2 = rinfo->need_pass_l2;
+	rm->allow_pass_l2 = rinfo->allow_pass_l2;
+
 	/* Find offsets from the field vector. Pick the first one for all the
 	 * recipes.
 	 */
@@ -5408,7 +5428,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	}
 
 	/* Look for a recipe which matches our requested fv / mask list */
-	*rid = ice_find_recp(hw, lkup_exts, rinfo->tun_type);
+	*rid = ice_find_recp(hw, lkup_exts, rinfo);
 	if (*rid < ICE_MAX_NUM_RECIPES)
 		/* Success if found a recipe that match the existing criteria */
 		goto err_unroll;
@@ -5846,7 +5866,9 @@ static bool ice_rules_equal(const struct ice_adv_rule_info *first,
 	return first->sw_act.flag == second->sw_act.flag &&
 	       first->tun_type == second->tun_type &&
 	       first->vlan_type == second->vlan_type &&
-	       first->src_vsi == second->src_vsi;
+	       first->src_vsi == second->src_vsi &&
+	       first->need_pass_l2 == second->need_pass_l2 &&
+	       first->allow_pass_l2 == second->allow_pass_l2;
 }
 
 /**
@@ -6085,7 +6107,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (!(rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI ||
 	      rinfo->sw_act.fltr_act == ICE_FWD_TO_Q ||
 	      rinfo->sw_act.fltr_act == ICE_FWD_TO_QGRP ||
-	      rinfo->sw_act.fltr_act == ICE_DROP_PACKET)) {
+	      rinfo->sw_act.fltr_act == ICE_DROP_PACKET ||
+	      rinfo->sw_act.fltr_act == ICE_NOP)) {
 		status = -EIO;
 		goto free_pkt_profile;
 	}
@@ -6096,7 +6119,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		goto free_pkt_profile;
 	}
 
-	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI)
+	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI ||
+	    rinfo->sw_act.fltr_act == ICE_NOP)
 		rinfo->sw_act.fwd_id.hw_vsi_id =
 			ice_get_hw_vsi_num(hw, vsi_handle);
 
@@ -6166,6 +6190,11 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		act |= ICE_SINGLE_ACT_VSI_FORWARDING | ICE_SINGLE_ACT_DROP |
 		       ICE_SINGLE_ACT_VALID_BIT;
 		break;
+	case ICE_NOP:
+		act |= (rinfo->sw_act.fwd_id.hw_vsi_id <<
+			ICE_SINGLE_ACT_VSI_ID_S) & ICE_SINGLE_ACT_VSI_ID_M;
+		act &= ~ICE_SINGLE_ACT_VALID_BIT;
+		break;
 	default:
 		status = -EIO;
 		goto err_ice_add_adv_rule;
@@ -6446,7 +6475,7 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 			return -EIO;
 	}
 
-	rid = ice_find_recp(hw, &lkup_exts, rinfo->tun_type);
+	rid = ice_find_recp(hw, &lkup_exts, rinfo);
 	/* If did not find a recipe that match the existing criteria */
 	if (rid == ICE_MAX_NUM_RECIPES)
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index c84b56fe84a5..5ecce39cf1f5 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -191,6 +191,8 @@ struct ice_adv_rule_info {
 	u16 vlan_type;
 	u16 fltr_rule_id;
 	u32 priority;
+	u8 need_pass_l2;
+	u8 allow_pass_l2;
 	u16 src_vsi;
 	struct ice_sw_act_ctrl sw_act;
 	struct ice_adv_rule_flags_info flags_info;
@@ -254,6 +256,9 @@ struct ice_sw_recipe {
 	 */
 	u8 priority;
 
+	u8 need_pass_l2;
+	u8 allow_pass_l2;
+
 	struct list_head rg_list;
 
 	/* AQ buffer associated with this recipe */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 5602695243a8..96977d6fc149 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -1034,6 +1034,7 @@ enum ice_sw_fwd_act_type {
 	ICE_FWD_TO_Q,
 	ICE_FWD_TO_QGRP,
 	ICE_DROP_PACKET,
+	ICE_NOP,
 	ICE_INVAL_ACT
 };
 
-- 
2.39.2

