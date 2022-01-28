Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C234A0113
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 20:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350980AbiA1Tok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 14:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiA1Toj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 14:44:39 -0500
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA55EC061714;
        Fri, 28 Jan 2022 11:44:38 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id B77D82E1267;
        Fri, 28 Jan 2022 22:44:35 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id tXt5iljH7U-iYHmDKw8;
        Fri, 28 Jan 2022 22:44:35 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643399075; bh=52LiHu+XPkFqsMnDLS8WdCcQATA+lGvesVGekcSAhjY=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=Dq/0EkBTvDCXAPCSYQIdaixi9KP8B+Qqkf0C3BT2OqW5p7ti5cueteQt2K2sV6jhy
         0PjBq9n6XL7o2cviZScnuUtARoSQaow55D/4uEFCxTA6tlGsqiagL+TDQnfYicVMKh
         qG5KPUccUxLFfGbYdfKy5p80iDtYrbzdsbdt2MR4=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id AubVxLDYQ9-iYIGCnda;
        Fri, 28 Jan 2022 22:44:34 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v4 2/5] txhash: Add socket option to control TX hash rethink behavior
Date:   Fri, 28 Jan 2022 22:44:05 +0300
Message-Id: <20220128194408.17742-3-hmukos@yandex-team.ru>
In-Reply-To: <20220128194408.17742-1-hmukos@yandex-team.ru>
References: <20220128194408.17742-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the SO_TXREHASH socket option to control hash rethink behavior per socket.
When default mode is set, sockets disable rehash at initialization and use
sysctl option when entering listen state. setsockopt() overrides default
behavior.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/net/sock.h                    | 12 +++---------
 include/uapi/asm-generic/socket.h     |  2 ++
 include/uapi/linux/socket.h           |  1 +
 net/core/sock.c                       | 13 +++++++++++++
 net/ipv4/inet_connection_sock.c       |  3 +++
 9 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 284d28755b8d..7d81535893af 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -133,6 +133,8 @@
 
 #define SO_RESERVE_MEM		73
 
+#define SO_TXREHASH		74
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 24e0efb360f6..1d55e57b8466 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -144,6 +144,8 @@
 
 #define SO_RESERVE_MEM		73
 
+#define SO_TXREHASH		74
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 845ddc63c882..654061e0964e 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -125,6 +125,8 @@
 
 #define SO_RESERVE_MEM		0x4047
 
+#define SO_TXREHASH		0x4048
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 2672dd03faf3..666f81e617ea 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -126,6 +126,8 @@
 
 #define SO_RESERVE_MEM           0x0052
 
+#define SO_TXREHASH              0x0053
+
 
 #if !defined(__KERNEL__)
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 0540e1b2aeb0..15cf639a5f23 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -316,6 +316,7 @@ struct sk_filter;
   *	@sk_rcvtimeo: %SO_RCVTIMEO setting
   *	@sk_sndtimeo: %SO_SNDTIMEO setting
   *	@sk_txhash: computed flow hash for use on transmit
+  *	@sk_txrehash: enable TX hash rethink
   *	@sk_filter: socket filtering instructions
   *	@sk_timer: sock cleanup timer
   *	@sk_stamp: time stamp of last packet received
@@ -493,6 +494,7 @@ struct sock {
 	kuid_t			sk_uid;
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	u8			sk_prefer_busy_poll;
+	u8			sk_txrehash;
 	u16			sk_busy_poll_budget;
 #endif
 	spinlock_t		sk_peer_lock;
@@ -2066,18 +2068,10 @@ static inline void sk_set_txhash(struct sock *sk)
 
 static inline bool sk_rethink_txhash(struct sock *sk)
 {
-	u8 rehash;
-
-	if (!sk->sk_txhash)
-		return false;
-
-	rehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
-
-	if (rehash) {
+	if (sk->sk_txhash && sk->sk_txrehash == SOCK_TXREHASH_ENABLED) {
 		sk_set_txhash(sk);
 		return true;
 	}
-
 	return false;
 }
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index c77a1313b3b0..467ca2f28760 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -128,6 +128,8 @@
 
 #define SO_RESERVE_MEM		73
 
+#define SO_TXREHASH		74
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 0accd6102ece..51d6bb2f6765 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,6 +31,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
+#define SOCK_TXREHASH_DEFAULT	((u8)-1)
 #define SOCK_TXREHASH_DISABLED	0
 #define SOCK_TXREHASH_ENABLED	1
 
diff --git a/net/core/sock.c b/net/core/sock.c
index cccf21f3618d..5e711b42898f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1447,6 +1447,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 	}
 
+	case SO_TXREHASH:
+		if (val < -1 || val > 1) {
+			ret = -EINVAL;
+			break;
+		}
+		sk->sk_txrehash = (u8)val;
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1834,6 +1842,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_reserved_mem;
 		break;
 
+	case SO_TXREHASH:
+		v.val = sk->sk_txrehash;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
@@ -3279,6 +3291,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_pacing_rate = ~0UL;
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
+	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
 	sk_rx_queue_clear(sk);
 	/*
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fc2a985f6064..b81fb13fc5f4 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1046,6 +1046,9 @@ int inet_csk_listen_start(struct sock *sk)
 	sk->sk_ack_backlog = 0;
 	inet_csk_delack_init(sk);
 
+	if (sk->sk_txrehash == SOCK_TXREHASH_DEFAULT)
+		sk->sk_txrehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
+
 	/* There is race window here: we announce ourselves listening,
 	 * but this transition is still not validated by get_port().
 	 * It is OK, because this socket enters to hash table only
-- 
2.17.1

