Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790CC257BDC
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgHaPLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgHaPKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5049C06123C
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w5so6307816wrp.8
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+DNmU1Xv05r8D5bnGnixuyCJobIehuSOVzITcXMdjAE=;
        b=ROqhN/ksH/TIegUsrutRyqQT9Rwrng7cqbedZh7HVktwUQ0RoVLtGBvqhu5KfOSxYa
         kgVGr/Gt53FpoLxiHwFD9r+agp2E9TxHtAvGUaPEnyzwGBgF5znGzSDbPO6Uo6cMEiK9
         6+Seivfrx3lwsZUv9xTp77ECx7mJ5TQm/DPfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+DNmU1Xv05r8D5bnGnixuyCJobIehuSOVzITcXMdjAE=;
        b=tTih7jqqfK+VX4UQYX5Bas7LydzCP4SK/zNtBnmfugq60Rn471WK7W7Cem5h1VFQkV
         +bGjBcljobz58MOhGQQVYpD6oANZmffve6L3fN5Wk7mH0Wewn19ZH9lzSFdlFAUfQqBw
         BlkF4p0mFkyski3HWKApcjbZCl6cwO2rjLfkdmOFKGkxnBWbJ7Vfq6OqOP9fzI7Db5HQ
         GUo33yRI9H9FHH22c+Ncuie7vAZRuQqhHy67RJsiRMQXm/TnStPqyVCNVnVrcEMo0aWf
         QKzsjJnwrdmyIDdx7XFGaAWDmpMTrxAI5xCARARPq9/hlv/R/Yg1NV4fwj/ADgbIzF0V
         383A==
X-Gm-Message-State: AOAM532Ka9GgQYnmmJKe83fw0YAXm9INjiw4vasKwKmhy7ziw5DOX1o3
        fOX0fcBNEPEZgM/99Q4R395E4owbqQZEr+n7
X-Google-Smtp-Source: ABdhPJwyRX8CR9rA4oClz7WjCQoSAUIIIMDweCneaTCHv1Z2yEHrl+5UuVVcuEpqkXScwgThLQObxQ==
X-Received: by 2002:a5d:554c:: with SMTP id g12mr2059812wrw.294.1598886607013;
        Mon, 31 Aug 2020 08:10:07 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:10:06 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 11/15] net: bridge: mcast: support for IGMPV3_MODE_IS_INCLUDE/EXCLUDE report
Date:   Mon, 31 Aug 2020 18:08:41 +0300
Message-Id: <20200831150845.1062447-12-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to process IGMPV3_MODE_IS_INCLUDE/EXCLUDE report types we need
some new helpers which allow us to set/clear flags for all current entries
and later delete marked entries after the report sources have been
processed.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 128 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index cf76a95f1599..2ba43d497515 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1156,6 +1156,37 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	spin_unlock(&br->multicast_lock);
 }
 
+static void __grp_src_modify_flags(struct net_bridge_group_src *src,
+				   u8 set_flags, u8 clear_flags)
+{
+	src->flags |= set_flags;
+	src->flags &= ~clear_flags;
+}
+
+static void __grp_src_modify_flags_all(struct net_bridge_port_group *pg,
+				       u8 set_flags, u8 clear_flags)
+{
+	struct net_bridge_group_src *ent;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		__grp_src_modify_flags(ent, set_flags, clear_flags);
+}
+
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
@@ -1189,6 +1220,97 @@ static bool br_multicast_isinc_allow(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    IS_EX (B)     EXCLUDE (A*B,B-A)        (B-A)=0
+ *                                                       Delete (A-B)
+ *                                                       Group Timer=GMI
+ */
+static void __grp_src_isexc_incl(struct net_bridge_port_group *pg,
+				 __be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge_group_src *ent;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	__grp_src_modify_flags_all(pg, BR_SGRP_F_DELETE, 0);
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent)
+			__grp_src_modify_flags(ent, 0, BR_SGRP_F_DELETE);
+		else
+			br_multicast_new_group_src(pg, &src_ip);
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
+				 __be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge *br = pg->port->br;
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	bool changed = false;
+	struct br_ip src_ip;
+	u32 src_idx;
+
+	__grp_src_modify_flags_all(pg, BR_SGRP_F_DELETE, 0);
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			__grp_src_modify_flags(ent, 0, BR_SGRP_F_DELETE);
+		} else {
+			ent = br_multicast_new_group_src(pg, &src_ip);
+			if (ent) {
+				mod_timer(&ent->timer,
+					  now + br_multicast_gmi(br));
+				changed = true;
+			}
+		}
+	}
+
+	if (__grp_src_delete_marked(pg))
+		changed = true;
+
+	return changed;
+}
+
+static bool br_multicast_isexc(struct net_bridge_port_group *pg,
+			       __be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge *br = pg->port->br;
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		__grp_src_isexc_incl(pg, srcs, nsrcs);
+		changed = true;
+		break;
+	case MCAST_EXCLUDE:
+		changed = __grp_src_isexc_excl(pg, srcs, nsrcs);
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
@@ -1285,6 +1407,12 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		case IGMPV3_ALLOW_NEW_SOURCES:
 			changed = br_multicast_isinc_allow(pg, grec->grec_src, nsrcs);
 			break;
+		case IGMPV3_MODE_IS_INCLUDE:
+			changed = br_multicast_isinc_allow(pg, grec->grec_src, nsrcs);
+			break;
+		case IGMPV3_MODE_IS_EXCLUDE:
+			changed = br_multicast_isexc(pg, grec->grec_src, nsrcs);
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
-- 
2.25.4

