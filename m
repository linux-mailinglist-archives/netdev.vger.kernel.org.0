Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D532D257BDF
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgHaPLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgHaPKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F62AC061755
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:11 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id e11so209261wme.0
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkF66m7r4xUb0m+rplUS8hiC/CAl6pksOtOpgPN7vWY=;
        b=PalQxtOUw2ZA8+EUayeTxquqxMovStIieaeQDhJOjtLi99Ce4zOUXRtUGmETOEBsn3
         7DEGm0VxlDHDRjGBKy68NXmcXqwb7uLiDWN87yOyK1GGgOTmZ2kI24+jo+ohIMwElfHy
         uF/Sw6kjv0LPs05toQ5XkcYh/UXPwEdW2MNl8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkF66m7r4xUb0m+rplUS8hiC/CAl6pksOtOpgPN7vWY=;
        b=aTzxg+OhU+MXMNYrXf0wp75i1ydrDpTlkKu+AY/DTmueJ4vRO6AcCVADXsG8CeR9OB
         SQF/2jXJI8VPhgdn0JJIMRgSNfzHB8YUJe9qHGfZmyU89ZMGXs6ZW93Ou3BQGoZYPqvq
         SGsUbN9tjMktkZPYTYdtFJzRqOmYKo1vW6Hd4ux2gs52U+x6NDgdxYfBdgljgxA+iMu4
         GLqaAdNRgyksjOB9zTc4D+DEaHPao1ah728zM+ruM6z1IvRBXOEm1dpxaQ/SKH7RrftU
         AJaS0xpKTBQT9w+3L6qav/uqq6usrZVzDQcFNP6JPiHQve3k1tbOS2Svw6KmoRjzIxMf
         vmcw==
X-Gm-Message-State: AOAM533HOx4GTyK9BNqyydlzIfjxhxxnVCgBpt/E4N5kVX6HUXE5o/H9
        kL2z3btlmvuQ3gxCqta1HcvdP87E5h0V6aaz
X-Google-Smtp-Source: ABdhPJwvYhGJFQHmQL1Ac0Oj+K/CzTs+/6SAw83VKOnDNWHg53vJzu/5Fy2MkphA42Ktvpmjc09Mgw==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr1731570wmb.84.1598886609952;
        Mon, 31 Aug 2020 08:10:09 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:10:09 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 13/15] net: bridge: mcast: support for IGMPV3_BLOCK_OLD_SOURCES report
Date:   Mon, 31 Aug 2020 18:08:43 +0300
Message-Id: <20200831150845.1062447-14-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already have all necessary helpers, so process IGMPV3_BLOCK_OLD_SOURCES
as per the RFC.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_multicast.c | 88 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 2777e3eb07b9..55c2729c61f4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1578,6 +1578,91 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg,
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
+	__grp_src_modify_flags_all(pg, 0, BR_SGRP_F_SEND);
+
+	memset(&src_ip, 0, sizeof(src_ip));
+	src_ip.proto = htons(ETH_P_IP);
+	for (src_idx = 0; src_idx < nsrcs; src_idx++) {
+		src_ip.u.ip4 = srcs[src_idx];
+		ent = br_multicast_find_group_src(pg, &src_ip);
+		if (ent) {
+			__grp_src_modify_flags(ent, BR_SGRP_F_SEND, 0);
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
+	__grp_src_modify_flags_all(pg, 0, BR_SGRP_F_SEND);
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
+			__grp_src_modify_flags(ent, BR_SGRP_F_SEND, 0);
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
@@ -1686,6 +1771,9 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
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

