Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF958315E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiG0SAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242766AbiG0R7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:36 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB8159260
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFrp5Q6iKFA4eJjEKfEe9DghS99n9Nez4yhRjtEUhEuJq4KwPEL97+VC9MSNsZcu82tdEUAOqrJwtTO0i1yz3+JRK6zHQNTZn28u6PorznsG+sQNfijnGao1DTrNIVs12NvYrc2QfQHqQUgiaEeZ0UTGpzJKRtiLYDIgnQZo0i0d8VW6cTV2Hfw5Q+DKhJxZDBYr+BtaxYVxMOs5bmBZuqlhWejNB8IhOq/JO7wRRb863Y8FhJXT6VhuzE6vSz+B5ZN0eQxp0z4dXBzDpfkVTf5iY3LwltY00kTxMqVkzOapeu6d22KdbuGRvctXbr3Rk9hL3RqnrlM+k3YjR/TfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0cZGKYG9E8NpSw2GnfDJ+ak5jSuh9+0zYJ6WQGZBwU=;
 b=dsqnV44Nweov5uWLnfHD917JtFHxiNJEo5t9h5x7iDGYXuuLINnQEbG6Jb16aFg+Z9ZZcwBgdON40RRRf1q2rF2B1C2XkrJhbOlV+wh3RP4C9QQ+YHFQlBd+rZkpfQkMoZi+BWuIkHaAfasR4J0s+6Q0nN+f5HTs0EmnjQkFZ1/qLOUVa4nI1kcV7JtMXNTKIP0CwtHsYCSqsTYG+WC+fgQN51HmsX699AdvjiWlKrFQvAuwPZEBadLYeJwdOcHEEK5RJKbjdYc6fOsT6l+p5HPlOh3zGoL92LrV5kOkCCDhOBVsNKFVmQMACA8/Yu8z315GZAcZON3TlAOcPqSrFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0cZGKYG9E8NpSw2GnfDJ+ak5jSuh9+0zYJ6WQGZBwU=;
 b=UbBGyakXDip0cgmUGm+CqiIi88v+4gx5f6rOY2dhy980vEEykg9BXahA9vUO1ox1Bo76+G25qSwHDTNCNxsT7jnfT0EJBKfxoqdSfXxjC4k8ocRd7e97WJbo7LUoCpNiZR8BG520FcyFxGysAkRKE3FIoPZ1QqVTpbiVJyRMsKlD1xTlRyWWtcHPttr695mQPd+/pPYXoO6wYy8+hYnUPV9s8XN+y1zDjYaP23FZU66QQS/v0k664rSbLBZ0hSEYrS9zInbkpW3Hm6N+njp/u/O+AWAqy/DIyHAKzF+em5/CJcxt61n1K0WRprONydMw6s7n0hj9JImVg9Wm6B6PDQ==
Received: from MW4PR04CA0264.namprd04.prod.outlook.com (2603:10b6:303:88::29)
 by CH0PR12MB5236.namprd12.prod.outlook.com (2603:10b6:610:d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:04:26 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::c9) by MW4PR04CA0264.outlook.office365.com
 (2603:10b6:303:88::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:25 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:24 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:22 -0700
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
Subject: [PATCH net-next 7/9] net/mlx4: Lock mlx4 devlink reload callback
Date:   Wed, 27 Jul 2022 20:03:34 +0300
Message-ID: <1658941416-74393-8-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 210f000e-89b5-48fe-55d5-08da6ff20f5a
X-MS-TrafficTypeDiagnostic: CH0PR12MB5236:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrvSyu//7E8YxVaFTyQ6wRTcnAGq2Gydjdo/dHMtPaDjMC6ioELNNS8l30kuEfp5aeLLX5C/7xKgAV2/U5t52rsGjI6YeuZf4gLNlHZLK8wU7Ua9w92OlMVXq77WOLiUmY2grtTiUk/gGeaLQZqTQ2dPXRHmLB+CIc42xbgrZsJc3/XqZ6P3FMUZVRbz+nuqJo8c4yB98WrKJZ+7Wnli+FbOTwsxcuanyLBxrCmni5Iv2RRRJ3onQuJ3FNVd4BYXI+5wLu//GQcNb9JWK8LMbOGm2zcsEJ7wikPX8P+bTfUKYti3958Ucq+Ak6eZqawEC1GpYlDgzqsfFXl65o16drQ+InmzhhjcmTluSvevJvi+k2O7xYZU1wmeyh6a90b1Jf1SON35YGDgXq52/0WfHOTifPOlt7mnAFil7Xb1xqRsD/Z4SngcQBGhNtU9npsSuEMzMdufTf7hmfxXcT3vKmO3MBVXGvrMB5GkFt0OM8qPG8p5nOWJbaNN1nwfaGUrXvcO3N1ZtRgen9LQ65btjCs5tdBf0icQ4bSrUxuas0soerK5A2D6py3d0yqXGtHgsHkM4XQgIlifh/i6MPSEYjUU6fV8BD8HCnOXnxOf0A9s5vOPTqzjgp/OUJpeWLBkyu4ckZwswaff8cirKeTsK8g/rfSE0dNtXFnV5w9XU6rv+MVJacHJQomNa5NAELBRnMgmd1KCs4Fy5xfHm/Nlvd0iy0TlCPwbFegOuDr9s89Usz1OnE4iKe19tuIqa8tzSm9U/IMQAx4GW8I+Qb2nBcqvfWgG48hmUj3IJaSOlA4r7tqR0OZ1M9Qjg1RWoMxUQNOpE55MfVskGBmoillwDw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(36840700001)(46966006)(40470700004)(336012)(36756003)(8936002)(70206006)(5660300002)(41300700001)(8676002)(70586007)(40480700001)(4326008)(110136005)(82740400003)(186003)(86362001)(54906003)(356005)(107886003)(2616005)(81166007)(36860700001)(478600001)(47076005)(426003)(7696005)(83380400001)(6666004)(316002)(40460700003)(26005)(2906002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:25.5287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 210f000e-89b5-48fe-55d5-08da6ff20f5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5236
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change devlink instance locks in mlx4 driver to have devlink reload
callback locked, while keeping all driver paths which leads to devl_ API
functions called by the mlx4 driver locked.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/catas.c |  5 +++
 drivers/net/ethernet/mellanox/mlx4/main.c  | 45 +++++++++++++++-------
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
index 5b11557f1ae4..0eb7b83637d8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/catas.c
+++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
@@ -204,9 +204,13 @@ void mlx4_enter_error_state(struct mlx4_dev_persistent *persist)
 
 static void mlx4_handle_error_state(struct mlx4_dev_persistent *persist)
 {
+	struct mlx4_dev *dev = persist->dev;
+	struct devlink *devlink;
 	int err = 0;
 
 	mlx4_enter_error_state(persist);
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP &&
 	    !(persist->interface_state & MLX4_INTERFACE_STATE_DELETION)) {
@@ -215,6 +219,7 @@ static void mlx4_handle_error_state(struct mlx4_dev_persistent *persist)
 			  err);
 	}
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 }
 
 static void dump_err_buf(struct mlx4_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 0166d003f22c..2c764d1d897d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3342,6 +3342,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	struct mlx4_dev_cap *dev_cap = NULL;
 	int existing_vfs = 0;
 
+	devl_assert_locked(devlink);
 	dev = &priv->dev;
 
 	INIT_LIST_HEAD(&priv->ctx_list);
@@ -3630,7 +3631,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
-	devl_lock(devlink);
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		err = mlx4_init_port_info(dev, port);
 		if (err)
@@ -3644,7 +3644,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	if (err)
 		goto err_port;
 
-	devl_unlock(devlink);
 	mlx4_request_modules(dev);
 
 	mlx4_sense_init(dev);
@@ -3661,7 +3660,6 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 err_port:
 	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);
-	devl_unlock(devlink);
 
 	mlx4_cleanup_default_counters(dev);
 	if (!mlx4_is_slave(dev))
@@ -3736,7 +3734,6 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	int prb_vf[MLX4_MAX_PORTS + 1] = {0, 0, 0};
 	const int param_map[MLX4_MAX_PORTS + 1][MLX4_MAX_PORTS + 1] = {
 		{2, 0, 0}, {0, 1, 2}, {0, 1, 2} };
-	struct devlink *devlink = priv_to_devlink(priv);
 	unsigned total_vfs = 0;
 	unsigned int i;
 
@@ -3849,9 +3846,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
-	devl_lock(devlink);
 	err = mlx4_crdump_init(&priv->dev);
-	devl_unlock(devlink);
 	if (err)
 		goto err_release_regions;
 
@@ -3869,9 +3864,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	mlx4_catas_end(&priv->dev);
 
 err_crdump:
-	devl_lock(devlink);
 	mlx4_crdump_end(&priv->dev);
-	devl_unlock(devlink);
 
 err_release_regions:
 	pci_release_regions(pdev);
@@ -3965,9 +3958,11 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
 		return -EOPNOTSUPP;
 	}
+	devl_lock(devlink);
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
 	mlx4_restart_one_down(persist->pdev);
+	devl_unlock(devlink);
 	return 0;
 }
 
@@ -3980,8 +3975,10 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	struct mlx4_dev_persistent *persist = dev->persist;
 	int err;
 
+	devl_lock(devlink);
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	err = mlx4_restart_one_up(persist->pdev, true, devlink);
+	devl_unlock(devlink);
 	if (err)
 		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
 			 err);
@@ -4008,6 +4005,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	devlink = devlink_alloc(&mlx4_devlink_ops, sizeof(*priv), &pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
+	devl_lock(devlink);
 	priv = devlink_priv(devlink);
 
 	dev       = &priv->dev;
@@ -4035,6 +4033,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
+	devl_unlock(devlink);
 	devlink_register(devlink);
 	return 0;
 
@@ -4044,6 +4043,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 err_devlink_unregister:
 	kfree(dev->persist);
 err_devlink_free:
+	devl_unlock(devlink);
 	devlink_free(devlink);
 	return ret;
 }
@@ -4069,6 +4069,7 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	int p, i;
 
 	devlink = priv_to_devlink(priv);
+	devl_assert_locked(devlink);
 	if (priv->removed)
 		return;
 
@@ -4084,12 +4085,10 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	mlx4_stop_sense(dev);
 	mlx4_unregister_device(dev);
 
-	devl_lock(devlink);
 	for (p = 1; p <= dev->caps.num_ports; p++) {
 		mlx4_cleanup_port_info(&priv->port[p]);
 		mlx4_CLOSE_PORT(dev, p);
 	}
-	devl_unlock(devlink);
 
 	if (mlx4_is_master(dev))
 		mlx4_free_resource_tracker(dev,
@@ -4150,6 +4149,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 
 	devlink_unregister(devlink);
 
+	devl_lock(devlink);
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
 
@@ -4174,9 +4174,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	else
 		mlx4_info(dev, "%s: interface is down\n", __func__);
 	mlx4_catas_end(dev);
-	devl_lock(devlink);
 	mlx4_crdump_end(dev);
-	devl_unlock(devlink);
 	if (dev->flags & MLX4_FLAG_SRIOV && !active_vfs) {
 		mlx4_warn(dev, "Disabling SR-IOV\n");
 		pci_disable_sriov(pdev);
@@ -4187,6 +4185,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
 	kfree(dev->persist);
+	devl_unlock(devlink);
 	devlink_free(devlink);
 }
 
@@ -4307,15 +4306,20 @@ static pci_ers_result_t mlx4_pci_err_detected(struct pci_dev *pdev,
 					      pci_channel_state_t state)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
+	struct mlx4_dev *dev = persist->dev;
+	struct devlink *devlink;
 
 	mlx4_err(persist->dev, "mlx4_pci_err_detected was called\n");
 	mlx4_enter_error_state(persist);
 
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
@@ -4348,6 +4352,7 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 	struct mlx4_dev	 *dev  = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
+	struct devlink *devlink;
 	int total_vfs;
 	int err;
 
@@ -4355,6 +4360,8 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 	total_vfs = dev->persist->num_vfs;
 	memcpy(nvfs, dev->persist->nvfs, sizeof(dev->persist->nvfs));
 
+	devlink = priv_to_devlink(priv);
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (!(persist->interface_state & MLX4_INTERFACE_STATE_UP)) {
 		err = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs, nvfs,
@@ -4373,19 +4380,23 @@ static void mlx4_pci_resume(struct pci_dev *pdev)
 	}
 end:
 	mutex_unlock(&persist->interface_state_mutex);
-
+	devl_unlock(devlink);
 }
 
 static void mlx4_shutdown(struct pci_dev *pdev)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev *dev = persist->dev;
+	struct devlink *devlink;
 
 	mlx4_info(persist->dev, "mlx4_shutdown was called\n");
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 	mlx4_pci_disable_device(dev);
 }
 
@@ -4400,12 +4411,16 @@ static int __maybe_unused mlx4_suspend(struct device *dev_d)
 	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev	*dev = persist->dev;
+	struct devlink *devlink;
 
 	mlx4_err(dev, "suspend was called\n");
+	devlink = priv_to_devlink(mlx4_priv(dev));
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (persist->interface_state & MLX4_INTERFACE_STATE_UP)
 		mlx4_unload_one(pdev);
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 
 	return 0;
 }
@@ -4417,6 +4432,7 @@ static int __maybe_unused mlx4_resume(struct device *dev_d)
 	struct mlx4_dev	*dev = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int nvfs[MLX4_MAX_PORTS + 1] = {0, 0, 0};
+	struct devlink *devlink;
 	int total_vfs;
 	int ret = 0;
 
@@ -4424,6 +4440,8 @@ static int __maybe_unused mlx4_resume(struct device *dev_d)
 	total_vfs = dev->persist->num_vfs;
 	memcpy(nvfs, dev->persist->nvfs, sizeof(dev->persist->nvfs));
 
+	devlink = priv_to_devlink(priv);
+	devl_lock(devlink);
 	mutex_lock(&persist->interface_state_mutex);
 	if (!(persist->interface_state & MLX4_INTERFACE_STATE_UP)) {
 		ret = mlx4_load_one(pdev, priv->pci_dev_data, total_vfs,
@@ -4437,6 +4455,7 @@ static int __maybe_unused mlx4_resume(struct device *dev_d)
 		}
 	}
 	mutex_unlock(&persist->interface_state_mutex);
+	devl_unlock(devlink);
 
 	return ret;
 }
-- 
2.18.2

