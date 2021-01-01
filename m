Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029612E82BA
	for <lists+netdev@lfdr.de>; Fri,  1 Jan 2021 02:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbhAAAtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 19:49:53 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:42051 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbhAAAtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 19:49:53 -0500
Received: by mail-il1-f197.google.com with SMTP id p10so18853487ilo.9
        for <netdev@vger.kernel.org>; Thu, 31 Dec 2020 16:49:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f4jpcmyenKqYfST2LyQr30I+nGdhfXpwOSlfzY/gMRg=;
        b=J0veX9SpN6g37RbLzzkMxOKLAKKd3kC2zv52bkFwTDLt78RAv2pg/i1PL/Hb7zZOT/
         MFfQeIToCaZUuoMlPw+ZIkhWUlZwM11t+xtdv/5hrOehpPC+H9+3KtoxDPO+S7m/q6nL
         GaHe0uClPqrQgPjyZ3G5UIio6pw8XLgdRXB0J0kZCfRalWzC/QNNLFMoePptzjxYPJ8z
         lHkv8+bhx0t0BLyBcw7FV7J7Xjlmi9d4MICyQTlfhZUcf4DL+yCUd9RlOZmd/mjyzxPd
         Q77k1eSUqfCK0OlLqsrLNL29p8hTEt/R/8mFrQNUNjPQ69PCBVLzeN0Nul635k1r4UTO
         9bTQ==
X-Gm-Message-State: AOAM532Mqkzq4IPWjNWhTC0HlPulv0oNHIiocVUhmPnZOOETceSFDRv+
        nYebO3lGIF5SFotDkLyS/zX9DntHVd3CnGU3gNe+YytDTEiN
X-Google-Smtp-Source: ABdhPJz5xy4u3Ybd++5GdqLQDigch4VAvgPEqKu2JTiKDWpaq0dnJo0DnSWd61C0FPgiaKY1aFv6nXGlpQzz7SzLD8LwnGBb8WKf
MIME-Version: 1.0
X-Received: by 2002:a92:58dc:: with SMTP id z89mr58050886ilf.11.1609462151899;
 Thu, 31 Dec 2020 16:49:11 -0800 (PST)
Date:   Thu, 31 Dec 2020 16:49:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7f02105b7cc1b99@google.com>
Subject: WARNING: suspicious RCU usage in xt_obj_to_user
From:   syzbot <syzbot+00399fa030c641ffc5ae@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f838f8d2 mfd: ab8500-debugfs: Remove extraneous seq_putc
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17074c47500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a43a64bad3fdb39
dashboard link: https://syzkaller.appspot.com/bug?extid=00399fa030c641ffc5ae
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00399fa030c641ffc5ae@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.10.0-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:7877 Illegal context switch in RCU-bh read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
1 lock held by syz-executor.0/9704:
 #0: ffff888013794458 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206

stack backtrace:
CPU: 0 PID: 9704 Comm: syz-executor.0 Not tainted 5.10.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ___might_sleep+0x229/0x2c0 kernel/sched/core.c:7877
 __might_fault+0x6e/0x180 mm/memory.c:5014
 xt_obj_to_user+0x31/0x110 net/netfilter/x_tables.c:277
 xt_target_to_user+0xa8/0x200 net/netfilter/x_tables.c:323
 copy_entries_to_user net/ipv4/netfilter/arp_tables.c:705 [inline]
 get_entries net/ipv4/netfilter/arp_tables.c:866 [inline]
 do_arpt_get_ctl+0x733/0x8f0 net/ipv4/netfilter/arp_tables.c:1450
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4141
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2156
 __do_sys_getsockopt net/socket.c:2171 [inline]
 __se_sys_getsockopt net/socket.c:2168 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2168
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ef5a
Code: b8 34 01 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 cd 9f fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 aa 9f fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffcf91ed728 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffcf91ed790 RCX: 000000000045ef5a
RDX: 0000000000000061 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffcf91ed73c R09: 000000000000000a
R10: 00007ffcf91ed790 R11: 0000000000000212 R12: 00007ffcf91ed73c
R13: 0000000000000000 R14: 0000000000000032 R15: 000000000003354d


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
