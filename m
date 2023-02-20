Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082F769C547
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjBTGRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjBTGRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADCBF764
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DEE8B80A4A
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120CEC433D2;
        Mon, 20 Feb 2023 06:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873824;
        bh=K5HGPxKAqEI8Kt5L9G1L/05Ankv+FZI2HXxp9DgP18A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W74ZLQZh4XoQlToeFwqZrBieXAZ2jkMs06j8BLUPLS1KUZgIOyxvdEYklHc+T5Sfx
         Um1uCv6pLPBIuBo2z19IKqzKLBjq64yeGDlVS8m6VDhE5Eg4wE1AIXCo79fwtTVtBU
         X0f97kJ9kGSNX3sLBjoUyW+/8/YKuk68gd83Psf+BeQJbcc747suQj2fZRWWoFm6bk
         7X/oWGDF8PuVsE3MnTpgVCnl41MJfOPRYLB6VsGASl4ATfHRR45t3Q/bGChzkMgm+t
         gP/RoR/A0rbczrRJE9QA/j1XTltYACxRPzG3dWXzOImnQpGUdYKC0U+FrUCqHKhu5T
         kcKpVz0NQpL3Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 11/14] net/mlx5: Move devlink registration before mlx5_load
Date:   Sun, 19 Feb 2023 22:14:39 -0800
Message-Id: <20230220061442.403092-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

In order to allow reference to devlink parameters during driver load,
move the devlink registration before mlx5_load. Subsequent patch will
use it to control the number of completion vectors required based on
whether eth is enabled or not.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 38f4374cc5e0..a0e2c525a2fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1399,16 +1399,16 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 		goto function_teardown;
 	}
 
+	err = mlx5_devlink_params_register(priv_to_devlink(dev));
+	if (err)
+		goto err_devlink_params_reg;
+
 	err = mlx5_load(dev);
 	if (err)
 		goto err_load;
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	err = mlx5_devlink_params_register(priv_to_devlink(dev));
-	if (err)
-		goto err_devlink_params_reg;
-
 	err = mlx5_register_device(dev);
 	if (err)
 		goto err_register;
@@ -1418,11 +1418,11 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	return 0;
 
 err_register:
-	mlx5_devlink_params_unregister(priv_to_devlink(dev));
-err_devlink_params_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
+err_devlink_params_reg:
 	mlx5_cleanup_once(dev);
 function_teardown:
 	mlx5_function_teardown(dev, true);
@@ -1441,7 +1441,6 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	mutex_lock(&dev->intf_state_mutex);
 
 	mlx5_unregister_device(dev);
-	mlx5_devlink_params_unregister(priv_to_devlink(dev));
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
@@ -1452,6 +1451,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
 	mlx5_cleanup_once(dev);
 	mlx5_function_teardown(dev, true);
 out:
-- 
2.39.1

