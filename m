Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C5C1C115C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgEALKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 07:10:14 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48598 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbgEALKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 07:10:13 -0400
Received: by mail-il1-f197.google.com with SMTP id i2so4410449ile.15
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 04:10:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=805zBc87YjZKh++vea6KHONgCzLVRm9bLbOYZJbmGEM=;
        b=SnUgxTLLnFo+fdRKzeWGxy7KQwrR2cWp6ChcRKL5Vgt0L2ZQcXuMpBaG7W+bnh9GeH
         Q4fpb5JbTWJfJRzhR8XvfrZCdgAQlCF7u7PYs5Tpncu7+71vYhhgKIaqkWB6rMOE0Fez
         NyaDuoVetsGB5sH6qGj1tA7h+hBYBZNR13GEX9wUmBKd9hbS+zMHMQupvKPrCegd6e71
         uGL9oXKe+SJ3lBNcaEBKZxOIZW0L9cMqamaiIaggncOsLGgwtuhpntTWVBrNZ/O+Hbo9
         ws+qHnoLGqA9B7lAH9FAZ5k+4NTx5Dd6cpmo/PgLyATvcilTbp6P1h3u9aGRnSG4tuM+
         ls0Q==
X-Gm-Message-State: AGi0Pua24zOZn/lImUkEeHrluoPJL9aMCsjAGMwh3EOJ5C6cb3WokcYG
        vsszdkPNKWYUIQTFnxCpb/pHZyJcvspR9qBb/cnizqFEytXy
X-Google-Smtp-Source: APiQypJXLoz6OkLldVGcPoJsS2tBVjQnuFwa49wLMYRV2HwiAPmx4AurWuYkGPc+S64EZkMaYU1DCw+CGWLgYwrKp12Fy1veOjJU
MIME-Version: 1.0
X-Received: by 2002:a5d:9505:: with SMTP id d5mr3200308iom.185.1588331411970;
 Fri, 01 May 2020 04:10:11 -0700 (PDT)
Date:   Fri, 01 May 2020 04:10:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000989de905a494396b@google.com>
Subject: KASAN: slab-out-of-bounds Read in inet_diag_bc_sk
From:   syzbot <syzbot+ee80f840d9bf6893223b@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, khlebnikov@yandex-team.ru,
        kpsingh@chromium.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    37ecb5b8 hinic: Use kmemdup instead of kzalloc and memcpy
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15f93c4c100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1494ce3fbc02154
dashboard link: https://syzkaller.appspot.com/bug?extid=ee80f840d9bf6893223b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11337a9c100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16f67d40100000

The bug was bisected to:

commit b1f3e43dbfacfcd95296b0f80f84b186add9ef54
Author: Dmitry Yakunin <zeil@yandex-team.ru>
Date:   Thu Apr 30 15:51:15 2020 +0000

    inet_diag: add support for cgroup filter

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10c3ec4c100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12c3ec4c100000
console output: https://syzkaller.appspot.com/x/log.txt?x=14c3ec4c100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ee80f840d9bf6893223b@syzkaller.appspotmail.com
Fixes: b1f3e43dbfac ("inet_diag: add support for cgroup filter")

batman_adv: batadv0: Interface activated: batadv_slave_1
==================================================================
BUG: KASAN: slab-out-of-bounds in __read_once_size include/linux/compiler.h:199 [inline]
BUG: KASAN: slab-out-of-bounds in sock_cgroup_ptr include/linux/cgroup.h:836 [inline]
BUG: KASAN: slab-out-of-bounds in inet_diag_bc_sk+0xb64/0xc70 net/ipv4/inet_diag.c:749
Read of size 8 at addr ffff888093b72260 by task syz-executor021/7043

CPU: 1 PID: 7043 Comm: syz-executor021 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 __read_once_size include/linux/compiler.h:199 [inline]
 sock_cgroup_ptr include/linux/cgroup.h:836 [inline]
 inet_diag_bc_sk+0xb64/0xc70 net/ipv4/inet_diag.c:749
 inet_diag_dump_icsk+0xbe4/0x1306 net/ipv4/inet_diag.c:1061
 __inet_diag_dump+0x8d/0x240 net/ipv4/inet_diag.c:1113
 netlink_dump+0x50b/0xf50 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x63f/0x910 net/netlink/af_netlink.c:2353
 netlink_dump_start include/linux/netlink.h:246 [inline]
 inet_diag_handler_cmd+0x263/0x2c0 net/ipv4/inet_diag.c:1278
 __sock_diag_cmd net/core/sock_diag.c:233 [inline]
 sock_diag_rcv_msg+0x2fe/0x3e0 net/core/sock_diag.c:264
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 sock_diag_rcv+0x26/0x40 net/core/sock_diag.c:275
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 do_iter_readv_writev+0x5a8/0x850 fs/read_write.c:694
 do_iter_write fs/read_write.c:999 [inline]
 do_iter_write+0x18b/0x600 fs/read_write.c:980
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1072
 do_writev+0x27f/0x300 fs/read_write.c:1115
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x443519
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc1c84dbe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443519
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 00007ffc1c84dbf0 R08: 000000000000001c R09: 0000000001bbbbbb
R10: 000000000000001c R11: 0000000000000246 R12: 00007ffc1c84dc00
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 0:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x11b/0x740 mm/slab.c:3484
 dst_alloc+0x103/0x1c0 net/core/dst.c:93
 ip6_dst_alloc+0x2e/0x90 net/ipv6/route.c:355
 icmp6_dst_alloc+0x69/0x460 net/ipv6/route.c:3135
 mld_sendpack+0x5dd/0xdf0 net/ipv6/mcast.c:1671
 mld_send_cr net/ipv6/mcast.c:1978 [inline]
 mld_ifc_timer_expire+0x42e/0x920 net/ipv6/mcast.c:2477
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers kernel/time/timer.c:1774 [inline]
 __run_timers kernel/time/timer.c:1741 [inline]
 run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1787
 __do_softirq+0x26c/0x9f7 kernel/softirq.c:292

Freed by task 9:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kmem_cache_free+0x7f/0x320 mm/slab.c:3694
 dst_destroy+0x27f/0x3a0 net/core/dst.c:129
 rcu_do_batch kernel/rcu/tree.c:2206 [inline]
 rcu_core+0x59f/0x1370 kernel/rcu/tree.c:2433
 __do_softirq+0x26c/0x9f7 kernel/softirq.c:292

The buggy address belongs to the object at ffff888093b72180
 which belongs to the cache ip6_dst_cache of size 224
The buggy address is located 0 bytes to the right of
 224-byte region [ffff888093b72180, ffff888093b72260)
The buggy address belongs to the page:
page:ffffea00024edc80 refcount:1 mapcount:0 mapping:0000000071da7a3c index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000226ef88 ffffea00024e6b88 ffff88809a706700
raw: 0000000000000000 ffff888093b72040 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888093b72100: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888093b72180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888093b72200: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                       ^
 ffff888093b72280: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff888093b72300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
