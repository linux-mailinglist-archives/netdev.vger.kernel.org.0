Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA9288110
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437281AbfHIRWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:22:08 -0400
Received: from mail-ot1-f69.google.com ([209.85.210.69]:36829 "EHLO
        mail-ot1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfHIRWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 13:22:08 -0400
Received: by mail-ot1-f69.google.com with SMTP id f11so70166754otq.3
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 10:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9cgS772CXPKMKmDau0zRvHAXUTX+eRt7zThYm1+Rpm8=;
        b=ApEzos2GQ5b3qsEcVPXSKEihVSA9Xoi5kGqQRAIkGK5LhmiGR23uY/PqmXFGyggf17
         kqvWKdMvcI39Zo5kvk8a/1lBT6cC0vYyyyG/s3PEAmBrwhmL5DlOHNqrk3FEaFhpX6bQ
         NVUSv6kjCbFWseCmvMnMGMgBCoiZpgxk40hH570Vu6gaJ4nfe77ax47vZr5RX6b7PJO3
         shd/lPG8/l5Kbv7ROorVr2etgLE37ma40ARFcfBLj3zYTqUlIllMCVMBOZRiyWn1xZ+P
         rm9pqG4o93aDqV/hyEa8hXd7YSxhqXs9iHCqwmKhEvu9gY9JPBDKZ2u3WKX7RVdpsOJK
         PWfw==
X-Gm-Message-State: APjAAAWlnRMD0GWalRY4Dvij8gUCKG4abecbFQCkZS6bkHlGLjjOLHs4
        kQd6SyDqvTwhacLJIgfwCGi5SM7J60Sqf4MURJxFrmnwLkL+
X-Google-Smtp-Source: APXvYqzmTg903SSJ0TgWcAxahc1LhK5woD2WlskriQoKETXrD12T92bhJSRQKTmj5Tn6pmpZu4SNKXGtO6x8XEC+++Nyy9mQ5Xzs
MIME-Version: 1.0
X-Received: by 2002:a02:6a56:: with SMTP id m22mr11871673jaf.114.1565371327220;
 Fri, 09 Aug 2019 10:22:07 -0700 (PDT)
Date:   Fri, 09 Aug 2019 10:22:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e695c1058fb26925@google.com>
Subject: KASAN: use-after-free Read in rxrpc_send_keepalive
From:   syzbot <syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com>
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

HEAD commit:    b678c568 Merge tag 'nfs-for-5.3-2' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ea5e36600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=d850c266e3df14da1d31
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rxrpc_send_keepalive+0x8a2/0x940  
net/rxrpc/output.c:635
Read of size 8 at addr ffff888064219698 by task kworker/0:3/11077

CPU: 0 PID: 11077 Comm: kworker/0:3 Not tainted 5.3.0-rc3+ #96
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  rxrpc_send_keepalive+0x8a2/0x940 net/rxrpc/output.c:635
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:369 [inline]
  rxrpc_peer_keepalive_worker+0x7be/0xd02 net/rxrpc/peer_event.c:430
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 20465:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
  rxrpc_lookup_local+0x64c/0x1b70 net/rxrpc/local_object.c:279
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

Freed by task 0:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  rxrpc_local_rcu+0x62/0x80 net/rxrpc/local_object.c:471
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2114 [inline]
  rcu_core+0x67f/0x1580 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff888064219680
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 24 bytes inside of
  1024-byte region [ffff888064219680, ffff888064219a80)
The buggy address belongs to the page:
page:ffffea0001908600 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0xffff888064218480 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00025f5a08 ffffea00028fca08 ffff8880aa400c40
raw: ffff888064218480 ffff888064218000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888064219580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888064219600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff888064219680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff888064219700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888064219780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
