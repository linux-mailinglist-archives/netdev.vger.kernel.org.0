Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F0964DE81
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiLOQWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiLOQWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EFB25EB5
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wsHoWm/EeF8Ya2EVXL07pEXDul793kzk/rx/5eyVuMM=;
        b=BwoKqBIx6fSr5xNam++I695VzM6Gv/ThNpGIq+r3l92k/Ch6YInuaeKLi2DbRPbqhCrRfj
        INxMdH8Vn1u3yJjijXHd9VkLgeXx79CgXr+9gDWlYjg0irIa+VdOCmvUgcICeefGExaD65
        gv2GuNWU+77cNovEb9WTSs0Pnn8YWoQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-dtLkmLztNyG5jfgkVbmkfA-1; Thu, 15 Dec 2022 11:20:59 -0500
X-MC-Unique: dtLkmLztNyG5jfgkVbmkfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAE8D8030D0;
        Thu, 15 Dec 2022 16:20:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6A9B14171BE;
        Thu, 15 Dec 2022 16:20:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 9/9] rxrpc: Fix the return value of
 rxrpc_new_incoming_call()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <error27@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:55 +0000
Message-ID: <167112125530.152641.9141534187681800613.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter sayeth[1]:

  The patch 5e6ef4f1017c: "rxrpc: Make the I/O thread take over the
  call and local processor work" from Jan 23, 2020, leads to the
  following Smatch static checker warning:

	net/rxrpc/io_thread.c:283 rxrpc_input_packet()
	warn: bool is not less than zero.

Fix this (for now) by changing rxrpc_new_incoming_call() to return an int
with 0 or error code rather than bool.  Note that the actual return value
of rxrpc_input_packet() is currently ignored.  I have a separate patch to
clean that up.

Fixes: 5e6ef4f1017c ("rxrpc: Make the I/O thread take over the call and local processor work")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2022-December/006123.html [1]
---

 net/rxrpc/ar-internal.h |    6 +++---
 net/rxrpc/call_accept.c |   18 +++++++++---------
 net/rxrpc/io_thread.c   |    4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 5b732a4af009..18092526d3c8 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -812,9 +812,9 @@ extern struct workqueue_struct *rxrpc_workqueue;
  */
 int rxrpc_service_prealloc(struct rxrpc_sock *, gfp_t);
 void rxrpc_discard_prealloc(struct rxrpc_sock *);
-bool rxrpc_new_incoming_call(struct rxrpc_local *, struct rxrpc_peer *,
-			     struct rxrpc_connection *, struct sockaddr_rxrpc *,
-			     struct sk_buff *);
+int rxrpc_new_incoming_call(struct rxrpc_local *, struct rxrpc_peer *,
+			    struct rxrpc_connection *, struct sockaddr_rxrpc *,
+			    struct sk_buff *);
 void rxrpc_accept_incoming_calls(struct rxrpc_local *);
 int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
 
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index d1850863507f..c02401656fa9 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -326,11 +326,11 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
  * If we want to report an error, we mark the skb with the packet type and
  * abort code and return false.
  */
-bool rxrpc_new_incoming_call(struct rxrpc_local *local,
-			     struct rxrpc_peer *peer,
-			     struct rxrpc_connection *conn,
-			     struct sockaddr_rxrpc *peer_srx,
-			     struct sk_buff *skb)
+int rxrpc_new_incoming_call(struct rxrpc_local *local,
+			    struct rxrpc_peer *peer,
+			    struct rxrpc_connection *conn,
+			    struct sockaddr_rxrpc *peer_srx,
+			    struct sk_buff *skb)
 {
 	const struct rxrpc_security *sec = NULL;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -342,7 +342,7 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	/* Don't set up a call for anything other than the first DATA packet. */
 	if (sp->hdr.seq != 1 ||
 	    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
-		return true; /* Just discard */
+		return 0; /* Just discard */
 
 	rcu_read_lock();
 
@@ -413,7 +413,7 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	_leave(" = %p{%d}", call, call->debug_id);
 	rxrpc_input_call_event(call, skb);
 	rxrpc_put_call(call, rxrpc_call_put_input);
-	return true;
+	return 0;
 
 unsupported_service:
 	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
@@ -425,10 +425,10 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 reject:
 	rcu_read_unlock();
 	_leave(" = f [%u]", skb->mark);
-	return false;
+	return -EPROTO;
 discard:
 	rcu_read_unlock();
-	return true;
+	return 0;
 }
 
 /*
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index e6b9f0ceae17..1ad067d66fb6 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -292,7 +292,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
 reject_packet:
 	rxrpc_reject_packet(local, skb);
-	return ret;
+	return 0;
 }
 
 /*
@@ -384,7 +384,7 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
 		if (rxrpc_to_client(sp))
 			goto bad_message;
 		if (rxrpc_new_incoming_call(conn->local, conn->peer, conn,
-					    peer_srx, skb))
+					    peer_srx, skb) == 0)
 			return 0;
 		goto reject_packet;
 	}


