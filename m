Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669F7349FF7
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCZCyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230501AbhCZCxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B718E61A43;
        Fri, 26 Mar 2021 02:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727230;
        bh=Ufv898jpmYbmz6RJGwgGqTA6Akji7qMBKJIuCFT4MD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6/Mv+2u3q8RKiiB1i6V8i0C6W76clO5ikN13vT/Cpx/K9N0SvAd1moASURjK2iSK
         SYYk39qA2xKHtE85hZJXDR8qICKaEs1Ff1JV3fZVNZ54weTSKHz6F55IhNGzHY2/RS
         rX+I9G/XiZBmopKu67Yrceh0uav2krI0WLLxfW0yq0q7dM6uGpT+E1fWJwDY+zDEVs
         EijkySMB5RWfiQk5ofWb+rlOYeKFi/DkzCU+XMTx2HTsWzf4of1ZMhMn8vGnAF5a6d
         ikUS01uI6gRMCUmniwngSI5pqSr90GmNroy4NtUsoyKnIbPdarv8nPL9ITOvSa7lmY
         lCfOIPZF56Rpg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/13] net/mlx5e: Move params logic into its dedicated file
Date:   Thu, 25 Mar 2021 19:53:35 -0700
Message-Id: <20210326025345.456475-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326025345.456475-1-saeed@kernel.org>
References: <20210326025345.456475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Take params logic out of en_main.c, into the dedicated params.c.
Some functions are now hidden and become static.
No functional change here.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  12 -
 .../ethernet/mellanox/mlx5/core/en/params.c   | 482 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/params.h   |  30 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 454 -----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   1 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   1 +
 6 files changed, 497 insertions(+), 483 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 9ea3f3befe74..d1fca0670b12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -919,8 +919,6 @@ struct mlx5e_profile {
 void mlx5e_build_ptys2ethtool_map(void);
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
-bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
-				struct mlx5e_params *params);
 
 void mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s);
@@ -1024,14 +1022,6 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_build_default_indir_rqt(u32 *indirection_rqt, int len,
 				   int num_channels);
 
-void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
-void mlx5e_reset_rx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
-void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
-void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
-
-void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
-void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
-			       struct mlx5e_params *params);
 int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_state);
 void mlx5e_activate_rq(struct mlx5e_rq *rq);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
@@ -1177,8 +1167,6 @@ int mlx5e_netdev_change_profile(struct mlx5e_priv *priv,
 void mlx5e_netdev_attach_nic_profile(struct mlx5e_priv *priv);
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv);
 void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16 mtu);
-void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
-			   struct mlx5e_params *params);
 void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 			    u16 num_channels);
 void mlx5e_rx_dim_work(struct work_struct *work);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 36381a2ed5a5..3a22f5760f3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -3,10 +3,12 @@
 
 #include "en/params.h"
 #include "en/txrx.h"
-#include "en_accel/tls_rxtx.h"
+#include "en/port.h"
+#include "en_accel/en_accel.h"
+#include "accel/ipsec.h"
 
-static inline bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
-				   struct mlx5e_xsk_param *xsk)
+static bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
+			    struct mlx5e_xsk_param *xsk)
 {
 	return params->xdp_prog || xsk;
 }
@@ -37,8 +39,8 @@ u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
 	return linear_rq_headroom + hw_mtu;
 }
 
-u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
-				struct mlx5e_xsk_param *xsk)
+static u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
+				       struct mlx5e_xsk_param *xsk)
 {
 	u32 frag_sz = mlx5e_rx_get_min_frag_sz(params, xsk);
 
@@ -186,3 +188,473 @@ int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *params)
 
 	return 0;
 }
+
+static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
+{
+	struct dim_cq_moder moder;
+
+	moder.cq_period_mode = cq_period_mode;
+	moder.pkts = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_PKTS;
+	moder.usec = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_USEC;
+	if (cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE)
+		moder.usec = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_USEC_FROM_CQE;
+
+	return moder;
+}
+
+static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8 cq_period_mode)
+{
+	struct dim_cq_moder moder;
+
+	moder.cq_period_mode = cq_period_mode;
+	moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;
+	moder.usec = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_USEC;
+	if (cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE)
+		moder.usec = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_USEC_FROM_CQE;
+
+	return moder;
+}
+
+static u8 mlx5_to_net_dim_cq_period_mode(u8 cq_period_mode)
+{
+	return cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE ?
+		DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+}
+
+void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode)
+{
+	if (params->tx_dim_enabled) {
+		u8 dim_period_mode = mlx5_to_net_dim_cq_period_mode(cq_period_mode);
+
+		params->tx_cq_moderation = net_dim_get_def_tx_moderation(dim_period_mode);
+	} else {
+		params->tx_cq_moderation = mlx5e_get_def_tx_moderation(cq_period_mode);
+	}
+}
+
+void mlx5e_reset_rx_moderation(struct mlx5e_params *params, u8 cq_period_mode)
+{
+	if (params->rx_dim_enabled) {
+		u8 dim_period_mode = mlx5_to_net_dim_cq_period_mode(cq_period_mode);
+
+		params->rx_cq_moderation = net_dim_get_def_rx_moderation(dim_period_mode);
+	} else {
+		params->rx_cq_moderation = mlx5e_get_def_rx_moderation(cq_period_mode);
+	}
+}
+
+void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
+{
+	mlx5e_reset_tx_moderation(params, cq_period_mode);
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
+			params->tx_cq_moderation.cq_period_mode ==
+				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
+}
+
+void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
+{
+	mlx5e_reset_rx_moderation(params, cq_period_mode);
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_BASED_MODER,
+			params->rx_cq_moderation.cq_period_mode ==
+				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
+}
+
+bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
+{
+	u32 link_speed = 0;
+	u32 pci_bw = 0;
+
+	mlx5e_port_max_linkspeed(mdev, &link_speed);
+	pci_bw = pcie_bandwidth_available(mdev->pdev, NULL, NULL, NULL);
+	mlx5_core_dbg_once(mdev, "Max link speed = %d, PCI BW = %d\n",
+			   link_speed, pci_bw);
+
+#define MLX5E_SLOW_PCI_RATIO (2)
+
+	return link_speed && pci_bw &&
+		link_speed > MLX5E_SLOW_PCI_RATIO * pci_bw;
+}
+
+bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
+				struct mlx5e_params *params)
+{
+	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
+		return false;
+
+	if (MLX5_IPSEC_DEV(mdev))
+		return false;
+
+	if (params->xdp_prog) {
+		/* XSK params are not considered here. If striding RQ is in use,
+		 * and an XSK is being opened, mlx5e_rx_mpwqe_is_linear_skb will
+		 * be called with the known XSK params.
+		 */
+		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
+			return false;
+	}
+
+	return true;
+}
+
+void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
+			       struct mlx5e_params *params)
+{
+	params->log_rq_mtu_frames = is_kdump_kernel() ?
+		MLX5E_PARAMS_MINIMUM_LOG_RQ_SIZE :
+		MLX5E_PARAMS_DEFAULT_LOG_RQ_SIZE;
+
+	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d)\n",
+		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ,
+		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
+		       BIT(mlx5e_mpwqe_get_log_rq_size(params, NULL)) :
+		       BIT(params->log_rq_mtu_frames),
+		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL)),
+		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS));
+}
+
+void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
+{
+	params->rq_wq_type = mlx5e_striding_rq_possible(mdev, params) &&
+		MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) ?
+		MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ :
+		MLX5_WQ_TYPE_CYCLIC;
+}
+
+void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
+			   struct mlx5e_params *params)
+{
+	/* Prefer Striding RQ, unless any of the following holds:
+	 * - Striding RQ configuration is not possible/supported.
+	 * - Slow PCI heuristic.
+	 * - Legacy RQ would use linear SKB while Striding RQ would use non-linear.
+	 *
+	 * No XSK params: checking the availability of striding RQ in general.
+	 */
+	if (!slow_pci_heuristic(mdev) &&
+	    mlx5e_striding_rq_possible(mdev, params) &&
+	    (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ||
+	     !mlx5e_rx_is_linear_skb(params, NULL)))
+		MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ, true);
+	mlx5e_set_rq_type(mdev, params);
+	mlx5e_init_rq_type_params(mdev, params);
+}
+
+/* Build queue parameters */
+
+void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e_channel *c)
+{
+	*ccp = (struct mlx5e_create_cq_param) {
+		.napi = &c->napi,
+		.ch_stats = c->stats,
+		.node = cpu_to_node(c->cpu),
+		.ix = c->ix,
+	};
+}
+
+#define DEFAULT_FRAG_SIZE (2048)
+
+static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
+				      struct mlx5e_params *params,
+				      struct mlx5e_xsk_param *xsk,
+				      struct mlx5e_rq_frags_info *info)
+{
+	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	int frag_size_max = DEFAULT_FRAG_SIZE;
+	u32 buf_size = 0;
+	int i;
+
+	if (MLX5_IPSEC_DEV(mdev))
+		byte_count += MLX5E_METADATA_ETHER_LEN;
+
+	if (mlx5e_rx_is_linear_skb(params, xsk)) {
+		int frag_stride;
+
+		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
+		frag_stride = roundup_pow_of_two(frag_stride);
+
+		info->arr[0].frag_size = byte_count;
+		info->arr[0].frag_stride = frag_stride;
+		info->num_frags = 1;
+		info->wqe_bulk = PAGE_SIZE / frag_stride;
+		goto out;
+	}
+
+	if (byte_count > PAGE_SIZE +
+	    (MLX5E_MAX_RX_FRAGS - 1) * frag_size_max)
+		frag_size_max = PAGE_SIZE;
+
+	i = 0;
+	while (buf_size < byte_count) {
+		int frag_size = byte_count - buf_size;
+
+		if (i < MLX5E_MAX_RX_FRAGS - 1)
+			frag_size = min(frag_size, frag_size_max);
+
+		info->arr[i].frag_size = frag_size;
+		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
+
+		buf_size += frag_size;
+		i++;
+	}
+	info->num_frags = i;
+	/* number of different wqes sharing a page */
+	info->wqe_bulk = 1 + (info->num_frags % 2);
+
+out:
+	info->wqe_bulk = max_t(u8, info->wqe_bulk, 8);
+	info->log_num_frags = order_base_2(info->num_frags);
+}
+
+static u8 mlx5e_get_rqwq_log_stride(u8 wq_type, int ndsegs)
+{
+	int sz = sizeof(struct mlx5_wqe_data_seg) * ndsegs;
+
+	switch (wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		sz += sizeof(struct mlx5e_rx_wqe_ll);
+		break;
+	default: /* MLX5_WQ_TYPE_CYCLIC */
+		sz += sizeof(struct mlx5e_rx_wqe_cyc);
+	}
+
+	return order_base_2(sz);
+}
+
+static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
+					struct mlx5e_cq_param *param)
+{
+	void *cqc = param->cqc;
+
+	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
+	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
+		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
+}
+
+static void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
+				    struct mlx5e_params *params,
+				    struct mlx5e_xsk_param *xsk,
+				    struct mlx5e_cq_param *param)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	bool hw_stridx = false;
+	void *cqc = param->cqc;
+	u8 log_cq_size;
+
+	switch (params->rq_wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
+			mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
+		hw_stridx = MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index);
+		break;
+	default: /* MLX5_WQ_TYPE_CYCLIC */
+		log_cq_size = params->log_rq_mtu_frames;
+	}
+
+	MLX5_SET(cqc, cqc, log_cq_size, log_cq_size);
+	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
+		MLX5_SET(cqc, cqc, mini_cqe_res_format, hw_stridx ?
+			 MLX5_CQE_FORMAT_CSUM_STRIDX : MLX5_CQE_FORMAT_CSUM);
+		MLX5_SET(cqc, cqc, cqe_comp_en, 1);
+	}
+
+	mlx5e_build_common_cq_param(priv, param);
+	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
+}
+
+void mlx5e_build_rq_param(struct mlx5e_priv *priv,
+			  struct mlx5e_params *params,
+			  struct mlx5e_xsk_param *xsk,
+			  u16 q_counter,
+			  struct mlx5e_rq_param *param)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	void *rqc = param->rqc;
+	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
+	int ndsegs = 1;
+
+	switch (params->rq_wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		MLX5_SET(wq, wq, log_wqe_num_of_strides,
+			 mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk) -
+			 MLX5_MPWQE_LOG_NUM_STRIDES_BASE);
+		MLX5_SET(wq, wq, log_wqe_stride_size,
+			 mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk) -
+			 MLX5_MPWQE_LOG_STRIDE_SZ_BASE);
+		MLX5_SET(wq, wq, log_wq_sz, mlx5e_mpwqe_get_log_rq_size(params, xsk));
+		break;
+	default: /* MLX5_WQ_TYPE_CYCLIC */
+		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
+		mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
+		ndsegs = param->frags_info.num_frags;
+	}
+
+	MLX5_SET(wq, wq, wq_type,          params->rq_wq_type);
+	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+	MLX5_SET(wq, wq, log_wq_stride,
+		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
+	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(rqc, rqc, counter_set_id, q_counter);
+	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
+	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
+
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
+	mlx5e_build_rx_cq_param(priv, params, xsk, &param->cqp);
+}
+
+void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
+			       u16 q_counter,
+			       struct mlx5e_rq_param *param)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	void *rqc = param->rqc;
+	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
+
+	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
+	MLX5_SET(wq, wq, log_wq_stride,
+		 mlx5e_get_rqwq_log_stride(MLX5_WQ_TYPE_CYCLIC, 1));
+	MLX5_SET(rqc, rqc, counter_set_id, q_counter);
+
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
+}
+
+void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_cq_param *param)
+{
+	void *cqc = param->cqc;
+
+	MLX5_SET(cqc, cqc, log_cq_size, params->log_sq_size);
+
+	mlx5e_build_common_cq_param(priv, param);
+	param->cq_period_mode = params->tx_cq_moderation.cq_period_mode;
+}
+
+void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
+				 struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
+	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.hw_objs.pdn);
+
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
+}
+
+void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
+			  struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+	bool allow_swp;
+
+	allow_swp = mlx5_geneve_tx_allowed(priv->mdev) ||
+		    !!MLX5_IPSEC_DEV(priv->mdev);
+	mlx5e_build_sq_param_common(priv, param);
+	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
+	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
+	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
+	param->stop_room = mlx5e_calc_sq_stop_room(priv->mdev, params);
+	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
+}
+
+static void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
+				     u8 log_wq_size,
+				     struct mlx5e_cq_param *param)
+{
+	void *cqc = param->cqc;
+
+	MLX5_SET(cqc, cqc, log_cq_size, log_wq_size);
+
+	mlx5e_build_common_cq_param(priv, param);
+
+	param->cq_period_mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+}
+
+static u8 mlx5e_get_rq_log_wq_sz(void *rqc)
+{
+	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
+
+	return MLX5_GET(wq, wq, log_wq_sz);
+}
+
+static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
+				      struct mlx5e_rq_param *rqp)
+{
+	switch (params->rq_wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE,
+			     order_base_2(MLX5E_UMR_WQEBBS) +
+			     mlx5e_get_rq_log_wq_sz(rqp->rqc));
+	default: /* MLX5_WQ_TYPE_CYCLIC */
+		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
+	}
+}
+
+static u8 mlx5e_build_async_icosq_log_wq_sz(struct net_device *netdev)
+{
+	if (netdev->hw_features & NETIF_F_HW_TLS_RX)
+		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
+
+	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
+}
+
+static void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
+				    u8 log_wq_size,
+				    struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	mlx5e_build_sq_param_common(priv, param);
+
+	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
+	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
+	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
+}
+
+static void mlx5e_build_async_icosq_param(struct mlx5e_priv *priv,
+					  u8 log_wq_size,
+					  struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	mlx5e_build_sq_param_common(priv, param);
+	param->stop_room = mlx5e_stop_room_for_wqe(1); /* for XSK NOP */
+	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
+	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
+	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
+}
+
+void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
+			     struct mlx5e_params *params,
+			     struct mlx5e_sq_param *param)
+{
+	void *sqc = param->sqc;
+	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	mlx5e_build_sq_param_common(priv, param);
+	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
+	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
+	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
+}
+
+void mlx5e_build_channel_param(struct mlx5e_priv *priv,
+			       struct mlx5e_params *params,
+			       u16 q_counter,
+			       struct mlx5e_channel_param *cparam)
+{
+	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
+
+	mlx5e_build_rq_param(priv, params, NULL, q_counter, &cparam->rq);
+
+	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
+	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(priv->netdev);
+
+	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
+	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
+	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
+	mlx5e_build_async_icosq_param(priv, async_icosq_log_wq_sz, &cparam->async_icosq);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 97a5bf50a53b..a43776e8a86b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -84,12 +84,21 @@ static inline bool mlx5e_qid_validate(const struct mlx5e_profile *profile,
 
 /* Parameter calculations */
 
+void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
+void mlx5e_reset_rx_moderation(struct mlx5e_params *params, u8 cq_period_mode);
+void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
+void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode);
+
+bool slow_pci_heuristic(struct mlx5_core_dev *mdev);
+bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+void mlx5e_build_rq_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
+
 u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
 				 struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
 			     struct mlx5e_xsk_param *xsk);
-u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
-				struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
 				struct mlx5e_xsk_param *xsk);
 bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
@@ -117,26 +126,23 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 			  struct mlx5e_xsk_param *xsk,
 			  u16 q_counter,
 			  struct mlx5e_rq_param *param);
+void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
+			       u16 q_counter,
+			       struct mlx5e_rq_param *param);
 void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
 				 struct mlx5e_sq_param *param);
 void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
 			  struct mlx5e_sq_param *param);
-void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_xsk_param *xsk,
-			     struct mlx5e_cq_param *param);
 void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
 			     struct mlx5e_params *params,
 			     struct mlx5e_cq_param *param);
-void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
-			      u8 log_wq_size,
-			      struct mlx5e_cq_param *param);
-void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
-			     u8 log_wq_size,
-			     struct mlx5e_sq_param *param);
 void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
 			     struct mlx5e_params *params,
 			     struct mlx5e_sq_param *param);
+void mlx5e_build_channel_param(struct mlx5e_priv *priv,
+			       struct mlx5e_params *params,
+			       u16 q_counter,
+			       struct mlx5e_channel_param *cparam);
 
 u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *params);
 int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6aae2bce32f3..efa4ba1f7260 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -87,51 +87,6 @@ bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 	return true;
 }
 
-void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
-			       struct mlx5e_params *params)
-{
-	params->log_rq_mtu_frames = is_kdump_kernel() ?
-		MLX5E_PARAMS_MINIMUM_LOG_RQ_SIZE :
-		MLX5E_PARAMS_DEFAULT_LOG_RQ_SIZE;
-
-	mlx5_core_info(mdev, "MLX5E: StrdRq(%d) RqSz(%ld) StrdSz(%ld) RxCqeCmprss(%d)\n",
-		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ,
-		       params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
-		       BIT(mlx5e_mpwqe_get_log_rq_size(params, NULL)) :
-		       BIT(params->log_rq_mtu_frames),
-		       BIT(mlx5e_mpwqe_get_log_stride_size(mdev, params, NULL)),
-		       MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS));
-}
-
-bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
-				struct mlx5e_params *params)
-{
-	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
-		return false;
-
-	if (mlx5_fpga_is_ipsec_device(mdev))
-		return false;
-
-	if (params->xdp_prog) {
-		/* XSK params are not considered here. If striding RQ is in use,
-		 * and an XSK is being opened, mlx5e_rx_mpwqe_is_linear_skb will
-		 * be called with the known XSK params.
-		 */
-		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
-			return false;
-	}
-
-	return true;
-}
-
-void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
-{
-	params->rq_wq_type = mlx5e_striding_rq_possible(mdev, params) &&
-		MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ) ?
-		MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ :
-		MLX5_WQ_TYPE_CYCLIC;
-}
-
 void mlx5e_update_carrier(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -1860,16 +1815,6 @@ static int mlx5e_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 	return err;
 }
 
-void mlx5e_build_create_cq_param(struct mlx5e_create_cq_param *ccp, struct mlx5e_channel *c)
-{
-	*ccp = (struct mlx5e_create_cq_param) {
-		.napi = &c->napi,
-		.ch_stats = c->stats,
-		.node = cpu_to_node(c->cpu),
-		.ix = c->ix,
-	};
-}
-
 static int mlx5e_open_queues(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
 			     struct mlx5e_channel_param *cparam)
@@ -2111,299 +2056,6 @@ static void mlx5e_close_channel(struct mlx5e_channel *c)
 	kvfree(c);
 }
 
-#define DEFAULT_FRAG_SIZE (2048)
-
-static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
-				      struct mlx5e_params *params,
-				      struct mlx5e_xsk_param *xsk,
-				      struct mlx5e_rq_frags_info *info)
-{
-	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	int frag_size_max = DEFAULT_FRAG_SIZE;
-	u32 buf_size = 0;
-	int i;
-
-	if (mlx5_fpga_is_ipsec_device(mdev))
-		byte_count += MLX5E_METADATA_ETHER_LEN;
-
-	if (mlx5e_rx_is_linear_skb(params, xsk)) {
-		int frag_stride;
-
-		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
-		frag_stride = roundup_pow_of_two(frag_stride);
-
-		info->arr[0].frag_size = byte_count;
-		info->arr[0].frag_stride = frag_stride;
-		info->num_frags = 1;
-		info->wqe_bulk = PAGE_SIZE / frag_stride;
-		goto out;
-	}
-
-	if (byte_count > PAGE_SIZE +
-	    (MLX5E_MAX_RX_FRAGS - 1) * frag_size_max)
-		frag_size_max = PAGE_SIZE;
-
-	i = 0;
-	while (buf_size < byte_count) {
-		int frag_size = byte_count - buf_size;
-
-		if (i < MLX5E_MAX_RX_FRAGS - 1)
-			frag_size = min(frag_size, frag_size_max);
-
-		info->arr[i].frag_size = frag_size;
-		info->arr[i].frag_stride = roundup_pow_of_two(frag_size);
-
-		buf_size += frag_size;
-		i++;
-	}
-	info->num_frags = i;
-	/* number of different wqes sharing a page */
-	info->wqe_bulk = 1 + (info->num_frags % 2);
-
-out:
-	info->wqe_bulk = max_t(u8, info->wqe_bulk, 8);
-	info->log_num_frags = order_base_2(info->num_frags);
-}
-
-static inline u8 mlx5e_get_rqwq_log_stride(u8 wq_type, int ndsegs)
-{
-	int sz = sizeof(struct mlx5_wqe_data_seg) * ndsegs;
-
-	switch (wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		sz += sizeof(struct mlx5e_rx_wqe_ll);
-		break;
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		sz += sizeof(struct mlx5e_rx_wqe_cyc);
-	}
-
-	return order_base_2(sz);
-}
-
-static u8 mlx5e_get_rq_log_wq_sz(void *rqc)
-{
-	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
-
-	return MLX5_GET(wq, wq, log_wq_sz);
-}
-
-void mlx5e_build_rq_param(struct mlx5e_priv *priv,
-			  struct mlx5e_params *params,
-			  struct mlx5e_xsk_param *xsk,
-			  u16 q_counter,
-			  struct mlx5e_rq_param *param)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqc = param->rqc;
-	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
-	int ndsegs = 1;
-
-	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		MLX5_SET(wq, wq, log_wqe_num_of_strides,
-			 mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk) -
-			 MLX5_MPWQE_LOG_NUM_STRIDES_BASE);
-		MLX5_SET(wq, wq, log_wqe_stride_size,
-			 mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk) -
-			 MLX5_MPWQE_LOG_STRIDE_SZ_BASE);
-		MLX5_SET(wq, wq, log_wq_sz, mlx5e_mpwqe_get_log_rq_size(params, xsk));
-		break;
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
-		mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
-		ndsegs = param->frags_info.num_frags;
-	}
-
-	MLX5_SET(wq, wq, wq_type,          params->rq_wq_type);
-	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
-	MLX5_SET(wq, wq, log_wq_stride,
-		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
-	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.hw_objs.pdn);
-	MLX5_SET(rqc, rqc, counter_set_id, q_counter);
-	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
-	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
-
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
-	mlx5e_build_rx_cq_param(priv, params, xsk, &param->cqp);
-}
-
-static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
-				      u16 q_counter,
-				      struct mlx5e_rq_param *param)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	void *rqc = param->rqc;
-	void *wq = MLX5_ADDR_OF(rqc, rqc, wq);
-
-	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
-	MLX5_SET(wq, wq, log_wq_stride,
-		 mlx5e_get_rqwq_log_stride(MLX5_WQ_TYPE_CYCLIC, 1));
-	MLX5_SET(rqc, rqc, counter_set_id, q_counter);
-
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
-}
-
-void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
-				 struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
-	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.hw_objs.pdn);
-
-	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
-}
-
-void mlx5e_build_sq_param(struct mlx5e_priv *priv, struct mlx5e_params *params,
-			  struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-	bool allow_swp;
-
-	allow_swp = mlx5_geneve_tx_allowed(priv->mdev) ||
-		    !!MLX5_IPSEC_DEV(priv->mdev);
-	mlx5e_build_sq_param_common(priv, param);
-	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
-	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
-	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
-	param->stop_room = mlx5e_calc_sq_stop_room(priv->mdev, params);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
-}
-
-static void mlx5e_build_common_cq_param(struct mlx5e_priv *priv,
-					struct mlx5e_cq_param *param)
-{
-	void *cqc = param->cqc;
-
-	MLX5_SET(cqc, cqc, uar_page, priv->mdev->priv.uar->index);
-	if (MLX5_CAP_GEN(priv->mdev, cqe_128_always) && cache_line_size() >= 128)
-		MLX5_SET(cqc, cqc, cqe_sz, CQE_STRIDE_128_PAD);
-}
-
-void mlx5e_build_rx_cq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_xsk_param *xsk,
-			     struct mlx5e_cq_param *param)
-{
-	struct mlx5_core_dev *mdev = priv->mdev;
-	bool hw_stridx = false;
-	void *cqc = param->cqc;
-	u8 log_cq_size;
-
-	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		log_cq_size = mlx5e_mpwqe_get_log_rq_size(params, xsk) +
-			mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk);
-		hw_stridx = MLX5_CAP_GEN(mdev, mini_cqe_resp_stride_index);
-		break;
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		log_cq_size = params->log_rq_mtu_frames;
-	}
-
-	MLX5_SET(cqc, cqc, log_cq_size, log_cq_size);
-	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		MLX5_SET(cqc, cqc, mini_cqe_res_format, hw_stridx ?
-			 MLX5_CQE_FORMAT_CSUM_STRIDX : MLX5_CQE_FORMAT_CSUM);
-		MLX5_SET(cqc, cqc, cqe_comp_en, 1);
-	}
-
-	mlx5e_build_common_cq_param(priv, param);
-	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
-}
-
-void mlx5e_build_tx_cq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_cq_param *param)
-{
-	void *cqc = param->cqc;
-
-	MLX5_SET(cqc, cqc, log_cq_size, params->log_sq_size);
-
-	mlx5e_build_common_cq_param(priv, param);
-	param->cq_period_mode = params->tx_cq_moderation.cq_period_mode;
-}
-
-void mlx5e_build_ico_cq_param(struct mlx5e_priv *priv,
-			      u8 log_wq_size,
-			      struct mlx5e_cq_param *param)
-{
-	void *cqc = param->cqc;
-
-	MLX5_SET(cqc, cqc, log_cq_size, log_wq_size);
-
-	mlx5e_build_common_cq_param(priv, param);
-
-	param->cq_period_mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
-}
-
-void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
-			     u8 log_wq_size,
-			     struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	mlx5e_build_sq_param_common(priv, param);
-
-	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
-	MLX5_SET(sqc, sqc, reg_umr, MLX5_CAP_ETH(priv->mdev, reg_umr_sq));
-	mlx5e_build_ico_cq_param(priv, log_wq_size, &param->cqp);
-}
-
-void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
-			     struct mlx5e_params *params,
-			     struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	mlx5e_build_sq_param_common(priv, param);
-	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
-	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE);
-	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
-}
-
-static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5e_params *params,
-				      struct mlx5e_rq_param *rqp)
-{
-	switch (params->rq_wq_type) {
-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
-		return max_t(u8, MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE,
-			     order_base_2(MLX5E_UMR_WQEBBS) +
-			     mlx5e_get_rq_log_wq_sz(rqp->rqc));
-	default: /* MLX5_WQ_TYPE_CYCLIC */
-		return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
-	}
-}
-
-static u8 mlx5e_build_async_icosq_log_wq_sz(struct net_device *netdev)
-{
-	if (netdev->hw_features & NETIF_F_HW_TLS_RX)
-		return MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
-
-	return MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
-}
-
-static void mlx5e_build_channel_param(struct mlx5e_priv *priv,
-				      struct mlx5e_params *params,
-				      u16 q_counter,
-				      struct mlx5e_channel_param *cparam)
-{
-	u8 icosq_log_wq_sz, async_icosq_log_wq_sz;
-
-	mlx5e_build_rq_param(priv, params, NULL, q_counter, &cparam->rq);
-
-	icosq_log_wq_sz = mlx5e_build_icosq_log_wq_sz(params, &cparam->rq);
-	async_icosq_log_wq_sz = mlx5e_build_async_icosq_log_wq_sz(priv->netdev);
-
-	mlx5e_build_sq_param(priv, params, &cparam->txq_sq);
-	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
-	mlx5e_build_icosq_param(priv, icosq_log_wq_sz, &cparam->icosq);
-	mlx5e_build_icosq_param(priv, async_icosq_log_wq_sz, &cparam->async_icosq);
-}
-
 int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs)
 {
@@ -4887,93 +4539,6 @@ void mlx5e_build_default_indir_rqt(u32 *indirection_rqt, int len,
 		indirection_rqt[i] = i % num_channels;
 }
 
-static bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
-{
-	u32 link_speed = 0;
-	u32 pci_bw = 0;
-
-	mlx5e_port_max_linkspeed(mdev, &link_speed);
-	pci_bw = pcie_bandwidth_available(mdev->pdev, NULL, NULL, NULL);
-	mlx5_core_dbg_once(mdev, "Max link speed = %d, PCI BW = %d\n",
-			   link_speed, pci_bw);
-
-#define MLX5E_SLOW_PCI_RATIO (2)
-
-	return link_speed && pci_bw &&
-		link_speed > MLX5E_SLOW_PCI_RATIO * pci_bw;
-}
-
-static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
-{
-	struct dim_cq_moder moder;
-
-	moder.cq_period_mode = cq_period_mode;
-	moder.pkts = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_PKTS;
-	moder.usec = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_USEC;
-	if (cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE)
-		moder.usec = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_USEC_FROM_CQE;
-
-	return moder;
-}
-
-static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8 cq_period_mode)
-{
-	struct dim_cq_moder moder;
-
-	moder.cq_period_mode = cq_period_mode;
-	moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;
-	moder.usec = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_USEC;
-	if (cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE)
-		moder.usec = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_USEC_FROM_CQE;
-
-	return moder;
-}
-
-static u8 mlx5_to_net_dim_cq_period_mode(u8 cq_period_mode)
-{
-	return cq_period_mode == MLX5_CQ_PERIOD_MODE_START_FROM_CQE ?
-		DIM_CQ_PERIOD_MODE_START_FROM_CQE :
-		DIM_CQ_PERIOD_MODE_START_FROM_EQE;
-}
-
-void mlx5e_reset_tx_moderation(struct mlx5e_params *params, u8 cq_period_mode)
-{
-	if (params->tx_dim_enabled) {
-		u8 dim_period_mode = mlx5_to_net_dim_cq_period_mode(cq_period_mode);
-
-		params->tx_cq_moderation = net_dim_get_def_tx_moderation(dim_period_mode);
-	} else {
-		params->tx_cq_moderation = mlx5e_get_def_tx_moderation(cq_period_mode);
-	}
-}
-
-void mlx5e_reset_rx_moderation(struct mlx5e_params *params, u8 cq_period_mode)
-{
-	if (params->rx_dim_enabled) {
-		u8 dim_period_mode = mlx5_to_net_dim_cq_period_mode(cq_period_mode);
-
-		params->rx_cq_moderation = net_dim_get_def_rx_moderation(dim_period_mode);
-	} else {
-		params->rx_cq_moderation = mlx5e_get_def_rx_moderation(cq_period_mode);
-	}
-}
-
-void mlx5e_set_tx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
-{
-	mlx5e_reset_tx_moderation(params, cq_period_mode);
-	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
-			params->tx_cq_moderation.cq_period_mode ==
-				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
-}
-
-void mlx5e_set_rx_cq_mode_params(struct mlx5e_params *params, u8 cq_period_mode)
-{
-	mlx5e_reset_rx_moderation(params, cq_period_mode);
-	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_BASED_MODER,
-			params->rx_cq_moderation.cq_period_mode ==
-				MLX5_CQ_PERIOD_MODE_START_FROM_CQE);
-}
-
 static u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeout)
 {
 	int i;
@@ -4986,25 +4551,6 @@ static u32 mlx5e_choose_lro_timeout(struct mlx5_core_dev *mdev, u32 wanted_timeo
 	return MLX5_CAP_ETH(mdev, lro_timer_supported_periods[i]);
 }
 
-void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
-			   struct mlx5e_params *params)
-{
-	/* Prefer Striding RQ, unless any of the following holds:
-	 * - Striding RQ configuration is not possible/supported.
-	 * - Slow PCI heuristic.
-	 * - Legacy RQ would use linear SKB while Striding RQ would use non-linear.
-	 *
-	 * No XSK params: checking the availability of striding RQ in general.
-	 */
-	if (!slow_pci_heuristic(mdev) &&
-	    mlx5e_striding_rq_possible(mdev, params) &&
-	    (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL) ||
-	     !mlx5e_rx_is_linear_skb(params, NULL)))
-		MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ, true);
-	mlx5e_set_rq_type(mdev, params);
-	mlx5e_init_rq_type_params(mdev, params);
-}
-
 void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 			    u16 num_channels)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4cc902e0d71b..e5123e9182c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -40,6 +40,7 @@
 #include "eswitch.h"
 #include "en.h"
 #include "en_rep.h"
+#include "en/params.h"
 #include "en/txrx.h"
 #include "en_tc.h"
 #include "en/rep/tc.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 48303286c133..79f26b56e0a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -33,6 +33,7 @@
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/fs.h>
 #include "en.h"
+#include "en/params.h"
 #include "ipoib.h"
 
 #define IB_DEFAULT_Q_KEY   0xb1b
-- 
2.30.2

