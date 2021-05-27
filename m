Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8057639267D
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhE0Ei0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhE0EiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E0F261003;
        Thu, 27 May 2021 04:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090197;
        bh=6A+Ob9Qp9rJ3GxEm/iWqL20rghU9FPxarZeUpHwBMTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9XyoQNF/sz142BqxAVgS0RMsh18OPowz7HMNUhXzmI04R9CrW7bDXVoITnd44D9V
         K+9Um3+mxP7FxIiWXv/BLbr0Ze2Hop64zao4rR1OUdOB8fiURRqd0iwpmw+j2Xk9G5
         M7Omw4xXVocgR2TT8Zb0vGTEoH9joswsYvJrv2YpkDiP7N7jS4CRjK0jWUYvhjym4D
         9Z3ZM5Dmv15vgC/DPQnjVdc4r80y2NSceIBIV80kfNopv4EBJt4Iipv1TVdaw+pBNg
         JeoFsfLe85kV8BfcL8ef83ne2Q5/M6UfsRHvo0M81kl1PUS8Ad+/dJ/er6eATECFEl
         ceGW8MLx4JeVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/17] net/mlx5: Move chains ft pool to be used by all firmware steering
Date:   Wed, 26 May 2021 21:36:02 -0700
Message-Id: <20210527043609.654854-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Firmware FT pool is per device, but the software tracking of this pool
only services fs_chains users, and if another layer takes a flow table,
the pool will not be updated, and fs_chains will fail creating a flow
table, with no recovery till the flow table is returned.

Move FT pool to be global per device, and stored at the cmd level,
so all layers can use it.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 25 ++++--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 27 ++++--
 .../ethernet/mellanox/mlx5/core/fs_ft_pool.c  | 83 +++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fs_ft_pool.h  | 21 +++++
 .../mellanox/mlx5/core/lib/fs_chains.c        | 89 ++-----------------
 include/linux/mlx5/driver.h                   |  2 +
 7 files changed, 151 insertions(+), 98 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index a1223e904190..8dbdf1aef00f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		health.o mcg.o cq.o alloc.o port.o mr.o pd.o \
 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o pci_irq.o \
-		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
+		fs_counters.o fs_ft_pool.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
 		fw_reset.o qos.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 94712a10ef9a..b7aae8b75760 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -36,6 +36,7 @@
 
 #include "fs_core.h"
 #include "fs_cmd.h"
+#include "fs_ft_pool.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
 
@@ -192,18 +193,20 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
-	unsigned int log_size = 0;
 	int err;
 
-	log_size = size ? ilog2(roundup_pow_of_two(size)) : 0;
-	ft->max_fte = 1 << log_size;
+	if (size != POOL_NEXT_SIZE)
+		size = roundup_pow_of_two(size);
+	size = mlx5_ft_pool_get_avail_sz(dev, ft->type, size);
+	if (!size)
+		return -ENOSPC;
 
 	MLX5_SET(create_flow_table_in, in, opcode,
 		 MLX5_CMD_OP_CREATE_FLOW_TABLE);
 
 	MLX5_SET(create_flow_table_in, in, table_type, ft->type);
 	MLX5_SET(create_flow_table_in, in, flow_table_context.level, ft->level);
-	MLX5_SET(create_flow_table_in, in, flow_table_context.log_size, log_size);
+	MLX5_SET(create_flow_table_in, in, flow_table_context.log_size, size ? ilog2(size) : 0);
 	MLX5_SET(create_flow_table_in, in, vport_number, ft->vport);
 	MLX5_SET(create_flow_table_in, in, other_vport,
 		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
@@ -240,9 +243,14 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	}
 
 	err = mlx5_cmd_exec_inout(dev, create_flow_table, in, out);
-	if (!err)
+	if (!err) {
 		ft->id = MLX5_GET(create_flow_table_out, out,
 				  table_id);
+		ft->max_fte = size;
+	} else {
+		mlx5_ft_pool_put_sz(ns->dev, size);
+	}
+
 	return err;
 }
 
@@ -251,6 +259,7 @@ static int mlx5_cmd_destroy_flow_table(struct mlx5_flow_root_namespace *ns,
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_flow_table_in)] = {};
 	struct mlx5_core_dev *dev = ns->dev;
+	int err;
 
 	MLX5_SET(destroy_flow_table_in, in, opcode,
 		 MLX5_CMD_OP_DESTROY_FLOW_TABLE);
@@ -260,7 +269,11 @@ static int mlx5_cmd_destroy_flow_table(struct mlx5_flow_root_namespace *ns,
 	MLX5_SET(destroy_flow_table_in, in, other_vport,
 		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
 
-	return mlx5_cmd_exec_in(dev, destroy_flow_table, in);
+	err = mlx5_cmd_exec_in(dev, destroy_flow_table, in);
+	if (!err)
+		mlx5_ft_pool_put_sz(ns->dev, ft->max_fte);
+
+	return err;
 }
 
 static int mlx5_cmd_modify_flow_table(struct mlx5_flow_root_namespace *ns,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 378990c933e5..6e20cbb4656a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -38,6 +38,7 @@
 #include "mlx5_core.h"
 #include "fs_core.h"
 #include "fs_cmd.h"
+#include "fs_ft_pool.h"
 #include "diag/fs_tracepoint.h"
 #include "accel/ipsec.h"
 #include "fpga/ipsec.h"
@@ -1166,6 +1167,8 @@ mlx5_create_lag_demux_flow_table(struct mlx5_flow_namespace *ns,
 
 	ft_attr.level = level;
 	ft_attr.prio  = prio;
+	ft_attr.max_fte = 1;
+
 	return __mlx5_create_flow_table(ns, &ft_attr, FS_FT_OP_MOD_LAG_DEMUX, 0);
 }
 EXPORT_SYMBOL(mlx5_create_lag_demux_flow_table);
@@ -1175,19 +1178,20 @@ mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
 				    struct mlx5_flow_table_attr *ft_attr)
 {
 	int num_reserved_entries = ft_attr->autogroup.num_reserved_entries;
-	int autogroups_max_fte = ft_attr->max_fte - num_reserved_entries;
 	int max_num_groups = ft_attr->autogroup.max_num_groups;
 	struct mlx5_flow_table *ft;
-
-	if (max_num_groups > autogroups_max_fte)
-		return ERR_PTR(-EINVAL);
-	if (num_reserved_entries > ft_attr->max_fte)
-		return ERR_PTR(-EINVAL);
+	int autogroups_max_fte;
 
 	ft = mlx5_create_flow_table(ns, ft_attr);
 	if (IS_ERR(ft))
 		return ft;
 
+	autogroups_max_fte = ft->max_fte - num_reserved_entries;
+	if (max_num_groups > autogroups_max_fte)
+		goto err_validate;
+	if (num_reserved_entries > ft->max_fte)
+		goto err_validate;
+
 	ft->autogroup.active = true;
 	ft->autogroup.required_groups = max_num_groups;
 	ft->autogroup.max_fte = autogroups_max_fte;
@@ -1195,6 +1199,10 @@ mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
 	ft->autogroup.group_size = autogroups_max_fte / (max_num_groups + 1);
 
 	return ft;
+
+err_validate:
+	mlx5_destroy_flow_table(ft);
+	return ERR_PTR(-ENOSPC);
 }
 EXPORT_SYMBOL(mlx5_create_auto_grouped_flow_table);
 
@@ -2588,6 +2596,7 @@ void mlx5_cleanup_fs(struct mlx5_core_dev *dev)
 	mlx5_cleanup_fc_stats(dev);
 	kmem_cache_destroy(steering->ftes_cache);
 	kmem_cache_destroy(steering->fgs_cache);
+	mlx5_ft_pool_destroy(dev);
 	kfree(steering);
 }
 
@@ -2938,9 +2947,13 @@ int mlx5_init_fs(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
+	err = mlx5_ft_pool_init(dev);
+	if (err)
+		return err;
+
 	steering = kzalloc(sizeof(*steering), GFP_KERNEL);
 	if (!steering)
-		return -ENOMEM;
+		goto err;
 	steering->dev = dev;
 	dev->priv.steering = steering;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
new file mode 100644
index 000000000000..526fbb669142
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include "fs_ft_pool.h"
+
+/* Firmware currently has 4 pool of 4 sizes that it supports (FT_POOLS),
+ * and a virtual memory region of 16M (MLX5_FT_SIZE), this region is duplicated
+ * for each flow table pool. We can allocate up to 16M of each pool,
+ * and we keep track of how much we used via mlx5_ft_pool_get_avail_sz.
+ * Firmware doesn't report any of this for now.
+ * ESW_POOL is expected to be sorted from large to small and match firmware
+ * pools.
+ */
+#define FT_SIZE (16 * 1024 * 1024)
+static const unsigned int FT_POOLS[] = { 4 * 1024 * 1024,
+					 1 * 1024 * 1024,
+					 64 * 1024,
+					 128,
+					 1 /* size for termination tables */ };
+struct mlx5_ft_pool {
+	int ft_left[ARRAY_SIZE(FT_POOLS)];
+};
+
+int mlx5_ft_pool_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_ft_pool *ft_pool;
+	int i;
+
+	ft_pool = kzalloc(sizeof(*ft_pool), GFP_KERNEL);
+
+	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
+		ft_pool->ft_left[i] = FT_SIZE / FT_POOLS[i];
+
+	dev->priv.ft_pool = ft_pool;
+	return 0;
+}
+
+void mlx5_ft_pool_destroy(struct mlx5_core_dev *dev)
+{
+	kfree(dev->priv.ft_pool);
+}
+
+int
+mlx5_ft_pool_get_avail_sz(struct mlx5_core_dev *dev, enum fs_flow_table_type table_type,
+			  int desired_size)
+{
+	u32 max_ft_size = 1 << MLX5_CAP_FLOWTABLE_TYPE(dev, log_max_ft_size, table_type);
+	int i, found_i = -1;
+
+	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
+		if (dev->priv.ft_pool->ft_left[i] && FT_POOLS[i] >= desired_size &&
+		    FT_POOLS[i] <= max_ft_size) {
+			found_i = i;
+			if (desired_size != POOL_NEXT_SIZE)
+				break;
+		}
+	}
+
+	if (found_i != -1) {
+		--dev->priv.ft_pool->ft_left[found_i];
+		return FT_POOLS[found_i];
+	}
+
+	return 0;
+}
+
+void
+mlx5_ft_pool_put_sz(struct mlx5_core_dev *dev, int sz)
+{
+	int i;
+
+	if (!sz)
+		return;
+
+	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
+		if (sz == FT_POOLS[i]) {
+			++dev->priv.ft_pool->ft_left[i];
+			return;
+		}
+	}
+
+	WARN_ONCE(1, "Couldn't find size %d in flow table size pool", sz);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
new file mode 100644
index 000000000000..25f4274b372b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_FS_FT_POOL_H__
+#define __MLX5_FS_FT_POOL_H__
+
+#include <linux/mlx5/driver.h>
+#include "fs_core.h"
+
+#define POOL_NEXT_SIZE 0
+
+int mlx5_ft_pool_init(struct mlx5_core_dev *dev);
+void mlx5_ft_pool_destroy(struct mlx5_core_dev *dev);
+
+int
+mlx5_ft_pool_get_avail_sz(struct mlx5_core_dev *dev, enum fs_flow_table_type table_type,
+			  int desired_size);
+void
+mlx5_ft_pool_put_sz(struct mlx5_core_dev *dev, int sz);
+
+#endif /* __MLX5_FS_FT_POOL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 4c60c540bf9d..d0cfe7adb8a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -6,6 +6,7 @@
 #include <linux/mlx5/fs.h>
 
 #include "lib/fs_chains.h"
+#include "fs_ft_pool.h"
 #include "en/mapping.h"
 #include "fs_core.h"
 #include "en_tc.h"
@@ -13,25 +14,10 @@
 #define chains_lock(chains) ((chains)->lock)
 #define chains_ht(chains) ((chains)->chains_ht)
 #define prios_ht(chains) ((chains)->prios_ht)
-#define ft_pool_left(chains) ((chains)->ft_left)
 #define tc_default_ft(chains) ((chains)->tc_default_ft)
 #define tc_end_ft(chains) ((chains)->tc_end_ft)
 #define ns_to_chains_fs_prio(ns) ((ns) == MLX5_FLOW_NAMESPACE_FDB ? \
 				  FDB_TC_OFFLOAD : MLX5E_TC_PRIO)
-
-/* Firmware currently has 4 pool of 4 sizes that it supports (FT_POOLS),
- * and a virtual memory region of 16M (MLX5_FT_SIZE), this region is duplicated
- * for each flow table pool. We can allocate up to 16M of each pool,
- * and we keep track of how much we used via get_next_avail_sz_from_pool.
- * Firmware doesn't report any of this for now.
- * ESW_POOL is expected to be sorted from large to small and match firmware
- * pools.
- */
-#define FT_SIZE (16 * 1024 * 1024)
-static const unsigned int FT_POOLS[] = { 4 * 1024 * 1024,
-					  1 * 1024 * 1024,
-					  64 * 1024,
-					  128 };
 #define FT_TBL_SZ (64 * 1024)
 
 struct mlx5_fs_chains {
@@ -49,8 +35,6 @@ struct mlx5_fs_chains {
 	enum mlx5_flow_namespace_type ns;
 	u32 group_num;
 	u32 flags;
-
-	int ft_left[ARRAY_SIZE(FT_POOLS)];
 };
 
 struct fs_chain {
@@ -160,54 +144,6 @@ mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
 	tc_end_ft(chains) = ft;
 }
 
-#define POOL_NEXT_SIZE 0
-static int
-mlx5_chains_get_avail_sz_from_pool(struct mlx5_fs_chains *chains,
-				   int desired_size)
-{
-	int i, found_i = -1;
-
-	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
-		if (ft_pool_left(chains)[i] && FT_POOLS[i] > desired_size) {
-			found_i = i;
-			if (desired_size != POOL_NEXT_SIZE)
-				break;
-		}
-	}
-
-	if (found_i != -1) {
-		--ft_pool_left(chains)[found_i];
-		return FT_POOLS[found_i];
-	}
-
-	return 0;
-}
-
-static void
-mlx5_chains_put_sz_to_pool(struct mlx5_fs_chains *chains, int sz)
-{
-	int i;
-
-	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
-		if (sz == FT_POOLS[i]) {
-			++ft_pool_left(chains)[i];
-			return;
-		}
-	}
-
-	WARN_ONCE(1, "Couldn't find size %d in flow table size pool", sz);
-}
-
-static void
-mlx5_chains_init_sz_pool(struct mlx5_fs_chains *chains, u32 ft_max)
-{
-	int i;
-
-	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
-		ft_pool_left(chains)[i] =
-			FT_POOLS[i] <= ft_max ? FT_SIZE / FT_POOLS[i] : 0;
-}
-
 static struct mlx5_flow_table *
 mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 			 u32 chain, u32 prio, u32 level)
@@ -221,11 +157,7 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	sz = (chain == mlx5_chains_get_nf_ft_chain(chains)) ?
-	     mlx5_chains_get_avail_sz_from_pool(chains, FT_TBL_SZ) :
-	     mlx5_chains_get_avail_sz_from_pool(chains, POOL_NEXT_SIZE);
-	if (!sz)
-		return ERR_PTR(-ENOSPC);
+	sz = (chain == mlx5_chains_get_nf_ft_chain(chains)) ? FT_TBL_SZ : POOL_NEXT_SIZE;
 	ft_attr.max_fte = sz;
 
 	/* We use tc_default_ft(chains) as the table's next_ft till
@@ -266,21 +198,12 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 	if (IS_ERR(ft)) {
 		mlx5_core_warn(chains->dev, "Failed to create chains table err %d (chain: %d, prio: %d, level: %d, size: %d)\n",
 			       (int)PTR_ERR(ft), chain, prio, level, sz);
-		mlx5_chains_put_sz_to_pool(chains, sz);
 		return ft;
 	}
 
 	return ft;
 }
 
-static void
-mlx5_chains_destroy_table(struct mlx5_fs_chains *chains,
-			  struct mlx5_flow_table *ft)
-{
-	mlx5_chains_put_sz_to_pool(chains, ft->max_fte);
-	mlx5_destroy_flow_table(ft);
-}
-
 static int
 create_chain_restore(struct fs_chain *chain)
 {
@@ -637,7 +560,7 @@ mlx5_chains_create_prio(struct mlx5_fs_chains *chains,
 err_miss_rule:
 	mlx5_destroy_flow_group(miss_group);
 err_group:
-	mlx5_chains_destroy_table(chains, ft);
+	mlx5_destroy_flow_table(ft);
 err_create:
 err_alloc:
 	kvfree(prio_s);
@@ -660,7 +583,7 @@ mlx5_chains_destroy_prio(struct mlx5_fs_chains *chains,
 			       prio_params);
 	mlx5_del_flow_rules(prio->miss_rule);
 	mlx5_destroy_flow_group(prio->miss_group);
-	mlx5_chains_destroy_table(chains, prio->ft);
+	mlx5_destroy_flow_table(prio->ft);
 	mlx5_chains_put_chain(chain);
 	kvfree(prio);
 }
@@ -785,7 +708,7 @@ void
 mlx5_chains_destroy_global_table(struct mlx5_fs_chains *chains,
 				 struct mlx5_flow_table *ft)
 {
-	mlx5_chains_destroy_table(chains, ft);
+	mlx5_destroy_flow_table(ft);
 }
 
 static struct mlx5_fs_chains *
@@ -817,8 +740,6 @@ mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 		       mlx5_chains_get_chain_range(chains_priv),
 		       mlx5_chains_get_prio_range(chains_priv));
 
-	mlx5_chains_init_sz_pool(chains_priv, attr->max_ft_sz);
-
 	err = rhashtable_init(&chains_ht(chains_priv), &chain_params);
 	if (err)
 		goto init_chains_ht_err;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f8e8d7e90616..6a7749c21b82 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -550,6 +550,7 @@ struct mlx5_adev {
 	int idx;
 };
 
+struct mlx5_ft_pool;
 struct mlx5_priv {
 	/* IRQ table valid only for real pci devices PF or VF */
 	struct mlx5_irq_table   *irq_table;
@@ -602,6 +603,7 @@ struct mlx5_priv {
 	struct mlx5_core_roce	roce;
 	struct mlx5_fc_stats		fc_stats;
 	struct mlx5_rl_table            rl_table;
+	struct mlx5_ft_pool		*ft_pool;
 
 	struct mlx5_bfreg_data		bfregs;
 	struct mlx5_uars_page	       *uar;
-- 
2.31.1

