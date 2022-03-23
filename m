Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799BB4E4DC0
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbiCWIHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiCWIHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:07:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C943B70F7D;
        Wed, 23 Mar 2022 01:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LEsbLTCobIra7Sk/dIaIRoBCRQ7K69SIvLYNzsU8sxk=; b=E6K1ZYRln+QCfhwJr1dNeYDuB4
        lkWOpeUo120/1k0r28ad+wzCaZFnEqyUGZZgPYmXU8clSpES920R5Y3JFSBktMxDiLrdezidkX9Oe
        vVbCxyAdAZWF9reVZZ6cZSMbWPr4OJZMyBZxBVNx92AfRVtlrB12CfLT7Hek63FINclRtQYY5+Ice
        Vv3vohSWr3RlSuoi4fwtwoBRl4XhiJtJqVT0koE/WQgghRXgoL2wuUz/0qCg5qKE6O6g4hXGqy0r0
        PYo7GjZcAuBOkl58vNsGJTYiltVzvOM976XVQRWG4B2V9LSHg90SPJkB5Blo1OAXSALxOeuEJE4lI
        2B1WhYgA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nWvzm-00CLRW-0x; Wed, 23 Mar 2022 08:05:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C507430007E;
        Wed, 23 Mar 2022 09:05:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 79FF729A6CAA0; Wed, 23 Mar 2022 09:05:26 +0100 (CET)
Date:   Wed, 23 Mar 2022 09:05:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
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
Message-ID: <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
 <164800289923.1716332.9772144337267953560.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164800289923.1716332.9772144337267953560.stgit@devnote2>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 11:34:59AM +0900, Masami Hiramatsu wrote:
> Add rethook for x86 implementation. Most of the code has been copied from
> kretprobes on x86.

Right; as said, I'm really unhappy with growing a carbon copy of this
stuff instead of sharing. Can we *please* keep it a single instance?
Them being basically indentical, it should be trivial to have
CONFIG_KPROBE_ON_RETHOOK (or somesuch) and just share this.

Also, what's rethook for anyway?

> diff --git a/arch/x86/kernel/kprobes/common.h b/arch/x86/kernel/kprobes/common.h
> index 7d3a2e2daf01..c993521d4933 100644
> --- a/arch/x86/kernel/kprobes/common.h
> +++ b/arch/x86/kernel/kprobes/common.h
> @@ -6,6 +6,7 @@
>  
>  #include <asm/asm.h>
>  #include <asm/frame.h>
> +#include <asm/insn.h>
>  
>  #ifdef CONFIG_X86_64
>  
> diff --git a/arch/x86/kernel/rethook.c b/arch/x86/kernel/rethook.c
> new file mode 100644
> index 000000000000..3e916361c33b
> --- /dev/null
> +++ b/arch/x86/kernel/rethook.c
> @@ -0,0 +1,121 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * x86 implementation of rethook. Mostly copied from arch/x86/kernel/kprobes/core.c.
> + */
> +#include <linux/bug.h>
> +#include <linux/rethook.h>
> +#include <linux/kprobes.h>
> +#include <linux/objtool.h>
> +
> +#include "kprobes/common.h"
> +
> +__visible void arch_rethook_trampoline_callback(struct pt_regs *regs);
> +
> +/*
> + * When a target function returns, this code saves registers and calls
> + * arch_rethook_trampoline_callback(), which calls the rethook handler.
> + */
> +asm(
> +	".text\n"
> +	".global arch_rethook_trampoline\n"
> +	".type arch_rethook_trampoline, @function\n"
> +	"arch_rethook_trampoline:\n"
> +#ifdef CONFIG_X86_64
> +	ANNOTATE_NOENDBR	/* This is only jumped from ret instruction */
> +	/* Push a fake return address to tell the unwinder it's a kretprobe. */
> +	"	pushq $arch_rethook_trampoline\n"
> +	UNWIND_HINT_FUNC
	"	pushq $" __stringify(__KERNEL_DS) "\n" /* %ss */
	/* Save the 'sp - 16', this will be fixed later. */
> +	"	pushq %rsp\n"
> +	"	pushfq\n"
> +	SAVE_REGS_STRING
> +	"	movq %rsp, %rdi\n"
> +	"	call arch_rethook_trampoline_callback\n"
> +	RESTORE_REGS_STRING
	/* In the callback function, 'regs->flags' is copied to 'regs->ss'. */

	this comment could do with a 'why' though... Because neither
	this nor the one in the handler really explains why it is
	important to have popf last

	"	addq $16, %rsp\n"
> +	"	popfq\n"
> +#else

same for i386:

> +	/* Push a fake return address to tell the unwinder it's a kretprobe. */
> +	"	pushl $arch_rethook_trampoline\n"
> +	UNWIND_HINT_FUNC
	/* Save the 'sp - 8', this will be fixed later. */
	"	pushl %ss\n"
> +	"	pushl %esp\n"
> +	"	pushfl\n"
> +	SAVE_REGS_STRING
> +	"	movl %esp, %eax\n"
> +	"	call arch_rethook_trampoline_callback\n"
> +	RESTORE_REGS_STRING
	/* In the callback function, 'regs->flags' is copied to 'regs->ss'. */
	"	addl $8, %esp\n"
> +	"	popfl\n"
> +#endif
> +	ASM_RET
> +	".size arch_rethook_trampoline, .-arch_rethook_trampoline\n"
> +);
> +NOKPROBE_SYMBOL(arch_rethook_trampoline);
> +
> +/*
> + * Called from arch_rethook_trampoline
> + */
> +__used __visible void arch_rethook_trampoline_callback(struct pt_regs *regs)
> +{
> +	unsigned long *frame_pointer;
> +
> +	/* fixup registers */
> +	regs->cs = __KERNEL_CS;
> +#ifdef CONFIG_X86_32
> +	regs->gs = 0;
> +#endif
> +	regs->ip = (unsigned long)&arch_rethook_trampoline;
> +	regs->orig_ax = ~0UL;
	regs->sp += 2*sizeof(long);
> +	frame_pointer = &regs->sp + 1;
> +
> +	/*
> +	 * The return address at 'frame_pointer' is recovered by the
> +	 * arch_rethook_fixup_return() which called from this
> +	 * rethook_trampoline_handler().
> +	 */
> +	rethook_trampoline_handler(regs, (unsigned long)frame_pointer);
> +
> +	/*
> +	 * Copy FLAGS to 'pt_regs::sp' so that arch_rethook_trapmoline()
> +	 * can do RET right after POPF.
> +	 */
	regs->ss = regs->flags;
> +}
> +NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);
