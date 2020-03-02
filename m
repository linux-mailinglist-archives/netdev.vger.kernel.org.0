Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2348B176225
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCBSNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:13:14 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:44740 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgCBSNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:13:14 -0500
Received: by mail-io1-f72.google.com with SMTP id q13so328564iob.11
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 10:13:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=j5q7y848T2P70zRiYu3DuUEmCDrFHU6vd+U30aYbPUA=;
        b=SI82b57r55srUqNuGhor9MJyqN6Wy2ZWMCP3K+TpXDi2gab8zLdszv1NY+uH31GmB5
         FrOhR3dJ/ONMwbnUHDZjTfQeaMyF6ouXVlAKztSL1fSjWkoeZcEQlUh62TkSl7klADG1
         Nf2plVplqto/lOgsExRjc4Fawa5Zr6iqJJoI/dlSoKSlZuMKXRfdrQq8Z1v6/FMZE+X/
         FfcD7JT/jPMU1pqZY7O91n2ZhKSd9ih5MPfhFhoY+vcsW70PrpITwbx0NcWIMNtiusxX
         7ewgmagzLBpgwk/6dzZnnyH7a8TcAts7kXMEIriKGEZ/td1gF8ck7cS6M5n1eUGLgurq
         cjnA==
X-Gm-Message-State: ANhLgQ1Q7VhIyphyM0QlwBjo8VzZVC2oCtuKkVGMN1Gpki9AY3fg90Q9
        lj1vJEHu5t6/6smgKZA2otmoHdzV34CEYBiJimp9sokeRR72
X-Google-Smtp-Source: ADFU+vu+B3RE2Nr7LlNkMzHD/kRbMXU0sQ6ZRLYE+JDbNuMCn4CiLjRFuAYhm6mmxFj7MF8LlmZRyzBVbdnZE5LetqppBx2tFP43
MIME-Version: 1.0
X-Received: by 2002:a02:85e8:: with SMTP id d95mr367885jai.92.1583172793156;
 Mon, 02 Mar 2020 10:13:13 -0800 (PST)
Date:   Mon, 02 Mar 2020 10:13:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f44aca059fe3232d@google.com>
Subject: possible deadlock in team_port_change_check
From:   syzbot <syzbot+eeca95faae43d590987b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b3e808c Merge tag 'mac80211-next-for-net-next-2020-02-24'..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=146c04f9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec9623400ee72
dashboard link: https://syzkaller.appspot.com/bug?extid=eeca95faae43d590987b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+eeca95faae43d590987b@syzkaller.appspotmail.com

device team_slave_1 left promiscuous mode
device vlan2 left promiscuous mode
device team_slave_0 left promiscuous mode
bridge9: port 1(@) entered disabled state
============================================
WARNING: possible recursive locking detected
5.6.0-rc2-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.5/26255 is trying to acquire lock:
ffff88805be96bf0 (team->team_lock_key#6){+.+.}, at: team_port_change_check+0x49/0x140 drivers/net/team/team.c:2962

but task is already holding lock:
ffff88805be96bf0 (team->team_lock_key#6){+.+.}, at: team_uninit+0x37/0x1c0 drivers/net/team/team.c:1665

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(team->team_lock_key#6);
  lock(team->team_lock_key#6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.5/26255:
 #0: ffffffff8a74d740 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a74d740 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5437
 #1: ffff88805be96bf0 (team->team_lock_key#6){+.+.}, at: team_uninit+0x37/0x1c0 drivers/net/team/team.c:1665

stack backtrace:
CPU: 0 PID: 26255 Comm: syz-executor.5 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2370 [inline]
 check_deadlock kernel/locking/lockdep.c:2411 [inline]
 validate_chain kernel/locking/lockdep.c:2954 [inline]
 __lock_acquire.cold+0x15d/0x385 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
 mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
 team_port_change_check+0x49/0x140 drivers/net/team/team.c:2962
 team_device_event+0x16a/0x420 drivers/net/team/team.c:2988
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 dev_close_many+0x32a/0x6c0 net/core/dev.c:1549
 vlan_device_event+0x9a9/0x2370 net/8021q/vlan.c:450
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 dev_close_many+0x32a/0x6c0 net/core/dev.c:1549
 dev_close.part.0+0x114/0x1e0 net/core/dev.c:1571
 dev_close+0x63/0x80 net/core/dev.c:1574
 team_port_del+0x35c/0x800 drivers/net/team/team.c:1345
 team_uninit+0xc3/0x1c0 drivers/net/team/team.c:1667
 rollback_registered_many+0xa06/0x1030 net/core/dev.c:8824
 unregister_netdevice_many.part.0+0x1b/0x1f0 net/core/dev.c:9963
 unregister_netdevice_many+0x3b/0x50 net/core/dev.c:9962
 rtnl_delete_link+0xda/0x130 net/core/rtnetlink.c:2933
 rtnl_dellink+0x341/0x9e0 net/core/rtnetlink.c:2985
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5440
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5458
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c479
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8bb9fd6c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f8bb9fd76d4 RCX: 000000000045c479
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 000000000000000a
RBP: 000000000076c060 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009f9 R14: 00000000004cc71a R15: 000000000076c06c


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
