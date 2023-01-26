Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE8667D402
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbjAZSX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjAZSXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:23:25 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2049.outbound.protection.outlook.com [40.107.14.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF3465EDB
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:23:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMzyv5xO0svuSf/U3ZgkEhr1L8sQb1vFudXHnj22FdMiLdQJVenLU/QUPi0yCFWntryNFcjmWZ8XXnBCVBBDZcauQo2mO5odQkY7KDx8mr7Ndvfi82cR4WUTzmuR6rA2ebzlHb8NP3HJtvpkQqMdXpqH8q+CRdZOaI98IpqTjOxsRTcPT6OlrY3C6RLLgBbPxmIY+JhMIf/ATqu2YiW9VHJOwj5fQNwB/V+BfXG7PLY2nvfa6TENj6UCXJj6dfHDwjxGr20Bp6yM8M/i4/syhIAznpQ/qxomtajUvwYWOzBXnpNOX2Rd1n1FcoaKhe2xppmAFzq754DzX78Ylo98wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrHHlW1Mq18VoW4+KIpHjKJ7vJBbfE8MrimIi/ffmTw=;
 b=cTEC2TiETeUNzsqn+LH3wJQ0xwwoCL0MHXtDwEeL/FcptXs9JkaJCHgZhAlDEt+X2aOd35SfftyFjTdSzXXQ3B52Q//lNcnQ8GIbv9kJGVMVGZToMky5euNLyw7hh1m92NBIEwus1wwfPC5/Xhlx4IYP5a6Z1QdcVN5pPzgcaJQqFmWo6QrEGgMpN1W4lxt/eQlLoqs5Y5TBmodc8YdqzlJLOVPqhR2VObWBbFrsH2JTEEXwrqJXZSzZ1yjHUQplZUpLGv9KueEG5AMsW4On+8Sxn36Z6dSz/TfjrxoHLu1dU0TGD7CPq0B3bbKyg+ZUXk/8UmMjh4pldrXinjzmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrHHlW1Mq18VoW4+KIpHjKJ7vJBbfE8MrimIi/ffmTw=;
 b=aVnQNrpowbkzB4TdpNZKsNF81uJvv3RI/wyl+9pxwUM74GsKKYPNJVf5HvlzNXm3fEloTb8dZlaYakjGCSWttNCO59ilp0Llcc8viSRyjMXcIaphx09HrlUCzw/o3HuJT/7SAvtv+Q6r78S5psQCN3lXg6LX6UM4xC15MVte8oI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7963.eurprd04.prod.outlook.com (2603:10a6:10:1e1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 18:23:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 18:23:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [RFC PATCH net-next] net/sched: taprio: give higher priority to higher TCs in software dequeue mode
Date:   Thu, 26 Jan 2023 20:23:02 +0200
Message-Id: <20230126182302.197763-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBBPR04MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: f52de773-51ea-4fdc-d4b0-08daffca64e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2bjziXg/os0xgAooR0JbVyuEjTsKo7EdeCBcj6JHOSGFYAMIiUvZzL16SR7er6t//R7nh/WzOkY4+/an1RBW88w1GtsrZucnTrEVoL9IUpvawdEGQsC45HH2fgGgdnF2dgbOjLKE/u8jjMJb3tsRIymyG7QqiQWwfWLN7baJwF8mSaMHabnUwUOJWtTeQHIOtbiA0Lvy0mQr1h06lWRWSVz2Xr3qOetoZsxN6fNLpcs2z4NYY9kLIRdK687y4PEXBYqVTCkOMeGex6Y3/Eihz+83HQK4frVhQnhbcIDEGGBjvPsrkDkgY4ppj2aJRxtUX6YC68SYeOmdSXQGA6BtGbdZNvAKbOOlESPk7eFqUx43lAuTpkFTgpb6X4e3ykW68l93VCwftea+ReO3pTNxEHtem4f0VJw1wwIF7I80sFJfbwCVXLIwJPTPtQ0xiG3IURJa30O5CVxI5KdhoNBDR+8bozyO7RlyZal5jGUEHLkBJ5PF4M522Htt01Hs9l1JPPeIZXtNDEwwzJHdlLBLDxb8oUeiC2KQvBXg3fLLi1at++KbHTOSPXtQdoTN07RNLNGjsGwoiPuI8ecMpWUDoiaoNYNB/Do1qN/OilbpnFBllO5hTLfK1yr+/W253/0/l7Uwmstb/h3Uhq00thjgrCpdWomsUlHJI/3l5KVhK/2Z6HNVeqs1wDJR3G07sgGQBPKNkrNIfyI5n8mf7ELqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(44832011)(7416002)(6506007)(5660300002)(2906002)(2616005)(41300700001)(8936002)(36756003)(4326008)(66556008)(6512007)(26005)(66476007)(6916009)(66946007)(186003)(83380400001)(8676002)(86362001)(1076003)(316002)(54906003)(6666004)(38350700002)(38100700002)(52116002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YVrh3b1froUetvSELx81PuIiU3JyxNRJcI6oKSjcXDV7JyibjwXToonrYT+O?=
 =?us-ascii?Q?XzsaC46XRouqmZKbwQqFad4KmuY1+74wAciWLJ1CM6UaMS5GDaaj9oSt711g?=
 =?us-ascii?Q?CR6VGg1X45VXwuxhHcuKu1EFHmSitnxZ9cRpZgkqYwBS3ZnGPleYZaJmzZj8?=
 =?us-ascii?Q?9pDShp8EATxqIv7kxWSH1iME7PUWHQ10AU1DjSttam5WrsqNp3ejFKve+gmM?=
 =?us-ascii?Q?9BVPVmo2BrCfpWyyEafp9xmcEt59rHs4X46H4yF0+m3fYQ7PBIjcEYYUQ4C8?=
 =?us-ascii?Q?fg4ftvb3s+SGhcqDjge/ZLtKsB+KeCPe9xECxxRvpz14TAJq8fktslQZE5qV?=
 =?us-ascii?Q?sadgCkAgrAIvkIgziWjEtESEuE/wIfwwoXz0Zcil5Hh0tGzjXlRpYWYByC2k?=
 =?us-ascii?Q?Kw3dxYc4C0Bj8+itrFYLDrdsNLdJylsm3wDT/xQNTxN9dRF3P46R6oJ4JGmu?=
 =?us-ascii?Q?PJ+pBs2joTvH/X7ixCd9PLFCpX28+sG+02hQ4b14GmO7ToQJepHjozVMfTmr?=
 =?us-ascii?Q?NkWcDqXbed1LR0n7RAGMS/t1Brtjzdt7FcNQLiZQN6Q7hq28yF0waoFvGVAf?=
 =?us-ascii?Q?Yjla3oB8nSdk27EIWWjcU2PqrydyDioPV4nh/uTYYfMjPnY/xgKDDfTt2DpA?=
 =?us-ascii?Q?aG4t8llRFCAHS3KrXOWpygFxYGtmBJDdzLhmvlDECKFdylza6DS26lQocoZs?=
 =?us-ascii?Q?JAv1jodqc42UQ7CMaZY3QIJfL/yyOje4nfPYsrU2AooUCvZ07PF3SZRB1AGI?=
 =?us-ascii?Q?Rc+/Ong3NnZ+hBfIYvJljpxq5453AJp6gZjpmzKMLVhHIHK9UuozZ7BtkY0p?=
 =?us-ascii?Q?EnBZAwoFOlceSY4xDY5QyVGFTCEkqzyv0w7kWJh2cshjcQ50EPMmlQZFuwHC?=
 =?us-ascii?Q?T2SqkTuB8QeDjJeJvpvyWkwulUhFo52ViuWBjDAE47/5iJisdvtSFRnGgz4b?=
 =?us-ascii?Q?N6qpb3nbedWuM5Bv6GWavw4BlOh53tM4LLi5kFjtoAMPC88XxPaaA8ihV10z?=
 =?us-ascii?Q?E90+GyVBx51nmOF4lYUpeGizV+x/keL5Y9Cwhh9FrRJqRqocZfD+KaTmBNeA?=
 =?us-ascii?Q?WkGn9RBoqWRAlwzF68lv2hZsXNggUAjBli4R1fwSMtsumVh4d5SS7z9pIlZS?=
 =?us-ascii?Q?XQbdX7V76IENlyJ/QM11o+pOVIEWqv/ov73A4UqoyymtlsZC5KOptlp1WL3l?=
 =?us-ascii?Q?9apJl7ZgZV8BBJhn4T7zaCMQYtE0+DoeynUW9Bi00iuiTD40KmgGzHY1KqEV?=
 =?us-ascii?Q?mMgMR/NAxyl80PA7Mpn081ZhNswThIjbImvCloa5nl8SXMR/F5OCbBUOayW2?=
 =?us-ascii?Q?OiqR5A8FazvLxXJv11p8YKHvKbLS3PmAgoMXYriIQpJj2vpmWuY7/QYcL/nw?=
 =?us-ascii?Q?MGdG7vQSkWtk38e2N+MizdVNgfr+GsRaHn6LhNyvx7hoqF4EPXA2FHvf2vmj?=
 =?us-ascii?Q?tEyGGNCW/C4X2JVfUgesfgXw69WR7huRMISVl7c9tZ/Ivr9cusL6HdHp9SRB?=
 =?us-ascii?Q?kmd7Y72OzXG5y1nrQ8b8r4Sb+KlkKPJ66xO2yxoTYaJDE7F2HL+V/44K6EGI?=
 =?us-ascii?Q?0ljx2Yl061MHi/NQ0F4euuu24x4aYEIvbxmXQNLcZfEOPO2O/+W9ofTnx8Tr?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52de773-51ea-4fdc-d4b0-08daffca64e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 18:23:17.0550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GLozgLHP4PU+7xu4cQQvO6Pd0UeeRwRdEfkXXtxlXOHBkN/Z/mR2hV/UTN19+Kv+AAy4TiYpmGPLfISRd4rfUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7963
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
q->curband from multiq_dequeue()/multiq_peek().

Something tells me Vinicius won't like the way in which this patch
interacts with TXTIME_ASSIST_IS_ENABLED(q->flags) and NICs where TXQ 0
really has higher priority than TXQ 1....

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Superficially (and quantitatively) tested using the following:

#!/bin/bash

ip netns add ns0
ip link add veth0 numtxqueues 2 numrxqueues 2 type veth peer name veth1
ip link set veth1 netns ns0
ip addr add 192.168.100.1/24 dev veth0 && ip link set veth0 up
ip -n ns0 addr add 192.168.100.2/24 dev veth1 && ip -n ns0 link set veth1 up

tc qdisc replace dev veth0 parent root taprio \
	num_tc 2 \
	map 0 1 \
	queues 1@0 1@1 \
	base-time 0 \
	sched-entry S 0xff 4000000000 \
	clockid CLOCK_TAI \
	flags 0x0
tc qdisc add dev veth0 clsact
tc filter add dev veth0 egress protocol ipv4 flower \
	ip_proto tcp dst_port 5201 action skbedit priority 1

ip netns exec ns0 iperf3 -s --port 5201 &
ip netns exec ns0 iperf3 -s --port 5202 &
sleep 1
taskset -c 0 iperf3 -c 192.168.100.2 -p 5201 -t 30 --logfile iperf5201.log &
taskset -c 1 iperf3 -c 192.168.100.2 -p 5202 -t 30 --logfile iperf5202.log &
sleep 20
killall iperf3

echo "iperf3 log to port 5201:"
cat iperf5201.log
echo "iperf3 log to port 5202:"
cat iperf5202.log
rm -f iperf5201.log iperf5202.log
tc -d -s filter show dev veth0 egress
tc qdisc del dev veth0 clsact
tc qdisc del dev veth0 root
ip netns del ns0

Before:

5201:
[ ID] Interval           Transfer     Bitrate         Retr
[  6]   0.00-20.12  sec   150 MBytes  62.4 Mbits/sec  457             sender
5202:
[ ID] Interval           Transfer     Bitrate         Retr
[  6]   0.00-20.00  sec   219 MBytes  91.9 Mbits/sec  635             sender

After:

5201:
[ ID] Interval           Transfer     Bitrate         Retr
[  6]   0.00-20.19  sec   198 MBytes  82.2 Mbits/sec  485             sender
5202:
[ ID] Interval           Transfer     Bitrate         Retr
[  6]   0.00-20.16  sec   162 MBytes  67.4 Mbits/sec  437             sender

Posting as RFC because I realize this is a breaking change, and because
I don't really care about software taprio all that much, but I still
don't think that the current code is something to follow.

 net/sched/sch_taprio.c | 51 ++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9a11a499ea2d..392d5f0592a6 100644
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
@@ -497,6 +498,16 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return taprio_enqueue_one(skb, sch, child, to_free);
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
@@ -504,10 +515,11 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry;
 	struct sk_buff *skb;
 	u32 gate_mask;
-	int i;
+	int tc;
 
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
@@ -517,11 +529,16 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	if (!gate_mask)
 		return NULL;
 
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-		int prio;
-		u8 tc;
+	/* Give higher priority to higher traffic classes */
+	for (tc = num_tc - 1; tc >= 0; tc--) {
+		int cur_txq = q->cur_txq[tc];
+		struct Qdisc *child;
 
+		/* Select among TXQs belonging to the same TC
+		 * using round robin
+		 */
+		child = q->qdiscs[cur_txq];
+		taprio_next_tc_txq(dev, tc, &cur_txq);
 		if (unlikely(!child))
 			continue;
 
@@ -532,9 +549,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 		if (TXTIME_ASSIST_IS_ENABLED(q->flags))
 			return skb;
 
-		prio = skb->priority;
-		tc = netdev_get_prio_tc_map(dev, prio);
-
 		if (!(gate_mask & BIT(tc)))
 			continue;
 
@@ -558,10 +572,11 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
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
@@ -575,13 +590,16 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	if (!gate_mask)
 		goto done;
 
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
+	/* Give higher priority to higher traffic classes */
+	for (tc = num_tc - 1; tc >= 0; tc--) {
+		struct Qdisc *child = q->qdiscs[q->cur_txq[tc]];
 		ktime_t guard;
-		int prio;
 		int len;
-		u8 tc;
 
+		/* As opposed to taprio_peek(), now we also advance the
+		 * current TXQ.
+		 */
+		taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
 		if (unlikely(!child))
 			continue;
 
@@ -596,9 +614,6 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		if (!skb)
 			continue;
 
-		prio = skb->priority;
-		tc = netdev_get_prio_tc_map(dev, prio);
-
 		if (!(gate_mask & BIT(tc))) {
 			skb = NULL;
 			continue;
@@ -1605,10 +1620,12 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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

