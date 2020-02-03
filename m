Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D72C150E99
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgBCR2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:28:51 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:39098 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgBCR2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 12:28:51 -0500
Received: by mail-io1-f72.google.com with SMTP id z26so9876170iog.6
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 09:28:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=i8un32MgIhK52ArzevaWM6LPBN+PFjSnMddDz4IYX3s=;
        b=cckb8ZPnCY2YOWm7OUksBse3WF3Ta7Z0A8jR2C3kUPHKwt89JYDHwoyqNAgz0e/UDO
         LW4aaI4EtP4ry9msN3E7aXYeVZaBTHuANWVgk9DEF4m7D+ao5xCshfak0hButfK3RnU/
         vaDdhG2qY0z/0JjY/C208sXiEddxCKHiKTGqsNbEAEdsp+IVCotwOzroDx54lcPKPi2+
         1gX6BJ7au94LQt8pCM89Lve0GPH3j/ZgCC/ZdddxjGEEighKlON6mvSX0et7iFCuChSA
         pi5CJhZybWfnyVlZTpOltKihTY3CmYkbtdTy/jEOHwjhdUaP85RD9d37r8Omz+4D8If2
         T9bQ==
X-Gm-Message-State: APjAAAVUZnSM+eLCfIEqU+AS7E4FHBEfe05JsBfHxqxsqKXgppRunFRj
        u0xNW8fbVXkcmO2rTJxznJEKC+WqgTRxliEqowFLnh9+uT1w
X-Google-Smtp-Source: APXvYqzOb1d6yRb3Ol//RAtGzq3y7n8sUw8l0aU/i/dMla/HQLLoQgYQFKVI4QQn57HRy1HB1ru0vcBGAyxz9LFHMQWqg88c5l85
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2815:: with SMTP id d21mr19111577ioe.217.1580750929074;
 Mon, 03 Feb 2020 09:28:49 -0800 (PST)
Date:   Mon, 03 Feb 2020 09:28:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b2012059daf41b8@google.com>
Subject: possible deadlock in rds_wake_sk_sleep (2)
From:   syzbot <syzbot+fafe7ab87492bb36ac5b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9f68e365 Merge tag 'drm-next-2020-01-30' of git://anongit...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17558df1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95b275782b150c86
dashboard link: https://syzkaller.appspot.com/bug?extid=fafe7ab87492bb36ac5b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fafe7ab87492bb36ac5b@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.5.0-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:4/231 is trying to acquire lock:
ffff8880a7e4de10 (&rs->rs_recv_lock){..--}, at: rds_wake_sk_sleep+0x24/0xe0 net/rds/af_rds.c:109

but task is already holding lock:
ffff888096fed900 (&(&rm->m_rs_lock)->rlock){..-.}, at: rds_send_remove_from_sock+0x352/0x9d0 net/rds/send.c:628

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&rm->m_rs_lock)->rlock){..-.}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
       rds_message_purge net/rds/message.c:138 [inline]
       rds_message_put net/rds/message.c:180 [inline]
       rds_message_put+0x1d9/0xda0 net/rds/message.c:173
       rds_loop_inc_free+0x16/0x20 net/rds/loop.c:115
       rds_inc_put+0x148/0x1b0 net/rds/recv.c:82
       rds_clear_recv_queue+0x157/0x380 net/rds/recv.c:770
       rds_release+0x117/0x430 net/rds/af_rds.c:73
       __sock_release+0xce/0x280 net/socket.c:605
       sock_close+0x1e/0x30 net/socket.c:1283
       __fput+0x2ff/0x890 fs/file_table.c:280
       ____fput+0x16/0x20 fs/file_table.c:313
       task_work_run+0x145/0x1c0 kernel/task_work.c:113
       tracehook_notify_resume include/linux/tracehook.h:188 [inline]
       exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
       prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
       syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
       do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&rs->rs_recv_lock){..--}:
       check_prev_add kernel/locking/lockdep.c:2475 [inline]
       check_prevs_add kernel/locking/lockdep.c:2580 [inline]
       validate_chain kernel/locking/lockdep.c:2970 [inline]
       __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
       lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
       __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:159 [inline]
       _raw_read_lock_irqsave+0x98/0xd0 kernel/locking/spinlock.c:231
       rds_wake_sk_sleep+0x24/0xe0 net/rds/af_rds.c:109
       rds_send_remove_from_sock+0xc0/0x9d0 net/rds/send.c:634
       rds_send_path_drop_acked+0x330/0x430 net/rds/send.c:710
       rds_tcp_write_space+0x1bb/0x6a1 net/rds/tcp_send.c:203
       tcp_new_space net/ipv4/tcp_input.c:5217 [inline]
       tcp_check_space+0x18f/0x760 net/ipv4/tcp_input.c:5228
       tcp_data_snd_check net/ipv4/tcp_input.c:5238 [inline]
       tcp_rcv_established+0x188b/0x1e90 net/ipv4/tcp_input.c:5646
       tcp_v4_do_rcv+0x619/0x8d0 net/ipv4/tcp_ipv4.c:1619
       tcp_v4_rcv+0x307f/0x3b40 net/ipv4/tcp_ipv4.c:2001
       ip_protocol_deliver_rcu+0x5a/0x880 net/ipv4/ip_input.c:204
       ip_local_deliver_finish+0x23b/0x380 net/ipv4/ip_input.c:231
       NF_HOOK include/linux/netfilter.h:307 [inline]
       NF_HOOK include/linux/netfilter.h:301 [inline]
       ip_local_deliver+0x1e9/0x520 net/ipv4/ip_input.c:252
       dst_input include/net/dst.h:442 [inline]
       ip_rcv_finish+0x1db/0x2f0 net/ipv4/ip_input.c:428
       NF_HOOK include/linux/netfilter.h:307 [inline]
       NF_HOOK include/linux/netfilter.h:301 [inline]
       ip_rcv+0xe8/0x3f0 net/ipv4/ip_input.c:538
       __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5198
       __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5312
       process_backlog+0x206/0x750 net/core/dev.c:6144
       napi_poll net/core/dev.c:6582 [inline]
       net_rx_action+0x508/0x1120 net/core/dev.c:6650
       __do_softirq+0x262/0x98c kernel/softirq.c:292
       do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
       do_softirq.part.0+0x11a/0x170 kernel/softirq.c:337
       do_softirq kernel/softirq.c:329 [inline]
       __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:189
       local_bh_enable include/linux/bottom_half.h:32 [inline]
       rcu_read_unlock_bh include/linux/rcupdate.h:690 [inline]
       ip_finish_output2+0x957/0x2610 net/ipv4/ip_output.c:229
       __ip_finish_output net/ipv4/ip_output.c:306 [inline]
       __ip_finish_output+0x604/0xc00 net/ipv4/ip_output.c:288
       ip_finish_output+0x38/0x1f0 net/ipv4/ip_output.c:316
       NF_HOOK_COND include/linux/netfilter.h:296 [inline]
       ip_output+0x22b/0x680 net/ipv4/ip_output.c:430
       dst_output include/net/dst.h:436 [inline]
       ip_local_out+0xbb/0x1b0 net/ipv4/ip_output.c:125
       __ip_queue_xmit+0x878/0x1c20 net/ipv4/ip_output.c:530
       ip_queue_xmit+0x5a/0x70 include/net/ip.h:237
       __tcp_transmit_skb+0x1ac9/0x3900 net/ipv4/tcp_output.c:1234
       __tcp_send_ack.part.0+0x3c6/0x5b0 net/ipv4/tcp_output.c:3771
       __tcp_send_ack net/ipv4/tcp_output.c:3777 [inline]
       tcp_send_ack net/ipv4/tcp_output.c:3777 [inline]
       tcp_send_delayed_ack+0x361/0x460 net/ipv4/tcp_output.c:3725
       __tcp_ack_snd_check+0x6b0/0x980 net/ipv4/tcp_input.c:5268
       tcp_rcv_established+0x1789/0x1e90 net/ipv4/tcp_input.c:5694
       tcp_v4_do_rcv+0x619/0x8d0 net/ipv4/tcp_ipv4.c:1619
       sk_backlog_rcv include/net/sock.h:938 [inline]
       __release_sock+0x129/0x390 net/core/sock.c:2437
       release_sock+0x59/0x1c0 net/core/sock.c:2953
       tcp_sendmsg+0x3b/0x50 net/ipv4/tcp.c:1434
       inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
       sock_sendmsg_nosec net/socket.c:652 [inline]
       sock_sendmsg+0xd7/0x130 net/socket.c:672
       kernel_sendmsg+0x44/0x50 net/socket.c:692
       rds_tcp_sendmsg+0xc7/0x100 net/rds/tcp_send.c:71
       rds_tcp_xmit+0x6e2/0xa40 net/rds/tcp_send.c:109
       rds_send_xmit+0x1354/0x2970 net/rds/send.c:367
       rds_send_worker+0x9c/0x2a0 net/rds/threads.c:200
       process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
       worker_thread+0x98/0xe40 kernel/workqueue.c:2410
       kthread+0x361/0x430 kernel/kthread.c:255
       ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&rm->m_rs_lock)->rlock);
                               lock(&rs->rs_recv_lock);
                               lock(&(&rm->m_rs_lock)->rlock);
  lock(&rs->rs_recv_lock);

 *** DEADLOCK ***

9 locks held by kworker/u4:4/231:
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff888099596928 ((wq_completion)krdsd){+.+.}, at: process_one_work+0x8dd/0x17a0 kernel/workqueue.c:2235
 #1: ffffc90001717dc0 ((work_completion)(&(&cp->cp_send_w)->work)){+.+.}, at: process_one_work+0x917/0x17a0 kernel/workqueue.c:2239
 #2: ffff8880873b0150 (k-sk_lock-AF_INET){+.+.}, at: lock_sock include/net/sock.h:1516 [inline]
 #2: ffff8880873b0150 (k-sk_lock-AF_INET){+.+.}, at: tcp_sendmsg+0x22/0x50 net/ipv4/tcp.c:1432
 #3: ffffffff89babf40 (rcu_read_lock){....}, at: sock_net include/net/sock.h:2459 [inline]
 #3: ffffffff89babf40 (rcu_read_lock){....}, at: __ip_queue_xmit+0x42/0x1c20 net/ipv4/ip_output.c:455
 #4: ffffffff89babf40 (rcu_read_lock){....}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #4: ffffffff89babf40 (rcu_read_lock){....}, at: __skb_unlink include/linux/skbuff.h:2034 [inline]
 #4: ffffffff89babf40 (rcu_read_lock){....}, at: __skb_dequeue include/linux/skbuff.h:2049 [inline]
 #4: ffffffff89babf40 (rcu_read_lock){....}, at: process_backlog+0x195/0x750 net/core/dev.c:6142
 #5: ffffffff89babf40 (rcu_read_lock){....}, at: __skb_pull include/linux/skbuff.h:2265 [inline]
 #5: ffffffff89babf40 (rcu_read_lock){....}, at: ip_local_deliver_finish+0x13a/0x380 net/ipv4/ip_input.c:228
 #6: ffff88805b9c4e60 (k-slock-AF_INET6/1){+.-.}, at: tcp_v4_rcv+0x2e1a/0x3b40 net/ipv4/tcp_ipv4.c:1995
 #7: ffff88805b9c5150 (clock-AF_INET6){++.-}, at: rds_tcp_write_space+0x28/0x6a1 net/rds/tcp_send.c:189
 #8: ffff888096fed900 (&(&rm->m_rs_lock)->rlock){..-.}, at: rds_send_remove_from_sock+0x352/0x9d0 net/rds/send.c:628

stack backtrace:
CPU: 1 PID: 231 Comm: kworker/u4:4 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: krdsd rds_send_worker
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
 check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
 check_prev_add kernel/locking/lockdep.c:2475 [inline]
 check_prevs_add kernel/locking/lockdep.c:2580 [inline]
 validate_chain kernel/locking/lockdep.c:2970 [inline]
 __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
 lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
 __raw_read_lock_irqsave include/linux/rwlock_api_smp.h:159 [inline]
 _raw_read_lock_irqsave+0x98/0xd0 kernel/locking/spinlock.c:231
 rds_wake_sk_sleep+0x24/0xe0 net/rds/af_rds.c:109
 rds_send_remove_from_sock+0xc0/0x9d0 net/rds/send.c:634
 rds_send_path_drop_acked+0x330/0x430 net/rds/send.c:710
 rds_tcp_write_space+0x1bb/0x6a1 net/rds/tcp_send.c:203
 tcp_new_space net/ipv4/tcp_input.c:5217 [inline]
 tcp_check_space+0x18f/0x760 net/ipv4/tcp_input.c:5228
 tcp_data_snd_check net/ipv4/tcp_input.c:5238 [inline]
 tcp_rcv_established+0x188b/0x1e90 net/ipv4/tcp_input.c:5646
 tcp_v4_do_rcv+0x619/0x8d0 net/ipv4/tcp_ipv4.c:1619
 tcp_v4_rcv+0x307f/0x3b40 net/ipv4/tcp_ipv4.c:2001
 ip_protocol_deliver_rcu+0x5a/0x880 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x23b/0x380 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x1e9/0x520 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x1db/0x2f0 net/ipv4/ip_input.c:428
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0xe8/0x3f0 net/ipv4/ip_input.c:538
 __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5198
 __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5312
 process_backlog+0x206/0x750 net/core/dev.c:6144
 napi_poll net/core/dev.c:6582 [inline]
 net_rx_action+0x508/0x1120 net/core/dev.c:6650
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 </IRQ>
 do_softirq.part.0+0x11a/0x170 kernel/softirq.c:337
 do_softirq kernel/softirq.c:329 [inline]
 __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:189
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:690 [inline]
 ip_finish_output2+0x957/0x2610 net/ipv4/ip_output.c:229
 __ip_finish_output net/ipv4/ip_output.c:306 [inline]
 __ip_finish_output+0x604/0xc00 net/ipv4/ip_output.c:288
 ip_finish_output+0x38/0x1f0 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0x22b/0x680 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0xbb/0x1b0 net/ipv4/ip_output.c:125
 __ip_queue_xmit+0x878/0x1c20 net/ipv4/ip_output.c:530
 ip_queue_xmit+0x5a/0x70 include/net/ip.h:237
 __tcp_transmit_skb+0x1ac9/0x3900 net/ipv4/tcp_output.c:1234
 __tcp_send_ack.part.0+0x3c6/0x5b0 net/ipv4/tcp_output.c:3771
 __tcp_send_ack net/ipv4/tcp_output.c:3777 [inline]
 tcp_send_ack net/ipv4/tcp_output.c:3777 [inline]
 tcp_send_delayed_ack+0x361/0x460 net/ipv4/tcp_output.c:3725
 __tcp_ack_snd_check+0x6b0/0x980 net/ipv4/tcp_input.c:5268
 tcp_rcv_established+0x1789/0x1e90 net/ipv4/tcp_input.c:5694
 tcp_v4_do_rcv+0x619/0x8d0 net/ipv4/tcp_ipv4.c:1619
 sk_backlog_rcv include/net/sock.h:938 [inline]
 __release_sock+0x129/0x390 net/core/sock.c:2437
 release_sock+0x59/0x1c0 net/core/sock.c:2953
 tcp_sendmsg+0x3b/0x50 net/ipv4/tcp.c:1434
 inet_sendmsg+0x9e/0xe0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 kernel_sendmsg+0x44/0x50 net/socket.c:692
 rds_tcp_sendmsg+0xc7/0x100 net/rds/tcp_send.c:71
 rds_tcp_xmit+0x6e2/0xa40 net/rds/tcp_send.c:109
 rds_send_xmit+0x1354/0x2970 net/rds/send.c:367
 rds_send_worker+0x9c/0x2a0 net/rds/threads.c:200
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
