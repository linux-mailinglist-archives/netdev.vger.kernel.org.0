Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F741F7097
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgFKWsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:48:04 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgFKWsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:48:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKvowxTc+6JH6UlT8JNbJKmiZ3j9msoVQAXGgYPqSvy4lxHU+KFBhHB5SEL1Weh3i9iyUc9lKZj2tHy/Z0WRjLQQ5CA9y93wrrb80ha/tzNeaoaTj5s69kwMcAZtHRtmQSJPyRDIE9ENo2+IOJPMqq2TKCr3k02EqfmK1goZyyh/xxkhuNMXAFxvA7osE4/ldYR3RFU+Giz1yDuPEgbijit6shOwtccM3R0nBYH8Ehh1MJt3yz7A+2I6LZmqJKGBjNH48Y29M07wRHPQbsD+T4oUSDIcJuBmW4BEvvKF8LZSLpmnkditvUHeHJe0a0k6kplf7Sc3Ajhi0XCTgwu8wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua2ZO314UjVeBkodNRqOVsRRf9M8j9+i30JRBAOOIjw=;
 b=da1xZW45zsx79eqOKbyn8otADqSezx07RufUlk+M20lmqx6j1N2yrcAIYaCFKN77OsmfgQtUWg8Ds6nRR9hpaasNwzAUDV45oBx/Ds9qCR4N2psSVb+9oBChT+BFWBdyZ9PGZdGGobh+eB0z6w/QFC/LK/dvA81q0GVj+XJulfXgQKJ36zdL3sK5kWT9M/NwGzG8sh7zfJjLlzGYgF1+JCK0/EaIVOso4Im0qrBzD0dQhViU8T2ToyZRbzCQdVzVbg+0frDiV0eGt3UI9v8TTx3ijc2y1WX1eqO4KQLpGbRU806Nx7goHs+vKbRId+qK7KDMHfsSljkUy6TGbZoMnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ua2ZO314UjVeBkodNRqOVsRRf9M8j9+i30JRBAOOIjw=;
 b=B+KNQuHUGa1tuFVByenOZXnWGV9sDE9qw5kV9VN2YEmRUYPLA1d9Ia7HSNTFSklHGTBOHZ57ChKNKhhLVXwBcxffKAUYWlqREQx8pJ5WJNcWfkV7QSuYghwfJDZQWyww56ivVnPe9t58AVfw+ccNNbBilG3+XOOwFnKD4Ng4AGU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/10] net/mlx5: Fix devlink objects and devlink device unregister sequence
Date:   Thu, 11 Jun 2020 15:47:05 -0700
Message-Id: <20200611224708.235014-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4cf28608-0426-4305-a967-08d80e5979b4
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4464F866F290382CE0658839BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xT45G7iRSDB+2mpNT6U7oW0L2EV/rSY9Hcls8pWdfQgQrqrBOfwOiiOnkhU8psaiYobnt3rIr6SNDWTzIDAzoJ+ySKxO9am15qAF3Yb7Zt8A/nh/GqlkFilDpO+YqMMACkereI6i/An5p9ZtVpUCB9QuIJV8dLyRM0F0+mGQSoT19CiHP+95KkBgTwiIf43vMp+3lLm88cIbkMtf7K0Y76SWjlTGAlwBqv5jIxGJlP9zM7WGJw9RPQhZAm0VtVJUKMuuE8A4HcxrKGsMUGcZ+WWKBXyR9Sm98VsD1ThGN98qohdMDz4B0p8gIRRaP6CJLjvp440gbDfKKp2m5daVt2baB9gj3oLtO3nH7Q4RPYcRlITfiNKBVPnJSPZBrwn1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5NioaZGXo/h8EmH+juUjN/ixj5yj5dMRQn7qIFpyDlWaj/bGUecDHgEXCPmTQKkrZLfBVKlLnJqiU/2Sb0SRgtHcdn9ckQ8TOZ4vTJ0M75f8OY1doYcDvfwIMt3OwY3VsCKa1O1SuPDIIHixNFA9VYmLotMFae05iQaHaX6r2gkm6ezC0eBWW+jvoAe5xZwFGvebiAchFm2lfze/xNGpfrMbCLXV+QpxbyWLN7RJpy5ymLjUnOmCKnxbH7A6ngM83BvZ3M9lteBEriQ/xqnjUUHdPob/ihXzx7HoNxxdXKlTNt4Mn132+q5TV6fYarLL5ceRDqvC2g6x85Iuzp+UG2djXsBxs0EUNsuD6QBxNitYa0GzmQnp1kQFObzwIIaFbR20aE3QXpPGP4AqHj89mnKFI+m6yvuxtjE5YyCpKCgMW5nBARtJuLn2R+omxVelAy0Vx0ef1p65Jt+rOf3SO1MUfv3qb/Jfk7kNOtx/RC8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf28608-0426-4305-a967-08d80e5979b4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:53.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bx5DKJxy4Qtl5FjBBBJelrniTqw7GCMvYD5nlHC1h2+8Nq3dOrUtRZ4XFWMNa9Mnvh5MlWgZEGTtCDddKmmUqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Current below problems exists.

1. devlink device is registered by mlx5_load_one(). But it is
not unregistered by mlx5_unload_one(). This is incorrect.

2. Above issue leads to,
When mlx5 PCI device is removed, currently devlink device is
unregistered before devlink ports are unregistered in below ladder
diagram.

remove_one()
  mlx5_devlink_unregister()
    [..]
    devlink_unregister() <- ports are still registered!
  mlx5_unload_one()
    mlx5_unregister_device()
      mlx5_remove_device()
        mlx5e_remove()
          mlx5e_devlink_port_unregister()
            devlink_port_unregister()

3. Condition checking for registering and unregister device are not
symmetric either in these routines.

Hence, fix the sequence by having load and unload routines symmetric
and in right order.
i.e.
(a) register devlink device followed by registering devlink ports
(b) unregister devlink ports followed by devlink device

Do this based on boot and cleanup flags instead of different
conditions.

Fixes: c6acd629eec7 ("net/mlx5e: Add support for devlink-port in non-representors mode")
Fixes: f60f315d339e ("net/mlx5e: Register devlink ports for physical link, PCI PF, VFs")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2729afc13ab48..e786c5c75dbaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1199,23 +1199,22 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	if (err)
 		goto err_load;
 
+	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
+
 	if (boot) {
 		err = mlx5_devlink_register(priv_to_devlink(dev), dev->device);
 		if (err)
 			goto err_devlink_reg;
-	}
-
-	if (mlx5_device_registered(dev))
-		mlx5_attach_device(dev);
-	else
 		mlx5_register_device(dev);
-
-	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
+	} else {
+		mlx5_attach_device(dev);
+	}
 
 	mutex_unlock(&dev->intf_state_mutex);
 	return 0;
 
 err_devlink_reg:
+	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
 	if (boot)
@@ -1231,10 +1230,15 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
-	if (cleanup)
+	mutex_lock(&dev->intf_state_mutex);
+
+	if (cleanup) {
 		mlx5_unregister_device(dev);
+		mlx5_devlink_unregister(priv_to_devlink(dev));
+	} else {
+		mlx5_detach_device(dev);
+	}
 
-	mutex_lock(&dev->intf_state_mutex);
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
 			       __func__);
@@ -1245,9 +1249,6 @@ void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	if (mlx5_device_registered(dev))
-		mlx5_detach_device(dev);
-
 	mlx5_unload(dev);
 
 	if (cleanup)
@@ -1387,8 +1388,6 @@ static void remove_one(struct pci_dev *pdev)
 
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
-	mlx5_devlink_unregister(devlink);
-
 	mlx5_drain_health_wq(dev);
 	mlx5_unload_one(dev, true);
 	mlx5_pci_close(dev);
-- 
2.26.2

