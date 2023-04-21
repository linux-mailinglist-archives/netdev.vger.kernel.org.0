Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAB86EA11B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjDUBjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbjDUBj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7419C5FE0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD1E64202
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1976C433D2;
        Fri, 21 Apr 2023 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041164;
        bh=X/WQtHfUxsmIpy9Y6qwjNWzs6KNqVL56sO2klxg8in4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFUUgSZKf/rNWxPLAl322n8vAwsTYhqUCA/v2U96B6zq5/QzlW0sV/iVny6lllWS4
         SQGemMx6Rv+JWJmESxNWrx17N/LsFQUP3OSL+x15OT42PinTOrCSIIZdwUrQLBRLrT
         qFrQyF7rpEFe0g5EPgU6eH7RICOqeKp79sPGpA2lp/Q5OjbfbdAyDbXzZ7Bje957M2
         684UvrUTAgeb56bTsnsvWrhOyMRcv98DvQIZuPo3vrmreswWOvFY7dOlc9vVFHhf7B
         NObjJcWx4L/qJoTm7G/ShZJxg97TtIm1SqgCps8uwc6pdiWJ3UmY5NS9R/ibiE9TaX
         S/CygJh5TBvfA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>
Subject: [net-next 06/15] Revert "net/mlx5: Expose vnic diagnostic counters for eswitch managed vports"
Date:   Thu, 20 Apr 2023 18:38:41 -0700
Message-Id: <20230421013850.349646-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

This reverts commit 606e6a72e29dff9e3341c4cc9b554420e4793f401 which exposes
the vnic diagnostic counters via debugfs. Instead, The upcoming series will
expose the same counters through devlink health reporter.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/esw/debugfs.c | 182 ------------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   6 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 -
 .../mellanox/mlx5/core/eswitch_offloads.c     |   3 -
 5 files changed, 1 insertion(+), 197 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index ca3c66cd47ec..68f6a4544f7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -69,7 +69,7 @@ mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
 				      ecpf.o rdma.o esw/legacy.o \
-				      esw/debugfs.o esw/devlink_port.o esw/vporttbl.o esw/qos.o
+				      esw/devlink_port.o esw/vporttbl.o esw/qos.o
 
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
deleted file mode 100644
index 2db13c71e88c..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
+++ /dev/null
@@ -1,182 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
-
-#include <linux/debugfs.h>
-#include "eswitch.h"
-
-enum vnic_diag_counter {
-	MLX5_VNIC_DIAG_TOTAL_Q_UNDER_PROCESSOR_HANDLE,
-	MLX5_VNIC_DIAG_SEND_QUEUE_PRIORITY_UPDATE_FLOW,
-	MLX5_VNIC_DIAG_COMP_EQ_OVERRUN,
-	MLX5_VNIC_DIAG_ASYNC_EQ_OVERRUN,
-	MLX5_VNIC_DIAG_CQ_OVERRUN,
-	MLX5_VNIC_DIAG_INVALID_COMMAND,
-	MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND,
-};
-
-static int mlx5_esw_query_vnic_diag(struct mlx5_vport *vport, enum vnic_diag_counter counter,
-				    u32 *val)
-{
-	u32 out[MLX5_ST_SZ_DW(query_vnic_env_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
-	struct mlx5_core_dev *dev = vport->dev;
-	u16 vport_num = vport->vport;
-	void *vnic_diag_out;
-	int err;
-
-	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
-	MLX5_SET(query_vnic_env_in, in, vport_number, vport_num);
-	if (!mlx5_esw_is_manager_vport(dev->priv.eswitch, vport_num))
-		MLX5_SET(query_vnic_env_in, in, other_vport, 1);
-
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (err)
-		return err;
-
-	vnic_diag_out = MLX5_ADDR_OF(query_vnic_env_out, out, vport_env);
-	switch (counter) {
-	case MLX5_VNIC_DIAG_TOTAL_Q_UNDER_PROCESSOR_HANDLE:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, total_error_queues);
-		break;
-	case MLX5_VNIC_DIAG_SEND_QUEUE_PRIORITY_UPDATE_FLOW:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out,
-				send_queue_priority_update_flow);
-		break;
-	case MLX5_VNIC_DIAG_COMP_EQ_OVERRUN:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, comp_eq_overrun);
-		break;
-	case MLX5_VNIC_DIAG_ASYNC_EQ_OVERRUN:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, async_eq_overrun);
-		break;
-	case MLX5_VNIC_DIAG_CQ_OVERRUN:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, cq_overrun);
-		break;
-	case MLX5_VNIC_DIAG_INVALID_COMMAND:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, invalid_command);
-		break;
-	case MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND:
-		*val = MLX5_GET(vnic_diagnostic_statistics, vnic_diag_out, quota_exceeded_command);
-		break;
-	}
-
-	return 0;
-}
-
-static int __show_vnic_diag(struct seq_file *file, struct mlx5_vport *vport,
-			    enum vnic_diag_counter type)
-{
-	u32 val = 0;
-	int ret;
-
-	ret = mlx5_esw_query_vnic_diag(vport, type, &val);
-	if (ret)
-		return ret;
-
-	seq_printf(file, "%d\n", val);
-	return 0;
-}
-
-static int total_q_under_processor_handle_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_TOTAL_Q_UNDER_PROCESSOR_HANDLE);
-}
-
-static int send_queue_priority_update_flow_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private,
-				MLX5_VNIC_DIAG_SEND_QUEUE_PRIORITY_UPDATE_FLOW);
-}
-
-static int comp_eq_overrun_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_COMP_EQ_OVERRUN);
-}
-
-static int async_eq_overrun_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_ASYNC_EQ_OVERRUN);
-}
-
-static int cq_overrun_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_CQ_OVERRUN);
-}
-
-static int invalid_command_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_INVALID_COMMAND);
-}
-
-static int quota_exceeded_command_show(struct seq_file *file, void *priv)
-{
-	return __show_vnic_diag(file, file->private, MLX5_VNIC_DIAG_QOUTA_EXCEEDED_COMMAND);
-}
-
-DEFINE_SHOW_ATTRIBUTE(total_q_under_processor_handle);
-DEFINE_SHOW_ATTRIBUTE(send_queue_priority_update_flow);
-DEFINE_SHOW_ATTRIBUTE(comp_eq_overrun);
-DEFINE_SHOW_ATTRIBUTE(async_eq_overrun);
-DEFINE_SHOW_ATTRIBUTE(cq_overrun);
-DEFINE_SHOW_ATTRIBUTE(invalid_command);
-DEFINE_SHOW_ATTRIBUTE(quota_exceeded_command);
-
-void mlx5_esw_vport_debugfs_destroy(struct mlx5_eswitch *esw, u16 vport_num)
-{
-	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
-
-	debugfs_remove_recursive(vport->dbgfs);
-	vport->dbgfs = NULL;
-}
-
-/* vnic diag dir name is "pf", "ecpf" or "{vf/sf}_xxxx" */
-#define VNIC_DIAG_DIR_NAME_MAX_LEN 8
-
-void mlx5_esw_vport_debugfs_create(struct mlx5_eswitch *esw, u16 vport_num, bool is_sf, u16 sf_num)
-{
-	struct mlx5_vport *vport = mlx5_eswitch_get_vport(esw, vport_num);
-	struct dentry *vnic_diag;
-	char dir_name[VNIC_DIAG_DIR_NAME_MAX_LEN];
-	int err;
-
-	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager))
-		return;
-
-	if (vport_num == MLX5_VPORT_PF) {
-		strcpy(dir_name, "pf");
-	} else if (vport_num == MLX5_VPORT_ECPF) {
-		strcpy(dir_name, "ecpf");
-	} else {
-		err = snprintf(dir_name, VNIC_DIAG_DIR_NAME_MAX_LEN, "%s_%d", is_sf ? "sf" : "vf",
-			       is_sf ? sf_num : vport_num - MLX5_VPORT_FIRST_VF);
-		if (WARN_ON(err < 0))
-			return;
-	}
-
-	vport->dbgfs = debugfs_create_dir(dir_name, esw->dbgfs);
-	vnic_diag = debugfs_create_dir("vnic_diag", vport->dbgfs);
-
-	if (MLX5_CAP_GEN(esw->dev, vnic_env_queue_counters)) {
-		debugfs_create_file("total_q_under_processor_handle", 0444, vnic_diag, vport,
-				    &total_q_under_processor_handle_fops);
-		debugfs_create_file("send_queue_priority_update_flow", 0444, vnic_diag, vport,
-				    &send_queue_priority_update_flow_fops);
-	}
-
-	if (MLX5_CAP_GEN(esw->dev, eq_overrun_count)) {
-		debugfs_create_file("comp_eq_overrun", 0444, vnic_diag, vport,
-				    &comp_eq_overrun_fops);
-		debugfs_create_file("async_eq_overrun", 0444, vnic_diag, vport,
-				    &async_eq_overrun_fops);
-	}
-
-	if (MLX5_CAP_GEN(esw->dev, vnic_env_cq_overrun))
-		debugfs_create_file("cq_overrun", 0444, vnic_diag, vport, &cq_overrun_fops);
-
-	if (MLX5_CAP_GEN(esw->dev, invalid_command_count))
-		debugfs_create_file("invalid_command", 0444, vnic_diag, vport,
-				    &invalid_command_fops);
-
-	if (MLX5_CAP_GEN(esw->dev, quota_exceeded_count))
-		debugfs_create_file("quota_exceeded_command", 0444, vnic_diag, vport,
-				    &quota_exceeded_command_fops);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 8bdf28762f41..8d63f5df7646 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -36,7 +36,6 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/mpfs.h>
-#include <linux/debugfs.h>
 #include "esw/acl/lgcy.h"
 #include "esw/legacy.h"
 #include "esw/qos.h"
@@ -1056,7 +1055,6 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	if (err)
 		return err;
 
-	mlx5_esw_vport_debugfs_create(esw, vport_num, false, 0);
 	err = esw_offloads_load_rep(esw, vport_num);
 	if (err)
 		goto err_rep;
@@ -1064,7 +1062,6 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	return err;
 
 err_rep:
-	mlx5_esw_vport_debugfs_destroy(esw, vport_num);
 	mlx5_esw_vport_disable(esw, vport_num);
 	return err;
 }
@@ -1072,7 +1069,6 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	esw_offloads_unload_rep(esw, vport_num);
-	mlx5_esw_vport_debugfs_destroy(esw, vport_num);
 	mlx5_esw_vport_disable(esw, vport_num);
 }
 
@@ -1672,7 +1668,6 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
 
-	esw->dbgfs = debugfs_create_dir("esw", mlx5_debugfs_get_dev_root(esw->dev));
 	esw_info(dev,
 		 "Total vports %d, per vport: max uc(%d) max mc(%d)\n",
 		 esw->total_vports,
@@ -1696,7 +1691,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw_info(esw->dev, "cleanup\n");
 
-	debugfs_remove_recursive(esw->dbgfs);
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	WARN_ON(refcount_read(&esw->qos.refcnt));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e9d68fdf68f5..f8e25ddc066a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -195,7 +195,6 @@ struct mlx5_vport {
 	enum mlx5_eswitch_vport_event enabled_events;
 	int index;
 	struct devlink_port *dl_port;
-	struct dentry *dbgfs;
 };
 
 struct mlx5_esw_indir_table;
@@ -343,7 +342,6 @@ struct mlx5_eswitch {
 		u32             large_group_num;
 	}  params;
 	struct blocking_notifier_head n_head;
-	struct dentry *dbgfs;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -704,9 +702,6 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vport_num);
 struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u16 vport_num);
 
-void mlx5_esw_vport_debugfs_create(struct mlx5_eswitch *esw, u16 vport_num, bool is_sf, u16 sf_num);
-void mlx5_esw_vport_debugfs_destroy(struct mlx5_eswitch *esw, u16 vport_num);
-
 int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
 				      u16 vport_num, u32 controller, u32 sfnum);
 void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b6e2709c1371..93ece46a0041 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3828,14 +3828,12 @@ int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_p
 	if (err)
 		goto devlink_err;
 
-	mlx5_esw_vport_debugfs_create(esw, vport_num, true, sfnum);
 	err = mlx5_esw_offloads_rep_load(esw, vport_num);
 	if (err)
 		goto rep_err;
 	return 0;
 
 rep_err:
-	mlx5_esw_vport_debugfs_destroy(esw, vport_num);
 	mlx5_esw_devlink_sf_port_unregister(esw, vport_num);
 devlink_err:
 	mlx5_esw_vport_disable(esw, vport_num);
@@ -3845,7 +3843,6 @@ int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_p
 void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	mlx5_esw_offloads_rep_unload(esw, vport_num);
-	mlx5_esw_vport_debugfs_destroy(esw, vport_num);
 	mlx5_esw_devlink_sf_port_unregister(esw, vport_num);
 	mlx5_esw_vport_disable(esw, vport_num);
 }
-- 
2.39.2

