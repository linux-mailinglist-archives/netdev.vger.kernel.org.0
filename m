Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7F6CE6B8
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfJGPJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:09:11 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:50493 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfJGPJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:09:08 -0400
Received: by mail-io1-f71.google.com with SMTP id f5so27126128iob.17
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 08:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mZ+MUmj5Y4NwRKu1oTpZySF67A1su90ulVRCdWT9+V4=;
        b=GgSKcqK4iatJCKz+ZZz1B2q1ka6+nhDXX1xryiXaNyoO9OZv2I4IkUPlrTDYh7a3uz
         4ifq5z1xSY+Qw+zR/h+p566r5HnEeg9yM4jsi/mlzRA0NpMQ88OLxsXhxDn+XCReoGMU
         abWtoAUH352yNG+XNQvvzw0Nbuhm2jK9FKiTsNq+gqXFmf1tUVKGHbnhluw8a4KDdztR
         WbJRTU3/p4spIsO+MpitaYISOArksUU2QARGW+DJuSGlLHKbFWPfGbA+iKuOo8+EvU2w
         cY1qKw9KG25KB8iGKkDErGBTUWsGJO4T0EhmWuT3yvs58zin/IyaU4ghFzPpHN6v63Li
         PHNw==
X-Gm-Message-State: APjAAAXVnvmPhyd5ziuZzUoBif9ayUt9ZLY08zF+nl3Y/xCq7ewLWaR2
        U9HdI0jYN/ngmLadADEBXmfmIYrURqr8jrTYqpJT4wrZYznj
X-Google-Smtp-Source: APXvYqwMNB1ZOWSO4vAI3skZ3eF86r8lwC0lJfcTfyHb0AyjwW/XTrkiA7TU4Xk0Jo72r3G3rD43MTzLiGFF9PxpDenGuj8f6p5H
MIME-Version: 1.0
X-Received: by 2002:a6b:2c97:: with SMTP id s145mr13659271ios.256.1570460948024;
 Mon, 07 Oct 2019 08:09:08 -0700 (PDT)
Date:   Mon, 07 Oct 2019 08:09:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0d74d0594536e2c@google.com>
Subject: KASAN: use-after-free Read in pn533_send_complete
From:   syzbot <syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andreyknvl@google.com,
        gregkh@linuxfoundation.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, opensource@jilayne.com, swinslow@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    58d5f26a usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=129c7463600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aa5dac3cda4ffd58
dashboard link: https://syzkaller.appspot.com/bug?extid=cb035c75c03dbe34b796
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101fb55d600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117f7885600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com

usb 1-1: NFC: Urb failure (status -71)
==================================================================
BUG: KASAN: use-after-free in pn533_send_complete.cold+0x47/0x6c  
drivers/nfc/pn533/usb.c:430
Read of size 8 at addr ffff8881d411fca8 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description.constprop.0+0x36/0x50 mm/kasan/report.c:374
  __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:506
  kasan_report+0xe/0x20 mm/kasan/common.c:634
  pn533_send_complete.cold+0x47/0x6c drivers/nfc/pn533/usb.c:430
  __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1654
  usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1719
  dummy_timer+0x120f/0x2fa2 drivers/usb/gadget/udc/dummy_hcd.c:1965
  call_timer_fn+0x179/0x650 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x5e3/0x1490 kernel/time/timer.c:1786
  __do_softirq+0x221/0x912 kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x178/0x1a0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x12f/0x500 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:default_idle+0x28/0x2e0 arch/x86/kernel/process.c:581
Code: 90 90 41 56 41 55 65 44 8b 2d 44 3a 8f 7a 41 54 55 53 0f 1f 44 00 00  
e8 36 ee d0 fb e9 07 00 00 00 0f 00 2d fa dd 4f 00 fb f4 <65> 44 8b 2d 20  
3a 8f 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffff8881da217dc8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881da1fb000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da1fb84c
RBP: ffffed103b43f600 R08: ffff8881da1fb000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x3b6/0x500 kernel/sched/idle.c:263
  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:355
  start_secondary+0x27d/0x330 arch/x86/kernel/smpboot.c:264
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

Allocated by task 22:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:483
  slab_post_alloc_hook mm/slab.h:584 [inline]
  slab_alloc_node mm/slub.c:2772 [inline]
  __kmalloc_node_track_caller+0xfc/0x3d0 mm/slub.c:4367
  alloc_dr drivers/base/devres.c:103 [inline]
  devm_kmalloc+0x87/0x190 drivers/base/devres.c:815
  devm_kzalloc include/linux/device.h:919 [inline]
  pn533_usb_probe+0x3b/0xd75 drivers/nfc/pn533/usb.c:461
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0xae6/0x16f0 drivers/base/core.c:2201
  usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0xae6/0x16f0 drivers/base/core.c:2201
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  worker_thread+0x96/0xe20 kernel/workqueue.c:2415
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 22:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:471
  slab_free_hook mm/slub.c:1424 [inline]
  slab_free_freelist_hook mm/slub.c:1475 [inline]
  slab_free mm/slub.c:3018 [inline]
  kfree+0xe4/0x2f0 mm/slub.c:3959
  release_nodes+0x4a1/0x910 drivers/base/devres.c:508
  devres_release_all+0x74/0xc3 drivers/base/devres.c:529
  really_probe+0x42f/0x6d0 drivers/base/dd.c:605
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0xae6/0x16f0 drivers/base/core.c:2201
  usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0xae6/0x16f0 drivers/base/core.c:2201
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  worker_thread+0x96/0xe20 kernel/workqueue.c:2415
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d411fc80
  which belongs to the cache kmalloc-96 of size 96
The buggy address is located 40 bytes inside of
  96-byte region [ffff8881d411fc80, ffff8881d411fce0)
The buggy address belongs to the page:
page:ffffea00075047c0 refcount:1 mapcount:0 mapping:ffff8881da002f00  
index:0x0
flags: 0x200000000000200(slab)
raw: 0200000000000200 ffffea000754b380 0000001500000015 ffff8881da002f00
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8881d411fb80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
  ffff8881d411fc00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
> ffff8881d411fc80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                   ^
  ffff8881d411fd00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
  ffff8881d411fd80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
