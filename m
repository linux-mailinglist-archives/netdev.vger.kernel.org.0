Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542E01AE366
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgDQRNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:13:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:30119 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgDQRM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:12:58 -0400
IronPort-SDR: qo2hFIEqF0eL5Um6BYABqiDFjmwv+ngtYd3XRKOC3W9dZgRsSG2LJJFiMLfKMNUPlZZ24Cy9vv
 sfl6jNUuokSw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:12:55 -0700
IronPort-SDR: k+pXinb4zF7xtkcYzeIT1U2Frr3rmoEBO1vgSqXrm7/05cbLzsWy/0xwZguyqufre0Z7sp/Oj1
 F1Z/8ZErv5VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="364383716"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2020 10:12:55 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     gregkh@linuxfoundation.org, jgg@ziepe.ca
Cc:     Mustafa Ismail <mustafa.ismail@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC PATCH v5 06/16] RDMA/irdma: Add QoS definitions
Date:   Fri, 17 Apr 2020 10:12:41 -0700
Message-Id: <20200417171251.1533371-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add definitions for managing the RDMA HW work scheduler (WS) tree.

A WS node is created via a control QP operation with the bandwidth
allocation, arbitration scheme, and traffic class of the QP specified.
The Qset handle returned associates the QoS parameters for the QP.
The Qset is registered with the LAN and a equivalent node is created
in the LAN packet scheduler tree.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/hw/irdma/ws.c | 395 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/irdma/ws.h |  39 +++
 2 files changed, 434 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/ws.c
 create mode 100644 drivers/infiniband/hw/irdma/ws.h

diff --git a/drivers/infiniband/hw/irdma/ws.c b/drivers/infiniband/hw/irdma/ws.c
new file mode 100644
index 000000000000..4828d7b0aee6
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/ws.c
@@ -0,0 +1,395 @@
+// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
+/* Copyright (c) 2019 Intel Corporation */
+#include "osdep.h"
+#include "status.h"
+#include "hmc.h"
+#include "defs.h"
+#include "type.h"
+#include "protos.h"
+
+#include "ws.h"
+
+/**
+ * irdma_alloc_node - Allocate a WS node and init
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ * @node_type: Type of node, leaf or parent
+ * @parent: parent node pointer
+ */
+static struct irdma_ws_node *irdma_alloc_node(struct irdma_sc_vsi *vsi,
+					      u8 user_pri,
+					      enum irdma_ws_node_type node_type,
+					      struct irdma_ws_node *parent)
+{
+	struct irdma_virt_mem ws_mem;
+	struct irdma_ws_node *node;
+	u16 node_index = 0;
+
+	ws_mem.size = sizeof(struct irdma_ws_node);
+	ws_mem.va = kzalloc(ws_mem.size, GFP_ATOMIC);
+	if (!ws_mem.va)
+		return NULL;
+
+	if (parent || vsi->vm_vf_type == IRDMA_VF_TYPE) {
+		node_index = irdma_alloc_ws_node_id(vsi->dev);
+		if (node_index == IRDMA_WS_NODE_INVALID) {
+			kfree(ws_mem.va);
+			return NULL;
+		}
+	}
+
+	node = ws_mem.va;
+	node->index = node_index;
+	node->vsi_index = vsi->vsi_idx;
+	INIT_LIST_HEAD(&node->child_list_head);
+	if (node_type == WS_NODE_TYPE_LEAF) {
+		node->type_leaf = true;
+		node->traffic_class = vsi->qos[user_pri].traffic_class;
+		node->user_pri = user_pri;
+		node->rel_bw = vsi->qos[user_pri].rel_bw;
+		if (!node->rel_bw)
+			node->rel_bw = 1;
+
+		node->lan_qs_handle = vsi->qos[user_pri].lan_qos_handle;
+		node->prio_type = IRDMA_PRIO_WEIGHTED_RR;
+	} else {
+		node->rel_bw = 1;
+		node->prio_type = IRDMA_PRIO_WEIGHTED_RR;
+	}
+
+	node->parent = parent;
+
+	return node;
+}
+
+/**
+ * irdma_free_node - Free a WS node
+ * @vsi: VSI stricture of device
+ * @node: Pointer to node to free
+ */
+static void irdma_free_node(struct irdma_sc_vsi *vsi,
+			    struct irdma_ws_node *node)
+{
+	struct irdma_virt_mem ws_mem;
+
+	if (node->index)
+		irdma_free_ws_node_id(vsi->dev, node->index);
+
+	ws_mem.va = node;
+	ws_mem.size = sizeof(struct irdma_ws_node);
+	kfree(ws_mem.va);
+}
+
+/**
+ * irdma_ws_cqp_cmd - Post CQP work scheduler node cmd
+ * @vsi: vsi pointer
+ * @node: pointer to node
+ * @cmd: add, remove or modify
+ */
+static enum irdma_status_code
+irdma_ws_cqp_cmd(struct irdma_sc_vsi *vsi, struct irdma_ws_node *node, u8 cmd)
+{
+	struct irdma_ws_node_info node_info = {};
+
+	node_info.id = node->index;
+	node_info.vsi = node->vsi_index;
+	if (node->parent)
+		node_info.parent_id = node->parent->index;
+	else
+		node_info.parent_id = node_info.id;
+
+	node_info.weight = node->rel_bw;
+	node_info.tc = node->traffic_class;
+	node_info.prio_type = node->prio_type;
+	node_info.type_leaf = node->type_leaf;
+	node_info.enable = node->enable;
+	if (irdma_cqp_ws_node_cmd(vsi->dev, cmd, &node_info)) {
+		dev_dbg(rfdev_to_dev(vsi->dev), "WS: CQP WS CMD failed\n");
+		return IRDMA_ERR_NO_MEMORY;
+	}
+
+	if (node->type_leaf && cmd == IRDMA_OP_WS_ADD_NODE) {
+		node->qs_handle = node_info.qs_handle;
+		vsi->qos[node->user_pri].qs_handle = node_info.qs_handle;
+	}
+
+	return 0;
+}
+
+/**
+ * ws_find_node - Find SC WS node based on VSI id or TC
+ * @parent: parent node of First VSI or TC node
+ * @match_val: value to match
+ * @type: match type VSI/TC
+ */
+static struct irdma_ws_node *ws_find_node(struct irdma_ws_node *parent,
+					  u16 match_val,
+					  enum irdma_ws_match_type type)
+{
+	struct irdma_ws_node *node;
+
+	switch (type) {
+	case WS_MATCH_TYPE_VSI:
+		list_for_each_entry(node, &parent->child_list_head, siblings) {
+			if (node->vsi_index == match_val)
+				return node;
+		}
+		break;
+	case WS_MATCH_TYPE_TC:
+		list_for_each_entry(node, &parent->child_list_head, siblings) {
+			if (node->traffic_class == match_val)
+				return node;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+/**
+ * irdma_tc_in_use - Checks to see if a leaf node is in use
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+static bool irdma_tc_in_use(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&vsi->qos[user_pri].lock, flags);
+	if (!list_empty(&vsi->qos[user_pri].qplist)) {
+		spin_unlock_irqrestore(&vsi->qos[user_pri].lock, flags);
+		return true;
+	}
+
+	/* Check if the traffic class associated with the given user priority
+	 * is in use by any other user priority. If so, nothing left to do
+	 */
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		if (vsi->qos[i].traffic_class == vsi->qos[user_pri].traffic_class &&
+		    !list_empty(&vsi->qos[i].qplist)) {
+			spin_unlock_irqrestore(&vsi->qos[user_pri].lock, flags);
+			return true;
+		}
+	}
+	spin_unlock_irqrestore(&vsi->qos[user_pri].lock, flags);
+
+	return false;
+}
+
+/**
+ * irdma_remove_leaf - Remove leaf node unconditionally
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+static void irdma_remove_leaf(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	struct irdma_ws_node *ws_tree_root, *vsi_node, *tc_node;
+
+	ws_tree_root = vsi->dev->ws_tree_root;
+	if (!ws_tree_root)
+		return;
+
+	vsi_node = ws_find_node(ws_tree_root, vsi->vsi_idx,
+				WS_MATCH_TYPE_VSI);
+	if (!vsi_node)
+		return;
+
+	tc_node = ws_find_node(vsi_node,
+			       vsi->qos[user_pri].traffic_class,
+			       WS_MATCH_TYPE_TC);
+	if (!tc_node)
+		return;
+
+	irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_DELETE_NODE);
+	vsi->unregister_qset(vsi, tc_node);
+	list_del(&tc_node->siblings);
+	irdma_free_node(vsi, tc_node);
+	/* Check if VSI node can be freed */
+	if (list_empty(&vsi_node->child_list_head)) {
+		irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_DELETE_NODE);
+		list_del(&vsi_node->siblings);
+		irdma_free_node(vsi, vsi_node);
+		/* Free head node there are no remaining VSI nodes */
+		if (list_empty(&ws_tree_root->child_list_head)) {
+			irdma_ws_cqp_cmd(vsi, ws_tree_root,
+					 IRDMA_OP_WS_DELETE_NODE);
+			irdma_free_node(vsi, ws_tree_root);
+			vsi->dev->ws_tree_root = NULL;
+		}
+	}
+}
+
+/**
+ * irdma_ws_add - Build work scheduler tree, set RDMA qs_handle
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+enum irdma_status_code irdma_ws_add(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	struct irdma_ws_node *ws_tree_root;
+	struct irdma_ws_node *vsi_node;
+	struct irdma_ws_node *tc_node;
+	u16 traffic_class;
+	enum irdma_status_code ret = 0;
+	int i;
+
+	mutex_lock(&vsi->dev->ws_mutex);
+	if (vsi->tc_change_pending) {
+		ret = IRDMA_ERR_NOT_READY;
+		goto exit;
+	}
+
+	ws_tree_root = vsi->dev->ws_tree_root;
+	if (!ws_tree_root) {
+		dev_dbg(rfdev_to_dev(vsi->dev), "WS: Creating root node\n");
+		ws_tree_root = irdma_alloc_node(vsi, user_pri,
+						WS_NODE_TYPE_PARENT, NULL);
+		if (!ws_tree_root) {
+			ret = IRDMA_ERR_NO_MEMORY;
+			goto exit;
+		}
+
+		ret = irdma_ws_cqp_cmd(vsi, ws_tree_root, IRDMA_OP_WS_ADD_NODE);
+		if (ret) {
+			irdma_free_node(vsi, ws_tree_root);
+			goto exit;
+		}
+
+		vsi->dev->ws_tree_root = ws_tree_root;
+	}
+
+	/* Find a second tier node that matches the VSI */
+	vsi_node = ws_find_node(ws_tree_root, vsi->vsi_idx,
+				WS_MATCH_TYPE_VSI);
+
+	/* If VSI node doesn't exist, add one */
+	if (!vsi_node) {
+		dev_dbg(rfdev_to_dev(vsi->dev),
+			"WS: Node not found matching VSI %d\n", vsi->vsi_idx);
+		vsi_node = irdma_alloc_node(vsi, user_pri, WS_NODE_TYPE_PARENT,
+					    ws_tree_root);
+		if (!vsi_node) {
+			ret = IRDMA_ERR_NO_MEMORY;
+			goto vsi_add_err;
+		}
+
+		ret = irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_ADD_NODE);
+		if (ret) {
+			irdma_free_node(vsi, vsi_node);
+			goto vsi_add_err;
+		}
+
+		list_add(&vsi_node->siblings, &ws_tree_root->child_list_head);
+	}
+
+	dev_dbg(rfdev_to_dev(vsi->dev),
+		"WS: Using node %d which represents VSI %d\n",
+		vsi_node->index, vsi->vsi_idx);
+	traffic_class = vsi->qos[user_pri].traffic_class;
+	tc_node = ws_find_node(vsi_node, traffic_class,
+			       WS_MATCH_TYPE_TC);
+	if (!tc_node) {
+		/* Add leaf node */
+		dev_dbg(rfdev_to_dev(vsi->dev),
+			"WS: Node not found matching VSI %d and TC %d\n",
+			vsi->vsi_idx, traffic_class);
+		tc_node = irdma_alloc_node(vsi, user_pri, WS_NODE_TYPE_LEAF,
+					   vsi_node);
+		if (!tc_node) {
+			ret = IRDMA_ERR_NO_MEMORY;
+			goto leaf_add_err;
+		}
+
+		ret = irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_ADD_NODE);
+		if (ret) {
+			irdma_free_node(vsi, tc_node);
+			goto leaf_add_err;
+		}
+
+		list_add(&tc_node->siblings, &vsi_node->child_list_head);
+		/*
+		 * callback to LAN to update the LAN tree with our node
+		 */
+		ret = vsi->register_qset(vsi, tc_node);
+		if (ret)
+			goto reg_err;
+
+		tc_node->enable = true;
+		ret = irdma_ws_cqp_cmd(vsi, tc_node, IRDMA_OP_WS_MODIFY_NODE);
+		if (ret)
+			goto reg_err;
+	}
+	dev_dbg(rfdev_to_dev(vsi->dev),
+		"WS: Using node %d which represents VSI %d TC %d\n",
+		tc_node->index, vsi->vsi_idx, traffic_class);
+	/*
+	 * Iterate through other UPs and update the QS handle if they have
+	 * a matching traffic class.
+	 */
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
+		if (vsi->qos[i].traffic_class == traffic_class) {
+			vsi->qos[i].qs_handle = tc_node->qs_handle;
+			vsi->qos[i].lan_qos_handle = tc_node->lan_qs_handle;
+			vsi->qos[i].l2_sched_node_id = tc_node->l2_sched_node_id;
+		}
+	}
+	goto exit;
+
+leaf_add_err:
+	if (list_empty(&vsi_node->child_list_head)) {
+		if (irdma_ws_cqp_cmd(vsi, vsi_node, IRDMA_OP_WS_DELETE_NODE))
+			goto exit;
+		list_del(&vsi_node->siblings);
+		irdma_free_node(vsi, vsi_node);
+	}
+
+vsi_add_err:
+	/* Free head node there are no remaining VSI nodes */
+	if (list_empty(&ws_tree_root->child_list_head)) {
+		irdma_ws_cqp_cmd(vsi, ws_tree_root, IRDMA_OP_WS_DELETE_NODE);
+		vsi->dev->ws_tree_root = NULL;
+		irdma_free_node(vsi, ws_tree_root);
+	}
+
+exit:
+	mutex_unlock(&vsi->dev->ws_mutex);
+	return ret;
+
+reg_err:
+	mutex_unlock(&vsi->dev->ws_mutex);
+	irdma_ws_remove(vsi, user_pri);
+	return ret;
+}
+
+/**
+ * irdma_ws_remove - Free WS scheduler node, update WS tree
+ * @vsi: vsi pointer
+ * @user_pri: user priority
+ */
+void irdma_ws_remove(struct irdma_sc_vsi *vsi, u8 user_pri)
+{
+	mutex_lock(&vsi->dev->ws_mutex);
+	if (irdma_tc_in_use(vsi, user_pri))
+		goto exit;
+
+	irdma_remove_leaf(vsi, user_pri);
+exit:
+	mutex_unlock(&vsi->dev->ws_mutex);
+}
+
+/**
+ * irdma_ws_reset - Reset entire WS tree
+ * @vsi: vsi pointer
+ */
+void irdma_ws_reset(struct irdma_sc_vsi *vsi)
+{
+	u8 i;
+
+	mutex_lock(&vsi->dev->ws_mutex);
+	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; ++i)
+		irdma_remove_leaf(vsi, i);
+	mutex_unlock(&vsi->dev->ws_mutex);
+}
diff --git a/drivers/infiniband/hw/irdma/ws.h b/drivers/infiniband/hw/irdma/ws.h
new file mode 100644
index 000000000000..442864284801
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/ws.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
+/* Copyright (c) 2015 - 2019 Intel Corporation */
+#ifndef IRDMA_WS_H
+#define IRDMA_WS_H
+
+#include "osdep.h"
+
+enum irdma_ws_node_type {
+	WS_NODE_TYPE_PARENT,
+	WS_NODE_TYPE_LEAF,
+};
+
+enum irdma_ws_match_type {
+	WS_MATCH_TYPE_VSI,
+	WS_MATCH_TYPE_TC,
+};
+
+struct irdma_ws_node {
+	struct list_head siblings;
+	struct list_head child_list_head;
+	struct irdma_ws_node *parent;
+	u64 lan_qs_handle; /* opaque handle used by LAN */
+	u32 l2_sched_node_id;
+	u16 index;
+	u16 qs_handle;
+	u16 vsi_index;
+	u8 traffic_class;
+	u8 user_pri;
+	u8 rel_bw;
+	u8 abstraction_layer; /* used for splitting a TC */
+	u8 prio_type;
+	bool type_leaf:1;
+	bool enable:1;
+};
+
+enum irdma_status_code irdma_ws_add(struct irdma_sc_vsi *vsi, u8 user_pri);
+void irdma_ws_remove(struct irdma_sc_vsi *vsi, u8 user_pri);
+void irdma_ws_reset(struct irdma_sc_vsi *vsi);
+#endif /* IRDMA_WS_H */
-- 
2.25.2

