Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379E23CF039
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377512AbhGSXGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:06:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:33663 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391079AbhGSV7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:59:42 -0400
Received: by mail-il1-f200.google.com with SMTP id b8-20020a92c8480000b0290208fe58bd16so11708219ilq.0
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 15:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wvbx2lFoJaYLHpKBT7uEznFCmvL6zfJHEmDc9KPwefU=;
        b=LMVbIDftsmXijQjyU6KoK4dWVkSq1KJu20bdLRGnK+0fkQt6uo/fHZvJmSKQEPtQ9G
         f4o5Dmq2w+4gcOq7zvEA2SJY8hZoQU4ALrAmLQtp7mGuJHKC9JmZaWFdAjgRSuqirw2n
         eDnSo+SCsYWIgShE44jMrRyCfjmmQuhr2IBFBvTDIVVDxjeu/08N6y4jsWyp0LM0IDZG
         CXwp7w75Vi4u2W2Ny73eAT9yWn2QlHrGTsBsrcjDfesJOxYCt+qS49O8BCkPt8EuIcOS
         CkSKE1l45VSvi/e4HkvS7h2fxAyz6ZfTC95aOiCALdc3DL8xRrPZG5VnWI5I7hiqCQAk
         XarA==
X-Gm-Message-State: AOAM5307qSk/Teadijf+Hw/hONynkJ8Q7aMxdIACSyVYyKazjFc5Ztf5
        9Wn6e3v547x0FmmFGGTddRHPlQGXgD7gjuCCFPVm7VD6525E
X-Google-Smtp-Source: ABdhPJzb1JhKDQW44G27Vhe0CmTGoYrgsuQOQKSe4bIWmSRNKqenxCiIxXhBiuYjAv0rvwalCBZQtZfb9Xwf9ANhTO0AMocH9CJ5
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c7:: with SMTP id 7mr2699127ilx.269.1626734420560;
 Mon, 19 Jul 2021 15:40:20 -0700 (PDT)
Date:   Mon, 19 Jul 2021 15:40:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048155f05c7819fbc@google.com>
Subject: [syzbot] bpf test error: possible deadlock in fs_reclaim_acquire
From:   syzbot <syzbot+12a265012f9ce626f9de@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    91091656252f s390/bpf: Perform r1 range checking before ac..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=14954378300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51ea6c9df4ed04c4
dashboard link: https://syzkaller.appspot.com/bug?extid=12a265012f9ce626f9de

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12a265012f9ce626f9de@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-fuzzer/8445 is trying to acquire lock:
ffffffff8ba9c180 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x160 mm/page_alloc.c:4586

but task is already holding lock:
ffff8880b9c4d620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (lock#2){-.-.}-{2:2}:
       local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
       rmqueue_pcplist mm/page_alloc.c:3675 [inline]
       rmqueue mm/page_alloc.c:3713 [inline]
       get_page_from_freelist+0x4aa/0x2f80 mm/page_alloc.c:4175
       __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5386
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
       kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
       insert_work+0x48/0x370 kernel/workqueue.c:1332
       __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
       queue_work_on+0xee/0x110 kernel/workqueue.c:1525
       rcu_do_batch kernel/rcu/tree.c:2558 [inline]
       rcu_core+0x7ab/0x1380 kernel/rcu/tree.c:2793
       __do_softirq+0x29b/0x9bd kernel/softirq.c:558
       invoke_softirq kernel/softirq.c:432 [inline]
       __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
       irq_exit_rcu+0x5/0x20 kernel/softirq.c:648
       sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       rol32 include/linux/bitops.h:108 [inline]
       jhash2 include/linux/jhash.h:129 [inline]
       hash_stack lib/stackdepot.c:181 [inline]
       stack_depot_save+0xe8/0x4e0 lib/stackdepot.c:273
       kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
       kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
       kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
       ____kasan_slab_free mm/kasan/common.c:366 [inline]
       ____kasan_slab_free mm/kasan/common.c:328 [inline]
       __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
       kasan_slab_free include/linux/kasan.h:229 [inline]
       slab_free_hook mm/slub.c:1639 [inline]
       slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1664
       slab_free mm/slub.c:3224 [inline]
       kmem_cache_free+0x8e/0x5a0 mm/slub.c:3240
       add_system_zone+0x48e/0x690 fs/ext4/block_validity.c:108
       ext4_setup_system_zone+0x230/0xab0 fs/ext4/block_validity.c:244
       ext4_fill_super+0x7ccc/0xe440 fs/ext4/super.c:4990
       mount_bdev+0x34d/0x410 fs/super.c:1368
       legacy_get_tree+0x105/0x220 fs/fs_context.c:592
       vfs_get_tree+0x89/0x2f0 fs/super.c:1498
       do_new_mount fs/namespace.c:2905 [inline]
       path_mount+0x132a/0x1fa0 fs/namespace.c:3235
       init_mount+0xaa/0xf4 fs/init.c:25
       do_mount_root+0x9c/0x25b init/do_mounts.c:386
       mount_block_root+0x32e/0x4dd init/do_mounts.c:417
       mount_root+0x1af/0x1f5 init/do_mounts.c:555
       prepare_namespace+0x1ff/0x234 init/do_mounts.c:607
       kernel_init_freeable+0x729/0x741 init/main.c:1570
       kernel_init+0x1a/0x1d0 init/main.c:1449
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #1 (&pool->lock){-.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
       __queue_work+0x366/0xed0 kernel/workqueue.c:1455
       queue_work_on+0xee/0x110 kernel/workqueue.c:1525
       queue_work include/linux/workqueue.h:507 [inline]
       schedule_work include/linux/workqueue.h:568 [inline]
       __vfree_deferred mm/vmalloc.c:2591 [inline]
       vfree_atomic+0xac/0xe0 mm/vmalloc.c:2609
       free_thread_stack kernel/fork.c:292 [inline]
       release_task_stack kernel/fork.c:432 [inline]
       put_task_stack+0x2e0/0x4e0 kernel/fork.c:443
       finish_task_switch.isra.0+0x77f/0xa50 kernel/sched/core.c:4595
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0x93c/0x2710 kernel/sched/core.c:5940
       preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6328
       irqentry_exit+0x31/0x80 kernel/entry/common.c:427
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5593
       __fs_reclaim_acquire mm/page_alloc.c:4564 [inline]
       fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4578
       might_alloc include/linux/sched/mm.h:198 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc_node mm/slub.c:2891 [inline]
       slab_alloc mm/slub.c:2978 [inline]
       kmem_cache_alloc+0x3e/0x4a0 mm/slub.c:2983
       prepare_creds+0x3f/0x7b0 kernel/cred.c:262
       copy_creds+0x9f/0xb20 kernel/cred.c:367
       copy_process+0x1413/0x74c0 kernel/fork.c:1992
       kernel_clone+0xe7/0xab0 kernel/fork.c:2509
       kernel_thread+0xb5/0xf0 kernel/fork.c:2561
       call_usermodehelper_exec_work kernel/umh.c:174 [inline]
       call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:160
       process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
       worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
       kthread+0x3e5/0x4d0 kernel/kthread.c:319
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
       __vmalloc+0x69/0x80 mm/vmalloc.c:3010
       snd_dma_alloc_pages+0x433/0x590 sound/core/memalloc.c:150
       do_alloc_pages+0x9b/0x160 sound/core/pcm_memory.c:43
       snd_pcm_lib_malloc_pages+0x3f6/0x880 sound/core/pcm_memory.c:404
       snd_pcm_hw_params+0x1408/0x1990 sound/core/pcm_native.c:705
       snd_pcm_kernel_ioctl+0xd1/0x240 sound/core/pcm_native.c:3332
       snd_pcm_oss_change_params_locked+0x1958/0x3990 sound/core/oss/pcm_oss.c:947
       snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1090 [inline]
       snd_pcm_oss_make_ready+0xe7/0x1b0 sound/core/oss/pcm_oss.c:1149
       snd_pcm_oss_sync+0x1de/0x800 sound/core/oss/pcm_oss.c:1714
       snd_pcm_oss_release+0x276/0x300 sound/core/oss/pcm_oss.c:2556
       __fput+0x288/0x920 fs/file_table.c:280
       task_work_run+0xdd/0x1a0 kernel/task_work.c:164
       tracehook_notify_resume include/linux/tracehook.h:189 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
       exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
       __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
       syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
       do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &pool->lock --> lock#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(lock#2);
                               lock(&pool->lock);
                               lock(lock#2);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by syz-fuzzer/8445:
 #0: ffff88802e47e440 (&runtime->oss.params_lock){+.+.}-{3:3}, at: snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1087 [inline]
 #0: ffff88802e47e440 (&runtime->oss.params_lock){+.+.}-{3:3}, at: snd_pcm_oss_make_ready+0xc7/0x1b0 sound/core/oss/pcm_oss.c:1149
 #1: ffff8880b9c4d620 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 0 PID: 8445 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
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
 __vmalloc+0x69/0x80 mm/vmalloc.c:3010
 snd_dma_alloc_pages+0x433/0x590 sound/core/memalloc.c:150
 do_alloc_pages+0x9b/0x160 sound/core/pcm_memory.c:43
 snd_pcm_lib_malloc_pages+0x3f6/0x880 sound/core/pcm_memory.c:404
 snd_pcm_hw_params+0x1408/0x1990 sound/core/pcm_native.c:705
 snd_pcm_kernel_ioctl+0xd1/0x240 sound/core/pcm_native.c:3332
 snd_pcm_oss_change_params_locked+0x1958/0x3990 sound/core/oss/pcm_oss.c:947
 snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1090 [inline]
 snd_pcm_oss_make_ready+0xe7/0x1b0 sound/core/oss/pcm_oss.c:1149
 snd_pcm_oss_sync+0x1de/0x800 sound/core/oss/pcm_oss.c:1714
 snd_pcm_oss_release+0x276/0x300 sound/core/oss/pcm_oss.c:2556
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af19b
Code: fb ff eb bd e8 a6 b6 fb ff e9 61 ff ff ff cc e8 9b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
RSP: 002b:000000c00037d430 EFLAGS: 00000206 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000c00001c000 RCX: 00000000004af19b
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 000000c00037d470 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 000000000000013f
R13: 000000000000013e R14: 0000000000000200 R15: 000000c000293400
BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8445, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 114834
hardirqs last  enabled at (114833): [<ffffffff89228250>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (114833): [<ffffffff89228250>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (114834): [<ffffffff81b21dc7>] __alloc_pages_bulk+0x1017/0x1870 mm/page_alloc.c:5291
softirqs last  enabled at (114470): [<ffffffff8146347e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (114470): [<ffffffff8146347e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
softirqs last disabled at (114449): [<ffffffff8146347e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (114449): [<ffffffff8146347e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
CPU: 0 PID: 8445 Comm: syz-fuzzer Not tainted 5.13.0-syzkaller #0
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
 __vmalloc+0x69/0x80 mm/vmalloc.c:3010
 snd_dma_alloc_pages+0x433/0x590 sound/core/memalloc.c:150
 do_alloc_pages+0x9b/0x160 sound/core/pcm_memory.c:43
 snd_pcm_lib_malloc_pages+0x3f6/0x880 sound/core/pcm_memory.c:404
 snd_pcm_hw_params+0x1408/0x1990 sound/core/pcm_native.c:705
 snd_pcm_kernel_ioctl+0xd1/0x240 sound/core/pcm_native.c:3332
 snd_pcm_oss_change_params_locked+0x1958/0x3990 sound/core/oss/pcm_oss.c:947
 snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1090 [inline]
 snd_pcm_oss_make_ready+0xe7/0x1b0 sound/core/oss/pcm_oss.c:1149
 snd_pcm_oss_sync+0x1de/0x800 sound/core/oss/pcm_oss.c:1714
 snd_pcm_oss_release+0x276/0x300 sound/core/oss/pcm_oss.c:2556
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af19b
Code: fb ff eb bd e8 a6 b6 fb ff e9 61 ff ff ff cc e8 9b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
RSP: 002b:000000c00037d430 EFLAGS: 00000206 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000c00001c000 RCX: 00000000004af19b
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 000000c00037d470 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 000000000000013f
R13: 000000000000013e R14: 0000000000000200 R15: 000000c000293400
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
base_sock_release(ffff88803967c540) sk=ffff888020e7c000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
