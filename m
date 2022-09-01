Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA915A91A1
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbiIAIHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiIAIHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:07:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5528BD2EAC
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 01:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662019655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v4JhmQvz5wu0u0rQUkK82gCbSyysjQqD9Eh+1gkTips=;
        b=XIL77Bkjym5LHTg6V58JVJ7PkRsrxIiy/m0I9F8fRpHQ7YmhU6kASl16wRcH5irT9cD3gp
        WNhlNy8hiFE3TDWLqj5rcx6SaCQTLxzyPqwT02qJjKtnH/mS3JzCsWcU480EfMCKX9ba3J
        KzYVantA7Wfx5pDatz5WkKdhLTTpqgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-AE-3gOcTPOav7Mcwkz6Bcw-1; Thu, 01 Sep 2022 04:07:33 -0400
X-MC-Unique: AE-3gOcTPOav7Mcwkz6Bcw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBE0796408F;
        Thu,  1 Sep 2022 08:07:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05AF640334F;
        Thu,  1 Sep 2022 08:07:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/6] rxrpc: Fix ICMP/ICMP6 error handling
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 09:07:31 +0100
Message-ID: <166201965117.3817988.7408300519776744363.stgit@warthog.procyon.org.uk>
In-Reply-To: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
References: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because rxrpc pretends to be a tunnel on top of a UDP/UDP6 socket, allowing
it to siphon off UDP packets early in the handling of received UDP packets
thereby avoiding the packet going through the UDP receive queue, it doesn't
get ICMP packets through the UDP ->sk_error_report() callback.  In fact, it
doesn't appear that there's any usable option for getting hold of ICMP
packets.

Fix this by adding a new UDP encap hook to distribute error messages for
UDP tunnels.  If the hook is set, then the tunnel driver will be able to
see ICMP packets.  The hook provides the offset into the packet of the UDP
header of the original packet that caused the notification.

An alternative would be to call the ->error_handler() hook - but that
requires that the skbuff be cloned (as ip_icmp_error() or ipv6_cmp_error()
do, though isn't really necessary or desirable in rxrpc's case is we want
to parse them there and then, not queue them).

Changes
=======
ver #2)
 - Fixed some missing CONFIG_AF_RXRPC_IPV6 conditionals.

Fixes: 5271953cad31 ("rxrpc: Use the UDP encap_rcv hook")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/udp.h        |    1 
 include/net/udp_tunnel.h   |    4 +
 net/ipv4/udp.c             |    2 
 net/ipv4/udp_tunnel_core.c |    1 
 net/ipv6/udp.c             |    5 +
 net/rxrpc/ar-internal.h    |    1 
 net/rxrpc/local_object.c   |    1 
 net/rxrpc/peer_event.c     |  291 +++++++++++++++++++++++++++++++++++++++-----
 8 files changed, 269 insertions(+), 37 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 254a2654400f..e96da4157d04 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -70,6 +70,7 @@ struct udp_sock {
 	 * For encapsulation sockets.
 	 */
 	int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
+	void (*encap_err_rcv)(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
 	int (*encap_err_lookup)(struct sock *sk, struct sk_buff *skb);
 	void (*encap_destroy)(struct sock *sk);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index afc7ce713657..72394f441dad 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -67,6 +67,9 @@ static inline int udp_sock_create(struct net *net,
 typedef int (*udp_tunnel_encap_rcv_t)(struct sock *sk, struct sk_buff *skb);
 typedef int (*udp_tunnel_encap_err_lookup_t)(struct sock *sk,
 					     struct sk_buff *skb);
+typedef void (*udp_tunnel_encap_err_rcv_t)(struct sock *sk,
+					   struct sk_buff *skb,
+					   unsigned int udp_offset);
 typedef void (*udp_tunnel_encap_destroy_t)(struct sock *sk);
 typedef struct sk_buff *(*udp_tunnel_gro_receive_t)(struct sock *sk,
 						    struct list_head *head,
@@ -80,6 +83,7 @@ struct udp_tunnel_sock_cfg {
 	__u8  encap_type;
 	udp_tunnel_encap_rcv_t encap_rcv;
 	udp_tunnel_encap_err_lookup_t encap_err_lookup;
+	udp_tunnel_encap_err_rcv_t encap_err_rcv;
 	udp_tunnel_encap_destroy_t encap_destroy;
 	udp_tunnel_gro_receive_t gro_receive;
 	udp_tunnel_gro_complete_t gro_complete;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 34eda973bbf1..cd72158e953a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -783,6 +783,8 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	 */
 	if (tunnel) {
 		/* ...not for tunnels though: we don't have a sending socket */
+		if (udp_sk(sk)->encap_err_rcv)
+			udp_sk(sk)->encap_err_rcv(sk, skb, iph->ihl << 2);
 		goto out;
 	}
 	if (!inet->recverr) {
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 8efaf8c3fe2a..8242c8947340 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -72,6 +72,7 @@ void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
 
 	udp_sk(sk)->encap_type = cfg->encap_type;
 	udp_sk(sk)->encap_rcv = cfg->encap_rcv;
+	udp_sk(sk)->encap_err_rcv = cfg->encap_err_rcv;
 	udp_sk(sk)->encap_err_lookup = cfg->encap_err_lookup;
 	udp_sk(sk)->encap_destroy = cfg->encap_destroy;
 	udp_sk(sk)->gro_receive = cfg->gro_receive;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 16c176e7c69a..3366d6a77ff2 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -616,8 +616,11 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	/* Tunnels don't have an application socket: don't pass errors back */
-	if (tunnel)
+	if (tunnel) {
+		if (udp_sk(sk)->encap_err_rcv)
+			udp_sk(sk)->encap_err_rcv(sk, skb, offset);
 		goto out;
+	}
 
 	if (!np->recverr) {
 		if (!harderr || sk->sk_state != TCP_ESTABLISHED)
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 571436064cd6..62c70709d798 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -982,6 +982,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
 /*
  * peer_event.c
  */
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
 void rxrpc_error_report(struct sock *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 96ecb7356c0f..79bb02eb67b2 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -137,6 +137,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 
 	tuncfg.encap_type = UDP_ENCAP_RXRPC;
 	tuncfg.encap_rcv = rxrpc_input_packet;
+	tuncfg.encap_err_rcv = rxrpc_encap_err_rcv;
 	tuncfg.sk_user_data = local;
 	setup_udp_tunnel_sock(net, local->socket, &tuncfg);
 
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index be032850ae8c..d5da67072068 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -16,22 +16,40 @@
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <net/ip.h>
+#include <net/icmp.h>
 #include "ar-internal.h"
 
+static void rxrpc_adjust_mtu(struct rxrpc_peer *, unsigned int);
 static void rxrpc_store_error(struct rxrpc_peer *, struct sock_exterr_skb *);
 static void rxrpc_distribute_error(struct rxrpc_peer *, int,
 				   enum rxrpc_call_completion);
 
 /*
- * Find the peer associated with an ICMP packet.
+ * Find the peer associated with an ICMPv4 packet.
  */
 static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
-						     const struct sk_buff *skb,
+						     struct sk_buff *skb,
+						     unsigned int udp_offset,
+						     unsigned int *info,
 						     struct sockaddr_rxrpc *srx)
 {
-	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	struct iphdr *ip, *ip0 = ip_hdr(skb);
+	struct icmphdr *icmp = icmp_hdr(skb);
+	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
 
-	_enter("");
+	_enter("%u,%u,%u", ip0->protocol, icmp->type, icmp->code);
+
+	switch (icmp->type) {
+	case ICMP_DEST_UNREACH:
+		*info = ntohs(icmp->un.frag.mtu);
+		fallthrough;
+	case ICMP_TIME_EXCEEDED:
+	case ICMP_PARAMETERPROB:
+		ip = (struct iphdr *)((void *)icmp + 8);
+		break;
+	default:
+		return NULL;
+	}
 
 	memset(srx, 0, sizeof(*srx));
 	srx->transport_type = local->srx.transport_type;
@@ -41,6 +59,230 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
 	 * versa?
 	 */
+	switch (srx->transport.family) {
+	case AF_INET:
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
+		       sizeof(struct in_addr));
+		break;
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case AF_INET6:
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
+		       sizeof(struct in_addr));
+		break;
+#endif
+
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	_net("ICMP {%pISp}", &srx->transport);
+	return rxrpc_lookup_peer_rcu(local, srx);
+}
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+/*
+ * Find the peer associated with an ICMPv6 packet.
+ */
+static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
+						      struct sk_buff *skb,
+						      unsigned int udp_offset,
+						      unsigned int *info,
+						      struct sockaddr_rxrpc *srx)
+{
+	struct icmp6hdr *icmp = icmp6_hdr(skb);
+	struct ipv6hdr *ip, *ip0 = ipv6_hdr(skb);
+	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
+
+	_enter("%u,%u,%u", ip0->nexthdr, icmp->icmp6_type, icmp->icmp6_code);
+
+	switch (icmp->icmp6_type) {
+	case ICMPV6_DEST_UNREACH:
+		*info = ntohl(icmp->icmp6_mtu);
+		fallthrough;
+	case ICMPV6_PKT_TOOBIG:
+	case ICMPV6_TIME_EXCEED:
+	case ICMPV6_PARAMPROB:
+		ip = (struct ipv6hdr *)((void *)icmp + 8);
+		break;
+	default:
+		return NULL;
+	}
+
+	memset(srx, 0, sizeof(*srx));
+	srx->transport_type = local->srx.transport_type;
+	srx->transport_len = local->srx.transport_len;
+	srx->transport.family = local->srx.transport.family;
+
+	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
+	 * versa?
+	 */
+	switch (srx->transport.family) {
+	case AF_INET:
+		_net("Rx ICMP6 on v4 sock");
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr,
+		       &ip->daddr.s6_addr32[3], sizeof(struct in_addr));
+		break;
+	case AF_INET6:
+		_net("Rx ICMP6");
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin6.sin6_addr, &ip->daddr,
+		       sizeof(struct in6_addr));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	_net("ICMP {%pISp}", &srx->transport);
+	return rxrpc_lookup_peer_rcu(local, srx);
+}
+#endif /* CONFIG_AF_RXRPC_IPV6 */
+
+/*
+ * Handle an error received on the local endpoint as a tunnel.
+ */
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
+			 unsigned int udp_offset)
+{
+	struct sock_extended_err ee;
+	struct sockaddr_rxrpc srx;
+	struct rxrpc_local *local;
+	struct rxrpc_peer *peer;
+	unsigned int info = 0;
+	int err;
+	u8 version = ip_hdr(skb)->version;
+	u8 type = icmp_hdr(skb)->type;
+	u8 code = icmp_hdr(skb)->code;
+
+	rcu_read_lock();
+	local = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!local)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	rxrpc_new_skb(skb, rxrpc_skb_received);
+
+	switch (ip_hdr(skb)->version) {
+	case IPVERSION:
+		peer = rxrpc_lookup_peer_icmp_rcu(local, skb, udp_offset,
+						  &info, &srx);
+		break;
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case 6:
+		peer = rxrpc_lookup_peer_icmp6_rcu(local, skb, udp_offset,
+						   &info, &srx);
+		break;
+#endif
+	default:
+		rcu_read_unlock();
+		return;
+	}
+
+	if (peer && !rxrpc_get_peer_maybe(peer))
+		peer = NULL;
+	if (!peer) {
+		rcu_read_unlock();
+		return;
+	}
+
+	memset(&ee, 0, sizeof(ee));
+
+	switch (version) {
+	case IPVERSION:
+		switch (type) {
+		case ICMP_DEST_UNREACH:
+			switch (code) {
+			case ICMP_FRAG_NEEDED:
+				rxrpc_adjust_mtu(peer, info);
+				rcu_read_unlock();
+				rxrpc_put_peer(peer);
+				return;
+			default:
+				break;
+			}
+
+			err = EHOSTUNREACH;
+			if (code <= NR_ICMP_UNREACH) {
+				/* Might want to do something different with
+				 * non-fatal errors
+				 */
+				//harderr = icmp_err_convert[code].fatal;
+				err = icmp_err_convert[code].errno;
+			}
+			break;
+
+		case ICMP_TIME_EXCEEDED:
+			err = EHOSTUNREACH;
+			break;
+		default:
+			err = EPROTO;
+			break;
+		}
+
+		ee.ee_origin = SO_EE_ORIGIN_ICMP;
+		ee.ee_type = type;
+		ee.ee_code = code;
+		ee.ee_errno = err;
+		break;
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case 6:
+		switch (type) {
+		case ICMPV6_PKT_TOOBIG:
+			rxrpc_adjust_mtu(peer, info);
+			rcu_read_unlock();
+			rxrpc_put_peer(peer);
+			return;
+		}
+
+		icmpv6_err_convert(type, code, &err);
+
+		if (err == EACCES)
+			err = EHOSTUNREACH;
+
+		ee.ee_origin = SO_EE_ORIGIN_ICMP6;
+		ee.ee_type = type;
+		ee.ee_code = code;
+		ee.ee_errno = err;
+		break;
+#endif
+	}
+
+	trace_rxrpc_rx_icmp(peer, &ee, &srx);
+
+	rxrpc_distribute_error(peer, err, RXRPC_CALL_NETWORK_ERROR);
+	rcu_read_unlock();
+	rxrpc_put_peer(peer);
+}
+
+/*
+ * Find the peer associated with a local error.
+ */
+static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
+						      const struct sk_buff *skb,
+						      struct sockaddr_rxrpc *srx)
+{
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+
+	_enter("");
+
+	memset(srx, 0, sizeof(*srx));
+	srx->transport_type = local->srx.transport_type;
+	srx->transport_len = local->srx.transport_len;
+	srx->transport.family = local->srx.transport.family;
+
 	switch (srx->transport.family) {
 	case AF_INET:
 		srx->transport_len = sizeof(srx->transport.sin);
@@ -104,10 +346,8 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 /*
  * Handle an MTU/fragmentation problem.
  */
-static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, struct sock_exterr_skb *serr)
+static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 {
-	u32 mtu = serr->ee.ee_info;
-
 	_net("Rx ICMP Fragmentation Needed (%d)", mtu);
 
 	/* wind down the local interface MTU */
@@ -172,41 +412,20 @@ void rxrpc_error_report(struct sock *sk)
 	}
 	rxrpc_new_skb(skb, rxrpc_skb_received);
 	serr = SKB_EXT_ERR(skb);
-	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
-		_leave("UDP empty message");
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		return;
-	}
 
-	peer = rxrpc_lookup_peer_icmp_rcu(local, skb, &srx);
-	if (peer && !rxrpc_get_peer_maybe(peer))
-		peer = NULL;
-	if (!peer) {
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		_leave(" [no peer]");
-		return;
-	}
-
-	trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
-
-	if ((serr->ee.ee_origin == SO_EE_ORIGIN_ICMP &&
-	     serr->ee.ee_type == ICMP_DEST_UNREACH &&
-	     serr->ee.ee_code == ICMP_FRAG_NEEDED)) {
-		rxrpc_adjust_mtu(peer, serr);
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		rxrpc_put_peer(peer);
-		_leave(" [MTU update]");
-		return;
+	if (serr->ee.ee_origin == SO_EE_ORIGIN_LOCAL) {
+		peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
+		if (peer && !rxrpc_get_peer_maybe(peer))
+			peer = NULL;
+		if (peer) {
+			trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
+			rxrpc_store_error(peer, serr);
+		}
 	}
 
-	rxrpc_store_error(peer, serr);
 	rcu_read_unlock();
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	rxrpc_put_peer(peer);
-
 	_leave("");
 }
 


