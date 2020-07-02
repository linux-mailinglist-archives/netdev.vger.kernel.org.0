Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC688211972
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgGBBfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgGBBXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE24020874;
        Thu,  2 Jul 2020 01:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653012;
        bh=MZ2iJx/qJnONWSY1ZZ0fE/jzrPllTcmAvUkRUH8FEx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEb5egsCCNEVlhrBY/2PVK9ic23hCOpIvOMLpDuTtvWffjPS/9uRUAMzD+BNZMzUD
         WULcoy3Ge7ze7JZrR1PJOCAcIMT7HnFGHzzh2nOJkhdrNTlMlXwINd/PzL5xtxM97z
         iH6cp95DujtxK7UI8o6AkA9P2xqVGyqEcApP1bNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 30/53] xprtrdma: Prevent dereferencing r_xprt->rx_ep after it is freed
Date:   Wed,  1 Jul 2020 21:21:39 -0400
Message-Id: <20200702012202.2700645-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2acc5cae292355f5f18ad377a2a966e7f03c8fec ]

r_xprt->rx_ep is known to be good while the transport's send lock is
held.  Otherwise additional references on rx_ep must be held when it
is used outside of that lock's critical sections.

For now, bump the rx_ep reference count once whenever there is at
least one outstanding Receive WR. This avoids the memory bandwidth
overhead of taking and releasing the reference count for every
ib_post_recv() and Receive completion.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 05c4d3a9cda27..db0259c6467ef 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -84,7 +84,8 @@ static void rpcrdma_rep_destroy(struct rpcrdma_rep *rep);
 static void rpcrdma_reps_unmap(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_mrs_create(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_mrs_destroy(struct rpcrdma_xprt *r_xprt);
-static int rpcrdma_ep_destroy(struct rpcrdma_ep *ep);
+static void rpcrdma_ep_get(struct rpcrdma_ep *ep);
+static int rpcrdma_ep_put(struct rpcrdma_ep *ep);
 static struct rpcrdma_regbuf *
 rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction,
 		     gfp_t flags);
@@ -97,7 +98,8 @@ static void rpcrdma_regbuf_free(struct rpcrdma_regbuf *rb);
  */
 static void rpcrdma_xprt_drain(struct rpcrdma_xprt *r_xprt)
 {
-	struct rdma_cm_id *id = r_xprt->rx_ep->re_id;
+	struct rpcrdma_ep *ep = r_xprt->rx_ep;
+	struct rdma_cm_id *id = ep->re_id;
 
 	/* Flush Receives, then wait for deferred Reply work
 	 * to complete.
@@ -108,6 +110,8 @@ static void rpcrdma_xprt_drain(struct rpcrdma_xprt *r_xprt)
 	 * local invalidations.
 	 */
 	ib_drain_sq(id->qp);
+
+	rpcrdma_ep_put(ep);
 }
 
 /**
@@ -267,7 +271,7 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		xprt_force_disconnect(xprt);
 		goto disconnected;
 	case RDMA_CM_EVENT_ESTABLISHED:
-		kref_get(&ep->re_kref);
+		rpcrdma_ep_get(ep);
 		ep->re_connect_status = 1;
 		rpcrdma_update_cm_private(ep, &event->param.conn);
 		trace_xprtrdma_inline_thresh(ep);
@@ -290,7 +294,7 @@ rpcrdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		ep->re_connect_status = -ECONNABORTED;
 disconnected:
 		xprt_force_disconnect(xprt);
-		return rpcrdma_ep_destroy(ep);
+		return rpcrdma_ep_put(ep);
 	default:
 		break;
 	}
@@ -346,7 +350,7 @@ static struct rdma_cm_id *rpcrdma_create_id(struct rpcrdma_xprt *r_xprt,
 	return ERR_PTR(rc);
 }
 
-static void rpcrdma_ep_put(struct kref *kref)
+static void rpcrdma_ep_destroy(struct kref *kref)
 {
 	struct rpcrdma_ep *ep = container_of(kref, struct rpcrdma_ep, re_kref);
 
@@ -370,13 +374,18 @@ static void rpcrdma_ep_put(struct kref *kref)
 	module_put(THIS_MODULE);
 }
 
+static noinline void rpcrdma_ep_get(struct rpcrdma_ep *ep)
+{
+	kref_get(&ep->re_kref);
+}
+
 /* Returns:
  *     %0 if @ep still has a positive kref count, or
  *     %1 if @ep was destroyed successfully.
  */
-static int rpcrdma_ep_destroy(struct rpcrdma_ep *ep)
+static noinline int rpcrdma_ep_put(struct rpcrdma_ep *ep)
 {
-	return kref_put(&ep->re_kref, rpcrdma_ep_put);
+	return kref_put(&ep->re_kref, rpcrdma_ep_destroy);
 }
 
 static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
@@ -493,7 +502,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	return 0;
 
 out_destroy:
-	rpcrdma_ep_destroy(ep);
+	rpcrdma_ep_put(ep);
 	rdma_destroy_id(id);
 out_free:
 	kfree(ep);
@@ -522,8 +531,12 @@ int rpcrdma_xprt_connect(struct rpcrdma_xprt *r_xprt)
 
 	ep->re_connect_status = 0;
 	xprt_clear_connected(xprt);
-
 	rpcrdma_reset_cwnd(r_xprt);
+
+	/* Bump the ep's reference count while there are
+	 * outstanding Receives.
+	 */
+	rpcrdma_ep_get(ep);
 	rpcrdma_post_recvs(r_xprt, true);
 
 	rc = rpcrdma_sendctxs_create(r_xprt);
@@ -588,7 +601,7 @@ void rpcrdma_xprt_disconnect(struct rpcrdma_xprt *r_xprt)
 	rpcrdma_mrs_destroy(r_xprt);
 	rpcrdma_sendctxs_destroy(r_xprt);
 
-	if (rpcrdma_ep_destroy(ep))
+	if (rpcrdma_ep_put(ep))
 		rdma_destroy_id(id);
 
 	r_xprt->rx_ep = NULL;
-- 
2.25.1

