Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D920C1B1
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgF0NXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:23:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53432 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726553AbgF0NXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=xHQ23E0ubwuEGdr08pTjn1ZZAxTi7f5b6ScMm0bJY4c=;
        b=M2dos+qSdkdfThdqEhDIKsZdSRpUlnleRLz5SSLKDmUuScAOxPdi2rNPySNeARJxGC++JK
        f87tLOdac2N1CSd3wVCCz7mBf3JyzO1/VTTla2k7/UaFtdNA2jDWgl5RegxJyr4gyBbrSH
        MI5gyle//eXIEsAQ8PIP1qEdX0c4uc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-UOKJWxGZPmy5N6uVApuoTQ-1; Sat, 27 Jun 2020 09:23:44 -0400
X-MC-Unique: UOKJWxGZPmy5N6uVApuoTQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFCF2800C60;
        Sat, 27 Jun 2020 13:23:42 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0901871662;
        Sat, 27 Jun 2020 13:23:29 +0000 (UTC)
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
Subject: [PATCH ghak90 V9 12/13] audit: track container nesting
Date:   Sat, 27 Jun 2020 09:20:45 -0400
Message-Id: <1d793e2fc60650de4bbc9f4bde3c736c94efe9a1.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
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

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |  1 +
 kernel/audit.c        | 60 ++++++++++++++++++++++++++++++++++++++++++---------
 kernel/audit.h        |  2 ++
 kernel/auditfilter.c  | 17 ++++++++++++++-
 kernel/auditsc.c      |  2 +-
 5 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 304fbb7c3c5b..025b52ae8422 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -115,6 +115,7 @@ struct audit_contobj {
 	refcount_t		refcount;
 	refcount_t		sigflag;
 	struct rcu_head         rcu;
+	struct audit_contobj	*parent;
 };
 
 struct audit_task_info {
diff --git a/kernel/audit.c b/kernel/audit.c
index efa65ec01239..aaf74702e993 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -221,6 +221,7 @@ struct audit_reply {
 
 void audit_netns_contid_add(struct net *net, struct audit_contobj *cont);
 void audit_netns_contid_del(struct net *net, struct audit_contobj *cont);
+void audit_log_contid(struct audit_buffer *ab, struct audit_contobj *cont);
 
 void __init audit_task_init(void)
 {
@@ -277,6 +278,7 @@ static void _audit_contobj_put_sig(struct audit_contobj *cont)
 	refcount_set(&cont->sigflag, 0);
 	if (!refcount_read(&cont->refcount)) {
 		put_task_struct(cont->owner);
+		_audit_contobj_put(cont->parent);
 		list_del_rcu(&cont->list);
 		kfree_rcu(cont, rcu);
 	}
@@ -574,7 +576,7 @@ void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
 			audit_log_format(ab, "contid=");
 		} else
 			audit_log_format(ab, ",");
-		audit_log_format(ab, "%llu", cont->obj->id);
+		audit_log_contid(ab, cont->obj);
 	}
 	audit_log_end(ab);
 out:
@@ -1747,7 +1749,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		kfree(sig_data);
 		break;
 	case AUDIT_SIGNAL_INFO2: {
+		char *contidstr = NULL;
 		unsigned int contidstrlen = 0;
+		struct audit_contobj *cont = audit_sig_cid;
 
 		len = 0;
 		if (audit_sig_sid) {
@@ -1757,13 +1761,27 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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
@@ -2444,6 +2462,23 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+void audit_log_contid(struct audit_buffer *ab, struct audit_contobj *cont)
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
  * audit_log_container_id - report container info
  * @context: task or local context for record
@@ -2460,7 +2495,8 @@ void audit_log_container_id(struct audit_context *context,
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
 	if (!ab)
 		return;
-	audit_log_format(ab, "contid=%llu", contid);
+	audit_log_format(ab, "contid=");
+	audit_log_contid(ab, cont);
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL(audit_log_container_id);
@@ -2810,6 +2846,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				INIT_LIST_HEAD(&newcont->list);
 				newcont->id = contid;
 				newcont->owner = get_task_struct(current);
+				newcont->parent = _audit_contobj_get(newcont->owner);
 				refcount_set(&newcont->refcount, 1);
 				list_add_rcu(&newcont->list,
 					     &audit_contid_hash[h]);
@@ -2828,6 +2865,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 		audit_netns_contid_add(net, newcont);
 	}
 conterror:
+	rcu_read_unlock();
 	task_unlock(task);
 
 	if (!audit_enabled)
@@ -2837,12 +2875,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	if (!ab)
 		return rc;
 
-	audit_log_format(ab,
-			 "op=set opid=%d contid=%llu old-contid=%llu",
-			 task_tgid_nr(task), contid, oldcont ? oldcont->id : -1);
+	audit_log_format(ab, "op=set opid=%d contid=%llu old-contid=",
+			 task_tgid_nr(task), contid);
+	audit_log_contid(ab, oldcont);
+	audit_log_end(ab);
+	rcu_read_lock();
 	_audit_contobj_put(oldcont);
 	rcu_read_unlock();
-	audit_log_end(ab);
 	return rc;
 }
 
@@ -2859,8 +2898,9 @@ void audit_log_container_drop(void)
 	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
 	if (!ab)
 		goto out;
-	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=%llu",
-			 task_tgid_nr(current), cont->id, cont->id);
+	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=",
+			 task_tgid_nr(current), AUDIT_CID_UNSET);
+	audit_log_contid(ab, cont);
 	audit_log_end(ab);
 out:
 	rcu_read_unlock();
diff --git a/kernel/audit.h b/kernel/audit.h
index 34d8ec4bc6ef..7bea5b51124b 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -229,6 +229,8 @@ static inline int audit_hash_contid(u64 contid)
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
 extern int audit_comparator64(const u64 left, const u32 op, const u64 right);
+extern int audit_contid_comparator(const u64 left, const u32 op,
+				   const u64 right);
 extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
 extern int parent_len(const char *path);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index d812698efc1d..981c72a8b863 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1302,6 +1302,21 @@ int audit_gid_comparator(kgid_t left, u32 op, kgid_t right)
 	}
 }
 
+int audit_contid_comparator(u64 left, u32 op, u64 right)
+{
+	struct audit_contobj *cont = NULL;
+	int h;
+	int result = 0;
+
+	h = audit_hash_contid(left);
+	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list) {
+		result = audit_comparator64(cont->id, op, right);
+		if (result)
+			break;
+	}
+	return result;
+}
+
 /**
  * parent_len - find the length of the parent portion of a pathname
  * @path: pathname of which to determine length
@@ -1393,7 +1408,7 @@ int audit_filter(int msgtype, unsigned int listtype)
 							  f->op, f->val);
 				break;
 			case AUDIT_CONTID:
-				result = audit_comparator64(audit_get_contid(current),
+				result = audit_contid_comparator(audit_get_contid(current),
 							    f->op, f->val64);
 				break;
 			case AUDIT_MSGTYPE:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index baa5709590b4..9198857ac721 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -641,7 +641,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 							  f->op, f->val);
 			break;
 		case AUDIT_CONTID:
-			result = audit_comparator64(audit_get_contid(tsk),
+			result = audit_contid_comparator(audit_get_contid(tsk),
 						    f->op, f->val64);
 			break;
 		case AUDIT_SUBJ_USER:
-- 
1.8.3.1

