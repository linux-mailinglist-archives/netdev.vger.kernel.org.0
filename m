Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D049934D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbfHVMYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732447AbfHVMYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:24:18 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F5212E95AC;
        Thu, 22 Aug 2019 12:24:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C2AC60166;
        Thu, 22 Aug 2019 12:24:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 7/9] rxrpc: Add a shadow refcount in the skb private data
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 13:24:14 +0100
Message-ID: <156647665408.11061.4204790133695737164.stgit@warthog.procyon.org.uk>
In-Reply-To: <156647659913.11061.13764606104739742865.stgit@warthog.procyon.org.uk>
References: <156647659913.11061.13764606104739742865.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 22 Aug 2019 12:24:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a shadow refcount to count pins from the Rx/Tx ring on an sk_buff so
that we can hold multiple refs on it without causing skb_cow_data() to
throw an assertion.

This is stored in the private part of the sk_buff as laid out in struct
rxrpc_skb_priv.

Add two accessor functions for pinning (adding) or unpinning (discarding) a
shadow ref.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |   15 ++++++++---
 net/rxrpc/ar-internal.h      |    2 +
 net/rxrpc/skbuff.c           |   57 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index e2356c51883b..34237ea8ceb0 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -28,10 +28,12 @@ enum rxrpc_skb_trace {
 	rxrpc_skb_got,
 	rxrpc_skb_lost,
 	rxrpc_skb_new,
+	rxrpc_skb_pin,
 	rxrpc_skb_purged,
 	rxrpc_skb_received,
 	rxrpc_skb_rotated,
 	rxrpc_skb_seen,
+	rxrpc_skb_unpin,
 };
 
 enum rxrpc_local_trace {
@@ -228,10 +230,12 @@ enum rxrpc_tx_point {
 	EM(rxrpc_skb_got,			"GOT") \
 	EM(rxrpc_skb_lost,			"*L*") \
 	EM(rxrpc_skb_new,			"NEW") \
+	EM(rxrpc_skb_pin,			"PIN") \
 	EM(rxrpc_skb_purged,			"PUR") \
 	EM(rxrpc_skb_received,			"RCV") \
 	EM(rxrpc_skb_rotated,			"ROT") \
-	E_(rxrpc_skb_seen,			"SEE")
+	EM(rxrpc_skb_seen,			"SEE") \
+	E_(rxrpc_skb_unpin,			"UPN")
 
 #define rxrpc_local_traces \
 	EM(rxrpc_local_got,			"GOT") \
@@ -633,14 +637,15 @@ TRACE_EVENT(rxrpc_call,
 
 TRACE_EVENT(rxrpc_skb,
 	    TP_PROTO(struct sk_buff *skb, enum rxrpc_skb_trace op,
-		     int usage, int mod_count, const void *where),
+		     int usage, int mod_count, int pins, const void *where),
 
-	    TP_ARGS(skb, op, usage, mod_count, where),
+	    TP_ARGS(skb, op, usage, mod_count, pins, where),
 
 	    TP_STRUCT__entry(
 		    __field(struct sk_buff *,		skb		)
 		    __field(enum rxrpc_skb_trace,	op		)
 		    __field(u8,				flags		)
+		    __field(u8,				pins		)
 		    __field(int,			usage		)
 		    __field(int,			mod_count	)
 		    __field(const void *,		where		)
@@ -651,16 +656,18 @@ TRACE_EVENT(rxrpc_skb,
 		    __entry->flags = rxrpc_skb(skb)->rx_flags;
 		    __entry->op = op;
 		    __entry->usage = usage;
+		    __entry->pins = pins;
 		    __entry->mod_count = mod_count;
 		    __entry->where = where;
 			   ),
 
-	    TP_printk("s=%p %cx %s u=%d m=%d p=%pSR",
+	    TP_printk("s=%p %cx %s u=%d m=%d r=%u p=%pSR",
 		      __entry->skb,
 		      __entry->flags & RXRPC_SKB_TX_BUFFER ? 'T' : 'R',
 		      __print_symbolic(__entry->op, rxrpc_skb_traces),
 		      __entry->usage,
 		      __entry->mod_count,
+		      __entry->pins,
 		      __entry->where)
 	    );
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 2d5294f3e62f..d784d58e0a0d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1113,6 +1113,8 @@ void rxrpc_see_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_get_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_free_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_purge_queue(struct sk_buff_head *);
+void rxrpc_pin_skb(struct sk_buff *, enum rxrpc_skb_trace);
+void rxrpc_unpin_skb(struct sk_buff *, enum rxrpc_skb_trace);
 
 /*
  * sysctl.c
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 8e6f45f84b9b..f9986a1510d3 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -22,9 +22,12 @@
  */
 void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+
+	atomic_set(&sp->nr_ring_pins, 1);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, 1, here);
 }
 
 /*
@@ -33,9 +36,12 @@ void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
+
 	if (skb) {
+		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 		int n = atomic_read(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+				atomic_read(&sp->nr_ring_pins), here);
 	}
 }
 
@@ -44,9 +50,11 @@ void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
  */
 void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(skb));
-	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+			atomic_read(&sp->nr_ring_pins), here);
 	skb_get(skb);
 }
 
@@ -56,11 +64,14 @@ void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
+
 	if (skb) {
+		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 		int n;
 		CHECK_SLAB_OKAY(&skb->users);
 		n = atomic_dec_return(select_skb_count(skb));
-		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n,
+				atomic_read(&sp->nr_ring_pins), here);
 		kfree_skb(skb);
 	}
 }
@@ -72,10 +83,46 @@ void rxrpc_purge_queue(struct sk_buff_head *list)
 {
 	const void *here = __builtin_return_address(0);
 	struct sk_buff *skb;
+
 	while ((skb = skb_dequeue((list))) != NULL) {
+		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 		int n = atomic_dec_return(select_skb_count(skb));
 		trace_rxrpc_skb(skb, rxrpc_skb_purged,
-				refcount_read(&skb->users), n, here);
+				refcount_read(&skb->users), n,
+				atomic_read(&sp->nr_ring_pins), here);
 		kfree_skb(skb);
 	}
 }
+
+/*
+ * Add a secondary ref on the socket buffer.
+ */
+void rxrpc_pin_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	const void *here = __builtin_return_address(0);
+	int n = atomic_read(select_skb_count(skb));
+	int np;
+
+	np = atomic_inc_return(&sp->nr_ring_pins);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, np, here);
+}
+
+/*
+ * Remove a secondary ref on the socket buffer.
+ */
+void rxrpc_unpin_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
+{
+	const void *here = __builtin_return_address(0);
+
+	if (skb) {
+		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+		int n = atomic_read(select_skb_count(skb));
+		int np;
+
+		np = atomic_dec_return(&sp->nr_ring_pins);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, np, here);
+		if (np == 0)
+			rxrpc_free_skb(skb, op);
+	}
+}

