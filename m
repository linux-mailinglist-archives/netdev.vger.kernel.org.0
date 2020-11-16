Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6C42B54D8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgKPXQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:16:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgKPXQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:16:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CC652225E;
        Mon, 16 Nov 2020 23:16:39 +0000 (UTC)
Date:   Mon, 16 Nov 2020 18:16:38 -0500
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
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201116181638.6b0de6f7@gandalf.local.home>
In-Reply-To: <20201116175107.02db396d@gandalf.local.home>
References: <20201116175107.02db396d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 17:51:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> [ Kees, I added you because you tend to know about these things.
>   Is it OK to assign a void func(void) that doesn't do anything and returns
>   nothing to a function pointer that could be call with parameters? We need
>   to add stubs for tracepoints when we fail to allocate a new array on
>   removal of a callback, but the callbacks do have arguments, but the stub
>   called does not have arguments.
> 
>   Matt, Does this patch fix the error your patch was trying to fix?
> ]
> 
> The list of tracepoint callbacks is managed by an array that is protected
> by RCU. To update this array, a new array is allocated, the updates are
> copied over to the new array, and then the list of functions for the
> tracepoint is switched over to the new array. After a completion of an RCU
> grace period, the old array is freed.
> 
> This process happens for both adding a callback as well as removing one.
> But on removing a callback, if the new array fails to be allocated, the
> callback is not removed, and may be used after it is freed by the clients
> of the tracepoint.
> 
> There's really no reason to fail if the allocation for a new array fails
> when removing a function. Instead, the function can simply be replaced by a
> stub function that could be cleaned up on the next modification of the
> array. That is, instead of calling the function registered to the
> tracepoint, it would call a stub function in its place.
> 
> Link: https://lore.kernel.org/r/20201115055256.65625-1-mmullins@mmlx.us
> 
> Cc: stable@vger.kernel.org
> Fixes: 97e1c18e8d17b ("tracing: Kernel Tracepoints")
> Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
> Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
> Reported-by: Matt Mullins <mmullins@mmlx.us>

Forgot my:

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

and tested with adding this (just to see if paths are hit).

-- Steve

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 774b3733cbbe..96f081ff5284 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -167,6 +167,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
 			/* Need to copy one at a time to remove stubs */
 			int probes = 0;
 
+			printk("HERE stub_funcs=%d\n", stub_funcs);
 			pos = -1;
 			for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
 				if (old[nr_probes].func == tp_stub_func)
@@ -235,7 +236,7 @@ static void *func_remove(struct tracepoint_func **funcs,
 		int j = 0;
 		/* N -> M, (N > 1, M > 0) */
 		/* + 1 for NULL */
-		new = allocate_probes(nr_probes - nr_del + 1, __GFP_NOFAIL);
+		new = NULL; //allocate_probes(nr_probes - nr_del + 1, __GFP_NOFAIL);
 		if (new) {
 			for (i = 0; old[i].func; i++)
 				if ((old[i].func != tp_func->func
