Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1875FF6BCF
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 23:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfKJWyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 17:54:09 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:42825 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfKJWyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 17:54:08 -0500
Received: by mail-il1-f198.google.com with SMTP id n16so15302897ilm.9
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 14:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=T+hSEXD8Dr0eik6ghANx808yi18vcvBCJAQm5kVWr2s=;
        b=ggLS11AQWPYn8d4Gt+ac+0UgfNv4GKFsZv6N/sxn680l9mmVj1VmgbVvQ53alXpnIL
         TV/mMkYDqaFzrS/imDjps6s2wEQcB/ly9GtGBzN5D/HSqbldvnWYCsKjjVvKJwl9mWkv
         /CLNk63xrQBaa6fKCUxDBgDwBfIvwRJZcQza51AHCoXoHNDRfkjMdLlUJkmCqK+MArTM
         xMSVubGdAUNKBoirqqTXZF1dw0s5nCFqJhjDKY7ivMwJzp7xSXwPYjbu8AgeUKPYTFur
         4x5c5xtM6BdM6ESossAf2SeEBEqP7bmoB+kAiZC+oXk4VcAeEGUUMdKpSpsjQAyHp6aG
         hfuw==
X-Gm-Message-State: APjAAAWskg/eMGAca4ixBt3kSh4bwrb+B15l8sglVNzjOtxk//JiKdvW
        6O/FtJyxnD9aOmK76Z3YGxlIcaaHIP30/v3lGki6RKvOIi+C
X-Google-Smtp-Source: APXvYqw6Ild/vJLjFVysjFa8KW3N9gwbpBvH+mHq0fOB0XgJiWam7/3idPuZp395EjbCe8qidk2Kcx4sitciXP/1LRoWqjEGvHUN
MIME-Version: 1.0
X-Received: by 2002:a92:7f03:: with SMTP id a3mr19662759ild.105.1573426447957;
 Sun, 10 Nov 2019 14:54:07 -0800 (PST)
Date:   Sun, 10 Nov 2019 14:54:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000082c66d059705e442@google.com>
Subject: KASAN: use-after-free Read in j1939_session_get_by_addr_locked
From:   syzbot <syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    00aff683 Merge tag 'for-5.4-rc6-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179eb2c2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=ca172a0ac477ac90f045
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144150e2e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11aaa9fce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com

vcan0: j1939_tp_rxtimer: 0x00000000be22d2f7: rx timeout, send abort
vcan0: j1939_xtp_rx_abort_one: 0x00000000be22d2f7: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
vcan0: j1939_tp_rxtimer: 0x00000000f7dc054a: rx timeout, send abort
vcan0: j1939_xtp_rx_abort_one: 0x00000000f7dc054a: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
==================================================================
BUG: KASAN: use-after-free in j1939_session_get_by_addr_locked+0x648/0x680  
net/can/j1939/transport.c:491
Read of size 8 at addr ffff8880937d9058 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  j1939_session_get_by_addr_locked+0x648/0x680 net/can/j1939/transport.c:491
  j1939_session_get_by_addr+0x47/0x60 net/can/j1939/transport.c:531
  j1939_xtp_rx_abort_one+0x8d/0x100 net/can/j1939/transport.c:1242
  j1939_xtp_rx_abort net/can/j1939/transport.c:1270 [inline]
  j1939_tp_cmd_recv net/can/j1939/transport.c:1958 [inline]
  j1939_tp_recv+0x798/0x9b0 net/can/j1939/transport.c:1991
  j1939_can_recv+0x4bb/0x620 net/can/j1939/main.c:100
  deliver net/can/af_can.c:568 [inline]
  can_rcv_filter+0x292/0x8e0 net/can/af_can.c:602
  can_receive+0x2e7/0x530 net/can/af_can.c:659
  can_rcv+0x133/0x1b0 net/can/af_can.c:685
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:4929
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5043
  process_backlog+0x206/0x750 net/core/dev.c:5874
  napi_poll net/core/dev.c:6311 [inline]
  net_rx_action+0x508/0x1120 net/core/dev.c:6379
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 10302:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  j1939_priv_create net/can/j1939/main.c:122 [inline]
  j1939_netdev_start+0xa4/0x550 net/can/j1939/main.c:251
  j1939_sk_bind+0x65a/0x8e0 net/can/j1939/socket.c:438
  __sys_bind+0x239/0x290 net/socket.c:1647
  __do_sys_bind net/socket.c:1658 [inline]
  __se_sys_bind net/socket.c:1656 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1656
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 10302:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  __j1939_priv_release net/can/j1939/main.c:154 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_priv_put+0x8b/0xb0 net/can/j1939/main.c:159
  j1939_netdev_stop+0x45/0x190 net/can/j1939/main.c:291
  j1939_sk_release+0x3bd/0x5c0 net/can/j1939/socket.c:580
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880937d8000
  which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4184 bytes inside of
  8192-byte region [ffff8880937d8000, ffff8880937da000)
The buggy address belongs to the page:
page:ffffea00024df600 refcount:1 mapcount:0 mapping:ffff8880aa4021c0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002623308 ffffea0002a31f08 ffff8880aa4021c0
raw: 0000000000000000 ffff8880937d8000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880937d8f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880937d8f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880937d9000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                     ^
  ffff8880937d9080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880937d9100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
