Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A682C3D46
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbfJAQlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731081AbfJAQle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A22B205C9;
        Tue,  1 Oct 2019 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948093;
        bh=sKBF4xUU1taMr94G4Nliz9kPsX8hP2tQ7LlSgY+UwAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7e8UVi8erCHhfuBEz/R5Zi4pjMOomVdn1VtRpFXON2SKXtQmwH6Y1flDbjwMDEU+
         9+JfzWrEWRz0uauyHBe7tXYAjIQmhbartw3tJ2/1GjAmV8vmebMpVmT1nt3dBdMf7g
         7VC+0V+9KBLUei9tuEQnHUS4tITDgm+ZmnrvkIL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Eli Dorfman <eli@vastdata.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 05/63] xprtrdma: Send Queue size grows after a reconnect
Date:   Tue,  1 Oct 2019 12:40:27 -0400
Message-Id: <20191001164125.15398-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 98ef77d1aaa7a2f4e1b2a721faa084222021fda7 ]

Eli Dorfman reports that after a series of idle disconnects, an
RPC/RDMA transport becomes unusable (rdma_create_qp returns
-ENOMEM). Problem was tracked down to increasing Send Queue size
after each reconnect.

The rdma_create_qp() API does not promise to leave its @qp_init_attr
parameter unaltered. In fact, some drivers do modify one or more of
its fields. Thus our calls to rdma_create_qp must use a fresh copy
of ib_qp_init_attr each time.

This fix is appropriate for kernels dating back to late 2007, though
it will have to be adapted, as the connect code has changed over the
years.

Reported-by: Eli Dorfman <eli@vastdata.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 84bb379245406..3f67c395845df 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -607,10 +607,10 @@ void rpcrdma_ep_destroy(struct rpcrdma_xprt *r_xprt)
  * Unlike a normal reconnection, a fresh PD and a new set
  * of MRs and buffers is needed.
  */
-static int
-rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
-			 struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
+static int rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
+				    struct ib_qp_init_attr *qp_init_attr)
 {
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	int rc, err;
 
 	trace_xprtrdma_reinsert(r_xprt);
@@ -627,7 +627,7 @@ rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
 	}
 
 	rc = -ENETUNREACH;
-	err = rdma_create_qp(ia->ri_id, ia->ri_pd, &ep->rep_attr);
+	err = rdma_create_qp(ia->ri_id, ia->ri_pd, qp_init_attr);
 	if (err) {
 		pr_err("rpcrdma: rdma_create_qp returned %d\n", err);
 		goto out3;
@@ -644,16 +644,16 @@ rpcrdma_ep_recreate_xprt(struct rpcrdma_xprt *r_xprt,
 	return rc;
 }
 
-static int
-rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt, struct rpcrdma_ep *ep,
-		     struct rpcrdma_ia *ia)
+static int rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt,
+				struct ib_qp_init_attr *qp_init_attr)
 {
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	struct rdma_cm_id *id, *old;
 	int err, rc;
 
 	trace_xprtrdma_reconnect(r_xprt);
 
-	rpcrdma_ep_disconnect(ep, ia);
+	rpcrdma_ep_disconnect(&r_xprt->rx_ep, ia);
 
 	rc = -EHOSTUNREACH;
 	id = rpcrdma_create_id(r_xprt, ia);
@@ -675,7 +675,7 @@ rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt, struct rpcrdma_ep *ep,
 		goto out_destroy;
 	}
 
-	err = rdma_create_qp(id, ia->ri_pd, &ep->rep_attr);
+	err = rdma_create_qp(id, ia->ri_pd, qp_init_attr);
 	if (err)
 		goto out_destroy;
 
@@ -700,25 +700,27 @@ rpcrdma_ep_connect(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia)
 	struct rpcrdma_xprt *r_xprt = container_of(ia, struct rpcrdma_xprt,
 						   rx_ia);
 	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
+	struct ib_qp_init_attr qp_init_attr;
 	int rc;
 
 retry:
+	memcpy(&qp_init_attr, &ep->rep_attr, sizeof(qp_init_attr));
 	switch (ep->rep_connected) {
 	case 0:
 		dprintk("RPC:       %s: connecting...\n", __func__);
-		rc = rdma_create_qp(ia->ri_id, ia->ri_pd, &ep->rep_attr);
+		rc = rdma_create_qp(ia->ri_id, ia->ri_pd, &qp_init_attr);
 		if (rc) {
 			rc = -ENETUNREACH;
 			goto out_noupdate;
 		}
 		break;
 	case -ENODEV:
-		rc = rpcrdma_ep_recreate_xprt(r_xprt, ep, ia);
+		rc = rpcrdma_ep_recreate_xprt(r_xprt, &qp_init_attr);
 		if (rc)
 			goto out_noupdate;
 		break;
 	default:
-		rc = rpcrdma_ep_reconnect(r_xprt, ep, ia);
+		rc = rpcrdma_ep_reconnect(r_xprt, &qp_init_attr);
 		if (rc)
 			goto out;
 	}
-- 
2.20.1

