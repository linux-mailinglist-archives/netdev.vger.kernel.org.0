Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B90B2360
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391235AbfIMP3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:29:06 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35523 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388442AbfIMP3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 11:29:03 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 13 Sep 2019 18:28:56 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x8DFSuJE018845;
        Fri, 13 Sep 2019 18:28:56 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 2/3] net: sched: take reference to psample group in flow_action infra
Date:   Fri, 13 Sep 2019 18:28:40 +0300
Message-Id: <20190913152841.15755-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190913152841.15755-1-vladbu@mellanox.com>
References: <20190913152841.15755-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With recent patch set that removed rtnl lock dependency from cls hardware
offload API rtnl lock is only taken when reading action data and can be
released after action-specific data is parsed into intermediate
representation. However, sample action psample group is passed by pointer
without obtaining reference to it first, which makes it possible to
concurrently overwrite the action and deallocate object pointed by
psample_group pointer after rtnl lock is released but before driver
finished using the pointer.

To prevent such race condition, obtain reference to psample group while it
is used by flow_action infra. Extend psample API with function
psample_group_take() that increments psample group reference counter.
Extend struct tc_action_ops with new get_psample_group() API. Implement the
API for action sample using psample_group_take() and already existing
psample_group_put() as a destructor. Use it in tc_setup_flow_action() to
take reference to psample group pointed to by entry->sample.psample_group
and release it in tc_cleanup_flow_action().

Disable bh when taking psample_groups_lock. The lock is now taken while
holding action tcf_lock that is used by data path and requires bh to be
disabled, so doing the same for psample_groups_lock is necessary to
preserve SOFTIRQ-irq-safety.

Fixes: 918190f50eb6 ("net: sched: flower: don't take rtnl lock for cls hw offloads API")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/act_api.h          |  5 +++++
 include/net/psample.h          |  1 +
 include/net/tc_act/tc_sample.h |  6 ------
 net/psample/psample.c          | 20 ++++++++++++++------
 net/sched/act_sample.c         | 27 +++++++++++++++++++++++++++
 net/sched/cls_api.c            | 13 +++++++++++--
 6 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 3a1a72990fce..4be8b0daedf0 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -78,6 +78,8 @@ static inline void tcf_tm_dump(struct tcf_t *dtm, const struct tcf_t *stm)
 #define ACT_P_CREATED 1
 #define ACT_P_DELETED 1
 
+typedef void (*tc_action_priv_destructor)(void *priv);
+
 struct tc_action_ops {
 	struct list_head head;
 	char    kind[IFNAMSIZ];
@@ -101,6 +103,9 @@ struct tc_action_ops {
 	size_t  (*get_fill_size)(const struct tc_action *act);
 	struct net_device *(*get_dev)(const struct tc_action *a);
 	void	(*put_dev)(struct net_device *dev);
+	struct psample_group *
+	(*get_psample_group)(const struct tc_action *a,
+			     tc_action_priv_destructor *destructor);
 };
 
 struct tc_action_net {
diff --git a/include/net/psample.h b/include/net/psample.h
index 6b578ce69cd8..68ae16bb0a4a 100644
--- a/include/net/psample.h
+++ b/include/net/psample.h
@@ -15,6 +15,7 @@ struct psample_group {
 };
 
 struct psample_group *psample_group_get(struct net *net, u32 group_num);
+void psample_group_take(struct psample_group *group);
 void psample_group_put(struct psample_group *group);
 
 #if IS_ENABLED(CONFIG_PSAMPLE)
diff --git a/include/net/tc_act/tc_sample.h b/include/net/tc_act/tc_sample.h
index b4fce0fae645..b5d76305e854 100644
--- a/include/net/tc_act/tc_sample.h
+++ b/include/net/tc_act/tc_sample.h
@@ -41,10 +41,4 @@ static inline int tcf_sample_trunc_size(const struct tc_action *a)
 	return to_sample(a)->trunc_size;
 }
 
-static inline struct psample_group *
-tcf_sample_psample_group(const struct tc_action *a)
-{
-	return rcu_dereference_rtnl(to_sample(a)->psample_group);
-}
-
 #endif /* __NET_TC_SAMPLE_H */
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 66e4b61a350d..a6ceb0533b5b 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -73,7 +73,7 @@ static int psample_nl_cmd_get_group_dumpit(struct sk_buff *msg,
 	int idx = 0;
 	int err;
 
-	spin_lock(&psample_groups_lock);
+	spin_lock_bh(&psample_groups_lock);
 	list_for_each_entry(group, &psample_groups_list, list) {
 		if (!net_eq(group->net, sock_net(msg->sk)))
 			continue;
@@ -89,7 +89,7 @@ static int psample_nl_cmd_get_group_dumpit(struct sk_buff *msg,
 		idx++;
 	}
 
-	spin_unlock(&psample_groups_lock);
+	spin_unlock_bh(&psample_groups_lock);
 	cb->args[0] = idx;
 	return msg->len;
 }
@@ -172,7 +172,7 @@ struct psample_group *psample_group_get(struct net *net, u32 group_num)
 {
 	struct psample_group *group;
 
-	spin_lock(&psample_groups_lock);
+	spin_lock_bh(&psample_groups_lock);
 
 	group = psample_group_lookup(net, group_num);
 	if (!group) {
@@ -183,19 +183,27 @@ struct psample_group *psample_group_get(struct net *net, u32 group_num)
 	group->refcount++;
 
 out:
-	spin_unlock(&psample_groups_lock);
+	spin_unlock_bh(&psample_groups_lock);
 	return group;
 }
 EXPORT_SYMBOL_GPL(psample_group_get);
 
+void psample_group_take(struct psample_group *group)
+{
+	spin_lock_bh(&psample_groups_lock);
+	group->refcount++;
+	spin_unlock_bh(&psample_groups_lock);
+}
+EXPORT_SYMBOL_GPL(psample_group_take);
+
 void psample_group_put(struct psample_group *group)
 {
-	spin_lock(&psample_groups_lock);
+	spin_lock_bh(&psample_groups_lock);
 
 	if (--group->refcount == 0)
 		psample_group_destroy(group);
 
-	spin_unlock(&psample_groups_lock);
+	spin_unlock_bh(&psample_groups_lock);
 }
 EXPORT_SYMBOL_GPL(psample_group_put);
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 10229124a992..692c4c9040fd 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -252,6 +252,32 @@ static int tcf_sample_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static void tcf_psample_group_put(void *priv)
+{
+	struct psample_group *group = priv;
+
+	psample_group_put(group);
+}
+
+static struct psample_group *
+tcf_sample_get_group(const struct tc_action *a,
+		     tc_action_priv_destructor *destructor)
+{
+	struct tcf_sample *s = to_sample(a);
+	struct psample_group *group;
+
+	spin_lock_bh(&s->tcf_lock);
+	group = rcu_dereference_protected(s->psample_group,
+					  lockdep_is_held(&s->tcf_lock));
+	if (group) {
+		psample_group_take(group);
+		*destructor = tcf_psample_group_put;
+	}
+	spin_unlock_bh(&s->tcf_lock);
+
+	return group;
+}
+
 static struct tc_action_ops act_sample_ops = {
 	.kind	  = "sample",
 	.id	  = TCA_ID_SAMPLE,
@@ -262,6 +288,7 @@ static struct tc_action_ops act_sample_ops = {
 	.cleanup  = tcf_sample_cleanup,
 	.walk	  = tcf_sample_walker,
 	.lookup	  = tcf_sample_search,
+	.get_psample_group = tcf_sample_get_group,
 	.size	  = sizeof(struct tcf_sample),
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c668195379bd..60d44b14750a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3324,6 +3324,16 @@ static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
 	return 0;
 }
 
+static void tcf_sample_get_group(struct flow_action_entry *entry,
+				 const struct tc_action *act)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	entry->sample.psample_group =
+		act->ops->get_psample_group(act, &entry->destructor);
+	entry->destructor_priv = entry->sample.psample_group;
+#endif
+}
+
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts, bool rtnl_held)
 {
@@ -3417,11 +3427,10 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->mark = tcf_skbedit_mark(act);
 		} else if (is_tcf_sample(act)) {
 			entry->id = FLOW_ACTION_SAMPLE;
-			entry->sample.psample_group =
-				tcf_sample_psample_group(act);
 			entry->sample.trunc_size = tcf_sample_trunc_size(act);
 			entry->sample.truncate = tcf_sample_truncate(act);
 			entry->sample.rate = tcf_sample_rate(act);
+			tcf_sample_get_group(entry, act);
 		} else if (is_tcf_police(act)) {
 			entry->id = FLOW_ACTION_POLICE;
 			entry->police.burst = tcf_police_tcfp_burst(act);
-- 
2.21.0

