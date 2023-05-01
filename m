Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97F96F31B6
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbjEAN7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 09:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjEAN7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 09:59:41 -0400
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD3810D
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 06:59:39 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-33110281872so551685ab.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 06:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682949578; x=1685541578;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVRLu2cXdrMnY4tk54xDYgV3CvWJrcSRgGqc2vrxApo=;
        b=HGK9gb0DhTjR7opp4l8BEvXoegvbxquoiOWaJNDi6Gb238Zkb/MTNwK/mklOn+gJ+M
         9Al5/2epiFAswOCYoqeDkgoC+1mbpbzz+yz61FoWsxl+SoakdLWlydZoWUSfAsS5U4aK
         XiYI578sWTyZfm2apHKi/R6KO8f0CitogfHWhje+p7b4+qabUddfbg9lXSsGUC/QKRTk
         Ndf2ZYYhZOb8YHIjLCU6s1kH551GzqclVZWE2NrcmkcaOA2hS9NmRRqw0Rh4EXgKFcib
         m7nUmllpsuZzq5Xiw8NCXBZ8iqi6Oq/leCDQ/yxNN4nUxtGp/WMEgL/3H49aabMYpTRo
         YTVA==
X-Gm-Message-State: AC+VfDyPhwErstU8eRlHBqrt3d+CI4BvkTGH2gwc/g929qhhLADTHARs
        18CilvA+urCRH8D0ZUODmfxpxKgWeTIrdsSlfLU6YfYf1RXw
X-Google-Smtp-Source: ACHHUZ6mm8CP/VGzx8DMhMQxF+iHQH2cReCQeAC3scMAybEyQ6AKGuIrfOIpbF2YDfDfjqmvsvTIMQTFgzskZOW80/vj0oACs+gj
MIME-Version: 1.0
X-Received: by 2002:a92:cd4a:0:b0:323:195:7458 with SMTP id
 v10-20020a92cd4a000000b0032301957458mr7118635ilq.0.1682949578547; Mon, 01 May
 2023 06:59:38 -0700 (PDT)
Date:   Mon, 01 May 2023 06:59:38 -0700
In-Reply-To: <000000000000aa920505f60d25ad@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce218f05faa23b67@google.com>
Subject: Re: [syzbot] [bluetooth?] KASAN: slab-use-after-free Read in hci_conn_hash_flush
From:   syzbot <syzbot+8bb72f86fc823817bc5d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, lrh2000@pku.edu.cn,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    58390c8ce1bd Merge tag 'iommu-updates-v6.4' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1502fd68280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d56ffc213bf6bf4a
dashboard link: https://syzkaller.appspot.com/bug?extid=8bb72f86fc823817bc5d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121cf70c280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ace9d8280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/64e93dba0330/disk-58390c8c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2b7f3c1154f1/vmlinux-58390c8c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4ad00371a063/bzImage-58390c8c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bb72f86fc823817bc5d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in hci_conn_hash_flush+0x244/0x270 net/bluetooth/hci_conn.c:2470
Read of size 8 at addr ffff88807df46000 by task syz-executor183/4997

CPU: 0 PID: 4997 Comm: syz-executor183 Not tainted 6.3.0-syzkaller-12049-g58390c8ce1bd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 hci_conn_hash_flush+0x244/0x270 net/bluetooth/hci_conn.c:2470
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4941
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2703
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:669
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad3/0x2960 kernel/exit.c:871
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1021
 __do_sys_exit_group kernel/exit.c:1032 [inline]
 __se_sys_exit_group kernel/exit.c:1030 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1030
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5c483ecbe9
Code: Unable to access opcode bytes at 0x7f5c483ecbbf.
RSP: 002b:00007ffcf6d71ce8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f5c484773b0 RCX: 00007f5c483ecbe9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffffffffffffb8 R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5c484773b0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Allocated by task 5002:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 hci_conn_add+0xb8/0x16b0 net/bluetooth/hci_conn.c:986
 hci_connect_sco+0x3c7/0x1050 net/bluetooth/hci_conn.c:1663
 sco_connect net/bluetooth/sco.c:264 [inline]
 sco_sock_connect+0x2d7/0xae0 net/bluetooth/sco.c:610
 __sys_connect_file+0x153/0x1a0 net/socket.c:2003
 __sys_connect+0x165/0x1a0 net/socket.c:2020
 __do_sys_connect net/socket.c:2030 [inline]
 __se_sys_connect net/socket.c:2027 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 4997:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:521
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3786 [inline]
 __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3799
 device_release+0xa3/0x240 drivers/base/core.c:2484
 kobject_cleanup lib/kobject.c:683 [inline]
 kobject_release lib/kobject.c:714 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c2/0x4d0 lib/kobject.c:731
 put_device+0x1f/0x30 drivers/base/core.c:3733
 hci_conn_del+0x1e5/0x950 net/bluetooth/hci_conn.c:1162
 hci_conn_unlink+0x2ce/0x460 net/bluetooth/hci_conn.c:1109
 hci_conn_unlink+0x362/0x460 net/bluetooth/hci_conn.c:1087
 hci_conn_hash_flush+0x19b/0x270 net/bluetooth/hci_conn.c:2479
 hci_dev_close_sync+0x5fb/0x1200 net/bluetooth/hci_sync.c:4941
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x1ce/0x580 net/bluetooth/hci_core.c:2703
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:669
 __fput+0x27c/0xa90 fs/file_table.c:321
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad3/0x2960 kernel/exit.c:871
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1021
 __do_sys_exit_group kernel/exit.c:1032 [inline]
 __se_sys_exit_group kernel/exit.c:1030 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1030
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807df46000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes inside of
 freed 4096-byte region [ffff88807df46000, ffff88807df47000)

The buggy address belongs to the physical page:
page:ffffea0001f7d000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7df40
head:ffffea0001f7d000 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5002, tgid 4997 (syz-executor183), ts 41448885910, free_ts 34737312749
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1722
 prep_new_page mm/page_alloc.c:1729 [inline]
 get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3493
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4759
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2277
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x390 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3192
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3291
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3490
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc+0x4e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 tomoyo_realpath_from_path+0xc3/0x600 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x29a/0x3a0 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:332 [inline]
 tomoyo_file_open+0xa1/0xc0 security/tomoyo/tomoyo.c:327
 security_file_open+0x49/0xb0 security/security.c:2797
 do_dentry_open+0x575/0x13f0 fs/open.c:907
 do_open fs/namei.c:3636 [inline]
 path_openat+0x1baa/0x2750 fs/namei.c:3791
 do_filp_open+0x1ba/0x410 fs/namei.c:3818
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2555
 free_unref_page+0x33/0x370 mm/page_alloc.c:2650
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2636
 qlink_free mm/kasan/quarantine.c:166 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3451 [inline]
 slab_alloc mm/slub.c:3459 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3466 [inline]
 kmem_cache_alloc+0x17c/0x3b0 mm/slub.c:3475
 ptlock_alloc+0x21/0x70 mm/memory.c:5942
 ptlock_init include/linux/mm.h:2755 [inline]
 pgtable_pte_page_ctor include/linux/mm.h:2776 [inline]
 __pte_alloc_one include/asm-generic/pgalloc.h:66 [inline]
 pte_alloc_one+0x6c/0x230 arch/x86/mm/pgtable.c:33
 __pte_alloc+0x6d/0x260 mm/memory.c:439
 do_anonymous_page mm/memory.c:4053 [inline]
 do_pte_missing mm/memory.c:3645 [inline]
 handle_pte_fault mm/memory.c:4947 [inline]
 __handle_mm_fault+0x412e/0x41c0 mm/memory.c:5089
 handle_mm_fault+0x2af/0x9f0 mm/memory.c:5243
 do_user_addr_fault+0x2ca/0x1210 arch/x86/mm/fault.c:1349
 handle_page_fault arch/x86/mm/fault.c:1534 [inline]
 exc_page_fault+0x98/0x170 arch/x86/mm/fault.c:1590
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:570

Memory state around the buggy address:
 ffff88807df45f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807df45f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807df46000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88807df46080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807df46100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
