Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AE34B8B72
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiBPOcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:32:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbiBPOcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:50 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9BA2782
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrlWHl4AFcUJA5RLVhhsQvxWyzyHHDEAQWSsyqzjcRD4TzG5y7UbMZJeRjUkWaxlX7hBCJDsjqqLY+uNNSJ5JNwQWnKOkJ7faEI+TNiD6HCkOQYtCyBpZN3KV/0okkJVDzxR7GjlfF2UICmqoHFPAmCLuqs3xSVOYI60dgYgAqBHXh22nRrq869Ld9lKuCcwvJkKfxys6Bq8OVrmMq4yGbvYgRQmhOI9ULsrkcDkFGTbAY/jVZUbjItP9U3V9s0LqSs78RZMVGq2piU7InkPJEZhNKci9Xa7RciycPbuBmV1qQmNtL/NiZBX8Tm1EzXHv2HByoAY5LEBabkvCCqa2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9D7GCHrZeADcJ7cdHZNorCKXiO+eDa/WXtPb7Z08YY=;
 b=GtICLF1LgiXt3W5L65FkPBeesEcFv1KPfbjvdddCHFMSI1KDu1gVV+hLA2WjfmMdZrE/EIOOmxw+AQU4AaEcelune6N1oXYKCEb7Xis3S6ZqA1/Lw2KQFApMYN+0wwbOhR4GSiO8enFEmicIH98Rv00F0Lif/HtWid/wxGlHlMtyZGL+jDBjq42hSjdsx/DWJXU4ebOOpdm9rMbpam6p9ayTRDFNGgXRvTFouaNAVbmoMNFTtT5MPVvW6j2GMFc3c1W3nje+eraA/97eM6AMAQ8vWoqBzwgBbmET8CsJCLesiTK81lxXDNZRbKXOT6WPlqjcwzcRt9ib6nFxjFUY7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9D7GCHrZeADcJ7cdHZNorCKXiO+eDa/WXtPb7Z08YY=;
 b=CxC0WE2/dfRiQCyQ2k1gNWrIAom5tCYy6eF7xJHz7iVP4Zcjt/yU1YTLumGXSSjbcZdRvgKtIsOa5Id3NUcDb2zVU6BwUyP9QtGBbUJ0kRxZ2iQRJzmTxC0ymzpxL96sefbBxuAJwTYQGAB8N+EvcNBM/jZb1yD52ksN3YdsfZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 00/11] Support PTP over UDP with the ocelot-8021q DSA tagging protocol
Date:   Wed, 16 Feb 2022 16:30:03 +0200
Message-Id: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66280d94-708b-4997-cc2b-08d9f1592c60
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB68154A18663B9C73F85F3E76E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cUQxdXQF4m0wT2PZ7DzG8mTVgZxHpUP9ZSz1xTcmgp//Kh2r4Orxl5fltN3YqWHCctgIu1OKHhkVe+MMSYRicGd7pDbr7j2qbnVTfLt7VPlgQ7tLundNJ6I/2pCDeNrXuwNu6C4H8kHzcRCRXbq25vj771HnTd36wVvBaT+spECwvtcAG8Y/I8F9H6sweh/3ZHczBSgXFdyF+C/euClbt3EiORjSjOv0QdvbDLHe/tsxQP/dOlvTi6/YS9SXXIQQNjtOacFXGAvWHs+vJSCrqRkyinGUzs/BWCpWaub+BMH2thSCktO0w+tUuw3ynonF6dpWTHKmzOYaayVRJ1mKpIARNIlEKZJfCnbLLwv2Y50KkFuLnH6rbNIcn8Z49UF7fZ/TiH0gRpnzRVba20Mqtpyb8lZNqNW9xBRYsiyix7TbIcHaKzC2vjB0s+etiabSlNIl814GykEy08HF+JLhflI2KusbhiPn0xBGEjpBlkfvahtnTqjlqh12pFCjVBvJZRpZrexfeyfz6QIvRTBC88EepWjn4ww/4s//ab7RSU5g36z6tPecf/SuurUiNnTlmDCPrWAjUKoz/JHq3YKdnsCpy1GpLcT/XrOoIQIhc9oFSmzK/66hSsawBhgG7Rt2b1Rsm8mZeR4pf5XIpz0OFYCZc4DOqDgDBd/JUjfrW2pP5Qv1S+7/9T5G7V1Ez7QiL7tPumzvS5f+aaANtgUQ3QcLWG+ks6cr3BDimZ+u9o1ZXZbl37eCcynrPR2xcw+7v/1M1Oz4s7Rymz3D1IoG2SM/L0V9mNrUkIku2FJZCgLtWkblD2yTTXB1aHCVMcl4OQub8XoScx4U6318sXPgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(966005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+wOt4cauQOb21wTgAYegHtYZm6yq8YenBbn0mpmZPgzfTGqg6xWPoKPtR0jC?=
 =?us-ascii?Q?bPzq6xPdYXNj/zl1zdBMgun++PXYh1noHxncZ/6Goh9b/crH9/es83QMEM1G?=
 =?us-ascii?Q?N/rhuC2a8LO7q90fKvXebgwupLAnKlrHsE7gqPiGRvtE5QcduH+6hZC4BT0E?=
 =?us-ascii?Q?h13/jw/9RFi76QxzVRSifAwYPC1q6SmjbZdiJm4FgLJ4PSrlsiDi5nZvx69Y?=
 =?us-ascii?Q?s6T84a2QP0n9H9qJGNaMTBs6RKOLgIoaBpcergbB07aMdJFqLfHV7PTr7zWv?=
 =?us-ascii?Q?SxkC2F6ts08Ho3u7DxgXZdUoooRo3atbUbM7ZCaFlaUqJW2Cjhc8pvzKJN64?=
 =?us-ascii?Q?OSVIZD1i7wJXD7ECyuQJI20fO2GncV2oQNhVSb3SltPkZdb7m/1dOJZXltWS?=
 =?us-ascii?Q?XdWUXSDe952XTKTuSCeG6GTcY6h3SLXxENiSmccJqzaY1D1AS5LnbbjTTYh9?=
 =?us-ascii?Q?p0cAMHv93n9CBJtos+V7v7eUwsVygK+BTjD1PViYcjnGZPNuaV2l4TVAQqyT?=
 =?us-ascii?Q?3KjS+SLKpZRUQfBTNWjdFCOrtISUfsBwAQ1QQgQahdJgLxq6dp9bRg2L0Vqs?=
 =?us-ascii?Q?C7fIMRPBM72CXuJTDq09Gpijq1zrpZgSHYs7RbmabhQ3qWrcKbbTWTaljgO9?=
 =?us-ascii?Q?Z7ZtMoJtDKjjUUvLB9CGHAhQJNmSgS/u5kVoLyvsiveP0IaFNUu/EyPxzJ5F?=
 =?us-ascii?Q?oZKXs/kT9VTFLrD3e14ZBXmBV8Y8dglySmrVVskf0DQxbJtySszxotJqr9Pw?=
 =?us-ascii?Q?QnsDHj8ytV9S2t2294W/P4w37nrvQs+lZfVIEHcGldCrJUhivEstg823SBvq?=
 =?us-ascii?Q?Qb0m6kcwtf6PG3il6mt3MQfM2zh1FkmiB3XW3hvgF7HZbvh/OC7e5kk/dezT?=
 =?us-ascii?Q?PJaDmbF7vhPoAgg6q3xlgV9AoiOwxCec/tmiY54VYQfTpKWKnJ6JC7UEI60P?=
 =?us-ascii?Q?aaojdzg49Zw55lux4CVkvDeZ1DuxKQ6MyH30zRJQXQEzGT0msryUylJTKPFF?=
 =?us-ascii?Q?sorgxqZeRC565jOvctymt/kQ72kEKZs5gBoFpuw3DGLELb9dJHHRV51OR2WR?=
 =?us-ascii?Q?yBZ0sM5yNNsojHMtSG21zoEQlcMmuiQ/lXIAa5/IVWaMfHR8bmDludfXx4wn?=
 =?us-ascii?Q?Ws5lF/EVSfOkYCUTU+09KmvmWQrhr4b/SOhOOUZtv/a4IamiqpIS+v09Xi1b?=
 =?us-ascii?Q?mRKFeMiXjlDHbh7uHBpUeZ3IaapDx8hDQCCPtTEVvdHyaxFB7Fvd9bpmHzm6?=
 =?us-ascii?Q?FX/Lvyck3jAepjvxGcBq9kVBFYr2mGKtJNusAPSHZrDrvyzntCrluJDoWEPG?=
 =?us-ascii?Q?k8ariGMKB0ZV49fL55CX22zdA4v7bvUVWKWWjf+ZxR8FklGpTI+vnfUBarvB?=
 =?us-ascii?Q?53/OdPs7ubvL3Lm5iZEVhnjXKmE+c1xdgXTBJtWGf25NJrH7FB92uc/N8jTU?=
 =?us-ascii?Q?oBcfRE+Rplzs4r2mvgRQoOObUbKz3VYtkj4Z9JekCidmHtThRsMmKitqtE3L?=
 =?us-ascii?Q?bUZ6hDcvAqr0jKQvABvUwRwSW7AukfZRJr5xFCMz06C9bD8a9Ayfue3XpAgH?=
 =?us-ascii?Q?P2Bsyb1LLSV5IdSYosjafX5/K5FGyjDsZCeJMEjvmCeVJ9Hd/8wqiwjMNvMK?=
 =?us-ascii?Q?gv/xplRkaAcF8Mst2VK9dd0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66280d94-708b-4997-cc2b-08d9f1592c60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:34.9966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUACcdbmjwoG4tqNdZKwIR4+4rJXAvqsK+PTaWda0A+BK9SI/loA2KYhi47/oWFRUKt4r5XHXpBG5+JRLTztyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The alternative tag_8021q-based tagger for Ocelot switches, added here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210129010009.3959398-1-olteanv@gmail.com/

gained support for PTP over L2 here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210213223801.1334216-1-olteanv@gmail.com/

mostly as a minimum viable requirement. That PTP support was mostly
self-contained code that installed some rules to replicate PTP packets
on the CPU queue, in felix_setup_mmio_filtering().

However ocelot-8021q starts to look more interesting for general purpose
usage, so it is now time to reduce the technical debt by integrating the
PTP traps used by Felix for tag_8021q with the rest of the Ocelot driver.

There is further consolidation of traps to be done. The cookies used by
MRP traps overlap with the cookies used for tag_8021q PTP traps, so
those features could not be used at the same time.

Vladimir Oltean (11):
  net: mscc: ocelot: use a consistent cookie for MRP traps
  net: mscc: ocelot: consolidate cookie allocation for private VCAP
    rules
  net: mscc: ocelot: delete OCELOT_MRP_CPUQ
  net: mscc: ocelot: use a single VCAP filter for all MRP traps
  net: mscc: ocelot: avoid overlap in VCAP IS2 between PTP and MRP traps
  net: dsa: felix: use DSA port iteration helpers
  net: mscc: ocelot: keep traps in a list
  net: mscc: ocelot: annotate which traps need PTP timestamping
  net: dsa: felix: remove dead code in felix_setup_mmio_filtering()
  net: dsa: felix: update destinations of existing traps with
    ocelot-8021q
  net: dsa: tag_ocelot_8021q: calculate TX checksum in software for
    deferred packets

 drivers/net/dsa/ocelot/felix.c            | 272 +++++++++-------------
 drivers/net/ethernet/mscc/ocelot.c        |  50 ++--
 drivers/net/ethernet/mscc/ocelot.h        |   6 +
 drivers/net/ethernet/mscc/ocelot_flower.c |   3 +
 drivers/net/ethernet/mscc/ocelot_mrp.c    |  56 ++---
 drivers/net/ethernet/mscc/ocelot_vcap.c   |   1 +
 include/soc/mscc/ocelot.h                 |   3 +-
 include/soc/mscc/ocelot_vcap.h            |  16 ++
 net/dsa/tag_ocelot_8021q.c                |   7 +
 9 files changed, 194 insertions(+), 220 deletions(-)

-- 
2.25.1

