Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C2C683375
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjAaROD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjAaRN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:13:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE6A4C6F8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mifQreM88lXTcEbP4AVoTmR0dVlc1qk46MxihoGDU2g=;
        b=PTBkL7is+BBST6/7j39Af2XzGg36Kdd1PnYTLTaD7SFmPEighdS4soAMhyAghGR108/NbQ
        iBFoamTVN1bofkFHspV55+j0ccB10bnoAUPS6G78R/AFtU6LLgFl3xSuuWkXa3lkeKbkpB
        8vswi6EVijEqDYi1L1Hnh5IGT5KkJ8M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-eyAK_msJNmCOEdl9MSFsLg-1; Tue, 31 Jan 2023 12:12:46 -0500
X-MC-Unique: eyAK_msJNmCOEdl9MSFsLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB9A318E0056;
        Tue, 31 Jan 2023 17:12:41 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF5531431C5D;
        Tue, 31 Jan 2023 17:12:40 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/13] rxrpc: Generate extra pings for RTT during heavy-receive call
Date:   Tue, 31 Jan 2023 17:12:20 +0000
Message-Id: <20230131171227.3912130-7-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

When doing a call that has a single transmitted data packet and a massive
amount of received data packets, we only ping for one RTT sample, which
means we don't get a good reading on it.

Fix this by converting occasional IDLE ACKs into PING ACKs to elicit a
response.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 include/trace/events/rxrpc.h |  3 ++-
 net/rxrpc/call_event.c       | 15 ++++++++++++---
 net/rxrpc/output.c           |  7 +++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index cdcadb1345dc..450b8f345814 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -360,11 +360,12 @@
 	EM(rxrpc_propose_ack_client_tx_end,	"ClTxEnd") \
 	EM(rxrpc_propose_ack_input_data,	"DataIn ") \
 	EM(rxrpc_propose_ack_input_data_hole,	"DataInH") \
-	EM(rxrpc_propose_ack_ping_for_check_life, "ChkLife") \
 	EM(rxrpc_propose_ack_ping_for_keepalive, "KeepAlv") \
 	EM(rxrpc_propose_ack_ping_for_lost_ack,	"LostAck") \
 	EM(rxrpc_propose_ack_ping_for_lost_reply, "LostRpl") \
+	EM(rxrpc_propose_ack_ping_for_old_rtt,	"OldRtt ") \
 	EM(rxrpc_propose_ack_ping_for_params,	"Params ") \
+	EM(rxrpc_propose_ack_ping_for_rtt,	"Rtt    ") \
 	EM(rxrpc_propose_ack_processing_op,	"ProcOp ") \
 	EM(rxrpc_propose_ack_respond_to_ack,	"Rsp2Ack") \
 	EM(rxrpc_propose_ack_respond_to_ping,	"Rsp2Png") \
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 1abdef15debc..cf9799be4286 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -498,9 +498,18 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
 			       rxrpc_propose_ack_rx_idle);
 
-	if (atomic_read(&call->ackr_nr_unacked) > 2)
-		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
-			       rxrpc_propose_ack_input_data);
+	if (atomic_read(&call->ackr_nr_unacked) > 2) {
+		if (call->peer->rtt_count < 3)
+			rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+				       rxrpc_propose_ack_ping_for_rtt);
+		else if (ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000),
+				      ktime_get_real()))
+			rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+				       rxrpc_propose_ack_ping_for_old_rtt);
+		else
+			rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
+				       rxrpc_propose_ack_input_data);
+	}
 
 	/* Make sure the timer is restarted */
 	if (!__rxrpc_call_is_complete(call)) {
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index a9746be29634..98b5d0db7761 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -253,12 +253,15 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
 	call->peer->last_tx_at = ktime_get_seconds();
-	if (ret < 0)
+	if (ret < 0) {
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_ack);
-	else
+	} else {
 		trace_rxrpc_tx_packet(call->debug_id, &txb->wire,
 				      rxrpc_tx_point_call_ack);
+		if (txb->wire.flags & RXRPC_REQUEST_ACK)
+			call->peer->rtt_last_req = ktime_get_real();
+	}
 	rxrpc_tx_backoff(call, ret);
 
 	if (!__rxrpc_call_is_complete(call)) {

