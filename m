Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724D1404235
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348556AbhIIATk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:19:40 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43631 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348056AbhIIATj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 20:19:39 -0400
Received: by mail-il1-f197.google.com with SMTP id i5-20020a056e0212c500b0022b41c6554bso170945ilm.10
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 17:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A/1kDSniShDOX9suyirIVKJzPQerjbCabu1sZGx/q60=;
        b=o1brf1vwniOyKa0pNVF3Zc/ZdxrcEDT+JdKkCiI+ZFDM6/GH6Hg7Neh8pIw/rSkjVK
         YgLMnNHjvsEOpitf3c3W5O8Ee4FbM5cZ6fB8PWzK2dhwK26Re0r5Zvtf9U66cUhidqPg
         Jj66SkBkM6EuiO3d2SvecCDxxmcwJ3jMB88PdfNjyV190vJqBF31OXiOr0niy6L542z8
         pYcJ0U61tVDueYtmXHuQGrtkaB04Se2ywPBLbtVhi90z8CmaIh7Ntk7fLzdefuaunY4c
         qO3t2QOA9pjTLhMpqdpc/PbF4BECyWQ/2aV4AjrUj3NDkTn+L9dCg19fozDfttlK4/Rc
         suBw==
X-Gm-Message-State: AOAM53168wJLvgr5MMrUjVtQxxppt81cV48xGyuwriGTPcSaPEYm5q8B
        zwFKqQfIs3pWqEvp3GMkiIURMxne5pWVUiQjxADKfVUiZCin
X-Google-Smtp-Source: ABdhPJzIJN34kHuwU4uhLfSbTpnynRNg4wcjQTV5gI0k5WL8R7hs5X90+w7QxCUg5zoClg4NWO0IIq9jaAFHRtKtkUGO70HAfX8G
MIME-Version: 1.0
X-Received: by 2002:a02:cebc:: with SMTP id z28mr214201jaq.49.1631146710473;
 Wed, 08 Sep 2021 17:18:30 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:18:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000041239905cb84f00b@google.com>
Subject: [syzbot] possible deadlock in team_vlan_rx_add_vid (2)
From:   syzbot <syzbot+8b158bd9e6ed497d8cfc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    27151f177827 Merge tag 'perf-tools-for-v5.15-2021-09-04' o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=131a147d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac2f9cc43f6b17e4
dashboard link: https://syzkaller.appspot.com/bug?extid=8b158bd9e6ed497d8cfc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b158bd9e6ed497d8cfc@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device team0
======================================================
WARNING: possible circular locking dependency detected
5.14.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.5/24836 is trying to acquire lock:
ffff88802f4d6cf8 (team->team_lock_key#6){+.+.}-{3:3}, at: team_vlan_rx_add_vid+0x38/0x1e0 drivers/net/team/team.c:1887

but task is already holding lock:
ffff88803aca8cf8 (team->team_lock_key#8){+.+.}-{3:3}, at: team_add_slave+0x9f/0x1cc0 drivers/net/team/team.c:1966

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (team->team_lock_key#8){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       team_vlan_rx_add_vid+0x38/0x1e0 drivers/net/team/team.c:1887
       vlan_add_rx_filter_info+0x149/0x1d0 net/8021q/vlan_core.c:211
       __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
       vlan_vid_add+0x3f2/0x800 net/8021q/vlan_core.c:336
       vlan_add_rx_filter_info+0x149/0x1d0 net/8021q/vlan_core.c:211
       __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
       vlan_vid_add+0x3f2/0x800 net/8021q/vlan_core.c:336
       vlan_device_event.cold+0x28/0x2d net/8021q/vlan.c:392
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
       call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
       call_netdevice_notifiers net/core/dev.c:2022 [inline]
       dev_open net/core/dev.c:1525 [inline]
       dev_open+0x132/0x150 net/core/dev.c:1513
       team_port_add drivers/net/team/team.c:1210 [inline]
       team_add_slave+0xaa4/0x1cc0 drivers/net/team/team.c:1967
       do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2521
       __rtnl_newlink+0x13a1/0x1750 net/core/rtnetlink.c:3475
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
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (team->team_lock_key#6){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       team_vlan_rx_add_vid+0x38/0x1e0 drivers/net/team/team.c:1887
       vlan_add_rx_filter_info+0x149/0x1d0 net/8021q/vlan_core.c:211
       __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
       vlan_vid_add+0x3f2/0x800 net/8021q/vlan_core.c:336
       vlan_device_event.cold+0x28/0x2d net/8021q/vlan.c:392
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
       call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
       call_netdevice_notifiers net/core/dev.c:2022 [inline]
       dev_open net/core/dev.c:1525 [inline]
       dev_open+0x132/0x150 net/core/dev.c:1513
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
       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(team->team_lock_key#8);
                               lock(team->team_lock_key#6);
                               lock(team->team_lock_key#8);
  lock(team->team_lock_key#6);

 *** DEADLOCK ***

2 locks held by syz-executor.5/24836:
 #0: ffffffff8d0ea4a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0ea4a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 #1: ffff88803aca8cf8 (team->team_lock_key#8){+.+.}-{3:3}, at: team_add_slave+0x9f/0x1cc0 drivers/net/team/team.c:1966

stack backtrace:
CPU: 1 PID: 24836 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __mutex_lock_common kernel/locking/mutex.c:596 [inline]
 __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
 team_vlan_rx_add_vid+0x38/0x1e0 drivers/net/team/team.c:1887
 vlan_add_rx_filter_info+0x149/0x1d0 net/8021q/vlan_core.c:211
 __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
 vlan_vid_add+0x3f2/0x800 net/8021q/vlan_core.c:336
 vlan_device_event.cold+0x28/0x2d net/8021q/vlan.c:392
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 dev_open net/core/dev.c:1525 [inline]
 dev_open+0x132/0x150 net/core/dev.c:1513
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
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f88af71b188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000006
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffc1ac8e84f R14: 00007f88af71b300 R15: 0000000000022000
team1: Port device team0 added


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
