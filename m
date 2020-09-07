Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F86526013C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgIGRCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgIGQdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4502121775;
        Mon,  7 Sep 2020 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496415;
        bh=lixp8BxmKE9x3A7XjRdy/g2rDI2HUaEJA24QkMcIIMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pw+eNtBLBg5aM/VA2AjnAMd+hh6Hlz7/iwMVIoAGQ2wKcNrwbZuBi7OReIj58EsGC
         sJB5M01vKRYLn1dpBtyAKXGbwQ0f5FwrOlnN6jxfVBxD0ASL5qqRgIQics5xqgPrJ7
         XQojVSwPQuF096XvxGO7bAI3nJXn9Gkro7EPSzN8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/43] rxrpc: Keep the ACK serial in a var in rxrpc_input_ack()
Date:   Mon,  7 Sep 2020 12:32:50 -0400
Message-Id: <20200907163329.1280888-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 68528d937dcd675e79973061c1a314db598162d1 ]

Keep the ACK serial number in a variable in rxrpc_input_ack() as it's used
frequently.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/input.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 22dec6049e1bb..6cace43b217ee 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -844,7 +844,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		struct rxrpc_ackinfo info;
 		u8 acks[RXRPC_MAXACKS];
 	} buf;
-	rxrpc_serial_t acked_serial;
+	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
 
@@ -857,6 +857,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 	offset += sizeof(buf.ack);
 
+	ack_serial = sp->hdr.serial;
 	acked_serial = ntohl(buf.ack.serial);
 	first_soft_ack = ntohl(buf.ack.firstPacket);
 	prev_pkt = ntohl(buf.ack.previousPacket);
@@ -865,31 +866,31 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	summary.ack_reason = (buf.ack.reason < RXRPC_ACK__INVALID ?
 			      buf.ack.reason : RXRPC_ACK__INVALID);
 
-	trace_rxrpc_rx_ack(call, sp->hdr.serial, acked_serial,
+	trace_rxrpc_rx_ack(call, ack_serial, acked_serial,
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
 
 	if (buf.ack.reason == RXRPC_ACK_PING_RESPONSE)
 		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
-					  sp->hdr.serial);
+					  ack_serial);
 	if (buf.ack.reason == RXRPC_ACK_REQUESTED)
 		rxrpc_input_requested_ack(call, skb->tstamp, acked_serial,
-					  sp->hdr.serial);
+					  ack_serial);
 
 	if (buf.ack.reason == RXRPC_ACK_PING) {
-		_proto("Rx ACK %%%u PING Request", sp->hdr.serial);
+		_proto("Rx ACK %%%u PING Request", ack_serial);
 		rxrpc_propose_ACK(call, RXRPC_ACK_PING_RESPONSE,
-				  sp->hdr.serial, true, true,
+				  ack_serial, true, true,
 				  rxrpc_propose_ack_respond_to_ping);
 	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
 		rxrpc_propose_ACK(call, RXRPC_ACK_REQUESTED,
-				  sp->hdr.serial, true, true,
+				  ack_serial, true, true,
 				  rxrpc_propose_ack_respond_to_ack);
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
 		return;
@@ -905,7 +906,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
 		goto out;
@@ -965,7 +966,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    RXRPC_TX_ANNO_LAST &&
 	    summary.nr_acks == call->tx_top - hard_ack &&
 	    rxrpc_is_client_call(call))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, ack_serial,
 				  false, true,
 				  rxrpc_propose_ack_ping_for_lost_reply);
 
-- 
2.25.1

