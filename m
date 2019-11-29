Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D4F10DABC
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 22:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfK2VFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 16:05:11 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:42975 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfK2VFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 16:05:11 -0500
Received: by mail-io1-f71.google.com with SMTP id p1so21101941ioo.9
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 13:05:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HRBN6HrxYoFZFgyjJ0Y/sNR1gbaNm2Kx7gw5Zi0YKu0=;
        b=CHCdgOuyLtTgCUfBX9XI42Mq9SxC7vK7EBCSTUdcQHP36JRifkS+d9/VzYO8Uz5X0m
         gZXFAONLRhLXmL/om5JjVxaFKj9VFjbo6Rr2M6oi7zqGNX9x0QU9Ae9WTasdtY3w+IaU
         NJEiIztCnLNFionPMcuCDtjfb1tMQaafzj2DxZ5y6VPcv+LZdGwl//4FNRw/c7C3i8SN
         WxPPB1h/cKScoCy2TZpCiwGSrHTcLs3MqcZOrf+2mntjhufdkBNxTBh1DjaS+HeIf47m
         C9q0ffnzctwX0YtFD6cGzhWA1KnEo4PaKicCsL6DUYNLmCvSTcn0j6RLK0W42Z7adJ8n
         wz2A==
X-Gm-Message-State: APjAAAXZ7S9TkI4C2AouVF9NJW1lmJHl/YV6cXKt/aKEgBUxV1zdiUCp
        8c4asgiW8RG4ZiQSgwCU4Dyqu+iEEZi7bnb2Ic2pTjlYd96c
X-Google-Smtp-Source: APXvYqz3zr2QVaGXkF9LleNtOT0E5GTt+RWUNboOhvJgzdKMrY9xBkU0oNHV3Clq3zhXJAb8vwijeMAHpiftEa0O7pKu842lGKbl
MIME-Version: 1.0
X-Received: by 2002:a92:da0a:: with SMTP id z10mr13290724ilm.286.1575061508869;
 Fri, 29 Nov 2019 13:05:08 -0800 (PST)
Date:   Fri, 29 Nov 2019 13:05:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc5697059882957f@google.com>
Subject: KASAN: use-after-free Read in ax88172a_unbind
From:   syzbot <syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andreyknvl@google.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    32b5e2b2 usb: gadget: add raw-gadget interface
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=12d808a6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d88612251f7691bd
dashboard link: https://syzkaller.appspot.com/bug?extid=4cd84f527bf4a10fc9c1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107034a2e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12da42dae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com

usb 1-1: USB disconnect, device number 2
asix 1-1:0.147 eth1: unregister 'asix' usb-dummy_hcd.0-1, ASIX AX88172A USB  
2.0 Ethernet
==================================================================
BUG: KASAN: use-after-free in ax88172a_remove_mdio  
drivers/net/usb/ax88172a.c:123 [inline]
BUG: KASAN: use-after-free in ax88172a_unbind+0x76/0xed  
drivers/net/usb/ax88172a.c:274
Read of size 8 at addr ffff8881d15e9100 by task kworker/0:2/102

CPU: 0 PID: 102 Comm: kworker/0:2 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xef/0x16e lib/dump_stack.c:118
  print_address_description.constprop.0+0x36/0x50 mm/kasan/report.c:374
  __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:506
  kasan_report+0xe/0x20 mm/kasan/common.c:634
  ax88172a_remove_mdio drivers/net/usb/ax88172a.c:123 [inline]
  ax88172a_unbind+0x76/0xed drivers/net/usb/ax88172a.c:274
  usbnet_disconnect+0x145/0x270 drivers/net/usb/usbnet.c:1618
  usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
  __device_release_driver drivers/base/dd.c:1134 [inline]
  device_release_driver_internal+0x42f/0x500 drivers/base/dd.c:1165
  bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:532
  device_del+0x481/0xd30 drivers/base/core.c:2664
  usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1237
  usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2200
  hub_port_connect drivers/usb/core/hub.c:5035 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
  port_event drivers/usb/core/hub.c:5470 [inline]
  hub_event+0x1753/0x3860 drivers/usb/core/hub.c:5552
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2264
  worker_thread+0x96/0xe20 kernel/workqueue.c:2410
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 83:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:483
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  ax88172a_bind+0x9f/0x7a2 drivers/net/usb/ax88172a.c:191
  usbnet_probe+0xb43/0x2470 drivers/net/usb/usbnet.c:1737
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0x1480/0x1c20 drivers/base/core.c:2487
  usb_set_configuration+0xe67/0x1740 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0x1480/0x1c20 drivers/base/core.c:2487
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2537
  hub_port_connect drivers/usb/core/hub.c:5184 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
  port_event drivers/usb/core/hub.c:5470 [inline]
  hub_event+0x1e59/0x3860 drivers/usb/core/hub.c:5552
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2264
  worker_thread+0x96/0xe20 kernel/workqueue.c:2410
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 83:
  save_stack+0x1b/0x80 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:471
  slab_free_hook mm/slub.c:1424 [inline]
  slab_free_freelist_hook mm/slub.c:1457 [inline]
  slab_free mm/slub.c:3004 [inline]
  kfree+0xdc/0x310 mm/slub.c:3956
  ax88172a_bind.cold+0x4d/0x1e8 drivers/net/usb/ax88172a.c:250
  usbnet_probe+0xb43/0x2470 drivers/net/usb/usbnet.c:1737
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0x1480/0x1c20 drivers/base/core.c:2487
  usb_set_configuration+0xe67/0x1740 drivers/usb/core/message.c:2023
  generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
  usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
  really_probe+0x281/0x6d0 drivers/base/dd.c:548
  driver_probe_device+0x104/0x210 drivers/base/dd.c:721
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
  bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:430
  __device_attach+0x217/0x360 drivers/base/dd.c:894
  bus_probe_device+0x1e4/0x290 drivers/base/bus.c:490
  device_add+0x1480/0x1c20 drivers/base/core.c:2487
  usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2537
  hub_port_connect drivers/usb/core/hub.c:5184 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
  port_event drivers/usb/core/hub.c:5470 [inline]
  hub_event+0x1e59/0x3860 drivers/usb/core/hub.c:5552
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2264
  worker_thread+0x96/0xe20 kernel/workqueue.c:2410
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d15e9100
  which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
  64-byte region [ffff8881d15e9100, ffff8881d15e9140)
The buggy address belongs to the page:
page:ffffea0007457a40 refcount:1 mapcount:0 mapping:ffff8881da003180  
index:0x0
raw: 0200000000000200 ffffea00074686c0 0000000d0000000d ffff8881da003180
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8881d15e9000: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff8881d15e9080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ffff8881d15e9100: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ffff8881d15e9180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff8881d15e9200: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
