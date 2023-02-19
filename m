Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A4469C081
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjBSNzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjBSNzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:55:09 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A7125B8;
        Sun, 19 Feb 2023 05:54:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBLFXZJ4WGqMVH9/a5GGZezBr8aAh6zhjL+p+MndXQH6PQtalx3+qnGG68uF9xUJhzTbzgwgCGhmOgNQwctfFEpDE0TqzTREmRX5qzGybQKqTa7HtFXtP/yzVPvU+OgjLoZSLgSn0H2xlYOlHE4Md+n4K+8oXwNX2NANk/oT0msrGvuAbrlur1qpRUyiLtGHcVQuJieNsqgo7JG69BvHoUv1ZWJievo27wfoMBpO0b1MPXtPeQm7170bapNpA0kbxXyxD1Zp21tAGMca5S4ikez1TzLLA5P0NVK5z4CK5WLHMiyPTc0xkW5OCeOVpDWl4KR4Fx/oVqQjDtO20ylOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ifzCyDc/Iq2TIwUwjzFqoMcukuy6moC10jjJvogVZU=;
 b=W8z8E2mHT6v6gxw9PsSBfzBvOgG96LwIvJaXzz+3sbmQirGGiE8O5HzpzzqInsyr5OXy/7zqy4ayK5wLF7Q1jSaI3+lzz7ICJeE4zdn8S2xGRt37O7+QY6H5+Ucq3WRypy0Ei34fSVZAcFG2ZevjyziRDMtyCl+QbTAW90pgouiApx0mr2WrkSU4yqCkARqyxzAl0NnObIgZlQ//JsdhcxFVC8FPVYKd8PQXOfRG+t3RfxTYCZCqNylObelwomj+HqnUW6r6DOVXv1bIHczIknnYJKksi1vqiC2W09jgM6ash+0+iMm9L5ImUUxXJdUhckozsqLSPOO87EBS2TGVCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ifzCyDc/Iq2TIwUwjzFqoMcukuy6moC10jjJvogVZU=;
 b=AY+vtnOKDBaQ9DbSE+8ZivjuMrMU8d1SKb7x9dtSZRrUp7tBFzEV0EmnOxaTywtRXsWtpChgbikQkGj3qP/lwB+WZXguvJ6ZUsVkUptv2x7qBsaRiVj3g+qDJrmTIW2Lq64yMv3ZXlIpwalAYL0vPwogBOYw9TJC9xiIarQ4kZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:57 +0000
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
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 10/12] net/sched: taprio: allow per-TC user input of FP adminStatus
Date:   Sun, 19 Feb 2023 15:53:06 +0200
Message-Id: <20230219135309.594188-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 85f28dd7-f70a-45f8-1d5c-08db1280bec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zYK9zyswMiHJSSCOyBFxr5tILiEVnHLw7Jtl7IaxoRw+rwOWH/VJ1LCAOp1K7Ic2GKIz1dwg0L1YXRD2BnO6/To8uiqiIEKp6lP34yuRx0bIJhrYca3C65hux/1PnZJExUv5Pj+q1wPSiqlCUEp9F65Hp+5SZtwoIrkVvQBfuX/4zQNpMvqGGkSP4IkUd1VknnoShNvdwpavno7b1OlzBOf00/oTho/AUjAg0mJJlf7TIbDa/9XUETw298CNxix1YFxvHDUg4cOavT9T5NRPWZPJg7jugLF3fhep6NpwigaqR0EX2O6yon2A8p2uzPSA48CPl0L5Cde5jy6ym7e+Vh99Oor5TLcV2iI24VMtSpDDYSa7/sdCNss5TMqnUtjJ8/KFBqzg/DP6Xl23DXUH4/RUtU77A2ndpg4cV+hFXbW1PtLeqU/SapiZ+405X2J+1aaH+2uQoOz/TfzbVA5yg2NwSTXUcco3ewZUFYR5SJbNbt0Rjiz8DtBYNPEG/6Dw7WrYF3aDwqnmVkJxGAhPgGyTJAsgsGI6oAhr8cAToHf5FkM0A+cax5vM+UvTCucTjKOH4cHvPWE4eOMV0Xcu9sbk2TaC8d6MNBUFlEmZxjepG0uTbArLAERqiEHxrIvuOYVUMTWbpNecNijXVmVQtf7GjOAz36/DhvhLLjL1M0KNZmiki2WvsjGsRbHIUMJwQM5pHTPho9OoGxY3yuxisQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G+Qt9Z2rSOouPVgoINs7pIrPvKMn4Ttcf/48lzKEZOg1UUeP9RYKDNrVJi/K?=
 =?us-ascii?Q?aOaApzaBVKbxkUpGkh8qqMHiokYn/5n++8BuEIqh2w1kOwWAEpsmq+IYtN9Y?=
 =?us-ascii?Q?/dyPDN61guXgqjuDJLlmA3rwlq3OSjUPiTsvbPwsmG5RdobRmgbKxMenm7Xc?=
 =?us-ascii?Q?9dujhnzcLQu4Focf8sbsPTO7SCwsAgsw0KMq6d5oP+yNhwNgdbd3QHxxEHWU?=
 =?us-ascii?Q?ZQ5FE9LGqpwKoPeWnnXMwtv/lV9BkzqF4UDBxsg79N3+FDTZ6YT2LoR5T+07?=
 =?us-ascii?Q?CUorjywEnRwnzYg0OKPLh8dfmGegWLuR3fgCJZ/ZDbD5zV+Jcd/tqSKrKFXu?=
 =?us-ascii?Q?emuAtmALaMjKFIpyAFKtBTA1JeXAMfqje6mYk2AkwdqdHtr30S2qoaAXuw0j?=
 =?us-ascii?Q?FZ0qkai4o4l0DuocFKcaeJvM4UPOcuDcHqc7tOTabIXvQ6Sfm9OQjzGJf2Q+?=
 =?us-ascii?Q?oQMXGh9Bt9v+Y0jrfmVkBFV2kHxFHClFnPWrDf6C3XqNcM7w3F7jiZiwXtQ9?=
 =?us-ascii?Q?CPHBQHwkoJcRfIhLcs/KNEDQrCt9u7Fa6qfG/o8oO2AoWtW3fLBzY3ATOEqP?=
 =?us-ascii?Q?CsTQjBThBqhDzZ2PFyE1zkvWbMUl4I8/z2FPSKUsTU8PmpetGFUTyfo45RCw?=
 =?us-ascii?Q?r07veaUdtx75aD+OEcMdWbbSRI0gTInhdkP1R8QOsO+8PGSBHJ0LACOnazQg?=
 =?us-ascii?Q?paGw6cvVJnsBUSeUjX0+Hhea1kR1B/4LM48zAU2pQ9XO2KbY8/LsYEK9SbL4?=
 =?us-ascii?Q?liy156uBtpkjYODdTfHdbXOk0CTkbelVhy9eBm18F9XLlB30e7eTa+limxtX?=
 =?us-ascii?Q?L+eEaVBXZue55R+vqjfyi5QLEw4ysqQViypt3lMnFq+8hVy6NruEogb7M6MU?=
 =?us-ascii?Q?zOmZc2o3QYHwUFTKmLPur3Lil0XNVrVlzq1OIRyN0A8hkWE9r2DLDe8ibvey?=
 =?us-ascii?Q?obfxYeVYgjkj22kdEfne45By724B5FCPHmE0MRz0V6GRX69iWSfqEVk7Qnwg?=
 =?us-ascii?Q?fvQAz3uMPy2Sq0O9Y6vZldsXHF1V2MBJbYzyMWyLEohJnGlZ0TcMFGLJ2yWS?=
 =?us-ascii?Q?mSSd4Ye2cjxlb7P3ZAfti+DSx7gfYprZ0ea+IVbsT8C5gSK/iq+EsuQ3FTdA?=
 =?us-ascii?Q?h+8oONaH7umuh1aeUPk5KkkV+qmPfknNJKZ8DwvIsNazUBAg+HC/uPlNvr06?=
 =?us-ascii?Q?64z66bhxup7mZhRdqtZbCDCUk5UDE1lPqHm3dY9D7ZRjI8tTJlYqlVLiZWqg?=
 =?us-ascii?Q?hlB18sRT+9i78wsrJWRSieWCRrr20IE0IC60PbgM7wvyuMfHG+GPKk9+VZ41?=
 =?us-ascii?Q?PABr3gYQtKaz0nYfjD7NUCGNegG5Cy/fS+TNml35/JWatGP7w56fy3mykFJa?=
 =?us-ascii?Q?pI/5SKI2Q8vdVQmfqnBTQ6FT+9s7MXHBZdM6bXofmkCiOSiK8BYEmH8ZspAa?=
 =?us-ascii?Q?CQflKRp7KMaHl1SJOuu5rUFhnngNfUofe1LzUgO5xSPoTBmb0Q/G1IqgyiIR?=
 =?us-ascii?Q?qMPwuDnNoAabsw0saSSbe57uHqMtumtLBss/aUhJJTy5cyUXJCQ+U7WZjWuv?=
 =?us-ascii?Q?QV4h8Uk2cJRh5FC08RhByjTiE4pg7v/Iy3APG6Wz2cKDlGnXmFseRjnIsq/K?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f28dd7-f70a-45f8-1d5c-08db1280bec8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:57.1612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3sjTRgJx8ooHCpwNvhz0UOzyw6KfoyD6HhNnDvAFDYrUGRNfdPFGUQtg5fZwrpezzsytWGAuPWSVfIu3zV2J5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
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
---
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
index 9781b47962bb..c799361adea4 100644
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
 
@@ -994,6 +996,9 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
 	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_FP]	   = NLA_POLICY_RANGE(NLA_U32,
+							      TC_FP_EXPRESS,
+							      TC_FP_PREEMPTIBLE),
 };
 
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
@@ -1514,6 +1519,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	taprio_sched_to_offload(dev, sched, offload, &caps);
+	mqprio_fp_to_offload(q->fp, &offload->mqprio);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
@@ -1655,13 +1661,14 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
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
@@ -1686,15 +1693,18 @@ static int taprio_parse_tc_entry(struct Qdisc *sch,
 
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
@@ -1704,29 +1714,51 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
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
 
@@ -2007,7 +2039,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
-	int i;
+	int i, tc;
 
 	spin_lock_init(&q->current_entry_lock);
 
@@ -2064,6 +2096,9 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		q->qdiscs[i] = qdisc;
 	}
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		q->fp[tc] = TC_FP_EXPRESS;
+
 	taprio_detect_broken_mqprio(q);
 
 	return taprio_change(sch, opt, extack);
@@ -2207,6 +2242,7 @@ static int dump_schedule(struct sk_buff *msg,
 }
 
 static int taprio_dump_tc_entries(struct sk_buff *skb,
+				  struct taprio_sched *q,
 				  struct sched_gate_list *sched)
 {
 	struct nlattr *n;
@@ -2224,6 +2260,9 @@ static int taprio_dump_tc_entries(struct sk_buff *skb,
 				sched->max_sdu[tc]))
 			goto nla_put_failure;
 
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_FP, q->fp[tc]))
+			goto nla_put_failure;
+
 		nla_nest_end(skb, n);
 	}
 
@@ -2265,7 +2304,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
-	if (oper && taprio_dump_tc_entries(skb, oper))
+	if (oper && taprio_dump_tc_entries(skb, q, oper))
 		goto options_error;
 
 	if (oper && dump_schedule(skb, oper))
-- 
2.34.1

