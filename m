Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25C32FA4B0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfKMBzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729274AbfKMBzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14FC92245D;
        Wed, 13 Nov 2019 01:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610150;
        bh=Sdmu46wqyOZ8xb4qgKmubdm8/s9CbLdUeDfQxVPweYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjpLJpytF9KrOA/Mk6ykd5SsbXjWyUQn+9tMUSvkmu1UmcWZSbj3NgkMbqnyeYzLa
         o+K2GzsFZvCMTp62Xqrs14xeKCY/ZGZu/di9zP/bHKcdit92Ftitig8c0G139HXuQK
         me9ZZU6u1RTAvdIWIFweicg7iB0Phjd0HpXq/eFI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 195/209] netfilter: nft_compat: do not dump private area
Date:   Tue, 12 Nov 2019 20:50:11 -0500
Message-Id: <20191113015025.9685-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d701d8117200399d85e63a737d2e4e897932f3b6 ]

Zero pad private area, otherwise we expose private kernel pointer to
userspace. This patch also zeroes the tail area after the ->matchsize
and ->targetsize that results from XT_ALIGN().

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1245e02239d90..469f9da5073bf 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -269,6 +269,24 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	kfree(expr->ops);
 }
 
+static int nft_extension_dump_info(struct sk_buff *skb, int attr,
+				   const void *info,
+				   unsigned int size, unsigned int user_size)
+{
+	unsigned int info_size, aligned_size = XT_ALIGN(size);
+	struct nlattr *nla;
+
+	nla = nla_reserve(skb, attr, aligned_size);
+	if (!nla)
+		return -1;
+
+	info_size = user_size ? : size;
+	memcpy(nla_data(nla), info, info_size);
+	memset(nla_data(nla) + info_size, 0, aligned_size - info_size);
+
+	return 0;
+}
+
 static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct xt_target *target = expr->ops->data;
@@ -276,7 +294,8 @@ static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_string(skb, NFTA_TARGET_NAME, target->name) ||
 	    nla_put_be32(skb, NFTA_TARGET_REV, htonl(target->revision)) ||
-	    nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(target->targetsize), info))
+	    nft_extension_dump_info(skb, NFTA_TARGET_INFO, info,
+				    target->targetsize, target->usersize))
 		goto nla_put_failure;
 
 	return 0;
@@ -504,7 +523,8 @@ static int __nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr,
 
 	if (nla_put_string(skb, NFTA_MATCH_NAME, match->name) ||
 	    nla_put_be32(skb, NFTA_MATCH_REV, htonl(match->revision)) ||
-	    nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(match->matchsize), info))
+	    nft_extension_dump_info(skb, NFTA_MATCH_INFO, info,
+				    match->matchsize, match->usersize))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.20.1

