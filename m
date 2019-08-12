Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12AB89DAD
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfHLMII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:08:08 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:53025 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbfHLMII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:08:08 -0400
Received: by mail-ot1-f71.google.com with SMTP id 88so4892823otc.19
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=k3c8LcSazCwKFrNziC6TBhoXX/eRW9ZM+i9e/h5ipd4=;
        b=XUDqD+WusOR8o4WmA7QZ7jibpfvpCAAyioAu01kDHbDbZa/rgCHfP28a9ezxWVR8xj
         PuUu2ZsKkGDSUr/eC3rbOvXZFTtH3j2R77zCS1S6GU7yfyqTAYDM2/EGrRDBxOnYqalE
         sFmr6KyoHy5hkgmqc4GhpMJ5X/VBDfrUdm6y+3U830VVVbMC+DN7l91AGGCqlKpaavKb
         ZzjGgGekSwJcz2sMguTJD9ug74G/R5iv6xR2tOWXcIaozzu4AfoYU+hNmi1r5pYLpW+b
         Xe2HS/bxnv428ZS4HF8SZSpomZrKmtGajcELg3k3RcY91AvcxDGqUDviCWRRGRt0Z5dH
         Gwmg==
X-Gm-Message-State: APjAAAW10LA2VUMHqJ0h2p0u0HSzgJ9zJX/sCQnF69R91/Tuc6RpRuLF
        jvYkB6B0iDFUdQnDAEOc6hIu8UymPgLMdnQHzR/oGwH5uCUv
X-Google-Smtp-Source: APXvYqxXM8QGVFHauf9s3BqfHHnqc0AEu6j0Lg3VV6mpTQQlFA7JqojoSeaXhSR84bvXhex4/fT4mgYzMkawCgGm/mNXv2L3tBPp
MIME-Version: 1.0
X-Received: by 2002:a02:390c:: with SMTP id l12mr24992612jaa.76.1565611686987;
 Mon, 12 Aug 2019 05:08:06 -0700 (PDT)
Date:   Mon, 12 Aug 2019 05:08:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007593f4058fea60d8@google.com>
Subject: KASAN: use-after-free Read in rxrpc_queue_local
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

syzbot found the following crash on:

HEAD commit:    125b7e09 net: tc35815: Explicitly check NET_IP_ALIGN is no..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=174a6536600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=78e71c5bab4f76a6a719
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165ec172600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119d4eba600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+78e71c5bab4f76a6a719@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_read  
include/asm-generic/atomic-instrumented.h:26 [inline]
BUG: KASAN: use-after-free in rxrpc_queue_local+0x7c/0x3e0  
net/rxrpc/local_object.c:354
Read of size 4 at addr ffff8880a7724014 by task syz-executor522/16188

CPU: 0 PID: 16188 Comm: syz-executor522 Not tainted 5.3.0-rc3+ #159
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
RIP: 0033:0x407bb1
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 24 1a 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffc861e4d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000407bb1
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000003
RBP: 00000000006e5a0c R08: 00000000004b1939 R09: 00000000004b1939
R10: 00007ffc861e4d40 R11: 0000000000000293 R12: 00000000006e5a00
R13: 0000000000000000 R14: 000000000000002d R15: 20c49ba5e353f7cf

Allocated by task 16189:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
  rxrpc_lookup_local+0x562/0x1b70 net/rxrpc/local_object.c:277
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

The buggy address belongs to the object at ffff8880a7724000
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 20 bytes inside of
  1024-byte region [ffff8880a7724000, ffff8880a7724400)
The buggy address belongs to the page:
page:ffffea00029dc900 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0xffff8880a7725200 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002a6ad08 ffffea0002a6a808 ffff8880aa400c40
raw: ffff8880a7725200 ffff8880a7724000 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a7723f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a7723f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a7724000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff8880a7724080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a7724100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
