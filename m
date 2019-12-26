Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE15212AEC7
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLZVPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:15:12 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:34001 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZVPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:15:12 -0500
Received: by mail-il1-f200.google.com with SMTP id l13so21639467ils.1
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=q/kM3hNHvC7xHvrXTsOHwQHfpns6WCQHWB8i90xjZpI=;
        b=JLE3BwJPlQgwAyjO6WiEB4D+/L48ZWqlTDXwfmevtOeNDpZdtqM40iEHrvjdKBZeLp
         4jgFOszZXNRgpc/BUY2+8txYGswtD/2dJOFU5CkyDofcc7SOTPNS5NQbaJtJdjLYqRzx
         CSQY0jvHgCT9OlXsgeypjcJhCs0LyKIHJiSy8UcdCqcROXaDYhyPSXxBYmGi+ae+3lt+
         12/5jn8OYCrb4IimZBCdv9g4YPoMx4KGVwHJhGxJEsxrbktK4jWW3gZHyBvu5DQW4hU+
         mO5ft17nBeKVi/ROOHyEBCvH7lFKd42xEm7dun5OdyKqU8X2e+NimycHtVcJWPWMp+sW
         Mgkw==
X-Gm-Message-State: APjAAAUNKtzMWJaCSyLLjaPd3rYBmvLY05GldCRi25ej5RlOtem8lLfX
        3wfL1cszzIeaLWy19T3IDe+gEjYdJLCnkkeIT5E5pvtUDivX
X-Google-Smtp-Source: APXvYqw0eXL0knSBDFLS9zNPnFLDEUdeUcUkwol8Z+hx4ADXhrZNKbJUGsPo+SVwWmOU2FxfYsAB6nj71/7KydpYAgXbI+hYH1Im
MIME-Version: 1.0
X-Received: by 2002:a5e:840f:: with SMTP id h15mr33848611ioj.286.1577394911270;
 Thu, 26 Dec 2019 13:15:11 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:15:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b5fc7059aa1df89@google.com>
Subject: KASAN: use-after-free Read in j1939_tp_txtimer
From:   syzbot <syzbot+5322482fe520b02aea30@syzkaller.appspotmail.com>
To:     bst@pengutronix.de, davem@davemloft.net,
        dev.kurt@vandijck-laurijssen.be, ecathinds@gmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        lkp@intel.com, maxime.jayat@mobile-devices.fr, mkl@pengutronix.de,
        netdev@vger.kernel.org, o.rempel@pengutronix.de, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    46cf053e Linux 5.5-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=158ac866e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=5322482fe520b02aea30
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11af21fee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116b4ec1e00000

The bug was bisected to:

commit 9d71dd0c70099914fcd063135da3c580865e924c
Author: The j1939 authors <linux-can@vger.kernel.org>
Date:   Mon Oct 8 09:48:36 2018 +0000

     can: add support of SAE J1939 protocol

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124d0ac1e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=114d0ac1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=164d0ac1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5322482fe520b02aea30@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")

==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/string.h:380 [inline]
BUG: KASAN: use-after-free in j1939_session_tx_dat  
net/can/j1939/transport.c:790 [inline]
BUG: KASAN: use-after-free in j1939_xtp_txnext_transmiter  
net/can/j1939/transport.c:847 [inline]
BUG: KASAN: use-after-free in j1939_tp_txtimer+0x777/0x1b00  
net/can/j1939/transport.c:1095
Read of size 7 at addr ffff88809073d917 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.5.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  memcpy+0x24/0x50 mm/kasan/common.c:125
  memcpy include/linux/string.h:380 [inline]
  j1939_session_tx_dat net/can/j1939/transport.c:790 [inline]
  j1939_xtp_txnext_transmiter net/can/j1939/transport.c:847 [inline]
  j1939_tp_txtimer+0x777/0x1b00 net/can/j1939/transport.c:1095
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_run_softirq+0x17e/0x270 kernel/time/hrtimer.c:1596
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 16:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:521
  slab_post_alloc_hook mm/slab.h:584 [inline]
  slab_alloc_node mm/slab.c:3263 [inline]
  kmem_cache_alloc_node+0x138/0x740 mm/slab.c:3575
  __alloc_skb+0xd5/0x5e0 net/core/skbuff.c:197
  alloc_skb include/linux/skbuff.h:1049 [inline]
  j1939_tp_tx_dat_new+0x38/0x530 net/can/j1939/transport.c:568
  j1939_tp_tx_dat net/can/j1939/transport.c:606 [inline]
  j1939_session_tx_dat net/can/j1939/transport.c:791 [inline]
  j1939_xtp_txnext_transmiter net/can/j1939/transport.c:847 [inline]
  j1939_tp_txtimer+0x7a7/0x1b00 net/can/j1939/transport.c:1095
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_run_softirq+0x17e/0x270 kernel/time/hrtimer.c:1596
  __do_softirq+0x262/0x98c kernel/softirq.c:292

Freed by task 16:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:335 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
  __cache_free mm/slab.c:3426 [inline]
  kmem_cache_free+0x86/0x320 mm/slab.c:3694
  kfree_skbmem net/core/skbuff.c:623 [inline]
  kfree_skbmem+0xfb/0x1c0 net/core/skbuff.c:617
  __kfree_skb net/core/skbuff.c:680 [inline]
  consume_skb net/core/skbuff.c:838 [inline]
  consume_skb+0x103/0x410 net/core/skbuff.c:832
  vcan_tx+0x29f/0x7f0 drivers/net/can/vcan.c:110
  __netdev_start_xmit include/linux/netdevice.h:4447 [inline]
  netdev_start_xmit include/linux/netdevice.h:4461 [inline]
  xmit_one net/core/dev.c:3420 [inline]
  dev_hard_start_xmit+0x1a3/0x9b0 net/core/dev.c:3436
  __dev_queue_xmit+0x2b05/0x35c0 net/core/dev.c:4013
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  can_send+0x439/0x890 net/can/af_can.c:277
  j1939_send_one+0x29d/0x360 net/can/j1939/main.c:340
  j1939_tp_tx_dat net/can/j1939/transport.c:615 [inline]
  j1939_session_tx_dat net/can/j1939/transport.c:791 [inline]
  j1939_xtp_txnext_transmiter net/can/j1939/transport.c:847 [inline]
  j1939_tp_txtimer+0x5a9/0x1b00 net/can/j1939/transport.c:1095
  __run_hrtimer kernel/time/hrtimer.c:1517 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1579
  hrtimer_run_softirq+0x17e/0x270 kernel/time/hrtimer.c:1596
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff88809073d840
  which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 215 bytes inside of
  224-byte region [ffff88809073d840, ffff88809073d920)
The buggy address belongs to the page:
page:ffffea000241cf40 refcount:1 mapcount:0 mapping:ffff88821b774e00  
index:0x0
raw: 00fffe0000000200 ffffea00026df588 ffffea00023d9308 ffff88821b774e00
raw: 0000000000000000 ffff88809073d0c0 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809073d800: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
  ffff88809073d880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809073d900: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
                          ^
  ffff88809073d980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809073da00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
