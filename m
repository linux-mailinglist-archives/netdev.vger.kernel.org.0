Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7E596CEF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbiHQKmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbiHQKmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:42:36 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A766745F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:42:35 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id q10-20020a056e020c2a00b002dedb497c7fso8816688ilg.16
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=dGf0k+8gaWLKZF0802lbU+hBLQGSChCQvh1ajDWAcoA=;
        b=BJWrBLMC7J7vFTqZsZsTxMQDItEutlMyiaFQ+q6w42D4VK7lgifnEba6y/r/G63OUY
         dOfWc7wS+zzMzc4i0jTWPUz7mXwml3lyAavGKLpuozWS771OAVAatXHnmlvWpp27ke/f
         7vyxQNRzntAe5Ta0KdkMVSi8+JSOJgAqd/JPY+nBL2V7EX2V3tFBP+5stfx32aZ6rfLZ
         fak2zuDSrUrflzMqcyNt9RC0PgmzyOH+pKRP90tDPJnwH7OplIzLKWaoLEll1OX88Ctu
         aF0jm4XnzlF+kwPM4yp0xBl8a0MiXByeCmGDh4hOTP7VdO+EBHgF2JeNME3Nn0lG1tzG
         EHOg==
X-Gm-Message-State: ACgBeo08K53Ik9I4CoHiH8d5qnTVDdIhBF11T1yKcneGB6Ch3uvH+YjC
        XsmtGqYrpIX7FI2NgpgZm/9JuKLfQ7qrZexQ1vsDXtATAFGz
X-Google-Smtp-Source: AA6agR5qkdM9MzspQ+NiB3humvMVExmDo8OhaPpID8tHtCE3K+O87UyGATco3xnjYi3pT0LdRl6zqFeGF2/OSkuAFVgMASf5IdBG
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca5:b0:2df:3283:b4a8 with SMTP id
 x5-20020a056e021ca500b002df3283b4a8mr12066898ill.131.1660732954380; Wed, 17
 Aug 2022 03:42:34 -0700 (PDT)
Date:   Wed, 17 Aug 2022 03:42:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d010b705e66d8520@google.com>
Subject: [syzbot] KASAN: use-after-free Read in mgmt_pending_remove
From:   syzbot <syzbot+915a8416bf15895b8e07@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    40b4ac880e21 net: lan966x: fix checking for return value o..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14d10915080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=924833c12349a8c0
dashboard link: https://syzkaller.appspot.com/bug?extid=915a8416bf15895b8e07
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=115e3d15080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12917dc3080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+915a8416bf15895b8e07@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0xde/0x110 lib/list_debug.c:46
Read of size 8 at addr ffff888020a29408 by task syz-executor378/3646

CPU: 1 PID: 3646 Comm: syz-executor378 Not tainted 5.19.0-syzkaller-13938-g40b4ac880e21 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 __list_del_entry_valid+0xde/0x110 lib/list_debug.c:46
 __list_del_entry include/linux/list.h:134 [inline]
 list_del include/linux/list.h:148 [inline]
 mgmt_pending_remove+0x1a/0x160 net/bluetooth/mgmt_util.c:314
 remove_adv_monitor+0x1b9/0x1c0 net/bluetooth/mgmt.c:5057
 hci_mgmt_cmd net/bluetooth/hci_sock.c:1619 [inline]
 hci_sock_sendmsg+0x1dee/0x2490 net/bluetooth/hci_sock.c:1739
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 sock_write_iter+0x291/0x3d0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2192 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9e9/0xdd0 fs/read_write.c:578
 ksys_write+0x1e8/0x250 fs/read_write.c:631
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f90195b9779
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffc4302508 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f90195b9779
RDX: 0000000000000008 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 00007fffc4302570 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000011 R14: 00007fffc4302580 R15: 0000000000000000
 </TASK>

Allocated by task 3646:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
 kmalloc include/linux/slab.h:600 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 mgmt_pending_new+0x57/0x290 net/bluetooth/mgmt_util.c:269
 mgmt_pending_add+0x34/0x160 net/bluetooth/mgmt_util.c:296
 remove_adv_monitor+0x120/0x1c0 net/bluetooth/mgmt.c:5040
 hci_mgmt_cmd net/bluetooth/hci_sock.c:1619 [inline]
 hci_sock_sendmsg+0x1dee/0x2490 net/bluetooth/hci_sock.c:1739
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 sock_write_iter+0x291/0x3d0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2192 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9e9/0xdd0 fs/read_write.c:578
 ksys_write+0x1e8/0x250 fs/read_write.c:631
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 3646:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:367 [inline]
 ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1754 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
 slab_free mm/slub.c:3534 [inline]
 kfree+0xe2/0x580 mm/slub.c:4562
 remove_adv_monitor+0x18b/0x1c0 net/bluetooth/mgmt.c:5050
 hci_mgmt_cmd net/bluetooth/hci_sock.c:1619 [inline]
 hci_sock_sendmsg+0x1dee/0x2490 net/bluetooth/hci_sock.c:1739
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 sock_write_iter+0x291/0x3d0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2192 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9e9/0xdd0 fs/read_write.c:578
 ksys_write+0x1e8/0x250 fs/read_write.c:631
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888020a29400
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 8 bytes inside of
 96-byte region [ffff888020a29400, ffff888020a29460)

The buggy address belongs to the physical page:
page:ffffea0000828a40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20a29
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000953600 dead000000000004 ffff888011841780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 2976, tgid 2976 (udevd), ts 23016454578, free_ts 23008667437
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:1824 [inline]
 allocate_slab+0x27e/0x3d0 mm/slub.c:1969
 new_slab mm/slub.c:2029 [inline]
 ___slab_alloc+0x7f1/0xe10 mm/slub.c:3031
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
 slab_alloc_node mm/slub.c:3209 [inline]
 slab_alloc mm/slub.c:3251 [inline]
 __kmalloc+0x32b/0x340 mm/slub.c:4420
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 tomoyo_encode+0x28/0x50 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x186/0x620 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1345
 vfs_getattr fs/stat.c:157 [inline]
 vfs_statx+0x16a/0x390 fs/stat.c:232
 vfs_fstatat+0x8c/0xb0 fs/stat.c:255
 __do_sys_newfstatat+0x91/0x110 fs/stat.c:425
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slub.c:3243 [inline]
 slab_alloc mm/slub.c:3251 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
 kmem_cache_alloc+0x267/0x3b0 mm/slub.c:3268
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:139
 getname_flags include/linux/audit.h:321 [inline]
 getname+0x8e/0xd0 fs/namei.c:218
 do_sys_openat2+0xf5/0x4c0 fs/open.c:1305
 do_sys_open fs/open.c:1327 [inline]
 __do_sys_openat fs/open.c:1343 [inline]
 __se_sys_openat fs/open.c:1338 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1338
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff888020a29300: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888020a29380: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888020a29400: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                      ^
 ffff888020a29480: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888020a29500: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
