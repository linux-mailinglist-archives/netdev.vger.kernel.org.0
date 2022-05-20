Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2F52F0CB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351803AbiETQep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351745AbiETQe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DACB8185401
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653064460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rLmx1GCnM/YKpdBUX7RMpFPLHBpyKfss7iMFqoE+U7c=;
        b=WWm7Ij3QxdhYO/T6ja3/nOGtmV86rNzzMKmSlXjgxfdCasvRfc5TnH1w9IUv57CBCOPbM8
        UiD2uBMT0hEFoDxCrKQVAPlPl+T5K7LDL5c8TQWcqSCeRa5N5aKTDuTSpnsMqD0UGQGfrk
        neynxcroohD68MsKwjb4fLhk/lIDUHo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-qRpXM2oEMu-MrlOdfNHm7A-1; Fri, 20 May 2022 12:34:17 -0400
X-MC-Unique: qRpXM2oEMu-MrlOdfNHm7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B209238041D3;
        Fri, 20 May 2022 16:34:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 078371410DD5;
        Fri, 20 May 2022 16:34:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/6] rxrpc: Don't let ack.previousPacket regress
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:34:15 +0100
Message-ID: <165306445535.34086.14676907429022402412.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
References: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previousPacket field in the rx ACK packet should never go backwards -
it's now the highest DATA sequence number received, not the last on
received (it used to be used for out of sequence detection).

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    4 ++--
 net/rxrpc/input.c       |    4 +++-
 net/rxrpc/output.c      |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 9a9688c41d4d..8465985a4cb6 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -679,7 +679,7 @@ struct rxrpc_call {
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
 
@@ -694,7 +694,7 @@ struct rxrpc_call {
 	/* Transmission-phase ACK management (ACKs we've received). */
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
 	rxrpc_seq_t		acks_first_seq;	/* first sequence number received */
-	rxrpc_seq_t		acks_prev_seq;	/* previous sequence number received */
+	rxrpc_seq_t		acks_prev_seq;	/* Highest previousPacket received */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index f11673cda217..2e61545ad8ca 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -453,7 +453,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	    !rxrpc_receiving_reply(call))
 		goto unlock;
 
-	call->ackr_prev_seq = seq0;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 
 	nr_subpackets = sp->nr_subpackets;
@@ -534,6 +533,9 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			ack_serial = serial;
 		}
 
+		if (after(seq0, call->ackr_highest_seq))
+			call->ackr_highest_seq = seq0;
+
 		/* Queue the packet.  We use a couple of memory barriers here as need
 		 * to make sure that rx_top is perceived to be set after the buffer
 		 * pointer and that the buffer pointer is set after the annotation and
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index a45c83f22236..46aae9b7006f 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -89,7 +89,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	pkt->ack.bufferSpace	= htons(8);
 	pkt->ack.maxSkew	= htons(0);
 	pkt->ack.firstPacket	= htonl(hard_ack + 1);
-	pkt->ack.previousPacket	= htonl(call->ackr_prev_seq);
+	pkt->ack.previousPacket	= htonl(call->ackr_highest_seq);
 	pkt->ack.serial		= htonl(serial);
 	pkt->ack.reason		= reason;
 	pkt->ack.nAcks		= top - hard_ack;


