Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052203D4779
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 13:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhGXLGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 07:06:52 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49126 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhGXLGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 07:06:51 -0400
Received: by mail-io1-f71.google.com with SMTP id w4-20020a5ec2440000b029053e3f025a44so3826579iop.15
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 04:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DYsmBzq4OfNlb/hy4fyNyTG4cv8iWs0JjApu6R2fgls=;
        b=fuyaIsRCeH3EOh0QDciief/sDsG+FRzdoeYtN+o5eN0Cx6U1kQve9Ph9tjMHhCq2b7
         QFagowmA35fjdRuv5k+WJsaPyEW3NByC9YHzb/NW87S2KW3j5K+irMDl4nsaQdoLAxts
         a2INvxfO8wuzlw2TRNIbWGX22ARIYnJ+2Vt4UknIA3ih9WSAmtTQIRQRXHAUlChWiZN6
         MwRlXpFcaXup/uIPeYEDYPhMoeI1lpQRmXb/pjhFlDQNgOTvEUOpRPmjWvd/KZ5/mGAI
         TecCgfc2prbiUbU6uluCXuUXzmzewEl+rttTj1PIlOT0K85lGXF2YLBApUBBOC+Xwg2C
         8N2w==
X-Gm-Message-State: AOAM533qSQVQow9ADLvKiUc3E7Gt5TtoefycuXLnvqZqqrAEMPB5qDwN
        6RljVBOI+m0MgOMtSxg0fe6Xk1XzkwPwBFCn6d5txN55aHfY
X-Google-Smtp-Source: ABdhPJzIv10nkoRpj8lQSn3Ow098LWasORBC9iCP6IdAn5clAS5AB+UYucLE1ozA/ULM5ilrJohwRW/46Z2k1wYciZUD1v4BRmdW
MIME-Version: 1.0
X-Received: by 2002:a5d:8453:: with SMTP id w19mr7312853ior.105.1627127242157;
 Sat, 24 Jul 2021 04:47:22 -0700 (PDT)
Date:   Sat, 24 Jul 2021 04:47:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045f1a505c7dd15fd@google.com>
Subject: [syzbot] net-next test error: possible deadlock in fs_reclaim_acquire
From:   syzbot <syzbot+39cd5d23c010bddbaf8c@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fef773fc8110 netlink: Deal with ESRCH error in nlmsg_notif..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15be62f8300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
dashboard link: https://syzkaller.appspot.com/bug?extid=39cd5d23c010bddbaf8c

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+39cd5d23c010bddbaf8c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.14.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-fuzzer/8453 is trying to acquire lock:
ffffffff8ba9d240 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x160 mm/page_alloc.c:4574

but task is already holding lock:
ffff8880b9d4d660 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5279

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (lock#2){-.-.}-{2:2}:
       local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
       rmqueue_pcplist mm/page_alloc.c:3663 [inline]
       rmqueue mm/page_alloc.c:3701 [inline]
       get_page_from_freelist+0x4aa/0x2f80 mm/page_alloc.c:4163
       __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5374
       alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2119
       alloc_pages+0x238/0x2a0 mm/mempolicy.c:2242
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
       kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
       insert_work+0x48/0x370 kernel/workqueue.c:1332
       __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
       queue_work_on+0xee/0x110 kernel/workqueue.c:1525
       queue_work include/linux/workqueue.h:507 [inline]
       rpm_suspend+0x1062/0x1770 drivers/base/power/runtime.c:634
       rpm_idle+0x555/0x8b0 drivers/base/power/runtime.c:476
       __pm_runtime_idle+0xbb/0x2d0 drivers/base/power/runtime.c:1044
       pm_runtime_put include/linux/pm_runtime.h:422 [inline]
       link_peers drivers/usb/core/port.c:385 [inline]
       link_peers_report+0x25b/0x7a0 drivers/usb/core/port.c:394
       find_and_link_peer drivers/usb/core/port.c:528 [inline]
       usb_hub_create_port_device+0xb06/0xd50 drivers/usb/core/port.c:578
       hub_configure drivers/usb/core/hub.c:1651 [inline]
       hub_probe.cold+0x247d/0x2a77 drivers/usb/core/hub.c:1885
       usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
       call_driver_probe drivers/base/dd.c:517 [inline]
       really_probe+0x23c/0xcd0 drivers/base/dd.c:595
       __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:747
       driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:777
       __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:894
       bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
       __device_attach+0x228/0x4a0 drivers/base/dd.c:965
       bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
       device_add+0xc2f/0x2180 drivers/base/core.c:3352
       usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2170
       usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
       usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
       call_driver_probe drivers/base/dd.c:517 [inline]
       really_probe+0x23c/0xcd0 drivers/base/dd.c:595
       __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:747
       driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:777
       __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:894
       bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
       __device_attach+0x228/0x4a0 drivers/base/dd.c:965
       bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
       device_add+0xc2f/0x2180 drivers/base/core.c:3352
       usb_new_device.cold+0x63f/0x108e drivers/usb/core/hub.c:2559
       register_root_hub drivers/usb/core/hcd.c:1010 [inline]
       usb_add_hcd.cold+0x140c/0x1813 drivers/usb/core/hcd.c:2939
       vhci_hcd_probe+0x1c9/0x3a0 drivers/usb/usbip/vhci_hcd.c:1374
       platform_probe+0xfc/0x1f0 drivers/base/platform.c:1427
       call_driver_probe drivers/base/dd.c:517 [inline]
       really_probe+0x23c/0xcd0 drivers/base/dd.c:595
       __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:747
       driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:777
       __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:894
       bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
       __device_attach+0x228/0x4a0 drivers/base/dd.c:965
       bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
       device_add+0xc2f/0x2180 drivers/base/core.c:3352
       platform_device_add+0x363/0x820 drivers/base/platform.c:728
       vhci_hcd_init+0x341/0x485 drivers/usb/usbip/vhci_hcd.c:1544
       do_one_initcall+0x103/0x650 init/main.c:1282
       do_initcall_level init/main.c:1355 [inline]
       do_initcalls init/main.c:1371 [inline]
       do_basic_setup init/main.c:1391 [inline]
       kernel_init_freeable+0x6b8/0x741 init/main.c:1593
       kernel_init+0x1a/0x1d0 init/main.c:1485
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #1 (&pool->lock){-.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
       __queue_work+0x366/0xed0 kernel/workqueue.c:1455
       queue_work_on+0xee/0x110 kernel/workqueue.c:1525
       queue_work include/linux/workqueue.h:507 [inline]
       schedule_work include/linux/workqueue.h:568 [inline]
       __vfree_deferred mm/vmalloc.c:2609 [inline]
       vfree_atomic+0xac/0xe0 mm/vmalloc.c:2627
       free_thread_stack kernel/fork.c:292 [inline]
       release_task_stack kernel/fork.c:432 [inline]
       put_task_stack+0x2e0/0x4e0 kernel/fork.c:443
       finish_task_switch.isra.0+0x77f/0xa50 kernel/sched/core.c:4595
       context_switch kernel/sched/core.c:4686 [inline]
       __schedule+0x942/0x26f0 kernel/sched/core.c:5940
       preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:6328
       irqentry_exit+0x31/0x80 kernel/entry/common.c:427
       asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
       lock_acquire+0x1ef/0x510 kernel/locking/lockdep.c:5593
       __fs_reclaim_acquire mm/page_alloc.c:4552 [inline]
       fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4566
       might_alloc include/linux/sched/mm.h:198 [inline]
       slab_pre_alloc_hook mm/slab.h:485 [inline]
       slab_alloc_node mm/slub.c:2902 [inline]
       slab_alloc mm/slub.c:2989 [inline]
       kmem_cache_alloc+0x3e/0x3a0 mm/slub.c:2994
       dup_fd+0x89/0xca0 fs/file.c:295
       copy_files kernel/fork.c:1478 [inline]
       copy_process+0x213e/0x74d0 kernel/fork.c:2107
       kernel_clone+0xe7/0xac0 kernel/fork.c:2509
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
       __fs_reclaim_acquire mm/page_alloc.c:4552 [inline]
       fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4566
       prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5164
       __alloc_pages+0x12f/0x500 mm/page_alloc.c:5363
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       save_stack+0x15e/0x1e0 mm/page_owner.c:120
       __set_page_owner+0x50/0x290 mm/page_owner.c:181
       prep_new_page mm/page_alloc.c:2433 [inline]
       __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5301
       alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
       vm_area_alloc_pages mm/vmalloc.c:2793 [inline]
       __vmalloc_area_node mm/vmalloc.c:2863 [inline]
       __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2966
       __vmalloc_node mm/vmalloc.c:3015 [inline]
       vzalloc+0x67/0x80 mm/vmalloc.c:3085
       n_tty_open+0x16/0x170 drivers/tty/n_tty.c:1848
       tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:449
       tty_ldisc_setup+0x43/0x100 drivers/tty/tty_ldisc.c:766
       tty_init_dev.part.0+0x1f4/0x610 drivers/tty/tty_io.c:1453
       tty_init_dev include/linux/err.h:36 [inline]
       tty_open_by_driver drivers/tty/tty_io.c:2098 [inline]
       tty_open+0xb16/0x1000 drivers/tty/tty_io.c:2146
       chrdev_open+0x266/0x770 fs/char_dev.c:414
       do_dentry_open+0x4c8/0x11d0 fs/open.c:826
       do_open fs/namei.c:3374 [inline]
       path_openat+0x1c23/0x27f0 fs/namei.c:3507
       do_filp_open+0x1aa/0x400 fs/namei.c:3534
       do_sys_openat2+0x16d/0x420 fs/open.c:1204
       do_sys_open fs/open.c:1220 [inline]
       __do_sys_openat fs/open.c:1236 [inline]
       __se_sys_openat fs/open.c:1231 [inline]
       __x64_sys_openat+0x13f/0x1f0 fs/open.c:1231
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
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

4 locks held by syz-fuzzer/8453:
 #0: ffffffff8c378fc8 (tty_mutex){+.+.}-{3:3}, at: tty_open_by_driver drivers/tty/tty_io.c:2062 [inline]
 #0: ffffffff8c378fc8 (tty_mutex){+.+.}-{3:3}, at: tty_open+0x55e/0x1000 drivers/tty/tty_io.c:2146
 #1: ffff88803007f1c0 (&tty->legacy_mutex){+.+.}-{3:3}, at: tty_lock+0xbd/0x120 drivers/tty/tty_mutex.c:20
 #2: ffff88803007f098 (&tty->ldisc_sem){++++}-{0:0}, at: __tty_ldisc_lock drivers/tty/tty_ldisc.c:300 [inline]
 #2: ffff88803007f098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_lock+0x61/0xb0 drivers/tty/tty_ldisc.c:324
 #3: ffff8880b9d4d660 (lock#2){-.-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5279

stack backtrace:
CPU: 1 PID: 8453 Comm: syz-fuzzer Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __fs_reclaim_acquire mm/page_alloc.c:4552 [inline]
 fs_reclaim_acquire+0x117/0x160 mm/page_alloc.c:4566
 prepare_alloc_pages+0x15c/0x580 mm/page_alloc.c:5164
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5363
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2433 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5301
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2793 [inline]
 __vmalloc_area_node mm/vmalloc.c:2863 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2966
 __vmalloc_node mm/vmalloc.c:3015 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3085
 n_tty_open+0x16/0x170 drivers/tty/n_tty.c:1848
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:449
 tty_ldisc_setup+0x43/0x100 drivers/tty/tty_ldisc.c:766
 tty_init_dev.part.0+0x1f4/0x610 drivers/tty/tty_io.c:1453
 tty_init_dev include/linux/err.h:36 [inline]
 tty_open_by_driver drivers/tty/tty_io.c:2098 [inline]
 tty_open+0xb16/0x1000 drivers/tty/tty_io.c:2146
 chrdev_open+0x266/0x770 fs/char_dev.c:414
 do_dentry_open+0x4c8/0x11d0 fs/open.c:826
 do_open fs/namei.c:3374 [inline]
 path_openat+0x1c23/0x27f0 fs/namei.c:3507
 do_filp_open+0x1aa/0x400 fs/namei.c:3534
 do_sys_openat2+0x16d/0x420 fs/open.c:1204
 do_sys_open fs/open.c:1220 [inline]
 __do_sys_openat fs/open.c:1236 [inline]
 __se_sys_openat fs/open.c:1231 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1231
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0004333f8 EFLAGS: 00000216 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000000c00001c000 RCX: 00000000004af20a
RDX: 0000000000000000 RSI: 000000c000097830 RDI: ffffffffffffff9c
RBP: 000000c000433470 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000184
R13: 0000000000000183 R14: 0000000000000200 R15: 000000c00021dcc0
BUG: sleeping function called from invalid context at mm/page_alloc.c:5167
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8453, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 136898
hardirqs last  enabled at (136897): [<ffffffff892cd960>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (136897): [<ffffffff892cd960>] _raw_spin_unlock_irqrestore+0x50/0x70 kernel/locking/spinlock.c:191
hardirqs last disabled at (136898): [<ffffffff81b2db47>] __alloc_pages_bulk+0x1017/0x1870 mm/page_alloc.c:5279
softirqs last  enabled at (135410): [<ffffffff81462a6e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last  enabled at (135410): [<ffffffff81462a6e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
softirqs last disabled at (135397): [<ffffffff81462a6e>] invoke_softirq kernel/softirq.c:432 [inline]
softirqs last disabled at (135397): [<ffffffff81462a6e>] __irq_exit_rcu+0x16e/0x1c0 kernel/softirq.c:636
CPU: 1 PID: 8453 Comm: syz-fuzzer Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5167
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5363
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2433 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5301
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2793 [inline]
 __vmalloc_area_node mm/vmalloc.c:2863 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2966
 __vmalloc_node mm/vmalloc.c:3015 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3085
 n_tty_open+0x16/0x170 drivers/tty/n_tty.c:1848
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:449
 tty_ldisc_setup+0x43/0x100 drivers/tty/tty_ldisc.c:766
 tty_init_dev.part.0+0x1f4/0x610 drivers/tty/tty_io.c:1453
 tty_init_dev include/linux/err.h:36 [inline]
 tty_open_by_driver drivers/tty/tty_io.c:2098 [inline]
 tty_open+0xb16/0x1000 drivers/tty/tty_io.c:2146
 chrdev_open+0x266/0x770 fs/char_dev.c:414
 do_dentry_open+0x4c8/0x11d0 fs/open.c:826
 do_open fs/namei.c:3374 [inline]
 path_openat+0x1c23/0x27f0 fs/namei.c:3507
 do_filp_open+0x1aa/0x400 fs/namei.c:3534
 do_sys_openat2+0x16d/0x420 fs/open.c:1204
 do_sys_open fs/open.c:1220 [inline]
 __do_sys_openat fs/open.c:1236 [inline]
 __se_sys_openat fs/open.c:1231 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1231
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0004333f8 EFLAGS: 00000216 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000000c00001c000 RCX: 00000000004af20a
RDX: 0000000000000000 RSI: 000000c000097830 RDI: ffffffffffffff9c
RBP: 000000c000433470 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000184
R13: 0000000000000183 R14: 0000000000000200 R15: 000000c00021dcc0
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
base_sock_release(ffff888039b10000) sk=ffff888022d0b000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
