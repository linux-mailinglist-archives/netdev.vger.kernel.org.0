Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918F83B5F09
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhF1NhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232135AbhF1NhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 09:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C360F6141F;
        Mon, 28 Jun 2021 13:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624887274;
        bh=ExvLWOqClO9sX13cV55KLyhbaOqefGQ9NVgjvW91HcM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G8XqjEDLyMf7yPiws6v/aTmEH/Fvvqt8X6YfNn4TYi2kVGPf93lfm7abPNVg9gSUU
         BA8WhrvVbBDnyUVB+BSPMgNafGcIqEumrpxl8WnWbAZI3gYbX99T90bopduHba8JnX
         xdbpmyIsup6cFs9d81j5gPpIeblVpm6Arwml1Kb4SrztEwwmwXXaMTP5tt6ZSXNg6A
         OwNoZIMyL1RRgNfzejuNvb/r1i9BoBE0pjJdNylLTJfJP1tXSUwd/i09NmxayAlNmk
         zBP6D5Xi79x1LeZwM4dbkPovRGYUk4LJFHFl4+ACWgHTe52iGuiImK9LTcUD7XVGUr
         yIg4zXSDgBYZA==
Date:   Mon, 28 Jun 2021 22:34:30 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Qiang Wang <wangqiang.wq.frank@bytedance.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Xiongchun duan <duanxiongchun@bytedance.com>
Subject: Re: [Phishing Risk] [PATCH] kprobe: fix kretprobe stack backtrace
Message-Id: <20210628223430.8f903ea25977f5568ec1df6e@kernel.org>
In-Reply-To: <CAMZfGtWPi4CuVOtmUpy2N9J_mvp+5=gSAFvqV1nmvDKP+CAvQA@mail.gmail.com>
References: <20210625084748.18128-1-wangqiang.wq.frank@bytedance.com>
        <CAMZfGtWPi4CuVOtmUpy2N9J_mvp+5=gSAFvqV1nmvDKP+CAvQA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Jun 2021 18:24:12 +0800
Muchun Song <songmuchun@bytedance.com> wrote:

> On Fri, Jun 25, 2021 at 4:49 PM Qiang Wang
> <wangqiang.wq.frank@bytedance.com> wrote:
> >
> > We found that we couldn't get the correct kernel stack from
> > kretprobe. For example:
> >
> > bpftrace -e 'kr:submit_bio {print(kstack)}'
> > Attaching 1 probe...
> >
> >         kretprobe_trampoline+0
> >
> >         kretprobe_trampoline+0
> >
> > The problem is caused by the wrong instruction register which
> > points to the address of kretprobe_trampoline in regs.
> > So we set the real return address in instruction register.
> > Finally, we tested and successfully fixed it.
> >
> > bpftrace -e 'kr:submit_bio {print(kstack)}'
> > Attaching 1 probe...
> >
> >         ext4_mpage_readpages+475
> >         read_pages+139
> >         page_cache_ra_unbounded+417
> >         filemap_get_pages+245
> >         filemap_read+169
> >         __kernel_read+327
> >         bprm_execve+648
> >         do_execveat_common.isra.39+409
> >         __x64_sys_execve+50
> >         do_syscall_64+54
> >         entry_SYSCALL_64_after_hwframe+68
> >
> > Reported-by: Chengming Zhou <zhouchengming@bytedance.com>
> > Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
> 
> Seems like a bug. Maybe we should add a "Fixes" tag here.

No, that is not a bug in the kretprobes. If you carefully check
kretprobes provided the rp->addr as ip address. BPF just did not
use it.

Anyway, I already made a same patch in the below series.

https://lore.kernel.org/bpf/162400000592.506599.4695807810528866713.stgit@devnote2/

and you can see that the series is including below 3 patches for that change.

https://lore.kernel.org/bpf/162399997853.506599.13701157683968161733.stgit@devnote2/
https://lore.kernel.org/bpf/162399998747.506599.1115560529431673586.stgit@devnote2/
https://lore.kernel.org/bpf/162399999702.506599.16339931387573094059.stgit@devnote2/

Without these patches, this change will break other arch.

Thanks,

> 
> > ---
> >  kernel/kprobes.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index 745f08fdd..1130381ca 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -1899,6 +1899,9 @@ unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
> >         current->kretprobe_instances.first = node->next;
> >         node->next = NULL;
> >
> > +       /* Kretprobe handler expects address is the real return address */
> > +       instruction_pointer_set(regs, (unsigned long)correct_ret_addr);
> > +
> >         /* Run them..  */
> >         while (first) {
> >                 ri = container_of(first, struct kretprobe_instance, llist);
> > --
> > 2.20.1
> >


-- 
Masami Hiramatsu <mhiramat@kernel.org>
