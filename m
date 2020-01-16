Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D6A13E122
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgAPQrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgAPQrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FDC2073A;
        Thu, 16 Jan 2020 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193264;
        bh=ugGLZAyuBztsE+iP3TQYDWRJdx2B6sTtqmL2u4iVhEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+sGKdftQ5d9PKgLd87pCNC95XpT41oojmlZsoc0xzCyA6WC1qzxpJewYh/RsRnNT
         w/OcXZ5uevq5Pk/3BaVBYPtTMicVVeeHIpPTQr6zwG66pTqMdEI5AYT1TpEJcPushP
         Xb/zGbrljPTy8PIAXIuGe7mwM+r5YC6PwB6dn/gc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.4 059/205] xprtrdma: Fix MR list handling
Date:   Thu, 16 Jan 2020 11:40:34 -0500
Message-Id: <20200116164300.6705-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c3700780a096fc66467c81076ddf7f3f11d639b5 ]

Close some holes introduced by commit 6dc6ec9e04c4 ("xprtrdma: Cache
free MRs in each rpcrdma_req") that could result in list corruption.

In addition, the result that is tabulated in @count is no longer
used, so @count is removed.

Fixes: 6dc6ec9e04c4 ("xprtrdma: Cache free MRs in each rpcrdma_req")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 41 +++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index f4b136504e96..be74ff8f7873 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -79,7 +79,6 @@ static void rpcrdma_reqs_reset(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_reps_destroy(struct rpcrdma_buffer *buf);
 static void rpcrdma_mrs_create(struct rpcrdma_xprt *r_xprt);
 static void rpcrdma_mrs_destroy(struct rpcrdma_buffer *buf);
-static void rpcrdma_mr_free(struct rpcrdma_mr *mr);
 static struct rpcrdma_regbuf *
 rpcrdma_regbuf_alloc(size_t size, enum dma_data_direction direction,
 		     gfp_t flags);
@@ -967,7 +966,7 @@ rpcrdma_mrs_create(struct rpcrdma_xprt *r_xprt)
 		mr->mr_xprt = r_xprt;
 
 		spin_lock(&buf->rb_lock);
-		list_add(&mr->mr_list, &buf->rb_mrs);
+		rpcrdma_mr_push(mr, &buf->rb_mrs);
 		list_add(&mr->mr_all, &buf->rb_all_mrs);
 		spin_unlock(&buf->rb_lock);
 	}
@@ -1185,10 +1184,19 @@ int rpcrdma_buffer_create(struct rpcrdma_xprt *r_xprt)
  */
 void rpcrdma_req_destroy(struct rpcrdma_req *req)
 {
+	struct rpcrdma_mr *mr;
+
 	list_del(&req->rl_all);
 
-	while (!list_empty(&req->rl_free_mrs))
-		rpcrdma_mr_free(rpcrdma_mr_pop(&req->rl_free_mrs));
+	while ((mr = rpcrdma_mr_pop(&req->rl_free_mrs))) {
+		struct rpcrdma_buffer *buf = &mr->mr_xprt->rx_buf;
+
+		spin_lock(&buf->rb_lock);
+		list_del(&mr->mr_all);
+		spin_unlock(&buf->rb_lock);
+
+		frwr_release_mr(mr);
+	}
 
 	rpcrdma_regbuf_free(req->rl_recvbuf);
 	rpcrdma_regbuf_free(req->rl_sendbuf);
@@ -1196,24 +1204,28 @@ void rpcrdma_req_destroy(struct rpcrdma_req *req)
 	kfree(req);
 }
 
-static void
-rpcrdma_mrs_destroy(struct rpcrdma_buffer *buf)
+/**
+ * rpcrdma_mrs_destroy - Release all of a transport's MRs
+ * @buf: controlling buffer instance
+ *
+ * Relies on caller holding the transport send lock to protect
+ * removing mr->mr_list from req->rl_free_mrs safely.
+ */
+static void rpcrdma_mrs_destroy(struct rpcrdma_buffer *buf)
 {
 	struct rpcrdma_xprt *r_xprt = container_of(buf, struct rpcrdma_xprt,
 						   rx_buf);
 	struct rpcrdma_mr *mr;
-	unsigned int count;
 
-	count = 0;
 	spin_lock(&buf->rb_lock);
 	while ((mr = list_first_entry_or_null(&buf->rb_all_mrs,
 					      struct rpcrdma_mr,
 					      mr_all)) != NULL) {
+		list_del(&mr->mr_list);
 		list_del(&mr->mr_all);
 		spin_unlock(&buf->rb_lock);
 
 		frwr_release_mr(mr);
-		count++;
 		spin_lock(&buf->rb_lock);
 	}
 	spin_unlock(&buf->rb_lock);
@@ -1286,17 +1298,6 @@ void rpcrdma_mr_put(struct rpcrdma_mr *mr)
 	rpcrdma_mr_push(mr, &mr->mr_req->rl_free_mrs);
 }
 
-static void rpcrdma_mr_free(struct rpcrdma_mr *mr)
-{
-	struct rpcrdma_xprt *r_xprt = mr->mr_xprt;
-	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
-
-	mr->mr_req = NULL;
-	spin_lock(&buf->rb_lock);
-	rpcrdma_mr_push(mr, &buf->rb_mrs);
-	spin_unlock(&buf->rb_lock);
-}
-
 /**
  * rpcrdma_buffer_get - Get a request buffer
  * @buffers: Buffer pool from which to obtain a buffer
-- 
2.20.1

