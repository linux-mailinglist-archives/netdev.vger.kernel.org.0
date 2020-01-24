Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE7148903
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404381AbgAXOUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbgAXOUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D57222D9;
        Fri, 24 Jan 2020 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875603;
        bh=VkUqlwhiyoaVn2n+UOuK6DseS0e5IuC+pKfVYzHaHsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GbGFs7R94prNGPSd5CGc5ErL9EPKlnk+nLoBNFHrEP03Bf1C01xN05WoX5+doR+i
         2dVD0m6bNxnTwasLs1rg7kaCs7r35xNCMjZmYXR0la9ecxhKmNdMFn7dKWs0W8VEHc
         BkjPoYaQLRTPCU2kC6XaNNHjV0v9wZb8lkYOv7cU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 091/107] netfilter: nft_tunnel: fix null-attribute check
Date:   Fri, 24 Jan 2020 09:18:01 -0500
Message-Id: <20200124141817.28793-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1c702bf902bd37349f6d91cd7f4b372b1e46d0ed ]

else we get null deref when one of the attributes is missing, both
must be non-null.

Reported-by: syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com
Fixes: aaecfdb5c5dd8ba ("netfilter: nf_tables: match on tunnel metadata")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae605a8e..d89c7c5530309 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -76,7 +76,7 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 	struct nft_tunnel *priv = nft_expr_priv(expr);
 	u32 len;
 
-	if (!tb[NFTA_TUNNEL_KEY] &&
+	if (!tb[NFTA_TUNNEL_KEY] ||
 	    !tb[NFTA_TUNNEL_DREG])
 		return -EINVAL;
 
-- 
2.20.1

