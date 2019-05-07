Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974E915C87
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEGGE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfEGFem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:34:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52508206A3;
        Tue,  7 May 2019 05:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207282;
        bh=CdbYZwttP0Dk7wLa6pPFBPjW3l9RlCCWUUJXA3PirFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkOupZ69hKtq9jMfm7qOA80Vr5Y+WNnb0gJktsKeo85AV2eR4fYtNSxZJsiNLj655
         xfEdqdGXS2K11Fll8sTu5Y3YChG5vr4jUQKaiE8uFTo0LvXrKoHhrvSM5yF6XTzjI7
         4nyD4DFRFEeFJxJ5Wkte5kJU8CynPg0+RFWS7ZYc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 64/99] netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()
Date:   Tue,  7 May 2019 01:31:58 -0400
Message-Id: <20190507053235.29900-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
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
index e2aac80f9b7b..25c2b98b9a96 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1502,7 +1502,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (!(type->hook_mask & (1 << hook->num)))
+	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.20.1

