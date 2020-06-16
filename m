Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF11FAE50
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFPKo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:44:28 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:52689 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgFPKoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:44:20 -0400
Received: by mail-il1-f200.google.com with SMTP id v14so14167687ilo.19
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 03:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TTirQLEB1uKm+kf+MuUjGanaHGyND0bZszoGaQzfV1w=;
        b=HAzFvUU0P10KlLp3G8k89HogYK/GTI/cjVIcCJsMOjXwmSgLrqkH7IqZeyZunE+kCU
         nvAENRKqxSOCu2WtflMCobMNDC+jl5o/iMvcIsEePFxxfeIxmMgksFXBXq2VTyPDHtY0
         mV51d7ujAeED+/707LVhT92wjHb5xPf3T00Mrs0gkL/8+123Y8CajtsNLTxXXzf1m6Ec
         jOdjA3DBRJ/gUOlLa6jOr4fnuuRULfueaVHE2qao28Ax1eJc/p32CV1BejwpVveOPMGp
         X+Rt0gN1gkYq4hsiUC/8QZNx1idxuSStDzl1Z/l6meMX2tIcUELbPv/VPv/wgGqIciQJ
         ggoA==
X-Gm-Message-State: AOAM533lETcMq6uz6/WK2RfkSEXJPbt9OdWCTmiB3bBfypar2itpmRHh
        i9frll6ZvZ9bhAw9Xm0WFl0A6vTr/KZeXEexgwj67SzvpFwc
X-Google-Smtp-Source: ABdhPJzUYLZRqL93VVykPjXPJDn+8rtTsskpGSAuekJ7vVLTVB3HbTQWFJI6xBTSTTkDBVJtE5zbSq+6J4fDhBuwSBOqVh/WNpUp
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13ee:: with SMTP id w14mr2281057ilj.190.1592304257429;
 Tue, 16 Jun 2020 03:44:17 -0700 (PDT)
Date:   Tue, 16 Jun 2020 03:44:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a376c105a8313901@google.com>
Subject: KASAN: use-after-free Read in __smsc95xx_mdio_read
From:   syzbot <syzbot+a7ebdb01bb2cc165cab6@syzkaller.appspotmail.com>
To:     UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f83346100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=a7ebdb01bb2cc165cab6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17046c66100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a8a3e100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a7ebdb01bb2cc165cab6@syzkaller.appspotmail.com

smsc95xx 1-1:1.0 eth6: Failed to read reg index 0x00000114: -19
smsc95xx 1-1:1.0 eth6 (unregistering): Error reading MII_ACCESS
smsc95xx 1-1:1.0 eth6 (unregistered): MII is busy in smsc95xx_mdio_read
==================================================================
BUG: KASAN: use-after-free in atomic64_read include/asm-generic/atomic-instrumented.h:836 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/asm-generic/atomic-long.h:28 [inline]
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x8e/0x660 kernel/locking/mutex.c:1237
Read of size 8 at addr ffff888094310c38 by task kworker/0:4/6949

CPU: 0 PID: 6949 Comm: kworker/0:4 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events check_carrier
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:192
 atomic64_read include/asm-generic/atomic-instrumented.h:836 [inline]
 atomic_long_read include/asm-generic/atomic-long.h:28 [inline]
 __mutex_unlock_slowpath+0x8e/0x660 kernel/locking/mutex.c:1237
 __smsc95xx_mdio_read+0x1bc/0x210 drivers/net/usb/smsc95xx.c:217
 smsc95xx_mdio_read drivers/net/usb/smsc95xx.c:278 [inline]
 check_carrier+0xf3/0x1d0 drivers/net/usb/smsc95xx.c:644
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

Allocated by task 6949:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0xb4/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:752 [inline]
 kvzalloc include/linux/mm.h:760 [inline]
 alloc_netdev_mqs+0x97/0xdc0 net/core/dev.c:9927
 usbnet_probe+0x159/0x2600 drivers/net/usb/usbnet.c:1686
 usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:374
 really_probe+0x281/0x6d0 drivers/base/dd.c:520
 driver_probe_device+0x104/0x210 drivers/base/dd.c:697
 __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:804
 bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:431
 __device_attach+0x21a/0x360 drivers/base/dd.c:870
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0x132d/0x1c10 drivers/base/core.c:2557
 usb_set_configuration+0xec5/0x1740 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0x9d/0xe0 drivers/usb/core/generic.c:241
 usb_probe_device+0xc6/0x1f0 drivers/usb/core/driver.c:272
 really_probe+0x281/0x6d0 drivers/base/dd.c:520
 driver_probe_device+0x104/0x210 drivers/base/dd.c:697
 __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:804
 bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:431
 __device_attach+0x21a/0x360 drivers/base/dd.c:870
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0x132d/0x1c10 drivers/base/core.c:2557
 usb_new_device.cold+0x753/0x103d drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5208 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x1eca/0x38f0 drivers/usb/core/hub.c:5576
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

Freed by task 6849:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 kvfree+0x42/0x50 mm/util.c:603
 device_release+0x71/0x200 drivers/base/core.c:1394
 kobject_cleanup lib/kobject.c:693 [inline]
 kobject_release lib/kobject.c:722 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1e7/0x2e0 lib/kobject.c:739
 put_device+0x1b/0x30 drivers/base/core.c:2656
 free_netdev+0x380/0x4a0 net/core/dev.c:10047
 usbnet_disconnect+0x1fb/0x270 drivers/net/usb/usbnet.c:1625
 usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:436
 __device_release_driver drivers/base/dd.c:1110 [inline]
 device_release_driver_internal+0x432/0x500 drivers/base/dd.c:1141
 bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:533
 device_del+0x481/0xd30 drivers/base/core.c:2734
 usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1245
 usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2217
 hub_port_connect drivers/usb/core/hub.c:5059 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5348 [inline]
 port_event drivers/usb/core/hub.c:5494 [inline]
 hub_event+0x17ca/0x38f0 drivers/usb/core/hub.c:5576
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

The buggy address belongs to the object at ffff888094310000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 3128 bytes inside of
 8192-byte region [ffff888094310000, ffff888094312000)
The buggy address belongs to the page:
page:ffffea000250c400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea000250c400 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0002257808 ffffea0002548608 ffff8880aa0021c0
raw: 0000000000000000 ffff888094310000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888094310b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094310b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888094310c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888094310c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888094310d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
