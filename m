Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C707E9D26
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfJ3OJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55246 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726268AbfJ3OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDd020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 3/8] net: sched: extract qstats update code into functions
Date:   Wed, 30 Oct 2019 16:09:02 +0200
Message-Id: <20191030140907.18561-4-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract common code that increments cpu_qstats counters into standalone act
API functions. Change hardware offloaded actions that use percpu counter
allocation to use the new functions instead of accessing cpu_qstats
directly.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h  | 16 ++++++++++++++++
 net/sched/act_csum.c   |  2 +-
 net/sched/act_ct.c     |  2 +-
 net/sched/act_gact.c   |  2 +-
 net/sched/act_mirred.c |  2 +-
 net/sched/act_vlan.c   |  2 +-
 6 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9a32853f77f9..8d6861ce205b 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -193,6 +193,22 @@ static inline void tcf_action_update_bstats(struct tc_action *a,
 	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
 }
 
+static inline struct gnet_stats_queue *
+tcf_action_get_qstats(struct tc_action *a)
+{
+	return this_cpu_ptr(a->cpu_qstats);
+}
+
+static inline void tcf_action_inc_drop_qstats(struct tc_action *a)
+{
+	qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+}
+
+static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
+{
+	qstats_overlimit_inc(this_cpu_ptr(a->cpu_qstats));
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 			     bool drop, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 69747b1860aa..bc909cf72257 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -624,7 +624,7 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 	return action;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(p->common.cpu_qstats));
+	tcf_action_inc_drop_qstats(&p->common);
 	action = TC_ACT_SHOT;
 	goto out;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f9779907dcf7..eabae2227e13 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -469,7 +469,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	return retval;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+	tcf_action_inc_drop_qstats(&c->common);
 	return TC_ACT_SHOT;
 }
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index a7e3d5621608..221f0c2e26b1 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -163,7 +163,7 @@ static int tcf_gact_act(struct sk_buff *skb, const struct tc_action *a,
 #endif
 	tcf_action_update_bstats(&gact->common, skb);
 	if (action == TC_ACT_SHOT)
-		qstats_drop_inc(this_cpu_ptr(gact->common.cpu_qstats));
+		tcf_action_inc_drop_qstats(&gact->common);
 
 	tcf_lastuse_update(&gact->tcf_tm);
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index e5216f80883b..49a378a5b4fa 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -303,7 +303,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 	if (err) {
 out:
-		qstats_overlimit_inc(this_cpu_ptr(m->common.cpu_qstats));
+		tcf_action_inc_overlimit_qstats(&m->common);
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index f6dccaa29239..ffa0f431aa84 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -88,7 +88,7 @@ static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
 	return action;
 
 drop:
-	qstats_drop_inc(this_cpu_ptr(v->common.cpu_qstats));
+	tcf_action_inc_drop_qstats(&v->common);
 	return TC_ACT_SHOT;
 }
 
-- 
2.21.0

