Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354D1405684
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359840AbhIINUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355250AbhIINNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48E1C632E1;
        Thu,  9 Sep 2021 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188908;
        bh=Y+PalN4q8RvwBAPT9+jNu3pp5FWhX2jqDZDErdHwqSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYRP3hLJlTjW+WKSLnFa8jRkUpWI8ahF9rI9ALp3+aEy/jUH+WY2Uj8zGveWPk6fa
         PatItwzfDWpxVW6gOeM3NoyAbgf/dtMPav1JzB2nXYOtVTjGtvvn/5dNXMlKHDFUMC
         DcU830f7iHgZGEez9nVUxrh5wD+bsJuO4U/slkgXyEmYNQgTqJZ18LwEVDiOmNTqEj
         8cCNsVpiG/K5THHOl0ZKIuKQCi0D7ZFNyJ3fSjiH0q5zLDMYClM+9b79/sqJsZaSbc
         Rp56FcUKjetxGl8GBm+pZ9bL61INIqobv5jvkOLdwFEXyPAzk2wxPS5/eUD8N3ZF9+
         gEvovuTbCG0Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 25/35] rpc: fix gss_svc_init cleanup on failure
Date:   Thu,  9 Sep 2021 08:01:06 -0400
Message-Id: <20210909120116.150912-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 5a4753446253a427c0ff1e433b9c4933e5af207c ]

The failure case here should be rare, but it's obviously wrong.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index bb8b0ef5de82..daf0c1ea3917 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1845,7 +1845,7 @@ gss_svc_init_net(struct net *net)
 		goto out2;
 	return 0;
 out2:
-	destroy_use_gss_proxy_proc_entry(net);
+	rsi_cache_destroy_net(net);
 out1:
 	rsc_cache_destroy_net(net);
 	return rv;
-- 
2.30.2

