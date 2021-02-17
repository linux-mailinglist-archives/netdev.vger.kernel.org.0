Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A1431DE35
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhBQRba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:31:30 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:43368 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhBQRbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:31:04 -0500
Received: by mail-io1-f71.google.com with SMTP id d8so12360537ion.10
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:30:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/f8kdQ17suhc3GX94l/5Ovpsj5NEQyjH7MSpp7PV+NE=;
        b=WlbcV8XP8bo6F/xiDBsVSSmTv35fg4bDkzwfa6waDa+n0kkTST0oGkE2FKH+XRjs6q
         hcTn39SCxMk8xl0H5Uma047bmw17AhmOXKDcL7rvSMFz0qZlGkrkiVGRgv0IKa9tl0B1
         FxmOjEHlpb648Ey9TY9Hkt4j6rShzMmbGfMPYdcqLA0kziS0IQI4koqCNPGILy0hP3Li
         BGnzipBGj8BKfX2WEDpL2MiHtNKsemNXuUv7XYMOGVk2zxXtEYOmWZ8ap/54RNHT2hJJ
         VSFNmqs4fYVe/bTO8pdOnTSME+HMsT+wW/nnxs5QqHZS8EraA0DVTZEQddtMa9rMecqs
         AJxA==
X-Gm-Message-State: AOAM533Bi2/s1xmPiuvyismG/OkGezn2qWzNPyG0ZiAxllDa8/CjD7T9
        lmROZ0g9/MXip8rVhzx3BwOq9Q15SihNiG65ZKFy/KntoA0u
X-Google-Smtp-Source: ABdhPJynutnaLMSBn6ZA4je8OPa/XEFAbnWWl0SCKx7ylYvrOAhPUUL4F5kWXCAlK0n+5+1idPRB3Wo8yNIxevGus7c/y606DDdr
MIME-Version: 1.0
X-Received: by 2002:a92:dccc:: with SMTP id b12mr142714ilr.86.1613583023246;
 Wed, 17 Feb 2021 09:30:23 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:30:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea934b05bb8b92cf@google.com>
Subject: KASAN: use-after-free Read in mptcp_established_options
From:   syzbot <syzbot+3c1e5ab4997849b69807@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    966df6de lan743x: sync only the received area of an rx rin..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11afe082d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=3c1e5ab4997849b69807

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3c1e5ab4997849b69807@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in mptcp_check_fallback net/mptcp/protocol.h:745 [inline]
BUG: KASAN: use-after-free in mptcp_established_options+0x22cf/0x2780 net/mptcp/options.c:724
Read of size 8 at addr ffff88802bea10a0 by task syz-executor.1/11042

CPU: 1 PID: 11042 Comm: syz-executor.1 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 mptcp_check_fallback net/mptcp/protocol.h:745 [inline]
 mptcp_established_options+0x22cf/0x2780 net/mptcp/options.c:724
 tcp_established_options+0x4ed/0x700 net/ipv4/tcp_output.c:953
 tcp_current_mss+0x1d2/0x360 net/ipv4/tcp_output.c:1840
 tcp_send_mss+0x28/0x2b0 net/ipv4/tcp.c:943
 mptcp_sendmsg_frag+0x13b/0x1220 net/mptcp/protocol.c:1266
 mptcp_push_pending+0x2cc/0x650 net/mptcp/protocol.c:1477
 mptcp_sendmsg+0xde4/0x2830 net/mptcp/protocol.c:1685
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:642
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:999
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x1ee/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465d99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff231ccc188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000465d99
RDX: 000000000003f9b4 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00000000004bcf27 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007ffeaa2da27f R14: 00007ff231ccc300 R15: 0000000000022000

Allocated by task 11017:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kmalloc include/linux/slab.h:552 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 subflow_create_ctx+0x82/0x230 net/mptcp/subflow.c:1378
 subflow_ulp_init+0x62/0x370 net/mptcp/subflow.c:1459
 __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
 tcp_set_ulp+0x27c/0x610 net/ipv4/tcp_ulp.c:160
 mptcp_subflow_create_socket+0x5bf/0xe20 net/mptcp/subflow.c:1343
 __mptcp_socket_create net/mptcp/protocol.c:110 [inline]
 mptcp_init_sock net/mptcp/protocol.c:2365 [inline]
 mptcp_init_sock+0x140/0x830 net/mptcp/protocol.c:2350
 inet6_create net/ipv6/af_inet6.c:256 [inline]
 inet6_create+0xa15/0x1010 net/ipv6/af_inet6.c:110
 __sock_create+0x3de/0x780 net/socket.c:1406
 sock_create net/socket.c:1457 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1499
 __do_sys_socket net/socket.c:1508 [inline]
 __se_sys_socket net/socket.c:1506 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1506
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 10650:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:192 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3143 [inline]
 kmem_cache_free_bulk mm/slub.c:3269 [inline]
 kmem_cache_free_bulk+0x253/0xc80 mm/slub.c:3256
 kfree_bulk include/linux/slab.h:409 [inline]
 kfree_rcu_work+0x4cd/0x860 kernel/rcu/tree.c:3226
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff88802bea1000
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 160 bytes inside of
 256-byte region [ffff88802bea1000, ffff88802bea1100)
The buggy address belongs to the page:
page:0000000026103328 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2bea0
head:0000000026103328 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c413c0
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802bea0f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802bea1000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802bea1080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff88802bea1100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802bea1180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
