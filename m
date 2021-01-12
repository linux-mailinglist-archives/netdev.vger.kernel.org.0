Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD832F33CA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390792AbhALPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:12:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390541AbhALPMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610464249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=wXW4v32PRIUorr74sndvNQGzZnX+Jchuaq0jcvoJaRE=;
        b=RyHORh/dRFFnQjWqd56qEpqtclXy2onEEKRitJOcqgZxgKwO02eT/BwZNby2Dwrh3EhabA
        7FiC6ZcaPTdtnzSS0gOoWsYyyNMQii+ysswOTGZJRrqQfr0rfLprocWyNK4xNM0K0iDcfr
        FVhut0/wj+eUc2s+otY6HcJvM0rz4/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-8kvIlTveOVCzbrwJk-h_3g-1; Tue, 12 Jan 2021 10:10:47 -0500
X-MC-Unique: 8kvIlTveOVCzbrwJk-h_3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE941107ACF7;
        Tue, 12 Jan 2021 15:10:44 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAB435D9D2;
        Tue, 12 Jan 2021 15:10:27 +0000 (UTC)
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
Subject: [PATCH ghak90 v11 02/11] audit: add container id
Date:   Tue, 12 Jan 2021 10:09:30 -0500
Message-Id: <d87fb33a8d7f456bddf7b1600a38c0af6df1b246.1610399347.git.rgb@redhat.com>
In-Reply-To: <cover.1610399347.git.rgb@redhat.com>
References: <cover.1610399347.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the proc fs write to set the audit container identifier of a
process, emitting an AUDIT_CONTAINER_OP record to document the event.

This is a write from the container orchestrator task to a proc entry of
the form /proc/PID/audit_containerid where PID is the process ID of the
newly created task that is to become the first task in a container, or
an additional task added to a container.

The write expects up to a u64 value (unset: 18446744073709551615).

The writer must have capability CAP_AUDIT_CONTROL.

This will produce an event such as this with the new CONTAINER_OP record:
  time->Thu Nov 26 10:24:27 2020
  type=PROCTITLE msg=audit(1606404267.551:174524): proctitle=2F7573722F62696E2F7065726C002D7700636F6E7461696E657269642F74657374
  type=SYSCALL msg=audit(1606404267.551:174524): arch=c000003e syscall=1 success=yes exit=20 a0=6 a1=557446aa9180 a2=14 a3=100 items=0 ppid=6827 pid=8724 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=1 comm="perl" exe="/usr/bin/perl" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
  type=CONTAINER_OP msg=audit(1606404267.551:174524): op=set opid=8730 contid=4515122123205246976 old-contid=-1

The "op" field indicates an initial set.  The "opid" field is the
object's PID, the process being "contained".  New and old audit
container identifier values are given in the "contid" fields.

It is not permitted to unset the audit container identifier.
A child inherits its parent's audit container identifier.

Store the audit container identifier in a refcounted kernel object that
is added to the master list of audit container identifiers.  This will
allow multiple container orchestrators/engines to work on the same
machine without danger of inadvertantly re-using an existing identifier.
It will also allow an orchestrator to inject a process into an existing
container by checking if the original container owner is the one
injecting the task.  A hash table list is used to optimize searches.

Since the life of each audit container indentifier is being tracked, we match
the creation event with the destruction event.  Log the drop of the audit
container identifier when the last process in that container exits.

Add support for reading the audit container identifier from the proc
filesystem.  This is a read from the proc entry of the form
/proc/PID/audit_containerid where PID is the process ID of the task
whose audit container identifier is sought.  The read expects up to a u64 value
(unset: (u64)-1).  This read requires CAP_AUDIT_CONTROL.

Add an entry to Documentation/ABI for /proc/$pid/audit_containerid.

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
Acks dropped due to log drop added 7.3, redo rcu/spin locking, u64/contobj
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 .../ABI/testing/procfs-audit_containerid      |  13 ++
 fs/proc/base.c                                |  56 ++++-
 include/linux/audit.h                         |   5 +
 include/uapi/linux/audit.h                    |   2 +
 kernel/audit.c                                | 210 ++++++++++++++++++
 kernel/audit.h                                |   2 +
 kernel/auditsc.c                              |   2 +
 7 files changed, 289 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/procfs-audit_containerid

diff --git a/Documentation/ABI/testing/procfs-audit_containerid b/Documentation/ABI/testing/procfs-audit_containerid
new file mode 100644
index 000000000000..30ea64790473
--- /dev/null
+++ b/Documentation/ABI/testing/procfs-audit_containerid
@@ -0,0 +1,13 @@
+What:		Audit Container Identifier
+Date:		2020-??
+KernelVersion:	5.10?
+Contact:	linux-audit@redhat.com
+Format:		u64
+Users:		auditd, libaudit, audit-testsuite, podman(?), container orchestrators
+Description:
+		The /proc/$pid/audit_containerid pseudofile it written
+		to set and read to get the audit container identifier of
+		process $pid.  The accessor must have CAP_AUDIT_CONTROL
+		or have its own /proc/$pid/capcontainerid set to write
+		or read.
+
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b3422cda2a91..bf447e7932d2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1244,7 +1244,7 @@ static const struct file_operations proc_oom_score_adj_operations = {
 };
 
 #ifdef CONFIG_AUDIT
-#define TMPBUFLEN 11
+#define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
@@ -1331,6 +1331,58 @@ static const struct file_operations proc_sessionid_operations = {
 	.read		= proc_sessionid_read,
 	.llseek		= generic_file_llseek,
 };
+
+static ssize_t proc_contid_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	struct task_struct *task = get_proc_task(inode);
+	ssize_t length;
+	char tmpbuf[TMPBUFLEN];
+
+	if (!task)
+		return -ESRCH;
+	length = audit_get_contid_proc(tmpbuf, TMPBUFLEN, task);
+	put_task_struct(task);
+	if (length < 0)
+		return length;
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
+}
+
+static ssize_t proc_contid_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	u64 contid;
+	int rv;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ESRCH;
+	if (*ppos != 0) {
+		/* No partial writes. */
+		put_task_struct(task);
+		return -EINVAL;
+	}
+
+	rv = kstrtou64_from_user(buf, count, 10, &contid);
+	if (rv < 0) {
+		put_task_struct(task);
+		return rv;
+	}
+
+	rv = audit_set_contid(task, contid);
+	put_task_struct(task);
+	if (rv < 0)
+		return rv;
+	return count;
+}
+
+static const struct file_operations proc_contid_operations = {
+	.read		= proc_contid_read,
+	.write		= proc_contid_write,
+	.llseek		= generic_file_llseek,
+};
 #endif
 
 #ifdef CONFIG_FAULT_INJECTION
@@ -3233,6 +3285,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_AUDIT
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
+	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
@@ -3575,6 +3628,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_AUDIT
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
+	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 515cc89a7e0c..30c55e6b6a3c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -204,6 +204,11 @@ extern kuid_t audit_get_loginuid(struct task_struct *tsk);
 extern unsigned int audit_get_sessionid(struct task_struct *tsk);
 extern void audit_set_sessionid_iouring(unsigned int sessionid);
 
+extern int audit_get_contid_proc(char *tmpbuf, int TMPBUFLEN,
+				 struct task_struct *task);
+
+extern int audit_set_contid(struct task_struct *tsk, u64 contid);
+
 extern u32 audit_enabled;
 
 extern int audit_signal_info(int sig, struct task_struct *t);
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index cd2d8279a5e4..26d65d0882e2 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -71,6 +71,7 @@
 #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
 #define AUDIT_SET_FEATURE	1018	/* Turn an audit feature on or off */
 #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
+#define AUDIT_CONTAINER_OP	1020	/* Define the container id and info */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
@@ -495,6 +496,7 @@ struct audit_tty_status {
 
 #define AUDIT_UID_UNSET (unsigned int)-1
 #define AUDIT_SID_UNSET ((unsigned int)-1)
+#define AUDIT_CID_UNSET ((u64)-1)
 
 /* audit_rule_data supports filter rules with both integer and string
  * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
diff --git a/kernel/audit.c b/kernel/audit.c
index a822fa3b8da3..fe94b295a362 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -144,6 +144,15 @@ static atomic_t audit_backlog_wait_time_actual = ATOMIC_INIT(0);
 /* Hash for inode-based rules */
 struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
 
+#define AUDIT_CONTID_BUCKETS	32
+/* Hash for contid object lists */
+static struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
+/* Lock all additions and deletions to the contid hash lists, assignment
+ * of container objects to tasks.  There should be no need for
+ * interaction with tasklist_lock
+ */
+static DEFINE_SPINLOCK(_audit_contobj_list_lock);
+
 static struct kmem_cache *audit_buffer_cache;
 
 /* queue msgs to send via kauditd_task */
@@ -208,9 +217,18 @@ struct audit_reply {
 	struct sk_buff *skb;
 };
 
+struct audit_contobj {
+	struct list_head	list;
+	u64			id;
+	struct task_struct	*owner;
+	refcount_t		refcount;
+	struct rcu_head         rcu;
+};
+
 struct audit_task_info {
 	kuid_t			loginuid;
 	unsigned int		sessionid;
+	struct audit_contobj	*cont;
 #ifdef CONFIG_AUDITSYSCALL
 	struct audit_context	*ctx;
 #endif
@@ -261,6 +279,15 @@ inline void audit_set_sessionid_iouring(unsigned int sessionid)
 	info->sessionid = sessionid;
 }
 
+static inline u64 audit_get_contid(struct task_struct *tsk)
+{
+	struct audit_task_info *info = tsk->audit;
+
+	if (!info || !info->cont)
+		return AUDIT_CID_UNSET;
+	return info->cont->id;
+}
+
 inline struct audit_context *_audit_context(struct task_struct *tsk)
 {
 	struct audit_task_info *info = tsk->audit;
@@ -276,6 +303,39 @@ struct audit_context *audit_context(void)
 }
 EXPORT_SYMBOL(audit_context);
 
+static struct audit_contobj *_audit_contobj_get(struct audit_contobj *cont)
+{
+	if (cont)
+		refcount_inc(&cont->refcount);
+	return cont;
+}
+
+static struct audit_contobj *_audit_contobj_get_bytask(struct task_struct *tsk)
+{
+	struct audit_task_info *info = tsk->audit;
+
+	if (!info)
+		return NULL;
+	return _audit_contobj_get(info->cont);
+}
+
+/* _audit_contobj_list_lock must be held by caller */
+static void _audit_contobj_put(struct audit_contobj *cont)
+{
+	if (!cont)
+		return;
+	if (refcount_dec_and_test(&cont->refcount)) {
+		put_task_struct(cont->owner);
+		list_del_rcu(&cont->list);
+		kfree_rcu(cont, rcu);
+	}
+}
+
+static inline int audit_hash_contid(u64 contid)
+{
+	return (contid & (AUDIT_CONTID_BUCKETS-1));
+}
+
 static void audit_alloc_task(struct task_struct *tsk)
 {
 	struct audit_task_info *info = tsk->audit;
@@ -289,6 +349,9 @@ static void audit_alloc_task(struct task_struct *tsk)
 	}
 	info->loginuid = audit_get_loginuid(current);
 	info->sessionid = audit_get_sessionid(current);
+	rcu_read_lock();
+	info->cont = _audit_contobj_get_bytask(current);
+	rcu_read_unlock();
 	tsk->audit = info;
 }
 
@@ -343,6 +406,9 @@ void audit_free(struct task_struct *tsk)
 	struct audit_task_info *info = tsk->audit;
 
 	audit_free_syscall(tsk);
+	spin_lock(&_audit_contobj_list_lock);
+	_audit_contobj_put(info->cont);
+	spin_unlock(&_audit_contobj_list_lock);
 	/* Freeing the audit_task_info struct must be performed after
 	 * audit_log_exit() due to need for loginuid and sessionid.
 	 */
@@ -1795,6 +1861,9 @@ static int __init audit_init(void)
 	for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
 		INIT_LIST_HEAD(&audit_inode_hash[i]);
 
+	for (i = 0; i < AUDIT_CONTID_BUCKETS; i++)
+		INIT_LIST_HEAD(&audit_contid_hash[i]);
+
 	mutex_init(&audit_cmd_mutex.lock);
 	audit_cmd_mutex.owner = NULL;
 
@@ -2509,6 +2578,147 @@ int audit_signal_info(int sig, struct task_struct *t)
 	return audit_signal_info_syscall(t);
 }
 
+/*
+ * audit_set_contid - set current task's audit contid
+ * @tsk: target task
+ * @contid: contid value
+ *
+ * Returns 0 on success, -EPERM on permission failure.
+ *
+ * If the original container owner goes away, no task injection is
+ * possible to an existing container.
+ *
+ * Called (set) from fs/proc/base.c::proc_contid_write().
+ */
+int audit_set_contid(struct task_struct *tsk, u64 contid)
+{
+	int rc = 0;
+	struct audit_buffer *ab;
+	struct audit_contobj *oldcont = NULL;
+	struct audit_contobj *cont = NULL, *newcont = NULL;
+	int h;
+	struct audit_task_info *info = tsk->audit;
+
+	/* Can't set if audit disabled */
+	if (!info) {
+		task_unlock(tsk);
+		return -ENOPROTOOPT;
+	}
+	read_lock(&tasklist_lock);
+	task_lock(tsk);
+	if (contid == AUDIT_CID_UNSET) {
+		/* Don't allow the contid to be unset */
+		rc = -EINVAL;
+	} else if (!capable(CAP_AUDIT_CONTROL)) {
+		/* if we don't have caps, reject */
+		rc = -EPERM;
+	} else if (!list_empty(&tsk->children) ||
+		   !(thread_group_leader(tsk) && thread_group_empty(tsk))) {
+		/* if task has children or is not single-threaded, deny */
+		rc = -EBUSY;
+	} else if (info->cont) {
+		/* if contid is already set, deny */
+		rc = -EEXIST;
+	}
+	rcu_read_lock();
+	oldcont = _audit_contobj_get_bytask(tsk);
+	if (rc)
+		goto error;
+
+	h = audit_hash_contid(contid);
+	spin_lock(&_audit_contobj_list_lock);
+	list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
+		if (cont->id == contid) {
+			/* task injection to existing container */
+			if (current == cont->owner) {
+				_audit_contobj_get(cont);
+				newcont = cont;
+			} else {
+				rc = -ENOTUNIQ;
+				spin_unlock(&_audit_contobj_list_lock);
+				goto error;
+			}
+			break;
+		}
+	if (!newcont) {
+		newcont = kmalloc(sizeof(*newcont), GFP_ATOMIC);
+		if (newcont) {
+			INIT_LIST_HEAD(&newcont->list);
+			newcont->id = contid;
+			newcont->owner = get_task_struct(current);
+			refcount_set(&newcont->refcount, 1);
+			list_add_rcu(&newcont->list,
+				     &audit_contid_hash[h]);
+		} else {
+			rc = -ENOMEM;
+			spin_unlock(&_audit_contobj_list_lock);
+			goto error;
+		}
+	}
+	info->cont = newcont;
+	_audit_contobj_put(oldcont);
+	spin_unlock(&_audit_contobj_list_lock);
+error:
+	rcu_read_unlock();
+	task_unlock(tsk);
+	read_unlock(&tasklist_lock);
+
+	if (!audit_enabled)
+		return rc;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
+	if (!ab)
+		return rc;
+
+	audit_log_format(ab,
+			 "op=set opid=%d contid=%llu old-contid=%llu",
+			 task_tgid_nr(tsk), contid, oldcont ? oldcont->id : -1);
+	spin_lock(&_audit_contobj_list_lock);
+	_audit_contobj_put(oldcont);
+	spin_unlock(&_audit_contobj_list_lock);
+	audit_log_end(ab);
+	return rc;
+}
+
+int audit_get_contid_proc(char *tmpbuf, int TMPBUFLEN,
+			  struct task_struct *tsk)
+{
+	int length;
+
+	/* if we don't have caps, reject */
+	if (!capable(CAP_AUDIT_CONTROL)) {
+		length = -EPERM;
+		goto out;
+	}
+	length = scnprintf(tmpbuf, TMPBUFLEN, "%llu", audit_get_contid(tsk));
+out:
+	return length;
+}
+
+void audit_log_container_drop(void)
+{
+	struct audit_buffer *ab;
+	struct audit_contobj *cont;
+
+	rcu_read_lock();
+	cont = _audit_contobj_get_bytask(current);
+	rcu_read_unlock();
+	if (!cont)
+		return;
+	if (refcount_read(&cont->refcount) > 2)
+		goto out;
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
+	if (!ab)
+		goto out;
+	audit_log_format(ab, "op=drop opid=%d contid=-1 old-contid=%llu",
+			 task_tgid_nr(current), cont->id);
+	audit_log_end(ab);
+out:
+	spin_lock(&_audit_contobj_list_lock);
+	_audit_contobj_put(cont);
+	spin_unlock(&_audit_contobj_list_lock);
+}
+
 /**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
diff --git a/kernel/audit.h b/kernel/audit.h
index aa81d913a3d2..c4a3d7e03fbe 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -210,6 +210,8 @@ static inline int audit_hash_ino(u32 ino)
 	return (ino & (AUDIT_INODE_BUCKETS-1));
 }
 
+extern void audit_log_container_drop(void);
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 018d2df70319..5056e32f9f47 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1596,6 +1596,8 @@ static void audit_log_exit(void)
 
 	audit_log_proctitle();
 
+	audit_log_container_drop();
+
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
 	if (ab)
-- 
2.18.4

