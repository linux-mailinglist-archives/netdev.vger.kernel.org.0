Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED5A180B4C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgCJWPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:15:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:52641 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgCJWPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:15:17 -0400
Received: by mail-il1-f200.google.com with SMTP id d2so10910156ilf.19
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=84Qll/dlvjLD8CKSDBpk24SgnTCJ2Jz6eCDGbYrKR6M=;
        b=qmy0HEHfyBig95MhM1gMFobTM/wzTtgCCSHPMl7VVF1qssyfTGzvU30iLg/llZ5MDK
         EyidLqShgm2XuXW5to+L/7EA7jGf3RKlFhjamrF8JXDkRe+JgaCTybPQ7ctc175l5oqw
         mS57e5DHsIr4GQuTosUD1jr8vHXjVYk9AP90WeoD6iJGpkWyeXWWlCYBwSTjSCndDb82
         ij9HwxO7k72SglFnmXvic3zK7oO59g6dAU3te2rP7nz9dCJyz4Dj6TxOURx5OPkEDGSo
         4wBzddhFcBfGb2HLYbXI8G+AQRUVm8g2/+E/HvVtKRVQaVN+hT0nRCJemOZKcRfzvdZZ
         HKFQ==
X-Gm-Message-State: ANhLgQ3PWB+irJSjIcFctaAp3923fsK5gDPwaMa+dMFrBq0WH2PQQmTl
        +KELJnh0LEkmaxJuq3hyCShNP+guGqx3f1y9fe52+ZpSp/WU
X-Google-Smtp-Source: ADFU+vuYOs9m+t/8m6YXsqaahK0LT1iDnXctxC8s0+uVCmTvZEB7HBEuRmjFGwYUuu3HdpWapyz+TgHH1fAI8lMe09pqO20GxIVP
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr264198ilj.0.1583878516849;
 Tue, 10 Mar 2020 15:15:16 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:15:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005d435905a0877414@google.com>
Subject: KASAN: use-after-free Write in tcindex_set_parms
From:   syzbot <syzbot+e5db00b3987d59130da5@syzkaller.appspotmail.com>
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

HEAD commit:    30bb5572 Merge tag 'ktest-v5.6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15bae581e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=e5db00b3987d59130da5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fe8219e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129e5439e00000

The bug was bisected to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=141c1dfde00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=161c1dfde00000
console output: https://syzkaller.appspot.com/x/log.txt?x=121c1dfde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e5db00b3987d59130da5@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: use-after-free in tcindex_set_parms+0x17fd/0x1a00 net/sched/cls_tcindex.c:455
Write of size 16 at addr ffff8880a86d28b8 by task syz-executor352/9506

CPU: 0 PID: 9506 Comm: syz-executor352 Not tainted 5.6.0-rc5-syzkaller #0
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
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440eb9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc66658278 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004a2690 RCX: 0000000000440eb9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000004a2690 R08: 0000000120080522 R09: 0000000120080522
R10: 0000000120080522 R11: 0000000000000246 R12: 00000000004023c0
R13: 0000000000402450 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 1:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 call_usermodehelper_setup+0x98/0x300 kernel/umh.c:386
 kobject_uevent_env+0xcfb/0x11f0 lib/kobject_uevent.c:613
 kernel_add_sysfs_param kernel/params.c:797 [inline]
 param_sysfs_builtin kernel/params.c:832 [inline]
 param_sysfs_init+0x3c5/0x430 kernel/params.c:953
 do_one_initcall+0x10a/0x7d0 init/main.c:1152
 do_initcall_level init/main.c:1225 [inline]
 do_initcalls init/main.c:1241 [inline]
 do_basic_setup init/main.c:1261 [inline]
 kernel_init_freeable+0x501/0x5ae init/main.c:1445
 kernel_init+0xd/0x1bb init/main.c:1352
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 562:
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

The buggy address belongs to the object at ffff8880a86d2800
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 184 bytes inside of
 192-byte region [ffff8880a86d2800, ffff8880a86d28c0)
The buggy address belongs to the page:
page:ffffea0002a1b480 refcount:1 mapcount:0 mapping:ffff8880aa000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00028da348 ffff8880aa001148 ffff8880aa000000
raw: 0000000000000000 ffff8880a86d2000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a86d2780: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a86d2800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880a86d2880: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                        ^
 ffff8880a86d2900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a86d2980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
