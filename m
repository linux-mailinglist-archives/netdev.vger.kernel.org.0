Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166523D106B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhGUNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbhGUNWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:22:02 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24943C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:02:39 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l26so2515852eda.10
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=izEfJ/KGkE+i5p7nm0OMKr/U+Dh/Kvr88MAgLxOg9FI=;
        b=xe3rsvbtLytiTTGZU+f9ptfPJvujq5qBa9eHBlu8RnNzOhrv6LpJ+LuLusZOBJ3H8E
         G/+JOU2AMfIs5vrP+1U/K+xkwl0d/be28C0HlY50bFS1Zyi5nxMl/6aTXs7189uajGc1
         qxOvZ0HjS9CKOpS+HJ3WFp16WKC/VdwXMC25t5ryBkExWtdwHFuMSdh2hjRGd5DDH+QS
         uT2zSDH9jn1v+94Ey8mYcbZrmHUL894KkI31z3zc/Hz7rgtQrQJ8M1vHp2mDo90/io6+
         uS2pP+zmKF688OXxNwxrk14nWaUCHteJXh4Ikh2HmtR6qmQGT5CpsuDME2GLB61TmJk/
         Wzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=izEfJ/KGkE+i5p7nm0OMKr/U+Dh/Kvr88MAgLxOg9FI=;
        b=AnPnTzHmXDp8WYSxUqIPFidiUPuyL+KtS5OklzO96D002utlVkcdY91M2NubsBWKw7
         f31eV3+VGKvvlxSRaghzwmFnHiWT35KCIBJNBRQWVP70vJusQq5X2ByJjHu3fwc+LwFN
         rMXvPM1PyHedDrOfxLfiY2wYK8qb5GXsDGvMsHvKLueF+8le+SVBajIJhMlZhUQJ37E5
         y7u5gry4Uibp6oET+adisAg/qtHFS/TNJeEgunrFAPXjf/QTNTY096n6ySawxlZ6yqU2
         PflGg7UpSepAEFeGm/k2Fy3HYryk2K+GEusZJBUUyj7GL0OKGbRtHTT2QpZEa15AE9SY
         Xv1g==
X-Gm-Message-State: AOAM531dltCurCZjTqmlljyGRbyzWTflitTh+VV6aafBxlEc7jXFUin1
        0i/dHUcw301mqfwb4mT+OeGf1XMCpCgIYyGYCrM=
X-Google-Smtp-Source: ABdhPJwFhGeRUEfQv75I6+/MDh6l6tgzt7VyVPRYzSIBm5Ne/qzvmELY+lf1hTr57KH4WX1szZiibQ==
X-Received: by 2002:aa7:c5c3:: with SMTP id h3mr48901673eds.376.1626876157506;
        Wed, 21 Jul 2021 07:02:37 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm8362925ejc.61.2021.07.21.07.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 07:02:37 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/2] net: bridge: multicast: add mdb context support
Date:   Wed, 21 Jul 2021 17:01:26 +0300
Message-Id: <20210721140127.773194-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721140127.773194-1-razor@blackwall.org>
References: <20210721140127.773194-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Choose the proper bridge multicast context when user-spaces is adding
mdb entries. Currently we require the vlan to be configured on at least
one device (port or bridge) in order to add an mdb entry if vlan
mcast snooping is enabled (vlan snooping implies vlan filtering).
Note that we always allow deleting an entry, regardless of the vlan state.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index d3383a47a2f2..7b6c3b91d272 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1019,14 +1019,47 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return 0;
 }
 
+static struct net_bridge_mcast *
+__br_mdb_choose_context(struct net_bridge *br,
+			const struct br_mdb_entry *entry,
+			struct netlink_ext_ack *extack)
+{
+	struct net_bridge_mcast *brmctx = NULL;
+	struct net_bridge_vlan *v;
+
+	if (!br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED)) {
+		brmctx = &br->multicast_ctx;
+		goto out;
+	}
+
+	if (!entry->vid) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot add an entry without a vlan when vlan snooping is enabled");
+		goto out;
+	}
+
+	v = br_vlan_find(br_vlan_group(br), entry->vid);
+	if (!v) {
+		NL_SET_ERR_MSG_MOD(extack, "Vlan is not configured");
+		goto out;
+	}
+	if (br_multicast_ctx_vlan_global_disabled(&v->br_mcast_ctx)) {
+		NL_SET_ERR_MSG_MOD(extack, "Vlan's multicast processing is disabled");
+		goto out;
+	}
+	brmctx = &v->br_mcast_ctx;
+out:
+	return brmctx;
+}
+
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			    struct br_mdb_entry *entry,
 			    struct nlattr **mdb_attrs,
 			    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp, *star_mp;
-	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+	struct net_bridge_mcast *brmctx;
 	struct br_ip group, star_group;
 	unsigned long now = jiffies;
 	unsigned char flags = 0;
@@ -1035,6 +1068,10 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 
 	__mdb_entry_to_br_ip(entry, &group, mdb_attrs);
 
+	brmctx = __br_mdb_choose_context(br, entry, extack);
+	if (!brmctx)
+		return -EINVAL;
+
 	/* host join errors which can happen before creating the group */
 	if (!port) {
 		/* don't allow any flags for host-joined groups */
@@ -1100,14 +1137,14 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	rcu_assign_pointer(*pp, p);
 	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer,
-			  now + br->multicast_ctx.multicast_membership_interval);
+			  now + brmctx->multicast_membership_interval);
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
 	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
 	 * added to all S,G entries for proper replication, if we are adding
 	 * a new INCLUDE port (S,G) then all of *,G EXCLUDE ports need to be
 	 * added to it for proper replication
 	 */
-	if (br_multicast_should_handle_mode(&br->multicast_ctx, group.proto)) {
+	if (br_multicast_should_handle_mode(brmctx, group.proto)) {
 		switch (filter_mode) {
 		case MCAST_EXCLUDE:
 			br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
-- 
2.31.1

