Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4901363DB50
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiK3RA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiK3Q7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:59:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276D594900
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dneFRaj6mh/2RNj3JxJnemRTBaWF2WqdAUXcna3A8HA=;
        b=bMBtuFe3fUY0Qdni6dxd18M50JdyAHbMrtOvTcTev8y0Vw9TykKvva2wJVmIkKeheuiol+
        RS3mBfi+GdYJGfAHpCIxav5k5CBKhN2USpAbYWadEWy7Njuqj0HqZIB0HcSx2Sofyga6vY
        LUL2IQdrzIDujNZrnM7QSKJkZn2ymC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-0KhjtdIiNta9JTGnMNrC0w-1; Wed, 30 Nov 2022 11:57:23 -0500
X-MC-Unique: 0KhjtdIiNta9JTGnMNrC0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BB8F185A792;
        Wed, 30 Nov 2022 16:57:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BC5A40C83D9;
        Wed, 30 Nov 2022 16:57:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 21/35] rxrpc: Remove call->input_lock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:57:19 +0000
Message-ID: <166982743990.621383.18023557629272593979.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove call->input_lock as it was only necessary to serialise access to the
state stored in the rxrpc_call struct by simultaneous softirq handlers
presenting received packets.  They now dump the packets in a queue and a
single process-context handler now processes them.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    1 -
 net/rxrpc/call_object.c |    1 -
 net/rxrpc/input.c       |   22 +++++-----------------
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 566377c64184..654e9dab107c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -657,7 +657,6 @@ struct rxrpc_call {
 	rxrpc_seq_t		rx_consumed;	/* Highest packet consumed */
 	rxrpc_serial_t		rx_serial;	/* Highest serial received for this call */
 	u8			rx_winsize;	/* Size of Rx window */
-	spinlock_t		input_lock;	/* Lock for packet input to this call */
 
 	/* TCP-style slow-start congestion control [RFC5681].  Since the SMSS
 	 * is fixed, we keep these numbers in terms of segments (ie. DATA
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 57c8d4cc900a..f6d1b3a6f8c6 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -143,7 +143,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->tx_lock);
-	spin_lock_init(&call->input_lock);
 	spin_lock_init(&call->acks_ack_lock);
 	rwlock_init(&call->state_lock);
 	refcount_set(&call->ref, 1);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index f4f6f3c62d03..13c52145a926 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -588,8 +588,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		}
 	}
 
-	spin_lock(&call->input_lock);
-
 	/* Received data implicitly ACKs all of the request packets we sent
 	 * when we're acting as a client.
 	 */
@@ -607,8 +605,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 out:
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
-
-	spin_unlock(&call->input_lock);
 	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	_leave(" [queued]");
 }
@@ -811,7 +807,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	offset = sizeof(struct rxrpc_wire_header);
 	if (skb_copy_bits(skb, offset, &ack, sizeof(ack)) < 0) {
 		rxrpc_proto_abort("XAK", call, 0);
-		goto out_not_locked;
+		goto out;
 	}
 	offset += sizeof(ack);
 
@@ -863,7 +859,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
-		return;
+		goto out;
 	}
 
 	/* If we get an OUT_OF_SEQUENCE ACK from the server, that can also
@@ -877,7 +873,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
-		return;
+		goto out;
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
@@ -885,7 +881,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->acks_first_seq,
 					   prev_pkt, call->acks_prev_seq);
-		goto out_not_locked;
+		goto out;
 	}
 
 	info.rxMTU = 0;
@@ -893,14 +889,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	if (skb->len >= ioffset + sizeof(info) &&
 	    skb_copy_bits(skb, ioffset, &info, sizeof(info)) < 0) {
 		rxrpc_proto_abort("XAI", call, 0);
-		goto out_not_locked;
+		goto out;
 	}
 
 	if (nr_acks > 0)
 		skb_condense(skb);
 
-	spin_lock(&call->input_lock);
-
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
@@ -992,8 +986,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	rxrpc_congestion_management(call, skb, &summary, acked_serial);
 out:
-	spin_unlock(&call->input_lock);
-out_not_locked:
 	rxrpc_free_skb(skb_put, rxrpc_skb_put_input);
 	rxrpc_free_skb(skb_old, rxrpc_skb_put_ack);
 }
@@ -1005,12 +997,8 @@ static void rxrpc_input_ackall(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_ack_summary summary = { 0 };
 
-	spin_lock(&call->input_lock);
-
 	if (rxrpc_rotate_tx_window(call, call->tx_top, &summary))
 		rxrpc_end_tx_phase(call, false, "ETL");
-
-	spin_unlock(&call->input_lock);
 }
 
 /*


