Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7430035438B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 17:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbhDEPp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 11:45:29 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:35715 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbhDEPp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 11:45:27 -0400
Received: by mail-il1-f199.google.com with SMTP id y11so9741147ilq.2
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 08:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+x9/MKuc2hmxIJVR5bNwtBPQEtsjTs7ETZd3G6qI0TE=;
        b=ZOtZFKKorFCzewWXkaYTWtaBSU1laTNCnMtYZra02yneWoRfaGsnsQfJMKY72veldM
         TtJ6EN457JegUVHbPoXnyYQhPRt8Hg4EDljminwszGpy2B4skJThfRTG7Q74Iajpfn61
         PodkwoN1OwVJkkyuCUsC8T8FcUSp1FnS9iWhKs5Jc4Ov9y2xISBB97gZ8PzhsQeEzdIX
         qc5/iPm+sVZQ/ZijBhC7eeK1vC4mFteEB7NhpzELkVOACjuM122SqlI0j4jC5W0YuhwD
         CNilrzRS9vjwE98LiGFQdCiMk7yGMuCdc+4CsTbsxvTZTTAX3y+KPvqbIf6V0FTEcBD4
         YrOQ==
X-Gm-Message-State: AOAM532eIrXV7TCbiG16cD+na5GLSuGvM0DB9FSjW2I0Ac7xgTG6BP8i
        EKdtcsHDtqaouuF2uZcGT2kaSFRteRfrzZ+Dl2aNS0Kl0SET
X-Google-Smtp-Source: ABdhPJzD7s2Zc45ImbfUcMY8nAFcTIlyrXFu4hSwoKW418AJ3Sx3xHQrWBnP0sohlKOQwvM8tvMlKyGj5IPFkQ/ENRBuGJHFFnyk
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1cad:: with SMTP id x13mr21246553ill.144.1617637520858;
 Mon, 05 Apr 2021 08:45:20 -0700 (PDT)
Date:   Mon, 05 Apr 2021 08:45:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce66e005bf3b9531@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in lock_sock_nested
From:   syzbot <syzbot+80a4f8091f8d5ba51de9@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d19cc4bf Merge tag 'trace-v5.12-rc5' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14898326d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d1a3d65a48dbd1bc
dashboard link: https://syzkaller.appspot.com/bug?extid=80a4f8091f8d5ba51de9

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80a4f8091f8d5ba51de9@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.12.0-rc5-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
no locks held by syz-executor.3/8407.

stack backtrace:
CPU: 0 PID: 8407 Comm: syz-executor.3 Not tainted 5.12.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep+0x229/0x2c0 kernel/sched/core.c:8294
 lock_sock_nested+0x25/0x120 net/core/sock.c:3062
 lock_sock include/net/sock.h:1600 [inline]
 do_ip_getsockopt+0x227/0x18e0 net/ipv4/ip_sockglue.c:1536
 ip_getsockopt+0x84/0x1c0 net/ipv4/ip_sockglue.c:1761
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4239
 __sys_getsockopt+0x21f/0x5f0 net/socket.c:2161
 __do_sys_getsockopt net/socket.c:2176 [inline]
 __se_sys_getsockopt net/socket.c:2173 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2173
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x467a6a
Code: 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc76a6a848 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffc76a6a85c RCX: 0000000000467a6a
RDX: 0000000000000060 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffc76a6a85c R09: 00007ffc76a6a8c0
R10: 00007ffc76a6a860 R11: 0000000000000246 R12: 00007ffc76a6a860
R13: 000000000005ecdc R14: 0000000000000000 R15: 00007ffc76a6afd0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
