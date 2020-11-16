Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A22B4C7F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbgKPRTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730564AbgKPRTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:19:33 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E9F20797;
        Mon, 16 Nov 2020 17:19:30 +0000 (UTC)
Date:   Mon, 16 Nov 2020 12:19:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Matt Mullins <mmullins@mmlx.us>
Cc:     mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        dvyukov@google.com, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] bpf: don't fail kmalloc while releasing raw_tp
Message-ID: <20201116121929.1a7aeb16@gandalf.local.home>
In-Reply-To: <20201115055256.65625-1-mmullins@mmlx.us>
References: <00000000000004500b05b31e68ce@google.com>
        <20201115055256.65625-1-mmullins@mmlx.us>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 21:52:55 -0800
Matt Mullins <mmullins@mmlx.us> wrote:

> bpf_link_free is always called in process context, including from a
> workqueue and from __fput.  Neither of these have the ability to
> propagate an -ENOMEM to the caller.
> 

Hmm, I think the real fix is to not have unregistering a tracepoint probe
fail because of allocation. We are removing a probe, perhaps we could just
inject NULL pointer that gets checked via the DO_TRACE loop?

I bet failing an unregister because of an allocation failure causes
problems elsewhere than just BPF.

Mathieu,

Can't we do something that would still allow to unregister a probe even if
a new probe array fails to allocate? We could kick off a irq work to try to
clean up the probe at a later time, but still, the unregister itself should
not fail due to memory failure.

-- Steve



> Reported-by: syzbot+83aa762ef23b6f0d1991@syzkaller.appspotmail.com
> Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
> Signed-off-by: Matt Mullins <mmullins@mmlx.us>
> ---
> I previously referenced a "pretty ugly" patch.  This is not that one,
> because I don't think there's any way I can make the caller of
> ->release() actually handle errors like ENOMEM.  
> 
> It also looks like most of the other ways tracepoint_probe_unregister is
> called also don't check the error code (e.g. just a quick grep found
> blk_unregister_tracepoints).  Should this just be upgraded to GFP_NOFAIL
> across the board instead of passing around a gfp_t?
> 
>  include/linux/trace_events.h |  6 ++++--
>  include/linux/tracepoint.h   |  7 +++++--
>  kernel/bpf/syscall.c         |  2 +-
>  kernel/trace/bpf_trace.c     |  6 ++++--
>  kernel/trace/trace_events.c  |  6 ++++--
>  kernel/tracepoint.c          | 20 ++++++++++----------
>  6 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
> index 5c6943354049..166ad7646a98 100644
> --- a/include/linux/trace_events.h
> +++ b/include/linux/trace_events.h
> @@ -625,7 +625,8 @@ int perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog);
>  void perf_event_detach_bpf_prog(struct perf_event *event);
>  int perf_event_query_prog_array(struct perf_event *event, void __user *info);
>  int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog);
> -int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog);
> +int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog,
> +			 gfp_t flags);
>  struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name);
>  void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp);
>  int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
> @@ -654,7 +655,8 @@ static inline int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_p
>  {
>  	return -EOPNOTSUPP;
>  }
> -static inline int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *p)
> +static inline int bpf_probe_unregister(struct bpf_raw_event_map *btp,
> +				       struct bpf_prog *p, gfp_t flags)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 598fec9f9dbf..7b02f92f3b8f 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -12,6 +12,7 @@
>   * Heavily inspired from the Linux Kernel Markers.
>   */
>  
> +#include <linux/gfp.h>
>  #include <linux/smp.h>
>  #include <linux/srcu.h>
>  #include <linux/errno.h>
> @@ -40,7 +41,8 @@ extern int
>  tracepoint_probe_register_prio(struct tracepoint *tp, void *probe, void *data,
>  			       int prio);
>  extern int
> -tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
> +tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data,
> +			    gfp_t flags);
>  extern void
>  for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
>  		void *priv);
> @@ -260,7 +262,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
>  	{								\
>  		return tracepoint_probe_unregister(&__tracepoint_##name,\
> -						(void *)probe, data);	\
> +						(void *)probe, data,	\
> +						GFP_KERNEL);		\
>  	}								\
>  	static inline void						\
>  	check_trace_callback_type_##name(void (*cb)(data_proto))	\
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b999e7ff2583..f6876681c4ab 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2601,7 +2601,7 @@ static void bpf_raw_tp_link_release(struct bpf_link *link)
>  	struct bpf_raw_tp_link *raw_tp =
>  		container_of(link, struct bpf_raw_tp_link, link);
>  
> -	bpf_probe_unregister(raw_tp->btp, raw_tp->link.prog);
> +	bpf_probe_unregister(raw_tp->btp, raw_tp->link.prog, GFP_KERNEL | __GFP_NOFAIL);
>  	bpf_put_raw_tracepoint(raw_tp->btp);
>  }
>  
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index a8d4f253ed77..a4ea58c7506d 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1955,9 +1955,11 @@ int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
>  	return __bpf_probe_register(btp, prog);
>  }
>  
> -int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
> +int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog,
> +			 gfp_t flags)
>  {
> -	return tracepoint_probe_unregister(btp->tp, (void *)btp->bpf_func, prog);
> +	return tracepoint_probe_unregister(btp->tp, (void *)btp->bpf_func, prog,
> +					   flags);
>  }
>  
>  int bpf_get_perf_event_info(const struct perf_event *event, u32 *prog_id,
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index a85effb2373b..ab1ac89caed2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -296,7 +296,8 @@ int trace_event_reg(struct trace_event_call *call,
>  	case TRACE_REG_UNREGISTER:
>  		tracepoint_probe_unregister(call->tp,
>  					    call->class->probe,
> -					    file);
> +					    file,
> +					    GFP_KERNEL);
>  		return 0;
>  
>  #ifdef CONFIG_PERF_EVENTS
> @@ -307,7 +308,8 @@ int trace_event_reg(struct trace_event_call *call,
>  	case TRACE_REG_PERF_UNREGISTER:
>  		tracepoint_probe_unregister(call->tp,
>  					    call->class->perf_probe,
> -					    call);
> +					    call,
> +					    GFP_KERNEL);
>  		return 0;
>  	case TRACE_REG_PERF_OPEN:
>  	case TRACE_REG_PERF_CLOSE:
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 73956eaff8a9..619666a43c9f 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -53,10 +53,9 @@ struct tp_probes {
>  	struct tracepoint_func probes[0];
>  };
>  
> -static inline void *allocate_probes(int count)
> +static inline void *allocate_probes(int count, gfp_t flags)
>  {
> -	struct tp_probes *p  = kmalloc(struct_size(p, probes, count),
> -				       GFP_KERNEL);
> +	struct tp_probes *p  = kmalloc(struct_size(p, probes, count), flags);
>  	return p == NULL ? NULL : p->probes;
>  }
>  
> @@ -150,7 +149,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
>  		}
>  	}
>  	/* + 2 : one for new probe, one for NULL func */
> -	new = allocate_probes(nr_probes + 2);
> +	new = allocate_probes(nr_probes + 2, GFP_KERNEL);
>  	if (new == NULL)
>  		return ERR_PTR(-ENOMEM);
>  	if (old) {
> @@ -174,7 +173,7 @@ func_add(struct tracepoint_func **funcs, struct tracepoint_func *tp_func,
>  }
>  
>  static void *func_remove(struct tracepoint_func **funcs,
> -		struct tracepoint_func *tp_func)
> +		struct tracepoint_func *tp_func, gfp_t flags)
>  {
>  	int nr_probes = 0, nr_del = 0, i;
>  	struct tracepoint_func *old, *new;
> @@ -207,7 +206,7 @@ static void *func_remove(struct tracepoint_func **funcs,
>  		int j = 0;
>  		/* N -> M, (N > 1, M > 0) */
>  		/* + 1 for NULL */
> -		new = allocate_probes(nr_probes - nr_del + 1);
> +		new = allocate_probes(nr_probes - nr_del + 1, flags);
>  		if (new == NULL)
>  			return ERR_PTR(-ENOMEM);
>  		for (i = 0; old[i].func; i++)
> @@ -264,13 +263,13 @@ static int tracepoint_add_func(struct tracepoint *tp,
>   * by preempt_disable around the call site.
>   */
>  static int tracepoint_remove_func(struct tracepoint *tp,
> -		struct tracepoint_func *func)
> +		struct tracepoint_func *func, gfp_t flags)
>  {
>  	struct tracepoint_func *old, *tp_funcs;
>  
>  	tp_funcs = rcu_dereference_protected(tp->funcs,
>  			lockdep_is_held(&tracepoints_mutex));
> -	old = func_remove(&tp_funcs, func);
> +	old = func_remove(&tp_funcs, func, flags);
>  	if (IS_ERR(old)) {
>  		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
>  		return PTR_ERR(old);
> @@ -344,7 +343,8 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register);
>   *
>   * Returns 0 if ok, error value on error.
>   */
> -int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data)
> +int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data,
> +				gfp_t flags)
>  {
>  	struct tracepoint_func tp_func;
>  	int ret;
> @@ -352,7 +352,7 @@ int tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data)
>  	mutex_lock(&tracepoints_mutex);
>  	tp_func.func = probe;
>  	tp_func.data = data;
> -	ret = tracepoint_remove_func(tp, &tp_func);
> +	ret = tracepoint_remove_func(tp, &tp_func, flags);
>  	mutex_unlock(&tracepoints_mutex);
>  	return ret;
>  }

