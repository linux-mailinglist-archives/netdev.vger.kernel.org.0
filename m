Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8695344EC8A
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhKLSW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:22:59 -0500
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:50086 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235265AbhKLSWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 13:22:50 -0500
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A1C652E1027;
        Fri, 12 Nov 2021 21:19:55 +0300 (MSK)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [2a02:6b8:c08:bd1e:0:640:7470:3316])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id LSoaUhoOcR-JtsaNqkl;
        Fri, 12 Nov 2021 21:19:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1636741195; bh=zBJXiQ4gH23vXskSG78LRyY/+tZ/7PgtnwQ/mnHzAOg=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=Kd++5bZ9gugp+o8OhkGm+0L4D3KGwXuitugtVbuHhqQdXjMDTjrr1dpngOdrOS7YG
         cg2PKYd/YCK3LV+mtlnKLTMHdCIBRKjezNy6b4Z23qep1siO0M4xwNy6OiG5AS11ai
         cETFILRb+l1FezNafp/paYzJfcVVaaR3NCIVUhew=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id vuM7zSALw5-JsxqIJ3t;
        Fri, 12 Nov 2021 21:19:54 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     hmukos@yandex-team.ru
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v2 net-next 2/4] txhash: Add socket option to control TX hash rethink behavior
Date:   Fri, 12 Nov 2021 21:19:37 +0300
Message-Id: <20211112181939.11329-3-hmukos@yandex-team.ru>
In-Reply-To: <20211112181939.11329-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211112181939.11329-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the SO_TXREHASH socket option to control hash rethink behavior per socket.
When default mode is set, sockets disable rehash at initialization and use
sysctl option when entering listen state. setsockopt() overrides default
behavior.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
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
index 1dd9baf4a6c2..e6b3f38f8c0e 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -131,6 +131,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_TXREHASH		73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 1eaf6a1ca561..2c8085ecde0a 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -142,6 +142,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_TXREHASH		73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 8baaad52d799..8bb78ed36e97 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -123,6 +123,8 @@
 
 #define SO_BUF_LOCK		0x4046
 
+#define SO_TXREHASH     	0x4047
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index e80ee8641ac3..cd43a690fbac 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -124,6 +124,8 @@
 
 #define SO_BUF_LOCK              0x0051
 
+#define SO_TXREHASH              0x0052
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/net/sock.h b/include/net/sock.h
index cc83140d6502..26c0efd7aa4b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -313,6 +313,7 @@ struct bpf_local_storage;
   *	@sk_rcvtimeo: %SO_RCVTIMEO setting
   *	@sk_sndtimeo: %SO_SNDTIMEO setting
   *	@sk_txhash: computed flow hash for use on transmit
+  *	@sk_txrehash: enable TX hash rethink
   *	@sk_filter: socket filtering instructions
   *	@sk_timer: sock cleanup timer
   *	@sk_stamp: time stamp of last packet received
@@ -462,6 +463,7 @@ struct sock {
 	unsigned int		sk_gso_max_size;
 	gfp_t			sk_allocation;
 	__u32			sk_txhash;
+	u8			sk_txrehash;
 
 	/*
 	 * Because of non atomicity rules, all
@@ -1954,18 +1956,10 @@ static inline void sk_set_txhash(struct sock *sk)
 
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
index 1f0a2b4864e4..6c17e477ec9f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -126,6 +126,8 @@
 
 #define SO_BUF_LOCK		72
 
+#define SO_TXREHASH		73
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index 0accd6102ece..75fab2ada8cf 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,6 +31,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
+#define SOCK_TXREHASH_DEFAULT	-1
 #define SOCK_TXREHASH_DISABLED	0
 #define SOCK_TXREHASH_ENABLED	1
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 62627e868e03..ca349ca4c31d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1367,6 +1367,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 					  ~SOCK_BUF_LOCK_MASK);
 		break;
 
+	case SO_TXREHASH:
+		if (val < -1 || val > 1) {
+			ret = -EINVAL;
+			break;
+		}
+		sk->sk_txrehash = val;
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1733,6 +1741,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_userlocks & SOCK_BUF_LOCK_MASK;
 		break;
 
+	case SO_TXREHASH:
+		v.val = sk->sk_txrehash;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
@@ -3165,6 +3177,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_pacing_rate = ~0UL;
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
+	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
 	sk_rx_queue_clear(sk);
 	/*
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f25d02ad4a8a..0d477c816309 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1046,6 +1046,9 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
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

