Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2AF1E7A9F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgE2Kai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:38 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37606 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgE2KaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2EB11205CB;
        Fri, 29 May 2020 12:30:22 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id V0gocSZNAlPQ; Fri, 29 May 2020 12:30:21 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1E3B1201E5;
        Fri, 29 May 2020 12:30:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 091B4318032D;
 Fri, 29 May 2020 12:30:18 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/11] xfrm: move xfrm4_extract_header to common helper
Date:   Fri, 29 May 2020 12:30:06 +0200
Message-ID: <20200529103011.30127-7-steffen.klassert@secunet.com>
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

The function only initializes the XFRM CB in the skb.

After previous patch xfrm4_extract_header is only called from
net/xfrm/xfrm_{input,output}.c.

Because of IPV6=m linker errors the ipv6 equivalent
(xfrm6_extract_header) was already placed in xfrm_inout.h because
we can't call functions residing in a module from the core.

So do the same for the ipv4 helper and place it next to the ipv6 one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
2.17.1

