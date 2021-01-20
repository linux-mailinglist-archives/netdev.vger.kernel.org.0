Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F72FD45C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbhATPlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390065AbhATOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:22 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88560C06179C
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:15 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gx5so14655167ejb.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OjWISbPB8HC46NGN9v+RAYWTAaENcUvF2CdBvQ4rsYE=;
        b=McFH6yJcgZ67BI5GI0pAosMG9GYjI2slMPWrfwnFstoKHhPVMA7ZF+9VhSm3+1xisa
         VQ1TrEn43SnUafmN7ZvHdxgMOVnmqPX50Qas380Gkx1SE4P03u10bOakEM4RNVD0lEJO
         lj25X/gH7uLTVbfYT02IdwNVP92euMRh7XwS+QxxpAAiTqNtK+4aJSJ6F87+L61BkROf
         u8ZST3vwNgFTKCqkOcSxL9yyxFfsPEQteT2Z3KPsXXJWxtt5z9ByczcZggApyPcageKH
         YgpvvT1WL5M3doDL+jaRvYqD1UMyNNTFxuMyHtMrh3NS5cNlbTP+FlO0IbJSaDlC9NFs
         DeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OjWISbPB8HC46NGN9v+RAYWTAaENcUvF2CdBvQ4rsYE=;
        b=kfYlJx4bkYdk6LV2Cx+nkci8gQaZzIjNZavYe+vUeI9772gCeAN9h5UDmgLjO8IBL3
         lny+EH+uM80IbnwInFGYxA7h+6mBhjKXrJW7fTfnDotLs37U1kzo5FHYlyWW2SvbIdOh
         wV0ZeBQ9Z5c7ljN9HJ8bh5kIe14M3MUlONiMPT9hi8rLtsh3b5ya+SirA7V7QNno2oTw
         bqD9/s/YXbEbW2uEKP97F4L3f0lEKooBIKUU7XHbXWJ3/Wn4uRB6YIM9sntQDE2Y2we9
         f56wag4GzIndEQHBH8WGVZdqTX+GpYxUrnQ+ygsXSHmd3iXi4RRr5g8zPZiz787uoCOL
         e7fg==
X-Gm-Message-State: AOAM533+j9/tTcfZc8B7A6CeCR0ob/k5FtCJrKma/UNmmVyzGXDJ1I0Q
        FE3ZbZUJ4NWTRgrTwRCO6E/cRG+OuyYbzLZpRz4=
X-Google-Smtp-Source: ABdhPJwTMO19YXxcpfZt6A+C0TPq4gxRVH3CZ2Ehdw2kok2UAPY8zwPXaqZ7Cr7zaxcaFj5Ytk8kgQ==
X-Received: by 2002:a17:906:803:: with SMTP id e3mr6214019ejd.346.1611154393673;
        Wed, 20 Jan 2021 06:53:13 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:12 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 09/14] net: bridge: multicast: add EHT allow/block handling
Date:   Wed, 20 Jan 2021 16:51:58 +0200
Message-Id: <20210120145203.1109140-10-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for IGMPv3/MLDv2 allow/block EHT handling. Similar to how
the reports are processed we have 2 cases when the group is in include
or exclude mode, these are processed as follows:
 - group include
  - allow: create missing entries
  - block: remove existing matching entries and remove the corresponding
    S,G entries if there are no more set host entries, then possibly
    delete the whole group if there are no more S,G entries

 - group exclude
  - allow
    - host include: create missing entries
    - host exclude: remove existing matching entries and remove the
      corresponding S,G entries if there are no more set host entries
  - block
    - host include: remove existing matching entries and remove the
      corresponding S,G entries if there are no more set host entries,
      then possibly delete the whole group if there are no more S,G entries
    - host exclude: create missing entries

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c         |  43 +++--
 net/bridge/br_multicast_eht.c     | 252 ++++++++++++++++++++++++++++++
 net/bridge/br_private.h           |   3 +
 net/bridge/br_private_mcast_eht.h |   6 +
 4 files changed, 290 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ac363b104239..3b8c5d1d0c55 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -560,7 +560,7 @@ static void br_multicast_destroy_group_src(struct net_bridge_mcast_gc *gc)
 	kfree_rcu(src, rcu);
 }
 
-static void br_multicast_del_group_src(struct net_bridge_group_src *src)
+void br_multicast_del_group_src(struct net_bridge_group_src *src)
 {
 	struct net_bridge *br = src->pg->key.port->br;
 
@@ -1092,7 +1092,7 @@ static void br_multicast_group_src_expired(struct timer_list *t)
 	spin_unlock(&br->multicast_lock);
 }
 
-static struct net_bridge_group_src *
+struct net_bridge_group_src *
 br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
 {
 	struct net_bridge_group_src *ent;
@@ -1804,7 +1804,8 @@ static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
  * EXCLUDE (X,Y)  ALLOW (A)     EXCLUDE (X+A,Y-A)        (A)=GMI
  */
 static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_addr,
-				     void *srcs, u32 nsrcs, size_t addr_size)
+				     void *srcs, u32 nsrcs, size_t addr_size,
+				     int grec_type)
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
@@ -1828,6 +1829,9 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_a
 			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	return changed;
 }
 
@@ -2140,7 +2144,7 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg, void *h_addr,
  * INCLUDE (A)    BLOCK (B)     INCLUDE (A)              Send Q(G,A*B)
  */
 static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
-				 void *srcs, u32 nsrcs, size_t addr_size)
+				 void *srcs, u32 nsrcs, size_t addr_size, int grec_type)
 {
 	struct net_bridge_group_src *ent;
 	u32 src_idx, to_send = 0;
@@ -2161,6 +2165,9 @@ static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
 
@@ -2180,7 +2187,7 @@ static bool __grp_src_block_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Send Q(G,A-Y)
  */
 static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
-				 void *srcs, u32 nsrcs, size_t addr_size)
+				 void *srcs, u32 nsrcs, size_t addr_size, int grec_type)
 {
 	struct net_bridge_group_src *ent;
 	u32 src_idx, to_send = 0;
@@ -2208,6 +2215,9 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
 
@@ -2215,16 +2225,18 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg, void *h_addr,
 }
 
 static bool br_multicast_block(struct net_bridge_port_group *pg, void *h_addr,
-			       void *srcs, u32 nsrcs, size_t addr_size)
+			       void *srcs, u32 nsrcs, size_t addr_size, int grec_type)
 {
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		changed = __grp_src_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_block_incl(pg, h_addr, srcs, nsrcs, addr_size,
+					       grec_type);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_block_excl(pg, h_addr, srcs, nsrcs, addr_size,
+					       grec_type);
 		break;
 	}
 
@@ -2327,11 +2339,11 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		switch (type) {
 		case IGMPV3_ALLOW_NEW_SOURCES:
 			changed = br_multicast_isinc_allow(pg, h_addr, grec->grec_src,
-							   nsrcs, sizeof(__be32));
+							   nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_MODE_IS_INCLUDE:
 			changed = br_multicast_isinc_allow(pg, h_addr, grec->grec_src,
-							   nsrcs, sizeof(__be32));
+							   nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_MODE_IS_EXCLUDE:
 			changed = br_multicast_isexc(pg, h_addr, grec->grec_src,
@@ -2347,7 +2359,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			break;
 		case IGMPV3_BLOCK_OLD_SOURCES:
 			changed = br_multicast_block(pg, h_addr, grec->grec_src,
-						     nsrcs, sizeof(__be32));
+						     nsrcs, sizeof(__be32), type);
 			break;
 		}
 		if (changed)
@@ -2455,12 +2467,14 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		case MLD2_ALLOW_NEW_SOURCES:
 			changed = br_multicast_isinc_allow(pg, h_addr,
 							   grec->grec_src, nsrcs,
-							   sizeof(struct in6_addr));
+							   sizeof(struct in6_addr),
+							   grec->grec_type);
 			break;
 		case MLD2_MODE_IS_INCLUDE:
 			changed = br_multicast_isinc_allow(pg, h_addr,
 							   grec->grec_src, nsrcs,
-							   sizeof(struct in6_addr));
+							   sizeof(struct in6_addr),
+							   grec->grec_type);
 			break;
 		case MLD2_MODE_IS_EXCLUDE:
 			changed = br_multicast_isexc(pg, h_addr,
@@ -2480,7 +2494,8 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		case MLD2_BLOCK_OLD_SOURCES:
 			changed = br_multicast_block(pg, h_addr,
 						     grec->grec_src, nsrcs,
-						     sizeof(struct in6_addr));
+						     sizeof(struct in6_addr),
+						     grec->grec_type);
 			break;
 		}
 		if (changed)
diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index 409fced7eae2..43f60388df16 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -366,6 +366,21 @@ __eht_lookup_create_set(struct net_bridge_port_group *pg,
 	return eht_set;
 }
 
+static void br_multicast_ip_src_to_eht_addr(const struct br_ip *src,
+					    union net_bridge_eht_addr *dest)
+{
+	switch (src->proto) {
+	case htons(ETH_P_IP):
+		dest->ip4 = src->src.ip4;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		memcpy(&dest->ip6, &src->src.ip6, sizeof(struct in6_addr));
+		break;
+#endif
+	}
+}
+
 static void br_multicast_create_eht_set_entry(struct net_bridge_port_group *pg,
 					      union net_bridge_eht_addr *src_addr,
 					      union net_bridge_eht_addr *h_addr,
@@ -451,3 +466,240 @@ static void br_multicast_del_eht_host(struct net_bridge_port_group *pg,
 					       &set_h->eht_set->src_addr,
 					       &set_h->h_addr);
 }
+
+static void __eht_allow_incl(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     size_t addr_size)
+{
+	union net_bridge_eht_addr eht_src_addr;
+	u32 src_idx;
+
+	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
+		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
+						  MCAST_INCLUDE,
+						  false);
+	}
+}
+
+static bool __eht_allow_excl(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     size_t addr_size)
+{
+	bool changed = false, host_excl = false;
+	union net_bridge_eht_addr eht_src_addr;
+	struct net_bridge_group_src *src_ent;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	host_excl = !!(br_multicast_eht_host_filter_mode(pg, h_addr) == MCAST_EXCLUDE);
+	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
+		if (!host_excl) {
+			br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
+							  MCAST_INCLUDE,
+							  false);
+		} else {
+			if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr,
+							    h_addr))
+				continue;
+			memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
+			src_ent = br_multicast_find_group_src(pg, &src_ip);
+			if (!src_ent)
+				continue;
+			br_multicast_del_group_src(src_ent);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+
+static bool br_multicast_eht_allow(struct net_bridge_port_group *pg,
+				   union net_bridge_eht_addr *h_addr,
+				   void *srcs,
+				   u32 nsrcs,
+				   size_t addr_size)
+{
+	bool changed = false;
+
+	switch (br_multicast_eht_host_filter_mode(pg, h_addr)) {
+	case MCAST_INCLUDE:
+		__eht_allow_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		break;
+	case MCAST_EXCLUDE:
+		changed = __eht_allow_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		break;
+	}
+
+	return changed;
+}
+
+static bool __eht_block_incl(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     size_t addr_size)
+{
+	union net_bridge_eht_addr eht_src_addr;
+	struct net_bridge_group_src *src_ent;
+	bool changed = false;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->key.addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
+		if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr, h_addr))
+			continue;
+		memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
+		src_ent = br_multicast_find_group_src(pg, &src_ip);
+		if (!src_ent)
+			continue;
+		br_multicast_del_group_src(src_ent);
+		changed = true;
+	}
+
+	return changed;
+}
+
+static bool __eht_block_excl(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     size_t addr_size)
+{
+	bool changed = false, host_excl = false;
+	union net_bridge_eht_addr eht_src_addr;
+	struct net_bridge_group_src *src_ent;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	host_excl = !!(br_multicast_eht_host_filter_mode(pg, h_addr) == MCAST_EXCLUDE);
+	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->key.addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
+		if (host_excl) {
+			br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
+							  MCAST_EXCLUDE,
+							  false);
+		} else {
+			if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr,
+							    h_addr))
+				continue;
+			memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
+			src_ent = br_multicast_find_group_src(pg, &src_ip);
+			if (!src_ent)
+				continue;
+			br_multicast_del_group_src(src_ent);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+
+static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
+				   union net_bridge_eht_addr *h_addr,
+				   void *srcs,
+				   u32 nsrcs,
+				   size_t addr_size)
+{
+	bool changed = false;
+
+	switch (br_multicast_eht_host_filter_mode(pg, h_addr)) {
+	case MCAST_INCLUDE:
+		changed = __eht_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		break;
+	case MCAST_EXCLUDE:
+		changed = __eht_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		break;
+	}
+
+	return changed;
+}
+
+static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     int grec_type)
+{
+	bool changed = false;
+
+	switch (grec_type) {
+	case IGMPV3_ALLOW_NEW_SOURCES:
+		br_multicast_eht_allow(pg, h_addr, srcs, nsrcs, sizeof(__be32));
+		break;
+	case IGMPV3_BLOCK_OLD_SOURCES:
+		changed = br_multicast_eht_block(pg, h_addr, srcs, nsrcs,
+						 sizeof(__be32));
+		break;
+	}
+
+	return changed;
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
+			     union net_bridge_eht_addr *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     int grec_type)
+{
+	bool changed = false;
+
+	switch (grec_type) {
+	case MLD2_ALLOW_NEW_SOURCES:
+		br_multicast_eht_allow(pg, h_addr, srcs, nsrcs,
+				       sizeof(struct in6_addr));
+		break;
+	case MLD2_BLOCK_OLD_SOURCES:
+		changed = br_multicast_eht_block(pg, h_addr, srcs, nsrcs,
+						 sizeof(struct in6_addr));
+		break;
+	}
+
+	return changed;
+}
+#endif
+
+/* true means an entry was deleted */
+bool br_multicast_eht_handle(struct net_bridge_port_group *pg,
+			     void *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     size_t addr_size,
+			     int grec_type)
+{
+	bool eht_enabled = !!(pg->key.port->flags & BR_MULTICAST_FAST_LEAVE);
+	union net_bridge_eht_addr eht_host_addr;
+	bool changed = false;
+
+	if (!eht_enabled)
+		goto out;
+
+	memset(&eht_host_addr, 0, sizeof(eht_host_addr));
+	memcpy(&eht_host_addr, h_addr, addr_size);
+	if (addr_size == sizeof(__be32))
+		changed = __eht_ip4_handle(pg, &eht_host_addr, srcs, nsrcs,
+					   grec_type);
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		changed = __eht_ip6_handle(pg, &eht_host_addr, srcs, nsrcs,
+					   grec_type);
+#endif
+
+out:
+	return changed;
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 0bf4c544a5da..cad967690e9f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -848,6 +848,9 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 				     u8 filter_mode);
 void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 				       struct net_bridge_port_group *sg);
+struct net_bridge_group_src *
+br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
+void br_multicast_del_group_src(struct net_bridge_group_src *src);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
diff --git a/net/bridge/br_private_mcast_eht.h b/net/bridge/br_private_mcast_eht.h
index bba507c9acb0..92933822301d 100644
--- a/net/bridge/br_private_mcast_eht.h
+++ b/net/bridge/br_private_mcast_eht.h
@@ -48,5 +48,11 @@ struct net_bridge_group_eht_set {
 };
 
 void br_multicast_eht_clean_sets(struct net_bridge_port_group *pg);
+bool br_multicast_eht_handle(struct net_bridge_port_group *pg,
+			     void *h_addr,
+			     void *srcs,
+			     u32 nsrcs,
+			     size_t addr_size,
+			     int grec_type);
 
 #endif /* _BR_PRIVATE_MCAST_EHT_H_ */
-- 
2.29.2

