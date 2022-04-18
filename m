Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF43505D0B
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbiDRQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346623AbiDRQ4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:56:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D984534BAB;
        Mon, 18 Apr 2022 09:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81776B81050;
        Mon, 18 Apr 2022 16:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F82C385A1;
        Mon, 18 Apr 2022 16:52:09 +0000 (UTC)
Subject: [PATCH RFC 09/15] SUNRPC: Add a cl_xprtsec_policy field
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:08 -0400
Message-ID: <165030072859.5246.6224499778231227131.stgit@oracle-102.nfsv4.dev>
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

The Linux RPC client will support one  transport security policy for
each struct rpc_clnt:

Three basic ones are added initially:

 = None: No transport security for this rpc_clnt.

 = TLS: The RPC client will establish a TLS session with encryption
   for this rpc_clnt.

 = mTLS: The RPC client will perform mutual peer authentication and
   establish a TLS session with encryption for this rpc_clnt.

Add tracepoints that are used to create an audit trail of TLS usage,
as REQUIRED by Section 7.1 of draft-ietf-nfsv4-rpc-tls-11 .

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/clnt.h   |    7 +++++
 include/trace/events/sunrpc.h |   54 +++++++++++++++++++++++++++++++++++++++++
 net/sunrpc/clnt.c             |    2 ++
 3 files changed, 63 insertions(+)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index ec0d241730cb..14f169aec5c8 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -32,6 +32,12 @@
 struct rpc_inode;
 struct rpc_sysfs_client;
 
+enum rpc_xprtsec {
+	RPC_XPRTSEC_NONE,	/* No transport security is used */
+	RPC_XPRTSEC_TLS,	/* RPC-with-TLS, encryption only */
+	RPC_XPRTSEC_MTLS,	/* RPC-with-TLS, peer auth plus encryption */
+};
+
 /*
  * The high-level client handle
  */
@@ -58,6 +64,7 @@ struct rpc_clnt {
 				cl_noretranstimeo: 1,/* No retransmit timeouts */
 				cl_autobind : 1,/* use getport() */
 				cl_chatty   : 1;/* be verbose */
+	enum rpc_xprtsec	cl_xprtsec_policy;	/* transport security policy */
 
 	struct rpc_rtt *	cl_rtt;		/* RTO estimator data */
 	const struct rpc_timeout *cl_timeout;	/* Timeout strategy */
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index e8d6adff1a50..8ffc9c07bc69 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -139,6 +139,16 @@ DEFINE_RPC_CLNT_EVENT(release);
 DEFINE_RPC_CLNT_EVENT(replace_xprt);
 DEFINE_RPC_CLNT_EVENT(replace_xprt_err);
 
+TRACE_DEFINE_ENUM(RPC_XPRTSEC_NONE);
+TRACE_DEFINE_ENUM(RPC_XPRTSEC_TLS);
+TRACE_DEFINE_ENUM(RPC_XPRTSEC_MTLS);
+
+#define rpc_show_xprtsec_policy(policy)					\
+	__print_symbolic(policy,					\
+		{ RPC_XPRTSEC_NONE,		"none" },		\
+		{ RPC_XPRTSEC_TLS,		"tls" },		\
+		{ RPC_XPRTSEC_MTLS,		"mtls" })
+
 TRACE_EVENT(rpc_clnt_new,
 	TP_PROTO(
 		const struct rpc_clnt *clnt,
@@ -1535,6 +1545,50 @@ TRACE_EVENT(rpcb_unregister,
 	)
 );
 
+/**
+ ** RPC-over-TLS tracepoints
+ **/
+
+DECLARE_EVENT_CLASS(rpc_tls_class,
+	TP_PROTO(
+		const struct rpc_clnt *clnt,
+		const struct rpc_xprt *xprt
+	),
+
+	TP_ARGS(clnt, xprt),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, requested_policy)
+		__field(u32, version)
+		__string(servername, xprt->servername)
+		__string(progname, clnt->cl_program->name)
+	),
+
+	TP_fast_assign(
+		__entry->requested_policy = clnt->cl_xprtsec_policy;
+		__entry->version = clnt->cl_vers;
+		__assign_str(servername, xprt->servername);
+		__assign_str(progname, clnt->cl_program->name)
+	),
+
+	TP_printk("server=%s %sv%u requested_policy=%s",
+		__get_str(servername), __get_str(progname), __entry->version,
+		rpc_show_xprtsec_policy(__entry->requested_policy)
+	)
+);
+
+#define DEFINE_RPC_TLS_EVENT(name) \
+	DEFINE_EVENT(rpc_tls_class, rpc_tls_##name, \
+			TP_PROTO( \
+				const struct rpc_clnt *clnt, \
+				const struct rpc_xprt *xprt \
+			), \
+			TP_ARGS(clnt, xprt))
+
+DEFINE_RPC_TLS_EVENT(unavailable);
+DEFINE_RPC_TLS_EVENT(not_started);
+
+
 /* Record an xdr_buf containing a fully-formed RPC message */
 DECLARE_EVENT_CLASS(svc_xdr_msg_class,
 	TP_PROTO(
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 3fb601d8a531..856581018f10 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -477,6 +477,7 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 	if (IS_ERR(clnt))
 		return clnt;
 
+	clnt->cl_xprtsec_policy = RPC_XPRTSEC_NONE;
 	if (!(args->flags & RPC_CLNT_CREATE_NOPING)) {
 		int err = rpc_ping(clnt);
 		if (err != 0) {
@@ -643,6 +644,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	new->cl_noretranstimeo = clnt->cl_noretranstimeo;
 	new->cl_discrtry = clnt->cl_discrtry;
 	new->cl_chatty = clnt->cl_chatty;
+	new->cl_xprtsec_policy = clnt->cl_xprtsec_policy;
 	new->cl_principal = clnt->cl_principal;
 	return new;
 


