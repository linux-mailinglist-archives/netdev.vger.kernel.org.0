Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F7D66D92F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbjAQJEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbjAQJBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:45 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2079.outbound.protection.outlook.com [40.107.13.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46CF22A1D;
        Tue, 17 Jan 2023 01:00:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcIx4hozDRBd6ibeK5zxzLk80rEMlpnA/FjGQod8qxyOXmQfOYHgyaAJ900OONj4ERfJ0l6iucG3pAXI8TYiP2UdRkdKMn7eOTuewyo0Sod6P7u1RiC1468XmSv1pcBGZh6ASbDB+BD7MfOA8P2b0UsOeXrNkDlsdNUeLFSuKWr3zx2B1sDo8qcBKx/Swjp3If284TQVfo0pAqS+uF9i61SoUn428dTrBv/FsIY0QZxELHi5meZwo3iUrkSbXRG6EjkPT4bPXgSAAX/KDGeU+UqAyAMCEYLXWRyYTUp1eqNlqEek5NaeBiLH536C9zM6DkNqKzUjZnRr7JBvAmHZnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1eeoWzge5aHMbkgOjO8OZXBKJ8tt7f+gGhi/Pki6myQ=;
 b=h+t059QP0MaY1wxzJ9tGRrnALH8+VAWLKoAN1Q+AzZwcRIYv+jdjelNMm5mwsSwjLHylHfgL+U4IztNmF0C8revOEzbaEonGhbb9QiTbpBrluHQWMY0gJKSmO5yaOyL6wLzmt835fmyeZgP9hd9z+Ns7w4kmrtPhxS5M9l9rGs520VEelkmJXQdFFc6cynZjWRi8FyQgE2ceKrKkL4JyAvxdBsOeirmHcfb3qpEc/C3oOCmm4+MbbsQwdMhXAywc45PToD6D3a2Hu/a+sOmJKgnbyhva9rODTRQrJFnuVGOofsPmDNzEAekpLE9W/m1gFPOEId2hQEAtMeO+mbEzbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1eeoWzge5aHMbkgOjO8OZXBKJ8tt7f+gGhi/Pki6myQ=;
 b=gj+dqQ2X1h+6Y0uvTHUrUyBiFBWg5os2tyjZjsmtJADJQhInxlLMcE6SSoQQvWNmbghsv3oSIf7xNPhwzPA2TuPhvn1HpVwXs9inEdgfLxD9MEmcIedRbCfzRlJkI83e/X3L3rRZhsvjTY0mhKbkwkV5kiyKWVNB62isKfrWFIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 09:00:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 net-next 11/12] net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
Date:   Tue, 17 Jan 2023 10:59:46 +0200
Message-Id: <20230117085947.2176464-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: da4f76e8-95f6-4c6f-a473-08daf86940f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BsOiolfJ/gteefso1ZDQr3Y5o54nWZZBCJRuE6uA6/harxZVbywa8dirQsjx7zxAw8lUTGYtOEsJf5ydKNGV/a8cbhGhwWIkVF3KA8XbDZci/t/8PKODsDjkPrOrjX9FMsmL3J72tAWO9wY+1j8OLyuLD6Rsrxua0hyVe06mTdjpDfpbxwYtlMrcI7m8j3mFmIaV8d71mHC5QXIGcB2HTmjjCuyAfoqWo5vYy8aBG9YlYlIt88bgPDy9D1EqztwMHDgKmyqHSKXUfE0ZPS/51gORK9kzfHdQjp4GtEfDQIZ0yeLav+eNkX1EbIP4/khXEdOuxbFane/e6RP9Lwza7xtOqb58Lfc2KjzAR1E4giR75SwHlc21rFVK2ih1FKyyO8gUIbqrqzlcU0wb6Cju9g/kSEOZdaZs4hjMd61pDyx6biqUEcsvRcVDk9R5n3cyipyhijMognisgJbZEeeCuXk7Dl8K/145uBmGzMka74pnbdS5VPbRwXxZEEcT6leKTDmBI7aM3/kRsZpyndXfq3jjyBUMx7bW6TsCpxomeF1MidNKy6TvYTPL1gCR9Xd8GR5XRvXQRj6cxjhVxs1IAPlcWude5Tr1A0O0htmrlRC+W3yRcjcG1B0qc2FSTKBVzG4yMgdfQbIeXcZFNavNsLglhw6Anolic7KgNoOn2g1JTK7VKoQ198XL9bf69HUZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(36756003)(86362001)(186003)(6916009)(4326008)(6512007)(8676002)(26005)(66556008)(41300700001)(66476007)(66946007)(2616005)(1076003)(316002)(6506007)(52116002)(6666004)(54906003)(478600001)(44832011)(6486002)(2906002)(7416002)(38100700002)(38350700002)(83380400001)(5660300002)(30864003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NJ0iuxP8W6j8FKnVkhuJ3LUgzGMBN4N5ybZMUzSG0hWe5bnCgwSExJFFfaJ7?=
 =?us-ascii?Q?JFL2GvPZnhPMSq5PsxscQuNc9kZ7Rm1xWExmgAt4xvpXdDbMyAZ/Dh1q9UOH?=
 =?us-ascii?Q?t5QrBJ6SmqKyL49O5TpXE9v4WXLco2udWAZBbD0Av/iHmjGhwxdBZ0FFv7By?=
 =?us-ascii?Q?Gad+eSMrJ5pcuaRnTdWnZ48hkkRASz/jzlH2CLig4eLYsbjAfl+T+gus+gMr?=
 =?us-ascii?Q?OMy5cigQWJeTcEgivpCL+2svjzKJYIVgOuZNtcz13C9jYeUYiAL+ueOKWLrp?=
 =?us-ascii?Q?8Zv6WVs6nFmhB+exhc5TBTc7FPnPmfxpkMiucHWn6KsXzUzYvmvItacfs18A?=
 =?us-ascii?Q?T37wSRVWRsDRVH/vVSrJjlN2rCMhqWNtvrJS0TWymuMS+nTXY7q4S0nspAmv?=
 =?us-ascii?Q?NzXB8DLXnx+l/nBja64c2mTyowN4yn2mVq+xcjg6LKzakDoniy+RZ4HjBp+L?=
 =?us-ascii?Q?SEr0mUIXqOgfySlAOhAyWvLbPbb6gPKvwZ9pPPWJtPuN1mizkAMIpGVGexA6?=
 =?us-ascii?Q?3SkGwea/d9WnAYmfIeB7wR+YO0VZDpWNkPTuCvqhc+Btr5Wvej5Wwivslt7a?=
 =?us-ascii?Q?gUGXtJdqYX8OeD/S1cIyJo5wxo9oj7i84TzznEcOCt8xCz/zTz5NmKt2d6cy?=
 =?us-ascii?Q?MybOBZkjTopsHArbWNQsv+K91jpf0mi5TabnHHVvQGD4b/p2nerqc/Wz2J3W?=
 =?us-ascii?Q?9eUo2MrelaJ1OUnU8Z0bB4L3FazhXy3yY/5O2oMpERva+fKwdYb6Ic9LgVq+?=
 =?us-ascii?Q?MFGZPWpYvCnxPf/8pPvDge7h4aAY/UvDf0caAFDrJFO2So398dJIT4MdVAPE?=
 =?us-ascii?Q?nEniCFV62XyKPfTmweTfoFEgq7U6yW40yg05c4R+b4D7Z0bTwFIWygI+4WbF?=
 =?us-ascii?Q?Aq5O7z9MuivVUWyDb2L5Hb1hhxKTU0aKudlPg0JE2kiLfvhgBgapYqqFenFm?=
 =?us-ascii?Q?hZkg01Ka1YO7CNuBHgDT5xv0PG0CXB0bpFnRsQa6IjcojmhS2qHTtlYqtHGP?=
 =?us-ascii?Q?pkXD/GUnfmGeMyndkH1czEztjbPoR09n5ntyQTwBmrsoFPcCt2t4TlJ9cri7?=
 =?us-ascii?Q?PPBW/JudVO4KEpmjpfgwToZKg4VmAiw0WoNNZNiyO9TkRb9NDCiJdar+V2PF?=
 =?us-ascii?Q?gcwL+zluD9ZfNGTbX76gaeBOHb8eKoz81R42U6wfgxvJ/M9K3ZaMjt+vczQv?=
 =?us-ascii?Q?arj0IRxXb1/4anAzZxfXZNv19+51X0k6MZmPjRN/+PPUxw4zbeFiR6Xe19ve?=
 =?us-ascii?Q?L7oBt0usvgW6QHwiQ3dYvqTnITeJkUW0imj+qunH417rOIit/IBjaIKbL0uC?=
 =?us-ascii?Q?W/QN9IvDbhxp3vkQZolFCMt7Noi2t6gGT5YS48zOSTRLhP+cCikQJa4ceATz?=
 =?us-ascii?Q?SCVlWt3e6rRpfL6QZgrtUwvJQmYZjsS9zYQ0QgJlYYeQNpuwXCS8Atm2XEou?=
 =?us-ascii?Q?Wg1hTw/eoTT/MHp9CcVHcjSHw1qtXucRRIJB0o1XJ9Hdj59Vk8PMqMnQ3ZlR?=
 =?us-ascii?Q?CTxRCarfkuYQa9fkT/ttSKefBrZ4raKn3MfqXJc/7Ks8l5aAK0IgNysVQZwW?=
 =?us-ascii?Q?+PcGDGPizphl2alVlzTHS9yxQV6AfTNxEOuQCx4cGIOQrCgu3NzOPmOvFVJx?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4f76e8-95f6-4c6f-a473-08daf86940f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:17.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9BcVXOAaLGaYOvN/0f3MFNx7yp4rrZW4nm3p1YC5ilGblvcTJxHdu6A0b+PtxT+BMD+Ta8PSJtBGBNN8RdIsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix VSC9959 switch supports frame preemption and has a MAC Merge
layer. In addition to the structured stats that exist for the eMAC,
export the counters associated with its pMAC (pause, RMON, MAC, PHY,
control) plus the high-level MAC Merge layer stats. The unstructured
ethtool counters, as well as the rtnl_link_stats64 were left to report
only the eMAC counters.

Because statistics processing is quite self-contained in ocelot_stats.c
now, I've opted for introducing an ocelot->mm_supported bool, based on
which the common switch lib does everything, rather than pushing the
TSN-specific code in felix_vsc9959.c, as happens for other TSN stuff.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: adapt to ETHTOOL_STATS_SRC_* -> ETHTOOL_MAC_STATS_SRC_* rename
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/dsa/ocelot/felix.c           |   9 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  38 +++
 drivers/net/ethernet/mscc/ocelot_stats.c | 289 ++++++++++++++++++++++-
 include/soc/mscc/ocelot.h                |  40 ++++
 4 files changed, 366 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3b738cb2ae6e..7867ca85410f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2024,6 +2024,14 @@ static int felix_port_del_dscp_prio(struct dsa_switch *ds, int port, u8 dscp,
 	return ocelot_port_del_dscp_prio(ocelot, port, dscp, prio);
 }
 
+static void felix_get_mm_stats(struct dsa_switch *ds, int port,
+			       struct ethtool_mm_stats *stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_mm_stats(ocelot, port, stats);
+}
+
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.change_tag_protocol		= felix_change_tag_protocol,
@@ -2031,6 +2039,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
+	.get_mm_stats			= felix_get_mm_stats,
 	.get_stats64			= felix_get_stats64,
 	.get_pause_stats		= felix_get_pause_stats,
 	.get_rmon_stats			= felix_get_rmon_stats,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index cbcc457499f3..535512280f12 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -318,6 +318,29 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_RX_GREEN_PRIO_5,		0x0000a4),
 	REG(SYS_COUNT_RX_GREEN_PRIO_6,		0x0000a8),
 	REG(SYS_COUNT_RX_GREEN_PRIO_7,		0x0000ac),
+	REG(SYS_COUNT_RX_ASSEMBLY_ERRS,		0x0000b0),
+	REG(SYS_COUNT_RX_SMD_ERRS,		0x0000b4),
+	REG(SYS_COUNT_RX_ASSEMBLY_OK,		0x0000b8),
+	REG(SYS_COUNT_RX_MERGE_FRAGMENTS,	0x0000bc),
+	REG(SYS_COUNT_RX_PMAC_OCTETS,		0x0000c0),
+	REG(SYS_COUNT_RX_PMAC_UNICAST,		0x0000c4),
+	REG(SYS_COUNT_RX_PMAC_MULTICAST,	0x0000c8),
+	REG(SYS_COUNT_RX_PMAC_BROADCAST,	0x0000cc),
+	REG(SYS_COUNT_RX_PMAC_SHORTS,		0x0000d0),
+	REG(SYS_COUNT_RX_PMAC_FRAGMENTS,	0x0000d4),
+	REG(SYS_COUNT_RX_PMAC_JABBERS,		0x0000d8),
+	REG(SYS_COUNT_RX_PMAC_CRC_ALIGN_ERRS,	0x0000dc),
+	REG(SYS_COUNT_RX_PMAC_SYM_ERRS,		0x0000e0),
+	REG(SYS_COUNT_RX_PMAC_64,		0x0000e4),
+	REG(SYS_COUNT_RX_PMAC_65_127,		0x0000e8),
+	REG(SYS_COUNT_RX_PMAC_128_255,		0x0000ec),
+	REG(SYS_COUNT_RX_PMAC_256_511,		0x0000f0),
+	REG(SYS_COUNT_RX_PMAC_512_1023,		0x0000f4),
+	REG(SYS_COUNT_RX_PMAC_1024_1526,	0x0000f8),
+	REG(SYS_COUNT_RX_PMAC_1527_MAX,		0x0000fc),
+	REG(SYS_COUNT_RX_PMAC_PAUSE,		0x000100),
+	REG(SYS_COUNT_RX_PMAC_CONTROL,		0x000104),
+	REG(SYS_COUNT_RX_PMAC_LONGS,		0x000108),
 	REG(SYS_COUNT_TX_OCTETS,		0x000200),
 	REG(SYS_COUNT_TX_UNICAST,		0x000204),
 	REG(SYS_COUNT_TX_MULTICAST,		0x000208),
@@ -349,6 +372,20 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_TX_GREEN_PRIO_6,		0x000270),
 	REG(SYS_COUNT_TX_GREEN_PRIO_7,		0x000274),
 	REG(SYS_COUNT_TX_AGED,			0x000278),
+	REG(SYS_COUNT_TX_MM_HOLD,		0x00027c),
+	REG(SYS_COUNT_TX_MERGE_FRAGMENTS,	0x000280),
+	REG(SYS_COUNT_TX_PMAC_OCTETS,		0x000284),
+	REG(SYS_COUNT_TX_PMAC_UNICAST,		0x000288),
+	REG(SYS_COUNT_TX_PMAC_MULTICAST,	0x00028c),
+	REG(SYS_COUNT_TX_PMAC_BROADCAST,	0x000290),
+	REG(SYS_COUNT_TX_PMAC_PAUSE,		0x000294),
+	REG(SYS_COUNT_TX_PMAC_64,		0x000298),
+	REG(SYS_COUNT_TX_PMAC_65_127,		0x00029c),
+	REG(SYS_COUNT_TX_PMAC_128_255,		0x0002a0),
+	REG(SYS_COUNT_TX_PMAC_256_511,		0x0002a4),
+	REG(SYS_COUNT_TX_PMAC_512_1023,		0x0002a8),
+	REG(SYS_COUNT_TX_PMAC_1024_1526,	0x0002ac),
+	REG(SYS_COUNT_TX_PMAC_1527_MAX,		0x0002b0),
 	REG(SYS_COUNT_DROP_LOCAL,		0x000400),
 	REG(SYS_COUNT_DROP_TAIL,		0x000404),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,	0x000408),
@@ -2623,6 +2660,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	}
 
 	ocelot->ptp = 1;
+	ocelot->mm_supported = true;
 
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
 	if (!ds) {
diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 551e3cbfae79..f660eef4a287 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -54,6 +54,29 @@ enum ocelot_stat {
 	OCELOT_STAT_RX_GREEN_PRIO_5,
 	OCELOT_STAT_RX_GREEN_PRIO_6,
 	OCELOT_STAT_RX_GREEN_PRIO_7,
+	OCELOT_STAT_RX_ASSEMBLY_ERRS,
+	OCELOT_STAT_RX_SMD_ERRS,
+	OCELOT_STAT_RX_ASSEMBLY_OK,
+	OCELOT_STAT_RX_MERGE_FRAGMENTS,
+	OCELOT_STAT_RX_PMAC_OCTETS,
+	OCELOT_STAT_RX_PMAC_UNICAST,
+	OCELOT_STAT_RX_PMAC_MULTICAST,
+	OCELOT_STAT_RX_PMAC_BROADCAST,
+	OCELOT_STAT_RX_PMAC_SHORTS,
+	OCELOT_STAT_RX_PMAC_FRAGMENTS,
+	OCELOT_STAT_RX_PMAC_JABBERS,
+	OCELOT_STAT_RX_PMAC_CRC_ALIGN_ERRS,
+	OCELOT_STAT_RX_PMAC_SYM_ERRS,
+	OCELOT_STAT_RX_PMAC_64,
+	OCELOT_STAT_RX_PMAC_65_127,
+	OCELOT_STAT_RX_PMAC_128_255,
+	OCELOT_STAT_RX_PMAC_256_511,
+	OCELOT_STAT_RX_PMAC_512_1023,
+	OCELOT_STAT_RX_PMAC_1024_1526,
+	OCELOT_STAT_RX_PMAC_1527_MAX,
+	OCELOT_STAT_RX_PMAC_PAUSE,
+	OCELOT_STAT_RX_PMAC_CONTROL,
+	OCELOT_STAT_RX_PMAC_LONGS,
 	OCELOT_STAT_TX_OCTETS,
 	OCELOT_STAT_TX_UNICAST,
 	OCELOT_STAT_TX_MULTICAST,
@@ -85,6 +108,20 @@ enum ocelot_stat {
 	OCELOT_STAT_TX_GREEN_PRIO_6,
 	OCELOT_STAT_TX_GREEN_PRIO_7,
 	OCELOT_STAT_TX_AGED,
+	OCELOT_STAT_TX_MM_HOLD,
+	OCELOT_STAT_TX_MERGE_FRAGMENTS,
+	OCELOT_STAT_TX_PMAC_OCTETS,
+	OCELOT_STAT_TX_PMAC_UNICAST,
+	OCELOT_STAT_TX_PMAC_MULTICAST,
+	OCELOT_STAT_TX_PMAC_BROADCAST,
+	OCELOT_STAT_TX_PMAC_PAUSE,
+	OCELOT_STAT_TX_PMAC_64,
+	OCELOT_STAT_TX_PMAC_65_127,
+	OCELOT_STAT_TX_PMAC_128_255,
+	OCELOT_STAT_TX_PMAC_256_511,
+	OCELOT_STAT_TX_PMAC_512_1023,
+	OCELOT_STAT_TX_PMAC_1024_1526,
+	OCELOT_STAT_TX_PMAC_1527_MAX,
 	OCELOT_STAT_DROP_LOCAL,
 	OCELOT_STAT_DROP_TAIL,
 	OCELOT_STAT_DROP_YELLOW_PRIO_0,
@@ -228,9 +265,52 @@ static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
 
+static const struct ocelot_stat_layout ocelot_mm_stats_layout[OCELOT_NUM_STATS] = {
+	OCELOT_COMMON_STATS,
+	OCELOT_STAT(RX_ASSEMBLY_ERRS),
+	OCELOT_STAT(RX_SMD_ERRS),
+	OCELOT_STAT(RX_ASSEMBLY_OK),
+	OCELOT_STAT(RX_MERGE_FRAGMENTS),
+	OCELOT_STAT(TX_MERGE_FRAGMENTS),
+	OCELOT_STAT(RX_PMAC_OCTETS),
+	OCELOT_STAT(RX_PMAC_UNICAST),
+	OCELOT_STAT(RX_PMAC_MULTICAST),
+	OCELOT_STAT(RX_PMAC_BROADCAST),
+	OCELOT_STAT(RX_PMAC_SHORTS),
+	OCELOT_STAT(RX_PMAC_FRAGMENTS),
+	OCELOT_STAT(RX_PMAC_JABBERS),
+	OCELOT_STAT(RX_PMAC_CRC_ALIGN_ERRS),
+	OCELOT_STAT(RX_PMAC_SYM_ERRS),
+	OCELOT_STAT(RX_PMAC_64),
+	OCELOT_STAT(RX_PMAC_65_127),
+	OCELOT_STAT(RX_PMAC_128_255),
+	OCELOT_STAT(RX_PMAC_256_511),
+	OCELOT_STAT(RX_PMAC_512_1023),
+	OCELOT_STAT(RX_PMAC_1024_1526),
+	OCELOT_STAT(RX_PMAC_1527_MAX),
+	OCELOT_STAT(RX_PMAC_PAUSE),
+	OCELOT_STAT(RX_PMAC_CONTROL),
+	OCELOT_STAT(RX_PMAC_LONGS),
+	OCELOT_STAT(TX_PMAC_OCTETS),
+	OCELOT_STAT(TX_PMAC_UNICAST),
+	OCELOT_STAT(TX_PMAC_MULTICAST),
+	OCELOT_STAT(TX_PMAC_BROADCAST),
+	OCELOT_STAT(TX_PMAC_PAUSE),
+	OCELOT_STAT(TX_PMAC_64),
+	OCELOT_STAT(TX_PMAC_65_127),
+	OCELOT_STAT(TX_PMAC_128_255),
+	OCELOT_STAT(TX_PMAC_256_511),
+	OCELOT_STAT(TX_PMAC_512_1023),
+	OCELOT_STAT(TX_PMAC_1024_1526),
+	OCELOT_STAT(TX_PMAC_1527_MAX),
+};
+
 static const struct ocelot_stat_layout *
 ocelot_get_stats_layout(struct ocelot *ocelot)
 {
+	if (ocelot->mm_supported)
+		return ocelot_mm_stats_layout;
+
 	return ocelot_stats_layout;
 }
 
@@ -410,14 +490,63 @@ static void ocelot_port_pause_stats_cb(struct ocelot *ocelot, int port, void *pr
 	pause_stats->rx_pause_frames = s[OCELOT_STAT_RX_PAUSE];
 }
 
+static void ocelot_port_pmac_pause_stats_cb(struct ocelot *ocelot, int port,
+					    void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_pause_stats *pause_stats = priv;
+
+	pause_stats->tx_pause_frames = s[OCELOT_STAT_TX_PMAC_PAUSE];
+	pause_stats->rx_pause_frames = s[OCELOT_STAT_RX_PMAC_PAUSE];
+}
+
+static void ocelot_port_mm_stats_cb(struct ocelot *ocelot, int port,
+				    void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_mm_stats *stats = priv;
+
+	stats->MACMergeFrameAssErrorCount = s[OCELOT_STAT_RX_ASSEMBLY_ERRS];
+	stats->MACMergeFrameSmdErrorCount = s[OCELOT_STAT_RX_SMD_ERRS];
+	stats->MACMergeFrameAssOkCount = s[OCELOT_STAT_RX_ASSEMBLY_OK];
+	stats->MACMergeFragCountRx = s[OCELOT_STAT_RX_MERGE_FRAGMENTS];
+	stats->MACMergeFragCountTx = s[OCELOT_STAT_TX_MERGE_FRAGMENTS];
+	stats->MACMergeHoldCount = s[OCELOT_STAT_TX_MM_HOLD];
+}
+
 void ocelot_port_get_pause_stats(struct ocelot *ocelot, int port,
 				 struct ethtool_pause_stats *pause_stats)
 {
-	ocelot_port_stats_run(ocelot, port, pause_stats,
-			      ocelot_port_pause_stats_cb);
+	struct net_device *dev;
+
+	switch (pause_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, pause_stats,
+				      ocelot_port_pause_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, pause_stats,
+					      ocelot_port_pmac_pause_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_pause_stats(dev, pause_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_pause_stats);
 
+void ocelot_port_get_mm_stats(struct ocelot *ocelot, int port,
+			      struct ethtool_mm_stats *stats)
+{
+	if (!ocelot->mm_supported)
+		return;
+
+	ocelot_port_stats_run(ocelot, port, stats, ocelot_port_mm_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_mm_stats);
+
 static const struct ethtool_rmon_hist_range ocelot_rmon_ranges[] = {
 	{   64,    64 },
 	{   65,   127 },
@@ -456,14 +585,57 @@ static void ocelot_port_rmon_stats_cb(struct ocelot *ocelot, int port, void *pri
 	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_1024_1526];
 }
 
+static void ocelot_port_pmac_rmon_stats_cb(struct ocelot *ocelot, int port,
+					   void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_rmon_stats *rmon_stats = priv;
+
+	rmon_stats->undersize_pkts = s[OCELOT_STAT_RX_PMAC_SHORTS];
+	rmon_stats->oversize_pkts = s[OCELOT_STAT_RX_PMAC_LONGS];
+	rmon_stats->fragments = s[OCELOT_STAT_RX_PMAC_FRAGMENTS];
+	rmon_stats->jabbers = s[OCELOT_STAT_RX_PMAC_JABBERS];
+
+	rmon_stats->hist[0] = s[OCELOT_STAT_RX_PMAC_64];
+	rmon_stats->hist[1] = s[OCELOT_STAT_RX_PMAC_65_127];
+	rmon_stats->hist[2] = s[OCELOT_STAT_RX_PMAC_128_255];
+	rmon_stats->hist[3] = s[OCELOT_STAT_RX_PMAC_256_511];
+	rmon_stats->hist[4] = s[OCELOT_STAT_RX_PMAC_512_1023];
+	rmon_stats->hist[5] = s[OCELOT_STAT_RX_PMAC_1024_1526];
+	rmon_stats->hist[6] = s[OCELOT_STAT_RX_PMAC_1527_MAX];
+
+	rmon_stats->hist_tx[0] = s[OCELOT_STAT_TX_PMAC_64];
+	rmon_stats->hist_tx[1] = s[OCELOT_STAT_TX_PMAC_65_127];
+	rmon_stats->hist_tx[2] = s[OCELOT_STAT_TX_PMAC_128_255];
+	rmon_stats->hist_tx[3] = s[OCELOT_STAT_TX_PMAC_128_255];
+	rmon_stats->hist_tx[4] = s[OCELOT_STAT_TX_PMAC_256_511];
+	rmon_stats->hist_tx[5] = s[OCELOT_STAT_TX_PMAC_512_1023];
+	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_PMAC_1024_1526];
+}
+
 void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
 				struct ethtool_rmon_stats *rmon_stats,
 				const struct ethtool_rmon_hist_range **ranges)
 {
+	struct net_device *dev;
+
 	*ranges = ocelot_rmon_ranges;
 
-	ocelot_port_stats_run(ocelot, port, rmon_stats,
-			      ocelot_port_rmon_stats_cb);
+	switch (rmon_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, rmon_stats,
+				      ocelot_port_rmon_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, rmon_stats,
+					      ocelot_port_pmac_rmon_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_rmon_stats(dev, rmon_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_rmon_stats);
 
@@ -475,11 +647,35 @@ static void ocelot_port_ctrl_stats_cb(struct ocelot *ocelot, int port, void *pri
 	ctrl_stats->MACControlFramesReceived = s[OCELOT_STAT_RX_CONTROL];
 }
 
+static void ocelot_port_pmac_ctrl_stats_cb(struct ocelot *ocelot, int port,
+					   void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_ctrl_stats *ctrl_stats = priv;
+
+	ctrl_stats->MACControlFramesReceived = s[OCELOT_STAT_RX_PMAC_CONTROL];
+}
+
 void ocelot_port_get_eth_ctrl_stats(struct ocelot *ocelot, int port,
 				    struct ethtool_eth_ctrl_stats *ctrl_stats)
 {
-	ocelot_port_stats_run(ocelot, port, ctrl_stats,
-			      ocelot_port_ctrl_stats_cb);
+	struct net_device *dev;
+
+	switch (ctrl_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, ctrl_stats,
+				      ocelot_port_ctrl_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, ctrl_stats,
+					      ocelot_port_pmac_ctrl_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_ctrl_stats(dev, ctrl_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_eth_ctrl_stats);
 
@@ -525,11 +721,60 @@ static void ocelot_port_mac_stats_cb(struct ocelot *ocelot, int port, void *priv
 	mac_stats->AlignmentErrors = s[OCELOT_STAT_RX_CRC_ALIGN_ERRS];
 }
 
+static void ocelot_port_pmac_mac_stats_cb(struct ocelot *ocelot, int port,
+					  void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_mac_stats *mac_stats = priv;
+
+	mac_stats->OctetsTransmittedOK = s[OCELOT_STAT_TX_PMAC_OCTETS];
+	mac_stats->FramesTransmittedOK = s[OCELOT_STAT_TX_PMAC_64] +
+					 s[OCELOT_STAT_TX_PMAC_65_127] +
+					 s[OCELOT_STAT_TX_PMAC_128_255] +
+					 s[OCELOT_STAT_TX_PMAC_256_511] +
+					 s[OCELOT_STAT_TX_PMAC_512_1023] +
+					 s[OCELOT_STAT_TX_PMAC_1024_1526] +
+					 s[OCELOT_STAT_TX_PMAC_1527_MAX];
+	mac_stats->OctetsReceivedOK = s[OCELOT_STAT_RX_PMAC_OCTETS];
+	mac_stats->FramesReceivedOK = s[OCELOT_STAT_RX_PMAC_64] +
+				      s[OCELOT_STAT_RX_PMAC_65_127] +
+				      s[OCELOT_STAT_RX_PMAC_128_255] +
+				      s[OCELOT_STAT_RX_PMAC_256_511] +
+				      s[OCELOT_STAT_RX_PMAC_512_1023] +
+				      s[OCELOT_STAT_RX_PMAC_1024_1526] +
+				      s[OCELOT_STAT_RX_PMAC_1527_MAX];
+	mac_stats->MulticastFramesXmittedOK = s[OCELOT_STAT_TX_PMAC_MULTICAST];
+	mac_stats->BroadcastFramesXmittedOK = s[OCELOT_STAT_TX_PMAC_BROADCAST];
+	mac_stats->MulticastFramesReceivedOK = s[OCELOT_STAT_RX_PMAC_MULTICAST];
+	mac_stats->BroadcastFramesReceivedOK = s[OCELOT_STAT_RX_PMAC_BROADCAST];
+	mac_stats->FrameTooLongErrors = s[OCELOT_STAT_RX_PMAC_LONGS];
+	/* Sadly, C_RX_CRC is the sum of FCS and alignment errors, they are not
+	 * counted individually.
+	 */
+	mac_stats->FrameCheckSequenceErrors = s[OCELOT_STAT_RX_PMAC_CRC_ALIGN_ERRS];
+	mac_stats->AlignmentErrors = s[OCELOT_STAT_RX_PMAC_CRC_ALIGN_ERRS];
+}
+
 void ocelot_port_get_eth_mac_stats(struct ocelot *ocelot, int port,
 				   struct ethtool_eth_mac_stats *mac_stats)
 {
-	ocelot_port_stats_run(ocelot, port, mac_stats,
-			      ocelot_port_mac_stats_cb);
+	struct net_device *dev;
+
+	switch (mac_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, mac_stats,
+				      ocelot_port_mac_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, mac_stats,
+					      ocelot_port_pmac_mac_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_mac_stats(dev, mac_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_eth_mac_stats);
 
@@ -541,11 +786,35 @@ static void ocelot_port_phy_stats_cb(struct ocelot *ocelot, int port, void *priv
 	phy_stats->SymbolErrorDuringCarrier = s[OCELOT_STAT_RX_SYM_ERRS];
 }
 
+static void ocelot_port_pmac_phy_stats_cb(struct ocelot *ocelot, int port,
+					  void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_phy_stats *phy_stats = priv;
+
+	phy_stats->SymbolErrorDuringCarrier = s[OCELOT_STAT_RX_PMAC_SYM_ERRS];
+}
+
 void ocelot_port_get_eth_phy_stats(struct ocelot *ocelot, int port,
 				   struct ethtool_eth_phy_stats *phy_stats)
 {
-	ocelot_port_stats_run(ocelot, port, phy_stats,
-			      ocelot_port_phy_stats_cb);
+	struct net_device *dev;
+
+	switch (phy_stats->src) {
+	case ETHTOOL_MAC_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, phy_stats,
+				      ocelot_port_phy_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, phy_stats,
+					      ocelot_port_pmac_phy_stats_cb);
+		break;
+	case ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_phy_stats(dev, phy_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_eth_phy_stats);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index df62be80a193..6de909d79896 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -362,6 +362,29 @@ enum ocelot_reg {
 	SYS_COUNT_RX_GREEN_PRIO_5,
 	SYS_COUNT_RX_GREEN_PRIO_6,
 	SYS_COUNT_RX_GREEN_PRIO_7,
+	SYS_COUNT_RX_ASSEMBLY_ERRS,
+	SYS_COUNT_RX_SMD_ERRS,
+	SYS_COUNT_RX_ASSEMBLY_OK,
+	SYS_COUNT_RX_MERGE_FRAGMENTS,
+	SYS_COUNT_RX_PMAC_OCTETS,
+	SYS_COUNT_RX_PMAC_UNICAST,
+	SYS_COUNT_RX_PMAC_MULTICAST,
+	SYS_COUNT_RX_PMAC_BROADCAST,
+	SYS_COUNT_RX_PMAC_SHORTS,
+	SYS_COUNT_RX_PMAC_FRAGMENTS,
+	SYS_COUNT_RX_PMAC_JABBERS,
+	SYS_COUNT_RX_PMAC_CRC_ALIGN_ERRS,
+	SYS_COUNT_RX_PMAC_SYM_ERRS,
+	SYS_COUNT_RX_PMAC_64,
+	SYS_COUNT_RX_PMAC_65_127,
+	SYS_COUNT_RX_PMAC_128_255,
+	SYS_COUNT_RX_PMAC_256_511,
+	SYS_COUNT_RX_PMAC_512_1023,
+	SYS_COUNT_RX_PMAC_1024_1526,
+	SYS_COUNT_RX_PMAC_1527_MAX,
+	SYS_COUNT_RX_PMAC_PAUSE,
+	SYS_COUNT_RX_PMAC_CONTROL,
+	SYS_COUNT_RX_PMAC_LONGS,
 	SYS_COUNT_TX_OCTETS,
 	SYS_COUNT_TX_UNICAST,
 	SYS_COUNT_TX_MULTICAST,
@@ -393,6 +416,20 @@ enum ocelot_reg {
 	SYS_COUNT_TX_GREEN_PRIO_6,
 	SYS_COUNT_TX_GREEN_PRIO_7,
 	SYS_COUNT_TX_AGED,
+	SYS_COUNT_TX_MM_HOLD,
+	SYS_COUNT_TX_MERGE_FRAGMENTS,
+	SYS_COUNT_TX_PMAC_OCTETS,
+	SYS_COUNT_TX_PMAC_UNICAST,
+	SYS_COUNT_TX_PMAC_MULTICAST,
+	SYS_COUNT_TX_PMAC_BROADCAST,
+	SYS_COUNT_TX_PMAC_PAUSE,
+	SYS_COUNT_TX_PMAC_64,
+	SYS_COUNT_TX_PMAC_65_127,
+	SYS_COUNT_TX_PMAC_128_255,
+	SYS_COUNT_TX_PMAC_256_511,
+	SYS_COUNT_TX_PMAC_512_1023,
+	SYS_COUNT_TX_PMAC_1024_1526,
+	SYS_COUNT_TX_PMAC_1527_MAX,
 	SYS_COUNT_DROP_LOCAL,
 	SYS_COUNT_DROP_TAIL,
 	SYS_COUNT_DROP_YELLOW_PRIO_0,
@@ -814,6 +851,7 @@ struct ocelot {
 	struct workqueue_struct		*owq;
 
 	u8				ptp:1;
+	u8				mm_supported:1;
 	struct ptp_clock		*ptp_clock;
 	struct ptp_clock_info		ptp_info;
 	struct hwtstamp_config		hwtstamp_config;
@@ -937,6 +975,8 @@ void ocelot_port_get_stats64(struct ocelot *ocelot, int port,
 			     struct rtnl_link_stats64 *stats);
 void ocelot_port_get_pause_stats(struct ocelot *ocelot, int port,
 				 struct ethtool_pause_stats *pause_stats);
+void ocelot_port_get_mm_stats(struct ocelot *ocelot, int port,
+			      struct ethtool_mm_stats *stats);
 void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
 				struct ethtool_rmon_stats *rmon_stats,
 				const struct ethtool_rmon_hist_range **ranges);
-- 
2.34.1

