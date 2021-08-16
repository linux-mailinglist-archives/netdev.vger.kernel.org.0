Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFDC3EDF3E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhHPVUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhHPVTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B60361056;
        Mon, 16 Aug 2021 21:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629148746;
        bh=fWp3DU7/Q2wSKNInrN9A5rkm+BLu4O8GyOG54rLEMFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaoU8AXHFFUTF4PFYk3KIoCK7Zl/1UqFyflsLDpjz1oFAXSjIt5RLyumEgb6BTXVw
         1cLoK2ivj7mxRgb5Vxh+4HB5OoLTNDteA7DCv7EdZF3PQIE7fsXjqErfBLkFdUM2Zc
         z4mMSi9ztGqQx0TtEJnxmIHMoDIK9uQvrfPbDzurHUECzzzuCfYiril1QtHJZDu3mm
         OFr0fNq0GR7g1mqR7o/wOmzuuMKVs3JmXQwd2WnTb380C+b04hBqNDzXI0g1iorVsc
         +qO49u6E0WSShhhumHRZ454MANFgejn6cpIKGnuQXPlbI8t8Wy/yhC4KfUws9yJHpE
         gAWLin2lt+9+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/17] net/mlx5e: Support MQPRIO channel mode
Date:   Mon, 16 Aug 2021 14:18:41 -0700
Message-Id: <20210816211847.526937-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816211847.526937-1-saeed@kernel.org>
References: <20210816211847.526937-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Add support for MQPRIO channel mode, in which a partition to TCs
is defined over the channels. We allow partitions with contiguous
queue indices, with no holes within. We do not allow modification
to the num of channels while this MQPRIO mode is active.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 99 +++++++++++++++++--
 3 files changed, 102 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3dbcb2cf2ff8..669a75f3537a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -72,6 +72,7 @@ struct page_pool;
 #define MLX5E_SW2HW_MTU(params, swmtu) ((swmtu) + ((params)->hard_mtu))
 
 #define MLX5E_MAX_NUM_TC	8
+#define MLX5E_MAX_NUM_MQPRIO_CH_TC TC_QOPT_MAX_QUEUE
 
 #define MLX5_RX_HEADROOM NET_SKB_PAD
 #define MLX5_SKB_FRAG_SZ(len)	(SKB_DATA_ALIGN(len) +	\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 839a753fda32..5696d3f1baaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -467,6 +467,16 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 		goto out;
 	}
 
+	/* Don't allow changing the number of channels if MQPRIO mode channel offload is active,
+	 * because it defines a partition over the channels queues.
+	 */
+	if (cur_params->mqprio.mode == TC_MQPRIO_MODE_CHANNEL) {
+		err = -EINVAL;
+		netdev_err(priv->netdev, "%s: MQPRIO mode channel offload is active, cannot change the number of channels\n",
+			   __func__);
+		goto out;
+	}
+
 	new_params = *cur_params;
 	new_params.num_channels = count;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f5c89a00214d..26d2f78c7706 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2263,7 +2263,8 @@ void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv)
 				ETH_MAX_MTU);
 }
 
-static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc)
+static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc,
+				struct tc_mqprio_qopt_offload *mqprio)
 {
 	int tc, err;
 
@@ -2278,11 +2279,16 @@ static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc)
 		return err;
 	}
 
-	/* Map netdev TCs to offset 0
-	 * We have our own UP to TXQ mapping for QoS
-	 */
-	for (tc = 0; tc < ntc; tc++)
-		netdev_set_tc_queue(netdev, tc, nch, 0);
+	for (tc = 0; tc < ntc; tc++) {
+		u16 count, offset;
+
+		/* For DCB mode, map netdev TCs to offset 0
+		 * We have our own UP to TXQ mapping for QoS
+		 */
+		count = mqprio ? mqprio->qopt.count[tc] : nch;
+		offset = mqprio ? mqprio->qopt.offset[tc] : 0;
+		netdev_set_tc_queue(netdev, tc, count, offset);
+	}
 
 	return 0;
 }
@@ -2321,7 +2327,7 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
 	num_rxqs = nch * priv->profile->rq_groups;
 
-	err = mlx5e_netdev_set_tcs(netdev, nch, ntc);
+	err = mlx5e_netdev_set_tcs(netdev, nch, ntc, NULL);
 	if (err)
 		goto err_out;
 	err = mlx5e_update_tx_netdev_queues(priv);
@@ -2344,7 +2350,7 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	WARN_ON_ONCE(netif_set_real_num_tx_queues(netdev, old_num_txqs));
 
 err_tcs:
-	mlx5e_netdev_set_tcs(netdev, old_num_txqs / old_ntc, old_ntc);
+	mlx5e_netdev_set_tcs(netdev, old_num_txqs / old_ntc, old_ntc, NULL);
 err_out:
 	return err;
 }
@@ -2879,6 +2885,81 @@ static int mlx5e_setup_tc_mqprio_dcb(struct mlx5e_priv *priv,
 	return err;
 }
 
+static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
+					 struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct net_device *netdev = priv->netdev;
+	int agg_count = 0;
+	int i;
+
+	if (mqprio->qopt.offset[0] != 0 || mqprio->qopt.num_tc < 1 ||
+	    mqprio->qopt.num_tc > MLX5E_MAX_NUM_MQPRIO_CH_TC)
+		return -EINVAL;
+
+	for (i = 0; i < mqprio->qopt.num_tc; i++) {
+		if (!mqprio->qopt.count[i]) {
+			netdev_err(netdev, "Zero size for queue-group (%d) is not supported\n", i);
+			return -EINVAL;
+		}
+		if (mqprio->min_rate[i]) {
+			netdev_err(netdev, "Min tx rate is not supported\n");
+			return -EINVAL;
+		}
+		if (mqprio->max_rate[i]) {
+			netdev_err(netdev, "Max tx rate is not supported\n");
+			return -EINVAL;
+		}
+
+		if (mqprio->qopt.offset[i] != agg_count) {
+			netdev_err(netdev, "Discontinuous queues config is not supported\n");
+			return -EINVAL;
+		}
+		agg_count += mqprio->qopt.count[i];
+	}
+
+	if (priv->channels.params.num_channels < agg_count) {
+		netdev_err(netdev, "Num of queues (%d) exceeds available (%d)\n",
+			   agg_count, priv->channels.params.num_channels);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mlx5e_mqprio_channel_set_tcs_ctx(struct mlx5e_priv *priv, void *ctx)
+{
+	struct tc_mqprio_qopt_offload *mqprio = (struct tc_mqprio_qopt_offload *)ctx;
+	struct net_device *netdev = priv->netdev;
+	u8 num_tc;
+
+	if (priv->channels.params.mqprio.mode != TC_MQPRIO_MODE_CHANNEL)
+		return -EINVAL;
+
+	num_tc = priv->channels.params.mqprio.num_tc;
+	mlx5e_netdev_set_tcs(netdev, 0, num_tc, mqprio);
+
+	return 0;
+}
+
+static int mlx5e_setup_tc_mqprio_channel(struct mlx5e_priv *priv,
+					 struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct mlx5e_params new_params;
+	int err;
+
+	err = mlx5e_mqprio_channel_validate(priv, mqprio);
+	if (err)
+		return err;
+
+	new_params = priv->channels.params;
+	new_params.mqprio.mode = TC_MQPRIO_MODE_CHANNEL;
+	new_params.mqprio.num_tc = mqprio->qopt.num_tc;
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_mqprio_channel_set_tcs_ctx, mqprio, true);
+
+	return err;
+}
+
 static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 				 struct tc_mqprio_qopt_offload *mqprio)
 {
@@ -2891,6 +2972,8 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	switch (mqprio->mode) {
 	case TC_MQPRIO_MODE_DCB:
 		return mlx5e_setup_tc_mqprio_dcb(priv, &mqprio->qopt);
+	case TC_MQPRIO_MODE_CHANNEL:
+		return mlx5e_setup_tc_mqprio_channel(priv, mqprio);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.31.1

