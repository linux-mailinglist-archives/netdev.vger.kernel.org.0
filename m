Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00722505D14
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346726AbiDRQ5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346714AbiDRQ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3717034BB0;
        Mon, 18 Apr 2022 09:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0B5612F3;
        Mon, 18 Apr 2022 16:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DBEC385AA;
        Mon, 18 Apr 2022 16:52:16 +0000 (UTC)
Subject: [PATCH RFC 10/15] SUNRPC: Expose TLS policy via the rpc_create() API
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:15 -0400
Message-ID: <165030073541.5246.4496835069767281458.stgit@oracle-102.nfsv4.dev>
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

Consumers use this API to specify RPC-over-TLS security policy for
each rpc_clnt. For the moment, this checks for TLS availability only
at the time the struct rpc_clnt is created.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/clnt.h     |    1 
 include/linux/sunrpc/xprt.h     |    1 
 include/linux/sunrpc/xprtsock.h |    1 
 include/trace/events/sunrpc.h   |   41 +++++++++++++----
 net/sunrpc/clnt.c               |   81 +++++++++++++++++++++++++++++++---
 net/sunrpc/xprtsock.c           |   93 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 201 insertions(+), 17 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 14f169aec5c8..e10a19d136ca 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -146,6 +146,7 @@ struct rpc_create_args {
 	struct svc_xprt		*bc_xprt;	/* NFSv4.1 backchannel */
 	const struct cred	*cred;
 	unsigned int		max_connect;
+	enum rpc_xprtsec	xprtsec_policy;
 };
 
 struct rpc_add_xprt_test {
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 522bbf937957..8d654bc35dce 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -158,6 +158,7 @@ struct rpc_xprt_ops {
 	int		(*enable_swap)(struct rpc_xprt *xprt);
 	void		(*disable_swap)(struct rpc_xprt *xprt);
 	void		(*inject_disconnect)(struct rpc_xprt *xprt);
+	int		(*tls_handshake_sync)(struct rpc_xprt *xprt);
 	int		(*bc_setup)(struct rpc_xprt *xprt,
 				    unsigned int min_reqs);
 	size_t		(*bc_maxpayload)(struct rpc_xprt *xprt);
diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 426c3bd516fe..d738a302b38b 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -58,6 +58,7 @@ struct sock_xprt {
 	struct work_struct	error_worker;
 	struct work_struct	recv_worker;
 	struct mutex		recv_mutex;
+	struct completion	handshake_done;
 	struct sockaddr_storage	srcaddr;
 	unsigned short		srcport;
 	int			xprt_err;
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 8ffc9c07bc69..a73b68e25a8c 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -149,36 +149,56 @@ TRACE_DEFINE_ENUM(RPC_XPRTSEC_MTLS);
 		{ RPC_XPRTSEC_TLS,		"tls" },		\
 		{ RPC_XPRTSEC_MTLS,		"mtls" })
 
+#define rpc_show_create_flags(flags)					\
+	__print_flags(flags, "|",					\
+		{ RPC_CLNT_CREATE_HARDRTRY,	"HARDRTRY" },		\
+		{ RPC_CLNT_CREATE_AUTOBIND,	"AUTOBIND" },		\
+		{ RPC_CLNT_CREATE_NONPRIVPORT,	"NONPRIVPORT" },	\
+		{ RPC_CLNT_CREATE_NOPING,	"NOPING" },		\
+		{ RPC_CLNT_CREATE_DISCRTRY,	"DISCRTRY" },		\
+		{ RPC_CLNT_CREATE_QUIET,	"QUIET" },		\
+		{ RPC_CLNT_CREATE_INFINITE_SLOTS,	"INFINITE_SLOTS" }, \
+		{ RPC_CLNT_CREATE_NO_IDLE_TIMEOUT,	"NO_IDLE_TIMEOUT" }, \
+		{ RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT,	"NO_RETRANS_TIMEOUT" }, \
+		{ RPC_CLNT_CREATE_SOFTERR,	"SOFTERR" },		\
+		{ RPC_CLNT_CREATE_REUSEPORT,	"REUSEPORT" })
+
 TRACE_EVENT(rpc_clnt_new,
 	TP_PROTO(
 		const struct rpc_clnt *clnt,
 		const struct rpc_xprt *xprt,
-		const char *program,
-		const char *server
+		const struct rpc_create_args *args
 	),
 
-	TP_ARGS(clnt, xprt, program, server),
+	TP_ARGS(clnt, xprt, args),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, client_id)
+		__field(unsigned long, xprtsec)
+		__field(unsigned long, flags)
+		__string(program, clnt->cl_program->name)
+		__string(server, xprt->servername)
 		__string(addr, xprt->address_strings[RPC_DISPLAY_ADDR])
 		__string(port, xprt->address_strings[RPC_DISPLAY_PORT])
-		__string(program, program)
-		__string(server, server)
 	),
 
 	TP_fast_assign(
 		__entry->client_id = clnt->cl_clid;
+		__entry->xprtsec = args->xprtsec_policy;
+		__entry->flags = args->flags;
+		__assign_str(program, clnt->cl_program->name);
+		__assign_str(server, xprt->servername);
 		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
 		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
-		__assign_str(program, program);
-		__assign_str(server, server);
 	),
 
-	TP_printk("client=" SUNRPC_TRACE_CLID_SPECIFIER
-		  " peer=[%s]:%s program=%s server=%s",
+	TP_printk("client=" SUNRPC_TRACE_CLID_SPECIFIER " peer=[%s]:%s"
+		" program=%s server=%s xprtsec=%s flags=%s",
 		__entry->client_id, __get_str(addr), __get_str(port),
-		__get_str(program), __get_str(server))
+		__get_str(program), __get_str(server),
+		rpc_show_xprtsec_policy(__entry->xprtsec),
+		rpc_show_create_flags(__entry->flags)
+	)
 );
 
 TRACE_EVENT(rpc_clnt_new_err,
@@ -1585,6 +1605,7 @@ DECLARE_EVENT_CLASS(rpc_tls_class,
 			), \
 			TP_ARGS(clnt, xprt))
 
+DEFINE_RPC_TLS_EVENT(unsupported);
 DEFINE_RPC_TLS_EVENT(unavailable);
 DEFINE_RPC_TLS_EVENT(not_started);
 
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 856581018f10..1601a06deaf5 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -76,6 +76,7 @@ static int	rpc_encode_header(struct rpc_task *task,
 static int	rpc_decode_header(struct rpc_task *task,
 				  struct xdr_stream *xdr);
 static int	rpc_ping(struct rpc_clnt *clnt);
+static int	rpc_starttls_sync(struct rpc_clnt *clnt);
 static void	rpc_check_timeout(struct rpc_task *task);
 
 static void rpc_register_client(struct rpc_clnt *clnt)
@@ -433,7 +434,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 	if (parent)
 		refcount_inc(&parent->cl_count);
 
-	trace_rpc_clnt_new(clnt, xprt, program->name, args->servername);
+	trace_rpc_clnt_new(clnt, xprt, args);
 	return clnt;
 
 out_no_path:
@@ -457,6 +458,7 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 {
 	struct rpc_clnt *clnt = NULL;
 	struct rpc_xprt_switch *xps;
+	int err;
 
 	if (args->bc_xprt && args->bc_xprt->xpt_bc_xps) {
 		WARN_ON_ONCE(!(args->protocol & XPRT_TRANSPORT_BC));
@@ -477,13 +479,23 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 	if (IS_ERR(clnt))
 		return clnt;
 
-	clnt->cl_xprtsec_policy = RPC_XPRTSEC_NONE;
-	if (!(args->flags & RPC_CLNT_CREATE_NOPING)) {
-		int err = rpc_ping(clnt);
-		if (err != 0) {
-			rpc_shutdown_client(clnt);
-			return ERR_PTR(err);
+	clnt->cl_xprtsec_policy = args->xprtsec_policy;
+	switch (args->xprtsec_policy) {
+	case RPC_XPRTSEC_NONE:
+		if (!(args->flags & RPC_CLNT_CREATE_NOPING)) {
+			err = rpc_ping(clnt);
+			if (err != 0)
+				goto out_shutdown;
 		}
+		break;
+	case RPC_XPRTSEC_TLS:
+		err = rpc_starttls_sync(clnt);
+		if (err != 0)
+			goto out_shutdown;
+		break;
+	default:
+		err = -EINVAL;
+		goto out_shutdown;
 	}
 
 	clnt->cl_softrtry = 1;
@@ -503,6 +515,10 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 		clnt->cl_chatty = 1;
 
 	return clnt;
+
+out_shutdown:
+	rpc_shutdown_client(clnt);
+	return ERR_PTR(err);
 }
 
 /**
@@ -690,6 +706,7 @@ rpc_clone_client_set_auth(struct rpc_clnt *clnt, rpc_authflavor_t flavor)
 		.version	= clnt->cl_vers,
 		.authflavor	= flavor,
 		.cred		= clnt->cl_cred,
+		.xprtsec_policy	= clnt->cl_xprtsec_policy,
 	};
 	return __rpc_clone_client(&args, clnt);
 }
@@ -2762,6 +2779,56 @@ static int rpc_ping(struct rpc_clnt *clnt)
 	return status;
 }
 
+/**
+ * rpc_starttls_sync - Synchronously establish a TLS session
+ * @clnt: A fresh RPC client
+ *
+ * Return values:
+ *   %0: TLS session established
+ *   %-ENOPROTOOPT: underlying xprt does not support TLS
+ *   %-EPERM: peer does not support TLS
+ *   %-EACCES: TLS session could not be established
+ */
+static int rpc_starttls_sync(struct rpc_clnt *clnt)
+{
+	struct rpc_xprt *xprt = xprt_get(rcu_dereference(clnt->cl_xprt));
+	struct rpc_message msg = {
+		.rpc_proc = &rpcproc_null,
+	};
+	int err;
+
+	if (!xprt->ops->tls_handshake_sync) {
+		trace_rpc_tls_unsupported(clnt, xprt);
+		err = -ENOPROTOOPT;
+		goto out_put;
+	}
+
+	err = rpc_call_sync(clnt, &msg,
+			    RPC_TASK_SOFT | RPC_TASK_SOFTCONN |
+			    RPC_TASK_TLSCRED);
+	switch (err) {
+	case 0:
+		break;
+	case -EACCES:
+	case -EIO:
+		trace_rpc_tls_unavailable(clnt, xprt);
+		err = -EPERM;
+		fallthrough;
+	default:
+		goto out_put;
+	}
+
+	if (xprt->ops->tls_handshake_sync(xprt)) {
+		trace_rpc_tls_not_started(clnt, xprt);
+		err = -EACCES;
+		goto out_put;
+	}
+
+out_put:
+	xprt_put(xprt);
+	return err;
+}
+
 struct rpc_cb_add_xprt_calldata {
 	struct rpc_xprt_switch *xps;
 	struct rpc_xprt *xprt;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e42ae84d7359..bbba9747f68d 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -48,6 +48,7 @@
 #include <net/udp.h>
 #include <net/tcp.h>
 #include <net/tls.h>
+#include <net/tlsh.h>
 
 #include <linux/bvec.h>
 #include <linux/highmem.h>
@@ -197,6 +198,11 @@ static struct ctl_table sunrpc_table[] = {
  */
 #define XS_IDLE_DISC_TO		(5U * 60 * HZ)
 
+/*
+ * TLS handshake timeout.
+ */
+#define XS_TLS_HANDSHAKE_TO	(20U * HZ)
+
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 # undef  RPC_DEBUG_DATA
 # define RPCDBG_FACILITY	RPCDBG_TRANS
@@ -2304,6 +2310,92 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 	return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, O_NONBLOCK);
 }
 
+#if IS_ENABLED(CONFIG_TLS)
+
+static void xs_tcp_clear_discard(struct sock_xprt *transport)
+{
+	transport->recv.ignore_dr = false;
+	transport->recv.copied = 0;
+	transport->recv.offset = 0;
+	transport->recv.len = 0;
+}
+
+/**
+ * xs_tcp_tls_handshake_done - TLS handshake completion handler
+ * @data: address of xprt to wake
+ * @status: status of handshake
+ *
+ */
+static void xs_tcp_tls_handshake_done(void *data, int status)
+{
+	struct rpc_xprt *xprt = data;
+	struct sock_xprt *transport =
+				container_of(xprt, struct sock_xprt, xprt);
+
+	transport->xprt_err = status ? -EACCES : 0;
+	complete(&transport->handshake_done);
+	xprt_put(xprt);
+}
+
+/**
+ * xs_tcp_tls_handshake_sync - Perform a full TLS client handshake
+ * @xprt: transport on which to perform handshake
+ *
+ * Caller ensures there will be no other traffic on this transport.
+ *
+ * Return values:
+ *   %0: Handshake completed successfully.
+ *   Negative errno: handshake not started, or failed.
+ */
+static int xs_tcp_tls_handshake_sync(struct rpc_xprt *xprt)
+{
+	struct sock_xprt *transport =
+				container_of(xprt, struct sock_xprt, xprt);
+	int rc;
+
+	/* XXX: make it an XPRT_ flag instead? */
+	WRITE_ONCE(transport->recv.ignore_dr, true);
+
+	init_completion(&transport->handshake_done);
+
+	transport->xprt_err = -ETIMEDOUT;
+	rc = tls_client_hello_x509(transport->sock,
+				   xs_tcp_tls_handshake_done, xprt_get(xprt),
+				   TLSH_DEFAULT_PRIORITIES, TLSH_NO_PEERID,
+				   TLSH_NO_CERT);
+	if (rc)
+		goto out;
+
+	rc = wait_for_completion_interruptible_timeout(&transport->handshake_done,
+						       XS_TLS_HANDSHAKE_TO);
+	if (rc < 0)
+		goto out;
+
+	rc = transport->xprt_err;
+
+out:
+	xs_tcp_clear_discard(transport);
+	return rc;
+}
+
+#else /* CONFIG_TLS */
+
+/**
+ * xs_tcp_tls_handshake_sync - Perform a full TLS client handshake
+ * @xprt: transport on which to perform handshake
+ *
+ * Caller ensures there will be no other traffic on this transport.
+ *
+ * Return values:
+ *   %-EACCES: handshake was not started.
+ */
+static int xs_tcp_tls_handshake_sync(struct rpc_xprt *xprt)
+{
+	return -EACCES;
+}
+
+#endif /*CONFIG_TLS */
+
 /**
  * xs_tcp_setup_socket - create a TCP socket and connect to a remote endpoint
  * @work: queued work item
@@ -2752,6 +2844,7 @@ static const struct rpc_xprt_ops xs_tcp_ops = {
 	.enable_swap		= xs_enable_swap,
 	.disable_swap		= xs_disable_swap,
 	.inject_disconnect	= xs_inject_disconnect,
+	.tls_handshake_sync	= xs_tcp_tls_handshake_sync,
 #ifdef CONFIG_SUNRPC_BACKCHANNEL
 	.bc_setup		= xprt_setup_bc,
 	.bc_maxpayload		= xs_tcp_bc_maxpayload,


