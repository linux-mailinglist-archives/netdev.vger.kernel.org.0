Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B2B3B5333
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhF0L5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhF0L5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A10C061767
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id t3so20878786edc.7
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PhxhHzM+Gx5kDzn3PDcqP7KW1UZmwEUFvtjkuz9RLTg=;
        b=vacwk4a6kyY8Rx0x4UB2qyzjxxBkjHKmup/Ahc0qj73Va39gfR6mud5nGjIV3HCL78
         S7mi53qTbPJxx1wExRQNq5YT8BCElNZM2+Na0q6OSGh3DNHfP9A0HxQyZfx0tce14Xcl
         BnObNoGDHvHWEoxJXiD+rgNtBLT1So+bwm6EvUaBl6ynMcOyvCjUCD5DekawiX5qUlNf
         hC3odz0phVr0CO3zUZMyQ29oN5ObBVqkoYsAyFZpQXdzu3rxVBgm83TJlTh3Hey7xcZ4
         staSBAHjYjos0+2dbt9YMJMqG6AKjlu72GuuPHzEbiePpuUjNGY4B4R4ylhhYoAqxDlD
         bwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PhxhHzM+Gx5kDzn3PDcqP7KW1UZmwEUFvtjkuz9RLTg=;
        b=obFHkv97gtuF2vDE6JWYHdJm+o+eTGtCiCAWXTJhIVA38InbcUHRJD8djfd03cBO/9
         xVjqHQ7qL0FldBmVV8gp6NE9nYzFgOs6mYWtxa/4+ngUiweEj9+HdZCRY3fxHXPl/Olh
         NfB4LhEuzVIPbLTKmwyCuZ/1yU66glpy6KZZpk8oOxs5KQltpRN0EgmAhTiA3ee3tBJ3
         1CdaWxlPwOskJ/5oVTvEaWn2CpC25BTBEDHxfzK9xxm/ysYpKFq0LIFIa6Wnz5M6q7nB
         Y1NUCEHJAQPlvWefvsOrBji+Omc3wpQ7zBERT00G/ZozdteWYDncJmP/AuZ2vW6oPkrC
         xa7w==
X-Gm-Message-State: AOAM531iEWiWSGgTUA3865FT++Bv+lFP01LtJD7CHisG4saHvXjQ9hSy
        H1Iq6NZK3V8GIbzg3SUsKnI=
X-Google-Smtp-Source: ABdhPJwlCXcryeLfRSFpopvvmWYHty4jkKSZPoytm5ofSGMUXCKABf8SvezT6yKQ4vs3i0CyiE9MyQ==
X-Received: by 2002:aa7:de90:: with SMTP id j16mr26804400edv.385.1624794880671;
        Sun, 27 Jun 2021 04:54:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 4/8] net: bridge: ignore switchdev events for LAG ports which didn't request replay
Date:   Sun, 27 Jun 2021 14:54:25 +0300
Message-Id: <20210627115429.1084203-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a slight inconvenience in the switchdev replay helpers added
recently, and this is when:

ip link add br0 type bridge
ip link add bond0 type bond
ip link set bond0 master br0
bridge vlan add dev bond0 vid 100
ip link set swp0 master bond0
ip link set swp1 master bond0

Since the underlying driver (currently only DSA) asks for a replay of
VLANs when swp0 and swp1 join the LAG because it is bridged, what will
happen is that DSA will try to react twice on the VLAN event for swp0.
This is not really a huge problem right now, because most drivers accept
duplicates since the bridge itself does, but it will become a problem
when we add support for replaying switchdev object deletions.

Let's fix this by adding a blank void *ctx in the replay helpers, which
will be passed on by the bridge in the switchdev notifications. If the
context is NULL, everything is the same as before. But if the context is
populated with a valid pointer, the underlying switchdev driver
(currently DSA) can use the pointer to 'see through' the bridge port
(which in the example above is bond0) and 'know' that the event is only
for a particular physical port offloading that bridge port, and not for
all of them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: s/void *ctx/const void *ctx/ in include/linux/if_bridge.h

 drivers/net/ethernet/mscc/ocelot_net.c | 19 +++++++++++++++++--
 include/linux/if_bridge.h              | 14 ++++++++------
 net/bridge/br_fdb.c                    |  7 ++++---
 net/bridge/br_mdb.c                    |  8 +++++---
 net/bridge/br_vlan.c                   |  8 +++++---
 net/dsa/port.c                         |  6 +++---
 net/dsa/slave.c                        |  9 +++++++++
 7 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 456541640feb..166d851962d2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -948,6 +948,9 @@ static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 	int port = priv->chip_port;
 	int err = 0;
 
+	if (ctx && ctx != priv)
+		return 0;
+
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		ocelot_port_attr_stp_state_set(ocelot, port, attr->u.stp_state);
@@ -1062,8 +1065,12 @@ static int ocelot_port_obj_add(struct net_device *dev, const void *ctx,
 			       const struct switchdev_obj *obj,
 			       struct netlink_ext_ack *extack)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
 	int ret = 0;
 
+	if (ctx && ctx != priv)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		ret = ocelot_port_obj_add_vlan(dev,
@@ -1089,8 +1096,12 @@ static int ocelot_port_obj_add(struct net_device *dev, const void *ctx,
 static int ocelot_port_obj_del(struct net_device *dev, const void *ctx,
 			       const struct switchdev_obj *obj)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
 	int ret = 0;
 
+	if (ctx && ctx != priv)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		ret = ocelot_vlan_vid_del(dev,
@@ -1143,10 +1154,14 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 				 struct net_device *bridge_dev,
 				 struct netlink_ext_ack *extack)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port_private *priv;
 	clock_t ageing_time;
 	u8 stp_state;
 	int err;
 
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+
 	ocelot_inherit_brport_flags(ocelot, port, brport_dev);
 
 	stp_state = br_port_get_stp_state(brport_dev);
@@ -1160,12 +1175,12 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	ageing_time = br_get_ageing_time(bridge_dev);
 	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
 
-	err = br_mdb_replay(bridge_dev, brport_dev,
+	err = br_mdb_replay(bridge_dev, brport_dev, priv,
 			    &ocelot_switchdev_blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(bridge_dev, brport_dev,
+	err = br_vlan_replay(bridge_dev, brport_dev, priv,
 			     &ocelot_switchdev_blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 12e9a32dbca0..57df761b6f4a 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -71,7 +71,8 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  struct notifier_block *nb, struct netlink_ext_ack *extack);
+		  const void *ctx, struct notifier_block *nb,
+		  struct netlink_ext_ack *extack);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
 					     struct list_head *br_ip_list)
@@ -104,7 +105,7 @@ static inline bool br_multicast_router(const struct net_device *dev)
 	return false;
 }
 static inline int br_mdb_replay(struct net_device *br_dev,
-				struct net_device *dev,
+				struct net_device *dev, const void *ctx,
 				struct notifier_block *nb,
 				struct netlink_ext_ack *extack)
 {
@@ -120,7 +121,8 @@ int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   struct notifier_block *nb, struct netlink_ext_ack *extack);
+		   const void *ctx, struct notifier_block *nb,
+		   struct netlink_ext_ack *extack);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -149,7 +151,7 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 }
 
 static inline int br_vlan_replay(struct net_device *br_dev,
-				 struct net_device *dev,
+				 struct net_device *dev, const void *ctx,
 				 struct notifier_block *nb,
 				 struct netlink_ext_ack *extack)
 {
@@ -166,7 +168,7 @@ bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(struct net_device *br_dev);
 int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  struct notifier_block *nb);
+		  const void *ctx, struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -197,7 +199,7 @@ static inline clock_t br_get_ageing_time(struct net_device *br_dev)
 }
 
 static inline int br_fdb_replay(struct net_device *br_dev,
-				struct net_device *dev,
+				struct net_device *dev, const void *ctx,
 				struct notifier_block *nb)
 {
 	return -EOPNOTSUPP;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b8d3ddfe5853..9d164a518e38 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -728,7 +728,7 @@ static inline size_t fdb_nlmsg_size(void)
 
 static int br_fdb_replay_one(struct notifier_block *nb,
 			     struct net_bridge_fdb_entry *fdb,
-			     struct net_device *dev)
+			     struct net_device *dev, const void *ctx)
 {
 	struct switchdev_notifier_fdb_info item;
 	int err;
@@ -739,13 +739,14 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
 	item.info.dev = dev;
+	item.info.ctx = ctx;
 
 	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
 	return notifier_to_errno(err);
 }
 
 int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  struct notifier_block *nb)
+		  const void *ctx, struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
@@ -766,7 +767,7 @@ int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
 		if (dst_dev != br_dev && dst_dev != dev)
 			continue;
 
-		err = br_fdb_replay_one(nb, fdb, dst_dev);
+		err = br_fdb_replay_one(nb, fdb, dst_dev, ctx);
 		if (err)
 			break;
 	}
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 3f839a8cc9fb..8bc6afca5e8c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -568,12 +568,13 @@ static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
 
 static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
 			     struct switchdev_obj_port_mdb *mdb,
-			     struct netlink_ext_ack *extack)
+			     const void *ctx, struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.info = {
 			.dev = dev,
 			.extack = extack,
+			.ctx = ctx,
 		},
 		.obj = &mdb->obj,
 	};
@@ -603,7 +604,8 @@ static int br_mdb_queue_one(struct list_head *mdb_list,
 }
 
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  struct notifier_block *nb, struct netlink_ext_ack *extack)
+		  const void *ctx, struct notifier_block *nb,
+		  struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct switchdev_obj *obj, *tmp;
@@ -664,7 +666,7 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 
 	list_for_each_entry(obj, &mdb_list, list) {
 		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					extack);
+					ctx, extack);
 		if (err)
 			goto out_free_mdb;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8789a57af543..2bfa2a00e193 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1807,12 +1807,13 @@ void br_vlan_notify(const struct net_bridge *br,
 static int br_vlan_replay_one(struct notifier_block *nb,
 			      struct net_device *dev,
 			      struct switchdev_obj_port_vlan *vlan,
-			      struct netlink_ext_ack *extack)
+			      const void *ctx, struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.info = {
 			.dev = dev,
 			.extack = extack,
+			.ctx = ctx,
 		},
 		.obj = &vlan->obj,
 	};
@@ -1823,7 +1824,8 @@ static int br_vlan_replay_one(struct notifier_block *nb,
 }
 
 int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   struct notifier_block *nb, struct netlink_ext_ack *extack)
+		   const void *ctx, struct notifier_block *nb,
+		   struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
@@ -1868,7 +1870,7 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 		if (!br_vlan_should_use(v))
 			continue;
 
-		err = br_vlan_replay_one(nb, dev, &vlan, extack);
+		err = br_vlan_replay_one(nb, dev, &vlan, ctx, extack);
 		if (err)
 			return err;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 5c93f1e1a03d..339781c98de1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -194,17 +194,17 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_mdb_replay(br, brport_dev,
+	err = br_mdb_replay(br, brport_dev, dp,
 			    &dsa_slave_switchdev_blocking_notifier,
 			    extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(br, brport_dev, &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, brport_dev, dp, &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(br, brport_dev,
+	err = br_vlan_replay(br, brport_dev, dp,
 			     &dsa_slave_switchdev_blocking_notifier,
 			     extack);
 	if (err && err != -EOPNOTSUPP)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3692259a025f..2f0d0a6b1f9c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -278,6 +278,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
+	if (ctx && ctx != dp)
+		return 0;
+
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
@@ -401,6 +404,9 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (ctx && ctx != dp)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
@@ -475,6 +481,9 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
+	if (ctx && ctx != dp)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-- 
2.25.1

