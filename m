Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078CC22445
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 19:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfERRgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 13:36:01 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:35721 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729342AbfERRgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 13:36:01 -0400
Received: by mail-it1-f199.google.com with SMTP id m188so9710740ita.0
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 10:36:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1CvcmZSlB35QHwFTvpa0OM2vzXbECFOPgO/fzHPp5Ac=;
        b=Xne79QqMb2Zj7fSANh6iYnjK4QQOjpJgqa30cVUfsq2w5fqIiFeS9c8niY9kX1lICC
         YOzBfNGOnrl/X8pNVHS4PCH6vDrc0zx7J6aVVcZKUNiI8h0MFSxNJeQ094fbJCnCTXVm
         NuK4g6730g1X1AsaysUoVeKFEYTcgsyv5Z/RLhcHcHjovPSeYVHYc7gfCy0skjJjLVgt
         ROJMiFghys24p/UZGwMCBa0JQs8E14amI8tUMrqiHqDqI57PxwOQ9vK6KtS2r+a7a2SW
         0JjIQRf/lXuX2MUtJgnOM0anh+FW0AHFS+lyRWnP2mZ3bU7u37r6ZP+KFXjA6kKenTnZ
         P3MQ==
X-Gm-Message-State: APjAAAUHJwh00nnriE6S4XASvTo4PdH9roXsOKNwCnJWI0Dzq8ypoUYV
        JnKznJSEkIVn+O4E9XI+WAwaK0joHImLbb0Kz9EdU3UVaIRE
X-Google-Smtp-Source: APXvYqzV8JeqBUYGAkEVFE/5tCLRs4BmMrMFHmykStvb7KmZgsRjuQCv2kRQa4EwNhkn41ukasbGIvtLxrHG8k6Baekq06RWo1k4
MIME-Version: 1.0
X-Received: by 2002:a5e:d703:: with SMTP id v3mr30942144iom.197.1558200960160;
 Sat, 18 May 2019 10:36:00 -0700 (PDT)
Date:   Sat, 18 May 2019 10:36:00 -0700
In-Reply-To: <Pine.LNX.4.44L0.1905181300440.10594-100000@netrider.rowland.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b8203405892cee43@google.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
From:   syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, chunkeey@gmail.com, chunkeey@googlemail.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
KASAN: use-after-free Read in usb_driver_release_interface

usb 1-1: Loading firmware file isl3887usb
usb 1-1: Direct firmware load for isl3887usb failed with error -2
usb 1-1: Firmware not found.
p54usb 1-1:0.143: failed to initialize device (-2)
==================================================================
BUG: KASAN: use-after-free in usb_driver_release_interface+0x16b/0x190  
drivers/usb/core/driver.c:584
Read of size 8 at addr ffff88808fc31218 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc3-g43151d6-dirty #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  print_address_description+0x6c/0x236 mm/kasan/report.c:187
  kasan_report.cold+0x1a/0x3c mm/kasan/report.c:317
  usb_driver_release_interface+0x16b/0x190 drivers/usb/core/driver.c:584
  p54u_load_firmware_cb+0x390/0x420  
drivers/net/wireless/intersil/p54/p54usb.c:948
  request_firmware_work_func+0x12d/0x249  
drivers/base/firmware_loader/main.c:785
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 12:
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:470
  kmalloc include/linux/slab.h:547 [inline]
  kzalloc include/linux/slab.h:742 [inline]
  usb_set_configuration+0x2e0/0x1740 drivers/usb/core/message.c:1846
  generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
  usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
  really_probe+0x2da/0xb10 drivers/base/dd.c:509
  driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
  __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
  bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
  __device_attach+0x223/0x3a0 drivers/base/dd.c:844
  bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
  device_add+0xad2/0x16e0 drivers/base/core.c:2106
  usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x138e/0x3b00 drivers/usb/core/hub.c:5432
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Freed by task 5394:
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x130/0x180 mm/kasan/common.c:459
  slab_free_hook mm/slub.c:1429 [inline]
  slab_free_freelist_hook+0x5e/0x140 mm/slub.c:1456
  slab_free mm/slub.c:3003 [inline]
  kfree+0xce/0x290 mm/slub.c:3958
  device_release+0x7d/0x210 drivers/base/core.c:1064
  kobject_cleanup lib/kobject.c:662 [inline]
  kobject_release lib/kobject.c:691 [inline]
  kref_put include/linux/kref.h:67 [inline]
  kobject_put+0x1df/0x4f0 lib/kobject.c:708
  put_device+0x21/0x30 drivers/base/core.c:2205
  usb_disable_device+0x309/0x790 drivers/usb/core/message.c:1244
  usb_disconnect+0x298/0x870 drivers/usb/core/hub.c:2197
  hub_port_connect drivers/usb/core/hub.c:4940 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0xcd2/0x3b00 drivers/usb/core/hub.c:5432
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88808fc31100
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 280 bytes inside of
  2048-byte region [ffff88808fc31100, ffff88808fc31900)
The buggy address belongs to the page:
page:ffffea00023f0c00 count:1 mapcount:0 mapping:ffff88812c3f4800 index:0x0  
compound_mapcount: 0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000200 ffff88812c3f4800
raw: 0000000000000000 00000000000f000f 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808fc31100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808fc31180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808fc31200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff88808fc31280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808fc31300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         43151d6c usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=148b9428a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17642018a00000

