Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555F22A07D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404297AbfEXVja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:39:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:52390 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404266AbfEXVj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:39:29 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUHuQ-0001BJ-W2; Fri, 24 May 2019 23:39:27 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hUHuQ-000NbE-Q3; Fri, 24 May 2019 23:39:26 +0200
Subject: Re: [PATCH bpf-next v5 1/3] bpf: implement bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>, kernel-team@fb.com,
        Peter Zijlstra <peterz@infradead.org>
References: <20190523214745.854300-1-yhs@fb.com>
 <20190523214745.854355-1-yhs@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <54257f88-b088-2330-ba49-a78ce06d08bf@iogearbox.net>
Date:   Fri, 24 May 2019 23:39:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190523214745.854355-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25459/Fri May 24 09:59:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/23/2019 11:47 PM, Yonghong Song wrote:
> This patch tries to solve the following specific use case.
> 
> Currently, bpf program can already collect stack traces
> through kernel function get_perf_callchain()
> when certain events happens (e.g., cache miss counter or
> cpu clock counter overflows). But such stack traces are
> not enough for jitted programs, e.g., hhvm (jited php).
> To get real stack trace, jit engine internal data structures
> need to be traversed in order to get the real user functions.
> 
> bpf program itself may not be the best place to traverse
> the jit engine as the traversing logic could be complex and
> it is not a stable interface either.
> 
> Instead, hhvm implements a signal handler,
> e.g. for SIGALARM, and a set of program locations which
> it can dump stack traces. When it receives a signal, it will
> dump the stack in next such program location.
> 
> Such a mechanism can be implemented in the following way:
>   . a perf ring buffer is created between bpf program
>     and tracing app.
>   . once a particular event happens, bpf program writes
>     to the ring buffer and the tracing app gets notified.
>   . the tracing app sends a signal SIGALARM to the hhvm.
> 
> But this method could have large delays and causing profiling
> results skewed.
> 
> This patch implements bpf_send_signal() helper to send
> a signal to hhvm in real time, resulting in intended stack traces.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h | 17 +++++++++-
>  kernel/trace/bpf_trace.c | 72 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 63e0cf66f01a..68d4470523a0 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2672,6 +2672,20 @@ union bpf_attr {
>   *		0 on success.
>   *
>   *		**-ENOENT** if the bpf-local-storage cannot be found.
> + *
> + * int bpf_send_signal(u32 sig)
> + *	Description
> + *		Send signal *sig* to the current task.
> + *	Return
> + *		0 on success or successfully queued.
> + *
> + *		**-EBUSY** if work queue under nmi is full.
> + *
> + *		**-EINVAL** if *sig* is invalid.
> + *
> + *		**-EPERM** if no permission to send the *sig*.
> + *
> + *		**-EAGAIN** if bpf program can try again.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -2782,7 +2796,8 @@ union bpf_attr {
>  	FN(strtol),			\
>  	FN(strtoul),			\
>  	FN(sk_storage_get),		\
> -	FN(sk_storage_delete),
> +	FN(sk_storage_delete),		\
> +	FN(send_signal),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f92d6ad5e080..70029eafc71f 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -567,6 +567,63 @@ static const struct bpf_func_proto bpf_probe_read_str_proto = {
>  	.arg3_type	= ARG_ANYTHING,
>  };
>  
> +struct send_signal_irq_work {
> +	struct irq_work irq_work;
> +	struct task_struct *task;
> +	u32 sig;
> +};
> +
> +static DEFINE_PER_CPU(struct send_signal_irq_work, send_signal_work);
> +
> +static void do_bpf_send_signal(struct irq_work *entry)
> +{
> +	struct send_signal_irq_work *work;
> +
> +	work = container_of(entry, struct send_signal_irq_work, irq_work);
> +	group_send_sig_info(work->sig, SEND_SIG_PRIV, work->task, PIDTYPE_TGID);
> +}
> +
> +BPF_CALL_1(bpf_send_signal, u32, sig)
> +{
> +	struct send_signal_irq_work *work = NULL;
> +
> +	/* Similar to bpf_probe_write_user, task needs to be
> +	 * in a sound condition and kernel memory access be
> +	 * permitted in order to send signal to the current
> +	 * task.
> +	 */
> +	if (unlikely(current->flags & (PF_KTHREAD | PF_EXITING)))
> +		return -EPERM;
> +	if (unlikely(uaccess_kernel()))
> +		return -EPERM;
> +	if (unlikely(!nmi_uaccess_okay()))
> +		return -EPERM;
> +
> +	if (in_nmi()) {
> +		work = this_cpu_ptr(&send_signal_work);
> +		if (work->irq_work.flags & IRQ_WORK_BUSY)

Given here and in stackmap are the only two users outside of kernel/irq_work.c,
it may probably be good to add a small helper to include/linux/irq_work.h and
use it for both.

Perhaps something like ...

static inline bool irq_work_busy(struct irq_work *work)
{
	return READ_ONCE(work->flags) & IRQ_WORK_BUSY;
}

> +			return -EBUSY;
> +
> +		/* Add the current task, which is the target of sending signal,
> +		 * to the irq_work. The current task may change when queued
> +		 * irq works get executed.
> +		 */
> +		work->task = current;
> +		work->sig = sig;
> +		irq_work_queue(&work->irq_work);
> +		return 0;
> +	}
> +
> +	return group_send_sig_info(sig, SEND_SIG_PRIV, current, PIDTYPE_TGID);
> +}
> +
> +static const struct bpf_func_proto bpf_send_signal_proto = {
> +	.func		= bpf_send_signal,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_ANYTHING,
> +};
> +
>  static const struct bpf_func_proto *
>  tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> @@ -617,6 +674,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	case BPF_FUNC_get_current_cgroup_id:
>  		return &bpf_get_current_cgroup_id_proto;
>  #endif
> +	case BPF_FUNC_send_signal:
> +		return &bpf_send_signal_proto;
>  	default:
>  		return NULL;
>  	}
> @@ -1343,5 +1402,18 @@ static int __init bpf_event_init(void)
>  	return 0;
>  }
>  
> +static int __init send_signal_irq_work_init(void)
> +{
> +	int cpu;
> +	struct send_signal_irq_work *work;
> +
> +	for_each_possible_cpu(cpu) {
> +		work = per_cpu_ptr(&send_signal_work, cpu);
> +		init_irq_work(&work->irq_work, do_bpf_send_signal);
> +	}
> +	return 0;
> +}
> +
>  fs_initcall(bpf_event_init);
> +subsys_initcall(send_signal_irq_work_init);
>  #endif /* CONFIG_MODULES */
> 

