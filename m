Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9060E76E
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 20:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiJZSaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 14:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbiJZSaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 14:30:20 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05ADF5E
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 11:29:36 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id s3-20020a5eaa03000000b006bbdfc81c6fso10957229ioe.4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 11:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbMjITi4oOoj8f0nD7La77apr6x51zwihRrLdJqW5LY=;
        b=rwANj+itW7LcKY2H/EiYRBmCk4T3wbuWOFp0TooUxwKlx53neXpzvCWnfLCfcaKOos
         EdFmmGKBjZ+zyNiJiPuXbA35Ak2YpmGkiB6ra31nRpqZnECCgwsnvpPQ1K6Z7kVJofDu
         HD2fZs/hehP/1RQ59IHxoXoaxRgjduX2xjOEgRWqZfE9kU8fa6qezHTBkKuJe9l+RGn/
         x7xDhr102+xheU2AJAwNDWpx1N1eBx4aSrhgMopV4Uvr4r/CmbMGVGllPYfZwm/TqnAb
         YAj7LSSGdUGpaJerMA6f+Fc+wsCEYy0mGQ5q+Pt0fdggFnmetTmFS0N0FK49qvpGsOxf
         98qw==
X-Gm-Message-State: ACrzQf3FRwdtx9w4ap2RmLlkFro0OMqpjJ+ne1zND7TsyO4o6BckdEGh
        XfMlk+m+0B+lPFvCh2xSnjL3VSv3bpyXxsp4FbvZii7c8sZC
X-Google-Smtp-Source: AMsMyM7LXY/rUKZdQFAcyEwT7u0LRpIuueS58T6VGZWKlqy6PANZ6N6h1pp/uwuVv2CX/z0EMNi0kVwgsWXHbs62/aCcTKh2v3n+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2589:b0:363:bc7a:19eb with SMTP id
 s9-20020a056638258900b00363bc7a19ebmr2309280jat.80.1666808975673; Wed, 26 Oct
 2022 11:29:35 -0700 (PDT)
Date:   Wed, 26 Oct 2022 11:29:35 -0700
In-Reply-To: <000000000000fad77705e7fd40fb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7513905ebf4346f@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in task_work_run (2)
From:   syzbot <syzbot+9228d6098455bb209ec8@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, dvyukov@google.com,
        ebiederm@xmission.com, keescook@chromium.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, luto@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        sumit.semwal@linaro.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    88619e77b33d net: stmmac: rk3588: Allow multiple gmac cont..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1646d6f2880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
dashboard link: https://syzkaller.appspot.com/bug?extid=9228d6098455bb209ec8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bc425e880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1126516e880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f8435d5c2c21/disk-88619e77.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/551d8a013e81/vmlinux-88619e77.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7d3f5c29064d/bzImage-88619e77.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9228d6098455bb209ec8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in task_work_run+0x1b0/0x270 kernel/task_work.c:178
Read of size 8 at addr ffff8880752b1c18 by task syz-executor361/3766

CPU: 0 PID: 3766 Comm: syz-executor361 Not tainted 6.1.0-rc2-syzkaller-00073-g88619e77b33d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
 task_work_run+0x1b0/0x270 kernel/task_work.c:178
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb35/0x2a20 kernel/exit.c:820
 do_group_exit+0xd0/0x2a0 kernel/exit.c:950
 get_signal+0x21a1/0x2430 kernel/signal.c:2858
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:296
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fb9f674b089
Code: Unable to access opcode bytes at 0x7fb9f674b05f.
RSP: 002b:00007fb9f66fb318 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 00007fb9f67da1a8 RCX: 00007fb9f674b089
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007fb9f67da1ac
RBP: 00007fb9f67da1a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000003100000400
R13: 00007fff658570cf R14: 00007fb9f66fb400 R15: 0000000000022000
 </TASK>

Allocated by task 3766:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 __kasan_slab_alloc+0x7e/0x80 mm/kasan/common.c:325
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3398 [inline]
 kmem_cache_alloc_node+0x2fc/0x400 mm/slub.c:3443
 perf_event_alloc.part.0+0x69/0x3bc0 kernel/events/core.c:11625
 perf_event_alloc kernel/events/core.c:12174 [inline]
 __do_sys_perf_event_open+0x4ae/0x32d0 kernel/events/core.c:12272
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 0:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2a/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1724 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1750
 slab_free mm/slub.c:3661 [inline]
 kmem_cache_free+0xea/0x5b0 mm/slub.c:3683
 rcu_do_batch kernel/rcu/tree.c:2250 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2510
 __do_softirq+0x1f7/0xad8 kernel/softirq.c:571

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 call_rcu+0x99/0x820 kernel/rcu/tree.c:2798
 put_event kernel/events/core.c:5095 [inline]
 perf_event_release_kernel+0x6f2/0x940 kernel/events/core.c:5210
 perf_release+0x33/0x40 kernel/events/core.c:5220
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16b/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:296
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 task_work_add+0x7b/0x2c0 kernel/task_work.c:48
 event_sched_out+0xe35/0x1190 kernel/events/core.c:2294
 __perf_remove_from_context+0x87/0xc40 kernel/events/core.c:2359
 event_function+0x29e/0x3e0 kernel/events/core.c:254
 remote_function kernel/events/core.c:92 [inline]
 remote_function+0x11e/0x1a0 kernel/events/core.c:72
 __flush_smp_call_function_queue+0x205/0x9a0 kernel/smp.c:630
 __sysvec_call_function_single+0xca/0x4d0 arch/x86/kernel/smp.c:248
 sysvec_call_function_single+0x8e/0xc0 arch/x86/kernel/smp.c:243
 asm_sysvec_call_function_single+0x16/0x20 arch/x86/include/asm/idtentry.h:657

The buggy address belongs to the object at ffff8880752b17c0
 which belongs to the cache perf_event of size 1392
The buggy address is located 1112 bytes inside of
 1392-byte region [ffff8880752b17c0, ffff8880752b1d30)

The buggy address belongs to the physical page:
page:ffffea0001d4ac00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x752b0
head:ffffea0001d4ac00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff8880118c23c0
raw: 0000000000000000 0000000080150015 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3754, tgid 3753 (syz-executor361), ts 58662170660, free_ts 58383135648
 prep_new_page mm/page_alloc.c:2538 [inline]
 get_page_from_freelist+0x10b5/0x2d50 mm/page_alloc.c:4287
 __alloc_pages+0x1c7/0x5a0 mm/page_alloc.c:5554
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2285
 alloc_slab_page mm/slub.c:1794 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1939
 new_slab mm/slub.c:1992 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3180
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
 slab_alloc_node mm/slub.c:3364 [inline]
 kmem_cache_alloc_node+0x189/0x400 mm/slub.c:3443
 perf_event_alloc.part.0+0x69/0x3bc0 kernel/events/core.c:11625
 perf_event_alloc kernel/events/core.c:12174 [inline]
 __do_sys_perf_event_open+0x4ae/0x32d0 kernel/events/core.c:12272
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1458 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1508
 free_unref_page_prepare mm/page_alloc.c:3386 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3482
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2586
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x62/0x80 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3398 [inline]
 slab_alloc mm/slub.c:3406 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3413 [inline]
 kmem_cache_alloc+0x2ac/0x3c0 mm/slub.c:3422
 kmem_cache_zalloc include/linux/slab.h:702 [inline]
 alloc_buffer_head+0x20/0x140 fs/buffer.c:2899
 alloc_page_buffers+0x280/0x790 fs/buffer.c:829
 create_empty_buffers+0x2c/0xf20 fs/buffer.c:1543
 ext4_block_write_begin+0x10a7/0x15f0 fs/ext4/inode.c:1074
 ext4_da_write_begin+0x44c/0xb50 fs/ext4/inode.c:3003
 generic_perform_write+0x252/0x570 mm/filemap.c:3753
 ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:285
 ext4_file_write_iter+0x8b8/0x16e0 fs/ext4/file.c:700
 __kernel_write_iter+0x25e/0x730 fs/read_write.c:517

Memory state around the buggy address:
 ffff8880752b1b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880752b1b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880752b1c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880752b1c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880752b1d00: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
==================================================================

