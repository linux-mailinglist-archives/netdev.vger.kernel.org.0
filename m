Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033E91603BF
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgBPK5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:57:15 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:50797 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgBPK5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:57:14 -0500
Received: by mail-il1-f198.google.com with SMTP id z12so11806050ilh.17
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 02:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=khkdmIgyKVi3BQRKte6m+fUbFSqCcRxt9OmDYtfZNBY=;
        b=DB37ZLDUBq+3Xb4RVq6AnvwZQox/9VyhnQVecEmwfahIymloP8HoBoqLZaUoSMiGES
         t71UFsVew9c/xEwldNjWQrZj42u20gVaCc2zviuBs3B4RNXU7e0jYlFGZVHMnB0k+rQt
         PovqzEAC1tNIIXV4Oa5EomQmGiCSRFXkyJLtLBVhUiE/bys721jww+NIU00K4UE05mZY
         K+2o4e8lfDHHzOWUxYls5xL4V8We8UZEoZk01WLvrpsIJbbCkaf+Ihn7lY+1ozZlxnGs
         0YrL3qMCnNNqs34bh1fhhNQPjUqaw+auT9IbfKE+kQsmKi7eo1lQUJwBmNyZMsLBNMQ0
         3ecw==
X-Gm-Message-State: APjAAAUZoK6L2GgkIt6Vn4a5kKoJYnoFsnvgqvDu634Glb8W8zKfYxn3
        1/blXFyydSiQm3zga2j+OR3hZxbTFWxev6qOKMrQ+oDx/iwo
X-Google-Smtp-Source: APXvYqz/uhApDy8BHsTOMV0Ax4nS1NjL5q1etw2OxJWRdFvNTWSg41CD5+DRw3LUFazwsjxHOVI2b8Yuzph7xFvJnFvRpaMDOXt+
MIME-Version: 1.0
X-Received: by 2002:a92:5c8a:: with SMTP id d10mr10921125ilg.137.1581850632480;
 Sun, 16 Feb 2020 02:57:12 -0800 (PST)
Date:   Sun, 16 Feb 2020 02:57:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000973ee059eaf4de6@google.com>
Subject: possible deadlock in bpf_lru_push_free
From:   syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2019fc96 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13aa0229e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=122b5421d14e68f29cd1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.6.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/16820 is trying to acquire lock:
ffffe8ffffccc040 (&loc_l->lock){....}, at: bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
ffffe8ffffccc040 (&loc_l->lock){....}, at: bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555

but task is already holding lock:
ffff88808ceda560 (&htab->buckets[i].lock#2){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&htab->buckets[i].lock#2){....}:
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

-> #1 (&l->lock){....}:
       __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
       _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
       bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 [inline]
       bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
       bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499
       prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
       htab_lru_map_update_elem+0x65b/0xba0 kernel/bpf/hashtab.c:950
       bpf_map_update_value.isra.0+0x61b/0x8e0 kernel/bpf/syscall.c:206
       map_update_elem kernel/bpf/syscall.c:1089 [inline]
       __do_sys_bpf+0x3163/0x41e0 kernel/bpf/syscall.c:3384
       __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
       __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
       do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&loc_l->lock){....}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
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

other info that might help us debug this:

Chain exists of:
  &loc_l->lock --> &l->lock --> &htab->buckets[i].lock#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&htab->buckets[i].lock#2);
                               lock(&l->lock);
                               lock(&htab->buckets[i].lock#2);
  lock(&loc_l->lock);

 *** DEADLOCK ***

2 locks held by syz-executor.3/16820:
 #0: ffffffff89bac240 (rcu_read_lock){....}, at: __htab_map_lookup_and_delete_batch+0x54b/0x1540 kernel/bpf/hashtab.c:1308
 #1: ffff88808ceda560 (&htab->buckets[i].lock#2){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322

stack backtrace:
CPU: 0 PID: 16820 Comm: syz-executor.3 Not tainted 5.6.0-rc1-syzkaller #0
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
RIP: 0033:0x45c6c9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007efeedbcdc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007efeedbce6d4 RCX: 000000000045c6c9
RDX: 0000000000000038 RSI: 00000000200001c0 RDI: 0000000000000019
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000060 R14: 00000000004c2e9b R15: 000000000076bf2c


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
