Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A22930DF38
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhBCQI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234926AbhBCQIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:08:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3C7A64FA5;
        Wed,  3 Feb 2021 16:05:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l7Kf8-009JBv-Qz; Wed, 03 Feb 2021 11:05:50 -0500
Message-ID: <20210203160550.710877069@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 03 Feb 2021 11:05:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
        Florian Weimer <fw@deneb.enyo.de>,
        syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com,
        syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com,
        Matt Mullins <mmullins@mmlx.us>
Subject: [for-next][PATCH 14/15] tracepoint: Do not fail unregistering a probe due to memory failure
References: <20210203160517.982448432@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
stub function that could be cleaned up on the next modification of the
array. That is, instead of calling the function registered to the
tracepoint, it would call a stub function in its place.

Link: https://lore.kernel.org/r/20201115055256.65625-1-mmullins@mmlx.us
Link: https://lore.kernel.org/r/20201116175107.02db396d@gandalf.local.home
Link: https://lore.kernel.org/r/20201117211836.54acaef2@oasis.local.home
Link: https://lkml.kernel.org/r/20201118093405.7a6d2290@gandalf.local.home

[ Note, this version does use undefined compiler behavior (assuming that
  a stub function with no parameters or return, can be called by a location
  that thinks it has parameters but still no return value. Static calls
  do the same thing, so this trick is not without precedent.

  There's another solution that uses RCU tricks and is more complex, but
  can be an alternative if this solution becomes an issue.

  Link: https://lore.kernel.org/lkml/20210127170721.58bce7cc@gandalf.local.home/
]

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
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
Cc: Florian Weimer <fw@deneb.enyo.de>
Fixes: 97e1c18e8d17b ("tracing: Kernel Tracepoints")
Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
Reported-by: Matt Mullins <mmullins@mmlx.us>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Matt Mullins <mmullins@mmlx.us>
---
 kernel/tracepoint.c | 80 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 16 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 7261fa0f5e3c..e8f20ae29c18 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -53,6 +53,12 @@ struct tp_probes {
 	struct tracepoint_func probes[];
 };
 
+/* Called in removal of a func but failed to allocate a new tp_funcs */
+static void tp_stub_func(void)
+{
+	return;
+}
+
 static inline void *allocate_probes(int count)
 {
 	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
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
+	new = allocate_probes(nr_probes + 2 - stub_funcs);
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
@@ -208,14 +236,32 @@ static void *func_remove(struct tracepoint_func **funcs,
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
 		new = allocate_probes(nr_probes - nr_del + 1);
-		if (new == NULL)
-			return ERR_PTR(-ENOMEM);
-		for (i = 0; old[i].func; i++)
-			if (old[i].func != tp_func->func
-					|| old[i].data != tp_func->data)
-				new[j++] = old[i];
-		new[nr_probes - nr_del].func = NULL;
-		*funcs = new;
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
-- 
2.29.2


