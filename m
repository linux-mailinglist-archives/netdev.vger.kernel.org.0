Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0D73E3D2C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 01:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhHHXik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 19:38:40 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:49851 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhHHXij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 19:38:39 -0400
Received: by mail-io1-f69.google.com with SMTP id k6-20020a6b3c060000b0290568c2302268so11617679iob.16
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 16:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6Sls2ZePO2B7rK1frbRgJ99vGjzszT5eqt0ie+TyZh4=;
        b=Y4fjUtQR6TxKnRnqRmwn2GDhAxbgdorAP5xi44sFKSHr2FroC7b4tOxsiaKUoMTUwh
         sXyRu8p6GAUJBAsC2IRBVEZYHDZKjiRXEuCKFH8oamE5tpX5++Gfcz8kXJS2983i2Sa2
         zr2Ksw3Bj3ov21vHO3nSLxeOidhE90dLARMpstXNB0GTdDJ8v9YA/WFhxx0zKvDbO+a5
         JmcYWa8Xi2m7+UgWgsEAjbadycZftdKChdN8+AExJt3auxEv5NwSAst35Gd7yPYmCgMY
         v/lPbWjQR541ccUDWHpoDp5josxYuszlyTySDYhz4Yx/RZrJRipq+Ldce8NeCt5JxoWX
         YG5Q==
X-Gm-Message-State: AOAM5309+ShoeAMjiLybeNUxSbIIjv0Z/JwXZYMEmFVDS989SoO0Hm0v
        BrP1wU0QXELRPf8gT7IbHBpz71BGV+RZr/LmG76p5qHveeoi
X-Google-Smtp-Source: ABdhPJzDq0KkjK6Hn7ioKuW9SGjXRihEUKOaipf9eMWxxIETGIhosE/xhsxde+AokRZJxSiizlG2oXwC7MMWm60zZs2yAHMtKZYd
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa3:: with SMTP id l3mr453617ilv.299.1628465898703;
 Sun, 08 Aug 2021 16:38:18 -0700 (PDT)
Date:   Sun, 08 Aug 2021 16:38:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006bd0b305c914c3dc@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in _copy_to_iter
From:   syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, rao.shoaib@oracle.com, shuah@kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12e3a69e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
dashboard link: https://syzkaller.appspot.com/bug?extid=8760ca6c1ee783ac4abd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c5b104300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10062aaa300000

The issue was bisected to:

commit 314001f0bf927015e459c9d387d62a231fe93af3
Author: Rao Shoaib <rao.shoaib@oracle.com>
Date:   Sun Aug 1 07:57:07 2021 +0000

    af_unix: Add OOB support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10765f8e300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12765f8e300000
console output: https://syzkaller.appspot.com/x/log.txt?x=14765f8e300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
Fixes: 314001f0bf92 ("af_unix: Add OOB support")

BUG: sleeping function called from invalid context at lib/iov_iter.c:619
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: syz-executor700
2 locks held by syz-executor700/8443:
 #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
 #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
 __might_fault+0x6e/0x180 mm/memory.c:5258
 _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
 copy_to_iter include/linux/uio.h:139 [inline]
 simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
 __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
 skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
 unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
 unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
 unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
 unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_recvmsg net/socket.c:958 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
 ___sys_recvmsg+0x127/0x200 net/socket.c:2664
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
 __sys_recvmmsg net/socket.c:2837 [inline]
 __do_sys_recvmmsg net/socket.c:2860 [inline]
 __se_sys_recvmmsg net/socket.c:2853 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ef39
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

=============================
[ BUG: Invalid wait context ]
5.14.0-rc3-syzkaller #0 Tainted: G        W        
-----------------------------
syz-executor700/8443 is trying to lock:
ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5260
other info that might help us debug this:
context-{4:4}
2 locks held by syz-executor700/8443:
 #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
 #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
 #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
stack backtrace:
CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [inline]
 check_wait_context kernel/locking/lockdep.c:4727 [inline]
 __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __might_fault mm/memory.c:5261 [inline]
 __might_fault+0x106/0x180 mm/memory.c:5246
 _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
 copy_to_iter include/linux/uio.h:139 [inline]
 simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
 __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
 skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
 unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
 unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
 unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
 unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
 sock_recvmsg_nosec net/socket.c:944 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 sock_recvmsg net/socket.c:958 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
 ___sys_recvmsg+0x127/0x200 net/socket.c:2664
 do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
 __sys_recvmmsg net/socket.c:2837 [inline]
 __do_sys_recvmmsg net/socket.c:2860 [inline]
 __se_sys_recvmmsg net/socket.c:2853 [inline]
 __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ef39
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000007 R11: 0000000000000246 R12: 0000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
