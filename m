Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5CA2DFE9E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgLURAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 12:00:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726632AbgLURAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 12:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608569916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=yPgYcoP9VP6fa7Mr7AH/bm+8Wq47T8v4BZfABnwLLcw=;
        b=CpyR9m7coZo9oRH2dQ0m7rz1NXeCi4cdAKGsHmvRHojGHoYN9mldcGahQyrzAOaFuIysbv
        hWybS1hcq6yZamP7AEv39KaEEBJ/pisMCPWiUKPizTEw6N+IziC3mKBjsY05tHi/JIHzCY
        CT7aM82yGJCsgEOf9nAMyUh+UUb4ghI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-XfR89AuENdmL3ZH03qxN6A-1; Mon, 21 Dec 2020 11:58:34 -0500
X-MC-Unique: XfR89AuENdmL3ZH03qxN6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91CEF801817;
        Mon, 21 Dec 2020 16:58:32 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D514860C61;
        Mon, 21 Dec 2020 16:58:15 +0000 (UTC)
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
Subject: [PATCH ghak90 v10 10/11] audit: track container nesting
Date:   Mon, 21 Dec 2020 11:55:44 -0500
Message-Id: <ceca0192c35bde32f1adb5148eca08375edbc116.1608225886.git.rgb@redhat.com>
In-Reply-To: <cover.1608225886.git.rgb@redhat.com>
References: <cover.1608225886.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track the parent container of a container to be able to filter and
report nesting.

Now that we have a way to track and check the parent container of a
container, modify the contid field format to be able to report that
nesting using a carrat ("^") modifier to indicate nesting.  The
original field format was "contid=<contid>" for task-associated records
and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
records.  The new field format is
"contid=<contid>[,^<contid>[...]][,<contid>[...]]".

For task event example, an orchestrator in contid 1 spawns tasks in contid
2 and contid 3, then the task in contid 2 spawns a task in contid 4.  An
event happens in the task in contid 4:
    type=SYSCALL ...
    type=CONTAINER_ID msg=audit(<date.time>:<serno>): contid=4,^2,^1

For a network namespace event example, an orchestrator in contid 1 in
network namespace A spawns peer tasks 2 and 3 in network namespace B.  An
event happens in network namespace B:
    type=NETFILTER_PKT ...
    type=CONTAINER_ID msg=audit(<date.time>:<serno>): contid=2,^1,3,^1

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c | 75 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 6eed8ed0cc8e..46ddf49f731f 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -231,6 +231,7 @@ struct audit_contobj {
 	refcount_t		refcount;
 	refcount_t		sigflag;
 	struct rcu_head         rcu;
+	struct audit_contobj	*parent;
 };
 
 struct audit_task_info {
@@ -253,6 +254,7 @@ struct audit_contobj_netns {
 
 static void audit_netns_contid_add(struct net *net, struct audit_contobj *cont);
 static void audit_netns_contid_del(struct net *net, struct audit_contobj *cont);
+static void audit_log_contid(struct audit_buffer *ab, struct audit_contobj *cont);
 
 void __init audit_task_init(void)
 {
@@ -378,6 +380,7 @@ static void _audit_contobj_put_sig(struct audit_contobj *cont)
 	refcount_set(&cont->sigflag, 0);
 	if (!refcount_read(&cont->refcount)) {
 		put_task_struct(cont->owner);
+		_audit_contobj_put(cont->parent);
 		list_del_rcu(&cont->list);
 		kfree_rcu(cont, rcu);
 	}
@@ -721,11 +724,11 @@ int audit_log_netns_contid_list(struct net *net, struct audit_context *context)
 				audit_log_lost("out of memory in audit_log_netns_contid_list");
 				goto out;
 			}
-			audit_log_format(ab, "record=1 contid=%llu",
-					 cont->obj->id);
+			audit_log_format(ab, "record=1 contid=");
 		} else {
-			audit_log_format(ab, ",%llu", cont->obj->id);
+			audit_log_format(ab, ",");
 		}
+		audit_log_contid(ab, cont->obj);
 	}
 	audit_log_end(ab);
 out:
@@ -1905,6 +1908,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_SIGNAL_INFO2: {
 		char *contidstr = NULL;
 		unsigned int contidstrlen = 0;
+		struct audit_contobj *cont = audit_sig_cid;
 
 		len = 0;
 		if (audit_sig_sid) {
@@ -1914,13 +1918,27 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				return err;
 		}
 		if (audit_sig_cid) {
-			contidstr = kmalloc(21, GFP_KERNEL);
+			contidstr = kmalloc(AUDIT_MESSAGE_TEXT_MAX, GFP_KERNEL);
 			if (!contidstr) {
 				if (audit_sig_sid)
 					security_release_secctx(ctx, len);
 				return -ENOMEM;
 			}
-			contidstrlen = scnprintf(contidstr, 20, "%llu", audit_sig_cid->id);
+			rcu_read_lock();
+			while (cont) {
+				if (cont->parent)
+					contidstrlen += scnprintf(contidstr,
+								  AUDIT_MESSAGE_TEXT_MAX -
+								  contidstrlen,
+								  "%llu,^", cont->id);
+				else
+					contidstrlen += scnprintf(contidstr,
+								  AUDIT_MESSAGE_TEXT_MAX -
+								  contidstrlen,
+								  "%llu", cont->id);
+				cont = cont->parent;
+			}
+			rcu_read_unlock();
 		}
 		sig_data2 = kmalloc(sizeof(*sig_data2) + contidstrlen + len, GFP_KERNEL);
 		if (!sig_data2) {
@@ -2607,6 +2625,23 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+static void audit_log_contid(struct audit_buffer *ab, struct audit_contobj *cont)
+{
+	if (!cont) {
+		audit_log_format(ab, "-1");
+		return;
+	}
+	rcu_read_lock();
+	while (cont) {
+		if (cont->parent)
+			audit_log_format(ab, "%llu,^", cont->id);
+		else
+			audit_log_format(ab, "%llu", cont->id);
+		cont = cont->parent;
+	}
+	rcu_read_unlock();
+}
+
 /*
  * _audit_log_container_id - report container info
  * @context: task or local context for record
@@ -2626,8 +2661,9 @@ static int _audit_log_container_id(struct audit_context *context,
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
 	if (!ab)
 		return 0;
-	audit_log_format(ab, "record=%d contid=%llu",
-			 record = ++context->contid_records, contobj->id);
+	audit_log_format(ab, "record=%d contid=",
+			 record = ++context->contid_records);
+	audit_log_contid(ab, contobj);
 	audit_log_end(ab);
 	return record;
 }
@@ -2663,7 +2699,18 @@ int audit_log_container_id_ctx(struct audit_context *context)
 
 int audit_contid_comparator(struct task_struct *tsk, u32 op, u64 right)
 {
-	return audit_comparator64(audit_get_contid(tsk), op, right);
+	struct audit_contobj *cont = NULL;
+	int h;
+	int result = 0;
+	u64 left = audit_get_contid(tsk);
+
+	h = audit_hash_contid(left);
+	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list) {
+		result = audit_comparator64(cont->id, op, right);
+		if (result)
+			break;
+	}
+	return result;
 }
 
 void audit_log_key(struct audit_buffer *ab, char *key)
@@ -3018,6 +3065,7 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 			INIT_LIST_HEAD(&newcont->list);
 			newcont->id = contid;
 			newcont->owner = get_task_struct(current);
+			newcont->parent = _audit_contobj_get_bytask(newcont->owner);
 			refcount_set(&newcont->refcount, 1);
 			list_add_rcu(&newcont->list,
 				     &audit_contid_hash[h]);
@@ -3046,9 +3094,9 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 	if (!ab)
 		return rc;
 
-	audit_log_format(ab,
-			 "op=set opid=%d contid=%llu old-contid=%llu",
-			 task_tgid_nr(tsk), contid, oldcont ? oldcont->id : -1);
+	audit_log_format(ab, "op=set opid=%d contid=%llu old-contid=",
+			 task_tgid_nr(tsk), contid);
+	audit_log_contid(ab, oldcont);
 	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	_audit_contobj_put(oldcont);
 	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
@@ -3087,8 +3135,9 @@ void audit_log_container_drop(void)
 	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
 	if (!ab)
 		goto out;
-	audit_log_format(ab, "op=drop opid=%d contid=-1 old-contid=%llu",
-			 task_tgid_nr(current), cont->id);
+	audit_log_format(ab, "op=drop opid=%d contid=-1 old-contid=",
+			 task_tgid_nr(current));
+	audit_log_contid(ab, cont);
 	audit_log_end(ab);
 out:
 	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
-- 
2.18.4

