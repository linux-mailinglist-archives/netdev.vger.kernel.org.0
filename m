Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258719228B
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 13:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfHSLgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 07:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfHSLgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 07:36:43 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68142063F;
        Mon, 19 Aug 2019 11:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566214602;
        bh=Dh5z2lybnSOtX+e2SmLVJ5/kFl8VFF6M3VaNO04+atw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxDbHviVSHLh551F1/s6aA8n3SqhaounB9Lf7ouRin2PFy7KRB1l2E4NyO3f1Gbj/
         9dGLABdlgTfMDFCyRSM3d2zXds5bf3zMMYQCiHGs6IURh+8ZuQTH/bCOlL7ppHzBAw
         +bAbo9wQF8VWIOmSx9K9erPlMB7mGO1jzNnNAxEs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 2/3] net/mlx5: Create bypass and loopback flow steering namespaces for RDMA RX
Date:   Mon, 19 Aug 2019 14:36:25 +0300
Message-Id: <20190819113626.20284-3-leon@kernel.org>
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

Use different namespaces for bypass and switchdev loopback because they
have different priorities and default table miss action requirement:
1. bypass: with multiple priorities support, and
   MLX5_FLOW_TABLE_MISS_ACTION_DEF as the default table miss action;
2. switchdev loopback: with single priority support, and
   MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN as the default table miss
   action.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 49 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/rdma.c    |  2 +-
 include/linux/mlx5/fs.h                       |  1 +
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fb3cfdfbafbe..7bdec442f0ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -182,6 +182,26 @@ static struct init_tree_node egress_root_fs = {
 	}
 };
 
+#define RDMA_RX_BYPASS_PRIO 0
+#define RDMA_RX_KERNEL_PRIO 1
+static struct init_tree_node rdma_rx_root_fs = {
+	.type = FS_TYPE_NAMESPACE,
+	.ar_size = 2,
+	.children = (struct init_tree_node[]) {
+		[RDMA_RX_BYPASS_PRIO] =
+		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_REGULAR_PRIOS,
+						  BY_PASS_PRIO_NUM_LEVELS))),
+		[RDMA_RX_KERNEL_PRIO] =
+		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS + 1, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN,
+				ADD_MULTIPLE_PRIO(1, 1))),
+	}
+};
+
 enum fs_i_lock_class {
 	FS_LOCK_GRANDPARENT,
 	FS_LOCK_PARENT,
@@ -2067,16 +2087,18 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
 		return NULL;
-	case MLX5_FLOW_NAMESPACE_RDMA_RX:
-		if (steering->rdma_rx_root_ns)
-			return &steering->rdma_rx_root_ns->ns;
-		return NULL;
 	default:
 		break;
 	}
 
 	if (type == MLX5_FLOW_NAMESPACE_EGRESS) {
 		root_ns = steering->egress_root_ns;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX) {
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_BYPASS_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL) {
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_KERNEL_PRIO;
 	} else { /* Must be NIC RX */
 		root_ns = steering->root_ns;
 		prio = type;
@@ -2507,18 +2529,25 @@ static int init_sniffer_rx_root_ns(struct mlx5_flow_steering *steering)
 
 static int init_rdma_rx_root_ns(struct mlx5_flow_steering *steering)
 {
-	struct fs_prio *prio;
+	int err;
 
 	steering->rdma_rx_root_ns = create_root_ns(steering, FS_FT_RDMA_RX);
 	if (!steering->rdma_rx_root_ns)
 		return -ENOMEM;
 
-	steering->rdma_rx_root_ns->ns.def_miss_action =
-		MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN;
+	err = init_root_tree(steering, &rdma_rx_root_fs,
+			     &steering->rdma_rx_root_ns->ns.node);
+	if (err)
+		goto out_err;
 
-	/* Create single prio */
-	prio = fs_create_prio(&steering->rdma_rx_root_ns->ns, 0, 1);
-	return PTR_ERR_OR_ZERO(prio);
+	set_prio_attrs(steering->rdma_rx_root_ns);
+
+	return 0;
+
+out_err:
+	cleanup_root_ns(steering->rdma_rx_root_ns);
+	steering->rdma_rx_root_ns = NULL;
+	return err;
 }
 static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index 17ce9dd56b13..18af6981e0be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -51,7 +51,7 @@ static int mlx5_rdma_enable_roce_steering(struct mlx5_core_dev *dev)
 		return -ENOMEM;
 	}
 
-	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_RDMA_RX);
+	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL);
 	if (!ns) {
 		mlx5_core_err(dev, "Failed to get RDMA RX namespace");
 		err = -EOPNOTSUPP;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 04a569568eac..5235b09a8ef3 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -75,6 +75,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_SNIFFER_TX,
 	MLX5_FLOW_NAMESPACE_EGRESS,
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 };
 
 enum {
-- 
2.20.1

