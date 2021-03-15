Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469BC33C3EF
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhCORPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbhCORPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:15:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DDCC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:15:37 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ci14so67407689ejc.7
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 10:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ESTLeD/rRbQ5zUXrpQ5m0lZ6N9szWSKZTky7aqh4MOU=;
        b=wpPPFeF9U8eYSajnF91c+M3CErL8izt8nMG5KcuEzkbRi7Cgk1AV1DE6aE3Bruqehw
         O2a2EVeRIvkxrLcEh9N+rkHP5OiXXBPliZqwKtdJ2k+T8QyoiJ8xLvvFKN2yGRekTYSw
         xZsTkHaxRmTK5blRe8rpaVx9HVhmwwIUjoGIs9A3T6wQjy7199vvLuuuNuqm9ZHJ0Qix
         FKXSZjNJa5fceqrzhkqtDFsNNbNwUe8avZqE1LEno0gvZ1b3Nvu82C0CR0Oo80eRa0yF
         3FABXlNPA7k/kvTI2D41qJGmPuMj1Md8pz96j9RRd/Aw6YTPEmyFLgR6APxrC/DMnP4I
         PPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESTLeD/rRbQ5zUXrpQ5m0lZ6N9szWSKZTky7aqh4MOU=;
        b=NPFjZu1Jw+4mh2lID5vo5SXFHDJSqeswpZoipBTAkKprRWU2oPMb0mw1CSl37kdZBr
         TsWH/AVEvBTERRLyVpCtcTA+1pEcDUjAzUaYv5mlLXWaT8nh03O0EqFuRnKQulmgDX6W
         NjvJLyo/vVf5UzX5+L6HgHBQiZlq1nnsVlwl38fASbcTnalvBgg+xCzgg7FAfoVxEiMt
         KaGtWleuQYYdiOSpJy0S8JDsF3V2cmpsot60cQNoq07t35DkkgLHgdpfd/mXYRowQB65
         m446AbATOLfusqLm5lgJA9rmA5p3i9MfpKcLtfCng710gFNhbRO2a/CFHEHU6EeqFlrq
         HFWA==
X-Gm-Message-State: AOAM532/4ucDxbuGn9LV5ION8b1KYyb2niDqw+hazelE2ER5dFUAgXWc
        sejznLeA+0meu3u6YIavGvVb3nGSIaCs+Pld
X-Google-Smtp-Source: ABdhPJzcDyJksw9ZzvLJjdcHPxxTxlpcT893mxbBxwgb+33KAnJYHq1Ku1WEQeo4kGf9nQnJ2Zc9+Q==
X-Received: by 2002:a17:906:b0d8:: with SMTP id bk24mr25462400ejb.252.1615828535505;
        Mon, 15 Mar 2021 10:15:35 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b12sm8297369eds.94.2021.03.15.10.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:15:35 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 2/2] net: bridge: mcast: factor out common allow/block EHT handling
Date:   Mon, 15 Mar 2021 19:13:42 +0200
Message-Id: <20210315171342.232809-3-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315171342.232809-1-razor@blackwall.org>
References: <20210315171342.232809-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We hande EHT state change for ALLOW messages in INCLUDE mode and for
BLOCK messages in EXCLUDE mode similarly - create the new set entries
with the proper filter mode. We also handle EHT state change for ALLOW
messages in EXCLUDE mode and for BLOCK messages in INCLUDE mode in a
similar way - delete the common entries (current set and new set).
Factor out all the common code as follows:
 - ALLOW/INCLUDE, BLOCK/EXCLUDE: call __eht_create_set_entries()
 - ALLOW/EXCLUDE, BLOCK/INCLUDE: call __eht_del_common_set_entries()

The set entries creation can be reused in __eht_inc_exc() as well.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast_eht.c | 98 ++++++++++-------------------------
 1 file changed, 27 insertions(+), 71 deletions(-)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index 982398e44658..13290a749d09 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -498,11 +498,13 @@ static void br_multicast_del_eht_host(struct net_bridge_port_group *pg,
 					       &set_h->h_addr);
 }
 
-static void __eht_allow_incl(struct net_bridge_port_group *pg,
-			     union net_bridge_eht_addr *h_addr,
-			     void *srcs,
-			     u32 nsrcs,
-			     size_t addr_size)
+/* create new set entries from reports */
+static void __eht_create_set_entries(struct net_bridge_port_group *pg,
+				     union net_bridge_eht_addr *h_addr,
+				     void *srcs,
+				     u32 nsrcs,
+				     size_t addr_size,
+				     int filter_mode)
 {
 	union net_bridge_eht_addr eht_src_addr;
 	u32 src_idx;
@@ -511,16 +513,17 @@ static void __eht_allow_incl(struct net_bridge_port_group *pg,
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
 		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
-						  MCAST_INCLUDE,
+						  filter_mode,
 						  false);
 	}
 }
 
-static bool __eht_allow_excl(struct net_bridge_port_group *pg,
-			     union net_bridge_eht_addr *h_addr,
-			     void *srcs,
-			     u32 nsrcs,
-			     size_t addr_size)
+/* delete existing set entries and their (S,G) entries if they were the last */
+static bool __eht_del_set_entries(struct net_bridge_port_group *pg,
+				  union net_bridge_eht_addr *h_addr,
+				  void *srcs,
+				  u32 nsrcs,
+				  size_t addr_size)
 {
 	union net_bridge_eht_addr eht_src_addr;
 	struct net_bridge_group_src *src_ent;
@@ -529,10 +532,11 @@ static bool __eht_allow_excl(struct net_bridge_port_group *pg,
 	u32 src_idx;
 
 	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->key.addr.proto;
 	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
 		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr,
-						    h_addr))
+		if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr, h_addr))
 			continue;
 		memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
 		src_ent = br_multicast_find_group_src(pg, &src_ip);
@@ -555,64 +559,18 @@ static bool br_multicast_eht_allow(struct net_bridge_port_group *pg,
 
 	switch (br_multicast_eht_host_filter_mode(pg, h_addr)) {
 	case MCAST_INCLUDE:
-		__eht_allow_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		__eht_create_set_entries(pg, h_addr, srcs, nsrcs, addr_size,
+					 MCAST_INCLUDE);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __eht_allow_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __eht_del_set_entries(pg, h_addr, srcs, nsrcs,
+						addr_size);
 		break;
 	}
 
 	return changed;
 }
 
-static bool __eht_block_incl(struct net_bridge_port_group *pg,
-			     union net_bridge_eht_addr *h_addr,
-			     void *srcs,
-			     u32 nsrcs,
-			     size_t addr_size)
-{
-	union net_bridge_eht_addr eht_src_addr;
-	struct net_bridge_group_src *src_ent;
-	bool changed = false;
-	struct br_ip src_ip;
-	u32 src_idx;
-
-	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
-	memset(&src_ip, 0, sizeof(src_ip));
-	src_ip.proto = pg->key.addr.proto;
-	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		if (!br_multicast_del_eht_set_entry(pg, &eht_src_addr, h_addr))
-			continue;
-		memcpy(&src_ip, srcs + (src_idx * addr_size), addr_size);
-		src_ent = br_multicast_find_group_src(pg, &src_ip);
-		if (!src_ent)
-			continue;
-		br_multicast_del_group_src(src_ent, true);
-		changed = true;
-	}
-
-	return changed;
-}
-
-static void __eht_block_excl(struct net_bridge_port_group *pg,
-			     union net_bridge_eht_addr *h_addr,
-			     void *srcs,
-			     u32 nsrcs,
-			     size_t addr_size)
-{
-	union net_bridge_eht_addr eht_src_addr;
-	u32 src_idx;
-
-	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
-	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
-						  MCAST_EXCLUDE,
-						  false);
-	}
-}
-
 static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 				   union net_bridge_eht_addr *h_addr,
 				   void *srcs,
@@ -623,10 +581,12 @@ static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 
 	switch (br_multicast_eht_host_filter_mode(pg, h_addr)) {
 	case MCAST_INCLUDE:
-		changed = __eht_block_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __eht_del_set_entries(pg, h_addr, srcs, nsrcs,
+						addr_size);
 		break;
 	case MCAST_EXCLUDE:
-		__eht_block_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		__eht_create_set_entries(pg, h_addr, srcs, nsrcs, addr_size,
+					 MCAST_EXCLUDE);
 		break;
 	}
 
@@ -644,7 +604,6 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 {
 	bool changed = false, flush_entries = to_report;
 	union net_bridge_eht_addr eht_src_addr;
-	u32 src_idx;
 
 	if (br_multicast_eht_host_filter_mode(pg, h_addr) != filter_mode)
 		flush_entries = true;
@@ -653,11 +612,8 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 	/* if we're changing mode del host and its entries */
 	if (flush_entries)
 		br_multicast_del_eht_host(pg, h_addr);
-	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
-		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
-		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
-						  filter_mode, false);
-	}
+	__eht_create_set_entries(pg, h_addr, srcs, nsrcs, addr_size,
+				 filter_mode);
 	/* we can be missing sets only if we've deleted some entries */
 	if (flush_entries) {
 		struct net_bridge *br = pg->key.port->br;
-- 
2.29.2

