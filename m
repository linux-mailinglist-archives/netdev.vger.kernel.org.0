Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E9638E309
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhEXJN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:13:58 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48746 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhEXJNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:13:53 -0400
Received: by mail-io1-f71.google.com with SMTP id y191-20020a6bc8c80000b02904313407018fso26779329iof.15
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:12:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=knsiepNzKLIRV0xuSivy0HpBvp6evnTsTrIM6JnWJt4=;
        b=ADs7XEANv/OOl0uDtWNPgFUvfz09MaELo8qfPNK2uOyi2fVJPe4hpjF7gYxu8vKcNx
         bjfWqXgWCg0/zHal8NTcqAdeEVrCWVI7ZToVAjtQzWh9W37y3tnZB/MzpG2Sbu2V8YbC
         qu+PLLYX35THZZbNoX8sl8kzWcNb27ZDORj1ooIzjQ9dMw0+0SVKFg9PlcbBGtJj3j+C
         AiLgIuysZBzk8BOzwSRSg5mblXiVpVwQsbfo58oc7t5B6qnhx7P0hzvGWCaV30YRoBd/
         poqLaTnh9qA67eDgj7cuMUon4gnbGMo+8oSC2j0XT37TA4tiQqWkNyIixmHSMA4KvCpa
         Gc7w==
X-Gm-Message-State: AOAM530ibXxh+KrG9OssKmatvyiqcgrbCuf3vMpCSjTDHNvNZFuccn+K
        c86pc3GInQIhmUIHw0XcRSF5aLrgpwr8kAnDy/C5QDRiXvuz
X-Google-Smtp-Source: ABdhPJyeF7jAZgF0ywP1DOpyBuuV/h1HGABOyhZh4jPLSfFoqakMVpL95SnY7jie9DkxFDY+DrF7u3RQja60DYBuQLQyHWB6PuhN
MIME-Version: 1.0
X-Received: by 2002:a92:b07:: with SMTP id b7mr13108882ilf.268.1621847545850;
 Mon, 24 May 2021 02:12:25 -0700 (PDT)
Date:   Mon, 24 May 2021 02:12:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9b3aa05c30fce61@google.com>
Subject: [syzbot] KASAN: use-after-free Read in dump_schedule (2)
From:   syzbot <syzbot+a6e609c672ce997c14a8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, leandro.maciel.dorileo@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vedang.patel@intel.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f5120f59 dpaa2-eth: don't print error from dpaa2_mac_conne..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1582989dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b1a53f9a0b5a801
dashboard link: https://syzkaller.appspot.com/bug?extid=a6e609c672ce997c14a8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11924417d00000

The issue was bisected to:

commit 7b9eba7ba0c1b24df42b70b62d154b284befbccf
Author: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Date:   Mon Apr 8 17:12:17 2019 +0000

    net/sched: taprio: fix picos_per_byte miscalculation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1261f09dd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1161f09dd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1661f09dd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6e609c672ce997c14a8@syzkaller.appspotmail.com
Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")

==================================================================
BUG: KASAN: use-after-free in dump_schedule+0x758/0x7d0 net/sched/sch_taprio.c:1837
Read of size 8 at addr ffff888043cca140 by task syz-executor.5/9214

CPU: 1 PID: 9214 Comm: syz-executor.5 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 dump_schedule+0x758/0x7d0 net/sched/sch_taprio.c:1837
 taprio_dump+0x591/0xd80 net/sched/sch_taprio.c:1906
 tc_fill_qdisc+0x60e/0x12a0 net/sched/sch_api.c:917
 qdisc_notify.isra.0+0x2b1/0x310 net/sched/sch_api.c:984
 tc_modify_qdisc+0xf54/0x1a50 net/sched/sch_api.c:1636
 rtnetlink_rcv_msg+0x44e/0xb70 net/core/rtnetlink.c:5550
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fba2214b188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffcc845827f R14: 00007fba2214b300 R15: 0000000000022000

Allocated by task 9193:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc include/linux/slab.h:556 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 taprio_change+0x5fb/0x4030 net/sched/sch_taprio.c:1477
 qdisc_change net/sched/sch_api.c:1332 [inline]
 tc_modify_qdisc+0xd50/0x1a50 net/sched/sch_api.c:1634
 rtnetlink_rcv_msg+0x44e/0xb70 net/core/rtnetlink.c:5550
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 9201:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1581 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1606
 slab_free mm/slub.c:3166 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4225
 rcu_do_batch kernel/rcu/tree.c:2558 [inline]
 rcu_core+0x7ab/0x13b0 kernel/rcu/tree.c:2793
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3038 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
 taprio_change+0x2e82/0x4030 net/sched/sch_taprio.c:1595
 qdisc_change net/sched/sch_api.c:1332 [inline]
 tc_modify_qdisc+0xd50/0x1a50 net/sched/sch_api.c:1634
 rtnetlink_rcv_msg+0x44e/0xb70 net/core/rtnetlink.c:5550
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3038 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
 taprio_change+0x2e82/0x4030 net/sched/sch_taprio.c:1595
 qdisc_change net/sched/sch_api.c:1332 [inline]
 tc_modify_qdisc+0xd50/0x1a50 net/sched/sch_api.c:1634
 rtnetlink_rcv_msg+0x44e/0xb70 net/core/rtnetlink.c:5550
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888043cca100
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 64 bytes inside of
 96-byte region [ffff888043cca100, ffff888043cca160)
The buggy address belongs to the page:
page:ffffea00010f3280 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x43cca
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000886b00 0000001600000016 ffff888011041780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 8489, ts 1045116260415, free_ts 0
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1644 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1784
 new_slab mm/slub.c:1847 [inline]
 new_slab_objects mm/slub.c:2593 [inline]
 ___slab_alloc+0x44c/0x7a0 mm/slub.c:2756
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2796
 slab_alloc_node mm/slub.c:2878 [inline]
 slab_alloc mm/slub.c:2920 [inline]
 __kmalloc+0x315/0x330 mm/slub.c:4063
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 tomoyo_commit_ok+0x1e/0x90 security/tomoyo/memory.c:76
 tomoyo_update_domain+0x5de/0x850 security/tomoyo/domain.c:139
 tomoyo_update_path_number_acl security/tomoyo/file.c:691 [inline]
 tomoyo_write_file+0x68b/0x7f0 security/tomoyo/file.c:1034
 tomoyo_write_domain2+0x116/0x1d0 security/tomoyo/common.c:1152
 tomoyo_add_entry security/tomoyo/common.c:2042 [inline]
 tomoyo_supervisor+0xbc9/0xf00 security/tomoyo/common.c:2103
 tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
 tomoyo_path_number_perm+0x419/0x590 security/tomoyo/file.c:734
 security_file_ioctl+0x50/0xb0 security/security.c:1539
 __do_sys_ioctl fs/ioctl.c:1063 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0xb3/0x200 fs/ioctl.c:1055
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888043cca000: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888043cca080: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>ffff888043cca100: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                           ^
 ffff888043cca180: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888043cca200: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
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
