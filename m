Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAFC1C3402
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgEDIGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgEDIGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB14C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7Q-000660-Nn; Mon, 04 May 2020 10:06:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 2/7] xfrm: state: remove extract_input indirection from xfrm_state_afinfo
Date:   Mon,  4 May 2020 10:06:04 +0200
Message-Id: <20200504080609.14648-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to keep CONFIG_IPV6=m working, xfrm6_extract_header needs to be
duplicated.  It will be removed again in a followup change when the
remaining caller is moved to net/xfrm as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.26.2

