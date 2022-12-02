Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2221B63FCD3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiLBAWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiLBAV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:21:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E661FFB9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Me+ROeT49aCKJ3azuUlnNHIqF71bOfLTZWQmzO3ZSU=;
        b=I/uQx84jtE+WNeYy3+KuHNRK5P+yOXB08Oh2g8PYVCgpglMbYY+vPXXvMmvu3dv+eHsrud
        wLfq10MtH8vGXproqXOP0hhFSRcNX+IQeEROczpe+FPCwoemk53q76B+NhejOlNs2wZYaX
        //jMOgb6ZhEq1b1jYjR7B8wBRZEcfvw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-nhkn0XbPP8Koa0-0ykikFw-1; Thu, 01 Dec 2022 19:18:05 -0500
X-MC-Unique: nhkn0XbPP8Koa0-0ykikFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 283B11C05EC9;
        Fri,  2 Dec 2022 00:18:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C38AC15BB4;
        Fri,  2 Dec 2022 00:18:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 21/36] rxrpc: Move error processing into the local
 endpoint I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:18:01 +0000
Message-ID: <166994028164.1732290.13913511917053984010.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the processing of error packets into the local endpoint I/O thread,
leaving the handover from UDP to merely transfer them into the local
endpoint queue.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    4 +++-
 net/rxrpc/io_thread.c   |   29 +++++++++++++++++++++++++++++
 net/rxrpc/peer_event.c  |   41 ++++++-----------------------------------
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 044815ba2b49..566377c64184 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -37,6 +37,7 @@ struct rxrpc_txbuf;
  */
 enum rxrpc_skb_mark {
 	RXRPC_SKB_MARK_PACKET,		/* Received packet */
+	RXRPC_SKB_MARK_ERROR,		/* Error notification */
 	RXRPC_SKB_MARK_REJECT_BUSY,	/* Reject with BUSY */
 	RXRPC_SKB_MARK_REJECT_ABORT,	/* Reject with ABORT (code in skb->priority) */
 };
@@ -959,6 +960,7 @@ void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection
  * io_thread.c
  */
 int rxrpc_encap_rcv(struct sock *, struct sk_buff *);
+void rxrpc_error_report(struct sock *);
 int rxrpc_io_thread(void *data);
 static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
 {
@@ -1063,7 +1065,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
 /*
  * peer_event.c
  */
-void rxrpc_error_report(struct sock *);
+void rxrpc_input_error(struct rxrpc_local *, struct sk_buff *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
 /*
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index ee2e36c46ae2..416c6101cf78 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -37,6 +37,31 @@ int rxrpc_encap_rcv(struct sock *udp_sk, struct sk_buff *skb)
 	return 0;
 }
 
+/*
+ * Handle an error received on the local endpoint.
+ */
+void rxrpc_error_report(struct sock *sk)
+{
+	struct rxrpc_local *local;
+	struct sk_buff *skb;
+
+	rcu_read_lock();
+	local = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!local)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	while ((skb = skb_dequeue(&sk->sk_error_queue))) {
+		skb->mark = RXRPC_SKB_MARK_ERROR;
+		rxrpc_new_skb(skb, rxrpc_skb_new_error_report);
+		skb_queue_tail(&local->rx_queue, skb);
+	}
+
+	rxrpc_wake_up_io_thread(local);
+	rcu_read_unlock();
+}
+
 /*
  * post connection-level events to the connection
  * - this includes challenges, responses, some aborts and call terminal packet
@@ -405,6 +430,10 @@ int rxrpc_io_thread(void *data)
 				rxrpc_input_packet(local, skb);
 				rcu_read_unlock();
 				break;
+			case RXRPC_SKB_MARK_ERROR:
+				rxrpc_input_error(local, skb);
+				rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
+				break;
 			default:
 				WARN_ON_ONCE(1);
 				rxrpc_free_skb(skb, rxrpc_skb_put_unknown);
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index f35cfc458dcf..94f63fb1bd67 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -131,51 +131,26 @@ static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 /*
  * Handle an error received on the local endpoint.
  */
-void rxrpc_error_report(struct sock *sk)
+void rxrpc_input_error(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	struct sock_exterr_skb *serr;
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
 	struct sockaddr_rxrpc srx;
-	struct rxrpc_local *local;
 	struct rxrpc_peer *peer = NULL;
-	struct sk_buff *skb;
 
-	rcu_read_lock();
-	local = rcu_dereference_sk_user_data(sk);
-	if (unlikely(!local)) {
-		rcu_read_unlock();
-		return;
-	}
-	_enter("%p{%d}", sk, local->debug_id);
+	_enter("L=%x", local->debug_id);
 
-	/* Clear the outstanding error value on the socket so that it doesn't
-	 * cause kernel_sendmsg() to return it later.
-	 */
-	sock_error(sk);
-
-	skb = sock_dequeue_err_skb(sk);
-	if (!skb) {
-		rcu_read_unlock();
-		_leave("UDP socket errqueue empty");
-		return;
-	}
-	rxrpc_new_skb(skb, rxrpc_skb_new_error_report);
-	serr = SKB_EXT_ERR(skb);
 	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
 		_leave("UDP empty message");
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 		return;
 	}
 
+	rcu_read_lock();
 	peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
 	if (peer && !rxrpc_get_peer_maybe(peer, rxrpc_peer_get_input_error))
 		peer = NULL;
-	if (!peer) {
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
-		_leave(" [no peer]");
+	rcu_read_unlock();
+	if (!peer)
 		return;
-	}
 
 	trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
 
@@ -188,11 +163,7 @@ void rxrpc_error_report(struct sock *sk)
 
 	rxrpc_store_error(peer, serr);
 out:
-	rcu_read_unlock();
-	rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 	rxrpc_put_peer(peer, rxrpc_peer_put_input_error);
-
-	_leave("");
 }
 
 /*


