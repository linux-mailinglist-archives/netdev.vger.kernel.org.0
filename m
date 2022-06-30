Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D57562510
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiF3VXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiF3VXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:23:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780C0FD3F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624190; x=1688160190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BfC9MWmbJh0OMCCj9iMRTLGKWRBbg/CZz5CvabicSp8=;
  b=SJ2x3aBD7+hPVK8oUWVTaFYycJBNn472SBBPovLNqPHQVo4p3p5iAuu0
   XFljicw1AOKOxCfl12JL33hPT0Ia4x/bIfNOz779HBk6m5ldPLYLextvj
   fbl773iwPvdjVxrFuk/3RW3acKc6r4Q3lV/MTejpzg31h5zywKsmUYvkY
   QltO8TVt/T+Hqp+nmc3LhCFxRUs7Vy6uvvGMjS0zjZptoH8EKHnm6ZwRe
   A9dwrrUjb60GV/rUmcAjTaQu5ZI5eEBm1uWYg+xMGegmQMhtDC+7pOq3E
   QCU8xgRtyb3F7GDOT00SjSD9388PgM1wYhdwiZO6hWCv69XYsYMMRkUX2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262274441"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262274441"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:23:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837768324"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:23:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/5] ice: Add support for VLAN TPID filters in switchdev
Date:   Thu, 30 Jun 2022 14:19:57 -0700
Message-Id: <20220630212000.3006759-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
References: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>

Enable support for adding TC rules that filter on the VLAN tag type
in switchdev mode.

Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/ice/ice_protocol_type.h    |  7 ++-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 59 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_switch.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 21 +++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  1 +
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |  1 -
 6 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index f8bd0990641b..d4a0d089649c 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -111,13 +111,18 @@ enum ice_prot_id {
 #define ICE_GRE_OF_HW		64
 
 #define ICE_UDP_OF_HW	52 /* UDP Tunnels */
-#define ICE_META_DATA_ID_HW 255 /* this is used for tunnel type */
+#define ICE_META_DATA_ID_HW 255 /* this is used for tunnel and VLAN type */
 
 #define ICE_MDID_SIZE 2
+
 #define ICE_TUN_FLAG_MDID 21
 #define ICE_TUN_FLAG_MDID_OFF (ICE_MDID_SIZE * ICE_TUN_FLAG_MDID)
 #define ICE_TUN_FLAG_MASK 0xFF
 
+#define ICE_VLAN_FLAG_MDID 20
+#define ICE_VLAN_FLAG_MDID_OFF (ICE_MDID_SIZE * ICE_VLAN_FLAG_MDID)
+#define ICE_PKT_FLAGS_0_TO_15_VLAN_FLAGS_MASK 0xD000
+
 #define ICE_TUN_FLAG_FV_IND 2
 
 /* Mapping of software defined protocol ID to hardware defined protocol ID */
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 85816a73f09f..4f1066fd9a46 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5536,10 +5536,11 @@ static bool ice_tun_type_match_word(enum ice_sw_tunnel_type tun_type, u16 *mask)
  * ice_add_special_words - Add words that are not protocols, such as metadata
  * @rinfo: other information regarding the rule e.g. priority and action info
  * @lkup_exts: lookup word structure
+ * @dvm_ena: is double VLAN mode enabled
  */
 static int
 ice_add_special_words(struct ice_adv_rule_info *rinfo,
-		      struct ice_prot_lkup_ext *lkup_exts)
+		      struct ice_prot_lkup_ext *lkup_exts, bool dvm_ena)
 {
 	u16 mask;
 
@@ -5558,6 +5559,19 @@ ice_add_special_words(struct ice_adv_rule_info *rinfo,
 		}
 	}
 
+	if (rinfo->vlan_type != 0 && dvm_ena) {
+		if (lkup_exts->n_val_words < ICE_MAX_CHAIN_WORDS) {
+			u8 word = lkup_exts->n_val_words++;
+
+			lkup_exts->fv_words[word].prot_id = ICE_META_DATA_ID_HW;
+			lkup_exts->fv_words[word].off = ICE_VLAN_FLAG_MDID_OFF;
+			lkup_exts->field_mask[word] =
+					ICE_PKT_FLAGS_0_TO_15_VLAN_FLAGS_MASK;
+		} else {
+			return -ENOSPC;
+		}
+	}
+
 	return 0;
 }
 
@@ -5677,7 +5691,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	/* Create any special protocol/offset pairs, such as looking at tunnel
 	 * bits by extracting metadata
 	 */
-	status = ice_add_special_words(rinfo, lkup_exts);
+	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
 		goto err_free_lkup_exts;
 
@@ -6010,6 +6024,36 @@ ice_fill_adv_packet_tun(struct ice_hw *hw, enum ice_sw_tunnel_type tun_type,
 	return -EIO;
 }
 
+/**
+ * ice_fill_adv_packet_vlan - fill dummy packet with VLAN tag type
+ * @vlan_type: VLAN tag type
+ * @pkt: dummy packet to fill in
+ * @offsets: offset info for the dummy packet
+ */
+static int
+ice_fill_adv_packet_vlan(u16 vlan_type, u8 *pkt,
+			 const struct ice_dummy_pkt_offsets *offsets)
+{
+	u16 i;
+
+	/* Find VLAN header and insert VLAN TPID */
+	for (i = 0; offsets[i].type != ICE_PROTOCOL_LAST; i++) {
+		if (offsets[i].type == ICE_VLAN_OFOS ||
+		    offsets[i].type == ICE_VLAN_EX) {
+			struct ice_vlan_hdr *hdr;
+			u16 offset;
+
+			offset = offsets[i].offset;
+			hdr = (struct ice_vlan_hdr *)&pkt[offset];
+			hdr->type = cpu_to_be16(vlan_type);
+
+			return 0;
+		}
+	}
+
+	return -EIO;
+}
+
 /**
  * ice_find_adv_rule_entry - Search a rule entry
  * @hw: pointer to the hardware structure
@@ -6045,6 +6089,7 @@ ice_find_adv_rule_entry(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 			}
 		if (rinfo->sw_act.flag == list_itr->rule_info.sw_act.flag &&
 		    rinfo->tun_type == list_itr->rule_info.tun_type &&
+		    rinfo->vlan_type == list_itr->rule_info.vlan_type &&
 		    lkups_matched)
 			return list_itr;
 	}
@@ -6333,6 +6378,14 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 			goto err_ice_add_adv_rule;
 	}
 
+	if (rinfo->vlan_type != 0 && ice_is_dvm_ena(hw)) {
+		status = ice_fill_adv_packet_vlan(rinfo->vlan_type,
+						  s_rule->hdr_data,
+						  profile->offsets);
+		if (status)
+			goto err_ice_add_adv_rule;
+	}
+
 	status = ice_aq_sw_rules(hw, (struct ice_aqc_sw_rules *)s_rule,
 				 rule_buf_sz, 1, ice_aqc_opc_add_sw_rules,
 				 NULL);
@@ -6570,7 +6623,7 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	/* Create any special protocol/offset pairs, such as looking at tunnel
 	 * bits by extracting metadata
 	 */
-	status = ice_add_special_words(rinfo, &lkup_exts);
+	status = ice_add_special_words(rinfo, &lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
 		return status;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index eb641e5512d2..59488e3e9d6a 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -192,6 +192,7 @@ struct ice_adv_rule_info {
 	u32 priority;
 	u8 rx; /* true means LOOKUP_RX otherwise LOOKUP_TX */
 	u16 fltr_rule_id;
+	u16 vlan_type;
 	struct ice_adv_rule_flags_info flags_info;
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index faf5bfd8d157..2fb3ef918e3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -138,6 +138,18 @@ ice_sw_type_from_tunnel(enum ice_tunnel_type type)
 	}
 }
 
+static u16 ice_check_supported_vlan_tpid(u16 vlan_tpid)
+{
+	switch (vlan_tpid) {
+	case ETH_P_8021Q:
+	case ETH_P_8021AD:
+	case ETH_P_QINQ1:
+		return vlan_tpid;
+	default:
+		return 0;
+	}
+}
+
 static int
 ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 			 struct ice_adv_lkup_elem *list)
@@ -273,8 +285,11 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 {
 	struct ice_tc_flower_lyr_2_4_hdrs *headers = &tc_fltr->outer_headers;
 	bool inner = false;
+	u16 vlan_tpid = 0;
 	int i = 0;
 
+	rule_info->vlan_type = vlan_tpid;
+
 	rule_info->tun_type = ice_sw_type_from_tunnel(tc_fltr->tunnel_type);
 	if (tc_fltr->tunnel_type != TNL_LAST) {
 		i = ice_tc_fill_tunnel_outer(flags, tc_fltr, list);
@@ -315,6 +330,10 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 
 	/* copy VLAN info */
 	if (flags & ICE_TC_FLWR_FIELD_VLAN) {
+		vlan_tpid = be16_to_cpu(headers->vlan_hdr.vlan_tpid);
+		rule_info->vlan_type =
+				ice_check_supported_vlan_tpid(vlan_tpid);
+
 		if (flags & ICE_TC_FLWR_FIELD_CVLAN)
 			list[i].type = ICE_VLAN_EX;
 		else
@@ -1075,6 +1094,8 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 				cpu_to_be16(match.key->vlan_id & VLAN_VID_MASK);
 		if (match.mask->vlan_priority)
 			headers->vlan_hdr.vlan_prio = match.key->vlan_priority;
+		if (match.mask->vlan_tpid)
+			headers->vlan_hdr.vlan_tpid = match.key->vlan_tpid;
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 87acfe5b0e4d..0193874cd203 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -41,6 +41,7 @@ struct ice_tc_flower_action {
 struct ice_tc_vlan_hdr {
 	__be16 vlan_id; /* Only last 12 bits valid */
 	u16 vlan_prio; /* Only last 3 bits valid (valid values: 0..7) */
+	__be16 vlan_tpid;
 };
 
 struct ice_tc_l2_hdr {
diff --git a/drivers/net/ethernet/intel/ice/ice_vlan_mode.c b/drivers/net/ethernet/intel/ice/ice_vlan_mode.c
index 1b618de592b7..bcda2e004807 100644
--- a/drivers/net/ethernet/intel/ice/ice_vlan_mode.c
+++ b/drivers/net/ethernet/intel/ice/ice_vlan_mode.c
@@ -199,7 +199,6 @@ static bool ice_is_dvm_supported(struct ice_hw *hw)
 #define ICE_SW_LKUP_VLAN_PKT_FLAGS_LKUP_IDX		2
 #define ICE_SW_LKUP_PROMISC_VLAN_LOC_LKUP_IDX		2
 #define ICE_PKT_FLAGS_0_TO_15_FV_IDX			1
-#define ICE_PKT_FLAGS_0_TO_15_VLAN_FLAGS_MASK		0xD000
 static struct ice_update_recipe_lkup_idx_params ice_dvm_dflt_recipes[] = {
 	{
 		/* Update recipe ICE_SW_LKUP_VLAN to filter based on the
-- 
2.35.1

