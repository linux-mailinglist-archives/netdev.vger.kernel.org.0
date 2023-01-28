Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB10067F383
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjA1BIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbjA1BIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:12 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D8E790AB
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g49neMMbqVIg4FNwfW5MSEidTtK4ecA8MUBkk/Z1R2SgPUNlbzC7LOFOdDDRR71k5+3gu8z7GmLxbtZcuWP3lnGnkRxItCJ+ytAVoZkHlT2O1JUAo16LcPMOCHHDHVg2FV556Y3Ulp5VXHWXVh7h1/1qVrfp7IDtgZ0y4JdwDldpVitsqlhV1mgkvwX4AeGsZvCxaRQszz996qDHB6/vvJcnp2S7j720ffixm4cQJGfEN11CoOkQhBT5+7PybygalP8LtCdUpRUa9eIjZSBZpHHQoU+31+R+EWhk4mTN2+pPsrkRdZjEqGVmxH2AKf7xavAEGgcoSsPmGTHrKPs1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ouHCHEy9RBErJLlFIjE/V+7sb5no2Et9ZIXCselWNTw=;
 b=Sxj/srQJZKGveRlxJClIXbBvokzirkETTwHedbd1elgu2xHepUa/AnxLMzqtPR58TU4tFd4+/kknrTKUPX6klG9rvtkhDoVZ2hWnbvEKMKlqnOi5CmwLKv408MMEliqGbQw6ZT0VnKio6rAKFLhHGYHdyqpgZfVJNkgOXVhZeSC9yp4Vu+iUIS2d+mHqgLdKIVk2ojO5it0n0Bz8THrphfFGvVhvw5ef8SDgDNa+44Si+WuY6Y8+nUqDLpssPM20EBCwqC8MhY8KMlxbZp8S3uly18iXM2UJngYoUnlV8eLusuXSSHzwZHimtyf9a2AQnCgetMFUEbMuGp2XGgOp2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouHCHEy9RBErJLlFIjE/V+7sb5no2Et9ZIXCselWNTw=;
 b=ST6yGKQF/k1Pa83gotKrxRUs7RHc6hxRVWMVKCUElBJm9hbUaJP/GnpDbau0zpF5z4hyf/rMJIInKhE1hOKioMVRDANY5/YOB9WYBqq5km6WWJ8J3CtroPn2ZEFJpMlwOw6UftZAgfSxt8QgnX0BbRmJ9wvrSxn8114nJva4U3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 15/15] net/sched: taprio: don't segment unnecessarily
Date:   Sat, 28 Jan 2023 03:07:19 +0200
Message-Id: <20230128010719.2182346-16-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2193cbe3-a205-439c-66c8-08db00cc17ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uHJEaq+t5GcYLCbjPEtyK7naSdbZF8e53gZltghAJEizhuSP05KLMqtW7t9iLLTWoBz3WHy5WxD8Hu5aGhHWgk3T0V9Q4Z0e/35Le/oGYFvj/M6pz8TjHVY954TYEQno04waqopdS24bJJqy8vpCgaBl1EmN9RVTSSuAKkltqRIovCvbm3QMl2lb62BzgHe6VNoD7OMun+Gqt+4wXb4bqoOzW3jwOopjxKmJ2hFmhFsQ5Qj3BFOot6/hbciNY39kUR1D/ZS/15X8vA76lNb1YA4nUEE9ZD+Z0j7C8JTijTrjXCqRF2rr+DUYS1BXHrbB+0cLOiaXPsUjbO2yQdnQMN5tX02bbrPcjTzsD+5yu4PHHa5UMWzcpa7TqFT7K9gdZXFk6ThftuEebUDzczUs9TOMcav2fGk4cOd9jxg3smS4D8G4sufVqrAYVI9fsvu2xDW1HjhiHjuFP5LCRORqn4V1Y6tCocAea6SLN/CzT/lVdx2Tn+Z5S68Aeh1+lzEv7jlYlp320CPbVEzMIFijrKAopeZlmn3Mz8WOWos50wE47JMQipfD+1XMEeLb4bAFuKtNPbsOvZLIEfZ14gMm8HtvnIbzGqVIa1ISg5y8xEPUT7Sas5V1NJookzrjrnCdsghB76nTtBR0dJ7U9iHzzhBXZitt1FqdNgobTvjNWnVaStr7W0izfHVRkDDt3GmFIyC3wMYrib1ds4xio91HFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mtsV7Fe9iXoXkNVLJ6SOudnbY/aqp/W08Hv7EayFmeW8fYCvDuzwkc/Uor1L?=
 =?us-ascii?Q?3n3OosOXYUKVNvp2D9EhAeJKczGFYXcyCzs0ca5735LaOSGHfLjc5AHkfmEJ?=
 =?us-ascii?Q?DazRd4y0yn6F8oWsfEU55JC9MblzV9W85A9GZY3dOtI9NlTIumOYlKstZM6S?=
 =?us-ascii?Q?aBPYygjP/CBp/lg3nOQGelrdKOVl5N9lzspXS0p/v2rbloh1Bp7aXtBRiJrb?=
 =?us-ascii?Q?Z/iO0iYQBnNCaERWzGwIKe39Jd0AXtoG9UXTU1/oKljAhmA+AQAb2nk3dyQR?=
 =?us-ascii?Q?zmDlQNf5lRQiUAhDSX+yZhgggeyZVNWcxQK/cpBhC82iaQscP6MVwyO5h1hP?=
 =?us-ascii?Q?d00ialj/QP+SqDMkMTbC3qaJ4LNGoXL9hcgGeCwdJ+POLqIsVVbI8GfvCRYs?=
 =?us-ascii?Q?yWxE4lv1BNjlDG2ULUeYfTmyFzvOZgcN3pLN/KG0p9KZXRvJHRGuZDSW4B9t?=
 =?us-ascii?Q?b7UKkDcb99ah3CfkzkjVz+aD0WZpo65LnIa0rPAbOn81dcjhcnyQ8UJ2Kn0x?=
 =?us-ascii?Q?bfPKIZicP/N9nRwxx2mvAxWtYnsS+BjlVxUWg8fMkqWrTGTe8kZfvO6r0xqZ?=
 =?us-ascii?Q?x5kmoXYC2imVvRSg8W7u+F1jzcipCGVpDbWkmvTI6dzWXbLW1vhEuCBGJULN?=
 =?us-ascii?Q?rGY5EUi+0rWoeHfAguJmUihM20IOcSOK1fmUqhkey6kHP5ZavPzz5QK+nulZ?=
 =?us-ascii?Q?2BhFOjKdolzxQXqGFeMx6ibvuUl+ea5BpUu/uMWhI/L3Vsfh5wZeHfycXkLq?=
 =?us-ascii?Q?POyFJhJWGUmvBioiBVtTBR5n7iPiZXVkmWQXjGE8Bm7w8oE1ioBJKnzC4k07?=
 =?us-ascii?Q?csIHTNTar3cEyj7TASXTCEOA7+1qUASNMDiQU0yu4GqAoL/JVrK1SvEEK71a?=
 =?us-ascii?Q?Tc6E+H+2WZkczyoe9HrFGDtFwWv2LxV1BofF/6oXk3A6IBi8+XodFaBH8lwi?=
 =?us-ascii?Q?oGNsdMHWlA8LEEzF+9PM64hAOUI2synDA4NI0H66ro2CXhhRoSMbTrG+puPr?=
 =?us-ascii?Q?65KMDv1z0Oq2t8ggYea1xP9v1c9Ma2wpTAm4PJ/gEM2oJq12fKKZNr2/ClBU?=
 =?us-ascii?Q?38XWJ8C6NNeYlZPbe5Bu79Ou3ih7Xo/lPRByVPKghnnOJYC0i7My79YMRQee?=
 =?us-ascii?Q?dNBVnzjy/+wRl0fCRauxXzBVYZAuKOY4XUZ7lMas7MgMeSv2k1a5L7E2TPj1?=
 =?us-ascii?Q?yFAXhiqd1GZenpvSF1M062lyEzBIa+As2EIz1NqwBB5/SDm8ntoxvuUIoWp3?=
 =?us-ascii?Q?k45iE2RdtkXhGGAoFks1fcJSR4XBPLDTYBGIaMSbZkI3XArtbWoTpF/nmPQl?=
 =?us-ascii?Q?Tdice9W6YKnyhfkOwpCjQQOKircLqiN1XiAZfxgciiABsVSiIqZpA8nH3C72?=
 =?us-ascii?Q?o5RUXxPUR02gXZLpXpPpIGLnrOPaIrQtc+dqd3Ke07C9zWMc8u9g8WetLnlr?=
 =?us-ascii?Q?C7sqvzK8tiWnhiI3FrenesyHq5NMFYt7PBuvWj0VaznW54oJGH29xKYon1ww?=
 =?us-ascii?Q?5EEJRN14bCAOjexYJCWYY17juyvks7bBo8aD0WwmuWMNOSi+mPldRSF2Ylpk?=
 =?us-ascii?Q?Sx1fNioO8K9TkLVnMKujX+nK9dbTdM1ETfvHiRZLscGW/1yMs5oL2gHd5jOU?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2193cbe3-a205-439c-66c8-08db00cc17ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:57.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MA4bMw4W9yCFy871/4qp2dQxBK2U7wZjPXqStiSKNK/Q43SY5fD45dVPk4/k8DJNHsC10Dqf6rTLKup4gxmRA==
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

Improve commit 497cc00224cf ("taprio: Handle short intervals and large
packets") to only perform segmentation when skb->len exceeds what
taprio_dequeue() expects.

In practice, this will make the biggest difference when a traffic class
gate is always open in the schedule. This is because the max_frm_len
will be U32_MAX, and such large skb->len values as Kurt reported will be
sent just fine unsegmented.

What I don't seem to know how to handle is how to make sure that the
segmented skbs themselves are smaller than the maximum frame size given
by the current queueMaxSDU[tc]. Nonetheless, we still need to drop
those, otherwise the Qdisc will hang.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 67 ++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index cc11787dc62a..e0bd613a6415 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -527,10 +527,6 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	struct sched_gate_list *sched;
-	int prio = skb->priority;
-	u8 tc;
 
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
@@ -542,17 +538,6 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			return qdisc_drop(skb, sch, to_free);
 	}
 
-	/* Devices with full offload are expected to honor this in hardware */
-	tc = netdev_get_prio_tc_map(dev, prio);
-
-	rcu_read_lock();
-	sched = rcu_dereference(q->oper_sched);
-	if (sched && skb->len > sched->max_frm_len[tc]) {
-		rcu_read_unlock();
-		return qdisc_drop(skb, sch, to_free);
-	}
-	rcu_read_unlock();
-
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -565,19 +550,34 @@ static int taprio_enqueue_segmented(struct sk_buff *skb, struct Qdisc *sch,
 {
 	unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
 	netdev_features_t features = netif_skb_features(skb);
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *sched;
 	struct sk_buff *segs, *nskb;
-	int ret;
+	int tc, ret;
+
+	tc = netdev_get_prio_tc_map(dev, skb->priority);
 
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 	if (IS_ERR_OR_NULL(segs))
 		return qdisc_drop(skb, sch, to_free);
 
+	rcu_read_lock();
+	sched = rcu_dereference(q->oper_sched);
+
 	skb_list_walk_safe(segs, segs, nskb) {
 		skb_mark_not_on_list(segs);
 		qdisc_skb_cb(segs)->pkt_len = segs->len;
 		slen += segs->len;
 
-		ret = taprio_enqueue_one(segs, sch, child, to_free);
+		/* FIXME: we should be segmenting to a smaller size
+		 * rather than dropping these
+		 */
+		if (sched && skb->len > sched->max_frm_len[tc])
+			ret = qdisc_drop(segs, sch, to_free);
+		else
+			ret = taprio_enqueue_one(segs, sch, child, to_free);
+
 		if (ret != NET_XMIT_SUCCESS) {
 			if (net_xmit_drop_count(ret))
 				qdisc_qstats_drop(sch);
@@ -586,6 +586,8 @@ static int taprio_enqueue_segmented(struct sk_buff *skb, struct Qdisc *sch,
 		}
 	}
 
+	rcu_read_unlock();
+
 	if (numsegs > 1)
 		qdisc_tree_reduce_backlog(sch, 1 - numsegs, len - slen);
 	consume_skb(skb);
@@ -600,8 +602,11 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *sched;
+	int prio = skb->priority;
 	struct Qdisc *child;
-	int queue;
+	int tc, queue;
 
 	queue = skb_get_queue_mapping(skb);
 
@@ -609,13 +614,25 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (unlikely(!child))
 		return qdisc_drop(skb, sch, to_free);
 
-	/* Large packets might not be transmitted when the transmission duration
-	 * exceeds any configured interval. Therefore, segment the skb into
-	 * smaller chunks. Drivers with full offload are expected to handle
-	 * this in hardware.
-	 */
-	if (skb_is_gso(skb))
-		return taprio_enqueue_segmented(skb, sch, child, to_free);
+	/* Devices with full offload are expected to honor this in hardware */
+	tc = netdev_get_prio_tc_map(dev, prio);
+
+	rcu_read_lock();
+	sched = rcu_dereference(q->oper_sched);
+	if (sched && skb->len > sched->max_frm_len[tc]) {
+		rcu_read_unlock();
+		/* Large packets might not be transmitted when the transmission duration
+		 * exceeds any configured interval. Therefore, segment the skb into
+		 * smaller chunks. Drivers with full offload are expected to handle
+		 * this in hardware.
+		 */
+		if (skb_is_gso(skb))
+			return taprio_enqueue_segmented(skb, sch, child,
+							to_free);
+
+		return qdisc_drop(skb, sch, to_free);
+	}
+	rcu_read_unlock();
 
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
-- 
2.34.1

