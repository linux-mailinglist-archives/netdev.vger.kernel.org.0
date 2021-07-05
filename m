Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0909B3BC3B6
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 23:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhGEVkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 17:40:25 -0400
Received: from novek.ru ([213.148.174.62]:46206 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233519AbhGEVjW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 17:39:22 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id DC8DB503BD6;
        Tue,  6 Jul 2021 00:34:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru DC8DB503BD6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1625520875; bh=/PoU6aozizmqRTTPX6WJbI/uL+r4bGsZdMQ3J4XMWkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrEB436MZuxNYM8KhH2eevS7RRSGMrCMP9LfuytfVW9dxW2eIHsLAvAWnIKk7YmUq
         rQmMuVLyidg3t0qn1vLmMojDKNHkhMOPIvDEaBMtbXb0SDN6pAX86cmRgC91AjYC3o
         WkX3ot3wZdeoytTeGNxbQg/tht6KwkflJ5WIQ+Cw=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net-next 2/2] net: ipv4: Consolidate ipv4_mtu and ip_dst_mtu_maybe_forward
Date:   Tue,  6 Jul 2021 00:36:17 +0300
Message-Id: <20210705213617.18317-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210705213617.18317-1-vfedorenko@novek.ru>
References: <20210705213617.18317-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consolidate IPv4 MTU code the same way it is done in IPv6 to have code
aligned in both address families

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/ip.h | 22 ++++++++++++++++++----
 net/ipv4/route.c | 21 +--------------------
 2 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d9683bef8684..9192444f2964 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -436,18 +436,32 @@ static inline bool ip_sk_ignore_df(const struct sock *sk)
 static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
+	const struct rtable *rt = container_of(dst, struct rtable, dst);
 	struct net *net = dev_net(dst->dev);
 	unsigned int mtu;
 
 	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
 	    ip_mtu_locked(dst) ||
-	    !forwarding)
-		return dst_mtu(dst);
+	    !forwarding) {
+		mtu = rt->rt_pmtu;
+		if (mtu && time_before(jiffies, rt->dst.expires))
+			goto out;
+	}
 
 	/* 'forwarding = true' case should always honour route mtu */
 	mtu = dst_metric_raw(dst, RTAX_MTU);
-	if (!mtu)
-		mtu = min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
+	if (mtu)
+		goto out;
+
+	mtu = READ_ONCE(dst->dev->mtu);
+
+	if (unlikely(ip_mtu_locked(dst))) {
+		if (rt->rt_uses_gateway && mtu > 576)
+			mtu = 576;
+	}
+
+out:
+	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
 
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 99c06944501a..04754d55b3c1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1299,26 +1299,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 
 INDIRECT_CALLABLE_SCOPE unsigned int ipv4_mtu(const struct dst_entry *dst)
 {
-	const struct rtable *rt = (const struct rtable *)dst;
-	unsigned int mtu = rt->rt_pmtu;
-
-	if (!mtu || time_after_eq(jiffies, rt->dst.expires))
-		mtu = dst_metric_raw(dst, RTAX_MTU);
-
-	if (mtu)
-		goto out;
-
-	mtu = READ_ONCE(dst->dev->mtu);
-
-	if (unlikely(ip_mtu_locked(dst))) {
-		if (rt->rt_uses_gateway && mtu > 576)
-			mtu = 576;
-	}
-
-out:
-	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
-
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+	return ip_dst_mtu_maybe_forward(dst, false);
 }
 EXPORT_INDIRECT_CALLABLE(ipv4_mtu);
 
-- 
2.18.4

