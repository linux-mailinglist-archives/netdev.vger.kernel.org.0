Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CFFE9D25
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfJ3OJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55254 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbfJ3OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDf020747;
        Wed, 30 Oct 2019 16:09:15 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 5/8] net: sched: modify stats helper functions to support regular stats
Date:   Wed, 30 Oct 2019 16:09:04 +0200
Message-Id: <20191030140907.18561-6-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify stats update helper functions introduced in previous patches in this
series to fallback to regular tc_action->tcfa_{b|q}stats if cpu stats are
not allocated for the action argument. If regular non-percpu allocated
counters are in use, then obtain action tcfa_lock while modifying them.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h | 30 +++++++++++++++++++++---------
 net/sched/act_api.c   | 19 ++++++++++++++-----
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 8d6861ce205b..a56477051dae 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -190,23 +190,35 @@ int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
 static inline void tcf_action_update_bstats(struct tc_action *a,
 					    struct sk_buff *skb)
 {
-	bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
-}
-
-static inline struct gnet_stats_queue *
-tcf_action_get_qstats(struct tc_action *a)
-{
-	return this_cpu_ptr(a->cpu_qstats);
+	if (likely(a->cpu_bstats)) {
+		bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), skb);
+		return;
+	}
+	spin_lock(&a->tcfa_lock);
+	bstats_update(&a->tcfa_bstats, skb);
+	spin_unlock(&a->tcfa_lock);
 }
 
 static inline void tcf_action_inc_drop_qstats(struct tc_action *a)
 {
-	qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+	if (likely(a->cpu_qstats)) {
+		qstats_drop_inc(this_cpu_ptr(a->cpu_qstats));
+		return;
+	}
+	spin_lock(&a->tcfa_lock);
+	qstats_drop_inc(&a->tcfa_qstats);
+	spin_unlock(&a->tcfa_lock);
 }
 
 static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 {
-	qstats_overlimit_inc(this_cpu_ptr(a->cpu_qstats));
+	if (likely(a->cpu_qstats)) {
+		qstats_overlimit_inc(this_cpu_ptr(a->cpu_qstats));
+		return;
+	}
+	spin_lock(&a->tcfa_lock);
+	qstats_overlimit_inc(&a->tcfa_qstats);
+	spin_unlock(&a->tcfa_lock);
 }
 
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 0638afa2fc3f..f85b88da5216 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -992,14 +992,23 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u32 packets,
 			     bool drop, bool hw)
 {
-	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+	if (a->cpu_bstats) {
+		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
 
-	if (drop)
-		this_cpu_ptr(a->cpu_qstats)->drops += packets;
+		if (drop)
+			this_cpu_ptr(a->cpu_qstats)->drops += packets;
+
+		if (hw)
+			_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
+					   bytes, packets);
+		return;
+	}
 
+	_bstats_update(&a->tcfa_bstats, bytes, packets);
+	if (drop)
+		a->tcfa_qstats.drops += packets;
 	if (hw)
-		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
-				   bytes, packets);
+		_bstats_update(&a->tcfa_bstats_hw, bytes, packets);
 }
 EXPORT_SYMBOL(tcf_action_update_stats);
 
-- 
2.21.0

