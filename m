Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57C65F2167
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJBFOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJBFOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3D551A23
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06CA260E04
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596AAC433B5;
        Sun,  2 Oct 2022 05:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687646;
        bh=pBsYphoR/hq0SV+iO+MtiSYa3Yf3FGYBOfY2l5HuYz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qU7eJJidieMwv9FjrR3v/r/gOctJb8PziFkVQ4Sjv678cn1xCZEkeFUFIuq/pIeyN
         FNBoUaKoHY40eO4+LMJHiKAhaSZ873MfxbHlZ9eRl59tTXAlxy+BQe014ZtXl/6q7a
         b4W3kDazpHLg3h8YOtesEnipBr4pHUqDCnJTL92oniWohZMyRs/CBA3622H82m7vOU
         8B3e4eId42aP8qc4UoFofiQL0w+iQYUOvuaVo2g2QZQqFWYo/o+VdWDE95L5GzcdVU
         Rsr/vuFiOWLVPN336n8nybzfmCmK8IiRulgtNJ1gYEjvwduWsgdHlt65Iyf+iEy5rY
         gwjAbz2FvLqxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 11/15] net/mlx5: Start health poll at earlier stage of driver load
Date:   Sat,  1 Oct 2022 21:56:28 -0700
Message-Id: <20221002045632.291612-12-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

Start health poll at earlier stage, so if fw fatal issue occurred before
or during initialization commands such as init_hca or set_hca_cap the
poll health can detect and indicate that the driver is already in error
state.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c    | 11 ++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c  | 17 ++++++++++-------
 include/linux/mlx5/driver.h                     |  1 +
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 59205ba2ef7b..5bfc54a10621 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -843,9 +843,6 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev)
 
 	health->timer.expires = jiffies + msecs_to_jiffies(poll_interval_ms);
 	add_timer(&health->timer);
-
-	if (mlx5_core_is_pf(dev) && MLX5_CAP_MCAM_REG(dev, mrtc))
-		queue_delayed_work(health->wq, &health->update_fw_log_ts_work, 0);
 }
 
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health)
@@ -862,6 +859,14 @@ void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health)
 	del_timer_sync(&health->timer);
 }
 
+void mlx5_start_health_fw_log_up(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	if (mlx5_core_is_pf(dev) && MLX5_CAP_MCAM_REG(dev, mrtc))
+		queue_delayed_work(health->wq, &health->update_fw_log_ts_work, 0);
+}
+
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index daa7442f31c9..0b459d841c3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1092,7 +1092,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_devcom_unregister_device(dev->priv.devcom);
 }
 
-static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
+static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot, u64 timeout)
 {
 	int err;
 
@@ -1130,10 +1130,12 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
 
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_UP);
 
+	mlx5_start_health_poll(dev);
+
 	err = mlx5_core_enable_hca(dev, 0);
 	if (err) {
 		mlx5_core_err(dev, "enable hca failed\n");
-		goto err_cmd_cleanup;
+		goto stop_health_poll;
 	}
 
 	err = mlx5_core_set_issi(dev);
@@ -1185,8 +1187,7 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
 		mlx5_core_err(dev, "query hca failed\n");
 		goto reclaim_boot_pages;
 	}
-
-	mlx5_start_health_poll(dev);
+	mlx5_start_health_fw_log_up(dev);
 
 	return 0;
 
@@ -1194,6 +1195,8 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
 	mlx5_reclaim_startup_pages(dev);
 err_disable_hca:
 	mlx5_core_disable_hca(dev, 0);
+stop_health_poll:
+	mlx5_stop_health_poll(dev, boot);
 err_cmd_cleanup:
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
@@ -1205,7 +1208,6 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 {
 	int err;
 
-	mlx5_stop_health_poll(dev, boot);
 	err = mlx5_cmd_teardown_hca(dev);
 	if (err) {
 		mlx5_core_err(dev, "tear_down_hca failed, skip cleanup\n");
@@ -1213,6 +1215,7 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	}
 	mlx5_reclaim_startup_pages(dev);
 	mlx5_core_disable_hca(dev, 0);
+	mlx5_stop_health_poll(dev, boot);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
 
@@ -1362,7 +1365,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	mutex_lock(&dev->intf_state_mutex);
 	dev->state = MLX5_DEVICE_STATE_UP;
 
-	err = mlx5_function_setup(dev, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
+	err = mlx5_function_setup(dev, true, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
 	if (err)
 		goto err_function;
 
@@ -1450,7 +1453,7 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
 		timeout = mlx5_tout_ms(dev, FW_PRE_INIT_ON_RECOVERY_TIMEOUT);
 	else
 		timeout = mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT);
-	err = mlx5_function_setup(dev, timeout);
+	err = mlx5_function_setup(dev, false, timeout);
 	if (err)
 		goto err_function;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 285f301a6390..a12929bc31b2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1017,6 +1017,7 @@ void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health);
+void mlx5_start_health_fw_log_up(struct mlx5_core_dev *dev);
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev);
 void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
 int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
-- 
2.37.3

