Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D897D744FD
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403774AbfGYFcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:32:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34824 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403751AbfGYFcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:32:09 -0400
Received: by mail-io1-f71.google.com with SMTP id w17so53685182iom.2
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 22:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ik3PtZyBSBOqk1Sa/lqEk+1ZnpfAPkC9BgntyOiu5Ow=;
        b=CAzkQcdgtiqKpE3sQvtKO0afSYUoECIsCP5vGKIdAn5mMIQw49S+EsatXC+fp3aCfp
         kqwdaQHP3FkuD5jL7rVTxLvZk/ZrxElhx0CpBL0VIzujZz1hMklfzDr83Gv7WCE0jkVV
         WlaIyyeP8043afth2ihrUO+yuzAPx24nH9nZVMy+oI7JHpMBku40lorBmjCqFFayb1SY
         KWIvMB1KTQ7Por0CR5YM2Lav16Vpm+I+ffYaFcXps83VkwE50xyQBH7S1X98J82eefHV
         8YARgptTNaDykrnUlf7bbyROjmz7Sy0zNGF7Qd9xaDALk/ahFZ3irNiDR1OPpHGt3WIx
         b7yw==
X-Gm-Message-State: APjAAAWEYDfcQ+9JzHAvgxZeb7PMJWP40eygJW027aY1fseBGVfOgpjc
        4tBhg+0ErzcyMPKleyM9jWgZFMVlw/D+rzRC2Aq+zXtUmApe
X-Google-Smtp-Source: APXvYqyt4JZSEp7X3QD42Djy+YIbghPzwFyCynwuQ/G1t0+prDGyxjJsSUQiU06hPmRJHY/Kwyc9z9J0jo/4kR8iq8ysTe8sEbEk
MIME-Version: 1.0
X-Received: by 2002:a6b:7606:: with SMTP id g6mr25632950iom.288.1564032728579;
 Wed, 24 Jul 2019 22:32:08 -0700 (PDT)
Date:   Wed, 24 Jul 2019 22:32:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034454a058e7abfcf@google.com>
Subject: KASAN: use-after-free Read in tls_sk_proto_cleanup
From:   syzbot <syzbot+42f653cb62d6b4f1c97b@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9e6dfe80 Add linux-next specific files for 20190724
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16797ef0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
dashboard link: https://syzkaller.appspot.com/bug?extid=42f653cb62d6b4f1c97b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+42f653cb62d6b4f1c97b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in tls_sk_proto_cleanup+0x37f/0x3e0  
net/tls/tls_main.c:299
Read of size 1 at addr ffff88808adaacd4 by task syz-executor.2/10709

CPU: 1 PID: 10709 Comm: syz-executor.2 Not tainted 5.3.0-rc1-next-20190724  
#50
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:129
  tls_sk_proto_cleanup+0x37f/0x3e0 net/tls/tls_main.c:299
  tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
  tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
  tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
  tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
  tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
  tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
  sk_backlog_rcv include/net/sock.h:945 [inline]
  __release_sock+0x129/0x390 net/core/sock.c:2418
  release_sock+0x59/0x1c0 net/core/sock.c:2934
  sk_stream_wait_memory+0x65a/0xfc0 net/core/stream.c:149
  tls_sw_sendmsg+0x673/0x17b0 net/tls/tls_sw.c:1054
  inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9e6411bc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9e6411c6d4
R13: 00000000004c7669 R14: 00000000004dcc70 R15: 00000000ffffffff

Allocated by task 10709:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  create_ctx+0x46/0x260 net/tls/tls_main.c:657
  tls_init net/tls/tls_main.c:851 [inline]
  tls_init+0x134/0x560 net/tls/tls_main.c:830
  __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
  tcp_set_ulp+0x330/0x640 net/ipv4/tcp_ulp.c:160
  do_tcp_setsockopt.isra.0+0x363/0x24f0 net/ipv4/tcp.c:2810
  tcp_setsockopt+0xbe/0xe0 net/ipv4/tcp.c:3137
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2084
  __do_sys_setsockopt net/socket.c:2100 [inline]
  __se_sys_setsockopt net/socket.c:2097 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2097
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 16209:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  tls_ctx_free.part.0+0x3a/0x40 net/tls/tls_main.c:261
  tls_ctx_free net/tls/tls_main.c:256 [inline]
  tls_ctx_free_deferred+0x9f/0x130 net/tls/tls_main.c:282
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88808adaacc0
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
  512-byte region [ffff88808adaacc0, ffff88808adaaec0)
The buggy address belongs to the page:
page:ffffea00022b6a80 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0xffff88808adaa540
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002617408 ffffea00024ed248 ffff8880aa400a80
raw: ffff88808adaa540 ffff88808adaa040 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808adaab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808adaac00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ffff88808adaac80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                  ^
  ffff88808adaad00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808adaad80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
