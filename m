Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CE7621F21
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiKHWWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKHWVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BC7663DA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z2zpgjzTK/gVTxk7oe8etnIFubSP2dPMJd/BpzSmD/w=;
        b=McQf5VYSZw3jfI5AonfP9yut9s/WoZKzedJ4GbwMy54OnOeZrGcIlTNJzn32dKOoVwRLKA
        vTN+vq2oPIp0J0h9JXpTu5O7QF7jYM+lB2Sbxl5XgmWHdYUG2/VSUtT6JEshdgZZ0GSthb
        i4tnK10yls+/4zUi0drHI/Cilk4SSFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-WWwE2_H5OuOnVGMEbHoqJA-1; Tue, 08 Nov 2022 17:19:50 -0500
X-MC-Unique: WWwE2_H5OuOnVGMEbHoqJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0CAE101A52A;
        Tue,  8 Nov 2022 22:19:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ABDBC15BB5;
        Tue,  8 Nov 2022 22:19:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 18/26] rxrpc: Split the rxrpc_recvmsg tracepoint
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:47 +0000
Message-ID: <166794598763.2389296.15095258096808573588.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the rxrpc_recvmsg tracepoint so that the tracepoints that are about
data packet processing (and which have extra pieces of information) are
separate from the tracepoint that shows the general flow of recvmsg().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   24 ++++++++++++++++++++++++
 net/rxrpc/recvmsg.c          |   37 ++++++++++++++++++-------------------
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index d32e9858c682..84464b29e54a 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -885,6 +885,30 @@ TRACE_EVENT(rxrpc_receive,
 	    );
 
 TRACE_EVENT(rxrpc_recvmsg,
+	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_recvmsg_trace why,
+		     int ret),
+
+	    TP_ARGS(call, why, ret),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		call		)
+		    __field(enum rxrpc_recvmsg_trace,	why		)
+		    __field(int,			ret		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call = call ? call->debug_id : 0;
+		    __entry->why = why;
+		    __entry->ret = ret;
+			   ),
+
+	    TP_printk("c=%08x %s ret=%d",
+		      __entry->call,
+		      __print_symbolic(__entry->why, rxrpc_recvmsg_traces),
+		      __entry->ret)
+	    );
+
+TRACE_EVENT(rxrpc_recvdata,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_recvmsg_trace why,
 		     rxrpc_seq_t seq, unsigned int offset, unsigned int len,
 		     int ret),
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 46e784edc0f4..77cde6311559 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -173,8 +173,8 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
 		break;
 	}
 
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_terminal, call->rx_hard_ack,
-			    call->rx_pkt_offset, call->rx_pkt_len, ret);
+	trace_rxrpc_recvdata(call, rxrpc_recvmsg_terminal, call->rx_hard_ack,
+			     call->rx_pkt_offset, call->rx_pkt_len, ret);
 	return ret;
 }
 
@@ -380,8 +380,8 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		ix = seq & RXRPC_RXTX_BUFF_MASK;
 		skb = call->rxtx_buffer[ix];
 		if (!skb) {
-			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_hole, seq,
-					    rx_pkt_offset, rx_pkt_len, 0);
+			trace_rxrpc_recvdata(call, rxrpc_recvmsg_hole, seq,
+					     rx_pkt_offset, rx_pkt_len, 0);
 			rxrpc_transmit_ack_packets(call->peer->local);
 			break;
 		}
@@ -404,15 +404,15 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 						 &call->rxtx_annotations[ix],
 						 &rx_pkt_offset, &rx_pkt_len,
 						 &rx_pkt_last);
-			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_next, seq,
-					    rx_pkt_offset, rx_pkt_len, ret2);
+			trace_rxrpc_recvdata(call, rxrpc_recvmsg_next, seq,
+					     rx_pkt_offset, rx_pkt_len, ret2);
 			if (ret2 < 0) {
 				ret = ret2;
 				goto out;
 			}
 		} else {
-			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_cont, seq,
-					    rx_pkt_offset, rx_pkt_len, 0);
+			trace_rxrpc_recvdata(call, rxrpc_recvmsg_cont, seq,
+					     rx_pkt_offset, rx_pkt_len, 0);
 		}
 
 		/* We have to handle short, empty and used-up DATA packets. */
@@ -435,8 +435,8 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		}
 
 		if (rx_pkt_len > 0) {
-			trace_rxrpc_recvmsg(call, rxrpc_recvmsg_full, seq,
-					    rx_pkt_offset, rx_pkt_len, 0);
+			trace_rxrpc_recvdata(call, rxrpc_recvmsg_full, seq,
+					     rx_pkt_offset, rx_pkt_len, 0);
 			ASSERTCMP(*_offset, ==, len);
 			ret = 0;
 			break;
@@ -464,8 +464,8 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		call->rx_pkt_last = rx_pkt_last;
 	}
 done:
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_data_return, seq,
-			    rx_pkt_offset, rx_pkt_len, ret);
+	trace_rxrpc_recvdata(call, rxrpc_recvmsg_data_return, seq,
+			     rx_pkt_offset, rx_pkt_len, ret);
 	if (ret == -EAGAIN)
 		set_bit(RXRPC_CALL_RX_UNDERRUN, &call->flags);
 	return ret;
@@ -488,7 +488,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	DEFINE_WAIT(wait);
 
-	trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_enter, 0, 0, 0, 0);
+	trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_enter, 0);
 
 	if (flags & (MSG_OOB | MSG_TRUNC))
 		return -EOPNOTSUPP;
@@ -525,8 +525,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (list_empty(&rx->recvmsg_q)) {
 			if (signal_pending(current))
 				goto wait_interrupted;
-			trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_wait,
-					    0, 0, 0, 0);
+			trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_wait, 0);
 			timeo = schedule_timeout(timeo);
 		}
 		finish_wait(sk_sleep(&rx->sk), &wait);
@@ -545,7 +544,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		rxrpc_get_call(call, rxrpc_call_got);
 	write_unlock_bh(&rx->recvmsg_lock);
 
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0, 0, 0, 0);
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0);
 
 	/* We're going to drop the socket lock, so we need to lock the call
 	 * against interference by sendmsg.
@@ -630,7 +629,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 error_unlock_call:
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, 0, 0, 0, ret);
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, ret);
 	return ret;
 
 error_requeue_call:
@@ -638,14 +637,14 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		write_lock_bh(&rx->recvmsg_lock);
 		list_add(&call->recvmsg_link, &rx->recvmsg_q);
 		write_unlock_bh(&rx->recvmsg_lock);
-		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0, 0, 0, 0);
+		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put);
 	}
 error_no_call:
 	release_sock(&rx->sk);
 error_trace:
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, 0, 0, 0, ret);
+	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, ret);
 	return ret;
 
 wait_interrupted:


