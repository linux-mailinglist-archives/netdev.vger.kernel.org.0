Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0B8697082
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjBNWOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbjBNWOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5220830B3B
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE110B81F5D
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0123C4339C;
        Tue, 14 Feb 2023 22:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412860;
        bh=Ui8YFzOHhYNxFP6SJLqgWETUltUgWQLi6d9Du7q1NwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojkmIBT/ffMtsswQKAGw9Bu4GfElGI92o3NzOs77z8dUhSkynd68XMg1n/x1tcB1Z
         uDlSIUOsRKr8OrF5PzzugCi9TXaeROi/5cSIs5EAdekss329o6iVI3uSgj4M1D31KP
         MyP9XtXTNlM2SldxObjO54xE4Ph+jKeOAlG2DIIciDIwJZ0Y5Q98L9u2ehAcio5gpX
         xz9/ooqTR5zVQC8i+ISnv4PjD8NV2DMnmZqGFjpUSQ1pSUifedOv6cGR0h7nTDuQwM
         G2WrsWAdIso/ywsq1pa5NHzxnpZBVn8roHxz5ZO845TB1fkxEA214VzfalON5tAElA
         DnYuilpGlZAUg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next V2 14/15] net/mlx5: Remove "recovery" arg from mlx5_load_one() function
Date:   Tue, 14 Feb 2023 14:12:38 -0800
Message-Id: <20230214221239.159033-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
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

From: Jiri Pirko <jiri@nvidia.com>

mlx5_load_one() is always called with recovery==false, so remove the
unneeded function arg.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 9 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 2 +-
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 63290da84010..7bde34a17165 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -167,7 +167,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
-			mlx5_load_one(dev, false);
+			mlx5_load_one(dev);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 26e1057845fe..6997b29fdecc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1509,13 +1509,13 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
 	return err;
 }
 
-int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
+int mlx5_load_one(struct mlx5_core_dev *dev)
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	int ret;
 
 	devl_lock(devlink);
-	ret = mlx5_load_one_devl_locked(dev, recovery);
+	ret = mlx5_load_one_devl_locked(dev, false);
 	devl_unlock(devlink);
 	return ret;
 }
@@ -1912,8 +1912,7 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
-	err = mlx5_load_one(dev, false);
-
+	err = mlx5_load_one(dev);
 	if (!err)
 		devlink_health_reporter_state_update(dev->priv.health.fw_fatal_reporter,
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
@@ -2004,7 +2003,7 @@ static int mlx5_resume(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	return mlx5_load_one(dev, false);
+	return mlx5_load_one(dev);
 }
 
 static const struct pci_device_id mlx5_core_pci_table[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 029305a8b80a..d670b28a7323 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -321,7 +321,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev);
-int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
+int mlx5_load_one(struct mlx5_core_dev *dev);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
 int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id,
-- 
2.39.1

