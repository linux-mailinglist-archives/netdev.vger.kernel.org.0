Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA84D086F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfJIHjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:39:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36550 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIHjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:39:08 -0400
Received: by mail-io1-f72.google.com with SMTP id g126so3296569iof.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 00:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zKIAbqyielIUj/Mx99zfInV+zgXY3zq3FqATuVVFMf8=;
        b=iTuEb9al1AgLaShj+JvSXFMsRDDSo+v6WoBgzs3XCipzKGL4A/16HfPCV8Gx/NN9/8
         jLyHfF2RMlVDcrZFJNBzWxZ91B2Mo3TN/Sy+45lg0mgaumku1a71Mgzs4NGmXw7Cly2G
         fb26432JCRq3reZYEPyfAE/Jnb4UBzZ091mJUWZ+LrBRvVfJKzyXAI76SHKhLCvyCiJs
         z7Bpamwg7hJlHN8NvwCAwp/FD+tYseaDLOrRxv5cEzpewQEEc0n/W9yuA1GPtYshZG7J
         V+lPwbuM5zRrJBNFf3cc11Wc5t+676YPPaDto4eqnHI7u3IrjjFsiwgO17zwcnddD+yM
         Ko+g==
X-Gm-Message-State: APjAAAXO+9uEH2CEb/xE2ntqBP70RD2PF4PhMPCLt8UnwELPcXKfYLn/
        HXkziFUeh2FsR6UOG+auhkN6I3LBAozWPQ8HfEqpeKk+tpWV
X-Google-Smtp-Source: APXvYqw2p+ZPKiqrYMseQppRA5pkb/NAXpnOXQt+hA7CS450vgEEbF/4zwMavf9Q6Jk/9MNjWWcuxVmcIMcc7vZQVGnkAw8ykKT9
MIME-Version: 1.0
X-Received: by 2002:a02:6508:: with SMTP id u8mr1995940jab.28.1570606747074;
 Wed, 09 Oct 2019 00:39:07 -0700 (PDT)
Date:   Wed, 09 Oct 2019 00:39:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003dc9ba059475614f@google.com>
Subject: KASAN: use-after-free Read in tipc_nl_node_dump_monitor_peer
From:   syzbot <syzbot+d2a8670576fa63d18623@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f9867b51 netdevsim: fix spelling mistake "forbidded" -> "f..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12b32d57600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=d2a8670576fa63d18623
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d3e04f600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a76593600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d2a8670576fa63d18623@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nla_parse_nested_deprecated  
include/net/netlink.h:1166 [inline]
BUG: KASAN: use-after-free in tipc_nl_node_dump_monitor_peer+0x508/0x5c0  
net/tipc/node.c:2493
Read of size 2 at addr ffff888094ee9ad4 by task syz-executor997/9201

CPU: 1 PID: 9201 Comm: syz-executor997 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load2_noabort+0x14/0x20 mm/kasan/generic_report.c:130
  nla_parse_nested_deprecated include/net/netlink.h:1166 [inline]
  tipc_nl_node_dump_monitor_peer+0x508/0x5c0 net/tipc/node.c:2493
  genl_lock_dumpit+0x86/0xc0 net/netlink/genetlink.c:529
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
  __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2352
  genl_family_rcv_msg_dumpit net/netlink/genetlink.c:614 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:710 [inline]
  genl_rcv_msg+0xc9b/0x1000 net/netlink/genetlink.c:730
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:741
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x445239
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 0b cd fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc1aee0468 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000445239
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00000000000110fa R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004023d0
R13: 0000000000402460 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9205:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc_node mm/slab.c:3615 [inline]
  __kmalloc_node_track_caller+0x4e/0x70 mm/slab.c:3629
  __kmalloc_reserve.isra.0+0x40/0xf0 net/core/skbuff.c:141
  __alloc_skb+0x10b/0x5e0 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1049 [inline]
  netlink_alloc_large_skb net/netlink/af_netlink.c:1174 [inline]
  netlink_sendmsg+0x972/0xd60 net/netlink/af_netlink.c:1892
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9205:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  skb_free_head+0x93/0xb0 net/core/skbuff.c:591
  skb_release_data+0x42d/0x7c0 net/core/skbuff.c:611
  skb_release_all+0x4d/0x60 net/core/skbuff.c:665
  __kfree_skb net/core/skbuff.c:679 [inline]
  consume_skb net/core/skbuff.c:838 [inline]
  consume_skb+0xfb/0x3b0 net/core/skbuff.c:832
  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
  netlink_unicast+0x539/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888094ee9ac0
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
  512-byte region [ffff888094ee9ac0, ffff888094ee9cc0)
The buggy address belongs to the page:
page:ffffea000253ba40 refcount:1 mapcount:0 mapping:ffff8880aa400a80  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00024676c8 ffff8880aa401748 ffff8880aa400a80
raw: 0000000000000000 ffff888094ee90c0 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888094ee9980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094ee9a00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ffff888094ee9a80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                  ^
  ffff888094ee9b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888094ee9b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
