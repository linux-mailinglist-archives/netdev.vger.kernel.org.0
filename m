Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE2E6DE361
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjDKSDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjDKSDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:03:01 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCAC659B;
        Tue, 11 Apr 2023 11:02:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jizysYVs99OjiwKWW5bhugdBT5bgeuFB+Pvaun6eHfCttcizmgS8uCn1IHfZGKPBtfbkN9wFisTlICFgsKYPFzvRfb+5V9jP2Bwd+oW+Zp/FBFutsKkTJp4trL25NpoYGN8PIYuL6vj6k+FSajTWU7ZwAZizFhVpsAu0aQa4Oib696GWJozjSxpBY6lqu5B/203O+f5FO6bNJiKWa6yYX0WF19VLKEglYMgPvUHLtY5xOBSX0B/fprO0/bUXjSch6ftnuUN2Dmg9GyMYG1ZZZhfG15Zz+BcFBRvJyBVOEJrG+PuorOOe16kmLMwADfxfp+syVDtsqyDMaFvpPqoWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWBEKXk3cVTgf+JhaSef1csrtsJlV25cbTm4fpz0yHs=;
 b=OMflONDBz2LUFlmyyxqieNuEyVyvEQYrsLoK9GV3rDx2NyryVlpj4PsD4sDtUNDTJf3p+62RZqWKAEig8L+kAUNOj1sJSg54d80nl9edEysSpn6m50CTSyWQmQsS9aK3mdFFVCu7gMP5qf0uCLGMxl8XIAA8tb0tp8Vgfs+HDnoOwfO7m3RJTNOs3M/M37RKpp2wFSbab5hwFVZ07vTYOBHqpQlF8MiolRNG5Gr4F4hnyVLYXnIADb/MMxFc3m43TmL6CH9qCUh4A62r31LLiJclslLLAVbT6OoGTQAYO8IZ2FLjetErog6ecqVVioFsPsuEmB0PpKoKxkpkCO8bXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWBEKXk3cVTgf+JhaSef1csrtsJlV25cbTm4fpz0yHs=;
 b=QWvwcxRbJjKi6QI2EM1MvwNqmZRRbNyafa5nq+RL7NzFKkse0VBQslzBmwilBne34CKk0mWpvmUS623ukmT2COR9CAinPyQ7sIbq60pazPlKMsijOLSuiZwWyLqf/sEIFnpcMLSXeB7Hx2lnGn3zHLtXcF5kezzRgtqm0CTulFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:32 +0000
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 7/9] net/sched: taprio: allow per-TC user input of FP adminStatus
Date:   Tue, 11 Apr 2023 21:01:55 +0300
Message-Id: <20230411180157.1850527-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: b96645c9-cd24-49ba-8e86-08db3ab6ebd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dodq3kWRHtKBHxjqrY1zstXP+tCqeip6wR0cYYVTuMh7mYfIxnCqkT6iXO1n4DGt4TPrwbGokkp7Ono5QZEHYxEqDkyWcpv3fdPPkN+lNUOeK+t4oNH1FSRLTQ0gktfia9Gg9uf2Cd5A6p7meTRxnMAk43HTvs2jNsF+yqsRFPswADq6zeAbGtr6siPvNZNowbNk3ks8gpFg0pKDu78cMRnu9EQxxcWWl4Hh8yi+lpg+Z8PFjicBbEgIMNdv6rbWBUaTImSxQ+r13Issqv/BPbIerGH66vbwOPgiOhOVQEWmVBlO7iU9TdJy5HTWxks9PwN7oufL7r4uCaZO9WaqLDDD8vzM1s3ruj8g4HD+LKda6uYVCgkiMP3ZYuvDXd8MIk1qJtdwiRPRnf1TwMjmL/m7YkA8jmvVByKEJ7X2vUwMUOMff35LrlVzxk6UAVqI1JotaRe2EUA/G90qgvBEid5iTsRkoFm6NFpxM71B4oz5aRxRo34k58rCnFbl/5z6GR0dWN5fGLq31nXmU/WOvwebwKDK9oImbjKBIAemd5BA3t5eNDyH/Z65c2xuusy3QjJT8xmqxXJ8cBZe87Zx6/dP9i5QKiZVNJSSuk59ZcmF0x1LwnE99kBh6b8kB1um
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M4FVfLgTbR+o/ZnV85nhMAf+oFtrXqVTQ2YgpsV9bWJNctoH7Ny+QbAu6qR/?=
 =?us-ascii?Q?QckOc+W01pEU1EhXHa9Y5W05m/FhzYty28LeLm/jJ5uJC1m3OAAg1APlr9MR?=
 =?us-ascii?Q?YacD3qxHQdTZBWXCybkagvVQAUXDIMdMZlkEehWnSuMEIi+rmLv5kZGn1iGN?=
 =?us-ascii?Q?7Sj73YSNz/O5G47dN/nhDns+LJWKw+rc1CbCkVtv7fHnt5jMYnhwttS3NxO2?=
 =?us-ascii?Q?sXISYtmC/0Li2wxo+iwk36eoJa9FNcOf2SyhMXJEJjY8byvL55Ds9l0YO4Ee?=
 =?us-ascii?Q?pcw7bTEEfpBEG+Jfrh+SglxUUiKWNW3sbYQbDohm32C8+OZjio7IHhX/Xs8z?=
 =?us-ascii?Q?xzDYpBOS2ARaSeDPmdyaEOTU9puoTrGH+kG8Hv+Sr2m9TmsP/fijKQJDWwX5?=
 =?us-ascii?Q?9OMbnq6hVvedhtQp71sDZypocXtDv1YKNVlebrlfUxMLdqGjNx0sZeJyR6LE?=
 =?us-ascii?Q?YW2yAnoTaF2OifkFVjGYPkE8Xr/A+K8XHx0Ir7mwsrBBSRN8vF+gixdeEXmQ?=
 =?us-ascii?Q?iZEA8wAHBuZHZgKWzJ/eoiAKljIWFcDWVhC/Jlai4/fwsQDwkmyHzS9Ulf1z?=
 =?us-ascii?Q?/3V2izXE+em42Baky/OxwEcThPqwKj9Nr08kCCw5oT6dIWrBbHAkXaoRJ0dk?=
 =?us-ascii?Q?8hgDk7JAZPkrRvz+EpzKUTJi585GEENtPQRR+apvuCMZkcWkYjg5DtsrWYTZ?=
 =?us-ascii?Q?GeO+xweaUsVOquwHo6M0oIlKmh4rDwKag9/z6BSFH8bAu8kjm+hjoezI+rih?=
 =?us-ascii?Q?b5DMMGm2bf9CKKF5+RU3+vQ0scCOMRTpnNzxOzbTLlHYrhlqlD6lu0wxb/Gi?=
 =?us-ascii?Q?T3olz0cJUdp05rL9cK3WFkbY2/wiVTpjfjGp3TDRSSvfB0AQZs4T3DJenu2L?=
 =?us-ascii?Q?2XXQvEioQPC3fMxIn2ILeuLAeOLYl0dm8onyziEvPGozfdcSdUmlR9UWvoK+?=
 =?us-ascii?Q?4GQJ2Obs8adQ3vPAJhg6pmYluJLfzZi1/oUJx2UGtjU4UWQa3VvMxQ4JNdKd?=
 =?us-ascii?Q?q4b40HgT0Z9X1C+jC9DpNabKc5PLGhezjBYZwjs2q3sRzEfQBOgJij5PYYdt?=
 =?us-ascii?Q?Do3VAy+sy1MrsG4BqsHRv2KfmRew9nhioQq/x2fx5N5K038hm9zxioDHWTZS?=
 =?us-ascii?Q?fRdRu7EU3bUsptrzZ6SMj36iUAj/7RrGFvT04afl+PPrFMzASiS1IXnOkK2C?=
 =?us-ascii?Q?ZXD7asneRTChuBoOIjCie2RWJthyL9puOXgjHHSXQ9Z1Ah5oQOEuIPyZAqO7?=
 =?us-ascii?Q?EaZv6rX9k76ZrnmQTWmHBNVArBnJlzyafYkEJ41oX0TfpyJTsMDeDuHNHYI3?=
 =?us-ascii?Q?Y5YtAQKIfqsdSFllkIR5Wu5B0m53az15TPA6aIlxCrBPrzSd56USOtQMz6BV?=
 =?us-ascii?Q?XkgyAVHrityXzMuwiy036Gt10iNuAYxYq2Is2SHD4iJ2IGbH+gOt6e3jznN1?=
 =?us-ascii?Q?XVRVSFChsmLIzHxqKNBpCSBwobvL4QpCtYDaLHETQcEIbUsXuxnpfoJh1dvA?=
 =?us-ascii?Q?ar58DZlX6jDl2k79MJ5d69cqmYmRkmXEvqHOF6g2CaO36oihqEeZeXFhMs/z?=
 =?us-ascii?Q?qTZWokuCvCASdhvhqjrNYv+a1RhLIyjYLErfga8vCn9Mc1TCcCHCSWlzAyeM?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b96645c9-cd24-49ba-8e86-08db3ab6ebd3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:31.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/uSxGFYz1NXg5O3YN0Su46RSL0PAIvMv8clSrKn3Ce0XxICaUkLchG35Cn59zVTs5o8C6bbE4kc6UmYZEjmmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2->v5: none
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

