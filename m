Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5723F3AD3D5
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhFRUrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:47:35 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:41600 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbhFRUrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 16:47:33 -0400
Received: by mail-il1-f197.google.com with SMTP id m15-20020a923f0f0000b02901ee102ac952so3618340ila.8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 13:45:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WWy358Ai3kRq2oHNuyRjq5Ya1NqTVhnP0/NxBKOX8F8=;
        b=No35tU0kwECrXLYFVzhO6ZH6jrecgUyfxj+57hgEP8aDm/LSCAS9LYdRUvUffg7Xj/
         eBvOZF0RkoyFHVu7fFIctmonXnY4rd9HTXB4z8UEXFjlgRja6NyfKA/juZe4YYus8cE1
         RZu2rlfSi997LopMNZtdWwTcO7JGQZTbWfEoXaB1KHy5F63um3sm2UPcrY9LkdmO8IkV
         ix39x9R59SpmEKDvh4TnlezrfYGkHxschQXtS03YQiIE1WqYKjxvk6KGn/F0SgI+UvoQ
         +tl9gsmaZylrW2M23GNqpBYYTNYp1eGa7splQB/W3cjpjaNTy8VwM9ABlg5pOLI4h+IM
         zTGw==
X-Gm-Message-State: AOAM532y0u2O2JsCXZklLIc6jOmg6GNXMbfkDh4+k5b1z1DLV4wGepIx
        HwBsJA3JBWPpguVmD4z2hGAqiYvXwxoOUxL+1ULBgxskNM/6
X-Google-Smtp-Source: ABdhPJx8Re1LIzYZ2B7UVB8Z4gWXT/X637J6gdoS+9MRRpNPWLdN6ZGOdDoLZTgQIKAoTCA5toghBPk9v6JwRevIjTbChfpPPDhB
MIME-Version: 1.0
X-Received: by 2002:a05:6638:191d:: with SMTP id p29mr5070003jal.75.1624049123988;
 Fri, 18 Jun 2021 13:45:23 -0700 (PDT)
Date:   Fri, 18 Jun 2021 13:45:23 -0700
In-Reply-To: <000000000000f034fc05c2da6617@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022183205c5106739@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in check_all_holdout_tasks_trace
From:   syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, dvyukov@google.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, john.fastabend@gmail.com,
        josh@joshtriplett.org, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        netdev@vger.kernel.org, paulmck@kernel.org, peterz@infradead.org,
        rcu@vger.kernel.org, rostedt@goodmis.org, shakeelb@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        yanfei.xu@windriver.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    0c38740c selftests/bpf: Fix ringbuf test fetching map FD
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=128a7e34300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6380da8984033f1
dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1264c2d7d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in check_all_holdout_tasks_trace+0x302/0x420 kernel/rcu/tasks.h:1084
Read of size 1 at addr ffff8880294cbc9c by task rcu_tasks_trace/12

CPU: 0 PID: 12 Comm: rcu_tasks_trace Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 check_all_holdout_tasks_trace+0x302/0x420 kernel/rcu/tasks.h:1084
 rcu_tasks_wait_gp+0x594/0xa60 kernel/rcu/tasks.h:358
 rcu_tasks_kthread+0x31c/0x6a0 kernel/rcu/tasks.h:224
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 8499:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:2913 [inline]
 kmem_cache_alloc_node+0x269/0x3e0 mm/slub.c:2949
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct kernel/fork.c:865 [inline]
 copy_process+0x5c8/0x7120 kernel/fork.c:1947
 kernel_clone+0xe7/0xab0 kernel/fork.c:2503
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2620
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 12:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1582 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1607
 slab_free mm/slub.c:3167 [inline]
 kmem_cache_free+0x8a/0x740 mm/slub.c:3183
 __put_task_struct+0x26f/0x400 kernel/fork.c:747
 trc_wait_for_one_reader kernel/rcu/tasks.h:935 [inline]
 check_all_holdout_tasks_trace+0x179/0x420 kernel/rcu/tasks.h:1081
 rcu_tasks_wait_gp+0x594/0xa60 kernel/rcu/tasks.h:358
 rcu_tasks_kthread+0x31c/0x6a0 kernel/rcu/tasks.h:224
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3038 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
 put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:180
 release_task+0xca1/0x1690 kernel/exit.c:226
 wait_task_zombie kernel/exit.c:1108 [inline]
 wait_consider_task+0x2fb5/0x3b40 kernel/exit.c:1335
 do_wait_thread kernel/exit.c:1398 [inline]
 do_wait+0x724/0xd40 kernel/exit.c:1515
 kernel_wait4+0x14c/0x260 kernel/exit.c:1678
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1706
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3038 [inline]
 call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
 put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:180
 release_task+0xca1/0x1690 kernel/exit.c:226
 wait_task_zombie kernel/exit.c:1108 [inline]
 wait_consider_task+0x2fb5/0x3b40 kernel/exit.c:1335
 do_wait_thread kernel/exit.c:1398 [inline]
 do_wait+0x724/0xd40 kernel/exit.c:1515
 kernel_wait4+0x14c/0x260 kernel/exit.c:1678
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1706
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8880294cb880
 which belongs to the cache task_struct of size 6976
The buggy address is located 1052 bytes inside of
 6976-byte region [ffff8880294cb880, ffff8880294cd3c0)
The buggy address belongs to the page:
page:ffffea0000a53200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x294c8
head:ffffea0000a53200 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea00008d6400 0000000200000002 ffff888140005140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2, ts 15187628853, free_ts 0
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1034/0x2bf0 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1645 [inline]
 allocate_slab+0x32e/0x4c0 mm/slub.c:1785
 new_slab mm/slub.c:1848 [inline]
 new_slab_objects mm/slub.c:2594 [inline]
 ___slab_alloc+0x4a1/0x810 mm/slub.c:2757
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2797
 slab_alloc_node mm/slub.c:2879 [inline]
 kmem_cache_alloc_node+0x12f/0x3e0 mm/slub.c:2949
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct kernel/fork.c:865 [inline]
 copy_process+0x5c8/0x7120 kernel/fork.c:1947
 kernel_clone+0xe7/0xab0 kernel/fork.c:2503
 kernel_thread+0xb5/0xf0 kernel/fork.c:2555
 create_kthread kernel/kthread.c:336 [inline]
 kthreadd+0x52a/0x790 kernel/kthread.c:679
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8880294cbb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880294cbc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880294cbc80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880294cbd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880294cbd80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

