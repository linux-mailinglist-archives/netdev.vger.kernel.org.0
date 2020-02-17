Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E500E1609A3
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBQE1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:27:13 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:40864 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgBQE1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:27:13 -0500
Received: by mail-il1-f200.google.com with SMTP id m18so13405245ill.7
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 20:27:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+bBk/Fq1vUTdJXRyprYVb3odKn2c5aAcymM78HKQdHw=;
        b=EEF99BU5g++5fMQnMUSRnPb6C/rkuE9gdXF+n3RIwGouyi6qsJsL+P0yFvC7FkfjFK
         /DNh/81gQ++Q5fMTJymqUXj64KiKPUd1fnvD+BButxIXLbESYQqlX9wHW9k5zLnaKGa1
         ZnkBSS0IUoaNmiSqc5Un1HwE6mUgFucJ810YsN0yjDa8pvuhZxb6iX7cYlH0scKi7dCL
         GXSYvHXzdzg3uVgOsM6SNNO6F3N5sNMipT2kbRrHPoG0j3RBckA2Hd+L4b9ji7d4eFNl
         aNf75eMEX3KT/VP5QReKNia3M6FZVWsrmHF34f0Y75LGfLCedtFOpX7tW6jWE1ivOLID
         7/CA==
X-Gm-Message-State: APjAAAXCcBO7Y/zCG/OuwqL3x1cht1aJNHjU9/2mqIsmB0L/6U+Kf8tZ
        /cFelNYaFSlHRetjmJsUy9tbexYQWkSgRaKFAW5Gm/DZ43Ei
X-Google-Smtp-Source: APXvYqxcIb/CRzVCGjsDdSN+fXJyEVys3Ud2R1DQgOHZ92+rAQLP/9cn8drlfpuMoPocx6nXHy6gdoLTuJGms/aOFYx3v/5F6RbP
MIME-Version: 1.0
X-Received: by 2002:a5d:9805:: with SMTP id a5mr10514425iol.80.1581913630947;
 Sun, 16 Feb 2020 20:27:10 -0800 (PST)
Date:   Sun, 16 Feb 2020 20:27:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009c250059ebdf837@google.com>
Subject: possible deadlock in htab_lru_map_delete_node
From:   syzbot <syzbot+a38ff3d9356388f2fb83@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        brianvv@google.com, daniel@iogearbox.net, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2019fc96 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1085b209e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=a38ff3d9356388f2fb83
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d716e6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1485b209e00000

The bug was bisected to:

commit 057996380a42bb64ccc04383cfa9c0ace4ea11f0
Author: Yonghong Song <yhs@fb.com>
Date:   Wed Jan 15 18:43:04 2020 +0000

    bpf: Add batch ops to all htab bpf map

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14d9b6e6e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16d9b6e6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12d9b6e6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a38ff3d9356388f2fb83@syzkaller.appspotmail.com
Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")

======================================================
WARNING: possible circular locking dependency detected
5.6.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor432/10129 is trying to acquire lock:
ffff8880988693e0 (&htab->buckets[i].lock){....}, at: htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593

but task is already holding lock:
ffff888098869a18 (&l->lock){....}, at: bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 [inline]
ffff888098869a18 (&l->lock){....}, at: bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
ffff888098869a18 (&l->lock){....}, at: bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&l->lock){....}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
       bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 [inline]
       bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
       bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499
       prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
       __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
       bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
       bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
       generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #1 (&loc_l->lock){....}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
       bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
       __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
       htab_lru_map_lookup_and_delete_batch+0x34/0x40 kernel/bpf/hashtab.c:1491
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&htab->buckets[i].lock){....}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
       __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220 [inline]
       __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:266
       bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:340 [inline]
       bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
       bpf_lru_pop_free+0x87c/0x1670 kernel/bpf/bpf_lru_list.c:499
       prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
       __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
       bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
       bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
       generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
       bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
       __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
  &htab->buckets[i].lock --> &loc_l->lock --> &l->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&l->lock);
                               lock(&loc_l->lock);
                               lock(&l->lock);
  lock(&htab->buckets[i].lock);

 *** DEADLOCK ***

3 locks held by syz-executor432/10129:
 #0: ffffffff89bac240 (rcu_read_lock){....}, at: bpf_percpu_hash_update+0x0/0x210 kernel/bpf/hashtab.c:1565
 #1: ffffe8ffffc49e40 (&loc_l->lock){....}, at: bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:443 [inline]
 #1: ffffe8ffffc49e40 (&loc_l->lock){....}, at: bpf_lru_pop_free+0x32b/0x1670 kernel/bpf/bpf_lru_list.c:499
 #2: ffff888098869a18 (&l->lock){....}, at: bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 [inline]
 #2: ffff888098869a18 (&l->lock){....}, at: bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
 #2: ffff888098869a18 (&l->lock){....}, at: bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499

stack backtrace:
CPU: 0 PID: 10129 Comm: syz-executor432 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
 htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
 __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220 [inline]
 __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:266
 bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:340 [inline]
 bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
 bpf_lru_pop_free+0x87c/0x1670 kernel/bpf/bpf_lru_list.c:499
 prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
 __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
 bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
 bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
 generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
 bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
 __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
 __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
 __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446b99
Code: e8 bc b4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 ab 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f14c0df8db8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446b99
RDX: 0000000000000038 RSI: 0000000020000040 RDI: 000000000000001a
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 00007ffc51c1364f R14: 00007f14c0df99c0 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
