Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921C810CD86
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfK1RMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:12:43 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43813 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfK1RMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:12:43 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so6062576ljm.10;
        Thu, 28 Nov 2019 09:12:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iWW2ZcDODwAUymp6ztx4hP3KlmmBCjKrYn7BIp8rJzg=;
        b=uW57LEfEeQ8Z5rO95Czgf8YLvsiAFluhkhO4RLAQmY8eX/+5Ew/GWx5KIOK2ch9Mib
         vRxnJkKx5Mv/qDdGue4/x7rcUZ5t00FKcv9vg0y4Cdpw5Ams6peCdXHWOODZ3pnn20DZ
         xFHmfext/PirrLIpxSmS4EtrrqpAdVXKXHFHxuRKeQgysyCH91E/OSfQlIxBItRuAK0p
         v6QYHxMWuSED7UH12S1l1EsBTS2lGvfLlan9zLSDHXoD2ji63wDwazaQ5wQ4ZrxTEhBG
         /80k0Cv+OsIJZks6CaxkUcFO5/SersiA/dMFqU85LMIXM2dsKYs8tsIncKb2yiciPlGE
         rGnA==
X-Gm-Message-State: APjAAAUuSn68i5k9kXDqlcQb3y6sXnmE5tzEfEFVCbsNKQQadvk9kJOR
        ltJ/tAlN/2VaM3THFt1oZdo=
X-Google-Smtp-Source: APXvYqxOegesx9KBUAgxQaPXA9sDokynBRRqIx6G2EwZwZ7lu5RVruY5P6aWXHYDOfMFvDqLm3t9Gw==
X-Received: by 2002:a2e:5751:: with SMTP id r17mr4482911ljd.254.1574961158884;
        Thu, 28 Nov 2019 09:12:38 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id z17sm9015959ljz.30.2019.11.28.09.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:12:38 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iaNLK-0006rR-9P; Thu, 28 Nov 2019 18:12:38 +0100
Date:   Thu, 28 Nov 2019 18:12:38 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     syzbot <syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com>,
        amitkarwar@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        siva8118@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in rsi_rx_done_handler
Message-ID: <20191128171238.GC29518@localhost>
References: <0000000000003712560591a4f1b1@google.com>
 <CAAeHK+yTSrTwh77-eWBwPw=WnHFSJw-cvHtf-6cbYnj5KA2dyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+yTSrTwh77-eWBwPw=WnHFSJw-cvHtf-6cbYnj5KA2dyg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 02:38:26PM +0100, Andrey Konovalov wrote:
> On Tue, Sep 3, 2019 at 2:08 PM syzbot
> <syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    eea39f24 usb-fuzzer: main usb gadget fuzzer driver
> > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1031c5f2600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d0c62209eedfd54e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b563b7f8dbe8223a51e8
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in rsi_rx_done_handler+0x3ba/0x490
> > drivers/net/wireless/rsi/rsi_91x_usb.c:267
> > Read of size 8 at addr ffff8881cebc0fe8 by task kworker/0:2/102
> >
> > CPU: 0 PID: 102 Comm: kworker/0:2 Not tainted 5.3.0-rc5+ #28
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >   <IRQ>
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0xca/0x13e lib/dump_stack.c:113
> >   print_address_description+0x6a/0x32c mm/kasan/report.c:351
> >   __kasan_report.cold+0x1a/0x33 mm/kasan/report.c:482
> >   kasan_report+0xe/0x12 mm/kasan/common.c:612
> >   rsi_rx_done_handler+0x3ba/0x490 drivers/net/wireless/rsi/rsi_91x_usb.c:267
> >   __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1657
> >   usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1722
> >   dummy_timer+0x120f/0x2fa2 drivers/usb/gadget/udc/dummy_hcd.c:1965
> >   call_timer_fn+0x179/0x650 kernel/time/timer.c:1322
> >   expire_timers kernel/time/timer.c:1366 [inline]
> >   __run_timers kernel/time/timer.c:1685 [inline]
> >   __run_timers kernel/time/timer.c:1653 [inline]
> >   run_timer_softirq+0x5cc/0x14b0 kernel/time/timer.c:1698
> >   __do_softirq+0x221/0x912 kernel/softirq.c:292
> >   invoke_softirq kernel/softirq.c:373 [inline]
> >   irq_exit+0x178/0x1a0 kernel/softirq.c:413
> >   exiting_irq arch/x86/include/asm/apic.h:537 [inline]
> >   smp_apic_timer_interrupt+0x12f/0x500 arch/x86/kernel/apic/apic.c:1095
> >   apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
> >   </IRQ>
> > RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
> > RIP: 0010:console_unlock+0xa2a/0xc40 kernel/printk/printk.c:2471
> > Code: 00 89 ee 48 c7 c7 20 89 d3 86 e8 61 ad 03 00 65 ff 0d 72 b5 d9 7e e9
> > db f9 ff ff e8 80 a0 15 00 e8 2b ca 1a 00 ff 74 24 30 9d <e9> 18 fe ff ff
> > e8 6c a0 15 00 48 8d 7d 08 48 89 f8 48 c1 e8 03 42
> > RSP: 0018:ffff8881d5077200 EFLAGS: 00000216 ORIG_RAX: ffffffffffffff13
> > RAX: 0000000000000007 RBX: 0000000000000200 RCX: 0000000000000006
> > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8881d5068844
> > RBP: 0000000000000000 R08: ffff8881d5068000 R09: fffffbfff11ad791
> > R10: fffffbfff11ad790 R11: ffffffff88d6bc87 R12: 000000000000004d
> > R13: dffffc0000000000 R14: ffffffff829090d0 R15: ffffffff87077430
> >   vprintk_emit+0x171/0x3e0 kernel/printk/printk.c:1986
> >   vprintk_func+0x75/0x113 kernel/printk/printk_safe.c:386
> >   printk+0xba/0xed kernel/printk/printk.c:2046
> >   really_probe.cold+0x69/0x1f6 drivers/base/dd.c:628
> >   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
> >   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
> >   bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
> >   __device_attach+0x217/0x360 drivers/base/dd.c:894
> >   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
> >   device_add+0xae6/0x16f0 drivers/base/core.c:2165
> >   usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
> >   generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
> >   usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
> >   really_probe+0x281/0x6d0 drivers/base/dd.c:548
> >   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
> >   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
> >   bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
> >   __device_attach+0x217/0x360 drivers/base/dd.c:894
> >   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
> >   device_add+0xae6/0x16f0 drivers/base/core.c:2165
> >   usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
> >   hub_port_connect drivers/usb/core/hub.c:5098 [inline]
> >   hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
> >   port_event drivers/usb/core/hub.c:5359 [inline]
> >   hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
> >   process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
> >   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
> >   kthread+0x318/0x420 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> >
> > Allocated by task 102:
> >   save_stack+0x1b/0x80 mm/kasan/common.c:69
> >   set_track mm/kasan/common.c:77 [inline]
> >   __kasan_kmalloc mm/kasan/common.c:487 [inline]
> >   __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:460
> >   kmalloc include/linux/slab.h:552 [inline]
> >   kzalloc include/linux/slab.h:748 [inline]
> >   rsi_init_usb_interface drivers/net/wireless/rsi/rsi_91x_usb.c:599 [inline]
> >   rsi_probe+0x11a/0x15a0 drivers/net/wireless/rsi/rsi_91x_usb.c:780
> >   usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
> >   really_probe+0x281/0x6d0 drivers/base/dd.c:548
> >   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
> >   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
> >   bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
> >   __device_attach+0x217/0x360 drivers/base/dd.c:894
> >   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
> >   device_add+0xae6/0x16f0 drivers/base/core.c:2165
> >   usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
> >   generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
> >   usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
> >   really_probe+0x281/0x6d0 drivers/base/dd.c:548
> >   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
> >   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
> >   bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
> >   __device_attach+0x217/0x360 drivers/base/dd.c:894
> >   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
> >   device_add+0xae6/0x16f0 drivers/base/core.c:2165
> >   usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
> >   hub_port_connect drivers/usb/core/hub.c:5098 [inline]
> >   hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
> >   port_event drivers/usb/core/hub.c:5359 [inline]
> >   hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
> >   process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
> >   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
> >   kthread+0x318/0x420 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> >
> > Freed by task 102:
> >   save_stack+0x1b/0x80 mm/kasan/common.c:69
> >   set_track mm/kasan/common.c:77 [inline]
> >   __kasan_slab_free+0x130/0x180 mm/kasan/common.c:449
> >   slab_free_hook mm/slub.c:1423 [inline]
> >   slab_free_freelist_hook mm/slub.c:1474 [inline]
> >   slab_free mm/slub.c:3016 [inline]
> >   kfree+0xe4/0x2f0 mm/slub.c:3957
> >   rsi_91x_deinit+0x270/0x2f0 drivers/net/wireless/rsi/rsi_91x_main.c:407
> >   rsi_probe+0xcec/0x15a0 drivers/net/wireless/rsi/rsi_91x_usb.c:834
> >   usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
> >   really_probe+0x281/0x6d0 drivers/base/dd.c:548
> >   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
> >   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
> >   bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
> >   __device_attach+0x217/0x360 drivers/base/dd.c:894
> >   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
> >   device_add+0xae6/0x16f0 drivers/base/core.c:2165
> >   usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
> >   generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
> >   usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
> >   really_probe+0x281/0x6d0 drivers/base/dd.c:548
> >   driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
> >   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
> >   bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
> >   __device_attach+0x217/0x360 drivers/base/dd.c:894
> >   bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
> >   device_add+0xae6/0x16f0 drivers/base/core.c:2165
> >   usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
> >   hub_port_connect drivers/usb/core/hub.c:5098 [inline]
> >   hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
> >   port_event drivers/usb/core/hub.c:5359 [inline]
> >   hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
> >   process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
> >   worker_thread+0x96/0xe20 kernel/workqueue.c:2415
> >   kthread+0x318/0x420 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> >
> > The buggy address belongs to the object at ffff8881cebc0f00
> >   which belongs to the cache kmalloc-512 of size 512
> > The buggy address is located 232 bytes inside of
> >   512-byte region [ffff8881cebc0f00, ffff8881cebc1100)
> > The buggy address belongs to the page:
> > page:ffffea00073af000 refcount:1 mapcount:0 mapping:ffff8881da002500
> > index:0x0 compound_mapcount: 0
> > flags: 0x200000000010200(slab|head)
> > raw: 0200000000010200 0000000000000000 0000000b00000001 ffff8881da002500
> > raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
> > page dumped because: kasan: bad access detected
> >
> > Memory state around the buggy address:
> >   ffff8881cebc0e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >   ffff8881cebc0f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > ffff8881cebc0f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                                                            ^
> >   ffff8881cebc1000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff8881cebc1080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ==================================================================
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> Most likely the same issue as:
> 
> #syz dup: WARNING: ODEBUG bug in rsi_probe
> 
> https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f

Nope, this was also an independent bug. Will submit a fix shortly.

#syz undup

Johan
