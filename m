Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799CF15B97
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfEGFiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbfEGFiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B862220578;
        Tue,  7 May 2019 05:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207486;
        bh=PKfrynBKEvM/PKeZRU7lV68wr5wLDaGH2t074wvcoTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0K2i3p/3Jut5GrBZ83+IuBvUHoVXfhhhghlUjwDb3u2G7r1soClxIJA90c3XsJ3ni
         bn50ACV5gS/ezhdPc8UnWWgchqxRTqncmYZEnQUn2wCI/EGJBgD8RzmukQQEFLgeLt
         93SEBlUe8S6XRRJk3WzG2zxI/HSBOWGfDhmEcki8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 70/81] netfilter: nf_tables: use-after-free in dynamic operations
Date:   Tue,  7 May 2019 01:35:41 -0400
Message-Id: <20190507053554.30848-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3f3a390dbd59d236f62cff8e8b20355ef7069e3d ]

Smatch reports:

       net/netfilter/nf_tables_api.c:2167 nf_tables_expr_destroy()
        error: dereferencing freed memory 'expr->ops'

net/netfilter/nf_tables_api.c
    2162 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
    2163                                   struct nft_expr *expr)
    2164 {
    2165        if (expr->ops->destroy)
    2166                expr->ops->destroy(ctx, expr);
                                                ^^^^
--> 2167        module_put(expr->ops->type->owner);
                           ^^^^^^^^^
    2168 }

Smatch says there are three functions which free expr->ops.

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f272f9538c44..ef7ff13a7b99 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2113,9 +2113,11 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
 				   struct nft_expr *expr)
 {
+	const struct nft_expr_type *type = expr->ops->type;
+
 	if (expr->ops->destroy)
 		expr->ops->destroy(ctx, expr);
-	module_put(expr->ops->type->owner);
+	module_put(type->owner);
 }
 
 struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
-- 
2.20.1

