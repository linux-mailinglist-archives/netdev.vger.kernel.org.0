Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2130A25F714
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgIGKAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728459AbgIGKA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB16C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c18so15120527wrm.9
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oE5q0x2KPUVm0YFNyyRau1/JmJvYh8O0fnBvPZslgx4=;
        b=Yrv4qoq8EBHMOnzNJj16VtXMz7S42DwlwAUI1qI59I3+q8g/yufauRzLHfEEyyyrhC
         WeGFmINZEwV7FMOI6bzjy97exXqGRIIPl7Xu1t8MXifPUXbJ67eHDgxJ9/LpGwQ0s5HX
         NbMBlJzsRl0Vke0iktkremZJCyxEb4Gri7tPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oE5q0x2KPUVm0YFNyyRau1/JmJvYh8O0fnBvPZslgx4=;
        b=Ze41Is0ZmzlYP84XT/hJAXzskJF5hb5yt6qia15C1+h2WLEhSzzuXpTjo/fA5oob6P
         BOxWpvHJPbzk9HNWGFwdlrgpwsIpnrOcY/K8p0doOuHMlHQCMSzgAw0AiD9AN7jIKOSH
         GMJLEDIw9g/6OBmceFmTF/Zv0HabC/GXkQLN7WrOuAA7+fv8Iyw+zS/WAJ7+E3S2b3/8
         Vjeq467Jql16BQmuHjv5++Jh5fpXYHqS2DBkKrUOXsozKnwz+stRQMc1eed6p+FBH/vN
         3kRWJsCCvDOI5PZ5PT1co6XUSPOwTu7hfdcvbtamE3xubsZvvnbHQbXXnPMaGb5lPby/
         Bn/w==
X-Gm-Message-State: AOAM533Jy/HbMr77jpXo8J2k4DEI9vNmq+IiUY0bA5mMxOgYqEVR9fSd
        4R8Cz/MV0o1uVek0U/tojOBTj/9lKbtEh1Gx
X-Google-Smtp-Source: ABdhPJxziB9pnJ5og7QFvrOiBgIgNLPz1+TcNUr9oGc5cc0Q4WtdrX/HBixnbnEWSSS8I4Wj9f+XGA==
X-Received: by 2002:a5d:4e03:: with SMTP id p3mr20602290wrt.354.1599472826412;
        Mon, 07 Sep 2020 03:00:26 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:25 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 10/15] net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report
Date:   Mon,  7 Sep 2020 12:56:14 +0300
Message-Id: <20200907095619.11216-11-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds handling for the ALLOW_NEW_SOURCES IGMPv3/MLDv2 report
types and limits them only when multicast_igmp_version == 3 or
multicast_mld_version == 2 respectively. Now that IGMPv3/MLDv2 handling
functions will be managing timers we need to delay their activation, thus
a new argument is added which controls if the timer should be updated.
We also disable host IGMPv3/MLDv2 handling as it's not yet implemented and
could cause inconsistent group state, the host can only join a group as
EXCLUDE {} or leave it.

v4: rename update_timer to igmpv2_mldv1 and use the passed value from
    br_multicast_add_group's callers
v3: Add IPv6/MLDv2 support

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 152 ++++++++++++++++++++++++++++++++------
 net/bridge/br_private.h   |   7 ++
 2 files changed, 137 insertions(+), 22 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ba2ce875a80e..98600a08114e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -787,7 +787,8 @@ static int br_multicast_add_group(struct net_bridge *br,
 				  struct net_bridge_port *port,
 				  struct br_ip *group,
 				  const unsigned char *src,
-				  u8 filter_mode)
+				  u8 filter_mode,
+				  bool igmpv2_mldv1)
 {
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
@@ -826,7 +827,8 @@ static int br_multicast_add_group(struct net_bridge *br,
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 
 found:
-	mod_timer(&p->timer, now + br->multicast_membership_interval);
+	if (igmpv2_mldv1)
+		mod_timer(&p->timer, now + br->multicast_membership_interval);
 
 out:
 	err = 0;
@@ -855,7 +857,8 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 	br_group.vid = vid;
 	filter_mode = igmpv2 ? MCAST_EXCLUDE : MCAST_INCLUDE;
 
-	return br_multicast_add_group(br, port, &br_group, src, filter_mode);
+	return br_multicast_add_group(br, port, &br_group, src, filter_mode,
+				      igmpv2);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -878,7 +881,8 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 	br_group.vid = vid;
 	filter_mode = mldv1 ? MCAST_EXCLUDE : MCAST_INCLUDE;
 
-	return br_multicast_add_group(br, port, &br_group, src, filter_mode);
+	return br_multicast_add_group(br, port, &br_group, src, filter_mode,
+				      mldv1);
 }
 #endif
 
@@ -1225,20 +1229,72 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	spin_unlock(&br->multicast_lock);
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    IS_IN (B)     INCLUDE (A+B)            (B)=GMI
+ * INCLUDE (A)    ALLOW (B)     INCLUDE (A+B)            (B)=GMI
+ * EXCLUDE (X,Y)  ALLOW (A)     EXCLUDE (X+A,Y-A)        (A)=GMI
+ */
+static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
+				     void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge *br = pg->port->br;
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	bool changed = false;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (!ent) {
+			ent = br_multicast_new_group_src(pg, &src_ip);
+			if (ent)
+				changed = true;
+		}
+
+		if (ent)
+			mod_timer(&ent->timer, now + br_multicast_gmi(br));
+		srcs += src_size;
+	}
+
+	return changed;
+}
+
+static struct net_bridge_port_group *
+br_multicast_find_port(struct net_bridge_mdb_entry *mp,
+		       struct net_bridge_port *p,
+		       const unsigned char *src)
+{
+	struct net_bridge_port_group *pg;
+	struct net_bridge *br = mp->br;
+
+	for (pg = mlock_dereference(mp->ports, br);
+	     pg;
+	     pg = mlock_dereference(pg->next, br))
+		if (br_port_group_equal(pg, p, src))
+			return pg;
+
+	return NULL;
+}
+
 static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 					 struct net_bridge_port *port,
 					 struct sk_buff *skb,
 					 u16 vid)
 {
+	bool igmpv2 = br->multicast_igmp_version == 2;
+	struct net_bridge_mdb_entry *mdst;
+	struct net_bridge_port_group *pg;
 	const unsigned char *src;
 	struct igmpv3_report *ih;
 	struct igmpv3_grec *grec;
-	int i;
-	int len;
-	int num;
-	int type;
-	int err = 0;
+	int i, len, num, type;
+	bool changed = false;
 	__be32 group;
+	int err = 0;
 	u16 nsrcs;
 
 	ih = igmpv3_report_hdr(skb);
@@ -1259,7 +1315,6 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		if (!ip_mc_may_pull(skb, len))
 			return -EINVAL;
 
-		/* We treat this as an IGMPv2 report for now. */
 		switch (type) {
 		case IGMPV3_MODE_IS_INCLUDE:
 		case IGMPV3_MODE_IS_EXCLUDE:
@@ -1274,16 +1329,42 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		}
 
 		src = eth_hdr(skb)->h_source;
-		if ((type == IGMPV3_CHANGE_TO_INCLUDE ||
-		     type == IGMPV3_MODE_IS_INCLUDE) &&
-		    nsrcs == 0) {
-			br_ip4_multicast_leave_group(br, port, group, vid, src);
+		if (nsrcs == 0 &&
+		    (type == IGMPV3_CHANGE_TO_INCLUDE ||
+		     type == IGMPV3_MODE_IS_INCLUDE)) {
+			if (!port || igmpv2) {
+				br_ip4_multicast_leave_group(br, port, group, vid, src);
+				continue;
+			}
 		} else {
 			err = br_ip4_multicast_add_group(br, port, group, vid,
-							 src, true);
+							 src, igmpv2);
 			if (err)
 				break;
 		}
+
+		if (!port || igmpv2)
+			continue;
+
+		spin_lock_bh(&br->multicast_lock);
+		mdst = br_mdb_ip4_get(br, group, vid);
+		if (!mdst)
+			goto unlock_continue;
+		pg = br_multicast_find_port(mdst, port, src);
+		if (!pg || (pg->flags & MDB_PG_FLAGS_PERMANENT))
+			goto unlock_continue;
+		/* reload grec */
+		grec = (void *)(skb->data + len - sizeof(*grec) - (nsrcs * 4));
+		switch (type) {
+		case IGMPV3_ALLOW_NEW_SOURCES:
+			changed = br_multicast_isinc_allow(pg, grec->grec_src,
+							   nsrcs, sizeof(__be32));
+			break;
+		}
+		if (changed)
+			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+unlock_continue:
+		spin_unlock_bh(&br->multicast_lock);
 	}
 
 	return err;
@@ -1295,14 +1376,16 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 					struct sk_buff *skb,
 					u16 vid)
 {
+	bool mldv1 = br->multicast_mld_version == 1;
+	struct net_bridge_mdb_entry *mdst;
+	struct net_bridge_port_group *pg;
 	unsigned int nsrcs_offset;
 	const unsigned char *src;
 	struct icmp6hdr *icmp6h;
 	struct mld2_grec *grec;
 	unsigned int grec_len;
-	int i;
-	int len;
-	int num;
+	bool changed = false;
+	int i, len, num;
 	int err = 0;
 
 	if (!ipv6_mc_may_pull(skb, sizeof(*icmp6h)))
@@ -1336,7 +1419,6 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		grec = (struct mld2_grec *)(skb->data + len);
 		len += grec_len;
 
-		/* We treat these as MLDv1 reports for now. */
 		switch (grec->grec_type) {
 		case MLD2_MODE_IS_INCLUDE:
 		case MLD2_MODE_IS_EXCLUDE:
@@ -1354,15 +1436,41 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		if ((grec->grec_type == MLD2_CHANGE_TO_INCLUDE ||
 		     grec->grec_type == MLD2_MODE_IS_INCLUDE) &&
 		    nsrcs == 0) {
-			br_ip6_multicast_leave_group(br, port, &grec->grec_mca,
-						     vid, src);
+			if (!port || mldv1) {
+				br_ip6_multicast_leave_group(br, port,
+							     &grec->grec_mca,
+							     vid, src);
+				continue;
+			}
 		} else {
 			err = br_ip6_multicast_add_group(br, port,
 							 &grec->grec_mca, vid,
-							 src, true);
+							 src, mldv1);
 			if (err)
 				break;
 		}
+
+		if (!port || mldv1)
+			continue;
+
+		spin_lock_bh(&br->multicast_lock);
+		mdst = br_mdb_ip6_get(br, &grec->grec_mca, vid);
+		if (!mdst)
+			goto unlock_continue;
+		pg = br_multicast_find_port(mdst, port, src);
+		if (!pg || (pg->flags & MDB_PG_FLAGS_PERMANENT))
+			goto unlock_continue;
+		switch (grec->grec_type) {
+		case MLD2_ALLOW_NEW_SOURCES:
+			changed = br_multicast_isinc_allow(pg, grec->grec_src,
+							   nsrcs,
+							   sizeof(struct in6_addr));
+			break;
+		}
+		if (changed)
+			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+unlock_continue:
+		spin_unlock_bh(&br->multicast_lock);
 	}
 
 	return err;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b2a226070846..fb35a73fc559 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -876,6 +876,13 @@ static inline unsigned long br_multicast_lmqt(const struct net_bridge *br)
 	return br->multicast_last_member_interval *
 	       br->multicast_last_member_count;
 }
+
+static inline unsigned long br_multicast_gmi(const struct net_bridge *br)
+{
+	/* use the RFC default of 2 for QRV */
+	return 2 * br->multicast_query_interval +
+	       br->multicast_query_response_interval;
+}
 #else
 static inline int br_multicast_rcv(struct net_bridge *br,
 				   struct net_bridge_port *port,
-- 
2.25.4

