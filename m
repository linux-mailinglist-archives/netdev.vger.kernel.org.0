Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8D37ECE8
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbhELUCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352111AbhELSCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 14:02:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0ACF6142C;
        Wed, 12 May 2021 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842483;
        bh=tUlpM3DQBjSnWR7vaADyD1QCt5Vsf2xpNC/talcvKrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzPD2UsPwNAF9HosVo0fpFRfO09xJLSmsu4PcBhIBt2RPqRds3kHvWBGMh1+tGwmI
         Bnr6yulq1cU3lXq6eJl4rbaVrGYDWbgl1X7vQ1cE+lVS8WcoPRbc203T6zZwyQn8kU
         61imPXW2yw+fBgMLykETDQqwLrj43nAeo0K1fzoVQmn1JZ023JFa5d1PnFRdYLrnzL
         LDe3cLZ6pU+mIjFzwqJjmwxba9exLfAoY7tQLxCcDP48tDWkUUybmRHx139rvHnUBo
         WQ3af7xIjGjpOeUxxMNZXy9cjb09OrLiW25c5PO8DMKpHtNQI6oV3Q2hjdHVu9DiC0
         CsVl5/gomhLhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 13/37] svcrdma: Don't leak send_ctxt on Send errors
Date:   Wed, 12 May 2021 14:00:40 -0400
Message-Id: <20210512180104.664121-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 351461f332db5670056a9c6bce6916027f91072f ]

Address a rare send_ctxt leak in the svc_rdma_sendto() error paths.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 52c759a8543e..3669661457c1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -958,7 +958,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	p = xdr_reserve_space(&sctxt->sc_stream,
 			      rpcrdma_fixed_maxsz * sizeof(*p));
 	if (!p)
-		goto err0;
+		goto err1;
 
 	ret = svc_rdma_send_reply_chunk(rdma, rctxt, &rqstp->rq_res);
 	if (ret < 0)
@@ -970,11 +970,11 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	*p = pcl_is_empty(&rctxt->rc_reply_pcl) ? rdma_msg : rdma_nomsg;
 
 	if (svc_rdma_encode_read_list(sctxt) < 0)
-		goto err0;
+		goto err1;
 	if (svc_rdma_encode_write_list(rctxt, sctxt) < 0)
-		goto err0;
+		goto err1;
 	if (svc_rdma_encode_reply_chunk(rctxt, sctxt, ret) < 0)
-		goto err0;
+		goto err1;
 
 	ret = svc_rdma_send_reply_msg(rdma, sctxt, rctxt, rqstp);
 	if (ret < 0)
-- 
2.30.2

