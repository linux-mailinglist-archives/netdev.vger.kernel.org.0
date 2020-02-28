Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F322172DA0
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgB1Apn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:43 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730447AbgB1Apm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ygs23d/XojN/oydgoBGdbfsepcbliQS1xjzhMcaZbwPFYTYNp+OLu912RDXdyDer+BoG7gMEPli+r2g8EHMKDOQb3ts/49TbDXRxwPY0bO3KdokP2K+ISCszVMCoLzU3/JGO0EqfAVCUfIFvmfUqKCh+Hoq0kwiAkcznAOeJj1INKGxaAKeJIGJ+NLw74j1KGQepTn608FjJCMfs/PUMki8HU4cz5iyF2pP4uXKHOdCgw1PjMplC5IE1iLSrg+lBP0OEl6u+7qbsmGRL5I1BCrceRnBuMEHRzl/76JmGERGuaqUbmCmralY2nnCUyl1vCHAJVqi05vyaVZAADeMzgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DDwDeDNh96jDB2JLAa8vNhd5clzlG4HJnaq/7oTK44=;
 b=EJZKij2NjXhTwu+oqxIuxxzwDBmHL9lqMCjxCgCaqKTjm0Fdyj+P86ZemioTIgZK2F2it+OPucYPoMsoL1DIM3cMKj48SAFqRsaurRqYmMkGrE9a8Q9LwiMc7zZpXvJY3XqLVckoHtqeBhGoKTO5jPPpHeYM/DxVBVMvIOv4N6YOz5Go9v3ymPGpxsLUi8QYC94utikQPQJ/LcaWpU2sCw4iapDDLvumTT7w8GiBoveE0wQBLqm52w7QZ3tb1aOTgydjVcsDfJO3H6yN5L4p5i9ZV+eeu0RvJVy972TfTzLCa3lXzGmedEF3IZnOBbqSCGQEr25rvl/ts6JMUX19jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DDwDeDNh96jDB2JLAa8vNhd5clzlG4HJnaq/7oTK44=;
 b=KqX+ZdPA/CXb3lgGIhcYG1bdadq6lIrJTlwmAt3WYJ93/W4ZLNgr1gOW3hYQjhKxWlIxW0dj7mJRcTb67tMSyyGy+IKNEOMAI1t8L6WBLL7Do7iAVptO7BtpsrJlXh44BLg92+0nXdeH3MAy2ZQxBYwEYYHKgvQNgBbJRCkXivw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups parameter
Date:   Thu, 27 Feb 2020 16:44:38 -0800
Message-Id: <20200228004446.159497-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:26 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8015d723-4e72-49a0-4a9b-08d7bbe781ae
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB418991656EE51405E45D3A47BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Awkp87pJ2u2NUiLqT4dwb1OCdpKRXQ23zxFAM7WhK5vulFw7yiToMII9K0ei2+TnixCyqZEOmq4dDJyWlLPHtpCZnHXfak5n7Xw+olpvNR0yTTMvynJIEmvVZ8lWZoZx/oVTX5NTXuvHjif5uPCQawGjLmsFIFEGRq+tu/082wuyJoLC+NZ23dwsbw3nSQ++0ol+IfaXYCLkdZIw82YNw2VCJSOhzgkZfiXIuH3LZ6yguT/zr4ypVj1EHbbm2wIc5J+bW/S1yZKMtgQGmHjaN9CplrupHmP82WgxFvUfaPU83zBfPn285C56VAfWYYe/xAj2UxHaDemd1tYGVFysJYJW64XsOrrOPy3UqqkyKkNiHJlFvoDCaa7KtuDxsLqtYOdRcs3fiT8YhklV9ZD47XDuOoIapD6FIvmDVZd/DW4G+roR0c36NRdwI3YKRwM23suv+KJHQl9xHShGUX6dNgJ/4AmNJpas3FCuUWZEijV5fWeAT1ggejNwLYE1AIDfwkjkvIROZswHVH52wOaDMsehvdnGIHP4LB4XR14zMYs=
X-MS-Exchange-AntiSpam-MessageData: wUUnkT8iOGsDc1YKgr4yZbJf4ggXBjjhucGZP7Hjjcc7W/gdfyrlM8NmW6aBd8COsd8fX8Set7rAMfp6olwpZ+I5Z8JjSzadd3qh4/1W4T1vvROPLOXS35dfsGXgw0kjHqp3BhoUMLVmHeXrHGSosQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8015d723-4e72-49a0-4a9b-08d7bbe781ae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:28.5826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OHRffx7/RmUjKI7H13JBJZIEUK3TWGZrfpJEEIAX1H+YD1oncjjwD+vVbzCGa/J6ZFaFxKY/XEnHy6PYFb2MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

Add a devlink parameter to control the number of large groups in a
autogrouped flow table. The default value is 15, and the range is between 1
and 1024.

The size of each large group can be calculated according to the following
formula: size = 4M / (fdb_large_groups + 1).

Examples:
- Set the number of large groups to 20.
    $ devlink dev param set pci/0000:82:00.0 name fdb_large_groups \
      cmode driverinit value 20

  Then run devlink reload command to apply the new value.
    $ devlink dev reload pci/0000:82:00.0

- Read the number of large groups in flow table.
    $ devlink dev param show pci/0000:82:00.0 name fdb_large_groups
    pci/0000:82:00.0:
      name fdb_large_groups type driver-specific
        values:
          cmode driverinit value 20

Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/devlink/mlx5.rst     |  6 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 36 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  6 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 22 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 +++-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 ++-
 .../mlx5/core/eswitch_offloads_chains.c       |  4 +--
 7 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 629a6e69c036..4e4b97f7971a 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -37,6 +37,12 @@ parameters.
        * ``smfs`` Software managed flow steering. In SMFS mode, the HW
          steering entities are created and manage through the driver without
          firmware intervention.
+   * - ``fdb_large_groups``
+     - u32
+     - driverinit
+     - Control the number of large groups (size > 1) in the FDB table.
+
+       * The default value is 15, and the range is between 1 and 1024.
 
 The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ca7f08513174..b7bb81b8c49b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -190,11 +190,6 @@ static int mlx5_devlink_fs_mode_get(struct devlink *devlink, u32 id,
 	return 0;
 }
 
-enum mlx5_devlink_param_id {
-	MLX5_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
-};
-
 static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 					     union devlink_param_value val,
 					     struct netlink_ext_ack *extack)
@@ -210,6 +205,23 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+#ifdef CONFIG_MLX5_ESWITCH
+static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id,
+						 union devlink_param_value val,
+						 struct netlink_ext_ack *extack)
+{
+	int group_num = val.vu32;
+
+	if (group_num < 1 || group_num > 1024) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unsupported group number, supported range is 1-1024");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+#endif
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
@@ -218,6 +230,13 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     mlx5_devlink_fs_mode_validate),
 	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_enable_roce_validate),
+#ifdef CONFIG_MLX5_ESWITCH
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+			     "fdb_large_groups", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL,
+			     mlx5_devlink_large_group_num_validate),
+#endif
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -237,6 +256,13 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 					   value);
+
+#ifdef CONFIG_MLX5_ESWITCH
+	value.vu32 = ESW_OFFLOADS_DEFAULT_NUM_GROUPS;
+	devlink_param_driverinit_value_set(devlink,
+					   MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+					   value);
+#endif
 }
 
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index d0ba03774ddf..f0de327a59be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -6,6 +6,12 @@
 
 #include <net/devlink.h>
 
+enum mlx5_devlink_param_id {
+	MLX5_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
+	MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+};
+
 struct devlink *mlx5_devlink_alloc(void);
 void mlx5_devlink_free(struct devlink *devlink);
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index e49acd0c5da5..25640864c375 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -39,6 +39,7 @@
 #include "lib/eq.h"
 #include "eswitch.h"
 #include "fs_core.h"
+#include "devlink.h"
 #include "ecpf.h"
 
 enum {
@@ -2006,6 +2007,25 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw)
 		esw_disable_vport(esw, vport);
 }
 
+static void mlx5_eswitch_get_devlink_param(struct mlx5_eswitch *esw)
+{
+	struct devlink *devlink = priv_to_devlink(esw->dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+						 &val);
+	if (!err) {
+		esw->params.large_group_num = val.vu32;
+	} else {
+		esw_warn(esw->dev,
+			 "Devlink can't get param fdb_large_groups, uses default (%d).\n",
+			 ESW_OFFLOADS_DEFAULT_NUM_GROUPS);
+		esw->params.large_group_num = ESW_OFFLOADS_DEFAULT_NUM_GROUPS;
+	}
+}
+
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
 {
 	int err;
@@ -2022,6 +2042,8 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
 	if (!MLX5_CAP_ESW_EGRESS_ACL(esw->dev, ft_support))
 		esw_warn(esw->dev, "engress ACL is not supported by FW\n");
 
+	mlx5_eswitch_get_devlink_param(esw);
+
 	esw_create_tsar(esw);
 
 	esw->mode = mode;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 479d2458f872..d010657ce601 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -49,13 +49,14 @@
 
 /* The index of the last real chain (FT) + 1 as chain zero is valid as well */
 #define FDB_NUM_CHAINS (FDB_FT_CHAIN + 1)
-#define ESW_OFFLOADS_NUM_GROUPS  4
 
 #define FDB_TC_MAX_PRIO 16
 #define FDB_TC_LEVELS_PER_PRIO 2
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+#define ESW_OFFLOADS_DEFAULT_NUM_GROUPS 15
+
 #define MLX5_MAX_UC_PER_VPORT(dev) \
 	(1 << MLX5_CAP_GEN(dev, log_max_current_uc_list))
 
@@ -262,6 +263,9 @@ struct mlx5_eswitch {
 	u16                     manager_vport;
 	u16                     first_host_vport;
 	struct mlx5_esw_functions esw_funcs;
+	struct {
+		u32             large_group_num;
+	}  params;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9a72c719d8f5..4b5b6618dff4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -71,13 +71,15 @@ struct mlx5_vport_table {
 	struct mlx5_vport_key key;
 };
 
+#define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
+
 static struct mlx5_flow_table *
 esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *fdb;
 
-	ft_attr.autogroup.max_num_groups = ESW_OFFLOADS_NUM_GROUPS;
+	ft_attr.autogroup.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS;
 	ft_attr.max_fte = MLX5_ESW_VPORT_TABLE_SIZE;
 	ft_attr.prio = FDB_PER_VPORT;
 	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 60121f2ee6c5..d41e4f002b84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -237,7 +237,7 @@ mlx5_esw_chains_create_fdb_table(struct mlx5_eswitch *esw,
 	}
 
 	ft_attr.autogroup.num_reserved_entries = 2;
-	ft_attr.autogroup.max_num_groups = ESW_OFFLOADS_NUM_GROUPS;
+	ft_attr.autogroup.max_num_groups = esw->params.large_group_num;
 	fdb = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(fdb)) {
 		esw_warn(esw->dev,
@@ -640,7 +640,7 @@ mlx5_esw_chains_init(struct mlx5_eswitch *esw)
 
 	esw_debug(dev,
 		  "Init esw offloads chains, max counters(%d), groups(%d), max flow table size(%d)\n",
-		  max_flow_counter, ESW_OFFLOADS_NUM_GROUPS, fdb_max);
+		  max_flow_counter, esw->params.large_group_num, fdb_max);
 
 	mlx5_esw_chains_init_sz_pool(esw);
 
-- 
2.24.1

