Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663D84DE2E5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240855AbiCRUye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbiCRUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF76DED7
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6982660CA3
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC9C340F5;
        Fri, 18 Mar 2022 20:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636791;
        bh=ktHGJYqeHF5Eb4Xh3WJsdoarGC4QXdEEH+MgGK9Cp8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gao9FpRHOAguJZjRsQsD2eZoNPeHddhSZ576vUiVHM5j+DxnPRxwCWrkrVqxE7iaG
         BRiCYmYLtC+kusruAZAVLHnDJphE44Tl4oyhkOupJM2Zl3V7yYhHpdGznVjizOaBs0
         ZhoTyxcXlomyKqaKBI6oJlpCMRf9jcTvcwGO+ANf6N2coardKzeYHXoEaohz62LzYu
         hqMDF827KjP0DyQg+8NvdI8DuzJuvT2dvehct/JavyUKK6VMVvMR3pW5vbYfMpFu2N
         U471uCSWbFlg08qIOrGQgGzYFPqammAVKxN4ZDaUlBNTUkKOFeJuh++DErqhN9p5oP
         vDe6wwA4ItVXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ
Date:   Fri, 18 Mar 2022 13:52:37 -0700
Message-Id: <20220318205248.33367-5-saeed@kernel.org>
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

This commit adds XDP multi buffer support to the RX path in the
non-linear legacy RQ mode. mlx5e_xdp_handle is called from
mlx5e_skb_from_cqe_nonlinear.

XDP_TX action for fragmented XDP frames is not yet supported and
blocked.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 6aa77f0e094e..3a837030e96e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -68,6 +68,11 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	if (unlikely(!xdpf))
 		return false;
 
+	if (unlikely(xdp_frame_has_frags(xdpf))) {
+		xdp_return_frame(xdpf);
+		return false;
+	}
+
 	xdptxd.data = xdpf->data;
 	xdptxd.len  = xdpf->len;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index dd8ff62e1693..e9ad5b3a30ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1572,6 +1572,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	struct mlx5e_dma_info *di = wi->di;
 	struct skb_shared_info *sinfo;
 	u32 frag_consumed_bytes;
+	struct bpf_prog *prog;
 	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	u32 truesize;
@@ -1582,6 +1583,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, wi->offset,
 				      rq->buff.frame0_sz, DMA_FROM_DEVICE);
+	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
 
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &xdp);
@@ -1629,6 +1631,17 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 	di = head_wi->di;
 
+	prog = rcu_dereference(rq->xdp_prog);
+	if (prog && mlx5e_xdp_handle(rq, di, prog, &xdp)) {
+		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
+			int i;
+
+			for (i = wi - head_wi; i < rq->wqe.info.num_frags; i++)
+				mlx5e_put_rx_frag(rq, &head_wi[i], true);
+		}
+		return NULL; /* page/packet was consumed by XDP */
+	}
+
 	skb = mlx5e_build_linear_skb(rq, xdp.data_hard_start, rq->buff.frame0_sz,
 				     xdp.data - xdp.data_hard_start,
 				     xdp.data_end - xdp.data,
-- 
2.35.1

