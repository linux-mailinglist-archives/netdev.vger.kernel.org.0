Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E078358954
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhDHQLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:15195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231785AbhDHQLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:51 -0400
IronPort-SDR: 2t1Ol/jNDkcvXEetSiX/B/T+A/P1qM2KnCCMpnp9qyQMWwUydK0PYKdE8kBi6YOYsppIYaoh1R
 YUg6NUWKNMVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257557979"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="257557979"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:38 -0700
IronPort-SDR: MSY5ZJLYoIieFQDgmvuu+FJGUlIMHpAPoDgXItvIZL7CbVLIrNnSth1HKLm1/GaPOKslWmuZ+p
 fcYuntEInG9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841392"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:38 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 02/15] ice: Modify recursive way of adding nodes
Date:   Thu,  8 Apr 2021 09:13:08 -0700
Message-Id: <20210408161321.3218024-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

Remove the recursive way of adding the nodes to the layer in order
to reduce the stack usage. Instead the algorithm is modified to use
a while loop.

The previous code was scanning recursively the nodes horizontally.
The total stack consumption will be based on number of nodes present
on that layer. In some cases it can consume more stack.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 130 ++++++++++++---------
 1 file changed, 77 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index f890337cc24a..97562051fe14 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -919,7 +919,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 }
 
 /**
- * ice_sched_add_nodes_to_layer - Add nodes to a given layer
+ * ice_sched_add_nodes_to_hw_layer - Add nodes to HW layer
  * @pi: port information structure
  * @tc_node: pointer to TC node
  * @parent: pointer to parent node
@@ -928,82 +928,106 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
  * @first_node_teid: pointer to the first node TEID
  * @num_nodes_added: pointer to number of nodes added
  *
- * This function add nodes to a given layer.
+ * Add nodes into specific HW layer.
  */
 static enum ice_status
-ice_sched_add_nodes_to_layer(struct ice_port_info *pi,
-			     struct ice_sched_node *tc_node,
-			     struct ice_sched_node *parent, u8 layer,
-			     u16 num_nodes, u32 *first_node_teid,
-			     u16 *num_nodes_added)
+ice_sched_add_nodes_to_hw_layer(struct ice_port_info *pi,
+				struct ice_sched_node *tc_node,
+				struct ice_sched_node *parent, u8 layer,
+				u16 num_nodes, u32 *first_node_teid,
+				u16 *num_nodes_added)
 {
-	u32 *first_teid_ptr = first_node_teid;
-	u16 new_num_nodes, max_child_nodes;
-	enum ice_status status = 0;
-	struct ice_hw *hw = pi->hw;
-	u16 num_added = 0;
-	u32 temp;
+	u16 max_child_nodes;
 
 	*num_nodes_added = 0;
 
 	if (!num_nodes)
-		return status;
+		return 0;
 
-	if (!parent || layer < hw->sw_entry_point_layer)
+	if (!parent || layer < pi->hw->sw_entry_point_layer)
 		return ICE_ERR_PARAM;
 
 	/* max children per node per layer */
-	max_child_nodes = hw->max_children[parent->tx_sched_layer];
+	max_child_nodes = pi->hw->max_children[parent->tx_sched_layer];
 
-	/* current number of children + required nodes exceed max children ? */
+	/* current number of children + required nodes exceed max children */
 	if ((parent->num_children + num_nodes) > max_child_nodes) {
 		/* Fail if the parent is a TC node */
 		if (parent == tc_node)
 			return ICE_ERR_CFG;
+		return ICE_ERR_MAX_LIMIT;
+	}
+
+	return ice_sched_add_elems(pi, tc_node, parent, layer, num_nodes,
+				   num_nodes_added, first_node_teid);
+}
+
+/**
+ * ice_sched_add_nodes_to_layer - Add nodes to a given layer
+ * @pi: port information structure
+ * @tc_node: pointer to TC node
+ * @parent: pointer to parent node
+ * @layer: layer number to add nodes
+ * @num_nodes: number of nodes to be added
+ * @first_node_teid: pointer to the first node TEID
+ * @num_nodes_added: pointer to number of nodes added
+ *
+ * This function add nodes to a given layer.
+ */
+static enum ice_status
+ice_sched_add_nodes_to_layer(struct ice_port_info *pi,
+			     struct ice_sched_node *tc_node,
+			     struct ice_sched_node *parent, u8 layer,
+			     u16 num_nodes, u32 *first_node_teid,
+			     u16 *num_nodes_added)
+{
+	u32 *first_teid_ptr = first_node_teid;
+	u16 new_num_nodes = num_nodes;
+	enum ice_status status = 0;
 
+	*num_nodes_added = 0;
+	while (*num_nodes_added < num_nodes) {
+		u16 max_child_nodes, num_added = 0;
+		u32 temp;
+
+		status = ice_sched_add_nodes_to_hw_layer(pi, tc_node, parent,
+							 layer,	new_num_nodes,
+							 first_teid_ptr,
+							 &num_added);
+		if (!status)
+			*num_nodes_added += num_added;
+		/* added more nodes than requested ? */
+		if (*num_nodes_added > num_nodes) {
+			ice_debug(pi->hw, ICE_DBG_SCHED, "added extra nodes %d %d\n", num_nodes,
+				  *num_nodes_added);
+			status = ICE_ERR_CFG;
+			break;
+		}
+		/* break if all the nodes are added successfully */
+		if (!status && (*num_nodes_added == num_nodes))
+			break;
+		/* break if the error is not max limit */
+		if (status && status != ICE_ERR_MAX_LIMIT)
+			break;
+		/* Exceeded the max children */
+		max_child_nodes = pi->hw->max_children[parent->tx_sched_layer];
 		/* utilize all the spaces if the parent is not full */
 		if (parent->num_children < max_child_nodes) {
 			new_num_nodes = max_child_nodes - parent->num_children;
-			/* this recursion is intentional, and wouldn't
-			 * go more than 2 calls
+		} else {
+			/* This parent is full, try the next sibling */
+			parent = parent->sibling;
+			/* Don't modify the first node TEID memory if the
+			 * first node was added already in the above call.
+			 * Instead send some temp memory for all other
+			 * recursive calls.
 			 */
-			status = ice_sched_add_nodes_to_layer(pi, tc_node,
-							      parent, layer,
-							      new_num_nodes,
-							      first_node_teid,
-							      &num_added);
-			if (status)
-				return status;
+			if (num_added)
+				first_teid_ptr = &temp;
 
-			*num_nodes_added += num_added;
+			new_num_nodes = num_nodes - *num_nodes_added;
 		}
-		/* Don't modify the first node TEID memory if the first node was
-		 * added already in the above call. Instead send some temp
-		 * memory for all other recursive calls.
-		 */
-		if (num_added)
-			first_teid_ptr = &temp;
-
-		new_num_nodes = num_nodes - num_added;
-
-		/* This parent is full, try the next sibling */
-		parent = parent->sibling;
-
-		/* this recursion is intentional, for 1024 queues
-		 * per VSI, it goes max of 16 iterations.
-		 * 1024 / 8 = 128 layer 8 nodes
-		 * 128 /8 = 16 (add 8 nodes per iteration)
-		 */
-		status = ice_sched_add_nodes_to_layer(pi, tc_node, parent,
-						      layer, new_num_nodes,
-						      first_teid_ptr,
-						      &num_added);
-		*num_nodes_added += num_added;
-		return status;
 	}
-
-	status = ice_sched_add_elems(pi, tc_node, parent, layer, num_nodes,
-				     num_nodes_added, first_node_teid);
 	return status;
 }
 
-- 
2.26.2

