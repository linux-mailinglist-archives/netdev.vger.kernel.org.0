Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8341A4F7F
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 13:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgDKLJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 07:09:13 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36831 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgDKLJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 07:09:13 -0400
Received: by mail-il1-f197.google.com with SMTP id e5so5025167ilg.3
        for <netdev@vger.kernel.org>; Sat, 11 Apr 2020 04:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZKqkKshdGEkt/3Yxs52uQA/cTeUPVNrJo21GVj08594=;
        b=B0KpqQPPHoX1Fhr7mRP3Bi4BTrVHNdIX0pc+wrGntUuQEEBc7vehS5kkxjHUP01gGw
         bDcviPZtxK/V5yE2yWtLETKlTgmZKHTRxGfx0QtQrQiGdB3To5yUIbs4GfwoaLj8lSAC
         MiXn9JhK3aCJg8gqvjRfRW+Wj13WfcHRCb7rrKyMr7CsK9LtxZRBR+KL2ie0XqQ7irFe
         FrhUWFeyZQ7Hxgvee79mXnoejzixHc+4INguNQCa5YB0O8NckSFyicmIFGqiUCRTL0n8
         zvYPHrDdb8CoLgfJCbZC/dSQ8cW0OyCmGlU2V1vCmZhHURfr/2PYjpJiAdasEQPfy0cc
         ijKA==
X-Gm-Message-State: AGi0PubtrJ1aiqA34e2rA4bmKjM+T6Ad8f7DpWhLjJ4vfz0C80Hn+JQx
        3NgdkIpy7VAGxAOO0CQtiSqR9x8R45uW/Y003OOZJDRipFr6
X-Google-Smtp-Source: APiQypJBVyDYo+1JXCWO0fvjWsORi6tIgTf/TbJw7VxKhJxlMdEr5AGwrH2ayhYPdC/PHEsrPH/kuJCkpAXiuLodt1dxue/5YpFU
MIME-Version: 1.0
X-Received: by 2002:a92:250e:: with SMTP id l14mr9114611ill.201.1586603352271;
 Sat, 11 Apr 2020 04:09:12 -0700 (PDT)
Date:   Sat, 11 Apr 2020 04:09:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000036317b05a301e1e4@google.com>
Subject: KASAN: use-after-free Read in ath9k_htc_txcompletion_cb
From:   syzbot <syzbot+809d3bdcdb4650cdbc83@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=10af83b3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6b9c154b0c23aecf
dashboard link: https://syzkaller.appspot.com/bug?extid=809d3bdcdb4650cdbc83
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+809d3bdcdb4650cdbc83@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ath9k_htc_txcompletion_cb+0x285/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:341
Read of size 8 at addr ffff8881d1caf488 by task kworker/0:0/24267

CPU: 0 PID: 24267 Comm: kworker/0:0 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 ath9k_htc_txcompletion_cb+0x285/0x2b0 drivers/net/wireless/ath/ath9k/htc_hst.c:341
 hif_usb_regout_cb+0x10b/0x1b0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:console_unlock+0xa6b/0xca0 kernel/printk/printk.c:2481
Code: 00 89 ee 48 c7 c7 60 3e 14 87 e8 10 c3 03 00 65 ff 0d c1 ed d8 7e e9 b5 f9 ff ff e8 0f 37 16 00 e8 0a 7f 1b 00 ff 74 24 30 9d <e9> fd fd ff ff e8 fb 36 16 00 48 8d 7d 08 48 89 f8 48 c1 e8 03 42
RSP: 0018:ffff8881d9227a50 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: 0000000000000200 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8881aba6d1cc
RBP: 0000000000000000 R08: ffff8881aba6c980 R09: fffffbfff1266485
R10: fffffbfff1266484 R11: ffffffff89332427 R12: ffffffff82a092b0
R13: ffffffff874d3950 R14: 0000000000000057 R15: dffffc0000000000
 vprintk_emit+0x171/0x3d0 kernel/printk/printk.c:1996
 vprintk_func+0x75/0x113 kernel/printk/printk_safe.c:386
 printk+0xba/0xed kernel/printk/printk.c:2056
 ath9k_htc_hw_init.cold+0x17/0x2a drivers/net/wireless/ath/ath9k/htc_hst.c:502
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 24267:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slub.c:2786 [inline]
 kmem_cache_alloc_node+0xdc/0x330 mm/slub.c:2822
 __alloc_skb+0xba/0x5a0 net/core/skbuff.c:198
 alloc_skb include/linux/skbuff.h:1081 [inline]
 htc_connect_service+0x2cc/0x840 drivers/net/wireless/ath/ath9k/htc_hst.c:257
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 24267:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3034 [inline]
 kmem_cache_free+0x9b/0x360 mm/slub.c:3050
 kfree_skbmem net/core/skbuff.c:622 [inline]
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:616
 __kfree_skb net/core/skbuff.c:679 [inline]
 kfree_skb net/core/skbuff.c:696 [inline]
 kfree_skb+0x102/0x3d0 net/core/skbuff.c:690
 htc_connect_service.cold+0xa9/0x109 drivers/net/wireless/ath/ath9k/htc_hst.c:282
 ath9k_wmi_connect+0xd2/0x1a0 drivers/net/wireless/ath/ath9k/wmi.c:265
 ath9k_init_htc_services.constprop.0+0xb4/0x650 drivers/net/wireless/ath/ath9k/htc_drv_init.c:146
 ath9k_htc_probe_device+0x25a/0x1d80 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x26b/0x500 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:976
 process_one_work+0x94b/0x1620 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8881d1caf3c0
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 200 bytes inside of
 224-byte region [ffff8881d1caf3c0, ffff8881d1caf4a0)
The buggy address belongs to the page:
page:ffffea0007472bc0 refcount:1 mapcount:0 mapping:ffff8881da16b400 index:0xffff8881d1caf280
flags: 0x200000000000200(slab)
raw: 0200000000000200 ffffea00074473c0 0000000900000009 ffff8881da16b400
raw: ffff8881d1caf280 00000000800c000b 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d1caf380: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881d1caf400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881d1caf480: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff8881d1caf500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d1caf580: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
