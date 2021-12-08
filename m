Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3455246D57F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhLHOVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:21:25 -0500
Received: from mail-dm6nam12on2053.outbound.protection.outlook.com ([40.107.243.53]:49696
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234950AbhLHOVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 09:21:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZpZAcpxMzF/tHX4R6+Qg1X2JF9Eq7CRrd8kor8eUckM6ORdF3qlPOrN3cc3W+129p/NcPiWrumD/KdPRMStDlX00z5SYmzlxdTRK81RRk7TDUg2azlMLEviWWVe1R1nn2CYkNmf0Yxy7mjoVRVk1mIKFTBHg8fcIaWzOM1qig6ajw3WGe9Kx84WncPtSpmwhF+ItzGoECddcIQu7xrvCIIJ8llf44KtTHqLSX2apVAQBM1jB1kzBfvaHsadyFwnlwgqytJIjTy4bQWpg1S7v4vCI+xhdAfzeWVFkAuexrVZMwWh7eJat2PFSSORTB+3fMFb5uogx13PPYu33BSxGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBlgrDTQ7dqnqNMoSVQAssmI+LEq8AF4WB5QjgpPCN0=;
 b=MhPL2SAEPSlU2244wJinyVqva8PHHF3JzFkbYetGjgqKqFlbXS8ZTOKog5wHuOpc+tkb/EW+fIhh2m6lsjC+idTXgKlteDzZYaRPoNxh6q4RhVPLgjJqwzXdkgA2OrrTyeyKVzHUmpTwRH8l+ZoicjBmnH9rhfB79NmfReQfl1DM7/ss7BsnOm5Q5DpSU9sTJzAoeJjQG/CcRBDGBXXPGHU9UAwc459aqr90I3vDRiWW4jfsCZNEsIOr6ev4+m2//Yns+cSw8lKuB/lIsKuYea180WXvoJTdIDZdztuNOoeLpexxBJ+CXe82z4/skyw36FSgr6jjFVjAA9NJ46kk1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBlgrDTQ7dqnqNMoSVQAssmI+LEq8AF4WB5QjgpPCN0=;
 b=VnRdjyAlny1M3iQrWSGdQFoA1hZbuhAGOX3vfnRVbQm8twyZzYOIpSMBVmDKBNoAyhKZaMz2bgaWq50rewZ4FKec/Hy6ViZt0Aj0preByVKk2vDS1Nqc4PtaUndY7wIaLXWijfbKZfvTkiRX+Zkf4BJavhrx+6vkobCueKkCOBXoHaVU4DxVXAhOQ1AZdBIbMQyahkfSsBv2R7Pl8xANdMnm5ZEiw0S8wZOIeUoSf7olkXik0tyfFQhUdMP77VGNgPWUTROJS4cd2Zs1Ew9hcH3ka0HHDkmJekRes8bS9W4ilmAnkUXV4Iye1PiuB4iYd6j58F7H6kKVjCDO677HAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM6PR12MB5568.namprd12.prod.outlook.com (2603:10b6:5:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 14:17:49 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 14:17:49 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v3 3/7] net/mlx5: Let user configure io_eq_size param
Date:   Wed,  8 Dec 2021 16:17:18 +0200
Message-Id: <20211208141722.13646-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0502CA0011.eurprd05.prod.outlook.com
 (2603:10a6:203:91::21) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM5PR0502CA0011.eurprd05.prod.outlook.com (2603:10a6:203:91::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 14:17:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 557733f0-1508-400e-fce5-08d9ba55837e
X-MS-TrafficTypeDiagnostic: DM6PR12MB5568:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5568794DF751B78B40200195CF6F9@DM6PR12MB5568.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fcUe571HiJyu7U/m6dDemyS1/FQcfxgpVYJE4ZyhhJaD8tv/KVITAKVp+ThRnTmG+KEBvGpcyfKLOZaYFt1nxxge3B2WjLcaBvxQhQZn3CmL9Fg0W+9LBk6O2GvuAe3cW62Uz5tC03xJTBIGV1rSb9awMPebPxaXGHeCcTgUIklXNOa5FWUnvVkDkvtRL7gp8PFTmLPciobC23h/uatxO++2Siy6E26J9lO1erJ6RH1jN2Qvua34vxgyMKQNxfBCiRGmn/DoW5Q8T/gcDQdwqg1H3CjqhPTQTckAXszKtbHjV4TLX0iMemQRoCeemKD7nHbFc8wEv48yAcKOVgKoS377tlN1L5YNic1zEkdniu8DZpP//xJayMDPRTjTuSvxt1PnVyhsCJG//OlBCv2NFUJALvsjq0SjX4455ZdCG054565DA0V+DaYpeB+ITO2JiXQ12PcNg883VpjBejSJmTu7jx1RsMNeuQCcE8Z1JcLV7L5PS3KFcve3vN+gnFacl+HLskuSt1do3fH8K0WHZQpilZpoCkUeCN5IlE0GU9+Oa1Lyo6mckG6BBLa2yuSb4WCNkdHUjouPlGlQOPzV2jrAB0zUaOXZy4Q+LmUjKfBRArv2ht8sDZc9bsMroHZzlgRogMRVzg2U7xdqlHTjTQTuD5BMkI12+GXkeeUGfslFXwr+o347D0JzcV+4fC/4UChHa/Pvu5f4UmoIU8QIGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66476007)(66556008)(1076003)(26005)(6512007)(52116002)(6666004)(107886003)(66946007)(6486002)(508600001)(2906002)(5660300002)(4326008)(8936002)(6506007)(36756003)(54906003)(186003)(956004)(38350700002)(8676002)(110136005)(2616005)(83380400001)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ge2BZknIGBcj6F3bZ+m7/wSJmSwiKCZmSK7PwMnByCSf25Ki+mQ+YygESiBp?=
 =?us-ascii?Q?n1HOe+zHj1wXmwfR9jCUCgM7z1YiJeOGnLqXPNgQH/fS2wvlAzD2bzKDdWDg?=
 =?us-ascii?Q?yA8l5/HerPspg3MgTPsJr7zgNpkrkO5+7T69SHKozpnuRMi7m3wY8tBGUMSK?=
 =?us-ascii?Q?x4G2Z1xET2YgQbJGxiLn0eglFA6NFYawzjkvOAzK/v1PCSmjg8WtJ5yGPvjj?=
 =?us-ascii?Q?SfdHuLx3hhOf6M4W708JOeRaFQuENQ4HOj092RlsgHp+RsA44C+LnUtileyB?=
 =?us-ascii?Q?9VRgl1vTouL1eUvtZe3BVk+fwzyCX23UyseJGJ4GyFF2It0oGXwgSbH1h1Z9?=
 =?us-ascii?Q?6+a474c1sMAUxbIOI057SUmCuZBa0bsHF2BkM43JLDy9hMPox4GbIs0+9q4v?=
 =?us-ascii?Q?oCdpJGKf6H0DY6pzTVVKaLiBq53gkAZoAW3c3NgKfjGAWcwe5DKu1GmzpGr6?=
 =?us-ascii?Q?+KrCxAKpG7fbO65xbFwWh8Bj6wmsnHHbr+QnURP7wp1FG4umtsiD/3Hwh/zx?=
 =?us-ascii?Q?TDtnWfAt7s41fmp01iJPJWQAUN3wCp8wgyt1BdvlkT+DjfLGpwo/+4m//+Pk?=
 =?us-ascii?Q?gUhIIQybWL9eUTnnjDVWPzBmnNv/yf0Fkimi8Lywl8fl7IoDe/49O7Xm+etS?=
 =?us-ascii?Q?2UDFy83ezNlJVbRnKWvVMEtYBOu2qNbT+nMenIrGiAWHf/p2URIH5BWOn89+?=
 =?us-ascii?Q?XqDAjLZDm9efPdvapBi5hreLIC9tR74mXlz9zUOZtmwXGoSadRWtEh+687UC?=
 =?us-ascii?Q?2dULA0Rvgks8K17wNwyZ9lf2NRZZHqxghChKqcP6lKZUA2hwMKd/0J0BybdC?=
 =?us-ascii?Q?lfPtFn2GfKmuQCvSi47Z0eqF2kozvVt+P05Rz8OrBY2ACD2/5qDWJKlPMX40?=
 =?us-ascii?Q?grVfXdupl+jJ5sk/y6Lo0qozfqrxaxt9uR2pjDdm02wtjXqatY/6axk/THJe?=
 =?us-ascii?Q?fQrVqpG4JNYFb9/Yvyx5b2vtpAdEvHYGaZPhu8y1VzKKsfxzIZt48dvqcaMW?=
 =?us-ascii?Q?YD8k2C9ryigI3w8r9rcCWZ+ehKHQKoWcScjIZjWFF6NQ8i7momXbch2ECiR9?=
 =?us-ascii?Q?it/isBXmtkePetOluEfHSLSGoSo0Grbwcwa9SQN226J/T07xHddBzZOb2GJ9?=
 =?us-ascii?Q?JC+2z4Q9SY90q9PFi53VOGQKiIQAMhQ7E0dljPjUMX6yxDJtCcR+MaMGdOyE?=
 =?us-ascii?Q?s/vXKwGSUphnN9GHgH1mXeIznj1KP8dPtcKWt4t/CULuK3oIvHH+4GpqACUb?=
 =?us-ascii?Q?L8q9edJ4BRjVoVE5tsY0RwW5yWs1rlgHoPISAY3f33l/o6xqSbNwBo23ZQiD?=
 =?us-ascii?Q?h/oSb0ILHaUDiObTg1Yv0ZZ8wBFl5Mtqtcd397snQ6nQgaXwjD4bElZ4qCh0?=
 =?us-ascii?Q?/YV4CFKubIsjE6H0qyuIbUkUR7/oTkf/1ieK/bE+vmoLHFdCFUgfLAYl0pRn?=
 =?us-ascii?Q?ZiUGy4fPD97GTyWwVunY/20uB6S1b/tXOv8hF7BD8XvhfVpHX/E4thnECWwV?=
 =?us-ascii?Q?nAU0ycxbTmnyHyTb0+WOyDAkso5wOKH/Koa3rsSbLnjQal6LNwFv2Ga9jOjA?=
 =?us-ascii?Q?yD2r5iXIo6g3brZk2MmdWKtAe0RH3D7iIOTycEK8SrVbZBXL+Tj6RW6qy4KO?=
 =?us-ascii?Q?vUBmszm9JiL5bLbNas/9kqo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557733f0-1508-400e-fce5-08d9ba55837e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 14:17:49.2771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qvhjJ4XIREMztv7ECtWRlqv9CvqYCabj8zFaG4kdRiyVsQj7z79dv3KnGjvwvYdBXJARpGXcBlWnrwVjUOvRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5568
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, each I/O EQ is taking 128KB of memory. This size
is not needed in all use cases, and is critical with large scale.
Hence, allow user to configure the size of I/O EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink dev param set pci/0000:00:0b.0 name io_eq_size value 64 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst      |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c  | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   | 18 +++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 4e4b97f7971a..291e7f63af73 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -14,8 +14,12 @@ Parameters
 
    * - Name
      - Mode
+     - Validation
    * - ``enable_roce``
      - driverinit
+   * - ``io_eq_size``
+     - driverinit
+     - The range is between 64 and 4096.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c98652b244a..177c6e9159f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -546,6 +546,13 @@ static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32
 	return 0;
 }
 
+static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
+					  union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	return (val.vu16 >= 64 && val.vu16 <= 4096) ? 0 : -EINVAL;
+}
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
@@ -570,6 +577,8 @@ static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			      mlx5_devlink_enable_remote_dev_reset_get,
 			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
+	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_eq_depth_validate),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -608,6 +617,11 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 						   value);
 	}
 #endif
+
+	value.vu32 = MLX5_COMP_EQ_SIZE;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+					   value);
 }
 
 static const struct devlink_param enable_eth_param =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 792e0d6aa861..7686d7c9c824 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -19,6 +19,7 @@
 #include "lib/clock.h"
 #include "diag/fw_tracer.h"
 #include "mlx5_irq.h"
+#include "devlink.h"
 
 enum {
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
@@ -796,6 +797,21 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 	}
 }
 
+static u16 comp_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+						 &val);
+	if (!err)
+		return val.vu32;
+	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
+	return MLX5_COMP_EQ_SIZE;
+}
+
 static int create_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -807,7 +823,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 
 	INIT_LIST_HEAD(&table->comp_eqs_list);
 	ncomp_eqs = table->num_comp_eqs;
-	nent = MLX5_COMP_EQ_SIZE;
+	nent = comp_eq_depth_devlink_param_get(dev);
 	for (i = 0; i < ncomp_eqs; i++) {
 		struct mlx5_eq_param param = {};
 		int vecidx = i;
-- 
2.21.3

