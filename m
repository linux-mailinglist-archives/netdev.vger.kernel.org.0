Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F8747CBA5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbhLVDQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbhLVDQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1864C061751
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 19:16:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2AB8617F8
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D46C36AEC;
        Wed, 22 Dec 2021 03:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142979;
        bh=nPInWnVrjUT61sQ8Y5bo4aMnI8TeMWjF7LaNiwcj6S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW252hpcbdDm5JE5TDr1fkJ66Pu9nOa4ekCiLvw6NBLr71Z/M5Nevwud7AZMbvL7p
         G5TTN7MXZdS3NDrNefmlDDGlVXdcvniTwbzkVYxkp3ae8+F/q39KQJlcNx9qgNdRE5
         vUgxhjvvRSBGRjwXLtbPx8tX5nJx5065YwwnQ3xr9fGI6FhNNu2m7TuKZkhb0k5a0U
         AycnwwiibRiZD1RfS78BwaCsNQ20+cjVv8J5YtUsxqUlA45YTFSiMFohpbV3ExqPLG
         A9DAQlve/nnqCsgFEw+CmIIRzurzhlIM2DOnizCb1kvVFPrSzPSnMQvMkI0TS/muE9
         UVeGJ4+HkRw+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 14/14] net/mlx5e: Take packet_merge params directly from the RX res struct
Date:   Tue, 21 Dec 2021 19:16:04 -0800
Message-Id: <20211222031604.14540-15-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

As packet_merge params structure is saved on the RX resources structure, there
is no need to pass it separately.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index 0015a81eb9a1..24c32f73040a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -37,7 +37,6 @@ struct mlx5e_rx_res {
 /* API for rx_res_rss_* */
 
 static int mlx5e_rx_res_rss_init_def(struct mlx5e_rx_res *res,
-				     const struct mlx5e_packet_merge_param *init_pkt_merge_param,
 				     unsigned int init_nch)
 {
 	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
@@ -52,7 +51,7 @@ static int mlx5e_rx_res_rss_init_def(struct mlx5e_rx_res *res,
 		return -ENOMEM;
 
 	err = mlx5e_rss_init(rss, res->mdev, inner_ft_support, res->drop_rqn,
-			     init_pkt_merge_param);
+			     &res->pkt_merge_param);
 	if (err)
 		goto err_rss_free;
 
@@ -277,8 +276,7 @@ struct mlx5e_rx_res *mlx5e_rx_res_alloc(void)
 	return kvzalloc(sizeof(struct mlx5e_rx_res), GFP_KERNEL);
 }
 
-static int mlx5e_rx_res_channels_init(struct mlx5e_rx_res *res,
-				      const struct mlx5e_packet_merge_param *init_pkt_merge_param)
+static int mlx5e_rx_res_channels_init(struct mlx5e_rx_res *res)
 {
 	bool inner_ft_support = res->features & MLX5E_RX_RES_FEATURE_INNER_FT;
 	struct mlx5e_tir_builder *builder;
@@ -309,7 +307,7 @@ static int mlx5e_rx_res_channels_init(struct mlx5e_rx_res *res,
 		mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
 					    mlx5e_rqt_get_rqtn(&res->channels[ix].direct_rqt),
 					    inner_ft_support);
-		mlx5e_tir_builder_build_packet_merge(builder, init_pkt_merge_param);
+		mlx5e_tir_builder_build_packet_merge(builder, &res->pkt_merge_param);
 		mlx5e_tir_builder_build_direct(builder);
 
 		err = mlx5e_tir_init(&res->channels[ix].direct_tir, builder, res->mdev, true);
@@ -339,7 +337,7 @@ static int mlx5e_rx_res_channels_init(struct mlx5e_rx_res *res,
 		mlx5e_tir_builder_build_rqt(builder, res->mdev->mlx5e_res.hw_objs.td.tdn,
 					    mlx5e_rqt_get_rqtn(&res->channels[ix].xsk_rqt),
 					    inner_ft_support);
-		mlx5e_tir_builder_build_packet_merge(builder, init_pkt_merge_param);
+		mlx5e_tir_builder_build_packet_merge(builder, &res->pkt_merge_param);
 		mlx5e_tir_builder_build_direct(builder);
 
 		err = mlx5e_tir_init(&res->channels[ix].xsk_tir, builder, res->mdev, true);
@@ -454,11 +452,11 @@ int mlx5e_rx_res_init(struct mlx5e_rx_res *res, struct mlx5_core_dev *mdev,
 	res->pkt_merge_param = *init_pkt_merge_param;
 	init_rwsem(&res->pkt_merge_param_sem);
 
-	err = mlx5e_rx_res_rss_init_def(res, init_pkt_merge_param, init_nch);
+	err = mlx5e_rx_res_rss_init_def(res, init_nch);
 	if (err)
 		goto err_out;
 
-	err = mlx5e_rx_res_channels_init(res, init_pkt_merge_param);
+	err = mlx5e_rx_res_channels_init(res);
 	if (err)
 		goto err_rss_destroy;
 
-- 
2.33.1

