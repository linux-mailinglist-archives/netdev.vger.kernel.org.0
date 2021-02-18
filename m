Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6591331EDAA
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhBRRtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:49:14 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:53521 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhBRRWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:22:25 -0500
Received: by mail-il1-f198.google.com with SMTP id s12so1574561ilh.20
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:21:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=70mWA/syeYNv54oaeIaoq9XXAMB6CP00uHj11qVXy7M=;
        b=TrzUeLehuMeugXbDimly7eJAlJMUBAYSkeDkXzLpA7PtIEyMGveMSukAkQ8VconSl0
         gtKftMLLenfdX/irUngEYf53FDHl4+/qyYaSnR+HIjGT623/61QsPAzLfhK8Z0bHp9lE
         1nIGOrg6GzaUEan1Z3LA3NCSbwo5D23zBgc9q6yUjRa1dkM9mnWuEye1FyaIt+5hPFmn
         qJ58rWiCp9mdIDyuNz4Wg++CFqPWUAYr6wymmvGt/FZPL5upVnyLIk9Uu4VINCJZJ/ON
         f8Rj6ZP5Mq0N4D45YceiSHrWyGhmsnws2dxNyrjd2/31Ift65YPrOvTmBxtIfVbZm0qe
         mx/g==
X-Gm-Message-State: AOAM532osLMiS7V9GifdyEFpVMIFTdeueJDK8i4n2Gr/8pqX7nZkYuHT
        miwz/Qnm8ySXwHGu8KdabiyOMC+mAoZL3G7C8A5Q3oB82mBE
X-Google-Smtp-Source: ABdhPJxlnJ7bZYFsn6UaWciRai5QfxcxAnaFxuVeRtkniCIVTkrAQCl49fqOUvAWa+AoBgbmIj32udtDOaQSEPHidAs54dGew3wF
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:11af:: with SMTP id 15mr156835ilj.302.1613668886307;
 Thu, 18 Feb 2021 09:21:26 -0800 (PST)
Date:   Thu, 18 Feb 2021 09:21:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0ea2805bb9f9056@google.com>
Subject: UBSAN: shift-out-of-bounds in netlink_recvmsg
From:   syzbot <syzbot+cdb35bcbfac5f493e2af@syzkaller.appspotmail.com>
To:     0x7f454c46@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        fw@strlen.de, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mkubecek@suse.cz, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b646acd5 net: re-solve some conflicts after net -> net-nex..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=129fbe04d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=cdb35bcbfac5f493e2af
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bd2e5ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c388f2d00000

The issue was bisected to:

commit b911c97c7dc771633c68ea9b8f15070f8af3d323
Author: Florian Westphal <fw@strlen.de>
Date:   Sat Feb 13 00:00:01 2021 +0000

    mptcp: add netlink event support

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=163d5724d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=153d5724d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=113d5724d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdb35bcbfac5f493e2af@syzkaller.appspotmail.com
Fixes: b911c97c7dc7 ("mptcp: add netlink event support")

================================================================================
UBSAN: shift-out-of-bounds in net/netlink/af_netlink.c:160:19
shift exponent 32 is too large for 32-bit type 'int'
CPU: 1 PID: 8437 Comm: syz-executor324 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 netlink_group_mask net/netlink/af_netlink.c:160 [inline]
 netlink_group_mask net/netlink/af_netlink.c:158 [inline]
 netlink_recvmsg.cold+0x1a/0x1f net/netlink/af_netlink.c:1992
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 sock_recvmsg net/socket.c:900 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2571
 ___sys_recvmsg+0x127/0x200 net/socket.c:2613
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2649
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444bf9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 81 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f68a1130318 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 00000000004ca408 RCX: 0000000000444bf9
RDX: 0000000000000002 RSI: 0000000020000440 RDI: 0000000000000003
RBP: 00000000004ca400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 8001000a373e1537
R13: 00007ffc4d11dcaf R14: 00007f68a1130400 R15: 0000000000022000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
