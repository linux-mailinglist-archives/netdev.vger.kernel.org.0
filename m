Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9246151512
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 05:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBDEoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 23:44:12 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39989 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgBDEoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 23:44:12 -0500
Received: by mail-il1-f200.google.com with SMTP id m18so13911528ill.7
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 20:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jRe8qrWGxPKQWY41/zu2j+Y/gBhuuZ/+yT0Q+9l46Ak=;
        b=JA1BvnIT5ORaEZIrBSY4l1AiXNoy0ycYkgwoM+K7I7veMB5SIL4PQG28J6yUd16hQJ
         g7nFbjhsqjOhHxhIVerqXRvyA28Fhri0sOyql8bmzZokQkMJEkbAe1JXVwEM2G7ljeng
         izq0g3FoscXaD8ZbjiYPqJVDgRg+yOcWo/hcVe0XB08MVnodyEwVwINg0cNtyFNCRy9q
         kClOimxYtRMr3h2HX8binlmzkOivbrA0NF6zFrnxvhgBw4iblBGDSnuMQer4/Wd4F89P
         H7uKlT4fRawvfgl09e1wQo6XYodzPddB+eV36zUU7iPZeCbzlYiFsUq4uw+CwqVZCQ2B
         lr1Q==
X-Gm-Message-State: APjAAAUZXXmrbGrNgKcrpt20z8Q760DKf6oaFhqZdWBTDCBFf9JAKdkm
        QMbP4eztdf0Zrlji1T4yYvjvpy/4r/Me4+hyYDRnNih73kDk
X-Google-Smtp-Source: APXvYqw8/Qj6d9DgZUV/SQanv0mSz+xrmjlyEfawNPpO4Cjy5AN/5l6u9Ggix/hrdw5FzxEloH1Lh8ZALC0cu0D/8K/0lQXHQecn
MIME-Version: 1.0
X-Received: by 2002:a92:1a12:: with SMTP id a18mr24842227ila.10.1580791451661;
 Mon, 03 Feb 2020 20:44:11 -0800 (PST)
Date:   Mon, 03 Feb 2020 20:44:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0baeb059db8b055@google.com>
Subject: inconsistent lock state in rxrpc_put_client_connection_id
From:   syzbot <syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3d80c653 Merge tag 'rxrpc-fixes-20200203' of git://git.ker..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=165dbda5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b275782b150c86
dashboard link: https://syzkaller.appspot.com/bug?extid=d82f3ac8d87e7ccbb2c9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.5.0-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
syz-executor.3/9477 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffffffff8a8b6e38 (rxrpc_conn_id_lock){+.?.}, at: spin_lock include/linux/spinlock.h:338 [inline]
ffffffff8a8b6e38 (rxrpc_conn_id_lock){+.?.}, at: rxrpc_put_client_connection_id net/rxrpc/conn_client.c:138 [inline]
ffffffff8a8b6e38 (rxrpc_conn_id_lock){+.?.}, at: rxrpc_put_client_connection_id+0x73/0xe0 net/rxrpc/conn_client.c:135
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  rxrpc_get_client_connection_id net/rxrpc/conn_client.c:109 [inline]
  rxrpc_alloc_client_connection net/rxrpc/conn_client.c:193 [inline]
  rxrpc_get_client_conn net/rxrpc/conn_client.c:340 [inline]
  rxrpc_connect_call+0x954/0x4e30 net/rxrpc/conn_client.c:701
  rxrpc_new_client_call+0x9c0/0x1ad0 net/rxrpc/call_object.c:290
  rxrpc_new_client_call_for_sendmsg net/rxrpc/sendmsg.c:595 [inline]
  rxrpc_do_sendmsg+0xffa/0x1d5f net/rxrpc/sendmsg.c:652
  rxrpc_sendmsg+0x4d6/0x5f0 net/rxrpc/af_rxrpc.c:586
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:672
  ____sys_sendmsg+0x358/0x880 net/socket.c:2343
  ___sys_sendmsg+0x100/0x170 net/socket.c:2397
  __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2487
  __do_sys_sendmmsg net/socket.c:2516 [inline]
  __se_sys_sendmmsg net/socket.c:2513 [inline]
  __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2513
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
irq event stamp: 13994944
hardirqs last  enabled at (13994944): [<ffffffff87e8d446>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (13994944): [<ffffffff87e8d446>] _raw_spin_unlock_irqrestore+0x66/0xe0 kernel/locking/spinlock.c:191
hardirqs last disabled at (13994943): [<ffffffff87e8d7bf>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (13994943): [<ffffffff87e8d7bf>] _raw_spin_lock_irqsave+0x6f/0xcd kernel/locking/spinlock.c:159
softirqs last  enabled at (13994502): [<ffffffff882006cd>] __do_softirq+0x6cd/0x98c kernel/softirq.c:319
softirqs last disabled at (13994915): [<ffffffff81477d5b>] invoke_softirq kernel/softirq.c:373 [inline]
softirqs last disabled at (13994915): [<ffffffff81477d5b>] irq_exit+0x19b/0x1e0 kernel/softirq.c:413

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rxrpc_conn_id_lock);
  <Interrupt>
    lock(rxrpc_conn_id_lock);

 *** DEADLOCK ***

3 locks held by syz-executor.3/9477:
 #0: ffff888098c32428 (sb_writers#3){.+.+}, at: sb_start_write include/linux/fs.h:1650 [inline]
 #0: ffff888098c32428 (sb_writers#3){.+.+}, at: mnt_want_write+0x3f/0xc0 fs/namespace.c:354
 #1: ffff8880aa0605c8 (&type->i_mutex_dir_key#3/1){+.+.}, at: inode_lock_nested include/linux/fs.h:826 [inline]
 #1: ffff8880aa0605c8 (&type->i_mutex_dir_key#3/1){+.+.}, at: filename_create+0x17c/0x4f0 fs/namei.c:3708
 #2: ffffffff89babe80 (rcu_callback){....}, at: rcu_do_batch kernel/rcu/tree.c:2176 [inline]
 #2: ffffffff89babe80 (rcu_callback){....}, at: rcu_core+0x562/0x1390 kernel/rcu/tree.c:2410

stack backtrace:
CPU: 0 PID: 9477 Comm: syz-executor.3 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_usage_bug.cold+0x327/0x378 kernel/locking/lockdep.c:3100
 valid_state kernel/locking/lockdep.c:3111 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3308 [inline]
 mark_lock+0xbb4/0x1220 kernel/locking/lockdep.c:3665
 mark_usage kernel/locking/lockdep.c:3565 [inline]
 __lock_acquire+0x1e8e/0x4a00 kernel/locking/lockdep.c:3908
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:338 [inline]
 rxrpc_put_client_connection_id net/rxrpc/conn_client.c:138 [inline]
 rxrpc_put_client_connection_id+0x73/0xe0 net/rxrpc/conn_client.c:135
 rxrpc_put_one_client_conn net/rxrpc/conn_client.c:955 [inline]
 rxrpc_put_client_conn+0x243/0xc90 net/rxrpc/conn_client.c:1001
 rxrpc_put_connection net/rxrpc/ar-internal.h:965 [inline]
 rxrpc_rcu_destroy_call+0xbd/0x200 net/rxrpc/call_object.c:572
 rcu_do_batch kernel/rcu/tree.c:2186 [inline]
 rcu_core+0x5e1/0x1390 kernel/rcu/tree.c:2410
 rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2419
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:find_get_entry+0x4a6/0x7a0 mm/filemap.c:1526
Code: 84 db 0f 84 20 02 00 00 e8 d7 c7 e1 ff e8 02 01 cf ff e8 cd c7 e1 ff 48 c7 c6 74 ae 93 81 48 c7 c7 40 bf ba 89 e8 da 5f c7 ff <48> b8 00 00 00 00 00 fc ff df 48 03 85 20 ff ff ff 48 c7 00 00 00
RSP: 0018:ffffc900020b78c8 EFLAGS: 00000296 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 1ffff1100cf70539
RDX: dffffc0000000000 RSI: 1ffff1100cf70545 RDI: 0000000000000286
RBP: ffffc900020b79b0 R08: 0000000000000003 R09: ffff888067b829d0
R10: fffffbfff1547c10 R11: ffffffff8aa3e087 R12: ffffea00017f46c0
R13: ffffea00017f46c0 R14: ffffc900020b7988 R15: 0000000000000000
 pagecache_get_page+0x4c/0x9e0 mm/filemap.c:1635
 find_get_page_flags include/linux/pagemap.h:266 [inline]
 __find_get_block_slow fs/buffer.c:210 [inline]
 __find_get_block fs/buffer.c:1336 [inline]
 __find_get_block+0x531/0xea0 fs/buffer.c:1330
 sb_find_get_block include/linux/buffer_head.h:338 [inline]
 recently_deleted fs/ext4/ialloc.c:677 [inline]
 find_inode_bit.isra.0+0x202/0x520 fs/ext4/ialloc.c:717
 __ext4_new_inode+0x16eb/0x4fa0 fs/ext4/ialloc.c:909
 ext4_mkdir+0x3d5/0xe20 fs/ext4/namei.c:2776
 vfs_mkdir+0x42e/0x670 fs/namei.c:3889
 do_mkdirat+0x234/0x2a0 fs/namei.c:3912
 __do_sys_mkdir fs/namei.c:3928 [inline]
 __se_sys_mkdir fs/namei.c:3926 [inline]
 __x64_sys_mkdir+0x5c/0x80 fs/namei.c:3926
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a7b7
Code: 1f 40 00 b8 5a 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 7d c2 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 5d c2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff189fccb8 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 0000000000114fb1 RCX: 000000000045a7b7
RDX: 00007fff189fcd06 RSI: 00000000000001ff RDI: 00007fff189fcd00
RBP: 0000000000001369 R08: 0000000000000000 R09: 0000000000000006
R10: 0000000000000064 R11: 0000000000000206 R12: 0000000000000006
R13: 00007fff189fccf0 R14: 0000000000114f37 R15: 00007fff189fcd00


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
