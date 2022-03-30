Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCEB4EC6C2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244415AbiC3OlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbiC3OlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:41:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E3EC541A0
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 07:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648651160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D0g41ZMuah7XSiZntnTcbfGmejku/xY2IgpccjE/IAM=;
        b=aMO+Ty6hw3zwtcvrOaxdl8ED6wKlAfmGr3EhL22gmlk3WBCl47+9eAh/BXla38TVDGtJm6
        dXdLtN+BEzuOp4jN1hvTNS/HRuAB651XPwQY1ozR00+jlUCdMOWss7ihGVmCG8j33tXLZv
        Mi2/mK1gAzC769x6Aze5YFVErhb5Hbw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-g7nNry4TN460ypjpPJHy5g-1; Wed, 30 Mar 2022 10:39:18 -0400
X-MC-Unique: g7nNry4TN460ypjpPJHy5g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 785B23C163E8;
        Wed, 30 Mar 2022 14:39:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A32CA401472;
        Wed, 30 Mar 2022 14:39:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix call timer start racing with call destruction
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date:   Wed, 30 Mar 2022 15:39:16 +0100
Message-ID: <164865115696.2943015.11097991776647323586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rxrpc_call struct has a timer used to handle various timed events
relating to a call.  This timer can get started from the packet input
routines that are run in softirq mode with just the RCU read lock held.
Unfortunately, because only the RCU read lock is held - and neither ref or
other lock is taken - the call can start getting destroyed at the same time
a packet comes in addressed to that call.  This causes the timer - which
was already stopped - to get restarted.  Later, the timer dispatch code may
then oops if the timer got deallocated first.

Fix this by trying to take a ref on the rxrpc_call struct and, if
successful, passing that ref along to the timer.  If the timer was already
running, the ref is discarded.

The timer completion routine can then pass the ref along to the call's work
item when it queues it.  If the timer or work item where already
queued/running, the extra ref is discarded.

Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2022-March/005073.html
---

 include/trace/events/rxrpc.h |    8 +++++++-
 net/rxrpc/ar-internal.h      |   15 +++++++--------
 net/rxrpc/call_event.c       |    2 +-
 net/rxrpc/call_object.c      |   40 +++++++++++++++++++++++++++++++++++-----
 4 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index e70c90116eda..4a3ab0ed6e06 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -83,12 +83,15 @@ enum rxrpc_call_trace {
 	rxrpc_call_error,
 	rxrpc_call_got,
 	rxrpc_call_got_kernel,
+	rxrpc_call_got_timer,
 	rxrpc_call_got_userid,
 	rxrpc_call_new_client,
 	rxrpc_call_new_service,
 	rxrpc_call_put,
 	rxrpc_call_put_kernel,
 	rxrpc_call_put_noqueue,
+	rxrpc_call_put_notimer,
+	rxrpc_call_put_timer,
 	rxrpc_call_put_userid,
 	rxrpc_call_queued,
 	rxrpc_call_queued_ref,
@@ -278,12 +281,15 @@ enum rxrpc_tx_point {
 	EM(rxrpc_call_error,			"*E*") \
 	EM(rxrpc_call_got,			"GOT") \
 	EM(rxrpc_call_got_kernel,		"Gke") \
+	EM(rxrpc_call_got_timer,		"GTM") \
 	EM(rxrpc_call_got_userid,		"Gus") \
 	EM(rxrpc_call_new_client,		"NWc") \
 	EM(rxrpc_call_new_service,		"NWs") \
 	EM(rxrpc_call_put,			"PUT") \
 	EM(rxrpc_call_put_kernel,		"Pke") \
-	EM(rxrpc_call_put_noqueue,		"PNQ") \
+	EM(rxrpc_call_put_noqueue,		"PnQ") \
+	EM(rxrpc_call_put_notimer,		"PnT") \
+	EM(rxrpc_call_put_timer,		"PTM") \
 	EM(rxrpc_call_put_userid,		"Pus") \
 	EM(rxrpc_call_queued,			"QUE") \
 	EM(rxrpc_call_queued_ref,		"QUR") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 7bd6f8a66a3e..969e532f77a9 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -777,14 +777,12 @@ void rxrpc_propose_ACK(struct rxrpc_call *, u8, u32, bool, bool,
 		       enum rxrpc_propose_ack_trace);
 void rxrpc_process_call(struct work_struct *);
 
-static inline void rxrpc_reduce_call_timer(struct rxrpc_call *call,
-					   unsigned long expire_at,
-					   unsigned long now,
-					   enum rxrpc_timer_trace why)
-{
-	trace_rxrpc_timer(call, why, now);
-	timer_reduce(&call->timer, expire_at);
-}
+void rxrpc_reduce_call_timer(struct rxrpc_call *call,
+			     unsigned long expire_at,
+			     unsigned long now,
+			     enum rxrpc_timer_trace why);
+
+void rxrpc_delete_call_timer(struct rxrpc_call *call);
 
 /*
  * call_object.c
@@ -808,6 +806,7 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *);
 bool __rxrpc_queue_call(struct rxrpc_call *);
 bool rxrpc_queue_call(struct rxrpc_call *);
 void rxrpc_see_call(struct rxrpc_call *);
+bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op);
 void rxrpc_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_put_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_cleanup_call(struct rxrpc_call *);
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index df864e692267..22e05de5d1ca 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -310,7 +310,7 @@ void rxrpc_process_call(struct work_struct *work)
 	}
 
 	if (call->state == RXRPC_CALL_COMPLETE) {
-		del_timer_sync(&call->timer);
+		rxrpc_delete_call_timer(call);
 		goto out_put;
 	}
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 4eb91d958a48..043508fd8d8a 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -53,10 +53,30 @@ static void rxrpc_call_timer_expired(struct timer_list *t)
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		trace_rxrpc_timer(call, rxrpc_timer_expired, jiffies);
-		rxrpc_queue_call(call);
+		__rxrpc_queue_call(call);
+	} else {
+		rxrpc_put_call(call, rxrpc_call_put);
+	}
+}
+
+void rxrpc_reduce_call_timer(struct rxrpc_call *call,
+			     unsigned long expire_at,
+			     unsigned long now,
+			     enum rxrpc_timer_trace why)
+{
+	if (rxrpc_try_get_call(call, rxrpc_call_got_timer)) {
+		trace_rxrpc_timer(call, why, now);
+		if (timer_reduce(&call->timer, expire_at))
+			rxrpc_put_call(call, rxrpc_call_put_notimer);
 	}
 }
 
+void rxrpc_delete_call_timer(struct rxrpc_call *call)
+{
+	if (del_timer_sync(&call->timer))
+		rxrpc_put_call(call, rxrpc_call_put_timer);
+}
+
 static struct lock_class_key rxrpc_call_user_mutex_lock_class_key;
 
 /*
@@ -463,6 +483,17 @@ void rxrpc_see_call(struct rxrpc_call *call)
 	}
 }
 
+bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
+{
+	const void *here = __builtin_return_address(0);
+	int n = atomic_fetch_add_unless(&call->usage, 1, 0);
+
+	if (n == 0)
+		return false;
+	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
+	return true;
+}
+
 /*
  * Note the addition of a ref on a call.
  */
@@ -510,8 +541,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	spin_unlock_bh(&call->lock);
 
 	rxrpc_put_call_slot(call);
-
-	del_timer_sync(&call->timer);
+	rxrpc_delete_call_timer(call);
 
 	/* Make sure we don't get any more notifications */
 	write_lock_bh(&rx->recvmsg_lock);
@@ -618,6 +648,8 @@ static void rxrpc_destroy_call(struct work_struct *work)
 	struct rxrpc_call *call = container_of(work, struct rxrpc_call, processor);
 	struct rxrpc_net *rxnet = call->rxnet;
 
+	rxrpc_delete_call_timer(call);
+
 	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
 	kfree(call->rxtx_buffer);
@@ -652,8 +684,6 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
 
-	del_timer_sync(&call->timer);
-
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 


