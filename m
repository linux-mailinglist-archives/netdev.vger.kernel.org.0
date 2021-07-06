Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9442E3BCCA0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhGFLTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232832AbhGFLTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F01F61C50;
        Tue,  6 Jul 2021 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570190;
        bh=NWL3vADDU6N+1LuUlaashQBGcDZ2JluWdi3H/fJzvaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNiLN3CEpVn2gL7UHDZzkBfkwT6r3/ZaR/IUaSc+p0ZmQr3+4EGGYX/bNd2GJ+rlD
         3ttQSFE5yvMqikc4yASxF1CiJVEiHUXsJV35jrpBe2+zfK0tHQ79iX8HCNHRgq3X9C
         N/4heFzyg4MkscEGHeL+s0AfWMyMVHws0gX3mWh1oe8pP4ZgU/85Q511NxRDMCRn18
         rxaI7yz5h/Dyub7h2grOfzBjCRSTBeoiammN5Dr0BjF0Fn3l3MOyLvm7q7FJ9pGMQp
         3+GkPTp/CTfCloOcEJmAsfMuWdxWHeJVLS9RTUkiiFlznQELXN29NHy9MTbxsCA/6i
         S/PIdhRtREbVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 105/189] xfrm: Fix error reporting in xfrm_state_construct.
Date:   Tue,  6 Jul 2021 07:12:45 -0400
Message-Id: <20210706111409.2058071-105-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index f0aecee4d539..b47d613409b7 100644
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

