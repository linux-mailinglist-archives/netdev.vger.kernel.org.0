Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934CA3BD233
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhGFLli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237175AbhGFLf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E8A661D3E;
        Tue,  6 Jul 2021 11:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570756;
        bh=2i22KCHVi/5HW7v/5PYOSKt8E72zDw5l4Ce16zyEpSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpkRmNt9+yZ5crUl6e67Z96Ijq+MXMmBDnrwUaeQorbzWGrwNkJMzdJnNEJQjHER/
         VbEA+8bkiTCT84Wf8B1vFnaRx+41MSfdHR/Z+zerNW/KuJ+UnXQn7+BzYi5cGLRBxf
         Hc2WTctjqjsaJ18W3Zmmfhfcinu2wQdM+tC1/uRBdItAQpTYf8B91iRvX/ariK7YUo
         FcCYjhYhxSWUKVpSq8K3KyIkUnaWYMCI3SR+buVD4RCiIvKGVsDrooNYJOb7olrbc0
         ciGalN8e0pgyy1nKKMB2LfXltDull5iYbpEcg3AeV0J0fPDobK8EwdoT7RCRBQYFb2
         3F6Z9CwU+4NRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/74] xfrm: Fix error reporting in xfrm_state_construct.
Date:   Tue,  6 Jul 2021 07:24:31 -0400
Message-Id: <20210706112502.2064236-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 6fd06963fa74197103cdbb4b494763127b3f2f34 ]

When memory allocation for XFRMA_ENCAP or XFRMA_COADDR fails,
the error will not be reported because the -ENOMEM assignment
to the err variable is overwritten before. Fix this by moving
these two in front of the function so that memory allocation
failures will be reported.

Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbb7d9d06478..0cee2d3c6e45 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -580,6 +580,20 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	copy_from_user_state(x, p);
 
+	if (attrs[XFRMA_ENCAP]) {
+		x->encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
+				   sizeof(*x->encap), GFP_KERNEL);
+		if (x->encap == NULL)
+			goto error;
+	}
+
+	if (attrs[XFRMA_COADDR]) {
+		x->coaddr = kmemdup(nla_data(attrs[XFRMA_COADDR]),
+				    sizeof(*x->coaddr), GFP_KERNEL);
+		if (x->coaddr == NULL)
+			goto error;
+	}
+
 	if (attrs[XFRMA_SA_EXTRA_FLAGS])
 		x->props.extra_flags = nla_get_u32(attrs[XFRMA_SA_EXTRA_FLAGS]);
 
@@ -600,23 +614,9 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 				   attrs[XFRMA_ALG_COMP])))
 		goto error;
 
-	if (attrs[XFRMA_ENCAP]) {
-		x->encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
-				   sizeof(*x->encap), GFP_KERNEL);
-		if (x->encap == NULL)
-			goto error;
-	}
-
 	if (attrs[XFRMA_TFCPAD])
 		x->tfcpad = nla_get_u32(attrs[XFRMA_TFCPAD]);
 
-	if (attrs[XFRMA_COADDR]) {
-		x->coaddr = kmemdup(nla_data(attrs[XFRMA_COADDR]),
-				    sizeof(*x->coaddr), GFP_KERNEL);
-		if (x->coaddr == NULL)
-			goto error;
-	}
-
 	xfrm_mark_get(attrs, &x->mark);
 
 	xfrm_smark_init(attrs, &x->props.smark);
-- 
2.30.2

