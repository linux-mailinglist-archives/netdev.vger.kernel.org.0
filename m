Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4DF43A5C4
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhJYVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbhJYVXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:23:50 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECD6C061243
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:21:27 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 83so5725466pgc.8
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dg+3da77xCN0ept3lU6Adg5MAj44I6g+k6oh+Yv/Wmk=;
        b=ZZAE5vvBlXBqmnqPeVDMpzNlRMG4f8aUTMM11B3Wt0yaKexrHt55FQmO5u1fD7bidR
         02xhl5QvTcmR3cGt0oq36GHl7u+9soV9E6KhT6dXaK6gGrqfTsgCADyJ2v6e5SSMny1K
         kHJTuEDYeo3h4PCPdtNNG1VGr+EIBO7xWhzuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dg+3da77xCN0ept3lU6Adg5MAj44I6g+k6oh+Yv/Wmk=;
        b=e7jprk2h6bPXiUOtipY1REgW9EZk8p6OMBlnuHOiy6iwFm3SqJu27frSKXj2VwCa71
         9RezzDq5Hb2iDJ21SLXq437dD6JHq4l/zhVhAnRkJEtr01kJhY9TQvDIFk4eQPlvA95Q
         nYAVjsFI5kVdVf/fbScK4p+shDc6qDe4lV8YF7xlNVCAUybKJrhIJQEf4KTfgb93b2QT
         0fMN3bAOSu8knVazk0uCcaB1Nh9nWcLOKwZwWeZGJsmZaV2aLHye80dEmiuBxiL8i+3S
         obZtsymB4eXaGyWT9WM3iLgmNVzTse/SDZpLCmcG9nmJfsgVMStMtIPXcT1iyedLgXG2
         xN+g==
X-Gm-Message-State: AOAM531PI/qC+ela/Q2IosK6shwrRB1H31HQ3igiB4bx7JRwM/EiXG81
        cBsmzzP8vaY+PByuiCRqaysYew==
X-Google-Smtp-Source: ABdhPJwuFvhpOg9qcPmPW8fWT61xDymkszr5XQdULAP3e/U/Jqkxh9G7sdKWk3bNge4o+fhW5E7j4Q==
X-Received: by 2002:a63:7c52:: with SMTP id l18mr9384968pgn.112.1635196887256;
        Mon, 25 Oct 2021 14:21:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j3sm20621719pfu.218.2021.10.25.14.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 14:21:26 -0700 (PDT)
Date:   Mon, 25 Oct 2021 14:21:26 -0700
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
Subject: Re: [PATCH v6 07/12] samples/bpf/offwaketime_kern: make sched_switch
 tracepoint args adopt to comm size change
Message-ID: <202110251421.0CD56F8@keescook>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-8-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025083315.4752-8-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:33:10AM +0000, Yafang Shao wrote:
> The sched:sched_switch tracepoint is derived from kernel, we should make
> its args compitable with the kernel.
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
>  samples/bpf/offwaketime_kern.c | 4 ++--

Seems this should be merged with the prior bpf samples patch?

-Kees

>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
> index 4866afd054da..eb4d94742e6b 100644
> --- a/samples/bpf/offwaketime_kern.c
> +++ b/samples/bpf/offwaketime_kern.c
> @@ -113,11 +113,11 @@ static inline int update_counts(void *ctx, u32 pid, u64 delta)
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
