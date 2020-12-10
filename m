Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E312D5CBB
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 15:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389832AbgLJOEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:04:01 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:46219 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389823AbgLJODw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:03:52 -0500
Received: by mail-il1-f198.google.com with SMTP id q5so4473314ilc.13
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 06:03:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dCHnS+IGmE05QjPXrUbbLAFiydDVaiZOQybW0UvsNF8=;
        b=p2t8PJJHYvWiLSRWnLlX/WOAQ/J/E24VzPWJliXuRDAzmL+kTBVp3JMxskUwoeqc/I
         tA2xJVDYOhMLPTB4glS9tYrR1TKBK3T4cn5sv5HGiUR/GoYss+tPlHycNOMhAEZe6xx5
         WYJCnohQwLiLA1Ggwnjyx55/eyqWdkZN3E/R+ck+G24wSBQ6bI1ZTN5zM8BxnMhWZPJP
         6u0ToRuuClyD0bHSuKfBRx1GGVnS7XdCPXLwbFcm6vl0UMt+v+Pbe6k2/obwbPYkPaMI
         H2XNC3V7RK+5VmxlLKasqo2TkftnQv79Rz1d77QUW1kxmcyzDlJbvj7jbDRky5XMTa6q
         Arlw==
X-Gm-Message-State: AOAM532HkeFm1JmOSG/ecNLzJSekmfC2hkUo7XU/2YTPWqut9fQR3ITi
        dc2Fx6CB4shQHoOb5/FJg7qmm+4vbQVcRperEVoTX9Vkm+mT
X-Google-Smtp-Source: ABdhPJzNhswceQ5PwLWQ9ylc/ytFQpeq987bYUGnEeJ6q1oS7R5eKN3G8ahRRjFS9lFelXt+dL91xjXPU/7vxgtm3PWnXeJNVVeU
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2110:: with SMTP id x16mr7176336iox.127.1607608991438;
 Thu, 10 Dec 2020 06:03:11 -0800 (PST)
Date:   Thu, 10 Dec 2020 06:03:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df5ecf05b61ca23b@google.com>
Subject: possible deadlock in zd_chip_disable_rxtx
From:   syzbot <syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, davem@davemloft.net, dsd@gentoo.org,
        kuba@kernel.org, kune@deine-taler.de, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8010622c USB: UAS: introduce a quirk to set no_write_same
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=131e6adf500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d24ee9ecd7ce968e
dashboard link: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13d7246b500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172c240f500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com

usb 1-1: reset high-speed USB device number 2 using dummy_hcd
usb 1-1: device descriptor read/64, error -71
usb 1-1: Using ep0 maxpacket: 32
usb 1-1: unable to get BOS descriptor or descriptor too short
zd1211rw 1-1:5.118: phy1
zd1211rw 1-1:5.114: error ioread32(CR_REG1): -11
============================================
WARNING: possible recursive locking detected
5.10.0-rc7-syzkaller #0 Not tainted
--------------------------------------------
kworker/1:2/2618 is trying to acquire lock:
ffff888102cbdd10 (&chip->mutex){+.+.}-{3:3}, at: zd_chip_disable_rxtx+0x1c/0x40 drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465

but task is already holding lock:
ffff888101d9dd10 (&chip->mutex){+.+.}-{3:3}, at: pre_reset+0x217/0x290 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1504

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&chip->mutex);
  lock(&chip->mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by kworker/1:2/2618:
 #0: ffff888103bff538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888103bff538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888103bff538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888103bff538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888103bff538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888103bff538 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x821/0x1520 kernel/workqueue.c:2243
 #1: ffffc900001c7da8 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x854/0x1520 kernel/workqueue.c:2247
 #2: ffff88810802a218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #2: ffff88810802a218 (&dev->mutex){....}-{3:3}, at: hub_event+0x1c5/0x42d0 drivers/usb/core/hub.c:5537
 #3: ffff8881013cd218 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #3: ffff8881013cd218 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
 #4: ffff88810ed8c1a8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:731 [inline]
 #4: ffff88810ed8c1a8 (&dev->mutex){....}-{3:3}, at: __device_attach+0x7a/0x4a0 drivers/base/dd.c:887
 #5: ffff888101d9dd10 (&chip->mutex){+.+.}-{3:3}, at: pre_reset+0x217/0x290 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1504

stack backtrace:
CPU: 1 PID: 2618 Comm: kworker/1:2 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2761 [inline]
 check_deadlock kernel/locking/lockdep.c:2804 [inline]
 validate_chain kernel/locking/lockdep.c:3595 [inline]
 __lock_acquire.cold+0x15e/0x3b0 kernel/locking/lockdep.c:4832
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x288/0x700 kernel/locking/lockdep.c:5402
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x10a0 kernel/locking/mutex.c:1103
 zd_chip_disable_rxtx+0x1c/0x40 drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465
 zd_op_stop+0x60/0x190 drivers/net/wireless/zydas/zd1211rw/zd_mac.c:343
 zd_usb_stop drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1479 [inline]
 pre_reset+0x19d/0x290 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1502
 usb_reset_device+0x379/0x9a0 drivers/usb/core/hub.c:5959
 probe+0x10f/0x590 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1371
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 usb_set_configuration+0x113c/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xde0 drivers/base/dd.c:554
 driver_probe_device+0x26b/0x3d0 drivers/base/dd.c:738
 __device_attach_driver+0x1d1/0x290 drivers/base/dd.c:844
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4a0 drivers/base/dd.c:912
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbb2/0x1ce0 drivers/base/core.c:2936
 usb_new_device.cold+0x71d/0xfe9 drivers/usb/core/hub.c:2555
 hub_port_connect drivers/usb/core/hub.c:5223 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5363 [inline]
 port_event drivers/usb/core/hub.c:5509 [inline]
 hub_event+0x2348/0x42d0 drivers/usb/core/hub.c:5591
 process_one_work+0x933/0x1520 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
zd1211rw 1-1:5.118: error ioread32(CR_REG1): -11
usb 1-1: reset high-speed USB device number 2 using dummy_hcd
usb 1-1: Using ep0 maxpacket: 32
usb 1-1: unable to get BOS descriptor or descriptor too short
ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
zd1211rw 1-1:5.57: phy2


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
