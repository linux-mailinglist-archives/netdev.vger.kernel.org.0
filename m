Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA0F6448AA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbiLFQEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiLFQCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:02:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C592D76C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gKRLpVEUwHNwp00j44YemD4GrzDTsfSMu14l1PMgPMI=;
        b=M/hqnD0MgEPmavA5vCpeJQJO+UuyPBys2NOtZPmWuRufaNQeVLmE1onPHsYwTxI6RaeeCJ
        IFvOMG1JA5aLwQRlIjXd7RJkvZDqYAP0L8/Zq2AeaSA9NW7/YXKEMR0Gu49qOJsPGRsH4f
        3p+2hhlje6aTawo/7xyTivtfZ5E6JP8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-8utbsERJOdWksMqxd58Ymw-1; Tue, 06 Dec 2022 11:01:28 -0500
X-MC-Unique: 8utbsERJOdWksMqxd58Ymw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B2B8858F17;
        Tue,  6 Dec 2022 16:01:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBBBB140EBF5;
        Tue,  6 Dec 2022 16:01:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 20/32] rxrpc: Offload the completion of service conn
 security to the I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:01:26 +0000
Message-ID: <167034248623.1105287.17936732760243344472.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
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

Offload the completion of the challenge/response cycle on a service
connection to the I/O thread.  After the RESPONSE packet has been
successfully decrypted and verified by the work queue, offloading the
changing of the call states to the I/O thread makes iteration over the
conn's channel list simpler.

Do this by marking the RESPONSE skbuff and putting it onto the receive
queue for the I/O thread to collect.  We put it on the front of the queue
as we've already received the packet for it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    2 ++
 net/rxrpc/ar-internal.h      |    1 +
 net/rxrpc/conn_event.c       |   46 +++++++++++++++++++++++++++++-------------
 net/rxrpc/io_thread.c        |    5 +++++
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 76d0bdc3e170..f4a1ca03fb1a 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -133,6 +133,7 @@
 #define rxrpc_skb_traces \
 	EM(rxrpc_skb_eaten_by_unshare,		"ETN unshare  ") \
 	EM(rxrpc_skb_eaten_by_unshare_nomem,	"ETN unshar-nm") \
+	EM(rxrpc_skb_get_conn_secured,		"GET conn-secd") \
 	EM(rxrpc_skb_get_conn_work,		"GET conn-work") \
 	EM(rxrpc_skb_get_local_work,		"GET locl-work") \
 	EM(rxrpc_skb_get_reject_work,		"GET rej-work ") \
@@ -142,6 +143,7 @@
 	EM(rxrpc_skb_new_error_report,		"NEW error-rpt") \
 	EM(rxrpc_skb_new_jumbo_subpacket,	"NEW jumbo-sub") \
 	EM(rxrpc_skb_new_unshared,		"NEW unshared ") \
+	EM(rxrpc_skb_put_conn_secured,		"PUT conn-secd") \
 	EM(rxrpc_skb_put_conn_work,		"PUT conn-work") \
 	EM(rxrpc_skb_put_error_report,		"PUT error-rep") \
 	EM(rxrpc_skb_put_input,			"PUT input    ") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 4f4dc3d49c35..508b6e2c26e1 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -38,6 +38,7 @@ struct rxrpc_txbuf;
 enum rxrpc_skb_mark {
 	RXRPC_SKB_MARK_PACKET,		/* Received packet */
 	RXRPC_SKB_MARK_ERROR,		/* Error notification */
+	RXRPC_SKB_MARK_SERVICE_CONN_SECURED, /* Service connection response has been verified */
 	RXRPC_SKB_MARK_REJECT_BUSY,	/* Reject with BUSY */
 	RXRPC_SKB_MARK_REJECT_ABORT,	/* Reject with ABORT (code in skb->priority) */
 };
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 21c826161741..434fa7e2f515 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -248,7 +248,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			       struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	int loop, ret;
+	int ret;
 
 	if (conn->state == RXRPC_CONN_ABORTED)
 		return -ECONNABORTED;
@@ -269,22 +269,21 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		if (ret < 0)
 			return ret;
 
-		spin_lock(&conn->bundle->channel_lock);
 		spin_lock(&conn->state_lock);
+		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING)
+			smp_store_release(&conn->state, RXRPC_CONN_SERVICE);
+		spin_unlock(&conn->state_lock);
 
-		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
-			conn->state = RXRPC_CONN_SERVICE;
-			spin_unlock(&conn->state_lock);
-			for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
-				rxrpc_call_is_secure(
-					rcu_dereference_protected(
-						conn->channels[loop].call,
-						lockdep_is_held(&conn->bundle->channel_lock)));
-		} else {
-			spin_unlock(&conn->state_lock);
+		if (conn->state == RXRPC_CONN_SERVICE) {
+			/* Offload call state flipping to the I/O thread.  As
+			 * we've already received the packet, put it on the
+			 * front of the queue.
+			 */
+			skb->mark = RXRPC_SKB_MARK_SERVICE_CONN_SECURED;
+			rxrpc_get_skb(skb, rxrpc_skb_get_conn_secured);
+			skb_queue_head(&conn->local->rx_queue, skb);
+			rxrpc_wake_up_io_thread(conn->local);
 		}
-
-		spin_unlock(&conn->bundle->channel_lock);
 		return 0;
 
 	default:
@@ -442,9 +441,28 @@ bool rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
  */
 void rxrpc_input_conn_event(struct rxrpc_connection *conn, struct sk_buff *skb)
 {
+	unsigned int loop;
+
 	if (test_and_clear_bit(RXRPC_CONN_EV_ABORT_CALLS, &conn->events))
 		rxrpc_abort_calls(conn);
 
+	switch (skb->mark) {
+	case RXRPC_SKB_MARK_SERVICE_CONN_SECURED:
+		if (conn->state != RXRPC_CONN_SERVICE)
+			break;
+
+		spin_lock(&conn->bundle->channel_lock);
+
+		for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
+			rxrpc_call_is_secure(
+				rcu_dereference_protected(
+					conn->channels[loop].call,
+					lockdep_is_held(&conn->bundle->channel_lock)));
+
+		spin_unlock(&conn->bundle->channel_lock);
+		break;
+	}
+
 	/* Process delayed ACKs whose time has come. */
 	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
 		rxrpc_process_delayed_final_acks(conn, false);
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index f709f6f109db..a89f8ba465b1 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -455,6 +455,7 @@ int rxrpc_io_thread(void *data)
 
 		/* Process received packets and errors. */
 		if ((skb = __skb_dequeue(&rx_queue))) {
+			struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 			switch (skb->mark) {
 			case RXRPC_SKB_MARK_PACKET:
 				skb->priority = 0;
@@ -467,6 +468,10 @@ int rxrpc_io_thread(void *data)
 				rxrpc_input_error(local, skb);
 				rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 				break;
+			case RXRPC_SKB_MARK_SERVICE_CONN_SECURED:
+				rxrpc_input_conn_event(sp->conn, skb);
+				rxrpc_put_connection(sp->conn, rxrpc_conn_put_poke);
+				rxrpc_free_skb(skb, rxrpc_skb_put_conn_secured);
 				break;
 			default:
 				WARN_ON_ONCE(1);


