Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCF57C56F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 16:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbfGaOzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 10:55:31 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36649 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388075AbfGaOza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 10:55:30 -0400
Received: by mail-lj1-f194.google.com with SMTP id i21so65928634ljj.3;
        Wed, 31 Jul 2019 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z+hRd98x5TV3xKbm4IgKfN0HNypL+IKEJ8fZRsTiix0=;
        b=fvVGLBSFsBeCBbnAFgMoGV4TPLTvo+6xoI2Hvax7N4ReE4xjlKMrgKGz/x44aYgJQQ
         HBNms7NhIT17yeS954cS+log+VeGl0T5OgofXv+MgCMI9r/lh97ZlpjO+jFKm4GgcrF1
         V4+FyBD0eB6oDNjWK+lgsjszwZmt55x092LDcZDdD/623SJ8sHXp8gJlV++eXfeMpOqA
         XmbQ+VwXFzzI8oxD4BzLq0znoqzisSSm9SNpO4BhfF5E/00R0O42uJN++S5kC0Ylb7P/
         lMTBwWCtQWrDxWdSurU1DYP4dDm3sonbWhsk0L6UA26lsQkqA9yfxlNIn97JfVqY9/JM
         htVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z+hRd98x5TV3xKbm4IgKfN0HNypL+IKEJ8fZRsTiix0=;
        b=M7ICN+Gc6Sxh/EzO5+UuPT9f61eRN8APndwAE+zBPdSyGjG1krqh3JrRWGGcdDL5zl
         N7tHO9ll4RNXJP7nPbBFrXFUuZavtVbYShkicwxVnQOkmXdK9muLecZZyzmtLQOI2eTB
         n8hJmnAUrwexkDc6C9MJXesFXX2r3N5K6GLd/tN6IPKj1y4dTNlM1fcFOu4p5JnsGWHA
         BXY1XkTzEnTY8tFWt1Ja7P02bYBsfERVwovkBH+1PT+JUJpw3Xl+Oo7uifX1Hz/NFsU3
         8RC/vvWwmh5KSmjSQ6a2sB/ds3G3hnO7AQ0S9KxMILOuPuwD/+3uYPc4k1Jjuz4hlNnK
         lIWw==
X-Gm-Message-State: APjAAAXxe5P3UNPbnje8HivpzTKhRDREk0XqYQSJStIQhyi5jLV/v1q2
        c33lDZn+ZtbGHtmh/ge+KQY=
X-Google-Smtp-Source: APXvYqzykQOfJKE2+s8Z9PdCeuLmIeuPmPCh8PdDa326fgulb9QTYSesVp7dRtsjEFi6EP9kH+9kIw==
X-Received: by 2002:a2e:8849:: with SMTP id z9mr25234956ljj.203.1564584927631;
        Wed, 31 Jul 2019 07:55:27 -0700 (PDT)
Received: from localhost.localdomain (77.241.141.68.bredband.3.dk. [77.241.141.68])
        by smtp.gmail.com with ESMTPSA id j7sm15647799lji.27.2019.07.31.07.55.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 07:55:27 -0700 (PDT)
From:   Tomas Bortoli <tomasbortoli@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        alexios.zavras@intel.com, tglx@linutronix.de, allison@lohutok.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com, Tomas Bortoli <tomasbortoli@gmail.com>
Subject: [PATCH] peak_usb: Fix info-leaks to USB devices
Date:   Wed, 31 Jul 2019 10:54:47 -0400
Message-Id: <20190731145447.29270-1-tomasbortoli@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uninitialized Kernel memory can leak to USB devices.

Fix by using kzalloc() instead of kmalloc() on the affected buffers.

Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Reported-by: syzbot+d6a5a1a3657b596ef132@syzkaller.appspotmail.com
Reported-by: syzbot+513e4d0985298538bf9b@syzkaller.appspotmail.com
---
Crash logs:
1.
BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x7ef/0x1f50 drivers/usb/core/urb.c:405
CPU: 0 PID: 3359 Comm: kworker/0:2 Not tainted 5.2.0-rc4+ #7
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x162/0x2d0 mm/kmsan/kmsan.c:611
 kmsan_internal_check_memory+0x974/0xa80 mm/kmsan/kmsan.c:705
 kmsan_handle_urb+0x28/0x40 mm/kmsan/kmsan_hooks.c:617
 usb_submit_urb+0x7ef/0x1f50 drivers/usb/core/urb.c:405
 usb_start_wait_urb+0x143/0x410 drivers/usb/core/message.c:58
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x49f/0x7f0 drivers/usb/core/message.c:156
 pcan_usb_pro_send_req+0x26b/0x3e0 drivers/net/can/usb/peak_usb/pcan_usb_pro.c:336
 pcan_usb_fd_drv_loaded drivers/net/can/usb/peak_usb/pcan_usb_fd.c:460 [inline]
 pcan_usb_fd_init+0x16ee/0x1900 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:885
 peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:809 [inline]
 peak_usb_probe+0x1416/0x1b20 drivers/net/can/usb/peak_usb/pcan_usb_core.c:907
 usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
 really_probe+0x1344/0x1d90 drivers/base/dd.c:513
 driver_probe_device+0x1ba/0x510 drivers/base/dd.c:670
 __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:777
 bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
 __device_attach+0x489/0x750 drivers/base/dd.c:843
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:890
2.
BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x7ef/0x1f50 /drivers/usb/core/urb.c:405
CPU: 1 PID: 3814 Comm: kworker/1:2 Not tainted 5.2.0+ #15
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack /lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 /lib/dump_stack.c:113
 kmsan_report+0x162/0x2d0 /mm/kmsan/kmsan_report.c:109
 kmsan_internal_check_memory+0x974/0xa80 /mm/kmsan/kmsan.c:551
 kmsan_handle_urb+0x28/0x40 /mm/kmsan/kmsan_hooks.c:621
 usb_submit_urb+0x7ef/0x1f50 /drivers/usb/core/urb.c:405
 usb_start_wait_urb+0x143/0x410 /drivers/usb/core/message.c:58
 usb_internal_control_msg /drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x49f/0x7f0 /drivers/usb/core/message.c:156
 pcan_usb_pro_send_req /drivers/net/can/usb/peak_usb/pcan_usb_pro.c:336 [inline]
 pcan_usb_pro_drv_loaded /drivers/net/can/usb/peak_usb/pcan_usb_pro.c:504 [inline]
 pcan_usb_pro_init+0x1319/0x1720 /drivers/net/can/usb/peak_usb/pcan_usb_pro.c:894
 peak_usb_create_dev /drivers/net/can/usb/peak_usb/pcan_usb_core.c:809 [inline]
 peak_usb_probe+0x1416/0x1b20 /drivers/net/can/usb/peak_usb/pcan_usb_core.c:907
 usb_probe_interface+0xd19/0x1310 /drivers/usb/core/driver.c:361
 really_probe+0x1344/0x1d90 /drivers/base/dd.c:513
 driver_probe_device+0x1ba/0x510 /drivers/base/dd.c:670
 __device_attach_driver+0x5b8/0x790 /drivers/base/dd.c:777
 bus_for_each_drv+0x28e/0x3b0 /drivers/base/bus.c:454
 __device_attach+0x489/0x750 /drivers/base/dd.c:843
 device_initial_probe+0x4a/0x60 /drivers/base/dd.c:890
 bus_probe_device+0x131/0x390 /drivers/base/bus.c:514
 device_add+0x25b5/0x2df0 /drivers/base/core.c:2111
 usb_set_configuration+0x309f/0x3710 /drivers/usb/core/message.c:2027
 generic_probe+0xe7/0x280 /drivers/usb/core/generic.c:210
 usb_probe_device+0x146/0x200 /drivers/usb/core/driver.c:266
 really_probe+0x1344/0x1d90 /drivers/base/dd.c:513
 driver_probe_device+0x1ba/0x510 /drivers/base/dd.c:670
 __device_attach_driver+0x5b8/0x790 /drivers/base/dd.c:777
 bus_for_each_drv+0x28e/0x3b0 /drivers/base/bus.c:454
 __device_attach+0x489/0x750 /drivers/base/dd.c:843
 device_initial_probe+0x4a/0x60 /drivers/base/dd.c:890
 bus_probe_device+0x131/0x390 /drivers/base/bus.c:514
 device_add+0x25b5/0x2df0 /drivers/base/core.c:2111
 usb_new_device+0x23e5/0x2fb0 /drivers/usb/core/hub.c:2534
 hub_port_connect /drivers/usb/core/hub.c:5089 [inline]
 hub_port_connect_change /drivers/usb/core/hub.c:5204 [inline]
 port_event /drivers/usb/core/hub.c:5350 [inline]
 hub_event+0x5853/0x7320 /drivers/usb/core/hub.c:5432
 process_one_work+0x1572/0x1f00 /kernel/workqueue.c:2269
 worker_thread+0x111b/0x2460 /kernel/workqueue.c:2415
 kthread+0x4b5/0x4f0 /kernel/kthread.c:256
 ret_from_fork+0x35/0x40 /arch/x86/entry/entry_64.S:355
Uninit was created at:
 kmsan_save_stack_with_flags /mm/kmsan/kmsan.c:187 [inline]
 kmsan_internal_poison_shadow+0x53/0xa0 /mm/kmsan/kmsan.c:146
 kmsan_slab_alloc+0xaa/0x120 /mm/kmsan/kmsan_hooks.c:175
 slab_alloc_node /mm/slub.c:2771 [inline]
 slab_alloc /mm/slub.c:2780 [inline]
 kmem_cache_alloc_trace+0x873/0xa50 /mm/slub.c:2797
 kmalloc /./include/linux/slab.h:547 [inline]
 pcan_usb_pro_drv_loaded /drivers/net/can/usb/peak_usb/pcan_usb_pro.c:497 [inline]
 pcan_usb_pro_init+0xe96/0x1720 /drivers/net/can/usb/peak_usb/pcan_usb_pro.c:894
 peak_usb_create_dev /drivers/net/can/usb/peak_usb/pcan_usb_core.c:809 [inline]
 peak_usb_probe+0x1416/0x1b20 /drivers/net/can/usb/peak_usb/pcan_usb_core.c:907
 usb_probe_interface+0xd19/0x1310 /drivers/usb/core/driver.c:361
 really_probe+0x1344/0x1d90 /drivers/base/dd.c:513
 driver_probe_device+0x1ba/0x510 /drivers/base/dd.c:670
 __device_attach_driver+0x5b8/0x790 /drivers/base/dd.c:777
 bus_for_each_drv+0x28e/0x3b0 /drivers/base/bus.c:454
 __device_attach+0x489/0x750 /drivers/base/dd.c:843
 device_initial_probe+0x4a/0x60 /drivers/base/dd.c:890
 bus_probe_device+0x131/0x390 /drivers/base/bus.c:514
 device_add+0x25b5/0x2df0 /drivers/base/core.c:2111
 usb_set_configuration+0x309f/0x3710 /drivers/usb/core/message.c:2027
 generic_probe+0xe7/0x280 /drivers/usb/core/generic.c:210
 usb_probe_device+0x146/0x200 /drivers/usb/core/driver.c:266
 really_probe+0x1344/0x1d90 /drivers/base/dd.c:513
 driver_probe_device+0x1ba/0x510 /drivers/base/dd.c:670
 __device_attach_driver+0x5b8/0x790 /drivers/base/dd.c:777
 bus_for_each_drv+0x28e/0x3b0 /drivers/base/bus.c:454
 __device_attach+0x489/0x750 /drivers/base/dd.c:843
 device_initial_probe+0x4a/0x60 /drivers/base/dd.c:890
 bus_probe_device+0x131/0x390 /drivers/base/bus.c:514
 device_add+0x25b5/0x2df0 /drivers/base/core.c:2111
 usb_new_device+0x23e5/0x2fb0 /drivers/usb/core/hub.c:2534
 hub_port_connect /drivers/usb/core/hub.c:5089 [inline]
 hub_port_connect_change /drivers/usb/core/hub.c:5204 [inline]
 port_event /drivers/usb/core/hub.c:5350 [inline]
 hub_event+0x5853/0x7320 /drivers/usb/core/hub.c:5432
 process_one_work+0x1572/0x1f00 /kernel/workqueue.c:2269
 worker_thread+0x111b/0x2460 /kernel/workqueue.c:2415
 kthread+0x4b5/0x4f0 /kernel/kthread.c:256
 ret_from_fork+0x35/0x40 /arch/x86/entry/entry_64.S:355
Bytes 2-15 of 16 are uninitialized
Memory access of size 16 starts at ffff8881030286e0
==================================================================

 drivers/net/can/usb/peak_usb/pcan_usb_fd.c  | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 34761c3a6286..47cc1ff5b88e 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -841,7 +841,7 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 			goto err_out;
 
 		/* allocate command buffer once for all for the interface */
-		pdev->cmd_buffer_addr = kmalloc(PCAN_UFD_CMD_BUFFER_SIZE,
+		pdev->cmd_buffer_addr = kzalloc(PCAN_UFD_CMD_BUFFER_SIZE,
 						GFP_KERNEL);
 		if (!pdev->cmd_buffer_addr)
 			goto err_out_1;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 178bb7cff0c1..53cb2f72bdd0 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -494,7 +494,7 @@ static int pcan_usb_pro_drv_loaded(struct peak_usb_device *dev, int loaded)
 	u8 *buffer;
 	int err;
 
-	buffer = kmalloc(PCAN_USBPRO_FCT_DRVLD_REQ_LEN, GFP_KERNEL);
+	buffer = kzalloc(PCAN_USBPRO_FCT_DRVLD_REQ_LEN, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-- 
2.11.0

