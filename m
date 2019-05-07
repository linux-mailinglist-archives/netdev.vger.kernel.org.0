Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDBE15BDF
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfEGF6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbfEGFh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:37:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB2C3214AE;
        Tue,  7 May 2019 05:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207447;
        bh=LHiUuJoh83slDEKFzLWLnuKCeQ05X+dfCelRoDDjyrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASjGpjQcP/JW/m7VkMIE6tWujFImq7bxmbii5jSS/8SzJ4ayMucdtevZDG6T3d1s7
         lmkznOAwDhaPnX0LUy/YzHg/b5c7A43RPtKZBp0N/5vH00YjUxh0jHeCIiSAg1t/jR
         GVbRfNracWwEuzHT82CrHTxgYRLmjjqS374VrJLY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 46/81] netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()
Date:   Tue,  7 May 2019 01:35:17 -0400
Message-Id: <20190507053554.30848-46-sashal@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 33d1c018179d0a30c39cc5f1682b77867282694b ]

I believe that "hook->num" can be up to UINT_MAX.  Shifting more than
31 bits would is undefined in C but in practice it would lead to shift
wrapping.  That would lead to an array overflow in nf_tables_addchain():

	ops->hook       = hook.type->hooks[ops->hooknum];

Fixes: fe19c04ca137 ("netfilter: nf_tables: remove nhooks field from struct nft_af_info")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1af54119bafc..f272f9538c44 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1496,7 +1496,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (!(type->hook_mask & (1 << hook->num)))
+	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.20.1

