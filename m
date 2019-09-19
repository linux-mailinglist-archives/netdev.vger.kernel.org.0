Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D73B70E4
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfISB1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387682AbfISB1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:27:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4A90381DE0;
        Thu, 19 Sep 2019 01:27:18 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0468C60C5E;
        Thu, 19 Sep 2019 01:27:01 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 18/21] audit: track container nesting
Date:   Wed, 18 Sep 2019 21:22:35 -0400
Message-Id: <a6b00624ac746bc0df9dd0044311b8364374b25b.1568834525.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 19 Sep 2019 01:27:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track the parent container of a container to be able to filter and
report nesting.

Now that we have a way to track and check the parent container of a
container, fixup other patches, or squash all nesting fixes together.

fixup! audit: add container id
fixup! audit: log drop of contid on exit of last task
fixup! audit: log container info of syscalls
fixup! audit: add containerid filtering
fixup! audit: NETFILTER_PKT: record each container ID associated with a netNS
fixup! audit: convert to contid list to check for orch/engine ownership softirq (for netfilter) audit: protect contid list lock from softirq

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h |  1 +
 kernel/audit.c        | 67 ++++++++++++++++++++++++++++++++++++++++++---------
 kernel/audit.h        |  3 +++
 kernel/auditfilter.c  | 20 ++++++++++++++-
 kernel/auditsc.c      |  2 +-
 5 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index dcd92f964120..1ce27af686ea 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -110,6 +110,7 @@ struct audit_cont {
 	struct task_struct	*owner;
 	refcount_t              refcount;
 	struct rcu_head         rcu;
+	struct audit_cont	*parent;
 };
 
 struct audit_task_info {
diff --git a/kernel/audit.c b/kernel/audit.c
index 9e82de13d2eb..848fd1c8c579 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -213,7 +213,7 @@ struct audit_reply {
 
 static struct kmem_cache *audit_task_cache;
 
-static DEFINE_SPINLOCK(audit_contid_list_lock);
+DEFINE_SPINLOCK(audit_contid_list_lock);
 
 void __init audit_task_init(void)
 {
@@ -275,6 +275,7 @@ void audit_free(struct task_struct *tsk)
 {
 	struct audit_task_info *info = tsk->audit;
 	struct nsproxy *ns = tsk->nsproxy;
+	unsigned long flags;
 
 	audit_free_syscall(tsk);
 	if (ns)
@@ -282,9 +283,9 @@ void audit_free(struct task_struct *tsk)
 	/* Freeing the audit_task_info struct must be performed after
 	 * audit_log_exit() due to need for loginuid and sessionid.
 	 */
-	spin_lock(&audit_contid_list_lock); 
+	spin_lock_irqsave(&audit_contid_list_lock, flags); 
 	audit_cont_put(tsk->audit->cont);
-	spin_unlock(&audit_contid_list_lock); 
+	spin_unlock_irqrestore(&audit_contid_list_lock, flags); 
 	info = tsk->audit;
 	tsk->audit = NULL;
 	kmem_cache_free(audit_task_cache, info);
@@ -450,6 +451,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 		audit_netns_contid_add(new->net_ns, contid);
 }
 
+void audit_log_contid(struct audit_buffer *ab, u64 contid);
 /**
  * audit_log_netns_contid_list - List contids for the given network namespace
  * @net: the network namespace of interest
@@ -481,7 +483,7 @@ void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
 			audit_log_format(ab, "contid=");
 		} else
 			audit_log_format(ab, ",");
-		audit_log_format(ab, "%llu", cont->id);
+		audit_log_contid(ab, cont->id);
 	}
 	audit_log_end(ab);
 out:
@@ -2371,6 +2373,36 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+void audit_log_contid(struct audit_buffer *ab, u64 contid)
+{
+	struct audit_cont *cont = NULL;
+	struct audit_cont *prcont = NULL;
+	int h;
+	unsigned long flags;
+
+	if (!audit_contid_valid(contid)) {
+		audit_log_format(ab, "%llu", contid);
+		return;
+	}
+	h = audit_hash_contid(contid);
+	spin_lock_irqsave(&audit_contid_list_lock, flags);
+	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
+		if (cont->id == contid)
+			prcont = cont;
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
+	spin_unlock_irqrestore(&audit_contid_list_lock, flags);
+}
+
 /*
  * audit_log_container_id - report container info
  * @context: task or local context for record
@@ -2386,7 +2418,8 @@ void audit_log_container_id(struct audit_context *context, u64 contid)
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
 	if (!ab)
 		return;
-	audit_log_format(ab, "contid=%llu", contid);
+	audit_log_format(ab, "contid=");
+	audit_log_contid(ab, contid);
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL(audit_log_container_id);
@@ -2648,6 +2681,7 @@ void audit_cont_put(struct audit_cont *cont)
 		return;
 	if (refcount_dec_and_test(&cont->refcount)) {
 		put_task_struct(cont->owner);
+		audit_cont_put(cont->parent);
 		list_del_rcu(&cont->list);
 		kfree_rcu(cont, rcu);
 		audit_contid_count--;
@@ -2732,8 +2766,9 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 		struct audit_cont *cont = NULL;
 		struct audit_cont *newcont = NULL;
 		int h = audit_hash_contid(contid);
+		unsigned long flags;
 
-		spin_lock(&audit_contid_list_lock);
+		spin_lock_irqsave(&audit_contid_list_lock, flags);
 		list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
 			if (cont->id == contid) {
 				/* task injection to existing container */
@@ -2757,6 +2792,9 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				newcont->id = contid;
 				get_task_struct(current);
 				newcont->owner = current;
+				newcont->parent = audit_cont(newcont->owner);
+				if (newcont->parent)
+					refcount_inc(&newcont->parent->refcount);
 				refcount_set(&newcont->refcount, 1);
 				list_add_rcu(&newcont->list, &audit_contid_hash[h]);
 				audit_contid_count++;
@@ -2768,7 +2806,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 		task->audit->cont = newcont;
 		audit_cont_put(oldcont);
 conterror:
-		spin_unlock(&audit_contid_list_lock);
+		spin_unlock_irqrestore(&audit_contid_list_lock, flags);
 	}
 	if (!rc) {
 		if (audit_contid_valid(oldcontid))
@@ -2786,9 +2824,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 
 	uid = from_kuid(&init_user_ns, task_uid(current));
 	tty = audit_get_tty();
+	audit_log_format(ab, "op=set opid=%d contid=", task_tgid_nr(task));
+	audit_log_contid(ab, contid);
+	audit_log_format(ab, " old-contid=");
+	audit_log_contid(ab, oldcontid);
 	audit_log_format(ab,
-			 "op=set opid=%d contid=%llu old-contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
-			 task_tgid_nr(task), contid, oldcontid,
+			 " pid=%d uid=%u auid=%u tty=%s ses=%u",
 			 task_tgid_nr(current), uid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			 tty ? tty_name(tty) : "(none)",
@@ -2819,10 +2860,12 @@ void audit_log_container_drop(void)
 
 	uid = from_kuid(&init_user_ns, task_uid(current));
 	tty = audit_get_tty();
+	audit_log_format(ab, "op=drop opid=%d contid=%llu old-contid=",
+			 task_tgid_nr(current), AUDIT_CID_UNSET);
+	audit_log_contid(ab, audit_get_contid(current));
 	audit_log_format(ab,
-			 "op=drop opid=%d contid=%llu old-contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
-			 task_tgid_nr(current), audit_get_contid(current),
-			 audit_get_contid(current), task_tgid_nr(current), uid,
+			 " pid=%d uid=%u auid=%u tty=%s ses=%u",
+			 task_tgid_nr(current), uid,
 			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			 tty ? tty_name(tty) : "(none)",
        			 audit_get_sessionid(current));
diff --git a/kernel/audit.h b/kernel/audit.h
index 25732fbc47a4..89b7de323c13 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -220,6 +220,8 @@ static inline int audit_hash_contid(u64 contid)
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
 }
 
+extern spinlock_t audit_contid_list_lock;
+
 extern int audit_contid_count;
 
 #define AUDIT_CONTID_COUNT	1 << 16
@@ -235,6 +237,7 @@ struct audit_contid_status {
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
 extern int audit_comparator64(const u64 left, const u32 op, const u64 right);
+extern int audit_contid_comparator(const u64 left, const u32 op, const u64 right);
 extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
 extern int parent_len(const char *path);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 9606f973fe33..513d57d03637 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1297,6 +1297,24 @@ int audit_gid_comparator(kgid_t left, u32 op, kgid_t right)
 	}
 }
 
+int audit_contid_comparator(u64 left, u32 op, u64 right)
+{
+	struct audit_cont *cont = NULL;
+	int h;
+	int result = 0;
+	unsigned long flags;
+
+	h = audit_hash_contid(left);
+	spin_lock_irqsave(&audit_contid_list_lock, flags);
+	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list) {
+		result = audit_comparator64(cont->id, op, right);
+		if (result)
+			break;
+	}
+	spin_unlock_irqrestore(&audit_contid_list_lock, flags);
+	return result;
+}
+
 /**
  * parent_len - find the length of the parent portion of a pathname
  * @path: pathname of which to determine length
@@ -1388,7 +1406,7 @@ int audit_filter(int msgtype, unsigned int listtype)
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

