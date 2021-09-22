Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47429413F0A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 03:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhIVBox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 21:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhIVBox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 21:44:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3172C061574;
        Tue, 21 Sep 2021 18:43:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23-20020a17090a591700b001976d2db364so1064371pji.2;
        Tue, 21 Sep 2021 18:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=bdMsUIUP0bTAoQb9ko1bPls66QU/alJ+APqCEVb81b4=;
        b=jOgHH8peKp3kUbD/tfBE5uyrQO3ytD+I8Jxsa/IyTHOZlDqBFO28H18IrXnBnLDo1v
         7bkL6oSdwJYF4+L7NrbrYyE8Qsny5SCKLLzD7yxLQC5wPvpC+p6uNNIO5+c1GfGRxXlS
         pe5E/6ZZTHwugODFSii5ncEpnSmD2flfNIsEf/RjOxZ7ylVjHrwprwUwfmkPzwx0en8r
         XMP6n7we8Npmu5i8DOkzC6X+Loolou/KsfqDiofpRiP99FixQh2tG3iA8Z8bMxXnXftF
         YeX/33sGMnrt6lM06SpY+bOch46W3Q9ar6jpEIc6Ew2ShHxR5+qNczoqj4CfX7vIyqZ0
         MnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=bdMsUIUP0bTAoQb9ko1bPls66QU/alJ+APqCEVb81b4=;
        b=vpdw8/4WKB5qvBP0cUmm64nyBHhBd40Paj+IWzMHj5/NX2zKhHOl3Gp1g+x9hRHkB0
         0dR0rkI/ywlGjrb+CfI3BWWwqu3NPGgj5Aa3IogsmO6Dlowju7GSXwuV5M+T3428ojbt
         pSsvXT8rnfMvEJlPIX0V7Aou0BlSZImZ6QjjtDJ+V1DYiHsIZ1P6p1Lda4BNOsUwuGwX
         sFAf7YfEB+1pjkwv6dIFZQ6znqQD7LZSNLwmoDZte52w6P9hKo/SyQO13NwOzJreKwe9
         /ay/FIUbQRxmjru42Xp+gCdAAtqnu0y5JqUSV5lH6qSSQJGZmoE5QWYnKwcxM8hLfIYj
         cYug==
X-Gm-Message-State: AOAM531P3JREMRAzs3KmrKMYy4olUI0kRQw8gLdmAmpMT3RduVCEugzz
        qGwdz+4wCUVznNJ+GGFTaA6584QJGKT+uySwnA==
X-Google-Smtp-Source: ABdhPJyMXjQkQClvgYSkiZhUquBdBXQELMvSyJHfDkNR3yye14CUMrkEKkeasIpreu9MSnlSXLKDcM9zwePuJt8psAI=
X-Received: by 2002:a17:902:d892:b0:138:abfd:ec7d with SMTP id
 b18-20020a170902d89200b00138abfdec7dmr30086182plz.15.1632275003136; Tue, 21
 Sep 2021 18:43:23 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 22 Sep 2021 09:43:11 +0800
Message-ID: <CACkBjsZC-3nm8FVhVfCAyodxbKAbdxUriZimwdq3JHH1=sxNcw@mail.gmail.com>
Subject: KASAN: use-after-free Read in tcp_write_timer_handler
To:     davem@davemloft.net, dsahern@kernel.org,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        songliubraving@fb.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 4357f03d6611 Merge tag 'pm-5.15-rc2
git tree: upstream
console output:
https://drive.google.com/file/d/1TvIf-dvfzbm8RKtYz9QHfPWixHnjIcFW/view?usp=sharing
kernel config: https://drive.google.com/file/d/1HKZtF_s3l6PL3OoQbNq_ei9CdBus-Tz0/view?usp=sharing
Similar report:
https://syzkaller.appspot.com/bug?id=83d75b561d8b1b2529c635338ecfb7136261db11

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

==================================================================
BUG: KASAN: use-after-free in tcp_probe_timer net/ipv4/tcp_timer.c:383 [inline]
BUG: KASAN: use-after-free in tcp_write_timer_handler+0x8fd/0x940
net/ipv4/tcp_timer.c:626
Read of size 1 at addr ffff88802272a0d5 by task syz-executor/12060

CPU: 2 PID: 12060 Comm: syz-executor Not tainted 5.15.0-rc1+ #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x93/0x334 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 tcp_probe_timer net/ipv4/tcp_timer.c:383 [inline]
 tcp_write_timer_handler+0x8fd/0x940 net/ipv4/tcp_timer.c:626
 tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x6b0/0xa90 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb6/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x1d7/0x93b kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0xf2/0x130 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:zap_pte_range mm/memory.c:1335 [inline]
RIP: 0010:zap_pmd_range mm/memory.c:1481 [inline]
RIP: 0010:zap_pud_range mm/memory.c:1510 [inline]
RIP: 0010:zap_p4d_range mm/memory.c:1531 [inline]
RIP: 0010:unmap_page_range+0xbdd/0x2da0 mm/memory.c:1552
Code: 00 00 00 48 89 44 24 08 e9 8a f5 ff ff e8 4b 97 ca ff 48 8b 74
24 08 4c 89 ea 48 8b 7c 24 48 e8 69 ec ff ff 48 83 7c 24 38 00 <49> 89
c7 0f 85 02 15 00 00 e8 25 97 ca ff 48 8b 44 24 10 48 8d 68
RSP: 0018:ffffc900092cf7a0 EFLAGS: 00000246
RAX: ffffea000080c780 RBX: 0000000000000025 RCX: ffff888104079c80
RDX: 0000000000000000 RSI: ffff888104079c80 RDI: 0000000000000002
RBP: 0000000000000001 R08: ffffffff81aba2c6 R09: 000000000013ffff
R10: 0000000000000006 R11: ffffed102080f390 R12: 0000000000000025
R13: 000000002031e025 R14: dffffc0000000000 R15: 00000000004db000
 unmap_single_vma+0x198/0x310 mm/memory.c:1597
 unmap_vmas+0x16d/0x2f0 mm/memory.c:1629
 exit_mmap+0x1d0/0x650 mm/mmap.c:3171
 __mmput kernel/fork.c:1115 [inline]
 mmput+0x16d/0x440 kernel/fork.c:1136
 exit_mm kernel/exit.c:501 [inline]
 do_exit+0xad6/0x2dd0 kernel/exit.c:812
 do_group_exit+0x125/0x340 kernel/exit.c:922
 get_signal+0x4d5/0x25a0 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: Unable to access opcode bytes at RIP 0x4739a3.
RSP: 002b:00007f4ef3c1bcd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffc59e0995f R14: 00007ffc59e09b00 R15: 00007f4ef3c1bdc0

Allocated by task 10273:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x83/0xb0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook+0x4d/0x4b0 mm/slab.h:519
 slab_alloc_node mm/slub.c:3206 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x150/0x340 mm/slub.c:3219
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 net_alloc net/core/net_namespace.c:402 [inline]
 copy_net_ns+0xea/0x660 net/core/net_namespace.c:457
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc8/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3077
 __do_sys_unshare kernel/fork.c:3151 [inline]
 __se_sys_unshare kernel/fork.c:3149 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3149
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888022729a40
 which belongs to the cache net_namespace of size 6464
The buggy address is located 1685 bytes inside of
 6464-byte region [ffff888022729a40, ffff88802272b380)
The buggy address belongs to the page:
page:ffffea000089ca00 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff888022729a40 pfn:0x22728
head:ffffea000089ca00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010e0c500
raw: ffff888022729a40 0000000080040002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 9342, ts 177339275214, free_ts 174923780601
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook mm/page_alloc.c:2418 [inline]
 prep_new_page+0x1a5/0x240 mm/page_alloc.c:2424
 get_page_from_freelist+0x1f10/0x3b70 mm/page_alloc.c:4153
 __alloc_pages+0x306/0x6e0 mm/page_alloc.c:5375
 alloc_pages+0x115/0x240 mm/mempolicy.c:2197
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab mm/slub.c:1900 [inline]
 new_slab+0x34a/0x480 mm/slub.c:1963
 ___slab_alloc+0xa9f/0x10d0 mm/slub.c:2994
 __slab_alloc.isra.0+0x4d/0xa0 mm/slub.c:3081
 slab_alloc_node mm/slub.c:3172 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x31e/0x340 mm/slub.c:3219
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 net_alloc net/core/net_namespace.c:402 [inline]
 copy_net_ns+0xea/0x660 net/core/net_namespace.c:457
 create_new_namespaces.isra.0+0x3cb/0xae0 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2d37/0x73d0 kernel/fork.c:2197
 kernel_clone+0xe7/0x10d0 kernel/fork.c:2584
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2701
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x412/0x900 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x19/0x580 mm/page_alloc.c:3394
 __unfreeze_partials+0x340/0x360 mm/slub.c:2495
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x13d/0x180 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x95/0xb0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook+0x4d/0x4b0 mm/slab.h:519
 slab_alloc_node mm/slub.c:3206 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x150/0x340 mm/slub.c:3219
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 jbd2_alloc_handle include/linux/jbd2.h:1603 [inline]
 new_handle fs/jbd2/transaction.c:481 [inline]
 jbd2__journal_start fs/jbd2/transaction.c:508 [inline]
 jbd2__journal_start+0x191/0x920 fs/jbd2/transaction.c:490
 __ext4_journal_start_sb+0x3a8/0x4a0 fs/ext4/ext4_jbd2.c:105
 __ext4_journal_start fs/ext4/ext4_jbd2.h:326 [inline]
 ext4_da_write_begin+0x4c5/0x1180 fs/ext4/inode.c:3002
 generic_perform_write+0x1fe/0x510 mm/filemap.c:3770
 ext4_buffered_write_iter+0x206/0x4c0 fs/ext4/file.c:269
 ext4_file_write_iter+0x42e/0x14a0 fs/ext4/file.c:680
 call_write_iter include/linux/fs.h:2163 [inline]
 do_iter_readv_writev+0x47b/0x750 fs/read_write.c:729
 do_iter_write fs/read_write.c:855 [inline]
 do_iter_write+0x18b/0x700 fs/read_write.c:836

Memory state around the buggy address:
 ffff888022729f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802272a000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802272a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff88802272a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802272a180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0: 00 00                add    %al,(%rax)
   2: 00 48 89              add    %cl,-0x77(%rax)
   5: 44 24 08              rex.R and $0x8,%al
   8: e9 8a f5 ff ff        jmpq   0xfffff597
   d: e8 4b 97 ca ff        callq  0xffca975d
  12: 48 8b 74 24 08        mov    0x8(%rsp),%rsi
  17: 4c 89 ea              mov    %r13,%rdx
  1a: 48 8b 7c 24 48        mov    0x48(%rsp),%rdi
  1f: e8 69 ec ff ff        callq  0xffffec8d
  24: 48 83 7c 24 38 00    cmpq   $0x0,0x38(%rsp)
* 2a: 49 89 c7              mov    %rax,%r15 <-- trapping instruction
  2d: 0f 85 02 15 00 00    jne    0x1535
  33: e8 25 97 ca ff        callq  0xffca975d
  38: 48 8b 44 24 10        mov    0x10(%rsp),%rax
  3d: 48                    rex.W
  3e: 8d                    .byte 0x8d
  3f: 68                    .byte 0x68
