Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B2B3DE45C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhHCC3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhHCC3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59CA56109F;
        Tue,  3 Aug 2021 02:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957740;
        bh=bB1O291EAz7I9z6S1LwqdKM9h6P7eGhfJCp1fd1fMK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlCG+Xny16JWeuRVfsyxawDNHPeid5YHz59Jok5ftwSqhPP3UOiZzHQ9XcrZrtTK/
         6nkJO33hWU1SYq6OmGCVF97jUPv6QY8WoZ9fzYxF3LaN58IrW+ECeq31geOCfr4c76
         0QRIRlIP0nSg1+xLIGLpD7d5aZN+//0RHJ81AFGL+XMDp7ACMgDujftLsMJ71XVd3c
         rCBN3ZYBZW4VoxSAqqHfk6n8Go0kJBRCrq+5+/vYoVWUivwFn8Ub6drOGWwWvonmTm
         VVljEKOc2Ifiqgk/jrMi5hXYcz6rqPC3l1oU8pTSeMxRPfsCxeNYEldWewCmT120ae
         Pp9oU4UZY72Lg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5e: Allocate the array of channels according to the real max_nch
Date:   Mon,  2 Aug 2021 19:28:41 -0700
Message-Id: <20210803022853.106973-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The channels array in struct mlx5e_rx_res is converted to a dynamic one,
which will use the dynamic value of max_nch instead of
implementation-defined maximum of MLX5E_MAX_NUM_CHANNELS.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c | 12 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h |  2 --
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 968e6a473cec..594b7971caf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -140,6 +140,7 @@ struct page_pool;
 #define MLX5E_PARAMS_DEFAULT_MIN_RX_WQES_MPW            0x2
 
 #define MLX5E_MIN_NUM_CHANNELS         0x1
+#define MLX5E_MAX_NUM_CHANNELS         (MLX5E_INDIR_RQT_SIZE / 2)
 #define MLX5E_MAX_NUM_SQS              (MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC)
 #define MLX5E_TX_CQ_POLL_BUDGET        128
 #define MLX5E_TX_XSK_POLL_BUDGET       64
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index a6b3a9473405..751b2cdc3ec1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -91,7 +91,7 @@ struct mlx5e_rx_res {
 		struct mlx5e_tir direct_tir;
 		struct mlx5e_rqt xsk_rqt;
 		struct mlx5e_tir xsk_tir;
-	} channels[MLX5E_MAX_NUM_CHANNELS];
+	} *channels;
 
 	struct {
 		struct mlx5e_rqt rqt;
@@ -210,6 +210,12 @@ static int mlx5e_rx_res_channels_init(struct mlx5e_rx_res *res,
 	if (!builder)
 		return -ENOMEM;
 
+	res->channels = kvcalloc(res->max_nch, sizeof(*res->channels), GFP_KERNEL);
+	if (!res->channels) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	for (ix = 0; ix < res->max_nch; ix++) {
 		err = mlx5e_rqt_init_direct(&res->channels[ix].direct_rqt,
 					    res->mdev, false, res->drop_rqn);
@@ -288,6 +294,8 @@ static int mlx5e_rx_res_channels_init(struct mlx5e_rx_res *res,
 	while (--ix >= 0)
 		mlx5e_rqt_destroy(&res->channels[ix].direct_rqt);
 
+	kvfree(res->channels);
+
 out:
 	mlx5e_tir_builder_free(builder);
 
@@ -355,6 +363,8 @@ static void mlx5e_rx_res_channels_destroy(struct mlx5e_rx_res *res)
 		mlx5e_tir_destroy(&res->channels[ix].xsk_tir);
 		mlx5e_rqt_destroy(&res->channels[ix].xsk_rqt);
 	}
+
+	kvfree(res->channels);
 }
 
 static void mlx5e_rx_res_ptp_destroy(struct mlx5e_rx_res *res)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
index 0092ee80a2cf..934e41a0761f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h
@@ -9,8 +9,6 @@
 #include "tir.h"
 #include "fs.h"
 
-#define MLX5E_MAX_NUM_CHANNELS (MLX5E_INDIR_RQT_SIZE / 2)
-
 struct mlx5e_rx_res;
 
 struct mlx5e_channels;
-- 
2.31.1

