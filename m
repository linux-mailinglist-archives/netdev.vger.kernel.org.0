Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F862B549D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgKPWvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgKPWvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:51:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75A362244C;
        Mon, 16 Nov 2020 22:51:09 +0000 (UTC)
Date:   Mon, 16 Nov 2020 17:51:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Matt Mullins <mmullins@mmlx.us>,
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
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] tracepoint: Do not fail unregistering a probe due to memory
 allocation
Message-ID: <20201116175107.02db396d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ Kees, I added you because you tend to know about these things.
  Is it OK to assign a void func(void) that doesn't do anything and returns
  nothing to a function pointer that could be call with parameters? We need
  to add stubs for tracepoints when we fail to allocate a new array on
  removal of a callback, but the callbacks do have arguments, but the stub
  called does not have arguments.

  Matt, Does this patch fix the error your patch was trying to fix?
]

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
stub function that could be cleaned up on the next modification of the
array. That is, instead of calling the function registered to the
tracepoint, it would call a stub function in its place.

Link: https://lore.kernel.org/r/20201115055256.65625-1-mmullins@mmlx.us

Cc: stable@vger.kernel.org
Fixes: 97e1c18e8d17b ("tracing: Kernel Tracepoints")
Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
Reported-by: Matt Mullins <mmullins@mmlx.us>
---
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3f659f855074..774b3733cbbe 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -53,10 +53,16 @@ struct tp_probes {
 	struct tracepoint_func probes[];
 };
 
-static inline void *allocate_probes(int count)
+/* Called in removal of a func but failed to allocate a new tp_funcs */
+static void tp_stub_func(void)
+{
+	return;
+}
+
+static inline void *allocate_probes(int count, gfp_t extra_flags)
 {
 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
-				       GFP_KERNEL);
+				       GFP_KERNEL | extra_flags);
 	return p == NULL ? NULL : p->probes;
 }
 
@@ -131,6 +137,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 {
 	struct tracepoint_func *old, *new;
 	int nr_probes = 0;
+	int stub_funcs = 0;
 	int pos = -1;
 
 	if (WARN_ON(!tp_func->func))
@@ -147,14 +154,34 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 			if (old[nr_probes].func == tp_func->func &&
 			    old[nr_probes].data == tp_func->data)
 				return ERR_PTR(-EEXIST);
+			if (old[nr_probes].func == tp_stub_func)
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
+				if (old[nr_probes].func == tp_stub_func)
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
@@ -188,8 +215,9 @@ static void *func_remove(struct tracepoint_func **funcs,
 	/* (N -> M), (N > 1, M >= 0) probes */
 	if (tp_func->func) {
 		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-			if (old[nr_probes].func == tp_func->func &&
-			     old[nr_probes].data == tp_func->data)
+			if ((old[nr_probes].func == tp_func->func &&
+			     old[nr_probes].data == tp_func->data) ||
+			    old[nr_probes].func == tp_stub_func)
 				nr_del++;
 		}
 	}
@@ -207,15 +235,33 @@ static void *func_remove(struct tracepoint_func **funcs,
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
+				    && old[i].func != tp_stub_func)
+					new[j++] = old[i];
+			new[nr_probes - nr_del].func = NULL;
+			*funcs = new;
+		} else {
+			/*
+			 * Failed to allocate, replace the old function
+			 * with calls to tp_stub_func.
+			 */
+			for (i = 0; old[i].func; i++)
+				if (old[i].func == tp_func->func &&
+				    old[i].data == tp_func->data) {
+					old[i].func = tp_stub_func;
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
@@ -295,10 +341,12 @@ static int tracepoint_remove_func(struct tracepoint *tp,
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
