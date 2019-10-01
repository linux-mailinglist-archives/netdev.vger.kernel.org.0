Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF763C3D13
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbfJAQl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731479AbfJAQlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EE9A21855;
        Tue,  1 Oct 2019 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948115;
        bh=MyDQQmHBYpxiok5wMLlt4ZWNdBVl66/vrF4hYu3W/oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpWBbWTqZu3Y49V/x2lluLsOUn89LaqC6tV7XcUIwS4594dNHExd0KV2ngdASCxJs
         r8wfwGCWZEriS7Ijh/sHTIZJQmXwWq0dG9yOkgO1H2KOg2DkoChMbZLym4QPiNTi7+
         ByDdYPmQqQ4D/dK4yID6e5XmNSS3mXSdCybxwEMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 21/63] SUNRPC: Don't try to parse incomplete RPC messages
Date:   Tue,  1 Oct 2019 12:40:43 -0400
Message-Id: <20191001164125.15398-21-sashal@kernel.org>
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

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 9ba828861c56a21d211d5d10f5643774b1ea330d ]

If the copy of the RPC reply into our buffers did not complete, and
we could end up with a truncated message. In that case, just resend
the call.

Fixes: a0584ee9aed80 ("SUNRPC: Use struct xdr_stream when decoding...")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 8f32f73614111..866b60313fb12 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2398,6 +2398,7 @@ call_decode(struct rpc_task *task)
 	struct rpc_clnt	*clnt = task->tk_client;
 	struct rpc_rqst	*req = task->tk_rqstp;
 	struct xdr_stream xdr;
+	int err;
 
 	dprint_status(task);
 
@@ -2420,6 +2421,15 @@ call_decode(struct rpc_task *task)
 	 * before it changed req->rq_reply_bytes_recvd.
 	 */
 	smp_rmb();
+
+	/*
+	 * Did we ever call xprt_complete_rqst()? If not, we should assume
+	 * the message is incomplete.
+	 */
+	err = -EAGAIN;
+	if (!req->rq_reply_bytes_recvd)
+		goto out;
+
 	req->rq_rcv_buf.len = req->rq_private_buf.len;
 
 	/* Check that the softirq receive buffer is valid */
@@ -2428,7 +2438,9 @@ call_decode(struct rpc_task *task)
 
 	xdr_init_decode(&xdr, &req->rq_rcv_buf,
 			req->rq_rcv_buf.head[0].iov_base, req);
-	switch (rpc_decode_header(task, &xdr)) {
+	err = rpc_decode_header(task, &xdr);
+out:
+	switch (err) {
 	case 0:
 		task->tk_action = rpc_exit_task;
 		task->tk_status = rpcauth_unwrap_resp(task, &xdr);
-- 
2.20.1

