Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC0340AE7A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhINNAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233189AbhINNAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 759FA610A6;
        Tue, 14 Sep 2021 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631624331;
        bh=md8Nqetrp5TiG5nDbCqbVcBHsLjT7Vg0qPhWlKEbSB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew6EYNDb0YobQiZt5QAQ2BPWAUNi4ApRL6ECvhyub5HPdDrDhHWKfBXpv/tOyAsSi
         bI0zHBKsXJ3ItGJYcCeTIiwM57LxGpzWI8uDIPJEwwHFCORryKqr8Ywtu4mswK5jTn
         Q5mJNucf0CHm5biTQ2LMMwb9QOKk2avt0Lf1H+doe2NIZG0ihORZMsShJ11sbMe+yH
         ZNaqbUV6nN1R0hDZbbenf9HXSn84qXf94b5Phv0QyCnwCZwHi9NfDZ7NWzfkvTcn9M
         3vso8qWkMzb/T/RAJtKZ5e6sxXBDRVkd9teblXtSzAH5btgo9wy14PJDIXruM4EmEa
         y7Meh2bgptMww==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/2] net/mlx5: Publish and unpublish all devlink parameters at once
Date:   Tue, 14 Sep 2021 15:58:28 +0300
Message-Id: <3d803cdf1104a97d23c5461869ff2f9cec12825b.1631623748.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631623748.git.leonro@nvidia.com>
References: <cover.1631623748.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The devlink parameters were published in two steps despite being static
and known in advance.

First step was to use devlink_params_publish() which iterated over all
known up to that point parameters and sent notification messages.
In second step, the call was devlink_param_publish() that looped over
same parameters list and sent notification for new parameters.

In order to simplify the API, move devlink_params_publish() to be called
when all parameters were already added and save the need to iterate over
parameters list again.

As a side effect, this change fixes the error unwind flow in which
parameters were not marked as unpublished.

Fixes: 82e6c96f04e1 ("net/mlx5: Register to devlink ingress VLAN filter trap")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e84287ffc7ce..dde8c03c5cfe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -625,7 +625,6 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 					   value);
-	devlink_param_publish(devlink, &enable_eth_param);
 	return 0;
 }
 
@@ -636,7 +635,6 @@ static void mlx5_devlink_eth_param_unregister(struct devlink *devlink)
 	if (!mlx5_eth_supported(dev))
 		return;
 
-	devlink_param_unpublish(devlink, &enable_eth_param);
 	devlink_param_unregister(devlink, &enable_eth_param);
 }
 
@@ -673,7 +671,6 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 					   value);
-	devlink_param_publish(devlink, &enable_rdma_param);
 	return 0;
 }
 
@@ -684,7 +681,6 @@ static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND) || MLX5_ESWITCH_MANAGER(dev))
 		return;
 
-	devlink_param_unpublish(devlink, &enable_rdma_param);
 	devlink_param_unregister(devlink, &enable_rdma_param);
 }
 
@@ -709,7 +705,6 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 					   value);
-	devlink_param_publish(devlink, &enable_rdma_param);
 	return 0;
 }
 
@@ -720,7 +715,6 @@ static void mlx5_devlink_vnet_param_unregister(struct devlink *devlink)
 	if (!mlx5_vnet_supported(dev))
 		return;
 
-	devlink_param_unpublish(devlink, &enable_vnet_param);
 	devlink_param_unregister(devlink, &enable_vnet_param);
 }
 
@@ -811,7 +805,6 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
-	devlink_params_publish(devlink);
 
 	err = mlx5_devlink_auxdev_params_register(devlink);
 	if (err)
@@ -821,6 +814,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	devlink_params_publish(devlink);
 	return 0;
 
 traps_reg_err:
@@ -835,9 +829,9 @@ int mlx5_devlink_register(struct devlink *devlink)
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_params_unpublish(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
-	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
-- 
2.31.1

