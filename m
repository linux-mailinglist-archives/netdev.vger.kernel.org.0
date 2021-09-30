Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5734541E4A0
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350118AbhI3XQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhI3XQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA1B061A79;
        Thu, 30 Sep 2021 23:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043704;
        bh=Sva2Ij6ncTbjmo8OD/ZADf4B823LxfXhQdKG55laNhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbMWGU4oloJKl87yDy0/kVQOY4uD0unsiM+qNxGVdWl/0D1dVfKPuGVXgy37GGMLy
         HYi6wxJSwiX4fulQ1lxrCj2g42vmyUeb7fiBNFIqSqf1BxV0Mi0tqfQJMODEet36kv
         wAjHzWlcBB4d6n5eMd6+oR62fp/Q8Ci339p7NAyqSxAECh9pIh3XsRZOxyvOYWivn/
         Zwfb2PwkmIsjQQIQeM5E6L3vXCIpKPS0usWhwgbIFiCHvCo//WlH81svjfPyfAoQaM
         Pv6G1ChxC5NK0W4ammL5+X3USHtynNqJRNECdidLNWT+7Kg8MkkFmSIbr+yJcCoYNj
         Y2541AxaMjXGg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/10] net/mlx5e: Keep the value for maximum number of channels in-sync
Date:   Thu, 30 Sep 2021 16:14:53 -0700
Message-Id: <20210930231501.39062-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The value for maximum number of channels is first calculated based
on the netdev's profile and current function resources (specifically,
number of MSIX vectors, which depends among other things on the number
of online cores in the system).
This value is then used to calculate the netdev's number of rxqs/txqs.
Once created (by alloc_etherdev_mqs), the number of netdev's rxqs/txqs
is constant and we must not exceed it.

To achieve this, keep the maximum number of channels in sync upon any
netdevice re-attach.

Use mlx5e_get_max_num_channels() for calculating the number of netdev's
rxqs/txqs. After netdev is created, use mlx5e_calc_max_nch() (which
coinsiders core device resources, profile, and netdev) to init or
update priv->max_nch.

Before this patch, the value of priv->max_nch might get out of sync,
mistakenly allowing accesses to out-of-bounds objects, which would
crash the system.

Track the number of channels stats structures used in a separate
field, as they are persistent to suspend/resume operations. All the
collected stats of every channel index that ever existed should be
preserved. They are reset only when struct mlx5e_priv is,
in mlx5e_priv_cleanup(), which is part of the profile changing flow.

There is no point anymore in blocking a profile change due to max_nch
mismatch in mlx5e_netdev_change_profile(). Remove the limitation.

Fixes: a1f240f18017 ("net/mlx5e: Adjust to max number of channles when re-attaching")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 11 ++--
 .../mellanox/mlx5/core/en/hv_vhca_stats.c     |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 59 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  4 +-
 6 files changed, 57 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7b8c8187543a..2dca9219ca71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -845,6 +845,7 @@ struct mlx5e_priv {
 	struct mlx5e_channel_stats channel_stats[MLX5E_MAX_NUM_CHANNELS];
 	struct mlx5e_channel_stats trap_stats;
 	struct mlx5e_ptp_stats     ptp_stats;
+	u16                        stats_nch;
 	u16                        max_nch;
 	u8                         max_opened_tc;
 	bool                       tx_ptp_opened;
@@ -1100,12 +1101,6 @@ int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *priv,
 				 struct ethtool_pauseparam *pauseparam);
 
 /* mlx5e generic netdev management API */
-static inline unsigned int
-mlx5e_calc_max_nch(struct mlx5e_priv *priv, const struct mlx5e_profile *profile)
-{
-	return priv->netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
-}
-
 static inline bool
 mlx5e_tx_mpwqe_supported(struct mlx5_core_dev *mdev)
 {
@@ -1114,11 +1109,13 @@ mlx5e_tx_mpwqe_supported(struct mlx5_core_dev *mdev)
 }
 
 int mlx5e_priv_init(struct mlx5e_priv *priv,
+		    const struct mlx5e_profile *profile,
 		    struct net_device *netdev,
 		    struct mlx5_core_dev *mdev);
 void mlx5e_priv_cleanup(struct mlx5e_priv *priv);
 struct net_device *
-mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int rxqs);
+mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
+		    unsigned int txqs, unsigned int rxqs);
 int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
index ac44bbe95c5c..d290d7276b8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
@@ -35,7 +35,7 @@ static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, void *data,
 {
 	int ch, i = 0;
 
-	for (ch = 0; ch < priv->max_nch; ch++) {
+	for (ch = 0; ch < priv->stats_nch; ch++) {
 		void *buf = data + i;
 
 		if (WARN_ON_ONCE(buf +
@@ -51,7 +51,7 @@ static void mlx5e_hv_vhca_fill_stats(struct mlx5e_priv *priv, void *data,
 static int mlx5e_hv_vhca_stats_buf_size(struct mlx5e_priv *priv)
 {
 	return (sizeof(struct mlx5e_hv_vhca_per_ring_stats) *
-		priv->max_nch);
+		priv->stats_nch);
 }
 
 static void mlx5e_hv_vhca_stats_work(struct work_struct *work)
@@ -100,7 +100,7 @@ static void mlx5e_hv_vhca_stats_control(struct mlx5_hv_vhca_agent *agent,
 	sagent = &priv->stats_agent;
 
 	block->version = MLX5_HV_VHCA_STATS_VERSION;
-	block->rings   = priv->max_nch;
+	block->rings   = priv->stats_nch;
 
 	if (!block->command) {
 		cancel_delayed_work_sync(&priv->stats_agent.work);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3fd515e7bf30..774ce88d80cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3065,7 +3065,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 {
 	int i;
 
-	for (i = 0; i < priv->max_nch; i++) {
+	for (i = 0; i < priv->stats_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats = &priv->channel_stats[i];
 		struct mlx5e_rq_stats *xskrq_stats = &channel_stats->xskrq;
 		struct mlx5e_rq_stats *rq_stats = &channel_stats->rq;
@@ -4186,8 +4186,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u8 rx_cq_period_mode;
 
-	priv->max_nch = mlx5e_calc_max_nch(priv, priv->profile);
-
 	params->sw_mtu = mtu;
 	params->hard_mtu = MLX5E_ETH_HARD_MTU;
 	params->num_channels = min_t(unsigned int, MLX5E_MAX_NUM_CHANNELS / 2,
@@ -4682,8 +4680,35 @@ static const struct mlx5e_profile mlx5e_nic_profile = {
 	.rx_ptp_support    = true,
 };
 
+static unsigned int
+mlx5e_calc_max_nch(struct mlx5_core_dev *mdev, struct net_device *netdev,
+		   const struct mlx5e_profile *profile)
+
+{
+	unsigned int max_nch, tmp;
+
+	/* core resources */
+	max_nch = mlx5e_get_max_num_channels(mdev);
+
+	/* netdev rx queues */
+	tmp = netdev->num_rx_queues / max_t(u8, profile->rq_groups, 1);
+	max_nch = min_t(unsigned int, max_nch, tmp);
+
+	/* netdev tx queues */
+	tmp = netdev->num_tx_queues;
+	if (mlx5_qos_is_supported(mdev))
+		tmp -= mlx5e_qos_max_leaf_nodes(mdev);
+	if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
+		tmp -= profile->max_tc;
+	tmp = tmp / profile->max_tc;
+	max_nch = min_t(unsigned int, max_nch, tmp);
+
+	return max_nch;
+}
+
 /* mlx5e generic netdev management API (move to en_common.c) */
 int mlx5e_priv_init(struct mlx5e_priv *priv,
+		    const struct mlx5e_profile *profile,
 		    struct net_device *netdev,
 		    struct mlx5_core_dev *mdev)
 {
@@ -4691,6 +4716,8 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	priv->mdev        = mdev;
 	priv->netdev      = netdev;
 	priv->msglevel    = MLX5E_MSG_LEVEL;
+	priv->max_nch     = mlx5e_calc_max_nch(mdev, netdev, profile);
+	priv->stats_nch   = priv->max_nch;
 	priv->max_opened_tc = 1;
 
 	if (!alloc_cpumask_var(&priv->scratchpad.cpumask, GFP_KERNEL))
@@ -4734,7 +4761,8 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 }
 
 struct net_device *
-mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int rxqs)
+mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
+		    unsigned int txqs, unsigned int rxqs)
 {
 	struct net_device *netdev;
 	int err;
@@ -4745,7 +4773,7 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, unsigned int txqs, unsigned int
 		return NULL;
 	}
 
-	err = mlx5e_priv_init(netdev_priv(netdev), netdev, mdev);
+	err = mlx5e_priv_init(netdev_priv(netdev), profile, netdev, mdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_priv_init failed, err=%d\n", err);
 		goto err_free_netdev;
@@ -4787,7 +4815,7 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
 
 	/* max number of channels may have changed */
-	max_nch = mlx5e_get_max_num_channels(priv->mdev);
+	max_nch = mlx5e_calc_max_nch(priv->mdev, priv->netdev, profile);
 	if (priv->channels.params.num_channels > max_nch) {
 		mlx5_core_warn(priv->mdev, "MLX5E: Reducing number of channels to %d\n", max_nch);
 		/* Reducing the number of channels - RXFH has to be reset, and
@@ -4796,6 +4824,13 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 		priv->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 		priv->channels.params.num_channels = max_nch;
 	}
+	if (max_nch != priv->max_nch) {
+		mlx5_core_warn(priv->mdev,
+			       "MLX5E: Updating max number of channels from %u to %u\n",
+			       priv->max_nch, max_nch);
+		priv->max_nch = max_nch;
+	}
+
 	/* 1. Set the real number of queues in the kernel the first time.
 	 * 2. Set our default XPS cpumask.
 	 * 3. Build the RQT.
@@ -4860,7 +4895,7 @@ mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mde
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	int err;
 
-	err = mlx5e_priv_init(priv, netdev, mdev);
+	err = mlx5e_priv_init(priv, new_profile, netdev, mdev);
 	if (err) {
 		mlx5_core_err(mdev, "mlx5e_priv_init failed, err=%d\n", err);
 		return err;
@@ -4886,20 +4921,12 @@ mlx5e_netdev_attach_profile(struct net_device *netdev, struct mlx5_core_dev *mde
 int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 				const struct mlx5e_profile *new_profile, void *new_ppriv)
 {
-	unsigned int new_max_nch = mlx5e_calc_max_nch(priv, new_profile);
 	const struct mlx5e_profile *orig_profile = priv->profile;
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	void *orig_ppriv = priv->ppriv;
 	int err, rollback_err;
 
-	/* sanity */
-	if (new_max_nch != priv->max_nch) {
-		netdev_warn(netdev, "%s: Replacing profile with different max channels\n",
-			    __func__);
-		return -EINVAL;
-	}
-
 	/* cleanup old profile */
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
@@ -4995,7 +5022,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	nch = mlx5e_get_max_num_channels(mdev);
 	txqs = nch * profile->max_tc + ptp_txqs + qos_sqs;
 	rxqs = nch * profile->rq_groups;
-	netdev = mlx5e_create_netdev(mdev, txqs, rxqs);
+	netdev = mlx5e_create_netdev(mdev, profile, txqs, rxqs);
 	if (!netdev) {
 		mlx5_core_err(mdev, "mlx5e_create_netdev failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index ae71a17fdb27..3dd1101cc693 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -596,7 +596,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
 					 MLX5_CQ_PERIOD_MODE_START_FROM_CQE :
 					 MLX5_CQ_PERIOD_MODE_START_FROM_EQE;
 
-	priv->max_nch = mlx5e_calc_max_nch(priv, priv->profile);
 	params = &priv->channels.params;
 
 	params->num_channels = MLX5E_REP_PARAMS_DEF_NUM_CHANNELS;
@@ -1169,7 +1168,7 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	nch = mlx5e_get_max_num_channels(dev);
 	txqs = nch * profile->max_tc;
 	rxqs = nch * profile->rq_groups;
-	netdev = mlx5e_create_netdev(dev, txqs, rxqs);
+	netdev = mlx5e_create_netdev(dev, profile, txqs, rxqs);
 	if (!netdev) {
 		mlx5_core_warn(dev,
 			       "Failed to create representor netdev for vport %d\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e4f5b6395148..46bf78169f63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -450,7 +450,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 
 	memset(s, 0, sizeof(*s));
 
-	for (i = 0; i < priv->max_nch; i++) {
+	for (i = 0; i < priv->stats_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =
 			&priv->channel_stats[i];
 		int j;
@@ -2119,7 +2119,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ptp) { return; }
 
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(channels)
 {
-	int max_nch = priv->max_nch;
+	int max_nch = priv->stats_nch;
 
 	return (NUM_RQ_STATS * max_nch) +
 	       (NUM_CH_STATS * max_nch) +
@@ -2133,7 +2133,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(channels)
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(channels)
 {
 	bool is_xsk = priv->xsk.ever_used;
-	int max_nch = priv->max_nch;
+	int max_nch = priv->stats_nch;
 	int i, j, tc;
 
 	for (i = 0; i < max_nch; i++)
@@ -2175,7 +2175,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(channels)
 static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(channels)
 {
 	bool is_xsk = priv->xsk.ever_used;
-	int max_nch = priv->max_nch;
+	int max_nch = priv->stats_nch;
 	int i, j, tc;
 
 	for (i = 0; i < max_nch; i++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 67571e5040d6..269ebb53eda6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -113,7 +113,7 @@ static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 	struct mlx5e_sw_stats s = { 0 };
 	int i, j;
 
-	for (i = 0; i < priv->max_nch; i++) {
+	for (i = 0; i < priv->stats_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats;
 		struct mlx5e_rq_stats *rq_stats;
 
@@ -711,7 +711,7 @@ static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u32 port_num,
 			goto destroy_ht;
 	}
 
-	err = mlx5e_priv_init(epriv, netdev, mdev);
+	err = mlx5e_priv_init(epriv, prof, netdev, mdev);
 	if (err)
 		goto destroy_mdev_resources;
 
-- 
2.31.1

