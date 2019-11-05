Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0EEF508
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKEFcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:32:12 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55059 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKEFcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 00:32:11 -0500
Received: by mail-io1-f72.google.com with SMTP id i15so14788992ion.21
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 21:32:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rOD589s+behik/fM/S/zlRKK0lDbx/9FlPGrpt7I8kQ=;
        b=blxeHa3XJ9iejt6+26bqVxyM10sOyZnSNMNxiXhSFSKWbSD9C0JbXMYV5ImMSUGkxz
         +L4x/eJathJcpZUjohFo5I0DQwhyqgoB9VEY/y49Puly3CiM8cpQZijSPjbSKft3KkLN
         IEUSPzVzmk72VFm1vjbrXP4xGxqKlswNNtW8c0hXpOUJIwwjpDU5i8WHqfpPIum21FK+
         5c06HX0gw8o3qRSeQO3/jfjhvPL+yW66X+g+MNMeu1jBYFrWI63jPJqkM7LdSkqPaKeQ
         DkEFFNBzivyXDN+sSyWFWvC1j/Lv6TD3Z7vOX64uXeZXml3faDzNLWQQXP3KNnOTkFoZ
         gXEA==
X-Gm-Message-State: APjAAAXK1cLUid76q0fpKy4wffDNhlRpnJH7Q6eM9PaSyODY9O0vcBHu
        2La2A8b46o8Sil7G7H0taAl2VyCOZ07/a2GNNf79EcyGLI3m
X-Google-Smtp-Source: APXvYqwgHZtMNRpbmvXw5Mt2nq6mL4W4z3czLET8VXiU3mQjQeYAkRRBZ0HR/7PdfdjzHdHW1jR8bg+JsAfTfZq3C83qnFlREJyy
MIME-Version: 1.0
X-Received: by 2002:a92:8408:: with SMTP id l8mr33356179ild.107.1572931928723;
 Mon, 04 Nov 2019 21:32:08 -0800 (PST)
Date:   Mon, 04 Nov 2019 21:32:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de1eec059692c021@google.com>
Subject: KASAN: use-after-free Write in j1939_sock_pending_del
From:   syzbot <syzbot+07bb74aeafc88ba7d5b4@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=169c59b2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=07bb74aeafc88ba7d5b4
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16fd7044e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+07bb74aeafc88ba7d5b4@syzkaller.appspotmail.com

vcan0: j1939_xtp_rx_abort_one: 0x00000000b4d8b78c: 0x00000: (2) System  
resources were needed for another task so this connection managed session  
was terminated.
vcan0: j1939_xtp_rx_abort_one: 0x00000000dadb7e22: 0x00000: (2) System  
resources were needed for another task so this connection managed session  
was terminated.
==================================================================
BUG: KASAN: use-after-free in atomic_sub_return  
include/asm-generic/atomic-instrumented.h:159 [inline]
BUG: KASAN: use-after-free in atomic_dec_return  
include/linux/atomic-fallback.h:455 [inline]
BUG: KASAN: use-after-free in j1939_sock_pending_del+0x20/0x70  
net/can/j1939/socket.c:73
Write of size 4 at addr ffff8880a4a2e4c0 by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5c0 mm/kasan/report.c:374
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:506
  kasan_report+0x26/0x50 mm/kasan/common.c:634
  check_memory_region_inline mm/kasan/generic.c:182 [inline]
  check_memory_region+0x2cf/0x2e0 mm/kasan/generic.c:192
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:98
  atomic_sub_return include/asm-generic/atomic-instrumented.h:159 [inline]
  atomic_dec_return include/linux/atomic-fallback.h:455 [inline]
  j1939_sock_pending_del+0x20/0x70 net/can/j1939/socket.c:73
  __j1939_session_drop net/can/j1939/transport.c:257 [inline]
  j1939_session_destroy net/can/j1939/transport.c:270 [inline]
  __j1939_session_release net/can/j1939/transport.c:280 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_session_put+0xd2/0x150 net/can/j1939/transport.c:285
  j1939_xtp_rx_abort_one+0xd3/0x3f0 net/can/j1939/transport.c:1261
  j1939_xtp_rx_abort net/can/j1939/transport.c:1269 [inline]
  j1939_tp_cmd_recv net/can/j1939/transport.c:1940 [inline]
  j1939_tp_recv+0x633/0xb80 net/can/j1939/transport.c:1973
  j1939_can_recv+0x424/0x650 net/can/j1939/main.c:100
  deliver net/can/af_can.c:568 [inline]
  can_rcv_filter+0x3c0/0x8b0 net/can/af_can.c:602
  can_receive+0x2ac/0x3b0 net/can/af_can.c:659
  can_rcv+0xe4/0x220 net/can/af_can.c:685
  __netif_receive_skb_one_core net/core/dev.c:4929 [inline]
  __netif_receive_skb+0x136/0x370 net/core/dev.c:5043
  process_backlog+0x4d8/0x930 net/core/dev.c:5874
  napi_poll net/core/dev.c:6311 [inline]
  net_rx_action+0x5ef/0x10d0 net/core/dev.c:6379
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:766
  run_ksoftirqd+0x64/0xf0 kernel/softirq.c:603
  smpboot_thread_fn+0x5b3/0x9a0 kernel/smpboot.c:165
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8435:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:510
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x254/0x340 mm/slab.c:3664
  kmalloc include/linux/slab.h:561 [inline]
  sk_prot_alloc+0xb0/0x290 net/core/sock.c:1605
  sk_alloc+0x38/0x950 net/core/sock.c:1659
  can_create+0x1de/0x480 net/can/af_can.c:157
  __sock_create+0x5cc/0x910 net/socket.c:1418
  sock_create net/socket.c:1469 [inline]
  __sys_socket+0xe7/0x2e0 net/socket.c:1511
  __do_sys_socket net/socket.c:1520 [inline]
  __se_sys_socket net/socket.c:1518 [inline]
  __x64_sys_socket+0x7a/0x90 net/socket.c:1518
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 16:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1642 [inline]
  __sk_destruct+0x523/0x620 net/core/sock.c:1726
  sk_destruct net/core/sock.c:1741 [inline]
  __sk_free+0x35d/0x430 net/core/sock.c:1752
  sock_wfree+0x106/0x140 net/core/sock.c:1968
  skb_release_head_state+0x100/0x210 net/core/skbuff.c:652
  skb_release_all net/core/skbuff.c:663 [inline]
  __kfree_skb+0x25/0x170 net/core/skbuff.c:679
  kfree_skb net/core/skbuff.c:697 [inline]
  skb_queue_purge+0x1a6/0x260 net/core/skbuff.c:3078
  j1939_session_destroy net/can/j1939/transport.c:269 [inline]
  __j1939_session_release net/can/j1939/transport.c:280 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_session_put+0x7f/0x150 net/can/j1939/transport.c:285
  j1939_xtp_rx_abort_one+0xd3/0x3f0 net/can/j1939/transport.c:1261
  j1939_xtp_rx_abort net/can/j1939/transport.c:1269 [inline]
  j1939_tp_cmd_recv net/can/j1939/transport.c:1940 [inline]
  j1939_tp_recv+0x633/0xb80 net/can/j1939/transport.c:1973
  j1939_can_recv+0x424/0x650 net/can/j1939/main.c:100
  deliver net/can/af_can.c:568 [inline]
  can_rcv_filter+0x3c0/0x8b0 net/can/af_can.c:602
  can_receive+0x2ac/0x3b0 net/can/af_can.c:659
  can_rcv+0xe4/0x220 net/can/af_can.c:685
  __netif_receive_skb_one_core net/core/dev.c:4929 [inline]
  __netif_receive_skb+0x136/0x370 net/core/dev.c:5043
  process_backlog+0x4d8/0x930 net/core/dev.c:5874
  napi_poll net/core/dev.c:6311 [inline]
  net_rx_action+0x5ef/0x10d0 net/core/dev.c:6379
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:766

The buggy address belongs to the object at ffff8880a4a2e000
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1216 bytes inside of
  2048-byte region [ffff8880a4a2e000, ffff8880a4a2e800)
The buggy address belongs to the page:
page:ffffea0002928b80 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002a48588 ffffea0002443f48 ffff8880aa400e00
raw: 0000000000000000 ffff8880a4a2e000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a4a2e380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a4a2e400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a4a2e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
  ffff8880a4a2e500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a4a2e580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
