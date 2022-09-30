Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36755F0FF6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiI3Q3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiI3Q3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16512169E54
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A79DA623D2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0133AC433D6;
        Fri, 30 Sep 2022 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555369;
        bh=sKkum5/1Mx2N4Zi5OQvh2iP/l8h+OAO4+6pd7emTGOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yqzu409QBgeM3Q5gv5IVDn+SOmkfZbfoRpJds5c0tLetArvIyRt8gFCyddNk6eyZ1
         5OWCZCwepwWTbP3vj3sW0dFepZUjEfvUkez7xC38NdOFtV5wIk7oObWDzmQlHwrynO
         1p9iH/Ol144Lg3BeDAJp3sbAScsYrexzw9CSIbftu7jAJr4Oa+ehb7ZkLTMt46tbCj
         kAdyaKRfxa3fTGJ+B4J6K7CyKqkpZBXY2vxdyFvmLY24G6WbkZ1j01IBiXaFvGCOM3
         MmFkybK/LjlErw8mRDatWfPn0QLu5MBEy39rFobVybLyXLdN8zYzpKAzov6o/DaLZk
         Kl5EZ3z9u+eSg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 03/16] net/mlx5e: Introduce wqe_index_mask for legacy RQ
Date:   Fri, 30 Sep 2022 09:28:50 -0700
Message-Id: <20220930162903.62262-4-saeed@kernel.org>
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

When fragments of different WQEs share the same page, mlx5e_post_rx_wqes
must wait until the old WQE stops using the page, only then the new WQE
can allocate the new page. Essentially, it means that if WQE index i is
still in use, the allocation must stop before `i % bulk`, where bulk is
the number of WQEs that may share the same page.

As bulk is always a power of two, `i % bulk = i & (bulk - 1)`, and the
new wqe_index_mask field will be equal to `bulk - 1`.

At the same time, wqe_bulk remains for optimization purposes and stores
`max(bulk, 8)`, which allows to skip the allocation until we have at
least 8 WQEs free.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/params.c   | 25 ++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 95a232fb2127..8e174a7f7c25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -660,6 +660,7 @@ struct mlx5e_rq_frags_info {
 	u8 num_frags;
 	u8 log_num_frags;
 	u8 wqe_bulk;
+	u8 wqe_index_mask;
 };
 
 struct mlx5e_dma_info {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 68bc66cbd8a5..49306a68b3b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -586,7 +586,14 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		info->arr[0].frag_size = byte_count;
 		info->arr[0].frag_stride = frag_stride;
 		info->num_frags = 1;
-		info->wqe_bulk = PAGE_SIZE / frag_stride;
+
+		/* N WQEs share the same page, N = PAGE_SIZE / frag_stride. The
+		 * first WQE in the page is responsible for allocation of this
+		 * page, this WQE's index is k*N. If WQEs [k*N+1; k*N+N-1] are
+		 * still not completed, the allocation must stop before k*N.
+		 */
+		info->wqe_index_mask = (PAGE_SIZE / frag_stride) - 1;
+
 		goto out;
 	}
 
@@ -635,11 +642,21 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 		i++;
 	}
 	info->num_frags = i;
-	/* number of different wqes sharing a page */
-	info->wqe_bulk = 1 + (info->num_frags % 2);
+
+	/* The last fragment of WQE with index 2*N may share the page with the
+	 * first fragment of WQE with index 2*N+1 in certain cases. If WQE 2*N+1
+	 * is not completed yet, WQE 2*N must not be allocated, as it's
+	 * responsible for allocating a new page.
+	 */
+	info->wqe_index_mask = info->num_frags % 2;
 
 out:
-	info->wqe_bulk = max_t(u8, info->wqe_bulk, 8);
+	/* Bulking optimization to skip allocation until at least 8 WQEs can be
+	 * allocated in a row. At the same time, never start allocation when
+	 * the page is still used by older WQEs.
+	 */
+	info->wqe_bulk = max_t(u8, info->wqe_index_mask + 1, 8);
+
 	info->log_num_frags = order_base_2(info->num_frags);
 
 	return 0;
-- 
2.37.3

