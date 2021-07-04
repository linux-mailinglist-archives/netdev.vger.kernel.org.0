Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C81B3BAC2D
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhGDI7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:59:53 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55166 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhGDI7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:59:51 -0400
Received: by mail-io1-f70.google.com with SMTP id m14-20020a5d898e0000b02904f7957d92b5so10911442iol.21
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 01:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CBFbWWG2no/RXNUb57K5ovDWepx1taZTCUg2vEu4ahY=;
        b=ZxLV0mhcnDvSXuKqa6qM6BPfsA2EVrHLAn894yBfTsAcjgHw8gcGav/dlMXHOrJQhx
         GvW2LFUW7bBTOidcqjge5AdlhzR0EuEPE1c0sqtFAdpRW5v8fq21tDjszcqQTvUhxvPV
         xshvIBqiDU2z0g10POphD7nSR97TnhYnBOLywf8k4A9rvdY2OWjd+haahqIB1wweqSMo
         pb1BDS8AFs4W1o/H8WHbyWOWV3UlJVlBQS4zy0DgN/3i7wcoFw+SMR6hzUKZCDSJXIHq
         8018Fw6gsadm/cvUoSZ7z+fPnQVkcAdgmGqL209hkpnZZ5lbkyWWwWY4IgilvXiXp5Jz
         c0Kw==
X-Gm-Message-State: AOAM530iEEwi6/WzgPMrzBs6bQ8wWfhXryxQ1rFOeZgy/KhkHTCcIP10
        xPM2AZxWGOFh50CAn6dECsqj6bgSE/m4SH4I4chtrRj/2zV1
X-Google-Smtp-Source: ABdhPJyRTW4jXgkVKOnEQ77RC6obW6JoNHPPvQag9GfjYxABk5Si7BZzdgrFakKtQ7Oekk0GOhQz4xjlEqKu3suvf+K0gzjp9+Be
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1521:: with SMTP id i1mr6308661ilu.155.1625389036410;
 Sun, 04 Jul 2021 01:57:16 -0700 (PDT)
Date:   Sun, 04 Jul 2021 01:57:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000231b1705c64860b3@google.com>
Subject: [syzbot] upstream test error: possible deadlock in __fs_reclaim_acquire
From:   syzbot <syzbot+c259b724a0f86d1f5459@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        ebiederm@xmission.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org, shakeelb@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    007b350a Merge tag 'dlm-5.14' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1690caac300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d126a83e6a7982cb
dashboard link: https://syzkaller.appspot.com/bug?extid=c259b724a0f86d1f5459
compiler:       Debian clang version 11.0.1-2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c259b724a0f86d1f5459@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-fuzzer/8414 is trying to acquire lock:
ffffffff8cfd67c0 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x0/0x30 mm/page_alloc.c:4222

but task is already holding lock:
ffff8880b9a31088 (lock#2){-.-.}-{2:2}, at: local_lock_acquire+0x7/0x130 include/linux/local_lock_internal.h:41

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
       __schedule+0xb5b/0x1450 kernel/sched/core.c:5940
       preempt_schedule_irq+0xe3/0x190 kernel/sched/core.c:6328
       irqentry_exit+0x56/0x90 kernel/entry/common.c:427
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       lock_acquire+0x1e7/0x4a0 kernel/locking/lockdep.c:5629
       __fs_reclaim_acquire+0x20/0x30 mm/page_alloc.c:4564
       fs_reclaim_acquire+0x59/0xf0 mm/page_alloc.c:4578
       might_alloc include/linux/sched/mm.h:198 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc_node mm/slub.c:2891 [inline]
       slab_alloc mm/slub.c:2978 [inline]
       kmem_cache_alloc+0x3a/0x340 mm/slub.c:2983
       getname_flags+0xba/0x640 fs/namei.c:138
       user_path_at_empty+0x28/0x50 fs/namei.c:2734
       user_path_at include/linux/namei.h:60 [inline]
       vfs_statx+0x102/0x3d0 fs/stat.c:203
       vfs_fstatat fs/stat.c:225 [inline]
       vfs_lstat include/linux/fs.h:3384 [inline]
       __do_sys_newlstat fs/stat.c:380 [inline]
       __se_sys_newlstat fs/stat.c:374 [inline]
       __x64_sys_newlstat+0xd3/0x150 fs/stat.c:374
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
       __alloc_pages_bulk+0x9f6/0x10b0 mm/page_alloc.c:5313
       alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
       vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
       __vmalloc_area_node mm/vmalloc.c:2845 [inline]
       __vmalloc_node_range+0x3ad/0x7f0 mm/vmalloc.c:2947
       vmalloc_user+0x70/0x80 mm/vmalloc.c:3082
       kcov_mmap+0x28/0x130 kernel/kcov.c:465
       call_mmap include/linux/fs.h:2119 [inline]
       mmap_region+0x10e2/0x1da0 mm/mmap.c:1809
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

2 locks held by syz-fuzzer/8414:
 #0: ffff8880187fea28 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #0: ffff8880187fea28 (&mm->mmap_lock#2){++++}-{3:3}, at: vm_mmap_pgoff+0x14d/0x2b0 mm/util.c:517
 #1: ffff8880b9a31088 (lock#2){-.-.}-{2:2}, at: local_lock_acquire+0x7/0x130 include/linux/local_lock_internal.h:41

stack backtrace:
CPU: 0 PID: 8414 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
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
 __alloc_pages_bulk+0x9f6/0x10b0 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x3ad/0x7f0 mm/vmalloc.c:2947
 vmalloc_user+0x70/0x80 mm/vmalloc.c:3082
 kcov_mmap+0x28/0x130 kernel/kcov.c:465
 call_mmap include/linux/fs.h:2119 [inline]
 mmap_region+0x10e2/0x1da0 mm/mmap.c:1809
 do_mmap+0x930/0x11a0 mm/mmap.c:1585
 vm_mmap_pgoff+0x19e/0x2b0 mm/util.c:519
 ksys_mmap_pgoff+0x504/0x7b0 mm/mmap.c:1636
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0003715d8 EFLAGS: 00000212 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c00001c000 RCX: 00000000004af20a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c000371638 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000212 R12: 00000000007798c5
R13: 00000000000000de R14: 00000000000000dd R15: 0000000000000100
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8414, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 67846
hardirqs last  enabled at (67845): [<ffffffff89c89aab>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (67845): [<ffffffff89c89aab>] _raw_spin_unlock_irqrestore+0x8b/0x120 kernel/locking/spinlock.c:191
hardirqs last disabled at (67846): [<ffffffff81bee901>] __alloc_pages_bulk+0x801/0x10b0 mm/page_alloc.c:5291
softirqs last  enabled at (67050): [<ffffffff814d502b>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (67050): [<ffffffff814d502b>] __irq_exit_rcu+0x21b/0x260 kernel/softirq.c:636
softirqs last disabled at (66829): [<ffffffff814d502b>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (66829): [<ffffffff814d502b>] __irq_exit_rcu+0x21b/0x260 kernel/softirq.c:636
CPU: 0 PID: 8414 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
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
 __alloc_pages_bulk+0x9f6/0x10b0 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x3ad/0x7f0 mm/vmalloc.c:2947
 vmalloc_user+0x70/0x80 mm/vmalloc.c:3082
 kcov_mmap+0x28/0x130 kernel/kcov.c:465
 call_mmap include/linux/fs.h:2119 [inline]
 mmap_region+0x10e2/0x1da0 mm/mmap.c:1809
 do_mmap+0x930/0x11a0 mm/mmap.c:1585
 vm_mmap_pgoff+0x19e/0x2b0 mm/util.c:519
 ksys_mmap_pgoff+0x504/0x7b0 mm/mmap.c:1636
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0003715d8 EFLAGS: 00000212 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 000000c00001c000 RCX: 00000000004af20a
RDX: 0000000000000003 RSI: 0000000000080000 RDI: 0000000000000000
RBP: 000000c000371638 R08: 0000000000000006 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000212 R12: 00000000007798c5
R13: 00000000000000de R14: 00000000000000dd R15: 0000000000000100
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
