Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6C11C3403
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgEDIGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgEDIGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:06:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6A5C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:06:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jVW7S-00066J-CR; Mon, 04 May 2020 10:06:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     steffen.klassert@secunet.com
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next v2 3/7] xfrm: move xfrm4_extract_header to common helper
Date:   Mon,  4 May 2020 10:06:05 +0200
Message-Id: <20200504080609.14648-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504080609.14648-1-fw@strlen.de>
References: <20200504080609.14648-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function only initializes the XFRM CB in the skb.

After previous patch xfrm4_extract_header is only called from
net/xfrm/xfrm_{input,output}.c.

Because of IPV6=m linker errors the ipv6 equivalent
(xfrm6_extract_header) was already placed in xfrm_inout.h because
we can't call functions residing in a module from the core.

So do the same for the ipv4 helper and place it next to the ipv6 one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/xfrm.h     |  1 -
 net/ipv4/xfrm4_state.c | 21 ---------------------
 net/xfrm/xfrm_inout.h  | 14 ++++++++++++++
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index a21c1dea5340..8b956528b6e6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1562,7 +1562,6 @@ int pktgen_xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb);
 #endif
 
 void xfrm_local_error(struct sk_buff *skb, int mtu);
-int xfrm4_extract_header(struct sk_buff *skb);
 int xfrm4_extract_input(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 		    int encap_type);
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index 521fc1bc069c..b23a1711297b 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -8,28 +8,7 @@
  *
  */
 
-#include <net/ip.h>
 #include <net/xfrm.h>
-#include <linux/pfkeyv2.h>
-#include <linux/ipsec.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/export.h>
-
-int xfrm4_extract_header(struct sk_buff *skb)
-{
-	const struct iphdr *iph = ip_hdr(skb);
-
-	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
-	XFRM_MODE_SKB_CB(skb)->id = iph->id;
-	XFRM_MODE_SKB_CB(skb)->frag_off = iph->frag_off;
-	XFRM_MODE_SKB_CB(skb)->tos = iph->tos;
-	XFRM_MODE_SKB_CB(skb)->ttl = iph->ttl;
-	XFRM_MODE_SKB_CB(skb)->optlen = iph->ihl * 4 - sizeof(*iph);
-	memset(XFRM_MODE_SKB_CB(skb)->flow_lbl, 0,
-	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
-
-	return 0;
-}
 
 static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.family			= AF_INET,
diff --git a/net/xfrm/xfrm_inout.h b/net/xfrm/xfrm_inout.h
index e24abac92dc2..efc5e6b2e87b 100644
--- a/net/xfrm/xfrm_inout.h
+++ b/net/xfrm/xfrm_inout.h
@@ -6,6 +6,20 @@
 #ifndef XFRM_INOUT_H
 #define XFRM_INOUT_H 1
 
+static inline void xfrm4_extract_header(struct sk_buff *skb)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+
+	XFRM_MODE_SKB_CB(skb)->ihl = sizeof(*iph);
+	XFRM_MODE_SKB_CB(skb)->id = iph->id;
+	XFRM_MODE_SKB_CB(skb)->frag_off = iph->frag_off;
+	XFRM_MODE_SKB_CB(skb)->tos = iph->tos;
+	XFRM_MODE_SKB_CB(skb)->ttl = iph->ttl;
+	XFRM_MODE_SKB_CB(skb)->optlen = iph->ihl * 4 - sizeof(*iph);
+	memset(XFRM_MODE_SKB_CB(skb)->flow_lbl, 0,
+	       sizeof(XFRM_MODE_SKB_CB(skb)->flow_lbl));
+}
+
 static inline void xfrm6_extract_header(struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.26.2

