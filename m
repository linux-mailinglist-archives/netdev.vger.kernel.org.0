Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9920C1BC
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgF0NYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:24:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbgF0NX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=CPP8DwxyP2nxU5T7VlnBBLby4pxWG218P+Lbpwd6l5M=;
        b=Q4zMdi0hHDdVtCiqyJzDPfJ7QwKjM4VQE8+4vVn7wHN0UOPydMVb1uBaElnqAB30iPPiMR
        VQD2aYmgdo0ivSG1O9HVsq8cs3tT2TT8W/X094K0y2c4X2RGHC8UNlZL7W0OAH7yXPzlCJ
        aXRReJGYsgH3hYu80aewWOTMWZu0a2g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-Az1n9d3oNUGv4uftFmg6og-1; Sat, 27 Jun 2020 09:23:21 -0400
X-MC-Unique: Az1n9d3oNUGv4uftFmg6og-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A05A804003;
        Sat, 27 Jun 2020 13:23:19 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A09D71662;
        Sat, 27 Jun 2020 13:23:14 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V9 10/13] audit: add support for containerid to network namespaces
Date:   Sat, 27 Jun 2020 09:20:43 -0400
Message-Id: <e9c1216a361c38ebc9cb4089922c259e2cfd5013.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This also adds support to qualify NETFILTER_PKT records.

Audit events could happen in a network namespace outside of a task
context due to packets received from the net that trigger an auditing
rule prior to being associated with a running task.  The network
namespace could be in use by multiple containers by association to the
tasks in that network namespace.  We still want a way to attribute
these events to any potential containers.  Keep a list per network
namespace to track these audit container identifiiers.

Add/increment the audit container identifier on:
- initial setting of the audit container identifier via /proc
- clone/fork call that inherits an audit container identifier
- unshare call that inherits an audit container identifier
- setns call that inherits an audit container identifier
Delete/decrement the audit container identifier on:
- an inherited audit container identifier dropped when child set
- process exit
- unshare call that drops a net namespace
- setns call that drops a net namespace

Add audit container identifier auxiliary record(s) to NETFILTER_PKT
event standalone records.  Iterate through all potential audit container
identifiers associated with a network namespace.

Please see the github audit kernel issue for contid net support:
  https://github.com/linux-audit/audit-kernel/issues/92
Please see the github audit testsuiite issue for the test case:
  https://github.com/linux-audit/audit-testsuite/issues/64
Please see the github audit wiki for the feature overview:
  https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/linux/audit.h    |  20 ++++++
 kernel/audit.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/nsproxy.c         |   4 ++
 net/netfilter/nft_log.c  |  11 +++-
 net/netfilter/xt_AUDIT.c |  11 +++-
 5 files changed, 195 insertions(+), 7 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index c4a755ae0d61..304fbb7c3c5b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -128,6 +128,13 @@ struct audit_task_info {
 
 extern struct audit_task_info init_struct_audit;
 
+struct audit_contobj_netns {
+	struct list_head	list;
+	struct audit_contobj	*obj;
+	int			count;
+	struct rcu_head		rcu;
+};
+
 extern int is_audit_feature_set(int which);
 
 extern int __init audit_register_class(int class, unsigned *list);
@@ -233,6 +240,11 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 
 extern void audit_log_container_id(struct audit_context *context,
 				   struct audit_contobj *cont);
+extern void audit_copy_namespaces(struct net *net, struct task_struct *tsk);
+extern void audit_switch_task_namespaces(struct nsproxy *ns,
+					 struct task_struct *p);
+extern void audit_log_netns_contid_list(struct net *net,
+					struct audit_context *context);
 
 extern u32 audit_enabled;
 
@@ -306,6 +318,14 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 static inline void audit_log_container_id(struct audit_context *context,
 					  struct audit_contobj *cont)
 { }
+static inline void audit_copy_namespaces(struct net *net, struct task_struct *tsk)
+{ }
+static inline void audit_switch_task_namespaces(struct nsproxy *ns,
+						struct task_struct *p)
+{ }
+static inline void audit_log_netns_contid_list(struct net *net,
+					       struct audit_context *context)
+{ }
 
 #define audit_enabled AUDIT_OFF
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 997c34178ee8..a862721dfd9b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -59,6 +59,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <net/netns/generic.h>
+#include <net/net_namespace.h>
 
 #include "audit.h"
 
@@ -86,9 +87,13 @@
 /**
  * struct audit_net - audit private network namespace data
  * @sk: communication socket
+ * @contobj_list: audit container identifier list
+ * @contobj_list_lock audit container identifier list lock
  */
 struct audit_net {
 	struct sock *sk;
+	struct list_head contobj_list;
+	spinlock_t contobj_list_lock;
 };
 
 /**
@@ -214,6 +219,9 @@ struct audit_reply {
 
 static struct kmem_cache *audit_task_cache;
 
+void audit_netns_contid_add(struct net *net, struct audit_contobj *cont);
+void audit_netns_contid_del(struct net *net, struct audit_contobj *cont);
+
 void __init audit_task_init(void)
 {
 	audit_task_cache = kmem_cache_create("audit_task",
@@ -326,10 +334,17 @@ struct audit_task_info init_struct_audit = {
 void audit_free(struct task_struct *tsk)
 {
 	struct audit_task_info *info = tsk->audit;
+	struct nsproxy *ns = tsk->nsproxy;
+	struct audit_contobj *cont;
 
 	audit_free_syscall(tsk);
 	rcu_read_lock();
-	_audit_contobj_put(tsk->audit->cont);
+	cont = _audit_contobj_get(tsk);
+	if (ns) {
+		audit_netns_contid_del(ns->net_ns, cont);
+		_audit_contobj_put(cont);
+	}
+	_audit_contobj_put(cont);
 	rcu_read_unlock();
 	/* Freeing the audit_task_info struct must be performed after
 	 * audit_log_exit() due to need for loginuid and sessionid.
@@ -437,6 +452,136 @@ static struct sock *audit_get_sk(const struct net *net)
 	return aunet->sk;
 }
 
+void audit_netns_contid_add(struct net *net, struct audit_contobj *cont)
+{
+	struct audit_net *aunet;
+	struct list_head *contobj_list;
+	struct audit_contobj_netns *contns;
+
+	if (!net)
+		return;
+	if (!cont)
+		return;
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		return;
+	contobj_list = &aunet->contobj_list;
+	rcu_read_lock();
+	spin_lock(&aunet->contobj_list_lock);
+	list_for_each_entry_rcu(contns, contobj_list, list)
+		if (contns->obj == cont) {
+			contns->count++;
+			goto out;
+		}
+	contns = kmalloc(sizeof(*contns), GFP_ATOMIC);
+	if (contns) {
+		INIT_LIST_HEAD(&contns->list);
+		contns->obj = cont;
+		contns->count = 1;
+		list_add_rcu(&contns->list, contobj_list);
+	}
+out:
+	spin_unlock(&aunet->contobj_list_lock);
+	rcu_read_unlock();
+}
+
+void audit_netns_contid_del(struct net *net, struct audit_contobj *cont)
+{
+	struct audit_net *aunet;
+	struct list_head *contobj_list;
+	struct audit_contobj_netns *contns = NULL;
+
+	if (!net)
+		return;
+	if (!cont)
+		return;
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		return;
+	contobj_list = &aunet->contobj_list;
+	rcu_read_lock();
+	spin_lock(&aunet->contobj_list_lock);
+	list_for_each_entry_rcu(contns, contobj_list, list)
+		if (contns->obj == cont) {
+			contns->count--;
+			if (contns->count < 1) {
+				list_del_rcu(&contns->list);
+				kfree_rcu(contns, rcu);
+			}
+			break;
+		}
+	spin_unlock(&aunet->contobj_list_lock);
+	rcu_read_unlock();
+}
+
+void audit_copy_namespaces(struct net *net, struct task_struct *tsk)
+{
+	struct audit_contobj *cont;
+
+	rcu_read_lock();
+	cont = _audit_contobj_get(tsk);
+	audit_netns_contid_add(net, cont);
+	rcu_read_unlock();
+}
+
+void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
+{
+	struct audit_contobj *cont;
+	struct nsproxy *new = p->nsproxy;
+
+	rcu_read_lock();
+	cont = _audit_contobj_get(p);
+	if (!cont)
+		goto out;
+	audit_netns_contid_del(ns->net_ns, cont);
+	if (new)
+		audit_netns_contid_add(new->net_ns, cont);
+	else
+		_audit_contobj_put(cont);
+	_audit_contobj_put(cont);
+out:
+	rcu_read_unlock();
+}
+
+/**
+ * audit_log_netns_contid_list - List contids for the given network namespace
+ * @net: the network namespace of interest
+ * @context: the audit context to use
+ *
+ * Description:
+ * Issues a CONTAINER_ID record with a CSV list of contids associated
+ * with a network namespace to accompany a NETFILTER_PKT record.
+ */
+void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
+{
+	struct audit_buffer *ab = NULL;
+	struct audit_contobj_netns *cont;
+	struct audit_net *aunet;
+
+	/* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
+	rcu_read_lock();
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		goto out;
+	list_for_each_entry_rcu(cont, &aunet->contobj_list, list) {
+		if (!ab) {
+			ab = audit_log_start(context, GFP_ATOMIC,
+					     AUDIT_CONTAINER_ID);
+			if (!ab) {
+				audit_log_lost("out of memory in audit_log_netns_contid_list");
+				goto out;
+			}
+			audit_log_format(ab, "contid=");
+		} else
+			audit_log_format(ab, ",");
+		audit_log_format(ab, "%llu", cont->obj->id);
+	}
+	audit_log_end(ab);
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(audit_log_netns_contid_list);
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
@@ -1786,7 +1931,6 @@ static int __net_init audit_net_init(struct net *net)
 		.flags	= NL_CFG_F_NONROOT_RECV,
 		.groups	= AUDIT_NLGRP_MAX,
 	};
-
 	struct audit_net *aunet = net_generic(net, audit_net_id);
 
 	aunet->sk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
@@ -1795,7 +1939,8 @@ static int __net_init audit_net_init(struct net *net)
 		return -ENOMEM;
 	}
 	aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
-
+	INIT_LIST_HEAD(&aunet->contobj_list);
+	spin_lock_init(&aunet->contobj_list_lock);
 	return 0;
 }
 
@@ -2585,6 +2730,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	int rc = 0;
 	struct audit_buffer *ab;
 	struct audit_contobj *oldcont = NULL;
+	struct net *net = task->nsproxy->net_ns;
 
 	task_lock(task);
 	/* Can't set if audit disabled */
@@ -2657,6 +2803,10 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 		spin_unlock(&audit_contobj_list_lock);
 		task->audit->cont = newcont;
 		_audit_contobj_put(oldcont);
+		audit_netns_contid_del(net, oldcont);
+		_audit_contobj_put(oldcont);
+		_audit_contobj_hold(newcont);
+		audit_netns_contid_add(net, newcont);
 	}
 conterror:
 	task_unlock(task);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b03df67621d0..5eddb3377049 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -26,6 +26,7 @@
 #include <linux/syscalls.h>
 #include <linux/cgroup.h>
 #include <linux/perf_event.h>
+#include <linux/audit.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -187,6 +188,8 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	}
 
 	tsk->nsproxy = new_ns;
+	if (flags & CLONE_NEWNET)
+		audit_copy_namespaces(new_ns->net_ns, tsk);
 	return 0;
 }
 
@@ -249,6 +252,7 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	ns = p->nsproxy;
 	p->nsproxy = new;
 	task_unlock(p);
+	audit_switch_task_namespaces(ns, p);
 
 	if (ns && atomic_dec_and_test(&ns->count))
 		free_nsproxy(ns);
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index fe4831f2258f..98d1e7e1a83c 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -66,13 +66,16 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 	struct sk_buff *skb = pkt->skb;
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	context = audit_alloc_local(GFP_ATOMIC);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (!ab)
-		return;
+		goto errout;
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
@@ -99,6 +102,10 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 		audit_log_format(ab, " saddr=? daddr=? proto=-1");
 
 	audit_log_end(ab);
+	net = xt_net(&pkt->xt);
+	audit_log_netns_contid_list(net, context);
+errout:
+	audit_free_context(context);
 }
 
 static void nft_log_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 9cdc16b0d0d8..ecf868a1abde 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -68,10 +68,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (audit_enabled == AUDIT_OFF)
-		goto errout;
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+		goto out;
+	context = audit_alloc_local(GFP_ATOMIC);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -101,7 +104,11 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 
 	audit_log_end(ab);
 
+	net = xt_net(par);
+	audit_log_netns_contid_list(net, context);
 errout:
+	audit_free_context(context);
+out:
 	return XT_CONTINUE;
 }
 
-- 
1.8.3.1

