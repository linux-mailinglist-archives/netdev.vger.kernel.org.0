Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F5F17D5E0
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 20:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCHTfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 15:35:13 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:34936 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgCHTfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 15:35:13 -0400
Received: by mail-il1-f200.google.com with SMTP id h18so5964220ilc.2
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 12:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=USf8eI6Wdkyc+LQps75FiL8cu4kVeYj/e5bvhNKIsNE=;
        b=NF3OZ5ve+ie1evMha8mlKojghfxtbuc5VziYLUkPlxItR1ErS3ozxUvt33COkof9LZ
         25cCKGhqLua1bpTXfDG6mcTYaLDv32WLAU07L1J3SHfLVw9qvutdJlvxUsl20N5PXHqZ
         MsmW0jbCbbBITSpxpStEHqhmr/KFHXwsc7eeKFZRwDuR7XEcpSotkQz88LrOsWQpnRfE
         fCa31DaIRE7AKfHSJ6dX9TL0vsHuoFxP9nbnmpVXSy+/zsL1vHF5J2IuQ+mK3dWykheq
         NdNVFrdC331L68/5Iaul/xC6dEHGf0RoaMuN/skpawdejk3+QRy0kA7CRiNSX0JKpGSC
         DzkA==
X-Gm-Message-State: ANhLgQ2z06Fa5UIk6J+Nw8LAAOM2YhSbeesqfQCRawe0JRmamqqmV9uQ
        jyj2dhZbAkNokF7EPaI+f8YE9XJP1M5m71gOHGXuWdAiVRpK
X-Google-Smtp-Source: ADFU+vsOKxwbKePeK6GT73C8F2pLyHRC/1xx/KDJ/1Vu1y7/kUrttE8KXLP0hPwdBuN1h7DDVpj4NwF7FWcMp41dWpBFIKZyK0wS
MIME-Version: 1.0
X-Received: by 2002:a6b:ee12:: with SMTP id i18mr8572276ioh.125.1583696112273;
 Sun, 08 Mar 2020 12:35:12 -0700 (PDT)
Date:   Sun, 08 Mar 2020 12:35:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034513e05a05cfc23@google.com>
Subject: KASAN: invalid-free in tcf_exts_destroy
From:   syzbot <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com>
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

HEAD commit:    c2003765 Merge tag 'io_uring-5.6-2020-03-07' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10cd2ae3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4527d1e2fb19fd5c
dashboard link: https://syzkaller.appspot.com/bug?extid=dcc34d54d68ef7d2d53d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1561b01de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15aad2f9e00000

The bug was bisected to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a275fde00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a275fde00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14a275fde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: double-free or invalid-free in tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002

CPU: 1 PID: 9507 Comm: syz-executor467 Not tainted 5.6.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
 kasan_report_invalid_free+0x61/0xa0 mm/kasan/report.c:468
 __kasan_slab_free+0x129/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
 tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
 tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
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
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe8f arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Allocated by task 1:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 __class_register+0x46/0x450 drivers/base/class.c:160
 spi_transport_init+0xf0/0x132 drivers/scsi/scsi_transport_spi.c:1609
 do_one_initcall+0x10a/0x7d0 init/main.c:1152
 do_initcall_level init/main.c:1225 [inline]
 do_initcalls init/main.c:1241 [inline]
 do_basic_setup init/main.c:1261 [inline]
 kernel_init_freeable+0x501/0x5ae init/main.c:1445
 kernel_init+0xd/0x1bb init/main.c:1352
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8880a12d5000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 152 bytes inside of
 1024-byte region [ffff8880a12d5000, ffff8880a12d5400)
The buggy address belongs to the page:
page:ffffea000284b540 refcount:1 mapcount:0 mapping:ffff8880aa000c40 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000285c288 ffffea000284b588 ffff8880aa000c40
raw: 0000000000000000 ffff8880a12d5000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a12d4f80: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a12d5000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880a12d5080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                            ^
 ffff8880a12d5100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880a12d5180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
