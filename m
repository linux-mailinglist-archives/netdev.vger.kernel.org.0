Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367F9113BBB
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 07:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfLEGfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 01:35:08 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:52910 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfLEGfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 01:35:07 -0500
Received: by mail-io1-f71.google.com with SMTP id e124so1708833iof.19
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 22:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sWlaImi5B4uVh73w3PHyR9//P49nAec4x6mydwyswqI=;
        b=mldoN1clOsjawQiuzw780Q3MwOTe4DkrWS59RVv9vwp7+WN7QNGB9iLtIsj7byo3d0
         Qtt27M7E6Dyd/+DgoY/A3n0CFi4Y4aNXdLfIg5G/hkVYeQutxB3ZLEALqpHCRSGSf8Dz
         lbe95HAAnMqSYeXy/1Ot86wIJ1pAeMXpguRGz1bmwi9YySCBcqqKTWVuXLWAnVD9N9Oo
         xwOOEPoDyGMbMhPFBuhwaxGpeIrczltQcivuWTGgV+YMi9hRCtHzEVnK1lHV3iQxZ0cW
         TdZSNQwbi3bKKGjzRaV6RpBCH+F0ppEDh9aZltoR5UN7U9MiUBS86Np9XfG4KxIPbZjv
         M1vg==
X-Gm-Message-State: APjAAAVxoZv2y/h/W+v8qmgKhP8vP3qxOV3Bvfc8wEHfXwL3EkJ6btRw
        89B79R0AMLd3ZbKQTZCCxDe6F1gu+VPXKe/OaeGWpzVl0V4C
X-Google-Smtp-Source: APXvYqyTtejw80rTQ+CvFHMjZ29IKsVykf637q7u88PD0v7dSr0tMfseJhNiwYx/dKnjCd9NiH1jHxoe84au5O7n2k3Y1oufRx2G
MIME-Version: 1.0
X-Received: by 2002:a6b:5a13:: with SMTP id o19mr5063163iob.120.1575527706944;
 Wed, 04 Dec 2019 22:35:06 -0800 (PST)
Date:   Wed, 04 Dec 2019 22:35:06 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004e6eed0598ef2184@google.com>
Subject: KASAN: slab-out-of-bounds Write in decode_data
From:   syzbot <syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com>
To:     ajk@comnets.uni-bremen.de, davem@davemloft.net,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63de3747 Merge tag 'tag-chrome-platform-for-v5.5' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165a7c82e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d189d07c6717979
dashboard link: https://syzkaller.appspot.com/bug?extid=fc8cd9a673d4577fb2e4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15379c2ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133cf97ee00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=150e2861e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=170e2861e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=130e2861e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in decode_data.part.0+0x23b/0x270  
drivers/net/hamradio/6pack.c:843
Write of size 1 at addr ffff8880993bd04e by task kworker/u4:2/25

CPU: 1 PID: 25 Comm: kworker/u4:2 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events_unbound flush_to_ldisc
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:638
  __asan_report_store1_noabort+0x17/0x20 mm/kasan/generic_report.c:137
  decode_data.part.0+0x23b/0x270 drivers/net/hamradio/6pack.c:843
  decode_data drivers/net/hamradio/6pack.c:965 [inline]
  sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
  sixpack_receive_buf drivers/net/hamradio/6pack.c:458 [inline]
  sixpack_receive_buf+0xde4/0x1420 drivers/net/hamradio/6pack.c:435
  tty_ldisc_receive_buf+0x15f/0x1c0 drivers/tty/tty_buffer.c:465
  tty_port_default_receive_buf+0x7d/0xb0 drivers/tty/tty_port.c:38
  receive_buf drivers/tty/tty_buffer.c:481 [inline]
  flush_to_ldisc+0x222/0x390 drivers/tty/tty_buffer.c:533
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8864:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:512 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:485
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:526
  __do_kmalloc_node mm/slab.c:3616 [inline]
  __kmalloc_node+0x4e/0x70 mm/slab.c:3623
  kmalloc_node include/linux/slab.h:579 [inline]
  kvmalloc_node+0x68/0x100 mm/util.c:574
  kvmalloc include/linux/mm.h:655 [inline]
  kvzalloc include/linux/mm.h:663 [inline]
  alloc_netdev_mqs+0x98/0xde0 net/core/dev.c:9730
  sixpack_open+0x104/0xaaf drivers/net/hamradio/6pack.c:563
  tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:464
  tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:591
  tiocsetd drivers/tty/tty_io.c:2337 [inline]
  tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2597
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8605:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  kasan_set_free_info mm/kasan/common.c:334 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:473
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:482
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  skb_free_head+0x93/0xb0 net/core/skbuff.c:591
  skb_release_data+0x551/0x8d0 net/core/skbuff.c:611
  skb_release_all+0x4d/0x60 net/core/skbuff.c:665
  __kfree_skb net/core/skbuff.c:679 [inline]
  consume_skb net/core/skbuff.c:838 [inline]
  consume_skb+0xfb/0x410 net/core/skbuff.c:832
  skb_free_datagram+0x1b/0x100 net/core/datagram.c:328
  netlink_recvmsg+0x6c6/0xf50 net/netlink/af_netlink.c:1996
  sock_recvmsg_nosec net/socket.c:873 [inline]
  sock_recvmsg net/socket.c:891 [inline]
  sock_recvmsg+0xce/0x110 net/socket.c:887
  ____sys_recvmsg+0x236/0x550 net/socket.c:2562
  ___sys_recvmsg+0xff/0x190 net/socket.c:2603
  __sys_recvmsg+0x102/0x1d0 net/socket.c:2650
  __do_sys_recvmsg net/socket.c:2660 [inline]
  __se_sys_recvmsg net/socket.c:2657 [inline]
  __x64_sys_recvmsg+0x78/0xb0 net/socket.c:2657
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880993bc000
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 78 bytes to the right of
  4096-byte region [ffff8880993bc000, ffff8880993bd000)
The buggy address belongs to the page:
page:ffffea000264ef00 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
raw: 00fffe0000010200 ffffea000262c288 ffffea00029bc908 ffff8880aa402000
raw: 0000000000000000 ffff8880993bc000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880993bcf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880993bcf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880993bd000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                               ^
  ffff8880993bd080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880993bd100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
