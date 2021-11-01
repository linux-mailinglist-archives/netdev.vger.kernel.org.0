Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F233C441DAD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhKAQEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:04:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52004 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhKAQEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:04:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C0B9C1FD45;
        Mon,  1 Nov 2021 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635782533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aLrUd5dODKPXxykk4s6tizUbvYQTGhjxi6BtMoFjlTo=;
        b=Beevnq+qOaI1o8vAFTJnn8T7IFm7qLnloDGyiPfYe4vrCcoyPKxWo6ep01e49GK59NfvoX
        +bEHTUgedYzQjUYKPU1fpfRUATdJAEjtTZkGXPdTZ3uwV1FDC1eBMmw2L68O1azd6nWWp6
        eoQVLuwjkf65E74QTWOktMKXogqLGT0=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B79CCA3B94;
        Mon,  1 Nov 2021 16:02:12 +0000 (UTC)
Date:   Mon, 1 Nov 2021 17:02:12 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qiang Zhang <qiang.zhang@windriver.com>,
        robdclark <robdclark@chromium.org>,
        christian <christian@brauner.io>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v7 00/11] extend task comm from 16 to 24
Message-ID: <YYAPhE9uX7OYTlpv@alley>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
 <YX/0h7j/nDwoBA+J@alley>
 <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-11-01 22:34:30, Yafang Shao wrote:
> On Mon, Nov 1, 2021 at 10:07 PM Petr Mladek <pmladek@suse.com> wrote:
> > On Mon 2021-11-01 06:04:08, Yafang Shao wrote:
> > > 4. Print a warning if the kthread comm is still truncated.
> > >
> > > 5. What will happen to the out-of-tree tools after this change?
> > >    If the tool get task comm through kernel API, for example prctl(2),
> > >    bpf_get_current_comm() and etc, then it doesn't matter how large the
> > >    user buffer is, because it will always get a string with a nul
> > >    terminator. While if it gets the task comm through direct string copy,
> > >    the user tool must make sure the copied string has a nul terminator
> > >    itself. As TASK_COMM_LEN is not exposed to userspace, there's no
> > >    reason that it must require a fixed-size task comm.
> >
> > The amount of code that has to be updated is really high. I am pretty
> > sure that there are more potential buffer overflows left.
> >
> > You did not commented on the concerns in the thread
> > https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/
> >
> I thought Steven[1] and  Kees[2] have already clearly explained why we
> do it like that, so I didn't give any more words on it.
> 
> [1]. https://lore.kernel.org/all/20211025170503.59830a43@gandalf.local.home/

Steven was against switching task->comm[16] into a dynamically
allocated pointer. But he was not against storing longer names
separately.

> [2]. https://lore.kernel.org/all/202110251406.56F87A3522@keescook/

Honestly, I am a bit confused by Kees' answer. IMHO, he agreed that
switching task->comm[16] into a pointer was not worth it.

But I am not sure what he meant by "Agreed -- this is a small change
for what is already an "uncommon" corner case."


> > Several people suggested to use a more conservative approach.
> 
> Yes, they are Al[3] and Alexei[4].
> 
> [3]. https://lore.kernel.org/lkml/YVkmaSUxbg%2FJtBHb@zeniv-ca.linux.org.uk/

IMHO, Al suggested to store the long name separately and return it
by proc_task_name() when available.


> [4]. https://lore.kernel.org/all/CAADnVQKm0Ljj-w5PbkAu1ugLFnZRRPt-Vk-J7AhXxDD5xVompA@mail.gmail.com/

Alexei used dentry->d_iname as an exaxmple. struct dentry uses
d_iname[DNAME_INLINE_LEN] for short names. And dynamically
allocated d_name for long names, see *__d_alloc() implementation.

> > I mean
> > to keep comm[16] as is and add a new pointer to the full name. The buffer
> > for the long name might be dynamically allocated only when needed.
> >
> 
> That would add a new allocation in the fork() for the threads with a long name.
> I'm not sure if it is worth it.

The allocation will be done only when needed. IMHO, the performance is
important only for userspace processes. I am not aware of any kernel
subsystem that would heavily create and destroy kthreads.


> > The pointer might be either in task_struct or struct kthread. It might
> > be used the same way as the full name stored by workqueue kthreads.
> >
> 
> If we decide to do it like that, I think we'd better add it in
> task_struct, then it will work for all tasks.

Is it really needed for userspace processes? For example, ps shows
the information from /proc/*/cmdline instead.


> > The advantage of the separate pointer:
> >
> >    + would work for names longer than 32
> >    + will not open security holes in code
> >
> 
> Yes, those are the advantages.  And the disadvantage of it is:
> 
>  - new allocation in fork()

It should not be a problem if we do it only when necessary and only
for kthreads.

Best Regards,
Petr
