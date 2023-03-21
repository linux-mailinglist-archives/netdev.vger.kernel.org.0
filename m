Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9DB6C26C7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCUBGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCUBGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:06:11 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EC919C4D;
        Mon, 20 Mar 2023 18:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmdTCPc/CiDXGPPr+cskAUlGE2+cVTlBVzW/SLx6WtN9ClUPTVyDblP+lwRf1bYE/IxORAa2ZpvO3ftCHCQH/FX2YjMVeHur9VuZOyhUhEuX4b8pzY4pV9bic8p80/OeBFHABTSMHUMwe4f9gk+fl70/hw8/DBlc/GzdakqfCst5bebm306VnmSIIy9/guI9f7Dzzqio/mkOr3kRPs4xL30sTLIAXoXiYVR/r7qgJOb/YJ9Za6DKPYOeBi8hHwilXNteLP6Tt3eaQ0rhyGPVJ7qxHC/DfUt9H8HmwusPF6yrbHQEddBeuZOnewdSqBZI/cFZ4dIBEFInt5aBUJumEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5bfq+wIcvIpTyW+F8g/QUhnwvDZmXfg5dOU7wW7IDM=;
 b=UVvUlG9jsMXE1X72GaIn9/40dYfUjBH9O9xQnIFnmu9DMQ5YMjM971P3V4joHEeCWDKiZaEYBZQvs+damaQwkLW8QYnr3nFACw6+YvQzBkBfutfTmkuINkzxfsY8GJSpIRXtwT1abiShk0fLmCPT9Ybiti/1AOmY1Yc9U516h+CadkQQwtwK8p+6Cak7spJBqP+Q4rSSsOjtH5vUZ35XDyIvE7BDq1q/FUCUrVnnjDp3WdkQcx6p+NuCnPGsD5GsGnq24Uv2XOKyjmSjfxzAF8HG66OGo6aYMsboisZVTaI6Lugq3MyW4n3GUT9C2/lS0IrHOH1UWH5muuBmJ0Pfag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5bfq+wIcvIpTyW+F8g/QUhnwvDZmXfg5dOU7wW7IDM=;
 b=gyT/bUj4b25oVIKcocw1xPZuBAoDPZQjW5/025a2CsRhyxfYHLQdMPzJzA9Ubv9FsEAUS25MQE9+oORYWpa2iuHDpXFqrij6GEQ4m4nzrtDOcP0nG6gPJabLyxqaggQmB9clykp97hCF3pNEfpTMTiCZOezhXRAmOmNA7khi6pw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7911.eurprd04.prod.outlook.com (2603:10a6:20b:28b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 01:03:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 01:03:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/3] net: mscc: ocelot: fix transfer from region->buf to ocelot->stats
Date:   Tue, 21 Mar 2023 03:03:24 +0200
Message-Id: <20230321010325.897817-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230321010325.897817-1-vladimir.oltean@nxp.com>
References: <20230321010325.897817-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0046.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: c19406ab-ead8-4a8c-d4c6-08db29a81c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2opAa69PikGDzvVMa4z6IbdpJBYOwMyGzHKq16I6zTyIrvlkpd9AdGauKhi5VnSkYxS1fx0T6Kg9qo6Q1eENo5R15kSPx/7vdZuJB9ajUhJM9qFLAJZpV/8m3JVcSG4YE0lPEV/xx2mw3QhoQKyNod0sLcAwAUs9AzrrblkuHZzfgRektyQZTZ9m92FU367zscegEsfxEy50o8tp0e8KVQTT2Zg29D0SlHVPp9IH5wTPXfNFfBxTCZZW2Bn35RIzrO1dtOFGD8usEy0u+RITyf40oKk9NVVblIy+pw9e4khjQHFYgislIRjA8AeoRgETnExCoo0JoDq8yFg86p9GOezKiKqj12dpyHcWutw5FjJIFRqbE21nO6fgMtNwB5jHtgRKx5POkB5uHEJ7N3zzuh1YJWds3mMF24lxeVzJOlDsrPqIsKfGZtO3KFfj4rgLW2ydUKWk3JwfivzOXUlrxZTtQ3SOgn/fj7UlbS8YdEUwx+f48HP2c3Ets+XEAhts/bP5+SmKnzIwe7EcPoMREis70xmL88CllYbRCvrvMkGXc8Q7YjsnHcM+ogXUEb4gBSzUOBu2V9Bm4/2Ugj+Es9hxMJ/dVbgPrQVGMfNaaY1JsOqN7HDf0/YCOPBC5skQ5zfq7dXHIvOjD/jNpz8Nd0/z0JNNX6zCW6eVg0/3lFg/GJ6Erun3l9M2O39T2DzI4hHdT6o1vHwl91pgnZ5yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199018)(2616005)(83380400001)(54906003)(86362001)(38100700002)(38350700002)(8936002)(4326008)(8676002)(66476007)(66556008)(36756003)(6916009)(66946007)(2906002)(44832011)(41300700001)(5660300002)(186003)(1076003)(26005)(52116002)(6486002)(6506007)(478600001)(6512007)(316002)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JilcWyzTd1WwrH/fiqPreDdl+IcpHJRC5mfZy+Ce8XEyvRuaY70hmSDENWV6?=
 =?us-ascii?Q?7ryDIp1K4Jbf2ASaW9S8NlqnlMP18vN2leF5x+NCKeZHD3taxnNaHQ8eOIKv?=
 =?us-ascii?Q?bVi1M0OfEOeU3WXXr0DravvkHpa/nojtAlpfVZ5Zxq1P36IAs4NDEl3R/hnD?=
 =?us-ascii?Q?po9MRrIXx0xcRNIxhYVE+HCD0JwI8Km+4gpubMaoBB1cSGkWW82zEMQw+vug?=
 =?us-ascii?Q?hsEuus/jbsewL2Tp2oE79+yEbIan3k+Yl6MumDop1cGs4cyvHGWAMZ3g7U8M?=
 =?us-ascii?Q?WabFte2NNZUlmKDXhHxaVzATfhaqCz0BrjCsFqpmKuLyCJ6riRgyohnufmXw?=
 =?us-ascii?Q?jefn94NeGthHKChwDdn95K3MfEpPKH0tKLKGdSzsScojoxhd6shcK3ApT8SN?=
 =?us-ascii?Q?QtEwjaRNkYm/QYaE6SlPoz/iviJk4+poGLOvD9CbrY+tw4IuQzT4DX6HfIUZ?=
 =?us-ascii?Q?DRXm87Qa2sJ4H8ORIUki0hWDx13eueS+SIX5Nlt9TmJGROvl0U82s3ql94Ea?=
 =?us-ascii?Q?UnHxZDpkQ9Nj8YHNorvS7+hsvsBKeCFFD1blRi662IiiLUfZjfph+kihfJrY?=
 =?us-ascii?Q?wZWKa7k1HONfme2+KMIQxrfF/bRHh9H3BLNgffSNho1R2dpNJqhW8Yzir5Fh?=
 =?us-ascii?Q?5dddczuqhAmbAs2ZwFx+beTPkETLLxQiV9LbibNmQzdspA4ZRIWYJ0RXMhVk?=
 =?us-ascii?Q?pKbBiiVddhR4Q53AbVfD1X94w3sK/4hJ9qT0F4R+Y25acC/OVN9GjHZiuzjZ?=
 =?us-ascii?Q?xqmoYaDRqMtmgQe/juX7jyC5Z6B6KQ72g/WfLC4hdTX/RlrPGc+UzHYCj1B1?=
 =?us-ascii?Q?PykYLp7ej4mIimM42ITSTu7WQcd2L3kr7NipWnyAIW0E+oR8El9OWCdjVaRJ?=
 =?us-ascii?Q?J0d+hSDkaDjdvZkl7Ln7CsE3ZQoAWFeh2N/KfX5P8U/clmkUTWKrHJg63J0L?=
 =?us-ascii?Q?RZoT2kteghISWiqm2zwVsQJ5k3dYPn1y9Q6SqjiZwMxCGOSb1y5dhXqQcAPG?=
 =?us-ascii?Q?p+1+yqZQgEimgBinxILBc0W16PQZZIl0RWyv3tf86kX0wPvfO3+LtrIyo9qD?=
 =?us-ascii?Q?H8Mfp0atxzBUVOMdit3C9OiiWToT9jdcXFAA6Fbw8RIF3+YlxC8RLxSIMSCU?=
 =?us-ascii?Q?ADp+WvT6kk3V6yY6zi19H1mJKEiUWHyujWx64MEjwhjd8PYZVmje5VxEY1yY?=
 =?us-ascii?Q?8hmn4xkA38iyL2Bi1P9jbPbPSvYK7LVkAbPwkzWoiAznh2s7ARjIfQ+IoHO5?=
 =?us-ascii?Q?NwQ3OvWPfAnDqGloXEq97DtUxfW4pqspYXf8Bn1HB15hinkB3lyGw7lwUskS?=
 =?us-ascii?Q?HdQ5/DdUDW2WWRnp1MpLXobMBSqUf1Z8xSRzp5HMda8h9mukPQnMc2RJrTkE?=
 =?us-ascii?Q?LDJe7pKTT9/gVVhZ33y83w8WHYs5dSvUidhjwThhjeD78zcBr8aXTxO8n8aW?=
 =?us-ascii?Q?kALUOlmTd33ChYiR6xbbGMonJQrM5QzkbeTQBuaJB/somzWnEs8U8EBsabTo?=
 =?us-ascii?Q?e7ljYQ8j4AmBkZoNsJ6gOlr8U5SdbDXFm1Hz6Q8ID5DU+dATFqNaH66bsuf8?=
 =?us-ascii?Q?Sjfu688Fu+16J3zwI9lGY64KZxPyM9W2vVnxTVPlMuPj0iI040+p4R65W52d?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19406ab-ead8-4a8c-d4c6-08db29a81c07
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 01:03:40.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMSk9jqA+9dxQ2lrvNUfbLCrJfymqVezeUh8ybG0d1FdUbKQ9CpMBqR0UkTDLA5vRzwEF6L/hch4nfjrUwuWIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To understand the problem, we need some definitions.

The driver is aware of multiple counters (enum ocelot_stat), yet not all
switches supported by the driver implement all counters. There are 2
statistics layouts: ocelot_stats_layout and ocelot_mm_stats_layout, the
latter having 36 counters more than the former.

ocelot->stats[] is not a compact array, i.e. there are elements within
it which are not going to be populated for ocelot_stats_layout. On the
other hand, ocelot->stats[] is easily indexable, for example "tx_octets"
for port 3 can be found at ocelot->stats[3 * OCELOT_NUM_STATS +
OCELOT_STAT_TX_OCTETS], and that is why we keep it sparse.

Regions, as created by ocelot_prepare_stats_regions(), are compact
(every element from region->buf will correspond to a counter that is
present in this switch's layout) but are not easily indexable.

Let's define holes as the ranges of values of enum ocelot_stat for which
ocelot_stats_layout doesn't have a "reg" defined. For example, there is
a hole between OCELOT_STAT_RX_GREEN_PRIO_7 and OCELOT_STAT_TX_OCTETS
which is of 23 elements that are only present on ocelot_mm_stats_layout,
and as such, they are also present in enum ocelot_stat. Let's define the
left extremity of the hole - the last enum ocelot_stat still defined -
as A (in this case OCELOT_STAT_RX_GREEN_PRIO_7) and the right extremity -
the first enum ocelot_stat that is defined after a series of undefined
ones - as B (in this case OCELOT_STAT_TX_OCTETS).

There is a bug in the procedure which transfers stats from region->buf[]
to ocelot->stats[].

For each hole in the ocelot_stats_layout, the logic transfers the stats
starting with enum ocelot_stat B to ocelot->stats[] index A + 1. So all
stats after a hole are saved to a position which is off by B - A + 1
elements.

This causes 2 kinds of issues:
(a) counters which shouldn't increment increment
(b) counters which should increment don't

Holes in the ocelot_stat_layout automatically imply the end of a region
and the beginning of a new one; however the reverse is not necessarily
true. For example, for ocelot_mm_stat_layout, there could be multiple
regions (which indicate discontinuities in register addresses) while
there is no hole (which indicates discontinuities in enum ocelot_stat
values).

In the example above, the stats from the second region->buf[] are not
transferred to ocelot->stats starting with index
"port * OCELOT_NUM_STATS + OCELOT_STAT_TX_OCTETS" as they should, but
rather, starting with element
"port * OCELOT_NUM_STATS + OCELOT_STAT_RX_GREEN_PRIO_7 + 1".

That stats[] array element is not reported to user space for switches
that use ocelot_stat_layout, and that is how issue (b) occurs.

However, if the length of the second region is larger than the hole,
then some stats will start to be transferred to the ocelot->stats[]
indices which *are* reported to user space, but those indices contain
wrong values (corresponding to unexpected counters). This is how issue
(a) occurs.

The procedure, as it was introduced in commit d87b1c08f38a ("net: mscc:
ocelot: use bulk reads for stats"), was not buggy, because there were no
holes in the struct ocelot_stat_layout instances at that time. The
problem is that when those holes were introduced, the function was not
updated to take them into consideration.

To update the procedure, we need to know, for each region, which enum
ocelot_stat corresponds to its region->base. We have no way of deducing
that based on the contents of struct ocelot_stats_region, so we need to
add this information.

Fixes: ab3f97a9610a ("net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 096c81ec9dd6..f18371154475 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -258,6 +258,7 @@ struct ocelot_stat_layout {
 struct ocelot_stats_region {
 	struct list_head node;
 	u32 base;
+	enum ocelot_stat first_stat;
 	int count;
 	u32 *buf;
 };
@@ -341,11 +342,12 @@ static int ocelot_port_update_stats(struct ocelot *ocelot, int port)
  */
 static void ocelot_port_transfer_stats(struct ocelot *ocelot, int port)
 {
-	unsigned int idx = port * OCELOT_NUM_STATS;
 	struct ocelot_stats_region *region;
 	int j;
 
 	list_for_each_entry(region, &ocelot->stats_regions, node) {
+		unsigned int idx = port * OCELOT_NUM_STATS + region->first_stat;
+
 		for (j = 0; j < region->count; j++) {
 			u64 *stat = &ocelot->stats[idx + j];
 			u64 val = region->buf[j];
@@ -355,8 +357,6 @@ static void ocelot_port_transfer_stats(struct ocelot *ocelot, int port)
 
 			*stat = (*stat & ~(u64)U32_MAX) + val;
 		}
-
-		idx += region->count;
 	}
 }
 
@@ -915,6 +915,7 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 			WARN_ON(last >= layout[i].reg);
 
 			region->base = layout[i].reg;
+			region->first_stat = i;
 			region->count = 1;
 			list_add_tail(&region->node, &ocelot->stats_regions);
 		}
-- 
2.34.1

