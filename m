Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A76423A76
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbhJFJX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhJFJX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 05:23:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90E5C061749;
        Wed,  6 Oct 2021 02:21:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso3436287pjb.0;
        Wed, 06 Oct 2021 02:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=rjak4BrjTFYAHsESRKCkP8Wsc51m0mV1HNkl7mF8nHA=;
        b=pkLLymtYYZBd3C8SudTZEyS4MWhYGLngEqZNmbfCl6/ubYosXg3nqypcTAW3pCjsoc
         bBvjwfsWwErEcI+YZm6SJO7AZOp93nhPqOES3x36hmq/GeLAk1QkvfLa43dkEgHWwBIN
         KL8oiTifm/oYAbfixhJRjx1jGve7UP4/JS9FF+ce+tw1N8lm0WnTW9KjXiNXe/7fIO4b
         dL95hdgw8jeYoNIm+v27rbbBbaINtOfy55dQg8dqXE1ZWjOHoESclAoAnBqapY3bZXcr
         hhV+hxoBuykWQXL0anuUoT80yv7UfK5jZQ17Yh6iDfPofntw8uTl0WEjBEvf21bWRfSu
         d4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rjak4BrjTFYAHsESRKCkP8Wsc51m0mV1HNkl7mF8nHA=;
        b=H3cLsPzLHZSA2Ni0leYO4wuY9I+gTZ48YqOLwRGmLaOEyTfVq+h1eMQiBJEWBqgevY
         l26RQDuBT86kET6xMw0LQTXITesINogUL6LIvjZRZUd6lF3yNswuCBPG8hEQNWt/1RC6
         1sxmziHlmoAjUPhakxa+1MOl1osbD+KdUurUEFOwldDTRfbB+gr1JA4BKtaA05lF/+Ok
         ipi1r9quca2Cbn2mEof0zhJIZk7e3hbUBWYpm6j+pu+GX2tOXl/lpknVhASSFAw9ZEcz
         SM02PYZDu+qYb3yPnBrMCnGPG2zgPswLETSjTblQ07gbGbjICB2NI0U46ODDDcoUJKOs
         HKsg==
X-Gm-Message-State: AOAM530yxUGg6Kutsf0VZKRZT25X5XJi7+4plP6y+XXuicYOXVXGUAkn
        Koe6+dATfTLFSwgBef/k3G1DKen6/rrkDh2Weg==
X-Google-Smtp-Source: ABdhPJwsQFgpJk/WReIrBo5JpBm0ZAW0x0tJX1V1mb4o7kqFLyOAl9KVQTKQXsyDBJl0d5UPVBFrgbsT3ir9p5Bm/2k=
X-Received: by 2002:a17:902:7b84:b0:13b:90a7:e270 with SMTP id
 w4-20020a1709027b8400b0013b90a7e270mr10004980pll.21.1633512095959; Wed, 06
 Oct 2021 02:21:35 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 6 Oct 2021 17:21:25 +0800
Message-ID: <CACkBjsa8g=6cL-HPj=BODG6wTbo03rNWegqiZ+2ij-aDSZfhUA@mail.gmail.com>
Subject: KASAN: use-after-free Read in hci_cmd_timeout
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 42d43c92fc57  Merge branch 'for-linus'
git tree: upstream
console output:
https://drive.google.com/file/d/1ibZB4dfXnXoDznHOKdxaNC3OOq-mob9e/view?usp=sharing
kernel config: https://drive.google.com/file/d/1ibZB4dfXnXoDznHOKdxaNC3OOq-mob9e/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

==================================================================
BUG: KASAN: use-after-free in hci_cmd_timeout+0x203/0x210
net/bluetooth/hci_core.c:2774
Read of size 2 at addr ffff88801dcf8008 by task kworker/1:0/22

CPU: 1 PID: 22 Comm: kworker/1:0 Not tainted 5.15.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events hci_cmd_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x93/0x334 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 hci_cmd_timeout+0x203/0x210 net/bluetooth/hci_core.c:2774
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Allocated by task 14281:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kasan_kmalloc ./include/linux/kasan.h:264 [inline]
 __kmalloc+0x1c1/0x390 mm/slub.c:4391
 kmalloc ./include/linux/slab.h:596 [inline]
 kzalloc ./include/linux/slab.h:721 [inline]
 ops_init+0xfb/0x420 net/core/net_namespace.c:130
 setup_net+0x415/0xa40 net/core/net_namespace.c:326
 copy_net_ns+0x2d9/0x660 net/core/net_namespace.c:470
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73d0 kernel/fork.c:2197
 kernel_clone+0xe7/0x10d0 kernel/fork.c:2584
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2701
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 6594:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0x100/0x140 mm/kasan/common.c:374
 kasan_slab_free ./include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook mm/slub.c:1725 [inline]
 slab_free mm/slub.c:3483 [inline]
 kfree+0xfc/0x700 mm/slub.c:4543
 skb_free_head+0x8b/0xa0 net/core/skbuff.c:654
 skb_release_data+0x5bf/0x700 net/core/skbuff.c:676
 skb_release_all+0x46/0x60 net/core/skbuff.c:741
 __kfree_skb net/core/skbuff.c:755 [inline]
 kfree_skb net/core/skbuff.c:773 [inline]
 kfree_skb+0xfa/0x3a0 net/core/skbuff.c:767
 hci_dev_do_open+0xa50/0x1820 net/bluetooth/hci_core.c:1634
 hci_power_on+0x133/0x650 net/bluetooth/hci_core.c:2263
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0xab0 kernel/rcu/tree.c:3552
 drop_sysctl_table+0x2e7/0x3b0 fs/proc/proc_sysctl.c:1647
 unregister_sysctl_table+0xc2/0x190 fs/proc/proc_sysctl.c:1685
 mpls_dev_sysctl_unregister+0x80/0xc0 net/mpls/af_mpls.c:1441
 mpls_dev_notify+0x458/0x770 net/mpls/af_mpls.c:1621
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1996 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1981
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 unregister_netdevice_many+0x930/0x14e0 net/core/dev.c:11043
 vti6_exit_batch_net+0x3ad/0x690 net/ipv6/ip6_vti.c:1188
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:171
 cleanup_net+0x511/0xa90 net/core/net_namespace.c:591
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0xab0 kernel/rcu/tree.c:3552
 ma_put net/ipv6/mcast.c:869 [inline]
 ma_put+0x11c/0x180 net/ipv6/mcast.c:865
 __ipv6_dev_mc_dec+0x278/0x340 net/ipv6/mcast.c:982
 addrconf_leave_solict.part.0+0xb5/0xf0 net/ipv6/addrconf.c:2189
 addrconf_leave_solict net/ipv6/addrconf.c:6124 [inline]
 __ipv6_ifa_notify+0x2a7/0xb40 net/ipv6/addrconf.c:6124
 addrconf_ifdown+0x92f/0x14d0 net/ipv6/addrconf.c:3835
 addrconf_notify+0xeb/0x1bc0 net/ipv6/addrconf.c:3646
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1996 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1981
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 dev_close_many+0x2fc/0x630 net/core/dev.c:1597
 unregister_netdevice_many+0x420/0x14e0 net/core/dev.c:11020
 default_device_exit_batch+0x302/0x3c0 net/core/dev.c:11573
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:171
 cleanup_net+0x511/0xa90 net/core/net_namespace.c:591
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff88801dcf8000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 8 bytes inside of
 512-byte region [ffff88801dcf8000, ffff88801dcf8200)
The buggy address belongs to the page:
page:ffffea0000773e00 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x1dcf8
head:ffffea0000773e00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 0000000300000001 ffff888010c42c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask
0xd2000(__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid
1, ts 19546740260, free_ts 0
 set_page_owner ./include/linux/page_owner.h:31 [inline]
 post_alloc_hook mm/page_alloc.c:2418 [inline]
 prep_new_page+0x1a5/0x240 mm/page_alloc.c:2424
 get_page_from_freelist+0x1f10/0x3b70 mm/page_alloc.c:4153
 __alloc_pages+0x306/0x6e0 mm/page_alloc.c:5375
 alloc_page_interleave+0x1e/0x1f0 mm/mempolicy.c:2042
 alloc_pages+0x1e4/0x240 mm/mempolicy.c:2192
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x34a/0x480 mm/slub.c:1963
 ___slab_alloc+0xa9f/0x10d0 mm/slub.c:2994
 __slab_alloc.isra.0+0x4d/0xa0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc_trace+0x31c/0x340 mm/slub.c:3231
 kmalloc ./include/linux/slab.h:591 [inline]
 usb_cache_string+0x5e/0x110 drivers/usb/core/message.c:1027
 usb_enumerate_device drivers/usb/core/hub.c:2405 [inline]
 usb_new_device+0x15b/0x760 drivers/usb/core/hub.c:2533
 register_root_hub+0x420/0x572 drivers/usb/core/hcd.c:1010
 usb_add_hcd.cold+0x1100/0x134a drivers/usb/core/hcd.c:2972
 vhci_hcd_probe+0x150/0x3a0 drivers/usb/usbip/vhci_hcd.c:1362
 platform_probe+0xfc/0x1f0 drivers/base/platform.c:1411
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe drivers/base/dd.c:596 [inline]
 really_probe+0x245/0xbd0 drivers/base/dd.c:541
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801dcf7f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801dcf7f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801dcf8000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88801dcf8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801dcf8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
