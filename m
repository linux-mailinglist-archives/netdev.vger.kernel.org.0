Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41AD323B70
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhBXLrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235010AbhBXLp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:28 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F91EC0617A9
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:12 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j9so2111121edp.1
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rdXrHF3RIlZtNN200L/dGI+RQwRa1qmw0c6RA8LNzA8=;
        b=d6rDMWZ2DGT8dwOrfmdIRj8aHw5c8EDLfBvC/BFWErLThrNaa44qMLwzb0hfOh2AJg
         fqZDd+Bn77M5aXvypKD/rcn4dcy0hVfq7jpR7RejQj60Ex0/NEv6vw5nGbr+SduCoj/2
         L9b3wmtnPo2RHR09G3jAHZ5NNM+DUwp2fCM4KADVA5gjuK3DV6wUf+rU0LKaPGu7YTHO
         zBxdxuNsMAnVYCae+STLtztKtu31t43bvHsArcq71DXIRt1ha+XXexlDyhjtQN6/b/L1
         7T5Bzk1fBvCmxfnOqI8o0OOk8QxmlUYsQ3nRwM8iU5XWAqvkFI7EZ50T82mYzjECdWW5
         Jyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rdXrHF3RIlZtNN200L/dGI+RQwRa1qmw0c6RA8LNzA8=;
        b=NtqlPpmu8VWkNu6I9eAiz6j+a2EUuNnRescTrr76eNkk9j33tNlcp7hi5rpEwXPKy8
         aLWpzkTbkQyh+SBi7wcf6xiXKeQODrBE+u0rsaT6stGyBkhpz+H8reyIQ30wiv6C6pN3
         6A4yQGmqI9OwpqaIvLWtIKFQ7wlk3nxyHUfnQSwkHfZyT8sBAZU0W3uvzNysON9hrYOE
         xOQcuAjP87Iaro4To+Sh3Mwceiqp/VhRyFNT7+h2esiSeKzGfkXzQtHp5ABSOBE3CmuB
         RTruwolvrKjXSOKWtnSrAk/Vt9Cia6h1LSli1iuNsSQW50jvl8hSsz9bn+YGeA1NuGbl
         VeWg==
X-Gm-Message-State: AOAM533dX+lq2HlsEwY427fVu2b/UMoHj1nEV5o1bsdKINUj8+pXP0lb
        MtMvG28gLHBLBd/C7VUhdVPMH8tX0HQ=
X-Google-Smtp-Source: ABdhPJw0W02an/0vVWIhl/MikZUw4lX60Ta12Sc4yqG3D2Bc7izcAU+/RoeGaXrNqQFhHjko09Kd8w==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr33971761edc.102.1614167051134;
        Wed, 24 Feb 2021 03:44:11 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 09/17] net: bridge: switchdev: send FDB notifications for host addresses
Date:   Wed, 24 Feb 2021 13:43:42 +0200
Message-Id: <20210224114350.2791260-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Treat addresses added to the bridge itself in the same way as regular
ports and send out a notification so that drivers may sync it down to
the hardware FDB.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       |  4 ++--
 net/bridge/br_private.h   |  7 ++++---
 net/bridge/br_switchdev.c | 11 +++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b7490237f3fc..1d54ae0f58fb 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -602,7 +602,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != fdb->dst &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
-				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
+				br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH);
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
@@ -735,7 +735,7 @@ static void fdb_notify(struct net_bridge *br,
 	int err = -ENOBUFS;
 
 	if (swdev_notify)
-		br_switchdev_fdb_notify(fdb, type);
+		br_switchdev_fdb_notify(br, fdb, type);
 
 	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d7d167e10b70..4a262dc55e6b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1581,8 +1581,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
 			       unsigned long mask,
 			       struct netlink_ext_ack *extack);
-void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
-			     int type);
+void br_switchdev_fdb_notify(struct net_bridge *br,
+			     const struct net_bridge_fdb_entry *fdb, int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
@@ -1629,7 +1629,8 @@ static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 }
 
 static inline void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 }
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a5e601e41cb9..9a707da79dfe 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -108,7 +108,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 }
 
 void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 	struct switchdev_notifier_fdb_info info = {
 		.addr = fdb->key.addr.addr,
@@ -117,18 +118,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
-
-	if (!fdb->dst)
-		return;
+	struct net_device *dev = fdb->dst ? fdb->dst->dev : br->dev;
 
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 fdb->dst->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 fdb->dst->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.25.1

