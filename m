Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78BF5EAE2C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiIZR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiIZR1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:27:02 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4947A855B8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 09:44:19 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id d24-20020a05660225d800b006a466ec7746so3220777iop.3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 09:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Jeurj+qz1RoEaY8Np1VP2ECVE074NEZB/B8wgW0chgw=;
        b=RxTyKjJ7T1KxR+JFAlGaIw7I6p4wqNwaIAWetK46R6d20IYAAkJLoyiSm04kyO/Hx3
         3QQYAYMtN4wyF4PI8XtdDXIv/r3Zs1X5NbwR6xv/RhC0pUKQ+GqP6lwoDPAXz7TeyHRq
         q7WU7epDB6pMVsKwwewYGucle0s6b89KufcSSxPBdQ9zxs3+14Z1ZGrQoD6MAQGTFOtb
         eyrggTVx8s8wQqvU0OmdT2eW1tiM02iUrFOqfpoaOZFRSQhWteRPYeAeJ0cSt/CBdEXS
         MoOLJiiG8BB3lmBvIWspKxSlxwJifd5XXnuKFk+beWLJ2Irw4Q5In1ezjJX1l4WgRB3F
         eFYw==
X-Gm-Message-State: ACrzQf1SeJnI5YN1gb/vm+Ty+gj/NQScTJ76S20A9mAbEWb14XCnTDJB
        WlItKfc90NS4lRS8Ueyr8sU8SyYA2Fn5jphhsGMJ6xGjK2JA
X-Google-Smtp-Source: AMsMyM5TdYOqo9/j5yhwi8A3ye/aQ2mTqO7SD/tpctGeVYcI+xRqlABqLBN4n6paSSnUaRqoEqUqERPTb2qE5B1JYCm+cjIPQ300
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20eb:b0:2f1:dc7a:c50c with SMTP id
 q11-20020a056e0220eb00b002f1dc7ac50cmr11083690ilv.269.1664210622381; Mon, 26
 Sep 2022 09:43:42 -0700 (PDT)
Date:   Mon, 26 Sep 2022 09:43:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa882f05e9973a36@google.com>
Subject: [syzbot] KASAN: use-after-free Read in l2cap_conn_del
From:   syzbot <syzbot+03450dacbc626061c3a3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    aaa11ce2ffc8 Add linux-next specific files for 20220923
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14b32754880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
dashboard link: https://syzkaller.appspot.com/bug?extid=03450dacbc626061c3a3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d389c4880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14269e38880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03450dacbc626061c3a3@syzkaller.appspotmail.com

Bluetooth: hci0: hardware error 0xff
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/linux/atomic/atomic-instrumented.h:1265 [inline]
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0xa6/0x5e0 kernel/locking/mutex.c:916
Read of size 8 at addr ffff888020ab34b8 by task kworker/u5:0/49

CPU: 0 PID: 49 Comm: kworker/u5:0 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Workqueue: hci0 hci_error_reset
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:1265 [inline]
 __mutex_unlock_slowpath+0xa6/0x5e0 kernel/locking/mutex.c:916
 l2cap_chan_unlock include/net/bluetooth/l2cap.h:860 [inline]
 l2cap_conn_del+0x404/0x7b0 net/bluetooth/l2cap_core.c:1932
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8214 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8207
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1787 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2430
 hci_dev_close_sync+0x5c4/0x1200 net/bluetooth/hci_sync.c:4804
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x9e/0x140 net/bluetooth/hci_core.c:1059
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>

Allocated by task 3621:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa1/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:695 [inline]
 l2cap_chan_create+0x40/0x930 net/bluetooth/l2cap_core.c:466
 a2mp_chan_open net/bluetooth/a2mp.c:771 [inline]
 amp_mgr_create+0x8f/0x960 net/bluetooth/a2mp.c:862
 a2mp_channel_create+0x7d/0x150 net/bluetooth/a2mp.c:894
 l2cap_data_channel net/bluetooth/l2cap_core.c:7571 [inline]
 l2cap_recv_frame+0x48e3/0x8d90 net/bluetooth/l2cap_core.c:7726
 l2cap_recv_acldata+0xaa6/0xc00 net/bluetooth/l2cap_core.c:8431
 hci_acldata_packet net/bluetooth/hci_core.c:3793 [inline]
 hci_rx_work+0x705/0x1230 net/bluetooth/hci_core.c:4028
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Freed by task 49:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2a/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1669 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1695
 slab_free mm/slub.c:3599 [inline]
 __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
 l2cap_chan_destroy net/bluetooth/l2cap_core.c:509 [inline]
 kref_put include/linux/kref.h:65 [inline]
 l2cap_chan_put+0x22a/0x2d0 net/bluetooth/l2cap_core.c:533
 l2cap_conn_del+0x3fc/0x7b0 net/bluetooth/l2cap_core.c:1930
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8214 [inline]
 l2cap_disconn_cfm+0x8c/0xc0 net/bluetooth/l2cap_core.c:8207
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1787 [inline]
 hci_conn_hash_flush+0x122/0x260 net/bluetooth/hci_conn.c:2430
 hci_dev_close_sync+0x5c4/0x1200 net/bluetooth/hci_sync.c:4804
 hci_dev_do_close+0x2d/0x70 net/bluetooth/hci_core.c:554
 hci_error_reset+0x9e/0x140 net/bluetooth/hci_core.c:1059
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x99/0x820 kernel/rcu/tree.c:2796
 netlink_release+0xeff/0x1db0 net/netlink/af_netlink.c:815
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16b/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:296
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888020ab3000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1208 bytes inside of
 2048-byte region [ffff888020ab3000, ffff888020ab3800)

The buggy address belongs to the physical page:
page:ffffea000082ac00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20ab0
head:ffffea000082ac00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888011842000 dead000080080008 0000000000000000
raw: 0000000000000000 dead000000000001 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 8393630899, free_ts 0
 prep_new_page mm/page_alloc.c:2538 [inline]
 get_page_from_freelist+0x1092/0x2d20 mm/page_alloc.c:4287
 __alloc_pages+0x1c7/0x5a0 mm/page_alloc.c:5546
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2113
 alloc_pages+0x22f/0x270 mm/mempolicy.c:2275
 alloc_slab_page mm/slub.c:1739 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1884
 new_slab mm/slub.c:1937 [inline]
 ___slab_alloc+0xac1/0x1430 mm/slub.c:3119
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3217
 slab_alloc_node mm/slub.c:3302 [inline]
 __kmem_cache_alloc_node+0x18a/0x3d0 mm/slub.c:3375
 __do_kmalloc_node mm/slab_common.c:933 [inline]
 __kmalloc+0x44/0xc0 mm/slab_common.c:947
 kmalloc include/linux/slab.h:564 [inline]
 kzalloc include/linux/slab.h:695 [inline]
 rfkill_alloc+0xa6/0x2c0 net/rfkill/core.c:984
 wiphy_new_nm+0x12d5/0x2090 net/wireless/core.c:527
 wiphy_new include/net/cfg80211.h:5550 [inline]
 virt_wifi_make_wiphy drivers/net/wireless/virt_wifi.c:363 [inline]
 virt_wifi_init_module+0x64/0x3d6 drivers/net/wireless/virt_wifi.c:665
 do_one_initcall+0x13d/0x780 init/main.c:1307
 do_initcall_level init/main.c:1382 [inline]
 do_initcalls init/main.c:1398 [inline]
 do_basic_setup init/main.c:1417 [inline]
 kernel_init_freeable+0x6ff/0x788 init/main.c:1637
 kernel_init+0x1a/0x1d0 init/main.c:1525
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888020ab3380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888020ab3400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888020ab3480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff888020ab3500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888020ab3580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
