Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7DC3D26
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfJAQlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731294AbfJAQlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C94C2168B;
        Tue,  1 Oct 2019 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948104;
        bh=HB5pc3swrauJmegZZvrtgZE1nd70LmkXU0RIyYHGTLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jq7WnIwqnvI6Scjb+6/bDI9vxvCopOYV0NyXGx5ajGRA/wQfR6k6trjvcm9g8Or6A
         Ez63x2gJGj0tx0R6Uh1Tf6qATQqbEwuZAoYiKYdDA5mPeBmW+B9CPDfe3Fj6bh40J3
         3rCTz5ExaBURlUj73l5WUmli2SqBAhD3tPKqsAXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 15/63] SUNRPC: RPC level errors should always set task->tk_rpc_status
Date:   Tue,  1 Oct 2019 12:40:37 -0400
Message-Id: <20191001164125.15398-15-sashal@kernel.org>
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

[ Upstream commit 714fbc73888f59321854e7f6c2f224213923bcad ]

Ensure that we set task->tk_rpc_status for all RPC level errors so that
the caller can distinguish between those and server reply status errors.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c  | 6 +++---
 net/sunrpc/sched.c | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index fbb85ea24ea0f..8f32f73614111 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1760,7 +1760,7 @@ call_allocate(struct rpc_task *task)
 		return;
 	}
 
-	rpc_exit(task, -ERESTARTSYS);
+	rpc_call_rpcerror(task, -ERESTARTSYS);
 }
 
 static int
@@ -2480,7 +2480,7 @@ rpc_encode_header(struct rpc_task *task, struct xdr_stream *xdr)
 	return 0;
 out_fail:
 	trace_rpc_bad_callhdr(task);
-	rpc_exit(task, error);
+	rpc_call_rpcerror(task, error);
 	return error;
 }
 
@@ -2547,7 +2547,7 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 		return -EAGAIN;
 	}
 out_err:
-	rpc_exit(task, error);
+	rpc_call_rpcerror(task, error);
 	return error;
 
 out_unparsable:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index a2c1148127172..0b11971dec79b 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -914,8 +914,10 @@ static void __rpc_execute(struct rpc_task *task)
 		/*
 		 * Signalled tasks should exit rather than sleep.
 		 */
-		if (RPC_SIGNALLED(task))
+		if (RPC_SIGNALLED(task)) {
+			task->tk_rpc_status = -ERESTARTSYS;
 			rpc_exit(task, -ERESTARTSYS);
+		}
 
 		/*
 		 * The queue->lock protects against races with
@@ -951,6 +953,7 @@ static void __rpc_execute(struct rpc_task *task)
 			 */
 			dprintk("RPC: %5u got signal\n", task->tk_pid);
 			set_bit(RPC_TASK_SIGNALLED, &task->tk_runstate);
+			task->tk_rpc_status = -ERESTARTSYS;
 			rpc_exit(task, -ERESTARTSYS);
 		}
 		dprintk("RPC: %5u sync task resuming\n", task->tk_pid);
-- 
2.20.1

