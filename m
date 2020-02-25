Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2516EF6D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbgBYTwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:52:34 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:40840 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYTwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:52:33 -0500
Received: by mail-pg1-f202.google.com with SMTP id n7so152177pgt.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Be5wzaV9lZY1RDlj19VIREDro27DD4bWnj4QqlmMvmg=;
        b=ixvjUbm6lpaIX/m6A+LdlpSPHvyG6u4N3VflxHk2qCJwjhV5f6HgjEhQG0MK9qgizQ
         SUWYcJ6UrB9j2duCIBAzE5rHEz7Z3sWXCBdKR4gqDm3TDIwmdM/h9hCUdiFD0Bt6oRCH
         sk3YEa1+deLxeyx8CP0/3xkNUtlNQifK7W9uKhocZc3OcwS68fv7E7eUejqLoUsECR9c
         qc6G2AZ7OcPsS+wNTDfqwf9Xi9DUDM1sr2uZjLcCjJqVa56Ete0CSPZcOTYtaWcWsBuV
         Okx3pVbdW+6SMwmys/0gSfJSg6nNrrBJbYvRUFmxZ5/lMA5d2GHEVOzDpu9jQDn7IeoK
         0ALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Be5wzaV9lZY1RDlj19VIREDro27DD4bWnj4QqlmMvmg=;
        b=Hl5DEzH96TjPM4r/jZ7HXgW1dAFA0x7SFw99UCsgjuTbWTmmkM7II/MWpFXSIQvDcg
         W9m4Y9dNfdoap8Zlp7VhWVurE+f5kA5hsCEP7z/DBs0PpgRWdQMbhRgst1fEdAIffjm7
         jNpYHDPJbsmItEKRvJFJk2rADDH5pwPP1cHtFbnH0h4LPXeYPB2/uJpBIhcXeWJHwg4R
         gx99isknifXcXpPEqiOcvBI4okb8+/TKgUYMe6ycKZBB8y+RNp79RoFWnFFPECFuG/B5
         ExD0o4PtSiBCHf1BHbEHAF1Bi6582alQwyvBKxr3rMS1q0jmQFhnr1HtDipkLfQw2GyL
         /eTg==
X-Gm-Message-State: APjAAAVLXUUiw+cGc38n4iSUsF7OCUpqtn37WG/fMamdNoJcn+EnysR6
        DMy7uTeTboboGLpWkVkVQDGTyuiDhz27iA==
X-Google-Smtp-Source: APXvYqwYe8l9kOYtwTMzdvPIsYy9s7vEKRGQvFqCof8HO7iVKbFi9NenY3W6PbaUyrzj2lYUzaDAsEnY9sDF1g==
X-Received: by 2002:a63:385c:: with SMTP id h28mr166028pgn.200.1582660352485;
 Tue, 25 Feb 2020 11:52:32 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:52:29 -0800
Message-Id: <20200225195229.183443-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH net] ipv6: restrict IPV6_ADDRFORM operation
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPV6_ADDRFORM is able to transform IPv6 socket to IPv4 one.
While this operation sounds illogical, we have to support it.

One of the things it does for TCP socket is to switch sk->sk_prot
to tcp_prot.

We now have other layers playing with sk->sk_prot, so we should make
sure to not interfere with them.

This patch makes sure sk_prot is the default pointer for TCP IPv6 socket.

syzbot reported :
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD a0113067 P4D a0113067 PUD a8771067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10686 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 inet_release+0x165/0x1c0 net/ipv4/af_inet.c:427
 __sock_release net/socket.c:605 [inline]
 sock_close+0xe1/0x260 net/socket.c:1283
 __fput+0x2e4/0x740 fs/file_table.c:280
 ____fput+0x15/0x20 fs/file_table.c:313
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
 syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
 do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c429
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2ae75dac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: 0000000000000000 RBX: 00007f2ae75db6d4 RCX: 000000000045c429
RDX: 0000000000000001 RSI: 000000000000011a RDI: 0000000000000004
RBP: 000000000076bf20 R08: 0000000000000038 R09: 0000000000000000
R10: 0000000020000180 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a9d R14: 00000000004ccfb4 R15: 000000000076bf2c
Modules linked in:
CR2: 0000000000000000
---[ end trace 82567b5207e87bae ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 net/ipv6/ipv6_sockglue.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 79fc012dd2cae44b69057c168037b018775d1f49..debdaeba5d8c130dbf7dd099bc29fbed80a7ac75 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -183,9 +183,15 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 					retv = -EBUSY;
 					break;
 				}
-			} else if (sk->sk_protocol != IPPROTO_TCP)
+			} else if (sk->sk_protocol == IPPROTO_TCP) {
+				if (sk->sk_prot != &tcpv6_prot) {
+					retv = -EBUSY;
+					break;
+				}
 				break;
-
+			} else {
+				break;
+			}
 			if (sk->sk_state != TCP_ESTABLISHED) {
 				retv = -ENOTCONN;
 				break;
-- 
2.25.0.265.gbab2e86ba0-goog

