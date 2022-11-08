Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7E621F15
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiKHWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiKHWUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:20:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09D0657E9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYcKuKVsYJxz8OW/FIqG+8k515MDsI9VvgeoFQLsZm8=;
        b=XznA79twJacNlqflMy0apcq8clWbZHIFsDpJeFDegj+m/r5CyeBcUlIk4eE8pxic/EdNDS
        YlwjcUPEEi46PvJqixor4tN7Cx67RVkmQxgULtghQbu9+s/StANWCJj/LZzQofTMFo+p35
        StZdDY076Jf4ulBowBZTbqKI0CBtKoM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-WqyTT54xMGGhIYGsGxnNgA-1; Tue, 08 Nov 2022 17:19:29 -0500
X-MC-Unique: WqyTT54xMGGhIYGsGxnNgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F0493801143;
        Tue,  8 Nov 2022 22:19:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC06D2028CE4;
        Tue,  8 Nov 2022 22:19:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 15/26] rxrpc: Define rxrpc_txbuf struct to carry data
 to be transmitted
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:28 +0000
Message-ID: <166794596815.2389296.6345159532020707046.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a struct, rxrpc_txbuf, to carry data to be transmitted instead of a
socket buffer so that it can be placed onto multiple queues at once.  This
also allows the data buffer to be in the same allocation as the internal
data.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   45 +++++++++++++++++++
 net/rxrpc/Makefile           |    1 
 net/rxrpc/ar-internal.h      |   53 ++++++++++++++++++++++
 net/rxrpc/proc.c             |    3 +
 net/rxrpc/txbuf.c            |  100 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 201 insertions(+), 1 deletion(-)
 create mode 100644 net/rxrpc/txbuf.c

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 484c8d032ab8..47b157b1d32b 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -252,6 +252,18 @@
 	E_(rxrpc_reqack_small_txwin,		"SMALL-TXWN")
 /* ---- Must update size of stat_why_req_ack[] if more are added! */
 
+#define rxrpc_txbuf_traces \
+	EM(rxrpc_txbuf_alloc_ack,		"ALLOC ACK  ")	\
+	EM(rxrpc_txbuf_alloc_data,		"ALLOC DATA ")	\
+	EM(rxrpc_txbuf_free,			"FREE       ")	\
+	EM(rxrpc_txbuf_get_trans,		"GET TRANS  ")	\
+	EM(rxrpc_txbuf_get_retrans,		"GET RETRANS")	\
+	EM(rxrpc_txbuf_put_cleaned,		"PUT CLEANED")	\
+	EM(rxrpc_txbuf_put_rotated,		"PUT ROTATED")	\
+	EM(rxrpc_txbuf_put_send_aborted,	"PUT SEND-X ")	\
+	EM(rxrpc_txbuf_see_send_more,		"SEE SEND+  ")	\
+	E_(rxrpc_txbuf_see_unacked,		"SEE UNACKED")
+
 /*
  * Generate enums for tracing information.
  */
@@ -280,6 +292,7 @@ enum rxrpc_skb_trace		{ rxrpc_skb_traces } __mode(byte);
 enum rxrpc_timer_trace		{ rxrpc_timer_traces } __mode(byte);
 enum rxrpc_transmit_trace	{ rxrpc_transmit_traces } __mode(byte);
 enum rxrpc_tx_point		{ rxrpc_tx_points } __mode(byte);
+enum rxrpc_txbuf_trace		{ rxrpc_txbuf_traces } __mode(byte);
 
 #endif /* end __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY */
 
@@ -308,6 +321,7 @@ rxrpc_skb_traces;
 rxrpc_timer_traces;
 rxrpc_transmit_traces;
 rxrpc_tx_points;
+rxrpc_txbuf_traces;
 
 /*
  * Now redefine the EM() and E_() macros to map the enums to the strings that
@@ -1469,6 +1483,37 @@ TRACE_EVENT(rxrpc_req_ack,
 		      __print_symbolic(__entry->why, rxrpc_req_ack_traces))
 	    );
 
+TRACE_EVENT(rxrpc_txbuf,
+	    TP_PROTO(unsigned int debug_id,
+		     unsigned int call_debug_id, rxrpc_seq_t seq,
+		     int ref, enum rxrpc_txbuf_trace what),
+
+	    TP_ARGS(debug_id, call_debug_id, seq, ref, what),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		debug_id	)
+		    __field(unsigned int,		call_debug_id	)
+		    __field(rxrpc_seq_t,		seq		)
+		    __field(int,			ref		)
+		    __field(enum rxrpc_txbuf_trace,	what		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->debug_id = debug_id;
+		    __entry->call_debug_id = call_debug_id;
+		    __entry->seq = seq;
+		    __entry->ref = ref;
+		    __entry->what = what;
+			   ),
+
+	    TP_printk("B=%08x c=%08x q=%08x %s r=%d",
+		      __entry->debug_id,
+		      __entry->call_debug_id,
+		      __entry->seq,
+		      __print_symbolic(__entry->what, rxrpc_txbuf_traces),
+		      __entry->ref)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _TRACE_RXRPC_H */
diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index b11281bed2a4..fdeba488fc6e 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -30,6 +30,7 @@ rxrpc-y := \
 	sendmsg.o \
 	server_key.o \
 	skbuff.o \
+	txbuf.o \
 	utils.o
 
 rxrpc-$(CONFIG_PROC_FS) += proc.o
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 282cb986f8a7..49e90614d5e5 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -29,6 +29,7 @@ struct rxrpc_crypt {
 
 struct key_preparsed_payload;
 struct rxrpc_connection;
+struct rxrpc_txbuf;
 
 /*
  * Mark applied to socket buffers in skb->mark.  skb->priority is used
@@ -759,6 +760,48 @@ struct rxrpc_send_params {
 	bool			upgrade;	/* If the connection is upgradeable */
 };
 
+/*
+ * Buffer of data to be output as a packet.
+ */
+struct rxrpc_txbuf {
+	struct rcu_head		rcu;
+	struct list_head	call_link;	/* Link in call->tx_queue */
+	struct list_head	tx_link;	/* Link in live Enc queue or Tx queue */
+	struct rxrpc_call	*call;		/* Call to which belongs */
+	ktime_t			last_sent;	/* Time at which last transmitted */
+	refcount_t		ref;
+	rxrpc_seq_t		seq;		/* Sequence number of this packet */
+	unsigned int		call_debug_id;
+	unsigned int		debug_id;
+	unsigned int		len;		/* Amount of data in buffer */
+	unsigned int		space;		/* Remaining data space */
+	unsigned int		offset;		/* Offset of fill point */
+	unsigned long		flags;
+#define RXRPC_TXBUF_ACKED	0		/* Set if ACK'd */
+#define RXRPC_TXBUF_NACKED	1		/* Set if NAK'd */
+#define RXRPC_TXBUF_LAST	2		/* Set if last packet in Tx phase */
+#define RXRPC_TXBUF_RESENT	3		/* Set if has been resent */
+#define RXRPC_TXBUF_RETRANS	4		/* Set if should be retransmitted */
+	struct {
+		/* The packet for encrypting and DMA'ing.  We align it such
+		 * that data[] aligns correctly for any crypto blocksize.
+		 */
+		u8		pad[64 - sizeof(struct rxrpc_wire_header)];
+		struct rxrpc_wire_header wire;	/* Network-ready header */
+		u8		data[RXRPC_JUMBO_DATALEN]; /* Data packet */
+	} __aligned(64);
+};
+
+static inline bool rxrpc_sending_to_server(const struct rxrpc_txbuf *txb)
+{
+	return txb->wire.flags & RXRPC_CLIENT_INITIATED;
+}
+
+static inline bool rxrpc_sending_to_client(const struct rxrpc_txbuf *txb)
+{
+	return !rxrpc_sending_to_server(txb);
+}
+
 #include <trace/events/rxrpc.h>
 
 /*
@@ -1125,6 +1168,16 @@ static inline int __init rxrpc_sysctl_init(void) { return 0; }
 static inline void rxrpc_sysctl_exit(void) {}
 #endif
 
+/*
+ * txbuf.c
+ */
+extern atomic_t rxrpc_nr_txbuf;
+struct rxrpc_txbuf *rxrpc_alloc_txbuf(struct rxrpc_call *call, u8 packet_type,
+				      gfp_t gfp);
+void rxrpc_get_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what);
+void rxrpc_see_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what);
+void rxrpc_put_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what);
+
 /*
  * utils.c
  */
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 9bd357f39c39..3877afd23598 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -458,7 +458,8 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_slow_start]),
 		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_small_txwin]));
 	seq_printf(seq,
-		   "Buffers  : txb=%u rxb=%u\n",
+		   "Buffers  : txb=%u,%u rxb=%u\n",
+		   atomic_read(&rxrpc_nr_txbuf),
 		   atomic_read(&rxrpc_n_tx_skbs),
 		   atomic_read(&rxrpc_n_rx_skbs));
 	return 0;
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
new file mode 100644
index 000000000000..66d922ad65d0
--- /dev/null
+++ b/net/rxrpc/txbuf.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* RxRPC Tx data buffering.
+ *
+ * Copyright (C) 2022 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
+#include "ar-internal.h"
+
+static atomic_t rxrpc_txbuf_debug_ids;
+atomic_t rxrpc_nr_txbuf;
+
+/*
+ * Allocate and partially initialise an I/O request structure.
+ */
+struct rxrpc_txbuf *rxrpc_alloc_txbuf(struct rxrpc_call *call, u8 packet_type,
+				      gfp_t gfp)
+{
+	struct rxrpc_txbuf *txb;
+
+	txb = kmalloc(sizeof(*txb), gfp);
+	if (txb) {
+		INIT_LIST_HEAD(&txb->call_link);
+		INIT_LIST_HEAD(&txb->tx_link);
+		refcount_set(&txb->ref, 1);
+		txb->call		= call;
+		txb->call_debug_id	= call->debug_id;
+		txb->debug_id		= atomic_inc_return(&rxrpc_txbuf_debug_ids);
+		txb->space		= sizeof(txb->data);
+		txb->len		= 0;
+		txb->offset		= 0;
+		txb->flags		= 0;
+		txb->seq		= call->tx_top + 1;
+		txb->wire.epoch		= htonl(call->conn->proto.epoch);
+		txb->wire.cid		= htonl(call->cid);
+		txb->wire.callNumber	= htonl(call->call_id);
+		txb->wire.seq		= htonl(txb->seq);
+		txb->wire.type		= packet_type;
+		txb->wire.flags		= call->conn->out_clientflag;
+		txb->wire.userStatus	= 0;
+		txb->wire.securityIndex	= call->security_ix;
+		txb->wire._rsvd		= 0;
+		txb->wire.serviceId	= htons(call->service_id);
+
+		trace_rxrpc_txbuf(txb->debug_id,
+				  txb->call_debug_id, txb->seq, 1,
+				  packet_type == RXRPC_PACKET_TYPE_DATA ?
+				  rxrpc_txbuf_alloc_data :
+				  rxrpc_txbuf_alloc_ack);
+		atomic_inc(&rxrpc_nr_txbuf);
+	}
+
+	return txb;
+}
+
+void rxrpc_get_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what)
+{
+	int r;
+
+	__refcount_inc(&txb->ref, &r);
+	trace_rxrpc_txbuf(txb->debug_id, txb->call_debug_id, txb->seq, r + 1, what);
+}
+
+void rxrpc_see_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what)
+{
+	int r = refcount_read(&txb->ref);
+
+	trace_rxrpc_txbuf(txb->debug_id, txb->call_debug_id, txb->seq, r, what);
+}
+
+static void rxrpc_free_txbuf(struct rcu_head *rcu)
+{
+	struct rxrpc_txbuf *txb = container_of(rcu, struct rxrpc_txbuf, rcu);
+
+	trace_rxrpc_txbuf(txb->debug_id, txb->call_debug_id, txb->seq, 0,
+			  rxrpc_txbuf_free);
+	kfree(txb);
+	atomic_dec(&rxrpc_nr_txbuf);
+}
+
+void rxrpc_put_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what)
+{
+	unsigned int debug_id, call_debug_id;
+	rxrpc_seq_t seq;
+	bool dead;
+	int r;
+
+	if (txb) {
+		debug_id = txb->debug_id;
+		call_debug_id = txb->call_debug_id;
+		seq = txb->seq;
+		dead = __refcount_dec_and_test(&txb->ref, &r);
+		trace_rxrpc_txbuf(debug_id, call_debug_id, seq, r - 1, what);
+		if (dead)
+			call_rcu(&txb->rcu, rxrpc_free_txbuf);
+	}
+}


