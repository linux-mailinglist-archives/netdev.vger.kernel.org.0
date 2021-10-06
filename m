Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD7423A86
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhJFJ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJFJ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 05:29:34 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9355FC061749;
        Wed,  6 Oct 2021 02:27:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n11so864105plf.4;
        Wed, 06 Oct 2021 02:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=5BPnrtcUd4exawwgaLK46Mso62ztjXNOBQ35saRpWTg=;
        b=qiIy5PsZX2xEncp7CHtfkOUmqFez0d6kOHjPyawoYNcACrpBCkpFRIZ6UGookevBWQ
         75VKsKUvZTqBqkH8Xj3pdmT90EHCPWLoIVGINDLblhzujtp6i88iWwoNpK5yfjo9ZM9T
         N60IZr19SG7YdUsdutP2IGY9setorJfoCD7/xA3UC3ABDqCG9XECmBghK0TAviP4OiGe
         +6SZb2HZsXZDDr7VvY3htZPwcQ6nQRt0hZ6BFxEIvtQfVUX6mD/Ry+uMmWfT9uXEuVsc
         5ykZZcD1TR1z1sl0dsypQkrOri0aabSWH9raM9ECLcE6IOVBVxDXQo2y/Sqa5JctZucD
         n4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5BPnrtcUd4exawwgaLK46Mso62ztjXNOBQ35saRpWTg=;
        b=SwGGcoHiVzQOQdnIiAR9cdZvlYmc+RzktLrve1KawLzs3AeQthDjznJhnGkL/KnpYX
         q2BRlH47JlIFNt2w2iq4uTOjUo1tmGRI9b6TFUE8KV8qANkfT01V0cBrEwvT34DjlQMB
         +WtVZNOUkBgISTP5kd5WmyqpmbcXbxLxMBanKifbkzviW0ayIStDWe0JSWzvczKtGtjW
         NziH5Y1svnON59jgXZMiEu0VPX/bETnampXkQuahGRt0S2yweAJN929phjPz9Uo/GwUq
         cDEp2uWfFFkcT/W+PazjhZ6doay+Su1V9iU5Vd1v6Jx3GEFYXoMTgY0UjUlxof+4MZK7
         zmfQ==
X-Gm-Message-State: AOAM533XRxxAubxOj0W3C4YULINL3zkLGhFcY7TLB3QKSdTTBtuiIrTe
        FQGvA9V2feFMADMtFJPDz0UyzzQs05YaQq/ViEu+7lVBxS4jdIY=
X-Google-Smtp-Source: ABdhPJxgNzmQg5dT365VyGrQ7QZB80Ms7uh85q8J3xX/38ZlHBmjBGld7w7Uly4VtXmOocGa3sw8DpSk3MEbb6gHvHU=
X-Received: by 2002:a17:90a:b794:: with SMTP id m20mr9962152pjr.178.1633512461971;
 Wed, 06 Oct 2021 02:27:41 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 6 Oct 2021 17:27:31 +0800
Message-ID: <CACkBjsb2j-6C7gPJVE_XZ_Fcc41H1VMoeDJiCHd-xCgcdKWD0A@mail.gmail.com>
Subject: possible deadlock in sch_direct_xmit
To:     Jamal Hadi Salim <jhs@mojatatu.com>, xiyou.wangcong@gmail.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 42d43c92fc57  Merge branch 'for-linus'
git tree: upstream
console output:
https://drive.google.com/file/d/16oeU35nvvz-aFIrGtltd6N0HHf6e6LXl/view?usp=sharing
kernel config: https://drive.google.com/file/d/15vWoQRbJuuMu4ovWhUm1h4SrHyNwK8im/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

============================================
WARNING: possible recursive locking detected
5.15.0-rc3+ #1 Not tainted
--------------------------------------------
syz-executor/9686 is trying to acquire lock:
ffff888013986498 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock
./include/linux/spinlock.h:363 [inline]
ffff888013986498 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock
./include/linux/netdevice.h:4405 [inline]
ffff888013986498 (_xmit_ETHER#2){+.-.}-{2:2}, at:
sch_direct_xmit+0x30f/0xc60 net/sched/sch_generic.c:340

but task is already holding lock:
ffff888013984898 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock
./include/linux/spinlock.h:363 [inline]
ffff888013984898 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock
./include/linux/netdevice.h:4405 [inline]
ffff888013984898 (_xmit_ETHER#2){+.-.}-{2:2}, at:
sch_direct_xmit+0x30f/0xc60 net/sched/sch_generic.c:340

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(_xmit_ETHER#2);
  lock(_xmit_ETHER#2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by syz-executor/9686:
 #0: ffffffff8b97e980 (rcu_read_lock_bh){....}-{1:2}, at:
lwtunnel_xmit_redirect ./include/net/lwtunnel.h:95 [inline]
 #0: ffffffff8b97e980 (rcu_read_lock_bh){....}-{1:2}, at:
ip_finish_output2+0x295/0x21e0 net/ipv4/ip_output.c:207
 #1: ffffffff8b97e980 (rcu_read_lock_bh){....}-{1:2}, at:
__dev_queue_xmit+0x1fc/0x3940 net/core/dev.c:4136
 #2: ffff888021cd5258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock
./include/linux/spinlock.h:373 [inline]
 #2: ffff888021cd5258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin
./include/net/sch_generic.h:173 [inline]
 #2: ffff888021cd5258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb
net/core/dev.c:3790 [inline]
 #2: ffff888021cd5258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x18bb/0x3940
net/core/dev.c:4170
 #3: ffff888013984898 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock
./include/linux/spinlock.h:363 [inline]
 #3: ffff888013984898 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock
./include/linux/netdevice.h:4405 [inline]
 #3: ffff888013984898 (_xmit_ETHER#2){+.-.}-{2:2}, at:
sch_direct_xmit+0x30f/0xc60 net/sched/sch_generic.c:340
 #4: ffffffff8b97e980 (rcu_read_lock_bh){....}-{1:2}, at:
lwtunnel_xmit_redirect ./include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8b97e980 (rcu_read_lock_bh){....}-{1:2}, at:
ip_finish_output2+0x295/0x21e0 net/ipv4/ip_output.c:207
 #5: ffffffff8b97e980 (rcu_read_lock_bh){....}-{1:2}, at:
__dev_queue_xmit+0x1fc/0x3940 net/core/dev.c:4136
 #6: ffff88810be44258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock
./include/linux/spinlock.h:373 [inline]
 #6: ffff88810be44258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin
./include/net/sch_generic.h:173 [inline]
 #6: ffff88810be44258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb
net/core/dev.c:3790 [inline]
 #6: ffff88810be44258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x18bb/0x3940
net/core/dev.c:4170

stack backtrace:
CPU: 0 PID: 9686 Comm: syz-executor Not tainted 5.15.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x168/0x3c3 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
 __raw_spin_lock ./include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock ./include/linux/spinlock.h:363 [inline]
 __netif_tx_lock ./include/linux/netdevice.h:4405 [inline]
 sch_direct_xmit+0x30f/0xc60 net/sched/sch_generic.c:340
 __dev_xmit_skb net/core/dev.c:3803 [inline]
 __dev_queue_xmit+0x1b05/0x3940 net/core/dev.c:4170
 neigh_resolve_output net/core/neighbour.c:1492 [inline]
 neigh_resolve_output+0x52a/0x850 net/core/neighbour.c:1472
 neigh_output ./include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x873/0x21e0 net/ipv4/ip_output.c:221
 __ip_finish_output net/ipv4/ip_output.c:299 [inline]
 __ip_finish_output+0x856/0x1450 net/ipv4/ip_output.c:281
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:309
 NF_HOOK_COND ./include/linux/netfilter.h:296 [inline]
 ip_mc_output+0x268/0xec0 net/ipv4/ip_output.c:408
 dst_output ./include/net/dst.h:450 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x69d/0xa90 net/ipv4/ip_tunnel_core.c:82
 ip_tunnel_xmit+0xf79/0x2af0 net/ipv4/ip_tunnel.c:810
 erspan_xmit+0x513/0x2ad0 net/ipv4/ip_gre.c:712
 __netdev_start_xmit ./include/linux/netdevice.h:4988 [inline]
 netdev_start_xmit ./include/linux/netdevice.h:5002 [inline]
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x1ff/0x950 net/core/dev.c:3592
 sch_direct_xmit+0x19f/0xc60 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3803 [inline]
 __dev_queue_xmit+0x1b05/0x3940 net/core/dev.c:4170
 neigh_resolve_output net/core/neighbour.c:1492 [inline]
 neigh_resolve_output+0x52a/0x850 net/core/neighbour.c:1472
 neigh_output ./include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x873/0x21e0 net/ipv4/ip_output.c:221
 __ip_finish_output net/ipv4/ip_output.c:299 [inline]
 __ip_finish_output+0x856/0x1450 net/ipv4/ip_output.c:281
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:309
 NF_HOOK_COND ./include/linux/netfilter.h:296 [inline]
 ip_mc_output+0x268/0xec0 net/ipv4/ip_output.c:408
 dst_output ./include/net/dst.h:450 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 ip_send_skb+0x3e/0xe0 net/ipv4/ip_output.c:1555
 udp_send_skb.isra.0+0x6d2/0x11c0 net/ipv4/udp.c:966
 udp_sendmsg+0x1d86/0x2820 net/ipv4/udp.c:1253
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x331/0x810 net/socket.c:2409
 ___sys_sendmsg+0x100/0x170 net/socket.c:2463
 __sys_sendmmsg+0x195/0x470 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9c5d76cc4d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9c5acd4c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f9c5d8930a0 RCX: 00007f9c5d76cc4d
RDX: 000000000800001d RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007f9c5d7e5d80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9c5d8930a0
R13: 00007ffff72e0cbf R14: 00007ffff72e0e60 R15: 00007f9c5acd4dc0
