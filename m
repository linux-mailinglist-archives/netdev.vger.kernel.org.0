Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B472738E0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgIVCr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgIVCrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:49 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A69023A62;
        Tue, 22 Sep 2020 02:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742869;
        bh=Gx0biYxiZjwn5wdT19TceKMDV/Z1aNiLq3Y74DPGBVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDQ/dNuFBS5C4TFElwAWMmhSz3LoIzFfaQhCcGGT9VDJZvZ2dPiXcTAjcd8O7Ylm5
         SU8NRDtHLROzSUOx31zM+LN29wK1Wa/KJAnyXlXUEqYEP36pebHoVXyMMgzSJd3fn+
         fzOYoxkSa66AouwQ6JxQxVOYKf2QmEUeJXYKUKiM=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 09/12] net/mlx5e: Generalize TX MPWQE checks for full session
Date:   Mon, 21 Sep 2020 19:47:01 -0700
Message-Id: <20200922024704.544482-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As preparation for the upcoming TX MPWQE for SKBs, create a function
(mlx5e_tx_mpwqe_is_full) to check whether an MPWQE session is full. This
function will be shared by MPWQE code for XDP and for SKBs. Defines are
renamed and moved to make them not XDP-specific.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  | 18 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h   | 18 ++----------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 03fe92323f48..b4ee1f2f1746 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -9,6 +9,19 @@
 
 #define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 
+/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
+ * (16 * 4 == 64) does not fit in the 6-bit DS field of Ctrl Segment.
+ * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
+ * full-session WQE be cache-aligned.
+ */
+#if L1_CACHE_BYTES < 128
+#define MLX5E_TX_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
+#else
+#define MLX5E_TX_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
+#endif
+
+#define MLX5E_TX_MPW_MAX_NUM_DS (MLX5E_TX_MPW_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS)
+
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
 enum mlx5e_icosq_wqe_type {
@@ -266,6 +279,11 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more);
 
+static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_xdp_mpwqe *session)
+{
+	return session->ds_count == MLX5E_TX_MPW_MAX_NUM_DS;
+}
+
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 {
 	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 737e88d49e89..2a72496ceda9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -199,7 +199,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
 
-	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
+	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(wqe->data);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 96d6b1553bab..0dc38acab5a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -45,20 +45,6 @@
 	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
 	 sizeof(struct mlx5_wqe_inline_seg))
 
-/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
- * (16 * 4 == 64) does not fit in the 6-bit DS field of Ctrl Segment.
- * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
- * full-session WQE be cache-aligned.
- */
-#if L1_CACHE_BYTES < 128
-#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
-#else
-#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
-#endif
-
-#define MLX5E_XDP_MPW_MAX_NUM_DS \
-	(MLX5E_XDP_MPW_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS)
-
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
@@ -141,8 +127,8 @@ static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session)
 {
 	if (session->inline_on)
 		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
-		       MLX5E_XDP_MPW_MAX_NUM_DS;
-	return session->ds_count == MLX5E_XDP_MPW_MAX_NUM_DS;
+		       MLX5E_TX_MPW_MAX_NUM_DS;
+	return mlx5e_tx_mpwqe_is_full(session);
 }
 
 struct mlx5e_xdp_wqe_info {
-- 
2.26.2

