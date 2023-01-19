Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03181674509
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjASVmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D57A9B103
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163685; x=1705699685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MGnRpjPHRRHPYY6gEK4adJUyzthIszEogei9Q0yYkGM=;
  b=SnaF7KjRll5H1Ts9BMhxdrU4m0c1/tQf3mKNDK+6ytHmMGiD6SAHtYHp
   eMeVEYIyvdLh0/P4VQN7Xbrw/3fE241SwW8oJMHlYqpFBnyw936C5b0JI
   QnO7g4t1t1sIrZvuMdMqAX+q5pOPTGxlvNVwo72fVsUURqdX6UX+HMEFu
   UIZB2OmbaVo5NqhL5zSQ7thTqWvAGfyl7+K+nLtMeeySeX3zHZNCumZMQ
   1vtnfAXg+ICS7p/JdPvEU5OG9JC95a4jwfK96DGJyHfIbT4ZMxcNquL1Q
   czcJvvlCbPy4lfCnS7+tQO0OhwS3ksrNEeOjE5QVKCmfWgU4EfvT4Eeoc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120604"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120604"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589874"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589874"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net-next 03/15] ice: Support drop action
Date:   Thu, 19 Jan 2023 13:27:30 -0800
Message-Id: <20230119212742.2106833-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amritha Nambiar <amritha.nambiar@intel.com>

Currently the drop action is supported only in switchdev mode.
Add support for offloading receive filters with action drop
in ADQ/non-ADQ modes. This is in addition to other actions
such as forwarding to a VSI (ADQ) or a queue (ADQ/non-ADQ).

Also renamed 'ch_vsi' to 'dest_vsi' as it is valid for multiple
actions such as forward to vsi/queue which may/may not create a
channel vsi.

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 50 ++++++++++++---------
 drivers/net/ethernet/intel/ice/ice_tc_lib.h | 10 +++++
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index faba0f857cd9..80706f7330f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -792,7 +792,7 @@ static struct ice_vsi *
 ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
 {
 	struct ice_rx_ring *ring = NULL;
-	struct ice_vsi *ch_vsi = NULL;
+	struct ice_vsi *dest_vsi = NULL;
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
 	u32 tc_class;
@@ -810,7 +810,7 @@ ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
 			return ERR_PTR(-EOPNOTSUPP);
 		}
 		/* Locate ADQ VSI depending on hw_tc number */
-		ch_vsi = vsi->tc_map_vsi[tc_class];
+		dest_vsi = vsi->tc_map_vsi[tc_class];
 		break;
 	case ICE_FWD_TO_Q:
 		/* Locate the Rx queue */
@@ -824,7 +824,7 @@ ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
 		/* Determine destination VSI even though the action is
 		 * FWD_TO_QUEUE, because QUEUE is associated with VSI
 		 */
-		ch_vsi = tc_fltr->dest_vsi;
+		dest_vsi = tc_fltr->dest_vsi;
 		break;
 	default:
 		dev_err(dev,
@@ -832,13 +832,13 @@ ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
 			tc_fltr->action.fltr_act);
 		return ERR_PTR(-EINVAL);
 	}
-	/* Must have valid ch_vsi (it could be main VSI or ADQ VSI) */
-	if (!ch_vsi) {
+	/* Must have valid dest_vsi (it could be main VSI or ADQ VSI) */
+	if (!dest_vsi) {
 		dev_err(dev,
 			"Unable to add filter because specified destination VSI doesn't exist\n");
 		return ERR_PTR(-EINVAL);
 	}
-	return ch_vsi;
+	return dest_vsi;
 }
 
 /**
@@ -860,7 +860,7 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	u32 flags = tc_fltr->flags;
-	struct ice_vsi *ch_vsi;
+	struct ice_vsi *dest_vsi;
 	struct device *dev;
 	u16 lkups_cnt = 0;
 	u16 l4_proto = 0;
@@ -883,9 +883,11 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	}
 
 	/* validate forwarding action VSI and queue */
-	ch_vsi = ice_tc_forward_action(vsi, tc_fltr);
-	if (IS_ERR(ch_vsi))
-		return PTR_ERR(ch_vsi);
+	if (ice_is_forward_action(tc_fltr->action.fltr_act)) {
+		dest_vsi = ice_tc_forward_action(vsi, tc_fltr);
+		if (IS_ERR(dest_vsi))
+			return PTR_ERR(dest_vsi);
+	}
 
 	lkups_cnt = ice_tc_count_lkups(flags, headers, tc_fltr);
 	list = kcalloc(lkups_cnt, sizeof(*list), GFP_ATOMIC);
@@ -904,7 +906,7 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 
 	switch (tc_fltr->action.fltr_act) {
 	case ICE_FWD_TO_VSI:
-		rule_info.sw_act.vsi_handle = ch_vsi->idx;
+		rule_info.sw_act.vsi_handle = dest_vsi->idx;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		rule_info.sw_act.src = hw->pf_id;
 		rule_info.rx = true;
@@ -915,7 +917,7 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	case ICE_FWD_TO_Q:
 		/* HW queue number in global space */
 		rule_info.sw_act.fwd_id.q_id = tc_fltr->action.fwd.q.hw_queue;
-		rule_info.sw_act.vsi_handle = ch_vsi->idx;
+		rule_info.sw_act.vsi_handle = dest_vsi->idx;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_QUEUE;
 		rule_info.sw_act.src = hw->pf_id;
 		rule_info.rx = true;
@@ -923,14 +925,15 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 			tc_fltr->action.fwd.q.queue,
 			tc_fltr->action.fwd.q.hw_queue, lkups_cnt);
 		break;
-	default:
-		rule_info.sw_act.flag |= ICE_FLTR_TX;
-		/* In case of Tx (LOOKUP_TX), src needs to be src VSI */
-		rule_info.sw_act.src = vsi->idx;
-		/* 'Rx' is false, direction of rule(LOOKUPTRX) */
-		rule_info.rx = false;
+	case ICE_DROP_PACKET:
+		rule_info.sw_act.flag |= ICE_FLTR_RX;
+		rule_info.sw_act.src = hw->pf_id;
+		rule_info.rx = true;
 		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto exit;
 	}
 
 	ret = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, &rule_added);
@@ -953,11 +956,11 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	tc_fltr->dest_vsi_handle = rule_added.vsi_handle;
 	if (tc_fltr->action.fltr_act == ICE_FWD_TO_VSI ||
 	    tc_fltr->action.fltr_act == ICE_FWD_TO_Q) {
-		tc_fltr->dest_vsi = ch_vsi;
+		tc_fltr->dest_vsi = dest_vsi;
 		/* keep track of advanced switch filter for
 		 * destination VSI
 		 */
-		ch_vsi->num_chnl_fltr++;
+		dest_vsi->num_chnl_fltr++;
 
 		/* keeps track of channel filters for PF VSI */
 		if (vsi->type == ICE_VSI_PF &&
@@ -978,6 +981,10 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 			tc_fltr->action.fwd.q.hw_queue, rule_added.rid,
 			rule_added.rule_id);
 		break;
+	case ICE_DROP_PACKET:
+		dev_dbg(dev, "added switch rule (lkups_cnt %u, flags 0x%x), action is drop, rid %u, rule_id %u\n",
+			lkups_cnt, flags, rule_added.rid, rule_added.rule_id);
+		break;
 	default:
 		break;
 	}
@@ -1712,6 +1719,9 @@ ice_tc_parse_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr,
 	case FLOW_ACTION_RX_QUEUE_MAPPING:
 		/* forward to queue */
 		return ice_tc_forward_to_queue(vsi, fltr, act);
+	case FLOW_ACTION_DROP:
+		fltr->action.fltr_act = ICE_DROP_PACKET;
+		return 0;
 	default:
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported TC action");
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index d916d1e92aa3..8d5e22ac7023 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -211,4 +211,14 @@ ice_del_cls_flower(struct ice_vsi *vsi, struct flow_cls_offload *cls_flower);
 void ice_replay_tc_fltrs(struct ice_pf *pf);
 bool ice_is_tunnel_supported(struct net_device *dev);
 
+static inline bool ice_is_forward_action(enum ice_sw_fwd_act_type fltr_act)
+{
+	switch (fltr_act) {
+	case ICE_FWD_TO_VSI:
+	case ICE_FWD_TO_Q:
+		return true;
+	default:
+		return false;
+	}
+}
 #endif /* _ICE_TC_LIB_H_ */
-- 
2.38.1

