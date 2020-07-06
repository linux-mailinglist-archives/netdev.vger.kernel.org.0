Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93474215B06
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgGFPmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:42:37 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:44601 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729611AbgGFPm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:42:26 -0400
Received: by mail-il1-f200.google.com with SMTP id x2so19450562ila.11
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QJnPhCb3eZtnvdOgIdcDa9xcO60r3hTftMQ84MmBxZc=;
        b=sEGrfZt5qeWBKaX33g4e2XGHaeusgYaaY1c2zjjloMxsgPFPDUWpGBOznFGZ0cwJAa
         3QdcHq+9TDu+pK+rIsm3XzCYn5WModM47IHEJDTjChWYo3wVhyLkiGZfp4bvCv7njLma
         pytURhBxbuOUI0VGVa07RzS+xpC1ZQtMh/3pSk/YN9tq2LpQdioxolbhEc098bMMH5FB
         dyOTGXIm8vv24mACpjkhi32Ry204iTXpo5DFN08Hpsorci7/h2ri2UrtG3C6klAJEmN0
         WNBOUZZaKF5q30MXDpWq5AyqsZiLQpxQrgnIn4OVrZdxc9UTw/z/hmDSsj+iKCEaxKmG
         wfjQ==
X-Gm-Message-State: AOAM532OorOXnPgTmXvtr70jci0rXLUEf/N/Do9Bbo1W/w0nkI7Pzbfj
        W9IKWIGrXRWlRlbwGnhGJ+71iy/bdCXhigoHRnqzimu/WhzK
X-Google-Smtp-Source: ABdhPJwu7iS8L19h9of8YaHDLaDeKg8r+n7vbCPenYa/hUCAI7iPBaCbL+xRiie/8XgJaaRx05yDzC142jzHQNLjeUg6Fb7fkeml
MIME-Version: 1.0
X-Received: by 2002:a92:d24a:: with SMTP id v10mr31698648ilg.224.1594050145771;
 Mon, 06 Jul 2020 08:42:25 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:42:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b164d505a9c7b802@google.com>
Subject: WARNING: suspicious RCU usage in bond_ipsec_add_sa
From:   syzbot <syzbot+582c98032903dcc04816@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e44f65fd xen-netfront: remove redundant assignment to vari..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16148f87100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
dashboard link: https://syzkaller.appspot.com/bug?extid=582c98032903dcc04816
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+582c98032903dcc04816@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.8.0-rc2-syzkaller #0 Not tainted
-----------------------------
drivers/net/bonding/bond_main.c:387 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.0/5186:
 #0: ffff888089791a28 (&net->xfrm.xfrm_cfg_mutex){+.+.}-{3:3}, at: xfrm_netlink_rcv+0x5c/0x90 net/xfrm/xfrm_user.c:2687

stack backtrace:
CPU: 1 PID: 5186 Comm: syz-executor.0 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 bond_ipsec_add_sa+0x1c8/0x220 drivers/net/bonding/bond_main.c:387
 xfrm_dev_state_add+0x2da/0x7b0 net/xfrm/xfrm_device.c:268
 xfrm_state_construct net/xfrm/xfrm_user.c:655 [inline]
 xfrm_add_sa+0x2166/0x34f0 net/xfrm/xfrm_user.c:684
 xfrm_user_rcv_msg+0x414/0x700 net/xfrm/xfrm_user.c:2680
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2688
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
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007ff7e9a92c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000005027e0 RCX: 000000000045cb29
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a45 R14: 00000000004cd2c9 R15: 00007ff7e9a936d4
bond0: (slave bond_slave_0): Slave does not support ipsec offload


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
