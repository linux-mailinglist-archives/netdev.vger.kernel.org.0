Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E121DC2CA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgETXWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:22:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44994 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728741AbgETXWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590016920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SH5lMdaEM7GLgj2ga2s7OYqUE66edMWtSLq4ISynuWU=;
        b=iuA/jjs/jl71IlOcfKLSqnJYlLHY01Y1a1qaqgy9xlE9emFkxW5DkwGTOpm84lbgidk0KO
        pNAIqUdcgDl5iYh2JW2Oibp4nJfTthfQBrKJ9VRoHLYwUZ3eU2006h/spc0Xl/BuWIAOXT
        gaW7ypdIWHUKaJBMrXech2+r0NbLwqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-BPlJwSgQMiyWwCGxXiFKaA-1; Wed, 20 May 2020 19:21:52 -0400
X-MC-Unique: BPlJwSgQMiyWwCGxXiFKaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 413B8835B40;
        Wed, 20 May 2020 23:21:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03BEB5C1D0;
        Wed, 20 May 2020 23:21:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/3] rxrpc: Fix the excessive initial retransmission
 timeout
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 00:21:49 +0100
Message-ID: <159001690903.18663.2345549941598300103.stgit@warthog.procyon.org.uk>
In-Reply-To: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
References: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc currently uses a fixed 4s retransmission timeout until the RTT is
sufficiently sampled.  This can cause problems with some fileservers with
calls to the cache manager in the afs filesystem being dropped from the
fileserver because a packet goes missing and the retransmission timeout is
greater than the call expiry timeout.

Fix this by:

 (1) Copying the RTT/RTO calculation code from Linux's TCP implementation
     and altering it to fit rxrpc.

 (2) Altering the various users of the RTT to make use of the new SRTT
     value.

 (3) Replacing the use of rxrpc_resend_timeout to use the calculated RTO
     value instead (which is needed in jiffies), along with a backoff.

Notes:

 (1) rxrpc provides RTT samples by matching the serial numbers on outgoing
     DATA packets that have the RXRPC_REQUEST_ACK set and PING ACK packets
     against the reference serial number in incoming REQUESTED ACK and
     PING-RESPONSE ACK packets.

 (2) Each packet that is transmitted on an rxrpc connection gets a new
     per-connection serial number, even for retransmissions, so an ACK can
     be cross-referenced to a specific trigger packet.  This allows RTT
     information to be drawn from retransmitted DATA packets also.

 (3) rxrpc maintains the RTT/RTO state on the rxrpc_peer record rather than
     on an rxrpc_call because many RPC calls won't live long enough to
     generate more than one sample.

 (4) The calculated SRTT value is in units of 8ths of a microsecond rather
     than nanoseconds.

The (S)RTT and RTO values are displayed in /proc/net/rxrpc/peers.

Fixes: 17926a79320a ([AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both"")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/fs_probe.c            |   18 +---
 fs/afs/vl_probe.c            |   18 +---
 include/net/af_rxrpc.h       |    2 
 include/trace/events/rxrpc.h |   17 ++--
 net/rxrpc/Makefile           |    1 
 net/rxrpc/ar-internal.h      |   25 ++++-
 net/rxrpc/call_accept.c      |    2 
 net/rxrpc/call_event.c       |   22 ++---
 net/rxrpc/input.c            |    6 +
 net/rxrpc/misc.c             |    5 -
 net/rxrpc/output.c           |    9 +-
 net/rxrpc/peer_event.c       |   46 ----------
 net/rxrpc/peer_object.c      |   12 ++-
 net/rxrpc/proc.c             |    8 +-
 net/rxrpc/rtt.c              |  195 ++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/sendmsg.c          |   26 ++----
 net/rxrpc/sysctl.c           |    9 --
 17 files changed, 266 insertions(+), 155 deletions(-)
 create mode 100644 net/rxrpc/rtt.c

diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index a587767b6ae1..237352d3cb53 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -32,9 +32,8 @@ void afs_fileserver_probe_result(struct afs_call *call)
 	struct afs_server *server = call->server;
 	unsigned int server_index = call->server_index;
 	unsigned int index = call->addr_ix;
-	unsigned int rtt = UINT_MAX;
+	unsigned int rtt_us;
 	bool have_result = false;
-	u64 _rtt;
 	int ret = call->error;
 
 	_enter("%pU,%u", &server->uuid, index);
@@ -93,15 +92,9 @@ void afs_fileserver_probe_result(struct afs_call *call)
 		}
 	}
 
-	/* Get the RTT and scale it to fit into a 32-bit value that represents
-	 * over a minute of time so that we can access it with one instruction
-	 * on a 32-bit system.
-	 */
-	_rtt = rxrpc_kernel_get_rtt(call->net->socket, call->rxcall);
-	_rtt /= 64;
-	rtt = (_rtt > UINT_MAX) ? UINT_MAX : _rtt;
-	if (rtt < server->probe.rtt) {
-		server->probe.rtt = rtt;
+	rtt_us = rxrpc_kernel_get_srtt(call->net->socket, call->rxcall);
+	if (rtt_us < server->probe.rtt) {
+		server->probe.rtt = rtt_us;
 		alist->preferred = index;
 		have_result = true;
 	}
@@ -113,8 +106,7 @@ void afs_fileserver_probe_result(struct afs_call *call)
 	spin_unlock(&server->probe_lock);
 
 	_debug("probe [%u][%u] %pISpc rtt=%u ret=%d",
-	       server_index, index, &alist->addrs[index].transport,
-	       (unsigned int)rtt, ret);
+	       server_index, index, &alist->addrs[index].transport, rtt_us, ret);
 
 	have_result |= afs_fs_probe_done(server);
 	if (have_result)
diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index 858498cc1b05..e3aa013c2177 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -31,10 +31,9 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	struct afs_addr_list *alist = call->alist;
 	struct afs_vlserver *server = call->vlserver;
 	unsigned int server_index = call->server_index;
+	unsigned int rtt_us = 0;
 	unsigned int index = call->addr_ix;
-	unsigned int rtt = UINT_MAX;
 	bool have_result = false;
-	u64 _rtt;
 	int ret = call->error;
 
 	_enter("%s,%u,%u,%d,%d", server->name, server_index, index, ret, call->abort_code);
@@ -93,15 +92,9 @@ void afs_vlserver_probe_result(struct afs_call *call)
 		}
 	}
 
-	/* Get the RTT and scale it to fit into a 32-bit value that represents
-	 * over a minute of time so that we can access it with one instruction
-	 * on a 32-bit system.
-	 */
-	_rtt = rxrpc_kernel_get_rtt(call->net->socket, call->rxcall);
-	_rtt /= 64;
-	rtt = (_rtt > UINT_MAX) ? UINT_MAX : _rtt;
-	if (rtt < server->probe.rtt) {
-		server->probe.rtt = rtt;
+	rtt_us = rxrpc_kernel_get_srtt(call->net->socket, call->rxcall);
+	if (rtt_us < server->probe.rtt) {
+		server->probe.rtt = rtt_us;
 		alist->preferred = index;
 		have_result = true;
 	}
@@ -113,8 +106,7 @@ void afs_vlserver_probe_result(struct afs_call *call)
 	spin_unlock(&server->probe_lock);
 
 	_debug("probe [%u][%u] %pISpc rtt=%u ret=%d",
-	       server_index, index, &alist->addrs[index].transport,
-	       (unsigned int)rtt, ret);
+	       server_index, index, &alist->addrs[index].transport, rtt_us, ret);
 
 	have_result |= afs_vl_probe_done(server);
 	if (have_result) {
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index 04e97bab6f28..ab988940bf04 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -59,7 +59,7 @@ bool rxrpc_kernel_abort_call(struct socket *, struct rxrpc_call *,
 void rxrpc_kernel_end_call(struct socket *, struct rxrpc_call *);
 void rxrpc_kernel_get_peer(struct socket *, struct rxrpc_call *,
 			   struct sockaddr_rxrpc *);
-u64 rxrpc_kernel_get_rtt(struct socket *, struct rxrpc_call *);
+u32 rxrpc_kernel_get_srtt(struct socket *, struct rxrpc_call *);
 int rxrpc_kernel_charge_accept(struct socket *, rxrpc_notify_rx_t,
 			       rxrpc_user_attach_call_t, unsigned long, gfp_t,
 			       unsigned int);
diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 191fe447f990..ab75f261f04a 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1112,18 +1112,17 @@ TRACE_EVENT(rxrpc_rtt_tx,
 TRACE_EVENT(rxrpc_rtt_rx,
 	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
 		     rxrpc_serial_t send_serial, rxrpc_serial_t resp_serial,
-		     s64 rtt, u8 nr, s64 avg),
+		     u32 rtt, u32 rto),
 
-	    TP_ARGS(call, why, send_serial, resp_serial, rtt, nr, avg),
+	    TP_ARGS(call, why, send_serial, resp_serial, rtt, rto),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
 		    __field(enum rxrpc_rtt_rx_trace,	why		)
-		    __field(u8,				nr		)
 		    __field(rxrpc_serial_t,		send_serial	)
 		    __field(rxrpc_serial_t,		resp_serial	)
-		    __field(s64,			rtt		)
-		    __field(u64,			avg		)
+		    __field(u32,			rtt		)
+		    __field(u32,			rto		)
 			     ),
 
 	    TP_fast_assign(
@@ -1132,18 +1131,16 @@ TRACE_EVENT(rxrpc_rtt_rx,
 		    __entry->send_serial = send_serial;
 		    __entry->resp_serial = resp_serial;
 		    __entry->rtt = rtt;
-		    __entry->nr = nr;
-		    __entry->avg = avg;
+		    __entry->rto = rto;
 			   ),
 
-	    TP_printk("c=%08x %s sr=%08x rr=%08x rtt=%lld nr=%u avg=%lld",
+	    TP_printk("c=%08x %s sr=%08x rr=%08x rtt=%u rto=%u",
 		      __entry->call,
 		      __print_symbolic(__entry->why, rxrpc_rtt_rx_traces),
 		      __entry->send_serial,
 		      __entry->resp_serial,
 		      __entry->rtt,
-		      __entry->nr,
-		      __entry->avg)
+		      __entry->rto)
 	    );
 
 TRACE_EVENT(rxrpc_timer,
diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index 6ffb7e9887ce..ddd0f95713a9 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -25,6 +25,7 @@ rxrpc-y := \
 	peer_event.o \
 	peer_object.o \
 	recvmsg.o \
+	rtt.o \
 	security.o \
 	sendmsg.o \
 	skbuff.o \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 3eb1ab40ca5c..9fe264bec70c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -7,6 +7,7 @@
 
 #include <linux/atomic.h>
 #include <linux/seqlock.h>
+#include <linux/win_minmax.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/sock.h>
@@ -311,11 +312,14 @@ struct rxrpc_peer {
 #define RXRPC_RTT_CACHE_SIZE 32
 	spinlock_t		rtt_input_lock;	/* RTT lock for input routine */
 	ktime_t			rtt_last_req;	/* Time of last RTT request */
-	u64			rtt;		/* Current RTT estimate (in nS) */
-	u64			rtt_sum;	/* Sum of cache contents */
-	u64			rtt_cache[RXRPC_RTT_CACHE_SIZE]; /* Determined RTT cache */
-	u8			rtt_cursor;	/* next entry at which to insert */
-	u8			rtt_usage;	/* amount of cache actually used */
+	unsigned int		rtt_count;	/* Number of samples we've got */
+
+	u32			srtt_us;	/* smoothed round trip time << 3 in usecs */
+	u32			mdev_us;	/* medium deviation			*/
+	u32			mdev_max_us;	/* maximal mdev for the last rtt period	*/
+	u32			rttvar_us;	/* smoothed mdev_max			*/
+	u32			rto_j;		/* Retransmission timeout in jiffies */
+	u8			backoff;	/* Backoff timeout */
 
 	u8			cong_cwnd;	/* Congestion window size */
 };
@@ -1041,7 +1045,6 @@ extern unsigned long rxrpc_idle_ack_delay;
 extern unsigned int rxrpc_rx_window_size;
 extern unsigned int rxrpc_rx_mtu;
 extern unsigned int rxrpc_rx_jumbo_max;
-extern unsigned long rxrpc_resend_timeout;
 
 extern const s8 rxrpc_ack_priority[];
 
@@ -1069,8 +1072,6 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
  * peer_event.c
  */
 void rxrpc_error_report(struct sock *);
-void rxrpc_peer_add_rtt(struct rxrpc_call *, enum rxrpc_rtt_rx_trace,
-			rxrpc_serial_t, rxrpc_serial_t, ktime_t, ktime_t);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
 /*
@@ -1102,6 +1103,14 @@ extern const struct seq_operations rxrpc_peer_seq_ops;
 void rxrpc_notify_socket(struct rxrpc_call *);
 int rxrpc_recvmsg(struct socket *, struct msghdr *, size_t, int);
 
+/*
+ * rtt.c
+ */
+void rxrpc_peer_add_rtt(struct rxrpc_call *, enum rxrpc_rtt_rx_trace,
+			rxrpc_serial_t, rxrpc_serial_t, ktime_t, ktime_t);
+unsigned long rxrpc_get_rto_backoff(struct rxrpc_peer *, bool);
+void rxrpc_peer_init_rtt(struct rxrpc_peer *);
+
 /*
  * rxkad.c
  */
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 70e44abf106c..b7611cc159e5 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -248,7 +248,7 @@ static void rxrpc_send_ping(struct rxrpc_call *call, struct sk_buff *skb)
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	ktime_t now = skb->tstamp;
 
-	if (call->peer->rtt_usage < 3 ||
+	if (call->peer->rtt_count < 3 ||
 	    ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000), now))
 		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
 				  true, true,
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index cedbbb3a7c2e..2a65ac41055f 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -111,8 +111,8 @@ static void __rxrpc_propose_ACK(struct rxrpc_call *call, u8 ack_reason,
 	} else {
 		unsigned long now = jiffies, ack_at;
 
-		if (call->peer->rtt_usage > 0)
-			ack_at = nsecs_to_jiffies(call->peer->rtt);
+		if (call->peer->srtt_us != 0)
+			ack_at = usecs_to_jiffies(call->peer->srtt_us >> 3);
 		else
 			ack_at = expiry;
 
@@ -157,24 +157,18 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
 static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 {
 	struct sk_buff *skb;
-	unsigned long resend_at;
+	unsigned long resend_at, rto_j;
 	rxrpc_seq_t cursor, seq, top;
-	ktime_t now, max_age, oldest, ack_ts, timeout, min_timeo;
+	ktime_t now, max_age, oldest, ack_ts;
 	int ix;
 	u8 annotation, anno_type, retrans = 0, unacked = 0;
 
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
-	if (call->peer->rtt_usage > 1)
-		timeout = ns_to_ktime(call->peer->rtt * 3 / 2);
-	else
-		timeout = ms_to_ktime(rxrpc_resend_timeout);
-	min_timeo = ns_to_ktime((1000000000 / HZ) * 4);
-	if (ktime_before(timeout, min_timeo))
-		timeout = min_timeo;
+	rto_j = call->peer->rto_j;
 
 	now = ktime_get_real();
-	max_age = ktime_sub(now, timeout);
+	max_age = ktime_sub(now, jiffies_to_usecs(rto_j));
 
 	spin_lock_bh(&call->lock);
 
@@ -219,7 +213,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	}
 
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
-	resend_at += jiffies + rxrpc_resend_timeout;
+	resend_at += jiffies + rto_j;
 	WRITE_ONCE(call->resend_at, resend_at);
 
 	if (unacked)
@@ -234,7 +228,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 					rxrpc_timer_set_for_resend);
 		spin_unlock_bh(&call->lock);
 		ack_ts = ktime_sub(now, call->acks_latest_ts);
-		if (ktime_to_ns(ack_ts) < call->peer->rtt)
+		if (ktime_to_us(ack_ts) < (call->peer->srtt_us >> 3))
 			goto out;
 		rxrpc_propose_ACK(call, RXRPC_ACK_PING, 0, true, false,
 				  rxrpc_propose_ack_ping_for_lost_ack);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 69e09d69c896..e438bfd3fdf5 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -91,11 +91,11 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 		/* We analyse the number of packets that get ACK'd per RTT
 		 * period and increase the window if we managed to fill it.
 		 */
-		if (call->peer->rtt_usage == 0)
+		if (call->peer->rtt_count == 0)
 			goto out;
 		if (ktime_before(skb->tstamp,
-				 ktime_add_ns(call->cong_tstamp,
-					      call->peer->rtt)))
+				 ktime_add_us(call->cong_tstamp,
+					      call->peer->srtt_us >> 3)))
 			goto out_no_clear_ca;
 		change = rxrpc_cong_rtt_window_end;
 		call->cong_tstamp = skb->tstamp;
diff --git a/net/rxrpc/misc.c b/net/rxrpc/misc.c
index 214405f75346..d4144fd86f84 100644
--- a/net/rxrpc/misc.c
+++ b/net/rxrpc/misc.c
@@ -63,11 +63,6 @@ unsigned int rxrpc_rx_mtu = 5692;
  */
 unsigned int rxrpc_rx_jumbo_max = 4;
 
-/*
- * Time till packet resend (in milliseconds).
- */
-unsigned long rxrpc_resend_timeout = 4 * HZ;
-
 const s8 rxrpc_ack_priority[] = {
 	[0]				= 0,
 	[RXRPC_ACK_DELAY]		= 1,
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 90e263c6aa69..f8b632a5c619 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -369,7 +369,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	    (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events) ||
 	     retrans ||
 	     call->cong_mode == RXRPC_CALL_SLOW_START ||
-	     (call->peer->rtt_usage < 3 && sp->hdr.seq & 1) ||
+	     (call->peer->rtt_count < 3 && sp->hdr.seq & 1) ||
 	     ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000),
 			  ktime_get_real())))
 		whdr.flags |= RXRPC_REQUEST_ACK;
@@ -423,13 +423,10 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		if (whdr.flags & RXRPC_REQUEST_ACK) {
 			call->peer->rtt_last_req = skb->tstamp;
 			trace_rxrpc_rtt_tx(call, rxrpc_rtt_tx_data, serial);
-			if (call->peer->rtt_usage > 1) {
+			if (call->peer->rtt_count > 1) {
 				unsigned long nowj = jiffies, ack_lost_at;
 
-				ack_lost_at = nsecs_to_jiffies(2 * call->peer->rtt);
-				if (ack_lost_at < 1)
-					ack_lost_at = 1;
-
+				ack_lost_at = rxrpc_get_rto_backoff(call->peer, retrans);
 				ack_lost_at += nowj;
 				WRITE_ONCE(call->ack_lost_at, ack_lost_at);
 				rxrpc_reduce_call_timer(call, ack_lost_at, nowj,
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 923b263c401b..b1449d971883 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -295,52 +295,6 @@ static void rxrpc_distribute_error(struct rxrpc_peer *peer, int error,
 	}
 }
 
-/*
- * Add RTT information to cache.  This is called in softirq mode and has
- * exclusive access to the peer RTT data.
- */
-void rxrpc_peer_add_rtt(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
-			rxrpc_serial_t send_serial, rxrpc_serial_t resp_serial,
-			ktime_t send_time, ktime_t resp_time)
-{
-	struct rxrpc_peer *peer = call->peer;
-	s64 rtt;
-	u64 sum = peer->rtt_sum, avg;
-	u8 cursor = peer->rtt_cursor, usage = peer->rtt_usage;
-
-	rtt = ktime_to_ns(ktime_sub(resp_time, send_time));
-	if (rtt < 0)
-		return;
-
-	spin_lock(&peer->rtt_input_lock);
-
-	/* Replace the oldest datum in the RTT buffer */
-	sum -= peer->rtt_cache[cursor];
-	sum += rtt;
-	peer->rtt_cache[cursor] = rtt;
-	peer->rtt_cursor = (cursor + 1) & (RXRPC_RTT_CACHE_SIZE - 1);
-	peer->rtt_sum = sum;
-	if (usage < RXRPC_RTT_CACHE_SIZE) {
-		usage++;
-		peer->rtt_usage = usage;
-	}
-
-	spin_unlock(&peer->rtt_input_lock);
-
-	/* Now recalculate the average */
-	if (usage == RXRPC_RTT_CACHE_SIZE) {
-		avg = sum / RXRPC_RTT_CACHE_SIZE;
-	} else {
-		avg = sum;
-		do_div(avg, usage);
-	}
-
-	/* Don't need to update this under lock */
-	peer->rtt = avg;
-	trace_rxrpc_rtt_rx(call, why, send_serial, resp_serial, rtt,
-			   usage, avg);
-}
-
 /*
  * Perform keep-alive pings.
  */
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 452163eadb98..ca29976bb193 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -225,6 +225,8 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 		spin_lock_init(&peer->rtt_input_lock);
 		peer->debug_id = atomic_inc_return(&rxrpc_debug_id);
 
+		rxrpc_peer_init_rtt(peer);
+
 		if (RXRPC_TX_SMSS > 2190)
 			peer->cong_cwnd = 2;
 		else if (RXRPC_TX_SMSS > 1095)
@@ -497,14 +499,14 @@ void rxrpc_kernel_get_peer(struct socket *sock, struct rxrpc_call *call,
 EXPORT_SYMBOL(rxrpc_kernel_get_peer);
 
 /**
- * rxrpc_kernel_get_rtt - Get a call's peer RTT
+ * rxrpc_kernel_get_srtt - Get a call's peer smoothed RTT
  * @sock: The socket on which the call is in progress.
  * @call: The call to query
  *
- * Get the call's peer RTT.
+ * Get the call's peer smoothed RTT.
  */
-u64 rxrpc_kernel_get_rtt(struct socket *sock, struct rxrpc_call *call)
+u32 rxrpc_kernel_get_srtt(struct socket *sock, struct rxrpc_call *call)
 {
-	return call->peer->rtt;
+	return call->peer->srtt_us >> 3;
 }
-EXPORT_SYMBOL(rxrpc_kernel_get_rtt);
+EXPORT_SYMBOL(rxrpc_kernel_get_srtt);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index b9d053e42821..8b179e3c802a 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -222,7 +222,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq,
 			 "Proto Local                                          "
 			 " Remote                                         "
-			 " Use CW  MTU   LastUse          RTT Rc\n"
+			 " Use  CW   MTU LastUse      RTT      RTO\n"
 			 );
 		return 0;
 	}
@@ -236,15 +236,15 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 	now = ktime_get_seconds();
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %3u"
-		   " %3u %5u %6llus %12llu %2u\n",
+		   " %3u %5u %6llus %8u %8u\n",
 		   lbuff,
 		   rbuff,
 		   atomic_read(&peer->usage),
 		   peer->cong_cwnd,
 		   peer->mtu,
 		   now - peer->last_tx_at,
-		   peer->rtt,
-		   peer->rtt_cursor);
+		   peer->srtt_us >> 3,
+		   jiffies_to_usecs(peer->rto_j));
 
 	return 0;
 }
diff --git a/net/rxrpc/rtt.c b/net/rxrpc/rtt.c
new file mode 100644
index 000000000000..928d8b34a3ee
--- /dev/null
+++ b/net/rxrpc/rtt.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/* RTT/RTO calculation.
+ *
+ * Adapted from TCP for AF_RXRPC by David Howells (dhowells@redhat.com)
+ *
+ * https://tools.ietf.org/html/rfc6298
+ * https://tools.ietf.org/html/rfc1122#section-4.2.3.1
+ * http://ccr.sigcomm.org/archive/1995/jan95/ccr-9501-partridge87.pdf
+ */
+
+#include <linux/net.h>
+#include "ar-internal.h"
+
+#define RXRPC_RTO_MAX	((unsigned)(120 * HZ))
+#define RXRPC_TIMEOUT_INIT ((unsigned)(1*HZ))	/* RFC6298 2.1 initial RTO value	*/
+#define rxrpc_jiffies32 ((u32)jiffies)		/* As rxrpc_jiffies32 */
+#define rxrpc_min_rtt_wlen 300			/* As sysctl_tcp_min_rtt_wlen */
+
+static u32 rxrpc_rto_min_us(struct rxrpc_peer *peer)
+{
+	return 200;
+}
+
+static u32 __rxrpc_set_rto(const struct rxrpc_peer *peer)
+{
+	return _usecs_to_jiffies((peer->srtt_us >> 3) + peer->rttvar_us);
+}
+
+static u32 rxrpc_bound_rto(u32 rto)
+{
+	return min(rto, RXRPC_RTO_MAX);
+}
+
+/*
+ * Called to compute a smoothed rtt estimate. The data fed to this
+ * routine either comes from timestamps, or from segments that were
+ * known _not_ to have been retransmitted [see Karn/Partridge
+ * Proceedings SIGCOMM 87]. The algorithm is from the SIGCOMM 88
+ * piece by Van Jacobson.
+ * NOTE: the next three routines used to be one big routine.
+ * To save cycles in the RFC 1323 implementation it was better to break
+ * it up into three procedures. -- erics
+ */
+static void rxrpc_rtt_estimator(struct rxrpc_peer *peer, long sample_rtt_us)
+{
+	long m = sample_rtt_us; /* RTT */
+	u32 srtt = peer->srtt_us;
+
+	/*	The following amusing code comes from Jacobson's
+	 *	article in SIGCOMM '88.  Note that rtt and mdev
+	 *	are scaled versions of rtt and mean deviation.
+	 *	This is designed to be as fast as possible
+	 *	m stands for "measurement".
+	 *
+	 *	On a 1990 paper the rto value is changed to:
+	 *	RTO = rtt + 4 * mdev
+	 *
+	 * Funny. This algorithm seems to be very broken.
+	 * These formulae increase RTO, when it should be decreased, increase
+	 * too slowly, when it should be increased quickly, decrease too quickly
+	 * etc. I guess in BSD RTO takes ONE value, so that it is absolutely
+	 * does not matter how to _calculate_ it. Seems, it was trap
+	 * that VJ failed to avoid. 8)
+	 */
+	if (srtt != 0) {
+		m -= (srtt >> 3);	/* m is now error in rtt est */
+		srtt += m;		/* rtt = 7/8 rtt + 1/8 new */
+		if (m < 0) {
+			m = -m;		/* m is now abs(error) */
+			m -= (peer->mdev_us >> 2);   /* similar update on mdev */
+			/* This is similar to one of Eifel findings.
+			 * Eifel blocks mdev updates when rtt decreases.
+			 * This solution is a bit different: we use finer gain
+			 * for mdev in this case (alpha*beta).
+			 * Like Eifel it also prevents growth of rto,
+			 * but also it limits too fast rto decreases,
+			 * happening in pure Eifel.
+			 */
+			if (m > 0)
+				m >>= 3;
+		} else {
+			m -= (peer->mdev_us >> 2);   /* similar update on mdev */
+		}
+
+		peer->mdev_us += m;		/* mdev = 3/4 mdev + 1/4 new */
+		if (peer->mdev_us > peer->mdev_max_us) {
+			peer->mdev_max_us = peer->mdev_us;
+			if (peer->mdev_max_us > peer->rttvar_us)
+				peer->rttvar_us = peer->mdev_max_us;
+		}
+	} else {
+		/* no previous measure. */
+		srtt = m << 3;		/* take the measured time to be rtt */
+		peer->mdev_us = m << 1;	/* make sure rto = 3*rtt */
+		peer->rttvar_us = max(peer->mdev_us, rxrpc_rto_min_us(peer));
+		peer->mdev_max_us = peer->rttvar_us;
+	}
+
+	peer->srtt_us = max(1U, srtt);
+}
+
+/*
+ * Calculate rto without backoff.  This is the second half of Van Jacobson's
+ * routine referred to above.
+ */
+static void rxrpc_set_rto(struct rxrpc_peer *peer)
+{
+	u32 rto;
+
+	/* 1. If rtt variance happened to be less 50msec, it is hallucination.
+	 *    It cannot be less due to utterly erratic ACK generation made
+	 *    at least by solaris and freebsd. "Erratic ACKs" has _nothing_
+	 *    to do with delayed acks, because at cwnd>2 true delack timeout
+	 *    is invisible. Actually, Linux-2.4 also generates erratic
+	 *    ACKs in some circumstances.
+	 */
+	rto = __rxrpc_set_rto(peer);
+
+	/* 2. Fixups made earlier cannot be right.
+	 *    If we do not estimate RTO correctly without them,
+	 *    all the algo is pure shit and should be replaced
+	 *    with correct one. It is exactly, which we pretend to do.
+	 */
+
+	/* NOTE: clamping at RXRPC_RTO_MIN is not required, current algo
+	 * guarantees that rto is higher.
+	 */
+	peer->rto_j = rxrpc_bound_rto(rto);
+}
+
+static void rxrpc_ack_update_rtt(struct rxrpc_peer *peer, long rtt_us)
+{
+	if (rtt_us < 0)
+		return;
+
+	//rxrpc_update_rtt_min(peer, rtt_us);
+	rxrpc_rtt_estimator(peer, rtt_us);
+	rxrpc_set_rto(peer);
+
+	/* RFC6298: only reset backoff on valid RTT measurement. */
+	peer->backoff = 0;
+}
+
+/*
+ * Add RTT information to cache.  This is called in softirq mode and has
+ * exclusive access to the peer RTT data.
+ */
+void rxrpc_peer_add_rtt(struct rxrpc_call *call, enum rxrpc_rtt_rx_trace why,
+			rxrpc_serial_t send_serial, rxrpc_serial_t resp_serial,
+			ktime_t send_time, ktime_t resp_time)
+{
+	struct rxrpc_peer *peer = call->peer;
+	s64 rtt_us;
+
+	rtt_us = ktime_to_us(ktime_sub(resp_time, send_time));
+	if (rtt_us < 0)
+		return;
+
+	spin_lock(&peer->rtt_input_lock);
+	rxrpc_ack_update_rtt(peer, rtt_us);
+	if (peer->rtt_count < 3)
+		peer->rtt_count++;
+	spin_unlock(&peer->rtt_input_lock);
+
+	trace_rxrpc_rtt_rx(call, why, send_serial, resp_serial,
+			   peer->srtt_us >> 3, peer->rto_j);
+}
+
+/*
+ * Get the retransmission timeout to set in jiffies, backing it off each time
+ * we retransmit.
+ */
+unsigned long rxrpc_get_rto_backoff(struct rxrpc_peer *peer, bool retrans)
+{
+	u64 timo_j;
+	u8 backoff = READ_ONCE(peer->backoff);
+
+	timo_j = peer->rto_j;
+	timo_j <<= backoff;
+	if (retrans && timo_j * 2 <= RXRPC_RTO_MAX)
+		WRITE_ONCE(peer->backoff, backoff + 1);
+
+	if (timo_j < 1)
+		timo_j = 1;
+
+	return timo_j;
+}
+
+void rxrpc_peer_init_rtt(struct rxrpc_peer *peer)
+{
+	peer->rto_j	= RXRPC_TIMEOUT_INIT;
+	peer->mdev_us	= jiffies_to_usecs(RXRPC_TIMEOUT_INIT);
+	peer->backoff	= 0;
+	//minmax_reset(&peer->rtt_min, rxrpc_jiffies32, ~0U);
+}
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 0fcf157aa09f..5e9c43d4a314 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -66,15 +66,14 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 					    struct rxrpc_call *call)
 {
 	rxrpc_seq_t tx_start, tx_win;
-	signed long rtt2, timeout;
-	u64 rtt;
+	signed long rtt, timeout;
 
-	rtt = READ_ONCE(call->peer->rtt);
-	rtt2 = nsecs_to_jiffies64(rtt) * 2;
-	if (rtt2 < 2)
-		rtt2 = 2;
+	rtt = READ_ONCE(call->peer->srtt_us) >> 3;
+	rtt = usecs_to_jiffies(rtt) * 2;
+	if (rtt < 2)
+		rtt = 2;
 
-	timeout = rtt2;
+	timeout = rtt;
 	tx_start = READ_ONCE(call->tx_hard_ack);
 
 	for (;;) {
@@ -92,7 +91,7 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 			return -EINTR;
 
 		if (tx_win != tx_start) {
-			timeout = rtt2;
+			timeout = rtt;
 			tx_start = tx_win;
 		}
 
@@ -271,16 +270,9 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		_debug("need instant resend %d", ret);
 		rxrpc_instant_resend(call, ix);
 	} else {
-		unsigned long now = jiffies, resend_at;
+		unsigned long now = jiffies;
+		unsigned long resend_at = now + call->peer->rto_j;
 
-		if (call->peer->rtt_usage > 1)
-			resend_at = nsecs_to_jiffies(call->peer->rtt * 3 / 2);
-		else
-			resend_at = rxrpc_resend_timeout;
-		if (resend_at < 1)
-			resend_at = 1;
-
-		resend_at += now;
 		WRITE_ONCE(call->resend_at, resend_at);
 		rxrpc_reduce_call_timer(call, resend_at, now,
 					rxrpc_timer_set_for_send);
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 2bbb38161851..18dade4e6f9a 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -71,15 +71,6 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.extra1		= (void *)&one_jiffy,
 		.extra2		= (void *)&max_jiffies,
 	},
-	{
-		.procname	= "resend_timeout",
-		.data		= &rxrpc_resend_timeout,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
-		.extra1		= (void *)&one_jiffy,
-		.extra2		= (void *)&max_jiffies,
-	},
 
 	/* Non-time values */
 	{


