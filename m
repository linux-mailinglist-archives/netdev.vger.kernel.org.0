Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319B068AA64
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjBDNyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbjBDNxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:53 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8B834037
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mARF21AuQyiWpZ270PqnzF4jJ1bM/EHPdpyFAknNoHz3MSSVom4StN160x5TaWAxqduxZ/cxEed7f0yss+HS++DGgoGHRMifLkAkTNnwsDhe9j/d5uA9tGokyWN6M1EvhlBr5ZRdc0SiV9RIjB9sEmAgOuU/5iVbUI/cRsNHlf2bPSi3T/UP4j3oMdzYKVv1VvgYRYmVm3+/W6RUg/CMO/c/rkDTSnOp0b0+5tUw1YG95wo401wCSsiMq+al0jcfaVulYvryC6ceuVtFZaGKTPnYDSgdiq+d3V1Lm2o7lXEgArqLCkSgfQryanWCVMJNxAwLM+gfJdU16UCd9+FLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSBScky2drnV5xp0ii2dFtv5lhAzk85dvZQu6Ze5Uxo=;
 b=Arpr1kvYxQm625VoHqZgh3woP5YtK725+D9twhJP1Bw4Pi7fgSeiE6Wi61kmnrRm8YbG0+23/7L/TOn8cRj2QJ4w/yyyhf9R/Dbjq5URgUhSu5V4PYkFmVSUDKyhaqm/IrPOxILUWGP6lKJS5e4ia+dSWKcJNrheNIJSmtl84ZRQGDwm0kUKS4i9wOhUDw3SQzFyMHsXtPpwylQzJWsRBNO4DcaAWYmypVRmxlry2ecpgqqHPeEr7id2dVrFISmOAw3T4cRb59mG1yivmo9m/GFtSxpMY40wi940CvoE5Ek7zd/0NyWJiDACxs+3Y5n8a85kGfsusI6f7ddzSJJ3uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSBScky2drnV5xp0ii2dFtv5lhAzk85dvZQu6Ze5Uxo=;
 b=pozJ1P4YvjRvpbVYxl6/naOM8xC1zbmLdzusWFup40iOMaxYhel8amcPuawbQ/E5atY618NhoOjeGKaKWilpxbpzQr0JHhsJXYZZkQ2xZcNTR6kG23/N8ySQSTRZ9yF9uqceJJb89ikXWWH4oZZ8VJglyXrtpG6Ti2hN7A3SQJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 07/13] net/sched: taprio: centralize mqprio qopt validation
Date:   Sat,  4 Feb 2023 15:53:01 +0200
Message-Id: <20230204135307.1036988-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 679c1f0e-ec41-4239-4473-08db06b73511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQ8ZxBMzFIWznleYsSe8k0g/mHK7VyXU4CZ/lmB1nuzpcVIglq11/fSClr74+cW6RvNQtQKUYx9iKtvU/9v2YSx0y/i8Dp4piwQghrE055J64c5PsrNwyojrTyq8LntM72Wv8MeUCu9IV1QeVJsDGw6rSDZkUdzJD23V1CXh3sryqAMxUvGmfSdyRRbHlWjdwgUZKk3iVuh4mBhu9kBG3jgPIkc5baa6tqo0IOAS1OW3JjDffBk82yRvbUO0tHwkx7ErA9TS0yf5aOV/ZH+ATi/teEQcEk+138lUa6wxI0GJbLfRAh6z7idol52kakgGaI5IlTeRgFoSoZFncU6GFCTwwwdW1XmnVBk7iVZVSJM6eTtHlLkKj5XUln/6XLyfyx/gE+Q2ABeZxeb4emwPLlCYJFSelZZZSFc1rWPD7ms1zG3PJ0tkNkxCBOJ+/pLdV42khUriZwarmr/KlmwxMcDml7fBNMigKxh4Xe3WEcoZRjIIEnLccWyYjJu06xhA0hv9Zx0zHT62IZdZo64e6ZPvtaoI2mcr18kRgSCy3geutzHtIwdvl5dGGTRf7gjcOq2cftZLhZxrrFt13rdHkCEr5GJA8TV3lzs/72G4ZZmosZ3anB92tDcLKMTUrmEmW0FhgwR/lxDLi0fNDKEHploKXGDTMHOvXNPNKiP0WpoOY3y1hr+tpBjcEPjtPZHY1NRueDRXJj3ZpxvfiYni5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(30864003)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T6S4a+Sc8pT373k6YiGP5qZraegvu4HZR7VRXQ+rPuoZNko3AUNI8JKJ+b6J?=
 =?us-ascii?Q?4SSSlhvGm+0oza66EGCO7uuRjHMO/EhuQ9dlgEoMLbOSXZCj4biDSss/r7JD?=
 =?us-ascii?Q?g3dVoFlRRXO6XqIKhBsF+d4p92qHmQBUGnLwY6/ZDrgy9yPTyMbp7hPfIF/s?=
 =?us-ascii?Q?FfCym0lee03a8CLmLx6IhmZiwsnYIf6gEsdIIGAFzjwWl8AVUBPomREd4C91?=
 =?us-ascii?Q?PPLiGXXjCS/Z12aC28MSREMxwOT6HjCEP5gqZzEtq2MozqKw5lVyVYVbqeNR?=
 =?us-ascii?Q?9fDAp7F6aqaYYKHGoAiHASRjgNQb+fBqOB2NzvqKK/g/f9G5skcNl8FdwVQU?=
 =?us-ascii?Q?l2JtYjBB33Z9POoHVf9ajHynPQaDkZjJBSnaNRWOfhpyRD/Gc++wBg8+V+qE?=
 =?us-ascii?Q?eDoZedw3mgag8gSKfxBkmhF5qT7JsYpSvyjV9mTJGHB7GgyhqbSzAh7J3gxj?=
 =?us-ascii?Q?U7+Sjsi/doyfHXI5IVfUN/ibucID2rT9cdns275XWbE+0Ze+j2Wpef/+P4rj?=
 =?us-ascii?Q?mcc+Wiet9LTwNth8/63A5sv3nH+JEZODjbOLZ3gW94MhIy5I54IEAQkMMZyI?=
 =?us-ascii?Q?OL6IXLC0YzQ1KTkkaWhGKmJ1r3MOYAvyx8NNW0h5eKx4cdgQcbVLQFicoCbl?=
 =?us-ascii?Q?JmESZw4dt2AhXFKYmeqjiLCyXZUPFISfCz9/XnmxNf8f2MM62tJh/nkhf1B7?=
 =?us-ascii?Q?1xSSOhJCXZ03Jd9JiMZAcsJuabcjNKN8nO2SA1YE6EAVWptoLZLm2gwCvCtT?=
 =?us-ascii?Q?O486RI7cqwW2RW2T8wnadPIHdrx0q32GmyWmr2NNSr6tdPDPiU+HRUoyA4E2?=
 =?us-ascii?Q?21tHMct8E6sE3XssZ/14v0lOtigdsl4NLdX/46NDmt9a7ebe3VWWr6pvgbQh?=
 =?us-ascii?Q?5fsA/u1mPN+JVdmKl0zxTZHYkcZ948um5tDXXlHLVgcu0DyzTKNxUUItenmU?=
 =?us-ascii?Q?ApSK/M2fTH1HW2gsMkUPqV/3CGc+pL56uBjES5305OoPBS4yUfUbkofw2vGi?=
 =?us-ascii?Q?yXNSABkQV5SEQravcxn2UNEmpmZhAA+oCGmXipDNJzHuK1E1cBHWMKTjO9yb?=
 =?us-ascii?Q?z/qv86hu/iCuh1z+42OVkNfVF52PrMbyzHTkcfLOuXIgPqPMUiD03J63apC5?=
 =?us-ascii?Q?E0EQVOX1rcSVb6gOkMu5IWakZZoNegSybN7zc3a7T9oT035fEdYf2iUSmyhW?=
 =?us-ascii?Q?2e+IcoUN/lecsAnB7e4pzIUE+66/A3ZgD6CX/TgHQ3HSoJKYep6cSD6LkRKj?=
 =?us-ascii?Q?nFxVFnit9IP6lete+Qf9h+P6PgpUQr8YxeUtWb79n1LOc/Kohx09PbmpYpMv?=
 =?us-ascii?Q?58+9pfrkl9TtJe29TJ+e0MiaFuNQfMK/ntNiEfkQ5LkSG3ZEJgf3aw+gLSDu?=
 =?us-ascii?Q?PdmUVdGVFUPTYMoSiuoKxvvwY0xKokR+HwNBtzlrtnoBriIFiHMke6zBH8SN?=
 =?us-ascii?Q?/pfqsKLHC5gxySM4ze0cYhrVJtMwA4R3uLu/opLR/UtDN4A46hijUK4g+k9G?=
 =?us-ascii?Q?3unHWgOOrpNWZsnF+bw9eVWNJPG6eggNT3bj4CWNW8riPAf0huau+m2dPAvG?=
 =?us-ascii?Q?1P5U9Glt7nbPqTqUYh3gjWGgOtPazkZtfHK1ng0z6OByhTr2ZszpC4bcxN6t?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679c1f0e-ec41-4239-4473-08db06b73511
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:34.5444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3X8aRKzXI7UeYZJ01L10E4JWs/+5JMiWaO3JqpM0sL5AsbExlCIzOVjm6atg+EZhn/TGRLISMfZBznVLNhjUnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a lot of code in taprio which is "borrowed" from mqprio.
It makes sense to put a stop to the "borrowing" and start actually
reusing code.

Because taprio and mqprio are built as part of different kernel modules,
code reuse can only take place either by writing it as static inline
(limiting), putting it in sch_generic.o (not generic enough), or
creating a third auto-selectable kernel module which only holds library
code. I opted for the third variant.

In a previous change, mqprio gained support for reverse TC:TXQ mappings,
something which taprio still denies. Make taprio use the same validation
logic so that it supports this configuration as well.

The taprio code didn't enforce TXQ overlaps in txtime-assist mode and
that looks intentional, even if I've no idea why that might be. Preserve
that, but add a comment.

There isn't any dedicated MAINTAINERS entry for mqprio, so nothing to
update there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6:
- add back lost comment above intervals_overlap()
- fix allow_overlapping_txqs being passed as false for txtime-assist
v4->v5: patch is new

 net/sched/Kconfig          |   7 +++
 net/sched/Makefile         |   1 +
 net/sched/sch_mqprio.c     |  77 +++------------------------
 net/sched/sch_mqprio_lib.c | 103 +++++++++++++++++++++++++++++++++++++
 net/sched/sch_mqprio_lib.h |  16 ++++++
 net/sched/sch_taprio.c     |  49 +++---------------
 6 files changed, 143 insertions(+), 110 deletions(-)
 create mode 100644 net/sched/sch_mqprio_lib.c
 create mode 100644 net/sched/sch_mqprio_lib.h

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index de18a0dda6df..f5acb535413d 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -195,8 +195,14 @@ config NET_SCH_ETF
 	  To compile this code as a module, choose M here: the
 	  module will be called sch_etf.
 
+config NET_SCH_MQPRIO_LIB
+	tristate
+	help
+	  Common library for manipulating mqprio queue configurations.
+
 config NET_SCH_TAPRIO
 	tristate "Time Aware Priority (taprio) Scheduler"
+	select NET_SCH_MQPRIO_LIB
 	help
 	  Say Y here if you want to use the Time Aware Priority (taprio) packet
 	  scheduling algorithm.
@@ -253,6 +259,7 @@ config NET_SCH_DRR
 
 config NET_SCH_MQPRIO
 	tristate "Multi-queue priority scheduler (MQPRIO)"
+	select NET_SCH_MQPRIO_LIB
 	help
 	  Say Y here if you want to use the Multi-queue Priority scheduler.
 	  This scheduler allows QOS to be offloaded on NICs that have support
diff --git a/net/sched/Makefile b/net/sched/Makefile
index dd14ef413fda..7911eec09837 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_NET_SCH_DRR)	+= sch_drr.o
 obj-$(CONFIG_NET_SCH_PLUG)	+= sch_plug.o
 obj-$(CONFIG_NET_SCH_ETS)	+= sch_ets.o
 obj-$(CONFIG_NET_SCH_MQPRIO)	+= sch_mqprio.o
+obj-$(CONFIG_NET_SCH_MQPRIO_LIB) += sch_mqprio_lib.o
 obj-$(CONFIG_NET_SCH_SKBPRIO)	+= sch_skbprio.o
 obj-$(CONFIG_NET_SCH_CHOKE)	+= sch_choke.o
 obj-$(CONFIG_NET_SCH_QFQ)	+= sch_qfq.o
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index d2a2dc068408..9303d2a1e840 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -17,6 +17,8 @@
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
 
+#include "sch_mqprio_lib.h"
+
 struct mqprio_sched {
 	struct Qdisc		**qdiscs;
 	u16 mode;
@@ -27,59 +29,6 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
-/* Returns true if the intervals [a, b) and [c, d) overlap. */
-static bool intervals_overlap(int a, int b, int c, int d)
-{
-	int left = max(a, c), right = min(b, d);
-
-	return left < right;
-}
-
-static int mqprio_validate_queue_counts(struct net_device *dev,
-					const struct tc_mqprio_qopt *qopt,
-					struct netlink_ext_ack *extack)
-{
-	int i, j;
-
-	for (i = 0; i < qopt->num_tc; i++) {
-		unsigned int last = qopt->offset[i] + qopt->count[i];
-
-		if (!qopt->count[i]) {
-			NL_SET_ERR_MSG_FMT_MOD(extack, "No queues for TC %d",
-					       i);
-			return -EINVAL;
-		}
-
-		/* Verify the queue count is in tx range being equal to the
-		 * real_num_tx_queues indicates the last queue is in use.
-		 */
-		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    last > dev->real_num_tx_queues) {
-			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Queues %d:%d for TC %d exceed the %d TX queues available",
-					       qopt->count[i], qopt->offset[i],
-					       i, dev->real_num_tx_queues);
-			return -EINVAL;
-		}
-
-		/* Verify that the offset and counts do not overlap */
-		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (intervals_overlap(qopt->offset[i], last,
-					      qopt->offset[j],
-					      qopt->offset[j] +
-					      qopt->count[j])) {
-				NL_SET_ERR_MSG_FMT_MOD(extack,
-						       "TC %d queues %d@%d overlap with TC %d queues %d@%d",
-						       i, qopt->count[i], qopt->offset[i],
-						       j, qopt->count[j], qopt->offset[j]);
-				return -EINVAL;
-			}
-		}
-	}
-
-	return 0;
-}
-
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt,
 				 struct netlink_ext_ack *extack)
@@ -160,17 +109,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 			    const struct tc_mqprio_caps *caps,
 			    struct netlink_ext_ack *extack)
 {
-	int i, err;
-
-	/* Verify num_tc is not out of max range */
-	if (qopt->num_tc > TC_MAX_QUEUE)
-		return -EINVAL;
-
-	/* Verify priority mapping uses valid tcs */
-	for (i = 0; i < TC_BITMASK + 1; i++) {
-		if (qopt->prio_tc_map[i] >= qopt->num_tc)
-			return -EINVAL;
-	}
+	int err;
 
 	/* Limit qopt->hw to maximum supported offload value.  Drivers have
 	 * the option of overriding this later if they don't support the a
@@ -185,11 +124,11 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	 * - validate the provided queue counts by itself (and apply them)
 	 * - request queue count validation here (and apply them)
 	 */
-	if (!qopt->hw || caps->validate_queue_counts) {
-		err = mqprio_validate_queue_counts(dev, qopt, extack);
-		if (err)
-			return err;
-	}
+	err = mqprio_validate_qopt(dev, qopt,
+				   !qopt->hw || caps->validate_queue_counts,
+				   false, extack);
+	if (err)
+		return err;
 
 	/* If ndo_setup_tc is not present then hardware doesn't support offload
 	 * and we should return an error.
diff --git a/net/sched/sch_mqprio_lib.c b/net/sched/sch_mqprio_lib.c
new file mode 100644
index 000000000000..e782b412a000
--- /dev/null
+++ b/net/sched/sch_mqprio_lib.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/net.h>
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <linux/types.h>
+#include <net/pkt_sched.h>
+
+#include "sch_mqprio_lib.h"
+
+/* Returns true if the intervals [a, b) and [c, d) overlap. */
+static bool intervals_overlap(int a, int b, int c, int d)
+{
+	int left = max(a, c), right = min(b, d);
+
+	return left < right;
+}
+
+static int mqprio_validate_queue_counts(struct net_device *dev,
+					const struct tc_mqprio_qopt *qopt,
+					bool allow_overlapping_txqs,
+					struct netlink_ext_ack *extack)
+{
+	int i, j;
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		unsigned int last = qopt->offset[i] + qopt->count[i];
+
+		if (!qopt->count[i]) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "No queues for TC %d",
+					       i);
+			return -EINVAL;
+		}
+
+		/* Verify the queue count is in tx range being equal to the
+		 * real_num_tx_queues indicates the last queue is in use.
+		 */
+		if (qopt->offset[i] >= dev->real_num_tx_queues ||
+		    last > dev->real_num_tx_queues) {
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Queues %d:%d for TC %d exceed the %d TX queues available",
+					       qopt->count[i], qopt->offset[i],
+					       i, dev->real_num_tx_queues);
+			return -EINVAL;
+		}
+
+		if (allow_overlapping_txqs)
+			continue;
+
+		/* Verify that the offset and counts do not overlap */
+		for (j = i + 1; j < qopt->num_tc; j++) {
+			if (intervals_overlap(qopt->offset[i], last,
+					      qopt->offset[j],
+					      qopt->offset[j] +
+					      qopt->count[j])) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "TC %d queues %d@%d overlap with TC %d queues %d@%d",
+						       i, qopt->count[i], qopt->offset[i],
+						       j, qopt->count[j], qopt->offset[j]);
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
+			 bool validate_queue_counts,
+			 bool allow_overlapping_txqs,
+			 struct netlink_ext_ack *extack)
+{
+	int i, err;
+
+	/* Verify num_tc is not out of max range */
+	if (qopt->num_tc > TC_MAX_QUEUE) {
+		NL_SET_ERR_MSG(extack,
+			       "Number of traffic classes is outside valid range");
+		return -EINVAL;
+	}
+
+	/* Verify priority mapping uses valid tcs */
+	for (i = 0; i <= TC_BITMASK; i++) {
+		if (qopt->prio_tc_map[i] >= qopt->num_tc) {
+			NL_SET_ERR_MSG(extack,
+				       "Invalid traffic class in priority to traffic class mapping");
+			return -EINVAL;
+		}
+	}
+
+	if (validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt,
+						   allow_overlapping_txqs,
+						   extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mqprio_validate_qopt);
+
+MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_mqprio_lib.h b/net/sched/sch_mqprio_lib.h
new file mode 100644
index 000000000000..353787a25648
--- /dev/null
+++ b/net/sched/sch_mqprio_lib.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __SCH_MQPRIO_LIB_H
+#define __SCH_MQPRIO_LIB_H
+
+#include <linux/types.h>
+
+struct net_device;
+struct netlink_ext_ack;
+struct tc_mqprio_qopt;
+
+int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
+			 bool validate_queue_counts,
+			 bool allow_overlapping_txqs,
+			 struct netlink_ext_ack *extack);
+
+#endif
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c322a61eaeea..888a29ee1da6 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -26,6 +26,8 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 
+#include "sch_mqprio_lib.h"
+
 static LIST_HEAD(taprio_list);
 
 #define TAPRIO_ALL_GATES_OPEN -1
@@ -924,7 +926,7 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 				   struct netlink_ext_ack *extack,
 				   u32 taprio_flags)
 {
-	int i, j;
+	bool allow_overlapping_txqs = TXTIME_ASSIST_IS_ENABLED(taprio_flags);
 
 	if (!qopt && !dev->num_tc) {
 		NL_SET_ERR_MSG(extack, "'mqprio' configuration is necessary");
@@ -937,52 +939,17 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 	if (dev->num_tc)
 		return 0;
 
-	/* Verify num_tc is not out of max range */
-	if (qopt->num_tc > TC_MAX_QUEUE) {
-		NL_SET_ERR_MSG(extack, "Number of traffic classes is outside valid range");
-		return -EINVAL;
-	}
-
 	/* taprio imposes that traffic classes map 1:n to tx queues */
 	if (qopt->num_tc > dev->num_tx_queues) {
 		NL_SET_ERR_MSG(extack, "Number of traffic classes is greater than number of HW queues");
 		return -EINVAL;
 	}
 
-	/* Verify priority mapping uses valid tcs */
-	for (i = 0; i <= TC_BITMASK; i++) {
-		if (qopt->prio_tc_map[i] >= qopt->num_tc) {
-			NL_SET_ERR_MSG(extack, "Invalid traffic class in priority to traffic class mapping");
-			return -EINVAL;
-		}
-	}
-
-	for (i = 0; i < qopt->num_tc; i++) {
-		unsigned int last = qopt->offset[i] + qopt->count[i];
-
-		/* Verify the queue count is in tx range being equal to the
-		 * real_num_tx_queues indicates the last queue is in use.
-		 */
-		if (qopt->offset[i] >= dev->num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues) {
-			NL_SET_ERR_MSG(extack, "Invalid queue in traffic class to queue mapping");
-			return -EINVAL;
-		}
-
-		if (TXTIME_ASSIST_IS_ENABLED(taprio_flags))
-			continue;
-
-		/* Verify that the offset and counts do not overlap */
-		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j]) {
-				NL_SET_ERR_MSG(extack, "Detected overlap in the traffic class to queue mapping");
-				return -EINVAL;
-			}
-		}
-	}
-
-	return 0;
+	/* For some reason, in txtime-assist mode, we allow TXQ ranges for
+	 * different TCs to overlap, and just validate the TXQ ranges.
+	 */
+	return mqprio_validate_qopt(dev, qopt, true, allow_overlapping_txqs,
+				    extack);
 }
 
 static int taprio_get_start_time(struct Qdisc *sch,
-- 
2.34.1

