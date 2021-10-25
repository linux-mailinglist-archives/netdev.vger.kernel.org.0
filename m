Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E369343A5E2
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhJYVcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhJYVcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:32:07 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B9DC061348
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:29:44 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l186so5529905pge.7
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nOMQKpZZuSWv5pYnk/aTwt2ZQSi3AA5V7IIeovAWdmo=;
        b=N/e+rJPgnPh6hCdB5QpblvsKgRB8F9m6xHRfbB+zBumWlQAeIAJ+MUK6vKcsYfvO6a
         BWeC06041L5efzCzGqTyh1VFtW745Bw8uGfEyzGEcikJD7ZAwiwMsDwouRDBu61Rir6m
         15Q0nVvJ2Te8Psh674RLvvscD06V1NdjhYk5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nOMQKpZZuSWv5pYnk/aTwt2ZQSi3AA5V7IIeovAWdmo=;
        b=arM48fQSmL+/qjL6av10cV2jqm+zMKrNIKCgkdYa+PxrRMcIXterGf/06v6t30vK3p
         kMuKDyEz0T74Uv9nxcdC/xVbxlUnaiTuOFix9JZ4bv1wQTxK+2aAhbJUTUltRMhlBIdS
         6H2hPFXaYZwQQUGdc8Nr1ELMPeEvrvv8Bdb7l0SVYv6QxNKcj9L6you7JGjIoPR7wJij
         6gYBIFEjabZW1qYpF3nQe/ShAa6+VHDXHn9BzgSObXlv8ia0vsZ/FLtOO3KtWs0luURc
         2az0TpNqqWU/QTZWbrb/bM8TuVx6aUfGPG842X7g2eIWLvI4u6hklxjEnKcHV0HIrWF4
         y4wA==
X-Gm-Message-State: AOAM531rq7wDe7UirDUPYCzn0Sklyzgsrt50Qf1XwRwuIhA3LEMNy8SC
        DcTQIBITP6Q9TwY7w23dfq/rnA==
X-Google-Smtp-Source: ABdhPJylCINuEW5HMAomQ2Sb8A/Mzy7iRmjXW2wPZwzIwDqx3aznemiayZaeelO4ogFK9kyPg6rTAw==
X-Received: by 2002:a63:131c:: with SMTP id i28mr15578346pgl.396.1635197384325;
        Mon, 25 Oct 2021 14:29:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r25sm16507932pge.61.2021.10.25.14.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 14:29:43 -0700 (PDT)
Date:   Mon, 25 Oct 2021 14:29:43 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     akpm@linux-foundation.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        valentin.schneider@arm.com, qiang.zhang@windriver.com,
        robdclark@chromium.org, christian@brauner.io,
        dietmar.eggemann@arm.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH v6 10/12] tools/testing/selftests/bpf: make it adopt to
 task comm size change
Message-ID: <202110251428.B891AD6ACB@keescook>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-11-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025083315.4752-11-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:33:13AM +0000, Yafang Shao wrote:
> The hard-coded 16 is used in various bpf progs. These progs get task
> comm either via bpf_get_current_comm() or prctl() or
> bpf_core_read_str(), all of which can work well even if the task comm size
> is changed.
> 
> In these BPF programs, one thing to be improved is the
> sched:sched_switch tracepoint args. As the tracepoint args are derived
> from the kernel, we'd better make it same with the kernel. So the macro
> TASK_COMM_LEN is converted to type enum, then all the BPF programs can
> get it through BTF.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/sched.h                                   | 9 +++++++--
>  tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
>  tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
>  3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c1a927ddec64..124538db792c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -274,8 +274,13 @@ struct task_group;
>  
>  #define get_current_state()	READ_ONCE(current->__state)
>  
> -/* Task command name length: */
> -#define TASK_COMM_LEN			16
> +/*
> + * Define the task command name length as enum, then it can be visible to
> + * BPF programs.
> + */
> +enum {
> +	TASK_COMM_LEN = 16,
> +};
>  
>  extern void scheduler_tick(void);
>  
> diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> index 00ed48672620..e9b602a6dc1b 100644
> --- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> +++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (c) 2018 Facebook
>  
> -#include <linux/bpf.h>
> +#include <vmlinux.h>

Why is this change needed here and below?

>  #include <bpf/bpf_helpers.h>
>  
>  #ifndef PERF_MAX_STACK_DEPTH
> @@ -41,11 +41,11 @@ struct {
>  /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
>  struct sched_switch_args {
>  	unsigned long long pad;
> -	char prev_comm[16];
> +	char prev_comm[TASK_COMM_LEN];
>  	int prev_pid;
>  	int prev_prio;
>  	long long prev_state;
> -	char next_comm[16];
> +	char next_comm[TASK_COMM_LEN];
>  	int next_pid;
>  	int next_prio;
>  };
> diff --git a/tools/testing/selftests/bpf/progs/test_tracepoint.c b/tools/testing/selftests/bpf/progs/test_tracepoint.c
> index 4b825ee122cf..f21982681e28 100644
> --- a/tools/testing/selftests/bpf/progs/test_tracepoint.c
> +++ b/tools/testing/selftests/bpf/progs/test_tracepoint.c
> @@ -1,17 +1,17 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (c) 2017 Facebook
>  
> -#include <linux/bpf.h>
> +#include <vmlinux.h>
>  #include <bpf/bpf_helpers.h>
>  
>  /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
>  struct sched_switch_args {
>  	unsigned long long pad;
> -	char prev_comm[16];
> +	char prev_comm[TASK_COMM_LEN];
>  	int prev_pid;
>  	int prev_prio;
>  	long long prev_state;
> -	char next_comm[16];
> +	char next_comm[TASK_COMM_LEN];
>  	int next_pid;
>  	int next_prio;
>  };
> -- 
> 2.17.1
> 

-- 
Kees Cook
