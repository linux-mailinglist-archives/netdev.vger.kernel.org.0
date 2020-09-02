Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C610F25AA56
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgIBLb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgIBL3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E87DC06125E
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:28 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v4so4123996wmj.5
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzhrU1X5QK7zN9nZRqOyfgvddTz2HYLjcgzS650iqOY=;
        b=dQCacWclRvKUoroMCZyEzf8Y0w/TlGmaQVejCerdl7W1g6J/0c6ioHmIsv+/+Aa7F5
         8DuAYRlg7lJb9fl7a8wPRhv7KMZCA2x44X7zuZewQBmsZ80stg7l5nDkhQuAQoTiAHNy
         hG00WySylt9FmCYn83mn/GwozFXoEdsQUjb5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzhrU1X5QK7zN9nZRqOyfgvddTz2HYLjcgzS650iqOY=;
        b=F3bG+NK88+DDIgdfR09jRcpWtiItspZt/6DDG5b64Vk+4R9n3bmWx4ZpeLHLP233z3
         x25O+LdX3f5VbA0m2tny5/nQBvlN/Hn1ehNwglTv6M1LS1TfNuyJTb5MWeUKmsFtPgG3
         TF/EQ/0DdZoP4P5OoyW249MLphYEX7baBC47S3d096OU4BgxfH76jZ132CR/mKlGzkYH
         tnuqhtW/S/Jx93r7Vn6nGZjzyWmDLiGA0vvUHgcLc2jg8d0StFyw7QnKvjA9eSEpwdMX
         K4KwwNjdHtWqRzSCJPrl48ChgnBls/O8fdbA9TdD+xpd8R00a494jcDbtW7ItMbAOpkH
         LD0A==
X-Gm-Message-State: AOAM532dLc9plbfDTBSSDWDcAQcyy7khNr8Qne8nS5SFoMkKvAUjCRKp
        ekv9b4hf+e0+6MQsYGhU7Hf/lvv0TzSdvJMo
X-Google-Smtp-Source: ABdhPJxx70Tnqtku1r/LXj+0qZlA8oiunwxX6hK53RqVd7boHBOwsGlZjrMuO6gks8hAUU3i5Ic7nw==
X-Received: by 2002:a05:600c:2f8f:: with SMTP id t15mr204386wmn.41.1599046166896;
        Wed, 02 Sep 2020 04:29:26 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:26 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 13/15] net: bridge: mcast: support for IGMPV3_BLOCK_OLD_SOURCES report
Date:   Wed,  2 Sep 2020 14:25:27 +0300
Message-Id: <20200902112529.1570040-14-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already have all necessary helpers, so process IGMPV3_BLOCK_OLD_SOURCES
as per the RFC.

v2: directly do flag bit operations

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 90 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 0dffd5a26110..7df192e9ec50 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1558,6 +1558,93 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg,
 	return changed;
 }
 
+/* State          Msg type      New state                Actions
+ * INCLUDE (A)    BLOCK (B)     INCLUDE (A)              Send Q(G,A*B)
+ */
+static void __grp_src_block_incl(struct net_bridge_port_group *pg,
+				 __be32 *srcs, u32 nsrcs)
+{
+	struct net_bridge_group_src *ent;
+	u32 src_idx, to_send = 0;
+	struct br_ip src_ip;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags &= ~BR_SGRP_F_SEND;
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			ent->flags |= BR_SGRP_F_SEND;
+			to_send++;
+		}
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
+				 __be32 *srcs, u32 nsrcs)
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
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
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
+	}
+
+	if (to_send)
+		__grp_src_query_marked_and_rexmit(pg);
+
+	return changed;
+}
+
+static bool br_multicast_block(struct net_bridge_port_group *pg,
+			       __be32 *srcs, u32 nsrcs)
+{
+	bool changed = false;
+
+	switch (pg->filter_mode) {
+	case MCAST_INCLUDE:
+		__grp_src_block_incl(pg, srcs, nsrcs);
+		break;
+	case MCAST_EXCLUDE:
+		changed = __grp_src_block_excl(pg, srcs, nsrcs);
+		break;
+	}
+
+	return changed;
+}
+
 static struct net_bridge_port_group *
 br_multicast_find_port(struct net_bridge_mdb_entry *mp,
 		       struct net_bridge_port *p,
@@ -1666,6 +1753,9 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 		case IGMPV3_CHANGE_TO_EXCLUDE:
 			changed = br_multicast_toex(pg, grec->grec_src, nsrcs);
 			break;
+		case IGMPV3_BLOCK_OLD_SOURCES:
+			changed = br_multicast_block(pg, grec->grec_src, nsrcs);
+			break;
 		}
 		if (changed)
 			br_mdb_notify(br->dev, mdst, pg, RTM_NEWMDB);
-- 
2.25.4

