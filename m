Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B9D128C2D
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 02:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfLVBpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 20:45:11 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:45620 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfLVBpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 20:45:10 -0500
Received: by mail-io1-f72.google.com with SMTP id c23so8978142ioi.12
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 17:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sm4+wUXkTCs2OOGVPDQmx501pVx6yNRgLcoZ5Pu14A4=;
        b=r+lDEZNWdMRRk+VR87C/3aYtVlbxIx+5raY+gmuKRXXqC/deTF2ia76NqTpL8p2pye
         IOkZoB8qcRK3OyBgdAnGk20nKPQq+9D1Zng03E5e2khez4cZYfYettZhMnM4zdiZCPQE
         UfGf47MDH6thfU5uyNOW2yJDFWpilj6bmTYdv2fJsui8MPV+cA8b1Y/hSd7XUgu1zW5I
         SXFj25pGm7AdQFDi1efiUs5PLVUqaynSZtAARBQEGbsjLtKhBRjSkIjSmqdOHrBcNHaV
         PzK7LSKJ0BvVt+uxvg//HWAWSYNzsAUHFHPz/0xS4GfPpwBJieQEm7I0VM61//8cRmNN
         KCsg==
X-Gm-Message-State: APjAAAVLQu3YBzCvd2ytfmSGwVI/i/S5qy4Ih9X298hIUfn0hPvG9k9Y
        CwxvM/hG+Lnf1k5KFG4o2/LJ1W72WaMEzI3hi7MAhz8vRq06
X-Google-Smtp-Source: APXvYqygoTjVFuJd25kMYRH4C0iFAS6PHc6Nhy1XXiM0GWbRWTuOShGf7ZGDm7R8+z3qwRGDTTEPXcRUNie+0UQJK3BPVyCS+Yf/
MIME-Version: 1.0
X-Received: by 2002:a92:d151:: with SMTP id t17mr3292865ilg.175.1576979110007;
 Sat, 21 Dec 2019 17:45:10 -0800 (PST)
Date:   Sat, 21 Dec 2019 17:45:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab9d07059a410fae@google.com>
Subject: KASAN: use-after-free Read in asix_suspend
From:   syzbot <syzbot+514595412b80dc817633@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andreyknvl@google.com, davem@davemloft.net,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        swinslow@gmail.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tranmanphong@gmail.com, zhang.run@zte.com.cn
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ecdf2214 usb: gadget: add raw-gadget interface
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=1330a2c6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b06a019075333661
dashboard link: https://syzkaller.appspot.com/bug?extid=514595412b80dc817633
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108f9ac1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=152dc6c1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+514595412b80dc817633@syzkaller.appspotmail.com

usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
hub 1-1:0.138: bad descriptor, ignoring hub
hub: probe of 1-1:0.138 failed with error -5
asix 1-1:0.138 (unnamed net_device) (uninitialized): Failed to read MAC  
address: 0
asix 1-1:0.138 eth1: register 'asix' at usb-dummy_hcd.0-1, ASIX AX88172A  
USB 2.0 Ethernet, 76:16:76:e7:25:cd
==================================================================
BUG: KASAN: use-after-free in asix_suspend+0xb9/0xc0  
drivers/net/usb/asix_devices.c:617
Read of size 8 at addr ffff8881d1984288 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.5.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xef/0x16e lib/dump_stack.c:118
  print_address_description.constprop.0+0x16/0x200 mm/kasan/report.c:374
  __kasan_report.cold+0x37/0x7f mm/kasan/report.c:506
  kasan_report+0xe/0x20 mm/kasan/common.c:639
  asix_suspend+0xb9/0xc0 drivers/net/usb/asix_devices.c:617
  usb_suspend_interface drivers/usb/core/driver.c:1203 [inline]
  usb_suspend_both+0x260/0x7b0 drivers/usb/core/driver.c:1308
  usb_runtime_suspend+0x46/0x120 drivers/usb/core/driver.c:1846
  __rpm_callback+0x27e/0x3c0 drivers/base/power/runtime.c:357
  rpm_callback+0x105/0x230 drivers/base/power/runtime.c:484
  rpm_suspend+0x37a/0x1300 drivers/base/power/runtime.c:629
  __pm_runtime_suspend+0xbb/0x150 drivers/base/power/runtime.c:1048
  pm_runtime_put_sync_autosuspend include/linux/pm_runtime.h:252 [inline]
  usb_new_device.cold+0xaee/0xe79 drivers/usb/core/hub.c:2567
  hub_port_connect drivers/usb/core/hub.c:5184 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5324 [inline]
  port_event drivers/usb/core/hub.c:5470 [inline]
  hub_event+0x1e59/0x3860 drivers/usb/core/hub.c:5552
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2264
  worker_thread+0x96/0xe20 kernel/workqueue.c:2410
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 12:
  save_stack+0x1b/0x80 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:486
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:670 [inline]
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

Freed by task 12:
  save_stack+0x1b/0x80 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:335 [inline]
  __kasan_slab_free+0x129/0x170 mm/kasan/common.c:474
  slab_free_hook mm/slub.c:1425 [inline]
  slab_free_freelist_hook mm/slub.c:1458 [inline]
  slab_free mm/slub.c:3005 [inline]
  kfree+0xda/0x310 mm/slub.c:3957
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

The buggy address belongs to the object at ffff8881d1984280
  which belongs to the cache kmalloc-64 of size 64
The buggy address is located 8 bytes inside of
  64-byte region [ffff8881d1984280, ffff8881d19842c0)
The buggy address belongs to the page:
page:ffffea0007466100 refcount:1 mapcount:0 mapping:ffff8881da003180  
index:0x0
raw: 0200000000000200 ffffea00074c2100 0000000a0000000a ffff8881da003180
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8881d1984180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff8881d1984200: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> ffff8881d1984280: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                       ^
  ffff8881d1984300: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff8881d


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
