Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092D21B07A6
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDTLmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:01 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1846421473;
        Mon, 20 Apr 2020 11:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382920;
        bh=SD46frLhKcPGCpBLYPHsoIbtczTG7qbBCecvZ5a7Sjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfOAyXdPR6zCn/iwb3B3+qAk3uKpdcIHPORwnHxZGp+EqXoUdUjbBTb2pmZa7Vtgz
         SEEbF6Z2hsCh1TDegcxd/+zJCR8rtJinPcpRC44meMQnZPzjWZ1fQEtKw3ouWW6jYY
         r+C1xTeXTYf2m+bDu5m57hd/yPFyHyDwp/WHYPwI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/24] net/mlx5: Update statistics to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:18 +0300
Message-Id: <20200420114136.264924-7-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of statistics to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../mellanox/mlx5/core/en/monitor_stats.c     | 46 ++++++-------------
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 17 ++-----
 2 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
index 7cd5b02e0f10..8fe8b4d6ad1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/monitor_stats.c
@@ -38,12 +38,11 @@ int mlx5e_monitor_counter_supported(struct mlx5e_priv *priv)
 
 void mlx5e_monitor_counter_arm(struct mlx5e_priv *priv)
 {
-	u32  in[MLX5_ST_SZ_DW(arm_monitor_counter_in)]  = {};
-	u32 out[MLX5_ST_SZ_DW(arm_monitor_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(arm_monitor_counter_in)] = {};
 
 	MLX5_SET(arm_monitor_counter_in, in, opcode,
 		 MLX5_CMD_OP_ARM_MONITOR_COUNTER);
-	mlx5_cmd_exec(priv->mdev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(priv->mdev, arm_monitor_counter, in);
 }
 
 static void mlx5e_monitor_counters_work(struct work_struct *work)
@@ -66,19 +65,6 @@ static int mlx5e_monitor_event_handler(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static void mlx5e_monitor_counter_start(struct mlx5e_priv *priv)
-{
-	MLX5_NB_INIT(&priv->monitor_counters_nb, mlx5e_monitor_event_handler,
-		     MONITOR_COUNTER);
-	mlx5_eq_notifier_register(priv->mdev, &priv->monitor_counters_nb);
-}
-
-static void mlx5e_monitor_counter_stop(struct mlx5e_priv *priv)
-{
-	mlx5_eq_notifier_unregister(priv->mdev, &priv->monitor_counters_nb);
-	cancel_work_sync(&priv->monitor_counters_work);
-}
-
 static int fill_monitor_counter_ppcnt_set1(int cnt, u32 *in)
 {
 	enum mlx5_monitor_counter_ppcnt ppcnt_cnt;
@@ -118,8 +104,7 @@ static void mlx5e_set_monitor_counter(struct mlx5e_priv *priv)
 	int num_q_counters      = MLX5_CAP_GEN(mdev, num_q_monitor_counters);
 	int num_ppcnt_counters  = !MLX5_CAP_PCAM_REG(mdev, ppcnt) ? 0 :
 				  MLX5_CAP_GEN(mdev, num_ppcnt_monitor_counters);
-	u32  in[MLX5_ST_SZ_DW(set_monitor_counter_in)]  = {};
-	u32 out[MLX5_ST_SZ_DW(set_monitor_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(set_monitor_counter_in)] = {};
 	int q_counter = priv->q_counter;
 	int cnt	= 0;
 
@@ -136,34 +121,31 @@ static void mlx5e_set_monitor_counter(struct mlx5e_priv *priv)
 	MLX5_SET(set_monitor_counter_in, in, opcode,
 		 MLX5_CMD_OP_SET_MONITOR_COUNTER);
 
-	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec_in(mdev, set_monitor_counter, in);
 }
 
 /* check if mlx5e_monitor_counter_supported before calling this function*/
 void mlx5e_monitor_counter_init(struct mlx5e_priv *priv)
 {
 	INIT_WORK(&priv->monitor_counters_work, mlx5e_monitor_counters_work);
-	mlx5e_monitor_counter_start(priv);
+	MLX5_NB_INIT(&priv->monitor_counters_nb, mlx5e_monitor_event_handler,
+		     MONITOR_COUNTER);
+	mlx5_eq_notifier_register(priv->mdev, &priv->monitor_counters_nb);
+
 	mlx5e_set_monitor_counter(priv);
 	mlx5e_monitor_counter_arm(priv);
 	queue_work(priv->wq, &priv->update_stats_work);
 }
 
-static void mlx5e_monitor_counter_disable(struct mlx5e_priv *priv)
+/* check if mlx5e_monitor_counter_supported before calling this function*/
+void mlx5e_monitor_counter_cleanup(struct mlx5e_priv *priv)
 {
-	u32  in[MLX5_ST_SZ_DW(set_monitor_counter_in)]  = {};
-	u32 out[MLX5_ST_SZ_DW(set_monitor_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(set_monitor_counter_in)] = {};
 
-	MLX5_SET(set_monitor_counter_in, in, num_of_counters, 0);
 	MLX5_SET(set_monitor_counter_in, in, opcode,
 		 MLX5_CMD_OP_SET_MONITOR_COUNTER);
 
-	mlx5_cmd_exec(priv->mdev, in, sizeof(in), out, sizeof(out));
-}
-
-/* check if mlx5e_monitor_counter_supported before calling this function*/
-void mlx5e_monitor_counter_cleanup(struct mlx5e_priv *priv)
-{
-	mlx5e_monitor_counter_disable(priv);
-	mlx5e_monitor_counter_stop(priv);
+	mlx5_cmd_exec_in(priv->mdev, set_monitor_counter, in);
+	mlx5_eq_notifier_unregister(priv->mdev, &priv->monitor_counters_nb);
+	cancel_work_sync(&priv->monitor_counters_work);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index ff4002ebad90..e91a8b22eba6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -491,18 +491,14 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vnic_env)
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vnic_env)
 {
 	u32 *out = (u32 *)priv->stats.vnic.query_vnic_env_out;
-	int outlen = MLX5_ST_SZ_BYTES(query_vnic_env_out);
-	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
 	struct mlx5_core_dev *mdev = priv->mdev;
 
 	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
 		return;
 
-	MLX5_SET(query_vnic_env_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_VNIC_ENV);
-	MLX5_SET(query_vnic_env_in, in, op_mod, 0);
-	MLX5_SET(query_vnic_env_in, in, other_vport, 0);
-	mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
+	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
+	mlx5_cmd_exec_inout(mdev, query_vnic_env, in, out);
 }
 
 #define VPORT_COUNTER_OFF(c) MLX5_BYTE_OFF(query_vport_counter_out, c)
@@ -577,15 +573,12 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vport)
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport)
 {
-	int outlen = MLX5_ST_SZ_BYTES(query_vport_counter_out);
 	u32 *out = (u32 *)priv->stats.vport.query_vport_out;
-	u32 in[MLX5_ST_SZ_DW(query_vport_counter_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_vport_counter_in)] = {};
 	struct mlx5_core_dev *mdev = priv->mdev;
 
 	MLX5_SET(query_vport_counter_in, in, opcode, MLX5_CMD_OP_QUERY_VPORT_COUNTER);
-	MLX5_SET(query_vport_counter_in, in, op_mod, 0);
-	MLX5_SET(query_vport_counter_in, in, other_vport, 0);
-	mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
+	mlx5_cmd_exec_inout(mdev, query_vport_counter, in, out);
 }
 
 #define PPORT_802_3_OFF(c) \
-- 
2.25.2

