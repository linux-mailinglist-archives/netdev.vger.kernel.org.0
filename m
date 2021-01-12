Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5552F33F0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405181AbhALPNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:13:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404671AbhALPNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610464315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=JMNDxOpcSJpy1boyDiRFGw1VU2TRGbjXVre/O5w1TLo=;
        b=WXKL7fix78CqLKio9qN/MC3/dTmWc48LukUEWeh3ztvSM1Z0nYJ3wIBUhtIFTaxRtMCkbZ
        88JhR/XT4XoDVrW2ybAxSFTeBgj0RVJnVvBUgO3ZDJ4rxJkNLjTvVLBbb6juSuXE1xaENP
        WrY9aIhobrexxYdU3o5ZukySJ4DvoDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-5ZMed7MhNqO0gmxicNO--Q-1; Tue, 12 Jan 2021 10:11:53 -0500
X-MC-Unique: 5ZMed7MhNqO0gmxicNO--Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A9D4EC1A7;
        Tue, 12 Jan 2021 15:11:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E9B75D9CD;
        Tue, 12 Jan 2021 15:11:42 +0000 (UTC)
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
Subject: [PATCH ghak90 v11 09/11] audit: contid check descendancy and nesting
Date:   Tue, 12 Jan 2021 10:09:37 -0500
Message-Id: <33d06da75cd65fa88c92968e35b6eb4346e98ffc.1610399347.git.rgb@redhat.com>
In-Reply-To: <cover.1610399347.git.rgb@redhat.com>
References: <cover.1610399347.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Require the target task to be a descendant of the container
orchestrator/engine.

You would only change the audit container ID from one set or inherited
value to another if you were nesting containers.

If changing the contid, the container orchestrator/engine must be a
descendant and not same orchestrator as the one that set it so it is not
possible to change the contid of another orchestrator's container.

Since the task_is_descendant() function is used in YAMA and in audit,
remove the duplication and pull the function into kernel/core/sched.c

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h    |  3 +++
 kernel/audit.c           | 26 +++++++++++++++++++++++---
 kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
 security/yama/yama_lsm.c | 33 ---------------------------------
 4 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1d10d81b8fd5..b30bbfec31ab 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2097,4 +2097,7 @@ int sched_trace_rq_nr_running(struct rq *rq);
 
 const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
 
+extern int task_is_descendant(struct task_struct *parent,
+			      struct task_struct *child);
+
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index c30bcd525dad..fcb78a6d8e4a 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -476,11 +476,13 @@ void audit_free(struct task_struct *tsk)
 	rcu_read_lock();
 	cont = _audit_contobj_get_bytask(tsk);
 	rcu_read_unlock();
-	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	if (ns) {
 		audit_netns_contid_del(ns->net_ns, cont);
+		spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 		_audit_contobj_put(cont);
+		spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 	}
+	spin_lock_irqsave(&_audit_contobj_list_lock, flags);
 	_audit_contobj_put(cont);
 	spin_unlock_irqrestore(&_audit_contobj_list_lock, flags);
 	audit_free_syscall(tsk);
@@ -2924,6 +2926,21 @@ int audit_signal_info(int sig, struct task_struct *t)
 	return audit_signal_info_syscall(t);
 }
 
+static bool audit_contid_isnesting(struct task_struct *tsk)
+{
+	bool isowner = false;
+	bool ownerisparent = false;
+	struct audit_task_info *info = tsk->audit;
+
+	rcu_read_lock();
+	if (info && info->cont) {
+		isowner = current == info->cont->owner;
+		ownerisparent = task_is_descendant(info->cont->owner, current);
+	}
+	rcu_read_unlock();
+	return !isowner && ownerisparent;
+}
+
 /*
  * audit_set_contid - set current task's audit contid
  * @tsk: target task
@@ -2964,8 +2981,11 @@ int audit_set_contid(struct task_struct *tsk, u64 contid)
 		   !(thread_group_leader(tsk) && thread_group_empty(tsk))) {
 		/* if task has children or is not single-threaded, deny */
 		rc = -EBUSY;
-	} else if (info->cont) {
-		/* if contid is already set, deny */
+	} else if (tsk == current || !task_is_descendant(current, tsk)) {
+		/* if task is not descendant, block */
+		rc = -EXDEV;
+	} else if (info->cont && !audit_contid_isnesting(tsk)) {
+		/* only allow contid setting again if nesting */
 		rc = -EEXIST;
 	}
 	rcu_read_lock();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 15d2562118d1..f769bcba4ee8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9072,6 +9072,39 @@ void dump_cpu_task(int cpu)
 	sched_show_task(cpu_curr(cpu));
 }
 
+/*
+ * task_is_descendant - walk up a process family tree looking for a match
+ * @parent: the process to compare against while walking up from child
+ * @child: the process to start from while looking upwards for parent
+ *
+ * Returns 1 if child is a descendant of parent, 0 if not.
+ */
+int task_is_descendant(struct task_struct *parent,
+			      struct task_struct *child)
+{
+	int rc = 0;
+	struct task_struct *walker = child;
+
+	if (!parent || !child)
+		return 0;
+
+	rcu_read_lock();
+	if (!thread_group_leader(parent))
+		parent = rcu_dereference(parent->group_leader);
+	while (walker->pid > 0) {
+		if (!thread_group_leader(walker))
+			walker = rcu_dereference(walker->group_leader);
+		if (walker == parent) {
+			rc = 1;
+			break;
+		}
+		walker = rcu_dereference(walker->real_parent);
+	}
+	rcu_read_unlock();
+
+	return rc;
+}
+
 /*
  * Nice levels are multiplicative, with a gentle 10% change for every
  * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 06e226166aab..2930e42eafc2 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -262,39 +262,6 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 	return rc;
 }
 
-/**
- * task_is_descendant - walk up a process family tree looking for a match
- * @parent: the process to compare against while walking up from child
- * @child: the process to start from while looking upwards for parent
- *
- * Returns 1 if child is a descendant of parent, 0 if not.
- */
-static int task_is_descendant(struct task_struct *parent,
-			      struct task_struct *child)
-{
-	int rc = 0;
-	struct task_struct *walker = child;
-
-	if (!parent || !child)
-		return 0;
-
-	rcu_read_lock();
-	if (!thread_group_leader(parent))
-		parent = rcu_dereference(parent->group_leader);
-	while (walker->pid > 0) {
-		if (!thread_group_leader(walker))
-			walker = rcu_dereference(walker->group_leader);
-		if (walker == parent) {
-			rc = 1;
-			break;
-		}
-		walker = rcu_dereference(walker->real_parent);
-	}
-	rcu_read_unlock();
-
-	return rc;
-}
-
 /**
  * ptracer_exception_found - tracer registered as exception for this tracee
  * @tracer: the task_struct of the process attempting ptrace
-- 
2.18.4

