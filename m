Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9E16C8C84
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCYIS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCYISy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:18:54 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB8E1BF;
        Sat, 25 Mar 2023 01:18:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id bc12so3930092plb.0;
        Sat, 25 Mar 2023 01:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679732319;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mA5oRxcQwzIVwISbmd69m7HVH8tIy7ezbQM7eKycBNg=;
        b=EWA2CTqA1Wz6cP9V+siCsbfDjwTCBXkZJEoCa8Loh1TlOIjZEstZ+K3G5owFsl++7s
         lvt0jSbK8BtAJXEyCE4wT1QWkPnpiAJ9PNO6T408o9+S1HEZY70dwxoVqtus+92Y30sL
         pDqGRiKSgDpH3VtGxc6Q3QrddRB/h0sezUKNcwBoi2beAc/RN9GeOrGiB1zcyYjOavKE
         pH3iqx8U4nSa7HP6nXTQWUkw6EdtsdeQmWPSE0QcgsGJsoa3ZvsuqbvfD5Aqdk2LzE4V
         UecmZqqEgr1nzHk9BQUipQMdzxEPbXqbLi4zlXjKhYzBc1IO0+SIp1Ybub1kfzDsTWHu
         /KBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679732319;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mA5oRxcQwzIVwISbmd69m7HVH8tIy7ezbQM7eKycBNg=;
        b=RU81KnJC/Ez8OksqrywmSKnNtELBcFOm86/uS/sjeVCPYubnBZEbyNMmyfB7t/Ch4/
         qtI0Ty54J/Pga0UcW0mjaeMWTlTlpXc3ADN3zk3TGAUz9d2Bi4v6eJZGEsHuMFZAlFFk
         uRCclo2enacyOpWOX4CgMvXuLjFbbVSU1pmaRr2EtrADUKPJOnQeAFf1K0YbsswavUjB
         2fCuG7J3nsRblHf4oCPOXLpvP9QiZjK6MW/oEhX8WFVGP8PZIjRAt/316fAnCzhsH+de
         cTw0FwRh+S/j+ff3N0ee9o964QaGuNPYPKwdQ9HSAm4AFEztdMOuk8r9wqvQwEqFuFu1
         +yUw==
X-Gm-Message-State: AAQBX9d/TpG/vgA+uhE4zEgGx2KWXe/RBb8xjQw/gah5AseyFYVYw/si
        zlZfbVdDCmsqwCA6mv30GTY=
X-Google-Smtp-Source: AKy350Z7SmNAAeaFR6XEUxd/fRl32dCS8OV38VHPmhimOa5r+3qvPeZ6ZQP5LXJMr0J9zOXNLoXjMg==
X-Received: by 2002:a17:903:188:b0:19c:f096:bbef with SMTP id z8-20020a170903018800b0019cf096bbefmr6271002plg.49.1679732319052;
        Sat, 25 Mar 2023 01:18:39 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902c1cd00b0019f2328bef8sm15453785plc.34.2023.03.25.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 01:18:38 -0700 (PDT)
Date:   Sat, 25 Mar 2023 17:18:34 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jirislaby@kernel.org, duoming@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: KASAN: use-after-free Read in slip_ioctl
Message-ID: <ZB6uWm6MbpX+NmE/@dragonet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We observed a use-after-free in slip_ioctl as attached at the end.

Although I'm not sure that our analysis is correct, it seems that the
concurrent execution of slip_ioctl() and slip_close() causes the issue
as follows.

CPU1                            CPU2
slip_ioctl                      slip_close (via slip_hangup)
-----                           -----
// Read a non-null value
sl = tty->disc_data;
                                // Nullify tty->disc_data and then
                                // unregister sl->dev
                                rcu_assign_pointer(tty->disc_data, NULL);
                                unregister_netdev(sl->dev);
// sl is freed in unregister_netdev()
if (!sl || sl->magic != SLIP_MAGIC)
    return -EINVAL;

I suspect that the two functions can be executed concurrently as I
don't see a locking mechanism to prevent this in tty_ioctl(), and that
sl is freed in unregister_netdev() as explained in the callstack. But
still we need to look into this further.


Best regards,
Dae R. Jeong


==================================================================
BUG: KASAN: use-after-free in slip_ioctl+0x6db/0x7d0 drivers/net/slip/slip.c:1083
Read of size 4 at addr ffff88804b856c80 by task syz-executor.0/9106

CPU: 2 PID: 9106 Comm: syz-executor.0 Not tainted 6.0.0-rc7-00166-gf09dbf1cf0d5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1cf/0x2b7 lib/dump_stack.c:106
 print_address_description+0x21/0x470 mm/kasan/report.c:317
 print_report+0x108/0x1f0 mm/kasan/report.c:433
 kasan_report+0xe5/0x110 mm/kasan/report.c:495
 slip_ioctl+0x6db/0x7d0 drivers/net/slip/slip.c:1083
 tty_ioctl+0x11e9/0x1a20 drivers/tty/tty_io.c:2787
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x110/0x180 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x478d29
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbbbdfb8be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000781408 RCX: 0000000000478d29
RDX: 0000000020000040 RSI: 00000000402c542c RDI: 0000000000000003
RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000781580
r13: 0000000000781414 R14: 0000000000781408 R15: 00007ffcfdc4f040
 </TASK>

Allocated by task 9103:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc+0xcd/0x100 mm/kasan/common.c:516
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 __kmalloc_node+0x366/0x550 mm/slub.c:4477
 kmalloc_node include/linux/slab.h:623 [inline]
 kvmalloc_node+0x6e/0x170 mm/util.c:613
 kvmalloc include/linux/slab.h:750 [inline]
 kvzalloc include/linux/slab.h:758 [inline]
 alloc_netdev_mqs+0x86/0x1240 net/core/dev.c:10603
 sl_alloc drivers/net/slip/slip.c:756 [inline]
 slip_open+0x489/0x1240 drivers/net/slip/slip.c:817
 tty_ldisc_open+0xb4/0x120 drivers/tty/tty_ldisc.c:433
 tty_set_ldisc+0x366/0x860 drivers/tty/tty_ldisc.c:558
 tiocsetd drivers/tty/tty_io.c:2433 [inline]
 tty_ioctl+0x168f/0x1a20 drivers/tty/tty_io.c:2714
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x110/0x180 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 9105:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x60 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0x134/0x1c0 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1759 [inline]
 slab_free_freelist_hook+0x278/0x370 mm/slub.c:1785
 slab_free mm/slub.c:3539 [inline]
 kfree+0x108/0x460 mm/slub.c:4567
 device_release+0x189/0x220
 kobject_cleanup+0x24f/0x360 lib/kobject.c:673
 netdev_run_todo+0x14ac/0x15a0 net/core/dev.c:10385
 unregister_netdev+0x1e9/0x270 net/core/dev.c:10922
 tty_ldisc_hangup+0x224/0x750 drivers/tty/tty_ldisc.c:700
 __tty_hangup+0x5b4/0x870 drivers/tty/tty_io.c:637
 tty_vhangup drivers/tty/tty_io.c:707 [inline]
 tty_ioctl+0xa7f/0x1a20 drivers/tty/tty_io.c:2718
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x110/0x180 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88804b856000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 3200 bytes inside of
 4096-byte region [ffff88804b856000, ffff88804b857000)

The buggy address belongs to the physical page:
page:ffffea00012e1400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4b850
head:ffffea00012e1400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea000421c600 dead000000000003 ffff88801344c140
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3028, tgid 3028 (systemd-udevd), ts 3568645047764, free_ts 3567951761241
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x800/0xc10 mm/page_alloc.c:4283
 __alloc_pages+0x2f0/0x650 mm/page_alloc.c:5549
 alloc_slab_page mm/slub.c:1829 [inline]
 allocate_slab+0x1eb/0xc00 mm/slub.c:1974
 new_slab mm/slub.c:2034 [inline]
 ___slab_alloc+0x581/0xff0 mm/slub.c:3036
 __slab_alloc mm/slub.c:3123 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 __kmalloc_node+0x3db/0x550 mm/slub.c:4473
 kmalloc_node include/linux/slab.h:623 [inline]
 kvmalloc_node+0x6e/0x170 mm/util.c:613
 kvmalloc include/linux/slab.h:750 [inline]
 seq_buf_alloc fs/seq_file.c:38 [inline]
 seq_read_iter+0x269/0x10f0 fs/seq_file.c:210
 call_read_iter include/linux/fs.h:2181 [inline]
 new_sync_read fs/read_write.c:389 [inline]
 vfs_read+0x838/0xd30 fs/read_write.c:470
 ksys_read+0x182/0x2c0 fs/read_write.c:607
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x76d/0x890 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x8a/0x880 mm/page_alloc.c:3476
 __skb_frag_unref include/linux/skbuff.h:3380 [inline]
 skb_release_data+0x3f0/0x910 net/core/skbuff.c:685
 skb_release_all net/core/skbuff.c:756 [inline]
 __kfree_skb+0x60/0x210 net/core/skbuff.c:770
 e1000_unmap_and_free_tx_resource drivers/net/ethernet/intel/e1000/e1000_main.c:1970 [inline]
 e1000_clean_tx_irq drivers/net/ethernet/intel/e1000/e1000_main.c:3860 [inline]
 e1000_clean+0x5ba/0x4400 drivers/net/ethernet/intel/e1000/e1000_main.c:3801
 __napi_poll+0xe7/0x6b0 net/core/dev.c:6511
 napi_poll net/core/dev.c:6578 [inline]
 net_rx_action+0x7a5/0x1210 net/core/dev.c:6689
 __do_softirq+0x372/0x783 kernel/softirq.c:571

Memory state around the buggy address:
 ffff88804b856b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804b856c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88804b856c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88804b856d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804b856d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
