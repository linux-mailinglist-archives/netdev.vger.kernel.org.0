Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC11FE9D2A
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfJ3OJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55245 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbfJ3OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDe020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 4/8] net: sched: don't expose action qstats to skb_tc_reinsert()
Date:   Wed, 30 Oct 2019 16:09:03 +0200
Message-Id: <20191030140907.18561-5-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous commit introduced helper function for updating qstats and
refactored set of actions to use the helpers, instead of modifying qstats
directly. However, one of the affected action exposes its qstats to
skb_tc_reinsert(), which then modifies it.

Refactor skb_tc_reinsert() to return integer error code and don't increment
overlimit qstats in case of error, and use the returned error code in
tcf_mirred_act() to manually increment the overlimit counter with new
helper function.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/sch_generic.h | 12 ++----------
 net/sched/act_mirred.c    |  4 ++--
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 637548d54b3e..a8b0a9a4c686 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1286,17 +1286,9 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 			  struct mini_Qdisc __rcu **p_miniq);
 
-static inline void skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
+static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
 {
-	struct gnet_stats_queue *stats = res->qstats;
-	int ret;
-
-	if (res->ingress)
-		ret = netif_receive_skb(skb);
-	else
-		ret = dev_queue_xmit(skb);
-	if (ret && stats)
-		qstats_overlimit_inc(res->qstats);
+	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
 }
 
 #endif
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 49a378a5b4fa..ae1129aaf3c0 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -289,8 +289,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-			res->qstats = this_cpu_ptr(m->common.cpu_qstats);
-			skb_tc_reinsert(skb, res);
+			if (skb_tc_reinsert(skb, res))
+				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}
-- 
2.21.0

