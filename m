Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2BD25E67E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgIEIZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbgIEIZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:25:02 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4233C061247
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:25:01 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c19so8923928wmd.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VurM3Q0P8DN+diibsl0fS50YUtMJAXq0EjcyobLlCCk=;
        b=AKlayoWkC0i+PhCBBy7XTZ3Egr9n8jEEJBk9AjXU2Oej3dhnTiqmkw/WvM0iFdoiuk
         EPZcvkNSQbOqg3VCgZnJCPj/ThG+F2rpwVFBAsEaT5UIKT4nB1cXNdZ/N5Ic1fBFsu6x
         IcIGXOvctWwyOENcIuhMBJ4PIJh28AOCCVJQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VurM3Q0P8DN+diibsl0fS50YUtMJAXq0EjcyobLlCCk=;
        b=sB6CnoOBFl/aBwzraRzDc4wyeb3+sLVr6Jv2vGJ5eMdW4H5SkyQVY7MOdlgt/hciVK
         Fb38rtwVUCHnKMTgNAM+yCHrziERAPfiSY5FzgJSkS3MJwS/+u7+8AaBBdsnR255pP4h
         cucdXjv1FMwH+2Q/43oGXPZ8vdUTGIzTsP2SjBVitx/XcQTieQQ6iEHg+fSijEugePQH
         ftbyBbDqbobUtT+vPvIdfYv6A8OwXg1Q0xqY2e1o3b5P+I5FuSrQzGWqcr7XolSuXoD+
         gkGnkcSLHehMV/XdhaNbOGhKwivCmpE2a75X4A2M3imZKk9A++b97t6nuLT8qqKfbzPr
         ZMhQ==
X-Gm-Message-State: AOAM530Z/4XMpzhULcHY1z9LohZqqkFxPsqV4vo9y2z+d6PTaqkvSMOd
        b8SX585DkdiTVCQ2o1/IADes+AhRQYdwiJTS
X-Google-Smtp-Source: ABdhPJzv24Mf/Aqap6cwxvDgnXSotaTF4TxVftufT670baKrpP41yD4/yy8pe55aQAtDxtWsfeu2vA==
X-Received: by 2002:a1c:9a8d:: with SMTP id c135mr11491332wme.58.1599294300072;
        Sat, 05 Sep 2020 01:25:00 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:59 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 13/15] net: bridge: mcast: support for IGMPV3/MLDv2 BLOCK_OLD_SOURCES report
Date:   Sat,  5 Sep 2020 11:24:08 +0300
Message-Id: <20200905082410.2230253-14-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already have all necessary helpers, so process IGMPV3/MLDv2
BLOCK_OLD_SOURCES as per the RFCs.

v3: add IPv6/MLDv2 support
v2: directly do flag bit operations

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 97 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b6c278dbfe32..2ded3f3c51c0 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1665,6 +1665,95 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    BLOCK (B)     INCLUDE (A)              Send Q(G,A*B)
+ */
+static void __grp_src_block_incl(struct net_bridge_port_group *pg,
+				 void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge_group_src *ent;
+	u32 src_idx, to_send = 0;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags &= ~BR_SGRP_F_SEND;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			ent->flags |= BR_SGRP_F_SEND;
+			to_send++;
+		}
+		srcs += src_size;
+	}
+
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+
+	if (pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list))
+		br_multicast_find_del_pg(pg->port->br, pg);
+}
+
+/* State          Msg type      New state                Actions
+ * EXCLUDE (X,Y)  BLOCK (A)     EXCLUDE (X+(A-Y),Y)      (A-X-Y)=Group Timer
+ *                                                       Send Q(G,A-Y)
+ */
+static bool __grp_src_block_excl(struct net_bridge_port_group *pg,
+				 void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge_group_src *ent;
+	u32 src_idx, to_send = 0;
+	bool changed = false;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags &= ~BR_SGRP_F_SEND;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (!ent) {
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
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+
+	return changed;
+}
+
+static bool br_multicast_block(struct net_bridge_port_group *pg,
+			       void *srcs, u32 nsrcs, size_t src_size)
+{
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		__grp_src_block_incl(pg, srcs, nsrcs, src_size);
+		break;
+	case MCAST_EXCLUDE:
+		changed = __grp_src_block_excl(pg, srcs, nsrcs, src_size);
+		break;
+	}
+
+	return changed;
+}
+
 static struct net_bridge_port_group *
 br_multicast_find_port(struct net_bridge_mdb_entry *mp,
 		       struct net_bridge_port *p,
@@ -1778,6 +1867,10 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			changed = br_multicast_toex(pg, grec->grec_src, nsrcs,
 						    sizeof(__be32));
 			break;
+		case IGMPV3_BLOCK_OLD_SOURCES:
+			changed = br_multicast_block(pg, grec->grec_src, nsrcs,
+						     sizeof(__be32));
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
@@ -1900,6 +1993,10 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 			changed = br_multicast_toex(pg, grec->grec_src, nsrcs,
 						    sizeof(struct in6_addr));
 			break;
+		case MLD2_BLOCK_OLD_SOURCES:
+			changed = br_multicast_block(pg, grec->grec_src, nsrcs,
+						     sizeof(struct in6_addr));
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
-- 
2.25.4

