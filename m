Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5B02801CD
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732626AbgJAO5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732594AbgJAO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYkZxkGH8+Ni3dL2UCH+Omr99WI7mAY98UR45J0c/1o=;
        b=KDmHl0h9B4Iu4VrIGw3Va0hfSP6mYzADJjzt+IhgkSTUBtAjwNk0w4QF5D6XZ/qP4+6pTc
        8y6Y9POYFKQcpkgK7zR5pg5V1QhVN3Xm9VXiK7DppRWCfs3SC22SX2maVhvVPtEIY6yPG2
        5LnocDJZiNMMvCc6LlHWAAa4E3PjYbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-4mMyFhyaNIq8vZYS6jSNhw-1; Thu, 01 Oct 2020 10:57:32 -0400
X-MC-Unique: 4mMyFhyaNIq8vZYS6jSNhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3588818C9F72;
        Thu,  1 Oct 2020 14:57:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 693C860BFA;
        Thu,  1 Oct 2020 14:57:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 06/23] rxrpc: Fix loss of final ack on shutdown
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:24 +0100
Message-ID: <160156424463.1728886.11605866471456123858.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the loss of transmission of a call's final ack when a socket gets shut
down.  This means that the server will retransmit the last data packet or
send a ping ack and then get an ICMP indicating the port got closed.  The
server will then view this as a failure.

Fixes: 3136ef49a14c ("rxrpc: Delay terminal ACK transmission on a client call")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/conn_client.c |    3 +++
 net/rxrpc/conn_event.c  |    6 +++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 19f714386654..0b4233fdd740 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -834,6 +834,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *);
  * conn_event.c
  */
 void rxrpc_process_connection(struct work_struct *);
+void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
 
 /*
  * conn_object.c
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 5d9adfd4c84f..7e574c75be8e 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -906,6 +906,9 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
 
 	_enter("C=%x", conn->debug_id);
 
+	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
+		rxrpc_process_delayed_final_acks(conn, true);
+
 	spin_lock(&bundle->channel_lock);
 	bindex = conn->bundle_shift / RXRPC_MAXCALLS;
 	if (bundle->conns[bindex] == conn) {
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index bba5d7906df6..c1b64e1dfc4e 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -397,7 +397,7 @@ static void rxrpc_secure_connection(struct rxrpc_connection *conn)
 /*
  * Process delayed final ACKs that we haven't subsumed into a subsequent call.
  */
-static void rxrpc_process_delayed_final_acks(struct rxrpc_connection *conn)
+void rxrpc_process_delayed_final_acks(struct rxrpc_connection *conn, bool force)
 {
 	unsigned long j = jiffies, next_j;
 	unsigned int channel;
@@ -416,7 +416,7 @@ static void rxrpc_process_delayed_final_acks(struct rxrpc_connection *conn)
 		smp_rmb(); /* vs rxrpc_disconnect_client_call */
 		ack_at = READ_ONCE(chan->final_ack_at);
 
-		if (time_before(j, ack_at)) {
+		if (time_before(j, ack_at) && !force) {
 			if (time_before(ack_at, next_j)) {
 				next_j = ack_at;
 				set = true;
@@ -450,7 +450,7 @@ static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 
 	/* Process delayed ACKs whose time has come. */
 	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
-		rxrpc_process_delayed_final_acks(conn);
+		rxrpc_process_delayed_final_acks(conn, false);
 
 	/* go through the conn-level event packets, releasing the ref on this
 	 * connection that each one has when we've finished with it */


