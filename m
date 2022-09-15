Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA005B9C30
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIONoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIONoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:44:05 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045E895E7F
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249440; x=1694785440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5qPhO/Nt/iAFYtWPb93JQT1TEsl8bv+1ij3shyGfw5o=;
  b=PDZB9+/G4FyutqXkXC4Z3sTumT2PjT3p06cVnMPGmOEl5WbXaW+Yh45q
   MbdvByiUIzjfXbjCx+aSw3HD36g/foTuJWhmsmSzM5c2CMz9iCPT8mcVm
   oi3sh2mr+vE6hAoqAYaJ4ZDW0OILdBerWk8adssjwhVuYg2lu8igR1tmn
   6iCbLuS+p8nccx3/didCbjEPbja3evLEGcXfypge4tjmWsPreuMpOIyt9
   1fTed/22Y4tB0OVpdeXs0w31zFt7WqW1F9rDrDbugI6WQyK3YR84ZUHNN
   m5JL/Vl/ykf+QO0iBRYgTKNpIlHOE4fE0BAb+3P1m0TwRvcZQ/jehOgZz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279100029"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279100029"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617278967"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:57 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 3/6] ice: Introduce new parameters in ice_sched_node
Date:   Thu, 15 Sep 2022 15:42:36 +0200
Message-Id: <20220915134239.1935604-4-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220915134239.1935604-1-michal.wilczynski@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
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

To support new devlink-rate API ice_sched_node struct needs to store
a number of additional parameters. This includes txq_id, tx_max,
tx_priority, tx_weight, and tx_priority. Also new function needs to be
added to configure the hardware with new parameters.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  8 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    | 82 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_sched.h    | 27 +++++-
 drivers/net/ethernet/intel/ice/ice_type.h     |  8 ++
 6 files changed, 117 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 7574267f014e..37f892ff4e02 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -848,9 +848,9 @@ struct ice_aqc_txsched_elem {
 	u8 generic;
 #define ICE_AQC_ELEM_GENERIC_MODE_M		0x1
 #define ICE_AQC_ELEM_GENERIC_PRIO_S		0x1
-#define ICE_AQC_ELEM_GENERIC_PRIO_M	(0x7 << ICE_AQC_ELEM_GENERIC_PRIO_S)
+#define ICE_AQC_ELEM_GENERIC_PRIO_M	        GENMASK(3, 1)
 #define ICE_AQC_ELEM_GENERIC_SP_S		0x4
-#define ICE_AQC_ELEM_GENERIC_SP_M	(0x1 << ICE_AQC_ELEM_GENERIC_SP_S)
+#define ICE_AQC_ELEM_GENERIC_SP_M	        GENMASK(4, 4)
 #define ICE_AQC_ELEM_GENERIC_ADJUST_VAL_S	0x5
 #define ICE_AQC_ELEM_GENERIC_ADJUST_VAL_M	\
 	(0x3 << ICE_AQC_ELEM_GENERIC_ADJUST_VAL_S)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 39769141c8e8..fda20dd204c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1092,6 +1092,9 @@ int ice_init_hw(struct ice_hw *hw)
 
 	hw->evb_veb = true;
 
+	/* init IDA for identifying scheduling nodes uniquely */
+	ida_init(&hw->port_info->sched_node_ids);
+
 	/* Query the allocated resources for Tx scheduler */
 	status = ice_sched_query_res_alloc(hw);
 	if (status) {
@@ -4652,7 +4655,8 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 	q_ctx->q_teid = le32_to_cpu(node.node_teid);
 
 	/* add a leaf node into scheduler tree queue layer */
-	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node);
+	status = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1, &node,
+				    buf->txqs[0].txq_id);
 	if (!status)
 		status = ice_sched_replay_q_bw(pi, q_ctx);
 
@@ -4887,7 +4891,7 @@ ice_ena_vsi_rdma_qset(struct ice_port_info *pi, u16 vsi_handle, u8 tc,
 	for (i = 0; i < num_qsets; i++) {
 		node.node_teid = buf->rdma_qsets[i].qset_teid;
 		ret = ice_sched_add_node(pi, hw->num_tx_sched_layers - 1,
-					 &node);
+					 &node, 0);
 		if (ret)
 			break;
 		qset_teid[i] = le32_to_cpu(node.node_teid);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 0b146a0d4205..1b0dcd4c0323 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1580,7 +1580,7 @@ ice_update_port_tc_tree_cfg(struct ice_port_info *pi,
 		/* new TC */
 		status = ice_sched_query_elem(pi->hw, teid2, &elem);
 		if (!status)
-			status = ice_sched_add_node(pi, 1, &elem);
+			status = ice_sched_add_node(pi, 1, &elem, 0);
 		if (status)
 			break;
 		/* update the TC number */
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 118595763bba..f29c30c1b58b 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018, Intel Corporation. */
 
+#include <net/devlink.h>
 #include "ice_sched.h"
 
 /**
@@ -142,12 +143,13 @@ ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
  * @pi: port information structure
  * @layer: Scheduler layer of the node
  * @info: Scheduler element information from firmware
+ * @txq_id: id of a tx_queue, if this node represents queue
  *
  * This function inserts a scheduler node to the SW DB.
  */
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info)
+		   struct ice_aqc_txsched_elem_data *info, u16 txq_id)
 {
 	struct ice_aqc_txsched_elem_data elem;
 	struct ice_sched_node *parent;
@@ -190,6 +192,9 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 		}
 	}
 
+	if (info->data.elem_type == ICE_AQC_ELEM_TYPE_LEAF)
+		node->tx_queue_id = txq_id;
+
 	node->in_use = true;
 	node->parent = parent;
 	node->tx_sched_layer = layer;
@@ -355,6 +360,9 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 	/* leaf nodes have no children */
 	if (node->children)
 		devm_kfree(ice_hw_to_dev(hw), node->children);
+
+	kfree(node->name);
+	ida_free(&pi->sched_node_ids, node->id);
 	devm_kfree(ice_hw_to_dev(hw), node);
 }
 
@@ -875,7 +883,7 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
  *
  * This function add nodes to HW as well as to SW DB for a given layer
  */
-static int
+int
 ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
 		    u16 *num_nodes_added, u32 *first_node_teid)
@@ -924,7 +932,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 	*num_nodes_added = num_nodes;
 	/* add nodes to the SW DB */
 	for (i = 0; i < num_nodes; i++) {
-		status = ice_sched_add_node(pi, layer, &buf->generic[i]);
+		status = ice_sched_add_node(pi, layer, &buf->generic[i], 0);
 		if (status) {
 			ice_debug(hw, ICE_DBG_SCHED, "add nodes in SW DB failed status =%d\n",
 				  status);
@@ -940,6 +948,15 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 
 		new_node->sibling = NULL;
 		new_node->tc_num = tc_node->tc_num;
+		new_node->tx_weight = ICE_SCHED_DFLT_BW_WT;
+		new_node->tx_share = ICE_SCHED_DFLT_BW;
+		new_node->tx_max = ICE_SCHED_DFLT_BW;
+		new_node->name = kzalloc(DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
+		if (!new_node->name)
+			return -ENOMEM;
+
+		new_node->id = ida_alloc(&pi->sched_node_ids, GFP_KERNEL);
+		snprintf(new_node->name, DEVLINK_RATE_NAME_MAX_LEN, "node_%u", new_node->id);
 
 		/* add it to previous node sibling pointer */
 		/* Note: siblings are not linked across branches */
@@ -1268,7 +1285,7 @@ int ice_sched_init_port(struct ice_port_info *pi)
 			    ICE_AQC_ELEM_TYPE_ENTRY_POINT)
 				hw->sw_entry_point_layer = j;
 
-			status = ice_sched_add_node(pi, j, &buf[i].generic[j]);
+			status = ice_sched_add_node(pi, j, &buf[i].generic[j], 0);
 			if (status)
 				goto err_init_port;
 		}
@@ -2154,7 +2171,7 @@ ice_sched_get_free_vsi_parent(struct ice_hw *hw, struct ice_sched_node *node,
  * This function removes the child from the old parent and adds it to a new
  * parent
  */
-static void
+void
 ice_sched_update_parent(struct ice_sched_node *new_parent,
 			struct ice_sched_node *node)
 {
@@ -2188,7 +2205,7 @@ ice_sched_update_parent(struct ice_sched_node *new_parent,
  *
  * This function move the child nodes to a given parent.
  */
-static int
+int
 ice_sched_move_nodes(struct ice_port_info *pi, struct ice_sched_node *parent,
 		     u16 num_items, u32 *list)
 {
@@ -3560,7 +3577,7 @@ ice_sched_set_eir_srl_excl(struct ice_port_info *pi,
  * node's RL profile ID of type CIR, EIR, or SRL, and removes old profile
  * ID from local database. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 		      enum ice_rl_type rl_type, u32 bw, u8 layer_num)
 {
@@ -3596,6 +3613,55 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 				       ICE_AQC_RL_PROFILE_TYPE_M, old_id);
 }
 
+/**
+ * ice_sched_set_node_priority - set node's priority
+ * @pi: port information structure
+ * @node: tree node
+ * @priority: number 0-7 representing priority among siblings
+ *
+ * This function sets priority of a node among it's siblings.
+ */
+int
+ice_sched_set_node_priority(struct ice_port_info *pi, struct ice_sched_node *node,
+			    u16 priority)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+
+	buf = node->info;
+	data = &buf.data;
+
+	data->valid_sections |= ICE_AQC_ELEM_VALID_GENERIC;
+	data->generic |= FIELD_PREP(ICE_AQC_ELEM_GENERIC_MODE_M, 0x1);
+	data->generic |= FIELD_PREP(ICE_AQC_ELEM_GENERIC_PRIO_M, priority);
+
+	return ice_sched_update_elem(pi->hw, node, &buf);
+}
+
+/**
+ * ice_sched_set_node_weight - set node's weight
+ * @pi: port information structure
+ * @node: tree node
+ * @weight: number 1-200 representing weight for WFQ
+ *
+ * This function sets weight of the node for WFQ algorithm.
+ */
+int
+ice_sched_set_node_weight(struct ice_port_info *pi, struct ice_sched_node *node, u16 weight)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+
+	buf = node->info;
+	data = &buf.data;
+
+	data->valid_sections = ICE_AQC_ELEM_VALID_CIR | ICE_AQC_ELEM_VALID_EIR;
+	data->cir_bw.bw_alloc = cpu_to_le16(weight);
+	data->eir_bw.bw_alloc = cpu_to_le16(weight);
+
+	return ice_sched_update_elem(pi->hw, node, &buf);
+}
+
 /**
  * ice_sched_set_node_bw_lmt - set node's BW limit
  * @pi: port information structure
@@ -3606,7 +3672,7 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
  * It updates node's BW limit parameters like BW RL profile ID of type CIR,
  * EIR, or SRL. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
 			  enum ice_rl_type rl_type, u32 bw)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 4f91577fed56..7958a3805b7f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -69,6 +69,28 @@ int
 ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
 			 struct ice_aqc_txsched_elem_data *buf, u16 buf_size,
 			 u16 *elems_ret, struct ice_sq_cd *cd);
+
+int
+ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
+			  enum ice_rl_type rl_type, u32 bw);
+
+int
+ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
+		      enum ice_rl_type rl_type, u32 bw, u8 layer_num);
+
+int
+ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
+		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
+		    u16 *num_nodes_added, u32 *first_node_teid);
+
+int
+ice_sched_move_nodes(struct ice_port_info *pi, struct ice_sched_node *parent,
+		     u16 num_items, u32 *list);
+
+int ice_sched_set_node_priority(struct ice_port_info *pi, struct ice_sched_node *node,
+				u16 priority);
+int ice_sched_set_node_weight(struct ice_port_info *pi, struct ice_sched_node *node, u16 weight);
+
 int ice_sched_init_port(struct ice_port_info *pi);
 int ice_sched_query_res_alloc(struct ice_hw *hw);
 void ice_sched_get_psm_clk_freq(struct ice_hw *hw);
@@ -81,7 +103,10 @@ struct ice_sched_node *
 ice_sched_find_node_by_teid(struct ice_sched_node *start_node, u32 teid);
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
-		   struct ice_aqc_txsched_elem_data *info);
+		   struct ice_aqc_txsched_elem_data *info, u16 txq_id);
+void
+ice_sched_update_parent(struct ice_sched_node *new_parent,
+			struct ice_sched_node *node);
 void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node);
 struct ice_sched_node *ice_sched_get_tc_node(struct ice_port_info *pi, u8 tc);
 struct ice_sched_node *
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 6ea54a3fad2c..dc3a675c988f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -522,8 +522,15 @@ struct ice_sched_node {
 	struct ice_sched_node *sibling; /* next sibling in the same layer */
 	struct ice_sched_node **children;
 	struct ice_aqc_txsched_elem_data info;
+	char *name;
+	u64 tx_max;
+	u64 tx_share;
 	u32 agg_id;			/* aggregator group ID */
+	u32 id;
+	u16 tx_queue_id;
 	u16 vsi_handle;
+	u16 tx_priority;
+	u16 tx_weight;
 	u8 in_use;			/* suspended or in use */
 	u8 tx_sched_layer;		/* Logical Layer (1-9) */
 	u8 num_children;
@@ -704,6 +711,7 @@ struct ice_port_info {
 	/* List contain profile ID(s) and other params per layer */
 	struct list_head rl_prof_list[ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct ice_qos_cfg qos_cfg;
+	struct ida sched_node_ids;
 	u8 is_vf:1;
 };
 
-- 
2.37.2

