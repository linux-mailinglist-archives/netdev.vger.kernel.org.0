Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F5296984
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372087AbgJWGJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:09:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S372084AbgJWGJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 02:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603433388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zGJQY3faBMeBh5Flht/aTwSLFqDOtybmBW+jtQJn154=;
        b=Opd9IXO6UXcmYtUmZ9pxqmhm0OLQuH+XgdHrWWn5k+EmGgAme1+Jv68Rr72OPZIeG0/ndT
        9r/lFM2ABRGeGFb3dnjwECnNX3Vz1sZWACb1h0cDLx8ZTwOwUmdyqvk9YvxIAK2Z48qMoU
        cdR76aCO2SjKB3eWn+c/EH+CRvy6F0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-qsg3ILdSPHGjtdew-D_ztQ-1; Fri, 23 Oct 2020 02:09:44 -0400
X-MC-Unique: qsg3ILdSPHGjtdew-D_ztQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C79B8192AB94;
        Fri, 23 Oct 2020 06:09:37 +0000 (UTC)
Received: from krava (unknown [10.40.192.63])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6CE4360C84;
        Fri, 23 Oct 2020 06:09:33 +0000 (UTC)
Date:   Fri, 23 Oct 2020 08:09:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201023060932.GF2332608@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
 <20201022141154.GB2332608@krava>
 <20201022104205.728dd135@gandalf.local.home>
 <20201022122150.45e81da0@gandalf.local.home>
 <20201022165229.34cd5141@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022165229.34cd5141@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 04:52:29PM -0400, Steven Rostedt wrote:
> On Thu, 22 Oct 2020 12:21:50 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 22 Oct 2020 10:42:05 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > I'd like to see how batch functions will work. I guess I need to start
> > > looking at the bpf trampoline, to see if we can modify the ftrace
> > > trampoline to have a quick access to parameters. It would be much more
> > > beneficial to update the existing generic function tracer to have access to
> > > function parameters that all users could benefit from, than to tweak a
> > > single use case into giving this feature to a single user.  
> > 
> > Looking at the creation of the bpf trampoline, I think I can modify ftrace
> > to have a more flexible callback. Something that passes the callback the
> > following:
> > 
> >  the function being traced.
> >  a pointer to the parent caller (that could be modified)
> >  a pointer to the original stack frame (what the stack was when the
> >       function is entered)
> >  An array of the arguments of the function (which could also be modified)
> > 
> > This is a change I've been wanting to make for some time, because it would
> > allow function graph to be a user of function tracer, and would give
> > everything access to the arguments.
> > 
> > We would still need a helper function to store all regs to keep kprobes
> > working unmodified, but this would still only be done if asked.
> > 
> > The above change shouldn't hurt performance for either ftrace or bpf
> > because it appears they both do the same. If BPF wants to have a batch
> > processing of functions, then I think we should modify ftrace to do this
> > new approach instead of creating another set of function trampolines.
> 
> The below is a quick proof of concept patch I whipped up. It will always
> save 6 arguments, so if BPF is really interested in just saving the bare
> minimum of arguments before calling, it can still use direct. But if you
> are going to have a generic callback, you'll need to save all parameters
> otherwise you can corrupt the function's parameter if traced function uses
> more than you save.

nice, I'll take a look, thanks for quick code ;-)

> 
> Which looking at the bpf trampoline code, I noticed that if the verifier
> can't find the btf func, it falls back to saving 5 parameters. Which can be
> a bug on x86 if the function itself uses 6 or more. If you only save 5
> parameters, then call a bpf program that calls a helper function that uses
> more than 5 parameters, it will likely corrupt the 6th parameter of the
> function being traced.

number of args from eBPF program to in-kernel function is
restricted to 5, so we should be fine

> 
> The code in question is this:
> 
> int btf_distill_func_proto(struct bpf_verifier_log *log,
> 			   struct btf *btf,
> 			   const struct btf_type *func,
> 			   const char *tname,
> 			   struct btf_func_model *m)
> {
> 	const struct btf_param *args;
> 	const struct btf_type *t;
> 	u32 i, nargs;
> 	int ret;
> 
> 	if (!func) {
> 		/* BTF function prototype doesn't match the verifier types.
> 		 * Fall back to 5 u64 args.
> 		 */
> 		for (i = 0; i < 5; i++)
> 			m->arg_size[i] = 8;
> 		m->ret_size = 8;
> 		m->nr_args = 5;
> 		return 0;
> 	}
> 
> Shouldn't it be falling back to 6, not 5?

but looks like this actualy could fallback to 6, jit would
allow that, but I'm not sure if there's another restriction

thanks,
jirka

> 
> -- Steve
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 7edbd5ee5ed4..b65d73f430ed 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -287,6 +287,10 @@ extern void ftrace_caller_end(void);
>  extern void ftrace_caller_op_ptr(void);
>  extern void ftrace_regs_caller_op_ptr(void);
>  extern void ftrace_regs_caller_jmp(void);
> +extern void ftrace_args_caller(void);
> +extern void ftrace_args_call(void);
> +extern void ftrace_args_caller_end(void);
> +extern void ftrace_args_caller_op_ptr(void);
>  
>  /* movq function_trace_op(%rip), %rdx */
>  /* 0x48 0x8b 0x15 <offset-to-ftrace_trace_op (4 bytes)> */
> @@ -317,7 +321,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  	unsigned long end_offset;
>  	unsigned long op_offset;
>  	unsigned long call_offset;
> -	unsigned long jmp_offset;
> +	unsigned long jmp_offset = 0;
>  	unsigned long offset;
>  	unsigned long npages;
>  	unsigned long size;
> @@ -336,12 +340,16 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
>  		op_offset = (unsigned long)ftrace_regs_caller_op_ptr;
>  		call_offset = (unsigned long)ftrace_regs_call;
>  		jmp_offset = (unsigned long)ftrace_regs_caller_jmp;
> +	} else if (ops->flags & FTRACE_OPS_FL_ARGS) {
> +		start_offset = (unsigned long)ftrace_args_caller;
> +		end_offset = (unsigned long)ftrace_args_caller_end;
> +		op_offset = (unsigned long)ftrace_args_caller_op_ptr;
> +		call_offset = (unsigned long)ftrace_args_call;
>  	} else {
>  		start_offset = (unsigned long)ftrace_caller;
>  		end_offset = (unsigned long)ftrace_caller_end;
>  		op_offset = (unsigned long)ftrace_caller_op_ptr;
>  		call_offset = (unsigned long)ftrace_call;
> -		jmp_offset = 0;
>  	}
>  
>  	size = end_offset - start_offset;
> diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
> index ac3d5f22fe64..65ca634d0b37 100644
> --- a/arch/x86/kernel/ftrace_64.S
> +++ b/arch/x86/kernel/ftrace_64.S
> @@ -176,6 +176,58 @@ SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
>  	retq
>  SYM_FUNC_END(ftrace_epilogue)
>  
> +SYM_FUNC_START(ftrace_args_caller)
> +#ifdef CONFIG_FRAME_POINTER
> +	push %rdp
> +	movq %rsp %rdp
> +# define CALLED_OFFEST (7 * 8)
> +# define PARENT_OFFSET (8 * 8)
> +#else
> +# define CALLED_OFFSET (6 * 8)
> +# define PARENT_OFFSET (7 * 8)
> +#endif
> +	/* save args */
> +	pushq %r9
> +	pushq %r8
> +	pushq %rcx
> +	pushq %rdx
> +	pushq %rsi
> +	pushq %rdi
> +
> +	/*
> +	 * Parameters:
> +	 *   Called site (function called)
> +	 *   Address of parent location
> +	 *   pointer to ftrace_ops
> +	 *   Location of stack when function was called
> +	 *   Array of arguments.
> +	 */
> +	movq CALLED_OFFSET(%rsp), %rdi
> +	leaq PARENT_OFFSET(%rsp), %rsi
> +SYM_INNER_LABEL(ftrace_args_caller_op_ptr, SYM_L_GLOBAL)
> +	/* Load the ftrace_ops into the 3rd parameter */
> +	movq function_trace_op(%rip), %rdx
> +	movq %rsi, %rcx
> +	leaq 0(%rsp), %r8
> +
> +SYM_INNER_LABEL(ftrace_args_call, SYM_L_GLOBAL)
> +	callq ftrace_stub
> +
> +	popq %rdi
> +	popq %rsi
> +	popq %rdx
> +	popq %rcx
> +	popq %r8
> +	popq %r9
> +
> +#ifdef CONFIG_FRAME_POINTER
> +	popq %rdp
> +#endif
> +
> +SYM_INNER_LABEL(ftrace_args_caller_end, SYM_L_GLOBAL)
> +	jmp ftrace_epilogue
> +SYM_FUNC_END(ftrace_args_caller)
> +
>  SYM_FUNC_START(ftrace_regs_caller)
>  	/* Save the current flags before any operations that can change them */
>  	pushfq
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 1bd3a0356ae4..0d077e8d7bb4 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -92,6 +92,17 @@ struct ftrace_ops;
>  typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
>  			      struct ftrace_ops *op, struct pt_regs *regs);
>  
> +typedef void (*ftrace_args_func_t)(unsigned long ip, unsigned long *parent_ip,
> +				   struct ftrace_ops *op, unsigned long *stack,
> +				   unsigned long *args);
> +
> +union ftrace_callback {
> +	ftrace_func_t		func;
> +	ftrace_args_func_t	args_func;
> +};
> +
> +typedef union ftrace_callback ftrace_callback_t;
> +
>  ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>  
>  /*
> @@ -169,6 +180,7 @@ enum {
>  	FTRACE_OPS_FL_TRACE_ARRAY		= BIT(15),
>  	FTRACE_OPS_FL_PERMANENT                 = BIT(16),
>  	FTRACE_OPS_FL_DIRECT			= BIT(17),
> +	FTRACE_OPS_FL_ARGS			= BIT(18),
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -447,9 +459,11 @@ enum {
>  	FTRACE_FL_DISABLED	= (1UL << 25),
>  	FTRACE_FL_DIRECT	= (1UL << 24),
>  	FTRACE_FL_DIRECT_EN	= (1UL << 23),
> +	FTRACE_FL_ARGS		= (1UL << 22),
> +	FTRACE_FL_ARGS_EN	= (1UL << 21),
>  };
>  
> -#define FTRACE_REF_MAX_SHIFT	23
> +#define FTRACE_REF_MAX_SHIFT	21
>  #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
>  
>  #define ftrace_rec_count(rec)	((rec)->flags & FTRACE_REF_MAX)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4833b6a82ce7..5632b0809dc0 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1721,6 +1721,9 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  			if (ops->flags & FTRACE_OPS_FL_DIRECT)
>  				rec->flags |= FTRACE_FL_DIRECT;
>  
> +			else if (ops->flags & FTRACE_OPS_FL_ARGS)
> +				rec->flags |= FTRACE_FL_ARGS;
> +
>  			/*
>  			 * If there's only a single callback registered to a
>  			 * function, and the ops has a trampoline registered
> @@ -1757,6 +1760,10 @@ static bool __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  			if (ops->flags & FTRACE_OPS_FL_DIRECT)
>  				rec->flags &= ~FTRACE_FL_DIRECT;
>  
> +			/* POC: but we will have more than one */
> +			if (ops->flags & FTRACE_OPS_FL_ARGS)
> +				rec->flags &= ~FTRACE_FL_ARGS;
> +
>  			/*
>  			 * If the rec had REGS enabled and the ops that is
>  			 * being removed had REGS set, then see if there is
> @@ -2103,6 +2110,13 @@ static int ftrace_check_record(struct dyn_ftrace *rec, bool enable, bool update)
>  		    !(rec->flags & FTRACE_FL_TRAMP_EN))
>  			flag |= FTRACE_FL_TRAMP;
>  
> +		/* Proof of concept */
> +		if (ftrace_rec_count(rec) == 1) {
> +			if (!(rec->flags & FTRACE_FL_ARGS) !=
> +			    !(rec->flags & FTRACE_FL_ARGS_EN))
> +				flag |= FTRACE_FL_ARGS;
> +		}
> +
>  		/*
>  		 * Direct calls are special, as count matters.
>  		 * We must test the record for direct, if the
> @@ -2144,6 +2158,17 @@ static int ftrace_check_record(struct dyn_ftrace *rec, bool enable, bool update)
>  				else
>  					rec->flags &= ~FTRACE_FL_TRAMP_EN;
>  			}
> +			if (flag & FTRACE_FL_ARGS) {
> +				if (ftrace_rec_count(rec) == 1) {
> +					if (rec->flags & FTRACE_FL_ARGS)
> +						rec->flags |= FTRACE_FL_ARGS_EN;
> +					else
> +						rec->flags &= ~FTRACE_FL_ARGS_EN;
> +				} else {
> +					rec->flags &= ~FTRACE_FL_ARGS_EN;
> +				}
> +			}
> +
>  			if (flag & FTRACE_FL_DIRECT) {
>  				/*
>  				 * If there's only one user (direct_ops helper)
> @@ -2192,7 +2217,8 @@ static int ftrace_check_record(struct dyn_ftrace *rec, bool enable, bool update)
>  			 * and REGS states. The _EN flags must be disabled though.
>  			 */
>  			rec->flags &= ~(FTRACE_FL_ENABLED | FTRACE_FL_TRAMP_EN |
> -					FTRACE_FL_REGS_EN | FTRACE_FL_DIRECT_EN);
> +					FTRACE_FL_REGS_EN | FTRACE_FL_DIRECT_EN |
> +					FTRACE_FL_ARGS_EN);
>  	}
>  
>  	ftrace_bug_type = FTRACE_BUG_NOP;
> @@ -3630,7 +3656,8 @@ static int t_show(struct seq_file *m, void *v)
>  			   ftrace_rec_count(rec),
>  			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
>  			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "  ",
> -			   rec->flags & FTRACE_FL_DIRECT ? " D" : "  ");
> +			   rec->flags & FTRACE_FL_DIRECT ? " D" :
> +			   rec->flags & FTRACE_FL_ARGS ? " A" : "  ");
>  		if (rec->flags & FTRACE_FL_TRAMP_EN) {
>  			ops = ftrace_find_tramp_ops_any(rec);
>  			if (ops) {
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 2c2126e1871d..a3da84b0e599 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -86,9 +86,48 @@ void ftrace_destroy_function_files(struct trace_array *tr)
>  	ftrace_free_ftrace_ops(tr);
>  }
>  
> +static void function_args_trace_call(unsigned long ip,
> +				     unsigned long *parent_ip,
> +				     struct ftrace_ops *op,
> +				     unsigned long *stack,
> +				     unsigned long *args)
> +{
> +	struct trace_array *tr = op->private;
> +	struct trace_array_cpu *data;
> +	unsigned long flags;
> +	int bit;
> +	int cpu;
> +	int pc;
> +
> +	if (unlikely(!tr->function_enabled))
> +		return;
> +
> +	pc = preempt_count();
> +	preempt_disable_notrace();
> +
> +	bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> +	if (bit < 0)
> +		goto out;
> +
> +	cpu = smp_processor_id();
> +	data = per_cpu_ptr(tr->array_buffer.data, cpu);
> +	if (!atomic_read(&data->disabled)) {
> +		local_save_flags(flags);
> +		trace_function(tr, ip, *parent_ip, flags, pc);
> +		trace_printk("%pS %lx %lx %lx %lx %lx %lx\n",
> +			     (void *)ip, args[0], args[1], args[2], args[3],
> +			     args[4], args[5]);
> +	}
> +	trace_clear_recursion(bit);
> +
> + out:
> +	preempt_enable_notrace();
> +
> +}
> +
>  static int function_trace_init(struct trace_array *tr)
>  {
> -	ftrace_func_t func;
> +	ftrace_callback_t callback;
>  
>  	/*
>  	 * Instance trace_arrays get their ops allocated
> @@ -101,11 +140,14 @@ static int function_trace_init(struct trace_array *tr)
>  	/* Currently only the global instance can do stack tracing */
>  	if (tr->flags & TRACE_ARRAY_FL_GLOBAL &&
>  	    func_flags.val & TRACE_FUNC_OPT_STACK)
> -		func = function_stack_trace_call;
> -	else
> -		func = function_trace_call;
> +		callback.func = function_stack_trace_call;
> +	else {
> +		tr->ops->flags |= FTRACE_OPS_FL_ARGS;
> +		callback.args_func = function_args_trace_call;
> +	}
> +//		func = function_trace_call;
>  
> -	ftrace_init_array_ops(tr, func);
> +	ftrace_init_array_ops(tr, callback.func);
>  
>  	tr->array_buffer.cpu = get_cpu();
>  	put_cpu();
> 

