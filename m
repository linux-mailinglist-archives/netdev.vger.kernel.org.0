Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC173654E8
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhDTJK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:10:57 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35564 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhDTJKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:10:53 -0400
Received: by mail-io1-f70.google.com with SMTP id l2-20020a5e82020000b02903c2fa852f92so11875896iom.2
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=cHaECdR/PzBVqswMCXkUzvIeCdFIMb9MUAccEcA9938=;
        b=KOfMguWl5IwwNXSmO6vb3ZnMLQtryyMnRxlASxkn1WYVGHmJM1lJlkdewk8Bu0IPqu
         xnvkzsslcJST+tll3zaOJ5dii3vY2mwVrqYDiaAHBNMDVCNDNN4NZB2V70oOk/KBtTZ4
         WUndUXvHMFWfsYeKhWNRq66GTJWAejXzlEIjkgsa65En2r80/YW+450Wa1f10kPnAX7B
         J0ZbvJZVNWulrRi1UZgKLQX4NHiBy5wI2UzQ3wVTcm8BaMNYZKOzPMI51wUPserTKkg8
         o3Q5SCh4HTtVJIM9zJUKmXhknOH+ET+OqMT7W1SVVwYy6ML65Y6aTpjj6LrbZF4bMA4x
         0q3w==
X-Gm-Message-State: AOAM531ztZxWm4uTYiJf9t6Euha8sNr5/FNDWLIdWGbhSbkKUGEzm7X/
        edDQErHc5ip/RObmuIesMcmu2PCdVpIyrBJYy4ZchVlshWFO
X-Google-Smtp-Source: ABdhPJx+K570iApRg80ZCmYOdfiMH0D2QraVHcAhcwa9AL4YHw6x5uq09HzDwOdQitfJEJTSD+/AISuSvgJcbiMnCwRK2uirX2m8
MIME-Version: 1.0
X-Received: by 2002:a5e:8a47:: with SMTP id o7mr973626iom.57.1618909822180;
 Tue, 20 Apr 2021 02:10:22 -0700 (PDT)
Date:   Tue, 20 Apr 2021 02:10:22 -0700
In-Reply-To: <00000000000057102e058e722bba@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dfe1bc05c063d0fa@google.com>
Subject: Re: [syzbot] INFO: task hung in perf_event_free_task
From:   syzbot <syzbot+7692cea7450c97fa2a0a@syzkaller.appspotmail.com>
To:     acme@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, cobranza@ingcoecuador.com,
        daniel@iogearbox.net, eranian@google.com, john.fastabend@gmail.com,
        jolsa@redhat.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mingo@kernel.org, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        vincent.weaver@maine.edu, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7af08140 Revert "gcov: clang: fix clang-11+ build"
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15416871d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0a6882014fd3d45
dashboard link: https://syzkaller.appspot.com/bug?extid=7692cea7450c97fa2a0a
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145c9ffed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12de31ded00000

The issue was bisected to:

commit 1cf8dfe8a661f0462925df943140e9f6d1ea5233
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Sat Jul 13 09:21:25 2019 +0000

    perf/core: Fix race between close() and fork()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1523f40c600000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1723f40c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=1323f40c600000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7692cea7450c97fa2a0a@syzkaller.appspotmail.com
Fixes: 1cf8dfe8a661 ("perf/core: Fix race between close() and fork()")

INFO: task syz-executor890:6628 blocked for more than 143 seconds.
      Not tainted 5.12.0-rc8-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor890 state:D stack:25968 pid: 6628 ppid:  8391 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4322 [inline]
 __schedule+0xa4d/0xf80 kernel/sched/core.c:5073
 schedule+0x14b/0x200 kernel/sched/core.c:5152
 perf_event_free_task+0x575/0x6a0 kernel/events/core.c:12623
 copy_process+0x418f/0x57e0 kernel/fork.c:2376
 kernel_clone+0x21a/0x7d0 kernel/fork.c:2500
 __do_sys_clone kernel/fork.c:2617 [inline]
 __se_sys_clone kernel/fork.c:2601 [inline]
 __x64_sys_clone+0x236/0x2b0 kernel/fork.c:2601
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x44b6e9
RSP: 002b:00007fd6c1512208 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00000000004d7288 RCX: 000000000044b6e9
RDX: 9999999999999999 RSI: 0000000000000000 RDI: 0000000022086605
RBP: 00000000004d7280 R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d728c
R13: 00007ffc3bab65ef R14: 00007fd6c1512300 R15: 0000000000022000

Showing all locks held in the system:
1 lock held by khungtaskd/1623:
 #0: ffffffff8cd10280 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30 arch/x86/pci/mmconfig_64.c:151
2 locks held by systemd-journal/4819:
1 lock held by in:imklog/8079:
 #0: ffff8880163265f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x2f0 fs/file.c:974
2 locks held by syz-executor890/6495:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1623 Comm: khungtaskd Not tainted 5.12.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x202/0x31e lib/dump_stack.c:120
 nmi_cpu_backtrace+0x16c/0x190 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x191/0x2f0 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xcfb/0xd40 kernel/hung_task.c:294
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 6495 Comm: syz-executor890 Not tainted 5.12.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:155 [inline]
RIP: 0010:unwind_next_frame+0x184/0x1f90 arch/x86/kernel/unwind_orc.c:443
Code: 89 7c 24 70 0f 84 1a 01 00 00 48 c7 c0 00 00 00 81 49 39 c4 0f 82 16 01 00 00 48 c7 c0 52 83 e0 89 49 39 c4 0f 83 06 01 00 00 <48> c7 c0 00 00 00 81 4c 89 e5 48 29 c5 48 c1 ed 08 48 c7 c0 e8 8d
RSP: 0000:ffffc9000dd5f720 EFLAGS: 00000087
RAX: ffffffff89e08352 RBX: ffffc9000dd5f828 RCX: ffffffff9031ab03
RDX: ffffc9000dd5fc20 RSI: ffffffff814e6de0 RDI: 0000000000000001
RBP: ffffc9000dd5f815 R08: 0000000000000003 R09: ffffc9000dd5f8b0
R10: fffff52001babf08 R11: 0000000000000000 R12: ffffffff814e6ddf
R13: ffffc9000dd5f7e0 R14: dffffc0000000000 R15: 1ffff92001babf02
FS:  00007fd6c1512700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000022000 CR3: 0000000034d8b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 arch_stack_walk+0xb2/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x104/0x1e0 kernel/stacktrace.c:121
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 __kasan_slab_alloc+0x8f/0xc0 mm/kasan/common.c:460
 kasan_slab_alloc include/linux/kasan.h:223 [inline]
 slab_post_alloc_hook mm/slab.h:516 [inline]
 slab_alloc_node mm/slub.c:2907 [inline]
 slab_alloc mm/slub.c:2915 [inline]
 kmem_cache_alloc+0x1c3/0x350 mm/slub.c:2920
 __sigqueue_alloc+0x2c2/0x490 kernel/signal.c:435
 __send_signal+0x210/0xe50 kernel/signal.c:1116
 force_sig_info_to_task+0x2a4/0x3f0 kernel/signal.c:1334
 force_sig_fault_to_task kernel/signal.c:1673 [inline]
 force_sig_fault+0x11e/0x1c0 kernel/signal.c:1680
 __bad_area_nosemaphore+0x390/0x570 arch/x86/mm/fault.c:840
 handle_page_fault arch/x86/mm/fault.c:1475 [inline]
 exc_page_fault+0xa1/0x1e0 arch/x86/mm/fault.c:1531
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:577
RIP: 0033:0x22000
Code: Unable to access opcode bytes at RIP 0x21fd6.
RSP: 002b:00007fd6c1512220 EFLAGS: 00010206
RAX: ffffffffffffffff RBX: 00000000004d7288 RCX: ffffffffffffffbc
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000000
RBP: 00000000004d7280 R08: 0000000000000000 R09: 00007fd6c1512300
R10: 00000000ffffffff R11: 0000000000000246 R12: 00000000004d728c
R13: 00007ffc3bab65ef R14: 00007fd6c1512300 R15: 0000000000022000

