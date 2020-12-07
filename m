Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4F92D1908
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgLGTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:03:56 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:53005 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgLGTD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:03:56 -0500
Received: by mail-il1-f200.google.com with SMTP id h4so11908752ilq.19
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 11:03:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BK3A/4RekMn0zj50Csrds0CNs93CU1NoudzU58/J44M=;
        b=qLXLoLXdP9KMfDaY9Tf37qHLp/VFTZG/EYxzq24KDkj+mdJN8wZ+tYVvqNbBcFQ1IP
         UnWownbyuGOkHlvalPWRaDklv/PsV3nSR7whOi33+aIqbdUOtjtlfy+nqzf21QbC1bn7
         VbP2gdqF9/Y4GtQc8DZcgXRbIp3sE0c8NBgYI/DA2mkX8a1ab65ONwY09c1ZAz/qoxNJ
         hXUmBJ/FJ01mOrMuIIX0UmZfNgc70GCAaKKOX4isPrsFmqJwhVvxbHrqJpdQpFNuzv5e
         qzDx5OnY/OrJ0snDhLUdQpIrOGw/CS+p+LWfmgYExss8N43irq/hdwu1qK1IRyT4J90U
         5A6g==
X-Gm-Message-State: AOAM531qPN0envUBVBkyjYeu4JW3ApZASN5AAydroVN5Bg0j94QzrQdd
        dDXi4QrBCylaY1y5PNzZtJe2JM23MtUWNwdubjKPEj5z9ky5
X-Google-Smtp-Source: ABdhPJydnkwEMek2z6foDq2wrDPXziet7vbC+ActUcVowL5wG4GdDPPtaRxZByaZY1DXNSvZGIKijihkJn4os+E+eHrbOnNZ/t0n
MIME-Version: 1.0
X-Received: by 2002:a6b:700f:: with SMTP id l15mr21473544ioc.22.1607367789173;
 Mon, 07 Dec 2020 11:03:09 -0800 (PST)
Date:   Mon, 07 Dec 2020 11:03:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018e57f05b5e47aa4@google.com>
Subject: KASAN: use-after-free Read in ieee80211_ibss_build_presp
From:   syzbot <syzbot+cd25350b5fe5b8ed143c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e87297fa Merge tag 'drm-fixes-2020-12-04' of git://anongit..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=144035d3500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e49433cfed49b7d9
dashboard link: https://syzkaller.appspot.com/bug?extid=cd25350b5fe5b8ed143c
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107ebd45500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ef29bb500000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1410d2ef500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1610d2ef500000
console output: https://syzkaller.appspot.com/x/log.txt?x=1210d2ef500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd25350b5fe5b8ed143c@syzkaller.appspotmail.com

wlan0: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/string.h:399 [inline]
BUG: KASAN: use-after-free in ieee80211_ibss_build_presp+0x10be/0x15f0 net/mac80211/ibss.c:171
Read of size 4 at addr ffff888014132cf8 by task kworker/u4:7/1428

CPU: 1 PID: 1428 Comm: kworker/u4:7 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy0 ieee80211_iface_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 memcpy+0x20/0x60 mm/kasan/common.c:105
 memcpy include/linux/string.h:399 [inline]
 ieee80211_ibss_build_presp+0x10be/0x15f0 net/mac80211/ibss.c:171
 __ieee80211_sta_join_ibss+0x685/0x17f0 net/mac80211/ibss.c:317
 ieee80211_sta_create_ibss.cold+0xc9/0x116 net/mac80211/ibss.c:1354
 ieee80211_sta_find_ibss net/mac80211/ibss.c:1484 [inline]
 ieee80211_ibss_work.cold+0x30e/0x60f net/mac80211/ibss.c:1708
 ieee80211_iface_work+0x82e/0x970 net/mac80211/iface.c:1476
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 8545:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:526 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 slab_alloc mm/slub.c:2899 [inline]
 __kmalloc_track_caller+0x1dc/0x3d0 mm/slub.c:4464
 kmemdup+0x23/0x50 mm/util.c:128
 kmemdup include/linux/string.h:472 [inline]
 ieee80211_ibss_join+0x861/0xf30 net/mac80211/ibss.c:1824
 rdev_join_ibss net/wireless/rdev-ops.h:535 [inline]
 __cfg80211_join_ibss+0x78c/0x1170 net/wireless/ibss.c:144
 nl80211_join_ibss+0xcbb/0x12b0 net/wireless/nl80211.c:10151
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8549:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kfree+0xdb/0x360 mm/slub.c:4124
 ieee80211_ibss_leave+0x83/0xe0 net/mac80211/ibss.c:1876
 rdev_leave_ibss net/wireless/rdev-ops.h:545 [inline]
 __cfg80211_leave_ibss+0x19a/0x4c0 net/wireless/ibss.c:212
 cfg80211_leave_ibss+0x57/0x80 net/wireless/ibss.c:230
 cfg80211_change_iface+0x855/0xef0 net/wireless/util.c:1012
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3789
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888014132cf8
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes inside of
 8-byte region [ffff888014132cf8, ffff888014132d00)
The buggy address belongs to the page:
page:0000000078f1b37d refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14132
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00004a8280 0000001200000012 ffff888010041c80
raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888014132b80: fc fc fb fc fc fc fc fb fc fc fc fc fb fc fc fc
 ffff888014132c00: fc 00 fc fc fc fc 00 fc fc fc fc fb fc fc fc fc
>ffff888014132c80: fa fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc fa
                                                                ^
 ffff888014132d00: fc fc fc fc fa fc fc fc fc 00 fc fc fc fc 00 fc
 ffff888014132d80: fc fc fc fb fc fc fc fc fb fc fc fc fc fb fc fc
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
