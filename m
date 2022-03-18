Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86E14DE2F6
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240873AbiCRUyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB42DEE4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC0560CA5
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811E7C340F3;
        Fri, 18 Mar 2022 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636792;
        bh=uO5jr9vKwn1uneBJ3HHNOV7EdeAk4VOuZ5IQ4RY9mc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwOIEBChXGEtvWLNUtFMi99HuA5vw+GMmpQQYMB/IJfKetdzFjnDgErbL+koWs/yl
         /kzEn8AfcZOdm5WezuNrEmzjzriEXTCxtLBpxaYtBdgE+5Xu7eunPwD7qXcqm6RV+o
         Yp6VxFD0aP63DtlgM7/P7CmSlwLU/Wy/wUCaR+NZI5omXrpMIus284vENcf7boNMBN
         jRsB6lHhaIxaHTWfb7rbitpoqRcXKVLZN4bVdOH1LZLW0VSI7HuHWANJYFlO73gAfI
         zssMYXtLmrY0SqMkQ6iMPxJr/Au4OqQtDKu9+vLSRaQpAgcDIdZYOoWduf9ll7458V
         y3stUq8S4iF5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Move mlx5e_xdpi_fifo_push out of xmit_xdp_frame
Date:   Fri, 18 Mar 2022 13:52:39 -0700
Message-Id: <20220318205248.33367-7-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The implementations of xmit_xdp_frame get the xdpi parameter of type
struct mlx5e_xdp_info for the sole purpose of calling
mlx5e_xdpi_fifo_push() on success.

This commit moves this call outside of xmit_xdp_frame, shifting this
responsibility to the caller. It will allow more fine-grained handling
of XDP info for cases when an xdp_frame is fragmented.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c    | 17 ++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h    |  2 --
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c |  4 +++-
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f5b2449fa15a..d084f930bb37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -537,7 +537,6 @@ struct mlx5e_xdpsq;
 typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xmit_data *,
-					struct mlx5e_xdp_info *,
 					int);
 
 struct mlx5e_xdpsq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 91dd5c59657b..b1114f854057 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -119,8 +119,12 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		xdpi.page.page = page;
 	}
 
-	return INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-			       mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, 0);
+	if (unlikely(!INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0)))
+		return false;
+
+	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
+	return true;
 }
 
 /* returns true if packet was consumed by xdp */
@@ -261,7 +265,7 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-			   struct mlx5e_xdp_info *xdpi, int check_result)
+			   int check_result)
 {
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
@@ -289,7 +293,6 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 	if (unlikely(mlx5e_xdp_mpqwe_is_full(session, sq->max_sq_mpw_wqebbs)))
 		mlx5e_xdp_mpwqe_complete(sq);
 
-	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
 	stats->xmit++;
 	return true;
 }
@@ -308,7 +311,7 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     struct mlx5e_xdp_info *xdpi, int check_result)
+		     int check_result)
 {
 	struct mlx5_wq_cyc       *wq   = &sq->wq;
 	u16                       pi   = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
@@ -358,7 +361,6 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	sq->doorbell_cseg = cseg;
 
-	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
 	stats->xmit++;
 	return true;
 }
@@ -537,12 +539,13 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdpi.frame.dma_addr = xdptxd.dma_addr;
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, 0);
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, 0);
 		if (unlikely(!ret)) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
 			break;
 		}
+		mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 		nxmit++;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 8a92cf007991..ce31828b6c19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -59,11 +59,9 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
-							  struct mlx5e_xdp_info *xdpi,
 							  int check_result));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 						    struct mlx5e_xmit_data *xdptxd,
-						    struct mlx5e_xdp_info *xdpi,
 						    int check_result));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 8e96260fce1d..5a889835039c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -103,12 +103,14 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
-				      mlx5e_xmit_xdp_frame, sq, &xdptxd, &xdpi, check_result);
+				      mlx5e_xmit_xdp_frame, sq, &xdptxd, check_result);
 		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
 				mlx5e_xdp_mpwqe_complete(sq);
 
 			mlx5e_xsk_tx_post_err(sq, &xdpi);
+		} else {
+			mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, &xdpi);
 		}
 
 		flush = true;
-- 
2.35.1

