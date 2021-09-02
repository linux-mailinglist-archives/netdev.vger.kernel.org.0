Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9684C3FF3CA
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347307AbhIBTHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347293AbhIBTHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8173760F11;
        Thu,  2 Sep 2021 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609564;
        bh=myKpKcNYGnXfNj/5egsbb6+3N8jw5BxNBdyS+Rup2T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQqf/m5DOS8pCvKIR3NXJQSg33ACHVJWdxoaqLrpQtZm5Vr1iUatxxEBK8uyKU0U2
         rgaDZx9dKsYly7ugKfn+KEJOvIgo8RtD42sV1s7eCKC5NR89QsC8jFwjmnBPrEDrZN
         FBRt3pAqjkv/avMSukiOHbr+z0p78NDKO8gTAlOHjXwxqImcLE4tVA/EHA/KlNGGDy
         ZefzP/Ddy+iQdNGZiUzgvSZN53iIwnv3stZ2SR/lr/CeAWvnW3IubrioFVKdWyndDf
         mrBxQbct3jcMz/oGjEyt+MWzrMONN/UCb/VEkZlNsErVfK/bFnqgWhJ2Sm5ZVYXR/7
         0q6hrC6gX/0uA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Fix rdma aux device on devlink reload
Date:   Thu,  2 Sep 2021 12:05:40 -0700
Message-Id: <20210902190554.211497-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

RDMA auxdev parameter registration was skipped for eswitch manager PCI PF.
Due to this when devlink parameter is read, it reads as false in below
code flow.

$ devlink dev reload pci/0000:06:00.0
  devlink_reload()
    mlx5_load_one()
      mlx5_attach_device()
        is_ib_enabled()
          devlink_param_driverinit_value_get()

Due to this, is_ib_enabled() returns false for the RDMA auxiliary
device. This results into a skipping RDMA auxiliary device creation on
reload.

There is no need to check for eswitch manager capability to support RDMA
auxiliary device. Hence, fix it by skipping eswitch manager capability.

Fixes: 87158cedf00e ("net/mlx5: Support enable_rdma devlink dev param")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e84287ffc7ce..dcf9f27ba2ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -658,11 +658,10 @@ static const struct devlink_param enable_rdma_param =
 
 static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 	int err;
 
-	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND) || MLX5_ESWITCH_MANAGER(dev))
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return 0;
 
 	err = devlink_param_register(devlink, &enable_rdma_param);
@@ -679,9 +678,7 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 
 static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND) || MLX5_ESWITCH_MANAGER(dev))
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return;
 
 	devlink_param_unpublish(devlink, &enable_rdma_param);
-- 
2.31.1

