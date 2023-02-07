Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F8368D9D8
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjBGN4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBGN4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:56:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FD537F17;
        Tue,  7 Feb 2023 05:56:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmFVCwJpqdVYHhwL54yiSRiGFmSAk/49xSyEOMKPlEzt7topGSe4/G6oL0FKeAogCbq6gxSkJc5jk0MUFQ4NvWX74gJINAuF+EnxibII80kyqePtRDO7CFkJ0a0IQADw1mBwdY8rvhSIExAZVmLhR4qiLcUvu//6h7abG/Nqy1aiT1JDS89sBVVTZoRMSYIADqe9F8xTHYqyX+2Vb9X5FtmpjNOlIc1eNFxygK5yqip7GYYcWh5jLtB/ZSsmGVpVpX1MmIoAgM1w5Nom81RVEWZICHFoIcjQGxSpNbPEchOW/gkjpTHopf+jiooTtVe2/OxSQql3g58WvY89pyk3/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1cgxpP38hEiVNWBLSx5k6HskTdkIJ1sBnRPwfabdhI=;
 b=gdbV5+XTbFxHjoGRUw16/grYFZewHoVu9Nf1mHmbmWXKnJAIFkfYtqyGnViWkrTUuBEDx62UyEtwt1ZOr/fOj35QV7yT8FCjJnvqc5aW53DHoHirENoFU5slWDzrVhNxSH+PxaFoAlmy9R9EIK7jlK49VfSiMDWy1Gi1beKyDR9D7+Xr8HDkcv3R/PxEI4RuHfYHgQpw1o89ZId+asGCcKabQwPKT/S5ziv2Qy0YzH/7CyMgtZ2acfS5bAUc+xAcA75eJNXZjpfuKpP70Ra4wCtPNqrk3Sh2DcPzoZ9iqXW+JK3ZcLgzodgF142aulmA8LmJWGlBljOkxOxpvhgQ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1cgxpP38hEiVNWBLSx5k6HskTdkIJ1sBnRPwfabdhI=;
 b=I4YO8SVzNVir4H6xRXLK+J7CiD1hOiIbI5koQjMCItYLxXnIZxh6USzZN4CoDwcHLJdimfqINy9WlaTIX+TIgC6r0dpuKl2oEtL07CeqM3+N3zAjAS55Rxe4PlyNynE3vqmrLCZ5JwhhZ4Z3OH/atg47iDvZXVfmxYbn12RC3GA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:21 +0000
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
Subject: [PATCH v2 net-next 09/15] net/sched: taprio: calculate guard band against actual TC gate close time
Date:   Tue,  7 Feb 2023 15:54:34 +0200
Message-Id: <20230207135440.1482856-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7a8ba8be-0566-4e7c-d6ce-08db0912f3aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pl5OsLdRRZbX+LJX6cpgBzSxCnRBo/bRleIAjgH2ilOXrnVckLRQdi74jBt013ixo8atQVPvmMNlO0Av2h4rX9sFlcp60V7bRzzOgST5r4P364Z9bOfoJz2r2sf9hLOCDKf5AuC2W8xioHwHpXeghk76qAdFTshK8zHUxi6JQfyZAQHA4ysXXZgIzv/5LEKh2Jfz4CfzI0qd0dM6EhVxnVxzY0nvslUMdoVinWxa9079m0BuyX6fDumun1fgc2ex+tsIIUfGC4s9k6TnrVcw8eVQnq/hx0mUQKGEgkSjQG0iPfUnMy3dBwI5UOl8W+nDq80icnIolIZXiFj64+gduNrRQhpiXcYGVb4dXLYdZYP2AgyHf/TRGSZFp+DzqmprJyZ1rG0d4snKaqyBOvyMP5x9YRkgCJOGWstvYVSWV2AuHIF5kyc4OQKoFC7qGMfNc1mRUtUIga1bzWalLec4mPf4dfBUg8OZBHYLrEqu/N48t8kRBwZPigUiuZnspcHXZjT2LpDEf5JpcbO3eHuchDU/FFFAhIjXDfpgCtP5V/buAvJe/UIu0NgjBjWbew7FQvxyKUOZ08xPgQrPM4QZcx1ryLjlL4bu1rQrIKnwBr+8yx70i/aZnzJNsvbZiKc0GQD1FONvBahEtisFp1Ukh6W+AhC2TMBgFaQMUS0v+XTNncJNMHqb/vTWjdHlO0PpJ1dTvxy0nY4hvm/lJH4rQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sBChaVsy92Ga6/5l/bQDCf8qgpzV4AW7Yag4+k83TwlHmcaKEosaS2b326m8?=
 =?us-ascii?Q?7VwjDxpbCodMXX3PMYyPbXgrTIIuP/fDATC7tSPfm0FQDdnmPW8JFiPLW+oF?=
 =?us-ascii?Q?m905/SakhR6va4iiXJJhurhfWwsMXbVznWzc93gk+21LBVCVA5m1RIG7qEH6?=
 =?us-ascii?Q?mrhKfRruN9hqWbR4WoVKlFGIMOgkmYvnXp6SbPevNHVSmdH9bzmou1IrZ5KT?=
 =?us-ascii?Q?KpZQvp7gKw86bIp5b6RHZx0iMzlD5wfeicPK4XgWq5y15WxZ6juYbL7J/vbO?=
 =?us-ascii?Q?PTf7EVwGgow4FLWab0cgsNLD+okw9KhCyNVmIiTOcu7LIkLPZltGvbSw++n5?=
 =?us-ascii?Q?QkCmc8gIDE9pjet5KNpC9hYzbAaVXUNPA0iC1HtJaY2zj9G6uIjOXTCi/TPx?=
 =?us-ascii?Q?y3cqse6hrCowrlVyJ4So68WHfZKt0Y2f9uhdk83mrPeZSnyQsKbEqSyHcbON?=
 =?us-ascii?Q?KIg4SIXisuGV2okgfWGFiiUiq82gKKrU8eTf/3qntYBKqH55QN9sEy1Z1GVC?=
 =?us-ascii?Q?+LAQpc5xcsloHULKZWuhj+T/wQa3o8ZnXeBVwnjcEuZfd19Kpr+lO3qN/23+?=
 =?us-ascii?Q?5mJ983deds6SfLk/3W64GIuq+x/hc5ZKMg/Xe4fIiVeB+IwxBK0nPptZC635?=
 =?us-ascii?Q?GmVav+MYX3ekwCvJD9RuS1ANOQ9AFtFktdJyJzZnMRYv/eN9bw4sC+Z9RJTE?=
 =?us-ascii?Q?gA/JUa5D2VUvqVtm+TTLX2BI88lHJjdpmDJwp68mo8URz+5Nrdzxven1zBac?=
 =?us-ascii?Q?ZrLzAEnFBOwvkK+UCSXv2ZBvNdlZ+zLC2dj9cFCztO8GZ+3QRwT1fPBOGwYH?=
 =?us-ascii?Q?Mgq7h1YSdafic1ol5DL+CjlZ5HG8/Yd4HaCPkQChiUtFXBwHffWsf81Ff/5P?=
 =?us-ascii?Q?KBTYjj2sVOfCDINRQg8h/S/VPhqTYCI+MKBja98UZDGDTa5fX+5u8Q47XUTc?=
 =?us-ascii?Q?PdxBUMmOTg4xbFiOPyZQ/F3DcJjaPt7u9EjZT4/39L5DELIfBFrzRKhdXANL?=
 =?us-ascii?Q?9TzBSsKVu4vN0XJcvORYee5jGiPJLrKRkqJDVWW8BGIIeclm0Ydp0j8dx5Jw?=
 =?us-ascii?Q?hr/Z4wRn6gpHtmmfB6U9YOMFzpCiWItkovKVMvGn4TwGGPPbH4A8PR3BCeym?=
 =?us-ascii?Q?UlnNpvslvIVD9/fncuwpr6V0W7H7g0OZdKqq8AUZGl5VCpO7NFyxJLcpJWl1?=
 =?us-ascii?Q?jeIlMXPWb3bdcfDVtGRcWNRtF1XRcup3+Sf1qBpVZd+mNNpFC90yKJqWbW6G?=
 =?us-ascii?Q?Wd2kTQPjUUECfyEq49c6DAYi/3oyYM6Oz1ZN90IBE2iOueNgJ55q5TGOYyRj?=
 =?us-ascii?Q?EnamLog0YpxGRvkjag5DvdcoBOp6VBFvMNHHRW5CdrloFj+0WGffKCMk7SxJ?=
 =?us-ascii?Q?dJKzISG6Ksx9Jm+2K9QJeYmFgyeAHzH0GWjchLrcLxyir0tgSLAgTHLWf7rV?=
 =?us-ascii?Q?t7vypy3FOepmiD+eTB4ETBOT0jsRd7xrLgQVMnf+NjFrW10Dm7GdkMzeSdaY?=
 =?us-ascii?Q?QkuSmcbsEv6+LaCBTrLfWPk1Yijj0wJi8A/PnB66gQpjoI1Q2bHnSeu1ic02?=
 =?us-ascii?Q?2ZYpA/qUBh3fBLPmKACdtBobv+FCU1OoQ/mIV5ndLWmI0/5Ql6j1aumDcRsk?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8ba8be-0566-4e7c-d6ce-08db0912f3aa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:21.8927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBHkmlMoUYc+W9vFkzUVxyyf4gOccZXB1xExk5V6sCUl9LgjXggF8NBf/unhQ/U5TD5h7hQGp2KNk0kElRV/Yg==
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

taprio_dequeue_from_txq() looks at the entry->end_time to determine
whether the skb will overrun its traffic class gate, as if at the end of
the schedule entry there surely is a "gate close" event for it. Hint:
maybe there isn't.

For each schedule entry, introduce an array of kernel times which
actually tracks when in the future will there be an *actual* gate close
event for that traffic class, and use that in the guard band overrun
calculation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: rename "tc_gate" to just "gate"

 net/sched/sch_taprio.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 08099c1747cc..e625f8f8704f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -44,12 +44,12 @@ struct sched_entry {
 	 */
 	u64 gate_duration[TC_MAX_QUEUE];
 	atomic_t budget[TC_MAX_QUEUE];
-	struct list_head list;
-
-	/* The instant that this entry ends and the next one
-	 * should open, the qdisc will make some effort so that no
-	 * packet leaves after this time.
+	/* The qdisc makes some effort so that no packet leaves
+	 * after this time
 	 */
+	ktime_t gate_close_time[TC_MAX_QUEUE];
+	struct list_head list;
+	/* Used to calculate when to advance the schedule */
 	ktime_t end_time;
 	ktime_t next_txtime;
 	int index;
@@ -148,6 +148,12 @@ static void taprio_calculate_gate_durations(struct taprio_sched *q,
 	}
 }
 
+static bool taprio_entry_allows_tx(ktime_t skb_end_time,
+				   struct sched_entry *entry, int tc)
+{
+	return ktime_before(skb_end_time, entry->gate_close_time[tc]);
+}
+
 static ktime_t sched_base_time(const struct sched_gate_list *sched)
 {
 	if (!sched)
@@ -644,7 +650,7 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	 * guard band ...
 	 */
 	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-	    ktime_after(guard, entry->end_time))
+	    !taprio_entry_allows_tx(guard, entry, tc))
 		return NULL;
 
 	/* ... and no budget. */
@@ -820,10 +826,13 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
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
@@ -861,6 +870,14 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 	end_time = ktime_add_ns(entry->end_time, next->interval);
 	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
+	for (tc = 0; tc < num_tc; tc++) {
+		if (next->gate_duration[tc] == oper->cycle_time)
+			next->gate_close_time[tc] = KTIME_MAX;
+		else
+			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
+								 next->gate_duration[tc]);
+	}
+
 	if (should_change_schedules(admin, oper, end_time)) {
 		/* Set things so the next time this runs, the new
 		 * schedule runs.
@@ -1117,8 +1134,11 @@ static int taprio_get_start_time(struct Qdisc *sch,
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
@@ -1130,6 +1150,14 @@ static void setup_first_end_time(struct taprio_sched *q,
 
 	first->end_time = ktime_add_ns(base, first->interval);
 	taprio_set_budgets(q, sched, first);
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (first->gate_duration[tc] == sched->cycle_time)
+			first->gate_close_time[tc] = KTIME_MAX;
+		else
+			first->gate_close_time[tc] = ktime_add_ns(base, first->gate_duration[tc]);
+	}
+
 	rcu_assign_pointer(q->current_entry, NULL);
 }
 
-- 
2.34.1

