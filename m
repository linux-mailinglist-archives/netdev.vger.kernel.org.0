Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C521D650860
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 09:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiLSIEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 03:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLSIEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 03:04:45 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9CB2716
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 00:04:44 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id w18-20020a5d9cd2000000b006e32359d7fcso3727502iow.15
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 00:04:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R0whHs85VeMIptQ5Z3SuFgI5wPfZDxbSvQ/o8nvL+QE=;
        b=8CySv/8Zvf/f6NvMrl5V4WdEVPAZV8V48J9EHa6VWPZt/3yA80R3/97MZi2YN/db4V
         yXoRQEjDo61cCgEISDtvdpbpAbFJ70ZYxA4wUAeHZWTntlkPFZJwKB/JIRwbDVBZEJJG
         +2VNCB19y2SoQIH6tDh4ELebQfpqUPtb+3+b1N9fQFKSDCMv5tuHyyfh3YbEEP7Z74b/
         +FPsOWdye7QuPhhUsFJQP2VduWZsPvJDlb5ySoub9AgjfB0WPcTKHIwGKnewYGAozPl1
         yhyIwj4wtWRyZAz0Cb/3xcplkbszUbMYuuyYfgGpCL5tVY4LZ+aCctJVWir04lD0mvXV
         q3Pw==
X-Gm-Message-State: ANoB5pnelQe9d43WECXp94qlAX1fe/hqLRuvvuMgIJniHXEv6EhGgvtO
        1x7Nry8McAfFZjJyJRiiZTTZq2Mx7ys8I6qBJeSG+pgv5jFE
X-Google-Smtp-Source: AA0mqf7DlY9nTflHJhdGX0QGu4CIMOuLrYbMGh5wPo9h+7ThqkkHsA9DFM5/uwaR/Mv/G6KlHcU8C9yYJ3kjAP60LSSoNW4kmK20
MIME-Version: 1.0
X-Received: by 2002:a92:2808:0:b0:302:f182:1b89 with SMTP id
 l8-20020a922808000000b00302f1821b89mr34560632ilf.249.1671437083607; Mon, 19
 Dec 2022 00:04:43 -0800 (PST)
Date:   Mon, 19 Dec 2022 00:04:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a20a2e05f029c577@google.com>
Subject: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
From:   syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
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

HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of https://git.kernel...
git tree:       bpf
console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df7e0480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e87100480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceeb13880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/373a99daa295/disk-13e3c779.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7fa71ed0fe17/vmlinux-13e3c779.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2842ad5c698b/bzImage-13e3c779.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
Read of size 8 at addr ffff8880237d6018 by task syz-executor287/8300

CPU: 0 PID: 8300 Comm: syz-executor287 Not tainted 6.1.0-syzkaller-09661-g13e3c7793e2f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
 put_pmu_ctx kernel/events/core.c:4913 [inline]
 put_pmu_ctx+0xad/0x390 kernel/events/core.c:4893
 _free_event+0x3c5/0x13d0 kernel/events/core.c:5196
 free_event+0x58/0xc0 kernel/events/core.c:5224
 __do_sys_perf_event_open+0x66d/0x2980 kernel/events/core.c:12701
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f3a2b1b3f29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4215df68 EFLAGS: 00000246 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f3a2b1b3f29
RDX: 0000000000000000 RSI: 0000000000002070 RDI: 0000000020000480
RBP: 0000000000000000 R08: 0000000000000008 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000012a59
R13: 00007fff4215df7c R14: 00007fff4215df90 R15: 00007fff4215df80
 </TASK>

Allocated by task 8300:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 alloc_perf_context kernel/events/core.c:4693 [inline]
 find_get_context+0xcc/0x810 kernel/events/core.c:4763
 __do_sys_perf_event_open+0x963/0x2980 kernel/events/core.c:12476
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 5310:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
 rcu_do_batch kernel/rcu/tree.c:2244 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2504
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x820 kernel/rcu/tree.c:2753
 put_ctx kernel/events/core.c:1180 [inline]
 put_ctx+0x116/0x1e0 kernel/events/core.c:1173
 perf_event_exit_task_context kernel/events/core.c:13046 [inline]
 perf_event_exit_task+0x556/0x760 kernel/events/core.c:13073
 do_exit+0xb4d/0x2a30 kernel/exit.c:829
 __do_sys_exit kernel/exit.c:917 [inline]
 __se_sys_exit kernel/exit.c:915 [inline]
 __x64_sys_exit+0x42/0x50 kernel/exit.c:915
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff8880237d6000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 24 bytes inside of
 512-byte region [ffff8880237d6000, ffff8880237d6200)

The buggy address belongs to the physical page:
page:ffffea00008df500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x237d4
head:ffffea00008df500 order:2 compound_mapcount:0 compound_pincount:0
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441c80 0000000000000000 dead000000000001
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2173, tgid 2173 (kworker/u4:3), ts 10211275854, free_ts 0
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4291
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5558
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 alloc_bprm+0x51/0x900 fs/exec.c:1510
 kernel_execve+0xaf/0x500 fs/exec.c:1981
 call_usermodehelper_exec_async+0x2e7/0x580 kernel/umh.c:113
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8880237d5f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880237d5f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880237d6000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880237d6080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880237d6100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
