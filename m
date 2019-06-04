Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7934EFE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFDRet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:34:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47016 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFDRet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:34:49 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 803CD9C0076;
        Tue,  4 Jun 2019 17:34:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 4 Jun
 2019 10:34:43 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v4 net-next 4/4] net/sched: call action stats offload in
 flower or mall dump
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Message-ID: <ed9e6ace-4997-9054-806e-1e6c8bc37a00@solarflare.com>
Date:   Tue, 4 Jun 2019 18:34:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24656.005
X-TM-AS-Result: No-1.439900-4.000000-10
X-TMASE-MatchedRID: aYY/z8vMijyh9oPbMj7PPFFSD47VOxuSsKzLQnnS/xwGmHr1eMxt2VMe
        5Blkpry7rdoLblq9S5rMJYD0aRF0RV/gigjYmFkNGjzBgnFZvQ7gXnxE81iysY5JUK9UdYknVJ3
        kOqZYJFYNUQt57QDCkLIOm0VPglY2I7HU13GYiCjlvSeYSYEULH0tCKdnhB58vqq8s2MNhPCZMP
        CnTMzfOiq2rl3dzGQ1PKufoifxElo5MkPRb9tyWkpZbvMu9ruFnvxCLTPh8vJktC5ZhPtd0g5CC
        bL5rMRQpjnlkRjMYHGL4JeB4aASVKx+ULyKAeAkl0kb426sKbJDgw2OfwbhLKMa5OkNpiHkifsL
        +6CY4RnJZmo0UvMlsUMMprcbiest
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.439900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24656.005
X-MDID: 1559669688-1HSOQ2p1LuiP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers that support per-action stats should implement TC_ACTION_STATS
 rather than TC_CLSFLOWER_STATS/TC_CLSMATCHALL_STATS.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 include/net/act_api.h      | 5 +++++
 include/net/flow_offload.h | 1 +
 net/sched/act_api.c        | 3 ++-
 net/sched/cls_api.c        | 1 +
 net/sched/cls_flower.c     | 6 ++++++
 net/sched/cls_matchall.c   | 5 +++++
 6 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 38d1769f279b..76054524a2de 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -187,6 +187,11 @@ int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct netlink_ext_ack *newchain);
 struct tcf_chain *tcf_action_set_ctrlact(struct tc_action *a, int action,
 					 struct tcf_chain *newchain);
+void tcf_action_update_stats(struct tc_action *a);
+#else /* CONFIG_NET_CLS_ACT */
+static inline void tcf_action_update_stats(struct tc_action *a)
+{
+}
 #endif /* CONFIG_NET_CLS_ACT */
 
 static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d526696958f6..813a91ae9d9a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -140,6 +140,7 @@ enum flow_action_mangle_base {
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	bool				want_stats;
 	unsigned long			cookie;
 	union {
 		u32			chain_index;	/* FLOW_ACTION_GOTO */
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 239fc28456d9..82f9c1f1acd6 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -754,7 +754,7 @@ tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	return a->ops->dump(skb, a, bind, ref);
 }
 
-static void tcf_action_update_stats(struct tc_action *a)
+void tcf_action_update_stats(struct tc_action *a)
 {
 	struct tc_action_block_binding *bind;
 	struct tc_action_offload offl = {};
@@ -767,6 +767,7 @@ static void tcf_action_update_stats(struct tc_action *a)
 	tcf_action_stats_update(a, offl.stats.bytes, offl.stats.pkts,
 				offl.stats.lastused, true);
 }
+EXPORT_SYMBOL(tcf_action_update_stats);
 
 int
 tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5411cec17af5..bb9b0d7ec1c0 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3195,6 +3195,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
+		entry->want_stats = act->ops && act->ops->stats_update;
 		entry->cookie = (unsigned long)act;
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 252d102702bb..fcd5615ca2bc 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -477,6 +477,8 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 {
 	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = tp->chain->block;
+	struct tc_action *act;
+	int i;
 
 	if (!rtnl_held)
 		rtnl_lock();
@@ -492,6 +494,10 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 			      cls_flower.stats.pkts,
 			      cls_flower.stats.lastused);
 
+	tcf_exts_for_each_action(i, act, &f->exts)
+		if (act->ops && act->ops->stats_update)
+			tcf_action_update_stats(act);
+
 	if (!rtnl_held)
 		rtnl_unlock();
 }
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 5cb4832d1b3b..c51beed83b1e 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -338,6 +338,8 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 {
 	struct tc_cls_matchall_offload cls_mall = {};
 	struct tcf_block *block = tp->chain->block;
+	struct tc_action *act;
+	int i;
 
 	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, NULL);
 	cls_mall.command = TC_CLSMATCHALL_STATS;
@@ -347,6 +349,9 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 
 	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
 			      cls_mall.stats.pkts, cls_mall.stats.lastused);
+	tcf_exts_for_each_action(i, act, &head->exts)
+		if (act->ops && act->ops->stats_update)
+			tcf_action_update_stats(act);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
