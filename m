Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190FF13E220
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgAPQx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbgAPQxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2582B20730;
        Thu, 16 Jan 2020 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193631;
        bh=19TCApyzeI5gckDjDb4HTF7aK+u8SwosNrm+rbWBpAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yakG4LfpXoD7mrVWbX/KNzYsCygwfsP/VXuH4oDY6WF5uAcbBlaL1kHfQB950GDOC
         LoZgtzB14K9fJ3HnzDZt4tK9GTxx6DlVDD+XmXKmslHl4cIYPwz1o6sWH85rD3yTgx
         5WEv8YF2Y9niDdGLywG9TdBdq8wqGCkB+kklf0wM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 165/205] SUNRPC: Fix backchannel latency metrics
Date:   Thu, 16 Jan 2020 11:42:20 -0500
Message-Id: <20200116164300.6705-165-sashal@kernel.org>
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

[ Upstream commit 8729aaba74626c4ebce3abf1b9e96bb62d2958ca ]

I noticed that for callback requests, the reported backlog latency
is always zero, and the rtt value is crazy big. The problem was that
rqst->rq_xtime is never set for backchannel requests.

Fixes: 78215759e20d ("SUNRPC: Make RTT measurement more ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c | 1 +
 net/sunrpc/xprtsock.c                      | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index d1fcc41d5eb5..908e78bb87c6 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -195,6 +195,7 @@ rpcrdma_bc_send_request(struct svcxprt_rdma *rdma, struct rpc_rqst *rqst)
 	pr_info("%s: %*ph\n", __func__, 64, rqst->rq_buffer);
 #endif
 
+	rqst->rq_xtime = ktime_get();
 	rc = svc_rdma_bc_sendto(rdma, rqst, ctxt);
 	if (rc) {
 		svc_rdma_send_ctxt_put(rdma, ctxt);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 70e52f567b2a..5361b98f31ae 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2659,6 +2659,8 @@ static int bc_sendto(struct rpc_rqst *req)
 		.iov_len	= sizeof(marker),
 	};
 
+	req->rq_xtime = ktime_get();
+
 	len = kernel_sendmsg(transport->sock, &msg, &iov, 1, iov.iov_len);
 	if (len != iov.iov_len)
 		return -EAGAIN;
@@ -2684,7 +2686,6 @@ static int bc_send_request(struct rpc_rqst *req)
 	struct svc_xprt	*xprt;
 	int len;
 
-	dprintk("sending request with xid: %08x\n", ntohl(req->rq_xid));
 	/*
 	 * Get the server socket associated with this callback xprt
 	 */
-- 
2.20.1

