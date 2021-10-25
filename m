Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A4543A5AA
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 23:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhJYVSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbhJYVSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 17:18:53 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3475AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:16:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t184so12202484pfd.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WykFcEu3gun2Q4Ung304wd/4WeKNK4r+geKtd+xDG0A=;
        b=hWzvmP79GbX+2eowlYcyfK+E8HA2QNjpW0MJuY8fPca5jpPKczyuxL99sDKZ2l+n/X
         SxAyl0TSq3Ea0DALPnln0NZpNxMYwlTDA5PUU+7iHnGLqD0pZGV4hk9D1ME0tSJXqtXk
         ZUpoQQOloYhp8IUHhi9LljGkNAk/40P4+klD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WykFcEu3gun2Q4Ung304wd/4WeKNK4r+geKtd+xDG0A=;
        b=nKfHBU10dZBxkbJ+Mcx6nqwrknsaoHOB5Qf0lIo55MGx0SP8x8JNzy85LPU5ZJ/Hyq
         MpCKlReovKyApO/Td0wsRVjXWS2IqblEF/SqfCfpr0NfNiWELcbwlzpKphaDXy+ob+Mt
         /o8LpZKAVxc9sxbcQLnRB8kL1yB6EwcqOOxnLMU0kIing2FMPzQ7okzPCaWyt1buek7v
         bThxFOUJSBH7p9lxgJ7xhBz1bl0NGHFFWyRO6gVZXtWAyyRx8arKsURPsHgWiztWdNBB
         A6FpXfN33SdQfQjtK5ZBDG0EyTpjIq1ZCyaE3I0X1QirzvuStv6NAsfq46QJq/9W3n5C
         NqZA==
X-Gm-Message-State: AOAM533JoyWAT50sNb3dGxsRUhIdOcl0Q5z2Ryalxr8JnPkjjBhY85YS
        BImcuOkSoQrnJeR8hw/qNTqe0Q==
X-Google-Smtp-Source: ABdhPJxmKiP4mIzK9EfWIWfSZIlru2lTN121HsO8gbDbxDQk4Vut9f2sGsYffv4goiE6GSJh6quc/g==
X-Received: by 2002:a62:445:0:b0:44c:3b5b:f680 with SMTP id 66-20020a620445000000b0044c3b5bf680mr21808807pfe.30.1635196590644;
        Mon, 25 Oct 2021 14:16:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d15sm22785970pfu.12.2021.10.25.14.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 14:16:30 -0700 (PDT)
Date:   Mon, 25 Oct 2021 14:16:29 -0700
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
Subject: Re: [PATCH v6 04/12] drivers/infiniband: make setup_ctxt always get
 a nul terminated task comm
Message-ID: <202110251415.9AD37837@keescook>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <20211025083315.4752-5-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025083315.4752-5-laoar.shao@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 08:33:07AM +0000, Yafang Shao wrote:
> Use strscpy_pad() instead of strlcpy() to make the comm always nul
> terminated. As the comment above the hard-coded 16, we can replace it
> with TASK_COMM_LEN, then it will adopt to the comm size change.
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
>  drivers/infiniband/hw/qib/qib.h          | 2 +-
>  drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
> index 9363bccfc6e7..a8e1c30c370f 100644
> --- a/drivers/infiniband/hw/qib/qib.h
> +++ b/drivers/infiniband/hw/qib/qib.h
> @@ -196,7 +196,7 @@ struct qib_ctxtdata {
>  	pid_t pid;
>  	pid_t subpid[QLOGIC_IB_MAX_SUBCTXT];
>  	/* same size as task_struct .comm[], command that opened context */
> -	char comm[16];
> +	char comm[TASK_COMM_LEN];
>  	/* pkeys set by this use of this ctxt */
>  	u16 pkeys[4];
>  	/* so file ops can get at unit */
> diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
> index 63854f4b6524..7ab2b448c183 100644
> --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> @@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
>  	rcd->tid_pg_list = ptmp;
>  	rcd->pid = current->pid;
>  	init_waitqueue_head(&dd->rcd[ctxt]->wait);
> -	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
> +	strscpy_pad(rcd->comm, current->comm, sizeof(rcd->comm));

This should use (the adjusted) get_task_comm() instead of leaving this
open-coded.

>  	ctxt_fp(fp) = rcd;
>  	qib_stats.sps_ctxts++;
>  	dd->freectxts--;
> -- 
> 2.17.1
> 

-- 
Kees Cook
