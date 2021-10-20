Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24443497C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJTK6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:58:38 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:17730
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230145AbhJTK6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:58:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfhDess5kwY5dR8zGe/CX6dqUK9rLk7NC5qIYd3kBk5xOvvUIFbVWTiiKBN+NJVo5bytMa2sdNpITr/QvFpKg4Jl4U3m1wzWnM5yXLhp0uIMe2d0sFIoqiYwqaDRMW2E7Z361fHJV1gfaqdQgEMFj8w6NBP3ooXgolNNiWMUWwCXJkUxAFzZ36qeklg/nDEQCvCuvdVomi+/NooRz1QgPrDjv/2MjOBmIu3hR6BTANN2CiN8yhV4K5MCkyUcQ0QWAMgtRDwhHIaLpC8G9gIe8vs5JfMuVztcCrEP3w/QK4SUX6GfdCrnzP9LJJPJqYhJIFxoA5c7Hs76jjHZ35kjBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPBxnyn4YMlZ/i+NBNb/DLvq2MlEgsDi3M7aEAqrvL8=;
 b=HVpllwKhlRh5CN+8VQX+ghg9kOJC3sOXk+janG9ibq5PEQV5BwRP3Q02uLKSh/PWzWAmnsCQKexSMytSTVI/phyC7EUdd22XIKyCkqHX4MiJRuinmweG7gAzs9y0kDjzpN5GDOm6tx8BvuIAm/wrpsm/O3UkRRstk1qtH/XDEwDpcqLWdqoRcoANY8xEYQEY7L2vlgrvKj1VK0Z9v0S9jLt3h7b4DBx51Gy7Xn39mMHjcvnML+GnGl9xG7AGFNHjiRv+4/8GqKXJBnwSJJxDy0lLaQvK1M1aRPO+rpKSqNccgeI9SOGCLPpfbydLNpZoITmmke0aCBmCP4E2dfnS4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPBxnyn4YMlZ/i+NBNb/DLvq2MlEgsDi3M7aEAqrvL8=;
 b=GrJWPhTwo3v+8yK3QI5v6w2zpzdcFpqOdds6wRBjgkYDnnG5TWJy5GIF2CFwCHrNH5CucP8jm2Lo3f5Yq2R8IXq9r9olyZhyKQuKOLjgpWkQ94OIGPRoxfGncuUF+yNGJUpXJaXrvHUkTHwRxvgS0Zvsltlj5bA/t7yFLQKvJFE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 10:56:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:56:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/5] Ocelot switch: support a config where all VLANs are egress-untagged
Date:   Wed, 20 Oct 2021 13:55:57 +0300
Message-Id: <20211020105602.770329-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0111.eurprd05.prod.outlook.com
 (2603:10a6:207:2::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0111.eurprd05.prod.outlook.com (2603:10a6:207:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:56:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ae71cfc-6493-4cd0-c74b-08d993b8407d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6702:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB670214C96E6CE0D5A21B6851E0BE9@VE1PR04MB6702.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+U3l69rUvFQtXZtnoDekr3JB/pO92GzUiGgAbzOgcLecyuxbnyRVUWVmyvhvWenHaPrnvjNR5bj4tQwtktlaqsAIMTXBktoaYbFvY0mHsbLKEPDPZskxr54EfncouoYDrXXRGAF3ibaGB28G1HQF/QxIgAV0ukn2bIfmfp8074bAhk9ANdYgIVT0Aw/NZuxZG+DiPWpXQW8aOig+BiWJI/mpCeyV/w4bkb5RWaoItnkwdMBCv6Z71VVKzG7JExMuDOOf6uqYIS7jNngE1jTYaXuliERCE/o8/MoqYMCVUGyvXxf2lhC3i8H29vk/sN7N7ZXXMquWhrGiJPaD5Lfxv9nkiS1Tb49xAIT7s03Q1zkNC4QfQ7CmdnvzbALWZawO+BH+iAVtIHzpcdosn5N2uxkfDJUY1A2oLf/U0yZASPZT2T0S3OGMhBnm1QHfPjh4uEaTzSS9ol9VkXCfdY8o4SGNCkBFGs2rg/MabG6DhL3CE6gQfdLCldeRlb8orZ4jBIWgVXsfdIhfgmyVVqnbF5NrMbvSoGU24wYkZ5X7TWOkjUMfOYS5qa4jaPUFKQo400hnxSuNXMJCScKbWgoYq1arpu06mzWlBLDT+biNfyrFqcbRvKNJaHw7jHrLNk9GVBtReEtCFzA6hvlSuE4sGo6moQBDRyv0+pLXKEQl72pHpwGGODQNl9H1YUpgr35+2L2Y5tL4L8ZyAdakDzQUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(8676002)(1076003)(26005)(38100700002)(52116002)(83380400001)(54906003)(316002)(86362001)(4326008)(186003)(8936002)(66946007)(6666004)(6636002)(66476007)(110136005)(508600001)(44832011)(2906002)(956004)(66556008)(6506007)(2616005)(38350700002)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+qceE9v1Vg4ATFAvjwCWymiZlZYe2QzmIO6G0CG8krsa7zkxBL0Bms/tKIQw?=
 =?us-ascii?Q?IOIA+dkPZlT2ByYsz3qTStlU3Na3yK6RqWgJ2EKXsGWde/LvIQsh/iais7FL?=
 =?us-ascii?Q?eRJLuIXEY6pwUBjI4jz3sgX0CNtQZt48+c1DBtkYksI1tIUYtA8GM/UcIHRc?=
 =?us-ascii?Q?jAxEyxgUMxVT8PtrqVKu+gOJsHPxQ9ovI8Pc5YCnI3q3y59thfHfTzoaWbTv?=
 =?us-ascii?Q?pB5yzh76Gx8sTrHEu0TuM0Qg/yvyiSFvZ8/MJV+MwnJccDGO7cYjHJmyTasH?=
 =?us-ascii?Q?nEaPfdZwJrb1I9JTFZes1jK76957WyQTEy3VRcZiIOiKgroGyPdosf/LypD9?=
 =?us-ascii?Q?vFxwL4I0IKYbwuHyPUmrtkey9MSW++lCveQqoW2u+J9V+6FXCYzE0yE478Zo?=
 =?us-ascii?Q?g7lKzqL07vCgNr6s47jEaIPWNh8kVqYnDb8gZQPte14dor9/c73R9xMQqd+2?=
 =?us-ascii?Q?ytEs2tH3KDV9tEMTIOd1flQc3muDwS5SMXV1Zak/yUEdKvRXXyT7h9AAVA7C?=
 =?us-ascii?Q?WEEksjncPnsbKeHEIlocQOmUg3/QBtKcEDIIJPILggDHpiv40dtr+8VoYedi?=
 =?us-ascii?Q?VTX0D/k9B2stbMpSN2kFv7JT0jbHr3fOvaf7CaWENH34NCHIn7rlxgJlfIeb?=
 =?us-ascii?Q?2AF/daNL2JHXlWDLKjWDmWPhT1XJGl9dygEVQybh2eFvKkgVrw161VJ359fN?=
 =?us-ascii?Q?zCoeU1XrK3+driqIn+TzYvqL+aF7wggsI+HOQwFSq0ZHf620AWeJ2tct1HBm?=
 =?us-ascii?Q?cMzug80j8t4eNHQuX7JhJpgOl4mqKWKggk2rKb/78V/5M0NTxxVlVFapUPie?=
 =?us-ascii?Q?wGuf2lJcrrVr+OrIBm8A9uWXvXJSl2xbqkj2DLvklLwhxjvukPLSKQ4Lb5/k?=
 =?us-ascii?Q?1ULBvbKA/BTetvZxENhqDWo0jwKg+LiUPE7ODoO15bFlg4WcTua6WC5gOc7M?=
 =?us-ascii?Q?D0hXuS3rMrVHLcQIySaVJ8XxrOJzUea+kTApbE2zuhQ0A6fbpf9/v5K5zU1N?=
 =?us-ascii?Q?KcHcHdQQhzBvxtMFv30Agpa9mHV0+OiclKe5jXKB0cjnAFG4wHGIOuUVH5M9?=
 =?us-ascii?Q?Zk5jKYa6NieLidqUPqu6qVblVsopDtUsPiYO4JbINByS4iKaqniALUCUYkcX?=
 =?us-ascii?Q?EGwLozz42z9dl3SpLLeq8LIwpkx/M5VORu4MuaZh8H3HyDOwwuI7zsqknc/p?=
 =?us-ascii?Q?tMc7/C9MSXNJOklXZYEoEl8QzobviSnunKMXyYboSpjeueKQ7SfycLO158yQ?=
 =?us-ascii?Q?p7rA5u4eiW09pMNwYNTjgA+Pk/AFzrM77LUh/g1NBRWc2iM67i+m2QOPOJDo?=
 =?us-ascii?Q?85U3fl4Dv1M15y7q13ax6eRG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae71cfc-6493-4cd0-c74b-08d993b8407d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:56:21.6755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xosu7XwjCeur0BSgT16AT4JEqt9TIqrxTIjP6FxbViDintxXadbk4y1EemJZ2U2WdZLFiwGWhNNmC1bum+IOMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Po Liu is working on a use case where a station attached to the Felix
DSA switch from NXP LS1028A must see traffic which is coming from
multiple sources, in multiple VLANs, as VLAN-untagged. This is currently
impossible with the driver.

The ocelot switch family have restricted functionality in terms of
stripping bridging service VLANs on the egress of a port.

Where the 'bridge vlan add' command can have the 'untagged' flag for
each VLAN entry, the ocelot hardware can have no more than one untagged
VLAN per port, or all of them.

The driver currently only supports the first option (at most one
untagged VLAN). So while one bridge VLAN tag can be stripped at egress
towards this external station, not all of them can. This series adds
support for the second option.

Vladimir Oltean (5):
  net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_CFG
  net: mscc: ocelot: convert the VLAN masks to a list
  net: mscc: ocelot: allow a config where all bridge VLANs are
    egress-untagged
  net: mscc: ocelot: add the local station MAC addresses in VID 0
  net: mscc: ocelot: track the port pvid using a pointer

 drivers/net/ethernet/mscc/ocelot.c     | 272 ++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot.h     |   1 +
 drivers/net/ethernet/mscc/ocelot_net.c |  12 +-
 include/soc/mscc/ocelot.h              |  24 ++-
 4 files changed, 219 insertions(+), 90 deletions(-)

-- 
2.25.1

