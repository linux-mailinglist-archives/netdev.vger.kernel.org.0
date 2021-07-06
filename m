Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F503BD29D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbhGFLoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237372AbhGFLgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B5861D8A;
        Tue,  6 Jul 2021 11:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570838;
        bh=03smCh26/GYOWe5lhahVhl1KR+OidGB07r5Z9zhMGYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkFBoETVoCysYwV+I5J4WMNVpT3u18WyCal6rmxabMcfYFZVAD4P0Ufckw19aJQUh
         l44VqvurgK+b/l2RXNxk0H6WeNpMxdJMS+KXyPFwsVM4hdO9fJbviXVlUDZuTNMukD
         UBu8C6l+GRuupkT2SIv1iew53DJ//uiVUfAC4P/we7zZleietpW1yJrnyeC2FXmIG9
         i4AlTudjLbiK0IbwIc2NlhM/GgcZcWdjJKwet4OgLpK4fcFmgfYHZKerqE/RHZUq5r
         wgJGgBuhXZ16JkuXH+1PdIxCFax9nWMDQKIoR1kE6JTXURycuPQGRfwSvBFPEBzb+h
         L5ALN1nFE02ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 31/55] xfrm: Fix error reporting in xfrm_state_construct.
Date:   Tue,  6 Jul 2021 07:26:14 -0400
Message-Id: <20210706112638.2065023-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112638.2065023-1-sashal@kernel.org>
References: <20210706112638.2065023-1-sashal@kernel.org>
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
index 0b80c7907715..f94abe1fdd58 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -579,6 +579,20 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
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
 
@@ -599,23 +613,9 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
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

