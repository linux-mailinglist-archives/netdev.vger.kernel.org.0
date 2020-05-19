Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F6A1DA276
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgESUUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgESUUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:20:44 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC5EC08C5C0;
        Tue, 19 May 2020 13:20:43 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jb8ig-00012c-Sv; Tue, 19 May 2020 22:20:10 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6/8] connector/cn_proc: Protect send_msg() with a local lock
Date:   Tue, 19 May 2020 22:19:10 +0200
Message-Id: <20200519201912.1564477-7-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519201912.1564477-1-bigeasy@linutronix.de>
References: <20200519201912.1564477-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Galbraith <umgwanakikbuti@gmail.com>

send_msg() disables preemption to avoid out-of-order messages. As the
code inside the preempt disabled section acquires regular spinlocks,
which are converted to 'sleeping' spinlocks on a PREEMPT_RT kernel and
eventually calls into a memory allocator, this conflicts with the RT
semantics.

Convert it to a local_lock which allows RT kernels to substitute them with
a real per CPU lock. On non RT kernels this maps to preempt_disable() as
before. No functional change.

[bigeasy: Patch description]

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/connector/cn_proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index d58ce664da843..055b0c86a0693 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -18,6 +18,7 @@
 #include <linux/pid_namespace.h>
=20
 #include <linux/cn_proc.h>
+#include <linux/locallock.h>
=20
 /*
  * Size of a cn_msg followed by a proc_event structure.  Since the
@@ -40,10 +41,11 @@ static struct cb_id cn_proc_event_id =3D { CN_IDX_PROC,=
 CN_VAL_PROC };
=20
 /* proc_event_counts is used as the sequence number of the netlink message=
 */
 static DEFINE_PER_CPU(__u32, proc_event_counts) =3D { 0 };
+static DEFINE_LOCAL_LOCK(send_msg_lock);
=20
 static inline void send_msg(struct cn_msg *msg)
 {
-	preempt_disable();
+	local_lock(send_msg_lock);
=20
 	msg->seq =3D __this_cpu_inc_return(proc_event_counts) - 1;
 	((struct proc_event *)msg->data)->cpu =3D smp_processor_id();
@@ -56,7 +58,7 @@ static inline void send_msg(struct cn_msg *msg)
 	 */
 	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT);
=20
-	preempt_enable();
+	local_unlock(send_msg_lock);
 }
=20
 void proc_fork_connector(struct task_struct *task)
--=20
2.26.2

