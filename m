Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5EA5F0FF9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiI3Q3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiI3Q3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8F625DC
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD4E0623C6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5A9C433B5;
        Fri, 30 Sep 2022 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555372;
        bh=ppK2RTDOAnP2rrbRJ6gQCIAuZ4vZ9k3FHmMxnArcFa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFZPhAIcaa2QBpkGmxklUzcVnJlkkInIOmDBUUxZp9Zl6FKYNdBo+CuGr1OpI40fB
         C9U7eVeT0V9fXQvwk/ukpxt+rEhAyBGwE9fjV3LpBZ1HlB3QehnZfXGeCFg2sPj0qL
         3IOVBfxGuTO2FheP8Ru1NHgzzVIgezb5bxeJl6XsSrsWoGsNYAm7sR98Huoh/bmwGk
         SUxgzhmjJWbUsDTsWYe04t8pRRT3/ErOK1dYrL8neg8TC3ERDhv6euCS5WQ8/d0qYp
         6aFAi3u54ki2aschoMgj74KCb3fuZDbRBMPKN1cWqjqRCZ3AMCmP3im6P+gPeXfHzY
         jYuiU82lKShGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 06/16] net/mlx5e: xsk: Use partial batches in legacy RQ with XSK
Date:   Fri, 30 Sep 2022 09:28:53 -0700
Message-Id: <20220930162903.62262-7-saeed@kernel.org>
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

The previous commit allowed allocating WQE batches in legacy RQ
partially, however, XSK still checks whether there are enough frames in
the fill ring. Remove this check to allow to allocate batches partially
also with XSK.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ffca217b7d7e..80f2b5960782 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -429,17 +429,6 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	int i;
 
-	if (rq->xsk_pool) {
-		int pages_desired = wqe_bulk << rq->wqe.info.log_num_frags;
-
-		/* Check in advance that we have enough frames, instead of
-		 * allocating one-by-one, failing and moving frames to the
-		 * Reuse Ring.
-		 */
-		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, pages_desired)))
-			return -ENOMEM;
-	}
-
 	for (i = 0; i < wqe_bulk; i++) {
 		int j = mlx5_wq_cyc_ctr2ix(wq, ix + i);
 		struct mlx5e_rx_wqe_cyc *wqe;
@@ -841,8 +830,7 @@ INDIRECT_CALLABLE_SCOPE bool mlx5e_post_rx_wqes(struct mlx5e_rq *rq)
 		bulk = wqe_bulk - ((head + wqe_bulk) & rq->wqe.info.wqe_index_mask);
 
 		count = mlx5e_alloc_rx_wqes(rq, head, bulk);
-		if (likely(count > 0))
-			mlx5_wq_cyc_push_n(wq, count);
+		mlx5_wq_cyc_push_n(wq, count);
 		if (unlikely(count != bulk)) {
 			rq->stats->buff_alloc_err++;
 			busy = true;
-- 
2.37.3

