Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0C1621F0F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiKHWU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiKHWUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:20:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0526964A21
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fI3ocko4NBzAXmLHrdnSY6xkrzBu8tsmas0Kk6d3w1s=;
        b=U76tgClI8oEpHmPFdDrWS5OLf+TnWEJTwPymdF1OnBfO9k1ejLGjQwSKpZXEmpxlrHV+s7
        d2b+BntpX6PKaAk+AKgmDKaUbH9yjy2KFRMr5Ohm4ec+zbyngCHDD/dmUXsh99/mTJUHeO
        JxnnzkjMq3AqvS8lQfMH0FGFFjlGNDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-rEiVMRsyNu6vWd2XiqVpSQ-1; Tue, 08 Nov 2022 17:19:04 -0500
X-MC-Unique: rEiVMRsyNu6vWd2XiqVpSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9F923801149;
        Tue,  8 Nov 2022 22:19:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 143762166B29;
        Tue,  8 Nov 2022 22:19:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/26] rxrpc: Call udp_sendmsg() directly
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:02 +0000
Message-ID: <166794594240.2389296.16232282847353290658.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call udp_sendmsg() and udpv6_sendmsg() directly rather than calling
kernel_sendmsg() as the latter assumes we want a kvec-class iterator.
However, zerocopy explicitly doesn't work with such an iterator.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/ipv6/udp.c     |    1 +
 net/rxrpc/output.c |   37 +++++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4bc3fc27ec78..331d699355f3 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1639,6 +1639,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	err = 0;
 	goto out;
 }
+EXPORT_SYMBOL(udpv6_sendmsg);
 
 void udpv6_destroy_sock(struct sock *sk)
 {
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index b803bfe146de..71885d741987 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
+#include <net/udp.h>
 #include "ar-internal.h"
 
 struct rxrpc_ack_buffer {
@@ -23,6 +24,19 @@ struct rxrpc_ack_buffer {
 	struct rxrpc_ackinfo ackinfo;
 };
 
+extern int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
+
+static ssize_t do_udp_sendmsg(struct socket *sk, struct msghdr *msg, size_t len)
+{
+#if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
+	struct sockaddr *sa = msg->msg_name;
+
+	if (sa->sa_family == AF_INET6)
+		return udpv6_sendmsg(sk->sk, msg, len);
+#endif
+	return udp_sendmsg(sk->sk, msg, len);
+}
+
 struct rxrpc_abort_buffer {
 	struct rxrpc_wire_header whdr;
 	__be32 abort_code;
@@ -258,8 +272,10 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_ping);
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_send);
-	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
+	ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
+	call->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_ack);
@@ -336,8 +352,8 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	serial = atomic_inc_return(&conn->serial);
 	pkt.whdr.serial = htonl(serial);
 
-	ret = kernel_sendmsg(conn->params.local->socket,
-			     &msg, iov, 1, sizeof(pkt));
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, sizeof(pkt));
+	ret = do_udp_sendmsg(conn->params.local->socket, &msg, sizeof(pkt));
 	conn->params.peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
@@ -397,6 +413,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	iov[1].iov_base = skb->head;
 	iov[1].iov_len = skb->len;
 	len = iov[0].iov_len + iov[1].iov_len;
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
 
 	msg.msg_name = &call->peer->srx.transport;
 	msg.msg_namelen = call->peer->srx.transport_len;
@@ -469,7 +486,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	 *     message and update the peer record
 	 */
 	rxrpc_inc_stat(call->rxnet, stat_tx_data_send);
-	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
+	ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
 	conn->params.peer->last_tx_at = ktime_get_seconds();
 
 	up_read(&conn->params.local->defrag_sem);
@@ -545,8 +562,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
 				IP_PMTUDISC_DONT);
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_frag);
-		ret = kernel_sendmsg(conn->params.local->socket, &msg,
-				     iov, 2, len);
+		ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
 		conn->params.peer->last_tx_at = ktime_get_seconds();
 
 		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
@@ -632,8 +648,8 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 			whdr.flags	^= RXRPC_CLIENT_INITIATED;
 			whdr.flags	&= RXRPC_CLIENT_INITIATED;
 
-			ret = kernel_sendmsg(local->socket, &msg,
-					     iov, ioc, size);
+			iov_iter_kvec(&msg.msg_iter, WRITE, iov, ioc, size);
+			ret = do_udp_sendmsg(local->socket, &msg, size);
 			if (ret < 0)
 				trace_rxrpc_tx_fail(local->debug_id, 0, ret,
 						    rxrpc_tx_point_reject);
@@ -688,7 +704,8 @@ void rxrpc_send_keepalive(struct rxrpc_peer *peer)
 
 	_proto("Tx VERSION (keepalive)");
 
-	ret = kernel_sendmsg(peer->local->socket, &msg, iov, 2, len);
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
+	ret = do_udp_sendmsg(peer->local->socket, &msg, len);
 	if (ret < 0)
 		trace_rxrpc_tx_fail(peer->debug_id, 0, ret,
 				    rxrpc_tx_point_version_keepalive);


