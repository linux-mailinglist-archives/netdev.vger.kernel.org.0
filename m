Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52523EF472
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 05:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfKEEWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 23:22:12 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:39863 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730377AbfKEEWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 23:22:11 -0500
Received: by mail-io1-f71.google.com with SMTP id l22so14691768iob.6
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 20:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mfqj3TAcqyeNHSygRN5iCrmZSIKmIlsm8ENduZpG8I4=;
        b=tPcJUzRt4pI4r4+Xvl7fM1GBKCTm2c3cyde9l///Xg120/ItebuqkxicZrjVZdqF88
         z28rkyOlH2d0NfXJK7iNrzuAyfnA8ZqkB5MNagql5nzmCmOCEDthrTkoOvnrdQGK4av9
         uOkUuo+clQJ6Nh2C0rtcZYT2fmHca9BCj6K/Scxgg0xegK/pMdqx5o+KyREZE4f3Fi8t
         ccgVb+4wv52WMw06FyL65XO2c4uqvuDFPQAHKa22V+nsbQgzQ8UiPb/VUcQb1jB5phSL
         pUWV9WyO7JTGsOMrPL6wo0j1APWx0+gfw+FY+whQtTYeuK0X4IWvrLTg/U9bWXoWHBRU
         kyOQ==
X-Gm-Message-State: APjAAAVv8ULMwIcITWUMF2XurAfMBKGN7BwyTaXv57crO++M1jL0gG74
        WhFkhVPR62azfAYQ4yx9cGw2EGepebU+xzUpQ+p3uhHxPhJi
X-Google-Smtp-Source: APXvYqxtvoStetphLczcQ+YRxqQAUArXJTjBMya9Bo8pT8gfoSsLq13s5OggyOyY6WFOFI3Ju1Yq+YUcSokpUWH/Rxn37lK+N1u2
MIME-Version: 1.0
X-Received: by 2002:a5d:804e:: with SMTP id b14mr8314550ior.77.1572927729535;
 Mon, 04 Nov 2019 20:22:09 -0800 (PST)
Date:   Mon, 04 Nov 2019 20:22:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009393ba059691c6a3@google.com>
Subject: KASAN: use-after-free Read in j1939_session_get_by_addr
From:   syzbot <syzbot+d9536adc269404a984f8@syzkaller.appspotmail.com>
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

HEAD commit:    a99d8080 Linux 5.4-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d0cc58e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5e2eca3f31f9bf
dashboard link: https://syzkaller.appspot.com/bug?extid=d9536adc269404a984f8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1796b4dce00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142798dce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d9536adc269404a984f8@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_abort_one: 0x00000000a2ba57cc: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
vcan0: j1939_xtp_rx_abort_one: 0x00000000f495a5ef: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3a8b/0x4a00  
kernel/locking/lockdep.c:3828
Read of size 8 at addr ffff888094225080 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.0-rc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __lock_acquire+0x3a8b/0x4a00 kernel/locking/lockdep.c:3828
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
  j1939_session_get_by_addr+0x2d/0x60 net/can/j1939/transport.c:530
  j1939_xtp_rx_abort_one+0x8d/0x100 net/can/j1939/transport.c:1242
  j1939_xtp_rx_abort net/can/j1939/transport.c:1270 [inline]
  j1939_tp_cmd_recv net/can/j1939/transport.c:1943 [inline]
  j1939_tp_recv+0x513/0x9b0 net/can/j1939/transport.c:1973
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

Allocated by task 9736:
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

Freed by task 9:
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
  j1939_session_destroy net/can/j1939/transport.c:271 [inline]
  __j1939_session_release net/can/j1939/transport.c:280 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_session_put+0x12c/0x180 net/can/j1939/transport.c:285
  j1939_xtp_rx_abort_one+0xc7/0x100 net/can/j1939/transport.c:1261
  j1939_xtp_rx_abort net/can/j1939/transport.c:1269 [inline]
  j1939_tp_cmd_recv net/can/j1939/transport.c:1943 [inline]
  j1939_tp_recv+0x4fb/0x9b0 net/can/j1939/transport.c:1973
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

The buggy address belongs to the object at ffff888094224000
  which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4224 bytes inside of
  8192-byte region [ffff888094224000, ffff888094226000)
The buggy address belongs to the page:
page:ffffea0002508900 refcount:1 mapcount:0 mapping:ffff8880aa4021c0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000252a808 ffffea000232f808 ffff8880aa4021c0
raw: 0000000000000000 ffff888094224000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888094224f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094225000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888094225080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff888094225100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094225180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
