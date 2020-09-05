Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2392625E679
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgIEIZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgIEIZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:25:02 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17216C061246
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:25:01 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a65so8811486wme.5
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WPQNMwh2W5eVH73Ir8mwQYbTwyqwgJ/5fOXRh6hHwkI=;
        b=SXYZu7osyCHFUPG+HZoOB5lvbUztgqE1D9adsXGU9TeOqZeFZwoBJTAzBDoEdM2913
         5Ye4+OF8SR/WP2wQmP5/AetxjQrSA8cHwWkQy1mitjI+F8I5dBOO7i17jlkcyDl96Nbl
         6KfEs7oDwb4W4JB43ysgrkyaJsnyM1MfFTtIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WPQNMwh2W5eVH73Ir8mwQYbTwyqwgJ/5fOXRh6hHwkI=;
        b=KTvgYac7HSIs9sf4nNVPYAyTE/fFxnB+eDt78TYvMDo8BUGPRJUzdiKbwoevbUgMY6
         BWqd7Qkx2/RTpVxloCGoXQh9Co5zDhuWIZEt//xWmrJXuCAEJyJta5J/UOhEyQP63U/a
         u6XmKq1hxsffjQ4KrU1mIVCNztOuMqcHAiFCaAa24Vy2DfwWjPOydToKJ0TVYip3eGbM
         ewi7Gcdw94EYw5Dt5ZEhXER4shZxjeFnKsXsiR+d/SzjJ3PhKANdWLYl0806TAIArYaB
         EfB/8siu2iswQ1200PhcDQTNXXJt4biJmvvnFKc0TZ7Ylvc2MGSzISAyfQuIXtXkkHe8
         DS+A==
X-Gm-Message-State: AOAM530c8xPC9NFE/fxhjeHldE2Ewis/iSZ6wOO2/m5iWhYBhkPPLOV/
        pMVypUvxKWd3zpFOnXp9nH5tjXYQZDpCxf3c
X-Google-Smtp-Source: ABdhPJz+W0L0CS+2VK7D5eQoAaL/djg7p1ayfLiYiEeYY4kyfWHeSyc18J/TWQfejaL/FBacyNEXbQ==
X-Received: by 2002:a1c:9697:: with SMTP id y145mr6612259wmd.174.1599294298537;
        Sat, 05 Sep 2020 01:24:58 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:57 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 12/15] net: bridge: mcast: support for IGMPV3/MLDv2 CHANGE_TO_INCLUDE/EXCLUDE report
Date:   Sat,  5 Sep 2020 11:24:07 +0300
Message-Id: <20200905082410.2230253-13-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to process IGMPV3/MLDv2 CHANGE_TO_INCLUDE/EXCLUDE report types we
need new helpers which allow us to mark entries based on their timer
state and to query only marked entries.

v3: add IPv6/MLDv2 support, fix other_query checks
v2: directly do flag bit operations

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 306 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 306 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index a9f6abf5e680..b6c278dbfe32 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1246,6 +1246,86 @@ static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
 	return deleted;
 }
 
+static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
+{
+	struct bridge_mcast_other_query *other_query = NULL;
+	struct net_bridge *br = pg->port->br;
+	u32 lmqc = br->multicast_last_member_count;
+	unsigned long lmqt, lmi, now = jiffies;
+	struct net_bridge_group_src *ent;
+
+	if (!netif_running(br->dev) ||
+	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return;
+
+	if (pg->addr.proto == htons(ETH_P_IP))
+		other_query = &br->ip4_other_query;
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		other_query = &br->ip6_other_query;
+#endif
+
+	lmqt = now + br_multicast_lmqt(br);
+	hlist_for_each_entry(ent, &pg->src_list, node) {
+		if (ent->flags & BR_SGRP_F_SEND) {
+			ent->flags &= ~BR_SGRP_F_SEND;
+			if (ent->timer.expires > lmqt) {
+				if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+				    other_query &&
+				    !timer_pending(&other_query->timer))
+					ent->src_query_rexmit_cnt = lmqc;
+				mod_timer(&ent->timer, lmqt);
+			}
+		}
+	}
+
+	if (!br_opt_get(br, BROPT_MULTICAST_QUERIER) ||
+	    !other_query || timer_pending(&other_query->timer))
+		return;
+
+	__br_multicast_send_query(br, pg->port, pg, &pg->addr,
+				  &pg->addr, true, 1, NULL);
+
+	lmi = now + br->multicast_last_member_interval;
+	if (!timer_pending(&pg->rexmit_timer) ||
+	    time_after(pg->rexmit_timer.expires, lmi))
+		mod_timer(&pg->rexmit_timer, lmi);
+}
+
+static void __grp_send_query_and_rexmit(struct net_bridge_port_group *pg)
+{
+	struct bridge_mcast_other_query *other_query = NULL;
+	struct net_bridge *br = pg->port->br;
+	unsigned long now = jiffies, lmi;
+
+	if (!netif_running(br->dev) ||
+	    !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return;
+
+	if (pg->addr.proto == htons(ETH_P_IP))
+		other_query = &br->ip4_other_query;
+#if IS_ENABLED(CONFIG_IPV6)
+	else
+		other_query = &br->ip6_other_query;
+#endif
+
+	if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+	    other_query && !timer_pending(&other_query->timer)) {
+		lmi = now + br->multicast_last_member_interval;
+		pg->grp_query_rexmit_cnt = br->multicast_last_member_count - 1;
+		__br_multicast_send_query(br, pg->port, pg, &pg->addr,
+					  &pg->addr, false, 0, NULL);
+		if (!timer_pending(&pg->rexmit_timer) ||
+		    time_after(pg->rexmit_timer.expires, lmi))
+			mod_timer(&pg->rexmit_timer, lmi);
+	}
+
+	if (pg->filter_mode == MCAST_EXCLUDE &&
+	    (!timer_pending(&pg->timer) ||
+	     time_after(pg->timer.expires, now + br_multicast_lmqt(br))))
+		mod_timer(&pg->timer, now + br_multicast_lmqt(br));
+}
+
 /* State          Msg type      New state                Actions
  * INCLUDE (A)    IS_IN (B)     INCLUDE (A+B)            (B)=GMI
  * INCLUDE (A)    ALLOW (B)     INCLUDE (A+B)            (B)=GMI
@@ -1375,6 +1455,216 @@ static bool br_multicast_isexc(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    TO_IN (B)     INCLUDE (A+B)            (B)=GMI
+ *                                                       Send Q(G,A-B)
+ */
+static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
+				void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge *br = pg->port->br;
+	u32 src_idx, to_send = pg->src_ents;
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	bool changed = false;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags |= BR_SGRP_F_SEND;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			ent->flags &= ~BR_SGRP_F_SEND;
+			to_send--;
+		} else {
+			ent = br_multicast_new_group_src(pg, &src_ip);
+			if (ent)
+				changed = true;
+		}
+		if (ent)
+			mod_timer(&ent->timer, now + br_multicast_gmi(br));
+		srcs += src_size;
+	}
+
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+
+	return changed;
+}
+
+/* State          Msg type      New state                Actions
+ * EXCLUDE (X,Y)  TO_IN (A)     EXCLUDE (X+A,Y-A)        (A)=GMI
+ *                                                       Send Q(G,X-A)
+ *                                                       Send Q(G)
+ */
+static bool __grp_src_toin_excl(struct net_bridge_port_group *pg,
+				void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge *br = pg->port->br;
+	u32 src_idx, to_send = pg->src_ents;
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	bool changed = false;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		if (timer_pending(&ent->timer))
+			ent->flags |= BR_SGRP_F_SEND;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			if (timer_pending(&ent->timer)) {
+				ent->flags &= ~BR_SGRP_F_SEND;
+				to_send--;
+			}
+		} else {
+			ent = br_multicast_new_group_src(pg, &src_ip);
+			if (ent)
+				changed = true;
+		}
+		if (ent)
+			mod_timer(&ent->timer, now + br_multicast_gmi(br));
+		srcs += src_size;
+	}
+
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+
+	__grp_send_query_and_rexmit(pg);
+
+	return changed;
+}
+
+static bool br_multicast_toin(struct net_bridge_port_group *pg,
+			      void *srcs, u32 nsrcs, size_t src_size)
+{
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		changed = __grp_src_toin_incl(pg, srcs, nsrcs, src_size);
+		break;
+	case MCAST_EXCLUDE:
+		changed = __grp_src_toin_excl(pg, srcs, nsrcs, src_size);
+		break;
+	}
+
+	return changed;
+}
+
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    TO_EX (B)     EXCLUDE (A*B,B-A)        (B-A)=0
+ *                                                       Delete (A-B)
+ *                                                       Send Q(G,A*B)
+ *                                                       Group Timer=GMI
+ */
+static void __grp_src_toex_incl(struct net_bridge_port_group *pg,
+				void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge_group_src *ent;
+	u32 src_idx, to_send = 0;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags = (ent->flags & ~BR_SGRP_F_SEND) | BR_SGRP_F_DELETE;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			ent->flags = (ent->flags & ~BR_SGRP_F_DELETE) |
+				     BR_SGRP_F_SEND;
+			to_send++;
+		} else {
+			br_multicast_new_group_src(pg, &src_ip);
+		}
+		srcs += src_size;
+	}
+
+	__grp_src_delete_marked(pg);
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+}
+
+/* State          Msg type      New state                Actions
+ * EXCLUDE (X,Y)  TO_EX (A)     EXCLUDE (A-Y,Y*A)        (A-X-Y)=Group Timer
+ *                                                       Delete (X-A)
+ *                                                       Delete (Y-A)
+ *                                                       Send Q(G,A-Y)
+ *                                                       Group Timer=GMI
+ */
+static bool __grp_src_toex_excl(struct net_bridge_port_group *pg,
+				void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge_group_src *ent;
+	u32 src_idx, to_send = 0;
+	bool changed = false;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags = (ent->flags & ~BR_SGRP_F_SEND) | BR_SGRP_F_DELETE;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			ent->flags &= ~BR_SGRP_F_DELETE;
+		} else {
+			ent = br_multicast_new_group_src(pg, &src_ip);
+			if (ent) {
+				mod_timer(&ent->timer, pg->timer.expires);
+				changed = true;
+			}
+		}
+		if (ent && timer_pending(&ent->timer)) {
+			ent->flags |= BR_SGRP_F_SEND;
+			to_send++;
+		}
+		srcs += src_size;
+	}
+
+	if (__grp_src_delete_marked(pg))
+		changed = true;
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+
+	return changed;
+}
+
+static bool br_multicast_toex(struct net_bridge_port_group *pg,
+			      void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge *br = pg->port->br;
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		__grp_src_toex_incl(pg, srcs, nsrcs, src_size);
+		changed = true;
+		break;
+	case MCAST_EXCLUDE:
+		__grp_src_toex_excl(pg, srcs, nsrcs, src_size);
+		break;
+	}
+
+	pg->filter_mode = MCAST_EXCLUDE;
+	mod_timer(&pg->timer, jiffies + br_multicast_gmi(br));
+
+	return changed;
+}
+
 static struct net_bridge_port_group *
 br_multicast_find_port(struct net_bridge_mdb_entry *mp,
 		       struct net_bridge_port *p,
@@ -1480,6 +1770,14 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			changed = br_multicast_isexc(pg, grec->grec_src, nsrcs,
 						     sizeof(__be32));
 			break;
+		case IGMPV3_CHANGE_TO_INCLUDE:
+			changed = br_multicast_toin(pg, grec->grec_src, nsrcs,
+						    sizeof(__be32));
+			break;
+		case IGMPV3_CHANGE_TO_EXCLUDE:
+			changed = br_multicast_toex(pg, grec->grec_src, nsrcs,
+						    sizeof(__be32));
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
@@ -1594,6 +1892,14 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 			changed = br_multicast_isexc(pg, grec->grec_src, nsrcs,
 						     sizeof(struct in6_addr));
 			break;
+		case MLD2_CHANGE_TO_INCLUDE:
+			changed = br_multicast_toin(pg, grec->grec_src, nsrcs,
+						    sizeof(struct in6_addr));
+			break;
+		case MLD2_CHANGE_TO_EXCLUDE:
+			changed = br_multicast_toex(pg, grec->grec_src, nsrcs,
+						    sizeof(struct in6_addr));
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
-- 
2.25.4

