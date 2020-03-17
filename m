Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AD9188BA0
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCQRHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:07:12 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56009 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgCQRHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:07:12 -0400
Received: by mail-io1-f69.google.com with SMTP id k5so14470775ioa.22
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 10:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7KdZfoOYN4gRS0oH0w8c/jmQngODpEYTiEryLZllDF0=;
        b=AL+z5CaajDkM0zw3iHey+w7owjGgv6sKHMh/UW3h8YgFBFRGIktZge7BBEs5DNlLF4
         x4k/xxLfioaY3zf53Q7956J3klvg0lJ7rKCwPec8qqJSkVmGY6Fr4uETu5ReP8oKnsbQ
         Y/aZR/l5wsEK3W1htsnZ533rK0pR6ipquE4PSSlTLqlRMuULaQZrjKsBFcfeq92cEVUq
         vhMHbfgJ2DYvq8SmBrEq9kdjmAOFtZWxgjW8lYRBUu1Vts67pFX3iSC5bNOvelFYyklP
         X3u1VrTfmAEc117tc1c7NSFiO7h2UAr0didGFTWHVgAcAqbm1k8taJvNQT9hsPaxMCyH
         clJQ==
X-Gm-Message-State: ANhLgQ0blZQ5zfHP/Hl9Le3gghSr1ZZs0XXU/rnPFuZ+FJofjcpy5VyC
        VRcjbw8Tw/kf2+k4xArddiwlp0+xd16ZOBifiWyrKYFKANr5
X-Google-Smtp-Source: ADFU+vt82XYZeyCTNR4F9H7m6nneQlOjOlIllTfhytdGqCtJXlKTu1289E77p/oqDQC/teUN19g+432ZgUnnUbJAfqoKgNbmK8yB
MIME-Version: 1.0
X-Received: by 2002:a5d:8782:: with SMTP id f2mr4980149ion.53.1584464831529;
 Tue, 17 Mar 2020 10:07:11 -0700 (PDT)
Date:   Tue, 17 Mar 2020 10:07:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007158e205a10ff75c@google.com>
Subject: KASAN: use-after-free Read in route4_destroy
From:   syzbot <syzbot+703474f5b80cd91649bc@syzkaller.appspotmail.com>
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

HEAD commit:    fb33c651 Linux 5.6-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1394f7c3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=703474f5b80cd91649bc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1397ffdde00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cb20e5e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+703474f5b80cd91649bc@syzkaller.appspotmail.com

tipc: TX() has been purged, node left!
==================================================================
BUG: KASAN: use-after-free in route4_destroy+0x6bf/0x800 net/sched/cls_route.c:295
Read of size 8 at addr ffff888022eab800 by task kworker/u16:0/8

CPU: 3 PID: 8 Comm: kworker/u16:0 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 route4_destroy+0x6bf/0x800 net/sched/cls_route.c:295
 tcf_proto_destroy+0x6e/0x310 net/sched/cls_api.c:296
 tcf_proto_put+0x8c/0xc0 net/sched/cls_api.c:308
 tcf_chain_flush+0x266/0x390 net/sched/cls_api.c:600
 tcf_block_flush_all_chains net/sched/cls_api.c:1052 [inline]
 __tcf_block_put+0x1a4/0x540 net/sched/cls_api.c:1214
 tcf_block_put_ext net/sched/cls_api.c:1414 [inline]
 tcf_block_put+0xb3/0x100 net/sched/cls_api.c:1429
 hfsc_destroy_qdisc+0xe0/0x280 net/sched/sch_hfsc.c:1501
 qdisc_destroy+0x118/0x690 net/sched/sch_generic.c:958
 qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:985
 dev_shutdown+0x2b5/0x486 net/sched/sch_generic.c:1311
 rollback_registered_many+0x603/0xe70 net/core/dev.c:8803
 unregister_netdevice_many.part.0+0x16/0x1e0 net/core/dev.c:9966
 unregister_netdevice_many net/core/dev.c:9965 [inline]
 default_device_exit_batch+0x311/0x3d0 net/core/dev.c:10442
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:175
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:589
 process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8791:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 route4_change+0x2a9/0x2250 net/sched/cls_route.c:493
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

Freed by task 8:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:476
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 route4_delete_filter_work+0x17/0x20 net/sched/cls_route.c:266
 process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888022eab800
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 0 bytes inside of
 192-byte region [ffff888022eab800, ffff888022eab8c0)
The buggy address belongs to the page:
page:ffffea00008baac0 refcount:1 mapcount:0 mapping:ffff88802cc00000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0000a95b08 ffffea00008a6fc8 ffff88802cc00000
raw: 0000000000000000 ffff888022eab000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888022eab700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888022eab780: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>ffff888022eab800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888022eab880: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888022eab900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
