Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B91299BD3
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410131AbgJZXxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410115AbgJZXxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A1A4221FC;
        Mon, 26 Oct 2020 23:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756413;
        bh=jq3+6+vpC0K076l/7Ii6puB7IWw6g2F3iSVyX/FnC3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXJlc2HIiBgMv9PlE33kWzrhBxYTdJiRjb2ASCJhJuv4GJMFCy1i5CGjLsHhoYe2G
         /5mUzwSsH1fMfFww9xfYz+Gl6Nbhs8J9+saERjo8ZDlBfcZbr8Wu9lca5Xa2tS8UbC
         etdoyUIHkAMevWgNU/yOHtluBJtrIxir8yYZNn1U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 071/132] SUNRPC: Mitigate cond_resched() in xprt_transmit()
Date:   Mon, 26 Oct 2020 19:51:03 -0400
Message-Id: <20201026235205.1023962-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
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
index d5cc5db9dbf39..b44099958c8bb 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1511,10 +1511,13 @@ xprt_transmit(struct rpc_task *task)
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
@@ -1522,7 +1525,6 @@ xprt_transmit(struct rpc_task *task)
 		status = xprt_request_transmit(next, task);
 		if (status == -EBADMSG && next != req)
 			status = 0;
-		cond_resched();
 		spin_lock(&xprt->queue_lock);
 		xprt_unpin_rqst(next);
 		if (status == 0) {
-- 
2.25.1

