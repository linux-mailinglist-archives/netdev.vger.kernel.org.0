Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4B543A5BB
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhJYVXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbhJYVXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:23:09 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA2EC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:20:46 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m21so11931658pgu.13
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NfrrVRCciJICOev8gMVBuAQquLy9VSfP1uEbEqVM24w=;
        b=H2EpbH8CK+eyq1Svymbl0Dbfo2kpVmHsKpcpd8aOlyPgS9egcampbijVN2rYBa4Rgn
         p7a+kyLwjWzm6IJXev9oy30YE4CPP1J9p6CFzIEnGFOIGhjk7GBbSz5REtZqbByQpuoA
         zURwII3gv6rc2pNshcM6TV+ht6kflPX4D3tGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NfrrVRCciJICOev8gMVBuAQquLy9VSfP1uEbEqVM24w=;
        b=QnWMJEuipeWt6If4JNSKkZdt/gypIpMhQpYu6jwgO+gz6uCh+sLhScyV6y70kWZHB1
         3UF49c+n3FA0ciz7fyAHhWsK9Crtlb/GNJUObg7oK+DUrJtYm0UyxZCizvCUY4GzqdMz
         WIu1TJ36iN1LnhgCjDV7w/FX5+Im3PSWxL6fBm98EfWqcTTJG4KJlVsMo3eMyDHYE5ed
         RuGqkcB+2WGv7BfHw4KmKBRk5E/n7RTxCTPkWEna9Gvomws7Wi5puyXAIGStyY29jCUE
         hX10fF1YaOmwQKP4MnUALz4cqFlDKXG4Xar6KffUtvf1+qah4lI8VbyZP1UgVjkxMcKt
         MLiQ==
X-Gm-Message-State: AOAM530pL4+WqR0PdidWaOmMSrR4ZqmPt5fOyrG4KVbDmyzChuoCAD+k
        OW0fDNN1YntAHwV3U5kLDgqhUg==
X-Google-Smtp-Source: ABdhPJyh2X1uSEHHHblNKO5f1PiBaklcfwz/rKHbsu1YaXrG1EqQDih9hnPhQ9fPP+X9SJoGD+kUag==
X-Received: by 2002:aa7:8d88:0:b0:47b:d965:fbb2 with SMTP id i8-20020aa78d88000000b0047bd965fbb2mr17526856pfr.16.1635196846138;
        Mon, 25 Oct 2021 14:20:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u4sm20477372pfh.147.2021.10.25.14.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 14:20:45 -0700 (PDT)
Date:   Mon, 25 Oct 2021 14:20:45 -0700
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
Subject: Re: [PATCH v6 06/12] samples/bpf/test_overhead_kprobe_kern: make it
 adopt to task comm size change
Message-ID: <202110251420.9D2C7731@keescook>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-7-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025083315.4752-7-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:33:09AM +0000, Yafang Shao wrote:
> bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
> we don't care about if the dst size is big enough. This patch also
> replaces the hard-coded 16 with TASK_COMM_LEN to make it adopt to task
> comm size change.
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

As these are samples, I guess it's fine to change their sizes.

Reviewed-by: Kees Cook <keescook@chromium.org>

> ---
>  samples/bpf/test_overhead_kprobe_kern.c | 11 ++++++-----
>  samples/bpf/test_overhead_tp_kern.c     |  5 +++--
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
> index f6d593e47037..8fdd2c9c56b2 100644
> --- a/samples/bpf/test_overhead_kprobe_kern.c
> +++ b/samples/bpf/test_overhead_kprobe_kern.c
> @@ -6,6 +6,7 @@
>   */
>  #include <linux/version.h>
>  #include <linux/ptrace.h>
> +#include <linux/sched.h>
>  #include <uapi/linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
>  #include <bpf/bpf_tracing.h>
> @@ -22,17 +23,17 @@ int prog(struct pt_regs *ctx)
>  {
>  	struct signal_struct *signal;
>  	struct task_struct *tsk;
> -	char oldcomm[16] = {};
> -	char newcomm[16] = {};
> +	char oldcomm[TASK_COMM_LEN] = {};
> +	char newcomm[TASK_COMM_LEN] = {};
>  	u16 oom_score_adj;
>  	u32 pid;
>  
>  	tsk = (void *)PT_REGS_PARM1(ctx);
>  
>  	pid = _(tsk->pid);
> -	bpf_probe_read_kernel(oldcomm, sizeof(oldcomm), &tsk->comm);
> -	bpf_probe_read_kernel(newcomm, sizeof(newcomm),
> -			      (void *)PT_REGS_PARM2(ctx));
> +	bpf_probe_read_kernel_str(oldcomm, sizeof(oldcomm), &tsk->comm);
> +	bpf_probe_read_kernel_str(newcomm, sizeof(newcomm),
> +				  (void *)PT_REGS_PARM2(ctx));
>  	signal = _(tsk->signal);
>  	oom_score_adj = _(signal->oom_score_adj);
>  	return 0;
> diff --git a/samples/bpf/test_overhead_tp_kern.c b/samples/bpf/test_overhead_tp_kern.c
> index eaa32693f8fc..80edadacb692 100644
> --- a/samples/bpf/test_overhead_tp_kern.c
> +++ b/samples/bpf/test_overhead_tp_kern.c
> @@ -4,6 +4,7 @@
>   * modify it under the terms of version 2 of the GNU General Public
>   * License as published by the Free Software Foundation.
>   */
> +#include <linux/sched.h>
>  #include <uapi/linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
>  
> @@ -11,8 +12,8 @@
>  struct task_rename {
>  	__u64 pad;
>  	__u32 pid;
> -	char oldcomm[16];
> -	char newcomm[16];
> +	char oldcomm[TASK_COMM_LEN];
> +	char newcomm[TASK_COMM_LEN];
>  	__u16 oom_score_adj;
>  };
>  SEC("tracepoint/task/task_rename")
> -- 
> 2.17.1
> 

-- 
Kees Cook
