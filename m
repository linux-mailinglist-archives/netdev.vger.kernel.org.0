Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE94E4744D5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhLNO0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:11 -0500
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:6881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229731AbhLNO0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MK8+V3HL6m2g5Ieo0XfcEp+U5IX6HVMaVpXsO8GOBrPXwZQfWkXTA2YwjNH1mVsdiIBfr9E6WWAiutWD3clSMD0SfK9IngrW9D1uy78bpU5y/NncY4TGgX704dHmB9PROqC6wyztKn/Sky/HL/jpy/RZsYAOmXGUaOY5uyXJrJ8sj3onWkTLrLCPyKattlkppyOS0PkG35b8T4sOfQIVri+HmAXOfYVpw+7GWhN4h16HpD761DDOMbBXLWiJn2N6E0eDnGf/gj73QFarLhjf9fk+IMOaRf/yFaZpI7J1nxV3uqgiXZt5jNsDsyXRm2vViONiTuQukOeubdzaqJdIHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkNfD+MEhhKo5q/2vhm5SjzT6/aSxR5JsPBDCjyauyM=;
 b=TiPKufuZ9MMBqwRdrUA5ArJBsTCi2Wxbfm36bsnAheQxAjJFwr9kyryuW7W2NiF6jnV8GZkwul5kxfzaTsHAvijPXptfbmTy0r+3GQJDcRs1e4YM6f8FEXpcaRaDlqCji7RiJaehHqT1cmnvb0B76ztz0YHvtBrW1TRVjuFSUvKNve1P7vr3DVP5/ITiMrYOaWOt4z1Bid9rBt4Qqes2mDRt/mfO3EHt+p3Ob5yQ6ZFBEOZjYCsRvl8+TtOwv9PD58cM+E5IuyUU1z7hTMdMFj0EB+0Hme7pXziDL3V5TkAt4FInPE9FqR+MEUeV+ULiPXLLhiAXy/PUIRnjHAtP4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkNfD+MEhhKo5q/2vhm5SjzT6/aSxR5JsPBDCjyauyM=;
 b=AzadCcixzG/StfR4Lq5OghycCh0cBLzDWhrO9s7bDHYMuI4J4zOpcNC4EV3x8atuG4Q8znOakkaWZtSR++jS/L4v80tnv3n3f35Ki2nSwskxLL0CI96ut9d20kU+Jtbc9HoTcXbjeT/+k1mTMn6bFqZbWLyVnrGM/Lw65zDuw8Jb8QTbJtyaHnvCtAoFOFtdQ56LWvXwid9vq73zJ+uYy5IVgZz3dpXB/cZn8SAJXc9W1zCvH5kcT9ijxptCUkjbtAXJFpkoCDHhDis/pE5ivrn14yOHLpiDvQlx1Nwx5eqThTgaIn46tk8umuLjd4/i12vRVpjxssl7ypLMHAijbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BY5PR12MB3955.namprd12.prod.outlook.com (2603:10b6:a03:1a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 14:26:09 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Add support for VxLAN with IPv6 underlay
Date:   Tue, 14 Dec 2021 16:25:43 +0200
Message-Id: <20211214142551.606542-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0069.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::15) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR1P264CA0069.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e27a08-9185-498e-4785-08d9bf0dabcf
X-MS-TrafficTypeDiagnostic: BY5PR12MB3955:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB39552E0D57EA25FAB224D484B2759@BY5PR12MB3955.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JX5UVrW74vj9PrnzXwVaKjUBOBwkHaUSrcRedpqE5XgAuzoJD9AMAtoeZKCVQOLvpUY2KJLH9gNE9p9s4IOt5b+fuHhfff9+mIGgBEfNHUfKiwQc7fMWWTLIwp3FxoI6l4XeUg6/I/AZz/3m4WyOFVV08m2Ia6Kuxgy+mV/Bbd+ZKicM4WkpLF7ETk+QlZ9HGwtKwqvERvQTpiCF99athMDoFuPA6RYFe4lnE2sWTDwaHyGkMK1/2Eb5Zk5madh73ltFEoVSgufoOTUdguZBqxsmzwkHF8AQky9EHhu8mImb0zLMnvsTvZkqGooo6bammF2pkz16L5rm8N5mMbHotcScldYcrqfHNL7Ul4sMA/Ok2QIJHsZzNP98mRlJop9waj61LVzJGt+IszzIp6NtNAzcSc7ClT3wsYdF1NiJjYrEqHKOWFyxmqQjEVh0jiUyeUw0JiK2WX9r4+M1xWnRrrAryGx+Uv5VdluWDCxU1cEtYAsqrt2d4gSvlkMGlzxCF3lb9EgBc5XM1Y9F9cb9yjyJhFUiAhJGM2+wggvYSfZ6VCP5pnp8oDQ2VEXONK0vI/0y1ztQ6ubeNXewBxZe2G9frzc4o+rRCAINPjBBFlvl2nPLru2IDaxsZ9Xp8cwmmuwNKp0Z6/1my55uIiGp/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6666004)(6486002)(6496006)(508600001)(2906002)(6916009)(186003)(86362001)(5660300002)(66556008)(4326008)(316002)(38100700002)(8676002)(66946007)(107886003)(66574015)(8936002)(83380400001)(66476007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/CpuC5D7/E8DIm+7OmQOZaHOyZYHHdE/VoA+h+4By+Ugf2srib7esSdQ2JJ?=
 =?us-ascii?Q?LMRjTm5MGILwk3GFbPKZV7gznvnQecIxp0EUDj/XMQcPaDUZpmFAa9VDpg/y?=
 =?us-ascii?Q?M7eNAYCUTc9AfYaYbfGKjBKPZ93e9NH0bcBI70XF+Ebk6lsXYIz6KfqHZ3LT?=
 =?us-ascii?Q?9jWmMeEp3JcTiNrUrPdCrZrA2PB9EKYN2+4w4APmxgVSfU3b7t5mp/nSNFAg?=
 =?us-ascii?Q?LTVjLV9Srya182kRMmL/73Xtj1LDJb9X5zfVdiky2hit4yXAmaGFAocpcVtC?=
 =?us-ascii?Q?DI0SsHis1H+7vQ0Ibmo+af9yWYPWqGXQBlNsflIu/RPTVIFn6T8iGEPwuLKz?=
 =?us-ascii?Q?3eAveV81xk+EyBLxxEUrOdGwfXsMEeH/iKKwcZ4bi1wJadVl/G7as0l/T1xf?=
 =?us-ascii?Q?Fr0B2pRwhjIO3BmV1zrhB/cqb/CcPFww00zuNB3gbjRDdWrBIOgQi5e3Mja/?=
 =?us-ascii?Q?6Lb231llj17tlUPnnDxSrQNLHiLM8JYUqjeV1lHl4pW7P+c++V0m3En7CGUY?=
 =?us-ascii?Q?ZE+zQB/SgDEazD8l93LSkFGwfhFZ232+JX8ukmNaVHbtSOvZGwANa4sB4/0Z?=
 =?us-ascii?Q?Kh5W3Ht9WpNav5hzjMP1BdunCDJZ7yCjuCL7VsuAVzELSIF1jbd4M3N0UXGs?=
 =?us-ascii?Q?Hesr3fr5OJNxsqLU7XRvk4YSmx9PBjOAMk3uLbnoTRDfctVgnr51Ph2OBVxx?=
 =?us-ascii?Q?CuhDwxSeEldJa5emKOahijm8760QN7O6LwE/MCT8beUElhtukUm9v8tNbRcc?=
 =?us-ascii?Q?5gKcAr8DzBEL73TRKK7zJ0zlnX/nRroO1dz6MHFP55C7RVC5GCEWegWYdP96?=
 =?us-ascii?Q?RDKmJfRhE5nS+WB8BI7DmiZ7Ijk9el1LoulFE4BGXdeIgEQGC8q6h//D6RXi?=
 =?us-ascii?Q?AsLqwBxEZQBKQj4NLXCWwDrCx/G8aHJbLpckMC+bfSGX9vzoxywwDagE6Zkr?=
 =?us-ascii?Q?xetpll2dUGzXJ5o6fsXWj36bMMnkiNQUeUDMpfEMeE4+mEzD2kbdcpVaiQ92?=
 =?us-ascii?Q?AxnCNTxfzqO2coXA3eCCK64mmII30AL+TOaaq1RNmo+MNBUyHEdhWAChisFK?=
 =?us-ascii?Q?frF2dXTwosnK8hsocQ5z9op87g7T2sAblFs107SSXmzKwhsAoButvluQASP+?=
 =?us-ascii?Q?zm/dOiNrHhR7gZ8iU1s0UVWDaNH0bzxr3L2qT4ss0Ub+5F8m63npl0KJ/chu?=
 =?us-ascii?Q?uhObTIF7wkzosd1/rGcXrUrAAHxB92FY4ISdEB+TqeUjjIdFS7Yxz9EMPlpB?=
 =?us-ascii?Q?CbWlZtxid6fCaLsUjLGsLZV4Q9r1FR1Mn6bh7umrkYzGF6VF3z5ae5RTY5ah?=
 =?us-ascii?Q?tbgcyDxV+27a5MSlC13QZGd/1Yy4ZRuY0Rz0khf0f/4R94Nz+pzIGDNEqjbm?=
 =?us-ascii?Q?l24fb+xNOnP7Ik0V4U+wXY5TNa4XMrvDGKyDTCGICeQHGoCN0HBTk/+c89aa?=
 =?us-ascii?Q?8G4x/ujCjGjxreVUYsOBwZ7T/g3p//Jw6FOx58DWCFW62VXRItdmpyMTAGM9?=
 =?us-ascii?Q?s6P3P+ECkgiZy6WS7d9o2Kbg/MoMzkRStUn6PqPiqPcbjgb6/2EzPkDLSR03?=
 =?us-ascii?Q?yVtCkQL7pIYHRzxUgS2I5yOusBOhxbwEWfDBYOM6ULul2ICnzSjcTvwrdpzN?=
 =?us-ascii?Q?scr1y7ijwlj4VgPcWA56CjavprrHdL0ZUM5NI8mzXLgk/sh5VmsX/PtoeoUm?=
 =?us-ascii?Q?ZRqYruO8OgAn9Hq+hJxlcHb6fkw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e27a08-9185-498e-4785-08d9bf0dabcf
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:09.0728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLVja999Gcw2NqcZA0oPYjJxYX3PlJ4SX4hZT8rvZe3TDXV+GevL4dPz96zpEzMXnGq6/2kwgFMwvIm0/uyH2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far, mlxsw only supported VxLAN with IPv4 underlay. This patchset
extends mlxsw to also support VxLAN with IPv6 underlay. The main
difference is related to the way IPv6 addresses are handled by the
device. See patch #1 for a detailed explanation.

Patch #1 creates a common hash table to store the mapping from IPv6
addresses to KVDL indexes. This table is useful for both IP-in-IP and
VxLAN tunnels with an IPv6 underlay.

Patch #2 converts the IP-in-IP code to use the new hash table.

Patches #3-#6 are preparations.

Patch #7 finally adds support for VxLAN with IPv6 underlay.

Patch #8 removes a test case that checked that VxLAN configurations with
IPv6 underlay are vetoed by the driver.

A follow-up patchset will add forwarding selftests.

Amit Cohen (8):
  mlxsw: spectrum: Add hash table for IPv6 address mapping
  mlxsw: spectrum_ipip: Use common hash table for IPv6 address mapping
  mlxsw: spectrum_nve_vxlan: Make VxLAN flags check per address family
  mlxsw: Split handling of FDB tunnel entries between address families
  mlxsw: reg: Add a function to fill IPv6 unicast FDB entries
  mlxsw: spectrum_nve: Keep track of IPv6 addresses used by FDB entries
  mlxsw: Add support for VxLAN with IPv6 underlay
  selftests: mlxsw: vxlan: Remove IPv6 test case

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  30 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 143 +++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  18 ++
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  28 +--
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    | 165 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |   2 +
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       |  97 ++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  14 ++
 .../mellanox/mlxsw/spectrum_switchdev.c       | 127 +++++++++++---
 .../selftests/drivers/net/mlxsw/vxlan.sh      |  18 --
 10 files changed, 558 insertions(+), 84 deletions(-)

-- 
2.31.1

