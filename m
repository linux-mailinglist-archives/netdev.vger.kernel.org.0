Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190D328F2D6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgJOM7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:59:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728521AbgJOM7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602766770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4MhbWxh851cjV4nmGqRdUHVI6ShXZOWPssQHQbSmKQ=;
        b=ZN2r3B7b3JYkEht09uvfgaHJi0UdmUC2YsV7d4FxYYT5US9X68lWOgBa2vy2U9QRw5hwLH
        wDK+mQV9jfgB1QjeUhRYdK3PfK1RHgfr9F2n/b7NYrbgMdUeS8zd+Nhn4Ec0a7hvhpX3dc
        JVASjP5+qRpf9rYdFqhi2V4YQJ3eZWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-4KXv7USjNPeodSz_7XQReg-1; Thu, 15 Oct 2020 08:59:28 -0400
X-MC-Unique: 4KXv7USjNPeodSz_7XQReg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DBEBD68A1;
        Thu, 15 Oct 2020 12:59:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-70.rdu2.redhat.com [10.10.120.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D4AC5C22B;
        Thu, 15 Oct 2020 12:59:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 2/2] rxrpc: Fix loss of final ack on shutdown
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 15 Oct 2020 13:59:25 +0100
Message-ID: <160276676546.955243.15747495003059936378.stgit@warthog.procyon.org.uk>
In-Reply-To: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
References: <160276675194.955243.3551319337030732277.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index c9287b6551df..dce48162f6c2 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -831,6 +831,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *);
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
index 6b7c6f4a82e3..aff184145ffa 100644
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


