Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30034E5173
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbiCWLm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbiCWLm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:42:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9815D37BFA;
        Wed, 23 Mar 2022 04:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47102B81E82;
        Wed, 23 Mar 2022 11:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AA3C340F2;
        Wed, 23 Mar 2022 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648035684;
        bh=amaOJDMqlU6j5AYUcANyJsWQwz0U/gFnRSPTa2zv0B0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=swO655H13VikFZsLI8GzgV2pXjhlsYW8CffaDxlPLFaQNq8YgnTgUIe0vrdaDjhW6
         gyxA9gpoM8BrjOFmzsGWXECzLp+8pFTjAdtafQqD+HHlP77APs3lO2drBfjzsSO5br
         Oc4aORE90aPAABx46rFVsiWe/2mCMS/LD3WmvDyiETW/sIvP7bM7uuoOHnTmn1mSKe
         QU+ycj6Ny0JhHdYis1qnaVOwLSJiVTAsqXmwufpkt4ZEL3zKr10cukPzs5VT6LIDDu
         WmgBjitpVODuKhGpP3z5yRLZaatqAogzE7oNs6orRZv5RVJmcny1bDjOUepPDlJYOf
         FnQG3pYLWO+8w==
Date:   Wed, 23 Mar 2022 20:41:19 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v13 bpf-next 1/1] rethook: x86: Add rethook x86
 implementation
Message-Id: <20220323204119.1feac1af0a1d58b8e63acd5d@kernel.org>
In-Reply-To: <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
        <164800289923.1716332.9772144337267953560.stgit@devnote2>
        <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 09:05:26 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 23, 2022 at 11:34:59AM +0900, Masami Hiramatsu wrote:
> > Add rethook for x86 implementation. Most of the code has been copied from
> > kretprobes on x86.
> 
> Right; as said, I'm really unhappy with growing a carbon copy of this
> stuff instead of sharing. Can we *please* keep it a single instance?

OK, then let me update the kprobe side too.

> Them being basically indentical, it should be trivial to have
> CONFIG_KPROBE_ON_RETHOOK (or somesuch) and just share this.

Yes, ideally it should use CONFIG_HAVE_RETHOOK since the rethook arch port
must be a copy of the kretprobe implementation. But for safety, I think
having CONFIG_KPROBE_ON_RETHOOK is a good idea until replacing all kretprobe
implementations.

> 
> Also, what's rethook for anyway?

Rethook is a feature which hooks the function return. Most of the
logic came from the kretprobe. Simply to say, 'kretprobe - kprobe' is 
the rethook :)

Thank you,

> 
> > diff --git a/arch/x86/kernel/kprobes/common.h b/arch/x86/kernel/kprobes/common.h
> > index 7d3a2e2daf01..c993521d4933 100644
> > --- a/arch/x86/kernel/kprobes/common.h
> > +++ b/arch/x86/kernel/kprobes/common.h
> > @@ -6,6 +6,7 @@
> >  
> >  #include <asm/asm.h>
> >  #include <asm/frame.h>
> > +#include <asm/insn.h>
> >  
> >  #ifdef CONFIG_X86_64
> >  
> > diff --git a/arch/x86/kernel/rethook.c b/arch/x86/kernel/rethook.c
> > new file mode 100644
> > index 000000000000..3e916361c33b
> > --- /dev/null
> > +++ b/arch/x86/kernel/rethook.c
> > @@ -0,0 +1,121 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * x86 implementation of rethook. Mostly copied from arch/x86/kernel/kprobes/core.c.
> > + */
> > +#include <linux/bug.h>
> > +#include <linux/rethook.h>
> > +#include <linux/kprobes.h>
> > +#include <linux/objtool.h>
> > +
> > +#include "kprobes/common.h"
> > +
> > +__visible void arch_rethook_trampoline_callback(struct pt_regs *regs);
> > +
> > +/*
> > + * When a target function returns, this code saves registers and calls
> > + * arch_rethook_trampoline_callback(), which calls the rethook handler.
> > + */
> > +asm(
> > +	".text\n"
> > +	".global arch_rethook_trampoline\n"
> > +	".type arch_rethook_trampoline, @function\n"
> > +	"arch_rethook_trampoline:\n"
> > +#ifdef CONFIG_X86_64
> > +	ANNOTATE_NOENDBR	/* This is only jumped from ret instruction */
> > +	/* Push a fake return address to tell the unwinder it's a kretprobe. */
> > +	"	pushq $arch_rethook_trampoline\n"
> > +	UNWIND_HINT_FUNC
> 	"	pushq $" __stringify(__KERNEL_DS) "\n" /* %ss */
> 	/* Save the 'sp - 16', this will be fixed later. */
> > +	"	pushq %rsp\n"
> > +	"	pushfq\n"
> > +	SAVE_REGS_STRING
> > +	"	movq %rsp, %rdi\n"
> > +	"	call arch_rethook_trampoline_callback\n"
> > +	RESTORE_REGS_STRING
> 	/* In the callback function, 'regs->flags' is copied to 'regs->ss'. */
> 
> 	this comment could do with a 'why' though... Because neither
> 	this nor the one in the handler really explains why it is
> 	important to have popf last
> 
> 	"	addq $16, %rsp\n"
> > +	"	popfq\n"
> > +#else
> 
> same for i386:
> 
> > +	/* Push a fake return address to tell the unwinder it's a kretprobe. */
> > +	"	pushl $arch_rethook_trampoline\n"
> > +	UNWIND_HINT_FUNC
> 	/* Save the 'sp - 8', this will be fixed later. */
> 	"	pushl %ss\n"
> > +	"	pushl %esp\n"
> > +	"	pushfl\n"
> > +	SAVE_REGS_STRING
> > +	"	movl %esp, %eax\n"
> > +	"	call arch_rethook_trampoline_callback\n"
> > +	RESTORE_REGS_STRING
> 	/* In the callback function, 'regs->flags' is copied to 'regs->ss'. */
> 	"	addl $8, %esp\n"
> > +	"	popfl\n"
> > +#endif
> > +	ASM_RET
> > +	".size arch_rethook_trampoline, .-arch_rethook_trampoline\n"
> > +);
> > +NOKPROBE_SYMBOL(arch_rethook_trampoline);
> > +
> > +/*
> > + * Called from arch_rethook_trampoline
> > + */
> > +__used __visible void arch_rethook_trampoline_callback(struct pt_regs *regs)
> > +{
> > +	unsigned long *frame_pointer;
> > +
> > +	/* fixup registers */
> > +	regs->cs = __KERNEL_CS;
> > +#ifdef CONFIG_X86_32
> > +	regs->gs = 0;
> > +#endif
> > +	regs->ip = (unsigned long)&arch_rethook_trampoline;
> > +	regs->orig_ax = ~0UL;
> 	regs->sp += 2*sizeof(long);
> > +	frame_pointer = &regs->sp + 1;
> > +
> > +	/*
> > +	 * The return address at 'frame_pointer' is recovered by the
> > +	 * arch_rethook_fixup_return() which called from this
> > +	 * rethook_trampoline_handler().
> > +	 */
> > +	rethook_trampoline_handler(regs, (unsigned long)frame_pointer);
> > +
> > +	/*
> > +	 * Copy FLAGS to 'pt_regs::sp' so that arch_rethook_trapmoline()
> > +	 * can do RET right after POPF.
> > +	 */
> 	regs->ss = regs->flags;
> > +}
> > +NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);


-- 
Masami Hiramatsu <mhiramat@kernel.org>
