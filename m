Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2E71429A5
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 12:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATLhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 06:37:11 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:33725 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgATLhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 06:37:10 -0500
Received: by mail-il1-f198.google.com with SMTP id s9so24893470ilk.0
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 03:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xBNA/KgA2wagbqF/XqH/qEY6DtCxvfx3ozrZJF+FY60=;
        b=m+amfPOEBf3FYz10G2FnAT13EmG7p1h9jOB5Lx2p6kgyazxvb77pX+frSCO3+zpsYL
         MGaEmRyZA4crvIsGxJ9nMnWm0mw9NT2ruTv7BQ6yy55hxaTCHOfIyFEOZ8gzAnU4LVK2
         IWIHoxsiix0h2ownOdMxwLYqlYZHodtXqjI/zc4bVA5GMyDrlTcxOzIL5jB+U27IEUWV
         kR7yyNYS01v9XLPvBdDU5+11RtjLLcmUhfHmgTv+77duZcVVnmqbqc6jSVO3gs+G770d
         mFllf3Vvx09AuVDjDym1G0OWcOASwn7lPhNc2rsHLmsVjUtBmU2suIy8gPULMHO/SwcY
         V9yQ==
X-Gm-Message-State: APjAAAWtM/oWNBeB1OI34QEc+lQ4QMfBvaZ+51R+FboDesN31cppkokF
        TiDyxRocVQL8OMnBJVKS+ZOTbc6UrUfqzRnfKfyiVLrPju3B
X-Google-Smtp-Source: APXvYqyyPInJ+VE6VgIJfo5d2Ws7ikGEU73uOM4B1N5bMf4CHCMYDRODgnN2k8anBIa46t0NiOGKRSQS7YC+o+aTZIQrTvvoMu9G
MIME-Version: 1.0
X-Received: by 2002:a92:db4f:: with SMTP id w15mr10001596ilq.182.1579520229796;
 Mon, 20 Jan 2020 03:37:09 -0800 (PST)
Date:   Mon, 20 Jan 2020 03:37:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000367175059c90b6bf@google.com>
Subject: KASAN: use-after-free Read in __nf_tables_abort
From:   syzbot <syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    def9d278 Linux 5.5-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d4e966e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf8e288883e40aba
dashboard link: https://syzkaller.appspot.com/bug?extid=29125d208b3dae9a7019
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c78faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0xd2/0xf5 lib/list_debug.c:42
Read of size 8 at addr ffff888096085408 by task syz-executor.0/9949

CPU: 0 PID: 9949 Comm: syz-executor.0 Not tainted 5.5.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
 __list_del_entry_valid+0xd2/0xf5 lib/list_debug.c:42
 __list_del_entry include/linux/list.h:131 [inline]
 list_del_rcu include/linux/rculist.h:148 [inline]
 __nf_tables_abort+0x1e53/0x2a50 net/netfilter/nf_tables_api.c:7258
 nf_tables_abort+0x17/0x30 net/netfilter/nf_tables_api.c:7373
 nfnetlink_rcv_batch+0xa5d/0x17a0 net/netfilter/nfnetlink.c:494
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f29992c7c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f29992c86d4 RCX: 000000000045b349
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000917 R14: 00000000004ca810 R15: 000000000075bf2c

Allocated by task 9949:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 nf_tables_newtable+0xa4d/0x1510 net/netfilter/nf_tables_api.c:981
 nfnetlink_rcv_batch+0xf42/0x17a0 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2840:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 nf_tables_table_destroy.isra.0+0xef/0x150 net/netfilter/nf_tables_api.c:1160
 nft_commit_release net/netfilter/nf_tables_api.c:6810 [inline]
 nf_tables_trans_destroy_work+0x406/0x7c0 net/netfilter/nf_tables_api.c:6860
 process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888096085400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 8 bytes inside of
 512-byte region [ffff888096085400, ffff888096085600)
The buggy address belongs to the page:
page:ffffea0002582140 refcount:1 mapcount:0 mapping:ffff8880aa400a80 index:0x0
raw: 00fffe0000000200 ffffea0002402a88 ffffea000294a748 ffff8880aa400a80
raw: 0000000000000000 ffff888096085000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888096085300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888096085380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888096085400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888096085480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888096085500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
