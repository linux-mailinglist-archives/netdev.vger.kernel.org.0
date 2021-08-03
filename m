Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF6A3DEA31
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhHCKAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234813AbhHCKA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8588060F56;
        Tue,  3 Aug 2021 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627984819;
        bh=LBKY3hTt2FUPdKgyEGSeDs6OHhBTNTcGF/AUCHL4BCY=;
        h=From:To:Cc:Subject:Date:From;
        b=GTy5ZhSsayI+dmMWO1uvYOLvYPi5wsInB+SyINfkL8fc/mkdcQ7hYsY8wN3gXOoCb
         cu7jY4YDn9n0KKKWelosK0fxPvFrX6CF1frhyDJMAekKHuhViHC3rAWOSMmMrO0+hk
         TV6qjywvuf56x5yTtSfMsYIG0NlLqaGfwEZUhzqfwEApw+N6wCJNbKxpvQcIyuXqiZ
         2wZ2brKBcD3CSsg4DVSoZc0X3Wyhtw0ThymRAwodq6Kg9zqj2LmsFwRKsbvuzK7swn
         R/LLc72xc17bxOLHDXDZdTudHzdFK//Y4q9+em0uMS574r3yk7PkcEUi0TyQV84w+H
         AHBnDY1NJ+qQg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net] net: ipv6: fix returned variable type in ip6_skb_dst_mtu
Date:   Tue,  3 Aug 2021 12:00:16 +0200
Message-Id: <20210803100016.314960-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch fixing the returned value of ip6_skb_dst_mtu (int -> unsigned
int) was rebased between its initial review and the version applied. In
the meantime fade56410c22 was applied, which added a new variable (int)
used as the returned value. This lead to a mismatch between the function
prototype and the variable used as the return value.

Fixes: 40fc3054b458 ("net: ipv6: fix return value of ip6_skb_dst_mtu")
Cc: Vadim Fedorenko <vfedorenko@novek.ru>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/net/ip6_route.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 625a38ccb5d9..0bf09a9bca4e 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -265,7 +265,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 static inline unsigned int ip6_skb_dst_mtu(struct sk_buff *skb)
 {
-	int mtu;
+	unsigned int mtu;
 
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
-- 
2.31.1

