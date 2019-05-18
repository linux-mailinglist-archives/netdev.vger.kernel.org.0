Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B142F22208
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 09:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbfERH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 03:28:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46493 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfERH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 03:28:06 -0400
Received: by mail-io1-f69.google.com with SMTP id h189so7221237ioa.13
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 00:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=z2hYiAaTK0CEsKJSi/CwKbqUeagJfEqEMmgyIue0Y9I=;
        b=HBs/RxGhYGdjFG/V0jGcuHBHcBsiLwlMRFT0H+mZH+07wEnxJPmYAXvo3WoqiaX9eB
         /Nj/+bA0+KaucnTQKCxWHiiAbFbSOX5viOFICe1ZMWF6m9X7tTPR4ccxUu1pLnGuyk6S
         ovBMnREXlh/f3lJXy8oKNDt7UJoYUmnbpQBpg/R6IsOEsdp0LVN05Rz4Ik+lB14IR8Y8
         CgCn+mgNViskgRVuDZlVYp28rnB1Wq+yzB6gOKmLKx8a9sUp3VLABxJ8h2Hz1w8zwInf
         9r+fMFKdRkkEYgdfkcBqbwwftI+JbPuFUq8u7Sx0T7x84ESEzTWz8rgdl1/oJIiGoRPp
         NYNQ==
X-Gm-Message-State: APjAAAVH1TcLvWTQZJD/D9YVFDAA7ckMdYA72KZqNcQ2/NTmGYxz9kwO
        OFFcOnW9y7W4Ds8JGL2Cpam5cGXxcAXJqHnHj0ts+13VUqRq
X-Google-Smtp-Source: APXvYqwOxYQL6gxdpSBErDed/nQ5jjjEVgmRKjJXWsX6IaYiKW0QfgV1RR8Qk1nLwgLAqfJ24Qbgo8qZtwD3nZiMJmxhGUkqKE1s
MIME-Version: 1.0
X-Received: by 2002:a24:e046:: with SMTP id c67mr5538546ith.16.1558164485924;
 Sat, 18 May 2019 00:28:05 -0700 (PDT)
Date:   Sat, 18 May 2019 00:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af6c020589247060@google.com>
Subject: BUG: spinlock bad magic in rhashtable_walk_enter
From:   syzbot <syzbot+01dd5c4b3c34a5cf9308@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11e25b02a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=01dd5c4b3c34a5cf9308
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b6373ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1251e73ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+01dd5c4b3c34a5cf9308@syzkaller.appspotmail.com

BUG: spinlock bad magic on CPU#0, syz-executor715/8517
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8517 Comm: syz-executor715 Not tainted 5.1.0+ #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:task_pid_nr include/linux/sched.h:1241 [inline]
RIP: 0010:spin_dump.cold+0xa2/0xe6 kernel/locking/spinlock_debug.c:65
Code: ae 4c 02 00 e8 75 5d bf 05 58 5b 41 5c 41 5d 41 5e 5d c3 48 8d bb d0  
04 00 00 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 04 3c 03 7e 24 44 8b ab d0 04 00 00 48 81 c3
RSP: 0018:ffff888086267538 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000078e05280 RCX: 0000000000000000
RDX: 000000000f1c0aea RSI: ffffffff815afbe6 RDI: 0000000078e05750
RBP: ffff888086267560 R08: 0000000000000036 R09: ffffed1015d06011
R10: ffffed1015d06010 R11: ffff8880ae830087 R12: ffff888216427ba8
R13: ffff88808e534300 R14: ffff888216426980 R15: ffff8880862675d8
FS:  0000000000b40880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000204 CR3: 0000000098123000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  spin_bug kernel/locking/spinlock_debug.c:75 [inline]
  debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
  do_raw_spin_lock+0x231/0x2e0 kernel/locking/spinlock_debug.c:112
  __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
  _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rhashtable_walk_enter+0xf9/0x390 lib/rhashtable.c:669
  __tipc_dump_start+0x1fa/0x3c0 net/tipc/socket.c:3414
  tipc_dump_start+0x70/0x90 net/tipc/socket.c:3396
  __netlink_dump_start+0x4fb/0x7e0 net/netlink/af_netlink.c:2351
  netlink_dump_start include/linux/netlink.h:226 [inline]
  tipc_sock_diag_handler_dump+0x1d9/0x270 net/tipc/diag.c:91
  __sock_diag_cmd net/core/sock_diag.c:232 [inline]
  sock_diag_rcv_msg+0x322/0x410 net/core/sock_diag.c:263
  netlink_rcv_skb+0x17a/0x460 net/netlink/af_netlink.c:2486
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:274
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x536/0x720 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:660 [inline]
  sock_sendmsg+0x12e/0x170 net/socket.c:671
  ___sys_sendmsg+0x81d/0x960 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0x103/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401f9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffce875faa8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 3bee47f081c674b7 ]---
RIP: 0010:task_pid_nr include/linux/sched.h:1241 [inline]
RIP: 0010:spin_dump.cold+0xa2/0xe6 kernel/locking/spinlock_debug.c:65
Code: ae 4c 02 00 e8 75 5d bf 05 58 5b 41 5c 41 5d 41 5e 5d c3 48 8d bb d0  
04 00 00 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 04 3c 03 7e 24 44 8b ab d0 04 00 00 48 81 c3
RSP: 0018:ffff888086267538 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000078e05280 RCX: 0000000000000000
RDX: 000000000f1c0aea RSI: ffffffff815afbe6 RDI: 0000000078e05750
RBP: ffff888086267560 R08: 0000000000000036 R09: ffffed1015d06011
R10: ffffed1015d06010 R11: ffff8880ae830087 R12: ffff888216427ba8
R13: ffff88808e534300 R14: ffff888216426980 R15: ffff8880862675d8
FS:  0000000000b40880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000204 CR3: 0000000098123000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
