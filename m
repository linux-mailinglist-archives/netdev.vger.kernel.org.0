Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA855843AD
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiG1Pzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiG1PzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:55:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243E26D567
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ5P6fntGh1FD0heJ7m+Y+YQMhfABt0UwW561SLxkc+lpTHfYhgU7nxObz/KclydWthnVwRX+B4/27woqZ+FXzxGxG9QgZtfm/81ETHGjN2o+QwF+w8J+W95IyxQCgAhJSJkg68GPByCOmcFMy2dE+JBSdiytMz8wD9e0xu/aax9gKkXCQtZPjTS/ekJSqkc8EyqPL80+dviESIhkrhkrJQLOXD+B5XNW8D/cZlihsb4madsGgrHNMyBBoF3D4UG9+GOV/8X5EPWldERXVEJhMCBa/PSgTXbA/r8geApHFPChw2Ke3ibjatp7evhMIIuK23rW/K9UlRjOhiZIA22fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FEdLw1sTXVoRDHrceXmgLjIk69yv3hyzZqPDftRQUY=;
 b=NifJuEKhrcY9uf0uHgqRvPZOgcUkUj+uh2wmZRQwpJbdIK0eckQVNncf6icRkKkNZ1SA2dlb4nth+V+5H4gjA8jQ+tL3krfcK4f4QFLK7s5/Ar+Ajaljm5BeBM0Y0s9yF1mu8/gvJ6BJytuR3X8hBzI0VBA+AfhLxOqIslVuabDujFMYWO3ijMlX5cMaiYmcEE4oDVaw1A98u25dA1gMZGVhFcSBQ5WhHqpxVsx/K9uLou38XjxRq/kkmOJQBWTZWAYhDmbix0Q8De4eY+UNU7u3xpHH4LkidAw8CGFHJE85zcXmZLKqI3IW0TE93G10nKhEnyMkNKF14mAsQ6HbGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FEdLw1sTXVoRDHrceXmgLjIk69yv3hyzZqPDftRQUY=;
 b=ZmewPgO7xIBJgeEwjGEzOjERxccdIqqJs4B2aWbFRF8x4M5iA5P9vsrSt54ZGX4dfTHbJwYkIdvx/WObvMDpxRdbMJjWBHAUsYG4XcQsW7rMbocEC0sVoF0buohAlcdwUeDLWpWXsPWz3VVB9d83tLPN0/JxYqXodbeOBpAiMLKz7Ka7FTfbcCq3aaCrMABVjz88Xg3q9i6ryuMOdwSyQdGKIhE0AYBAUqoyz2VmTCxUU8WIQHR0gGd7zU53Mit1Umy9cE3FDtQ8Js6T0DYG+mcD9kzYEVndAtLdlWXBuycUi0PAlrqTAlXTHpaFxZ2bKFRwfPoLeIn+ERNe5AGkuw==
Received: from DM6PR07CA0070.namprd07.prod.outlook.com (2603:10b6:5:74::47) by
 BN8PR12MB3362.namprd12.prod.outlook.com (2603:10b6:408:44::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.6; Thu, 28 Jul 2022 15:54:48 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::d9) by DM6PR07CA0070.outlook.office365.com
 (2603:10b6:5:74::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:38 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:35 -0700
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
Subject: [PATCH net-next v2 6/9] net/mlx4: Use devl_ API for devlink port register / unregister
Date:   Thu, 28 Jul 2022 18:53:47 +0300
Message-ID: <1659023630-32006-7-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b63de526-45a2-4326-43ff-08da70b17f76
X-MS-TrafficTypeDiagnostic: BN8PR12MB3362:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iOxwKR+fQrk7QNg9Sv0CG8oyLJxLzQbrzo8MGvWW40E5H0XbVLufhpQG7WJwtFxpvoZRflxiamhQocIwduOYryaO2yJoKktvGRIXsdFyd2IA/DOdZXwVstKmsARZlvc37xeqHHVLfnxzdq7NcZWIUCiz5zRKWxF4vKBWkxWUh49x+KGg+mzVSzHYza33xoG4DClIr42tjOzpyMjPhlXN6PULGtNz/lDp06t/fYcv1S7Xw/JifpGqd1+625gI1EPY81kUQ9NB/0+l4EdeWBdWrnnTJBJw2Ctkhl1SfaR6dpA3NMwZ/lAa4mq38IV7DSZuOZgr6GaqZgqzOpOoYAX6sJ8ww8yoWrZWbdbgwHVfKzwscVfzA7XE0GYskenJ96gXHpbykBf6GGkz2Iej1xqK7+g4ZXOUsAXuYURNRYEXlgkni9RH9ZgcghNvYertJnpIosVy2nDAbDstPNQf75eGAvBL4jfmIkV9v48McNDIlMNlGH9F2eFA1QrckCJJ+oMuB2Rw48mdHNvxVo/5zg3b1w9XHnWzZLFc3UFaZsb4vnAl0k530aVpZIAxu5vI/ALa3D+ZmnUV3WscUPF7Ez5dyqm7Vtzh42uadyerL7YjQ2QScQiPvyN8PjE+NUsDpFhOPaWI1YGWz6VDXbSkL+ZOd43g9/B8a8cj7aHiMmMyV+dX5x3997L0ZCKhdGJkhfCpG/dqnrfiLu8JnxfvjsHsYcH4MEQ6iV3k3YGDty3JioF+m0bH40CEKwENI/5j22j3C9S7kwtm2oyZqROzHRtRtSlOAqdJCSI8/2Qhye+QrdnwjTuTMMybadbqL1Us5RzhwNFE3KjjvhNwkhoYUIu5wQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966006)(40470700004)(36840700001)(47076005)(107886003)(426003)(7696005)(186003)(41300700001)(6666004)(2906002)(336012)(26005)(2616005)(86362001)(82310400005)(40460700003)(81166007)(356005)(82740400003)(83380400001)(40480700001)(8936002)(110136005)(4326008)(316002)(54906003)(478600001)(5660300002)(70586007)(8676002)(70206006)(36756003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:47.4607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b63de526-45a2-4326-43ff-08da70b17f76
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3362
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devl_ API to call devl_port_register() and devl_port_unregister()
instead of devlink_port_register() and devlink_port_unregister(). Add
devlink instance lock in mlx4 driver paths to these functions.

This will be used by the downstream patch to invoke mlx4 devlink reload
callbacks with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index f3d13190b959..0166d003f22c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3033,7 +3033,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
 	int err;
 
-	err = devlink_port_register(devlink, &info->devlink_port, port);
+	err = devl_port_register(devlink, &info->devlink_port, port);
 	if (err)
 		return err;
 
@@ -3071,7 +3071,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	err = device_create_file(&dev->persist->pdev->dev, &info->port_attr);
 	if (err) {
 		mlx4_err(dev, "Failed to create file for port %d\n", port);
-		devlink_port_unregister(&info->devlink_port);
+		devl_port_unregister(&info->devlink_port);
 		info->port = -1;
 		return err;
 	}
@@ -3093,7 +3093,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 		mlx4_err(dev, "Failed to create mtu file for port %d\n", port);
 		device_remove_file(&info->dev->persist->pdev->dev,
 				   &info->port_attr);
-		devlink_port_unregister(&info->devlink_port);
+		devl_port_unregister(&info->devlink_port);
 		info->port = -1;
 		return err;
 	}
@@ -3109,7 +3109,7 @@ static void mlx4_cleanup_port_info(struct mlx4_port_info *info)
 	device_remove_file(&info->dev->persist->pdev->dev, &info->port_attr);
 	device_remove_file(&info->dev->persist->pdev->dev,
 			   &info->port_mtu_attr);
-	devlink_port_unregister(&info->devlink_port);
+	devl_port_unregister(&info->devlink_port);
 
 #ifdef CONFIG_RFS_ACCEL
 	free_irq_cpu_rmap(info->rmap);
@@ -3333,6 +3333,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 			 int total_vfs, int *nvfs, struct mlx4_priv *priv,
 			 int reset_flow)
 {
+	struct devlink *devlink = priv_to_devlink(priv);
 	struct mlx4_dev *dev;
 	unsigned sum = 0;
 	int err;
@@ -3629,6 +3630,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
+	devl_lock(devlink);
 	for (port = 1; port <= dev->caps.num_ports; port++) {
 		err = mlx4_init_port_info(dev, port);
 		if (err)
@@ -3642,6 +3644,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 	if (err)
 		goto err_port;
 
+	devl_unlock(devlink);
 	mlx4_request_modules(dev);
 
 	mlx4_sense_init(dev);
@@ -3658,6 +3661,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 err_port:
 	for (--port; port >= 1; --port)
 		mlx4_cleanup_port_info(&priv->port[port]);
+	devl_unlock(devlink);
 
 	mlx4_cleanup_default_counters(dev);
 	if (!mlx4_is_slave(dev))
@@ -4061,8 +4065,10 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	struct mlx4_dev  *dev  = persist->dev;
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int               pci_dev_data;
+	struct devlink *devlink;
 	int p, i;
 
+	devlink = priv_to_devlink(priv);
 	if (priv->removed)
 		return;
 
@@ -4078,10 +4084,12 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	mlx4_stop_sense(dev);
 	mlx4_unregister_device(dev);
 
+	devl_lock(devlink);
 	for (p = 1; p <= dev->caps.num_ports; p++) {
 		mlx4_cleanup_port_info(&priv->port[p]);
 		mlx4_CLOSE_PORT(dev, p);
 	}
+	devl_unlock(devlink);
 
 	if (mlx4_is_master(dev))
 		mlx4_free_resource_tracker(dev,
-- 
2.18.2

