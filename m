Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA7569CAD6
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjBTMZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjBTMZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:25:05 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200971C7E2;
        Mon, 20 Feb 2023 04:24:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3yH2e1aExJAn3nXEEJqfDlnBLbevBzOWK0YNqcBoLS+FwnT7pQiK86wbM3pqgcr444MCoVw6XoQD97qirhGHnbQBW4J+IAloQp0lgoMcdzJYIwLXcbqk7b9WFcLRlo8vD0pMZpbltbHW2TjWHC/X1T6g5t4qf2vyn6m/fFqQe8IKx9b2trkAwH6jemodD1hBhRRa8KRPAQWmELg3qNifIe0COwg4w/8Upn+15mZPZyRLcNTXVkK+5fEZVAwqSZ96xzkJf5D8XfjVB4P/bwVUUzSJ7Wu2fAlXbozgBz1B+/RoJCd254ewBETHiD8UBdM9Iazf0beE+x/mrJwtm4+RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b215qCVn8hRuvfP2vtMGROGT+pxgylLl6oiOh2pB/EQ=;
 b=icK0Jlq3NpEcMKOlx5w2uWEmHS/PIVVmh1/eSVkhInKKpjObhgYMewD2e/Jn0XoD4B0/f4B/JHgfBFpccmd6fKxQfnODJIooWt5gytv/B92Uga2PZoGAn1X9+pzF0vrwoBNINqfFH5F1YRslSFwbbd7Cb1z1eSqDBnQn1opBAIGWVn72uAmjeSbUrXWKlUzuGumJ1VYL9Yt9eDif69eqj2HozZh32zxSTNCAE/8Z5HZLUptn2Eso7n7CGYRjkYkb367Id0t2FXKZ6JgqvMGWhhqgnfM9dMjm4X4pypK0ASLXaK8J7zv6mI1kNM4xwjBt0GPxPY0S1vjxiqwVg6C+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b215qCVn8hRuvfP2vtMGROGT+pxgylLl6oiOh2pB/EQ=;
 b=GNjVLFeblHtEWLyIobNhuzPZM+8kAfTxMzwtZ2Ileom+TXydvWRO/GXPcbG3mATEtTEKjs0mYZyF8mkoM7aQQFi1f53pZ3Yw+9UGokm9GhUKa/CYFN9MEXh4HOOh+KtjdMfzRw0cRS2VLUsiHglwVOB5xHcSJDDrTbVTET2nvjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 08/13] net/sched: taprio: allow per-TC user input of FP adminStatus
Date:   Mon, 20 Feb 2023 14:23:38 +0200
Message-Id: <20230220122343.1156614-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f15fd6b-5930-47ef-2ba1-08db133d614b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3U9G/aSg2yGje+llwfpNyl2kuc/tDy+IwsLQTDOxfuRZQn1C7iSBVHaZdCJWxktCYpta4Pgu8bZs6kLZKLqpyhWPMfiXM1PJDIZsVh/iwItjdhhAdia2CeLrU+IlbvPKw6TSExQPdR7J9Jpm5J7K910Rrd7U+Y5c01OyVzBcOOdSTeIdAHRiK6PlNsDzk/QDCrU3wdSH9OQsh3GxBpAWnhoNLXpfBFLkTLguasDPQ3E9Rnbynk0rACcasta2b/pPynCEH16+VmsjgtArzInk0cpksmz8Kj6BinlyBQdl01An+LIVQfXsD5EuEVWecx621//9CHtK2Hvtvd+qLVA9gVyQBHfNMnrtJh1AcCRT2Q/w+lZyO+bSIsvPnFiIlfWKG/O8U2I9qdeoKo4pbT4y1lVJXDiri9tnWTysiPzQjVuh3smIps3p4jbnx3npA36V2G8lKgUaajs7sJVRLw8hBKKH1pCeB7JxmTpLzKRQ/dgjs5EIL1w7spFlpUq7YsadzWhZ+E16l9k/JQpgwUEt1S6OaAwMNRbQKfm9K5n13TydII3+UzNgaDvpuGLbjMds0XL6uf1jmXhpHkRscYc5iOXo8RPC4vO1YC8sYkW+IbYcIh/Xc5I/CEiJbnB+FIYH5wI5BRRJMe+ZPL/eu6hbgrwvAvLKY8JK+GGu/CP+xwac1zLU0rWrb6klaYvfXxGCRuSC0DJWquc9NnpQgF3/+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QrirDxdwd3Hjxx4ZXwjyKQYAH72hNwKg6dLeqTGeugzySZDS/qiqgxwSPaw/?=
 =?us-ascii?Q?9bDhl4xOlSmCYtXgEVHYkksBI/J+WtqxV+PmJSmBLO3Q+Did0dU5OxtNtiOi?=
 =?us-ascii?Q?qMhGo/CA30lcrzIK+dIOuaepKUe+oPjY+7xMTvlliU/HXUcM0Itez7N9QCFq?=
 =?us-ascii?Q?ANCcxnu6yNiNbF+T5ZriE6SRsTr+NfhfcjTSsnuqo3fGyPdBT3XcfAc9V3F2?=
 =?us-ascii?Q?yFMUyj/X3jVtZm55J6W3BKB4DhpftKCzFKXX/1h5tnx4nRVZ5o7UpK1aJAA4?=
 =?us-ascii?Q?VrJPRJz892IdmEJVEnW2OEXdzUZFw2qU+IQ42Y3lV5KUyQwlqJXNqtIeANfL?=
 =?us-ascii?Q?5A3tatAhlYD/2gWeueeUf8VE1jBlPE1rETnPhAh2OLBgj4LyrhcHn2VMD3wV?=
 =?us-ascii?Q?uMJWyafRiysPE/d6YH0zQAUxkhe9Rj529J73SQPhBtvX4YOpD7GDntax/8TI?=
 =?us-ascii?Q?0CPaIbG6Nuf16kyzTcpWKEgQxtMHWodaKfS3okM08chpw9UWGp0iurBxvXUH?=
 =?us-ascii?Q?3hiq9NL0R3DCITHdD2bXDpzUt5YY/i09KawSBj0RQYLMWmlgR6Dw9ax4/pZv?=
 =?us-ascii?Q?Ricqhbbf7wMeo9NISeiedJb8UNGJaOUNEPdsOFKj0uHtmVV5iyY98UwG+LaD?=
 =?us-ascii?Q?fOJHUb5UPvIXm/d7pJwMn/C3BaV4BM+t9KctNkEe/ESgcxGcB6FmJl2fw38Q?=
 =?us-ascii?Q?bdUyixLm9Tw62smsIZ3YirisqqmZSEDoOWWkFXqJqyIlW4sQetrrwBXy+72s?=
 =?us-ascii?Q?U3LmbTFJYI2GqaoNb8BLWv+uzYav9uqfSCmq8uU8CnWuilLf8+8qGscn83uc?=
 =?us-ascii?Q?u+H1P4zxcwwMow4d7jrMc2oS9ujZNvpPm7xjWwPpdi022msgHd2mH+F0BZnV?=
 =?us-ascii?Q?l9H460YRgLIz/ZNzZN1u35IMV6itz0ffSTAXIwNeD9aN/mVTzo+SSJviEb8e?=
 =?us-ascii?Q?MitzMuB+GdosR7YCCCaGkmDJjub25FcOq8l1PGwJPagHiVXEm44GaMUQjAzK?=
 =?us-ascii?Q?B/d2M7jl8Z6z+bzCqfDqeOwIwN66nzbbUFGdoAn6coNfhJKy40/VZIcFkqJ1?=
 =?us-ascii?Q?O7lXTuLpkKwGaDmcIa1LQWw6kP1nx/CmVcq2vlD0WxpL0g93qwvtJHWqxs1P?=
 =?us-ascii?Q?21ULqfH6/Yzf3srqP+f1eArxjLF/wOvB1lYXLetSu5G7tlkyuD9vHwCtCoMS?=
 =?us-ascii?Q?rQs9vqCvAiEQkoCAaLSZKOFaHimpDG9ZbRv1B+Vh1IorZh1tDMXG77xMI8jh?=
 =?us-ascii?Q?MQ9WN721iPkpgB+z59XXzh9aGtTwNnnQOYTP8xpnkiPJVgVf3IRa+iFWhTOf?=
 =?us-ascii?Q?hWDUdXDRKesbLZ458MOXGxi3EdfZtLVzic7BXlSl6ZMU3Oy3TQcFdHdok6co?=
 =?us-ascii?Q?U7+ngFS2mcSQowytEiqTTzTxWMRItJauGUf3/vQa4GkgkcOxIId4R3lrZUx2?=
 =?us-ascii?Q?426cLs/ls6vvryFUIfs0cRrUzqyT8MeGCdHha6m9QYgnmk9wacMu+uCI8dIx?=
 =?us-ascii?Q?TU+nchHY6v9M3c3uhIkT158eAkfm9O1fVggFRasNW03egLLE40rirh7sMldU?=
 =?us-ascii?Q?4rMBeSImDyimFoLDgGINMRsl8s3//xVDOIGhaCtbhCNOvIyVzDjV9fPUNtOc?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f15fd6b-5930-47ef-2ba1-08db133d614b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:15.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9iYcvTk4pv3Q58lIvD+NdE6dWM4cToTxYHqDR3g9ripHC+O2ba9ZGrmgdFc/1Ace00/qJK3U8x2rVs7xC6waQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a duplication of the FP adminStatus logic introduced for
tc-mqprio. Offloading is done through the tc_mqprio_qopt_offload
structure embedded within tc_taprio_qopt_offload. So practically, if a
device driver is written to treat the mqprio portion of taprio just like
standalone mqprio, it gets unified handling of frame preemption.

I would have reused more code with taprio, but this is mostly netlink
attribute parsing, which is hard to transform into generic code without
having something that stinks as a result. We have the same variables
with the same semantics, just different nlattr type values
(TCA_MQPRIO_TC_ENTRY=5 vs TCA_TAPRIO_ATTR_TC_ENTRY=12;
TCA_MQPRIO_TC_ENTRY_FP=2 vs TCA_TAPRIO_TC_ENTRY_FP=3, etc) and
consequently, different policies for the nest.

Every time nla_parse_nested() is called, an on-stack table "tb" of
nlattr pointers is allocated statically, up to the maximum understood
nlattr type. That array size is hardcoded as a constant, but when
transforming this into a common parsing function, it would become either
a VLA (which the Linux kernel rightfully doesn't like) or a call to the
allocator.

Having FP adminStatus in tc-taprio can be seen as addressing the 802.1Q
Annex S.3 "Scheduling and preemption used in combination, no HOLD/RELEASE"
and S.4 "Scheduling and preemption used in combination with HOLD/RELEASE"
use cases. HOLD and RELEASE events are emitted towards the underlying
MAC Merge layer when the schedule hits a Set-And-Hold-MAC or a
Set-And-Release-MAC gate operation. So within the tc-taprio UAPI space,
one can distinguish between the 2 use cases by choosing whether to use
the TC_TAPRIO_CMD_SET_AND_HOLD and TC_TAPRIO_CMD_SET_AND_RELEASE gate
operations within the schedule, or just TC_TAPRIO_CMD_SET_GATES.

A small part of the change is dedicated to refactoring the max_sdu
nlattr parsing to put all logic under the "if" that tests for presence
of that nlattr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v2->v3: none
v1->v2: slightly reword commit message

 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_taprio.c         | 65 +++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index b8d29be91b62..51a7addc56c6 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1252,6 +1252,7 @@ enum {
 	TCA_TAPRIO_TC_ENTRY_UNSPEC,
 	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
 	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_FP,			/* u32 */
 
 	/* add new constants above here */
 	__TCA_TAPRIO_TC_ENTRY_CNT,
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index cbad43019172..76db9a10ef50 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -96,6 +97,7 @@ struct taprio_sched {
 	struct list_head taprio_list;
 	int cur_txq[TC_MAX_QUEUE];
 	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
+	u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
 	u32 txtime_delay;
 };
 
@@ -1002,6 +1004,9 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
 	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_FP]	   = NLA_POLICY_RANGE(NLA_U32,
+							      TC_FP_EXPRESS,
+							      TC_FP_PREEMPTIBLE),
 };
 
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
@@ -1524,6 +1529,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	offload->mqprio.extack = extack;
 	taprio_sched_to_offload(dev, sched, offload, &caps);
+	mqprio_fp_to_offload(q->fp, &offload->mqprio);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
@@ -1671,13 +1677,14 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 static int taprio_parse_tc_entry(struct Qdisc *sch,
 				 struct nlattr *opt,
 				 u32 max_sdu[TC_QOPT_MAX_QUEUE],
+				 u32 fp[TC_QOPT_MAX_QUEUE],
 				 unsigned long *seen_tcs,
 				 struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
 	struct net_device *dev = qdisc_dev(sch);
-	u32 val = 0;
 	int err, tc;
+	u32 val;
 
 	err = nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
 			       taprio_tc_policy, extack);
@@ -1702,15 +1709,18 @@ static int taprio_parse_tc_entry(struct Qdisc *sch,
 
 	*seen_tcs |= BIT(tc);
 
-	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]) {
 		val = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+		if (val > dev->max_mtu) {
+			NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
+			return -ERANGE;
+		}
 
-	if (val > dev->max_mtu) {
-		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
-		return -ERANGE;
+		max_sdu[tc] = val;
 	}
 
-	max_sdu[tc] = val;
+	if (tb[TCA_TAPRIO_TC_ENTRY_FP])
+		fp[tc] = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_FP]);
 
 	return 0;
 }
@@ -1720,29 +1730,51 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 				   struct netlink_ext_ack *extack)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
 	u32 max_sdu[TC_QOPT_MAX_QUEUE];
+	bool have_preemption = false;
 	unsigned long seen_tcs = 0;
+	u32 fp[TC_QOPT_MAX_QUEUE];
 	struct nlattr *n;
 	int tc, rem;
 	int err = 0;
 
-	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
 		max_sdu[tc] = q->max_sdu[tc];
+		fp[tc] = q->fp[tc];
+	}
 
 	nla_for_each_nested(n, opt, rem) {
 		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
 			continue;
 
-		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs,
+		err = taprio_parse_tc_entry(sch, n, max_sdu, fp, &seen_tcs,
 					    extack);
 		if (err)
-			goto out;
+			return err;
 	}
 
-	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
 		q->max_sdu[tc] = max_sdu[tc];
+		q->fp[tc] = fp[tc];
+		if (fp[tc] != TC_FP_EXPRESS)
+			have_preemption = true;
+	}
+
+	if (have_preemption) {
+		if (!FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+			NL_SET_ERR_MSG(extack,
+				       "Preemption only supported with full offload");
+			return -EOPNOTSUPP;
+		}
+
+		if (!ethtool_dev_mm_supported(dev)) {
+			NL_SET_ERR_MSG(extack,
+				       "Device does not support preemption");
+			return -EOPNOTSUPP;
+		}
+	}
 
-out:
 	return err;
 }
 
@@ -2023,7 +2055,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	int i;
+	int i, tc;
 
 	spin_lock_init(&q->current_entry_lock);
 
@@ -2080,6 +2112,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		q->qdiscs[i] = qdisc;
 	}
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		q->fp[tc] = TC_FP_EXPRESS;
+
 	taprio_detect_broken_mqprio(q);
 
 	return taprio_change(sch, opt, extack);
@@ -2223,6 +2258,7 @@ static int dump_schedule(struct sk_buff *msg,
 }
 
 static int taprio_dump_tc_entries(struct sk_buff *skb,
+				  struct taprio_sched *q,
 				  struct sched_gate_list *sched)
 {
 	struct nlattr *n;
@@ -2240,6 +2276,9 @@ static int taprio_dump_tc_entries(struct sk_buff *skb,
 				sched->max_sdu[tc]))
 			goto nla_put_failure;
 
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_FP, q->fp[tc]))
+			goto nla_put_failure;
+
 		nla_nest_end(skb, n);
 	}
 
@@ -2281,7 +2320,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
-	if (oper && taprio_dump_tc_entries(skb, oper))
+	if (oper && taprio_dump_tc_entries(skb, q, oper))
 		goto options_error;
 
 	if (oper && dump_schedule(skb, oper))
-- 
2.34.1

