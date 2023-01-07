Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A18660D75
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbjAGJzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbjAGJyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:54:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561207D9F8
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1TmX85bqbTUdAzvpkriMidpRRM5zjGpbLiAiadiYl4=;
        b=QffFXoYpz4CwK2xz5IIvT0Qc5AmvtewRj1GtApfQ9bGSaRbtsOULvIg+6gdioXpapundft
        /k19zD6wQmVibSSGGsUn9eu7PJ51atJgdW1wowoTzlLaO0CyuaPedMx4uWHWOChCQzcysW
        6tyfJYu8dPxYtZBsy9OuM/6ffUqOGDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-tynkUZmBNQKupVf6CqcuYA-1; Sat, 07 Jan 2023 04:53:14 -0500
X-MC-Unique: tynkUZmBNQKupVf6CqcuYA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E27522999B36;
        Sat,  7 Jan 2023 09:53:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C5240C2064;
        Sat,  7 Jan 2023 09:53:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 03/19] rxrpc: Separate call retransmission from other conn
 events
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:53:12 +0000
Message-ID: <167308519246.1538866.13323069187362517647.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the rxrpc_conn_retransmit_call() directly from rxrpc_input_packet()
rather than calling it via connection event handling.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    2 ++
 net/rxrpc/conn_event.c  |   34 +++++-----------------------------
 net/rxrpc/io_thread.c   |    2 +-
 3 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 9cf763c338bc..f3b8806e7241 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -897,6 +897,8 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *);
 /*
  * conn_event.c
  */
+void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn, struct sk_buff *skb,
+				unsigned int channel);
 void rxrpc_process_connection(struct work_struct *);
 void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
 int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 480364bcbf85..dfd29882126f 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -19,9 +19,9 @@
 /*
  * Retransmit terminal ACK or ABORT of the previous call.
  */
-static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
-				       struct sk_buff *skb,
-				       unsigned int channel)
+void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
+				struct sk_buff *skb,
+				unsigned int channel)
 {
 	struct rxrpc_skb_priv *sp = skb ? rxrpc_skb(skb) : NULL;
 	struct rxrpc_channel *chan;
@@ -292,24 +292,6 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 	_enter("{%d},{%u,%%%u},", conn->debug_id, sp->hdr.type, sp->hdr.serial);
 
 	switch (sp->hdr.type) {
-	case RXRPC_PACKET_TYPE_DATA:
-	case RXRPC_PACKET_TYPE_ACK:
-		rxrpc_conn_retransmit_call(conn, skb,
-					   sp->hdr.cid & RXRPC_CHANNELMASK);
-		return 0;
-
-	case RXRPC_PACKET_TYPE_BUSY:
-		/* Just ignore BUSY packets for now. */
-		return 0;
-
-	case RXRPC_PACKET_TYPE_ABORT:
-		conn->error = -ECONNABORTED;
-		conn->abort_code = skb->priority;
-		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
-		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
-		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
-		return -ECONNABORTED;
-
 	case RXRPC_PACKET_TYPE_CHALLENGE:
 		return conn->security->respond_to_challenge(conn, skb,
 							    _abort_code);
@@ -504,18 +486,12 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 
 	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
 		_leave(" = -ECONNABORTED [%u]", conn->state);
-		return -ECONNABORTED;
+		return 0;
 	}
 
 	_enter("{%d},{%u,%%%u},", conn->debug_id, sp->hdr.type, sp->hdr.serial);
 
 	switch (sp->hdr.type) {
-	case RXRPC_PACKET_TYPE_DATA:
-	case RXRPC_PACKET_TYPE_ACK:
-		rxrpc_conn_retransmit_call(conn, skb,
-					   sp->hdr.cid & RXRPC_CHANNELMASK);
-		return 0;
-
 	case RXRPC_PACKET_TYPE_BUSY:
 		/* Just ignore BUSY packets for now. */
 		return 0;
@@ -526,7 +502,7 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
 		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
-		return -ECONNABORTED;
+		return 0;
 
 	case RXRPC_PACKET_TYPE_CHALLENGE:
 	case RXRPC_PACKET_TYPE_RESPONSE:
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 1ad067d66fb6..0e1a548d35f8 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -358,7 +358,7 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 					    sp->hdr.seq,
 					    sp->hdr.serial,
 					    sp->hdr.flags);
-		rxrpc_input_conn_packet(conn, skb);
+		rxrpc_conn_retransmit_call(conn, skb, channel);
 		return 0;
 	}
 


