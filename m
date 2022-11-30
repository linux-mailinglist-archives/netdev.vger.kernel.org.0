Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7EF63DB40
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiK3Q6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiK3Q5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:57:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E4191C11
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zed4TskVzZBf0Lp0+EduaaL2oGYwYd/Zz6NwOYGIqxk=;
        b=BeCn3uaFsWGrjlxZGyBmrVDNz/b8xV7aVOlrPdsuyfBd1bWgLO46BL2spsaC+iOZPx4fcL
        UzwMNPocVdWzOx3eNH86/AkrX8vRx5fyN8zVDMdhqQzQGw0j75mSlmU+yKa22Cs6ZHbjou
        Hm8Iamcixg8LHCZWpXSeEcd8ThzDQLA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307--g7lwgJZNYmAfZ9Dh8RdVQ-1; Wed, 30 Nov 2022 11:56:23 -0500
X-MC-Unique: -g7lwgJZNYmAfZ9Dh8RdVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9C37185A7A9;
        Wed, 30 Nov 2022 16:56:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C8842166B26;
        Wed, 30 Nov 2022 16:56:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 14/35] rxrpc: trace: Don't use
 __builtin_return_address for sk_buff tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:56:19 +0000
Message-ID: <166982737927.621383.1527931764497198598.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rxrpc tracing, use enums to generate lists of points of interest rather
than __builtin_return_address() for the sk_buff tracepoint.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   57 ++++++++++++++++++++++++------------------
 net/rxrpc/call_event.c       |    4 +--
 net/rxrpc/call_object.c      |    2 +
 net/rxrpc/conn_event.c       |    6 ++--
 net/rxrpc/input.c            |   36 +++++++++++++--------------
 net/rxrpc/local_event.c      |    4 +--
 net/rxrpc/output.c           |    6 ++--
 net/rxrpc/peer_event.c       |    8 +++---
 net/rxrpc/recvmsg.c          |    6 ++--
 net/rxrpc/skbuff.c           |   36 +++++++++++----------------
 10 files changed, 84 insertions(+), 81 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 6f5be7ac7f6b..5a2292baffc8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -17,19 +17,31 @@
  * Declare tracing information enums and their string mappings for display.
  */
 #define rxrpc_skb_traces \
-	EM(rxrpc_skb_ack,			"ACK") \
-	EM(rxrpc_skb_cleaned,			"CLN") \
-	EM(rxrpc_skb_cloned_jumbo,		"CLJ") \
-	EM(rxrpc_skb_freed,			"FRE") \
-	EM(rxrpc_skb_got,			"GOT") \
-	EM(rxrpc_skb_lost,			"*L*") \
-	EM(rxrpc_skb_new,			"NEW") \
-	EM(rxrpc_skb_purged,			"PUR") \
-	EM(rxrpc_skb_received,			"RCV") \
-	EM(rxrpc_skb_rotated,			"ROT") \
-	EM(rxrpc_skb_seen,			"SEE") \
-	EM(rxrpc_skb_unshared,			"UNS") \
-	E_(rxrpc_skb_unshared_nomem,		"US0")
+	EM(rxrpc_skb_eaten_by_unshare,		"ETN unshare  ") \
+	EM(rxrpc_skb_eaten_by_unshare_nomem,	"ETN unshar-nm") \
+	EM(rxrpc_skb_get_ack,			"GET ack      ") \
+	EM(rxrpc_skb_get_conn_work,		"GET conn-work") \
+	EM(rxrpc_skb_get_to_recvmsg,		"GET to-recv  ") \
+	EM(rxrpc_skb_get_to_recvmsg_oos,	"GET to-recv-o") \
+	EM(rxrpc_skb_new_encap_rcv,		"NEW encap-rcv") \
+	EM(rxrpc_skb_new_error_report,		"NEW error-rpt") \
+	EM(rxrpc_skb_new_jumbo_subpacket,	"NEW jumbo-sub") \
+	EM(rxrpc_skb_new_unshared,		"NEW unshared ") \
+	EM(rxrpc_skb_put_ack,			"PUT ack      ") \
+	EM(rxrpc_skb_put_conn_work,		"PUT conn-work") \
+	EM(rxrpc_skb_put_error_report,		"PUT error-rep") \
+	EM(rxrpc_skb_put_input,			"PUT input    ") \
+	EM(rxrpc_skb_put_jumbo_subpacket,	"PUT jumbo-sub") \
+	EM(rxrpc_skb_put_lose,			"PUT lose     ") \
+	EM(rxrpc_skb_put_purge,			"PUT purge    ") \
+	EM(rxrpc_skb_put_rotate,		"PUT rotate   ") \
+	EM(rxrpc_skb_put_unknown,		"PUT unknown  ") \
+	EM(rxrpc_skb_see_conn_work,		"SEE conn-work") \
+	EM(rxrpc_skb_see_local_work,		"SEE locl-work") \
+	EM(rxrpc_skb_see_recvmsg,		"SEE recvmsg  ") \
+	EM(rxrpc_skb_see_reject,		"SEE reject   ") \
+	EM(rxrpc_skb_see_rotate,		"SEE rotate   ") \
+	E_(rxrpc_skb_see_version,		"SEE version  ")
 
 #define rxrpc_local_traces \
 	EM(rxrpc_local_free,			"FREE        ") \
@@ -582,33 +594,30 @@ TRACE_EVENT(rxrpc_call,
 	    );
 
 TRACE_EVENT(rxrpc_skb,
-	    TP_PROTO(struct sk_buff *skb, enum rxrpc_skb_trace op,
-		     int usage, int mod_count, const void *where),
+	    TP_PROTO(struct sk_buff *skb, int usage, int mod_count,
+		     enum rxrpc_skb_trace why),
 
-	    TP_ARGS(skb, op, usage, mod_count, where),
+	    TP_ARGS(skb, usage, mod_count, why),
 
 	    TP_STRUCT__entry(
 		    __field(struct sk_buff *,		skb		)
-		    __field(enum rxrpc_skb_trace,	op		)
 		    __field(int,			usage		)
 		    __field(int,			mod_count	)
-		    __field(const void *,		where		)
+		    __field(enum rxrpc_skb_trace,	why		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->skb = skb;
-		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->mod_count = mod_count;
-		    __entry->where = where;
+		    __entry->why = why;
 			   ),
 
-	    TP_printk("s=%p Rx %s u=%d m=%d p=%pSR",
+	    TP_printk("s=%p Rx %s u=%d m=%d",
 		      __entry->skb,
-		      __print_symbolic(__entry->op, rxrpc_skb_traces),
+		      __print_symbolic(__entry->why, rxrpc_skb_traces),
 		      __entry->usage,
-		      __entry->mod_count,
-		      __entry->where)
+		      __entry->mod_count)
 	    );
 
 TRACE_EVENT(rxrpc_rx_packet,
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 0c8d2186cda8..29ca02e53c47 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -153,7 +153,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		spin_lock_bh(&call->acks_ack_lock);
 		ack_skb = call->acks_soft_tbl;
 		if (ack_skb) {
-			rxrpc_get_skb(ack_skb, rxrpc_skb_ack);
+			rxrpc_get_skb(ack_skb, rxrpc_skb_get_ack);
 			ack = (void *)ack_skb->data + sizeof(struct rxrpc_wire_header);
 		}
 		spin_unlock_bh(&call->acks_ack_lock);
@@ -251,7 +251,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 no_further_resend:
 	spin_unlock(&call->tx_lock);
 no_resend:
-	rxrpc_free_skb(ack_skb, rxrpc_skb_freed);
+	rxrpc_free_skb(ack_skb, rxrpc_skb_put_ack);
 
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
 	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer,
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index afd957f6dc1c..815209673115 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -663,7 +663,7 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
 	}
 	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
-	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_cleaned);
+	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
 
 	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
 }
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 817f895c77ca..49d885f73fa5 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -437,7 +437,7 @@ static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 	/* go through the conn-level event packets, releasing the ref on this
 	 * connection that each one has when we've finished with it */
 	while ((skb = skb_dequeue(&conn->rx_queue))) {
-		rxrpc_see_skb(skb, rxrpc_skb_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_see_conn_work);
 		ret = rxrpc_process_event(conn, skb, &abort_code);
 		switch (ret) {
 		case -EPROTO:
@@ -449,7 +449,7 @@ static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 			goto requeue_and_leave;
 		case -ECONNABORTED:
 		default:
-			rxrpc_free_skb(skb, rxrpc_skb_freed);
+			rxrpc_free_skb(skb, rxrpc_skb_put_conn_work);
 			break;
 		}
 	}
@@ -463,7 +463,7 @@ static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 protocol_error:
 	if (rxrpc_abort_connection(conn, ret, abort_code) < 0)
 		goto requeue_and_leave;
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_conn_work);
 	return;
 }
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 09b44cd11c9b..ab8b7a1be935 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -485,7 +485,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 					rxrpc_propose_ack_input_data);
 
 err_free:
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 }
 
 /*
@@ -513,7 +513,7 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 			kdebug("couldn't clone");
 			return false;
 		}
-		rxrpc_new_skb(jskb, rxrpc_skb_cloned_jumbo);
+		rxrpc_new_skb(jskb, rxrpc_skb_new_jumbo_subpacket);
 		jsp = rxrpc_skb(jskb);
 		jsp->offset = offset;
 		jsp->len = RXRPC_JUMBO_DATALEN;
@@ -553,7 +553,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 
 	state = READ_ONCE(call->state);
 	if (state >= RXRPC_CALL_COMPLETE) {
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 		return;
 	}
 
@@ -563,14 +563,14 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	if (sp->hdr.securityIndex != 0) {
 		struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
 		if (!nskb) {
-			rxrpc_eaten_skb(skb, rxrpc_skb_unshared_nomem);
+			rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare_nomem);
 			return;
 		}
 
 		if (nskb != skb) {
-			rxrpc_eaten_skb(skb, rxrpc_skb_received);
+			rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare);
 			skb = nskb;
-			rxrpc_new_skb(skb, rxrpc_skb_unshared);
+			rxrpc_new_skb(skb, rxrpc_skb_new_unshared);
 			sp = rxrpc_skb(skb);
 		}
 	}
@@ -609,7 +609,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	rxrpc_notify_socket(call);
 
 	spin_unlock(&call->input_lock);
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	_leave(" [queued]");
 }
 
@@ -994,8 +994,8 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 out:
 	spin_unlock(&call->input_lock);
 out_not_locked:
-	rxrpc_free_skb(skb_put, rxrpc_skb_freed);
-	rxrpc_free_skb(skb_old, rxrpc_skb_freed);
+	rxrpc_free_skb(skb_put, rxrpc_skb_put_input);
+	rxrpc_free_skb(skb_old, rxrpc_skb_put_ack);
 }
 
 /*
@@ -1075,7 +1075,7 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
 		break;
 	}
 
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 no_free:
 	_leave("");
 }
@@ -1137,7 +1137,7 @@ static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
 		skb_queue_tail(&local->event_queue, skb);
 		rxrpc_queue_local(local);
 	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	}
 }
 
@@ -1150,7 +1150,7 @@ static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		skb_queue_tail(&local->reject_queue, skb);
 		rxrpc_queue_local(local);
 	} else {
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	}
 }
 
@@ -1228,7 +1228,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	if (skb->tstamp == 0)
 		skb->tstamp = ktime_get_real();
 
-	rxrpc_new_skb(skb, rxrpc_skb_received);
+	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
 
 	skb_pull(skb, sizeof(struct udphdr));
 
@@ -1245,7 +1245,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		static int lose;
 		if ((lose++ & 7) == 7) {
 			trace_rxrpc_rx_lose(sp);
-			rxrpc_free_skb(skb, rxrpc_skb_lost);
+			rxrpc_free_skb(skb, rxrpc_skb_put_lose);
 			return 0;
 		}
 	}
@@ -1286,14 +1286,14 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		if (sp->hdr.securityIndex != 0) {
 			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
 			if (!nskb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_unshared_nomem);
+				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare_nomem);
 				goto out;
 			}
 
 			if (nskb != skb) {
-				rxrpc_eaten_skb(skb, rxrpc_skb_received);
+				rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare);
 				skb = nskb;
-				rxrpc_new_skb(skb, rxrpc_skb_unshared);
+				rxrpc_new_skb(skb, rxrpc_skb_new_unshared);
 				sp = rxrpc_skb(skb);
 			}
 		}
@@ -1434,7 +1434,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	goto out;
 
 discard:
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_input);
 out:
 	trace_rxrpc_rx_done(0, 0);
 	return 0;
diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index f23a3fbabbda..c344383a20b2 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -88,7 +88,7 @@ void rxrpc_process_local_events(struct rxrpc_local *local)
 	if (skb) {
 		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
-		rxrpc_see_skb(skb, rxrpc_skb_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_see_local_work);
 		_debug("{%d},{%u}", local->debug_id, sp->hdr.type);
 
 		switch (sp->hdr.type) {
@@ -105,7 +105,7 @@ void rxrpc_process_local_events(struct rxrpc_local *local)
 			break;
 		}
 
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	}
 
 	_leave("");
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index d324e88f7642..131c7a76fb06 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -615,7 +615,7 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 	memset(&whdr, 0, sizeof(whdr));
 
 	while ((skb = skb_dequeue(&local->reject_queue))) {
-		rxrpc_see_skb(skb, rxrpc_skb_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_see_reject);
 		sp = rxrpc_skb(skb);
 
 		switch (skb->mark) {
@@ -631,7 +631,7 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 			ioc = 2;
 			break;
 		default:
-			rxrpc_free_skb(skb, rxrpc_skb_freed);
+			rxrpc_free_skb(skb, rxrpc_skb_put_input);
 			continue;
 		}
 
@@ -656,7 +656,7 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 						      rxrpc_tx_point_reject);
 		}
 
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_input);
 	}
 
 	_leave("");
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index b28739d10927..f35cfc458dcf 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -158,12 +158,12 @@ void rxrpc_error_report(struct sock *sk)
 		_leave("UDP socket errqueue empty");
 		return;
 	}
-	rxrpc_new_skb(skb, rxrpc_skb_received);
+	rxrpc_new_skb(skb, rxrpc_skb_new_error_report);
 	serr = SKB_EXT_ERR(skb);
 	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
 		_leave("UDP empty message");
 		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 		return;
 	}
 
@@ -172,7 +172,7 @@ void rxrpc_error_report(struct sock *sk)
 		peer = NULL;
 	if (!peer) {
 		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+		rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 		_leave(" [no peer]");
 		return;
 	}
@@ -189,7 +189,7 @@ void rxrpc_error_report(struct sock *sk)
 	rxrpc_store_error(peer, serr);
 out:
 	rcu_read_unlock();
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 	rxrpc_put_peer(peer, rxrpc_peer_put_input_error);
 
 	_leave("");
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index c84d2b620396..bfac9e09347e 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -229,7 +229,7 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	_enter("%d", call->debug_id);
 
 	skb = skb_dequeue(&call->recvmsg_queue);
-	rxrpc_see_skb(skb, rxrpc_skb_rotated);
+	rxrpc_see_skb(skb, rxrpc_skb_see_rotate);
 
 	sp = rxrpc_skb(skb);
 	tseq   = sp->hdr.seq;
@@ -240,7 +240,7 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	if (after(tseq, call->rx_consumed))
 		smp_store_release(&call->rx_consumed, tseq);
 
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_free_skb(skb, rxrpc_skb_put_rotate);
 
 	trace_rxrpc_receive(call, last ? rxrpc_receive_rotate_last : rxrpc_receive_rotate,
 			    serial, call->rx_consumed);
@@ -302,7 +302,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	 */
 	skb = skb_peek(&call->recvmsg_queue);
 	while (skb) {
-		rxrpc_see_skb(skb, rxrpc_skb_seen);
+		rxrpc_see_skb(skb, rxrpc_skb_see_recvmsg);
 		sp = rxrpc_skb(skb);
 		seq = sp->hdr.seq;
 
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 0c827d5bb2b8..ebe0c75e7b07 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/* ar-skbuff.c: socket buffer destruction handling
+/* Socket buffer accounting
  *
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -19,56 +19,50 @@
 /*
  * Note the allocation or reception of a socket buffer.
  */
-void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, refcount_read(&skb->users), n, why);
 }
 
 /*
  * Note the re-emergence of a socket buffer from a queue or buffer.
  */
-void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	if (skb) {
 		int n = atomic_read(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, refcount_read(&skb->users), n, why);
 	}
 }
 
 /*
  * Note the addition of a ref on a socket buffer.
  */
-void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, refcount_read(&skb->users), n, why);
 	skb_get(skb);
 }
 
 /*
  * Note the dropping of a ref on a socket buffer by the core.
  */
-void rxrpc_eaten_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+void rxrpc_eaten_skb(struct sk_buff *skb, enum rxrpc_skb_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(&rxrpc_n_rx_skbs);
-	trace_rxrpc_skb(skb, op, 0, n, here);
+	trace_rxrpc_skb(skb, 0, n, why);
 }
 
 /*
  * Note the destruction of a socket buffer.
  */
-void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	if (skb) {
-		int n;
-		n = atomic_dec_return(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+		int n = atomic_dec_return(select_skb_count(skb));
+		trace_rxrpc_skb(skb, refcount_read(&skb->users), n, why);
 		kfree_skb(skb);
 	}
 }
@@ -78,12 +72,12 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
  */
 void rxrpc_purge_queue(struct sk_buff_head *list)
 {
-	const void *here = __builtin_return_address(0);
 	struct sk_buff *skb;
+
 	while ((skb = skb_dequeue((list))) != NULL) {
 		int n = atomic_dec_return(select_skb_count(skb));
-		trace_rxrpc_skb(skb, rxrpc_skb_purged,
-				refcount_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, refcount_read(&skb->users), n,
+				rxrpc_skb_put_purge);
 		kfree_skb(skb);
 	}
 }


