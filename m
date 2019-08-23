Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1099D9B256
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393724AbfHWOmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:42:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:34879 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393131AbfHWOmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 10:42:07 -0400
Received: by mail-io1-f70.google.com with SMTP id p2so11345570iod.2
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 07:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oGRoIYqYNhNuFpAeuDnZORqyo0RN7FZRZYFb1eVOswY=;
        b=FZsXjh0+3EAdb7240e+7N+THqP6TQD3b9EGc25IJuVOKBqk62so/wzGr51EUhqb29x
         wdkNJz5POcbNvD6AZBAywocRUN+Xko/6s7J1Bd9OzeaYwl8Hzt/bxrR+f97vsOmu4ssO
         DuufMn2MT7G5KSyxu7mxozIIeto1zA9/t+fGzxdt6tIp1YZHctuwliTSyQvI3moZHhr3
         XVXozzJHZfcDd7o8CmRbRfQPpaxzH1c/sjBbcISknUYNfZwv9JAL4U4TSq2vNDx0/wQA
         IkkuGjZT8Pg4cTw3E+vM4EwAxBETSRDuY9fnNr91+u3BVXihvXNvb7hQ2dYvCpisVJy3
         nnLg==
X-Gm-Message-State: APjAAAVfhiMsJWIhBWiQMz+jYYlFpJt7hVYLevZxgFV5M8ojAXErCBN3
        jY1AEcbTe3pAKOcOGlH9ZUAjAaYyYRDnwrfdOMviFpjQQ4rO
X-Google-Smtp-Source: APXvYqzA93rljXyWkKzeiso/H6XB0BcTqh0Ne13ybdAMtM0PVJnJuSj2rc+e4/qnLYpMG4ZRbZRQRCW1JUFWwUfVupK67W0OFGZU
MIME-Version: 1.0
X-Received: by 2002:a5e:a90f:: with SMTP id c15mr7199882iod.41.1566571326763;
 Fri, 23 Aug 2019 07:42:06 -0700 (PDT)
Date:   Fri, 23 Aug 2019 07:42:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000727bd10590c9cf6c@google.com>
Subject: KASAN: use-after-free Read in rxrpc_release_call
From:   syzbot <syzbot+eed305768ece6682bb7f@syzkaller.appspotmail.com>
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

HEAD commit:    fed07ef3 Merge tag 'mlx5-updates-2019-08-21' of git://git...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1256e22e600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e34a4fe936eac597
dashboard link: https://syzkaller.appspot.com/bug?extid=eed305768ece6682bb7f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+eed305768ece6682bb7f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rxrpc_release_call+0xb2d/0xb60  
net/rxrpc/call_object.c:481
Read of size 8 at addr ffff888062ffeb50 by task syz-executor.5/4764

CPU: 1 PID: 4764 Comm: syz-executor.5 Not tainted 5.3.0-rc5+ #143
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  rxrpc_release_call+0xb2d/0xb60 net/rxrpc/call_object.c:481
  rxrpc_release_calls_on_socket+0x6e7/0x1320 net/rxrpc/call_object.c:517
  rxrpc_release_sock net/rxrpc/af_rxrpc.c:898 [inline]
  rxrpc_release+0x40c/0x840 net/rxrpc/af_rxrpc.c:930
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
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe5ddebec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000459829
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe5ddebf6d4
R13: 00000000004f8f72 R14: 00000000004d1a70 R15: 00000000ffffffff

Allocated by task 4766:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  rxrpc_alloc_connection+0x86/0x5f0 net/rxrpc/conn_object.c:41
  rxrpc_alloc_client_connection net/rxrpc/conn_client.c:176 [inline]
  rxrpc_get_client_conn net/rxrpc/conn_client.c:339 [inline]
  rxrpc_connect_call+0x648/0x4c00 net/rxrpc/conn_client.c:697
  rxrpc_new_client_call+0x978/0x19d0 net/rxrpc/call_object.c:289
  rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:594 [inline]
  rxrpc_do_sendmsg+0xff5/0x1d53 net/rxrpc/sendmsg.c:651
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:585
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
  rxrpc_destroy_connection+0x1f2/0x2d0 net/rxrpc/conn_object.c:372
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2114 [inline]
  rcu_core+0x67f/0x1580 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff888062ffe900
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 592 bytes inside of
  1024-byte region [ffff888062ffe900, ffff888062ffed00)
The buggy address belongs to the page:
page:ffffea00018bff80 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000181be88 ffffea0002324108 ffff8880aa400c40
raw: 0000000000000000 ffff888062ffe000 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888062ffea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888062ffea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888062ffeb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                  ^
  ffff888062ffeb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888062ffec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
