Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7DF404C2F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242978AbhIIL4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243660AbhIILyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F87B6136F;
        Thu,  9 Sep 2021 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187886;
        bh=ZMlgaw7vEbJRxNnsnX+4MTZdPk8DdvLyk4xw4z6Gioo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlfWSm33kJOQpeoBkvSGsDQAHwy6VaQ8e21HkrlN3Dp1bxC+j6FSrlyHnSKpSWodi
         IwOmrCpAIcFIOx1kvJcFCngjFY8acxf93vqGQCIxItVCbzFBdP9uJx8aQY4hUT+Ik1
         aRpXXZ2KT1wvhSsyJBtAyi/bZnyjKBJLgIHzDlW5VZtf7gs3KpjjVdSSVCL/Ccmi5c
         jdoQJq+qv1W28OIJvl2aYJRZFERg0wVqRREFSwzLed7UZOXervdHSvdkqalPy+yP2j
         Rqed0RVvO/KeVp3oNZCfZAvwtSX2m5/FNhqB3I5e5SrkuTf761m6ZrfUrc+vtbA0AL
         lOEPUSFpvO1rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 168/252] rpc: fix gss_svc_init cleanup on failure
Date:   Thu,  9 Sep 2021 07:39:42 -0400
Message-Id: <20210909114106.141462-168-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index a81be45f40d9..3d685fe328fa 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1980,7 +1980,7 @@ gss_svc_init_net(struct net *net)
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

