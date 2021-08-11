Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAE03E8C5A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhHKItk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44028 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbhHKItj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:39 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id B075460056;
        Wed, 11 Aug 2021 10:48:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/10] netfilter: nft_compat: use nfnetlink_unicast()
Date:   Wed, 11 Aug 2021 10:48:59 +0200
Message-Id: <20210811084908.14744-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use nfnetlink_unicast() which already translates EAGAIN to ENOBUFS,
since EAGAIN is reserved to report missing module dependencies to the
nfnetlink core.

e0241ae6ac59 ("netfilter: use nfnetlink_unicast() forgot to update
this spot.

Reported-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.20.1

