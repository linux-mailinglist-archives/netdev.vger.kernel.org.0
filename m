Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52163181F91
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgCKReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:37 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730458AbgCKReh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkKHh7PgVmZie4tH5JfxhlHbCF47sgtNg7I1zD8Y+xcoT0sgAd5e9PNGXpKrCKkAbo9FczUdO6kFB8KzHwnlRrhpCQEFp2wh3CziqeAvoo99jFCxM0U2pC0BTG/XFBHt7jlTgx6Rse7JVd0ICZ8uKdYye2w/OrhjYDxOLO8l+Y3bro8RWOTEp65eZM03AR9Y2TEojurU4hPpatRxo7yBgz6bVpFHEy1o1uNJ2cpoUOaGliwJfUAHTJH/27rtc43/zS2jpWeUBspWIUXI9iZh0dqMnpdngxwZOFf7qjQkOZue4DSQ88uF/eEOiDAM/y6YRHD4QLNGTB1YDdYODsVfeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3aRxSj5xnzuACnbu7S28eI+8+NVVARzZnoqlR4OfkQ=;
 b=ZOqqKvYtrgVa16VlkcCKOqLh2G7mTX7+Zt+cEDY5t1BS+q1hSJZSH1pLsVrURAEs9dHLI7aB/47UC5hIqu5CHRZpxEurVNrIaHgVgQYC8nEqWbrvpxPdkKUQnOL7IfEKagbH7ngDTjgCqIJRg/uHja2/2nJvdlih8kZWQuIWtoMmfDK7xbJo+28s8X9MDcm+hRxwAiwb99EvX36EqC51PRlh9xfOEQW2zESz2ZR/4cNpQlJZbQHbQ/SqKnR1j1z2nvfyECMhbyAQESAcOWX5BF0f2qX/vKWDcWI3jxGPeTBS0E4drj85N6iD24PvAJ4Mvr4Q7wbfSicemPQdBHUVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3aRxSj5xnzuACnbu7S28eI+8+NVVARzZnoqlR4OfkQ=;
 b=JaNz1VU98lUEszAmdYI2x+boJlLDIhEaT51Umqpd+ZV92gHt7C9pznOooiJNWCo22bHMjx0HOcOBvc2jYTtNlxwkoaP6+4H6FIo9efgSStf35nTnL4eAY745briSi0/3QA6Dz825I2hfAsjdluBmMp8XRs4ZLzs0RHOGPxuzMos=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:31 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:31 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN tail-dropping mode
Date:   Wed, 11 Mar 2020 19:33:53 +0200
Message-Id: <20200311173356.38181-4-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:30 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c10636b-914e-4571-31e8-08d7c5e27529
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB344949137E18C16C18C00285DBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QuevtkeJcSv528MHeV5zhn6ZfwG4y1uxXN2XfVbl6JA9dLkw3GkCaBs+f3Az548mvfn3BXRAZMPPzX4fsMAQ9ot9Oi3bbh4xErNZbGPqmXn/nuSnnYsHxoNfAN6XddfDN1scqofcUL88DUeZ0ZJH/wTAoyWUiBWuPRTPe5761YLYR/UMFCYt6rIR8gaxeD0Vu8XPywxwSF33ySnAly/uzRrhhTV7ENlBhKfVjSUMwR73+jFNpkYFdwCUEJn36BN/o8FDSG3MtKJUlZd/ATgF4EtkD9ndrg8w9ao/875rcqU1/uoACcI0kzRLEiVDRmIRSjsRGkXHmC/EJ1I1FnwVeJwqInCH6q6hL5XTpkRhYoGUmAfVthOGb9es6jcM+QU5Zo5PGAwjqnlpyU1It5r39ABnwRx5PjM3T93c1D1WK27H9B6axW09/c6LaowiyzG8
X-MS-Exchange-AntiSpam-MessageData: dQE2uBrymwVQztKlr3/x9G0GA6hoOLo/CAqVl/Q0D4J9M58rlK/uuQH/KOf1SnsZoUCrbtEw+lxj1C7ydrcecE4suFF4Sm31T1vUYF9Fb+4jAN26TBzBewzMsVVkjL+VWDrhCzeQnvbEnruIabUl2g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c10636b-914e-4571-31e8-08d7c5e27529
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:31.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeNPFU/ckpISc2/oRd9Zbns6NbjO7vDaWW7g5gytM/eeRQVA5bmUhhko0lIqDsFe4s1Vp0K5ot3zR8uZmeC2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the RED Qdisc is currently configured to enable ECN, the RED algorithm
is used to decide whether a certain SKB should be marked. If that SKB is
not ECN-capable, it is early-dropped.

It is also possible to keep all traffic in the queue, and just mark the
ECN-capable subset of it, as appropriate under the RED algorithm. Some
switches support this mode, and some installations make use of it.

To that end, add a new RED flag, TC_RED_TAILDROP. When the Qdisc is
configured with this flag, non-ECT traffic is enqueued (and tail-dropped
when the queue size is exhausted) instead of being early-dropped.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - Fix red_use_taildrop() condition in red_enqueue switch for
      probabilistic case.

 include/net/pkt_cls.h          |  1 +
 include/net/red.h              |  5 +++++
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_red.c            | 31 +++++++++++++++++++++++++------
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 341a66af8d59..9ad369aba678 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -727,6 +727,7 @@ struct tc_red_qopt_offload_params {
 	u32 limit;
 	bool is_ecn;
 	bool is_harddrop;
+	bool is_taildrop;
 	struct gnet_stats_queue *qstats;
 };
 
diff --git a/include/net/red.h b/include/net/red.h
index 5718d2b25637..372b4988118c 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -200,6 +200,11 @@ static inline bool red_get_flags(unsigned char flags,
 		return false;
 	}
 
+	if ((*p_flags & TC_RED_TAILDROP) && !(*p_flags & TC_RED_ECN)) {
+		NL_SET_ERR_MSG_MOD(extack, "taildrop mode is only meaningful with ECN");
+		return false;
+	}
+
 	*p_userbits = flags & ~historic_mask;
 	return true;
 }
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 277df546e1a9..45d1c0e6444e 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -286,6 +286,7 @@ struct tc_red_qopt {
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
+#define TC_RED_TAILDROP		8
 };
 
 #define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 61d7c5a61279..1474f973ec6d 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -48,7 +48,7 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
-#define RED_SUPPORTED_FLAGS TC_RED_HISTORIC_FLAGS
+#define RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_TAILDROP)
 
 static inline int red_use_ecn(struct red_sched_data *q)
 {
@@ -60,6 +60,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
 	return q->flags & TC_RED_HARDDROP;
 }
 
+static inline int red_use_taildrop(struct red_sched_data *q)
+{
+	return q->flags & TC_RED_TAILDROP;
+}
+
 static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
@@ -80,23 +85,36 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	case RED_PROB_MARK:
 		qdisc_qstats_overlimit(sch);
-		if (!red_use_ecn(q) || !INET_ECN_set_ce(skb)) {
+		if (!red_use_ecn(q)) {
 			q->stats.prob_drop++;
 			goto congestion_drop;
 		}
 
-		q->stats.prob_mark++;
+		if (INET_ECN_set_ce(skb)) {
+			q->stats.prob_mark++;
+		} else if (!red_use_taildrop(q)) {
+			q->stats.prob_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN taildrop mode: queue it. */
 		break;
 
 	case RED_HARD_MARK:
 		qdisc_qstats_overlimit(sch);
-		if (red_use_harddrop(q) || !red_use_ecn(q) ||
-		    !INET_ECN_set_ce(skb)) {
+		if (red_use_harddrop(q) || !red_use_ecn(q)) {
 			q->stats.forced_drop++;
 			goto congestion_drop;
 		}
 
-		q->stats.forced_mark++;
+		if (INET_ECN_set_ce(skb)) {
+			q->stats.forced_mark++;
+		} else if (!red_use_taildrop(q)) {
+			q->stats.forced_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN taildrop mode: queue it. */
 		break;
 	}
 
@@ -171,6 +189,7 @@ static int red_offload(struct Qdisc *sch, bool enable)
 		opt.set.limit = q->limit;
 		opt.set.is_ecn = red_use_ecn(q);
 		opt.set.is_harddrop = red_use_harddrop(q);
+		opt.set.is_taildrop = red_use_taildrop(q);
 		opt.set.qstats = &sch->qstats;
 	} else {
 		opt.command = TC_RED_DESTROY;
-- 
2.20.1

