Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502EE3A2154
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhFJAYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhFJAYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AF2613EF;
        Thu, 10 Jun 2021 00:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284539;
        bh=hqIifpZ2hKuNQvR8dBQjsiKdQEhhaYd5zWEaW7uq3ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gezYU5Cgy4nqBHdFImYbaztlzhNnk8Eg6AW0tQ2pELadCXfTkK+VG13nKPCpsMkuD
         Daaj1ai/GYw71rSNH2i/+gdoEE38VfBg1jB6+YKUc4T3YNUb4iFbkQ+owDTRmwW4jw
         pdCuoFObwFSzWCA/JE+ypDMTMv8qUS9ZJMqp/PEd8SYKQUCuzjqM8J0gtVFX+MtUoN
         BI/izopnJeoC0+vJiQjj2JJszWblvcWkV9FEYFuMuKPrAFjo0ThtRce8LyAjuEek2H
         Y/v1ydkpVPapua12QKhdm0qKc5fW8fTIgawpaEkcdv7l9YMOOptABPhTYdu7ajbZCj
         skuno4PP8lDFw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/12] net/mlx5: DR, Don't use SW steering when RoCE is not supported
Date:   Wed,  9 Jun 2021 17:21:49 -0700
Message-Id: <20210610002155.196735-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

SW steering uses RC QP to write/read to/from ICM, hence it's not
supported when RoCE is not supported as well.

Fixes: 70605ea545e8 ("net/mlx5: DR, Expose APIs for direct rule managing")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h    | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 612b0ac31db2..9737565cd8d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -124,10 +124,11 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action);
 static inline bool
 mlx5dr_is_supported(struct mlx5_core_dev *dev)
 {
-	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner) ||
-	       (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner_v2) &&
-		(MLX5_CAP_GEN(dev, steering_format_version) <=
-		 MLX5_STEERING_FORMAT_CONNECTX_6DX));
+	return MLX5_CAP_GEN(dev, roce) &&
+	       (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner) ||
+		(MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner_v2) &&
+		 (MLX5_CAP_GEN(dev, steering_format_version) <=
+		  MLX5_STEERING_FORMAT_CONNECTX_6DX)));
 }
 
 /* buddy functions & structure */
-- 
2.31.1

