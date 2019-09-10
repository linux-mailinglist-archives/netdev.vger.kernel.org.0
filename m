Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95648AF362
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 01:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfIJXfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 19:35:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40430 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfIJXfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 19:35:07 -0400
Received: by mail-io1-f71.google.com with SMTP id l9so25296820ioj.7
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 16:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Y67ZPAjv5Qq+Fx3oOv1534DfTfsCTzwcze7Z3T26u+U=;
        b=bd7VK3Y2keDbHalsTfmDKcCWHDAKNHOAabw87dXCkl1074XUe3s5bxiT3O52PdcVou
         yd/Qwfi71DfQinrFYmy34zP0nql821h05AO+RoyHG7hQfQnoWJBNsRPf4j88v0Uhq2Uj
         JgSHSwFpg3P7JRJtXozB1hszBP1wcs4SNkSlpdWfSARpa51TNGIskEchc8wudr3wQoeq
         JZAku8Fd1RTmCpdEQPHGsMRWwxcblhyRUsiHIPz5vvqdXdrCszz+H3GsceUL93YERgyI
         hDCH2qX2qx8b749TjNFKhHIWObUuoQLDLcnvpsgk//VIyosnVS2x9TAkxAdZ2SkKv6lL
         oh3Q==
X-Gm-Message-State: APjAAAXGeXMfD6cFBUolMCKMbsTqSl5UXn6p9tiXRWHktaoSfrdoTA91
        3SHR0r0ySE8fhGxvw27RCbFzP4Z0R+TUi8EHR/LIour/55Si
X-Google-Smtp-Source: APXvYqxDShE5QODV3Bt/aXdYO54eEw9UNBEK1xCKo6mvmG8TVje0Sj9MsL8Fcp0zqrZrft6TEdufwtY4haSPtBVWoFBfbq6+Htkz
MIME-Version: 1.0
X-Received: by 2002:a6b:b4c7:: with SMTP id d190mr11298139iof.209.1568158506509;
 Tue, 10 Sep 2019 16:35:06 -0700 (PDT)
Date:   Tue, 10 Sep 2019 16:35:06 -0700
In-Reply-To: <000000000000e695c1058fb26925@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb6c1005923b5ab7@google.com>
Subject: Re: KASAN: use-after-free Read in rxrpc_send_keepalive
From:   syzbot <syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com>
To:     MAILER_DAEMON@email.uscc.net, davem@davemloft.net,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    3120b9a6 Merge tag 'ipc-fixes' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107d1ca5600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed2b148cd67382ec
dashboard link: https://syzkaller.appspot.com/bug?extid=d850c266e3df14da1d31
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17347095600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143bcca5600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rxrpc_send_keepalive+0xe2/0x3c0  
net/rxrpc/output.c:634
Read of size 8 at addr ffff8880a859a058 by task kworker/0:2/3016

CPU: 0 PID: 3016 Comm: kworker/0:2 Not tainted 5.3.0-rc8+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5b0 mm/kasan/report.c:351
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:482
  kasan_report+0x26/0x50 mm/kasan/common.c:618
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  rxrpc_send_keepalive+0xe2/0x3c0 net/rxrpc/output.c:634
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:369 [inline]
  rxrpc_peer_keepalive_worker+0x76e/0xb40 net/rxrpc/peer_event.c:430
  process_one_work+0x7ef/0x10e0 kernel/workqueue.c:2269
  worker_thread+0xc01/0x1630 kernel/workqueue.c:2415
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9378:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:493
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:507
  kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  rxrpc_alloc_connection+0x79/0x490 net/rxrpc/conn_object.c:41
  rxrpc_alloc_client_connection net/rxrpc/conn_client.c:176 [inline]
  rxrpc_get_client_conn net/rxrpc/conn_client.c:339 [inline]
  rxrpc_connect_call+0xb30/0x2c40 net/rxrpc/conn_client.c:697
  rxrpc_new_client_call+0x6d5/0xb60 net/rxrpc/call_object.c:289
  rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:595 [inline]
  rxrpc_do_sendmsg+0xf2b/0x19b0 net/rxrpc/sendmsg.c:652
  rxrpc_sendmsg+0x5eb/0x8b0 net/rxrpc/af_rxrpc.c:585
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x60d/0x910 net/socket.c:2311
  __sys_sendmmsg+0x239/0x470 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg net/socket.c:2439 [inline]
  __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2439
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 16:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:455
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:463
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  rxrpc_destroy_connection+0x1ec/0x240 net/rxrpc/conn_object.c:372
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2114 [inline]
  rcu_core+0x892/0xf10 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778

The buggy address belongs to the object at ffff8880a859a040
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 24 bytes inside of
  1024-byte region [ffff8880a859a040, ffff8880a859a440)
The buggy address belongs to the page:
page:ffffea0002a16680 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00024cc688 ffffea0002684d88 ffff8880aa400c40
raw: 0000000000000000 ffff8880a859a040 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a8599f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a8599f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a859a000: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                     ^
  ffff8880a859a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a859a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

