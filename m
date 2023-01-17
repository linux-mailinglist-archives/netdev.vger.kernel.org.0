Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B296C66D930
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbjAQJED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbjAQJBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:44 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2079.outbound.protection.outlook.com [40.107.13.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DF5302A8;
        Tue, 17 Jan 2023 01:00:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlQzoWu1zNfu3I+rey0Hg8PDBhvUAPGY9gdREQ+RsYDPPKKm1dxkZ1AVlts9XteQIX3G+m18wEKKNxiw/KZdPjUjli5YQfhyBc0HoZeW2rTkTkn+ej8v55uWSGhzA8cPAv0YDPP7BT2dIiEFHuS7Th5yjYMAP6VsejPepb4QZwptBBrZgtRo/oawfdPwWANYfbCAqSh7vU5Fch9UAD5TEGgkPyYgzEFLbWYSHo5Rd8tSek7c33FQrQy3A7HqkcXaD+y3K6lIsTDXrxhtOgvDFcORsiKpR9ycyrYMobM+Wxdo1GoV7BzPHBYg7R58BHedl5rLyCQyK3Ijv86i4SgDdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUViFYUJxDtQ118HMqUSPlfLX2uflDjdj8HxS3yoZSc=;
 b=BFxnQrq5USW8Q4IavOLsbDAXqUC9YR7Pz4StB91T2AXT+ZaLiEUMaZbttQ+vBcdnmFH5SVA2kwD/3HfiEBKX3iBa9ZCWsX1GwUCWN5MCjZTM901X2EPiBHmUz+o4Bodc9lS8SwzUjdG+ECUcwF3nHk6bmnSoicf3v+EZ3ScOTFZxhbMAMqIlRhFa+PzZjhn/qhWsZhOu9+VRvovnYvRBVVjsxmuSy9vBjBP4OyQsFv3LklNo6mX0VeYDjlhA3jiEsNpr3ov1CWhi0aCU8J4LXhm9l0Zxcd2BFQ/vTKHXzOMUilryLttYO4cXj6q1hP2GNBSQR0D9xXWxJy18N6hu7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUViFYUJxDtQ118HMqUSPlfLX2uflDjdj8HxS3yoZSc=;
 b=W8yxg1sIZofVrpKGdoqdtRcov+TlnIkAodbpT/IJsaADunOINQT6SWB+fLwB4+mzlqV1qgvI1QEnMeP196odQ+ItLinBt8gy7zHY5+R1zkQivdJGTbZs7FtnDakozn5COcSowX+Ki+odwt8alJekr0X6Bt9E22v7CN8Dct8gxEo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 09:00:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:15 +0000
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
Subject: [PATCH v3 net-next 10/12] net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
Date:   Tue, 17 Jan 2023 10:59:45 +0200
Message-Id: <20230117085947.2176464-11-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9d2fb7dc-e8f4-49da-4184-08daf8693fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2KPy4pzoftm8BdFh/xE1PcDAjE+3LW7B6jKHYk1p4H3iJepHyQchkRxY0ZES8Ie8a/1LzihDeX9+GjD3HvHhHB2MURNc8UpsaSJybNcqpK7lZe4W2+5NuyqYN8DOtS93/ugH/6C1upeYTAo1u4vFfDEyKe1DmZfx6mez1vd8od/xQnUEo/1FVsrzDDFGmfzN/JORIUnMsf19CxdCMGGoUZrMmrWH0+kKuwY5riDTyGLpCky/VPpnLIhpMRJKawSmEHaDmqcnypnOPCoWnSqcSRbWDvoFPrp/eE6PpWDQbMlFltpz9Jna4kTqdv0QXepXOQbZZUUYO6foZ8vx7Yi9dFNMRy8ZqoCyrkT5jwzy+Hxdqo4LV7fMD2tU8ntMUCf7umiNOIQCg96vLC9d9eRmMQKJARhs4tWO1khudIwkKrxbpBUBtYJne1LqHvmukq9g5tBGlhZrMOePNQnO2zfmxpV/AclMwdvJONPG/T3yKLq5pzwzQc7yKRzXNmdLVC0L5EnifUODoeumVPBPCe9l2U13JybnDe71d+jJAGR9n5yYQeE150rj81vKF0ndvtRFRQ7RMdfMzNDFvQSj82idV/wM40SBDZGuNnrFiAJRwErtNznrxN/LuEltDbwCOlq5RF9dBDVe/YTOwebUaTOQ+eiaQliULpeC2y4ILDy9pQBqOYg8KO2iDdroxaPQ2II
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(36756003)(86362001)(186003)(6916009)(4326008)(6512007)(8676002)(26005)(66556008)(41300700001)(66476007)(66946007)(2616005)(1076003)(316002)(6506007)(52116002)(6666004)(54906003)(478600001)(44832011)(6486002)(2906002)(7416002)(38100700002)(38350700002)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ius8xkCucIp2atb2jJFF70olsoDmOT1UYPXojhAOoPhM8i5hTe24yjUm1CKQ?=
 =?us-ascii?Q?Q+lHqM3zDIHI+Ep34cvKjZVg8eQdgJUcKPSyj4afqYRvwiZiqaFlmgb/XGV3?=
 =?us-ascii?Q?Jh4UWDxy7Kouij+Hz74C2O3vtOiLDJ+QxlAtRSzXuKXaDA7DLNA1XfQBk4Sx?=
 =?us-ascii?Q?3bQIJ5tE/mjZG/zvbulXnwbTmj29xLx0aPMJti7dVd00CUbiMLzEAfy1b1Co?=
 =?us-ascii?Q?Fo15bze97JajHmJOBO+UiW9T443VeymnX61xA6aD9Wsis2FCBG1KouSGsXrt?=
 =?us-ascii?Q?yPhuyCAFd2bggUkKw8tgsv3l5Vc5sQDe+5to9WgF9addV9Y0uPy5Ohhd9hsk?=
 =?us-ascii?Q?D91B1LDZITl0GerZ39txbQeQdYaRfLirFvXbUIDEGaQ7+pM68fbWQU5zDHZv?=
 =?us-ascii?Q?WDMfvYb5xtCLaNbh6ZYDF0Q4eAyExpB6tIjdIHvg4OUtec/rMsEBLIvg4gJb?=
 =?us-ascii?Q?UtTyGk4WTsW7cbg8pxrT2Z0tuYRBxw7aHMzHBDKVufc1iCBnQDhaQowOpYKl?=
 =?us-ascii?Q?DpXFYKDUyBuCCug+0KtOuz0raNuKkwOUnOj3E+ZUE/bLFVhucTPAdN0D3YXE?=
 =?us-ascii?Q?ZNipj9e8y0waBylyTxfES1ssUEhSO/i+cPE+S9is0IWckzIRn4S7nQOPPZgn?=
 =?us-ascii?Q?Sae4kRApj6o8juKN6vLIZNLP1057XVBEEng7tvINSzB25TXbTIAstq8Rcln/?=
 =?us-ascii?Q?hQJX15okLXf7Uz4BAb3RYryF5bxmtHrQBtJWjTo/qnhGNoSkh0p9miSzjfyO?=
 =?us-ascii?Q?SJIbIzvSXQv9lNOuUw4yIQdaTx/YFFpqBKNwLQtlD/SpHXyDDQE4nopyj5md?=
 =?us-ascii?Q?kj2ZTDbbmnrB+BS9uelX5jsZ/jes8bVQpzR831Ac27Udl+IK+1IvRA1ddDe+?=
 =?us-ascii?Q?UROy5TvZhJN2m3/IpuJ/EZEfBuhSLPL8mu43o8EQHLUUhsO60Ew+sjhp+ysf?=
 =?us-ascii?Q?uslMOhvC6jckIhzl3gwmgDW3JdpZlVH55uYIR4SMHcDEAqjw8HjnQ7RCpTar?=
 =?us-ascii?Q?oW5gRtv83PgnHq9t8YiazjGJVy4duxvESmWz3HmxJ/TFF7wKxm9wFvoYf9kA?=
 =?us-ascii?Q?2tst6uhd5SCHTRDmmERlcIK35qSv/+cnw11kiWIF5n2LegAL9wIUaQ1DbPWm?=
 =?us-ascii?Q?Y6OiGT8vd1LOkURXmRgm/W5+FHiZB6ftTkfYVmp9MQU6Jb/8aBD//2RVZuVW?=
 =?us-ascii?Q?Ns3h+289icPqHmdgJZY09mSdbQyxTr8mhOzRmTh2pitwWb0oM/xh8sl6k5Ku?=
 =?us-ascii?Q?mI1e5QEjTNpHOr+U5VP/TbKvzDkKvgiCxal3j0iT0ri72IQKFb8DfPeO9Q07?=
 =?us-ascii?Q?VetEJRnYkLsUdf1+FUljG7otA8tHDUYiZzXOHQ4QJ1tnpAyyTXLYbGX7Hu4p?=
 =?us-ascii?Q?Fu4O0GMN/k1Z0/jHWZq2LKlpYSGh4EGV1BerOWtXAGS69OGKmS8SDPVLsmnC?=
 =?us-ascii?Q?c24g0PnsM86iQwLa9HBQiOiQfU8SQz96QSGFdSvOrdwYkTk9m/ThKPznUz6u?=
 =?us-ascii?Q?hmE6yI4V2jkKtdDUviuGnO6eNyWA+3lIMlmUsoAfYkRU9MgYveOyBhDSEEoC?=
 =?us-ascii?Q?hkExx/GxqzhQW/nN6T6bS7As/NplVEwK25rM/bq9XbaxGHyyrAj+FqitCDBW?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2fb7dc-e8f4-49da-4184-08daf8693fc4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:15.4083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0cK3L6z2PDa5TQ5G+3mo1NjTATgopBRkbXdZG7AaIRBVqkR9S4uujKJyP7V0gFIx2Vuc8q5eVGBdlfZzp+KBbQ==
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

Some hardware instances of the ocelot driver support the MAC Merge
layer, which gives access to an extra preemptible MAC. This has
implications upon the statistics. There will be a stats layout when MM
isn't supported, and a different one when it is.
The ocelot_stats_layout() helper will return the correct one.
In preparation of that, refactor the existing code to use this helper.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/ethernet/mscc/ocelot_stats.c | 40 +++++++++++++++++-------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 01306172b7f7..551e3cbfae79 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -228,6 +228,12 @@ static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
 
+static const struct ocelot_stat_layout *
+ocelot_get_stats_layout(struct ocelot *ocelot)
+{
+	return ocelot_stats_layout;
+}
+
 /* Read the counters from hardware and keep them in region->buf.
  * Caller must hold &ocelot->stat_view_lock.
  */
@@ -306,16 +312,19 @@ static void ocelot_check_stats_work(struct work_struct *work)
 
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 {
+	const struct ocelot_stat_layout *layout;
 	int i;
 
 	if (sset != ETH_SS_STATS)
 		return;
 
+	layout = ocelot_get_stats_layout(ocelot);
+
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (ocelot_stats_layout[i].name[0] == '\0')
+		if (layout[i].name[0] == '\0')
 			continue;
 
-		memcpy(data, ocelot_stats_layout[i].name, ETH_GSTRING_LEN);
+		memcpy(data, layout[i].name, ETH_GSTRING_LEN);
 		data += ETH_GSTRING_LEN;
 	}
 }
@@ -350,13 +359,16 @@ static void ocelot_port_stats_run(struct ocelot *ocelot, int port, void *priv,
 
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 {
+	const struct ocelot_stat_layout *layout;
 	int i, num_stats = 0;
 
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
+	layout = ocelot_get_stats_layout(ocelot);
+
 	for (i = 0; i < OCELOT_NUM_STATS; i++)
-		if (ocelot_stats_layout[i].name[0] != '\0')
+		if (layout[i].name[0] != '\0')
 			num_stats++;
 
 	return num_stats;
@@ -366,14 +378,17 @@ EXPORT_SYMBOL(ocelot_get_sset_count);
 static void ocelot_port_ethtool_stats_cb(struct ocelot *ocelot, int port,
 					 void *priv)
 {
+	const struct ocelot_stat_layout *layout;
 	u64 *data = priv;
 	int i;
 
+	layout = ocelot_get_stats_layout(ocelot);
+
 	/* Copy all supported counters */
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
 		int index = port * OCELOT_NUM_STATS + i;
 
-		if (ocelot_stats_layout[i].name[0] == '\0')
+		if (layout[i].name[0] == '\0')
 			continue;
 
 		*data++ = ocelot->stats[index];
@@ -602,16 +617,19 @@ EXPORT_SYMBOL(ocelot_port_get_stats64);
 static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 {
 	struct ocelot_stats_region *region = NULL;
+	const struct ocelot_stat_layout *layout;
 	unsigned int last = 0;
 	int i;
 
 	INIT_LIST_HEAD(&ocelot->stats_regions);
 
+	layout = ocelot_get_stats_layout(ocelot);
+
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (!ocelot_stats_layout[i].reg)
+		if (!layout[i].reg)
 			continue;
 
-		if (region && ocelot_stats_layout[i].reg == last + 4) {
+		if (region && layout[i].reg == last + 4) {
 			region->count++;
 		} else {
 			region = devm_kzalloc(ocelot->dev, sizeof(*region),
@@ -620,17 +638,17 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 				return -ENOMEM;
 
 			/* enum ocelot_stat must be kept sorted in the same
-			 * order as ocelot_stats_layout[i].reg in order to have
-			 * efficient bulking
+			 * order as layout[i].reg in order to have efficient
+			 * bulking
 			 */
-			WARN_ON(last >= ocelot_stats_layout[i].reg);
+			WARN_ON(last >= layout[i].reg);
 
-			region->base = ocelot_stats_layout[i].reg;
+			region->base = layout[i].reg;
 			region->count = 1;
 			list_add_tail(&region->node, &ocelot->stats_regions);
 		}
 
-		last = ocelot_stats_layout[i].reg;
+		last = layout[i].reg;
 	}
 
 	list_for_each_entry(region, &ocelot->stats_regions, node) {
-- 
2.34.1

