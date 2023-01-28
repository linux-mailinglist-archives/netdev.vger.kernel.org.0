Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52BD67F378
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjA1BIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbjA1BH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:07:58 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1974623640
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3HXbagZ4elzRiIEzlG10vB/UNRW0nbG48R0yL3C/6apO5iz6x5eUi6ggkRL1FRmRxr1W1PPb0kxRlCX93l2pbWf37No6rHKTCv4sqwdFujdlIhtIieIwuIb/CdlEDeU5jQaLUp0cnMuELs3Y1TRGMtfE7Q8zcDi+JwlHhVqupPtNjQ8lB7zh73n/0+Shu2EeQ0z6C3bMec3AhQbDq10vwQkU4Fn73SzyZ2gftgy7dM2D5gdxU9tXm5Y0N6yG5pJwhBse5li7CF5b73dVCYls+2I6sApMe8yOTCj9yyViaSVE95MQxqj+c+sCVOxtPNIcsrdwHz6XT3P3kaYrySIsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9op/AhMplJj9e5Vzos73yAvRTc2/6szWqr/UptpKPs=;
 b=QHKAl6NkUTxZui8mG9Dw09xvuS7ZQ4ewZz0WC1Vm70QuNcBAfJv3sl7ovecgyr2cUiH1/I6nalx52GfZPpvVeskxKhU/8nrQ3t5v5yHB84HkviqfhZAjjuZZDflZJk9/2d5XPL1Ey3szR1WzruIpqw9d694lZoxPVZnTfptV7qXiCTnbECD/8OuyoDsEImCX1BSJnlwvSqFlvrCQSIitU7sPQAOQ+cJQzXf+Z8+as2tl+RNpKX83G5NYmCPtt4kM1Y06s3JmWHhXW8d9njWVCXHoBy4EK1hi1JTxZiLVTK6fqo5gN5eCTJiaZ59Po1BlD+E2QeAJyV6LQcsB1NhlTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9op/AhMplJj9e5Vzos73yAvRTc2/6szWqr/UptpKPs=;
 b=nK0McIA4I48BdsDj56TmIRAI5cXwVkc9Jrg9pPLq7UZKKU7CrQUgKMvSyUwPgq5/vH89bLYK0lxleSwJGpxg325aCZ5/G0RuLpi39wifF4toJq/CDvU2uJOogpP69IafumDzzPPzXRQJA0d3fZxwv8t4zax+sOJM32PclCPVULc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 05/15] net/sched: taprio: give higher priority to higher TCs in software dequeue mode
Date:   Sat, 28 Jan 2023 03:07:09 +0200
Message-Id: <20230128010719.2182346-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 564e4396-981f-4a7c-c613-08db00cc145d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kBLU0qV4UXqYF0uyieHyP/dfZPjcbDmk4C9ir67ugAZ63Hj86N5MgmpaFg8ZNzzY5nghj6W99WYKXZLOJ7ZwIRv0GMoFlPyDIAolZ/FAA0USsJxSTTHA+AilCQRaCwso1weLVzGOj9jytgNATIeV08tD9iojtRbnSH9xoPKkblCzbYTd5H87cYYNtKIJpffQq9rHcnyrBX+DdDOsmOlHDUEU5wFRGZw78kr+Zs5GTU9+Z5CyQhCqDNe3MK0VtWBA7xpDCcB+RXXBemxXFQ2M9MPWs4rzLTay4UvLN6B9qQCGAcJTWCAe3q8ZQRh/pdDJKHBr9LV9k7HS7i6N5Af2PlsYhM9QRiJxBx646ILh43Vx8UgHbZidH4yzVy7uy0JQxYhPE5iFV4qmHiElPGxP3cIiW405sNJT3ZV3mO/k2qpDPV9U/UwvRPhhRmJ9JaK4tGUKjCUjFzEePTstvP5MlQit59745KNO4roEtEMUgD9PkQC2wnmiMCqparqEI1me21cWWL2xAA48OEPToT0OBUToDoAfdUKLQFbqpy7i+xh8SywVMbX/kljF+XIXoaaNMPS8tBZRdS1nOWMXAy2Q3VI8P5dEBk8ymOLSlrQCPiMwHhumVqIZr02YFJtKpiYPdF7EXf4W5PKP5lJrppFhLgsshihAK58QycPGKQTznY3Kl6PrtDHlb6jbUgneNu6PzK4FxqYNQ3XVc216OkKAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TT0VNp2ilhRPZ2l5GyYv1OwYkaWqM+JDd48jMlbIB/11cF+7pVzijZE35E2x?=
 =?us-ascii?Q?EkOOJnaE8Q5DOPyCNJZasNZDS7s88vpT5OyGV8NBKKm/VSjt4N8Za+NSMpov?=
 =?us-ascii?Q?zWdlF6065bVv/2pwBchlcm/LiyO+xZ4+G96NJWg/5BWwxYEx693sbwChZFEh?=
 =?us-ascii?Q?Dip9Mby4Wow62VVAyaFtWXegOaHl6cgFcsJaI3Kh0E7w3QB4wA/F8CbVtaFo?=
 =?us-ascii?Q?Jq2tu1Zy9bP0ChIvjoGEJKv1oCbVdemooXLk5AEiFDdVlNJU1htIUvr9sFnW?=
 =?us-ascii?Q?5m31F/4m1IOIkUoHgumwD/7+Gljmy2K2keJHr3XLunPLK0HwuPi7kg4jBL49?=
 =?us-ascii?Q?x6eIRLhJfn2Ds88ByWVszzgaMtfxZMyGDKOMD/E3+RCYjdTA8KefyhVmcc8D?=
 =?us-ascii?Q?wyXTXFCjJiRrekH9xAJlkabvICWs0kwe6vNgalQ0UZGJd9mOEL4ydn7ecMX0?=
 =?us-ascii?Q?wr36mCXiHXYn4f6ebnHtsMYj2m9+YxU/IgtQTws2up+4yO9C1yyAmJmSNieT?=
 =?us-ascii?Q?lf4R9cWpQT95j+PZ8j/qNy3rV8Md6gMS4/S13RULgfHMaQVZQQtP0zRz9mse?=
 =?us-ascii?Q?YeocrP/0ioUgMSyDA+2ELXsc0+JMGJYznc4cfQD74gmrRDa0BKOYrPXqfUuv?=
 =?us-ascii?Q?LG1M4yVq1eK1ZUkyftr1fXZPybPjj76I08+NabYZ/3aBAvs12HQVseu3MotR?=
 =?us-ascii?Q?Y8p200sfPcDi/FKaEH0tEi0Z+tSqCSBeOmVHtE112rfkstpfrYUNqTxmyd8m?=
 =?us-ascii?Q?smozUTk+1/KLjR6y6kLviKoTXmcci9RF9PmdGiav6WZp1GbRqhgzec/W56R3?=
 =?us-ascii?Q?mkPWZ+BZsL1edf0f3pBj3hELvVYNKjlJvmFEK57V0/pTPSnPTQvCNjNwtgp6?=
 =?us-ascii?Q?z2btE0Hku/Dv9mRm2nQPkATb0oC2409YeqCpN0REtaxFQ0KusK0L78KtY7Q+?=
 =?us-ascii?Q?2nYFfqu0ZFuz1zVaAWpXj+JPM+lZA7KoSIDoPKGaPx8cgLqWA5Xgtv19syrj?=
 =?us-ascii?Q?7HG1uJfaH3GOS1SqqSUJ+uZ4mLn1mD/MtvHsvdNZmAxm/TRMws3SVGU4YY6J?=
 =?us-ascii?Q?4+cPYNmfqsorIV/aRK9ORSIxypXulxeMns+CVWHRgx+EMj/YP9DLGxyHE9Vf?=
 =?us-ascii?Q?q3rO8HvOUPKsMxas52R4LonOjzzIYRIj5kpZcUAfY9YzJxaTSrHE7S9AR0lX?=
 =?us-ascii?Q?h18Z7WCUVNkwM8hs94PT6YWFdMJTFJSdLdT5rFwgRLK1QdZJUKA8YWA/Wdmq?=
 =?us-ascii?Q?iEDdzIkhxWRAN/mp9BlmeYrngH8sH9Oo+q8XbmjJ+rH+cWpwuotx6CDkeaQR?=
 =?us-ascii?Q?UDj709OkVtZoCL40wynrJv+Vg8JfGRMGiRoYsoMrQ6QDFU72lv32Y5XwSXQ+?=
 =?us-ascii?Q?/zB/V2gVbqZlUlFr+KDtNuxKMZENxPN6CpiaWxJAJzleVAilNQhQXmOkboXb?=
 =?us-ascii?Q?VV+mD0GDVxDwjOUF5tZFsqhing5wkwqhnoKLPY9RbEDtFWK0Shmqu7OHiAOp?=
 =?us-ascii?Q?Hyp3Rd6ApgexxfiB7t5fzOW6WO1eJKzyShSIEBiAtLm5lyH70Z05Gv599K1X?=
 =?us-ascii?Q?QrUYWhEin5KFJ/YUJL33ODWjDtIj8dp+aiCXHrIb/AmlOMqMDeyUJ5FU+W4j?=
 =?us-ascii?Q?wg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564e4396-981f-4a7c-c613-08db00cc145d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:51.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qOH4NXacALzAoDJfYoXCNHk2HawmGFo55NaAjGDgOKlnQPzEjZXVKi1FBhX5X6jJHiNguY/ahBfs4XamHtrHg==
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

Currently taprio iterates over child qdiscs in increasing order of TXQ
index, therefore giving higher xmit priority to TXQ 0 and lower to TXQ N.

However, to the best of my understanding, we should prioritize based on
the traffic class, so we should really dequeue starting with the highest
traffic class and going down from there. We get to the TXQ using the
tc_to_txq[] netdev property.

TXQs within the same TC have the same (strict) priority, so we should
pick from them as fairly as we can. Implement something very similar to
q->curband from multiq_dequeue().

Something tells me Vinicius won't like the way in which this patch
interacts with TXTIME_ASSIST_IS_ENABLED(q->flags) and NICs where TXQ 0
really has higher priority than TXQ 1....

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 49 +++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 30741b950b46..7dbb09b87bc5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -78,6 +78,7 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	int cur_txq[TC_MAX_QUEUE];
 	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
 	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
@@ -515,13 +516,10 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 					       u32 gate_mask)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
 	struct Qdisc *child = q->qdiscs[txq];
 	struct sk_buff *skb;
 	ktime_t guard;
-	int prio;
 	int len;
-	u8 tc;
 
 	if (unlikely(!child))
 		return NULL;
@@ -533,12 +531,6 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	if (!skb)
 		return NULL;
 
-	prio = skb->priority;
-	tc = netdev_get_prio_tc_map(dev, prio);
-
-	if (!(gate_mask & BIT(tc)))
-		return NULL;
-
 	len = qdisc_pkt_len(skb);
 	guard = ktime_add_ns(taprio_get_time(q), length_to_duration(q, len));
 
@@ -566,6 +558,16 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	return skb;
 }
 
+static void taprio_next_tc_txq(struct net_device *dev, int tc, int *txq)
+{
+	int offset = dev->tc_to_txq[tc].offset;
+	int count = dev->tc_to_txq[tc].count;
+
+	(*txq)++;
+	if (*txq == offset + count)
+		*txq = offset;
+}
+
 /* Will not be called in the full offload case, since the TX queues are
  * attached to the Qdisc created using qdisc_create_dflt()
  */
@@ -573,10 +575,11 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	int num_tc = netdev_get_num_tc(dev);
 	struct sk_buff *skb = NULL;
 	struct sched_entry *entry;
 	u32 gate_mask;
-	int i;
+	int tc;
 
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
@@ -590,10 +593,24 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	if (!gate_mask)
 		goto done;
 
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
-		if (skb)
-			goto done;
+	for (tc = num_tc - 1; tc >= 0; tc--) {
+		int first_txq = q->cur_txq[tc];
+
+		if (!(gate_mask & BIT(tc)))
+			continue;
+
+		/* Select among TXQs belonging to the same TC
+		 * using round robin
+		 */
+		do {
+			skb = taprio_dequeue_from_txq(sch, q->cur_txq[tc],
+						      entry, gate_mask);
+
+			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
+
+			if (skb)
+				goto done;
+		} while (q->cur_txq[tc] != first_txq);
 	}
 
 done:
@@ -1588,10 +1605,12 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
 		if (err)
 			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
+		for (i = 0; i < mqprio->num_tc; i++) {
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
 					    mqprio->offset[i]);
+			q->cur_txq[i] = mqprio->offset[i];
+		}
 
 		/* Always use supplied priority mappings */
 		for (i = 0; i <= TC_BITMASK; i++)
-- 
2.34.1

