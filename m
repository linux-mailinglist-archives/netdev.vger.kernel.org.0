Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3327638285F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhEQJdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:33:43 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55977 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbhEQJdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:33:36 -0400
Received: by mail-io1-f70.google.com with SMTP id p2-20020a5d98420000b029043b3600ac76so51633ios.22
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=chYCG1eSiqpXo7g1lFMI2QJxaUDc/EJp8u1bZRzSMMI=;
        b=NRQqgFduCsB/7l3OXfX3AdYcwEO8wAt47oM7oY1r3Q5IxlaTm3zt8TNTkqecIsB+rl
         Nc6RrTNdYzaElFqNOGRT36HnmYDW/Io9dPI/uc6D0ndagmcxox6LYvQLbMk5/JgBQLXg
         tZOnHBS6T7ucbyckuG0jWdsVWF2QUlbKSa4R9JaxJ06iHNfzEowLHcbAaoHPHF1vqqW4
         yoS/wSs+WItt+WEmo3vkHWrP2hsFmzmmAq+xaSMq2joc4wLcccVjDRMyiHhhE+IaCumD
         sKDkz/9T2vb65/nNmGvu8tGWguiOnsSomXCXJHfewATo6XdSNuiZ88Yph6KqG/ZGZqMs
         dfkA==
X-Gm-Message-State: AOAM531f3E08UwCwPz5u8I+TT8vwuIlfM+aS6WJFN/+UOBiYn/vUlhCe
        XJfHIWgEXZ+fSsOfPhoFvu1QRJ1t6kSUHzqmr304FqJwRBXY
X-Google-Smtp-Source: ABdhPJxBYF7gz9opBvrlF/camk3rBOS+W61VNaQOw8GdBZhSBT5yvQ/bbsTHJyC9kJk7aVzPMvt5xpxlzqiN6X+kCvAmtXP6A1np
MIME-Version: 1.0
X-Received: by 2002:a5d:814d:: with SMTP id f13mr21285700ioo.203.1621243939921;
 Mon, 17 May 2021 02:32:19 -0700 (PDT)
Date:   Mon, 17 May 2021 02:32:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002227b805c28345f8@google.com>
Subject: [syzbot] possible deadlock in __schedule
From:   syzbot <syzbot+a9bb2f97117a3bb1b77d@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, shakeelb@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    88b06399 Merge tag 'for-5.13-rc1-part2-tag' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d47145d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e4fa783e79fe30c8
dashboard link: https://syzkaller.appspot.com/bug?extid=a9bb2f97117a3bb1b77d

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a9bb2f97117a3bb1b77d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.13.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.0/9979 is trying to acquire lock:
ffff88803ffffba0 (&pgdat->kswapd_wait){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

but task is already holding lock:
ffff88802cd35358 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1334 [inline]
ffff88802cd35358 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x23e0 kernel/sched/core.c:5061

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&rq->lock){-.-.}-{2:2}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
       rq_lock kernel/sched/sched.h:1334 [inline]
       task_fork_fair+0x74/0x4d0 kernel/sched/fair.c:10795
       sched_fork+0x3fc/0xbd0 kernel/sched/core.c:3792
       copy_process+0x1f32/0x7120 kernel/fork.c:2086
       kernel_clone+0xe7/0xab0 kernel/fork.c:2503
       kernel_thread+0xb5/0xf0 kernel/fork.c:2555
       rest_init+0x23/0x388 init/main.c:687
       start_kernel+0x475/0x496 init/main.c:1087
       secondary_startup_64_no_verify+0xb0/0xbb

-> #1 (&p->pi_lock){-.-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
       try_to_wake_up+0x98/0x14b0 kernel/sched/core.c:3364
       autoremove_wake_function+0x12/0x140 kernel/sched/wait.c:404
       __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
       __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
       wakeup_kswapd+0x3f8/0x640 mm/vmscan.c:4185
       rmqueue mm/page_alloc.c:3572 [inline]
       get_page_from_freelist+0x17bd/0x2b60 mm/page_alloc.c:3991
       __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       __page_cache_alloc mm/filemap.c:1005 [inline]
       __page_cache_alloc+0x303/0x3a0 mm/filemap.c:990
       pagecache_get_page+0x38f/0x18d0 mm/filemap.c:1885
       grab_cache_page_write_begin+0x64/0x90 mm/filemap.c:3610
       ext4_da_write_begin+0x35c/0x1160 fs/ext4/inode.c:2984
       generic_perform_write+0x20a/0x4f0 mm/filemap.c:3660
       ext4_buffered_write_iter+0x244/0x4d0 fs/ext4/file.c:269
       ext4_file_write_iter+0x423/0x14e0 fs/ext4/file.c:680
       call_write_iter include/linux/fs.h:2114 [inline]
       new_sync_write+0x426/0x650 fs/read_write.c:518
       vfs_write+0x796/0xa30 fs/read_write.c:605
       ksys_write+0x12d/0x250 fs/read_write.c:658
       do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (&pgdat->kswapd_wait){..-.}-{2:2}:
       check_prev_add kernel/locking/lockdep.c:2938 [inline]
       check_prevs_add kernel/locking/lockdep.c:3061 [inline]
       validate_chain kernel/locking/lockdep.c:3676 [inline]
       __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
       lock_acquire kernel/locking/lockdep.c:5512 [inline]
       lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
       __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137
       wakeup_kswapd+0x3f8/0x640 mm/vmscan.c:4185
       wake_all_kswapds+0x143/0x2c0 mm/page_alloc.c:4484
       __alloc_pages_slowpath.constprop.0+0x17c1/0x2140 mm/page_alloc.c:4756
       __alloc_pages+0x422/0x500 mm/page_alloc.c:5213
       alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
       stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
       kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
       kasan_record_aux_stack+0xa4/0xd0 mm/kasan/generic.c:345
       irq_work_queue_on+0x9f/0x160 kernel/irq_work.c:104
       balance_rt+0x202/0x2c0 kernel/sched/rt.c:1541
       put_prev_task_balance kernel/sched/core.c:4934 [inline]
       pick_next_task kernel/sched/core.c:4974 [inline]
       __schedule+0x134c/0x23e0 kernel/sched/core.c:5111
       schedule+0xcf/0x270 kernel/sched/core.c:5226
       schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
       io_schedule_timeout+0xcb/0x140 kernel/sched/core.c:7203
       do_wait_for_common kernel/sched/completion.c:85 [inline]
       __wait_for_common kernel/sched/completion.c:106 [inline]
       wait_for_common_io kernel/sched/completion.c:123 [inline]
       wait_for_completion_io_timeout+0x163/0x280 kernel/sched/completion.c:191
       submit_bio_wait+0x158/0x230 block/bio.c:1160
       blkdev_issue_flush+0xd6/0x130 block/blk-flush.c:446
       ext4_sync_file+0x60b/0xfd0 fs/ext4/fsync.c:177
       vfs_fsync_range+0x13a/0x220 fs/sync.c:200
       generic_write_sync include/linux/fs.h:2982 [inline]
       ext4_buffered_write_iter+0x36a/0x4d0 fs/ext4/file.c:277
       ext4_file_write_iter+0x423/0x14e0 fs/ext4/file.c:680
       call_write_iter include/linux/fs.h:2114 [inline]
       do_iter_readv_writev+0x46f/0x740 fs/read_write.c:740
       do_iter_write+0x188/0x670 fs/read_write.c:866
       vfs_iter_write+0x70/0xa0 fs/read_write.c:907
       iter_file_splice_write+0x6fa/0xc10 fs/splice.c:689
       do_splice_from fs/splice.c:767 [inline]
       direct_splice_actor+0x110/0x180 fs/splice.c:936
       splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
       do_splice_direct+0x1b3/0x280 fs/splice.c:979
       do_sendfile+0x9f0/0x1110 fs/read_write.c:1260
       __do_sys_sendfile64 fs/read_write.c:1319 [inline]
       __se_sys_sendfile64 fs/read_write.c:1311 [inline]
       __x64_sys_sendfile64+0x149/0x210 fs/read_write.c:1311
       do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  &pgdat->kswapd_wait --> &p->pi_lock --> &rq->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rq->lock);
                               lock(&p->pi_lock);
                               lock(&rq->lock);
  lock(&pgdat->kswapd_wait);

 *** DEADLOCK ***

2 locks held by syz-executor.0/9979:
 #0: ffff888023830460 (sb_writers#5){.+.+}-{0:0}, at: __do_sys_sendfile64 fs/read_write.c:1319 [inline]
 #0: ffff888023830460 (sb_writers#5){.+.+}-{0:0}, at: __se_sys_sendfile64 fs/read_write.c:1311 [inline]
 #0: ffff888023830460 (sb_writers#5){.+.+}-{0:0}, at: __x64_sys_sendfile64+0x149/0x210 fs/read_write.c:1311
 #1: ffff88802cd35358 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1334 [inline]
 #1: ffff88802cd35358 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x23e0 kernel/sched/core.c:5061

stack backtrace:
CPU: 3 PID: 9979 Comm: syz-executor.0 Not tainted 5.13.0-rc1-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2129
 check_prev_add kernel/locking/lockdep.c:2938 [inline]
 check_prevs_add kernel/locking/lockdep.c:3061 [inline]
 validate_chain kernel/locking/lockdep.c:3676 [inline]
 __lock_acquire+0x2a17/0x5230 kernel/locking/lockdep.c:4902
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137
 wakeup_kswapd+0x3f8/0x640 mm/vmscan.c:4185
 wake_all_kswapds+0x143/0x2c0 mm/page_alloc.c:4484
 __alloc_pages_slowpath.constprop.0+0x17c1/0x2140 mm/page_alloc.c:4756
 __alloc_pages+0x422/0x500 mm/page_alloc.c:5213
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 kasan_save_stack+0x32/0x40 mm/kasan/common.c:40
 kasan_record_aux_stack+0xa4/0xd0 mm/kasan/generic.c:345
 irq_work_queue_on+0x9f/0x160 kernel/irq_work.c:104
 balance_rt+0x202/0x2c0 kernel/sched/rt.c:1541
 put_prev_task_balance kernel/sched/core.c:4934 [inline]
 pick_next_task kernel/sched/core.c:4974 [inline]
 __schedule+0x134c/0x23e0 kernel/sched/core.c:5111
 schedule+0xcf/0x270 kernel/sched/core.c:5226
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_schedule_timeout+0xcb/0x140 kernel/sched/core.c:7203
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common_io kernel/sched/completion.c:123 [inline]
 wait_for_completion_io_timeout+0x163/0x280 kernel/sched/completion.c:191
 submit_bio_wait+0x158/0x230 block/bio.c:1160
 blkdev_issue_flush+0xd6/0x130 block/blk-flush.c:446
 ext4_sync_file+0x60b/0xfd0 fs/ext4/fsync.c:177
 vfs_fsync_range+0x13a/0x220 fs/sync.c:200
 generic_write_sync include/linux/fs.h:2982 [inline]
 ext4_buffered_write_iter+0x36a/0x4d0 fs/ext4/file.c:277
 ext4_file_write_iter+0x423/0x14e0 fs/ext4/file.c:680
 call_write_iter include/linux/fs.h:2114 [inline]
 do_iter_readv_writev+0x46f/0x740 fs/read_write.c:740
 do_iter_write+0x188/0x670 fs/read_write.c:866
 vfs_iter_write+0x70/0xa0 fs/read_write.c:907
 iter_file_splice_write+0x6fa/0xc10 fs/splice.c:689
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0x9f0/0x1110 fs/read_write.c:1260
 __do_sys_sendfile64 fs/read_write.c:1319 [inline]
 __se_sys_sendfile64 fs/read_write.c:1311 [inline]
 __x64_sys_sendfile64+0x149/0x210 fs/read_write.c:1311
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f354f1c3188 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 000000000056c158 RCX: 00000000004665f9
RDX: 0000000020000100 RSI: 0000000000000006 RDI: 0000000000000006
RBP: 00000000004bfce1 R08: 0000000000000000 R09: 0000000000000000
R10: 00008080ffffff80 R11: 0000000000000246 R12: 000000000056c158
R13: 00007fff4004641f R14: 00007f354f1c3300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
