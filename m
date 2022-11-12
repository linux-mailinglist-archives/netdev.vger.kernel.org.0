Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E136268CB
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiKLKWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiKLKV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:21:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E192E13DE3
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F82EB8074C
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366AAC433D6;
        Sat, 12 Nov 2022 10:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248515;
        bh=BEoaW33viQC+3S7pc2+2H9xcQjIUEpfkw66L1Pd0zIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LixqWRKgq8LBBZwKgBa8DHst8bTLr2rxTnqKn9/B53GNAsg04Ut+uKxFLaMM3Ox7/
         e+J0yjoeWmf3HMxtUnILwVQgc9v/zFAS3oDBUeUq/xIcoNF17LR1U7aMbr2WLpC5uO
         O2enyGtQ+1KPfq1Cjdk95VWFbfpHbheRSMsxyhIGR7NPZggRMCvwAeBPudshf4R1ZF
         O1JYvg7sJK7yS357RXFFUWjNBuSg+1sElGHJa74B+T31CrI2ohuCHYmOuI5t+RBSVw
         duUrj1tSZt4ajNQaU8ZnA6fdU2JSwF+yl3DBFlEc8bI7AJCExf29NZmOm+bzV21jaL
         h2oUZ3c67aVFw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Unregister traps on driver unload flow
Date:   Sat, 12 Nov 2022 02:21:35 -0800
Message-Id: <20221112102147.496378-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

Before this patch, devlink traps are registered only on full driver
probe and unregistered on driver removal. As devlink traps are not
usable once driver functionality is unloaded, it should be unrgeistered
also on flows that unload the driver and then registered when loaded
back, e.g. devlink reload flow.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 11 ++---------
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |  8 ++++++++
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 66c6a7017695..cc2ae427dcb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -840,7 +840,7 @@ static const struct devlink_trap_group mlx5_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
 };
 
-static int mlx5_devlink_traps_register(struct devlink *devlink)
+int mlx5_devlink_traps_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *core_dev = devlink_priv(devlink);
 	int err;
@@ -862,7 +862,7 @@ static int mlx5_devlink_traps_register(struct devlink *devlink)
 	return err;
 }
 
-static void mlx5_devlink_traps_unregister(struct devlink *devlink)
+void mlx5_devlink_traps_unregister(struct devlink *devlink)
 {
 	devl_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr));
 	devl_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
@@ -889,17 +889,11 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto max_uc_list_err;
 
-	err = mlx5_devlink_traps_register(devlink);
-	if (err)
-		goto traps_reg_err;
-
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 
 	return 0;
 
-traps_reg_err:
-	mlx5_devlink_max_uc_list_param_unregister(devlink);
 max_uc_list_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
 auxdev_reg_err:
@@ -910,7 +904,6 @@ int mlx5_devlink_register(struct devlink *devlink)
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
-	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 30bf4882779b..fd033df24856 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -30,6 +30,8 @@ void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_
 int mlx5_devlink_trap_get_num_active(struct mlx5_core_dev *dev);
 int mlx5_devlink_traps_get_action(struct mlx5_core_dev *dev, int trap_id,
 				  enum devlink_trap_action *action);
+int mlx5_devlink_traps_register(struct devlink *devlink);
+void mlx5_devlink_traps_unregister(struct devlink *devlink);
 
 struct devlink *mlx5_devlink_alloc(struct device *dev);
 void mlx5_devlink_free(struct devlink *devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 283c4cc28944..9e6da51b7481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1306,8 +1306,15 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 	mlx5_sf_dev_table_create(dev);
 
+	err = mlx5_devlink_traps_register(priv_to_devlink(dev));
+	if (err)
+		goto err_traps_reg;
+
 	return 0;
 
+err_traps_reg:
+	mlx5_sf_dev_table_destroy(dev);
+	mlx5_sriov_detach(dev);
 err_sriov:
 	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
@@ -1336,6 +1343,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
+	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
 	mlx5_eswitch_disable(dev->priv.eswitch);
-- 
2.38.1

