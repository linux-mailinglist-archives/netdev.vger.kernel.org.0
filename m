Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBAE321310
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhBVJ0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:26:18 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:46159 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhBVJ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:26:01 -0500
Received: by mail-il1-f199.google.com with SMTP id j5so7212026ila.13
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 01:25:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dd5E75WeB1fcJTnUyxbeSxDm5KeJnuGU9IgYm2DyzmU=;
        b=fav8Zp4mmRgNY/duGJQpuNTKkFKdP5RuJ7sCXa9mqDjbTn0lXSfxDtKEcnPFkxNi91
         rgikvtd4/xcqISyNyAOFygnyWH4/wUyRKtmPXZMkOenVZRkXutP0Ym5pc3BYwRIQtnf1
         ya6mdPHnKTzlSXjmkDYa+D2hpu2Mb85GEC/65alhmyCi2bbI9Fk7AKKrHFvbZzJEYukg
         pmGlVW9Ca2thdciX4p587bOqEgUdYwU5BWaqtPKYCsAChWeGB3Gil4onrDhzKEZlF4F9
         J9ecV6xXxzhoLedXfsmenbUHTBpKQuSf0C1wajke9KqLD2HolIg6/eMUwN20PdkLNBeA
         oIeA==
X-Gm-Message-State: AOAM531kJDmAck1sgLwR+SqrurNsS0eG+B2Z9VjESx6YtFMN/ztgFnAg
        9WEa2b9XL7F/Mpu+CKtEUq4os2L1J92IYMWPmO4Wep/8/wTR
X-Google-Smtp-Source: ABdhPJyc36tIXExcRpXhdhOptC8rXSAFw70zjDUUHJsw7xDbK0PMwjV+Eaf8fWfXi4Zdb/iHi7KZgi954segSaraf9P+InXjDzl6
MIME-Version: 1.0
X-Received: by 2002:a92:940b:: with SMTP id c11mr13431224ili.132.1613985920259;
 Mon, 22 Feb 2021 01:25:20 -0800 (PST)
Date:   Mon, 22 Feb 2021 01:25:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000731bc205bbe96143@google.com>
Subject: memory leak in __pskb_copy_fclone
From:   syzbot <syzbot+44b651863a17760a893b@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b89c34d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5528e8db7fc481ae
dashboard link: https://syzkaller.appspot.com/bug?extid=44b651863a17760a893b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a9d40cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1208fccad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+44b651863a17760a893b@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff888110c36e00 (size 232):
  comm "syz-executor899", pid 8419, jiffies 4294996042 (age 38.220s)
  hex dump (first 32 bytes):
    10 1b f0 10 81 88 ff ff 10 1b f0 10 81 88 ff ff  ................
    00 00 00 00 00 00 00 00 40 1a f0 10 81 88 ff ff  ........@.......
  backtrace:
    [<00000000b4534d28>] __alloc_skb+0x6d/0x280 net/core/skbuff.c:198
    [<00000000a1f27cd4>] __pskb_copy_fclone+0x73/0x330 net/core/skbuff.c:1563
    [<000000003311a1de>] __pskb_copy include/linux/skbuff.h:1163 [inline]
    [<000000003311a1de>] pskb_copy include/linux/skbuff.h:3130 [inline]
    [<000000003311a1de>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
    [<00000000c07253fa>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
    [<00000000c07253fa>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
    [<000000001b265c49>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
    [<00000000908eabe9>] __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
    [<00000000908eabe9>] netdev_start_xmit include/linux/netdevice.h:4792 [inline]
    [<00000000908eabe9>] xmit_one net/core/dev.c:3574 [inline]
    [<00000000908eabe9>] dev_hard_start_xmit+0xe1/0x330 net/core/dev.c:3590
    [<000000007fbb3187>] sch_direct_xmit+0x1c5/0x500 net/sched/sch_generic.c:313
    [<000000001df39c76>] qdisc_restart net/sched/sch_generic.c:376 [inline]
    [<000000001df39c76>] __qdisc_run+0x201/0x810 net/sched/sch_generic.c:384
    [<000000002521364f>] qdisc_run include/net/pkt_sched.h:136 [inline]
    [<000000002521364f>] qdisc_run include/net/pkt_sched.h:128 [inline]
    [<000000002521364f>] __dev_xmit_skb net/core/dev.c:3765 [inline]
    [<000000002521364f>] __dev_queue_xmit+0xb9b/0xf60 net/core/dev.c:4119
    [<00000000fe77cf74>] dgram_sendmsg+0x40c/0x4d0 net/ieee802154/socket.c:682
    [<00000000f9f3520e>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000f9f3520e>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<000000005e70a8bc>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2345
    [<00000000e2a23226>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000008b9fc415>] __sys_sendmsg+0x88/0x100 net/socket.c:2432
    [<0000000089dd1aab>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000011f571a2>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888103ae5f00 (size 232):
  comm "syz-executor899", pid 8428, jiffies 4294998453 (age 14.110s)
  hex dump (first 32 bytes):
    50 1b f0 10 81 88 ff ff 50 1b f0 10 81 88 ff ff  P.......P.......
    00 00 00 00 00 00 00 00 80 1a f0 10 81 88 ff ff  ................
  backtrace:
    [<00000000b4534d28>] __alloc_skb+0x6d/0x280 net/core/skbuff.c:198
    [<00000000a1f27cd4>] __pskb_copy_fclone+0x73/0x330 net/core/skbuff.c:1563
    [<000000003311a1de>] __pskb_copy include/linux/skbuff.h:1163 [inline]
    [<000000003311a1de>] pskb_copy include/linux/skbuff.h:3130 [inline]
    [<000000003311a1de>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
    [<00000000c07253fa>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
    [<00000000c07253fa>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
    [<000000001b265c49>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
    [<00000000908eabe9>] __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
    [<00000000908eabe9>] netdev_start_xmit include/linux/netdevice.h:4792 [inline]
    [<00000000908eabe9>] xmit_one net/core/dev.c:3574 [inline]
    [<00000000908eabe9>] dev_hard_start_xmit+0xe1/0x330 net/core/dev.c:3590
    [<000000007fbb3187>] sch_direct_xmit+0x1c5/0x500 net/sched/sch_generic.c:313
    [<000000001df39c76>] qdisc_restart net/sched/sch_generic.c:376 [inline]
    [<000000001df39c76>] __qdisc_run+0x201/0x810 net/sched/sch_generic.c:384
    [<000000002521364f>] qdisc_run include/net/pkt_sched.h:136 [inline]
    [<000000002521364f>] qdisc_run include/net/pkt_sched.h:128 [inline]
    [<000000002521364f>] __dev_xmit_skb net/core/dev.c:3765 [inline]
    [<000000002521364f>] __dev_queue_xmit+0xb9b/0xf60 net/core/dev.c:4119
    [<00000000fe77cf74>] dgram_sendmsg+0x40c/0x4d0 net/ieee802154/socket.c:682
    [<00000000f9f3520e>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000f9f3520e>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<000000005e70a8bc>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2345
    [<00000000e2a23226>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000008b9fc415>] __sys_sendmsg+0x88/0x100 net/socket.c:2432
    [<0000000089dd1aab>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000011f571a2>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810d717c00 (size 512):
  comm "syz-executor899", pid 8428, jiffies 4294998453 (age 14.110s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000010ef2c1d>] __kmalloc_reserve net/core/skbuff.c:142 [inline]
    [<0000000010ef2c1d>] __alloc_skb+0xab/0x280 net/core/skbuff.c:210
    [<00000000a1f27cd4>] __pskb_copy_fclone+0x73/0x330 net/core/skbuff.c:1563
    [<000000003311a1de>] __pskb_copy include/linux/skbuff.h:1163 [inline]
    [<000000003311a1de>] pskb_copy include/linux/skbuff.h:3130 [inline]
    [<000000003311a1de>] hwsim_hw_xmit+0xd3/0x140 drivers/net/ieee802154/mac802154_hwsim.c:132
    [<00000000c07253fa>] drv_xmit_async net/mac802154/driver-ops.h:16 [inline]
    [<00000000c07253fa>] ieee802154_tx+0xc7/0x190 net/mac802154/tx.c:83
    [<000000001b265c49>] ieee802154_subif_start_xmit+0x58/0x70 net/mac802154/tx.c:132
    [<00000000908eabe9>] __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
    [<00000000908eabe9>] netdev_start_xmit include/linux/netdevice.h:4792 [inline]
    [<00000000908eabe9>] xmit_one net/core/dev.c:3574 [inline]
    [<00000000908eabe9>] dev_hard_start_xmit+0xe1/0x330 net/core/dev.c:3590
    [<000000007fbb3187>] sch_direct_xmit+0x1c5/0x500 net/sched/sch_generic.c:313
    [<000000001df39c76>] qdisc_restart net/sched/sch_generic.c:376 [inline]
    [<000000001df39c76>] __qdisc_run+0x201/0x810 net/sched/sch_generic.c:384
    [<000000002521364f>] qdisc_run include/net/pkt_sched.h:136 [inline]
    [<000000002521364f>] qdisc_run include/net/pkt_sched.h:128 [inline]
    [<000000002521364f>] __dev_xmit_skb net/core/dev.c:3765 [inline]
    [<000000002521364f>] __dev_queue_xmit+0xb9b/0xf60 net/core/dev.c:4119
    [<00000000fe77cf74>] dgram_sendmsg+0x40c/0x4d0 net/ieee802154/socket.c:682
    [<00000000f9f3520e>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000f9f3520e>] sock_sendmsg+0x56/0x80 net/socket.c:672
    [<000000005e70a8bc>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2345
    [<00000000e2a23226>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2399
    [<000000008b9fc415>] __sys_sendmsg+0x88/0x100 net/socket.c:2432
    [<0000000089dd1aab>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000011f571a2>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
