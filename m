Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A4C25AA53
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgIBLbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgIBL30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:26 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5065BC061246
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id m6so4867178wrn.0
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WQVx57lpxhwPFsPNQAezt/1bPQj12DWcBPV6SR3gQ/k=;
        b=WXO6Aitb6qbbLzLHlic8rETcl8AstqmpqHPyudTpfEGpjpV4Fi5Md4ZCmHs6yrt8cz
         wPhvXdbfGnCc5rY7Id7Hc6tKVds33+nheokk9grQA+Mssh8C+PVbVSo3jxS8Ul2r+cjx
         QDTAqWc8crQxNaSRWRtpiUE7gzlXe75TucPM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WQVx57lpxhwPFsPNQAezt/1bPQj12DWcBPV6SR3gQ/k=;
        b=H39/Q52Ckp2HGnKKq6+LDqq5NdaxATJ7/kQFrlCu6YEhmHlg2f9U9jc+VeeZhisR9n
         NjzCF1VPP/2PJ804UolbbKEBA7pXnDrYFLu/3KqHb0YVtSuFUbVrX9gGvaxkGzYVubFo
         YDOCxaSj37w1G5c9ZlyrSNq13sk7RmjCYFwAcKMAScG7QIJK7ZDPAjylv6WnEGc4Wmni
         qcDzz7LEy/z0rEQhKOvbglbJYhotCx81yliw9jGYwUaUwfR7bt3UjB9a5Qh5pBGOLtco
         s3KxIpnSpcqOZQ/AjKH55YL/dMBwSF4e3/oXTAj6sBFytjsRg/BMDSRR3P1jYni+rBG7
         2x7A==
X-Gm-Message-State: AOAM532wFGafvDVDeiZRbfEd5ZpPxZlc7qOlOHuL0SpEXuOwBOJJeJlY
        Nm+HlKHnwWRVKtVerZhQPb8FTTQw9uBh5nc8
X-Google-Smtp-Source: ABdhPJyQThJ2XLtwUPjTHB/cKdi1MxOJvKLFZ645vrIuBJKHK6txIEqw5+r/H8kkZinVRFHf/gsaQQ==
X-Received: by 2002:a5d:514e:: with SMTP id u14mr1914235wrt.211.1599046162468;
        Wed, 02 Sep 2020 04:29:22 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:21 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 10/15] net: bridge: mcast: support for IGMPv3 IGMPV3_ALLOW_NEW_SOURCES report
Date:   Wed,  2 Sep 2020 14:25:24 +0300
Message-Id: <20200902112529.1570040-11-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds handling for the IGMPV3_ALLOW_NEW_SOURCES IGMPv3 report
type and limits it only when multicast_igmp_version == 3. Now that
IGMPv3 handling functions will be managing timers we need to delay their
activation, thus a new argument is added which controls if the timer
should be updated. We also disable host IGMPv3 handling as it's not yet
implemented and could cause inconsistent group state, the host can only
join a group as EXCLUDE {} or leave it.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 113 ++++++++++++++++++++++++++++++++------
 net/bridge/br_private.h   |   7 +++
 2 files changed, 103 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index aabb1fcc7fa1..93771309f59f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -721,7 +721,8 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 static int br_multicast_add_group(struct net_bridge *br,
 				  struct net_bridge_port *port,
 				  struct br_ip *group,
-				  const unsigned char *src)
+				  const unsigned char *src,
+				  bool update_timer)
 {
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
@@ -760,7 +761,8 @@ static int br_multicast_add_group(struct net_bridge *br,
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 
 found:
-	mod_timer(&p->timer, now + br->multicast_membership_interval);
+	if (update_timer)
+		mod_timer(&p->timer, now + br->multicast_membership_interval);
 
 out:
 	err = 0;
@@ -774,7 +776,8 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 				      struct net_bridge_port *port,
 				      __be32 group,
 				      __u16 vid,
-				      const unsigned char *src)
+				      const unsigned char *src,
+				      bool update_timer)
 {
 	struct br_ip br_group;
 
@@ -786,7 +789,7 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 
-	return br_multicast_add_group(br, port, &br_group, src);
+	return br_multicast_add_group(br, port, &br_group, src, update_timer);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -806,7 +809,7 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
 
-	return br_multicast_add_group(br, port, &br_group, src);
+	return br_multicast_add_group(br, port, &br_group, src, true);
 }
 #endif
 
@@ -1153,20 +1156,71 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	spin_unlock(&br->multicast_lock);
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    IS_IN (B)     INCLUDE (A+B)            (B)=GMI
+ * INCLUDE (A)    ALLOW (B)     INCLUDE (A+B)            (B)=GMI
+ * EXCLUDE (X,Y)  ALLOW (A)     EXCLUDE (X+A,Y-A)        (A)=GMI
+ */
+static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
+				     __be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge *br = pg->port->br;
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	bool changed = false;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (!ent) {
+			ent = br_multicast_new_group_src(pg, &src_ip);
+			if (ent)
+				changed = true;
+		}
+
+		if (ent)
+			mod_timer(&ent->timer, now + br_multicast_gmi(br));
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
@@ -1187,7 +1241,6 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		if (!ip_mc_may_pull(skb, len))
 			return -EINVAL;
 
-		/* We treat this as an IGMPv2 report for now. */
 		switch (type) {
 		case IGMPV3_MODE_IS_INCLUDE:
 		case IGMPV3_MODE_IS_EXCLUDE:
@@ -1202,16 +1255,41 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		}
 
 		src = eth_hdr(skb)->h_source;
-		if ((type == IGMPV3_CHANGE_TO_INCLUDE ||
-		     type == IGMPV3_MODE_IS_INCLUDE) &&
-		    nsrcs == 0) {
-			br_ip4_multicast_leave_group(br, port, group, vid, src);
+		if (nsrcs == 0 &&
+		    (type == IGMPV3_CHANGE_TO_INCLUDE ||
+		     type == IGMPV3_MODE_IS_INCLUDE)) {
+			if (igmpv2 || !port) {
+				br_ip4_multicast_leave_group(br, port, group, vid, src);
+				continue;
+			}
 		} else {
 			err = br_ip4_multicast_add_group(br, port, group, vid,
-							 src);
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
+			changed = br_multicast_isinc_allow(pg, grec->grec_src, nsrcs);
+			break;
+		}
+		if (changed)
+			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
+unlock_continue:
+		spin_unlock_bh(&br->multicast_lock);
 	}
 
 	return err;
@@ -1859,7 +1937,8 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 	case IGMP_HOST_MEMBERSHIP_REPORT:
 	case IGMPV2_HOST_MEMBERSHIP_REPORT:
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-		err = br_ip4_multicast_add_group(br, port, ih->group, vid, src);
+		err = br_ip4_multicast_add_group(br, port, ih->group, vid, src,
+						 true);
 		break;
 	case IGMPV3_HOST_MEMBERSHIP_REPORT:
 		err = br_ip4_multicast_igmp3_report(br, port, skb, vid);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 78822d3a3b7c..a18bd67dab34 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -875,6 +875,13 @@ static inline unsigned long br_multicast_lmqt(const struct net_bridge *br)
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

