Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CE620C1A8
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgF0NXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:23:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49899 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726914AbgF0NXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=k1ut6WkTgl4dIR6Pt+/0ewyvawbqPYzltO79GX8YVNI=;
        b=HCERefNlUreUcPVXy+Dkav/V0gZLb1qH7qugTHPyZUbJoLp81EkfJiZhy8LsnoLItR5Aui
        qcGM9RI04IqqEdHByPqPb1h4d2OIRZOjyRZt5xU6Mv6ASMXRjIfdBOQlkFP+Y3Ov6OSLDR
        np6sdPCED5Ojl38zx2DDFFOkf+TUINE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-mnILldnlMISyoZ0KY_i4pg-1; Sat, 27 Jun 2020 09:23:31 -0400
X-MC-Unique: mnILldnlMISyoZ0KY_i4pg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9793618A0724;
        Sat, 27 Jun 2020 13:23:29 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE2C71662;
        Sat, 27 Jun 2020 13:23:19 +0000 (UTC)
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
Subject: [PATCH ghak90 V9 11/13] audit: contid check descendancy and nesting
Date:   Sat, 27 Jun 2020 09:20:44 -0400
Message-Id: <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
In-Reply-To: <cover.1593198710.git.rgb@redhat.com>
References: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
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
 kernel/audit.c           | 23 +++++++++++++++++++++--
 kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
 security/yama/yama_lsm.c | 33 ---------------------------------
 4 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2213ac670386..06938d0b9e0c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2047,4 +2047,7 @@ static inline void rseq_syscall(struct pt_regs *regs)
 
 const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
 
+extern int task_is_descendant(struct task_struct *parent,
+			      struct task_struct *child);
+
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index a862721dfd9b..efa65ec01239 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2713,6 +2713,20 @@ int audit_signal_info(int sig, struct task_struct *t)
 	return audit_signal_info_syscall(t);
 }
 
+static bool audit_contid_isnesting(struct task_struct *tsk)
+{
+	bool isowner = false;
+	bool ownerisparent = false;
+
+	rcu_read_lock();
+	if (tsk->audit && tsk->audit->cont) {
+		isowner = current == tsk->audit->cont->owner;
+		ownerisparent = task_is_descendant(tsk->audit->cont->owner, current);
+	}
+	rcu_read_unlock();
+	return !isowner && ownerisparent;
+}
+
 /*
  * audit_set_contid - set current task's audit contid
  * @task: target task
@@ -2755,8 +2769,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 		rc = -EBUSY;
 		goto unlock;
 	}
-	/* if contid is already set, deny */
-	if (audit_contid_set(task))
+	/* if task is not descendant, block */
+	if (task == current || !task_is_descendant(current, task)) {
+		rc = -EXDEV;
+		goto unlock;
+	}
+	/* only allow contid setting again if nesting */
+	if (audit_contid_set(task) && !audit_contid_isnesting(task))
 		rc = -EEXIST;
 unlock:
 	read_unlock(&tasklist_lock);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8f360326861e..e6b24c52b3c3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8012,6 +8012,39 @@ void dump_cpu_task(int cpu)
 }
 
 /*
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
+/*
  * Nice levels are multiplicative, with a gentle 10% change for every
  * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
  * nice 1, it will get ~10% less CPU time than another CPU-bound task
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 536c99646f6a..24939f765df5 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -263,39 +263,6 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 }
 
 /**
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
-/**
  * ptracer_exception_found - tracer registered as exception for this tracee
  * @tracer: the task_struct of the process attempting ptrace
  * @tracee: the task_struct of the process to be ptraced
-- 
1.8.3.1

