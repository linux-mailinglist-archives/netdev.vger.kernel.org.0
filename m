Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063D15B9923
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiIOKvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiIOKvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06D186C04;
        Thu, 15 Sep 2022 03:51:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWxs2lukLHSP2UId74+e0W5kyHKCJ00SBLMxqYcPalCf0Zha4wy/sqJU2EXkLKi1nAsUsNZ3R71+ztOWulzPDRuzjntmU9EJBYsYzEK8d9cm8kO0vv7BWKqFYyxugdP8BRdQuILsLCxRPUcvU7c3Kienv3EuGYSqNoKAB2+id/sR3kKGCtFv8jQ53zwUDz73KAvd2YS4gmO4b0EztrCkDQh+6xJ0UivIg4EJkpXdCEiPZGR7Om4ZzUJH1/BDOAiNx2VbuRFgLDtTePaglVF3PtyfVLz3TDZ2i4XQeD9quULyWq4L3eHoGvrOdHu0ZhwIPIsb2eI+K7U8t3mlv7s5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+G6TwJq6ioGqqPHMsCklnww6HGHekjKkGFthnYt6AQ=;
 b=NpSMGf4XvxyzOhVP2VqiemjmyUW2gyGvt9Abh/vgaw4+U/qXlCQFs8dWA6TEZmLrr/WqlqrcvfqsBYjB6zwf6ivDUv4gB2vOj/iAY0LK+9ZJvKwQ8bpbiKwlJReRSS8uvW+J/eW2SMDJEQiBTCZD4VLDqz9OLcpW89wah2CsAYtpu7SIS3+O0xGvhZaw/dQZ2CzyXzidRo4Hdp/4TPhE96cBZbf05+nY+jSyxUgNcVgOfDmEgvyBZ4vuaKu0/p0T2/CbaQxDsx9BMBbHNXblSV+BwlDteC8gQgF5/oyZyeyJLYCI5pk2jq55eGXZNL6OX5DKdVhjXxICTBxVJtOumg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+G6TwJq6ioGqqPHMsCklnww6HGHekjKkGFthnYt6AQ=;
 b=LHFU1g8sT0eqG2PtjsUYHNuW1QmN2ARGEwhp7j19IwOpJaonmXwSdrUEFH0cKp+uSuDNo6NofIAQ4UmBnAbKyK8jxil/PhI9NOQWyX6jMWj+KRBu5r2oQpL9vgXjEBgaYp05JAALayiFKTy9X3YUSTOGDArYa+uWHIYQ2COxnb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:51:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:51:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 5/7] net/sched: taprio: stop going through private ops for dequeue and peek
Date:   Thu, 15 Sep 2022 13:50:44 +0300
Message-Id: <20220915105046.2404072-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: dd2e048d-7595-44dd-bbc5-08da97082d8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2BJymnjVv3IRsOcHOFTkCmSJ1jMXxP3IgK85EJWJ8wD8KQHWrujsCTxuuEz7ro8WR64yhFZV1yaT3ZfRMsWoGMlHsH3qN1WCIpJy5p4RKtvYmyTH+RKA/uCYyj/ZPe716qrs/F5I9cBqqoavH0+MON4htWOJmcOXBEOAXLowT/xbf3ttQ57AbQVpef+4BIt7xbQaeZEplLjOnznUAG2doW7yKzqcg8niic14AM2AuCeWQnUSeF0ZqZZPN9S5kAJfgo2KYZnQ7k+7ZB2UZBO0+KHhQA03oSTSXxXmuXAjAfiNC3WwHGiEhdQWYQZeET3TbrJ627V3RbwPw/oKPByY8JFa7RvdimnIYIRg/ko52hxy29MQoCc0Tpl9/DzN1rNibZBzPjY1lhmjbZGLa/08FloB7d5ONe9KqHilR0/wwVuyFW/IE+4y83vNNt82qUjIxX2/xhEnVcqbhQm3BvPenRLTuDwxr7LX3KT098Hovs5gfTEb8NNfrHgt9kI8RtHPYEQLreZopD/ijUQtdIHxzxuiCHuAG1wxhbCE7BK5PXIZ0urAiwJ2arvfVAoxw2c81BXQzIgDEGcQYIv8en5aPfLRfMG8kAQhn9siVj7tk8NDStRSpFHFq7VaSxBlFlKoWEeUP/XEFZQZEJ8nRQl8ku15ogdvXJih2Dgdk0dMbdttjvdNbQTNNnAheHE8zMT4yjUQzod3nhmwhK0tHbpoJBVvW6Zdn1rl/AUw+PmubaoZXn3Kf6ElhzgjdnBey0+oOSkIoakHJBpZnCUGD9oDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gTC7jVQpd6J2in92rtJfi7xWZKi1OQDDevM/5D7TZm3doqofOYSXNpDQxyhM?=
 =?us-ascii?Q?swWwPS0unkpqDz77BEyBVLCc/ui0I0tuIZ9z5KG8p1R2IfaU1Y6DxF+YNYQv?=
 =?us-ascii?Q?qW7bOIshA5LhIe+WUpU+a9tfyrzpdALHMgCck2CCa/nMyJjzrG9nC43bWwFU?=
 =?us-ascii?Q?5IpaXMCUqY33rf+hVoMPoYWLfvF0rJo+ibq7Z+7RNShBbilsJ875hbB1sV96?=
 =?us-ascii?Q?iVgMvtv4p5H/BuLWihOj2AZHSNjhFS40qt/7r8nrQ9sF7XkmEtZfXLRkf9SM?=
 =?us-ascii?Q?57NlZZAT8ktCTtzcuuYi4I4PrKqidF0Mn0Tc9BcagPunj+TyW5FcVl/bWOuV?=
 =?us-ascii?Q?65iVIhyGSzm592AdJg0Sm0maoqQRY1I51EBdS3Gsm0wdoXozzqLcS8dmHi4Q?=
 =?us-ascii?Q?3rWOmqazNvI6q4Xrm2poeThy/CwloHYOxUgHpWG2VFldvwUjKptD7jsFcBsl?=
 =?us-ascii?Q?zx7AkY6y0o74Ry15xY6NCtWb2mAAz6ta0H2BUZ/y/o/zgQn6Y3/zlsnvLCoI?=
 =?us-ascii?Q?14tit1rAiSB/0hl8pw2eun3ttdvQ0tDqs/PHp0ZW0rFG2C9CUONU/VtSY4/P?=
 =?us-ascii?Q?g4JjRrPpCyQjbrtPlQ3G0scJZw6rmNI5Ycy6VkvT6p6Oqxstc74XYx6eUZ6J?=
 =?us-ascii?Q?7LwvsEFxEZscn9yvl2+NLDE9TTjIM1keIe5y4R16mDk3SbyGkFAWz94Leg/q?=
 =?us-ascii?Q?/SA7LJbVEkiWNpuapcdXWEMYCYewaNnXslNOzC7mIcVctpupyLvFQOuBm4Yg?=
 =?us-ascii?Q?GAsqRy1cyZWP5/RvN42DVL1PC+AvecwzERO+YNAXiaW+sl28wXJ5ghU8alac?=
 =?us-ascii?Q?Dmf2deSD1bY3DmPJMfGLMXFfmeLUn5tXBU26tcqu3bQNpjnREzOzAVyWp4kq?=
 =?us-ascii?Q?UdrT47yaRj2kNJhTt9463BPupvcddoy4CJnUtqEqvJEKVMegrU6Kzehu3Edm?=
 =?us-ascii?Q?C5snZbZxevKwVT29u/8WIbWCWsn/CEkZS0IfUL62SZjmq3TxaMsnKb0+slUi?=
 =?us-ascii?Q?/vsx2QgIBDf0t6JFdzXzN+qaPuFdiAfI0+FGS97ffR6FfEm6+Cedvozp7gi3?=
 =?us-ascii?Q?hqe6iBzasMikLaJb8i9utKNY3naM2l/TVcPeco/wzcnJ/V+8hmmaaYaOzb0t?=
 =?us-ascii?Q?/pw2fYh8BUdHB1DeU8jqDVXCCM5eMfeiBa3FY8VtwFCYzUdjZ/6jQSc3NPTn?=
 =?us-ascii?Q?nKW7XcGGKnCaoGchrvtAVZzsUL1vpYvDpgPZE1wHoS4eHnx3jOdLElm8SUJJ?=
 =?us-ascii?Q?XEjyPHT+jXi4iJg5rAR+iPg1bacFcjWsnq68HOYIXnFqAC4Btw8Yoac0ScSk?=
 =?us-ascii?Q?/VHCIu2wbCDF4kyqB0BsBtj46p/K4RbKeewVA0F9T2k3aBAHOSuVN8UvWSMU?=
 =?us-ascii?Q?wPfyDFL14+uVTSCSz1N+2rNh605m80htqVtqYLsQHDkWQN4Ds3iYUT7ed21I?=
 =?us-ascii?Q?XlMSt1+AfNfO549Aiyw3DI9chVd4//CWFfPEGGAkziZO5JD9eY30G4Ake8Wr?=
 =?us-ascii?Q?mN9o467mCRULXbIdMk3wxTN+344s9npd+D5ycKJrehXeGLyAHGmDgO07N1o7?=
 =?us-ascii?Q?qQGXEdTnoBUvhoUNWMl96Cgb0ztpbFMjORvFuAAsBDB0NMNt736tuw+UbHl0?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd2e048d-7595-44dd-bbc5-08da97082d8f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:51:00.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGaDQcjMqzYAXwuUFyIAGalUq0Kt15PAl/DScQHSP+ArRKPkcG1RjDFxEGzaJnYgTzGBosLROk/S1nTEik4m6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 13511704f8d7 ("net: taprio offload: enforce qdisc to netdev
queue mapping"), taprio_dequeue_soft() and taprio_peek_soft() are de
facto the only implementations for Qdisc_ops :: dequeue and Qdisc_ops ::
peek that taprio provides.

This is because in full offload mode, __dev_queue_xmit() will select a
txq->qdisc which is never root taprio qdisc. So if nothing is enqueued
in the root qdisc, it will never be run and nothing will get dequeued
from it.

Therefore, we can remove the private indirection from taprio, and always
point Qdisc_ops :: dequeue to taprio_dequeue_soft (now simply named
taprio_dequeue) and Qdisc_ops :: peek to taprio_peek_soft (now simply
named taprio_peek).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_taprio.c | 58 +++++++++---------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0781fc4a2789..f3eadea101e1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -79,8 +79,6 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
-	struct sk_buff *(*dequeue)(struct Qdisc *sch);
-	struct sk_buff *(*peek)(struct Qdisc *sch);
 	u32 txtime_delay;
 };
 
@@ -492,7 +490,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
 
-static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
+static struct sk_buff *taprio_peek(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -501,6 +499,11 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
+	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
+		WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
+		return NULL;
+	}
+
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
@@ -536,20 +539,6 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 	return NULL;
 }
 
-static struct sk_buff *taprio_peek_offload(struct Qdisc *sch)
-{
-	WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
-
-	return NULL;
-}
-
-static struct sk_buff *taprio_peek(struct Qdisc *sch)
-{
-	struct taprio_sched *q = qdisc_priv(sch);
-
-	return q->peek(sch);
-}
-
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
@@ -557,7 +546,7 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
+static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -566,6 +555,11 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
+	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
+		WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
+		return NULL;
+	}
+
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	/* if there's no entry, it means that the schedule didn't
@@ -645,20 +639,6 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 	return skb;
 }
 
-static struct sk_buff *taprio_dequeue_offload(struct Qdisc *sch)
-{
-	WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
-
-	return NULL;
-}
-
-static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
-{
-	struct taprio_sched *q = qdisc_priv(sch);
-
-	return q->dequeue(sch);
-}
-
 static bool should_restart_cycle(const struct sched_gate_list *oper,
 				 const struct sched_entry *entry)
 {
@@ -1557,17 +1537,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		q->advance_timer.function = advance_sched;
 	}
 
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
-		q->dequeue = taprio_dequeue_offload;
-		q->peek = taprio_peek_offload;
-	} else {
-		/* Be sure to always keep the function pointers
-		 * in a consistent state.
-		 */
-		q->dequeue = taprio_dequeue_soft;
-		q->peek = taprio_peek_soft;
-	}
-
 	err = taprio_get_start_time(sch, new_admin, &start);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
@@ -1682,9 +1651,6 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
-	q->dequeue = taprio_dequeue_soft;
-	q->peek = taprio_peek_soft;
-
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
-- 
2.34.1

