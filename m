Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E17D328522
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhCAQta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233279AbhCAQot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 11:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13D464F94;
        Mon,  1 Mar 2021 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616269;
        bh=JZuoPyem7BXj70uXYt5WEXtN+U06Wcpxah3YyjHUWjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MRRNC/kY+giGkDPBMuRjZTZ11jeHqwOs0qXtEMYyHRTMfOADARkhYaar3YwFB1bT
         6SmLjkfjoYj/iyRC/KFf3alfNqhzrEbzyE68b2+EjrfXIEmu9Q8NXt7HhunmHoIlRH
         9zoObdvSk/W/5+a2lkH0KGazx8XZBNQ3ruPbBKzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
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
        Matt Mullins <mmullins@mmlx.us>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/176] tracepoint: Do not fail unregistering a probe due to memory failure
Date:   Mon,  1 Mar 2021 17:12:44 +0100
Message-Id: <20210301161025.500837025@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit befe6d946551d65cddbd32b9cb0170b0249fd5ed ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/tracepoint.c | 80 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 16 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index a170d83043a5a..b65b2e7fd8507 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -60,6 +60,12 @@ struct tp_probes {
 	struct tracepoint_func probes[0];
 };
 
+/* Called in removal of a func but failed to allocate a new tp_funcs */
+static void tp_stub_func(void)
+{
+	return;
+}
+
 static inline void *allocate_probes(int count)
 {
 	struct tp_probes *p  = kmalloc(count * sizeof(struct tracepoint_func)
@@ -98,6 +104,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 {
 	struct tracepoint_func *old, *new;
 	int nr_probes = 0;
+	int stub_funcs = 0;
 	int pos = -1;
 
 	if (WARN_ON(!tp_func->func))
@@ -114,14 +121,34 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
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
@@ -155,8 +182,9 @@ static void *func_remove(struct tracepoint_func **funcs,
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
@@ -175,14 +203,32 @@ static void *func_remove(struct tracepoint_func **funcs,
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
@@ -239,10 +285,12 @@ static int tracepoint_remove_func(struct tracepoint *tp,
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
2.27.0



