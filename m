Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F8E5B9C31
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiIONod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiIONoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:44:06 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426E796FD5
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249443; x=1694785443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/omt/xpVTFw+/EXWQN4ixtvMYREbcHV9AyEHDD/9n6Q=;
  b=WoY2F8nBqyODo6+OeWinsat7Ah3eTEKRGSkeGgZrHkIF7K73j3ADmI+F
   Ebb6n0sWM41Fm5tXdLZkMsvR5ILXMsd8YXG+aW82UGTm05PcH2wKlFYib
   RATg7AHi787qYagczYnhu4MP6n8qM1AIQvfDqbNPCiB/2VLyYa8j1cXPM
   yOr4i4UF3yrSoAeQKookC/tMsKan2o7PqrN3AbjfUScPV54OTJdpVCv/7
   d+5b40wKP7Ith5xB2z6wGBYbC+YOAmZ9werHFLqbLzMOuL8n/r6E3Tlgf
   LqwTbvu/XgTKiKPxz98cl3nS0agHI/OcmBM+DpR1PRJe4Fos3OyN2yj+S
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279100038"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279100038"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:44:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617278991"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:44:00 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 4/6] ice: Implement devlink-rate API
Date:   Thu, 15 Sep 2022 15:42:37 +0200
Message-Id: <20220915134239.1935604-5-michal.wilczynski@intel.com>
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

There is a need to support modification of Tx scheduler topology, in the
ice driver. This will allow user to control Tx settings of each node in
the internal hierarchy of nodes. A number of parameters is supported per
each node: tx_max, tx_share, tx_priority and tx_weight.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 511 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |   2 +
 2 files changed, 513 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index e6ec20079ced..925283605b59 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -713,6 +713,490 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+/**
+ * ice_traverse_tx_tree - traverse Tx scheduler tree
+ * @devlink: devlink struct
+ * @node: current node, used for recursion
+ * @tc_node: tc_node struct, that is treated as a root
+ * @pf: pf struct
+ *
+ * This function traverses Tx scheduler tree and exports
+ * entire structure to the devlink-rate.
+ */
+static void ice_traverse_tx_tree(struct devlink *devlink, struct ice_sched_node *node,
+				 struct ice_sched_node *tc_node, struct ice_pf *pf)
+{
+	struct ice_vf *vf;
+	int i;
+
+	devl_lock(devlink);
+
+	if (node->parent == tc_node) {
+		/* create root node */
+		devl_rate_node_create(devlink, node, node->name, NULL);
+	} else if (node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF &&
+		   node->parent->name) {
+		devl_rate_queue_create(devlink, node->parent->name, node->tx_queue_id, node);
+	} else if (node->vsi_handle &&
+		   pf->vsi[node->vsi_handle]->vf) {
+		vf = pf->vsi[node->vsi_handle]->vf;
+		snprintf(node->name, DEVLINK_RATE_NAME_MAX_LEN, "vport_%u", vf->devlink_port.index);
+		if (!vf->devlink_port.devlink_rate)
+			devl_rate_vport_create(&vf->devlink_port, node, node->parent->name);
+	} else {
+		devl_rate_node_create(devlink, node, node->name, node->parent->name);
+	}
+
+	devl_unlock(devlink);
+
+	for (i = 0; i < node->num_children; i++)
+		ice_traverse_tx_tree(devlink, node->children[i], tc_node, pf);
+}
+
+/**
+ * ice_devlink_rate_init_tx_topology - export Tx scheduler tree to devlink rate
+ * @devlink: devlink struct
+ * @vsi: main vsi struct
+ *
+ * This function finds a root node, then calls ice_traverse_tx tree, which
+ * traverses the tree and export it's contents to devlink rate.
+ */
+int ice_devlink_rate_init_tx_topology(struct devlink *devlink, struct ice_vsi *vsi)
+{
+	struct ice_port_info *pi = vsi->port_info;
+	struct ice_sched_node *tc_node;
+	struct ice_pf *pf = vsi->back;
+	int i;
+
+	tc_node = pi->root->children[0];
+	mutex_lock(&pi->sched_lock);
+	for (i = 0; i < tc_node->num_children; i++)
+		ice_traverse_tx_tree(devlink, tc_node->children[i], tc_node, pf);
+	mutex_unlock(&pi->sched_lock);
+
+	return 0;
+}
+
+/**
+ * ice_set_object_tx_share - sets node scheduling parameter
+ * @pi: devlink struct instance
+ * @node: node struct instance
+ * @extack: extended netdev ack structure
+ *
+ * This function sets ICE_MIN_BW scheduling BW limit.
+ */
+static int ice_set_object_tx_share(struct ice_port_info *pi, struct ice_sched_node *node,
+				   struct netlink_ext_ack *extack)
+{
+	int status;
+
+	mutex_lock(&pi->sched_lock);
+	status = ice_sched_set_node_bw_lmt(pi, node, ICE_MIN_BW, node->tx_share);
+	mutex_unlock(&pi->sched_lock);
+
+	if (status)
+		NL_SET_ERR_MSG_MOD(extack, "Can't set scheduling node tx_share");
+
+	return status;
+}
+
+/**
+ * ice_set_object_tx_max - sets node scheduling parameter
+ * @pi: devlink struct instance
+ * @node: node struct instance
+ * @extack: extended netdev ack structure
+ *
+ * This function sets ICE_MAX_BW scheduling BW limit.
+ */
+static int ice_set_object_tx_max(struct ice_port_info *pi, struct ice_sched_node *node,
+				 struct netlink_ext_ack *extack)
+{
+	int status;
+
+	mutex_lock(&pi->sched_lock);
+	status = ice_sched_set_node_bw_lmt(pi, node, ICE_MAX_BW, node->tx_max);
+	mutex_unlock(&pi->sched_lock);
+
+	if (status)
+		NL_SET_ERR_MSG_MOD(extack, "Can't set scheduling node tx_max");
+
+	return status;
+}
+
+/**
+ * ice_set_object_tx_priority - sets node scheduling parameter
+ * @pi: devlink struct instance
+ * @node: node struct instance
+ * @extack: extended netdev ack structure
+ *
+ * This function sets priority of node among siblings.
+ */
+static int ice_set_object_tx_priority(struct ice_port_info *pi, struct ice_sched_node *node,
+				      struct netlink_ext_ack *extack)
+{
+	int status;
+
+	mutex_lock(&pi->sched_lock);
+	status = ice_sched_set_node_priority(pi, node, node->tx_priority);
+	mutex_unlock(&pi->sched_lock);
+
+	if (status)
+		NL_SET_ERR_MSG_MOD(extack, "Can't set scheduling node tx_priority");
+
+	return status;
+}
+
+/**
+ * ice_set_object_tx_weight - sets node scheduling parameter
+ * @pi: devlink struct instance
+ * @node: node struct instance
+ * @extack: extended netdev ack structure
+ *
+ * This function sets node weight for WFQ algorithm.
+ */
+static int ice_set_object_tx_weight(struct ice_port_info *pi, struct ice_sched_node *node,
+				    struct netlink_ext_ack *extack)
+{
+	int status;
+
+	mutex_lock(&pi->sched_lock);
+	status = ice_sched_set_node_weight(pi, node, node->tx_weight);
+	mutex_unlock(&pi->sched_lock);
+
+	if (status)
+		NL_SET_ERR_MSG_MOD(extack, "Can't set scheduling node tx_weight");
+
+	return status;
+}
+
+/**
+ * ice_get_pi_from_dev_rate - get port info from devlink_rate
+ * @rate_node: devlink struct instance
+ *
+ * This function returns corresponding port_info struct of devlink_rate
+ */
+static struct ice_port_info *ice_get_pi_from_dev_rate(struct devlink_rate *rate_node)
+{
+	struct ice_pf *pf = devlink_priv(rate_node->devlink);
+
+	return ice_get_main_vsi(pf)->port_info;
+}
+
+static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv,
+				     struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static int ice_devlink_rate_node_del(struct devlink_rate *rate_node, void *priv,
+				     struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node, *tc_node;
+	struct ice_port_info *pi;
+
+	pi = ice_get_pi_from_dev_rate(rate_node);
+	tc_node = pi->root->children[0];
+	node = priv;
+
+	if (!rate_node->parent || !node || tc_node == node)
+		return 0;
+
+	if (node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF) {
+		NL_SET_ERR_MSG_MOD(extack, "Queue can't be deleted");
+		return -EINVAL;
+	}
+	mutex_lock(&pi->sched_lock);
+	ice_free_sched_node(pi, node);
+	mutex_unlock(&pi->sched_lock);
+
+	return 0;
+}
+
+static int ice_devlink_rate_vport_tx_max_set(struct devlink_rate *rate_vport, void *priv,
+					     u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_max = tx_max / 10;
+
+	return ice_set_object_tx_max(ice_get_pi_from_dev_rate(rate_vport), node, extack);
+}
+
+static int ice_devlink_rate_vport_tx_share_set(struct devlink_rate *rate_vport, void *priv,
+					       u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_share = tx_share / 10;
+
+	return ice_set_object_tx_share(ice_get_pi_from_dev_rate(rate_vport), node, extack);
+}
+
+static int ice_devlink_rate_vport_tx_priority_set(struct devlink_rate *rate_vport, void *priv,
+						  u64 tx_priority, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_priority = tx_priority;
+
+	return ice_set_object_tx_priority(ice_get_pi_from_dev_rate(rate_vport), node, extack);
+}
+
+static int ice_devlink_rate_vport_tx_weight_set(struct devlink_rate *rate_vport, void *priv,
+						u64 tx_weight, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_weight = tx_weight;
+
+	return ice_set_object_tx_weight(ice_get_pi_from_dev_rate(rate_vport), node, extack);
+}
+
+static int ice_devlink_rate_node_tx_max_set(struct devlink_rate *rate_node, void *priv,
+					    u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_max = tx_max / 10;
+
+	return ice_set_object_tx_max(ice_get_pi_from_dev_rate(rate_node), node, extack);
+}
+
+static int ice_devlink_rate_node_tx_share_set(struct devlink_rate *rate_node, void *priv,
+					      u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_share = tx_share / 10;
+
+	return ice_set_object_tx_share(ice_get_pi_from_dev_rate(rate_node), node, extack);
+}
+
+static int ice_devlink_rate_node_tx_priority_set(struct devlink_rate *rate_node, void *priv,
+						 u64 tx_priority, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_priority = tx_priority;
+
+	return ice_set_object_tx_priority(ice_get_pi_from_dev_rate(rate_node), node, extack);
+}
+
+static int ice_devlink_rate_node_tx_weight_set(struct devlink_rate *rate_node, void *priv,
+					       u64 tx_weight, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_weight = tx_weight;
+
+	return ice_set_object_tx_weight(ice_get_pi_from_dev_rate(rate_node), node, extack);
+}
+
+static int ice_devlink_rate_queue_tx_max_set(struct devlink_rate *rate_queue, void *priv,
+					     u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_max = tx_max / 10;
+
+	return ice_set_object_tx_max(ice_get_pi_from_dev_rate(rate_queue), node, extack);
+}
+
+static int ice_devlink_rate_queue_tx_share_set(struct devlink_rate *rate_queue, void *priv,
+					       u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_share = tx_share / 10;
+
+	return ice_set_object_tx_share(ice_get_pi_from_dev_rate(rate_queue), node, extack);
+}
+
+static int ice_devlink_rate_queue_tx_priority_set(struct devlink_rate *rate_queue, void *priv,
+						  u64 tx_priority, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_priority = tx_priority;
+
+	return ice_set_object_tx_priority(ice_get_pi_from_dev_rate(rate_queue), node, extack);
+}
+
+static int ice_devlink_rate_queue_tx_weight_set(struct devlink_rate *rate_queue, void *priv,
+						u64 tx_weight, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_weight = tx_weight;
+
+	return ice_set_object_tx_weight(ice_get_pi_from_dev_rate(rate_queue), node, extack);
+}
+
+static int ice_devlink_set_parent(struct devlink_rate *devlink_rate,
+				  struct devlink_rate *parent,
+				  void **priv, void *parent_priv,
+				  struct netlink_ext_ack *extack)
+{
+	struct ice_port_info *pi = ice_get_pi_from_dev_rate(devlink_rate);
+	struct ice_sched_node *tc_node, *node, *parent_node;
+	u16 num_nodes_added;
+	u32 first_node_teid;
+	u32 node_teid;
+	int status;
+
+	tc_node = pi->root->children[0];
+	node = *priv;
+
+	if (!parent) {
+		if (!node || tc_node == node ||
+		    node->info.data.elem_type == ICE_AQC_ELEM_TYPE_LEAF) {
+			return -EINVAL;
+		}
+
+		mutex_lock(&pi->sched_lock);
+		ice_free_sched_node(pi, node);
+		mutex_unlock(&pi->sched_lock);
+
+		return 0;
+	}
+
+	parent_node = parent_priv;
+
+	/* if the node doesn't exist, create it */
+	if (!node) {
+		mutex_lock(&pi->sched_lock);
+
+		status = ice_sched_add_elems(pi, tc_node, parent_node,
+					     parent_node->tx_sched_layer + 1,
+					     1, &num_nodes_added, &first_node_teid);
+
+		mutex_unlock(&pi->sched_lock);
+
+		if (status) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't add a new node");
+			return status;
+		}
+
+		node = ice_sched_find_node_by_teid(parent_node, first_node_teid);
+		*priv = node;
+
+		if (devlink_rate->tx_share) {
+			node->tx_share = devlink_rate->tx_share;
+			ice_set_object_tx_share(pi, node, extack);
+		}
+		if (devlink_rate->tx_max) {
+			node->tx_max = devlink_rate->tx_max;
+			ice_set_object_tx_max(pi, node, extack);
+		}
+		if (devlink_rate->tx_priority) {
+			node->tx_priority = devlink_rate->tx_priority;
+			ice_set_object_tx_priority(pi, node, extack);
+		}
+		if (devlink_rate->tx_weight) {
+			node->tx_weight = devlink_rate->tx_weight;
+			ice_set_object_tx_weight(pi, node, extack);
+		}
+	} else {
+		node_teid = le32_to_cpu(node->info.node_teid);
+		mutex_lock(&pi->sched_lock);
+		status = ice_sched_move_nodes(pi, parent_node, 1, &node_teid);
+		mutex_unlock(&pi->sched_lock);
+
+		if (status)
+			NL_SET_ERR_MSG_MOD(extack, "Can't move existing node to a new parent");
+	}
+
+	return status;
+}
+
+static int
+ice_devlink_reassign_queue(struct ice_port_info *pi, struct ice_sched_node *queue_node,
+			   struct ice_sched_node *src_node, struct ice_sched_node *dst_node)
+{
+	struct ice_aqc_move_txqs_data *buf;
+	struct ice_hw *hw = pi->hw;
+	u32 blocked_cgds;
+	u8 txqs_moved;
+	u16 buf_size;
+	int status;
+
+	buf_size = struct_size(buf, txqs, 1);
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	buf->src_teid = src_node->info.node_teid;
+	buf->dest_teid = dst_node->info.node_teid;
+	buf->txqs[0].txq_id = queue_node->tx_queue_id;
+	buf->txqs[0].q_cgd = 0;
+	buf->txqs[0].q_teid = queue_node->info.node_teid;
+
+	status = ice_aq_move_recfg_lan_txq(hw, 1, true, false, false, false, 50,
+					   &blocked_cgds, buf, buf_size, &txqs_moved, NULL);
+	if (!status)
+		ice_sched_update_parent(dst_node, queue_node);
+
+	kfree(buf);
+
+	return status;
+}
+
+static int ice_devlink_rate_queue_parent_set(struct devlink_rate *devlink_rate,
+					     struct devlink_rate *parent,
+					     void **priv, void *parent_priv,
+					     struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node, *prev_parent, *next_parent;
+	struct ice_port_info *pi;
+
+	if (!parent)
+		return -EINVAL;
+
+	pi = ice_get_pi_from_dev_rate(devlink_rate);
+
+	node = *priv;
+	next_parent = parent_priv;
+	prev_parent = node->parent;
+
+	return ice_devlink_reassign_queue(pi, node, prev_parent, next_parent);
+}
+
 static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
@@ -725,6 +1209,28 @@ static const struct devlink_ops ice_devlink_ops = {
 	.eswitch_mode_set = ice_eswitch_mode_set,
 	.info_get = ice_devlink_info_get,
 	.flash_update = ice_devlink_flash_update,
+
+	.rate_node_new = ice_devlink_rate_node_new,
+	.rate_node_del = ice_devlink_rate_node_del,
+
+	.rate_vport_tx_max_set = ice_devlink_rate_vport_tx_max_set,
+	.rate_vport_tx_share_set = ice_devlink_rate_vport_tx_share_set,
+	.rate_vport_tx_priority_set = ice_devlink_rate_vport_tx_priority_set,
+	.rate_vport_tx_weight_set = ice_devlink_rate_vport_tx_weight_set,
+
+	.rate_node_tx_max_set = ice_devlink_rate_node_tx_max_set,
+	.rate_node_tx_share_set = ice_devlink_rate_node_tx_share_set,
+	.rate_node_tx_priority_set = ice_devlink_rate_node_tx_priority_set,
+	.rate_node_tx_weight_set = ice_devlink_rate_node_tx_weight_set,
+
+	.rate_queue_tx_max_set = ice_devlink_rate_queue_tx_max_set,
+	.rate_queue_tx_share_set = ice_devlink_rate_queue_tx_share_set,
+	.rate_queue_tx_priority_set = ice_devlink_rate_queue_tx_priority_set,
+	.rate_queue_tx_weight_set = ice_devlink_rate_queue_tx_weight_set,
+
+	.rate_vport_parent_set = ice_devlink_set_parent,
+	.rate_node_parent_set = ice_devlink_set_parent,
+	.rate_queue_parent_set = ice_devlink_rate_queue_parent_set,
 };
 
 static int
@@ -893,6 +1399,9 @@ void ice_devlink_register(struct ice_pf *pf)
  */
 void ice_devlink_unregister(struct ice_pf *pf)
 {
+	devl_lock(priv_to_devlink(pf));
+	devl_rate_objects_destroy(priv_to_devlink(pf));
+	devl_unlock(priv_to_devlink(pf));
 	devlink_unregister(priv_to_devlink(pf));
 }
 
@@ -1098,6 +1607,8 @@ void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 
 	devlink_port = &vf->devlink_port;
 
+	devl_rate_vport_destroy(devlink_port);
+
 	devlink_port_type_clear(devlink_port);
 	devlink_port_unregister(devlink_port);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index fe006d9946f8..8bfed9ee2c4c 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -18,4 +18,6 @@ void ice_devlink_destroy_vf_port(struct ice_vf *vf);
 void ice_devlink_init_regions(struct ice_pf *pf);
 void ice_devlink_destroy_regions(struct ice_pf *pf);
 
+int ice_devlink_rate_init_tx_topology(struct devlink *devlink, struct ice_vsi *vsi);
+
 #endif /* _ICE_DEVLINK_H_ */
-- 
2.37.2

