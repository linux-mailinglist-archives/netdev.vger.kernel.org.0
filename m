Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D782FD462
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390919AbhATPmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389974AbhATOzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:55:25 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC1BC0617A4
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:21 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s11so18790974edd.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YT+SYFiw1dH0jJDDS//jhORRXswYAr3VsLQ6058Ln4M=;
        b=XTkqPPTp+PixnWplr7ie8/nV6iLYqPMstodVv4rNcV2HNQ2QCVA+IAoVenNeM7ZD83
         zXlvfsU5ijEPeIhs8zH4OJ3Mgb/HrzfXNCmWpQeRtDh9V45tkO3zfkcGz2cPlUAIKoxf
         gHU6zlyd/dZbQgWTQ0Q3lJSq/69YBpcllywqLELJp09O62SwbT6PUeMOhVjPFC+rEPWS
         gvqpI4OWp9pH+G5P125dqzK0LqXm67ILszXfmu939rXSVm55oWZ4ytGJ+RdcWGYHwdF+
         bmASzAtDnEQJfy20PjENjlV/E6Sa4EwqkMDOWVNZPMDQy9/6IyvaXzTQaPui1gwxrEYO
         B/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YT+SYFiw1dH0jJDDS//jhORRXswYAr3VsLQ6058Ln4M=;
        b=oRhy9OWa9BaqtFtITm4b/PRhz3UrQQYaMgjcWUzKlnbtuZ5qOmoTToz3dcH7YgL7gq
         6I6higLIoTTsigXagcjujTZSPXCsPr4yTcciHydCC70BLUHWSBFCDc+7sDzoFEdk8Jsh
         PRJf6gTX/KUgo5woRAkPzYuG4V71I3NTkL03EZjwCpvQezn6FXRvxq2JZ98yHrmpBa1e
         0A7rguDfwtHxbCqzuhLcssa+QRD/qDie1ksAx9CS9opf1IW5QGBqOlBB+h3r5/EaAufs
         YcBsZkPW+Ti/89KC+BJI3iRIPR3N8AehabRYeGHRDIcbyC3I6fDkDuAwflFqy4wQ7Rnf
         qedQ==
X-Gm-Message-State: AOAM533pBEtzcMO122/P/slwvG14G+uFtnqFM/3RWgsd7ahsEXGhaVFb
        QUv+877kG73Y6HEd1dnuf0bzqBXbXC/Dj1fnOY4=
X-Google-Smtp-Source: ABdhPJwom8mpybS8iOwn4uZe6k9ha+xYzX5RAledJa4fTae60pvUFCJW1jESfvgx0hT07z4mk+6eZg==
X-Received: by 2002:a50:e008:: with SMTP id e8mr7435458edl.339.1611154399994;
        Wed, 20 Jan 2021 06:53:19 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:19 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 14/14] net: bridge: multicast: mark IGMPv3/MLDv2 fast-leave deletes
Date:   Wed, 20 Jan 2021 16:52:03 +0200
Message-Id: <20210120145203.1109140-15-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120145203.1109140-1-razor@blackwall.org>
References: <20210120145203.1109140-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Mark groups which were deleted due to fast leave/EHT.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c     | 21 ++++++++++++++-------
 net/bridge/br_multicast_eht.c |  8 ++++----
 net/bridge/br_private.h       |  3 ++-
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 47afb1e11daf..df5db6a58e95 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -442,7 +442,8 @@ static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 	br_multicast_sg_add_exclude_ports(star_mp, sg);
 }
 
-static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src)
+static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src,
+					bool fastleave)
 {
 	struct net_bridge_port_group *p, *pg = src->pg;
 	struct net_bridge_port_group __rcu **pp;
@@ -467,6 +468,8 @@ static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src)
 		    (p->flags & MDB_PG_FLAGS_PERMANENT))
 			break;
 
+		if (fastleave)
+			p->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 		br_multicast_del_pg(mp, p, pp);
 		break;
 	}
@@ -560,11 +563,12 @@ static void br_multicast_destroy_group_src(struct net_bridge_mcast_gc *gc)
 	kfree_rcu(src, rcu);
 }
 
-void br_multicast_del_group_src(struct net_bridge_group_src *src)
+void br_multicast_del_group_src(struct net_bridge_group_src *src,
+				bool fastleave)
 {
 	struct net_bridge *br = src->pg->key.port->br;
 
-	br_multicast_fwd_src_remove(src);
+	br_multicast_fwd_src_remove(src, fastleave);
 	hlist_del_init_rcu(&src->node);
 	src->pg->src_ents--;
 	hlist_add_head(&src->mcast_gc.gc_node, &br->mcast_gc_list);
@@ -596,7 +600,7 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	hlist_del_init(&pg->mglist);
 	br_multicast_eht_clean_sets(pg);
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
-		br_multicast_del_group_src(ent);
+		br_multicast_del_group_src(ent, false);
 	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
 	if (!br_multicast_is_star_g(&mp->addr)) {
 		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
@@ -653,7 +657,7 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 	pg->filter_mode = MCAST_INCLUDE;
 	hlist_for_each_entry_safe(src_ent, tmp, &pg->src_list, node) {
 		if (!timer_pending(&src_ent->timer)) {
-			br_multicast_del_group_src(src_ent);
+			br_multicast_del_group_src(src_ent, false);
 			changed = true;
 		}
 	}
@@ -1080,7 +1084,7 @@ static void br_multicast_group_src_expired(struct timer_list *t)
 
 	pg = src->pg;
 	if (pg->filter_mode == MCAST_INCLUDE) {
-		br_multicast_del_group_src(src);
+		br_multicast_del_group_src(src, false);
 		if (!hlist_empty(&pg->src_list))
 			goto out;
 		br_multicast_find_del_pg(br, pg);
@@ -1704,7 +1708,7 @@ static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
 
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		if (ent->flags & BR_SGRP_F_DELETE) {
-			br_multicast_del_group_src(ent);
+			br_multicast_del_group_src(ent, false);
 			deleted++;
 		}
 
@@ -2053,6 +2057,7 @@ static bool br_multicast_toin(struct net_bridge_port_group *pg, void *h_addr,
 	}
 
 	if (br_multicast_eht_should_del_pg(pg)) {
+		pg->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 		br_multicast_find_del_pg(pg->key.port->br, pg);
 		/* a notification has already been sent and we shouldn't
 		 * access pg after the delete so we have to return false
@@ -2273,6 +2278,8 @@ static bool br_multicast_block(struct net_bridge_port_group *pg, void *h_addr,
 
 	if ((pg->filter_mode == MCAST_INCLUDE && hlist_empty(&pg->src_list)) ||
 	    br_multicast_eht_should_del_pg(pg)) {
+		if (br_multicast_eht_should_del_pg(pg))
+			pg->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 		br_multicast_find_del_pg(pg->key.port->br, pg);
 		/* a notification has already been sent and we shouldn't
 		 * access pg after the delete so we have to return false
diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index 64ccbd4ae9d9..a4fa1760bc8a 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -537,7 +537,7 @@ static bool __eht_allow_excl(struct net_bridge_port_group *pg,
 			src_ent = br_multicast_find_group_src(pg, &src_ip);
 			if (!src_ent)
 				continue;
-			br_multicast_del_group_src(src_ent);
+			br_multicast_del_group_src(src_ent, true);
 			changed = true;
 		}
 	}
@@ -588,7 +588,7 @@ static bool __eht_block_incl(struct net_bridge_port_group *pg,
 		src_ent = br_multicast_find_group_src(pg, &src_ip);
 		if (!src_ent)
 			continue;
-		br_multicast_del_group_src(src_ent);
+		br_multicast_del_group_src(src_ent, true);
 		changed = true;
 	}
 
@@ -625,7 +625,7 @@ static bool __eht_block_excl(struct net_bridge_port_group *pg,
 			src_ent = br_multicast_find_group_src(pg, &src_ip);
 			if (!src_ent)
 				continue;
-			br_multicast_del_group_src(src_ent);
+			br_multicast_del_group_src(src_ent, true);
 			changed = true;
 		}
 	}
@@ -689,7 +689,7 @@ static bool __eht_inc_exc(struct net_bridge_port_group *pg,
 			br_multicast_ip_src_to_eht_addr(&src_ent->addr,
 							&eht_src_addr);
 			if (!br_multicast_eht_set_lookup(pg, &eht_src_addr)) {
-				br_multicast_del_group_src(src_ent);
+				br_multicast_del_group_src(src_ent, true);
 				changed = true;
 				continue;
 			}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cad967690e9f..0e26ba623006 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -850,7 +850,8 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 				       struct net_bridge_port_group *sg);
 struct net_bridge_group_src *
 br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
-void br_multicast_del_group_src(struct net_bridge_group_src *src);
+void br_multicast_del_group_src(struct net_bridge_group_src *src,
+				bool fastleave);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
-- 
2.29.2

