Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CEA189423
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgCRCsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:30 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727133AbgCRCs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcDoAGtEVCAUGWWu1XZKcENlC3M7r9gskoLpYuTw5TJuydsmhp14IorsXukjvmQnYyLUxXliakx/7Q1JdHINJwjCW1tR2c/Gs3jruuIlnQOI8JF3h+TemyHfucHIRvpQUtWMvfF1wKsAQFRx04eL/eVbauppIQey9S46Ik9DhvZqB8OZiTrYprtzWSpA9ujlaZKfMUlWJRu9q3sPKbHbF/kQ5usq9UUOMRvJFvHHNRh6I0AqGb4Pis4M0V7bx0EpVNvsbyfAdBF32i0iuvXxe5IEVNU84q1QWOtlz5JqqhvbMAgbSrE+2wYYZfAEJjRyuJl1cbpDZuzRVrgLmv4W6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0oA59Lkb1+NvytZrNt1BFD51e7Qv3XsLm2IlVFSIsA=;
 b=NRJFvZplRGhEssTcTlc71bFdXBDNiaAXMn+mL5TVAxgO0h1Ya29mKW1ZVWXTZlFBKU7KWERhcOfe2OdYgQcz8jgNfdVvIzSyFRRkxhgbZI13upfQArE24S07olW2PkQQqIa9nerSA8uJkpB1jPGplAufszdvRxdShJMCGuTL1EWoVHLhRv1GcBLt2ZJpsa3UoinVhYBxTAyZUUH/9PqgzE+Ma+9WG/MmPbRccnRIEIvwYP5bLmEnY1zemWwrOac/NHZgLzncjf7ifcNSel3Koohl5kdAb762fTrI/854NTIYM+01w3u6mKEfgclUoQg+PjBimiSdl/lsEd1gGffVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0oA59Lkb1+NvytZrNt1BFD51e7Qv3XsLm2IlVFSIsA=;
 b=dcYcfwAXrZ7iKO0wfay7lRwyAUARJ5kClisLVs8eoWrfAL+GhoD4Klmf03DsJGLDMFDrY9mTjf5oaQm+eTArg4/t/e/ZhlaRSK7JOqhTzLEy9TXN+lvUFd5xojxe6OJfH9RqhU7JEu/6qKd4Hs9txM5ozUK/N2SuWuRHEHRzQWM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/14] net/mlx5e: Fix devlink port register sequence
Date:   Tue, 17 Mar 2020 19:47:17 -0700
Message-Id: <20200318024722.26580-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:16 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5cdf098-1883-43da-f7d1-08d7cae6d024
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41090421464812D93A8B9098BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eM5YjDaLQRZhv/cFCetGGJwM1VHloJqdnHln+7bfCH+jmOJ+fN1BPRtRaPBCOGUDw6S7pBGxA/QnzBVxS79qbF7b8TDiBGqFIIqVgs8cz1hbGP9xwAheGk+HKhv3z6miLv/aJ24QNjwWfwpw7NK+m8d70T1wYo0QS82Sq5J9i5C/j7EEixwvsOKvMjnXRfm/oKcZZi7UJJGuqZ00LrSPXEy56DSGZcDvlCdRl5BPTPrnGxQsXyALin5f4ETjzkgy08QTCc0mHmKorZ7B6FDRztwnnWB/50bARbB4gw6h1493cn65SGJvRrBcymOD796kdIcycTH0v5ZqK6gIiiSOvqSegBrVtqYsrfyPk26O3iNzDkQr6uxlIw6EPEG7aEqgAtonIaAXynEcLxFa99uvEM3wHTTyVDAXJSxB+4VCg93TKZHTdTFMUMifc5ca/RWf339UbfCkB3c6HNNpSSHicBWazBIVGkJ73sTbzglEoEhLpgU4/KGmgMupDt++S7OjY7fX3KtcsjBPytvIdp9VW5usjfGhNMAcR5RFbXsARhc=
X-MS-Exchange-AntiSpam-MessageData: 4oAsf/O84AuCv7DcgHDLgfiq+VCHBZ5aPdyes83GuO1MwF20e14ce+c0+uU2Q4X3rWPuofe6w4ksDcrKphm9cuHlJTjgUR9mRmyT+UZ9nwq3m5kFPEc8UZ60hZSWO+WKRv6wCZOznemMW0zPVLoFsA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5cdf098-1883-43da-f7d1-08d7cae6d024
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:18.2065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtSQRqHiVTRNyppopBtTS/t7PUvmkO9jN+UtblPbq0TGzS3GlSkxbDxSLvOVtTzWwInJZzCNruREVva3ijHx3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

If udevd is configured to rename interfaces according to persistent
naming rules and if a network interface has phys_port_name in sysfs,
its contents will be appended to the interface name.
However, register_netdev creates device in sysfs and if
devlink_port_register is called after that, there is a timeframe in
which udevd may read an empty phys_port_name value. The consequence is
that the interface will lose this suffix and its name will not be
really persistent.

The solution is to register the port before registering a netdev.

Fixes: c6acd629eec7 ("net/mlx5e: Add support for devlink-port in non-representors mode")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 26 +++++++------------
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 16 +++++++-----
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index e38495e4aa42..f8b2de4b04be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -3,20 +3,14 @@
 
 #include "en/devlink.h"
 
-int mlx5e_devlink_port_register(struct net_device *netdev)
+int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 {
-	struct mlx5_core_dev *dev;
-	struct mlx5e_priv *priv;
-	struct devlink *devlink;
-	int err;
+	struct devlink *devlink = priv_to_devlink(priv->mdev);
 
-	priv = netdev_priv(netdev);
-	dev = priv->mdev;
-
-	if (mlx5_core_is_pf(dev))
+	if (mlx5_core_is_pf(priv->mdev))
 		devlink_port_attrs_set(&priv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       PCI_FUNC(dev->pdev->devfn),
+				       PCI_FUNC(priv->mdev->pdev->devfn),
 				       false, 0,
 				       NULL, 0);
 	else
@@ -24,12 +18,12 @@ int mlx5e_devlink_port_register(struct net_device *netdev)
 				       DEVLINK_PORT_FLAVOUR_VIRTUAL,
 				       0, false, 0, NULL, 0);
 
-	devlink = priv_to_devlink(dev);
-	err = devlink_port_register(devlink, &priv->dl_port, 1);
-	if (err)
-		return err;
-	devlink_port_type_eth_set(&priv->dl_port, netdev);
-	return 0;
+	return devlink_port_register(devlink, &priv->dl_port, 1);
+}
+
+void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
+{
+	devlink_port_type_eth_set(&priv->dl_port, priv->netdev);
 }
 
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 3e5393a0901f..83123a801adc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -7,8 +7,9 @@
 #include <net/devlink.h>
 #include "en.h"
 
-int mlx5e_devlink_port_register(struct net_device *dev);
+int mlx5e_devlink_port_register(struct mlx5e_priv *priv);
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
+void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv);
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f9c928afec89..be20d2247594 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5467,25 +5467,27 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 		goto err_destroy_netdev;
 	}
 
-	err = register_netdev(netdev);
+	err = mlx5e_devlink_port_register(priv);
 	if (err) {
-		mlx5_core_err(mdev, "register_netdev failed, %d\n", err);
+		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 		goto err_detach;
 	}
 
-	err = mlx5e_devlink_port_register(netdev);
+	err = register_netdev(netdev);
 	if (err) {
-		mlx5_core_err(mdev, "mlx5e_devlink_phy_port_register failed, %d\n", err);
-		goto err_unregister_netdev;
+		mlx5_core_err(mdev, "register_netdev failed, %d\n", err);
+		goto err_devlink_port_unregister;
 	}
 
+	mlx5e_devlink_port_type_eth_set(priv);
+
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_init_app(priv);
 #endif
 	return priv;
 
-err_unregister_netdev:
-	unregister_netdev(netdev);
+err_devlink_port_unregister:
+	mlx5e_devlink_port_unregister(priv);
 err_detach:
 	mlx5e_detach(mdev, priv);
 err_destroy_netdev:
-- 
2.24.1

