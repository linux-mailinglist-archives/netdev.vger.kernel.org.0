Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5D11F2CF2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733064AbgFIA3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730197AbgFHXQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4CC2083E;
        Mon,  8 Jun 2020 23:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658174;
        bh=Oqu2yOvrwuOCvuThZiTy/2R+0TTTq6zMYRIblVN+r5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abzJ4hCoxwQ8n7kqHrKIm8u5GRMpHuoOwie1z+NtFFgq7bqrY0Brl3eIgETuAhF5M
         tX+wNo5uv4G3+ivUFOH8pjFA6NZO/48ji3QbTXEvxZVBFTWign/6de06YPWTWMric3
         q2K8rupVf+xQShkCLKHOMIieaO7d7fW6H36nJeVc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 200/606] rxrpc: Trace discarded ACKs
Date:   Mon,  8 Jun 2020 19:05:25 -0400
Message-Id: <20200608231211.3363633-200-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit d1f129470e6cb79b8b97fecd12689f6eb49e27fe ]

Add a tracepoint to track received ACKs that are discarded due to being
outside of the Tx window.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h | 35 +++++++++++++++++++++++++++++++++++
 net/rxrpc/input.c            | 12 ++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index ab75f261f04a..ba9efdc848f9 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1541,6 +1541,41 @@ TRACE_EVENT(rxrpc_notify_socket,
 		      __entry->serial)
 	    );
 
+TRACE_EVENT(rxrpc_rx_discard_ack,
+	    TP_PROTO(unsigned int debug_id, rxrpc_serial_t serial,
+		     rxrpc_seq_t first_soft_ack, rxrpc_seq_t call_ackr_first,
+		     rxrpc_seq_t prev_pkt, rxrpc_seq_t call_ackr_prev),
+
+	    TP_ARGS(debug_id, serial, first_soft_ack, call_ackr_first,
+		    prev_pkt, call_ackr_prev),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	debug_id	)
+		    __field(rxrpc_serial_t,	serial		)
+		    __field(rxrpc_seq_t,	first_soft_ack)
+		    __field(rxrpc_seq_t,	call_ackr_first)
+		    __field(rxrpc_seq_t,	prev_pkt)
+		    __field(rxrpc_seq_t,	call_ackr_prev)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->debug_id		= debug_id;
+		    __entry->serial		= serial;
+		    __entry->first_soft_ack	= first_soft_ack;
+		    __entry->call_ackr_first	= call_ackr_first;
+		    __entry->prev_pkt		= prev_pkt;
+		    __entry->call_ackr_prev	= call_ackr_prev;
+			   ),
+
+	    TP_printk("c=%08x r=%08x %08x<%08x %08x<%08x",
+		      __entry->debug_id,
+		      __entry->serial,
+		      __entry->first_soft_ack,
+		      __entry->call_ackr_first,
+		      __entry->prev_pkt,
+		      __entry->call_ackr_prev)
+	    );
+
 #endif /* _TRACE_RXRPC_H */
 
 /* This part must be outside protection */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index e438bfd3fdf5..2f22f082a66c 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -866,8 +866,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq))
+	    before(prev_pkt, call->ackr_prev_seq)) {
+		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+					   first_soft_ack, call->ackr_first_seq,
+					   prev_pkt, call->ackr_prev_seq);
 		return;
+	}
 
 	buf.info.rxMTU = 0;
 	ioffset = offset + nr_acks + 3;
@@ -879,8 +883,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq))
+	    before(prev_pkt, call->ackr_prev_seq)) {
+		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+					   first_soft_ack, call->ackr_first_seq,
+					   prev_pkt, call->ackr_prev_seq);
 		goto out;
+	}
 	call->acks_latest_ts = skb->tstamp;
 
 	call->ackr_first_seq = first_soft_ack;
-- 
2.25.1

