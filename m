Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D477D48406E
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiADLCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiADLCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 06:02:16 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6082C061761;
        Tue,  4 Jan 2022 03:02:15 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d1so86429435ybh.6;
        Tue, 04 Jan 2022 03:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=mGlAodKEg9z1dZtJU5aJlKFvzAKcl398Jzhld4Dtd5E=;
        b=GNFWdPWGPNUYky15a67mmVA9WmI5fM7o98lQpaRQDc9NbSfJNnsK3tCbTyNbETfNEW
         EiYwLWU0nsff/aRuMx9tqKPG+320JpTkstf2z2aAJsK/W+Ow3QHcrgK49BlBeASgA0Or
         lvDA9fU9fdbvpd+ukMi+QuHEkAPVgMVsreI1G/JymOw2KBpw3paY5q+IlopODc6ZF6BR
         do41GEHFNE3AvJx5AevojzQzmEaunX2en4+Sr2cBQySo8NY0X+ZBIYihwOkBCr/OwqVp
         teaLTuuzjbypGS5j8kvaIGNr1i/VRPK0b1E6oLFEY6NxUBM3xIHDCpmPd1n1Yvl9hL7r
         WoUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=mGlAodKEg9z1dZtJU5aJlKFvzAKcl398Jzhld4Dtd5E=;
        b=8NH8O37duV28NiNCTFX7SmYIllWFnFOQxcNrtx6VkdECfD2Akvt06T+jUeaQyNkjW/
         W8Z7uqpd1zzmuIwqyZraV6F8pLaOJ4Gwyp+ELZ8t+oSiTwV5+KhrRj7/IsLlQMa4HWZZ
         q7WdH9koCnoOIVdPcWSSPxz4DfD+lm7SxjczqQeKLJUGkk6Gc8ua6UA8R3eoyuIz/5qe
         icIaGFH/saApRRo+v+zNKbWj1DO2KxOLV5YCxPr2FOHVyb8GUksq6f1Vuh+DgwMrpX0A
         Vb1JP/sEFROmFkLRX/kfODLG6qeuwExB2EqEY0QxPKtVpv/jpzE5QAdRP+kTHSqJZjc/
         5hrA==
X-Gm-Message-State: AOAM531Hjj4VZTjOmYTQvLyAQcGXqmClfgHAp3XDK558lX3RCWSopg1D
        6mDwNMyb4Oyrs2ujv+Dxw2AawrH/xa9bt6W0s2U=
X-Google-Smtp-Source: ABdhPJywWjC6AePs/Xpa/YX+KZrj/fRL506wP9t7ck+4j4GfzWpuPCux3kmdAUTyzMW2ZHAFIVi+vG7Nhy3icpX+5v0=
X-Received: by 2002:a25:3417:: with SMTP id b23mr53027951yba.91.1641294134140;
 Tue, 04 Jan 2022 03:02:14 -0800 (PST)
MIME-Version: 1.0
From:   kvartet <xyru1999@gmail.com>
Date:   Tue, 4 Jan 2022 19:02:03 +0800
Message-ID: <CAFkrUsjoPAdwRJemK2WK53xsp50PGBzYEVLoTv2itdxTd38JAw@mail.gmail.com>
Subject: INFO: task hung in xt_find_match
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Cc:     sunhao.th@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Syzkaller to fuzz the latest Linux kernel, the following
crash was triggered.

HEAD commit: a7904a538933 Linux 5.16-rc6
git tree: upstream
console output: https://paste.ubuntu.com/p/hFxPCTYb5S/plain/
kernel config: https://paste.ubuntu.com/p/FDDNHDxtwz/plain/

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.

If you fix this issue, please add the following tag to the commit:
Reported-by: Yiru Xu <xyru1999@gmail.com>

INFO: task syz-executor.6:13081 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.6  state:D stack:28544 pid:13081 ppid:  6803 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 xt_find_match net/netfilter/x_tables.c:205 [inline]
 xt_find_match+0xa1/0x270 net/netfilter/x_tables.c:197
 xt_request_find_match net/netfilter/x_tables.c:235 [inline]
 xt_request_find_match+0x88/0x120 net/netfilter/x_tables.c:228
 find_check_match net/ipv6/netfilter/ip6_tables.c:500 [inline]
 find_check_entry.isra.0+0x236/0x930 net/ipv6/netfilter/ip6_tables.c:558
 translate_table+0xc99/0x16d0 net/ipv6/netfilter/ip6_tables.c:735
 do_replace net/ipv6/netfilter/ip6_tables.c:1153 [inline]
 do_ip6t_set_ctl+0x50e/0xb10 net/ipv6/netfilter/ip6_tables.c:1639
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x15f/0x190 net/ipv6/ipv6_sockglue.c:1017
 sctp_setsockopt+0x149/0xa8d0 net/sctp/socket.c:4576
 __sys_setsockopt+0x2db/0x610 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f813396889d
RSP: 002b:00007f81322d9c28 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f8133a87f60 RCX: 00007f813396889d
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 00007f81339d500d R08: 00000000000003c8 R09: 0000000000000000
R10: 0000000020000340 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffea5194ecf R14: 00007f8133a87f60 R15: 00007f81322d9dc0
 </TASK>

Showing all locks held in the system:
2 locks held by systemd/1:
 #0: ffff88801a675550 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff88801a675550 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
3 locks held by kworker/u8:1/10:
1 lock held by khungtaskd/40:
 #0: ffffffff8bb80e20 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
1 lock held by systemd-journal/3055:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by systemd-udevd/3058:
 #0: ffff88801a676940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff88801a676940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by in:imklog/6770:
 #0: ffff88802a735f48 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff88802a735f48 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by rs:main Q:Reg/6771:
 #0: ffff888018678af0 (&f->f_pos_lock){+.+.}-{3:3}, at:
__fdget_pos+0xe9/0x100 fs/file.c:1034
 #1: ffff888102a10460 (sb_writers#5){.+.+}-{0:0}, at:
ksys_write+0x12d/0x250 fs/read_write.c:643
 #2: ffff88802a49e7a0 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at:
inode_lock include/linux/fs.h:783 [inline]
 #2: ffff88802a49e7a0 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at:
ext4_buffered_write_iter+0xb8/0x360 fs/ext4/file.c:263
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6713:
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6714:
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6715:
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6727:
 #0: ffff8880178ac028 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff8880178ac028 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6786:
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880286d8f88 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/6796:
 #0: ffff8880286d9980
 (
mapping.invalidate_lock){++++}-{3:3}
, at: filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
, at: filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.2/6799:
 #0: ffff8880286d9980 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880286d9980 (mapping.invalidate_lock){++++}-{3:3}, at:
page_cache_ra_unbounded+0x1bc/0x950 mm/readahead.c:194
1 lock held by syz-executor.7/6800:
 #0: ffff888015d04d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
1 lock held by syz-executor.5/6802:
 #0: ffff888015d04d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
2 locks held by kworker/u8:6/11683:
2 locks held by syz-executor.3/16727:
 #0: ffff888015d04d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.0/10214:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
3 locks held by kworker/0:0/12374:
3 locks held by kworker/3:14/17038:
2 locks held by syz-executor.1/8381:
 #0: ffff8880286d9980 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880286d9980 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by kworker/2:20/8392:
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff888010c66138
((wq_completion)events_freezable_power_){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2269
 #1: ffffc90019bbfdc8
((work_completion)(&(&ev->dwork)->work)){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2273
4 locks held by syz-executor.4/11310:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024074728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888024074728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888024074728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880ba900828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880ba900828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880ba900828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11313:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024071d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888024071d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888024071d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888086b31628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888086b31628 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888086b31628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11315:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888054c37828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888054c37828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888054c37828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b254d528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b254d528 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b254d528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11316:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff888024074028
 (&mm->mmap_lock
#2){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b18b3228 (
&mm->mmap_lock
/1
){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11318:
 #0:
ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024075528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888024075528 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888024075528 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880aabd7128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880aabd7128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880aabd7128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11319:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888054c30128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888054c30128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888054c30128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a7d0f128
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11321:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024074e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888024074e28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888024074e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880921c7128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880921c7128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880921c7128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11324:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888054c37128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888054c37128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888054c37128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a1b35c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a1b35c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a1b35c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11327:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888054c36328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888054c36328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888054c36328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a969e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a969e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a969e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim
mm/page_alloc.c:4609 [inline]
 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11330:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888083379d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888083379d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888083379d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b50d3228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b50d3228 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b50d3228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11332:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff888024073228
 (&mm->mmap_lock#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff88809569c728
 (&mm->mmap_lock
/1
){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11333:
 #0:
ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88808337e328 (
&mm->mmap_lock
#2){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809168f128
 (&mm->mmap_lock
/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11334:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888083378828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888083378828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888083378828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888092abd528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888092abd528 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888092abd528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11335:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888022fb9d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888022fb9d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888022fb9d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880921c2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880921c2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880921c2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11336:
 #0:
ffffffff8bc53fd0 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88808337d528
 (&mm->mmap_lock
#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809d807128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809d807128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809d807128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11337:
 #0: ffff888024072b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff888024072b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11339:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b2ce28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b2ce28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b2ce28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff88809e3a8828 (
&mm->mmap_lock/1
){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140
 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11340:
 #0:
ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0
kernel/fork.c:1450
 #1: ffff888022fb8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888022fb8f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888022fb8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88808498ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88808498ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88808498ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11341:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024076a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888024076a28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888024076a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809eecf128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809eecf128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809eecf128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11343:
 #0: ffff888022fbf128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff888022fbf128 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11348:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11349:
 #0: ffffffff8bc53fd0 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88812f2a4e28
 (
&mm->mmap_lock#2){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888092abea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888092abea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888092abea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11350:
 #0:
ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff888025951628
 (&mm->mmap_lock
#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809db21628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809db21628 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809db21628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11351:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b2f828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b2f828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b2f828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a9720f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a9720f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a9720f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11352:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11353:
 #0: ffffffff8bc53fd0 (dup_mmap_sem
){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b28128 (&mm->mmap_lock#2){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b71c0128 (&mm->mmap_lock
/1
){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11354:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888022fbb928
 (&mm->mmap_lock
#2){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880af93ce28
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11355:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b29628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b29628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b29628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b18b5c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b18b5c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b18b5c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11356:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b2b228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b2b228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b2b228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880aaaa4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880aaaa4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880aaaa4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11357:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88812f2a7828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88812f2a7828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88812f2a7828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880aabd6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880aabd6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880aabd6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11358:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11359:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88812f2a0828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88812f2a0828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88812f2a0828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88808337ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88808337ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88808337ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11361:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b2c728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b2c728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b2c728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880ab892428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880ab892428 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880ab892428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11362:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88812f2a4728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88812f2a4728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88812f2a4728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff88809ff47128 (
&mm->mmap_lock
/1){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11364:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11368:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f3c8128
 (&mm->mmap_lock#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880872bb228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880872bb228 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880872bb228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11369:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f3ca428 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811f3ca428 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811f3ca428 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809db21d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809db21d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809db21d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11370:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f3cab28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811f3cab28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811f3cab28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a9720128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a9720128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a9720128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11371:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025955528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025955528 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025955528 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a05d3228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a05d3228 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a05d3228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11372:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11373:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024070128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888024070128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888024070128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888085ba5528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888085ba5528 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888085ba5528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11374:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b2ea28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b2ea28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b2ea28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880879a4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880879a4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880879a4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11375:
 #0: ffffffff8bc53fd0 (
dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88812f2a2b28 (&mm->mmap_lock
#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880ab894728
 (&mm->mmap_lock
/1){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11376:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888029b2dc28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888029b2dc28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888029b2dc28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888084934028
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11379:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025954028 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025954028 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025954028 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2d21628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2d21628 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2d21628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11380:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11383:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88812f2a3928 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88812f2a3928 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88812f2a3928 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff8880a1b33928 (&mm->mmap_lock/1
){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11384:
 #0: ffff888029b2f128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff888029b2f128 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11386:
 #0: ffff88808fb24728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff88808fb24728 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11388:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888024071628
 (&mm->mmap_lock#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888127583228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888127583228 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888127583228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11390:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f3cb228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811f3cb228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811f3cb228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b50d2b28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b50d2b28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b50d2b28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim
){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0
mm/page_alloc.c:5007
4 locks held by syz-executor.4/11391:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f3cdc28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811f3cdc28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811f3cdc28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888098e78828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888098e78828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888098e78828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11392:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888021a93928 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888021a93928 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888021a93928 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888122f54028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888122f54028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888122f54028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11393:
 #0: ffff88811f565c28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff88811f565c28 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11396:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9006a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9006a28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9006a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888021355c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888021355c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888021355c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11397:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9004e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9004e28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9004e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff888092abb928 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
ffff888092abb928 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
ffff888092abb928 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11399:
 #0:
ffffffff8bc53fd0 (
dup_mmap_sem
){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f3cd528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811f3cd528 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811f3cd528 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff8880a77f2b28
 (&mm->mmap_lock
/1){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11400:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025956328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025956328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025956328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888080e1b228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888080e1b228 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888080e1b228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11398:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811f567128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811f567128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811f567128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809569ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809569ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809569ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11401:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9007828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9007828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9007828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880aaaa2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880aaaa2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880aaaa2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11402:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9000f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9000f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9000f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809dd7f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809dd7f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809dd7f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11404:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888084ab3228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888084ab3228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888084ab3228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888084af0f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888084af0f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888084af0f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11403:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888021a96328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888021a96328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888021a96328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2686328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2686328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2686328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11405:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff8880606bf128
 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff8880a7d0dc28
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11406:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880b27db228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880b27db228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880b27db228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a8ce6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a8ce6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a8ce6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11409:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9003928 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9003928 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9003928 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2548128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2548128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2548128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11410:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880aefa8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880aefa8f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880aefa8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a1b34028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a1b34028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a1b34028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11411:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9001628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9001628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9001628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a8ce5c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a8ce5c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a8ce5c28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11412:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88811a772b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88811a772b28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88811a772b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b653b228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b653b228 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b653b228 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11413:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880aeface28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880aeface28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880aeface28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809fe3e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809fe3e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809fe3e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11414:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888127b5f128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888127b5f128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888127b5f128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b50d7828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b50d7828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b50d7828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (
fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11415:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888049f73228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888049f73228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888049f73228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888092aace28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888092aace28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888092aace28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11416:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880b27da428 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880b27da428 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880b27da428 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880813c0128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880813c0128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880813c0128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11417:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88809b8df828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88809b8df828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88809b8df828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b33ef128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b33ef128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b33ef128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11418:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11420:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880b27d8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880b27d8f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880b27d8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2684728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2684728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2684728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11421:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025956a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025956a28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025956a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b653c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b653c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b653c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11422:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88808fb21628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88808fb21628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88808fb21628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b33eea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b33eea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b33eea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11423:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880b3359d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880b3359d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880b3359d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809dd7ce28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809dd7ce28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809dd7ce28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11424:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888021a90f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888021a90f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888021a90f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff88809eecdc28 (&mm->mmap_lock
/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11425:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88811a770128
 (
&mm->mmap_lock
#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880aca99628 (&mm->mmap_lock/1
){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11426:
 #0:
ffff888084ab0f28 (
&mm->mmap_lock#2
){++++}-{3:3}, at: mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
){++++}-{3:3}, at: do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1:
ffffffff8bca5140 (fs_reclaim
){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0
mm/page_alloc.c:5007
4 locks held by syz-executor.4/11427:
 #0:
ffffffff8bc53fd0 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880b3358f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880b3358f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880b3358f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880ba906a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880ba906a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880ba906a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11428:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888049f77128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888049f77128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888049f77128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2685528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2685528 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2685528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11429:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88809b8dc728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88809b8dc728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88809b8dc728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b33e8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b33e8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b33e8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11430:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888126850f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888126850f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888126850f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880879a6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880879a6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880879a6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11431:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888084ab4028 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888084ab4028 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888084ab4028 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809db20f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809db20f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809db20f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11433:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888126854028 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888126854028 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888126854028 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a969ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a969ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a969ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11435:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888126854728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888126854728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888126854728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a248ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a248ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a248ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.4/11436:
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #0: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11437:
4 locks held by syz-executor.4/11438:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880a9000128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880a9000128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880a9000128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2:
ffff88809e3af828
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11439:
 #0: ffff888126855528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff888126855528 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11440:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880b27d9d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880b27d9d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880b27d9d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809eecc028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809eecc028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809eecc028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11441:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88809b8db928
 (&mm->mmap_lock
#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b33edc28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b33edc28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b33edc28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (
fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-executor.4/11442:
 #0: ffff888021a91628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff888021a91628 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1:
ffffffff8bca5140
 (
fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11443:
 #0:
ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0
kernel/fork.c:1450
 #1: ffff888025952b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025952b28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025952b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a7366a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a7366a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a7366a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11444:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88808337b928 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88808337b928 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88808337b928 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809dd7ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809dd7ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809dd7ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140
 (
fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.4/11445:
 #0:
ffffffff8bc53fd0



Best Regards,
Yiru
