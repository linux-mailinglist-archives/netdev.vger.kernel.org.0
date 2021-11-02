Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A802144250A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhKBBV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhKBBVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 21:21:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF35F61051;
        Tue,  2 Nov 2021 01:18:47 +0000 (UTC)
Date:   Mon, 1 Nov 2021 21:18:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
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
Message-ID: <20211101211845.20ff5b2e@gandalf.local.home>
In-Reply-To: <CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
        <YX/0h7j/nDwoBA+J@alley>
        <CALOAHbA61RyGVzG8SVcNG=0rdqnUCt4AxCKmtuxRnbS_SH=+MQ@mail.gmail.com>
        <YYAPhE9uX7OYTlpv@alley>
        <CALOAHbAx55AUo3bm8ZepZSZnw7A08cvKPdPyNTf=E_tPqmw5hw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 09:09:50 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> So if no one against, I will do it in two steps,
> 
> 1. Send the task comm cleanups in a separate patchset named "task comm cleanups"
>     This patchset includes patch #1, #2, #4,  #5, #6, #7 and #9.
>     Cleaning them up can make it less error prone, and it will be
> helpful if we want to extend task comm in the future :)

Agreed.

> 
> 2.  Keep the current comm[16] as-is and introduce a separate pointer
> to store kthread's long name

I'm OK with this. Hopefully more would chime in too.

>      Now we only care about kthread, so we can put the pointer into a
> kthread specific struct.
>      For example in the struct kthread, or in kthread->data (which may
> conflict with workqueue).

No, add a new field to the structure. "full_name" or something like that.
I'm guessing it should be NULL if the name fits in TASK_COMM_LEN and
allocated if the name had to be truncated.

Do not overload data with this. That will just make things confusing.
There's not that many kthreads, where an addition of an 8 byte pointer is
going to cause issues.

> 
>      And then dynamically allocate a longer name if it is truncated,
> for example,
>      __kthread_create_on_node
>          len = vsnprintf(name, sizeof(name), namefmt, args);
>          if (len >= TASK_COMM_LEN) {
>              /* create a longer name */

And make sure you have it fail the kthread allocation if it fails to
allocate.

>          }
> 
>      And then we modify proc_task_name(), so the user can get
> kthread's longer name via /proc/[pid]/comm.

Agreed.

> 
>      And then free the allocated memory when the kthread is destroyed.

Correct.

Thanks,

-- Steve
