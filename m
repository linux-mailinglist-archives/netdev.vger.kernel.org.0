Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F022627219A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIUK4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIUK42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A3FC0613D2
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id m6so12260562wrn.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgky1A3hcxj1MPtWkJkYb67UkAbVS/Usr+n+qMifYIA=;
        b=C17WewuTMBmPOJeGBAe4bpLQkSlLYAIqfc/WuuE3KNpR/UHv0TonzV/CFA9ogkUsF9
         PRD0lI/nPA3Jeq27b2l2iHDrXv4+YcdPbl6Fs/DSwdqkfoZVBJYKBDywmE0Cy0zP+wa+
         +JbwjSW1sNGFEtLFYgaihzRzHRELVveiUYOU3BsrXw4lGGX0H76w65bJfXgJAitM48KO
         oo3sOhQ2WmeJ+H+xbpougKh0+7o0hMPH13g+LFxypMzRYGsQTMqlTyg1C08v8jlSmPom
         YCrGbBreVJDVvPKvXmeSP+Gab8r0AAXL+iLrhqDL9081kYa03B6BUFdvWQYnRWlSOAio
         38lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgky1A3hcxj1MPtWkJkYb67UkAbVS/Usr+n+qMifYIA=;
        b=j0IEoYT3hVC2o9QTUQauGLlx6L+vUbGA4AXqsrJhiYwq9U3tgbaNv0wMoFdWQzL7PO
         VyKehJcFpi7gx/SZHLa838fKRJMAUgh+Fbhd47xS7s+FaFoQegMgbFr4rCtAzt1FgVe7
         g9C+jMawMIHD4+piVUfLGS3bU1hR92mRUcL8PH/a+o+Cr5ameeq9jWkdUX/i1SKZ53Ex
         aBqbqF6NrvshLntgYlzO7Yg6D3ZxeTiqW/oWwkDrXhxFHgkRvaXWie0aVTYNNSbvfJUa
         c93SPChNyhhq88VyoqGtuFL5QRlHRW/yIjGLq/WzCl85NP/1UrIf/djkLz1khamnIrD0
         SX5A==
X-Gm-Message-State: AOAM533rV//bAivOlFzONnB+GlAJM7fx78gRLu+xUE6nukzsU6xdXPFn
        4bepKScs92wVeW5uQFANzBPr5Fmwu5MrlIt78IabSA==
X-Google-Smtp-Source: ABdhPJzPaX9Qyit+Cnc/LXLXynJ+PNAQ9hKD8yvljfj9TDt7PNv60nZwXm2IjLWbN2RMjhNtFrJcLA==
X-Received: by 2002:a5d:4486:: with SMTP id j6mr49650564wrq.278.1600685785928;
        Mon, 21 Sep 2020 03:56:25 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:25 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 15/16] net: bridge: mcast: handle host state
Date:   Mon, 21 Sep 2020 13:55:25 +0300
Message-Id: <20200921105526.1056983-16-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Since host joins are considered as EXCLUDE {} joins we need to reflect
that in all of *,G ports' S,G entries. Since the S,Gs can have
host_joined == true only set automatically we can safely set it to false
when removing all automatically added entries upon S,G delete.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 58 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 11d224c01914..66eb62ded192 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -286,6 +286,53 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 	}
 }
 
+/* called when adding a new S,G with host_joined == false by default */
+static void br_multicast_sg_host_state(struct net_bridge_mdb_entry *star_mp,
+				       struct net_bridge_port_group *sg)
+{
+	struct net_bridge_mdb_entry *sg_mp;
+
+	if (WARN_ON(!br_multicast_is_star_g(&star_mp->addr)))
+		return;
+	if (!star_mp->host_joined)
+		return;
+
+	sg_mp = br_mdb_ip_get(star_mp->br, &sg->key.addr);
+	if (!sg_mp)
+		return;
+	sg_mp->host_joined = true;
+}
+
+/* set the host_joined state of all of *,G's S,G entries */
+static void br_multicast_star_g_host_state(struct net_bridge_mdb_entry *star_mp)
+{
+	struct net_bridge *br = star_mp->br;
+	struct net_bridge_mdb_entry *sg_mp;
+	struct net_bridge_port_group *pg;
+	struct br_ip sg_ip;
+
+	if (WARN_ON(!br_multicast_is_star_g(&star_mp->addr)))
+		return;
+
+	memset(&sg_ip, 0, sizeof(sg_ip));
+	sg_ip = star_mp->addr;
+	for (pg = mlock_dereference(star_mp->ports, br);
+	     pg;
+	     pg = mlock_dereference(pg->next, br)) {
+		struct net_bridge_group_src *src_ent;
+
+		hlist_for_each_entry(src_ent, &pg->src_list, node) {
+			if (!(src_ent->flags & BR_SGRP_F_INSTALLED))
+				continue;
+			sg_ip.src = src_ent->addr.src;
+			sg_mp = br_mdb_ip_get(br, &sg_ip);
+			if (!sg_mp)
+				continue;
+			sg_mp->host_joined = star_mp->host_joined;
+		}
+	}
+}
+
 static void br_multicast_sg_del_exclude_ports(struct net_bridge_mdb_entry *sgmp)
 {
 	struct net_bridge_port_group __rcu **pp;
@@ -305,6 +352,12 @@ static void br_multicast_sg_del_exclude_ports(struct net_bridge_mdb_entry *sgmp)
 				  MDB_PG_FLAGS_PERMANENT)))
 			return;
 
+	/* currently the host can only have joined the *,G which means
+	 * we treat it as EXCLUDE {}, so for an S,G it's considered a
+	 * STAR_EXCLUDE entry and we can safely leave it
+	 */
+	sgmp->host_joined = false;
+
 	for (pp = &sgmp->ports;
 	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;) {
 		if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
@@ -326,6 +379,7 @@ void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
 	if (WARN_ON(!br_multicast_is_star_g(&star_mp->addr)))
 		return;
 
+	br_multicast_sg_host_state(star_mp, sg);
 	memset(&sg_key, 0, sizeof(sg_key));
 	sg_key.addr = sg->key.addr;
 	/* we need to add all exclude ports to the S,G */
@@ -1143,6 +1197,8 @@ void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
 {
 	if (!mp->host_joined) {
 		mp->host_joined = true;
+		if (br_multicast_is_star_g(&mp->addr))
+			br_multicast_star_g_host_state(mp);
 		if (notify)
 			br_mdb_notify(mp->br->dev, mp, NULL, RTM_NEWMDB);
 	}
@@ -1155,6 +1211,8 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 		return;
 
 	mp->host_joined = false;
+	if (br_multicast_is_star_g(&mp->addr))
+		br_multicast_star_g_host_state(mp);
 	if (notify)
 		br_mdb_notify(mp->br->dev, mp, NULL, RTM_DELMDB);
 }
-- 
2.25.4

