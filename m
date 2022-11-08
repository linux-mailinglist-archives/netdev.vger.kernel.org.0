Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87FE621F30
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiKHWXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKHWWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6955657E2
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSTDcTX8F6XRImbRoVSwdltq/9P30uhhtl/SBijouH8=;
        b=gZJ04ATtO5UykP1ac3HUY7w4R6elIobg/y6EJSqSASCtMsHEJI5bZ5JbWqvGNVhurFHV12
        +7oKswFma9B1pC+1e3MvJNUDOk9Ph7NS87Yjs/XWoyrNug7/XzIRGA/ao1FhHieNPxG3mt
        xVp0qHRisc/g8C6rIPPHgAQJG2rQpQ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-aKHobH48NHqPO0rd5qZNuA-1; Tue, 08 Nov 2022 17:20:28 -0500
X-MC-Unique: aKHobH48NHqPO0rd5qZNuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4556F833AEE;
        Tue,  8 Nov 2022 22:20:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAB392166B2C;
        Tue,  8 Nov 2022 22:20:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 24/26] rxrpc: Remove the rxtx ring
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:27 +0000
Message-ID: <166794602708.2389296.15633178516565768516.stgit@warthog.procyon.org.uk>
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

The Rx/Tx ring is no longer used, so remove it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |   15 ---------------
 net/rxrpc/call_object.c |   24 ------------------------
 2 files changed, 39 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 168d03b56ada..775eb91aabb2 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -617,21 +617,6 @@ struct rxrpc_call {
 	unsigned short		rx_pkt_offset;	/* Current recvmsg packet offset */
 	unsigned short		rx_pkt_len;	/* Current recvmsg packet len */
 
-	/* Rx/Tx circular buffer, depending on phase.
-	 *
-	 * In the Rx phase, packets are annotated with 0 or the number of the
-	 * segment of a jumbo packet each buffer refers to.  There can be up to
-	 * 47 segments in a maximum-size UDP packet.
-	 *
-	 * In the Tx phase, packets are annotated with which buffers have been
-	 * acked.
-	 */
-#define RXRPC_RXTX_BUFF_SIZE	64
-#define RXRPC_RXTX_BUFF_MASK	(RXRPC_RXTX_BUFF_SIZE - 1)
-#define RXRPC_INIT_RX_WINDOW_SIZE 63
-	struct sk_buff		**rxtx_buffer;
-	u8			*rxtx_annotations;
-
 	/* Transmitted data tracking. */
 	spinlock_t		tx_lock;	/* Transmit queue lock */
 	struct list_head	tx_buffer;	/* Buffer of transmissible packets */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 91771031ad3c..aa19daaa487b 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -129,16 +129,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	if (!call)
 		return NULL;
 
-	call->rxtx_buffer = kcalloc(RXRPC_RXTX_BUFF_SIZE,
-				    sizeof(struct sk_buff *),
-				    gfp);
-	if (!call->rxtx_buffer)
-		goto nomem;
-
-	call->rxtx_annotations = kcalloc(RXRPC_RXTX_BUFF_SIZE, sizeof(u8), gfp);
-	if (!call->rxtx_annotations)
-		goto nomem_2;
-
 	mutex_init(&call->user_mutex);
 
 	/* Prevent lockdep reporting a deadlock false positive between the afs
@@ -183,12 +173,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->rtt_avail = RXRPC_CALL_RTT_AVAIL_MASK;
 	atomic_inc(&rxnet->nr_calls);
 	return call;
-
-nomem_2:
-	kfree(call->rxtx_buffer);
-nomem:
-	kmem_cache_free(rxrpc_call_jar, call);
-	return NULL;
 }
 
 /*
@@ -516,12 +500,6 @@ void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
  */
 static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 {
-	int i;
-
-	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++) {
-		rxrpc_free_skb(call->rxtx_buffer[i], rxrpc_skb_cleaned);
-		call->rxtx_buffer[i] = NULL;
-	}
 	skb_queue_purge(&call->recvmsg_queue);
 	skb_queue_purge(&call->rx_oos_queue);
 }
@@ -658,8 +636,6 @@ static void rxrpc_destroy_call(struct work_struct *work)
 
 	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
-	kfree(call->rxtx_buffer);
-	kfree(call->rxtx_annotations);
 	kmem_cache_free(rxrpc_call_jar, call);
 	if (atomic_dec_and_test(&rxnet->nr_calls))
 		wake_up_var(&rxnet->nr_calls);


