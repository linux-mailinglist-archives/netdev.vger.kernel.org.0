Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E675125AA54
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgIBLbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgIBL32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4DCC06125C
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:27 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x14so4829647wrl.12
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=olba7YZuiOdWVUbjISlgCiVJSPh8C9vBzXfaBWot4Mc=;
        b=hRSJ6L0t+RNja36ZrAPNOblNCrdrS9id03SD2bRb2wJpdAldPj2wvLyPv7Ozd+zvvh
         JReShKgAE0xEprpBqnm7bcb67ZLW3FWCC1gLh3X3WgC+LyNbK8t64t3mP/+7MIhN0oMb
         ibScBC1cAlNC1S55teclgRBd7Xm7M0oSx73Qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=olba7YZuiOdWVUbjISlgCiVJSPh8C9vBzXfaBWot4Mc=;
        b=qGdGjeXCuLQzz7wZ2uG75mkoacD5EtqwC6J4/zcVJZ+qx44Qd3ful/RwSbv/ylXH90
         vXaflVFIzB0kzvTbfY3IDDSOKg5FggO7RI43e5nhegqsFa5rj9CPjz8KaOmL1o7svQv7
         HSmmsU2vbaX76lkeX9cQ3yCBn4cp0W2eW42WCpF3yfeTXqEhrtLR3KxWl1/KeVZcOAMV
         5IUhGKIMLrk+gZvhreYp80Rs+SSG1dTX9xsxB1YRGsMA7U5HDQ4FMtLZd8zw2IrzB6hR
         lpVZixt8DfdQD8aq4WBoNRh68lmOhrMKohWh7q4wemzFaoIGcFYiVzpYALnUXaFWNq8F
         M8hw==
X-Gm-Message-State: AOAM5331ycY3rOanZGpneXu1JKwf95PGZFYUwsScyRZqiTlvU164Nj7U
        q31fZBGIbi8ibTQKE6uO3ntw5PnRTn55diW6
X-Google-Smtp-Source: ABdhPJzXkB8FbknQNEC5zLAeOgTeng6UPpBsB1rTt7FgWt8hEby7T+JsUeMgVUl9zda2cTedZja5Gg==
X-Received: by 2002:adf:fed1:: with SMTP id q17mr6432862wrs.85.1599046165394;
        Wed, 02 Sep 2020 04:29:25 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:24 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 12/15] net: bridge: mcast: support for IGMPV3_CHANGE_TO_INCLUDE/EXCLUDE report
Date:   Wed,  2 Sep 2020 14:25:26 +0300
Message-Id: <20200902112529.1570040-13-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to process IGMPV3_CHANGE_TO_INCLUDE/EXCLUDE report types we
need new helpers which allow us to mark entries based on their timer
state and to query only marked entries.

v2: directly do flag bit operations

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 267 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 267 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9e0c8a462343..0dffd5a26110 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1171,6 +1171,61 @@ static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
 	return deleted;
 }
 
+static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
+{
+	struct net_bridge *br = pg->port->br;
+	u32 lmqc = br->multicast_last_member_count;
+	unsigned long lmqt, lmi, now = jiffies;
+	struct net_bridge_group_src *ent;
+
+	lmqt = now + br_multicast_lmqt(br);
+	hlist_for_each_entry(ent, &pg->src_list, node) {
+		if (ent->flags & BR_SGRP_F_SEND) {
+			ent->flags &= ~BR_SGRP_F_SEND;
+			if (ent->timer.expires > lmqt) {
+				if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+				    !timer_pending(&br->ip4_other_query.timer))
+					ent->src_query_rexmit_cnt = lmqc;
+				mod_timer(&ent->timer, lmqt);
+			}
+		}
+	}
+
+	if (!br_opt_get(br, BROPT_MULTICAST_QUERIER) ||
+	    timer_pending(&br->ip4_other_query.timer))
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
+	struct net_bridge *br = pg->port->br;
+	unsigned long now = jiffies, lmi;
+
+	if (br_opt_get(br, BROPT_MULTICAST_QUERIER) &&
+	    timer_pending(&br->ip4_other_query.timer)) {
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
@@ -1297,6 +1352,212 @@ static bool br_multicast_isexc(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    TO_IN (B)     INCLUDE (A+B)            (B)=GMI
+ *                                                       Send Q(G,A-B)
+ */
+static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
+				__be32 *srcs, u32 nsrcs)
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
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
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
+				__be32 *srcs, u32 nsrcs)
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
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
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
+			      __be32 *srcs, u32 nsrcs)
+{
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		changed = __grp_src_toin_incl(pg, srcs, nsrcs);
+		break;
+	case MCAST_EXCLUDE:
+		changed = __grp_src_toin_excl(pg, srcs, nsrcs);
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
+				__be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge_group_src *ent;
+	u32 src_idx, to_send = 0;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags = (ent->flags & ~BR_SGRP_F_SEND) | BR_SGRP_F_DELETE;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			ent->flags = (ent->flags & ~BR_SGRP_F_DELETE) |
+				     BR_SGRP_F_SEND;
+			to_send++;
+		} else {
+			br_multicast_new_group_src(pg, &src_ip);
+		}
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
+				__be32 *srcs, u32 nsrcs)
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
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
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
+			      __be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge *br = pg->port->br;
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		__grp_src_toex_incl(pg, srcs, nsrcs);
+		changed = true;
+		break;
+	case MCAST_EXCLUDE:
+		__grp_src_toex_excl(pg, srcs, nsrcs);
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
@@ -1399,6 +1660,12 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		case IGMPV3_MODE_IS_EXCLUDE:
 			changed = br_multicast_isexc(pg, grec->grec_src, nsrcs);
 			break;
+		case IGMPV3_CHANGE_TO_INCLUDE:
+			changed = br_multicast_toin(pg, grec->grec_src, nsrcs);
+			break;
+		case IGMPV3_CHANGE_TO_EXCLUDE:
+			changed = br_multicast_toex(pg, grec->grec_src, nsrcs);
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
-- 
2.25.4

