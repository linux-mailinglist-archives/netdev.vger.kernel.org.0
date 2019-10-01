Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9388C3ABF
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbfJAQjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbfJAQjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7776E21872;
        Tue,  1 Oct 2019 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947971;
        bh=Hi/MFaaJ5GWhVSa+IqBly6KzXkJMtUWh1MbotqnxbIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnxjCo5oRc33g960RY4lMtGdQkUI96OYCH+XV4qi5zFOEQpmQwPJXPquw9EFraFpJ
         Dy7IT8NEzeb/wNAEcwvfxDHitiQSSAZ/e+gRyIkeMVPaWzvjKK5H/VojacXU2WqHLu
         lz1ivhRomBB4y1FwijEmFPXcdByl8ij3uoZ92IPk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 05/71] xprtrdma: Toggle XPRT_CONGESTED in xprtrdma's slot methods
Date:   Tue,  1 Oct 2019 12:38:15 -0400
Message-Id: <20191001163922.14735-5-sashal@kernel.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 395790566eec37706dedeb94779045adc3a7581e ]

Commit 48be539dd44a ("xprtrdma: Introduce ->alloc_slot call-out for
xprtrdma") added a separate alloc_slot and free_slot to the RPC/RDMA
transport. Later, commit 75891f502f5f ("SUNRPC: Support for
congestion control when queuing is enabled") modified the generic
alloc/free_slot methods, but neglected the methods in xprtrdma.

Found via code review.

Fixes: 75891f502f5f ("SUNRPC: Support for congestion control ... ")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 2ec349ed47702..f4763e8a67617 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -571,6 +571,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
+	set_bit(XPRT_CONGESTED, &xprt->state);
 	rpc_sleep_on(&xprt->backlog, task, NULL);
 	task->tk_status = -EAGAIN;
 }
@@ -589,7 +590,8 @@ xprt_rdma_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *rqst)
 
 	memset(rqst, 0, sizeof(*rqst));
 	rpcrdma_buffer_put(&r_xprt->rx_buf, rpcr_to_rdmar(rqst));
-	rpc_wake_up_next(&xprt->backlog);
+	if (unlikely(!rpc_wake_up_next(&xprt->backlog)))
+		clear_bit(XPRT_CONGESTED, &xprt->state);
 }
 
 static bool rpcrdma_check_regbuf(struct rpcrdma_xprt *r_xprt,
-- 
2.20.1

