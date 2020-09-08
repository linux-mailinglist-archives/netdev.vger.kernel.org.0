Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167DE260C19
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 09:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgIHHdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 03:33:40 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:35048 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729450AbgIHHdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 03:33:21 -0400
Received: by mail-il1-f208.google.com with SMTP id p16so11416583ilp.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 00:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DrM2WCpXJni+pWF+DYDXi6ZPwROH9NKgPGVrwdvcC8Y=;
        b=i7UTSdWYfSZNm7hQEBXdypzTbvyg+/Nyrik84EcXcMRNKjaaz13EcUDzJ30i1BrQW2
         ODQjYaqj2q2k/UJ14aLSA1GkaCPKlpWDl1bYeGiuAi+DWOHB2yjv/x2XRVNvSUjLHgdx
         b87S7Noz5KIhTt2oG8BSBQIpKp5eIWGRW+CEJpT6Rw7NmFKPuFpFHdh83SbXMso70/g2
         gQb1Flm1AhqtQ20Ao9TDVBnKngT3vWvAy+otZ0v7i1W8VDWyw7hmDEVLBdGii4I+PxI7
         ZOFA6EqK5dZsvp8vfCwSw5YeoB1K2VTIeDz1PtteycvjNFfOtdklaF3NXOa+n0ZbYcwO
         YMHQ==
X-Gm-Message-State: AOAM532+kqhBpJU7ciGQoz/1iH7Ok9j817T9LNfvCeN85WwacMTiz5Fs
        c8oHxZ7H0MOeu1jVxg+KBz+KF6wdK1F3IT0qQUiHVRgCqLS2
X-Google-Smtp-Source: ABdhPJxwxola6tjl5Xs6+98Cwd4t1PyoPXL1Rdc31C+ffEV6FNz4YYMQcG8FHq4dtiLGPk6Dfu1FjSLLkOH+GfEAiInawEhOqtpv
MIME-Version: 1.0
X-Received: by 2002:a6b:e718:: with SMTP id b24mr20719449ioh.9.1599550399960;
 Tue, 08 Sep 2020 00:33:19 -0700 (PDT)
Date:   Tue, 08 Sep 2020 00:33:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000063dca305aec85988@google.com>
Subject: BUG: spinlock bad magic in lock_sock_nested
From:   syzbot <syzbot+eb47d1a545390e9fd5bf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0f091e43 netlabel: remove unused param from audit_log_form..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1171cbb6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61025c6fd3261bb1
dashboard link: https://syzkaller.appspot.com/bug?extid=eb47d1a545390e9fd5bf
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eb47d1a545390e9fd5bf@syzkaller.appspotmail.com

BUG: spinlock bad magic on CPU#0, kworker/0:2/2721
 lock: 0xffff88809395b088, .magic: ffff8880, .owner: <none>/-1, .owner_cpu: 4
CPU: 0 PID: 2721 Comm: kworker/0:2 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
 do_raw_spin_lock+0x216/0x2b0 kernel/locking/spinlock_debug.c:112
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3034
 l2cap_sock_teardown_cb+0x88/0x400 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
general protection fault, probably for non-canonical address 0xff16fb65bf176ca9: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xf8b7fb2df8bb6548-0xf8b7fb2df8bb654f]
CPU: 0 PID: 2721 Comm: kworker/0:2 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__pv_queued_spin_lock_slowpath+0x538/0xaf0 kernel/locking/qspinlock.c:471
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 50 05 00 00 4a 03 1c e5 00 59 84 89 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 20 05 00 00 4c 8d 6b 14 48 89 6c 24 08 48 8b 2c
RSP: 0018:ffffc9000947f9c8 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: f8b7fb2df8bb654f RCX: ffffffff815b03df
RDX: 1f16ff65bf176ca9 RSI: 0000000000000002 RDI: ffffffff8984fd38
RBP: ffff88809395b088 R08: 0000000000000001 R09: ffff88809395b08b
R10: ffffed101272b611 R11: 0000000000000160 R12: 0000000000001487
R13: 0000000000000001 R14: 0000000000040000 R15: ffff8880ae636b80
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5e095ddb8 CR3: 000000005badb000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:656 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3034
 l2cap_sock_teardown_cb+0x88/0x400 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace cdfef0620d680c8c ]---
RIP: 0010:__pv_queued_spin_lock_slowpath+0x538/0xaf0 kernel/locking/qspinlock.c:471
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 50 05 00 00 4a 03 1c e5 00 59 84 89 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 20 05 00 00 4c 8d 6b 14 48 89 6c 24 08 48 8b 2c
RSP: 0018:ffffc9000947f9c8 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: f8b7fb2df8bb654f RCX: ffffffff815b03df
RDX: 1f16ff65bf176ca9 RSI: 0000000000000002 RDI: ffffffff8984fd38
RBP: ffff88809395b088 R08: 0000000000000001 R09: ffff88809395b08b
R10: ffffed101272b611 R11: 0000000000000160 R12: 0000000000001487
R13: 0000000000000001 R14: 0000000000040000 R15: ffff8880ae636b80
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5e095ddb8 CR3: 000000005badb000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
