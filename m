Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1888612DB8B
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 20:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLaTvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 14:51:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59320 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727487AbfLaTvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 14:51:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577821881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=J9fbi1o1u2+bx30RCLzuhAeZtnzoIeJSFxvNNtp7VC8=;
        b=Z/9Hop7yhD2/ErC9bjCEpWEYm7C8Eu45T/i+0yEKnKBEx78Pr0VqWfi4NzKFd9e7aYCO7X
        boDCmFBR4ZEjgICNR6q2tGlDsOjtjm6kt7hgp7Ve5o5xiuM1yyvj2OvnNACF4hTwDXH/S5
        UbU9pKgT5Kp2E+nl/ALN8X0iCEMLCWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-gqwhrgfhPdynen3Yq3q8LA-1; Tue, 31 Dec 2019 14:51:20 -0500
X-MC-Unique: gqwhrgfhPdynen3Yq3q8LA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A1DD18031D3;
        Tue, 31 Dec 2019 19:51:18 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-15.phx2.redhat.com [10.3.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FF7967673;
        Tue, 31 Dec 2019 19:51:13 +0000 (UTC)
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
Subject: [PATCH ghak90 V8 13/16] audit: track container nesting
Date:   Tue, 31 Dec 2019 14:48:26 -0500
Message-Id: <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
In-Reply-To: <cover.1577736799.git.rgb@redhat.com>
References: <cover.1577736799.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track the parent container of a container to be able to filter and
report nesting.

Now that we have a way to track and check the parent container of a
container, modify the contid field format to be able to report that
nesting using a carrat ("^") separator to indicate nesting.  The
original field format was "contid=<contid>" for task-associated records
and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
records.  The new field format is
"contid=<contid>[^<contid>[...]][,<contid>[...]]".

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |  1 +
 kernel/audit.c        | 53 +++++++++++++++++++++++++++++++++++++++++++--------
 kernel/audit.h        |  1 +
 kernel/auditfilter.c  | 17 ++++++++++++++++-
 kernel/auditsc.c      |  2 +-
 5 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index ed8d5b74758d..4272b468417a 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -109,6 +109,7 @@ struct audit_contobj {
 	struct task_struct	*owner;
 	refcount_t              refcount;
 	struct rcu_head         rcu;
+	struct audit_contobj	*parent;
 };
 
 struct audit_task_info {
diff --git a/kernel/audit.c b/kernel/audit.c
index ef8e07524c46..68be59d1a89b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -251,6 +251,7 @@ static void _audit_contobj_put(struct audit_contobj *cont)
 		return;
 	if (refcount_dec_and_test(&cont->refcount)) {
 		put_task_struct(cont->owner);
+		_audit_contobj_put(cont->parent);
 		list_del_rcu(&cont->list);
 		kfree_rcu(cont, rcu);
 	}
@@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 		audit_netns_contid_add(new->net_ns, contid);
 }
 
+void audit_log_contid(struct audit_buffer *ab, u64 contid);
 /**
  * audit_log_netns_contid_list - List contids for the given network namespace
  * @net: the network namespace of interest
@@ -523,7 +525,7 @@ void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
 			audit_log_format(ab, "contid=");
 		} else
 			audit_log_format(ab, ",");
-		audit_log_format(ab, "%llu", cont->id);
+		audit_log_contid(ab, cont->id);
 	}
 	audit_log_end(ab);
 out:
@@ -2311,6 +2313,36 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+void audit_log_contid(struct audit_buffer *ab, u64 contid)
+{
+	struct audit_contobj *cont = NULL, *prcont = NULL;
+	int h;
+
+	if (!audit_contid_valid(contid)) {
+		audit_log_format(ab, "%llu", contid);
+		return;
+	}
+	h = audit_hash_contid(contid);
+	rcu_read_lock();
+	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
+		if (cont->id == contid) {
+			prcont = cont;
+			break;
+		}
+	if (!prcont) {
+		audit_log_format(ab, "%llu", contid);
+		goto out;
+	}
+	while (prcont) {
+		audit_log_format(ab, "%llu", prcont->id);
+		prcont = prcont->parent;
+		if (prcont)
+			audit_log_format(ab, "^");
+	}
+out:
+	rcu_read_unlock();
+}
+
 /*
  * audit_log_container_id - report container info
  * @context: task or local context for record
@@ -2326,7 +2358,8 @@ void audit_log_container_id(struct audit_context *context, u64 contid)
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
 	if (!ab)
 		return;
-	audit_log_format(ab, "contid=%llu", contid);
+	audit_log_format(ab, "contid=");
+	audit_log_contid(ab, contid);
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL(audit_log_container_id);
@@ -2675,6 +2708,9 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				newcont->id = contid;
 				get_task_struct(current);
 				newcont->owner = current;
+				newcont->parent = _audit_contobj(newcont->owner);
+				if (newcont->parent)
+					_audit_contobj_hold(newcont->parent);
 				refcount_set(&newcont->refcount, 1);
 				spin_lock(&audit_contobj_list_lock);
 				list_add_rcu(&newcont->list, &audit_contid_hash[h]);
@@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	if (!ab)
 		return rc;
 
-	audit_log_format(ab,
-			 "op=set opid=%d contid=%llu old-contid=%llu",
-			 task_tgid_nr(task), contid, oldcontid);
+	audit_log_format(ab, "op=set opid=%d contid=", task_tgid_nr(task));
+	audit_log_contid(ab, contid);
+	audit_log_format(ab, " old-contid=");
+	audit_log_contid(ab, oldcontid);
 	audit_log_end(ab);
 	return rc;
 }
@@ -2723,9 +2760,9 @@ void audit_log_container_drop(void)
 	if (!ab)
 		return;
 
-	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=%llu",
-			 task_tgid_nr(current), audit_get_contid(current),
-			 audit_get_contid(current));
+	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=",
+			 task_tgid_nr(current), AUDIT_CID_UNSET);
+	audit_log_contid(ab, audit_get_contid(current));
 	audit_log_end(ab);
 }
 
diff --git a/kernel/audit.h b/kernel/audit.h
index 5e2f5c9820d8..de814fcbb38c 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -226,6 +226,7 @@ static inline int audit_hash_contid(u64 contid)
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
 extern int audit_comparator64(const u64 left, const u32 op, const u64 right);
+extern int audit_contid_comparator(const u64 left, const u32 op, const u64 right);
 extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
 extern int parent_len(const char *path);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 9606f973fe33..1757896740e8 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1297,6 +1297,21 @@ int audit_gid_comparator(kgid_t left, u32 op, kgid_t right)
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
@@ -1388,7 +1403,7 @@ int audit_filter(int msgtype, unsigned int listtype)
 							  f->op, f->val);
 				break;
 			case AUDIT_CONTID:
-				result = audit_comparator64(audit_get_contid(current),
+				result = audit_contid_comparator(audit_get_contid(current),
 							    f->op, f->val64);
 				break;
 			case AUDIT_MSGTYPE:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a658fe775b86..6bf6d8b9dfd1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -630,7 +630,7 @@ static int audit_filter_rules(struct task_struct *tsk,
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

