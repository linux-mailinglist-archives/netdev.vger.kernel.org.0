Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F032FD45E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390110AbhATPla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390071AbhATOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:22 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E0EC06179E
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:16 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id l9so28202525ejx.3
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uNE7y77lbdLDnfOJ4rQsshk9o2iRhWsVjlqN+VPgGno=;
        b=rW+h8B8xiWjFYj3WWrGe+0J990O5dWr4rmDCAgOL/eeyfFnbSijgT5me8/0IrtIELB
         gqmIrleJ3Aml3g0mfojvYzw4PknhuRpKaJTzzMwI4GUT2vdAYFTeY+MxOBEZYOqVFot6
         Nfn7iQ3HJhlvwBQ3uetM12q2SdTJAksLP+dyVtJjZZRqojqsf5kQyoNkpe9l6zKentDt
         zF7TRr3yOdt39VVukxOgUpkmS64TjON0oAuOjfiWFNxWRI0pmujy6BDU70G6T3Fjs6uT
         1iprFD+JG0ePqjPGZPHRVSNjfdShTirDt+2Ar6ShyN2rC7eH1CBpVKS50nupiNBCJzqn
         tGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uNE7y77lbdLDnfOJ4rQsshk9o2iRhWsVjlqN+VPgGno=;
        b=Zto9uuz/wSX7UEHanrLs2XtUIyvzpbLy6JXBZDjPt/c3HaoHWswVhkOFnjIIKv2rO8
         86wB1dLGa7TQOkKzybw67+ghn7HOullDxs/iUH7ulHdY/3f0SiwSh4pGgL7UNnif4aRH
         X5aHj0H/Rb4aqgM8z5X5lv4MwG4qYQ9zX5RFBALU7xRVdGmQ1vbkWlFvw9Gs7VNFUZb2
         sIrVaGerLw0YL+WX1JEq8MzYA2dY8wHLLLjPRVZ1w2Nx20EvH3kaO7tn1N5hz76ZVcnT
         7R9FbMMVfvKAKJDMBMzYXIQrUoDnKag+jHZIVR9kn68YifPKBf3YB6sVE4UgaMB77cSR
         AqzQ==
X-Gm-Message-State: AOAM531T2U6kV4Ac0+iTzac8pSVUFsWm1J2yeV5mrTTqvi+seBb0NU6q
        Ot/tfZs880nbnGY4b3bu7Fdvg5k9Kf352/ElmwA=
X-Google-Smtp-Source: ABdhPJxcThI8AFKgjNJYJrGAn7VYKlQZAHgmLvDvnLwxMYWodNzVUyUGEroM7wTTx1EEwGNrDoiBdA==
X-Received: by 2002:a17:906:b042:: with SMTP id bj2mr6278382ejb.261.1611154394784;
        Wed, 20 Jan 2021 06:53:14 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:14 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 10/14] net: bridge: multicast: add EHT include and exclude handling
Date:   Wed, 20 Jan 2021 16:51:59 +0200
Message-Id: <20210120145203.1109140-11-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for IGMPv3/MLDv2 include and exclude EHT handling. Similar to
how the reports are processed we have 2 cases when the group is in include
or exclude mode, these are processed as follows:
 - group include
  - is_include: create missing entries
  - to_include: flush existing entries and create a new set from the
    report, obviously if the src set is empty then we delete the group

 - group exclude
  - is_exclude: create missing entries
  - to_exclude: flush existing entries and create a new set from the
    report, any empty source set entries are removed

If the group is in a different mode then we just flush all entries reported
by the host and we create a new set with the new mode entries created from
the report. If the report is include type, the source list is empty and
the group has empty sources' set then we remove it. Any source set entries
which are empty are removed as well. If the group is in exclude mode it
can exist without any S,G entries (allowing for all traffic to pass).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c         |  84 ++++++++++++++++++-------
 net/bridge/br_multicast_eht.c     | 100 +++++++++++++++++++++++++++++-
 net/bridge/br_private_mcast_eht.h |   7 +++
 3 files changed, 168 insertions(+), 23 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3b8c5d1d0c55..9cfc004312ab 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1841,7 +1841,8 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg, void *h_a
  *                                                       Group Timer=GMI
  */
 static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
-				 void *srcs, u32 nsrcs, size_t addr_size)
+				 void *srcs, u32 nsrcs, size_t addr_size,
+				 int grec_type)
 {
 	struct net_bridge_group_src *ent;
 	struct br_ip src_ip;
@@ -1863,6 +1864,8 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
 			br_multicast_fwd_src_handle(ent);
 	}
 
+	br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type);
+
 	__grp_src_delete_marked(pg);
 }
 
@@ -1873,7 +1876,8 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Group Timer=GMI
  */
 static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
-				 void *srcs, u32 nsrcs, size_t addr_size)
+				 void *srcs, u32 nsrcs, size_t addr_size,
+				 int grec_type)
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
@@ -1902,6 +1906,9 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	if (__grp_src_delete_marked(pg))
 		changed = true;
 
@@ -1909,19 +1916,22 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg, void *h_addr,
 }
 
 static bool br_multicast_isexc(struct net_bridge_port_group *pg, void *h_addr,
-			       void *srcs, u32 nsrcs, size_t addr_size)
+			       void *srcs, u32 nsrcs, size_t addr_size,
+			       int grec_type)
 {
 	struct net_bridge *br = pg->key.port->br;
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		__grp_src_isexc_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		__grp_src_isexc_incl(pg, h_addr, srcs, nsrcs, addr_size,
+				     grec_type);
 		br_multicast_star_g_handle_mode(pg, MCAST_EXCLUDE);
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_isexc_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_isexc_excl(pg, h_addr, srcs, nsrcs, addr_size,
+					       grec_type);
 		break;
 	}
 
@@ -1936,7 +1946,8 @@ static bool br_multicast_isexc(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Send Q(G,A-B)
  */
 static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
-				void *srcs, u32 nsrcs, size_t addr_size)
+				void *srcs, u32 nsrcs, size_t addr_size,
+				int grec_type)
 {
 	struct net_bridge *br = pg->key.port->br;
 	u32 src_idx, to_send = pg->src_ents;
@@ -1965,6 +1976,9 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
 			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
 
@@ -1977,7 +1991,8 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Send Q(G)
  */
 static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
-				void *srcs, u32 nsrcs, size_t addr_size)
+				void *srcs, u32 nsrcs, size_t addr_size,
+				int grec_type)
 {
 	struct net_bridge *br = pg->key.port->br;
 	u32 src_idx, to_send = pg->src_ents;
@@ -2009,6 +2024,9 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
 			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
 
@@ -2018,19 +2036,30 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg, void *h_addr,
 }
 
 static bool br_multicast_toin(struct net_bridge_port_group *pg, void *h_addr,
-			      void *srcs, u32 nsrcs, size_t addr_size)
+			      void *srcs, u32 nsrcs, size_t addr_size,
+			      int grec_type)
 {
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		changed = __grp_src_toin_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_toin_incl(pg, h_addr, srcs, nsrcs, addr_size,
+					      grec_type);
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_toin_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_toin_excl(pg, h_addr, srcs, nsrcs, addr_size,
+					      grec_type);
 		break;
 	}
 
+	if (br_multicast_eht_should_del_pg(pg)) {
+		br_multicast_find_del_pg(pg->key.port->br, pg);
+		/* a notification has already been sent and we shouldn't
+		 * access pg after the delete so we have to return false
+		 */
+		changed = false;
+	}
+
 	return changed;
 }
 
@@ -2041,7 +2070,8 @@ static bool br_multicast_toin(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Group Timer=GMI
  */
 static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
-				void *srcs, u32 nsrcs, size_t addr_size)
+				void *srcs, u32 nsrcs, size_t addr_size,
+				int grec_type)
 {
 	struct net_bridge_group_src *ent;
 	u32 src_idx, to_send = 0;
@@ -2066,6 +2096,8 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
 			br_multicast_fwd_src_handle(ent);
 	}
 
+	br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type);
+
 	__grp_src_delete_marked(pg);
 	if (to_send)
 		__grp_src_query_marked_and_rexmit(pg);
@@ -2079,7 +2111,8 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg, void *h_addr,
  *                                                       Group Timer=GMI
  */
 static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
-				void *srcs, u32 nsrcs, size_t addr_size)
+				void *srcs, u32 nsrcs, size_t addr_size,
+				int grec_type)
 {
 	struct net_bridge_group_src *ent;
 	u32 src_idx, to_send = 0;
@@ -2109,6 +2142,9 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
 		}
 	}
 
+	if (br_multicast_eht_handle(pg, h_addr, srcs, nsrcs, addr_size, grec_type))
+		changed = true;
+
 	if (__grp_src_delete_marked(pg))
 		changed = true;
 	if (to_send)
@@ -2118,19 +2154,22 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg, void *h_addr,
 }
 
 static bool br_multicast_toex(struct net_bridge_port_group *pg, void *h_addr,
-			      void *srcs, u32 nsrcs, size_t addr_size)
+			      void *srcs, u32 nsrcs, size_t addr_size,
+			      int grec_type)
 {
 	struct net_bridge *br = pg->key.port->br;
 	bool changed = false;
 
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
-		__grp_src_toex_incl(pg, h_addr, srcs, nsrcs, addr_size);
+		__grp_src_toex_incl(pg, h_addr, srcs, nsrcs, addr_size,
+				    grec_type);
 		br_multicast_star_g_handle_mode(pg, MCAST_EXCLUDE);
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
-		changed = __grp_src_toex_excl(pg, h_addr, srcs, nsrcs, addr_size);
+		changed = __grp_src_toex_excl(pg, h_addr, srcs, nsrcs, addr_size,
+					      grec_type);
 		break;
 	}
 
@@ -2347,15 +2386,15 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			break;
 		case IGMPV3_MODE_IS_EXCLUDE:
 			changed = br_multicast_isexc(pg, h_addr, grec->grec_src,
-						     nsrcs, sizeof(__be32));
+						     nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_CHANGE_TO_INCLUDE:
 			changed = br_multicast_toin(pg, h_addr, grec->grec_src,
-						    nsrcs, sizeof(__be32));
+						    nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_CHANGE_TO_EXCLUDE:
 			changed = br_multicast_toex(pg, h_addr, grec->grec_src,
-						    nsrcs, sizeof(__be32));
+						    nsrcs, sizeof(__be32), type);
 			break;
 		case IGMPV3_BLOCK_OLD_SOURCES:
 			changed = br_multicast_block(pg, h_addr, grec->grec_src,
@@ -2479,17 +2518,20 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		case MLD2_MODE_IS_EXCLUDE:
 			changed = br_multicast_isexc(pg, h_addr,
 						     grec->grec_src, nsrcs,
-						     sizeof(struct in6_addr));
+						     sizeof(struct in6_addr),
+						     grec->grec_type);
 			break;
 		case MLD2_CHANGE_TO_INCLUDE:
 			changed = br_multicast_toin(pg, h_addr,
 						    grec->grec_src, nsrcs,
-						    sizeof(struct in6_addr));
+						    sizeof(struct in6_addr),
+						    grec->grec_type);
 			break;
 		case MLD2_CHANGE_TO_EXCLUDE:
 			changed = br_multicast_toex(pg, h_addr,
 						    grec->grec_src, nsrcs,
-						    sizeof(struct in6_addr));
+						    sizeof(struct in6_addr),
+						    grec->grec_type);
 			break;
 		case MLD2_BLOCK_OLD_SOURCES:
 			changed = br_multicast_block(pg, h_addr,
diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index 43f60388df16..861ae63f4a1c 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -629,13 +629,79 @@ static bool br_multicast_eht_block(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* flush_entries is true when changing mode */
+static bool __eht_inc_exc(struct net_bridge_port_group *pg,
+			  union net_bridge_eht_addr *h_addr,
+			  void *srcs,
+			  u32 nsrcs,
+			  size_t addr_size,
+			  unsigned char filter_mode,
+			  bool to_report)
+{
+	bool changed = false, flush_entries = to_report;
+	union net_bridge_eht_addr eht_src_addr;
+	u32 src_idx;
+
+	if (br_multicast_eht_host_filter_mode(pg, h_addr) != filter_mode)
+		flush_entries = true;
+
+	memset(&eht_src_addr, 0, sizeof(eht_src_addr));
+	/* if we're changing mode del host and its entries */
+	if (flush_entries)
+		br_multicast_del_eht_host(pg, h_addr);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&eht_src_addr, srcs + (src_idx * addr_size), addr_size);
+		br_multicast_create_eht_set_entry(pg, &eht_src_addr, h_addr,
+						  filter_mode, false);
+	}
+	/* we can be missing sets only if we've deleted some entries */
+	if (flush_entries) {
+		struct net_bridge_group_src *src_ent;
+		struct hlist_node *tmp;
+
+		hlist_for_each_entry_safe(src_ent, tmp, &pg->src_list, node) {
+			br_multicast_ip_src_to_eht_addr(&src_ent->addr,
+							&eht_src_addr);
+			if (!br_multicast_eht_set_lookup(pg, &eht_src_addr)) {
+				br_multicast_del_group_src(src_ent);
+				changed = true;
+				continue;
+			}
+		}
+	}
+
+	return changed;
+}
+
+static bool br_multicast_eht_inc(struct net_bridge_port_group *pg,
+				 union net_bridge_eht_addr *h_addr,
+				 void *srcs,
+				 u32 nsrcs,
+				 size_t addr_size,
+				 bool to_report)
+{
+	return __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size, MCAST_INCLUDE,
+			     to_report);
+}
+
+static bool br_multicast_eht_exc(struct net_bridge_port_group *pg,
+				 union net_bridge_eht_addr *h_addr,
+				 void *srcs,
+				 u32 nsrcs,
+				 size_t addr_size,
+				 bool to_report)
+{
+	return __eht_inc_exc(pg, h_addr, srcs, nsrcs, addr_size, MCAST_EXCLUDE,
+			     to_report);
+}
+
 static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
 			     union net_bridge_eht_addr *h_addr,
 			     void *srcs,
 			     u32 nsrcs,
 			     int grec_type)
 {
-	bool changed = false;
+	bool changed = false, to_report = false;
 
 	switch (grec_type) {
 	case IGMPV3_ALLOW_NEW_SOURCES:
@@ -645,6 +711,20 @@ static bool __eht_ip4_handle(struct net_bridge_port_group *pg,
 		changed = br_multicast_eht_block(pg, h_addr, srcs, nsrcs,
 						 sizeof(__be32));
 		break;
+	case IGMPV3_CHANGE_TO_INCLUDE:
+		to_report = true;
+		fallthrough;
+	case IGMPV3_MODE_IS_INCLUDE:
+		changed = br_multicast_eht_inc(pg, h_addr, srcs, nsrcs,
+					       sizeof(__be32), to_report);
+		break;
+	case IGMPV3_CHANGE_TO_EXCLUDE:
+		to_report = true;
+		fallthrough;
+	case IGMPV3_MODE_IS_EXCLUDE:
+		changed = br_multicast_eht_exc(pg, h_addr, srcs, nsrcs,
+					       sizeof(__be32), to_report);
+		break;
 	}
 
 	return changed;
@@ -657,7 +737,7 @@ static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
 			     u32 nsrcs,
 			     int grec_type)
 {
-	bool changed = false;
+	bool changed = false, to_report = false;
 
 	switch (grec_type) {
 	case MLD2_ALLOW_NEW_SOURCES:
@@ -668,6 +748,22 @@ static bool __eht_ip6_handle(struct net_bridge_port_group *pg,
 		changed = br_multicast_eht_block(pg, h_addr, srcs, nsrcs,
 						 sizeof(struct in6_addr));
 		break;
+	case MLD2_CHANGE_TO_INCLUDE:
+		to_report = true;
+		fallthrough;
+	case MLD2_MODE_IS_INCLUDE:
+		changed = br_multicast_eht_inc(pg, h_addr, srcs, nsrcs,
+					       sizeof(struct in6_addr),
+					       to_report);
+		break;
+	case MLD2_CHANGE_TO_EXCLUDE:
+		to_report = true;
+		fallthrough;
+	case MLD2_MODE_IS_EXCLUDE:
+		changed = br_multicast_eht_exc(pg, h_addr, srcs, nsrcs,
+					       sizeof(struct in6_addr),
+					       to_report);
+		break;
 	}
 
 	return changed;
diff --git a/net/bridge/br_private_mcast_eht.h b/net/bridge/br_private_mcast_eht.h
index 92933822301d..9daffa3ad8d5 100644
--- a/net/bridge/br_private_mcast_eht.h
+++ b/net/bridge/br_private_mcast_eht.h
@@ -55,4 +55,11 @@ bool br_multicast_eht_handle(struct net_bridge_port_group *pg,
 			     size_t addr_size,
 			     int grec_type);
 
+static inline bool
+br_multicast_eht_should_del_pg(const struct net_bridge_port_group *pg)
+{
+	return !!((pg->key.port->flags & BR_MULTICAST_FAST_LEAVE) &&
+		  RB_EMPTY_ROOT(&pg->eht_host_tree));
+}
+
 #endif /* _BR_PRIVATE_MCAST_EHT_H_ */
-- 
2.29.2

