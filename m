Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EEB2ADA92
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732592AbgKJPid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732552AbgKJPia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 10:38:30 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D3220797;
        Tue, 10 Nov 2020 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605022710;
        bh=eso8Y/0QxL6ZUd/D6BSzMmvcmQ+RLUBfTMipsyiZskw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVIskgYEC268tgeILwPnKtzx9J3FIZNWbthoHx8Gw8jPBx7LEw3ggN58Lw33y7FgI
         eu5E2KRymOiUqW7vBL3hD8qQwsnbGRfczJYlrEEOaJdZxkHyYt9+VlvkYCXCXKL2kk
         lKp2HVKf+Er4y+WRdbHoO/HF+iUBuu0lxIy6Cuqs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH v5 net-nex 5/5] net: mlx5: add xdp tx return bulking support
Date:   Tue, 10 Nov 2020 16:38:00 +0100
Message-Id: <0e898e7f201e65bdf4d9457f9ad4997d8e52dd4c.1605020963.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1605020963.git.lorenzo@kernel.org>
References: <cover.1605020963.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert mlx5 driver to xdp_return_frame_bulk APIs.

XDP_REDIRECT (upstream codepath): 8.9Mpps
XDP_REDIRECT (upstream codepath + bulking APIs): 10.2Mpps

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index ae90d533a350..2e3e78b0f333 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -366,7 +366,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				  struct mlx5e_xdp_wqe_info *wi,
 				  u32 *xsk_frames,
-				  bool recycle)
+				  bool recycle,
+				  struct xdp_frame_bulk *bq)
 {
 	struct mlx5e_xdp_info_fifo *xdpi_fifo = &sq->db.xdpi_fifo;
 	u16 i;
@@ -379,7 +380,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 			/* XDP_TX from the XSK RQ and XDP_REDIRECT */
 			dma_unmap_single(sq->pdev, xdpi.frame.dma_addr,
 					 xdpi.frame.xdpf->len, DMA_TO_DEVICE);
-			xdp_return_frame(xdpi.frame.xdpf);
+			xdp_return_frame_bulk(xdpi.frame.xdpf, bq);
 			break;
 		case MLX5E_XDP_XMIT_MODE_PAGE:
 			/* XDP_TX from the regular RQ */
@@ -397,12 +398,15 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 {
+	struct xdp_frame_bulk bq;
 	struct mlx5e_xdpsq *sq;
 	struct mlx5_cqe64 *cqe;
 	u32 xsk_frames = 0;
 	u16 sqcc;
 	int i;
 
+	xdp_frame_bulk_init(&bq);
+
 	sq = container_of(cq, struct mlx5e_xdpsq, cq);
 
 	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
@@ -434,7 +438,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 			sqcc += wi->num_wqebbs;
 
-			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, true);
+			mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, true, &bq);
 		} while (!last_wqe);
 
 		if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_REQ)) {
@@ -447,6 +451,8 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 		}
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
+	xdp_flush_frame_bulk(&bq);
+
 	if (xsk_frames)
 		xsk_tx_completed(sq->xsk_pool, xsk_frames);
 
@@ -463,8 +469,13 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 {
+	struct xdp_frame_bulk bq;
 	u32 xsk_frames = 0;
 
+	xdp_frame_bulk_init(&bq);
+
+	rcu_read_lock(); /* need for xdp_return_frame_bulk */
+
 	while (sq->cc != sq->pc) {
 		struct mlx5e_xdp_wqe_info *wi;
 		u16 ci;
@@ -474,9 +485,12 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 
 		sq->cc += wi->num_wqebbs;
 
-		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, false);
+		mlx5e_free_xdpsq_desc(sq, wi, &xsk_frames, false, &bq);
 	}
 
+	xdp_flush_frame_bulk(&bq);
+	rcu_read_unlock();
+
 	if (xsk_frames)
 		xsk_tx_completed(sq->xsk_pool, xsk_frames);
 }
-- 
2.26.2

