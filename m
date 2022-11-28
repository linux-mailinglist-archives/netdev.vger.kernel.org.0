Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF763A9CA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiK1Nmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiK1Nmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:42:35 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5840A382
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:42:31 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id q6-20020a056e020c2600b00302664fc72cso8839920ilg.14
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:42:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2+cfvaxHreOajFnU7N/RbXUq1BsiAabTyRF93AgS1Cg=;
        b=aqwyBV2L8DRbe0M5swh3ttB2Rj/qLBxYVgMPI71l0TUE/EThocsRODcMxyLv0vEXQ6
         9o58SOCv7SJywUf1gwLWhfr/+pd7Sk75qPacdiOXdcaYU7r4ZOxRygqpVGJB1+AiFkaV
         v/DZ0M2DGRXzzuNa/Kib0VIKbqBzRyN4KCjzrVrNWDFoJE9HbrzCcsc21H/Ij0af7WJx
         zN3075Wjqh2VssqXwMFEO0HmRhpSN2B3kTO/v56gZcWCECSnFcGs5Ulz/F7zz/NjNWhB
         9i7JMoW9may+eaBctS4ZN2+ZV8asf7nulGKVcmOrux2BQUE2RZgvQu+ECYVOpP9D2ue9
         Qtvg==
X-Gm-Message-State: ANoB5pntFOChy00snpiHmaz4YUbrtbwKtyxPaz06Yr2hHdL7gBN+zw2D
        Rw4ukJJMerZn02dnYEVj9qsetk0di0x8+H/tb8Eea7I4c0mY
X-Google-Smtp-Source: AA0mqf5C39Ialth7FmALnDsjf6BZoouCdEOuKsXAcKI3rCpQPXhxAu0EadMn8EM7naLyXGxn61C6myVfa0hAGDeGYmAUTY2Wl13Z
MIME-Version: 1.0
X-Received: by 2002:a02:665f:0:b0:375:7ab5:7158 with SMTP id
 l31-20020a02665f000000b003757ab57158mr16998670jaf.160.1669642950701; Mon, 28
 Nov 2022 05:42:30 -0800 (PST)
Date:   Mon, 28 Nov 2022 05:42:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa798505ee880a25@google.com>
Subject: [syzbot] KASAN: slab-out-of-bounds Write in __build_skb_around
From:   syzbot <syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        haoluo@google.com, hawk@kernel.org, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com, sdf@google.com,
        song@kernel.org, syzkaller-bugs@googlegroups.com, yhs@fb.com
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

HEAD commit:    c35bd4e42885 Add linux-next specific files for 20221124
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15e5d7e5880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
dashboard link: https://syzkaller.appspot.com/bug?extid=fda18eaa8c12534ccb3b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1096f205880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b2d68d880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/968fee464d14/disk-c35bd4e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f46fe801b5b/vmlinux-c35bd4e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2cdf8fb264e/bzImage-c35bd4e4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295

CPU: 0 PID: 5295 Comm: syz-executor413 Not tainted 6.1.0-rc6-next-20221124-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:253 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:364
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:464
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 memset+0x24/0x50 mm/kasan/shadow.c:44
 __build_skb_around+0x235/0x340 net/core/skbuff.c:294
 __build_skb+0x4f/0x60 net/core/skbuff.c:328
 build_skb+0x22/0x280 net/core/skbuff.c:340
 bpf_prog_test_run_skb+0x343/0x1e10 net/bpf/test_run.c:1131
 bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
 __sys_bpf+0x1599/0x4ff0 kernel/bpf/syscall.c:4997
 __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f30de9aad19
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeaee34318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f30de9aad19
RDX: 0000000000000028 RSI: 0000000020000180 RDI: 000000000000000a
RBP: 00007f30de96eec0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f30de96ef50
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Allocated by task 5295:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:376 [inline]
 ____kasan_kmalloc mm/kasan/common.c:335 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:385
 kasan_kmalloc include/linux/kasan.h:212 [inline]
 __do_kmalloc_node mm/slab_common.c:955 [inline]
 __kmalloc+0x5a/0xd0 mm/slab_common.c:968
 kmalloc include/linux/slab.h:575 [inline]
 kzalloc include/linux/slab.h:711 [inline]
 bpf_test_init.isra.0+0xa5/0x150 net/bpf/test_run.c:778
 bpf_prog_test_run_skb+0x22e/0x1e10 net/bpf/test_run.c:1097
 bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
 __sys_bpf+0x1599/0x4ff0 kernel/bpf/syscall.c:4997
 __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88802aa17000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 704 bytes inside of
 1024-byte region [ffff88802aa17000, ffff88802aa17400)

The buggy address belongs to the physical page:
page:ffffea0000aa8400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2aa10
head:ffffea0000aa8400 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5295, tgid 5295 (strace-static-x), ts 57049914920, free_ts 56991966201
 prep_new_page mm/page_alloc.c:2541 [inline]
 get_page_from_freelist+0x119c/0x2cd0 mm/page_alloc.c:4293
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5551
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1833 [inline]
 allocate_slab+0x25e/0x350 mm/slub.c:1980
 new_slab mm/slub.c:2033 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3211
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3310
 slab_alloc_node mm/slub.c:3395 [inline]
 __kmem_cache_alloc_node+0x1a9/0x430 mm/slub.c:3472
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc+0x4a/0xd0 mm/slab_common.c:968
 kmalloc include/linux/slab.h:575 [inline]
 kzalloc include/linux/slab.h:711 [inline]
 tomoyo_init_log+0x1282/0x1ec0 security/tomoyo/audit.c:275
 tomoyo_supervisor+0x354/0xf10 security/tomoyo/common.c:2088
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x183/0x200 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x13d2/0x1f80 security/tomoyo/domain.c:879
 tomoyo_bprm_check_security security/tomoyo/tomoyo.c:101 [inline]
 tomoyo_bprm_check_security+0x133/0x1c0 security/tomoyo/tomoyo.c:91
 security_bprm_check+0x49/0xb0 security/security.c:897
 search_binary_handler fs/exec.c:1723 [inline]
 exec_binprm fs/exec.c:1777 [inline]
 bprm_execve fs/exec.c:1851 [inline]
 bprm_execve+0x732/0x19f0 fs/exec.c:1808
 do_execveat_common+0x724/0x890 fs/exec.c:1956
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1448 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1498
 free_unref_page_prepare mm/page_alloc.c:3379 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3474
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2617
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:307
 kasan_slab_alloc include/linux/kasan.h:202 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3433 [inline]
 slab_alloc mm/slub.c:3441 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3448 [inline]
 kmem_cache_alloc+0x1e3/0x430 mm/slub.c:3457
 vm_area_alloc+0x20/0x100 kernel/fork.c:458
 mmap_region+0x44c/0x1dd0 mm/mmap.c:2605
 do_mmap+0x831/0xf60 mm/mmap.c:1412
 vm_mmap_pgoff+0x1af/0x280 mm/util.c:520
 ksys_mmap_pgoff+0x7d/0x5a0 mm/mmap.c:1458
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88802aa17180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88802aa17200: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff88802aa17280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                           ^
 ffff88802aa17300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802aa17380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
