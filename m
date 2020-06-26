Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76520B6BC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgFZRTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:19:30 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:41443 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgFZRTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:19:19 -0400
Received: by mail-il1-f198.google.com with SMTP id k6so6876287ilg.8
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/kUK10ieELCUi5nx8WSCdTJbL7ZCzD7ZpVCtC/bhIJ0=;
        b=c3etcLDUiIfle6O69RddetX0wdJcM9GyFrIrrEcZji6Q5xLa9rOAby7WOO4FyC/wTG
         T1u1LKJma0gixmh6eK3fsONpZ+DTiWeXY6ewb6MLMI9AU7frtZ9V5qOVm4qTS88C5YtZ
         5oHpg6vSn2HZppFiLIXwicuAhsnLhjH3UWQJ6ipw3WJhJdaoXIw7W/ZtUx532Aqk42zG
         gvauRfVah3LMXoXTP6jGmMSgF9at5j2JdhN7oDHP0r5A0Ze6sJiELgNOPC3DFlScmsbu
         EeTaffXZIWWiOc/wbcp7PhaddPqbKSasZAsZlqqBZQwRywZdxRs9OSEUULwdC/l0fvaC
         R1XA==
X-Gm-Message-State: AOAM5338BOIjZmnSbR4XLf15AwZq3Z7oQm17pBmOEyT0vJ4kh9e27pXC
        /awYYvChfpsjlZCN3pfuil4S40IG0kUws76WLcHhhaD/bHBS
X-Google-Smtp-Source: ABdhPJx3Z2RgDpnNjyz+jrFVunjC87B5X8/RuJd9TmZjzYqyDn/8qFBU12ccoeZ9iQhD/5cwbp0Xzsc5vyQzg6m6riOo4oq79tdS
MIME-Version: 1.0
X-Received: by 2002:a92:9f5c:: with SMTP id u89mr4072216ili.262.1593191958242;
 Fri, 26 Jun 2020 10:19:18 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:19:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000baea3505a8ffe8bc@google.com>
Subject: possible deadlock in team_device_event
From:   syzbot <syzbot+e12b58247a69da14ecd2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7a64135f libbpf: Adjust SEC short cut for expected attach ..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=16ed6439100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=e12b58247a69da14ecd2
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e12b58247a69da14ecd2@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.8.0-rc1-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.1/17372 is trying to acquire lock:
ffff888096a2ac38 (team->team_lock_key#4){+.+.}-{3:3}, at: team_port_change_check drivers/net/team/team.c:2969 [inline]
ffff888096a2ac38 (team->team_lock_key#4){+.+.}-{3:3}, at: team_device_event+0x372/0xab6 drivers/net/team/team.c:2995

but task is already holding lock:
ffff888096a2ac38 (team->team_lock_key#4){+.+.}-{3:3}, at: team_add_slave+0x9f/0x1960 drivers/net/team/team.c:1966

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(team->team_lock_key#4);
  lock(team->team_lock_key#4);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor.1/17372:
 #0: ffffffff8a7afda8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7afda8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 #1: ffff888096a2ac38 (team->team_lock_key#4){+.+.}-{3:3}, at: team_add_slave+0x9f/0x1960 drivers/net/team/team.c:1966

stack backtrace:
CPU: 1 PID: 17372 Comm: syz-executor.1 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain kernel/locking/lockdep.c:3202 [inline]
 __lock_acquire.cold+0x178/0x3f8 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x10d0 kernel/locking/mutex.c:1103
 team_port_change_check drivers/net/team/team.c:2969 [inline]
 team_device_event+0x372/0xab6 drivers/net/team/team.c:2995
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1628
 vlan_device_event+0x8ef/0x2010 net/8021q/vlan.c:450
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1628
 dev_close net/core/dev.c:1650 [inline]
 dev_close+0x173/0x220 net/core/dev.c:1644
 team_port_add drivers/net/team/team.c:1305 [inline]
 team_add_slave+0xf45/0x1960 drivers/net/team/team.c:1967
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2476
 do_setlink+0x903/0x35c0 net/core/rtnetlink.c:2611
 __rtnl_newlink+0xc21/0x1730 net/core/rtnetlink.c:3272
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb19
Code: Bad RIP value.
RSP: 002b:00007fb1de059c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000502400 RCX: 000000000045cb19
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a38 R14: 00000000004cd1fc R15: 00007fb1de05a6d4


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
