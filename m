Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B83B8B07
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 01:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbhGAAB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhGAAB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 20:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493F3613F7;
        Wed, 30 Jun 2021 23:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625097537;
        bh=F5a8UcLjpBxCfgcs/9ldfS6ToJ0b1vKhOUDCo+oZJjc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SG/hE0eBldza/ursZAX5oBMZG14zhf6rEn7rqweEnXsAN+vK11iwWZtpx7xT3DQqE
         vRFqrN9P0lHH6L0gVvHp+b27qkuyvtJ/bJuivenBBO9P+vNUZKCexHO8pJGMoVFN16
         IKvGVDVaGO8w8ZtXmGDU+2ku0SQSoVcqa87S761NvPXp9AJjbn9m1ztbNl0Ax3+J2x
         EWHN1Dwe4fRMCxBoC9d2Gqg87g6aHtqIj32kHMmzWRvY7pfwnp7Hjk/pcZV+fqWna2
         /ld2Pe973Lu1dZkUhvm3Ew47iPvu7kYKa7D3YfheS+dBWnGigR3s7uB6RrMXaq8v2O
         1T7gtl4VrpBgA==
Date:   Thu, 1 Jul 2021 08:58:54 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe
 programs
Message-Id: <20210701085854.0f2aeafc0fce11f3ca9d52a8@kernel.org>
In-Reply-To: <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
References: <20210629192945.1071862-1-jolsa@kernel.org>
        <20210629192945.1071862-5-jolsa@kernel.org>
        <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Jun 2021 10:47:01 -0700
Yonghong Song <yhs@fb.com> wrote:

> 
> 
> On 6/29/21 12:29 PM, Jiri Olsa wrote:
> > Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
> > so it's now possible to call bpf_get_func_ip from both kprobe and
> > kretprobe programs.
> > 
> > Taking the caller's address from 'struct kprobe::addr', which is
> > defined for both kprobe and kretprobe.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/uapi/linux/bpf.h       |  2 +-
> >   kernel/bpf/verifier.c          |  2 ++
> >   kernel/trace/bpf_trace.c       | 14 ++++++++++++++
> >   kernel/trace/trace_kprobe.c    | 20 ++++++++++++++++++--
> >   kernel/trace/trace_probe.h     |  5 +++++
> >   tools/include/uapi/linux/bpf.h |  2 +-
> >   6 files changed, 41 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 83e87ffdbb6e..4894f99a1993 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4783,7 +4783,7 @@ union bpf_attr {
> >    *
> >    * u64 bpf_get_func_ip(void *ctx)
> >    * 	Description
> > - * 		Get address of the traced function (for tracing programs).
> > + * 		Get address of the traced function (for tracing and kprobe programs).
> >    * 	Return
> >    * 		Address of the traced function.
> >    */
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 701ff7384fa7..b66e0a7104f8 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5979,6 +5979,8 @@ static bool has_get_func_ip(struct bpf_verifier_env *env)
> >   			return -ENOTSUPP;
> >   		}
> >   		return 0;
> > +	} else if (type == BPF_PROG_TYPE_KPROBE) {
> > +		return 0;
> >   	}
> >   
> >   	verbose(env, "func %s#%d not supported for program type %d\n",
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 9edd3b1a00ad..1a5bddce9abd 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -961,6 +961,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
> >   	.arg1_type	= ARG_PTR_TO_CTX,
> >   };
> >   
> > +BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> > +{
> > +	return trace_current_kprobe_addr();
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > +	.func		= bpf_get_func_ip_kprobe,
> > +	.gpl_only	= true,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_CTX,
> > +};
> > +
> >   const struct bpf_func_proto *
> >   bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   {
> > @@ -1092,6 +1104,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   	case BPF_FUNC_override_return:
> >   		return &bpf_override_return_proto;
> >   #endif
> > +	case BPF_FUNC_get_func_ip:
> > +		return &bpf_get_func_ip_proto_kprobe;
> >   	default:
> >   		return bpf_tracing_func_proto(func_id, prog);
> >   	}
> > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > index ea6178cb5e33..b07d5888db14 100644
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
> >   }
> >   
> >   #ifdef CONFIG_PERF_EVENTS
> > +/* Used by bpf get_func_ip helper */
> > +DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;
> 
> Didn't check other architectures. But this should work
> for x86 where if nested kprobe happens, the second
> kprobe will not call kprobe handlers.

No problem, other architecture also does not call nested kprobes handlers.
However, you don't need this because you can use kprobe_running()
in kprobe context.

kp = kprobe_running();
if (kp)
	return kp->addr;

BTW, I'm not sure why don't you use instruction_pointer(regs)?

Thank you,

> 
> This essentially is to provide an additional parameter to
> bpf program. Andrii is developing a mechanism to
> save arbitrary data in *current task_struct*, which
> might be used here to save current_kprobe_addr, we can
> save one per cpu variable.
> 
> > +
> > +u64 trace_current_kprobe_addr(void)
> > +{
> > +	return *this_cpu_ptr(&current_kprobe_addr);
> > +}
> > +
> > +static void trace_current_kprobe_set(struct trace_kprobe *tk)
> > +{
> > +	__this_cpu_write(current_kprobe_addr, (u64) tk->rp.kp.addr);
> > +}
> >   
> >   /* Kprobe profile handler */
> >   static int
> > @@ -1585,6 +1597,7 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
> >   		unsigned long orig_ip = instruction_pointer(regs);
> >   		int ret;
> >   
> > +		trace_current_kprobe_set(tk);
> >   		ret = trace_call_bpf(call, regs);
> >   
> >   		/*
> > @@ -1631,8 +1644,11 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
> >   	int size, __size, dsize;
> >   	int rctx;
> >   
> > -	if (bpf_prog_array_valid(call) && !trace_call_bpf(call, regs))
> > -		return;
> > +	if (bpf_prog_array_valid(call)) {
> > +		trace_current_kprobe_set(tk);
> > +		if (!trace_call_bpf(call, regs))
> > +			return;
> > +	}
> >   
> >   	head = this_cpu_ptr(call->perf_events);
> >   	if (hlist_empty(head))
> [...]


-- 
Masami Hiramatsu <mhiramat@kernel.org>
