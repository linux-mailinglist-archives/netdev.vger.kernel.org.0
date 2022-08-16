Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1470595DCE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiHPNym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiHPNy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:29 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10058.outbound.protection.outlook.com [40.107.1.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F803ED54
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CETml8NEebAIVJ8xoUBwAyACeFBV4zGoMSTtLz6JLqp9YOaBS6kDVZFuWgMCHE1/rHhohYyjh1e6YKgwo9U6iskZVSREpeldPKada+yEbLl4vxLJa/0pduUmT6s6RPduxYAHJa571Xp0seBHkuLCOINrTzeR+wnh8LugjAItG88RUvp8jooby7NeDFkttqJK9jaICjyBOtWOBzadNru46l2reltUturjRzjg/QILS0mMXMcyZT3Woq9pb120OqHqwv2LaH7yI20+asbcXmrAOW4PX47wauKuvPuzVMD5McM1xlqYrCIjHh9vB++heO9DDG4sOZYTx2y+T/RFkEf7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/IVS7Sm7863srtI8jco1z2sWmYlvdxzNSO4UMlie1Q=;
 b=B3Fx2JOe70urkDiq3AiLMkub4uuCey+XQww1yQuNhuUq86kQ8f+YSrmpbephLpkqdJ1LZWjTmJKNDOfNTo6s6aVSKAqnpxjgz/a0Q7Nrrbds73oyjTIAaJfYqRBOqw0Gs68+QKV+zyNlSKVUmIOUbHa3q/S//d/EkrPTzxqul2L+N8CRrBD4bAcy+Zl/ZslSlfvXKMtYEVQ80OKrUVB66tJqj26M5VIcKgvyjP+AfApIVFsQA6EEyMPkL/tZaMuImPSs9p0zZ5SENIkyrL0CO2syvzihEqIKoNnPC8qjV0vkWQVRpu1vtvJbODJREN7/OUiXqNK7hlw6PDsD01heow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/IVS7Sm7863srtI8jco1z2sWmYlvdxzNSO4UMlie1Q=;
 b=a6iEI3XH2LrqTB1GsZH2D9x9x9lAU8PWaybYber/iMWCJrPT4D2VkrvtFs4emDGgIlqBluEU4JP5TC84eTzGqVWF+jY/pJzNqPKc64b1OBjri4kVvVwulYsC79tlKEtjZ7t+LcyPp+vJd8OYn0+P+kQi2AnKLTn00SL9cfK2HKE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5702.eurprd04.prod.outlook.com (2603:10a6:20b:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 13:54:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net 6/8] net: mscc: ocelot: make struct ocelot_stat_layout array indexable
Date:   Tue, 16 Aug 2022 16:53:50 +0300
Message-Id: <20220816135352.1431497-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab886d81-f800-416d-6984-08da7f8ed014
X-MS-TrafficTypeDiagnostic: AM6PR04MB5702:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMA0Jo2HPRAN7YejZYgM3Zq5ssCwkmh8X8Jju8ljtUCtg35dOR5Aqx06+CEVBisvfSjrGI5VzRLBx01Whn3TJeUcC8i/i/GznFedQ32+/nW0l/5eFVp3vlNuZhZvPHgsqVf1IHoPJNTw/pJFfyJzozkCrkyPkYzK58Dwr/qX6CGujPP+ZdOdAX813kNzYQQgC38zAm+9dggeSPaXuYppaUtg2mhnSZBnYIYVhKPOE720exjxw8nNI+EWRgq8swet73RoJhCr74CSgQD3exzYAIYdxhxI1cunDv/FTJMZ3W9fMSiD8U1nsUuN4Tk4wCTNpYF/blBBNCCSvXxsZoWipoF29PCITaI+s7gIck2RGqMz+1qPc2Y81ofgEGQaURGjhXMITv9SOiBDC10Po1MHJi98j0H0N9fx+BWL4uukQcjPAhupAxKvAX4cmgVwam4oT7MtaE7ggm0dXJq3Hxuk3WwfyzJ4v5igTkUHerRoKPw1bkOdKWIvP7Zy4GBUosYwTac3Tqgr3CNNXpy++50/sc85/nmf11u+NXArfSVWKTZvCZ36BdaSWoVAh+y6H7lLFR+ULlVXh2o+F+jJPY62gppj8E/MBMNKprkeeSFgxo8LEek4f94dgEINWFFnbWEOljeA+q+lncbqAiVk9mj/zfLZzSkf7HYw97spCr4RVGf/l3ikRvXZRbkxsGluW5TZlIjHi77OVhABIJhK971JPI2GQ0lcdkIJgdZ6nP2uhVW2BU+AcKKlh8aUJztv85ycC/sAidCQAmxP8DRaqRVHf8vdLAfCSFPcSsLcPppE5GA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(54906003)(316002)(6916009)(83380400001)(52116002)(36756003)(1076003)(41300700001)(6512007)(6486002)(478600001)(7416002)(2616005)(186003)(6506007)(6666004)(5660300002)(26005)(8676002)(66946007)(2906002)(30864003)(38350700002)(66476007)(86362001)(44832011)(8936002)(66556008)(4326008)(38100700002)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o65Asz4LA+g4gpTSABvdCaxpbAY159AyJaSYgG1cLFNx8vPod2fvy67PS6xJ?=
 =?us-ascii?Q?dZcS2RIFNrncXy546gAgJDtbHRy4AqqIBiiBfAwUNBfhMb2IfZUzhZesOZyL?=
 =?us-ascii?Q?suBhxB3MlX4K+wDJ0EbEaRT6BtCyo4DpSbeHcCqhIrQalKpjzpQrkGD0w3YA?=
 =?us-ascii?Q?OnUJfTR1oi3qdKnE6GSc/VHbcXYesO+R7YghDBp6H0NDI6EZkaZCp3J8TyYY?=
 =?us-ascii?Q?oa3/LblbK/H7T/esiDp8P0s6RSNrPID7+onUtsxGmmLb0cXP+4r+4X3S1Syi?=
 =?us-ascii?Q?5GNOErVtyi0FnLJVwfq86M2IguTcqKFv3C91Y7WhP9vaSphgXIvL2xcUsEM6?=
 =?us-ascii?Q?rxU0RDVgmlW3dG3Oqqyj5v87YJDoXu94hw/vLv1gABJAYfLgDiBFo+ET9DMN?=
 =?us-ascii?Q?4GphKf94JaSQjxBMwhYoIV/6XI5Bdj6gbPO3AV1jAptupMkCMKByst4iceLM?=
 =?us-ascii?Q?RHTyGdjxgc+H/2i5Eu8CwBFAGyyr+V2UzLppdsp+0jeZXufY0j7MRabKXtQK?=
 =?us-ascii?Q?2r5CneBVL5Kd8s4f8UZd5KZWuztK8T0eUl8eTjbz3oTkb/MpQ98zGmOrQUFa?=
 =?us-ascii?Q?43dte1Ot+evsdH9h7PsyuCIaCcRn76+Hz+s/tkQPalT3YqEfuekO31ySAB50?=
 =?us-ascii?Q?Zt3Sc3vCNXpFFLvOb8oUZMdAmIvkyYuf+ZzswfGG8NDZbg2bZeMjz8vxVBJd?=
 =?us-ascii?Q?pQt70IEwaBg/p4qiiv5Txx89z44l51t9A3048W5TX0DOCGgfXWu1A8HJO8oe?=
 =?us-ascii?Q?jYQSPpME/H+Wk1z4q03Sc77dDgmnZJWhNXyEzmigCtV7LKfcI47HAGd+dA31?=
 =?us-ascii?Q?2D/DzmCcSishgxSEwqbC8S6Tt2OVcWVoitLiqpdksUDooW5mANykLat2hBMa?=
 =?us-ascii?Q?yfjmK7HGbnMD1v5D5dlUc1CC2ExZQEl9jnlzhOWNH3XqA+jQSM9KfGVrmKAM?=
 =?us-ascii?Q?zvZMoVD3gPx6CCAAuBzuL+i04fqzUYSmphx0g2EXKL5MokvFd1cvN9P0vqwN?=
 =?us-ascii?Q?BcVVLvdXuD63sONb2Z5RWoudjOe/3bYEG3gSyQUp1jXLm5JM8/KzQVn4VSHA?=
 =?us-ascii?Q?A6nn4L+fBISmtvnpVQqfkTTWG/GXoIsYnaD6PaM/bXIjTvy4MNxnZn/BUDwX?=
 =?us-ascii?Q?sj4SfFY95zMuDn+kYbY2ShREis7sbpNgoxhUk2CE+bhmrkh/wSNy/f+PixtX?=
 =?us-ascii?Q?KTxf5mWeStkp+8R3g31APROd1OImQZ+SqtK8Sz8HFIK6Su6qPzpADLrwHhf3?=
 =?us-ascii?Q?gzALK4lzlGUegRjZEE/Fh84ujovSvHdQEonsIkDcPnulhBnuPDoExHdsjrMg?=
 =?us-ascii?Q?TgUKkEAS7/R/PEKrDaA/VU7iYSqdtm5M9rP3i5SS1wg48BBuwGxWFHjNa4Ky?=
 =?us-ascii?Q?GqtxHhDeqAlvYVYVBG79VwcaOodLh4hUpP2JrTZoANrpD1SYJi/jV5ZhJunf?=
 =?us-ascii?Q?LxZMuacfaylEWPnEOVlgHvHWUds8aNqTwWK/p0L1laAShUtFO6elG2AUBZxe?=
 =?us-ascii?Q?/AJ30uefp1A+GBfk1rR5jlMCccRrabC4/idR0ZCkaaMoN5ffGTQN1d+9KQKB?=
 =?us-ascii?Q?L1AQz3HcxltYlU0MgxDLDUZQhpiPgwVjWxWLdjNA6XpL0+jFHTD6i9oWZ7gu?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab886d81-f800-416d-6984-08da7f8ed014
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:18.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Jj4J9vkYf8WbmLR/lpvBiwp7AnfuzWh+H41dVk0t2NTu/ZkOyNc3GP8Vy5Q3ddX6Uzccn32uJaJ9SQq37TmJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5702
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot counters are 32-bit and require periodic reading, every 2
seconds, by ocelot_port_update_stats(), so that wraparounds are
detected.

Currently, the counters reported by ocelot_get_stats64() come from the
32-bit hardware counters directly, rather than from the 64-bit
accumulated ocelot->stats, and this is a problem for their integrity.

The strategy is to make ocelot_get_stats64() able to cherry-pick
individual stats from ocelot->stats the way in which it currently reads
them out from SYS_COUNT_* registers. But currently it can't, because
ocelot->stats is an opaque u64 array that's used only to feed data into
ethtool -S.

To solve that problem, we need to make ocelot->stats indexable, and
associate each element with an element of struct ocelot_stat_layout used
by ethtool -S.

This makes ocelot_stat_layout a fat (and possibly sparse) array, so we
need to change the way in which we access it. We no longer need
OCELOT_STAT_END as a sentinel, because we know the array's size
(OCELOT_NUM_STATS). We just need to skip the array elements that were
left unpopulated for the switch revision (ocelot, felix, seville).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 468 ++++++++++++++++-----
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 468 ++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot.c         |  40 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 468 ++++++++++++++++-----
 include/soc/mscc/ocelot.h                  | 105 ++++-
 5 files changed, 1243 insertions(+), 306 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 46fd6cd0d8f3..c9f270f24b1c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -551,101 +551,379 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 7, 4),
 };
 
-static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
-	{ .offset = 0x00,	.name = "rx_octets", },
-	{ .offset = 0x01,	.name = "rx_unicast", },
-	{ .offset = 0x02,	.name = "rx_multicast", },
-	{ .offset = 0x03,	.name = "rx_broadcast", },
-	{ .offset = 0x04,	.name = "rx_shorts", },
-	{ .offset = 0x05,	.name = "rx_fragments", },
-	{ .offset = 0x06,	.name = "rx_jabbers", },
-	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
-	{ .offset = 0x08,	.name = "rx_sym_errs", },
-	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
-	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
-	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
-	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
-	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
-	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
-	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
-	{ .offset = 0x10,	.name = "rx_pause", },
-	{ .offset = 0x11,	.name = "rx_control", },
-	{ .offset = 0x12,	.name = "rx_longs", },
-	{ .offset = 0x13,	.name = "rx_classified_drops", },
-	{ .offset = 0x14,	.name = "rx_red_prio_0", },
-	{ .offset = 0x15,	.name = "rx_red_prio_1", },
-	{ .offset = 0x16,	.name = "rx_red_prio_2", },
-	{ .offset = 0x17,	.name = "rx_red_prio_3", },
-	{ .offset = 0x18,	.name = "rx_red_prio_4", },
-	{ .offset = 0x19,	.name = "rx_red_prio_5", },
-	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
-	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
-	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
-	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
-	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
-	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
-	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
-	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
-	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
-	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
-	{ .offset = 0x24,	.name = "rx_green_prio_0", },
-	{ .offset = 0x25,	.name = "rx_green_prio_1", },
-	{ .offset = 0x26,	.name = "rx_green_prio_2", },
-	{ .offset = 0x27,	.name = "rx_green_prio_3", },
-	{ .offset = 0x28,	.name = "rx_green_prio_4", },
-	{ .offset = 0x29,	.name = "rx_green_prio_5", },
-	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
-	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
-	{ .offset = 0x80,	.name = "tx_octets", },
-	{ .offset = 0x81,	.name = "tx_unicast", },
-	{ .offset = 0x82,	.name = "tx_multicast", },
-	{ .offset = 0x83,	.name = "tx_broadcast", },
-	{ .offset = 0x84,	.name = "tx_collision", },
-	{ .offset = 0x85,	.name = "tx_drops", },
-	{ .offset = 0x86,	.name = "tx_pause", },
-	{ .offset = 0x87,	.name = "tx_frames_below_65_octets", },
-	{ .offset = 0x88,	.name = "tx_frames_65_to_127_octets", },
-	{ .offset = 0x89,	.name = "tx_frames_128_255_octets", },
-	{ .offset = 0x8A,	.name = "tx_frames_256_511_octets", },
-	{ .offset = 0x8B,	.name = "tx_frames_512_1023_octets", },
-	{ .offset = 0x8C,	.name = "tx_frames_1024_1526_octets", },
-	{ .offset = 0x8D,	.name = "tx_frames_over_1526_octets", },
-	{ .offset = 0x8E,	.name = "tx_yellow_prio_0", },
-	{ .offset = 0x8F,	.name = "tx_yellow_prio_1", },
-	{ .offset = 0x90,	.name = "tx_yellow_prio_2", },
-	{ .offset = 0x91,	.name = "tx_yellow_prio_3", },
-	{ .offset = 0x92,	.name = "tx_yellow_prio_4", },
-	{ .offset = 0x93,	.name = "tx_yellow_prio_5", },
-	{ .offset = 0x94,	.name = "tx_yellow_prio_6", },
-	{ .offset = 0x95,	.name = "tx_yellow_prio_7", },
-	{ .offset = 0x96,	.name = "tx_green_prio_0", },
-	{ .offset = 0x97,	.name = "tx_green_prio_1", },
-	{ .offset = 0x98,	.name = "tx_green_prio_2", },
-	{ .offset = 0x99,	.name = "tx_green_prio_3", },
-	{ .offset = 0x9A,	.name = "tx_green_prio_4", },
-	{ .offset = 0x9B,	.name = "tx_green_prio_5", },
-	{ .offset = 0x9C,	.name = "tx_green_prio_6", },
-	{ .offset = 0x9D,	.name = "tx_green_prio_7", },
-	{ .offset = 0x9E,	.name = "tx_aged", },
-	{ .offset = 0x100,	.name = "drop_local", },
-	{ .offset = 0x101,	.name = "drop_tail", },
-	{ .offset = 0x102,	.name = "drop_yellow_prio_0", },
-	{ .offset = 0x103,	.name = "drop_yellow_prio_1", },
-	{ .offset = 0x104,	.name = "drop_yellow_prio_2", },
-	{ .offset = 0x105,	.name = "drop_yellow_prio_3", },
-	{ .offset = 0x106,	.name = "drop_yellow_prio_4", },
-	{ .offset = 0x107,	.name = "drop_yellow_prio_5", },
-	{ .offset = 0x108,	.name = "drop_yellow_prio_6", },
-	{ .offset = 0x109,	.name = "drop_yellow_prio_7", },
-	{ .offset = 0x10A,	.name = "drop_green_prio_0", },
-	{ .offset = 0x10B,	.name = "drop_green_prio_1", },
-	{ .offset = 0x10C,	.name = "drop_green_prio_2", },
-	{ .offset = 0x10D,	.name = "drop_green_prio_3", },
-	{ .offset = 0x10E,	.name = "drop_green_prio_4", },
-	{ .offset = 0x10F,	.name = "drop_green_prio_5", },
-	{ .offset = 0x110,	.name = "drop_green_prio_6", },
-	{ .offset = 0x111,	.name = "drop_green_prio_7", },
-	OCELOT_STAT_END
+static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] = {
+	[OCELOT_STAT_RX_OCTETS] = {
+		.name = "rx_octets",
+		.offset = 0x00,
+	},
+	[OCELOT_STAT_RX_UNICAST] = {
+		.name = "rx_unicast",
+		.offset = 0x01,
+	},
+	[OCELOT_STAT_RX_MULTICAST] = {
+		.name = "rx_multicast",
+		.offset = 0x02,
+	},
+	[OCELOT_STAT_RX_BROADCAST] = {
+		.name = "rx_broadcast",
+		.offset = 0x03,
+	},
+	[OCELOT_STAT_RX_SHORTS] = {
+		.name = "rx_shorts",
+		.offset = 0x04,
+	},
+	[OCELOT_STAT_RX_FRAGMENTS] = {
+		.name = "rx_fragments",
+		.offset = 0x05,
+	},
+	[OCELOT_STAT_RX_JABBERS] = {
+		.name = "rx_jabbers",
+		.offset = 0x06,
+	},
+	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
+		.name = "rx_crc_align_errs",
+		.offset = 0x07,
+	},
+	[OCELOT_STAT_RX_SYM_ERRS] = {
+		.name = "rx_sym_errs",
+		.offset = 0x08,
+	},
+	[OCELOT_STAT_RX_64] = {
+		.name = "rx_frames_below_65_octets",
+		.offset = 0x09,
+	},
+	[OCELOT_STAT_RX_65_127] = {
+		.name = "rx_frames_65_to_127_octets",
+		.offset = 0x0A,
+	},
+	[OCELOT_STAT_RX_128_255] = {
+		.name = "rx_frames_128_to_255_octets",
+		.offset = 0x0B,
+	},
+	[OCELOT_STAT_RX_256_511] = {
+		.name = "rx_frames_256_to_511_octets",
+		.offset = 0x0C,
+	},
+	[OCELOT_STAT_RX_512_1023] = {
+		.name = "rx_frames_512_to_1023_octets",
+		.offset = 0x0D,
+	},
+	[OCELOT_STAT_RX_1024_1526] = {
+		.name = "rx_frames_1024_to_1526_octets",
+		.offset = 0x0E,
+	},
+	[OCELOT_STAT_RX_1527_MAX] = {
+		.name = "rx_frames_over_1526_octets",
+		.offset = 0x0F,
+	},
+	[OCELOT_STAT_RX_PAUSE] = {
+		.name = "rx_pause",
+		.offset = 0x10,
+	},
+	[OCELOT_STAT_RX_CONTROL] = {
+		.name = "rx_control",
+		.offset = 0x11,
+	},
+	[OCELOT_STAT_RX_LONGS] = {
+		.name = "rx_longs",
+		.offset = 0x12,
+	},
+	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
+		.name = "rx_classified_drops",
+		.offset = 0x13,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_0] = {
+		.name = "rx_red_prio_0",
+		.offset = 0x14,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_1] = {
+		.name = "rx_red_prio_1",
+		.offset = 0x15,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_2] = {
+		.name = "rx_red_prio_2",
+		.offset = 0x16,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_3] = {
+		.name = "rx_red_prio_3",
+		.offset = 0x17,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_4] = {
+		.name = "rx_red_prio_4",
+		.offset = 0x18,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_5] = {
+		.name = "rx_red_prio_5",
+		.offset = 0x19,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_6] = {
+		.name = "rx_red_prio_6",
+		.offset = 0x1A,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_7] = {
+		.name = "rx_red_prio_7",
+		.offset = 0x1B,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
+		.name = "rx_yellow_prio_0",
+		.offset = 0x1C,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
+		.name = "rx_yellow_prio_1",
+		.offset = 0x1D,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
+		.name = "rx_yellow_prio_2",
+		.offset = 0x1E,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
+		.name = "rx_yellow_prio_3",
+		.offset = 0x1F,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
+		.name = "rx_yellow_prio_4",
+		.offset = 0x20,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
+		.name = "rx_yellow_prio_5",
+		.offset = 0x21,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
+		.name = "rx_yellow_prio_6",
+		.offset = 0x22,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
+		.name = "rx_yellow_prio_7",
+		.offset = 0x23,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
+		.name = "rx_green_prio_0",
+		.offset = 0x24,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
+		.name = "rx_green_prio_1",
+		.offset = 0x25,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
+		.name = "rx_green_prio_2",
+		.offset = 0x26,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
+		.name = "rx_green_prio_3",
+		.offset = 0x27,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
+		.name = "rx_green_prio_4",
+		.offset = 0x28,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
+		.name = "rx_green_prio_5",
+		.offset = 0x29,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
+		.name = "rx_green_prio_6",
+		.offset = 0x2A,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
+		.name = "rx_green_prio_7",
+		.offset = 0x2B,
+	},
+	[OCELOT_STAT_TX_OCTETS] = {
+		.name = "tx_octets",
+		.offset = 0x80,
+	},
+	[OCELOT_STAT_TX_UNICAST] = {
+		.name = "tx_unicast",
+		.offset = 0x81,
+	},
+	[OCELOT_STAT_TX_MULTICAST] = {
+		.name = "tx_multicast",
+		.offset = 0x82,
+	},
+	[OCELOT_STAT_TX_BROADCAST] = {
+		.name = "tx_broadcast",
+		.offset = 0x83,
+	},
+	[OCELOT_STAT_TX_COLLISION] = {
+		.name = "tx_collision",
+		.offset = 0x84,
+	},
+	[OCELOT_STAT_TX_DROPS] = {
+		.name = "tx_drops",
+		.offset = 0x85,
+	},
+	[OCELOT_STAT_TX_PAUSE] = {
+		.name = "tx_pause",
+		.offset = 0x86,
+	},
+	[OCELOT_STAT_TX_64] = {
+		.name = "tx_frames_below_65_octets",
+		.offset = 0x87,
+	},
+	[OCELOT_STAT_TX_65_127] = {
+		.name = "tx_frames_65_to_127_octets",
+		.offset = 0x88,
+	},
+	[OCELOT_STAT_TX_128_255] = {
+		.name = "tx_frames_128_255_octets",
+		.offset = 0x89,
+	},
+	[OCELOT_STAT_TX_256_511] = {
+		.name = "tx_frames_256_511_octets",
+		.offset = 0x8A,
+	},
+	[OCELOT_STAT_TX_512_1023] = {
+		.name = "tx_frames_512_1023_octets",
+		.offset = 0x8B,
+	},
+	[OCELOT_STAT_TX_1024_1526] = {
+		.name = "tx_frames_1024_1526_octets",
+		.offset = 0x8C,
+	},
+	[OCELOT_STAT_TX_1527_MAX] = {
+		.name = "tx_frames_over_1526_octets",
+		.offset = 0x8D,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
+		.name = "tx_yellow_prio_0",
+		.offset = 0x8E,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
+		.name = "tx_yellow_prio_1",
+		.offset = 0x8F,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
+		.name = "tx_yellow_prio_2",
+		.offset = 0x90,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
+		.name = "tx_yellow_prio_3",
+		.offset = 0x91,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
+		.name = "tx_yellow_prio_4",
+		.offset = 0x92,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
+		.name = "tx_yellow_prio_5",
+		.offset = 0x93,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
+		.name = "tx_yellow_prio_6",
+		.offset = 0x94,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
+		.name = "tx_yellow_prio_7",
+		.offset = 0x95,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
+		.name = "tx_green_prio_0",
+		.offset = 0x96,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
+		.name = "tx_green_prio_1",
+		.offset = 0x97,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
+		.name = "tx_green_prio_2",
+		.offset = 0x98,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
+		.name = "tx_green_prio_3",
+		.offset = 0x99,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
+		.name = "tx_green_prio_4",
+		.offset = 0x9A,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
+		.name = "tx_green_prio_5",
+		.offset = 0x9B,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
+		.name = "tx_green_prio_6",
+		.offset = 0x9C,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
+		.name = "tx_green_prio_7",
+		.offset = 0x9D,
+	},
+	[OCELOT_STAT_TX_AGED] = {
+		.name = "tx_aged",
+		.offset = 0x9E,
+	},
+	[OCELOT_STAT_DROP_LOCAL] = {
+		.name = "drop_local",
+		.offset = 0x100,
+	},
+	[OCELOT_STAT_DROP_TAIL] = {
+		.name = "drop_tail",
+		.offset = 0x101,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
+		.name = "drop_yellow_prio_0",
+		.offset = 0x102,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
+		.name = "drop_yellow_prio_1",
+		.offset = 0x103,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
+		.name = "drop_yellow_prio_2",
+		.offset = 0x104,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
+		.name = "drop_yellow_prio_3",
+		.offset = 0x105,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
+		.name = "drop_yellow_prio_4",
+		.offset = 0x106,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
+		.name = "drop_yellow_prio_5",
+		.offset = 0x107,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
+		.name = "drop_yellow_prio_6",
+		.offset = 0x108,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
+		.name = "drop_yellow_prio_7",
+		.offset = 0x109,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
+		.name = "drop_green_prio_0",
+		.offset = 0x10A,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
+		.name = "drop_green_prio_1",
+		.offset = 0x10B,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
+		.name = "drop_green_prio_2",
+		.offset = 0x10C,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
+		.name = "drop_green_prio_3",
+		.offset = 0x10D,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
+		.name = "drop_green_prio_4",
+		.offset = 0x10E,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
+		.name = "drop_green_prio_5",
+		.offset = 0x10F,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
+		.name = "drop_green_prio_6",
+		.offset = 0x110,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
+		.name = "drop_green_prio_7",
+		.offset = 0x111,
+	},
 };
 
 static const struct vcap_field vsc9959_vcap_es0_keys[] = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ebe9ddbbe2b7..fe5d4642d0bc 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -545,101 +545,379 @@ static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
 	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 11, 4),
 };
 
-static const struct ocelot_stat_layout vsc9953_stats_layout[] = {
-	{ .offset = 0x00,	.name = "rx_octets", },
-	{ .offset = 0x01,	.name = "rx_unicast", },
-	{ .offset = 0x02,	.name = "rx_multicast", },
-	{ .offset = 0x03,	.name = "rx_broadcast", },
-	{ .offset = 0x04,	.name = "rx_shorts", },
-	{ .offset = 0x05,	.name = "rx_fragments", },
-	{ .offset = 0x06,	.name = "rx_jabbers", },
-	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
-	{ .offset = 0x08,	.name = "rx_sym_errs", },
-	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
-	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
-	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
-	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
-	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
-	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
-	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
-	{ .offset = 0x10,	.name = "rx_pause", },
-	{ .offset = 0x11,	.name = "rx_control", },
-	{ .offset = 0x12,	.name = "rx_longs", },
-	{ .offset = 0x13,	.name = "rx_classified_drops", },
-	{ .offset = 0x14,	.name = "rx_red_prio_0", },
-	{ .offset = 0x15,	.name = "rx_red_prio_1", },
-	{ .offset = 0x16,	.name = "rx_red_prio_2", },
-	{ .offset = 0x17,	.name = "rx_red_prio_3", },
-	{ .offset = 0x18,	.name = "rx_red_prio_4", },
-	{ .offset = 0x19,	.name = "rx_red_prio_5", },
-	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
-	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
-	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
-	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
-	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
-	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
-	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
-	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
-	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
-	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
-	{ .offset = 0x24,	.name = "rx_green_prio_0", },
-	{ .offset = 0x25,	.name = "rx_green_prio_1", },
-	{ .offset = 0x26,	.name = "rx_green_prio_2", },
-	{ .offset = 0x27,	.name = "rx_green_prio_3", },
-	{ .offset = 0x28,	.name = "rx_green_prio_4", },
-	{ .offset = 0x29,	.name = "rx_green_prio_5", },
-	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
-	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
-	{ .offset = 0x40,	.name = "tx_octets", },
-	{ .offset = 0x41,	.name = "tx_unicast", },
-	{ .offset = 0x42,	.name = "tx_multicast", },
-	{ .offset = 0x43,	.name = "tx_broadcast", },
-	{ .offset = 0x44,	.name = "tx_collision", },
-	{ .offset = 0x45,	.name = "tx_drops", },
-	{ .offset = 0x46,	.name = "tx_pause", },
-	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
-	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
-	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
-	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
-	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
-	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
-	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
-	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
-	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
-	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
-	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
-	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
-	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
-	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
-	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
-	{ .offset = 0x56,	.name = "tx_green_prio_0", },
-	{ .offset = 0x57,	.name = "tx_green_prio_1", },
-	{ .offset = 0x58,	.name = "tx_green_prio_2", },
-	{ .offset = 0x59,	.name = "tx_green_prio_3", },
-	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
-	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
-	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
-	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
-	{ .offset = 0x5E,	.name = "tx_aged", },
-	{ .offset = 0x80,	.name = "drop_local", },
-	{ .offset = 0x81,	.name = "drop_tail", },
-	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
-	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
-	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
-	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
-	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
-	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
-	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
-	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
-	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
-	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
-	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
-	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
-	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
-	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
-	{ .offset = 0x90,	.name = "drop_green_prio_6", },
-	{ .offset = 0x91,	.name = "drop_green_prio_7", },
-	OCELOT_STAT_END
+static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STATS] = {
+	[OCELOT_STAT_RX_OCTETS] = {
+		.name = "rx_octets",
+		.offset = 0x00,
+	},
+	[OCELOT_STAT_RX_UNICAST] = {
+		.name = "rx_unicast",
+		.offset = 0x01,
+	},
+	[OCELOT_STAT_RX_MULTICAST] = {
+		.name = "rx_multicast",
+		.offset = 0x02,
+	},
+	[OCELOT_STAT_RX_BROADCAST] = {
+		.name = "rx_broadcast",
+		.offset = 0x03,
+	},
+	[OCELOT_STAT_RX_SHORTS] = {
+		.name = "rx_shorts",
+		.offset = 0x04,
+	},
+	[OCELOT_STAT_RX_FRAGMENTS] = {
+		.name = "rx_fragments",
+		.offset = 0x05,
+	},
+	[OCELOT_STAT_RX_JABBERS] = {
+		.name = "rx_jabbers",
+		.offset = 0x06,
+	},
+	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
+		.name = "rx_crc_align_errs",
+		.offset = 0x07,
+	},
+	[OCELOT_STAT_RX_SYM_ERRS] = {
+		.name = "rx_sym_errs",
+		.offset = 0x08,
+	},
+	[OCELOT_STAT_RX_64] = {
+		.name = "rx_frames_below_65_octets",
+		.offset = 0x09,
+	},
+	[OCELOT_STAT_RX_65_127] = {
+		.name = "rx_frames_65_to_127_octets",
+		.offset = 0x0A,
+	},
+	[OCELOT_STAT_RX_128_255] = {
+		.name = "rx_frames_128_to_255_octets",
+		.offset = 0x0B,
+	},
+	[OCELOT_STAT_RX_256_511] = {
+		.name = "rx_frames_256_to_511_octets",
+		.offset = 0x0C,
+	},
+	[OCELOT_STAT_RX_512_1023] = {
+		.name = "rx_frames_512_to_1023_octets",
+		.offset = 0x0D,
+	},
+	[OCELOT_STAT_RX_1024_1526] = {
+		.name = "rx_frames_1024_to_1526_octets",
+		.offset = 0x0E,
+	},
+	[OCELOT_STAT_RX_1527_MAX] = {
+		.name = "rx_frames_over_1526_octets",
+		.offset = 0x0F,
+	},
+	[OCELOT_STAT_RX_PAUSE] = {
+		.name = "rx_pause",
+		.offset = 0x10,
+	},
+	[OCELOT_STAT_RX_CONTROL] = {
+		.name = "rx_control",
+		.offset = 0x11,
+	},
+	[OCELOT_STAT_RX_LONGS] = {
+		.name = "rx_longs",
+		.offset = 0x12,
+	},
+	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
+		.name = "rx_classified_drops",
+		.offset = 0x13,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_0] = {
+		.name = "rx_red_prio_0",
+		.offset = 0x14,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_1] = {
+		.name = "rx_red_prio_1",
+		.offset = 0x15,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_2] = {
+		.name = "rx_red_prio_2",
+		.offset = 0x16,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_3] = {
+		.name = "rx_red_prio_3",
+		.offset = 0x17,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_4] = {
+		.name = "rx_red_prio_4",
+		.offset = 0x18,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_5] = {
+		.name = "rx_red_prio_5",
+		.offset = 0x19,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_6] = {
+		.name = "rx_red_prio_6",
+		.offset = 0x1A,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_7] = {
+		.name = "rx_red_prio_7",
+		.offset = 0x1B,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
+		.name = "rx_yellow_prio_0",
+		.offset = 0x1C,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
+		.name = "rx_yellow_prio_1",
+		.offset = 0x1D,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
+		.name = "rx_yellow_prio_2",
+		.offset = 0x1E,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
+		.name = "rx_yellow_prio_3",
+		.offset = 0x1F,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
+		.name = "rx_yellow_prio_4",
+		.offset = 0x20,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
+		.name = "rx_yellow_prio_5",
+		.offset = 0x21,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
+		.name = "rx_yellow_prio_6",
+		.offset = 0x22,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
+		.name = "rx_yellow_prio_7",
+		.offset = 0x23,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
+		.name = "rx_green_prio_0",
+		.offset = 0x24,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
+		.name = "rx_green_prio_1",
+		.offset = 0x25,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
+		.name = "rx_green_prio_2",
+		.offset = 0x26,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
+		.name = "rx_green_prio_3",
+		.offset = 0x27,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
+		.name = "rx_green_prio_4",
+		.offset = 0x28,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
+		.name = "rx_green_prio_5",
+		.offset = 0x29,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
+		.name = "rx_green_prio_6",
+		.offset = 0x2A,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
+		.name = "rx_green_prio_7",
+		.offset = 0x2B,
+	},
+	[OCELOT_STAT_TX_OCTETS] = {
+		.name = "tx_octets",
+		.offset = 0x40,
+	},
+	[OCELOT_STAT_TX_UNICAST] = {
+		.name = "tx_unicast",
+		.offset = 0x41,
+	},
+	[OCELOT_STAT_TX_MULTICAST] = {
+		.name = "tx_multicast",
+		.offset = 0x42,
+	},
+	[OCELOT_STAT_TX_BROADCAST] = {
+		.name = "tx_broadcast",
+		.offset = 0x43,
+	},
+	[OCELOT_STAT_TX_COLLISION] = {
+		.name = "tx_collision",
+		.offset = 0x44,
+	},
+	[OCELOT_STAT_TX_DROPS] = {
+		.name = "tx_drops",
+		.offset = 0x45,
+	},
+	[OCELOT_STAT_TX_PAUSE] = {
+		.name = "tx_pause",
+		.offset = 0x46,
+	},
+	[OCELOT_STAT_TX_64] = {
+		.name = "tx_frames_below_65_octets",
+		.offset = 0x47,
+	},
+	[OCELOT_STAT_TX_65_127] = {
+		.name = "tx_frames_65_to_127_octets",
+		.offset = 0x48,
+	},
+	[OCELOT_STAT_TX_128_255] = {
+		.name = "tx_frames_128_255_octets",
+		.offset = 0x49,
+	},
+	[OCELOT_STAT_TX_256_511] = {
+		.name = "tx_frames_256_511_octets",
+		.offset = 0x4A,
+	},
+	[OCELOT_STAT_TX_512_1023] = {
+		.name = "tx_frames_512_1023_octets",
+		.offset = 0x4B,
+	},
+	[OCELOT_STAT_TX_1024_1526] = {
+		.name = "tx_frames_1024_1526_octets",
+		.offset = 0x4C,
+	},
+	[OCELOT_STAT_TX_1527_MAX] = {
+		.name = "tx_frames_over_1526_octets",
+		.offset = 0x4D,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
+		.name = "tx_yellow_prio_0",
+		.offset = 0x4E,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
+		.name = "tx_yellow_prio_1",
+		.offset = 0x4F,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
+		.name = "tx_yellow_prio_2",
+		.offset = 0x50,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
+		.name = "tx_yellow_prio_3",
+		.offset = 0x51,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
+		.name = "tx_yellow_prio_4",
+		.offset = 0x52,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
+		.name = "tx_yellow_prio_5",
+		.offset = 0x53,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
+		.name = "tx_yellow_prio_6",
+		.offset = 0x54,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
+		.name = "tx_yellow_prio_7",
+		.offset = 0x55,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
+		.name = "tx_green_prio_0",
+		.offset = 0x56,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
+		.name = "tx_green_prio_1",
+		.offset = 0x57,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
+		.name = "tx_green_prio_2",
+		.offset = 0x58,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
+		.name = "tx_green_prio_3",
+		.offset = 0x59,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
+		.name = "tx_green_prio_4",
+		.offset = 0x5A,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
+		.name = "tx_green_prio_5",
+		.offset = 0x5B,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
+		.name = "tx_green_prio_6",
+		.offset = 0x5C,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
+		.name = "tx_green_prio_7",
+		.offset = 0x5D,
+	},
+	[OCELOT_STAT_TX_AGED] = {
+		.name = "tx_aged",
+		.offset = 0x5E,
+	},
+	[OCELOT_STAT_DROP_LOCAL] = {
+		.name = "drop_local",
+		.offset = 0x80,
+	},
+	[OCELOT_STAT_DROP_TAIL] = {
+		.name = "drop_tail",
+		.offset = 0x81,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
+		.name = "drop_yellow_prio_0",
+		.offset = 0x82,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
+		.name = "drop_yellow_prio_1",
+		.offset = 0x83,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
+		.name = "drop_yellow_prio_2",
+		.offset = 0x84,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
+		.name = "drop_yellow_prio_3",
+		.offset = 0x85,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
+		.name = "drop_yellow_prio_4",
+		.offset = 0x86,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
+		.name = "drop_yellow_prio_5",
+		.offset = 0x87,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
+		.name = "drop_yellow_prio_6",
+		.offset = 0x88,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
+		.name = "drop_yellow_prio_7",
+		.offset = 0x89,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
+		.name = "drop_green_prio_0",
+		.offset = 0x8A,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
+		.name = "drop_green_prio_1",
+		.offset = 0x8B,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
+		.name = "drop_green_prio_2",
+		.offset = 0x8C,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
+		.name = "drop_green_prio_3",
+		.offset = 0x8D,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
+		.name = "drop_green_prio_4",
+		.offset = 0x8E,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
+		.name = "drop_green_prio_5",
+		.offset = 0x8F,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
+		.name = "drop_green_prio_6",
+		.offset = 0x90,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
+		.name = "drop_green_prio_7",
+		.offset = 0x91,
+	},
 };
 
 static const struct vcap_field vsc9953_vcap_es0_keys[] = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c67f162f8ab5..68991b021c56 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1860,16 +1860,20 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 	if (sset != ETH_SS_STATS)
 		return;
 
-	for (i = 0; i < ocelot->num_stats; i++)
+	for (i = 0; i < OCELOT_NUM_STATS; i++) {
+		if (ocelot->stats_layout[i].name[0] == '\0')
+			continue;
+
 		memcpy(data + i * ETH_GSTRING_LEN, ocelot->stats_layout[i].name,
 		       ETH_GSTRING_LEN);
+	}
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
 /* Caller must hold &ocelot->stats_lock */
 static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
 {
-	unsigned int idx = port * ocelot->num_stats;
+	unsigned int idx = port * OCELOT_NUM_STATS;
 	struct ocelot_stats_region *region;
 	int err, j;
 
@@ -1930,9 +1934,15 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 	/* check and update now */
 	err = ocelot_port_update_stats(ocelot, port);
 
-	/* Copy all counters */
-	for (i = 0; i < ocelot->num_stats; i++)
-		*data++ = ocelot->stats[port * ocelot->num_stats + i];
+	/* Copy all supported counters */
+	for (i = 0; i < OCELOT_NUM_STATS; i++) {
+		int index = port * OCELOT_NUM_STATS + i;
+
+		if (ocelot->stats_layout[i].name[0] == '\0')
+			continue;
+
+		*data++ = ocelot->stats[index];
+	}
 
 	spin_unlock(&ocelot->stats_lock);
 
@@ -1943,10 +1953,16 @@ EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 {
+	int i, num_stats = 0;
+
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
-	return ocelot->num_stats;
+	for (i = 0; i < OCELOT_NUM_STATS; i++)
+		if (ocelot->stats_layout[i].name[0] != '\0')
+			num_stats++;
+
+	return num_stats;
 }
 EXPORT_SYMBOL(ocelot_get_sset_count);
 
@@ -1958,7 +1974,10 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 
 	INIT_LIST_HEAD(&ocelot->stats_regions);
 
-	for (i = 0; i < ocelot->num_stats; i++) {
+	for (i = 0; i < OCELOT_NUM_STATS; i++) {
+		if (ocelot->stats_layout[i].name[0] == '\0')
+			continue;
+
 		if (region && ocelot->stats_layout[i].offset == last + 1) {
 			region->count++;
 		} else {
@@ -3340,7 +3359,6 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 
 int ocelot_init(struct ocelot *ocelot)
 {
-	const struct ocelot_stat_layout *stat;
 	char queue_name[32];
 	int i, ret;
 	u32 port;
@@ -3353,12 +3371,8 @@ int ocelot_init(struct ocelot *ocelot)
 		}
 	}
 
-	ocelot->num_stats = 0;
-	for_each_stat(ocelot, stat)
-		ocelot->num_stats++;
-
 	ocelot->stats = devm_kcalloc(ocelot->dev,
-				     ocelot->num_phys_ports * ocelot->num_stats,
+				     ocelot->num_phys_ports * OCELOT_NUM_STATS,
 				     sizeof(u64), GFP_KERNEL);
 	if (!ocelot->stats)
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 961f803aca19..9ff910560043 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -96,101 +96,379 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[] = {
-	{ .name = "rx_octets", .offset = 0x00, },
-	{ .name = "rx_unicast", .offset = 0x01, },
-	{ .name = "rx_multicast", .offset = 0x02, },
-	{ .name = "rx_broadcast", .offset = 0x03, },
-	{ .name = "rx_shorts", .offset = 0x04, },
-	{ .name = "rx_fragments", .offset = 0x05, },
-	{ .name = "rx_jabbers", .offset = 0x06, },
-	{ .name = "rx_crc_align_errs", .offset = 0x07, },
-	{ .name = "rx_sym_errs", .offset = 0x08, },
-	{ .name = "rx_frames_below_65_octets", .offset = 0x09, },
-	{ .name = "rx_frames_65_to_127_octets", .offset = 0x0A, },
-	{ .name = "rx_frames_128_to_255_octets", .offset = 0x0B, },
-	{ .name = "rx_frames_256_to_511_octets", .offset = 0x0C, },
-	{ .name = "rx_frames_512_to_1023_octets", .offset = 0x0D, },
-	{ .name = "rx_frames_1024_to_1526_octets", .offset = 0x0E, },
-	{ .name = "rx_frames_over_1526_octets", .offset = 0x0F, },
-	{ .name = "rx_pause", .offset = 0x10, },
-	{ .name = "rx_control", .offset = 0x11, },
-	{ .name = "rx_longs", .offset = 0x12, },
-	{ .name = "rx_classified_drops", .offset = 0x13, },
-	{ .name = "rx_red_prio_0", .offset = 0x14, },
-	{ .name = "rx_red_prio_1", .offset = 0x15, },
-	{ .name = "rx_red_prio_2", .offset = 0x16, },
-	{ .name = "rx_red_prio_3", .offset = 0x17, },
-	{ .name = "rx_red_prio_4", .offset = 0x18, },
-	{ .name = "rx_red_prio_5", .offset = 0x19, },
-	{ .name = "rx_red_prio_6", .offset = 0x1A, },
-	{ .name = "rx_red_prio_7", .offset = 0x1B, },
-	{ .name = "rx_yellow_prio_0", .offset = 0x1C, },
-	{ .name = "rx_yellow_prio_1", .offset = 0x1D, },
-	{ .name = "rx_yellow_prio_2", .offset = 0x1E, },
-	{ .name = "rx_yellow_prio_3", .offset = 0x1F, },
-	{ .name = "rx_yellow_prio_4", .offset = 0x20, },
-	{ .name = "rx_yellow_prio_5", .offset = 0x21, },
-	{ .name = "rx_yellow_prio_6", .offset = 0x22, },
-	{ .name = "rx_yellow_prio_7", .offset = 0x23, },
-	{ .name = "rx_green_prio_0", .offset = 0x24, },
-	{ .name = "rx_green_prio_1", .offset = 0x25, },
-	{ .name = "rx_green_prio_2", .offset = 0x26, },
-	{ .name = "rx_green_prio_3", .offset = 0x27, },
-	{ .name = "rx_green_prio_4", .offset = 0x28, },
-	{ .name = "rx_green_prio_5", .offset = 0x29, },
-	{ .name = "rx_green_prio_6", .offset = 0x2A, },
-	{ .name = "rx_green_prio_7", .offset = 0x2B, },
-	{ .name = "tx_octets", .offset = 0x40, },
-	{ .name = "tx_unicast", .offset = 0x41, },
-	{ .name = "tx_multicast", .offset = 0x42, },
-	{ .name = "tx_broadcast", .offset = 0x43, },
-	{ .name = "tx_collision", .offset = 0x44, },
-	{ .name = "tx_drops", .offset = 0x45, },
-	{ .name = "tx_pause", .offset = 0x46, },
-	{ .name = "tx_frames_below_65_octets", .offset = 0x47, },
-	{ .name = "tx_frames_65_to_127_octets", .offset = 0x48, },
-	{ .name = "tx_frames_128_255_octets", .offset = 0x49, },
-	{ .name = "tx_frames_256_511_octets", .offset = 0x4A, },
-	{ .name = "tx_frames_512_1023_octets", .offset = 0x4B, },
-	{ .name = "tx_frames_1024_1526_octets", .offset = 0x4C, },
-	{ .name = "tx_frames_over_1526_octets", .offset = 0x4D, },
-	{ .name = "tx_yellow_prio_0", .offset = 0x4E, },
-	{ .name = "tx_yellow_prio_1", .offset = 0x4F, },
-	{ .name = "tx_yellow_prio_2", .offset = 0x50, },
-	{ .name = "tx_yellow_prio_3", .offset = 0x51, },
-	{ .name = "tx_yellow_prio_4", .offset = 0x52, },
-	{ .name = "tx_yellow_prio_5", .offset = 0x53, },
-	{ .name = "tx_yellow_prio_6", .offset = 0x54, },
-	{ .name = "tx_yellow_prio_7", .offset = 0x55, },
-	{ .name = "tx_green_prio_0", .offset = 0x56, },
-	{ .name = "tx_green_prio_1", .offset = 0x57, },
-	{ .name = "tx_green_prio_2", .offset = 0x58, },
-	{ .name = "tx_green_prio_3", .offset = 0x59, },
-	{ .name = "tx_green_prio_4", .offset = 0x5A, },
-	{ .name = "tx_green_prio_5", .offset = 0x5B, },
-	{ .name = "tx_green_prio_6", .offset = 0x5C, },
-	{ .name = "tx_green_prio_7", .offset = 0x5D, },
-	{ .name = "tx_aged", .offset = 0x5E, },
-	{ .name = "drop_local", .offset = 0x80, },
-	{ .name = "drop_tail", .offset = 0x81, },
-	{ .name = "drop_yellow_prio_0", .offset = 0x82, },
-	{ .name = "drop_yellow_prio_1", .offset = 0x83, },
-	{ .name = "drop_yellow_prio_2", .offset = 0x84, },
-	{ .name = "drop_yellow_prio_3", .offset = 0x85, },
-	{ .name = "drop_yellow_prio_4", .offset = 0x86, },
-	{ .name = "drop_yellow_prio_5", .offset = 0x87, },
-	{ .name = "drop_yellow_prio_6", .offset = 0x88, },
-	{ .name = "drop_yellow_prio_7", .offset = 0x89, },
-	{ .name = "drop_green_prio_0", .offset = 0x8A, },
-	{ .name = "drop_green_prio_1", .offset = 0x8B, },
-	{ .name = "drop_green_prio_2", .offset = 0x8C, },
-	{ .name = "drop_green_prio_3", .offset = 0x8D, },
-	{ .name = "drop_green_prio_4", .offset = 0x8E, },
-	{ .name = "drop_green_prio_5", .offset = 0x8F, },
-	{ .name = "drop_green_prio_6", .offset = 0x90, },
-	{ .name = "drop_green_prio_7", .offset = 0x91, },
-	OCELOT_STAT_END
+static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
+	[OCELOT_STAT_RX_OCTETS] = {
+		.name = "rx_octets",
+		.offset = 0x00,
+	},
+	[OCELOT_STAT_RX_UNICAST] = {
+		.name = "rx_unicast",
+		.offset = 0x01,
+	},
+	[OCELOT_STAT_RX_MULTICAST] = {
+		.name = "rx_multicast",
+		.offset = 0x02,
+	},
+	[OCELOT_STAT_RX_BROADCAST] = {
+		.name = "rx_broadcast",
+		.offset = 0x03,
+	},
+	[OCELOT_STAT_RX_SHORTS] = {
+		.name = "rx_shorts",
+		.offset = 0x04,
+	},
+	[OCELOT_STAT_RX_FRAGMENTS] = {
+		.name = "rx_fragments",
+		.offset = 0x05,
+	},
+	[OCELOT_STAT_RX_JABBERS] = {
+		.name = "rx_jabbers",
+		.offset = 0x06,
+	},
+	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
+		.name = "rx_crc_align_errs",
+		.offset = 0x07,
+	},
+	[OCELOT_STAT_RX_SYM_ERRS] = {
+		.name = "rx_sym_errs",
+		.offset = 0x08,
+	},
+	[OCELOT_STAT_RX_64] = {
+		.name = "rx_frames_below_65_octets",
+		.offset = 0x09,
+	},
+	[OCELOT_STAT_RX_65_127] = {
+		.name = "rx_frames_65_to_127_octets",
+		.offset = 0x0A,
+	},
+	[OCELOT_STAT_RX_128_255] = {
+		.name = "rx_frames_128_to_255_octets",
+		.offset = 0x0B,
+	},
+	[OCELOT_STAT_RX_256_511] = {
+		.name = "rx_frames_256_to_511_octets",
+		.offset = 0x0C,
+	},
+	[OCELOT_STAT_RX_512_1023] = {
+		.name = "rx_frames_512_to_1023_octets",
+		.offset = 0x0D,
+	},
+	[OCELOT_STAT_RX_1024_1526] = {
+		.name = "rx_frames_1024_to_1526_octets",
+		.offset = 0x0E,
+	},
+	[OCELOT_STAT_RX_1527_MAX] = {
+		.name = "rx_frames_over_1526_octets",
+		.offset = 0x0F,
+	},
+	[OCELOT_STAT_RX_PAUSE] = {
+		.name = "rx_pause",
+		.offset = 0x10,
+	},
+	[OCELOT_STAT_RX_CONTROL] = {
+		.name = "rx_control",
+		.offset = 0x11,
+	},
+	[OCELOT_STAT_RX_LONGS] = {
+		.name = "rx_longs",
+		.offset = 0x12,
+	},
+	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
+		.name = "rx_classified_drops",
+		.offset = 0x13,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_0] = {
+		.name = "rx_red_prio_0",
+		.offset = 0x14,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_1] = {
+		.name = "rx_red_prio_1",
+		.offset = 0x15,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_2] = {
+		.name = "rx_red_prio_2",
+		.offset = 0x16,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_3] = {
+		.name = "rx_red_prio_3",
+		.offset = 0x17,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_4] = {
+		.name = "rx_red_prio_4",
+		.offset = 0x18,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_5] = {
+		.name = "rx_red_prio_5",
+		.offset = 0x19,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_6] = {
+		.name = "rx_red_prio_6",
+		.offset = 0x1A,
+	},
+	[OCELOT_STAT_RX_RED_PRIO_7] = {
+		.name = "rx_red_prio_7",
+		.offset = 0x1B,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
+		.name = "rx_yellow_prio_0",
+		.offset = 0x1C,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
+		.name = "rx_yellow_prio_1",
+		.offset = 0x1D,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
+		.name = "rx_yellow_prio_2",
+		.offset = 0x1E,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
+		.name = "rx_yellow_prio_3",
+		.offset = 0x1F,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
+		.name = "rx_yellow_prio_4",
+		.offset = 0x20,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
+		.name = "rx_yellow_prio_5",
+		.offset = 0x21,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
+		.name = "rx_yellow_prio_6",
+		.offset = 0x22,
+	},
+	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
+		.name = "rx_yellow_prio_7",
+		.offset = 0x23,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
+		.name = "rx_green_prio_0",
+		.offset = 0x24,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
+		.name = "rx_green_prio_1",
+		.offset = 0x25,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
+		.name = "rx_green_prio_2",
+		.offset = 0x26,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
+		.name = "rx_green_prio_3",
+		.offset = 0x27,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
+		.name = "rx_green_prio_4",
+		.offset = 0x28,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
+		.name = "rx_green_prio_5",
+		.offset = 0x29,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
+		.name = "rx_green_prio_6",
+		.offset = 0x2A,
+	},
+	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
+		.name = "rx_green_prio_7",
+		.offset = 0x2B,
+	},
+	[OCELOT_STAT_TX_OCTETS] = {
+		.name = "tx_octets",
+		.offset = 0x40,
+	},
+	[OCELOT_STAT_TX_UNICAST] = {
+		.name = "tx_unicast",
+		.offset = 0x41,
+	},
+	[OCELOT_STAT_TX_MULTICAST] = {
+		.name = "tx_multicast",
+		.offset = 0x42,
+	},
+	[OCELOT_STAT_TX_BROADCAST] = {
+		.name = "tx_broadcast",
+		.offset = 0x43,
+	},
+	[OCELOT_STAT_TX_COLLISION] = {
+		.name = "tx_collision",
+		.offset = 0x44,
+	},
+	[OCELOT_STAT_TX_DROPS] = {
+		.name = "tx_drops",
+		.offset = 0x45,
+	},
+	[OCELOT_STAT_TX_PAUSE] = {
+		.name = "tx_pause",
+		.offset = 0x46,
+	},
+	[OCELOT_STAT_TX_64] = {
+		.name = "tx_frames_below_65_octets",
+		.offset = 0x47,
+	},
+	[OCELOT_STAT_TX_65_127] = {
+		.name = "tx_frames_65_to_127_octets",
+		.offset = 0x48,
+	},
+	[OCELOT_STAT_TX_128_255] = {
+		.name = "tx_frames_128_255_octets",
+		.offset = 0x49,
+	},
+	[OCELOT_STAT_TX_256_511] = {
+		.name = "tx_frames_256_511_octets",
+		.offset = 0x4A,
+	},
+	[OCELOT_STAT_TX_512_1023] = {
+		.name = "tx_frames_512_1023_octets",
+		.offset = 0x4B,
+	},
+	[OCELOT_STAT_TX_1024_1526] = {
+		.name = "tx_frames_1024_1526_octets",
+		.offset = 0x4C,
+	},
+	[OCELOT_STAT_TX_1527_MAX] = {
+		.name = "tx_frames_over_1526_octets",
+		.offset = 0x4D,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
+		.name = "tx_yellow_prio_0",
+		.offset = 0x4E,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
+		.name = "tx_yellow_prio_1",
+		.offset = 0x4F,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
+		.name = "tx_yellow_prio_2",
+		.offset = 0x50,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
+		.name = "tx_yellow_prio_3",
+		.offset = 0x51,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
+		.name = "tx_yellow_prio_4",
+		.offset = 0x52,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
+		.name = "tx_yellow_prio_5",
+		.offset = 0x53,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
+		.name = "tx_yellow_prio_6",
+		.offset = 0x54,
+	},
+	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
+		.name = "tx_yellow_prio_7",
+		.offset = 0x55,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
+		.name = "tx_green_prio_0",
+		.offset = 0x56,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
+		.name = "tx_green_prio_1",
+		.offset = 0x57,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
+		.name = "tx_green_prio_2",
+		.offset = 0x58,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
+		.name = "tx_green_prio_3",
+		.offset = 0x59,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
+		.name = "tx_green_prio_4",
+		.offset = 0x5A,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
+		.name = "tx_green_prio_5",
+		.offset = 0x5B,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
+		.name = "tx_green_prio_6",
+		.offset = 0x5C,
+	},
+	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
+		.name = "tx_green_prio_7",
+		.offset = 0x5D,
+	},
+	[OCELOT_STAT_TX_AGED] = {
+		.name = "tx_aged",
+		.offset = 0x5E,
+	},
+	[OCELOT_STAT_DROP_LOCAL] = {
+		.name = "drop_local",
+		.offset = 0x80,
+	},
+	[OCELOT_STAT_DROP_TAIL] = {
+		.name = "drop_tail",
+		.offset = 0x81,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
+		.name = "drop_yellow_prio_0",
+		.offset = 0x82,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
+		.name = "drop_yellow_prio_1",
+		.offset = 0x83,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
+		.name = "drop_yellow_prio_2",
+		.offset = 0x84,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
+		.name = "drop_yellow_prio_3",
+		.offset = 0x85,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
+		.name = "drop_yellow_prio_4",
+		.offset = 0x86,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
+		.name = "drop_yellow_prio_5",
+		.offset = 0x87,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
+		.name = "drop_yellow_prio_6",
+		.offset = 0x88,
+	},
+	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
+		.name = "drop_yellow_prio_7",
+		.offset = 0x89,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
+		.name = "drop_green_prio_0",
+		.offset = 0x8A,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
+		.name = "drop_green_prio_1",
+		.offset = 0x8B,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
+		.name = "drop_green_prio_2",
+		.offset = 0x8C,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
+		.name = "drop_green_prio_3",
+		.offset = 0x8D,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
+		.name = "drop_green_prio_4",
+		.offset = 0x8E,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
+		.name = "drop_green_prio_5",
+		.offset = 0x8F,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
+		.name = "drop_green_prio_6",
+		.offset = 0x90,
+	},
+	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
+		.name = "drop_green_prio_7",
+		.offset = 0x91,
+	},
 };
 
 static void ocelot_pll5_init(struct ocelot *ocelot)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 72b9474391da..2428bc64cb1d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -105,11 +105,6 @@
 #define REG_RESERVED_ADDR		0xffffffff
 #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
 
-#define for_each_stat(ocelot, stat)				\
-	for ((stat) = (ocelot)->stats_layout;			\
-	     ((stat)->name[0] != '\0');				\
-	     (stat)++)
-
 enum ocelot_target {
 	ANA = 1,
 	QS,
@@ -540,13 +535,108 @@ enum ocelot_ptp_pins {
 	TOD_ACC_PIN
 };
 
+enum ocelot_stat {
+	OCELOT_STAT_RX_OCTETS,
+	OCELOT_STAT_RX_UNICAST,
+	OCELOT_STAT_RX_MULTICAST,
+	OCELOT_STAT_RX_BROADCAST,
+	OCELOT_STAT_RX_SHORTS,
+	OCELOT_STAT_RX_FRAGMENTS,
+	OCELOT_STAT_RX_JABBERS,
+	OCELOT_STAT_RX_CRC_ALIGN_ERRS,
+	OCELOT_STAT_RX_SYM_ERRS,
+	OCELOT_STAT_RX_64,
+	OCELOT_STAT_RX_65_127,
+	OCELOT_STAT_RX_128_255,
+	OCELOT_STAT_RX_256_511,
+	OCELOT_STAT_RX_512_1023,
+	OCELOT_STAT_RX_1024_1526,
+	OCELOT_STAT_RX_1527_MAX,
+	OCELOT_STAT_RX_PAUSE,
+	OCELOT_STAT_RX_CONTROL,
+	OCELOT_STAT_RX_LONGS,
+	OCELOT_STAT_RX_CLASSIFIED_DROPS,
+	OCELOT_STAT_RX_RED_PRIO_0,
+	OCELOT_STAT_RX_RED_PRIO_1,
+	OCELOT_STAT_RX_RED_PRIO_2,
+	OCELOT_STAT_RX_RED_PRIO_3,
+	OCELOT_STAT_RX_RED_PRIO_4,
+	OCELOT_STAT_RX_RED_PRIO_5,
+	OCELOT_STAT_RX_RED_PRIO_6,
+	OCELOT_STAT_RX_RED_PRIO_7,
+	OCELOT_STAT_RX_YELLOW_PRIO_0,
+	OCELOT_STAT_RX_YELLOW_PRIO_1,
+	OCELOT_STAT_RX_YELLOW_PRIO_2,
+	OCELOT_STAT_RX_YELLOW_PRIO_3,
+	OCELOT_STAT_RX_YELLOW_PRIO_4,
+	OCELOT_STAT_RX_YELLOW_PRIO_5,
+	OCELOT_STAT_RX_YELLOW_PRIO_6,
+	OCELOT_STAT_RX_YELLOW_PRIO_7,
+	OCELOT_STAT_RX_GREEN_PRIO_0,
+	OCELOT_STAT_RX_GREEN_PRIO_1,
+	OCELOT_STAT_RX_GREEN_PRIO_2,
+	OCELOT_STAT_RX_GREEN_PRIO_3,
+	OCELOT_STAT_RX_GREEN_PRIO_4,
+	OCELOT_STAT_RX_GREEN_PRIO_5,
+	OCELOT_STAT_RX_GREEN_PRIO_6,
+	OCELOT_STAT_RX_GREEN_PRIO_7,
+	OCELOT_STAT_TX_OCTETS,
+	OCELOT_STAT_TX_UNICAST,
+	OCELOT_STAT_TX_MULTICAST,
+	OCELOT_STAT_TX_BROADCAST,
+	OCELOT_STAT_TX_COLLISION,
+	OCELOT_STAT_TX_DROPS,
+	OCELOT_STAT_TX_PAUSE,
+	OCELOT_STAT_TX_64,
+	OCELOT_STAT_TX_65_127,
+	OCELOT_STAT_TX_128_255,
+	OCELOT_STAT_TX_256_511,
+	OCELOT_STAT_TX_512_1023,
+	OCELOT_STAT_TX_1024_1526,
+	OCELOT_STAT_TX_1527_MAX,
+	OCELOT_STAT_TX_YELLOW_PRIO_0,
+	OCELOT_STAT_TX_YELLOW_PRIO_1,
+	OCELOT_STAT_TX_YELLOW_PRIO_2,
+	OCELOT_STAT_TX_YELLOW_PRIO_3,
+	OCELOT_STAT_TX_YELLOW_PRIO_4,
+	OCELOT_STAT_TX_YELLOW_PRIO_5,
+	OCELOT_STAT_TX_YELLOW_PRIO_6,
+	OCELOT_STAT_TX_YELLOW_PRIO_7,
+	OCELOT_STAT_TX_GREEN_PRIO_0,
+	OCELOT_STAT_TX_GREEN_PRIO_1,
+	OCELOT_STAT_TX_GREEN_PRIO_2,
+	OCELOT_STAT_TX_GREEN_PRIO_3,
+	OCELOT_STAT_TX_GREEN_PRIO_4,
+	OCELOT_STAT_TX_GREEN_PRIO_5,
+	OCELOT_STAT_TX_GREEN_PRIO_6,
+	OCELOT_STAT_TX_GREEN_PRIO_7,
+	OCELOT_STAT_TX_AGED,
+	OCELOT_STAT_DROP_LOCAL,
+	OCELOT_STAT_DROP_TAIL,
+	OCELOT_STAT_DROP_YELLOW_PRIO_0,
+	OCELOT_STAT_DROP_YELLOW_PRIO_1,
+	OCELOT_STAT_DROP_YELLOW_PRIO_2,
+	OCELOT_STAT_DROP_YELLOW_PRIO_3,
+	OCELOT_STAT_DROP_YELLOW_PRIO_4,
+	OCELOT_STAT_DROP_YELLOW_PRIO_5,
+	OCELOT_STAT_DROP_YELLOW_PRIO_6,
+	OCELOT_STAT_DROP_YELLOW_PRIO_7,
+	OCELOT_STAT_DROP_GREEN_PRIO_0,
+	OCELOT_STAT_DROP_GREEN_PRIO_1,
+	OCELOT_STAT_DROP_GREEN_PRIO_2,
+	OCELOT_STAT_DROP_GREEN_PRIO_3,
+	OCELOT_STAT_DROP_GREEN_PRIO_4,
+	OCELOT_STAT_DROP_GREEN_PRIO_5,
+	OCELOT_STAT_DROP_GREEN_PRIO_6,
+	OCELOT_STAT_DROP_GREEN_PRIO_7,
+	OCELOT_NUM_STATS,
+};
+
 struct ocelot_stat_layout {
 	u32 offset;
 	char name[ETH_GSTRING_LEN];
 };
 
-#define OCELOT_STAT_END { .name = "" }
-
 struct ocelot_stats_region {
 	struct list_head node;
 	u32 offset;
@@ -709,7 +799,6 @@ struct ocelot {
 	const u32 *const		*map;
 	const struct ocelot_stat_layout	*stats_layout;
 	struct list_head		stats_regions;
-	unsigned int			num_stats;
 
 	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
 	int				packet_buffer_size;
-- 
2.34.1

