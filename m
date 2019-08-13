Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215168AC2D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfHMAvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:51:02 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:41050 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMAvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:51:02 -0400
Received: by mail-ot1-f71.google.com with SMTP id a8so87717009oti.8
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=IXC8f+6CtYCNVkAn+PBhTvyIkZUHCItWpTG0bitgtUs=;
        b=L4+NaNDxl3ZlLQZn33kk/3vVqM5nWSyLwIHTLyopRMzwJv5KrE8Mw7XJgn3cErZHB/
         Z9iK5Mt6wqHwZXvAIJcplnL1q/jXFgFHIYVBcbN4hpNPPq3l3BQiPRqLfKnfTL5MfrJ8
         5hZumH7aXftU2Ma/ffO5EQG09H5ApYAqDvtiqfz7pvQn5iRRfbVjoFldpC65w+vqhw39
         Q9R6Fj1HWilfIVyVo9+ic5AMH1YeJXQRSkq1A24+XAaVTbf/0GfBJsuDZtLkaV6dCiAY
         ksxyrt+M8SAN8kchGD6EqytVJHqyeDalZqZunT5PhPSaYT7TUmu6k5IlhmPL3jWJluqP
         frvQ==
X-Gm-Message-State: APjAAAW1qedhokNao9NjEZ0u37LQfRCOrpUEtDYcuJsf2c4m0b7KJ8QZ
        uQeQQuBwA+vhpMhVN7s0o2nEZDl4vnK+N9cqdKQ1THaLKCZL
X-Google-Smtp-Source: APXvYqzSfz2wRnCQyCNu/o6nRmctq6yPZ0toZF2N8tN7yOoeWZQK5Bgy0ybLo0i2NbwUebLW5NvPEzXD62bZG0xLL0LHgy19yW/s
MIME-Version: 1.0
X-Received: by 2002:a5d:968b:: with SMTP id m11mr31666935ion.16.1565657461082;
 Mon, 12 Aug 2019 17:51:01 -0700 (PDT)
Date:   Mon, 12 Aug 2019 17:51:01 -0700
In-Reply-To: <5014.1565649712@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ced34b058ff50814@google.com>
Subject: Re: BUG: corrupted list in rxrpc_local_processor
From:   syzbot <syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
KASAN: use-after-free Read in rxrpc_queue_local

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in rxrpc_queue_local+0x7c/0x3e0  
net/rxrpc/local_object.c:354
Read of size 4 at addr ffff8880a82b56d4 by task syz-executor.0/11829

CPU: 1 PID: 11829 Comm: syz-executor.0 Not tainted 5.3.0-rc3+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_read+0x11/0x20 mm/kasan/common.c:92
  atomic_read include/asm-generic/atomic-instrumented.h:26 [inline]
  rxrpc_queue_local+0x7c/0x3e0 net/rxrpc/local_object.c:354
  rxrpc_unuse_local+0x52/0x80 net/rxrpc/local_object.c:408
  rxrpc_release_sock net/rxrpc/af_rxrpc.c:904 [inline]
  rxrpc_release+0x47d/0x840 net/rxrpc/af_rxrpc.c:930
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413511
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffc204e87c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000413511
RDX: 0000001b2e420000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007ffc204e88a0 R11: 0000000000000293 R12: 000000000075bf20
R13: 000000000001ac29 R14: 0000000000760210 R15: ffffffffffffffff

Allocated by task 11830:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
  rxrpc_lookup_local+0x562/0x1ba0 net/rxrpc/local_object.c:277
  rxrpc_sendmsg+0x379/0x5f0 net/rxrpc/af_rxrpc.c:566
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
  __do_sys_sendmmsg net/socket.c:2442 [inline]
  __se_sys_sendmmsg net/socket.c:2439 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 16:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  rxrpc_local_rcu+0x62/0x80 net/rxrpc/local_object.c:495
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2114 [inline]
  rcu_core+0x67f/0x1580 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff8880a82b56c0
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
  1024-byte region [ffff8880a82b56c0, ffff8880a82b5ac0)
The buggy address belongs to the page:
page:ffffea0002a0ad00 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0xffff8880a82b5b40 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002a1cb08 ffffea00023b0c88 ffff8880aa400c40
raw: ffff8880a82b5b40 ffff8880a82b4040 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a82b5580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a82b5600: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ffff8880a82b5680: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                  ^
  ffff8880a82b5700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a82b5780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         03a62469 rxrpc: Fix local endpoint replacement
git tree:        
git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
console output: https://syzkaller.appspot.com/x/log.txt?x=15f1679a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

