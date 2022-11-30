Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC9E63DB22
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiK3Qzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiK3Qz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:55:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049D7532EE
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NsICjhS6DG6kKg5RohWKW4WHT3hznS63zas0NRgDh0w=;
        b=IRW7L6wwIWc/SI71PU9UZHuf4gwJMtVHFORbJBjoNxVwXKNBSRvmbD9GmVk07wfEK8ZdDY
        sm7Ie2NtmVuTFQVumkS7qkZDFYu3YpyEfUyKSdX8YH9cmflh2tXUWXRuodA+QOv8Zc7kvt
        cRAsAPtYmfzEUjTe9a86e2hDFYj+NG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-EnDnCH-rNAyjX0bkNJNM5g-1; Wed, 30 Nov 2022 11:54:29 -0500
X-MC-Unique: EnDnCH-rNAyjX0bkNJNM5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75E16185A79C;
        Wed, 30 Nov 2022 16:54:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B1B940C6EC4;
        Wed, 30 Nov 2022 16:54:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 01/35] rxrpc: Implement an in-kernel rxperf server
 for testing purposes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:54:26 +0000
Message-ID: <166982726601.621383.15475080589217572083.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement an in-kernel rxperf server to allow kernel-based rxrpc services
to be tested directly, unlike with AFS where they're accessed by the
fileserver when the latter decides it wants to.

This is implemented as a module that, if loaded, opens UDP port 7009
(afs3-rmtsys) and listens on it for incoming calls.  Calls can be generated
using the rxperf command shipped with OpenAFS, for example.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/net/af_rxrpc.h |    1 
 net/rxrpc/Kconfig      |    7 +
 net/rxrpc/Makefile     |    3 
 net/rxrpc/rxperf.c     |  619 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/server_key.c |   25 ++
 5 files changed, 655 insertions(+)
 create mode 100644 net/rxrpc/rxperf.c

diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index b69ca695935c..dc033f08191e 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -71,5 +71,6 @@ void rxrpc_kernel_set_max_life(struct socket *, struct rxrpc_call *,
 			       unsigned long);
 
 int rxrpc_sock_set_min_security_level(struct sock *sk, unsigned int val);
+int rxrpc_sock_set_security_keyring(struct sock *, struct key *);
 
 #endif /* _NET_RXRPC_H */
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index accd35c05577..7ae023b37a83 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -58,4 +58,11 @@ config RXKAD
 
 	  See Documentation/networking/rxrpc.rst.
 
+config RXPERF
+	tristate "RxRPC test service"
+	help
+	  Provide an rxperf service tester.  This listens on UDP port 7009 for
+	  incoming calls from the rxperf program (an example of which can be
+	  found in OpenAFS).
+
 endif
diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index fdeba488fc6e..79687477d93c 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -36,3 +36,6 @@ rxrpc-y := \
 rxrpc-$(CONFIG_PROC_FS) += proc.o
 rxrpc-$(CONFIG_RXKAD) += rxkad.o
 rxrpc-$(CONFIG_SYSCTL) += sysctl.o
+
+
+obj-$(CONFIG_RXPERF) += rxperf.o
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
new file mode 100644
index 000000000000..277ba18f575d
--- /dev/null
+++ b/net/rxrpc/rxperf.c
@@ -0,0 +1,619 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* In-kernel rxperf server for testing purposes.
+ *
+ * Copyright (C) 2022 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) "rxperf: " fmt
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <net/sock.h>
+#include <net/af_rxrpc.h>
+
+MODULE_DESCRIPTION("rxperf test server (afs)");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
+
+#define RXPERF_PORT		7009
+#define RX_PERF_SERVICE		147
+#define RX_PERF_VERSION		3
+#define RX_PERF_SEND		0
+#define RX_PERF_RECV		1
+#define RX_PERF_RPC		3
+#define RX_PERF_FILE		4
+#define RX_PERF_MAGIC_COOKIE	0x4711
+
+struct rxperf_proto_params {
+	__be32		version;
+	__be32		type;
+	__be32		rsize;
+	__be32		wsize;
+} __packed;
+
+static const u8 rxperf_magic_cookie[] = { 0x00, 0x00, 0x47, 0x11 };
+static const u8 secret[8] = { 0xa7, 0x83, 0x8a, 0xcb, 0xc7, 0x83, 0xec, 0x94 };
+
+enum rxperf_call_state {
+	RXPERF_CALL_SV_AWAIT_PARAMS,	/* Server: Awaiting parameter block */
+	RXPERF_CALL_SV_AWAIT_REQUEST,	/* Server: Awaiting request data */
+	RXPERF_CALL_SV_REPLYING,	/* Server: Replying */
+	RXPERF_CALL_SV_AWAIT_ACK,	/* Server: Awaiting final ACK */
+	RXPERF_CALL_COMPLETE,		/* Completed or failed */
+};
+
+struct rxperf_call {
+	struct rxrpc_call	*rxcall;
+	struct iov_iter		iter;
+	struct kvec		kvec[1];
+	struct work_struct	work;
+	const char		*type;
+	size_t			iov_len;
+	size_t			req_len;	/* Size of request blob */
+	size_t			reply_len;	/* Size of reply blob */
+	unsigned int		debug_id;
+	unsigned int		operation_id;
+	struct rxperf_proto_params params;
+	__be32			tmp[2];
+	s32			abort_code;
+	enum rxperf_call_state	state;
+	short			error;
+	unsigned short		unmarshal;
+	u16			service_id;
+	int (*deliver)(struct rxperf_call *call);
+	void (*processor)(struct work_struct *work);
+};
+
+static struct socket *rxperf_socket;
+static struct key *rxperf_sec_keyring;	/* Ring of security/crypto keys */
+static struct workqueue_struct *rxperf_workqueue;
+
+static void rxperf_deliver_to_call(struct work_struct *work);
+static int rxperf_deliver_param_block(struct rxperf_call *call);
+static int rxperf_deliver_request(struct rxperf_call *call);
+static int rxperf_process_call(struct rxperf_call *call);
+static void rxperf_charge_preallocation(struct work_struct *work);
+
+static DECLARE_WORK(rxperf_charge_preallocation_work,
+		    rxperf_charge_preallocation);
+
+static inline void rxperf_set_call_state(struct rxperf_call *call,
+					 enum rxperf_call_state to)
+{
+	call->state = to;
+}
+
+static inline void rxperf_set_call_complete(struct rxperf_call *call,
+					    int error, s32 remote_abort)
+{
+	if (call->state != RXPERF_CALL_COMPLETE) {
+		call->abort_code = remote_abort;
+		call->error = error;
+		call->state = RXPERF_CALL_COMPLETE;
+	}
+}
+
+static void rxperf_rx_discard_new_call(struct rxrpc_call *rxcall,
+				       unsigned long user_call_ID)
+{
+	kfree((struct rxperf_call *)user_call_ID);
+}
+
+static void rxperf_rx_new_call(struct sock *sk, struct rxrpc_call *rxcall,
+			       unsigned long user_call_ID)
+{
+	queue_work(rxperf_workqueue, &rxperf_charge_preallocation_work);
+}
+
+static void rxperf_queue_call_work(struct rxperf_call *call)
+{
+	queue_work(rxperf_workqueue, &call->work);
+}
+
+static void rxperf_notify_rx(struct sock *sk, struct rxrpc_call *rxcall,
+			     unsigned long call_user_ID)
+{
+	struct rxperf_call *call = (struct rxperf_call *)call_user_ID;
+
+	if (call->state != RXPERF_CALL_COMPLETE)
+		rxperf_queue_call_work(call);
+}
+
+static void rxperf_rx_attach(struct rxrpc_call *rxcall, unsigned long user_call_ID)
+{
+	struct rxperf_call *call = (struct rxperf_call *)user_call_ID;
+
+	call->rxcall = rxcall;
+}
+
+static void rxperf_notify_end_reply_tx(struct sock *sock,
+				       struct rxrpc_call *rxcall,
+				       unsigned long call_user_ID)
+{
+	rxperf_set_call_state((struct rxperf_call *)call_user_ID,
+			      RXPERF_CALL_SV_AWAIT_ACK);
+}
+
+/*
+ * Charge the incoming call preallocation.
+ */
+static void rxperf_charge_preallocation(struct work_struct *work)
+{
+	struct rxperf_call *call;
+
+	for (;;) {
+		call = kzalloc(sizeof(*call), GFP_KERNEL);
+		if (!call)
+			break;
+
+		call->type		= "unset";
+		call->debug_id		= atomic_inc_return(&rxrpc_debug_id);
+		call->deliver		= rxperf_deliver_param_block;
+		call->state		= RXPERF_CALL_SV_AWAIT_PARAMS;
+		call->service_id	= RX_PERF_SERVICE;
+		call->iov_len		= sizeof(call->params);
+		call->kvec[0].iov_len	= sizeof(call->params);
+		call->kvec[0].iov_base	= &call->params;
+		iov_iter_kvec(&call->iter, READ, call->kvec, 1, call->iov_len);
+		INIT_WORK(&call->work, rxperf_deliver_to_call);
+
+		if (rxrpc_kernel_charge_accept(rxperf_socket,
+					       rxperf_notify_rx,
+					       rxperf_rx_attach,
+					       (unsigned long)call,
+					       GFP_KERNEL,
+					       call->debug_id) < 0)
+			break;
+		call = NULL;
+	}
+
+	kfree(call);
+}
+
+/*
+ * Open an rxrpc socket and bind it to be a server for callback notifications
+ * - the socket is left in blocking mode and non-blocking ops use MSG_DONTWAIT
+ */
+static int rxperf_open_socket(void)
+{
+	struct sockaddr_rxrpc srx;
+	struct socket *socket;
+	int ret;
+
+	ret = sock_create_kern(&init_net, AF_RXRPC, SOCK_DGRAM, PF_INET6,
+			       &socket);
+	if (ret < 0)
+		goto error_1;
+
+	socket->sk->sk_allocation = GFP_NOFS;
+
+	/* bind the callback manager's address to make this a server socket */
+	memset(&srx, 0, sizeof(srx));
+	srx.srx_family			= AF_RXRPC;
+	srx.srx_service			= RX_PERF_SERVICE;
+	srx.transport_type		= SOCK_DGRAM;
+	srx.transport_len		= sizeof(srx.transport.sin6);
+	srx.transport.sin6.sin6_family	= AF_INET6;
+	srx.transport.sin6.sin6_port	= htons(RXPERF_PORT);
+
+	ret = rxrpc_sock_set_min_security_level(socket->sk,
+						RXRPC_SECURITY_ENCRYPT);
+	if (ret < 0)
+		goto error_2;
+
+	ret = rxrpc_sock_set_security_keyring(socket->sk, rxperf_sec_keyring);
+
+	ret = kernel_bind(socket, (struct sockaddr *)&srx, sizeof(srx));
+	if (ret < 0)
+		goto error_2;
+
+	rxrpc_kernel_new_call_notification(socket, rxperf_rx_new_call,
+					   rxperf_rx_discard_new_call);
+
+	ret = kernel_listen(socket, INT_MAX);
+	if (ret < 0)
+		goto error_2;
+
+	rxperf_socket = socket;
+	rxperf_charge_preallocation(&rxperf_charge_preallocation_work);
+	return 0;
+
+error_2:
+	sock_release(socket);
+error_1:
+	pr_err("Can't set up rxperf socket: %d\n", ret);
+	return ret;
+}
+
+/*
+ * close the rxrpc socket rxperf was using
+ */
+static void rxperf_close_socket(void)
+{
+	kernel_listen(rxperf_socket, 0);
+	kernel_sock_shutdown(rxperf_socket, SHUT_RDWR);
+	flush_workqueue(rxperf_workqueue);
+	sock_release(rxperf_socket);
+}
+
+/*
+ * Log remote abort codes that indicate that we have a protocol disagreement
+ * with the server.
+ */
+static void rxperf_log_error(struct rxperf_call *call, s32 remote_abort)
+{
+	static int max = 0;
+	const char *msg;
+	int m;
+
+	switch (remote_abort) {
+	case RX_EOF:		 msg = "unexpected EOF";	break;
+	case RXGEN_CC_MARSHAL:	 msg = "client marshalling";	break;
+	case RXGEN_CC_UNMARSHAL: msg = "client unmarshalling";	break;
+	case RXGEN_SS_MARSHAL:	 msg = "server marshalling";	break;
+	case RXGEN_SS_UNMARSHAL: msg = "server unmarshalling";	break;
+	case RXGEN_DECODE:	 msg = "opcode decode";		break;
+	case RXGEN_SS_XDRFREE:	 msg = "server XDR cleanup";	break;
+	case RXGEN_CC_XDRFREE:	 msg = "client XDR cleanup";	break;
+	case -32:		 msg = "insufficient data";	break;
+	default:
+		return;
+	}
+
+	m = max;
+	if (m < 3) {
+		max = m + 1;
+		pr_info("Peer reported %s failure on %s\n", msg, call->type);
+	}
+}
+
+/*
+ * deliver messages to a call
+ */
+static void rxperf_deliver_to_call(struct work_struct *work)
+{
+	struct rxperf_call *call = container_of(work, struct rxperf_call, work);
+	enum rxperf_call_state state;
+	u32 abort_code, remote_abort = 0;
+	int ret;
+
+	if (call->state == RXPERF_CALL_COMPLETE)
+		return;
+
+	while (state = call->state,
+	       state == RXPERF_CALL_SV_AWAIT_PARAMS ||
+	       state == RXPERF_CALL_SV_AWAIT_REQUEST ||
+	       state == RXPERF_CALL_SV_AWAIT_ACK
+	       ) {
+		if (state == RXPERF_CALL_SV_AWAIT_ACK) {
+			if (!rxrpc_kernel_check_life(rxperf_socket, call->rxcall))
+				goto call_complete;
+			return;
+		}
+
+		ret = call->deliver(call);
+		if (ret == 0)
+			ret = rxperf_process_call(call);
+
+		switch (ret) {
+		case 0:
+			continue;
+		case -EINPROGRESS:
+		case -EAGAIN:
+			return;
+		case -ECONNABORTED:
+			rxperf_log_error(call, call->abort_code);
+			goto call_complete;
+		case -EOPNOTSUPP:
+			abort_code = RXGEN_OPCODE;
+			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
+						abort_code, ret, "GOP");
+			goto call_complete;
+		case -ENOTSUPP:
+			abort_code = RX_USER_ABORT;
+			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
+						abort_code, ret, "GUA");
+			goto call_complete;
+		case -EIO:
+			pr_err("Call %u in bad state %u\n",
+			       call->debug_id, call->state);
+			fallthrough;
+		case -ENODATA:
+		case -EBADMSG:
+		case -EMSGSIZE:
+		case -ENOMEM:
+		case -EFAULT:
+			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
+						RXGEN_SS_UNMARSHAL, ret, "GUM");
+			goto call_complete;
+		default:
+			rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
+						RX_CALL_DEAD, ret, "GER");
+			goto call_complete;
+		}
+	}
+
+call_complete:
+	rxperf_set_call_complete(call, ret, remote_abort);
+	/* The call may have been requeued */
+	rxrpc_kernel_end_call(rxperf_socket, call->rxcall);
+	cancel_work(&call->work);
+	kfree(call);
+}
+
+/*
+ * Extract a piece of data from the received data socket buffers.
+ */
+static int rxperf_extract_data(struct rxperf_call *call, bool want_more)
+{
+	u32 remote_abort = 0;
+	int ret;
+
+	ret = rxrpc_kernel_recv_data(rxperf_socket, call->rxcall, &call->iter,
+				     &call->iov_len, want_more, &remote_abort,
+				     &call->service_id);
+	pr_debug("Extract i=%zu l=%zu m=%u ret=%d\n",
+		 iov_iter_count(&call->iter), call->iov_len, want_more, ret);
+	if (ret == 0 || ret == -EAGAIN)
+		return ret;
+
+	if (ret == 1) {
+		switch (call->state) {
+		case RXPERF_CALL_SV_AWAIT_REQUEST:
+			rxperf_set_call_state(call, RXPERF_CALL_SV_REPLYING);
+			break;
+		case RXPERF_CALL_COMPLETE:
+			pr_debug("premature completion %d", call->error);
+			return call->error;
+		default:
+			break;
+		}
+		return 0;
+	}
+
+	rxperf_set_call_complete(call, ret, remote_abort);
+	return ret;
+}
+
+/*
+ * Grab the operation ID from an incoming manager call.
+ */
+static int rxperf_deliver_param_block(struct rxperf_call *call)
+{
+	u32 version;
+	int ret;
+
+	/* Extract the parameter block */
+	ret = rxperf_extract_data(call, true);
+	if (ret < 0)
+		return ret;
+
+	version			= ntohl(call->params.version);
+	call->operation_id	= ntohl(call->params.type);
+	call->deliver		= rxperf_deliver_request;
+
+	if (version != RX_PERF_VERSION) {
+		pr_info("Version mismatch %x\n", version);
+		return -ENOTSUPP;
+	}
+
+	switch (call->operation_id) {
+	case RX_PERF_SEND:
+		call->type = "send";
+		call->reply_len = 0;
+		call->iov_len = 4;	/* Expect req size */
+		break;
+	case RX_PERF_RECV:
+		call->type = "recv";
+		call->req_len = 0;
+		call->iov_len = 4;	/* Expect reply size */
+		break;
+	case RX_PERF_RPC:
+		call->type = "rpc";
+		call->iov_len = 8;	/* Expect req size and reply size */
+		break;
+	case RX_PERF_FILE:
+		call->type = "file";
+		fallthrough;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	rxperf_set_call_state(call, RXPERF_CALL_SV_AWAIT_REQUEST);
+	return call->deliver(call);
+}
+
+/*
+ * Deliver the request data.
+ */
+static int rxperf_deliver_request(struct rxperf_call *call)
+{
+	int ret;
+
+	switch (call->unmarshal) {
+	case 0:
+		call->kvec[0].iov_len	= call->iov_len;
+		call->kvec[0].iov_base	= call->tmp;
+		iov_iter_kvec(&call->iter, READ, call->kvec, 1, call->iov_len);
+		call->unmarshal++;
+		fallthrough;
+	case 1:
+		ret = rxperf_extract_data(call, true);
+		if (ret < 0)
+			return ret;
+
+		switch (call->operation_id) {
+		case RX_PERF_SEND:
+			call->type = "send";
+			call->req_len	= ntohl(call->tmp[0]);
+			call->reply_len	= 0;
+			break;
+		case RX_PERF_RECV:
+			call->type = "recv";
+			call->req_len = 0;
+			call->reply_len	= ntohl(call->tmp[0]);
+			break;
+		case RX_PERF_RPC:
+			call->type = "rpc";
+			call->req_len	= ntohl(call->tmp[0]);
+			call->reply_len	= ntohl(call->tmp[1]);
+			break;
+		default:
+			pr_info("Can't parse extra params\n");
+			return -EIO;
+		}
+
+		pr_debug("CALL op=%s rq=%zx rp=%zx\n",
+			 call->type, call->req_len, call->reply_len);
+
+		call->iov_len = call->req_len;
+		iov_iter_discard(&call->iter, READ, call->req_len);
+		call->unmarshal++;
+		fallthrough;
+	case 2:
+		ret = rxperf_extract_data(call, false);
+		if (ret < 0)
+			return ret;
+		call->unmarshal++;
+		fallthrough;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Process a call for which we've received the request.
+ */
+static int rxperf_process_call(struct rxperf_call *call)
+{
+	struct msghdr msg = {};
+	struct bio_vec bv[1];
+	struct kvec iov[1];
+	ssize_t n;
+	size_t reply_len = call->reply_len, len;
+
+	rxrpc_kernel_set_tx_length(rxperf_socket, call->rxcall,
+				   reply_len + sizeof(rxperf_magic_cookie));
+
+	while (reply_len > 0) {
+		len = min(reply_len, PAGE_SIZE);
+		bv[0].bv_page	= ZERO_PAGE(0);
+		bv[0].bv_offset	= 0;
+		bv[0].bv_len	= len;
+		iov_iter_bvec(&msg.msg_iter, WRITE, bv, 1, len);
+		msg.msg_flags = MSG_MORE;
+		n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
+					   len, rxperf_notify_end_reply_tx);
+		if (n < 0)
+			return n;
+		if (n == 0)
+			return -EIO;
+		reply_len -= n;
+	}
+
+	len = sizeof(rxperf_magic_cookie);
+	iov[0].iov_base	= (void *)rxperf_magic_cookie;
+	iov[0].iov_len	= len;
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
+	msg.msg_flags = 0;
+	n = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg, len,
+				   rxperf_notify_end_reply_tx);
+	if (n >= 0)
+		return 0; /* Success */
+
+	if (n == -ENOMEM)
+		rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
+					RXGEN_SS_MARSHAL, -ENOMEM, "GOM");
+	return n;
+}
+
+/*
+ * Add a key to the security keyring.
+ */
+static int rxperf_add_key(struct key *keyring)
+{
+	key_ref_t kref;
+	int ret;
+
+	kref = key_create_or_update(make_key_ref(keyring, true),
+				    "rxrpc_s",
+				    __stringify(RX_PERF_SERVICE) ":2",
+				    secret,
+				    sizeof(secret),
+				    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH
+				    | KEY_USR_VIEW,
+				    KEY_ALLOC_NOT_IN_QUOTA);
+
+	if (IS_ERR(kref)) {
+		pr_err("Can't allocate rxperf server key: %ld\n", PTR_ERR(kref));
+		return PTR_ERR(kref);
+	}
+
+	ret = key_link(keyring, key_ref_to_ptr(kref));
+	if (ret < 0)
+		pr_err("Can't link rxperf server key: %d\n", ret);
+	key_ref_put(kref);
+	return ret;
+}
+
+/*
+ * Initialise the rxperf server.
+ */
+static int __init rxperf_init(void)
+{
+	struct key *keyring;
+	int ret = -ENOMEM;
+
+	pr_info("Server registering\n");
+
+	rxperf_workqueue = alloc_workqueue("rxperf", 0, 0);
+	if (!rxperf_workqueue)
+		goto error_workqueue;
+
+	keyring = keyring_alloc("rxperf_server",
+				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
+				KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
+				KEY_POS_WRITE |
+				KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH |
+				KEY_USR_WRITE |
+				KEY_OTH_VIEW | KEY_OTH_READ | KEY_OTH_SEARCH,
+				KEY_ALLOC_NOT_IN_QUOTA,
+				NULL, NULL);
+	if (IS_ERR(keyring)) {
+		pr_err("Can't allocate rxperf server keyring: %ld\n",
+		       PTR_ERR(keyring));
+		goto error_keyring;
+	}
+	rxperf_sec_keyring = keyring;
+	ret = rxperf_add_key(keyring);
+	if (ret < 0)
+		goto error_key;
+
+	ret = rxperf_open_socket();
+	if (ret < 0)
+		goto error_socket;
+	return 0;
+
+error_socket:
+error_key:
+	key_put(rxperf_sec_keyring);
+error_keyring:
+	destroy_workqueue(rxperf_workqueue);
+	rcu_barrier();
+error_workqueue:
+	pr_err("Failed to register: %d\n", ret);
+	return ret;
+}
+late_initcall(rxperf_init); /* Must be called after net/ to create socket */
+
+static void __exit rxperf_exit(void)
+{
+	pr_info("Server unregistering.\n");
+
+	rxperf_close_socket();
+	key_put(rxperf_sec_keyring);
+	destroy_workqueue(rxperf_workqueue);
+	rcu_barrier();
+}
+module_exit(rxperf_exit);
+
diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index ee269e0e6ee8..e51940589ee5 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -144,3 +144,28 @@ int rxrpc_server_keyring(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 	_leave(" = 0 [key %x]", key->serial);
 	return 0;
 }
+
+/**
+ * rxrpc_sock_set_security_keyring - Set the security keyring for a kernel service
+ * @sk: The socket to set the keyring on
+ * @keyring: The keyring to set
+ *
+ * Set the server security keyring on an rxrpc socket.  This is used to provide
+ * the encryption keys for a kernel service.
+ */
+int rxrpc_sock_set_security_keyring(struct sock *sk, struct key *keyring)
+{
+	struct rxrpc_sock *rx = rxrpc_sk(sk);
+	int ret = 0;
+
+	lock_sock(sk);
+	if (rx->securities)
+		ret = -EINVAL;
+	else if (rx->sk.sk_state != RXRPC_UNBOUND)
+		ret = -EISCONN;
+	else
+		rx->securities = key_get(keyring);
+	release_sock(sk);
+	return ret;
+}
+EXPORT_SYMBOL(rxrpc_sock_set_security_keyring);


