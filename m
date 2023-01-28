Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC9767F382
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjA1BIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbjA1BIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:07 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26935A830
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIiJXLZpzw8k4OZ4lzG37e/1cZlgSp/YceVAXTbtcsw3R/DMzrz8UUVjvTaP/d+1EtVN7n68Lf7q0OIRLs8g4ETDRUC2ifOqLtiWdLMVPxXoaHRyq6sOAWbLPXrPPFumHcE6YUobI/imPv6DxJEkcWgm9ka6JtV3tiUQ2srtJgrOe3b7DLPCFfR3rwhVYAiP7Yqu1g1KnEeCGr/ePhGEEhlXpDGXLrjjI9CqTC9cBohktkAJStX5DJHxv8xI5g6Rk9zJZn4LBEkAfKOIwJrakOSV3AKQ8GAp1LkHYJIBd5IhMIrqcIZP2srk8Gv41DaMu8xQiWmoN3mAWJk0ZwPuDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wA16AQlQ/8aeVoaTgy0R1oXM2n137XIHlyGL1gOI0Nk=;
 b=dyIXlXe1EuhrnjuJVwlfAoOrHLO7Um4TeoMyHlcx2I5drJ1Tz58Vh8j60JCBTkOCaLBZStuBkdZveVgplsA4PQOlSNepzOmJrFGg2XMPofx0nTQha3KFOFWHT57n7h+davTmSYdn08b3F/n0glOHQJcn2zN8yCyNYHqyy7XogVDv3ORaQ0uJciu0aOLBw8zPqSSwgrsPbEuixEA5TqLtQA9pkVt5XytRO4TMCkFyvZR1O4bvHXI5FtmIQUQ0tlcjYC5jKQ0aGg/LIDCi88p3DIkBUwcGkDumhNPyGM+JWUP/4DTV6HQ5fmUHYOwouz2inkxx2HShMWAyfe27LCDRmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wA16AQlQ/8aeVoaTgy0R1oXM2n137XIHlyGL1gOI0Nk=;
 b=AX4F/Dhj969Z9z1BQJ786v3vzRvsEEc9d8RHw9ti1mZ44H774Yvv6YIQEvbTnfY7GijoxRMEQnOJouG/UkIgmI1n4BETpIEKp68N3rnuInjHSStjMs7tbd7O2YMRsYd44+7sAxPcq2O6V+Y7Rsf9UnZ8bAP6Df8QNbQazA0a/Rc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 13/15] net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations
Date:   Sat, 28 Jan 2023 03:07:17 +0200
Message-Id: <20230128010719.2182346-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 8604f35f-dae5-43d0-99c5-08db00cc1707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sx3xf05aYKqAQQcxNGgpXuYglo9Ks/oPGHJCJdpqwIskVMYEomCyo/3fSMwD7FvNVjos7HFSL4gmui4e5UkVLX8j5C4ZNTTXETfUiNPb7LjtteCg0NAFr8j1+u7xi4YXBs+PK2Y8wk63bERaTFCsIw4I2cF8so2Y9K7iKfmMXYosrfealLwlvXRuqDPy+zynEYBjbtzDPrZsjnbGCFqvyAFL7JyLhREpgfed45B/gY3gb7+gOXl13x4aH4Ez+7iLUs1wG6i1Or/YDV3Nmhpqb3fSU3jBhptJRmA6XjF2uzDkPXg2VUbHZGYeqT1U06SvsvgYnn3VVZ2Qlx4mdW8adryeC4AHvJoxqSjOT4O0Mt58Ktv5JIT1vkZ/q50LyOkWjN9EqeMohsnIIAJzXGa9Z+Tim7UPHU7BKG/wrGxPViSHdYrEGabB4AfHHpr+Bgh4W2S4R/GOnEhdsEtv8YvIpbmUcyGSHfEcNLrS5kP0MJ7qx5jApXqB6+z8Pe+7DOQocj8EAsifpACeMeZ9X3wHKP5aovCTVqDvZOqMq3o6mEPJxtpizENqnoq+IgHeW5sS10XVszeE+nAnM7Hu9yFr9cCsQoWKFSU4i8QoYSwIYGfMbcz/M+2/1BJLmyFMLYnJYfjg1iQKh4gGeVfcg+F2/CgCXqRpfV31Zfp1sgCUED/BAwmtMxmnG7oWXlMC2a3ck4kyklQJWL+Ln9Q1Zzlcmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rl/8AqlER50UMnVY5xP4Q4hSvyRx1JHvXEEHiCzPM4LVQke2lA8R0h430C+I?=
 =?us-ascii?Q?ifWRtyQUKW3kUHp3DNf+Exl5hPsXcS754xSdYqI5WZKWNqe4G43xqTn+lJyb?=
 =?us-ascii?Q?7SQuqvxgt0fQjjbpc49EWpq2Urp5yGN3QMlSzo5oBxJQJiuK8EIqA5jCQfVr?=
 =?us-ascii?Q?XXPjDPDaaJphqmzCxh8tZpfArtNr3eoOGurBvyewrg1Pzzpec3Ro2ZJpSXxr?=
 =?us-ascii?Q?aMUraGQcZZAIZdYqAn4jSHFJdET1AcSo5AHsU8rHFquWVBCJ2B2mpQp7qm+T?=
 =?us-ascii?Q?uZ+Om3dRW901ggTomrlhdKdvoaYHv60eJLhgs2y/ivE5cnd8dYTLFedHnWwi?=
 =?us-ascii?Q?WSIxnBuPVoUHV+hoqyNk+vPrTgzWsJGwZAtiy5tsCSOb2+VTuFvLbZL2Mlqz?=
 =?us-ascii?Q?uDQUctHZhotTLyJ974o0VSQGLsKOX3wnHSxbb2XOY7PCANpfyszlFAexMR2c?=
 =?us-ascii?Q?L3dn3CMZKUIFRcKNqewQswEL/oUDnSFSvxD+kZe8BwCCPbPWnB6bAznpBG+o?=
 =?us-ascii?Q?VV0at0vHRTF35sU0NIJI0CjSaE0G5zp2Xp894u7uYGkrV2BnrYF1QPC6ZFRE?=
 =?us-ascii?Q?0YX+rwRkYTnSMLxK9I4/zJRw0cmLkbH0XPQb8bfgBGj8sFlDqcgWYAwG8wP3?=
 =?us-ascii?Q?7MydF559ixqy3gqDSPbcY79ROtqRzop5mAx0Wc++etZ+K8VIgxVuGpbZui5r?=
 =?us-ascii?Q?VVJ8knGvvDP4FcrBXKuJEs0ySSuK8Y4DvXUPMheFTAggEVW2sEKfbAqB/BHD?=
 =?us-ascii?Q?PbMqXk7dOtqlsbLDErnaUg3d8a9KuBD6d5AhuAsL38hrOjY1b2ttwcGABV8Q?=
 =?us-ascii?Q?kEAzD50XgqJrNCWBOAMbDKiNqUtFBswwmMaSVJPmxdG0P2l0i6RUSm4dVtKO?=
 =?us-ascii?Q?SeBS1X5XEWYGf1e8obwNFE5/tVeTdyoO3t0m0DByZT3QNX8UtJJY6X3Lty9j?=
 =?us-ascii?Q?bx1u57zTe36UlG8les15wt9HZ/nRErRp6H0ObkKi/rlBPbK03B0n1LYnIh8S?=
 =?us-ascii?Q?t6uqQ/9WZYIjuTv6KB4xhF7MDtg+PN3N9zcBh2JYhuQzhq1Q7647m9YlG2Rf?=
 =?us-ascii?Q?dUqFVaAlanjT1075BO9SceRpBs3x2rDz0WwRHND3tgGgIhL+8tkiMO+gtavv?=
 =?us-ascii?Q?v3wWn/rpiAcTgbdKyjJcyJQiDrTmMFOsaUG4mm073NuP12oYMHDy5Fl7BEA9?=
 =?us-ascii?Q?3N55zZPg92cCqig72S3VKwi14JxX0KyGm198+LG9hyq21k1twg0YlWQMWrQi?=
 =?us-ascii?Q?oSWHbrN/1A6BroAvRZDOr0GzM0AAAX6ZGKZLv1jLxgGDZ5e/dm6XdvmuDD5y?=
 =?us-ascii?Q?PORGBTW02n3VSBwYaX/D1K1womMppj28kvrqGKjHXzC92E1HzV+y8ey4IWwv?=
 =?us-ascii?Q?V7i1dbY5L4W7BqyARAkq79rfiP4CUOtPPfW6dsRa0Lv0PzzDy+ZQM70MJLR7?=
 =?us-ascii?Q?0Padb4rTh+7yDEkCT52HfLv3cyDeK18Pwcmo5CN/SwyvvgzZMwKz5Q1AOyba?=
 =?us-ascii?Q?ljRIrq4zf+oO1joDzyOAKbuQv9DZBVfqO2wUwkMuLwxUPwaFXeKMbHnr4bOw?=
 =?us-ascii?Q?Nnaq+3XnqNi/51Y3Ed1kPDlTOKgf7IMLNOyM/wa7LH66prFtqVPzVTM9uAUE?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8604f35f-dae5-43d0-99c5-08db00cc1707
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:56.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KdbS1XTrkARI5mO2AfV8tXjqFOKS/uX0SmWSHiCPrzzqh9dxfckSFtDUvSoCeGDUg0tgJ8MyUDeU0zWQq3PzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio today has a huge problem with small TC gate durations, because it
might accept packets in taprio_enqueue() which will never be sent by
taprio_dequeue().

Since not much infrastructure was available, a kludge was added in
commit 497cc00224cf ("taprio: Handle short intervals and large
packets"), which segmented large TCP segments, but the fact of the
matter is that the issue isn't specific to large TCP segments (and even
worse, the performance penalty in segmenting those is absolutely huge).

In commit a54fc09e4cba ("net/sched: taprio: allow user input of per-tc
max SDU"), taprio gained support for queueMaxSDU, which is precisely the
mechanism through which packets should be dropped at qdisc_enqueue() if
they cannot be sent.

After that patch, it was necessary for the user to manually limit the
maximum MTU per TC. This change adds the necessary logic for taprio to
further limit the values specified (or not specified) by the user to
some minimum values which never allow oversized packets to be sent.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 68 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 43a8fd92a5a0..7a4c0b70cdc9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -60,6 +60,7 @@ struct sched_gate_list {
 	 */
 	u64 max_open_tc_gate_duration[TC_MAX_QUEUE];
 	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
+	u32 max_sdu[TC_MAX_QUEUE]; /* for dump */
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
@@ -240,18 +241,52 @@ static int length_to_duration(struct taprio_sched *q, int len)
 	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
+static int duration_to_length(struct taprio_sched *q, u64 duration)
+{
+	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_byte));
+}
+
+/* Sets sched->max_sdu[] and sched->max_frm_len[] to the minimum between the
+ * q->max_sdu[] requested by the user and the max_sdu dynamically determined by
+ * the maximum open gate durations at the given link speed.
+ */
 static void taprio_update_queue_max_sdu(struct taprio_sched *q,
-					struct sched_gate_list *sched)
+					struct sched_gate_list *sched,
+					struct qdisc_size_table *stab)
 {
 	struct net_device *dev = qdisc_dev(q->root);
 	int num_tc = netdev_get_num_tc(dev);
+	u32 max_sdu_from_user;
+	u32 max_sdu_dynamic;
+	u32 max_sdu;
 	int tc;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		if (q->max_sdu[tc])
-			sched->max_frm_len[tc] = q->max_sdu[tc] + dev->hard_header_len;
-		else
+		max_sdu_from_user = q->max_sdu[tc] ?: U32_MAX;
+
+		/* TC gate never closes => keep the queueMaxSDU
+		 * selected by the user
+		 */
+		if (sched->max_open_tc_gate_duration[tc] == sched->cycle_time) {
+			max_sdu_dynamic = U32_MAX;
+		} else {
+			u32 max_frm_len;
+
+			max_frm_len = duration_to_length(q, sched->max_open_tc_gate_duration[tc]);
+			if (stab)
+				max_frm_len -= stab->szopts.overhead;
+			max_sdu_dynamic = max_frm_len - dev->hard_header_len;
+		}
+
+		max_sdu = min(max_sdu_dynamic, max_sdu_from_user);
+
+		if (max_sdu != U32_MAX) {
+			sched->max_frm_len[tc] = max_sdu + dev->hard_header_len;
+			sched->max_sdu[tc] = max_sdu;
+		} else {
 			sched->max_frm_len[tc] = U32_MAX; /* never oversized */
+			sched->max_sdu[tc] = 0;
+		}
 	}
 }
 
@@ -1223,6 +1258,8 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 			       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct sched_gate_list *oper, *admin;
+	struct qdisc_size_table *stab;
 	struct taprio_sched *q;
 
 	ASSERT_RTNL();
@@ -1235,6 +1272,17 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 			continue;
 
 		taprio_set_picos_per_byte(dev, q);
+
+		stab = rtnl_dereference(q->root->stab);
+
+		oper = rtnl_dereference(q->oper_sched);
+		if (oper)
+			taprio_update_queue_max_sdu(q, oper, stab);
+
+		admin = rtnl_dereference(q->admin_sched);
+		if (admin)
+			taprio_update_queue_max_sdu(q, admin, stab);
+
 		break;
 	}
 
@@ -1625,7 +1673,8 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
 			continue;
 
-		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs, extack);
+		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs,
+					    extack);
 		if (err)
 			goto out;
 	}
@@ -1772,7 +1821,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 
 	taprio_set_picos_per_byte(dev, q);
-	taprio_update_queue_max_sdu(q, new_admin);
+	taprio_update_queue_max_sdu(q, new_admin, stab);
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
@@ -2110,7 +2159,8 @@ static int dump_schedule(struct sk_buff *msg,
 	return -1;
 }
 
-static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
+static int taprio_dump_tc_entries(struct sk_buff *skb,
+				  struct sched_gate_list *sched)
 {
 	struct nlattr *n;
 	int tc;
@@ -2124,7 +2174,7 @@ static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
 			goto nla_put_failure;
 
 		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
-				q->max_sdu[tc]))
+				sched->max_sdu[tc]))
 			goto nla_put_failure;
 
 		nla_nest_end(skb, n);
@@ -2175,7 +2225,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
-	if (taprio_dump_tc_entries(q, skb))
+	if (oper && taprio_dump_tc_entries(skb, oper))
 		goto options_error;
 
 	if (oper && dump_schedule(skb, oper))
-- 
2.34.1

