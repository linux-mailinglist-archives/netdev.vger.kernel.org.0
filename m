Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD6B67F377
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjA1BID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjA1BH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:07:56 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D61F1F929
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVew+vsGcO2XIWGCuVswNguX3S9GUEzwA7JNTs66AyH8qQqzTigxNoAmaVOhIkAPCVx8zKHEO7b4sbtYxdRLw/4QlQHzyQgW22KUQT0+GfgvrZxutQ3qgHwxMf+wM+0mIn4V1cg0HDwNaHJ8benVKZvee2xwcbxhgS7vHO4j03+yGhWrhkulgw3u/iL0mx4sadT5F/JasSv1nGDa0CO5kVxC3NAm+fizgtPsGlGMcjais4zUGBeoyifPVeDVqY4oJFpQZ1bgALt+WmimRONyBUIgXk67iUFjrY2wQU1u24Xgg9ULy7Bnp4V9+q0feO2zl/GAFN884oyC8dipjx0h5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IKFiU2X46zL5lnXxF3I+Af7Rh8KVaWY7k4fcGTg6qI=;
 b=awoC/r47Wa/GK+u0X0i3/wY2iDzRAMSWQgsHl70gItQW302J8EeWRBZri6TJletH28HOv6A5jlcb6kSd2qKaFL8XDwo09Cn7TZvcgmGigyCYhHmJ+B8s/haNZH+mWiHl7CrJwv813m/6R+oopto5DVkRTnld/bx0A5EEWdlqAFA3aannsGBMzQwTRZxcO3oTPG3yhXlaTLPacYlPuK3GtfqWDIXCU2vAUQDQ/M8OA+dENDl9TOzXg1ez29eqjs3a8grxYASoqlbk2hWJFq0lCxKfU1kzTui70MIH0fqeu9UNAzwrnjpC0bNHIOnzqMjIdWzZjkUJhFFzAY/gO3u4RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IKFiU2X46zL5lnXxF3I+Af7Rh8KVaWY7k4fcGTg6qI=;
 b=J2vtOFHVoimVLKI0b23m2df4h4PZ6m5JR7eahBkt64/sTPBPhOHl3lgsCAbAzBFBMSDY33Xt9fa07xdp5lHDrJyrcLLoYb4fTC6lVBF6W1YgILtPp8L0yd0qqULr7+nzLtZqgc4J0B6ByFxH/kCdwsvoe7QkG35z1xjslo7yS70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 03/15] net/sched: taprio: refactor one skb dequeue from TXQ to separate function
Date:   Sat, 28 Jan 2023 03:07:07 +0200
Message-Id: <20230128010719.2182346-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e204eced-9992-4fb0-bda9-08db00cc13af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pQJH3AS0MAiGZ6KnZbmy1ke+9ml7/uCn05gf1+IfCkj62/kATuruPtxo4lePHMPeS08ZXau47AkwG8TG817hX/3w0axjhfGg2gRByEsg/P79k68k0NuKof1xGWAKv8n8CNTCoXHH3tdH29OPddW/c13Ryb1RKCr/dmkez1sKrLKgMjv5anlt2m6DLDwZy1jkMRMsaOYakj78+uGZaXXk/4vlzYeQiEe/HXsLtZuth/UtafNByyRW2jbAtUxRqRy81SDPse/Z/wFXCGClyvloN6EG3VuiLInonwLhg4T4yuK/ywI2+rLxXPS+sN4B9qzCOOroTAZ8fidGV6SQi4xGnoaZILWtX9I+hXfLKac2IAz31twZJZ4mvrdF76PU35izxQ94Ry4H8ykfIDkRf3zgWIF4UzZgOecjaC3UfKhFQ6aeaffpg84SZfRUi9Mlhh6TYBcuThZFsgmnC89W05dvn0Qu7E+IwH6iXaIbT9vgbHEnqVLrZPRn3NMOh8pplFH/aybjmDrfzub5ItzWY02II6UT/cDzHkBuOtD2hBzjt1/s6UdqC9FWxo1IcxAdL3TtzEPvETKK0CPQDPU0Tsi8lmXgTJGSnRebBe/3BphyPAMq4O0DNEL5Fj/rZ2yEJ9vEv/GDJVnu0v/EtpVayKCj+3mmyqrU606qxcpigUNiKcSKO1Ml1ApiiSaqOYaa7UF31RLqjf9mTNueYr6s3sLcOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ya8hVuXxr5Q4YiWHpL78WK3vCQQYXi/93X2IGEuFHzOM2qL+pY2QrMUhlyj6?=
 =?us-ascii?Q?LoaFB/38mte7s6ov/i0/Xwem0lj0tBjrwDvXHpggkPc5gd0b58NfrplBBfXk?=
 =?us-ascii?Q?cArjagZL/rcrtTeOLDmIs0nDHVV8rD0DdDKmK8yiZ1dmYjFRPCRzemtAz+x/?=
 =?us-ascii?Q?hLIKTV4DQEMV4ttaiL9MNhmHORIQsUNv5IpSpKvL9XknM84r/xkj1zhwDQwJ?=
 =?us-ascii?Q?Y3aCJzX4uEGZ1cZlfLnJNL38b1UQuWlTzt65I6lUfHbT+iKlJRhEPnkti1G5?=
 =?us-ascii?Q?9gFOYDEZBf3dhDRyRl942qXg37F2Dn02XoPytmZBEiFgIQFBapzzE6uspgKj?=
 =?us-ascii?Q?vovboH1soQomDuJCTstiS7SIJ/nw4nFrqjUUy2zd9fccVKjKUzlHsKnF6IZP?=
 =?us-ascii?Q?qe1cFhGbq2mhqvvYcpBSUYs7l6xQTxUNkeWF0unKIwQg0flBmepcb4Skvr7d?=
 =?us-ascii?Q?+LSpi+/cfsAdu6YcsMChjAHQgPJoHqKPeqgsv4357+BotDKALDZv4mh5WnkT?=
 =?us-ascii?Q?Kff/th1J6niMhidXqfJsMWCsTHPdoElA9WEezYoxXPTL87QqvcYXvCS0viif?=
 =?us-ascii?Q?ovBld+n4bmoUfRTT+HeWPsKnagdhPhjIXl1MRNfPA0YcflQUBuNWHynaYIv5?=
 =?us-ascii?Q?xDOFL7U8gcicu+b++bzM9Qf9mFT3VvrbOTonRqNY8s2n0oc2txn050VQ0x5p?=
 =?us-ascii?Q?ww5BSEE266xQ4vb3QSqt3nBps6lT821IdRmN7J+XmSBFhMjme811QgKD3Kss?=
 =?us-ascii?Q?hxyVICJ4UXLNV5orMCzyt9TnHjtW7wpcfWiwOqoluE3SmQcAqKT+QaBq6P8z?=
 =?us-ascii?Q?QGIqpJuVdK48wDJbOlShHoUvywoOMx4dJqnlrBd5vFAPEiYqY6Dd8XqW6mxj?=
 =?us-ascii?Q?Wsiup8q+KgdgYcMvM1YgRgxRGyItvtt+hVWIvPf5ib5upMmMHhA+IbW4pEZ4?=
 =?us-ascii?Q?4q8IDnoQdPH4uGs+vszsqR7mGIckktOicwfK4j1iqLQm6/zCMVkDDrsjCqFr?=
 =?us-ascii?Q?/NyUbinXGpPBvEo4mptJrbEZzo/tHOUdzbi9CQHHxx7n/dP2ky5La3MyE31p?=
 =?us-ascii?Q?+CNo8kdlSqjp7MN8pgeYXNyS+DmRvSJ16/HzxZ7hcVnsaqmpeVk1Bg6pX/P7?=
 =?us-ascii?Q?2yECacWbaTwZ99AhyjqQeudFhUaA53YbXNIqRYQa7YxEZ47quiJ9wcsYiqL0?=
 =?us-ascii?Q?2WYrw9szLkJgI3CdVo95dFKJs3d/1MoZXip9vMSKFLP78JBuIXefFdo/nrqk?=
 =?us-ascii?Q?gtl6o341tiWwPoDNuhBMDvdqxPP+2awMUoODi79HTYOhGc/SqTObvzJ48ZvO?=
 =?us-ascii?Q?+ZLZ5LZbqrNr7kMdSp3TP5tuH+tamuszRd2aaOfwQOBR4J+7HTLHb3jyfnr/?=
 =?us-ascii?Q?rCdGOqhl4PxtccErs7F/ojRiGUFnnVOJ2LRbLJjIJsF9amG6URCfdfCcOz8W?=
 =?us-ascii?Q?oEICkIOnXGUut/pouMudZIWOLVqzR2p/AttkE5Wpnggz0mMWUvHUSCfpZa3Y?=
 =?us-ascii?Q?0LlVWuxGFiTS3IGgDRLen99Utbmoc769ln6VFrIqykB7dF8HQoSJhH8boW6e?=
 =?us-ascii?Q?lcXKtZJgZQ3Qrd3eDDbWapjlG92qsS93l/I5y4+cM2P1AbF5doKv8AJ8/IIn?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e204eced-9992-4fb0-bda9-08db00cc13af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:50.8232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2tDi7DnNxgfq7e3dyUHCg32riKNX8wc0LEZ4duyv+jFvcjjtlZrb7oJb3Jfhz4gUlFq+VqxHpsdAjZZTduo3w==
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

Future changes will refactor the TXQ selection procedure, and a lot of
stuff will become messy, the indentation of the bulk of the dequeue
procedure would increase, etc.

Break out the bulk of the function into a new one, which knows the TXQ
(child qdisc) we should perform a dequeue from.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 121 +++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 58 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1504fdae723f..fed8ccc000dc 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -510,6 +510,66 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
+static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
+					       struct sched_entry *entry,
+					       u32 gate_mask)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct Qdisc *child = q->qdiscs[txq];
+	struct sk_buff *skb;
+	ktime_t guard;
+	int prio;
+	int len;
+	u8 tc;
+
+	if (unlikely(!child))
+		return NULL;
+
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
+		skb = child->ops->dequeue(child);
+		if (!skb)
+			return NULL;
+		goto skb_found;
+	}
+
+	skb = child->ops->peek(child);
+	if (!skb)
+		return NULL;
+
+	prio = skb->priority;
+	tc = netdev_get_prio_tc_map(dev, prio);
+
+	if (!(gate_mask & BIT(tc)))
+		return NULL;
+
+	len = qdisc_pkt_len(skb);
+	guard = ktime_add_ns(taprio_get_time(q), length_to_duration(q, len));
+
+	/* In the case that there's no gate entry, there's no
+	 * guard band ...
+	 */
+	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
+	    ktime_after(guard, entry->close_time))
+		return NULL;
+
+	/* ... and no budget. */
+	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
+	    atomic_sub_return(len, &entry->budget) < 0)
+		return NULL;
+
+	skb = child->ops->dequeue(child);
+	if (unlikely(!skb))
+		return NULL;
+
+skb_found:
+	qdisc_bstats_update(sch, skb);
+	qdisc_qstats_backlog_dec(sch, skb);
+	sch->q.qlen--;
+
+	return skb;
+}
+
 /* Will not be called in the full offload case, since the TX queues are
  * attached to the Qdisc created using qdisc_create_dflt()
  */
@@ -535,64 +595,9 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		goto done;
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-		ktime_t guard;
-		int prio;
-		int len;
-		u8 tc;
-
-		if (unlikely(!child))
-			continue;
-
-		if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-			skb = child->ops->dequeue(child);
-			if (!skb)
-				continue;
-			goto skb_found;
-		}
-
-		skb = child->ops->peek(child);
-		if (!skb)
-			continue;
-
-		prio = skb->priority;
-		tc = netdev_get_prio_tc_map(dev, prio);
-
-		if (!(gate_mask & BIT(tc))) {
-			skb = NULL;
-			continue;
-		}
-
-		len = qdisc_pkt_len(skb);
-		guard = ktime_add_ns(taprio_get_time(q),
-				     length_to_duration(q, len));
-
-		/* In the case that there's no gate entry, there's no
-		 * guard band ...
-		 */
-		if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-		    ktime_after(guard, entry->close_time)) {
-			skb = NULL;
-			continue;
-		}
-
-		/* ... and no budget. */
-		if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-		    atomic_sub_return(len, &entry->budget) < 0) {
-			skb = NULL;
-			continue;
-		}
-
-		skb = child->ops->dequeue(child);
-		if (unlikely(!skb))
-			continue;
-
-skb_found:
-		qdisc_bstats_update(sch, skb);
-		qdisc_qstats_backlog_dec(sch, skb);
-		sch->q.qlen--;
-
-		goto done;
+		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
+		if (skb)
+			goto done;
 	}
 
 done:
-- 
2.34.1

