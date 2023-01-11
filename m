Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0222E666034
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbjAKQSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbjAKQRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:44 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2054.outbound.protection.outlook.com [40.107.13.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44605F4A;
        Wed, 11 Jan 2023 08:17:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLmUiHunXXE285em5MBz+qLFz1noyWRBWhxyae5x7Fx8z41k37QQvtahPoHB67WqscmAReOvqVsb+O/mHpYJ45RsB5Myf3fbC1KuDki+4UkNZkmXLtf0mxdKlQnC47Ug6YMJN6Fc9RFcmTbTe0Ny1os7W8gl4bFhBTA+ACQCxtTXr4xRQiqBOxl6KVc2v8FnsAxSr12jxWPY8FFEsLYAwe7Hn18dL8QXYeJUNt4KP//kgGGZLZgnqTbM3JqU1oJsXBSxlt5rY4mpx0GY4FcEDnzcnFFAbuDXQ0z6X++XUYwo77sCjgB2pN0YeHMlSpn+D41VtNtWnWbZzJrdfeSsLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfGDgR8XtBdxz/tXCK4dGk2/b046Jl6bSnKzUfD9r/o=;
 b=Oo9f5lBNjM54jZu4KsdZ9fxlGJO13MFVcEXT92pGMyHPdjS0CvgqwK6U+QJDGYyg8b2a45wpL/eydVEZ4A5qu55R4vIPm132gaisb1UUJ2+u7rllVArvrJI4EJg3I4PpE89e7uQzdXcnRsNjZv9SMV/j/J2iGWYBZIrJ2GYSbpYlthUK6+SAGuxPh9mFSjtRt1hTtRpHkiiNEbLgOEztO+bMDvjwkgS8GNEmvVGrnsIqx9pNuc7zW80krg2r5KjAH4L000nuzobe4qFqDlst+a7cGdQHgVk464kjj7OvphasLkYK0qVru5gRSZjrt9bUkUVxDLGDI35tveGNdJEmog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfGDgR8XtBdxz/tXCK4dGk2/b046Jl6bSnKzUfD9r/o=;
 b=AHZ6dMCge+269GRCu+oMBSKHhhOPwTQDpPRvUkjCqD6hsKbY9wlWpchBpRDXiJZht04I2/xTx0MEiEBTPHdsNtYDw3lT6LfMgw2BkuG7C9jaF6qfhH4p3Gii6OXXQJlyJzA5LIEYn40kaE5OxcdUCSlxi5gL0ZXTdfdtgzUd9GA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7549.eurprd04.prod.outlook.com (2603:10a6:102:e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:31 +0000
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
Subject: [PATCH v2 net-next 10/12] net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
Date:   Wed, 11 Jan 2023 18:17:04 +0200
Message-Id: <20230111161706.1465242-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: dfe4acb6-ad11-4468-2bc1-08daf3ef5727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4g0n9FZvecSWzszyiU7mgOCDYm1s9pwPOBATHqwHlUF3tetHzhiqBV5EmwNs4VxIft50yIRlBF7Ywmq3lKX/2M+fP7XHaCLkTTLz91Jr4S0kahU7NvCihwwyTWJRInIofWrbaj9EBRwYpLZX5pydXdsiLcKYWX/OEIDIaMFaOlOG+TpiOehPRA9Ie3aH9BCi5WfDzSBW+9zMxtZ2gO3veDrIxfeHVXU7dypnljkpi1bvidgHfcCtlRhioE3+f6WtdZeH5cEErVs9Fo04qzFzF2CBHD112bgDn2G66lMNnFNcvK/1ihS4vK4OfP8rbRGHhh2E6mR7kSXw0VkxQKOqhcEsgF1q4CtGvMN9YK13j722FM8ZHHBYBSubnGNaPawzFNrG8oWUdcy441f801MRO+J8xoO0vbpA4Hufhmdq2S/rCdPCiofQkKRLkkGINaG736khmwc/wYJKWKrV6Q3vwZwXPFLsaVQJdoaR3OTILDIVV8olcxJothsZsdGfxwjju6vhueHyPHzZQ0tAEo1xWEYShelG9Gwrhf62FemQWvx7A9iCLqzznnivF5E8vLuJfi17ACg/FQgqjO7cJQfmn7q7mlW6iagIenjmtncS/7+gp/s8qJZr0+1CPGCjvQNDyVZR+VE1sCVgxhB8ch9phKAk9BqyEt2GMmnqVQfQ4YCZFVYsoQN7gfNJ9yJan23m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(36756003)(38100700002)(8936002)(186003)(2906002)(41300700001)(7416002)(5660300002)(52116002)(6916009)(4326008)(66476007)(8676002)(66556008)(66946007)(316002)(54906003)(44832011)(38350700002)(6512007)(26005)(2616005)(1076003)(86362001)(83380400001)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DoUAGu176m++ID/iO4/9uYhOiRnCtd/qh9KZfFKpmwc/t/z/XHIYm9IgcFhg?=
 =?us-ascii?Q?hSEyldJpdUij6uJotfBVDyeVL/G1HAfIyJosA+FM8+I7MVJzY1vTPR1QY7mM?=
 =?us-ascii?Q?rd7rDo9K3VVbLIk3aaS6ccpPEn9w2uU6pCEcIn0DppuY/Nk9D8KItiCMV11v?=
 =?us-ascii?Q?LixALyk1d9zILBjDwBNPBe9mJJlrHeMwQZJJhMjPfZRAdV5cKQM/vr5tXRaK?=
 =?us-ascii?Q?YJjlwlBBH40ZkdVcSQabrkQ2ETPdRNmuqWEVsHzAvoT1/ncSuf2Xpsw8NfLE?=
 =?us-ascii?Q?C0/IP+B8ebtkBYDnUfzt099Y1gnSQsqD0EXmEnD0yhnTII3up6qoykLm/t97?=
 =?us-ascii?Q?/03lZKwhzeuNXRVDJBFV8cGjf74mkQv+S1/EWBRHD8ehvY9+mma+/cXXurZb?=
 =?us-ascii?Q?/yfUf8fakYbBUNqM+3/DGe4/e9HMIEZpoK1nBiD+CjYfa7D4q83QZNOw5etV?=
 =?us-ascii?Q?4MMtNzhQfvPaM66BE1RogXklofa2xDJdACuE1Gf3x9Hkx9+mmX/xhtLEq2F5?=
 =?us-ascii?Q?1WxzLcwGIO91HGtRfALLhUjN7U6svCoUH9XRQ9cF4+9kX/E6vcnNFxI2zHpL?=
 =?us-ascii?Q?+VKEylxU+JCx9XGg9Fgv9/KXfcG1gyaucm2ae39OWM/kXnvuQBUqvvdXX5ws?=
 =?us-ascii?Q?mtYvHzzMUWyZT0mqMqAISPtWNRbajX+MH2vx8ra0L525kx48kgf8aODRYZlA?=
 =?us-ascii?Q?enBwPd22j3GI1cE3FP09Y6RhKPrVxoqHZxKDyAylyKhPXyoB1WIzH0IeEIBd?=
 =?us-ascii?Q?qPzAcY69tSSNacc3YvFLYSFBpgXvotayKMNGN+2ntK+F2M5g+vc7VGLe6lv8?=
 =?us-ascii?Q?KWvh2GdDLZGUcehj9zEBZ16RXjpaEPEFLFcQllT56dqu+6U4GHKxZZpZqdyl?=
 =?us-ascii?Q?oa1n3/xRdlNsY9Re3Jhf939NFSnNGN35QhShLWXng6izmVt2M/za0KqtE4wO?=
 =?us-ascii?Q?p63PnQfmFyc8C8uW4NnXS5vqe+4RgJVrwgIMrPuu+89e6pLlHhHk6nfildcZ?=
 =?us-ascii?Q?p4pBiNyTLRVrI/P3LMEw6GXo85J9Zf0EIcDgP9B5IIuTe8e5DuRWbWsm4Q0K?=
 =?us-ascii?Q?WP+doBK9cJN6nOaf3WRJ36vOErrP8gcdOu1xxhTtxnoXMjnWZpliWbew2ZBU?=
 =?us-ascii?Q?8LOaHCu8jycnDcOpj05K1owcokLd0SEscUyZUyZk8IqoLWhVohScXTbB3WIZ?=
 =?us-ascii?Q?AumOk0V1ku6p9mn63KB6soKDIUxiLjCN0WV1diptyVoSmxJiYi4HK7rywnlF?=
 =?us-ascii?Q?iFRMMLtSZ+63fGNwicykhM7cM5X2n5LcSf7rxFLrpkhO7qnwUucStXlxMB0O?=
 =?us-ascii?Q?KOawREKLxn6EWljnm+fzS37w7DSKycqJFP5Z6ojHsST6lehVlP+AeUP3SeSe?=
 =?us-ascii?Q?nLqnHQAzJYvulHa0ljVvMaTQP1UUr2u5Xrt/aXqSN739CyidIDUKgxLkqmtE?=
 =?us-ascii?Q?Vgk14fntO3CXfSQ/Ty0UeMyyqabfzoKA6+AapcHrgoeEewQppARlMTC1XVLF?=
 =?us-ascii?Q?dAw3XDT1OIjmAgrqtfEpzy6+oF4ykJhhA9FSUN8nXsqdK1ysxrvJLld8c3w0?=
 =?us-ascii?Q?W+tbsT9+hXfTCoRXkKV1YHjVAUZdlckN3UVZj9YzYY7yNJusFEowAEvbNt5B?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe4acb6-ad11-4468-2bc1-08daf3ef5727
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:31.2827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EETpE2opMYtrHXAq6kpu8J1nsZSAGJ9X0ztdqIoQo6F280C+A3/txJonvVIyzccVkOJYsevlCHgMW36Kk/k+CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7549
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

