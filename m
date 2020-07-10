Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B54621C082
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 01:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGJXFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 19:05:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:48604 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgGJXFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 19:05:32 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ju24i-0004Pg-E8; Sat, 11 Jul 2020 01:05:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ju24i-000VO0-4H; Sat, 11 Jul 2020 01:05:00 +0200
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: use dedicated bpf_trace_printk event
 instead of trace_printk()
To:     Alan Maguire <alan.maguire@oracle.com>, rostedt@goodmis.org,
        mingo@redhat.com, ast@kernel.org, andriin@fb.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <1594390953-31757-1-git-send-email-alan.maguire@oracle.com>
 <1594390953-31757-2-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <10d713e3-c2d6-7331-a589-b567e8378944@iogearbox.net>
Date:   Sat, 11 Jul 2020 01:04:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1594390953-31757-2-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25869/Fri Jul 10 16:01:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 4:22 PM, Alan Maguire wrote:
> The bpf helper bpf_trace_printk() uses trace_printk() under the hood.
> This leads to an alarming warning message originating from trace
> buffer allocation which occurs the first time a program using
> bpf_trace_printk() is loaded.
> 
> We can instead create a trace event for bpf_trace_printk() and enable
> it in-kernel when/if we encounter a program using the
> bpf_trace_printk() helper.  With this approach, trace_printk()
> is not used directly and no warning message appears.
> 
> This work was started by Steven (see Link) and finished by Alan; added
> Steven's Signed-off-by with his permission.
> 
> Link: https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>   kernel/trace/Makefile    |  2 ++
>   kernel/trace/bpf_trace.c | 41 ++++++++++++++++++++++++++++++++++++-----
>   kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
>   3 files changed, 72 insertions(+), 5 deletions(-)
>   create mode 100644 kernel/trace/bpf_trace.h
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 6575bb0..aeba5ee 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -31,6 +31,8 @@ ifdef CONFIG_GCOV_PROFILE_FTRACE
>   GCOV_PROFILE := y
>   endif
>   
> +CFLAGS_bpf_trace.o := -I$(src)
> +
>   CFLAGS_trace_benchmark.o := -I$(src)
>   CFLAGS_trace_events_filter.o := -I$(src)
>   
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 1d874d8..1414bf5 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -11,6 +11,7 @@
>   #include <linux/uaccess.h>
>   #include <linux/ctype.h>
>   #include <linux/kprobes.h>
> +#include <linux/spinlock.h>
>   #include <linux/syscalls.h>
>   #include <linux/error-injection.h>
>   
> @@ -19,6 +20,9 @@
>   #include "trace_probe.h"
>   #include "trace.h"
>   
> +#define CREATE_TRACE_POINTS
> +#include "bpf_trace.h"
> +
>   #define bpf_event_rcu_dereference(p)					\
>   	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
>   
> @@ -374,6 +378,29 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>   	}
>   }
>   
> +static DEFINE_RAW_SPINLOCK(trace_printk_lock);
> +
> +#define BPF_TRACE_PRINTK_SIZE   1024
> +
> +

nit: double newline

> +static inline __printf(1, 0) int bpf_do_trace_printk(const char *fmt, ...)
> +{
> +	static char buf[BPF_TRACE_PRINTK_SIZE];
> +	unsigned long flags;
> +	va_list ap;
> +	int ret;
> +
> +	raw_spin_lock_irqsave(&trace_printk_lock, flags);
> +	va_start(ap, fmt);
> +	ret = vsnprintf(buf, BPF_TRACE_PRINTK_SIZE, fmt, ap);

nit: s/BPF_TRACE_PRINTK_SIZE/sizeof(buf)/

> +	va_end(ap);
> +	if (ret >= 0)
> +		trace_bpf_trace_printk(buf);

Is there a specific reason you added the 'ret >= 0' check on top of [0]? Given
the vsnprintf() internals you either return 0 or number of characters generated,
no?

   [0] https://lore.kernel.org/bpf/20200628194334.6238b933@oasis.local.home/

Rest lgtm, thanks!

> +	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
> +
> +	return ret;
> +}
> +
>   /*
>    * Only limited trace_printk() conversion specifiers allowed:
>    * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
> @@ -483,8 +510,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>    */
>   #define __BPF_TP_EMIT()	__BPF_ARG3_TP()
>   #define __BPF_TP(...)							\
> -	__trace_printk(0 /* Fake ip */,					\
> -		       fmt, ##__VA_ARGS__)
> +	bpf_do_trace_printk(fmt, ##__VA_ARGS__)
>   
>   #define __BPF_ARG1_TP(...)						\
>   	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
> @@ -521,10 +547,15 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>   const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>   {
>   	/*
> -	 * this program might be calling bpf_trace_printk,
> -	 * so allocate per-cpu printk buffers
> +	 * This program might be calling bpf_trace_printk,
> +	 * so enable the associated bpf_trace/bpf_trace_printk event.
> +	 * Repeat this each time as it is possible a user has
> +	 * disabled bpf_trace_printk events.  By loading a program
> +	 * calling bpf_trace_printk() however the user has expressed
> +	 * the intent to see such events.
>   	 */
> -	trace_printk_init_buffers();
> +	if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
> +		pr_warn_ratelimited("could not enable bpf_trace_printk events");
>   
>   	return &bpf_trace_printk_proto;
>   }
> diff --git a/kernel/trace/bpf_trace.h b/kernel/trace/bpf_trace.h
> new file mode 100644
> index 0000000..9acbc11
> --- /dev/null
> +++ b/kernel/trace/bpf_trace.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM bpf_trace
> +
> +#if !defined(_TRACE_BPF_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
> +
> +#define _TRACE_BPF_TRACE_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(bpf_trace_printk,
> +
> +	TP_PROTO(const char *bpf_string),
> +
> +	TP_ARGS(bpf_string),
> +
> +	TP_STRUCT__entry(
> +		__string(bpf_string, bpf_string)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(bpf_string, bpf_string);
> +	),
> +
> +	TP_printk("%s", __get_str(bpf_string))
> +);
> +
> +#endif /* _TRACE_BPF_TRACE_H */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#define TRACE_INCLUDE_FILE bpf_trace
> +
> +#include <trace/define_trace.h>
> 

