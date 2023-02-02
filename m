Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4992F687266
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBBAh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjBBAhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:17 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2342F7448D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6u8C5CbL5ySc/p7NlMkI1AzimyJavTreoCgX0baDbdpiSIEA3Puy/ZGyWEFJStCFF19i4JbvFD+imPkj9U/Akh1abzVsrBi0PbVdlAVU6WWZOZl2fIclAZJkL0PBGJ1yxxJRd22oycD4UdOEHSUHgyDw9HOOYb9DZyzRcc8u0tzsC3JR6IJl9J2SURFpxtvIkfa3qLQ2sLSNwTXpiNevPCHCcwoBoJIhDlcCucXfCNKCGOCX5SWfExHzbb0wBPQdWLUL32h11jerhhD2/NrH4NimZnykx5tlowMkHDT+c78g4/5DoEb6NoyMRSYUly6UlwqixaKuzbs9Eoq8oGSFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OHxym3zSKqe4O0DeBlok5hGMlnqeAD7RS55cysdQw8=;
 b=A0959HNT/sSvSeO5itxgdwn/lDvn2gbvf8yHuU0cXaYjK1FbNYIgmp4EuqrHfeHprBx1+OK/Xgz7ukZf+if08WTvv4Tahta7fg3zUE8+AXGsZ08SlHuBglJhqhz7KieuR2rIjgATBxRpl1Mypegh3DCAI1i3b+0eV8XcnMsQKI8CasHE7oD/rfIufNYcgw6oFSUIcE/0+JgixXNni+rdowHYNxXQKRl54t3GFwB7P4lUQNrOgQnxbijDon53dw/enaUEpDUvxL5qLemwB4jVirsRPgscSGmHVnvfSPnsMUX0K+b1BYS4Tnx/bCF5V4PjlU/6MUJeDv0A/IAYQnG9jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OHxym3zSKqe4O0DeBlok5hGMlnqeAD7RS55cysdQw8=;
 b=s1adM0LHIXGWBoyzOk4/qq9aqVSIFAE9WpPocm08iwKjlIeWMFdAhAcS8Fv1qLDe+GPdg/wIgkbHSq0AOaJQguMQr2MySRFq5Ra6EG3TNITkPSZTircixRKPBqVOSa0+yERgW7/EYqkii+wRiLxc5LqHcxZO/iKFAaowgvcrqeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:58 +0000
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
Subject: [PATCH v5 net-next 11/17] net/sched: taprio: centralize mqprio qopt validation
Date:   Thu,  2 Feb 2023 02:36:15 +0200
Message-Id: <20230202003621.2679603-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: ab385a97-8509-4826-a733-08db04b5976d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0q06kTLu+VbNzijI5Xb+Ersc4yRlPqcmapj+5ghRJS+hp0CjdcPVIuwzsq90h/N3eVPSCMEYURmhLUwl4zUjOAWyLWqAhVCgY9ftPvZX++IgkAZn9DIAXNQZNodTIUGxzv/gQDz/Vv5C1aTmAiZgphCrG56gWLQnVK03lWAgkm0Ll71tJOwWQDsIeCBR+MgsAVZV+/trKfwswRu6g+wLRnQ6rsnzeNTf8XewDPx/uvJMEIrTgLTVDdYe5XXs8BCjXP/E3LcbQKXNIOg/I6dVnxTGwb+A0ZevfiyKTFhS4Lbuouj+8XjW64xrGiKhbWfSNUE+RBdPMB95TyTN/rI6xy9uvcyHZM8JoYP5HWZcOcQ7cSA/1raNOztKvLo2OJRcONRx0Mi/48K03kU7fLr7CHV+CnuWGL+bFjMoUAQOD0RPCvAx+7jSJnHNnVSFhMVCCHQ6luBIIrGj6gng4ctXJSsh2HcVjoNFmFlmE8YRA8LpyQgIApYb8GV6It0qwEI9DaBHjME6ZbeFZlVQ+fBhdLCjyVU2HEG04aHS/ZwRAyM5+Yk+bzf16dcyJqm3fUuXdvSFHlArzhyy1J6QZqVH5GTw6PjhSI1PLOYyBx7ixHEx2aC1ydD4QeLLZDY1ryDa446hIXjcgrxPJtpUr3VGg4CvmJ47FmR+zxuyLv4YkUS96f4nLA4WpZ4EncXEAuB1cTaTBW9cEOYr/722gwdFng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(30864003)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zrYIFX/1MKhGWPqsPOzVmbjs1kBiFymAKL/DjXPuCiRXrQKDeKYt4wumbsDa?=
 =?us-ascii?Q?u4H52i8D1Fyo3ANzMU2I3z/5yzUH/Jx2pJT7XoooT6eukWhY9JELPcSQcR+Z?=
 =?us-ascii?Q?BBHSgtmPxfWNKJjY52vLJCATcrtKra6lRdCodcxZRAIibGsU2ijqZgszA417?=
 =?us-ascii?Q?E0WXO1AACkn+DY4Lj9slFoVlpdsAYxQ3yEpZcIWdSKrKMPLGas1jcW6y6T4R?=
 =?us-ascii?Q?iN/tTcyyriOcukn8gWLuNTHYzwmfrJUMJFxh83uYzRvUiGkp4WtGgCtSTpLP?=
 =?us-ascii?Q?beZnBLAeTXPCvETqSy86IxrI+D+bV045JE0MGMk39WYrX5oONl04wIZwPloG?=
 =?us-ascii?Q?PU+Gp/uWfBjIWec1s4M9x4BQafz4XErNBVVyWJOCGU4XRtsdU/7bWePL9L+Y?=
 =?us-ascii?Q?YrkAF8ej/485kGolP+5cCW+asN2G22vJSBwt5UUxyJYX+tVckVLcBY4W4QoM?=
 =?us-ascii?Q?P/OluctjG1SHAngo3kOZTHomPCxilkPApl4MLyk4WOqwiz4D4HU7dB/cZrnW?=
 =?us-ascii?Q?ZRYJYictBsqRd2UghGUUPhvsA5PqsyqCd+vpju3sAaSDcFnRP1Ccc7qVlzRs?=
 =?us-ascii?Q?j/u8TOPhJKbZZE94rMR7dAkzor8VeaJYRileBGbUTBzdNJ+iGGE5nqh/8Guk?=
 =?us-ascii?Q?XCBseFI2FBmdQHb26B3EQ3zXYiJr4RJedwLiHZ9KZrJbNz4ICPXa0JLG2zED?=
 =?us-ascii?Q?ht0MDANtmkNhaU4zPTRcenbsHQFIfcb/92ZqY4UyvbPOoAsJ8m3oixlG1T68?=
 =?us-ascii?Q?WYWRfUG3OOb6Aq8mr77acwkYbERzR4hg8PtsPHgLPNQR0D9uzDH6H8YtNToQ?=
 =?us-ascii?Q?HyB8T+CEO/1smbJFUe5o8ZnvTf5OUYaSFRR4ECn1OGDCY0V3VP+UMfscDrSe?=
 =?us-ascii?Q?lqKPWooai4GraQ+uLn5JT6FSVUjEFvYfHwSObl8xhtJ3yrWIIB5At/6elFKX?=
 =?us-ascii?Q?G6UXSZXrLPqN8w4qWSx3QXQWnFEIAMt8Cmlfxn44PsCTrfFO4+NHgsivGX8Q?=
 =?us-ascii?Q?UzMhZvPP8AJhWNi6Q7boQ+VDoFmszxHWmAXHeeQWiF5DGZbyJjVi7WHjBuxS?=
 =?us-ascii?Q?rVru37Yok7H9XJ266MOdwOh7UGnZogyqJfYkpKoixt+biuE8Mr0clH/8lmLF?=
 =?us-ascii?Q?CwNqM7MX4lRacdcKPGMG5uab37N6CmtVW8wPgtWCr713YeK4Jy3/kxUCjitc?=
 =?us-ascii?Q?3wIcusPWOJpqimXKXj5Jtm9VMrLH9VF7ZNbwvDJsz9qBRhpim/gLviSh3s0G?=
 =?us-ascii?Q?vNlthhwNyrjhmmssV4K3aGv35bjVO38BAfm+ARTTRzDYxz0ND8bcxHAfgUiY?=
 =?us-ascii?Q?c/ec03aGpanOwUeVmBxs+vw96QuRlndFnBpn+dFsiI6gusbnkQr8xnNYZi7C?=
 =?us-ascii?Q?Sz6Qyb31etXe0OCMjDR8F07l4hKuOJ15wMv65pCifINViPsMT7NwoIq/3g51?=
 =?us-ascii?Q?1R40bVAms8NbvsJtkc2NdkaEs+j1eZZL/OtGIJelquWqwrwFa+gB5Ny0Au50?=
 =?us-ascii?Q?+1Hg8fSf7mttBJEEKvHuUryaMpJd9sp1/dNQAD10zS790fbSLHt5Up4mKD+a?=
 =?us-ascii?Q?A6v4rLZYtoYaYClf2SgWi04ecQP2RRmLiMIx+clRv9T9opo8XsbgfycYllQL?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab385a97-8509-4826-a733-08db04b5976d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:58.3100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TIr1fbGP4oyUAEUIigoBTosiEhA7T4yfZ/NSHufBGZ/1EsRovLibcxOSWepbN4JxBvuMSIzVY0rEUNBA6LaCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
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
---
v4->v5: patch is new

 net/sched/Kconfig          |   7 +++
 net/sched/Makefile         |   1 +
 net/sched/sch_mqprio.c     |  77 +++-------------------------
 net/sched/sch_mqprio_lib.c | 100 +++++++++++++++++++++++++++++++++++++
 net/sched/sch_mqprio_lib.h |  16 ++++++
 net/sched/sch_taprio.c     |  49 +++---------------
 6 files changed, 140 insertions(+), 110 deletions(-)
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
index 3b6832278d83..b10f0683d39b 100644
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
@@ -183,11 +122,11 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	 * to either populate the queue counts itself or to validate the
 	 * provided queue counts (or to request validation on its behalf).
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
index 000000000000..b8cb412871b7
--- /dev/null
+++ b/net/sched/sch_mqprio_lib.c
@@ -0,0 +1,100 @@
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
+		err = mqprio_validate_queue_counts(dev, qopt, false, extack);
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

