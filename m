Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3468D9F6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjBGN5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjBGN51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:57:27 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2081.outbound.protection.outlook.com [40.107.7.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C9A4C3F;
        Tue,  7 Feb 2023 05:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idXzKj1gfnA3KDyyRQBg3Jq50YQe26YGL7iaa0+EbU4PjwaEdVrCb+0CCjtuopIROYZqIG1TNTsJs++t7n+sbAN7hM3hC6qqiFCxpNGfk4QJUkH2E/8K8UK9Jfn8lrxJLjDeDGZ0flsHPz4xPu+cmo1ebImnflJ4AJnlNhRosb5+FkG4ffwkr/EPmRhsKLHgF4rs7k5yh7ZH1MZ4nfe/vvoviz2b+UUwe17rU0u6Veu92PmR0o5IZvARL6385LAGgKivHedteL9lWHpXJRofD/OUQwcJRRLA676Uh5T/2ZAoxI3UTdkRWeril4iWVTG7GQhGUqXmsz7mFVttNqBv+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyvBdeO4lzfn6LZwQegbDSoHEdK00RUbNjAp8gCQn1E=;
 b=jak3ynTCwAVu09d2Je9bSWEDJlPhOjGY3TB/9E7Nvtx9I+WK7m1/kh8umcc088Y5KA8tUERgu8pVWVcl95+Cj9jyExvE4Bt91pFgMnyNZRKXbGU4HGuM7uAz0MdsfohsYefz8PsWFZAH1iu1lT0oU6BKP6KwSDvXIFsNj/mLGkqHD++7azRAC95Z7cmZDpe9blonY0MLMh55Az8yRZZBJvnI3yKyBhI7WHwAt2NqYJODVQa0hvcKuF7hJFD1BuTa4MAgf5iv05F/IeK6nu4r0qT70TiXATiW5v9N8YFfx4wBs/ThYfu9ekGtiwMdP3Tkuu4oBPvIaKcWSoQ8fm4Cug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyvBdeO4lzfn6LZwQegbDSoHEdK00RUbNjAp8gCQn1E=;
 b=Xi5ugnyYR/O/bwAAeP6zZ6crxvknaU+GY2X/kx38sY850/L80IRAKSZ73/397F3Gf3ZWg3A4kAkNSVUvcOqSepbUoqxEBtoGSWV0JAlO1IuFU4zHkup1M+IrJsxDtepTsxDqIJ2wzQhkpEaSdl3x122zPrpQfMgrNa+/hEQQg+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:28 +0000
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
Subject: [PATCH v2 net-next 12/15] net/sched: keep the max_frm_len information inside struct sched_gate_list
Date:   Tue,  7 Feb 2023 15:54:37 +0200
Message-Id: <20230207135440.1482856-13-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 272ba18f-0ef3-4187-ef79-08db0912f827
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9IrKekyZ/BHeCtE4ID9m8SOa4I8EXHHb8EQ0f3Y6NSndjwx+5knxjzcn+e2i2eEKgKMHqpJkporb3EF8hYOFi8l4kvL7QaEYwvABvwZq7HgH/uHIJN+OYBgjEPmgxv7RLMSvO9YPDZWFbvm6zoRC041KbHCsDK10jNCk+T0fNFOI+A9FPKVrCNHPkPh326OflgQTFiZQvp130YkJ6ANJ2utV9TgyI7PfFTMpWrW6vh+LHw4bodXPWH+lTgcTXlU2xU34SvkEhUS9Qs0wKJ1dWQvN7dmS7MeRXVkOm7fZeIbd2dGOKHsX0SYZzIH0oJRkEd4MTGwXSf0EmBtqCCxXzYHayE1oUBz5z9lSfoV2Rs7NXFulW09+lSWXqfHpMtHvyZoBgOFZnxeiWyuYmB0nBwiz7qMqMQZ5EQvbgBtFetre9ba9mMDPenWsC93mZ6S9Gw+BPh+ZqeAG8O0geRhl+nJWpExYhSB48nN6A0eMvy6mMXb2ZwCMc4lxdeF0RFMS7ns911xKP475qYPLcWGFRrK4qhjxhqfpCdJKkvFkBT61OyzxHm3PvDsp8YuV5GazDLaKbRV1xe32FPzwOEiFR8aDwpPrlscPHkdwiC7yR3QT2AiHCc/PEGNJwr9EgHp4gMa8L+La/xq/JtE+xSRPEPmKjxv3vowKicRLfC/Sww345dzGJqMwNmq3PX/jeJpkZDNex8pm6sc/H7kBVD4/Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gcpKVbEYXzaWbaPv8iNrOPz18JAlQTtncKGsyiods0FQRScwtyijPB/QuJVi?=
 =?us-ascii?Q?wUoJFS/53UB37pGSvPiR9fJYOnRGKtEN0gS0WULCSV2bX1EgbK0zj5Ros/G3?=
 =?us-ascii?Q?6CGH2hOjtT/ZVZ45D51+DVSZl9319tleKi8GSu2SQEEUl0v7sf1XCdeDmXLz?=
 =?us-ascii?Q?+j36/EAn06XsNkQH6X1lHY7tH/57ddkbn6oPhxyf3MmnRsucx65acNNe/mqU?=
 =?us-ascii?Q?GCkFo0rTvDqv3c2iLsV05I6fINlLwu3ByMcyIzvIMU4LOOs7Zfiqqd9DlcsO?=
 =?us-ascii?Q?/TJHr/h0LhiZV4xwP+nG7eV20NP6ZHhOY18u7wXQIhKKu6e0oCf+mtVdp+Nw?=
 =?us-ascii?Q?WmfkRs6UGrQ5EpBjTGrRrCQr6H5pK0KAy+VVT3bU1JI35xdf8dt+C2lQjeMe?=
 =?us-ascii?Q?aSP6p9Gydy7in6nocoyDIXxwFqH8l5IoBE4MoLoAqS7gx5mUddfpY9PdftJa?=
 =?us-ascii?Q?+4eg/GkWjcYXH3gRLJ5eH5M126PnULkaowveCUf0Fs9YsPnWXcs6fz+EQGt6?=
 =?us-ascii?Q?bNp9ypgVPqhp4wB3V26v1r3q6Bj+FBA+unRC+aydLa4XdNGbYhHdqj5nLIp7?=
 =?us-ascii?Q?vOxnYvIa2G9hBUWi2htZIm2df5BkFy9UR58Q35l4V/ayOrJeLYH0rn6kI7sd?=
 =?us-ascii?Q?a58Io0sOnHMroYPoZT3RXsu51d4NeSOruhtUG4m6XtYaZrpoJxZDcF0yo3JY?=
 =?us-ascii?Q?Ang/Dz0aFIrKRAjDD1C668E7Ql8ttaPqX7VWyc9qwwM/sqLsyJSloB7AYiVy?=
 =?us-ascii?Q?jE5jc/P+jEdjQS0sgxzqCB48m6A8Xxm2sHIyd/1IUaipV8hNYNunYOlleuZF?=
 =?us-ascii?Q?we2kfDrXszMXH9vhtySdiuuN8Aa+8kb4E6eUEk5TctA0xaifXu1QtpMFqWB/?=
 =?us-ascii?Q?3J46IU9s0jeYZIDUtzO7cbMEydqKVolzHjQl+YLoJeFym71M35LnkUV+uG8h?=
 =?us-ascii?Q?+V8AiVusYYuPXyHkZoaWmLqaxUPqK+3+z27ZUaVQJZHpS6ky5GYuMBVTwYWa?=
 =?us-ascii?Q?JwZADy0jt8oV7pOavT8NuZy1KDA0nVo62L+s3YFws/bS+6br1FHrK7BYhvbs?=
 =?us-ascii?Q?WU2M00PVitD/TCwpEPvRE+qb52Nfg1a/99/fkW3B+qEAyAUMHIKP0TvAvTzb?=
 =?us-ascii?Q?txyU601kCHkFnLhPJc2l4v4lFpkJFf6zTmqDre7wJ4RV5he72UDAn1mKm2vF?=
 =?us-ascii?Q?mFrBh9SmTDV27MGKocCfui5MPn25JU685kr7pQ96M1r929840eKLnwvOdRzi?=
 =?us-ascii?Q?BaFwY+90dqOaocDwcPTk8iM9XDc4LmNx5bnIjpicxLME1ZmkaBMCBnQElZpu?=
 =?us-ascii?Q?bZ5vlgLDS8Wcks6qXvQpY4aI1ETbj7WpepRdBkpCxmBDDupW090caqM1UrnE?=
 =?us-ascii?Q?8qk+3JIGTC2mgWEOY/SyDExEsMnj4VT5ophRHTcJE0kLtc21oQY15hu+q7GH?=
 =?us-ascii?Q?E3N8WrEaacLIGDgNFHZE1e/65JEyB0wdNGGNHOxL0/AIp7iwT83vyNHZsNEp?=
 =?us-ascii?Q?QDXqBndTmCKdqh0CLEFS0rbJ0gc6CshFnIsmlzmotQcU3OoFYo3JNSyRij0e?=
 =?us-ascii?Q?1EtmlPe6yh6ExRV3U7OYvqaK+ET8imOJGRv3uRw1qJuORkSCjyD2pQEU7e1U?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272ba18f-0ef3-4187-ef79-08db0912f827
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:28.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAxIcgdUt2eTQgeFI+B6UYjistp+GWyT8gMLTpFVg8kXVPObyjWM/9GTRXFpYNxWw3SQtjHV75b5V5bAk5yyEw==
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

I have one practical reason for doing this and one concerning correctness.

The practical reason has to do with a follow-up patch, which aims to mix
2 sources of max_sdu (one coming from the user and the other automatically
calculated based on TC gate durations @current link speed). Among those
2 sources of input, we must always select the smaller max_sdu value, but
this can change at various link speeds. So the max_sdu coming from the
user must be kept separated from the value that is operationally used
(the minimum of the 2), because otherwise we overwrite it and forget
what the user asked us to do.

To solve that, this patch proposes that struct sched_gate_list contains
the operationally active max_frm_len, and q->max_sdu contains just what
was requested by the user.

The reason having to do with correctness is based on the following
observation: the admin sched_gate_list becomes operational at a given
base_time in the future. Until then, it is inactive and applies no
shaping, all gates are open, etc. So the queueMaxSDU dropping shouldn't
apply either (this is a mechanism to ensure that packets smaller than
the largest gate duration for that TC don't hang the port; clearly it
makes little sense if the gates are always open).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: create a taprio_skb_exceeds_queue_max_sdu() helper function

 net/sched/sch_taprio.c | 53 +++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7553bc82cf6f..d3e3be543fae 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -63,6 +63,7 @@ struct sched_gate_list {
 	 * or 0 if a traffic class gate never opens during the schedule.
 	 */
 	u64 max_open_gate_duration[TC_MAX_QUEUE];
+	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
@@ -93,7 +94,6 @@ struct taprio_sched {
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 	int cur_txq[TC_MAX_QUEUE];
-	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
 	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
 };
@@ -246,6 +246,21 @@ static int length_to_duration(struct taprio_sched *q, int len)
 	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
+static void taprio_update_queue_max_sdu(struct taprio_sched *q,
+					struct sched_gate_list *sched)
+{
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
+	int tc;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (q->max_sdu[tc])
+			sched->max_frm_len[tc] = q->max_sdu[tc] + dev->hard_header_len;
+		else
+			sched->max_frm_len[tc] = U32_MAX; /* never oversized */
+	}
+}
+
 /* Returns the entry corresponding to next available interval. If
  * validate_interval is set, it only validates whether the timestamp occurs
  * when the gate corresponding to the skb's traffic class is open.
@@ -479,14 +494,33 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	return txtime;
 }
 
-static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
-			      struct Qdisc *child, struct sk_buff **to_free)
+/* Devices with full offload are expected to honor this in hardware */
+static bool taprio_skb_exceeds_queue_max_sdu(struct Qdisc *sch,
+					     struct sk_buff *skb)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *sched;
 	int prio = skb->priority;
+	bool exceeds = false;
 	u8 tc;
 
+	tc = netdev_get_prio_tc_map(dev, prio);
+
+	rcu_read_lock();
+	sched = rcu_dereference(q->oper_sched);
+	if (sched && skb->len > sched->max_frm_len[tc])
+		exceeds = true;
+	rcu_read_unlock();
+
+	return exceeds;
+}
+
+static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
+			      struct Qdisc *child, struct sk_buff **to_free)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
 		if (!is_valid_interval(skb, sch))
@@ -497,9 +531,7 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			return qdisc_drop(skb, sch, to_free);
 	}
 
-	/* Devices with full offload are expected to honor this in hardware */
-	tc = netdev_get_prio_tc_map(dev, prio);
-	if (skb->len > q->max_frm_len[tc])
+	if (taprio_skb_exceeds_queue_max_sdu(sch, skb))
 		return qdisc_drop(skb, sch, to_free);
 
 	qdisc_qstats_backlog_inc(sch, skb);
@@ -1609,7 +1641,6 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 				   struct netlink_ext_ack *extack)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
 	u32 max_sdu[TC_QOPT_MAX_QUEUE];
 	unsigned long seen_tcs = 0;
 	struct nlattr *n;
@@ -1628,13 +1659,8 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 			goto out;
 	}
 
-	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
 		q->max_sdu[tc] = max_sdu[tc];
-		if (max_sdu[tc])
-			q->max_frm_len[tc] = max_sdu[tc] + dev->hard_header_len;
-		else
-			q->max_frm_len[tc] = U32_MAX; /* never oversized */
-	}
 
 out:
 	return err;
@@ -1758,6 +1784,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 
 	taprio_set_picos_per_byte(dev, q);
+	taprio_update_queue_max_sdu(q, new_admin);
 
 	if (mqprio) {
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
-- 
2.34.1

