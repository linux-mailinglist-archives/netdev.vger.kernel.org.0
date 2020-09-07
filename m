Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DC325F70D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgIGKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgIGKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CECC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:20 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id g4so15151126wrs.5
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0FbZpQPGLq/aKSjJPRGBQhfrm3MKHUc+jlYZdmKheVg=;
        b=H2ULkaf+LIg17r/y0i7H+D0vrJU7R8uyrzbteLXi4hqUpcYdCx8jqCqUwesQNi8Dvc
         3uFdPpl5BnReNgwkS0OLWtI2m/C+K+bzLmoAzNDbFUbbhuPT9WvqpWHaZE7AYY9cYqnm
         /2WUYmc9YG8gOprJpNoASmbAQ8nDW4d2IHstw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0FbZpQPGLq/aKSjJPRGBQhfrm3MKHUc+jlYZdmKheVg=;
        b=Cp9jewWFuBzTQVWLTUMIPo0RTu/hOUCNu07qJX+ID1KT9RE8Uz6PCScHd4JHHNKaqk
         KoOOv20kMFkIF+u9m5Am9ptQQpaNSFsgojC18yXlMH4+/e9B7QyaIhMH7V44UCVmU9bM
         VbFmtWli6L6dQCoZZLWG7sZffL/uJgh548KZTuSiD+pgtPcqlKXUwrm9vGPZTsYYI+NV
         XUzPnCwtwP0rqPU5F5lw/312W80FqgMJqJ5swPFqiCz6eI9KiZ8yJxBQfKk1IHhRzALF
         Yml9UM8aORNWUdWPjUYyZOUo6e840NR7U+0hohJd9yt6M6vN0UW1j+LKrJIdGl9rVOL8
         5cjQ==
X-Gm-Message-State: AOAM531Apw6LnjJUPpjP8WvKLnUR43Fa7Jje4RnYIvQru5tmlMpPNVDY
        +qY7wUmPE29jOPuq7XdcTWOZXzbFPxZuCCkZ
X-Google-Smtp-Source: ABdhPJxEQzNn0TaUKWGEkLBcMXNC6GC9abn58/5M/QSjfohBWoL5owEpYygLqrfvg42lNwJtB4kjYg==
X-Received: by 2002:adf:f101:: with SMTP id r1mr20673455wro.314.1599472818521;
        Mon, 07 Sep 2020 03:00:18 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:16 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 05/15] net: bridge: mcast: add support for group-and-source specific queries
Date:   Mon,  7 Sep 2020 12:56:09 +0300
Message-Id: <20200907095619.11216-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allows br_multicast_alloc_query to build queries with the port group's
source lists and sends a query for sources over and under lmqt when
necessary as per RFCs 3376 and 3810 with the suppress flag set
appropriately.

v3: add IPv6 support

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 236 +++++++++++++++++++++++++++++---------
 net/bridge/br_private.h   |   1 +
 2 files changed, 183 insertions(+), 54 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index bbfa0219fa4a..cfb9533447c7 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -234,21 +234,50 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 }
 
 static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
-						    __be32 group,
-						    u8 *igmp_type)
+						    struct net_bridge_port_group *pg,
+						    __be32 ip_dst, __be32 group,
+						    bool with_srcs, bool over_lmqt,
+						    u8 sflag, u8 *igmp_type)
 {
+	struct net_bridge_port *p = pg ? pg->port : NULL;
+	struct net_bridge_group_src *ent;
+	size_t pkt_size, igmp_hdr_size;
+	unsigned long now = jiffies;
 	struct igmpv3_query *ihv3;
-	size_t igmp_hdr_size;
+	void *csum_start = NULL;
+	__sum16 *csum = NULL;
 	struct sk_buff *skb;
 	struct igmphdr *ih;
 	struct ethhdr *eth;
+	unsigned long lmqt;
 	struct iphdr *iph;
+	u16 lmqt_srcs = 0;
 
 	igmp_hdr_size = sizeof(*ih);
-	if (br->multicast_igmp_version == 3)
+	if (br->multicast_igmp_version == 3) {
 		igmp_hdr_size = sizeof(*ihv3);
-	skb = netdev_alloc_skb_ip_align(br->dev, sizeof(*eth) + sizeof(*iph) +
-						 igmp_hdr_size + 4);
+		if (pg && with_srcs) {
+			lmqt = now + (br->multicast_last_member_interval *
+				      br->multicast_last_member_count);
+			hlist_for_each_entry(ent, &pg->src_list, node) {
+				if (over_lmqt == time_after(ent->timer.expires,
+							    lmqt) &&
+				    ent->src_query_rexmit_cnt > 0)
+					lmqt_srcs++;
+			}
+
+			if (!lmqt_srcs)
+				return NULL;
+			igmp_hdr_size += lmqt_srcs * sizeof(__be32);
+		}
+	}
+
+	pkt_size = sizeof(*eth) + sizeof(*iph) + 4 + igmp_hdr_size;
+	if ((p && pkt_size > p->dev->mtu) ||
+	    pkt_size > br->dev->mtu)
+		return NULL;
+
+	skb = netdev_alloc_skb_ip_align(br->dev, pkt_size);
 	if (!skb)
 		goto out;
 
@@ -258,29 +287,24 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 	eth = eth_hdr(skb);
 
 	ether_addr_copy(eth->h_source, br->dev->dev_addr);
-	eth->h_dest[0] = 1;
-	eth->h_dest[1] = 0;
-	eth->h_dest[2] = 0x5e;
-	eth->h_dest[3] = 0;
-	eth->h_dest[4] = 0;
-	eth->h_dest[5] = 1;
+	ip_eth_mc_map(ip_dst, eth->h_dest);
 	eth->h_proto = htons(ETH_P_IP);
 	skb_put(skb, sizeof(*eth));
 
 	skb_set_network_header(skb, skb->len);
 	iph = ip_hdr(skb);
+	iph->tot_len = htons(pkt_size - sizeof(*eth));
 
 	iph->version = 4;
 	iph->ihl = 6;
 	iph->tos = 0xc0;
-	iph->tot_len = htons(sizeof(*iph) + igmp_hdr_size + 4);
 	iph->id = 0;
 	iph->frag_off = htons(IP_DF);
 	iph->ttl = 1;
 	iph->protocol = IPPROTO_IGMP;
 	iph->saddr = br_opt_get(br, BROPT_MULTICAST_QUERY_USE_IFADDR) ?
 		     inet_select_addr(br->dev, 0, RT_SCOPE_LINK) : 0;
-	iph->daddr = htonl(INADDR_ALLHOSTS_GROUP);
+	iph->daddr = ip_dst;
 	((u8 *)&iph[1])[0] = IPOPT_RA;
 	((u8 *)&iph[1])[1] = 4;
 	((u8 *)&iph[1])[2] = 0;
@@ -300,7 +324,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 			   (HZ / IGMP_TIMER_SCALE);
 		ih->group = group;
 		ih->csum = 0;
-		ih->csum = ip_compute_csum((void *)ih, sizeof(*ih));
+		csum = &ih->csum;
+		csum_start = (void *)ih;
 		break;
 	case 3:
 		ihv3 = igmpv3_query_hdr(skb);
@@ -310,15 +335,38 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 			     (HZ / IGMP_TIMER_SCALE);
 		ihv3->group = group;
 		ihv3->qqic = br->multicast_query_interval / HZ;
-		ihv3->nsrcs = 0;
+		ihv3->nsrcs = htons(lmqt_srcs);
 		ihv3->resv = 0;
-		ihv3->suppress = 0;
+		ihv3->suppress = sflag;
 		ihv3->qrv = 2;
 		ihv3->csum = 0;
-		ihv3->csum = ip_compute_csum((void *)ihv3, sizeof(*ihv3));
+		csum = &ihv3->csum;
+		csum_start = (void *)ihv3;
+		if (!pg || !with_srcs)
+			break;
+
+		lmqt_srcs = 0;
+		hlist_for_each_entry(ent, &pg->src_list, node) {
+			if (over_lmqt == time_after(ent->timer.expires,
+						    lmqt) &&
+			    ent->src_query_rexmit_cnt > 0) {
+				ihv3->srcs[lmqt_srcs++] = ent->addr.u.ip4;
+				ent->src_query_rexmit_cnt--;
+			}
+		}
+		if (WARN_ON(lmqt_srcs != ntohs(ihv3->nsrcs))) {
+			kfree_skb(skb);
+			return NULL;
+		}
 		break;
 	}
 
+	if (WARN_ON(!csum || !csum_start)) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	*csum = ip_compute_csum(csum_start, igmp_hdr_size);
 	skb_put(skb, igmp_hdr_size);
 	__skb_pull(skb, sizeof(*eth));
 
@@ -328,23 +376,53 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
-						    const struct in6_addr *grp,
-						    u8 *igmp_type)
+						    struct net_bridge_port_group *pg,
+						    const struct in6_addr *ip6_dst,
+						    const struct in6_addr *group,
+						    bool with_srcs, bool over_llqt,
+						    u8 sflag, u8 *igmp_type)
 {
+	struct net_bridge_port *p = pg ? pg->port : NULL;
+	struct net_bridge_group_src *ent;
+	size_t pkt_size, mld_hdr_size;
+	unsigned long now = jiffies;
 	struct mld2_query *mld2q;
+	void *csum_start = NULL;
 	unsigned long interval;
+	__sum16 *csum = NULL;
 	struct ipv6hdr *ip6h;
 	struct mld_msg *mldq;
-	size_t mld_hdr_size;
 	struct sk_buff *skb;
+	unsigned long llqt;
 	struct ethhdr *eth;
+	u16 llqt_srcs = 0;
 	u8 *hopopt;
 
 	mld_hdr_size = sizeof(*mldq);
-	if (br->multicast_mld_version == 2)
+	if (br->multicast_mld_version == 2) {
 		mld_hdr_size = sizeof(*mld2q);
-	skb = netdev_alloc_skb_ip_align(br->dev, sizeof(*eth) + sizeof(*ip6h) +
-						 8 + mld_hdr_size);
+		if (pg && with_srcs) {
+			llqt = now + (br->multicast_last_member_interval *
+				      br->multicast_last_member_count);
+			hlist_for_each_entry(ent, &pg->src_list, node) {
+				if (over_llqt == time_after(ent->timer.expires,
+							    llqt) &&
+				    ent->src_query_rexmit_cnt > 0)
+					llqt_srcs++;
+			}
+
+			if (!llqt_srcs)
+				return NULL;
+			mld_hdr_size += llqt_srcs * sizeof(struct in6_addr);
+		}
+	}
+
+	pkt_size = sizeof(*eth) + sizeof(*ip6h) + 8 + mld_hdr_size;
+	if ((p && pkt_size > p->dev->mtu) ||
+	    pkt_size > br->dev->mtu)
+		return NULL;
+
+	skb = netdev_alloc_skb_ip_align(br->dev, pkt_size);
 	if (!skb)
 		goto out;
 
@@ -366,7 +444,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	ip6h->payload_len = htons(8 + mld_hdr_size);
 	ip6h->nexthdr = IPPROTO_HOPOPTS;
 	ip6h->hop_limit = 1;
-	ipv6_addr_set(&ip6h->daddr, htonl(0xff020000), 0, 0, htonl(1));
+	ip6h->daddr = *ip6_dst;
 	if (ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6h->daddr, 0,
 			       &ip6h->saddr)) {
 		kfree_skb(skb);
@@ -391,7 +469,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 
 	/* ICMPv6 */
 	skb_set_transport_header(skb, skb->len);
-	interval = ipv6_addr_any(grp) ?
+	interval = ipv6_addr_any(group) ?
 			br->multicast_query_response_interval :
 			br->multicast_last_member_interval;
 	*igmp_type = ICMPV6_MGM_QUERY;
@@ -403,12 +481,9 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 		mldq->mld_cksum = 0;
 		mldq->mld_maxdelay = htons((u16)jiffies_to_msecs(interval));
 		mldq->mld_reserved = 0;
-		mldq->mld_mca = *grp;
-		mldq->mld_cksum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-						  sizeof(*mldq), IPPROTO_ICMPV6,
-						  csum_partial(mldq,
-							       sizeof(*mldq),
-							       0));
+		mldq->mld_mca = *group;
+		csum = &mldq->mld_cksum;
+		csum_start = (void *)mldq;
 		break;
 	case 2:
 		mld2q = (struct mld2_query *)icmp6_hdr(skb);
@@ -418,21 +493,41 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 		mld2q->mld2q_cksum = 0;
 		mld2q->mld2q_resv1 = 0;
 		mld2q->mld2q_resv2 = 0;
-		mld2q->mld2q_suppress = 0;
+		mld2q->mld2q_suppress = sflag;
 		mld2q->mld2q_qrv = 2;
-		mld2q->mld2q_nsrcs = 0;
+		mld2q->mld2q_nsrcs = htons(llqt_srcs);
 		mld2q->mld2q_qqic = br->multicast_query_interval / HZ;
-		mld2q->mld2q_mca = *grp;
-		mld2q->mld2q_cksum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-						     sizeof(*mld2q),
-						     IPPROTO_ICMPV6,
-						     csum_partial(mld2q,
-								  sizeof(*mld2q),
-								  0));
+		mld2q->mld2q_mca = *group;
+		csum = &mld2q->mld2q_cksum;
+		csum_start = (void *)mld2q;
+		if (!pg || !with_srcs)
+			break;
+
+		llqt_srcs = 0;
+		hlist_for_each_entry(ent, &pg->src_list, node) {
+			if (over_llqt == time_after(ent->timer.expires,
+						    llqt) &&
+			    ent->src_query_rexmit_cnt > 0) {
+				mld2q->mld2q_srcs[llqt_srcs++] = ent->addr.u.ip6;
+				ent->src_query_rexmit_cnt--;
+			}
+		}
+		if (WARN_ON(llqt_srcs != ntohs(mld2q->mld2q_nsrcs))) {
+			kfree_skb(skb);
+			return NULL;
+		}
 		break;
 	}
-	skb_put(skb, mld_hdr_size);
 
+	if (WARN_ON(!csum || !csum_start)) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	*csum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr, mld_hdr_size,
+				IPPROTO_ICMPV6,
+				csum_partial(csum_start, mld_hdr_size, 0));
+	skb_put(skb, mld_hdr_size);
 	__skb_pull(skb, sizeof(*eth));
 
 out:
@@ -441,16 +536,36 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 #endif
 
 static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
-						struct br_ip *addr,
-						u8 *igmp_type)
+						struct net_bridge_port_group *pg,
+						struct br_ip *ip_dst,
+						struct br_ip *group,
+						bool with_srcs, bool over_lmqt,
+						u8 sflag, u8 *igmp_type)
 {
-	switch (addr->proto) {
+	__be32 ip4_dst;
+
+	switch (group->proto) {
 	case htons(ETH_P_IP):
-		return br_ip4_multicast_alloc_query(br, addr->u.ip4, igmp_type);
+		ip4_dst = ip_dst ? ip_dst->u.ip4 : htonl(INADDR_ALLHOSTS_GROUP);
+		return br_ip4_multicast_alloc_query(br, pg,
+						    ip4_dst, group->u.ip4,
+						    with_srcs, over_lmqt,
+						    sflag, igmp_type);
 #if IS_ENABLED(CONFIG_IPV6)
-	case htons(ETH_P_IPV6):
-		return br_ip6_multicast_alloc_query(br, &addr->u.ip6,
-						    igmp_type);
+	case htons(ETH_P_IPV6): {
+		struct in6_addr ip6_dst;
+
+		if (ip_dst)
+			ip6_dst = ip_dst->u.ip6;
+		else
+			ipv6_addr_set(&ip6_dst, htonl(0xff020000), 0, 0,
+				      htonl(1));
+
+		return br_ip6_multicast_alloc_query(br, pg,
+						    &ip6_dst, &group->u.ip6,
+						    with_srcs, over_lmqt,
+						    sflag, igmp_type);
+	}
 #endif
 	}
 	return NULL;
@@ -824,12 +939,19 @@ static void br_multicast_select_own_querier(struct net_bridge *br,
 
 static void __br_multicast_send_query(struct net_bridge *br,
 				      struct net_bridge_port *port,
-				      struct br_ip *ip)
+				      struct net_bridge_port_group *pg,
+				      struct br_ip *ip_dst,
+				      struct br_ip *group,
+				      bool with_srcs,
+				      u8 sflag)
 {
+	bool over_lmqt = !!sflag;
 	struct sk_buff *skb;
 	u8 igmp_type;
 
-	skb = br_multicast_alloc_query(br, ip, &igmp_type);
+again_under_lmqt:
+	skb = br_multicast_alloc_query(br, pg, ip_dst, group, with_srcs,
+				       over_lmqt, sflag, &igmp_type);
 	if (!skb)
 		return;
 
@@ -840,8 +962,13 @@ static void __br_multicast_send_query(struct net_bridge *br,
 		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
 			dev_net(port->dev), NULL, skb, NULL, skb->dev,
 			br_dev_queue_push_xmit);
+
+		if (over_lmqt && with_srcs && sflag) {
+			over_lmqt = false;
+			goto again_under_lmqt;
+		}
 	} else {
-		br_multicast_select_own_querier(br, ip, skb);
+		br_multicast_select_own_querier(br, group, skb);
 		br_multicast_count(br, port, skb, igmp_type,
 				   BR_MCAST_DIR_RX);
 		netif_rx(skb);
@@ -877,7 +1004,7 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, port, &br_group);
+	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0);
 
 	time = jiffies;
 	time += own_query->startup_sent < br->multicast_startup_query_count ?
@@ -1530,7 +1657,8 @@ br_multicast_leave_group(struct net_bridge *br,
 		goto out;
 
 	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
-		__br_multicast_send_query(br, port, &mp->addr);
+		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
+					  false, 0);
 
 		time = jiffies + br->multicast_last_member_count *
 				 br->multicast_last_member_interval;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index eab8952a332a..e0632721b1ef 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -225,6 +225,7 @@ struct net_bridge_group_src {
 	struct br_ip			addr;
 	struct net_bridge_port_group	*pg;
 	u8				flags;
+	u8				src_query_rexmit_cnt;
 	struct timer_list		timer;
 
 	struct net_bridge		*br;
-- 
2.25.4

