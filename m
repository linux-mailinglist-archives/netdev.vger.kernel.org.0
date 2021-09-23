Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE5415634
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbhIWDkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239131AbhIWDkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BCD6113E;
        Thu, 23 Sep 2021 03:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368315;
        bh=crLakz6dp+PwUr/WqoV21bAV6tZr4/j8KpjawonXH5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuMm7HXUizJTCEYnszLirXG5N63LdCfSd4dYYDbJTZheoNyrXWnfAOFFpfo7/xZFl
         thglLfzM+8nRqcES/fdbd7fCSeteDM/aigXj/j/xnS09nIhW9ydvJX2VIoI8fmi1Tx
         kFNWACTi7xUVQ/nNwLnOKtEZCLZvrq70HQjIz6X9VUZ+AUV5RBy3Pz4rTWDjZdrBkS
         BVvMdHwxijo/cYERcofKUe1rXHrrBC9egGK3xD+Jz32zCEemJTZ+qUfFLXIScdLkOZ
         70B3AQwXDIBTmJJf1IucroMGebNgDYkyGSC9e/VeNUhjcZzP99dGY5tSIJa8l3j1nl
         bJLeGd45F30yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 07/34] ipv6: delay fib6_sernum increase in fib6_add
Date:   Wed, 22 Sep 2021 23:37:55 -0400
Message-Id: <20210923033823.1420814-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033823.1420814-1-sashal@kernel.org>
References: <20210923033823.1420814-1-sashal@kernel.org>
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
index ef75c9b05f17..68e94e9f5089 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1378,7 +1378,6 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
-	int sernum = fib6_new_sernum(info->nl_net);
 
 	if (info->nlh) {
 		if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
@@ -1478,7 +1477,7 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	if (!err) {
 		if (rt->nh)
 			list_add(&rt->nh_list, &rt->nh->f6i_list);
-		__fib6_update_sernum_upto_root(rt, sernum);
+		__fib6_update_sernum_upto_root(rt, fib6_new_sernum(info->nl_net));
 		fib6_start_gc(info->nl_net, rt);
 	}
 
-- 
2.30.2

