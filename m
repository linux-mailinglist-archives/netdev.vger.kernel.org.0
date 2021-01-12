Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAA12F33CC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403789AbhALPMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:12:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56366 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389426AbhALPM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610464261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Kk6Nzwn3umjTOuB5yGDNbtr85xT4w2cQHn90rXYF93k=;
        b=Z6awm/RmAY4S4Iz0Zl+wL7R4ph2/08sapYxpdKieTdubNfNRun+yW69/Evf13bpkbLgbK5
        PQZ3lYdv+tbPztXWvRDjKYmyTw/ppG3aUe0i5qH7wV1OhmWz1xY9Hs4MGSJqAIa2Vo+ARP
        EboOx/iV/+ieWeihKH8YrHsZP0MNeuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-CXcgC2LtNSOFZD8yy1MqpA-1; Tue, 12 Jan 2021 10:10:57 -0500
X-MC-Unique: CXcgC2LtNSOFZD8yy1MqpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1422D801B12;
        Tue, 12 Jan 2021 15:10:55 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 247595D9CD;
        Tue, 12 Jan 2021 15:10:44 +0000 (UTC)
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
Subject: [PATCH ghak90 v11 03/11] audit: log container info of syscalls
Date:   Tue, 12 Jan 2021 10:09:31 -0500
Message-Id: <84026735e3627d193d5f15ea2b15a2895ed31e3e.1610399347.git.rgb@redhat.com>
In-Reply-To: <cover.1610399347.git.rgb@redhat.com>
References: <cover.1610399347.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new audit record AUDIT_CONTAINER_ID to document the audit
container identifier of a process if it is present.

Called from audit_log_exit(), syscalls are covered.

Include target_cid references from ptrace and signal.

A sample raw event:
  time->Thu Nov 26 10:24:40 2020
  type=PROCTITLE msg=audit(1606404280.226:174542): proctitle=2F7573722F62696E2F7065726C002D7700636F6E7461696E657269642F74657374
  type=PATH msg=audit(1606404280.226:174542): item=1 name="/tmp/audit-testsuite-dir-8riQ/testsuite-1606404267-WNldVJCr" inode=428 dev=00:1f mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
  type=PATH msg=audit(1606404280.226:174542): item=0 name="/tmp/audit-testsuite-dir-8riQ/" inode=427 dev=00:1f mode=040700 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
  type=CWD msg=audit(1606404280.226:174542): cwd="/root/rgb/git/audit-testsuite/tests"
  type=SYSCALL msg=audit(1606404280.226:174542): arch=c000003e syscall=257 success=yes exit=6 a0=ffffff9c a1=557446bd5f10 a2=80241 a3=1b6 items=2 ppid=8724 pid=8758 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=1 comm="perl" exe="/usr/bin/perl" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="testsuite-1606404267-WNldVJCr" record=1
  type=CONTAINER_ID msg=audit(1606404280.226:174542): record=1 contid=527940429489930240

Please see the github audit kernel issue for the main feature:
  https://github.com/linux-audit/audit-kernel/issues/90
Please see the github audit userspace issue for supporting additions:
  https://github.com/linux-audit/audit-userspace/issues/51
Please see the github audit testsuiite issue for the test case:
  https://github.com/linux-audit/audit-testsuite/issues/64
Please see the github audit wiki for the feature overview:
  https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Acks removed due to added "record=" field, track container of signalled process
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             | 74 ++++++++++++++++++++++++++++++++++++++
 kernel/audit.h             |  6 ++++
 kernel/auditsc.c           | 49 ++++++++++++++++++++-----
 4 files changed, 122 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 26d65d0882e2..c56335e828dc 100644
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
index fe94b295a362..5495b69bc505 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -319,6 +319,11 @@ static struct audit_contobj *_audit_contobj_get_bytask(struct task_struct *tsk)
 	return _audit_contobj_get(info->cont);
 }
 
+void *audit_contobj_get_bytask(struct task_struct *tsk)
+{
+	return (void *)_audit_contobj_get_bytask(tsk);
+}
+
 /* _audit_contobj_list_lock must be held by caller */
 static void _audit_contobj_put(struct audit_contobj *cont)
 {
@@ -331,6 +336,17 @@ static void _audit_contobj_put(struct audit_contobj *cont)
 	}
 }
 
+void audit_contobj_put(void **cont, int count)
+{
+	int i;
+	struct audit_contobj **contobj = (struct audit_contobj **)cont;
+
+	spin_lock(&_audit_contobj_list_lock);
+	for (i = 0; i < count; i++)
+		_audit_contobj_put(contobj[i]);
+	spin_unlock(&_audit_contobj_list_lock);
+}
+
 static inline int audit_hash_contid(u64 contid)
 {
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
@@ -2327,6 +2343,59 @@ void audit_log_session_info(struct audit_buffer *ab)
 	audit_log_format(ab, "auid=%u ses=%u", auid, sessionid);
 }
 
+/*
+ * _audit_log_container_id - report container info
+ * @context: task or local context for record
+ * @cont: container object to report
+ *
+ * Returns 0 on record absence, positive integer on valid record id.
+ */
+static int _audit_log_container_id(struct audit_context *context,
+				    struct audit_contobj *contobj)
+{
+	struct audit_buffer *ab;
+	int record;
+
+	if (!contobj)
+		return 0;
+	/* Generate AUDIT_CONTAINER_ID record with container ID */
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER_ID);
+	if (!ab)
+		return 0;
+	audit_log_format(ab, "record=%d contid=%llu",
+			 record = ++context->contid_records, contobj->id);
+	audit_log_end(ab);
+	return record;
+}
+
+int audit_log_container_id(struct audit_context *context, void *cont)
+{
+	return _audit_log_container_id(context, (struct audit_contobj *)cont);
+}
+
+/*
+ * audit_log_container_id_ctx - report container info
+ * @context: task or local context for record
+ *
+ * Returns 0 on record absence, positive integer on valid record id.
+ */
+int audit_log_container_id_ctx(struct audit_context *context)
+{
+	struct audit_contobj *contobj;
+	int record;
+
+	rcu_read_lock();
+	contobj = _audit_contobj_get_bytask(current);
+	rcu_read_unlock();
+	if (!contobj)
+		return 0;
+	record = _audit_log_container_id(context, contobj);
+	spin_lock(&_audit_contobj_list_lock);
+	_audit_contobj_put(contobj);
+	spin_unlock(&_audit_contobj_list_lock);
+	return record;
+}
+
 void audit_log_key(struct audit_buffer *ab, char *key)
 {
 	audit_log_format(ab, " key=");
@@ -2631,6 +2700,11 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 		if (cont->id == contid) {
 			/* task injection to existing container */
 			if (current == cont->owner) {
+				if (!refcount_read(&cont->refcount)) {
+					rc = -ENOTUNIQ;
+					spin_unlock(&_audit_contobj_list_lock);
+					goto error;
+				}
 				_audit_contobj_get(cont);
 				newcont = cont;
 			} else {
diff --git a/kernel/audit.h b/kernel/audit.h
index c4a3d7e03fbe..de79f59d623f 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -135,6 +135,8 @@ struct audit_context {
 	kuid_t		    target_uid;
 	unsigned int	    target_sessionid;
 	u32		    target_sid;
+	void		    *target_cid;
+	int		    contid_records;
 	char		    target_comm[TASK_COMM_LEN];
 
 	struct audit_tree_refs *trees, *first_trees;
@@ -211,6 +213,10 @@ static inline int audit_hash_ino(u32 ino)
 }
 
 extern void audit_log_container_drop(void);
+extern void *audit_contobj_get_bytask(struct task_struct *tsk);
+extern void audit_contobj_put(void **cont, int count);
+extern int audit_log_container_id(struct audit_context *context, void *cont);
+extern int audit_log_container_id_ctx(struct audit_context *context);
 
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 5056e32f9f47..2d9762f2f432 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -112,6 +112,7 @@ struct audit_aux_data_pids {
 	kuid_t			target_uid[AUDIT_AUX_PIDS];
 	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
 	u32			target_sid[AUDIT_AUX_PIDS];
+	void			*target_cid[AUDIT_AUX_PIDS];
 	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
 	int			pid_count;
 };
@@ -905,6 +906,7 @@ static inline void audit_free_names(struct audit_context *context)
 static inline void audit_free_aux(struct audit_context *context)
 {
 	struct audit_aux_data *aux;
+	struct audit_aux_data_pids *axp;
 
 	while ((aux = context->aux)) {
 		context->aux = aux->next;
@@ -912,6 +914,8 @@ static inline void audit_free_aux(struct audit_context *context)
 	}
 	while ((aux = context->aux_pids)) {
 		context->aux_pids = aux->next;
+		axp = (struct audit_aux_data_pids *)aux;
+		audit_contobj_put(axp->target_cid, axp->pid_count);
 		kfree(aux);
 	}
 }
@@ -985,7 +989,7 @@ static inline void audit_free_context(struct audit_context *context)
 
 static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 				 kuid_t auid, kuid_t uid, unsigned int sessionid,
-				 u32 sid, char *comm)
+				 u32 sid, char *comm, int record)
 {
 	struct audit_buffer *ab;
 	char *ctx = NULL;
@@ -1010,6 +1014,8 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 	}
 	audit_log_format(ab, " ocomm=");
 	audit_log_untrustedstring(ab, comm);
+	if (record)
+		audit_log_format(ab, " record=%d", record);
 	audit_log_end(ab);
 
 	return rc;
@@ -1479,9 +1485,12 @@ static void audit_log_exit(void)
 	struct audit_buffer *ab;
 	struct audit_aux_data *aux;
 	struct audit_names *n;
+	int record;
 
 	context->personality = current->personality;
 
+	record = audit_log_container_id_ctx(context);
+
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
 	if (!ab)
 		return;		/* audit_panic has been called */
@@ -1504,6 +1513,8 @@ static void audit_log_exit(void)
 
 	audit_log_task_info(ab);
 	audit_log_key(ab, context->filterkey);
+	if (record)
+		audit_log_format(ab, " record=%d", record);
 	audit_log_end(ab);
 
 	for (aux = context->aux; aux; aux = aux->next) {
@@ -1562,22 +1573,28 @@ static void audit_log_exit(void)
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
 
-		for (i = 0; i < axs->pid_count; i++)
+		for (i = 0; i < axs->pid_count; i++) {
+			record = audit_log_container_id(context, axs->target_cid[i]);
 			if (audit_log_pid_context(context, axs->target_pid[i],
 						  axs->target_auid[i],
 						  axs->target_uid[i],
 						  axs->target_sessionid[i],
 						  axs->target_sid[i],
-						  axs->target_comm[i]))
+						  axs->target_comm[i], record))
 				call_panic = 1;
+		}
 	}
 
-	if (context->target_pid &&
-	    audit_log_pid_context(context, context->target_pid,
-				  context->target_auid, context->target_uid,
-				  context->target_sessionid,
-				  context->target_sid, context->target_comm))
+	if (context->target_pid) {
+		record = audit_log_container_id(context, context->target_cid);
+		if (audit_log_pid_context(context, context->target_pid,
+					  context->target_auid,
+					  context->target_uid,
+					  context->target_sessionid,
+					  context->target_sid,
+					  context->target_comm, record))
 			call_panic = 1;
+	}
 
 	if (context->pwd.dentry && context->pwd.mnt) {
 		ab = audit_log_start(context, GFP_KERNEL, AUDIT_CWD);
@@ -1755,11 +1772,16 @@ void __audit_syscall_exit(int success, long return_code)
 	audit_free_aux(context);
 	context->aux = NULL;
 	context->aux_pids = NULL;
+	if (context->target_pid) {
+		audit_contobj_put(&context->target_cid, 1);
+		context->target_cid = NULL;
+	}
 	context->target_pid = 0;
 	context->target_sid = 0;
 	context->sockaddr_len = 0;
 	context->type = 0;
 	context->fds[0] = -1;
+	context->contid_records = 0;
 	if (context->state != AUDIT_RECORD_CONTEXT) {
 		kfree(context->filterkey);
 		context->filterkey = NULL;
@@ -2400,11 +2422,16 @@ void __audit_ptrace(struct task_struct *t)
 {
 	struct audit_context *context = audit_context();
 
+	if (context->target_pid)
+		audit_contobj_put(&context->target_cid, 1);
 	context->target_pid = task_tgid_nr(t);
 	context->target_auid = audit_get_loginuid(t);
 	context->target_uid = task_uid(t);
 	context->target_sessionid = audit_get_sessionid(t);
 	security_task_getsecid(t, &context->target_sid);
+	rcu_read_lock();
+	context->target_cid = audit_contobj_get_bytask(t);
+	rcu_read_unlock();
 	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
 }
 
@@ -2432,6 +2459,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 		ctx->target_uid = t_uid;
 		ctx->target_sessionid = audit_get_sessionid(t);
 		security_task_getsecid(t, &ctx->target_sid);
+		rcu_read_lock();
+		ctx->target_cid = audit_contobj_get_bytask(t);
+		rcu_read_unlock();
 		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
 		return 0;
 	}
@@ -2453,6 +2483,9 @@ int audit_signal_info_syscall(struct task_struct *t)
 	axp->target_uid[axp->pid_count] = t_uid;
 	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
 	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
+	rcu_read_lock();
+	axp->target_cid[axp->pid_count] = audit_contobj_get_bytask(t);
+	rcu_read_unlock();
 	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
 	axp->pid_count++;
 
-- 
2.18.4

