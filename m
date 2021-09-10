Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E263C406248
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 02:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhIJApO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 20:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhIJASG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EBFC611C1;
        Fri, 10 Sep 2021 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233009;
        bh=gwRwG4G4N8PGqxgHm684roFXH4gnD9B5AOdGvL2KIko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8/3PmeqlFM9eIyf3fy2QcKKkRdDAUO80tj7OfcKXfDBML2Kb+2NKTK1/4ryCauNV
         PKqmZoLEYYthivHDqtnSaBNTXHUE2DAsqeLJojLjD2vc7NFuRW57LBQSn6GSLfUeFR
         eBwjKN8ZB1LAUwUTf0jX5CWjHlkM4Ovj2vPxO7fEVOXtFM1jBU22PIDesq184s0nXZ
         8Ykda7ZfxzZC1HSJS/ZdzhwsVMrtrhG1QxnUmH2/NnPA/m/PFxf2Mwk4doMkmPqME2
         NVeRrffFYvi80uk5puTevRQedg8ooLmq2sck2xqgOfJe4AjIfNsaCpbnBlIcv6BF52
         bC/Xz6+7md+DA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 36/99] xprtrdma: Disconnect after an ib_post_send() immediate error
Date:   Thu,  9 Sep 2021 20:14:55 -0400
Message-Id: <20210910001558.173296-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1143129e4d0d27740ce680d2fb0161ad4f27aa7e ]

ib_post_send() does not disconnect the QP when it returns an
immediate error. Thus, the code that posts LocalInv has to
explicitly disconnect after an immediate error. This is just
like the frwr_send() callers handle it.

If a disconnect isn't done here, the transport deadlocks.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c  | 8 ++++++++
 net/sunrpc/xprtrdma/verbs.c     | 2 +-
 net/sunrpc/xprtrdma/xprt_rdma.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 229fcc9a9064..754c5dffe127 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -557,6 +557,10 @@ void frwr_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 
 	/* On error, the MRs get destroyed once the QP has drained. */
 	trace_xprtrdma_post_linv_err(req, rc);
+
+	/* Force a connection loss to ensure complete recovery.
+	 */
+	rpcrdma_force_disconnect(ep);
 }
 
 /**
@@ -653,4 +657,8 @@ void frwr_unmap_async(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 	 * retransmission.
 	 */
 	rpcrdma_unpin_rqst(req->rl_reply);
+
+	/* Force a connection loss to ensure complete recovery.
+	 */
+	rpcrdma_force_disconnect(ep);
 }
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 649c23518ec0..c1797ea19418 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -124,7 +124,7 @@ static void rpcrdma_xprt_drain(struct rpcrdma_xprt *r_xprt)
  * connection is closed or lost. (The important thing is it needs
  * to be invoked "at least" once).
  */
-static void rpcrdma_force_disconnect(struct rpcrdma_ep *ep)
+void rpcrdma_force_disconnect(struct rpcrdma_ep *ep)
 {
 	if (atomic_add_unless(&ep->re_force_disconnect, 1, 1))
 		xprt_force_disconnect(ep->re_xprt);
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 5d231d94e944..927e20a2c04e 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -454,6 +454,7 @@ extern unsigned int xprt_rdma_memreg_strategy;
 /*
  * Endpoint calls - xprtrdma/verbs.c
  */
+void rpcrdma_force_disconnect(struct rpcrdma_ep *ep);
 void rpcrdma_flush_disconnect(struct rpcrdma_xprt *r_xprt, struct ib_wc *wc);
 int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt);
 void rpcrdma_xprt_disconnect(struct rpcrdma_xprt *r_xprt);
-- 
2.30.2

