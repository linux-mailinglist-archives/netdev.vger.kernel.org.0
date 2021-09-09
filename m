Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19354404AFF
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhIILuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241326AbhIILq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0107861205;
        Thu,  9 Sep 2021 11:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187789;
        bh=ze7B5FV3b/CWQmkaH2nhTOx865klHkNYpzxXSArr3fY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inkHa5UYAz+xgzQu54sKatwC/8OPWlCSTG8rhAuhUGg80sMTMlHiFOJUsWdTKWWau
         ZmTEDAoO+IHU2YIHn9SlyAvQAI/GyHwtEradbYXrKJaIQ+UF0vVkjEjQ8erQP7Aqpo
         wILaEY8ehmBjiBaduPjOuMukOpilj1ipN7G6QWwcE8hjkHARI3rZfeGqvwn7cLN3j1
         ZUi9h0GwTGHYBLEtRylgND6OEx9OeLJURZyMVKn9hmSa7HgAmPWeAx8OqoBxE+ZLrX
         ft/oqQZ11MPX3CF7tfjJx1yApN0ku5K/yI/rWaYu7uNG/YqBd3sqFBTjd8ebFZrybW
         AhIFRYquFHLCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 096/252] netfilter: nft_compat: use nfnetlink_unicast()
Date:   Thu,  9 Sep 2021 07:38:30 -0400
Message-Id: <20210909114106.141462-96-sashal@kernel.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 241d1af4c11a75d4c17ecc0193a6ab60553efbfc ]

Use nfnetlink_unicast() which already translates EAGAIN to ENOBUFS,
since EAGAIN is reserved to report missing module dependencies to the
nfnetlink core.

e0241ae6ac59 ("netfilter: use nfnetlink_unicast() forgot to update
this spot.

Reported-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 639c337c885b..272bcdb1392d 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -683,14 +683,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		goto out_put;
 	}
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;
+	ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 out_put:
 	rcu_read_lock();
 	module_put(THIS_MODULE);
-	return ret == -EAGAIN ? -ENOBUFS : ret;
+
+	return ret;
 }
 
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
-- 
2.30.2

