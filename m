Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA8D621F2B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKHWXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiKHWWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6092EA5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ssiSL57+Arnz0LznRSBpqep6+L7Gbhd0GAZEbTzt4Ic=;
        b=SAp+ZVAfONFM4ddFOUE1Rmrw5wMhwch68oVxLi3CYrgqwo1A10r3Z1qT3VimLM/QBlTan0
        tjwLKJT4JDfp5vLSFY2YrcUvUYa9fzQf+eu+RgXNV7Gg0J+Ib23nLDa9Csokf4Yc0qHd+c
        wzgmLmMuhowDYS7ykY0lUYNej4XdLus=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-bY7kjxcCNKG46LLNWrvCDg-1; Tue, 08 Nov 2022 17:20:15 -0500
X-MC-Unique: bY7kjxcCNKG46LLNWrvCDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F92B299E753;
        Tue,  8 Nov 2022 22:20:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE8A540C947B;
        Tue,  8 Nov 2022 22:20:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 22/26] rxrpc: Remove call->lock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:14 +0000
Message-ID: <166794601410.2389296.15345861353801742959.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call->lock is no longer necessary, so remove it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    1 -
 net/rxrpc/call_event.c  |   22 ++--------------------
 net/rxrpc/call_object.c |    3 ---
 net/rxrpc/input.c       |    3 ---
 net/rxrpc/output.c      |    6 +-----
 5 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index d7aebe82e17c..5ec30e84360b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -601,7 +601,6 @@ struct rxrpc_call {
 	unsigned long		user_call_ID;	/* user-defined call ID */
 	unsigned long		flags;
 	unsigned long		events;
-	spinlock_t		lock;
 	spinlock_t		notify_lock;	/* Kernel notification lock */
 	rwlock_t		state_lock;	/* lock for state transition */
 	u32			abort_code;	/* Local/remote abort code */
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 3c37b280eb20..dbfaf8170929 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -26,24 +26,19 @@ void rxrpc_propose_ping(struct rxrpc_call *call, u32 serial,
 	unsigned long now = jiffies;
 	unsigned long ping_at = now + rxrpc_idle_ack_delay;
 
-	spin_lock_bh(&call->lock);
-
 	if (time_before(ping_at, call->ping_at)) {
 		WRITE_ONCE(call->ping_at, ping_at);
 		rxrpc_reduce_call_timer(call, ping_at, now,
 					rxrpc_timer_set_for_ping);
 		trace_rxrpc_propose_ack(call, why, RXRPC_ACK_PING, serial);
 	}
-
-	spin_unlock_bh(&call->lock);
 }
 
 /*
  * Propose a DELAY ACK be sent in the future.
  */
-static void __rxrpc_propose_delay_ACK(struct rxrpc_call *call,
-				      rxrpc_serial_t serial,
-				      enum rxrpc_propose_ack_trace why)
+void rxrpc_propose_delay_ACK(struct rxrpc_call *call, rxrpc_serial_t serial,
+			     enum rxrpc_propose_ack_trace why)
 {
 	unsigned long expiry = rxrpc_soft_ack_delay;
 	unsigned long now = jiffies, ack_at;
@@ -68,17 +63,6 @@ static void __rxrpc_propose_delay_ACK(struct rxrpc_call *call,
 	trace_rxrpc_propose_ack(call, why, RXRPC_ACK_DELAY, serial);
 }
 
-/*
- * Propose a DELAY ACK be sent, locking the call structure
- */
-void rxrpc_propose_delay_ACK(struct rxrpc_call *call, rxrpc_serial_t  serial,
-			     enum rxrpc_propose_ack_trace why)
-{
-	spin_lock_bh(&call->lock);
-	__rxrpc_propose_delay_ACK(call, serial, why);
-	spin_unlock_bh(&call->lock);
-}
-
 /*
  * Queue an ACK for immediate transmission.
  */
@@ -204,10 +188,8 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	 * retransmitting data.
 	 */
 	if (list_empty(&retrans_queue)) {
-		spin_lock_bh(&call->lock);
 		rxrpc_reduce_call_timer(call, resend_at, now_j,
 					rxrpc_timer_set_for_resend);
-		spin_unlock_bh(&call->lock);
 		ack_ts = ktime_sub(now, call->acks_latest_ts);
 		if (ktime_to_us(ack_ts) < (call->peer->srtt_us >> 3))
 			goto out;
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index ed5f6f0e4286..a3ae2ab45f9e 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -159,7 +159,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	skb_queue_head_init(&call->recvmsg_queue);
 	skb_queue_head_init(&call->rx_oos_queue);
 	init_waitqueue_head(&call->waitq);
-	spin_lock_init(&call->lock);
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->tx_lock);
 	spin_lock_init(&call->input_lock);
@@ -543,10 +542,8 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
-	spin_lock_bh(&call->lock);
 	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
 		BUG();
-	spin_unlock_bh(&call->lock);
 
 	rxrpc_put_call_slot(call);
 	rxrpc_delete_call_timer(call);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index b1f7debd4f3e..e6e1267915de 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -279,9 +279,6 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 	rxrpc_seq_t top = READ_ONCE(call->tx_top);
 
 	if (call->ackr_reason) {
-		spin_lock_bh(&call->lock);
-		call->ackr_reason = 0;
-		spin_unlock_bh(&call->lock);
 		now = jiffies;
 		timo = now + MAX_JIFFY_OFFSET;
 		WRITE_ONCE(call->resend_at, timo);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index e2f501cef040..2c3f7e4e30d7 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -229,13 +229,9 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	if (txb->ack.reason == RXRPC_ACK_IDLE)
 		clear_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags);
 
-	spin_lock_bh(&call->lock);
 	n = rxrpc_fill_out_ack(conn, call, txb);
-	spin_unlock_bh(&call->lock);
-	if (n == 0) {
-		kfree(pkt);
+	if (n == 0)
 		return 0;
-	}
 
 	iov[0].iov_base	= &txb->wire;
 	iov[0].iov_len	= sizeof(txb->wire) + sizeof(txb->ack) + n;


