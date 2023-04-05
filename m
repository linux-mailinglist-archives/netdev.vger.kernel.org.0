Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A046D7682
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbjDEILQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbjDEILH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:11:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C4959DB
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682248; x=1712218248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WOO8Ny4QhEIF1KWVs0in6CDxJjXlH+7nV3I0ui5XdSk=;
  b=TdVwAh1GBgw891TkDOOktqruECOsGaSeHmyqfKSpfbEHGVcxIesjv2si
   BkTpPIE3H5htwzM+unbKqelRtK7vk4fA9vcJa0u4imH3nmzTkQeb36fDK
   21CIwpoPNMHWDZVY20EQqQ/WdeFlSS2ToBjcRPSKbXljrtLA5mQ3m9EiV
   suoa0O42n0D61VXUp19RkwXe6tVA/HszmPo9o2LuxSg1TH7fjzU9w/a7T
   4F26kFQ+EKD0QLCcQKZxt5XUjUccB6z/NNml8z9/0lMiizJK/rX2LsLpG
   mjGqbinPNxwNn+jJLfLDVrQnAFczoAmanAaa9adExUvyzPMKIWvm6MX0t
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428681515"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428681515"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:10:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775961358"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="775961358"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2023 01:10:10 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com, pmenzel@molgen.mpg.de,
        aleksander.lobakin@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v3 3/5] ice: allow matching on meta data
Date:   Wed,  5 Apr 2023 09:51:11 +0200
Message-Id: <20230405075113.455662-4-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
References: <20230405075113.455662-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Match on tunnel type mata data always if tunnel type is different than
TNL_LAST.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
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
index e806dfe69b90..b55cdb9a009f 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4573,6 +4573,15 @@ static const struct ice_prot_ext_tbl_entry ice_prot_ext[ICE_PROTOCOL_LAST] = {
 	{ ICE_L2TPV3,		{ 0, 2, 4, 6, 8, 10 } },
 	{ ICE_VLAN_EX,          { 2, 0 } },
 	{ ICE_VLAN_IN,          { 2, 0 } },
+	{ ICE_HW_METADATA,	{ ICE_SOURCE_PORT_MDID_OFFSET,
+				  ICE_PTYPE_MDID_OFFSET,
+				  ICE_PACKET_LENGTH_MDID_OFFSET,
+				  ICE_SOURCE_VSI_MDID_OFFSET,
+				  ICE_PKT_VLAN_MDID_OFFSET,
+				  ICE_PKT_TUNNEL_MDID_OFFSET,
+				  ICE_PKT_TCP_MDID_OFFSET,
+				  ICE_PKT_ERROR_MDID_OFFSET,
+				}},
 };
 
 static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
@@ -4597,6 +4606,7 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
 	{ ICE_L2TPV3,		ICE_L2TPV3_HW },
 	{ ICE_VLAN_EX,          ICE_VLAN_OF_HW },
 	{ ICE_VLAN_IN,          ICE_VLAN_OL_HW },
+	{ ICE_HW_METADATA,      ICE_META_DATA_ID_HW },
 };
 
 /**
@@ -5255,72 +5265,6 @@ ice_create_recipe_group(struct ice_hw *hw, struct ice_sw_recipe *rm,
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
@@ -5434,13 +5378,6 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
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
@@ -5726,6 +5663,10 @@ ice_fill_adv_dummy_packet(struct ice_adv_lkup_elem *lkups, u16 lkups_cnt,
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
@@ -5861,16 +5802,21 @@ ice_fill_adv_packet_tun(struct ice_hw *hw, enum ice_sw_tunnel_type tun_type,
 
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
@@ -5889,6 +5835,15 @@ ice_fill_adv_packet_vlan(u16 vlan_type, u8 *pkt,
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
@@ -5922,9 +5877,7 @@ ice_find_adv_rule_entry(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
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
@@ -6040,6 +5993,20 @@ ice_adv_add_update_vsi_list(struct ice_hw *hw,
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
@@ -6121,7 +6088,11 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
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
@@ -6212,22 +6183,16 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
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
@@ -6470,13 +6435,6 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
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
index 8e77868d6dca..e9f7deefee3e 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -186,12 +186,14 @@ struct ice_adv_rule_flags_info {
 };
 
 struct ice_adv_rule_info {
+	/* Store metadata values in rule info */
 	enum ice_sw_tunnel_type tun_type;
 	u16 vlan_type;
 	u16 fltr_rule_id;
 	u32 priority;
 	struct ice_sw_act_ctrl sw_act;
 	struct ice_adv_rule_flags_info flags_info;
+	u16 src_vsi;
 };
 
 /* A collection of one or more four word recipe */
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

