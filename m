Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D39E6C6633
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCWLMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCWLL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:11:57 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106532CFD4
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrIyzpIyEF+mavFo65vmFz7oUlMUcJQZ6rjgSWwpo51SZ3qEemSAPxU79KRnE1fyG7FxN0u33VgFY640MkyDFeM6vTqwRtRG20NSU/tNg/Fh4i/SzO21wRp6JvkDmhpIcf0blofJbrxuTKbgLQYy8qGfLWzDXQO329WewVHHa3SO2sqzYQEW8V3WybB5fLJ37ytnu/cvcKiiwdSBWl7y4ApHiIg+Qs+FmrzFMxrshbdTqTlHViLxSj0R+9xmw4wSvs5BsWYcOCa2PS7rvsDHkYz/AECPvW6aur5EAk12LhHI96h2NklKtJLeaqyxRzKAKLmSD2mnV9RCekHvLdfuuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McCag0KGpa3dRuv6lc7U5CPZYXflkVHZ2NahGFznI4Y=;
 b=BoHX39w41tsN+6FhZgLlkxWpxJ6+4PZBcwMfr4oiB+ZD1JYwQQD6dWZlShAs5FaNDLVX0XRWwx3FbZiL4fTQxDRJOKFV6GniiIZU6tYGv7ZaHPZG57X8UiBO3wGn8IAbA/0gqjhT1PBMEBFkOPcIrYoQ8ha3g0+izkIc5un9hDzkJ0sL8yy4xXplVGlLSi2jI0zYfQFPnmCYcFuSy7TdUZ9CyIUQzAJgIqGZNwYsA+MJ9dbqZtpUANXvRCaZavZtE9Sr0qJsMJ4FID9xs0mTUwaEbN6RL1Y0nDI5jCvZogwonE5BdUfNVjYROsbCHq5dyEPP9VTG1LzPWzWXLxLvnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McCag0KGpa3dRuv6lc7U5CPZYXflkVHZ2NahGFznI4Y=;
 b=aP/7OKS6+UPeP/XcoEOMLP/68L+Oixo5EuvxSmlDBbfKFvasSBiytY8+zQzJPNn02rNr4UklwYacuuLh8wGtsMLOCyjx8LKvLcd3tJgF3smlC8V6yN6zmTx+aeSdvD+ooT1IYdajWVuefT/UsU++E+N8pAJ8u5xXCsE45V8eDqCKLjwX56JT07aBwbyRB9+mspVKQJk7Zfu7eizfmo57zFgxbcZX6ldN0G0YOGaoj1JqGMcScNgYPnc8M19T+eFgp2jo7UBfjQGGAB8ZY/udtXJv7FvBPZY5R6QXCGZ8RdRKZrIH54U4GbFMKbHxxz0DY5VkWX6JApfkX6+cm8pTfQ==
Received: from DS7PR03CA0289.namprd03.prod.outlook.com (2603:10b6:5:3ad::24)
 by CH2PR12MB5017.namprd12.prod.outlook.com (2603:10b6:610:36::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 11:11:51 +0000
Received: from DS1PEPF0000E648.namprd02.prod.outlook.com
 (2603:10b6:5:3ad:cafe::a) by DS7PR03CA0289.outlook.office365.com
 (2603:10b6:5:3ad::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 11:11:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E648.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 11:11:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:11:45 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 23 Mar
 2023 04:11:45 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Thu, 23 Mar
 2023 04:11:42 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/4] net/mlx5: Implement devlink port function cmds to control ipsec_crypto
Date:   Thu, 23 Mar 2023 13:10:57 +0200
Message-ID: <20230323111059.210634-3-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E648:EE_|CH2PR12MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 24237b52-4feb-4898-df38-08db2b8f66ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GkGLNoOKGdOfeq3Rrmqg6TKNDJwhVU7JYSPXJz+JIL0jJzR4I4MVJf0dhr3bzuCnTIJgXcPy+71tC/B3IQnCrZ8efRuZjC36C+tWQlLoGKfpwpuSd2gFMxCSDufKIP4ntjlagi2DsKyF40XBSP0wcXP2/0JYJrvRZQ7+faqpIpG1WczZf+i6+Nl21vejJMAQ5WIh5k5xeB0nmHdTvFz41AScaFFyRLJ8EmxJi1ySpQhNy0H0OqAJa9ltjX8RPt15m4i+IpA+bPtOKnNJOGwlUt9sIjY2PkP1h9jCQAmPqJbzvtftO0e7huulz9juZHVLtdFM0QciWCxFT7RlUPEAxEaX/N7h5ONcGEntZr1jlH+ivudxiLHMBtMj6eo5Rba+tjlqo/BWBSwnI9tPwCK95BgYEyCq3NZTG8x8FcdXn7qiJb+PUnv072QDxHADfxwI61xq3QQVeEnD+JYJWzUIq84jTi3Q0XtfpL8XWtSVPkv4iXHFo5Af7fY3cpEtZwWx0sAblOC/V4h/cGSaSl/Svx+Slo1RGW2NJh/8XoYuPyqPMTxvaytzosnKmoQA8tvlRgR6olzRgqxhIn56mTP2oYZezehYrwqRvBcjv2H4X3DXAYDL/SMbfy///63XLyQY4GoPb+t0GSJRdEHU9w9Unj3LB7LU7qL3BeMcmsVKuc6jr4SqUBaA79kC/BnsDLerQv4fNjYxrgLJtr5iTibG3YNhpBIg+JqPgx1PmHRFw8wd2J49ics2bDfHGZj2WJKdTUcW91b8qoNvVBZa6U6bhA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(46966006)(40470700004)(36840700001)(336012)(107886003)(26005)(1076003)(47076005)(6666004)(426003)(8676002)(70206006)(316002)(4326008)(7696005)(2616005)(54906003)(70586007)(6916009)(40480700001)(478600001)(8936002)(2906002)(41300700001)(36860700001)(5660300002)(30864003)(7636003)(82740400003)(356005)(83380400001)(186003)(86362001)(82310400005)(36756003)(40460700003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:11:50.8743
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24237b52-4feb-4898-df38-08db2b8f66ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E648.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5017
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement devlink port function commands to enable / disable IPsec
crypto offloads.  This is used to control the IPsec capability of the
device.

When ipsec_crypto is enabled for a VF, it prevents adding IPsec crypto
offloads on the PF, because the two cannot be active simultaneously due
to HW constraints. Conversely, if there are any active IPsec crypto
offloads on the PF, it's not allowed to enable ipsec_crypto on a VF,
until PF IPsec offloads are cleared.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlx5/switchdev.rst      |   8 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 ++
 .../ethernet/mellanox/mlx5/core/esw/ipsec.c   | 271 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  29 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  20 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 100 +++++++
 .../ethernet/mellanox/mlx5/core/lib/ipsec.h   |  41 +++
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   3 +
 11 files changed, 494 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
index 01deedb71597..9a41da6b33ff 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
@@ -168,6 +168,14 @@ explicitly enable the VF migratable capability.
 mlx5 driver support devlink port function attr mechanism to setup migratable
 capability. (refer to Documentation/networking/devlink/devlink-port.rst)
 
+IPsec crypto capability setup
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+User who wants mlx5 PCI VFs to be able to perform IPsec crypto offloading need
+to explicitly enable the VF ipsec_crypto capability.
+
+mlx5 driver support devlink port function attr mechanism to setup ipsec_crypto
+capability. (refer to Documentation/networking/devlink/devlink-port.rst)
+
 SF state setup
 --------------
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 6c2f1d4a58ab..02ccf440a09f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -69,7 +69,7 @@ mlx5_core-$(CONFIG_MLX5_TC_SAMPLE)   += en/tc/sample.o
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
 				      ecpf.o rdma.o esw/legacy.o \
-				      esw/debugfs.o esw/devlink_port.o esw/vporttbl.o esw/qos.o
+				      esw/debugfs.o esw/devlink_port.o esw/vporttbl.o esw/qos.o esw/ipsec.o
 
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1ee2a472e1d2..6beea396401a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -324,6 +324,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
 	.port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
 	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
+	.port_fn_ipsec_crypto_get = mlx5_devlink_port_fn_ipsec_crypto_get,
+	.port_fn_ipsec_crypto_set = mlx5_devlink_port_fn_ipsec_crypto_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7b0d3de0ec6c..573769a6b002 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -37,6 +37,8 @@
 #include <linux/netdevice.h>
 
 #include "en.h"
+#include "eswitch.h"
+#include "lib/ipsec.h"
 #include "ipsec.h"
 #include "ipsec_rxtx.h"
 
@@ -307,6 +309,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	struct net_device *netdev = x->xso.real_dev;
 	struct mlx5e_ipsec *ipsec;
+	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
 	int err;
 
@@ -326,6 +329,11 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	sa_entry->x = x;
 	sa_entry->ipsec = ipsec;
 
+	esw = priv->mdev->priv.eswitch;
+	if (esw && mlx5_esw_vport_ipsec_offload_enabled(esw))
+		return -EBUSY;
+	mlx5_eswitch_ipsec_offloads_count_inc(priv->mdev);
+
 	/* check esn */
 	mlx5e_ipsec_update_esn_state(sa_entry);
 
@@ -361,6 +369,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
+	mlx5_eswitch_ipsec_offloads_count_dec(priv->mdev);
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 	return err;
@@ -374,6 +383,7 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 
 	old = xa_erase_bh(&ipsec->sadb, sa_entry->ipsec_obj_id);
 	WARN_ON(old != sa_entry);
+	mlx5_eswitch_ipsec_offloads_count_dec(ipsec->mdev);
 }
 
 static void mlx5e_xfrm_free_state(struct xfrm_state *x)
@@ -567,6 +577,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 {
 	struct net_device *netdev = x->xdo.real_dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
+	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
 	int err;
 
@@ -587,6 +598,11 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	pol_entry->x = x;
 	pol_entry->ipsec = priv->ipsec;
 
+	esw = priv->mdev->priv.eswitch;
+	if (esw && mlx5_esw_vport_ipsec_offload_enabled(esw))
+		return -EBUSY;
+	mlx5_eswitch_ipsec_offloads_count_inc(priv->mdev);
+
 	mlx5e_ipsec_build_accel_pol_attrs(pol_entry, &pol_entry->attrs);
 	err = mlx5e_accel_ipsec_fs_add_pol(pol_entry);
 	if (err)
@@ -596,6 +612,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	return 0;
 
 err_fs:
+	mlx5_eswitch_ipsec_offloads_count_dec(priv->mdev);
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 	return err;
@@ -605,6 +622,7 @@ static void mlx5e_xfrm_free_policy(struct xfrm_policy *x)
 {
 	struct mlx5e_ipsec_pol_entry *pol_entry = to_ipsec_pol_entry(x);
 
+	mlx5_eswitch_ipsec_offloads_count_dec(pol_entry->ipsec->mdev);
 	mlx5e_accel_ipsec_fs_del_pol(pol_entry);
 	kfree(pol_entry);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
new file mode 100644
index 000000000000..ab67e375c87b
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/mlx5/device.h>
+#include <linux/mlx5/vport.h>
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "lib/ipsec.h"
+
+static int esw_ipsec_vf_query_generic(struct mlx5_core_dev *dev, u16 vport_num, bool *result)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *hca_cap = NULL, *query_cap = NULL;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(dev))
+		return 0;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	if (!query_cap)
+		return -ENOMEM;
+
+	err = mlx5_vport_get_other_func_general_cap(dev, vport_num, query_cap);
+	if (err)
+		goto out;
+
+	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
+	*result = MLX5_GET(cmd_hca_cap, hca_cap, ipsec_offload);
+out:
+	kvfree(query_cap);
+	return err;
+}
+
+enum esw_vport_ipsec_offload {
+	MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD,
+};
+
+static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vport, bool *crypto)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *hca_cap = NULL, *query_cap = NULL;
+	bool ipsec_enabled;
+	int err;
+
+	/* Querying IPsec caps only makes sense when generic ipsec_offload
+	 * HCA cap is enabled
+	 */
+	err = esw_ipsec_vf_query_generic(dev, vport->index, &ipsec_enabled);
+	if (err)
+		return err;
+	if (!ipsec_enabled) {
+		*crypto = false;
+		return 0;
+	}
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	if (!query_cap)
+		return -ENOMEM;
+
+	err = mlx5_vport_get_other_func_cap(dev, vport->index, query_cap, MLX5_CAP_IPSEC);
+	if (err)
+		goto out;
+
+	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
+	*crypto = MLX5_GET(ipsec_cap, hca_cap, ipsec_crypto_offload);
+out:
+	kvfree(query_cap);
+	return err;
+}
+
+static int esw_ipsec_vf_set_generic(struct mlx5_core_dev *dev, u16 vport_num, bool ipsec_ofld)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *hca_cap = NULL, *query_cap = NULL, *cap;
+	int ret;
+
+	if (!MLX5_CAP_GEN(dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	hca_cap = kvzalloc(set_sz, GFP_KERNEL);
+	if (!hca_cap || !query_cap) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = mlx5_vport_get_other_func_general_cap(dev, vport_num, query_cap);
+	if (ret)
+		goto out;
+
+	cap = MLX5_ADDR_OF(set_hca_cap_in, hca_cap, capability);
+	memcpy(cap, MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
+	MLX5_SET(cmd_hca_cap, cap, ipsec_offload, ipsec_ofld);
+
+	MLX5_SET(set_hca_cap_in, hca_cap, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, hca_cap, other_function, 1);
+	MLX5_SET(set_hca_cap_in, hca_cap, function_id, vport_num);
+
+	MLX5_SET(set_hca_cap_in, hca_cap, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1);
+	ret = mlx5_cmd_exec_in(dev, set_hca_cap, hca_cap);
+out:
+	kvfree(hca_cap);
+	kvfree(query_cap);
+	return ret;
+}
+
+static int esw_ipsec_vf_set_bytype(struct mlx5_core_dev *dev, struct mlx5_vport *vport,
+				   bool enable, enum esw_vport_ipsec_offload type)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *hca_cap = NULL, *query_cap = NULL, *cap;
+	int ret;
+
+	if (!MLX5_CAP_GEN(dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	hca_cap = kvzalloc(set_sz, GFP_KERNEL);
+	if (!hca_cap || !query_cap) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = mlx5_vport_get_other_func_cap(dev, vport->index, query_cap, MLX5_CAP_IPSEC);
+	if (ret)
+		goto out;
+
+	cap = MLX5_ADDR_OF(set_hca_cap_in, hca_cap, capability);
+	memcpy(cap, MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
+
+	switch (type) {
+	case MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD:
+		MLX5_SET(ipsec_cap, cap, ipsec_crypto_offload, enable);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	MLX5_SET(set_hca_cap_in, hca_cap, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, hca_cap, other_function, 1);
+	MLX5_SET(set_hca_cap_in, hca_cap, function_id, vport->index);
+
+	MLX5_SET(set_hca_cap_in, hca_cap, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_IPSEC << 1);
+	ret = mlx5_cmd_exec_in(dev, set_hca_cap, hca_cap);
+out:
+	kvfree(hca_cap);
+	kvfree(query_cap);
+	return ret;
+}
+
+static int esw_ipsec_vf_crypto_aux_caps_set(struct mlx5_core_dev *dev, u16 vport_num, bool enable)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *hca_cap = NULL, *query_cap = NULL, *cap;
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	int ret;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	hca_cap = kvzalloc(set_sz, GFP_KERNEL);
+	if (!hca_cap || !query_cap) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = mlx5_vport_get_other_func_cap(dev, vport_num, query_cap, MLX5_CAP_ETHERNET_OFFLOADS);
+	if (ret)
+		goto out;
+
+	cap = MLX5_ADDR_OF(set_hca_cap_in, hca_cap, capability);
+	memcpy(cap, MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
+	MLX5_SET(per_protocol_networking_offload_caps, cap, insert_trailer, enable);
+	MLX5_SET(set_hca_cap_in, hca_cap, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, hca_cap, other_function, 1);
+	MLX5_SET(set_hca_cap_in, hca_cap, function_id, vport_num);
+	MLX5_SET(set_hca_cap_in, hca_cap, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_ETHERNET_OFFLOADS << 1);
+	ret = mlx5_cmd_exec_in(esw->dev, set_hca_cap, hca_cap);
+out:
+	kvfree(hca_cap);
+	kvfree(query_cap);
+	return ret;
+}
+
+static int esw_ipsec_vf_offload_set_bytype(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+					   bool enable, enum esw_vport_ipsec_offload type)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	int err = 0;
+
+	if (vport->index == MLX5_VPORT_PF)
+		return -EOPNOTSUPP;
+
+	if (!mlx5_esw_vport_ipsec_offload_enabled(esw) && mlx5_eswitch_ipsec_offloads_enabled(dev))
+		return -EBUSY;
+
+	if (type == MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD) {
+		err = esw_ipsec_vf_crypto_aux_caps_set(dev, vport->index, enable);
+		if (err) {
+			mlx5_core_dbg(dev,
+				      "Failed to set auxiliary caps for ipsec_crypto_offload: %d\n",
+				      err);
+			return err;
+		}
+	}
+
+	if (enable) {
+		err = esw_ipsec_vf_set_generic(dev, vport->index, enable);
+		if (err) {
+			mlx5_core_dbg(dev, "Failed to enable generic ipsec_offload: %d\n", err);
+			return err;
+		}
+		err = esw_ipsec_vf_set_bytype(dev, vport, enable, type);
+		if (err) {
+			mlx5_core_dbg(dev, "Failed to enable ipsec_offload type %d: %d\n", type,
+				      err);
+			return err;
+		}
+	} else {
+		err = esw_ipsec_vf_set_bytype(dev, vport, enable, type);
+		if (err) {
+			mlx5_core_dbg(dev, "Failed to disable ipsec_offload type %d: %d\n", type,
+				      err);
+			return err;
+		}
+		err = esw_ipsec_vf_set_generic(dev, vport->index, enable);
+		if (err) {
+			mlx5_core_dbg(dev, "Failed to disable generic ipsec_offload: %d\n",
+				      err);
+			return err;
+		}
+	}
+
+	if (type == MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD)
+		vport->info.ipsec_crypto_enabled = enable;
+
+	return err;
+}
+
+bool mlx5_esw_ipsec_vf_offload_supported(struct mlx5_core_dev *dev)
+{
+	/* Old firmware doesn't support ipsec_offload capability for VFs. This
+	 * can be detected by checking reformat_add_esp_trasport capability -
+	 * when this cap isn't supported it means firmware cannot be trusted
+	 * about what it reports for ipsec_offload cap.
+	 */
+	return MLX5_CAP_FLOWTABLE_NIC_TX(dev, reformat_add_esp_trasport);
+}
+
+int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport, bool *crypto)
+{
+	return esw_ipsec_vf_query(dev, vport, crypto);
+}
+
+int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+					 bool enable)
+{
+	return esw_ipsec_vf_offload_set_bytype(esw, vport, enable,
+					       MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0f052513fefa..7d4f19c21f48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -47,6 +47,7 @@
 #include "devlink.h"
 #include "ecpf.h"
 #include "en/mod_hdr.h"
+#include "en_accel/ipsec.h"
 
 enum {
 	MLX5_ACTION_NONE = 0,
@@ -782,6 +783,7 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
 	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	bool ipsec_crypto_enabled;
 	void *query_ctx;
 	void *hca_caps;
 	int err;
@@ -809,6 +811,11 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 
 	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
 	vport->info.mig_enabled = MLX5_GET(cmd_hca_cap_2, hca_caps, migratable);
+
+	err = mlx5_esw_ipsec_vf_offload_get(esw->dev, vport, &ipsec_crypto_enabled);
+	if (err)
+		goto out_free;
+	vport->info.ipsec_crypto_enabled = ipsec_crypto_enabled;
 out_free:
 	kfree(query_ctx);
 	return err;
@@ -873,6 +880,23 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	esw_vport_cleanup_acl(esw, vport);
 }
 
+void mlx5_esw_vport_ipsec_offload_enable(struct mlx5_eswitch *esw)
+{
+	esw->enabled_ipsec_vf_count++;
+	WARN_ON(!esw->enabled_ipsec_vf_count);
+}
+
+void mlx5_esw_vport_ipsec_offload_disable(struct mlx5_eswitch *esw)
+{
+	esw->enabled_ipsec_vf_count--;
+	WARN_ON(esw->enabled_ipsec_vf_count == U16_MAX);
+}
+
+bool mlx5_esw_vport_ipsec_offload_enabled(struct mlx5_eswitch *esw)
+{
+	return !!esw->enabled_ipsec_vf_count;
+}
+
 int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 			  enum mlx5_eswitch_vport_event enabled_events)
 {
@@ -895,6 +919,8 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 	/* Sync with current vport context */
 	vport->enabled_events = enabled_events;
 	vport->enabled = true;
+	if (vport->vport != MLX5_VPORT_PF && vport->info.ipsec_crypto_enabled)
+		mlx5_esw_vport_ipsec_offload_enable(esw);
 
 	/* Esw manager is trusted by default. Host PF (vport 0) is trusted as well
 	 * in smartNIC as it's a vport group manager.
@@ -953,6 +979,9 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
 		mlx5_esw_vport_vhca_id_clear(esw, vport_num);
 
+	if (vport->vport != MLX5_VPORT_PF && vport->info.ipsec_crypto_enabled)
+		mlx5_esw_vport_ipsec_offload_disable(esw);
+
 	/* We don't assume VFs will cleanup after themselves.
 	 * Calling vport change handler while vport is disabled will cleanup
 	 * the vport resources.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 19e9a77c4633..dc7949814b91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -157,6 +157,7 @@ struct mlx5_vport_info {
 	u8                      trusted: 1;
 	u8                      roce_enabled: 1;
 	u8                      mig_enabled: 1;
+	u8                      ipsec_crypto_enabled: 1;
 };
 
 /* Vport context events */
@@ -343,6 +344,7 @@ struct mlx5_eswitch {
 	}  params;
 	struct blocking_notifier_head n_head;
 	struct dentry *dbgfs;
+	u16 enabled_ipsec_vf_count;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -519,6 +521,10 @@ int mlx5_devlink_port_fn_migratable_get(struct devlink_port *port, bool *is_enab
 					struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_migratable_set(struct devlink_port *port, bool enable,
 					struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_crypto_get(struct devlink_port *port, bool *is_enabled,
+					  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable,
+					  struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
@@ -653,6 +659,15 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
 
+bool mlx5_esw_ipsec_vf_offload_supported(struct mlx5_core_dev *dev);
+int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport,
+				  bool *crypto);
+int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+					 bool enable);
+void mlx5_esw_vport_ipsec_offload_enable(struct mlx5_eswitch *esw);
+void mlx5_esw_vport_ipsec_offload_disable(struct mlx5_eswitch *esw);
+bool mlx5_esw_vport_ipsec_offload_enabled(struct mlx5_eswitch *esw);
+
 int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 			  enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
@@ -805,6 +820,11 @@ mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw)
 {
 	return 0;
 }
+
+static inline bool mlx5_esw_vport_ipsec_offload_enabled(struct mlx5_eswitch *esw)
+{
+	return false;
+}
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 22075943bb58..fd546dd0a481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4139,3 +4139,103 @@ int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
+
+int mlx5_devlink_port_fn_ipsec_crypto_get(struct devlink_port *port, bool *is_enabled,
+					  struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_crypto");
+		return err;
+	}
+
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled) {
+		*is_enabled = vport->info.ipsec_crypto_enabled;
+		err = 0;
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable,
+					  struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	struct net *net;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_crypto");
+		return err;
+	}
+
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	/* xfrm_cfg lock is needed to avoid races with XFRM state being added to
+	 * the PF net device. Netlink stack takes this lock for `ip xfrm` user
+	 * commands, so here we need to take it before esw->state_lock to
+	 * preserve the order.
+	 */
+	net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
+	mutex_lock(&net->xfrm.xfrm_cfg_mutex);
+
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+		goto out;
+	}
+	if (vport->info.ipsec_crypto_enabled == enable) {
+		err = 0;
+		goto out;
+	}
+
+	err = mlx5_esw_ipsec_vf_crypto_offload_set(esw, vport, enable);
+	switch (err) {
+	case 0:
+		break;
+	case -EBUSY:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed setting ipsec_crypto. Make sure ip xfrm state/policy is cleared on the PF.");
+		goto out;
+	case -EINVAL:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed setting ipsec_crypto. Make sure to unbind the VF first");
+		goto out;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Failed setting HCA ipsec_crypto_offload cap.");
+		goto out;
+	}
+
+	vport->info.ipsec_crypto_enabled = enable;
+	if (enable)
+		mlx5_esw_vport_ipsec_offload_enable(esw);
+	else
+		mlx5_esw_vport_ipsec_offload_disable(esw);
+out:
+	mutex_unlock(&esw->state_lock);
+	mutex_unlock(&net->xfrm.xfrm_cfg_mutex);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h
new file mode 100644
index 000000000000..cf0bca6d5f3e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_LIB_IPSEC_H__
+#define __MLX5_LIB_IPSEC_H__
+
+#include <linux/mlx5/driver.h>
+
+#ifdef CONFIG_MLX5_EN_IPSEC
+
+/* The caller must hold mlx5_eswitch->state_lock */
+static inline void mlx5_eswitch_ipsec_offloads_count_inc(struct mlx5_core_dev *mdev)
+{
+	WARN_ON(mdev->ipsec_offloads_count == U64_MAX);
+	mdev->ipsec_offloads_count++;
+}
+
+/* The caller must hold mlx5_eswitch->state_lock */
+static inline void mlx5_eswitch_ipsec_offloads_count_dec(struct mlx5_core_dev *mdev)
+{
+	WARN_ON(mdev->ipsec_offloads_count == 0);
+	mdev->ipsec_offloads_count--;
+}
+
+/* The caller must hold mlx5_eswitch->state_lock */
+static inline bool mlx5_eswitch_ipsec_offloads_enabled(struct mlx5_core_dev *mdev)
+{
+	return !!mdev->ipsec_offloads_count;
+}
+#else
+static inline void mlx5_eswitch_ipsec_offloads_count_inc(struct mlx5_core_dev *mdev) { }
+
+static inline void mlx5_eswitch_ipsec_offloads_count_dec(struct mlx5_core_dev *mdev) { }
+
+static inline bool mlx5_eswitch_ipsec_offloads_enabled(struct mlx5_core_dev *mdev)
+{
+	return false;
+}
+#endif /* CONFIG_MLX5_EN_IPSEC */
+
+#endif /* __MLX5_LIB_IPSEC_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7a898113b6b7..a139c9a8ddb5 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -811,6 +811,7 @@ struct mlx5_core_dev {
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 	struct mlx5_thermal	*thermal;
+	u64                      ipsec_offloads_count;
 };
 
 struct mlx5_db {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e47d6c58da35..6e4a013b36ed 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -65,9 +65,11 @@ enum {
 
 enum {
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE        = 0x0,
+	MLX5_SET_HCA_CAP_OP_MOD_ETHERNET_OFFLOADS     = 0x1,
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
+	MLX5_SET_HCA_CAP_OP_MOD_IPSEC                 = 0x15,
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE2       = 0x20,
 	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
 };
@@ -3456,6 +3458,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_macsec_cap_bits macsec_cap;
 	struct mlx5_ifc_crypto_cap_bits crypto_cap;
+	struct mlx5_ifc_ipsec_cap_bits ipsec_cap;
 	u8         reserved_at_0[0x8000];
 };
 
-- 
2.40.0

