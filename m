Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153165843A3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiG1Pyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiG1Pyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6655E6BD71
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afy4m/DNciZYfOA7XZFGAFSVAqQiHK5hkHYDmksSNfBk+Db/jCKWLiNwAflqmT86YJCAhSdsqrtLIMm899pJXd/DdBb+1t9r4gjrZeYlMl+VDM+USJ+3ihG4wJuy49OAfQSQGS8lhWyur9E/07sOqc969fNHLbiOp1Cor4AYgqdk4ZUGTjmq7DT3uTbClxhjBCZJaoU0/9YA05KowngV8JruACCkH9pOjI57KGbO8yypWA3KeIogSq5Oq6T/OlXD4+hi+newv0K1d6hqjlliBosaGqy4w41Z6rEJR4gG8RwQ2oXsOunf0A7wbS5a9xnAOzx/WiLu7Myi3EG4Ksw9Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8D+dIvNBnYIuuwEElDEylQuGbF0gsqEGpG7oc+cFNE=;
 b=ZIJLIzvcZYV4zyKHZCt4vP1ZpSBwXwMDQTs1vBmJLyVRXkzKI2ookofmi32Jun9I2guteslGI1Gv2/yNc7fPt6JOXkwGT0pKG/U121EpCwdqKJBIYSXOw2w5RkgaEHHctZlrzPndd77lUJDcVIN0VPJIVbn4MM7p8Nn703l/D4rHBkvaHgQPn8EaWV8HItbDdB+wfNxgkthfgSSMvBO4N3itWjVG88NFrcBbtbw75enS4DSa9qlNC6dXdQg2u9dqOwiI48k9de9zQXACUSkaMEdbj5VORAIdHwKlh4oebFKglZiUA5gihcTKNtXcZ2/UeJb5WhtL7+Sb87af8RNprw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8D+dIvNBnYIuuwEElDEylQuGbF0gsqEGpG7oc+cFNE=;
 b=dOKwrsq9+ndM9UYeatacg88cr5mhOnkOYevAfs6ESwuf0ve+vYvkCNh9EJRARGP60d3+NyD/JVAFjRNIHtuOhtaP468ZVmQXnFulZ4MYxzOpDzx4DLv2c78X86ccm712GZFKzwAJWN45dBUPVxmY/dk2lepJh7arT7FZXNqRdjdrQq1KaqFBUJ+NxB4uFHHN2/XB8kQwlUUz6hzWUWrDEgcBArrLUEx7b2NbCz1DJYB+29l2Z3DghKHiZuKLzNDl6tnJJxNl3xEco1e357Z7p1GngXEOzqqXm1BYeAysxxtPqBGCmFYEUxRkkGFhXyZJtYSqoSqQFuR+s4uyCSUfEA==
Received: from DS7PR06CA0024.namprd06.prod.outlook.com (2603:10b6:8:2a::8) by
 DM4PR12MB6085.namprd12.prod.outlook.com (2603:10b6:8:b3::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Thu, 28 Jul 2022 15:54:33 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::30) by DS7PR06CA0024.outlook.office365.com
 (2603:10b6:8:2a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:32 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:32 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:29 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 4/9] net/mlx5: Lock mlx5 devlink reload callbacks
Date:   Thu, 28 Jul 2022 18:53:45 +0300
Message-ID: <1659023630-32006-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05af87b5-14f5-4765-a473-08da70b17719
X-MS-TrafficTypeDiagnostic: DM4PR12MB6085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Vy7aPsXuhOGNH+1mLBqrPynLaeeWvmYhT637dJZHb5vXnBP2TJVJRc4cECmeKbm/vOlBRJFZe6V2f5Z/ig3k+Xm6k/5n71AsojANGTELsyJC/iw+1Ju5R5XoQ5SFwUs6X99zTG2IHy7daAXEH2XT7wYEe7xd/Gyc8HZtEmGtyFtv4MoLu0m5H2Yg5ELIdc0Q3bsNRio3lC7wsUEuNWDKpYDvN2PkhB//DP6IoTSIwtQriuj1q1buvOM08aQK+6PBmn9MGh03LimUKOINEqrJjH2PQBkQBwmuGHShQX5nEU/3NjG2ldu/3YrBImvgSsvF7pOUsJr51QijKRUkztER6neCVlAySnlk8b151NCR5LkjB8A5RSeD7rznTlfqvKdJYD7tdKoLsuE9MHyp8GyRDxW16epHDFbhbO5qQykblC1qxt4KqDdTszCzT3aT7cot1vHHpqsNFBw7DJSqPoukCpENoacZ9GcFoh5zl/R8PoiMwKS3KUX1VeADE33p0efdcdVk4qrqal0+kFOhnENoNdl0d6EPTLcsSIQxRqTjzcu8fKmWvlyuV7jxtwKfAdxm4P0Q+pCZ70FQf0xB/LJsBgEVNP04A9BZn71KA4xtu6+inB+4UCu9G6exG5oDIcbaFhV7VJcwrR2StSpjmpSUx1ixTmuqHjBMW799Q+6ld1biUSrTFkiW8YqZY3uf8UMrxUMaN9NClr1TlUaRPFrFsuC1XWmzvAcIBX2cnrrz6wuZsSIqFnF/jpTFl0k3xNsrqPjAqitc7LBG8aIgBWy0jL9MfWmofaNLZcYVhl06Vt3SCtg09OKu0aCCdXKnIxeNMvqGQmINP/XRbPMme+jl0+gQGGKr/FOa84eQB5Y9SXzoxyrIQqjdR2rE0Ivqe389ZuB+XgJtiMtyjun3/NFmQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(40470700004)(36840700001)(46966006)(336012)(6666004)(426003)(47076005)(4326008)(7696005)(186003)(107886003)(82740400003)(8676002)(81166007)(316002)(26005)(83380400001)(70586007)(478600001)(30864003)(36860700001)(41300700001)(82310400005)(110136005)(40460700003)(2616005)(8936002)(2906002)(40480700001)(356005)(36756003)(5660300002)(86362001)(70206006)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:33.4475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05af87b5-14f5-4765-a473-08da70b17719
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6085
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change devlink instance locks in mlx5 driver to have devlink reload
callbacks locked, while keeping all driver paths which lead to devl_ API
functions called by the driver locked.

Add mlx5_load_one_devl_locked() and mlx5_unload_one_devl_locked() which
are used by the paths which are already locked such as devlink reload
callbacks.

This patch makes the driver use devl_ API also for traps register as
these functions are called from the driver paths parallel to reload that
requires locking now.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 19 ++-----
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 50 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 18 ++-----
 .../net/ethernet/mellanox/mlx5/core/main.c    | 34 ++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  6 +++
 6 files changed, 79 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ccf2068d2e79..0571e40c6ee5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -335,13 +335,12 @@ static void del_adev(struct auxiliary_device *adev)
 
 int mlx5_attach_device(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_priv *priv = &dev->priv;
 	struct auxiliary_device *adev;
 	struct auxiliary_driver *adrv;
 	int ret = 0, i;
 
-	devl_lock(devlink);
+	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&mlx5_intf_mutex);
 	priv->flags &= ~MLX5_PRIV_FLAGS_DETACH;
 	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
@@ -394,20 +393,18 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 	}
 	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	mutex_unlock(&mlx5_intf_mutex);
-	devl_unlock(devlink);
 	return ret;
 }
 
 void mlx5_detach_device(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_priv *priv = &dev->priv;
 	struct auxiliary_device *adev;
 	struct auxiliary_driver *adrv;
 	pm_message_t pm = {};
 	int i;
 
-	devl_lock(devlink);
+	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&mlx5_intf_mutex);
 	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	for (i = ARRAY_SIZE(mlx5_adev_devices) - 1; i >= 0; i--) {
@@ -441,21 +438,17 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	priv->flags |= MLX5_PRIV_FLAGS_DETACH;
 	mutex_unlock(&mlx5_intf_mutex);
-	devl_unlock(devlink);
 }
 
 int mlx5_register_device(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink;
 	int ret;
 
-	devlink = priv_to_devlink(dev);
-	devl_lock(devlink);
+	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	ret = mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
-	devl_unlock(devlink);
 	if (ret)
 		mlx5_unregister_device(dev);
 
@@ -464,15 +457,11 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink;
-
-	devlink = priv_to_devlink(dev);
-	devl_lock(devlink);
+	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
-	devl_unlock(devlink);
 }
 
 static int add_drivers(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 41bb50d94caa..1c05a7091698 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -108,7 +108,7 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	mlx5_unload_one(dev);
+	mlx5_unload_one_devl_locked(dev);
 	err = mlx5_health_wait_pci_up(dev);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
@@ -143,6 +143,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	struct pci_dev *pdev = dev->pdev;
 	bool sf_dev_allocated;
+	int ret = 0;
 
 	sf_dev_allocated = mlx5_sf_dev_allocated(dev);
 	if (sf_dev_allocated) {
@@ -163,19 +164,25 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
 	}
 
+	devl_lock(devlink);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-		mlx5_unload_one(dev);
-		return 0;
+		mlx5_unload_one_devl_locked(dev);
+		break;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
-			return mlx5_devlink_trigger_fw_live_patch(devlink, extack);
-		return mlx5_devlink_reload_fw_activate(devlink, extack);
+			ret = mlx5_devlink_trigger_fw_live_patch(devlink, extack);
+		else
+			ret = mlx5_devlink_reload_fw_activate(devlink, extack);
+		break;
 	default:
 		/* Unsupported action should not get to this function */
 		WARN_ON(1);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
 	}
+
+	devl_unlock(devlink);
+	return ret;
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
@@ -183,24 +190,29 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	int ret = 0;
 
+	devl_lock(devlink);
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-		return mlx5_load_one(dev, false);
+		ret = mlx5_load_one_devl_locked(dev, false);
+		break;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
 			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-		return mlx5_load_one(dev, false);
+		ret = mlx5_load_one_devl_locked(dev, false);
+		break;
 	default:
 		/* Unsupported action should not get to this function */
 		WARN_ON(1);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
 	}
 
-	return 0;
+	devl_unlock(devlink);
+	return ret;
 }
 
 static struct mlx5_devlink_trap *mlx5_find_trap_by_id(struct mlx5_core_dev *dev, int trap_id)
@@ -837,28 +849,28 @@ static int mlx5_devlink_traps_register(struct devlink *devlink)
 	struct mlx5_core_dev *core_dev = devlink_priv(devlink);
 	int err;
 
-	err = devlink_trap_groups_register(devlink, mlx5_trap_groups_arr,
-					   ARRAY_SIZE(mlx5_trap_groups_arr));
+	err = devl_trap_groups_register(devlink, mlx5_trap_groups_arr,
+					ARRAY_SIZE(mlx5_trap_groups_arr));
 	if (err)
 		return err;
 
-	err = devlink_traps_register(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr),
-				     &core_dev->priv);
+	err = devl_traps_register(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr),
+				  &core_dev->priv);
 	if (err)
 		goto err_trap_group;
 	return 0;
 
 err_trap_group:
-	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
-				       ARRAY_SIZE(mlx5_trap_groups_arr));
+	devl_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
+				    ARRAY_SIZE(mlx5_trap_groups_arr));
 	return err;
 }
 
 static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 {
-	devlink_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr));
-	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
-				       ARRAY_SIZE(mlx5_trap_groups_arr));
+	devl_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr));
+	devl_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
+				    ARRAY_SIZE(mlx5_trap_groups_arr));
 }
 
 int mlx5_devlink_register(struct devlink *devlink)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 30a6c9fbf1b6..6aa58044b949 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1300,20 +1300,19 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
  */
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 {
-	struct devlink *devlink;
 	bool toggle_lag;
 	int ret;
 
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
+	devl_assert_locked(priv_to_devlink(esw->dev));
+
 	toggle_lag = !mlx5_esw_is_fdb_created(esw);
 
 	if (toggle_lag)
 		mlx5_lag_disable_change(esw->dev);
 
-	devlink = priv_to_devlink(esw->dev);
-	devl_lock(devlink);
 	down_write(&esw->mode_lock);
 	if (!mlx5_esw_is_fdb_created(esw)) {
 		ret = mlx5_eswitch_enable_locked(esw, num_vfs);
@@ -1327,7 +1326,6 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
 	up_write(&esw->mode_lock);
-	devl_unlock(devlink);
 
 	if (toggle_lag)
 		mlx5_lag_enable_change(esw->dev);
@@ -1338,13 +1336,10 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 /* When disabling sriov, free driver level resources. */
 void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 {
-	struct devlink *devlink;
-
 	if (!mlx5_esw_allowed(esw))
 		return;
 
-	devlink = priv_to_devlink(esw->dev);
-	devl_lock(devlink);
+	devl_assert_locked(priv_to_devlink(esw->dev));
 	down_write(&esw->mode_lock);
 	/* If driver is unloaded, this function is called twice by remove_one()
 	 * and mlx5_unload(). Prevent the second call.
@@ -1373,7 +1368,6 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 
 unlock:
 	up_write(&esw->mode_lock);
-	devl_unlock(devlink);
 }
 
 /* Free resources for corresponding eswitch mode. It is called by devlink
@@ -1407,18 +1401,14 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
 
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 {
-	struct devlink *devlink;
-
 	if (!mlx5_esw_allowed(esw))
 		return;
 
+	devl_assert_locked(priv_to_devlink(esw->dev));
 	mlx5_lag_disable_change(esw->dev);
-	devlink = priv_to_devlink(esw->dev);
-	devl_lock(devlink);
 	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw);
 	up_write(&esw->mode_lock);
-	devl_unlock(devlink);
 	mlx5_lag_enable_change(esw->dev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b621c1ddd14..01fcb23eb69a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1304,8 +1304,10 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 
 int mlx5_init_one(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink = priv_to_devlink(dev);
 	int err = 0;
 
+	devl_lock(devlink);
 	mutex_lock(&dev->intf_state_mutex);
 	dev->state = MLX5_DEVICE_STATE_UP;
 
@@ -1334,6 +1336,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 		goto err_register;
 
 	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(devlink);
 	return 0;
 
 err_register:
@@ -1348,11 +1351,15 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(devlink);
 	return err;
 }
 
 void mlx5_uninit_one(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	devl_lock(devlink);
 	mutex_lock(&dev->intf_state_mutex);
 
 	mlx5_unregister_device(dev);
@@ -1371,13 +1378,15 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	mlx5_function_teardown(dev, true);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(devlink);
 }
 
-int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
+int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
 {
 	int err = 0;
 	u64 timeout;
 
+	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "interface is up, NOP\n");
@@ -1419,8 +1428,20 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
 	return err;
 }
 
-void mlx5_unload_one(struct mlx5_core_dev *dev)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
 {
+	struct devlink *devlink = priv_to_devlink(dev);
+	int ret;
+
+	devl_lock(devlink);
+	ret = mlx5_load_one_devl_locked(dev, recovery);
+	devl_unlock(devlink);
+	return ret;
+}
+
+void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev)
+{
+	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&dev->intf_state_mutex);
 
 	mlx5_detach_device(dev);
@@ -1438,6 +1459,15 @@ void mlx5_unload_one(struct mlx5_core_dev *dev)
 	mutex_unlock(&dev->intf_state_mutex);
 }
 
+void mlx5_unload_one(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	devl_lock(devlink);
+	mlx5_unload_one_devl_locked(dev);
+	devl_unlock(devlink);
+}
+
 static const int types[] = {
 	MLX5_CAP_GENERAL,
 	MLX5_CAP_GENERAL_2,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 9cc7afea2758..ad61b86d5769 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -290,7 +290,9 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev);
+void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
+int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 5757cd6e1819..ee2e1b7c1310 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -154,13 +154,16 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
+	struct devlink *devlink = priv_to_devlink(dev);
 	int err;
 
+	devl_lock(devlink);
 	err = mlx5_device_enable_sriov(dev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "mlx5_device_enable_sriov failed : %d\n", err);
 		return err;
 	}
+	devl_unlock(devlink);
 
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
@@ -173,10 +176,13 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 void mlx5_sriov_disable(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
+	struct devlink *devlink = priv_to_devlink(dev);
 	int num_vfs = pci_num_vf(dev->pdev);
 
 	pci_disable_sriov(pdev);
+	devl_lock(devlink);
 	mlx5_device_disable_sriov(dev, num_vfs, true);
+	devl_unlock(devlink);
 }
 
 int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
-- 
2.18.2

