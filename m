Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C80CEC97
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfJGTTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:19:11 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51537 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728530AbfJGTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 15:19:07 -0400
Received: by mail-io1-f70.google.com with SMTP id x13so28093326ioa.18
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 12:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kfIipKsUoU2wWE9hKOkjQ6E2PbPEy+2k66M2HMxGCeQ=;
        b=Oze5Zst2v/d2jh9IEC6hYQfBdpKGj4mxBaL1ZT25Tkwse1AnGgD6DHMVtXZzIV817x
         KFlTieD1la4GQj8jAkf6x84D9FWfQSUnxLdpfGivNXUcLJ/nbJfMYAiMHeLvDhYQ9Tui
         Gl7ubBkn265r/Ao6NXBB1V4daT3cEWQJVYr3QSfqScZzBzTlzw+lxzuTwwk6H5gRmoQS
         7iFpYIIGoWnXE4Q6A15nvc2OLxw2Pk8ITsmekO7IOEAxnbpmXuC00ryfQVzYMauDKTaQ
         Zh8gUqTb1lQsWVEb/e9J+4PH9V3v1yglxNTOVacwpekOZt8V6YParCuSDtSopsdVyi4E
         Ddgg==
X-Gm-Message-State: APjAAAUGgDms8Ui6a3fbeG1+RA8Ihz9AYtGRWCVhMmwD96UQPwfKolk/
        w77iCXawVcyylS0ZN7UCzqDu+LSOnUGL8SGp77nds0ihCObS
X-Google-Smtp-Source: APXvYqxmlQbrzZCsCgl3Aqez5p34MMznTpFGk54INHY3AxNOW/acF4gq6+pYak8SyVeux3NOkFMekxdJcgfbwGtHbQ6MFTOGVIwF
MIME-Version: 1.0
X-Received: by 2002:a6b:f319:: with SMTP id m25mr20397110ioh.33.1570475946432;
 Mon, 07 Oct 2019 12:19:06 -0700 (PDT)
Date:   Mon, 07 Oct 2019 12:19:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea6699059456ecc8@google.com>
Subject: KMSAN: uninit-value in asix_mdio_read
From:   syzbot <syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com>
To:     allison@lohutok.net, davem@davemloft.net, glider@google.com,
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

HEAD commit:    1e76a3e5 kmsan: replace __GFP_NO_KMSAN_SHADOW with kmsan_i..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10327cc3600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f03c659d0830ab8d
dashboard link: https://syzkaller.appspot.com/bug?extid=a631ec9e717fb0423053
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e9a3db600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167fcefb600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com

asix 1-1:0.78 (unnamed net_device) (uninitialized): Failed to write reg  
index 0x0000: -71
asix 1-1:0.78 (unnamed net_device) (uninitialized): Failed to send software  
reset: ffffffb9
asix 1-1:0.78 (unnamed net_device) (uninitialized): Failed to write reg  
index 0x0000: -71
asix 1-1:0.78 (unnamed net_device) (uninitialized): Failed to enable  
software MII access
asix 1-1:0.78 (unnamed net_device) (uninitialized): Failed to read reg  
index 0x0000: -71
=====================================================
BUG: KMSAN: uninit-value in asix_mdio_bus_read+0xbc/0xe0  
drivers/net/usb/ax88172a.c:31
CPU: 0 PID: 2919 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x13a/0x2b0 mm/kmsan/kmsan_report.c:108
  __msan_warning+0x73/0xe0 mm/kmsan/kmsan_instr.c:250
  asix_mdio_read+0x3e9/0x8f0 drivers/net/usb/asix_common.c:461
  asix_mdio_bus_read+0xbc/0xe0 drivers/net/usb/ax88172a.c:31
  __mdiobus_read+0x106/0x3d0 drivers/net/phy/mdio_bus.c:563
  mdiobus_read+0xbd/0x110 drivers/net/phy/mdio_bus.c:640
  get_phy_id drivers/net/phy/phy_device.c:785 [inline]
  get_phy_device+0x331/0x8a0 drivers/net/phy/phy_device.c:819
  mdiobus_scan+0x91/0x760 drivers/net/phy/mdio_bus.c:527
  __mdiobus_register+0x86d/0xca0 drivers/net/phy/mdio_bus.c:426
  ax88172a_init_mdio drivers/net/usb/ax88172a.c:105 [inline]
  ax88172a_bind+0xcc5/0xf80 drivers/net/usb/ax88172a.c:243
  usbnet_probe+0x10ae/0x3960 drivers/net/usb/usbnet.c:1722
  usb_probe_interface+0xd19/0x1310 drivers/usb/core/driver.c:361
  really_probe+0x1373/0x1dc0 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:709
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:816
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:882
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:929
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2165
  usb_set_configuration+0x309f/0x3710 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x146/0x200 drivers/usb/core/driver.c:266
  really_probe+0x1373/0x1dc0 drivers/base/dd.c:552
  driver_probe_device+0x1ba/0x510 drivers/base/dd.c:709
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:816
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x489/0x750 drivers/base/dd.c:882
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:929
  bus_probe_device+0x131/0x390 drivers/base/bus.c:514
  device_add+0x25b5/0x2df0 drivers/base/core.c:2165
  usb_new_device+0x23e5/0x2fb0 drivers/usb/core/hub.c:2536
  hub_port_connect drivers/usb/core/hub.c:5098 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x581d/0x72f0 drivers/usb/core/hub.c:5441
  process_one_work+0x1572/0x1ef0 kernel/workqueue.c:2269
  worker_thread+0x111b/0x2460 kernel/workqueue.c:2415
  kthread+0x4b5/0x4f0 kernel/kthread.c:256
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Local variable description: ----smsr@asix_mdio_read
Variable was created at:
  asix_mdio_read+0xa0/0x8f0 include/linux/netdevice.h:2180
  asix_mdio_bus_read+0xbc/0xe0 drivers/net/usb/ax88172a.c:31
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
