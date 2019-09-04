Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E88A8CD5
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfIDQSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731543AbfIDP6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF93B22CF7;
        Wed,  4 Sep 2019 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612728;
        bh=9ihFwqapVZ8ImWO7Fe8EEFOgFkuhEe0mW9hNiTymonE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohLXILHVZqYXQ7dnTI/nap5vJ4RtGBTzoJiYYfcfqqMqMVgOBxeX3awnRp9+u0tA7
         9J7Pb9v8Fb5cimz+ASNPkNOecG9nIngO/Xov283NAOjxdzgSOM56CPTwUoz+rbJu+H
         lS7nHFssubgkJHeLWs4u+SdnRQcgPr/x0UoSopkk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 45/94] SUNRPC: Handle EADDRINUSE and ENOBUFS correctly
Date:   Wed,  4 Sep 2019 11:56:50 -0400
Message-Id: <20190904155739.2816-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 80f455da6cd0998a5be30a8af24ea2a22815c212 ]

If a connect or bind attempt returns EADDRINUSE, that means we want to
retry with a different port. It is not a fatal connection error.
Similarly, ENOBUFS is not fatal, but just indicates a memory allocation
issue. Retry after a short delay.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 9e1743b364ec4..3f090a75f3721 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1926,6 +1926,9 @@ call_bind_status(struct rpc_task *task)
 		task->tk_rebind_retry--;
 		rpc_delay(task, 3*HZ);
 		goto retry_timeout;
+	case -ENOBUFS:
+		rpc_delay(task, HZ >> 2);
+		goto retry_timeout;
 	case -EAGAIN:
 		goto retry_timeout;
 	case -ETIMEDOUT:
@@ -1949,7 +1952,6 @@ call_bind_status(struct rpc_task *task)
 	case -ENETDOWN:
 	case -EHOSTUNREACH:
 	case -ENETUNREACH:
-	case -ENOBUFS:
 	case -EPIPE:
 		dprintk("RPC: %5u remote rpcbind unreachable: %d\n",
 				task->tk_pid, task->tk_status);
@@ -2040,8 +2042,6 @@ call_connect_status(struct rpc_task *task)
 	case -ENETDOWN:
 	case -ENETUNREACH:
 	case -EHOSTUNREACH:
-	case -EADDRINUSE:
-	case -ENOBUFS:
 	case -EPIPE:
 		xprt_conditional_disconnect(task->tk_rqstp->rq_xprt,
 					    task->tk_rqstp->rq_connect_cookie);
@@ -2050,6 +2050,7 @@ call_connect_status(struct rpc_task *task)
 		/* retry with existing socket, after a delay */
 		rpc_delay(task, 3*HZ);
 		/* fall through */
+	case -EADDRINUSE:
 	case -ENOTCONN:
 	case -EAGAIN:
 	case -ETIMEDOUT:
@@ -2058,6 +2059,9 @@ call_connect_status(struct rpc_task *task)
 		clnt->cl_stats->netreconn++;
 		task->tk_action = call_transmit;
 		return;
+	case -ENOBUFS:
+		rpc_delay(task, HZ >> 2);
+		goto out_retry;
 	}
 	rpc_call_rpcerror(task, status);
 	return;
-- 
2.20.1

