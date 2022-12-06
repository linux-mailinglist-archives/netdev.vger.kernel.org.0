Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728B064495B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiLFQfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiLFQfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:35:22 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8304B5FE0
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:34:36 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id h10-20020a056e021b8a00b00302671bb5fdso14875699ili.21
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WseDIsbYMkjBZxEnErYcThjHgZolmvJOeRXwYnfIZTs=;
        b=tToWPstsZJjnYsgi1MZ+s0xIe82ryTR4mXuAagyYDJC4y1waFy36/r1wZtxVJq2tQ1
         vylMdmE4htf5Bcz1omR19YjRSuD3qBOn7fskt90YesF8jyHw9/lVqcas9wISURrKEM1R
         6Os5BMKC4pOVeadWQsuLUTcg8dDEOUcjq9r1U4Szzgw0nHkxyBPleFkUqd/ZPAkwXUSJ
         yQsWhvA5EzAutSqmAI4sLL3wInOdmJqY1tAvnXAIV08D6l3jcZhAjhjBJRVT47lq1yRI
         pqprDisWdDVqdaoMVXG7C7psNnqw48V5G+DWqIg9AEKYAmmBOYSkqPatv64/oXxqEmnz
         m1oA==
X-Gm-Message-State: ANoB5pnkhqEAnnf++pbMKgaSd5Y5FNCR1M+v4IyDLZstaD9h+9BMm/+K
        U7NrkRYTZpX+LWs7PiyPXTjSlCKmyTWSUZEH3l98pQYOBdMc
X-Google-Smtp-Source: AA0mqf6UXFIAzGE0f1Y9ZJgMVzdg9+EzFkyC2/niOzDj0JqeNp5y/KfSWQ1y9sqvjfB+4zhfsufJLlL01VB/4f8TmceJWtIBDMXV
MIME-Version: 1.0
X-Received: by 2002:a92:d9d0:0:b0:302:e43e:f817 with SMTP id
 n16-20020a92d9d0000000b00302e43ef817mr28831775ilq.250.1670344475841; Tue, 06
 Dec 2022 08:34:35 -0800 (PST)
Date:   Tue, 06 Dec 2022 08:34:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000229f1505ef2b6159@google.com>
Subject: [syzbot] KASAN: use-after-free Read in rxrpc_lookup_local
From:   syzbot <syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    c9f8d73645b6 net: mtk_eth_soc: enable flow offload support..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12f9af53880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c608c21151db14f2
dashboard link: https://syzkaller.appspot.com/bug?extid=3538a6a72efa8b059c38
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17fedb97880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1749f597880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bf270f71d81b/disk-c9f8d736.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9df5873e74c3/vmlinux-c9f8d736.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4db90f01e6d3/bzImage-c9f8d736.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rxrpc_local_cmp_key net/rxrpc/local_object.c:53 [inline]
BUG: KASAN: use-after-free in rxrpc_lookup_local+0xdcf/0xfb0 net/rxrpc/local_object.c:224
Read of size 2 at addr ffff888022b3521c by task syz-executor112/3641

CPU: 0 PID: 3641 Comm: syz-executor112 Not tainted 6.1.0-rc7-syzkaller-01810-gc9f8d73645b6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 rxrpc_local_cmp_key net/rxrpc/local_object.c:53 [inline]
 rxrpc_lookup_local+0xdcf/0xfb0 net/rxrpc/local_object.c:224
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 __sys_bind+0x1ed/0x260 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9f1c5edd39
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd21e4598 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 000000000000dd76 RCX: 00007f9f1c5edd39
RDX: 0000000000000024 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffdd21e4738 R09: 00007ffdd21e4738
R10: 00007ffdd21e4010 R11: 0000000000000246 R12: 00007ffdd21e45ac
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Allocated by task 3634:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:553 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 rxrpc_alloc_local net/rxrpc/local_object.c:93 [inline]
 rxrpc_lookup_local+0x4d9/0xfb0 net/rxrpc/local_object.c:249
 rxrpc_bind+0x35e/0x5c0 net/rxrpc/af_rxrpc.c:150
 __sys_bind+0x1ed/0x260 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 3624:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1724 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1750
 slab_free mm/slub.c:3661 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3674
 rcu_do_batch kernel/rcu/tree.c:2250 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2510
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x9d/0x820 kernel/rcu/tree.c:2798
 rxrpc_put_local.part.0+0x128/0x170 net/rxrpc/local_object.c:332
 rxrpc_put_local+0x25/0x30 net/rxrpc/local_object.c:324
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:888 [inline]
 rxrpc_release+0x237/0x550 net/rxrpc/af_rxrpc.c:914
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb3d/0x2a30 kernel/exit.c:820
 do_group_exit+0xd4/0x2a0 kernel/exit.c:950
 __do_sys_exit_group kernel/exit.c:961 [inline]
 __se_sys_exit_group kernel/exit.c:959 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:959
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888022b35000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 540 bytes inside of
 1024-byte region [ffff888022b35000, ffff888022b35400)

The buggy address belongs to the physical page:
page:ffffea00008acc00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22b30
head:ffffea00008acc00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888012041dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3624, tgid 3624 (sshd), ts 56650444929, free_ts 56632976403
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1794 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1939
 new_slab mm/slub.c:1992 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3180
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
 slab_alloc_node mm/slub.c:3364 [inline]
 __kmem_cache_alloc_node+0x199/0x3e0 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:975
 kmalloc_reserve net/core/skbuff.c:438 [inline]
 __alloc_skb+0xe9/0x310 net/core/skbuff.c:511
 alloc_skb_fclone include/linux/skbuff.h:1319 [inline]
 tcp_stream_alloc_skb+0x3c/0x580 net/ipv4/tcp.c:862
 tcp_sendmsg_locked+0xc4f/0x2960 net/ipv4/tcp.c:1325
 tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1483
 inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:827
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 sock_write_iter+0x295/0x3d0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2199 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9ed/0xdd0 fs/read_write.c:584
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x4d0 mm/page_alloc.c:3483
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2586
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x184/0x210 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3398 [inline]
 __kmem_cache_alloc_node+0x2e2/0x3e0 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:968
 kmalloc include/linux/slab.h:558 [inline]
 tomoyo_add_entry security/tomoyo/common.c:2022 [inline]
 tomoyo_supervisor+0xb60/0xf10 security/tomoyo/common.c:2094
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x183/0x200 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x13d2/0x1f80 security/tomoyo/domain.c:879
 tomoyo_bprm_check_security security/tomoyo/tomoyo.c:101 [inline]
 tomoyo_bprm_check_security+0x125/0x1b0 security/tomoyo/tomoyo.c:91
 security_bprm_check+0x49/0xb0 security/security.c:869
 search_binary_handler fs/exec.c:1715 [inline]
 exec_binprm fs/exec.c:1768 [inline]
 bprm_execve fs/exec.c:1837 [inline]
 bprm_execve+0x732/0x19f0 fs/exec.c:1799
 do_execveat_common+0x724/0x890 fs/exec.c:1942
 do_execve fs/exec.c:2016 [inline]
 __do_sys_execve fs/exec.c:2092 [inline]
 __se_sys_execve fs/exec.c:2087 [inline]
 __x64_sys_execve+0x93/0xc0 fs/exec.c:2087

Memory state around the buggy address:
 ffff888022b35100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888022b35180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888022b35200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff888022b35280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888022b35300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
