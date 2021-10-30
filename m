Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6B7440965
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJ3OKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhJ3OKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:10:05 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C53C061714
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 07:07:35 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id m14so11979489pfc.9
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 07:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W7h6QszKWvlaKfrQkc65rRT10gVl1k3ehXJ4p+9EbS4=;
        b=TkZx/DUFi0FsT0bh6E1ZZyIwfUK/3/0Eb8Up7Wz9Et/ZcA49mtkniD55Ve2WnwTHod
         IW9xyNylpkwcUC9q8Xjxn3vBEIZDYQMvlklwyispM4ALYfUIZA+htmDdpy2P5L9pe7sX
         M2P0yQqogD916G3CGGoMfy+QhMFu2fKNXKTRtf6JRtrxRSsmEF+LNP5wY96SHStaAl6f
         aBT7vYmgN76I4/jh/scX38iUq5/Z0SM+tGBM8kGh3CLastSl2Or9QGtVRXG+DysJezkX
         ZrOj2YTzOwriugMGrWQWzyGSaR3x35gg0Up/piMiMbkouL4N6CTzHOhNo7N/XltpocAu
         Ohhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W7h6QszKWvlaKfrQkc65rRT10gVl1k3ehXJ4p+9EbS4=;
        b=1FEBJpO0Ekw4Q6yV0+1ekxdLk18YjO4DKHD8B9CDRlhk8+hmW6SKpwS8Rnuy7flBnH
         2MfPyT/PDAwjKljoH2rL//apvoz5dxAujKIT8lZgyr/MLVYSh6cJNhr+HROTBtw/Jitl
         KTYsega03TRW9My23i7Ffqcvwb3C43NWgdyolYVeotKyDHp9FOo8XVSk7UK4Q1aYvt2s
         KYUYg+krPnh7eZ9rqSBW26ORJ3O385kPZXEO1SZSyoJ8dQfEu4JhHj9+BuZqMmWyi/wH
         qcfzptVxEeu+4UvFVPJG0V3NHtHLOOlqCiTjM3pjLqJvpzqpiHttVSjHStKOZXQC5n40
         wNzw==
X-Gm-Message-State: AOAM531WkP2gVmkvlTKOVJgU6KapzWLS8Uhe5wf22FC5Q0uRmj+H7ORR
        9bmZV0LrIZp0IPkW9vyFQH3Pom3PukU6vQ==
X-Google-Smtp-Source: ABdhPJx12srtBy54oWfBnoBIAchVJhXAu3nTzoMz/w2kePoR13rmSxpphDEBwmcVCGDgcCQCD+UQnw==
X-Received: by 2002:a63:d654:: with SMTP id d20mr13065621pgj.122.1635602854613;
        Sat, 30 Oct 2021 07:07:34 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 142sm8278942pgh.22.2021.10.30.07.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:07:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v6 4/5] amt: add mld report message handler
Date:   Sat, 30 Oct 2021 14:07:17 +0000
Message-Id: <20211030140718.16662-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030140718.16662-1-ap420073@gmail.com>
References: <20211030140718.16662-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous patch, igmp report handler was added.
That handler can be used for mld too.
So, it uses that common code to parse mld report message.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Eliminate sparse warnings.
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.

v4 -> v5:
 - Refactoring.

v5 -> v6:
 - No change.

 drivers/net/amt.c | 446 +++++++++++++++++++++++++++++++++++++++++++++-
 include/net/amt.h |   1 +
 2 files changed, 440 insertions(+), 7 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 9520b2aced63..386dbc3b4750 100644
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
 	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct qdisc_skb_cb) >
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
@@ -333,6 +350,13 @@ static void amt_act_src(struct amt_tunnel_list *tunnel,
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
 
@@ -778,6 +808,96 @@ static void amt_send_igmp_gq(struct amt_dev *amt,
 	dev_queue_xmit(skb);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static struct sk_buff *amt_build_mld_gq(struct amt_dev *amt)
+{
+	u8 ra[AMT_IP6HDR_OPTS] = { IPPROTO_ICMPV6, 0, IPV6_TLV_ROUTERALERT,
+				   2, 0, 0, IPV6_TLV_PAD1, IPV6_TLV_PAD1 };
+	int hlen = LL_RESERVED_SPACE(amt->dev);
+	int tlen = amt->dev->needed_tailroom;
+	struct mld2_query *mld2q;
+	void *csum_start = NULL;
+	struct ipv6hdr *ip6h;
+	struct sk_buff *skb;
+	struct ethhdr *eth;
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
+	skb_put_zero(skb, sizeof(*ip6h));
+	skb_put_data(skb, ra, sizeof(ra));
+	skb_put_zero(skb, sizeof(*mld2q));
+	skb_pull(skb, sizeof(*eth));
+	skb_reset_network_header(skb);
+	ip6h			= ipv6_hdr(skb);
+	ip6h->payload_len	= htons(sizeof(ra) + sizeof(*mld2q));
+	ip6h->nexthdr		= NEXTHDR_HOP;
+	ip6h->hop_limit		= 1;
+	ip6h->daddr		= mld2_all_node;
+	ip6_flow_hdr(ip6h, 0, 0);
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
@@ -1022,6 +1142,10 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -1053,6 +1177,31 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -1092,12 +1241,19 @@ static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -1187,6 +1343,13 @@ static void amt_cleanup_srcs(struct amt_dev *amt,
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
@@ -1197,6 +1360,9 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
 {
 	struct igmpv3_grec *igmp_grec;
 	struct amt_source_node *snode;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct mld2_grec *mld_grec;
+#endif
 	union amt_addr src = {0,};
 	u16 nsrcs;
 	u32 hash;
@@ -1206,13 +1372,23 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
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
 
@@ -1228,6 +1404,13 @@ static void amt_add_srcs(struct amt_dev *amt, struct amt_tunnel_list *tunnel,
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
@@ -1262,6 +1445,9 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
 	struct amt_dev *amt = tunnel->amt;
 	struct amt_source_node *snode;
 	struct igmpv3_grec *igmp_grec;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct mld2_grec *mld_grec;
+#endif
 	union amt_addr src = {0,};
 	struct hlist_node *t;
 	u16 nsrcs;
@@ -1271,7 +1457,12 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
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
@@ -1281,6 +1472,11 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
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
@@ -1299,6 +1495,11 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
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
@@ -1315,6 +1516,12 @@ static void amt_lookup_act_srcs(struct amt_tunnel_list *tunnel,
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
@@ -1330,6 +1537,11 @@ out_sub:;
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
@@ -1837,6 +2049,169 @@ static void amt_igmp_report_handler(struct amt_dev *amt, struct sk_buff *skb,
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
@@ -1892,6 +2267,17 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
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
@@ -1954,6 +2340,30 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
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
+		if (!pskb_may_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS +
+				   sizeof(*mld2q)))
+			return true;
+
+		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
+		skb_reset_transport_header(skb);
+		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
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
@@ -2030,6 +2440,26 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
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
@@ -2229,6 +2659,8 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 
 	if (!amtrh->p)
 		amt_send_igmp_gq(amt, tunnel);
+	else
+		amt_send_mld_gq(amt, tunnel);
 
 	return false;
 }
diff --git a/include/net/amt.h b/include/net/amt.h
index 9581711b4d5c..8c5fe6b9070e 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -350,6 +350,7 @@ struct amt_dev {
 
 #define AMT_TOS			0xc0
 #define AMT_IPHDR_OPTS		4
+#define AMT_IP6HDR_OPTS		8
 #define AMT_GC_INTERVAL		(30 * 1000)
 #define AMT_MAX_GROUP		32
 #define AMT_MAX_SOURCE		128
-- 
2.17.1

