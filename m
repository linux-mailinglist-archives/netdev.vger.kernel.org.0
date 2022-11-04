Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123D1619A19
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiKDOeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiKDOeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:34:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F29219004
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572310; x=1699108310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RwhCLxS1ycbgFj9IK/S0L2UuEnTPlfQqSuACrLsATPg=;
  b=Ct1Gqvay8walKEIGc8+TfiB1TcmkS/IMWBOB3yxxlkziyTF4ew358kSk
   v4HTlmVKT3t5BkL+FY1I0iDAF2talCSMi0bvDlSNwXLISap5ia/N9ARlI
   SLSomS06E4ScRNMYEwt/VqQqa6krOMsh7CJbSUqOX0Z3HuTa4zR/UcjY6
   ElXY415h+iXg0cZ11YdZvGhVT0iUdD5vkJm+CmdSWysCo/uWPYkZ3cllZ
   VuFnQ1BJEW8WhZfdqYGYjrMMwIbLHOkVY9S+MfjKSs57oa+C56kMHSp7l
   L9TqiBRLtAsolt+pTfWE7ZBl7u7sDFvf+jaVjwj/DqlRW+yNdqDCEIT6s
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="290367548"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="290367548"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="777730375"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="777730375"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:31:41 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v9 8/9] ice: Implement devlink-rate API
Date:   Fri,  4 Nov 2022 15:31:01 +0100
Message-Id: <20221104143102.1120076-9-michal.wilczynski@intel.com>
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

There is a need to support modification of Tx scheduler tree, in the
ice driver. This will allow user to control Tx settings of each node in
the internal hierarchy of nodes. As a result user will be able to use
Hierarchy QoS implemented entirely in the hardware.

This patch implemenents devlink-rate API. It also exports initial
default hierarchy. It's mostly dictated by the fact that the tree
can't be removed entirely, all we can do is enable the user to modify
it. For example root node shouldn't ever be removed, also nodes that
have children are off-limits.

Example initial tree with 2 VF's:

[root@fedora ~]# devlink port function rate show

pci/0000:4b:00.0/node_27: type node parent node_26
pci/0000:4b:00.0/node_26: type node parent node_0
pci/0000:4b:00.0/node_34: type node parent node_33
pci/0000:4b:00.0/node_33: type node parent node_32
pci/0000:4b:00.0/node_32: type node parent node_16
pci/0000:4b:00.0/node_19: type node parent node_18
pci/0000:4b:00.0/node_18: type node parent node_17
pci/0000:4b:00.0/node_17: type node parent node_16
pci/0000:4b:00.0/node_21: type node parent node_20
pci/0000:4b:00.0/node_20: type node parent node_3
pci/0000:4b:00.0/node_14: type node parent node_5
pci/0000:4b:00.0/node_5: type node parent node_3
pci/0000:4b:00.0/node_13: type node parent node_4
pci/0000:4b:00.0/node_12: type node parent node_4
pci/0000:4b:00.0/node_11: type node parent node_4
pci/0000:4b:00.0/node_10: type node parent node_4
pci/0000:4b:00.0/node_9: type node parent node_4
pci/0000:4b:00.0/node_8: type node parent node_4
pci/0000:4b:00.0/node_7: type node parent node_4
pci/0000:4b:00.0/node_6: type node parent node_4
pci/0000:4b:00.0/node_4: type node parent node_3
pci/0000:4b:00.0/node_3: type node parent node_16
pci/0000:4b:00.0/node_16: type node parent node_15
pci/0000:4b:00.0/node_15: type node parent node_0
pci/0000:4b:00.0/node_2: type node parent node_1
pci/0000:4b:00.0/node_1: type node parent node_0
pci/0000:4b:00.0/node_0: type node
pci/0000:4b:00.0/1: type leaf parent node_27
pci/0000:4b:00.0/2: type leaf parent node_27

Let me visualize part of the tree:

                    +---------+
                    |  node_0 |
                    +---------+
                         |
                    +----v----+
                    | node_26 |
                    +----+----+
                         |
                    +----v----+
                    | node_27 |
                    +----+----+
                         |
                |-----------------|
           +----v----+       +----v----+
           |   VF 1  |       |   VF 2  |
           +----+----+       +----+----+

So at this point there is a couple things that can be done.
For example we could only assign parameters to VF's.

[root@fedora ~]# devlink port function rate set pci/0000:4b:00.0/1 \
                 tx_max 5Gbps

This would cap the VF 1 BW to 5Gbps.

But let's say you would like to create a completely new branch.
This can be done like this:

[root@fedora ~]# devlink port function rate add \
                 pci/0000:4b:00.0/node_custom parent node_0
[root@fedora ~]# devlink port function rate add \
                 pci/0000:4b:00.0/node_custom_1 parent node_custom
[root@fedora ~]# devlink port function rate set \
                 pci/0000:4b:00.0/1 parent node_custom_1

This creates a completely new branch and reassigns VF 1 to it.

A number of parameters is supported per each node: tx_max, tx_share,
tx_priority and tx_weight.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 419 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |   2 +
 drivers/net/ethernet/intel/ice/ice_repr.c    |  13 +
 3 files changed, 434 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 455489e9457d..d6e65d7b2d6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -713,6 +713,408 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
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
+	struct devlink_rate *rate_node;
+	struct ice_vf *vf;
+	int i;
+
+	devl_lock(devlink);
+
+	if (node->parent == tc_node) {
+		/* create root node */
+		rate_node = devl_rate_node_create(devlink, node, node->name, NULL);
+	} else if (node->vsi_handle &&
+		   pf->vsi[node->vsi_handle]->vf) {
+		vf = pf->vsi[node->vsi_handle]->vf;
+		if (!vf->devlink_port.devlink_rate)
+			/* leaf nodes doesn't have children so we don't set rate_node */
+			devl_rate_leaf_create(&vf->devlink_port, node,
+					      node->parent->rate_node);
+	} else if (node->info.data.elem_type != ICE_AQC_ELEM_TYPE_LEAF &&
+		   node->parent->name) {
+		rate_node = devl_rate_node_create(devlink, node, node->name,
+						  node->parent->rate_node);
+	}
+
+	if (!IS_ERR(rate_node))
+		node->rate_node = rate_node;
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
+	if (node->tx_priority >= 8) {
+		NL_SET_ERR_MSG_MOD(extack, "Priority should be less than 8");
+		return -EINVAL;
+	}
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
+	if (node->tx_weight > 200 || node->tx_weight < 1) {
+		NL_SET_ERR_MSG_MOD(extack, "Weight must be between 1 and 200");
+		return -EINVAL;
+	}
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
+	struct ice_sched_node *node;
+	struct ice_port_info *pi;
+
+	pi = ice_get_pi_from_dev_rate(rate_node);
+
+	/* preallocate memory for ice_sched_node */
+	node = devm_kzalloc(ice_hw_to_dev(pi->hw), sizeof(*node), GFP_KERNEL);
+	*priv = node;
+
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
+	if (!rate_node->parent || !node || tc_node == node || !extack)
+		return 0;
+
+	/* can't allow to delete a node with children */
+	if (node->num_children)
+		return -EINVAL;
+
+	mutex_lock(&pi->sched_lock);
+	ice_free_sched_node(pi, node);
+	mutex_unlock(&pi->sched_lock);
+
+	return 0;
+}
+
+static int ice_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
+					    u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_max = div_u64(tx_max, 10);
+
+	return ice_set_object_tx_max(ice_get_pi_from_dev_rate(rate_leaf), node, extack);
+}
+
+static int ice_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
+					      u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_share = div_u64(tx_share, 10);
+
+	return ice_set_object_tx_share(ice_get_pi_from_dev_rate(rate_leaf), node, extack);
+}
+
+static int ice_devlink_rate_leaf_tx_priority_set(struct devlink_rate *rate_leaf, void *priv,
+						 u64 tx_priority, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_priority = tx_priority;
+
+	return ice_set_object_tx_priority(ice_get_pi_from_dev_rate(rate_leaf), node, extack);
+}
+
+static int ice_devlink_rate_leaf_tx_weight_set(struct devlink_rate *rate_leaf, void *priv,
+					       u64 tx_weight, struct netlink_ext_ack *extack)
+{
+	struct ice_sched_node *node = priv;
+
+	if (!node)
+		return 0;
+
+	node->tx_weight = tx_weight;
+
+	return ice_set_object_tx_weight(ice_get_pi_from_dev_rate(rate_leaf), node, extack);
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
+	node->tx_max = div_u64(tx_max, 10);
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
+	node->tx_share = div_u64(tx_share, 10);
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
+static int ice_devlink_set_parent(struct devlink_rate *devlink_rate,
+				  struct devlink_rate *parent,
+				  void *priv, void *parent_priv,
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
+	node = priv;
+
+	if (!extack)
+		return 0;
+
+	if (!parent) {
+		if (!node || tc_node == node || node->num_children)
+			return -EINVAL;
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
+	if (!node->parent) {
+		mutex_lock(&pi->sched_lock);
+
+		status = ice_sched_add_elems(pi, tc_node, parent_node,
+					     parent_node->tx_sched_layer + 1,
+					     1, &num_nodes_added, &first_node_teid,
+					     &node);
+
+		mutex_unlock(&pi->sched_lock);
+
+		if (status) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't add a new node");
+			return status;
+		}
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
 static const struct devlink_ops ice_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
@@ -725,6 +1127,22 @@ static const struct devlink_ops ice_devlink_ops = {
 	.eswitch_mode_set = ice_eswitch_mode_set,
 	.info_get = ice_devlink_info_get,
 	.flash_update = ice_devlink_flash_update,
+
+	.rate_node_new = ice_devlink_rate_node_new,
+	.rate_node_del = ice_devlink_rate_node_del,
+
+	.rate_leaf_tx_max_set = ice_devlink_rate_leaf_tx_max_set,
+	.rate_leaf_tx_share_set = ice_devlink_rate_leaf_tx_share_set,
+	.rate_leaf_tx_priority_set = ice_devlink_rate_leaf_tx_priority_set,
+	.rate_leaf_tx_weight_set = ice_devlink_rate_leaf_tx_weight_set,
+
+	.rate_node_tx_max_set = ice_devlink_rate_node_tx_max_set,
+	.rate_node_tx_share_set = ice_devlink_rate_node_tx_share_set,
+	.rate_node_tx_priority_set = ice_devlink_rate_node_tx_priority_set,
+	.rate_node_tx_weight_set = ice_devlink_rate_node_tx_weight_set,
+
+	.rate_leaf_parent_set = ice_devlink_set_parent,
+	.rate_node_parent_set = ice_devlink_set_parent,
 };
 
 static int
@@ -1089,6 +1507,7 @@ int ice_devlink_create_vf_port(struct ice_vf *vf)
  */
 void ice_devlink_destroy_vf_port(struct ice_vf *vf)
 {
+	devl_rate_leaf_destroy(&vf->devlink_port);
 	devlink_port_unregister(&vf->devlink_port);
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
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 0483eb14c288..46f58d48318c 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -389,6 +389,7 @@ static void ice_repr_rem(struct ice_vf *vf)
  */
 void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
 {
+	struct devlink *devlink;
 	struct ice_vf *vf;
 	unsigned int bkt;
 
@@ -396,6 +397,14 @@ void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
 
 	ice_for_each_vf(pf, bkt, vf)
 		ice_repr_rem(vf);
+
+	/* since all port representors are destroyed, there is
+	 * no point in keeping the nodes
+	 */
+	devlink = priv_to_devlink(pf);
+	devl_lock(devlink);
+	devl_rate_nodes_destroy(devlink);
+	devl_unlock(devlink);
 }
 
 /**
@@ -404,6 +413,7 @@ void ice_repr_rem_from_all_vfs(struct ice_pf *pf)
  */
 int ice_repr_add_for_all_vfs(struct ice_pf *pf)
 {
+	struct devlink *devlink;
 	struct ice_vf *vf;
 	unsigned int bkt;
 	int err;
@@ -416,6 +426,9 @@ int ice_repr_add_for_all_vfs(struct ice_pf *pf)
 			goto err;
 	}
 
+	devlink = priv_to_devlink(pf);
+	ice_devlink_rate_init_tx_topology(devlink, ice_get_main_vsi(pf));
+
 	return 0;
 
 err:
-- 
2.37.2

