Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713F7EA3F9
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfJ3TWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:22:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40869 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfJ3TWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:22:08 -0400
Received: by mail-io1-f69.google.com with SMTP id 125so2643532iou.7
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 12:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=khoGcAG7R6/Th/Ql7oDqglP9PTs7MZlRnfGjkI25LVM=;
        b=NHJhrT1BYYM8f+H8c+/IMSemX2wuZYv50wJ0tHL9nI1tVGTQeYt/FVGVePhDKMRLX7
         vKMR6sJK4HYz+NYt8LU84pqlYQuQ+fQNeSlsI9bCEq5MBLYcF40LVYZHZNYTMhpzmmR4
         ILroitamc96amAQe2MyY5JomzLiWtFvXeoU9Vg0eLa4uRPVxfrSYQvVQrs8MceYSiNSE
         0W2gidQdjQTtGVFipqrhRfXAQovMwtNDCP8ktACn0+9Fum3xo6RM+jqLeeNeYG0JzZpe
         ajeaLhgOAJCn/6lvvx31RxaTkWCpE3z2RJJqXxuvMNfubtuYFCxactFU2v+jxEJ6++hA
         bJrQ==
X-Gm-Message-State: APjAAAX0mKEvdQxzfBixuZTAtkuATryRGeNvQd6gyeN1gUZv4G9AgAjH
        wOre/TKPcrJEnrgP2hx+zEL0HztfT4FmUvkqpKFhyvRZplfT
X-Google-Smtp-Source: APXvYqz0jpZtYd1ylVPYuYGc+K+FpHCDQZ2CiqF98OVVfySYUsaC8liAfwZ5bVayIukFm/18+nLkIlbzusYaB3vapIrCF9sZ2TOJ
MIME-Version: 1.0
X-Received: by 2002:a5d:9059:: with SMTP id v25mr1343320ioq.58.1572463327820;
 Wed, 30 Oct 2019 12:22:07 -0700 (PDT)
Date:   Wed, 30 Oct 2019 12:22:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000013c4c1059625a655@google.com>
Subject: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    96c6c319 net: kasan: kmsan: support CONFIG_GENERIC_CSUM on..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11f103bce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
dashboard link: https://syzkaller.appspot.com/bug?extid=0631d878823ce2411636
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10dd9774e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13651a24e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0631d878823ce2411636@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in cdc_ncm_set_dgram_size+0x6ba/0xbc0  
drivers/net/usb/cdc_ncm.c:587
CPU: 0 PID: 11865 Comm: kworker/0:3 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:245
  cdc_ncm_set_dgram_size+0x6ba/0xbc0 drivers/net/usb/cdc_ncm.c:587
  cdc_ncm_setup drivers/net/usb/cdc_ncm.c:673 [inline]
  cdc_ncm_bind_common+0x2b54/0x3c50 drivers/net/usb/cdc_ncm.c:928
  cdc_ncm_bind+0x2de/0x330 drivers/net/usb/cdc_ncm.c:1042
  usbnet_probe+0x10d3/0x39d0 drivers/net/usb/usbnet.c:1730
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0xd91/0x1f90 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:721
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:828
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:430
  __device_attach+0x489/0x750 drivers/base/dd.c:894
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:941
  bus_probe_device+0x131/0x390 drivers/base/bus.c:490
  device_add+0x25b5/0x2df0 drivers/base/core.c:2202
  usb_set_configuration+0x309f/0x3710 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x146/0x200 drivers/usb/core/driver.c:266
  really_probe+0xd91/0x1f90 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:721
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:828
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:430
  __device_attach+0x489/0x750 drivers/base/dd.c:894
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:941
  bus_probe_device+0x131/0x390 drivers/base/bus.c:490
  device_add+0x25b5/0x2df0 drivers/base/core.c:2202
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x581d/0x72f0 drivers/usb/core/hub.c:5441
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x189c/0x2460 kernel/workqueue.c:2417
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----max_datagram_size@cdc_ncm_set_dgram_size
Variable was created at:
  cdc_ncm_set_dgram_size+0xf5/0xbc0 drivers/net/usb/cdc_ncm.c:564
  cdc_ncm_set_dgram_size+0xf5/0xbc0 drivers/net/usb/cdc_ncm.c:564
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
