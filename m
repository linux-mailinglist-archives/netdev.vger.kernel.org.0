Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED6F3BAF07
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 22:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhGDUlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 16:41:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45585 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhGDUlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 16:41:06 -0400
Received: by mail-io1-f69.google.com with SMTP id e24-20020a5d8e180000b02904dd8a55bbd7so12024793iod.12
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 13:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MLuticSE4LQzdZP0NRfEKiJDbhJOy5ADvFzX0FtLti4=;
        b=lu/OJzGKcIVkupkTpx2Q4CmJ6YNkAEiap7ILNDDrXpvn/otU+xHvC9INEmJz3L0cOS
         hmUxLQ+d+CebJzUmj6xJensG5mMH/cNz9wmkwkwLiSUodyiYLtzI1JfijUcLSxZk1/lM
         YXV/IkDD0/VRFiK1HmYtOWz0QpKfEFZ8RInLiNmoCdSqqVrj9bJOS4Pjrl9WkFet8AD5
         sThYL9WNu+p8FHOBF1Hg5msRg17nCidDPfWEQcII96NwshHvWjO4AgA8OXH28JCbC457
         BBywpxdiz8jEsKn1Yja47YcUH7TjzxZ+eJCYmDqZXCr/VPpR9V46d3j0uevcca+vwHfu
         iCHw==
X-Gm-Message-State: AOAM530v4iAP0obWxdSCvkonqTkt88k5tWKmZfhbrlUydIaeI1k9+z/X
        QSbKSk4R36A6mvmL3/g7d76E+WRicgydr3GRNYVFkV7cIvIY
X-Google-Smtp-Source: ABdhPJzuo27ypgJUxAtOEluYDIcClDZ625Oha1VKjo2FdKhVsryX0hD93G995cfZ2WYMD0n31Gfc3wXnxi2XO1tM8oa68JIhoDL2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3594:: with SMTP id v20mr9090624jal.25.1625431107414;
 Sun, 04 Jul 2021 13:38:27 -0700 (PDT)
Date:   Sun, 04 Jul 2021 13:38:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3b12f05c6522ba9@google.com>
Subject: [syzbot] upstream test error: possible deadlock in fs_reclaim_acquire
From:   syzbot <syzbot+957fdc00c16da68efb1b@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, shakeelb@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    df04fbe8 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15be418c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5c1e3acc43bcfec
dashboard link: https://syzkaller.appspot.com/bug?extid=957fdc00c16da68efb1b

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+957fdc00c16da68efb1b@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-fuzzer/8436 is trying to acquire lock:
ffffffff8c099780 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x160 mm/page_alloc.c:4586

but task is already holding lock:
ffff8880b9d31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (lock#2){-.-.}-{2:2}:
       local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
       free_unref_page+0x1bf/0x690 mm/page_alloc.c:3439
       mm_free_pgd kernel/fork.c:636 [inline]
       __mmdrop+0xcb/0x3f0 kernel/fork.c:687
       mmdrop include/linux/sched/mm.h:49 [inline]
       finish_task_switch.isra.0+0x7cd/0xb80 kernel/sched/core.c:4582
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0xb41/0x5980 kernel/sched/core.c:5940
       preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6328
       irqentry_exit+0x31/0x80 kernel/entry/common.c:427
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       lock_release+0x12/0x720 kernel/locking/lockdep.c:5633
       might_alloc include/linux/sched/mm.h:199 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc mm/slab.c:3306 [inline]
       kmem_cache_alloc+0x41/0x530 mm/slab.c:3507
       anon_vma_alloc mm/rmap.c:89 [inline]
       anon_vma_fork+0xed/0x630 mm/rmap.c:354
       dup_mmap kernel/fork.c:554 [inline]
       dup_mm+0x9a0/0x1380 kernel/fork.c:1379
       copy_mm kernel/fork.c:1431 [inline]
       copy_process+0x71f0/0x74d0 kernel/fork.c:2119
       kernel_clone+0xe7/0xab0 kernel/fork.c:2509
       __do_sys_clone+0xc8/0x110 kernel/fork.c:2626
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

2 locks held by syz-fuzzer/8436:
 #0: ffff88802a51c128 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #0: ffff88802a51c128 (&mm->mmap_lock#2){++++}-{3:3}, at: vm_mmap_pgoff+0x15c/0x290 mm/util.c:517
 #1: ffff8880b9d31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 1 PID: 8436 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
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
RSP: 002b:000000c0006175d8 EFLAGS: 00000212 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c00001e800 RCX: 00000000004af20a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c000617638 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000212 R12: 00000000007798c5
R13: 00000000000000d3 R14: 00000000000000d2 R15: 0000000000000100
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8436, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 6576
hardirqs last  enabled at (6575): [<ffffffff891e6120>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (6575): [<ffffffff891e6120>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (6576): [<ffffffff81b1bf0c>] __alloc_pages_bulk+0x101c/0x1870 mm/page_alloc.c:5291
softirqs last  enabled at (5362): [<ffffffff812b500e>] copy_kernel_to_xregs arch/x86/include/asm/fpu/internal.h:330 [inline]
softirqs last  enabled at (5362): [<ffffffff812b500e>] __fpu__restore_sig+0xe5e/0x14d0 arch/x86/kernel/fpu/signal.c:360
softirqs last disabled at (5360): [<ffffffff812b4aa2>] __fpu__restore_sig+0x8f2/0x14d0 arch/x86/kernel/fpu/signal.c:325
CPU: 1 PID: 8436 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
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
RSP: 002b:000000c0006175d8 EFLAGS: 00000212 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c00001e800 RCX: 00000000004af20a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c000617638 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000212 R12: 00000000007798c5
R13: 00000000000000d3 R14: 00000000000000d2 R15: 0000000000000100


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
