Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B6954DC4E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 09:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359564AbiFPH6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 03:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359139AbiFPH6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 03:58:24 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC515B3F4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:58:21 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id r1-20020a6b8f01000000b00669d87aebc5so486896iod.18
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sGxImpxhD4BnXQPVGC953AQBXBQaUcD+L5GsSAV1Cck=;
        b=ADyvv6L7F1xs54GYIgh/gi1QO9qKGyKr1nfaBbxMJZ80IutR8uCZmkCsSWT9yqGjn+
         UGeatkE8mfz/z8q8577lChcakdJ8F77qBSrn3gYxmQ3ct3l8H6mddGIH1vZcKsc/HuOf
         92PfXyYJhzFX2Dyl+SjO63h9b3hRf4Ex70KRP9dmzFpIjanUS7cmh3NtG97CVwPraf5z
         RGZg8lp2Bx1pcpdX/do+Sz2l0QiNRApPB0uUbC9gs5esc8eDjV++3zPHCY0CPfnYv7A+
         bB2qEmgjDBBTZqv6N2I2YxHLl6DIX0bbYByI01Zrc/hgGqnsaG5KG3vNoD+GgKxLA0wu
         fWyQ==
X-Gm-Message-State: AJIora+rLbNTiGK2iG2qInxo/rGkVtEcF6wRVGWkiYbBc61tOPxF3MW/
        OuL/rQr2HZRMjv41WpU5uujUd3vhtIExeU3GhS2uj4TUxUlU
X-Google-Smtp-Source: AGRyM1sQwWSgbeTrEzw1GnK+CMyO7rX/jtG5jT8QKtuQBC+NX9F3Pyy+BaDGTkNQpdWqDCOe8swGBY7BuB4eJBLflDicMoVfcuYG
MIME-Version: 1.0
X-Received: by 2002:a02:cab3:0:b0:332:c2b:d815 with SMTP id
 e19-20020a02cab3000000b003320c2bd815mr1953754jap.79.1655366301305; Thu, 16
 Jun 2022 00:58:21 -0700 (PDT)
Date:   Thu, 16 Jun 2022 00:58:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005cd14505e18c007e@google.com>
Subject: [syzbot] KASAN: use-after-free Write in inet_put_port
From:   syzbot <syzbot+0a847a982613c6438fba@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
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

HEAD commit:    7a68065eb9cd Merge tag 'gpio-fixes-for-v5.19-rc2' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10bfcc6bf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d918e534921ed083
dashboard link: https://syzkaller.appspot.com/bug?extid=0a847a982613c6438fba
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0a847a982613c6438fba@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:886 [inline]
BUG: KASAN: use-after-free in inet_bind2_bucket_destroy net/ipv4/inet_hashtables.c:136 [inline]
BUG: KASAN: use-after-free in __inet_put_port net/ipv4/inet_hashtables.c:174 [inline]
BUG: KASAN: use-after-free in inet_put_port+0x4e6/0x590 net/ipv4/inet_hashtables.c:182
Write of size 8 at addr ffff888078a0b028 by task syz-executor.0/21904

CPU: 1 PID: 21904 Comm: syz-executor.0 Not tainted 5.19.0-rc1-syzkaller-00303-g7a68065eb9cd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
 print_address_description+0x65/0x4b0 mm/kasan/report.c:313
 print_report+0xf4/0x210 mm/kasan/report.c:429
 kasan_report+0xfb/0x130 mm/kasan/report.c:491
 __hlist_del include/linux/list.h:886 [inline]
 inet_bind2_bucket_destroy net/ipv4/inet_hashtables.c:136 [inline]
 __inet_put_port net/ipv4/inet_hashtables.c:174 [inline]
 inet_put_port+0x4e6/0x590 net/ipv4/inet_hashtables.c:182
 dccp_set_state+0x1b7/0x250 net/dccp/proto.c:103
 dccp_terminate_connection net/dccp/proto.c:969 [inline]
 dccp_close+0x873/0xfc0 net/dccp/proto.c:1023
 inet_release+0x184/0x1e0 net/ipv4/af_inet.c:428
 __sock_release net/socket.c:650 [inline]
 sock_close+0xd7/0x260 net/socket.c:1365
 __fput+0x3b9/0x820 fs/file_table.c:317
 task_work_run+0x146/0x1c0 kernel/task_work.c:177
 get_signal+0x15d9/0x1780 kernel/signal.c:2634
 arch_do_signal_or_restart+0x8d/0x750 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop+0x74/0x160 kernel/entry/common.c:166
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f19cb489109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f19cc573168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffe00 RBX: 00007f19cb59c100 RCX: 00007f19cb489109
RDX: 0000000000000010 RSI: 0000000020000180 RDI: 0000000000000006
RBP: 00007f19cb4e30ad R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fffda88fa9f R14: 00007f19cc573300 R15: 0000000000022000
 </TASK>

Allocated by task 21893:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0xb2/0xe0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:750 [inline]
 slab_alloc_node mm/slub.c:3214 [inline]
 slab_alloc mm/slub.c:3222 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3229 [inline]
 kmem_cache_alloc+0x199/0x2f0 mm/slub.c:3239
 inet_bind2_bucket_create net/ipv4/inet_hashtables.c:91 [inline]
 __inet_hash_connect+0xdf9/0x17c0 net/ipv4/inet_hashtables.c:951
 dccp_v4_connect+0x93b/0x1150 net/dccp/ipv4.c:108
 __inet_stream_connect+0x250/0xe10 net/ipv4/af_inet.c:660
 inet_stream_connect+0x61/0xa0 net/ipv4/af_inet.c:724
 __sys_connect_file net/socket.c:1979 [inline]
 __sys_connect+0x29b/0x2d0 net/socket.c:1996
 __do_sys_connect net/socket.c:2006 [inline]
 __se_sys_connect net/socket.c:2003 [inline]
 __x64_sys_connect+0x76/0x80 net/socket.c:2003
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 21893:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0xd8/0x110 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1727 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1753
 slab_free mm/slub.c:3507 [inline]
 kmem_cache_free+0xc7/0x270 mm/slub.c:3524
 inet_bind2_bucket_destroy net/ipv4/inet_hashtables.c:137 [inline]
 __inet_put_port net/ipv4/inet_hashtables.c:174 [inline]
 inet_put_port+0x500/0x590 net/ipv4/inet_hashtables.c:182
 dccp_set_state+0x1b7/0x250 net/dccp/proto.c:103
 dccp_terminate_connection net/dccp/proto.c:969 [inline]
 dccp_close+0x873/0xfc0 net/dccp/proto.c:1023
 inet_release+0x184/0x1e0 net/ipv4/af_inet.c:428
 __sock_release net/socket.c:650 [inline]
 sock_close+0xd7/0x260 net/socket.c:1365
 __fput+0x3b9/0x820 fs/file_table.c:317
 task_work_run+0x146/0x1c0 kernel/task_work.c:177
 get_signal+0x15d9/0x1780 kernel/signal.c:2634
 arch_do_signal_or_restart+0x8d/0x750 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop+0x74/0x160 kernel/entry/common.c:166
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff888078a0b000
 which belongs to the cache dccp_bind2_bucket of size 56
The buggy address is located 40 bytes inside of
 56-byte region [ffff888078a0b000, ffff888078a0b038)

The buggy address belongs to the physical page:
page:ffffea0001e282c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78a0b
memcg:ffff8880490a8a01
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 0000000000000000 dead000000000122 ffff88814a99e8c0
raw: 0000000000000000 0000000080200020 00000001ffffffff ffff8880490a8a01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_HARDWALL), pid 19042, tgid 19041 (syz-executor.3), ts 338492193643, free_ts 338281576402
 prep_new_page mm/page_alloc.c:2456 [inline]
 get_page_from_freelist+0x72b/0x7a0 mm/page_alloc.c:4198
 __alloc_pages+0x259/0x560 mm/page_alloc.c:5426
 alloc_slab_page+0x70/0xf0 mm/slub.c:1797
 allocate_slab+0x5e/0x520 mm/slub.c:1942
 new_slab mm/slub.c:2002 [inline]
 ___slab_alloc+0x41e/0xcd0 mm/slub.c:3002
 __slab_alloc mm/slub.c:3089 [inline]
 slab_alloc_node mm/slub.c:3180 [inline]
 slab_alloc mm/slub.c:3222 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3229 [inline]
 kmem_cache_alloc+0x246/0x2f0 mm/slub.c:3239
 inet_bind2_bucket_create+0x30/0x310 net/ipv4/inet_hashtables.c:91
 inet_csk_get_port+0x107f/0x17f0 net/ipv4/inet_connection_sock.c:501
 __inet6_bind+0xac5/0x12d0 net/ipv6/af_inet6.c:405
 inet6_bind+0x18d/0x250 net/ipv6/af_inet6.c:464
 __sys_bind+0x233/0x2e0 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x76/0x80 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0x812/0x900 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page_list+0x12c/0x890 mm/page_alloc.c:3475
 release_pages+0x2a04/0x2cb0 mm/swap.c:980
 tlb_batch_pages_flush mm/mmu_gather.c:58 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:255 [inline]
 tlb_flush_mmu+0x850/0xa70 mm/mmu_gather.c:262
 tlb_finish_mmu+0xcb/0x200 mm/mmu_gather.c:353
 exit_mmap+0x1dc/0x530 mm/mmap.c:3164
 __mmput+0x111/0x3a0 kernel/fork.c:1187
 exit_mm+0x211/0x2f0 kernel/exit.c:510
 do_exit+0x4ca/0x1ed0 kernel/exit.c:782
 do_group_exit+0x23b/0x2f0 kernel/exit.c:925
 get_signal+0x172f/0x1780 kernel/signal.c:2857
 arch_do_signal_or_restart+0x8d/0x750 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop+0x74/0x160 kernel/entry/common.c:166
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Memory state around the buggy address:
 ffff888078a0af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888078a0af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888078a0b000: fa fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
                                  ^
 ffff888078a0b080: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
 ffff888078a0b100: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
