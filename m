Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E89D1E038A
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbgEXV6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388038AbgEXV6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:58:20 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0946C061A0E;
        Sun, 24 May 2020 14:58:20 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jcycw-0007Zv-U8; Sun, 24 May 2020 23:57:51 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 5/7] connector/cn_proc: Protect send_msg() with a local lock
Date:   Sun, 24 May 2020 23:57:37 +0200
Message-Id: <20200524215739.551568-6-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.27.0.rc0
In-Reply-To: <20200524215739.551568-1-bigeasy@linutronix.de>
References: <20200524215739.551568-1-bigeasy@linutronix.de>
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
 drivers/connector/cn_proc.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index d58ce664da843..d424d1f469136 100644
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
@@ -38,25 +39,32 @@ static inline struct cn_msg *buffer_to_cn_msg(__u8 *buf=
fer)
 static atomic_t proc_event_num_listeners =3D ATOMIC_INIT(0);
 static struct cb_id cn_proc_event_id =3D { CN_IDX_PROC, CN_VAL_PROC };
=20
-/* proc_event_counts is used as the sequence number of the netlink message=
 */
-static DEFINE_PER_CPU(__u32, proc_event_counts) =3D { 0 };
+/* local_evt.counts is used as the sequence number of the netlink message =
*/
+struct local_evt {
+	__u32 counts;
+	struct local_lock lock;
+};
+static DEFINE_PER_CPU(struct local_evt, local_evt) =3D {
+	.counts =3D 0,
+	.lock =3D INIT_LOCAL_LOCK(lock),
+};
=20
 static inline void send_msg(struct cn_msg *msg)
 {
-	preempt_disable();
+	local_lock(&local_evt.lock);
=20
-	msg->seq =3D __this_cpu_inc_return(proc_event_counts) - 1;
+	msg->seq =3D __this_cpu_inc_return(local_evt.counts) - 1;
 	((struct proc_event *)msg->data)->cpu =3D smp_processor_id();
=20
 	/*
-	 * Preemption remains disabled during send to ensure the messages are
-	 * ordered according to their sequence numbers.
+	 * local_lock() disables preemption during send to ensure the messages
+	 * are ordered according to their sequence numbers.
 	 *
 	 * If cn_netlink_send() fails, the data is not sent.
 	 */
 	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT);
=20
-	preempt_enable();
+	local_unlock(&local_evt.lock);
 }
=20
 void proc_fork_connector(struct task_struct *task)
--=20
2.27.0.rc0

