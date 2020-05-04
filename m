Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94601C3404
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgEDIGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728151AbgEDIGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E519C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7U-00066Y-1k; Mon, 04 May 2020 10:06:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 4/7] xfrm: expose local_rxpmtu via ipv6_stubs
Date:   Mon,  4 May 2020 10:06:06 +0200
Message-Id: <20200504080609.14648-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We cannot call this function from the core kernel unless we would force
CONFIG_IPV6=y.

Therefore expose this via ipv6_stubs so we can call it from net/xfrm
in the followup patch.

Since the call is expected to be unlikely, no extra code for the IPV6=y
case is added and we will always eat the indirection cost.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.26.2

