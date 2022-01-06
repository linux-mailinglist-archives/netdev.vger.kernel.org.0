Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8A486755
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbiAFQHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:17 -0500
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:25601
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240966AbiAFQHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6UhvaMm0wdMbXju9GnKFBag80J2cd5eTC6FC18+S74/FTh3vcdktifNZ8GF8L3+nmL1SPvxDSUpUeBUteMhJ+tX3654RA2J+pSdl9Cf6fW2JaNdXFuEL873bDBvGmXL8nK730469JQy0toCwgfDGxWLYRFphAiCTnr49y7QpmsWGlAqsbJYRcySG87Pqpemkjn2T7DmkOD6k84ocGiStLzMG2viuCTN7VBqR7+z01HGq5yEFnl9l4RhiKom8Ky8juTONG+bPcMW0x+NtagJOk5e168HfivfckQTV/v3F2M07tr/9nI5IMtl9fjDKWGWBNdQGbDmw3mSEvspaNm14w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeVJ4b4pt0MTWMLMzrNRvFmCEf87r9E/+4ajucbZW9o=;
 b=LJh4Ktg+oG+l6+qbhcrkauAbgrwzqPd0VCo//YGrwQ+qBEhGaIlGwyj8h5ZIvZ2RaqmAWfwiz6zfoVupKosMVztDtOMQIutuqF6zIbFV5ttKx9R8aLUlxdDFsbo387YEPxnNPZvUu6wOiXrmTjX2bFlIU7toVygs+lz4iXjA49NXRlQUfFGvvBidw/MNNleJlWYJ35BLIbNGtt9FHgV+Y7XMN2XrNHefwd2ZmL9f2K14E1FX9FGlVVGBabj+vW+uK1jPPKJWKFvW79LaoQTBkyiMa7iSO7LAzfTb7yNas3HsMrKfP6fFC/gQLvwfD2O2QGjcOxddx8sgAmqfutFczA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeVJ4b4pt0MTWMLMzrNRvFmCEf87r9E/+4ajucbZW9o=;
 b=l9+l/OszVxGq2ENi/XDeryuMgbFqAbrN/EBagS7Z2O9dkmp5AUdDKQEYl0+OjRI3DetYBKSbf029kYR+MoaaODqIEpnLFpOhzu9pSRWT/Gr7T/SB2WcY76MIVrU96nIv8HBsCrc//aEtkICJfoMd+nL+wHMq6jhfGYMYuX6b7YbJ4PVE5wXRMp0uP41GpXYK9dyZHMpOp6kEU5laRxLq77XAQCLhsxc18JYVPaxz2Sbv9MYmENarnGV9NllMXa2aIogTTyjeSQBZo003fAOZoRZ77jm3GXcTsQIx9IjAfKSpWnJtNyuP2V1cutvVMR9su/iPc77nE5KsnRLNxdWRIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:15 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: Rename virtual router flex key element
Date:   Thu,  6 Jan 2022 18:06:45 +0200
Message-Id: <20220106160652.821176-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::34) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa6829cf-29cc-40c2-caa3-08d9d12e9b5b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB405807C57039A481677C740AB24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFKWn3krzyinIL6PVsUBLMRqiZa1cS39Sp99e2vxr9DAkcYhQ/4UE4LNs2l5zgqmDtXrOKWxpDx5aX5cD8cdDeUr8TbINT+0Ux4IJLh8S6hNz2q5808gL0rQa4yDEjcqRKYpHPQRSPDh93UnKo5Zi8xu08ZPP1PoV4s8Jvcw/QMBd6GZcN99K/Ps9NRhMtfmTWCd88ua5QXgyehChRENFbtsKsG8p1N+w/BF0+BWjmGeWqlizBWJPagHGWyv1ozutvhKioJ+ehWdgf/sWcpB+9ID2OP9HngR6lP5C2RPY65buQLsX+gggmwYOQE8JklNcevvLc/pne6gSQi5eY0c6In/kS6O9yFfD4k1KoQGpsvoT88HXMjOEzafkl9mR4VBwM7TfNHPjGFPYosfqGOqy/SAlD+UJ0YdPybxvWBn2nXbk6QjDql1tqvHY6QR/rVd/l5N/WanUCnemBObyqS8R6KgINcgvieM5jiKRzpyHE6oe60Z4nYj9LIBNdSnHu8DR6SfKgm0WMxQq8YiQV/jAgfVcwkk8WxgpVe1zSlbTMNgFMwZwVmRjodrodawsvvho5Ye9x6dyg85Os6Z+XH8j2PxcFwXodcIItk14cdTCgVljLBX7xFfyyN9a597/sbxxNfIOkXB4SgnZJ/J3jh4IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(66574015)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dmz8t0G2IwSLsUIxveJcfrpVb71X0a7HQCLWGhg/26AdFK9a/mqqLPiROtjk?=
 =?us-ascii?Q?4cjT3ZEnKNyAX78ow+LompbdXhCS33NvlApi0RlzndvvTfG8BAzGSQttZr8k?=
 =?us-ascii?Q?GVqfJVG6KhRW0/hhpjwv9H+woD8sKfqxNyg9ZEawaiOz4Nufuv7xqrQuGkZg?=
 =?us-ascii?Q?M7G27uhOj/2iFm5UW9+QE8YEH2dDoLksbK0KqDk+aE5+hV9sGRxP/3k3QLo5?=
 =?us-ascii?Q?Gpx6lxNpcD1TGKF9p3DNLhCU5N7hZZP0wmj8I22U9J0OfyH9R/OYb5464GMi?=
 =?us-ascii?Q?NFHHzqHszkcbf2z5bjHY4/HZgGSdFvoeXcNkkE50NmwWvElr7nisajxeKEzf?=
 =?us-ascii?Q?i7Sz0zFQ5GFTV0ijmknnUKDKethGgIHWjWDLKSnKSFQb+tIuAkYwntOve5Aj?=
 =?us-ascii?Q?AXkJJPd6JRsXC40o1Rhvc4O2eiTsl+qJItRQBbUTOWLUYA3Vecuyit3MGwZf?=
 =?us-ascii?Q?28ZKe5NZ9T4JlRsfCGnOhzjpkUOE07VSR3c9iCKoG/9iGcMfethLQP0kOtMa?=
 =?us-ascii?Q?55uhlPtN7e3cp1zdAxCY3si6tEpd7c0j9Yh+YPIEKUYcLzGcmPcLvEjzfhdl?=
 =?us-ascii?Q?5rvn8wsFi73rEYSLs4zM+b89O2EUWJCmpoehMVGxWGr7MjUSuJkuFXl9GAdH?=
 =?us-ascii?Q?gD0eYJhffHtriKgvqVc6Wc1ILF1u5vnMYnBzFIzoxsbaQPSoF3SZU00hUrFA?=
 =?us-ascii?Q?6WhYL+fiu+9wiNYkY2QRUJO5YaY1xwBAjL0g7ZlAFHZOzYDAJEbv9B91wKb/?=
 =?us-ascii?Q?5FSjhjYNQ7H3TRlLWjXHOpoPoVoLb3mgUCWgCCDVzHMWrKiPO9f7zrc/2Thf?=
 =?us-ascii?Q?WE2KXgoJj8BsNllfcygvTi+W8FxtG8LpKmwEYkOcGlmrdyyGGIYtyVmrO9mI?=
 =?us-ascii?Q?k5NzuSpEno9aEAtFBI0kykNISpIZjs/OrOe1yfhVkd3+/uX9hcte/S+bFDjH?=
 =?us-ascii?Q?cyAbgufZVvXEu2mR9TAIEYQJytjgZBK7/TPoPuw3Tbd5ADSH4jszPr1l3m8X?=
 =?us-ascii?Q?pCkzziJzmhXiWsQUSgXnQEalo49onfUwJyjXxLjOpla+W2CfF+5FB2aOR+p2?=
 =?us-ascii?Q?3NO2wH2VZ98MiUUzxmx9DZ2wUpt+UgET+irTJIZbTjK1IIZEwW4MAZM/Vjmz?=
 =?us-ascii?Q?RntJungF7NG97Bji0x+7AXFomWezWv7ZyGKtYsdU7uTHWPJWVlq1jx/BkKDd?=
 =?us-ascii?Q?8vUR4l7Wkc0BdgQhg9DaeCMLDg7w4/XkqmMR3LqVLAgTQPgTCgWgZYoP2pyw?=
 =?us-ascii?Q?60M49sFuTfO+0WIFrCmxnxRCH/S3U2OQzLj41ht9EXbukrHF2RkjT68VgKEd?=
 =?us-ascii?Q?g3M40v8ZpkeIORbFZhsSbKs5o8oQx+VBQQembogJRRCWP3+47BxreIwu52ds?=
 =?us-ascii?Q?WhGh1KIRVwMloHq0jPOqHjacSnQMH0NxH4GCqp4Cuhn/pmz1qQRUJRuzaYVj?=
 =?us-ascii?Q?0UaT1AUIYqOOYCOdUIIGEnhpIex665vCEh9uDL44JGmYOBkwrtFfDG+gQl2S?=
 =?us-ascii?Q?IvfPzjJAM2/Suseckv3ykq4ZLT8/9KZQ73DXEC9chuVqn+qJSsrrIexQv40U?=
 =?us-ascii?Q?+Lss8CEhNZYMBxnPRB4o0TozLbNeKHKhmBf0Yyr54yg3rXde/t4GwmB1AvHV?=
 =?us-ascii?Q?WV6SSbvLyEwtmllBrNmJU9o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa6829cf-29cc-40c2-caa3-08d9d12e9b5b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:15.5601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9UNE2QkuVLH6QXJfJji1AavEonjVJlutMcTy0ZL5OoJ8H1sEXlCp6VCA1pvFkQJgOfEVXPEcNDHrbN3bO4Qyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In Spectrum-4, the size of the virtual router ACL key element increased
from 11 bits to 12 bits.

In order to reuse the existing virtual router ACL key element
enumerators for Spectrum-4, rename 'VIRT_ROUTER_8_10' and
'VIRT_ROUTER_0_7' to 'VIRT_ROUTER_MSB' and 'VIRT_ROUTER_LSB',
respectively.

No functional changes intended.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c |  4 ++--
 .../net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h |  4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c  | 12 ++++++------
 .../ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
index f1b09c2f9eda..bd1a51a0a540 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c
@@ -32,8 +32,8 @@ static const struct mlxsw_afk_element_info mlxsw_afk_element_infos[] = {
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_TTL_, 0x18, 0, 8),
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_ECN, 0x18, 9, 2),
 	MLXSW_AFK_ELEMENT_INFO_U32(IP_DSCP, 0x18, 11, 6),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_8_10, 0x18, 17, 3),
-	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_0_7, 0x18, 20, 8),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_MSB, 0x18, 17, 3),
+	MLXSW_AFK_ELEMENT_INFO_U32(VIRT_ROUTER_LSB, 0x18, 20, 8),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_96_127, 0x20, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_64_95, 0x24, 4),
 	MLXSW_AFK_ELEMENT_INFO_BUF(SRC_IP_32_63, 0x28, 4),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
index a47a17c04c62..3a037fe47211 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h
@@ -33,8 +33,8 @@ enum mlxsw_afk_element {
 	MLXSW_AFK_ELEMENT_IP_TTL_,
 	MLXSW_AFK_ELEMENT_IP_ECN,
 	MLXSW_AFK_ELEMENT_IP_DSCP,
-	MLXSW_AFK_ELEMENT_VIRT_ROUTER_8_10,
-	MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_7,
+	MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
+	MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
 	MLXSW_AFK_ELEMENT_MAX,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
index a11d911302f1..e4f4cded2b6f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c
@@ -45,8 +45,8 @@ static int mlxsw_sp2_mr_tcam_bind_group(struct mlxsw_sp *mlxsw_sp,
 }
 
 static const enum mlxsw_afk_element mlxsw_sp2_mr_tcam_usage_ipv4[] = {
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_8_10,
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_7,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
 		MLXSW_AFK_ELEMENT_SRC_IP_0_31,
 		MLXSW_AFK_ELEMENT_DST_IP_0_31,
 };
@@ -89,8 +89,8 @@ static void mlxsw_sp2_mr_tcam_ipv4_fini(struct mlxsw_sp2_mr_tcam *mr_tcam)
 }
 
 static const enum mlxsw_afk_element mlxsw_sp2_mr_tcam_usage_ipv6[] = {
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_8_10,
-		MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_7,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
+		MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
 		MLXSW_AFK_ELEMENT_SRC_IP_96_127,
 		MLXSW_AFK_ELEMENT_SRC_IP_64_95,
 		MLXSW_AFK_ELEMENT_SRC_IP_32_63,
@@ -189,10 +189,10 @@ mlxsw_sp2_mr_tcam_rule_parse(struct mlxsw_sp_acl_rule *rule,
 
 	rulei = mlxsw_sp_acl_rule_rulei(rule);
 	rulei->priority = priority;
-	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER_0_7,
+	mlxsw_sp_acl_rulei_keymask_u32(rulei, MLXSW_AFK_ELEMENT_VIRT_ROUTER_LSB,
 				       key->vrid, GENMASK(7, 0));
 	mlxsw_sp_acl_rulei_keymask_u32(rulei,
-				       MLXSW_AFK_ELEMENT_VIRT_ROUTER_8_10,
+				       MLXSW_AFK_ELEMENT_VIRT_ROUTER_MSB,
 				       key->vrid >> 8, GENMASK(2, 0));
 	switch (key->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
index 279c241f76f0..fa66316234c4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c
@@ -168,8 +168,8 @@ static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_2[] = {
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv4_4[] = {
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_0_7, 0x04, 24, 8),
-	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_8_10, 0x00, 0, 3),
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_LSB, 0x04, 24, 8),
+	MLXSW_AFK_ELEMENT_INST_U32(VIRT_ROUTER_MSB, 0x00, 0, 3),
 };
 
 static struct mlxsw_afk_element_inst mlxsw_sp_afk_element_info_ipv6_0[] = {
-- 
2.33.1

