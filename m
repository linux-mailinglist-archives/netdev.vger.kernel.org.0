Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8D5F0FFD
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiI3QaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiI3Q3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66275DF7C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 893FDB82695
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC10C433D7;
        Fri, 30 Sep 2022 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555374;
        bh=Xztq1BgW/oKRlwLkCDRr9luu7uxY5UDc1kgthA5Oak8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9qGE92uVXqUzJoxSz7LVtAoQdfOCzVDecJH4bMukMwJlZDHIfaxyFlamXztnLEvH
         zzAXQxEYZ4r6m4LlXK4xq6IVUHnEnjnQWJBGmwDrWBQAqxNfw9MQdudqqlmo9sfgK8
         OohxGcGVSar+Y6SiJ4k2PSeGR+uOLvDq8QUQC0xnCF1IVOP9mIDBTYn/u6nQ1QigOC
         pCJmgILxEJXjBbnsPLe4QEjN6ixNjsrAet3eQLHZnq01wmbcEP9FPbbVmQzTwOXrQi
         tNmChb3u5mqwtFy+FKdVzEGkUvKRpmgwI1ZDozVzy7wlurFtppB5rZ5PszcfdL2/uj
         dWZlFm9WPnYig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 08/16] net/mlx5e: xsk: Split out WQE allocation for legacy XSK RQ
Date:   Fri, 30 Sep 2022 09:28:55 -0700
Message-Id: <20220930162903.62262-9-saeed@kernel.org>
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

Allocation of XSK frames on legacy RQ may be made more efficient with a
specialized routine that relies on certain assumptions, such as there is
only one fragment, allocation units (XSK frames) are not shared among
multiple packets. It reduces the number of branches both in the XSK code
and in the regular RQ, because with this approach there is only a single
check whether it's an XSK or regular RQ.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 26 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 11 +++++---
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 4441d35943d1..a850141789a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -8,6 +8,32 @@
 
 /* RX data path */
 
+int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
+{
+	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
+	int i;
+
+	for (i = 0; i < wqe_bulk; i++) {
+		int j = mlx5_wq_cyc_ctr2ix(wq, ix + i);
+		struct mlx5e_wqe_frag_info *frag;
+		struct mlx5e_rx_wqe_cyc *wqe;
+		dma_addr_t addr;
+
+		wqe = mlx5_wq_cyc_get_wqe(wq, j);
+		/* Assumes log_num_frags == 0. */
+		frag = &rq->wqe.frags[j];
+
+		frag->au->xsk = xsk_buff_alloc(rq->xsk_pool);
+		if (unlikely(!frag->au->xsk))
+			return i;
+
+		addr = xsk_buff_xdp_get_frame_dma(frag->au->xsk);
+		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
+	}
+
+	return wqe_bulk;
+}
+
 static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, void *data,
 					       u32 cqe_bcnt)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index e702cb790476..acabcee623f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -9,6 +9,7 @@
 
 /* RX data path */
 
+int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
 						    u16 cqe_bcnt,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d620c1ed9b80..6321eb3fff31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -359,7 +359,7 @@ static inline int mlx5e_get_rx_frag(struct mlx5e_rq *rq,
 		 * offset) should just use the new one without replenishing again
 		 * by themselves.
 		 */
-		err = mlx5e_page_alloc(rq, frag->au);
+		err = mlx5e_page_alloc_pool(rq, frag->au);
 
 	return err;
 }
@@ -393,8 +393,7 @@ static int mlx5e_alloc_rx_wqe(struct mlx5e_rq *rq, struct mlx5e_rx_wqe_cyc *wqe,
 			goto free_frags;
 
 		headroom = i == 0 ? rq->buff.headroom : 0;
-		addr = rq->xsk_pool ? xsk_buff_xdp_get_frame_dma(frag->au->xsk) :
-				      page_pool_get_dma_addr(frag->au->page);
+		addr = page_pool_get_dma_addr(frag->au->page);
 		wqe->data[i].addr = cpu_to_be64(addr + frag->offset + headroom);
 	}
 
@@ -826,7 +825,11 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 	 */
 	wqe_bulk -= (head + wqe_bulk) & rq->wqe.info.wqe_index_mask;
 
-	count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
+	if (!rq->xsk_pool)
+		count = mlx5e_alloc_rx_wqes(rq, head, wqe_bulk);
+	else
+		count = mlx5e_xsk_alloc_rx_wqes(rq, head, wqe_bulk);
+
 	mlx5_wq_cyc_push_n(wq, count);
 	if (unlikely(count != wqe_bulk)) {
 		rq->stats->buff_alloc_err++;
-- 
2.37.3

