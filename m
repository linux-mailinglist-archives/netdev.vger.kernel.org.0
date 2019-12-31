Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B9712DB93
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 20:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfLaTvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 14:51:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727526AbfLaTvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 14:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577821898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=D92yqc/c7K6La53a5GdOn22Sz19wJNdv52qE0dv8ldg=;
        b=e0w+vdL8NEU0LQRz3Stnj532wqf4tfqEkmi4ux2LLScVOeaA3OtmDNfwooQtQO3dBz/VQO
        wZWDtPOjKTwrSYyQTqadZEKoIgPI5VkHpyLFIs1sQd6Q1JfmcDkWODYrcwlVg3ZN+xCNSe
        ghqUBbkwVz9JUsQTsXRMWxPrD/KvyAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-tewkK3phM3q0P_k1PkT45w-1; Tue, 31 Dec 2019 14:51:37 -0500
X-MC-Unique: tewkK3phM3q0P_k1PkT45w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B4BDB22;
        Tue, 31 Dec 2019 19:51:35 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-15.phx2.redhat.com [10.3.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A137967673;
        Tue, 31 Dec 2019 19:51:30 +0000 (UTC)
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
Subject: [PATCH ghak90 V8 15/16] audit: check contid count per netns and add config param limit
Date:   Tue, 31 Dec 2019 14:48:28 -0500
Message-Id: <229a7be1f1136906a360a46e2cf8cdcd4c7c4b1b.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clamp the number of audit container identifiers associated with a
network namespace to limit the netlink and disk bandwidth used and to
prevent losing information from record text size overflow in the contid
field.

Add a configuration parameter AUDIT_STATUS_CONTID_NETNS_LIMIT (0x100)
to set the audit container identifier netns limit.  This is used to
prevent overflow of the contid field in CONTAINER_OP and CONTAINER_ID
messages, losing information, and to limit bandwidth used by these
messages.

This value must be balanced with the audit container identifier nesting
depth limit to multiply out to no more than 400.  This is determined by
the total audit message length less message overhead divided by the
length of the text representation of an audit container identifier.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h      | 16 +++++++----
 include/linux/nsproxy.h    |  2 +-
 include/uapi/linux/audit.h |  2 ++
 kernel/audit.c             | 68 ++++++++++++++++++++++++++++++++++++++--------
 kernel/audit.h             |  7 +++++
 kernel/fork.c              | 10 +++++--
 kernel/nsproxy.c           | 27 +++++++++++++++---
 7 files changed, 107 insertions(+), 25 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 4272b468417a..28b9c7cd86a6 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -234,9 +234,9 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 }
 
 extern void audit_log_container_id(struct audit_context *context, u64 contid);
-extern void audit_netns_contid_add(struct net *net, u64 contid);
+extern int audit_netns_contid_add(struct net *net, u64 contid);
 extern void audit_netns_contid_del(struct net *net, u64 contid);
-extern void audit_switch_task_namespaces(struct nsproxy *ns,
+extern int audit_switch_task_namespaces(struct nsproxy *ns,
 					 struct task_struct *p);
 extern void audit_log_netns_contid_list(struct net *net,
 					struct audit_context *context);
@@ -312,13 +312,17 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 
 static inline void audit_log_container_id(struct audit_context *context, u64 contid)
 { }
-static inline void audit_netns_contid_add(struct net *net, u64 contid)
-{ }
+static inline int audit_netns_contid_add(struct net *net, u64 contid)
+{
+	return 0;
+}
 static inline void audit_netns_contid_del(struct net *net, u64 contid)
 { }
-static inline void audit_switch_task_namespaces(struct nsproxy *ns,
+static inline int audit_switch_task_namespaces(struct nsproxy *ns,
 						struct task_struct *p)
-{ }
+{
+	return 0;
+}
 static inline void audit_log_netns_contid_list(struct net *net,
 					       struct audit_context *context)
 { }
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 2ae1b1a4d84d..3ca35cbf2cd8 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -67,7 +67,7 @@ struct nsproxy {
 
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
 void exit_task_namespaces(struct task_struct *tsk);
-void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
+int switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
 void free_nsproxy(struct nsproxy *ns);
 int unshare_nsproxy_namespaces(unsigned long, struct nsproxy **,
 	struct cred *, struct fs_struct *);
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index dcb076b0d2e1..2844d78cd7af 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -344,6 +344,7 @@ enum {
 #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
 #define AUDIT_STATUS_LOST		0x0040
 #define AUDIT_STATUS_CONTID_DEPTH_LIMIT	0x0080
+#define AUDIT_STATUS_CONTID_NETNS_LIMIT	0x0100
 
 #define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
 #define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
@@ -473,6 +474,7 @@ struct audit_status {
 	};
 	__u32		backlog_wait_time;/* message queue wait timeout */
 	__u32		contid_depth_limit;/* container depth limit */
+	__u32		contid_netns_limit;/* container netns limit */
 };
 
 struct audit_features {
diff --git a/kernel/audit.c b/kernel/audit.c
index e5e39aedaf86..1287f0b63757 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -89,11 +89,13 @@
  * @sk: communication socket
  * @contid_list: audit container identifier list
  * @contid_list_lock audit container identifier list lock
+ * @contid_count count of audit container identifiers using this netns
  */
 struct audit_net {
 	struct sock *sk;
 	struct list_head contid_list;
 	spinlock_t contid_list_lock;
+	int contid_count;
 };
 
 /**
@@ -158,6 +160,7 @@ struct auditd_connection {
  * no need for interaction with tasklist_lock */
 static DEFINE_SPINLOCK(audit_contobj_list_lock);
 static u32 audit_contid_depth_limit = AUDIT_CONTID_DEPTH_LIMIT;
+static u32 audit_contid_netns_limit = AUDIT_CONTID_NETNS_LIMIT;
 
 static struct kmem_cache *audit_buffer_cache;
 
@@ -419,19 +422,20 @@ static struct sock *audit_get_sk(const struct net *net)
 	return aunet->sk;
 }
 
-void audit_netns_contid_add(struct net *net, u64 contid)
+int audit_netns_contid_add(struct net *net, u64 contid)
 {
 	struct audit_net *aunet;
 	struct list_head *contid_list;
 	struct audit_contobj_netns *cont;
+	int rc = 0;
 
 	if (!net)
-		return;
+		return 0;
 	if (!audit_contid_valid(contid))
-		return;
+		return 0;
 	aunet = net_generic(net, audit_net_id);
 	if (!aunet)
-		return;
+		return 0;
 	contid_list = &aunet->contid_list;
 	rcu_read_lock();
 	list_for_each_entry_rcu(cont, contid_list, list)
@@ -447,11 +451,22 @@ void audit_netns_contid_add(struct net *net, u64 contid)
 		cont->id = contid;
 		refcount_set(&cont->refcount, 1);
 		spin_lock(&aunet->contid_list_lock);
-		list_add_rcu(&cont->list, contid_list);
+		if (audit_contid_netns_limit != 0 &&
+		    aunet->contid_count < audit_contid_netns_limit) {
+			list_add_rcu(&cont->list, contid_list);
+			aunet->contid_count++;
+		} else {
+			rc = -ENOSR;
+		}
 		spin_unlock(&aunet->contid_list_lock);
+		if (rc)
+			kfree(cont);
+	} else {
+		rc = -ENOMEM;
 	}
 out:
 	rcu_read_unlock();
+	return rc;
 }
 
 void audit_netns_contid_del(struct net *net, u64 contid)
@@ -475,6 +490,7 @@ void audit_netns_contid_del(struct net *net, u64 contid)
 			if (refcount_dec_and_test(&cont->refcount)) {
 				list_del_rcu(&cont->list);
 				kfree_rcu(cont, rcu);
+				aunet->contid_count--;
 			}
 			spin_unlock(&aunet->contid_list_lock);
 			break;
@@ -482,16 +498,21 @@ void audit_netns_contid_del(struct net *net, u64 contid)
 	rcu_read_unlock();
 }
 
-void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
+int audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 {
 	u64 contid = audit_get_contid(p);
 	struct nsproxy *new = p->nsproxy;
+	int rc = 0;
 
 	if (!audit_contid_valid(contid))
-		return;
+		return 0;
 	audit_netns_contid_del(ns->net_ns, contid);
-	if (new)
-		audit_netns_contid_add(new->net_ns, contid);
+	if (new) {
+		rc = audit_netns_contid_add(new->net_ns, contid);
+		if (rc)
+			audit_netns_contid_add(ns->net_ns, contid);
+	}
+	return rc;
 }
 
 void audit_log_contid(struct audit_buffer *ab, u64 contid);
@@ -683,7 +704,7 @@ static int audit_set_contid_depth_limit(u32 limit)
 {
 	int rc = 0;
 
-	if (limit > 20 * AUDIT_CONTID_DEPTH_LIMIT) {
+	if (limit * audit_contid_netns_limit > AUDIT_CONTID_MSG_LIMIT) {
 		rc = -ENOSPC;
 		audit_log_config_change("audit_contid_depth_limit",
 					limit, audit_contid_depth_limit, 0);
@@ -693,6 +714,20 @@ static int audit_set_contid_depth_limit(u32 limit)
 				      &audit_contid_depth_limit, limit);
 }
 
+static int audit_set_contid_netns_limit(u32 limit)
+{
+	int rc = 0;
+
+	if (limit * audit_contid_depth_limit > AUDIT_CONTID_MSG_LIMIT) {
+		rc = -ENOSPC;
+		audit_log_config_change("audit_contid_netns_limit",
+					limit, audit_contid_netns_limit, 0);
+		return rc;
+	}
+	return audit_do_config_change("audit_contid_netns_limit",
+				      &audit_contid_netns_limit, limit);
+}
+
 static int audit_set_enabled(u32 state)
 {
 	int rc;
@@ -1455,6 +1490,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.feature_bitmap	= AUDIT_FEATURE_BITMAP_ALL;
 		s.backlog_wait_time	= audit_backlog_wait_time;
 		s.contid_depth_limit	= audit_contid_depth_limit;
+		s.contid_netns_limit	= audit_contid_netns_limit;
 		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
@@ -1565,6 +1601,13 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			if (err < 0)
 				return err;
 		}
+		if (s.mask & AUDIT_STATUS_CONTID_NETNS_LIMIT) {
+			if (sizeof(s) > (size_t)nlh->nlmsg_len)
+				return -EINVAL;
+			err = audit_set_contid_netns_limit(s.contid_netns_limit);
+			if (err < 0)
+				return err;
+		}
 		break;
 	}
 	case AUDIT_GET_FEATURE:
@@ -1834,6 +1877,7 @@ static int __net_init audit_net_init(struct net *net)
 	aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 	INIT_LIST_HEAD(&aunet->contid_list);
 	spin_lock_init(&aunet->contid_list_lock);
+	aunet->contid_count = 0;
 	return 0;
 }
 
@@ -2776,7 +2820,9 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	if (!rc) {
 		if (audit_contid_valid(oldcontid))
 			audit_netns_contid_del(net, oldcontid);
-		audit_netns_contid_add(net, contid);
+		rc = audit_netns_contid_add(net, contid);
+		if (rc && audit_contid_valid(oldcontid))
+			audit_netns_contid_add(net, oldcontid);
 	}
 	task_unlock(task);
 
diff --git a/kernel/audit.h b/kernel/audit.h
index fbca07a49c03..5701a42e564f 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -222,6 +222,13 @@ static inline int audit_hash_contid(u64 contid)
 
 #define AUDIT_CONTID_DEPTH_LIMIT	4
 
+#define AUDIT_CONTID_NETNS_LIMIT	100
+
+/* this value is determined by AUDIT_MESSAGE_TEXT_MAX (8560) minus
+ * overhead (128) all divided by the max text representation of a full
+ * u64 (21) */
+#define AUDIT_CONTID_MSG_LIMIT	400
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
diff --git a/kernel/fork.c b/kernel/fork.c
index edf034e5cbb4..7431649d6a5a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2935,6 +2935,13 @@ int ksys_unshare(unsigned long unshare_flags)
 					 new_cred, new_fs);
 	if (err)
 		goto bad_unshare_cleanup_cred;
+	if (new_nsproxy) {
+		err = switch_task_namespaces(current, new_nsproxy);
+		if (err) {
+			free_nsproxy(new_nsproxy);
+			goto bad_unshare_cleanup_cred;
+		}
+	}
 
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
 		if (do_sysvsem) {
@@ -2949,9 +2956,6 @@ int ksys_unshare(unsigned long unshare_flags)
 			shm_init_task(current);
 		}
 
-		if (new_nsproxy)
-			switch_task_namespaces(current, new_nsproxy);
-
 		task_lock(current);
 
 		if (new_fs) {
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index bbdb5bbf5446..5181a41172a8 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -138,6 +138,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
 	u64 contid = audit_get_contid(tsk);
+	int rc;
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
 			      CLONE_NEWPID | CLONE_NEWNET |
@@ -165,7 +166,12 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 		return  PTR_ERR(new_ns);
 
 	tsk->nsproxy = new_ns;
-	audit_netns_contid_add(new_ns->net_ns, contid);
+	rc = audit_netns_contid_add(new_ns->net_ns, contid);
+	if (rc) {
+		tsk->nsproxy = old_ns;
+		free_nsproxy(new_ns);
+		return rc;
+	}
 	return 0;
 }
 
@@ -213,9 +219,10 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 	return err;
 }
 
-void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
+int switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 {
 	struct nsproxy *ns;
+	int rc;
 
 	might_sleep();
 
@@ -223,10 +230,17 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	ns = p->nsproxy;
 	p->nsproxy = new;
 	task_unlock(p);
-	audit_switch_task_namespaces(ns, p);
+	rc = audit_switch_task_namespaces(ns, p);
+	if (rc) {
+		task_lock(p);
+		p->nsproxy = ns;
+		task_unlock(p);
+		return rc;
+	}
 
 	if (ns && atomic_dec_and_test(&ns->count))
 		free_nsproxy(ns);
+	return 0;
 }
 
 void exit_task_namespaces(struct task_struct *p)
@@ -262,7 +276,12 @@ void exit_task_namespaces(struct task_struct *p)
 		free_nsproxy(new_nsproxy);
 		goto out;
 	}
-	switch_task_namespaces(tsk, new_nsproxy);
+	err = switch_task_namespaces(tsk, new_nsproxy);
+	if (err) {
+		ns->ops->install(tsk->nsproxy, ns);
+		free_nsproxy(new_nsproxy);
+		goto out;
+	}
 
 	perf_event_namespaces(tsk);
 out:
-- 
1.8.3.1

