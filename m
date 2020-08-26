Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B13253144
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgHZO12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:27:28 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:46083 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgHZO1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:27:21 -0400
Received: by mail-il1-f200.google.com with SMTP id q19so1673220ilt.13
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 07:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IxBmqmDRoHLcoHKmS6D2wqcsc8+BWb34PU7TknvN7DE=;
        b=hxUsIt/aDgGZGHs5Ghaq/TI8mh3N8wY6eo5u9udf3PxXYotrjm1B5+u/oEKzmZ1lhG
         8pC0VzZwocYxz36lxLdUqiI8h7xKKeEM9ihV92W6VXLWiWKItkmQXlXlFqHWVKhvMp+f
         XYzooiA0jIgWqxLy3x/wEVSTzThHr1OTsERJssnYiwgKHTeAlM8Q//DiRG/KdzblsnCn
         Pj94UAzFtHYD6KvfgIxL0LTPxUPTXo+c1i7pOxXTuleUQfgwvrA/4OeHJuv1K3zeqXLy
         Mgk6Qzz8JjdxCCvPSaLY7v4KMLqHdiMwZSUjAZsVbPqwiMnf8ZZIZmPTnY+2rx4lF5bn
         q+Cw==
X-Gm-Message-State: AOAM532W2DrxL7EEr0060iT8aedCINvfum4SMd31sn9Wj8SEjmD1dFfY
        1wUyU8R8IGYsEetw2pFq7X7r2YElrtQG7g3wRvSvK741jp+k
X-Google-Smtp-Source: ABdhPJzB2ln6gc3GUNhZHjsCa5AWe4c4CAaM1SmcAstLpYCF2NjbAAyvvlMwBZ3CloNI7vb/3uZW3VNzgRvMrYzJW6mAZBt/55ZE
MIME-Version: 1.0
X-Received: by 2002:a02:cbb5:: with SMTP id v21mr10945733jap.88.1598452040273;
 Wed, 26 Aug 2020 07:27:20 -0700 (PDT)
Date:   Wed, 26 Aug 2020 07:27:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d12fd05adc89e64@google.com>
Subject: WARNING: refcount bug in qdisc_put (2)
From:   syzbot <syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, petrm@mellanox.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6a9dc5fd lib: Revert use of fallthrough pseudo-keyword in ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ee850e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
dashboard link: https://syzkaller.appspot.com/bug?extid=b33c1cb0a30ebdc8a5f9
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e2a461900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176e7296900000

The issue was bisected to:

commit aee9caa03fc3c8b02f8f31824354d85f30e562e0
Author: Petr Machata <petrm@mellanox.com>
Date:   Fri Jun 26 22:45:28 2020 +0000

    net: sched: sch_red: Add qevents "early_drop" and "mark"

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1453782e900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1653782e900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1253782e900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com
Fixes: aee9caa03fc3 ("net: sched: sch_red: Add qevents "early_drop" and "mark"")

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 6850 at lib/refcount.c:28 refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6850 Comm: syz-executor115 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x1d1/0x1e0 lib/refcount.c:28
Code: e9 db fe ff ff 48 89 df e8 dc ee 18 fe e9 8a fe ff ff e8 e2 d5 d8 fd 48 c7 c7 00 db 93 88 c6 05 da e4 11 07 01 e8 d1 e6 a9 fd <0f> 0b e9 af fe ff ff 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55
RSP: 0018:ffffc90001fe74a0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880946b4180 RSI: ffffffff815dafc7 RDI: fffff520003fce86
RBP: 0000000000000003 R08: 0000000000000001 R09: ffff8880ae6318e7
R10: 0000000000000000 R11: 0000000035383654 R12: ffff8880a0b75864
R13: 00000000ffffffea R14: ffff88809dc40000 R15: ffff88809fa52024
 refcount_sub_and_test include/linux/refcount.h:274 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 qdisc_put+0xbe/0xe0 net/sched/sch_generic.c:984
 qdisc_create+0xcd9/0x12e0 net/sched/sch_api.c:1295
 tc_modify_qdisc+0x4c8/0x1990 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4404a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff85fa9228 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004404a9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401cb0
R13: 0000000000401d40 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
