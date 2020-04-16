Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0721AC244
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 15:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895215AbgDPNYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 09:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2895193AbgDPNXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 09:23:39 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABCFC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:22:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t14so4758585wrw.12
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 06:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=jmgr9Ilk4OTLOcE/Qe6zFw8VK3hTQtTshbLpxE4HIyY=;
        b=USa0D4A3ZHxXCJSSMqlRBimle4KScA6dHiGIwyv/jMFYTSe+T+ekq5moFhTI0VUkkp
         dTyOtR2qcpxgxqfs8lA0OcbjJs6M7mdc6STVxApd+bpS+sr194gQeZZtEM32oMW8qBT6
         sPhegHhl177+nd7yeethW+KpzB0gjEP2bjTZgMeyXo0sxQYFnczud/0Nm7OFLukHQye3
         gr6Bfba0pWQiwWmFT9YCoiwEml7SubwJ8lOs7G/Y8PUpXxWcRWkrizBRF+mliM3g4yub
         SRRDOgQk77ItlcdZgqtInlfR+vzE/R1BnTDzGnapNdLOWwjUf7Fd3AtBOAnVgaQDqAjg
         gi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jmgr9Ilk4OTLOcE/Qe6zFw8VK3hTQtTshbLpxE4HIyY=;
        b=dvJ8G8wFs7X9pnsNgypNIijUudBWsrQah6DtNESS2LFnBh6ew8cxogql4ImfiSVgPv
         9c/z0vnB1WPMWXqAJWKHL4jRpG+3jK5/a6oeIny/wdtYbcbFHvBCgcXFs0tLgZweRuGM
         HtNP1pJchHA3VfpydgbmIdJh4UBFsjGmkENzZjpwVlwuKhNBBnX2vXp4/cx3uh0n+Uto
         UrLfFUXokJ0uWYJIOS8ymPGCYU1pFPhUFIaRAOdak03ZxoWr986UFEE8LcmErZVR7XMw
         HzoR8jp9hWto5XqjiLxe6HxfOfyq2TjfP72F4dIxkWr6ZKcaqEDQuUPVIXDBWmerZLlA
         AJQA==
X-Gm-Message-State: AGi0PuaxfVR+Y5DoPdOCSyT+IWpmq+otzSaiFvyQ0d+4D9Q/yt1hzY1f
        trQBPkZE+iYnhyU5phXkVhWxOsN5BvM=
X-Google-Smtp-Source: APiQypKAtNaUWU2h2s3GRiSd/Gcc0nuBUt5G0kwPf7+cT0aS42pD10Qdf4l32eYI0+rQUy3ZDD2c8g==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr26701212wrw.104.1587043367303;
        Thu, 16 Apr 2020 06:22:47 -0700 (PDT)
Received: from white ([188.27.148.74])
        by smtp.gmail.com with ESMTPSA id y7sm3743403wmb.43.2020.04.16.06.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 06:22:46 -0700 (PDT)
Date:   Thu, 16 Apr 2020 16:22:42 +0300
From:   =?utf-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v4] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
Message-ID: <20200416132242.GA2586@white>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this year's edition of GSoC, there is a project idea for CRIU to add 
support for checkpoint/restore of cork-ed UDP sockets. But to add it, the
kernel API needs to be extended.

This is what this patch does. It adds UDP "repair mode" for UDP sockets in 
a similar approach to the TCP "repair mode", but only the send queue is
necessary to be retrieved. So the patch extends the recv and setsockopt 
syscalls. Using UDP_REPAIR option in setsockopt, caller can set the socket
in repair mode. If it is setted, the recv/recvfrom/recvmsg will receive the
write queue and the destination of the data. As in the TCP mode, to change 
the repair mode requires the CAP_NET_ADMIN capability and to receive data 
the caller is obliged to use the MSG_PEEK flag.

Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
---
 include/linux/udp.h      |    3 +
 include/net/udp.h        |    3 +
 include/uapi/linux/udp.h |    1 
 net/ipv4/udp.c           |   85 +++++++++++++++++++++++++++++++++++++++--------
 net/ipv6/udp.c           |   64 ++++++++++++++++++++++++-----------
 5 files changed, 122 insertions(+), 34 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597bdc33..b22bd70118ce 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -51,7 +51,8 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1;	/* Can accept GRO packets */
+			 gro_enabled:1,	/* Can accept GRO packets */
+			 repair:1;/* Receive the send queue */
 	/*
 	 * Following member retains the information to create a UDP header
 	 * when the socket is uncorked.
diff --git a/include/net/udp.h b/include/net/udp.h
index a8fa6c0c6ded..f7a7fab0712f 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -282,8 +282,11 @@ int udp_get_port(struct sock *sk, unsigned short snum,
 int udp_err(struct sk_buff *, u32);
 int udp_abort(struct sock *sk, int err);
 int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			int noblock, int flags, int *addr_len);
 int udp_push_pending_frames(struct sock *sk);
 void udp_flush_pending_frames(struct sock *sk);
+int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len);
 int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
 void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
 int udp_rcv(struct sk_buff *skb);
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 4828794efcf8..2fe78329d6da 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -29,6 +29,7 @@ struct udphdr {
 
 /* UDP socket options */
 #define UDP_CORK	1	/* Never send partially complete segments */
+#define UDP_REPAIR  19  /* Receive the send queue */
 #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
 #define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
 #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 32564b350823..58b59db42ca3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1720,6 +1720,48 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
+int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
+{
+	int copy, copied = 0, err = 0;
+	struct sk_buff *skb;
+
+	lock_sock(sk);
+	skb_queue_walk(&sk->sk_write_queue, skb) {
+		copy = len - copied;
+		if (copy > skb->len - off)
+			copy = skb->len - off;
+
+		err = skb_copy_datagram_msg(skb, off, msg, copy);
+		if (err)
+			break;
+
+		copied += copy;
+		if (len <= copied)
+			break;
+	}
+	release_sock(sk);
+	return err ?: copied;
+}
+EXPORT_SYMBOL(udp_peek_sndq);
+
+static void udp_set_source_addr(struct sock *sk, struct msghdr *msg,
+				int *addr_len, u32 addr, u16 port)
+{
+	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
+
+	if (sin) {
+		sin->sin_family = AF_INET;
+		sin->sin_port = port;
+		sin->sin_addr.s_addr = addr;
+		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
+
+		if (cgroup_bpf_enabled)
+			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
+							(struct sockaddr *)sin);
+	}
+}
+
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
@@ -1729,8 +1771,9 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		int flags, int *addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
+	struct udp_sock *up = udp_sk(sk);
 	struct sk_buff *skb;
+	struct flowi4 *fl4;
 	unsigned int ulen, copied;
 	int off, err, peeking = flags & MSG_PEEK;
 	int is_udplite = IS_UDPLITE(sk);
@@ -1739,6 +1782,17 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len, addr_len);
 
+	if (unlikely(up->repair)) {
+		if (!peeking)
+			return -EPERM;
+
+		off = sizeof(struct iphdr) + sizeof(struct udphdr);
+		fl4 = &inet->cork.fl.u.ip4;
+		udp_set_source_addr(sk, msg, addr_len, fl4->daddr,
+				    fl4->fl4_dport);
+		return udp_peek_sndq(sk, msg, off, len);
+	}
+
 try_again:
 	off = sk_peek_offset(sk, flags);
 	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
@@ -1793,19 +1847,8 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 			      UDP_MIB_INDATAGRAMS, is_udplite);
 
 	sock_recv_ts_and_drops(msg, sk, skb);
-
-	/* Copy the address. */
-	if (sin) {
-		sin->sin_family = AF_INET;
-		sin->sin_port = udp_hdr(skb)->source;
-		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
-		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
-		*addr_len = sizeof(*sin);
-
-		if (cgroup_bpf_enabled)
-			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
-							(struct sockaddr *)sin);
-	}
+	udp_set_source_addr(sk, msg, addr_len, ip_hdr(skb)->saddr,
+			    udp_hdr(skb)->source);
 
 	if (udp_sk(sk)->gro_enabled)
 		udp_cmsg_recv(msg, sk, skb);
@@ -1833,6 +1876,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
+EXPORT_SYMBOL(udp_recvmsg);
 
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
@@ -2557,6 +2601,15 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		}
 		break;
 
+	case UDP_REPAIR:
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+			err = -EPERM;
+		else if (val != 0)
+			up->repair = 1;
+		else
+			up->repair = 0;
+		break;
+
 	case UDP_ENCAP:
 		switch (val) {
 		case 0:
@@ -2678,6 +2731,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->corkflag;
 		break;
 
+	case UDP_REPAIR:
+		val = up->repair;
+		break;
+
 	case UDP_ENCAP:
 		val = up->encap_type;
 		break;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7d4151747340..be2a668c29c5 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -250,6 +250,24 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 EXPORT_SYMBOL_GPL(udp6_lib_lookup);
 #endif
 
+static void udpv6_set_source_addr(struct sock *sk, struct msghdr *msg,
+				  int *addr_len, struct in6_addr *addr,
+				  u16 port, u32 scope_id)
+{
+	DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
+
+	sin6->sin6_family = AF_INET6;
+	sin6->sin6_port = port;
+	sin6->sin6_flowinfo = 0;
+	sin6->sin6_addr = *addr;
+	sin6->sin6_scope_id = scope_id;
+	*addr_len = sizeof(*sin6);
+
+	if (cgroup_bpf_enabled)
+		BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
+					(struct sockaddr *)sin6);
+}
+
 /* do not use the scratch area len for jumbogram: their length execeeds the
  * scratch area space; note that the IP6CB flags is still in the first
  * cacheline, so checking for jumbograms is cheap
@@ -269,8 +287,11 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
+	struct udp_sock *up = udp_sk(sk);
+	struct in6_addr saddr;
 	struct sk_buff *skb;
-	unsigned int ulen, copied;
+	struct flowi6 *fl6;
+	unsigned int ulen, scpid, copied;
 	int off, err, peeking = flags & MSG_PEEK;
 	int is_udplite = IS_UDPLITE(sk);
 	struct udp_mib __percpu *mib;
@@ -283,6 +304,23 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
+	if (unlikely(up->repair)) {
+		if (!peeking)
+			return -EPERM;
+
+		if (up->pending == AF_INET)
+			return udp_recvmsg(sk, msg, len, noblock,
+					   flags, addr_len);
+
+		off = sizeof(struct ipv6hdr) + sizeof(struct udphdr);
+		if (msg->msg_name) {
+			fl6 = &inet->cork.fl.u.ip6;
+			udpv6_set_source_addr(sk, msg, addr_len, &fl6->daddr,
+					      fl6->fl6_dport, fl6->flowi6_oif);
+		}
+		return udp_peek_sndq(sk, msg, off, len);
+	}
+
 try_again:
 	off = sk_peek_offset(sk, flags);
 	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
@@ -336,28 +374,16 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	sock_recv_ts_and_drops(msg, sk, skb);
 
-	/* Copy the address. */
 	if (msg->msg_name) {
-		DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
-		sin6->sin6_family = AF_INET6;
-		sin6->sin6_port = udp_hdr(skb)->source;
-		sin6->sin6_flowinfo = 0;
-
 		if (is_udp4) {
-			ipv6_addr_set_v4mapped(ip_hdr(skb)->saddr,
-					       &sin6->sin6_addr);
-			sin6->sin6_scope_id = 0;
+			ipv6_addr_set_v4mapped(ip_hdr(skb)->saddr, &saddr);
+			scpid = 0;
 		} else {
-			sin6->sin6_addr = ipv6_hdr(skb)->saddr;
-			sin6->sin6_scope_id =
-				ipv6_iface_scope_id(&sin6->sin6_addr,
-						    inet6_iif(skb));
+			saddr = ipv6_hdr(skb)->saddr;
+			scpid = ipv6_iface_scope_id(&saddr, inet6_iif(skb));
 		}
-		*addr_len = sizeof(*sin6);
-
-		if (cgroup_bpf_enabled)
-			BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
-						(struct sockaddr *)sin6);
+		udpv6_set_source_addr(sk, msg, addr_len, &saddr,
+				      udp_hdr(skb)->source, scpid);
 	}
 
 	if (udp_sk(sk)->gro_enabled)
