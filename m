Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093FE43B028
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhJZKiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:38:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47904 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbhJZKiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:38:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CFCFC1FD4C;
        Tue, 26 Oct 2021 10:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635244551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1eIOwvf/mMVcZwym9Rsv9K70HOPBD5q/9n5lAFwsZyI=;
        b=INOy8JbcR/E0RvXOtZ9l6kLK4ypy5b76OCI5OckfNKpFgnwhlXjEbmuL3zGAyCw8uxdvjj
        YSpBGCium6DRcUwhe5EC3/On5TQaGYvsiKMxzDZqBKy4LcBGj5EteMRwpKyc5XDj7AZPwm
        YDf9opjAXlpbqwZAzKOuC4KIFz3WjkU=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 025E8A3B85;
        Tue, 26 Oct 2021 10:35:50 +0000 (UTC)
Date:   Tue, 26 Oct 2021 12:35:47 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Zhang, Qiang" <qiang.zhang@windriver.com>, robdclark@chromium.org,
        Christian Brauner <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6 00/12] extend task comm from 16 to 24
Message-ID: <YXfaA2uSj9JIfZIl@alley>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
 <CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com>
 <20211025170503.59830a43@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025170503.59830a43@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-10-25 17:05:03, Steven Rostedt wrote:
> On Mon, 25 Oct 2021 11:10:09 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > It looks like a churn that doesn't really address the problem.
> > If we were to allow long names then make it into a pointer and use 16 byte
> > as an optimized storage for short names. Any longer name would be a pointer.
> > In other words make it similar to dentry->d_iname.
> 
> That would be quite a bigger undertaking too, as it is assumed throughout
> the kernel that the task->comm is TASK_COMM_LEN and is nul terminated. And
> most locations that save the comm simply use a fixed size string of
> TASK_COMM_LEN. Not saying its not feasible, but it would require a lot more
> analysis of the impact by changing such a fundamental part of task struct
> from a static to something requiring allocation.

I fully agree. The evolution of this patchset clearly shows how many
code paths depend on the existing behavior.


> Unless you are suggesting that we truncate like normal the 16 byte names
> (to a max of 15 characters), and add a way to hold the entire name for
> those locations that understand it.

Yup. If the problem is only with kthreads, it might be possible to
store the pointer into "struct kthread" and update proc_task_name().
It would generalize the solution already used by workqueues.
I think that something like this was mentioned in the discussion
about v1.

Best Regards,
Petr
