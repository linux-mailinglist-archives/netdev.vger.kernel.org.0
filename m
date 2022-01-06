Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE9848675D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbiAFQIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:08:02 -0500
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:24607
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240990AbiAFQIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:08:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTPUKG6O8sQHQhqzB5TKLCPMmqNCTGqZINfcD/d8lpwKpUh2XiLISWouuxl0dXsNbji2DRH/6wrJm7thMMt5WtpSEi5MaVNDSbn9Zqpq5ZHUN8FLxmo+OQsFx+YZXq8PEbQmzyroDRKRvoPCL+vAxXzj2yhfA16ez7yr6Pah1zErqgeAwqrsQahnK65pj3HIdGz9bNdXELk1kTW36l/x45bO+MpZmO2WQZEDz6MCTjg1w3Qg4gZRxMkmHY3qTxb7BK4bN+MszCIY9sl25XZE38HcTObLTy6B3xhPtn7gcna9Avd4l7eRvzYaiANdSljrBJ9qIibnPbtQDjT3px9FIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xTZWZp0gEhnons8tdSm8elF8yhVaWYK7athGArN8Lw=;
 b=iOi6a7ux45Ck+eUv3b5G9b4HO3wX++9/0CqOue0QdjanoNfPiu5ftzofd4VwZbOYPiS/d7m9DD8+A6xl0mJUFjrPZsqBcx4Y2B250LkuBZbt7N/HiKQxpUNy/Ndzf2sRJ6LBnPeQe9NPWQW2aFlSoFMLeSwB30GbigE7dX9QJuwhbtXkQ+2XF0lEnjdsLbdXaKSqej+LMGL+L12swr6KsvQxFnhisHUKvNKYd1g1EZ+4KqDLFEolf0i49xHoiF12y3awk9YIGc4KSW2Dgfe3+opTllyd33tL0wQEYUSqDAUrNzpfCe4LuewTLEzPfyuKQ7CCZpJRepnXQGAOGYMgnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xTZWZp0gEhnons8tdSm8elF8yhVaWYK7athGArN8Lw=;
 b=JXtMjMzz/wfqqJ7LYC3G9M4eIbDuzZL+RhpLio7SlSMhFb9CFmrSgkihH+kqG3+3NHG2R4hpbLaxLiXfMHWyX2TIRkBIvmOoB1YLqiLC2cLPSyF8Vxlt1h6zSJiG+Fdb+KzijkEQIqC5dreXq0pRAQmaxgiDyL4J9Mt61w8CsJt+tNmrVAnzT8f5Cv5b5qdn8/FIMzls50HrKEGvbu1v2DQUK9mm3uKTVkBbj4w5DaQ0DMKtjPzbdRlN+nBvv+1BO5/Y77v6hYzaoVfL8MzaS5WW3VZc6rN6V/U84Pkss59QTrgvx4Cv8zQiAcpjK2dbDLSRoxGziNVdCXKS4meDHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:59 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:59 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: spectrum: Extend to support Spectrum-4 ASIC
Date:   Thu,  6 Jan 2022 18:06:52 +0200
Message-Id: <20220106160652.821176-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0058.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::18) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a48490e8-dd42-4ef9-87e2-08d9d12eb597
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058C3748CD44F3285B3B6E4B24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2TKvPoJ7p/A+oWZqpADqNH9G3kmQbz38XISb4JeK0q9YNGjPPj6PlVf3wE6z7qYrle4YYdLGT0crqlqNTigAY+fS3xJh2re559ANl/u0LI8ZiI8BXVWOqmDfGxYcCXV84haLjfYS5ikPtlcTw2uWgXxoyQFyfKX/ohYohsfC3yVwpoIo1cOaGnAnjQ6fiR4xOoHoDQ4C99WiJdflPYlSNZFI1QEWmDXDOxd94rtAHNtDWxsq9mTR0azw8dg/BxIUCkz2fDKCKVKLrde904knDVWWH0Afuvm7tqeF1BArPhF6bY2YmdjcsZMHJJ+N2f3PaID8lep8urDxoJ25SCfPYiqxtsuQXe1SNpvwcwNJV90k0/w02ACPi80/jiMInq9ZDmxjR5f3dUaQ6GdaBGWZk1kvdALXKcNYGqUx6Mauo0OsZXftKoCEJ+rAJBkmjui0HGk1D88f9B6qxbRcKLtQdJRplaz1UcXTx9yJeRO352hJaQWUWSr8fTod3J+cMlBprWpALYIIN0AOxwOkJairx3+UU5RVsZgUMg5+q+AyOhd5EKLURG8S/gcHD4uMJbE1WcZ+NitC0iP3coRMTvi6lak3RPj9gGONlCyIfCNTZjpDuPSIbY154RkibnVr8wbBLLmZVWFmyQNGWhl4thS2OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(66574015)(4326008)(26005)(38100700002)(8676002)(19627235002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+0vjLCMPI5LC6B7FUm6/KOOG9O3foPC2E1mf12le7i3GeVctn9keVnvz6J1/?=
 =?us-ascii?Q?EkqRJhuTz7RXJ7tzGugAB2HlaFUJvt8y8fANA3gDU1pnzRyC4dwTl0+i5Vjk?=
 =?us-ascii?Q?AMFrOf3hcsAs7EBM+0XYBJS0E0bP3o9KKVXMLTDBt7wdAMCTKNRRSz0NCD3S?=
 =?us-ascii?Q?9HargrRr9LZQNxd6kQZJHOm5eZqkGnaEpVbnIjGatUEMfUEDDvd5QzE2kKpW?=
 =?us-ascii?Q?r5jtoyFo35+Mp3HoeKnU45XUo9gclyQbT4l0cRG/ah5EZzCo5zDAolehgqNR?=
 =?us-ascii?Q?Y5JYHh8Uu9PbtE3R+LKjazi6a1woNVU01vWZW563X46TfkidRjPzeCpiQ6/C?=
 =?us-ascii?Q?jsB9XimSE748CcS26FuXkjSQujKwTDFuJ5Oa6aPqHHhMk4XbK2Un0wCwqi+y?=
 =?us-ascii?Q?LyVj/a60riHlxcB44Vaeft/NojJd4ozZB9b2TgGYQg/O8AXoHUZpgQ/F/1YC?=
 =?us-ascii?Q?yauOVt3dFoc+Iy4wvwOldVgoT5a/XFY4zd2OZuE0zvwuj9CQzJ3RN6eS/LIX?=
 =?us-ascii?Q?1OIWpUnNBRbsl60hMjqTV1OoJkF6HMflbh6cB2lx4/+goAyYSNGy03YU05mO?=
 =?us-ascii?Q?65M84Fkk9zV8G5bYDxfiboUSAydHanqljhJYfx8Mh/DJNMHf1s47vNVo5n7+?=
 =?us-ascii?Q?Q7NoVzMN1Hb25QeELkMRQ8XVtvgu+USNyNMuDmj7rKJt1dS8JhfZAVe4EZB4?=
 =?us-ascii?Q?DcMHeQXpsQ35k5BziyCiqWRZAGG0ckBtkj45YtMzbYhHFQf2zMVDHznwZEcR?=
 =?us-ascii?Q?znAb4NpLWLupQCryAA/a/z1PT8ouSDkmp5yEINonHOHeZ2QpJRCrQGsVJqlj?=
 =?us-ascii?Q?Ar0QdsJSeETrgR7K1C8br4GVTrE+vxalbS2Q7+BhMal5sQotObSY7RFfVDbB?=
 =?us-ascii?Q?TBtRIYxIe7/PVOszA26LdxCN8SyFgyHm3b51tvfabOB5QY//QmrB8frL73uP?=
 =?us-ascii?Q?TE+em5s4f7/1vBfYgDv1vYQRivrltl5i+5puAyNLzzkeEJ0YLsBoeM1RAP9c?=
 =?us-ascii?Q?PTHQJEbwAnKjLAQdbmL7/86kuPZbVvGXv79k5uZyMJLlg6PfRrPbkVYuGegs?=
 =?us-ascii?Q?GiT0jlvOeunAnZZwE3dlhrrpknCS4FfrFfOrr0F4l9I7wNwH0mS6kwLBr2kF?=
 =?us-ascii?Q?xoxMX7u8w1J4RoDwt8GBHkPV6aoS3AHWV1Oa7burGdIrtJSqfDqP6aixriII?=
 =?us-ascii?Q?m4ds7fsmSsRJUW16ps5QGjcbglUQ3QszpZdICft9eNhYBxljfqp04BDdTOp8?=
 =?us-ascii?Q?9H1lKpcPHRlxZc/s16kYE4qVlrhpT1asIwlgQ3nf+EF74W3/2mLjiQLrknbT?=
 =?us-ascii?Q?TfMeJwrQsmxbs3Uk8PXg2PZzKNuEt5sqz33fyITtsTXnXjiTJkqGpAGSG1s6?=
 =?us-ascii?Q?bMKGPIqDIO0I9pDuqUH33dwO6y2pSNrUc7uNkxHUfWnTnev184d4mKOZK/Ma?=
 =?us-ascii?Q?TF7XdlGgLiw7GcXI352MHCaiRdxQMtaExJP13FfIrxMy70StC9vgPK6GYqs+?=
 =?us-ascii?Q?VRKSApLX8SGDNSI/Iywm/yJS47WAb4G0hsGHCCk9dyTgmOu4bNz5IM9mh9aP?=
 =?us-ascii?Q?ewfIsr8XRAHsVwjfdtkHSg4ZiMPcksKmwoQn0dVAQxSuGpfb/K9Q8MRsUO5A?=
 =?us-ascii?Q?4bd7fDvApKYAwk9ddvrIRDs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a48490e8-dd42-4ef9-87e2-08d9d12eb597
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:59.6974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d8xtrTbx5XvjlPu8SAXUxCaa3hiTN8YPyWdu3wP1RkoDtMvyIilNeCzvhUTGJy5PtkhGxdk6j56UwkVyG0DmZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Extend existing driver for Spectrum, Spectrum-2 and Spectrum-3 ASICs
to support Spectrum-4 ASIC as well.

Currently there is no released firmware version for Spectrum-4, so the
driver is not enforcing a minimum version.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.h     |  1 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 95 +++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index d1ae248e125c..4683312861ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -66,7 +66,7 @@ config MLXSW_SPECTRUM
 	default m
 	help
 	  This driver supports Mellanox Technologies
-	  Spectrum/Spectrum-2/Spectrum-3 Ethernet Switch ASICs.
+	  Spectrum/Spectrum-2/Spectrum-3/Spectrum-4 Ethernet Switch ASICs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called mlxsw_spectrum.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.h b/drivers/net/ethernet/mellanox/mlxsw/pci.h
index 9899c1a2ea8f..cacc2f9fa1d4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.h
@@ -9,6 +9,7 @@
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM		0xcb84
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM2	0xcf6c
 #define PCI_DEVICE_ID_MELLANOX_SPECTRUM3	0xcf70
+#define PCI_DEVICE_ID_MELLANOX_SPECTRUM4	0xcf80
 
 #if IS_ENABLED(CONFIG_MLXSW_PCI)
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index c97d2c744725..24cc65018b41 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3914,6 +3914,7 @@ MLXSW_ITEM32(reg, qeec, max_shaper_bs, 0x1C, 0, 6);
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1	5
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2	11
 #define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3	11
+#define MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP4	11
 
 static inline void mlxsw_reg_qeec_pack(char *payload, u16 local_port,
 				       enum mlxsw_reg_qeec_hr hr, u8 index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6e4265c86eb8..aa411dec62f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -95,6 +95,7 @@ static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
 static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
+static const char mlxsw_sp4_driver_name[] = "mlxsw_spectrum4";
 
 static const unsigned char mlxsw_sp1_mac_mask[ETH_ALEN] = {
 	0xff, 0xff, 0xff, 0xff, 0xfc, 0x00
@@ -3202,6 +3203,36 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
 
+static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
+			  const struct mlxsw_bus_info *mlxsw_bus_info,
+			  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+
+	mlxsw_sp->switchdev_ops = &mlxsw_sp2_switchdev_ops;
+	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
+	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
+	mlxsw_sp->afk_ops = &mlxsw_sp4_afk_ops;
+	mlxsw_sp->mr_tcam_ops = &mlxsw_sp2_mr_tcam_ops;
+	mlxsw_sp->acl_rulei_ops = &mlxsw_sp2_acl_rulei_ops;
+	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
+	mlxsw_sp->acl_bf_ops = &mlxsw_sp4_acl_bf_ops;
+	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
+	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
+	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
+	mlxsw_sp->sb_ops = &mlxsw_sp3_sb_ops;
+	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
+	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
+	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
+	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
+	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
+	mlxsw_sp->mall_ops = &mlxsw_sp2_mall_ops;
+	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
+	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP4;
+
+	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
+}
+
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
@@ -3761,6 +3792,45 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.temp_warn_enabled		= true,
 };
 
+static struct mlxsw_driver mlxsw_sp4_driver = {
+	.kind				= mlxsw_sp4_driver_name,
+	.priv_size			= sizeof(struct mlxsw_sp),
+	.init				= mlxsw_sp4_init,
+	.fini				= mlxsw_sp_fini,
+	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
+	.port_split			= mlxsw_sp_port_split,
+	.port_unsplit			= mlxsw_sp_port_unsplit,
+	.sb_pool_get			= mlxsw_sp_sb_pool_get,
+	.sb_pool_set			= mlxsw_sp_sb_pool_set,
+	.sb_port_pool_get		= mlxsw_sp_sb_port_pool_get,
+	.sb_port_pool_set		= mlxsw_sp_sb_port_pool_set,
+	.sb_tc_pool_bind_get		= mlxsw_sp_sb_tc_pool_bind_get,
+	.sb_tc_pool_bind_set		= mlxsw_sp_sb_tc_pool_bind_set,
+	.sb_occ_snapshot		= mlxsw_sp_sb_occ_snapshot,
+	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
+	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
+	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
+	.trap_init			= mlxsw_sp_trap_init,
+	.trap_fini			= mlxsw_sp_trap_fini,
+	.trap_action_set		= mlxsw_sp_trap_action_set,
+	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_group_set			= mlxsw_sp_trap_group_set,
+	.trap_policer_init		= mlxsw_sp_trap_policer_init,
+	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
+	.trap_policer_set		= mlxsw_sp_trap_policer_set,
+	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
+	.txhdr_construct		= mlxsw_sp_txhdr_construct,
+	.resources_register		= mlxsw_sp2_resources_register,
+	.params_register		= mlxsw_sp2_params_register,
+	.params_unregister		= mlxsw_sp2_params_unregister,
+	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
+	.txhdr_len			= MLXSW_TXHDR_LEN,
+	.profile			= &mlxsw_sp2_config_profile,
+	.res_query_enabled		= true,
+	.fw_fatal_enabled		= true,
+	.temp_warn_enabled		= true,
+};
+
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &mlxsw_sp_port_netdev_ops;
@@ -4928,6 +4998,16 @@ static struct pci_driver mlxsw_sp3_pci_driver = {
 	.id_table = mlxsw_sp3_pci_id_table,
 };
 
+static const struct pci_device_id mlxsw_sp4_pci_id_table[] = {
+	{PCI_VDEVICE(MELLANOX, PCI_DEVICE_ID_MELLANOX_SPECTRUM4), 0},
+	{0, },
+};
+
+static struct pci_driver mlxsw_sp4_pci_driver = {
+	.name = mlxsw_sp4_driver_name,
+	.id_table = mlxsw_sp4_pci_id_table,
+};
+
 static int __init mlxsw_sp_module_init(void)
 {
 	int err;
@@ -4947,6 +5027,10 @@ static int __init mlxsw_sp_module_init(void)
 	if (err)
 		goto err_sp3_core_driver_register;
 
+	err = mlxsw_core_driver_register(&mlxsw_sp4_driver);
+	if (err)
+		goto err_sp4_core_driver_register;
+
 	err = mlxsw_pci_driver_register(&mlxsw_sp1_pci_driver);
 	if (err)
 		goto err_sp1_pci_driver_register;
@@ -4959,13 +5043,21 @@ static int __init mlxsw_sp_module_init(void)
 	if (err)
 		goto err_sp3_pci_driver_register;
 
+	err = mlxsw_pci_driver_register(&mlxsw_sp4_pci_driver);
+	if (err)
+		goto err_sp4_pci_driver_register;
+
 	return 0;
 
+err_sp4_pci_driver_register:
+	mlxsw_pci_driver_unregister(&mlxsw_sp3_pci_driver);
 err_sp3_pci_driver_register:
 	mlxsw_pci_driver_unregister(&mlxsw_sp2_pci_driver);
 err_sp2_pci_driver_register:
 	mlxsw_pci_driver_unregister(&mlxsw_sp1_pci_driver);
 err_sp1_pci_driver_register:
+	mlxsw_core_driver_unregister(&mlxsw_sp4_driver);
+err_sp4_core_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp3_driver);
 err_sp3_core_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
@@ -4979,9 +5071,11 @@ static int __init mlxsw_sp_module_init(void)
 
 static void __exit mlxsw_sp_module_exit(void)
 {
+	mlxsw_pci_driver_unregister(&mlxsw_sp4_pci_driver);
 	mlxsw_pci_driver_unregister(&mlxsw_sp3_pci_driver);
 	mlxsw_pci_driver_unregister(&mlxsw_sp2_pci_driver);
 	mlxsw_pci_driver_unregister(&mlxsw_sp1_pci_driver);
+	mlxsw_core_driver_unregister(&mlxsw_sp4_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp3_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp2_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sp1_driver);
@@ -4998,6 +5092,7 @@ MODULE_DESCRIPTION("Mellanox Spectrum driver");
 MODULE_DEVICE_TABLE(pci, mlxsw_sp1_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp2_pci_id_table);
 MODULE_DEVICE_TABLE(pci, mlxsw_sp3_pci_id_table);
+MODULE_DEVICE_TABLE(pci, mlxsw_sp4_pci_id_table);
 MODULE_FIRMWARE(MLXSW_SP1_FW_FILENAME);
 MODULE_FIRMWARE(MLXSW_SP2_FW_FILENAME);
 MODULE_FIRMWARE(MLXSW_SP3_FW_FILENAME);
-- 
2.33.1

