Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD4930A4FE
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhBAKIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhBAKHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:07:15 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C9BC061574
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 02:06:28 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id d85so15623654qkg.5
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 02:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sjt/JjpcscfEvtBP7EMVUaDK8j1N22A9/cE7A8z1fNQ=;
        b=RWGlo0LF/xf0B6XMXJt4uEKHEI1PMWjoAzhk2jM1knlpTyoxZlXjsTGiphTN2+gWRQ
         CfcfBynFycq6HShZmXTMtsL32rhWghYM7wEOPYcBCLQqoX5/zLN0JVOmCedt7+b4ylhV
         aYFI0MlGniLS4Po7+bLxc0k6dfeNVZnjJPY6VSHXW4a7QEzI3yLS2JAx1S8qUgnCeySe
         JTUGK5hONej427H1zqtvZoVMKjdHLNMYwJ/I/43/3VsWsjpQS09AuRuBojFy4GWeDPCu
         EzNru2aRUgwTxsodEFirvxS0kN93jAd+IeehH1fEA8oXWAG0Z5bJIz9k6KsOAB4c/ayt
         +QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sjt/JjpcscfEvtBP7EMVUaDK8j1N22A9/cE7A8z1fNQ=;
        b=qRPrtXP6fEAFt7UC0utOxdGuDq99hR964nUAS4dkY+DvK0NIzii/U5O2SALr0nfWmm
         qdpdJDTDff/v6BkIDPCLyScCdAT/JveIcxSMpsW0skVlR7KuatMxic77OFDrkkmCILpK
         /o0qUy1Lp813NDrMggOAsyxFVfLGm6pGGH/BRxLh1rt6ggcI/qozrxt9ciRPshJD+oLX
         jT4GLe7WEfuLYiFb9qLAeCWKwz14nWwjdPteS/LEXUNUCRusc9KUgeJeka8RnZlzk0s1
         0hJUYg3UWJw2zx/eBM21QjqJNntaUHdpxwId+/CwiufBM6oydSlrw+tYtn37LHWXKQ4E
         Vlbg==
X-Gm-Message-State: AOAM5338XVIVXZuqs2kjfR0yjvEpEwN0L4oxnrpkuxPpYDu6of6sPOYo
        cQ4AbbdMxR/6+OOyj41ujXKo8arC5SM0lYpCYBJGUg==
X-Google-Smtp-Source: ABdhPJz1neDI6y2opCjejp39+RFPmdlUHPXrFefxOn9wklgPLmQPMf8ui0W8o2qIpXB9V8ohhvWgsAt8x04qGTAFxyU=
X-Received: by 2002:a05:620a:918:: with SMTP id v24mr15329179qkv.350.1612173987508;
 Mon, 01 Feb 2021 02:06:27 -0800 (PST)
MIME-Version: 1.0
References: <CACT4Y+YJp0t0HA3+wDsAVxgTK4J+Pvht-J4-ENkOtS=C=Fhtzg@mail.gmail.com>
 <YBfPAvBa8bbSU2nZ@hirez.programming.kicks-ass.net>
In-Reply-To: <YBfPAvBa8bbSU2nZ@hirez.programming.kicks-ass.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 1 Feb 2021 11:06:16 +0100
Message-ID: <CACT4Y+YGY+fanogUFYXxpGZsCp53gjUi7Xua4Bmvs6gAvSfLoA@mail.gmail.com>
Subject: Re: corrupted pvqspinlock in htab_map_update_elem
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 10:51 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sun, Jan 31, 2021 at 09:42:53AM +0100, Dmitry Vyukov wrote:
> > Hi,
> >
> > I am testing the following the program:
> > https://gist.github.com/dvyukov/e5c0a8ef220ef856363c1080b0936a9e
> > on the latest upstream 6642d600b541b81931fb1ab0c041b0d68f77be7e and
> > getting the following crash. Config is:
> > https://gist.github.com/dvyukov/16d9905e5ef35e44285451f1d330ddbc
> >
> > The program updates a bpf map from a program called on hw breakpoint
> > hit. Not sure if it's a bpf issue or a perf issue. This time it is not
> > a fuzzer workload, I am trying to do something useful :)
>
> Something useful and BPF don't go together as far as I'm concerned.
>
> > ------------[ cut here ]------------
> > pvqspinlock: lock 0xffffffff8f371d80 has corrupted value 0x0!
> > WARNING: CPU: 3 PID: 8771 at kernel/locking/qspinlock_paravirt.h:498
> > __pv_queued_spin_unlock_slowpath+0x22e/0x2b0
> > kernel/locking/qspinlock_paravirt.h:498
> > Modules linked in:
> > CPU: 3 PID: 8771 Comm: a.out Not tainted 5.11.0-rc5+ #71
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> > rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:__pv_queued_spin_unlock_slowpath+0x22e/0x2b0
> > kernel/locking/qspinlock_paravirt.h:498
> > Code: ea 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2
> > 75 62 41 8b 55 00 4c 89 ee 48 c7 c7 20 6b 4c 89 e8 72 d3 5f 07 <0f> 0b
> > e9 6cc
> > RSP: 0018:fffffe00000c17b0 EFLAGS: 00010086
> > RAX: 0000000000000000 RBX: ffffffff8f3b5660 RCX: 0000000000000000
> > RDX: ffff8880150222c0 RSI: ffffffff815b624d RDI: fffffbc0000182e8
> > RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> > R10: ffffffff817de94f R11: 0000000000000000 R12: ffff8880150222c0
> > R13: ffffffff8f371d80 R14: ffff8880181fead8 R15: 0000000000000000
> > FS:  00007fa5b51f0700(0000) GS:ffff88802cf80000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000002286908 CR3: 0000000015b24000 CR4: 0000000000750ee0
> > DR0: 00000000004cb3d4 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> > Call Trace:
> >  <#DB>
> >  __raw_callee_save___pv_queued_spin_unlock_slowpath+0x11/0x20
> >  .slowpath+0x9/0xe
> >  pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:559 [inline]
> >  queued_spin_unlock arch/x86/include/asm/qspinlock.h:56 [inline]
> >  lockdep_unlock+0x10e/0x290 kernel/locking/lockdep.c:124
> >  debug_locks_off_graph_unlock kernel/locking/lockdep.c:165 [inline]
> >  print_usage_bug kernel/locking/lockdep.c:3710 [inline]
>
> Ha, I think you hit a bug in lockdep. But it was about to tell you you
> can't go take locks from NMI context that are also used outside of it.

Mkay. Perf calls a BPF program from NMI context. Should that program
type be significantly restricted? But even if maps can't be used, is
there anything useful a program invoked from such context can do at
all?

> >  verify_lock_unused kernel/locking/lockdep.c:5374 [inline]
> >  lock_acquire kernel/locking/lockdep.c:5433 [inline]
> >  lock_acquire+0x471/0x720 kernel/locking/lockdep.c:5407
> >  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
> >  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
> >  htab_lock_bucket kernel/bpf/hashtab.c:175 [inline]
> >  htab_map_update_elem+0x1f0/0x790 kernel/bpf/hashtab.c:1023
> >  bpf_prog_60236c52b8017ad1+0x8e/0xab4
> >  bpf_dispatcher_nop_func include/linux/bpf.h:651 [inline]
> >  bpf_overflow_handler+0x192/0x5b0 kernel/events/core.c:9755
> >  __perf_event_overflow+0x13c/0x370 kernel/events/core.c:8979
> >  perf_swevent_overflow kernel/events/core.c:9055 [inline]
> >  perf_swevent_event+0x347/0x550 kernel/events/core.c:9083
> >  perf_bp_event+0x1a2/0x1c0 kernel/events/core.c:9932
> >  hw_breakpoint_handler arch/x86/kernel/hw_breakpoint.c:535 [inline]
> >  hw_breakpoint_exceptions_notify+0x18a/0x3b0 arch/x86/kernel/hw_breakpoint.c:567
> >  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
> >  atomic_notifier_call_chain+0x8d/0x170 kernel/notifier.c:217
> >  notify_die+0xda/0x170 kernel/notifier.c:548
> >  notify_debug+0x20/0x30 arch/x86/kernel/traps.c:842
> >  exc_debug_kernel arch/x86/kernel/traps.c:902 [inline]
> >  exc_debug+0x103/0x140 arch/x86/kernel/traps.c:998
> >  asm_exc_debug+0x19/0x30 arch/x86/include/asm/idtentry.h:598
