Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC9D41A5F9
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 05:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhI1DR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 23:17:28 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:22256 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbhI1DRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 23:17:24 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HJPkh4Q56z8tS3;
        Tue, 28 Sep 2021 11:14:52 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 11:15:43 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 11:15:41 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <bfields@fieldses.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wenbin.zeng@gmail.com>, <jlayton@kernel.org>, <dsahern@gmail.com>,
        <nicolas.dichtel@6wind.com>, <viro@zeniv.linux.org.uk>,
        <willy@infradead.org>, <jakub.kicinski@netronome.com>,
        <tyhicks@canonical.com>, <cong.wang@bytedance.com>,
        <ast@kernel.org>, <jiang.wang@bytedance.com>,
        <christian.brauner@ubuntu.com>, <edumazet@google.com>,
        <Rao.Shoaib@oracle.com>, <kuniyu@amazon.co.jp>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <chuck.lever@oracle.com>, <neilb@suse.com>, <kolga@netapp.com>,
        <timo@rothenpieler.org>, <tom@talpey.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 2/2] auth_gss: Fix deadlock that blocks rpcsec_gss_exit_net when use-gss-proxy==1
Date:   Tue, 28 Sep 2021 11:14:40 +0800
Message-ID: <20210928031440.2222303-3-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928031440.2222303-1-wanghai38@huawei.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When use-gss-proxy is set to 1, write_gssp() creates a rpc client in
gssp_rpc_create(), this increases the netns refcount by 2, these
refcounts are supposed to be released in rpcsec_gss_exit_net(), but it
will never happen because rpcsec_gss_exit_net() is triggered only when
the netns refcount gets to 0, specifically:
    refcount=0 -> cleanup_net() -> ops_exit_list -> rpcsec_gss_exit_net
It is a deadlock situation here, refcount will never get to 0 unless
rpcsec_gss_exit_net() is called. So, in this case, the netns refcount
should not be increased.

In this case, xprt will take a netns refcount which is not supposed
to be taken. Add a new flag to rpc_create_args called
RPC_CLNT_CREATE_NO_NET_REF for not increasing the netns refcount.

It is safe not to hold the netns refcount, because when cleanup_net(), it
will hold the gssp_lock and then shut down the rpc client synchronously.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 include/linux/sunrpc/clnt.h                |  1 +
 include/linux/sunrpc/xprt.h                |  6 ++++--
 net/sunrpc/auth_gss/gss_rpc_upcall.c       |  3 ++-
 net/sunrpc/clnt.c                          |  2 ++
 net/sunrpc/xprt.c                          | 13 +++++++++----
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |  2 +-
 net/sunrpc/xprtrdma/transport.c            |  2 +-
 net/sunrpc/xprtsock.c                      |  4 +++-
 8 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index a4661646adc9..6323518e7b1c 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -159,6 +159,7 @@ struct rpc_add_xprt_test {
 #define RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT	(1UL << 9)
 #define RPC_CLNT_CREATE_SOFTERR		(1UL << 10)
 #define RPC_CLNT_CREATE_REUSEPORT	(1UL << 11)
+#define RPC_CLNT_CREATE_NO_NET_REF	(1UL << 12)
 
 struct rpc_clnt *rpc_create(struct rpc_create_args *args);
 struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 955ea4d7af0b..cc518a58b93c 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -284,6 +284,7 @@ struct rpc_xprt {
 	} stat;
 
 	struct net		*xprt_net;
+	bool			xprt_net_refcnt;
 	const char		*servername;
 	const char		*address_strings[RPC_DISPLAY_MAX];
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
@@ -317,6 +318,7 @@ static inline int bc_prealloc(struct rpc_rqst *req)
 
 #define XPRT_CREATE_INFINITE_SLOTS	(1U)
 #define XPRT_CREATE_NO_IDLE_TIMEOUT	(1U << 1)
+#define XPRT_CREATE_NO_NET_REF		(1U << 2)
 
 struct xprt_create {
 	int			ident;		/* XPRT_TRANSPORT identifier */
@@ -370,8 +372,8 @@ void			xprt_release(struct rpc_task *task);
 struct rpc_xprt *	xprt_get(struct rpc_xprt *xprt);
 void			xprt_put(struct rpc_xprt *xprt);
 struct rpc_xprt *	xprt_alloc(struct net *net, size_t size,
-				unsigned int num_prealloc,
-				unsigned int max_req);
+				   unsigned int num_prealloc,
+				   unsigned int max_req, bool xprt_net_refcnt);
 void			xprt_free(struct rpc_xprt *);
 void			xprt_add_backlog(struct rpc_xprt *xprt, struct rpc_task *task);
 bool			xprt_wake_up_backlog(struct rpc_xprt *xprt, struct rpc_rqst *req);
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index 61c276bddaf2..8c35805470d5 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -98,7 +98,8 @@ static int gssp_rpc_create(struct net *net, struct rpc_clnt **_clnt)
 		 * done without the correct namespace:
 		 */
 		.flags		= RPC_CLNT_CREATE_NOPING |
-				  RPC_CLNT_CREATE_NO_IDLE_TIMEOUT
+				  RPC_CLNT_CREATE_NO_IDLE_TIMEOUT |
+				  RPC_CLNT_CREATE_NO_NET_REF
 	};
 	struct rpc_clnt *clnt;
 	int result = 0;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f056ff931444..672bebae50ca 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -543,6 +543,8 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *args)
 		xprtargs.flags |= XPRT_CREATE_INFINITE_SLOTS;
 	if (args->flags & RPC_CLNT_CREATE_NO_IDLE_TIMEOUT)
 		xprtargs.flags |= XPRT_CREATE_NO_IDLE_TIMEOUT;
+	if (args->flags & RPC_CLNT_CREATE_NO_NET_REF)
+		xprtargs.flags |= XPRT_CREATE_NO_NET_REF;
 	/*
 	 * If the caller chooses not to specify a hostname, whip
 	 * up a string representation of the passed-in address.
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index cfd681700d1a..ffa6de06f21b 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1794,8 +1794,8 @@ static void xprt_free_id(struct rpc_xprt *xprt)
 }
 
 struct rpc_xprt *xprt_alloc(struct net *net, size_t size,
-		unsigned int num_prealloc,
-		unsigned int max_alloc)
+			    unsigned int num_prealloc,
+			    unsigned int max_alloc, bool xprt_net_refcnt)
 {
 	struct rpc_xprt *xprt;
 	struct rpc_rqst *req;
@@ -1806,6 +1806,7 @@ struct rpc_xprt *xprt_alloc(struct net *net, size_t size,
 		goto out;
 
 	xprt_alloc_id(xprt);
+	xprt->xprt_net_refcnt = xprt_net_refcnt;
 	xprt_init(xprt, net);
 
 	for (i = 0; i < num_prealloc; i++) {
@@ -1832,7 +1833,8 @@ EXPORT_SYMBOL_GPL(xprt_alloc);
 
 void xprt_free(struct rpc_xprt *xprt)
 {
-	put_net(xprt->xprt_net);
+	if (xprt->xprt_net_refcnt)
+		put_net(xprt->xprt_net);
 	xprt_free_all_slots(xprt);
 	xprt_free_id(xprt);
 	rpc_sysfs_xprt_destroy(xprt);
@@ -2024,7 +2026,10 @@ static void xprt_init(struct rpc_xprt *xprt, struct net *net)
 
 	xprt_init_xid(xprt);
 
-	xprt->xprt_net = get_net(net);
+	if (xprt->xprt_net_refcnt)
+		xprt->xprt_net = get_net(net);
+	else
+		xprt->xprt_net = net;
 }
 
 /**
diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 16897fcb659c..8cd7a38da0f0 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -251,7 +251,7 @@ xprt_setup_rdma_bc(struct xprt_create *args)
 
 	xprt = xprt_alloc(args->net, sizeof(*new_xprt),
 			  RPCRDMA_MAX_BC_REQUESTS,
-			  RPCRDMA_MAX_BC_REQUESTS);
+			  RPCRDMA_MAX_BC_REQUESTS, true);
 	if (!xprt)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 16e5696314a4..f0f7faa571f6 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -323,7 +323,7 @@ xprt_setup_rdma(struct xprt_create *args)
 		return ERR_PTR(-EIO);
 
 	xprt = xprt_alloc(args->net, sizeof(struct rpcrdma_xprt), 0,
-			  xprt_rdma_slot_table_entries);
+			  xprt_rdma_slot_table_entries, true);
 	if (!xprt) {
 		module_put(THIS_MODULE);
 		return ERR_PTR(-ENOMEM);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 04f1b78bcbca..b6c15159992a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2740,6 +2740,8 @@ static struct rpc_xprt *xs_setup_xprt(struct xprt_create *args,
 {
 	struct rpc_xprt *xprt;
 	struct sock_xprt *new;
+	bool xprt_net_refcnt = args->flags & XPRT_CREATE_NO_NET_REF ?
+			       false : true;
 
 	if (args->addrlen > sizeof(xprt->addr)) {
 		dprintk("RPC:       xs_setup_xprt: address too large\n");
@@ -2747,7 +2749,7 @@ static struct rpc_xprt *xs_setup_xprt(struct xprt_create *args,
 	}
 
 	xprt = xprt_alloc(args->net, sizeof(*new), slot_table_size,
-			max_slot_table_size);
+			  max_slot_table_size, xprt_net_refcnt);
 	if (xprt == NULL) {
 		dprintk("RPC:       xs_setup_xprt: couldn't allocate "
 				"rpc_xprt\n");
-- 
2.17.1

