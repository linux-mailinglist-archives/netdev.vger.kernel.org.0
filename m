Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3BB26F23A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgIRC5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727808AbgIRCGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E51792395C;
        Fri, 18 Sep 2020 02:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394802;
        bh=jlTAbGS5MsUREKDb7jp+tpjOT/onXdgqdGPSDFE+tqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzPpreagCB5UkAN5YeUU4Ngwl5B9k33SUB33VQf44TVMEq6taEX/ftPwWLyBxlYZF
         wsj5mZrljEtUKpm2LNKY3hdSTurxCPVXNMa4ZOUnHa/ta34xSJmmhpyxjid+dQVvYB
         6o3qP4a51cXm/6/0jwZqmP/bTtsjoEVBYnOvMGXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 271/330] svcrdma: Fix backchannel return code
Date:   Thu, 17 Sep 2020 22:00:11 -0400
Message-Id: <20200918020110.2063155-271-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ea740bd5f58e2912e74f401fd01a9d6aa985ca05 ]

Way back when I was writing the RPC/RDMA server-side backchannel
code, I misread the TCP backchannel reply handler logic. When
svc_tcp_recvfrom() successfully receives a backchannel reply, it
does not return -EAGAIN. It sets XPT_DATA and returns zero.

Update svc_rdma_recvfrom() to return zero. Here, XPT_DATA doesn't
need to be set again: it is set whenever a new message is received,
behind a spin lock in a single threaded context.

Also, if handling the cb reply is not successful, the message is
simply dropped. There's no special message framing to deal with as
there is in the TCP case.

Now that the handle_bc_reply() return value is ignored, I've removed
the dprintk call sites in the error exit of handle_bc_reply() in
favor of trace points in other areas that already report the error
cases.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_rdma.h            |  5 ++-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c | 38 ++++++----------------
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    | 11 +++----
 3 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 26f282e5e0822..77589ed787f5c 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -154,9 +154,8 @@ struct svc_rdma_send_ctxt {
 };
 
 /* svc_rdma_backchannel.c */
-extern int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt,
-				    __be32 *rdma_resp,
-				    struct xdr_buf *rcvbuf);
+extern void svc_rdma_handle_bc_reply(struct svc_rqst *rqstp,
+				     struct svc_rdma_recv_ctxt *rctxt);
 
 /* svc_rdma_recvfrom.c */
 extern void svc_rdma_recv_ctxts_destroy(struct svcxprt_rdma *rdma);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 325eef1f85824..68d2dcf0a1be1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -15,26 +15,25 @@
 #undef SVCRDMA_BACKCHANNEL_DEBUG
 
 /**
- * svc_rdma_handle_bc_reply - Process incoming backchannel reply
- * @xprt: controlling backchannel transport
- * @rdma_resp: pointer to incoming transport header
- * @rcvbuf: XDR buffer into which to decode the reply
+ * svc_rdma_handle_bc_reply - Process incoming backchannel Reply
+ * @rqstp: resources for handling the Reply
+ * @rctxt: Received message
  *
- * Returns:
- *	%0 if @rcvbuf is filled in, xprt_complete_rqst called,
- *	%-EAGAIN if server should call ->recvfrom again.
  */
-int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, __be32 *rdma_resp,
-			     struct xdr_buf *rcvbuf)
+void svc_rdma_handle_bc_reply(struct svc_rqst *rqstp,
+			      struct svc_rdma_recv_ctxt *rctxt)
 {
+	struct svc_xprt *sxprt = rqstp->rq_xprt;
+	struct rpc_xprt *xprt = sxprt->xpt_bc_xprt;
 	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(xprt);
+	struct xdr_buf *rcvbuf = &rqstp->rq_arg;
 	struct kvec *dst, *src = &rcvbuf->head[0];
+	__be32 *rdma_resp = rctxt->rc_recv_buf;
 	struct rpc_rqst *req;
 	u32 credits;
 	size_t len;
 	__be32 xid;
 	__be32 *p;
-	int ret;
 
 	p = (__be32 *)src->iov_base;
 	len = src->iov_len;
@@ -49,14 +48,10 @@ int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, __be32 *rdma_resp,
 		__func__, (int)len, p);
 #endif
 
-	ret = -EAGAIN;
-	if (src->iov_len < 24)
-		goto out_shortreply;
-
 	spin_lock(&xprt->queue_lock);
 	req = xprt_lookup_rqst(xprt, xid);
 	if (!req)
-		goto out_notfound;
+		goto out_unlock;
 
 	dst = &req->rq_private_buf.head[0];
 	memcpy(&req->rq_private_buf, &req->rq_rcv_buf, sizeof(struct xdr_buf));
@@ -77,25 +72,12 @@ int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, __be32 *rdma_resp,
 	spin_unlock(&xprt->transport_lock);
 
 	spin_lock(&xprt->queue_lock);
-	ret = 0;
 	xprt_complete_rqst(req->rq_task, rcvbuf->len);
 	xprt_unpin_rqst(req);
 	rcvbuf->len = 0;
 
 out_unlock:
 	spin_unlock(&xprt->queue_lock);
-out:
-	return ret;
-
-out_shortreply:
-	dprintk("svcrdma: short bc reply: xprt=%p, len=%zu\n",
-		xprt, src->iov_len);
-	goto out;
-
-out_notfound:
-	dprintk("svcrdma: unrecognized bc reply: xprt=%p, xid=%08x\n",
-		xprt, be32_to_cpu(xid));
-	goto out_unlock;
 }
 
 /* Send a backwards direction RPC call.
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index d803d814a03ad..fd5c1f1bb9885 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -817,12 +817,9 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		goto out_drop;
 	rqstp->rq_xprt_hlen = ret;
 
-	if (svc_rdma_is_backchannel_reply(xprt, p)) {
-		ret = svc_rdma_handle_bc_reply(xprt->xpt_bc_xprt, p,
-					       &rqstp->rq_arg);
-		svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
-		return ret;
-	}
+	if (svc_rdma_is_backchannel_reply(xprt, p))
+		goto out_backchannel;
+
 	svc_rdma_get_inv_rkey(rdma_xprt, ctxt);
 
 	p += rpcrdma_fixed_maxsz;
@@ -852,6 +849,8 @@ out_postfail:
 	svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
 	return ret;
 
+out_backchannel:
+	svc_rdma_handle_bc_reply(rqstp, ctxt);
 out_drop:
 	svc_rdma_recv_ctxt_put(rdma_xprt, ctxt);
 	return 0;
-- 
2.25.1

