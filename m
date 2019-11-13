Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21CAFA153
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbfKMB4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:56:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729527AbfKMB4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6728222D3;
        Wed, 13 Nov 2019 01:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610194;
        bh=yEwg5eq9AJUgDswCxH1W7TOiH2oQz7hZu2VUsre4Ml0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3Y6EM/3L5y3AudnPXVvts9wj/dx6z2r/1U/BOlzJuhhXu34rGVYJHNANfeQHdjB4
         0Xj9hur5dexhQtZP6ZF6Utv/Vsgeuggf3IAg4aEP9mK8rA16EFNQokb7NF9UB/Dd4I
         PTZCY680J06oqN/SjyFeN3vLTDUVkYh0qQMqn4cw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 008/115] SUNRPC: Fix priority queue fairness
Date:   Tue, 12 Nov 2019 20:54:35 -0500
Message-Id: <20191113015622.11592-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f42f7c283078ce3c1e8368b140e270755b1ae313 ]

Fix up the priority queue to not batch by owner, but by queue, so that
we allow '1 << priority' elements to be dequeued before switching to
the next priority queue.
The owner field is still used to wake up requests in round robin order
by owner to avoid single processes hogging the RPC layer by loading the
queues.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/sched.h |   2 -
 net/sunrpc/sched.c           | 109 +++++++++++++++++------------------
 2 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index d96e74e114c06..c9548a63d09bb 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -188,7 +188,6 @@ struct rpc_timer {
 struct rpc_wait_queue {
 	spinlock_t		lock;
 	struct list_head	tasks[RPC_NR_PRIORITY];	/* task queue for each priority level */
-	pid_t			owner;			/* process id of last task serviced */
 	unsigned char		maxpriority;		/* maximum priority (0 if queue is not a priority queue) */
 	unsigned char		priority;		/* current priority */
 	unsigned char		nr;			/* # tasks remaining for cookie */
@@ -204,7 +203,6 @@ struct rpc_wait_queue {
  * from a single cookie.  The aim is to improve
  * performance of NFS operations such as read/write.
  */
-#define RPC_BATCH_COUNT			16
 #define RPC_IS_PRIORITY(q)		((q)->maxpriority > 0)
 
 /*
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index f9db5fe52d367..aff76fb434300 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -99,64 +99,78 @@ __rpc_add_timer(struct rpc_wait_queue *queue, struct rpc_task *task)
 	list_add(&task->u.tk_wait.timer_list, &queue->timer_list.list);
 }
 
-static void rpc_rotate_queue_owner(struct rpc_wait_queue *queue)
-{
-	struct list_head *q = &queue->tasks[queue->priority];
-	struct rpc_task *task;
-
-	if (!list_empty(q)) {
-		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
-		if (task->tk_owner == queue->owner)
-			list_move_tail(&task->u.tk_wait.list, q);
-	}
-}
-
 static void rpc_set_waitqueue_priority(struct rpc_wait_queue *queue, int priority)
 {
 	if (queue->priority != priority) {
-		/* Fairness: rotate the list when changing priority */
-		rpc_rotate_queue_owner(queue);
 		queue->priority = priority;
+		queue->nr = 1U << priority;
 	}
 }
 
-static void rpc_set_waitqueue_owner(struct rpc_wait_queue *queue, pid_t pid)
-{
-	queue->owner = pid;
-	queue->nr = RPC_BATCH_COUNT;
-}
-
 static void rpc_reset_waitqueue_priority(struct rpc_wait_queue *queue)
 {
 	rpc_set_waitqueue_priority(queue, queue->maxpriority);
-	rpc_set_waitqueue_owner(queue, 0);
 }
 
 /*
- * Add new request to a priority queue.
+ * Add a request to a queue list
  */
-static void __rpc_add_wait_queue_priority(struct rpc_wait_queue *queue,
-		struct rpc_task *task,
-		unsigned char queue_priority)
+static void
+__rpc_list_enqueue_task(struct list_head *q, struct rpc_task *task)
 {
-	struct list_head *q;
 	struct rpc_task *t;
 
-	INIT_LIST_HEAD(&task->u.tk_wait.links);
-	if (unlikely(queue_priority > queue->maxpriority))
-		queue_priority = queue->maxpriority;
-	if (queue_priority > queue->priority)
-		rpc_set_waitqueue_priority(queue, queue_priority);
-	q = &queue->tasks[queue_priority];
 	list_for_each_entry(t, q, u.tk_wait.list) {
 		if (t->tk_owner == task->tk_owner) {
-			list_add_tail(&task->u.tk_wait.list, &t->u.tk_wait.links);
+			list_add_tail(&task->u.tk_wait.links,
+					&t->u.tk_wait.links);
+			/* Cache the queue head in task->u.tk_wait.list */
+			task->u.tk_wait.list.next = q;
+			task->u.tk_wait.list.prev = NULL;
 			return;
 		}
 	}
+	INIT_LIST_HEAD(&task->u.tk_wait.links);
 	list_add_tail(&task->u.tk_wait.list, q);
 }
 
+/*
+ * Remove request from a queue list
+ */
+static void
+__rpc_list_dequeue_task(struct rpc_task *task)
+{
+	struct list_head *q;
+	struct rpc_task *t;
+
+	if (task->u.tk_wait.list.prev == NULL) {
+		list_del(&task->u.tk_wait.links);
+		return;
+	}
+	if (!list_empty(&task->u.tk_wait.links)) {
+		t = list_first_entry(&task->u.tk_wait.links,
+				struct rpc_task,
+				u.tk_wait.links);
+		/* Assume __rpc_list_enqueue_task() cached the queue head */
+		q = t->u.tk_wait.list.next;
+		list_add_tail(&t->u.tk_wait.list, q);
+		list_del(&task->u.tk_wait.links);
+	}
+	list_del(&task->u.tk_wait.list);
+}
+
+/*
+ * Add new request to a priority queue.
+ */
+static void __rpc_add_wait_queue_priority(struct rpc_wait_queue *queue,
+		struct rpc_task *task,
+		unsigned char queue_priority)
+{
+	if (unlikely(queue_priority > queue->maxpriority))
+		queue_priority = queue->maxpriority;
+	__rpc_list_enqueue_task(&queue->tasks[queue_priority], task);
+}
+
 /*
  * Add new request to wait queue.
  *
@@ -194,13 +208,7 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
  */
 static void __rpc_remove_wait_queue_priority(struct rpc_task *task)
 {
-	struct rpc_task *t;
-
-	if (!list_empty(&task->u.tk_wait.links)) {
-		t = list_entry(task->u.tk_wait.links.next, struct rpc_task, u.tk_wait.list);
-		list_move(&t->u.tk_wait.list, &task->u.tk_wait.list);
-		list_splice_init(&task->u.tk_wait.links, &t->u.tk_wait.links);
-	}
+	__rpc_list_dequeue_task(task);
 }
 
 /*
@@ -212,7 +220,8 @@ static void __rpc_remove_wait_queue(struct rpc_wait_queue *queue, struct rpc_tas
 	__rpc_disable_timer(queue, task);
 	if (RPC_IS_PRIORITY(queue))
 		__rpc_remove_wait_queue_priority(task);
-	list_del(&task->u.tk_wait.list);
+	else
+		list_del(&task->u.tk_wait.list);
 	queue->qlen--;
 	dprintk("RPC: %5u removed from queue %p \"%s\"\n",
 			task->tk_pid, queue, rpc_qname(queue));
@@ -481,17 +490,9 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 	 * Service a batch of tasks from a single owner.
 	 */
 	q = &queue->tasks[queue->priority];
-	if (!list_empty(q)) {
-		task = list_entry(q->next, struct rpc_task, u.tk_wait.list);
-		if (queue->owner == task->tk_owner) {
-			if (--queue->nr)
-				goto out;
-			list_move_tail(&task->u.tk_wait.list, q);
-		}
-		/*
-		 * Check if we need to switch queues.
-		 */
-		goto new_owner;
+	if (!list_empty(q) && --queue->nr) {
+		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
+		goto out;
 	}
 
 	/*
@@ -503,7 +504,7 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 		else
 			q = q - 1;
 		if (!list_empty(q)) {
-			task = list_entry(q->next, struct rpc_task, u.tk_wait.list);
+			task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
 			goto new_queue;
 		}
 	} while (q != &queue->tasks[queue->priority]);
@@ -513,8 +514,6 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 
 new_queue:
 	rpc_set_waitqueue_priority(queue, (unsigned int)(q - &queue->tasks[0]));
-new_owner:
-	rpc_set_waitqueue_owner(queue, task->tk_owner);
 out:
 	return task;
 }
-- 
2.20.1

