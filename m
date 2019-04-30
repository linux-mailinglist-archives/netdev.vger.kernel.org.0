Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552BBF091
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfD3Gh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48842 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfD3Ghi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 69DD620275;
        Tue, 30 Apr 2019 08:37:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XXs17kx1ofsg; Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3DD682027A;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 334BF3180628;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 11/18] xfrm: remove afinfo pointer from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:20 +0200
Message-ID: <20190430063727.10908-12-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 3F88323C-CD4F-47FE-914E-9A6805FE48B9
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Adds an EXPORT_SYMBOL for afinfo_get_rcu, as it will now be called from
ipv6 in case of CONFIG_IPV6=m.

This change has virtually no effect on vmlinux size, but it reduces
afinfo size and allows followup patch to make xfrm modes const.

v2: mark if (afinfo) tests as likely (Sabrina)
    re-fetch afinfo according to inner_mode in xfrm_prepare_input().

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  1 -
 net/ipv4/xfrm4_output.c | 12 +++++++++++-
 net/ipv6/xfrm6_output.c | 21 +++++++++++++++++++--
 net/xfrm/xfrm_input.c   | 34 ++++++++++++++++++++++++++++------
 net/xfrm/xfrm_output.c  | 12 +++++++++++-
 net/xfrm/xfrm_policy.c  | 10 +++++++++-
 net/xfrm/xfrm_state.c   |  4 ++--
 7 files changed, 80 insertions(+), 14 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4351444c10fc..8d1c9506bcf6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -423,7 +423,6 @@ int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned sh
 int xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 
 struct xfrm_mode {
-	struct xfrm_state_afinfo *afinfo;
 	struct module *owner;
 	u8 encap;
 	u8 family;
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 6802d1aee424..7c3df14daef3 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -72,6 +72,8 @@ int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb)
 static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
+	const struct xfrm_state_afinfo *afinfo;
+	int ret = -EAFNOSUPPORT;
 
 #ifdef CONFIG_NETFILTER
 	if (!x) {
@@ -80,7 +82,15 @@ static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	}
 #endif
 
-	return x->outer_mode->afinfo->output_finish(sk, skb);
+	rcu_read_lock();
+	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode->family);
+	if (likely(afinfo))
+		ret = afinfo->output_finish(sk, skb);
+	else
+		kfree_skb(skb);
+	rcu_read_unlock();
+
+	return ret;
 }
 
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 2b663d2ffdcd..455fbf3b91cf 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -122,11 +122,28 @@ int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
 	return xfrm_output(sk, skb);
 }
 
+static int __xfrm6_output_state_finish(struct xfrm_state *x, struct sock *sk,
+				       struct sk_buff *skb)
+{
+	const struct xfrm_state_afinfo *afinfo;
+	int ret = -EAFNOSUPPORT;
+
+	rcu_read_lock();
+	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode->family);
+	if (likely(afinfo))
+		ret = afinfo->output_finish(sk, skb);
+	else
+		kfree_skb(skb);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int __xfrm6_output_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 
-	return x->outer_mode->afinfo->output_finish(sk, skb);
+	return __xfrm6_output_state_finish(x, sk, skb);
 }
 
 static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
@@ -168,7 +185,7 @@ static int __xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 				    __xfrm6_output_finish);
 
 skip_frag:
-	return x->outer_mode->afinfo->output_finish(sk, skb);
+	return __xfrm6_output_state_finish(x, sk, skb);
 }
 
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index e0fd9561ffe5..74b53c13279b 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -352,19 +352,35 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	struct xfrm_mode *inner_mode = x->inner_mode;
-	int err;
+	const struct xfrm_state_afinfo *afinfo;
+	int err = -EAFNOSUPPORT;
 
-	err = x->outer_mode->afinfo->extract_input(x, skb);
-	if (err)
+	rcu_read_lock();
+	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode->family);
+	if (likely(afinfo))
+		err = afinfo->extract_input(x, skb);
+
+	if (err) {
+		rcu_read_unlock();
 		return err;
+	}
 
 	if (x->sel.family == AF_UNSPEC) {
 		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
-		if (inner_mode == NULL)
+		if (!inner_mode) {
+			rcu_read_unlock();
 			return -EAFNOSUPPORT;
+		}
 	}
 
-	skb->protocol = inner_mode->afinfo->eth_proto;
+	afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
+	if (unlikely(!afinfo)) {
+		rcu_read_unlock();
+		return -EAFNOSUPPORT;
+	}
+
+	skb->protocol = afinfo->eth_proto;
+	rcu_read_unlock();
 	return xfrm_inner_mode_encap_remove(x, inner_mode, skb);
 }
 
@@ -440,6 +456,7 @@ static int xfrm_inner_mode_input(struct xfrm_state *x,
 
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
+	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = dev_net(skb->dev);
 	int err;
 	__be32 seq;
@@ -705,7 +722,12 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		if (xo)
 			xfrm_gro = xo->flags & XFRM_GRO;
 
-		err = x->inner_mode->afinfo->transport_finish(skb, xfrm_gro || async);
+		err = -EAFNOSUPPORT;
+		rcu_read_lock();
+		afinfo = xfrm_state_afinfo_get_rcu(x->inner_mode->family);
+		if (likely(afinfo))
+			err = afinfo->transport_finish(skb, xfrm_gro || async);
+		rcu_read_unlock();
 		if (xfrm_gro) {
 			sp = skb_sec_path(skb);
 			if (sp)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9bdf16f13606..17c4f58d28ea 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -623,7 +623,10 @@ EXPORT_SYMBOL_GPL(xfrm_output);
 
 static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
+	const struct xfrm_state_afinfo *afinfo;
 	struct xfrm_mode *inner_mode;
+	int err = -EAFNOSUPPORT;
+
 	if (x->sel.family == AF_UNSPEC)
 		inner_mode = xfrm_ip2inner_mode(x,
 				xfrm_af2proto(skb_dst(skb)->ops->family));
@@ -632,7 +635,14 @@ static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	if (inner_mode == NULL)
 		return -EAFNOSUPPORT;
-	return inner_mode->afinfo->extract_output(x, skb);
+
+	rcu_read_lock();
+	afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
+	if (likely(afinfo))
+		err = afinfo->extract_output(x, skb);
+	rcu_read_unlock();
+
+	return err;
 }
 
 void xfrm_local_error(struct sk_buff *skb, int mtu)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 8d1a898d0ba5..67122beb116c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2545,6 +2545,7 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 					    const struct flowi *fl,
 					    struct dst_entry *dst)
 {
+	const struct xfrm_state_afinfo *afinfo;
 	struct net *net = xp_net(policy);
 	unsigned long now = jiffies;
 	struct net_device *dev;
@@ -2622,7 +2623,14 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 		dst1->lastuse = now;
 
 		dst1->input = dst_discard;
-		dst1->output = inner_mode->afinfo->output;
+
+		rcu_read_lock();
+		afinfo = xfrm_state_afinfo_get_rcu(inner_mode->family);
+		if (likely(afinfo))
+			dst1->output = afinfo->output;
+		else
+			dst1->output = dst_discard_out;
+		rcu_read_unlock();
 
 		xdst_prev = xdst;
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c32394b59776..358b09f0d018 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -354,7 +354,6 @@ int xfrm_register_mode(struct xfrm_mode *mode)
 	if (!try_module_get(afinfo->owner))
 		goto out;
 
-	mode->afinfo = afinfo;
 	modemap[mode->encap] = mode;
 	err = 0;
 
@@ -378,7 +377,7 @@ void xfrm_unregister_mode(struct xfrm_mode *mode)
 	spin_lock_bh(&xfrm_mode_lock);
 	if (likely(modemap[mode->encap] == mode)) {
 		modemap[mode->encap] = NULL;
-		module_put(mode->afinfo->owner);
+		module_put(afinfo->owner);
 	}
 
 	spin_unlock_bh(&xfrm_mode_lock);
@@ -2188,6 +2187,7 @@ struct xfrm_state_afinfo *xfrm_state_afinfo_get_rcu(unsigned int family)
 
 	return rcu_dereference(xfrm_state_afinfo[family]);
 }
+EXPORT_SYMBOL_GPL(xfrm_state_afinfo_get_rcu);
 
 struct xfrm_state_afinfo *xfrm_state_get_afinfo(unsigned int family)
 {
-- 
2.17.1

