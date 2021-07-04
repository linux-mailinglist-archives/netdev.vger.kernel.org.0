Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E723BACF3
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhGDLx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 07:53:57 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48720 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhGDLxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 07:53:55 -0400
Received: by mail-io1-f71.google.com with SMTP id f2-20020a6b62020000b02905094eaa65fdso2539367iog.15
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 04:51:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9UY5DKEEmLfXsXziPoXaMFmZp4udBip2uaq/1L6U9RI=;
        b=TzdGMvVL86a7Fy/osEPy/721wGnzWwQ5PTvhfHY5NliFfo50Arma7kScXOHuOAmxaq
         uALe4O6qdgqEvSzPk/7Og4MxXDGtwvoj5FFkRmue2m2nh9CilSj5RlnnOel0/8gPCbaW
         buJkDTlMAXw7rvDtgkNap6L7F5P301g5oFmhzqB844bkOcoL+bPpT2NaQavITdg5F1j9
         3poR+RaBRu2FVQEzI4KKIuSM0NNSW/wmCMWADBUqz4cSyVqxADOmzt/CEJx7KVeXTBLl
         Jrrc3eAIeeLEzwM30fMmkUrGx13WhilBHxI6wCiiKuZmDoPS5GVI3r4488E/o6nTiU7A
         dYDQ==
X-Gm-Message-State: AOAM533VIwwwG2qD8Acdfs1WZx6DhMLlvTr6NyYajteDdKVixOHfYewn
        YMlb6IAJgNA50G9L9Wb+yRIxa8IQeOAC+UvMhQ/f7/SwG2vo
X-Google-Smtp-Source: ABdhPJxgG1Zmk2Hb/OM312E6Ut3E+4dfoWWP62/Aybr62+dtODt08SDlleLZkyvhD/yxvFVOjL3ZZp2WzC/nj01fgCYqiwT7Ej7+
MIME-Version: 1.0
X-Received: by 2002:a05:6602:19:: with SMTP id b25mr7536575ioa.93.1625399480372;
 Sun, 04 Jul 2021 04:51:20 -0700 (PDT)
Date:   Sun, 04 Jul 2021 04:51:20 -0700
In-Reply-To: <0000000000002054ab05c6486083@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5532d05c64ace69@google.com>
Subject: Re: [syzbot] possible deadlock in __fs_reclaim_acquire
From:   syzbot <syzbot+127fd7828d6eeb611703@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org, shakeelb@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3dbdb38e Merge branch 'for-5.14' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e0b9d8300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1700b0b2b41cd52c
dashboard link: https://syzkaller.appspot.com/bug?extid=127fd7828d6eeb611703
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10542f52300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+127fd7828d6eeb611703@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-execprog/8416 is trying to acquire lock:
ffffffff8cfd6720 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x0/0x30 mm/page_alloc.c:4222

but task is already holding lock:
ffff8880b9b31088 (lock#2){-.-.}-{2:2}, at: local_lock_acquire+0x7/0x130 include/linux/local_lock_internal.h:41

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (lock#2){-.-.}-{2:2}:
       lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
       local_lock_acquire+0x23/0x130 include/linux/local_lock_internal.h:42
       free_unref_page+0x242/0x550 mm/page_alloc.c:3439
       mm_free_pgd kernel/fork.c:636 [inline]
       __mmdrop+0xae/0x3f0 kernel/fork.c:687
       mmdrop include/linux/sched/mm.h:49 [inline]
       finish_task_switch+0x221/0x630 kernel/sched/core.c:4582
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0xc0f/0x11f0 kernel/sched/core.c:5940
       preempt_schedule_notrace+0x12c/0x170 kernel/sched/core.c:6179
       preempt_schedule_notrace_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:36
       rcu_read_unlock_sched_notrace include/linux/rcupdate.h:809 [inline]
       trace_lock_release+0x9f/0x140 include/trace/events/lock.h:58
       lock_release+0x81/0x7b0 kernel/locking/lockdep.c:5636
       might_alloc include/linux/sched/mm.h:199 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc_node mm/slub.c:2891 [inline]
       slab_alloc mm/slub.c:2978 [inline]
       kmem_cache_alloc+0x41/0x340 mm/slub.c:2983
       kmem_cache_zalloc include/linux/slab.h:711 [inline]
       attach_epitem fs/eventpoll.c:1414 [inline]
       ep_insert fs/eventpoll.c:1468 [inline]
       do_epoll_ctl+0x13a7/0x2f70 fs/eventpoll.c:2133
       __do_sys_epoll_ctl fs/eventpoll.c:2184 [inline]
       __se_sys_epoll_ctl fs/eventpoll.c:2175 [inline]
       __x64_sys_epoll_ctl+0x14e/0x190 fs/eventpoll.c:2175
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add+0x4f9/0x5b30 kernel/locking/lockdep.c:3174
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x4476/0x6100 kernel/locking/lockdep.c:5015
       lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
       __fs_reclaim_acquire+0x20/0x30 mm/page_alloc.c:4564
       fs_reclaim_acquire+0x59/0xf0 mm/page_alloc.c:4578
       prepare_alloc_pages+0x151/0x5a0 mm/page_alloc.c:5176
       __alloc_pages+0x14d/0x5f0 mm/page_alloc.c:5375
       stack_depot_save+0x361/0x490 lib/stackdepot.c:303
       save_stack+0xf9/0x1f0 mm/page_owner.c:120
       __set_page_owner+0x42/0x2f0 mm/page_owner.c:181
       prep_new_page mm/page_alloc.c:2445 [inline]
       __alloc_pages_bulk+0x9f2/0x1090 mm/page_alloc.c:5313
       alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
       vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
       __vmalloc_area_node mm/vmalloc.c:2845 [inline]
       __vmalloc_node_range+0x3ad/0x7f0 mm/vmalloc.c:2947
       vmalloc_user+0x70/0x80 mm/vmalloc.c:3082
       kcov_mmap+0x28/0x130 kernel/kcov.c:465
       call_mmap include/linux/fs.h:2119 [inline]
       mmap_region+0x1410/0x1df0 mm/mmap.c:1809
       do_mmap+0x930/0x11a0 mm/mmap.c:1585
       vm_mmap_pgoff+0x19e/0x2b0 mm/util.c:519
       ksys_mmap_pgoff+0x504/0x7b0 mm/mmap.c:1636
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lock#2);
                               lock(fs_reclaim);
                               lock(lock#2);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by syz-execprog/8416:
 #0: ffff8880161e0128 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #0: ffff8880161e0128 (&mm->mmap_lock#2){++++}-{3:3}, at: vm_mmap_pgoff+0x14d/0x2b0 mm/util.c:517
 #1: ffff8880b9b31088 (lock#2){-.-.}-{2:2}, at: local_lock_acquire+0x7/0x130 include/linux/local_lock_internal.h:41

stack backtrace:
CPU: 1 PID: 8416 Comm: syz-execprog Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0x1ae/0x29f lib/dump_stack.c:96
 print_circular_bug+0xb17/0xdc0 kernel/locking/lockdep.c:2009
 check_noncircular+0x2cc/0x390 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add+0x4f9/0x5b30 kernel/locking/lockdep.c:3174
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x4476/0x6100 kernel/locking/lockdep.c:5015
 lock_acquire+0x182/0x4a0 kernel/locking/lockdep.c:5625
 __fs_reclaim_acquire+0x20/0x30 mm/page_alloc.c:4564
 fs_reclaim_acquire+0x59/0xf0 mm/page_alloc.c:4578
 prepare_alloc_pages+0x151/0x5a0 mm/page_alloc.c:5176
 __alloc_pages+0x14d/0x5f0 mm/page_alloc.c:5375
 stack_depot_save+0x361/0x490 lib/stackdepot.c:303
 save_stack+0xf9/0x1f0 mm/page_owner.c:120
 __set_page_owner+0x42/0x2f0 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x9f2/0x1090 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x3ad/0x7f0 mm/vmalloc.c:2947
 vmalloc_user+0x70/0x80 mm/vmalloc.c:3082
 kcov_mmap+0x28/0x130 kernel/kcov.c:465
 call_mmap include/linux/fs.h:2119 [inline]
 mmap_region+0x1410/0x1df0 mm/mmap.c:1809
 do_mmap+0x930/0x11a0 mm/mmap.c:1585
 vm_mmap_pgoff+0x19e/0x2b0 mm/util.c:519
 ksys_mmap_pgoff+0x504/0x7b0 mm/mmap.c:1636
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4b132a
Code: e8 db 57 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c000173a10 EFLAGS: 00000202 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c000020800 RCX: 00000000004b132a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c000173a70 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000202 R12: 0000000000727f1a
R13: 00000000000001f6 R14: 0000000000000200 R15: 0000000000000100
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8416, name: syz-execprog
INFO: lockdep is turned off.
irq event stamp: 70646
hardirqs last  enabled at (70645): [<ffffffff89cf038b>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (70645): [<ffffffff89cf038b>] _raw_spin_unlock_irqrestore+0x8b/0x120 kernel/locking/spinlock.c:191
hardirqs last disabled at (70646): [<ffffffff81be4351>] __alloc_pages_bulk+0x801/0x1090 mm/page_alloc.c:5291
softirqs last  enabled at (69738): [<ffffffff814d4fbb>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (69738): [<ffffffff814d4fbb>] __irq_exit_rcu+0x21b/0x260 kernel/softirq.c:636
softirqs last disabled at (69687): [<ffffffff814d4fbb>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (69687): [<ffffffff814d4fbb>] __irq_exit_rcu+0x21b/0x260 kernel/softirq.c:636
CPU: 1 PID: 8416 Comm: syz-execprog Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0x1ae/0x29f lib/dump_stack.c:96
 ___might_sleep+0x4e5/0x6b0 kernel/sched/core.c:9153
 prepare_alloc_pages+0x1c0/0x5a0 mm/page_alloc.c:5179
 __alloc_pages+0x14d/0x5f0 mm/page_alloc.c:5375
 stack_depot_save+0x361/0x490 lib/stackdepot.c:303
 save_stack+0xf9/0x1f0 mm/page_owner.c:120
 __set_page_owner+0x42/0x2f0 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x9f2/0x1090 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x3ad/0x7f0 mm/vmalloc.c:2947
 vmalloc_user+0x70/0x80 mm/vmalloc.c:3082
 kcov_mmap+0x28/0x130 kernel/kcov.c:465
 call_mmap include/linux/fs.h:2119 [inline]
 mmap_region+0x1410/0x1df0 mm/mmap.c:1809
 do_mmap+0x930/0x11a0 mm/mmap.c:1585
 vm_mmap_pgoff+0x19e/0x2b0 mm/util.c:519
 ksys_mmap_pgoff+0x504/0x7b0 mm/mmap.c:1636
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4b132a
Code: e8 db 57 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c000173a10 EFLAGS: 00000202 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c000020800 RCX: 00000000004b132a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c000173a70 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000202 R12: 0000000000727f1a
R13: 00000000000001f6 R14: 0000000000000200 R15: 0000000000000100

