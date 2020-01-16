Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4313F624
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437226AbgAPTBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388733AbgAPRFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D6AD20730;
        Thu, 16 Jan 2020 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194347;
        bh=CG0j5CIjKNoT9C0veCZho73jXHeOkr6pOUdwpcE3xic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PS4as2vySiimtkRm/RTXAH7MkR5Ndw7Ff7NhMObimaa22ALkrF+CY4hyNz/3yvWtc
         xJoiXJ1IVI2iG2Y6C4cVTzBlgmoQ0+HdHq1ZfBK5ijFok6SiY1MToAwd2syM2jOb1k
         fCdyd1X/UDRnM+NSb2rQ/WtB2sCfuedIix0drRBQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Altman <jaltman@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 288/671] rxrpc: Fix detection of out of order acks
Date:   Thu, 16 Jan 2020 11:58:46 -0500
Message-Id: <20200116170509.12787-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Altman <jaltman@auristor.com>

[ Upstream commit 1a2391c30c0b9d041bc340f68df81d49c53546cc ]

The rxrpc packet serial number cannot be safely used to compute out of
order ack packets for several reasons:

 1. The allocation of serial numbers cannot be assumed to imply the order
    by which acks are populated and transmitted.  In some rxrpc
    implementations, delayed acks and ping acks are transmitted
    asynchronously to the receipt of data packets and so may be transmitted
    out of order.  As a result, they can race with idle acks.

 2. Serial numbers are allocated by the rxrpc connection and not the call
    and as such may wrap independently if multiple channels are in use.

In any case, what matters is whether the ack packet provides new
information relating to the bounds of the window (the firstPacket and
previousPacket in the ACK data).

Fix this by discarding packets that appear to wind back the window bounds
rather than on serial number procession.

Fixes: 298bc15b2079 ("rxrpc: Only take the rwind and mtu values from latest ACK")
Signed-off-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h |  1 +
 net/rxrpc/input.c       | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index dfd9eab77cc8..37e4c1801a41 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -644,6 +644,7 @@ struct rxrpc_call {
 	u8			ackr_reason;	/* reason to ACK */
 	u16			ackr_skew;	/* skew on packet being ACK'd */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
+	rxrpc_serial_t		ackr_first_seq;	/* first sequence number received */
 	rxrpc_seq_t		ackr_prev_seq;	/* previous sequence number received */
 	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
 	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 7965600ee5de..2f91ab909191 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -837,7 +837,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 		u8 acks[RXRPC_MAXACKS];
 	} buf;
 	rxrpc_serial_t acked_serial;
-	rxrpc_seq_t first_soft_ack, hard_ack;
+	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
 
 	_enter("");
@@ -851,13 +851,14 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 
 	acked_serial = ntohl(buf.ack.serial);
 	first_soft_ack = ntohl(buf.ack.firstPacket);
+	prev_pkt = ntohl(buf.ack.previousPacket);
 	hard_ack = first_soft_ack - 1;
 	nr_acks = buf.ack.nAcks;
 	summary.ack_reason = (buf.ack.reason < RXRPC_ACK__INVALID ?
 			      buf.ack.reason : RXRPC_ACK__INVALID);
 
 	trace_rxrpc_rx_ack(call, sp->hdr.serial, acked_serial,
-			   first_soft_ack, ntohl(buf.ack.previousPacket),
+			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
 
 	if (buf.ack.reason == RXRPC_ACK_PING_RESPONSE)
@@ -878,8 +879,9 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 				  rxrpc_propose_ack_respond_to_ack);
 	}
 
-	/* Discard any out-of-order or duplicate ACKs. */
-	if (before_eq(sp->hdr.serial, call->acks_latest))
+	/* Discard any out-of-order or duplicate ACKs (outside lock). */
+	if (before(first_soft_ack, call->ackr_first_seq) ||
+	    before(prev_pkt, call->ackr_prev_seq))
 		return;
 
 	buf.info.rxMTU = 0;
@@ -890,12 +892,16 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb,
 
 	spin_lock(&call->input_lock);
 
-	/* Discard any out-of-order or duplicate ACKs. */
-	if (before_eq(sp->hdr.serial, call->acks_latest))
+	/* Discard any out-of-order or duplicate ACKs (inside lock). */
+	if (before(first_soft_ack, call->ackr_first_seq) ||
+	    before(prev_pkt, call->ackr_prev_seq))
 		goto out;
 	call->acks_latest_ts = skb->tstamp;
 	call->acks_latest = sp->hdr.serial;
 
+	call->ackr_first_seq = first_soft_ack;
+	call->ackr_prev_seq = prev_pkt;
+
 	/* Parse rwind and mtu sizes if provided. */
 	if (buf.info.rxMTU)
 		rxrpc_input_ackinfo(call, skb, &buf.info);
-- 
2.20.1

