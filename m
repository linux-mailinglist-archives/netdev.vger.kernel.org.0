Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2126D34F1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 01:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjDAXMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 19:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDAXMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 19:12:48 -0400
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D561B35D
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 16:12:46 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id 187-20020a6b15c4000000b007590817bcfbso15994095iov.12
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 16:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680390766; x=1682982766;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ztqmH68+XXccWlVqS7GLZy0labq1EgCTA5s2+a0IZMc=;
        b=p/HpOgWY4ZQYfj4h9PsOnFcWbh7JYqHY5u0Lj+q6EAsYSyywRo/VpId8QSSzX58+PY
         MOMxeXe9uYAq0RYLeyaJ5UXQSf/XQPXhtdZHAA+WbZvi+H33cPYy9qHYmySm2qP0Zl4J
         Q3vFQvyzii3BK+dXC3lBxh+wbIYjItQuambjXNVrRqbr2U9GQQB/+XXDpFOvo8lU+raY
         fiNZfFJ2eZn3BdbuDz4IyHHGH+GNp4aWjkPMHoJDdJITSSz0IVFiFV+wCAjnJjXXYNg1
         cLYwSPuSsX5f+qzR/yQ3zfQId6y8mTtgV/pao5gPlNYw6Yh4qjtK+up8S/W97gTsIOeb
         zRpQ==
X-Gm-Message-State: AO0yUKW5H0lJECILayM9/HJ1iowpVNsy5ZUPdwvr5b5koN2ANCuSTjJi
        81K/rYP2FLOPfLwmJfisR5RUJmc+cWg9aTpLt9n+iJez+Wh6
X-Google-Smtp-Source: AK7set8/hRJ5dIU+BrcR8JAPfq5wC4NUTGWSv06oswmjCsj+oaQmt5VgKqem7YURFwAlHR0uOpS7eGj1HqB+ARmueLGaRJUBfP64
MIME-Version: 1.0
X-Received: by 2002:a02:95a6:0:b0:3a7:e46f:1016 with SMTP id
 b35-20020a0295a6000000b003a7e46f1016mr12747135jai.0.1680390766005; Sat, 01
 Apr 2023 16:12:46 -0700 (PDT)
Date:   Sat, 01 Apr 2023 16:12:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b113b705f84e761b@google.com>
Subject: [syzbot] [batman?] WARNING: locking bug in batadv_nc_process_nc_paths
From:   syzbot <syzbot+6c3ddeb774a88806d35a@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pabeni@redhat.com, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a6faf7ea9fcb Add linux-next specific files for 20230328
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12e4a6d1c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd9eb5678a80e926
dashboard link: https://syzkaller.appspot.com/bug?extid=6c3ddeb774a88806d35a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b03351a37b6b/disk-a6faf7ea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/663c2ddae5f7/vmlinux-a6faf7ea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a5e229b4773a/bzImage-a6faf7ea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6c3ddeb774a88806d35a@syzkaller.appspotmail.com

=============================
[ BUG: Invalid wait context ]
6.3.0-rc4-next-20230328-syzkaller #0 Not tainted
-----------------------------
kworker/u4:11/7080 is trying to lock:
ffffffff916756d0 (lock_keys_hash){....}-{40:209}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
ffffffff916756d0 (lock_keys_hash){....}-{40:209}, at: batadv_nc_process_nc_paths.part.0+0x142/0x3f0 net/batman-adv/network-coding.c:690
other info that might help us debug this:
context-{4:4}
3 locks held by kworker/u4:11/7080:
 #0: ffff888026eef938
 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 ((wq_completion)bat_events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 ((wq_completion)bat_events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:643 [inline]
 ((wq_completion)bat_events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:670 [inline]
 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_one_work+0x883/0x15e0 kernel/workqueue.c:2376
 #1: ffffc900033afdb0
 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work+0x8b7/0x15e0 kernel/workqueue.c:2380
 #2: ffffffff8c795e00 (rcu_read_lock){....}-{1:2}, at: batadv_nc_process_nc_paths.part.0+0xb1/0x3f0 net/batman-adv/network-coding.c:684
stack backtrace:
CPU: 1 PID: 7080 Comm: kworker/u4:11 Not tainted 6.3.0-rc4-next-20230328-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/17/2023
Workqueue: bat_events batadv_nc_worker
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4724 [inline]
 check_wait_context kernel/locking/lockdep.c:4785 [inline]
 __lock_acquire+0x159e/0x5df0 kernel/locking/lockdep.c:5024
 lock_acquire.part.0+0x11c/0x370 kernel/locking/lockdep.c:5691
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:355 [inline]
 batadv_nc_process_nc_paths.part.0+0x142/0x3f0 net/batman-adv/network-coding.c:690
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:679 [inline]
 batadv_nc_worker+0xc82/0xfe0 net/batman-adv/network-coding.c:728
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x33e/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
==================================================================
BUG: KASAN: slab-out-of-bounds in batadv_nc_fwd_flush+0x422/0x4d0 net/batman-adv/network-coding.c:650
Read of size 4 at addr ffff88807a916130 by task kworker/u4:11/7080

CPU: 1 PID: 7080 Comm: kworker/u4:11 Not tainted 6.3.0-rc4-next-20230328-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/17/2023
Workqueue: bat_events batadv_nc_worker

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 batadv_nc_fwd_flush+0x422/0x4d0 net/batman-adv/network-coding.c:650
 batadv_nc_process_nc_paths.part.0+0x1b6/0x3f0 net/batman-adv/network-coding.c:693
 batadv_nc_process_nc_paths net/batman-adv/network-coding.c:679 [inline]
 batadv_nc_worker+0xc82/0xfe0 net/batman-adv/network-coding.c:728
 process_one_work+0x99a/0x15e0 kernel/workqueue.c:2405
 worker_thread+0x67d/0x10c0 kernel/workqueue.c:2552
 kthread+0x33e/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 12301:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 ref_tracker_alloc+0x158/0x580 lib/ref_tracker.c:85
 __netdev_tracker_alloc include/linux/netdevice.h:4059 [inline]
 netdev_hold include/linux/netdevice.h:4088 [inline]
 netdev_hold include/linux/netdevice.h:4083 [inline]
 fib_check_nh_nongw net/ipv4/fib_semantics.c:1238 [inline]
 fib_check_nh+0x270/0x640 net/ipv4/fib_semantics.c:1258
 fib_create_info+0x23b0/0x4c00 net/ipv4/fib_semantics.c:1553
 fib_table_insert+0x199/0x1be0 net/ipv4/fib_trie.c:1236
 fib_magic+0x493/0x580 net/ipv4/fib_frontend.c:1104
 fib_add_ifaddr+0x4bc/0x560 net/ipv4/fib_frontend.c:1148
 fib_netdev_event+0x38c/0x6f0 net/ipv4/fib_frontend.c:1486
 notifier_call_chain+0xb6/0x3c0 kernel/notifier.c:93
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1937
 call_netdevice_notifiers_extack net/core/dev.c:1975 [inline]
 call_netdevice_notifiers net/core/dev.c:1989 [inline]
 __dev_notify_flags+0x120/0x2d0 net/core/dev.c:8566
 dev_change_flags+0x11b/0x170 net/core/dev.c:8604
 do_setlink+0x9f4/0x3d30 net/core/rtnetlink.c:2836
 rtnl_group_changelink net/core/rtnetlink.c:3380 [inline]
 __rtnl_newlink+0xb90/0x1840 net/core/rtnetlink.c:3636
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3673
 rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6388
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2572
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807a916100
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 16 bytes to the right of
 allocated 32-byte region [ffff88807a916100, ffff88807a916120)

The buggy address belongs to the physical page:
page:ffffea0001ea4580 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7a916
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000000200 ffff888012441500 ffffea0001dedf40 dead000000000002
raw: 0000000000000000 0000000000400040 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_HARDWALL), pid 5781, tgid 5781 (syz-executor.4), ts 327417606587, free_ts 297066583858
 prep_new_page mm/page_alloc.c:1729 [inline]
 get_page_from_freelist+0xf75/0x2aa0 mm/page_alloc.c:3493
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4759
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2283
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x28e/0x380 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc+0x4e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 kzalloc include/linux/slab.h:680 [inline]
 tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 tomoyo_encode+0x2c/0x50 security/tomoyo/realpath.c:80
 tomoyo_path_perm+0x394/0x430 security/tomoyo/file.c:831
 tomoyo_path_symlink+0x98/0xe0 security/tomoyo/tomoyo.c:211
 security_path_symlink+0xe3/0x160 security/security.c:1747
 do_symlinkat+0x10a/0x2e0 fs/namei.c:4422
 __do_sys_symlinkat fs/namei.c:4440 [inline]
 __se_sys_symlinkat fs/namei.c:4437 [inline]
 __x64_sys_symlinkat+0x97/0xc0 fs/namei.c:4437
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x4d8/0xb80 mm/page_alloc.c:2555
 free_unref_page+0x33/0x370 mm/page_alloc.c:2650
 qlink_free mm/kasan/quarantine.c:166 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x17c/0x320 mm/slub.c:3491
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
 do_open fs/namei.c:3560 [inline]
 path_openat+0x1baa/0x2750 fs/namei.c:3715
 do_filp_open+0x1ba/0x410 fs/namei.c:3742
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1356
 do_sys_open fs/open.c:1372 [inline]
 __do_sys_openat fs/open.c:1388 [inline]
 __se_sys_openat fs/open.c:1383 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1383

Memory state around the buggy address:
 ffff88807a916000: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
 ffff88807a916080: 00 00 00 00 fc fc fc fc 00 00 05 fc fc fc fc fc
>ffff88807a916100: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
                                     ^
 ffff88807a916180: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
 ffff88807a916200: 00 00 00 00 fc fc fc fc 00 00 04 fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
