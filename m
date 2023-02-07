Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F3D68D9D0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjBGN4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjBGN4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:56:06 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF2938EB2;
        Tue,  7 Feb 2023 05:55:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJ3yHu+4bveH69T7yrD+kFbBZyLmn+HTBQYUJIndyuDKXCdp7Ujz0FgsHXUWRIKBvmzwcNwa5Xq1AzG0wdjacEV6ha5uMWr9at45z4QfjnfsZHyB7tF94kngL0utxQg7YYdETdMqyTRpgMXtoqkpBK8pnWtPEOMy7HxF17J+Ap0c9IjnXCp55lIoTkNNKRY/sUXz20v2A15YlWPu6lZ1sn6beQvhdkiyDeRarTjk5jDb/t/GnR1XI/60eVd1Tm+8JaDL8o5vsi0oXcyKCjxpQN8XBrQxpWL1Vz54gjfwbPpsg+Jp3eP4l7dMQXd4fx+tIG6hxY/IcgD6/3xzsCjCLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Vx238rJ90P6wkkhoauMB2d2JNtugRnFwNwtbfQMEBQ=;
 b=MGe+Ev7HfGducVbbcJ0GqkiF5r9Gq/zCcCT3WXJgP6jj2pnqw09/6rw3uf+bTLQTtTaRBe4pb7rR5WEZ2pqMJCUD2Rlufj/l35TUfDASzEgaxI8LUqUv1sYgVSSOdI5VAR4gestbc2d9pq1QTDusT71MP6hNNI3oWJfnVg9CDTSXW46sUMz3J86/zLXPQDRyetOcpcW8DUlzaSat/1wKo8IVNIhn/C0jjWK1dPZhlb/FL1hQfFdGPxxOIC39AU62hfCLdc4joZnrm7uDoiJZmDRxng4DfY7z1j6dKOd4+zDL4mWFLeFyrhqZTr4gxODsBQwHpd0h2ja0DKpTWZVsBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Vx238rJ90P6wkkhoauMB2d2JNtugRnFwNwtbfQMEBQ=;
 b=oUgHRrEDTIG4CZiBqTnZs9w0S2X3IDuSY8+eP9I8kFaAVDRjHkp1Co08URClgmBGpk8XzaHSCjMZudzuReSfgY3HMkkAfs7bULAERTN401NRn0/VyVPQUNME9cTN/IncT9Q1JoOoqUG5Njv8PLungWi19GDW09AJnyM9agcGDuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:16 +0000
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
Subject: [PATCH v2 net-next 07/15] net/sched: taprio: rename close_time to end_time
Date:   Tue,  7 Feb 2023 15:54:32 +0200
Message-Id: <20230207135440.1482856-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e454eb61-440e-4b37-113a-08db0912f152
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZcLZp5DPqcsJy2G6wiCsPOcu9FjCNBZuDU63ucxbjpxdcEr53pUr6hG2R53VQ+VBnNroxPoyvocItzBQFdqKSrY0ahtPLdm4NfgOGPEjl6ZKog7ZwxB1IqwWgCo2PaKlzgis6Wmc6BOX1g5KZ8TbDr+msZ8EervKp502gGYrsxwBUOj4yIbLtcdpxVg6+cULUnCXQ2/J+/Q7vcjTKwRbeZ2hWI3WnT+/0506Gz2MOHbI0xDSj1dLrOSVJjzg/wHA6MP/cInLV43FzINEhICLTzO91TZKdL2OSWoJrUjGMwWPsKn04ED+vVpSFLnpTL9aX9gm2lL2OX+8VcRlwYXbQAKrX/WKKPnsVyskg6C/R5khMXc1xJfL0vQO/hd80OYXIg3NWsU/gsi6ylfzALZ7oDwXYYySaQt/BUVvcjlYygKGr6clbnjxk7826DOoG9MNkE4AsEAb319dUHUyJFEy7Uonvsmm24rrrmoHb2ztIkbQ6DDUFOkKGYpGwSzotFRu/WHl/N3tY7IJUIpUGEo2xOq87hFarOjUPBxvoMm+Mlq8DqDvfqs7uL1AXZKsVJuDsurAKrHsBw2Y4+afywQM0bdFNX+bOW+p9zqbw6Va6LWAHirHrhQRZ4yDLuFd15LQMPS7DgCoxAfpghQ2k3THgQGyB8EawFhyUO84X385oGfZAYy25BjJlH4WAltjFzEatEt+JJ3UYA+CbFgr5nq6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cgo4iWPHgv8ytlYQZf2THvQjWhvRO02W6XrjiII+qkRBgTgzQBVkvmQ76bd3?=
 =?us-ascii?Q?MGlrEpzNfY6S+qNeLe8Bmwc624f/z8H4UYJWOokHagHt5M98Hrnduw/SjULf?=
 =?us-ascii?Q?+TOP+NKjFQbPPAYTp65RnSI2FEZGliCCUWV1YE/PJVH5mWXdPKvbzPX/sOw6?=
 =?us-ascii?Q?BkI4aMLfrEbFdznrO0oIE5pbadxLN9JF81hrUgqsyHPnIxUeGhgDX/v+dN37?=
 =?us-ascii?Q?7OvDkJboSRlFEbLUgJfM5YrzCmXyErthQFHUAJP/kvIALKsLypikz/oLjXKm?=
 =?us-ascii?Q?j6Srztixnf/SzfRbLBpByhUcyX4IUL0lbnbBsENrfQ/LhmHegtJzz99JbAR1?=
 =?us-ascii?Q?mCVYQ1DS0peWaOTBu2cIwMv+cIr4jtcaxh6Kg82n19cCsC6ITH6QW2GQJuzM?=
 =?us-ascii?Q?Re5ZCc0DBAehoCuJSO+M/5dZDcA+Zd+DUvfPh0UfskJtOwLjMLmACdLUkntC?=
 =?us-ascii?Q?N0Qrf+zcPSoRNpu6eV0u9QEQ94wES38GWF9B+veEh/at/mvOiXY77EeIIEBK?=
 =?us-ascii?Q?hcg4Icac1FUvUK4vTE+3fhSLLvmWXRrfOIT2pF5PALJgXTE4VqtzloFdHMA4?=
 =?us-ascii?Q?L6GAFFM+RPhCEHI93epAXc+9pJWPHtBx6oNVUsE8CbFuqVqMvgUskaKChwCS?=
 =?us-ascii?Q?uwBLO63MNZzgzAsLcmF1EAmwmhWd3N+1GI2pusM7TMXVtIYVtC6MgUvbwzZY?=
 =?us-ascii?Q?kkX/HGo0M0cTbo49k7fhsEeJ7tR2xXDPp67ce4SW703fKcXx+bIgH6kh8O6R?=
 =?us-ascii?Q?H320ZLVe7M/7juIW+MGs7qHrpaIe2Jp6gXQVX10tYuir+uojJmOGX6GTJraa?=
 =?us-ascii?Q?cfHHd5Y0BXeHNv4PcAhvqcTlFysjJa5IwkIQruyH1Q0FmC5USaGELiNLnGfO?=
 =?us-ascii?Q?lqzmotQfnVyURmVI08ARrRhZUEII/M70cw093JnIGel01NiTMcuA0CVhbcHW?=
 =?us-ascii?Q?Qe6RWpL3tS+uGjzK019MrbbUPo47cyqkySuOThcYe2mMZyIxD99XksYEfPeU?=
 =?us-ascii?Q?7XZpCE6RHZrTf6sjZwIKncLg1bTESXPrbGsQpO4UgiA3DcsQIVrvfVOj1VdD?=
 =?us-ascii?Q?+yz8HWACx8rc/WeEhSXHHZkXcMzE343qLr++/45GLohrVY5hXQZoF++yuiR1?=
 =?us-ascii?Q?2vtkq5fqgbo6oDqZLsQBrQkScPAcAuBM1lKy8ETTyMjO9bKSnW210UeCI0Zl?=
 =?us-ascii?Q?ZYuZXD0vgWyL8kKueCuJQbLY2+P8cn12eATEiQS8jX3HDwCqFp9TzSq9fh1l?=
 =?us-ascii?Q?kvpr7qU1sluX43ZGXqt/MraNx4nq4b56JYvckrgn+2TWab+ptD9N6fBCYcZJ?=
 =?us-ascii?Q?iULNG7goHKvbhv4mcrKsj/hJAKgHfvMS9Df4rnsIP6W1wv7A5f7jsRmX+GDu?=
 =?us-ascii?Q?q+h6R4RoG/Zgn4DxNEi0W5gOmnqmuq/kXocwZJ//qXjL/BPtVz1dTcnlBM4n?=
 =?us-ascii?Q?1pJMTfwrIW2eXocI87Guc/m+htVrhNHzv1diH2zaaSoCr695NyyQrVYwoLdk?=
 =?us-ascii?Q?QEB3/jwDKx344s4HjKTDenlz15GBimt12n9SgdZDOK4iWVqy0NcU4oL1T7Kj?=
 =?us-ascii?Q?VWwznuo+pzJ/zJ3QdDLoY1QDl3ZtP/LQBBu/uyKG2c9LBcTPTgrK6YcRMOkd?=
 =?us-ascii?Q?5g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e454eb61-440e-4b37-113a-08db0912f152
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:16.8305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIDe1fLsej7bX8Z/ROm2nBBEcTrH7WrftS5d57+/DzrIoLRytL2GL/jv87QUhwOfBcKvGu6sUxhCmNOuKULAEg==
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

There is a confusion in terms in taprio which makes what is called
"close_time" to be actually used for 2 things:

1. determining when an entry "closes" such that transmitted skbs are
   never allowed to overrun that time (?!)
2. an aid for determining when to advance and/or restart the schedule
   using the hrtimer

It makes more sense to call this so-called "close_time" "end_time",
because it's not clear at all to me what "closes". Future patches will
hopefully make better use of the term "to close".

This is an absolutely mechanical change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: none

 net/sched/sch_taprio.c | 52 +++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7d897bbd48ca..3e798c8406ae 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -45,11 +45,11 @@ struct sched_entry {
 	u64 gate_duration[TC_MAX_QUEUE];
 	struct list_head list;
 
-	/* The instant that this entry "closes" and the next one
+	/* The instant that this entry ends and the next one
 	 * should open, the qdisc will make some effort so that no
 	 * packet leaves after this time.
 	 */
-	ktime_t close_time;
+	ktime_t end_time;
 	ktime_t next_txtime;
 	atomic_t budget;
 	int index;
@@ -66,7 +66,7 @@ struct sched_gate_list {
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
-	ktime_t cycle_close_time;
+	ktime_t cycle_end_time;
 	s64 cycle_time;
 	s64 cycle_time_extension;
 	s64 base_time;
@@ -606,7 +606,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	 * guard band ...
 	 */
 	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-	    ktime_after(guard, entry->close_time))
+	    ktime_after(guard, entry->end_time))
 		return NULL;
 
 	/* ... and no budget. */
@@ -738,7 +738,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 	if (list_is_last(&entry->list, &oper->entries))
 		return true;
 
-	if (ktime_compare(entry->close_time, oper->cycle_close_time) == 0)
+	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
 		return true;
 
 	return false;
@@ -746,7 +746,7 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
 
 static bool should_change_schedules(const struct sched_gate_list *admin,
 				    const struct sched_gate_list *oper,
-				    ktime_t close_time)
+				    ktime_t end_time)
 {
 	ktime_t next_base_time, extension_time;
 
@@ -755,18 +755,18 @@ static bool should_change_schedules(const struct sched_gate_list *admin,
 
 	next_base_time = sched_base_time(admin);
 
-	/* This is the simple case, the close_time would fall after
+	/* This is the simple case, the end_time would fall after
 	 * the next schedule base_time.
 	 */
-	if (ktime_compare(next_base_time, close_time) <= 0)
+	if (ktime_compare(next_base_time, end_time) <= 0)
 		return true;
 
-	/* This is the cycle_time_extension case, if the close_time
+	/* This is the cycle_time_extension case, if the end_time
 	 * plus the amount that can be extended would fall after the
 	 * next schedule base_time, we can extend the current schedule
 	 * for that amount.
 	 */
-	extension_time = ktime_add_ns(close_time, oper->cycle_time_extension);
+	extension_time = ktime_add_ns(end_time, oper->cycle_time_extension);
 
 	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
 	 * how precisely the extension should be made. So after
@@ -785,7 +785,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	struct sched_gate_list *oper, *admin;
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t close_time;
+	ktime_t end_time;
 
 	spin_lock(&q->current_entry_lock);
 	entry = rcu_dereference_protected(q->current_entry,
@@ -804,41 +804,41 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	 * entry of all schedules are pre-calculated during the
 	 * schedule initialization.
 	 */
-	if (unlikely(!entry || entry->close_time == oper->base_time)) {
+	if (unlikely(!entry || entry->end_time == oper->base_time)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		close_time = next->close_time;
+		end_time = next->end_time;
 		goto first_run;
 	}
 
 	if (should_restart_cycle(oper, entry)) {
 		next = list_first_entry(&oper->entries, struct sched_entry,
 					list);
-		oper->cycle_close_time = ktime_add_ns(oper->cycle_close_time,
-						      oper->cycle_time);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+						    oper->cycle_time);
 	} else {
 		next = list_next_entry(entry, list);
 	}
 
-	close_time = ktime_add_ns(entry->close_time, next->interval);
-	close_time = min_t(ktime_t, close_time, oper->cycle_close_time);
+	end_time = ktime_add_ns(entry->end_time, next->interval);
+	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
-	if (should_change_schedules(admin, oper, close_time)) {
+	if (should_change_schedules(admin, oper, end_time)) {
 		/* Set things so the next time this runs, the new
 		 * schedule runs.
 		 */
-		close_time = sched_base_time(admin);
+		end_time = sched_base_time(admin);
 		switch_schedules(q, &admin, &oper);
 	}
 
-	next->close_time = close_time;
+	next->end_time = end_time;
 	taprio_set_budget(q, next);
 
 first_run:
 	rcu_assign_pointer(q->current_entry, next);
 	spin_unlock(&q->current_entry_lock);
 
-	hrtimer_set_expires(&q->advance_timer, close_time);
+	hrtimer_set_expires(&q->advance_timer, end_time);
 
 	rcu_read_lock();
 	__netif_schedule(sch);
@@ -1076,8 +1076,8 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	return 0;
 }
 
-static void setup_first_close_time(struct taprio_sched *q,
-				   struct sched_gate_list *sched, ktime_t base)
+static void setup_first_end_time(struct taprio_sched *q,
+				 struct sched_gate_list *sched, ktime_t base)
 {
 	struct sched_entry *first;
 	ktime_t cycle;
@@ -1088,9 +1088,9 @@ static void setup_first_close_time(struct taprio_sched *q,
 	cycle = sched->cycle_time;
 
 	/* FIXME: find a better place to do this */
-	sched->cycle_close_time = ktime_add_ns(base, cycle);
+	sched->cycle_end_time = ktime_add_ns(base, cycle);
 
-	first->close_time = ktime_add_ns(base, first->interval);
+	first->end_time = ktime_add_ns(base, first->interval);
 	taprio_set_budget(q, first);
 	rcu_assign_pointer(q->current_entry, NULL);
 }
@@ -1756,7 +1756,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 	} else {
-		setup_first_close_time(q, new_admin, start);
+		setup_first_end_time(q, new_admin, start);
 
 		/* Protects against advance_sched() */
 		spin_lock_irqsave(&q->current_entry_lock, flags);
-- 
2.34.1

