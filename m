Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A051B621F05
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKHWUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiKHWTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B81F1DA66
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilkVlWMZ66o0Mi1eOm932j6aT+E2f79QV8a2HjhcgHQ=;
        b=cL+d8TTNQlaYKexIvU0LLzUJYlOYTVHXFupfsRtyH9yA9zafN1Kpm+fZEPv5hKIVX1055Y
        L7MfFRuhtbtmNlBF2ZMg9gIjazOSfulYrmg/PjubORa8tK20WSAtPkqXvfOLhdnpFs5y/s
        NJDqZ/aohoIiZwkXq3NE1Zqbz2i9Nvo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-9a6O_cOiPgmu_5WapqEkKg-1; Tue, 08 Nov 2022 17:18:32 -0500
X-MC-Unique: 9a6O_cOiPgmu_5WapqEkKg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC2312A59552;
        Tue,  8 Nov 2022 22:18:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36A6C492B13;
        Tue,  8 Nov 2022 22:18:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 06/26] rxrpc: Record statistics about ACK types
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:30 +0000
Message-ID: <166794591054.2389296.17729121265163888645.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
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

Record statistics about the different types of ACKs that have been
transmitted and received and the number of ACKs that have been filled out
and transmitted or that have been skipped.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    6 ++++++
 net/rxrpc/call_event.c  |    2 ++
 net/rxrpc/input.c       |    1 +
 net/rxrpc/output.c      |    7 ++++++-
 net/rxrpc/proc.c        |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ed406a5f939b..8ed707a11d43 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -101,6 +101,12 @@ struct rxrpc_net {
 	atomic_t		stat_rx_data;
 	atomic_t		stat_rx_data_reqack;
 	atomic_t		stat_rx_data_jumbo;
+
+	atomic_t		stat_tx_ack_fill;
+	atomic_t		stat_tx_ack_send;
+	atomic_t		stat_tx_ack_skip;
+	atomic_t		stat_tx_acks[256];
+	atomic_t		stat_rx_acks[256];
 };
 
 /*
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index c5b3ae1fe80b..70f70a0393f7 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -50,6 +50,8 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 	unsigned long expiry = rxrpc_soft_ack_delay;
 	s8 prior = rxrpc_ack_priority[ack_reason];
 
+	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
+
 	/* Pings are handled specially because we don't want to accidentally
 	 * lose a ping response by subsuming it into a ping.
 	 */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index e7586d5ea2c3..7810b7d4f871 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -888,6 +888,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	trace_rxrpc_rx_ack(call, ack_serial, acked_serial,
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
+	rxrpc_inc_stat(call->rxnet, stat_rx_acks[buf.ack.reason]);
 
 	switch (buf.ack.reason) {
 	case RXRPC_ACK_PING_RESPONSE:
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 8fddad2f63fc..f350d39e3a60 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -83,8 +83,12 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	tmp = atomic_xchg(&call->ackr_nr_unacked, 0);
 	tmp |= atomic_xchg(&call->ackr_nr_consumed, 0);
 	if (!tmp && (reason == RXRPC_ACK_DELAY ||
-		     reason == RXRPC_ACK_IDLE))
+		     reason == RXRPC_ACK_IDLE)) {
+		rxrpc_inc_stat(call->rxnet, stat_tx_ack_skip);
 		return 0;
+	}
+
+	rxrpc_inc_stat(call->rxnet, stat_tx_ack_fill);
 
 	/* Barrier against rxrpc_input_data(). */
 	serial = call->ackr_serial;
@@ -253,6 +257,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	if (ping)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_ping);
 
+	rxrpc_inc_stat(call->rxnet, stat_tx_ack_send);
 	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
 	conn->params.peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 102744411932..488c403f1d33 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -418,6 +418,33 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&rxnet->stat_rx_data),
 		   atomic_read(&rxnet->stat_rx_data_reqack),
 		   atomic_read(&rxnet->stat_rx_data_jumbo));
+	seq_printf(seq,
+		   "Ack      : fill=%u send=%u skip=%u\n",
+		   atomic_read(&rxnet->stat_tx_ack_fill),
+		   atomic_read(&rxnet->stat_tx_ack_send),
+		   atomic_read(&rxnet->stat_tx_ack_skip));
+	seq_printf(seq,
+		   "Ack-Tx   : req=%u dup=%u oos=%u exw=%u nos=%u png=%u prs=%u dly=%u idl=%u\n",
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_REQUESTED]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_DUPLICATE]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_OUT_OF_SEQUENCE]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_EXCEEDS_WINDOW]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_NOSPACE]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_PING]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_PING_RESPONSE]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_DELAY]),
+		   atomic_read(&rxnet->stat_tx_acks[RXRPC_ACK_IDLE]));
+	seq_printf(seq,
+		   "Ack-Rx   : req=%u dup=%u oos=%u exw=%u nos=%u png=%u prs=%u dly=%u idl=%u\n",
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_REQUESTED]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_DUPLICATE]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_OUT_OF_SEQUENCE]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_EXCEEDS_WINDOW]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_NOSPACE]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_PING]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_PING_RESPONSE]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_DELAY]),
+		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_IDLE]));
 	seq_printf(seq,
 		   "Buffers  : txb=%u rxb=%u\n",
 		   atomic_read(&rxrpc_n_tx_skbs),
@@ -443,5 +470,11 @@ int rxrpc_stats_clear(struct file *file, char *buf, size_t size)
 	atomic_set(&rxnet->stat_rx_data, 0);
 	atomic_set(&rxnet->stat_rx_data_reqack, 0);
 	atomic_set(&rxnet->stat_rx_data_jumbo, 0);
+
+	atomic_set(&rxnet->stat_tx_ack_fill, 0);
+	atomic_set(&rxnet->stat_tx_ack_send, 0);
+	atomic_set(&rxnet->stat_tx_ack_skip, 0);
+	memset(&rxnet->stat_tx_acks, 0, sizeof(rxnet->stat_tx_acks));
+	memset(&rxnet->stat_rx_acks, 0, sizeof(rxnet->stat_rx_acks));
 	return size;
 }


