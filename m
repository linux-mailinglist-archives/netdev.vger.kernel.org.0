Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE7D49FCA5
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbiA1PRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241222AbiA1PRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:17:05 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C120C061747;
        Fri, 28 Jan 2022 07:17:05 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id C2BBF2E19EC;
        Fri, 28 Jan 2022 18:16:57 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id P2tWiljPRG-GuH0dNOh;
        Fri, 28 Jan 2022 18:16:57 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643383017; bh=v1u8vfr7wd4FzzBYIadsUhnz+CIP/pvuk/Qq3gahyyU=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=hGtFBtaHvz6s6LzujPjqU2a0Y6ZLcaT6Jc446btLUXOqkww3utvS+g+GL0UnENrw1
         R/RNPHMbSMqPtyNNZyG0ARluoV0BosxoZa0lG6mvGRMsf/MAyOohSN5wvA1Yu01vwi
         ksx3nFyp7FqMJ3ozRgXmRhqQ3mfKNgSY/CFXGCm4=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IrjHL3bpzz-GuIOxrUv;
        Fri, 28 Jan 2022 18:16:56 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v3 2/4] txhash: Add socket option to control TX hash rethink behavior
Date:   Fri, 28 Jan 2022 18:16:00 +0300
Message-Id: <20220128151602.2748-3-hmukos@yandex-team.ru>
In-Reply-To: <20220128151602.2748-1-hmukos@yandex-team.ru>
References: <20220128151602.2748-1-hmukos@yandex-team.ru>
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
index 8baaad52d799..a9c4bb30adb3 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -123,6 +123,8 @@
 
 #define SO_BUF_LOCK		0x4046
 
+#define SO_TXREHASH		0x4047
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
index cc83140d6502..8869b0d470c9 100644
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
@@ -486,6 +487,7 @@ struct sock {
 	kuid_t			sk_uid;
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	u8			sk_prefer_busy_poll;
+	u8			sk_txrehash;
 	u16			sk_busy_poll_budget;
 #endif
 	struct pid		*sk_peer_pid;
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
index 0accd6102ece..51d6bb2f6765 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -31,6 +31,7 @@ struct __kernel_sockaddr_storage {
 
 #define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
 
+#define SOCK_TXREHASH_DEFAULT	((u8)-1)
 #define SOCK_TXREHASH_DISABLED	0
 #define SOCK_TXREHASH_ENABLED	1
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 62627e868e03..daace0d10156 100644
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
+		sk->sk_txrehash = (u8)val;
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

