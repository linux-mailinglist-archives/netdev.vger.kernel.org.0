Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3D41F101
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354933AbhJAPRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:42 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:29755
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354920AbhJAPRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEhqe9z4oPt0TLnL5H8DGR2Knij08NCjmU+hoCKZDhOAgvSElfBaAJ2yGAtM5Xr08F64IxghfDgtejXXWNBX5adW3+z9SApPY6NSgeKh52fV2Z1jMb5hVUr7686xUoNMBpjw+/yB2LRRFGbL77R6POuu4sDdhcQIbs7vz1mYSdNNKo9jVHStBhBcqcIqo6ZeDVISQrbf+5hR+AIBPoKEVJZoR0oNmGwwu8iuKB6N4IwV5ihzRgdPV4DvKaxOgaKYyiI73OkBn6MOHG1z1HplxcBJug1UUPJxyCB5g5nJYfNR4HbacwmQe0eqciYafJni8i2GjeF9YReIrl3NPTqm8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uU6pAwLDG7pR+Lv9FfpcQ8mh1Ts4VDxyUYzh7bWu2nM=;
 b=i4ZdkOqWB+xgvBRpc/nhJ/rXBPKZjiwrPI9ySnzguHiVBnx7q/HW2m6n2gJgutSzrRR9ghpnb5+O59B62GCemQQSb96nEzaD2Zee+sm81H5ttmDKaP5Xozuu8MZDDjei+2jqFg/hueKmrwZyZURpzbTfU5VF2QA16rNTDqnjRQ8BNRSEjya1SlxqD9/6OyDivsKoclZ2nHzCj37Vqd20KejTOeexWu5/wDDsVG8pGsMhuVuF1j6nMHjLC9F9alp5eYRYbjfo4Ei0GYXAHffB3kYmttAd4gHXYiDadldvAmtSQgdL0BhANYi4szEmU6xZUHb0efZEDEFIxWXAedrWjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uU6pAwLDG7pR+Lv9FfpcQ8mh1Ts4VDxyUYzh7bWu2nM=;
 b=SyiI12WU2BSl9slPp8UNwsFcq1MfDRqEDjuo78WqWDfaWojrkP3JUNiNzI4DRq9+iiX//yDNNF7ifV2rgNHK4MANwLZbJhmPeECRKFlqu7vTIbry9mS6ualUADDnGQCnJ1VeC5fzjo1Dxz/ak5zlrSEnE60QeufBBRWeVfodgRo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 4/6] selftests: net: mscc: ocelot: bring up the ports automatically
Date:   Fri,  1 Oct 2021 18:15:29 +0300
Message-Id: <20211001151531.2840873-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
References: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 320e0030-77ff-455a-eb46-08d984ee5887
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4224406EF9E4184A0D39366FE0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UWDMRmwkcRfra6/KqCF2C08qz8isRMxONGBxyNpcrO6yG+y6m3onm8N+B7WZVHLkIwfBp2qyqUaIt/DGbzgoBtU4me5VacwRTxS4eQtFzNk6ymjemJ8mberp+s1hNE6cBXSiHulXJXoaJKlyIhdv/YIDJC5J9D9ao/JfFyhipJ2KCrlPoLP3y9ZfSLoPfkgxv7V3C/T19XUHhCf9ZTngaKkAN5AZ9y+GYcbnoft+mohJWgabQibAAJRxygxo42oUNF0dkoLOCM1uva1sdw/o/T/nZXUqnShvAcuq7+cVmBVuKlfwPsP4r8+23TpGSwDc295O9VTnLeLRamgM5E0h4edg1oDizLcLKnneBVrtNOlY/ns1NLT24ETOrfuYyvZ5HQL6fSPeo7BE9mahYt2yaewStiW1PBIeK9EkYNQ4AOSlJDBdCj/c8QfOIlqya9XQ5gbOjSguYWPNBkeqnchDvV95hsKm8moTpoW99QkTgHo23wvhUiVdzazxO/Dm9FwE336ZyAlJKxBLHnpV+FU4ZtfESo1oH8egCmB/iUzh8r8Vd8N/IAiy1ji4iUgupPj6C6TryK4RQ80/mzc2FtmLlfD5W7lqxOfkgD3M3uwMTFSfduADfdwiwP3f79A3tn17mtqsJ1rwUO5K8VGngzHiWNMXG8B6mGGiXtOxk69gv0eZWu0FyORm/0EmqpjnWNXQiWMg+JozMBS7v5JvMFvhSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(4744005)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cwZ9Tnuk6iY4C8saax2J7GNSvTwGmebnSsDIqW6E8GV9V9LZIoV0G8EpgYwR?=
 =?us-ascii?Q?uIlYe2ICfl1MMk62LLqmeTvDMvXkFEkZV3ci189dpOmFwLPFtiCv5DGBtXu/?=
 =?us-ascii?Q?MHCGVewBXIlNRCLZeg0buHe6tfAJl8E3hBDrFp0l09ZXUf26PwVCuBVp9dyE?=
 =?us-ascii?Q?ymWDpv5AFMvgKrX8C1dz1dSKlNtUfDi6TyM6FZ/DKw8a8OTLMwFV61RzQZzC?=
 =?us-ascii?Q?ZzsS7M8oYgRKW+m68KnPfFkYot3GxGrHG5s2/qit0mPhp4bDSicFxClf1Yc+?=
 =?us-ascii?Q?sXT7TR7RJ6HbLirWAzcm2TogvdvXgXaNLaYRUTs6OZub7HGaaAmbpb7LhHph?=
 =?us-ascii?Q?E157NbshUTasyM2BKMPZsBMCRpJkGx2pMbc9FUOb5VaJsq9VmAe0N8jdCAsS?=
 =?us-ascii?Q?SCGltjLSdezSVidxYHqVMMKjGDjn/CE8qzBJIbPzH5Izaq86RTIla5BuUXQA?=
 =?us-ascii?Q?nl9jGEQmKamHlL9kRqljCWTie7oxbb9dy6oXCsokTpT6Og3YZyUB9SzEes9N?=
 =?us-ascii?Q?ma0S6xTTfLansIj3UbZIdmpd8TvdZqd7k03sm3nhRg/tGevZUfioWF6kDESD?=
 =?us-ascii?Q?7piZ8TzjpkGKMiaAwk3xGOcD84mlvCNFEPw9n8bggXgI5Z+kkbKWvmL/d/9H?=
 =?us-ascii?Q?+aNfZbczEAPLp0YW+m9FXRVe41Z9vHI4rvDu1Neb1Ra0ydarMGeFEOXza2t9?=
 =?us-ascii?Q?zBY80WZx8oW1v+ClAibFE9mxE+jj4h0F/8rtBlzx46F4fBDxyALsO3VpmMsA?=
 =?us-ascii?Q?RKWfRxPB6P9kMJ6WQTtUsY2s/0b8/DXCCLiCZBWn5WGYmiH33miVkYfeRTI0?=
 =?us-ascii?Q?J1NSaCfap1KadxhCS0RmuPsAE8DN+7QJA5sRStaqc2MYfyKV3L+uB4lcN9ai?=
 =?us-ascii?Q?7dcayrDNSydP/IacNML7Rq7TyJ+QW/WaOIM79qM0psH2+ZEMtqm5/WAKEKuk?=
 =?us-ascii?Q?JqJl7xZNslgKjuNOhlXi6gr/Azn2OgPUTJjo/qwKa3DPDufoY2apsYiWHi1B?=
 =?us-ascii?Q?cbzJs3UEdW1Q8goVHgpqFMzPoo5/bKHHSYezRWtQb9AFKGcM4knE+nOv4hg/?=
 =?us-ascii?Q?KOtUrBuXPrZZtUKqLNxo/9SiQsi7UDW7kDMcVJEOY4K0vhw/pnL6Z4gxnxU4?=
 =?us-ascii?Q?hqqaVlFXjtdA9NrMQpe+HMpGYAqOy/gO76plZ2K0/dzs0sdvq3GbnFTtYmIw?=
 =?us-ascii?Q?8lwNjPyIIIYcjEVPfdJW6KSZRUVvQx0fBiTAwjlMGSObnJmVqbvRD5UBRxnQ?=
 =?us-ascii?Q?JSsVJ8rMqn8fTzO2c2hVS0Z5BDTovTcgjp93wxd28hR9jt+QXsf08DMOE3zx?=
 =?us-ascii?Q?53nzodnVm2exHgrvbWl8vyV9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320e0030-77ff-455a-eb46-08d984ee5887
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:47.3850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeeTEuLCX4wX6nR47nNkakkVBJuHSIpjXOXQISAbLWAtGrO4XD1MA9MonZh/jhXbEA4sqKbleiaLJIVJNCFxeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like when I wrote the selftests I was using a network manager that
brought up the ports automatically. In order to not rely on that, let
the script open them up.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../testing/selftests/drivers/net/ocelot/tc_flower_chains.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index f7d84549cc3e..0e19b56effe6 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -156,6 +156,11 @@ create_tcam_skeleton()
 
 setup_prepare()
 {
+	ip link set $eth0 up
+	ip link set $eth1 up
+	ip link set $eth2 up
+	ip link set $eth3 up
+
 	create_tcam_skeleton $eth0
 
 	ip link add br0 type bridge
-- 
2.25.1

