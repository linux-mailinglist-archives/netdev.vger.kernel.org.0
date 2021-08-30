Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8F23FBAC7
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhH3RWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhH3RWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:22:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60766C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 10:21:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id bg1so3646879plb.13
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 10:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJiGw0Uc7CzBANKVi+6brTtfBW+x2MlWpBFomfLcT7E=;
        b=eVPXsskz7C60fe/vlywev1TBxM26nAp0rqMN6PhfAUZTiI63c8x8w4apAIElNYoa8Y
         XHniQl56Z2xr1U5rVfKTDUKyqN00P42/gtFB6IXFN65HdiKRLZsWwl6vlXu3yXWaau4Q
         cZue6FZcTwYUfZ+l/sC95XRPDCNqVxiHY4dBAi88Bonbu8qE5+aklRz3+0BFxvG0VpV4
         PEcpI4bkh1hF38qeqs3mvaojW73zNAiGJkkPrNjU0LE3u8OLADzBemFdVdfjB0UehkZw
         C/Liv2GKVYyT8oOYTgAKX8i383DKde3lF+n0yqhSi6kyw7cbPzpWDDjIoyUibiuuIODL
         7RUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJiGw0Uc7CzBANKVi+6brTtfBW+x2MlWpBFomfLcT7E=;
        b=dp43+2nTZ2wbfraJo2+1xQ14Q6sqdFN3Q5oCoaf03/iRo1HCcPNcl8hBPGWK+zrFof
         vyhPwX7dVq7ree1El//On68j1xNs8z2sakhPo5sJGrrp7KSGidtdjF8tmO4Z4YPE5/R/
         iYeWEPENP+i9tXkEIznXknjdZaLwKTdIU+GWzRnNHF0qUCX3JFcNJM2qwA8eyrDZJ2tt
         ChTXn3e6TbJf7bYkmtCcOq/AqPjzLRqqQh7h/0aXlHesCj2WZ9DDcRoWXAO0undLUOmU
         FXienLPdHW9fO2r4VM7aSd/GCIu01VFoHYboIqby72412BEmw86ampmN5p6AakvNDhbL
         e79A==
X-Gm-Message-State: AOAM531dnwHNSEaURML50MGm5q594fWMRegwkTCdvHsnOtN/OCkW9klO
        5I+Bw/cAbKQ94w18VmX2L6s=
X-Google-Smtp-Source: ABdhPJy+vcwTu0GePaKthW+rtATKRNUtR2/XVaTr5+2OgSXxFN+tx2xD44mrDTgq9gqrj8l839m/aA==
X-Received: by 2002:a17:902:8f83:b0:138:9186:71d7 with SMTP id z3-20020a1709028f8300b00138918671d7mr655198plo.56.1630344102843;
        Mon, 30 Aug 2021 10:21:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9d39:21f7:8d5a:bfe])
        by smtp.gmail.com with ESMTPSA id w3sm15817735pfn.96.2021.08.30.10.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:21:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] af_unix: fix potential NULL deref in unix_dgram_connect()
Date:   Mon, 30 Aug 2021 10:21:37 -0700
Message-Id: <20210830172137.325718-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot was able to trigger NULL deref in unix_dgram_connect() [1]

This happens in

	if (unix_peer(sk))
		sk->sk_state = other->sk_state = TCP_ESTABLISHED; // crash because @other is NULL

Because locks have been dropped, unix_peer() might be non NULL,
while @other is NULL (AF_UNSPEC case)

We need to move code around, so that we no longer access
unix_peer() and sk_state while locks have been released.

[1]
general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 10341 Comm: syz-executor239 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unix_dgram_connect+0x32a/0xc60 net/unix/af_unix.c:1226
Code: 00 00 45 31 ed 49 83 bc 24 f8 05 00 00 00 74 69 e8 eb 5b a6 f9 48 8d 7d 12 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 e0 07 00 00
RSP: 0018:ffffc9000a89fcd8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff87cf4ef5 RDI: 0000000000000012
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88802e1917c3
R10: ffffffff87cf4eba R11: 0000000000000001 R12: ffff88802e191740
R13: 0000000000000000 R14: ffff88802e191d38 R15: ffff88802e1917c0
FS:  00007f3eb0052700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004787d0 CR3: 0000000029c0a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __sys_connect_file+0x155/0x1a0 net/socket.c:1890
 __sys_connect+0x161/0x190 net/socket.c:1907
 __do_sys_connect net/socket.c:1917 [inline]
 __se_sys_connect net/socket.c:1914 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1914
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446a89
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3eb0052208 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00000000004cc4d8 RCX: 0000000000446a89
RDX: 000000000000006e RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000004cc4d0 R08: 00007f3eb0052700 R09: 0000000000000000
R10: 00007f3eb0052700 R11: 0000000000000246 R12: 00000000004cc4dc
R13: 00007ffd791e79cf R14: 00007f3eb0052300 R15: 0000000000022000
Modules linked in:
---[ end trace 4eb809357514968c ]---
RIP: 0010:unix_dgram_connect+0x32a/0xc60 net/unix/af_unix.c:1226
Code: 00 00 45 31 ed 49 83 bc 24 f8 05 00 00 00 74 69 e8 eb 5b a6 f9 48 8d 7d 12 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 e0 07 00 00
RSP: 0018:ffffc9000a89fcd8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000002 RSI: ffffffff87cf4ef5 RDI: 0000000000000012
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88802e1917c3
R10: ffffffff87cf4eba R11: 0000000000000001 R12: ffff88802e191740
R13: 0000000000000000 R14: ffff88802e191d38 R15: ffff88802e1917c0
FS:  00007f3eb0052700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd791fe960 CR3: 0000000029c0a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/unix/af_unix.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4cf0b1c47f0f99e99c12d37af2494f301a965856..5d49c92a2487d663d511d26c2cb024f5f3d670d8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -494,7 +494,7 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 			sk_error_report(other);
 		}
 	}
-	sk->sk_state = other->sk_state = TCP_CLOSE;
+	other->sk_state = TCP_CLOSE;
 }
 
 static void unix_sock_destructor(struct sock *sk)
@@ -1196,6 +1196,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		if (err)
 			goto out_unlock;
 
+		sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	} else {
 		/*
 		 *	1003.1g breaking connected state with AF_UNSPEC
@@ -1209,7 +1210,10 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 	 */
 	if (unix_peer(sk)) {
 		struct sock *old_peer = unix_peer(sk);
+
 		unix_peer(sk) = other;
+		if (!other)
+			sk->sk_state = TCP_CLOSE;
 		unix_dgram_peer_wake_disconnect_wakeup(sk, old_peer);
 
 		unix_state_double_unlock(sk, other);
@@ -1222,8 +1226,6 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		unix_state_double_unlock(sk, other);
 	}
 
-	if (unix_peer(sk))
-		sk->sk_state = other->sk_state = TCP_ESTABLISHED;
 	return 0;
 
 out_unlock:
@@ -1805,6 +1807,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 
 			unix_state_unlock(sk);
 
+			sk->sk_state = TCP_CLOSE;
 			unix_dgram_disconnected(sk, other);
 			sock_put(other);
 			err = -ECONNREFUSED;
-- 
2.33.0.259.gc128427fd7-goog

