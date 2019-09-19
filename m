Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B671EB70CD
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbfISB0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387790AbfISB0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:26:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5B3CE800DF1;
        Thu, 19 Sep 2019 01:26:36 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7E0C6107E;
        Thu, 19 Sep 2019 01:26:21 +0000 (UTC)
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
Subject: [PATCH ghak90 V7 14/21] audit: contid check descendancy and nesting
Date:   Wed, 18 Sep 2019 21:22:31 -0400
Message-Id: <16abf1b2aafeb5f1b8dae20b9a4836e54f959ca5.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 19 Sep 2019 01:26:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

?fixup! audit: convert to contid list to check for orch/engine ownership

Require the target task to be a descendant of the container
orchestrator/engine.

You would only change the audit container ID from one set or inherited
value to another if you were nesting containers.

If changing the contid, the container orchestrator/engine must be a
descendant and not same orchestrator as the one that set it so it is not
possible to change the contid of another orchestrator's container.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 8 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9ce7a1ec7a92..69fe1e9af7cb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -2560,6 +2560,39 @@ static struct task_struct *audit_cont_owner(struct task_struct *tsk)
 }
 
 /*
+ * task_is_descendant - walk up a process family tree looking for a match
+ * @parent: the process to compare against while walking up from child
+ * @child: the process to start from while looking upwards for parent
+ *
+ * Returns 1 if child is a descendant of parent, 0 if not.
+ */
+static int task_is_descendant(struct task_struct *parent,
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
  * audit_set_contid - set current task's audit contid
  * @task: target task
  * @contid: contid value
@@ -2587,22 +2620,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	oldcontid = audit_get_contid(task);
 	read_lock(&tasklist_lock);
 	/* Don't allow the contid to be unset */
-	if (!audit_contid_valid(contid))
+	if (!audit_contid_valid(contid)) {
 		rc = -EINVAL;
+		goto unlock;
+	}
 	/* Don't allow the contid to be set to the same value again */
-	else if (contid == oldcontid) {
+	if (contid == oldcontid) {
 		rc = -EADDRINUSE;
+		goto unlock;
+	}
 	/* if we don't have caps, reject */
-	else if (!capable(CAP_AUDIT_CONTROL))
+	if (!capable(CAP_AUDIT_CONTROL)) {
 		rc = -EPERM;
-	/* if task has children or is not single-threaded, deny */
-	else if (!list_empty(&task->children))
+		goto unlock;
+	}
+	/* if task has children, deny */
+	if (!list_empty(&task->children)) {
 		rc = -EBUSY;
-	else if (!(thread_group_leader(task) && thread_group_empty(task)))
+		goto unlock;
+	}
+	/* if task is not single-threaded, deny */
+	if (!(thread_group_leader(task) && thread_group_empty(task))) {
 		rc = -EALREADY;
-	/* if contid is already set, deny */
-	else if (audit_contid_set(task))
+		goto unlock;
+	}
+	/* if task is not descendant, block */
+	if (task == current) {
+		rc = -EBADSLT;
+		goto unlock;
+	}
+	if (!task_is_descendant(current, task)) {
+		rc = -EXDEV;
+		goto unlock;
+	}
+	/* only allow contid setting again if nesting */
+	if (audit_contid_set(task) && current == audit_cont_owner(task))
 		rc = -ECHILD;
+unlock:
 	read_unlock(&tasklist_lock);
 	if (!rc) {
 		struct audit_cont *oldcont = audit_cont(task);
-- 
1.8.3.1

