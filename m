Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871EF2816C6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388014AbgJBPim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:38:42 -0400
Received: from mail-io1-f78.google.com ([209.85.166.78]:49531 "EHLO
        mail-io1-f78.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgJBPiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:38:19 -0400
Received: by mail-io1-f78.google.com with SMTP id k133so1294425iof.16
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yJXYmujX0Sq1pREornVMz/1riL7fnyzKq1XdUIFnDf8=;
        b=ST5Kza73OaWu3ZOk0Fnu/GNJQZaFGunsCtL9Pzqx/qFnGa2QifPKKhN33gConhmTEF
         UU/YwKe+Wys0IPU5W/UFLWeYH8a6wf81sk4SUMsNzSKCRSiWJfE9LV9TTXz0PdiS32xe
         j/oFDmhPMChYHDf1J6OGCLYRmBKzDILHKu9qXv9+p+QG12gWiKeswaGPDT+aWqNxOBO7
         AjD/Bp0j/NX+f9/RWim02NXpMUX/ZEDXzXT1gfk8mYijH9H085avXNGjnAZ7M7M4uYnh
         4EEFJkfFupwnFS4J1XJHp5jRIyuDsgus0MRqPXOKLOugkqhl0Uk0w++966c/luGglYzg
         6gXw==
X-Gm-Message-State: AOAM53028eMqnQaiBPqG+j1W3xTrDJPtZNH74nu9I0K55Xe0gdj6PMbq
        Gn2SZRW56qRw3BJEwIeqikEk/6ilKnsFj2tZA8Y3c2OReKIe
X-Google-Smtp-Source: ABdhPJw7ZAbG8FaVmdvAzfoe82gtJAKcu1UCvedDwGtuyZuVDzuvf5q0LREyTZJUR2oM7hTnzzkRo0UzbpgVw2tkBEI6lfrdmvIs
MIME-Version: 1.0
X-Received: by 2002:a92:d389:: with SMTP id o9mr2362727ilo.52.1601653098549;
 Fri, 02 Oct 2020 08:38:18 -0700 (PDT)
Date:   Fri, 02 Oct 2020 08:38:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fe183705b0b1eb20@google.com>
Subject: KASAN: use-after-free Read in tipc_mcast_xmit (2)
From:   syzbot <syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a59cf619 Merge branch 'Fix-bugs-in-Octeontx2-netdev-driver'
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=163c2467900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99a7c78965c75e07
dashboard link: https://syzkaller.appspot.com/bug?extid=e96a7ba46281824cc46a
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15ada44d900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14007467900000

The issue was bisected to:

commit ff48b6222e65ebdba5a403ef1deba6214e749193
Author: Xin Long <lucien.xin@gmail.com>
Date:   Sun Sep 13 11:37:31 2020 +0000

    tipc: use skb_unshare() instead in tipc_buf_append()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=125402b3900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=115402b3900000
console output: https://syzkaller.appspot.com/x/log.txt?x=165402b3900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com
Fixes: ff48b6222e65 ("tipc: use skb_unshare() instead in tipc_buf_append()")

R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004028a0
R13: 0000000000402930 R14: 0000000000000000 R15: 0000000000000000
tipc: Failed do clone local mcast rcv buffer
==================================================================
BUG: KASAN: use-after-free in __skb_unlink include/linux/skbuff.h:2063 [inline]
BUG: KASAN: use-after-free in __skb_dequeue include/linux/skbuff.h:2082 [inline]
BUG: KASAN: use-after-free in __skb_queue_purge include/linux/skbuff.h:2793 [inline]
BUG: KASAN: use-after-free in tipc_mcast_xmit+0xfaa/0x1170 net/tipc/bcast.c:422
Read of size 8 at addr ffff8880a73e2040 by task syz-executor657/6887

CPU: 1 PID: 6887 Comm: syz-executor657 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __skb_unlink include/linux/skbuff.h:2063 [inline]
 __skb_dequeue include/linux/skbuff.h:2082 [inline]
 __skb_queue_purge include/linux/skbuff.h:2793 [inline]
 tipc_mcast_xmit+0xfaa/0x1170 net/tipc/bcast.c:422
 tipc_sendmcast+0xaaf/0xef0 net/tipc/socket.c:865
 __tipc_sendmsg+0xee3/0x18a0 net/tipc/socket.c:1454
 tipc_sendmsg+0x4c/0x70 net/tipc/socket.c:1387
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4419d9
Code: e8 cc ac 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe0cace4c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004419d9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000004
RBP: 000000000000f0ee R08: 0000000000000001 R09: 0000000000402930
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004028a0
R13: 0000000000402930 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6887:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:518 [inline]
 slab_alloc_node mm/slab.c:3254 [inline]
 kmem_cache_alloc_node+0x136/0x430 mm/slab.c:3574
 __alloc_skb+0x71/0x550 net/core/skbuff.c:198
 alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
 tipc_buf_acquire+0x28/0xf0 net/tipc/msg.c:76
 tipc_msg_build+0x6b8/0x10c0 net/tipc/msg.c:428
 tipc_sendmcast+0x855/0xef0 net/tipc/socket.c:859
 __tipc_sendmsg+0xee3/0x18a0 net/tipc/socket.c:1454
 tipc_sendmsg+0x4c/0x70 net/tipc/socket.c:1387
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6887:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kmem_cache_free.part.0+0x74/0x1e0 mm/slab.c:3693
 kfree_skbmem+0x166/0x1b0 net/core/skbuff.c:643
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 tipc_buf_append+0x6dc/0xcf0 net/tipc/msg.c:198
 tipc_msg_reassemble+0x175/0x4f0 net/tipc/msg.c:790
 tipc_mcast_xmit+0x699/0x1170 net/tipc/bcast.c:386
 tipc_sendmcast+0xaaf/0xef0 net/tipc/socket.c:865
 __tipc_sendmsg+0xee3/0x18a0 net/tipc/socket.c:1454
 tipc_sendmsg+0x4c/0x70 net/tipc/socket.c:1387
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a73e2040
 which belongs to the cache skbuff_fclone_cache of size 456
The buggy address is located 0 bytes inside of
 456-byte region [ffff8880a73e2040, ffff8880a73e2208)
The buggy address belongs to the page:
page:000000001368f319 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xa73e2
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffff8880a9050f50 ffffea00028ff188 ffff8880a903dc00
raw: 0000000000000000 ffff8880a73e2040 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a73e1f00: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
 ffff8880a73e1f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a73e2000: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                           ^
 ffff8880a73e2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a73e2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
