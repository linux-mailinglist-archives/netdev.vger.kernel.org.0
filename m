Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627AB8AC02
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHMAgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:36:02 -0400
Received: from mail-ot1-f70.google.com ([209.85.210.70]:45659 "EHLO
        mail-ot1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHMAgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:36:02 -0400
Received: by mail-ot1-f70.google.com with SMTP id k22so7106508otn.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DdharNhZ7fUYbdIIsQ/LEEyRD5VF53RtP1Ku2I74hAQ=;
        b=mg/kNH2QoaqhgE/aITQXaPrh2OAilFlQJcIIi28nXzfjL9EIBzGC2ryBe9+7dS2BB5
         EAe17V6KvpUovkLqgFCyuZDej4pdNazbJmA9muuABqP48LqmODvwynRbWRAAIxPdXiTZ
         Wo+7CA5c9/pNz8+83GKGV+/ZNqhHr4kAhpyx9RSB46KeHYY98CpR0vrZPv50HgMrPcQM
         jsazvsTwD8TRK81hgvXGXmgBC0oMTGU9JTaEvyQzqEBnxcrV/FnkkWFwk6FtTzmqVrAd
         sjqq/jgKWJ2mfko0x6h+LZtgRg7GBmDdb2q2qY6vMf7aIlZZNiSIiEwuDcdKujys2CWI
         uxFA==
X-Gm-Message-State: APjAAAXGeCCIacBzXAKkSgtw4eMgWB1N0Eto6dkbEu/0N7IFzlQw4RkE
        u50YGYocMEYjt9r4DZ6A2JUZgqnVghKDb0CdnRJe8skIGhi6
X-Google-Smtp-Source: APXvYqxMYAGcxlWJVOtPt7gFUbqfN2enOSd4JaOv/R/ou+1LqtPPq6T0aJbW880XaDuOAMXYaicGN5cLYZX1wKbO9PcKwvAA35DA
MIME-Version: 1.0
X-Received: by 2002:a6b:ea12:: with SMTP id m18mr19516038ioc.173.1565656561041;
 Mon, 12 Aug 2019 17:36:01 -0700 (PDT)
Date:   Mon, 12 Aug 2019 17:36:01 -0700
In-Reply-To: <4694.1565649521@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029475c058ff4d32e@google.com>
Subject: Re: KASAN: use-after-free Read in rxrpc_queue_local
From:   syzbot <syzbot+78e71c5bab4f76a6a719@syzkaller.appspotmail.com>
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
Read of size 4 at addr ffff888081e3db14 by task syz-executor.5/31180

CPU: 0 PID: 31180 Comm: syz-executor.5 Not tainted 5.3.0-rc3+ #1
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
RSP: 002b:00007fffc45736d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000413511
RDX: 0000001b33920000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000001 R08: ffffffffffffffff R09: ffffffffffffffff
R10: 00007fffc45737b0 R11: 0000000000000293 R12: 000000000075bf20
R13: 000000000003624a R14: 0000000000760270 R15: ffffffffffffffff

Allocated by task 31182:
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
  rxrpc_bind+0x34d/0x5e0 net/rxrpc/af_rxrpc.c:149
  __sys_bind+0x239/0x290 net/socket.c:1647
  __do_sys_bind net/socket.c:1658 [inline]
  __se_sys_bind net/socket.c:1656 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1656
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9:
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

The buggy address belongs to the object at ffff888081e3db00
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
  1024-byte region [ffff888081e3db00, ffff888081e3df00)
The buggy address belongs to the page:
page:ffffea0002078f00 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002073288 ffffea00022f1608 ffff8880aa400c40
raw: 0000000000000000 ffff888081e3c000 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888081e3da00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888081e3da80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff888081e3db00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff888081e3db80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888081e3dc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         03a62469 rxrpc: Fix local endpoint replacement
git tree:        
git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
console output: https://syzkaller.appspot.com/x/log.txt?x=14500d36600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

