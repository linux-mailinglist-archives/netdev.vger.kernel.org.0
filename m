Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB959F06A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbfH0QjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:39:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:7294 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730248AbfH0Qif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876330"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Victor Raj <victor.raj@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: added sibling head to parse nodes
Date:   Tue, 27 Aug 2019 09:38:19 -0700
Message-Id: <20190827163832.8362-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Victor Raj <victor.raj@intel.com>

There was a bug in the previous code which never traverses all the
children to get the first node of the requested layer. Add a sibling
head pointer to point the first node of each layer per TC. This helps
traverse easier and quicker and also removes the recursion.

Signed-off-by: Victor Raj <victor.raj@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 57 ++++++++--------------
 drivers/net/ethernet/intel/ice/ice_type.h  |  2 +
 2 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2a232504379d..79d64f9ed609 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -260,33 +260,17 @@ ice_sched_remove_elems(struct ice_hw *hw, struct ice_sched_node *parent,
 
 /**
  * ice_sched_get_first_node - get the first node of the given layer
- * @hw: pointer to the HW struct
+ * @pi: port information structure
  * @parent: pointer the base node of the subtree
  * @layer: layer number
  *
  * This function retrieves the first node of the given layer from the subtree
  */
 static struct ice_sched_node *
-ice_sched_get_first_node(struct ice_hw *hw, struct ice_sched_node *parent,
-			 u8 layer)
+ice_sched_get_first_node(struct ice_port_info *pi,
+			 struct ice_sched_node *parent, u8 layer)
 {
-	u8 i;
-
-	if (layer < hw->sw_entry_point_layer)
-		return NULL;
-	for (i = 0; i < parent->num_children; i++) {
-		struct ice_sched_node *node = parent->children[i];
-
-		if (node) {
-			if (node->tx_sched_layer == layer)
-				return node;
-			/* this recursion is intentional, and wouldn't
-			 * go more than 9 calls
-			 */
-			return ice_sched_get_first_node(hw, node, layer);
-		}
-	}
-	return NULL;
+	return pi->sib_head[parent->tc_num][layer];
 }
 
 /**
@@ -342,7 +326,7 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 	parent = node->parent;
 	/* root has no parent */
 	if (parent) {
-		struct ice_sched_node *p, *tc_node;
+		struct ice_sched_node *p;
 
 		/* update the parent */
 		for (i = 0; i < parent->num_children; i++)
@@ -354,16 +338,7 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 				break;
 			}
 
-		/* search for previous sibling that points to this node and
-		 * remove the reference
-		 */
-		tc_node = ice_sched_get_tc_node(pi, node->tc_num);
-		if (!tc_node) {
-			ice_debug(hw, ICE_DBG_SCHED,
-				  "Invalid TC number %d\n", node->tc_num);
-			goto err_exit;
-		}
-		p = ice_sched_get_first_node(hw, tc_node, node->tx_sched_layer);
+		p = ice_sched_get_first_node(pi, node, node->tx_sched_layer);
 		while (p) {
 			if (p->sibling == node) {
 				p->sibling = node->sibling;
@@ -371,8 +346,13 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 			}
 			p = p->sibling;
 		}
+
+		/* update the sibling head if head is getting removed */
+		if (pi->sib_head[node->tc_num][node->tx_sched_layer] == node)
+			pi->sib_head[node->tc_num][node->tx_sched_layer] =
+				node->sibling;
 	}
-err_exit:
+
 	/* leaf nodes have no children */
 	if (node->children)
 		devm_kfree(ice_hw_to_dev(hw), node->children);
@@ -743,13 +723,17 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 
 		/* add it to previous node sibling pointer */
 		/* Note: siblings are not linked across branches */
-		prev = ice_sched_get_first_node(hw, tc_node, layer);
+		prev = ice_sched_get_first_node(pi, tc_node, layer);
 		if (prev && prev != new_node) {
 			while (prev->sibling)
 				prev = prev->sibling;
 			prev->sibling = new_node;
 		}
 
+		/* initialize the sibling head */
+		if (!pi->sib_head[tc_node->tc_num][layer])
+			pi->sib_head[tc_node->tc_num][layer] = new_node;
+
 		if (i == 0)
 			*first_node_teid = teid;
 	}
@@ -1160,7 +1144,7 @@ ice_sched_get_free_qparent(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 		goto lan_q_exit;
 
 	/* get the first queue group node from VSI sub-tree */
-	qgrp_node = ice_sched_get_first_node(pi->hw, vsi_node, qgrp_layer);
+	qgrp_node = ice_sched_get_first_node(pi, vsi_node, qgrp_layer);
 	while (qgrp_node) {
 		/* make sure the qgroup node is part of the VSI subtree */
 		if (ice_sched_find_node_in_subtree(pi->hw, vsi_node, qgrp_node))
@@ -1191,7 +1175,7 @@ ice_sched_get_vsi_node(struct ice_hw *hw, struct ice_sched_node *tc_node,
 	u8 vsi_layer;
 
 	vsi_layer = ice_sched_get_vsi_layer(hw);
-	node = ice_sched_get_first_node(hw, tc_node, vsi_layer);
+	node = ice_sched_get_first_node(hw->port_info, tc_node, vsi_layer);
 
 	/* Check whether it already exists */
 	while (node) {
@@ -1316,7 +1300,8 @@ ice_sched_calc_vsi_support_nodes(struct ice_hw *hw,
 			/* If intermediate nodes are reached max children
 			 * then add a new one.
 			 */
-			node = ice_sched_get_first_node(hw, tc_node, (u8)i);
+			node = ice_sched_get_first_node(hw->port_info, tc_node,
+							(u8)i);
 			/* scan all the siblings */
 			while (node) {
 				if (node->num_children < hw->max_children[i])
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 24bbef8bbe69..d76e0cb7ef46 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -347,6 +347,8 @@ struct ice_port_info {
 	struct ice_mac_info mac;
 	struct ice_phy_info phy;
 	struct mutex sched_lock;	/* protect access to TXSched tree */
+	struct ice_sched_node *
+		sib_head[ICE_MAX_TRAFFIC_CLASS][ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct ice_dcbx_cfg local_dcbx_cfg;	/* Oper/Local Cfg */
 	/* DCBX info */
 	struct ice_dcbx_cfg remote_dcbx_cfg;	/* Peer Cfg */
-- 
2.21.0

