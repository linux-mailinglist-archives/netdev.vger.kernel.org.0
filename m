Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4425D334768
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhCJTEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233717AbhCJTDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53AB64FCE;
        Wed, 10 Mar 2021 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403034;
        bh=6E1/Tk+iaqCP4ys2pHL2ZD+w4lMAzAgGpCc/0DiaCUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7YHBkyhE9fxO+oJgCnm4H/GfwnUk/QL6I0LrRq5TzvLus1Q2ijHp/x2tDCl0BfIQ
         +CndE+g2xci4Z3o9ES7xJbMagvlg8fP2ulBpl3hm7VuyBmf8Rkc7qt+WP1Y1NLG3WW
         797ClJVAVY7Kmio3vl7NzyxZpcOcSZhQ7oH9MT+9EYyc6l7ggqIB9StfEGyc34f/xs
         torUUbk6yKpgXWKkd1tUhPLTTNeLYigBQowagt0IdEq2llZ5qs7r9qpsHK2qPDXUO3
         VtNbN5Ni1W74OI846CW8WmptXpxpfxmxETvuQZFdKCJNff08HX1zrxs2dIiN9Xsfaa
         i3uDIfv4GeL9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/18] net/mlx5e: RX, Mind the MPWQE gaps when calculating offsets
Date:   Wed, 10 Mar 2021 11:03:26 -0800
Message-Id: <20210310190342.238957-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Since cited patch, MLX5E_REQUIRED_WQE_MTTS is not a power of two.
Hence, usage of MLX5E_LOG_ALIGNED_MPWQE_PPW should be replaced,
as it lost some accuracy. Use the designated macro to calculate
the number of required MTTs.

This makes sure the solution in cited patch works properly.

While here, un-inline mlx5e_get_mpwqe_offset(), and remove the
unused RQ parameter.

Fixes: c3c9402373fe ("net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   | 4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7435fe6829b6..304b296fe8b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -92,14 +92,15 @@ struct page_pool;
 				    MLX5_MPWRQ_LOG_WQE_SZ - PAGE_SHIFT : 0)
 #define MLX5_MPWRQ_PAGES_PER_WQE		BIT(MLX5_MPWRQ_WQE_PAGE_ORDER)
 
-#define MLX5_MTT_OCTW(npages) (ALIGN(npages, 8) / 2)
+#define MLX5_ALIGN_MTTS(mtts)		(ALIGN(mtts, 8))
+#define MLX5_ALIGNED_MTTS_OCTW(mtts)	((mtts) / 2)
+#define MLX5_MTT_OCTW(mtts)		(MLX5_ALIGNED_MTTS_OCTW(MLX5_ALIGN_MTTS(mtts)))
 /* Add another page to MLX5E_REQUIRED_WQE_MTTS as a buffer between
  * WQEs, This page will absorb write overflow by the hardware, when
  * receiving packets larger than MTU. These oversize packets are
  * dropped by the driver at a later stage.
  */
-#define MLX5E_REQUIRED_WQE_MTTS		(ALIGN(MLX5_MPWRQ_PAGES_PER_WQE + 1, 8))
-#define MLX5E_LOG_ALIGNED_MPWQE_PPW	(ilog2(MLX5E_REQUIRED_WQE_MTTS))
+#define MLX5E_REQUIRED_WQE_MTTS		(MLX5_ALIGN_MTTS(MLX5_MPWRQ_PAGES_PER_WQE + 1))
 #define MLX5E_REQUIRED_MTTS(wqes)	(wqes * MLX5E_REQUIRED_WQE_MTTS)
 #define MLX5E_MAX_RQ_NUM_MTTS	\
 	((1 << 16) * 2) /* So that MLX5_MTT_OCTW(num_mtts) fits into u16 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5c8ffa8da6f0..831f5495ff39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -334,9 +334,9 @@ static int mlx5e_create_rq_umr_mkey(struct mlx5_core_dev *mdev, struct mlx5e_rq
 				     rq->wqe_overflow.addr);
 }
 
-static inline u64 mlx5e_get_mpwqe_offset(struct mlx5e_rq *rq, u16 wqe_ix)
+static u64 mlx5e_get_mpwqe_offset(u16 wqe_ix)
 {
-	return (wqe_ix << MLX5E_LOG_ALIGNED_MPWQE_PPW) << PAGE_SHIFT;
+	return MLX5E_REQUIRED_MTTS(wqe_ix) << PAGE_SHIFT;
 }
 
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
@@ -577,7 +577,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 				mlx5_wq_ll_get_wqe(&rq->mpwqe.wq, i);
 			u32 byte_count =
 				rq->mpwqe.num_strides << rq->mpwqe.log_stride_sz;
-			u64 dma_offset = mlx5e_get_mpwqe_offset(rq, i);
+			u64 dma_offset = mlx5e_get_mpwqe_offset(i);
 
 			wqe->data[0].addr = cpu_to_be64(dma_offset + rq->buff.headroom);
 			wqe->data[0].byte_count = cpu_to_be32(byte_count);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1b6ad94ebb10..249d8905e644 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -500,7 +500,6 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	struct mlx5e_icosq *sq = rq->icosq;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5e_umr_wqe *umr_wqe;
-	u16 xlt_offset = ix << (MLX5E_LOG_ALIGNED_MPWQE_PPW - 1);
 	u16 pi;
 	int err;
 	int i;
@@ -531,7 +530,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe->ctrl.opmod_idx_opcode =
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
-	umr_wqe->uctrl.xlt_offset = cpu_to_be16(xlt_offset);
+	umr_wqe->uctrl.xlt_offset =
+		cpu_to_be16(MLX5_ALIGNED_MTTS_OCTW(MLX5E_REQUIRED_MTTS(ix)));
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type   = MLX5E_ICOSQ_WQE_UMR_RX,
-- 
2.29.2

