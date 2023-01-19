Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF2E67387C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjASM3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjASM2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:28:04 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9190F71F17;
        Thu, 19 Jan 2023 04:28:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3IZUkN22D2m87LpMXMKotSGmSTUr3aTwK3oBKv8Li8JskXSDjW2oyXnb2idQRXH4R0htJM2cYwmg/dCqObSEUxs3F4Q8//AsoHlUOMdkbRP8ZMX4xCDLlTg+Mh9aBYgkfhamNOAZct7exLstBZbPG9EJ6DNnSv5AmRgJOMPX+XH/5/ZZuYe8VJOzeF5tV2pVYDFBeqHNoFp/nNkDHgqAPZJ1NyJCze136vRcMQP+p2bNVBY1Nj3KXbahxwyZ9fz5VqjMLr+3jsp+ftCpcVgEq2Al0KEmE/4/f56ktZ/AtGDlnx3CUUHMlR98soslYXrOG11XpTDmID3OKmt2pUJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+vYijF6RivZml5xLzO5xYG1FrZUa+bWRjEFZw72mzg=;
 b=YCvIcBp0GhzhbqPUbMZCm8ZKEMT4iX0puBimk0Cgui1HTPcyu4ZLMFGUmtrNlnuf3q9/dCtyvNi4/LYyG8kTf3GEghx7jbKVtNrPsXUdCHiZ7cx1TehnJ2g395NV0QKDqGZmsUYONt4ZuX06kdtMnUMYZznwF+rhLR5VNkW4yK63766MhH/gwkDICPkOeZ/1r3vZ1XXzkWLZdicKcCQwQPZ/Kn2QcbSpJQqHcxLJoiBZbm/J4lS/bEDagdFS2a76JAG0f8sRBmSdu2sUlSgrbNOJo4LEGFxl2y8ydczW+mTTE8QkgSXqNBp6knW1COvQKiSwueYBg6oRrGpwnNnUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+vYijF6RivZml5xLzO5xYG1FrZUa+bWRjEFZw72mzg=;
 b=XuxVV5CyRDH1NdCdTNoGV/12elTr9pbjpt/Cq8QAZoRDdkTLm0r0nl773Pc4Zsq1TUlNsAcvHtWqTxwdIUH2Ol/slHGB97QbHSJ1511bEdrca7hdtiZiY/HEXmzKzBfgQUQxU6pnCojD0iKUWPnxdiH2gXX0lMD3hGdMmknguCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:28:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:59 +0000
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
Subject: [PATCH v4 net-next 10/12] net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
Date:   Thu, 19 Jan 2023 14:27:02 +0200
Message-Id: <20230119122705.73054-11-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: 29047ac0-37ef-4995-2b7a-08dafa1899f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2WfE8iYJN6c4PSFZljXYuktCXh1Ln4QITlmguO61OPbOUjAnslMEzyg7F++/7A+2OZPUSzU2cetXqzuFgGfzyH0nVa4UgBFy7orv11B4yhESzHT59GlIg8YekSCv0PhNU49eeaRow41ol85U6gB9xUF6Izr3JwPqDekEf9jiuD+dmrt0JhYTI7ojBQkI76jJQ6BglW7oeoP0P/tgVCLJfZucIqgEBXfyO0+4Ri2pTXf1Iqp/0VFfvreHlnOYx54xxDYBrlwlgInATqS16UDqOTkS2gX5Hhl+JtmmCDdcG2H6jG+bzILaYsGy22ok2zY7YgvRastZGE7LD214cTrPVTzjw/zvIjav1Rdx8ESrGQxaQZAXRCoSaGQo6A17IkIcPIWhsVSRoYGLFpvFwYLy4ksv8urIJ1P5jx7DIssN5sVLeiHGVCP/0mZrXAxX2QuWAgVjO6y+R/E6WOoX4Sl5ehw5A1u7V5YYZ+7sTWVEa0UZMhxRtQ9YOCe95ILNUrysZ9rLnvsSMug0n8lpqQPsmhjvFr+XMHCVNVs0419iX6zGYnzhOFttWAx/DUvlbRHVKtntC88DneJZOYbZ6Ddhj1FSBls1HAnd/mmIdBi88X631j7xUqueeCgiIELkYVIpIL/CVZTii6ZsCsUoGtGmILFhdaWUtW1SdIAVsBF2c7w2ZfQeJOj0uVJdAI/9cCCJzjeQJn6Yxjl72CqMcqAog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+dN6qYuIb2EF2b9MRkjQVrCK0GNzIkXhzqv4keU7PmqkZoBoWMZyQecbIC4y?=
 =?us-ascii?Q?k1+MkgLQkg6+eGGAp9X534E92Fv7Cz0ODv2ElST9NFE9GCC2i11p0GxIoXQT?=
 =?us-ascii?Q?mXCxAxybs2+yOZSz00cS4q2RpblzSDWbFk7tDIo2Kh36G8EHNqbiU1FLdXv0?=
 =?us-ascii?Q?fXNYFMVRZs+DQ62NZlG135dK1x37byefnpX7yV7t+kjJbM7GCElIUZaA1W6z?=
 =?us-ascii?Q?2ayQbEcB96VZ77HUZ41wHjot8p2uVthdUtbygbWWK4L6Endlx1gVQ9vfdaFq?=
 =?us-ascii?Q?Pns3+Y5kzyMdSay1W9eUJ7FBbsr8OvjQKv29wZOdLoTkOLTE09s5U7ztsBjx?=
 =?us-ascii?Q?OmoKfgj8SWW6vFDqwrjJOBsF/TrY/utJWJsA/9tYf0ncnR+ZOTMZJrctqaZB?=
 =?us-ascii?Q?VHH7CyUlzx6eaZcLMADxkaiDKhcpYIHhGTkX3knuTzYFaOQPo3Z/DfFeXmNu?=
 =?us-ascii?Q?CbxsYMW+2iu8PPbciqy7leB9RsX8A0+io41eam+t/0kKsKtxpOKlsIWGHxsr?=
 =?us-ascii?Q?7pJMLCfRbGzsI2Ly1xJ7A7RVW+ACsvO/HMHQLFsClLFNJvsgwyLU4MPeEulO?=
 =?us-ascii?Q?xCuwi3Yj/rF49vUxW/KJzUl8ZcEcU8U2KMijLaSFNDPlb9JaLbrGyWntoRI7?=
 =?us-ascii?Q?l3ep8MGA3vi7XQUbNJv0mEnCFvUx1FgK0ebzWqF1ku4IoSy/9yoBzAdcA4BM?=
 =?us-ascii?Q?NUbW5ej1SuUNOLhKmRc3u+uG1eVFfkPizxgCMa9i0JxP07uCSfVGKSBSe9e8?=
 =?us-ascii?Q?LL+KyuPGPrbu5IZ1ya0DK5VB3eWnivbhdl88aPSlpikENwDIoHb8lxqwUQlz?=
 =?us-ascii?Q?DWVTon9RphG+/Os315EwJTLKc/C8g5vJH7g1ccbn1pG3krwyu2lIsJmSAOCI?=
 =?us-ascii?Q?EEmD1Ms5lsE/ugGvHmShS3KCq8EmB4ITlQUP1VWX8A2F0HZbcDnbHu7ZKASI?=
 =?us-ascii?Q?JmIJSHqDTviyTPChWvk+rjTVNtn2UfRCZQs8J8wqNUj1CxVo3d6lAX5OdUOq?=
 =?us-ascii?Q?No3rTdAOGNE9MyVgskym+1H1BvTjfnGTn2Rh5Q0y7nwwvGXCa6JrvW73SFuY?=
 =?us-ascii?Q?1noepaS+j9t8kgqPTJAzCvwm0T+DwuaO5mZoqykglRQaanyrsCDhKIFdFXMh?=
 =?us-ascii?Q?jbeaG7QWpX1VEd2T+u9t/buTY0u2Nbcw7V4AAPQnhUtt2hblSqSiFEBsvQjz?=
 =?us-ascii?Q?7QAgvuJCMFOl/oVDfamOetXZozVrGNrSUvgTy7T9M6ePKl3UXbuqnGTxHWx+?=
 =?us-ascii?Q?1L2saBjPj1dWEOQa7rN8kAE9oGUmvmRipETmvTzhyCKH+eMs+Bz9kLMcYnXQ?=
 =?us-ascii?Q?0WcWpOpT7gEqyQQ2vq7HYMGW7btPa5dA2ZDk72CYkUb6vP1S1r2G+DyXLY8+?=
 =?us-ascii?Q?RyL6I+UUha8ay5PcO5n7gxM56BsCza2buo1T6xckNT71v3Hueh0G/JmBQf/X?=
 =?us-ascii?Q?R/Ld58ik9Tn039t7Y96xKBouu8m6YH0ifWkcDtMoLTk9KDiCSO/61UFdSRKA?=
 =?us-ascii?Q?cd1kjI369JGm03ojIlrs0VpGiSQXfN9z57ytrCer5XvWZXVlXNg49dcdcZPA?=
 =?us-ascii?Q?VrmM7KtxcjfGXWESBDP5dGZ3Q4JLjXPwCGeof5UcutGXShLugpFbzSU+VwUG?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29047ac0-37ef-4995-2b7a-08dafa1899f9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:59.8561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uTlCyRQBC6WR6bHOudwUyiRu/QpOFwOf9rs79DAGA8MEFJ52h7UnyqXBmMsnCZfualruhQpfWdtRzSdFzik8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
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
v2->v4: none
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

