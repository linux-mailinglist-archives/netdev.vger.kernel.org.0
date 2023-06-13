Return-Path: <netdev+bounces-10475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F3F372EA9B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D5711C208D3
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E829A3D385;
	Tue, 13 Jun 2023 18:15:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101F238CA4;
	Tue, 13 Jun 2023 18:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DEAC433F0;
	Tue, 13 Jun 2023 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686680106;
	bh=vP9sQ/XFTk8yMRjHXZi3SkX7StaiGtOnKUv8pPvNJ4c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JZOiMUtmw+VhtyEhw5tIAKUAtayp/jNc2/qrDK+poirp2jvVf702aeihpLojUfbWr
	 RsiLltxvWn0LVf1iavqJ7q7LEnVzqzab06bnw6PPT5BSCwM9EbnnnvD0u4eMt7N8AT
	 tCKfDp3pRlPGL4jjmgcMjUOSM0iF8sDjZjFPJmj4BQT6yyzNd83TOAaclzDJnodoWT
	 Izzd74NZTf9A5J1jtuAo9zQY6i541U/SsjO3FjrtEunEbyskkiB1MWjf0QBkpJP+YB
	 gFGYFQRWs4N15azgBwuBVtXwJCZUsviRI0TIWCeNaty0sXRklby139HvmknbgHlUfY
	 VGCsoI4A87UEg==
Date: Tue, 13 Jun 2023 11:15:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: dhowells@redhat.com
Cc: syzbot <syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com>,
 bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [net?] KASAN: stack-out-of-bounds Read in
 skb_splice_from_iter
Message-ID: <20230613111505.249ccb18@kernel.org>
In-Reply-To: <000000000000ae4cbf05fdeb8349@google.com>
References: <000000000000ae4cbf05fdeb8349@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi David, are you fighting all these fires reported by syzbot?
I see another one just rolled in from yesterdays KCM changes.

On Mon, 12 Jun 2023 02:40:51 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e7c5433c5aaa tools: ynl: Remove duplicated include in hand..
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=109d3d1d280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
> dashboard link: https://syzkaller.appspot.com/bug?extid=d8486855ef44506fd675
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f22943280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e1363b280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/13c08af1fd21/disk-e7c5433c.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/35820511752b/vmlinux-e7c5433c.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6a8cbec0d40f/bzImage-e7c5433c.xz
> 
> The issue was bisected to:
> 
> commit 2dc334f1a63a8839b88483a3e73c0f27c9c1791c
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Jun 7 18:19:09 2023 +0000
> 
>     splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=149e0c8b280000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=169e0c8b280000
> console output: https://syzkaller.appspot.com/x/log.txt?x=129e0c8b280000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com
> Fixes: 2dc334f1a63a ("splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()")
> 
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in skb_splice_from_iter+0xcd6/0xd70 net/core/skbuff.c:6933
> Read of size 8 at addr ffffc900039bf8f8 by task syz-executor193/5001
> 
> CPU: 1 PID: 5001 Comm: syz-executor193 Not tainted 6.4.0-rc5-syzkaller-00915-ge7c5433c5aaa #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>  print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
>  print_report mm/kasan/report.c:462 [inline]
>  kasan_report+0x11c/0x130 mm/kasan/report.c:572
>  skb_splice_from_iter+0xcd6/0xd70 net/core/skbuff.c:6933
>  __ip_append_data+0x1439/0x3c20 net/ipv4/ip_output.c:1210
>  ip_append_data net/ipv4/ip_output.c:1350 [inline]
>  ip_append_data+0x115/0x1a0 net/ipv4/ip_output.c:1329
>  raw_sendmsg+0xb50/0x30a0 net/ipv4/raw.c:641
>  inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:829
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg+0xde/0x190 net/socket.c:747
>  splice_to_socket+0x954/0xe30 fs/splice.c:917
>  do_splice_from fs/splice.c:969 [inline]
>  do_splice+0xb8c/0x1e50 fs/splice.c:1309
>  __do_splice+0x14e/0x270 fs/splice.c:1387
>  __do_sys_splice fs/splice.c:1598 [inline]
>  __se_sys_splice fs/splice.c:1580 [inline]
>  __x64_sys_splice+0x19c/0x250 fs/splice.c:1580
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fba0bf36d29
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe0d4bac38 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fba0bf36d29
> RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007fba0befaed0 R08: 000000000004ffdd R09: 000000000000000d
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fba0befaf60
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> The buggy address belongs to stack of task syz-executor193/5001
>  and is located at offset 408 in frame:
>  raw_sendmsg+0x0/0x30a0 include/net/sock.h:2733
> 
> This frame has 8 objects:
>  [48, 52) 'hdrincl'
>  [64, 68) 'err'
>  [80, 88) 'rt'
>  [112, 152) 'ipc'
>  [192, 240) 'state'
>  [272, 336) 'fl4'
>  [368, 392) 'rfv'
>  [432, 504) 'opt_copy'
> 
> The buggy address belongs to the virtual mapping at
>  [ffffc900039b8000, ffffc900039c1000) created by:
>  kernel_clone+0xeb/0x890 kernel/fork.c:2915
> 
> The buggy address belongs to the physical page:
> page:ffffea0001d6c880 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x75b22
> flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
> page_type: 0xffffffff()
> raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_ZERO), pid 4968, tgid 4968 (dhcpcd-run-hook), ts 47435778840, free_ts 47434086594
>  set_page_owner include/linux/page_owner.h:31 [inline]
>  post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1731
>  prep_new_page mm/page_alloc.c:1738 [inline]
>  get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3502
>  __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4768
>  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2279
>  vm_area_alloc_pages mm/vmalloc.c:3009 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3085 [inline]
>  __vmalloc_node_range+0xb1c/0x14a0 mm/vmalloc.c:3257
>  alloc_thread_stack_node kernel/fork.c:313 [inline]
>  dup_task_struct kernel/fork.c:1116 [inline]
>  copy_process+0x13bb/0x75c0 kernel/fork.c:2333
>  kernel_clone+0xeb/0x890 kernel/fork.c:2915
>  __do_sys_clone+0xba/0x100 kernel/fork.c:3058
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1302 [inline]
>  free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2564
>  free_unref_page_list+0xe3/0xa70 mm/page_alloc.c:2705
>  release_pages+0xcd8/0x1380 mm/swap.c:1042
>  tlb_batch_pages_flush+0xa8/0x1a0 mm/mmu_gather.c:97
>  tlb_flush_mmu_free mm/mmu_gather.c:292 [inline]
>  tlb_flush_mmu mm/mmu_gather.c:299 [inline]
>  tlb_finish_mmu+0x14b/0x7e0 mm/mmu_gather.c:391
>  exit_mmap+0x2b2/0x930 mm/mmap.c:3123
>  __mmput+0x128/0x4c0 kernel/fork.c:1351
>  mmput+0x60/0x70 kernel/fork.c:1373
>  exit_mm kernel/exit.c:567 [inline]
>  do_exit+0x9b0/0x29b0 kernel/exit.c:861
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:1024
>  __do_sys_exit_group kernel/exit.c:1035 [inline]
>  __se_sys_exit_group kernel/exit.c:1033 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1033
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Memory state around the buggy address:
>  ffffc900039bf780: f1 f1 04 f2 00 00 00 f2 f2 f2 00 00 00 00 00 f2
>  ffffc900039bf800: f2 f2 f2 f2 00 00 00 00 00 00 f2 f2 f2 f2 00 00
> >ffffc900039bf880: 00 00 00 00 00 00 f2 f2 f2 f2 00 00 00 f2 f2 f2  
>                                                                 ^
>  ffffc900039bf900: f2 f2 00 00 00 00 00 00 00 00 00 f3 f3 f3 f3 f3
>  ffffc900039bf980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> If the bug is already fixed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to change bug's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the bug is a duplicate of another bug, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup


