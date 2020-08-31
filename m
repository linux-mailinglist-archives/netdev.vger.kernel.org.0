Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C086A257BD2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgHaPLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgHaPKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:09 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2488EC0619C1
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so6294881wrm.9
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BstRYIuCHVXodtS5S5E5VfIRShzqxrAANr8C9MkvOP4=;
        b=Qm54943Uo1hn8m5kQQJmjYWTNNkf3pPH5+l7aLqtXMfOFdSls0N0u+d+Y/QGMHi1uf
         lpS/mewRoujl8y/48FaU7KtNnCOeHhrI9EF8WKU/N5bzFkENOZPvvN7wxcdNQafnmjlA
         n7kK0kiMf2Vl1OCnCdIqusYCbsAUseMpyPbhQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BstRYIuCHVXodtS5S5E5VfIRShzqxrAANr8C9MkvOP4=;
        b=kHM5VhgC+UOEAf9iisBR3CvgtvzIdqeznoCWdC3Cghs5d8d67oi/eboUunym/Mp03y
         APWo1jwyB2Rfxf/MNvUzjdCEoPfSdPxxVdGSYa7GxSRLD9KzPzzwNzk/+Vpx/c7QfLcD
         kmpn8fn+TU4D3GnUXpsOx+Ri6oZ7+NKUJ8cDvSNhtH3W7DlZtqeYc6i/oOjboQkKG00k
         XcWuWjoJ5pjsGLo1CF0QXcgzjdZGS0iST0ABxBxkCxS+KNBB4he+hPAY1odCTw/0Zimu
         TqhAGTVBjnyRjRyjLm51JbDxXqrwpQnqCV1lu/lWtc8kN7RuoxbbVuJtOmgn16eCc7pV
         K1+A==
X-Gm-Message-State: AOAM532CJoyLOQ3hisjYTmrU20hoOw2nTji+KIRDBVlc3iW4PIEbnkL5
        zhzx+ha7juVDoF/qu1Byi3/a2sTCaskTOajA
X-Google-Smtp-Source: ABdhPJy8TU/TWqL6BNMUIpoNClksHH/IKEOU1bkwIx8Tj0zT72iG0+Qmtm9swk1sPdynqD8JeoCNow==
X-Received: by 2002:a5d:48c8:: with SMTP id p8mr2006949wrs.299.1598886596336;
        Mon, 31 Aug 2020 08:09:56 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:09:55 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 04/15] net: bridge: mcast: add support for group-and-source specific queries
Date:   Mon, 31 Aug 2020 18:08:34 +0300
Message-Id: <20200831150845.1062447-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allows br_ip4_multicast_alloc_query to build queries with the port group's
source lists and sends a query for sources over and under lmqt when
necessary as per RFC 3376 with the suppress flag set appropriately.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 126 +++++++++++++++++++++++++++++---------
 net/bridge/br_private.h   |   1 +
 2 files changed, 99 insertions(+), 28 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e527a7531ce5..6d53ce667d82 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -228,21 +228,50 @@ static void br_multicast_port_group_expired(struct timer_list *t)
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
 
@@ -252,29 +281,24 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
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
@@ -294,7 +318,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 			   (HZ / IGMP_TIMER_SCALE);
 		ih->group = group;
 		ih->csum = 0;
-		ih->csum = ip_compute_csum((void *)ih, sizeof(*ih));
+		csum = &ih->csum;
+		csum_start = (void *)ih;
 		break;
 	case 3:
 		ihv3 = igmpv3_query_hdr(skb);
@@ -304,15 +329,38 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
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
+		kfree(skb);
+		return NULL;
+	}
+
+	*csum = ip_compute_csum(csum_start, igmp_hdr_size);
 	skb_put(skb, igmp_hdr_size);
 	__skb_pull(skb, sizeof(*eth));
 
@@ -435,15 +483,24 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
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
 	case htons(ETH_P_IPV6):
-		return br_ip6_multicast_alloc_query(br, &addr->u.ip6,
+		return br_ip6_multicast_alloc_query(br, &group->u.ip6,
 						    igmp_type);
 #endif
 	}
@@ -808,12 +865,19 @@ static void br_multicast_select_own_querier(struct net_bridge *br,
 
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
 
@@ -824,8 +888,13 @@ static void __br_multicast_send_query(struct net_bridge *br,
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
@@ -861,7 +930,7 @@ static void br_multicast_send_query(struct net_bridge *br,
 	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
-	__br_multicast_send_query(br, port, &br_group);
+	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0);
 
 	time = jiffies;
 	time += own_query->startup_sent < br->multicast_startup_query_count ?
@@ -1522,7 +1591,8 @@ br_multicast_leave_group(struct net_bridge *br,
 		goto out;
 
 	if (br_opt_get(br, BROPT_MULTICAST_QUERIER)) {
-		__br_multicast_send_query(br, port, &mp->addr);
+		__br_multicast_send_query(br, port, NULL, NULL, &mp->addr,
+					  false, 0);
 
 		time = jiffies + br->multicast_last_member_count *
 				 br->multicast_last_member_interval;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d30533d310c5..4ae371b632d1 100644
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

