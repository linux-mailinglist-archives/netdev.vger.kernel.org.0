Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA13935B4
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhE0S61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236118AbhE0S6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0DA1613DA;
        Thu, 27 May 2021 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141799;
        bh=nmQMpDdS66Pr3+LbIaQYoJ3Ix8L5gz828xcFiDNMYaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAj6fXIRPmTOqUQJpkBaaBDFd3sgat7vMi2HDO+ZnCDddYJY3ENjRhxkZVGRYcBBC
         UIs6jVC65gFhw0ORNiP6Ig0KSHoF2JM3bzS4XshynpbYhSNrumV/e7etERSYFUXytS
         sYl9/j6NZUiTjTS9/CgOXotj7SJ2h4jA6lIEwdYOkHHUOmQ1StqcWjO6the0mXq4LH
         Qgq9WLh2fQJw6L8Jf7UIg4p64ZospwlVkayMERs9pYS2GuMupJEram5Q4BilE0tMA/
         nisK5/d0kEBST+yUjBfknYHT2v5BKwtDhsyUMU8OKC4xyMSahMO86wsh1xmNzvnlcR
         /fix+75z3CJxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/15] net/mlx5: Move table size calculation to steering cmd layer
Date:   Thu, 27 May 2021 11:56:18 -0700
Message-Id: <20210527185624.694304-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Currently the table size is calculated by the fs_core layer. However, each
steering cmd instance has a different allocation logic. FW steering uses
a predefined pools of multiple sizes. SW steering doesn't have a pool,
and can allocate any size of tables.

Move the table size calculation to the steering cmd layer as a pre-step
for moving fs_chains pool logic globally to firmware steering, and
increasing table sizes for software steering. In addition, change the
size parameter to absolute size to allow the special zero value to
mean "get next available maximum size".

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c       | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c      |  8 ++------
 .../net/ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  6 ++++--
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 8e06731d3cb3..94712a10ef9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -49,9 +49,11 @@ static int mlx5_cmd_stub_update_root_ft(struct mlx5_flow_root_namespace *ns,
 
 static int mlx5_cmd_stub_create_flow_table(struct mlx5_flow_root_namespace *ns,
 					   struct mlx5_flow_table *ft,
-					   unsigned int log_size,
+					   unsigned int size,
 					   struct mlx5_flow_table *next_ft)
 {
+	ft->max_fte = size ? roundup_pow_of_two(size) : 1;
+
 	return 0;
 }
 
@@ -181,7 +183,7 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 
 static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 				      struct mlx5_flow_table *ft,
-				      unsigned int log_size,
+				      unsigned int size,
 				      struct mlx5_flow_table *next_ft)
 {
 	int en_encap = !!(ft->flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
@@ -190,8 +192,12 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
+	unsigned int log_size = 0;
 	int err;
 
+	log_size = size ? ilog2(roundup_pow_of_two(size)) : 0;
+	ft->max_fte = 1 << log_size;
+
 	MLX5_SET(create_flow_table_in, in, opcode,
 		 MLX5_CMD_OP_CREATE_FLOW_TABLE);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
index d62de642eca9..c2e102ed82ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -38,7 +38,7 @@
 struct mlx5_flow_cmds {
 	int (*create_flow_table)(struct mlx5_flow_root_namespace *ns,
 				 struct mlx5_flow_table *ft,
-				 unsigned int log_size,
+				 unsigned int size,
 				 struct mlx5_flow_table *next_ft);
 	int (*destroy_flow_table)(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index f74d2c834037..378990c933e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -752,7 +752,7 @@ static struct mlx5_flow_group *alloc_insert_flow_group(struct mlx5_flow_table *f
 	return fg;
 }
 
-static struct mlx5_flow_table *alloc_flow_table(int level, u16 vport, int max_fte,
+static struct mlx5_flow_table *alloc_flow_table(int level, u16 vport,
 						enum fs_flow_table_type table_type,
 						enum fs_flow_table_op_mod op_mod,
 						u32 flags)
@@ -775,7 +775,6 @@ static struct mlx5_flow_table *alloc_flow_table(int level, u16 vport, int max_ft
 	ft->op_mod = op_mod;
 	ft->type = table_type;
 	ft->vport = vport;
-	ft->max_fte = max_fte;
 	ft->flags = flags;
 	INIT_LIST_HEAD(&ft->fwd_rules);
 	mutex_init(&ft->lock);
@@ -1070,7 +1069,6 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 	struct mlx5_flow_table *next_ft;
 	struct fs_prio *fs_prio = NULL;
 	struct mlx5_flow_table *ft;
-	int log_table_sz;
 	int err;
 
 	if (!root) {
@@ -1101,7 +1099,6 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 	 */
 	ft = alloc_flow_table(ft_attr->level,
 			      vport,
-			      ft_attr->max_fte ? roundup_pow_of_two(ft_attr->max_fte) : 0,
 			      root->table_type,
 			      op_mod, ft_attr->flags);
 	if (IS_ERR(ft)) {
@@ -1110,12 +1107,11 @@ static struct mlx5_flow_table *__mlx5_create_flow_table(struct mlx5_flow_namespa
 	}
 
 	tree_init_node(&ft->node, del_hw_flow_table, del_sw_flow_table);
-	log_table_sz = ft->max_fte ? ilog2(ft->max_fte) : 0;
 	next_ft = unmanaged ? ft_attr->next_ft :
 			      find_next_chained_ft(fs_prio);
 	ft->def_miss_action = ns->def_miss_action;
 	ft->ns = ns;
-	err = root->cmds->create_flow_table(root, ft, log_table_sz, next_ft);
+	err = root->cmds->create_flow_table(root, ft, ft_attr->max_fte, next_ft);
 	if (err)
 		goto free_ft;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 96c39a17d026..ee45d698cd9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -62,7 +62,7 @@ static int set_miss_action(struct mlx5_flow_root_namespace *ns,
 
 static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 					 struct mlx5_flow_table *ft,
-					 unsigned int log_size,
+					 unsigned int size,
 					 struct mlx5_flow_table *next_ft)
 {
 	struct mlx5dr_table *tbl;
@@ -71,7 +71,7 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 
 	if (mlx5_dr_is_fw_table(ft->flags))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
-								    log_size,
+								    size,
 								    next_ft);
 	flags = ft->flags;
 	/* turn off encap/decap if not supported for sw-str by fw */
@@ -97,6 +97,8 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 		}
 	}
 
+	ft->max_fte = size ? roundup_pow_of_two(size) : 1;
+
 	return 0;
 }
 
-- 
2.31.1

