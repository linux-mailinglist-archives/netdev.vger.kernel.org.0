Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47510437093
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 05:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhJVDyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 23:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJVDym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 23:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C71CA610CF;
        Fri, 22 Oct 2021 03:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634874745;
        bh=ByPDUyyAdTZE18OJTBUU3plft6+xirKjXsLLJY6EG4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Erv9Pl/4IB6ddoKt7U+ys6oUmxIw4NAUGcRqjppUmOg1Tet5LoByq/PSYBUnvyyTt
         kcFdEWENBmrOwRzcMY0+heQRw4xuP9ELySWKXNYreSJSFmHq5kasQ2cTnad+SM2oio
         9cugJhs/Hk5wtliuKyETSXFu/rC18+trbWQM37Eo=
Date:   Thu, 21 Oct 2021 20:52:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        valentin.schneider@arm.com, qiang.zhang@windriver.com,
        robdclark@chromium.org, christian@brauner.io,
        dietmar.eggemann@arm.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com
Subject: Re: [PATCH v5 00/15] extend task comm from 16 to 24 for
 CONFIG_BASE_FULL
Message-Id: <20211021205222.714a76c854cc0e7a7d6db890@linux-foundation.org>
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 03:45:07 +0000 Yafang Shao <laoar.shao@gmail.com> wrote:

> This patchset changes files among many subsystems. I don't know which
> tree it should be applied to, so I just base it on Linus's tree.

I can do that ;)

> There're many truncated kthreads in the kernel, which may make trouble
> for the user, for example, the user can't get detailed device
> information from the task comm.

That sucked of us.

> This patchset tries to improve this problem fundamentally by extending
> the task comm size from 16 to 24. In order to do that, we have to do
> some cleanups first.

It's at v5 and there's no evidence of review activity?  C'mon, folks!

> 1. Make the copy of task comm always safe no matter what the task
> comm size is. For example,
> 
>   Unsafe                 Safe
>   strlcpy                strscpy_pad
>   strncpy                strscpy_pad
>   bpf_probe_read_kernel  bpf_probe_read_kernel_str
>                          bpf_core_read_str
>                          bpf_get_current_comm
>                          perf_event__prepare_comm
>                          prctl(2)
> 
> 2. Replace the old hard-coded 16 with a new macro TASK_COMM_LEN_16 to
> make it more grepable.
> 
> 3. Extend the task comm size to 24 for CONFIG_BASE_FULL case and keep it
> as 16 for CONFIG_BASE_SMALL.

Is this justified?  How much simpler/more reliable/more maintainable/
would the code be if we were to make CONFIG_BASE_SMALL suffer with the
extra 8 bytes?

> 4. Print a warning if the kthread comm is still truncated.

