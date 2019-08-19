Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5407492287
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 13:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfHSLgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 07:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfHSLgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 07:36:37 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88432063F;
        Mon, 19 Aug 2019 11:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566214595;
        bh=3VsIy8a6UEh3Iz6brqydfUyslV6tDliigK5MGul8jX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIIpmKvBubMHlASWJ47ybPXTKgFFReayQERCSqB873vpprHfMLPoAV/sjbLEWVRuz
         VZ/1Cw4+JSVOeC25sdsHwdXAzKfT/aIYTMnF8cwMy4QjiZU6272VTG+r76vk8kGPxJ
         2J+kMPRtufeF7FfBM5H2gj3A1hs0rH6vizqiiSj8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Add per-namespace flow table default miss action support
Date:   Mon, 19 Aug 2019 14:36:24 +0300
Message-Id: <20190819113626.20284-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819113626.20284-1-leon@kernel.org>
References: <20190819113626.20284-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Currently all the namespaces under the same steering domain share the same
default table miss action, however in some situations (e.g., RDMA RX)
different actions are required. This patch adds a per-namespace default
table miss action instead of using the miss action of the steering domain.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 73 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  3 +-
 3 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index b84a225bbe86..1e3381604b3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -182,7 +182,7 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 		} else {
 			MLX5_SET(create_flow_table_in, in,
 				 flow_table_context.table_miss_action,
-				 ns->def_miss_action);
+				 ft->def_miss_action);
 		}
 		break;
 
@@ -262,7 +262,7 @@ static int mlx5_cmd_modify_flow_table(struct mlx5_flow_root_namespace *ns,
 		} else {
 			MLX5_SET(modify_flow_table_in, in,
 				 flow_table_context.table_miss_action,
-				 ns->def_miss_action);
+				 ft->def_miss_action);
 		}
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3e99799bdb40..fb3cfdfbafbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -60,7 +60,8 @@
 	ADD_PRIO(num_prios_val, 0, num_levels_val, {},\
 		 __VA_ARGS__)\
 
-#define ADD_NS(...) {.type = FS_TYPE_NAMESPACE,\
+#define ADD_NS(def_miss_act, ...) {.type = FS_TYPE_NAMESPACE,	\
+	.def_miss_action = def_miss_act,\
 	.children = (struct init_tree_node[]) {__VA_ARGS__},\
 	.ar_size = INIT_TREE_NODE_ARRAY_SIZE(__VA_ARGS__) \
 }
@@ -131,33 +132,41 @@ static struct init_tree_node {
 	int num_leaf_prios;
 	int prio;
 	int num_levels;
+	enum mlx5_flow_table_miss_action def_miss_action;
 } root_fs = {
 	.type = FS_TYPE_NAMESPACE,
 	.ar_size = 7,
-	.children = (struct init_tree_node[]) {
-		ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0,
-			 FS_CHAINING_CAPS,
-			 ADD_NS(ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
-						  BY_PASS_PRIO_NUM_LEVELS))),
-		ADD_PRIO(0, LAG_MIN_LEVEL, 0,
-			 FS_CHAINING_CAPS,
-			 ADD_NS(ADD_MULTIPLE_PRIO(LAG_NUM_PRIOS,
-						  LAG_PRIO_NUM_LEVELS))),
-		ADD_PRIO(0, OFFLOADS_MIN_LEVEL, 0, {},
-			 ADD_NS(ADD_MULTIPLE_PRIO(OFFLOADS_NUM_PRIOS, OFFLOADS_MAX_FT))),
-		ADD_PRIO(0, ETHTOOL_MIN_LEVEL, 0,
-			 FS_CHAINING_CAPS,
-			 ADD_NS(ADD_MULTIPLE_PRIO(ETHTOOL_NUM_PRIOS,
-						  ETHTOOL_PRIO_NUM_LEVELS))),
-		ADD_PRIO(0, KERNEL_MIN_LEVEL, 0, {},
-			 ADD_NS(ADD_MULTIPLE_PRIO(KERNEL_NIC_TC_NUM_PRIOS, KERNEL_NIC_TC_NUM_LEVELS),
-				ADD_MULTIPLE_PRIO(KERNEL_NIC_NUM_PRIOS,
-						  KERNEL_NIC_PRIO_NUM_LEVELS))),
-		ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0,
-			 FS_CHAINING_CAPS,
-			 ADD_NS(ADD_MULTIPLE_PRIO(LEFTOVERS_NUM_PRIOS, LEFTOVERS_NUM_LEVELS))),
-		ADD_PRIO(0, ANCHOR_MIN_LEVEL, 0, {},
-			 ADD_NS(ADD_MULTIPLE_PRIO(ANCHOR_NUM_PRIOS, ANCHOR_NUM_LEVELS))),
+	  .children = (struct init_tree_node[]){
+		  ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0, FS_CHAINING_CAPS,
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+						    BY_PASS_PRIO_NUM_LEVELS))),
+		  ADD_PRIO(0, LAG_MIN_LEVEL, 0, FS_CHAINING_CAPS,
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(LAG_NUM_PRIOS,
+						    LAG_PRIO_NUM_LEVELS))),
+		  ADD_PRIO(0, OFFLOADS_MIN_LEVEL, 0, {},
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(OFFLOADS_NUM_PRIOS,
+						    OFFLOADS_MAX_FT))),
+		  ADD_PRIO(0, ETHTOOL_MIN_LEVEL, 0, FS_CHAINING_CAPS,
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(ETHTOOL_NUM_PRIOS,
+						    ETHTOOL_PRIO_NUM_LEVELS))),
+		  ADD_PRIO(0, KERNEL_MIN_LEVEL, 0, {},
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(KERNEL_NIC_TC_NUM_PRIOS,
+						    KERNEL_NIC_TC_NUM_LEVELS),
+				  ADD_MULTIPLE_PRIO(KERNEL_NIC_NUM_PRIOS,
+						    KERNEL_NIC_PRIO_NUM_LEVELS))),
+		  ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0, FS_CHAINING_CAPS,
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(LEFTOVERS_NUM_PRIOS,
+						    LEFTOVERS_NUM_LEVELS))),
+		  ADD_PRIO(0, ANCHOR_MIN_LEVEL, 0, {},
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(ANCHOR_NUM_PRIOS,
+						    ANCHOR_NUM_LEVELS))),
 	}
 };
 
@@ -167,7 +176,8 @@ static struct init_tree_node egress_root_fs = {
 	.children = (struct init_tree_node[]) {
 		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
 			 FS_CHAINING_CAPS_EGRESS,
-			 ADD_NS(ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 	}
 };
@@ -1014,6 +1024,7 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 	tree_init_node(&ft->node, del_hw_flow_table, del_sw_flow_table);
 	log_table_sz = ft->max_fte ? ilog2(ft->max_fte) : 0;
 	next_ft = find_next_chained_ft(fs_prio);
+	ft->def_miss_action = ns->def_miss_action;
 	err = root->cmds->create_flow_table(root, ft, log_table_sz, next_ft);
 	if (err)
 		goto free_ft;
@@ -2155,7 +2166,8 @@ static struct mlx5_flow_namespace *fs_init_namespace(struct mlx5_flow_namespace
 	return ns;
 }
 
-static struct mlx5_flow_namespace *fs_create_namespace(struct fs_prio *prio)
+static struct mlx5_flow_namespace *fs_create_namespace(struct fs_prio *prio,
+						       int def_miss_act)
 {
 	struct mlx5_flow_namespace	*ns;
 
@@ -2164,6 +2176,7 @@ static struct mlx5_flow_namespace *fs_create_namespace(struct fs_prio *prio)
 		return ERR_PTR(-ENOMEM);
 
 	fs_init_namespace(ns);
+	ns->def_miss_action = def_miss_act;
 	tree_init_node(&ns->node, NULL, del_sw_ns);
 	tree_add_node(&ns->node, &prio->node);
 	list_add_tail(&ns->node.list, &prio->node.children);
@@ -2230,7 +2243,7 @@ static int init_root_tree_recursive(struct mlx5_flow_steering *steering,
 		base = &fs_prio->node;
 	} else if (init_node->type == FS_TYPE_NAMESPACE) {
 		fs_get_obj(fs_prio, fs_parent_node);
-		fs_ns = fs_create_namespace(fs_prio);
+		fs_ns = fs_create_namespace(fs_prio, init_node->def_miss_action);
 		if (IS_ERR(fs_ns))
 			return PTR_ERR(fs_ns);
 		base = &fs_ns->node;
@@ -2500,7 +2513,7 @@ static int init_rdma_rx_root_ns(struct mlx5_flow_steering *steering)
 	if (!steering->rdma_rx_root_ns)
 		return -ENOMEM;
 
-	steering->rdma_rx_root_ns->def_miss_action =
+	steering->rdma_rx_root_ns->ns.def_miss_action =
 		MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN;
 
 	/* Create single prio */
@@ -2543,7 +2556,7 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	}
 
 	for (chain = 0; chain <= FDB_MAX_CHAIN; chain++) {
-		ns = fs_create_namespace(maj_prio);
+		ns = fs_create_namespace(maj_prio, MLX5_FLOW_TABLE_MISS_ACTION_DEF);
 		if (IS_ERR(ns)) {
 			err = PTR_ERR(ns);
 			goto out_err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index c48c382f926f..69f809831959 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -145,6 +145,7 @@ struct mlx5_flow_table {
 	struct list_head		fwd_rules;
 	u32				flags;
 	struct rhltable			fgs_hash;
+	enum mlx5_flow_table_miss_action def_miss_action;
 };
 
 struct mlx5_ft_underlay_qp {
@@ -191,6 +192,7 @@ struct fs_prio {
 struct mlx5_flow_namespace {
 	/* parent == NULL => root ns */
 	struct	fs_node			node;
+	enum mlx5_flow_table_miss_action def_miss_action;
 };
 
 struct mlx5_flow_group_mask {
@@ -219,7 +221,6 @@ struct mlx5_flow_root_namespace {
 	struct mutex			chain_lock;
 	struct list_head		underlay_qpns;
 	const struct mlx5_flow_cmds	*cmds;
-	enum mlx5_flow_table_miss_action def_miss_action;
 };
 
 int mlx5_init_fc_stats(struct mlx5_core_dev *dev);
-- 
2.20.1

