Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D703C20C188
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgF0NWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:22:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24092 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726765AbgF0NWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=6qtunjE5ws/F4Adj5tQCB/kH4v2kuL7jtyqe5YAUFwU=;
        b=OrIo+R3JFD9R8bhZn4lOX3pFjFyu6tKcUSIA4vBA0RBdMo+smkXTAA5hs532AYfeXNFl7i
        AnPpmzE6IB9KmgK27PJ+xAqRTNRuTkV2diixvuWseGB82FCxI0DYxOuJXOje2tb1WD/fLp
        t3FX/hW+eL6MgQyeT1HdWdHFYN3VBtc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-iExRSYVTOjm3bv2NNWNE1A-1; Sat, 27 Jun 2020 09:22:28 -0400
X-MC-Unique: iExRSYVTOjm3bv2NNWNE1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 860DE8031F6;
        Sat, 27 Jun 2020 13:22:26 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE857932A;
        Sat, 27 Jun 2020 13:22:13 +0000 (UTC)
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
Subject: [PATCH ghak90 V9 05/13] audit: log container info of syscalls
Date:   Sat, 27 Jun 2020 09:20:38 -0400
Message-Id: <6e2e10432e1400f747918eeb93bf45029de2aa6c.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new audit record AUDIT_CONTAINER_ID to document the audit
container identifier of a process if it is present.

Called from audit_log_exit(), syscalls are covered.

Include target_cid references from ptrace and signal.

A sample raw event:
type=SYSCALL msg=audit(1519924845.499:257): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=56374e1cef30 a2=241 a3=1b6 items=2 ppid=606 pid=635 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=3 comm="bash" exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="tmpcontainerid"
type=CWD msg=audit(1519924845.499:257): cwd="/root"
type=PATH msg=audit(1519924845.499:257): item=0 name="/tmp/" inode=13863 dev=00:27 mode=041777 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype= PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
type=PATH msg=audit(1519924845.499:257): item=1 name="/tmp/tmpcontainerid" inode=17729 dev=00:27 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
type=PROCTITLE msg=audit(1519924845.499:257): proctitle=62617368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E7461696E65726964
type=CONTAINER_ID msg=audit(1519924845.499:257): contid=123458

Please see the github audit kernel issue for the main feature:
  https://github.com/linux-audit/audit-kernel/issues/90
Please see the github audit userspace issue for supporting additions:
  https://github.com/linux-audit/audit-userspace/issues/51
Please see the github audit testsuiite issue for the test case:
  https://github.com/linux-audit/audit-testsuite/issues/64
Please see the github audit wiki for the feature overview:
  https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/linux/audit.h      |  7 +++++++
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             | 25 +++++++++++++++++++++++--
 kernel/audit.h             |  4 ++++
 kernel/auditsc.c           | 45 +++++++++++++++++++++++++++++++++++++++------
 5 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2800d4f1a2a8..5eeba0efffc2 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -222,6 +222,9 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 	return tsk->audit->cont->id;
 }
 
+extern void audit_log_container_id(struct audit_context *context,
+				   struct audit_contobj *cont);
+
 extern u32 audit_enabled;
 
 extern int audit_signal_info(int sig, struct task_struct *t);
@@ -291,6 +294,10 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 	return AUDIT_CID_UNSET;
 }
 
+static inline void audit_log_container_id(struct audit_context *context,
+					  struct audit_contobj *cont)
+{ }
+
 #define audit_enabled AUDIT_OFF
 
 static inline int audit_signal_info(int sig, struct task_struct *t)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 859382527210..fd98460c983f 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -119,6 +119,7 @@
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
 #define AUDIT_BPF		1334	/* BPF subsystem */
 #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
+#define AUDIT_CONTAINER_ID	1336	/* Container ID */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.c b/kernel/audit.c
index 9e0b38ce1ead..a09f8f661234 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -227,7 +227,7 @@ static struct audit_contobj *_audit_contobj_hold(struct audit_contobj *cont)
 	return cont;
 }
 
-static struct audit_contobj *_audit_contobj_get(struct task_struct *tsk)
+struct audit_contobj *_audit_contobj_get(struct task_struct *tsk)
 {
 	if (!tsk->audit)
 		return NULL;
@@ -235,7 +235,7 @@ static struct audit_contobj *_audit_contobj_get(struct task_struct *tsk)
 }
 
 /* rcu_read_lock must be held by caller */
-static void _audit_contobj_put(struct audit_contobj *cont)
+void _audit_contobj_put(struct audit_contobj *cont)
 {
 	if (!cont)
 		return;
@@ -2211,6 +2211,27 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+/*
+ * audit_log_container_id - report container info
+ * @context: task or local context for record
+ * @cont: container object to report
+ */
+void audit_log_container_id(struct audit_context *context,
+			    struct audit_contobj *cont)
+{
+	struct audit_buffer *ab;
+
+	if (!cont)
+		return;
+	/* Generate AUDIT_CONTAINER_ID record with container ID */
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
+	if (!ab)
+		return;
+	audit_log_format(ab, "contid=%llu", contid);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL(audit_log_container_id);
+
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
 	audit_log_format(ab, " key=");
diff --git a/kernel/audit.h b/kernel/audit.h
index d07093903008..0c9446f8d52c 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -135,6 +135,7 @@ struct audit_context {
 	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
 	u32		    target_sid;
+	struct audit_contobj *target_cid;
 	char		    target_comm[TASK_COMM_LEN];
 
 	struct audit_tree_refs *trees, *first_trees;
@@ -218,6 +219,9 @@ static inline int audit_hash_contid(u64 contid)
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
 }
 
+extern struct audit_contobj *_audit_contobj_get(struct task_struct *tsk);
+extern void _audit_contobj_put(struct audit_contobj *cont);
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f03d3eb0752c..9e79645e5c0e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -113,6 +113,7 @@ struct audit_aux_data_pids {
 	kuid_t			target_uid[AUDIT_AUX_PIDS];
 	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
 	u32			target_sid[AUDIT_AUX_PIDS];
+	struct audit_contobj	*target_cid[AUDIT_AUX_PIDS];
 	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
 	int			pid_count;
 };
@@ -889,13 +890,20 @@ static inline void audit_free_names(struct audit_context *context)
 static inline void audit_free_aux(struct audit_context *context)
 {
 	struct audit_aux_data *aux;
+	struct audit_aux_data_pids *axp;
 
+	_audit_contobj_put(context->target_cid);
 	while ((aux = context->aux)) {
 		context->aux = aux->next;
 		kfree(aux);
 	}
 	while ((aux = context->aux_pids)) {
+		int i;
+
 		context->aux_pids = aux->next;
+		axp = (struct audit_aux_data_pids *)aux;
+		for (i = 0; i < axp->pid_count; i++)
+			_audit_contobj_put(axp->target_cid[i]);
 		kfree(aux);
 	}
 }
@@ -1458,6 +1466,7 @@ static void audit_log_exit(void)
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
 	struct audit_names *n;
+	struct audit_contobj *cont;
 
 	context->personality = current->personality;
 
@@ -1541,7 +1550,7 @@ static void audit_log_exit(void)
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
 
-		for (i = 0; i < axs->pid_count; i++)
+		for (i = 0; i < axs->pid_count; i++) {
 			if (audit_log_pid_context(context, axs->target_pid[i],
 						  axs->target_auid[i],
 						  axs->target_uid[i],
@@ -1549,14 +1558,20 @@ static void audit_log_exit(void)
 						  axs->target_sid[i],
 						  axs->target_comm[i]))
 				call_panic = 1;
+			audit_log_container_id(context, axs->target_cid[i]);
+		}
 	}
 
-	if (context->target_pid &&
-	    audit_log_pid_context(context, context->target_pid,
-				  context->target_auid, context->target_uid,
-				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+	if (context->target_pid) {
+		if (audit_log_pid_context(context, context->target_pid,
+					  context->target_auid,
+					  context->target_uid,
+					  context->target_sessionid,
+					  context->target_sid,
+					  context->target_comm))
 			call_panic = 1;
+		audit_log_container_id(context, context->target_cid);
+	}
 
 	if (context->pwd.dentry && context->pwd.mnt) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
@@ -1575,6 +1590,14 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	rcu_read_lock();
+	cont = _audit_contobj_get(current);
+	rcu_read_unlock();
+	audit_log_container_id(context, cont);
+	rcu_read_lock();
+	_audit_contobj_put(cont);
+	rcu_read_unlock();
+
 	audit_log_container_drop();
 
 	/* Send end of event record to help user space know we are finished */
@@ -2385,6 +2408,10 @@ void __audit_ptrace(struct task_struct *t)
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
+	rcu_read_lock();
+	_audit_contobj_put(context->target_cid);
+	context->target_cid = _audit_contobj_get(t);
+	rcu_read_unlock();
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2412,6 +2439,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
+		rcu_read_lock();
+		ctx->target_cid = _audit_contobj_get(t);
+		rcu_read_unlock();
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2433,6 +2463,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
+	rcu_read_lock();
+	axp->target_cid[axp->pid_count] = _audit_contobj_get(t);
+	rcu_read_unlock();
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
-- 
1.8.3.1

