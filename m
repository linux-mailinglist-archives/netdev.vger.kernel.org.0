Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1068E508
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBHAh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBHAhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709699762
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A08D61472
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD0AC4339B;
        Wed,  8 Feb 2023 00:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816639;
        bh=fbq5kj9OmIT69f9BQYM/Cy7zhiQILthGfJEDEjRb3Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrWblPiGE8H0NHKdUDeOsUpbELy/aKiDIWcZoAePDDO7boPeduqGKqYL2K5de7MA9
         VTAjpxneH0VB49FPodVzu0v1jmvHVCOX5zCv7e3ffajIryvwx5JqjxvOqHEcUVoQhn
         4bd+DMBRhW720tfdG1Pp70qTwnPOhnH85fx+GxPTLc3/VDQYp5WhWk27wC8QUL64/0
         7GA2nwQXieq70R27ViXXM36qLYdYtEc78trQf8NN4KBBzivkQvcwpVkU1ezpCnVsJ1
         K/qNhlQZxYQzggG78jLawWGrasTO/HOy4T3pfSJnrUSDSRM9Ulb8FElsZ/JCkPA0iJ
         mOjpHgb/tu/Kg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Remove redundant health work lock
Date:   Tue,  7 Feb 2023 16:36:59 -0800
Message-Id: <20230208003712.68386-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Commit 90e7cb78b815 ("net/mlx5: fix missing mutex_unlock in
mlx5_fw_fatal_reporter_err_work()") introduced another checking of
MLX5_DROP_HEALTH_NEW_WORK. At this point, the first check of
MLX5_DROP_HEALTH_NEW_WORK is redundant and so is the lock that
protects it.

Remove the lock and rename MLX5_DROP_HEALTH_NEW_WORK to reflect these
changes.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 28 +++++--------------
 include/linux/mlx5/driver.h                   |  2 --
 2 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 879555ba847d..1e8bee906c31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -62,7 +62,7 @@ enum {
 };
 
 enum {
-	MLX5_DROP_NEW_HEALTH_WORK,
+	MLX5_DROP_HEALTH_WORK,
 };
 
 enum  {
@@ -675,7 +675,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	devlink = priv_to_devlink(dev);
 
 	mutex_lock(&dev->intf_state_mutex);
-	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
+	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
 		mutex_unlock(&dev->intf_state_mutex);
 		return;
@@ -771,14 +771,8 @@ static unsigned long get_next_poll_jiffies(struct mlx5_core_dev *dev)
 void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
-	unsigned long flags;
 
-	spin_lock_irqsave(&health->wq_lock, flags);
-	if (!test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags))
-		queue_work(health->wq, &health->fatal_report_work);
-	else
-		mlx5_core_err(dev, "new health works are not permitted at this stage\n");
-	spin_unlock_irqrestore(&health->wq_lock, flags);
+	queue_work(health->wq, &health->fatal_report_work);
 }
 
 #define MLX5_MSEC_PER_HOUR (MSEC_PER_SEC * 60 * 60)
@@ -858,7 +852,7 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev)
 
 	timer_setup(&health->timer, poll_health, 0);
 	health->fatal_error = MLX5_SENSOR_NO_ERR;
-	clear_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags);
+	clear_bit(MLX5_DROP_HEALTH_WORK, &health->flags);
 	health->health = &dev->iseg->health;
 	health->health_counter = &dev->iseg->health_counter;
 
@@ -869,13 +863,9 @@ void mlx5_start_health_poll(struct mlx5_core_dev *dev)
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
-	unsigned long flags;
 
-	if (disable_health) {
-		spin_lock_irqsave(&health->wq_lock, flags);
-		set_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags);
-		spin_unlock_irqrestore(&health->wq_lock, flags);
-	}
+	if (disable_health)
+		set_bit(MLX5_DROP_HEALTH_WORK, &health->flags);
 
 	del_timer_sync(&health->timer);
 }
@@ -891,11 +881,8 @@ void mlx5_start_health_fw_log_up(struct mlx5_core_dev *dev)
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
-	unsigned long flags;
 
-	spin_lock_irqsave(&health->wq_lock, flags);
-	set_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags);
-	spin_unlock_irqrestore(&health->wq_lock, flags);
+	set_bit(MLX5_DROP_HEALTH_WORK, &health->flags);
 	cancel_delayed_work_sync(&health->update_fw_log_ts_work);
 	cancel_work_sync(&health->report_work);
 	cancel_work_sync(&health->fatal_report_work);
@@ -928,7 +915,6 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	kfree(name);
 	if (!health->wq)
 		goto out_err;
-	spin_lock_init(&health->wq_lock);
 	INIT_WORK(&health->fatal_report_work, mlx5_fw_fatal_reporter_err_work);
 	INIT_WORK(&health->report_work, mlx5_fw_reporter_err_work);
 	INIT_DELAYED_WORK(&health->update_fw_log_ts_work, mlx5_health_log_ts_update);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index cd529e051b4d..91e8160ed087 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -430,8 +430,6 @@ struct mlx5_core_health {
 	u8				synd;
 	u32				fatal_error;
 	u32				crdump_size;
-	/* wq spinlock to synchronize draining */
-	spinlock_t			wq_lock;
 	struct workqueue_struct	       *wq;
 	unsigned long			flags;
 	struct work_struct		fatal_report_work;
-- 
2.39.1

