Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12705B8BE3
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiINPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiINPdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:32 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D390048CAB;
        Wed, 14 Sep 2022 08:33:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a43AXo6QwtxTKroNPO6LORG9Mr61A85cNFMFHUS6VA+B9v6buIIw1mYzbk2h2V+3W/Fk938VD8TaXM7WrYdOWRvwXeJUO+wCU5zDm5v0XcVPUiSZStUeQbymHbEv7BPngDjO9sYSb3Vrv+Eq0axgqCAnZ0PiGHD2e1zKyBrj1UKJOckALujWVk6xoxur0EQZCFzi8BkL3NfScwIKsWMPTnSJLWaQYpeW5nnD5sflDkSOcl8/PnODTbreY8TmV3gJ50SLh24VvBTmvi1q8a2sUVVMkWWMwZ3NFlrRzvmFS6BGPAh+XQHFLCf7tVxxnz/yaQUkr+FK6AnxiWyEKGB0ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMFm3xsYutYgfDjln+tMhvPVKymV8/hLvpohHGGAHAw=;
 b=nKGUsCm1haVnTzzrTDFs71xCmVrR+5svYhfg0xixApmC+Wq/N1zKew3rW5RN0i4G0QCD7B/Ef9hfWZkh1uoY7FwMRgkqxjYOBYjK7yoEHGdmVxRfIwL0AIYFmNOygmYBctFLMLkbZS4fPJEuIUpdGcHlNfn3bWd1PM9qgsBe0+bFtzIidSLfaDRkHjkgDoOmEU/KMAy1WSdKqnOAoBTu5UBC6APHmMmqPLqkX0eYJoip8Tk/grcohr4Q/SsDYP7PGEqiaJYDB83usujlRB+9Rxmhzsj+KtVAlwWzSm2vmSOgWeOjMwvy2B0Kk60oj67jTMKNPAPtqprZ1JwPDzzztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMFm3xsYutYgfDjln+tMhvPVKymV8/hLvpohHGGAHAw=;
 b=pJ47g+7pDYooIJgRLSExcUEl3Sdcypl3ISHVOdrBBA2tJ0CeLfYIi5xq201GSuyDVV73mI0CO0r6v7udjn0e748I7KxZj09FVAX6bOnbE/NdI7dw92uEZ7tk6vGb7hdYxYIkhC9Z4Xj6VMPqsYh+a8KnqL3VyDSwTz+XqJKrKzk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/13] net/sched: taprio: stop going through private ops for dequeue and peek
Date:   Wed, 14 Sep 2022 18:32:52 +0300
Message-Id: <20220914153303.1792444-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: aa015005-a344-49e1-beab-08da966678a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: khG2ZerjYFMdRo8mL+wzLVvMJDdxiUTxl/c70jEKhf4lLy5FF82y25VNzbe48e+1JNoH3LdpNyOH0EKjG/2gphXjiReNV6SU/RoseuZHwek43dTk0yT5DjhecGdnmAaoYrH2dvPNBz1kivoAF8R7yUM01LHdFrn7Se9IsL6tbJaTdfKpggQv9I4HcNFsbLFp0/WOXocsj3vdJvHYBbFCkUkyHG9BhOiEIlyt5HVgGA0qml6vGju7OIQ19mXZ+vv3YWuOdchdNf1T7VMJ6CicSqQNG9l9Wvo8SutdzYXZNBN9c8F/JHfGvUdKL/TJKeglF6aMn5/6BrUUr94RnTgiZ1c5S6IWXXdZJLK+YYUcfdpXewQb1WcMEw2ggl4Fvsvjr4VKMo40Gpn+D3mJjzctwAnQc4KiloHUe48QNvskMOguWNu1X6qJlObAydnttVq1A3rzbBXan89+N4W+UuEvYSO68+R2bDvg31r1mN5v2WPlZ1y9lPKYAsZb4p8fsXm5SOxLM/bcHbumrjtXAvDIw6nPm2B8oTQ+lzPMFeR/J+vTVg8zUcrNOY5R5bxa3ELJ8zpiBCVs6OIJIFEG01zaIglQ467LfTut0oTPjg/zSaKI7kI6nNYJa56vzC5huMBToocxCiVnpuJxRtgy6LD5bCf5uGwy9pTOjQGcynMVnMUhZHZcJu4Y2UUcMPXHFOcozKPbdsJ78pTZuQ8h6RrZDYzPwe0yytAkYeztjmAoBn35DlQoxIf6c8Xv2gYAtG7FUI3h5ZyByi9AocnL9qG6Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RW53V8WgBmbiLqSWhpODjwJya7NhR/ADHGgCNccdIiOSojMB1hNtM1C/BOIT?=
 =?us-ascii?Q?KS1wxuvamC0PjC4HaVFYE+e5VOecbAXxrSUKI9VnuJOMsTwt7XaKQM55SMcz?=
 =?us-ascii?Q?Q5PalYTUBkOdxj6kNAT/xQWJ/6QPo2vFvNikenJyoSONjsXH/7XDYCX/rUwG?=
 =?us-ascii?Q?6YUnFNJqWhjSCMWzWfQogOl6zV8jxUyIEX7lZo22OyFYH374umqFkRO3UBGR?=
 =?us-ascii?Q?re1ESKLLoPsKZu1693FV1qriQeKV0cuhRoVUcUteXihzpt4JCEm2TAvBHBBE?=
 =?us-ascii?Q?kSsx4MF+j6A4ur7A41WzjXbzfkjGJuAR+XfqonfwLvSpBvFfpCEvMHv5mfV8?=
 =?us-ascii?Q?xEIRLnoCBau0Q7LE5wdssk1rHFPAnQ5VzvbBnSSYBgYzjQz++BdSkQnFm2Mw?=
 =?us-ascii?Q?hoZvWyQlf4ayQfmLVmtQqJ0hVOyBIJ/A+DD/mwyRMsKBbR1wJ24ziVGJVDQY?=
 =?us-ascii?Q?Od3aEbsCcxsfa+AiMM4Z8q7YIX/tuYfUzHLLH5ObMLss/wP2iRyyk1fRFtjr?=
 =?us-ascii?Q?Yvrhzh7R5tSxA4YF6R90ipSYAo5JMEEuWx8noQjucEnqiWRW+E8dLQ5LG9qK?=
 =?us-ascii?Q?PHWHcUmL0lUjggcu8/1VfTeEhmEN/SuYpe/GHtmd7nSR7elWC0p1N+U4TT3G?=
 =?us-ascii?Q?iY8ycZWEckmEZy2LcwjUQCzGHHknikZRWSpnT8UcJaQ4JL3Y9hsydFVC1vp4?=
 =?us-ascii?Q?NJJn1skUPs/SoKBlv+bVMirEJaSTCxVVFuVnMDD9eBuD7CAhdbgUDxm37B0S?=
 =?us-ascii?Q?MkIm2Jlcshak3w0uRjA9N6DyEM0iPK7o/ToQ0EmWE+LT/laEzL7HTboxAlOy?=
 =?us-ascii?Q?LjvH9SM0j9/d0wuWxk1I1tFZy2DjfOgX2igSs3yQBXvMFp8qj2RZ/qKp5OEV?=
 =?us-ascii?Q?yeiZFvQr2YJoqdhZws+5yzigmSI+fafWNAVnF4v/pX527ugGFjd5L3YhItiP?=
 =?us-ascii?Q?0bD2nAaXXXheuB3fh2DlxCWUwkO2E4bR38sHdJdCDMKHIPJN4jN8WxygRmI5?=
 =?us-ascii?Q?4xMcoONr0KlcfmsbVOIqYuMSqfT2QSnxi08RUrBBIAUwXN3I4IwvgCka6EQr?=
 =?us-ascii?Q?2jOiG160lrP1vlxJZFoh4ZHdRRkOPMzDe9jAUPOJLTG/3LBI0tSbNL9pfHGS?=
 =?us-ascii?Q?w7DiaeTZAGLNiAXQHyldS990iiQQjuYc4sXVvBgGg7fDeY+D2WtGPyoolgdV?=
 =?us-ascii?Q?UXaqra9OlKppZlo+tE6mJJBvoRKtPDBPIFN6l4xBdOW8dc2X6rYGLG0U5bD7?=
 =?us-ascii?Q?8MBOGE/xqS1GUmVYaJckCLyae866ij2cNv01XV83oobSRPrTSwwMhxcfVqNp?=
 =?us-ascii?Q?afqGPUAmXnddyHsr64v2ZAP6Q8rHBgcucIFnu9VaGpVfdyX2os7Mmrwu+jUY?=
 =?us-ascii?Q?7xg+r0lSrSpg7cb5vpXAdQSEKrGDg83UE/YLing3vNZYnlx8x7dmDBxwjEI2?=
 =?us-ascii?Q?fOOjuEgCmv2FTx4aPhxBOUNaWd/GkZZiJ0Wn4fIx1jLSuEzKyfMpRIyWprfZ?=
 =?us-ascii?Q?DdBBnq7bbtCZf3QItzBCbX9kaUeilv1dVm/JW4F5usfz9I6p2JoKHmqJYs9U?=
 =?us-ascii?Q?scOuGVyoiKO4Mo8a8OtGLGGTWvvoYZG76lEk3i68zOtJJIEnzxa9gkzX7Vd+?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa015005-a344-49e1-beab-08da966678a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:28.3870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01TLLxxTg7WOHVnj493uj4cOmT9UFH651hYcfRTKJRchiPAF1d7ho2GWSXZcEgzkMKEXL5iVUjHi0L+jiGN0TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 net/sched/sch_taprio.c | 58 +++++++++---------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a172c1eba995..226aa6efb365 100644
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
@@ -1565,17 +1545,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1694,9 +1663,6 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
-	q->dequeue = taprio_dequeue_soft;
-	q->peek = taprio_peek_soft;
-
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
-- 
2.34.1

