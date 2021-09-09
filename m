Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9AC40546F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355351AbhIIM6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353357AbhIIMtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:49:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C4E463211;
        Thu,  9 Sep 2021 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188602;
        bh=/Mc2ln3JnejyRuR3H4GwKJgFRcdTutqOBtrVfUGEjlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTaMZ7O2nuZ9F5/X9SzpyUZCl7ZFvL0w9tNnelP3Tqv+/zFQDTy7cuzBKEe0/tu/D
         rz92xdw7qXt4ATc25tiLFUksTIrs4iLUG6IvnHyjpNt6VA/MxJBOIekSVZkHExodVy
         yc4XBVAlVgYZHIhrN57KlkxiMlT69ZGPcLSxOsJQ8NsEIwd8bu+LQy78VYMHnk+a7+
         092sAdLkQGAv9MaU4XTqC41wIo9fAkB+N3qgBWAe976rcOJUdI/LK0Mrzov2+PnSYp
         /UV2JdsOjxK+lpmW0lvt631jT7oFSe7d849AmB6ny173LXY1YLwwJCZ9CIYxOpnYM0
         mXlWaCN1Yy3vA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 074/109] rpc: fix gss_svc_init cleanup on failure
Date:   Thu,  9 Sep 2021 07:54:31 -0400
Message-Id: <20210909115507.147917-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index d5470c7fe879..c0016473a255 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1937,7 +1937,7 @@ gss_svc_init_net(struct net *net)
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

