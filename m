Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1AA2738DD
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbgIVCr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbgIVCrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:46 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C0ED23A6A;
        Tue, 22 Sep 2020 02:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742865;
        bh=ThAAM0KHi7jx+bDDaqbK9py51sYNeJ/D4KrNbuLs64c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8iA4/pfSkqffiPbsKn/QVkiD2GUb/zAEjlHogt/WNnsuaAKTFpyucs1TtgxQ+y/x
         z2X1gwmGOWV2S5b9v+j42z+QEB5cLzscmiHDCk1l9sUkxfX/47fqTrrGRapV0XknbG
         ypbAYO9SmWL1EWdK8dxcDKrlanygDUpoZ1MUIFNc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 07/12] net/mlx5e: Move the TLS resync check out of the function
Date:   Mon, 21 Sep 2020 19:46:59 -0700
Message-Id: <20200922024704.544482-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Before this patch, mlx5e_ktls_tx_handle_resync_dump_comp checked for
resync_dump_frag_page. It happened for all WQEs without an SKB,
including padding WQEs, and required a function call. Normally, padding
WQEs happen more often than TLS resyncs. Take this check out of the
function and put it to an inline function to save a call on all padding
WQEs.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  3 ---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        | 14 +++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  4 ++--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index f4861545b236..b140e13fdcc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -345,9 +345,6 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	struct mlx5e_sq_stats *stats;
 	struct mlx5e_sq_dma *dma;
 
-	if (!wi->resync_dump_frag_page)
-		return;
-
 	dma = mlx5e_dma_get(sq, (*dma_fifo_cc)++);
 	stats = sq->stats;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index ff4c740af10b..fcfb156cf09d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -29,11 +29,19 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
+static inline void
+mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					  struct mlx5e_tx_wqe_info *wi,
+					  u32 *dma_fifo_cc)
+{
+	if (unlikely(wi->resync_dump_frag_page))
+		mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma_fifo_cc);
+}
 #else
 static inline void
-mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
-				      struct mlx5e_tx_wqe_info *wi,
-				      u32 *dma_fifo_cc)
+mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					  struct mlx5e_tx_wqe_info *wi,
+					  u32 *dma_fifo_cc)
 {
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index e458a0ab8740..aea30399f664 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -545,7 +545,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			sqcc += wi->num_wqebbs;
 
 			if (unlikely(!skb)) {
-				mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+				mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
 				continue;
 			}
 
@@ -610,7 +610,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		sqcc += wi->num_wqebbs;
 
 		if (!skb) {
-			mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+			mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
 			continue;
 		}
 
-- 
2.26.2

