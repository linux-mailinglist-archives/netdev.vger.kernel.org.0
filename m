Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDC0E9D22
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfJ3OJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55247 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726334AbfJ3OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDb020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 1/8] net: sched: extract common action counters update code into function
Date:   Wed, 30 Oct 2019 16:09:00 +0200
Message-Id: <20191030140907.18561-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, all implementations of tc_action_ops->stats_update() callback
have almost exactly the same implementation of counters update
code (besides gact which also updates drop counter). In order to simplify
support for using both percpu-allocated and regular action counters
depending on run-time flag in following patches, extract action counters
update code into standalone function in act API.

This commit doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h  |  2 ++
 net/sched/act_api.c    | 14 ++++++++++++++
 net/sched/act_ct.c     |  6 +-----
 net/sched/act_gact.c   | 10 +---------
 net/sched/act_mirred.c |  5 +----
 net/sched/act_police.c |  5 +----
 net/sched/act_vlan.c   |  5 +----
 7 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index b18c699681ca..f6f66c692385 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -186,6 +186,8 @@ int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
 int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
+			     bool drop, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 69d4676a402f..0638afa2fc3f 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -989,6 +989,20 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	return err;
 }
 
+void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
+			     bool drop, bool hw)
+{
+	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+
+	if (drop)
+		this_cpu_ptr(a->cpu_qstats)->drops += packets;
+
+	if (hw)
+		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
+				   bytes, packets);
+}
+EXPORT_SYMBOL(tcf_action_update_stats);
+
 int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 			  int compat_mode)
 {
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index fcc46025e790..ba76857754e5 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -905,11 +905,7 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
 {
 	struct tcf_ct *c = to_ct(a);
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	c->tcf_tm.lastuse = max_t(u64, c->tcf_tm.lastuse, lastuse);
 }
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 324f1d1f6d47..569cec63d4c3 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -177,15 +177,7 @@ static void tcf_gact_stats_update(struct tc_action *a, u64 bytes, u32 packets,
 	int action = READ_ONCE(gact->tcf_action);
 	struct tcf_t *tm = &gact->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(gact->common.cpu_bstats), bytes,
-			   packets);
-	if (action == TC_ACT_SHOT)
-		this_cpu_ptr(gact->common.cpu_qstats)->drops += packets;
-
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(gact->common.cpu_bstats_hw),
-				   bytes, packets);
-
+	tcf_action_update_stats(a, bytes, packets, action == TC_ACT_SHOT, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 08923b21e566..621686a6b5be 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -318,10 +318,7 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u32 packets,
 	struct tcf_mirred *m = to_mirred(a);
 	struct tcf_t *tm = &m->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 981a9eca0c52..51d34b1a61d5 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -294,10 +294,7 @@ static void tcf_police_stats_update(struct tc_action *a,
 	struct tcf_police *police = to_police(a);
 	struct tcf_t *tm = &police->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 08aaf719a70f..9e68edb22e53 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -307,10 +307,7 @@ static void tcf_vlan_stats_update(struct tc_action *a, u64 bytes, u32 packets,
 	struct tcf_vlan *v = to_vlan(a);
 	struct tcf_t *tm = &v->tcf_tm;
 
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
-	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+	tcf_action_update_stats(a, bytes, packets, false, hw);
 	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
 }
 
-- 
2.21.0

