Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B634E2F1
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 10:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhC3IPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 04:15:41 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48292 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhC3IPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 04:15:18 -0400
Received: by mail-io1-f70.google.com with SMTP id g12so2271921ion.15
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 01:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zYXf/slRk7VawuClIizAYDwXZvagn572A8aIc7ReDl4=;
        b=CPhzEfm+DUpHIU80oh+G39Iiw4nzV42IxRQRs1Gme8TpSn9Ji05P7ed4TUgobmWynr
         25S/Esawg6WNiCr4QH5F6QkO+xD4CZbbdfihEH8m5A0dT7Lcs+Tww5lCVQbu/YhZqZa3
         g/1FG0sKNHqSojv0fbPR+B7hGQEX6NGnehpYkffadU+KDkdEWLZaqDfDdOoj/TJn9r66
         gfg+EVKy+CJpmQeY1EoUcYipYlYGb5VplM8eiglHR+n5+oJvha1/wodvDOF9log7CCnw
         5sPUtdpPD4XHQHnYH06KVMVHaVV9ywwd08YJ+xTznRF3uvOqBqSxS6RgJXeVP15Z9rnu
         c4kg==
X-Gm-Message-State: AOAM532L4U4t/m47Mx2NXpa8cwF/87KIFbXdQeN1O/mGGbKo83RJZHva
        mpqC0AocVGQp4IELApmwKbrgn+OHpTapf+VrAfhYZAZOuaAz
X-Google-Smtp-Source: ABdhPJwKJk0QKq5P4gjbg6O26k6KLl6vZZ+uQRlwsxirGFxfu7T2rZ5tmW0ogaRjzVH4A8+WcLGN1ORfqi4nybJIw7rDuYLZ6Q/8
MIME-Version: 1.0
X-Received: by 2002:a02:9042:: with SMTP id y2mr28513880jaf.94.1617092117553;
 Tue, 30 Mar 2021 01:15:17 -0700 (PDT)
Date:   Tue, 30 Mar 2021 01:15:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c668005bebc9969@google.com>
Subject: [syzbot] possible deadlock in ip_mc_drop_socket
From:   syzbot <syzbot+35ace9909754e04618b9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fb6ec87f net: dsa: Fix type was not set for devlink port
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12dd978ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=35ace9909754e04618b9

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+35ace9909754e04618b9@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.12.0-rc4-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.4/31420 is trying to acquire lock:
ffffffff8d66b1a8 (rtnl_mutex){+.+.}-{3:3}, at: ip_mc_drop_socket+0x89/0x260 net/ipv4/igmp.c:2671

but task is already holding lock:
ffff888059d6c4a0 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
ffff888059d6c4a0 (sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_release+0x55/0x120 net/mptcp/protocol.c:3431

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (sk_lock-AF_INET){+.+.}-{0:0}:
       lock_sock_nested+0xca/0x120 net/core/sock.c:3071
       lock_sock include/net/sock.h:1600 [inline]
       do_ip_setsockopt net/ipv4/ip_sockglue.c:945 [inline]
       ip_setsockopt+0x1d2/0x3a00 net/ipv4/ip_sockglue.c:1423
       udp_setsockopt+0x76/0xc0 net/ipv4/udp.c:2719
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
       ip_mc_drop_socket+0x89/0x260 net/ipv4/igmp.c:2671
       mptcp_release+0xab/0x120 net/mptcp/protocol.c:3438
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
  lock(sk_lock-AF_INET);
                               lock(rtnl_mutex);
                               lock(sk_lock-AF_INET);
  lock(rtnl_mutex);

 *** DEADLOCK ***

2 locks held by syz-executor.4/31420:
 #0: ffff88802ee8e190 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:775 [inline]
 #0: ffff88802ee8e190 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:598
 #1: ffff888059d6c4a0 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
 #1: ffff888059d6c4a0 (sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_release+0x55/0x120 net/mptcp/protocol.c:3431

stack backtrace:
CPU: 0 PID: 31420 Comm: syz-executor.4 Not tainted 5.12.0-rc4-syzkaller #0
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
 ip_mc_drop_socket+0x89/0x260 net/ipv4/igmp.c:2671
 mptcp_release+0xab/0x120 net/mptcp/protocol.c:3438
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
RSP: 002b:00007ffc0696dff0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 000000000041926b
RDX: 0000000000570b58 RSI: 000000000d1147dc RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000001b31a25db8
R10: 00007ffc0696e0e0 R11: 0000000000000293 R12: 0000000000094f5f
R13: 00000000000003e8 R14: 000000000056bf60 R15: 0000000000094f24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
