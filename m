Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F3726BFDC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgIPIwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:52:24 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:37462 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgIPIwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:52:16 -0400
Received: by mail-il1-f206.google.com with SMTP id c66so5032360ilf.4
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:52:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=R8C+QzQBoXS9C6i/TEwgz/S51dgBQPXEcwPrSd0S8DU=;
        b=lGcZJrxkfsM+/YJxKIkgryoSL5i+Q4MYVydtzClekpzk+lZVI2y+4soRJPrH9I+8fB
         3emEPtnS+k/OM2YZbLN3mOYXT08C1wyHl/nK7pxzU3XxYezeV73NjJre6zSFbQcl8M/f
         6rOTgHm9GxDL9bMg/z2vebFxWT8PIA/JK7QZ0YyGcRqaOikEKULgPwZEKGbfB8QgwxEF
         YP0cag+b/G0+sHvAScHZ+T6AWJwEwJmnCKb4I/5E3u7xjExQUxJObRTB4CcPbq8dWcse
         FW/Rh7ErwHfEVazVUWeu/al2LQGzQrcP0fRFBjDg+/S8pOo7V7peP/2dNJ0g84uxGyLq
         5EvA==
X-Gm-Message-State: AOAM532aNpj8JUMzdGJMBmKbjXCH1DuCm9x88ON8aCDVcOz8VTb44cEq
        Utl5hVSPymT0a9TQJrMt6NrvObpFrqZqeKsuw0qpIQk0fXex
X-Google-Smtp-Source: ABdhPJxszs9Odkfnq6c7Sf7vC23Ry4t7jbp8hOkcZpqpBU7TPRb8sXRUjXbjZ45SSTEci93NqkyFXjJqByq3eSgOamdrGYIMeB06
MIME-Version: 1.0
X-Received: by 2002:a6b:8b89:: with SMTP id n131mr18349587iod.170.1600246335113;
 Wed, 16 Sep 2020 01:52:15 -0700 (PDT)
Date:   Wed, 16 Sep 2020 01:52:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b8e4505af6a62a9@google.com>
Subject: KASAN: use-after-free Write in rxrpc_put_bundle
From:   syzbot <syzbot+d57aaf84dd8a550e6d91@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ed6d9b02 ionic: fix up debugfs after queue swap
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d4c1b5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d29a102d22f784ea
dashboard link: https://syzkaller.appspot.com/bug?extid=d57aaf84dd8a550e6d91
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fe9101900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1749d92d900000

The issue was bisected to:

commit 245500d853e9f20036cec7df4f6984ece4c6bf26
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 1 10:15:32 2020 +0000

    rxrpc: Rewrite the client connection manager

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12348911900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11348911900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16348911900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d57aaf84dd8a550e6d91@syzkaller.appspotmail.com
Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_dec_return include/asm-generic/atomic-instrumented.h:340 [inline]
BUG: KASAN: use-after-free in rxrpc_put_bundle+0x1d/0x80 net/rxrpc/conn_client.c:141
Write of size 4 at addr ffff8880a8669220 by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_dec_return include/asm-generic/atomic-instrumented.h:340 [inline]
 rxrpc_put_bundle+0x1d/0x80 net/rxrpc/conn_client.c:141
 rxrpc_destroy_connection+0x150/0x2f0 net/rxrpc/conn_object.c:367
 rcu_do_batch kernel/rcu/tree.c:2428 [inline]
 rcu_core+0x5ca/0x1130 kernel/rcu/tree.c:2656
 __do_softirq+0x1f7/0xa91 kernel/softirq.c:298
 run_ksoftirqd kernel/softirq.c:652 [inline]
 run_ksoftirqd+0xcf/0x170 kernel/softirq.c:644
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 6875:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x174/0x2c0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 rxrpc_alloc_bundle+0x7e/0x290 net/rxrpc/conn_client.c:121
 rxrpc_look_up_bundle net/rxrpc/conn_client.c:275 [inline]
 rxrpc_prep_call net/rxrpc/conn_client.c:374 [inline]
 rxrpc_connect_call+0x85c/0x1580 net/rxrpc/conn_client.c:710
 rxrpc_new_client_call+0x961/0x1020 net/rxrpc/call_object.c:331
 rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:622 [inline]
 rxrpc_do_sendmsg+0xf14/0x136d net/rxrpc/sendmsg.c:679
 rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:560
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmmsg+0x195/0x480 net/socket.c:2497
 __do_sys_sendmmsg net/socket.c:2526 [inline]
 __se_sys_sendmmsg net/socket.c:2523 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 2642:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x10e/0x2b0 mm/slab.c:3756
 rxrpc_put_bundle net/rxrpc/conn_client.c:146 [inline]
 rxrpc_put_bundle+0x6b/0x80 net/rxrpc/conn_client.c:138
 rxrpc_unbundle_conn+0x1f8/0x3d0 net/rxrpc/conn_client.c:935
 rxrpc_clean_up_local_conns+0x38d/0x587 net/rxrpc/conn_client.c:1114
 rxrpc_local_destroyer net/rxrpc/local_object.c:399 [inline]
 rxrpc_local_processor+0x38d/0x5e0 net/rxrpc/local_object.c:433
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff8880a8669200
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 32 bytes inside of
 192-byte region [ffff8880a8669200, ffff8880a86692c0)
The buggy address belongs to the page:
page:000000007bfb6cde refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a8669d00 pfn:0xa8669
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002a42f88 ffffea00027d8f08 ffff8880aa040000
raw: ffff8880a8669d00 ffff8880a8669000 000000010000000d 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a8669100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a8669180: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff8880a8669200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff8880a8669280: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880a8669300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
