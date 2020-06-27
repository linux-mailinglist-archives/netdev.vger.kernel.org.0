Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622FD20C16B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgF0NTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:19:13 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51330 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgF0NTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:19:12 -0400
Received: by mail-io1-f70.google.com with SMTP id x22so8103875ion.18
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 06:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2ETT4vRqkagml67hgM1LINwp51bE7tiOUDLkI2udidU=;
        b=MWcbpQ7DNx8+RTg0KSuU0i+Ec1Tj03eOr88TOndPijP1Qz4qtifWZljoGtWOqXcL0U
         qCD4SLDJ9sKfiOKz2jvjRdP1FjwDFcMxbT7HKyB4qdeuk1AAYuuBqJPrHhiMWYiATRHP
         xYpuRhLSZvfwKPKmkFyXfpBh1hDOnSaT+TSfs5xFRJbEHWAFI5WM5tvgG447p0YTzpg6
         H81VhUlFCFIlx+IvNHLD881iT71znk2gtvXNXigz+bsGA4q36ugcu/+Tqh6vl8xD2XAQ
         jnI9741a73zg03gmUd4/9A6dxq1qgaaWmPEv/hVV5o4foQ9STHgfZdiocnNB1vP9/PGE
         MaYQ==
X-Gm-Message-State: AOAM532XxqechBt/0u8K0ySYbXZLwYgs3Djyjs1vwLO4bdGJhQu9+xwF
        R9tcHJctOSLHEaflRJ73P0eks6G7PTzQtq44elaEy9IGvizR
X-Google-Smtp-Source: ABdhPJzZicoDpcMR9MJB8x29XA1Na8tAmKCbYlYr3OMYiW7Ru8tafplRKxXouDIpLHcHy5Y+fgdc7VDA0BzIYstrpohP+2zW0+G9
MIME-Version: 1.0
X-Received: by 2002:a92:8947:: with SMTP id n68mr3024125ild.235.1593263951270;
 Sat, 27 Jun 2020 06:19:11 -0700 (PDT)
Date:   Sat, 27 Jun 2020 06:19:11 -0700
In-Reply-To: <000000000000cf1be105a8ffc44c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d95a0505a910abd1@google.com>
Subject: Re: possible deadlock in dev_mc_unsync
From:   syzbot <syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12e8e9c5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=08e3d39f3eb8643216be
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11d2b1c5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17aed775100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.8.0-rc2-syzkaller #0 Not tainted
--------------------------------------------
syz-executor094/7550 is trying to acquire lock:
ffff8880a8f1e280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
ffff8880a8f1e280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:915 [inline]
ffff8880a8f1e280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:909

but task is already holding lock:
ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:914 [inline]
ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:909

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&vlan_netdev_addr_lock_key/1);
  lock(&vlan_netdev_addr_lock_key/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor094/7550:
 #0: ffffffff8a7b0228 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7b0228 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5457
 #1: ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:358 [inline]
 #1: ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: netif_addr_lock_bh include/linux/netdevice.h:4248 [inline]
 #1: ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync net/core/dev_addr_lists.c:914 [inline]
 #1: ffff8880876f4280 (&vlan_netdev_addr_lock_key/1){+...}-{2:2}, at: dev_mc_unsync+0xb0/0x190 net/core/dev_addr_lists.c:909

stack backtrace:
CPU: 0 PID: 7550 Comm: syz-executor094 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain kernel/locking/lockdep.c:3202 [inline]
 __lock_acquire.cold+0x178/0x3f8 kernel/locking/lockdep.c:4380
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 _raw_spin_lock_nested+0x30/0x40 kernel/locking/spinlock.c:361
 netif_addr_lock_nested include/linux/netdevice.h:4243 [inline]
 dev_mc_unsync net/core/dev_addr_lists.c:915 [inline]
 dev_mc_unsync+0xf4/0x190 net/core/dev_addr_lists.c:909
 vlan_dev_stop+0x51/0x350 net/8021q/vlan_dev.c:315
 __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1599
 dev_close_many+0x238/0x650 net/core/dev.c:1624
 vlan_device_event+0x8ef/0x2010 net/8021q/vlan.c:450
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2027
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 dev_close_many+0x30b/0x650 net/core/dev.c:1628
 rollback_registered_many+0x3af/0xf60 net/core/dev.c:8945
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10113
 unregister_netdevice_many+0x36/0x50 net/core/dev.c:10112
 rtnl_delete_link net/core/rtnetlink.c:2953 [inline]
 rtnl_dellink+0x351/0xa70 net/core/rtnetlink.c:3005
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
RIP: 0033:0x4495a9
Code: Bad RIP value.
RSP: 002b:00007f5a08ffddb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dec68 RCX: 00000000004495a9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00000000006dec60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dec6c
R13: 00007ffef4bb9e0f R14: 00007f5a08ffe9c0 R15: 00000000006dec6c

