Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55E613F460
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389693AbgAPRJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389283AbgAPRJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCDE52467A;
        Thu, 16 Jan 2020 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194566;
        bh=PEm+bMJbk/ztRxGX3pMP4loztHjfCNeyUsny1mCgJ7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDwmW6kiU/bcq2j1fmxZohvs888Ylny+MNgxnLQNAuOVFPzCpKBeLylL4IZphC+Oi
         Vwo1tnRDXTRYECLGlnuwzFRZVIIPZhteHeCR5vr8B0FeiDQ8KCq7GsbF/OX7NrVXtT
         q+GbgcHgL25BzPK3yKpXpk2e6PKgILffOp3WLU68=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 445/671] xprtrdma: Fix use-after-free in rpcrdma_post_recvs
Date:   Thu, 16 Jan 2020 12:01:23 -0500
Message-Id: <20200116170509.12787-182-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2d0abe36cf13fb7b577949fd1539326adddcc9bc ]

Dereference wr->next /before/ the memory backing wr has been
released. This issue was found by code inspection. It is not
expected to be a significant problem because it is in an error
path that is almost never executed.

Fixes: 7c8d9e7c8863 ("xprtrdma: Move Receive posting to ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 5ddbf227e7c6..2a1d8ec7f706 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1558,10 +1558,11 @@ rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, bool temp)
 	rc = ib_post_recv(r_xprt->rx_ia.ri_id->qp, wr,
 			  (const struct ib_recv_wr **)&bad_wr);
 	if (rc) {
-		for (wr = bad_wr; wr; wr = wr->next) {
+		for (wr = bad_wr; wr;) {
 			struct rpcrdma_rep *rep;
 
 			rep = container_of(wr, struct rpcrdma_rep, rr_recv_wr);
+			wr = wr->next;
 			rpcrdma_recv_buffer_put(rep);
 			--count;
 		}
-- 
2.20.1

