Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DDD1EEED3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 02:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgFEAkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 20:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFEAkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 20:40:35 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F9B0206DC;
        Fri,  5 Jun 2020 00:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591317633;
        bh=x8/RqE03KqRQ3GIs1zh0qctkTOefu5NUXFjCRrf456o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XAzNe2//y7mxs93kqTE0ew4Ojfsd5iZoff4o1XFYph4+6ok1XYIAoSdSZSug3Hm6O
         IKUpEILJFNLOmaVrPdMQTKNlltWl/X3F5dp1du/SLWdpDXnqmjWAhNh6o3O5MKTeJ4
         AeVXVTP7QlZuIde40tbspyTaOXhKGDWo0IB30IXQ=
Date:   Thu, 4 Jun 2020 17:40:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+d769eed29cc42d75e2a3@syzkaller.appspotmail.com>
Cc:     linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: BUG: sleeping function called from invalid context in
 crypto_drop_spawn
Message-ID: <20200605004031.GB148196@sol.localdomain>
References: <00000000000060f19905a74b6825@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000060f19905a74b6825@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc linux-crypto.  crypto_free_shash() is being called in atomic context;
perhaps that should be allowed?  kfree() can be called in atomic context.

On Thu, Jun 04, 2020 at 05:33:19PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    39884604 mptcp: fix NULL ptr dereference in MP_JOIN error ..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1322a9ce100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=55b0bb710b7fdf44
> dashboard link: https://syzkaller.appspot.com/bug?extid=d769eed29cc42d75e2a3
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d769eed29cc42d75e2a3@syzkaller.appspotmail.com
> 
> BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1530
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 15295, name: syz-executor.1
> 6 locks held by syz-executor.1/15295:
>  #0: ffff88809740c430 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
>  #1: ffff888214f62450 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2908 [inline]
>  #1: ffff888214f62450 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x4cf/0x5d0 fs/read_write.c:558
>  #2: ffff88805241d488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: inode_lock include/linux/fs.h:797 [inline]
>  #2: ffff88805241d488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: ext4_buffered_write_iter+0xb3/0x450 fs/ext4/file.c:264
>  #3: ffff88805241d278 (&ei->i_data_sem){++++}-{3:3}, at: ext4_da_map_blocks fs/ext4/inode.c:1692 [inline]
>  #3: ffff88805241d278 (&ei->i_data_sem){++++}-{3:3}, at: ext4_da_get_block_prep+0xa0d/0x1120 fs/ext4/inode.c:1810
>  #4: ffff88805241d808 (&ei->i_es_lock){++++}-{2:2}, at: ext4_es_insert_delayed_block+0x12a/0x540 fs/ext4/extents_status.c:1982
>  #5: ffffc90000da8d60 ((&n->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:193 [inline]
>  #5: ffffc90000da8d60 ((&n->timer)){+.-.}-{0:0}, at: call_timer_fn+0xdb/0x780 kernel/time/timer.c:1394
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 PID: 15295 Comm: syz-executor.1 Not tainted 5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  ___might_sleep.cold+0x1f4/0x23d kernel/sched/core.c:6800
>  down_write+0x6e/0x150 kernel/locking/rwsem.c:1530
>  crypto_drop_spawn crypto/algapi.c:707 [inline]
>  crypto_drop_spawn+0x4b/0x2b0 crypto/algapi.c:702
>  shash_free_singlespawn_instance+0x15/0x20 crypto/shash.c:593
>  crypto_free_instance crypto/algapi.c:68 [inline]
>  crypto_destroy_instance+0x7a/0xc0 crypto/algapi.c:76
>  crypto_alg_put crypto/internal.h:94 [inline]
>  crypto_alg_put crypto/internal.h:91 [inline]
>  crypto_mod_put crypto/api.c:45 [inline]
>  crypto_destroy_tfm+0x198/0x310 crypto/api.c:566
>  crypto_free_shash include/crypto/hash.h:722 [inline]
>  sctp_destruct_sock+0x37/0x50 net/sctp/socket.c:5231
>  __sk_destruct+0x4b/0x7c0 net/core/sock.c:1783
>  sk_destruct+0xc6/0x100 net/core/sock.c:1827
>  __sk_free+0xef/0x3d0 net/core/sock.c:1838
>  sock_wfree+0x129/0x240 net/core/sock.c:2064
>  skb_release_head_state+0xe2/0x250 net/core/skbuff.c:651
>  skb_release_all+0x11/0x60 net/core/skbuff.c:662
>  __kfree_skb net/core/skbuff.c:678 [inline]
>  kfree_skb net/core/skbuff.c:696 [inline]
>  kfree_skb+0xfa/0x410 net/core/skbuff.c:690
>  neigh_invalidate+0x25c/0x5c0 net/core/neighbour.c:993
>  neigh_timer_handler+0xdbb/0x1180 net/core/neighbour.c:1080
>  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
>  expire_timers kernel/time/timer.c:1449 [inline]
>  __run_timers kernel/time/timer.c:1773 [inline]
>  __run_timers kernel/time/timer.c:1740 [inline]
>  run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1786
>  __do_softirq+0x26c/0x9f7 kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x192/0x1d0 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>  smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1140
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
> RIP: 0010:lock_acquire+0x267/0x8f0 kernel/locking/lockdep.c:4937
> Code: 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 c6 05 00 00 48 83 3d c5 2d 3b 08 00 0f 84 65 04 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 48 03 44 24 08 48 c7
> RSP: 0018:ffffc90004fa74c8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff132980c RBX: ffff8880868da440 RCX: 5e17927a8ce40e94
> RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000282
> RBP: 0000000000000000 R08: 0000000000000001 R09: fffffbfff1861546
> R10: ffffffff8c30aa2f R11: fffffbfff1861545 R12: 0000000000000000
> R13: ffff88805241d808 R14: 0000000000000000 R15: 0000000000000000
>  __raw_write_lock include/linux/rwlock_api_smp.h:210 [inline]
>  _raw_write_lock+0x2a/0x40 kernel/locking/spinlock.c:295
>  ext4_es_insert_delayed_block+0x12a/0x540 fs/ext4/extents_status.c:1982
>  ext4_insert_delayed_block fs/ext4/inode.c:1655 [inline]
>  ext4_da_map_blocks fs/ext4/inode.c:1746 [inline]
>  ext4_da_get_block_prep+0x6ea/0x1120 fs/ext4/inode.c:1810
>  ext4_block_write_begin+0x59a/0x1430 fs/ext4/inode.c:1053
>  ext4_da_write_begin+0x56e/0xbc0 fs/ext4/inode.c:2995
>  generic_perform_write+0x20a/0x4e0 mm/filemap.c:3302
>  ext4_buffered_write_iter+0x1f7/0x450 fs/ext4/file.c:270
>  ext4_file_write_iter+0x1ec/0x13f0 fs/ext4/file.c:642
>  call_write_iter include/linux/fs.h:1907 [inline]
>  new_sync_write+0x4a2/0x700 fs/read_write.c:484
>  __vfs_write+0xc9/0x100 fs/read_write.c:497
>  vfs_write+0x268/0x5d0 fs/read_write.c:559
>  ksys_write+0x12d/0x250 fs/read_write.c:612
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x45ca69
> Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ff2b9d83c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000050c980 RCX: 000000000045ca69
> RDX: 000000006db6e559 RSI: 0000000020000040 RDI: 0000000000000006
> RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000cec R14: 00000000004cf3d4 R15: 00007ff2b9d846d4
> 
> =============================
> [ BUG: Invalid wait context ]
> 5.7.0-rc6-syzkaller #0 Tainted: G        W        
> -----------------------------
> syz-executor.1/15295 is trying to lock:
> ffffffff89e64330 (crypto_alg_sem){++++}-{3:3}, at: crypto_drop_spawn crypto/algapi.c:707 [inline]
> ffffffff89e64330 (crypto_alg_sem){++++}-{3:3}, at: crypto_drop_spawn+0x4b/0x2b0 crypto/algapi.c:702
> other info that might help us debug this:
> context-{2:2}
> 6 locks held by syz-executor.1/15295:
>  #0: ffff88809740c430 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
>  #1: ffff888214f62450 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2908 [inline]
>  #1: ffff888214f62450 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x4cf/0x5d0 fs/read_write.c:558
>  #2: ffff88805241d488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: inode_lock include/linux/fs.h:797 [inline]
>  #2: ffff88805241d488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: ext4_buffered_write_iter+0xb3/0x450 fs/ext4/file.c:264
>  #3: ffff88805241d278 (&ei->i_data_sem){++++}-{3:3}, at: ext4_da_map_blocks fs/ext4/inode.c:1692 [inline]
>  #3: ffff88805241d278 (&ei->i_data_sem){++++}-{3:3}, at: ext4_da_get_block_prep+0xa0d/0x1120 fs/ext4/inode.c:1810
>  #4: ffff88805241d808 (&ei->i_es_lock){++++}-{2:2}, at: ext4_es_insert_delayed_block+0x12a/0x540 fs/ext4/extents_status.c:1982
>  #5: ffffc90000da8d60 ((&n->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:193 [inline]
>  #5: ffffc90000da8d60 ((&n->timer)){+.-.}-{0:0}, at: call_timer_fn+0xdb/0x780 kernel/time/timer.c:1394
> stack backtrace:
> CPU: 1 PID: 15295 Comm: syz-executor.1 Tainted: G        W         5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4007 [inline]
>  check_wait_context kernel/locking/lockdep.c:4068 [inline]
>  __lock_acquire.cold+0x273/0x3f8 kernel/locking/lockdep.c:4305
>  lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
>  down_write+0x8d/0x150 kernel/locking/rwsem.c:1531
>  crypto_drop_spawn crypto/algapi.c:707 [inline]
>  crypto_drop_spawn+0x4b/0x2b0 crypto/algapi.c:702
>  shash_free_singlespawn_instance+0x15/0x20 crypto/shash.c:593
>  crypto_free_instance crypto/algapi.c:68 [inline]
>  crypto_destroy_instance+0x7a/0xc0 crypto/algapi.c:76
>  crypto_alg_put crypto/internal.h:94 [inline]
>  crypto_alg_put crypto/internal.h:91 [inline]
>  crypto_mod_put crypto/api.c:45 [inline]
>  crypto_destroy_tfm+0x198/0x310 crypto/api.c:566
>  crypto_free_shash include/crypto/hash.h:722 [inline]
>  sctp_destruct_sock+0x37/0x50 net/sctp/socket.c:5231
>  __sk_destruct+0x4b/0x7c0 net/core/sock.c:1783
>  sk_destruct+0xc6/0x100 net/core/sock.c:1827
>  __sk_free+0xef/0x3d0 net/core/sock.c:1838
>  sock_wfree+0x129/0x240 net/core/sock.c:2064
>  skb_release_head_state+0xe2/0x250 net/core/skbuff.c:651
>  skb_release_all+0x11/0x60 net/core/skbuff.c:662
>  __kfree_skb net/core/skbuff.c:678 [inline]
>  kfree_skb net/core/skbuff.c:696 [inline]
>  kfree_skb+0xfa/0x410 net/core/skbuff.c:690
>  neigh_invalidate+0x25c/0x5c0 net/core/neighbour.c:993
>  neigh_timer_handler+0xdbb/0x1180 net/core/neighbour.c:1080
>  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
>  expire_timers kernel/time/timer.c:1449 [inline]
>  __run_timers kernel/time/timer.c:1773 [inline]
>  __run_timers kernel/time/timer.c:1740 [inline]
>  run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1786
>  __do_softirq+0x26c/0x9f7 kernel/softirq.c:292
>  invoke_softirq kernel/softirq.c:373 [inline]
>  irq_exit+0x192/0x1d0 kernel/softirq.c:413
>  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>  smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1140
>  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>  </IRQ>
> RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
> RIP: 0010:lock_acquire+0x267/0x8f0 kernel/locking/lockdep.c:4937
> Code: 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 c6 05 00 00 48 83 3d c5 2d 3b 08 00 0f 84 65 04 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 48 03 44 24 08 48 c7
> RSP: 0018:ffffc90004fa74c8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
> RAX: 1ffffffff132980c RBX: ffff8880868da440 RCX: 5e17927a8ce40e94
> RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000282
> RBP: 0000000000000000 R08: 0000000000000001 R09: fffffbfff1861546
> R10: ffffffff8c30aa2f R11: fffffbfff1861545 R12: 0000000000000000
> R13: ffff88805241d808 R14: 0000000000000000 R15: 0000000000000000
>  __raw_write_lock include/linux/rwlock_api_smp.h:210 [inline]
>  _raw_write_lock+0x2a/0x40 kernel/locking/spinlock.c:295
>  ext4_es_insert_delayed_block+0x12a/0x540 fs/ext4/extents_status.c:1982
>  ext4_insert_delayed_block fs/ext4/inode.c:1655 [inline]
>  ext4_da_map_blocks fs/ext4/inode.c:1746 [inline]
>  ext4_da_get_block_prep+0x6ea/0x1120 fs/ext4/inode.c:1810
>  ext4_block_write_begin+0x59a/0x1430 fs/ext4/inode.c:1053
>  ext4_da_write_begin+0x56e/0xbc0 fs/ext4/inode.c:2995
>  generic_perform_write+0x20a/0x4e0 mm/filemap.c:3302
>  ext4_buffered_write_iter+0x1f7/0x450 fs/ext4/file.c:270
>  ext4_file_write_iter+0x1ec/0x13f0 fs/ext4/file.c:642
>  call_write_iter include/linux/fs.h:1907 [inline]
>  new_sync_write+0x4a2/0x700 fs/read_write.c:484
>  __vfs_write+0xc9/0x100 fs/read_write.c:497
>  vfs_write+0x268/0x5d0 fs/read_write.c:559
>  ksys_write+0x12d/0x250 fs/read_write.c:612
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x45ca69
> Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ff2b9d83c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000050c980 RCX: 000000000045ca69
> RDX: 000000006db6e559 RSI: 0000000020000040 RDI: 0000000000000006
> RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000cec R14: 00000000004cf3d4 R15: 00007ff2b9d846d4
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000060f19905a74b6825%40google.com.
