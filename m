Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BC23FF3D8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347412AbhIBTHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347348AbhIBTHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B59660F21;
        Thu,  2 Sep 2021 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609571;
        bh=NgD94vJ5lDZdntU9C5LMy/3p7xaw/u7a6XpCpQSA5kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmS+unWNQ/Ze5RzK9KNVYZWM2uIZ2kkjLuaUD/sG1DIBsdn9NnZY0n1FZkgN4/DGo
         i/gnwF3cEwxVTQ02eDmdN2pwbMijDu+MeC7Z2nhU88kfn5oARcGA8cNiDpK9r1QD2Y
         o3Ga8/45MShDDcoAhBtUIGK+LUqPfwdRKMRdBpPDxm+0USw2ovpeniQWbbaFPMVr9P
         y9y51WlmoUkQtgYl3TM5MjD5tklxY2DBrxF9br/+tIQI9hbnLysrsOkCdXDu2fFbiw
         ETqOP/KeukK30Ft8jHP29dJa1bh6Am2NPtMnknBfEiBHgmw4wLPUkiXDf8fRT18I6z
         KVrrcxXh890sA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Add TX max rate support for MQPRIO channel mode
Date:   Thu,  2 Sep 2021 12:05:54 -0700
Message-Id: <20210902190554.211497-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Add driver max_rate support for the MQPRIO bw_rlimit shaper
in channel mode.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 +
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 99 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  9 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 92 ++++++++++++++++-
 4 files changed, 199 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a8178656da9c..03110daea567 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -253,6 +253,9 @@ struct mlx5e_params {
 		u16 mode;
 		u8 num_tc;
 		struct netdev_tc_txq tc_to_txq[TC_MAX_QUEUE];
+		struct {
+			struct mlx5e_mqprio_rl *rl;
+		} channel;
 	} mqprio;
 	bool rx_cqe_compress_def;
 	bool tunneled_offload_en;
@@ -878,6 +881,7 @@ struct mlx5e_priv {
 #endif
 	struct mlx5e_scratchpad    scratchpad;
 	struct mlx5e_htb           htb;
+	struct mlx5e_mqprio_rl    *mqprio_rl;
 };
 
 struct mlx5e_rx_handlers {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 17a607541af6..50977f01a050 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -7,6 +7,21 @@
 
 #define BYTES_IN_MBIT 125000
 
+int mlx5e_qos_bytes_rate_check(struct mlx5_core_dev *mdev, u64 nbytes)
+{
+	if (nbytes < BYTES_IN_MBIT) {
+		qos_warn(mdev, "Input rate (%llu Bytes/sec) below minimum supported (%u Bytes/sec)\n",
+			 nbytes, BYTES_IN_MBIT);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static u32 mlx5e_qos_bytes2mbits(struct mlx5_core_dev *mdev, u64 nbytes)
+{
+	return div_u64(nbytes, BYTES_IN_MBIT);
+}
+
 int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev)
 {
 	return min(MLX5E_QOS_MAX_LEAF_NODES, mlx5_qos_max_leaf_nodes(mdev));
@@ -980,3 +995,87 @@ int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ce
 
 	return err;
 }
+
+struct mlx5e_mqprio_rl {
+	struct mlx5_core_dev *mdev;
+	u32 root_id;
+	u32 *leaves_id;
+	u8 num_tc;
+};
+
+struct mlx5e_mqprio_rl *mlx5e_mqprio_rl_alloc(void)
+{
+	return kvzalloc(sizeof(struct mlx5e_mqprio_rl), GFP_KERNEL);
+}
+
+void mlx5e_mqprio_rl_free(struct mlx5e_mqprio_rl *rl)
+{
+	kvfree(rl);
+}
+
+int mlx5e_mqprio_rl_init(struct mlx5e_mqprio_rl *rl, struct mlx5_core_dev *mdev, u8 num_tc,
+			 u64 max_rate[])
+{
+	int err;
+	int tc;
+
+	if (!mlx5_qos_is_supported(mdev)) {
+		qos_warn(mdev, "Missing QoS capabilities. Try disabling SRIOV or use a supported device.");
+		return -EOPNOTSUPP;
+	}
+	if (num_tc > mlx5e_qos_max_leaf_nodes(mdev))
+		return -EINVAL;
+
+	rl->mdev = mdev;
+	rl->num_tc = num_tc;
+	rl->leaves_id = kvcalloc(num_tc, sizeof(*rl->leaves_id), GFP_KERNEL);
+	if (!rl->leaves_id)
+		return -ENOMEM;
+
+	err = mlx5_qos_create_root_node(mdev, &rl->root_id);
+	if (err)
+		goto err_free_leaves;
+
+	qos_dbg(mdev, "Root created, id %#x\n", rl->root_id);
+
+	for (tc = 0; tc < num_tc; tc++) {
+		u32 max_average_bw;
+
+		max_average_bw = mlx5e_qos_bytes2mbits(mdev, max_rate[tc]);
+		err = mlx5_qos_create_leaf_node(mdev, rl->root_id, 0, max_average_bw,
+						&rl->leaves_id[tc]);
+		if (err)
+			goto err_destroy_leaves;
+
+		qos_dbg(mdev, "Leaf[%d] created, id %#x, max average bw %u Mbits/sec\n",
+			tc, rl->leaves_id[tc], max_average_bw);
+	}
+	return 0;
+
+err_destroy_leaves:
+	while (--tc >= 0)
+		mlx5_qos_destroy_node(mdev, rl->leaves_id[tc]);
+	mlx5_qos_destroy_node(mdev, rl->root_id);
+err_free_leaves:
+	kvfree(rl->leaves_id);
+	return err;
+}
+
+void mlx5e_mqprio_rl_cleanup(struct mlx5e_mqprio_rl *rl)
+{
+	int tc;
+
+	for (tc = 0; tc < rl->num_tc; tc++)
+		mlx5_qos_destroy_node(rl->mdev, rl->leaves_id[tc]);
+	mlx5_qos_destroy_node(rl->mdev, rl->root_id);
+	kvfree(rl->leaves_id);
+}
+
+int mlx5e_mqprio_rl_get_node_hw_id(struct mlx5e_mqprio_rl *rl, int tc, u32 *hw_id)
+{
+	if (tc >= rl->num_tc)
+		return -EINVAL;
+
+	*hw_id = rl->leaves_id[tc];
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
index 757682b7c0e0..b7558907ba20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
@@ -12,6 +12,7 @@ struct mlx5e_priv;
 struct mlx5e_channels;
 struct mlx5e_channel;
 
+int mlx5e_qos_bytes_rate_check(struct mlx5_core_dev *mdev, u64 nbytes);
 int mlx5e_qos_max_leaf_nodes(struct mlx5_core_dev *mdev);
 int mlx5e_qos_cur_leaf_nodes(struct mlx5e_priv *priv);
 
@@ -41,4 +42,12 @@ int mlx5e_htb_leaf_del_last(struct mlx5e_priv *priv, u16 classid, bool force,
 int mlx5e_htb_node_modify(struct mlx5e_priv *priv, u16 classid, u64 rate, u64 ceil,
 			  struct netlink_ext_ack *extack);
 
+/* MQPRIO TX rate limit */
+struct mlx5e_mqprio_rl;
+struct mlx5e_mqprio_rl *mlx5e_mqprio_rl_alloc(void);
+void mlx5e_mqprio_rl_free(struct mlx5e_mqprio_rl *rl);
+int mlx5e_mqprio_rl_init(struct mlx5e_mqprio_rl *rl, struct mlx5_core_dev *mdev, u8 num_tc,
+			 u64 max_rate[]);
+void mlx5e_mqprio_rl_cleanup(struct mlx5e_mqprio_rl *rl);
+int mlx5e_mqprio_rl_get_node_hw_id(struct mlx5e_mqprio_rl *rl, int tc, u32 *hw_id);
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ca7a5e932c2c..162923d55a37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1706,6 +1706,35 @@ static void mlx5e_close_tx_cqs(struct mlx5e_channel *c)
 		mlx5e_close_cq(&c->sq[tc].cq);
 }
 
+static int mlx5e_mqprio_txq_to_tc(struct netdev_tc_txq *tc_to_txq, unsigned int txq)
+{
+	int tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (txq - tc_to_txq[tc].offset < tc_to_txq[tc].count)
+			return tc;
+
+	return -ENOENT;
+}
+
+static int mlx5e_txq_get_qos_node_hw_id(struct mlx5e_params *params, int txq_ix,
+					u32 *hw_id)
+{
+	int tc;
+
+	if (params->mqprio.mode != TC_MQPRIO_MODE_CHANNEL ||
+	    !params->mqprio.channel.rl) {
+		*hw_id = 0;
+		return 0;
+	}
+
+	tc = mlx5e_mqprio_txq_to_tc(params->mqprio.tc_to_txq, txq_ix);
+	if (tc < 0)
+		return tc;
+
+	return mlx5e_mqprio_rl_get_node_hw_id(params->mqprio.channel.rl, tc, hw_id);
+}
+
 static int mlx5e_open_sqs(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_channel_param *cparam)
@@ -1714,9 +1743,15 @@ static int mlx5e_open_sqs(struct mlx5e_channel *c,
 
 	for (tc = 0; tc < mlx5e_get_dcb_num_tc(params); tc++) {
 		int txq_ix = c->ix + tc * params->num_channels;
+		u32 qos_queue_group_id;
+
+		err = mlx5e_txq_get_qos_node_hw_id(params, txq_ix, &qos_queue_group_id);
+		if (err)
+			goto err_close_sqs;
 
 		err = mlx5e_open_txqsq(c, c->priv->tisn[c->lag_port][tc], txq_ix,
-				       params, &cparam->txq_sq, &c->sq[tc], tc, 0, NULL);
+				       params, &cparam->txq_sq, &c->sq[tc], tc,
+				       qos_queue_group_id, NULL);
 		if (err)
 			goto err_close_sqs;
 	}
@@ -2341,6 +2376,13 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 		netdev_warn(netdev, "netif_set_real_num_rx_queues failed, %d\n", err);
 		goto err_txqs;
 	}
+	if (priv->mqprio_rl != priv->channels.params.mqprio.channel.rl) {
+		if (priv->mqprio_rl) {
+			mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
+			mlx5e_mqprio_rl_free(priv->mqprio_rl);
+		}
+		priv->mqprio_rl = priv->channels.params.mqprio.channel.rl;
+	}
 
 	return 0;
 
@@ -2902,15 +2944,18 @@ static void mlx5e_params_mqprio_dcb_set(struct mlx5e_params *params, u8 num_tc)
 {
 	params->mqprio.mode = TC_MQPRIO_MODE_DCB;
 	params->mqprio.num_tc = num_tc;
+	params->mqprio.channel.rl = NULL;
 	mlx5e_mqprio_build_default_tc_to_txq(params->mqprio.tc_to_txq, num_tc,
 					     params->num_channels);
 }
 
 static void mlx5e_params_mqprio_channel_set(struct mlx5e_params *params,
-					    struct tc_mqprio_qopt *qopt)
+					    struct tc_mqprio_qopt *qopt,
+					    struct mlx5e_mqprio_rl *rl)
 {
 	params->mqprio.mode = TC_MQPRIO_MODE_CHANNEL;
 	params->mqprio.num_tc = qopt->num_tc;
+	params->mqprio.channel.rl = rl;
 	mlx5e_mqprio_build_tc_to_txq(params->mqprio.tc_to_txq, qopt);
 }
 
@@ -2962,9 +3007,13 @@ static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
 			netdev_err(netdev, "Min tx rate is not supported\n");
 			return -EINVAL;
 		}
+
 		if (mqprio->max_rate[i]) {
-			netdev_err(netdev, "Max tx rate is not supported\n");
-			return -EINVAL;
+			int err;
+
+			err = mlx5e_qos_bytes_rate_check(priv->mdev, mqprio->max_rate[i]);
+			if (err)
+				return err;
 		}
 
 		if (mqprio->qopt.offset[i] != agg_count) {
@@ -2983,10 +3032,21 @@ static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static bool mlx5e_mqprio_rate_limit(struct tc_mqprio_qopt_offload *mqprio)
+{
+	int tc;
+
+	for (tc = 0; tc < mqprio->qopt.num_tc; tc++)
+		if (mqprio->max_rate[tc])
+			return true;
+	return false;
+}
+
 static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
 					 struct tc_mqprio_qopt_offload *mqprio)
 {
 	struct mlx5e_params new_params;
+	struct mlx5e_mqprio_rl *rl;
 	bool nch_changed;
 	int err;
 
@@ -2996,8 +3056,21 @@ static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
+	rl = NULL;
+	if (mlx5e_mqprio_rate_limit(mqprio)) {
+		rl = mlx5e_mqprio_rl_alloc();
+		if (!rl)
+			return -ENOMEM;
+		err = mlx5e_mqprio_rl_init(rl, priv->mdev, mqprio->qopt.num_tc,
+					   mqprio->max_rate);
+		if (err) {
+			mlx5e_mqprio_rl_free(rl);
+			return err;
+		}
+	}
+
 	new_params = priv->channels.params;
-	mlx5e_params_mqprio_channel_set(&new_params, &mqprio->qopt);
+	mlx5e_params_mqprio_channel_set(&new_params, &mqprio->qopt, rl);
 
 	if (nch_changed)
 		err = mlx5e_safe_switch_params(priv, &new_params,
@@ -3007,6 +3080,10 @@ static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
 		err = mlx5e_safe_switch_params(priv, &new_params,
 					       mlx5e_update_netdev_queues_ctx,
 					       NULL, true);
+	if (err && rl) {
+		mlx5e_mqprio_rl_cleanup(rl);
+		mlx5e_mqprio_rl_free(rl);
+	}
 
 	return err;
 }
@@ -4781,6 +4858,11 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 		kfree(priv->htb.qos_sq_stats[i]);
 	kvfree(priv->htb.qos_sq_stats);
 
+	if (priv->mqprio_rl) {
+		mlx5e_mqprio_rl_cleanup(priv->mqprio_rl);
+		mlx5e_mqprio_rl_free(priv->mqprio_rl);
+	}
+
 	memset(priv, 0, sizeof(*priv));
 }
 
-- 
2.31.1

