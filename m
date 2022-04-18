Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD3B505D0E
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbiDRQ5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346788AbiDRQ4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:56:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECCD35856;
        Mon, 18 Apr 2022 09:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96045612F2;
        Mon, 18 Apr 2022 16:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747C1C385A1;
        Mon, 18 Apr 2022 16:52:23 +0000 (UTC)
Subject: [PATCH RFC 11/15] SUNRPC: Add infrastructure for async RPC_AUTH_TLS
 probe
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:22 -0400
Message-ID: <165030074244.5246.8728494438187879593.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce helpers for sending an RPC_AUTH_TLS probe, waiting for
it, and then parsing the reply. These will be used to handle the
reconnect case.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/clnt.h |    1 +
 include/linux/sunrpc/xprt.h |   13 ++++++++++
 net/sunrpc/clnt.c           |   58 +++++++++++++++++++++++++++++++++++++++++++
 net/sunrpc/xprt.c           |    1 +
 net/sunrpc/xprtsock.c       |   56 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 129 insertions(+)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index e10a19d136ca..15fd84e4c321 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -209,6 +209,7 @@ int		rpc_call_sync(struct rpc_clnt *clnt,
 			      unsigned int flags);
 struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred,
 			       int flags);
+void		rpc_starttls_async(struct rpc_task *task);
 int		rpc_restart_call_prepare(struct rpc_task *);
 int		rpc_restart_call(struct rpc_task *);
 void		rpc_setbufsize(struct rpc_clnt *, unsigned int, unsigned int);
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 8d654bc35dce..cbb0fe738d97 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -159,6 +159,7 @@ struct rpc_xprt_ops {
 	void		(*disable_swap)(struct rpc_xprt *xprt);
 	void		(*inject_disconnect)(struct rpc_xprt *xprt);
 	int		(*tls_handshake_sync)(struct rpc_xprt *xprt);
+	int		(*tls_handshake_async)(struct rpc_xprt *xprt);
 	int		(*bc_setup)(struct rpc_xprt *xprt,
 				    unsigned int min_reqs);
 	size_t		(*bc_maxpayload)(struct rpc_xprt *xprt);
@@ -204,6 +205,7 @@ struct rpc_xprt {
 	size_t			max_payload;	/* largest RPC payload size,
 						   in bytes */
 
+	struct rpc_wait_queue	probing;	/* requests waiting on TLS probe */
 	struct rpc_wait_queue	binding;	/* requests waiting on rpcbind */
 	struct rpc_wait_queue	sending;	/* requests waiting to send */
 	struct rpc_wait_queue	pending;	/* requests in flight */
@@ -436,6 +438,7 @@ void			xprt_release_write(struct rpc_xprt *, struct rpc_task *);
 #define XPRT_CWND_WAIT		(10)
 #define XPRT_WRITE_SPACE	(11)
 #define XPRT_SND_IS_COOKIE	(12)
+#define XPRT_PROBING		(13)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
@@ -506,4 +509,14 @@ static inline int xprt_test_and_set_binding(struct rpc_xprt *xprt)
 	return test_and_set_bit(XPRT_BINDING, &xprt->state);
 }
 
+static inline void xprt_clear_probing(struct rpc_xprt *xprt)
+{
+	clear_bit(XPRT_PROBING, &xprt->state);
+}
+
+static inline int xprt_test_and_set_probing(struct rpc_xprt *xprt)
+{
+	return test_and_set_bit(XPRT_PROBING, &xprt->state);
+}
+
 #endif /* _LINUX_SUNRPC_XPRT_H */
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 1601a06deaf5..e9a6622dba68 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2829,6 +2829,64 @@ static int rpc_starttls_sync(struct rpc_clnt *clnt)
 	return err;
 }
 
+static void rpc_probe_tls_done(struct rpc_task *task, void *data)
+{
+	struct rpc_xprt *xprt = data;
+
+	if (task->tk_status < 0) {
+		trace_rpc_tls_unavailable(task->tk_client, xprt);
+		xprt_clear_probing(xprt);
+		rpc_wake_up_status(&xprt->probing, task->tk_status);
+		return;
+	}
+
+	/* Send ClientHello; a second callback will wake the waiting task */
+	if (xprt->ops->tls_handshake_async(xprt)) {
+		trace_rpc_tls_not_started(task->tk_client, xprt);
+		xprt_clear_probing(xprt);
+		rpc_wake_up_status(&xprt->probing, -EACCES);
+	}
+}
+
+static void rpc_probe_tls_release(void *data)
+{
+	struct rpc_xprt *xprt = data;
+
+	xprt_put(xprt);
+}
+
+static const struct rpc_call_ops rpc_ops_probe_tls = {
+	.rpc_call_done	= rpc_probe_tls_done,
+	.rpc_release	= rpc_probe_tls_release,
+};
+
+/**
+ * rpc_starttls_async - Asynchronously establish a TLS session
+ * @task: an RPC task waiting for a TLS session
+ *
+ */
+void rpc_starttls_async(struct rpc_task *task)
+{
+	struct rpc_xprt *xprt = xprt_get(task->tk_xprt);
+
+	rpc_sleep_on_timeout(&xprt->probing, task, NULL,
+			     jiffies + xprt->connect_timeout);
+	if (xprt_test_and_set_probing(xprt)) {
+		xprt_put(xprt);
+		return;
+	}
+
+	/*
+	 * RPC_TASK_TLSCRED: use an RPC_AUTH_TLS cred instead of AUTH_NULL
+	 * RPC_TASK_SWAPPER: insert the task at the head of the transmit queue
+	 * RPC_TASK_CORK: stop sending after this Call is transmitted
+	 */
+	rpc_put_task(rpc_call_null_helper(task->tk_client, xprt, NULL,
+		     RPC_TASK_TLSCRED | RPC_TASK_SWAPPER | RPC_TASK_CORK,
+		     &rpc_ops_probe_tls, xprt));
+}
+EXPORT_SYMBOL_GPL(rpc_starttls_async);
+
 struct rpc_cb_add_xprt_calldata {
 	struct rpc_xprt_switch *xps;
 	struct rpc_xprt *xprt;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 4b303b945b51..762281dba077 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -2016,6 +2016,7 @@ static void xprt_init(struct rpc_xprt *xprt, struct net *net)
 	xprt->cwnd = RPC_INITCWND;
 	xprt->bind_index = 0;
 
+	rpc_init_wait_queue(&xprt->probing, "xprt_probing");
 	rpc_init_wait_queue(&xprt->binding, "xprt_binding");
 	rpc_init_wait_queue(&xprt->pending, "xprt_pending");
 	rpc_init_wait_queue(&xprt->sending, "xprt_sending");
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index bbba9747f68d..bb8c32002ce7 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2378,6 +2378,46 @@ static int xs_tcp_tls_handshake_sync(struct rpc_xprt *xprt)
 	return rc;
 }
 
+/**
+ * xs_tcp_tls_handshake_wake - TLS handshake completion handler
+ * @data: address of xprt to wake
+ * @status: status of handshake
+ *
+ */
+static void xs_tcp_tls_handshake_wake(void *data, int status)
+{
+	struct rpc_xprt *xprt = data;
+	struct sock_xprt *transport =
+				container_of(xprt, struct sock_xprt, xprt);
+
+	xs_tcp_clear_discard(transport);
+	xprt_clear_probing(xprt);
+	rpc_wake_up_status(&xprt->probing, status < 0 ? -EACCES : 0);
+	xprt_put(xprt);
+}
+
+/**
+ * xs_tcp_tls_handshake_async - Start a TLS handshake
+ * @xprt: transport on which to perform handshake
+ *
+ * Caller ensures there will be no other traffic on this transport.
+ *
+ * Return values:
+ *   %0: Handshake initiated; @xprt will be awoken when it's done.
+ *   Negative errno: handshake was not started.
+ */
+static int xs_tcp_tls_handshake_async(struct rpc_xprt *xprt)
+{
+	struct sock_xprt *transport =
+				container_of(xprt, struct sock_xprt, xprt);
+
+	WRITE_ONCE(transport->recv.ignore_dr, true);
+	return tls_client_hello_x509(transport->sock,
+				     xs_tcp_tls_handshake_wake, xprt_get(xprt),
+				     TLSH_DEFAULT_PRIORITIES, TLSH_NO_PEERID,
+				     TLSH_NO_CERT);
+}
+
 #else /* CONFIG_TLS */
 
 /**
@@ -2394,6 +2434,21 @@ static int xs_tcp_tls_handshake_sync(struct rpc_xprt *xprt)
 	return -EACCES;
 }
 
+/**
+ * xs_tcp_tls_handshake_async - Start a TLS handshake
+ * @xprt: transport on which to perform handshake
+ *
+ * Caller ensures there will be no other traffic on this transport.
+ *
+ * Return values:
+ *   %0: Handshake initiated; @xprt will be awoken when it's done.
+ *   Negative errno: handshake was not started.
+ */
+static int xs_tcp_tls_handshake_async(struct rpc_xprt *xprt)
+{
+	return -EACCES;
+}
+
 #endif /*CONFIG_TLS */
 
 /**
@@ -2845,6 +2900,7 @@ static const struct rpc_xprt_ops xs_tcp_ops = {
 	.disable_swap		= xs_disable_swap,
 	.inject_disconnect	= xs_inject_disconnect,
 	.tls_handshake_sync	= xs_tcp_tls_handshake_sync,
+	.tls_handshake_async	= xs_tcp_tls_handshake_async,
 #ifdef CONFIG_SUNRPC_BACKCHANNEL
 	.bc_setup		= xprt_setup_bc,
 	.bc_maxpayload		= xs_tcp_bc_maxpayload,


