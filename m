Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB7FE752F
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbfJ1PcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:32:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54136 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ1PcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:32:09 -0400
Received: by mail-io1-f69.google.com with SMTP id w8so8592346iol.20
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 08:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UegRxERUIJE6YexgxVScHPCKly7vZIEe9nnAYl/GsmY=;
        b=Afw1PgTLD7/Y1eBzrzTpxRRzAKCHyHvh/AlvorkEZxjQ2ZlFv1jq3GxwMUqHtABHhS
         bivTx9BKLkpQ2Ps7I+v8oOjVjq+s1c9RzcgQvT/LEJLDH0N/Sn96o198UZJm42PBWtp7
         c7tO2RrQggv+ZP+kwuYLh+AX5ohOeZEeKC69nHOVSaniSOE7OkVYV35Bb0XPE2LH+so5
         3hPJ4PCRccekSFv0+c6IE1sys3zYeDuc4YaN3CGt60ughrMGBcMz3xzBBOxlRzEeI/pO
         AWKpMzU16pQO9gc9/mX4M73FW+fZ1sfe/QArwoxHrELzuAp9I+Xqr00y6OXWY+TuOcve
         RB1g==
X-Gm-Message-State: APjAAAUCswWQUXd2RG7J0t7hZ4M00NN7m//C6qmsmrDLp+ux+jadDK1n
        dXGbHe61NlZIBRtFt0ChSagKpc4/LVm2n0TYPe43KLioP9qW
X-Google-Smtp-Source: APXvYqwsR+CCvbEHUNa9ci6T79SOTTjlgQOMb15P2zf5pEeP/Ti9QlHt8mys0VnwQ1JNKx0kZZZhjfgGD7cnpJpMdm4k2tFkOCcW
MIME-Version: 1.0
X-Received: by 2002:a6b:fb0c:: with SMTP id h12mr11135428iog.239.1572276728660;
 Mon, 28 Oct 2019 08:32:08 -0700 (PDT)
Date:   Mon, 28 Oct 2019 08:32:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e68ee20595fa33be@google.com>
Subject: KASAN: use-after-free Read in sctp_sock_dump
From:   syzbot <syzbot+e5b57b8780297657b25b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, roid@mellanox.com, saeedm@mellanox.com,
        syzkaller-bugs@googlegroups.com, vladbu@mellanox.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d6d5df1d Linux 5.4-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ef5a70e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2bcb64e504d04eff
dashboard link: https://syzkaller.appspot.com/bug?extid=e5b57b8780297657b25b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cd8800e00000

The bug was bisected to:

commit 61086f391044fd587af9d70a9b8f6f800dd474ba
Author: Vlad Buslov <vladbu@mellanox.com>
Date:   Fri Aug 2 19:21:56 2019 +0000

     net/mlx5e: Protect encap hash table with mutex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135960af600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10d960af600000
console output: https://syzkaller.appspot.com/x/log.txt?x=175960af600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e5b57b8780297657b25b@syzkaller.appspotmail.com
Fixes: 61086f391044 ("net/mlx5e: Protect encap hash table with mutex")

==================================================================
BUG: KASAN: use-after-free in sctp_sock_dump+0xaa3/0xb20 net/sctp/diag.c:311
Read of size 8 at addr ffff88808231c498 by task syz-executor.5/28263

CPU: 0 PID: 28263 Comm: syz-executor.5 Not tainted 5.4.0-rc5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  sctp_sock_dump+0xaa3/0xb20 net/sctp/diag.c:311
  sctp_for_each_transport+0x2b4/0x350 net/sctp/socket.c:5404
  sctp_diag_dump+0x33e/0x450 net/sctp/diag.c:513
  __inet_diag_dump+0x9e/0x130 net/ipv4/inet_diag.c:1055
  inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1071
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
  __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2352
  netlink_dump_start include/linux/netlink.h:233 [inline]
  inet_diag_handler_cmd+0x262/0x320 net/ipv4/inet_diag.c:1176
  __sock_diag_cmd net/core/sock_diag.c:233 [inline]
  sock_diag_rcv_msg+0x319/0x410 net/core/sock_diag.c:264
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  sock_diag_rcv+0x2b/0x40 net/core/sock_diag.c:275
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  sock_write_iter+0x27c/0x3e0 net/socket.c:989
  call_write_iter include/linux/fs.h:1895 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  compat_writev+0x1f1/0x390 fs/read_write.c:1295
  do_compat_writev+0xf5/0x1f0 fs/read_write.c:1316
  __do_compat_sys_writev fs/read_write.c:1327 [inline]
  __se_compat_sys_writev fs/read_write.c:1323 [inline]
  __ia32_compat_sys_writev+0x74/0xb0 fs/read_write.c:1323
  do_syscall_32_irqs_on arch/x86/entry/common.c:333 [inline]
  do_fast_syscall_32+0x27b/0xdb3 arch/x86/entry/common.c:404
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fd7a39
Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c  
24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f7f4f0cc EFLAGS: 00000296 ORIG_RAX: 0000000000000092
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000240
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 28250:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  sctp_endpoint_new+0x79/0xb90 net/sctp/endpointola.c:133
  sctp_init_sock+0xc2a/0x1360 net/sctp/socket.c:5089
  inet6_create net/ipv6/af_inet6.c:253 [inline]
  inet6_create+0x9c0/0xf80 net/ipv6/af_inet6.c:107
  __sock_create+0x3d8/0x730 net/socket.c:1418
  sock_create net/socket.c:1469 [inline]
  __sys_socket+0x103/0x220 net/socket.c:1511
  __do_sys_socket net/socket.c:1520 [inline]
  __se_sys_socket net/socket.c:1518 [inline]
  __ia32_sys_socket+0x73/0xb0 net/socket.c:1518
  do_syscall_32_irqs_on arch/x86/entry/common.c:333 [inline]
  do_fast_syscall_32+0x27b/0xdb3 arch/x86/entry/common.c:404
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 28245:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  sctp_endpoint_destroy net/sctp/endpointola.c:219 [inline]
  sctp_endpoint_put+0x1a7/0x210 net/sctp/endpointola.c:235
  sctp_endpoint_free+0x77/0x90 net/sctp/endpointola.c:182
  sctp_destroy_sock+0x9f/0x3e0 net/sctp/socket.c:5142
  sctp_v6_destroy_sock+0x16/0x30 net/sctp/socket.c:9523
  sk_common_release+0x6b/0x340 net/core/sock.c:3172
  sctp_close+0x4f6/0x880 net/sctp/socket.c:1537
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  get_signal+0x2078/0x2500 kernel/signal.c:2528
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:348 [inline]
  do_fast_syscall_32+0xb87/0xdb3 arch/x86/entry/common.c:404
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

The buggy address belongs to the object at ffff88808231c400
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 152 bytes inside of
  512-byte region [ffff88808231c400, ffff88808231c600)
The buggy address belongs to the page:
page:ffffea000208c700 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0xffff88808231cc00
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002873c88 ffffea000238f708 ffff8880aa400a80
raw: ffff88808231cc00 ffff88808231c000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808231c380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88808231c400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88808231c480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff88808231c500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88808231c580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
