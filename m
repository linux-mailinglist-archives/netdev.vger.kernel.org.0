Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945CF27219B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgIUK4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgIUK41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70591C0613D1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e17so11667993wme.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dSI61IYGUvQV65ypmHP+5t4/9m2yNYCAWOhMPESqfJ8=;
        b=xPWFLSNljiVJ0iFREi1JRrBz4WlMpqAAelgpsfASnh4mAk5+HEZBULJ+aAk9Fa+17y
         2J9IMRVmBfqU1CkDy8Yhi03g7TOG/QBS2fe8zN1c5ie4MylIe+aBq29GLHjBWid0zrEv
         tIBe2L0sjcdCBlyoQQ0e6XGTjFLzJ9g0miq4PnxLFVwgK8uKdUun2O9JTpo1S3QIr7jF
         geIla/7UytU8US9bWl9Gej9Onct1ysLgRna13Xf5efUpcp+C3Z5mSuG1unbQOrW9eRwF
         i2xvXKSnXm9h3BWX2soigIfog3cxSVgVUFX5VExb3WKW02/eT2T+7BvhJuZ2zpPGz9OM
         m4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSI61IYGUvQV65ypmHP+5t4/9m2yNYCAWOhMPESqfJ8=;
        b=ID+c7EiN5l/0aC7UgUOsiOQYZuVsyTgN5iubN9zRGX5S4p5xMeUZCCxAjjVcKFRd4J
         9cjPmB02/lz+HNWvjOWkh9GuDYTttqncBE7HnoGdmhGLCs0DTnxTyloD9BK2xARDzr03
         8A7RSWATmJ0h7wK1wW2qixGD3flimxVc2u50MVfXuE9EO24uBjEqu/eN6FaJ4+hrAJzj
         cfirXlYwe7SZySjZYjd2g/U7vwtTlDVWhWSH/DDQIZbIVZg29AEk0IS+Z4tYTicBUE15
         7LQR/Xh1EQ/Vyp1USwbWTnAASd71MPdxJC9jzj5JCZja2t0RzLBEGl1r9btNHSAgnrqw
         spNw==
X-Gm-Message-State: AOAM5311C9LiiftsuKVuLQAIfNoBIsnF9Ytcqy/YO+73ZzdgP7KEKdyx
        ZxN1TfJKGAXv/pN7JbaM7wnEUDSBiFdmC1lC+uNATw==
X-Google-Smtp-Source: ABdhPJw1At9tHQPBdQl5p3IR8KoYEGgtP4WkGH04NHOb2cdiUjn7wQJYJRO2KqzS8+MBxqb5u07BLw==
X-Received: by 2002:a1c:818f:: with SMTP id c137mr25666692wmd.0.1600685784817;
        Mon, 21 Sep 2020 03:56:24 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:24 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 14/16] net: bridge: mcast: add support for blocked port groups
Date:   Mon, 21 Sep 2020 13:55:24 +0300
Message-Id: <20200921105526.1056983-15-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When excluding S,G entries we need a way to block a particular S,G,port.
The new port group flag is managed based on the source's timer as per
RFCs 3376 and 3810. When a source expires and its port group is in
EXCLUDE mode, it will be blocked.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            |  2 ++
 net/bridge/br_multicast.c      | 49 +++++++++++++++++++++++++++++-----
 net/bridge/br_private.h        |  1 +
 4 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index e4bd30a25f6b..4c687686aa8f 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -519,6 +519,7 @@ struct br_mdb_entry {
 #define MDB_FLAGS_OFFLOAD	(1 << 0)
 #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
 #define MDB_FLAGS_STAR_EXCL	(1 << 2)
+#define MDB_FLAGS_BLOCKED	(1 << 3)
 	__u8 flags;
 	__u16 vid;
 	struct {
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 28cd35a9cf37..e15bab19a012 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -64,6 +64,8 @@ static void __mdb_entry_fill_flags(struct br_mdb_entry *e, unsigned char flags)
 		e->flags |= MDB_FLAGS_FAST_LEAVE;
 	if (flags & MDB_PG_FLAGS_STAR_EXCL)
 		e->flags |= MDB_FLAGS_STAR_EXCL;
+	if (flags & MDB_PG_FLAGS_BLOCKED)
+		e->flags |= MDB_FLAGS_BLOCKED;
 }
 
 static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip,
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index f39bbd733722..11d224c01914 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -72,7 +72,8 @@ __br_multicast_add_group(struct net_bridge *br,
 			 struct br_ip *group,
 			 const unsigned char *src,
 			 u8 filter_mode,
-			 bool igmpv2_mldv1);
+			 bool igmpv2_mldv1,
+			 bool blocked);
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
 
@@ -211,7 +212,7 @@ static void __fwd_add_star_excl(struct net_bridge_port_group *pg,
 		return;
 
 	src_pg = __br_multicast_add_group(br, pg->key.port, sg_ip, pg->eth_addr,
-					  MCAST_INCLUDE, false);
+					  MCAST_INCLUDE, false, false);
 	if (IS_ERR_OR_NULL(src_pg) ||
 	    src_pg->rt_protocol != RTPROT_KERNEL)
 		return;
@@ -343,7 +344,7 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 		src_pg = __br_multicast_add_group(br, pg->key.port,
 						  &sg->key.addr,
 						  sg->eth_addr,
-						  MCAST_INCLUDE, false);
+						  MCAST_INCLUDE, false, false);
 		if (IS_ERR_OR_NULL(src_pg) ||
 		    src_pg->rt_protocol != RTPROT_KERNEL)
 			continue;
@@ -364,7 +365,8 @@ static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 	sg_ip = src->pg->key.addr;
 	sg_ip.src = src->addr.src;
 	sg = __br_multicast_add_group(src->br, src->pg->key.port, &sg_ip,
-				      src->pg->eth_addr, MCAST_INCLUDE, false);
+				      src->pg->eth_addr, MCAST_INCLUDE, false,
+				      !timer_pending(&src->timer));
 	if (IS_ERR_OR_NULL(sg))
 		return;
 	src->flags |= BR_SGRP_F_INSTALLED;
@@ -415,9 +417,38 @@ static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src)
 	src->flags &= ~BR_SGRP_F_INSTALLED;
 }
 
+/* install S,G and based on src's timer enable or disable forwarding */
 static void br_multicast_fwd_src_handle(struct net_bridge_group_src *src)
 {
+	struct net_bridge_port_group_sg_key sg_key;
+	struct net_bridge_port_group *sg;
+	u8 old_flags;
+
 	br_multicast_fwd_src_add(src);
+
+	memset(&sg_key, 0, sizeof(sg_key));
+	sg_key.addr = src->pg->key.addr;
+	sg_key.addr.src = src->addr.src;
+	sg_key.port = src->pg->key.port;
+
+	sg = br_sg_port_find(src->br, &sg_key);
+	if (!sg || (sg->flags & MDB_PG_FLAGS_PERMANENT))
+		return;
+
+	old_flags = sg->flags;
+	if (timer_pending(&src->timer))
+		sg->flags &= ~MDB_PG_FLAGS_BLOCKED;
+	else
+		sg->flags |= MDB_PG_FLAGS_BLOCKED;
+
+	if (old_flags != sg->flags) {
+		struct net_bridge_mdb_entry *sg_mp;
+
+		sg_mp = br_mdb_ip_get(src->br, &sg_key.addr);
+		if (!sg_mp)
+			return;
+		br_mdb_notify(src->br->dev, sg_mp, sg, RTM_NEWMDB);
+	}
 }
 
 static void br_multicast_destroy_mdb_entry(struct net_bridge_mcast_gc *gc)
@@ -995,7 +1026,10 @@ static void br_multicast_group_src_expired(struct timer_list *t)
 		if (!hlist_empty(&pg->src_list))
 			goto out;
 		br_multicast_find_del_pg(br, pg);
+	} else {
+		br_multicast_fwd_src_handle(src);
 	}
+
 out:
 	spin_unlock(&br->multicast_lock);
 }
@@ -1131,7 +1165,8 @@ __br_multicast_add_group(struct net_bridge *br,
 			 struct br_ip *group,
 			 const unsigned char *src,
 			 u8 filter_mode,
-			 bool igmpv2_mldv1)
+			 bool igmpv2_mldv1,
+			 bool blocked)
 {
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p = NULL;
@@ -1167,6 +1202,8 @@ __br_multicast_add_group(struct net_bridge *br,
 		goto out;
 	}
 	rcu_assign_pointer(*pp, p);
+	if (blocked)
+		p->flags |= MDB_PG_FLAGS_BLOCKED;
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 
 found:
@@ -1189,7 +1226,7 @@ static int br_multicast_add_group(struct net_bridge *br,
 
 	spin_lock(&br->multicast_lock);
 	pg = __br_multicast_add_group(br, port, group, src, filter_mode,
-				      igmpv2_mldv1);
+				      igmpv2_mldv1, false);
 	/* NULL is considered valid for host joined groups */
 	err = IS_ERR(pg) ? PTR_ERR(pg) : 0;
 	spin_unlock(&br->multicast_lock);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 128d2d0417a0..345118e35c42 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -214,6 +214,7 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
 #define MDB_PG_FLAGS_STAR_EXCL	BIT(3)
+#define MDB_PG_FLAGS_BLOCKED	BIT(4)
 
 #define PG_SRC_ENT_LIMIT	32
 
-- 
2.25.4

