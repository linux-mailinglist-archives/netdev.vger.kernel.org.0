Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC72667F37D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjA1BIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjA1BIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:02 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8230A22018
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWqoqKgLDNjm2Hd9sJdqk/37c7MLBqcVNnJwAPLlSBZwA63qBCOodiCeK9JpgJlXb+XdIsCNHYLveG+5cUJVUFRdMC+GEBXHekfLc8KFLyk15sh2q51LOw0GAMRyX9CVeyWpCkgoP952ULj1hETHUkuEM5OCGghI5f5M7cfrF6jNWZ9vOj2GAlDQlf5FAz/Jisl7xG2mkLu58OdYvOd0mJiZwm0JSJPFU/pDyrq0C60ehQ0sWx1vgbRredFfU/I6/gh7RQimP+20No0iKEc83vGbVRthovAdH5Gm+1rU27uRNGpRZR2A7pXfq2XYzl8Ymct5PjoONCcQYQr35VGNcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmrMhPAVzjmifYxrAjsuA9hOXQvl2+vnEVVjevd0ijA=;
 b=gKMjMeEpFvYGZCzbpHE4aVPnAc7c6GLdK4pq72BL7qxaQMRQ/wk2JH0DPY6uV9lb+6SRT7d/6lr0fmtHYoqlzgMBKxsss9fCi/GRVO3tT4nCKHnJZQ/5nX3umRs0478d980TVPcnJ8J0MLI2PdS/i+KrtFPlSOlCspp8eTUqEwXoyeogMAhbCSLWH11FaI552FqPjinAfHRZZ696ddrs3fiBNQi72ECZMpQTREP40+Vei8byHWgvjl5TvSbddq5MUBCCZFDBxw2SaGtaZ0c8SJEV4iaS9uGki60sSBlUMUfB8xCJuUTqDanCbse8hiNvbf4RPOVvu8vsPW619y3A3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmrMhPAVzjmifYxrAjsuA9hOXQvl2+vnEVVjevd0ijA=;
 b=KKZakOjA0lHEyJlv9/2gFPWFj+8dHKeS5R86OYmbJ9cs14oFMNNFMK1YDfJZKvGLbckUzxKN+515OxaS+HOn5bORk+Ig7xqz5BsSR1lUjhuNZYNC5mzHXDb3Z4qidbLA/9rcVFX+Ret1F0wEAEaSvU1nSwIk8S+ppTpta/va+ws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 09/15] net/sched: taprio: calculate guard band against actual TC gate close time
Date:   Sat, 28 Jan 2023 03:07:13 +0200
Message-Id: <20230128010719.2182346-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: c4a742e7-03e1-40ee-88fe-08db00cc15ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sS9atxsaG8qUTKlRuVdswRCQmDMbVy/z15doWSccSJfq0SmUbTbLU5Uxz5NUkMZ/fIBNktQ9XRjbCEynRXUD8GV4XTPkxtAPcFH8f4ZyiQQw+lNc/qItglZy/illZc8USB66Mu/BJD9BpbDhlex6tPWj6TKJDy01D9VeO9eCoeO+YonYHokrTRpjxpzJWBe3NS053XGQf+dO8eClUsTrj3mKEFAevmfPFxvG3y+zplQsEL3wxKS/7BzyW5/s9FKmfxf+Nf2h+QlxOFhExOlhh22+VB8xhE8ay510AQ7JOcROSlkdceqL55rPRhss4nZvkB18GDhHOtO89iRaYfIZeSRHWYZyLl+eQKKU+7ZEFeQEztfHeZslKg6F0suhEx6965YD62oSlgg2MyyFkU69EF3bsZenlmQdjdY1n6LgyxQX/kerqRaMlMNSEFahnQG77DhcdtgNvxtMIOeJ7rXFQRrSSAsrBvMCHi5JdP15cTHwt0JhQ7wAIy/7DBPDpTBQfVMoBwDyQpOvnZb3rRqTo6MLe/US5We27L7c2mAyW8wmkShZ+CdS55XXkvNuBYfO1qrsHNjYuUE+jGYYqoImLbEeH5J5dXJQlitvynKlxazQj1HTKm7JTMR8BiG+29eZHUFglolyDfXG4/TBGJbBeUeD8uEhK1lr0enVUnLLFLBs4bXE20xtzbr/YqiWcBmIRtxAJqb4ejgetxTMxz+bPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xeDF5BjAD9atyP5KCtVEfPO5MAIHB8ghH055qoMfrswddTh4IYepv5c907Tx?=
 =?us-ascii?Q?7flCQYFM/WzZ/AC/auekdKL/uUGlX0ZiiKyoiyRoz30P2eVbhzjKW14efaAT?=
 =?us-ascii?Q?dLxOr3ZF9w562mbF6Ia+7ep1rZBpnVoCKQyKDHm6onEE4KkIYtJI05GG2PZ/?=
 =?us-ascii?Q?SKM289feGGAZf1mo1c6Sklu/GLDcJvcOxSnM2OVKNLm/DEvE2RpR9DGizK40?=
 =?us-ascii?Q?wHGfSWLdYaIWQPKJ1QTaSqXP7wXY3Np9isSoxGUCuHWRZXwDSfwozLA8TvLB?=
 =?us-ascii?Q?JuaHVB1fMVJA7cFSt7fM6XD2/Ikh6hLfO8Jc59oI72cuSVcA0DuNPvudi505?=
 =?us-ascii?Q?mugv3uDnt0bFzaQ4v44tx2m3i9qzPeBzz0Z8HyNNGP5wEvvJoOq0VwPdi0Nx?=
 =?us-ascii?Q?LqNt/3TxwP2OZvKkTvZQT1ks/gDHf0Gapn+iE6TXgMa2gee/6YIMM/rsWLeC?=
 =?us-ascii?Q?+Jn4POVOblTNuyIVP9bO0cVRAz/zoIzy3K3ZCcJCb9nbsWWQr8KpOBFrzhXg?=
 =?us-ascii?Q?J180Me7PeoUu/nfmgnynjqFuozFhXkCyE1jivpl8f575juM1o46A9X7sRaNB?=
 =?us-ascii?Q?4zVVbUlm04VaMGufv58ijQg/G6poVeIqY7EDcI1UbaXZry5kKfgTgxDaPDYg?=
 =?us-ascii?Q?2RTlguZpnrDazrKUkMU7ibwEANoQ/RjDxYITC7JrIX0d+TjB7ZIUfKheLhNp?=
 =?us-ascii?Q?C7bxRXuvhicGVRruQp9SoFwuK/9KmRfDJAJ2uojdKAc1/zW2dnw9vlQTVPC/?=
 =?us-ascii?Q?qNLyEZsTXflKGSZx+0mNzexetvKx++MoikJ6pnYK77jes9tQ/lYhej5fFOjo?=
 =?us-ascii?Q?cgnKEUrFx4tQVTRdAb07gesuOGgHmMIx6+iRW+7daWaviLfU/QE/+wuxC10S?=
 =?us-ascii?Q?Ej576khYTf7HZz1B20E3WCH0rQMkf+5GB+6fD0lcbGfOOpMG1JACu8HqXTYW?=
 =?us-ascii?Q?BkNeUWLknU61wlEeqpWUBgUOe+Ac6lbkciHgELtwWfkuDG2o6zDv2IWp6Z9u?=
 =?us-ascii?Q?TVUsbde50ydjr9rEy8yJZJlIfrUSckQDI9SoZCQSLWNjtADzLMNt8ktGNKIn?=
 =?us-ascii?Q?o34yMC+iSw82MYjIFoKfK3XTxZMT8zXlet60P8idOGXuoQiG9Tcb/NdcPr1O?=
 =?us-ascii?Q?yPBbl/spOJd0H4G+ErLHlyysVi9ioKQUZrrmPYq8Pjr2nW9++uREMocIEz3x?=
 =?us-ascii?Q?9Oo5QZqKMl48T4q9oF4WnqJzRydfxvuLCBGggkv4fwOtqaoTVgxk0avx5mmB?=
 =?us-ascii?Q?E3y9GK0o95FLekjwCiZfFQjRzyqLXUjPTbdYHCCQJ3LniY+QJUXmMbnPQBfi?=
 =?us-ascii?Q?CDCzuQOjgq3XDH9vD69yMjs2nvqACkp6F3mCEnNf6RlpikA17AEvZhp0LlLI?=
 =?us-ascii?Q?lYO9M6lhmiOrBnwMtv3AxCplKo2aZJ1bghlUA97anws1frIOxFhA/Z0/1ezG?=
 =?us-ascii?Q?QJsSyleqnVeFMef3UlfmsZ7xEJ21FtD9apZjdBGjCTjsx9+5FhnOklsIkypI?=
 =?us-ascii?Q?LlIUL1QHaLVf7z1kHWTxKVa7MytdMTsRlfOouQ1ANVvNxljAK1JJDthPdZhf?=
 =?us-ascii?Q?b785gY9f0q3Y2ystYFt8ZeCszeD3eErq1UAid7OERlxGlijoSve/Z+viuKBv?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a742e7-03e1-40ee-88fe-08db00cc15ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:54.1511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxJ4bpcD2C3pDknHcfa+QM9QrNclNy61y8ZUGu69ZObJ0CMg/mIP0ZK6LR8o/n2x5TYTi4EO3qs/+w3AkEj3Xw==
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

taprio_dequeue_from_txq() looks at the entry->end_time to determine
whether the skb will overrun its traffic class gate, as if at the end of
the schedule entry there surely is a "gate close" event for it. Hint:
maybe there isn't.

For each schedule entry, introduce an array of kernel times which
actually tracks when in the future will there be an *actual* gate close
event for that traffic class, and use that in the guard band overrun
calculation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b3c25ab6a559..8ec3c0e1f741 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -40,12 +40,12 @@ struct sched_entry {
 	 */
 	u64 tc_gate_duration[TC_MAX_QUEUE];
 	atomic_t budget[TC_MAX_QUEUE];
-	struct list_head list;
-
-	/* The instant that this entry ends and the next one
-	 * should open, the qdisc will make some effort so that no
-	 * packet leaves after this time.
+	/* The qdisc makes some effort so that no packet leaves
+	 * after this time
 	 */
+	ktime_t tc_gate_close_time[TC_MAX_QUEUE];
+	struct list_head list;
+	/* Used to calculate when to advance the schedule */
 	ktime_t end_time;
 	ktime_t next_txtime;
 	int index;
@@ -142,6 +142,12 @@ static void taprio_calculate_tc_gate_durations(struct taprio_sched *q,
 	}
 }
 
+static bool taprio_entry_allows_tx(ktime_t skb_end_time,
+				   struct sched_entry *entry, int tc)
+{
+	return ktime_before(skb_end_time, entry->tc_gate_close_time[tc]);
+}
+
 static ktime_t sched_base_time(const struct sched_gate_list *sched)
 {
 	if (!sched)
@@ -629,7 +635,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	 * guard band ...
 	 */
 	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-	    ktime_after(guard, entry->end_time))
+	    !taprio_entry_allows_tx(guard, entry, tc))
 		return NULL;
 
 	/* ... and no budget. */
@@ -761,10 +767,13 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 {
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
 					      advance_timer);
+	struct net_device *dev = qdisc_dev(q->root);
 	struct sched_gate_list *oper, *admin;
+	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
 	ktime_t end_time;
+	int tc;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -802,6 +811,14 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	end_time = ktime_add_ns(entry->end_time, next->interval);
 	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
+	for (tc = 0; tc < num_tc; tc++) {
+		if (next->tc_gate_duration[tc] == oper->cycle_time)
+			next->tc_gate_close_time[tc] = KTIME_MAX;
+		else
+			next->tc_gate_close_time[tc] = ktime_add_ns(entry->end_time,
+								    next->tc_gate_duration[tc]);
+	}
+
 	if (should_change_schedules(admin, oper, end_time)) {
 		/* Set things so the next time this runs, the new
 		 * schedule runs.
@@ -1107,8 +1124,11 @@ static int taprio_get_start_time(struct Qdisc *sch,
 static void setup_first_end_time(struct taprio_sched *q,
 				 struct sched_gate_list *sched, ktime_t base)
 {
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *first;
 	ktime_t cycle;
+	int tc;
 
 	first = list_first_entry(&sched->entries,
 				 struct sched_entry, list);
@@ -1120,6 +1140,14 @@ static void setup_first_end_time(struct taprio_sched *q,
 
 	first->end_time = ktime_add_ns(base, first->interval);
 	taprio_set_budgets(q, sched, first);
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (first->tc_gate_duration[tc] == sched->cycle_time)
+			first->tc_gate_close_time[tc] = KTIME_MAX;
+		else
+			first->tc_gate_close_time[tc] = ktime_add_ns(base, first->tc_gate_duration[tc]);
+	}
+
 	rcu_assign_pointer(q->current_entry, NULL);
 }
 
-- 
2.34.1

