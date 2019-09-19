Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06CB70D0
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbfISB0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387882AbfISB0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:26:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3CBEA302C080;
        Thu, 19 Sep 2019 01:26:42 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6F5760C18;
        Thu, 19 Sep 2019 01:26:36 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 15/21] sched: pull task_is_descendant into kernel/sched/core.c
Date:   Wed, 18 Sep 2019 21:22:32 -0400
Message-Id: <ff8a73c7841ef788c60f13f90d036b321af0e431.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 19 Sep 2019 01:26:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the task_is_descendant() function is used in YAMA and in audit,
pull the function into kernel/core/sched.c

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h    |  3 +++
 kernel/audit.c           | 33 ---------------------------------
 kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
 security/yama/yama_lsm.c | 33 ---------------------------------
 4 files changed, 36 insertions(+), 66 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a936d162513a..b251f018f4db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1988,4 +1988,7 @@ static inline void rseq_syscall(struct pt_regs *regs)
 
 const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
 
+extern int task_is_descendant(struct task_struct *parent,
+			      struct task_struct *child);
+
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index 69fe1e9af7cb..4fe7678304dd 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2560,39 +2560,6 @@ static struct task_struct *audit_cont_owner(struct task_struct *tsk)
 }
 
 /*
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
-/*
  * audit_set_contid - set current task's audit contid
  * @task: target task
  * @contid: contid value
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2b037f195473..7ba9e07381fa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7509,6 +7509,39 @@ void dump_cpu_task(int cpu)
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
index 94dc346370b1..25eae205eae8 100644
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

