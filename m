Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6932E34902E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhCYLdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230417AbhCYLau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 07:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AD1161A61;
        Thu, 25 Mar 2021 11:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671675;
        bh=7+/xmXOtKBsHg7XwHtan05NXhF776FAi9Srk7V44K+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmEuajCdvMdRvDiM0v01X3O3euFRpFj2dYedupDdnjh/OwJmsuih89DUgCgWosSUP
         5W5s/5ebZr0UrMG/h6h5abuZ+GX2lQiqlkpzuePffve3Y6145Ym74yymrsTsnZYQ3u
         iFTarb0bda9WSONcJgojZSYlN2UtbHSLiydmbOZ36WTvIFRJPfmrYLvbxTFbj5SQsR
         WVhFxsYvSIigGJhhmxvBDVW4AS6O48oIuSQGxfd1RHOY2h4vV1XEXMmC0EdFIBTzpY
         NYMHdArh3NI/MWZ3rIQeyl7BDjworGNIuG7i+825CGjsCGvoq0HyEn4zMvxKxcXtbc
         n1XTXsa79ZUEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/16] rpc: fix NULL dereference on kmalloc failure
Date:   Thu, 25 Mar 2021 07:27:37 -0400
Message-Id: <20210325112751.1928421-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112751.1928421-1-sashal@kernel.org>
References: <20210325112751.1928421-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 0ddc942394013f08992fc379ca04cffacbbe3dae ]

I think this is unlikely but possible:

svc_authenticate sets rq_authop and calls svcauth_gss_accept.  The
kmalloc(sizeof(*svcdata), GFP_KERNEL) fails, leaving rq_auth_data NULL,
and returning SVC_DENIED.

This causes svc_process_common to go to err_bad_auth, and eventually
call svc_authorise.  That calls ->release == svcauth_gss_release, which
tries to dereference rq_auth_data.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Link: https://lore.kernel.org/linux-nfs/3F1B347F-B809-478F-A1E9-0BE98E22B0F0@oracle.com/T/#t
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 03043d5221e9..27dfd85830d8 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1713,11 +1713,14 @@ static int
 svcauth_gss_release(struct svc_rqst *rqstp)
 {
 	struct gss_svc_data *gsd = (struct gss_svc_data *)rqstp->rq_auth_data;
-	struct rpc_gss_wire_cred *gc = &gsd->clcred;
+	struct rpc_gss_wire_cred *gc;
 	struct xdr_buf *resbuf = &rqstp->rq_res;
 	int stat = -EINVAL;
 	struct sunrpc_net *sn = net_generic(SVC_NET(rqstp), sunrpc_net_id);
 
+	if (!gsd)
+		goto out;
+	gc = &gsd->clcred;
 	if (gc->gc_proc != RPC_GSS_PROC_DATA)
 		goto out;
 	/* Release can be called twice, but we only wrap once. */
@@ -1758,10 +1761,10 @@ svcauth_gss_release(struct svc_rqst *rqstp)
 	if (rqstp->rq_cred.cr_group_info)
 		put_group_info(rqstp->rq_cred.cr_group_info);
 	rqstp->rq_cred.cr_group_info = NULL;
-	if (gsd->rsci)
+	if (gsd && gsd->rsci) {
 		cache_put(&gsd->rsci->h, sn->rsc_cache);
-	gsd->rsci = NULL;
-
+		gsd->rsci = NULL;
+	}
 	return stat;
 }
 
-- 
2.30.1

