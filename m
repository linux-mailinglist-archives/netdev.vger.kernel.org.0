Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD23F1060D2
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfKVFwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:52:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbfKVFwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0CC20840;
        Fri, 22 Nov 2019 05:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401933;
        bh=ZJ8gpXQBhU0zBIqGfk5Yz47S/EoXgQRH3InZOl3iSCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2//HfNDYqFq6F0GtGfl0Z90FcwwwEBXA51zs/haC3jUp+moASvIJvY+5mfywPiWa
         MDKF2e7g1iCMb8zvdqGAqK1tMR5ybvTcxu6IRE+0m49cesRtDo7mgMTJoKPcvO6iV4
         kOShzVfQu8XXDK/pUqqIl/P2CB2MDqs0bUjKzLGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 159/219] xprtrdma: Prevent leak of rpcrdma_rep objects
Date:   Fri, 22 Nov 2019 00:48:11 -0500
Message-Id: <20191122054911.1750-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 07e10308ee5da8e6132e0b737ece1c99dd651fb6 ]

If a reply has been processed but the RPC is later retransmitted
anyway, the req->rl_reply field still contains the only pointer to
the old rpcrdma rep. When the next reply comes in, the reply handler
will stomp on the rl_reply field, leaking the old rep.

A trace event is added to capture such leaks.

This problem seems to be worsened by the restructuring of the RPC
Call path in v4.20. Fully addressing this issue will require at
least a re-architecture of the disconnect logic, which is not
appropriate during -rc.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rpcrdma.h | 28 ++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/rpc_rdma.c |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index 53df203b8057a..4c91cadd1871d 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -917,6 +917,34 @@ TRACE_EVENT(xprtrdma_cb_setup,
 DEFINE_CB_EVENT(xprtrdma_cb_call);
 DEFINE_CB_EVENT(xprtrdma_cb_reply);
 
+TRACE_EVENT(xprtrdma_leaked_rep,
+	TP_PROTO(
+		const struct rpc_rqst *rqst,
+		const struct rpcrdma_rep *rep
+	),
+
+	TP_ARGS(rqst, rep),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, task_id)
+		__field(unsigned int, client_id)
+		__field(u32, xid)
+		__field(const void *, rep)
+	),
+
+	TP_fast_assign(
+		__entry->task_id = rqst->rq_task->tk_pid;
+		__entry->client_id = rqst->rq_task->tk_client->cl_clid;
+		__entry->xid = be32_to_cpu(rqst->rq_xid);
+		__entry->rep = rep;
+	),
+
+	TP_printk("task:%u@%u xid=0x%08x rep=%p",
+		__entry->task_id, __entry->client_id, __entry->xid,
+		__entry->rep
+	)
+);
+
 /**
  ** Server-side RPC/RDMA events
  **/
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index c8ae983c6cc01..f2eaf264726be 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1360,6 +1360,10 @@ void rpcrdma_reply_handler(struct rpcrdma_rep *rep)
 	spin_unlock(&xprt->recv_lock);
 
 	req = rpcr_to_rdmar(rqst);
+	if (req->rl_reply) {
+		trace_xprtrdma_leaked_rep(rqst, req->rl_reply);
+		rpcrdma_recv_buffer_put(req->rl_reply);
+	}
 	req->rl_reply = rep;
 	rep->rr_rqst = rqst;
 	clear_bit(RPCRDMA_REQ_F_PENDING, &req->rl_flags);
-- 
2.20.1

