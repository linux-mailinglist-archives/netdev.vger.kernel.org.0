Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9828443B528
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhJZPNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhJZPNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:13:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0D2C061767
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:10:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v1-20020a17090a088100b001a21156830bso2561560pjc.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xlGeqIsszCuuW3Pvn49Cq+sYRHriXXlU/fpijBMKh/M=;
        b=ZBk/gXwPQ4amQIHPxXWlfL5V3UpsfP64ePGj7fBdSyl0KU2VyurA+GLkCQE+3ECkQg
         2QnCSQNJRx9WC+W0Muuk8mbE9XBQyZfHWM2yekecR8SWadfDJYixBmMjYsG0he1nLw8J
         5HK/KZwxojBJZmZINfOnoskP41sN2I3uILVoI3i7pq5ZM2xQ42t4yO5nuAZnkKevRH/P
         u/amrOgPvUMUJbXbm97tvw+6NgSjvR3qC0YhqlaSJ14jerefl3rGvAHquvVdAQUq477f
         J+06G3UhuAyllTSIBnOC/IUqIBr50T8c/1qoAuAoZ1aeyKUU8moTfatPJIy4ykPMpoA7
         WCXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xlGeqIsszCuuW3Pvn49Cq+sYRHriXXlU/fpijBMKh/M=;
        b=FJKfwPiBSP0Bs3owODYdAGHbEONJcpgE/04y/Ah8ZSicutC4AIp2FYKKIJREuAlSLo
         3ZTmstYIYDEnACj9Pty9ZbCoJWb59Vi9ytWJ+/W1ZGQJLqFBKS70E+M6xL/Lyg6vWC+G
         p/fplAcrGVIdkkpzvMo/9WDdqaMyz8hqaMIaQlQ7+p8JYwGM+g9nePiO8G6AlDre3+V5
         RYKiYMj0zx7CyXcT1+EZwnPTzl0x3PiL/ORHbJEf/LAD0OQqDL+Bu+LdgB3dAFyVILsx
         Oi6oWCAGnB6xbUNidPXkbyEzT2Ky3UPX+Qds7f39c7kMafbUF8JxNZpwcS+dRCbzOdzU
         90Dw==
X-Gm-Message-State: AOAM532Sb2vlJbOCi+fFD8fuZgLmKDnqMveCynpdBERKPsebS3ZxVHXD
        mQ0DO14+MtbzElvZ6jCW4bE=
X-Google-Smtp-Source: ABdhPJx9VT+FafvTvWpwXftyd+3JPnXf8wwjH5gCG7Qt5IpcxgCxV73V/UQ4gOQ4KmzC4jdyfJ0ZLQ==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr10876577pjb.241.1635261046485;
        Tue, 26 Oct 2021 08:10:46 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id p1sm10911009pfo.143.2021.10.26.08.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 08:10:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next 4/4 v4] amt: add mld report message handler
Date:   Tue, 26 Oct 2021 15:10:16 +0000
Message-Id: <20211026151016.25997-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211026151016.25997-1-ap420073@gmail.com>
References: <20211026151016.25997-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous patch, igmp report handler was added.
That handler can be used for mld too.
So, it uses that common code to parse mld report message.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Eliminate sparse warnings
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.

 drivers/net/amt.c | 453 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 446 insertions(+), 7 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 280415b893bc..3eb96134a0a0 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -31,13 +31,10 @@
 
 static struct workqueue_struct *amt_wq;
 
-static struct igmpv3_grec igmpv3_zero_grec;
-
 static HLIST_HEAD(source_gc_list);
 /* Lock for source_gc_list */
 static spinlock_t source_gc_lock;
 static struct delayed_work source_gc_wq;
-
 static char *status_str[] = {
 	"AMT_STATUS_INIT",
 	"AMT_STATUS_SENT_DISCOVERY",
@@ -71,6 +68,14 @@ static char *action_str[] = {
 	"AMT_ACT_STATUS_NONE_NEW",
 };
 
+static struct igmpv3_grec igmpv3_zero_grec;
+
+#if IS_ENABLED(CONFIG_IPV6)
+#define MLD2_ALL_NODE_INIT { { { 0xff, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x01 } } }
+static struct in6_addr mld2_all_node = MLD2_ALL_NODE_INIT;
+static struct mld2_grec mldv2_zero_grec;
+#endif
+
 static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
 {
 	return (struct amt_skb_cb *)((void *)skb->cb +
@@ -225,6 +230,13 @@ static void amt_destroy_source(struct amt_source_node *snode)
 			   "Delete source %pI4 from %pI4\n",
 			   &snode->source_addr.ip4,
 			   &gnode->group_addr.ip4);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		netdev_dbg(snode->gnode->amt->dev,
+			   "Delete source %pI6 from %pI6\n",
+			   &snode->source_addr.ip6,
+			   &gnode->group_addr.ip6);
+#endif
 	}
 
 	cancel_delayed_work(&snode->source_timer);
@@ -250,6 +262,11 @@ static void amt_del_group(struct amt_dev *amt, struct amt_group_node *gnode)
 	if (!gnode->v6)
 		netdev_dbg(amt->dev, "Leave group %pI4\n",
 			   &gnode->group_addr.ip4);
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		netdev_dbg(amt->dev, "Leave group %pI6\n",
+			   &gnode->group_addr.ip6);
+#endif
 	for (i = 0; i < amt->hash_buckets; i++)
 		hlist_for_each_entry_safe(snode, t, &gnode->sources[i], node)
 			amt_destroy_source(snode);
@@ -332,6 +349,13 @@ static void amt_act_src(struct amt_tunnel_list *tunnel,
 			   &snode->source_addr.ip4,
 			   &gnode->group_addr.ip4,
 			   action_str[act]);
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		netdev_dbg(amt->dev, "Source %pI6 from %pI6 Acted %s\n",
+			   &snode->source_addr.ip6,
+			   &gnode->group_addr.ip6,
+			   action_str[act]);
+#endif
 }
 
 static struct amt_source_node *amt_alloc_snode(struct amt_group_node *gnode,
@@ -471,6 +495,12 @@ static struct amt_group_node *amt_add_group(struct amt_dev *amt,
 	if (!gnode->v6)
 		netdev_dbg(amt->dev, "Join group %pI4\n",
 			   &gnode->group_addr.ip4);
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		netdev_dbg(amt->dev, "Join group %pI6\n",
+			   &gnode->group_addr.ip6);
+#endif
+
 	return gnode;
 }
 
@@ -779,6 +809,104 @@ static void amt_send_igmp_gq(struct amt_dev *amt,
 	dev_queue_xmit(skb);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static struct sk_buff *amt_build_mld_gq(struct amt_dev *amt)
+{
+	u8 ra[8] = { IPPROTO_ICMPV6, 0, IPV6_TLV_ROUTERALERT,
+		     2, 0, 0, IPV6_TLV_PAD1, IPV6_TLV_PAD1 };
+	int hlen = LL_RESERVED_SPACE(amt->dev);
+	int tlen = amt->dev->needed_tailroom;
+	struct mld2_query *mld2q;
+	void *csum_start = NULL;
+	struct ipv6hdr *ip6h;
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+	u8 *hopopt;
+	u32 len;
+
+	len = hlen + tlen + sizeof(*ip6h) + sizeof(ra) + sizeof(*mld2q);
+	skb = netdev_alloc_skb_ip_align(amt->dev, len);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, hlen);
+	skb_push(skb, sizeof(*eth));
+	skb_reset_mac_header(skb);
+	eth = eth_hdr(skb);
+	skb->priority = TC_PRIO_CONTROL;
+	skb->protocol = htons(ETH_P_IPV6);
+	skb_put_zero(skb, sizeof(*ip6h) + sizeof(ra) + sizeof(*mld2q));
+	skb_pull(skb, sizeof(*eth));
+	skb_reset_network_header(skb);
+	ip6h			= ipv6_hdr(skb);
+	ip6h->payload_len	= htons(sizeof(ra) + sizeof(*mld2q));
+	ip6h->nexthdr		= NEXTHDR_HOP;
+	ip6h->hop_limit		= 1;
+	ip6h->daddr		= mld2_all_node;
+	ip6_flow_hdr(ip6h, 0, 0);
+	hopopt = (u8 *)(ip6h + 1);
+	hopopt[0] = IPPROTO_ICMPV6;             /* next hdr */
+	hopopt[1] = 0;                          /* length of HbH */
+	hopopt[2] = IPV6_TLV_ROUTERALERT;       /* Router Alert */
+	hopopt[3] = 2;                          /* Length of RA Option */
+	hopopt[4] = 0;                          /* Type = 0x0000 (MLD) */
+	hopopt[5] = 0;
+	hopopt[6] = IPV6_TLV_PAD1;              /* Pad1 */
+	hopopt[7] = IPV6_TLV_PAD1;              /* Pad1 */
+
+	if (ipv6_dev_get_saddr(amt->net, amt->dev, &ip6h->daddr, 0,
+			       &ip6h->saddr)) {
+		amt->dev->stats.tx_errors++;
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	eth->h_proto = htons(ETH_P_IPV6);
+	ether_addr_copy(eth->h_source, amt->dev->dev_addr);
+	ipv6_eth_mc_map(&mld2_all_node, eth->h_dest);
+
+	skb_pull(skb, sizeof(*ip6h) + sizeof(ra));
+	skb_reset_transport_header(skb);
+	mld2q			= (struct mld2_query *)icmp6_hdr(skb);
+	mld2q->mld2q_mrc	= htons(1);
+	mld2q->mld2q_type	= ICMPV6_MGM_QUERY;
+	mld2q->mld2q_code	= 0;
+	mld2q->mld2q_cksum	= 0;
+	mld2q->mld2q_resv1	= 0;
+	mld2q->mld2q_resv2	= 0;
+	mld2q->mld2q_suppress	= 0;
+	mld2q->mld2q_qrv	= amt->qrv;
+	mld2q->mld2q_nsrcs	= 0;
+	mld2q->mld2q_qqic	= amt->qi;
+	csum_start		= (void *)mld2q;
+	mld2q->mld2q_cksum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					     sizeof(*mld2q),
+					     IPPROTO_ICMPV6,
+					     csum_partial(csum_start,
+							  sizeof(*mld2q), 0));
+
+	skb->ip_summed = CHECKSUM_NONE;
+	skb_push(skb, sizeof(*eth) + sizeof(*ip6h) + sizeof(ra));
+	return skb;
+}
+
+static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
+{
+	struct sk_buff *skb;
+
+	skb = amt_build_mld_gq(amt);
+	if (!skb)
+		return;
+
+	amt_skb_cb(skb)->tunnel = tunnel;
+	dev_queue_xmit(skb);
+}
+#else
+static void amt_send_mld_gq(struct amt_dev *amt, struct amt_tunnel_list *tunnel)
+{
+}
+#endif
+
 static void amt_secret_work(struct work_struct *work)
 {
 	struct amt_dev *amt = container_of(to_delayed_work(work),
@@ -1023,6 +1151,10 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct amt_tunnel_list *tunnel;
 	struct amt_group_node *gnode;
 	union amt_addr group = {0,};
+#if IS_ENABLED(CONFIG_IPV6)
+	struct ipv6hdr *ip6h;
+	struct mld_msg *mld;
+#endif
 	bool report = false;
 	struct igmphdr *ih;
 	bool query = false;
@@ -1055,6 +1187,31 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		v6 = false;
 		group.ip4 = iph->daddr;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (iph->version == 6) {
+		ip6h = ipv6_hdr(skb);
+		if (!ipv6_addr_is_multicast(&ip6h->daddr))
+			goto free;
+
+		if (!ipv6_mc_check_mld(skb)) {
+			mld = (struct mld_msg *)skb_transport_header(skb);
+			switch (mld->mld_type) {
+			case ICMPV6_MGM_REPORT:
+			case ICMPV6_MLD2_REPORT:
+				report = true;
+				break;
+			case ICMPV6_MGM_QUERY:
+				query = true;
+				break;
+			default:
+				goto free;
+			}
+		} else {
+			data = true;
+		}
+		v6 = true;
+		group.ip6 = ip6h->daddr;
+#endif
 	} else {
 		dev->stats.tx_errors++;
 		goto free;
@@ -1094,12 +1251,19 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 			hash = amt_group_hash(tunnel, &group);
 			hlist_for_each_entry_rcu(gnode, &tunnel->groups[hash],
 						 node) {
-				if (!v6)
+				if (!v6) {
 					if (gnode->group_addr.ip4 == iph->daddr)
 						goto found;
+#if IS_ENABLED(CONFIG_IPV6)
+				} else {
+					if (ipv6_addr_equal(&gnode->group_addr.ip6,
+							    &ip6h->daddr))
+						goto found;
+#endif
+				}
 			}
 			continue;
-found:;
+found:
 			amt_send_multicast_data(amt, skb, tunnel, v6);
 		}
 	}
@@ -1191,6 +1355,13 @@ static void amt_cleanup_srcs(struct amt_dev *amt,
 					   "Add source as OLD %pI4 from %pI4\n",
 					   &snode->source_addr.ip4,
 					   &gnode->group_addr.ip4);
+#if IS_ENABLED(CONFIG_IPV6)
+			else
+				netdev_dbg(snode->gnode->amt->dev,
+					   "Add source as OLD %pI6 from %pI6\n",
+					   &snode->source_addr.ip6,
+					   &gnode->group_addr.ip6);
+#endif
 		}
 	}
 }
@@ -1201,6 +1372,9 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
 {
 	struct igmpv3_grec *igmp_grec;
 	struct amt_source_node *snode;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct mld2_grec *mld_grec;
+#endif
 	union amt_addr src = {0,};
 	u16 nsrcs;
 	u32 hash;
@@ -1210,13 +1384,23 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
 		igmp_grec = (struct igmpv3_grec *)grec;
 		nsrcs = ntohs(igmp_grec->grec_nsrcs);
 	} else {
-		return;
+#if IS_ENABLED(CONFIG_IPV6)
+		mld_grec = (struct mld2_grec *)grec;
+		nsrcs = ntohs(mld_grec->grec_nsrcs);
+#else
+	return;
+#endif
 	}
 	for (i = 0; i < nsrcs; i++) {
 		if (tunnel->nr_sources >= amt->max_sources)
 			return;
 		if (!v6)
 			src.ip4 = igmp_grec->grec_src[i];
+#if IS_ENABLED(CONFIG_IPV6)
+		else
+			memcpy(&src.ip6, &mld_grec->grec_src[i],
+			       sizeof(struct in6_addr));
+#endif
 		if (amt_lookup_src(tunnel, gnode, AMT_FILTER_ALL, &src))
 			continue;
 
@@ -1232,6 +1416,13 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
 					   "Add source as NEW %pI4 from %pI4\n",
 					   &snode->source_addr.ip4,
 					   &gnode->group_addr.ip4);
+#if IS_ENABLED(CONFIG_IPV6)
+			else
+				netdev_dbg(snode->gnode->amt->dev,
+					   "Add source as NEW %pI6 from %pI6\n",
+					   &snode->source_addr.ip6,
+					   &gnode->group_addr.ip6);
+#endif
 		}
 	}
 }
@@ -1266,6 +1457,9 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 	struct amt_dev *amt = tunnel->amt;
 	struct amt_source_node *snode;
 	struct igmpv3_grec *igmp_grec;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct mld2_grec *mld_grec;
+#endif
 	union amt_addr src = {0,};
 	struct hlist_node *t;
 	u16 nsrcs;
@@ -1275,7 +1469,12 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 		igmp_grec = (struct igmpv3_grec *)grec;
 		nsrcs = ntohs(igmp_grec->grec_nsrcs);
 	} else {
-		return;
+#if IS_ENABLED(CONFIG_IPV6)
+		mld_grec = (struct mld2_grec *)grec;
+		nsrcs = ntohs(mld_grec->grec_nsrcs);
+#else
+	return;
+#endif
 	}
 
 	memset(&src, 0, sizeof(union amt_addr));
@@ -1285,6 +1484,11 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 		for (i = 0; i < nsrcs; i++) {
 			if (!v6)
 				src.ip4 = igmp_grec->grec_src[i];
+#if IS_ENABLED(CONFIG_IPV6)
+			else
+				memcpy(&src.ip6, &mld_grec->grec_src[i],
+				       sizeof(struct in6_addr));
+#endif
 			snode = amt_lookup_src(tunnel, gnode, filter, &src);
 			if (!snode)
 				continue;
@@ -1303,6 +1507,11 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 		for (i = 0; i < nsrcs; i++) {
 			if (!v6)
 				src.ip4 = igmp_grec->grec_src[i];
+#if IS_ENABLED(CONFIG_IPV6)
+			else
+				memcpy(&src.ip6, &mld_grec->grec_src[i],
+				       sizeof(struct in6_addr));
+#endif
 			snode = amt_lookup_src(tunnel, gnode, filter, &src);
 			if (!snode)
 				continue;
@@ -1319,6 +1528,12 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 				for (j = 0; j < nsrcs; j++) {
 					if (!v6)
 						src.ip4 = igmp_grec->grec_src[j];
+#if IS_ENABLED(CONFIG_IPV6)
+					else
+						memcpy(&src.ip6,
+						       &mld_grec->grec_src[j],
+						       sizeof(struct in6_addr));
+#endif
 					if (amt_addr_equal(&snode->source_addr,
 							   &src))
 						goto out_sub;
@@ -1334,6 +1549,11 @@ out_sub:;
 		for (i = 0; i < nsrcs; i++) {
 			if (!v6)
 				src.ip4 = igmp_grec->grec_src[i];
+#if IS_ENABLED(CONFIG_IPV6)
+			else
+				memcpy(&src.ip6, &mld_grec->grec_src[i],
+				       sizeof(struct in6_addr));
+#endif
 			snode = amt_lookup_src(tunnel, gnode, AMT_FILTER_ALL,
 					       &src);
 			if (!snode) {
@@ -1841,6 +2061,169 @@ static void amt_igmp_report_handler(struct amt_dev *amt, struct sk_buff *skb,
 	}
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+/* RFC 3810
+ * 8.3.2. In the Presence of MLDv1 Multicast Address Listeners
+ *
+ * When Multicast Address Compatibility Mode is MLDv2, a router acts
+ * using the MLDv2 protocol for that multicast address.  When Multicast
+ * Address Compatibility Mode is MLDv1, a router internally translates
+ * the following MLDv1 messages for that multicast address to their
+ * MLDv2 equivalents:
+ *
+ * MLDv1 Message                 MLDv2 Equivalent
+ * --------------                -----------------
+ * Report                        IS_EX( {} )
+ * Done                          TO_IN( {} )
+ */
+static void amt_mldv1_report_handler(struct amt_dev *amt, struct sk_buff *skb,
+				     struct amt_tunnel_list *tunnel)
+{
+	struct mld_msg *mld = (struct mld_msg *)icmp6_hdr(skb);
+	struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct amt_group_node *gnode;
+	union amt_addr group, host;
+
+	memcpy(&group.ip6, &mld->mld_mca, sizeof(struct in6_addr));
+	memcpy(&host.ip6, &ip6h->saddr, sizeof(struct in6_addr));
+
+	gnode = amt_lookup_group(tunnel, &group, &host, true);
+	if (!gnode) {
+		gnode = amt_add_group(amt, tunnel, &group, &host, true);
+		if (!IS_ERR(gnode)) {
+			gnode->filter_mode = MCAST_EXCLUDE;
+			if (!mod_delayed_work(amt_wq, &gnode->group_timer,
+					      msecs_to_jiffies(amt_gmi(amt))))
+				dev_hold(amt->dev);
+		}
+	}
+}
+
+/* RFC 3810
+ * 8.3.2. In the Presence of MLDv1 Multicast Address Listeners
+ *
+ * When Multicast Address Compatibility Mode is MLDv2, a router acts
+ * using the MLDv2 protocol for that multicast address.  When Multicast
+ * Address Compatibility Mode is MLDv1, a router internally translates
+ * the following MLDv1 messages for that multicast address to their
+ * MLDv2 equivalents:
+ *
+ * MLDv1 Message                 MLDv2 Equivalent
+ * --------------                -----------------
+ * Report                        IS_EX( {} )
+ * Done                          TO_IN( {} )
+ */
+static void amt_mldv1_leave_handler(struct amt_dev *amt, struct sk_buff *skb,
+				    struct amt_tunnel_list *tunnel)
+{
+	struct mld_msg *mld = (struct mld_msg *)icmp6_hdr(skb);
+	struct iphdr *iph = ip_hdr(skb);
+	struct amt_group_node *gnode;
+	union amt_addr group, host;
+
+	memcpy(&group.ip6, &mld->mld_mca, sizeof(struct in6_addr));
+	memset(&host, 0, sizeof(union amt_addr));
+	host.ip4 = iph->saddr;
+
+	gnode = amt_lookup_group(tunnel, &group, &host, true);
+	if (gnode) {
+		amt_del_group(amt, gnode);
+		return;
+	}
+}
+
+static void amt_mldv2_report_handler(struct amt_dev *amt, struct sk_buff *skb,
+				     struct amt_tunnel_list *tunnel)
+{
+	struct mld2_report *mld2r = (struct mld2_report *)icmp6_hdr(skb);
+	int len = skb_transport_offset(skb) + sizeof(*mld2r);
+	void *zero_grec = (void *)&mldv2_zero_grec;
+	struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct amt_group_node *gnode;
+	union amt_addr group, host;
+	struct mld2_grec *grec;
+	u16 nsrcs;
+	int i;
+
+	for (i = 0; i < ntohs(mld2r->mld2r_ngrec); i++) {
+		len += sizeof(*grec);
+		if (!ipv6_mc_may_pull(skb, len))
+			break;
+
+		grec = (void *)(skb->data + len - sizeof(*grec));
+		nsrcs = ntohs(grec->grec_nsrcs);
+
+		len += nsrcs * sizeof(struct in6_addr);
+		if (!ipv6_mc_may_pull(skb, len))
+			break;
+
+		memset(&group, 0, sizeof(union amt_addr));
+		group.ip6 = grec->grec_mca;
+		memset(&host, 0, sizeof(union amt_addr));
+		host.ip6 = ip6h->saddr;
+		gnode = amt_lookup_group(tunnel, &group, &host, true);
+		if (!gnode) {
+			gnode = amt_add_group(amt, tunnel, &group, &host,
+					      ETH_P_IPV6);
+			if (IS_ERR(gnode))
+				continue;
+		}
+
+		amt_add_srcs(amt, tunnel, gnode, grec, true);
+		switch (grec->grec_type) {
+		case MLD2_MODE_IS_INCLUDE:
+			amt_mcast_is_in_handler(amt, tunnel, gnode, grec,
+						zero_grec, true);
+			break;
+		case MLD2_MODE_IS_EXCLUDE:
+			amt_mcast_is_ex_handler(amt, tunnel, gnode, grec,
+						zero_grec, true);
+			break;
+		case MLD2_CHANGE_TO_INCLUDE:
+			amt_mcast_to_in_handler(amt, tunnel, gnode, grec,
+						zero_grec, true);
+			break;
+		case MLD2_CHANGE_TO_EXCLUDE:
+			amt_mcast_to_ex_handler(amt, tunnel, gnode, grec,
+						zero_grec, true);
+			break;
+		case MLD2_ALLOW_NEW_SOURCES:
+			amt_mcast_allow_handler(amt, tunnel, gnode, grec,
+						zero_grec, true);
+			break;
+		case MLD2_BLOCK_OLD_SOURCES:
+			amt_mcast_block_handler(amt, tunnel, gnode, grec,
+						zero_grec, true);
+			break;
+		default:
+			break;
+		}
+		amt_cleanup_srcs(amt, tunnel, gnode);
+	}
+}
+
+/* caller held tunnel->lock */
+static void amt_mld_report_handler(struct amt_dev *amt, struct sk_buff *skb,
+				   struct amt_tunnel_list *tunnel)
+{
+	struct mld_msg *mld = (struct mld_msg *)icmp6_hdr(skb);
+
+	switch (mld->mld_type) {
+	case ICMPV6_MGM_REPORT:
+		amt_mldv1_report_handler(amt, skb, tunnel);
+		break;
+	case ICMPV6_MLD2_REPORT:
+		amt_mldv2_report_handler(amt, skb, tunnel);
+		break;
+	case ICMPV6_MGM_REDUCTION:
+		amt_mldv1_leave_handler(amt, skb, tunnel);
+		break;
+	default:
+		break;
+	}
+}
+#endif
+
 static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 {
 	struct amt_header_advertisement *amta;
@@ -1895,6 +2278,17 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IP);
 		eth->h_proto = htons(ETH_P_IP);
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h;
+
+		ip6h = ipv6_hdr(skb);
+		if (!ipv6_addr_is_multicast(&ip6h->daddr))
+			return true;
+		skb->protocol = htons(ETH_P_IPV6);
+		eth->h_proto = htons(ETH_P_IPV6);
+		ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
+#endif
 	} else {
 		return true;
 	}
@@ -1956,6 +2350,29 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		skb->protocol = htons(ETH_P_IP);
 		eth->h_proto = htons(ETH_P_IP);
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		struct mld2_query *mld2q;
+
+		if (!ipv6_addr_is_multicast(&ip6h->daddr))
+			return true;
+		if (!pskb_may_pull(skb, sizeof(*ip6h) + 8 + sizeof(*mld2q)))
+			return true;
+
+		mld2q = skb_pull(skb, sizeof(*ip6h) + 8);
+		skb_reset_transport_header(skb);
+		skb_push(skb, sizeof(*ip6h) + 8);
+		spin_lock_bh(&amt->lock);
+		amt->ready6 = true;
+		amt->mac = amtmq->response_mac;
+		amt->req_cnt = 0;
+		amt->qi = mld2q->mld2q_qqic;
+		spin_unlock_bh(&amt->lock);
+		skb->protocol = htons(ETH_P_IPV6);
+		eth->h_proto = htons(ETH_P_IPV6);
+		ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
+#endif
 	} else {
 		return true;
 	}
@@ -2032,6 +2449,26 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IP);
 		eth->h_proto = htons(ETH_P_IP);
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h = ipv6_hdr(skb);
+
+		if (ipv6_mc_check_mld(skb)) {
+			netdev_dbg(amt->dev, "Invalid MLD\n");
+			return true;
+		}
+
+		spin_lock_bh(&tunnel->lock);
+		amt_mld_report_handler(amt, skb, tunnel);
+		spin_unlock_bh(&tunnel->lock);
+
+		skb_push(skb, sizeof(struct ethhdr));
+		skb_reset_mac_header(skb);
+		eth = eth_hdr(skb);
+		skb->protocol = htons(ETH_P_IPV6);
+		eth->h_proto = htons(ETH_P_IPV6);
+		ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
+#endif
 	} else {
 		netdev_dbg(amt->dev, "Unsupported Protocol\n");
 		return true;
@@ -2234,6 +2671,8 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 
 	if (!amtrh->p)
 		amt_send_igmp_gq(amt, tunnel);
+	else
+		amt_send_mld_gq(amt, tunnel);
 
 	return false;
 }
-- 
2.17.1

