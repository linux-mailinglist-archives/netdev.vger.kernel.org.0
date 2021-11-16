Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546194539CD
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239787AbhKPTIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:08:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239755AbhKPTHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE73F63241;
        Tue, 16 Nov 2021 19:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637089494;
        bh=StF9zvIyiI8CbHePB2sRe3ydWwyn5ypRVDzxRXBi2dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxjKHO14BvbFdU9Hm3UCZqrGVetxQdYaZBLkcT9qNsyBxO/q68Luaf876UOMCaCpJ
         U/yfLs5yB1AjlBDR3cj/+sXRJOZncvGmvqj5kg8XGUHrgLJHP3HBrOyNpxUYr9OYTW
         UkTh8yUkru8PmrPkMoUR5Fo64CnCppvEF9L5FFgNTWhfiLCfeoGVSYE2GAPCgenFKE
         JD4QG6mOFyBb+M7p9L7hd+fQlv8RH4q0vjVoC8o+6Lx8kVNnk1FNNWReTXeL8yH07I
         IDO3Sa+2BIgkoWrslVyzn9PxRqL8L6GVNV1B4WB6Z6Nwgdpz/obKPnwfUggHdDgekx
         d2Jvq+mCy60rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        kuba@kernel.org, colin.king@intel.com, neilb@suse.de,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/65] UNRPC: Return specific error code on kmalloc failure
Date:   Tue, 16 Nov 2021 14:03:24 -0500
Message-Id: <20211116190443.2418144-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211116190443.2418144-1-sashal@kernel.org>
References: <20211116190443.2418144-1-sashal@kernel.org>
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

