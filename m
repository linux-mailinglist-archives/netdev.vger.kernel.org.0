Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C79C3BAC15
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhGDIUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:20:07 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:36848 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhGDIUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:20:05 -0400
Received: by mail-il1-f198.google.com with SMTP id v4-20020a92cd440000b02901ee67a35b12so8666929ilq.3
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 01:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FFGRgBB1exUOjDkoKujWbrYZKfR9vAsSpHGDZx2QXDQ=;
        b=fNxH5rXdz9tUPjg+0phJ8ERtRCepvbHj76vShlbuua3TMQMPqNqxTb9THFm6VLzDul
         nEVkKSFwLTA8jbUSlR7/9qFAOkOI3le4nIHvGVtbG0iQ5EgGeDLcBG0q4G8BmD6cykwG
         h0iAM4x6FwCdI4vB2j22/2L7D4YKK6HnnzG79YY4t0REMY6DWXxZEVTtrV0IpLA00Epd
         /X8xsB1Y7K7i+q4v0pZvOuBv81BiiCSl4eKdZyCwiHnm9Lqo0+dxsJIR6fXJKwtnekYF
         E34DK9O8IXj0fQQQJoMPGP87IiQrVq8KsAKBU1p10boaM+ByNQTG4BARbbc76FavmQKS
         7wmA==
X-Gm-Message-State: AOAM530HiA4RTtkvQtJVop1efg8QNS3DFvNQvGkwDYMmtDFCa2wp4ynn
        X3X1QhzumEIsP1MBOA+wFn4oT9uEby18nIV6SUuyB1SCHVjD
X-Google-Smtp-Source: ABdhPJyG24RbzVK+EgV+wIApEINBeMWPbKtmY0JQIv6jvMWU2D858c8FfEc3RxlzWIhxrBnUOK2croCKUlJPGCJWoCbdfqNoRwU3
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a64:: with SMTP id w4mr6105084ilv.232.1625386649555;
 Sun, 04 Jul 2021 01:17:29 -0700 (PDT)
Date:   Sun, 04 Jul 2021 01:17:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de9bde05c647d15b@google.com>
Subject: [syzbot] possible deadlock in fs_reclaim_acquire (3)
From:   syzbot <syzbot+e4297c8090dc600ba884@syzkaller.appspotmail.com>
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

HEAD commit:    3dbdb38e Merge branch 'for-5.14' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1156c149d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90b227e3653ac0d7
dashboard link: https://syzkaller.appspot.com/bug?extid=e4297c8090dc600ba884
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10613b94300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4297c8090dc600ba884@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-execprog/8452 is trying to acquire lock:
ffffffff8c297880 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x160 mm/page_alloc.c:4586

but task is already holding lock:
ffff8880b9d31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (lock#2){-.-.}-{2:2}:
       local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
       free_unref_page+0x1bf/0x690 mm/page_alloc.c:3439
       mm_free_pgd kernel/fork.c:636 [inline]
       __mmdrop+0xcb/0x3f0 kernel/fork.c:687
       mmdrop include/linux/sched/mm.h:49 [inline]
       finish_task_switch.isra.0+0x6da/0xa50 kernel/sched/core.c:4582
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0x93c/0x2710 kernel/sched/core.c:5940
       preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6328
       irqentry_exit+0x31/0x80 kernel/entry/common.c:427
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5593
       fs_reclaim_acquire mm/page_alloc.c:4581 [inline]
       fs_reclaim_acquire+0xd2/0x160 mm/page_alloc.c:4572
       prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5176
       __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       __page_cache_alloc mm/filemap.c:1005 [inline]
       __page_cache_alloc+0x303/0x3a0 mm/filemap.c:990
       page_cache_ra_unbounded+0x348/0x930 mm/readahead.c:215
       do_page_cache_ra mm/readahead.c:267 [inline]
       ondemand_readahead+0x65c/0x1190 mm/readahead.c:550
       page_cache_async_ra mm/readahead.c:607 [inline]
       page_cache_async_ra+0x2e1/0x3f0 mm/readahead.c:582
       page_cache_async_readahead include/linux/pagemap.h:907 [inline]
       filemap_readahead mm/filemap.c:2442 [inline]
       filemap_get_pages+0x61a/0x1950 mm/filemap.c:2483
       filemap_read+0x2ca/0xe40 mm/filemap.c:2550
       generic_file_read_iter+0x397/0x4f0 mm/filemap.c:2701
       ext4_file_read_iter+0x1d4/0x5d0 fs/ext4/file.c:130
       __kernel_read+0x58d/0xa90 fs/read_write.c:454
       integrity_kernel_read+0x7b/0xb0 security/integrity/iint.c:199
       ima_calc_file_hash_tfm+0x2aa/0x3b0 security/integrity/ima/ima_crypto.c:484
       ima_calc_file_shash security/integrity/ima/ima_crypto.c:515 [inline]
       ima_calc_file_hash+0x19d/0x4b0 security/integrity/ima/ima_crypto.c:572
       ima_collect_measurement+0x4ca/0x570 security/integrity/ima/ima_api.c:252
       process_measurement+0xd1c/0x17e0 security/integrity/ima/ima_main.c:330
       ima_file_check+0xb9/0x100 security/integrity/ima/ima_main.c:499
       do_open fs/namei.c:3363 [inline]
       path_openat+0x15b5/0x27e0 fs/namei.c:3494
       do_filp_open+0x190/0x3d0 fs/namei.c:3521
       do_sys_openat2+0x16d/0x420 fs/open.c:1195
       do_sys_open fs/open.c:1211 [inline]
       __do_sys_open fs/open.c:1219 [inline]
       __se_sys_open fs/open.c:1215 [inline]
       __x64_sys_open+0x119/0x1c0 fs/open.c:1215
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #1 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}:
       fs_reclaim_acquire mm/page_alloc.c:4581 [inline]
       fs_reclaim_acquire+0xd2/0x160 mm/page_alloc.c:4572
       might_alloc include/linux/sched/mm.h:198 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc mm/slab.c:3306 [inline]
       kmem_cache_alloc_trace+0x39/0x480 mm/slab.c:3573
       kmalloc include/linux/slab.h:591 [inline]
       kzalloc include/linux/slab.h:721 [inline]
       alloc_workqueue_attrs+0x38/0x80 kernel/workqueue.c:3365
       wq_numa_init kernel/workqueue.c:5899 [inline]
       workqueue_init+0x94/0x979 kernel/workqueue.c:6031
       kernel_init_freeable+0x3fb/0x741 init/main.c:1541
       kernel_init+0x1a/0x1d0 init/main.c:1449
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

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
       __vmalloc_node mm/vmalloc.c:2996 [inline]
       __vmalloc_area_node mm/vmalloc.c:2828 [inline]
       __vmalloc_node_range+0x313/0x960 mm/vmalloc.c:2947
       vmalloc_user+0x67/0x80 mm/vmalloc.c:3082
       security_read_policy+0x126/0x2c0 security/selinux/ss/services.c:4032
       sel_open_policy+0x2dc/0x660 security/selinux/selinuxfs.c:421
       do_dentry_open+0x4c8/0x11c0 fs/open.c:826
       do_open fs/namei.c:3361 [inline]
       path_openat+0x1c0e/0x27e0 fs/namei.c:3494
       do_filp_open+0x190/0x3d0 fs/namei.c:3521
       do_sys_openat2+0x16d/0x420 fs/open.c:1195
       do_sys_open fs/open.c:1211 [inline]
       __do_sys_openat fs/open.c:1227 [inline]
       __se_sys_openat fs/open.c:1222 [inline]
       __x64_sys_openat+0x13f/0x1f0 fs/open.c:1222
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> mmu_notifier_invalidate_range_start --> lock#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lock#2);
                               lock(mmu_notifier_invalidate_range_start);
                               lock(lock#2);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by syz-execprog/8452:
 #0: ffffffff90b710c0 (&selinux_state.policy_mutex){+.+.}-{3:3}, at: sel_open_policy+0xe3/0x660 security/selinux/selinuxfs.c:404
 #1: ffff8880b9d31620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 1 PID: 8452 Comm: syz-execprog Not tainted 5.13.0-syzkaller #0
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
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 __vmalloc_area_node mm/vmalloc.c:2828 [inline]
 __vmalloc_node_range+0x313/0x960 mm/vmalloc.c:2947
 vmalloc_user+0x67/0x80 mm/vmalloc.c:3082
 security_read_policy+0x126/0x2c0 security/selinux/ss/services.c:4032
 sel_open_policy+0x2dc/0x660 security/selinux/selinuxfs.c:421
 do_dentry_open+0x4c8/0x11c0 fs/open.c:826
 do_open fs/namei.c:3361 [inline]
 path_openat+0x1c0e/0x27e0 fs/namei.c:3494
 do_filp_open+0x190/0x3d0 fs/namei.c:3521
 do_sys_openat2+0x16d/0x420 fs/open.c:1195
 do_sys_open fs/open.c:1211 [inline]
 __do_sys_openat fs/open.c:1227 [inline]
 __se_sys_openat fs/open.c:1222 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1222
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4b132a
Code: e8 db 57 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c00009db20 EFLAGS: 00000206 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000000c000020800 RCX: 00000000004b132a
RDX: 0000000000080000 RSI: 000000c000682160 RDI: ffffffffffffff9c
RBP: 000000c00009db98 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
R13: 000000000000000c R14: 000000000000000b R15: 0000000000000100
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8452, name: syz-execprog
INFO: lockdep is turned off.
irq event stamp: 7542
hardirqs last  enabled at (7541): [<ffffffff89244350>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (7541): [<ffffffff89244350>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (7542): [<ffffffff81b146e7>] __alloc_pages_bulk+0x1017/0x1870 mm/page_alloc.c:5291
softirqs last  enabled at (7438): [<ffffffff814568be>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (7438): [<ffffffff814568be>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
softirqs last disabled at (7433): [<ffffffff814568be>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (7433): [<ffffffff814568be>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
CPU: 1 PID: 8452 Comm: syz-execprog Not tainted 5.13.0-syzkaller #0
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
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 __vmalloc_area_node mm/vmalloc.c:2828 [inline]
 __vmalloc_node_range+0x313/0x960 mm/vmalloc.c:2947
 vmalloc_user+0x67/0x80 mm/vmalloc.c:3082
 security_read_policy+0x126/0x2c0 security/selinux/ss/services.c:4032
 sel_open_policy+0x2dc/0x660 security/selinux/selinuxfs.c:421
 do_dentry_open+0x4c8/0x11c0 fs/open.c:826
 do_open fs/namei.c:3361 [inline]
 path_openat+0x1c0e/0x27e0 fs/namei.c:3494
 do_filp_open+0x190/0x3d0 fs/namei.c:3521
 do_sys_openat2+0x16d/0x420 fs/open.c:1195
 do_sys_open fs/open.c:1211 [inline]
 __do_sys_openat fs/open.c:1227 [inline]
 __se_sys_openat fs/open.c:1222 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1222
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4b132a
Code: e8 db 57 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c00009db20 EFLAGS: 00000206 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000000c000020800 RCX: 00000000004b132a
RDX: 0000000000080000 RSI: 000000c000682160 RDI: ffffffffffffff9c
RBP: 000000c00009db98 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffffff
R13: 000000000000000c R14: 000000000000000b R15: 0000000000000100


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
