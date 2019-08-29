Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C480A1AF1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfH2NID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfH2NIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 09:08:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C21BB7F746;
        Thu, 29 Aug 2019 13:08:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6A335C21E;
        Thu, 29 Aug 2019 13:08:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/7] rxrpc: Abstract out rxtx ring cleanup
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 29 Aug 2019 14:08:01 +0100
Message-ID: <156708408120.26102.7710356156597753765.stgit@warthog.procyon.org.uk>
In-Reply-To: <156708405310.26102.7954021163316252673.stgit@warthog.procyon.org.uk>
References: <156708405310.26102.7954021163316252673.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 29 Aug 2019 13:08:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abstract out rxtx ring cleanup into its own function from its two callers.
This makes it easier to apply the same changes to both.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/call_object.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 217b12be9e08..c9ab2da957fe 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -421,6 +421,21 @@ void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 	trace_rxrpc_call(call, op, n, here, NULL);
 }
 
+/*
+ * Clean up the RxTx skb ring.
+ */
+static void rxrpc_cleanup_ring(struct rxrpc_call *call)
+{
+	int i;
+
+	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++) {
+		rxrpc_free_skb(call->rxtx_buffer[i],
+			       (call->tx_phase ? rxrpc_skb_tx_cleaned :
+				rxrpc_skb_rx_cleaned));
+		call->rxtx_buffer[i] = NULL;
+	}
+}
+
 /*
  * Detach a call from its owning socket.
  */
@@ -429,7 +444,6 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	const void *here = __builtin_return_address(0);
 	struct rxrpc_connection *conn = call->conn;
 	bool put = false;
-	int i;
 
 	_enter("{%d,%d}", call->debug_id, atomic_read(&call->usage));
 
@@ -479,13 +493,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	if (conn)
 		rxrpc_disconnect_call(call);
 
-	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++) {
-		rxrpc_free_skb(call->rxtx_buffer[i],
-			       (call->tx_phase ? rxrpc_skb_tx_cleaned :
-				rxrpc_skb_rx_cleaned));
-		call->rxtx_buffer[i] = NULL;
-	}
-
+	rxrpc_cleanup_ring(call);
 	_leave("");
 }
 
@@ -568,8 +576,6 @@ static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
  */
 void rxrpc_cleanup_call(struct rxrpc_call *call)
 {
-	int i;
-
 	_net("DESTROY CALL %d", call->debug_id);
 
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
@@ -580,12 +586,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 	ASSERTCMP(call->conn, ==, NULL);
 
-	/* Clean up the Rx/Tx buffer */
-	for (i = 0; i < RXRPC_RXTX_BUFF_SIZE; i++)
-		rxrpc_free_skb(call->rxtx_buffer[i],
-			       (call->tx_phase ? rxrpc_skb_tx_cleaned :
-				rxrpc_skb_rx_cleaned));
-
+	rxrpc_cleanup_ring(call);
 	rxrpc_free_skb(call->tx_pending, rxrpc_skb_tx_cleaned);
 
 	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);

