Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D1D20BCE7
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgFZWqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:43 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbgFZWqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWTx7rRqjlr0V3XKtSgyrieABveB6MIDR2wSFQUdc5LFp7eOVk5Cw87u4CLqRNbi2NRT6BgKVjiL+WOu4sTAprTYUn0Y2D8mLXvmA32P33CbT68tp6Sw0nSa03FNqdWqnInSU+Efn+FC80sUTXJ3MA3+uWK7o34eA/wyhxnUX+C4r3mY9UkqAP5ZFOL6TMkFuaEEu8i5Q44WhpuSTUDyQeeczuh3hxy9NvM1a1PbYzD9TaWFkpsOD4u7tBOzzYNkdZbv0gkRvIoedbGX4D/gk5Z3WZgm12XTKmmSE2xXr6tKGB5EeoyBXSfdYED7Wrv7PONwTwzNqwLLQMSVKgZGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScmF1iQzZaSZ/hBDOMN3PEwKvtwfJiWzZfYxT26Pz8k=;
 b=KnsCHJrwnOQ5ThNt4T1yUEwo3ON/tZ86bblsEECXYi5AhR12X0iHJreAYQLicZjepAqxz8PFmqzYtbq4ZG4WP7541Yf6VGcf94ARUy8LGECaIrbSvs0dXyvs/qp62v9RUhKby1vQEh1VfZxhE8X18/YIZ5foNc2OhCEBOnWZTKyAwm0+2qAEQnhjqNrzq2rbhJAq18oFVHz/vmT+mIRy61nvWoZIac0zrdgBMQzRxTTER4GpTSbr3jLwYZJN5f+KekxMTaCDurPOQ0UyKghP/rha6ARoLrCZXgPth3Egi3x9wTXmTbJB2TzlaRQSCFPXUBChIl91uWZkZhj3v2YLMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScmF1iQzZaSZ/hBDOMN3PEwKvtwfJiWzZfYxT26Pz8k=;
 b=QME7PUbmm7h5ADvN0dKWbKnh1znp12v1lW3p5PTN0GWNyAhs7CC9xC4Yw7p65wp1P0dYwjVMi7agnX4IRrYdUVm7+099iIPO+ZJhBt7vXpcXlaI5gfUx+U4buzkj/YzPAKXuysGXUZskdDeVPg4u9FE4cG90il5swYrw51jx23I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:15 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:15 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v1 4/5] net: sched: sch_red: Add qevents "early_drop" and "mark"
Date:   Sat, 27 Jun 2020 01:45:28 +0300
Message-Id: <e86ad149f5152544778d6c16585348c85fd91df5.1593209494.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:13 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ebc4f697-996c-4ff2-9af7-08d81a22bb6e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB31960C2FF2A8119CEFF2650EDB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkGqbkUyn1QCk1u0PoHxUJdf1BLMMW/x1KklcISknPpT16sw/auFFfOkL0zxLraY2hBweNEJTePF93Lg2eQBKw0vQ+cyStpOwnOzKgr+GlzMkN64YH/45njAwsKidV+q/NOtdOLdzcK4NAJw2hih88BpKlcETlnCqtV80v4zjCsYOC/dyVUdkXIX8ZwoHCf5jffMk96zm22QVgr2P56aoIMa1rw3VrZsyP4GDr4ZRPr+b9rwQWa3i8OO4GIJ0V+tpHBDUkMx4XNqjqSu2E13+9cPr95kCF+jAxeSuslTsiVN23qI6fdRWHYXi+82wuCNpQfT8UNMht0kPXhsWbXUAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UHEAvjNkJfZJNUQOIPMXzM8Q0/3yfXoEItkvdPA31WwInKSIGMDMY/ax+S0140ryz4/hCHOutt+Iq6vEU/zq+PWIjfeMQBx1lejssPSqNL6Qw9+uYn3bdQe5Wg7OcLZb32YJF1D4xsfAZDzLhOmQ6My6/f3Y1lPKVtC1u6GLeJvfUbP3Emfqp+f6OvyQQRfF78fXQHhs+ZKqhiBwS3VIQPe9S7r/V674FTCsbu6z7DyZx2mHqnXcMxAmbke1b4rtIkd0yRHWwO+9gunCBBQ21LputOFNdgc3AIsKfUCUjgn0Tu+wAcYqD/4zoNUCLBr6jOvQd2Cg1awbK0X2oNiVs9gKG4Svo6KwIg2yyLP+sXyEdrJ0T6uaoF6F9/rE7ehX8TyhYGbIGho5Hjjm7Y9n2Z0ykwJpLN7tsTFq+20yU4fF8zV/2EloHv9gUhHYhmrLJvIWBFgp8DYOYTXBiZBffR4ViRu8d8/0QUsIBZSOFqg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc4f697-996c-4ff2-9af7-08d81a22bb6e
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:15.1241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DCP90KLn+rq7+015tGDLqBFTjDy3oUhe0ciIEiH16+poUI7zWQEY5g5W76R2eZ42mkeGRj+6ti6BYxIh/iA43g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow acting on dropped and/or ECN-marked packets, add two new
qevents to the RED qdisc: "early_drop" and "mark". Filters attached at
"early_drop" block are executed as packets are early-dropped, those
attached at the "mark" block are executed as packets are ECN-marked.

Two new attributes are introduced: TCA_RED_EARLY_DROP_BLOCK with the block
index for the "early_drop" qevent, and TCA_RED_MARK_BLOCK for the "mark"
qevent. Absence of these attributes signifies "don't care": no block is
allocated in that case, or the existing blocks are left intact in case of
the change callback.

For purposes of offloading, blocks attached to these qevents appear with
newly-introduced binder types, FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP and
FLOW_BLOCK_BINDER_TYPE_RED_MARK.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/flow_offload.h     |  2 ++
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_red.c            | 58 ++++++++++++++++++++++++++++++++--
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311a0433..d63a6a164bf4 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -419,6 +419,8 @@ enum flow_block_binder_type {
 	FLOW_BLOCK_BINDER_TYPE_UNSPEC,
 	FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
+	FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP,
+	FLOW_BLOCK_BINDER_TYPE_RED_MARK,
 };
 
 struct flow_block {
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index a95f3ae7ab37..9e7c2c607845 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -257,6 +257,8 @@ enum {
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
 	TCA_RED_FLAGS,		/* bitfield32 */
+	TCA_RED_EARLY_DROP_BLOCK, /* u32 */
+	TCA_RED_MARK_BLOCK,	/* u32 */
 	__TCA_RED_MAX,
 };
 
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 225ce370e5a8..de2be4d04ed6 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -46,6 +46,8 @@ struct red_sched_data {
 	struct red_vars		vars;
 	struct red_stats	stats;
 	struct Qdisc		*qdisc;
+	struct tcf_qevent	qe_early_drop;
+	struct tcf_qevent	qe_mark;
 };
 
 #define TC_RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
@@ -92,6 +94,9 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 
 		if (INET_ECN_set_ce(skb)) {
 			q->stats.prob_mark++;
+			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, root_lock, to_free, &ret);
+			if (!skb)
+				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
 			q->stats.prob_drop++;
 			goto congestion_drop;
@@ -109,6 +114,9 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 
 		if (INET_ECN_set_ce(skb)) {
 			q->stats.forced_mark++;
+			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, root_lock, to_free, &ret);
+			if (!skb)
+				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
 			q->stats.forced_drop++;
 			goto congestion_drop;
@@ -129,6 +137,10 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 	return ret;
 
 congestion_drop:
+	skb = tcf_qevent_handle(&q->qe_early_drop, sch, skb, root_lock, to_free, &ret);
+	if (!skb)
+		return NET_XMIT_CN | ret;
+
 	qdisc_drop(skb, sch, to_free);
 	return NET_XMIT_CN;
 }
@@ -202,6 +214,8 @@ static void red_destroy(struct Qdisc *sch)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
 
+	tcf_qevent_destroy(&q->qe_mark, sch);
+	tcf_qevent_destroy(&q->qe_early_drop, sch);
 	del_timer_sync(&q->adapt_timer);
 	red_offload(sch, false);
 	qdisc_put(q->qdisc);
@@ -213,6 +227,8 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
 	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
 	[TCA_RED_MAX_P] = { .type = NLA_U32 },
 	[TCA_RED_FLAGS] = NLA_POLICY_BITFIELD32(TC_RED_SUPPORTED_FLAGS),
+	[TCA_RED_EARLY_DROP_BLOCK] = { .type = NLA_U32 },
+	[TCA_RED_MARK_BLOCK] = { .type = NLA_U32 },
 };
 
 static int __red_change(struct Qdisc *sch, struct nlattr **tb,
@@ -328,12 +344,38 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 	q->qdisc = &noop_qdisc;
 	q->sch = sch;
 	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
-	return __red_change(sch, tb, extack);
+
+	err = __red_change(sch, tb, extack);
+	if (err)
+		return err;
+
+	err = tcf_qevent_init(&q->qe_early_drop, sch,
+			      FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP,
+			      tb[TCA_RED_EARLY_DROP_BLOCK], extack);
+	if (err)
+		goto err_early_drop_init;
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
+	tcf_qevent_destroy(&q->qe_early_drop, sch);
+err_early_drop_init:
+	del_timer_sync(&q->adapt_timer);
+	red_offload(sch, false);
+	qdisc_put(q->qdisc);
+	return err;
 }
 
 static int red_change(struct Qdisc *sch, struct nlattr *opt,
 		      struct netlink_ext_ack *extack)
 {
+	struct red_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_RED_MAX + 1];
 	int err;
 
@@ -345,6 +387,16 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	err = tcf_qevent_validate_change(&q->qe_early_drop,
+					 tb[TCA_RED_EARLY_DROP_BLOCK], extack);
+	if (err)
+		return err;
+
+	err = tcf_qevent_validate_change(&q->qe_mark,
+					 tb[TCA_RED_MARK_BLOCK], extack);
+	if (err)
+		return err;
+
 	return __red_change(sch, tb, extack);
 }
 
@@ -389,7 +441,9 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
 	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P) ||
 	    nla_put_bitfield32(skb, TCA_RED_FLAGS,
-			       q->flags, TC_RED_SUPPORTED_FLAGS))
+			       q->flags, TC_RED_SUPPORTED_FLAGS) ||
+	    tcf_qevent_dump(skb, TCA_RED_MARK_BLOCK, &q->qe_mark) ||
+	    tcf_qevent_dump(skb, TCA_RED_EARLY_DROP_BLOCK, &q->qe_early_drop))
 		goto nla_put_failure;
 	return nla_nest_end(skb, opts);
 
-- 
2.20.1

