Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252786EA89B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjDUKuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDUKuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:50:02 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA759038
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:49:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgyGkihVn4ymMRP/EM5QlMgj7DFyT6dSB5nsGJtRX1DOBE0hlwWDTajpFZYnKA89htZN4tBwMQ1FFnP+zYwj+hQc2vq6Huu2kuPtxQT1VuqbOJK0y54UNStIT3LSeiCuXg7+73OOrhFQdqtw0OAilFgCQ4z2MiKAh4+Rj2rpRxn/NSQy1JAklwDG8BbejWYx3jlfRlChre7VRd5e7h2JEXTJkW0uoeH9ZBNjRoNIfBzSQAKAF8zCXOxcfH/S3H+Q15Jw55RlCt+zbQ7aXVegqFoCCuPf796tGHWtwZoJ8t+urAq69dCneLw4iul33lAv63HJb2WQ9bVkBIYIaSVgrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNzh+/gLNKT7sPaM9ChnFfJ4kiwD1XB3qpDxer0hc5o=;
 b=IrIhCh6cXDDlfNwwUWFC6o9OKVXm5r08jHKyuXLNKR6FBqvQI4tKXYqSEsVRXZM9A7zuLnRnOF4YoT9t1nAPAc+IpCMrLNBFWAt78gghUZsC5DT2EC3RLPtMK6z/WvqriTzxFROhzLPzSfCkPfrs3eKfoP3b067unTtPFKumbsQtG55Vt7zT7ZyNeQi+5zZjofYM7DPqR5agTu+S8xEc0Q7HpV/IIZxqyxxNauVPmmCTDrI9PZ8w//HftbNoEz1fRg9Oo635CnvwNn06NCIyVLT3GaUuZ0KTuOFfQD7ILO+PFQI7CV035wE4nCsbVePI9wiRhcOgOLXI8aXH6J89vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNzh+/gLNKT7sPaM9ChnFfJ4kiwD1XB3qpDxer0hc5o=;
 b=MHDDW1btIyT1PZmD0sd0yo9fHl5GC/BPdoe2KS0YprdDlue9ZADaB6O91IWlQRK/RCMfnA8zG+x8WqoPllLMS6JsYvKdGJkti5VtP8o+f8lSaYevfWDKEFpNbb5kloR4nmh3ul4iZyyjApQ3xYVi3cP0nJTdi2irrHgx5RSGzKW4+x+m8BMNLGlakwmou0rZM8BeiWwztubLATjHmLvpmTiu2WK39JSJDR/h3/vW+QvKHrhyNbSaYSQLIt9DOwRdnldUBmc2iDDIxjlC3oVgpux0cO2VTkTK3nSAwsH17NJwbpBHT3K2Mra1WgXp56EPDMliq0mcE9p0RhVCYg3qDw==
Received: from BN9PR03CA0229.namprd03.prod.outlook.com (2603:10b6:408:f8::24)
 by CO6PR12MB5410.namprd12.prod.outlook.com (2603:10b6:5:35b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Fri, 21 Apr
 2023 10:49:47 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:408:f8:cafe::24) by BN9PR03CA0229.outlook.office365.com
 (2603:10b6:408:f8::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 10:49:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.15 via Frontend Transport; Fri, 21 Apr 2023 10:49:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 03:49:38 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 03:49:37 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 03:49:35 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next V2 2/4] net/mlx5: Implement devlink port function cmds to control ipsec_crypto
Date:   Fri, 21 Apr 2023 13:48:59 +0300
Message-ID: <20230421104901.897946-3-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421104901.897946-1-dchumak@nvidia.com>
References: <20230421104901.897946-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|CO6PR12MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: 540c0d23-0541-4e30-9d69-08db42561fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xXf0FTH2crFa2a/Jll0LQ6eA1ND4Fh8xxJ8QBRXvAcGJVFSDcwa0ZurahEsPA1X1f27BoJNFqDBfjMwKcEPrjLh3Jmf+LWVnWyg4We+NM23iP/3VcmZqG6RIqJLbJRsbVCO4f5EQL/dRltQnnAyQq3VDKvhfAykaT1JS3fdCDurDfyhpK9/UoWvrQxy0jCY7x9HQ+B85frMRY2fsAnGA795vYegRRUB51RDVpxoRpjQygiS+Tr6KP0HH7ZIfRc8zf0JCoxy1MYHoBb+yMHZowmGNWlV7QqLhldvy+l5yKFWJsYleF/uJi8f0IZFbYXQOKh7YpVQnZfwLb9YVYgjly4KAe8LjHvbLWyM2E6HE8KR5Omxt1oQhfueg7ro4oFlbqZwh8/iEhXzWdirVCsVolg+obKjtlE7XovlhRVTOX/GmS/5JnzFP+M3kxrxepnd19S0Nj6ZiMvzgul8nt6tY74/bIgWzxLVgnHbmCd+0iM+Kgx4FAlHleXfLcdNLfETTaAzkaYT7r9wlWYM/6d4lXZzg0GQOxFw/cUsf8OK7BRfbryi5uWISujb+vjLIyqmuXvE9Tt3td/iAELUonhvDIWNJB5/loyDQNZScL7jzoFVi5i7VHRjyNf70E3pmbGIDzx4O+1yjZUJcmXHCiIwAys0eRjk3OunVgvcsA7axHcQ1UcAXAu7BRB5PI67yJio/rEl6iL3JqjoOmaGA1HKHEuUVJWNkRdz+k/Wqrt5j30Yyo507Px6ZGDqyV8TefyXucLm/x+pYV0UB8gT9ETc7EQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(186003)(426003)(336012)(107886003)(41300700001)(6666004)(7696005)(36860700001)(83380400001)(47076005)(2616005)(54906003)(478600001)(110136005)(40460700003)(4326008)(82310400005)(70586007)(70206006)(40480700001)(356005)(316002)(7636003)(5660300002)(8936002)(82740400003)(36756003)(2906002)(30864003)(86362001)(8676002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 10:49:47.0158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 540c0d23-0541-4e30-9d69-08db42561fd9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5410
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
---
v1 -> v2:
 - Fix build when CONFIG_XFRM is not set.
 - Fix switchdev mode init for HW that doesn't have ipsec_offload
   capability
 - Perform additional capability checks to test if ipsec_crypto offload
   is supported by the HW
---
 .../ethernet/mellanox/mlx5/switchdev.rst      |   8 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 +
 .../ethernet/mellanox/mlx5/core/esw/ipsec.c   | 329 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  29 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  23 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 105 ++++++
 .../ethernet/mellanox/mlx5/core/lib/ipsec.h   |  41 +++
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   3 +
 11 files changed, 563 insertions(+), 2 deletions(-)
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
index ca3c66cd47ec..3f84950d0217 100644
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
index 25d1a04ef443..e1c7cd11444f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -324,7 +324,11 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
 	.port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
 	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
-#endif
+#ifdef CONFIG_XFRM
+	.port_fn_ipsec_crypto_get = mlx5_devlink_port_fn_ipsec_crypto_get,
+	.port_fn_ipsec_crypto_set = mlx5_devlink_port_fn_ipsec_crypto_set,
+#endif /* CONFIG_XFRM */
+#endif /* CONFIG_MLX5_ESWITCH */
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
 	.port_del = mlx5_devlink_sf_port_del,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 5fd609d1120e..aa67f129dc94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -38,6 +38,8 @@
 #include <net/netevent.h>
 
 #include "en.h"
+#include "eswitch.h"
+#include "lib/ipsec.h"
 #include "ipsec.h"
 #include "ipsec_rxtx.h"
 
@@ -622,6 +624,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	struct net_device *netdev = x->xso.real_dev;
 	struct mlx5e_ipsec *ipsec;
+	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
 	gfp_t gfp;
 	int err;
@@ -646,6 +649,11 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	if (err)
 		goto err_xfrm;
 
+	esw = priv->mdev->priv.eswitch;
+	if (esw && mlx5_esw_vport_ipsec_offload_enabled(esw))
+		return -EBUSY;
+	mlx5_eswitch_ipsec_offloads_count_inc(priv->mdev);
+
 	/* check esn */
 	if (x->props.flags & XFRM_STATE_ESN)
 		mlx5e_ipsec_update_esn_state(sa_entry);
@@ -711,6 +719,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	kfree(sa_entry->work->data);
 	kfree(sa_entry->work);
 err_xfrm:
+	mlx5_eswitch_ipsec_offloads_count_dec(priv->mdev);
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 	return err;
@@ -734,6 +743,7 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 		/* Make sure that no ARP requests are running in parallel */
 		flush_workqueue(ipsec->wq);
 
+	mlx5_eswitch_ipsec_offloads_count_dec(ipsec->mdev);
 }
 
 static void mlx5e_xfrm_free_state(struct xfrm_state *x)
@@ -1007,6 +1017,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 {
 	struct net_device *netdev = x->xdo.real_dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
+	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
 	int err;
 
@@ -1027,6 +1038,11 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
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
@@ -1036,6 +1052,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	return 0;
 
 err_fs:
+	mlx5_eswitch_ipsec_offloads_count_dec(priv->mdev);
 	kfree(pol_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 	return err;
@@ -1045,6 +1062,7 @@ static void mlx5e_xfrm_free_policy(struct xfrm_policy *x)
 {
 	struct mlx5e_ipsec_pol_entry *pol_entry = to_ipsec_pol_entry(x);
 
+	mlx5_eswitch_ipsec_offloads_count_dec(pol_entry->ipsec->mdev);
 	mlx5e_accel_ipsec_fs_del_pol(pol_entry);
 	kfree(pol_entry);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
new file mode 100644
index 000000000000..5da5fc17cafb
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
@@ -0,0 +1,329 @@
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
+	if (!mlx5_esw_ipsec_vf_offload_supported(dev)) {
+		*result = false;
+		return 0;
+	}
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
+static bool esw_ipsec_offload_supported(struct mlx5_core_dev *dev, u16 vport_num)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *hca_cap = NULL, *query_cap = NULL;
+	int err;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	if (!query_cap)
+		return false;
+
+	err = mlx5_vport_get_other_func_cap(dev, vport_num, query_cap, MLX5_CAP_GENERAL);
+	if (err)
+		goto notsupported;
+	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
+	if (!MLX5_GET(cmd_hca_cap, hca_cap, log_max_dek))
+		goto notsupported;
+
+	kvfree(query_cap);
+	return true;
+
+notsupported:
+	kvfree(query_cap);
+	return false;
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
+bool mlx5_esw_ipsec_vf_crypto_offload_supported(struct mlx5_core_dev *dev, u16 vport_num)
+{
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *hca_cap = NULL, *query_cap = NULL;
+	int err;
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(dev))
+		return false;
+
+	if (!esw_ipsec_offload_supported(dev, vport_num))
+		return false;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	if (!query_cap)
+		return false;
+
+	err = mlx5_vport_get_other_func_cap(dev, vport_num, query_cap, MLX5_CAP_ETHERNET_OFFLOADS);
+	if (err)
+		goto notsupported;
+	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
+	if (!MLX5_GET(per_protocol_networking_offload_caps, hca_cap, swp))
+		goto notsupported;
+
+	kvfree(query_cap);
+	return true;
+
+notsupported:
+	kvfree(query_cap);
+	return false;
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
index 8bdf28762f41..e3b492a84f1b 100644
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
index e9d68fdf68f5..d1f469ec284b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -157,6 +157,7 @@ struct mlx5_vport_info {
 	u8                      trusted: 1;
 	u8                      roce_enabled: 1;
 	u8                      mig_enabled: 1;
+	u8                      ipsec_crypto_enabled: 1;
 };
 
 /* Vport context events */
@@ -344,6 +345,7 @@ struct mlx5_eswitch {
 	}  params;
 	struct blocking_notifier_head n_head;
 	struct dentry *dbgfs;
+	u16 enabled_ipsec_vf_count;
 };
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
@@ -520,6 +522,12 @@ int mlx5_devlink_port_fn_migratable_get(struct devlink_port *port, bool *is_enab
 					struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_migratable_set(struct devlink_port *port, bool enable,
 					struct netlink_ext_ack *extack);
+#ifdef CONFIG_XFRM
+int mlx5_devlink_port_fn_ipsec_crypto_get(struct devlink_port *port, bool *is_enabled,
+					  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable,
+					  struct netlink_ext_ack *extack);
+#endif /* CONFIG_XFRM */
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
@@ -654,6 +662,16 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
 
+bool mlx5_esw_ipsec_vf_offload_supported(struct mlx5_core_dev *dev);
+bool mlx5_esw_ipsec_vf_crypto_offload_supported(struct mlx5_core_dev *dev, u16 vport_num);
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
@@ -819,6 +837,11 @@ static inline bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev)
 static inline void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
 {
 }
+
+static inline bool mlx5_esw_vport_ipsec_offload_enabled(struct mlx5_eswitch *esw)
+{
+	return false;
+}
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b6e2709c1371..d0cb80714f00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4204,3 +4204,108 @@ int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
+
+#ifdef CONFIG_XFRM
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
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_crypto");
+		return err;
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
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!mlx5_esw_ipsec_vf_crypto_offload_supported(esw->dev, vport_num)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device doesn't support ipsec_crypto or capability is blocked");
+		return err;
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
+#endif /* CONFIG_XFRM */
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
index 135a3c8d8237..5c2ad022879f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -812,6 +812,7 @@ struct mlx5_core_dev {
 	u32                      vsc_addr;
 	struct mlx5_hv_vhca	*hv_vhca;
 	struct mlx5_thermal	*thermal;
+	u64                      ipsec_offloads_count;
 };
 
 struct mlx5_db {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 20d00e09b168..e1ee4cf4799f 100644
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
@@ -3477,6 +3479,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_macsec_cap_bits macsec_cap;
 	struct mlx5_ifc_crypto_cap_bits crypto_cap;
+	struct mlx5_ifc_ipsec_cap_bits ipsec_cap;
 	u8         reserved_at_0[0x8000];
 };
 
-- 
2.40.0

