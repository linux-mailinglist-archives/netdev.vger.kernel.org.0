Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A892738D7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgIVCrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbgIVCro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:44 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2EC923A9F;
        Tue, 22 Sep 2020 02:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742863;
        bh=eex6rKsZcA08Gn1Kw741+qxXq32/IlmkfziIHL+nym0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoutZH9q4LvaupvL2TsSx+FZJ+pQcsOUfpSE4nI4ofh6gH3UQHy1a8NeffPOB2hku
         LY+ogWJazRRF8vRi8r59RJZwwA7AfAWW2zcZEgJ33JN4L58nwXXaaSLdn98tLz1NLp
         CqvUaq6hxS535uGnp5T1rXYny5QH4Yza488mPbBo=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 05/12] net/mlx5e: Small improvements for XDP TX MPWQE logic
Date:   Mon, 21 Sep 2020 19:46:57 -0700
Message-Id: <20200922024704.544482-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Use MLX5E_XDP_MPW_MAX_WQEBBS to reserve space for a MPWQE, because it's
actually the maximal size a MPWQE can take.

Reorganize the logic that checks when to close the MPWQE session:

1. Put all checks into a single function.

2. When inline is on, make only one comparison - if it's false, the less
strict one will also be false. The compiler probably optimized it out
anyway, but it's clearer to also reflect it in the code.

The MLX5E_XDP_INLINE_WQE_* defines are also changed to make the
calculations more correct from the logical point of view. Though
MLX5E_XDP_INLINE_WQE_MAX_DS_CNT used to be 16 and didn't change its
value, the calculation used to be DIV_ROUND_UP(max inline packet size,
MLX5_SEND_WQE_DS), and the numerator should have included sizeof(struct
mlx5_wqe_inline_seg).

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h | 16 +++++++++-------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 145592788de5..7fccd2ea7dc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -198,7 +198,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 	u16 pi;
 
-	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5_SEND_WQE_MAX_WQEBBS);
+	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
 	session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	net_prefetchw(session->wqe->data);
@@ -284,8 +284,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *x
 
 	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
 
-	if (unlikely(mlx5e_xdp_no_room_for_inline_pkt(session) ||
-		     session->ds_count == MLX5E_XDP_MPW_MAX_NUM_DS))
+	if (unlikely(mlx5e_xdp_mpqwe_is_full(session)))
 		mlx5e_xdp_mpwqe_complete(sq);
 
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index e806c13d491f..615bf04f4a54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -42,9 +42,10 @@
 	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 #define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */)
 
-#define MLX5E_XDP_INLINE_WQE_SZ_THRSD (256 - sizeof(struct mlx5_wqe_inline_seg))
-#define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT \
-	DIV_ROUND_UP(MLX5E_XDP_INLINE_WQE_SZ_THRSD, MLX5_SEND_WQE_DS)
+#define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT 16
+#define MLX5E_XDP_INLINE_WQE_SZ_THRSD \
+	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
+	 sizeof(struct mlx5_wqe_inline_seg))
 
 /* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
  * (16 * 4 == 64) does not fit in the 6-bit DS field of Ctrl Segment.
@@ -141,11 +142,12 @@ static inline void mlx5e_xdp_update_inline_state(struct mlx5e_xdpsq *sq)
 		session->inline_on = 1;
 }
 
-static inline bool
-mlx5e_xdp_no_room_for_inline_pkt(struct mlx5e_xdp_mpwqe *session)
+static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session)
 {
-	return session->inline_on &&
-	       session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT > MLX5E_XDP_MPW_MAX_NUM_DS;
+	if (session->inline_on)
+		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
+		       MLX5E_XDP_MPW_MAX_NUM_DS;
+	return session->ds_count == MLX5E_XDP_MPW_MAX_NUM_DS;
 }
 
 struct mlx5e_xdp_wqe_info {
-- 
2.26.2

