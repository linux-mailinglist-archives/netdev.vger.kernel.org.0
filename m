Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40EB607162
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJUHrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJUHrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:47:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B83247E1F
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 00:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666338466; x=1697874466;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0ROxJ9XZbt79rFzPlyaXLx9hjfIgq6L6l1BOpoueuOQ=;
  b=nX85c4Ut01vLGGbFBdb+WMuQEm0b+f7A+uZJPALqIcUqRCzfvRwgALo+
   azyOAHr7Qr+i05Og42DNjH+R5E+qDj+sALA1ATF7ySfiOG391ZQO1+7aH
   +5hGCCj8+/3PfwzXmYRnDGRxy/zxhPJvwBD5Hy69Ppd5fMODVwpMbcxYw
   o577AQDwA1jbEjnNHa61WwOHscphfUNb4m7QlNWMCgS3VHVea8tWWiKXW
   p12HnMdxwRIsaLZs0AKKCggrqZuHzw1Sm9zxXA0P2NmCHEg3cPgqgiVBE
   EsOXiPvEr4SBmBUtWlqUmofVIu8IiHIWdK3AnGtiNNPFkSQqiGXu59ANr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="333515715"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="333515715"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 00:47:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="699198895"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="699198895"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga004.fm.intel.com with ESMTP; 21 Oct 2022 00:47:45 -0700
Subject: [net-next PATCH v3 2/3] ice: Enable RX queue selection using
 skbedit action
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Fri, 21 Oct 2022 00:58:45 -0700
Message-ID: <166633912531.52141.4323488109427719592.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch uses TC skbedit queue_mapping action to support
forwarding packets to a device queue. Such filters with action
forward to queue will be the highest priority switch filter in
HW.
Example:
$ tc filter add dev ens4f0 protocol ip ingress flower\
  dst_ip 192.168.1.12 ip_proto tcp dst_port 5001\
  action skbedit queue_mapping 5 skip_sw

The above command adds an ingress filter, incoming packets
qualifying the match will be accepted into queue 5. The queue
number is in decimal format.

Refactored ice_add_tc_flower_adv_fltr() to consolidate code with
action FWD_TO_VSI and FWD_TO QUEUE.

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h        |   15 +
 drivers/net/ethernet/intel/ice/ice_main.c   |    2 
 drivers/net/ethernet/intel/ice/ice_tc_lib.c |  351 +++++++++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |   40 ++-
 4 files changed, 299 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 001500afc4a6..d75c8d11f867 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -137,6 +137,21 @@
  */
 #define ICE_BW_KBPS_DIVISOR		125
 
+/* Default recipes have priority 4 and below, hence priority values between 5..7
+ * can be used as filter priority for advanced switch filter (advanced switch
+ * filters need new recipe to be created for specified extraction sequence
+ * because default recipe extraction sequence does not represent custom
+ * extraction)
+ */
+#define ICE_SWITCH_FLTR_PRIO_QUEUE	7
+/* prio 6 is reserved for future use (e.g. switch filter with L3 fields +
+ * (Optional: IP TOS/TTL) + L4 fields + (optionally: TCP fields such as
+ * SYN/FIN/RST))
+ */
+#define ICE_SWITCH_FLTR_PRIO_RSVD	6
+#define ICE_SWITCH_FLTR_PRIO_VSI	5
+#define ICE_SWITCH_FLTR_PRIO_QGRP	ICE_SWITCH_FLTR_PRIO_VSI
+
 /* Macro for each VSI in a PF */
 #define ice_for_each_vsi(pf, i) \
 	for ((i) = 0; (i) < (pf)->num_alloc_vsi; (i)++)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0f6718719453..df65e829ea33 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8283,7 +8283,7 @@ static void ice_rem_all_chnl_fltrs(struct ice_pf *pf)
 
 		rule.rid = fltr->rid;
 		rule.rule_id = fltr->rule_id;
-		rule.vsi_handle = fltr->dest_id;
+		rule.vsi_handle = fltr->dest_vsi_handle;
 		status = ice_rem_adv_rule_by_id(&pf->hw, &rule);
 		if (status) {
 			if (status == -ENOENT)
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index f68c555be4e9..faba0f857cd9 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -724,13 +724,123 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	 */
 	fltr->rid = rule_added.rid;
 	fltr->rule_id = rule_added.rule_id;
-	fltr->dest_id = rule_added.vsi_handle;
+	fltr->dest_vsi_handle = rule_added.vsi_handle;
 
 exit:
 	kfree(list);
 	return ret;
 }
 
+/**
+ * ice_locate_vsi_using_queue - locate VSI using queue (forward to queue action)
+ * @vsi: Pointer to VSI
+ * @tc_fltr: Pointer to tc_flower_filter
+ *
+ * Locate the VSI using specified queue. When ADQ is not enabled, always
+ * return input VSI, otherwise locate corresponding VSI based on per channel
+ * offset and qcount
+ */
+static struct ice_vsi *
+ice_locate_vsi_using_queue(struct ice_vsi *vsi,
+			   struct ice_tc_flower_fltr *tc_fltr)
+{
+	int num_tc, tc, queue;
+
+	/* if ADQ is not active, passed VSI is the candidate VSI */
+	if (!ice_is_adq_active(vsi->back))
+		return vsi;
+
+	/* Locate the VSI (it could still be main PF VSI or CHNL_VSI depending
+	 * upon queue number)
+	 */
+	num_tc = vsi->mqprio_qopt.qopt.num_tc;
+	queue = tc_fltr->action.fwd.q.queue;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		int qcount = vsi->mqprio_qopt.qopt.count[tc];
+		int offset = vsi->mqprio_qopt.qopt.offset[tc];
+
+		if (queue >= offset && queue < offset + qcount) {
+			/* for non-ADQ TCs, passed VSI is the candidate VSI */
+			if (tc < ICE_CHNL_START_TC)
+				return vsi;
+			else
+				return vsi->tc_map_vsi[tc];
+		}
+	}
+	return NULL;
+}
+
+static struct ice_rx_ring *
+ice_locate_rx_ring_using_queue(struct ice_vsi *vsi,
+			       struct ice_tc_flower_fltr *tc_fltr)
+{
+	u16 queue = tc_fltr->action.fwd.q.queue;
+
+	return queue < vsi->num_rxq ? vsi->rx_rings[queue] : NULL;
+}
+
+/**
+ * ice_tc_forward_action - Determine destination VSI and queue for the action
+ * @vsi: Pointer to VSI
+ * @tc_fltr: Pointer to TC flower filter structure
+ *
+ * Validates the tc forward action and determines the destination VSI and queue
+ * for the forward action.
+ */
+static struct ice_vsi *
+ice_tc_forward_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *tc_fltr)
+{
+	struct ice_rx_ring *ring = NULL;
+	struct ice_vsi *ch_vsi = NULL;
+	struct ice_pf *pf = vsi->back;
+	struct device *dev;
+	u32 tc_class;
+
+	dev = ice_pf_to_dev(pf);
+
+	/* Get the destination VSI and/or destination queue and validate them */
+	switch (tc_fltr->action.fltr_act) {
+	case ICE_FWD_TO_VSI:
+		tc_class = tc_fltr->action.fwd.tc.tc_class;
+		/* Select the destination VSI */
+		if (tc_class < ICE_CHNL_START_TC) {
+			NL_SET_ERR_MSG_MOD(tc_fltr->extack,
+					   "Unable to add filter because of unsupported destination");
+			return ERR_PTR(-EOPNOTSUPP);
+		}
+		/* Locate ADQ VSI depending on hw_tc number */
+		ch_vsi = vsi->tc_map_vsi[tc_class];
+		break;
+	case ICE_FWD_TO_Q:
+		/* Locate the Rx queue */
+		ring = ice_locate_rx_ring_using_queue(vsi, tc_fltr);
+		if (!ring) {
+			dev_err(dev,
+				"Unable to locate Rx queue for action fwd_to_queue: %u\n",
+				tc_fltr->action.fwd.q.queue);
+			return ERR_PTR(-EINVAL);
+		}
+		/* Determine destination VSI even though the action is
+		 * FWD_TO_QUEUE, because QUEUE is associated with VSI
+		 */
+		ch_vsi = tc_fltr->dest_vsi;
+		break;
+	default:
+		dev_err(dev,
+			"Unable to add filter because of unsupported action %u (supported actions: fwd to tc, fwd to queue)\n",
+			tc_fltr->action.fltr_act);
+		return ERR_PTR(-EINVAL);
+	}
+	/* Must have valid ch_vsi (it could be main VSI or ADQ VSI) */
+	if (!ch_vsi) {
+		dev_err(dev,
+			"Unable to add filter because specified destination VSI doesn't exist\n");
+		return ERR_PTR(-EINVAL);
+	}
+	return ch_vsi;
+}
+
 /**
  * ice_add_tc_flower_adv_fltr - add appropriate filter rules
  * @vsi: Pointer to VSI
@@ -772,11 +882,10 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 		return -EOPNOTSUPP;
 	}
 
-	/* get the channel (aka ADQ VSI) */
-	if (tc_fltr->dest_vsi)
-		ch_vsi = tc_fltr->dest_vsi;
-	else
-		ch_vsi = vsi->tc_map_vsi[tc_fltr->action.tc_class];
+	/* validate forwarding action VSI and queue */
+	ch_vsi = ice_tc_forward_action(vsi, tc_fltr);
+	if (IS_ERR(ch_vsi))
+		return PTR_ERR(ch_vsi);
 
 	lkups_cnt = ice_tc_count_lkups(flags, headers, tc_fltr);
 	list = kcalloc(lkups_cnt, sizeof(*list), GFP_ATOMIC);
@@ -790,30 +899,40 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	}
 
 	rule_info.sw_act.fltr_act = tc_fltr->action.fltr_act;
-	if (tc_fltr->action.tc_class >= ICE_CHNL_START_TC) {
-		if (!ch_vsi) {
-			NL_SET_ERR_MSG_MOD(tc_fltr->extack, "Unable to add filter because specified destination doesn't exist");
-			ret = -EINVAL;
-			goto exit;
-		}
+	/* specify the cookie as filter_rule_id */
+	rule_info.fltr_rule_id = tc_fltr->cookie;
 
-		rule_info.sw_act.fltr_act = ICE_FWD_TO_VSI;
+	switch (tc_fltr->action.fltr_act) {
+	case ICE_FWD_TO_VSI:
 		rule_info.sw_act.vsi_handle = ch_vsi->idx;
-		rule_info.priority = 7;
+		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
 		rule_info.sw_act.src = hw->pf_id;
 		rule_info.rx = true;
 		dev_dbg(dev, "add switch rule for TC:%u vsi_idx:%u, lkups_cnt:%u\n",
-			tc_fltr->action.tc_class,
+			tc_fltr->action.fwd.tc.tc_class,
 			rule_info.sw_act.vsi_handle, lkups_cnt);
-	} else {
+		break;
+	case ICE_FWD_TO_Q:
+		/* HW queue number in global space */
+		rule_info.sw_act.fwd_id.q_id = tc_fltr->action.fwd.q.hw_queue;
+		rule_info.sw_act.vsi_handle = ch_vsi->idx;
+		rule_info.priority = ICE_SWITCH_FLTR_PRIO_QUEUE;
+		rule_info.sw_act.src = hw->pf_id;
+		rule_info.rx = true;
+		dev_dbg(dev, "add switch rule action to forward to queue:%u (HW queue %u), lkups_cnt:%u\n",
+			tc_fltr->action.fwd.q.queue,
+			tc_fltr->action.fwd.q.hw_queue, lkups_cnt);
+		break;
+	default:
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
+		/* In case of Tx (LOOKUP_TX), src needs to be src VSI */
 		rule_info.sw_act.src = vsi->idx;
+		/* 'Rx' is false, direction of rule(LOOKUPTRX) */
 		rule_info.rx = false;
+		rule_info.priority = ICE_SWITCH_FLTR_PRIO_VSI;
+		break;
 	}
 
-	/* specify the cookie as filter_rule_id */
-	rule_info.fltr_rule_id = tc_fltr->cookie;
-
 	ret = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info, &rule_added);
 	if (ret == -EEXIST) {
 		NL_SET_ERR_MSG_MOD(tc_fltr->extack,
@@ -831,19 +950,14 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 	 */
 	tc_fltr->rid = rule_added.rid;
 	tc_fltr->rule_id = rule_added.rule_id;
-	if (tc_fltr->action.tc_class > 0 && ch_vsi) {
-		/* For PF ADQ, VSI type is set as ICE_VSI_CHNL, and
-		 * for PF ADQ filter, it is not yet set in tc_fltr,
-		 * hence store the dest_vsi ptr in tc_fltr
-		 */
-		if (ch_vsi->type == ICE_VSI_CHNL)
-			tc_fltr->dest_vsi = ch_vsi;
+	tc_fltr->dest_vsi_handle = rule_added.vsi_handle;
+	if (tc_fltr->action.fltr_act == ICE_FWD_TO_VSI ||
+	    tc_fltr->action.fltr_act == ICE_FWD_TO_Q) {
+		tc_fltr->dest_vsi = ch_vsi;
 		/* keep track of advanced switch filter for
-		 * destination VSI (channel VSI)
+		 * destination VSI
 		 */
 		ch_vsi->num_chnl_fltr++;
-		/* in this case, dest_id is VSI handle (sw handle) */
-		tc_fltr->dest_id = rule_added.vsi_handle;
 
 		/* keeps track of channel filters for PF VSI */
 		if (vsi->type == ICE_VSI_PF &&
@@ -851,10 +965,22 @@ ice_add_tc_flower_adv_fltr(struct ice_vsi *vsi,
 			      ICE_TC_FLWR_FIELD_ENC_DST_MAC)))
 			pf->num_dmac_chnl_fltrs++;
 	}
-	dev_dbg(dev, "added switch rule (lkups_cnt %u, flags 0x%x) for TC %u, rid %u, rule_id %u, vsi_idx %u\n",
-		lkups_cnt, flags,
-		tc_fltr->action.tc_class, rule_added.rid,
-		rule_added.rule_id, rule_added.vsi_handle);
+	switch (tc_fltr->action.fltr_act) {
+	case ICE_FWD_TO_VSI:
+		dev_dbg(dev, "added switch rule (lkups_cnt %u, flags 0x%x), action is forward to TC %u, rid %u, rule_id %u, vsi_idx %u\n",
+			lkups_cnt, flags,
+			tc_fltr->action.fwd.tc.tc_class, rule_added.rid,
+			rule_added.rule_id, rule_added.vsi_handle);
+		break;
+	case ICE_FWD_TO_Q:
+		dev_dbg(dev, "added switch rule (lkups_cnt %u, flags 0x%x), action is forward to queue: %u (HW queue %u)     , rid %u, rule_id %u\n",
+			lkups_cnt, flags, tc_fltr->action.fwd.q.queue,
+			tc_fltr->action.fwd.q.hw_queue, rule_added.rid,
+			rule_added.rule_id);
+		break;
+	default:
+		break;
+	}
 exit:
 	kfree(list);
 	return ret;
@@ -1455,43 +1581,15 @@ ice_add_switch_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 }
 
 /**
- * ice_handle_tclass_action - Support directing to a traffic class
+ * ice_prep_adq_filter - Prepare ADQ filter with the required additional headers
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to TC flower offload structure
  * @fltr: Pointer to TC flower filter structure
  *
- * Support directing traffic to a traffic class
+ * Prepare ADQ filter with the required additional header fields
  */
 static int
-ice_handle_tclass_action(struct ice_vsi *vsi,
-			 struct flow_cls_offload *cls_flower,
-			 struct ice_tc_flower_fltr *fltr)
+ice_prep_adq_filter(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 {
-	int tc = tc_classid_to_hwtc(vsi->netdev, cls_flower->classid);
-	struct ice_vsi *main_vsi;
-
-	if (tc < 0) {
-		NL_SET_ERR_MSG_MOD(fltr->extack, "Unable to add filter because specified destination is invalid");
-		return -EINVAL;
-	}
-	if (!tc) {
-		NL_SET_ERR_MSG_MOD(fltr->extack, "Unable to add filter because of invalid destination");
-		return -EINVAL;
-	}
-
-	if (!(vsi->all_enatc & BIT(tc))) {
-		NL_SET_ERR_MSG_MOD(fltr->extack, "Unable to add filter because of non-existence destination");
-		return -EINVAL;
-	}
-
-	/* Redirect to a TC class or Queue Group */
-	main_vsi = ice_get_main_vsi(vsi->back);
-	if (!main_vsi || !main_vsi->netdev) {
-		NL_SET_ERR_MSG_MOD(fltr->extack,
-				   "Unable to add filter because of invalid netdevice");
-		return -EINVAL;
-	}
-
 	if ((fltr->flags & ICE_TC_FLWR_FIELD_TENANT_ID) &&
 	    (fltr->flags & (ICE_TC_FLWR_FIELD_DST_MAC |
 			   ICE_TC_FLWR_FIELD_SRC_MAC))) {
@@ -1503,9 +1601,8 @@ ice_handle_tclass_action(struct ice_vsi *vsi,
 	/* For ADQ, filter must include dest MAC address, otherwise unwanted
 	 * packets with unrelated MAC address get delivered to ADQ VSIs as long
 	 * as remaining filter criteria is satisfied such as dest IP address
-	 * and dest/src L4 port. Following code is trying to handle:
-	 * 1. For non-tunnel, if user specify MAC addresses, use them (means
-	 * this code won't do anything
+	 * and dest/src L4 port. Below code handles the following cases:
+	 * 1. For non-tunnel, if user specify MAC addresses, use them.
 	 * 2. For non-tunnel, if user didn't specify MAC address, add implicit
 	 * dest MAC to be lower netdev's active unicast MAC address
 	 * 3. For tunnel,  as of now TC-filter through flower classifier doesn't
@@ -1528,35 +1625,97 @@ ice_handle_tclass_action(struct ice_vsi *vsi,
 		eth_broadcast_addr(fltr->outer_headers.l2_mask.dst_mac);
 	}
 
-	/* validate specified dest MAC address, make sure either it belongs to
-	 * lower netdev or any of MACVLAN. MACVLANs MAC address are added as
-	 * unicast MAC filter destined to main VSI.
-	 */
-	if (!ice_mac_fltr_exist(&main_vsi->back->hw,
-				fltr->outer_headers.l2_key.dst_mac,
-				main_vsi->idx)) {
-		NL_SET_ERR_MSG_MOD(fltr->extack,
-				   "Unable to add filter because legacy MAC filter for specified destination doesn't exist");
-		return -EINVAL;
-	}
-
 	/* Make sure VLAN is already added to main VSI, before allowing ADQ to
 	 * add a VLAN based filter such as MAC + VLAN + L4 port.
 	 */
 	if (fltr->flags & ICE_TC_FLWR_FIELD_VLAN) {
 		u16 vlan_id = be16_to_cpu(fltr->outer_headers.vlan_hdr.vlan_id);
 
-		if (!ice_vlan_fltr_exist(&main_vsi->back->hw, vlan_id,
-					 main_vsi->idx)) {
+		if (!ice_vlan_fltr_exist(&vsi->back->hw, vlan_id, vsi->idx)) {
 			NL_SET_ERR_MSG_MOD(fltr->extack,
 					   "Unable to add filter because legacy VLAN filter for specified destination doesn't exist");
 			return -EINVAL;
 		}
 	}
+	return 0;
+}
+
+/**
+ * ice_handle_tclass_action - Support directing to a traffic class
+ * @vsi: Pointer to VSI
+ * @cls_flower: Pointer to TC flower offload structure
+ * @fltr: Pointer to TC flower filter structure
+ *
+ * Support directing traffic to a traffic class/queue-set
+ */
+static int
+ice_handle_tclass_action(struct ice_vsi *vsi,
+			 struct flow_cls_offload *cls_flower,
+			 struct ice_tc_flower_fltr *fltr)
+{
+	int tc = tc_classid_to_hwtc(vsi->netdev, cls_flower->classid);
+
+	/* user specified hw_tc (must be non-zero for ADQ TC), action is forward
+	 * to hw_tc (i.e. ADQ channel number)
+	 */
+	if (tc < ICE_CHNL_START_TC) {
+		NL_SET_ERR_MSG_MOD(fltr->extack,
+				   "Unable to add filter because of unsupported destination");
+		return -EOPNOTSUPP;
+	}
+	if (!(vsi->all_enatc & BIT(tc))) {
+		NL_SET_ERR_MSG_MOD(fltr->extack,
+				   "Unable to add filter because of non-existence destination");
+		return -EINVAL;
+	}
 	fltr->action.fltr_act = ICE_FWD_TO_VSI;
-	fltr->action.tc_class = tc;
+	fltr->action.fwd.tc.tc_class = tc;
 
-	return 0;
+	return ice_prep_adq_filter(vsi, fltr);
+}
+
+static int
+ice_tc_forward_to_queue(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr,
+			struct flow_action_entry *act)
+{
+	struct ice_vsi *ch_vsi = NULL;
+	u16 queue = act->rx_queue;
+
+	if (queue > vsi->num_rxq) {
+		NL_SET_ERR_MSG_MOD(fltr->extack,
+				   "Unable to add filter because specified queue is invalid");
+		return -EINVAL;
+	}
+	fltr->action.fltr_act = ICE_FWD_TO_Q;
+	fltr->action.fwd.q.queue = queue;
+	/* determine corresponding HW queue */
+	fltr->action.fwd.q.hw_queue = vsi->rxq_map[queue];
+
+	/* If ADQ is configured, and the queue belongs to ADQ VSI, then prepare
+	 * ADQ switch filter
+	 */
+	ch_vsi = ice_locate_vsi_using_queue(vsi, fltr);
+	if (!ch_vsi)
+		return -EINVAL;
+	fltr->dest_vsi = ch_vsi;
+	if (!ice_is_chnl_fltr(fltr))
+		return 0;
+
+	return ice_prep_adq_filter(vsi, fltr);
+}
+
+static int
+ice_tc_parse_action(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr,
+		    struct flow_action_entry *act)
+{
+	switch (act->id) {
+	case FLOW_ACTION_RX_QUEUE_MAPPING:
+		/* forward to queue */
+		return ice_tc_forward_to_queue(vsi, fltr, act);
+	default:
+		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported TC action");
+		return -EOPNOTSUPP;
+	}
 }
 
 /**
@@ -1575,7 +1734,7 @@ ice_parse_tc_flower_actions(struct ice_vsi *vsi,
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls_flower);
 	struct flow_action *flow_action = &rule->action;
 	struct flow_action_entry *act;
-	int i;
+	int i, err;
 
 	if (cls_flower->classid)
 		return ice_handle_tclass_action(vsi, cls_flower, fltr);
@@ -1584,21 +1743,13 @@ ice_parse_tc_flower_actions(struct ice_vsi *vsi,
 		return -EINVAL;
 
 	flow_action_for_each(i, act, flow_action) {
-		if (ice_is_eswitch_mode_switchdev(vsi->back)) {
-			int err = ice_eswitch_tc_parse_action(fltr, act);
-
-			if (err)
-				return err;
-			continue;
-		}
-		/* Allow only one rule per filter */
-
-		/* Drop action */
-		if (act->id == FLOW_ACTION_DROP) {
-			NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported action DROP");
-			return -EINVAL;
-		}
-		fltr->action.fltr_act = ICE_FWD_TO_VSI;
+		if (ice_is_eswitch_mode_switchdev(vsi->back))
+			err = ice_eswitch_tc_parse_action(fltr, act);
+		else
+			err = ice_tc_parse_action(vsi, fltr, act);
+		if (err)
+			return err;
+		continue;
 	}
 	return 0;
 }
@@ -1618,7 +1769,7 @@ static int ice_del_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 
 	rule_rem.rid = fltr->rid;
 	rule_rem.rule_id = fltr->rule_id;
-	rule_rem.vsi_handle = fltr->dest_id;
+	rule_rem.vsi_handle = fltr->dest_vsi_handle;
 	err = ice_rem_adv_rule_by_id(&pf->hw, &rule_rem);
 	if (err) {
 		if (err == -ENOENT) {
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 92642faad595..d916d1e92aa3 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -45,7 +45,20 @@ struct ice_indr_block_priv {
 };
 
 struct ice_tc_flower_action {
-	u32 tc_class;
+	/* forward action specific params */
+	union {
+		struct {
+			u32 tc_class; /* forward to hw_tc */
+			u32 rsvd;
+		} tc;
+		struct {
+			u16 queue; /* forward to queue */
+			/* To add filter in HW, absolute queue number in global
+			 * space of queues (between 0...N) is needed
+			 */
+			u16 hw_queue;
+		} q;
+	} fwd;
 	enum ice_sw_fwd_act_type fltr_act;
 };
 
@@ -131,11 +144,11 @@ struct ice_tc_flower_fltr {
 	 */
 	u16 rid;
 	u16 rule_id;
-	/* this could be queue/vsi_idx (sw handle)/queue_group, depending upon
-	 * destination type
+	/* VSI handle of the destination VSI (it could be main PF VSI, CHNL_VSI,
+	 * VF VSI)
 	 */
-	u16 dest_id;
-	/* if dest_id is vsi_idx, then need to store destination VSI ptr */
+	u16 dest_vsi_handle;
+	/* ptr to destination VSI */
 	struct ice_vsi *dest_vsi;
 	/* direction of fltr for eswitch use case */
 	enum ice_eswitch_fltr_direction direction;
@@ -162,12 +175,23 @@ struct ice_tc_flower_fltr {
  * @f: Pointer to tc-flower filter
  *
  * Criteria to determine of given filter is valid channel filter
- * or not is based on its "destination". If destination is hw_tc (aka tc_class)
- * and it is non-zero, then it is valid channel (aka ADQ) filter
+ * or not is based on its destination.
+ * For forward to VSI action, if destination is valid hw_tc (aka tc_class)
+ * and in supported range of TCs for ADQ, then return true.
+ * For forward to queue, as long as dest_vsi is valid and it is of type
+ * VSI_CHNL (PF ADQ VSI is of type VSI_CHNL), return true.
+ * NOTE: For forward to queue, correct dest_vsi is still set in tc_fltr based
+ * on destination queue specified.
  */
 static inline bool ice_is_chnl_fltr(struct ice_tc_flower_fltr *f)
 {
-	return !!f->action.tc_class;
+	if (f->action.fltr_act == ICE_FWD_TO_VSI)
+		return f->action.fwd.tc.tc_class >= ICE_CHNL_START_TC &&
+		       f->action.fwd.tc.tc_class < ICE_CHNL_MAX_TC;
+	else if (f->action.fltr_act == ICE_FWD_TO_Q)
+		return f->dest_vsi && f->dest_vsi->type == ICE_VSI_CHNL;
+
+	return false;
 }
 
 /**

