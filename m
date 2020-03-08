Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6627817D6D8
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgCHWoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:44:18 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:40487 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHWoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:44:17 -0400
Received: by mail-il1-f198.google.com with SMTP id g79so2741136ild.7
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=M0KtNvUI/mym2mipHOWfUV+46mfNylBTB0C7uyOuZNM=;
        b=hNFn/J3u9XfnXm+yJ61o0O6RJ7PbL5eZcPkMy3u5puRVbUyTX0U3dfmCGbXJOyH5rP
         ILUyIeh4BCEZNxwL07VmZ7L/N4EVFIAsiGKabBFdYZRMosQENQXNo4UsRvqg75n3xVHe
         9Zjr2Sw+9MTPx5j//tSE6IVlGIxQQSdWLRFPdW3CYPCaX2pJar3X+DG7+nePATc90gao
         YNkAGp9HFePtJlnxa+c6ULCTqMNlx/7Wk3jynzkgZKY9fZwjixmtCneaepG+/ZIZR4OB
         V0aslwQOFqNrCjdHX2ihZOe9Wklm95+2U1wb7Vwm2p0F+23+NPd53MGwD6nq/zwMaZ0O
         oEaQ==
X-Gm-Message-State: ANhLgQ3n/aZ8a/wHyeW/40R4xuQJAlxHL3Y3oFV6dv3sPitfigTSH2Ww
        YziXnjszoJgMPs5AuJ6NxdUw4Xadsag0+xtB76pk8T4R+OjB
X-Google-Smtp-Source: ADFU+vsjKB/0E9V38FTl0tyZTmWJnY66oMCgY/4yOHTZ52/uFcanPpzlCirAZdiS0apU2Q3/NW3dDy/VUFVvA7C24ChlFW91SWln
MIME-Version: 1.0
X-Received: by 2002:a92:216:: with SMTP id 22mr13058589ilc.53.1583707455029;
 Sun, 08 Mar 2020 15:44:15 -0700 (PDT)
Date:   Sun, 08 Mar 2020 15:44:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000490abd05a05fa060@google.com>
Subject: KASAN: slab-out-of-bounds Write in tcindex_set_parms
From:   syzbot <syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    425c075d Merge branch 'tun-debug'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=134d2ae3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=598678fc6e800071
dashboard link: https://syzkaller.appspot.com/bug?extid=c72da7b9ed57cde6fca2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122ed70de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116689fde00000

The bug was bisected to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=150a7d53e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=170a7d53e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=130a7d53e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: slab-out-of-bounds in tcindex_set_parms+0x17fd/0x1a00 net/sched/cls_tcindex.c:455
Write of size 16 at addr ffff8880a219e6b8 by task syz-executor508/9705

CPU: 1 PID: 9705 Comm: syz-executor508 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 tcindex_set_parms+0x17fd/0x1a00 net/sched/cls_tcindex.c:455
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5431
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440eb9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffef61bf118 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a2690 RCX: 0000000000440eb9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000004a2690 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004023c0
R13: 0000000000402450 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9705:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 tcindex_set_parms+0x1f1/0x1a00 net/sched/cls_tcindex.c:325
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5431
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2501:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 call_usermodehelper_freeinfo kernel/umh.c:48 [inline]
 umh_complete kernel/umh.c:62 [inline]
 umh_complete+0x81/0x90 kernel/umh.c:51
 call_usermodehelper_exec_async+0x459/0x710 kernel/umh.c:122
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a219e600
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 184 bytes inside of
 192-byte region [ffff8880a219e600, ffff8880a219e6c0)
The buggy address belongs to the page:
page:ffffea0002886780 refcount:1 mapcount:0 mapping:ffff8880aa000000 index:0xffff8880a219ef00
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002882b88 ffff8880aa001138 ffff8880aa000000
raw: ffff8880a219ef00 ffff8880a219e000 000000010000000b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a219e580: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a219e600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880a219e680: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 ffff8880a219e700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a219e780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
