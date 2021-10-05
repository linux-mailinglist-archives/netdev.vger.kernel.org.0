Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FF8422895
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhJENxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhJENws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 976C661A0A;
        Tue,  5 Oct 2021 13:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441857;
        bh=s2OZDyjrE+EWWNn46xpQQivBdb9I8IUHqGAz8lAI+A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxj6yfzrh8gY+rl7SA8Uy6eTHgiLO8mABHuJQBRh01SPhfwoNUf9WUT9Y+CBSsjov
         vtHmkYQtd3JeDbg2vPyvmE4LIGcE56l/Me9TH0LwT47PPqVynxuW2eoXJFt0RAlpCU
         oWCHCW0Vm5rGst39GuXCkjDI7FbR7+apkQEw7mlcJBt5ogajGnEbJPbrIFPPXposz2
         FyZkLnr10MxRSh5OHC3NeMW+Z1z/vkqLg/wpAaJPsI+ZlFP2MNNc4FI0Na39gYs7R7
         w73JtYTwRto3wosxNvO8zJHLl0owV0CSptEPfJrfOdsbxMY76n4tTLftINSQNtwdx5
         g+3uEIrk2afIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 17/40] netfilter: nf_tables: Fix oversized kvmalloc() calls
Date:   Tue,  5 Oct 2021 09:49:56 -0400
Message-Id: <20211005135020.214291-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 45928afe94a094bcda9af858b96673d59bc4a0e9 ]

The commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
limits the max allocatable memory via kvmalloc() to MAX_INT.

Reported-by: syzbot+cd43695a64bcd21b8596@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..4b6255c4b183 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4336,7 +4336,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (ops->privsize != NULL)
 		size = ops->privsize(nla, &desc);
 	alloc_size = sizeof(*set) + size + udlen;
-	if (alloc_size < size)
+	if (alloc_size < size || alloc_size > INT_MAX)
 		return -ENOMEM;
 	set = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!set)
-- 
2.33.0

