Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48949C33F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 06:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiAZF3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 00:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiAZF3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 00:29:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6734C06161C;
        Tue, 25 Jan 2022 21:29:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81D39B81B87;
        Wed, 26 Jan 2022 05:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D142C340E3;
        Wed, 26 Jan 2022 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643174974;
        bh=YqoPDtkI3W4wcHz6EuTeKxDkKjg3vXsCEfTPwtuMcVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KOPvbwet643U+XiYa6ne58RYlIrZiFIe9PHqdoixKsT9nO5i9sCJWCWHHFKLBnj+9
         EMN30IS8oNK2i57U2YypVUtCLBMYCYMAJfAJHxOTDY386TSX7YTQYpqonKx2lOMz8N
         iDiUtgolWuf1/6q/WGSPVGsQQ3jXOa4kzQyZV5wHctCg2UDJ8YlabKO46+bH9J7WBA
         xzbNxOPF04Ir2yYCQRiJVLcZZ0f+C8AA5CQRojV2LQjF+C3+jiQxjcxGTqnErQoGN5
         RPmEd1tyrhtvHn+QLT7sQNURMXRveTftafBpQ2QGE/Z0XqexNNiqVpoCCEOO+ulPVl
         2GuSPdulq8dnw==
Date:   Wed, 26 Jan 2022 14:29:29 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 3/9] rethook: Add a generic return hook
Message-Id: <20220126142929.625200a7aed435d7e83638e1@kernel.org>
In-Reply-To: <20220125114615.0533446c@gandalf.local.home>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311272945.1933078.2077074421506087620.stgit@devnote2>
        <20220125114615.0533446c@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steve,

Thanks for the review. 
I'll fix the typos.


On Tue, 25 Jan 2022 11:46:15 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > + */
> > +static inline bool is_rethook_trampoline(unsigned long addr)
> > +{
> > +	return addr == (unsigned long)arch_rethook_trampoline;
> 
> Will this work on architectures like PPC that have strange ways of holding
> the function addresses? Or is that what the below fixup handles?

Yes, I'll use dereference_symbol_descriptor().

> > +}
> > +
> > +/* If the architecture needs a fixup the return address, implement it. */
> 
> 	"needs to fixup the"
> 
> > +void arch_rethook_fixup_return(struct pt_regs *regs,
> > +			       unsigned long correct_ret_addr);
> > +
> > +/* Generic trampoline handler, arch code must prepare asm stub */
> > +unsigned long rethook_trampoline_handler(struct pt_regs *regs,
> > +					 unsigned long frame);
> > +
> > +#ifdef CONFIG_RETHOOK
> > +void rethook_flush_task(struct task_struct *tk);
> > +#else
> > +#define rethook_flush_task(tsk)	do { } while (0)
> > +#endif
> > +
> > +#endif
> > +
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 78c351e35fec..2bfabf5355b7 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1473,6 +1473,9 @@ struct task_struct {
> >  #ifdef CONFIG_KRETPROBES
> >  	struct llist_head               kretprobe_instances;
> >  #endif
> > +#ifdef CONFIG_RETHOOK
> > +	struct llist_head               rethooks;
> > +#endif
> >  
> >  #ifdef CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH
> >  	/*
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index f702a6a63686..a39a321c1f37 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -64,6 +64,7 @@
> >  #include <linux/compat.h>
> >  #include <linux/io_uring.h>
> >  #include <linux/kprobes.h>
> > +#include <linux/rethook.h>
> >  
> >  #include <linux/uaccess.h>
> >  #include <asm/unistd.h>
> > @@ -169,6 +170,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
> >  	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
> >  
> >  	kprobe_flush_task(tsk);
> > +	rethook_flush_task(tsk);
> >  	perf_event_delayed_put(tsk);
> >  	trace_sched_process_free(tsk);
> >  	put_task_struct(tsk);
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 3244cc56b697..ffae38be64c4 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2282,6 +2282,9 @@ static __latent_entropy struct task_struct *copy_process(
> >  #ifdef CONFIG_KRETPROBES
> >  	p->kretprobe_instances.first = NULL;
> >  #endif
> > +#ifdef CONFIG_RETHOOK
> > +	p->rethooks.first = NULL;
> > +#endif
> >  
> >  	/*
> >  	 * Ensure that the cgroup subsystem policies allow the new process to be
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 23483dd474b0..4d27e56c6e76 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -10,6 +10,17 @@ config USER_STACKTRACE_SUPPORT
> >  config NOP_TRACER
> >  	bool
> >  
> > +config HAVE_RETHOOK
> > +	bool
> > +
> > +config RETHOOK
> > +	bool
> > +	depends on HAVE_RETHOOK
> > +	help
> > +	  Enable generic return hooking feature. This is an internal
> > +	  API, which will be used by other function-entry hooking
> > +	  feature like fprobe and kprobes.
> 
> 	"features"
> 
> > +
> >  config HAVE_FUNCTION_TRACER
> >  	bool
> >  	help
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index 79255f9de9a4..c6f11a139eac 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -98,6 +98,7 @@ obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
> >  obj-$(CONFIG_BOOTTIME_TRACING) += trace_boot.o
> >  obj-$(CONFIG_FTRACE_RECORD_RECURSION) += trace_recursion_record.o
> >  obj-$(CONFIG_FPROBE) += fprobe.o
> > +obj-$(CONFIG_RETHOOK) += rethook.o
> >  
> >  obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
> >  
> > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > new file mode 100644
> > index 000000000000..76c9848b44a9
> > --- /dev/null
> > +++ b/kernel/trace/rethook.c
> > @@ -0,0 +1,311 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#define pr_fmt(fmt) "rethook: " fmt
> > +
> > +#include <linux/bug.h>
> > +#include <linux/kallsyms.h>
> > +#include <linux/kprobes.h>
> > +#include <linux/preempt.h>
> > +#include <linux/rethook.h>
> > +#include <linux/slab.h>
> > +#include <linux/sort.h>
> > +
> > +/* Return hook list (shadow stack by list) */
> > +
> > +/*
> > + * This function is called from delayed_put_task_struct() when a task is
> > + * dead and cleaned up to recycle any kretprobe instances associated with
> > + * this task. These left over instances represent probed functions that
> > + * have been called but will never return.
> > + */
> > +void rethook_flush_task(struct task_struct *tk)
> > +{
> > +	struct rethook_node *rhn;
> > +	struct llist_node *node;
> > +
> > +	preempt_disable();
> > +
> > +	node = __llist_del_all(&tk->rethooks);
> 
> Hmm, this keeps preemption disabled for the entire walk of the list.
> Can we enable it here, and then just disable it when calling
> rethook_recycle()?

Yes, it is possible.

> > +	while (node) {
> > +		rhn = container_of(node, struct rethook_node, llist);
> > +		node = node->next;
> 
> 		preempt_disable();
> > +		rethook_recycle(rhn);
> 		preempt_enable();
> 
> ? I'm concerned about the latency that this can add on RT tasks.

OK, actually I just followed what the kretprobe does.

[SNIP]
> > +/* This assumes the 'tsk' is the current task or the is not running. */
> 
> 	"or the is not running" ?

Oops, "a task which is not running"

> > +/**
> > + * rethook_find_ret_addr -- Find correct return address modified by rethook
> > + * @tsk: Target task
> > + * @frame: A frame pointer
> > + * @cur: a storage of the loop cursor llist_node pointer for next call
> > + *
> > + * Find the correct return address modified by a rethook on @tsk in unsigned
> > + * long type. If it finds the return address, this returns that address value,
> > + * or this returns 0.
> 
> space
> 
> > + * The @tsk must be 'current' or a task which is not running. @frame is a hint
> 
> How do you know a tsk is not running? How can that be guaranteed?

There is no check yet (I expected to caller ensure it).
I'll add task_is_running() check.

> > + * to get the currect return address - which is compared with the
> > + * rethook::frame field. The @cur is a loop cursor for searching the
> > + * kretprobe return addresses on the @tsk. The '*@cur' should be NULL at the
> > + * first call, but '@cur' itself must NOT NULL.
> 
> I know you state what the return value is above, but it should be stated
> (again) here. As kernel-doc should have a separate section for return
> values:
> 
>  * Returns found address value or zero if not found.

OK.

> 
> > + */
> > +unsigned long rethook_find_ret_addr(struct task_struct *tsk, unsigned long frame,
> > +				    struct llist_node **cur)
> > +{
> > +	struct rethook_node *rhn = NULL;
> > +	unsigned long ret;
> > +
> > +	if (WARN_ON_ONCE(!cur))
> > +		return 0;
> > +
> > +	do {
> > +		ret = __rethook_find_ret_addr(tsk, cur);
> > +		if (!ret)
> > +			break;
> > +		rhn = container_of(*cur, struct rethook_node, llist);
> > +	} while (rhn->frame != frame);
> > +
> > +	return ret;
> > +}
> 

Thank you!

> -- Steve
> 
> 
> > +NOKPROBE_SYMBOL(rethook_find_ret_addr);
> > +
> > +void __weak arch_rethook_fixup_return(struct pt_regs *regs,
> > +				      unsigned long correct_ret_addr)
> > +{
> > +	/*
> > +	 * Do nothing by default. If the architecture which uses a
> > +	 * frame pointer to record real return address on the stack,
> > +	 * it should fill this function to fixup the return address
> > +	 * so that stacktrace works from the rethook handler.
> > +	 */
> > +}
> > +
> > +/* This function will be called from each arch-defined trampoline. */
> > +unsigned long rethook_trampoline_handler(struct pt_regs *regs,
> > +					 unsigned long frame)
> > +{
> > +	struct llist_node *first, *node = NULL;
> > +	unsigned long correct_ret_addr;
> > +	rethook_handler_t handler;
> > +	struct rethook_node *rhn;
> > +
> > +	correct_ret_addr = __rethook_find_ret_addr(current, &node);
> > +	if (!correct_ret_addr) {
> > +		pr_err("rethook: Return address not found! Maybe there is a bug in the kernel\n");
> > +		BUG_ON(1);
> > +	}
> > +
> > +	instruction_pointer_set(regs, correct_ret_addr);
> > +
> > +	/*
> > +	 * These loops must be protected from rethook_free_rcu() because those
> > +	 * are accessing 'rhn->rethook'.
> > +	 */
> > +	preempt_disable();
> > +
> > +	/*
> > +	 * Run the handler on the shadow stack. Do not unlink the list here because
> > +	 * stackdump inside the handlers needs to decode it.
> > +	 */
> > +	first = current->rethooks.first;
> > +	while (first) {
> > +		rhn = container_of(first, struct rethook_node, llist);
> > +		if (WARN_ON_ONCE(rhn->frame != frame))
> > +			break;
> > +		handler = READ_ONCE(rhn->rethook->handler);
> > +		if (handler)
> > +			handler(rhn, rhn->rethook->data, regs);
> > +
> > +		if (first == node)
> > +			break;
> > +		first = first->next;
> > +	}
> > +
> > +	/* Fixup registers for returning to correct address. */
> > +	arch_rethook_fixup_return(regs, correct_ret_addr);
> > +
> > +	/* Unlink used shadow stack */
> > +	first = current->rethooks.first;
> > +	current->rethooks.first = node->next;
> > +	node->next = NULL;
> > +
> > +	while (first) {
> > +		rhn = container_of(first, struct rethook_node, llist);
> > +		first = first->next;
> > +		rethook_recycle(rhn);
> > +	}
> > +	preempt_enable();
> > +
> > +	return correct_ret_addr;
> > +}
> > +NOKPROBE_SYMBOL(rethook_trampoline_handler);
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
