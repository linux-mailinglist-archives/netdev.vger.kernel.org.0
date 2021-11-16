Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63D4539FE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbhKPTVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239873AbhKPTVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6711863220;
        Tue, 16 Nov 2021 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637090284;
        bh=StF9zvIyiI8CbHePB2sRe3ydWwyn5ypRVDzxRXBi2dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9BbynV/nzZCGY+kAeg5+egq79sKFig/v9cLiOzyi9dpG9XqDxmI2FKTMyBcSSxxL
         rT9Bk4F1ZwR53BW7l8hCPu3uR7w2i3uzJdNORxf2qR/dbG6JEgbDbC5VANXZgPweEF
         TRsuqkVYZF/HFuH8B49g6FkHEtlrNpfJ/9IEXalUCuN54VdRPUhVHFStepHqkVCBc/
         8GPai/ZcYWu6pt/nI8cHVnHfGx/s5RNHg2lGWpdCaL5zBMQxWingVVdSXddCgSdYZy
         2kJzQulC6IYnRwv9iIRT3Jz8EOPkcCA/RXkjoz0Cu07Zb9RJS/W71E2UGrUTuMp5Yc
         Y7jX0h6or2KyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        chuck.lever@oracle.com, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, davem@davemloft.net, kuba@kernel.org,
        colin.king@intel.com, neilb@suse.de, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/65] UNRPC: Return specific error code on kmalloc failure
Date:   Tue, 16 Nov 2021 14:16:49 -0500
Message-Id: <20211116191754.2419097-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116191754.2419097-1-sashal@kernel.org>
References: <20211116191754.2419097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 458032fcfa91c8714859b1f01b9ac7dccea5d6cd ]

Although the callers of this function only care about whether the
return value is null or not, we should still give a rigorous
error code.

Smatch tool warning:
net/sunrpc/auth_gss/svcauth_gss.c:784 gss_write_verf() warn: returning
-1 instead of -ENOMEM is sloppy

No functional change, just more standardized.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 1f2817195549b..b87565b64928d 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -781,7 +781,7 @@ gss_write_verf(struct svc_rqst *rqstp, struct gss_ctx *ctx_id, u32 seq)
 	svc_putnl(rqstp->rq_res.head, RPC_AUTH_GSS);
 	xdr_seq = kmalloc(4, GFP_KERNEL);
 	if (!xdr_seq)
-		return -1;
+		return -ENOMEM;
 	*xdr_seq = htonl(seq);
 
 	iov.iov_base = xdr_seq;
-- 
2.33.0

