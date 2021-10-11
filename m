Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD724299F9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 01:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhJKXtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 19:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhJKXtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 19:49:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E81BB600EF;
        Mon, 11 Oct 2021 23:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633996068;
        bh=8/gr/oEwosgEckZEY426I+AnZhmCw4JvuCWhUtiqRLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lv1p/mRiHACMb+Ia64XcWgaFEzjxjSCTOPsi89z4ICvI6MOi10vbdXnEjdK2Q7eno
         0Zv5CXxxiIgeFXAwmcy41Q2z3hd9l284Rz1+8h21rehbA2S1vcQCWs8Q+sBqM46Fiw
         DCc6X+eTw5DSCLI51c4vukKcin/Cg5rHvj8ijDG4jaB2KBIbrGQ9qPy7U+PPK4G13K
         4kCJMPvApodNkqnV39Xv2m9fc8V3+4QApC36x8YjZDo3ukRUhfj8GER5YWtNjdlOfR
         Zlyv4JAzAqo2LlufdJV4xPRXWZO4k060gAQnNo9MIia+cPsk1iKh0BbShdjeGq/ts3
         Rfw06Y0KQlL1g==
Date:   Mon, 11 Oct 2021 16:47:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+67f89551088ea1a6850e@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in veth_xdp_rcv
Message-ID: <20211011164747.303ffcd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <000000000000c1524005cdeacc5f@google.com>
References: <000000000000c1524005cdeacc5f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: Paolo, Toke

On Sat, 09 Oct 2021 05:40:24 -0700 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    af4bb50d4647 bpf, tests: Add more LD_IMM64 tests
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=129a1214b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
> dashboard link: https://syzkaller.appspot.com/bug?extid=67f89551088ea1a6850e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+67f89551088ea1a6850e@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __ptr_ring_peek include/linux/ptr_ring.h:172 [inline]
> BUG: KASAN: use-after-free in __ptr_ring_consume include/linux/ptr_ring.h:299 [inline]
> BUG: KASAN: use-after-free in veth_xdp_rcv+0x70b/0x810 drivers/net/veth.c:856
> Read of size 8 at addr ffff88804c47a1d8 by task ksoftirqd/0/13
> 
> CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.15.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  __ptr_ring_peek include/linux/ptr_ring.h:172 [inline]
>  __ptr_ring_consume include/linux/ptr_ring.h:299 [inline]
>  veth_xdp_rcv+0x70b/0x810 drivers/net/veth.c:856
>  veth_poll+0x134/0x850 drivers/net/veth.c:913
>  __napi_poll+0xaf/0x440 net/core/dev.c:6993
>  napi_poll net/core/dev.c:7060 [inline]
>  net_rx_action+0x801/0xb40 net/core/dev.c:7147
>  __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
>  run_ksoftirqd kernel/softirq.c:920 [inline]
>  run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
>  smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Allocated by task 23048:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:434 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:513 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:472 [inline]
>  __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
>  kmalloc_node include/linux/slab.h:614 [inline]
>  kvmalloc_node+0x61/0x120 mm/util.c:587
>  kvmalloc include/linux/mm.h:805 [inline]
>  kvmalloc_array include/linux/mm.h:823 [inline]
>  __ptr_ring_init_queue_alloc include/linux/ptr_ring.h:471 [inline]
>  ptr_ring_init include/linux/ptr_ring.h:489 [inline]
>  __veth_napi_enable_range+0xa2/0x780 drivers/net/veth.c:941
>  __veth_napi_enable drivers/net/veth.c:964 [inline]
>  veth_enable_xdp+0x30f/0x620 drivers/net/veth.c:1068
>  veth_xdp_set drivers/net/veth.c:1483 [inline]
>  veth_xdp+0x4d4/0x780 drivers/net/veth.c:1523
>  dev_xdp_install+0xd5/0x270 net/core/dev.c:9365
>  dev_xdp_attach+0x83d/0x1010 net/core/dev.c:9513
>  dev_xdp_attach_link net/core/dev.c:9532 [inline]
>  bpf_xdp_link_attach+0x262/0x410 net/core/dev.c:9695
>  link_create kernel/bpf/syscall.c:4258 [inline]
>  __sys_bpf+0x549c/0x5df0 kernel/bpf/syscall.c:4657
>  __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Freed by task 23044:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free mm/kasan/common.c:328 [inline]
>  __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:230 [inline]
>  slab_free_hook mm/slub.c:1700 [inline]
>  slab_free_freelist_hook+0x81/0x190 mm/slub.c:1725
>  slab_free mm/slub.c:3483 [inline]
>  kfree+0xe4/0x530 mm/slub.c:4543
>  kvfree+0x42/0x50 mm/util.c:620
>  ptr_ring_cleanup include/linux/ptr_ring.h:671 [inline]
>  veth_napi_del_range+0x3aa/0x560 drivers/net/veth.c:985
>  veth_napi_del drivers/net/veth.c:991 [inline]
>  veth_disable_xdp+0x2b3/0x430 drivers/net/veth.c:1101
>  veth_xdp_set drivers/net/veth.c:1499 [inline]
>  veth_xdp+0x698/0x780 drivers/net/veth.c:1523
>  dev_xdp_install+0x1ed/0x270 net/core/dev.c:9365
>  dev_xdp_detach_link net/core/dev.c:9549 [inline]
>  bpf_xdp_link_release+0x242/0x4e0 net/core/dev.c:9564
>  bpf_link_free+0xe6/0x1b0 kernel/bpf/syscall.c:2419
>  bpf_link_put+0x161/0x1b0 kernel/bpf/syscall.c:2445
>  bpf_link_release+0x33/0x40 kernel/bpf/syscall.c:2453
>  __fput+0x288/0x9f0 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>  exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
>  __call_rcu kernel/rcu/tree.c:2987 [inline]
>  call_rcu+0xb1/0x750 kernel/rcu/tree.c:3067
>  netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
>  __sock_release+0xcd/0x280 net/socket.c:649
>  sock_close+0x18/0x20 net/socket.c:1314
>  __fput+0x288/0x9f0 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>  exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
>  __call_rcu kernel/rcu/tree.c:2987 [inline]
>  call_rcu+0xb1/0x750 kernel/rcu/tree.c:3067
>  netlink_release+0xdd4/0x1dd0 net/netlink/af_netlink.c:812
>  __sock_release+0xcd/0x280 net/socket.c:649
>  sock_close+0x18/0x20 net/socket.c:1314
>  __fput+0x288/0x9f0 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>  exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The buggy address belongs to the object at ffff88804c47a000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 472 bytes inside of
>  2048-byte region [ffff88804c47a000, ffff88804c47a800)
> The buggy address belongs to the page:
> page:ffffea0001311e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4c478
> head:ffffea0001311e00 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c42000
> raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 19628, ts 447286861857, free_ts 447089779835
>  prep_new_page mm/page_alloc.c:2424 [inline]
>  get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4153
>  __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5375
>  alloc_pages+0x1a7/0x300 mm/mempolicy.c:2197
>  alloc_slab_page mm/slub.c:1763 [inline]
>  allocate_slab mm/slub.c:1900 [inline]
>  new_slab+0x319/0x490 mm/slub.c:1963
>  ___slab_alloc+0x921/0xfe0 mm/slub.c:2994
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3081
>  slab_alloc_node mm/slub.c:3172 [inline]
>  __kmalloc_node_track_caller+0x2d2/0x340 mm/slub.c:4936
>  kmalloc_reserve net/core/skbuff.c:352 [inline]
>  __alloc_skb+0xda/0x360 net/core/skbuff.c:424
>  alloc_skb include/linux/skbuff.h:1116 [inline]
>  nlmsg_new include/net/netlink.h:953 [inline]
>  rtmsg_ifinfo_build_skb+0x72/0x1a0 net/core/rtnetlink.c:3809
>  unregister_netdevice_many+0x9e4/0x1790 net/core/dev.c:11054
>  unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10984
>  unregister_netdevice include/linux/netdevice.h:2988 [inline]
>  __tun_detach+0x10ad/0x13d0 drivers/net/tun.c:670
>  tun_detach drivers/net/tun.c:687 [inline]
>  tun_chr_close+0xc4/0x180 drivers/net/tun.c:3397
>  __fput+0x288/0x9f0 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>  exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1338 [inline]
>  free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1389
>  free_unref_page_prepare mm/page_alloc.c:3315 [inline]
>  free_unref_page+0x19/0x690 mm/page_alloc.c:3394
>  __unfreeze_partials+0x340/0x360 mm/slub.c:2495
>  qlink_free mm/kasan/quarantine.c:146 [inline]
>  qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
>  kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
>  __kasan_slab_alloc+0x95/0xb0 mm/kasan/common.c:444
>  kasan_slab_alloc include/linux/kasan.h:254 [inline]
>  slab_post_alloc_hook mm/slab.h:519 [inline]
>  slab_alloc_node mm/slub.c:3206 [inline]
>  slab_alloc mm/slub.c:3214 [inline]
>  kmem_cache_alloc+0x209/0x390 mm/slub.c:3219
>  getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
>  getname_flags+0x9a/0xe0 include/linux/audit.h:319
>  user_path_at_empty+0x2b/0x60 fs/namei.c:2800
>  user_path_at include/linux/namei.h:57 [inline]
>  vfs_statx+0x142/0x390 fs/stat.c:221
>  vfs_fstatat fs/stat.c:243 [inline]
>  vfs_lstat include/linux/fs.h:3356 [inline]
>  __do_sys_newlstat+0x91/0x110 fs/stat.c:398
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Memory state around the buggy address:
>  ffff88804c47a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88804c47a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88804c47a180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb  
>                                                     ^
>  ffff88804c47a200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88804c47a280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

