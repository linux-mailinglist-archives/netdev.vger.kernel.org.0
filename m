Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267E583679
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387845AbfHFQMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbfHFQMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:12:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E57216B7;
        Tue,  6 Aug 2019 16:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565107924;
        bh=3I4O8nhiO43P8QxEjFGZHZedb97kqr6oBTdXFS4CF6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bChjrLnjK+tvGVVO+Vuujz0ArhsIsqY9WRolY/nvXcg76zBM44xdJ4W84Q73DEJRb
         B7D7YZ6TV+tIkaf1KGJcfx85KMSMc3+E2KCJoUdWcspxvOKqNYF2nGRJwx8Bi3dANO
         XvhVmiHn/aUtj3b7K2f1LsuafpsUvnZkeLZCkMoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 03/17] mlx5: no need to check return value of debugfs_create functions
Date:   Tue,  6 Aug 2019 18:11:14 +0200
Message-Id: <20190806161128.31232-4-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806161128.31232-1-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

This cleans up a lot of unneeded code and logic around the debugfs
files, making all of this much simpler and easier to understand as we
don't need to keep the dentries saved anymore.

Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  51 ++-------
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 102 ++----------------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 include/linux/mlx5/driver.h                   |  12 +--
 7 files changed, 24 insertions(+), 163 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8cdd7e66f8df..973f90888b1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1368,49 +1368,19 @@ static void clean_debug_files(struct mlx5_core_dev *dev)
 	debugfs_remove_recursive(dbg->dbg_root);
 }
 
-static int create_debugfs_files(struct mlx5_core_dev *dev)
+static void create_debugfs_files(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_debug *dbg = &dev->cmd.dbg;
-	int err = -ENOMEM;
-
-	if (!mlx5_debugfs_root)
-		return 0;
 
 	dbg->dbg_root = debugfs_create_dir("cmd", dev->priv.dbg_root);
-	if (!dbg->dbg_root)
-		return err;
-
-	dbg->dbg_in = debugfs_create_file("in", 0400, dbg->dbg_root,
-					  dev, &dfops);
-	if (!dbg->dbg_in)
-		goto err_dbg;
 
-	dbg->dbg_out = debugfs_create_file("out", 0200, dbg->dbg_root,
-					   dev, &dfops);
-	if (!dbg->dbg_out)
-		goto err_dbg;
-
-	dbg->dbg_outlen = debugfs_create_file("out_len", 0600, dbg->dbg_root,
-					      dev, &olfops);
-	if (!dbg->dbg_outlen)
-		goto err_dbg;
-
-	dbg->dbg_status = debugfs_create_u8("status", 0600, dbg->dbg_root,
-					    &dbg->status);
-	if (!dbg->dbg_status)
-		goto err_dbg;
-
-	dbg->dbg_run = debugfs_create_file("run", 0200, dbg->dbg_root, dev, &fops);
-	if (!dbg->dbg_run)
-		goto err_dbg;
+	debugfs_create_file("in", 0400, dbg->dbg_root, dev, &dfops);
+	debugfs_create_file("out", 0200, dbg->dbg_root, dev, &dfops);
+	debugfs_create_file("out_len", 0600, dbg->dbg_root, dev, &olfops);
+	debugfs_create_u8("status", 0600, dbg->dbg_root, &dbg->status);
+	debugfs_create_file("run", 0200, dbg->dbg_root, dev, &fops);
 
 	mlx5_cmdif_debugfs_init(dev);
-
-	return 0;
-
-err_dbg:
-	clean_debug_files(dev);
-	return err;
 }
 
 static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
@@ -2007,17 +1977,10 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 		goto err_cache;
 	}
 
-	err = create_debugfs_files(dev);
-	if (err) {
-		err = -ENOMEM;
-		goto err_wq;
-	}
+	create_debugfs_files(dev);
 
 	return 0;
 
-err_wq:
-	destroy_workqueue(cmd->wq);
-
 err_cache:
 	destroy_msg_cache(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index a11e22d0b0cc..04854e5fbcd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -92,8 +92,6 @@ EXPORT_SYMBOL(mlx5_debugfs_root);
 void mlx5_register_debugfs(void)
 {
 	mlx5_debugfs_root = debugfs_create_dir("mlx5", NULL);
-	if (IS_ERR_OR_NULL(mlx5_debugfs_root))
-		mlx5_debugfs_root = NULL;
 }
 
 void mlx5_unregister_debugfs(void)
@@ -101,45 +99,25 @@ void mlx5_unregister_debugfs(void)
 	debugfs_remove(mlx5_debugfs_root);
 }
 
-int mlx5_qp_debugfs_init(struct mlx5_core_dev *dev)
+void mlx5_qp_debugfs_init(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return 0;
-
 	atomic_set(&dev->num_qps, 0);
 
 	dev->priv.qp_debugfs = debugfs_create_dir("QPs",  dev->priv.dbg_root);
-	if (!dev->priv.qp_debugfs)
-		return -ENOMEM;
-
-	return 0;
 }
 
 void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return;
-
 	debugfs_remove_recursive(dev->priv.qp_debugfs);
 }
 
-int mlx5_eq_debugfs_init(struct mlx5_core_dev *dev)
+void mlx5_eq_debugfs_init(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return 0;
-
 	dev->priv.eq_debugfs = debugfs_create_dir("EQs",  dev->priv.dbg_root);
-	if (!dev->priv.eq_debugfs)
-		return -ENOMEM;
-
-	return 0;
 }
 
 void mlx5_eq_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return;
-
 	debugfs_remove_recursive(dev->priv.eq_debugfs);
 }
 
@@ -183,85 +161,41 @@ static const struct file_operations stats_fops = {
 	.write	= average_write,
 };
 
-int mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
+void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_stats *stats;
 	struct dentry **cmd;
 	const char *namep;
-	int err;
 	int i;
 
-	if (!mlx5_debugfs_root)
-		return 0;
-
 	cmd = &dev->priv.cmdif_debugfs;
 	*cmd = debugfs_create_dir("commands", dev->priv.dbg_root);
-	if (!*cmd)
-		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(dev->cmd.stats); i++) {
 		stats = &dev->cmd.stats[i];
 		namep = mlx5_command_str(i);
 		if (strcmp(namep, "unknown command opcode")) {
 			stats->root = debugfs_create_dir(namep, *cmd);
-			if (!stats->root) {
-				mlx5_core_warn(dev, "failed adding command %d\n",
-					       i);
-				err = -ENOMEM;
-				goto out;
-			}
-
-			stats->avg = debugfs_create_file("average", 0400,
-							 stats->root, stats,
-							 &stats_fops);
-			if (!stats->avg) {
-				mlx5_core_warn(dev, "failed creating debugfs file\n");
-				err = -ENOMEM;
-				goto out;
-			}
-
-			stats->count = debugfs_create_u64("n", 0400,
-							  stats->root,
-							  &stats->n);
-			if (!stats->count) {
-				mlx5_core_warn(dev, "failed creating debugfs file\n");
-				err = -ENOMEM;
-				goto out;
-			}
+
+			debugfs_create_file("average", 0400, stats->root, stats,
+					    &stats_fops);
+			debugfs_create_u64("n", 0400, stats->root, &stats->n);
 		}
 	}
-
-	return 0;
-out:
-	debugfs_remove_recursive(dev->priv.cmdif_debugfs);
-	return err;
 }
 
 void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return;
-
 	debugfs_remove_recursive(dev->priv.cmdif_debugfs);
 }
 
-int mlx5_cq_debugfs_init(struct mlx5_core_dev *dev)
+void mlx5_cq_debugfs_init(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return 0;
-
 	dev->priv.cq_debugfs = debugfs_create_dir("CQs",  dev->priv.dbg_root);
-	if (!dev->priv.cq_debugfs)
-		return -ENOMEM;
-
-	return 0;
 }
 
 void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	if (!mlx5_debugfs_root)
-		return;
-
 	debugfs_remove_recursive(dev->priv.cq_debugfs);
 }
 
@@ -484,7 +418,6 @@ static int add_res_tree(struct mlx5_core_dev *dev, enum dbg_rsc_type type,
 {
 	struct mlx5_rsc_debug *d;
 	char resn[32];
-	int err;
 	int i;
 
 	d = kzalloc(struct_size(d, fields, nfile), GFP_KERNEL);
@@ -496,30 +429,15 @@ static int add_res_tree(struct mlx5_core_dev *dev, enum dbg_rsc_type type,
 	d->type = type;
 	sprintf(resn, "0x%x", rsn);
 	d->root = debugfs_create_dir(resn,  root);
-	if (!d->root) {
-		err = -ENOMEM;
-		goto out_free;
-	}
 
 	for (i = 0; i < nfile; i++) {
 		d->fields[i].i = i;
-		d->fields[i].dent = debugfs_create_file(field[i], 0400,
-							d->root, &d->fields[i],
-							&fops);
-		if (!d->fields[i].dent) {
-			err = -ENOMEM;
-			goto out_rem;
-		}
+		debugfs_create_file(field[i], 0400, d->root, &d->fields[i],
+				    &fops);
 	}
 	*dbg = d;
 
 	return 0;
-out_rem:
-	debugfs_remove_recursive(d->root);
-
-out_free:
-	kfree(d);
-	return err;
 }
 
 static void rem_res_tree(struct mlx5_rsc_debug *d)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 2df9aaa421c6..09d4c64b6e73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -411,7 +411,7 @@ void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table;
-	int i, err;
+	int i;
 
 	eq_table = kvzalloc(sizeof(*eq_table), GFP_KERNEL);
 	if (!eq_table)
@@ -419,9 +419,7 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 
 	dev->priv.eq_table = eq_table;
 
-	err = mlx5_eq_debugfs_init(dev);
-	if (err)
-		goto kvfree_eq_table;
+	mlx5_eq_debugfs_init(dev);
 
 	mutex_init(&eq_table->lock);
 	for (i = 0; i < MLX5_EVENT_TYPE_MAX; i++)
@@ -429,11 +427,6 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 
 	eq_table->irq_table = dev->priv.irq_table;
 	return 0;
-
-kvfree_eq_table:
-	kvfree(eq_table);
-	dev->priv.eq_table = NULL;
-	return err;
 }
 
 void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 3dfab91ae5f2..4be4d2d36218 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -87,7 +87,7 @@ void mlx5_eq_synchronize_cmd_irq(struct mlx5_core_dev *dev);
 
 int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
 void mlx5_debug_eq_remove(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
-int mlx5_eq_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_eq_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_eq_debugfs_cleanup(struct mlx5_core_dev *dev);
 
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index fa0e991f1983..0b70b1d6338d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -826,11 +826,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eq_cleanup;
 	}
 
-	err = mlx5_cq_debugfs_init(dev);
-	if (err) {
-		mlx5_core_err(dev, "failed to initialize cq debugfs\n");
-		goto err_events_cleanup;
-	}
+	mlx5_cq_debugfs_init(dev);
 
 	mlx5_init_qp_table(dev);
 
@@ -891,7 +887,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_mkey_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
-err_events_cleanup:
 	mlx5_events_cleanup(dev);
 err_eq_cleanup:
 	mlx5_eq_table_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 471bbc48bc1f..87b75b2207c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -146,7 +146,7 @@ u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev,
 
 void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev);
 void mlx5_cmd_flush(struct mlx5_core_dev *dev);
-int mlx5_cq_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_cq_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev);
 
 int mlx5_query_pcam_reg(struct mlx5_core_dev *dev, u32 *pcam, u8 feature_group,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d8f348ef9c33..df23f17eed64 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -189,7 +189,6 @@ enum mlx5_coredev_type {
 };
 
 struct mlx5_field_desc {
-	struct dentry	       *dent;
 	int			i;
 };
 
@@ -242,11 +241,6 @@ struct mlx5_cmd_msg {
 
 struct mlx5_cmd_debug {
 	struct dentry	       *dbg_root;
-	struct dentry	       *dbg_in;
-	struct dentry	       *dbg_out;
-	struct dentry	       *dbg_outlen;
-	struct dentry	       *dbg_status;
-	struct dentry	       *dbg_run;
 	void		       *in_msg;
 	void		       *out_msg;
 	u8			status;
@@ -271,8 +265,6 @@ struct mlx5_cmd_stats {
 	u64		sum;
 	u64		n;
 	struct dentry  *root;
-	struct dentry  *avg;
-	struct dentry  *count;
 	/* protect command average calculations */
 	spinlock_t	lock;
 };
@@ -972,7 +964,7 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 int mlx5_core_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn);
 int mlx5_core_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn);
 
-int mlx5_qp_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_qp_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
 			 int size_in, void *data_out, int size_out,
@@ -984,7 +976,7 @@ int mlx5_db_alloc_node(struct mlx5_core_dev *dev, struct mlx5_db *db,
 void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db);
 
 const char *mlx5_command_str(int command);
-int mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index);
-- 
2.22.0

