Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DFC3B4FE3
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 20:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhFZSpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 14:45:14 -0400
Received: from mail.efficios.com ([167.114.26.124]:55078 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhFZSpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 14:45:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B0E04342C8A;
        Sat, 26 Jun 2021 14:42:50 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id vW9pityWiUom; Sat, 26 Jun 2021 14:42:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7E24F342C88;
        Sat, 26 Jun 2021 14:42:49 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 7E24F342C88
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1624732969;
        bh=GU0YgrNLq2P1s0pWX6FcYzfV+0aM3tp+YjgNts6V6Ak=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=g+32GTUlmAOVkqF+Tqt/UGPF6trEZ3TOpWOZA9TWJ0SRx27TUUmtvRpkyTGOJtU/o
         vaV2WW61ij+VI8h+JeuaK+yX9K6Ly6wmvBsZfs8nrU0v7SlmbkgOiWyiWbeVTUlTWN
         n2K2T5g/p6W1JtWOmuam4MvG3/vcJrrozN6E8eKYfNIQ31pgTNTX3mT9cOhc9VYtA8
         mbt/teHAslHlY6sVM2imraEXISKhh+BZLbRej0bjuRz/fiN/lO+UFn75SdbJfuPwNk
         NIv+oOalCS/J2MrHyK+4izl8eGilKLUSADxSwRX/dm1M1Ga/dbKvdnXNb+OkfG5Dhm
         3o5aMTQgMloQA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RHcXpO5QAdMb; Sat, 26 Jun 2021 14:42:49 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 58753342A9B;
        Sat, 26 Jun 2021 14:42:49 -0400 (EDT)
Date:   Sat, 26 Jun 2021 14:42:49 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Message-ID: <1252314758.18555.1624732969232.JavaMail.zimbra@efficios.com>
In-Reply-To: <20210626142213.6dee5c60@rorschach.local.home>
References: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp> <20210626101834.55b4ecf1@rorschach.local.home> <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp> <20210626114157.765d9371@rorschach.local.home> <20210626142213.6dee5c60@rorschach.local.home>
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4018 (zclient/8.8.15_GA_4018)
Thread-Topic: tracepoint: Do not warn on EEXIST or ENOENT
Thread-Index: LVpiAayug1iByt8B8glRMFgL25vWqw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


----- Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 26 Jun 2021 11:41:57 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > If BPF is expected to register the same tracepoint with the same
> > callback and data more than once, then let's add a call to do that
> > without warning. Like I said, other callers expect the call to succeed
> > unless it's out of memory, which tends to cause other problems.
> 
> If BPF is OK with registering the same probe more than once if user
> space expects it, we can add this patch, which allows the caller (in
> this case BPF) to not warn if the probe being registered is already
> registered, and keeps the idea that a probe registered twice is a bug
> for all other use cases.

How can removal of the duplicates be non buggy then ? The first removal will match both probes.

Thanks,

Mathieu

> 
> -- Steve
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 13f65420f188..656d22cf42fc 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -36,10 +36,11 @@ struct trace_eval_map {
>  extern struct srcu_struct tracepoint_srcu;
>  
>  extern int
> -tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data);
> +tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data,
> +			  bool no_warn);
>  extern int
>  tracepoint_probe_register_prio(struct tracepoint *tp, void *probe, void *data,
> -			       int prio);
> +			       int prio, bool no_warn);
>  extern int
>  tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
>  extern void
> @@ -250,14 +251,16 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>  	register_trace_##name(void (*probe)(data_proto), void *data)	\
>  	{								\
>  		return tracepoint_probe_register(&__tracepoint_##name,	\
> -						(void *)probe, data);	\
> +						(void *)probe, data,	\
> +						 false);		\
>  	}								\
>  	static inline int						\
>  	register_trace_prio_##name(void (*probe)(data_proto), void *data,\
>  				   int prio)				\
>  	{								\
>  		return tracepoint_probe_register_prio(&__tracepoint_##name, \
> -					      (void *)probe, data, prio); \
> +					      (void *)probe, data,	\
> +					      prio, false);		\
>  	}								\
>  	static inline int						\
>  	unregister_trace_##name(void (*probe)(data_proto), void *data)	\
> diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
> index 8bcffbdef3d3..b76738e61eee 100644
> --- a/kernel/kcsan/kcsan_test.c
> +++ b/kernel/kcsan/kcsan_test.c
> @@ -1160,7 +1160,7 @@ static void register_tracepoints(struct tracepoint *tp, void *ignore)
>  {
>  	check_trace_callback_type_console(probe_console);
>  	if (!strcmp(tp->name, "console"))
> -		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
> +		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL, false));
>  }
>  
>  __no_kcsan
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 7a52bc172841..3d3a80db40b5 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1840,7 +1840,7 @@ static int __bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *
>  	if (prog->aux->max_tp_access > btp->writable_size)
>  		return -EINVAL;
>  
> -	return tracepoint_probe_register(tp, (void *)btp->bpf_func, prog);
> +	return tracepoint_probe_register(tp, (void *)btp->bpf_func, prog, true);
>  }
>  
>  int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 80e96989770e..07986569b1b9 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -500,7 +500,7 @@ int trace_event_reg(struct trace_event_call *call,
>  	case TRACE_REG_REGISTER:
>  		return tracepoint_probe_register(call->tp,
>  						 call->class->probe,
> -						 file);
> +						 file, false);
>  	case TRACE_REG_UNREGISTER:
>  		tracepoint_probe_unregister(call->tp,
>  					    call->class->probe,
> @@ -511,7 +511,7 @@ int trace_event_reg(struct trace_event_call *call,
>  	case TRACE_REG_PERF_REGISTER:
>  		return tracepoint_probe_register(call->tp,
>  						 call->class->perf_probe,
> -						 call);
> +						 call, false);
>  	case TRACE_REG_PERF_UNREGISTER:
>  		tracepoint_probe_unregister(call->tp,
>  					    call->class->perf_probe,
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 9f478d29b926..3c3a517b229e 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -273,7 +273,8 @@ static void tracepoint_update_call(struct tracepoint *tp, struct tracepoint_func
>   * Add the probe function to a tracepoint.
>   */
>  static int tracepoint_add_func(struct tracepoint *tp,
> -			       struct tracepoint_func *func, int prio)
> +			       struct tracepoint_func *func, int prio,
> +			       bool no_warn)
>  {
>  	struct tracepoint_func *old, *tp_funcs;
>  	int ret;
> @@ -288,7 +289,7 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  			lockdep_is_held(&tracepoints_mutex));
>  	old = func_add(&tp_funcs, func, prio);
>  	if (IS_ERR(old)) {
> -		WARN_ON_ONCE(PTR_ERR(old) != -ENOMEM);
> +		WARN_ON_ONCE(!no_warn && PTR_ERR(old) != -ENOMEM);
>  		return PTR_ERR(old);
>  	}
>  
> @@ -349,6 +350,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>   * @probe: probe handler
>   * @data: tracepoint data
>   * @prio: priority of this function over other registered functions
> + * @no_warn: Do not warn if the tracepoint is already registered
>   *
>   * Returns 0 if ok, error value on error.
>   * Note: if @tp is within a module, the caller is responsible for
> @@ -357,7 +359,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>   * within module exit functions.
>   */
>  int tracepoint_probe_register_prio(struct tracepoint *tp, void *probe,
> -				   void *data, int prio)
> +				   void *data, int prio, bool no_warn)
>  {
>  	struct tracepoint_func tp_func;
>  	int ret;
> @@ -366,7 +368,7 @@ int tracepoint_probe_register_prio(struct tracepoint *tp, void *probe,
>  	tp_func.func = probe;
>  	tp_func.data = data;
>  	tp_func.prio = prio;
> -	ret = tracepoint_add_func(tp, &tp_func, prio);
> +	ret = tracepoint_add_func(tp, &tp_func, prio, no_warn);
>  	mutex_unlock(&tracepoints_mutex);
>  	return ret;
>  }
> @@ -377,6 +379,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register_prio);
>   * @tp: tracepoint
>   * @probe: probe handler
>   * @data: tracepoint data
> + * @no_warn: Do not warn if the tracepoint is already registered
>   *
>   * Returns 0 if ok, error value on error.
>   * Note: if @tp is within a module, the caller is responsible for
> @@ -384,9 +387,11 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register_prio);
>   * performed either with a tracepoint module going notifier, or from
>   * within module exit functions.
>   */
> -int tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data)
> +int tracepoint_probe_register(struct tracepoint *tp, void *probe, void *data,
> +			      bool no_warn)
>  {
> -	return tracepoint_probe_register_prio(tp, probe, data, TRACEPOINT_DEFAULT_PRIO);
> +	return tracepoint_probe_register_prio(tp, probe, data,
> +					      TRACEPOINT_DEFAULT_PRIO, no_warn);
>  }
>  EXPORT_SYMBOL_GPL(tracepoint_probe_register);
>  
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index 4acf4251ee04..a9331c967690 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -820,7 +820,7 @@ static void register_tracepoints(struct tracepoint *tp, void *ignore)
>  {
>  	check_trace_callback_type_console(probe_console);
>  	if (!strcmp(tp->name, "console"))
> -		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL));
> +		WARN_ON(tracepoint_probe_register(tp, probe_console, NULL, true));
>  }
>  
>  static void unregister_tracepoints(struct tracepoint *tp, void *ignore)

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
