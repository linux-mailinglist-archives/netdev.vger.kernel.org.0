Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0DE505D11
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbiDRQ5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiDRQ4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:56:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5F2340C8;
        Mon, 18 Apr 2022 09:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F21612FB;
        Mon, 18 Apr 2022 16:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD0C385A7;
        Mon, 18 Apr 2022 16:52:30 +0000 (UTC)
Subject: [PATCH RFC 12/15] SUNRPC: Add FSM machinery to handle RPC_AUTH_TLS on
 reconnect
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:29 -0400
Message-ID: <165030074924.5246.5399913437403260546.stgit@oracle-102.nfsv4.dev>
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

Try STARTTLS with the RPC server peer as soon as a transport
connection is established.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/clnt.h  |    1 -
 include/linux/sunrpc/sched.h |    1 +
 net/sunrpc/clnt.c            |   59 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 15fd84e4c321..e10a19d136ca 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -209,7 +209,6 @@ int		rpc_call_sync(struct rpc_clnt *clnt,
 			      unsigned int flags);
 struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred,
 			       int flags);
-void		rpc_starttls_async(struct rpc_task *task);
 int		rpc_restart_call_prepare(struct rpc_task *);
 int		rpc_restart_call(struct rpc_task *);
 void		rpc_setbufsize(struct rpc_clnt *, unsigned int, unsigned int);
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index f8c09638fa69..0d1ae89a2339 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -139,6 +139,7 @@ struct rpc_task_setup {
 #define RPC_IS_ASYNC(t)		((t)->tk_flags & RPC_TASK_ASYNC)
 #define RPC_IS_SWAPPER(t)	((t)->tk_flags & RPC_TASK_SWAPPER)
 #define RPC_IS_CORK(t)		((t)->tk_flags & RPC_TASK_CORK)
+#define RPC_IS_TLSPROBE(t)	((t)->tk_flags & RPC_TASK_TLSCRED)
 #define RPC_IS_SOFT(t)		((t)->tk_flags & (RPC_TASK_SOFT|RPC_TASK_TIMEOUT))
 #define RPC_IS_SOFTCONN(t)	((t)->tk_flags & RPC_TASK_SOFTCONN)
 #define RPC_WAS_SENT(t)		((t)->tk_flags & RPC_TASK_SENT)
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e9a6622dba68..0506971410f7 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -70,6 +70,8 @@ static void	call_refresh(struct rpc_task *task);
 static void	call_refreshresult(struct rpc_task *task);
 static void	call_connect(struct rpc_task *task);
 static void	call_connect_status(struct rpc_task *task);
+static void	call_start_tls(struct rpc_task *task);
+static void	call_tls_status(struct rpc_task *task);
 
 static int	rpc_encode_header(struct rpc_task *task,
 				  struct xdr_stream *xdr);
@@ -77,6 +79,7 @@ static int	rpc_decode_header(struct rpc_task *task,
 				  struct xdr_stream *xdr);
 static int	rpc_ping(struct rpc_clnt *clnt);
 static int	rpc_starttls_sync(struct rpc_clnt *clnt);
+static void	rpc_starttls_async(struct rpc_task *task);
 static void	rpc_check_timeout(struct rpc_task *task);
 
 static void rpc_register_client(struct rpc_clnt *clnt)
@@ -2163,7 +2166,7 @@ call_connect_status(struct rpc_task *task)
 	rpc_call_rpcerror(task, status);
 	return;
 out_next:
-	task->tk_action = call_transmit;
+	task->tk_action = call_start_tls;
 	return;
 out_retry:
 	/* Check for timeouts before looping back to call_bind */
@@ -2171,6 +2174,53 @@ call_connect_status(struct rpc_task *task)
 	rpc_check_timeout(task);
 }
 
+static void
+call_start_tls(struct rpc_task *task)
+{
+	struct rpc_xprt *xprt = task->tk_rqstp->rq_xprt;
+	struct rpc_clnt *clnt = task->tk_client;
+
+	task->tk_action = call_transmit;
+	if (RPC_IS_TLSPROBE(task))
+		return;
+
+	switch (clnt->cl_xprtsec_policy) {
+	case RPC_XPRTSEC_TLS:
+	case RPC_XPRTSEC_MTLS:
+		if (xprt->ops->tls_handshake_async) {
+			task->tk_action = call_tls_status;
+			rpc_starttls_async(task);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+call_tls_status(struct rpc_task *task)
+{
+	struct rpc_xprt *xprt = task->tk_rqstp->rq_xprt;
+	struct rpc_clnt *clnt = task->tk_client;
+
+	task->tk_action = call_transmit;
+	if (!task->tk_status)
+		return;
+
+	xprt_force_disconnect(xprt);
+
+	switch (clnt->cl_xprtsec_policy) {
+	case RPC_XPRTSEC_TLS:
+	case RPC_XPRTSEC_MTLS:
+		rpc_delay(task, 5*HZ /* arbitrary */);
+		break;
+	default:
+		task->tk_action = call_bind;
+	}
+
+	rpc_check_timeout(task);
+}
+
 /*
  * 5.	Transmit the RPC request, and wait for reply
  */
@@ -2355,7 +2405,7 @@ call_status(struct rpc_task *task)
 	struct rpc_clnt	*clnt = task->tk_client;
 	int		status;
 
-	if (!task->tk_msg.rpc_proc->p_proc)
+	if (!task->tk_msg.rpc_proc->p_proc && !RPC_IS_TLSPROBE(task))
 		trace_xprt_ping(task->tk_xprt, task->tk_status);
 
 	status = task->tk_status;
@@ -2663,6 +2713,8 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 
 out_msg_denied:
 	error = -EACCES;
+	if (RPC_IS_TLSPROBE(task))
+		goto out_err;
 	p = xdr_inline_decode(xdr, sizeof(*p));
 	if (!p)
 		goto out_unparsable;
@@ -2865,7 +2917,7 @@ static const struct rpc_call_ops rpc_ops_probe_tls = {
  * @task: an RPC task waiting for a TLS session
  *
  */
-void rpc_starttls_async(struct rpc_task *task)
+static void rpc_starttls_async(struct rpc_task *task)
 {
 	struct rpc_xprt *xprt = xprt_get(task->tk_xprt);
 
@@ -2885,7 +2937,6 @@ void rpc_starttls_async(struct rpc_task *task)
 		     RPC_TASK_TLSCRED | RPC_TASK_SWAPPER | RPC_TASK_CORK,
 		     &rpc_ops_probe_tls, xprt));
 }
-EXPORT_SYMBOL_GPL(rpc_starttls_async);
 
 struct rpc_cb_add_xprt_calldata {
 	struct rpc_xprt_switch *xps;


