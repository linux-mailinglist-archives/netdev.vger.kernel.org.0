Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBECC3DE5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfJARDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbfJAQjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C999421920;
        Tue,  1 Oct 2019 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947984;
        bh=6wgNZmsOgbRgn0aUaKX9yXUl7VTpU4/3/nmkC16hG4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/ZZ9Z3L4x83zsG9JA88HTUFBYSK1EBAhnOWw5Dz2pxUhUNe6VsJ8ak8DB/lM447V
         aDR418+4yNiMOOg/m2I5IABWu6lqdFqjviAdO9boWIkYiBqzZvCfhyDzySzpGoAcDY
         Qxy5kYT3rUB3NsO1EOvCTuj5j+t2AX3lgA+zTcec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 16/71] SUNRPC: RPC level errors should always set task->tk_rpc_status
Date:   Tue,  1 Oct 2019 12:38:26 -0400
Message-Id: <20191001163922.14735-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
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
index a07b516e503a0..76e745ff78138 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1837,7 +1837,7 @@ call_allocate(struct rpc_task *task)
 		return;
 	}
 
-	rpc_exit(task, -ERESTARTSYS);
+	rpc_call_rpcerror(task, -ERESTARTSYS);
 }
 
 static int
@@ -2561,7 +2561,7 @@ rpc_encode_header(struct rpc_task *task, struct xdr_stream *xdr)
 	return 0;
 out_fail:
 	trace_rpc_bad_callhdr(task);
-	rpc_exit(task, error);
+	rpc_call_rpcerror(task, error);
 	return error;
 }
 
@@ -2628,7 +2628,7 @@ rpc_decode_header(struct rpc_task *task, struct xdr_stream *xdr)
 		return -EAGAIN;
 	}
 out_err:
-	rpc_exit(task, error);
+	rpc_call_rpcerror(task, error);
 	return error;
 
 out_unparsable:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 1f275aba786fc..53934fe73a9db 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -930,8 +930,10 @@ static void __rpc_execute(struct rpc_task *task)
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
@@ -967,6 +969,7 @@ static void __rpc_execute(struct rpc_task *task)
 			 */
 			dprintk("RPC: %5u got signal\n", task->tk_pid);
 			set_bit(RPC_TASK_SIGNALLED, &task->tk_runstate);
+			task->tk_rpc_status = -ERESTARTSYS;
 			rpc_exit(task, -ERESTARTSYS);
 		}
 		dprintk("RPC: %5u sync task resuming\n", task->tk_pid);
-- 
2.20.1

