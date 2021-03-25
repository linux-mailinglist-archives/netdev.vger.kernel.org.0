Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD95F349085
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhCYLfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhCYLdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 07:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8970261A86;
        Thu, 25 Mar 2021 11:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671715;
        bh=HAaJak4bHpPnuRXInyA1iSQlO0XhkFJmnK63h0bmJ+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGPjJyztns2LMHxkt40y6m7/jv/azZkTR8qSuY1+qtP6CK+cHY4IInLX76AAPtr0p
         4cwqW+5UkEh58qMdEAri/DCoYl0iJdZXQF0ONfpn2exG8LwJpFkQv4T1WlkUfJlUC9
         Vr6joGBFf3Xk1+2TjINMso+FumcIVH25iaRVrjFF0tpoLJcI57inA6h7hxkB5s+pvh
         hWI6G6xfKQE/D5M2uDGxcXSbN5I9CIyMMJj1lnROduJaEkKROzlpz2lh812MNV1dVn
         HuahVHPInLXLEyE5SPvICxQwGDkCAUebXMLF8qVI+bkIkyFP7zwd2tqS/7AT8kuw0a
         CtNatd94FKQ8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/10] rpc: fix NULL dereference on kmalloc failure
Date:   Thu, 25 Mar 2021 07:28:23 -0400
Message-Id: <20210325112832.1928898-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112832.1928898-1-sashal@kernel.org>
References: <20210325112832.1928898-1-sashal@kernel.org>
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
index 91263d6a103b..bb8b0ef5de82 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1697,11 +1697,14 @@ static int
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
@@ -1742,10 +1745,10 @@ svcauth_gss_release(struct svc_rqst *rqstp)
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

