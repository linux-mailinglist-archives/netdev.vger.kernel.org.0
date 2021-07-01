Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521DB3B8BBA
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 03:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhGABUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 21:20:10 -0400
Received: from novek.ru ([213.148.174.62]:59392 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238352AbhGABUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 21:20:09 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 23695503C0F;
        Thu,  1 Jul 2021 04:15:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 23695503C0F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625102136; bh=NQUurqQ0XpgIceRk7xT+4ni893tKBP1oaQXN708e3RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Em7hCT72d/DLnYuQyglDx1Qt3j3qG6CXPFO+dAf2jg5arnNj+7KBZHpnh/tZKlPD+
         jHSyWUK1kDctB0F1bkn4aiq2LEfiAPwpfZtTrbLfAzVEbrRv3HaLgw0vliBW0q7twH
         CsPtEDCDyj6uGCkrwYdVKc7ZiJYpQ3IOGhkWPhC8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [RFC net-next 1/2] net: ipv6: introduce ip6_dst_mtu_maybe_forward
Date:   Thu,  1 Jul 2021 04:17:27 +0300
Message-Id: <20210701011728.22626-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210701011728.22626-1-vfedorenko@novek.ru>
References: <20210701011728.22626-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace ip6_dst_mtu_forward with ip6_dst_mtu_maybe_forward and
reuse this code in ip6_mtu. Actually these two functions were
almost duplicates, this change will simplify the maintaince of
mtu calculation code.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/ip6_route.h            |  5 +++--
 net/ipv6/ip6_output.c              |  2 +-
 net/ipv6/route.c                   | 20 +-------------------
 net/netfilter/nf_flow_table_core.c |  2 +-
 4 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index f14149df5a65..322960506528 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -316,12 +316,13 @@ static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *
 	       !lwtunnel_cmp_encap(nha->fib_nh_lws, nhb->fib_nh_lws);
 }
 
-static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
+static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst,
+						      bool forwarding)
 {
 	struct inet6_dev *idev;
 	unsigned int mtu;
 
-	if (dst_metric_locked(dst, RTAX_MTU)) {
+	if (!forwarding || dst_metric_locked(dst, RTAX_MTU)) {
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 		if (mtu)
 			goto out;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 984050f35c61..bdfe96fe6fc3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -577,7 +577,7 @@ int ip6_forward(struct sk_buff *skb)
 		}
 	}
 
-	mtu = ip6_dst_mtu_forward(dst);
+	mtu = ip6_dst_mtu_maybe_forward(dst, true);
 	if (mtu < IPV6_MIN_MTU)
 		mtu = IPV6_MIN_MTU;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7b756a7dc036..da2c651325e2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3201,25 +3201,7 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 
 INDIRECT_CALLABLE_SCOPE unsigned int ip6_mtu(const struct dst_entry *dst)
 {
-	struct inet6_dev *idev;
-	unsigned int mtu;
-
-	mtu = dst_metric_raw(dst, RTAX_MTU);
-	if (mtu)
-		goto out;
-
-	mtu = IPV6_MIN_MTU;
-
-	rcu_read_lock();
-	idev = __in6_dev_get(dst->dev);
-	if (idev)
-		mtu = idev->cnf.mtu6;
-	rcu_read_unlock();
-
-out:
-	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
-
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+	return ip6_dst_mtu_maybe_forward(dst, false);
 }
 EXPORT_INDIRECT_CALLABLE(ip6_mtu);
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1e50908b1b7e..8fe024a0ae46 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -99,7 +99,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
 	case NFPROTO_IPV6:
-		flow_tuple->mtu = ip6_dst_mtu_forward(dst);
+		flow_tuple->mtu = ip6_dst_mtu_maybe_forward(dst, true);
 		break;
 	}
 
-- 
2.18.4

