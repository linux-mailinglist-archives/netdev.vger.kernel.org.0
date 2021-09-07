Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B001740303B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348445AbhIGVZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348298AbhIGVZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C59DD600D0;
        Tue,  7 Sep 2021 21:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049869;
        bh=myKpKcNYGnXfNj/5egsbb6+3N8jw5BxNBdyS+Rup2T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r35W435KeoUBg7HCV8jLU/686WK150Qti+CYYkrzJzQoh6jEPhi7ZtlmBbG8S6dLV
         BoY2bKgYQXdsVYu/9VVVDlCjmxUnQ9rRvLVndi2miCPB0jD5Dso2KalMoiw5bTGbb+
         S6YTn5eX55MPS1lKef0TTgOpMdkHFx00HPiPzdBLwag8pX4k4kDN3QDxSGvTpm3d2i
         xF9ghHX7QddXzJ0QJXzC9VLYSgMAeq9BnFtqihnWfz8X9E5vkcJ0aZpfxBPisl9hqJ
         GkwQyECGVvsYGBMOG26JEnelulyof0WYpc1g4/rr0+W0oth6iDzTI+uECbGYdh9Byi
         Wt299xKfleWKA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/7] net/mlx5: Fix rdma aux device on devlink reload
Date:   Tue,  7 Sep 2021 14:24:15 -0700
Message-Id: <20210907212420.28529-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
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

