Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832F05F2169
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiJBFOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJBFOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280D252090
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD595B8075B
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58760C433D7;
        Sun,  2 Oct 2022 05:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687647;
        bh=v+ZiVtfxyhUwI0OL+TNoshPOxwK2xlkrOp+1Dhewy7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf98N4L+INR72wUUOFc2AL3qO0PhanKoOFavOaY9l+YfMKuAvuxCZ6fZqIoAms/oD
         vvNlT+U0SOKo2o9mOSl/z1rWAWy12UxfZWjxF9exxP4zkSa2V+ADEYuv4Tt6OlliPm
         sCPdFn77hnhEuxybNPiO43KhsKxijGZ6VkSHUGuHFc6xT0C962pr+3tO1eUIfVQhg2
         fLqp+sV4nAbg/hCLM2xlW6fWkL9hPX0hQi0hw2aDcq8tFsZ5gYGQ0cebbuSC6NwBVd
         1FvjIs7BkMS9Jkowa5ijZtp+IfUHqr/LpNA5O7kF4SyZn1uiqge/m/14NY5cO2zXnb
         VdEXDKDpiiK/A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 12/15] net/mlx5: Set default grace period based on function type
Date:   Sat,  1 Oct 2022 21:56:29 -0700
Message-Id: <20221002045632.291612-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

Currently, driver sets the same grace period for fw fatal health reporter
to any type of function.

Since the lower level functions are more vulnerable to fw fatal errors as a
result of parent function closure/reload, set a smaller grace period for
the lower level functions, as follows:

1. For ECPF: 180 seconds.
2. For PF: 60 seconds.
3. For VF/SF: 30 seconds.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c   | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 5bfc54a10621..86ed87d704f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -702,11 +702,25 @@ static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
 		.dump = mlx5_fw_fatal_reporter_dump,
 };
 
-#define MLX5_REPORTER_FW_GRACEFUL_PERIOD 1200000
+#define MLX5_FW_REPORTER_ECPF_GRACEFUL_PERIOD 180000
+#define MLX5_FW_REPORTER_PF_GRACEFUL_PERIOD 60000
+#define MLX5_FW_REPORTER_VF_GRACEFUL_PERIOD 30000
+#define MLX5_FW_REPORTER_DEFAULT_GRACEFUL_PERIOD MLX5_FW_REPORTER_VF_GRACEFUL_PERIOD
+
 static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 	struct devlink *devlink = priv_to_devlink(dev);
+	u64 grace_period;
+
+	if (mlx5_core_is_ecpf(dev)) {
+		grace_period = MLX5_FW_REPORTER_ECPF_GRACEFUL_PERIOD;
+	} else if (mlx5_core_is_pf(dev)) {
+		grace_period = MLX5_FW_REPORTER_PF_GRACEFUL_PERIOD;
+	} else {
+		/* VF or SF */
+		grace_period = MLX5_FW_REPORTER_DEFAULT_GRACEFUL_PERIOD;
+	}
 
 	health->fw_reporter =
 		devlink_health_reporter_create(devlink, &mlx5_fw_reporter_ops,
@@ -718,7 +732,7 @@ static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 	health->fw_fatal_reporter =
 		devlink_health_reporter_create(devlink,
 					       &mlx5_fw_fatal_reporter_ops,
-					       MLX5_REPORTER_FW_GRACEFUL_PERIOD,
+					       grace_period,
 					       dev);
 	if (IS_ERR(health->fw_fatal_reporter))
 		mlx5_core_warn(dev, "Failed to create fw fatal reporter, err = %ld\n",
-- 
2.37.3

