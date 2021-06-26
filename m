Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4951B3B4EEB
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 16:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFZOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 10:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhFZOVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 10:21:19 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C81661C2E;
        Sat, 26 Jun 2021 14:18:56 +0000 (UTC)
Date:   Sat, 26 Jun 2021 10:18:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
Message-ID: <20210626101834.55b4ecf1@rorschach.local.home>
In-Reply-To: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Jun 2021 22:58:45 +0900
Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> syzbot is hitting WARN_ON_ONCE() at tracepoint_add_func() [1], but
> func_add() returning -EEXIST and func_remove() returning -ENOENT are
> not kernel bugs that can justify crashing the system.

There should be no path that registers a tracepoint twice. That's a bug
in the kernel. Looking at the link below, I see the backtrace:

Call Trace:
 tracepoint_probe_register_prio kernel/tracepoint.c:369 [inline]
 tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:389
 __bpf_probe_register kernel/trace/bpf_trace.c:2154 [inline]
 bpf_probe_register+0x15a/0x1c0 kernel/trace/bpf_trace.c:2159
 bpf_raw_tracepoint_open+0x34a/0x720 kernel/bpf/syscall.c:2878
 __do_sys_bpf+0x2586/0x4f40 kernel/bpf/syscall.c:4435
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47

So BPF is allowing the user to register the same tracepoint more than
once? That looks to be a bug in the BPF code where it shouldn't be
allowing user space to register the same tracepoint multiple times.

If we take the patch and just error out, that is probably not what the
BPF user wants.

-- Steve



> 
> Commit d66a270be3310d7a ("tracepoint: Do not warn on ENOMEM") says that
> tracepoint should only warn when a kernel API user does not respect the
> required preconditions (e.g. same tracepoint enabled twice, or called
> to remove a tracepoint that does not exist). But WARN*() must be used to
> denote kernel bugs and not to print simple warnings. If someone wants to
> print warnings, pr_warn() etc. should be used instead.
> 
> Link: https://syzkaller.appspot.com/bug?id=41f4318cf01762389f4d1c1c459da4f542fe5153 [1]
> Reported-by: syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
> ---
>  kernel/tracepoint.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 9f478d29b926..3cfa37a3d05c 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -287,10 +287,8 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  	tp_funcs = rcu_dereference_protected(tp->funcs,
>  			lockdep_is_held(&tracepoints_mutex));
>  	old = func_add(&tp_funcs, func, prio);
> -	if (IS_ERR(old)) {
> -		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
> +	if (IS_ERR(old))
>  		return PTR_ERR(old);
> -	}
>  
>  	/*
>  	 * rcu_assign_pointer has as smp_store_release() which makes sure
> @@ -320,7 +318,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  	tp_funcs = rcu_dereference_protected(tp->funcs,
>  			lockdep_is_held(&tracepoints_mutex));
>  	old = func_remove(&tp_funcs, func);
> -	if (WARN_ON_ONCE(IS_ERR(old)))
> +	if (IS_ERR(old))
>  		return PTR_ERR(old);
>  
>  	if (tp_funcs == old)

