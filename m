Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444CE67387D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjASM3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjASM2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:28:08 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2974C5CE49;
        Thu, 19 Jan 2023 04:28:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPqCaak2z3g9d6/9sYJGZqsRc/EiQsK3diEYzu0upxw7o0/MIiIQh+de9H9RZq4k95WfX/ocZ1mgr+PmqWXu0tjFDiyjNzAvkQz0v+eip6oeKOeBSRxR5d4TDdqeRTGyHQeqKePQquSQc9bWKImdf66M8Pt9VJE65iSo2vw56Pwb+uQ30Wsk2RRj7O0Bzl/ZOMvstKqxr7NtkM+/YsyyHhyIuhHW8yicwWVSnOpiJcW98mcmF9Wdb+Dhw23I1jZxmUDdw+0pXOKxdLTSr2EYqnqxb1B+aDrAv9N9QeudjyPSO5dfgQDTEcaCwtsJdCnl9GOjekTj7fg1W4DZPBiiHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSmvI1kwqu1rshOeg/mzMgk5FXONNHJSpRncJdwrN8Q=;
 b=nVe5v1ihMuRNk8V/HlKuJOV7+OcUrD/BANZW9iGfv5ai6j+flUqEcJcEkeEuCGl48shZM8juPnQm1w5d/XlGkm7RKxrXDCkbk/y8B4v5SL1FylhQiQ7eiW/YwDcsPvDQ+GmeX8b/MIIotiJyGVV6b7jbpTef8Lxu816rUlM4SfVGLO+7G47r1ObAEmodef/LaYV2OPiCBibGRcCoU0+tJaO5jQBJUqPh89ISLkTujZBiP63IZEHKq/L6rYPZeO4hZ62x273lualTMkw8kel/xtpCCWOlRW4lbzSk8WS+UITIiaMH70zGF5G5mrxmAw+n5FqGUZTkJMwSl9M8KyXbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSmvI1kwqu1rshOeg/mzMgk5FXONNHJSpRncJdwrN8Q=;
 b=MGhU/DlhBFaRMNu8qzF/FLxSD9aBsJQZJMe2ZOhVMeekqBPyJO5amsG1KajEQ123BDeorj3UIyE2t/pMSryvYMBjaUTtX8r6xpdqMPaYomC5Y36PrDf5M+oPI2/sNavwy/eFSRlvY0/+MEURn8pHcgjxTV6rL3LFPpGaUB7FR+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8206.eurprd04.prod.outlook.com (2603:10a6:102:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:28:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:28:02 +0000
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
Subject: [PATCH v4 net-next 11/12] net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
Date:   Thu, 19 Jan 2023 14:27:03 +0200
Message-Id: <20230119122705.73054-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: bfcee6e5-765d-4733-79e3-08dafa189b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //I1r54IFaCp9iwtX2klW2ub6jhqk1wsC3/zIlNP3EmN78Bcvyx9ZS1WD20PlEzr1M2lHPQnO3Y03tcADeSpp8sOmSrfzjdf7NYs0qiaflaUqkIEQ/BLA2on0RMJ/B3HfVptTvFrk9QHJGLZruMzr9QBDRpXsmJXRnrJZVuGFkFHuzMOg3jzsPcd8WIJdtfdJJGjaOFkvtVNVozm76cxdIm/yWxwP7mqyw/NtseDQFk/WsGWd+elgd81lLtVHV2IbsCX5lmRbCmaefLngwqx/LA7OgMxE46+vuEHDW+i82O+sxHy81yVeMHb/rlWpn5XNUSsEeEd+1fvBa0e8tm7PE02xyW2NhKBHpEik3iw+q1lokvBY7EUeA1nFdcBhMUlqkWObXE1xKBnMZf+1SQVKpB6qcpBCn9hl81qPboeAPsHHVLtYl/mh3/jrVaekeBBWOpQzv5YXHsVcw3KseT5jaXYIjIWMeuGGyrWxFgA7goezYoKzR1vP1nKWgS+xwjDw5fsmDoSeTiIGZsVwReDCpe0w8fbYJDm5ulQdvotK/UzrHqY4PE6s5aNb9Td3JGxr0FhmupnX6j2aDVisbeyDkf7/lZtX2EYzgAW9FAeNOaxKsA+JeA+QSbZ2Tuq7YuRmubNawAMTdQCKkuU8a6O40QPJYMPQYoz0uDwu6kitR+8yI/E7FgKwueAwXiT8eK4MTpjTrj+BdwX4L0gfvzTfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199015)(6506007)(86362001)(44832011)(66556008)(7416002)(5660300002)(8936002)(2906002)(66476007)(30864003)(66946007)(38350700002)(38100700002)(316002)(52116002)(54906003)(4326008)(36756003)(478600001)(6486002)(6916009)(41300700001)(8676002)(186003)(1076003)(6512007)(83380400001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meapa64ukuyPWSOfh+Qd1gCCvhoVGZB8H29m/rsqgF5KNU5N8OK1WiDomH87?=
 =?us-ascii?Q?Md/HQx8YR1v0e0ZZZ3bV67TAJoElrBSjPsErXfh68Umk0zxRyXC5Ii/LnEzW?=
 =?us-ascii?Q?oIZlci4hHrtfJCle+WEofFwko0MMSDkgWXdoGC7LjbCVxLS/Q8mGDd0uwz5/?=
 =?us-ascii?Q?Ip7QrJBYXzfXKvn0GrL3bNH6rehAF7Qk5H9jIINJflCaHztwnAPmOMAH8EMZ?=
 =?us-ascii?Q?ruhySioVtkdsS+Pwj34a+kz3Dq3ITFnj6xmvIbCjCSdIMqvvUK7YvpbFpg2j?=
 =?us-ascii?Q?0wagNstM2i4Xk+LHjOItmLVSs/bnjPQCmTYNzP1hw50HxaMmJmxvEjz35Al/?=
 =?us-ascii?Q?ErpD33rAPrAWPG6kzqTyPfwLbERhOA4b5W2+TUCTYdRHEaGv8uENd2DFCRZ8?=
 =?us-ascii?Q?dOLwwz+9MKLohDwcRoWe4ouP5u4Ks3JMWiM/cJROwM53fxfraxJfUfmafsqH?=
 =?us-ascii?Q?PIT27V7WPWj5XHSLQKaptXvZEBj5Rn7AB1DptSPt3fGi0vCaNh7TypeJaNVB?=
 =?us-ascii?Q?KQgd+Ajd/ASnh66T5LGXidcXbLhwaEHfUvD8MYYtmwB/AeKIcnUXAEli+m2C?=
 =?us-ascii?Q?cQnui2EDaXgt0sKw2ebdWwPygZ+dbRXR/04a1NxxThVXyFo4b0Wx0YuzO7wb?=
 =?us-ascii?Q?fDlSlb/ExKK/MXN5wNwiq95mdBVWs+sXWx+Quxew8hSbFR+OZbjCNLssvNkv?=
 =?us-ascii?Q?ZjZo1uvsfovTMJbIrU+SbcM5i5Mx49lD0ImKv4xa8h3WNvNZxtC13JZQX7a9?=
 =?us-ascii?Q?HV24rECPx0s/LkVxV5bNzKwojpWZm+Fn/VnjWZtFjEaKWtF/WU8nC3DwjebN?=
 =?us-ascii?Q?Ro2TeLUS/AGI/Daa06UAr6PKv56CoeJmcLc4DLqYvRkkco3tl1Eb85NrMCUm?=
 =?us-ascii?Q?kfehg939U+eL/60V90QvxSaZ6ItRvLlWpGhP+8SC3FWpI6TxMSGFpsFIviAo?=
 =?us-ascii?Q?pQBN5Vk7U/rE/+X5ihKJBRTrzGmYiNYcIypVftl22Ucl5ZbA3lTTvah0GLqK?=
 =?us-ascii?Q?wZkOm8gbkgenGJFMpxjIqf2cT2Q+nbVkBdvCieEM+pC9H5OLs5kbjmvtQI9p?=
 =?us-ascii?Q?oOTVvuZ+81JJivEErFtsHDiXElb4boK3sRxZDhKguubcSEnHlR8VrhX+8tBv?=
 =?us-ascii?Q?g4qI9PLZ+9sF++7wFv8UQGddatDC9tzLPP2eoePXkjv8LV0nwtBmwyE91H3J?=
 =?us-ascii?Q?LJ+jpEt7VhoCZ5OMN8JCRn02xe6jMZO9sYvnAOBvl1UCRRee9d+rH5FjMMAn?=
 =?us-ascii?Q?LPNugfdTJdn2JVJgOoflMVk0ucLV14aWfjWggP51kxi6rPr2wKhAXCNbvPAW?=
 =?us-ascii?Q?+BqQhhqweykaDK2KfyTemcVLjkQP1Ab86fW7q3X6dnRCdaVgdHXa5w22DD88?=
 =?us-ascii?Q?X2A0ZjxRF40jN5c5aGP/HSV8UePQfF8hZOY9LANUenzVgDtWdUK5vTgiCFNr?=
 =?us-ascii?Q?FXhtmES3JkQM5xoFnmVjpItuwrw7CrTn+M+7l5Zs046o1f4Sa0IL/IiIK+MR?=
 =?us-ascii?Q?iS1bw7N8ldg0X5yrPYCs/in0pQi9fxyg3DQ+uKVhpts0uP00L9A9jzpreDdz?=
 =?us-ascii?Q?vjMoTUVz5CCB/Axd2SxRW/xsVpIU9yBMifYZORzo9hNhXhCVJaBre9uLWmtu?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfcee6e5-765d-4733-79e3-08dafa189b31
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:28:02.0591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pu4YsrCZopXRrIHlqc1vr6FA2W/3wp4YsThDMaRz2AJgqhty+6PmG0n51hwLOEuRHuiCs+u0DUN036UJmZcU1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8206
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
v3->v4: none
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

