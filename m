Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6771416031
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEGJKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:10:07 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:41080 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfEGJKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:10:07 -0400
Received: by mail-it1-f200.google.com with SMTP id y62so14062868itd.6
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wGj8QD5gKJW43OuUYpH6pO7J5gHO+g1GMqUge+gSVCw=;
        b=J8bIFIK0DVV5bCZ6WVIyjQlGmgzzC90kGix/bFRkO3h8W0KjlbLho387aTT2cvFvTQ
         lMZWSi5g0R7ebOKz08UlyoR1jv4tb3tM/Dta8XRf0f5n5AenQg6+YOTPevw3IpKiWtnR
         JbgmlODH+3djSstojgXn9I1KjbrmL1i+eyKdnVtxxBwxnNU8u0VfWEsdYKjOs7E7nt2G
         1hvMoNUcc8fjH/3Tl+oJvKe9hmRLgYXhb7j9lGm2+d5W6f7nZ8LLOBEwtJ4sPchPdj5R
         Wa0mLX3InYiVtAZQn/Ggg9QuupSQQA6kUYhRB1oInkxRzWknv4srSTTK4Tzuhl/ppa7E
         UOQw==
X-Gm-Message-State: APjAAAV8qBtGpIBRD08D2G8+H4jL/SfnfEwfquyVncU6yHxeLqqqhz8a
        hMvZW9zSwQn/mJz3CG/PhHVoB3oalf1p1p2Lsq1bsX0d4MdM
X-Google-Smtp-Source: APXvYqxDW5QCZU/EC3UQeUBZbnYC491FuIKbQhdZyD6oz6ReScipKY22VF2GVnlNUccnTQrfJH2EAiIxRFO/ATvrnpwvlaT00zLt
MIME-Version: 1.0
X-Received: by 2002:a24:7595:: with SMTP id y143mr7969814itc.42.1557220205903;
 Tue, 07 May 2019 02:10:05 -0700 (PDT)
Date:   Tue, 07 May 2019 02:10:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035c756058848954a@google.com>
Subject: KASAN: use-after-free Read in hci_cmd_timeout
From:   syzbot <syzbot+19a9f729f05272857487@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    83a50840 Merge tag 'seccomp-v5.1-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14b99b60a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef1b87b455c397cf
dashboard link: https://syzkaller.appspot.com/bug?extid=19a9f729f05272857487
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+19a9f729f05272857487@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in hci_cmd_timeout+0x212/0x220  
net/bluetooth/hci_core.c:2617
Read of size 2 at addr ffff88809fa9ca08 by task kworker/1:1/22

CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 5.1.0-rc7+ #94
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events hci_cmd_timeout
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_load_n_noabort+0xf/0x20 mm/kasan/generic_report.c:142
  hci_cmd_timeout+0x212/0x220 net/bluetooth/hci_core.c:2617
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 8319:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
  __do_kmalloc_node mm/slab.c:3687 [inline]
  __kmalloc_node_track_caller+0x4e/0x70 mm/slab.c:3701
  __kmalloc_reserve.isra.0+0x40/0xf0 net/core/skbuff.c:140
  __alloc_skb+0x10b/0x5e0 net/core/skbuff.c:208
  alloc_skb include/linux/skbuff.h:1058 [inline]
  bt_skb_alloc include/net/bluetooth/bluetooth.h:339 [inline]
  hci_prepare_cmd+0x30/0x230 net/bluetooth/hci_request.c:287
  hci_req_add_ev+0xb0/0x210 net/bluetooth/hci_request.c:321
  __hci_cmd_sync_ev+0xfc/0x1c0 net/bluetooth/hci_request.c:133
  __hci_cmd_sync+0x37/0x50 net/bluetooth/hci_request.c:182
  btintel_enter_mfg+0x2e/0x90 drivers/bluetooth/btintel.c:82
  ag6xx_setup+0x106/0x820 drivers/bluetooth/hci_ag6xx.c:180
  hci_uart_setup+0x1c4/0x490 drivers/bluetooth/hci_ldisc.c:418
  hci_dev_do_open+0x78c/0x1780 net/bluetooth/hci_core.c:1450
  hci_power_on+0x10d/0x580 net/bluetooth/hci_core.c:2173
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Freed by task 8319:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
  __cache_free mm/slab.c:3499 [inline]
  kfree+0xcf/0x230 mm/slab.c:3822
  skb_free_head+0x93/0xb0 net/core/skbuff.c:557
  skb_release_data+0x576/0x7a0 net/core/skbuff.c:577
  skb_release_all+0x4d/0x60 net/core/skbuff.c:631
  __kfree_skb net/core/skbuff.c:645 [inline]
  kfree_skb net/core/skbuff.c:663 [inline]
  kfree_skb+0xe8/0x390 net/core/skbuff.c:657
  hci_dev_do_open+0xb2b/0x1780 net/bluetooth/hci_core.c:1552
  hci_power_on+0x10d/0x580 net/bluetooth/hci_core.c:2173
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88809fa9ca00
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 8 bytes inside of
  512-byte region [ffff88809fa9ca00, ffff88809fa9cc00)
The buggy address belongs to the page:
page:ffffea00027ea700 count:1 mapcount:0 mapping:ffff8880aa400940 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00023039c8 ffffea00026f9488 ffff8880aa400940
raw: 0000000000000000 ffff88809fa9c000 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809fa9c900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809fa9c980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88809fa9ca00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88809fa9ca80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809fa9cb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
