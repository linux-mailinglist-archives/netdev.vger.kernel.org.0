Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8096936B7A3
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhDZRLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:11:47 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51462 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbhDZRLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:44 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6A21064123;
        Mon, 26 Apr 2021 19:10:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/22] netfilter: nat: move nf_xfrm_me_harder to where it is used
Date:   Mon, 26 Apr 2021 19:10:35 +0200
Message-Id: <20210426171056.345271-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

remove the export and make it static.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h |  2 --
 net/netfilter/nf_nat_core.c    | 37 ---------------------------------
 net/netfilter/nf_nat_proto.c   | 38 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 0d412dd63707..987111ae5240 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -104,8 +104,6 @@ unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
 
-int nf_xfrm_me_harder(struct net *n, struct sk_buff *s, unsigned int family);
-
 static inline int nf_nat_initialized(struct nf_conn *ct,
 				     enum nf_nat_manip_type manip)
 {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index b7c3c902290f..7de595ead06a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -146,43 +146,6 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		return;
 	}
 }
-
-int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
-{
-	struct flowi fl;
-	unsigned int hh_len;
-	struct dst_entry *dst;
-	struct sock *sk = skb->sk;
-	int err;
-
-	err = xfrm_decode_session(skb, &fl, family);
-	if (err < 0)
-		return err;
-
-	dst = skb_dst(skb);
-	if (dst->xfrm)
-		dst = ((struct xfrm_dst *)dst)->route;
-	if (!dst_hold_safe(dst))
-		return -EHOSTUNREACH;
-
-	if (sk && !net_eq(net, sock_net(sk)))
-		sk = NULL;
-
-	dst = xfrm_lookup(net, dst, &fl, sk, 0);
-	if (IS_ERR(dst))
-		return PTR_ERR(dst);
-
-	skb_dst_drop(skb);
-	skb_dst_set(skb, dst);
-
-	/* Change in oif may mean change in hh_len. */
-	hh_len = skb_dst(skb)->dev->hard_header_len;
-	if (skb_headroom(skb) < hh_len &&
-	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
-		return -ENOMEM;
-	return 0;
-}
-EXPORT_SYMBOL(nf_xfrm_me_harder);
 #endif /* CONFIG_XFRM */
 
 /* We keep an extra hash for each conntrack, for fast searching. */
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 4731d21fc3ad..48cc60084d28 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -659,6 +659,44 @@ nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
+#ifdef CONFIG_XFRM
+static int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
+{
+	struct sock *sk = skb->sk;
+	struct dst_entry *dst;
+	unsigned int hh_len;
+	struct flowi fl;
+	int err;
+
+	err = xfrm_decode_session(skb, &fl, family);
+	if (err < 0)
+		return err;
+
+	dst = skb_dst(skb);
+	if (dst->xfrm)
+		dst = ((struct xfrm_dst *)dst)->route;
+	if (!dst_hold_safe(dst))
+		return -EHOSTUNREACH;
+
+	if (sk && !net_eq(net, sock_net(sk)))
+		sk = NULL;
+
+	dst = xfrm_lookup(net, dst, &fl, sk, 0);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	skb_dst_drop(skb);
+	skb_dst_set(skb, dst);
+
+	/* Change in oif may mean change in hh_len. */
+	hh_len = skb_dst(skb)->dev->hard_header_len;
+	if (skb_headroom(skb) < hh_len &&
+	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
+		return -ENOMEM;
+	return 0;
+}
+#endif
+
 static unsigned int
 nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
-- 
2.30.2

