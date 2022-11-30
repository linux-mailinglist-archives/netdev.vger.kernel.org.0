Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE663DB55
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiK3RBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiK3RBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:01:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF54681DB1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z6QQEHUq8aGAElvlTLH4USEK7iWS4UjdJ8ZNjiJjfog=;
        b=Y/S0Q+7sJkmSjoH5zGCiUcIIk60JiAbBrDYzYsKvKnSyqTOX8oaL1GmgET7gvr7aCHwBG7
        zEeD3ayhQxuOEYyRR02fMgqCIdDAZIfDAxgKP/CfXPkYooXPU3xlrdqo3xfnykQqazcRHf
        kDuyy3vD2Mw46QiBdhIAz4Ct1wU/ZMk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-ofSnyi-7NnifSmxvD-zisA-1; Wed, 30 Nov 2022 11:57:49 -0500
X-MC-Unique: ofSnyi-7NnifSmxvD-zisA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CD5F185A7AB;
        Wed, 30 Nov 2022 16:57:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 345712166B26;
        Wed, 30 Nov 2022 16:57:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 24/35] rxrpc: Copy client call parameters into
 rxrpc_call earlier
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:57:45 +0000
Message-ID: <166982746544.621383.4933729446413150137.stgit@warthog.procyon.org.uk>
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

Copy client call parameters into rxrpc_call earlier so that that can be
used to convey them to the connection code - which can then be offloaded to
the I/O thread.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    3 +++
 net/rxrpc/ar-internal.h      |    7 +++++-
 net/rxrpc/call_accept.c      |    2 ++
 net/rxrpc/call_object.c      |   50 ++++++++++++++++++++++++++----------------
 net/rxrpc/conn_client.c      |    2 +-
 net/rxrpc/io_thread.c        |    4 ++-
 net/rxrpc/output.c           |    2 +-
 net/rxrpc/proc.c             |   25 ++++++---------------
 net/rxrpc/recvmsg.c          |    8 +++----
 net/rxrpc/security.c         |   30 +++++++++++++++++++++++++
 net/rxrpc/txbuf.c            |    2 +-
 11 files changed, 87 insertions(+), 48 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 0b12d96c7921..8bd48358f757 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -52,6 +52,7 @@
 
 #define rxrpc_local_traces \
 	EM(rxrpc_local_free,			"FREE        ") \
+	EM(rxrpc_local_get_call,		"GET call    ") \
 	EM(rxrpc_local_get_client_conn,		"GET conn-cln") \
 	EM(rxrpc_local_get_for_use,		"GET for-use ") \
 	EM(rxrpc_local_get_peer,		"GET peer    ") \
@@ -61,6 +62,7 @@
 	EM(rxrpc_local_processing,		"PROCESSING  ") \
 	EM(rxrpc_local_put_already_queued,	"PUT alreadyq") \
 	EM(rxrpc_local_put_bind,		"PUT bind    ") \
+	EM(rxrpc_local_put_call,		"PUT call    ") \
 	EM(rxrpc_local_put_for_use,		"PUT for-use ") \
 	EM(rxrpc_local_put_kill_conn,		"PUT conn-kil") \
 	EM(rxrpc_local_put_peer,		"PUT peer    ") \
@@ -166,6 +168,7 @@
 	EM(rxrpc_call_new_client,		"NEW client  ") \
 	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
 	EM(rxrpc_call_put_discard_prealloc,	"PUT disc-pre") \
+	EM(rxrpc_call_put_discard_error,	"PUT disc-err") \
 	EM(rxrpc_call_put_input,		"PUT input   ") \
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index a80655fa9dfb..3bd6a5eb2fb7 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -530,6 +530,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_UPGRADE,		/* Service upgrade was requested for the call */
 	RXRPC_CALL_DELAY_ACK_PENDING,	/* DELAY ACK generation is pending */
 	RXRPC_CALL_IDLE_ACK_PENDING,	/* IDLE ACK generation is pending */
+	RXRPC_CALL_EXCLUSIVE,		/* The call uses a once-only connection */
 };
 
 /*
@@ -592,10 +593,13 @@ struct rxrpc_call {
 	struct rcu_head		rcu;
 	struct rxrpc_connection	*conn;		/* connection carrying call */
 	struct rxrpc_peer	*peer;		/* Peer record for remote address */
+	struct rxrpc_local	*local;		/* Representation of local endpoint */
 	struct rxrpc_sock __rcu	*socket;	/* socket responsible */
 	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
+	struct key		*key;		/* Security details */
 	const struct rxrpc_security *security;	/* applied security module */
 	struct mutex		user_mutex;	/* User access mutex */
+	struct sockaddr_rxrpc	dest_srx;	/* Destination address */
 	unsigned long		delay_ack_at;	/* When DELAY ACK needs to happen */
 	unsigned long		ack_lost_at;	/* When ACK is figured as lost */
 	unsigned long		resend_at;	/* When next resend needs to happen */
@@ -631,11 +635,11 @@ struct rxrpc_call {
 	enum rxrpc_call_state	state;		/* current state of call */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
 	refcount_t		ref;
-	u16			service_id;	/* service ID */
 	u8			security_ix;	/* Security type */
 	enum rxrpc_interruptibility interruptibility; /* At what point call may be interrupted */
 	u32			call_id;	/* call ID on connection  */
 	u32			cid;		/* connection ID plus channel index */
+	u32			security_level;	/* Security level selected */
 	int			debug_id;	/* debug ID for printks */
 	unsigned short		rx_pkt_offset;	/* Current recvmsg packet offset */
 	unsigned short		rx_pkt_len;	/* Current recvmsg packet len */
@@ -1147,6 +1151,7 @@ extern const struct rxrpc_security rxkad;
 int __init rxrpc_init_security(void);
 const struct rxrpc_security *rxrpc_security_lookup(u8);
 void rxrpc_exit_security(void);
+int rxrpc_init_client_call_security(struct rxrpc_call *);
 int rxrpc_init_client_conn_security(struct rxrpc_connection *);
 const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *,
 							 struct sk_buff *);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8d106b626aa3..8bc327aa2beb 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -318,10 +318,12 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 			  (call_tail + 1) & (RXRPC_BACKLOG_MAX - 1));
 
 	rxrpc_see_call(call, rxrpc_call_see_accept);
+	call->local = rxrpc_get_local(conn->local, rxrpc_local_get_call);
 	call->conn = conn;
 	call->security = conn->security;
 	call->security_ix = conn->security_ix;
 	call->peer = rxrpc_get_peer(conn->peer, rxrpc_peer_get_accept);
+	call->dest_srx = peer->srx;
 	call->cong_ssthresh = call->peer->cong_ssthresh;
 	call->tx_last_sent = ktime_get_real();
 	return call;
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 997641e3d1c8..2622d06bb0d6 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -47,14 +47,9 @@ static struct semaphore rxrpc_kernel_call_limiter =
 
 void rxrpc_poke_call(struct rxrpc_call *call, enum rxrpc_call_poke_trace what)
 {
-	struct rxrpc_local *local;
-	struct rxrpc_peer *peer = call->peer;
+	struct rxrpc_local *local = call->local;
 	bool busy;
 
-	if (WARN_ON_ONCE(!peer))
-		return;
-	local = peer->local;
-
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		spin_lock_bh(&local->lock);
 		busy = !list_empty(&call->attend_link);
@@ -200,22 +195,45 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
  */
 static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 						  struct sockaddr_rxrpc *srx,
+						  struct rxrpc_conn_parameters *cp,
+						  struct rxrpc_call_params *p,
 						  gfp_t gfp,
 						  unsigned int debug_id)
 {
 	struct rxrpc_call *call;
 	ktime_t now;
+	int ret;
 
 	_enter("");
 
 	call = rxrpc_alloc_call(rx, gfp, debug_id);
 	if (!call)
 		return ERR_PTR(-ENOMEM);
-	call->state = RXRPC_CALL_CLIENT_AWAIT_CONN;
-	call->service_id = srx->srx_service;
 	now = ktime_get_real();
-	call->acks_latest_ts = now;
-	call->cong_tstamp = now;
+	call->acks_latest_ts	= now;
+	call->cong_tstamp	= now;
+	call->state		= RXRPC_CALL_CLIENT_AWAIT_CONN;
+	call->dest_srx		= *srx;
+	call->interruptibility	= p->interruptibility;
+	call->tx_total_len	= p->tx_total_len;
+	call->key		= key_get(cp->key);
+	call->local		= rxrpc_get_local(cp->local, rxrpc_local_get_call);
+	if (p->kernel)
+		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
+	if (cp->upgrade)
+		__set_bit(RXRPC_CALL_UPGRADE, &call->flags);
+	if (cp->exclusive)
+		__set_bit(RXRPC_CALL_EXCLUSIVE, &call->flags);
+
+	ret = rxrpc_init_client_call_security(call);
+	if (ret < 0) {
+		__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
+		rxrpc_put_call(call, rxrpc_call_put_discard_error);
+		return ERR_PTR(ret);
+	}
+
+	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
+			 p->user_call_ID, rxrpc_call_new_client);
 
 	_leave(" = %p", call);
 	return call;
@@ -295,7 +313,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 		return ERR_PTR(-ERESTARTSYS);
 	}
 
-	call = rxrpc_alloc_client_call(rx, srx, gfp, debug_id);
+	call = rxrpc_alloc_client_call(rx, srx, cp, p, gfp, debug_id);
 	if (IS_ERR(call)) {
 		release_sock(&rx->sk);
 		up(limiter);
@@ -303,13 +321,6 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 		return call;
 	}
 
-	call->interruptibility = p->interruptibility;
-	call->tx_total_len = p->tx_total_len;
-	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
-			 p->user_call_ID, rxrpc_call_new_client);
-	if (p->kernel)
-		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
-
 	/* We need to protect a partially set up call against the user as we
 	 * will be acting outside the socket lock.
 	 */
@@ -413,7 +424,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 
 	rcu_assign_pointer(call->socket, rx);
 	call->call_id		= sp->hdr.callNumber;
-	call->service_id	= sp->hdr.serviceId;
+	call->dest_srx.srx_service = sp->hdr.serviceId;
 	call->cid		= sp->hdr.cid;
 	call->state		= RXRPC_CALL_SERVER_SECURING;
 	call->cong_tstamp	= skb->tstamp;
@@ -639,6 +650,7 @@ static void rxrpc_destroy_call(struct work_struct *work)
 	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
 	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
 	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
+	rxrpc_put_local(call->local, rxrpc_local_put_call);
 	call_rcu(&call->rcu, rxrpc_rcu_free_call);
 }
 
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 9485a3d18f29..ab3dd22fadc0 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -553,7 +553,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	call->call_id	= call_id;
 	call->security	= conn->security;
 	call->security_ix = conn->security_ix;
-	call->service_id = conn->service_id;
+	call->dest_srx.srx_service = conn->service_id;
 
 	trace_rxrpc_connect_call(call);
 
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index cc249bc6b8cd..2119941b6d6c 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -343,8 +343,8 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 		}
 
 		if (call) {
-			if (sp->hdr.serviceId != call->service_id)
-				call->service_id = sp->hdr.serviceId;
+			if (sp->hdr.serviceId != call->dest_srx.srx_service)
+				call->dest_srx.srx_service = sp->hdr.serviceId;
 			if ((int)sp->hdr.serial - (int)call->rx_serial > 0)
 				call->rx_serial = sp->hdr.serial;
 			if (!test_bit(RXRPC_CALL_RX_HEARD, &call->flags))
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 131c7a76fb06..e2ce7dadbb7a 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -357,7 +357,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	pkt.whdr.userStatus	= 0;
 	pkt.whdr.securityIndex	= call->security_ix;
 	pkt.whdr._rsvd		= 0;
-	pkt.whdr.serviceId	= htons(call->service_id);
+	pkt.whdr.serviceId	= htons(call->dest_srx.srx_service);
 	pkt.abort_code		= htonl(call->abort_code);
 
 	iov[0].iov_base	= &pkt;
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 35d5b43c677e..5af7c8ee4b1a 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -49,8 +49,6 @@ static void rxrpc_call_seq_stop(struct seq_file *seq, void *v)
 static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_local *local;
-	struct rxrpc_sock *rx;
-	struct rxrpc_peer *peer;
 	struct rxrpc_call *call;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 	unsigned long timeout = 0;
@@ -69,22 +67,13 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 
 	call = list_entry(v, struct rxrpc_call, link);
 
-	rx = rcu_dereference(call->socket);
-	if (rx) {
-		local = READ_ONCE(rx->local);
-		if (local)
-			sprintf(lbuff, "%pISpc", &local->srx.transport);
-		else
-			strcpy(lbuff, "no_local");
-	} else {
-		strcpy(lbuff, "no_socket");
-	}
-
-	peer = call->peer;
-	if (peer)
-		sprintf(rbuff, "%pISpc", &peer->srx.transport);
+	local = call->local;
+	if (local)
+		sprintf(lbuff, "%pISpc", &local->srx.transport);
 	else
-		strcpy(rbuff, "no_connection");
+		strcpy(lbuff, "no_local");
+
+	sprintf(rbuff, "%pISpc", &call->dest_srx.transport);
 
 	if (call->state != RXRPC_CALL_SERVER_PREALLOC) {
 		timeout = READ_ONCE(call->expect_rx_by);
@@ -98,7 +87,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %06lx\n",
 		   lbuff,
 		   rbuff,
-		   call->service_id,
+		   call->dest_srx.srx_service,
 		   call->cid,
 		   call->call_id,
 		   rxrpc_is_service_call(call) ? "Svc" : "Clt",
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index bfac9e09347e..5df7f468abed 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -490,11 +490,9 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	}
 
 	if (msg->msg_name && call->peer) {
-		struct sockaddr_rxrpc *srx = msg->msg_name;
-		size_t len = sizeof(call->peer->srx);
+		size_t len = sizeof(call->dest_srx);
 
-		memcpy(msg->msg_name, &call->peer->srx, len);
-		srx->srx_service = call->service_id;
+		memcpy(msg->msg_name, &call->dest_srx, len);
 		msg->msg_namelen = len;
 	}
 
@@ -639,7 +637,7 @@ int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 out:
 	rxrpc_transmit_ack_packets(call->peer->local);
 	if (_service)
-		*_service = call->service_id;
+		*_service = call->dest_srx.srx_service;
 	mutex_unlock(&call->user_mutex);
 	_leave(" = %d [%zu,%d]", ret, iov_iter_count(iter), *_abort);
 	return ret;
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index e6ddac9b3732..209f2c25a0da 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -62,6 +62,36 @@ const struct rxrpc_security *rxrpc_security_lookup(u8 security_index)
 	return rxrpc_security_types[security_index];
 }
 
+/*
+ * Initialise the security on a client call.
+ */
+int rxrpc_init_client_call_security(struct rxrpc_call *call)
+{
+	const struct rxrpc_security *sec;
+	struct rxrpc_key_token *token;
+	struct key *key = call->key;
+	int ret;
+
+	if (!key)
+		return 0;
+
+	ret = key_validate(key);
+	if (ret < 0)
+		return ret;
+
+	for (token = key->payload.data[0]; token; token = token->next) {
+		sec = rxrpc_security_lookup(token->security_index);
+		if (sec)
+			goto found;
+	}
+	return -EKEYREJECTED;
+
+found:
+	call->security = sec;
+	_leave(" = 0");
+	return 0;
+}
+
 /*
  * initialise the security on a client connection
  */
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index f93dc666a3a0..90ff00c340cd 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -44,7 +44,7 @@ struct rxrpc_txbuf *rxrpc_alloc_txbuf(struct rxrpc_call *call, u8 packet_type,
 		txb->wire.userStatus	= 0;
 		txb->wire.securityIndex	= call->security_ix;
 		txb->wire._rsvd		= 0;
-		txb->wire.serviceId	= htons(call->service_id);
+		txb->wire.serviceId	= htons(call->dest_srx.srx_service);
 
 		trace_rxrpc_txbuf(txb->debug_id,
 				  txb->call_debug_id, txb->seq, 1,


