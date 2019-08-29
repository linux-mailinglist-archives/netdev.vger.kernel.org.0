Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E99AA1ACD
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfH2NGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfH2NGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:06:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6500E308219E;
        Thu, 29 Aug 2019 13:06:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80C555C1D6;
        Thu, 29 Aug 2019 13:06:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/5] rxrpc: Pass the input handler's data skb reference
 to the Rx ring
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 29 Aug 2019 14:06:19 +0100
Message-ID: <156708397971.25861.1471138213727662062.stgit@warthog.procyon.org.uk>
In-Reply-To: <156708397261.25861.2158085372781699276.stgit@warthog.procyon.org.uk>
References: <156708397261.25861.2158085372781699276.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 29 Aug 2019 13:06:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the reference held on a DATA skb in the rxrpc input handler into the
Rx ring rather than getting an additional ref for this and then dropping
the original ref at the end.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 35b1a9368d80..140cede77655 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -422,7 +422,8 @@ static void rxrpc_input_dup_data(struct rxrpc_call *call, rxrpc_seq_t seq,
 }
 
 /*
- * Process a DATA packet, adding the packet to the Rx ring.
+ * Process a DATA packet, adding the packet to the Rx ring.  The caller's
+ * packet ref must be passed on or discarded.
  */
 static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
@@ -441,8 +442,10 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	       sp->hdr.serial, seq0, sp->hdr.flags, sp->nr_subpackets);
 
 	state = READ_ONCE(call->state);
-	if (state >= RXRPC_CALL_COMPLETE)
+	if (state >= RXRPC_CALL_COMPLETE) {
+		rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
 		return;
+	}
 
 	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
@@ -555,7 +558,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		 * Barriers against rxrpc_recvmsg_data() and rxrpc_rotate_rx_window()
 		 * and also rxrpc_fill_out_ack().
 		 */
-		rxrpc_get_skb(skb, rxrpc_skb_rx_got);
+		if (!terminal)
+			rxrpc_get_skb(skb, rxrpc_skb_rx_got);
 		call->rxtx_annotations[ix] = annotation;
 		smp_wmb();
 		call->rxtx_buffer[ix] = skb;
@@ -616,6 +620,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 
 unlock:
 	spin_unlock(&call->input_lock);
+	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
 	_leave(" [queued]");
 }
 
@@ -1024,7 +1029,7 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_DATA:
 		rxrpc_input_data(call, skb);
-		break;
+		goto no_free;
 
 	case RXRPC_PACKET_TYPE_ACK:
 		rxrpc_input_ack(call, skb);
@@ -1051,6 +1056,8 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 		break;
 	}
 
+	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
+no_free:
 	_leave("");
 }
 
@@ -1375,8 +1382,11 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		mutex_unlock(&call->user_mutex);
 	}
 
+	/* Process a call packet; this either discards or passes on the ref
+	 * elsewhere.
+	 */
 	rxrpc_input_call_packet(call, skb);
-	goto discard;
+	goto out;
 
 discard:
 	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);

