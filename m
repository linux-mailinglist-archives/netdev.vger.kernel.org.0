Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302BF21E34C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGMWz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:55:28 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37223 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGMWzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:55:23 -0400
Received: by mail-io1-f69.google.com with SMTP id 63so9163635ioy.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 15:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jj1P8fWj+QmBL3oVWARuXgxqUpoC+v1KVkS2xZgmtoo=;
        b=F/7xMs48LRQwiPl0iqt8hsL2ebKNaOa5DzsPK46P09/JmN70UvWkziSKFFItbtCwjw
         rG3J7rsLKc9KmhDxEeArEvhq/VbiwkpMIjVFD2tnJ4DFuu9z9VbfDIYc0mD7gVp4UlMe
         SAEHPrk5vOtZgJE4IvRPSuInsDzphLpJRORkRyOy4SY+mL/SKnA4y6vAEcSQIkaioZUv
         6+RFCFDntoLo8w1Ni/aoYFUJRA7UBxdC63g1cGtn5IP99q1iLolFOcVoGQf+NyhkB0FX
         AgF5OM94yFP0TKNLi/eAB5k7ivnAKpMsLXwcKYMTm/pqo2I4T4HGHMGY42K2Aj+bk1oG
         spJQ==
X-Gm-Message-State: AOAM533uj32JiUOTtOpUdIYGTv3jZVJGJXdAs2ZWavR3ioE/ydFugnqg
        ziPXIj89PqaHjeVz3ct6mKtDZMHOIjvyqNimLkQhvb5zWwCU
X-Google-Smtp-Source: ABdhPJyLihBN/zrOc2+4DcQ75Lu3lXRHgDuni0saKo5qorRgL58EKUMvVYYpOi/K9c0EoAZ7agMwKX7nIyOyB7ALfV3d216GOxZM
MIME-Version: 1.0
X-Received: by 2002:a6b:640e:: with SMTP id t14mr2067545iog.39.1594680921636;
 Mon, 13 Jul 2020 15:55:21 -0700 (PDT)
Date:   Mon, 13 Jul 2020 15:55:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd436905aa5a9533@google.com>
Subject: KASAN: use-after-free Read in devlink_health_reporter_destroy
From:   syzbot <syzbot+dd0040db0d77d52f98a5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    71930d61 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c8d157100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c5bc87125719cf4
dashboard link: https://syzkaller.appspot.com/bug?extid=dd0040db0d77d52f98a5
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1421cd3f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ccfe4f100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dd0040db0d77d52f98a5@syzkaller.appspotmail.com

netdevsim netdevsim3 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
==================================================================
BUG: KASAN: use-after-free in devlink_health_reporter_destroy+0x184/0x1d0 net/core/devlink.c:5476
Read of size 8 at addr ffff88808ca11c20 by task kworker/u4:1/21

CPU: 1 PID: 21 Comm: kworker/u4:1 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 devlink_health_reporter_destroy+0x184/0x1d0 net/core/devlink.c:5476
 nsim_dev_health_exit+0x8b/0xe0 drivers/net/netdevsim/health.c:317
 nsim_dev_reload_destroy+0x132/0x1e0 drivers/net/netdevsim/dev.c:1134
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:712
 devlink_reload+0xc1/0x3a0 net/core/devlink.c:2952
 devlink_pernet_pre_exit+0xfb/0x190 net/core/devlink.c:9622
 ops_pre_exit_list net/core/net_namespace.c:176 [inline]
 cleanup_net+0x451/0xa00 net/core/net_namespace.c:591
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6819:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 __devlink_health_reporter_create+0x91/0x2f0 net/core/devlink.c:5359
 devlink_health_reporter_create+0xa1/0x1d0 net/core/devlink.c:5431
 nsim_dev_health_init+0x95/0x3a0 drivers/net/netdevsim/health.c:279
 nsim_dev_probe+0xada/0xf80 drivers/net/netdevsim/dev.c:1086
 really_probe+0x282/0x8a0 drivers/base/dd.c:525
 driver_probe_device+0xfe/0x1d0 drivers/base/dd.c:701
 __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:807
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x28d/0x3f0 drivers/base/dd.c:873
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xacf/0x1b00 drivers/base/core.c:2680
 nsim_bus_dev_new drivers/net/netdevsim/bus.c:336 [inline]
 new_device_store+0x374/0x5c0 drivers/net/netdevsim/bus.c:215
 bus_attr_store+0x72/0xa0 drivers/base/bus.c:122
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:138
 kernfs_fop_write+0x268/0x490 fs/kernfs/file.c:315
 vfs_write+0x2b0/0x6b0 fs/read_write.c:576
 ksys_write+0x12d/0x250 fs/read_write.c:631
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 21:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 devlink_health_reporter_free net/core/devlink.c:5449 [inline]
 devlink_health_reporter_put+0xb7/0xf0 net/core/devlink.c:5456
 __devlink_health_reporter_destroy net/core/devlink.c:5463 [inline]
 devlink_health_reporter_destroy+0x143/0x1d0 net/core/devlink.c:5475
 nsim_dev_health_exit+0x8b/0xe0 drivers/net/netdevsim/health.c:317
 nsim_dev_reload_destroy+0x132/0x1e0 drivers/net/netdevsim/dev.c:1134
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:712
 devlink_reload+0xc1/0x3a0 net/core/devlink.c:2952
 devlink_pernet_pre_exit+0xfb/0x190 net/core/devlink.c:9622
 ops_pre_exit_list net/core/net_namespace.c:176 [inline]
 cleanup_net+0x451/0xa00 net/core/net_namespace.c:591
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff88808ca11c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 32 bytes inside of
 512-byte region [ffff88808ca11c00, ffff88808ca11e00)
The buggy address belongs to the page:
page:ffffea0002328440 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88808ca11000
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00024ba648 ffffea0002a32788 ffff8880aa000a80
raw: ffff88808ca11000 ffff88808ca11000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808ca11b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88808ca11b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88808ca11c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff88808ca11c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808ca11d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
