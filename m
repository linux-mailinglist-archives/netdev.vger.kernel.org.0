Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D0C4C2D34
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiBXNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiBXNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:54 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59211786BA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:35:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwct4dvoCkAPrqmIRu1LVY54XhGk+u43V7Aca1/6Iw1AhqWCP6NZXl9IM3vhsQm6pI88HaG8PwjgIzrtrSAecuXAzqpS0Xg66g9Q8hCRHn5v3tgr0Q9jDcGOa+o8E3FtHHKlNyMbDRr1D1JimootakUki836G40GoNC8yF59Pa4pStRi0uHr0516HyOIWgVjRlBx3M/HYdAAcoyoODsoQaF0Gakl16DsMUKbBvJVKlCWt7HM8GYK7w6e4uC+NGLwS8WBsQmOwiC3v/h7rfUjDFWNFsWTQ06kTFUgSadl50dXSRB0Mi8rHZE843QPRgEQfVf50ua5t5R7CmY9E33aeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ztyjqZXvTtUmK4yYGG2kSf1S0gk5n1/V/POIb5YTmc=;
 b=iNG1TTGXnllvncShJTIYANy6VcOzxYalgfabnYsph9xhFCUaKfZMFM0AjR1MAwQs2zLqQrkMj5OP1ROP3zJhdtKHyGoMENT43hQ0WAK+SF/+GoakCmd4nfip479bOzRipvazMgThn/8ud4P9MLli7i0+bfKVcBSoanGtdibyeJTYUrBsZdN2duddvsNCR/EHSNc2WTVU6Hs3WZM4KW8eMYJ2iZbVld/y7Vkv08usInvok0ToCU8/zCCLBj+qyV8VpvuUwCYpIoEeKTgloduGqv8TnXq6wFNgAXFFD9bgBp1Fc2r/8T165t6keXD6oa7YbZNqb9L63aMN7pW/DcOtZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ztyjqZXvTtUmK4yYGG2kSf1S0gk5n1/V/POIb5YTmc=;
 b=VfwTmZp52iSBtCxroSS4fcTAvLOM+JycpVHZuTnLv+rjjwcrTmgxSrCTjWJlXXAvqlkgghWPsc2DBFKSeaTuSEId29wCEZDGqrqJBIhnn7SgSqFAT+WfgPGAvXU4aI6jmSXzG7wMiWMAx2VDD87p+TOA95lce9xGyYx37Gp+wRctn06odHip44llVNzDLvIbbzxn4SiarC61F38nN8VLRO+yYrZXO8Ykqh4Bg8EkaYXc5Rcg3lWPFw6y0qAOEPJEzXyJ4EvozPyDW/ISD5cGwaX5Yy/tH49U7vqsrhmb+Ik1zS/dZ6lve7HRWqf+LZm6aglKnqUuJqpg26gmevC18w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:35:19 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:35:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/14] mlxsw: Add support for IFLA_OFFLOAD_XSTATS_L3_STATS
Date:   Thu, 24 Feb 2022 15:33:34 +0200
Message-Id: <20220224133335.599529-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0004.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be64157f-7c8e-473a-3abe-08d9f79a7fd1
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60087307D2A874F9CE5CA270B23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sh9ny7ebO+b6XWrjjJf6gxqXYSugxogUBpJ9zO+VZXGUCKsZ9J8k7skQEhvHfF5xFPUJ93n7qVx7sLxfTjr9pYjNH19mQSFWKTidmXlmBd/19PrCaggKQPZiJPb8Lla9geyEVdPB7UMj669NbnNYxYVyd355c7aPQBHFLrpJ4V91RhStTPHudg7uBNys1TlmffMOk6pmEXLeO3fRfPnkLtm8Nh0rGkHCRddbTJpaZg9jEjSDgF7YN4HYrRawlePcVuEVelSR3a/N2wBXJBiDuR5t+oA1arn9a1rZO+gLeclFNGDDXHuX4P/+8NdIEkEouEGCEnPIJHhUG8O0uOtdk/CYuJuAC3yFMj2RfmPlsP/oaPzmrssxbM27IHFs71v0X1SX51woHlHuL3dILtvCneVbMxbe8rSxIR1buCaGVAeJRqZj+v/aHnWVORg6qx1gNM3LG3ddjfbzlVSf/aEJUHR46UzLnb14qZfCV71dxKAT7BSmgRJRSHUi5RbOQaHM/zd0jcNLFaJ7l8AZbD8WJ1R6Zo2WJrqr5kq3w9mlwi5D3OB+bduTDoAoDjM9ppTFvVQUbgs5WDWNLp/Va2CxBx3K7uvKhNqhHTGCvmUz0AwulvIZn4efjiqSodJ6PvfUHIdyQ0Csxp53+PY9oZIeOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(30864003)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lvyv63o8xW5Nk0R7aa9En+5uI7jeiSWX7N+woU6uWxcaMsc9ij5QV+Touixv?=
 =?us-ascii?Q?XtyWoea3vkPLb5wMIhc+sTWLn3eDTfq7X/HeXe8YX/9/ejIEdxt0jKo91vS7?=
 =?us-ascii?Q?tirgLh2FlZBrV0MGlieSw/Ux+YmF7CiPSxpcFqbYspRNBmCfIkY6wSnYSv8g?=
 =?us-ascii?Q?GjQMW1KnXRpLUE0KB4VEsyxnZyCx3QpR4LZsYw9mcjcns4T4QbvrT1pGhVOd?=
 =?us-ascii?Q?PXwviwtOYJaz2AXnJSKtOmHYj/oM2KcKhNuCPZcG0rmGv2sfjQzIsDhNz09h?=
 =?us-ascii?Q?E80RL0fxoFH2znpjVAD3VYTXSQdzt8hUxrkOBLTTuODOWbhKC0nu+p2FuDaX?=
 =?us-ascii?Q?ih8H57r9HfR7uhS+diyBUi0x0cAvma+bQ146cPVR2CD4bdM8S7/K+o0ACvWy?=
 =?us-ascii?Q?eRM1b+JTU8gMSTFSDnRh+O8UVBAjdt1JuPs//E7x/Q0Jo/K5ers3c3Dcjhlq?=
 =?us-ascii?Q?WzAcdXzDx0lgViqLLHhg05qF9W8GMHG9LL7+EetI7myzIZ77FdmQqBw5LaYG?=
 =?us-ascii?Q?JNg/Dwn4R7tTBUyfMSxEtXxu6pxPdiUp4DgTeAa32GValkiYacKW8AgewXD8?=
 =?us-ascii?Q?/ej24CMN+ZQMFeZLKZ7N4XR5+rFuKNnJxZh/6STwHqpB/9eflDDvpVZFuFSF?=
 =?us-ascii?Q?lHkDtFagUplqOpQmGzmEVhNqIB/mYyE0drXuS9HzayUEJ9o0hMyKNAGFwzGK?=
 =?us-ascii?Q?FY0uHIPg1sEYJmSyIftwK6eN45QGF0MdbBu1vq56305ZA1kQ/yIDHn9zOned?=
 =?us-ascii?Q?QWlA2F0JVlPFIrsYjHPnIqYBd7QURA1e1uJuuxCMw/8KgW+xB4zZSx2kUM9K?=
 =?us-ascii?Q?zkKNvNUEMUHGjzaefSHO3pTq28Duuj9yZ9zL/3DFbge8LsETuhFsmVLHb6Ro?=
 =?us-ascii?Q?L2xDDk+f7oDGtRnuLnP2L5MrD/yA2H30UetQqd6QbjAfeb1y1yR1zZLXG7lW?=
 =?us-ascii?Q?gVC9k90uYxwgpSiHkYkkGIyd4/PotJbqHW8Ddbha9DYVBo8xialqNYxspm1z?=
 =?us-ascii?Q?fETSXU8i0tMbdXJm62UA1LnfKCrz3rFyerxY9vuIZaULzABndlqa0fID7DRV?=
 =?us-ascii?Q?cLY+dVYKCs9Ib7MwBdzcP91LVoEhDh3/is3YTxSTQILehhsWReiOXDQMw9LL?=
 =?us-ascii?Q?lrkoq1Lj8dPGCijDWoBJnIywR64MF7zS1EW+H2qfy5HgLByk/EqnUNNFX6lV?=
 =?us-ascii?Q?fz7D70ptr6e0gX2P9mKrs0yLxydOD5skMNzB19LnGsYeHV95UFxXlHdczAOR?=
 =?us-ascii?Q?ja839gjePCnYIeEncppVlUb72+5k46RaHrO9ew/AWERiH6FsgWFBhvXNf9vw?=
 =?us-ascii?Q?+xSnhST0JFUhnb5lh6Hj0dGcdFP7NfpSVQVWj6AB4z/WbFwGKoti28jFeRmU?=
 =?us-ascii?Q?MZT2jMEB5XeTj32BGYHBsQhy0wju61uGSIKCHXlz3Xt7aWA1u/JSGCIfYuCE?=
 =?us-ascii?Q?DTWMUS8BbPUypa/wgrEnOF/J0aA+2FFVzWeUmQehChX3rii18/6Vyih07I98?=
 =?us-ascii?Q?887jj1H5xsu3CXAzPfZfacByoTXsmItlpNTqu/Yovx2ZlkVPuTiciz0IhJoq?=
 =?us-ascii?Q?NcenhOpY+nT1mX7e2KrWPnHAJsuPC3Bs7+AoSJTqgNQqwUIp1wt25/WNO9a0?=
 =?us-ascii?Q?Xoz8Xfmw2RVl4/oHBYoHGMw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be64157f-7c8e-473a-3abe-08d9f79a7fd1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:35:19.3109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DsPYiBPAip9Cu+i0VsTJ40z0bRDMH6QLFiyTokP2S3vy8E65+H0ZBB64SA72Sa7Pm0phthtZstWavQ2Qmc+bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Spectrum machines support L3 stats by binding a counter to a RIF, a
hardware object representing a router interface. Recognize the netdevice
notifier events, NETDEV_OFFLOAD_XSTATS_*, to support enablement,
disablement, and reporting back to core.

As a netdevice gains a RIF, if L3 stats are enabled, install the counters,
and ping the core so that a userspace notification can be emitted.

Similarly, as a netdevice loses a RIF, push the as-yet-unreported
statistics to the core, so that they are not lost, and ping the core to
emit userspace notification.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 291 +++++++++++++++++-
 2 files changed, 293 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 10f32deea158..7b7b17183d10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4829,6 +4829,10 @@ static bool mlxsw_sp_netdevice_event_is_router(unsigned long event)
 	case NETDEV_PRE_CHANGEADDR:
 	case NETDEV_CHANGEADDR:
 	case NETDEV_CHANGEMTU:
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
 		return true;
 	default:
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2b21fea3b37d..7ccf1c6f4643 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -225,6 +225,64 @@ int mlxsw_sp_rif_counter_value_get(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+struct mlxsw_sp_rif_counter_set_basic {
+	u64 good_unicast_packets;
+	u64 good_multicast_packets;
+	u64 good_broadcast_packets;
+	u64 good_unicast_bytes;
+	u64 good_multicast_bytes;
+	u64 good_broadcast_bytes;
+	u64 error_packets;
+	u64 discard_packets;
+	u64 error_bytes;
+	u64 discard_bytes;
+};
+
+static int
+mlxsw_sp_rif_counter_fetch_clear(struct mlxsw_sp_rif *rif,
+				 enum mlxsw_sp_rif_counter_dir dir,
+				 struct mlxsw_sp_rif_counter_set_basic *set)
+{
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	char ricnt_pl[MLXSW_REG_RICNT_LEN];
+	unsigned int *p_counter_index;
+	int err;
+
+	if (!mlxsw_sp_rif_counter_valid_get(rif, dir))
+		return -EINVAL;
+
+	p_counter_index = mlxsw_sp_rif_p_counter_get(rif, dir);
+	if (!p_counter_index)
+		return -EINVAL;
+
+	mlxsw_reg_ricnt_pack(ricnt_pl, *p_counter_index,
+			     MLXSW_REG_RICNT_OPCODE_CLEAR);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ricnt), ricnt_pl);
+	if (err)
+		return err;
+
+	if (!set)
+		return 0;
+
+#define MLXSW_SP_RIF_COUNTER_EXTRACT(NAME)				\
+		(set->NAME = mlxsw_reg_ricnt_ ## NAME ## _get(ricnt_pl))
+
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_unicast_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_multicast_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_broadcast_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_unicast_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_multicast_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_broadcast_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(error_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(discard_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(error_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(discard_bytes);
+
+#undef MLXSW_SP_RIF_COUNTER_EXTRACT
+
+	return 0;
+}
+
 static int mlxsw_sp_rif_counter_clear(struct mlxsw_sp *mlxsw_sp,
 				      unsigned int counter_index)
 {
@@ -242,9 +300,13 @@ int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp_rif *rif,
 	unsigned int *p_counter_index;
 	int err;
 
+	if (mlxsw_sp_rif_counter_valid_get(rif, dir))
+		return 0;
+
 	p_counter_index = mlxsw_sp_rif_p_counter_get(rif, dir);
 	if (!p_counter_index)
 		return -EINVAL;
+
 	err = mlxsw_sp_counter_alloc(mlxsw_sp, MLXSW_SP_COUNTER_SUB_POOL_RIF,
 				     p_counter_index);
 	if (err)
@@ -8146,6 +8208,166 @@ u16 mlxsw_sp_ipip_lb_ul_rif_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif)
 	return lb_rif->ul_rif_id;
 }
 
+static bool
+mlxsw_sp_router_port_l3_stats_enabled(struct mlxsw_sp_rif *rif)
+{
+	return mlxsw_sp_rif_counter_valid_get(rif,
+					      MLXSW_SP_RIF_COUNTER_EGRESS) &&
+	       mlxsw_sp_rif_counter_valid_get(rif,
+					      MLXSW_SP_RIF_COUNTER_INGRESS);
+}
+
+static int
+mlxsw_sp_router_port_l3_stats_enable(struct mlxsw_sp_rif *rif)
+{
+	int err;
+
+	err = mlxsw_sp_rif_counter_alloc(rif, MLXSW_SP_RIF_COUNTER_INGRESS);
+	if (err)
+		return err;
+
+	/* Clear stale data. */
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_INGRESS,
+					       NULL);
+	if (err)
+		goto err_clear_ingress;
+
+	err = mlxsw_sp_rif_counter_alloc(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	if (err)
+		goto err_alloc_egress;
+
+	/* Clear stale data. */
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_EGRESS,
+					       NULL);
+	if (err)
+		goto err_clear_egress;
+
+	return 0;
+
+err_clear_egress:
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+err_alloc_egress:
+err_clear_ingress:
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_INGRESS);
+	return err;
+}
+
+static void
+mlxsw_sp_router_port_l3_stats_disable(struct mlxsw_sp_rif *rif)
+{
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_INGRESS);
+}
+
+static void
+mlxsw_sp_router_port_l3_stats_report_used(struct mlxsw_sp_rif *rif,
+					  struct netdev_notifier_offload_xstats_info *info)
+{
+	if (!mlxsw_sp_router_port_l3_stats_enabled(rif))
+		return;
+	netdev_offload_xstats_report_used(info->report_used);
+}
+
+static int
+mlxsw_sp_router_port_l3_stats_fetch(struct mlxsw_sp_rif *rif,
+				    struct rtnl_link_stats64 *p_stats)
+{
+	struct mlxsw_sp_rif_counter_set_basic ingress;
+	struct mlxsw_sp_rif_counter_set_basic egress;
+	int err;
+
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_INGRESS,
+					       &ingress);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_EGRESS,
+					       &egress);
+	if (err)
+		return err;
+
+#define MLXSW_SP_ROUTER_ALL_GOOD(SET, SFX)		\
+		((SET.good_unicast_ ## SFX) +		\
+		 (SET.good_multicast_ ## SFX) +		\
+		 (SET.good_broadcast_ ## SFX))
+
+	p_stats->rx_packets = MLXSW_SP_ROUTER_ALL_GOOD(ingress, packets);
+	p_stats->tx_packets = MLXSW_SP_ROUTER_ALL_GOOD(egress, packets);
+	p_stats->rx_bytes = MLXSW_SP_ROUTER_ALL_GOOD(ingress, bytes);
+	p_stats->tx_bytes = MLXSW_SP_ROUTER_ALL_GOOD(egress, bytes);
+	p_stats->rx_errors = ingress.error_packets;
+	p_stats->tx_errors = egress.error_packets;
+	p_stats->rx_dropped = ingress.discard_packets;
+	p_stats->tx_dropped = egress.discard_packets;
+	p_stats->multicast = ingress.good_multicast_packets +
+			     ingress.good_broadcast_packets;
+
+#undef MLXSW_SP_ROUTER_ALL_GOOD
+
+	return 0;
+}
+
+static int
+mlxsw_sp_router_port_l3_stats_report_delta(struct mlxsw_sp_rif *rif,
+					   struct netdev_notifier_offload_xstats_info *info)
+{
+	struct rtnl_link_stats64 stats = {};
+	int err;
+
+	if (!mlxsw_sp_router_port_l3_stats_enabled(rif))
+		return 0;
+
+	err = mlxsw_sp_router_port_l3_stats_fetch(rif, &stats);
+	if (err)
+		return err;
+
+	netdev_offload_xstats_report_delta(info->report_delta, &stats);
+	return 0;
+}
+
+struct mlxsw_sp_router_hwstats_notify_work {
+	struct work_struct work;
+	struct net_device *dev;
+};
+
+static void mlxsw_sp_router_hwstats_notify_work(struct work_struct *work)
+{
+	struct mlxsw_sp_router_hwstats_notify_work *hws_work =
+		container_of(work, struct mlxsw_sp_router_hwstats_notify_work,
+			     work);
+
+	rtnl_lock();
+	rtnl_offload_xstats_notify(hws_work->dev);
+	rtnl_unlock();
+	dev_put(hws_work->dev);
+	kfree(hws_work);
+}
+
+static void
+mlxsw_sp_router_hwstats_notify_schedule(struct net_device *dev)
+{
+	struct mlxsw_sp_router_hwstats_notify_work *hws_work;
+
+	/* To collect notification payload, the core ends up sending another
+	 * notifier block message, which would deadlock on the attempt to
+	 * acquire the router lock again. Just postpone the notification until
+	 * later.
+	 */
+
+	hws_work = kzalloc(sizeof(*hws_work), GFP_KERNEL);
+	if (!hws_work)
+		return;
+
+	INIT_WORK(&hws_work->work, mlxsw_sp_router_hwstats_notify_work);
+	dev_hold(dev);
+	hws_work->dev = dev;
+	mlxsw_core_schedule_work(&hws_work->work);
+}
+
 int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif)
 {
 	return rif->dev->ifindex;
@@ -8156,6 +8378,16 @@ const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
 	return rif->dev;
 }
 
+static void mlxsw_sp_rif_push_l3_stats(struct mlxsw_sp_rif *rif)
+{
+	struct rtnl_link_stats64 stats = {};
+
+	if (!mlxsw_sp_router_port_l3_stats_fetch(rif, &stats))
+		netdev_offload_xstats_push_delta(rif->dev,
+						 NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+						 &stats);
+}
+
 static struct mlxsw_sp_rif *
 mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		    const struct mlxsw_sp_rif_params *params,
@@ -8216,10 +8448,19 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 			goto err_mr_rif_add;
 	}
 
-	mlxsw_sp_rif_counters_alloc(rif);
+	if (netdev_offload_xstats_enabled(rif->dev,
+					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
+		err = mlxsw_sp_router_port_l3_stats_enable(rif);
+		if (err)
+			goto err_stats_enable;
+		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
+	} else {
+		mlxsw_sp_rif_counters_alloc(rif);
+	}
 
 	return rif;
 
+err_stats_enable:
 err_mr_rif_add:
 	for (i--; i >= 0; i--)
 		mlxsw_sp_mr_rif_del(vr->mr_table[i], rif);
@@ -8249,7 +8490,15 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	mlxsw_sp_router_rif_gone_sync(mlxsw_sp, rif);
 	vr = &mlxsw_sp->router->vrs[rif->vr_id];
 
-	mlxsw_sp_rif_counters_free(rif);
+	if (netdev_offload_xstats_enabled(rif->dev,
+					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
+		mlxsw_sp_rif_push_l3_stats(rif);
+		mlxsw_sp_router_port_l3_stats_disable(rif);
+		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
+	} else {
+		mlxsw_sp_rif_counters_free(rif);
+	}
+
 	for (i = 0; i < MLXSW_SP_L3_PROTO_MAX; i++)
 		mlxsw_sp_mr_rif_del(vr->mr_table[i], rif);
 	ops->deconfigure(rif);
@@ -9126,6 +9375,35 @@ static int mlxsw_sp_router_port_pre_changeaddr_event(struct mlxsw_sp_rif *rif,
 	return -ENOBUFS;
 }
 
+static int
+mlxsw_sp_router_port_offload_xstats_cmd(struct mlxsw_sp_rif *rif,
+					unsigned long event,
+					struct netdev_notifier_offload_xstats_info *info)
+{
+	switch (info->type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		break;
+	default:
+		return 0;
+	}
+
+	switch (event) {
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+		return mlxsw_sp_router_port_l3_stats_enable(rif);
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+		mlxsw_sp_router_port_l3_stats_disable(rif);
+		return 0;
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+		mlxsw_sp_router_port_l3_stats_report_used(rif, info);
+		return 0;
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		return mlxsw_sp_router_port_l3_stats_report_delta(rif, info);
+	}
+
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
 int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 					 unsigned long event, void *ptr)
 {
@@ -9151,6 +9429,15 @@ int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 	case NETDEV_PRE_CHANGEADDR:
 		err = mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
 		break;
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		err = mlxsw_sp_router_port_offload_xstats_cmd(rif, event, ptr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 
 out:
-- 
2.33.1

