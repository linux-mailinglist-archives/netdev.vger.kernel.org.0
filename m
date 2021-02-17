Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122A831DE33
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhBQRbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:31:19 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:33123 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhBQRbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:31:04 -0500
Received: by mail-il1-f198.google.com with SMTP id k5so10985110ilu.0
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:30:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ng4f56rdZrboj8s7V22fLP2ZtUe40ciRTAHqfc+10Pw=;
        b=klEOaLm2GOH9k5EWQCVSv1pVoA9Fp1aqdobxxqtXm8vD70rXtFAvefHOBFoLZ/e1zW
         eNgdk9qnSAdW8SbQnRND4X4z57XXtsxtDt9PLR+UGdHnxDKnr0T6u/N9pIT4RWCG0Eok
         4RDxQ1/B1yBFtOxbogvlv9FaoIn3xNxV/NUHr2y80X6Yu0czG9QYyARZw93Yh5XEZ3dg
         MUC87nT7FDZQWGWKI0tQXJQbMDxqx5iC2j1pls0Rd/TtVVTMc4RyMVGtv8IFhgMO9Lkt
         El48sweVoEeN3DvgrfzKpLN4von5zI3bgqHf8UGZY2wNjDJBqtaZY6AaNrIOMeGdQf3Q
         EFyw==
X-Gm-Message-State: AOAM532KTAVJyX/eGIB8x9K1Gxzo+vGllYJY7gAnzFd4Ge6vr8wC3qLp
        9Yh7N38mysUZUIrBPCWbbwFf3ljokIlWhMCklHbZZ+6Vl0fa
X-Google-Smtp-Source: ABdhPJwajKIm/Bpm7iHcZvMeAuQJj7PJl5lBC55CsYbEBU3UiNS2OgtFUs/pwpFJATqqmro0aba+HWRPLcWsCeqRBLgMCoBUHIqn
MIME-Version: 1.0
X-Received: by 2002:a6b:6519:: with SMTP id z25mr74557iob.147.1613583023008;
 Wed, 17 Feb 2021 09:30:23 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:30:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6f01f05bb8b9268@google.com>
Subject: possible deadlock in inet_stream_connect
From:   syzbot <syzbot+b0f5178b61ed7f3bbb46@syzkaller.appspotmail.com>
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

HEAD commit:    9ec5eea5 lib/parman: Delete newline
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11380d24d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=b0f5178b61ed7f3bbb46
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177a6d14d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10caeb02d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b0f5178b61ed7f3bbb46@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.11.0-rc7-syzkaller #0 Not tainted
--------------------------------------------
syz-executor845/10119 is trying to acquire lock:
ffff888021e6e320 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1598 [inline]
ffff888021e6e320 (sk_lock-AF_INET6){+.+.}-{0:0}, at: inet_stream_connect+0x3f/0xa0 net/ipv4/af_inet.c:724

but task is already holding lock:
ffff888022c1a520 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1598 [inline]
ffff888022c1a520 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp_stream_connect+0x85/0x800 net/mptcp/protocol.c:3171

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_INET6);
  lock(sk_lock-AF_INET6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz-executor845/10119:
 #0: ffff888022c1a520 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1598 [inline]
 #0: ffff888022c1a520 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp_stream_connect+0x85/0x800 net/mptcp/protocol.c:3171

stack backtrace:
CPU: 0 PID: 10119 Comm: syz-executor845 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2761 [inline]
 check_deadlock kernel/locking/lockdep.c:2804 [inline]
 validate_chain kernel/locking/lockdep.c:3595 [inline]
 __lock_acquire.cold+0x114/0x39e kernel/locking/lockdep.c:4832
 lock_acquire kernel/locking/lockdep.c:5442 [inline]
 lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5407
 lock_sock_nested+0xc5/0x110 net/core/sock.c:3071
 lock_sock include/net/sock.h:1598 [inline]
 inet_stream_connect+0x3f/0xa0 net/ipv4/af_inet.c:724
 mptcp_stream_connect+0x156/0x800 net/mptcp/protocol.c:3200
 __sys_connect_file+0x155/0x1a0 net/socket.c:1835
 __sys_connect+0x161/0x190 net/socket.c:1852
 __do_sys_connect net/socket.c:1862 [inline]
 __se_sys_connect net/socket.c:1859 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1859
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443ce9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff5f9324e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443ce9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000a800000000 R09: 000000a800000000
R10: 000000a800000000 R11: 0000000000000246 R12: 00007fff5f932500
R13: 00007fff5f932510 R14: 0000000000014e11 R15: 00007fff5f9324f0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
