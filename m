Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959CA5ED135
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiI0XsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiI0XsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:48:09 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C7A1BBEE4;
        Tue, 27 Sep 2022 16:48:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqtRmgAeAH2KUxNERkcSq9TUxeo1WaTtVApQZHQbKzBZJBM4DSxrmkFYh3c6mGlRI/QwLfAsGYRuE/K/M7hahKrFiAjaF9Nt/t4ZLaQ4XulqYLiPsEdznAAem9mSm07l/vRv2ZFIdD9D5kbPlbFrOWNLiPaNba58BkdxiVFNVDNR2ZVSMbUFdPvjCs4eOtyWoD+FMdwB42YVa4o2Y9AnkEOBky8L6OKL+/R0j5cB5RG6U1g+QLqJUtW4WF4yDQhqRjIse6cvGnpbb07JZHd8d4/d+IFufwcLAdviUYELAqiYTx68iogQAtmZWlFjXxA8IRKKry5hlp7AS5GxQYAr6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLc8s6Bn8XOsMpJP/GpFRRZy12/JvSSOvPPwV1i6x+8=;
 b=d5z7h5a38/CmZPhKf3vYBvDCrhROsQ/AhRTDbK1F0irUt2gEj+Dg+aSKgeJ/ZzzPWpEmfG9tTcA58cM/g/98RtfSkuJ3GfzS/CiJ1wMCkAwqIJtEGpbfpUZk3fhBkwjkTSDBdegvC1ev/pdO309b6ueu9WxS/8YhhDgHipsn5UpxLK9CsqiC7uYi6fJiRmwFhtZ06oefX06ewrdhMTsFOiGKsI0zdzsK4CVM3I/ghpH6VkbNVNbtTWoxjRzfgR8uszwR8m3TM8+nRmV2cmmcV+aNnWCh8NCOlZbSDiatnEJcT1XVoW+X6Y0otLVmgOvn04FzuJRzrj5WVeF8t5fNhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLc8s6Bn8XOsMpJP/GpFRRZy12/JvSSOvPPwV1i6x+8=;
 b=QfJJh3l7lanlSFp/ZBwULCjQRAz7+vteFXyPO26bi3fjGZxGIUrgt/mBA14hcY/fJZVNmC8UL/y2fhIXvZaA1wFr0Lp1wivyhjhsFSUw1M9HMCJknE6IRk4Guky/1S0e2vaUyEEZuKMRhEJiqKH/t2oE6exIf+02E44ROYbiR60=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:02 +0000
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
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 2/8] net/sched: taprio: allow user input of per-tc max SDU
Date:   Wed, 28 Sep 2022 02:47:40 +0300
Message-Id: <20220927234746.1823648-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: d5360a78-6b94-4ee4-0d71-08daa0e2b721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oyrdULZj+G+82M6g4cHHjVvp4LooU20WufYXkd1gguUxoQtoIkzSyDNgqZfcKAuAhHFrzM8nZ8mz5cDaAwWKlgAyPHZFQlogk+jn65sgNV38ODweqSiDWNBekcQ/XimxoYT4qSo2mqX9OrKBFw8zx0xOhZmitwDGbBe/lswKERFAydnNgefaFzTFvyvn72Zhue/NvwXenMzYGpmphFbYEMtZjjA/BTX7aoLmhL8tSFLcTo+p2D1Gojw5JIWFLy1ehRZXl7eKJVLUQXUr4SDsvRfLCczCSlVREkeVWmzL4ddsTv4MIGD9RlaZzktlfltGnFG5P+HlSEJ07WICX6miRS2D5ep3kyNRn9e+lYlPFapv5blI8E5nJRa1pR9RG/lNMIXWn077UGkTxAH+ns5ICGQdyYs9mokOA+CYUy6lNqCB1AjHRz6cLtr9IQmFw1EO7l5SXC2rFsK91Ut2JsYClxgDOxQvSxSFJRYu2gFAQsLdz5a2JsENcFgz35d3FFn/E8Uays8B/Ibsz5YLDGVoUGzOzxMgCz/g2metJssMmP749tDAOOasHdX8D5byAQqsaFj3zLTM5L47ayOynJlSLWihrn0sLOnIjlCbSNHa+HK6fpqANT8pQOskQPLgnfnk8XgQnREigf9I8Z6+iXxijcXAJxPjfGvwAEJ7biWbbpaQsVId4LNw0y8Jw1iVm+aobbR8C8gI6dN6OyO6ZAe8g9p1n8o9kocId9mmZQrQOvIE9kosCQTY3TVxFF9gE9pFu0vogMSsMPyRc+nvGpI1pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U9XKp+t/VlRWMNWK66CiQWilOZx6nZIZPuamLgmdL6qje/xmBq+23CNRgMAy?=
 =?us-ascii?Q?1I49mUb0siGa7ZTZ7tUYbMFFdhUmojpBlCdst5Txuk2aw4dkW/dm+0zMpLhF?=
 =?us-ascii?Q?tWASMHtsfR4v0+xfCmGEHT5Gt59Df5FcZ+5B/4P4mwNFZwjILwMmn0ktRZGZ?=
 =?us-ascii?Q?s2cb8nApkQIGwBz3AV4AGdFZqf6FJkcHNXcvoNZcBnO+BSyrsoqKHnyK1hty?=
 =?us-ascii?Q?v9evSvBfZlYixOT0Oscg2SbfF9t7sNxUdgk5SDrhsKmJ46ZPqBVnXHGO8V5Y?=
 =?us-ascii?Q?mSNFHcwKHuspwWnw8oBW/ja0RTPvJ7LcIPp4U2vBQFp0TbjS/4mMAKN7TEFM?=
 =?us-ascii?Q?j20QwsNWLpsLaPgY6x1xQuB6IY9gC9HJJydsLpC97qtpzBys2m/YqYtbhDbE?=
 =?us-ascii?Q?DWzaMxkCFpfpEiVZT/UNjQnD/lL3U32dgp2P509K7jdLiMrhPuAOvMB3Kuod?=
 =?us-ascii?Q?54myu9AqLRj2l/IQ+WRRK4cKvnJ6rjbFuSJImKqayAdRyC2m7Ti9obdU+rc5?=
 =?us-ascii?Q?b8eHl9FJ+WTRHQfFfxUYLpker9RDMpwt191ri0KarlBqAJOxpx3erUqpyl19?=
 =?us-ascii?Q?Om+Vzz422iXEJw6oQhSgQ6zxvT4avpXcVhdMcgZ/HDokJM6FDr6sQwS9GFB1?=
 =?us-ascii?Q?FHFuYgJnBSRMC1dGYiwHlLNw5Gt1yUaPz7DC/n3Q08aBS8d0TuLE9cTPJV2f?=
 =?us-ascii?Q?Z107qaP6qsS8eoS+GIzdQsn+wS2WsWiHkp7RcG/g19HxlY8xMOCpsm+9IGFu?=
 =?us-ascii?Q?/snqCi8wGWxdF4HDKrQoASAq8ModLWdb2ZSqRCEK1n8/89nAc+pnQpLaVGb2?=
 =?us-ascii?Q?XV/5ytLdORxLHHP80MboQBpnxlJFQZfXjYeVsQNWx5/KavH0MTCTleGaWI8W?=
 =?us-ascii?Q?f0PT2HIGMdwmokIAqn6AxrRq/EW+VHUX+vMO1TLmM7c+6utzAdxA2fcvZgVw?=
 =?us-ascii?Q?p+nlYxwVaX8cxbak9imfufkdb27suRQjBF7Va5NU6ATmK3BoRFqCuFON58pM?=
 =?us-ascii?Q?tXg9ezoQwUkszEN5SuHZWC7PSSYiCfI+a4jps6VgCunoHeAAxIueLSCs+l17?=
 =?us-ascii?Q?kmLo1MmYCE1K4OS6fHHXg8sguoghYHu8u9XpnIbOyd8ZGqXUY4WhKxH+HlbQ?=
 =?us-ascii?Q?gro0XNDHGThj8+drv089c/AMgFrXBWARMP9Rl+sY90h5Q7KVEFgYhV95L50r?=
 =?us-ascii?Q?CNJeW9FNdr8q9dTqOwODNyyDs3681wWD9v44lwV0HOnrznguSl71la1gyhu3?=
 =?us-ascii?Q?dKrJa7gy2uIpYYe7YOdYViLxSyY683YOF7s9XC/Tw6nGvQoDP2DihMf7LcIV?=
 =?us-ascii?Q?xtDdX4b+xpwLjQvIUaUvBA5DV50OZtmuFIdbZ1OeI8F5vjDwxUbYpQb0bsKg?=
 =?us-ascii?Q?5ScXV3wX8Tw9hL+HcftV6NoejKcdfvcSpwVR6ZKR4kIjMR7+A4gpoPu+nlnu?=
 =?us-ascii?Q?RDUqsddgRdOpObkUK+be0VHr9PMvJZe3B96xVW7R7jyAShF8D7zeF83JtJML?=
 =?us-ascii?Q?FT4lrjQ7PskYl0v7wYimOT57K5/5/4qyHxn0FQbKC/ieWeNOq2KPwCHath+4?=
 =?us-ascii?Q?DPyn5LnewaZ4rvck+GpNbn4jC4Cjlw0qvjD1Tm094y5tagZfyYCdw8rgmjpr?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5360a78-6b94-4ee4-0d71-08daa0e2b721
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:02.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: stdxj+UVlYuLkTVZwd1JiV4A/bMEQ4SWwNXi0xhpsGzkc/AwR0iYtLVV/I2IMR1WqLNIWc1ny5/ijOAye7TN5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1Q clause 12.29.1.1 "The queueMaxSDUTable structure and data
types" and 8.6.8.4 "Enhancements for scheduled traffic" talk about the
existence of a per traffic class limitation of maximum frame sizes, with
a fallback on the port-based MTU.

As far as I am able to understand, the 802.1Q Service Data Unit (SDU)
represents the MAC Service Data Unit (MSDU, i.e. L2 payload), excluding
any number of prepended VLAN headers which may be otherwise present in
the MSDU. Therefore, the queueMaxSDU is directly comparable to the
device MTU (1500 means L2 payload sizes are accepted, or frame sizes of
1518 octets, or 1522 plus one VLAN header). Drivers which offload this
are directly responsible of translating into other units of measurement.

To keep the fast path checks optimized, we keep 2 arrays in the qdisc,
one for max_sdu translated into frame length (so that it's comparable to
skb->len), and another for offloading and for dumping back to the user.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: use qdisc_offload_query_caps(). This also gives an extack
message to the user on lack of support for queueMaxSDU, which was not
available before.

 include/net/pkt_sched.h        |   5 ++
 include/uapi/linux/pkt_sched.h |  11 +++
 net/sched/sch_taprio.c         | 152 ++++++++++++++++++++++++++++++++-
 3 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 34600292fdfb..38207873eda6 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,10 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_taprio_caps {
+	bool supports_queue_max_sdu:1;
+};
+
 struct tc_taprio_sched_entry {
 	u8 command; /* TC_TAPRIO_CMD_* */
 
@@ -173,6 +177,7 @@ struct tc_taprio_qopt_offload {
 	ktime_t base_time;
 	u64 cycle_time;
 	u64 cycle_time_extension;
+	u32 max_sdu[TC_MAX_QUEUE];
 
 	size_t num_entries;
 	struct tc_taprio_sched_entry entries[];
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index f292b467b27f..000eec106856 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1232,6 +1232,16 @@ enum {
 #define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
 #define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
 
+enum {
+	TCA_TAPRIO_TC_ENTRY_UNSPEC,
+	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+
+	/* add new constants above here */
+	__TCA_TAPRIO_TC_ENTRY_CNT,
+	TCA_TAPRIO_TC_ENTRY_MAX = (__TCA_TAPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1245,6 +1255,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
 	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
+	TCA_TAPRIO_ATTR_TC_ENTRY, /* nest */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0bc6d90e1e51..435d866fcfa0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -78,6 +78,8 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
+	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
 };
 
@@ -415,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int prio = skb->priority;
+	u8 tc;
 
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
@@ -426,6 +431,11 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			return qdisc_drop(skb, sch, to_free);
 	}
 
+	/* Devices with full offload are expected to honor this in hardware */
+	tc = netdev_get_prio_tc_map(dev, prio);
+	if (skb->len > q->max_frm_len[tc])
+		return qdisc_drop(skb, sch, to_free);
+
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -754,6 +764,11 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]  = { .type = NLA_U32 },
 };
 
+static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
+	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+};
+
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
 		.len = sizeof(struct tc_mqprio_qopt)
@@ -766,6 +781,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_TC_ENTRY]		     = { .type = NLA_NESTED },
 };
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
@@ -1216,7 +1232,8 @@ static int taprio_enable_offload(struct net_device *dev,
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct tc_taprio_qopt_offload *offload;
-	int err = 0;
+	struct tc_taprio_caps caps;
+	int tc, err = 0;
 
 	if (!ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack,
@@ -1224,6 +1241,19 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_TAPRIO,
+				 &caps, sizeof(caps));
+
+	if (!caps.supports_queue_max_sdu) {
+		for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+			if (q->max_sdu[tc]) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Device does not handle queueMaxSDU");
+				return -EOPNOTSUPP;
+			}
+		}
+	}
+
 	offload = taprio_offload_alloc(sched->num_entries);
 	if (!offload) {
 		NL_SET_ERR_MSG(extack,
@@ -1233,6 +1263,9 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	taprio_sched_to_offload(dev, sched, offload);
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		offload->max_sdu[tc] = q->max_sdu[tc];
+
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack,
@@ -1367,6 +1400,89 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 	return err;
 }
 
+static int taprio_parse_tc_entry(struct Qdisc *sch,
+				 struct nlattr *opt,
+				 u32 max_sdu[TC_QOPT_MAX_QUEUE],
+				 unsigned long *seen_tcs,
+				 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
+	struct net_device *dev = qdisc_dev(sch);
+	u32 val = 0;
+	int err, tc;
+
+	err = nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
+			       taprio_tc_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
+		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");
+		return -EINVAL;
+	}
+
+	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
+	if (tc >= TC_QOPT_MAX_QUEUE) {
+		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");
+		return -ERANGE;
+	}
+
+	if (*seen_tcs & BIT(tc)) {
+		NL_SET_ERR_MSG_MOD(extack, "Duplicate TC entry");
+		return -EINVAL;
+	}
+
+	*seen_tcs |= BIT(tc);
+
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+		val = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+
+	if (val > dev->max_mtu) {
+		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
+		return -ERANGE;
+	}
+
+	max_sdu[tc] = val;
+
+	return 0;
+}
+
+static int taprio_parse_tc_entries(struct Qdisc *sch,
+				   struct nlattr *opt,
+				   struct netlink_ext_ack *extack)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	u32 max_sdu[TC_QOPT_MAX_QUEUE];
+	unsigned long seen_tcs = 0;
+	struct nlattr *n;
+	int tc, rem;
+	int err = 0;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		max_sdu[tc] = q->max_sdu[tc];
+
+	nla_for_each_nested(n, opt, rem) {
+		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
+			continue;
+
+		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs, extack);
+		if (err)
+			goto out;
+	}
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+		q->max_sdu[tc] = max_sdu[tc];
+		if (max_sdu[tc])
+			q->max_frm_len[tc] = max_sdu[tc] + dev->hard_header_len;
+		else
+			q->max_frm_len[tc] = U32_MAX; /* never oversized */
+	}
+
+out:
+	return err;
+}
+
 static int taprio_mqprio_cmp(const struct net_device *dev,
 			     const struct tc_mqprio_qopt *mqprio)
 {
@@ -1445,6 +1561,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	err = taprio_parse_tc_entries(sch, opt, extack);
+	if (err)
+		return err;
+
 	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
 	if (!new_admin) {
 		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
@@ -1825,6 +1945,33 @@ static int dump_schedule(struct sk_buff *msg,
 	return -1;
 }
 
+static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
+{
+	struct nlattr *n;
+	int tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+		n = nla_nest_start(skb, TCA_TAPRIO_ATTR_TC_ENTRY);
+		if (!n)
+			return -EMSGSIZE;
+
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_INDEX, tc))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
+				q->max_sdu[tc]))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, n);
+	}
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, n);
+	return -EMSGSIZE;
+}
+
 static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1863,6 +2010,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
+	if (taprio_dump_tc_entries(q, skb))
+		goto options_error;
+
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.34.1

