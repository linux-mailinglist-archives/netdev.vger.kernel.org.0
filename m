Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537E73E51AB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhHJEAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236902AbhHJEAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 00:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0F960F8F;
        Tue, 10 Aug 2021 03:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567979;
        bh=EHN/4pcPbtqjcxjABQwWEJgQECh+AphGT8tQwCNuPB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSMjMG5kceFxD/eRzMC5DtrW7wBWgLggu0nZJY9XdCMHrCm5TDvniN3U2+7P5s0Ri
         jP5/FAIJNLTkiHfztqe4leqZN5i300yz3OjkQeYh/s75tjAf8IM/yeahk7pgcnN/Ru
         dywLW9r8bQVxcjQBT3BUPvN5HYOgTi406B4lN2aDGiK+gBBRKPkvK1hKuvToONFX4O
         1gTZ5gQ06nHG9KbGEk0UDp5vwBp5hV3FTh49QDSW90TaRWit83r4LEa/HRjLVnEWbH
         29MANCTXxoUngUf96G5JICOVXY7ORI7Hnxq4NE0YCzmc+WQypkxLvz1S3cZ5qF17Q/
         WsHwkd9YPloVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/12] net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free
Date:   Mon,  9 Aug 2021 20:59:16 -0700
Message-Id: <20210810035923.345745-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

mlx5e_close_xdpsq does the cleanup: it calls mlx5e_free_xdpsq_descs to
free the outstanding descriptors, which relies on
mlx5e_page_release_dynamic and page_pool_release_page. However,
page_pool_destroy is already called by this point, because
mlx5e_close_rq runs before mlx5e_close_xdpsq.

This commit fixes the use-after-free by swapping mlx5e_close_xdpsq and
mlx5e_close_rq.

The commit cited below started calling page_pool_destroy directly from
the driver. Previously, the page pool was destroyed under a call_rcu
from xdp_rxq_info_unreg_mem_model, which would defer the deallocation
until after the XDPSQ is cleaned up.

Fixes: 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 37c440837945..fd250f7bcd88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1891,30 +1891,30 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	if (err)
 		goto err_close_icosq;
 
+	err = mlx5e_open_rxq_rq(c, params, &cparam->rq);
+	if (err)
+		goto err_close_sqs;
+
 	if (c->xdp) {
 		err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL,
 				       &c->rq_xdpsq, false);
 		if (err)
-			goto err_close_sqs;
+			goto err_close_rq;
 	}
 
-	err = mlx5e_open_rxq_rq(c, params, &cparam->rq);
-	if (err)
-		goto err_close_xdp_sq;
-
 	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, NULL, &c->xdpsq, true);
 	if (err)
-		goto err_close_rq;
+		goto err_close_xdp_sq;
 
 	return 0;
 
-err_close_rq:
-	mlx5e_close_rq(&c->rq);
-
 err_close_xdp_sq:
 	if (c->xdp)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
 
+err_close_rq:
+	mlx5e_close_rq(&c->rq);
+
 err_close_sqs:
 	mlx5e_close_sqs(c);
 
@@ -1949,9 +1949,9 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 static void mlx5e_close_queues(struct mlx5e_channel *c)
 {
 	mlx5e_close_xdpsq(&c->xdpsq);
-	mlx5e_close_rq(&c->rq);
 	if (c->xdp)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
+	mlx5e_close_rq(&c->rq);
 	mlx5e_close_sqs(c);
 	mlx5e_close_icosq(&c->icosq);
 	mlx5e_close_icosq(&c->async_icosq);
-- 
2.31.1

