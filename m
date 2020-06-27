Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C2920C1BE
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgF0NYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:24:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33892 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726989AbgF0NYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=Vbsz74jx639O45NZJ//E5urMuCAJMJoLkV3YW2Jxk5M=;
        b=HoYprsEFrnEbRo0CyRgZDNa2qQy+fl/QYGGy2jDLKgaA1pO7fEXbmrBWlVtIW3BH+pwngt
        dOe+poN1VSKXosOji+gz3Iar1eXRH4HFXu+x90Xq3Y+qkCcEBIMZSbf1dXFGaUmkh67DcG
        Yu5DP5yWa9dNOZZIEh/h8wOZbdkdYHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-C3L9deshP0OUCzQ5IpSj0Q-1; Sat, 27 Jun 2020 09:23:55 -0400
X-MC-Unique: C3L9deshP0OUCzQ5IpSj0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D191A0BD7;
        Sat, 27 Jun 2020 13:23:53 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A07D8205F;
        Sat, 27 Jun 2020 13:23:43 +0000 (UTC)
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
Subject: [PATCH ghak90 V9 13/13] audit: add capcontid to set contid outside init_user_ns
Date:   Sat, 27 Jun 2020 09:20:46 -0400
Message-Id: <b6cb5500cfd7e8686ac2a7758103688c2da7f4ce.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
process in a non-init user namespace the capability to set audit
container identifiers of individual children.

Provide the /proc/$PID/audit_capcontid interface to capcontid.
Valid values are: 1==enabled, 0==disabled

Writing a "1" to this special file for the target process $PID will
enable the target process to set audit container identifiers of its
descendants.

A process must already have CAP_AUDIT_CONTROL in the initial user
namespace or have had audit_capcontid enabled by a previous use of this
feature by its parent on this process in order to be able to enable it
for another process.  The target process must be a descendant of the
calling process.

Report this action in new message type AUDIT_SET_CAPCONTID 1022 with
fields opid= capcontid= old-capcontid=

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/proc/base.c             | 57 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/audit.h      | 14 ++++++++++++
 include/uapi/linux/audit.h |  1 +
 kernel/audit.c             | 38 ++++++++++++++++++++++++++++++-
 4 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 794474cd8f35..1083db2ce345 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1329,7 +1329,7 @@ static ssize_t proc_contid_read(struct file *file, char __user *buf,
 	if (!task)
 		return -ESRCH;
 	/* if we don't have caps, reject */
-	if (!capable(CAP_AUDIT_CONTROL))
+	if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
 		return -EPERM;
 	length = scnprintf(tmpbuf, TMPBUFLEN, "%llu", audit_get_contid(task));
 	put_task_struct(task);
@@ -1370,6 +1370,59 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
 	.write		= proc_contid_write,
 	.llseek		= generic_file_llseek,
 };
+
+static ssize_t proc_capcontid_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	struct task_struct *task = get_proc_task(inode);
+	ssize_t length;
+	char tmpbuf[TMPBUFLEN];
+
+	if (!task)
+		return -ESRCH;
+	/* if we don't have caps, reject */
+	if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
+		return -EPERM;
+	length = scnprintf(tmpbuf, TMPBUFLEN, "%u", audit_get_capcontid(task));
+	put_task_struct(task);
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
+}
+
+static ssize_t proc_capcontid_write(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	struct inode *inode = file_inode(file);
+	u32 capcontid;
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
+	rv = kstrtou32_from_user(buf, count, 10, &capcontid);
+	if (rv < 0) {
+		put_task_struct(task);
+		return rv;
+	}
+
+	rv = audit_set_capcontid(task, capcontid);
+	put_task_struct(task);
+	if (rv < 0)
+		return rv;
+	return count;
+}
+
+static const struct file_operations proc_capcontid_operations = {
+	.read		= proc_capcontid_read,
+	.write		= proc_capcontid_write,
+	.llseek		= generic_file_llseek,
+};
 #endif
 
 #ifdef CONFIG_FAULT_INJECTION
@@ -3273,6 +3326,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
 	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
+	REG("audit_capcontainerid", S_IWUSR|S_IRUSR, proc_capcontid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
@@ -3613,6 +3667,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
 	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
+	REG("audit_capcontainerid", S_IWUSR|S_IRUSR, proc_capcontid_operations),
 #endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 025b52ae8422..2b3a2b6020ed 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -122,6 +122,7 @@ struct audit_task_info {
 	kuid_t			loginuid;
 	unsigned int		sessionid;
 	struct audit_contobj	*cont;
+	u32			capcontid;
 #ifdef CONFIG_AUDITSYSCALL
 	struct audit_context	*ctx;
 #endif
@@ -230,6 +231,14 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 	return tsk->audit->sessionid;
 }
 
+static inline u32 audit_get_capcontid(struct task_struct *tsk)
+{
+	if (!tsk->audit)
+		return 0;
+	return tsk->audit->capcontid;
+}
+
+extern int audit_set_capcontid(struct task_struct *tsk, u32 enable);
 extern int audit_set_contid(struct task_struct *tsk, u64 contid);
 
 static inline u64 audit_get_contid(struct task_struct *tsk)
@@ -311,6 +320,11 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 	return AUDIT_SID_UNSET;
 }
 
+static inline u32 audit_get_capcontid(struct task_struct *tsk)
+{
+	return 0;
+}
+
 static inline u64 audit_get_contid(struct task_struct *tsk)
 {
 	return AUDIT_CID_UNSET;
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 831c12bdd235..5e30f4c95dc2 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -73,6 +73,7 @@
 #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
 #define AUDIT_CONTAINER_OP	1020	/* Define the container id and info */
 #define AUDIT_SIGNAL_INFO2	1021	/* Get info auditd signal sender */
+#define AUDIT_SET_CAPCONTID	1022	/* Set cap_contid of a task */
 
 #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
 #define AUDIT_USER_AVC		1107	/* We filter this differently */
diff --git a/kernel/audit.c b/kernel/audit.c
index aaf74702e993..454473f2e193 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -307,6 +307,7 @@ int audit_alloc(struct task_struct *tsk)
 	rcu_read_lock();
 	info->cont = _audit_contobj_get(current);
 	rcu_read_unlock();
+	info->capcontid = 0;
 	tsk->audit = info;
 
 	ret = audit_alloc_syscall(tsk);
@@ -322,6 +323,7 @@ struct audit_task_info init_struct_audit = {
 	.loginuid = INVALID_UID,
 	.sessionid = AUDIT_SID_UNSET,
 	.cont = NULL,
+	.capcontid = 0,
 #ifdef CONFIG_AUDITSYSCALL
 	.ctx = NULL,
 #endif
@@ -2763,6 +2765,40 @@ static bool audit_contid_isnesting(struct task_struct *tsk)
 	return !isowner && ownerisparent;
 }
 
+int audit_set_capcontid(struct task_struct *task, u32 enable)
+{
+	u32 oldcapcontid;
+	int rc = 0;
+	struct audit_buffer *ab;
+
+	if (!task->audit)
+		return -ENOPROTOOPT;
+	oldcapcontid = audit_get_capcontid(task);
+	/* if task is not descendant, block */
+	if (task == current || !task_is_descendant(current, task))
+		rc = -EXDEV;
+	else if (current_user_ns() == &init_user_ns) {
+		if (!capable(CAP_AUDIT_CONTROL) &&
+		    !audit_get_capcontid(current))
+			rc = -EPERM;
+	}
+	if (!rc)
+		task->audit->capcontid = enable;
+
+	if (!audit_enabled)
+		return rc;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_SET_CAPCONTID);
+	if (!ab)
+		return rc;
+
+	audit_log_format(ab,
+			 "opid=%d capcontid=%u old-capcontid=%u",
+			 task_tgid_nr(task), enable, oldcapcontid);
+	audit_log_end(ab);
+	return rc;
+}
+
 /*
  * audit_set_contid - set current task's audit contid
  * @task: target task
@@ -2795,7 +2831,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 		goto unlock;
 	}
 	/* if we don't have caps, reject */
-	if (!capable(CAP_AUDIT_CONTROL)) {
+	if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current)) {
 		rc = -EPERM;
 		goto unlock;
 	}
-- 
1.8.3.1

