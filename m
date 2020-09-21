Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8394F27219D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIUK45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgIUK4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1E8C0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g4so12229652wrs.5
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hfC5WQrBRXxEfIWBiW8wBg3L00Pa4/ZeG4/AgXLO3Fc=;
        b=actfVbm5xLJkWfI1oa0xj66oHl2GWt1LBWFS8gj5ShRW3uLhvbIpf4sSToIU22cAt+
         SK8xEst2iDFB1ZquTzPW/NEJjgCaY+1Xp0pti8L/K58u99K5WfW2TZFoc7MLIR1ubuP1
         dPNUeF7SX0XFvppkg0eexf/401xGtrFZGGCHT0VOtCaBM/5yuIGh+goKtWFG/ZeZpVOo
         vrlBYp4OgqXM0I77P9PpFBDd+uPRZWDLlxR+QfEqrNVg7/hGjtYeNSB/R1j/GNkVj6Sw
         u9dYHoYZXG99ll66zPB+JmCSNhGBIJ3oIibbUt6YW7vWAtp3I9AhpGo02SdEo7/Jb1u8
         j3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfC5WQrBRXxEfIWBiW8wBg3L00Pa4/ZeG4/AgXLO3Fc=;
        b=SOF2MZoHwGiYBLWwG2J9zREeuMQ+b/kfX2dnmzHDbOIpjx+vdOI+N1aE21XxtVEURX
         9lU6HYuYvQ8Sj4WNTtrBH+cu2LmZplbE4eWNd+rZD9p0Rs6eTtgYCWH1sxl1grQ0jtJy
         1i5Cm2NKt34DXjChXjwXdTYB93As5VmbDOzjX0RqRXIKNDPj6rjfDhUGjHNzFDFOa/n5
         6+vRxKR9IsLqIC0lAM8te4tmy2U+uYaQGXwtunYGBABdxvSgeq0xhpLqcJRbS6PM5FoG
         AqBO2ekhtLdfZW9+dq8wH70p41BSiRX/yT+200fpMBLA9elMor47ZeekFsGlvZNXAmcR
         hUHA==
X-Gm-Message-State: AOAM533tWJqREMynet9D1O/Xm0sb2RDgi7OhNcbLxt2BABed0g6g+8TT
        498CYpDPwxZGj5Smled2WKpJJF5shSmKrmGvdnLpqQ==
X-Google-Smtp-Source: ABdhPJwIe0eB0R5Ra3kUfaIo4XJovJ6ZkkAvodtq0kNes3UPjaHol1to68ET+Bx00aVK1vG6Xov6uA==
X-Received: by 2002:adf:9e06:: with SMTP id u6mr52564792wre.208.1600685782530;
        Mon, 21 Sep 2020 03:56:22 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:22 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 12/16] net: bridge: mcast: install S,G entries automatically based on reports
Date:   Mon, 21 Sep 2020 13:55:22 +0300
Message-Id: <20200921105526.1056983-13-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

This patch adds support for automatic install of S,G mdb entries based
on the port group's source list and the source entry's timer.
Once installed the S,G will be used when forwarding packets if the
approprate multicast/mld versions are set. A new source flag called
BR_SGRP_F_INSTALLED denotes if the source has a forwarding mdb entry
installed.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 176 +++++++++++++++++++++++++++++---------
 net/bridge/br_private.h   |   1 +
 2 files changed, 138 insertions(+), 39 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 0fec9f38787c..ece8ac805e98 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -66,6 +66,13 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 const struct in6_addr *group,
 					 __u16 vid, const unsigned char *src);
 #endif
+static struct net_bridge_port_group *
+__br_multicast_add_group(struct net_bridge *br,
+			 struct net_bridge_port *port,
+			 struct br_ip *group,
+			 const unsigned char *src,
+			 u8 filter_mode,
+			 bool igmpv2_mldv1);
 
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
@@ -175,6 +182,81 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 	return br_mdb_ip_get_rcu(br, &ip);
 }
 
+static bool br_port_group_equal(struct net_bridge_port_group *p,
+				struct net_bridge_port *port,
+				const unsigned char *src)
+{
+	if (p->key.port != port)
+		return false;
+
+	if (!(port->flags & BR_MULTICAST_TO_UNICAST))
+		return true;
+
+	return ether_addr_equal(src, p->eth_addr);
+}
+
+static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
+{
+	struct net_bridge_port_group *sg;
+	struct br_ip sg_ip;
+
+	if (src->flags & BR_SGRP_F_INSTALLED)
+		return;
+
+	memset(&sg_ip, 0, sizeof(sg_ip));
+	sg_ip = src->pg->key.addr;
+	sg_ip.src = src->addr.src;
+	sg = __br_multicast_add_group(src->br, src->pg->key.port, &sg_ip,
+				      src->pg->eth_addr, MCAST_INCLUDE, false);
+	if (IS_ERR_OR_NULL(sg))
+		return;
+	src->flags |= BR_SGRP_F_INSTALLED;
+
+	/* if it was added by user-space as perm we can skip next steps */
+	if (sg->rt_protocol != RTPROT_KERNEL &&
+	    (sg->flags & MDB_PG_FLAGS_PERMANENT))
+		return;
+
+	/* the kernel is now responsible for removing this S,G */
+	del_timer(&sg->timer);
+}
+
+static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src)
+{
+	struct net_bridge_port_group *p, *pg = src->pg;
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_mdb_entry *mp;
+	struct br_ip sg_ip;
+
+	memset(&sg_ip, 0, sizeof(sg_ip));
+	sg_ip = pg->key.addr;
+	sg_ip.src = src->addr.src;
+
+	mp = br_mdb_ip_get(src->br, &sg_ip);
+	if (!mp)
+		return;
+
+	for (pp = &mp->ports;
+	     (p = mlock_dereference(*pp, src->br)) != NULL;
+	     pp = &p->next) {
+		if (!br_port_group_equal(p, pg->key.port, pg->eth_addr))
+			continue;
+
+		if (p->rt_protocol != RTPROT_KERNEL &&
+		    (p->flags & MDB_PG_FLAGS_PERMANENT))
+			break;
+
+		br_multicast_del_pg(mp, p, pp);
+		break;
+	}
+	src->flags &= ~BR_SGRP_F_INSTALLED;
+}
+
+static void br_multicast_fwd_src_handle(struct net_bridge_group_src *src)
+{
+	br_multicast_fwd_src_add(src);
+}
+
 static void br_multicast_destroy_mdb_entry(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_mdb_entry *mp;
@@ -204,7 +286,8 @@ static void br_multicast_group_expired(struct timer_list *t)
 	struct net_bridge *br = mp->br;
 
 	spin_lock(&br->multicast_lock);
-	if (!netif_running(br->dev) || timer_pending(&mp->timer))
+	if (hlist_unhashed(&mp->mdb_node) || !netif_running(br->dev) ||
+	    timer_pending(&mp->timer))
 		goto out;
 
 	br_multicast_host_leave(mp, true);
@@ -231,6 +314,7 @@ static void br_multicast_del_group_src(struct net_bridge_group_src *src)
 {
 	struct net_bridge *br = src->pg->key.port->br;
 
+	br_multicast_fwd_src_remove(src);
 	hlist_del_init_rcu(&src->node);
 	src->pg->src_ents--;
 	hlist_add_head(&src->mcast_gc.gc_node, &br->mcast_gc_list);
@@ -851,19 +935,6 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	return p;
 }
 
-static bool br_port_group_equal(struct net_bridge_port_group *p,
-				struct net_bridge_port *port,
-				const unsigned char *src)
-{
-	if (p->key.port != port)
-		return false;
-
-	if (!(port->flags & BR_MULTICAST_TO_UNICAST))
-		return true;
-
-	return ether_addr_equal(src, p->eth_addr);
-}
-
 void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 {
 	if (!mp->host_joined) {
@@ -884,28 +955,26 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 		br_mdb_notify(mp->br->dev, mp, NULL, RTM_DELMDB);
 }
 
-static int br_multicast_add_group(struct net_bridge *br,
-				  struct net_bridge_port *port,
-				  struct br_ip *group,
-				  const unsigned char *src,
-				  u8 filter_mode,
-				  bool igmpv2_mldv1)
+static struct net_bridge_port_group *
+__br_multicast_add_group(struct net_bridge *br,
+			 struct net_bridge_port *port,
+			 struct br_ip *group,
+			 const unsigned char *src,
+			 u8 filter_mode,
+			 bool igmpv2_mldv1)
 {
 	struct net_bridge_port_group __rcu **pp;
-	struct net_bridge_port_group *p;
+	struct net_bridge_port_group *p = NULL;
 	struct net_bridge_mdb_entry *mp;
 	unsigned long now = jiffies;
-	int err;
 
-	spin_lock(&br->multicast_lock);
 	if (!netif_running(br->dev) ||
 	    (port && port->state == BR_STATE_DISABLED))
 		goto out;
 
 	mp = br_multicast_new_group(br, group);
-	err = PTR_ERR(mp);
 	if (IS_ERR(mp))
-		goto err;
+		return ERR_PTR(PTR_ERR(mp));
 
 	if (!port) {
 		br_multicast_host_join(mp, true);
@@ -923,8 +992,10 @@ static int br_multicast_add_group(struct net_bridge *br,
 
 	p = br_multicast_new_port_group(port, group, *pp, 0, src, filter_mode,
 					RTPROT_KERNEL);
-	if (unlikely(!p))
-		goto err;
+	if (unlikely(!p)) {
+		p = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 	rcu_assign_pointer(*pp, p);
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 
@@ -933,10 +1004,26 @@ static int br_multicast_add_group(struct net_bridge *br,
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
 
 out:
-	err = 0;
+	return p;
+}
+
+static int br_multicast_add_group(struct net_bridge *br,
+				  struct net_bridge_port *port,
+				  struct br_ip *group,
+				  const unsigned char *src,
+				  u8 filter_mode,
+				  bool igmpv2_mldv1)
+{
+	struct net_bridge_port_group *pg;
+	int err;
 
-err:
+	spin_lock(&br->multicast_lock);
+	pg = __br_multicast_add_group(br, port, group, src, filter_mode,
+				      igmpv2_mldv1);
+	/* NULL is considered valid for host joined groups */
+	err = IS_ERR(pg) ? PTR_ERR(pg) : 0;
 	spin_unlock(&br->multicast_lock);
+
 	return err;
 }
 
@@ -1349,6 +1436,13 @@ static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
 	return deleted;
 }
 
+static void __grp_src_mod_timer(struct net_bridge_group_src *src,
+				unsigned long expires)
+{
+	mod_timer(&src->timer, expires);
+	br_multicast_fwd_src_handle(src);
+}
+
 static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 {
 	struct bridge_mcast_other_query *other_query = NULL;
@@ -1377,7 +1471,7 @@ static void __grp_src_query_marked_and_rexmit(struct net_bridge_port_group *pg)
 				    other_query &&
 				    !timer_pending(&other_query->timer))
 					ent->src_query_rexmit_cnt = lmqc;
-				mod_timer(&ent->timer, lmqt);
+				__grp_src_mod_timer(ent, lmqt);
 			}
 		}
 	}
@@ -1456,7 +1550,7 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
 		}
 
 		if (ent)
-			mod_timer(&ent->timer, now + br_multicast_gmi(br));
+			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
 		srcs += src_size;
 	}
 
@@ -1486,7 +1580,9 @@ static void __grp_src_isexc_incl(struct net_bridge_port_group *pg,
 		if (ent)
 			ent->flags &= ~BR_SGRP_F_DELETE;
 		else
-			br_multicast_new_group_src(pg, &src_ip);
+			ent = br_multicast_new_group_src(pg, &src_ip);
+		if (ent)
+			br_multicast_fwd_src_handle(ent);
 		srcs += src_size;
 	}
 
@@ -1522,8 +1618,8 @@ static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg,
 		} else {
 			ent = br_multicast_new_group_src(pg, &src_ip);
 			if (ent) {
-				mod_timer(&ent->timer,
-					  now + br_multicast_gmi(br));
+				__grp_src_mod_timer(ent,
+						    now + br_multicast_gmi(br));
 				changed = true;
 			}
 		}
@@ -1589,7 +1685,7 @@ static bool __grp_src_toin_incl(struct net_bridge_port_group *pg,
 				changed = true;
 		}
 		if (ent)
-			mod_timer(&ent->timer, now + br_multicast_gmi(br));
+			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
 		srcs += src_size;
 	}
 
@@ -1634,7 +1730,7 @@ static bool __grp_src_toin_excl(struct net_bridge_port_group *pg,
 				changed = true;
 		}
 		if (ent)
-			mod_timer(&ent->timer, now + br_multicast_gmi(br));
+			__grp_src_mod_timer(ent, now + br_multicast_gmi(br));
 		srcs += src_size;
 	}
 
@@ -1689,8 +1785,10 @@ static void __grp_src_toex_incl(struct net_bridge_port_group *pg,
 				     BR_SGRP_F_SEND;
 			to_send++;
 		} else {
-			br_multicast_new_group_src(pg, &src_ip);
+			ent = br_multicast_new_group_src(pg, &src_ip);
 		}
+		if (ent)
+			br_multicast_fwd_src_handle(ent);
 		srcs += src_size;
 	}
 
@@ -1727,7 +1825,7 @@ static bool __grp_src_toex_excl(struct net_bridge_port_group *pg,
 		} else {
 			ent = br_multicast_new_group_src(pg, &src_ip);
 			if (ent) {
-				mod_timer(&ent->timer, pg->timer.expires);
+				__grp_src_mod_timer(ent, pg->timer.expires);
 				changed = true;
 			}
 		}
@@ -1823,7 +1921,7 @@ static bool __grp_src_block_excl(struct net_bridge_port_group *pg,
 		if (!ent) {
 			ent = br_multicast_new_group_src(pg, &src_ip);
 			if (ent) {
-				mod_timer(&ent->timer, pg->timer.expires);
+				__grp_src_mod_timer(ent, pg->timer.expires);
 				changed = true;
 			}
 		}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 55486b4956d3..93d76b3dfc35 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -218,6 +218,7 @@ struct net_bridge_fdb_entry {
 
 #define BR_SGRP_F_DELETE	BIT(0)
 #define BR_SGRP_F_SEND		BIT(1)
+#define BR_SGRP_F_INSTALLED	BIT(2)
 
 struct net_bridge_mcast_gc {
 	struct hlist_node		gc_node;
-- 
2.25.4

