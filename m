Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67B9644892
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiLFQBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiLFQBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6332E6A8
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqloZNwxTXUS3t/wAesCkZJpHZe7dBojOkrMlTPIvcM=;
        b=Blm7WwAeTRKX7IRJObIbU+RjIjBHEKCpifq3Y/XDAi6iH5Hc2o/Wb9SRLuojdahx4mpi7t
        Fvh5vHSI093F1AvjYo4ecm1GTeaWfjmGz7phUAdVoS3r1+tzYbGmG25moqiyni5iJ2mfwD
        1t4axnDg7jEzX8b8Us/GdzFT3ZjLa/c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-qsStTfa8PRS8yQToYP2zqA-1; Tue, 06 Dec 2022 11:00:04 -0500
X-MC-Unique: qsStTfa8PRS8yQToYP2zqA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53A363810D39;
        Tue,  6 Dec 2022 16:00:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95CC6492B07;
        Tue,  6 Dec 2022 16:00:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 10/32] rxrpc: Generate extra pings for RTT during
 heavy-receive call
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:59:59 +0000
Message-ID: <167034239985.1105287.15155402480779520338.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

 include/trace/events/rxrpc.h |    3 ++-
 net/rxrpc/call_event.c       |   15 ++++++++++++---
 net/rxrpc/output.c           |    7 +++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 49a0f799cdef..c47954aea7be 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -258,11 +258,12 @@
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
index bf6858e69187..768bc8a63038 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -460,9 +460,18 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
 			       rxrpc_propose_ack_rx_idle);
 
-	if (atomic_read(&call->ackr_nr_unacked) > 2)
-		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
-			       rxrpc_propose_ack_input_data);
+	if (atomic_read(&call->ackr_nr_unacked) > 2) {
+		if (call->peer->rtt_count < 3)
+			rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+				       rxrpc_propose_ack_ping_for_rtt);
+		else if(ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000),
+				     ktime_get_real()))
+			rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+				       rxrpc_propose_ack_ping_for_old_rtt);
+		else
+			rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
+				       rxrpc_propose_ack_input_data);
+	}
 
 	/* Make sure the timer is restarted */
 	if (call->state != RXRPC_CALL_COMPLETE) {
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 3d8c9f830ee0..2a44958b1bc7 100644
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
 
 	if (call->state < RXRPC_CALL_COMPLETE) {


