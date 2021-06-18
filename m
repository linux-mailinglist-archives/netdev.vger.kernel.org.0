Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED63AD1F6
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhFRSTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:19:39 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:43936 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhFRSTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:19:34 -0400
Received: by mail-il1-f198.google.com with SMTP id w14-20020a92c88e0000b02901edfbb11919so6318017ilo.10
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=miL4vYc454/8TvcuBV9VOLxWlMT+rOmYqHNBKteuPv4=;
        b=lqqHeqEb80OuG6CY35ZBF+RiKrgVVgJmfJJUQm3p7zpsjNZrRco5o6fO/taAv556zo
         a2Ye8lKX3AykqO/mpwqlZCkQUt7xz11JRR+5XPfBdUOBhVmnTB1AOthMO0rGtrRsORnQ
         ViUpsLGSp2q96KV8JaUHWZvi9gdCeLfHILYI/N5otFLp4DHX7ax0zvi9/eYUxPI5EVY+
         HZ7cz32tPX/f0Nqv7NJV6mX9/dLWMFimbDfK9q8HjkD7jqV220jc5VDThsTvj9B296MW
         pi6o5uX5QGqhHMEuhT8YyKYxqthti37TA8tdIgPrpxfKlzqnXk5VBLQvF75eA0wRdqSu
         kinw==
X-Gm-Message-State: AOAM53230GXIXizV1pSA9oHwz4JNTmgLvqOYDUXWCQRdJkRCqtuq/jdC
        Vah0pLxe/Xm7mAM3oI3fO2LLdmblGWKPmO8VyRRiN27lb6YT
X-Google-Smtp-Source: ABdhPJwVpqDrxJpeZzN/aSMAxym9o34BDpK3cgNAYo8mhiRgcsrEkE4AcVmA095mU5A03VBgmB1PfpixLqWMN/7Kv4ATj9DgZDwX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8ee:: with SMTP id n14mr6995095ilt.205.1624040244781;
 Fri, 18 Jun 2021 11:17:24 -0700 (PDT)
Date:   Fri, 18 Jun 2021 11:17:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e4266905c50e5553@google.com>
Subject: [syzbot] inconsistent lock state in padata_do_serial
From:   syzbot <syzbot+5952f5d2983bea3ff2ba@syzkaller.appspotmail.com>
To:     daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f4cdcae0 Merge branch 'cxgb4-fixes'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14e3ef4fd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
dashboard link: https://syzkaller.appspot.com/bug?extid=5952f5d2983bea3ff2ba

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5952f5d2983bea3ff2ba@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.13.0-rc3-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
syz-executor.0/15349 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffffe8ffff939e90 (&pd_list->lock){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffffe8ffff939e90 (&pd_list->lock){+.?.}-{2:2}, at: padata_do_serial+0x192/0x410 kernel/padata.c:405
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5512 [inline]
  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  padata_do_serial+0x192/0x410 kernel/padata.c:405
  pcrypt_aead_enc+0x57/0x70 crypto/pcrypt.c:87
  padata_do_parallel+0x759/0x890 kernel/padata.c:230
  pcrypt_aead_encrypt+0x39f/0x4d0 crypto/pcrypt.c:115
  crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
  tls_do_encryption net/tls/tls_sw.c:529 [inline]
  tls_push_record+0x13d7/0x3230 net/tls/tls_sw.c:762
  bpf_exec_tx_verdict+0xd82/0x11a0 net/tls/tls_sw.c:802
  tls_sw_sendmsg+0xa41/0x1800 net/tls/tls_sw.c:1014
  inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:642
  sock_sendmsg_nosec net/socket.c:654 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:674
  __sys_sendto+0x21c/0x320 net/socket.c:1977
  __do_sys_sendto net/socket.c:1989 [inline]
  __se_sys_sendto net/socket.c:1985 [inline]
  __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1985
  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
  entry_SYSCALL_64_after_hwframe+0x44/0xae
irq event stamp: 20754
hardirqs last  enabled at (20754): [<ffffffff8145d500>] __local_bh_enable_ip+0xa0/0x120 kernel/softirq.c:389
hardirqs last disabled at (20753): [<ffffffff8145d523>] __local_bh_enable_ip+0xc3/0x120 kernel/softirq.c:366
softirqs last  enabled at (20356): [<ffffffff8145d336>] invoke_softirq kernel/softirq.c:433 [inline]
softirqs last  enabled at (20356): [<ffffffff8145d336>] __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
softirqs last disabled at (20733): [<ffffffff8145d336>] invoke_softirq kernel/softirq.c:433 [inline]
softirqs last disabled at (20733): [<ffffffff8145d336>] __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&pd_list->lock);
  <Interrupt>
    lock(&pd_list->lock);

 *** DEADLOCK ***

4 locks held by syz-executor.0/15349:
 #0: ffff88802938a460 (sb_writers#5){.+.+}-{0:0}, at: __do_sys_sendfile64 fs/read_write.c:1325 [inline]
 #0: ffff88802938a460 (sb_writers#5){.+.+}-{0:0}, at: __se_sys_sendfile64 fs/read_write.c:1311 [inline]
 #0: ffff88802938a460 (sb_writers#5){.+.+}-{0:0}, at: __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1311
 #1: ffff888079db0488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: inode_lock include/linux/fs.h:774 [inline]
 #1: ffff888079db0488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: ext4_dio_write_iter fs/ext4/file.c:510 [inline]
 #1: ffff888079db0488 (&sb->s_type->i_mutex_key#10){++++}-{3:3}, at: ext4_file_write_iter+0xaeb/0x14e0 fs/ext4/file.c:678
 #2: ffffc90000007d70 ((&d->timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:35 [inline]
 #2: ffffc90000007d70 ((&d->timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x6b0 kernel/time/timer.c:1421
 #3: ffffffff8bf79320 (rcu_read_lock){....}-{1:2}, at: buf_msg net/tipc/msg.h:201 [inline]
 #3: ffffffff8bf79320 (rcu_read_lock){....}-{1:2}, at: tipc_bearer_xmit_skb+0x8c/0x3f0 net/tipc/bearer.c:549

stack backtrace:
CPU: 0 PID: 15349 Comm: syz-executor.0 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_usage_bug kernel/locking/lockdep.c:203 [inline]
 valid_state kernel/locking/lockdep.c:3820 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4023 [inline]
 mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4480
 mark_usage kernel/locking/lockdep.c:4375 [inline]
 __lock_acquire+0x11aa/0x5230 kernel/locking/lockdep.c:4856
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5477
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 padata_do_serial+0x192/0x410 kernel/padata.c:405
 pcrypt_aead_enc+0x57/0x70 crypto/pcrypt.c:87
 padata_do_parallel+0x759/0x890 kernel/padata.c:230
 pcrypt_aead_encrypt+0x39f/0x4d0 crypto/pcrypt.c:115
 crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
 tipc_aead_encrypt net/tipc/crypto.c:828 [inline]
 tipc_crypto_xmit+0x10b4/0x2d40 net/tipc/crypto.c:1769
 tipc_bearer_xmit_skb+0x180/0x3f0 net/tipc/bearer.c:556
 tipc_disc_timeout+0x864/0xc80 net/tipc/discover.c:335
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
 __run_timers kernel/time/timer.c:1726 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 de 51 41 f8 48 89 ef e8 76 ca 41 f8 e8 d1 be 61 f8 fb bf 01 00 00 00 <e8> 56 c0 35 f8 65 8b 05 3f c2 e8 76 85 c0 74 02 5d c3 e8 fb 17 e7
RSP: 0018:ffffc9000121efc8 EFLAGS: 00000202
RAX: 00000000000050fb RBX: 0000000000000402 RCX: 1ffffffff204bf8a
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
RBP: ffff8880b9c35640 R08: 0000000000000001 R09: ffffffff90226937
R10: 0000000000000001 R11: 0000000000000001 R12: ffff8880b9c35640
R13: ffff88801c033880 R14: ffff888028956200 R15: ffff88801fb23880
 finish_lock_switch kernel/sched/core.c:4093 [inline]
 finish_task_switch.isra.0+0x15d/0x810 kernel/sched/core.c:4210
 context_switch kernel/sched/core.c:4342 [inline]
 __schedule+0x91e/0x23e0 kernel/sched/core.c:5147
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:5307
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
 _raw_spin_unlock_irqrestore+0x57/0x70 kernel/locking/spinlock.c:191
 spin_unlock_irqrestore include/linux/spinlock.h:409 [inline]
 prepare_to_wait+0x122/0x3f0 kernel/sched/wait.c:263
 __wait_on_bit+0xd1/0x190 kernel/sched/wait_bit.c:47
 out_of_line_wait_on_bit+0xd5/0x110 kernel/sched/wait_bit.c:64
 wait_on_bit_io include/linux/wait_bit.h:101 [inline]
 __wait_on_buffer fs/buffer.c:122 [inline]
 wait_on_buffer include/linux/buffer_head.h:356 [inline]
 __sync_dirty_buffer+0x2fb/0x3f0 fs/buffer.c:3177
 ext4_write_inode+0x574/0x630 fs/ext4/inode.c:5236
 write_inode fs/fs-writeback.c:1320 [inline]
 __writeback_single_inode+0xae9/0xfd0 fs/fs-writeback.c:1525
 writeback_single_inode+0x2a5/0x460 fs/fs-writeback.c:1580
 sync_inode fs/fs-writeback.c:2624 [inline]
 sync_inode_metadata+0x93/0xd0 fs/fs-writeback.c:2644
 ext4_fsync_nojournal fs/ext4/fsync.c:92 [inline]
 ext4_sync_file+0x9cc/0xfd0 fs/ext4/fsync.c:170
 vfs_fsync_range+0x13a/0x220 fs/sync.c:200
 generic_write_sync include/linux/fs.h:2982 [inline]
 iomap_dio_complete+0x5f9/0x780 fs/iomap/direct-io.c:127
 iomap_dio_rw+0x62/0x90 fs/iomap/direct-io.c:652
 ext4_dio_write_iter fs/ext4/file.c:568 [inline]
 ext4_file_write_iter+0xe18/0x14e0 fs/ext4/file.c:678
 call_write_iter include/linux/fs.h:2114 [inline]
 do_iter_readv_writev+0x46f/0x740 fs/read_write.c:740
 do_iter_write+0x188/0x670 fs/read_write.c:866
 vfs_iter_write+0x70/0xa0 fs/read_write.c:907
 iter_file_splice_write+0x723/0xc70 fs/splice.c:689
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0x9f0/0x1110 fs/read_write.c:1260
 __do_sys_sendfile64 fs/read_write.c:1325 [inline]
 __se_sys_sendfile64 fs/read_write.c:1311 [inline]
 __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1311
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7748bc2188 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000006
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 000800000000000c R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fff0dc53ccf R14: 00007f7748bc2300 R15: 0000000000022000
TCP: request_sock_TCPv6: Possible SYN flooding on port 20002. Sending cookies.  Check SNMP counters.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
