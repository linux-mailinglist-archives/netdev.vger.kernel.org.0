Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2231737ED00
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382495AbhELUFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352544AbhELSDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 14:03:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 744366142D;
        Wed, 12 May 2021 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842543;
        bh=QF4abw8CNboSBbQfegD6rcHqvN3NCM63O8d2+K3ku50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYgDaxZIeMsZIdEgVmpqrt3v18voHUdhDhDoT0uHi4aoHTNm2ZRjNf/rmBudXjCBV
         hIs7owHnSTG9nHf/goX+NgynEsy7m5z4ivamp9QFSnM8M1kBn41LKzWo51WPF6fpEe
         Xkoux70N3aEMhJP7M9DepnDUVa5Bd9LCpCJ/zer3n5FkJ3HJN6PNeAo5JivlYDVP2k
         xk/SeQJePHqrFfdkZCIM/q1cOPbWlQLLp8mfRoadCwSOXU/GsuZ1eWckjGNL1Im/DI
         sq9Q7/u2w7DOcfwyKuL5dnyr1HCqmsi4K4KcipSLsIREh3cROaH1JJHOnayUZ1cCas
         /Jork0sU140kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 11/35] svcrdma: Don't leak send_ctxt on Send errors
Date:   Wed, 12 May 2021 14:01:41 -0400
Message-Id: <20210512180206.664536-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
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
index 68af79d4f04f..65e9b8a38fae 100644
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

