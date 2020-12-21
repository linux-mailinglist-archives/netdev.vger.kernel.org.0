Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533542DFE8E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 18:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgLUQ7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 11:59:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbgLUQ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 11:59:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608569886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=5YSF3Ey9GPUZPTa5iLsa7pHdozcbofcz4D7cGLJSNx8=;
        b=e7ksj1EHfDPOh/jN7rRp1Ti3md9P7ho+k51AFhttDuZ60qAwSc7dl+o2M/eybXebpWLdo5
        zage21jFDpKtSg6JEKUkWVgo+s2T8+a9ZGN+VG+BoYLWI+hcIlw9ASuy66H2WT9mwdP3eE
        ZgKLiz/4TM93PVzNdFF1OHU58MSyljE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-6VQzLITfOOacA5FzmJF4_Q-1; Mon, 21 Dec 2020 11:58:04 -0500
X-MC-Unique: 6VQzLITfOOacA5FzmJF4_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68D1D100C600;
        Mon, 21 Dec 2020 16:58:02 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3171E60C0F;
        Mon, 21 Dec 2020 16:57:49 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux Containers List <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Linux FSdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>, mpatel@redhat.com,
        Serge Hallyn <serge@hallyn.com>,
        Kees Cook <keescook@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 v10 08/11] audit: add support for containerid to network namespaces
Date:   Mon, 21 Dec 2020 11:55:42 -0500
Message-Id: <c8c5e8f2ed832ba2291089c4ad68d77931c38c08.1608225886.git.rgb@redhat.com>
In-Reply-To: <cover.1608225886.git.rgb@redhat.com>
References: <cover.1608225886.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Sample event:
type=NETFILTER_PKT msg=audit(2020-11-26 10:24:47.984:174549) : mark=0x15766399 saddr=127.0.0.1 daddr=127.0.0.1 proto=icmp record=1
type=CONTAINER_ID msg=audit(2020-11-26 10:24:47.984:174549) : record=1 contid=4112973747854606336,1916436506412318720

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
 include/linux/audit.h    |  17 +++
 kernel/audit.c           | 229 ++++++++++++++++++++++++++++++++++-----
 kernel/nsproxy.c         |   4 +
 net/netfilter/nft_log.c  |  14 ++-
 net/netfilter/xt_AUDIT.c |  14 ++-
 5 files changed, 249 insertions(+), 29 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 056a7c9a12a2..014f73296fec 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -217,6 +217,12 @@ extern int audit_get_contid_proc(char *tmpbuf, int TMPBUFLEN,
 
 extern int audit_set_contid(struct task_struct *tsk, u64 contid);
 
+extern void audit_copy_namespaces(struct net *net, struct task_struct *tsk);
+extern void audit_switch_task_namespaces(struct nsproxy *ns,
+					 struct task_struct *p);
+extern int audit_log_netns_contid_list(struct net *net,
+					struct audit_context *context);
+
 extern u32 audit_enabled;
 
 extern int audit_signal_info(int sig, struct task_struct *t);
@@ -281,6 +287,17 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 	return AUDIT_SID_UNSET;
 }
 
+static inline void audit_copy_namespaces(struct net *net, struct task_struct *tsk)
+{ }
+static inline void audit_switch_task_namespaces(struct nsproxy *ns,
+						struct task_struct *p)
+{ }
+static inline int audit_log_netns_contid_list(struct net *net,
+					       struct audit_context *context)
+{
+	return 0;
+}
+
 #define audit_enabled AUDIT_OFF
 
 static inline int audit_signal_info(int sig, struct task_struct *t)
diff --git a/kernel/audit.c b/kernel/audit.c
index 300daf2bcb16..8d03f07e7128 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -59,6 +59,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <net/netns/generic.h>
+#include <net/net_namespace.h>
 
 #include "audit.h"
 
@@ -86,9 +87,13 @@ static unsigned int audit_net_id;
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
@@ -239,6 +244,16 @@ struct audit_task_info {
 
 static struct kmem_cache *audit_task_cache;
 
+struct audit_contobj_netns {
+	struct list_head	list;
+	struct audit_contobj	*obj;
+	int			count;
+	struct rcu_head		rcu;
+};
+
+static void audit_netns_contid_add(struct net *net, struct audit_contobj *cont);
+static void audit_netns_contid_del(struct net *net, struct audit_contobj *cont);
+
 void __init audit_task_init(void)
 {
 	audit_task_cache = kmem_cache_create("audit_task",
@@ -372,11 +387,12 @@ void audit_contobj_put(void **cont, int count)
 {
 	int i;
 	struct audit_contobj **contobj = (struct audit_contobj **)cont;
+	unsigned long flags;
 
-	spin_lock(&_audit_contobj_list_lock);
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	for (i = 0; i < count; i++)
 		_audit_contobj_put(contobj[i]);
-	spin_unlock(&_audit_contobj_list_lock);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 }
 
 static inline int audit_hash_contid(u64 contid)
@@ -452,11 +468,24 @@ int audit_alloc(struct task_struct *tsk)
 void audit_free(struct task_struct *tsk)
 {
 	struct audit_task_info *info = tsk->audit;
+	unsigned long flags;
+	struct nsproxy *ns = tsk->nsproxy;
+	struct audit_contobj *cont;
 
+	rcu_read_lock();
+	cont = _audit_contobj_get_bytask(tsk);
+	rcu_read_unlock();
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
+	if (ns) {
+		audit_netns_contid_del(ns->net_ns, cont);
+		_audit_contobj_put(cont);
+	}
+	_audit_contobj_put(cont);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 	audit_free_syscall(tsk);
-	spin_lock(&_audit_contobj_list_lock);
-	_audit_contobj_put(info->cont);
-	spin_unlock(&_audit_contobj_list_lock);
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
+	_audit_contobj_put(cont);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 	/* Freeing the audit_task_info struct must be performed after
 	 * audit_log_exit() due to need for loginuid and sessionid.
 	 */
@@ -464,9 +493,9 @@ void audit_free(struct task_struct *tsk)
 	kmem_cache_free(audit_task_cache, info);
 	rcu_read_lock();
 	if (audit_sig_adtsk == tsk) {
-		spin_lock(&_audit_contobj_list_lock);
+		spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 		_audit_contobj_put_sig(audit_sig_cid);
-		spin_unlock(&_audit_contobj_list_lock);
+		spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 		audit_sig_cid = NULL;
 		audit_sig_adtsk = NULL;
 	}
@@ -564,6 +593,145 @@ static struct sock *audit_get_sk(const struct net *net)
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
+	cont = _audit_contobj_get_bytask(tsk);
+	rcu_read_unlock();
+	audit_netns_contid_add(net, cont);
+}
+
+void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
+{
+	struct audit_contobj *cont;
+	struct nsproxy *new = p->nsproxy;
+	unsigned long flags;
+
+	rcu_read_lock();
+	cont = _audit_contobj_get_bytask(p);
+	rcu_read_unlock();
+	if (!cont)
+		return;
+	audit_netns_contid_del(ns->net_ns, cont);
+	if (new)
+		audit_netns_contid_add(new->net_ns, cont);
+	else {
+		spin_lock_irqsave(&_audit_contobj_list_lock, flags);
+		_audit_contobj_put(cont);
+		spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
+	}
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
+	_audit_contobj_put(cont);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
+}
+
+/**
+ * audit_log_netns_contid_list - List contids for the given network namespace
+ * @net: the network namespace of interest
+ * @context: the audit context to use
+ *
+ * Returns 1 for record, 0 for none.
+ *
+ * Description:
+ * Issues a CONTAINER_ID record with a CSV list of contids associated
+ * with a network namespace to accompany a NETFILTER_PKT record.
+ */
+int audit_log_netns_contid_list(struct net *net, struct audit_context *context)
+{
+	struct audit_buffer *ab = NULL;
+	struct audit_contobj_netns *cont;
+	struct audit_net *aunet = net_generic(net, audit_net_id);
+	unsigned int record;
+
+	if (!aunet)
+		return 0;
+	rcu_read_lock();
+	list_for_each_entry_rcu(cont, &aunet->contobj_list, list) {
+		record = 1;
+		if (!ab) {
+			ab = audit_log_start(context, GFP_ATOMIC,
+					     AUDIT_CONTAINER_ID);
+			if (!ab) {
+				audit_log_lost("out of memory in audit_log_netns_contid_list");
+				goto out;
+			}
+			audit_log_format(ab, "record=1 contid=%llu",
+					 cont->obj->id);
+		} else {
+			audit_log_format(ab, ",%llu", cont->obj->id);
+		}
+	}
+	audit_log_end(ab);
+out:
+	rcu_read_unlock();
+	return record;
+}
+EXPORT_SYMBOL(audit_log_netns_contid_list);
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
@@ -1453,6 +1621,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct audit_sig_info2  *sig_data2;
 	char			*ctx = NULL;
 	u32			len;
+	unsigned long		flags;
 
 	err = audit_netlink_ok(skb, msg_type);
 	if (err)
@@ -1726,9 +1895,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
 				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
-		spin_lock(&_audit_contobj_list_lock);
+		spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 		_audit_contobj_put_sig(audit_sig_cid);
-		spin_unlock(&_audit_contobj_list_lock);
+		spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 		audit_sig_cid = NULL;
 		break;
 	case AUDIT_SIGNAL_INFO2: {
@@ -1769,9 +1938,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			memcpy(sig_data2->data + contidstrlen, ctx, len);
 			security_release_secctx(ctx, len);
 		}
-		spin_lock(&_audit_contobj_list_lock);
+		spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 		_audit_contobj_put_sig(audit_sig_cid);
-		spin_unlock(&_audit_contobj_list_lock);
+		spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 		audit_sig_cid = NULL;
 		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
 				 sig_data2, sizeof(*sig_data2) + contidstrlen + len);
@@ -1926,7 +2095,8 @@ static int __net_init audit_net_init(struct net *net)
 		return -ENOMEM;
 	}
 	aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
-
+	INIT_LIST_HEAD(&aunet->contobj_list);
+	spin_lock_init(&aunet->contobj_list_lock);
 	return 0;
 }
 
@@ -2475,6 +2645,7 @@ int audit_log_container_id_ctx(struct audit_context *context)
 {
 	struct audit_contobj *contobj;
 	int record;
+	unsigned long flags;
 
 	rcu_read_lock();
 	contobj = _audit_contobj_get_bytask(current);
@@ -2482,9 +2653,9 @@ int audit_log_container_id_ctx(struct audit_context *context)
 	if (!contobj)
 		return 0;
 	record = _audit_log_container_id(context, contobj);
-	spin_lock(&_audit_contobj_list_lock);
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	_audit_contobj_put(contobj);
-	spin_unlock(&_audit_contobj_list_lock);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 	return record;
 }
 
@@ -2731,6 +2902,7 @@ int audit_signal_info(int sig, struct task_struct *t)
 	    (sig == SIGTERM || sig == SIGHUP ||
 	     sig == SIGUSR1 || sig == SIGUSR2)) {
 		kuid_t uid = current_uid(), auid;
+		unsigned long flags;
 
 		audit_sig_pid = task_tgid_nr(current);
 		auid = audit_get_loginuid(current);
@@ -2739,9 +2911,9 @@ int audit_signal_info(int sig, struct task_struct *t)
 		else
 			audit_sig_uid = uid;
 		security_task_getsecid(current, &audit_sig_sid);
-		spin_lock(&_audit_contobj_list_lock);
+		spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 		_audit_contobj_put_sig(audit_sig_cid);
-		spin_unlock(&_audit_contobj_list_lock);
+		spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 		rcu_read_lock();
 		audit_sig_cid = _audit_contobj_get_sig_bytask(current);
 		rcu_read_unlock();
@@ -2771,6 +2943,8 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 	struct audit_contobj *cont = NULL, *newcont = NULL;
 	int h;
 	struct audit_task_info *info = tsk->audit;
+	unsigned long flags;
+	struct net *net = tsk->nsproxy->net_ns;
 
 	/* Can't set if audit disabled */
 	if (!info) {
@@ -2799,21 +2973,21 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 		goto error;
 
 	h = audit_hash_contid(contid);
-	spin_lock(&_audit_contobj_list_lock);
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
 		if (cont->id == contid) {
 			/* task injection to existing container */
 			if (current == cont->owner) {
 				if (!refcount_read(&cont->refcount)) {
 					rc = -ENOTUNIQ;
-					spin_unlock(&_audit_contobj_list_lock);
+					spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 					goto error;
 				}
 				_audit_contobj_get(cont);
 				newcont = cont;
 			} else {
 				rc = -ENOTUNIQ;
-				spin_unlock(&_audit_contobj_list_lock);
+				spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 				goto error;
 			}
 			break;
@@ -2829,13 +3003,17 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 				     &audit_contid_hash[h]);
 		} else {
 			rc = -ENOMEM;
-			spin_unlock(&_audit_contobj_list_lock);
+			spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 			goto error;
 		}
 	}
 	info->cont = newcont;
 	_audit_contobj_put(oldcont);
-	spin_unlock(&_audit_contobj_list_lock);
+	audit_netns_contid_del(net, oldcont);
+	_audit_contobj_put(oldcont);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
+	_audit_contobj_get(newcont);
+	audit_netns_contid_add(net, newcont);
 error:
 	rcu_read_unlock();
 	task_unlock(tsk);
@@ -2851,9 +3029,9 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 	audit_log_format(ab,
 			 "op=set opid=%d contid=%llu old-contid=%llu",
 			 task_tgid_nr(tsk), contid, oldcont ? oldcont->id : -1);
-	spin_lock(&_audit_contobj_list_lock);
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	_audit_contobj_put(oldcont);
-	spin_unlock(&_audit_contobj_list_lock);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 	audit_log_end(ab);
 	return rc;
 }
@@ -2877,6 +3055,7 @@ void audit_log_container_drop(void)
 {
 	struct audit_buffer *ab;
 	struct audit_contobj *cont;
+	unsigned long flags;
 
 	rcu_read_lock();
 	cont = _audit_contobj_get_bytask(current);
@@ -2892,9 +3071,9 @@ void audit_log_container_drop(void)
 			 task_tgid_nr(current), cont->id);
 	audit_log_end(ab);
 out:
-	spin_lock(&_audit_contobj_list_lock);
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	_audit_contobj_put(cont);
-	spin_unlock(&_audit_contobj_list_lock);
+	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 }
 
 /**
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 12dd41b39a7f..e5ac1f37efd3 100644
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
index 57899454a530..383becc41889 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -66,13 +66,19 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 	struct sk_buff *skb = pkt->skb;
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
+	int record;
 
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	context = audit_alloc_local(GFP_ATOMIC);
+	net = xt_net(&pkt->xt);
+	record = audit_log_netns_contid_list(net, context);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (!ab)
-		return;
+		goto errout;
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
@@ -98,7 +104,11 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 	if (fam == -1)
 		audit_log_format(ab, " saddr=? daddr=? proto=-1");
 
+	if (record)
+		audit_log_format(ab, " record=%d", record);
 	audit_log_end(ab);
+errout:
+	audit_free_context(context);
 }
 
 static void nft_log_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 9cdc16b0d0d8..d2c5069745ea 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -68,10 +68,16 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
+	int record;
 
 	if (audit_enabled == AUDIT_OFF)
-		goto errout;
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+		goto out;
+	context = audit_alloc_local(GFP_ATOMIC);
+	net = xt_net(par);
+	record = audit_log_netns_contid_list(net, context);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -99,9 +105,13 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	if (fam == -1)
 		audit_log_format(ab, " saddr=? daddr=? proto=-1");
 
+	if (record)
+		audit_log_format(ab, " record=%d", record);
 	audit_log_end(ab);
 
 errout:
+	audit_free_context(context);
+out:
 	return XT_CONTINUE;
 }
 
-- 
2.18.4

