Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE606DB138
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDGRLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjDGRLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:11:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43B8B765
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680887468; x=1712423468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=saNBIfEqKt9DGVGtJOf6eLiBhQZWo92wJsMv61TEjgs=;
  b=HgSf0e0DzjparVNVDDZjOpndpXbx0yEIISy/fCeEjiKCq5h2chT1iPd4
   6YNVVami6kU0iCTJhAjqCYSRzGxv9u377nlQEdyviz0oZK68fSAuxWIiz
   QGGlIZvxyXZZvlYIrtCMDg/Ec8d7YhCuFMA10OIlh2nBbBBvnKfOr2gJJ
   0vsEAjWDqIAmUUSHhl2Bjq+ReBv7izPy4HTrwJEu/mSglc9xmUcFuuSds
   Oo++EePTRXxl9CTSXKzhOnIw8bbq79M+IvNzgeamz+DbdXGiVQY4Zi/D/
   42BHwKoBXKdTi2ZHuu/nu7HGvSjC5pQ+uyH7WTMHH72newIk45Hjvnsgk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="344805727"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="344805727"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 10:11:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="687569952"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="687569952"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2023 10:11:06 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com, pmenzel@molgen.mpg.de,
        aleksander.lobakin@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 4/5] ice: allow matching on meta data
Date:   Fri,  7 Apr 2023 18:52:18 +0200
Message-Id: <20230407165219.2737504-5-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add meta data matching criteria in the same place as protocol matching
criteria. There is no need to add meta data as special words after
parsing all lookups. Trade meta data in the same why as other lookups.

The one difference between meta data lookups and protocol lookups is
that meta data doesn't impact how the packets looks like. Because of that
ignore it when filling testing packet.

Match on tunnel type meta data always if tunnel type is different than
TNL_LAST.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/intel/ice/ice_protocol_type.h    |   8 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 158 +++++++-----------
 drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  29 +++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   1 +
 5 files changed, 95 insertions(+), 105 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 8a84f106bd4d..ed0ab8177c61 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -47,6 +47,7 @@ enum ice_protocol_type {
 	ICE_L2TPV3,
 	ICE_VLAN_EX,
 	ICE_VLAN_IN,
+	ICE_HW_METADATA,
 	ICE_VXLAN_GPE,
 	ICE_SCTP_IL,
 	ICE_PROTOCOL_LAST
@@ -387,6 +388,13 @@ enum ice_hw_metadata_offset {
 	ICE_PKT_ERROR_MDID_OFFSET = ICE_MDID_SIZE * ICE_PKT_ERROR_MDID,
 };
 
+enum ice_pkt_flags {
+	ICE_PKT_FLAGS_VLAN = 0,
+	ICE_PKT_FLAGS_TUNNEL = 1,
+	ICE_PKT_FLAGS_TCP = 2,
+	ICE_PKT_FLAGS_ERROR = 3,
+};
+
 struct ice_hw_metadata {
 	__be16 source_port;
 	__be16 ptype;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index baa61a2b82f0..9578bd0a2d65 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4578,6 +4578,15 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	ICE_PROTOCOL_ENTRY(ICE_L2TPV3, 0, 2, 4, 6, 8, 10),
 	ICE_PROTOCOL_ENTRY(ICE_VLAN_EX, 2, 0),
 	ICE_PROTOCOL_ENTRY(ICE_VLAN_IN, 2, 0),
+	ICE_PROTOCOL_ENTRY(ICE_HW_METADATA,
+			   ICE_SOURCE_PORT_MDID_OFFSET,
+			   ICE_PTYPE_MDID_OFFSET,
+			   ICE_PACKET_LENGTH_MDID_OFFSET,
+			   ICE_SOURCE_VSI_MDID_OFFSET,
+			   ICE_PKT_VLAN_MDID_OFFSET,
+			   ICE_PKT_TUNNEL_MDID_OFFSET,
+			   ICE_PKT_TCP_MDID_OFFSET,
+			   ICE_PKT_ERROR_MDID_OFFSET),
 };
 
 static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
@@ -4602,6 +4611,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_L2TPV3,		ICE_L2TPV3_HW },
 	{ ICE_VLAN_EX,          ICE_VLAN_OF_HW },
 	{ ICE_VLAN_IN,          ICE_VLAN_OL_HW },
+	{ ICE_HW_METADATA,      ICE_META_DATA_ID_HW },
 };
 
 /**
@@ -5260,72 +5270,6 @@ ice_create_recipe_group(struct ice_hw *hw, struct ice_sw_recipe *rm,
 	return status;
 }
 
-/**
- * ice_tun_type_match_word - determine if tun type needs a match mask
- * @tun_type: tunnel type
- * @mask: mask to be used for the tunnel
- */
-static bool ice_tun_type_match_word(enum ice_sw_tunnel_type tun_type, u16 *mask)
-{
-	switch (tun_type) {
-	case ICE_SW_TUN_GENEVE:
-	case ICE_SW_TUN_VXLAN:
-	case ICE_SW_TUN_NVGRE:
-	case ICE_SW_TUN_GTPU:
-	case ICE_SW_TUN_GTPC:
-		*mask = ICE_PKT_TUNNEL_MASK;
-		return true;
-
-	default:
-		*mask = 0;
-		return false;
-	}
-}
-
-/**
- * ice_add_special_words - Add words that are not protocols, such as metadata
- * @rinfo: other information regarding the rule e.g. priority and action info
- * @lkup_exts: lookup word structure
- * @dvm_ena: is double VLAN mode enabled
- */
-static int
-ice_add_special_words(struct ice_adv_rule_info *rinfo,
-		      struct ice_prot_lkup_ext *lkup_exts, bool dvm_ena)
-{
-	u16 mask;
-
-	/* If this is a tunneled packet, then add recipe index to match the
-	 * tunnel bit in the packet metadata flags.
-	 */
-	if (ice_tun_type_match_word(rinfo->tun_type, &mask)) {
-		if (lkup_exts->n_val_words < ICE_MAX_CHAIN_WORDS) {
-			u8 word = lkup_exts->n_val_words++;
-
-			lkup_exts->fv_words[word].prot_id = ICE_META_DATA_ID_HW;
-			lkup_exts->fv_words[word].off =
-				ICE_PKT_TUNNEL_MDID_OFFSET;
-			lkup_exts->field_mask[word] = mask;
-		} else {
-			return -ENOSPC;
-		}
-	}
-
-	if (rinfo->vlan_type != 0 && dvm_ena) {
-		if (lkup_exts->n_val_words < ICE_MAX_CHAIN_WORDS) {
-			u8 word = lkup_exts->n_val_words++;
-
-			lkup_exts->fv_words[word].prot_id = ICE_META_DATA_ID_HW;
-			lkup_exts->fv_words[word].off =
-				ICE_PKT_VLAN_MDID_OFFSET;
-			lkup_exts->field_mask[word] = ICE_PKT_VLAN_MASK;
-		} else {
-			return -ENOSPC;
-		}
-	}
-
-	return 0;
-}
-
 /* ice_get_compat_fv_bitmap - Get compatible field vector bitmap for rule
  * @hw: pointer to hardware structure
  * @rinfo: other information regarding the rule e.g. priority and action info
@@ -5439,13 +5383,6 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (status)
 		goto err_unroll;
 
-	/* Create any special protocol/offset pairs, such as looking at tunnel
-	 * bits by extracting metadata
-	 */
-	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
-	if (status)
-		goto err_unroll;
-
 	/* Group match words into recipes using preferred recipe grouping
 	 * criteria.
 	 */
@@ -5731,6 +5668,10 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
 		 * was already checked when search for the dummy packet
 		 */
 		type = lkups[i].type;
+		/* metadata isn't present in the packet */
+		if (type == ICE_HW_METADATA)
+			continue;
+
 		for (j = 0; offsets[j].type != ICE_PROTOCOL_LAST; j++) {
 			if (type == offsets[j].type) {
 				offset = offsets[j].offset;
@@ -5866,16 +5807,21 @@ ice_fill_adv_packet_tun(struct ice_hw *hw, enum ice_sw_tunnel_type tun_type,
 
 /**
  * ice_fill_adv_packet_vlan - fill dummy packet with VLAN tag type
+ * @hw: pointer to hw structure
  * @vlan_type: VLAN tag type
  * @pkt: dummy packet to fill in
  * @offsets: offset info for the dummy packet
  */
 static int
-ice_fill_adv_packet_vlan(u16 vlan_type, u8 *pkt,
+ice_fill_adv_packet_vlan(struct ice_hw *hw, u16 vlan_type, u8 *pkt,
 			 const struct ice_dummy_pkt_offsets *offsets)
 {
 	u16 i;
 
+	/* Check if there is something to do */
+	if (!vlan_type || !ice_is_dvm_ena(hw))
+		return 0;
+
 	/* Find VLAN header and insert VLAN TPID */
 	for (i = 0; offsets[i].type != ICE_PROTOCOL_LAST; i++) {
 		if (offsets[i].type == ICE_VLAN_OFOS ||
@@ -5894,6 +5840,15 @@ ice_fill_adv_packet_vlan(u16 vlan_type, u8 *pkt,
 	return -EIO;
 }
 
+static bool ice_rules_equal(const struct ice_adv_rule_info *first,
+			    const struct ice_adv_rule_info *second)
+{
+	return first->sw_act.flag == second->sw_act.flag &&
+	       first->tun_type == second->tun_type &&
+	       first->vlan_type == second->vlan_type &&
+	       first->src_vsi == second->src_vsi;
+}
+
 /**
  * ice_find_adv_rule_entry - Search a rule entry
  * @hw: pointer to the hardware structure
@@ -5927,9 +5882,7 @@ ice_find_adv_rule_entry(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 				lkups_matched = false;
 				break;
 			}
-		if (rinfo->sw_act.flag == list_itr->rule_info.sw_act.flag &&
-		    rinfo->tun_type == list_itr->rule_info.tun_type &&
-		    rinfo->vlan_type == list_itr->rule_info.vlan_type &&
+		if (ice_rules_equal(rinfo, &list_itr->rule_info) &&
 		    lkups_matched)
 			return list_itr;
 	}
@@ -6045,6 +5998,20 @@ ice_adv_add_update_vsi_list(struct ice_hw *hw,
 	return status;
 }
 
+void ice_rule_add_tunnel_metadata(struct ice_adv_lkup_elem *lkup)
+{
+	lkup->type = ICE_HW_METADATA;
+	lkup->m_u.metadata.flags[ICE_PKT_FLAGS_TUNNEL] =
+		cpu_to_be16(ICE_PKT_TUNNEL_MASK);
+}
+
+void ice_rule_add_vlan_metadata(struct ice_adv_lkup_elem *lkup)
+{
+	lkup->type = ICE_HW_METADATA;
+	lkup->m_u.metadata.flags[ICE_PKT_FLAGS_VLAN] =
+		cpu_to_be16(ICE_PKT_VLAN_MASK);
+}
+
 /**
  * ice_add_adv_rule - helper function to create an advanced switch rule
  * @hw: pointer to the hardware structure
@@ -6126,7 +6093,11 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI)
 		rinfo->sw_act.fwd_id.hw_vsi_id =
 			ice_get_hw_vsi_num(hw, vsi_handle);
-	rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
+
+	if (rinfo->src_vsi)
+		rinfo->sw_act.src = ice_get_hw_vsi_num(hw, rinfo->src_vsi);
+	else
+		rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
 
 	status = ice_add_adv_recipe(hw, lkups, lkups_cnt, rinfo, &rid);
 	if (status)
@@ -6217,22 +6188,16 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (status)
 		goto err_ice_add_adv_rule;
 
-	if (rinfo->tun_type != ICE_NON_TUN &&
-	    rinfo->tun_type != ICE_SW_TUN_AND_NON_TUN) {
-		status = ice_fill_adv_packet_tun(hw, rinfo->tun_type,
-						 s_rule->hdr_data,
-						 profile->offsets);
-		if (status)
-			goto err_ice_add_adv_rule;
-	}
+	status = ice_fill_adv_packet_tun(hw, rinfo->tun_type, s_rule->hdr_data,
+					 profile->offsets);
+	if (status)
+		goto err_ice_add_adv_rule;
 
-	if (rinfo->vlan_type != 0 && ice_is_dvm_ena(hw)) {
-		status = ice_fill_adv_packet_vlan(rinfo->vlan_type,
-						  s_rule->hdr_data,
-						  profile->offsets);
-		if (status)
-			goto err_ice_add_adv_rule;
-	}
+	status = ice_fill_adv_packet_vlan(hw, rinfo->vlan_type,
+					  s_rule->hdr_data,
+					  profile->offsets);
+	if (status)
+		goto err_ice_add_adv_rule;
 
 	status = ice_aq_sw_rules(hw, (struct ice_aqc_sw_rules *)s_rule,
 				 rule_buf_sz, 1, ice_aqc_opc_add_sw_rules,
@@ -6475,13 +6440,6 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 			return -EIO;
 	}
 
-	/* Create any special protocol/offset pairs, such as looking at tunnel
-	 * bits by extracting metadata
-	 */
-	status = ice_add_special_words(rinfo, &lkup_exts, ice_is_dvm_ena(hw));
-	if (status)
-		return status;
-
 	rid = ice_find_recp(hw, &lkup_exts, rinfo->tun_type);
 	/* If did not find a recipe that match the existing criteria */
 	if (rid == ICE_MAX_NUM_RECIPES)
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 8e77868d6dca..bbd759f94187 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -186,10 +186,12 @@ struct ice_adv_rule_flags_info {
 };
 
 struct ice_adv_rule_info {
+	/* Store metadata values in rule info */
 	enum ice_sw_tunnel_type tun_type;
 	u16 vlan_type;
 	u16 fltr_rule_id;
 	u32 priority;
+	u16 src_vsi;
 	struct ice_sw_act_ctrl sw_act;
 	struct ice_adv_rule_flags_info flags_info;
 };
@@ -340,6 +342,8 @@ ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 		  u16 counter_id);
 
 /* Switch/bridge related commands */
+void ice_rule_add_tunnel_metadata(struct ice_adv_lkup_elem *lkup);
+void ice_rule_add_vlan_metadata(struct ice_adv_lkup_elem *lkup);
 int
 ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		 u16 lkups_cnt, struct ice_adv_rule_info *rinfo,
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index b5af6cd5592b..85241da1a41e 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -54,6 +54,10 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & (ICE_TC_FLWR_FIELD_VLAN | ICE_TC_FLWR_FIELD_VLAN_PRIO))
 		lkups_cnt++;
 
+	/* is VLAN TPID specified */
+	if (flags & ICE_TC_FLWR_FIELD_VLAN_TPID)
+		lkups_cnt++;
+
 	/* is CVLAN specified? */
 	if (flags & (ICE_TC_FLWR_FIELD_CVLAN | ICE_TC_FLWR_FIELD_CVLAN_PRIO))
 		lkups_cnt++;
@@ -80,6 +84,10 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 		     ICE_TC_FLWR_FIELD_SRC_L4_PORT))
 		lkups_cnt++;
 
+	/* matching for tunneled packets in metadata */
+	if (fltr->tunnel_type != TNL_LAST)
+		lkups_cnt++;
+
 	return lkups_cnt;
 }
 
@@ -320,6 +328,10 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		i++;
 	}
 
+	/* always fill matching on tunneled packets in metadata */
+	ice_rule_add_tunnel_metadata(&list[i]);
+	i++;
+
 	return i;
 }
 
@@ -390,10 +402,6 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 
 	/* copy VLAN info */
 	if (flags & (ICE_TC_FLWR_FIELD_VLAN | ICE_TC_FLWR_FIELD_VLAN_PRIO)) {
-		vlan_tpid = be16_to_cpu(headers->vlan_hdr.vlan_tpid);
-		rule_info->vlan_type =
-				ice_check_supported_vlan_tpid(vlan_tpid);
-
 		if (flags & ICE_TC_FLWR_FIELD_CVLAN)
 			list[i].type = ICE_VLAN_EX;
 		else
@@ -418,6 +426,15 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 		i++;
 	}
 
+	if (flags & ICE_TC_FLWR_FIELD_VLAN_TPID) {
+		vlan_tpid = be16_to_cpu(headers->vlan_hdr.vlan_tpid);
+		rule_info->vlan_type =
+				ice_check_supported_vlan_tpid(vlan_tpid);
+
+		ice_rule_add_vlan_metadata(&list[i]);
+		i++;
+	}
+
 	if (flags & (ICE_TC_FLWR_FIELD_CVLAN | ICE_TC_FLWR_FIELD_CVLAN_PRIO)) {
 		list[i].type = ICE_VLAN_IN;
 
@@ -1454,8 +1471,10 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 						 VLAN_PRIO_MASK);
 		}
 
-		if (match.mask->vlan_tpid)
+		if (match.mask->vlan_tpid) {
 			headers->vlan_hdr.vlan_tpid = match.key->vlan_tpid;
+			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_TPID;
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 8d5e22ac7023..8bbc1a62bdb1 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -33,6 +33,7 @@
 #define ICE_TC_FLWR_FIELD_L2TPV3_SESSID		BIT(26)
 #define ICE_TC_FLWR_FIELD_VLAN_PRIO		BIT(27)
 #define ICE_TC_FLWR_FIELD_CVLAN_PRIO		BIT(28)
+#define ICE_TC_FLWR_FIELD_VLAN_TPID		BIT(29)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
-- 
2.39.2

