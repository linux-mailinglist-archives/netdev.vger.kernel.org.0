Return-Path: <netdev+bounces-6199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4347C7152D3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE0E71C20AFB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE3F7ED;
	Tue, 30 May 2023 01:07:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7BD636
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:07:39 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BF7CF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408857; x=1716944857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPV3NxAThO5CtILRbEkb4//CRHfAG9vvxjJSAvkOSSw=;
  b=rUFsmWC7/iBklJYvgDmf4dexQA3nzbKsrAGCpzPwmhTNw4tq71ccuYmn
   AuSzcCMPpZq/MWhSI2oAa+Zay9pP+7lFnBzNCMDtminL6qeZ1J5rrpmLE
   bwCWe3i+nn6lkYIwUAQlZYxol/LD0WXGoTVQ9vGd/ViS9opmoltyMMjzk
   A=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="217212788"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:07:34 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id 2488EE4CC9;
	Tue, 30 May 2023 01:07:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:07:30 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:07:27 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 08/14] udp: Remove csum branch for UDP-Lite.
Date: Mon, 29 May 2023 18:03:42 -0700
Message-ID: <20230530010348.21425-9-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D039UWA004.ant.amazon.com (10.13.139.68) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some functions still have conditional branches for UDP-Lite's
checksum that we can altogether remove now.

We can remove udp_skb_cb and partial_cov in struct udp_skb_cb
and finally remove udplite.h.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/linux/udp.h     |  2 --
 include/net/udp.h       | 17 ++--------
 include/net/udplite.h   | 70 -----------------------------------------
 net/ipv4/udp.c          | 58 +++++++---------------------------
 net/ipv6/ip6_checksum.c | 16 +---------
 net/ipv6/udp.c          | 37 +++++++---------------
 6 files changed, 27 insertions(+), 173 deletions(-)
 delete mode 100644 include/net/udplite.h

diff --git a/include/linux/udp.h b/include/linux/udp.h
index f2f44ad62ea0..ed6cad269fd1 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -146,6 +146,4 @@ static inline void udp_allow_gso(struct sock *sk)
 #define udp_portaddr_for_each_entry_rcu(__sk, list) \
 	hlist_for_each_entry_rcu(__sk, list, __sk_common.skc_portaddr_node)
 
-#define IS_UDPLITE(__sk) (__sk->sk_protocol == IPPROTO_UDPLITE)
-
 #endif	/* _LINUX_UDP_H */
diff --git a/include/net/udp.h b/include/net/udp.h
index d00509873f6f..902ee75bd25e 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -30,11 +30,9 @@
 #include <linux/indirect_call_wrapper.h>
 
 /**
- *	struct udp_skb_cb  -  UDP(-Lite) private variables
+ *	struct udp_skb_cb  -  UDP private variables
  *
  *	@header:      private variables used by IPv4/IPv6
- *	@cscov:       checksum coverage length (UDP-Lite only)
- *	@partial_cov: if set indicates partial csum coverage
  */
 struct udp_skb_cb {
 	union {
@@ -43,8 +41,6 @@ struct udp_skb_cb {
 		struct inet6_skb_parm	h6;
 #endif
 	} header;
-	__u16		cscov;
-	__u8		partial_cov;
 };
 #define UDP_SKB_CB(__skb)	((struct udp_skb_cb *)((__skb)->cb))
 
@@ -105,13 +101,11 @@ extern int sysctl_udp_wmem_min;
 struct sk_buff;
 
 /*
- *	Generic checksumming routines for UDP(-Lite) v4 and v6
+ *	Generic checksumming routines for UDP v4 and v6
  */
 static inline __sum16 __udp_lib_checksum_complete(struct sk_buff *skb)
 {
-	return (UDP_SKB_CB(skb)->cscov == skb->len ?
-		__skb_checksum_complete(skb) :
-		__skb_checksum_complete_head(skb, UDP_SKB_CB(skb)->cscov));
+	return __skb_checksum_complete(skb);
 }
 
 static inline int udp_lib_checksum_complete(struct sk_buff *skb)
@@ -162,7 +156,6 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
 		skb->csum = csum_partial(skb->data, sizeof(struct udphdr),
 					 skb->csum);
 	skb_pull_rcsum(skb, sizeof(struct udphdr));
-	UDP_SKB_CB(skb)->cscov -= sizeof(struct udphdr);
 }
 
 typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
@@ -494,9 +487,6 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 
 static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
 {
-	/* UDP-lite can't land here - no GRO */
-	WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
-
 	/* UDP packets generated with UDP_SEGMENT and traversing:
 	 *
 	 * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
@@ -510,7 +500,6 @@ static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
 	 * a valid csum after the segmentation.
 	 * Additionally fixup the UDP CB.
 	 */
-	UDP_SKB_CB(skb)->cscov = skb->len;
 	if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
 		skb->csum_valid = 1;
 }
diff --git a/include/net/udplite.h b/include/net/udplite.h
deleted file mode 100644
index 1bc9393f2890..000000000000
--- a/include/net/udplite.h
+++ /dev/null
@@ -1,70 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- *	Definitions for the UDP-Lite (RFC 3828) code.
- */
-#ifndef _UDPLITE_H
-#define _UDPLITE_H
-
-#include <net/ip6_checksum.h>
-#include <net/udp.h>
-
-/*
- *	Checksum computation is all in software, hence simpler getfrag.
- */
-static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
-				      int len, int odd, struct sk_buff *skb)
-{
-	struct msghdr *msg = from;
-	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
-}
-
-/*
- * 	Checksumming routines
- */
-static inline int udplite_checksum_init(struct sk_buff *skb, struct udphdr *uh)
-{
-	u16 cscov;
-
-        /* In UDPv4 a zero checksum means that the transmitter generated no
-         * checksum. UDP-Lite (like IPv6) mandates checksums, hence packets
-         * with a zero checksum field are illegal.                            */
-	if (uh->check == 0) {
-		net_dbg_ratelimited("UDPLite: zeroed checksum field\n");
-		return 1;
-	}
-
-	cscov = ntohs(uh->len);
-
-	if (cscov == 0)		 /* Indicates that full coverage is required. */
-		;
-	else if (cscov < 8  || cscov > skb->len) {
-		/*
-		 * Coverage length violates RFC 3828: log and discard silently.
-		 */
-		net_dbg_ratelimited("UDPLite: bad csum coverage %d/%d\n",
-				    cscov, skb->len);
-		return 1;
-
-	} else if (cscov < skb->len) {
-        	UDP_SKB_CB(skb)->partial_cov = 1;
-		UDP_SKB_CB(skb)->cscov = cscov;
-		if (skb->ip_summed == CHECKSUM_COMPLETE)
-			skb->ip_summed = CHECKSUM_NONE;
-		skb->csum_valid = 0;
-        }
-
-	return 0;
-}
-
-/* Fast-path computation of checksum. Socket may not be locked. */
-static inline __wsum udplite_csum(struct sk_buff *skb)
-{
-	const int off = skb_transport_offset(skb);
-	int len = skb->len - off;
-
-	skb->ip_summed = CHECKSUM_NONE;     /* no HW support for checksumming */
-
-	return skb_checksum(skb, off, len, 0);
-}
-
-#endif	/* _UDPLITE_H */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 345a6364a969..aee075fb5f4f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -113,7 +113,6 @@
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 #include <net/udp_tunnel.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
@@ -903,14 +902,12 @@ EXPORT_SYMBOL(udp_set_csum);
 static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 			struct inet_cork *cork)
 {
-	int err, len, datalen, is_udplite;
 	struct sock *sk = skb->sk;
 	struct inet_sock *inet;
+	int err, len, datalen;
 	struct udphdr *uh;
-	__wsum csum = 0;
 
 	inet = inet_sk(sk);
-	is_udplite = IS_UDPLITE(sk);
 	len = skb->len - skb_transport_offset(skb);
 	datalen = len - sizeof(*uh);
 
@@ -939,8 +936,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
-		    dst_xfrm(skb_dst(skb))) {
+		if (skb->ip_summed != CHECKSUM_PARTIAL || dst_xfrm(skb_dst(skb))) {
 			kfree_skb(skb);
 			return -EIO;
 		}
@@ -954,26 +950,18 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 		goto csum_partial;
 	}
 
-	if (is_udplite)  				 /*     UDP-Lite      */
-		csum = udplite_csum(skb);
-
-	else if (sk->sk_no_check_tx) {			 /* UDP csum off */
-
+	if (sk->sk_no_check_tx) {			 /* UDP csum off */
 		skb->ip_summed = CHECKSUM_NONE;
 		goto send;
-
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) { /* UDP hardware csum */
 csum_partial:
-
 		udp4_hwcsum(skb, fl4->saddr, fl4->daddr);
 		goto send;
-
-	} else
-		csum = udp_csum(skb);
+	}
 
 	/* add protocol-dependent pseudo-header */
 	uh->check = csum_tcpudp_magic(fl4->saddr, fl4->daddr, len,
-				      sk->sk_protocol, csum);
+				      sk->sk_protocol, udp_csum(skb));
 	if (uh->check == 0)
 		uh->check = CSUM_MANGLED_0;
 
@@ -1054,12 +1042,10 @@ EXPORT_SYMBOL_GPL(udp_cmsg_send);
 
 int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
-	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	DECLARE_SOCKADDR(struct sockaddr_in *, usin, msg->msg_name);
 	struct inet_sock *inet = inet_sk(sk);
 	struct udp_sock *up = udp_sk(sk);
 	struct ip_options_data opt_copy;
-	int is_udplite = IS_UDPLITE(sk);
 	__be32 daddr, faddr, saddr;
 	struct rtable *rt = NULL;
 	struct flowi4 fl4_stack;
@@ -1085,9 +1071,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return -EOPNOTSUPP;
 
 	corkreq = READ_ONCE(up->corkflag) || msg->msg_flags & MSG_MORE;
-	getfrag = is_udplite ? udplite_getfrag : ip_generic_getfrag;
-
 	fl4 = &inet->cork.fl.u.ip4;
+
 	if (up->pending) {
 		/*
 		 * There are pending frames.
@@ -1257,7 +1242,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (!corkreq) {
 		struct inet_cork cork;
 
-		skb = ip_make_skb(sk, fl4, getfrag, msg, ulen,
+		skb = ip_make_skb(sk, fl4, ip_generic_getfrag, msg, ulen,
 				  sizeof(struct udphdr), &ipc, &rt,
 				  &cork, msg->msg_flags);
 		err = PTR_ERR(skb);
@@ -1288,7 +1273,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 do_append_data:
 	up->len += ulen;
-	err = ip_append_data(sk, fl4, getfrag, msg, ulen,
+	err = ip_append_data(sk, fl4, ip_generic_getfrag, msg, ulen,
 			     sizeof(struct udphdr), &ipc, &rt,
 			     corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
 	if (err)
@@ -1811,7 +1796,6 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
 	int off, err, peeking = flags & MSG_PEEK;
 	struct inet_sock *inet = inet_sk(sk);
-	int is_udplite = IS_UDPLITE(sk);
 	struct net *net = sock_net(sk);
 	bool checksum_valid = false;
 	unsigned int ulen, copied;
@@ -1833,14 +1817,10 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
 	else if (copied < ulen)
 		msg->msg_flags |= MSG_TRUNC;
 
-	/*
-	 * If checksum is needed at all, try to do it while copying the
-	 * data.  If the data is truncated, or if we only want a partial
-	 * coverage checksum (UDP-Lite), do it before the copy.
+	/* If checksum is needed at all, try to do it while copying the
+	 * data.  If the data is truncated, do it before the copy.
 	 */
-
-	if (copied < ulen || peeking ||
-	    (is_udplite && UDP_SKB_CB(skb)->partial_cov)) {
+	if (copied < ulen || peeking) {
 		checksum_valid = udp_skb_csum_unnecessary(skb) ||
 				!__udp_lib_checksum_complete(skb);
 		if (!checksum_valid)
@@ -2272,20 +2252,6 @@ static inline int udp4_csum_init(struct sk_buff *skb, struct udphdr *uh,
 {
 	int err;
 
-	UDP_SKB_CB(skb)->partial_cov = 0;
-	UDP_SKB_CB(skb)->cscov = skb->len;
-
-	if (proto == IPPROTO_UDPLITE) {
-		err = udplite_checksum_init(skb, uh);
-		if (err)
-			return err;
-
-		if (UDP_SKB_CB(skb)->partial_cov) {
-			skb->csum = inet_compute_pseudo(skb, proto);
-			return 0;
-		}
-	}
-
 	/* Note, we are only interested in != 0 or == 0, thus the
 	 * force to int.
 	 */
@@ -2317,7 +2283,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 {
 	int ret;
 
-	if (inet_get_convert_csum(sk) && uh->check && !IS_UDPLITE(sk))
+	if (inet_get_convert_csum(sk) && uh->check)
 		skb_checksum_try_convert(skb, IPPROTO_UDP, inet_compute_pseudo);
 
 	ret = udp_queue_rcv_skb(sk, skb);
diff --git a/net/ipv6/ip6_checksum.c b/net/ipv6/ip6_checksum.c
index 377717045f8f..1362db7a3660 100644
--- a/net/ipv6/ip6_checksum.c
+++ b/net/ipv6/ip6_checksum.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <net/ip.h>
+#include <net/ip6_checksum.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 #include <asm/checksum.h>
 
 #ifndef _HAVE_ARCH_IPV6_CSUM
@@ -66,20 +66,6 @@ int udp6_csum_init(struct sk_buff *skb, struct udphdr *uh, int proto)
 {
 	int err;
 
-	UDP_SKB_CB(skb)->partial_cov = 0;
-	UDP_SKB_CB(skb)->cscov = skb->len;
-
-	if (proto == IPPROTO_UDPLITE) {
-		err = udplite_checksum_init(skb, uh);
-		if (err)
-			return err;
-
-		if (UDP_SKB_CB(skb)->partial_cov) {
-			skb->csum = ip6_compute_pseudo(skb, proto);
-			return 0;
-		}
-	}
-
 	/* To support RFC 6936 (allow zero checksum in UDP/IPV6 for tunnels)
 	 * we accept a checksum of zero here. When we find the socket
 	 * for the UDP packet we'll check if that socket allows zero checksum
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 5c4b0e662ff5..21d48f8803d0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -51,7 +51,6 @@
 #include <net/busy_poll.h>
 #include <net/sock_reuseport.h>
 #include <net/udp.h>
-#include <net/udplite.h>
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -344,7 +343,6 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	int off, err, peeking = flags & MSG_PEEK;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
-	int is_udplite = IS_UDPLITE(sk);
 	struct udp_mib __percpu *mib;
 	bool checksum_valid = false;
 	unsigned int ulen, copied;
@@ -373,14 +371,10 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	is_udp4 = (skb->protocol == htons(ETH_P_IP));
 	mib = __UDPX_MIB(sk, is_udp4);
 
-	/*
-	 * If checksum is needed at all, try to do it while copying the
-	 * data.  If the data is truncated, or if we only want a partial
-	 * coverage checksum (UDP-Lite), do it before the copy.
+	/* If checksum is needed at all, try to do it while copying the
+	 * data.  If the data is truncated, do it before the copy.
 	 */
-
-	if (copied < ulen || peeking ||
-	    (is_udplite && UDP_SKB_CB(skb)->partial_cov)) {
+	if (copied < ulen || peeking) {
 		checksum_valid = udp_skb_csum_unnecessary(skb) ||
 				!__udp_lib_checksum_complete(skb);
 		if (!checksum_valid)
@@ -910,7 +904,7 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 {
 	int ret;
 
-	if (inet_get_convert_csum(sk) && uh->check && !IS_UDPLITE(sk))
+	if (inet_get_convert_csum(sk) && uh->check)
 		skb_checksum_try_convert(skb, IPPROTO_UDP, ip6_compute_pseudo);
 
 	ret = udpv6_queue_rcv_skb(sk, skb);
@@ -1205,12 +1199,10 @@ static void udp6_hwcsum_outgoing(struct sock *sk, struct sk_buff *skb,
 static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			   struct inet_cork *cork)
 {
-	int err, len, datalen, is_udplite;
 	struct sock *sk = skb->sk;
+	int err, len, datalen;
 	struct udphdr *uh;
-	__wsum csum = 0;
 
-	is_udplite = IS_UDPLITE(sk);
 	len = skb->len - skb_transport_offset(skb);
 	datalen = len - sizeof(*uh);
 
@@ -1239,8 +1231,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->ip_summed != CHECKSUM_PARTIAL || is_udplite ||
-		    dst_xfrm(skb_dst(skb))) {
+		if (skb->ip_summed != CHECKSUM_PARTIAL || dst_xfrm(skb_dst(skb))) {
 			kfree_skb(skb);
 			return -EIO;
 		}
@@ -1254,21 +1245,18 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 		goto csum_partial;
 	}
 
-	if (is_udplite)
-		csum = udplite_csum(skb);
-	else if (udp_sk(sk)->no_check6_tx) {   /* UDP csum disabled */
+	if (udp_sk(sk)->no_check6_tx) {   /* UDP csum disabled */
 		skb->ip_summed = CHECKSUM_NONE;
 		goto send;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) { /* UDP hardware csum */
 csum_partial:
 		udp6_hwcsum_outgoing(sk, skb, &fl6->saddr, &fl6->daddr, len);
 		goto send;
-	} else
-		csum = udp_csum(skb);
+	}
 
 	/* add protocol-dependent pseudo-header */
 	uh->check = csum_ipv6_magic(&fl6->saddr, &fl6->daddr,
-				    len, fl6->flowi6_proto, csum);
+				    len, fl6->flowi6_proto, udp_csum(skb));
 	if (uh->check == 0)
 		uh->check = CSUM_MANGLED_0;
 
@@ -1308,7 +1296,6 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 
 int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
-	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
 	struct ipv6_txoptions *opt_to_free = NULL;
 	struct in6_addr *daddr, *final_p, final;
@@ -1319,7 +1306,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct udp_sock *up = udp_sk(sk);
 	struct ipv6_txoptions opt_space;
 	int addr_len = msg->msg_namelen;
-	int is_udplite = IS_UDPLITE(sk);
 	struct inet_cork_full cork;
 	struct ipcm6_cookie ipc6;
 	bool connected = false;
@@ -1392,7 +1378,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	corkreq = READ_ONCE(up->corkflag) || msg->msg_flags & MSG_MORE;
 	fl6 = &cork.fl.u.ip6;
 
-	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
 		if (up->pending == AF_INET)
 			return udp_sendmsg(sk, msg, len);
@@ -1562,7 +1547,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (!corkreq) {
 		struct sk_buff *skb;
 
-		skb = ip6_make_skb(sk, getfrag, msg, ulen,
+		skb = ip6_make_skb(sk, ip_generic_getfrag, msg, ulen,
 				   sizeof(struct udphdr), &ipc6,
 				   (struct rt6_info *)dst,
 				   msg->msg_flags, &cork);
@@ -1590,7 +1575,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (ipc6.dontfrag < 0)
 		ipc6.dontfrag = np->dontfrag;
 	up->len += ulen;
-	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
+	err = ip6_append_data(sk, ip_generic_getfrag, msg, ulen, sizeof(struct udphdr),
 			      &ipc6, fl6, (struct rt6_info *)dst,
 			      corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
 	if (err)
-- 
2.30.2


