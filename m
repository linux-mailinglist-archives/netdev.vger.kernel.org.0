Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7273505D0A
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346680AbiDRQ5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346652AbiDRQ5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E902E35AA3;
        Mon, 18 Apr 2022 09:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548E9612DF;
        Mon, 18 Apr 2022 16:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E427C385A1;
        Mon, 18 Apr 2022 16:52:37 +0000 (UTC)
Subject: [PATCH RFC 13/15] NFS: Replace fs_context-related dprintk() call
 sites with tracepoints
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:35 -0400
Message-ID: <165030075595.5246.450883758227828699.stgit@oracle-102.nfsv4.dev>
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

Contributed as part of the long patch series that converts NFS from
using dprintk to tracepoints for observability.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/fs_context.c |   25 ++++++++++-------
 fs/nfs/nfstrace.h   |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index e2d59bb5e6bb..b52362735d12 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -21,6 +21,8 @@
 #include "nfs.h"
 #include "internal.h"
 
+#include "nfstrace.h"
+
 #define NFSDBG_FACILITY		NFSDBG_MOUNT
 
 #if IS_ENABLED(CONFIG_NFS_V3)
@@ -284,7 +286,7 @@ static int nfs_verify_server_address(struct sockaddr *addr)
 	}
 	}
 
-	dfprintk(MOUNT, "NFS: Invalid IP address specified\n");
+	trace_nfs_mount_addr_err(addr);
 	return 0;
 }
 
@@ -378,7 +380,7 @@ static int nfs_parse_security_flavors(struct fs_context *fc,
 	char *string = param->string, *p;
 	int ret;
 
-	dfprintk(MOUNT, "NFS: parsing %s=%s option\n", param->key, param->string);
+	trace_nfs_mount_assign(param->key, string);
 
 	while ((p = strsep(&string, ":")) != NULL) {
 		if (!*p)
@@ -480,7 +482,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 	unsigned int len;
 	int ret, opt;
 
-	dfprintk(MOUNT, "NFS:   parsing nfs mount option '%s'\n", param->key);
+	trace_nfs_mount_option(param);
 
 	opt = fs_parse(fc, nfs_fs_parameters, param, &result);
 	if (opt < 0)
@@ -683,6 +685,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 			return ret;
 		break;
 	case Opt_vers:
+		trace_nfs_mount_assign(param->key, param->string);
 		ret = nfs_parse_version_string(fc, param->string);
 		if (ret < 0)
 			return ret;
@@ -694,6 +697,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		break;
 
 	case Opt_proto:
+		trace_nfs_mount_assign(param->key, param->string);
 		protofamily = AF_INET;
 		switch (lookup_constant(nfs_xprt_protocol_tokens, param->string, -1)) {
 		case Opt_xprt_udp6:
@@ -729,6 +733,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		break;
 
 	case Opt_mountproto:
+		trace_nfs_mount_assign(param->key, param->string);
 		mountfamily = AF_INET;
 		switch (lookup_constant(nfs_xprt_protocol_tokens, param->string, -1)) {
 		case Opt_xprt_udp6:
@@ -751,6 +756,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		break;
 
 	case Opt_addr:
+		trace_nfs_mount_assign(param->key, param->string);
 		len = rpc_pton(fc->net_ns, param->string, param->size,
 			       &ctx->nfs_server.address,
 			       sizeof(ctx->nfs_server._address));
@@ -759,16 +765,19 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		ctx->nfs_server.addrlen = len;
 		break;
 	case Opt_clientaddr:
+		trace_nfs_mount_assign(param->key, param->string);
 		kfree(ctx->client_address);
 		ctx->client_address = param->string;
 		param->string = NULL;
 		break;
 	case Opt_mounthost:
+		trace_nfs_mount_assign(param->key, param->string);
 		kfree(ctx->mount_server.hostname);
 		ctx->mount_server.hostname = param->string;
 		param->string = NULL;
 		break;
 	case Opt_mountaddr:
+		trace_nfs_mount_assign(param->key, param->string);
 		len = rpc_pton(fc->net_ns, param->string, param->size,
 			       &ctx->mount_server.address,
 			       sizeof(ctx->mount_server._address));
@@ -846,7 +855,6 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		 */
 	case Opt_sloppy:
 		ctx->sloppy = true;
-		dfprintk(MOUNT, "NFS:   relaxing parsing rules\n");
 		break;
 	}
 
@@ -879,10 +887,8 @@ static int nfs_parse_source(struct fs_context *fc,
 	size_t len;
 	const char *end;
 
-	if (unlikely(!dev_name || !*dev_name)) {
-		dfprintk(MOUNT, "NFS: device name not specified\n");
+	if (unlikely(!dev_name || !*dev_name))
 		return -EINVAL;
-	}
 
 	/* Is the host name protected with square brakcets? */
 	if (*dev_name == '[') {
@@ -922,7 +928,7 @@ static int nfs_parse_source(struct fs_context *fc,
 	if (!ctx->nfs_server.export_path)
 		goto out_nomem;
 
-	dfprintk(MOUNT, "NFS: MNTPATH: '%s'\n", ctx->nfs_server.export_path);
+	trace_nfs_mount_path(ctx->nfs_server.export_path);
 	return 0;
 
 out_bad_devname:
@@ -1116,7 +1122,6 @@ static int nfs23_parse_monolithic(struct fs_context *fc,
 	return nfs_invalf(fc, "NFS: nfs_mount_data version supports only AUTH_SYS");
 
 out_nomem:
-	dfprintk(MOUNT, "NFS: not enough memory to handle mount options");
 	return -ENOMEM;
 
 out_no_address:
@@ -1248,7 +1253,7 @@ static int nfs4_parse_monolithic(struct fs_context *fc,
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 	ctx->nfs_server.export_path = c;
-	dfprintk(MOUNT, "NFS: MNTPATH: '%s'\n", c);
+	trace_nfs_mount_path(c);
 
 	c = strndup_user(data->client_addr.data, 16);
 	if (IS_ERR(c))
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index 012bd7339862..ccaeae42ee77 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -1609,6 +1609,83 @@ TRACE_EVENT(nfs_fh_to_dentry,
 		)
 );
 
+TRACE_EVENT(nfs_mount_addr_err,
+	TP_PROTO(
+		const struct sockaddr *sap
+	),
+
+	TP_ARGS(sap),
+
+	TP_STRUCT__entry(
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->addr, sap, sizeof(__entry->addr));
+	),
+
+	TP_printk("addr=%pISpc", __entry->addr)
+);
+
+TRACE_EVENT(nfs_mount_assign,
+	TP_PROTO(
+		const char *option,
+		const char *value
+	),
+
+	TP_ARGS(option, value),
+
+	TP_STRUCT__entry(
+		__string(option, option)
+		__string(value, value)
+	),
+
+	TP_fast_assign(
+		__assign_str(option, option);
+		__assign_str(value, value);
+	),
+
+	TP_printk("option %s=%s",
+		__get_str(option), __get_str(value)
+	)
+);
+
+TRACE_EVENT(nfs_mount_option,
+	TP_PROTO(
+		const struct fs_parameter *param
+	),
+
+	TP_ARGS(param),
+
+	TP_STRUCT__entry(
+		__string(option, param->key)
+	),
+
+	TP_fast_assign(
+		__assign_str(option, param->key);
+	),
+
+	TP_printk("option %s", __get_str(option))
+);
+
+TRACE_EVENT(nfs_mount_path,
+	TP_PROTO(
+		const char *path
+	),
+
+	TP_ARGS(path),
+
+	TP_STRUCT__entry(
+		__string(path, path)
+	),
+
+	TP_fast_assign(
+		__assign_str(path, path);
+	),
+
+	TP_printk("path='%s'", __get_str(path))
+);
+
 DECLARE_EVENT_CLASS(nfs_xdr_event,
 		TP_PROTO(
 			const struct xdr_stream *xdr,


