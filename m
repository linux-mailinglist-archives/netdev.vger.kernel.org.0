Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC10B70BD
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbfISB0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfISB0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:26:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C67D307CDEA;
        Thu, 19 Sep 2019 01:26:13 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE43160C5D;
        Thu, 19 Sep 2019 01:25:58 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 12/21] audit: add support for containerid to network namespaces
Date:   Wed, 18 Sep 2019 21:22:29 -0400
Message-Id: <91315ac64b44bcad9dfc623fa7fefe67d7d2561b.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 19 Sep 2019 01:26:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 include/linux/audit.h | 19 +++++++++++
 kernel/audit.c        | 87 +++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/nsproxy.c      |  4 +++
 3 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 575fff6ea7c9..73e3ab38e3e0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -13,6 +13,7 @@
 #include <linux/ptrace.h>
 #include <linux/namei.h>  /* LOOKUP_* */
 #include <uapi/linux/audit.h>
+#include <linux/refcount.h>
 
 #define AUDIT_INO_UNSET ((unsigned long)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
@@ -122,6 +123,13 @@ struct audit_task_info {
 
 extern struct audit_task_info init_struct_audit;
 
+struct audit_contid {
+	struct list_head	list;
+	u64			id;
+	refcount_t		refcount;
+	struct rcu_head		rcu;
+};
+
 extern int is_audit_feature_set(int which);
 
 extern int __init audit_register_class(int class, unsigned *list);
@@ -229,6 +237,10 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 extern void audit_cont_put(struct audit_cont *cont);
 
 extern void audit_log_container_id(struct audit_context *context, u64 contid);
+extern void audit_netns_contid_add(struct net *net, u64 contid);
+extern void audit_netns_contid_del(struct net *net, u64 contid);
+extern void audit_switch_task_namespaces(struct nsproxy *ns,
+					 struct task_struct *p);
 
 extern u32 audit_enabled;
 
@@ -309,6 +321,13 @@ static inline void audit_cont_put(struct audit_cont *cont)
 
 static inline void audit_log_container_id(struct audit_context *context, u64 contid)
 { }
+static inline void audit_netns_contid_add(struct net *net, u64 contid)
+{ }
+static inline void audit_netns_contid_del(struct net *net, u64 contid)
+{ }
+static inline void audit_switch_task_namespaces(struct nsproxy *ns,
+						struct task_struct *p)
+{ }
 
 #define audit_enabled AUDIT_OFF
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 7cdb76b38966..e0c27bc39925 100644
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
+ * @contid_list: audit container identifier list
+ * @contid_list_lock audit container identifier list lock
  */
 struct audit_net {
 	struct sock *sk;
+	struct list_head contid_list;
+	spinlock_t contid_list_lock;
 };
 
 /**
@@ -269,8 +274,11 @@ struct audit_task_info init_struct_audit = {
 void audit_free(struct task_struct *tsk)
 {
 	struct audit_task_info *info = tsk->audit;
+	struct nsproxy *ns = tsk->nsproxy;
 
 	audit_free_syscall(tsk);
+	if (ns)
+		audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
 	/* Freeing the audit_task_info struct must be performed after
 	 * audit_log_exit() due to need for loginuid and sessionid.
 	 */
@@ -373,6 +381,75 @@ static struct sock *audit_get_sk(const struct net *net)
 	return aunet->sk;
 }
 
+void audit_netns_contid_add(struct net *net, u64 contid)
+{
+	struct audit_net *aunet;
+	struct list_head *contid_list;
+	struct audit_contid *cont;
+
+	if (!net)
+		return;
+	if (!audit_contid_valid(contid))
+		return;
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		return;
+	contid_list = &aunet->contid_list;
+	spin_lock(&aunet->contid_list_lock);
+	list_for_each_entry_rcu(cont, contid_list, list)
+		if (cont->id == contid) {
+			refcount_inc(&cont->refcount);
+			goto out;
+		}
+	cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
+	if (cont) {
+		INIT_LIST_HEAD(&cont->list);
+		cont->id = contid;
+		refcount_set(&cont->refcount, 1);
+		list_add_rcu(&cont->list, contid_list);
+	}
+out:
+	spin_unlock(&aunet->contid_list_lock);
+}
+
+void audit_netns_contid_del(struct net *net, u64 contid)
+{
+	struct audit_net *aunet;
+	struct list_head *contid_list;
+	struct audit_contid *cont = NULL;
+
+	if (!net)
+		return;
+	if (!audit_contid_valid(contid))
+		return;
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		return;
+	contid_list = &aunet->contid_list;
+	spin_lock(&aunet->contid_list_lock);
+	list_for_each_entry_rcu(cont, contid_list, list)
+		if (cont->id == contid) {
+			if (refcount_dec_and_test(&cont->refcount)) {
+				list_del_rcu(&cont->list);
+				kfree_rcu(cont, rcu);
+			}
+			break;
+		}
+	spin_unlock(&aunet->contid_list_lock);
+}
+
+void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
+{
+	u64 contid = audit_get_contid(p);
+	struct nsproxy *new = p->nsproxy;
+
+	if (!audit_contid_valid(contid))
+		return;
+	audit_netns_contid_del(ns->net_ns, contid);
+	if (new)
+		audit_netns_contid_add(new->net_ns, contid);
+}
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
@@ -1641,7 +1718,6 @@ static int __net_init audit_net_init(struct net *net)
 		.flags	= NL_CFG_F_NONROOT_RECV,
 		.groups	= AUDIT_NLGRP_MAX,
 	};
-
 	struct audit_net *aunet = net_generic(net, audit_net_id);
 
 	aunet->sk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
@@ -1650,7 +1726,8 @@ static int __net_init audit_net_init(struct net *net)
 		return -ENOMEM;
 	}
 	aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
-
+	INIT_LIST_HEAD(&aunet->contid_list);
+	spin_lock_init(&aunet->contid_list_lock);
 	return 0;
 }
 
@@ -2460,6 +2537,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	uid_t uid;
 	struct tty_struct *tty;
 	char comm[sizeof(current->comm)];
+	struct net *net = task->nsproxy->net_ns;
 
 	task_lock(task);
 	/* Can't set if audit disabled */
@@ -2530,6 +2608,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 conterror:
 		spin_unlock(&audit_contid_list_lock);
 	}
+	if (!rc) {
+		if (audit_contid_valid(oldcontid))
+			audit_netns_contid_del(net, oldcontid);
+		audit_netns_contid_add(net, contid);
+	}
 	task_unlock(task);
 
 	if (!audit_enabled)
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index c815f58e6bc0..bbdb5bbf5446 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -23,6 +23,7 @@
 #include <linux/syscalls.h>
 #include <linux/cgroup.h>
 #include <linux/perf_event.h>
+#include <linux/audit.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -136,6 +137,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
+	u64 contid = audit_get_contid(tsk);
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
 			      CLONE_NEWPID | CLONE_NEWNET |
@@ -163,6 +165,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 		return  PTR_ERR(new_ns);
 
 	tsk->nsproxy = new_ns;
+	audit_netns_contid_add(new_ns->net_ns, contid);
 	return 0;
 }
 
@@ -220,6 +223,7 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	ns = p->nsproxy;
 	p->nsproxy = new;
 	task_unlock(p);
+	audit_switch_task_namespaces(ns, p);
 
 	if (ns && atomic_dec_and_test(&ns->count))
 		free_nsproxy(ns);
-- 
1.8.3.1

