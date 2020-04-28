Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690A61BBC9E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgD1Lkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgD1Lkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 07:40:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026EFC03C1A9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 04:40:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jTOba-0004Pq-Mh; Tue, 28 Apr 2020 13:40:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 4/7] xfrm: expose local_rxpmtu via ipv6_stubs
Date:   Tue, 28 Apr 2020 13:40:25 +0200
Message-Id: <20200428114028.20693-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428114028.20693-1-fw@strlen.de>
References: <20200428114028.20693-1-fw@strlen.de>
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
 include/net/ipv6_stubs.h | 3 +++
 include/net/xfrm.h       | 1 +
 net/ipv6/af_inet6.c      | 4 ++++
 net/ipv6/xfrm6_output.c  | 2 +-
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 3e7d2c0e79ca..6f363ad01fbf 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -56,6 +56,9 @@ struct ipv6_stub {
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
 			      bool router, bool solicited, bool override, bool inc_opt);
+#if IS_ENABLED(CONFIG_XFRM)
+	void (*xfrm6_local_rxpmtu)(struct sk_buff *skb, u32 mtu);
+#endif
 	struct neigh_table *nd_tbl;
 };
 extern const struct ipv6_stub *ipv6_stub __read_mostly;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 5ff10680bc97..4d8be0649464 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1604,6 +1604,7 @@ int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
 			  u8 **prevhdr);
 
 #ifdef CONFIG_XFRM
+void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu);
 int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 int xfrm_user_policy(struct sock *sk, int optname,
 		     u8 __user *optval, int optlen);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 345baa0a754f..2d8cc02057c8 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -60,6 +60,7 @@
 #include <net/calipso.h>
 #include <net/seg6.h>
 #include <net/rpl.h>
+#include <net/xfrm.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -961,6 +962,9 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_del_rt	   = ip6_del_rt,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
+#if IS_ENABLED(CONFIG_XFRM)
+	.xfrm6_local_rxpmtu = xfrm6_local_rxpmtu,
+#endif
 	.nd_tbl	= &nd_tbl,
 };
 
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

