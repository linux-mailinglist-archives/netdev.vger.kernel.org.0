Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8D64D76A
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 08:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiLOHtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 02:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOHtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 02:49:45 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3332CC94;
        Wed, 14 Dec 2022 23:49:43 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id f3so3643402pgc.2;
        Wed, 14 Dec 2022 23:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=638eiuU0ZsFEhpJsO+Ri4XHiM7p1FTomBDcD/XaCVLM=;
        b=jf6G6bI7ybe1rVTs0YPCuWFsqnsanYnALt3PZJhHFjnccY6ahEEDVPB145hAyw0CVK
         ZA4OHN0dz8W20bSqtamEeoYWZutaBFki14pDGT8yJI2lwthNhhidZ54oCR3cvOa1rcko
         jguCpKUsfikpJFOfTvKVSyp3Qg5AMZhXVrU25/rgjAJKNamDGYDnQ6frQPpcL93+C3EL
         cjFPFjULc6CIOE8FyjTShHKuxMVXmfWUEBaXrcTo1cu3tVy6HGd1YDvwLQeVhfvGsCkR
         61YsS/pKBwFz4IUCEqRxei6dLyVCb7DBKYQtDw38OMDcITvaQ/cf92AuAA8KKg0ngLqL
         5KhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=638eiuU0ZsFEhpJsO+Ri4XHiM7p1FTomBDcD/XaCVLM=;
        b=J9U4w8aPn1jBKZM+6uf54wvSIFi5urpeJTn7SEZjR1zQbz+M4TxXe6bC9B+u9XT23d
         HzMEjIrOPPC2gGdQ+3eLBh+8FDADeluteSrX7qZv6UvgqMsaiFZjvl+P+dxJJ9jT1p6X
         VORexkraIxbUyBA/YfgyfE1BPgo7up1jpvrXOjLgeVvNDZ8UAHSD0yBB4PVlusw5ANwn
         h7DvLWL93aSFBCsZAYWNHFuHxCnm0Ff6sHq3qp3TyQ+I4dAr+hTSFHOzfP/LSBWEPO3H
         25YXKOS1SDDs96Elf1ourYy64vFMD3DIlHFaQbJZw1ZHT+cEIGU+Uq6y6GTBNwYvOl8U
         E4yw==
X-Gm-Message-State: ANoB5pmDDo4UyhbEdcZnfc5Iy1KMy4djogWPyyzJ7z0Jcccf0MtCXyWp
        6oqb9JzQT+gIYiJccvTEwbMwWsnBNcYWnerxjA8ju8xt3A==
X-Google-Smtp-Source: AA0mqf5vZtoNJpQG4tjOHARM5i456I5xNknn9VZ4Zt8cqvsb6OQ/yWmhJLtDYfKnvOSxRnAfBUYKiZ0QWEwMEGzjPOA=
X-Received: by 2002:a63:5f83:0:b0:478:ab05:4da9 with SMTP id
 t125-20020a635f83000000b00478ab054da9mr20716217pgb.369.1671090582719; Wed, 14
 Dec 2022 23:49:42 -0800 (PST)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 15 Dec 2022 15:49:31 +0800
Message-ID: <CACkBjsbS0jeOUFzxWH-bBay9=cTQ_S2JbMnAa7V2sHpp_19PPw@mail.gmail.com>
Subject: KASAN: use-after-free Read in ___bpf_prog_run
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following KASAN report can be triggered by loading and test
running this simple BPF prog with a random data/ctx:

0: r0 = bpf_get_current_task_btf      ;
R0_w=trusted_ptr_task_struct(off=0,imm=0)
1: r0 = *(u32 *)(r0 +8192)       ;
R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
2: exit

I've simplified the C reproducer but didn't find the root cause.
JIT was disabled, and the interpreter triggered UAF when executing
the load insn. A slab-out-of-bound read can also be triggered:
https://pastebin.com/raw/g9zXr8jU

This can be reproduced on:

HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to test
padding handling of btf_dump
git tree: bpf-next
console log: https://pastebin.com/raw/1EUi9tJe
kernel config: https://pastebin.com/raw/rgY3AJDZ
C reproducer: https://pastebin.com/raw/cfVGuCBm

==================================================================
BUG: KASAN: use-after-free in ___bpf_prog_run+0x7f35/0x8fd0
kernel/bpf/core.c:1937
Read of size 4 at addr ffff88801f1f2000 by task a.out/7137

CPU: 3 PID: 7137 Comm: a.out Not tainted
6.1.0-rc8-02212-gef3911a3e4d6-dirty #137
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
1.16.1-1-1 04/01/2014
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x100/0x178 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:284 [inline]
print_report+0x167/0x46c mm/kasan/report.c:395
kasan_report+0xbf/0x1e0 mm/kasan/report.c:495
___bpf_prog_run+0x7f35/0x8fd0 kernel/bpf/core.c:1937
__bpf_prog_run32+0x9d/0xe0 kernel/bpf/core.c:2045
bpf_dispatcher_nop_func include/linux/bpf.h:1082 [inline]
__bpf_prog_run include/linux/filter.h:600 [inline]
bpf_prog_run include/linux/filter.h:607 [inline]
bpf_test_run+0x38e/0x980 net/bpf/test_run.c:402
bpf_prog_test_run_skb+0xb67/0x1dc0 net/bpf/test_run.c:1187
bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
__sys_bpf+0x1293/0x5840 kernel/bpf/syscall.c:4997
__do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
__se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
__x64_sys_bpf+0x78/0xc0 kernel/bpf/syscall.c:5081
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fb8adae4469
Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007fff514ad148 EFLAGS: 00000203 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8adae4469
RDX: 0000000000000025 RSI: 0000000020000200 RDI: 000000000000000a
RBP: 00007fff514ae2f0 R08: 00007fb8adb2dd70 R09: 00000b4100000218
R10: e67c061720b91d86 R11: 0000000000000203 R12: 000055ed87c00760
R13: 00007fff514ae3d0 R14: 0000000000000000 R15: 0000000000000000
</TASK>

Allocated by task 7128:
kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
kasan_set_track+0x25/0x30 mm/kasan/common.c:52
__kasan_slab_alloc+0x84/0x90 mm/kasan/common.c:325
kasan_slab_alloc include/linux/kasan.h:201 [inline]
slab_post_alloc_hook mm/slab.h:737 [inline]
slab_alloc_node mm/slub.c:3398 [inline]
kmem_cache_alloc_node+0x166/0x410 mm/slub.c:3443
alloc_task_struct_node kernel/fork.c:171 [inline]
dup_task_struct kernel/fork.c:966 [inline]
copy_process+0x5db/0x6f40 kernel/fork.c:2084
kernel_clone+0xe8/0x980 kernel/fork.c:2671
__do_sys_clone+0xc0/0x100 kernel/fork.c:2812
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 0:
kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
kasan_set_track+0x25/0x30 mm/kasan/common.c:52
kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:511
____kasan_slab_free mm/kasan/common.c:236 [inline]
____kasan_slab_free+0x15e/0x1b0 mm/kasan/common.c:200
kasan_slab_free include/linux/kasan.h:177 [inline]
slab_free_hook mm/slub.c:1724 [inline]
slab_free_freelist_hook+0x10b/0x1e0 mm/slub.c:1750
slab_free mm/slub.c:3661 [inline]
kmem_cache_free+0xee/0x5b0 mm/slub.c:3683
put_task_struct include/linux/sched/task.h:119 [inline]
delayed_put_task_struct+0x274/0x3e0 kernel/exit.c:178
rcu_do_batch kernel/rcu/tree.c:2250 [inline]
rcu_core+0x835/0x1980 kernel/rcu/tree.c:2510
__do_softirq+0x1f7/0xaf6 kernel/softirq.c:571

Last potentially related work creation:
kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
__kasan_record_aux_stack+0xbf/0xd0 mm/kasan/generic.c:481
call_rcu+0x9e/0x790 kernel/rcu/tree.c:2798
put_task_struct_rcu_user kernel/exit.c:184 [inline]
put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:181
release_task+0xe9e/0x1ae0 kernel/exit.c:234
wait_task_zombie kernel/exit.c:1136 [inline]
wait_consider_task+0x17d8/0x3e70 kernel/exit.c:1363
do_wait_thread kernel/exit.c:1426 [inline]
do_wait+0x75f/0xdc0 kernel/exit.c:1543
kernel_wait4+0x153/0x260 kernel/exit.c:1706
__do_sys_wait4+0x147/0x160 kernel/exit.c:1734
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
__kasan_record_aux_stack+0xbf/0xd0 mm/kasan/generic.c:481
call_rcu+0x9e/0x790 kernel/rcu/tree.c:2798
put_task_struct_rcu_user kernel/exit.c:184 [inline]
put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:181
release_task+0xe9e/0x1ae0 kernel/exit.c:234
wait_task_zombie kernel/exit.c:1136 [inline]
wait_consider_task+0x17d8/0x3e70 kernel/exit.c:1363
do_wait_thread kernel/exit.c:1426 [inline]
do_wait+0x75f/0xdc0 kernel/exit.c:1543
kernel_wait4+0x153/0x260 kernel/exit.c:1706
__do_sys_wait4+0x147/0x160 kernel/exit.c:1734
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88801f1f1d80
which belongs to the cache task_struct of size 7240
The buggy address is located 640 bytes inside of
7240-byte region [ffff88801f1f1d80, ffff88801f1f39c8)

The buggy address belongs to the physical page:
page:ffffea00007c7c00 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x1f1f0
head:ffffea00007c7c00 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff888013b2c081
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea00005e4200 dead000000000002 ffff88801322a000
raw: 0000000000000000 0000000080040004 00000001ffffffff ffff888013b2c081
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 16, tgid 16 (kworker/u17:1), ts 3731671201, free_ts 0
prep_new_page mm/page_alloc.c:2539 [inline]
get_page_from_freelist+0x10ce/0x2db0 mm/page_alloc.c:4291
__alloc_pages+0x1c8/0x5c0 mm/page_alloc.c:5558
alloc_pages+0x1a9/0x270 mm/mempolicy.c:2285
alloc_slab_page mm/slub.c:1794 [inline]
allocate_slab+0x24e/0x340 mm/slub.c:1939
new_slab mm/slub.c:1992 [inline]
___slab_alloc+0x89a/0x1400 mm/slub.c:3180
__slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
slab_alloc_node mm/slub.c:3364 [inline]
kmem_cache_alloc_node+0x12e/0x410 mm/slub.c:3443
alloc_task_struct_node kernel/fork.c:171 [inline]
dup_task_struct kernel/fork.c:966 [inline]
copy_process+0x5db/0x6f40 kernel/fork.c:2084
kernel_clone+0xe8/0x980 kernel/fork.c:2671
user_mode_thread+0xb4/0xf0 kernel/fork.c:2747
call_usermodehelper_exec_work kernel/umh.c:175 [inline]
call_usermodehelper_exec_work+0xcb/0x170 kernel/umh.c:161
process_one_work+0xa33/0x1720 kernel/workqueue.c:2289
worker_thread+0x67d/0x10e0 kernel/workqueue.c:2436
kthread+0x2e4/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
page_owner free stack trace missing

Memory state around the buggy address:
ffff88801f1f1f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
ffff88801f1f1f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801f1f2000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
^
ffff88801f1f2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
ffff88801f1f2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
