Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A352521A9D5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGIVlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIVlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 17:41:24 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E8B920708;
        Thu,  9 Jul 2020 21:41:22 +0000 (UTC)
Date:   Thu, 9 Jul 2020 17:41:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf: use dedicated bpf_trace_printk event
 instead of trace_printk()
Message-ID: <20200709174120.0ae45ca4@oasis.local.home>
In-Reply-To: <1593787468-29931-2-git-send-email-alan.maguire@oracle.com>
References: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com>
        <1593787468-29931-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Jul 2020 15:44:27 +0100
Alan Maguire <alan.maguire@oracle.com> wrote:

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
>  kernel/trace/Makefile    |  2 ++
>  kernel/trace/bpf_trace.c | 41 +++++++++++++++++++++++++++++++++++++----
>  kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 4 deletions(-)
>  create mode 100644 kernel/trace/bpf_trace.h
> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 6575bb0..aeba5ee 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -31,6 +31,8 @@ ifdef CONFIG_GCOV_PROFILE_FTRACE
>  GCOV_PROFILE := y
>  endif
>  
> +CFLAGS_bpf_trace.o := -I$(src)
> +
>  CFLAGS_trace_benchmark.o := -I$(src)
>  CFLAGS_trace_events_filter.o := -I$(src)
>  
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 1d874d8..cdbafc4 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2,6 +2,10 @@
>  /* Copyright (c) 2011-2015 PLUMgrid, http://plumgrid.com
>   * Copyright (c) 2016 Facebook
>   */
> +#define CREATE_TRACE_POINTS
> +
> +#include "bpf_trace.h"
> +

Note, it's probably best to include the above after all the other
headers. The CREATE_TRACE_POINTS might cause issues if a header has
other trace event headers included.

>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
> @@ -11,6 +15,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/ctype.h>
>  #include <linux/kprobes.h>
> +#include <linux/spinlock.h>
>  #include <linux/syscalls.h>
>  #include <linux/error-injection.h>
>  
> @@ -374,6 +379,28 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>  	}
>  }
>  
> +static DEFINE_SPINLOCK(trace_printk_lock);

I wonder if we should make this a RAW_SPINLOCK(). That way it wont
cause any issues on PREEMPT_RT if a bpf trace event is called within
other raw spinlocks.

> +
> +#define BPF_TRACE_PRINTK_SIZE   1024
> +
> +static inline int bpf_do_trace_printk(const char *fmt, ...)
> +{
> +	static char buf[BPF_TRACE_PRINTK_SIZE];
> +	unsigned long flags;
> +	va_list ap;
> +	int ret;
> +
> +	spin_lock_irqsave(&trace_printk_lock, flags);
> +	va_start(ap, fmt);
> +	ret = vsnprintf(buf, BPF_TRACE_PRINTK_SIZE, fmt, ap);
> +	va_end(ap);
> +	if (ret > 0)
> +		trace_bpf_trace_printk(buf);
> +	spin_unlock_irqrestore(&trace_printk_lock, flags);
> +
> +	return ret;
> +}
> +
>  /*
>   * Only limited trace_printk() conversion specifiers allowed:
>   * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
> @@ -483,8 +510,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>   */
>  #define __BPF_TP_EMIT()	__BPF_ARG3_TP()
>  #define __BPF_TP(...)							\
> -	__trace_printk(0 /* Fake ip */,					\
> -		       fmt, ##__VA_ARGS__)
> +	bpf_do_trace_printk(fmt, ##__VA_ARGS__)
>  
>  #define __BPF_ARG1_TP(...)						\
>  	((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))	\
> @@ -518,13 +544,20 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
>  	.arg2_type	= ARG_CONST_SIZE,
>  };
>  
> +int bpf_trace_printk_enabled;
> +
>  const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>  {
>  	/*
>  	 * this program might be calling bpf_trace_printk,
> -	 * so allocate per-cpu printk buffers
> +	 * so enable the associated bpf_trace/bpf_trace_printk event.
>  	 */
> -	trace_printk_init_buffers();
> +	if (!bpf_trace_printk_enabled) {
> +		if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))

If you just keep it enabled, it may be best to always call this. It
doesn't hurt if you call it when it is already enabled.

This is because if someone were to disable the bpf_trace_printk via
tracefs, and then load another bpf program with another
bpf_trace_printk in it, that program wont re-enable the
bpf_trace_printk trace event again do to this check.

The rest looks fine to me.

-- Steve


> +			pr_warn_ratelimited("could not enable bpf_trace_printk events");
> +		else
> +			bpf_trace_printk_enabled = 1;
> +	}
>  
>  	return &bpf_trace_printk_proto;
>  }
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

