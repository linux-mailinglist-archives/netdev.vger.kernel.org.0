Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144A8415659
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbhIWDlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239132AbhIWDkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D45061152;
        Thu, 23 Sep 2021 03:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368342;
        bh=fqW2KSb0L1fQDtFpqxgu8MLAxrSoETip7ZGJ/QIO488=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6ss2rEMMaTbgMHUVf5sstCytKweSm/sZag/LZEOWR/ERHHjx2B8a2h/cShJROccd
         H5mym5yyPdyA9635xP8cuFPaNQ/NQkdf75inGQLBGNVdV9qLMOaBEouSMXnjA2YUlN
         mfNpkCQ7Ign1wvyND19K+N2994cAdoT739p589WpG7Bl/yqWC2bZxWX8pE6kUwYBac
         TyDbOqf+z8XyQJsiLPc5XQI72EJ1ji9bedmcj8M6lBiffXsqUQ/FI3zEoXCVJtSTEk
         aRlfN/oitGxxR9hYtDrV5nOa/teSC0iJjBnUiYvAufoJNPAHUdzpTm2Coq2DWfWRbi
         WVQ/g1cJvGf6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/19] ipv6: delay fib6_sernum increase in fib6_add
Date:   Wed, 22 Sep 2021 23:38:39 -0400
Message-Id: <20210923033853.1421193-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang kai <zhangkaiheb@126.com>

[ Upstream commit e87b5052271e39d62337ade531992b7e5d8c2cfa ]

only increase fib6_sernum in net namespace after add fib6_info
successfully.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index bb68290ad68d..9a6f66e0e9a2 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1310,7 +1310,6 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
-	int sernum = fib6_new_sernum(info->nl_net);
 
 	if (info->nlh) {
 		if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -1410,7 +1409,7 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	if (!err) {
 		if (rt->nh)
 			list_add(&rt->nh_list, &rt->nh->f6i_list);
-		__fib6_update_sernum_upto_root(rt, sernum);
+		__fib6_update_sernum_upto_root(rt, fib6_new_sernum(info->nl_net));
 		fib6_start_gc(info->nl_net, rt);
 	}
 
-- 
2.30.2

