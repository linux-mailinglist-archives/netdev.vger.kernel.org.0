Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F40D31986B
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBLC6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhBLC6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DF4364E77;
        Fri, 12 Feb 2021 02:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098643;
        bh=9xA4BaoUt1Y+XA23Z7/Os34i9eXPsxVMnWzXU2hdS5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoCVj2YzMMkyEy2IA7Vfu/rKU8mX5efxJ/uwow2ZUxc7tRbPBE3W+7Cgd+rZ+Uax9
         vWSvYXVfNXXFwaRrDz08mvNgfBjnWPWgkk4zMGAy0MkeLLOk2TumxK3I3PB0DS+12B
         3TqM3+Zhq+RjwLdv9JPl53FOHcr0HWmkPFdiEH26iz/rrqrS6Eq/V9I7EXvb7oqwue
         JmKwEOP8DdOe/f5uvs1WdCACrKfq3t6MmNJMXPHl/KeuGYRme2RvqNJz/X9wnGd4DF
         E5PFkRUMJdV4U6/spycN+kE0HzOMHdCC0FOG1EE/sndCXPYkve6Hmfbhx3EmURfuR9
         yS+e8uWiI5vrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/15] net/mlx5: Fix health error state handling
Date:   Thu, 11 Feb 2021 18:56:32 -0800
Message-Id: <20210212025641.323844-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, when we discover a fatal error, we are queueing a work that
will wait for a lock in order to enter the device to error state.
Meanwhile, FW commands are still being processed, and gets timeouts.
This can block the driver for few minutes before the work will manage
to get the lock and enter to error state.

Setting the device to error state before queueing health work, in order
to avoid FW commands being processed while the work is waiting for the
lock.

Fixes: c1d4d2e92ad6 ("net/mlx5: Avoid calling sleeping function by the health poll thread")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 54523bed16cd..0c32c485eb58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -190,6 +190,16 @@ static bool reset_fw_if_needed(struct mlx5_core_dev *dev)
 	return true;
 }
 
+static void enter_error_state(struct mlx5_core_dev *dev, bool force)
+{
+	if (mlx5_health_check_fatal_sensors(dev) || force) { /* protected state setting */
+		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+		mlx5_cmd_flush(dev);
+	}
+
+	mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_SYS_ERROR, (void *)1);
+}
+
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 {
 	bool err_detected = false;
@@ -208,12 +218,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 		goto unlock;
 	}
 
-	if (mlx5_health_check_fatal_sensors(dev) || force) { /* protected state setting */
-		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
-		mlx5_cmd_flush(dev);
-	}
-
-	mlx5_notifier_call_chain(dev->priv.events, MLX5_DEV_EVENT_SYS_ERROR, (void *)1);
+	enter_error_state(dev, force);
 unlock:
 	mutex_unlock(&dev->intf_state_mutex);
 }
@@ -613,7 +618,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	priv = container_of(health, struct mlx5_priv, health);
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 
-	mlx5_enter_error_state(dev, false);
+	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		if (mlx5_health_try_recover(dev))
 			mlx5_core_err(dev, "health recovery failed\n");
@@ -707,8 +712,9 @@ static void poll_health(struct timer_list *t)
 		mlx5_core_err(dev, "Fatal error %u detected\n", fatal_error);
 		dev->priv.health.fatal_error = fatal_error;
 		print_health_info(dev);
+		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 		mlx5_trigger_health_work(dev);
-		goto out;
+		return;
 	}
 
 	count = ioread32be(health->health_counter);
-- 
2.29.2

