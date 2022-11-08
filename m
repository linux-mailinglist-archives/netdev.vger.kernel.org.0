Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C8E621F09
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiKHWUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKHWT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5393A5800D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0ICaD4B6wKeXNJGrAhC+dsFuyjV6dVhrh9+hCll+NE=;
        b=AGaSTgZvv9LET8C/1I1oQhwo0RWw0UZLxza54+7A1l395yNbshNm0IcXpFuOMCJl0QOrBr
        KQ6cmmtQirZ5Cvpnezh2A/9VX3gjKubf3MeRtsdSc+CZAAr8aKDvOfAt1Z7GHfE7Z2lRy/
        EOpPQbu8F6K4pl9w4oGzS0ZMy4iAAdU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-4TzpSzjZMweAvDYd0dUMog-1; Tue, 08 Nov 2022 17:18:51 -0500
X-MC-Unique: 4TzpSzjZMweAvDYd0dUMog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE9F7101A52A;
        Tue,  8 Nov 2022 22:18:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 476E52024CC1;
        Tue,  8 Nov 2022 22:18:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 09/26] net: Change the udp encap_err_rcv to allow use
 of {ip,ipv6}_icmp_error()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:49 +0000
Message-ID: <166794592958.2389296.2747114929168447718.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the udp encap_err_rcv signature to match ip_icmp_error() and
ipv6_icmp_error() so that those can be used from the called function and
export them.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
---

 include/linux/udp.h      |    3 +-
 include/net/udp_tunnel.h |    4 +--
 net/ipv4/ip_sockglue.c   |    1 +
 net/ipv4/udp.c           |    3 +-
 net/ipv6/datagram.c      |    1 +
 net/ipv6/udp.c           |    3 +-
 net/rxrpc/ar-internal.h  |    2 +
 net/rxrpc/peer_event.c   |   71 +++++++++++-----------------------------------
 8 files changed, 28 insertions(+), 60 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 5cdba00a904a..dea57aa37df6 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -70,7 +70,8 @@ struct udp_sock {
 	 * For encapsulation sockets.
 	 */
 	int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
-	void (*encap_err_rcv)(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
+	void (*encap_err_rcv)(struct sock *sk, struct sk_buff *skb, int err,
+			      __be16 port, u32 info, u8 *payload);
 	int (*encap_err_lookup)(struct sock *sk, struct sk_buff *skb);
 	void (*encap_destroy)(struct sock *sk);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 72394f441dad..0ca9b7a11baf 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -68,8 +68,8 @@ typedef int (*udp_tunnel_encap_rcv_t)(struct sock *sk, struct sk_buff *skb);
 typedef int (*udp_tunnel_encap_err_lookup_t)(struct sock *sk,
 					     struct sk_buff *skb);
 typedef void (*udp_tunnel_encap_err_rcv_t)(struct sock *sk,
-					   struct sk_buff *skb,
-					   unsigned int udp_offset);
+					   struct sk_buff *skb, int err,
+					   __be16 port, u32 info, u8 *payload);
 typedef void (*udp_tunnel_encap_destroy_t)(struct sock *sk);
 typedef struct sk_buff *(*udp_tunnel_gro_receive_t)(struct sock *sk,
 						    struct list_head *head,
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 5f16807d3235..9f92ae35bb01 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -433,6 +433,7 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 	}
 	kfree_skb(skb);
 }
+EXPORT_SYMBOL_GPL(ip_icmp_error);
 
 void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 info)
 {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 89accc3c8bb3..b859d6c8298e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -784,7 +784,8 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	if (tunnel) {
 		/* ...not for tunnels though: we don't have a sending socket */
 		if (udp_sk(sk)->encap_err_rcv)
-			udp_sk(sk)->encap_err_rcv(sk, skb, iph->ihl << 2);
+			udp_sk(sk)->encap_err_rcv(sk, skb, err, uh->dest, info,
+						  (u8 *)(uh+1));
 		goto out;
 	}
 	if (!inet->recverr) {
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index df7e032ce87d..7c7155b48f17 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -334,6 +334,7 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 	if (sock_queue_err_skb(sk, skb))
 		kfree_skb(skb);
 }
+EXPORT_SYMBOL_GPL(ipv6_icmp_error);
 
 void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info)
 {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 297f7cc06044..4bc3fc27ec78 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -631,7 +631,8 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	/* Tunnels don't have an application socket: don't pass errors back */
 	if (tunnel) {
 		if (udp_sk(sk)->encap_err_rcv)
-			udp_sk(sk)->encap_err_rcv(sk, skb, offset);
+			udp_sk(sk)->encap_err_rcv(sk, skb, err, uh->dest,
+						  ntohl(info), (u8 *)(uh+1));
 		goto out;
 	}
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 436a1e8d0abd..51270b2e49c3 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -998,7 +998,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
 /*
  * peer_event.c
  */
-void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
+void rxrpc_encap_err_rcv(struct sock *, struct sk_buff *, int, __be16, u32, u8 *);
 void rxrpc_error_report(struct sock *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 32561e9567fe..d7d6d7aff985 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -29,20 +29,16 @@ static void rxrpc_distribute_error(struct rxrpc_peer *, int,
  */
 static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 						     struct sk_buff *skb,
-						     unsigned int udp_offset,
-						     unsigned int *info,
+						     __be16 udp_port,
 						     struct sockaddr_rxrpc *srx)
 {
 	struct iphdr *ip, *ip0 = ip_hdr(skb);
 	struct icmphdr *icmp = icmp_hdr(skb);
-	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
 
 	_enter("%u,%u,%u", ip0->protocol, icmp->type, icmp->code);
 
 	switch (icmp->type) {
 	case ICMP_DEST_UNREACH:
-		*info = ntohs(icmp->un.frag.mtu);
-		fallthrough;
 	case ICMP_TIME_EXCEEDED:
 	case ICMP_PARAMETERPROB:
 		ip = (struct iphdr *)((void *)icmp + 8);
@@ -63,7 +59,7 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 	case AF_INET:
 		srx->transport_len = sizeof(srx->transport.sin);
 		srx->transport.family = AF_INET;
-		srx->transport.sin.sin_port = udp->dest;
+		srx->transport.sin.sin_port = udp_port;
 		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
 		       sizeof(struct in_addr));
 		break;
@@ -72,7 +68,7 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 	case AF_INET6:
 		srx->transport_len = sizeof(srx->transport.sin);
 		srx->transport.family = AF_INET;
-		srx->transport.sin.sin_port = udp->dest;
+		srx->transport.sin.sin_port = udp_port;
 		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
 		       sizeof(struct in_addr));
 		break;
@@ -93,20 +89,16 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
  */
 static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
 						      struct sk_buff *skb,
-						      unsigned int udp_offset,
-						      unsigned int *info,
+						      __be16 udp_port,
 						      struct sockaddr_rxrpc *srx)
 {
 	struct icmp6hdr *icmp = icmp6_hdr(skb);
 	struct ipv6hdr *ip, *ip0 = ipv6_hdr(skb);
-	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
 
 	_enter("%u,%u,%u", ip0->nexthdr, icmp->icmp6_type, icmp->icmp6_code);
 
 	switch (icmp->icmp6_type) {
 	case ICMPV6_DEST_UNREACH:
-		*info = ntohl(icmp->icmp6_mtu);
-		fallthrough;
 	case ICMPV6_PKT_TOOBIG:
 	case ICMPV6_TIME_EXCEED:
 	case ICMPV6_PARAMPROB:
@@ -129,13 +121,13 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
 		_net("Rx ICMP6 on v4 sock");
 		srx->transport_len = sizeof(srx->transport.sin);
 		srx->transport.family = AF_INET;
-		srx->transport.sin.sin_port = udp->dest;
+		srx->transport.sin.sin_port = udp_port;
 		memcpy(&srx->transport.sin.sin_addr,
 		       &ip->daddr.s6_addr32[3], sizeof(struct in_addr));
 		break;
 	case AF_INET6:
 		_net("Rx ICMP6");
-		srx->transport.sin.sin_port = udp->dest;
+		srx->transport.sin.sin_port = udp_port;
 		memcpy(&srx->transport.sin6.sin6_addr, &ip->daddr,
 		       sizeof(struct in6_addr));
 		break;
@@ -152,15 +144,13 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
 /*
  * Handle an error received on the local endpoint as a tunnel.
  */
-void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
-			 unsigned int udp_offset)
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, int err,
+			 __be16 port, u32 info, u8 *payload)
 {
 	struct sock_extended_err ee;
 	struct sockaddr_rxrpc srx;
 	struct rxrpc_local *local;
 	struct rxrpc_peer *peer;
-	unsigned int info = 0;
-	int err;
 	u8 version = ip_hdr(skb)->version;
 	u8 type = icmp_hdr(skb)->type;
 	u8 code = icmp_hdr(skb)->code;
@@ -176,13 +166,11 @@ void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
 
 	switch (ip_hdr(skb)->version) {
 	case IPVERSION:
-		peer = rxrpc_lookup_peer_icmp_rcu(local, skb, udp_offset,
-						  &info, &srx);
+		peer = rxrpc_lookup_peer_icmp_rcu(local, skb, port, &srx);
 		break;
 #ifdef CONFIG_AF_RXRPC_IPV6
 	case 6:
-		peer = rxrpc_lookup_peer_icmp6_rcu(local, skb, udp_offset,
-						   &info, &srx);
+		peer = rxrpc_lookup_peer_icmp6_rcu(local, skb, port, &srx);
 		break;
 #endif
 	default:
@@ -201,34 +189,12 @@ void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
 
 	switch (version) {
 	case IPVERSION:
-		switch (type) {
-		case ICMP_DEST_UNREACH:
-			switch (code) {
-			case ICMP_FRAG_NEEDED:
-				rxrpc_adjust_mtu(peer, info);
-				rcu_read_unlock();
-				rxrpc_put_peer(peer);
-				return;
-			default:
-				break;
-			}
-
-			err = EHOSTUNREACH;
-			if (code <= NR_ICMP_UNREACH) {
-				/* Might want to do something different with
-				 * non-fatal errors
-				 */
-				//harderr = icmp_err_convert[code].fatal;
-				err = icmp_err_convert[code].errno;
-			}
-			break;
-
-		case ICMP_TIME_EXCEEDED:
-			err = EHOSTUNREACH;
-			break;
-		default:
-			err = EPROTO;
-			break;
+		if (type == ICMP_DEST_UNREACH &&
+		    code == ICMP_FRAG_NEEDED) {
+			rxrpc_adjust_mtu(peer, info);
+			rcu_read_unlock();
+			rxrpc_put_peer(peer);
+			return;
 		}
 
 		ee.ee_origin = SO_EE_ORIGIN_ICMP;
@@ -239,16 +205,13 @@ void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
 
 #ifdef CONFIG_AF_RXRPC_IPV6
 	case 6:
-		switch (type) {
-		case ICMPV6_PKT_TOOBIG:
+		if (type == ICMPV6_PKT_TOOBIG) {
 			rxrpc_adjust_mtu(peer, info);
 			rcu_read_unlock();
 			rxrpc_put_peer(peer);
 			return;
 		}
 
-		icmpv6_err_convert(type, code, &err);
-
 		if (err == EACCES)
 			err = EHOSTUNREACH;
 


