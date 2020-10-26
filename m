Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF5299D05
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411058AbgJ0ADU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411039AbgJZX4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1351522202;
        Mon, 26 Oct 2020 23:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756567;
        bh=8GCNzbKpvsqLPIFyh/3q+gb2kOaXod3PBysi3b/Cp+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbLVt5nUlUe+Ig0rVJi8bRuNupOtttrWwnIx0lPgeD0TquK9iZmhlJuscF8AywIOm
         +ovdo49Xwm6r2hx2IoL/ukgOVviLwOt25xdhk7IrZQp37K7R9v4WLwIN5iaJs4b85c
         nOpBwRPXvxlk7+L16HfLBEPzyrgnTRRiJwXq8BRk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 42/80] SUNRPC: Mitigate cond_resched() in xprt_transmit()
Date:   Mon, 26 Oct 2020 19:54:38 -0400
Message-Id: <20201026235516.1025100-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6f9f17287e78e5049931af2037b15b26d134a32a ]

The original purpose of this expensive call is to prevent a long
queue of requests from blocking other work.

The cond_resched() call is unnecessary after just a single send
operation.

For longer queues, instead of invoking the kernel scheduler, simply
release the transport send lock and return to the RPC scheduler.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 41df4c507193b..a6fee86f400ec 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1503,10 +1503,13 @@ xprt_transmit(struct rpc_task *task)
 {
 	struct rpc_rqst *next, *req = task->tk_rqstp;
 	struct rpc_xprt	*xprt = req->rq_xprt;
-	int status;
+	int counter, status;
 
 	spin_lock(&xprt->queue_lock);
+	counter = 0;
 	while (!list_empty(&xprt->xmit_queue)) {
+		if (++counter == 20)
+			break;
 		next = list_first_entry(&xprt->xmit_queue,
 				struct rpc_rqst, rq_xmit);
 		xprt_pin_rqst(next);
@@ -1514,7 +1517,6 @@ xprt_transmit(struct rpc_task *task)
 		status = xprt_request_transmit(next, task);
 		if (status == -EBADMSG && next != req)
 			status = 0;
-		cond_resched();
 		spin_lock(&xprt->queue_lock);
 		xprt_unpin_rqst(next);
 		if (status == 0) {
-- 
2.25.1

