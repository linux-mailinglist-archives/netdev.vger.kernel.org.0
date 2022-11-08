Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A845F621F0D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiKHWUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKHWUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:20:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0A863CF8
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYowBStDtbmSksFLlJNG1WGbKQnDprcHsLd0XXxzF0I=;
        b=eLH5MeoJI+t1AQltK2CCG2bxJYOysPesj9Lur7skcXyQeUNgxZgq4oZeC4kgrEE7eUAvyt
        rVAdJlCIXpzV5taGpGBUVoVSTnTgMBKyUR32228hwHqerL4t57NByWBOGxmTmUfWs3TSsr
        G0UxxBQZloXkzdBIols2IKf3251Y7hw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-mtaGGAqtNwGLWyYMGqISIg-1; Tue, 08 Nov 2022 17:18:57 -0500
X-MC-Unique: mtaGGAqtNwGLWyYMGqISIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F9B21C08793;
        Tue,  8 Nov 2022 22:18:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D2C6140EBF3;
        Tue,  8 Nov 2022 22:18:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 10/26] rxrpc: Use the core ICMP/ICMP6 parsers
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:56 +0000
Message-ID: <166794593605.2389296.4691455419013637117.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make rxrpc_encap_rcv_err() pass the ICMP/ICMP6 skbuff to ip_icmp_error() or
ipv6_icmp_error() as appropriate to do the parsing rather than trying to do
it in rxrpc.

This pushes an error report onto the UDP socket's error queue and calls
->sk_error_report() from which point rxrpc can pick it up.

It would be preferable to steal the packet directly from ip*_icmp_error()
rather than letting it get queued, but this is probably good enough.

Also note that __udp4_lib_err() calls sk_error_report() twice in some
cases.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |    1 
 net/rxrpc/local_object.c |   13 ++
 net/rxrpc/peer_event.c   |  245 +++++-----------------------------------------
 3 files changed, 42 insertions(+), 217 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 51270b2e49c3..ba0ee5d1c723 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -998,7 +998,6 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
 /*
  * peer_event.c
  */
-void rxrpc_encap_err_rcv(struct sock *, struct sk_buff *, int, __be16, u32, u8 *);
 void rxrpc_error_report(struct sock *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 38ea98ff426b..e95e75e785fb 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -23,6 +23,19 @@
 static void rxrpc_local_processor(struct work_struct *);
 static void rxrpc_local_rcu(struct rcu_head *);
 
+/*
+ * Handle an ICMP/ICMP6 error turning up at the tunnel.  Push it through the
+ * usual mechanism so that it gets parsed and presented through the UDP
+ * socket's error_report().
+ */
+static void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, int err,
+				__be16 port, u32 info, u8 *payload)
+{
+	if (ip_hdr(skb)->version == IPVERSION)
+		return ip_icmp_error(sk, skb, err, port, info, payload);
+	return ipv6_icmp_error(sk, skb, err, port, info, payload);
+}
+
 /*
  * Compare a local to an address.  Return -ve, 0 or +ve to indicate less than,
  * same or greater than.
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index d7d6d7aff985..cda3890657a9 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -16,220 +16,12 @@
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <net/ip.h>
-#include <net/icmp.h>
 #include "ar-internal.h"
 
-static void rxrpc_adjust_mtu(struct rxrpc_peer *, unsigned int);
 static void rxrpc_store_error(struct rxrpc_peer *, struct sock_exterr_skb *);
 static void rxrpc_distribute_error(struct rxrpc_peer *, int,
 				   enum rxrpc_call_completion);
 
-/*
- * Find the peer associated with an ICMPv4 packet.
- */
-static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
-						     struct sk_buff *skb,
-						     __be16 udp_port,
-						     struct sockaddr_rxrpc *srx)
-{
-	struct iphdr *ip, *ip0 = ip_hdr(skb);
-	struct icmphdr *icmp = icmp_hdr(skb);
-
-	_enter("%u,%u,%u", ip0->protocol, icmp->type, icmp->code);
-
-	switch (icmp->type) {
-	case ICMP_DEST_UNREACH:
-	case ICMP_TIME_EXCEEDED:
-	case ICMP_PARAMETERPROB:
-		ip = (struct iphdr *)((void *)icmp + 8);
-		break;
-	default:
-		return NULL;
-	}
-
-	memset(srx, 0, sizeof(*srx));
-	srx->transport_type = local->srx.transport_type;
-	srx->transport_len = local->srx.transport_len;
-	srx->transport.family = local->srx.transport.family;
-
-	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
-	 * versa?
-	 */
-	switch (srx->transport.family) {
-	case AF_INET:
-		srx->transport_len = sizeof(srx->transport.sin);
-		srx->transport.family = AF_INET;
-		srx->transport.sin.sin_port = udp_port;
-		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
-		       sizeof(struct in_addr));
-		break;
-
-#ifdef CONFIG_AF_RXRPC_IPV6
-	case AF_INET6:
-		srx->transport_len = sizeof(srx->transport.sin);
-		srx->transport.family = AF_INET;
-		srx->transport.sin.sin_port = udp_port;
-		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
-		       sizeof(struct in_addr));
-		break;
-#endif
-
-	default:
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-
-	_net("ICMP {%pISp}", &srx->transport);
-	return rxrpc_lookup_peer_rcu(local, srx);
-}
-
-#ifdef CONFIG_AF_RXRPC_IPV6
-/*
- * Find the peer associated with an ICMPv6 packet.
- */
-static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
-						      struct sk_buff *skb,
-						      __be16 udp_port,
-						      struct sockaddr_rxrpc *srx)
-{
-	struct icmp6hdr *icmp = icmp6_hdr(skb);
-	struct ipv6hdr *ip, *ip0 = ipv6_hdr(skb);
-
-	_enter("%u,%u,%u", ip0->nexthdr, icmp->icmp6_type, icmp->icmp6_code);
-
-	switch (icmp->icmp6_type) {
-	case ICMPV6_DEST_UNREACH:
-	case ICMPV6_PKT_TOOBIG:
-	case ICMPV6_TIME_EXCEED:
-	case ICMPV6_PARAMPROB:
-		ip = (struct ipv6hdr *)((void *)icmp + 8);
-		break;
-	default:
-		return NULL;
-	}
-
-	memset(srx, 0, sizeof(*srx));
-	srx->transport_type = local->srx.transport_type;
-	srx->transport_len = local->srx.transport_len;
-	srx->transport.family = local->srx.transport.family;
-
-	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
-	 * versa?
-	 */
-	switch (srx->transport.family) {
-	case AF_INET:
-		_net("Rx ICMP6 on v4 sock");
-		srx->transport_len = sizeof(srx->transport.sin);
-		srx->transport.family = AF_INET;
-		srx->transport.sin.sin_port = udp_port;
-		memcpy(&srx->transport.sin.sin_addr,
-		       &ip->daddr.s6_addr32[3], sizeof(struct in_addr));
-		break;
-	case AF_INET6:
-		_net("Rx ICMP6");
-		srx->transport.sin.sin_port = udp_port;
-		memcpy(&srx->transport.sin6.sin6_addr, &ip->daddr,
-		       sizeof(struct in6_addr));
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-
-	_net("ICMP {%pISp}", &srx->transport);
-	return rxrpc_lookup_peer_rcu(local, srx);
-}
-#endif /* CONFIG_AF_RXRPC_IPV6 */
-
-/*
- * Handle an error received on the local endpoint as a tunnel.
- */
-void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, int err,
-			 __be16 port, u32 info, u8 *payload)
-{
-	struct sock_extended_err ee;
-	struct sockaddr_rxrpc srx;
-	struct rxrpc_local *local;
-	struct rxrpc_peer *peer;
-	u8 version = ip_hdr(skb)->version;
-	u8 type = icmp_hdr(skb)->type;
-	u8 code = icmp_hdr(skb)->code;
-
-	rcu_read_lock();
-	local = rcu_dereference_sk_user_data(sk);
-	if (unlikely(!local)) {
-		rcu_read_unlock();
-		return;
-	}
-
-	rxrpc_new_skb(skb, rxrpc_skb_received);
-
-	switch (ip_hdr(skb)->version) {
-	case IPVERSION:
-		peer = rxrpc_lookup_peer_icmp_rcu(local, skb, port, &srx);
-		break;
-#ifdef CONFIG_AF_RXRPC_IPV6
-	case 6:
-		peer = rxrpc_lookup_peer_icmp6_rcu(local, skb, port, &srx);
-		break;
-#endif
-	default:
-		rcu_read_unlock();
-		return;
-	}
-
-	if (peer && !rxrpc_get_peer_maybe(peer))
-		peer = NULL;
-	if (!peer) {
-		rcu_read_unlock();
-		return;
-	}
-
-	memset(&ee, 0, sizeof(ee));
-
-	switch (version) {
-	case IPVERSION:
-		if (type == ICMP_DEST_UNREACH &&
-		    code == ICMP_FRAG_NEEDED) {
-			rxrpc_adjust_mtu(peer, info);
-			rcu_read_unlock();
-			rxrpc_put_peer(peer);
-			return;
-		}
-
-		ee.ee_origin = SO_EE_ORIGIN_ICMP;
-		ee.ee_type = type;
-		ee.ee_code = code;
-		ee.ee_errno = err;
-		break;
-
-#ifdef CONFIG_AF_RXRPC_IPV6
-	case 6:
-		if (type == ICMPV6_PKT_TOOBIG) {
-			rxrpc_adjust_mtu(peer, info);
-			rcu_read_unlock();
-			rxrpc_put_peer(peer);
-			return;
-		}
-
-		if (err == EACCES)
-			err = EHOSTUNREACH;
-
-		ee.ee_origin = SO_EE_ORIGIN_ICMP6;
-		ee.ee_type = type;
-		ee.ee_code = code;
-		ee.ee_errno = err;
-		break;
-#endif
-	}
-
-	trace_rxrpc_rx_icmp(peer, &ee, &srx);
-
-	rxrpc_distribute_error(peer, err, RXRPC_CALL_NETWORK_ERROR);
-	rcu_read_unlock();
-	rxrpc_put_peer(peer);
-}
-
 /*
  * Find the peer associated with a local error.
  */
@@ -246,6 +38,9 @@ static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
 	srx->transport_len = local->srx.transport_len;
 	srx->transport.family = local->srx.transport.family;
 
+	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
+	 * versa?
+	 */
 	switch (srx->transport.family) {
 	case AF_INET:
 		srx->transport_len = sizeof(srx->transport.sin);
@@ -375,20 +170,38 @@ void rxrpc_error_report(struct sock *sk)
 	}
 	rxrpc_new_skb(skb, rxrpc_skb_received);
 	serr = SKB_EXT_ERR(skb);
+	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
+		_leave("UDP empty message");
+		rcu_read_unlock();
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		return;
+	}
 
-	if (serr->ee.ee_origin == SO_EE_ORIGIN_LOCAL) {
-		peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
-		if (peer && !rxrpc_get_peer_maybe(peer))
-			peer = NULL;
-		if (peer) {
-			trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
-			rxrpc_store_error(peer, serr);
-		}
+	peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
+	if (peer && !rxrpc_get_peer_maybe(peer))
+		peer = NULL;
+	if (!peer) {
+		rcu_read_unlock();
+		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		_leave(" [no peer]");
+		return;
 	}
 
+	trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
+
+	if ((serr->ee.ee_origin == SO_EE_ORIGIN_ICMP &&
+	     serr->ee.ee_type == ICMP_DEST_UNREACH &&
+	     serr->ee.ee_code == ICMP_FRAG_NEEDED)) {
+		rxrpc_adjust_mtu(peer, serr->ee.ee_info);
+		goto out;
+	}
+
+	rxrpc_store_error(peer, serr);
+out:
 	rcu_read_unlock();
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	rxrpc_put_peer(peer);
+
 	_leave("");
 }
 


