Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6922B60291
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfGEIqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:24 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37480 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbfGEIqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5146820257;
        Fri,  5 Jul 2019 10:46:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aJw6lmAxivI5; Fri,  5 Jul 2019 10:46:16 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4125E201C6;
        Fri,  5 Jul 2019 10:46:15 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 533713180879;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/9] xfrm: remove eth_proto value from xfrm_state_afinfo
Date:   Fri, 5 Jul 2019 10:46:06 +0200
Message-ID: <20190705084610.3646-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

xfrm_prepare_input needs to lookup the state afinfo backend again to fetch
the address family ethernet protocol value.

There are only two address families, so a switch statement is simpler.
While at it, use u8 for family and proto and remove the owner member --
its not used anywhere.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  6 ++----
 net/ipv4/xfrm4_state.c |  2 --
 net/ipv6/xfrm6_state.c |  2 --
 net/xfrm/xfrm_input.c  | 24 ++++++++++++------------
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4325cb708ed4..812994ad49ac 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -346,10 +346,8 @@ void km_state_expired(struct xfrm_state *x, int hard, u32 portid);
 int __xfrm_state_delete(struct xfrm_state *x);
 
 struct xfrm_state_afinfo {
-	unsigned int			family;
-	unsigned int			proto;
-	__be16				eth_proto;
-	struct module			*owner;
+	u8				family;
+	u8				proto;
 	const struct xfrm_type		*type_map[IPPROTO_MAX];
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index 62c96da38b4e..f8ed3c3bb928 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -34,8 +34,6 @@ int xfrm4_extract_header(struct sk_buff *skb)
 static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.family			= AF_INET,
 	.proto			= IPPROTO_IPIP,
-	.eth_proto		= htons(ETH_P_IP),
-	.owner			= THIS_MODULE,
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
 	.extract_input		= xfrm4_extract_input,
diff --git a/net/ipv6/xfrm6_state.c b/net/ipv6/xfrm6_state.c
index 1782ebb22dd3..78daadecbdef 100644
--- a/net/ipv6/xfrm6_state.c
+++ b/net/ipv6/xfrm6_state.c
@@ -40,8 +40,6 @@ int xfrm6_extract_header(struct sk_buff *skb)
 static struct xfrm_state_afinfo xfrm6_state_afinfo = {
 	.family			= AF_INET6,
 	.proto			= IPPROTO_IPV6,
-	.eth_proto		= htons(ETH_P_IPV6),
-	.owner			= THIS_MODULE,
 	.output			= xfrm6_output,
 	.output_finish		= xfrm6_output_finish,
 	.extract_input		= xfrm6_extract_input,
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 314973aaa414..8a00cc94c32c 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -359,28 +359,28 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
 	if (likely(afinfo))
 		err = afinfo->extract_input(x, skb);
+	rcu_read_unlock();
 
-	if (err) {
-		rcu_read_unlock();
+	if (err)
 		return err;
-	}
 
 	if (x->sel.family == AF_UNSPEC) {
 		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-		if (!inner_mode) {
-			rcu_read_unlock();
+		if (!inner_mode)
 			return -EAFNOSUPPORT;
-		}
 	}
 
-	afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
-	if (unlikely(!afinfo)) {
-		rcu_read_unlock();
-		return -EAFNOSUPPORT;
+	switch (inner_mode->family) {
+	case AF_INET:
+		skb->protocol = htons(ETH_P_IP);
+		break;
+	case AF_INET6:
+		skb->protocol = htons(ETH_P_IPV6);
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 
-	skb->protocol = afinfo->eth_proto;
-	rcu_read_unlock();
 	return xfrm_inner_mode_encap_remove(x, inner_mode, skb);
 }
 
-- 
2.17.1

