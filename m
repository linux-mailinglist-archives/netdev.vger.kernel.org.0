Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76690737AC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfGXTSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:18:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37801 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbfGXTSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:18:08 -0400
Received: by mail-io1-f69.google.com with SMTP id v3so52127526ios.4
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 12:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lEMu0m22wDaJRk+5rv2rzVQSS4vLiX5zmKGJxpdYVqg=;
        b=ABLcisQBaLq/p0UKU5sYvZrYIM0nGAmixLkN1oO8FSOhX0z4EUYDmJBRqsMaaTM34O
         CXvGwY8mamJMtZFbg3DZe2f+xGu6SlubyGsRUCUQROVzftTB3ZL9+KhVHuGn8heZii8x
         uziiYN6Y5kmiZWP78Kh/hSdyeSi+eBZjn/mCKk2ncFJPhvd3b3sdf7FBTv93sUdOA9sV
         uspsyRG4SI8WK7asn+U6HmixmghcldUOjzzgjyXlBHu+5e9mIHrcmumnPhFXm8IAryNZ
         cpiSZwM0txsZdkLfujSWlF0UCb6eln2kVGoCgIhU8Yty+rgIsqCMTi3QoM3bDGbUiqTo
         KZLw==
X-Gm-Message-State: APjAAAXWzTTnYgyNCUGa1z1YrMPY7EI2J7YILwoM80m8a2QMwlLvXHTx
        3y0TrNWTNJrNmzZumnzna2nRR9guD2OxQxS4O0G/WxS8diNZ
X-Google-Smtp-Source: APXvYqwG2P3HT9WZ8m28jVM4+fieLe0Zr6/Bvp8CSOYWAOYsfrq2fAuYKR+wgZ8hjLzmMs+aq4jtu33k8Ge71UKd3o4u26XdVyCZ
MIME-Version: 1.0
X-Received: by 2002:a5e:9515:: with SMTP id r21mr44673640ioj.257.1563995886993;
 Wed, 24 Jul 2019 12:18:06 -0700 (PDT)
Date:   Wed, 24 Jul 2019 12:18:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000464b54058e722b54@google.com>
Subject: BUG: spinlock recursion in release_sock
From:   syzbot <syzbot+e67cf584b5e6b35a8ffa@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9e6dfe80 Add linux-next specific files for 20190724
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11c1271fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
dashboard link: https://syzkaller.appspot.com/bug?extid=e67cf584b5e6b35a8ffa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13680594600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b34144600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e67cf584b5e6b35a8ffa@syzkaller.appspotmail.com

BUG: spinlock recursion on CPU#0, syz-executor596/9231
  lock: 0xffff8880a16c2d08, .magic: dead4ead, .owner:  
syz-executor596/9231, .owner_cpu: 0
CPU: 0 PID: 9231 Comm: syz-executor596 Not tainted 5.3.0-rc1-next-20190724  
#50
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  spin_dump.cold+0x81/0xe6 kernel/locking/spinlock_debug.c:67
  spin_bug kernel/locking/spinlock_debug.c:75 [inline]
  debug_spin_lock_before kernel/locking/spinlock_debug.c:84 [inline]
  do_raw_spin_lock+0x252/0x2e0 kernel/locking/spinlock_debug.c:112
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  release_sock+0x20/0x1c0 net/core/sock.c:2932
  wait_on_pending_writer+0x20f/0x420 net/tls/tls_main.c:91
  tls_sk_proto_cleanup+0x2c5/0x3e0 net/tls/tls_main.c:295
  tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
  tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
  tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
  tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
  tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
  tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
  tcp_v6_rcv+0x31f1/0x3500 net/ipv6/tcp_ipv6.c:1588
  ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
  dst_input include/net/dst.h:442 [inline]
  ip6_rcv_finish+0x1de/0x2f0 net/ipv6/ip6_input.c:76
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:4999
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5113
  process_backlog+0x206/0x750 net/core/dev.c:5924
  napi_poll net/core/dev.c:6347 [inline]
  net_rx_action+0x508/0x10c0 net/core/dev.c:6413
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1080
  </IRQ>
  do_softirq.part.0+0x11a/0x170 kernel/softirq.c:337
  do_softirq kernel/softirq.c:329 [inline]
  __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:189
  local_bh_enable include/linux/bottom_half.h:32 [inline]
  inet_csk_listen_stop+0x1e0/0x850 net/ipv4/inet_connection_sock.c:993
  tcp_close+0xd5b/0x10e0 net/ipv4/tcp.c:2338
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x406581
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 24 1a 00 00 c3 48  
83 ec 08 e8 6a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 b3 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffd1ccb84a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000406581
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00000000006dcc20 R08: 0000000000000140 R09: 0000000000000140
R10: 00007ffd1ccb84d0 R11: 0000000000000293 R12: 00007ffd1ccb8500
R13: 00000000006dcc2c R14: 000000000000002d R15: 0000000000000007


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
