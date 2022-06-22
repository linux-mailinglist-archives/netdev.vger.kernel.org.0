Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF3553FD1
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 03:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355398AbiFVBBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 21:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiFVBB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 21:01:29 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FEF31903
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 18:01:25 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id q13-20020a5d9f0d000000b00669c03397f7so8417560iot.10
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 18:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5mPCIc9HWLqyDlRHAbHeSV4t2zvDD9FqrVDB16msq7Y=;
        b=pmN9RbI8oR/eOinObjJ/8Esv0EBnfgJrZlgVUnNEZiMBz4JpWFEvjSVzhgj6uSnkw2
         03bAbKTNlSd4LNR2PHu8lmebamVNVw5Ma7AIvKBotWUdZYh9LpV51i9CChEw7spQa6aT
         8D/K2//PE9NoGkxYPfMDc0NzWExXLEfTiS/GgDidci4DrCS/JIPji9kMuAtwDUPW4Dva
         633s0SLjQ25peLuzzLbjmd3saeSatY3y9vMLeLtkdvQ6RaRIKEp9ujJnA0cpj8TPhmwi
         OR1RX4jgtV0BOElPtC/fg739FyDeBd8HuSiGfN/w770WuTPg0PBtHLKlfGTX0DZfFyx8
         x3vQ==
X-Gm-Message-State: AJIora8HVj6CeECICMZbyZlzWXqkfsLDNZQvGZAGYZz4gAsPwBxGTV2e
        Xf87uUhNJsGsjq2Zu4gNq+kRJazV+SRaMwjcp6WeKk2ta9+e
X-Google-Smtp-Source: AGRyM1sTAfcNbJVV7eA2DE7yqMDl455yWDieF4f9Xfyuo0j0nM6y++/ilAjvK4ncxQzGAhWItevjhSp6ZeuKlqi0snprFhVmhwAV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:10cf:b0:2d9:2310:e6b3 with SMTP id
 s15-20020a056e0210cf00b002d92310e6b3mr599171ilj.212.1655859684903; Tue, 21
 Jun 2022 18:01:24 -0700 (PDT)
Date:   Tue, 21 Jun 2022 18:01:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005115d105e1fee003@google.com>
Subject: [syzbot] KASAN: use-after-free Read in free_netdev (3)
From:   syzbot <syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, idosch@nvidia.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
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

Hello,

syzbot found the following issue on:

HEAD commit:    b4a028c4d031 ipv4: ping: fix bind address validity check
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17a3ab08080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70e1a4d352a3c6ae
dashboard link: https://syzkaller.appspot.com/bug?extid=b75c138e9286ac742647
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15506c60080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116b6628080000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15270be8080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17270be8080000
console output: https://syzkaller.appspot.com/x/log.txt?x=13270be8080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com

netlink: 20 bytes leftover after parsing attributes in process `syz-executor304'.
==================================================================
BUG: KASAN: use-after-free in free_netdev+0x58c/0x620 net/core/dev.c:10704
Read of size 8 at addr ffff88807e9de738 by task syz-executor304/3633

CPU: 1 PID: 3633 Comm: syz-executor304 Not tainted 5.19.0-rc2-syzkaller-00103-gb4a028c4d031 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 free_netdev+0x58c/0x620 net/core/dev.c:10704
 netdev_run_todo+0xb48/0x10f0 net/core/dev.c:10356
 rtnl_unlock net/core/rtnetlink.c:147 [inline]
 rtnetlink_rcv_msg+0x447/0xc90 net/core/rtnetlink.c:6090
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fae52dad6e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fae52d5b308 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fae52e364e8 RCX: 00007fae52dad6e9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 00007fae52e364e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fae52e364ec
R13: 00007fae52e03494 R14: 74656e2f7665642f R15: 0000000000022000
 </TASK>

Allocated by task 3633:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:605 [inline]
 sk_prot_alloc+0x110/0x290 net/core/sock.c:1975
 sk_alloc+0x36/0x770 net/core/sock.c:2028
 tun_chr_open+0x7b/0x540 drivers/net/tun.c:3408
 misc_open+0x376/0x4a0 drivers/char/misc.c:143
 chrdev_open+0x266/0x770 fs/char_dev.c:414
 do_dentry_open+0x4a1/0x11f0 fs/open.c:848
 do_open fs/namei.c:3520 [inline]
 path_openat+0x1c71/0x2910 fs/namei.c:3653
 do_filp_open+0x1aa/0x400 fs/namei.c:3680
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1278
 do_sys_open fs/open.c:1294 [inline]
 __do_sys_openat fs/open.c:1310 [inline]
 __se_sys_openat fs/open.c:1305 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1305
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 3634:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1727 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1753
 slab_free mm/slub.c:3507 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4555
 sk_prot_free net/core/sock.c:2011 [inline]
 __sk_destruct+0x5e5/0x710 net/core/sock.c:2097
 sk_destruct net/core/sock.c:2112 [inline]
 __sk_free+0x1a4/0x4a0 net/core/sock.c:2123
 sk_free+0x78/0xa0 net/core/sock.c:2134
 sock_put include/net/sock.h:1927 [inline]
 __tun_detach+0xdb7/0x13e0 drivers/net/tun.c:680
 tun_detach drivers/net/tun.c:692 [inline]
 tun_chr_close+0x15c/0x180 drivers/net/tun.c:3444
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 ptrace_notify+0x114/0x140 kernel/signal.c:2353
 ptrace_report_syscall include/linux/ptrace.h:420 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
 syscall_exit_work kernel/entry/common.c:249 [inline]
 syscall_exit_to_user_mode_prepare+0xdb/0x230 kernel/entry/common.c:276
 __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
 syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff88807e9de000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1848 bytes inside of
 4096-byte region [ffff88807e9de000, ffff88807e9df000)

The buggy address belongs to the physical page:
page:ffffea0001fa7600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e9d8
head:ffffea0001fa7600 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888011842140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2984, tgid 2984 (udevd), ts 16101031779, free_ts 16095933951
 prep_new_page mm/page_alloc.c:2456 [inline]
 get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1797 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1942
 new_slab mm/slub.c:2002 [inline]
 ___slab_alloc+0x985/0xd90 mm/slub.c:3002
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3089
 slab_alloc_node mm/slub.c:3180 [inline]
 slab_alloc mm/slub.c:3222 [inline]
 __kmalloc+0x318/0x350 mm/slub.c:4413
 kmalloc include/linux/slab.h:605 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:320 [inline]
 tomoyo_file_open+0x9d/0xc0 security/tomoyo/tomoyo.c:315
 security_file_open+0x45/0xb0 security/security.c:1645
 do_dentry_open+0x349/0x11f0 fs/open.c:835
 do_open fs/namei.c:3520 [inline]
 path_openat+0x1c71/0x2910 fs/namei.c:3653
 do_filp_open+0x1aa/0x400 fs/namei.c:3680
 do_sys_openat2+0x16d/0x4c0 fs/open.c:1278
 do_sys_open fs/open.c:1294 [inline]
 __do_sys_openat fs/open.c:1310 [inline]
 __se_sys_openat fs/open.c:1305 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1305
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3438
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2521
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:750 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3222 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3229 [inline]
 kmem_cache_alloc_lru+0x31a/0x720 mm/slub.c:3246
 __d_alloc+0x32/0x960 fs/dcache.c:1769
 d_alloc+0x4a/0x230 fs/dcache.c:1849
 d_alloc_parallel+0xe7/0x1af0 fs/dcache.c:2601
 __lookup_slow+0x193/0x480 fs/namei.c:1686
 lookup_slow fs/namei.c:1718 [inline]
 walk_component+0x40f/0x6a0 fs/namei.c:2014
 lookup_last fs/namei.c:2469 [inline]
 path_lookupat+0x1bb/0x860 fs/namei.c:2493
 filename_lookup+0x1c6/0x590 fs/namei.c:2522
 vfs_statx+0x148/0x390 fs/stat.c:228
 vfs_fstatat+0x8c/0xb0 fs/stat.c:255

Memory state around the buggy address:
 ffff88807e9de600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e9de680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807e9de700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff88807e9de780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e9de800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
