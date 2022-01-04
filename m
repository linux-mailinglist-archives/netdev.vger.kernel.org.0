Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BFF483F04
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiADJSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiADJSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:18:52 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFE8C061761;
        Tue,  4 Jan 2022 01:18:51 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id o185so79156848ybo.12;
        Tue, 04 Jan 2022 01:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=r9handxJtW6sURqRQUmbX3ifZhJWRYF6CaAkJIn/Ejc=;
        b=JapFmm1XzYt3SdwUfwpMEalLQ+EiKmXNz3Z7zkR20eLHORobB8Fjww+fZI/iAwevAN
         b/GBhx3Q16YGVAm0NsXkbZKbemncv5kJFAs0fmC4of1RgZ/44dzP/UmrbCFVVeYMuaWo
         AD2q+DkS/w5hQ0nde9kTSMyaehzbwZqB8mWrFh7sNlnGMX/gopVxISfw8yplWeDbyCzj
         G0lQr8gjRvbP2Ll4kMfIu1xkczRGP1qEbAwgZNWfYcg3N50n83Xxv54jxSScfzHnmAYQ
         fld7tt7xWL1qZ75IrN7Nu6bTQ4LZBW8vu6RfIt92lkQpsAK6yQd3ooSpWdyyUciH8uHt
         vgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=r9handxJtW6sURqRQUmbX3ifZhJWRYF6CaAkJIn/Ejc=;
        b=mvuz9j/BoqpQHgDmix88jkdi4vt4qehnw8+hOwATTWJpSXqpiykAhcHRW+5TB4eAtS
         /JfvWceXeh3aGFScbBcKOaiRouxTq7Fl6JvcMTlH/+fc374wPPRm9KLWYVD1FqwqoJ3P
         bBG7xzqOQmrxZPY1IK8l/0PW0LnjLAoPW9nMvlcRaeLhC0nnihUc7R5x+2cnWdWGUiLi
         Rot5lhQiqZShgWsjMKd0RThXQuZM9aWGLenqcR9sKyboX0Z89n8twpUyOfvd2mCQB5j7
         +lHep56Ur0IzOEksLM+BWpEtHy73sw2iTtHUYQvWw2UBjIEBEAmT7cl+6HzjU7Xb2ofy
         nB3g==
X-Gm-Message-State: AOAM532alkgm9r2NYfFteuwNeN2U1Qm8TvESpjrStRDOoMXknx0ta4+y
        ZJo/hajY4zSItlHT1DJaJHHLWNUUnEhRRadeCYU=
X-Google-Smtp-Source: ABdhPJwMAoR5Glh2zoaBXWmguMjwQNhuxuitQZOclfRGIn3fClBrlDBxvRaPIb8Pdrswlc+OcZ46YyTI6aFbhJU4kos=
X-Received: by 2002:a25:305:: with SMTP id 5mr55225203ybd.439.1641287930167;
 Tue, 04 Jan 2022 01:18:50 -0800 (PST)
MIME-Version: 1.0
From:   kvartet <xyru1999@gmail.com>
Date:   Tue, 4 Jan 2022 17:18:39 +0800
Message-ID: <CAFkrUshxTc5xFdpp_MPfdtisNgf3SRUO0vNTh8bzagZ6kNwC3A@mail.gmail.com>
Subject: INFO: task hung in do_ip6t_get_ctl
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
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
console output: https://paste.ubuntu.com/p/BpKg5JbNvp/plain/
kernel config: https://paste.ubuntu.com/p/FDDNHDxtwz/plain/

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Yiru Xu <xyru1999@gmail.com>


INFO: task syz-executor.0:6784 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc6 #9
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:23800 pid: 6784 ppid:  6775 flags:0x00000000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xc48/0x1610 kernel/locking/mutex.c:740
 xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
 get_entries net/ipv6/netfilter/ip6_tables.c:1037 [inline]
 do_ip6t_get_ctl+0x405/0x9b0 net/ipv6/netfilter/ip6_tables.c:1672
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt net/ipv6/ipv6_sockglue.c:1495 [inline]
 ipv6_getsockopt+0x1f4/0x270 net/ipv6/ipv6_sockglue.c:1475
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4252
 __sys_getsockopt+0x21f/0x5f0 net/socket.c:2220
 __do_sys_getsockopt net/socket.c:2235 [inline]
 __se_sys_getsockopt net/socket.c:2232 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2232
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f49a729535e
RSP: 002b:00007fffb529abb8 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000000029 RCX: 00007f49a729535e
RDX: 0000000000000041 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 00007fffb529abe0 R08: 00007fffb529abdc R09: 00007fffb529b140
R10: 00007fffb529ac40 R11: 0000000000000212 R12: 00007fffb529ac40
R13: 0000000000000003 R14: 00007fffb529abdc R15: 00007f49a7385a40
 </TASK>

Showing all locks held in the system:
2 locks held by systemd/1:
 #0: ffff88801ec99980 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff88801ec99980 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by khungtaskd/39:
 #0: ffffffff8bb80e20 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
1 lock held by oom_reaper/40:
2 locks held by kswapd1/124:
2 locks held by systemd-journal/3057:
 #0: ffff888105e64460 (sb_writers#3){.+.+}-{0:0}, at: do_syscall_x64
arch/x86/entry/common.c:50 [inline]
 #0: ffff888105e64460 (sb_writers#3){.+.+}-{0:0}, at:
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 #1: ffffffff8c353758 (tomoyo_ss){....}-{0:0}, at:
tomoyo_path_perm+0x1c1/0x420 security/tomoyo/file.c:847
2 locks held by systemd-udevd/3067:
 #0: ffff888018b36940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888018b36940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by systemd-timesyn/3122:
 #0: ffff888018b36940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888018b36940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by sd-resolve/3128:
 #0: ffff8880258b5550 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880258b5550 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by in:imklog/6755:
 #0: ffff888018b36940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888018b36940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by rs:main Q:Reg/6756:
 #0: ffff8880258b6940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff8880258b6940 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1:
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by cron/6333:
 #0: ffff88801ec98de8 (&type->i_mutex_dir_key#4){++++}-{3:3}, at:
inode_lock_shared include/linux/fs.h:793 [inline]
 #0: ffff88801ec98de8 (&type->i_mutex_dir_key#4){++++}-{3:3}, at:
lookup_slow fs/namei.c:1673 [inline]
 #0: ffff88801ec98de8 (&type->i_mutex_dir_key#4){++++}-{3:3}, at:
walk_component+0x400/0x6a0 fs/namei.c:1970
2 locks held by syz-fuzzer/6682:
 #0: ffff8880170af828 (&mm->mmap_lock#2){++++}-{3:3}
, at: mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
, at: do_user_addr_fault+0x285/0x11c0 arch/x86/mm/fault.c:1338
 #1:
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6683:
 #0: ffff888106b7b768 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888106b7b768 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6684:
 #0: ffff888106b7b768 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888106b7b768 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6696:
 #0: ffff888106b7b768 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888106b7b768 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by syz-fuzzer/6774:
 #0:
ffff888106b7b768
 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.0/6784:
 #0: ffff8880201d0d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
5 locks held by syz-executor.2/6785:
 #0: ffff88810ae62460 (sb_writers#5){.+.+}-{0:0}, at:
do_unlinkat+0x17f/0x660 fs/namei.c:4146
 #1: ffff888055ef03f0 (&type->i_mutex_dir_key#4/1){+.+.}-{3:3}, at:
inode_lock_nested include/linux/fs.h:818 [inline]
 #1: ffff888055ef03f0 (&type->i_mutex_dir_key#4/1){+.+.}-{3:3}, at:
do_unlinkat+0x269/0x660 fs/namei.c:4150
 #2: ffff888055dde7a0 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at:
inode_lock include/linux/fs.h:783 [inline]
 #2: ffff888055dde7a0 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at:
vfs_unlink+0xd0/0x770 fs/namei.c:4089
 #3: ffff88810ae66990 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xf58/0x1360 fs/jbd2/transaction.c:466
 #4: ffff888106ba0648 (&mapping->i_mmap_rwsem){++++}-{3:3}, at:
i_mmap_lock_read include/linux/fs.h:513 [inline]
 #4: ffff888106ba0648 (&mapping->i_mmap_rwsem){++++}-{3:3}, at:
rmap_walk_file+0x86d/0xc20 mm/rmap.c:2345
2 locks held by syz-executor.4/6786:
 #0: ffff888106ba0590 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_invalidate_lock_shared include/linux/fs.h:838 [inline]
 #0: ffff888106ba0590 (mapping.invalidate_lock){++++}-{3:3}, at:
filemap_fault+0x1537/0x2400 mm/filemap.c:3096
 #1:
ffffffff8bca5140 (
fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
1 lock held by syz-executor.6/6787:
 #0: ffff8880201d0d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
2 locks held by syz-executor.5/6788:
 #0: ffff8880201d0d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #1: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
2 locks held by kworker/u8:3/8500:
4 locks held by kworker/u8:5/10342:
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff8881000ad938 ((wq_completion)netns){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2269
 #1: ffffc9001a027dc8 (net_cleanup_work){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2273
 #2:
ffffffff8d2eeb90 (pernet_ops_rwsem){++++}-{3:3}, at:
cleanup_net+0x9b/0xa90 net/core/net_namespace.c:555
 #3: ffff8880201d0d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table+0x12e/0x360 net/netfilter/x_tables.c:1221
2 locks held by kworker/2:88/25111:
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
 #1: ffffc90018df7dc8
((work_completion)(&(&ev->dwork)->work)){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2273
1 lock held by syz-executor.1/8118:
 #0: ffff8880201d0d88 (&xt[i].mutex){+.+.}-{3:3}, at:
xt_find_table_lock+0x147/0x690 net/netfilter/x_tables.c:1242
4 locks held by syz-executor.0/17374:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c2b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c2b28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c2b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888099e08828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888099e08828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888099e08828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17378:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c0828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c0828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c0828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888099c18128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888099c18128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888099c18128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17380:
 #0:
ffffffff8bc53fd0
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c0128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c0128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c0128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a5401628
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
4 locks held by syz-executor.0/17383:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c6a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c6a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880595a6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880595a6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880595a6a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17388:
 #0: ffffffff8bc53fd0 (dup_mmap_sem
){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88804fe39d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88804fe39d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88804fe39d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b4a20f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b4a20f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b4a20f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17389:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88804fe3c728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88804fe3c728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88804fe3c728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888094e44028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888094e44028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888094e44028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17390:
 #0: ffffffff8bc53fd0
 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c5528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c5528 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c5528 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b763e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b763e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b763e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17393:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff8880522c0f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
ffff8880522c0f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
ffff8880522c0f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888094227128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888094227128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888094227128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17394:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c1d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c1d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c1d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809988b928 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809988b928 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809988b928 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17396:
 #0:
ffffffff8bc53fd0 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88804fe3ce28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88804fe3ce28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88804fe3ce28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88812d49f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88812d49f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88812d49f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17397:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c7128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c7128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c7128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880ac735528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880ac735528 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880ac735528 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17399:
 #0:
ffffffff8bc53fd0 (
dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880629d2b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880629d2b28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880629d2b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a46edc28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a46edc28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a46edc28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17400:
 #0:
ffffffff8bc53fd0
 (
dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88804fe3f128
 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b1980128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b1980128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b1980128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17401:
 #0: ffffffff8bc53fd0 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275bdc28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275bdc28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275bdc28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a3737828 (&mm->mmap_lock
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
4 locks held by syz-executor.0/17402:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88804fe3a428 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88804fe3a428 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88804fe3a428 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a82c0128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a82c0128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a82c0128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17403:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275ba428 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275ba428 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275ba428 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2412428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2412428 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2412428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17405:
 #0: ffffffff8bc53fd0 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880522c6328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880522c6328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880522c6328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b4684028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b4684028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b4684028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17406:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275bf828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275bf828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275bf828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8881253a1d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8881253a1d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8881253a1d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (
fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17407:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275b9d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275b9d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275b9d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88809255ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88809255ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88809255ea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17408:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801cbbea28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801cbbea28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801cbbea28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a33c4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a33c4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a33c4728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17409:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801cbb8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801cbb8f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801cbb8f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a44cf128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a44cf128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a44cf128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17410:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88801cbb8828 (
&mm->mmap_lock
#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888087768828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888087768828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888087768828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17411:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88801fb43928 (&mm->mmap_lock
#2
){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888022a24e28
 (&mm->mmap_lock/1
){+.+.}-{3:3}
, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
, at: dup_mmap kernel/fork.c:507 [inline]
, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140
 (
fs_reclaim
){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17412:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880170ad528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880170ad528 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880170ad528 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880411dea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880411dea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880411dea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17413:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880629d7128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880629d7128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880629d7128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a842f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a842f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a842f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17414:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888062a60828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888062a60828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888062a60828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a232f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a232f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a232f828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140
 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim
mm/page_alloc.c:4609 [inline]
 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17415:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880629d7828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880629d7828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880629d7828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a3ef9d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a3ef9d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a3ef9d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17416:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275bc728
 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88804378e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88804378e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88804378e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17417:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801baed528 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801baed528 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801baed528 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888045988128
 (
&mm->mmap_lock
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
4 locks held by syz-executor.0/17418:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801fb43228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801fb43228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801fb43228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880549e2b28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880549e2b28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880549e2b28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17419:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275be328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275be328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275be328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880468b0128
 (&mm->mmap_lock
/1
){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17420:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801cbb8128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801cbb8128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801cbb8128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b4818128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b4818128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b4818128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17421:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275bb228 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275bb228 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275bb228 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880aead6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880aead6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880aead6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17422:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275bc028 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275bc028 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275bc028 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88805a296a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88805a296a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88805a296a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17423:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem
){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880275b9628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880275b9628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880275b9628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a45ece28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a45ece28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a45ece28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17424:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801fb47828
 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888058cbea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888058cbea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888058cbea28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17426:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8880170a9628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880170a9628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8880170a9628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a1ab6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a1ab6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a1ab6328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17427:
 #0: ffffffff8bc53fd0
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88801cbbb228 (
&mm->mmap_lock
#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888097c86328
 (
&mm->mmap_lock
/1
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
4 locks held by syz-executor.0/17428:
 #0:
ffffffff8bc53fd0
 (
dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88801cbba428 (
&mm->mmap_lock#2){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888098654028
 (&mm->mmap_lock
/1
){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17429:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888062a63928 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888062a63928 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888062a63928 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b88df828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b88df828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b88df828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17430:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042621d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042621d28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042621d28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888027b31d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888027b31d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888027b31d28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (
fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_direct_reclaim
mm/page_alloc.c:4609 [inline]
fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17431:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801fb40128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801fb40128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801fb40128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a88c8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a88c8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a88c8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17433:
 #0:
ffffffff8bc53fd0
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042622b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042622b28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042622b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a7e57828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a7e57828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a7e57828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17434:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042620828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042620828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042620828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b19b8f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b19b8f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b19b8f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17435:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88806188ce28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88806188ce28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88806188ce28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880969e9628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880969e9628 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880969e9628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17436:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042626a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042626a28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042626a28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a126f128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a126f128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a126f128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17437:
 #0:
ffffffff8bc53fd0 (dup_mmap_sem
){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88801baea428
 (&mm->mmap_lock
#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b8597128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b8597128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b8597128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17438:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042623928 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042623928 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042623928 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888090a4c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888090a4c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888090a4c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17439:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8881235b4728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8881235b4728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8881235b4728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888092246a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888092246a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888092246a28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17440:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88806188f128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88806188f128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88806188f128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888095198f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888095198f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888095198f28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17441:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042620128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042620128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042620128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888092ba2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888092ba2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888092ba2428 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17443:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff8880587cc728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
ffff8880587cc728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
ffff8880587cc728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888092246328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888092246328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888092246328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17444:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042626328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042626328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042626328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a2d0c028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a2d0c028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a2d0c028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17445:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801baee328 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801baee328 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801baee328 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b17e9628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b17e9628 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b17e9628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17446:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801fb44028 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801fb44028 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801fb44028 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880877d8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880877d8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880877d8128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17447:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff8881235b7828
 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable
include/linux/mmap_lock.h:87 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:498 [inline]
 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a44cf828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a44cf828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a44cf828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17448:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025441628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025441628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025441628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88813159ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88813159ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88813159ab28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17450:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025440128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025440128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025440128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff88812229c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88812229c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff88812229c728 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17451:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888061888128 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888061888128 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888061888128 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880460d4e28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880460d4e28 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880460d4e28 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17452:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff8881235b0828 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8881235b0828 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff8881235b0828 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880bafc0828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880bafc0828 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880bafc0828 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17453:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025444728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025444728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025444728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b6f8e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b6f8e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b6f8e328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17454:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888042624e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888042624e28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888042624e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888035137128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888035137128 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888035137128 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140
 (
fs_reclaim){+.+.}-{0:0}
, at: __perform_reclaim mm/page_alloc.c:4585 [inline]
, at: __alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
, at: __alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17455:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff88801fb40f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff88801fb40f28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff88801fb40f28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a7e2c028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a7e2c028 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a7e2c028 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17456:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025441d28
 (
&mm->mmap_lock#2
){++++}-{3:3}
, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
, at: dup_mmap kernel/fork.c:498 [inline]
, at: dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b481b928
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested
include/linux/mmap_lock.h:78 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:507 [inline]
 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3:
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17459:
 #0:
ffffffff8bc53fd0
 (
dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:497 [inline]
dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025444e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025444e28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025444e28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff888097c83928 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff888097c83928 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff888097c83928 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17460:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}
, at: dup_mmap kernel/fork.c:497 [inline]
, at: dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1:
ffff88801fb44728 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
ffff88801fb44728 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
ffff88801fb44728 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880b2411628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880b2411628 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880b2411628 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17462:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888025442b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888025442b28 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888025442b28 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450
 #2: ffff8880a46ee328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff8880a46ee328 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap
kernel/fork.c:507 [inline]
 #2: ffff8880a46ee328 (&mm->mmap_lock/1){+.+.}-{3:3}, at:
dup_mm+0x18a/0x13d0 kernel/fork.c:1450
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4585 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4609 [inline]
 #3: ffffffff8bca5140 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath.constprop.0+0x760/0x21b0 mm/page_alloc.c:5007
4 locks held by syz-executor.0/17463:
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap
kernel/fork.c:497 [inline]
 #0: ffffffff8bc53fd0 (dup_mmap_sem){.+.+}-{0:0}, at:
dup_mm+0x108/0x13d0 kernel/fork.c:1450
 #1: ffff888062a61628 (&mm->mmap_lock#2){++++}-{3:3}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff888062a61628 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap
kernel/fork.c:498 [inline]
 #1: ffff888062a61628 (&mm->mmap_lock#2){++++}-{3:3}, at:
dup_mm+0x12e/0x13d0 kernel/fork.c:1450



Best Regards,
Yiru
