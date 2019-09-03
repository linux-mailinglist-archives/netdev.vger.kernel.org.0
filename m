Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85533A683D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbfICMJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:09:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44461 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729082AbfICMIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 08:08:11 -0400
Received: by mail-io1-f72.google.com with SMTP id f5so22808277ioo.11
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 05:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t1xRn2tF6pZ4b6CqOkbk2xkmtY9gkP0++rOrzzJbaPQ=;
        b=Ce0rFN1lZGzAUvMsu5MH97727S7zvaqWHW1eFxZGVzzq/RD3l3AevzOjCrFDHqS2ab
         r/99ObMCfyh0o8TCeSQDLOQjnlm1gnzSSnhpqRRNKEu/xYtNUrB6XnjCLt2X2veOuBDN
         3sTuj7pFx2RecwWDBnoO7fn1/T0DsbebzY8E0IFfQgvKpAHwQxvEVPcTd+5tQhWicFAD
         2fJGnFZA+8YaMcdrQSHkL1qA5Yzad+ABtD7ZV47zTHqozg/S7xP01s4TJLhF1MPDQfY6
         UuTSQw6mLhUgW4TeTdWIu2Z2G233G8nALZFqZh0gjPmHKZoGclzjci8fGA4e8woK7lor
         Hk1A==
X-Gm-Message-State: APjAAAWzkReefI/C01WBD/qupv0RljCQzd8TA/2nkQ/RqsIqEqQrHnWP
        +hTd3uxsKoZ/Xs4OtCLgYqXSAyJkHiSG0X1FVQ0vnJvSbW5Y
X-Google-Smtp-Source: APXvYqwCRoZRNw+UNzUY+4tIjMtH2F3w1btOuFNX+K4uM86FL3B2l9k6sMAKL7nHtpFvbSq13kfIER/j1rwJmZoURKUsuIEbFjTJ
MIME-Version: 1.0
X-Received: by 2002:a6b:7002:: with SMTP id l2mr18362520ioc.300.1567512489801;
 Tue, 03 Sep 2019 05:08:09 -0700 (PDT)
Date:   Tue, 03 Sep 2019 05:08:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022c6e60591a4f15a@google.com>
Subject: KASAN: use-after-free Read in atusb_disconnect
From:   syzbot <syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    eea39f24 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=15c4eba6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d0c62209eedfd54e
dashboard link: https://syzkaller.appspot.com/bug?extid=f4509a9138a1472e7e80
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15486ab6600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15777f22600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com

usb 1-1: USB disconnect, device number 2
==================================================================
BUG: KASAN: use-after-free in atusb_disconnect+0x17f/0x1c0  
drivers/net/ieee802154/atusb.c:1143
Read of size 8 at addr ffff8881d53eee28 by task kworker/1:2/83

CPU: 1 PID: 83 Comm: kworker/1:2 Not tainted 5.3.0-rc5+ #28
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description+0x6a/0x32c mm/kasan/report.c:351
  __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:482
  kasan_report+0xe/0x12 mm/kasan/common.c:612
  atusb_disconnect+0x17f/0x1c0 drivers/net/ieee802154/atusb.c:1143
  usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
  __device_release_driver drivers/base/dd.c:1134 [inline]
  device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
  bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:556
  device_del+0x420/0xb10 drivers/base/core.c:2339
  usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1237
  usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2199
  hub_port_connect drivers/usb/core/hub.c:4949 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1454/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  worker_thread+0x96/0xe20 kernel/workqueue.c:2415
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 12:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:460
  kmalloc include/linux/slab.h:557 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  wpan_phy_new+0x22/0x290 net/ieee802154/core.c:109
  ieee802154_alloc_hw+0x11d/0x750 net/mac802154/main.c:77
  atusb_probe+0x9b/0xfa2 drivers/net/ieee802154/atusb.c:1023
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2165
  usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
  device_add+0xae6/0x16f0 drivers/base/core.c:2165
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  worker_thread+0x96/0xe20 kernel/workqueue.c:2415
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 83:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:449
  slab_free_hook mm/slub.c:1423 [inline]
  slab_free_freelist_hook mm/slub.c:1474 [inline]
  slab_free mm/slub.c:3016 [inline]
  kfree+0xe4/0x2f0 mm/slub.c:3957
  device_release+0x71/0x200 drivers/base/core.c:1064
  kobject_cleanup lib/kobject.c:693 [inline]
  kobject_release lib/kobject.c:722 [inline]
  kref_put include/linux/kref.h:65 [inline]
  kobject_put+0x171/0x280 lib/kobject.c:739
  put_device+0x1b/0x30 drivers/base/core.c:2264
  atusb_disconnect+0x117/0x1c0 drivers/net/ieee802154/atusb.c:1140
  usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
  __device_release_driver drivers/base/dd.c:1134 [inline]
  device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
  bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:556
  device_del+0x420/0xb10 drivers/base/core.c:2339
  usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1237
  usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2199
  hub_port_connect drivers/usb/core/hub.c:4949 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1454/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  worker_thread+0x96/0xe20 kernel/workqueue.c:2415
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d53ee600
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2088 bytes inside of
  4096-byte region [ffff8881d53ee600, ffff8881d53ef600)
The buggy address belongs to the page:
page:ffffea000754fa00 refcount:1 mapcount:0 mapping:ffff8881da00c280  
index:0x0 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 0000000000000000 0000000600000001 ffff8881da00c280
raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8881d53eed00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881d53eed80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8881d53eee00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                   ^
  ffff8881d53eee80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8881d53eef00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
