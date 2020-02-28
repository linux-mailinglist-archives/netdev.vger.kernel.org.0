Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC2A172D9E
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbgB1Api (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:38 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730441AbgB1Api (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mp7KBz9/XeaioU46L1FJ9lrjVF+UFpDVbriGJbfsT+NA0B7LHhRdSbF8RuDVrUBXTDAAYYIzYrMRG5avNWGLZ4FHdC6oz/7cQ2hSWzcH2OnE56Ejyum16/fTYiemjmJxImpijFWM0+GMFN4yag9XlIriEnqIIiOAPlHwkbacYZVSKpTA6YehwyYljcqofiVCYVeu3fo1j200bYOI9Z3klWZ/a1j47AhMlFeAblNhdeqh15SaM+amtZ0YfjsrgIFlTGXSb0c0gRjE1MqR6eo5ilrPyf8ro0DRsw+/8CChtkCydcGoW1yhg2YE6/ijT9L1kj+AddyzC5r6MWSoMKOc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWoyUW/0s8qsGVUWl6WesJ7w20vIAEVSjsNnL7Jo4Ac=;
 b=MInUBMrdj2VGoO0K6suZvSg9rwNVn8CkdJBoHM6Smlgpzy3IkGZf36pB+3naFwlnKA5ZO9l1FRcpHsH7x2z9oZATwb58oh/i9//HX0fYo1MJ0qMrk5z9Z09G+v44hkBDKLxz0ay1I+jtE9Np5hMojQr8hiDzQg2ihRJZtSJIm9xV7QUp2+dYEFr86PkoEuA7No2l7mHf3M7wLIneC5AqFpn8npMN4xdHuwZHQ1iuAlEq/pcYQMFWB7GL+45eqXpIrJbweBvi4tkI+MRnvfmTrsViaR8M1wNQemKXxeSWtOkmOJqNhcXFqIABaPyUeAHWGk92utAGJSHlFLbouIsTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWoyUW/0s8qsGVUWl6WesJ7w20vIAEVSjsNnL7Jo4Ac=;
 b=PN/HeDdQr8UTeZ4qowKTzVrVpRishXXXGXs3MB0r5bOFN/CcAJEqZbSV6qPRXwQS6k1j78vDiuxHdOvGuo0zG6uevq2DpSGaPUTrbcKTk8PKxAMKI7RduVjr1vQ6A2fqyG2osQUmBJ4H+6lgQcKjhzZEd3fVPN86JXZwxa5tbjc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/16] net/mlx5e: Add support for devlink-port in non-representors mode
Date:   Thu, 27 Feb 2020 16:44:36 -0800
Message-Id: <20200228004446.159497-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:22 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 607de7c9-70aa-4d6e-cf11-08d7bbe77f10
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB418956E79766C71FDC0B4A75BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:403;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auYhAAqZWpZVgaUIP+Nc/sxjYsbgiBJ7O/dgDLBIjZWHHVY5vP7+oDheGmqWgf62VPX68dSt3GkeoGmEYD9rQADeMrN4HsHDj5UGkmtrj1oEnhvcLfcKFwFap8pM6Loh9I5PPCeQ3yL1CMTQgt2m4OwBcKmLMsOjKyRv62F5lkuOKvMzV5NlkbZNnwywQtJyUYx7kctdW2B7rys3oyhsX4JtjFC/LDN79lxI3Io9XqtU7/aobKG5xfu6TsAAUnjPMRgceKUAFk0qYYhcCF6pvJzxQelF0tCl3/WL0b2Q14uNEFcRRLpD5JcASHjNlwO8jC46CYeePUGRk6vOYwswnu8exz2C41b8Cn80sD2OOQpQaoEQXlvbWF+aJv5tT7MDpPP1RPbw9M8+AaDSbTgNg/rEMHlED0ZJLrfNnlanudmXpeckp3mMNFWWzSGCnw4W8/a2JXI/YR3hgzr6faL7IFWiYd+fgzqRMKNQmHaot3W5WDvYRM5cN36XHZb7i8belZFW1IS737reqFq2OkmiAsKSXOAZey65aZLlo8Beu1s=
X-MS-Exchange-AntiSpam-MessageData: HJAIl7L/ogRZj8HMWXtoCsP37dfDpVzkbsk+HjXe6cg6CHjkEaZiTiFq4azz/ld1U7MgYqVs6dFeJsNG2hs8koCbRq619F9KrFAjpgU01y/jb8ddWEnHrJzgYToLAWiYBIJQu8URQuUe3vPP64lhtQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607de7c9-70aa-4d6e-cf11-08d7bbe77f10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:24.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+WKSNJurEGo3wrQt6nIFdpRQswZHPox5DyZRVbujABAayjjholzc39hFP2SpWgjJxDq8Sy5iU5B/6a5l2NcWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Added devlink_port field to mlx5e_priv structure and a callback to
netdev ops to enable devlink to get info about the port. The port
registration happens at driver initialization.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 38 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/devlink.h  | 15 ++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++++++
 5 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e0bb8e12356e..f3dec6b41436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -25,7 +25,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
-		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 3cc439ab3253..93ca9ea5a96e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -880,6 +880,7 @@ struct mlx5e_priv {
 #endif
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
+	struct devlink_port             dl_phy_port;
 	struct mlx5e_xsk           xsk;
 #if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
new file mode 100644
index 000000000000..1a87a3fc6b44
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020, Mellanox Technologies inc.  All rights reserved. */
+
+#include "en/devlink.h"
+
+int mlx5e_devlink_phy_port_register(struct net_device *dev)
+{
+	struct mlx5e_priv *priv;
+	struct devlink *devlink;
+	int err;
+
+	priv = netdev_priv(dev);
+	devlink = priv_to_devlink(priv->mdev);
+
+	devlink_port_attrs_set(&priv->dl_phy_port,
+			       DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       PCI_FUNC(priv->mdev->pdev->devfn),
+			       false, 0,
+			       NULL, 0);
+	err = devlink_port_register(devlink, &priv->dl_phy_port, 1);
+	if (err)
+		return err;
+	devlink_port_type_eth_set(&priv->dl_phy_port, dev);
+	return 0;
+}
+
+void mlx5e_devlink_phy_port_unregister(struct mlx5e_priv *priv)
+{
+	devlink_port_unregister(&priv->dl_phy_port);
+}
+
+struct devlink_port *mlx5e_get_devlink_phy_port(struct net_device *dev)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	return &priv->dl_phy_port;
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
new file mode 100644
index 000000000000..b8cd63b88688
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc.  All rights reserved. */
+
+#ifndef __MLX5E_EN_DEVLINK_H
+#define __MLX5E_EN_DEVLINK_H
+
+#include <net/devlink.h>
+#include "en.h"
+
+int mlx5e_devlink_phy_port_register(struct net_device *dev);
+void mlx5e_devlink_phy_port_unregister(struct mlx5e_priv *priv);
+struct devlink_port *mlx5e_get_devlink_phy_port(struct net_device *dev);
+
+#endif
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d29e53c023f1..fc14b7be7ca8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -63,6 +63,7 @@
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
 #include "en/hv_vhca_stats.h"
+#include "en/devlink.h"
 #include "lib/mlx5.h"
 
 
@@ -4605,6 +4606,7 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_set_vf_link_state   = mlx5e_set_vf_link_state,
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
 #endif
+	.ndo_get_devlink_port    = mlx5e_get_devlink_phy_port,
 };
 
 static int mlx5e_check_required_hca_cap(struct mlx5_core_dev *mdev)
@@ -5472,11 +5474,19 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 		goto err_detach;
 	}
 
+	err = mlx5e_devlink_phy_port_register(netdev);
+	if (err) {
+		mlx5_core_err(mdev, "mlx5e_devlink_phy_port_register failed, %d\n", err);
+		goto err_unregister_netdev;
+	}
+
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_init_app(priv);
 #endif
 	return priv;
 
+err_unregister_netdev:
+	unregister_netdev(netdev);
 err_detach:
 	mlx5e_detach(mdev, priv);
 err_destroy_netdev:
@@ -5498,6 +5508,7 @@ static void mlx5e_remove(struct mlx5_core_dev *mdev, void *vpriv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_delete_app(priv);
 #endif
+	mlx5e_devlink_phy_port_unregister(priv);
 	unregister_netdev(priv->netdev);
 	mlx5e_detach(mdev, vpriv);
 	mlx5e_destroy_netdev(priv);
-- 
2.24.1

