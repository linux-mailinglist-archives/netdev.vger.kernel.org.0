Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0945695B0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiGFXNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiGFXNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793C2639
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4878B81EFB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88533C3411C;
        Wed,  6 Jul 2022 23:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149206;
        bh=C7B5aRF20hWFVCaImnZbjKxDPbhY4A+oiFLv4CYC7ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVJ2BIMvyMyrqqsKDnG6wCiCTxhcYvOa+mF3R4oR+vouYwHL/ghIADukKhGL/lsps
         nKplR0YXMRtHD/lBJKFciefCKiucPbu0F2fxe9KyLPs6j766LZVN5kyMqH0FJV8wZM
         uieIcHWJZfj4caAp+x6I6Ila+328hN4tiIO0ZngeE6cx2B4R+itDW3iFHssQd3sVal
         g8QNTuufDe3ofYf0RZoaihLhxTRKgeNX35/cNBb1+M4WtWPtrFO6/ItrURdLy6xu/N
         TPzmbqIsTAVdRi61QvbqhtADi3IY1/p93m8LA4orNz3o6cIyGvXeCsCWp3n1s30Arq
         QvIjvsGemL7qA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net 9/9] net/mlx5e: Ring the TX doorbell on DMA errors
Date:   Wed,  6 Jul 2022 16:13:09 -0700
Message-Id: <20220706231309.38579-10-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

TX doorbells may be postponed, because sometimes the driver knows that
another packet follows (for example, when xmit_more is true, or when a
MPWQE session is closed before transmitting a packet).

However, the DMA mapping may fail for the next packet, in which case a
new WQE is not posted, the doorbell isn't updated either, and the
transmission of the previous packet will be delayed indefinitely.

This commit fixes the described rare error flow by posting a NOP and
ringing the doorbell on errors to flush all the previous packets. The
MPWQE session is closed before that. DMA mapping in the MPWQE flow is
moved to the beginning of mlx5e_sq_xmit_mpwqe, because empty sessions
are not allowed. Stop room always has enough space for a NOP, because
the actual TX WQE is not posted.

Fixes: e586b3b0baee ("net/mlx5: Ethernet Datapath files")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 39 ++++++++++++++-----
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 50d14cec4894..9a7250be229f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -341,6 +341,26 @@ static void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
 	}
 }
 
+static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_tx_wqe_info *wi;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	/* Must not be called when a MPWQE session is active but empty. */
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wi = &sq->db.wqe_info[pi];
+
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.num_wqebbs = 1,
+	};
+
+	wqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     const struct mlx5e_tx_attr *attr,
@@ -459,6 +479,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 
 static bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct mlx5e_tx_attr *attr)
@@ -560,6 +581,13 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5e_xmit_data txd;
 
+	txd.data = skb->data;
+	txd.len = skb->len;
+
+	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
+		goto err_unmap;
+
 	if (!mlx5e_tx_mpwqe_session_is_active(sq)) {
 		mlx5e_tx_mpwqe_session_start(sq, eseg);
 	} else if (!mlx5e_tx_mpwqe_same_eseg(sq, eseg)) {
@@ -569,18 +597,9 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	sq->stats->xmit_more += xmit_more;
 
-	txd.data = skb->data;
-	txd.len = skb->len;
-
-	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
-		goto err_unmap;
 	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
-
 	mlx5e_skb_fifo_push(&sq->db.skb_fifo, skb);
-
 	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
-
 	mlx5e_tx_skb_update_hwts_flags(skb);
 
 	if (unlikely(mlx5e_tx_mpwqe_is_full(&sq->mpwqe, sq->max_sq_mpw_wqebbs))) {
@@ -602,6 +621,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	mlx5e_dma_unmap_wqe_err(sq, 1);
 	sq->stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
@@ -1006,5 +1026,6 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 #endif
-- 
2.36.1

