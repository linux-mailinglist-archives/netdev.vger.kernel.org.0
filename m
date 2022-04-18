Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA75505D1D
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346829AbiDRQ5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346841AbiDRQ5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2343A35DFE;
        Mon, 18 Apr 2022 09:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B490AB81050;
        Mon, 18 Apr 2022 16:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00A9C385B9;
        Mon, 18 Apr 2022 16:52:43 +0000 (UTC)
Subject: [PATCH RFC 14/15] NFS: Have struct nfs_client carry a TLS policy
 field
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:43 -0400
Message-ID: <165030076300.5246.10317845682186810210.stgit@oracle-102.nfsv4.dev>
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

The new field is used to match struct nfs_clients that have the same
TLS policy setting.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/client.c           |    6 ++++++
 fs/nfs/internal.h         |    1 +
 fs/nfs/nfs3client.c       |    1 +
 fs/nfs/nfs4client.c       |   16 +++++++++++-----
 include/linux/nfs_fs_sb.h |    7 ++++++-
 5 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e828504cc396..0896e4f047d1 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -184,6 +184,7 @@ struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_init)
 	clp->cl_net = get_net(cl_init->net);
 
 	clp->cl_principal = "*";
+	clp->cl_xprtsec = cl_init->xprtsec_policy;
 	return clp;
 
 error_cleanup:
@@ -326,6 +327,10 @@ static struct nfs_client *nfs_match_client(const struct nfs_client_initdata *dat
 							   sap))
 				continue;
 
+		/* Match the xprt security policy */
+		if (clp->cl_xprtsec != data->xprtsec_policy)
+			continue;
+
 		refcount_inc(&clp->cl_count);
 		return clp;
 	}
@@ -675,6 +680,7 @@ static int nfs_init_server(struct nfs_server *server,
 		.cred = server->cred,
 		.nconnect = ctx->nfs_server.nconnect,
 		.init_flags = (1UL << NFS_CS_REUSEPORT),
+		.xprtsec_policy = NFS_CS_XPRTSEC_NONE,
 	};
 	struct nfs_client *clp;
 	int error;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 7eefa16ed381..0a3512c39376 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -81,6 +81,7 @@ struct nfs_client_initdata {
 	struct net *net;
 	const struct rpc_timeout *timeparms;
 	const struct cred *cred;
+	unsigned int xprtsec_policy;
 };
 
 /*
diff --git a/fs/nfs/nfs3client.c b/fs/nfs/nfs3client.c
index 5601e47360c2..d7c5db1f5825 100644
--- a/fs/nfs/nfs3client.c
+++ b/fs/nfs/nfs3client.c
@@ -93,6 +93,7 @@ struct nfs_client *nfs3_set_ds_client(struct nfs_server *mds_srv,
 		.net = mds_clp->cl_net,
 		.timeparms = &ds_timeout,
 		.cred = mds_srv->cred,
+		.xprtsec_policy = mds_clp->cl_xprtsec,
 	};
 	struct nfs_client *clp;
 	char buf[INET6_ADDRSTRLEN + 1];
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 47a6cf892c95..682d47e5977b 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -895,7 +895,8 @@ static int nfs4_set_client(struct nfs_server *server,
 		int proto, const struct rpc_timeout *timeparms,
 		u32 minorversion, unsigned int nconnect,
 		unsigned int max_connect,
-		struct net *net)
+		struct net *net,
+		unsigned int xprtsec_policy)
 {
 	struct nfs_client_initdata cl_init = {
 		.hostname = hostname,
@@ -908,6 +909,7 @@ static int nfs4_set_client(struct nfs_server *server,
 		.net = net,
 		.timeparms = timeparms,
 		.cred = server->cred,
+		.xprtsec_policy = xprtsec_policy,
 	};
 	struct nfs_client *clp;
 
@@ -1156,7 +1158,8 @@ static int nfs4_init_server(struct nfs_server *server, struct fs_context *fc)
 				ctx->minorversion,
 				ctx->nfs_server.nconnect,
 				ctx->nfs_server.max_connect,
-				fc->net_ns);
+				fc->net_ns,
+				NFS_CS_XPRTSEC_NONE);
 	if (error < 0)
 		return error;
 
@@ -1246,7 +1249,8 @@ struct nfs_server *nfs4_create_referral_server(struct fs_context *fc)
 				parent_client->cl_mvops->minor_version,
 				parent_client->cl_nconnect,
 				parent_client->cl_max_connect,
-				parent_client->cl_net);
+				parent_client->cl_net,
+				parent_client->cl_xprtsec);
 	if (!error)
 		goto init_server;
 #endif	/* IS_ENABLED(CONFIG_SUNRPC_XPRT_RDMA) */
@@ -1262,7 +1266,8 @@ struct nfs_server *nfs4_create_referral_server(struct fs_context *fc)
 				parent_client->cl_mvops->minor_version,
 				parent_client->cl_nconnect,
 				parent_client->cl_max_connect,
-				parent_client->cl_net);
+				parent_client->cl_net,
+				parent_client->cl_xprtsec);
 	if (error < 0)
 		goto error;
 
@@ -1335,7 +1340,8 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 	error = nfs4_set_client(server, hostname, sap, salen, buf,
 				clp->cl_proto, clnt->cl_timeout,
 				clp->cl_minorversion,
-				clp->cl_nconnect, clp->cl_max_connect, net);
+				clp->cl_nconnect, clp->cl_max_connect,
+				net, clp->cl_xprtsec);
 	clear_bit(NFS_MIG_TSM_POSSIBLE, &server->mig_status);
 	if (error != 0) {
 		nfs_server_insert_lists(server);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 157d2bd6b241..7ec7d3b37d19 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -63,7 +63,12 @@ struct nfs_client {
 	u32			cl_minorversion;/* NFSv4 minorversion */
 	unsigned int		cl_nconnect;	/* Number of connections */
 	unsigned int		cl_max_connect; /* max number of xprts allowed */
-	const char *		cl_principal;  /* used for machine cred */
+	const char *		cl_principal;	/* used for machine cred */
+	unsigned int		cl_xprtsec;	/* xprt security policy */
+#define NFS_CS_XPRTSEC_NONE	(0)
+#define NFS_CS_XPRTSEC_AUTO	(1)
+#define NFS_CS_XPRTSEC_TLS	(2)
+#define NFS_CS_XPRTSEC_MTLS	(3)
 
 #if IS_ENABLED(CONFIG_NFS_V4)
 	struct list_head	cl_ds_clients; /* auth flavor data servers */


