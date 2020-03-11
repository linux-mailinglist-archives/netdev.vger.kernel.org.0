Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462C4182115
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 19:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgCKSob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 14:44:31 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:48182 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730730AbgCKSob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 14:44:31 -0400
Received: by mail-pl1-f202.google.com with SMTP id w3so1730445plz.15
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 11:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=V5utLIEDzwq7LeSAtItzmD1JbNLw+JdXcL3i+r4+PIw=;
        b=kU90F5eAQz5fez5zWVccHoOVyWRnW4KOO3uLCP2ubjkPTUyL2PBnucXVpLyVEi0hCc
         q3Z2zIEUyTTUqFMsvoYYWMCkkKrC7bvpON6KLcIedhYnYTo9dMkFGryBjFxS1izqjxsV
         yA4ePJj3b58lDzmXQo9UUUcVeXJJ4+sPfve0Mb7ZvjnpXQprDdPoKlOZ/Mc+HRCghi79
         JfBsLJmU/YfWy7wxZPoxhNU/juL+FD8pbgZCKajS4rjstIBl2UTKAzSORjfcmqMnfOZK
         X8tDs9KiEUbGoBbH/ZOLmgjgAlZIgVLzR/xp18Y1u0s7wpu+2fyfW3PB37dqadSoeZ+h
         LMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=V5utLIEDzwq7LeSAtItzmD1JbNLw+JdXcL3i+r4+PIw=;
        b=t0viqPRf4xPzJ1UIT+Qt9U2MP3kgKrXfKxmPywh8jCBxKmiKWvw+n9iFs8DD/6cUGh
         si+XP4DZedrDAalQtVOAxPgT5Hlafn0hEfiBoRCyjaUq1LsICpeNt1I2AePPfv3qWcyH
         undQ9dD4H8rYyDDTWU2UAQ7e9pZHS2nbtJQFW+K5Ehg0Gpshn6T6kEXDlQFfGQV8H/TM
         imSo5JP+RS9pqIUrjiA6B+0rQzeKEzmZ+nTklDH4Lw6Kb5swiySLB/05eAQV7fCDzKjd
         c2xM7VhNHcQExxzSv/mKEhiGTU2fhLfgeUdw4RcC1FA/GRxSVcZIssOHTQy8fhWoKSKc
         U6oA==
X-Gm-Message-State: ANhLgQ1TIjUUnqwJYWuLMSC/dqACG1lzy1haHsDWoGHXN1OkLqtVroY4
        /K9vvJT3WyuYcxYaz4jvQZbpp46pkjiXXQ==
X-Google-Smtp-Source: ADFU+vu7mFtXHGnHrfHjHWq7ncN2EOE1bJAFRqyVmZvUuhZ2Q3h84j4bS177C8CIjeJoq8QbNuGSRJWa2x/5xg==
X-Received: by 2002:a17:90a:37ea:: with SMTP id v97mr155200pjb.26.1583952269664;
 Wed, 11 Mar 2020 11:44:29 -0700 (PDT)
Date:   Wed, 11 Mar 2020 11:44:26 -0700
Message-Id: <20200311184426.39253-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] net: memcg: fix lockdep splat in inet_csk_accept()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Locking newsk while still holding the listener lock triggered
a lockdep splat [1]

We can simply move the memcg code after we release the listener lock,
as this can also help if multiple threads are sharing a common listener.

Also fix a typo while reading socket sk_rmem_alloc.

[1]
WARNING: possible recursive locking detected
5.6.0-rc3-syzkaller #0 Not tainted
--------------------------------------------
syz-executor598/9524 is trying to acquire lock:
ffff88808b5b8b90 (sk_lock-AF_INET6){+.+.}, at: lock_sock include/net/sock.h:1541 [inline]
ffff88808b5b8b90 (sk_lock-AF_INET6){+.+.}, at: inet_csk_accept+0x69f/0xd30 net/ipv4/inet_connection_sock.c:492

but task is already holding lock:
ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: lock_sock include/net/sock.h:1541 [inline]
ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: inet_csk_accept+0x8d/0xd30 net/ipv4/inet_connection_sock.c:445

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_INET6);
  lock(sk_lock-AF_INET6);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz-executor598/9524:
 #0: ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: lock_sock include/net/sock.h:1541 [inline]
 #0: ffff88808b5b9590 (sk_lock-AF_INET6){+.+.}, at: inet_csk_accept+0x8d/0xd30 net/ipv4/inet_connection_sock.c:445

stack backtrace:
CPU: 0 PID: 9524 Comm: syz-executor598 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2370 [inline]
 check_deadlock kernel/locking/lockdep.c:2411 [inline]
 validate_chain kernel/locking/lockdep.c:2954 [inline]
 __lock_acquire.cold+0x114/0x288 kernel/locking/lockdep.c:3954
 lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4484
 lock_sock_nested+0xc5/0x110 net/core/sock.c:2947
 lock_sock include/net/sock.h:1541 [inline]
 inet_csk_accept+0x69f/0xd30 net/ipv4/inet_connection_sock.c:492
 inet_accept+0xe9/0x7c0 net/ipv4/af_inet.c:734
 __sys_accept4_file+0x3ac/0x5b0 net/socket.c:1758
 __sys_accept4+0x53/0x90 net/socket.c:1809
 __do_sys_accept4 net/socket.c:1821 [inline]
 __se_sys_accept4 net/socket.c:1818 [inline]
 __x64_sys_accept4+0x93/0xf0 net/socket.c:1818
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4445c9
Code: e8 0c 0d 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc35b37608 EFLAGS: 00000246 ORIG_RAX: 0000000000000120
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004445c9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000306777 R09: 0000000000306777
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004053d0 R14: 0000000000000000 R15: 0000000000000000

Fixes: d752a4986532 ("net: memcg: late association of sock to memcg")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/inet_connection_sock.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 65a3b2565102622e9c87fb4342dcb6f583c1c37e..d545fb99a8a1c84153c4a42226d15754c1f52ca0 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -483,27 +483,27 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
 
-	if (mem_cgroup_sockets_enabled) {
+out:
+	release_sock(sk);
+	if (newsk && mem_cgroup_sockets_enabled) {
 		int amt;
 
 		/* atomically get the memory usage, set and charge the
-		 * sk->sk_memcg.
+		 * newsk->sk_memcg.
 		 */
 		lock_sock(newsk);
 
-		/* The sk has not been accepted yet, no need to look at
-		 * sk->sk_wmem_queued.
+		/* The socket has not been accepted yet, no need to look at
+		 * newsk->sk_wmem_queued.
 		 */
 		amt = sk_mem_pages(newsk->sk_forward_alloc +
-				   atomic_read(&sk->sk_rmem_alloc));
+				   atomic_read(&newsk->sk_rmem_alloc));
 		mem_cgroup_sk_alloc(newsk);
 		if (newsk->sk_memcg && amt)
 			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
 
 		release_sock(newsk);
 	}
-out:
-	release_sock(sk);
 	if (req)
 		reqsk_put(req);
 	return newsk;
-- 
2.25.1.481.gfbce0eb801-goog

