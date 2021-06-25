Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969DF3B42D1
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 14:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFYMFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 08:05:34 -0400
Received: from mail-eopbgr60091.outbound.protection.outlook.com ([40.107.6.91]:56910
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229712AbhFYMFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 08:05:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmLS07biuYMAF563rULRcyPmS+9FFHXNVNcHp+crCsc+WM1SPFfbt2nmWYU99KrZWTg2sqLnmKT1Qs/il7anBAOjVgO1tQURlil2lBCUAqionKUVyS0KganVovQBwUzgtx/t8unuvnymxGYwFXtk0XmGE232MUBOXbYMV2Sw9zU1ectEjiZvo4sRYj2qolsiLYyA54eRUgu7nFVJ0+oyjZ1SUWQNEMN85rOqkJIznw8onFvUxZnkMJK+gRoxEHFELilRAIRKXVmeecvCJMAO87bUoi/AqShdpHL6GyiZ4GbnKGUCGMdqBaGfp2a8G75PX/BZcxKAsJMXIKMISF7fCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYZ5r3kDSoe4pbNSfy3ATVldax559C+q3c/8j1YZyOg=;
 b=b71YpJXXGYbFiU8gYq30GsuWfHmquoljMM/zs1BNdC0AxsBHBnx/F6lKgF1BVmiLBESpoiCniUUs30Bi5OsIg/Q0k4PGRcQtBXQiDBKKcOEjoiXAIFZp3qMqmp4dvLt/ZC0yutLOmBBxaj/QLvP7f942M3A5pfqIvu4q8BKXHOjKmmZldnkjgFTAiVs91Nx/xaVPghKfjKpmg/6r0WJ0lTjj9T3ABFfFfATjW64HPl0TwGBt+kQKQ1D02n/xAuEAdD/WTy+LDe+SdlTZd8jTw5PIiKSvKZUBoRjqldedJOGMyUKhZlpRrzNg7cdFiFnV2fhHnayMFeCwyES7AQY1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=itu.dk; dmarc=pass action=none header.from=itu.dk; dkim=pass
 header.d=itu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itu.dk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYZ5r3kDSoe4pbNSfy3ATVldax559C+q3c/8j1YZyOg=;
 b=avD2hDQUjgN+olCCmttTpneEJVVEl6ayeHjCp+3wDHgt4+IWmOUmghchvZeDz03aqhDgJGVtaeRl4FTXrDx6Qbn53Wp7KtK78aSApc/++FkFRouB/YdCiS+bMsJhZiOCTf7ywErHCpQbvNYQYNaE2WlaHXyaYX28UPKn837ioRw3ObouxPdkiCSZvp5HK20n7f0ZVd+eBcLazJ3t3wZ7VnaF8uN5JeU36vkdePZ2SidrD+5j1XEigJrNXo9sAB2Yz/+m8+zwrPlW+6UZXZ3G+L0nfhl9AVvJiGfDIMG96GhjE1whnVAnygPO1Dv57IT6hEfxKuUPuDUPCPp7CEH6gw==
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com (2603:10a6:208:180::13)
 by AM9PR02MB6561.eurprd02.prod.outlook.com (2603:10a6:20b:2ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Fri, 25 Jun
 2021 12:03:11 +0000
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511]) by AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511%9]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 12:03:11 +0000
From:   Niclas Hedam <nhed@itu.dk>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] net: sched: Add support for packet bursting.
Thread-Topic: [PATCH] net: sched: Add support for packet bursting.
Thread-Index: AQHXaboRno1QlQ+G6kK3RWITgvXpiQ==
Date:   Fri, 25 Jun 2021 12:03:10 +0000
Message-ID: <0124A7CD-1C46-4BC2-A18C-9B03DD57B8B8@itu.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=itu.dk;
x-originating-ip: [130.226.132.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1457482-3c74-4960-31f6-08d937d13405
x-ms-traffictypediagnostic: AM9PR02MB6561:
x-microsoft-antispam-prvs: <AM9PR02MB656183A607104F8329691ECDB4069@AM9PR02MB6561.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dGLCCpn6wQtvN7kCke6BZhkwuOMlSqSA7wzf1nZUkec3PK8KlOePJ9i/hnpc0P28PMBN7RtErrt0Zmrez+npSvLAaHNAzwA083TCABVBR1W9qhQMPWu1AVBUfHAoDCHjogHL1KpBfovUufp5LrAAp9FrZb0V0PB7yKqY0XBI3qkqxWepjV5PsEw0O+RD+EFAWq1bgx1VjUKaWzwBGbIKkfXADwpSQX50nrSasQAGkbXsKN8BamPnkUJnzs/lKKh+pdpmUMQ/wV4VnAmk/YflojoVflc1WZU86Ku4ozKgT6YKTu6CKtWc8XZxT0NzuPEldWtOtcdJA6I04CncMlbgO1PMId/vz6kY7ny6dQf40ATbeCWkDK6t+uqb/gBk4QlDNz/1244UcX8bfqIsVfFGHASYQNnkG2IPja7UPEC2eH+K+/uhh+twaprxjUPsHMmXnTFcUZBhtI28E7gJtw5vgSK+JANee8Y16sUkrzCQgfsT/m7X7B7rv0odqNe6FMIZn3YZkqgd9IfoExEsRCxvxdpnynxXyJwhNTP17Ti8cxgL37o1VKuIdIdDjGxXBHCYMHc6BSkTJGsYrl4f7D1cMf+DEEbDUYsKyc9+5x8s4v/heUw85PhdI49VPqeiW11peaCYMaThr6LZl3S+vO4YPuLTUWvpGoDU4f6BJrnzFD4UEEKqHfHXcLBUl29ShdfGJAg81ZVHjqBSlAjdY8DbTt+jqcJWE73Li2HIa5kVmebAl84WcVbVhG6IXf+tuyJ0WdV4NcTo/TphTVvzofisCW0V1sE/ts9L1xYURixY4Mr/wIOTUvSyP2OfkwhwKeUL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5777.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39830400003)(136003)(2906002)(66556008)(64756008)(66446008)(66476007)(186003)(26005)(66946007)(76116006)(6506007)(316002)(8676002)(478600001)(91956017)(33656002)(786003)(5660300002)(4326008)(8936002)(36756003)(83380400001)(6486002)(8976002)(86362001)(38100700002)(2616005)(122000001)(6916009)(71200400001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z2kzonMthPZQ+/Nt+pDrIt450bEYpGRBMeCHVfAeYfammtc/a4XbMAvDvPop?=
 =?us-ascii?Q?0YGbfAO41K1DZHXzcgPaxr84COU1HObidSsgNYoCsZcLxsvQR6xD9auqv2Uf?=
 =?us-ascii?Q?zbThkTIWQIQ6YrdUmjg8s3It0DDaaxMdZYisSan5PSjS/0NZjLHwRuP/4q4E?=
 =?us-ascii?Q?/pO5hVKjPiSzjhztp5MOdLMcLCwAh/siFUvcTpZ9piPKDExGc609wH0F4CMx?=
 =?us-ascii?Q?kVQ/CF2QI9AnTOiQwB/rdPRI2L5mUd6UmEXP2mlL/jT3QCTYAQgxAJsNYhoI?=
 =?us-ascii?Q?g9Wdwhrr+SAe9Eu7CW4TZcjpzs28QbaHo2ZCNxFTtM0BvQCJ3gYCwXyHHohj?=
 =?us-ascii?Q?xc2nMzGBA5vnLirnL1GpD9W4RqnyqINt9WddvlmgImJXBOMXNA04Vri0vpCo?=
 =?us-ascii?Q?ZOvLK0HXsDWfK9JP1dBPP+uWiuQ8oy44xSpINKKrT7peEVtd+FHEFZz0dqtI?=
 =?us-ascii?Q?uwfU9w6mtmnjfstdx+hm9BJLey9kARWYM3pKsNZEI9zeyYouElYKqb3cXIkq?=
 =?us-ascii?Q?w4gGzP+wuEKREuSS8Wt8yhr14PJtDh3bU83ZxfhrrRSGRl8HBKJcpOlOUxkX?=
 =?us-ascii?Q?UBr9VQyIYvLroN9CZfZqvZ2rMx48w+47fu5YxA3B8K5j5KuIgymTfyjU/sMe?=
 =?us-ascii?Q?AeWdGOEmxheqM2SUR4zapzOPQt9iDQOhydREyxguw/uH0j5pOlYl/xlFH8oy?=
 =?us-ascii?Q?Pox2WvfuxqbJX7yVa16dY2YtNYJ6KPLGy4IhBFVkRY1DNU21UaP7/ZerWNvt?=
 =?us-ascii?Q?dFpgvuObHU6J01JPt5MtpD/m1EDeq54qll8k8kxjJhmBmq8Ag5pNyEU2Zwsq?=
 =?us-ascii?Q?dBZKu5JvAd15YHlrYOPVem3FVZy9k54ka1Fd9pHcSYEVMLYIt5RiwTWr8r22?=
 =?us-ascii?Q?etF2Z4ukeH6eHZEJZN4YrorZHHWWLGvlYoekPRSR7KgtR5XqA/35JRi3F4SB?=
 =?us-ascii?Q?/Qm42SbM2qsMhSM6kJZyBwQ3DEsmtsSW8y/M5KMVqkBnOK5/pKtqdwaN87GW?=
 =?us-ascii?Q?GTBozoMqngPynTu3KOjEigb88UuVWcfiFR3CPCCTM/+4hRK+qkniB3J42lIi?=
 =?us-ascii?Q?pg+fapWvo8M7NukmUZUXhuzJvt0xAr3O2AjClO8ovSbbw4oPz84u9895c8Qg?=
 =?us-ascii?Q?12ImPZ3Z6CEN9F3QN1gy9GKne08wHHFGJ2++Oothsys8QLZ6Lpw6VspImMRv?=
 =?us-ascii?Q?Dc7CJ20p3/VdR4My9FJOpNNPyJdIRBmj2P/Az0ID9ZueY/YJKGYmT+75sENE?=
 =?us-ascii?Q?u8R0Y5yXySoCSShv1P0H3o3QJgJJHfkkrWNv5K2cgDH1VKmetboDTX77pcGY?=
 =?us-ascii?Q?VB/rFiF9esVW3geq8GJ4p5kc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81ED72EBA990A14A8DCCD888F1614390@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: itu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5777.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1457482-3c74-4960-31f6-08d937d13405
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 12:03:10.9695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea229b6-7a08-4086-b44c-71f57f716bdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VLfz1k3I6UP3UUUA1ofZxntlXwlmlZfzgH4cXxMiSYD6ME+qtRyiZ9cgAktx6OdD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR02MB6561
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This patch implements packet bursting in the NetEm scheduler.
This allows system administrators to hold back outgoing
packets and release them at a multiple of a time quantum.
This feature can be used to prevent timing attacks caused
by network latency.

I'm currently publishing a paper on this, which is currently not
publicly available, but the idea is based on Predictive Black-Box
Mitigation of Timing Channels
(https://dl.acm.org/doi/pdf/10.1145/1866307.1866341).

Signed-off-by: Niclas Hedam <niclas@hed.am>
---
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_netem.c          | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.=
h
index 79a699f106b1..826d1dee6601 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -594,6 +594,7 @@ enum {
 	TCA_NETEM_DELAY_DIST,
 	TCA_NETEM_REORDER,
 	TCA_NETEM_CORRUPT,
+	TCA_NETEM_BURSTING,
 	TCA_NETEM_LOSS,
 	TCA_NETEM_RATE,
 	TCA_NETEM_ECN,
@@ -615,6 +616,7 @@ struct tc_netem_qopt {
 	__u32	gap;		/* re-ordering gap (0 for none) */
 	__u32   duplicate;	/* random packet dup  (0=3Dnone ~0=3D100%) */
 	__u32	jitter;		/* random jitter in latency (us) */
+	__u32	bursting;	/* send packets in bursts (us) */
 };

 struct tc_netem_corr {
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0c345e43a09a..52d796287b86 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -85,6 +85,7 @@ struct netem_sched_data {
 	s64 latency;
 	s64 jitter;

+	u32 bursting;
 	u32 loss;
 	u32 ecn;
 	u32 limit;
@@ -467,7 +468,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qd=
isc *sch,
 	/* If a delay is expected, orphan the skb. (orphaning usually takes
 	 * place at TX completion time, so _before_ the link transit delay)
 	 */
-	if (q->latency || q->jitter || q->rate)
+	if (q->latency || q->jitter || q->rate || q->bursting)
 		skb_orphan_partial(skb);

 	/*
@@ -527,8 +528,17 @@ static int netem_enqueue(struct sk_buff *skb, struct Q=
disc *sch,
 	qdisc_qstats_backlog_inc(sch, skb);

 	cb =3D netem_skb_cb(skb);
-	if (q->gap =3D=3D 0 ||		/* not doing reordering */
-	    q->counter < q->gap - 1 ||	/* inside last reordering gap */
+	if (q->bursting > 0) {
+		u64 now;
+
+		now =3D ktime_get_ns();
+
+		cb->time_to_send =3D now - (now % q->bursting) + q->bursting;
+
+		++q->counter;
+		tfifo_enqueue(skb, sch);
+	} else if (q->gap =3D=3D 0 ||		/* not doing reordering */
+	    q->counter < q->gap - 1 ||		/* inside last reordering gap */
 	    q->reorder < get_crandom(&q->reorder_cor)) {
 		u64 now;
 		s64 delay;
@@ -927,6 +937,7 @@ static const struct nla_policy netem_policy[TCA_NETEM_M=
AX + 1] =3D {
 	[TCA_NETEM_ECN]		=3D { .type =3D NLA_U32 },
 	[TCA_NETEM_RATE64]	=3D { .type =3D NLA_U64 },
 	[TCA_NETEM_LATENCY64]	=3D { .type =3D NLA_S64 },
+	[TCA_NETEM_BURSTING]	=3D { .type =3D NLA_U64 },
 	[TCA_NETEM_JITTER64]	=3D { .type =3D NLA_S64 },
 	[TCA_NETEM_SLOT]	=3D { .len =3D sizeof(struct tc_netem_slot) },
 };
@@ -1001,6 +1012,7 @@ static int netem_change(struct Qdisc *sch, struct nla=
ttr *opt,

 	q->latency =3D PSCHED_TICKS2NS(qopt->latency);
 	q->jitter =3D PSCHED_TICKS2NS(qopt->jitter);
+	q->bursting =3D PSCHED_TICKS2NS(qopt->bursting);
 	q->limit =3D qopt->limit;
 	q->gap =3D qopt->gap;
 	q->counter =3D 0;
@@ -1032,6 +1044,9 @@ static int netem_change(struct Qdisc *sch, struct nla=
ttr *opt,
 	if (tb[TCA_NETEM_LATENCY64])
 		q->latency =3D nla_get_s64(tb[TCA_NETEM_LATENCY64]);

+	if (tb[TCA_NETEM_BURSTING])
+		q->bursting =3D nla_get_u64(tb[TCA_NETEM_BURSTING]);
+
 	if (tb[TCA_NETEM_JITTER64])
 		q->jitter =3D nla_get_s64(tb[TCA_NETEM_JITTER64]);

@@ -1150,6 +1165,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_bu=
ff *skb)
 			     UINT_MAX);
 	qopt.jitter =3D min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
 			    UINT_MAX);
+	qopt.bursting =3D min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->bursting),
+			    UINT_MAX);
+
 	qopt.limit =3D q->limit;
 	qopt.loss =3D q->loss;
 	qopt.gap =3D q->gap;
--
2.25.1

