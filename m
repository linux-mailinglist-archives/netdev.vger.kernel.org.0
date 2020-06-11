Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB81F6F11
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 22:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgFKU5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 16:57:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45345 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726153AbgFKU5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 16:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591909025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=stO8jQvqNcwOWNIQtMJm8gAm7jWS/z8vF2BB4pQqyOU=;
        b=azRiEU0TpyN92JAp2Vov4x3PIWkmGi76qjcqo/q/762E+Z8ZX3JTWUlD3i/CBF/EPCgepa
        PftcjM+/ygPonIQ9uMh940u3QtteHqfZItfrsIi50PADxjyAEeVEwSfjlh6Z1BLQQOD2A/
        hwIiDwyYm0fkrYwukBI/+uE68AQ33II=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-avyxs7TKMRShXit6EtYNNQ-1; Thu, 11 Jun 2020 16:57:03 -0400
X-MC-Unique: avyxs7TKMRShXit6EtYNNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F229A107ACCA;
        Thu, 11 Jun 2020 20:57:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C5367F4DB;
        Thu, 11 Jun 2020 20:57:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix race between incoming ACK parser and
 retransmitter
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 11 Jun 2020 21:57:00 +0100
Message-ID: <159190902048.3557242.17524953697020439394.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a race between the retransmission code and the received ACK parser.
The problem is that the retransmission loop has to drop the lock under
which it is iterating through the transmission buffer in order to transmit
a packet, but whilst the lock is dropped, the ACK parser can crank the Tx
window round and discard the packets from the buffer.

The retransmission code then updated the annotations for the wrong packet
and a later retransmission thought it had to retransmit a packet that
wasn't there, leading to a NULL pointer dereference.

Fix this by:

 (1) Moving the annotation change to before we drop the lock prior to
     transmission.  This means we can't vary the annotation depending on
     the outcome of the transmission, but that's fine - we'll retransmit
     again later if it failed now.

 (2) Skipping the packet if the skb pointer is NULL.

The following oops was seen:

	BUG: kernel NULL pointer dereference, address: 000000000000002d
	Workqueue: krxrpcd rxrpc_process_call
	RIP: 0010:rxrpc_get_skb+0x14/0x8a
	...
	Call Trace:
	 rxrpc_resend+0x331/0x41e
	 ? get_vtime_delta+0x13/0x20
	 rxrpc_process_call+0x3c0/0x4ac
	 process_one_work+0x18f/0x27f
	 worker_thread+0x1a3/0x247
	 ? create_worker+0x17d/0x17d
	 kthread+0xe6/0xeb
	 ? kthread_delayed_work_timer_fn+0x83/0x83
	 ret_from_fork+0x1f/0x30

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/call_event.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 61a51c251e1b..aa1c8eee6557 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -248,7 +248,18 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		if (anno_type != RXRPC_TX_ANNO_RETRANS)
 			continue;
 
+		/* We need to reset the retransmission state, but we need to do
+		 * so before we drop the lock as a new ACK/NAK may come in and
+		 * confuse things
+		 */
+		annotation &= ~RXRPC_TX_ANNO_MASK;
+		annotation |= RXRPC_TX_ANNO_RESENT;
+		call->rxtx_annotations[ix] = annotation;
+
 		skb = call->rxtx_buffer[ix];
+		if (!skb)
+			continue;
+
 		rxrpc_get_skb(skb, rxrpc_skb_got);
 		spin_unlock_bh(&call->lock);
 
@@ -262,24 +273,6 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		spin_lock_bh(&call->lock);
-
-		/* We need to clear the retransmit state, but there are two
-		 * things we need to be aware of: A new ACK/NAK might have been
-		 * received and the packet might have been hard-ACK'd (in which
-		 * case it will no longer be in the buffer).
-		 */
-		if (after(seq, call->tx_hard_ack)) {
-			annotation = call->rxtx_annotations[ix];
-			anno_type = annotation & RXRPC_TX_ANNO_MASK;
-			if (anno_type == RXRPC_TX_ANNO_RETRANS ||
-			    anno_type == RXRPC_TX_ANNO_NAK) {
-				annotation &= ~RXRPC_TX_ANNO_MASK;
-				annotation |= RXRPC_TX_ANNO_UNACK;
-			}
-			annotation |= RXRPC_TX_ANNO_RESENT;
-			call->rxtx_annotations[ix] = annotation;
-		}
-
 		if (after(call->tx_hard_ack, seq))
 			seq = call->tx_hard_ack;
 	}


