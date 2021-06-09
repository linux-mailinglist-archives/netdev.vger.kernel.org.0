Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D223A0E3B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 10:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhFIIDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 04:03:03 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:34607 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237399AbhFIIDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 04:03:00 -0400
Received: by mail-pj1-f46.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso3181924pjx.1
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 01:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCD52nTwTei4FNtUewt/0/MhitLNjGYdeI4x9Bv2eWE=;
        b=Pjip2Mwkjy6Kx3wjOQNnmk19kgXgp1vwz5+YXVJ+4jyCPVUiX+/JDFyiI+K9xjXsKt
         K2neoklfZgX8mwRj3HbKQDEARh7ZOikJULhjaqor6YpOBaHUU/nhHToM0ksoH4Q2SaQ7
         udgp8bVr7XwzPevC7FkP66xG11LQA+W4pHg+X4bWFB+/69YpVBkWg6L1Fy3oQqrWYsdG
         NhRPh/vO86JizL8R1dTKwxONleve/paFQx86krqRpwUCD0nCI2sp2sCd14AwziJ1Np6i
         enyE592rlHaskClYpanVbV32fWpi4S+f8Nnw9b5AGPxjOcVBZlcJySVlmEglwdxUu9nd
         zLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCD52nTwTei4FNtUewt/0/MhitLNjGYdeI4x9Bv2eWE=;
        b=tu9h8xJfwU1NLma9CryVvCPlm1OIHxwzuB9uFZAeDPcbL+DcHUKNtX7vS/pFIDv4ci
         eWDvgdlsw45al0kukBhWnB2Su/+N6LjB0KPRzXZb+4J7uZ+BOoMXAwTugGvh39HJIamF
         r1is8MsTGChW9fztYg4JuapHDtd9B+j2li2vU+jnjAvmrLKbFdzIqkJG/vVjc65gUfwW
         zBfj0dHaI/iXih9ss1eZQUsJMYofyuXc0/cwSwbjnFaebEBHeCHiKCTlyO6tr6uFzJc5
         bvXljUO9NO8+5aok2/bYn0U7vGV5JByilUxl/uVXJmJuKUFT0XJ4b9uRknIGkVESpaI4
         4iDg==
X-Gm-Message-State: AOAM531UQXCgQWkmaxKuTaKMwCdjPmO3M4036ms41dre6VU6ZMEQ1bzn
        wkCdy44RpmMhhXNUOw/dEfE=
X-Google-Smtp-Source: ABdhPJx7rbYUPbVsT8cJ8GWXxus9IQhPNSAP7iFeHdYaeweEsSuDkSvZA2zpAm/u0+EXJ0qFMKgUNA==
X-Received: by 2002:a17:90a:6305:: with SMTP id e5mr9292004pjj.232.1623225590212;
        Wed, 09 Jun 2021 00:59:50 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6726:fcf9:18f4:66f2])
        by smtp.gmail.com with ESMTPSA id j12sm13629555pgs.83.2021.06.09.00.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 00:59:49 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] inet: annotate data race in inet_send_prepare() and inet_dgram_connect()
Date:   Wed,  9 Jun 2021 00:59:45 -0700
Message-Id: <20210609075945.3976469-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both functions are known to be racy when reading inet_num
as we do not want to grab locks for the common case the socket
has been bound already. The race is resolved in inet_autobind()
by reading again inet_num under the socket lock.

syzbot reported:
BUG: KCSAN: data-race in inet_send_prepare / udp_lib_get_port

write to 0xffff88812cba150e of 2 bytes by task 24135 on cpu 0:
 udp_lib_get_port+0x4b2/0xe20 net/ipv4/udp.c:308
 udp_v6_get_port+0x5e/0x70 net/ipv6/udp.c:89
 inet_autobind net/ipv4/af_inet.c:183 [inline]
 inet_send_prepare+0xd0/0x210 net/ipv4/af_inet.c:807
 inet6_sendmsg+0x29/0x80 net/ipv6/af_inet6.c:639
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88812cba150e of 2 bytes by task 24132 on cpu 1:
 inet_send_prepare+0x21/0x210 net/ipv4/af_inet.c:806
 inet6_sendmsg+0x29/0x80 net/ipv6/af_inet6.c:639
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2516
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0x9db4

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 24132 Comm: syz-executor.2 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/af_inet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f17870ee558bbaa043c10dc5b8a61a3fa1304880..2f94d221c00e9888d0f5f3738593fda811215cc6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -575,7 +575,7 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 			return err;
 	}
 
-	if (!inet_sk(sk)->inet_num && inet_autobind(sk))
+	if (data_race(!inet_sk(sk)->inet_num) && inet_autobind(sk))
 		return -EAGAIN;
 	return sk->sk_prot->connect(sk, uaddr, addr_len);
 }
@@ -803,7 +803,7 @@ int inet_send_prepare(struct sock *sk)
 	sock_rps_record_flow(sk);
 
 	/* We may need to bind the socket. */
-	if (!inet_sk(sk)->inet_num && !sk->sk_prot->no_autobind &&
+	if (data_race(!inet_sk(sk)->inet_num) && !sk->sk_prot->no_autobind &&
 	    inet_autobind(sk))
 		return -EAGAIN;
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

