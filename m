Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FBE409916
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbhIMQal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:30:41 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36776 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbhIMQaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:30:39 -0400
Received: by mail-io1-f70.google.com with SMTP id w7-20020a5e9707000000b005c3adb2571fso14321471ioj.3
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 09:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KNdTyHh1t8BTf2GAYl/7g8JX/wIwOhnr4+QZ0NbF+rs=;
        b=g8eK30olOjcnqL8w2innaHQR1XIh4JtN5pDhbxaUJSWRleH6yKirhlpdpNz68uHRyG
         G1Eo5P/z1qiUqxOR6l9+LgWPhXjm08ruYxOA1BRPnvi+2Y4NiSSu7EVjPFI8BSIeGpEe
         Z/s5AYJn2J1BkYZFG5KKwEuG2ruJhC3nIHYy9kiKR7JzL66oamB3A14J3qr8fvpQ+UeD
         /EkhAWCDcx/QWzK20R/AkgxRipKBIIMNF1ey1L6eDGS2ppTT6NONSggswz1E5C/WiA86
         q/fxmBoQYUSfeVHWXQEqgp6NLVKVE/8CblKBYW2p0fhyG6huipdbXr7IwQ3//f2fQcHl
         27JA==
X-Gm-Message-State: AOAM532PuYr/3ragW8bWEkzEa4qkIY7tQa/GDj5RFCt+HwervBKeoNsy
        HUgnw+QvGyn6mgD1zK6fJVCWbBetUXu5D7VKjCJM+s0ROgDr
X-Google-Smtp-Source: ABdhPJxqhx6vjfx/fLIT2TJSpavcAHIAaPQAae6swcP106bVa8bxlhROSxLC8lCsQOZqkUA69I4Ou5h7Yh1isGjVAxOJW4Elw1T9
MIME-Version: 1.0
X-Received: by 2002:a92:da4a:: with SMTP id p10mr7660447ilq.13.1631550563219;
 Mon, 13 Sep 2021 09:29:23 -0700 (PDT)
Date:   Mon, 13 Sep 2021 09:29:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0fea005cbe2f70d@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_ipportip_create
From:   syzbot <syzbot+30aea515bdd9616dd4e9@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bf9f243f23e6 Merge tag '5.15-rc-ksmbd-part2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123479c7300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37df9ef5660a8387
dashboard link: https://syzkaller.appspot.com/bug?extid=30aea515bdd9616dd4e9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167a5873300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1080c163300000

The issue was bisected to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14e9083b300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16e9083b300000
console output: https://syzkaller.appspot.com/x/log.txt?x=12e9083b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+30aea515bdd9616dd4e9@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6538 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 6538 Comm: syz-executor249 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 8d 18 0d 00 49 89 c5 e9 69 ff ff ff e8 10 9d d0 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 ff 9c d0 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 e6
RSP: 0018:ffffc900025af268 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc900025af380 RCX: 0000000000000000
RDX: ffff888025433900 RSI: ffffffff81a57041 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: ffff8880b9d32a0b
R10: ffffffff81a56ffe R11: 000000000000001f R12: 0000000400000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88807bbce000
FS:  0000000001a7d300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7269e1d6c0 CR3: 000000006f6c6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_ipportip_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f029
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd69914258 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f029
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000403010 R08: 0000000000000005 R09: 0000000000400488
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004030a0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
