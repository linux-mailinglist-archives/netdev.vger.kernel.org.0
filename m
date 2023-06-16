Return-Path: <netdev+bounces-11598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD40733A95
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82A731C20B66
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB3721067;
	Fri, 16 Jun 2023 20:11:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D841ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC9FC433C8;
	Fri, 16 Jun 2023 20:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946302;
	bh=uRYa8PnQbFH4dNF83hhmbx2aFmSCUUjjdlbCOllwRjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juQ2qz3Vy3cyunZG81GMoFy3VzQtPJ5SE6Xbc15rukeSLDk5EhBAzdDRqMD/Kmt86
	 mC7Q/oyCnxy+GfB+C3+5B27hnPdx5j0NJsKMri5zHICSy7Kid4mey0MmaRcBNo3hyN
	 jdexza2xbkGMA8PUOd4j0GvvmuZIodK5VCKx5PcH/deZ4tqQ3+6W/Uj7h4xXgavINS
	 OmmmIcZ7hc84JjKHm2WDzN4/a3zMHXGIalTiHfJRd0M9JXI76SZGD2X4IFmBmELPPn
	 OSsi2jRxDrJid0qe/pqHGs0kmEWLSu37dQ3o0VRL4Wp+gOvAz/P++vCV52Qu0uHHkC
	 4Y+3NSreo4zLw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Remove mlx5e_dbg() and msglvl support
Date: Fri, 16 Jun 2023 13:11:07 -0700
Message-Id: <20230616201113.45510-10-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gal Pressman <gal@nvidia.com>

The msglvl support was implemented using the mlx5e_dbg() macro which is
rarely used in the driver, and is not very useful when you can just use
dynamic debug instead.
Remove mlx5e_dbg() and convert its usages to netdev_dbg().

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 10 -----
 .../mellanox/mlx5/core/en/port_buffer.c       | 44 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |  8 ++--
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    | 26 +++++------
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 18 ++------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  5 +--
 6 files changed, 45 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ceabe57c511a..b1807bfb815f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -165,15 +165,6 @@ struct page_pool;
 #define MLX5E_MAX_KLM_PER_WQE(mdev) \
 	MLX5E_KLM_ENTRIES_PER_WQE(MLX5_SEND_WQE_BB * mlx5e_get_max_sq_aligned_wqebbs(mdev))
 
-#define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
-
-#define mlx5e_dbg(mlevel, priv, format, ...)                    \
-do {                                                            \
-	if (NETIF_MSG_##mlevel & (priv)->msglevel)              \
-		netdev_warn(priv->netdev, format,               \
-			    ##__VA_ARGS__);                     \
-} while (0)
-
 #define mlx5e_state_dereference(priv, p) \
 	rcu_dereference_protected((p), lockdep_is_held(&(priv)->state_lock))
 
@@ -880,7 +871,6 @@ struct mlx5e_priv {
 #endif
 	/* priv data path fields - end */
 
-	u32                        msglevel;
 	unsigned long              state;
 	struct mutex               state_lock; /* Protects Interface state */
 	struct mlx5e_rq            drop_rq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 7e8e96cc5cd0..8e25f4ef5ccc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -65,12 +65,13 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 			MLX5_GET(bufferx_reg, buffer, xoff_threshold) * port_buff_cell_sz;
 		total_used += port_buffer->buffer[i].size;
 
-		mlx5e_dbg(HW, priv, "buffer %d: size=%d, xon=%d, xoff=%d, epsb=%d, lossy=%d\n", i,
-			  port_buffer->buffer[i].size,
-			  port_buffer->buffer[i].xon,
-			  port_buffer->buffer[i].xoff,
-			  port_buffer->buffer[i].epsb,
-			  port_buffer->buffer[i].lossy);
+		netdev_dbg(priv->netdev, "buffer %d: size=%d, xon=%d, xoff=%d, epsb=%d, lossy=%d\n",
+			   i,
+			   port_buffer->buffer[i].size,
+			   port_buffer->buffer[i].xon,
+			   port_buffer->buffer[i].xoff,
+			   port_buffer->buffer[i].epsb,
+			   port_buffer->buffer[i].lossy);
 	}
 
 	port_buffer->internal_buffers_size = 0;
@@ -87,11 +88,11 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 					 port_buffer->internal_buffers_size -
 					 port_buffer->headroom_size;
 
-	mlx5e_dbg(HW, priv,
-		  "total buffer size=%u, headroom buffer size=%u, internal buffers size=%u, spare buffer size=%u\n",
-		  port_buffer->port_buffer_size, port_buffer->headroom_size,
-		  port_buffer->internal_buffers_size,
-		  port_buffer->spare_buffer_size);
+	netdev_dbg(priv->netdev,
+		   "total buffer size=%u, headroom buffer size=%u, internal buffers size=%u, spare buffer size=%u\n",
+		   port_buffer->port_buffer_size, port_buffer->headroom_size,
+		   port_buffer->internal_buffers_size,
+		   port_buffer->spare_buffer_size);
 out:
 	kfree(out);
 	return err;
@@ -352,7 +353,7 @@ static u32 calculate_xoff(struct mlx5e_priv *priv, unsigned int mtu)
 
 	xoff = (301 + 216 * priv->dcbx.cable_len / 100) * speed / 1000 + 272 * mtu / 100;
 
-	mlx5e_dbg(HW, priv, "%s: xoff=%d\n", __func__, xoff);
+	netdev_dbg(priv->netdev, "%s: xoff=%d\n", __func__, xoff);
 	return xoff;
 }
 
@@ -484,6 +485,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 				    u8 *prio2buffer)
 {
 	u16 port_buff_cell_sz = priv->dcbx.port_buff_cell_sz;
+	struct net_device *netdev = priv->netdev;
 	struct mlx5e_port_buffer port_buffer;
 	u32 xoff = calculate_xoff(priv, mtu);
 	bool update_prio2buffer = false;
@@ -495,7 +497,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 	int err;
 	int i;
 
-	mlx5e_dbg(HW, priv, "%s: change=%x\n", __func__, change);
+	netdev_dbg(netdev, "%s: change=%x\n", __func__, change);
 	max_mtu = max_t(unsigned int, priv->netdev->max_mtu, MINIMUM_MAX_MTU);
 
 	err = mlx5e_port_query_buffer(priv, &port_buffer);
@@ -510,8 +512,8 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 	}
 
 	if (change & MLX5E_PORT_BUFFER_PFC) {
-		mlx5e_dbg(HW, priv, "%s: requested PFC per priority bitmask: 0x%x\n",
-			  __func__, pfc->pfc_en);
+		netdev_dbg(netdev, "%s: requested PFC per priority bitmask: 0x%x\n",
+			   __func__, pfc->pfc_en);
 		err = mlx5e_port_query_priority2buffer(priv->mdev, buffer);
 		if (err)
 			return err;
@@ -526,8 +528,8 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 	if (change & MLX5E_PORT_BUFFER_PRIO2BUFFER) {
 		update_prio2buffer = true;
 		for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++)
-			mlx5e_dbg(HW, priv, "%s: requested to map prio[%d] to buffer %d\n",
-				  __func__, i, prio2buffer[i]);
+			netdev_dbg(priv->netdev, "%s: requested to map prio[%d] to buffer %d\n",
+				   __func__, i, prio2buffer[i]);
 
 		err = fill_pfc_en(priv->mdev, &curr_pfc_en);
 		if (err)
@@ -541,10 +543,10 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 
 	if (change & MLX5E_PORT_BUFFER_SIZE) {
 		for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
-			mlx5e_dbg(HW, priv, "%s: buffer[%d]=%d\n", __func__, i, buffer_size[i]);
+			netdev_dbg(priv->netdev, "%s: buffer[%d]=%d\n", __func__, i, buffer_size[i]);
 			if (!port_buffer.buffer[i].lossy && !buffer_size[i]) {
-				mlx5e_dbg(HW, priv, "%s: lossless buffer[%d] size cannot be zero\n",
-					  __func__, i);
+				netdev_dbg(priv->netdev, "%s: lossless buffer[%d] size cannot be zero\n",
+					   __func__, i);
 				return -EINVAL;
 			}
 
@@ -552,7 +554,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 			total_used += buffer_size[i];
 		}
 
-		mlx5e_dbg(HW, priv, "%s: total buffer requested=%d\n", __func__, total_used);
+		netdev_dbg(priv->netdev, "%s: total buffer requested=%d\n", __func__, total_used);
 
 		if (total_used > port_buffer.headroom_size &&
 		    (total_used - port_buffer.headroom_size) >
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index bed0c2d043e7..933a7772a7a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -570,10 +570,10 @@ static struct mlx5_flow_handle *arfs_add_rule(struct mlx5e_priv *priv,
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->channel_stats[arfs_rule->rxq]->rq.arfs_err++;
-		mlx5e_dbg(HW, priv,
-			  "%s: add rule(filter id=%d, rq idx=%d, ip proto=0x%x) failed,err=%d\n",
-			  __func__, arfs_rule->filter_id, arfs_rule->rxq,
-			  tuple->ip_proto, err);
+		netdev_dbg(priv->netdev,
+			   "%s: add rule(filter id=%d, rq idx=%d, ip proto=0x%x) failed,err=%d\n",
+			   __func__, arfs_rule->filter_id, arfs_rule->rxq,
+			   tuple->ip_proto, err);
 	}
 
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index ebee52a8361a..8705cffc747f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -275,10 +275,10 @@ static int mlx5e_dcbnl_ieee_setets_core(struct mlx5e_priv *priv, struct ieee_ets
 	memcpy(priv->dcbx.tc_tsa, ets->tc_tsa, sizeof(ets->tc_tsa));
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		mlx5e_dbg(HW, priv, "%s: prio_%d <=> tc_%d\n",
-			  __func__, i, ets->prio_tc[i]);
-		mlx5e_dbg(HW, priv, "%s: tc_%d <=> tx_bw_%d%%, group_%d\n",
-			  __func__, i, tc_tx_bw[i], tc_group[i]);
+		netdev_dbg(priv->netdev, "%s: prio_%d <=> tc_%d\n",
+			   __func__, i, ets->prio_tc[i]);
+		netdev_dbg(priv->netdev, "%s: tc_%d <=> tx_bw_%d%%, group_%d\n",
+			   __func__, i, tc_tx_bw[i], tc_group[i]);
 	}
 
 	return err;
@@ -399,9 +399,9 @@ static int mlx5e_dcbnl_ieee_setpfc(struct net_device *dev,
 	}
 
 	if (!ret) {
-		mlx5e_dbg(HW, priv,
-			  "%s: PFC per priority bit mask: 0x%x\n",
-			  __func__, pfc->pfc_en);
+		netdev_dbg(dev,
+			   "%s: PFC per priority bit mask: 0x%x\n",
+			   __func__, pfc->pfc_en);
 	}
 	return ret;
 }
@@ -611,8 +611,8 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	}
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		mlx5e_dbg(HW, priv, "%s: tc_%d <=> max_bw %d Gbps\n",
-			  __func__, i, max_bw_value[i]);
+		netdev_dbg(netdev, "%s: tc_%d <=> max_bw %d Gbps\n",
+			   __func__, i, max_bw_value[i]);
 	}
 
 	return mlx5_modify_port_ets_rate_limit(mdev, max_bw_value, max_bw_unit);
@@ -640,10 +640,10 @@ static u8 mlx5e_dcbnl_setall(struct net_device *netdev)
 		ets.tc_rx_bw[i] = cee_cfg->pg_bw_pct[i];
 		ets.tc_tsa[i]   = IEEE_8021QAZ_TSA_ETS;
 		ets.prio_tc[i]  = cee_cfg->prio_to_pg_map[i];
-		mlx5e_dbg(HW, priv,
-			  "%s: Priority group %d: tx_bw %d, rx_bw %d, prio_tc %d\n",
-			  __func__, i, ets.tc_tx_bw[i], ets.tc_rx_bw[i],
-			  ets.prio_tc[i]);
+		netdev_dbg(netdev,
+			   "%s: Priority group %d: tx_bw %d, rx_bw %d, prio_tc %d\n",
+			   __func__, i, ets.tc_tx_bw[i], ets.tc_rx_bw[i],
+			   ets.prio_tc[i]);
 	}
 
 	err = mlx5e_dbcnl_validate_ets(netdev, &ets, true);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 1f5a2110d31f..27861b68ced5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1689,16 +1689,6 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 	return 0;
 }
 
-static u32 mlx5e_get_msglevel(struct net_device *dev)
-{
-	return ((struct mlx5e_priv *)netdev_priv(dev))->msglevel;
-}
-
-static void mlx5e_set_msglevel(struct net_device *dev, u32 val)
-{
-	((struct mlx5e_priv *)netdev_priv(dev))->msglevel = val;
-}
-
 static int mlx5e_set_phys_id(struct net_device *dev,
 			     enum ethtool_phys_id_state state)
 {
@@ -1952,9 +1942,9 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (err)
 		return err;
 
-	mlx5e_dbg(DRV, priv, "MLX5E: RxCqeCmprss was turned %s\n",
-		  MLX5E_GET_PFLAG(&priv->channels.params,
-				  MLX5E_PFLAG_RX_CQE_COMPRESS) ? "ON" : "OFF");
+	netdev_dbg(priv->netdev, "MLX5E: RxCqeCmprss was turned %s\n",
+		   MLX5E_GET_PFLAG(&priv->channels.params,
+				   MLX5E_PFLAG_RX_CQE_COMPRESS) ? "ON" : "OFF");
 
 	return 0;
 }
@@ -2444,8 +2434,6 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_priv_flags    = mlx5e_get_priv_flags,
 	.set_priv_flags    = mlx5e_set_priv_flags,
 	.self_test         = mlx5e_self_test,
-	.get_msglevel      = mlx5e_get_msglevel,
-	.set_msglevel      = mlx5e_set_msglevel,
 	.get_fec_stats     = mlx5e_get_fec_stats,
 	.get_fecparam      = mlx5e_get_fecparam,
 	.set_fecparam      = mlx5e_set_fecparam,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a7c526ee5024..c564ac86ff8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2401,7 +2401,7 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 	/* Asymmetric dynamic memory allocation.
 	 * Freed in mlx5e_priv_arrays_free, not on channel closure.
 	 */
-	mlx5e_dbg(DRV, priv, "Creating channel stats %d\n", ix);
+	netdev_dbg(priv->netdev, "Creating channel stats %d\n", ix);
 	priv->channel_stats[ix] = kvzalloc_node(sizeof(**priv->channel_stats),
 						GFP_KERNEL, cpu_to_node(cpu));
 	if (!priv->channel_stats[ix])
@@ -2779,7 +2779,7 @@ int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
 	if (MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_TX_PORT_TS))
 		num_txqs += ntc;
 
-	mlx5e_dbg(DRV, priv, "Setting num_txqs %d\n", num_txqs);
+	netdev_dbg(priv->netdev, "Setting num_txqs %d\n", num_txqs);
 	err = netif_set_real_num_tx_queues(priv->netdev, num_txqs);
 	if (err)
 		netdev_warn(priv->netdev, "netif_set_real_num_tx_queues failed, %d\n", err);
@@ -5585,7 +5585,6 @@ int mlx5e_priv_init(struct mlx5e_priv *priv,
 	/* priv init */
 	priv->mdev        = mdev;
 	priv->netdev      = netdev;
-	priv->msglevel    = MLX5E_MSG_LEVEL;
 	priv->max_nch     = nch;
 	priv->max_opened_tc = 1;
 
-- 
2.40.1


