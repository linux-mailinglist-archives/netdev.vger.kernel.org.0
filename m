Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D512B6A6
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfL0RoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728401AbfL0RoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A6624125;
        Fri, 27 Dec 2019 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468658;
        bh=Jvvz7VAOuf5cr7sba0W0VhPGhpU6NhDWTovzuuWPgIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exsQ2hwlHlKt1tvJN/qD0tsJIQCqqkwzS0RN0ZLiWFjDC4rZgbziop2YKYUnbetS7
         8G9CUL75pMb0zxvpa5jTwIVusj23N58CC6PuznqaYVsXeVnDNh9sBRYyzo7F2JgjWK
         KrdAjWHSIxyx5RvjgpKNHaQr8+c1/XB2wWfU9wWg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/84] netfilter: nf_tables: validate NFT_SET_ELEM_INTERVAL_END
Date:   Fri, 27 Dec 2019 12:42:48 -0500
Message-Id: <20191227174352.6264-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit bffc124b6fe37d0ae9b428d104efb426403bb5c9 ]

Only NFTA_SET_ELEM_KEY and NFTA_SET_ELEM_FLAGS make sense for elements
whose NFT_SET_ELEM_INTERVAL_END flag is set on.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e1b1f7f4745..42f79f9532c6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4351,14 +4351,20 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
 		    !(flags & NFT_SET_ELEM_INTERVAL_END))
 			return -EINVAL;
-		if (nla[NFTA_SET_ELEM_DATA] != NULL &&
-		    flags & NFT_SET_ELEM_INTERVAL_END)
-			return -EINVAL;
 	} else {
 		if (nla[NFTA_SET_ELEM_DATA] != NULL)
 			return -EINVAL;
 	}
 
+	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
+	     (nla[NFTA_SET_ELEM_DATA] ||
+	      nla[NFTA_SET_ELEM_OBJREF] ||
+	      nla[NFTA_SET_ELEM_TIMEOUT] ||
+	      nla[NFTA_SET_ELEM_EXPIRATION] ||
+	      nla[NFTA_SET_ELEM_USERDATA] ||
+	      nla[NFTA_SET_ELEM_EXPR]))
+		return -EINVAL;
+
 	timeout = 0;
 	if (nla[NFTA_SET_ELEM_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
-- 
2.20.1

