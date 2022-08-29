Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5695A4371
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 08:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiH2G4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 02:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiH2Gzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 02:55:52 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE7205D0;
        Sun, 28 Aug 2022 23:55:47 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-340f82c77baso57262107b3.1;
        Sun, 28 Aug 2022 23:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=FrQoNOR9QZYEUxwQ9sVh4rnQ2hW0acXt8Q3wdMBtrSI=;
        b=kQL0iCdMiyXQ00IMN3es4QU1mdNhsCLOMX2lw6aSIoJauHOlXTeJ7ER9sH7KqHMKt0
         ZzFufbG3cuMycusrQCuIT8A0A1uWoLgKsLKhASgNbhWwIMyEN9AqyUcgd0x6NV/YJeL3
         j2wUKF8aklRMSDKzqkSv8gjCKIWVaQtBzZJaLJ0PSkBOUkZFK3/wg4376FHUSowUlLGj
         6idQYBHXmRHJOabKnLtgLVRTh2dysH4Esvya81ew1TpBrh2q7RAggceT1eNSk75iTy4N
         Ba1fvA+Uzer/v+aKqjLzE+0UTp0X5/wfP2m2HywSBGtZyLhYCSKiUl3ssM5AnLGID0op
         mv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=FrQoNOR9QZYEUxwQ9sVh4rnQ2hW0acXt8Q3wdMBtrSI=;
        b=6BD1uRohkuxIBtSJQDAc1YzdY/4x5qJuJxOpCBnJQNhQ1o4Eckcww1flAIU3G68qwK
         X+qafZh3FfjKD5G7MXA49da+/H9jyAO48egDL1l4e4qxu5DP7RcQeSKMc4FSxvm5HAGw
         fSuVkCI6wY1tmc47w9VqvgqwppKyx0vO/5tLfVCJqmVrMlbKRnN0wSdVN3JeVC/6P56T
         rVsbAdAcuATX/x4+JPb+5DDPJuveY/oNRFMYew7ijTcfz7qbq2+S1S/3wYy0682k3f+Y
         co3NtUPCcuvSP3dPdxdv9m4eejyHRk6fKfcfXm3s3K3yzT8ieEZdF6fLYvXBl/NnCXfP
         F1SA==
X-Gm-Message-State: ACgBeo338JGKd7a5fY4A25pocs9KU/ohgayOQlhTxCH76/578A7/EbtV
        GJKa4Mgs7dMxmSS2eRTQ/FQ7nkY8SgIkNl/DrvVnK9S7Y3LlwDgpXHY=
X-Google-Smtp-Source: AA6agR4ROoElo4udeG5xjyiVHZKb8Ef1V3E92vU0Os6igqhf9IJ7X17aIPHilGpcC/+7ac7nOPlbQJO0rONX2m3ZFMw=
X-Received: by 2002:a05:6902:100b:b0:695:c64a:ab62 with SMTP id
 w11-20020a056902100b00b00695c64aab62mr8169480ybt.552.1661756146158; Sun, 28
 Aug 2022 23:55:46 -0700 (PDT)
MIME-Version: 1.0
From:   Jiacheng Xu <578001344xu@gmail.com>
Date:   Mon, 29 Aug 2022 14:55:35 +0800
Message-ID: <CAO4S-mcOn9_dCGRfBTw6oKPek1yHRyX43ZW+aZBYBucV-Wb2CQ@mail.gmail.com>
Subject: possible deadlock in sch_direct_xmit
To:     linux-kernel@vger.kernel.org,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        jiri@resnulli.us
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using modified Syzkaller to fuzz the Linux kernel-5.19, the
following crash was triggered.
We would appreciate a CVE ID if this is a security issue.

HEAD commit: 3d7cb6b04c3f Linux-5.19
git tree: upstream

console output:
https://drive.google.com/file/d/1ba6S6vbR1GdjkocR9Z14H5fAvrnXnc9T/view?usp=sharing
kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
syz repro: https://drive.google.com/file/d/1bz7Wga1bdlnlUrqfLi26IRGMoAqy6NAf/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1Qz_ChFTK3zJEssQ_CfgPGNTdgGHxVFOY/view?usp=sharing

Description:
When sending socket to device, HARD_TX_LOCK() in sch_direct_xmit() is
called to ensure only one CPU can execute it. However,
sch_direct_xmit() could be re-entrant through ops->ndo_start_xmit in
__netdev_start_xmit().
Such call stack is:

    ip_send_skb();
       HARD_TX_LOCK();
           sch_direct_xmit();
               __netdev_start_xmit();
                   ip_tunnel_xmit();
                      HARD_TX_LOCK();
                           sch_direct_xmit();

Environment:
Ubuntu 20.04 on Linux 5.4.0
QEMU 4.2.1:
qemu-system-x86_64 \
  -m 2G \
  -smp 2 \
  -kernel /home/workdir/bzImage \
  -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
  -drive file=/home/workdir/stretch.img,format=raw \
  -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
  -net nic,model=e1000 \
  -enable-kvm \
  -nographic \
  -pidfile vm.pid \
  2>&1 | tee vm.log

If you fix this issue, please add the following tag to the commit:
Reported-by Jiacheng Xu<578001344xu@gmail.com>

============================================
WARNING: possible recursive locking detected
5.19.0 #2 Not tainted
--------------------------------------------
syz-executor/7687 is trying to acquire lock:
ffff88810b142458 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock
include/linux/spinlock.h:349 [inline]
ffff88810b142458 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock
include/linux/netdevice.h:4256 [inline]
ffff88810b142458 (_xmit_ETHER#2){+.-.}-{2:2}, at:
sch_direct_xmit+0x318/0xc70 net/sched/sch_generic.c:340

but task is already holding lock:
ffff88801dba0cd8 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock
include/linux/spinlock.h:349 [inline]
ffff88801dba0cd8 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock
include/linux/netdevice.h:4256 [inline]
ffff88801dba0cd8 (_xmit_ETHER#2){+.-.}-{2:2}, at:
sch_direct_xmit+0x318/0xc70 net/sched/sch_generic.c:340

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(_xmit_ETHER#2);
  lock(_xmit_ETHER#2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by syz-executor/7687:
 #0: ffffffff8bd86e00 (rcu_read_lock_bh){....}-{1:2}, at:
lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #0: ffffffff8bd86e00 (rcu_read_lock_bh){....}-{1:2}, at:
ip_finish_output2+0x29b/0x2200 net/ipv4/ip_output.c:214
 #1: ffffffff8bd86e00 (rcu_read_lock_bh){....}-{1:2}, at:
__dev_queue_xmit+0x20a/0x3ad0 net/core/dev.c:4172
 #2: ffff88801abac258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock
include/linux/spinlock.h:359 [inline]
 #2: ffff88801abac258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin
include/net/sch_generic.h:187 [inline]
 #2: ffff88801abac258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin
include/net/sch_generic.h:184 [inline]
 #2: ffff88801abac258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb
net/core/dev.c:3804 [inline]
 #2: ffff88801abac258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x1384/0x3ad0
net/core/dev.c:4221
 #3: ffff88801dba0cd8 (_xmit_ETHER#2){+.-.}-{2:2}, at: spin_lock
include/linux/spinlock.h:349 [inline]
 #3: ffff88801dba0cd8 (_xmit_ETHER#2){+.-.}-{2:2}, at: __netif_tx_lock
include/linux/netdevice.h:4256 [inline]
 #3: ffff88801dba0cd8 (_xmit_ETHER#2){+.-.}-{2:2}, at:
sch_direct_xmit+0x318/0xc70 net/sched/sch_generic.c:340
 #4: ffffffff8bd86e00 (rcu_read_lock_bh){....}-{1:2}, at:
lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8bd86e00 (rcu_read_lock_bh){....}-{1:2}, at:
ip_finish_output2+0x29b/0x2200 net/ipv4/ip_output.c:214
 #5: ffffffff8bd86e00 (rcu_read_lock_bh){....}-{1:2}, at:
__dev_queue_xmit+0x20a/0x3ad0 net/core/dev.c:4172
 #6: ffff88810b772258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: spin_trylock
include/linux/spinlock.h:359 [inline]
 #6: ffff88810b772258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin
include/net/sch_generic.h:187 [inline]
 #6: ffff88810b772258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: qdisc_run_begin
include/net/sch_generic.h:184 [inline]
 #6: ffff88810b772258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_xmit_skb
net/core/dev.c:3804 [inline]
 #6: ffff88810b772258 (dev->qdisc_tx_busylock ?:
&qdisc_tx_busylock){+...}-{2:2}, at: __dev_queue_xmit+0x1384/0x3ad0
net/core/dev.c:4221

stack backtrace:
CPU: 0 PID: 7687 Comm: syz-executor Not tainted 5.19.0 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
 check_deadlock kernel/locking/lockdep.c:3031 [inline]
 validate_chain kernel/locking/lockdep.c:3816 [inline]
 __lock_acquire.cold+0x152/0x3ca kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5665 [inline]
 lock_acquire+0x1ab/0x580 kernel/locking/lockdep.c:5630
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:349 [inline]
 __netif_tx_lock include/linux/netdevice.h:4256 [inline]
 sch_direct_xmit+0x318/0xc70 net/sched/sch_generic.c:340
 __dev_xmit_skb net/core/dev.c:3817 [inline]
 __dev_queue_xmit+0x15c6/0x3ad0 net/core/dev.c:4221
 dev_queue_xmit include/linux/netdevice.h:2994 [inline]
 neigh_resolve_output net/core/neighbour.c:1528 [inline]
 neigh_resolve_output+0x53d/0x870 net/core/neighbour.c:1508
 neigh_output include/net/neighbour.h:549 [inline]
 ip_finish_output2+0x7ab/0x2200 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:306 [inline]
 __ip_finish_output+0x85c/0x1450 net/ipv4/ip_output.c:288
 ip_finish_output+0x32/0x280 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x20a/0x620 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x693/0xa80 net/ipv4/ip_tunnel_core.c:82
 ip_tunnel_xmit+0xff9/0x2c40 net/ipv4/ip_tunnel.c:811
 erspan_xmit+0x521/0x2b00 net/ipv4/ip_gre.c:715
 __netdev_start_xmit include/linux/netdevice.h:4805 [inline]
 netdev_start_xmit include/linux/netdevice.h:4819 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x19d/0x8b0 net/core/dev.c:3606
 sch_direct_xmit+0x19f/0xc70 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3817 [inline]
 __dev_queue_xmit+0x15c6/0x3ad0 net/core/dev.c:4221
 dev_queue_xmit include/linux/netdevice.h:2994 [inline]
 neigh_resolve_output net/core/neighbour.c:1528 [inline]
 neigh_resolve_output+0x53d/0x870 net/core/neighbour.c:1508
 neigh_output include/net/neighbour.h:549 [inline]
 ip_finish_output2+0x7ab/0x2200 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:306 [inline]
 __ip_finish_output+0x85c/0x1450 net/ipv4/ip_output.c:288
 ip_finish_output+0x32/0x280 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x20a/0x620 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:451 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 ip_send_skb+0x3e/0xe0 net/ipv4/ip_output.c:1571
 udp_send_skb.isra.0+0x731/0x1460 net/ipv4/udp.c:967
 udp_sendmsg+0x1dc3/0x2830 net/ipv4/udp.c:1254
 udpv6_sendmsg+0x1762/0x2bd0 net/ipv6/udp.c:1365
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:652
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 sock_sendmsg+0xc3/0x120 net/socket.c:729
 ____sys_sendmsg+0x334/0x810 net/socket.c:2488
 ___sys_sendmsg+0x100/0x170 net/socket.c:2542
 __sys_sendmmsg+0x195/0x470 net/socket.c:2628
 __do_sys_sendmmsg net/socket.c:2657 [inline]
 __se_sys_sendmmsg net/socket.c:2654 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2654
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f545b495dfd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f545c6afc58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f545b5bc0a0 RCX: 00007f545b495dfd
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00007f545b4ff4c1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000004000000 R11: 0000000000000246 R12: 00007f545b5bc0a0
R13: 00007fffca7bf54f R14: 00007fffca7bf6f0 R15: 00007f545c6afdc0
 </TASK>
