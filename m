Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F2D557D03
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiFWNaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiFWN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:29:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D8A13F331
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655990959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8+2mW0ljPoZfaleOj039bSm270SW9ZHn8ZaI6/T8Bkg=;
        b=ZgMO0upZ62SQDA42893Q/F8+Vh89/6m8Rxg2VxxoyHfqUS2BtIAH6EGiL3kYGB90l/sq4X
        ZqF3EFfIFYDJhBFnzY35C2oIUVI9m6e1R1ZPlNQFTsjCxd1f15BnCScyVO7moqqJnnHvVW
        6l5EbzcbJzE+09Uj+oF+SN3gZu6A68I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-Vgn_L9iGPOi3qy_p4m8xow-1; Thu, 23 Jun 2022 09:29:08 -0400
X-MC-Unique: Vgn_L9iGPOi3qy_p4m8xow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9ABE41C0CE6B;
        Thu, 23 Jun 2022 13:29:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5227E815B;
        Thu, 23 Jun 2022 13:29:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 2/8] rxrpc: Allow UDP socket sharing for AF_RXRPC service
 sockets
From:   David Howells <dhowells@redhat.com>
To:     linux-afs@lists.infradead.org
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 14:29:05 +0100
Message-ID: <165599094563.1827880.1075055732033526686.stgit@warthog.procyon.org.uk>
In-Reply-To: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
References: <165599093190.1827880.6407599132975295152.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow multiple AF_RXRPC service sockets to share a single UDP socket,
provided the set of service IDs supported by each socket is disjoint with
those of the other sockets.

bind() can be used repeatedly on a socket to bind multiple service IDs to
it.  The RXRPC_UPGRADEABLE_SERVICE sockopt can then be used to indicate
service upgrade paths between pairs of service IDs on the same socket.

Binding a service address now causes the preallocation buffers to be
created rather than this being done by listen().

The backlog struct is now replaced by a more comprehensive service struct
that can in future be shared between multiple sockets that are acting as
channels to the same set of services.

The local endpoint then maintains a list of services rather than pointing
at a specific AF_RXRPC socket.  New calls go onto a queue on the
rxrpc_service struct rather than been punted directly to a socket, waiting
for a recvmsg() to pick them up (in the kernel, a notification hook is
called instead).

On a userspace socket, the preallocated call user IDs are now held in a
separate ring and applied when recvmsg() selects the call.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h            |    3 
 fs/afs/main.c                |    1 
 fs/afs/rxrpc.c               |   83 +++-----
 include/net/af_rxrpc.h       |    9 -
 include/trace/events/afs.h   |    4 
 include/trace/events/rxrpc.h |    6 -
 net/rxrpc/af_rxrpc.c         |  255 +++++++++++++++++++-----
 net/rxrpc/ar-internal.h      |   95 ++++++---
 net/rxrpc/call_accept.c      |  444 +++++++++++++++++++++++++++---------------
 net/rxrpc/call_object.c      |  133 ++++++++-----
 net/rxrpc/conn_service.c     |   17 +-
 net/rxrpc/input.c            |   25 +-
 net/rxrpc/key.c              |    4 
 net/rxrpc/local_object.c     |   24 +-
 net/rxrpc/net_ns.c           |    1 
 net/rxrpc/peer_object.c      |   17 +-
 net/rxrpc/proc.c             |   46 ++--
 net/rxrpc/recvmsg.c          |   67 +++++-
 net/rxrpc/security.c         |   22 +-
 net/rxrpc/server_key.c       |   12 +
 20 files changed, 823 insertions(+), 445 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index a6f25d9e75b5..799f0773e7de 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -259,8 +259,6 @@ struct afs_net {
 
 	/* AF_RXRPC I/O stuff */
 	struct socket		*socket;
-	struct afs_call		*spare_incoming_call;
-	struct work_struct	charge_preallocation_work;
 	struct mutex		socket_mutex;
 	atomic_t		nr_outstanding_calls;
 	atomic_t		nr_superblocks;
@@ -1273,7 +1271,6 @@ extern struct workqueue_struct *afs_async_calls;
 
 extern int __net_init afs_open_socket(struct afs_net *);
 extern void __net_exit afs_close_socket(struct afs_net *);
-extern void afs_charge_preallocation(struct work_struct *);
 extern void afs_put_call(struct afs_call *);
 extern void afs_make_call(struct afs_addr_cursor *, struct afs_call *, gfp_t);
 extern long afs_wait_for_call_to_complete(struct afs_call *, struct afs_addr_cursor *);
diff --git a/fs/afs/main.c b/fs/afs/main.c
index eae288c8d40a..93388d821a8c 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -74,7 +74,6 @@ static int __net_init afs_net_init(struct net *net_ns)
 	net->live = true;
 	generate_random_uuid((unsigned char *)&net->uuid);
 
-	INIT_WORK(&net->charge_preallocation_work, afs_charge_preallocation);
 	mutex_init(&net->socket_mutex);
 
 	net->cells = RB_ROOT;
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index a5434f3e57c6..af11ca170d96 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -19,6 +19,8 @@ struct workqueue_struct *afs_async_calls;
 static void afs_wake_up_call_waiter(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_wake_up_async_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_process_async_call(struct work_struct *);
+static unsigned long afs_rx_preallocate_call(struct sock *, struct rxrpc_call *,
+					     unsigned int *);
 static void afs_rx_new_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_rx_discard_new_call(struct rxrpc_call *, unsigned long);
 static int afs_deliver_cm_op_id(struct afs_call *);
@@ -81,7 +83,10 @@ int afs_open_socket(struct afs_net *net)
 	 * it sends back to us.
 	 */
 
-	rxrpc_kernel_new_call_notification(socket, afs_rx_new_call,
+	rxrpc_kernel_new_call_notification(socket,
+					   afs_wake_up_async_call,
+					   afs_rx_preallocate_call,
+					   afs_rx_new_call,
 					   afs_rx_discard_new_call);
 
 	ret = kernel_listen(socket, INT_MAX);
@@ -89,7 +94,6 @@ int afs_open_socket(struct afs_net *net)
 		goto error_2;
 
 	net->socket = socket;
-	afs_charge_preallocation(&net->charge_preallocation_work);
 	_leave(" = 0");
 	return 0;
 
@@ -110,11 +114,6 @@ void afs_close_socket(struct afs_net *net)
 	kernel_listen(net->socket, 0);
 	flush_workqueue(afs_async_calls);
 
-	if (net->spare_incoming_call) {
-		afs_put_call(net->spare_incoming_call);
-		net->spare_incoming_call = NULL;
-	}
-
 	_debug("outstanding %u", atomic_read(&net->nr_outstanding_calls));
 	wait_var_event(&net->nr_outstanding_calls,
 		       !atomic_read(&net->nr_outstanding_calls));
@@ -133,7 +132,7 @@ void afs_close_socket(struct afs_net *net)
  */
 static struct afs_call *afs_alloc_call(struct afs_net *net,
 				       const struct afs_call_type *type,
-				       gfp_t gfp)
+				       bool prealloc, gfp_t gfp)
 {
 	struct afs_call *call;
 	int o;
@@ -151,7 +150,8 @@ static struct afs_call *afs_alloc_call(struct afs_net *net,
 	spin_lock_init(&call->state_lock);
 	call->iter = &call->def_iter;
 
-	o = atomic_inc_return(&net->nr_outstanding_calls);
+	if (!prealloc)
+		o = atomic_inc_return(&net->nr_outstanding_calls);
 	trace_afs_call(call, afs_call_trace_alloc, 1, o,
 		       __builtin_return_address(0));
 	return call;
@@ -229,7 +229,7 @@ struct afs_call *afs_alloc_flat_call(struct afs_net *net,
 {
 	struct afs_call *call;
 
-	call = afs_alloc_call(net, type, GFP_NOFS);
+	call = afs_alloc_call(net, type, false, GFP_NOFS);
 	if (!call)
 		goto nomem_call;
 
@@ -703,45 +703,25 @@ static void afs_process_async_call(struct work_struct *work)
 	_leave("");
 }
 
-static void afs_rx_attach(struct rxrpc_call *rxcall, unsigned long user_call_ID)
-{
-	struct afs_call *call = (struct afs_call *)user_call_ID;
-
-	call->rxcall = rxcall;
-}
-
-/*
- * Charge the incoming call preallocation.
- */
-void afs_charge_preallocation(struct work_struct *work)
+static unsigned long afs_rx_preallocate_call(struct sock *sock,
+					     struct rxrpc_call *rxcall,
+					     unsigned int *_debug_id)
 {
-	struct afs_net *net =
-		container_of(work, struct afs_net, charge_preallocation_work);
-	struct afs_call *call = net->spare_incoming_call;
+	struct afs_call *call;
+	struct afs_net *net = afs_sock2net(sock);
 
-	for (;;) {
-		if (!call) {
-			call = afs_alloc_call(net, &afs_RXCMxxxx, GFP_KERNEL);
-			if (!call)
-				break;
-
-			call->drop_ref = true;
-			call->async = true;
-			call->state = AFS_CALL_SV_AWAIT_OP_ID;
-			init_waitqueue_head(&call->waitq);
-			afs_extract_to_tmp(call);
-		}
+	call = afs_alloc_call(net, &afs_RXCMxxxx, true, GFP_KERNEL);
+	if (!call)
+		return 0;
 
-		if (rxrpc_kernel_charge_accept(net->socket,
-					       afs_wake_up_async_call,
-					       afs_rx_attach,
-					       (unsigned long)call,
-					       GFP_KERNEL,
-					       call->debug_id) < 0)
-			break;
-		call = NULL;
-	}
-	net->spare_incoming_call = call;
+	*_debug_id = call->debug_id;
+	call->rxcall = rxcall;
+	call->drop_ref = true;
+	call->async = true;
+	call->state = AFS_CALL_SV_AWAIT_OP_ID;
+	init_waitqueue_head(&call->waitq);
+	afs_extract_to_tmp(call);
+	return (unsigned long)call;
 }
 
 /*
@@ -751,6 +731,11 @@ static void afs_rx_discard_new_call(struct rxrpc_call *rxcall,
 				    unsigned long user_call_ID)
 {
 	struct afs_call *call = (struct afs_call *)user_call_ID;
+	unsigned int o;
+
+	o = atomic_inc_return(&call->net->nr_outstanding_calls);
+	trace_afs_call(call, afs_call_trace_discard, atomic_read(&call->usage),
+		        o, __builtin_return_address(0));
 
 	call->rxcall = NULL;
 	afs_put_call(call);
@@ -762,9 +747,13 @@ static void afs_rx_discard_new_call(struct rxrpc_call *rxcall,
 static void afs_rx_new_call(struct sock *sk, struct rxrpc_call *rxcall,
 			    unsigned long user_call_ID)
 {
+	struct afs_call *call = (struct afs_call *)user_call_ID;
 	struct afs_net *net = afs_sock2net(sk);
+	unsigned int o;
 
-	queue_work(afs_wq, &net->charge_preallocation_work);
+	o = atomic_inc_return(&net->nr_outstanding_calls);
+	trace_afs_call(call, afs_call_trace_accept, atomic_read(&call->usage),
+		        o, __builtin_return_address(0));
 }
 
 /*
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index cee5f83c0f11..71e943c32027 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -34,9 +34,12 @@ typedef void (*rxrpc_notify_end_tx_t)(struct sock *, struct rxrpc_call *,
 typedef void (*rxrpc_notify_new_call_t)(struct sock *, struct rxrpc_call *,
 					unsigned long);
 typedef void (*rxrpc_discard_new_call_t)(struct rxrpc_call *, unsigned long);
-typedef void (*rxrpc_user_attach_call_t)(struct rxrpc_call *, unsigned long);
+typedef unsigned long (*rxrpc_preallocate_call_t)(struct sock *, struct rxrpc_call *,
+						  unsigned int *);
 
 void rxrpc_kernel_new_call_notification(struct socket *,
+					rxrpc_notify_rx_t,
+					rxrpc_preallocate_call_t,
 					rxrpc_notify_new_call_t,
 					rxrpc_discard_new_call_t);
 struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *,
@@ -60,9 +63,6 @@ void rxrpc_kernel_end_call(struct socket *, struct rxrpc_call *);
 void rxrpc_kernel_get_peer(struct socket *, struct rxrpc_call *,
 			   struct sockaddr_rxrpc *);
 bool rxrpc_kernel_get_srtt(struct socket *, struct rxrpc_call *, u32 *);
-int rxrpc_kernel_charge_accept(struct socket *, rxrpc_notify_rx_t,
-			       rxrpc_user_attach_call_t, unsigned long, gfp_t,
-			       unsigned int);
 void rxrpc_kernel_set_tx_length(struct socket *, struct rxrpc_call *, s64);
 bool rxrpc_kernel_check_life(const struct socket *, const struct rxrpc_call *);
 u32 rxrpc_kernel_get_epoch(struct socket *, struct rxrpc_call *);
@@ -73,5 +73,6 @@ void rxrpc_kernel_set_max_life(struct socket *, struct rxrpc_call *,
 			       unsigned long);
 
 int rxrpc_sock_set_min_security_level(struct sock *sk, unsigned int val);
+int rxrpc_sock_set_upgradeable_service(struct sock *sk, unsigned int val[2]);
 
 #endif /* _NET_RXRPC_H */
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 499f5fabd20f..bbc5f471973a 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -19,7 +19,9 @@
 #define __AFS_DECLARE_TRACE_ENUMS_ONCE_ONLY
 
 enum afs_call_trace {
+	afs_call_trace_accept,
 	afs_call_trace_alloc,
+	afs_call_trace_discard,
 	afs_call_trace_free,
 	afs_call_trace_get,
 	afs_call_trace_put,
@@ -323,7 +325,9 @@ enum afs_cb_break_reason {
  * Declare tracing information enums and their string mappings for display.
  */
 #define afs_call_traces \
+	EM(afs_call_trace_accept,		"ACCPT") \
 	EM(afs_call_trace_alloc,		"ALLOC") \
+	EM(afs_call_trace_discard,		"DSCRD") \
 	EM(afs_call_trace_free,			"FREE ") \
 	EM(afs_call_trace_get,			"GET  ") \
 	EM(afs_call_trace_put,			"PUT  ") \
diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index d20bf4aa0204..b9b0b694b223 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -68,8 +68,11 @@
 	E_(rxrpc_client_to_idle,		"->Idle")
 
 #define rxrpc_call_traces \
+	EM(rxrpc_call_accepted,			"ACC") \
 	EM(rxrpc_call_connected,		"CON") \
+	EM(rxrpc_call_discard,			"DSC") \
 	EM(rxrpc_call_error,			"*E*") \
+	EM(rxrpc_call_get_socket_list,		"Gsl") \
 	EM(rxrpc_call_got,			"GOT") \
 	EM(rxrpc_call_got_kernel,		"Gke") \
 	EM(rxrpc_call_got_timer,		"GTM") \
@@ -80,6 +83,7 @@
 	EM(rxrpc_call_put_kernel,		"Pke") \
 	EM(rxrpc_call_put_noqueue,		"PnQ") \
 	EM(rxrpc_call_put_notimer,		"PnT") \
+	EM(rxrpc_call_put_socket_list,		"Psl") \
 	EM(rxrpc_call_put_timer,		"PTM") \
 	EM(rxrpc_call_put_userid,		"Pus") \
 	EM(rxrpc_call_queued,			"QUE") \
@@ -439,7 +443,7 @@ TRACE_EVENT(rxrpc_call,
 		    __entry->aux = aux;
 			   ),
 
-	    TP_printk("c=%08x %s u=%d sp=%pSR a=%p",
+	    TP_printk("c=%08x %s u=%d sp=%pSR a=%px",
 		      __entry->call,
 		      __print_symbolic(__entry->op, rxrpc_call_traces),
 		      __entry->usage,
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 5519c2bef7f5..703e10969d2f 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -15,6 +15,7 @@
 #include <linux/random.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
+#include <linux/circ_buf.h>
 #include <linux/key-type.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -123,6 +124,117 @@ static int rxrpc_validate_address(struct rxrpc_sock *rx,
 	return 0;
 }
 
+/*
+ * Bind a service to an rxrpc socket.
+ */
+static int rxrpc_bind_service(struct rxrpc_sock *rx, struct rxrpc_local *local,
+			      u16 service_id)
+{
+	struct rxrpc_service_ids *ids;
+	struct rxrpc_service *b;
+	int i;
+
+	list_for_each_entry(b, &local->services, local_link) {
+		ids = rcu_dereference_protected(
+			b->ids, lockdep_is_held(&rx->local->services_lock));
+		for (i = 0; i < ids->nr_ids; i++)
+			if (service_id == ids->ids[i].service_id)
+				return -EADDRINUSE;
+	}
+
+	b = kzalloc(sizeof(struct rxrpc_service), GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&b->local_link);
+	INIT_LIST_HEAD(&b->to_be_accepted);
+	INIT_LIST_HEAD(&b->waiting_sockets);
+	INIT_WORK(&b->preallocator, rxrpc_service_preallocate);
+	spin_lock_init(&b->incoming_lock);
+	refcount_set(&b->ref, 1);
+	refcount_set(&b->active, 1);
+	b->local = local;
+
+	ids = kzalloc(struct_size(ids, ids, 1), GFP_KERNEL);
+	if (!ids) {
+		kfree(b);
+		return -ENOMEM;
+	}
+
+	ids->nr_ids = 1;
+	ids->ids[0].service_id = service_id;
+	rcu_assign_pointer(b->ids, ids);
+
+	rx->service = b;
+	rx->local = local;
+	list_add_tail_rcu(&b->local_link, &local->services);
+	return 0;
+}
+
+/*
+ * Bind an additional service to an rxrpc socket.
+ */
+static int rxrpc_bind_service2(struct rxrpc_sock *rx, struct rxrpc_local *local,
+			       u16 service_id)
+{
+	struct rxrpc_service_ids *ids, *old;
+	struct rxrpc_service *b;
+	int i;
+
+	list_for_each_entry(b, &local->services, local_link) {
+		ids = rcu_dereference_protected(
+			b->ids, lockdep_is_held(&rx->local->services_lock));
+		for (i = 0; i < ids->nr_ids; i++)
+			if (service_id == ids->ids[i].service_id)
+				return -EADDRINUSE;
+	}
+
+	b = rx->service;
+	old = rcu_dereference_protected(
+		b->ids, lockdep_is_held(&local->services_lock));
+
+	ids = kzalloc(struct_size(ids, ids, old->nr_ids + 1), GFP_KERNEL);
+	if (!ids)
+		return -ENOMEM;
+
+	memcpy(ids, old, struct_size(ids, ids, old->nr_ids));
+	ids->ids[ids->nr_ids++].service_id = service_id;
+	rcu_assign_pointer(b->ids, ids);
+	kfree_rcu(old, rcu);
+	return 0;
+}
+
+/*
+ * Mark a service on an rxrpc socket as upgradable.  Both service IDs must have
+ * been bound to this socket and upgrade-to-same is not allowed.
+ */
+static int rxrpc_bind_service_upgrade(struct rxrpc_sock *rx,
+				      u16 service_id, u16 upgrade_to)
+{
+	struct rxrpc_service_ids *ids;
+	struct rxrpc_service *b = rx->service;
+	int i;
+
+	if (upgrade_to == service_id)
+		return -EINVAL;
+
+	ids = rcu_dereference_protected(
+		b->ids, lockdep_is_held(&rx->local->services_lock));
+	for (i = 0; i < ids->nr_ids; i++)
+		if (upgrade_to == ids->ids[i].service_id)
+			goto found_upgrade;
+	return -EINVAL;
+
+found_upgrade:
+	for (i = 0; i < ids->nr_ids; i++) {
+		if (service_id == ids->ids[i].service_id) {
+			if (ids->ids[i].upgrade_to)
+				return -EINVAL;
+			ids->ids[i].upgrade_to = upgrade_to;
+		}
+	}
+	return 0;
+}
+
 /*
  * bind a local address to an RxRPC socket
  */
@@ -145,41 +257,45 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 
 	switch (rx->sk.sk_state) {
 	case RXRPC_UNBOUND:
-		rx->srx = *srx;
-		local = rxrpc_lookup_local(sock_net(&rx->sk), &rx->srx);
+		local = rxrpc_lookup_local(sock_net(&rx->sk), srx,
+					   rx->sk.sk_kern_sock);
 		if (IS_ERR(local)) {
 			ret = PTR_ERR(local);
 			goto error_unlock;
 		}
 
 		if (service_id) {
-			write_lock(&local->services_lock);
-			if (rcu_access_pointer(local->service))
+			mutex_lock(&local->services_lock);
+			ret = rxrpc_bind_service(rx, local, service_id);
+			if (ret)
 				goto service_in_use;
-			rx->local = local;
-			rcu_assign_pointer(local->service, rx);
-			write_unlock(&local->services_lock);
+			mutex_unlock(&local->services_lock);
 
+			srx->srx_service = 0;
+			rx->srx = *srx;
 			rx->sk.sk_state = RXRPC_SERVER_BOUND;
 		} else {
+			srx->srx_service = 0;
+			rx->srx = *srx;
 			rx->local = local;
 			rx->sk.sk_state = RXRPC_CLIENT_BOUND;
 		}
 		break;
 
 	case RXRPC_SERVER_BOUND:
+		local = rx->local;
 		ret = -EINVAL;
 		if (service_id == 0)
 			goto error_unlock;
-		ret = -EADDRINUSE;
-		if (service_id == rx->srx.srx_service)
-			goto error_unlock;
-		ret = -EINVAL;
-		srx->srx_service = rx->srx.srx_service;
+		srx->srx_service = 0;
 		if (memcmp(srx, &rx->srx, sizeof(*srx)) != 0)
 			goto error_unlock;
-		rx->second_service = service_id;
-		rx->sk.sk_state = RXRPC_SERVER_BOUND2;
+
+		mutex_lock(&local->services_lock);
+		ret = rxrpc_bind_service2(rx, local, service_id);
+		if (ret)
+			goto service_in_use;
+		mutex_unlock(&local->services_lock);
 		break;
 
 	default:
@@ -192,7 +308,7 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 	return 0;
 
 service_in_use:
-	write_unlock(&local->services_lock);
+	mutex_unlock(&local->services_lock);
 	rxrpc_unuse_local(local);
 	rxrpc_put_local(local);
 	ret = -EADDRINUSE;
@@ -209,20 +325,21 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 static int rxrpc_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
+	struct rxrpc_service *b;
 	struct rxrpc_sock *rx = rxrpc_sk(sk);
-	unsigned int max, old;
+	unsigned int max;
 	int ret;
 
 	_enter("%p,%d", rx, backlog);
 
 	lock_sock(&rx->sk);
+	b = rx->service;
 
 	switch (rx->sk.sk_state) {
 	case RXRPC_UNBOUND:
 		ret = -EADDRNOTAVAIL;
 		break;
 	case RXRPC_SERVER_BOUND:
-	case RXRPC_SERVER_BOUND2:
 		ASSERT(rx->local != NULL);
 		max = READ_ONCE(rxrpc_max_backlog);
 		ret = -EINVAL;
@@ -230,19 +347,24 @@ static int rxrpc_listen(struct socket *sock, int backlog)
 			backlog = max;
 		else if (backlog < 0 || backlog > max)
 			break;
-		old = sk->sk_max_ack_backlog;
-		sk->sk_max_ack_backlog = backlog;
-		ret = rxrpc_service_prealloc(rx, GFP_KERNEL);
-		if (ret == 0)
-			rx->sk.sk_state = RXRPC_SERVER_LISTENING;
-		else
-			sk->sk_max_ack_backlog = old;
+		ret = -ENOMEM;
+		if (!rx->sk.sk_kern_sock) {
+			rx->call_id_backlog =
+				kcalloc(RXRPC_BACKLOG_MAX,
+					sizeof(rx->call_id_backlog[0]),
+					GFP_KERNEL);
+			if (!rx->call_id_backlog)
+				break;
+		}
+		b->max_tba = backlog;
+		rx->sk.sk_state = RXRPC_SERVER_LISTENING;
+		schedule_work(&b->preallocator);
+		ret = 0;
 		break;
 	case RXRPC_SERVER_LISTENING:
 		if (backlog == 0) {
 			rx->sk.sk_state = RXRPC_SERVER_LISTEN_DISABLED;
-			sk->sk_max_ack_backlog = 0;
-			rxrpc_discard_prealloc(rx);
+			b->max_tba = 0;
 			ret = 0;
 			break;
 		}
@@ -354,7 +476,7 @@ void rxrpc_kernel_end_call(struct socket *sock, struct rxrpc_call *call)
 	_enter("%d{%d}", call->debug_id, refcount_read(&call->ref));
 
 	mutex_lock(&call->user_mutex);
-	rxrpc_release_call(rxrpc_sk(sock->sk), call);
+	rxrpc_release_call(call);
 
 	/* Make sure we're not going to call back into a kernel service */
 	if (call->notify_rx) {
@@ -400,6 +522,8 @@ EXPORT_SYMBOL(rxrpc_kernel_get_epoch);
 /**
  * rxrpc_kernel_new_call_notification - Get notifications of new calls
  * @sock: The socket to intercept received messages on
+ * @notify_rx: Event notification function for the call
+ * @preallocate_call: Func to obtain a user_call_ID
  * @notify_new_call: Function to be called when new calls appear
  * @discard_new_call: Function to discard preallocated calls
  *
@@ -407,13 +531,19 @@ EXPORT_SYMBOL(rxrpc_kernel_get_epoch);
  */
 void rxrpc_kernel_new_call_notification(
 	struct socket *sock,
+	rxrpc_notify_rx_t notify_rx,
+	rxrpc_preallocate_call_t preallocate_call,
 	rxrpc_notify_new_call_t notify_new_call,
 	rxrpc_discard_new_call_t discard_new_call)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
+	struct rxrpc_service *b = rx->service;
 
-	rx->notify_new_call = notify_new_call;
-	rx->discard_new_call = discard_new_call;
+	b->kernel_sock = sock->sk;
+	b->notify_rx = notify_rx;
+	b->preallocate_call = preallocate_call;
+	b->notify_new_call = notify_new_call;
+	b->discard_new_call = discard_new_call;
 }
 EXPORT_SYMBOL(rxrpc_kernel_new_call_notification);
 
@@ -539,7 +669,8 @@ static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
 			ret = -EAFNOSUPPORT;
 			goto error_unlock;
 		}
-		local = rxrpc_lookup_local(sock_net(sock->sk), &rx->srx);
+		local = rxrpc_lookup_local(sock_net(sock->sk), &rx->srx,
+					   rx->sk.sk_kern_sock);
 		if (IS_ERR(local)) {
 			ret = PTR_ERR(local);
 			goto error_unlock;
@@ -586,6 +717,22 @@ int rxrpc_sock_set_min_security_level(struct sock *sk, unsigned int val)
 }
 EXPORT_SYMBOL(rxrpc_sock_set_min_security_level);
 
+int rxrpc_sock_set_upgradeable_service(struct sock *sk, unsigned int val[2])
+{
+	struct rxrpc_sock *rx = rxrpc_sk(sk);
+	int ret = -EISCONN;
+
+	lock_sock(sk);
+	if (rx->sk.sk_state == RXRPC_SERVER_BOUND) {
+		mutex_lock(&rx->local->services_lock);
+		ret = rxrpc_bind_service_upgrade(rx, val[0], val[1]);
+		mutex_unlock(&rx->local->services_lock);
+	}
+	release_sock(sk);
+	return ret;
+}
+EXPORT_SYMBOL(rxrpc_sock_set_upgradeable_service);
+
 /*
  * set RxRPC socket options
  */
@@ -653,24 +800,21 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 
 		case RXRPC_UPGRADEABLE_SERVICE:
 			ret = -EINVAL;
-			if (optlen != sizeof(service_upgrade) ||
-			    rx->service_upgrade.from != 0)
+			if (optlen != sizeof(service_upgrade))
 				goto error;
 			ret = -EISCONN;
-			if (rx->sk.sk_state != RXRPC_SERVER_BOUND2)
+			if (rx->sk.sk_state != RXRPC_SERVER_BOUND)
 				goto error;
 			ret = -EFAULT;
 			if (copy_from_sockptr(service_upgrade, optval,
 					   sizeof(service_upgrade)) != 0)
 				goto error;
-			ret = -EINVAL;
-			if ((service_upgrade[0] != rx->srx.srx_service ||
-			     service_upgrade[1] != rx->second_service) &&
-			    (service_upgrade[0] != rx->second_service ||
-			     service_upgrade[1] != rx->srx.srx_service))
+			mutex_lock(&rx->local->services_lock);
+			ret = rxrpc_bind_service_upgrade(rx, service_upgrade[0],
+							 service_upgrade[1]);
+			mutex_unlock(&rx->local->services_lock);
+			if (ret < 0)
 				goto error;
-			rx->service_upgrade.from = service_upgrade[0];
-			rx->service_upgrade.to = service_upgrade[1];
 			goto success;
 
 		default:
@@ -721,6 +865,7 @@ static __poll_t rxrpc_poll(struct file *file, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	struct rxrpc_sock *rx = rxrpc_sk(sk);
+	struct rxrpc_service *b = rx->service;
 	__poll_t mask;
 
 	sock_poll_wait(file, sock, wait);
@@ -737,6 +882,12 @@ static __poll_t rxrpc_poll(struct file *file, struct socket *sock,
 	if (rxrpc_writable(sk))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
+	if (b &&
+	    !list_empty(&b->to_be_accepted) &&
+	    CIRC_CNT(rx->call_id_backlog_head, rx->call_id_backlog_tail,
+		     RXRPC_BACKLOG_MAX) == 0)
+		mask |= EPOLLIN | EPOLLRDNORM;
+
 	return mask;
 }
 
@@ -771,17 +922,15 @@ static int rxrpc_create(struct net *net, struct socket *sock, int protocol,
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	sk->sk_state		= RXRPC_UNBOUND;
 	sk->sk_write_space	= rxrpc_write_space;
-	sk->sk_max_ack_backlog	= 0;
 	sk->sk_destruct		= rxrpc_sock_destructor;
 
 	rx = rxrpc_sk(sk);
 	rx->family = protocol;
 	rx->calls = RB_ROOT;
 
-	spin_lock_init(&rx->incoming_lock);
 	INIT_LIST_HEAD(&rx->sock_calls);
-	INIT_LIST_HEAD(&rx->to_be_accepted);
 	INIT_LIST_HEAD(&rx->recvmsg_q);
+	INIT_LIST_HEAD(&rx->accepting_link);
 	rwlock_init(&rx->recvmsg_lock);
 	rwlock_init(&rx->call_lock);
 	memset(&rx->srx, 0, sizeof(rx->srx));
@@ -803,7 +952,6 @@ static int rxrpc_create(struct net *net, struct socket *sock, int protocol,
 static int rxrpc_shutdown(struct socket *sock, int flags)
 {
 	struct sock *sk = sock->sk;
-	struct rxrpc_sock *rx = rxrpc_sk(sk);
 	int ret = 0;
 
 	_enter("%p,%d", sk, flags);
@@ -823,9 +971,6 @@ static int rxrpc_shutdown(struct socket *sock, int flags)
 		ret = -ESHUTDOWN;
 	}
 	spin_unlock_bh(&sk->sk_receive_queue.lock);
-
-	rxrpc_discard_prealloc(rx);
-
 	release_sock(sk);
 	return ret;
 }
@@ -862,6 +1007,8 @@ static int rxrpc_release_sock(struct sock *sk)
 	/* declare the socket closed for business */
 	sock_orphan(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
+	if (rx->service)
+		rxrpc_deactivate_service(rx);
 
 	/* We want to kill off all connections from a service socket
 	 * as fast as possible because we can't share these; client
@@ -869,7 +1016,6 @@ static int rxrpc_release_sock(struct sock *sk)
 	 */
 	switch (sk->sk_state) {
 	case RXRPC_SERVER_BOUND:
-	case RXRPC_SERVER_BOUND2:
 	case RXRPC_SERVER_LISTENING:
 	case RXRPC_SERVER_LISTEN_DISABLED:
 		rx->local->service_closed = true;
@@ -880,14 +1026,11 @@ static int rxrpc_release_sock(struct sock *sk)
 	sk->sk_state = RXRPC_CLOSE;
 	spin_unlock_bh(&sk->sk_receive_queue.lock);
 
-	if (rx->local && rcu_access_pointer(rx->local->service) == rx) {
-		write_lock(&rx->local->services_lock);
-		rcu_assign_pointer(rx->local->service, NULL);
-		write_unlock(&rx->local->services_lock);
-	}
-
 	/* try to flush out this socket */
-	rxrpc_discard_prealloc(rx);
+	if (rx->service) {
+		kfree(rx->call_id_backlog);
+		rxrpc_put_service(rxnet, rx->service);
+	}
 	rxrpc_release_calls_on_socket(rx);
 	flush_workqueue(rxrpc_workqueue);
 	rxrpc_purge_queue(&sk->sk_receive_queue);
@@ -901,8 +1044,6 @@ static int rxrpc_release_sock(struct sock *sk)
 	rx->local = NULL;
 	key_put(rx->key);
 	rx->key = NULL;
-	key_put(rx->securities);
-	rx->securities = NULL;
 	sock_put(sk);
 
 	_leave(" = 0");
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 68d269598305..89f86c31a50b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -47,7 +47,6 @@ enum {
 	RXRPC_CLIENT_UNBOUND,		/* Unbound socket used as client */
 	RXRPC_CLIENT_BOUND,		/* client local address bound */
 	RXRPC_SERVER_BOUND,		/* server local address bound */
-	RXRPC_SERVER_BOUND2,		/* second server local address bound */
 	RXRPC_SERVER_LISTENING,		/* server listening for connections */
 	RXRPC_SERVER_LISTEN_DISABLED,	/* server listening disabled */
 	RXRPC_CLOSE,			/* socket is being closed */
@@ -57,6 +56,7 @@ enum {
  * Per-network namespace data.
  */
 struct rxrpc_net {
+	struct net		*net;
 	struct proc_dir_entry	*proc_net;	/* Subdir in /proc/net */
 	u32			epoch;		/* Local epoch for detecting local-end reset */
 	struct list_head	calls;		/* List of calls active in this namespace */
@@ -97,14 +97,49 @@ struct rxrpc_net {
 };
 
 /*
- * Service backlog preallocation.
+ * List of services listened on and their upgraded versions.
+ */
+struct rxrpc_service_ids {
+	struct rcu_head		rcu;
+	unsigned int		nr_ids;
+	struct {
+		u16		service_id;	/* Service ID to listen on */
+		u16		upgrade_to;	/* Service ID to upgrade to (or 0) */
+	} ids[];
+};
+
+/*
+ * Active service.  This may be shared between a number of sockets.
  *
  * This contains circular buffers of preallocated peers, connections and calls
  * for incoming service calls and their head and tail pointers.  This allows
  * calls to be set up in the data_ready handler, thereby avoiding the need to
  * shuffle packets around so much.
  */
-struct rxrpc_backlog {
+struct rxrpc_service {
+	struct rcu_head		rcu;
+	struct rxrpc_local	*local;		/* Local endpoint */
+	struct list_head	local_link;	/* Link in local->service_list */
+	struct list_head	to_be_accepted;	/* Calls awaiting acceptance */
+	struct list_head	waiting_sockets; /* List of sockets waiting to accept */
+	struct work_struct	preallocator;	/* Preallocator work item */
+	struct rxrpc_service_ids __rcu *ids;	/* List of service IDs */
+	struct key		*securities;	/* list of server security descriptors */
+	spinlock_t		incoming_lock;	/* Incoming call vs service shutdown lock */
+	refcount_t		ref;
+	refcount_t		active;		/* Active socket count */
+	unsigned int		nr_tba;		/* Number of calls on to_be_accepted */
+	unsigned int		max_tba;	/* Maximum number of calls on to_be_accepted */
+	int			error;		/* Allocation error */
+
+	/* Notifications for kernel-based services. */
+	struct sock		*kernel_sock;	/* Kernel's socket */
+	rxrpc_notify_rx_t	notify_rx;	/* Setting to call->notify_rx */
+	rxrpc_preallocate_call_t preallocate_call; /* Func to preallocate a call */
+	rxrpc_notify_new_call_t	notify_new_call; /* Func to notify of new call */
+	rxrpc_discard_new_call_t discard_new_call; /* Func to discard a new call */
+
+	/* Structure preallocation. */
 	unsigned short		peer_backlog_head;
 	unsigned short		peer_backlog_tail;
 	unsigned short		conn_backlog_head;
@@ -123,31 +158,24 @@ struct rxrpc_backlog {
 struct rxrpc_sock {
 	/* WARNING: sk has to be the first member */
 	struct sock		sk;
-	rxrpc_notify_new_call_t	notify_new_call; /* Func to notify of new call */
-	rxrpc_discard_new_call_t discard_new_call; /* Func to discard a new call */
 	struct rxrpc_local	*local;		/* local endpoint */
-	struct rxrpc_backlog	*backlog;	/* Preallocation for services */
-	spinlock_t		incoming_lock;	/* Incoming call vs service shutdown lock */
+	struct rxrpc_service	*service;
+	unsigned long		*call_id_backlog; /* Precharged call IDs */
 	struct list_head	sock_calls;	/* List of calls owned by this socket */
-	struct list_head	to_be_accepted;	/* calls awaiting acceptance */
 	struct list_head	recvmsg_q;	/* Calls awaiting recvmsg's attention  */
+	struct list_head	accepting_link;	/* Link in service->waiting_sockets */
 	struct hlist_node	ns_link;	/* Link in net->sockets */
 	rwlock_t		recvmsg_lock;	/* Lock for recvmsg_q */
 	struct key		*key;		/* security for this socket */
-	struct key		*securities;	/* list of server security descriptors */
 	struct rb_root		calls;		/* User ID -> call mapping */
 	unsigned long		flags;
-#define RXRPC_SOCK_CONNECTED		0	/* connect_srx is set */
+#define RXRPC_SOCK_CONNECTED	0		/* connect_srx is set */
 	rwlock_t		call_lock;	/* lock for calls */
 	u32			min_sec_level;	/* minimum security level */
 #define RXRPC_SECURITY_MAX	RXRPC_SECURITY_ENCRYPT
 	bool			exclusive;	/* Exclusive connection for a client socket */
-	u16			second_service;	/* Additional service bound to the endpoint */
-	struct {
-		/* Service upgrade information */
-		u16		from;		/* Service ID to upgrade (if not 0) */
-		u16		to;		/* service ID to upgrade to */
-	} service_upgrade;
+	unsigned short		call_id_backlog_head;
+	unsigned short		call_id_backlog_tail;
 	sa_family_t		family;		/* Protocol family created with */
 	struct sockaddr_rxrpc	srx;		/* Primary Service/local addresses */
 	struct sockaddr_rxrpc	connect_srx;	/* Default client address from connect() */
@@ -278,17 +306,18 @@ struct rxrpc_local {
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct work_struct	processor;
-	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
+	struct list_head	services;	/* Service(s) listening on this endpoint */
+	struct mutex		services_lock;	/* Lock for services list */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	reject_queue;	/* packets awaiting rejection */
 	struct sk_buff_head	event_queue;	/* endpoint event packets awaiting processing */
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
 	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
 	spinlock_t		lock;		/* access lock */
-	rwlock_t		services_lock;	/* lock for services list */
 	int			debug_id;	/* debug ID for printks */
 	bool			dead;
 	bool			service_closed;	/* Service socket closed */
+	bool			kernel;		/* T if kernel endpoint */
 	struct sockaddr_rxrpc	srx;		/* local address */
 };
 
@@ -500,6 +529,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 	RXRPC_CALL_KERNEL,		/* The call was made by the kernel */
 	RXRPC_CALL_UPGRADE,		/* Service upgrade was requested for the call */
+	RXRPC_CALL_NEWLY_ACCEPTED,	/* Incoming call hasn't yet been reported by recvmsg */
 };
 
 /*
@@ -564,8 +594,10 @@ struct rxrpc_call {
 	struct rcu_head		rcu;
 	struct rxrpc_connection	*conn;		/* connection carrying call */
 	struct rxrpc_peer	*peer;		/* Peer record for remote address */
+	struct rxrpc_local	*local;		/* Local endpoint */
 	struct rxrpc_sock __rcu	*socket;	/* socket responsible */
 	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
+	struct rxrpc_service	*service;	/* The service this call came in through */
 	const struct rxrpc_security *security;	/* applied security module */
 	struct mutex		user_mutex;	/* User access mutex */
 	unsigned long		ack_at;		/* When deferred ACK needs to happen */
@@ -585,7 +617,6 @@ struct rxrpc_call {
 	struct list_head	link;		/* link in master call list */
 	struct list_head	chan_wait_link;	/* Link in conn->bundle->waiting_calls */
 	struct hlist_node	error_link;	/* link in error distribution list */
-	struct list_head	accept_link;	/* Link in rx->acceptq */
 	struct list_head	recvmsg_link;	/* Link in rx->recvmsg_q */
 	struct list_head	sock_link;	/* Link in rx->sock_calls */
 	struct rb_node		sock_node;	/* Node in rx->calls */
@@ -757,12 +788,12 @@ extern struct workqueue_struct *rxrpc_workqueue;
 /*
  * call_accept.c
  */
-int rxrpc_service_prealloc(struct rxrpc_sock *, gfp_t);
-void rxrpc_discard_prealloc(struct rxrpc_sock *);
+void rxrpc_service_preallocate(struct work_struct *work);
+void rxrpc_put_service(struct rxrpc_net *, struct rxrpc_service *);
+void rxrpc_deactivate_service(struct rxrpc_sock *);
 struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *,
-					   struct rxrpc_sock *,
 					   struct sk_buff *);
-void rxrpc_accept_incoming_calls(struct rxrpc_local *);
+void rxrpc_accept_incoming_call(struct rxrpc_sock *);
 int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
 
 /*
@@ -788,15 +819,15 @@ extern unsigned int rxrpc_max_call_lifetime;
 extern struct kmem_cache *rxrpc_call_jar;
 
 struct rxrpc_call *rxrpc_find_call_by_user_ID(struct rxrpc_sock *, unsigned long);
-struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *, gfp_t, unsigned int);
+struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_local *, gfp_t, unsigned int,
+				    struct rxrpc_service *);
 struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *,
 					 struct rxrpc_conn_parameters *,
 					 struct sockaddr_rxrpc *,
 					 struct rxrpc_call_params *, gfp_t,
 					 unsigned int);
-void rxrpc_incoming_call(struct rxrpc_sock *, struct rxrpc_call *,
-			 struct sk_buff *);
-void rxrpc_release_call(struct rxrpc_sock *, struct rxrpc_call *);
+void rxrpc_incoming_call(struct rxrpc_call *, struct sk_buff *);
+void rxrpc_release_call(struct rxrpc_call *);
 void rxrpc_release_calls_on_socket(struct rxrpc_sock *);
 bool __rxrpc_queue_call(struct rxrpc_call *);
 bool rxrpc_queue_call(struct rxrpc_call *);
@@ -898,7 +929,7 @@ static inline void rxrpc_reduce_conn_timer(struct rxrpc_connection *conn,
 struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *,
 						     struct sk_buff *);
 struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *, gfp_t);
-void rxrpc_new_incoming_connection(struct rxrpc_sock *, struct rxrpc_connection *,
+void rxrpc_new_incoming_connection(const struct rxrpc_service *, struct rxrpc_connection *,
 				   const struct rxrpc_security *, struct sk_buff *);
 void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 
@@ -929,7 +960,8 @@ extern void rxrpc_process_local_events(struct rxrpc_local *);
 /*
  * local_object.c
  */
-struct rxrpc_local *rxrpc_lookup_local(struct net *, const struct sockaddr_rxrpc *);
+struct rxrpc_local *rxrpc_lookup_local(struct net *, const struct sockaddr_rxrpc *,
+				       bool);
 struct rxrpc_local *rxrpc_get_local(struct rxrpc_local *);
 struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *);
 void rxrpc_put_local(struct rxrpc_local *);
@@ -995,8 +1027,7 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *,
 struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *, struct rxrpc_local *,
 				     struct sockaddr_rxrpc *, gfp_t);
 struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t);
-void rxrpc_new_incoming_peer(struct rxrpc_sock *, struct rxrpc_local *,
-			     struct rxrpc_peer *);
+void rxrpc_new_incoming_peer(struct rxrpc_local *, struct rxrpc_peer *);
 void rxrpc_destroy_all_peers(struct rxrpc_net *);
 struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *);
 struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *);
@@ -1065,7 +1096,7 @@ int __init rxrpc_init_security(void);
 const struct rxrpc_security *rxrpc_security_lookup(u8);
 void rxrpc_exit_security(void);
 int rxrpc_init_client_conn_security(struct rxrpc_connection *);
-const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *,
+const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_service *,
 							 struct sk_buff *);
 struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
 					  struct sk_buff *, u32, u32);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 99e10eea3732..3cba4dacb8d4 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -31,167 +31,284 @@ static void rxrpc_dummy_notify(struct sock *sk, struct rxrpc_call *call,
  * Preallocate a single service call, connection and peer and, if possible,
  * give them a user ID and attach the user's side of the ID to them.
  */
-static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
-				      struct rxrpc_backlog *b,
-				      rxrpc_notify_rx_t notify_rx,
-				      rxrpc_user_attach_call_t user_attach_call,
-				      unsigned long user_call_ID, gfp_t gfp,
-				      unsigned int debug_id)
+void rxrpc_service_preallocate(struct work_struct *work)
 {
-	const void *here = __builtin_return_address(0);
-	struct rxrpc_call *call, *xcall;
-	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
-	struct rb_node *parent, **pp;
-	int max, tmp;
-	unsigned int size = RXRPC_BACKLOG_MAX;
-	unsigned int head, tail, call_head, call_tail;
-
-	max = rx->sk.sk_max_ack_backlog;
-	tmp = rx->sk.sk_ack_backlog;
-	if (tmp >= max) {
-		_leave(" = -ENOBUFS [full %u]", max);
-		return -ENOBUFS;
-	}
-	max -= tmp;
+	struct rxrpc_service *b = container_of(work, struct rxrpc_service, preallocator);
+	struct rxrpc_local *local = b->local;
+	struct rxrpc_net *rxnet = local->rxnet;
+	unsigned int head, tail, size = RXRPC_BACKLOG_MAX;
+	int max = b->max_tba;
 
-	/* We don't need more conns and peers than we have calls, but on the
-	 * other hand, we shouldn't ever use more peers than conns or conns
-	 * than calls.
-	 */
-	call_head = b->call_backlog_head;
-	call_tail = READ_ONCE(b->call_backlog_tail);
-	tmp = CIRC_CNT(call_head, call_tail, size);
-	if (tmp >= max) {
-		_leave(" = -ENOBUFS [enough %u]", tmp);
-		return -ENOBUFS;
-	}
-	max = tmp + 1;
+	if (!refcount_read(&b->active))
+		return;
 
 	head = b->peer_backlog_head;
 	tail = READ_ONCE(b->peer_backlog_tail);
-	if (CIRC_CNT(head, tail, size) < max) {
-		struct rxrpc_peer *peer = rxrpc_alloc_peer(rx->local, gfp);
+	while (CIRC_CNT(head, tail, size) < max) {
+		struct rxrpc_peer *peer = rxrpc_alloc_peer(local, GFP_KERNEL);
 		if (!peer)
-			return -ENOMEM;
-		b->peer_backlog[head] = peer;
-		smp_store_release(&b->peer_backlog_head,
-				  (head + 1) & (size - 1));
+			goto nomem;
+		b->peer_backlog[head++] = peer;
+		head &= size - 1;
+		smp_store_release(&b->peer_backlog_head, head);
 	}
 
 	head = b->conn_backlog_head;
 	tail = READ_ONCE(b->conn_backlog_tail);
-	if (CIRC_CNT(head, tail, size) < max) {
+	while (CIRC_CNT(head, tail, size) < max) {
 		struct rxrpc_connection *conn;
 
-		conn = rxrpc_prealloc_service_connection(rxnet, gfp);
+		conn = rxrpc_prealloc_service_connection(rxnet, GFP_KERNEL);
 		if (!conn)
-			return -ENOMEM;
-		b->conn_backlog[head] = conn;
-		smp_store_release(&b->conn_backlog_head,
-				  (head + 1) & (size - 1));
+			goto nomem;
 
 		trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_service,
-				 refcount_read(&conn->ref), here);
+				 refcount_read(&conn->ref), NULL);
+
+		b->conn_backlog[head++] = conn;
+		head &= size - 1;
+		smp_store_release(&b->conn_backlog_head, head);
 	}
 
-	/* Now it gets complicated, because calls get registered with the
-	 * socket here, with a user ID preassigned by the user.
-	 */
-	call = rxrpc_alloc_call(rx, gfp, debug_id);
-	if (!call)
-		return -ENOMEM;
-	call->flags |= (1 << RXRPC_CALL_IS_SERVICE);
-	call->state = RXRPC_CALL_SERVER_PREALLOC;
+	head = b->call_backlog_head;
+	tail = READ_ONCE(b->call_backlog_tail);
+	while (CIRC_CNT(head, tail, size) < max) {
+		struct rxrpc_call *call;
+		unsigned int debug_id = 0;
+
+		if (!b->preallocate_call)
+			debug_id = atomic_inc_return(&rxrpc_debug_id);
+
+		call = rxrpc_alloc_call(b->local, GFP_KERNEL, debug_id, b);
+		if (!call)
+			goto nomem;
+		call->flags |= (1 << RXRPC_CALL_IS_SERVICE);
+		call->state = RXRPC_CALL_SERVER_PREALLOC;
+		call->notify_rx = b->notify_rx;
+		__set_bit(RXRPC_CALL_NEWLY_ACCEPTED, &call->flags);
+
+		if (b->kernel_sock) {
+			struct rxrpc_sock *rx = rxrpc_sk(b->kernel_sock);
+			rxrpc_get_call(call, rxrpc_call_get_socket_list);
+			write_lock(&rx->call_lock);
+			list_add(&call->sock_link, &rx->sock_calls);
+			write_unlock(&rx->call_lock);
+		} else {
+			refcount_inc(&b->ref);
+			call->service = b;
+		}
 
-	trace_rxrpc_call(call->debug_id, rxrpc_call_new_service,
-			 refcount_read(&call->ref),
-			 here, (const void *)user_call_ID);
+		spin_lock_bh(&rxnet->call_lock);
+		list_add_tail_rcu(&call->link, &rxnet->calls);
+		spin_unlock_bh(&rxnet->call_lock);
+
+		trace_rxrpc_call(call->debug_id, rxrpc_call_new_service,
+				 refcount_read(&call->ref), NULL,
+				 (void *)(unsigned long)head);
+
+		b->call_backlog[head++] = call;
+		head &= size - 1;
+		smp_store_release(&b->call_backlog_head, head);
+	}
+
+	return;
+
+nomem:
+	WRITE_ONCE(b->error, -ENOMEM);
+}
+
+/*
+ * Attempt to add a user call ID to the preallocation ring.
+ */
+static int rxrpc_service_charge_user_call_id(struct rxrpc_sock *rx,
+					     unsigned long user_call_ID)
+{
+	struct rxrpc_service *b = rx->service;
+	struct rxrpc_call *xcall;
+	struct rb_node *p;
+	unsigned int head, tail, size = RXRPC_BACKLOG_MAX;
+	unsigned int i;
+	int ret = -EBADSLT, max = b->max_tba;
+
+	_enter("%lx", user_call_ID);
+
+	if (!b)
+		return -EINVAL;
+
+	write_lock(&rx->call_lock);
+
+	/* Check the user ID isn't already in use in the active tree. */
+	p = rx->calls.rb_node;
+	while (p) {
+		xcall = rb_entry(p, struct rxrpc_call, sock_node);
+		if (user_call_ID < xcall->user_call_ID)
+			p = p->rb_left;
+		else if (user_call_ID > xcall->user_call_ID)
+			p = p->rb_right;
+		else
+			goto err;
+	}
+
+	/* We also need to check the preallocation ring. */
+	for (i = 0; i < size; i++)
+		if (user_call_ID == rx->call_id_backlog[i])
+			goto err;
+
+	ret = -ENOBUFS;
+	head = rx->call_id_backlog_head;
+	tail = READ_ONCE(rx->call_id_backlog_tail);
+
+	if (CIRC_CNT(head, tail, size) >= max)
+		goto err;
+
+	rx->call_id_backlog[head & (size - 1)] = user_call_ID;
+	smp_store_release(&rx->call_id_backlog_head, (head + 1) & (size - 1));
+
+	if (list_empty(&rx->accepting_link)) {
+		spin_lock_bh(&b->incoming_lock);
+		if (list_empty(&rx->accepting_link))
+			list_add_tail(&rx->accepting_link, &b->waiting_sockets);
+		spin_unlock_bh(&b->incoming_lock);
+	}			
+	ret = 0;
+
+err:
+	write_unlock(&rx->call_lock);
+	return ret;
+}
+
+/*
+ * Pick an ID for an incoming call and attach it to the socket.  This is only
+ * used for sockets opened by userspace.  Kernel sockets get the user ID set
+ * during preallocation.
+ */
+void rxrpc_accept_incoming_call(struct rxrpc_sock *rx)
+{
+	struct rxrpc_service *b = rx->service;
+	struct rxrpc_call *xcall, *call;
+	struct rb_node *parent, **pp;
+	const void *here = __builtin_return_address(0);
+	unsigned int head, tail, size = RXRPC_BACKLOG_MAX;
+
+	if (CIRC_CNT(rx->call_id_backlog_head, rx->call_id_backlog_tail, size) == 0)
+		return;
 
 	write_lock(&rx->call_lock);
 
-	/* Check the user ID isn't already in use */
+	/* Obtain an ID from the preallocation ring. */
+	head = smp_load_acquire(&rx->call_id_backlog_head);
+	tail = rx->call_id_backlog_tail;
+
+	if (CIRC_CNT(head, tail, size) == 0) {
+		write_unlock(&rx->call_lock);
+		return;
+	}
+
+	spin_lock_bh(&b->incoming_lock);
+
+	call = list_first_entry_or_null(&b->to_be_accepted,
+					struct rxrpc_call, recvmsg_link);
+	if (!call) {
+		spin_unlock_bh(&b->incoming_lock);
+		write_unlock(&rx->call_lock);
+		return;
+	}
+
+	write_lock(&rx->recvmsg_lock);
+	rxrpc_get_call(call, rxrpc_call_got_userid);
+	call->user_call_ID = rx->call_id_backlog[tail];
+	rcu_assign_pointer(call->socket, rx);
+	/* recvmsg_link mustn't be seen to be empty. */
+	list_move_tail(&call->recvmsg_link, &rx->recvmsg_q);
+	b->nr_tba--;
+	write_unlock(&rx->recvmsg_lock);
+
+	rx->call_id_backlog[tail] = 0;
+	tail = (tail + 1) & (size - 1);
+	smp_store_release(&rx->call_id_backlog_tail, tail);
+
+	if (CIRC_CNT(head, tail, size) == 0)
+		list_del_init(&rx->accepting_link);
+
+	spin_unlock_bh(&b->incoming_lock);
+
+	trace_rxrpc_call(call->debug_id, rxrpc_call_accepted,
+			 refcount_read(&call->ref),
+			 here, (const void *)call->user_call_ID);
+
+	/* Insert the ID */
+	set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
+
 	pp = &rx->calls.rb_node;
 	parent = NULL;
 	while (*pp) {
 		parent = *pp;
 		xcall = rb_entry(parent, struct rxrpc_call, sock_node);
-		if (user_call_ID < xcall->user_call_ID)
+		if (call->user_call_ID < xcall->user_call_ID)
 			pp = &(*pp)->rb_left;
-		else if (user_call_ID > xcall->user_call_ID)
+		else if (call->user_call_ID > xcall->user_call_ID)
 			pp = &(*pp)->rb_right;
 		else
 			goto id_in_use;
 	}
 
-	call->user_call_ID = user_call_ID;
-	call->notify_rx = notify_rx;
-	if (user_attach_call) {
-		rxrpc_get_call(call, rxrpc_call_got_kernel);
-		user_attach_call(call, user_call_ID);
-	}
-
-	rxrpc_get_call(call, rxrpc_call_got_userid);
 	rb_link_node(&call->sock_node, parent, pp);
 	rb_insert_color(&call->sock_node, &rx->calls);
-	set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
 
+	rxrpc_get_call(call, rxrpc_call_get_socket_list);
 	list_add(&call->sock_link, &rx->sock_calls);
-
 	write_unlock(&rx->call_lock);
 
-	rxnet = call->rxnet;
-	spin_lock_bh(&rxnet->call_lock);
-	list_add_tail_rcu(&call->link, &rxnet->calls);
-	spin_unlock_bh(&rxnet->call_lock);
-
-	b->call_backlog[call_head] = call;
-	smp_store_release(&b->call_backlog_head, (call_head + 1) & (size - 1));
-	_leave(" = 0 [%d -> %lx]", call->debug_id, user_call_ID);
-	return 0;
+	_leave(" [%d -> %lx]", call->debug_id, call->user_call_ID);
+	return;
 
 id_in_use:
+	WARN_ON(1);
 	write_unlock(&rx->call_lock);
 	rxrpc_cleanup_call(call);
-	_leave(" = -EBADSLT");
-	return -EBADSLT;
+	return;
 }
 
 /*
- * Allocate the preallocation buffers for incoming service calls.  These must
- * be charged manually.
+ * Dispose of a service record.
  */
-int rxrpc_service_prealloc(struct rxrpc_sock *rx, gfp_t gfp)
+void rxrpc_put_service(struct rxrpc_net *rxnet, struct rxrpc_service *b)
 {
-	struct rxrpc_backlog *b = rx->backlog;
-
-	if (!b) {
-		b = kzalloc(sizeof(struct rxrpc_backlog), gfp);
-		if (!b)
-			return -ENOMEM;
-		rx->backlog = b;
+	if (b && refcount_dec_and_test(&b->ref)) {
+		key_put(b->securities);
+		kfree_rcu(b, rcu);
 	}
-
-	return 0;
 }
 
 /*
  * Discard the preallocation on a service.
  */
-void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
+void rxrpc_deactivate_service(struct rxrpc_sock *rx)
 {
-	struct rxrpc_backlog *b = rx->backlog;
+	struct rxrpc_service *b = rx->service;
 	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
 	unsigned int size = RXRPC_BACKLOG_MAX, head, tail;
 
-	if (!b)
+	spin_lock_bh(&b->incoming_lock);
+	list_del_init(&rx->accepting_link);
+	spin_unlock_bh(&b->incoming_lock);
+
+	if (!refcount_dec_and_test(&rx->service->active))
 		return;
-	rx->backlog = NULL;
 
-	/* Make sure that there aren't any incoming calls in progress before we
-	 * clear the preallocation buffers.
+	kdebug("-- deactivate --");
+
+	/* Now that active is 0, make sure that there aren't any incoming calls
+	 * being set up before we clear the preallocation buffers.
 	 */
-	spin_lock_bh(&rx->incoming_lock);
-	spin_unlock_bh(&rx->incoming_lock);
+	spin_lock_bh(&b->incoming_lock);
+	spin_unlock_bh(&b->incoming_lock);
+
+	mutex_lock(&rx->local->services_lock);
+	list_del_rcu(&b->local_link);
+	mutex_unlock(&rx->local->services_lock);
+
+	cancel_work_sync(&b->preallocator);
 
 	head = b->peer_backlog_head;
 	tail = b->peer_backlog_tail;
@@ -218,23 +335,44 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 
 	head = b->call_backlog_head;
 	tail = b->call_backlog_tail;
+	kdebug("backlog %x %x", head, tail);
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_call *call = b->call_backlog[tail];
-		rcu_assign_pointer(call->socket, rx);
-		if (rx->discard_new_call) {
+
+		kdebug("discard c=%08x", call->debug_id);
+
+		trace_rxrpc_call(call->debug_id, rxrpc_call_discard,
+				 refcount_read(&call->ref),
+				 NULL, (const void *)call->user_call_ID);
+		if (b->discard_new_call) {
 			_debug("discard %lx", call->user_call_ID);
-			rx->discard_new_call(call, call->user_call_ID);
+			b->discard_new_call(call, call->user_call_ID);
 			if (call->notify_rx)
 				call->notify_rx = rxrpc_dummy_notify;
 			rxrpc_put_call(call, rxrpc_call_put_kernel);
 		}
+
 		rxrpc_call_completed(call);
-		rxrpc_release_call(rx, call);
+		rxrpc_release_call(call);
 		rxrpc_put_call(call, rxrpc_call_put);
 		tail = (tail + 1) & (size - 1);
 	}
 
-	kfree(b);
+	spin_lock_bh(&b->incoming_lock);
+	while (!list_empty(&b->to_be_accepted)) {
+		struct rxrpc_call *call =
+			list_entry(b->to_be_accepted.next,
+				   struct rxrpc_call, recvmsg_link);
+		list_del(&call->recvmsg_link);
+		spin_unlock_bh(&b->incoming_lock);
+		if (rxrpc_abort_call("SKR", call, 0, RX_CALL_DEAD, -ECONNRESET))
+			rxrpc_send_abort_packet(call);
+		rxrpc_release_call(call);
+		rxrpc_put_call(call, rxrpc_call_put);
+		spin_lock_bh(&b->incoming_lock);
+	}
+	spin_unlock_bh(&b->incoming_lock);
+
 }
 
 /*
@@ -257,14 +395,13 @@ static void rxrpc_send_ping(struct rxrpc_call *call, struct sk_buff *skb)
  * Allocate a new incoming call from the prealloc pool, along with a connection
  * and a peer as necessary.
  */
-static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
+static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_service *b,
 						    struct rxrpc_local *local,
 						    struct rxrpc_peer *peer,
 						    struct rxrpc_connection *conn,
 						    const struct rxrpc_security *sec,
 						    struct sk_buff *skb)
 {
-	struct rxrpc_backlog *b = rx->backlog;
 	struct rxrpc_call *call;
 	unsigned short call_head, conn_head, peer_head;
 	unsigned short call_tail, conn_tail, peer_tail;
@@ -298,7 +435,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 					  (peer_tail + 1) &
 					  (RXRPC_BACKLOG_MAX - 1));
 
-			rxrpc_new_incoming_peer(rx, local, peer);
+			rxrpc_new_incoming_peer(local, peer);
 		}
 
 		/* Now allocate and set up the connection */
@@ -309,7 +446,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		conn->params.local = rxrpc_get_local(local);
 		conn->params.peer = peer;
 		rxrpc_see_connection(conn);
-		rxrpc_new_incoming_connection(rx, conn, sec, skb);
+		rxrpc_new_incoming_connection(b, conn, sec, skb);
 	} else {
 		rxrpc_get_connection(conn);
 	}
@@ -326,6 +463,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	call->security_ix = conn->security_ix;
 	call->peer = rxrpc_get_peer(conn->params.peer);
 	call->cong_cwnd = call->peer->cong_cwnd;
+	__set_bit(RXRPC_CALL_RX_HEARD, &call->flags);
 	return call;
 }
 
@@ -345,20 +483,32 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
  * The call is returned with the user access mutex held.
  */
 struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
-					   struct rxrpc_sock *rx,
 					   struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	const struct rxrpc_service_ids *ids;
 	const struct rxrpc_security *sec = NULL;
 	struct rxrpc_connection *conn;
+	struct rxrpc_service *b;
 	struct rxrpc_peer *peer = NULL;
 	struct rxrpc_call *call = NULL;
+	unsigned int i;
 
 	_enter("");
 
-	spin_lock(&rx->incoming_lock);
-	if (rx->sk.sk_state == RXRPC_SERVER_LISTEN_DISABLED ||
-	    rx->sk.sk_state == RXRPC_CLOSE) {
+	list_for_each_entry_rcu(b, &local->services, local_link) {
+		ids = rcu_dereference(b->ids);
+		for (i = 0; i < ids->nr_ids; i++)
+			if (ids->ids[i].service_id == sp->hdr.serviceId)
+				goto found_service;
+	}
+	_leave(" = NULL [no srv]");
+	return NULL;
+
+found_service:
+	spin_lock(&b->incoming_lock);
+
+	if (refcount_read(&b->active) == 0) {
 		trace_rxrpc_abort(0, "CLS", sp->hdr.cid, sp->hdr.callNumber,
 				  sp->hdr.seq, RX_INVALID_OPERATION, ESHUTDOWN);
 		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
@@ -366,20 +516,25 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 		goto no_call;
 	}
 
+	if (b->nr_tba >= b->max_tba) {
+		skb->mark = RXRPC_SKB_MARK_REJECT_BUSY;
+		goto no_call;
+	}
+
 	/* The peer, connection and call may all have sprung into existence due
 	 * to a duplicate packet being handled on another CPU in parallel, so
 	 * we have to recheck the routing.  However, we're now holding
-	 * rx->incoming_lock, so the values should remain stable.
+	 * incoming_lock, so the values should remain stable.
 	 */
 	conn = rxrpc_find_connection_rcu(local, skb, &peer);
 
 	if (!conn) {
-		sec = rxrpc_get_incoming_security(rx, skb);
+		sec = rxrpc_get_incoming_security(b, skb);
 		if (!sec)
 			goto no_call;
 	}
 
-	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, skb);
+	call = rxrpc_alloc_incoming_call(b, local, peer, conn, sec, skb);
 	if (!call) {
 		skb->mark = RXRPC_SKB_MARK_REJECT_BUSY;
 		goto no_call;
@@ -389,11 +544,14 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 			    sp->hdr.serial, sp->hdr.seq);
 
 	/* Make the call live. */
-	rxrpc_incoming_call(rx, call, skb);
+	rcu_assign_pointer(call->socket, b->kernel_sock);
+	rxrpc_incoming_call(call, skb);
 	conn = call->conn;
 
-	if (rx->notify_new_call)
-		rx->notify_new_call(&rx->sk, call, call->user_call_ID);
+	if (b->notify_new_call)
+		b->notify_new_call(b->kernel_sock, call, call->user_call_ID);
+	spin_unlock(&b->incoming_lock);
+	schedule_work(&b->preallocator);
 
 	spin_lock(&conn->state_lock);
 	switch (conn->state) {
@@ -422,7 +580,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 		BUG();
 	}
 	spin_unlock(&conn->state_lock);
-	spin_unlock(&rx->incoming_lock);
 
 	rxrpc_send_ping(call, skb);
 
@@ -431,13 +588,13 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 * (recvmsg queue, to-be-accepted queue or user ID tree) or the kernel
 	 * service to prevent the call from being deallocated too early.
 	 */
-	rxrpc_put_call(call, rxrpc_call_put);
+	//rxrpc_put_call(call, rxrpc_call_put);
 
 	_leave(" = %p{%d}", call, call->debug_id);
 	return call;
 
 no_call:
-	spin_unlock(&rx->incoming_lock);
+	spin_unlock(&b->incoming_lock);
 	_leave(" = NULL [%u]", skb->mark);
 	return NULL;
 }
@@ -447,45 +604,14 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
  */
 int rxrpc_user_charge_accept(struct rxrpc_sock *rx, unsigned long user_call_ID)
 {
-	struct rxrpc_backlog *b = rx->backlog;
+	int ret;
 
 	if (rx->sk.sk_state == RXRPC_CLOSE)
 		return -ESHUTDOWN;
 
-	return rxrpc_service_prealloc_one(rx, b, NULL, NULL, user_call_ID,
-					  GFP_KERNEL,
-					  atomic_inc_return(&rxrpc_debug_id));
-}
-
-/*
- * rxrpc_kernel_charge_accept - Charge up socket with preallocated calls
- * @sock: The socket on which to preallocate
- * @notify_rx: Event notification function for the call
- * @user_attach_call: Func to attach call to user_call_ID
- * @user_call_ID: The tag to attach to the preallocated call
- * @gfp: The allocation conditions.
- * @debug_id: The tracing debug ID.
- *
- * Charge up the socket with preallocated calls, each with a user ID.  A
- * function should be provided to effect the attachment from the user's side.
- * The user is given a ref to hold on the call.
- *
- * Note that the call may be come connected before this function returns.
- */
-int rxrpc_kernel_charge_accept(struct socket *sock,
-			       rxrpc_notify_rx_t notify_rx,
-			       rxrpc_user_attach_call_t user_attach_call,
-			       unsigned long user_call_ID, gfp_t gfp,
-			       unsigned int debug_id)
-{
-	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
-	struct rxrpc_backlog *b = rx->backlog;
-
-	if (sock->sk->sk_state == RXRPC_CLOSE)
-		return -ESHUTDOWN;
+	ret = xchg(&rx->service->error, 0);
+	if (ret < 0)
+		return ret;
 
-	return rxrpc_service_prealloc_one(rx, b, notify_rx,
-					  user_attach_call, user_call_ID,
-					  gfp, debug_id);
+	return rxrpc_service_charge_user_call_id(rx, user_call_ID);
 }
-EXPORT_SYMBOL(rxrpc_kernel_charge_accept);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 84d0a4109645..e90b205a6c0f 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -119,16 +119,20 @@ struct rxrpc_call *rxrpc_find_call_by_user_ID(struct rxrpc_sock *rx,
 /*
  * allocate a new call
  */
-struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
-				    unsigned int debug_id)
+struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_local *local, gfp_t gfp,
+				    unsigned int debug_id,
+				    struct rxrpc_service *b)
 {
 	struct rxrpc_call *call;
-	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
+	struct rxrpc_net *rxnet = local->rxnet;
 
 	call = kmem_cache_zalloc(rxrpc_call_jar, gfp);
 	if (!call)
 		return NULL;
 
+	call->debug_id = debug_id;
+	refcount_set(&call->ref, 1);
+
 	call->rxtx_buffer = kcalloc(RXRPC_RXTX_BUFF_SIZE,
 				    sizeof(struct sk_buff *),
 				    gfp);
@@ -139,12 +143,20 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	if (!call->rxtx_annotations)
 		goto nomem_2;
 
+	if (b && b->preallocate_call) {
+		call->user_call_ID = b->preallocate_call(b->kernel_sock,
+							 call, &call->debug_id);
+		if (!call->user_call_ID)
+			goto nomem_3;
+		rxrpc_get_call(call, rxrpc_call_got_kernel);
+	}
+
 	mutex_init(&call->user_mutex);
 
 	/* Prevent lockdep reporting a deadlock false positive between the afs
 	 * filesystem and sys_sendmsg() via the mmap sem.
 	 */
-	if (rx->sk.sk_kern_sock)
+	if (local->kernel)
 		lockdep_set_class(&call->user_mutex,
 				  &rxrpc_call_user_mutex_lock_class_key);
 
@@ -152,7 +164,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	INIT_WORK(&call->processor, &rxrpc_process_call);
 	INIT_LIST_HEAD(&call->link);
 	INIT_LIST_HEAD(&call->chan_wait_link);
-	INIT_LIST_HEAD(&call->accept_link);
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
 	init_waitqueue_head(&call->waitq);
@@ -160,8 +171,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->input_lock);
 	rwlock_init(&call->state_lock);
-	refcount_set(&call->ref, 1);
-	call->debug_id = debug_id;
 	call->tx_total_len = -1;
 	call->next_rx_timo = 20 * HZ;
 	call->next_req_timo = 1 * HZ;
@@ -176,11 +185,14 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->cong_cwnd = 2;
 	call->cong_ssthresh = RXRPC_RXTX_BUFF_SIZE - 1;
 
+	call->local = local;
 	call->rxnet = rxnet;
 	call->rtt_avail = RXRPC_CALL_RTT_AVAIL_MASK;
 	atomic_inc(&rxnet->nr_calls);
 	return call;
 
+nomem_3:
+	kfree(call->rxtx_annotations);
 nomem_2:
 	kfree(call->rxtx_buffer);
 nomem:
@@ -201,7 +213,7 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 
 	_enter("");
 
-	call = rxrpc_alloc_call(rx, gfp, debug_id);
+	call = rxrpc_alloc_call(rx->local, gfp, debug_id, NULL);
 	if (!call)
 		return ERR_PTR(-ENOMEM);
 	call->state = RXRPC_CALL_CLIENT_AWAIT_CONN;
@@ -332,6 +344,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	rxrpc_get_call(call, rxrpc_call_got_userid);
 	rb_link_node(&call->sock_node, parent, pp);
 	rb_insert_color(&call->sock_node, &rx->calls);
+
+	rxrpc_get_call(call, rxrpc_call_get_socket_list);
 	list_add(&call->sock_link, &rx->sock_calls);
 
 	write_unlock(&rx->call_lock);
@@ -373,7 +387,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 				    RX_CALL_DEAD, -EEXIST);
 	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
 			 refcount_read(&call->ref), here, ERR_PTR(-EEXIST));
-	rxrpc_release_call(rx, call);
+	rxrpc_release_call(call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
 	_leave(" = -EEXIST");
@@ -398,9 +412,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
  * Set up an incoming call.  call->conn points to the connection.
  * This is called in BH context and isn't allowed to fail.
  */
-void rxrpc_incoming_call(struct rxrpc_sock *rx,
-			 struct rxrpc_call *call,
-			 struct sk_buff *skb)
+void rxrpc_incoming_call(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_connection *conn = call->conn;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -408,7 +420,6 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 
 	_enter(",%d", call->conn->debug_id);
 
-	rcu_assign_pointer(call->socket, rx);
 	call->call_id		= sp->hdr.callNumber;
 	call->service_id	= sp->hdr.serviceId;
 	call->cid		= sp->hdr.cid;
@@ -523,11 +534,12 @@ static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 /*
  * Detach a call from its owning socket.
  */
-void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
+void rxrpc_release_call(struct rxrpc_call *call)
 {
 	const void *here = __builtin_return_address(0);
 	struct rxrpc_connection *conn = call->conn;
-	bool put = false;
+	struct rxrpc_sock *rx = rcu_access_pointer(call->socket);
+	bool put = false, put_sl = false;
 
 	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
@@ -545,34 +557,45 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	rxrpc_put_call_slot(call);
 	rxrpc_delete_call_timer(call);
 
-	/* Make sure we don't get any more notifications */
-	write_lock_bh(&rx->recvmsg_lock);
+	if (rx) {
+		/* Make sure we don't get any more notifications */
+		write_lock_bh(&rx->recvmsg_lock);
 
-	if (!list_empty(&call->recvmsg_link)) {
-		_debug("unlinking once-pending call %p { e=%lx f=%lx }",
-		       call, call->events, call->flags);
-		list_del(&call->recvmsg_link);
-		put = true;
-	}
+		if (!list_empty(&call->recvmsg_link)) {
+			_debug("unlinking once-pending call %p { e=%lx f=%lx }",
+			       call, call->events, call->flags);
+			list_del(&call->recvmsg_link);
+			put = true;
+		}
 
-	/* list_empty() must return false in rxrpc_notify_socket() */
-	call->recvmsg_link.next = NULL;
-	call->recvmsg_link.prev = NULL;
+		/* list_empty() must return false in rxrpc_notify_socket() */
+		call->recvmsg_link.next = LIST_POISON1;
+		call->recvmsg_link.prev = LIST_POISON2;
 
-	write_unlock_bh(&rx->recvmsg_lock);
-	if (put)
-		rxrpc_put_call(call, rxrpc_call_put);
+		write_unlock_bh(&rx->recvmsg_lock);
+		if (put)
+			rxrpc_put_call(call, rxrpc_call_put);
 
-	write_lock(&rx->call_lock);
+		write_lock(&rx->call_lock);
 
-	if (test_and_clear_bit(RXRPC_CALL_HAS_USERID, &call->flags)) {
-		rb_erase(&call->sock_node, &rx->calls);
-		memset(&call->sock_node, 0xdd, sizeof(call->sock_node));
-		rxrpc_put_call(call, rxrpc_call_put_userid);
-	}
+		put = test_and_clear_bit(RXRPC_CALL_HAS_USERID, &call->flags);
+		if (put) {
+			rb_erase(&call->sock_node, &rx->calls);
+			memset(&call->sock_node, 0xdd, sizeof(call->sock_node));
+		}
 
-	list_del(&call->sock_link);
-	write_unlock(&rx->call_lock);
+		put_sl = !list_empty(&call->sock_link);
+		if (put_sl)
+			list_del_init(&call->sock_link);
+		write_unlock(&rx->call_lock);
+		if (put)
+			rxrpc_put_call(call, rxrpc_call_put_userid);
+		if (put_sl)
+			rxrpc_put_call(call, rxrpc_call_put_socket_list);
+	} else {
+		if (!list_empty(&call->recvmsg_link))
+			list_del(&call->recvmsg_link);
+	}
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
@@ -592,24 +615,25 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 
 	_enter("%p", rx);
 
-	while (!list_empty(&rx->to_be_accepted)) {
-		call = list_entry(rx->to_be_accepted.next,
-				  struct rxrpc_call, accept_link);
-		list_del(&call->accept_link);
-		rxrpc_abort_call("SKR", call, 0, RX_CALL_DEAD, -ECONNRESET);
-		rxrpc_put_call(call, rxrpc_call_put);
-	}
-
+	write_lock(&rx->call_lock);
 	while (!list_empty(&rx->sock_calls)) {
 		call = list_entry(rx->sock_calls.next,
 				  struct rxrpc_call, sock_link);
-		rxrpc_get_call(call, rxrpc_call_got);
-		rxrpc_abort_call("SKT", call, 0, RX_CALL_DEAD, -ECONNRESET);
-		rxrpc_send_abort_packet(call);
-		rxrpc_release_call(rx, call);
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_see_call(call);
+		list_del_init(&call->sock_link);
+		write_unlock(&rx->call_lock);
+
+		if (call->state != RXRPC_CALL_SERVER_PREALLOC &&
+		    call->state != RXRPC_CALL_COMPLETE &&
+		    rxrpc_abort_call("SKT", call, 0, RX_CALL_DEAD, -ECONNRESET))
+			rxrpc_send_abort_packet(call);
+		rxrpc_release_call(call);
+		rxrpc_put_call(call, rxrpc_call_put_socket_list);
+
+		write_lock(&rx->call_lock);
 	}
 
+	write_unlock(&rx->call_lock);
 	_leave("");
 }
 
@@ -627,9 +651,8 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 	ASSERT(call != NULL);
 
 	dead = __refcount_dec_and_test(&call->ref, &n);
-	trace_rxrpc_call(debug_id, op, n, here, NULL);
+	trace_rxrpc_call(debug_id, op, n - 1, here, NULL);
 	if (dead) {
-		_debug("call %d dead", call->debug_id);
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
@@ -652,6 +675,7 @@ static void rxrpc_destroy_call(struct work_struct *work)
 
 	rxrpc_delete_call_timer(call);
 
+	rxrpc_put_service(rxnet, call->service);
 	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
 	kfree(call->rxtx_buffer);
@@ -687,7 +711,10 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
-	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
+	if (WARN_ON(!test_bit(RXRPC_CALL_RELEASED, &call->flags))) {
+		kdebug("### UNRELEASED c=%08x", call->debug_id);
+		return;
+	}
 
 	rxrpc_cleanup_ring(call);
 	rxrpc_free_skb(call->tx_pending, rxrpc_skb_cleaned);
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 6e6aa02c6f9e..594173b8a02e 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -153,12 +153,14 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
  * Set up an incoming connection.  This is called in BH context with the RCU
  * read lock held.
  */
-void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
+void rxrpc_new_incoming_connection(const struct rxrpc_service *b,
 				   struct rxrpc_connection *conn,
 				   const struct rxrpc_security *sec,
 				   struct sk_buff *skb)
 {
+	const struct rxrpc_service_ids *ids;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	unsigned int i;
 
 	_enter("");
 
@@ -178,9 +180,16 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 	 * first packet on a new connection.  Once done, it applies to all
 	 * subsequent calls on that connection.
 	 */
-	if (sp->hdr.userStatus == RXRPC_USERSTATUS_SERVICE_UPGRADE &&
-	    conn->service_id == rx->service_upgrade.from)
-		conn->service_id = rx->service_upgrade.to;
+	if (sp->hdr.userStatus == RXRPC_USERSTATUS_SERVICE_UPGRADE) {
+		ids = rcu_dereference(b->ids);
+		for (i = 0; i < ids->nr_ids; i++) {
+			if (conn->service_id == ids->ids[i].service_id &&
+			    ids->ids[i].upgrade_to) {
+				conn->service_id = ids->ids[i].upgrade_to;
+				break;
+			}
+		}
+	}
 
 	/* Make the connection a target for incoming packets. */
 	rxrpc_publish_service_conn(conn->params.peer, conn);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 721d847ba92b..5f3871357362 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1130,8 +1130,7 @@ static void rxrpc_input_call_packet(struct rxrpc_call *call,
  *
  * TODO: If callNumber > call_id + 1, renegotiate security.
  */
-static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
-					  struct rxrpc_connection *conn,
+static void rxrpc_input_implicit_end_call(struct rxrpc_connection *conn,
 					  struct rxrpc_call *call)
 {
 	switch (READ_ONCE(call->state)) {
@@ -1149,9 +1148,9 @@ static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
 		break;
 	}
 
-	spin_lock(&rx->incoming_lock);
+	spin_lock(&call->input_lock);
 	__rxrpc_disconnect_call(conn, call);
-	spin_unlock(&rx->incoming_lock);
+	spin_unlock(&call->input_lock);
 }
 
 /*
@@ -1246,7 +1245,6 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	struct rxrpc_call *call = NULL;
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_peer *peer = NULL;
-	struct rxrpc_sock *rx = NULL;
 	unsigned int channel;
 
 	_enter("%p", udp_sk);
@@ -1357,14 +1355,8 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		 * that would begin a call are explicitly rejected and the rest
 		 * are just discarded.
 		 */
-		rx = rcu_dereference(local->service);
-		if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
-			    sp->hdr.serviceId != rx->second_service)) {
-			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
-			    sp->hdr.seq == 1)
-				goto unsupported_service;
-			goto discard;
-		}
+		if (list_empty(&local->services))
+			goto unsupported_service;
 	}
 
 	conn = rxrpc_find_connection_rcu(local, skb, &peer);
@@ -1433,7 +1425,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 			if (rxrpc_to_client(sp))
 				goto reject_packet;
 			if (call)
-				rxrpc_input_implicit_end_call(rx, conn, call);
+				rxrpc_input_implicit_end_call(conn, call);
 			call = NULL;
 		}
 
@@ -1453,7 +1445,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 			goto bad_message;
 		if (sp->hdr.seq != 1)
 			goto discard;
-		call = rxrpc_new_incoming_call(local, rx, skb);
+		call = rxrpc_new_incoming_call(local, skb);
 		if (!call)
 			goto reject_packet;
 	}
@@ -1477,6 +1469,9 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	goto post_abort;
 
 unsupported_service:
+	if (sp->hdr.type != RXRPC_PACKET_TYPE_DATA ||
+	    sp->hdr.seq != 1)
+		goto discard;
 	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 			  RX_INVALID_OPERATION, EOPNOTSUPP);
 	skb->priority = RX_INVALID_OPERATION;
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 8d2073e0e3da..bbb270a01810 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -452,7 +452,7 @@ int rxrpc_request_key(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
 		return -EINVAL;
 
 	description = memdup_sockptr_nul(optval, optlen);
@@ -689,7 +689,7 @@ static long rxrpc_read(const struct key *key,
 #undef ENCODE
 
 	ASSERTCMP(tok, ==, ntoks);
-	ASSERTCMP((char __user *) xdr - buffer, ==, size);
+	ASSERTCMP((unsigned long) xdr - (unsigned long)buffer, ==, size);
 	_leave(" = %zu", size);
 	return size;
 }
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 96ecb7356c0f..2a01c79a51e0 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -73,15 +73,18 @@ static long rxrpc_local_cmp_key(const struct rxrpc_local *local,
  * Allocate a new local endpoint.
  */
 static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
-					     const struct sockaddr_rxrpc *srx)
+					     const struct sockaddr_rxrpc *srx,
+					     bool kernel)
 {
 	struct rxrpc_local *local;
 
 	local = kzalloc(sizeof(struct rxrpc_local), GFP_KERNEL);
 	if (local) {
+		local->kernel = kernel;
 		refcount_set(&local->ref, 1);
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
+		INIT_LIST_HEAD(&local->services);
 		INIT_HLIST_NODE(&local->link);
 		INIT_WORK(&local->processor, rxrpc_local_processor);
 		init_rwsem(&local->defrag_sem);
@@ -90,7 +93,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		local->client_bundles = RB_ROOT;
 		spin_lock_init(&local->client_bundles_lock);
 		spin_lock_init(&local->lock);
-		rwlock_init(&local->services_lock);
+		mutex_init(&local->services_lock);
 		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
 		memcpy(&local->srx, srx, sizeof(*srx));
 		local->srx.srx_service = 0;
@@ -176,7 +179,8 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
  * Look up or create a new local endpoint using the specified local address.
  */
 struct rxrpc_local *rxrpc_lookup_local(struct net *net,
-				       const struct sockaddr_rxrpc *srx)
+				       const struct sockaddr_rxrpc *srx,
+				       bool kernel)
 {
 	struct rxrpc_local *local;
 	struct rxrpc_net *rxnet = rxrpc_net(net);
@@ -197,12 +201,12 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		if (diff != 0)
 			continue;
 
-		/* Services aren't allowed to share transport sockets, so
-		 * reject that here.  It is possible that the object is dying -
-		 * but it may also still have the local transport address that
-		 * we want bound.
+		/* Userspace services aren't allowed to share transport sockets
+		 * with kernel services, so reject that here.  It is possible
+		 * that the object is dying - but it may also still have the
+		 * local transport address that we want bound.
 		 */
-		if (srx->srx_service) {
+		if (local->kernel != kernel) {
 			local = NULL;
 			goto addr_in_use;
 		}
@@ -219,7 +223,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		goto found;
 	}
 
-	local = rxrpc_alloc_local(rxnet, srx);
+	local = rxrpc_alloc_local(rxnet, srx, kernel);
 	if (!local)
 		goto nomem;
 
@@ -379,7 +383,7 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 
 	rxrpc_clean_up_local_conns(local);
 	rxrpc_service_connection_reaper(&rxnet->service_conn_reaper);
-	ASSERT(!local->service);
+	ASSERT(list_empty(&local->services));
 
 	if (socket) {
 		local->socket = NULL;
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 4107099a259c..524265924f9f 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -45,6 +45,7 @@ static __net_init int rxrpc_init_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 	int ret, i;
 
+	rxnet->net = net;
 	rxnet->live = true;
 	get_random_bytes(&rxnet->epoch, sizeof(rxnet->epoch));
 	rxnet->epoch |= RXRPC_RANDOM_EPOCH;
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 26d2ae9baaf2..9f250237c622 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -149,10 +149,8 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
  * assess the MTU size for the network interface through which this peer is
  * reached
  */
-static void rxrpc_assess_MTU_size(struct rxrpc_sock *rx,
-				  struct rxrpc_peer *peer)
+static void rxrpc_assess_MTU_size(struct rxrpc_peer *peer)
 {
-	struct net *net = sock_net(&rx->sk);
 	struct dst_entry *dst;
 	struct rtable *rt;
 	struct flowi fl;
@@ -160,6 +158,7 @@ static void rxrpc_assess_MTU_size(struct rxrpc_sock *rx,
 #ifdef CONFIG_AF_RXRPC_IPV6
 	struct flowi6 *fl6 = &fl.u.ip6;
 #endif
+	struct net *net = peer->local->rxnet->net;
 
 	peer->if_mtu = 1500;
 
@@ -243,11 +242,10 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 /*
  * Initialise peer record.
  */
-static void rxrpc_init_peer(struct rxrpc_sock *rx, struct rxrpc_peer *peer,
-			    unsigned long hash_key)
+static void rxrpc_init_peer(struct rxrpc_peer *peer, unsigned long hash_key)
 {
 	peer->hash_key = hash_key;
-	rxrpc_assess_MTU_size(rx, peer);
+	rxrpc_assess_MTU_size(peer);
 	peer->mtu = peer->if_mtu;
 	peer->rtt_last_req = ktime_get_real();
 
@@ -292,7 +290,7 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
 	peer = rxrpc_alloc_peer(local, gfp);
 	if (peer) {
 		memcpy(&peer->srx, srx, sizeof(*srx));
-		rxrpc_init_peer(rx, peer, hash_key);
+		rxrpc_init_peer(peer, hash_key);
 	}
 
 	_leave(" = %p", peer);
@@ -310,14 +308,13 @@ static void rxrpc_free_peer(struct rxrpc_peer *peer)
  * since we've already done a search in the list from the non-reentrant context
  * (the data_ready handler) that is the only place we can add new peers.
  */
-void rxrpc_new_incoming_peer(struct rxrpc_sock *rx, struct rxrpc_local *local,
-			     struct rxrpc_peer *peer)
+void rxrpc_new_incoming_peer(struct rxrpc_local *local, struct rxrpc_peer *peer)
 {
 	struct rxrpc_net *rxnet = local->rxnet;
 	unsigned long hash_key;
 
 	hash_key = rxrpc_peer_hash_key(local, &peer->srx);
-	rxrpc_init_peer(rx, peer, hash_key);
+	rxrpc_init_peer(peer, hash_key);
 
 	spin_lock(&rxnet->peer_hash_lock);
 	hash_add_rcu(rxnet->peer_hash, &peer->hash_link, hash_key);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index b92303012338..814a6aba4c17 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -49,7 +49,6 @@ static void rxrpc_call_seq_stop(struct seq_file *seq, void *v)
 static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_local *local;
-	struct rxrpc_sock *rx;
 	struct rxrpc_peer *peer;
 	struct rxrpc_call *call;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
@@ -68,16 +67,11 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 
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
+	local = call->local;
+	if (local)
+		sprintf(lbuff, "%pISpc", &local->srx.transport);
+	else
+		strcpy(lbuff, "no_local");
 
 	peer = call->peer;
 	if (peer)
@@ -403,22 +397,23 @@ const struct seq_operations rxrpc_local_seq_ops = {
  */
 static int rxrpc_socket_seq_show(struct seq_file *seq, void *v)
 {
+	struct rxrpc_service_ids *ids;
+	struct rxrpc_service *b;
 	struct rxrpc_local *local;
 	struct rxrpc_sock *rx;
 	struct list_head *p;
-	char lbuff[50];
-	unsigned int nr_calls = 0, nr_acc = 0, nr_attend = 0;
+	char lbuff[50], sep;
+	unsigned int nr_calls = 0, nr_acc, nr_attend = 0, i;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
 			 "Proto Local                                          "
-			 " Use Svc1 Svc2 nCal nAcc nAtn\n");
+			 " Use nCal nAcc nAtn Services\n");
 		return 0;
 	}
 
 	rx = hlist_entry(v, struct rxrpc_sock, ns_link);
 	local = rx->local;
-
 	if (local)
 		sprintf(lbuff, "%pISpc", &local->srx.transport);
 	else
@@ -428,11 +423,11 @@ static int rxrpc_socket_seq_show(struct seq_file *seq, void *v)
 	list_for_each(p, &rx->sock_calls) {
 		nr_calls++;
 	}
-	list_for_each(p, &rx->to_be_accepted) {
-		nr_acc++;
-	}
 	read_unlock(&rx->call_lock);
 
+	b = rx->service;
+	nr_acc = b ? b->nr_tba : 0;
+
 	read_lock_bh(&rx->recvmsg_lock);
 	list_for_each(p, &rx->recvmsg_q) {
 		nr_attend++;
@@ -440,12 +435,23 @@ static int rxrpc_socket_seq_show(struct seq_file *seq, void *v)
 	read_unlock_bh(&rx->recvmsg_lock);
 
 	seq_printf(seq,
-		   "UDP   %-47.47s %3d %4x %4x %4u %4u %4u\n",
+		   "UDP   %-47.47s %3d %4x %4x %4u",
 		   lbuff,
 		   refcount_read(&rx->sk.sk_refcnt),
-		   rx->srx.srx_service, rx->second_service,
 		   nr_calls, nr_acc, nr_attend);
 
+	if (b) {
+		sep = ' ';
+		ids = rcu_dereference(b->ids);
+		for (i = 0; i < ids->nr_ids; i++) {
+			seq_printf(seq, "%c%x", sep, ids->ids[i].service_id);
+			if (ids->ids[i].upgrade_to)
+				seq_printf(seq, ">%x", ids->ids[i].upgrade_to);
+			sep = ',';
+		}
+	}
+
+	seq_putc(seq, '\n');
 	return 0;
 }
 
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 250f23bc1c07..2b596e2172ce 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -32,28 +32,50 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 
 	rcu_read_lock();
 
+	if (call->notify_rx) {
+		spin_lock_bh(&call->notify_lock);
+		call->notify_rx(sk, call, call->user_call_ID);
+		spin_unlock_bh(&call->notify_lock);
+		goto out;
+	}
+
 	rx = rcu_dereference(call->socket);
-	sk = &rx->sk;
-	if (rx && sk->sk_state < RXRPC_CLOSE) {
-		if (call->notify_rx) {
-			spin_lock_bh(&call->notify_lock);
-			call->notify_rx(sk, call, call->user_call_ID);
-			spin_unlock_bh(&call->notify_lock);
-		} else {
-			write_lock_bh(&rx->recvmsg_lock);
-			if (list_empty(&call->recvmsg_link)) {
-				rxrpc_get_call(call, rxrpc_call_got);
-				list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
-			}
-			write_unlock_bh(&rx->recvmsg_lock);
+	if (rx) {
+		sk = &rx->sk;
+		if (sk->sk_state >= RXRPC_CLOSE)
+			goto out;
 
-			if (!sock_flag(sk, SOCK_DEAD)) {
-				_debug("call %ps", sk->sk_data_ready);
+		write_lock_bh(&rx->recvmsg_lock);
+		if (list_empty(&call->recvmsg_link)) {
+			rxrpc_get_call(call, rxrpc_call_got);
+			list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
+		}
+		write_unlock_bh(&rx->recvmsg_lock);
+
+		if (!sock_flag(sk, SOCK_DEAD)) {
+			_debug("call %ps", sk->sk_data_ready);
+			sk->sk_data_ready(sk);
+		}
+		goto out;
+	}
+
+	if (call->service) {
+		struct rxrpc_service *b = call->service;
+
+		spin_lock_bh(&b->incoming_lock);
+		if (list_empty(&call->recvmsg_link)) {
+			list_add_tail(&call->recvmsg_link, &b->to_be_accepted);
+			b->nr_tba++;
+		}
+		list_for_each_entry(rx, &b->waiting_sockets, accepting_link) {
+			sk = &rx->sk;
+			if (!sock_flag(sk, SOCK_DEAD))
 				sk->sk_data_ready(sk);
-			}
 		}
+		spin_unlock_bh(&b->incoming_lock);
 	}
 
+out:
 	rcu_read_unlock();
 	_leave("");
 }
@@ -505,6 +527,11 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 try_again:
 	lock_sock(&rx->sk);
 
+	/* If there's a call we can accept, add that to the queue. */
+	if (rx->sk.sk_state == RXRPC_SERVER_LISTENING &&
+	    !list_empty(&rx->service->to_be_accepted))
+		rxrpc_accept_incoming_call(rx);		
+
 	/* Return immediately if a client socket has no outstanding calls */
 	if (RB_EMPTY_ROOT(&rx->calls) &&
 	    list_empty(&rx->recvmsg_q) &&
@@ -587,6 +614,12 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			goto error_unlock_call;
 	}
 
+	if (test_and_clear_bit(RXRPC_CALL_NEWLY_ACCEPTED, &call->flags)) {
+		ret = put_cmsg(msg, SOL_RXRPC, RXRPC_NEW_CALL, 0, NULL);
+		if (ret < 0)
+			goto error_unlock_call;
+	}
+
 	if (msg->msg_name && call->peer) {
 		struct sockaddr_rxrpc *srx = msg->msg_name;
 		size_t len = sizeof(call->peer->srx);
@@ -622,7 +655,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (ret < 0)
 			goto error_unlock_call;
 		if (!(flags & MSG_PEEK))
-			rxrpc_release_call(rx, call);
+			rxrpc_release_call(call);
 		msg->msg_flags |= MSG_EOR;
 		ret = 1;
 	}
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 50cb5f1ee0c0..0d4c049ede58 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -104,7 +104,7 @@ int rxrpc_init_client_conn_security(struct rxrpc_connection *conn)
 /*
  * Set the ops a server connection.
  */
-const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *rx,
+const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_service *b,
 							 struct sk_buff *skb)
 {
 	const struct rxrpc_security *sec;
@@ -123,7 +123,7 @@ const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *rx,
 	}
 
 	if (sp->hdr.securityIndex != RXRPC_SECURITY_NONE &&
-	    !rx->securities) {
+	    !b->securities) {
 		trace_rxrpc_abort(0, "SVR",
 				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 				  RX_INVALID_OPERATION, EKEYREJECTED);
@@ -143,8 +143,11 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *conn,
 					  u32 kvno, u32 enctype)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct rxrpc_sock *rx;
+	const struct rxrpc_service_ids *ids;
+	const struct rxrpc_service *b;
+	const struct rxrpc_local *local = conn->params.local;
 	struct key *key = ERR_PTR(-EKEYREJECTED);
+	unsigned int i;
 	key_ref_t kref = NULL;
 	char kdesc[5 + 1 + 3 + 1 + 12 + 1 + 12 + 1];
 	int ret;
@@ -163,12 +166,17 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *conn,
 
 	rcu_read_lock();
 
-	rx = rcu_dereference(conn->params.local->service);
-	if (!rx)
-		goto out;
+	list_for_each_entry_rcu(b, &local->services, local_link) {
+		ids = rcu_dereference(b->ids);
+		for (i = 0; i < ids->nr_ids; i++)
+			if (ids->ids[i].service_id == sp->hdr.serviceId)
+				goto found_service;
+	}
+	goto out;
 
+found_service:
 	/* look through the service's keyring */
-	kref = keyring_search(make_key_ref(rx->securities, 1UL),
+	kref = keyring_search(make_key_ref(b->securities, 1UL),
 			      &key_type_rxrpc_s, kdesc, true);
 	if (IS_ERR(kref)) {
 		key = ERR_CAST(kref);
diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index ee269e0e6ee8..017837940b0d 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -122,10 +122,11 @@ int rxrpc_server_keyring(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 {
 	struct key *key;
 	char *description;
+	int ret = -EBUSY;
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->service)
 		return -EINVAL;
 
 	description = memdup_sockptr_nul(optval, optlen);
@@ -139,8 +140,13 @@ int rxrpc_server_keyring(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 		return PTR_ERR(key);
 	}
 
-	rx->securities = key;
 	kfree(description);
+
+	if (cmpxchg(&rx->service->securities, NULL, key) == NULL)
+		ret = 0;
+	else
+		key_put(key);
+
 	_leave(" = 0 [key %x]", key->serial);
-	return 0;
+	return ret;
 }


