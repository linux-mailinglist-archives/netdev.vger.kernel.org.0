Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA09666CA01
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjAPQ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjAPQ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:57:51 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4821D34555
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:40:48 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id s2-20020a056e02216200b0030bc3be69e5so21470945ilv.20
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:40:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yKSVY9R0PyWFm6q5WbYUWAgUkoXMWUhechkQnutsCkM=;
        b=0BYzyo/TwyYGm6ewAo96YIdQgi3okqhGZt+zpIC68+Pe83v5zebbqDdHFiVXmmFiUX
         wnZ1HrAA/zLBg6yphl0WNommuyxXDw8utG1ZQggZ5NIFZHlNcnpv+PfoBT7mbJ+z8ea6
         1zZ9EEMYyUfbGBlsmdOmdq/LPc0612AUGU+3ww/Pe66RgitGm7BeFP2kFgYCytuLeMPW
         0ZarNOZf/sodQcHpiYQYCzuxkgYiu24pP3tXjcOIWhEfT3WtegsT5WcJUBTRQBpruLxx
         qJc7kXi+06Jz/xhDEdAkQDiSoMqRrj9ZI+w30Xep4bTkQ9Jv1ClddYZ4tGCZ8CminQec
         R4HQ==
X-Gm-Message-State: AFqh2koLUF2M+SNc4IRZlChmhgx0cJdCsVXb7zOKjm31ViOXo/2OLmHU
        on5ToWz05ex70WHT6wS2E5QZxTi22WmLeS9ZIlKzpnGEDyOi
X-Google-Smtp-Source: AMrXdXtYCbHxBReCTOYYE0cauQL7T2xdJy/mPts7o7ZzizVhX3hkCmgye1713awmFvtJXDx3XQ1+FbFvT0gWzeO7/lrrGDtWNVdW
MIME-Version: 1.0
X-Received: by 2002:a02:aa18:0:b0:39e:a033:90c with SMTP id
 r24-20020a02aa18000000b0039ea033090cmr2178992jam.254.1673887247286; Mon, 16
 Jan 2023 08:40:47 -0800 (PST)
Date:   Mon, 16 Jan 2023 08:40:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4c9d405f2643e01@google.com>
Subject: [syzbot] possible deadlock in br_multicast_rcv (3)
From:   syzbot <syzbot+d7b7f1412c02134efa6d@syzkaller.appspotmail.com>
To:     axboe@fb.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net, edumazet@google.com, hch@lst.de,
        ivecera@redhat.com, jiri@resnulli.us, kbusch@kernel.org,
        kuba@kernel.org, lengchao@huawei.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, llvm@lists.linux.dev,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        pabeni@redhat.com, razor@blackwall.org, roopa@nvidia.com,
        sagi@grimberg.me, syzkaller-bugs@googlegroups.com, trix@redhat.com
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

HEAD commit:    60d86034b14e Merge tag 'mlx5-updates-2023-01-10' of git://..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1745e1ce480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de2f853811ba4e08
dashboard link: https://syzkaller.appspot.com/bug?extid=d7b7f1412c02134efa6d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16aa9b6e480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16645fd6480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b5b394a217aa/disk-60d86034.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f129c2da4b3a/vmlinux-60d86034.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6dbc96a4303d/bzImage-60d86034.xz

The issue was bisected to:

commit dda3248e7fc306e0ce3612ae96bdd9a36e2ab04f
Author: Chao Leng <lengchao@huawei.com>
Date:   Thu Feb 4 07:55:11 2021 +0000

    nvme: introduce a nvme_host_path_error helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1564ba0e480000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1764ba0e480000
console output: https://syzkaller.appspot.com/x/log.txt?x=1364ba0e480000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d7b7f1412c02134efa6d@syzkaller.appspotmail.com
Fixes: dda3248e7fc3 ("nvme: introduce a nvme_host_path_error helper")

============================================
WARNING: possible recursive locking detected
6.2.0-rc2-syzkaller-00378-g60d86034b14e #0 Not tainted
--------------------------------------------
ksoftirqd/0/15 is trying to acquire lock:
ffff88814b52d338 (&br->multicast_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
ffff88814b52d338 (&br->multicast_lock){+.-.}-{2:2}, at: br_ip6_multicast_query net/bridge/br_multicast.c:3351 [inline]
ffff88814b52d338 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_ipv6_rcv net/bridge/br_multicast.c:3747 [inline]
ffff88814b52d338 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_rcv+0x2019/0x6830 net/bridge/br_multicast.c:3802

but task is already holding lock:
ffff88807ac21338 (&br->multicast_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
ffff88807ac21338 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_port_query_expired+0x61/0x360 net/bridge/br_multicast.c:1752

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&br->multicast_lock);
  lock(&br->multicast_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by ksoftirqd/0/15:
 #0: ffffc90000147c50 ((&pmctx->ip6_own_query.timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:31 [inline]
 #0: ffffc90000147c50 ((&pmctx->ip6_own_query.timer)){+.-.}-{0:0}, at: call_timer_fn+0xd4/0x7c0 kernel/time/timer.c:1690
 #1: ffff88807ac21338 (&br->multicast_lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:350 [inline]
 #1: ffff88807ac21338 (&br->multicast_lock){+.-.}-{2:2}, at: br_multicast_port_query_expired+0x61/0x360 net/bridge/br_multicast.c:1752
 #2: ffffffff8c791b20 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x237/0x3ba0 net/core/dev.c:4166
 #3: ffffffff8c791b20 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x237/0x3ba0 net/core/dev.c:4166
 #4: ffffffff8c791b80 (rcu_read_lock){....}-{1:2}, at: br_dev_xmit+0x4/0x1620 net/bridge/br_device.c:29

stack backtrace:
CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.2.0-rc2-syzkaller-00378-g60d86034b14e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2990 [inline]
 check_deadlock kernel/locking/lockdep.c:3033 [inline]
 validate_chain kernel/locking/lockdep.c:3818 [inline]
 __lock_acquire.cold+0x116/0x3a7 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:350 [inline]
 br_ip6_multicast_query net/bridge/br_multicast.c:3351 [inline]
 br_multicast_ipv6_rcv net/bridge/br_multicast.c:3747 [inline]
 br_multicast_rcv+0x2019/0x6830 net/bridge/br_multicast.c:3802
 br_dev_xmit+0x726/0x1620 net/bridge/br_device.c:89
 __netdev_start_xmit include/linux/netdevice.h:4865 [inline]
 netdev_start_xmit include/linux/netdevice.h:4879 [inline]
 xmit_one net/core/dev.c:3583 [inline]
 dev_hard_start_xmit+0x1c2/0x990 net/core/dev.c:3599
 __dev_queue_xmit+0x2cdf/0x3ba0 net/core/dev.c:4249
 dev_queue_xmit include/linux/netdevice.h:3035 [inline]
 vlan_dev_hard_start_xmit+0x1bc/0x5c0 net/8021q/vlan_dev.c:124
 __netdev_start_xmit include/linux/netdevice.h:4865 [inline]
 netdev_start_xmit include/linux/netdevice.h:4879 [inline]
 xmit_one net/core/dev.c:3583 [inline]
 dev_hard_start_xmit+0x1c2/0x990 net/core/dev.c:3599
 __dev_queue_xmit+0x2cdf/0x3ba0 net/core/dev.c:4249
 dev_queue_xmit include/linux/netdevice.h:3035 [inline]
 br_dev_queue_push_xmit+0x26e/0x740 net/bridge/br_forward.c:53
 NF_HOOK include/linux/netfilter.h:302 [inline]
 __br_multicast_send_query+0x11c6/0x3b70 net/bridge/br_multicast.c:1656
 br_multicast_send_query+0x266/0x4b0 net/bridge/br_multicast.c:1735
 br_multicast_port_query_expired+0x2c3/0x360 net/bridge/br_multicast.c:1760
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1700
 expire_timers+0x2c6/0x5c0 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571
 run_ksoftirqd kernel/softirq.c:934 [inline]
 run_ksoftirqd+0x31/0x60 kernel/softirq.c:926
 smpboot_thread_fn+0x659/0xa20 kernel/smpboot.c:164
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
