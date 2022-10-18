Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC3602BDC
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJRMgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJRMgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:36:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B9CC2CA0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666096567; x=1697632567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Opintw8q8GQN2D6Is5lkEzWfOZ+huMIzLYPcDuCLUg=;
  b=T3s4uLMwmLQYz6gfTQanUcrntcdlCIfn5Fw6iWTA0D3rk6TCx/N39pfP
   2RX3W7fZONFONtC6IvBmu4f11yuK1iJGpIBpwIFotWL3GlWY2RweptbIH
   C9jSJC6QspBxMw56YlzIVVCXpAP+XEok34DtUZ+IpeTw4ShMZ0sdwXzeM
   DtqqDQ0Yag9A1FEfojOTUcYU/hG651Oc7/c7zhArMK/0YUnrb3uWj1J+y
   QJNooVzyZUNa+EporoDD+MRca3PlMCsfs17b09GENhOavoMaV6AncbYki
   rwCmVjjEdsZ3hat1c19HIE496pjs2miOn7Ov0Jka8nrVd/+qbfYQxh89y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="286481801"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286481801"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:36:05 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="771181228"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="771181228"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:36:03 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v6 2/4] ice: Introduce new parameters in ice_sched_node
Date:   Tue, 18 Oct 2022 14:35:40 +0200
Message-Id: <20221018123543.1210217-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221018123543.1210217-1-michal.wilczynski@intel.com>
References: <20221018123543.1210217-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support new devlink-rate API ice_sched_node struct needs to store
a number of additional parameters. This includes tx_max, tx_priority,
tx_weight, and tx_priority.

Add new fields to ice_sched_node struct. Add new functions to configure
the hardware with new parameters. Introduce new xarray to identify
nodes uniquely.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  3 +
 drivers/net/ethernet/intel/ice/ice_sched.c    | 79 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_sched.h    | 25 ++++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  7 ++
 5 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 1bdc70aa979d..958c1e435232 100644
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
index 039342a0ed15..e2e661010176 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1105,6 +1105,9 @@ int ice_init_hw(struct ice_hw *hw)
 
 	hw->evb_veb = true;
 
+	/* init xarray for identifying scheduling nodes uniquely */
+	xa_init_flags(&hw->port_info->sched_node_ids, XA_FLAGS_ALLOC);
+
 	/* Query the allocated resources for Tx scheduler */
 	status = ice_sched_query_res_alloc(hw);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 118595763bba..782e46488c1e 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018, Intel Corporation. */
 
+#include <net/devlink.h>
 #include "ice_sched.h"
 
 /**
@@ -355,6 +356,9 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 	/* leaf nodes have no children */
 	if (node->children)
 		devm_kfree(ice_hw_to_dev(hw), node->children);
+
+	kfree(node->name);
+	xa_erase(&pi->sched_node_ids, node->id);
 	devm_kfree(ice_hw_to_dev(hw), node);
 }
 
@@ -875,7 +879,7 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
  *
  * This function add nodes to HW as well as to SW DB for a given layer
  */
-static int
+int
 ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
 		    u16 *num_nodes_added, u32 *first_node_teid)
@@ -940,6 +944,22 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 
 		new_node->sibling = NULL;
 		new_node->tc_num = tc_node->tc_num;
+		new_node->tx_weight = ICE_SCHED_DFLT_BW_WT;
+		new_node->tx_share = ICE_SCHED_DFLT_BW;
+		new_node->tx_max = ICE_SCHED_DFLT_BW;
+		new_node->name = kzalloc(DEVLINK_RATE_NAME_MAX_LEN, GFP_KERNEL);
+		if (!new_node->name)
+			return -ENOMEM;
+
+		status = xa_alloc(&pi->sched_node_ids, &new_node->id, NULL, XA_LIMIT(0, UINT_MAX),
+				  GFP_KERNEL);
+		if (status) {
+			ice_debug(hw, ICE_DBG_SCHED, "xa_alloc failed for sched node status =%d\n",
+				  status);
+			break;
+		}
+
+		snprintf(new_node->name, DEVLINK_RATE_NAME_MAX_LEN, "node_%u", new_node->id);
 
 		/* add it to previous node sibling pointer */
 		/* Note: siblings are not linked across branches */
@@ -2154,7 +2174,7 @@ ice_sched_get_free_vsi_parent(struct ice_hw *hw, struct ice_sched_node *node,
  * This function removes the child from the old parent and adds it to a new
  * parent
  */
-static void
+void
 ice_sched_update_parent(struct ice_sched_node *new_parent,
 			struct ice_sched_node *node)
 {
@@ -2188,7 +2208,7 @@ ice_sched_update_parent(struct ice_sched_node *new_parent,
  *
  * This function move the child nodes to a given parent.
  */
-static int
+int
 ice_sched_move_nodes(struct ice_port_info *pi, struct ice_sched_node *parent,
 		     u16 num_items, u32 *list)
 {
@@ -3560,7 +3580,7 @@ ice_sched_set_eir_srl_excl(struct ice_port_info *pi,
  * node's RL profile ID of type CIR, EIR, or SRL, and removes old profile
  * ID from local database. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 		      enum ice_rl_type rl_type, u32 bw, u8 layer_num)
 {
@@ -3596,6 +3616,55 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
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
@@ -3606,7 +3675,7 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
  * It updates node's BW limit parameters like BW RL profile ID of type CIR,
  * EIR, or SRL. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
 			  enum ice_rl_type rl_type, u32 bw)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 4f91577fed56..581148888b6f 100644
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
@@ -82,6 +104,9 @@ ice_sched_find_node_by_teid(struct ice_sched_node *start_node, u32 teid);
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 		   struct ice_aqc_txsched_elem_data *info);
+void
+ice_sched_update_parent(struct ice_sched_node *new_parent,
+			struct ice_sched_node *node);
 void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node);
 struct ice_sched_node *ice_sched_get_tc_node(struct ice_port_info *pi, u8 tc);
 struct ice_sched_node *
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e1abfcee96dc..3b6d317371cd 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -524,8 +524,14 @@ struct ice_sched_node {
 	struct ice_sched_node *sibling; /* next sibling in the same layer */
 	struct ice_sched_node **children;
 	struct ice_aqc_txsched_elem_data info;
+	char *name;
+	u64 tx_max;
+	u64 tx_share;
 	u32 agg_id;			/* aggregator group ID */
+	u32 id;
 	u16 vsi_handle;
+	u16 tx_priority;
+	u16 tx_weight;
 	u8 in_use;			/* suspended or in use */
 	u8 tx_sched_layer;		/* Logical Layer (1-9) */
 	u8 num_children;
@@ -706,6 +712,7 @@ struct ice_port_info {
 	/* List contain profile ID(s) and other params per layer */
 	struct list_head rl_prof_list[ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct ice_qos_cfg qos_cfg;
+	struct xarray sched_node_ids;
 	u8 is_vf:1;
 };
 
-- 
2.37.2

