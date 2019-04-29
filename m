Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D5EB21
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfD2Tue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:50:34 -0400
Received: from mail.us.es ([193.147.175.20]:41696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729287AbfD2Tuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:50:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0D791031CC
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B915DA718
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 21:50:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A92EDA712; Mon, 29 Apr 2019 21:50:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 370B0DA714;
        Mon, 29 Apr 2019 21:50:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Apr 2019 21:50:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E3D264265A32;
        Mon, 29 Apr 2019 21:50:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH 8/9 net-next,v2] netfilter: nf_conntrack_bridge: add support for IPv6
Date:   Mon, 29 Apr 2019 21:50:13 +0200
Message-Id: <20190429195014.4724-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190429195014.4724-1-pablo@netfilter.org>
References: <20190429195014.4724-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_defrag() and br_fragment() indirections are added in case of IPv6 support
comes as a module, to avoid pulling innecessary dependencies in.

The new fraglist iterator and fragment transformer APIs is used to
implement the refragmentation code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/linux/netfilter_ipv6.h             |  50 ++++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c |  59 +++++++++++++-
 net/ipv6/netfilter.c                       | 123 +++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 12113e502656..a21b8c9623ee 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -19,6 +19,7 @@ struct ip6_rt_info {
 };
 
 struct nf_queue_entry;
+struct nf_ct_bridge_frag_data;
 
 /*
  * Hook functions for ipv6 to allow xt_* modules to be built-in even
@@ -39,6 +40,15 @@ struct nf_ipv6_ops {
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
 	int (*reroute)(struct sk_buff *skb, const struct nf_queue_entry *entry);
+#if IS_MODULE(CONFIG_IPV6)
+	int (*br_defrag)(struct net *net, struct sk_buff *skb, u32 user);
+	int (*br_fragment)(struct net *net, struct sock *sk,
+			   struct sk_buff *skb,
+			   struct nf_ct_bridge_frag_data *data,
+			   int (*output)(struct net *, struct sock *sk,
+					 const struct nf_ct_bridge_frag_data *data,
+					 struct sk_buff *));
+#endif
 };
 
 #ifdef CONFIG_NETFILTER
@@ -86,6 +96,46 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 #endif
 }
 
+static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
+				    u32 user)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return 1;
+
+	return v6_ops->br_defrag(net, skb, user);
+#else
+	return nf_ct_frag6_gather(net, skb, user);
+#endif
+}
+
+int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
+		    struct nf_ct_bridge_frag_data *data,
+		    int (*output)(struct net *, struct sock *sk,
+				  const struct nf_ct_bridge_frag_data *data,
+				  struct sk_buff *));
+
+static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
+				     struct sk_buff *skb,
+				     struct nf_ct_bridge_frag_data *data,
+				     int (*output)(struct net *, struct sock *sk,
+						   const struct nf_ct_bridge_frag_data *data,
+						   struct sk_buff *))
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return 1;
+
+	return v6_ops->br_fragment(net, sk, skb, data, output);
+#else
+	return br_ip6_fragment(net, sk, skb, data, output);
+#endif
+}
+
 int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
 
 static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 2571528ed582..b675cd7c1a82 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -163,6 +163,31 @@ static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
+	enum ip_conntrack_info ctinfo;
+	struct br_input_skb_cb cb;
+	const struct nf_conn *ct;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct)
+		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
+
+	br_skb_cb_save(skb, &cb, sizeof(struct inet6_skb_parm));
+
+	err = nf_ipv6_br_defrag(state->net, skb,
+				IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);
+	/* queued */
+	if (err == -EINPROGRESS)
+		return NF_STOLEN;
+
+	br_skb_cb_restore(skb, &cb, IP6CB(skb)->frag_max_size);
+	return err == 0 ? NF_ACCEPT : NF_DROP;
+}
+
 static int nf_ct_br_ip_check(const struct sk_buff *skb)
 {
 	const struct iphdr *iph;
@@ -177,6 +202,23 @@ static int nf_ct_br_ip_check(const struct sk_buff *skb)
 	len = ntohs(iph->tot_len);
 	if (skb->len < nhoff + len ||
 	    len < (iph->ihl * 4))
+                return -1;
+
+	return 0;
+}
+
+static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
+{
+	const struct ipv6hdr *hdr;
+	int nhoff, len;
+
+	nhoff = skb_network_offset(skb);
+	hdr = ipv6_hdr(skb);
+	if (hdr->version != 6)
+		return -1;
+
+	len = ntohs(hdr->payload_len) + sizeof(struct ipv6hdr) + nhoff;
+	if (skb->len < len)
 		return -1;
 
 	return 0;
@@ -212,7 +254,19 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		ret = nf_ct_br_defrag4(skb, &bridge_state);
 		break;
 	case htons(ETH_P_IPV6):
-		/* fall through */
+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			return NF_ACCEPT;
+
+		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
+		if (pskb_trim_rcsum(skb, len))
+			return NF_ACCEPT;
+
+		if (nf_ct_br_ipv6_check(skb))
+			return NF_ACCEPT;
+
+		bridge_state.pf = NFPROTO_IPV6;
+		ret = nf_ct_br_defrag6(skb, &bridge_state);
+		break;
 	default:
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		return NF_ACCEPT;
@@ -254,7 +308,8 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 		nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
 		break;
 	case htons(ETH_P_IPV6):
-		return NF_ACCEPT;
+		nf_br_ip6_fragment(state->net, state->sk, skb, &data, output);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return NF_DROP;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 1240ccd57f39..c6665382acb5 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -16,6 +16,9 @@
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/netfilter/nf_conntrack_bridge.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include "../bridge/br_private.h"
 
 int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 {
@@ -109,6 +112,122 @@ int __nf_ip6_route(struct net *net, struct dst_entry **dst,
 }
 EXPORT_SYMBOL_GPL(__nf_ip6_route);
 
+int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
+		    struct nf_ct_bridge_frag_data *data,
+		    int (*output)(struct net *, struct sock *sk,
+				  const struct nf_ct_bridge_frag_data *data,
+				  struct sk_buff *))
+{
+	int frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+	struct ip6_frag_state state;
+	u8 *prevhdr, nexthdr = 0;
+	unsigned int mtu, hlen;
+	int hroom, err = 0;
+	__be32 frag_id;
+
+	err = ip6_find_1stfragopt(skb, &prevhdr);
+	if (err < 0)
+		goto blackhole;
+	hlen = err;
+	nexthdr = *prevhdr;
+
+	mtu = skb->dev->mtu;
+	if (frag_max_size > mtu ||
+	    frag_max_size < IPV6_MIN_MTU)
+		goto blackhole;
+
+	mtu = frag_max_size;
+	if (mtu < hlen + sizeof(struct frag_hdr) + 8)
+		goto blackhole;
+	mtu -= hlen + sizeof(struct frag_hdr);
+
+	frag_id = ipv6_select_ident(net, &ipv6_hdr(skb)->daddr,
+				    &ipv6_hdr(skb)->saddr);
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    (err = skb_checksum_help(skb)))
+		goto blackhole;
+
+	hroom = LL_RESERVED_SPACE(skb->dev);
+	if (skb_has_frag_list(skb)) {
+		unsigned int first_len = skb_pagelen(skb);
+		struct ip6_fraglist_iter iter;
+		struct sk_buff *frag2;
+
+		if (first_len - hlen > mtu ||
+		    skb_headroom(skb) < (hroom + sizeof(struct frag_hdr)))
+			goto blackhole;
+
+		if (skb_cloned(skb))
+			goto slow_path;
+
+		skb_walk_frags(skb, frag2) {
+			if (frag2->len > mtu ||
+			    skb_headroom(frag2) < (hlen + hroom + sizeof(struct frag_hdr)))
+				goto blackhole;
+
+			/* Partially cloned skb? */
+			if (skb_shared(frag2))
+				goto slow_path;
+		}
+
+		err = ip6_fraglist_init(skb, hlen, prevhdr, nexthdr, frag_id,
+					&iter);
+		if (err < 0)
+			goto blackhole;
+
+		for (;;) {
+			/* Prepare header of the next frame,
+			 * before previous one went down.
+			 */
+			if (iter.frag)
+				ip6_fraglist_prepare(skb, &iter);
+
+			err = output(net, sk, data, skb);
+			if (err || !iter.frag)
+				break;
+
+			skb = ip6_fraglist_next(&iter);
+		}
+
+		kfree(iter.tmp_hdr);
+		if (!err)
+			return 0;
+
+		kfree_skb_list(iter.frag_list);
+		return err;
+	}
+slow_path:
+	/* This is a linearized skbuff, the original geometry is lost for us.
+	 * This may also be a clone skbuff, we could preserve the geometry for
+	 * the copies but probably not worth the effort.
+	 */
+	ip6_frag_init(skb, hlen, mtu, skb->dev->needed_tailroom,
+		      LL_RESERVED_SPACE(skb->dev), prevhdr, nexthdr, frag_id,
+		      &state);
+
+	while (state.left > 0) {
+		struct sk_buff *skb2;
+
+		skb2 = ip6_frag_next(skb, &state);
+		if (IS_ERR(skb2)) {
+			err = PTR_ERR(skb2);
+			goto blackhole;
+		}
+
+		err = output(net, sk, data, skb2);
+		if (err)
+			goto blackhole;
+	}
+	consume_skb(skb);
+	return err;
+
+blackhole:
+	kfree_skb(skb);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(br_ip6_fragment);
+
 static const struct nf_ipv6_ops ipv6ops = {
 #if IS_MODULE(CONFIG_IPV6)
 	.chk_addr		= ipv6_chk_addr,
@@ -119,6 +238,10 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
+#if IS_MODULE(CONFIG_NF_CONNTRACK_BRIDGE)
+	.br_defrag		= nf_ct_frag6_gather,
+	.br_fragment		= br_ip6_fragment,
+#endif
 };
 
 int __init ipv6_netfilter_init(void)
-- 
2.11.0

