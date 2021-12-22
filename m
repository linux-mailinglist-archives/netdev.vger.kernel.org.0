Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E0347D06E
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbhLVLAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:00:42 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:50942 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244362AbhLVLAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:00:36 -0500
Received: by mail-io1-f70.google.com with SMTP id p129-20020a6b8d87000000b00601b30457cdso1048867iod.17
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:00:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GKX/d8iTHUta4j7+l6WF6B1hADn9V+84Bv3iJuqSE44=;
        b=lOvRhYLgGDPEW3e/K+CjDUWsbwRTCREUVNZhV6eQd0GzhwDI8NX6ZKyv/azlC7/vEy
         dfO0DptY2N05sRpgdaiPwZ7OoNiTZBGgiWsJE0xOo+ehG76bw+ztDc3Q+fGCFMihkF3d
         m1E6zzqoVTftkLAG2moEjdSRLCyXgBk5Xs3Z3DlTtd3fxRyztuCdhXnO4aYSdxaiqaY+
         cQsgTG79YbUTTJn3vnEqMY6RuVgy2wyGJk9kuqsFojb4CcZxTAsL/GSKWxOvtUT9KC5d
         1c1+WQ20EcmGmAwCH9fnN+e7aAa5J3f+caJCTkukPEQh4Q/L27/BVVTnBLcR/qmI9cYZ
         WYjA==
X-Gm-Message-State: AOAM531DnKd6vUawYjIF1O/sTDQm/ZcL8tbIKYVtcMxh5pJNz1ydW48y
        hQlTUXR6u2mdwaza1UAjR3KvegRAg+PBg86fIRGiYku8CoaV
X-Google-Smtp-Source: ABdhPJzDQee906NuLJIycYnVt2Nc0JabAzX9pZz4e5RvgxkmAtfCRVqDq1wRys3GlAV2KZ5xMgVzge06l3bMc7SUeprU3tbXtNz9
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3823:: with SMTP id i35mr1070513jav.213.1640170834581;
 Wed, 22 Dec 2021 03:00:34 -0800 (PST)
Date:   Wed, 22 Dec 2021 03:00:34 -0800
In-Reply-To: <00000000000045dc96059f4d7b02@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f75af905d3ba0716@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
From:   syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tpa@hlghospital.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    819d11507f66 bpf, selftests: Fix spelling mistake "tained"..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=138bf80db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=22b66456935ee10
dashboard link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172ccbcdb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14fcccedb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+694120e1002c117747ed@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in tcp_retransmit_timer+0x2ea2/0x3320 net/ipv4/tcp_timer.c:511
Read of size 8 at addr ffff888075d9b6d8 by task jbd2/sda1-8/2936

CPU: 1 PID: 2936 Comm: jbd2/sda1-8 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 tcp_retransmit_timer+0x2ea2/0x3320 net/ipv4/tcp_timer.c:511
 tcp_write_timer_handler+0x5e6/0xbc0 net/ipv4/tcp_timer.c:622
 tcp_write_timer+0xa2/0x2b0 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x1c/0x60 kernel/kcov.c:200
Code: be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 8b 05 29 be 8a 7e 89 c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b 14 25 40 70 02 00 <a9> 00 01 ff 00 74 0e 85 c9 74 35 8b 82 a4 15 00 00 85 c0 74 2b 8b
RSP: 0018:ffffc9000cc8f7e0 EFLAGS: 00000246
RAX: 0000000080000001 RBX: 0000000000005460 RCX: 0000000000000000
RDX: ffff88807dcdd700 RSI: ffffffff82149a29 RDI: 0000000000000003
RBP: 0000000000008000 R08: 0000000000008000 R09: ffff88801d0598ff
R10: ffffffff82149a1c R11: 0000000000000000 R12: ffff88801d059a88
R13: 00000000ffffffff R14: ffff88801d059000 R15: 00000000ffffffff
 mb_test_and_clear_bits+0xd9/0x240 fs/ext4/mballoc.c:1675
 mb_free_blocks+0x364/0x1370 fs/ext4/mballoc.c:1811
 ext4_free_data_in_buddy fs/ext4/mballoc.c:3662 [inline]
 ext4_process_freed_data+0x56c/0x1070 fs/ext4/mballoc.c:3713
 ext4_journal_commit_callback+0x11e/0x380 fs/ext4/super.c:449
 jbd2_journal_commit_transaction+0x55a8/0x6be0 fs/jbd2/commit.c:1171
 kjournald2+0x1d0/0x930 fs/jbd2/journal.c:213
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 3696:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:259 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:3234 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 kmem_cache_alloc+0x202/0x3a0 mm/slub.c:3247
 kmem_cache_zalloc include/linux/slab.h:714 [inline]
 net_alloc net/core/net_namespace.c:402 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:457
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3075
 __do_sys_unshare kernel/fork.c:3146 [inline]
 __se_sys_unshare kernel/fork.c:3144 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3144
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 503:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kmem_cache_free+0xbd/0x5d0 mm/slub.c:3530
 net_free net/core/net_namespace.c:431 [inline]
 net_free net/core/net_namespace.c:427 [inline]
 cleanup_net+0x8ba/0xb00 net/core/net_namespace.c:614
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888075d9b480
 which belongs to the cache net_namespace of size 6464
The buggy address is located 600 bytes inside of
 6464-byte region [ffff888075d9b480, ffff888075d9cdc0)
The buggy address belongs to the page:
page:ffffea0001d76600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x75d98
head:ffffea0001d76600 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011885000
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3693, ts 1611631437660, free_ts 92175173930
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 kmem_cache_alloc+0x35c/0x3a0 mm/slub.c:3247
 kmem_cache_zalloc include/linux/slab.h:714 [inline]
 net_alloc net/core/net_namespace.c:402 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:457
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3075
 __do_sys_unshare kernel/fork.c:3146 [inline]
 __se_sys_unshare kernel/fork.c:3144 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3144
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 __unfreeze_partials+0x343/0x360 mm/slub.c:2527
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:259 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:3234 [inline]
 kmem_cache_alloc_node+0x255/0x3f0 mm/slub.c:3270
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1126 [inline]
 alloc_skb_with_frags+0x93/0x620 net/core/skbuff.c:6078
 sock_alloc_send_pskb+0x783/0x910 net/core/sock.c:2575
 unix_dgram_sendmsg+0x3ec/0x1950 net/unix/af_unix.c:1811
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_write_iter+0x289/0x3c0 net/socket.c:1057
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x1ee/0x250 fs/read_write.c:643

Memory state around the buggy address:
 ffff888075d9b580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075d9b600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888075d9b680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888075d9b700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075d9b780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	be b0 01 00 00       	mov    $0x1b0,%esi
   5:	e8 b4 ff ff ff       	callq  0xffffffbe
   a:	31 c0                	xor    %eax,%eax
   c:	c3                   	retq
   d:	90                   	nop
   e:	65 8b 05 29 be 8a 7e 	mov    %gs:0x7e8abe29(%rip),%eax        # 0x7e8abe3e
  15:	89 c1                	mov    %eax,%ecx
  17:	48 8b 34 24          	mov    (%rsp),%rsi
  1b:	81 e1 00 01 00 00    	and    $0x100,%ecx
  21:	65 48 8b 14 25 40 70 	mov    %gs:0x27040,%rdx
  28:	02 00
* 2a:	a9 00 01 ff 00       	test   $0xff0100,%eax <-- trapping instruction
  2f:	74 0e                	je     0x3f
  31:	85 c9                	test   %ecx,%ecx
  33:	74 35                	je     0x6a
  35:	8b 82 a4 15 00 00    	mov    0x15a4(%rdx),%eax
  3b:	85 c0                	test   %eax,%eax
  3d:	74 2b                	je     0x6a
  3f:	8b                   	.byte 0x8b

