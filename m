Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9A01E7A9D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgE2Ka0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:26 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37590 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2KaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 038592054D;
        Fri, 29 May 2020 12:30:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VpZM285ORg-l; Fri, 29 May 2020 12:30:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DC4F3205CB;
        Fri, 29 May 2020 12:30:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0CE5D31803C0;
 Fri, 29 May 2020 12:30:18 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/11] xfrm: expose local_rxpmtu via ipv6_stubs
Date:   Fri, 29 May 2020 12:30:07 +0200
Message-ID: <20200529103011.30127-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We cannot call this function from the core kernel unless we would force
CONFIG_IPV6=y.

Therefore expose this via ipv6_stubs so we can call it from net/xfrm
in the followup patch.

Since the call is expected to be unlikely, no extra code for the IPV6=y
case is added and we will always eat the indirection cost.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/ipv6_stubs.h | 1 +
 include/net/xfrm.h       | 1 +
 net/ipv6/af_inet6.c      | 1 +
 net/ipv6/xfrm6_output.c  | 2 +-
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 1e9e0cf7dc75..d8ab3872aa2a 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -57,6 +57,7 @@ struct ipv6_stub {
 			      const struct in6_addr *solicited_addr,
 			      bool router, bool solicited, bool override, bool inc_opt);
 #if IS_ENABLED(CONFIG_XFRM)
+	void (*xfrm6_local_rxpmtu)(struct sk_buff *skb, u32 mtu);
 	int (*xfrm6_udp_encap_rcv)(struct sock *sk, struct sk_buff *skb);
 	int (*xfrm6_rcv_encap)(struct sk_buff *skb, int nexthdr, __be32 spi,
 			       int encap_type);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8b956528b6e6..10295ab4cdfb 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1608,6 +1608,7 @@ int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
 			  u8 **prevhdr);
 
 #ifdef CONFIG_XFRM
+void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu);
 int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 int xfrm_user_policy(struct sock *sk, int optname,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index cbbb00bad20e..aa4882929fd0 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -963,6 +963,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
 #if IS_ENABLED(CONFIG_XFRM)
+	.xfrm6_local_rxpmtu = xfrm6_local_rxpmtu,
 	.xfrm6_udp_encap_rcv = xfrm6_udp_encap_rcv,
 	.xfrm6_rcv_encap = xfrm6_rcv_encap,
 #endif
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 855078a43fc7..23e2b52cfba6 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -40,7 +40,7 @@ static int xfrm6_local_dontfrag(struct sk_buff *skb)
 	return 0;
 }
 
-static void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu)
+void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu)
 {
 	struct flowi6 fl6;
 	struct sock *sk = skb->sk;
-- 
2.17.1

