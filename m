Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589D25F0FFC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiI3QaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiI3Q3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F83DF31
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E02623D2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFC5C433B5;
        Fri, 30 Sep 2022 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555375;
        bh=T+s97SeKJIbErdKQXQFfA76RivEJ0uiOK9KGqHHOjOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSukFOOW+ctjrwPbDP6GsM86yUwJbthP+AkYWPuGOObm8s5LfvzNrwfc6uBXJmAh3
         Ue41tEiKCSHcpubc1QohquBR3sCAapHaRyQEQduZEExJmB4RE50m51vey0fNE48NcJ
         2KI1AaYrL6B+0P+Zuh3N2nWgwwydBsSA5O8CINQkpotZD5HQpDMdQrezv62wtFXUGM
         U/73tx5HY2kFnUx3XdO6FwLGML6oG+lSiKf65Dbs4v4Q+YiXvNBxettBlmioszMShd
         CC+rHvsZyRs61PHeKlOcZvwHWiL9ruRslqsT09lULXiKYhJkGh4SZ1a85Vi26dCiym
         8eZ6WWa2HUfVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 09/16] net/mlx5e: xsk: Use xsk_buff_alloc_batch on legacy RQ
Date:   Fri, 30 Sep 2022 09:28:56 -0700
Message-Id: <20220930162903.62262-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

XSK provides a function to allocate frames in batches for more efficient
processing. This commit starts using this function on legacy RQ, adding
a special case for XSK. The new branch introduced basically replaces the
branch that was removed from the same place a few commits before.

A check is made that DMA sync is not needed, because the batching
allocator falls back to returning one frame when DMA sync is needed, and
this is best handled by the loop in the standard case.

Performance improvement is up to 8% in the aligned mode and up to 9% in
the unaligned mode.

Aligned mode, 2048-byte frames: 12.8 Mpps -> 13.5 Mpps
Aligned mode, 4096-byte frames: 11.5 Mpps -> 12.4 Mpps
Unaligned mode, 2048-byte frames: 12.2 Mpps -> 13.4 Mpps
Unaligned mode, 3072-byte frames: 11.6 Mpps -> 12.5 Mpps
Unaligned mode, 4096-byte frames: 11.2 Mpps -> 12.2 Mpps

CPU: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 40 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 ++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  7 ++++
 4 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index a850141789a0..812a370f6aea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -8,6 +8,46 @@
 
 /* RX data path */
 
+int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
+{
+	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+	struct xdp_buff **buffs;
+	u32 contig, alloc;
+	int i;
+
+	/* mlx5e_init_frags_partition creates a 1:1 mapping between
+	 * rq->wqe.frags and rq->wqe.alloc_units, which allows us to
+	 * allocate XDP buffers straight into alloc_units.
+	 */
+	BUILD_BUG_ON(sizeof(rq->wqe.alloc_units[0]) !=
+		     sizeof(rq->wqe.alloc_units[0].xsk));
+	buffs = (struct xdp_buff **)rq->wqe.alloc_units;
+	contig = mlx5_wq_cyc_get_size(wq) - ix;
+	if (wqe_bulk <= contig) {
+		alloc = xsk_buff_alloc_batch(rq->xsk_pool, buffs + ix, wqe_bulk);
+	} else {
+		alloc = xsk_buff_alloc_batch(rq->xsk_pool, buffs + ix, contig);
+		if (likely(alloc == contig))
+			alloc += xsk_buff_alloc_batch(rq->xsk_pool, buffs, wqe_bulk - contig);
+	}
+
+	for (i = 0; i < alloc; i++) {
+		int j = mlx5_wq_cyc_ctr2ix(wq, ix + i);
+		struct mlx5e_wqe_frag_info *frag;
+		struct mlx5e_rx_wqe_cyc *wqe;
+		dma_addr_t addr;
+
+		wqe = mlx5_wq_cyc_get_wqe(wq, j);
+		/* Assumes log_num_frags == 0. */
+		frag = &rq->wqe.frags[j];
+
+		addr = xsk_buff_xdp_get_frame_dma(frag->au->xsk);
+		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
+	}
+
+	return alloc;
+}
+
 int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index acabcee623f9..7898a78237b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -9,6 +9,7 @@
 
 /* RX data path */
 
+int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2719247b18db..6a0adda03463 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -433,6 +433,13 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 	struct mlx5e_wqe_frag_info *prev = NULL;
 	int i;
 
+	if (rq->xsk_pool) {
+		/* Assumptions used by XSK batched allocator. */
+		WARN_ON(rq->wqe.info.num_frags != 1);
+		WARN_ON(rq->wqe.info.log_num_frags != 0);
+		WARN_ON(rq->wqe.info.arr[0].frag_stride != PAGE_SIZE);
+	}
+
 	next_frag.au = &rq->wqe.alloc_units[0];
 
 	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 6321eb3fff31..5f411c29157f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -827,7 +827,14 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 
 	if (!rq->xsk_pool)
 		count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
+	else if (likely(!rq->xsk_pool->dma_need_sync))
+		count = mlx5e_xsk_alloc_rx_wqes_batched(rq, head, wqe_bulk);
 	else
+		/* If dma_need_sync is true, it's more efficient to call
+		 * xsk_buff_alloc in a loop, rather than xsk_buff_alloc_batch,
+		 * because the latter does the same check and returns only one
+		 * frame.
+		 */
 		count = mlx5e_xsk_alloc_rx_wqes(rq, head, wqe_bulk);
 
 	mlx5_wq_cyc_push_n(wq, count);
-- 
2.37.3

