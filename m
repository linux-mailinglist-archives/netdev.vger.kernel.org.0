Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6913C28A2
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 19:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhGIRpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 13:45:10 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:42989 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbhGIRpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 13:45:09 -0400
Received: by mail-il1-f199.google.com with SMTP id d17-20020a9236110000b02901cf25fcfdcdso6432060ila.9
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 10:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nAIiLG582GE5TP2osna2SVaot0omqgzkFcYWBYBMNHk=;
        b=stduNecxHvX8OiLTMH0X6WgU9P4vBR1w5OaPSqAw1VP6D46+pKs/MwpHbBlmuufBs0
         8i3NEjFsvWyGecIpEo2d7Vf0EA+kqIopNOLg6F/mQgUMgiDTFJ5hKdPiSZVGJlJE7rI6
         fkkRI+VkFiAY41STztgqblPIkja/RQ6pIvTFRtgRy3G1dVUwmuehRBentMq3t65QZ9zb
         OjiFiyExTkuvIdMMZ4TsF+wEldk/DjgsLEvSW33ClMFAMVA8E/CrvVMzqHliL87xKEio
         v8DnX98O+pGNVh0C+RyQDSSB9Of6bgA0YcoIKobgRjjq9Uq6nEIinJsnzzuttT988uX3
         dwQQ==
X-Gm-Message-State: AOAM531tCmQNFkfXSJ8XURIQtSzYu1hMzhMgrhXQe59zHB1RWZpiIQvn
        iuAenTJ+BRYb4GXHWn7RQqIcaKQv1LIkYP/f/NsDeKWWxEBo
X-Google-Smtp-Source: ABdhPJxMpZko7RXD/A5lWSHRBW487h2+kfM/IsX7WAJjc0W7T1qagGxylv1Kid52LZjBd9Q7q84XTw3OMUrqjkb7rv4f3vguFAE2
MIME-Version: 1.0
X-Received: by 2002:a5d:9589:: with SMTP id a9mr8070079ioo.63.1625852544481;
 Fri, 09 Jul 2021 10:42:24 -0700 (PDT)
Date:   Fri, 09 Jul 2021 10:42:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005efd1b05c6b44bd3@google.com>
Subject: [syzbot] net test error: possible deadlock in fs_reclaim_acquire
From:   syzbot <syzbot+c453e1328dbf23580e9e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, davem@davemloft.net, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org, shakeelb@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ccd27f05 ipv6: fix 'disable_policy' for fwd packets
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1785e6b0300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4dab7ebc24619f37
dashboard link: https://syzkaller.appspot.com/bug?extid=c453e1328dbf23580e9e

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c453e1328dbf23580e9e@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-fuzzer/8439 is trying to acquire lock:
ffffffff8ba9c1c0 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x160 mm/page_alloc.c:4586

but task is already holding lock:
ffff8880b9d4d620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (lock#2){-.-.}-{2:2}:
       local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
       free_unref_page+0x1bf/0x690 mm/page_alloc.c:3439
       mm_free_pgd kernel/fork.c:636 [inline]
       __mmdrop+0xcb/0x3f0 kernel/fork.c:687
       mmdrop include/linux/sched/mm.h:49 [inline]
       finish_task_switch.isra.0+0x6da/0xa50 kernel/sched/core.c:4582
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0x93c/0x2710 kernel/sched/core.c:5940
       preempt_schedule_notrace+0x5b/0xd0 kernel/sched/core.c:6179
       preempt_schedule_notrace_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:36
       rcu_read_unlock_sched_notrace include/linux/rcupdate.h:809 [inline]
       trace_lock_acquire include/trace/events/lock.h:13 [inline]
       lock_acquire+0x461/0x510 kernel/locking/lockdep.c:5596
       fs_reclaim_acquire mm/page_alloc.c:4581 [inline]
       fs_reclaim_acquire+0xd2/0x160 mm/page_alloc.c:4572
       might_alloc include/linux/sched/mm.h:198 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc_node mm/slub.c:2891 [inline]
       slab_alloc mm/slub.c:2978 [inline]
       kmem_cache_alloc+0x3e/0x4a0 mm/slub.c:2983
       getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
       getname_flags fs/namei.c:2734 [inline]
       user_path_at_empty+0xa1/0x100 fs/namei.c:2734
       user_path_at include/linux/namei.h:60 [inline]
       do_faccessat+0x127/0x850 fs/open.c:425
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __fs_reclaim_acquire mm/page_alloc.c:4564 [inline]
       fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4578
       prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5176
       __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       save_stack+0x15e/0x1e0 mm/page_owner.c:120
       __set_page_owner+0x50/0x290 mm/page_owner.c:181
       prep_new_page mm/page_alloc.c:2445 [inline]
       __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
       alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
       vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
       __vmalloc_area_node mm/vmalloc.c:2845 [inline]
       __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
       vmalloc_user+0x67/0x80 mm/vmalloc.c:3082
       kcov_mmap+0x2b/0x140 kernel/kcov.c:465
       call_mmap include/linux/fs.h:2119 [inline]
       mmap_region+0xcde/0x1760 mm/mmap.c:1809
       do_mmap+0x86e/0x11d0 mm/mmap.c:1585
       vm_mmap_pgoff+0x1b7/0x290 mm/util.c:519
       ksys_mmap_pgoff+0x4a8/0x620 mm/mmap.c:1636
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
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

2 locks held by syz-fuzzer/8439:
 #0: ffff888030c74028 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #0: ffff888030c74028 (&mm->mmap_lock#2){++++}-{3:3}, at: vm_mmap_pgoff+0x15c/0x290 mm/util.c:517
 #1: ffff8880b9d4d620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 1 PID: 8439 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __fs_reclaim_acquire mm/page_alloc.c:4564 [inline]
 fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4578
 prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5176
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 vmalloc_user+0x67/0x80 mm/vmalloc.c:3082
 kcov_mmap+0x2b/0x140 kernel/kcov.c:465
 call_mmap include/linux/fs.h:2119 [inline]
 mmap_region+0xcde/0x1760 mm/mmap.c:1809
 do_mmap+0x86e/0x11d0 mm/mmap.c:1585
 vm_mmap_pgoff+0x1b7/0x290 mm/util.c:519
 ksys_mmap_pgoff+0x4a8/0x620 mm/mmap.c:1636
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0002ef5d8 EFLAGS: 00000212 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c00001e800 RCX: 00000000004af20a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c0002ef638 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000212 R12: 00000000007798c5
R13: 00000000000000d4 R14: 00000000000000d3 R15: 0000000000000100
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8439, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 30266
hardirqs last  enabled at (30265): [<ffffffff892271f0>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (30265): [<ffffffff892271f0>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (30266): [<ffffffff81b21da7>] __alloc_pages_bulk+0x1017/0x1870 mm/page_alloc.c:5291
softirqs last  enabled at (29546): [<ffffffff8146345e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (29546): [<ffffffff8146345e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
softirqs last disabled at (29535): [<ffffffff8146345e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (29535): [<ffffffff8146345e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
CPU: 1 PID: 8439 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9153
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5179
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 vmalloc_user+0x67/0x80 mm/vmalloc.c:3082
 kcov_mmap+0x2b/0x140 kernel/kcov.c:465
 call_mmap include/linux/fs.h:2119 [inline]
 mmap_region+0xcde/0x1760 mm/mmap.c:1809
 do_mmap+0x86e/0x11d0 mm/mmap.c:1585
 vm_mmap_pgoff+0x1b7/0x290 mm/util.c:519
 ksys_mmap_pgoff+0x4a8/0x620 mm/mmap.c:1636
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0002ef5d8 EFLAGS: 00000212 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c00001e800 RCX: 00000000004af20a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c0002ef638 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000212 R12: 00000000007798c5
R13: 00000000000000d4 R14: 00000000000000d3 R15: 0000000000000100


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
