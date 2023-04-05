Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C426D7680
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbjDEILO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbjDEILD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:11:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D559D3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682247; x=1712218247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LLczaxwHJEtNCWLJ8oWlVW397bMVx4xrWnA0piQF4HY=;
  b=kOBawAsBBxySwsaMNmPpIIaXL64IJ2m3LB40w1L1SG8OV+nvYE2pd1EM
   hf8CpIO/tyajPniBhT11GctvBiwZcepy8lWDTu9xiSAmbstYIzRu1ee1u
   2vHOdfxFDiwaPvY4gimSRZUASFxCoqMGUdDUpoMLsPRjNLTPE6veKzR1u
   0ICAoYo1PXvV85k4VP17ennyvGzZ1lR+PVo14XVqRs3POo0zWa92iaYOw
   wDV5550W0zxzaGfMdvq56yOCOynOBTQphsxBsxtfB2ix9XXbMheXPbs5G
   bzgg6bh+2ERAxgCi6MOAwmNnMARyb7W4+3CcrlwY1nBFjmWO1TGPYv79d
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428681510"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428681510"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="775961342"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="775961342"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2023 01:10:08 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        piotr.raczynski@intel.com, pmenzel@molgen.mpg.de,
        aleksander.lobakin@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next v3 2/5] ice: remove redundant Rx field from rule info
Date:   Wed,  5 Apr 2023 09:51:10 +0200
Message-Id: <20230405075113.455662-3-michal.swiatkowski@linux.intel.com>
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

Information about the direction is currently stored in sw_act.flag.
There is no need to duplicate it in another field.

Setting direction flag doesn't mean that there is a match criteria for
direction in rule. It is only a information for HW from where switch id
should be collected (VSI or port). In current implementation of advance
rule handling, without matching for direction meta data, we can always
set one the same flag and everything will work the same.

Ability to match on direction matadata will be added in follow up
patches.

Recipe 0, 3 and 9 loaded from package has direction match
criteria, but they are handled in other function.

Move ice_adv_rule_info fields to avoid holes.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  1 -
 drivers/net/ethernet/intel/ice/ice_switch.c  | 22 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_switch.h  |  8 +++----
 drivers/net/ethernet/intel/ice/ice_tc_lib.c  |  5 -----
 4 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index f6dd3f8fd936..2c80d57331d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -39,7 +39,6 @@ ice_eswitch_add_vf_mac_rule(struct ice_pf *pf, struct ice_vf *vf, const u8 *mac)
 	rule_info.sw_act.flag |= ICE_FLTR_TX;
 	rule_info.sw_act.vsi_handle = ctrl_vsi->idx;
 	rule_info.sw_act.fltr_act = ICE_FWD_TO_Q;
-	rule_info.rx = false;
 	rule_info.sw_act.fwd_id.q_id = hw->func_caps.common_cap.rxq_first_id +
 				       ctrl_vsi->rxq_map[vf->vf_id];
 	rule_info.flags_info.act |= ICE_SINGLE_ACT_LB_ENABLE;
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 5c3f266fa80f..e806dfe69b90 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -6121,8 +6121,7 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (rinfo->sw_act.fltr_act == ICE_FWD_TO_VSI)
 		rinfo->sw_act.fwd_id.hw_vsi_id =
 			ice_get_hw_vsi_num(hw, vsi_handle);
-	if (rinfo->sw_act.flag & ICE_FLTR_TX)
-		rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
+	rinfo->sw_act.src = ice_get_hw_vsi_num(hw, vsi_handle);
 
 	status = ice_add_adv_recipe(hw, lkups, lkups_cnt, rinfo, &rid);
 	if (status)
@@ -6190,19 +6189,20 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 		goto err_ice_add_adv_rule;
 	}
 
-	/* set the rule LOOKUP type based on caller specified 'Rx'
-	 * instead of hardcoding it to be either LOOKUP_TX/RX
+	/* If there is no matching criteria for direction there
+	 * is only one difference between Rx and Tx:
+	 * - get switch id base on VSI number from source field (Tx)
+	 * - get switch id base on port number (Rx)
 	 *
-	 * for 'Rx' set the source to be the port number
-	 * for 'Tx' set the source to be the source HW VSI number (determined
-	 * by caller)
+	 * If matching on direction metadata is chose rule direction is
+	 * extracted from type value set here.
 	 */
-	if (rinfo->rx) {
-		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
-		s_rule->src = cpu_to_le16(hw->port_info->lport);
-	} else {
+	if (rinfo->sw_act.flag & ICE_FLTR_TX) {
 		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_TX);
 		s_rule->src = cpu_to_le16(rinfo->sw_act.src);
+	} else {
+		s_rule->hdr.type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
+		s_rule->src = cpu_to_le16(hw->port_info->lport);
 	}
 
 	s_rule->recipe_id = cpu_to_le16(rid);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 68d8e8a6a189..8e77868d6dca 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -10,7 +10,6 @@
 #define ICE_DFLT_VSI_INVAL 0xff
 #define ICE_FLTR_RX BIT(0)
 #define ICE_FLTR_TX BIT(1)
-#define ICE_FLTR_TX_RX (ICE_FLTR_RX | ICE_FLTR_TX)
 #define ICE_VSI_INVAL_ID 0xffff
 #define ICE_INVAL_Q_HANDLE 0xFFFF
 
@@ -188,11 +187,10 @@ struct ice_adv_rule_flags_info {
 
 struct ice_adv_rule_info {
 	enum ice_sw_tunnel_type tun_type;
-	struct ice_sw_act_ctrl sw_act;
-	u32 priority;
-	u8 rx; /* true means LOOKUP_RX otherwise LOOKUP_TX */
-	u16 fltr_rule_id;
 	u16 vlan_type;
+	u16 fltr_rule_id;
+	u32 priority;
+	struct ice_sw_act_ctrl sw_act;
 	struct ice_adv_rule_flags_info flags_info;
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 76f29a5bf8d7..b5af6cd5592b 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -697,11 +697,9 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	if (fltr->direction == ICE_ESWITCH_FLTR_INGRESS) {
 		rule_info.sw_act.flag |= ICE_FLTR_RX;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 	} else {
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
 		rule_info.sw_act.src = vsi->idx;
-		rule_info.rx = false;
 		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
 		rule_info.flags_info.act_valid = true;
 	}
@@ -909,7 +907,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 		rule_info.sw_act.vsi_handle = dest_vsi->idx;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		dev_dbg(dev, "add switch rule for TC:%u vsi_idx:%u, lkups_cnt:%u\n",
 			tc_fltr->action.fwd.tc.tc_class,
 			rule_info.sw_act.vsi_handle, lkups_cnt);
@@ -920,7 +917,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 		rule_info.sw_act.vsi_handle = dest_vsi->idx;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_QUEUE;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		dev_dbg(dev, "add switch rule action to forward to queue:%u (HW queue %u), lkups_cnt:%u\n",
 			tc_fltr->action.fwd.q.queue,
 			tc_fltr->action.fwd.q.hw_queue, lkups_cnt);
@@ -928,7 +924,6 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	case ICE_DROP_PACKET:
 		rule_info.sw_act.flag |= ICE_FLTR_RX;
 		rule_info.sw_act.src = hw->pf_id;
-		rule_info.rx = true;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		break;
 	default:
-- 
2.39.2

