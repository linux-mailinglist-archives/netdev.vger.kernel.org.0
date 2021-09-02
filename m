Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE89F3FF3D6
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbhIBTHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347340AbhIBTHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47B7161053;
        Thu,  2 Sep 2021 19:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609570;
        bh=5jgY0MIqcLzmeh5JtQWzOm6OIpirB5tkiRiV1405JlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eovSCuWjYadQGhuVJpt2PDhYI9alX44ZbqGGeP+aIzNAw9evNkorn1eB3fIppB2CU
         aGOUK6SGJ0cqUwagM/9ATvxs4AbXifQe2waSgU+dn64gG9pZtlHS8wlXXt1rqf+guA
         0zGAqo4OcsbZOlyOBcsSZgJLkw0qUObv7NpZCVXTFgYuDMsjMORaeCmsvC2/L5eQp9
         ywDFz0NDgen/U2d9wLiqVi28knvIUs/VJeeGpc1NuOkwwXYwWi7afUxLLKVQndo7A3
         MuxdhDdfkREdMtEBXpfbV61oADs7SA6iU2BDpLQkUNMtmK28HaebE1tF/TYAZVmdLe
         jYXYWTsRMHVNw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Improve MQPRIO resiliency
Date:   Thu,  2 Sep 2021 12:05:52 -0700
Message-Id: <20210902190554.211497-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

* Add netdev->tc_to_txq rollback in case of failure in
  mlx5e_update_netdev_queues().
* Fix broken transition between the two modes:
  MQPRIO DCB mode with tc==8, and MQPRIO channel mode.
* Disable MQPRIO channel mode if re-attaching with a different number
  of channels.
* Improve code sharing.

Fixes: ec60c4581bd9 ("net/mlx5e: Support MQPRIO channel mode")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 118 +++++++++++++-----
 2 files changed, 88 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 669a75f3537a..4ff84832fb45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -252,6 +252,7 @@ struct mlx5e_params {
 	struct {
 		u16 mode;
 		u8 num_tc;
+		struct netdev_tc_txq tc_to_txq[TC_MAX_QUEUE];
 	} mqprio;
 	bool rx_cqe_compress_def;
 	bool tunneled_offload_en;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47efd858964d..ae223fc46df7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2264,7 +2264,7 @@ void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv)
 }
 
 static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc,
-				struct tc_mqprio_qopt_offload *mqprio)
+				struct netdev_tc_txq *tc_to_txq)
 {
 	int tc, err;
 
@@ -2282,11 +2282,8 @@ static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc,
 	for (tc = 0; tc < ntc; tc++) {
 		u16 count, offset;
 
-		/* For DCB mode, map netdev TCs to offset 0
-		 * We have our own UP to TXQ mapping for QoS
-		 */
-		count = mqprio ? mqprio->qopt.count[tc] : nch;
-		offset = mqprio ? mqprio->qopt.offset[tc] : 0;
+		count = tc_to_txq[tc].count;
+		offset = tc_to_txq[tc].offset;
 		netdev_set_tc_queue(netdev, tc, count, offset);
 	}
 
@@ -2315,19 +2312,24 @@ int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
 
 static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 {
+	struct netdev_tc_txq old_tc_to_txq[TC_MAX_QUEUE], *tc_to_txq;
 	struct net_device *netdev = priv->netdev;
 	int old_num_txqs, old_ntc;
 	int num_rxqs, nch, ntc;
 	int err;
+	int i;
 
 	old_num_txqs = netdev->real_num_tx_queues;
 	old_ntc = netdev->num_tc ? : 1;
+	for (i = 0; i < ARRAY_SIZE(old_tc_to_txq); i++)
+		old_tc_to_txq[i] = netdev->tc_to_txq[i];
 
 	nch = priv->channels.params.num_channels;
-	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
+	ntc = priv->channels.params.mqprio.num_tc;
 	num_rxqs = nch * priv->profile->rq_groups;
+	tc_to_txq = priv->channels.params.mqprio.tc_to_txq;
 
-	err = mlx5e_netdev_set_tcs(netdev, nch, ntc, NULL);
+	err = mlx5e_netdev_set_tcs(netdev, nch, ntc, tc_to_txq);
 	if (err)
 		goto err_out;
 	err = mlx5e_update_tx_netdev_queues(priv);
@@ -2350,11 +2352,14 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	WARN_ON_ONCE(netif_set_real_num_tx_queues(netdev, old_num_txqs));
 
 err_tcs:
-	mlx5e_netdev_set_tcs(netdev, old_num_txqs / old_ntc, old_ntc, NULL);
+	WARN_ON_ONCE(mlx5e_netdev_set_tcs(netdev, old_num_txqs / old_ntc, old_ntc,
+					  old_tc_to_txq));
 err_out:
 	return err;
 }
 
+static MLX5E_DEFINE_PREACTIVATE_WRAPPER_CTX(mlx5e_update_netdev_queues);
+
 static void mlx5e_set_default_xps_cpumasks(struct mlx5e_priv *priv,
 					   struct mlx5e_params *params)
 {
@@ -2861,6 +2866,58 @@ static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 	return 0;
 }
 
+static void mlx5e_mqprio_build_default_tc_to_txq(struct netdev_tc_txq *tc_to_txq,
+						 int ntc, int nch)
+{
+	int tc;
+
+	memset(tc_to_txq, 0, sizeof(*tc_to_txq) * TC_MAX_QUEUE);
+
+	/* Map netdev TCs to offset 0.
+	 * We have our own UP to TXQ mapping for DCB mode of QoS
+	 */
+	for (tc = 0; tc < ntc; tc++) {
+		tc_to_txq[tc] = (struct netdev_tc_txq) {
+			.count = nch,
+			.offset = 0,
+		};
+	}
+}
+
+static void mlx5e_mqprio_build_tc_to_txq(struct netdev_tc_txq *tc_to_txq,
+					 struct tc_mqprio_qopt *qopt)
+{
+	int tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+		tc_to_txq[tc] = (struct netdev_tc_txq) {
+			.count = qopt->count[tc],
+			.offset = qopt->offset[tc],
+		};
+	}
+}
+
+static void mlx5e_params_mqprio_dcb_set(struct mlx5e_params *params, u8 num_tc)
+{
+	params->mqprio.mode = TC_MQPRIO_MODE_DCB;
+	params->mqprio.num_tc = num_tc;
+	mlx5e_mqprio_build_default_tc_to_txq(params->mqprio.tc_to_txq, num_tc,
+					     params->num_channels);
+}
+
+static void mlx5e_params_mqprio_channel_set(struct mlx5e_params *params,
+					    struct tc_mqprio_qopt *qopt)
+{
+	params->mqprio.mode = TC_MQPRIO_MODE_CHANNEL;
+	params->mqprio.num_tc = qopt->num_tc;
+	mlx5e_mqprio_build_tc_to_txq(params->mqprio.tc_to_txq, qopt);
+}
+
+static void mlx5e_params_mqprio_reset(struct mlx5e_params *params)
+{
+	mlx5e_params_mqprio_dcb_set(params, 1);
+}
+
 static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
 				     struct tc_mqprio_qopt *mqprio)
 {
@@ -2874,8 +2931,7 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
 		return -EINVAL;
 
 	new_params = priv->channels.params;
-	new_params.mqprio.mode = TC_MQPRIO_MODE_DCB;
-	new_params.mqprio.num_tc = tc ? tc : 1;
+	mlx5e_params_mqprio_dcb_set(&new_params, tc ? tc : 1);
 
 	err = mlx5e_safe_switch_params(priv, &new_params,
 				       mlx5e_num_channels_changed_ctx, NULL, true);
@@ -2926,36 +2982,30 @@ static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int mlx5e_mqprio_channel_set_tcs_ctx(struct mlx5e_priv *priv, void *ctx)
-{
-	struct tc_mqprio_qopt_offload *mqprio = (struct tc_mqprio_qopt_offload *)ctx;
-	struct net_device *netdev = priv->netdev;
-	u8 num_tc;
-
-	if (priv->channels.params.mqprio.mode != TC_MQPRIO_MODE_CHANNEL)
-		return -EINVAL;
-
-	num_tc = priv->channels.params.mqprio.num_tc;
-	mlx5e_netdev_set_tcs(netdev, 0, num_tc, mqprio);
-
-	return 0;
-}
-
 static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
 					 struct tc_mqprio_qopt_offload *mqprio)
 {
 	struct mlx5e_params new_params;
+	bool nch_changed;
 	int err;
 
+	nch_changed = mlx5e_get_dcb_num_tc(&priv->channels.params) > 1;
+
 	err = mlx5e_mqprio_channel_validate(priv, mqprio);
 	if (err)
 		return err;
 
 	new_params = priv->channels.params;
-	new_params.mqprio.mode = TC_MQPRIO_MODE_CHANNEL;
-	new_params.mqprio.num_tc = mqprio->qopt.num_tc;
-	err = mlx5e_safe_switch_params(priv, &new_params,
-				       mlx5e_mqprio_channel_set_tcs_ctx, mqprio, true);
+	mlx5e_params_mqprio_channel_set(&new_params, &mqprio->qopt);
+
+	if (nch_changed)
+		err = mlx5e_safe_switch_params(priv, &new_params,
+					       mlx5e_num_channels_changed_ctx,
+					       NULL, true);
+	else
+		err = mlx5e_safe_switch_params(priv, &new_params,
+					       mlx5e_update_netdev_queues_ctx,
+					       NULL, true);
 
 	return err;
 }
@@ -4192,7 +4242,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	params->hard_mtu = MLX5E_ETH_HARD_MTU;
 	params->num_channels = min_t(unsigned int, MLX5E_MAX_NUM_CHANNELS / 2,
 				     priv->max_nch);
-	params->mqprio.num_tc = 1;
+	mlx5e_params_mqprio_reset(params);
 
 	/* Set an initial non-zero value, so that mlx5e_select_queue won't
 	 * divide by zero if called before first activating channels.
@@ -4781,6 +4831,7 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
 	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
 	const struct mlx5e_profile *profile = priv->profile;
+	bool nch_changed = false;
 	int max_nch;
 	int err;
 
@@ -4795,6 +4846,7 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 		 */
 		priv->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 		priv->channels.params.num_channels = max_nch;
+		nch_changed = true;
 	}
 	/* 1. Set the real number of queues in the kernel the first time.
 	 * 2. Set our default XPS cpumask.
@@ -4806,6 +4858,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	 */
 	if (take_rtnl)
 		rtnl_lock();
+	if (nch_changed && priv->channels.params.mqprio.mode == TC_MQPRIO_MODE_CHANNEL) {
+		mlx5_core_warn(priv->mdev, "MLX5E: Num channels changed. Disabling MQPRIO channel mode\n");
+		mlx5e_params_mqprio_reset(&priv->channels.params);
+	}
 	err = mlx5e_num_channels_changed(priv);
 	if (take_rtnl)
 		rtnl_unlock();
-- 
2.31.1

