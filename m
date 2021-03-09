Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E041A3329E9
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCIPNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:13:32 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:41137 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhCIPNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:13:23 -0500
Received: by mail-io1-f70.google.com with SMTP id n1so10468911iob.8
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 07:13:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5Y7QHkLp2ycDcPGAl8DICaPidHDcIKD1NE/lJ7OHIpQ=;
        b=BYZJnZgDMfSV4g7uhxVnN2nCUThsUci0WPEL981+bUlsG2A+SyCKnbWgXBwIMJe7Ck
         8I7OnzBatUP7Obh6g2WeYdAahBZFNiX3DlxEmL/X423WWH0rMg7Qcr4ANh/wVGGcGvwa
         bi20NC0FC4r5XEt6EXcbM8rI+yf6ZqPN6ZNHPxeFH9QluyxGVnDgBGpr27sEknI3Ed9S
         G2H8JtwqTB6a03q2p77D9a9RWiMkVLhX8iYr4pH6kk5gZGr7VTNkgg7uIOywdqt6Uw1A
         c1ZD0oQ98iF/kBoIroBJj3VmoDaRzc1N41D1Bfhvw6mKaIKTcNHU+yTL23ZDo74c6f4v
         WgWg==
X-Gm-Message-State: AOAM530CriKUS5x4U18+KHdclQDC5vX28yFGAX3fLSWK02tAE5gpIUk4
        w+j8S5XKjuN23y03KUlGANHN+ntxz0nOoltQZiV0uULlKNGr
X-Google-Smtp-Source: ABdhPJxO66uLPRe/BTMfaP+iPU/Uw65G40SLS+6Fx+EAK1EXmecQQvpE9586kMNu0I99HeYYA04cYZpdJ8TiE6EE/kOlDDgVk/Bj
MIME-Version: 1.0
X-Received: by 2002:a02:6989:: with SMTP id e131mr29333517jac.105.1615302802558;
 Tue, 09 Mar 2021 07:13:22 -0800 (PST)
Date:   Tue, 09 Mar 2021 07:13:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0510605bd1bfd39@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in htb_select_queue
From:   syzbot <syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        maximmi@mellanox.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tariqt@nvidia.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    38b5133a octeontx2-pf: Fix otx2_get_fecparam()
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=166288a8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=b53a709f04722ca12a3c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119454ccd00000

The issue was bisected to:

commit d03b195b5aa015f6c11988b86a3625f8d5dbac52
Author: Maxim Mikityanskiy <maximmi@mellanox.com>
Date:   Tue Jan 19 12:08:13 2021 +0000

    sch_htb: Hierarchical QoS hardware offload

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ab12ecd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=106b12ecd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ab12ecd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com
Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 183fe067 P4D 183fe067 PUD 21aef067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10125 Comm: syz-executor.0 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
FS:  00007f73f9698700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 htb_offload net/sched/sch_htb.c:1011 [inline]
 htb_select_queue+0x17f/0x2c0 net/sched/sch_htb.c:1349
 tc_modify_qdisc+0x44a/0x1a50 net/sched/sch_api.c:1657
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x466019
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f73f9698188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466019
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 00000000004bd067 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007fffefccc11f R14: 00007f73f9698300 R15: 0000000000022000
Modules linked in:
CR2: 0000000000000000
---[ end trace e1544e8206616773 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
FS:  00007f73f9698700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
