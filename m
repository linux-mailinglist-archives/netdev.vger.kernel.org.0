Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2525C708
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgICQhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:37:22 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49709 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgICQhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:37:20 -0400
Received: by mail-io1-f71.google.com with SMTP id k133so2429568iof.16
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 09:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=g7LWrEEzS7K4SBthHufKEANswDJugXnsabtvbwG0OdM=;
        b=fGWDIVPmKZiRC19E7H1a9bRN6x+UL9oS0ueE+xwPtlcsRwZEqBpMVNXpqz1xT+tDlZ
         zMe23Rm3tAsYO8rsUTvw45c4Jv3d6KbGlczeiNLutwfjFOHBcRbDVj5NTxyaIha4Fc2k
         afIa84Mfsw7x8i3Wm+pu/zgtWPUcfNkrTAFNV3B/tbGcNAYLwCasGR0CFAZb+uY89o0H
         IPpu3Oezc5YaQarYlvvaXNt2TtIceT9nnavUET89oOryYsEVZazXUaUkkUXfPMGZAuwX
         zsyRYZ5Ozf7DjNDqW3U/XszHRsJAYrEQhQ5uhkDKyiBwTeA5pjv5MuFaBzliuMZ5wNUi
         A4WQ==
X-Gm-Message-State: AOAM531h26Gb0n0kgA/AxgR5P7OFMcrpUc62XHiPDw4XNQ1aBareFCkB
        rSVPknB6OEUC2MEwbeMScHv9ZKn36FwMHr+2BmOQ70dz4sPQ
X-Google-Smtp-Source: ABdhPJwTM/CPP/PUd30y5J9pwOG53XOrDzAAb58mxHQyiXBP8X3gxSmsiQSrjKbcyDRBzuSxUrChIlqlvjMQkd8Zcbs2yaXwwXIC
MIME-Version: 1.0
X-Received: by 2002:a92:194b:: with SMTP id e11mr4200423ilm.133.1599151039271;
 Thu, 03 Sep 2020 09:37:19 -0700 (PDT)
Date:   Thu, 03 Sep 2020 09:37:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a358f905ae6b5dc6@google.com>
Subject: KASAN: use-after-free Read in dump_schedule
From:   syzbot <syzbot+621fd33c0b53d15ee8de@syzkaller.appspotmail.com>
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

syzbot found the following issue on:

HEAD commit:    fc3abb53 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b672f5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1c560d0f4e121c9
dashboard link: https://syzkaller.appspot.com/bug?extid=621fd33c0b53d15ee8de
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1129d0e9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fb6a25900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+621fd33c0b53d15ee8de@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in dump_schedule+0x4b/0x850 net/sched/sch_taprio.c:1747
Read of size 8 at addr ffff88808f48cb40 by task syz-executor466/11250

CPU: 0 PID: 11250 Comm: syz-executor466 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 dump_schedule+0x4b/0x850 net/sched/sch_taprio.c:1747
 taprio_dump+0x701/0xcc0 net/sched/sch_taprio.c:1815
 tc_fill_qdisc+0x5c5/0x1150 net/sched/sch_api.c:916
 qdisc_notify+0x1df/0x370 net/sched/sch_api.c:983
 tc_modify_qdisc+0x1b1a/0x1d90 net/sched/sch_api.c:1635
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 kernel_sendmsg+0xe2/0x120 net/socket.c:691
 sock_no_sendpage+0xe0/0x120 net/core/sock.c:2852
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0xd0/0x120 net/socket.c:944
 pipe_to_sendpage+0x208/0x2d0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x351/0x8b0 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x112/0x180 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 do_splice+0xdd1/0x1a50 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1419 [inline]
 __se_sys_splice fs/splice.c:1401 [inline]
 __x64_sys_splice+0x14f/0x1f0 fs/splice.c:1401
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x449fa9
Code: e8 9c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 04 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa469406d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00000000006e0c48 RCX: 0000000000449fa9
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006e0c40 R08: 0000000000010973 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e0c4c
R13: 140b0024000000a4 R14: 0000000000000000 R15: 000000306d616574

Allocated by task 11229:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x1e4/0x2e0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 taprio_change+0x3b5/0x5200 net/sched/sch_taprio.c:1436
 qdisc_change net/sched/sch_api.c:1331 [inline]
 tc_modify_qdisc+0x1793/0x1d90 net/sched/sch_api.c:1633
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 kernel_sendmsg+0xe2/0x120 net/socket.c:691
 sock_no_sendpage+0xe0/0x120 net/core/sock.c:2852
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0xd0/0x120 net/socket.c:944
 pipe_to_sendpage+0x208/0x2d0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x351/0x8b0 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x112/0x180 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 do_splice+0xdd1/0x1a50 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1419 [inline]
 __se_sys_splice fs/splice.c:1401 [inline]
 __x64_sys_splice+0x14f/0x1f0 fs/splice.c:1401
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 9:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x113/0x200 mm/slab.c:3756
 rcu_do_batch kernel/rcu/tree.c:2428 [inline]
 rcu_core+0x79b/0x1130 kernel/rcu/tree.c:2656
 __do_softirq+0x256/0x6d5 kernel/softirq.c:298

Last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0x7b/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x141/0x830 kernel/rcu/tree.c:2968
 taprio_change+0x4202/0x5200 net/sched/sch_taprio.c:1554
 qdisc_change net/sched/sch_api.c:1331 [inline]
 tc_modify_qdisc+0x1793/0x1d90 net/sched/sch_api.c:1633
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 kernel_sendmsg+0xe2/0x120 net/socket.c:691
 sock_no_sendpage+0xe0/0x120 net/core/sock.c:2852
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0xd0/0x120 net/socket.c:944
 pipe_to_sendpage+0x208/0x2d0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x351/0x8b0 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x112/0x180 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 do_splice+0xdd1/0x1a50 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1419 [inline]
 __se_sys_splice fs/splice.c:1401 [inline]
 __x64_sys_splice+0x14f/0x1f0 fs/splice.c:1401
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0x7b/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x141/0x830 kernel/rcu/tree.c:2968
 taprio_change+0x4202/0x5200 net/sched/sch_taprio.c:1554
 qdisc_change net/sched/sch_api.c:1331 [inline]
 tc_modify_qdisc+0x1793/0x1d90 net/sched/sch_api.c:1633
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 kernel_sendmsg+0xe2/0x120 net/socket.c:691
 sock_no_sendpage+0xe0/0x120 net/core/sock.c:2852
 kernel_sendpage net/socket.c:3642 [inline]
 sock_sendpage+0xd0/0x120 net/socket.c:944
 pipe_to_sendpage+0x208/0x2d0 fs/splice.c:448
 splice_from_pipe_feed fs/splice.c:502 [inline]
 __splice_from_pipe+0x351/0x8b0 fs/splice.c:626
 splice_from_pipe fs/splice.c:661 [inline]
 generic_splice_sendpage+0x112/0x180 fs/splice.c:834
 do_splice_from fs/splice.c:846 [inline]
 do_splice+0xdd1/0x1a50 fs/splice.c:1144
 __do_sys_splice fs/splice.c:1419 [inline]
 __se_sys_splice fs/splice.c:1401 [inline]
 __x64_sys_splice+0x14f/0x1f0 fs/splice.c:1401
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88808f48cb00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 64 bytes inside of
 96-byte region [ffff88808f48cb00, ffff88808f48cb60)
The buggy address belongs to the page:
page:00000000cae6299d refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88808f48cd00 pfn:0x8f48c
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002761e08 ffffea000275d888 ffff8880aa440300
raw: ffff88808f48cd00 ffff88808f48c000 000000010000001a 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808f48ca00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88808f48ca80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff88808f48cb00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                           ^
 ffff88808f48cb80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
 ffff88808f48cc00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
