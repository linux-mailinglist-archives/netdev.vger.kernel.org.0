Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAB82DC889
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgLPVyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:54:52 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:52507 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgLPVyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 16:54:52 -0500
Received: by mail-io1-f72.google.com with SMTP id b136so25256641iof.19
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 13:54:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=K+UTL1SNKrXO6bwT07zAze2PZObFLqUgFnQL3D5qBw0=;
        b=uDMtH2xciU7bdzfTzvjm+v4W76NxyrJRdd4Jy2wfIe5VkOMC25sz256xn0GVX+zIzH
         ynFjjC2zBlVVt8WJ2tzff6P0h7s6pQqEkt9OsXklR/wgGpxfvROByo1v4waeMKMfn69m
         BaElQeQ2oVyIBzqiJefSLxxR3IZg1OzoBd/b1eB3OJL+Xj9m8HuPkakByZ5IS07LkBD5
         3FHyHcfH9JNQ8M1HT+jZOXSLzZLpmZjEyXgcIPhPj36JCJMT7JDm+/+nD0ckLscbWwmj
         5t09kdByzC0jB1Nlj0C2MoS4DDP65Eeyg0IYqn0yGwrj2RSM1+VZN+U9C6fB9PrCrMgr
         x3Xw==
X-Gm-Message-State: AOAM532k4jHOuA0NeoEuyr5v3fsgbgbXqdvZQchGBTi8fnmOVe+fAm5d
        GGtdM+7/1lewhtWNxsj5YaJL4zB5TKPCA6Y/kDZJkSEeybcN
X-Google-Smtp-Source: ABdhPJyzuySwJbNYQVybaVuxgnqeE+ysBPwQ0+faA6UKXkeKJfkpUbYic3H8+ZLjUCVgcZCtJseFtWDdArKpMhoqrlha/ChTiSFw
MIME-Version: 1.0
X-Received: by 2002:a5d:8704:: with SMTP id u4mr43417613iom.3.1608155650983;
 Wed, 16 Dec 2020 13:54:10 -0800 (PST)
Date:   Wed, 16 Dec 2020 13:54:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005210be05b69bea58@google.com>
Subject: WARNING: suspicious RCU usage in get_wiphy_regdom
From:   syzbot <syzbot+db4035751c56c0079282@syzkaller.appspotmail.com>
To:     davem@davemloft.net, ilan.peer@intel.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    00f7763a Merge tag 'mac80211-next-for-net-next-2020-12-11'..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=160acef3500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d8e2f94cac4630
dashboard link: https://syzkaller.appspot.com/bug?extid=db4035751c56c0079282
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133bc287500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ef080f500000

The issue was bisected to:

commit beee246951571cc5452176f3dbfe9aa5a10ba2b9
Author: Ilan Peer <ilan.peer@intel.com>
Date:   Sun Nov 29 15:30:51 2020 +0000

    cfg80211: Save the regulatory domain when setting custom regulatory

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11492ecb500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13492ecb500000
console output: https://syzkaller.appspot.com/x/log.txt?x=15492ecb500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+db4035751c56c0079282@syzkaller.appspotmail.com
Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting custom regulatory")

=============================
WARNING: suspicious RCU usage
5.10.0-rc7-syzkaller #0 Not tainted
-----------------------------
net/wireless/reg.c:144 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor217/8471:
 #0: ffffffff8c9b5230 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8c9b52e8 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8c9b52e8 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:798

stack backtrace:
CPU: 0 PID: 8471 Comm: syz-executor217 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 get_wiphy_regdom net/wireless/reg.c:144 [inline]
 get_wiphy_regdom+0xc3/0xd0 net/wireless/reg.c:142
 wiphy_apply_custom_regulatory+0x234/0x360 net/wireless/reg.c:2574
 mac80211_hwsim_new_radio+0x1f45/0x4830 drivers/net/wireless/mac80211_hwsim.c:3247
 hwsim_new_radio_nl+0x9a6/0x10b0 drivers/net/wireless/mac80211_hwsim.c:3822
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2331
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2385
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2418
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440309
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff9be21ed8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440309
RDX: 0000000004000010 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000401ba0 R11: 0000000000000246 R12: 0000000000401b10
R13: 0000000000401ba0 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
