Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90AC2B7422
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKRCSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:18:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgKRCSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 21:18:42 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14BC324655;
        Wed, 18 Nov 2020 02:18:38 +0000 (UTC)
Date:   Tue, 17 Nov 2020 21:18:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Matt Mullins <mmullins@mmlx.us>, paulmck <paulmck@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201117211836.54acaef2@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The list of tracepoint callbacks is managed by an array that is protected
by RCU. To update this array, a new array is allocated, the updates are
copied over to the new array, and then the list of functions for the
tracepoint is switched over to the new array. After a completion of an RCU
grace period, the old array is freed.

This process happens for both adding a callback as well as removing one.
But on removing a callback, if the new array fails to be allocated, the
callback is not removed, and may be used after it is freed by the clients
of the tracepoint.

There's really no reason to fail if the allocation for a new array fails
when removing a function. Instead, the function can simply be replaced by a
stub that will be ignored in the callback loop, and it will be cleaned up
on the next modification of the array.

Link: https://lore.kernel.org/r/20201115055256.65625-1-mmullins@mmlx.us
Link: https://lkml.kernel.org/r/20201116175107.02db396d@gandalf.local.home

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Cc: netdev <netdev@vger.kernel.org>
Cc: bpf <bpf@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Fixes: 97e1c18e8d17b ("tracing: Kernel Tracepoints")
Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
Reported-by: Matt Mullins <mmullins@mmlx.us>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:
   Use 1L value for stub function, and ignore calling it.

 include/linux/tracepoint.h |  9 ++++-
 kernel/tracepoint.c        | 80 +++++++++++++++++++++++++++++---------
 2 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 0f21617f1a66..2e06e05b9d2a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,6 +33,8 @@ struct trace_eval_map {
 
 #define TRACEPOINT_DEFAULT_PRIO	10
 
+#define TRACEPOINT_STUB		((void *)0x1L)
+
 extern struct srcu_struct tracepoint_srcu;
 
 extern int
@@ -310,7 +312,12 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		do {							\
 			it_func = (it_func_ptr)->func;			\
 			__data = (it_func_ptr)->data;			\
-			((void(*)(void *, proto))(it_func))(__data, args); \
+			/*						\
+			 * Removed functions that couldn't be allocated \
+			 * are replaced with TRACEPOINT_STUB.		\
+			 */						\
+			if (likely(it_func != TRACEPOINT_STUB))		\
+				((void(*)(void *, proto))(it_func))(__data, args); \
 		} while ((++it_func_ptr)->func);			\
 		return 0;						\
 	}								\
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3f659f855074..20ce78b3f578 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -53,10 +53,10 @@ struct tp_probes {
 	struct tracepoint_func probes[];
 };
 
-static inline void *allocate_probes(int count)
+static inline void *allocate_probes(int count, gfp_t extra_flags)
 {
 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
-				       GFP_KERNEL);
+				       GFP_KERNEL | extra_flags);
 	return p == NULL ? NULL : p->probes;
 }
 
@@ -131,6 +131,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 {
 	struct tracepoint_func *old, *new;
 	int nr_probes = 0;
+	int stub_funcs = 0;
 	int pos = -1;
 
 	if (WARN_ON(!tp_func->func))
@@ -147,14 +148,34 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 			if (old[nr_probes].func == tp_func->func &&
 			    old[nr_probes].data == tp_func->data)
 				return ERR_PTR(-EEXIST);
+			if (old[nr_probes].func == TRACEPOINT_STUB)
+				stub_funcs++;
 		}
 	}
-	/* + 2 : one for new probe, one for NULL func */
-	new = allocate_probes(nr_probes + 2);
+	/* + 2 : one for new probe, one for NULL func - stub functions */
+	new = allocate_probes(nr_probes + 2 - stub_funcs, 0);
 	if (new == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (old) {
-		if (pos < 0) {
+		if (stub_funcs) {
+			/* Need to copy one at a time to remove stubs */
+			int probes = 0;
+
+			pos = -1;
+			for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+				if (old[nr_probes].func == TRACEPOINT_STUB)
+					continue;
+				if (pos < 0 && old[nr_probes].prio < prio)
+					pos = probes++;
+				new[probes++] = old[nr_probes];
+			}
+			nr_probes = probes;
+			if (pos < 0)
+				pos = probes;
+			else
+				nr_probes--; /* Account for insertion */
+
+		} else if (pos < 0) {
 			pos = nr_probes;
 			memcpy(new, old, nr_probes * sizeof(struct tracepoint_func));
 		} else {
@@ -188,8 +209,9 @@ static void *func_remove(struct tracepoint_func **funcs,
 	/* (N -> M), (N > 1, M >= 0) probes */
 	if (tp_func->func) {
 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-			if (old[nr_probes].func == tp_func->func &&
-			     old[nr_probes].data == tp_func->data)
+			if ((old[nr_probes].func == tp_func->func &&
+			     old[nr_probes].data == tp_func->data) ||
+			    old[nr_probes].func == TRACEPOINT_STUB)
 				nr_del++;
 		}
 	}
@@ -207,15 +229,33 @@ static void *func_remove(struct tracepoint_func **funcs,
 		int j = 0;
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
-		new = allocate_probes(nr_probes - nr_del + 1);
-		if (new == NULL)
-			return ERR_PTR(-ENOMEM);
-		for (i = 0; old[i].func; i++)
-			if (old[i].func != tp_func->func
-					|| old[i].data != tp_func->data)
-				new[j++] = old[i];
-		new[nr_probes - nr_del].func = NULL;
-		*funcs = new;
+		new = allocate_probes(nr_probes - nr_del + 1, __GFP_NOFAIL);
+		if (new) {
+			for (i = 0; old[i].func; i++)
+				if ((old[i].func != tp_func->func
+				     || old[i].data != tp_func->data)
+				    && old[i].func != TRACEPOINT_STUB)
+					new[j++] = old[i];
+			new[nr_probes - nr_del].func = NULL;
+			*funcs = new;
+		} else {
+			/*
+			 * Failed to allocate, replace the old function
+			 * with TRACEPOINT_STUB.
+			 */
+			for (i = 0; old[i].func; i++)
+				if (old[i].func == tp_func->func &&
+				    old[i].data == tp_func->data) {
+					old[i].func = TRACEPOINT_STUB;
+					/* Set the prio to the next event. */
+					if (old[i + 1].func)
+						old[i].prio =
+							old[i + 1].prio;
+					else
+						old[i].prio = -1;
+				}
+			*funcs = old;
+		}
 	}
 	debug_print_probes(*funcs);
 	return old;
@@ -295,10 +335,12 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 	tp_funcs = rcu_dereference_protected(tp->funcs,
 			lockdep_is_held(&tracepoints_mutex));
 	old = func_remove(&tp_funcs, func);
-	if (IS_ERR(old)) {
-		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
+	if (WARN_ON_ONCE(IS_ERR(old)))
 		return PTR_ERR(old);
-	}
+
+	if (tp_funcs == old)
+		/* Failed allocating new tp_funcs, replaced func with stub */
+		return 0;
 
 	if (!tp_funcs) {
 		/* Removed last function */
-- 
2.25.4

