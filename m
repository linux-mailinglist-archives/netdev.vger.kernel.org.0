Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1290B650A36
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiLSKhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiLSKhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:37:51 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A992716
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 02:37:50 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id g3-20020a056e021a2300b00305e3da9585so6353180ile.16
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 02:37:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MN2EWpHYQFYc/HKpaCBVTVic/neMpUMPorWKL36xRm0=;
        b=zJp8H79Mad/QepkCeVqvw2/NIRnP55MwhZZzpNA2JgrKVZJzKUEy+kvx/aWA4rDdAT
         13cOB4bgFwxALw4ICmKVJONQnF7aajq9hojZ9x3mwiPBq+KIzDwBSKMI0U2PPi87xptK
         63iiqNOzWe7JydNNR/a4iYfy7cuUISdQZa4cuIxf2t9NU9cuWFc5OocrGJPUCwBaYZ3o
         bZ7//KHYJfGiWi63yaT/0ujWOYJ5/Jp4V8JxfZmgKulD39cXNT1E2vMi8ReHHA//l0rI
         iYxrr06AMsIb9YqHTa6n2Mr6XSDVA8elHfl/y4kdTSTydH+SQ/w2uDQeqy+SBv1DcxHd
         pMMg==
X-Gm-Message-State: ANoB5plsM3ggj6NN+f88j2ERUDfGo/mRvbE3mxyl1sTs+8cZtx4cNJk0
        +AS+CL7hXN1IefLQAAGiWecf1I632xDwim94Z/26fxn69QAA
X-Google-Smtp-Source: AA0mqf5Upz7iDtfNWEC9L4RCQ9Ut4BwhupkP6RBCswjTvfwiQz1SbZR9ZTOSJqf+Q/DlG6Cp2xvGk4S/u2pdv5hydzPdQ/bHWTKv
MIME-Version: 1.0
X-Received: by 2002:a02:a88e:0:b0:38a:6579:50e6 with SMTP id
 l14-20020a02a88e000000b0038a657950e6mr8688128jam.185.1671446269433; Mon, 19
 Dec 2022 02:37:49 -0800 (PST)
Date:   Mon, 19 Dec 2022 02:37:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000269f9a05f02be9d8@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Write in copy_verifier_state
From:   syzbot <syzbot+59af7bf76d795311da8c@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, sdf@google.com,
        song@kernel.org, syzkaller-bugs@googlegroups.com, trix@redhat.com,
        yhs@fb.com
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

HEAD commit:    041fae9c105a Merge tag 'f2fs-for-6.2-rc1' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=136be5d0480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2f3d9d232a3cac5
dashboard link: https://syzkaller.appspot.com/bug?extid=59af7bf76d795311da8c
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1650d477880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1305f993880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e228bf558f91/disk-041fae9c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/11eeb90801b7/vmlinux-041fae9c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1f9651f3b5bd/bzImage-041fae9c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59af7bf76d795311da8c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in copy_array kernel/bpf/verifier.c:1072 [inline]
BUG: KASAN: slab-out-of-bounds in copy_verifier_state+0x130/0xbe0 kernel/bpf/verifier.c:1250
Write of size 80 at addr ffff888022c71000 by task syz-executor186/5067

CPU: 0 PID: 5067 Comm: syz-executor186 Not tainted 6.1.0-syzkaller-10971-g041fae9c105a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e3/0x2d0 lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:306
 print_report+0x107/0x220 mm/kasan/report.c:417
 kasan_report+0x139/0x170 mm/kasan/report.c:517
 kasan_check_range+0x2a7/0x2e0 mm/kasan/generic.c:189
 memcpy+0x3c/0x60 mm/kasan/shadow.c:66
 copy_array kernel/bpf/verifier.c:1072 [inline]
 copy_verifier_state+0x130/0xbe0 kernel/bpf/verifier.c:1250
 pop_stack kernel/bpf/verifier.c:1314 [inline]
 do_check+0x8e51/0x107b0 kernel/bpf/verifier.c:14031
 do_check_common+0x909/0x1800 kernel/bpf/verifier.c:16289
 do_check_main kernel/bpf/verifier.c:16352 [inline]
 bpf_check+0x107e2/0x16170 kernel/bpf/verifier.c:16936
 bpf_prog_load+0x1306/0x1be0 kernel/bpf/syscall.c:2619
 __sys_bpf+0x396/0x6d0 kernel/bpf/syscall.c:4979
 __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
 __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:5081
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7ff1fb190c29
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeaae55678 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff1fb190c29
RDX: 0000000000000048 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 00007ff1fb154dd0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ff1fb154e60
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Allocated by task 5067:
 kasan_save_stack mm/kasan/common.c:45 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 __kasan_krealloc+0xbf/0xf0 mm/kasan/common.c:439
 kasan_krealloc include/linux/kasan.h:231 [inline]
 __do_krealloc mm/slab_common.c:1361 [inline]
 krealloc+0xb2/0x110 mm/slab_common.c:1398
 push_jmp_history kernel/bpf/verifier.c:2592 [inline]
 is_state_visited kernel/bpf/verifier.c:13552 [inline]
 do_check+0x9433/0x107b0 kernel/bpf/verifier.c:13752
 do_check_common+0x909/0x1800 kernel/bpf/verifier.c:16289
 do_check_main kernel/bpf/verifier.c:16352 [inline]
 bpf_check+0x107e2/0x16170 kernel/bpf/verifier.c:16936
 bpf_prog_load+0x1306/0x1be0 kernel/bpf/syscall.c:2619
 __sys_bpf+0x396/0x6d0 kernel/bpf/syscall.c:4979
 __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
 __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:5081
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888022c71000
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 0 bytes inside of
 96-byte region [ffff888022c71000, ffff888022c71060)

The buggy address belongs to the physical page:
page:ffffea00008b1c40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x22c71
ksm flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff888012841780 ffffea0000a6d880 0000000000000003
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 4437, tgid 4437 (udevd), ts 26581643327, free_ts 26581082061
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x72b/0x7a0 mm/page_alloc.c:4283
 __alloc_pages+0x259/0x560 mm/page_alloc.c:5549
 alloc_slab_page+0xbd/0x190 mm/slub.c:1851
 allocate_slab+0x5e/0x3c0 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0x7f4/0xeb0 mm/slub.c:3193
 __slab_alloc mm/slub.c:3292 [inline]
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x25b/0x340 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0x9e/0x190 mm/slab_common.c:981
 kmalloc include/linux/slab.h:584 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
 tomoyo_encode+0x26f/0x540 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x5ae/0x5f0 security/tomoyo/realpath.c:283
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x280/0x680 security/tomoyo/file.c:822
 security_inode_getattr+0xc0/0x140 security/security.c:1375
 vfs_getattr fs/stat.c:161 [inline]
 vfs_statx+0x198/0x4b0 fs/stat.c:236
 vfs_fstatat fs/stat.c:270 [inline]
 __do_sys_newfstatat fs/stat.c:440 [inline]
 __se_sys_newfstatat+0x104/0x7b0 fs/stat.c:434
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x751/0x780 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x19/0x4c0 mm/page_alloc.c:3464
 free_pipe_info+0x302/0x380 fs/pipe.c:851
 put_pipe_info fs/pipe.c:711 [inline]
 pipe_release+0x232/0x310 fs/pipe.c:734
 __fput+0x3ba/0x880 fs/file_table.c:320
 task_work_run+0x243/0x300 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0x134/0x160 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x2e/0x60 kernel/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff888022c70f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888022c70f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888022c71000: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff888022c71080: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888022c71100: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
