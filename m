Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70B43B304
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbhJZNOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230324AbhJZNOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 09:14:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A7360C49;
        Tue, 26 Oct 2021 13:12:13 +0000 (UTC)
Date:   Tue, 26 Oct 2021 09:12:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
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
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH v6 08/12] tools/bpf/bpftool/skeleton: make it adopt to
 task comm size change
Message-ID: <20211026091211.569a7ba2@gandalf.local.home>
In-Reply-To: <CALOAHbDPs-pbr5CnmuRv+b+CgMdEkzi4Yr2fSO9pKCE-chr3Yg@mail.gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
        <20211025083315.4752-9-laoar.shao@gmail.com>
        <202110251421.7056ACF84@keescook>
        <CALOAHbDPs-pbr5CnmuRv+b+CgMdEkzi4Yr2fSO9pKCE-chr3Yg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 10:18:51 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> > So, if we're ever going to copying these buffers out of the kernel (I
> > don't know what the object lifetime here in bpf is for "e", etc), we
> > should be zero-padding (as get_task_comm() does).
> >
> > Should this, instead, be using a bounce buffer?  
> 
> The comment in bpf_probe_read_kernel_str_common() says
> 
>   :      /*
>   :       * The strncpy_from_kernel_nofault() call will likely not fill the
>   :       * entire buffer, but that's okay in this circumstance as we're probing
>   :       * arbitrary memory anyway similar to bpf_probe_read_*() and might
>   :       * as well probe the stack. Thus, memory is explicitly cleared
>   :       * only in error case, so that improper users ignoring return
>   :       * code altogether don't copy garbage; otherwise length of string
>   :       * is returned that can be used for bpf_perf_event_output() et al.
>   :       */
> 
> It seems that it doesn't matter if the buffer is filled as that is
> probing arbitrary memory.
> 
> >
> > get_task_comm(comm, task->group_leader);  
> 
> This helper can't be used by the BPF programs, as it is not exported to BPF.
> 
> > bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm), comm);

I guess Kees is worried that e.comm will have something exported to user
space that it shouldn't. But since e is part of the BPF program, does the
BPF JIT take care to make sure everything on its stack is zero'd out, such
that a user BPF couldn't just read various items off its stack and by doing
so, see kernel memory it shouldn't be seeing?

I'm guessing it does, otherwise this would be a bigger issue than this
patch series.

-- Steve
