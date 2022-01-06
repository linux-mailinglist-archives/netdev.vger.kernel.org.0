Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CC3486752
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiAFQHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:10 -0500
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:14496
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240846AbiAFQHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAeWoXbHJr9wPyYrS99aDnDRUdeuow9UHXjqIpCXmPFgVEmfY3gHjOMqw7ooN9adK+RMw0BNQVNhGqyxJANAiK8kg/j10qyIuGfsKXxVmO/BrQmJwCQ5Wdq2phUj/LGQQNGRe75WV975xvnnWSDP5L6DM2X+8eSgjmbeBudIYikXURhaQRXjTUgg/eMwXFHlBBN43f9j4cDsgSVhZ+vdZe+rGgFkk6L1h2054nx/fxIU8RLAC81Q3yCFyxiad0fvES0XFLx8NHwBhpHBmzI57Rg/SLzYiwmCwgFVQV4OvsLx0Hi8mAC3J0Lm7i9S02T5wGb+6U2I7YJMYxZLHcY3Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiyhFiHHeSZ29johws5+38XVVfClf1uCKyS/cr3y9uE=;
 b=jp2DzK7tIWqjBUBpmaFPxxACgRupRboD0cxft4kq1arwcRwnepOVQ8vhXnGttANR6SRYVykNkCLUZcUYMeAtteFhTSZFhOgewgnq9dUjWUhqRTy27p1l+PyaUGEaUIYsGcUgXc+xUovDaf4b7ddf4uMxrUOEnp3hhOOTUKsdwO1bjBI0hMovG9hKyzhpFH3mC6rlqLJFkknL8ND2e8OA1l+RVoBGA0YuGRYWkeFJ6xdAc7imxwvEyoidptqIcmm8hWBMKJPWT2K4bVLBAQXUSiJQ/9TQqK4nGjjd9+mwnHcta5ZvVlYbAFL1v4ZXzNULIuJzGm4XqGo6bf2UCyfcgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiyhFiHHeSZ29johws5+38XVVfClf1uCKyS/cr3y9uE=;
 b=Fn/BuukHaF6r+bAI1cMraxw63Fs8yKpN3Msf8CPRy/mAYWIPB/IhZ3HFJNEXNwUepDUCqyFj92HJl9YJJ/GYbrpdRHxWBlkhryzGLgJtK44FBwkpOBStRuYMKrp9krVyyjj0XUgaTVEfxa6j4MXqNVF56NAFXx3TqNnTMuel03Q/eCZ4BE12k17fxSGX8k5GZQbLzorQYunpgUgnXbI92rn22BXHFUfPkYe1a5ZFeyFYIQ7CEjZpIErwEMegsy81HHTleNwOTo5U5c70FJLunaLyQX53FsZF243TnBW0qb8SwUG9CYa/yazoJYx3hcnpYwfXZy1RtPdb7jx1OU/BfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:07 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Add Spectrum-4 support
Date:   Thu,  6 Jan 2022 18:06:44 +0200
Message-Id: <20220106160652.821176-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::21) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 408a5fbd-dbec-410c-e6bf-08d9d12e962b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB405879800C774B1C0E556F68B24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKOu5oYVRlU2px+ktjjU2ydhrJqCQpGz5l3x13sZ+XMU1GKCuEua9kqU4nb8mDId3PE3PlSAz4CaadOWI/IFAHrErUq/MYNL8WgnSCuya+b0Z7f2B7G0x1+YLdTgBfmoVAulqpYfOwh/BhZ/OoYRiQHwD50oioKQD5H22UDwZuPYhXvQvzbQ3dUGngw8ftAlc2cFa8nkgiZrPX/MhM+AF5IEmLlPBAvdfAdsiSlScSM7MROpZWb0pZF4i64kFfeiIQuL2mMQaOSVfaE1nuKME2QtZAzGfl/K8uHVHFfEgCHZnaezXQ2B2dMdFDGIdQ9sAamt2uIp6/KnUIk4UyMQyPF0w2gUlMqK58M83etmov3V/jlburVWtQplYIXEs/LnsBlgP25gq/86LO+acz9K0LipqGfwYDsq8Z/daN9GWP9Ntlvsbkf7agi8CIMKq5NYsPE8LskL/mqtCNoO3KabERzzlFlv64OH3CaQkrguuIBp4zFQHVshdnpw1lc3UJwqXuqn0Lg2yB/MURZv76h+xipUQAmefoiRz+9t2FC0Sbp7xgIxuZZWEDf+3GSvKFhMW4PtDey4C6h9ZiHCAL81n0k1Dxw3mhIbIM4bszoUab+i5Ej3aZgFE6vbvHRHR9RJcswF+p7NwJbDkqCE1d54Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(66574015)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/g/F58l+EZKwGoHZQLmaNAQckX5YN50AChmzy57m/hCaZchjxhI1dIKlkaHd?=
 =?us-ascii?Q?IMVS1VnuLoTRQZqN8QCiVcy1naT/cQJoiP/yvm15J6uijP5wnGUph9UrWkk8?=
 =?us-ascii?Q?Nfbd5giaA7XAt/4s5Omys+tk9Sb/DrXozv0l+WaFIJlv1t2+z70CEZBq75l6?=
 =?us-ascii?Q?CWJv0S4S8FXj+N7VtLgxMb8q5NuzBeVRFgvvCw8vuwrgCXmZGSLqBtIpyiaf?=
 =?us-ascii?Q?05UgI2ih5MoS8G/FYnZ4fNpEUICxYlSdvwwDvSRKfV/gQPlU4TvbBM6AiMpK?=
 =?us-ascii?Q?YtGU1rB7vRhCbBRWKSzcSi9ERVrRA/54cJqA7EzBIQvbHndngfr5k62c06Y0?=
 =?us-ascii?Q?PsPYIcIv1BBtCvUwuCAgvim0dXfHaI4H8HtBk4UCYjFGtHqYz3SbA1MdIoG3?=
 =?us-ascii?Q?MhEKwDw7zNhgzP/tVxMNoNMStW4X2MnByeu36xJxL5oKEK7xBZBntfOmI5br?=
 =?us-ascii?Q?HlU0Q+7SgRdKsy9jL+GbxyASk561giNDOWQtwtB2NC7cnOinc7db6qx0sp/Q?=
 =?us-ascii?Q?eE28fHoztFUDzSO8aBGdRdYMSnjkU7OYjgNmdinzbdbrd7XHt7gwG6QO5dtl?=
 =?us-ascii?Q?kn5s12iAbiZXsB3wPxlP8+RjiUtcMzIlrtp/zsQuc+NdKqRZpHb1ENPQ8+yx?=
 =?us-ascii?Q?KH/Usu1psSueBUesLP4FwrcLpDrM7T/2YL0CIBhj8sOSgLFMbcjKWLgD53NP?=
 =?us-ascii?Q?eeXvf8JoLfyIw+tzbHFIo/pe9Q0bk1QL/XKDqdQcQafMc08poAkn3aZfIodp?=
 =?us-ascii?Q?JyCctLHjCTBhbkjCo8nWfe2BIeur6LYh5Zv7y5e5WM4PCXHtXHZ5n/ZYEvML?=
 =?us-ascii?Q?Es1XNk7YD2RJmmTyCd6cr3rxrbyAnl9SmGCS+iMcdhy87lVa2MS3pkldTPOf?=
 =?us-ascii?Q?jqN+LdeFOUvSrUf2b+tMIIeo4Z3xbbqiHuOFhoe32BZmJQvqzPHb5qbu7XIy?=
 =?us-ascii?Q?RJjsfyRUlFQphkNVFWy1rmM2BfhfUarloCpGiRQFiGa4EiRfURTswBA8T+AB?=
 =?us-ascii?Q?tXVpB/umJt5kXTCEuO87+tVeN+jXcAgClKx0o6+uMtCAFZLd23GEroajn9ky?=
 =?us-ascii?Q?4ty4pziXniodJflVC5KVRbLJSUud5AW7YYN6cgPGJg/B6OHJFu0gYl6U9X8P?=
 =?us-ascii?Q?3pV1WLJIR0cGPMjSvFBNcbrCS+vbHPL9vhpdXtVlu0rInBPWyNSNWhRmH1Bk?=
 =?us-ascii?Q?c+3UdLDD4j+xe5gK9eeUGWYWysObUZff8ipkyvOx7JC+MJ44X1jnxIdAvuw6?=
 =?us-ascii?Q?BjWKmWyGhXOGu4fxpmpQI/m+7mCKH8vhe9sNXOmHKPCwgPdr3GRELhrD9wCu?=
 =?us-ascii?Q?voiMBysDTYlP7LxbhqTGc6YcabTWFV5o+fKNcHOD42KmE0wy/oxdsFv3mj/6?=
 =?us-ascii?Q?eOl2pB6JxBj2KvHt47htfrakn5jsGzBiPJxmTTIFn5t10JUccAnt/D+HQLis?=
 =?us-ascii?Q?QQcir/ovW9w58ysJJDCEnZAZJpw9gj5gWqKuumBMvQ/U4P+lt+hA/Bv+ZRFR?=
 =?us-ascii?Q?xgqyvq4/13zqc0OzKDYM6JCY0HWJQ+/2PdliKwOJ6enAaJldyDmhG1uaAoub?=
 =?us-ascii?Q?dehYTCdIZi2za01hhxL9gOOHPMfIKkbJv+fRXGLyEgQKz3Z+yHuG4gr1uBqD?=
 =?us-ascii?Q?wKPksRUiea7rOPpuhx/d/WQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408a5fbd-dbec-410c-e6bf-08d9d12e962b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:06.9202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjgwLfLCu3GwybtCqIwFZFs/12RxjXR4RL00IK3FpIqdVWjiQoRpxa7hgqTfAjsSlIlDfKp5Kf3dZqeYDsCmSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds Spectrum-4 support in mlxsw. It builds on top of a
previous patchset merged in commit 10184da91666 ("Merge branch
'mlxsw-Spectrum-4-prep'") and makes two additional changes before adding
Spectrum-4 support.

Patchset overview:

Patches #1-#2 add a few Spectrum-4 specific variants of existing ACL
keys. The new variants are needed because the size of certain key
elements (e.g., local port) was increased in Spectrum-4.

Patches #3-#6 are preparations.

Patch #7 implements the Spectrum-4 variant of the Bloom filter hash
function. The Bloom filter is used to optimize ACL lookups by
potentially skipping certain lookups if they are guaranteed not to
match. See additional info in merge commit ae6750e0a5ef ("Merge branch
'mlxsw-spectrum_acl-Add-Bloom-filter-support'").

Patch #8 finally adds Spectrum-4 support.

Amit Cohen (8):
  mlxsw: Rename virtual router flex key element
  mlxsw: Introduce flex key elements for Spectrum-4
  mlxsw: spectrum_acl_bloom_filter: Reorder functions to make the code
    more aesthetic
  mlxsw: spectrum_acl_bloom_filter: Make mlxsw_sp_acl_bf_key_encode()
    more flexible
  mlxsw: spectrum_acl_bloom_filter: Rename Spectrum-2 specific objects
    for future use
  mlxsw: Add operations structure for bloom filter calculation
  mlxsw: spectrum_acl_bloom_filter: Add support for Spectrum-4
    calculation
  mlxsw: spectrum: Extend to support Spectrum-4 ASIC

 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   2 +-
 .../mellanox/mlxsw/core_acl_flex_keys.c       |   4 +-
 .../mellanox/mlxsw/core_acl_flex_keys.h       |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.h     |   1 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  97 +++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   6 +
 .../mellanox/mlxsw/spectrum2_mr_tcam.c        |  12 +-
 .../mlxsw/spectrum_acl_bloom_filter.c         | 351 +++++++++++++++---
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c   |  46 ++-
 .../mellanox/mlxsw/spectrum_acl_tcam.h        |   6 +
 11 files changed, 468 insertions(+), 62 deletions(-)

-- 
2.33.1

