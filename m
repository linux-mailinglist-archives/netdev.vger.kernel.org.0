Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E428A350396
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 17:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhCaPhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 11:37:25 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:52308 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhCaPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 11:37:23 -0400
Received: by mail-io1-f70.google.com with SMTP id d4so1785552iop.19
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 08:37:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=z8nPr3JJgPpDKpFIfZ1dGIHn+oOycU54gsgANu1iR7Y=;
        b=QjicHN+PqPmmo/1peIJOjwMA/4xxFkQYMJJExiXrTNs0ZRY5eKWxUyFG5nWtN4C7Jo
         vtnIlcNLhxe/Ft1xEqCPHq9IkweJ9nIj8cFv3M7eO1f5Knn78FK6LjEGrKtsVjTMDGZh
         H2G0ZOIa+fEjjp1Ewc7DuBh9K+aSeTT7+dgFd18YgbevBmdFz2d3n5WhC3ptt+G1EBc+
         q1qRIHQylcq+c5z+WaDtbCO8810GVOchsLVnxym619UyVPcl21AaTagqQkBiv0/mNOCr
         4hQSIpz56/YX5EQRpTgf9M7WDzb4l3hF1hi8Wlz/HF3v++tayKMTaAqinyRjIMB+WxAV
         RvsQ==
X-Gm-Message-State: AOAM530C1hGDOIBQM+HcPJGk1buKOwS3JHruupYBNTg0ia7p9Pgiy6zt
        cHJCzoHWq5OSuYszklH2pCl0ae1v55edPpMyAEg4KOj7Z6PU
X-Google-Smtp-Source: ABdhPJzpn3gNjL7+SCcEUqLRMWQRZSARdIaxLvqqjoq1bXcdI/fd+yjXZLzdGGXK/BOgbLa86Ch6CDdzFZqQkMJqg4RYPqMG2s7l
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2f0c:: with SMTP id q12mr2795111iow.82.1617205043423;
 Wed, 31 Mar 2021 08:37:23 -0700 (PDT)
Date:   Wed, 31 Mar 2021 08:37:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000246d0105bed6e42d@google.com>
Subject: [syzbot] possible deadlock in ipv6_sock_ac_close
From:   syzbot <syzbot+c18d9ae8897308206c1d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    37f368d8 lan743x: remove redundant intializations of point..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fe28ced00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=c18d9ae8897308206c1d

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c18d9ae8897308206c1d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.12.0-rc4-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/17484 is trying to acquire lock:
ffffffff8d66d328 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_ac_close+0xd5/0x110 net/ipv6/anycast.c:219

but task is already holding lock:
ffff88806c808120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
ffff88806c808120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3530

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (sk_lock-AF_INET6){+.+.}-{0:0}:
       lock_sock_nested+0xca/0x120 net/core/sock.c:3071
       lock_sock include/net/sock.h:1600 [inline]
       do_ipv6_setsockopt.constprop.0+0x31f/0x4220 net/ipv6/ipv6_sockglue.c:418
       ipv6_setsockopt+0xd6/0x180 net/ipv6/ipv6_sockglue.c:1003
       __sys_setsockopt+0x2db/0x610 net/socket.c:2117
       __do_sys_setsockopt net/socket.c:2128 [inline]
       __se_sys_setsockopt net/socket.c:2125 [inline]
       __x64_sys_setsockopt+0xba/0x150 net/socket.c:2125
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (rtnl_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:2936 [inline]
       check_prevs_add kernel/locking/lockdep.c:3059 [inline]
       validate_chain kernel/locking/lockdep.c:3674 [inline]
       __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4900
       lock_acquire kernel/locking/lockdep.c:5510 [inline]
       lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
       __mutex_lock_common kernel/locking/mutex.c:949 [inline]
       __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
       ipv6_sock_ac_close+0xd5/0x110 net/ipv6/anycast.c:219
       mptcp6_release+0xc1/0x130 net/mptcp/protocol.c:3539
       __sock_release+0xcd/0x280 net/socket.c:599
       sock_close+0x18/0x20 net/socket.c:1258
       __fput+0x288/0x920 fs/file_table.c:280
       task_work_run+0xdd/0x1a0 kernel/task_work.c:140
       tracehook_notify_resume include/linux/tracehook.h:189 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
       exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
       __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
       syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sk_lock-AF_INET6);
                               lock(rtnl_mutex);
                               lock(sk_lock-AF_INET6);
  lock(rtnl_mutex);

 *** DEADLOCK ***

2 locks held by syz-executor.3/17484:
 #0: ffff888062f3a6d0 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:775 [inline]
 #0: ffff888062f3a6d0 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:598
 #1: ffff88806c808120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
 #1: ffff88806c808120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/0x130 net/mptcp/protocol.c:3530

stack backtrace:
CPU: 0 PID: 17484 Comm: syz-executor.3 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2127
 check_prev_add kernel/locking/lockdep.c:2936 [inline]
 check_prevs_add kernel/locking/lockdep.c:3059 [inline]
 validate_chain kernel/locking/lockdep.c:3674 [inline]
 __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __mutex_lock_common kernel/locking/mutex.c:949 [inline]
 __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1096
 ipv6_sock_ac_close+0xd5/0x110 net/ipv6/anycast.c:219
 mptcp6_release+0xc1/0x130 net/mptcp/protocol.c:3539
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x41926b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007fffdbb1c900 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 000000000041926b
RDX: 0000000000000000 RSI: 000000000d1327a1 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000001b32727cec
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000056c9e0
R13: 000000000056c9e0 R14: 000000000056bf60 R15: 000000000005bd25


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
