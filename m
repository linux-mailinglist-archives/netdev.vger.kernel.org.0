Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54D726F291
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgIRC7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgIRCFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C891238D6;
        Fri, 18 Sep 2020 02:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394751;
        bh=uMzatrwYt8y8qpM4E128ZkyGVe/RJOCjs/3WqC4f2/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hilvsCY9dtRN2zSEjSx7zpxYrczgXJuPKeg9LtlHGDFrnRyfd232/qJqTxQzIPhK
         NGqD7R2zioSy8qLREJd9tYnLTJ7mgz+aia3+D1nDdTrOvsbITTJW6eUCRShyoKFQdh
         pgS0XlDJrvVerevmsNv83AZoIlAHht/QrAcvWQ7w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 229/330] SUNRPC: Don't start a timer on an already queued rpc task
Date:   Thu, 17 Sep 2020 21:59:29 -0400
Message-Id: <20200918020110.2063155-229-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1fab7dc477241c12f977955aa6baea7938b6f08d ]

Move the test for whether a task is already queued to prevent
corruption of the timer list in __rpc_sleep_on_priority_timeout().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 9c79548c68474..53d8b82eda006 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -204,10 +204,6 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
 		struct rpc_task *task,
 		unsigned char queue_priority)
 {
-	WARN_ON_ONCE(RPC_IS_QUEUED(task));
-	if (RPC_IS_QUEUED(task))
-		return;
-
 	INIT_LIST_HEAD(&task->u.tk_wait.timer_list);
 	if (RPC_IS_PRIORITY(queue))
 		__rpc_add_wait_queue_priority(queue, task, queue_priority);
@@ -382,7 +378,7 @@ static void rpc_make_runnable(struct workqueue_struct *wq,
  * NB: An RPC task will only receive interrupt-driven events as long
  * as it's on a wait queue.
  */
-static void __rpc_sleep_on_priority(struct rpc_wait_queue *q,
+static void __rpc_do_sleep_on_priority(struct rpc_wait_queue *q,
 		struct rpc_task *task,
 		unsigned char queue_priority)
 {
@@ -395,12 +391,23 @@ static void __rpc_sleep_on_priority(struct rpc_wait_queue *q,
 
 }
 
+static void __rpc_sleep_on_priority(struct rpc_wait_queue *q,
+		struct rpc_task *task,
+		unsigned char queue_priority)
+{
+	if (WARN_ON_ONCE(RPC_IS_QUEUED(task)))
+		return;
+	__rpc_do_sleep_on_priority(q, task, queue_priority);
+}
+
 static void __rpc_sleep_on_priority_timeout(struct rpc_wait_queue *q,
 		struct rpc_task *task, unsigned long timeout,
 		unsigned char queue_priority)
 {
+	if (WARN_ON_ONCE(RPC_IS_QUEUED(task)))
+		return;
 	if (time_is_after_jiffies(timeout)) {
-		__rpc_sleep_on_priority(q, task, queue_priority);
+		__rpc_do_sleep_on_priority(q, task, queue_priority);
 		__rpc_add_timer(q, task, timeout);
 	} else
 		task->tk_status = -ETIMEDOUT;
-- 
2.25.1

