Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7248E3AA6B3
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhFPWmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233953AbhFPWmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 579A3613F2;
        Wed, 16 Jun 2021 22:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883226;
        bh=R664l/Mg65Y9XylXGj7cn2WcAdUkXtKLPnXnZGpbNiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIFDTBesiItLOeTVog+094XhU0zTcb/FxuXWxSWCNk6LLk3pFhkBpQFIji24ZCmgi
         7GGkuug90Zlszp+UEwFhwOkW8IZRgt9LRmpnZAi0Y3Q/QChcxtudfNlHVB+eL4q8Fa
         fyYfw4mZ4K0gjhxfSCnTj7hRs87SxZDfAd1OFEVVXRPpnS9hpCHMhF1/UgZatGo1uh
         L05n93piDEsOr7bwzGYztlJ6P5XlD/Ww5ft9ans3SCWyx34/rD/zDENMrGYeYwwSpp
         bcpj2mDZS/iQ9ErHvRko9mPIQaidjmXTbZNWQ8RLSGVHgUjMIyQzFWFbLwwmrmKBY2
         HontS9UmHOwsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [net 1/8] net/mlx5: Fix error path for set HCA defaults
Date:   Wed, 16 Jun 2021 15:40:08 -0700
Message-Id: <20210616224015.14393-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In the case of the failure to execute mlx5_core_set_hca_defaults(),
we used wrong goto label to execute error unwind flow.

Fixes: 5bef709d76a2 ("net/mlx5: Enable host PF HCA after eswitch is initialized")
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a1d67bd7fb43..0d0f63a27aba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1161,7 +1161,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	err = mlx5_core_set_hca_defaults(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to set hca defaults\n");
-		goto err_sriov;
+		goto err_set_hca;
 	}
 
 	mlx5_vhca_event_start(dev);
@@ -1194,6 +1194,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	mlx5_sf_hw_table_destroy(dev);
 err_vhca:
 	mlx5_vhca_event_stop(dev);
+err_set_hca:
 	mlx5_cleanup_fs(dev);
 err_fs:
 	mlx5_accel_tls_cleanup(dev);
-- 
2.31.1

