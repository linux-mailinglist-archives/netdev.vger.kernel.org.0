Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682F456C25
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfFZOgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59872 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727830AbfFZOgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:19 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY6027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 08/16] net/mlx5e: Calculate linear RX frag size considering XSK
Date:   Wed, 26 Jun 2019 17:35:30 +0300
Message-Id: <1561559738-4213-9-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Additional conditions introduced:

- XSK implies XDP.
- Headroom includes the XSK headroom if it exists.
- No space is reserved for struct shared_skb_info in XSK mode.
- Fragment size smaller than the XSK chunk size is not allowed.

A new auxiliary function mlx5e_get_linear_rq_headroom with the support
for XSK is introduced. Use this function in the implementation of
mlx5e_get_rq_headroom. Change headroom to u32 to match the headroom
field in struct xdp_umem.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 65 +++++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  8 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +-
 3 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index d3744bffbae3..50a458dc3836 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -3,33 +3,62 @@
 
 #include "en/params.h"
 
-u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params)
+static inline bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
+				   struct mlx5e_xsk_param *xsk)
 {
-	u16 hw_mtu = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	u16 linear_rq_headroom = params->xdp_prog ?
-		XDP_PACKET_HEADROOM : MLX5_RX_HEADROOM;
-	u32 frag_sz;
+	return params->xdp_prog || xsk;
+}
+
+static inline u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
+					       struct mlx5e_xsk_param *xsk)
+{
+	u16 headroom = NET_IP_ALIGN;
+
+	if (mlx5e_rx_is_xdp(params, xsk)) {
+		headroom += XDP_PACKET_HEADROOM;
+		if (xsk)
+			headroom += xsk->headroom;
+	} else {
+		headroom += MLX5_RX_HEADROOM;
+	}
+
+	return headroom;
+}
+
+u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
+				struct mlx5e_xsk_param *xsk)
+{
+	u32 hw_mtu = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	u16 linear_rq_headroom = mlx5e_get_linear_rq_headroom(params, xsk);
+	u32 frag_sz = linear_rq_headroom + hw_mtu;
 
-	linear_rq_headroom += NET_IP_ALIGN;
+	/* AF_XDP doesn't build SKBs in place. */
+	if (!xsk)
+		frag_sz = MLX5_SKB_FRAG_SZ(frag_sz);
 
-	frag_sz = MLX5_SKB_FRAG_SZ(linear_rq_headroom + hw_mtu);
+	/* XDP in mlx5e doesn't support multiple packets per page. */
+	if (mlx5e_rx_is_xdp(params, xsk))
+		frag_sz = max_t(u32, frag_sz, PAGE_SIZE);
 
-	if (params->xdp_prog && frag_sz < PAGE_SIZE)
-		frag_sz = PAGE_SIZE;
+	/* Even if we can go with a smaller fragment size, we must not put
+	 * multiple packets into a single frame.
+	 */
+	if (xsk)
+		frag_sz = max_t(u32, frag_sz, xsk->chunk_size);
 
 	return frag_sz;
 }
 
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params)
 {
-	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params);
+	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params, NULL);
 
 	return MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(linear_frag_sz);
 }
 
 bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params)
 {
-	u32 frag_sz = mlx5e_rx_get_linear_frag_sz(params);
+	u32 frag_sz = mlx5e_rx_get_linear_frag_sz(params, NULL);
 
 	return !params->lro_en && frag_sz <= PAGE_SIZE;
 }
@@ -39,7 +68,7 @@ bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params)
 bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
 				  struct mlx5e_params *params)
 {
-	u32 frag_sz = mlx5e_rx_get_linear_frag_sz(params);
+	u32 frag_sz = mlx5e_rx_get_linear_frag_sz(params, NULL);
 	s8 signed_log_num_strides_param;
 	u8 log_num_strides;
 
@@ -75,7 +104,7 @@ u8 mlx5e_mpwqe_get_log_stride_size(struct mlx5_core_dev *mdev,
 				   struct mlx5e_params *params)
 {
 	if (mlx5e_rx_mpwqe_is_linear_skb(mdev, params))
-		return order_base_2(mlx5e_rx_get_linear_frag_sz(params));
+		return order_base_2(mlx5e_rx_get_linear_frag_sz(params, NULL));
 
 	return MLX5_MPWRQ_DEF_LOG_STRIDE_SZ(mdev);
 }
@@ -90,15 +119,9 @@ u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
 u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
 			  struct mlx5e_params *params)
 {
-	u16 linear_rq_headroom = params->xdp_prog ?
-		XDP_PACKET_HEADROOM : MLX5_RX_HEADROOM;
-	bool is_linear_skb;
-
-	linear_rq_headroom += NET_IP_ALIGN;
-
-	is_linear_skb = (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) ?
+	bool is_linear_skb = (params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC) ?
 		mlx5e_rx_is_linear_skb(params) :
 		mlx5e_rx_mpwqe_is_linear_skb(mdev, params);
 
-	return is_linear_skb ? linear_rq_headroom : 0;
+	return is_linear_skb ? mlx5e_get_linear_rq_headroom(params, NULL) : 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index b106a0236f36..ed420f3efe52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -6,7 +6,13 @@
 
 #include "en.h"
 
-u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params);
+struct mlx5e_xsk_param {
+	u16 headroom;
+	u16 chunk_size;
+};
+
+u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
+				struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params);
 bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params);
 bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1b427d7fab42..837a973b3507 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1954,7 +1954,7 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	if (mlx5e_rx_is_linear_skb(params)) {
 		int frag_stride;
 
-		frag_stride = mlx5e_rx_get_linear_frag_sz(params);
+		frag_stride = mlx5e_rx_get_linear_frag_sz(params, NULL);
 		frag_stride = roundup_pow_of_two(frag_stride);
 
 		info->arr[0].frag_size = byte_count;
-- 
1.8.3.1

