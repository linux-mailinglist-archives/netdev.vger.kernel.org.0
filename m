Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93C3309B29
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 09:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhAaIoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 03:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhAaInr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 03:43:47 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68DEC061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 00:43:05 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id h16so8924482qth.11
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 00:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=34LF0oUAzvA7L0f72J8AccfB18y2J2I07QbXdiR+PSM=;
        b=GuUbI0El8uD0Q0avPsmpDFyV2+UcVsg+ZmvkY/c6RduCF9r2q2RK9D86bzAp9VtkGI
         395JShPKndA6Mrq1eHxJE56QV6ipKwKLbwUzaVkma6iMnfrBCNz6tv99Z7DbfXTWshFX
         PqOXAczmnmwmDeOuFs4wrqV3RvTF24e9vVNLy6r5ofLehziuTu4p163cz5xGS5H423A8
         lxFG7BPpinN4HMw1e1gEVSoP2eyQNE4gjOsFKWUO0+U457ANQqXDr1MjI0CPaQ0HUOw2
         OhZRIvJWEe9ru/y14Wl2MR5dTpdqelwfA4D5OX6YfynSif/QTxA1Ww6DGBAUboeV1YN3
         gdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=34LF0oUAzvA7L0f72J8AccfB18y2J2I07QbXdiR+PSM=;
        b=eA542T+H6yic0Wn4W4VrG/teym9lMlBhKFuZgQ6NKS+Ajh1hIfpOHGmSaxtVzZv+nM
         G9Kink7h4CLgnfk7omLWVh6tlKA3n3Pw92rwRM5TQzvNfIffS79DHnGEG1ay6xhfR1Yz
         hhvJwTBgY2TMuTcD6CzgHvcjjaFhR0mPs+ub5kFSuLEVopqpsSVEIbhlxjdd30Q3U+Ro
         QI6jnBtFF4JSuOLvIUYvf0DVuMskl/cn9jXr3clrq1i19VlDFgR65niUdBLZZvr1vto7
         +uRmVi87YKeBKbjRhq3WR28GS6s6yczYHnx1hpP7pMgku8ln4F5OwQRtvmb4lc58/iDF
         7tbg==
X-Gm-Message-State: AOAM533qH3ZvqRSnc5L8paDhDdwIhxsSlafhfGVQugVgcyEbc7eK7BfR
        0JLLTKTgOiKe/j4tZ3slKzelaPsyv6E+eAQ8TQuM/g==
X-Google-Smtp-Source: ABdhPJxsJ7PH9FtIyP9C9WAmb997COsD/GLIXO77mK+pUBa8oDOazghml5eT07aVTltA/qksXeFcLtQMN3YGdY+BjLU=
X-Received: by 2002:ac8:7c82:: with SMTP id y2mr10558143qtv.67.1612082584127;
 Sun, 31 Jan 2021 00:43:04 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 31 Jan 2021 09:42:53 +0100
Message-ID: <CACT4Y+YJp0t0HA3+wDsAVxgTK4J+Pvht-J4-ENkOtS=C=Fhtzg@mail.gmail.com>
Subject: corrupted pvqspinlock in htab_map_update_elem
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am testing the following the program:
https://gist.github.com/dvyukov/e5c0a8ef220ef856363c1080b0936a9e
on the latest upstream 6642d600b541b81931fb1ab0c041b0d68f77be7e and
getting the following crash. Config is:
https://gist.github.com/dvyukov/16d9905e5ef35e44285451f1d330ddbc

The program updates a bpf map from a program called on hw breakpoint
hit. Not sure if it's a bpf issue or a perf issue. This time it is not
a fuzzer workload, I am trying to do something useful :)

------------[ cut here ]------------
pvqspinlock: lock 0xffffffff8f371d80 has corrupted value 0x0!
WARNING: CPU: 3 PID: 8771 at kernel/locking/qspinlock_paravirt.h:498
__pv_queued_spin_unlock_slowpath+0x22e/0x2b0
kernel/locking/qspinlock_paravirt.h:498
Modules linked in:
CPU: 3 PID: 8771 Comm: a.out Not tainted 5.11.0-rc5+ #71
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.13.0-44-g88ab0c15525c-prebuilt.qemu.org 04/01/2014
RIP: 0010:__pv_queued_spin_unlock_slowpath+0x22e/0x2b0
kernel/locking/qspinlock_paravirt.h:498
Code: ea 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2
75 62 41 8b 55 00 4c 89 ee 48 c7 c7 20 6b 4c 89 e8 72 d3 5f 07 <0f> 0b
e9 6cc
RSP: 0018:fffffe00000c17b0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffffffff8f3b5660 RCX: 0000000000000000
RDX: ffff8880150222c0 RSI: ffffffff815b624d RDI: fffffbc0000182e8
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff817de94f R11: 0000000000000000 R12: ffff8880150222c0
R13: ffffffff8f371d80 R14: ffff8880181fead8 R15: 0000000000000000
FS:  00007fa5b51f0700(0000) GS:ffff88802cf80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002286908 CR3: 0000000015b24000 CR4: 0000000000750ee0
DR0: 00000000004cb3d4 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <#DB>
 __raw_callee_save___pv_queued_spin_unlock_slowpath+0x11/0x20
 .slowpath+0x9/0xe
 pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:559 [inline]
 queued_spin_unlock arch/x86/include/asm/qspinlock.h:56 [inline]
 lockdep_unlock+0x10e/0x290 kernel/locking/lockdep.c:124
 debug_locks_off_graph_unlock kernel/locking/lockdep.c:165 [inline]
 print_usage_bug kernel/locking/lockdep.c:3710 [inline]
 verify_lock_unused kernel/locking/lockdep.c:5374 [inline]
 lock_acquire kernel/locking/lockdep.c:5433 [inline]
 lock_acquire+0x471/0x720 kernel/locking/lockdep.c:5407
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 htab_lock_bucket kernel/bpf/hashtab.c:175 [inline]
 htab_map_update_elem+0x1f0/0x790 kernel/bpf/hashtab.c:1023
 bpf_prog_60236c52b8017ad1+0x8e/0xab4
 bpf_dispatcher_nop_func include/linux/bpf.h:651 [inline]
 bpf_overflow_handler+0x192/0x5b0 kernel/events/core.c:9755
 __perf_event_overflow+0x13c/0x370 kernel/events/core.c:8979
 perf_swevent_overflow kernel/events/core.c:9055 [inline]
 perf_swevent_event+0x347/0x550 kernel/events/core.c:9083
 perf_bp_event+0x1a2/0x1c0 kernel/events/core.c:9932
 hw_breakpoint_handler arch/x86/kernel/hw_breakpoint.c:535 [inline]
 hw_breakpoint_exceptions_notify+0x18a/0x3b0 arch/x86/kernel/hw_breakpoint.c:567
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 atomic_notifier_call_chain+0x8d/0x170 kernel/notifier.c:217
 notify_die+0xda/0x170 kernel/notifier.c:548
 notify_debug+0x20/0x30 arch/x86/kernel/traps.c:842
 exc_debug_kernel arch/x86/kernel/traps.c:902 [inline]
 exc_debug+0x103/0x140 arch/x86/kernel/traps.c:998
 asm_exc_debug+0x19/0x30 arch/x86/include/asm/idtentry.h:598
RIP: 0010:copy_user_generic_unrolled+0xa2/0xc0 arch/x86/lib/copy_user_64.S:102
Code: ff c9 75 b6 89 d1 83 e2 07 c1 e9 03 74 12 4c 8b 06 4c 89 07 48
8d 76 08 48 8d 7f 08 ff c9 75 ee 21 d2 74 10 89 d1 8a 06 88 07 <48> ff
c6 484
RSP: 0018:ffffc90000d67af0 EFLAGS: 00040202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000001 RSI: ffff88801341d001 RDI: 00000000004cb3d4
RBP: 00000000004cb3d4 R08: 0000000000000000 R09: ffff88801341d001
R10: ffffed1002683a00 R11: 0000000000000000 R12: ffff88801341d001
R13: 00000000004cb3d5 R14: 0000000000000000 R15: 0000000000000001
 </#DB>
 copy_user_generic arch/x86/include/asm/uaccess_64.h:37 [inline]
 raw_copy_to_user arch/x86/include/asm/uaccess_64.h:58 [inline]
 copyout.part.0+0xe4/0x110 lib/iov_iter.c:148
 copyout lib/iov_iter.c:182 [inline]
 copy_page_to_iter_iovec lib/iov_iter.c:219 [inline]
 copy_page_to_iter+0x416/0xed0 lib/iov_iter.c:926
 pipe_read+0x4a4/0x13a0 fs/pipe.c:290
 call_read_iter include/linux/fs.h:1895 [inline]
 new_sync_read+0x5b7/0x6e0 fs/read_write.c:415
 vfs_read+0x35c/0x570 fs/read_write.c:496
 ksys_read+0x1ee/0x250 fs/read_write.c:634
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x406c1c
Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 fc ff ff
48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 31 c0 0f 05 <48> 3d
00 f08
RSP: 002b:00007fa5b51f02d0 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00000000004cb3d4 RCX: 0000000000406c1c
RDX: 0000000000000001 RSI: 00000000004cb3d4 RDI: 0000000000000004
RBP: 00007fa5b51f030c R08: 0000000000000000 R09: 0000000000000000
R10: 00007fa5b51f0700 R11: 0000000000000246 R12: 00000000004cb3d0
R13: cccccccccccccccd R14: 00007fa5b51f0400 R15: 0000000000802000
