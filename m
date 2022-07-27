Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618DF58315C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243215AbiG0SAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242758AbiG0R7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0577D59264
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZ+K0hSonVJoKF9P1pfWP8yrTxRbjMzi7GxCdHaj4lruyZpS4WcRcgFjmPMTMeEboAWcTgkNfX6lMoJsIVSchkKRL/tihVbrH9y5f6Hzfpk7YXqHvBwaQcAN/LAIwkIRI4aTbvrh7USK9p45LbtcOR8ZdvxYQD7JeOIicsNwR5n0hexJfQb4v9+bKczOz0/kh3nt5k3DymTuGn/DXCTiwBvtb+MGm1STXKnn+QyANWEB6heNsJWhYsY9QlZq5/rF1AzIURRGibV/wQYreN1+atzeCmW6TRZL40MUDOgDBkbtcM3La0rw7QTYxbK9cCb1oSKYeZxezYP2J4YqM+mq3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8D+dIvNBnYIuuwEElDEylQuGbF0gsqEGpG7oc+cFNE=;
 b=buSVavJXha8wXc3GePHWBKAoZ/dCb4fn1dRocgHkUpBMKVPD3x6oWfoEC9u5a22COtFPgbmXM0el9ddCUMXeN8sJy4euoJm+hpheDQHOHpXZinSA8mL7lCQCzJsVOy0S3Iv+IT/wEm1Flh+wXRQe0TNUFBMWi0dOa0SM7n1CVVHMnjM53cFkqYU+cvGxrxH1vEGTD/borD6/ep7yUBJSTevAFHIptgGKzTtzX2rhj6o3vLuWRX6qgSex9fzY8cm5tuclZ8OEnBYxsNkRkwytOwbPx6KKoFQ748Kg3iyCl9uXn7y/BhF6AdU9+45rMgI+zbPwvpGJKPuB2vrkC6Tk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8D+dIvNBnYIuuwEElDEylQuGbF0gsqEGpG7oc+cFNE=;
 b=r3yTjImqjOnDVq9nT7AFmkXNJQBBBGKvwpGsBAHT+qj9jUxSF6T6o5DjM6PvZVOLonANJGe+GRxGkRoX5mXyeRVQLItSt7dsiIwv8kRODi+SF9riATf4PkKzaQ3lPQCmx/lpHQbek/KARyxoFmX9fMN+UROJUQS+romJVlqbFoZIRBYVFz/rmWn9cY7sA+w+OkezNPOt7sLXHbNSUcIu+xte6iNU53eKm5w6rTOcWenCQBffLudvxSTYS2mdJpoz7Ktv6aCMBZW4YZp5jyEmbp38pYxJkJzAoWNCz730DmafNQeBQsAr6amf+SqZ3luYdNiI38AmSxoz0t8uJNslzQ==
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by BYAPR12MB3269.namprd12.prod.outlook.com (2603:10b6:a03:12f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Wed, 27 Jul
 2022 17:04:17 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::57) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:16 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:15 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:13 -0700
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
Subject: [PATCH net-next 4/9] net/mlx5: Lock mlx5 devlink reload callbacks
Date:   Wed, 27 Jul 2022 20:03:31 +0300
Message-ID: <1658941416-74393-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a12ba81a-c5d2-404c-3d8e-08da6ff20a1e
X-MS-TrafficTypeDiagnostic: BYAPR12MB3269:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eJkZCwFa8Eba2GRtaejuQXKqFb5hW1lwUyWoAgBku0pHc/XxW091l8MKqHDgN72QN1tvRrzvSIvpwhSycj6i3eyJ3Ny/XpIHl6CIV5c1b78ioOw4v66zFfL2S18ABlaW/sby4kCJZxqltrKRrLh69njWF0zGMBX9CowTGkd0OugOhGW9aOkhpOoKK3E2ciABjsUmbAXHyCMHjYazSthziheD7De3C4B0ylBAbvUP6DxXNQ042uxMZS/bfS+cIsr1EidhOONC6U3OqRaBveKjY6dfoKpWaXBlZ97094HdPBi2icz/YrLTwKlAd7JHO3QV0iG6jy3r/jkEgrcxDoVbbhnPs4Gebd8Ut3u/3serTe5agTFRGgCVJVAXofL1sFQzpIXXQ7PHhQIjb0IWHGZukzFP5nMUvAjiZnOTtKh7KKO40AI7E4fFRoUm+xjobiYUSwxYc0myt1rUA3drsOiCaFwTSX3MH7I4CENxoaHUAlXa3NGZ6g5HtuOD5uBkdFl3emiTxp4Dhcm5MmUjrNLAnQ83vdJzjKuzXnEf+P8he2xqXeS1YA+bnhPEwtX9hhhtxOJthh/1IPSlFcrBHkYgMU8ODp5HTu8ojQZ3mrsfudXB1kh2KGlra8GgLAsebgPcYRqbzy50UdNjJ+nXRBW236aFjgPhKMcbH/MwMT86LaAiuTY9W/GUvSaYECgWPrk7KDq6/24awjcaESD0vlya90Tii2i+JrgRrCZCM6QKaBxXnMw1AhkJu53p4ZasOaZF0LebqAHHPG6o0wC9czRaEb5pznEfJiT+dHQaQfFldVw6iGm8GmRjilnsivLn03NAIGTOQrK3RHIpwgvI59MURw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(40470700004)(36840700001)(46966006)(8936002)(82740400003)(36860700001)(30864003)(5660300002)(83380400001)(41300700001)(426003)(2906002)(40460700003)(40480700001)(7696005)(2616005)(54906003)(6666004)(36756003)(316002)(81166007)(356005)(86362001)(47076005)(4326008)(70586007)(478600001)(82310400005)(8676002)(186003)(26005)(110136005)(70206006)(107886003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:16.7463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a12ba81a-c5d2-404c-3d8e-08da6ff20a1e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3269
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

