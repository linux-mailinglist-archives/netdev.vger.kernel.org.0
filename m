Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39319E9D29
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfJ3OJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55249 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726328AbfJ3OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDc020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 2/8] net: sched: extract bstats update code into function
Date:   Wed, 30 Oct 2019 16:09:01 +0200
Message-Id: <20191030140907.18561-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract common code that increments cpu_bstats counter into standalone act
API function. Change hardware offloaded actions that use percpu counter
allocation to use the new function instead of incrementing cpu_bstats
directly.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h      | 7 +++++++
 net/sched/act_csum.c       | 2 +-
 net/sched/act_ct.c         | 2 +-
 net/sched/act_gact.c       | 2 +-
 net/sched/act_mirred.c     | 2 +-
 net/sched/act_tunnel_key.c | 2 +-
 net/sched/act_vlan.c       | 2 +-
 7 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index f6f66c692385..9a32853f77f9 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -186,6 +186,13 @@ int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
 int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
+
+static inline void tcf_action_update_bstats(struct tc_action *a,
+					    struct sk_buff *skb)
+{
+	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+}
+
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 			     bool drop, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index d3cfad88dc3a..69747b1860aa 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -580,7 +580,7 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 	params = rcu_dereference_bh(p->params);
 
 	tcf_lastuse_update(&p->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(p->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&p->common, skb);
 
 	action = READ_ONCE(p->tcf_action);
 	if (unlikely(action == TC_ACT_SHOT))
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ba76857754e5..f9779907dcf7 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -465,7 +465,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	skb_push_rcsum(skb, nh_ofs);
 
 out:
-	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+	tcf_action_update_bstats(&c->common, skb);
 	return retval;
 
 drop:
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 569cec63d4c3..a7e3d5621608 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -161,7 +161,7 @@ static int tcf_gact_act(struct sk_buff *skb, const struct tc_action *a,
 		action = gact_rand[ptype](gact);
 	}
 #endif
-	bstats_cpu_update(this_cpu_ptr(gact->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&gact->common, skb);
 	if (action == TC_ACT_SHOT)
 		qstats_drop_inc(this_cpu_ptr(gact->common.cpu_qstats));
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 621686a6b5be..e5216f80883b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -231,7 +231,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	tcf_lastuse_update(&m->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&m->common, skb);
 
 	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
 	m_eaction = READ_ONCE(m->tcfm_eaction);
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2f83a79f76aa..9ab2d3b4a9fc 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -31,7 +31,7 @@ static int tunnel_key_act(struct sk_buff *skb, const struct tc_action *a,
 	params = rcu_dereference_bh(t->params);
 
 	tcf_lastuse_update(&t->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(t->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&t->common, skb);
 	action = READ_ONCE(t->tcf_action);
 
 	switch (params->tcft_action) {
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 9e68edb22e53..f6dccaa29239 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -29,7 +29,7 @@ static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
 	u16 tci;
 
 	tcf_lastuse_update(&v->tcf_tm);
-	bstats_cpu_update(this_cpu_ptr(v->common.cpu_bstats), skb);
+	tcf_action_update_bstats(&v->common, skb);
 
 	/* Ensure 'data' points at mac_header prior calling vlan manipulating
 	 * functions.
-- 
2.21.0

