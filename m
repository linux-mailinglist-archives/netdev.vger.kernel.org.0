Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC21E7AA0
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgE2Kal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:41 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37602 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgE2KaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id ABD912057B;
        Fri, 29 May 2020 12:30:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4DrRoEDPO_34; Fri, 29 May 2020 12:30:21 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DDB97205CD;
        Fri, 29 May 2020 12:30:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 04FDE3180317;
 Fri, 29 May 2020 12:30:18 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 05/11] xfrm: state: remove extract_input indirection from xfrm_state_afinfo
Date:   Fri, 29 May 2020 12:30:05 +0200
Message-ID: <20200529103011.30127-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

In order to keep CONFIG_IPV6=m working, xfrm6_extract_header needs to be
duplicated.  It will be removed again in a followup change when the
remaining caller is moved to net/xfrm as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  3 ---
 net/ipv4/xfrm4_input.c  |  5 -----
 net/ipv4/xfrm4_state.c  |  1 -
 net/ipv6/xfrm6_input.c  |  5 -----
 net/ipv6/xfrm6_output.c | 17 ++++++++++++++++-
 net/ipv6/xfrm6_state.c  | 24 ------------------------
 net/xfrm/xfrm_inout.h   | 18 ++++++++++++++++++
 net/xfrm/xfrm_input.c   | 21 +++++++++++----------
 8 files changed, 45 insertions(+), 49 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 397007324abd..a21c1dea5340 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -362,8 +362,6 @@ struct xfrm_state_afinfo {
 
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int			(*output_finish)(struct sock *sk, struct sk_buff *skb);
-	int			(*extract_input)(struct xfrm_state *x,
-						 struct sk_buff *skb);
 	int			(*extract_output)(struct xfrm_state *x,
 						  struct sk_buff *skb);
 	int			(*transport_finish)(struct sk_buff *skb,
@@ -1587,7 +1585,6 @@ int xfrm4_protocol_deregister(struct xfrm4_protocol *handler, unsigned char prot
 int xfrm4_tunnel_register(struct xfrm_tunnel *handler, unsigned short family);
 int xfrm4_tunnel_deregister(struct xfrm_tunnel *handler, unsigned short family);
 void xfrm4_local_error(struct sk_buff *skb, u32 mtu);
-int xfrm6_extract_header(struct sk_buff *skb);
 int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi,
 		  struct ip6_tnl *t);
diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index f8de2482a529..ad2afeef4f10 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -18,11 +18,6 @@
 #include <net/ip.h>
 #include <net/xfrm.h>
 
-int xfrm4_extract_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	return xfrm4_extract_header(skb);
-}
-
 static int xfrm4_rcv_encap_finish2(struct net *net, struct sock *sk,
 				   struct sk_buff *skb)
 {
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index d7c200779e4f..521fc1bc069c 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -36,7 +36,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.proto			= IPPROTO_IPIP,
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
-	.extract_input		= xfrm4_extract_input,
 	.transport_finish	= xfrm4_transport_finish,
 	.local_error		= xfrm4_local_error,
 };
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 56f52353b324..04cbeefd8982 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -17,11 +17,6 @@
 #include <net/ipv6.h>
 #include <net/xfrm.h>
 
-int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	return xfrm6_extract_header(skb);
-}
-
 int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi,
 		  struct ip6_tnl *t)
 {
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index fbe51d40bd7e..855078a43fc7 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -94,6 +94,20 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 	return ret;
 }
 
+static void __xfrm6_extract_header(struct sk_buff *skb)
+{
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+
+	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
+	XFRM_MODE_SKB_CB(skb)->id = 0;
+	XFRM_MODE_SKB_CB(skb)->frag_off = htons(IP_DF);
+	XFRM_MODE_SKB_CB(skb)->tos = ipv6_get_dsfield(iph);
+	XFRM_MODE_SKB_CB(skb)->ttl = iph->hop_limit;
+	XFRM_MODE_SKB_CB(skb)->optlen = 0;
+	memcpy(XFRM_MODE_SKB_CB(skb)->flow_lbl, iph->flow_lbl,
+	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
+}
+
 int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err;
@@ -104,7 +118,8 @@ int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	XFRM_MODE_SKB_CB(skb)->protocol = ipv6_hdr(skb)->nexthdr;
 
-	return xfrm6_extract_header(skb);
+	__xfrm6_extract_header(skb);
+	return 0;
 }
 
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 78daadecbdef..8fbf5a68ee6e 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -13,36 +13,12 @@
  */
 
 #include <net/xfrm.h>
-#include <linux/pfkeyv2.h>
-#include <linux/ipsec.h>
-#include <linux/netfilter_ipv6.h>
-#include <linux/export.h>
-#include <net/dsfield.h>
-#include <net/ipv6.h>
-#include <net/addrconf.h>
-
-int xfrm6_extract_header(struct sk_buff *skb)
-{
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-
-	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
-	XFRM_MODE_SKB_CB(skb)->id = 0;
-	XFRM_MODE_SKB_CB(skb)->frag_off = htons(IP_DF);
-	XFRM_MODE_SKB_CB(skb)->tos = ipv6_get_dsfield(iph);
-	XFRM_MODE_SKB_CB(skb)->ttl = iph->hop_limit;
-	XFRM_MODE_SKB_CB(skb)->optlen = 0;
-	memcpy(XFRM_MODE_SKB_CB(skb)->flow_lbl, iph->flow_lbl,
-	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
-
-	return 0;
-}
 
 static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.family			= AF_INET6,
 	.proto			= IPPROTO_IPV6,
 	.output			= xfrm6_output,
 	.output_finish		= xfrm6_output_finish,
-	.extract_input		= xfrm6_extract_input,
 	.extract_output		= xfrm6_extract_output,
 	.transport_finish	= xfrm6_transport_finish,
 	.local_error		= xfrm6_local_error,
diff --git a/net/xfrm/xfrm_inout.h b/net/xfrm/xfrm_inout.h
index c7b0318938e2..e24abac92dc2 100644
--- a/net/xfrm/xfrm_inout.h
+++ b/net/xfrm/xfrm_inout.h
@@ -6,6 +6,24 @@
 #ifndef XFRM_INOUT_H
 #define XFRM_INOUT_H 1
 
+static inline void xfrm6_extract_header(struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+
+	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
+	XFRM_MODE_SKB_CB(skb)->id = 0;
+	XFRM_MODE_SKB_CB(skb)->frag_off = htons(IP_DF);
+	XFRM_MODE_SKB_CB(skb)->tos = ipv6_get_dsfield(iph);
+	XFRM_MODE_SKB_CB(skb)->ttl = iph->hop_limit;
+	XFRM_MODE_SKB_CB(skb)->optlen = 0;
+	memcpy(XFRM_MODE_SKB_CB(skb)->flow_lbl, iph->flow_lbl,
+	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
+#else
+	WARN_ON_ONCE(1);
+#endif
+}
+
 static inline void xfrm6_beet_make_header(struct sk_buff *skb)
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index aa35f23c4912..6db266a0cb2d 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -353,17 +353,18 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	const struct xfrm_mode *inner_mode = &x->inner_mode;
-	const struct xfrm_state_afinfo *afinfo;
-	int err = -EAFNOSUPPORT;
-
-	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
-	if (likely(afinfo))
-		err = afinfo->extract_input(x, skb);
-	rcu_read_unlock();
 
-	if (err)
-		return err;
+	switch (x->outer_mode.family) {
+	case AF_INET:
+		xfrm4_extract_header(skb);
+		break;
+	case AF_INET6:
+		xfrm6_extract_header(skb);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EAFNOSUPPORT;
+	}
 
 	if (x->sel.family == AF_UNSPEC) {
 		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-- 
2.17.1

