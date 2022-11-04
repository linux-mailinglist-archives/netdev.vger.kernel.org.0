Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDB4619A1A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiKDOew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiKDOeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:34:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E925633E
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572310; x=1699108310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0bvFQe0VqbiTA0E14Bj/Y2J2v92pwUcpNYWrmfnLUy0=;
  b=abF5yfmVqFi+iK0stQ3SSh5iaSIR2HaPvaX/v7UM+2r8Fb2LJln/kG//
   HXTT3+2t8YInWpZXB2j4bihWzbf4xiEYyDc5f5Ozx7Gqw6+5iDUVx5Odp
   adVjYJ71vFz6m6U7KZiqCGhUaEjdp9oMolK4AsOKi/7PDGHedoGaOtNPm
   /TX5G/a0lnWv2H/6Qx16F4N2CFx7YzIQ0CMPcInX8+9FBNbhNP6Tjv58V
   XTad6r3WgQ/iuMBy8NiciBF2PcwjFnNiw/nYalZ4xRzcMEBKF3FknFNfm
   kLfjL7yN2XKplxWEC4+TKvhX8CluMshqnpnyplrxob1Lu+qSr4gymXakY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="290367539"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="290367539"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:41 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730367"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730367"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:38 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v9 7/9] ice: Add an option to pre-allocate memory for ice_sched_node
Date:   Fri,  4 Nov 2022 15:31:00 +0100
Message-Id: <20221104143102.1120076-8-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221104143102.1120076-1-michal.wilczynski@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink-rate API requires a priv object to be allocated when node still
doesn't have a parent. This is problematic, because ice_sched_node can't
be currently created without a parent.

Add an option to pre-allocate memory for ice_sched_node struct. Add
new arguments to ice_sched_add() and ice_sched_add_elems() that allow
for pre-allocation of memory for ice_sched_node struct.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c |  4 ++--
 drivers/net/ethernet/intel/ice/ice_dcb.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c  | 22 +++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_sched.h  |  6 ++++--
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index e2e661010176..216370ec60d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4603,7 +4603,7 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 	q_ctx->q_teid = le32_to_cpu(node.node_teid);
 
 	/* add a leaf node into scheduler tree queue layer */
-	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node);
+	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node, NULL);
 	if (!status)
 		status = ice_sched_replay_q_bw(pi, q_ctx);
 
@@ -4838,7 +4838,7 @@ ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 	for (i = 0; i < num_qsets; i++) {
 		node.node_teid = buf->rdma_qsets[i].qset_teid;
 		ret = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1,
-					 &node);
+					 &node, NULL);
 		if (ret)
 			break;
 		qset_teid[i] = le32_to_cpu(node.node_teid);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 0b146a0d4205..6be02f9b0b8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1580,7 +1580,7 @@ ice_update_port_tc_tree_cfg(struct ice_port_info *pi,
 		/* new TC */
 		status = ice_sched_query_elem(pi->hw, teid2, &elem);
 		if (!status)
-			status = ice_sched_add_node(pi, 1, &elem);
+			status = ice_sched_add_node(pi, 1, &elem, NULL);
 		if (status)
 			break;
 		/* update the TC number */
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 80cde5683371..711b43d2613c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -148,7 +148,8 @@ ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
  */
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info)
+		   struct ice_aqc_txsched_elem_data *info,
+		   struct ice_sched_node *prealloc_node)
 {
 	struct ice_aqc_txsched_elem_data elem;
 	struct ice_sched_node *parent;
@@ -177,7 +178,10 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 	if (status)
 		return status;
 
-	node = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*node), GFP_KERNEL);
+	if (prealloc_node)
+		node = prealloc_node;
+	else
+		node = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*node), GFP_KERNEL);
 	if (!node)
 		return -ENOMEM;
 	if (hw->max_children[layer]) {
@@ -876,13 +880,15 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
  * @num_nodes: number of nodes
  * @num_nodes_added: pointer to num nodes added
  * @first_node_teid: if new nodes are added then return the TEID of first node
+ * @prealloc_nodes: preallocated nodes struct for software DB
  *
  * This function add nodes to HW as well as to SW DB for a given layer
  */
 int
 ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
-		    u16 *num_nodes_added, u32 *first_node_teid)
+		    u16 *num_nodes_added, u32 *first_node_teid,
+		    struct ice_sched_node **prealloc_nodes)
 {
 	struct ice_sched_node *prev, *new_node;
 	struct ice_aqc_add_elem *buf;
@@ -928,7 +934,11 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 	*num_nodes_added = num_nodes;
 	/* add nodes to the SW DB */
 	for (i = 0; i < num_nodes; i++) {
-		status = ice_sched_add_node(pi, layer, &buf->generic[i]);
+		if (prealloc_nodes)
+			status = ice_sched_add_node(pi, layer, &buf->generic[i], prealloc_nodes[i]);
+		else
+			status = ice_sched_add_node(pi, layer, &buf->generic[i], NULL);
+
 		if (status) {
 			ice_debug(hw, ICE_DBG_SCHED, "add nodes in SW DB failed status =%d\n",
 				  status);
@@ -1023,7 +1033,7 @@ ice_sched_add_nodes_to_hw_layer(struct ice_port_info *pi,
 	}
 
 	return ice_sched_add_elems(pi, tc_node, parent, layer, num_nodes,
-				   num_nodes_added, first_node_teid);
+				   num_nodes_added, first_node_teid, NULL);
 }
 
 /**
@@ -1288,7 +1298,7 @@ int ice_sched_init_port(struct ice_port_info *pi)
 			    ICE_AQC_ELEM_TYPE_ENTRY_POINT)
 				hw->sw_entry_point_layer = j;
 
-			status = ice_sched_add_node(pi, j, &buf[i].generic[j]);
+			status = ice_sched_add_node(pi, j, &buf[i].generic[j], NULL);
 			if (status)
 				goto err_init_port;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 920db43ed4fa..9c100747445a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -83,7 +83,8 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 int
 ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
-		    u16 *num_nodes_added, u32 *first_node_teid);
+		    u16 *num_nodes_added, u32 *first_node_teid,
+		    struct ice_sched_node **prealloc_node);
 
 int
 ice_sched_move_nodes(struct ice_port_info *pi, struct ice_sched_node *parent,
@@ -105,7 +106,8 @@ struct ice_sched_node *
 ice_sched_find_node_by_teid(struct ice_sched_node *start_node, u32 teid);
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info);
+		   struct ice_aqc_txsched_elem_data *info,
+		   struct ice_sched_node *prealloc_node);
 void
 ice_sched_update_parent(struct ice_sched_node *new_parent,
 			struct ice_sched_node *node);
-- 
2.37.2

