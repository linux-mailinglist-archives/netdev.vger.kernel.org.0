Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2405A5ECEB9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiI0UhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiI0Ugu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3358B85FAA
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA3A4B81C19
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BF3C433C1;
        Tue, 27 Sep 2022 20:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311007;
        bh=Kcb1hWi/+6H9adD2DLmYGtYMG/CqS/zGpXXxLw2qzT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWNQE+lbTEmBEgjrH0z0tHnAzZxfDmfFvJWTqHbmyqITABJp4Fh+0t8e4tLcgN+oT
         8FBiotLfI6om2xqjots2SAzYDOOGz/Lrqyh1WLVKBZ9HizBvSxZXYftKkxi+3PKb0M
         W8AH1L75f9uxZG9AKZ6FvrXAwmEK5z0n7oV9KOUAuYTT1zDsQX+YUc6wzoEa06RO7u
         TTeRDt01QKb5qlj7t3rSzHc+yLY6Hyp2In+vh80A8ck3p98MVk21ngtRJK9FPOk1RQ
         pLhAfaefVJvvSlvEf3PRb/Tmsw9rks4sDbxq7EDA9JJjr/i+w3eJIikdna/m4wOioq
         uVJwCyHHNHcqw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 09/16] net/mlx5e: Use the aligned max TX MPWQE size
Date:   Tue, 27 Sep 2022 13:36:04 -0700
Message-Id: <20220927203611.244301-10-saeed@kernel.org>
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

TX MPWQE size is limited to the cacheline-aligned maximum. Use the same
value for the stop room and the capability check.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h   | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 5 +++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 2be09cc3c437..2c8fe2e60e17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -209,11 +209,11 @@ u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *par
 	stop_room  = mlx5e_ktls_get_stop_room(mdev, params);
 	stop_room += mlx5e_stop_room_for_max_wqe(mdev);
 	if (is_mpwqe)
-		/* A MPWQE can take up to the maximum-sized WQE + all the normal
-		 * stop room can be taken if a new packet breaks the active
-		 * MPWQE session and allocates its WQEs right away.
+		/* A MPWQE can take up to the maximum cacheline-aligned WQE +
+		 * all the normal stop room can be taken if a new packet breaks
+		 * the active MPWQE session and allocates its WQEs right away.
 		 */
-		stop_room += mlx5e_stop_room_for_max_wqe(mdev);
+		stop_room += mlx5e_stop_room_for_mpwqe(mdev);
 
 	return stop_room;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index c208ea307bff..8751e48e283d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -439,6 +439,13 @@ static inline u16 mlx5e_stop_room_for_max_wqe(struct mlx5_core_dev *mdev)
 	return MLX5E_STOP_ROOM(mlx5e_get_max_sq_wqebbs(mdev));
 }
 
+static inline u16 mlx5e_stop_room_for_mpwqe(struct mlx5_core_dev *mdev)
+{
+	u8 mpwqe_wqebbs = mlx5e_get_max_sq_aligned_wqebbs(mdev);
+
+	return mlx5e_stop_room_for_wqe(mdev, mpwqe_wqebbs);
+}
+
 static inline bool mlx5e_icosq_can_post_wqe(struct mlx5e_icosq *sq, u16 wqe_size)
 {
 	u16 room = sq->reserved_room;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e7fea19ac523..a3013d5190d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -75,7 +75,7 @@ bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 
 	striding_rq_umr = MLX5_CAP_GEN(mdev, striding_rq) && MLX5_CAP_GEN(mdev, umr_ptr_rlky) &&
 			  MLX5_CAP_ETH(mdev, reg_umr_sq);
-	max_wqe_sz_cap = mlx5e_get_max_sq_wqebbs(mdev) * MLX5_SEND_WQE_BB;
+	max_wqe_sz_cap = mlx5e_get_max_sq_aligned_wqebbs(mdev) * MLX5_SEND_WQE_BB;
 	inline_umr = max_wqe_sz_cap >= MLX5E_UMR_WQE_INLINE_SZ;
 	if (!striding_rq_umr)
 		return false;
@@ -1155,7 +1155,8 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 		is_redirect ?
 			&c->priv->channel_stats[c->ix]->xdpsq :
 			&c->priv->channel_stats[c->ix]->rq_xdpsq;
-	sq->stop_room = mlx5e_stop_room_for_max_wqe(mdev);
+	sq->stop_room = param->is_mpw ? mlx5e_stop_room_for_mpwqe(mdev) :
+					mlx5e_stop_room_for_max_wqe(mdev);
 	sq->max_sq_mpw_wqebbs = mlx5e_get_max_sq_aligned_wqebbs(mdev);
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
-- 
2.37.3

