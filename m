Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF53D02B2
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhGTT3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:29:18 -0400
Received: from novek.ru ([213.148.174.62]:46314 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhGTT0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:26:25 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1FAEA503E20;
        Tue, 20 Jul 2021 23:04:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1FAEA503E20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626811471; bh=gW3aGHf/lDdAM5zBNFyaoJKkvl1CnxQ7OgOl2qK9pzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4bTo+8zUWD0ygD8+PR+1S42lpYjk6cUhhtsrUsygxgv17cpXKzOmqtzKCRzOZyVP
         Ts2VRayP2kh4Q/5vqsbOTRPAFd6lUonYLypegUm2OOaChlUb/lATSK7YHcslG3XW85
         i32wqH+FA36w1bTDw8XBVTMdOuul37G8NP333I8Q=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RESEND net-next  1/2] net: ipv6: introduce ip6_dst_mtu_maybe_forward
Date:   Tue, 20 Jul 2021 23:06:27 +0300
Message-Id: <20210720200628.16805-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210720200628.16805-1-vfedorenko@novek.ru>
References: <20210720200628.16805-1-vfedorenko@novek.ru>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/net/ip6_route.h            |  5 +++--
 net/ipv6/ip6_output.c              |  2 +-
 net/ipv6/route.c                   | 20 +-------------------
 net/netfilter/nf_flow_table_core.c |  2 +-
 4 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 625a38ccb5d9..820eae3ea95f 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -316,12 +316,13 @@ static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *
 	       !lwtunnel_cmp_encap(nha->fib_nh_lws, nhb->fib_nh_lws);
 }
 
-static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
+static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst,
+						     bool forwarding)
 {
 	struct inet6_dev *idev;
 	unsigned int mtu;
 
-	if (dst_metric_locked(dst, RTAX_MTU)) {
+	if (!forwarding || dst_metric_locked(dst, RTAX_MTU)) {
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 		if (mtu)
 			goto out;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 01bea76e3891..f6bc7828a480 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -607,7 +607,7 @@ int ip6_forward(struct sk_buff *skb)
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

