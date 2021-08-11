Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997403E94F9
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhHKPr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhHKPre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:47:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCFAC0613D3;
        Wed, 11 Aug 2021 08:47:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso5635281pjy.5;
        Wed, 11 Aug 2021 08:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q/E104pcWehG6+65FuKSyhSd0QBz+jtxLHWtWT14jd0=;
        b=Y6TTwqTT9bacsMijVEa/14Q9ROIVnWsG+17L5GKxO6ZccvHIAj6z71A9RFVH2ZiocW
         Q6hA6+4dP7n19z6Dn/w1dy2J4+XNRZvXlxQmChrU+uFxekXHhFwQX3s2X1mdJbzcJ6on
         sTeOiL+Rb16oCCCl04x5IA1VJ+XQBXtHZvcXTSJ7oxWd35xaDdeTXgUKRqGhazuJZ4YR
         dk7Zz5YTJKJhsxw9CZZgrBSB2Pk26wpQf9Hm3tU2xx7yNdZnJ+PM2Nvii8flqOKQNmQj
         KJsz2YFmWgwufnuFBmkIdCt/pKZGT7nVS+KdAwSNjOcJDW6aMslNyVVGAhaV1GA8rJyN
         ZLSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q/E104pcWehG6+65FuKSyhSd0QBz+jtxLHWtWT14jd0=;
        b=lGlod9UsPYznpBPpi0SGESBtuDMLWybsItXjCxLW5oWDnSPggaMhYT/9VKO6cmoAs3
         wcr4WrmtS7BeIZCGvgmWAmX9CWgSCjWRLN5MVewcuL9UGQXNZW5MYXp4jOqq/AaaEBoA
         bHM5Vc6U3Q8jFhGrUpRhpDrVhnymvm8zARABz4waxtu3VAAhEOjZsXLapKNONwmJkNTM
         RJMEjnPwugXBZfen/arsm0Jw5gdMPxwAE7TKnB8qLrHaw/Ma0J59f4RYh/gPR/tyUjwT
         PY7svycUm34499QHpdLYtSRk/nc2to6w6PE3NwxbaY33lpgCJWzJaY5fi3zPBCH1tCK0
         YRCg==
X-Gm-Message-State: AOAM531EHBolLHm7se4DmzU/MmpT49uKmhvTZsavZQ7jsMpKaUEAvY2K
        b3qMPMIuHhZ1+wpUJ7jIrIqhkaXPqh6iOy5xLhc=
X-Google-Smtp-Source: ABdhPJyYRI8NQ31erI0YJ7KshffOhLVyCmtJPG/h+UvLiGq4iBmozuywWOy9Wmq0HYw+L1AH3kkh+g==
X-Received: by 2002:a17:90a:ce0a:: with SMTP id f10mr37848939pju.71.1628696829375;
        Wed, 11 Aug 2021 08:47:09 -0700 (PDT)
Received: from localhost.localdomain ([123.20.118.31])
        by smtp.gmail.com with ESMTPSA id z13sm6960942pjd.44.2021.08.11.08.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 08:47:09 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        minhquangbui99@gmail.com, lesedorucalin01@gmail.com
Subject: [PATCH v2 1/2] udp: UDP socket send queue repair
Date:   Wed, 11 Aug 2021 22:45:57 +0700
Message-Id: <20210811154557.6935-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this patch, I implement UDP_REPAIR sockoption and a new path in
udp_recvmsg for dumping the corked packet in UDP socket's send queue.

A userspace program can use recvmsg syscall to get the packet's data and
the msg_name information of the packet. Currently, other related
information in inet_cork that are set in cmsg are not dumped.

While working on this, I was aware of Lese Doru Calin's patch and got some
ideas from it.

Link: https://lore.kernel.org/netdev/20200502082856.GA3152@white/
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 include/linux/udp.h      |  3 +-
 include/net/udp.h        |  2 +
 include/uapi/linux/udp.h |  1 +
 net/ipv4/udp.c           | 94 +++++++++++++++++++++++++++++++++++++++-
 net/ipv6/udp.c           | 56 +++++++++++++++++++++++-
 5 files changed, 151 insertions(+), 5 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index ae66dadd8543..63df0753966e 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -70,7 +70,8 @@ struct udp_sock {
 #define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
 #define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
 	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
-	__u8		 unused[3];
+	__u8		 repair;
+	__u8		 unused[2];
 	/*
 	 * For encapsulation sockets.
 	 */
diff --git a/include/net/udp.h b/include/net/udp.h
index 360df454356c..4550e72b9f2a 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -331,6 +331,8 @@ struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
 int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
+int udp_peek_sndq(struct sock *sk, struct msghdr *msg,
+		  size_t len);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 4828794efcf8..255d056403da 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -29,6 +29,7 @@ struct udphdr {
 
 /* UDP socket options */
 #define UDP_CORK	1	/* Never send partially complete segments */
+#define UDP_REPAIR	2	/* UDP sock is under repair right now */
 #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
 #define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
 #define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1a742b710e54..c91148956338 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1826,6 +1826,65 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 }
 EXPORT_SYMBOL(udp_read_sock);
 
+static int udp_copy_addr(struct sock *sk, struct msghdr *msg, int *addr_len)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	struct flowi4 *fl4;
+	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
+
+	if (udp_sk(sk)->pending != AF_INET)
+		return -EAGAIN;
+
+	if (sin) {
+		fl4 = &inet->cork.fl.u.ip4;
+		sin->sin_family = AF_INET;
+		sin->sin_port = fl4->fl4_dport;
+		sin->sin_addr.s_addr = fl4->daddr;
+		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
+	}
+
+	return 0;
+}
+
+int udp_peek_sndq(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct sk_buff *skb;
+	int copied = 0, err = 0, peek_off, off, header_off, copy_len;
+
+	peek_off = READ_ONCE(sk->sk_peek_off);
+	if (peek_off < 0)
+		off = 0;
+	else
+		off = peek_off;
+
+	skb_queue_walk(&sk->sk_write_queue, skb) {
+		header_off = skb_transport_offset(skb) + sizeof(struct udphdr);
+		if (off > skb->len - header_off) {
+			off -= skb->len - header_off;
+			continue;
+		}
+
+		if (len > skb->len - off - header_off)
+			copy_len = skb->len - off - header_off;
+		else
+			copy_len = len;
+
+		err = skb_copy_datagram_msg(skb, off + header_off, msg, copy_len);
+		if (err)
+			return err;
+
+		copied += copy_len;
+		len -= copy_len;
+		off = 0;
+	}
+
+	if (peek_off >= 0)
+		sk_peek_offset_bwd(sk, -copied);
+	return copied;
+}
+EXPORT_SYMBOL(udp_peek_sndq);
+
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
@@ -1841,10 +1900,27 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	int off, err, peeking = flags & MSG_PEEK;
 	int is_udplite = IS_UDPLITE(sk);
 	bool checksum_valid = false;
+	struct udp_sock *up = udp_sk(sk);
 
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len, addr_len);
 
+	if (unlikely(up->repair)) {
+		if (!peeking)
+			return -EPERM;
+
+		lock_sock(sk);
+		err = udp_copy_addr(sk, msg, addr_len);
+		if (err) {
+			release_sock(sk);
+			return err;
+		}
+
+		err = udp_peek_sndq(sk, msg, len);
+		release_sock(sk);
+		return err;
+	}
+
 try_again:
 	off = sk_peek_offset(sk, flags);
 	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
@@ -1912,7 +1988,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 						      (struct sockaddr *)sin);
 	}
 
-	if (udp_sk(sk)->gro_enabled)
+	if (up->gro_enabled)
 		udp_cmsg_recv(msg, sk, skb);
 
 	if (inet->cmsg_flags)
@@ -1926,7 +2002,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	return err;
 
 csum_copy_err:
-	if (!__sk_queue_drop_skb(sk, &udp_sk(sk)->reader_queue, skb, flags,
+	if (!__sk_queue_drop_skb(sk, &up->reader_queue, skb, flags,
 				 udp_skb_destructor)) {
 		UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
@@ -2752,6 +2828,16 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		up->pcflag |= UDPLITE_RECV_CC;
 		break;
 
+	case UDP_REPAIR:
+		if (!sk_net_capable(sk, CAP_NET_ADMIN)) {
+			err = -EPERM;
+			break;
+		}
+
+		up->repair = valbool;
+		sk->sk_peek_off = -1;
+		break;
+
 	default:
 		err = -ENOPROTOOPT;
 		break;
@@ -2820,6 +2906,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->pcrlen;
 		break;
 
+	case UDP_REPAIR:
+		val = up->repair;
+		break;
+
 	default:
 		return -ENOPROTOOPT;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index c5e15e94bb00..09b5a489829b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -313,6 +313,42 @@ static int udp6_skb_len(struct sk_buff *skb)
 	return unlikely(inet6_is_jumbogram(skb)) ? skb->len : udp_skb_len(skb);
 }
 
+static int udp6_copy_addr(struct sock *sk, struct msghdr *msg, int *addr_len)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	struct flowi4 *fl4;
+	struct flowi6 *fl6;
+	DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
+
+	if (sin6) {
+		switch (udp_sk(sk)->pending) {
+		case AF_INET:
+			fl4 = &inet->cork.fl.u.ip4;
+			sin6->sin6_family = AF_INET6;
+			sin6->sin6_port = fl4->fl4_dport;
+			ipv6_addr_set_v4mapped(fl4->daddr,
+					       &sin6->sin6_addr);
+			sin6->sin6_flowinfo = 0;
+			sin6->sin6_scope_id = 0;
+			*addr_len = sizeof(*sin6);
+			break;
+		case AF_INET6:
+			fl6 = &inet->cork.fl.u.ip6;
+			sin6->sin6_family = AF_INET6;
+			sin6->sin6_port = fl6->fl6_dport;
+			sin6->sin6_addr = fl6->daddr;
+			sin6->sin6_flowinfo = fl6->flowlabel & IPV6_FLOWINFO_MASK;
+			sin6->sin6_scope_id = fl6->flowi6_oif;
+			*addr_len = sizeof(*sin6);
+			break;
+		default:
+			return -EAGAIN;
+		}
+	}
+
+	return 0;
+}
+
 /*
  *	This should be easy, if there is something there we
  *	return it, otherwise we block.
@@ -330,6 +366,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct udp_mib __percpu *mib;
 	bool checksum_valid = false;
 	int is_udp4;
+	struct udp_sock *up = udp_sk(sk);
 
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
@@ -337,6 +374,21 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
+	if (unlikely(up->repair)) {
+		if (!peeking)
+			return -EPERM;
+
+		lock_sock(sk);
+		err = udp6_copy_addr(sk, msg, addr_len);
+		if (err) {
+			release_sock(sk);
+			return err;
+		}
+
+		err = udp_peek_sndq(sk, msg, len);
+		release_sock(sk);
+		return err;
+	}
 try_again:
 	off = sk_peek_offset(sk, flags);
 	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
@@ -413,7 +465,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 						      (struct sockaddr *)sin6);
 	}
 
-	if (udp_sk(sk)->gro_enabled)
+	if (up->gro_enabled)
 		udp_cmsg_recv(msg, sk, skb);
 
 	if (np->rxopt.all)
@@ -436,7 +488,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	return err;
 
 csum_copy_err:
-	if (!__sk_queue_drop_skb(sk, &udp_sk(sk)->reader_queue, skb, flags,
+	if (!__sk_queue_drop_skb(sk, &up->reader_queue, skb, flags,
 				 udp_skb_destructor)) {
 		SNMP_INC_STATS(mib, UDP_MIB_CSUMERRORS);
 		SNMP_INC_STATS(mib, UDP_MIB_INERRORS);
-- 
2.17.1

