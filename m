Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192FF183D18
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCLXMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:12:50 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:26253
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbgCLXMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:12:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itJtFqoce/FvyHjQjdo8ptzITkDu76WkNzS4Q7/RleG35HBQ2QVING4e8+iF5LatJJBM31BCmIMoGuO4b2LkPO93A1M6z95hjMZScZ3bnuaz6egvufkBb9JISOo447zGQcDMTIv6tvGv9R/uIwp9+6H5FhzoDyOMhbHLuLGG+CyHm07f/L6Y8k0hTUBbrBxnLb8B2S4p/lXAQYtIrJOhVsisXNbJrmEseUeHwl+Qmtqy6Z+iuZXXMkvH+St2CxY2wrbwThhSY0MLoITSxBNwjUCvyWoAeDMmxHM54mNw63bqwzHb/0CARXHaYQxnZFYugOhihua23dcHF+kMLWgmhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3TxnIf0qkF2GqLdvkqTYIE7x2yZD3r6oGFwcsB2ugM=;
 b=hxZ7g0yzi66/IqV3p40EuzxbUo+HUubnUffQ0xAn/K7TSZJbaoNTP7yU40/y8RyM/MbI2TDEILRf5fxNd/J7GvocxKUniCnI5k532xqYp2Ynu/klFVpxsHPGXV/2OvKCsaIROQlnxs+ujrAcOf9mYVcg3qAj0IAbP+xXVJ1Oq3a10hu/cgspEP7t2J/aVrOdDdtz/1A3k6gO2YQ6oPocOtJ3tkfmPvtPPYCU5DDYvmabXFyAgFTCnR/mY+sPsEvcNRkvHJDoh+Q479/eUxGhiQzAKd6xPU2zgygeXlmMUS66azgZ/zSWoa6FKX/Z0F9jRFXt64sjXqJ6WW/KvixBxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3TxnIf0qkF2GqLdvkqTYIE7x2yZD3r6oGFwcsB2ugM=;
 b=qNOenQquV9z4xrGVfAsIhXIGa8ODKPWh7+M03CfNcsG3YKdEGtfLz0TcgVWew8B9OIbEeeWJNaEQgKOZr+nhl6ejIx5dU3pu7X5MhECCWAQX9AjUeSg3WhQj0NnMihjZPISqzL+6OaAuWLYotrc4TbjXU5Lm0s+rnmxrKQ/2i+k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3194.eurprd05.prod.outlook.com (10.170.241.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 23:12:40 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:12:40 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v4 3/6] net: sched: RED: Introduce an ECN nodrop mode
Date:   Fri, 13 Mar 2020 01:10:57 +0200
Message-Id: <20200312231100.37180-4-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312231100.37180-1-petrm@mellanox.com>
References: <20200312231100.37180-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 23:12:39 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d1d5183-5dc7-4842-5d07-08d7c6dadcc5
X-MS-TrafficTypeDiagnostic: HE1PR05MB3194:|HE1PR05MB3194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3194C5875CBC3AEF2B54C220DBFD0@HE1PR05MB3194.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(316002)(2906002)(66556008)(8676002)(66476007)(66946007)(4326008)(54906003)(81156014)(81166006)(6666004)(36756003)(1076003)(5660300002)(6512007)(6506007)(6486002)(52116002)(478600001)(16526019)(107886003)(26005)(8936002)(6916009)(956004)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3194;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rq8QQx9pOUW+tlOSYMgKLUv+da5InkVasgAITSqwjSDZYtjLsLy/g8EEtWjHNhTrF2ac2cr+NhqIp7dgAgfBorvTWVB9H3yoNTSgv3nQJ3G/tFMnMHXo4gn/ah1hwjcbe14EuXM2j3t0+DU3mXbzg6v2UipDYOz9sb3qirZZJSIJwxfFIYFWi7SBRjm0Fce2mVzRC5myEk5d/0G79Wp1+nKZYgum9YrxaasnG3i5nw43JfBBU5gvWKPf0vy2HDLxmBowDy+NFKzMTnXZHaEB0zhNnGcr8//umQuYBdYS6lLhTrRmkjhmkJ5x3PjuVi6Lpp/SqMZFJ9Y0cQCL6wfWLeE+FJrsQ4UlhaBviqc2PqnH3iumHC/J6VvmVaSgyIW3WI2/kTVS6ByHm2OdyqUEkzWbw6z2w9FFWYGtK5a4ZjCoExeSxDku/sPGsV/msPau
X-MS-Exchange-AntiSpam-MessageData: oynpXMX8YR0ue1QDMZioA2Ix1pOBRphUgsW5gY3aQosf0cugsV5OYJU1LqRLTrQJC2qrZn1+NHOQwK3X73Kq8vc7Ql1TBQ8pTvTn5hDAzn6HeiW+ySdHa9ThyZUBBqsu0jfbl3ap6ZhrgK+NTU82wQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1d5183-5dc7-4842-5d07-08d7c6dadcc5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:12:40.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYZ8VFiBkWPRMsImbSQOie+tLRoGApadLvI4AUmPnEMWMJ+q28sfLoQ4eAKnGC6lL74MUcHiOak7E3ojCAHKDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3194
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

To that end, add a new RED flag, TC_RED_NODROP. When the Qdisc is
configured with this flag, non-ECT traffic is enqueued instead of being
early-dropped.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---

Notes:
    v3:
    - Rename "taildrop" to "nodrop"
    - Make red_use_nodrop() static instead of static inline
    
    v2:
    - Fix red_use_taildrop() condition in red_enqueue switch for
      probabilistic case.

 include/net/pkt_cls.h          |  1 +
 include/net/red.h              |  5 +++++
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_red.c            | 31 +++++++++++++++++++++++++------
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 341a66af8d59..e7e279ad8694 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -727,6 +727,7 @@ struct tc_red_qopt_offload_params {
 	u32 limit;
 	bool is_ecn;
 	bool is_harddrop;
+	bool is_nodrop;
 	struct gnet_stats_queue *qstats;
 };
 
diff --git a/include/net/red.h b/include/net/red.h
index 6a2aaa6c7c41..fc455445f4b2 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -209,6 +209,11 @@ static inline int red_get_flags(unsigned char qopt_flags,
 static inline int red_validate_flags(unsigned char flags,
 				     struct netlink_ext_ack *extack)
 {
+	if ((flags & TC_RED_NODROP) && !(flags & TC_RED_ECN)) {
+		NL_SET_ERR_MSG_MOD(extack, "nodrop mode is only meaningful with ECN");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 6325507935ea..ea39287d59c8 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -286,6 +286,7 @@ struct tc_red_qopt {
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
+#define TC_RED_NODROP		8
 };
 
 #define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index d4ce111704dc..3ef0a4f7399b 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -48,7 +48,7 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
-static const u32 red_supported_flags = TC_RED_HISTORIC_FLAGS;
+static const u32 red_supported_flags = TC_RED_HISTORIC_FLAGS | TC_RED_NODROP;
 
 static inline int red_use_ecn(struct red_sched_data *q)
 {
@@ -60,6 +60,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
 	return q->flags & TC_RED_HARDDROP;
 }
 
+static int red_use_nodrop(struct red_sched_data *q)
+{
+	return q->flags & TC_RED_NODROP;
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
+		} else if (!red_use_nodrop(q)) {
+			q->stats.prob_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN nodrop mode: queue it. */
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
+		} else if (!red_use_nodrop(q)) {
+			q->stats.forced_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN nodrop mode: queue it. */
 		break;
 	}
 
@@ -171,6 +189,7 @@ static int red_offload(struct Qdisc *sch, bool enable)
 		opt.set.limit = q->limit;
 		opt.set.is_ecn = red_use_ecn(q);
 		opt.set.is_harddrop = red_use_harddrop(q);
+		opt.set.is_nodrop = red_use_nodrop(q);
 		opt.set.qstats = &sch->qstats;
 	} else {
 		opt.command = TC_RED_DESTROY;
-- 
2.20.1

