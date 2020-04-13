Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CA31A6806
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgDMOXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730650AbgDMOXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE2C2075E;
        Mon, 13 Apr 2020 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787821;
        bh=WC5+Jic4bh+3LsN5kSjgiZSgGnFY46w58SVmwZVsjZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8TAXXXmo/COkIz8ALcCOhLfSEV7PIXpLRxNWsrh3sKRjUXfeUG/LF4uYMbf/jBhR
         YeUWEKiOeqSr9GtPYqUdRY+oQ0McbzHuTIBOaPC/Dr41J+ZnWlAEXm1HO1+/HAqNtX
         vPKKTAbnv2KTTnH5x/Tsy79zGMl+sez/ewO3h8Z8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/13] net/mlx5: Remove Q counter low level helper APIs
Date:   Mon, 13 Apr 2020 17:23:04 +0300
Message-Id: <20200413142308.936946-10-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
References: <20200413142308.936946-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

mlx5 core users are encouraged to use low level API (mlx5_cmd_exec)
without the need of helper functions, do this for q counters, remove
helper functions and call mlx5_cmd_exec directly from users.

This will help reduce the total amount of code and reduction of the
mlx5_core symbol table.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 55 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 39 ++++++++-----
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 35 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/qp.c  | 39 -------------
 include/linux/mlx5/qp.h                       |  4 --
 5 files changed, 80 insertions(+), 92 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b8ac77ea8125..58e3b1d5d7b2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5411,15 +5411,21 @@ static bool is_mdev_switchdev_mode(const struct mlx5_core_dev *mdev)
 
 static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
+	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
 	int num_cnt_ports;
 	int i;
 
 	num_cnt_ports = is_mdev_switchdev_mode(dev->mdev) ? 1 : dev->num_ports;
 
+	MLX5_SET(dealloc_q_counter_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_Q_COUNTER);
+
 	for (i = 0; i < num_cnt_ports; i++) {
-		if (dev->port[i].cnts.set_id_valid)
-			mlx5_core_dealloc_q_counter(dev->mdev,
-						    dev->port[i].cnts.set_id);
+		if (dev->port[i].cnts.set_id_valid) {
+			MLX5_SET(dealloc_q_counter_in, in, counter_set_id,
+				 dev->port[i].cnts.set_id);
+			mlx5_cmd_exec_in(dev->mdev, dealloc_q_counter, in);
+		}
 		kfree(dev->port[i].cnts.names);
 		kfree(dev->port[i].cnts.offsets);
 	}
@@ -5610,27 +5616,23 @@ static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    struct rdma_hw_stats *stats,
 				    u16 set_id)
 {
-	int outlen = MLX5_ST_SZ_BYTES(query_q_counter_out);
-	void *out;
+	u32 out[MLX5_ST_SZ_DW(query_q_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_q_counter_in)] = {};
 	__be32 val;
 	int ret, i;
 
-	out = kvzalloc(outlen, GFP_KERNEL);
-	if (!out)
-		return -ENOMEM;
-
-	ret = mlx5_core_query_q_counter(mdev, set_id, 0, out, outlen);
+	MLX5_SET(query_q_counter_in, in, opcode, MLX5_CMD_OP_QUERY_Q_COUNTER);
+	MLX5_SET(query_q_counter_in, in, counter_set_id, set_id);
+	ret = mlx5_cmd_exec_inout(mdev, query_q_counter, in, out);
 	if (ret)
-		goto free;
+		return ret;
 
 	for (i = 0; i < cnts->num_q_counters; i++) {
-		val = *(__be32 *)(out + cnts->offsets[i]);
+		val = *(__be32 *)((void *)out + cnts->offsets[i]);
 		stats->value[i] = (u64)be32_to_cpu(val);
 	}
 
-free:
-	kvfree(out);
-	return ret;
+	return 0;
 }
 
 static int mlx5_ib_query_ext_ppcnt_counters(struct mlx5_ib_dev *dev,
@@ -5737,6 +5739,20 @@ static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
 					counter->stats, counter->id);
 }
 
+static int mlx5_ib_counter_dealloc(struct rdma_counter *counter)
+{
+	struct mlx5_ib_dev *dev = to_mdev(counter->device);
+	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
+
+	if (!counter->id)
+		return 0;
+
+	MLX5_SET(dealloc_q_counter_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_Q_COUNTER);
+	MLX5_SET(dealloc_q_counter_in, in, counter_set_id, counter->id);
+	return mlx5_cmd_exec_in(dev->mdev, dealloc_q_counter, in);
+}
+
 static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 				   struct ib_qp *qp)
 {
@@ -5760,7 +5776,7 @@ static int mlx5_ib_counter_bind_qp(struct rdma_counter *counter,
 	return 0;
 
 fail_set_counter:
-	mlx5_core_dealloc_q_counter(dev->mdev, cnt_set_id);
+	mlx5_ib_counter_dealloc(counter);
 	counter->id = 0;
 
 	return err;
@@ -5771,13 +5787,6 @@ static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp)
 	return mlx5_ib_qp_set_counter(qp, NULL);
 }
 
-static int mlx5_ib_counter_dealloc(struct rdma_counter *counter)
-{
-	struct mlx5_ib_dev *dev = to_mdev(counter->device);
-
-	return mlx5_core_dealloc_q_counter(dev->mdev, counter->id);
-}
-
 static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
 				 enum rdma_netdev_t type,
 				 struct rdma_netdev_alloc_params *params)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dd7f338425eb..30970b405040 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4997,29 +4997,40 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 void mlx5e_create_q_counters(struct mlx5e_priv *priv)
 {
+	u32 out[MLX5_ST_SZ_DW(alloc_q_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_q_counter_in)] = {};
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
-	err = mlx5_core_alloc_q_counter(mdev, &priv->q_counter);
-	if (err) {
-		mlx5_core_warn(mdev, "alloc queue counter failed, %d\n", err);
-		priv->q_counter = 0;
-	}
+	MLX5_SET(alloc_q_counter_in, in, opcode, MLX5_CMD_OP_ALLOC_Q_COUNTER);
+	err = mlx5_cmd_exec_inout(mdev, alloc_q_counter, in, out);
+	if (!err)
+		priv->q_counter =
+			MLX5_GET(alloc_q_counter_out, out, counter_set_id);
 
-	err = mlx5_core_alloc_q_counter(mdev, &priv->drop_rq_q_counter);
-	if (err) {
-		mlx5_core_warn(mdev, "alloc drop RQ counter failed, %d\n", err);
-		priv->drop_rq_q_counter = 0;
-	}
+	err = mlx5_cmd_exec_inout(mdev, alloc_q_counter, in, out);
+	if (!err)
+		priv->drop_rq_q_counter =
+			MLX5_GET(alloc_q_counter_out, out, counter_set_id);
 }
 
 void mlx5e_destroy_q_counters(struct mlx5e_priv *priv)
 {
-	if (priv->q_counter)
-		mlx5_core_dealloc_q_counter(priv->mdev, priv->q_counter);
+	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)] = {};
+
+	MLX5_SET(dealloc_q_counter_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_Q_COUNTER);
+	if (priv->q_counter) {
+		MLX5_SET(dealloc_q_counter_in, in, counter_set_id,
+			 priv->q_counter);
+		mlx5_cmd_exec_in(priv->mdev, dealloc_q_counter, in);
+	}
 
-	if (priv->drop_rq_q_counter)
-		mlx5_core_dealloc_q_counter(priv->mdev, priv->drop_rq_q_counter);
+	if (priv->drop_rq_q_counter) {
+		MLX5_SET(dealloc_q_counter_in, in, counter_set_id,
+			 priv->drop_rq_q_counter);
+		mlx5_cmd_exec_in(priv->mdev, dealloc_q_counter, in);
+	}
 }
 
 static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 30b216d9284c..ff4002ebad90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -411,18 +411,29 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(qcnt)
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(qcnt)
 {
 	struct mlx5e_qcounter_stats *qcnt = &priv->stats.qcnt;
-	u32 out[MLX5_ST_SZ_DW(query_q_counter_out)];
-
-	if (priv->q_counter &&
-	    !mlx5_core_query_q_counter(priv->mdev, priv->q_counter, 0, out,
-				       sizeof(out)))
-		qcnt->rx_out_of_buffer = MLX5_GET(query_q_counter_out,
-						  out, out_of_buffer);
-	if (priv->drop_rq_q_counter &&
-	    !mlx5_core_query_q_counter(priv->mdev, priv->drop_rq_q_counter, 0,
-				       out, sizeof(out)))
-		qcnt->rx_if_down_packets = MLX5_GET(query_q_counter_out, out,
-						    out_of_buffer);
+	u32 out[MLX5_ST_SZ_DW(query_q_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_q_counter_in)] = {};
+	int ret;
+
+	MLX5_SET(query_q_counter_in, in, opcode, MLX5_CMD_OP_QUERY_Q_COUNTER);
+
+	if (priv->q_counter) {
+		MLX5_SET(query_q_counter_in, in, counter_set_id,
+			 priv->q_counter);
+		ret = mlx5_cmd_exec_inout(priv->mdev, query_q_counter, in, out);
+		if (!ret)
+			qcnt->rx_out_of_buffer = MLX5_GET(query_q_counter_out,
+							  out, out_of_buffer);
+	}
+
+	if (priv->drop_rq_q_counter) {
+		MLX5_SET(query_q_counter_in, in, counter_set_id,
+			 priv->drop_rq_q_counter);
+		ret = mlx5_cmd_exec_inout(priv->mdev, query_q_counter, in, out);
+		if (!ret)
+			qcnt->rx_if_down_packets = MLX5_GET(query_q_counter_out,
+							    out, out_of_buffer);
+	}
 }
 
 #define VNIC_ENV_OFF(c) MLX5_BYTE_OFF(query_vnic_env_out, c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index c3aea4cc2fff..e36790ad5256 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -680,45 +680,6 @@ void mlx5_core_destroy_sq_tracked(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_core_destroy_sq_tracked);
 
-int mlx5_core_alloc_q_counter(struct mlx5_core_dev *dev, u16 *counter_id)
-{
-	u32 in[MLX5_ST_SZ_DW(alloc_q_counter_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(alloc_q_counter_out)] = {0};
-	int err;
-
-	MLX5_SET(alloc_q_counter_in, in, opcode, MLX5_CMD_OP_ALLOC_Q_COUNTER);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (!err)
-		*counter_id = MLX5_GET(alloc_q_counter_out, out,
-				       counter_set_id);
-	return err;
-}
-EXPORT_SYMBOL_GPL(mlx5_core_alloc_q_counter);
-
-int mlx5_core_dealloc_q_counter(struct mlx5_core_dev *dev, u16 counter_id)
-{
-	u32 in[MLX5_ST_SZ_DW(dealloc_q_counter_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(dealloc_q_counter_out)] = {0};
-
-	MLX5_SET(dealloc_q_counter_in, in, opcode,
-		 MLX5_CMD_OP_DEALLOC_Q_COUNTER);
-	MLX5_SET(dealloc_q_counter_in, in, counter_set_id, counter_id);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-EXPORT_SYMBOL_GPL(mlx5_core_dealloc_q_counter);
-
-int mlx5_core_query_q_counter(struct mlx5_core_dev *dev, u16 counter_id,
-			      int reset, void *out, int out_size)
-{
-	u32 in[MLX5_ST_SZ_DW(query_q_counter_in)] = {0};
-
-	MLX5_SET(query_q_counter_in, in, opcode, MLX5_CMD_OP_QUERY_Q_COUNTER);
-	MLX5_SET(query_q_counter_in, in, clear, reset);
-	MLX5_SET(query_q_counter_in, in, counter_set_id, counter_id);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, out_size);
-}
-EXPORT_SYMBOL_GPL(mlx5_core_query_q_counter);
-
 struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
 						int res_num,
 						enum mlx5_res_type res_type)
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index fab88b0c76f9..2413394298dc 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -597,10 +597,6 @@ int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 				struct mlx5_core_qp *sq);
 void mlx5_core_destroy_sq_tracked(struct mlx5_core_dev *dev,
 				  struct mlx5_core_qp *sq);
-int mlx5_core_alloc_q_counter(struct mlx5_core_dev *dev, u16 *counter_id);
-int mlx5_core_dealloc_q_counter(struct mlx5_core_dev *dev, u16 counter_id);
-int mlx5_core_query_q_counter(struct mlx5_core_dev *dev, u16 counter_id,
-			      int reset, void *out, int out_size);
 
 struct mlx5_core_rsc_common *mlx5_core_res_hold(struct mlx5_core_dev *dev,
 						int res_num,
-- 
2.25.2

