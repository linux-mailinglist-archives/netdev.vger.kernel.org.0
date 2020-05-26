Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB281E27FE
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgEZRKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:43 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728444AbgEZRKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8V9sB5JY4V5xZm/tFLacH8sqvBY9eVR/tX0oH79QNks70VXsTZ2HXk9E7NpBWo/JHt1Nifkv+DX+y73I+3wKUw9L0sfNXBefhAZysKNpp8Id5kqGsv8veTGw5kkH2pOOg8MAGkiNQNzBVGLrFdVWpeqXpSiTHENwKGU60Z2e9PDnZIbnCxPYWbhDHWyNJ/m/4teA+I8sGvtyQx8RUFBwFHd9PUsQuqLacL5hA3HDZa/IMxQ7PmXGR9U7IcgSfDPIvQ2Kxn+Aguna96nNpAEbHhT4Qje63qTLn8kgA3CfosixxYqR/POe2LZAqY/88jUSLBPIZggSnTymC2q/fi+cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALLyRWl7V771Gc9eTXXcQ2OaSqs9U262I63I4vzV9Kw=;
 b=BOTMkf5HC10idluZnwWXjVfv7Zk+NRTflg1HQJ6iUFP9XX0nCtkg8hcQEIVyD3ouumVim8cP8DUlGM2npYQTsVUikLihCCKDcdl2rpP8B1KIGWrfWKFsk3c9v3cWfgBeRC1yUxMQYY4y7B9b8Fi6SeN7Eps2/t2SZr6j++Bvq5uWsgdZzq7jth2ccEwJm0UxoyO7um/m0T1x6Vxg/Gh2hGFR09f1eTTGU6vs6z303MqxPM6+kRw+ZkS/QvYKq8pJ/eSewBfpoGTU4JgwejlMmLUyDj6TAYr3BxPqzUsikOEjzsQ7jXG6k3Czm8/OqNTVFL0H6kdw+uvbdjWx6m+fcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALLyRWl7V771Gc9eTXXcQ2OaSqs9U262I63I4vzV9Kw=;
 b=ClY0eJawa/Fi+8Mz27rmbvVVvxKHGsXSx2tLLI70gtyHWwuQ7/7d0auIyfoQ7uYx+I63SKPpKtBpfmy+lI4E8qc/nupPevtBk8wq6gnj3HQJlqIU4sxSZ5csg/j+ezzjoE8R8PRDJTpPlKEdyOBQN13CRJkB7hwU2HxMxrKeLVE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:34 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:34 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH net-next 3/3] net: sched: sch_red: Add qevents "early" and "mark"
Date:   Tue, 26 May 2020 20:10:07 +0300
Message-Id: <7c4c0ee1b5c4e0af61dc4ffb199df78b93499879.1590512901.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1590512901.git.petrm@mellanox.com>
References: <cover.1590512901.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:33 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7cca7565-4df6-4db9-1eee-08d80197b3cc
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB32259D8E5059EEF7BB693BA2DBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9s09jZ7KMauCpviaCE4ZbEuhMYmCzKKCQ/a/z3BTIwuPMWylC9Dql6xOMExl2uUo6aOWzG/bHlxx17twriQJGKlXDAoqXSB5zleQi/IuOFbhn5bixvF5fRJYaWtPjLSHPe1icU+EcOiRELpASp5JntPCRWPfcc/kUzcGfBldy6Y46NS7isvIHcjKprCKBy0RGSIB07+lUP1p+jnH4AqSmyeaORSGMTsZSmKQoo6ePbeRvXLaupj8j4sxGDN3tahZIJOBrgsEVZERbLy3Wa6mYKXfQjdydHfaWKYTa7Ias8hwe05+Tgsgvu9J6r4KRygLhwnk6JYay45U3e/OFoLPAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1pIZbMsmhpPvYTDSQdDCRP6QxQQC7znXVGhrpumROduicAbqe15tJVBbi7SReL0Dx/bRFLd4kYpRgM+wNqU1g8XwYQLw5VoeBwd3s4sj+rteyD/idJRH0gG0DETkz5Oa20A6BVGf6QpzsbxiTh2Mv+Lpb7C0sy1px+GGG1DDDnabJuvRTTWVTLy6IOsMcl5B+IMXMTf3zlk/v0ry6SA6fQnl3qob5WkXwBI4xiV+VPetUS7++BUb5aqOodfLEI1Z011+t4QrK6DMDzDgTe2cd3zQSiIcyCI4xLTQ6av21pUc3GThWds4Fg5d6zvZYIBpPoNL9FAZrs0ew0t8emliL71PqajORXVkDyEVXdXBUxhBkNaoZVxfX1AjyKw/cpr59+ZcGbl9BkLji6pifXDXKg1gdkMyXV3sPEil8jqbJreM1dbt3X1r3oZCxcrCE1i43zuvLdzgsympGsojURzk+KrQd/LlG0W7+36nGmZc/W04Y6QBLbTZdg9TI6XpFn0T
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cca7565-4df6-4db9-1eee-08d80197b3cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:34.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFRH37/CSpOQNY8xRTp0PTW7k2BHwFTVmZU7+u8dMJSElPGz8T3WePtmdrxPViyQ22GoE3xrUZisZ3S7mWgOVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow acting on dropped and/or ECN-marked packets, add two new
qevents to the RED qdisc: "early" and "mark". Filters attached at "early"
block are executed as packets are early-dropped, those attached at the
"mark" block are executed as packets are ECN-marked.

Two new attributes are introduced: TCA_RED_EARLY_BLOCK with the block index
for the "early" qevent, and TCA_RED_MARK_BLOCK for the "mark" qevent.
Absence of these attributes signifies "don't care": no block is allocated
in that case, or the existing blocks are left intact in case of the change
callback.

For purposes of offloading, blocks attached to these qevents appear with
newly-introduced binder types, FLOW_BLOCK_BINDER_TYPE_RED_EARLY and
FLOW_BLOCK_BINDER_TYPE_RED_MARK.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/flow_offload.h     |  2 ++
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_red.c            | 59 +++++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 4001ffb04f0d..635d2bb57550 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -416,6 +416,8 @@ enum flow_block_binder_type {
 	FLOW_BLOCK_BINDER_TYPE_UNSPEC,
 	FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
+	FLOW_BLOCK_BINDER_TYPE_RED_EARLY,
+	FLOW_BLOCK_BINDER_TYPE_RED_MARK,
 };
 
 struct flow_block {
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index a95f3ae7ab37..ff3f4830e049 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -257,6 +257,8 @@ enum {
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
 	TCA_RED_FLAGS,		/* bitfield32 */
+	TCA_RED_EARLY_BLOCK,	/* u32 */
+	TCA_RED_MARK_BLOCK,	/* u32 */
 	__TCA_RED_MAX,
 };
 
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index c52a40ad5e59..0c6a6429ca02 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -46,6 +46,8 @@ struct red_sched_data {
 	struct red_vars		vars;
 	struct red_stats	stats;
 	struct Qdisc		*qdisc;
+	struct tcf_qevent	qe_early;
+	struct tcf_qevent	qe_mark;
 };
 
 #define TC_RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
@@ -92,6 +94,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		if (INET_ECN_set_ce(skb)) {
 			q->stats.prob_mark++;
+			skb = tcf_qevent_handle(&q->qe_mark, sch,
+						skb, to_free, &ret);
+			if (!skb)
+				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
 			q->stats.prob_drop++;
 			goto congestion_drop;
@@ -109,6 +115,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		if (INET_ECN_set_ce(skb)) {
 			q->stats.forced_mark++;
+			skb = tcf_qevent_handle(&q->qe_mark, sch,
+						skb, to_free, &ret);
+			if (!skb)
+				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
 			q->stats.forced_drop++;
 			goto congestion_drop;
@@ -129,6 +139,11 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return ret;
 
 congestion_drop:
+	skb = tcf_qevent_handle(&q->qe_early, sch,
+				skb, to_free, &ret);
+	if (!skb)
+		return NET_XMIT_CN | ret;
+
 	qdisc_drop(skb, sch, to_free);
 	return NET_XMIT_CN;
 }
@@ -202,6 +217,8 @@ static void red_destroy(struct Qdisc *sch)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 
+	tcf_qevent_destroy(&q->qe_mark, sch);
+	tcf_qevent_destroy(&q->qe_early, sch);
 	del_timer_sync(&q->adapt_timer);
 	red_offload(sch, false);
 	qdisc_put(q->qdisc);
@@ -213,6 +230,8 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
 	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
 	[TCA_RED_MAX_P] = { .type = NLA_U32 },
 	[TCA_RED_FLAGS] = NLA_POLICY_BITFIELD32(TC_RED_SUPPORTED_FLAGS),
+	[TCA_RED_EARLY_BLOCK] = { .type = NLA_U32 },
+	[TCA_RED_MARK_BLOCK] = { .type = NLA_U32 },
 };
 
 static int __red_change(struct Qdisc *sch, struct nlattr **tb,
@@ -328,7 +347,35 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 	q->qdisc = &noop_qdisc;
 	q->sch = sch;
 	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
-	return __red_change(sch, tb, extack);
+
+	q->qe_early.attr_name = TCA_RED_EARLY_BLOCK;
+	q->qe_mark.attr_name = TCA_RED_MARK_BLOCK;
+
+	err = __red_change(sch, tb, extack);
+	if (err)
+		return err;
+
+	err = tcf_qevent_init(&q->qe_early, sch,
+			      FLOW_BLOCK_BINDER_TYPE_RED_EARLY,
+			      tb[TCA_RED_EARLY_BLOCK], extack);
+	if (err)
+		goto err_early_init;
+
+	err = tcf_qevent_init(&q->qe_mark, sch,
+			      FLOW_BLOCK_BINDER_TYPE_RED_MARK,
+			      tb[TCA_RED_MARK_BLOCK], extack);
+	if (err)
+		goto err_mark_init;
+
+	return 0;
+
+err_mark_init:
+	tcf_qevent_destroy(&q->qe_early, sch);
+err_early_init:
+	del_timer_sync(&q->adapt_timer);
+	red_offload(sch, false);
+	qdisc_put(q->qdisc);
+	return err;
 }
 
 static int red_change(struct Qdisc *sch, struct nlattr *opt,
@@ -346,6 +393,16 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	err = tcf_qevent_validate_change(&q->qe_early, tb[TCA_RED_EARLY_BLOCK],
+					 extack);
+	if (err)
+		return err;
+
+	err = tcf_qevent_validate_change(&q->qe_mark, tb[TCA_RED_MARK_BLOCK],
+					 extack);
+	if (err)
+		return err;
+
 	return __red_change(sch, tb, extack);
 }
 
-- 
2.20.1

