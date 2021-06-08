Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5E63A001C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 20:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhFHSkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbhFHSit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:38:49 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EA5C061787;
        Tue,  8 Jun 2021 11:36:10 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id g38so31587042ybi.12;
        Tue, 08 Jun 2021 11:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nEbFbKoLutEn8LPv4kWiYSYfRvwWro+B0p6xeT8GQko=;
        b=gHwxAJsOtg3gePVeCFOJQ/TsUr6xM9Il3WMFQoab/M52pIZsbOAfeb7ZN2t/8R+r16
         tH8IAUmdm/VhiuvMg/GnoJ+iuxPyc34JAHKv0rgnxgDIo9DU9u/S1nY+QuzD3CxSyx/v
         N5clK40euQH+KqXz7TvsAQ3tUzDoj7d2mjJ0r0Zlg1B2mO1l5gkrcu3+lPF/s3Tox1O7
         Jze3aDfchX+BnNf4VIUq5g6HI/imsxl9rVWkM1BYp9pisRTd+R6hWzd+N0ovKU55DDfh
         lMSaIQC1ImeAiHAU5lyrLHBa6FnZxvJkF3qaYT4rqrn0dG0N2H/pNfYuk3m4K2eBSQlP
         OckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nEbFbKoLutEn8LPv4kWiYSYfRvwWro+B0p6xeT8GQko=;
        b=K/cTM+QBE28jiAelIbf11ZGOSEzuI4TN/pjzuqwO/NtAVkIQ5pVpXPGY+K/V3nOzTK
         lzsZsoa3hMe5hNt3vyF9+BpPF6R/FR6wyStn7wnpOMerfVDS1x+BQvnep+0Xxu6pP7cL
         439ovXrvr/nJRbOL99Qe5LtQ23O8G7wwI9m+WoLwTydsFPrkGDiYTjHYSl44lH7pDpNF
         fV4FXUnOueoulSBYOt6DHGju0qNXsvK9ghQz69CUqOzsMBLlnZ6gxdNx77yZtne2hHjk
         4amsfH9R7tpR7MpY/lYWINMoLb4cBUqv+SFnTg6LKtC6eXCNN3OssCGlzpz7W+mFfN7Y
         iWgg==
X-Gm-Message-State: AOAM532XNUsmQdTSE7aYyffqBqa8Dgx6/ZpG+bO3HPx0eSJm98wFFEzK
        pzdQ8A49NZvL8L7rea01AfMSo+ou95yXRyrUIUkSmPQDmrJPlA==
X-Google-Smtp-Source: ABdhPJygS9vn63UFJsAIyrL29SplfcaIPdp4fehiUVOzrVqtF3WOOB07K9ZcCC7iJT3IKsEc2KckIMJe4jr8SoYHyEw=
X-Received: by 2002:a25:1455:: with SMTP id 82mr33506361ybu.403.1623177369441;
 Tue, 08 Jun 2021 11:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <20210605111034.1810858-4-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Jun 2021 11:35:58 -0700
Message-ID: <CAEf4BzY5ngJz_=e2wnqG7yB996xdQAPCBfz3_4mB9P2N-1RoCw@mail.gmail.com>
Subject: Re: [PATCH 03/19] x86/ftrace: Make function graph use ftrace directly
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 4:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>
> We don't need special hook for graph tracer entry point,
> but instead we can use graph_ops::func function to install
> the return_hooker.
>
> This moves the graph tracing setup _before_ the direct
> trampoline prepares the stack, so the return_hooker will
> be called when the direct trampoline is finished.
>
> This simplifies the code, because we don't need to take into
> account the direct trampoline setup when preparing the graph
> tracer hooker and we can allow function graph tracer on entries
> registered with direct trampoline.
>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  arch/x86/include/asm/ftrace.h |  9 +++++++--
>  arch/x86/kernel/ftrace.c      | 37 ++++++++++++++++++++++++++++++++---
>  arch/x86/kernel/ftrace_64.S   | 29 +--------------------------
>  include/linux/ftrace.h        |  6 ++++++
>  kernel/trace/fgraph.c         |  8 +++++---
>  5 files changed, 53 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index 9f3130f40807..024d9797646e 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -57,6 +57,13 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
>
>  #define ftrace_instruction_pointer_set(fregs, _ip)     \
>         do { (fregs)->regs.ip = (_ip); } while (0)
> +
> +struct ftrace_ops;
> +#define ftrace_graph_func ftrace_graph_func
> +void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
> +                      struct ftrace_ops *op, struct ftrace_regs *fregs);
> +#else
> +#define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
>  #endif
>
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -65,8 +72,6 @@ struct dyn_arch_ftrace {
>         /* No extra data needed for x86 */
>  };
>
> -#define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
> -
>  #endif /*  CONFIG_DYNAMIC_FTRACE */
>  #endif /* __ASSEMBLY__ */
>  #endif /* CONFIG_FUNCTION_TRACER */
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index c555624da989..804fcc6ef2c7 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -527,7 +527,7 @@ static void *addr_from_call(void *ptr)
>         return ptr + CALL_INSN_SIZE + call.disp;
>  }
>
> -void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
> +void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
>                            unsigned long frame_pointer);
>
>  /*
> @@ -541,7 +541,8 @@ static void *static_tramp_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
>         void *ptr;
>
>         if (ops && ops->trampoline) {
> -#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +#if !defined(CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS) && \
> +       defined(CONFIG_FUNCTION_GRAPH_TRACER)
>                 /*
>                  * We only know about function graph tracer setting as static
>                  * trampoline.
> @@ -589,8 +590,9 @@ void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>
>  #ifdef CONFIG_DYNAMIC_FTRACE
> -extern void ftrace_graph_call(void);
>
> +#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
> +extern void ftrace_graph_call(void);
>  static const char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
>  {
>         return text_gen_insn(JMP32_INSN_OPCODE, (void *)ip, (void *)addr);
> @@ -618,7 +620,17 @@ int ftrace_disable_ftrace_graph_caller(void)
>
>         return ftrace_mod_jmp(ip, &ftrace_stub);
>  }
> +#else /* !CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS */
> +int ftrace_enable_ftrace_graph_caller(void)
> +{
> +       return 0;
> +}
>
> +int ftrace_disable_ftrace_graph_caller(void)
> +{
> +       return 0;
> +}
> +#endif /* CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS */
>  #endif /* !CONFIG_DYNAMIC_FTRACE */
>
>  /*
> @@ -629,6 +641,7 @@ void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
>                            unsigned long frame_pointer)
>  {
>         unsigned long return_hooker = (unsigned long)&return_to_handler;
> +       int bit;
>
>         /*
>          * When resuming from suspend-to-ram, this function can be indirectly
> @@ -648,7 +661,25 @@ void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
>         if (unlikely(atomic_read(&current->tracing_graph_pause)))
>                 return;
>
> +       bit = ftrace_test_recursion_trylock(ip, *parent);
> +       if (bit < 0)
> +               return;
> +
>         if (!function_graph_enter(*parent, ip, frame_pointer, parent))
>                 *parent = return_hooker;
> +
> +       ftrace_test_recursion_unlock(bit);
> +}
> +
> +#ifdef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
> +void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
> +                      struct ftrace_ops *op, struct ftrace_regs *fregs)
> +{
> +       struct pt_regs *regs = &fregs->regs;
> +       unsigned long *stack = (unsigned long *)kernel_stack_pointer(regs);
> +
> +       prepare_ftrace_return(ip, (unsigned long *)stack, 0);
>  }
> +#endif
> +
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
> index a8eb084a7a9a..7a879901f103 100644
> --- a/arch/x86/kernel/ftrace_64.S
> +++ b/arch/x86/kernel/ftrace_64.S
> @@ -174,11 +174,6 @@ SYM_INNER_LABEL(ftrace_caller_end, SYM_L_GLOBAL)
>  SYM_FUNC_END(ftrace_caller);
>
>  SYM_FUNC_START(ftrace_epilogue)
> -#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
> -       jmp ftrace_stub
> -#endif
> -
>  /*
>   * This is weak to keep gas from relaxing the jumps.
>   * It is also used to copy the retq for trampolines.
> @@ -288,15 +283,6 @@ SYM_FUNC_START(__fentry__)
>         cmpq $ftrace_stub, ftrace_trace_function
>         jnz trace
>
> -fgraph_trace:
> -#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -       cmpq $ftrace_stub, ftrace_graph_return
> -       jnz ftrace_graph_caller
> -
> -       cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
> -       jnz ftrace_graph_caller
> -#endif
> -
>  SYM_INNER_LABEL(ftrace_stub, SYM_L_GLOBAL)
>         retq
>
> @@ -314,25 +300,12 @@ trace:
>         CALL_NOSPEC r8
>         restore_mcount_regs
>
> -       jmp fgraph_trace
> +       jmp ftrace_stub
>  SYM_FUNC_END(__fentry__)
>  EXPORT_SYMBOL(__fentry__)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> -SYM_FUNC_START(ftrace_graph_caller)
> -       /* Saves rbp into %rdx and fills first parameter  */
> -       save_mcount_regs
> -
> -       leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
> -       movq $0, %rdx   /* No framepointers needed */
> -       call    prepare_ftrace_return
> -
> -       restore_mcount_regs
> -
> -       retq
> -SYM_FUNC_END(ftrace_graph_caller)
> -
>  SYM_FUNC_START(return_to_handler)
>         subq  $24, %rsp
>
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index a69f363b61bf..40b493908f09 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -614,6 +614,12 @@ void ftrace_modify_all_code(int command);
>  extern void ftrace_graph_caller(void);
>  extern int ftrace_enable_ftrace_graph_caller(void);
>  extern int ftrace_disable_ftrace_graph_caller(void);
> +#ifndef ftrace_graph_func
> +#define ftrace_graph_func ftrace_stub
> +#define FTRACE_OPS_GRAPH_STUB | FTRACE_OPS_FL_STUB
> +#else
> +#define FTRACE_OPS_GRAPH_STUB
> +#endif
>  #else
>  static inline int ftrace_enable_ftrace_graph_caller(void) { return 0; }
>  static inline int ftrace_disable_ftrace_graph_caller(void) { return 0; }
> diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
> index b8a0d1d564fb..58e96b45e9da 100644
> --- a/kernel/trace/fgraph.c
> +++ b/kernel/trace/fgraph.c
> @@ -115,6 +115,7 @@ int function_graph_enter(unsigned long ret, unsigned long func,
>  {
>         struct ftrace_graph_ent trace;
>
> +#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
>         /*
>          * Skip graph tracing if the return location is served by direct trampoline,
>          * since call sequence and return addresses are unpredictable anyway.
> @@ -124,6 +125,7 @@ int function_graph_enter(unsigned long ret, unsigned long func,
>         if (ftrace_direct_func_count &&
>             ftrace_find_rec_direct(ret - MCOUNT_INSN_SIZE))
>                 return -EBUSY;
> +#endif
>         trace.func = func;
>         trace.depth = ++current->curr_ret_depth;
>
> @@ -333,10 +335,10 @@ unsigned long ftrace_graph_ret_addr(struct task_struct *task, int *idx,
>  #endif /* HAVE_FUNCTION_GRAPH_RET_ADDR_PTR */
>
>  static struct ftrace_ops graph_ops = {
> -       .func                   = ftrace_stub,
> +       .func                   = ftrace_graph_func,
>         .flags                  = FTRACE_OPS_FL_INITIALIZED |
> -                                  FTRACE_OPS_FL_PID |
> -                                  FTRACE_OPS_FL_STUB,
> +                                  FTRACE_OPS_FL_PID
> +                                  FTRACE_OPS_GRAPH_STUB,

nit: this looks so weird... Why not define FTRACE_OPS_GRAPH_STUB as
zero in case of #ifdef ftrace_graph_func? Then it will be natural and
correctly looking | FTRACE_OPS_GRAPH_STUB?

>  #ifdef FTRACE_GRAPH_TRAMP_ADDR
>         .trampoline             = FTRACE_GRAPH_TRAMP_ADDR,
>         /* trampoline_size is only needed for dynamically allocated tramps */
> --
> 2.31.1
>
