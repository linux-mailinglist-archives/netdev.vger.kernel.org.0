Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625C1D8212
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbfJOVWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 17:22:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:41286 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJOVWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 17:22:08 -0400
Received: by mail-io1-f69.google.com with SMTP id m25so16643557ioo.8
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 14:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bstYtC8Ri8tluUuq778xxN+KSS3XBV0G97whA8YKm8o=;
        b=pbFzNSJQBy2J0QG8vqJUfMILG0iq6Z9uEOx30l+vfQdqUA+go+JlktRPl9uA98qHAT
         JuzYTR0ALOeYNGVSfW7genRX4uTAhhukEmUISr8ikFNxQPk2tTTEOXXVAtJjBYs/c1v4
         qIyCTwOkN4fMZZSkMpF/RAyWtTbbobLfL28ai/hnYbImmeUc1OzzGMPk8/XaIGzxISAv
         Uxkd47SPx9CNNQWQdYK/2O654xUhia+5tYQs4xhPfp/HMTFUT2q3lMWil9SeE7C5TtR6
         pV6pMNpl1CY/i62oAC3hy5ftvA2YiSLZunioPkNkuhEux7DpjtxGWmcRLz0SDgSMj3P+
         7TvQ==
X-Gm-Message-State: APjAAAUaSzybFigr1qA15joZpf1VxlFrUBC0mfPZApHV/OBSocUqEnXC
        SNJXctR+LIqr/OP2Yg8YeSabUNfvHB4b7yu55Jmd+ncQHAFg
X-Google-Smtp-Source: APXvYqzAt6j2rF9D7TsrAleAUuKduSGEH6A8zW/VXkM+19DW2B+e8sFGeZCdtU4NXMIC5gFtbbMYJlXhUVbs/lmWzGxQ34KvI/f4
MIME-Version: 1.0
X-Received: by 2002:a92:9ecd:: with SMTP id s74mr8223352ilk.188.1571174527489;
 Tue, 15 Oct 2019 14:22:07 -0700 (PDT)
Date:   Tue, 15 Oct 2019 14:22:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009763320594f993ee@google.com>
Subject: KMSAN: uninit-value in asix_mdio_write
From:   syzbot <syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, gregkh@linuxfoundation.org,
        hslester96@gmail.com, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c2453450 kmsan: kcov: prettify the code unpoisoning area->..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1159ab53600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3684f3c73f43899a
dashboard link: https://syzkaller.appspot.com/bug?extid=7dc7c28d4577bbe55b10
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e7276f600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15609b30e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7dc7c28d4577bbe55b10@syzkaller.appspotmail.com

asix 1-1:0.145 (unnamed net_device) (uninitialized): Failed to enable  
software MII access
asix 1-1:0.145 (unnamed net_device) (uninitialized): Failed to read reg  
index 0x0000: -71
=====================================================
BUG: KMSAN: uninit-value in asix_mdio_write+0x3fa/0x8d0  
drivers/net/usb/asix_common.c:496
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x14a/0x2f0 mm/kmsan/kmsan_report.c:109
  __msan_warning+0x73/0xf0 mm/kmsan/kmsan_instr.c:245
  asix_mdio_write+0x3fa/0x8d0 drivers/net/usb/asix_common.c:496
  asix_phy_reset+0xd8/0x2d0 drivers/net/usb/asix_devices.c:208
  ax88172_bind+0x780/0xbd0 drivers/net/usb/asix_devices.c:272
  usbnet_probe+0x10d3/0x39d0 drivers/net/usb/usbnet.c:1730
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0xd91/0x1f90 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:721
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:828
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:430
  __device_attach+0x489/0x750 drivers/base/dd.c:894
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:941
  bus_probe_device+0x131/0x390 drivers/base/bus.c:490
  device_add+0x25b5/0x2df0 drivers/base/core.c:2201
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
  device_add+0x25b5/0x2df0 drivers/base/core.c:2201
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x581d/0x72f0 drivers/usb/core/hub.c:5441
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----smsr@asix_mdio_write
Variable was created at:
  asix_mdio_write+0xc7/0x8d0 drivers/net/usb/asix_common.c:480
  asix_mdio_write+0xc7/0x8d0 drivers/net/usb/asix_common.c:480
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
