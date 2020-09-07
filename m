Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAB125F713
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgIGKAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728503AbgIGKAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BB0C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:29 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so15100462wrl.12
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/HHkOD9Evu1q0SaEZG9U0z2prXuHI60mm4pmhG3cvh0=;
        b=Hp6tXFshRH/sYUgPT4ACltIka6rJl0ZV+TE75THsvuVVOfxMSCQGJpMMHAXWFq64yx
         j/+dZ3bS4dmb5O71FHM0qaUmrvbTcRVNTqhYBDtzOrSrHQjwKJUl8MWe31AJItNuV9sb
         65fKQiZVCFv7o8lDp/DjlrgYQJzUn+Bo89oVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/HHkOD9Evu1q0SaEZG9U0z2prXuHI60mm4pmhG3cvh0=;
        b=dYP7n6bIpY22vX0jskL1SfBGx/s4epmCQMeH+GSwvPBM89N5VnZVa66iKe1HqZ3n3h
         ElDfzjkgLrWmZP079FSPKcdx6xza8Yle1gVY98E9eA7wTTqq44TkgclArNcKPlRqJf/t
         pxBhCK9D2458eryzaSKt9irXa7MwT/GHKQadp9cmT0no6EduO8eHDQjNSZJXhnw9Jiq5
         fgx6heyAXKdVd5ZQIIzpkUFPCt5V2lhrKhAA3kC3QIctAexDYd97rCei23pe3FgC1v5H
         ShZ/JNebbCHO55O485Tvj8bNSHh3YiTQ5zKcGUkRXJkw/tcKs3d1hgIN24ymXyxBsoSM
         3RIA==
X-Gm-Message-State: AOAM532s7LOWEyrTQzDnCHR+sJQALiOgCbJ00ossjjU0ZFSd+xcgnFoG
        npKvYm1MFNI2Tvv9wZQStUKJ6dwVFwoL+xmX
X-Google-Smtp-Source: ABdhPJxNj5jJhL0+QgT0hVq+mm0pwIlT0ig7CzrdNDGnFzVRlRg5guN14rwSRRwIXypDv8MzgDiqAQ==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr19860320wrn.333.1599472827972;
        Mon, 07 Sep 2020 03:00:27 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:27 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 11/15] net: bridge: mcast: support for IGMPV3/MLDv2 MODE_IS_INCLUDE/EXCLUDE report
Date:   Mon,  7 Sep 2020 12:56:15 +0300
Message-Id: <20200907095619.11216-12-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to process IGMPV3/MLDv2_MODE_IS_INCLUDE/EXCLUDE report types we
need some new helpers which allow us to set/clear flags for all current
entries and later delete marked entries after the report sources have been
processed.

v3: add IPv6/MLDv2 support
v2: drop flag helpers and directly do flag bit operations

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 126 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 98600a08114e..634415e8c50f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1229,6 +1229,21 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	spin_unlock(&br->multicast_lock);
 }
 
+static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
+{
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
+	int deleted = 0;
+
+	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
+		if (ent->flags & BR_SGRP_F_DELETE) {
+			br_multicast_del_group_src(ent);
+			deleted++;
+		}
+
+	return deleted;
+}
+
 /* State          Msg type      New state                Actions
  * INCLUDE (A)    IS_IN (B)     INCLUDE (A+B)            (B)=GMI
  * INCLUDE (A)    ALLOW (B)     INCLUDE (A+B)            (B)=GMI
@@ -1263,6 +1278,101 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    IS_EX (B)     EXCLUDE (A*B,B-A)        (B-A)=0
+ *                                                       Delete (A-B)
+ *                                                       Group Timer=GMI
+ */
+static void __grp_src_isexc_incl(struct net_bridge_port_group *pg,
+				 void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge_group_src *ent;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags |= BR_SGRP_F_DELETE;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = pg->addr.proto;
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		memcpy(&src_ip.u, srcs, src_size);
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent)
+			ent->flags &= ~BR_SGRP_F_DELETE;
+		else
+			br_multicast_new_group_src(pg, &src_ip);
+		srcs += src_size;
+	}
+
+	__grp_src_delete_marked(pg);
+}
+
+/* State          Msg type      New state                Actions
+ * EXCLUDE (X,Y)  IS_EX (A)     EXCLUDE (A-Y,Y*A)        (A-X-Y)=GMI
+ *                                                       Delete (X-A)
+ *                                                       Delete (Y-A)
+ *                                                       Group Timer=GMI
+ */
+static bool __grp_src_isexc_excl(struct net_bridge_port_group *pg,
+				 void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge *br = pg->port->br;
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	bool changed = false;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags |= BR_SGRP_F_DELETE;
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
+				mod_timer(&ent->timer,
+					  now + br_multicast_gmi(br));
+				changed = true;
+			}
+		}
+		srcs += src_size;
+	}
+
+	if (__grp_src_delete_marked(pg))
+		changed = true;
+
+	return changed;
+}
+
+static bool br_multicast_isexc(struct net_bridge_port_group *pg,
+			       void *srcs, u32 nsrcs, size_t src_size)
+{
+	struct net_bridge *br = pg->port->br;
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		__grp_src_isexc_incl(pg, srcs, nsrcs, src_size);
+		changed = true;
+		break;
+	case MCAST_EXCLUDE:
+		changed = __grp_src_isexc_excl(pg, srcs, nsrcs, src_size);
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
@@ -1360,6 +1470,14 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			changed = br_multicast_isinc_allow(pg, grec->grec_src,
 							   nsrcs, sizeof(__be32));
 			break;
+		case IGMPV3_MODE_IS_INCLUDE:
+			changed = br_multicast_isinc_allow(pg, grec->grec_src, nsrcs,
+							   sizeof(__be32));
+			break;
+		case IGMPV3_MODE_IS_EXCLUDE:
+			changed = br_multicast_isexc(pg, grec->grec_src, nsrcs,
+						     sizeof(__be32));
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
@@ -1466,6 +1584,14 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 							   nsrcs,
 							   sizeof(struct in6_addr));
 			break;
+		case MLD2_MODE_IS_INCLUDE:
+			changed = br_multicast_isinc_allow(pg, grec->grec_src, nsrcs,
+							   sizeof(struct in6_addr));
+			break;
+		case MLD2_MODE_IS_EXCLUDE:
+			changed = br_multicast_isexc(pg, grec->grec_src, nsrcs,
+						     sizeof(struct in6_addr));
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
-- 
2.25.4

