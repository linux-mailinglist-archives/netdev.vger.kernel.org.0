Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E973207F7
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 02:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBUB3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 20:29:08 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:53440 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhBUB3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 20:29:01 -0500
Received: by mail-il1-f199.google.com with SMTP id s12so5543349ilh.20
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 17:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ldGbwdnoWRyU8djcYy/N9OqGQb/IL1w1x4/+F3IbWx8=;
        b=pSLkGZjNldan/mXCWUZb3tPjj2ImspzXhFmVd6pyxLkLMga5JkDXwuxSoKpGtkRDJf
         tTq6KRJqBQXr5NhoMPGmU9IIr1N8p3h8exp1cYfq1hb7+L/kyBoGVx/62kghYVlS1esv
         YUiYzQgmVI8DA1aHdOqGxC9rzAN0x7LQX+zJgYF1CA1wJNTG+7+v9Oc76IbdleJUimHi
         SIGv3EWgciJxDSufG7WzCXo9hY3mvdsxyaWUe/opW8JfIwvGQ0bMT4xdJ9j2hO4I9ZeP
         +WbqkLbhcJxjhyMvcyV1DUlFmDjWDSQUFIsR24fuhdPNYjkZLxccf4TeUbPgt4Ijhun8
         wLlw==
X-Gm-Message-State: AOAM530Svf4oQ5HKweJUFeO6Qae9tjfGjOFfMqrkP/sXIvTaHmR5tvmp
        UGYqQlprxHXXHeZVmZnJER6PKrPifwfWH1xAQwWC5J41+M6t
X-Google-Smtp-Source: ABdhPJxsTxKRhsAovjmY87uaBHL7dIAaW/yMqjoiphV8RllEhcZ9AGm7d3UHee5WqMV1jJWoD2gNa2WUXw1giwM2LFMzqV3o9Fmc
MIME-Version: 1.0
X-Received: by 2002:a6b:b24e:: with SMTP id b75mr10066746iof.108.1613870900093;
 Sat, 20 Feb 2021 17:28:20 -0800 (PST)
Date:   Sat, 20 Feb 2021 17:28:20 -0800
In-Reply-To: <00000000000058dc4205b40f4dbf@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6a82c05bbce99d1@google.com>
Subject: Re: KASAN: use-after-free Read in blk_update_request
From:   syzbot <syzbot+a3f809f70c0f239cda46@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kpsingh@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1156374ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b919ebed7b4902
dashboard link: https://syzkaller.appspot.com/bug?extid=a3f809f70c0f239cda46
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143ee67ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1585d40cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a3f809f70c0f239cda46@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in debug_spin_unlock kernel/locking/spinlock_debug.c:97 [inline]
BUG: KASAN: use-after-free in do_raw_spin_unlock+0x481/0x8a0 kernel/locking/spinlock_debug.c:138
Read of size 4 at addr ffff888020c03154 by task ksoftirqd/0/12

CPU: 0 PID: 12 Comm: ksoftirqd/0 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:120
 print_address_description+0x5f/0x3a0 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report+0x15e/0x200 mm/kasan/report.c:413
 debug_spin_unlock kernel/locking/spinlock_debug.c:97 [inline]
 do_raw_spin_unlock+0x481/0x8a0 kernel/locking/spinlock_debug.c:138
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:159 [inline]
 _raw_spin_unlock_irqrestore+0x20/0x60 kernel/locking/spinlock.c:191
 spin_unlock_irqrestore include/linux/spinlock.h:409 [inline]
 __wake_up_common_lock kernel/sched/wait.c:140 [inline]
 __wake_up+0xe2/0x140 kernel/sched/wait.c:157
 req_bio_endio block/blk-core.c:264 [inline]
 blk_update_request+0x7f7/0x14f0 block/blk-core.c:1462
 blk_mq_end_request+0x39/0x70 block/blk-mq.c:564
 blk_done_softirq+0x2fd/0x380 block/blk-mq.c:588
 __do_softirq+0x318/0x714 kernel/softirq.c:343
 run_ksoftirqd+0x63/0xa0 kernel/softirq.c:650
 smpboot_thread_fn+0x572/0x970 kernel/smpboot.c:165
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 8906:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc+0xbd/0xf0 mm/kasan/common.c:429
 kasan_kmalloc include/linux/kasan.h:219 [inline]
 kmem_cache_alloc_trace+0x200/0x300 mm/slub.c:2919
 kmalloc include/linux/slab.h:552 [inline]
 lbmLogInit fs/jfs/jfs_logmgr.c:1829 [inline]
 lmLogInit+0x26e/0x1530 fs/jfs/jfs_logmgr.c:1278
 open_inline_log fs/jfs/jfs_logmgr.c:1183 [inline]
 lmLogOpen+0x4c6/0xeb0 fs/jfs/jfs_logmgr.c:1077
 jfs_mount_rw+0x91/0x4a0 fs/jfs/jfs_mount.c:259
 jfs_fill_super+0x57e/0x960 fs/jfs/super.c:571
 mount_bdev+0x26c/0x3a0 fs/super.c:1366
 legacy_get_tree+0xea/0x180 fs/fs_context.c:592
 vfs_get_tree+0x86/0x270 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x17ad/0x2a00 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount+0x28c/0x320 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8906:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe2/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0xd6/0x1a0 mm/slub.c:1580
 slab_free mm/slub.c:3143 [inline]
 kfree+0xd1/0x2a0 mm/slub.c:4139
 lbmLogShutdown fs/jfs/jfs_logmgr.c:1872 [inline]
 lmLogInit+0xfb5/0x1530 fs/jfs/jfs_logmgr.c:1423
 open_inline_log fs/jfs/jfs_logmgr.c:1183 [inline]
 lmLogOpen+0x4c6/0xeb0 fs/jfs/jfs_logmgr.c:1077
 jfs_mount_rw+0x91/0x4a0 fs/jfs/jfs_mount.c:259
 jfs_fill_super+0x57e/0x960 fs/jfs/super.c:571
 mount_bdev+0x26c/0x3a0 fs/super.c:1366
 legacy_get_tree+0xea/0x180 fs/fs_context.c:592
 vfs_get_tree+0x86/0x270 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x17ad/0x2a00 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount+0x28c/0x320 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Last potentially related work creation:
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
 kasan_record_aux_stack+0xcc/0x100 mm/kasan/generic.c:344
 insert_work+0x54/0x400 kernel/workqueue.c:1331
 __queue_work+0x97f/0xcc0 kernel/workqueue.c:1497
 queue_work_on+0xc1/0x120 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x206/0x3d0 kernel/umh.c:433
 kobject_uevent_env+0x1349/0x1730 lib/kobject_uevent.c:617
 kobject_synth_uevent+0x368/0x8a0 lib/kobject_uevent.c:208
 uevent_store+0x47/0x70 drivers/base/bus.c:585
 kernfs_fop_write_iter+0x3b6/0x510 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x896/0xab0 fs/read_write.c:605
 ksys_write+0x11b/0x220 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888020c03100
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 84 bytes inside of
 192-byte region [ffff888020c03100, ffff888020c031c0)
The buggy address belongs to the page:
page:000000004af063c2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20c03
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea000083b4c0 0000000300000003 ffff888011041500
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888020c03000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888020c03080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888020c03100: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff888020c03180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888020c03200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

