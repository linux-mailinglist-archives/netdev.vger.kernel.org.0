Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506FD355CD5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245287AbhDFU1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:27:35 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43290 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhDFU1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 16:27:30 -0400
Received: by mail-io1-f71.google.com with SMTP id d12so13717583ioo.10
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 13:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WWZMD3vE1shWWmcKMLVb3tL7TZhs/w4sb0DksWu1yo4=;
        b=ZP/AIexZRPxiTHIpEMq0kbSZGOr2onjilYYhZjcaQfnilyu8TazSn+q5+5c2/siNhS
         HI/TBu7KgupuFqNyK96X1NMXDhjLuRySO/rdW1PVppjp+oz7DfLXMgTVZRC+uCyXpuxE
         wTd+VeyEJdZ8Nxi2aMFfR571HuW1zKWVELQA1ZOb4z/YpHplLMP39pJgZ29vjwUtR6aX
         11/o65tUT4/dfHodNZZMo4GI6VdyrWKEtDaOlIkcTtz+NGPFY0U4keTRenQTLsn0KE6n
         uNhQQVxeu3yqf7GXm8TdhIBMREK1j7Ss/pT/kEKIjDac0u5awM4eXtDaPdOTLr3DCOQP
         +mxg==
X-Gm-Message-State: AOAM531i7XpYZYs6tjsg8jpwOAoiW+d6ayzxo6mSkN/3DbpOW/TYB/9+
        o4JwAzgZeJSZpv7ptZgQD2c7J2PW+7WvjaNSwzPlM0SuO/Mr
X-Google-Smtp-Source: ABdhPJz3WotH7oEOOHsVp0hC3ITf9FpTkVQlpuBbSLzB6d2rxa0sqNazLFH5jFNtQuNPrhI8AxGj0YiOYK0vZ/SAoTC1jGx/WNSf
MIME-Version: 1.0
X-Received: by 2002:a6b:3c1a:: with SMTP id k26mr25172746iob.113.1617740842168;
 Tue, 06 Apr 2021 13:27:22 -0700 (PDT)
Date:   Tue, 06 Apr 2021 13:27:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c794c05bf53a4b7@google.com>
Subject: [syzbot] possible deadlock in team_device_event (2)
From:   syzbot <syzbot+d6d7f5e816b836806b38@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bd78980b net: usb: ax88179_178a: initialize local variable..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1043f831d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=d6d7f5e816b836806b38

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d6d7f5e816b836806b38@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.12.0-rc4-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.2/10541 is trying to acquire lock:
ffff888060ac8c78 (team->team_lock_key#3){+.+.}-{3:3}, at: team_port_change_check drivers/net/team/team.c:2970 [inline]
ffff888060ac8c78 (team->team_lock_key#3){+.+.}-{3:3}, at: team_device_event+0x36a/0xa90 drivers/net/team/team.c:2996

but task is already holding lock:
ffff888060ac8c78 (team->team_lock_key#3){+.+.}-{3:3}, at: team_del_slave+0x29/0x140 drivers/net/team/team.c:1981

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(team->team_lock_key#3);
  lock(team->team_lock_key#3);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.2/10541:
 #0: ffffffff8d66d7a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d66d7a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5550
 #1: ffff888060ac8c78 (team->team_lock_key#3){+.+.}-{3:3}, at: team_del_slave+0x29/0x140 drivers/net/team/team.c:1981

stack backtrace:
CPU: 1 PID: 10541 Comm: syz-executor.2 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __mutex_lock_common kernel/locking/mutex.c:949 [inline]
 __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
 team_port_change_check drivers/net/team/team.c:2970 [inline]
 team_device_event+0x36a/0xa90 drivers/net/team/team.c:2996
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 dev_close_many+0x2ff/0x620 net/core/dev.c:1722
 vlan_device_event+0x8eb/0x2020 net/8021q/vlan.c:453
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 dev_close_many+0x2ff/0x620 net/core/dev.c:1722
 dev_close net/core/dev.c:1744 [inline]
 dev_close+0x16d/0x210 net/core/dev.c:1738
 team_port_del+0x34e/0x960 drivers/net/team/team.c:1349
 team_del_slave+0x34/0x140 drivers/net/team/team.c:1982
 do_set_master+0xe1/0x220 net/core/rtnetlink.c:2505
 do_setlink+0x920/0x3a70 net/core/rtnetlink.c:2715
 __rtnl_newlink+0xdcf/0x1710 net/core/rtnetlink.c:3376
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f23b77d7188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007fff1a112cdf R14: 00007f23b77d7300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
