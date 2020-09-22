Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E78273BF2
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgIVHa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbgIVHaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F08C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:51 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id b79so2211082wmb.4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tyoSfgxjIdkHay3lQPIo6DBSKBZ7kiAjyZijVRqB9EU=;
        b=wRptmNgpIj9wuklliEsfaoVa7qmvdG2d5NC1lOEut1ozl4YW6ZnFDaL8Hi8pkQari4
         ot3Ad2a3QoWkI/nIWeQ6TXzUOIFdd8NHbPLpBPdixtSI+pLQTunZzoG4IcuFhvnqidxt
         UsWB87tIE3JVptyEei4CBn6VPkFQaMIfxMiWd69Gip7dF9hs8rm1r4UNYaRnL0HO9dvA
         MXIlkXowwqAfl0eIayoP9EDJygiK8QHHCU8qsXyyXJyc7ML+NwJUWZpUDMVAvOOkvNcq
         zRe0+EJ+gJ2GOSfLM9LWkBlxOqWhhp4pf7OjK8ITBITrXHFwQCXut4nm5ZaTpFnvAv2Q
         GaeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tyoSfgxjIdkHay3lQPIo6DBSKBZ7kiAjyZijVRqB9EU=;
        b=UqTwESN9pGzxvm3wu7iiI0sqyZIR1A/UgQnY67pVhmcXN21XsDvIpdf0Wv8y87bsJw
         I3N/m/bdRbdW/xxLvMu3QoE/02vcPDvdsNOhgiRzgi+EvusLFMTG3XjmIL3AEJfjekY8
         m9WEcleuNmr+yNGfKegkYJsDBfnu0EGRVu6ZqLYt4KOS0niiIlmrxYi3PAxNd5WlaCLS
         HGeZtN7RHzJmubpnAGplzGD34PTUX9MYVoFySce5+zlBFINJJbnD8Ib17ipQzM+YIwcA
         Z+IfaHNfE4E2bmscC2ptOrwttjt74yQVo0+J7B7YQP1K1VxaiId178vvn8x6ddH44LTc
         zTxQ==
X-Gm-Message-State: AOAM533cOWPplAcG+IBGWfoe3d+HznZ2Bvhe0DzlghHIXFmZoBwzv69j
        Ra2iF8zWrSMkbf2SnC8MMCxEcJ6qy0UWJKBxUjCTKw==
X-Google-Smtp-Source: ABdhPJyEqrARPrOSwv8D9NNfZH6xNXGadyFgG+jCTGq7Z0d1fJwN08ul3cuDo811/MqqRxnMcEAM6w==
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr3130537wmg.72.1600759849698;
        Tue, 22 Sep 2020 00:30:49 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:48 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 05/16] net: bridge: mcast: use br_ip's src for src groups and querier address
Date:   Tue, 22 Sep 2020 10:30:16 +0300
Message-Id: <20200922073027.1196992-6-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Now that we have src and dst in br_ip it is logical to use the src field
for the cases where we need to work with a source address such as
querier source address and group source address.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c       |  4 +--
 net/bridge/br_multicast.c | 56 +++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 1df62d887953..269ffd2e549b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -98,7 +98,7 @@ static int __mdb_fill_srcs(struct sk_buff *skb,
 		switch (ent->addr.proto) {
 		case htons(ETH_P_IP):
 			if (nla_put_in_addr(skb, MDBA_MDB_SRCATTR_ADDRESS,
-					    ent->addr.u.ip4)) {
+					    ent->addr.src.ip4)) {
 				nla_nest_cancel(skb, nest_ent);
 				goto out_cancel_err;
 			}
@@ -106,7 +106,7 @@ static int __mdb_fill_srcs(struct sk_buff *skb,
 #if IS_ENABLED(CONFIG_IPV6)
 		case htons(ETH_P_IPV6):
 			if (nla_put_in6_addr(skb, MDBA_MDB_SRCATTR_ADDRESS,
-					     &ent->addr.u.ip6)) {
+					     &ent->addr.src.ip6)) {
 				nla_nest_cancel(skb, nest_ent);
 				goto out_cancel_err;
 			}
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e77f1e27caf7..a899c22c8f57 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -423,7 +423,7 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 			if (over_lmqt == time_after(ent->timer.expires,
 						    lmqt) &&
 			    ent->src_query_rexmit_cnt > 0) {
-				ihv3->srcs[lmqt_srcs++] = ent->addr.u.ip4;
+				ihv3->srcs[lmqt_srcs++] = ent->addr.src.ip4;
 				ent->src_query_rexmit_cnt--;
 				if (need_rexmit && ent->src_query_rexmit_cnt)
 					*need_rexmit = true;
@@ -584,7 +584,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 			if (over_llqt == time_after(ent->timer.expires,
 						    llqt) &&
 			    ent->src_query_rexmit_cnt > 0) {
-				mld2q->mld2q_srcs[llqt_srcs++] = ent->addr.u.ip6;
+				mld2q->mld2q_srcs[llqt_srcs++] = ent->addr.src.ip6;
 				ent->src_query_rexmit_cnt--;
 				if (need_rexmit && ent->src_query_rexmit_cnt)
 					*need_rexmit = true;
@@ -717,13 +717,13 @@ br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
 	switch (ip->proto) {
 	case htons(ETH_P_IP):
 		hlist_for_each_entry(ent, &pg->src_list, node)
-			if (ip->u.ip4 == ent->addr.u.ip4)
+			if (ip->src.ip4 == ent->addr.src.ip4)
 				return ent;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		hlist_for_each_entry(ent, &pg->src_list, node)
-			if (!ipv6_addr_cmp(&ent->addr.u.ip6, &ip->u.ip6))
+			if (!ipv6_addr_cmp(&ent->addr.src.ip6, &ip->src.ip6))
 				return ent;
 		break;
 #endif
@@ -742,14 +742,14 @@ br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_i
 
 	switch (src_ip->proto) {
 	case htons(ETH_P_IP):
-		if (ipv4_is_zeronet(src_ip->u.ip4) ||
-		    ipv4_is_multicast(src_ip->u.ip4))
+		if (ipv4_is_zeronet(src_ip->src.ip4) ||
+		    ipv4_is_multicast(src_ip->src.ip4))
 			return NULL;
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		if (ipv6_addr_any(&src_ip->u.ip6) ||
-		    ipv6_addr_is_multicast(&src_ip->u.ip6))
+		if (ipv6_addr_any(&src_ip->src.ip6) ||
+		    ipv6_addr_is_multicast(&src_ip->src.ip6))
 			return NULL;
 		break;
 #endif
@@ -1019,10 +1019,10 @@ static void br_multicast_select_own_querier(struct net_bridge *br,
 					    struct sk_buff *skb)
 {
 	if (ip->proto == htons(ETH_P_IP))
-		br->ip4_querier.addr.u.ip4 = ip_hdr(skb)->saddr;
+		br->ip4_querier.addr.src.ip4 = ip_hdr(skb)->saddr;
 #if IS_ENABLED(CONFIG_IPV6)
 	else
-		br->ip6_querier.addr.u.ip6 = ipv6_hdr(skb)->saddr;
+		br->ip6_querier.addr.src.ip6 = ipv6_hdr(skb)->saddr;
 #endif
 }
 
@@ -1399,7 +1399,7 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (!ent) {
 			ent = br_multicast_new_group_src(pg, &src_ip);
@@ -1433,7 +1433,7 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent)
 			ent->flags &= ~BR_SGRP_F_DELETE;
@@ -1467,7 +1467,7 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags &= ~BR_SGRP_F_DELETE;
@@ -1530,7 +1530,7 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags &= ~BR_SGRP_F_SEND;
@@ -1573,7 +1573,7 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			if (timer_pending(&ent->timer)) {
@@ -1634,7 +1634,7 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags = (ent->flags & ~BR_SGRP_F_DELETE) |
@@ -1672,7 +1672,7 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags &= ~BR_SGRP_F_DELETE;
@@ -1736,7 +1736,7 @@ static void __grp_src_block_incl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (ent) {
 			ent->flags |= BR_SGRP_F_SEND;
@@ -1770,7 +1770,7 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg,
 	memset(&src_ip, 0, sizeof(src_ip));
 	src_ip.proto = pg->addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&src_ip.u, srcs, src_size);
+		memcpy(&src_ip.src, srcs, src_size);
 		ent = br_multicast_find_group_src(pg, &src_ip);
 		if (!ent) {
 			ent = br_multicast_new_group_src(pg, &src_ip);
@@ -2071,16 +2071,16 @@ static bool br_ip4_multicast_select_querier(struct net_bridge *br,
 	    !timer_pending(&br->ip4_other_query.timer))
 		goto update;
 
-	if (!br->ip4_querier.addr.u.ip4)
+	if (!br->ip4_querier.addr.src.ip4)
 		goto update;
 
-	if (ntohl(saddr) <= ntohl(br->ip4_querier.addr.u.ip4))
+	if (ntohl(saddr) <= ntohl(br->ip4_querier.addr.src.ip4))
 		goto update;
 
 	return false;
 
 update:
-	br->ip4_querier.addr.u.ip4 = saddr;
+	br->ip4_querier.addr.src.ip4 = saddr;
 
 	/* update protected by general multicast_lock by caller */
 	rcu_assign_pointer(br->ip4_querier.port, port);
@@ -2097,13 +2097,13 @@ static bool br_ip6_multicast_select_querier(struct net_bridge *br,
 	    !timer_pending(&br->ip6_other_query.timer))
 		goto update;
 
-	if (ipv6_addr_cmp(saddr, &br->ip6_querier.addr.u.ip6) <= 0)
+	if (ipv6_addr_cmp(saddr, &br->ip6_querier.addr.src.ip6) <= 0)
 		goto update;
 
 	return false;
 
 update:
-	br->ip6_querier.addr.u.ip6 = *saddr;
+	br->ip6_querier.addr.src.ip6 = *saddr;
 
 	/* update protected by general multicast_lock by caller */
 	rcu_assign_pointer(br->ip6_querier.port, port);
@@ -2118,10 +2118,10 @@ static bool br_multicast_select_querier(struct net_bridge *br,
 {
 	switch (saddr->proto) {
 	case htons(ETH_P_IP):
-		return br_ip4_multicast_select_querier(br, port, saddr->u.ip4);
+		return br_ip4_multicast_select_querier(br, port, saddr->src.ip4);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		return br_ip6_multicast_select_querier(br, port, &saddr->u.ip6);
+		return br_ip6_multicast_select_querier(br, port, &saddr->src.ip6);
 #endif
 	}
 
@@ -2263,7 +2263,7 @@ static void br_ip4_multicast_query(struct net_bridge *br,
 
 	if (!group) {
 		saddr.proto = htons(ETH_P_IP);
-		saddr.u.ip4 = iph->saddr;
+		saddr.src.ip4 = iph->saddr;
 
 		br_multicast_query_received(br, port, &br->ip4_other_query,
 					    &saddr, max_delay);
@@ -2351,7 +2351,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 
 	if (is_general_query) {
 		saddr.proto = htons(ETH_P_IPV6);
-		saddr.u.ip6 = ipv6_hdr(skb)->saddr;
+		saddr.src.ip6 = ipv6_hdr(skb)->saddr;
 
 		br_multicast_query_received(br, port, &br->ip6_other_query,
 					    &saddr, max_delay);
-- 
2.25.4

