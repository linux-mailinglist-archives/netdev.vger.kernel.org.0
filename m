Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03F066D0EC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 22:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbjAPV2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 16:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbjAPV2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 16:28:51 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA1129E10
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:28:49 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so21740918ild.16
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:28:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2XCwDhtAn7jFlbT/UnBt4PISFMusnU1tJQ4/TMA1T0g=;
        b=HJcOYp9pB44lW/rfjdexr+iuAWa7HwpBAHJlYnS7xl0sDUC7PJ8XmumjdwFSzqKoWT
         D8pNTL61jrGVvSiIBYPyOnwgIQyx1tlAsydw3fEMOcQmSSkgBtyWhkcxqPHCHchiDQ0Q
         9r4bq32XtYZYCRMHzEFlH0IJvc5Bj2gdaZAaVKHU2nPtVsj1n2f5nxUzGFn8CaV/cY4J
         r8i4GdmKpl8cNV+KUOPXvndQJgS75cSCaPRx7mSQ6ske2V8AvqHGWGkfJ+rwUESBAzIt
         C1wQgpyCYs1QLxvUFR+YM3ClxDbnrY7W41Qn7GkgoiblnGNNXZ7mVohM41sdm3Dbmtmp
         aNfQ==
X-Gm-Message-State: AFqh2kqImknF/+rm8Bd07wFIBYIwyGI3/lNiW/lWg+5MuIB3CPQ/uFPZ
        zCgR85dLdGJ58HnjupNftRLqEEgBOUqa/6hl6yLBbMAnywqi
X-Google-Smtp-Source: AMrXdXv482S15UmyPtDD+qmSxm86zoKq+p8wQhtrV8IVRZtWPlwG6GH7RPwh600RvablVQVxhYvjTrblXD1FEi5oW00bSJFBcgZR
MIME-Version: 1.0
X-Received: by 2002:a92:d74c:0:b0:30d:a23a:604f with SMTP id
 e12-20020a92d74c000000b0030da23a604fmr105030ilq.139.1673904529168; Mon, 16
 Jan 2023 13:28:49 -0800 (PST)
Date:   Mon, 16 Jan 2023 13:28:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9606605f2684493@google.com>
Subject: [syzbot] possible deadlock in lapb_disconnect_request
From:   syzbot <syzbot+c9450e09c6b15886782c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        ms@dev.tdt.de, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    358a161a6a9e Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=150ef54a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2573056c6a11f00d
dashboard link: https://syzkaller.appspot.com/bug?extid=c9450e09c6b15886782c
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1760c716480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a8500e480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/99d14e0f4c19/disk-358a161a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/23275b612976/vmlinux-358a161a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ed79195fac61/Image-358a161a.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c9450e09c6b15886782c@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device bond1475
============================================
WARNING: possible recursive locking detected
6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0 Not tainted
--------------------------------------------
syz-executor129/7388 is trying to acquire lock:
ffff0000fff929c0 (&lapb->lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
ffff0000fff929c0 (&lapb->lock){+.-.}-{2:2}, at: lapb_disconnect_request+0xc0/0x1d4 net/lapb/lapb_iface.c:356

but task is already holding lock:
ffff0000fff571c0 (&lapb->lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
ffff0000fff571c0 (&lapb->lock){+.-.}-{2:2}, at: lapb_device_event+0x108/0x380 net/lapb/lapb_iface.c:471

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&lapb->lock);
  lock(&lapb->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by syz-executor129/7388:
 #0: ffff80000da1a2f8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffff80000da1a2f8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x458/0x82c net/core/rtnetlink.c:6138
 #1: ffff0000fff571c0 (&lapb->lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
 #1: ffff0000fff571c0 (&lapb->lock){+.-.}-{2:2}, at: lapb_device_event+0x108/0x380 net/lapb/lapb_iface.c:471
 #2: ffff80000d645548 (rcu_read_lock_bh){....}-{1:2}, at: rcu_lock_acquire+0x18/0x54 include/linux/rcupdate.h:324
 #3: ffff80000d645520 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x10/0x4c include/linux/rcupdate.h:324
 #4: ffff80000d645548 (rcu_read_lock_bh){....}-{1:2}, at: rcu_lock_acquire+0x18/0x54 include/linux/rcupdate.h:324
 #5: ffff0000ff325ed8 (_xmit_X25#2){+...}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
 #5: ffff0000ff325ed8 (_xmit_X25#2){+...}-{2:2}, at: __netif_tx_lock include/linux/netdevice.h:4316 [inline]
 #5: ffff0000ff325ed8 (_xmit_X25#2){+...}-{2:2}, at: __dev_queue_xmit+0x79c/0xdb8 net/core/dev.c:4245
 #6: ffff0000ffd76cc0 (&lapbeth->up_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
 #6: ffff0000ffd76cc0 (&lapbeth->up_lock){+...}-{2:2}, at: lapbeth_xmit+0x30/0x2b0 drivers/net/wan/lapbether.c:190

stack backtrace:
CPU: 0 PID: 7388 Comm: syz-executor129 Not tainted 6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 __lock_acquire+0x808/0x3084
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x54/0x6c kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:355 [inline]
 lapb_disconnect_request+0xc0/0x1d4 net/lapb/lapb_iface.c:356
 lapbeth_xmit+0x8c/0x2b0 drivers/net/wan/lapbether.c:211
 __netdev_start_xmit include/linux/netdevice.h:4865 [inline]
 netdev_start_xmit include/linux/netdevice.h:4879 [inline]
 xmit_one net/core/dev.c:3583 [inline]
 dev_hard_start_xmit+0xd4/0x1ec net/core/dev.c:3599
 __dev_queue_xmit+0x83c/0xdb8 net/core/dev.c:4249
 bond_start_xmit+0x708/0xca0 drivers/net/bonding/bond_main.c:5457
 __netdev_start_xmit include/linux/netdevice.h:4865 [inline]
 netdev_start_xmit include/linux/netdevice.h:4879 [inline]
 xmit_one net/core/dev.c:3583 [inline]
 dev_hard_start_xmit+0xd4/0x1ec net/core/dev.c:3599
 __dev_queue_xmit+0x83c/0xdb8 net/core/dev.c:4249
 dev_queue_xmit include/linux/netdevice.h:3035 [inline]
 lapbeth_data_transmit+0xd0/0xe4 drivers/net/wan/lapbether.c:259
 lapb_data_transmit+0x3c/0x60 net/lapb/lapb_iface.c:447
 lapb_transmit_buffer+0x154/0x1a0 net/lapb/lapb_out.c:149
 lapb_send_control+0x170/0x18c net/lapb/lapb_subr.c:251
 lapb_establish_data_link+0x50/0x70
 lapb_device_event+0x2ac/0x380
 notifier_call_chain kernel/notifier.c:87 [inline]
 raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
 call_netdevice_notifiers_info net/core/dev.c:1944 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 dev_open+0xec/0x168 net/core/dev.c:1458
 bond_enslave+0x7cc/0x1824 drivers/net/bonding/bond_main.c:1963
 do_set_master net/core/rtnetlink.c:2617 [inline]
 do_setlink+0x564/0x17a4 net/core/rtnetlink.c:2820
 __rtnl_newlink net/core/rtnetlink.c:3590 [inline]
 rtnl_newlink+0x98c/0xa08 net/core/rtnetlink.c:3637
 rtnetlink_rcv_msg+0x484/0x82c net/core/rtnetlink.c:6141
 netlink_rcv_skb+0xfc/0x1e8 net/netlink/af_netlink.c:2564
 rtnetlink_rcv+0x28/0x38 net/core/rtnetlink.c:6159
 netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1330
 netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x2f8/0x440 net/socket.c:2476
 ___sys_sendmsg net/socket.c:2530 [inline]
 __sys_sendmsg+0x1ac/0x228 net/socket.c:2559
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2566
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x140 arch/arm64/kernel/syscall.c:197
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
bond1475: (slave lapb2942): Enslaving as an active interface with an up link


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
