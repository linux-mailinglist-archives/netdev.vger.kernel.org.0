Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD353B5398
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhF0OMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbhF0OMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:48 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6174DC061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:23 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n2so13315888eju.11
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l0CZNtkfeJQejItwC7vZvOlnWOoK6FFD+nSdpk8okW4=;
        b=PPX+spCA6HXV1hEvD9R7EHKAqNQJIi5Si9y7yuOmlE2W0Ww/eW7RiPPzPVG5Dh7lP+
         EjlgWfwc16bzBBaw5TWzMsftuwKYDKFD6RfLmJ2+uGbZwSIED2hj8jWe3+3mYcsd8gT5
         3uyFjd1B7TS0oH20d17JLpK8nyNyhLO0RsTOssPUpZQs7lD5p5h6+bufWRjt/X/D53LG
         Ct7/4pFnvlVYGJldS31O55oLOzlQwYv9/b7mu2Wx6LEbU0zGged6+t2AuMjgQQBI+6L/
         6baS2gCYce1NJK9vsYdxnlHCZwAJyUT45XjLcVCMHdNev+p8fAFPSxAM3dwYV0t+YrG3
         I3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l0CZNtkfeJQejItwC7vZvOlnWOoK6FFD+nSdpk8okW4=;
        b=C3+U4oi4dVxa9Nqxt2hRV9OI57NN7ypSC4MD5RY8fR2H5Z4vSTRHbddpuGgs1aGrZg
         JjfO0p3L3ArSylN8e1Ly/YKiyKKtaKSg7q1GTc6unOB7GR+13WXgyDyTp6/CWCAj/OFG
         pCg9NhrPuKbQ2wc2IZ2kyF5I8oOQnEVO+ajEoqsAnO/212JHwMC/GDj/EzsbGeftmENu
         IL8tSqVkY7/mwAhXWEQsCa2yqQ+oxPPL2F/z0q48Z4Hzx99Z13C4IOovLQ/GbaCMgu5n
         cM5LwjkvUBNul70xtLkruLkJNsBp1lGCGNxf5GL3aH1Wy6n1SxgycQhanyCVrjnqivvz
         PDog==
X-Gm-Message-State: AOAM530BBg+lH0EPJmNm5J0th2omg38C5KktskfDkownGFAAKQL1baHC
        3/IPYWBVPzJkP9yqbTVqXUlzPqp9rhE=
X-Google-Smtp-Source: ABdhPJxvdXetFNaBFYKseI6DPWaVaTDoFgJmIbjzk8ejCbaFlIuFkpMlidGgpoKUMvAovdQCU8SXXA==
X-Received: by 2002:a17:907:3e9a:: with SMTP id hs26mr20170090ejc.531.1624803021857;
        Sun, 27 Jun 2021 07:10:21 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 01/15] net: bridge: switchdev: send FDB notifications for host addresses
Date:   Sun, 27 Jun 2021 17:09:59 +0300
Message-Id: <20210627141013.1273942-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
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
index 16f9434fdb5d..0296d737a519 100644
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
@@ -794,7 +794,7 @@ static void fdb_notify(struct net_bridge *br,
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

