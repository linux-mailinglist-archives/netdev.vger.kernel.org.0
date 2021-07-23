Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD713D3CE6
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbhGWPN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:13:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57306 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbhGWPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:53 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1F330642A0;
        Fri, 23 Jul 2021 17:53:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/6] netfilter: nft_last: avoid possible false sharing
Date:   Fri, 23 Jul 2021 17:54:09 +0200
Message-Id: <20210723155412.17916-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723155412.17916-1-pablo@netfilter.org>
References: <20210723155412.17916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the idiom described in:

https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance

Moreover, prevent a compiler optimization.

Fixes: 836382dc2471 ("netfilter: nf_tables: add last expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_last.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
index 8088b99f2ee3..304e33cbed9b 100644
--- a/net/netfilter/nft_last.c
+++ b/net/netfilter/nft_last.c
@@ -48,24 +48,30 @@ static void nft_last_eval(const struct nft_expr *expr,
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
 
-	priv->last_jiffies = jiffies;
-	priv->last_set = 1;
+	if (READ_ONCE(priv->last_jiffies) != jiffies)
+		WRITE_ONCE(priv->last_jiffies, jiffies);
+	if (READ_ONCE(priv->last_set) == 0)
+		WRITE_ONCE(priv->last_set, 1);
 }
 
 static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_last_priv *priv = nft_expr_priv(expr);
+	unsigned long last_jiffies = READ_ONCE(priv->last_jiffies);
+	u32 last_set = READ_ONCE(priv->last_set);
 	__be64 msecs;
 
-	if (time_before(jiffies, priv->last_jiffies))
-		priv->last_set = 0;
+	if (time_before(jiffies, last_jiffies)) {
+		WRITE_ONCE(priv->last_set, 0);
+		last_set = 0;
+	}
 
-	if (priv->last_set)
-		msecs = nf_jiffies64_to_msecs(jiffies - priv->last_jiffies);
+	if (last_set)
+		msecs = nf_jiffies64_to_msecs(jiffies - last_jiffies);
 	else
 		msecs = 0;
 
-	if (nla_put_be32(skb, NFTA_LAST_SET, htonl(priv->last_set)) ||
+	if (nla_put_be32(skb, NFTA_LAST_SET, htonl(last_set)) ||
 	    nla_put_be64(skb, NFTA_LAST_MSECS, msecs, NFTA_LAST_PAD))
 		goto nla_put_failure;
 
-- 
2.20.1

