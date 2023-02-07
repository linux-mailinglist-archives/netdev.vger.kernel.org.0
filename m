Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598DE68D9FA
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjBGN6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjBGN6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:58:04 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B442E0FA;
        Tue,  7 Feb 2023 05:57:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvEjdkoPTcBYhb5IEGmK+YTqtNyz4VGt+cheWFpVlqZFZm/DBmMVU1y2Wxzt7wrgoQyOF6XzY0iJk0/XyG3tAMTzHFJXdEMzJNPgxIUqU81PnZ3mfnPWJ7MjOUKutoBCrISlahjYR7C/yhFzYHtYOaTwReBQYfZNgT/hnXUES7wl9hgej0TjVU3G0jS98AqTq/FGuvGGSVjjomcR6/nMjmrlJ0V82iFmX0mv75UUzYZceRubFBI/IWUQ/gCJ1p2qKi8fpPTiPIvd02EyWWuLAIi0pI+RoV60TyBummMO9q2jaJFzgFQ1erQ1ww9qNHwTj1EG1dvxo7E2t/Eqg5J2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuPLRJ7SNyyCiyR9jFu+ruSdL2kWjmKTnlGihV9wK+U=;
 b=Bc9v7+csCg3VwTtKvtWoUjIqUOSqnOH0AVtriTs0/EJNLmHqL9sA5FgK0/yIV3j+dOPq3dx1v7I6Sy8b0ng9bmT1JxN10rzSNtv+GpLaTrV+0Ktx6XRweWk03+E/aZMCLv1J73PLABfJmCrhHIfVJ44mNci9FihCgUGmcEEUiBcIkatu4RhF7T0hif7QEm+dk1smx0MdQUKNPJz4rqHeBfuHes4PeEZJHik6Majcf/YQzYooSp62CyyMPOJ4IGkFt2ScAb8BOO1LDcd/Nlb4caFoHWE4CJ9kzdf9Bik6n2enFoqswwgMRLBzrgvG1QfPkDjhvF0LOuarti50bwZPuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuPLRJ7SNyyCiyR9jFu+ruSdL2kWjmKTnlGihV9wK+U=;
 b=o4UQ/xy2HhZ1Mct7Mdo8KyKf4sl76D4hwpK+RP1luau0OxRj5jJp29SYlORiHrI8N9PZqpm+WW92ujYwBTQ7dHfrZOFZ6TXZkCTWtBjShbw4KqrDUa/Hop0800F/2Ko6MeBRQA3SHx8ybfyNbvSy6sGya5yKWhbpaR/p5B0Fi9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:31 +0000
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
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 13/15] net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations
Date:   Tue,  7 Feb 2023 15:54:38 +0200
Message-Id: <20230207135440.1482856-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b7ae1c-f9dc-423f-fe88-08db0912f9a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFp7RQiQHNycD5T6RFxGF1AdmZ4AjDd0mWTaSCkZIXgDzSgYD9NxRdl/RiSNe7jMTqonMCnRzRHuEfbH0RkHUFECamHDpPrKT0RhMXubEOrF7En95RG6Q+Zd6SifVIYCW4LoGvdeZ9sZGeEZaJr2nfm/FGHnJAnygGgxuagtwxWFtEKdOivk5gKSzkl3/lC0zbwWqD3Qot47YIVXBe63jAzUa8/QK3FjT0yW/3KetuOu8cbPtAr4qYBqjRg7nrKRFojTcBEuWAJtnLhi/H9jz9uzt6/itrrxnH5ORB5+SL6ctUO6Aj5ev0qTDFs/6SSjEvbk1A3OK6TAFj3CnArngIpbSshnG8jKtdVKJxPRMvsDshXOYP9wcAuTDSeSkOtZo/FW6LLldTjqAg22djdlUeXwMmWja/nFXs2A5OMknKfuiLgHGqcZ7/kcT0kUoI0QD/taoEpHUrZuATm/P47VUqydXYqYMdtmNVW1EgjZ7VZ0ux+x6++NCToC7ykPB0PQ+6tT4obNsNj4AIXDQEZO3+jeNuJjDaygPKP7uJGPm7JXHAvZ7GV0dexPKnPVojWcXdu15GxUJlfpr7n50UXbwfS1PH095QqKsuz3uJKNfnwS6ubhoiXy7ZkLCcO3DgRryh0CcMGFkaK/XINy7YHnYCYOGPoe5rK0qolQe9AUIGW5I/p4Ob5exPPg2/Umrjt+9ne+LxqkXMRAevACk9L1lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G37AU/hUAV2bBRRFwti/eXmOl6Zk206s7a8qXxXbIE7ZJ7RMIzoDFsi3AMfl?=
 =?us-ascii?Q?Ji8hIXZs9Wi1a2L1/gOgCZCvqoNHA0MbTFJ4QwcxMwJVTKqc0juArltLXMIM?=
 =?us-ascii?Q?zEVHt3LDpkvhsigb1ePuz5VPcLKqqN6AxSCtqhbDL1TKERBVBxwulhRuHgoB?=
 =?us-ascii?Q?l84id/1pPt/QEVuf2X++YqfoEnqddfDqqQOvO9V6cY21yxsG02yqikNt2Aiv?=
 =?us-ascii?Q?mJgiX6QwtqQzC+ZWvYY0hnAqzoxG1pSMiaAgVBp4vmH17wRvnlYYOpL3dghY?=
 =?us-ascii?Q?o8H0jYi29MClmOoBXWHLKof4pnt6svPP1cStnjmNYv/b6A8ehuabb1/K3PvI?=
 =?us-ascii?Q?ODqFCrC+civb+Fo0xSD0DUBKI/P7aB3l6NuRxni5ZIp9PWOLF8rWvDDHa65D?=
 =?us-ascii?Q?PnXAnphDVyY0+Ftb3arCuEkEMfKn9V5Kyka/YugofUcZwT3YkGumJNFZRBZ8?=
 =?us-ascii?Q?XgLeaPmrSSTybYKs0+Esd/cqkgecAClmLat65QwMkMH123UCzxvZd4PehRGq?=
 =?us-ascii?Q?D08stVyZaklQP8y2UA2T6d3sP7/0hnd7YdAvr63Fc8HlYxdcLwjIPCYT82ee?=
 =?us-ascii?Q?wdD02tMT0x09b4Il0B+UO7kcM60yuJqOTpC+ZfiKC0iel5MBM7lGU8o2f6aZ?=
 =?us-ascii?Q?A4nkRCZg3ORRhEnccWo6+M2cYrVkmBCzUrwbaq5jASs8zz0qbO9AvhqA5RLs?=
 =?us-ascii?Q?/bZdlELmFnUAfAGNDg9N1+6xHFhtN043z/sim4+uaBoYcdiSCqGYiWgzLBwy?=
 =?us-ascii?Q?kKplccCJxiGE6Opbh4Y5hifhKs4v/31eKUnZu6BheFrZEmb+mQS6742V16+2?=
 =?us-ascii?Q?GN1WzmQyiSeY6LmKxSxdN57sL8eoTHGsIgBjlG0EaUVufWXRJJX0yUS/opzT?=
 =?us-ascii?Q?etUxAn+FQFxXdxaaH6tedU89WGxf5K2/Hq1af0WRVISl811Bb9kgf8Y7qant?=
 =?us-ascii?Q?piRFoQY5Nri9T+MsP5Wp5i9I+qn4QT+lBmsa7QVXCWxKeDJrKGvWnmOd/OQv?=
 =?us-ascii?Q?ESId0uUeAqEWY5OS1NLClECznO6OEyzd3smayGQkcLH8bDUXstXNVIQnAx82?=
 =?us-ascii?Q?4ylIgPohaUEaRBQ3bqbO13l+Q8/WZYHc+3bviLTWWS7aa4yXUaqA8JprREd9?=
 =?us-ascii?Q?7eAxMrKe5P6wrWSYGB86UZQ5CYGmlsRTqMt9rRjX5CV36TJT6U0vzoDyozq+?=
 =?us-ascii?Q?hPvZNcDYZoOvcNhM4R1//kpLEMK1pt1NeQJChKbVZIB5obHeTxdZ8e2wz37q?=
 =?us-ascii?Q?LtQkH0UL6TzWFWCgeNcvexaYXrSebE65nEzv2nuUA3Z7Vni3M3+w1z7A9Z4R?=
 =?us-ascii?Q?OQSPchlMf44iNJfwOnG4KtuHZ5e9/VNsJi+C0CzBs5uIIFduagg0Mg20EQfY?=
 =?us-ascii?Q?okD+JqclNFHKWFkA31WUJNc0lzmcoz/i8lry9esPluPqbkEnCmNXAcfgt3Id?=
 =?us-ascii?Q?rnn96gcnrkbYM+k5o9bp0mo8ioCFzO1xyvvk74tsmrCVtrtpWbjjQUYibCyf?=
 =?us-ascii?Q?ZdYTPJzmpa5ZcumDq8egdoCmIMmZetX9n3tL2z088bu+QJ7tzPaFjHCzI16c?=
 =?us-ascii?Q?govFFfSFua3aZUDuTZLhkeTaW1Uu3zYu3j3LwD2bo1THmyZO1++LJvfklJcG?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b7ae1c-f9dc-423f-fe88-08db0912f9a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:30.9701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IJtZNyo3eW6YOHTN7tYSvfqDXNVPM+fxsHK+Fpj0eLeY5HuPLRfeSDDF7fqaItItS3EI1V6l9VIJsfNKrvNPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
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
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: max_open_tc_gate_duration got renamed to max_open_gate_duration

 net/sched/sch_taprio.c | 70 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index d3e3be543fae..e7163d6fab77 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -64,6 +64,7 @@ struct sched_gate_list {
 	 */
 	u64 max_open_gate_duration[TC_MAX_QUEUE];
 	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
+	u32 max_sdu[TC_MAX_QUEUE]; /* for dump */
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
@@ -94,7 +95,7 @@ struct taprio_sched {
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 	int cur_txq[TC_MAX_QUEUE];
-	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
+	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
 	u32 txtime_delay;
 };
 
@@ -246,18 +247,52 @@ static int length_to_duration(struct taprio_sched *q, int len)
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
+		if (sched->max_open_gate_duration[tc] == sched->cycle_time) {
+			max_sdu_dynamic = U32_MAX;
+		} else {
+			u32 max_frm_len;
+
+			max_frm_len = duration_to_length(q, sched->max_open_gate_duration[tc]);
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
 
@@ -1243,6 +1278,8 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 			       void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct sched_gate_list *oper, *admin;
+	struct qdisc_size_table *stab;
 	struct taprio_sched *q;
 
 	ASSERT_RTNL();
@@ -1255,6 +1292,17 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
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
 
@@ -1654,7 +1702,8 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
 			continue;
 
-		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs, extack);
+		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs,
+					    extack);
 		if (err)
 			goto out;
 	}
@@ -1784,7 +1833,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 
 	taprio_set_picos_per_byte(dev, q);
-	taprio_update_queue_max_sdu(q, new_admin);
+	taprio_update_queue_max_sdu(q, new_admin, stab);
 
 	if (mqprio) {
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
@@ -2142,7 +2191,8 @@ static int dump_schedule(struct sk_buff *msg,
 	return -1;
 }
 
-static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
+static int taprio_dump_tc_entries(struct sk_buff *skb,
+				  struct sched_gate_list *sched)
 {
 	struct nlattr *n;
 	int tc;
@@ -2156,7 +2206,7 @@ static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
 			goto nla_put_failure;
 
 		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
-				q->max_sdu[tc]))
+				sched->max_sdu[tc]))
 			goto nla_put_failure;
 
 		nla_nest_end(skb, n);
@@ -2200,7 +2250,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
-	if (taprio_dump_tc_entries(q, skb))
+	if (oper && taprio_dump_tc_entries(skb, oper))
 		goto options_error;
 
 	if (oper && dump_schedule(skb, oper))
-- 
2.34.1

