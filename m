Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DC03B73D7
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhF2OJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhF2OJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:09:48 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1135C061767
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w13so25517171edc.0
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ndKg9ATVhqHRP+XyLBlEyLJKFXx1AU9l2lVP0bNXvFQ=;
        b=T7n2R3SDebIL8wwmeQq/l7XV31GhrJDyf2OAecvjBBlXBraKEaF8Eber9ZPUj0EYX2
         3QsQ73t9igXn/kgo2wKch1e0btUFWW4OGYf5tVcbANb6wSzEwUy/ud39akPkr6TXF1i3
         sSU181xplZDi2cmMznzDxAZtahtQ+sqlx4Yqb+Hi5vRgF8a05domsd/3Qfc7kXzKb5UY
         iDSjHEooE9CCChrI5Xmc9+n54qPhsmGfJxUeJGyQVY+b3oejgeY5/zsh5FEPfz+MjIme
         MCrDBO9sIGKIdbtkQaHRlIbdmDpu8hWksDWfxe1HU7uHxdRyQIAkG69lUKGP2gGljcUK
         Veiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ndKg9ATVhqHRP+XyLBlEyLJKFXx1AU9l2lVP0bNXvFQ=;
        b=FSaSrc1pZcnU+SdVlLu3Epx7Doq6ClPAuPehQky1C7z9aA4obiksUfj3idR55nJjVE
         G1SCzUuJEImFvJKwF7ds9TPmPYdWb56B27yXJwT989lZuGJ5FuD4hMUooOWYlxBnL4x6
         bs2qd1JM5tYMheoYr/3w9/pqjKfVzB6u2KylQXfPskL6APe3pbtCKqlRN3zPQaJBVgVc
         kF/trGsKVKqQ+pVAg7mcii6zYyYYbpIlJI6qTEOJzvPzZh4lv6KS7m0UfEieOJ/AOtVH
         Iu+aa8OnPiGh7UgXKcaJKYxGa1+DbdfWHc0sbz66HkcozhpOMEVyAk/J4gsN8Zu45mMA
         +/HQ==
X-Gm-Message-State: AOAM533ei4hz9ns6JGEpHwI2sSc/42kRulyPr1eCj0T9tzQGoLU8KB5X
        S83InhqnWwqg4+Ru9a2tia1eijEvC0s=
X-Google-Smtp-Source: ABdhPJytiVx7aS3o/J0Y3yKetuikkmEATfbsyURMxQ2p9rb9XPl15VkF7kT7IBGnMFoPJQDgDDmMwA==
X-Received: by 2002:a05:6402:849:: with SMTP id b9mr32450071edz.270.1624975638213;
        Tue, 29 Jun 2021 07:07:18 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 02/15] net: bridge: switchdev: send FDB notifications for host addresses
Date:   Tue, 29 Jun 2021 17:06:45 +0300
Message-Id: <20210629140658.2510288-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
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
v4->v5: rebased on top of the READ_ONCE change

 net/bridge/br_fdb.c       |  4 ++--
 net/bridge/br_private.h   |  7 ++++---
 net/bridge/br_switchdev.c | 11 +++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index dc3ecf2d5637..bad7e84d76af 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -607,7 +607,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != READ_ONCE(fdb->dst) &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
-				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
+				br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH);
 				WRITE_ONCE(fdb->dst, source);
 				fdb_modified = true;
 				/* Take over HW learned entry */
@@ -800,7 +800,7 @@ static void fdb_notify(struct net_bridge *br,
 	int err = -ENOBUFS;
 
 	if (swdev_notify)
-		br_switchdev_fdb_notify(fdb, type);
+		br_switchdev_fdb_notify(br, fdb, type);
 
 	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a684d0cfc58c..2b48b204205e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1654,8 +1654,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
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
@@ -1702,7 +1702,8 @@ static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 }
 
 static inline void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 }
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 192293fe37fd..d3adee0f91f9 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -108,9 +108,11 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 }
 
 void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 	const struct net_bridge_port *dst = READ_ONCE(fdb->dst);
+	struct net_device *dev = dst ? dst->dev : br->dev;
 	struct switchdev_notifier_fdb_info info = {
 		.addr = fdb->key.addr.addr,
 		.vid = fdb->key.vlan_id,
@@ -119,17 +121,14 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
 
-	if (!dst)
-		return;
-
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 dst->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 dst->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.25.1

