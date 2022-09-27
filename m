Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7B75ECEB1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbiI0UhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiI0Ugt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4D384E46
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0FCFB81CDA
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCBBC433B5;
        Tue, 27 Sep 2022 20:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311005;
        bh=bTkjXzYTXf0r+Nn2/H8dT86omCwPr1L688bYlUKpBjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaTIa1gr6RXhNrrw5Q8hUs1M0Z+sie1KQiBSgzyOduhCneSq+vZwPTXV5D9fsm3wF
         B0E+c4E3tN+sejyhSUIkzCgrmTIoif24pYh5uqCa+gvFrobdRurwbAYZO3L6JNNe6e
         xXBjbOcdj5BjEER2aQMbjwHcQ8pu2RsQD9A+dKMz3tNobGonURNUvEULvYUKFE4n7G
         XxxVUb6m1FZKAf9/E8miSwGW6xf8285nhFc3CUGAaRL5mbZFb4aIeUMoZvxIYu1UPl
         2kYam6Vaxv4npYAUUV0yH6FyAZePhb4V1D1k3ipUTM4U5glGIEArezv/W2hC0urWey
         aZbVMPvF9r46A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 07/16] net/mlx5e: Use mlx5e_stop_room_for_max_wqe where appropriate
Date:   Tue, 27 Sep 2022 13:36:02 -0700
Message-Id: <20220927203611.244301-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
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

mlx5e_alloc_xdpsq calculates sq->stop_room internally, but there is
already a function for that: mlx5e_stop_room_for_max_wqe. This commit
makes use of this function.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5391b7ca1d21..e7fea19ac523 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1155,7 +1155,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 		is_redirect ?
 			&c->priv->channel_stats[c->ix]->xdpsq :
 			&c->priv->channel_stats[c->ix]->rq_xdpsq;
-	sq->stop_room = MLX5E_STOP_ROOM(mlx5e_get_max_sq_wqebbs(mdev));
+	sq->stop_room = mlx5e_stop_room_for_max_wqe(mdev);
 	sq->max_sq_mpw_wqebbs = mlx5e_get_max_sq_aligned_wqebbs(mdev);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
-- 
2.37.3

