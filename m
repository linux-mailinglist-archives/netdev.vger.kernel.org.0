Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512B756C24
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfFZOgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59965 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728041AbfFZOgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:22 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:17 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGYB027430;
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
Subject: [PATCH bpf-next V6 13/16] net/mlx5e: Consider XSK in XDP MTU limit calculation
Date:   Wed, 26 Jun 2019 17:35:35 +0300
Message-Id: <1561559738-4213-14-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Use the existing mlx5e_get_linear_rq_headroom function to calculate the
headroom for mlx5e_xdp_max_mtu. This function takes the XSK headroom
into consideration, which will be used in the following patches.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h    | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 ++--
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 50a458dc3836..0de908b12fcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -9,8 +9,8 @@ static inline bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 	return params->xdp_prog || xsk;
 }
 
-static inline u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
-					       struct mlx5e_xsk_param *xsk)
+u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
+				 struct mlx5e_xsk_param *xsk)
 {
 	u16 headroom = NET_IP_ALIGN;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index ed420f3efe52..7f29b82dd8c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -11,6 +11,8 @@ struct mlx5e_xsk_param {
 	u16 chunk_size;
 };
 
+u16 mlx5e_get_linear_rq_headroom(struct mlx5e_params *params,
+				 struct mlx5e_xsk_param *xsk);
 u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
 				struct mlx5e_xsk_param *xsk);
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 1364bdff702c..ee99efde9143 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -32,10 +32,11 @@
 
 #include <linux/bpf_trace.h>
 #include "en/xdp.h"
+#include "en/params.h"
 
-int mlx5e_xdp_max_mtu(struct mlx5e_params *params)
+int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
 {
-	int hr = NET_IP_ALIGN + XDP_PACKET_HEADROOM;
+	int hr = mlx5e_get_linear_rq_headroom(params, xsk);
 
 	/* Let S := SKB_DATA_ALIGN(sizeof(struct skb_shared_info)).
 	 * The condition checked in mlx5e_rx_is_linear_skb is:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 86db5ad49a42..9200cb9f499b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -39,7 +39,8 @@
 	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 #define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */)
 
-int mlx5e_xdp_max_mtu(struct mlx5e_params *params);
+struct mlx5e_xsk_param;
+int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		      void *va, u16 *rx_headroom, u32 *len);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index abc1d0f6cf53..96fb3fa32d63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3722,7 +3722,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	if (params->xdp_prog &&
 	    !mlx5e_rx_is_linear_skb(&new_channels.params)) {
 		netdev_err(netdev, "MTU(%d) > %d is not allowed while XDP enabled\n",
-			   new_mtu, mlx5e_xdp_max_mtu(params));
+			   new_mtu, mlx5e_xdp_max_mtu(params, NULL));
 		err = -EINVAL;
 		goto out;
 	}
@@ -4167,7 +4167,7 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 	if (!mlx5e_rx_is_linear_skb(&new_channels.params)) {
 		netdev_warn(netdev, "XDP is not allowed with MTU(%d) > %d\n",
 			    new_channels.params.sw_mtu,
-			    mlx5e_xdp_max_mtu(&new_channels.params));
+			    mlx5e_xdp_max_mtu(&new_channels.params, NULL));
 		return -EINVAL;
 	}
 
-- 
1.8.3.1

