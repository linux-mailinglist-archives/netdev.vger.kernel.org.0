Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DBF411889
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbhITPoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:44:04 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:35802 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbhITPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:44:03 -0400
Received: by mail-io1-f71.google.com with SMTP id g8-20020a05660203c800b005d58875129eso21093508iov.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PSni9MjmG0vl04msQOLn/dTzzLWMRU+Ls5PPuK9wBqk=;
        b=nnifvOo+q0WUC7+BNlSf4VQuIZZyHyqxUhp/qKv8PvC/WwfmXTr2jqbyZwvP3B5N6z
         bg8Qr14V8di/AQrjfzSrtLpVl7Aiv/PrdypvaGL+f7oCoqMZjnhqN5/7SRlX5MK9y3JZ
         VjtXq9hW1WUEVk9gBHJGJP1FzKskKFm0nXIRZvPjrZpSFWuMZcMUjbYJhBgF93J1rC6+
         /uvCYYgEUm0SZfCwwC28/ChG/TEnPwGoBBI2wRkx/DZIriTjG4wL3EgBLpS5Ez6NlxT1
         GjONXaehSfHKLm8zB016QsGLstuUkv32Ab1m0n56ZNNGOHLF/9lQ2PFT+ahSPjK9BIeY
         IVbQ==
X-Gm-Message-State: AOAM531xNxuXRC2m02wmVJfz0pGITYwsW8clAAD3cyPmGlbaZxs/vId9
        ebbxPJgTvcgQ17LZRicdiTQU4NiCRV0/AeAKSzVYRqg52e7O
X-Google-Smtp-Source: ABdhPJzhlYKY36WBy6S+1W7EyW5d63bCMDfW3cXsptbRwJXD0oDz0GDhBZjintQhZMLuYcUK2sv5SIyZTT5aFXsdzktTSxa6mt0S
MIME-Version: 1.0
X-Received: by 2002:a02:cf39:: with SMTP id s25mr7918369jar.40.1632152556732;
 Mon, 20 Sep 2021 08:42:36 -0700 (PDT)
Date:   Mon, 20 Sep 2021 08:42:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005d127e05cc6f212d@google.com>
Subject: [syzbot] possible deadlock in team_del_slave
From:   syzbot <syzbot+513e530ebfbfe5816cec@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e57f52b42d1f Merge branch 'bpf: implement variadic printk ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=143e16ab300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
dashboard link: https://syzkaller.appspot.com/bug?extid=513e530ebfbfe5816cec
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+513e530ebfbfe5816cec@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.15.0-rc1-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/6377 is trying to acquire lock:
ffff888026c82cf8 (team->team_lock_key#5){+.+.}-{3:3}, at: team_del_slave+0x29/0x140 drivers/net/team/team.c:1981

but task is already holding lock:
ffff8880795b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_del_interface+0xff/0x470 net/wireless/nl80211.c:4088

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&rdev->wiphy.mtx){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       wiphy_lock include/net/cfg80211.h:5311 [inline]
       ieee80211_open net/mac80211/iface.c:361 [inline]
       ieee80211_open+0x18f/0x240 net/mac80211/iface.c:348
       __dev_open+0x2bc/0x4d0 net/core/dev.c:1484
       dev_open net/core/dev.c:1520 [inline]
       dev_open+0xe8/0x150 net/core/dev.c:1513
       team_port_add drivers/net/team/team.c:1210 [inline]
       team_add_slave+0xaa4/0x1cc0 drivers/net/team/team.c:1967
       do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2521
       do_setlink+0x9f3/0x3970 net/core/rtnetlink.c:2726
       __rtnl_newlink+0xde6/0x1750 net/core/rtnetlink.c:3391
       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
       rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
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

-> #0 (team->team_lock_key#5){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       team_del_slave+0x29/0x140 drivers/net/team/team.c:1981
       team_device_event+0x7df/0xa90 drivers/net/team/team.c:3004
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
       call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
       call_netdevice_notifiers net/core/dev.c:2022 [inline]
       unregister_netdevice_many+0x951/0x1790 net/core/dev.c:11041
       unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10975
       unregister_netdevice include/linux/netdevice.h:2988 [inline]
       _cfg80211_unregister_wdev+0x483/0x770 net/wireless/core.c:1125
       ieee80211_if_remove+0x1df/0x380 net/mac80211/iface.c:2088
       ieee80211_del_iface+0x12/0x20 net/mac80211/cfg.c:144
       rdev_del_virtual_intf net/wireless/rdev-ops.h:57 [inline]
       nl80211_del_interface+0x1b2/0x470 net/wireless/nl80211.c:4090
       genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
       genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
       genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
       genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
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

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rdev->wiphy.mtx);
                               lock(team->team_lock_key#5);
                               lock(&rdev->wiphy.mtx);
  lock(team->team_lock_key#5);

 *** DEADLOCK ***

3 locks held by syz-executor.4/6377:
 #0: ffffffff8d177290 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:802
 #1: ffffffff8d0e3f28 (rtnl_mutex){+.+.}-{3:3}, at: nl80211_pre_doit+0x23/0x620 net/wireless/nl80211.c:14927
 #2: ffff8880795b05e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_del_interface+0xff/0x470 net/wireless/nl80211.c:4088

stack backtrace:
CPU: 0 PID: 6377 Comm: syz-executor.4 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __mutex_lock_common kernel/locking/mutex.c:596 [inline]
 __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
 team_del_slave+0x29/0x140 drivers/net/team/team.c:1981
 team_device_event+0x7df/0xa90 drivers/net/team/team.c:3004
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 unregister_netdevice_many+0x951/0x1790 net/core/dev.c:11041
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10975
 unregister_netdevice include/linux/netdevice.h:2988 [inline]
 _cfg80211_unregister_wdev+0x483/0x770 net/wireless/core.c:1125
 ieee80211_if_remove+0x1df/0x380 net/mac80211/iface.c:2088
 ieee80211_del_iface+0x12/0x20 net/mac80211/cfg.c:144
 rdev_del_virtual_intf net/wireless/rdev-ops.h:57 [inline]
 nl80211_del_interface+0x1b2/0x470 net/wireless/nl80211.c:4090
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
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
RIP: 0033:0x7ff117663739
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff114bda188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff117767f80 RCX: 00007ff117663739
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00007ff1176bdcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff117767f80
R13: 00007ffdd3545d8f R14: 00007ff114bda300 R15: 0000000000022000
device wlan9 left promiscuous mode
team0: Port device wlan9 removed


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
