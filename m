Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4924D3C3C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbiCIVj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbiCIVjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2127F76677
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E5F7B82020
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D1FC340EC;
        Wed,  9 Mar 2022 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861889;
        bh=XkvQBiZuQs0yXCYCSn8aUCDnxjqghW07EMWNXb/Gz3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLJtlS9krhmPE6vLRmOdNpujJ/Jy08izKkqZQUwa+sHUJ8qIfcmhyhhhxEt6pK2MI
         lFc6QinuD8mDSzqucn3DjVaivLLNIermt3uGSBpSo0reW2tFH3VMtwvFVG0dSBbQmr
         D7YIuRy79JsaIMW4yOuJxSJS9XYFty9OVe+St2hPtPRam2FS6nBnghqTHliIcgkmBd
         SoQ7w69A+sNLKlTDG1AoxumgPXuZszX4eTs2oFNZ7VHe3GHXnVOzRxvLmxkRG019IP
         cYVc/tcadXz2OJXeP7dHE1zcYua8zvJddaE6NDmg4w8eVJiPpP1Vtl0IRl3m/xQqZR
         hJG2USFNeBzIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5: Move debugfs entries to separate struct
Date:   Wed,  9 Mar 2022 13:37:46 -0800
Message-Id: <20220309213755.610202-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Move the debugfs entry pointers under priv to their own struct.
Add get function for device debugfs root.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cong.c             |  3 +-
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 drivers/infiniband/hw/mlx5/mr.c               |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 30 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  8 ++---
 .../mellanox/mlx5/core/steering/dr_dbg.c      |  2 +-
 include/linux/mlx5/driver.h                   | 17 ++++++-----
 8 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 0b61df52332a..290ea8ac3838 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -433,8 +433,7 @@ void mlx5_ib_init_cong_debugfs(struct mlx5_ib_dev *dev, u32 port_num)
 
 	dev->port[port_num].dbg_cc_params = dbg_cc_params;
 
-	dbg_cc_params->root = debugfs_create_dir("cc_params",
-						 mdev->priv.dbg_root);
+	dbg_cc_params->root = debugfs_create_dir("cc_params", mlx5_debugfs_get_dev_root(mdev));
 
 	for (i = 0; i < MLX5_IB_DBG_CC_MAX; i++) {
 		dbg_cc_params->params[i].offset = i;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 85f526c861e9..32a0ea820573 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4178,7 +4178,7 @@ static int mlx5_ib_stage_delay_drop_init(struct mlx5_ib_dev *dev)
 	if (!mlx5_debugfs_root)
 		return 0;
 
-	root = debugfs_create_dir("delay_drop", dev->mdev->priv.dbg_root);
+	root = debugfs_create_dir("delay_drop", mlx5_debugfs_get_dev_root(dev->mdev));
 	dev->delay_drop.dir_debugfs = root;
 
 	debugfs_create_atomic_t("num_timeout_events", 0400, root,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 06e4b8cea6bd..32cb7068f0ca 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -696,7 +696,7 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
 
-	cache->root = debugfs_create_dir("mr_cache", dev->mdev->priv.dbg_root);
+	cache->root = debugfs_create_dir("mr_cache", mlx5_debugfs_get_dev_root(dev->mdev));
 
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8933c00067e8..3b61224e9a3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1543,7 +1543,7 @@ static void create_debugfs_files(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd_debug *dbg = &dev->cmd.dbg;
 
-	dbg->dbg_root = debugfs_create_dir("cmd", dev->priv.dbg_root);
+	dbg->dbg_root = debugfs_create_dir("cmd", mlx5_debugfs_get_dev_root(dev));
 
 	debugfs_create_file("in", 0400, dbg->dbg_root, dev, &dfops);
 	debugfs_create_file("out", 0200, dbg->dbg_root, dev, &dfops);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 18b04e977bb8..883e44457367 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -99,26 +99,32 @@ void mlx5_unregister_debugfs(void)
 	debugfs_remove(mlx5_debugfs_root);
 }
 
+struct dentry *mlx5_debugfs_get_dev_root(struct mlx5_core_dev *dev)
+{
+	return dev->priv.dbg.dbg_root;
+}
+EXPORT_SYMBOL(mlx5_debugfs_get_dev_root);
+
 void mlx5_qp_debugfs_init(struct mlx5_core_dev *dev)
 {
-	dev->priv.qp_debugfs = debugfs_create_dir("QPs",  dev->priv.dbg_root);
+	dev->priv.dbg.qp_debugfs = debugfs_create_dir("QPs", dev->priv.dbg.dbg_root);
 }
 EXPORT_SYMBOL(mlx5_qp_debugfs_init);
 
 void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	debugfs_remove_recursive(dev->priv.qp_debugfs);
+	debugfs_remove_recursive(dev->priv.dbg.qp_debugfs);
 }
 EXPORT_SYMBOL(mlx5_qp_debugfs_cleanup);
 
 void mlx5_eq_debugfs_init(struct mlx5_core_dev *dev)
 {
-	dev->priv.eq_debugfs = debugfs_create_dir("EQs",  dev->priv.dbg_root);
+	dev->priv.dbg.eq_debugfs = debugfs_create_dir("EQs", dev->priv.dbg.dbg_root);
 }
 
 void mlx5_eq_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	debugfs_remove_recursive(dev->priv.eq_debugfs);
+	debugfs_remove_recursive(dev->priv.dbg.eq_debugfs);
 }
 
 static ssize_t average_read(struct file *filp, char __user *buf, size_t count,
@@ -168,8 +174,8 @@ void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 	const char *namep;
 	int i;
 
-	cmd = &dev->priv.cmdif_debugfs;
-	*cmd = debugfs_create_dir("commands", dev->priv.dbg_root);
+	cmd = &dev->priv.dbg.cmdif_debugfs;
+	*cmd = debugfs_create_dir("commands", dev->priv.dbg.dbg_root);
 
 	for (i = 0; i < MLX5_CMD_OP_MAX; i++) {
 		stats = &dev->cmd.stats[i];
@@ -193,17 +199,17 @@ void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 
 void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	debugfs_remove_recursive(dev->priv.cmdif_debugfs);
+	debugfs_remove_recursive(dev->priv.dbg.cmdif_debugfs);
 }
 
 void mlx5_cq_debugfs_init(struct mlx5_core_dev *dev)
 {
-	dev->priv.cq_debugfs = debugfs_create_dir("CQs",  dev->priv.dbg_root);
+	dev->priv.dbg.cq_debugfs = debugfs_create_dir("CQs", dev->priv.dbg.dbg_root);
 }
 
 void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 {
-	debugfs_remove_recursive(dev->priv.cq_debugfs);
+	debugfs_remove_recursive(dev->priv.dbg.cq_debugfs);
 }
 
 static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
@@ -448,7 +454,7 @@ int mlx5_debug_qp_add(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp)
 	if (!mlx5_debugfs_root)
 		return 0;
 
-	err = add_res_tree(dev, MLX5_DBG_RSC_QP, dev->priv.qp_debugfs,
+	err = add_res_tree(dev, MLX5_DBG_RSC_QP, dev->priv.dbg.qp_debugfs,
 			   &qp->dbg, qp->qpn, qp_fields,
 			   ARRAY_SIZE(qp_fields), qp);
 	if (err)
@@ -475,7 +481,7 @@ int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 	if (!mlx5_debugfs_root)
 		return 0;
 
-	err = add_res_tree(dev, MLX5_DBG_RSC_EQ, dev->priv.eq_debugfs,
+	err = add_res_tree(dev, MLX5_DBG_RSC_EQ, dev->priv.dbg.eq_debugfs,
 			   &eq->dbg, eq->eqn, eq_fields,
 			   ARRAY_SIZE(eq_fields), eq);
 	if (err)
@@ -500,7 +506,7 @@ int mlx5_debug_cq_add(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	if (!mlx5_debugfs_root)
 		return 0;
 
-	err = add_res_tree(dev, MLX5_DBG_RSC_CQ, dev->priv.cq_debugfs,
+	err = add_res_tree(dev, MLX5_DBG_RSC_CQ, dev->priv.dbg.cq_debugfs,
 			   &cq->dbg, cq->cqn, cq_fields,
 			   ARRAY_SIZE(cq_fields), cq);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 98be7050aa8d..d8d36477b97f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1487,8 +1487,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	INIT_LIST_HEAD(&priv->pgdir_list);
 
 	priv->numa_node = dev_to_node(mlx5_core_dma_dev(dev));
-	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
-					    mlx5_debugfs_root);
+	priv->dbg.dbg_root = debugfs_create_dir(dev_name(dev->device),
+						mlx5_debugfs_root);
 	INIT_LIST_HEAD(&priv->traps);
 
 	err = mlx5_tout_init(dev);
@@ -1524,7 +1524,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 err_health_init:
 	mlx5_tout_cleanup(dev);
 err_timeout_init:
-	debugfs_remove(dev->priv.dbg_root);
+	debugfs_remove(dev->priv.dbg.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
@@ -1542,7 +1542,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
 	mlx5_tout_cleanup(dev);
-	debugfs_remove_recursive(dev->priv.dbg_root);
+	debugfs_remove_recursive(dev->priv.dbg.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index 2784cd59fefe..2e8b109fb34e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -630,7 +630,7 @@ void mlx5dr_dbg_init_dump(struct mlx5dr_domain *dmn)
 	}
 
 	dmn->dump_info.steering_debugfs =
-		debugfs_create_dir("steering", dev->priv.dbg_root);
+		debugfs_create_dir("steering", mlx5_debugfs_get_dev_root(dev));
 	dmn->dump_info.fdb_debugfs =
 		debugfs_create_dir("fdb", dmn->dump_info.steering_debugfs);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f18c1e15a12c..aa539d245a12 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -551,6 +551,14 @@ struct mlx5_adev {
 	int idx;
 };
 
+struct mlx5_debugfs_entries {
+	struct dentry *dbg_root;
+	struct dentry *qp_debugfs;
+	struct dentry *eq_debugfs;
+	struct dentry *cq_debugfs;
+	struct dentry *cmdif_debugfs;
+};
+
 struct mlx5_ft_pool;
 struct mlx5_priv {
 	/* IRQ table valid only for real pci devices PF or VF */
@@ -570,12 +578,7 @@ struct mlx5_priv {
 	struct mlx5_core_health health;
 	struct list_head	traps;
 
-	/* start: qp staff */
-	struct dentry	       *qp_debugfs;
-	struct dentry	       *eq_debugfs;
-	struct dentry	       *cq_debugfs;
-	struct dentry	       *cmdif_debugfs;
-	/* end: qp staff */
+	struct mlx5_debugfs_entries dbg;
 
 	/* start: alloc staff */
 	/* protect buffer allocation according to numa node */
@@ -585,7 +588,6 @@ struct mlx5_priv {
 	struct mutex            pgdir_mutex;
 	struct list_head        pgdir_list;
 	/* end: alloc staff */
-	struct dentry	       *dbg_root;
 
 	struct list_head        ctx_list;
 	spinlock_t              ctx_lock;
@@ -1038,6 +1040,7 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn);
 int mlx5_core_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn);
 int mlx5_core_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn);
 
+struct dentry *mlx5_debugfs_get_dev_root(struct mlx5_core_dev *dev);
 void mlx5_qp_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_qp_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_access_reg(struct mlx5_core_dev *dev, void *data_in, int size_in,
-- 
2.35.1

