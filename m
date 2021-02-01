Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E1B30A4A4
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhBAJvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhBAJvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:51:51 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C84CC061573;
        Mon,  1 Feb 2021 01:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zkTRr0sCMnysz6iecuNbFCZaIOk5DpKkSAujEN3P+uw=; b=ilrwWalYZUfqfHIIcNoXA/egVX
        SXe5c06TutJ++zLKBfBZUkU0fLhl8fdOuSz1lEjP7Zynan6Gd1jJJ3dbcA4gYIJeRFsqEkSXKvks7
        zWkNhrtEyKQN8qOHiZQ+RfVqKz1YkqKAtrV+7le7n7MwjlWiYBEeQeAneYCQgjS57UNx6PsED2sxs
        HO0929v1SD8QLmyrrnXUu2Db7XOnhzq7Sw7gSHKaWIfgGO08b2Nsos6qGvFJe2pGtBxLETuVRr2WA
        UtvR8SEPlnkeCKY4OO1xAqSakYOk2fcSLyUT18HiTMKnVUZHC3mIu56wH2rLH7xWM3+Bc6uMDadod
        COh+3rLQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l6VrH-0001hu-Or; Mon, 01 Feb 2021 09:51:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7D5C63011FE;
        Mon,  1 Feb 2021 10:50:58 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5C8E62B802286; Mon,  1 Feb 2021 10:50:58 +0100 (CET)
Date:   Mon, 1 Feb 2021 10:50:58 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: corrupted pvqspinlock in htab_map_update_elem
Message-ID: <YBfPAvBa8bbSU2nZ@hirez.programming.kicks-ass.net>
References: <CACT4Y+YJp0t0HA3+wDsAVxgTK4J+Pvht-J4-ENkOtS=C=Fhtzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YJp0t0HA3+wDsAVxgTK4J+Pvht-J4-ENkOtS=C=Fhtzg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 09:42:53AM +0100, Dmitry Vyukov wrote:
> Hi,
> 
> I am testing the following the program:
> https://gist.github.com/dvyukov/e5c0a8ef220ef856363c1080b0936a9e
> on the latest upstream 6642d600b541b81931fb1ab0c041b0d68f77be7e and
> getting the following crash. Config is:
> https://gist.github.com/dvyukov/16d9905e5ef35e44285451f1d330ddbc
> 
> The program updates a bpf map from a program called on hw breakpoint
> hit. Not sure if it's a bpf issue or a perf issue. This time it is not
> a fuzzer workload, I am trying to do something useful :)

Something useful and BPF don't go together as far as I'm concerned.

> ------------[ cut here ]------------
> pvqspinlock: lock 0xffffffff8f371d80 has corrupted value 0x0!
> WARNING: CPU: 3 PID: 8771 at kernel/locking/qspinlock_paravirt.h:498
> __pv_queued_spin_unlock_slowpath+0x22e/0x2b0
> kernel/locking/qspinlock_paravirt.h:498
> Modules linked in:
> CPU: 3 PID: 8771 Comm: a.out Not tainted 5.11.0-rc5+ #71
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
> RIP: 0010:__pv_queued_spin_unlock_slowpath+0x22e/0x2b0
> kernel/locking/qspinlock_paravirt.h:498
> Code: ea 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2
> 75 62 41 8b 55 00 4c 89 ee 48 c7 c7 20 6b 4c 89 e8 72 d3 5f 07 <0f> 0b
> e9 6cc
> RSP: 0018:fffffe00000c17b0 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: ffffffff8f3b5660 RCX: 0000000000000000
> RDX: ffff8880150222c0 RSI: ffffffff815b624d RDI: fffffbc0000182e8
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> R10: ffffffff817de94f R11: 0000000000000000 R12: ffff8880150222c0
> R13: ffffffff8f371d80 R14: ffff8880181fead8 R15: 0000000000000000
> FS:  00007fa5b51f0700(0000) GS:ffff88802cf80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000002286908 CR3: 0000000015b24000 CR4: 0000000000750ee0
> DR0: 00000000004cb3d4 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <#DB>
>  __raw_callee_save___pv_queued_spin_unlock_slowpath+0x11/0x20
>  .slowpath+0x9/0xe
>  pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:559 [inline]
>  queued_spin_unlock arch/x86/include/asm/qspinlock.h:56 [inline]
>  lockdep_unlock+0x10e/0x290 kernel/locking/lockdep.c:124
>  debug_locks_off_graph_unlock kernel/locking/lockdep.c:165 [inline]
>  print_usage_bug kernel/locking/lockdep.c:3710 [inline]

Ha, I think you hit a bug in lockdep. But it was about to tell you you
can't go take locks from NMI context that are also used outside of it.

>  verify_lock_unused kernel/locking/lockdep.c:5374 [inline]
>  lock_acquire kernel/locking/lockdep.c:5433 [inline]
>  lock_acquire+0x471/0x720 kernel/locking/lockdep.c:5407
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
>  htab_lock_bucket kernel/bpf/hashtab.c:175 [inline]
>  htab_map_update_elem+0x1f0/0x790 kernel/bpf/hashtab.c:1023
>  bpf_prog_60236c52b8017ad1+0x8e/0xab4
>  bpf_dispatcher_nop_func include/linux/bpf.h:651 [inline]
>  bpf_overflow_handler+0x192/0x5b0 kernel/events/core.c:9755
>  __perf_event_overflow+0x13c/0x370 kernel/events/core.c:8979
>  perf_swevent_overflow kernel/events/core.c:9055 [inline]
>  perf_swevent_event+0x347/0x550 kernel/events/core.c:9083
>  perf_bp_event+0x1a2/0x1c0 kernel/events/core.c:9932
>  hw_breakpoint_handler arch/x86/kernel/hw_breakpoint.c:535 [inline]
>  hw_breakpoint_exceptions_notify+0x18a/0x3b0 arch/x86/kernel/hw_breakpoint.c:567
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  atomic_notifier_call_chain+0x8d/0x170 kernel/notifier.c:217
>  notify_die+0xda/0x170 kernel/notifier.c:548
>  notify_debug+0x20/0x30 arch/x86/kernel/traps.c:842
>  exc_debug_kernel arch/x86/kernel/traps.c:902 [inline]
>  exc_debug+0x103/0x140 arch/x86/kernel/traps.c:998
>  asm_exc_debug+0x19/0x30 arch/x86/include/asm/idtentry.h:598
