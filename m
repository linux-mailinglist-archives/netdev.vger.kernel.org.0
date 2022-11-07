Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E987E61FD19
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiKGSPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiKGSPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:15:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584C417AAE
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844858; x=1699380858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O7KKpj9M/VYyABfgY1UE49PIzD5Tzf/Uv3dKW+agJpY=;
  b=HB6tLu+gQdyYtBTbIS8mGCGAdoiTQM9YYf9HfYh1V3WBlxwMvJIHxJfQ
   o9CadndhlX88GcrBajklDYDAJ143ZWvhhA+hfmruvreDOOJrmffiJhyUE
   VL+5WV/FuoUWcP2tSYs+78XI1AikK06VghiQpSOGnSVRsY/uFtwZLcrzs
   cBkyDZIrobQ1/dhX8rUx5qKPxM1eFjQdXaS2O47w5eGVeWJkLWI25TQlQ
   oLgwzKb3Mdu0Cai7r7ZFjDsTAg6TsgJzQ6L3n02vyl4P2o0WmGS9WIEvA
   eT/x1ws8f2DwWs2ahYoxw3CwbWTVM2KtZzXX1Hm+V9RprfVL4HQDRVCAU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293852022"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293852022"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962728"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962728"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:15 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v10 07/10] ice: Add an option to pre-allocate memory for ice_sched_node
Date:   Mon,  7 Nov 2022 19:13:23 +0100
Message-Id: <20221107181327.379007-8-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221107181327.379007-1-michal.wilczynski@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/intel/ice/ice_sched.c  | 23 +++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_sched.h  |  6 ++++--
 4 files changed, 24 insertions(+), 11 deletions(-)

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
index 80cde5683371..2a55fffb943c 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -143,12 +143,14 @@ ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
  * @pi: port information structure
  * @layer: Scheduler layer of the node
  * @info: Scheduler element information from firmware
+ * @prealloc_node: preallocated ice_sched_node struct for SW DB
  *
  * This function inserts a scheduler node to the SW DB.
  */
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info)
+		   struct ice_aqc_txsched_elem_data *info,
+		   struct ice_sched_node *prealloc_node)
 {
 	struct ice_aqc_txsched_elem_data elem;
 	struct ice_sched_node *parent;
@@ -177,7 +179,10 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
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
@@ -876,13 +881,15 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
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
@@ -928,7 +935,11 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
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
@@ -1023,7 +1034,7 @@ ice_sched_add_nodes_to_hw_layer(struct ice_port_info *pi,
 	}
 
 	return ice_sched_add_elems(pi, tc_node, parent, layer, num_nodes,
-				   num_nodes_added, first_node_teid);
+				   num_nodes_added, first_node_teid, NULL);
 }
 
 /**
@@ -1288,7 +1299,7 @@ int ice_sched_init_port(struct ice_port_info *pi)
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

