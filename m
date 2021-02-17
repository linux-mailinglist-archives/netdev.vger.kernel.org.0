Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC031DE3C
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhBQRc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:32:28 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:46621 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhBQRcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:32:04 -0500
Received: by mail-io1-f69.google.com with SMTP id f6so12358480iox.13
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:31:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rNKpLhkKFfl81T2Dw8MfkIfrcSM+vdv5Ip5r2EUodUc=;
        b=gGclkdsFj/XaY/lh60DDF8kpabPQArOqYEiS+2x4hU+9gWuDIPwGTFWa0oiLBeWPXs
         KpmhMmnMbp8rvBkSIrKxa9DmWNbzDjffxFGSx+seMKx9yeIiAOW7jm+ZAdcU09Kll4EP
         dVmkFnO2PTArgZk6u4EK6Nml+4NeMaTG51ch4S/Ey9iOlHvP3SIqlm7Xwd4jVkyzIM8O
         LRmqW5gZtShx4LzcuyLjrwHGDTgAKF3kEBwRyeeldmYrqdH+Gs8MIy2WglZa7+c+7Qz5
         zupC2y/Zb1Y4uDHfuY2u1OZmqvtKd7flgNhWTbUg6MQUHnW0E5J7p3kEgpXHOBuRO82V
         KFGw==
X-Gm-Message-State: AOAM5330CzUOPfewtLYRlvzZdlFSNPFudeX7DhZ+K+DrvI1awZzVr12I
        +vCq4qbHpNFIX6JnnOo8FWVRyU7Nkdp2pe5AEY+tWh0D62/4
X-Google-Smtp-Source: ABdhPJwxUdbXjHbs2JhYfhCWsAWe5JUtXoMDQCBXfenubzELl0ZcSCm8Pf8sxIMcvIbn6dmuxVDqAEwa55dseTGHsKGxQNuYnapH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ca:: with SMTP id s10mr122663ilu.286.1613583082878;
 Wed, 17 Feb 2021 09:31:22 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:31:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000787b8805bb8b96ce@google.com>
Subject: possible deadlock in mptcp_push_pending
From:   syzbot <syzbot+d1b1723faccb7a43f6d1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c48f8607 Merge branch 'PTP-for-DSA-tag_ocelot_8021q'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16525cb0d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=d1b1723faccb7a43f6d1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d1b1723faccb7a43f6d1@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.11.0-rc7-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.1/15600 is trying to acquire lock:
ffff888057303220 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1598 [inline]
ffff888057303220 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp_push_pending+0x28b/0x650 net/mptcp/protocol.c:1466

but task is already holding lock:
ffff8880285da520 (sk_lock-AF_INET6){+.+.}-{0:0}, at: inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_INET6);
  lock(sk_lock-AF_INET6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz-executor.1/15600:
 #0: ffff8880285da520 (sk_lock-AF_INET6){+.+.}-{0:0}, at: inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638

stack backtrace:
CPU: 1 PID: 15600 Comm: syz-executor.1 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2761 [inline]
 check_deadlock kernel/locking/lockdep.c:2804 [inline]
 validate_chain kernel/locking/lockdep.c:3595 [inline]
 __lock_acquire.cold+0x114/0x39e kernel/locking/lockdep.c:4832
 lock_acquire kernel/locking/lockdep.c:5442 [inline]
 lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5407
 lock_sock_nested+0xc5/0x110 net/core/sock.c:3071
 lock_sock include/net/sock.h:1598 [inline]
 mptcp_push_pending+0x28b/0x650 net/mptcp/protocol.c:1466
 mptcp_sendmsg+0xde4/0x2830 net/mptcp/protocol.c:1685
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:999
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465d99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f45e25188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056c0b0 RCX: 0000000000465d99
RDX: 0000000020000001 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004bcf27 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c0b0
R13: 00007ffec3fddc7f R14: 00007f0f45e25300 R15: 0000000000022000
general protection fault, probably for non-canonical address 0xdffffc0000000007: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
CPU: 0 PID: 15600 Comm: syz-executor.1 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mptcp_sendmsg_frag+0xa3f/0x1220 net/mptcp/protocol.c:1330
Code: 80 3c 02 00 0f 85 04 07 00 00 48 8b 04 24 48 8b 98 20 07 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 38 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e d6 04 00 00 48 8d 7d 10 44 8b
RSP: 0018:ffffc900020577e8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: 0000000000000000 RDI: 0000000000000038
RBP: ffff88802b42e610 R08: 0000000000000001 R09: ffff88802b42e610
R10: ffffed1005685cc4 R11: 0000000000000000 R12: ffff8880285da400
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000204
FS:  00007f0f45e25700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d4b6e570c0 CR3: 000000005c5ae000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mptcp_push_pending+0x2cc/0x650 net/mptcp/protocol.c:1477
 mptcp_sendmsg+0xde4/0x2830 net/mptcp/protocol.c:1685
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:999
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465d99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0f45e25188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056c0b0 RCX: 0000000000465d99
RDX: 0000000020000001 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004bcf27 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c0b0
R13: 00007ffec3fddc7f R14: 00007f0f45e25300 R15: 0000000000022000
Modules linked in:
---[ end trace 88e1139d1c953589 ]---
RIP: 0010:mptcp_sendmsg_frag+0xa3f/0x1220 net/mptcp/protocol.c:1330
Code: 80 3c 02 00 0f 85 04 07 00 00 48 8b 04 24 48 8b 98 20 07 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 38 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e d6 04 00 00 48 8d 7d 10 44 8b
RSP: 0018:ffffc900020577e8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000007 RSI: 0000000000000000 RDI: 0000000000000038
RBP: ffff88802b42e610 R08: 0000000000000001 R09: ffff88802b42e610
R10: ffffed1005685cc4 R11: 0000000000000000 R12: ffff8880285da400
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000204
FS:  00007f0f45e25700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f272a496000 CR3: 000000005c5ae000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
