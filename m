Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AC41E0511
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 05:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbgEYDOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 23:14:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33290 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388510AbgEYDOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 23:14:18 -0400
Received: by mail-io1-f72.google.com with SMTP id w4so11782390iol.0
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 20:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YSWc34iX3GK8ObMO8XHR5U5QhpSHn1IWPTDBonz04dU=;
        b=ttOEOmi4U+DDcjphJkawceanw7W1bWQ3pejuZM/zwEtrHJIM9VsqaIXP+zjJvnx4EM
         TOYr78T+tnJHwmo68DmF/v+HFvyBYiFnB/zLIu4R1kcnfGM4Qc1YuL2J5/d0rbjuUV3i
         EXUVz22DcOos4km8/Svgf63yNVJd3hk+/N4xtCRRcGPWJKPkk/tafcgx4US2CEiP2+xe
         zyxzcWZ2FoAptWB4MPWCmRgVX/RIaxM8y/VXbntvOxHgCeq98W27ck0pGsEn+OMC25p6
         55BPemaFt3Y33IpxoToCvsE3x0ekzNczrLrnwehHxkJANan7nabAcw4w+eph3+bdmwHH
         ZWGw==
X-Gm-Message-State: AOAM530g6K7IsZcFD8E9Thj1CAhLaND9V3fGchmJG8mhHmO5nqnnJXfM
        C5b7Q2jLV/c7cTeTDnu32A1TLXcrqzX+McUdRb+sjX06BJmj
X-Google-Smtp-Source: ABdhPJxsbx6n8x/nMHeqIEt5cap9oSTo8nQK+yklLFkw76SjM625O48upChlWPPuWEq7icEG+0rG9XmUmKJ8XgF+hcCtLsVY/cXz
MIME-Version: 1.0
X-Received: by 2002:a5d:914d:: with SMTP id y13mr1544846ioq.48.1590376455857;
 Sun, 24 May 2020 20:14:15 -0700 (PDT)
Date:   Sun, 24 May 2020 20:14:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b5f39305a6705fd3@google.com>
Subject: general protection fault in sock_recvmsg
From:   syzbot <syzbot+d7cface3f90b13edf5b0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    caffb99b Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a74441100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c33c7f7c5471fd39
dashboard link: https://syzkaller.appspot.com/bug?extid=d7cface3f90b13edf5b0
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141034ba100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119cd016100000

The bug was bisected to:

commit 263e1201a2c324b60b15ecda5de9ebf1e7293e31
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Thu Apr 30 13:01:51 2020 +0000

    mptcp: consolidate synack processing.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119d8626100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=139d8626100000
console output: https://syzkaller.appspot.com/x/log.txt?x=159d8626100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d7cface3f90b13edf5b0@syzkaller.appspotmail.com
Fixes: 263e1201a2c3 ("mptcp: consolidate synack processing.")

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 7226 Comm: syz-executor523 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sock_recvmsg_nosec net/socket.c:886 [inline]
RIP: 0010:sock_recvmsg+0x92/0x110 net/socket.c:904
Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 6c 24 04 e8 53 18 1d fb 4d 8d 6f 20 4c 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ef e8 20 12 5b fb bd a0 00 00 00 49 03 6d
RSP: 0018:ffffc90001077b98 EFLAGS: 00010202
RAX: 0000000000000004 RBX: ffffc90001077dc0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff86565e59 R09: ffffed10115afeaa
R10: ffffed10115afeaa R11: 0000000000000000 R12: 1ffff9200020efbc
R13: 0000000000000020 R14: ffffc90001077de0 R15: 0000000000000000
FS:  00007fc6a3abe700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d0050 CR3: 00000000969f0000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mptcp_recvmsg+0x18d5/0x19b0 net/mptcp/protocol.c:891
 inet_recvmsg+0xf6/0x1d0 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 __sys_recvfrom+0x2f3/0x470 net/socket.c:2057
 __do_sys_recvfrom net/socket.c:2075 [inline]
 __se_sys_recvfrom net/socket.c:2071 [inline]
 __x64_sys_recvfrom+0xda/0xf0 net/socket.c:2071
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x448ef9
Code: e8 cc 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc6a3abdda8 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00000000006dec28 RCX: 0000000000448ef9
RDX: 0000000000001000 RSI: 00000000200004c0 RDI: 0000000000000003
RBP: 00000000006dec20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000040000000 R11: 0000000000000246 R12: 00000000006dec2c
R13: 00007ffe4730174f R14: 00007fc6a3abe9c0 R15: 00000000006dec2c
Modules linked in:
---[ end trace 097bdf143c3a60db ]---
RIP: 0010:sock_recvmsg_nosec net/socket.c:886 [inline]
RIP: 0010:sock_recvmsg+0x92/0x110 net/socket.c:904
Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 6c 24 04 e8 53 18 1d fb 4d 8d 6f 20 4c 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 ef e8 20 12 5b fb bd a0 00 00 00 49 03 6d
RSP: 0018:ffffc90001077b98 EFLAGS: 00010202
RAX: 0000000000000004 RBX: ffffc90001077dc0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff86565e59 R09: ffffed10115afeaa
R10: ffffed10115afeaa R11: 0000000000000000 R12: 1ffff9200020efbc
R13: 0000000000000020 R14: ffffc90001077de0 R15: 0000000000000000
FS:  00007fc6a3abe700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d0050 CR3: 00000000969f0000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
