Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E92738DC
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgIVCr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729310AbgIVCru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:50 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622B32396D;
        Tue, 22 Sep 2020 02:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742870;
        bh=JUzMnvmaU2VdE8LWTvEzde1yH8YAYkFid3Tqv6SYGvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdEMA5uuWGFh8H45lstUF84cw4otjz4vghWufwLfIlTHBFqG922olihMKZFdU/yc3
         WVsKjWo3obfHndZMYTsA0cjlH8XM3EE9iMkoGDVJGCH11C3cWAFI2kpknPCjG8zSDe
         Z0mGOFgKg7pRMGH3T4AORuT68AHcOAvoRwdHxgmA=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 10/12] net/mlx5e: Rename xmit-related structs to generalize them
Date:   Mon, 21 Sep 2020 19:47:02 -0700
Message-Id: <20200922024704.544482-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As preparation for the upcoming TX MPWQE support for SKBs, rename struct
mlx5e_xdp_mpwqe to mlx5e_tx_mpwqe and move it above struct mlx5e_txqsq.
This structure will be reused in the regular SQ and in the regular TX
data path. Also rename mlx5e_xdp_xmit_data to mlx5e_xmit_data - it will
be used in the upcoming TX MPWQE flow.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 22 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 16 +++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 10 ++++-----
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 04c6ff2386bf..252cc0277475 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -313,6 +313,14 @@ enum {
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
 
+struct mlx5e_tx_mpwqe {
+	/* Current MPWQE session */
+	struct mlx5e_tx_wqe *wqe;
+	u8 ds_count;
+	u8 pkt_count;
+	u8 inline_on;
+};
+
 struct mlx5e_txqsq {
 	/* data path */
 
@@ -403,7 +411,7 @@ struct mlx5e_xdp_info {
 	};
 };
 
-struct mlx5e_xdp_xmit_data {
+struct mlx5e_xmit_data {
 	dma_addr_t  dma_addr;
 	void       *data;
 	u32         len;
@@ -416,18 +424,10 @@ struct mlx5e_xdp_info_fifo {
 	u32 mask;
 };
 
-struct mlx5e_xdp_mpwqe {
-	/* Current MPWQE session */
-	struct mlx5e_tx_wqe *wqe;
-	u8                   ds_count;
-	u8                   pkt_count;
-	u8                   inline_on;
-};
-
 struct mlx5e_xdpsq;
 typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
-					struct mlx5e_xdp_xmit_data *,
+					struct mlx5e_xmit_data *,
 					struct mlx5e_xdp_info *,
 					int);
 
@@ -442,7 +442,7 @@ struct mlx5e_xdpsq {
 	u32                        xdpi_fifo_pc ____cacheline_aligned_in_smp;
 	u16                        pc;
 	struct mlx5_wqe_ctrl_seg   *doorbell_cseg;
-	struct mlx5e_xdp_mpwqe     mpwqe;
+	struct mlx5e_tx_mpwqe      mpwqe;
 
 	struct mlx5e_cq            cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index b4ee1f2f1746..06dbfd6cd82a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -279,7 +279,7 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more);
 
-static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_xdp_mpwqe *session)
+static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session)
 {
 	return session->ds_count == MLX5E_TX_MPW_MAX_NUM_DS;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2a72496ceda9..f0a102763de6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -59,7 +59,7 @@ static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		    struct mlx5e_dma_info *di, struct xdp_buff *xdp)
 {
-	struct mlx5e_xdp_xmit_data xdptxd;
+	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
 	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
@@ -194,7 +194,7 @@ static u16 mlx5e_xdpsq_get_next_pi(struct mlx5e_xdpsq *sq, u16 size)
 
 static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 {
-	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
@@ -203,7 +203,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(wqe->data);
 
-	*session = (struct mlx5e_xdp_mpwqe) {
+	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
 		.ds_count = MLX5E_TX_WQE_EMPTY_DS_COUNT,
 		.pkt_count = 0,
@@ -216,7 +216,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5_wq_cyc       *wq    = &sq->wq;
-	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5_wqe_ctrl_seg *cseg = &session->wqe->ctrl;
 	u16 ds_count = session->ds_count;
 	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
@@ -261,10 +261,10 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq
 }
 
 INDIRECT_CALLABLE_SCOPE bool
-mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *xdptxd,
+mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 			   struct mlx5e_xdp_info *xdpi, int check_result)
 {
-	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
 	if (unlikely(xdptxd->len > sq->hw_mtu)) {
@@ -308,7 +308,7 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 }
 
 INDIRECT_CALLABLE_SCOPE bool
-mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *xdptxd,
+mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 		     struct mlx5e_xdp_info *xdpi, int check_result)
 {
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
@@ -505,7 +505,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
-		struct mlx5e_xdp_xmit_data xdptxd;
+		struct mlx5e_xmit_data xdptxd;
 		struct mlx5e_xdp_info xdpi;
 		bool ret;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 0dc38acab5a8..4bd8af478a4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -58,11 +58,11 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		   u32 flags);
 
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
-							  struct mlx5e_xdp_xmit_data *xdptxd,
+							  struct mlx5e_xmit_data *xdptxd,
 							  struct mlx5e_xdp_info *xdpi,
 							  int check_result));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
-						    struct mlx5e_xdp_xmit_data *xdptxd,
+						    struct mlx5e_xmit_data *xdptxd,
 						    struct mlx5e_xdp_info *xdpi,
 						    int check_result));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
@@ -123,7 +123,7 @@ static inline bool mlx5e_xdp_get_inline_state(struct mlx5e_xdpsq *sq, bool cur)
 	return cur;
 }
 
-static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session)
+static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_tx_mpwqe *session)
 {
 	if (session->inline_on)
 		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
@@ -138,10 +138,10 @@ struct mlx5e_xdp_wqe_info {
 
 static inline void
 mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
-			 struct mlx5e_xdp_xmit_data *xdptxd,
+			 struct mlx5e_xmit_data *xdptxd,
 			 struct mlx5e_xdpsq_stats *stats)
 {
-	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5_wqe_data_seg *dseg =
 		(struct mlx5_wqe_data_seg *)session->wqe + session->ds_count;
 	u32 dma_len = xdptxd->len;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index aa91cbdfe969..fb671a457129 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -67,8 +67,8 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
 	struct xsk_buff_pool *pool = sq->xsk_pool;
+	struct mlx5e_xmit_data xdptxd;
 	struct mlx5e_xdp_info xdpi;
-	struct mlx5e_xdp_xmit_data xdptxd;
 	bool work_done = true;
 	bool flush = false;
 
-- 
2.26.2

