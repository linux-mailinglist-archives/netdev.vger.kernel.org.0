Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D746434D854
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhC2Tey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:34:54 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35670 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhC2TeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:34:23 -0400
Received: by mail-io1-f70.google.com with SMTP id v24so11669301ion.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OrPDaz0uXlDAGavWdBModoSbr4og33NB13Z6NEmvLrk=;
        b=XAtOSvDmN7IAOi4gGtAX0UBkdfwea5clTciw0js0x2kOJDWFecI/OFztA8fZMxD60o
         NiA+SBQNBrAx6Weqame9l3C4rpR/7BanUrzuDu0pnmx2dBb4kNhf62M6HBLXKfBTdbtC
         78gPopq2nBxXhJQ9TAGwdG+H0OHj1PdAzH3A7KNtFbBctp0dOIN5I76UX5SLoCXXS4mQ
         Vkdmo1VlkyY+Ytg7rmfuiBViHFRj/wa46SnT2bpWExKGpw62S0Cg7DfjLcrKMGDMwZAD
         Xy+tvnEaNKV/eSJOoPQNNx98iOCGEXEhCuM2OhX80NAs/cSM6VE9/AF5dn+wtOLGNWXP
         E+PQ==
X-Gm-Message-State: AOAM533RX9265DwmMLdXamD1/oHyErYDbaaVUwzzXFxjZ3F1Pic1LzY6
        tZiGi72lTL1jMJoOvNlPk7YdE6KuY38xpO4ilHMHfFuSdN8d
X-Google-Smtp-Source: ABdhPJz2YO830nGl4M6ePvLGaPzfj1rTapAn96ODgiHyJNjckK5R93z+domwZR0jK4zlRmMBByoYdUBVo5zAEZjMaqEKJvYy0zK3
MIME-Version: 1.0
X-Received: by 2002:a02:5184:: with SMTP id s126mr5484831jaa.107.1617046462357;
 Mon, 29 Mar 2021 12:34:22 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:34:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f964fd05beb1f7d3@google.com>
Subject: [syzbot] possible deadlock in ip_setsockopt
From:   syzbot <syzbot+81bff613876f26c198d8@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1b479fb8 drivers/net/wan/hdlc_fr: Fix a double free in pvc..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1072d3d6d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=81bff613876f26c198d8

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81bff613876f26c198d8@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.12.0-rc4-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/14381 is trying to acquire lock:
ffff888018aa2420 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1600 [inline]
ffff888018aa2420 (sk_lock-AF_INET){+.+.}-{0:0}, at: do_ip_setsockopt net/ipv4/ip_sockglue.c:945 [inline]
ffff888018aa2420 (sk_lock-AF_INET){+.+.}-{0:0}, at: ip_setsockopt+0x1d2/0x3a00 net/ipv4/ip_sockglue.c:1423

but task is already holding lock:
ffffffff8d66b1a8 (rtnl_mutex){+.+.}-{3:3}, at: do_ip_setsockopt net/ipv4/ip_sockglue.c:944 [inline]
ffffffff8d66b1a8 (rtnl_mutex){+.+.}-{3:3}, at: ip_setsockopt+0x1c8/0x3a00 net/ipv4/ip_sockglue.c:1423

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (rtnl_mutex){+.+.}-{3:3}:
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

-> #0 (sk_lock-AF_INET){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:2936 [inline]
       check_prevs_add kernel/locking/lockdep.c:3059 [inline]
       validate_chain kernel/locking/lockdep.c:3674 [inline]
       __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4900
       lock_acquire kernel/locking/lockdep.c:5510 [inline]
       lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
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

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rtnl_mutex);
                               lock(sk_lock-AF_INET);
                               lock(rtnl_mutex);
  lock(sk_lock-AF_INET);

 *** DEADLOCK ***

1 lock held by syz-executor.3/14381:
 #0: ffffffff8d66b1a8 (rtnl_mutex){+.+.}-{3:3}, at: do_ip_setsockopt net/ipv4/ip_sockglue.c:944 [inline]
 #0: ffffffff8d66b1a8 (rtnl_mutex){+.+.}-{3:3}, at: ip_setsockopt+0x1c8/0x3a00 net/ipv4/ip_sockglue.c:1423

stack backtrace:
CPU: 0 PID: 14381 Comm: syz-executor.3 Not tainted 5.12.0-rc4-syzkaller #0
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
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd7716d0188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000029 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000004bf9fb R08: 0000000000000010 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffec9848caf R14: 00007fd7716d0300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
