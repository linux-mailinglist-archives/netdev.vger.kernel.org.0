Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E783B5334
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhF0L5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhF0L5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717FDC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id m14so20899114edp.9
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m0/bMS0fJ7wroFXD2kogO0ldLmgCesjwH+I/u3a9J0s=;
        b=BMcIeDk5tmxHupiS1K5frhzhoUKX9zIK3nBBha1mKGH/t0WeSr36wS+YKSO50auncU
         EbRkXvAjP3Q+SWyrB4H1I4oXI1llHVScTyjG6JRuwZkn3CPyxf+vxerAcjFEIACjF+t0
         zTUukFCuZeKyMLPkpCrEhudFn6tLDG5qaCjKWeu/OZ4gTlWE+j2FJi827dju/iCA88mK
         0ZgpJyn+rkkZaxjyoE2z0YX8Dxb2v5R8sBSWqPKMWsRUJnnoYbKQgjcjLer4IR9vutVn
         DdpbGiFChIFu7fLTfQlRkD3eQv8O4rYCHZlO03roLB+uhJBRcjgnxKF9/N2LIOdX7LH5
         UNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m0/bMS0fJ7wroFXD2kogO0ldLmgCesjwH+I/u3a9J0s=;
        b=OkhRZIMzOcdrPbJiEGOaAtrzD8+P+cNURqjQPVDPI2aKxCcdEhbyqMkPU5IyIpPoJY
         DDvMdcj2QlqynOuFUyO6pNpPLtan6l2xPflQ3Jn/8cnmkjwOq/2sDNkByCX1AsldZihp
         bH2On1VHspdG9V1ibEaV+2TcqMyxArxUAPEIWTVg6wyuZskTrRaDx4kwOUAa6Hqpy2bS
         dVPvgj1C5DaEz/jItIO/sKNm3Ok3JiaFDWmarTnI1+IEz3I/0617bGzK3m/s+4kBkgNI
         adOCNHJQjJ8wXkfCE7IOBzgonSsFjoRIVbCS1LzDxS1GiiSCNB8mvTOVklBIiVQu2P+e
         rs1A==
X-Gm-Message-State: AOAM532DDeMq7ceXhNyox0cuAgnLhSYt7T/rM2vG+3sfmrsvzOyQZ79O
        bjHNIsDpsXh3X+IaTnhHyp8=
X-Google-Smtp-Source: ABdhPJzjcZbFrGyGNefW0QtZzBYmHrIr1eJ3r9Zn1Tgys953sA5950kGoM84NTCqnEX1IkQin8SD1g==
X-Received: by 2002:a05:6402:430d:: with SMTP id m13mr27061528edc.283.1624794882973;
        Sun, 27 Jun 2021 04:54:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:42 -0700 (PDT)
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
Subject: [PATCH v2 net-next 6/8] net: bridge: allow the switchdev replay functions to be called for deletion
Date:   Sun, 27 Jun 2021 14:54:27 +0300
Message-Id: <20210627115429.1084203-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When a switchdev port leaves a LAG that is a bridge port, the switchdev
objects and port attributes offloaded to that port are not removed:

ip link add br0 type bridge
ip link add bond0 type bond mode 802.3ad
ip link set swp0 master bond0
ip link set bond0 master br0
bridge vlan add dev bond0 vid 100
ip link set swp0 nomaster

VLAN 100 will remain installed on swp0 despite it going into standalone
mode, because as far as the bridge is concerned, nothing ever happened
to its bridge port.

Let's extend the bridge vlan, fdb and mdb replay functions to take a
'bool adding' argument, and make DSA and ocelot call the replay
functions with 'adding' as false from the switchdev unsync path, for the
switch port that leaves the bridge.

Note that this patch in itself does not salvage anything, because in the
current pull mode of operation, DSA still needs to call the replay
helpers with adding=false. This will be done in another patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c |  4 ++--
 include/linux/if_bridge.h              | 12 ++++++------
 net/bridge/br_fdb.c                    | 15 +++++++++++----
 net/bridge/br_mdb.c                    | 15 +++++++++++----
 net/bridge/br_vlan.c                   | 15 +++++++++++----
 net/dsa/port.c                         | 13 ++++++-------
 6 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 166d851962d2..3e89e34f86d5 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1175,12 +1175,12 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	ageing_time = br_get_ageing_time(bridge_dev);
 	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
 
-	err = br_mdb_replay(bridge_dev, brport_dev, priv,
+	err = br_mdb_replay(bridge_dev, brport_dev, priv, true,
 			    &ocelot_switchdev_blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(bridge_dev, brport_dev, priv,
+	err = br_vlan_replay(bridge_dev, brport_dev, priv, true,
 			     &ocelot_switchdev_blocking_nb, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 6b54da2c65ba..b651c5e32a28 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -71,7 +71,7 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, struct notifier_block *nb,
+		  const void *ctx, bool adding, struct notifier_block *nb,
 		  struct netlink_ext_ack *extack);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
@@ -106,7 +106,7 @@ static inline bool br_multicast_router(const struct net_device *dev)
 }
 static inline int br_mdb_replay(const struct net_device *br_dev,
 				const struct net_device *dev, const void *ctx,
-				struct notifier_block *nb,
+				bool adding, struct notifier_block *nb,
 				struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
@@ -121,7 +121,7 @@ int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
 int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, struct notifier_block *nb,
+		   const void *ctx, bool adding, struct notifier_block *nb,
 		   struct netlink_ext_ack *extack);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
@@ -152,7 +152,7 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
 
 static inline int br_vlan_replay(struct net_device *br_dev,
 				 struct net_device *dev, const void *ctx,
-				 struct notifier_block *nb,
+				 bool adding, struct notifier_block *nb,
 				 struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
@@ -168,7 +168,7 @@ bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
 int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, struct notifier_block *nb);
+		  const void *ctx, bool adding, struct notifier_block *nb);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -200,7 +200,7 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 
 static inline int br_fdb_replay(const struct net_device *br_dev,
 				const struct net_device *dev, const void *ctx,
-				struct notifier_block *nb)
+				bool adding, struct notifier_block *nb)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2e777c8b0921..16f9434fdb5d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -728,7 +728,8 @@ static inline size_t fdb_nlmsg_size(void)
 
 static int br_fdb_replay_one(struct notifier_block *nb,
 			     const struct net_bridge_fdb_entry *fdb,
-			     struct net_device *dev, const void *ctx)
+			     struct net_device *dev, unsigned long action,
+			     const void *ctx)
 {
 	struct switchdev_notifier_fdb_info item;
 	int err;
@@ -741,15 +742,16 @@ static int br_fdb_replay_one(struct notifier_block *nb,
 	item.info.dev = dev;
 	item.info.ctx = ctx;
 
-	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
+	err = nb->notifier_call(nb, action, &item);
 	return notifier_to_errno(err);
 }
 
 int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
-		  const void *ctx, struct notifier_block *nb)
+		  const void *ctx, bool adding, struct notifier_block *nb)
 {
 	struct net_bridge_fdb_entry *fdb;
 	struct net_bridge *br;
+	unsigned long action;
 	int err = 0;
 
 	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
@@ -757,6 +759,11 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 
 	br = netdev_priv(br_dev);
 
+	if (adding)
+		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
+	else
+		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
+
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
@@ -767,7 +774,7 @@ int br_fdb_replay(const struct net_device *br_dev, const struct net_device *dev,
 		if (dst_dev != br_dev && dst_dev != dev)
 			continue;
 
-		err = br_fdb_replay_one(nb, fdb, dst_dev, ctx);
+		err = br_fdb_replay_one(nb, fdb, dst_dev, action, ctx);
 		if (err)
 			break;
 	}
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index cebdbff17b54..17a720b4473f 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -568,7 +568,8 @@ static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
 
 static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
 			     const struct switchdev_obj_port_mdb *mdb,
-			     const void *ctx, struct netlink_ext_ack *extack)
+			     unsigned long action, const void *ctx,
+			     struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.info = {
@@ -580,7 +581,7 @@ static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
 	};
 	int err;
 
-	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
+	err = nb->notifier_call(nb, action, &obj_info);
 	return notifier_to_errno(err);
 }
 
@@ -604,12 +605,13 @@ static int br_mdb_queue_one(struct list_head *mdb_list,
 }
 
 int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, struct notifier_block *nb,
+		  const void *ctx, bool adding, struct notifier_block *nb,
 		  struct netlink_ext_ack *extack)
 {
 	const struct net_bridge_mdb_entry *mp;
 	struct switchdev_obj *obj, *tmp;
 	struct net_bridge *br;
+	unsigned long action;
 	LIST_HEAD(mdb_list);
 	int err = 0;
 
@@ -664,9 +666,14 @@ int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
 
 	rcu_read_unlock();
 
+	if (adding)
+		action = SWITCHDEV_PORT_OBJ_ADD;
+	else
+		action = SWITCHDEV_PORT_OBJ_DEL;
+
 	list_for_each_entry(obj, &mdb_list, list) {
 		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					ctx, extack);
+					action, ctx, extack);
 		if (err)
 			goto out_free_mdb;
 	}
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 2bfa2a00e193..a08e9f193009 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1807,7 +1807,8 @@ void br_vlan_notify(const struct net_bridge *br,
 static int br_vlan_replay_one(struct notifier_block *nb,
 			      struct net_device *dev,
 			      struct switchdev_obj_port_vlan *vlan,
-			      const void *ctx, struct netlink_ext_ack *extack)
+			      const void *ctx, unsigned long action,
+			      struct netlink_ext_ack *extack)
 {
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.info = {
@@ -1819,18 +1820,19 @@ static int br_vlan_replay_one(struct notifier_block *nb,
 	};
 	int err;
 
-	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
+	err = nb->notifier_call(nb, action, &obj_info);
 	return notifier_to_errno(err);
 }
 
 int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
-		   const void *ctx, struct notifier_block *nb,
+		   const void *ctx, bool adding, struct notifier_block *nb,
 		   struct netlink_ext_ack *extack)
 {
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
+	unsigned long action;
 	int err = 0;
 	u16 pvid;
 
@@ -1857,6 +1859,11 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 	if (!vg)
 		return 0;
 
+	if (adding)
+		action = SWITCHDEV_PORT_OBJ_ADD;
+	else
+		action = SWITCHDEV_PORT_OBJ_DEL;
+
 	pvid = br_get_pvid(vg);
 
 	list_for_each_entry(v, &vg->vlan_list, vlist) {
@@ -1870,7 +1877,7 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 		if (!br_vlan_should_use(v))
 			continue;
 
-		err = br_vlan_replay_one(nb, dev, &vlan, ctx, extack);
+		err = br_vlan_replay_one(nb, dev, &vlan, ctx, action, extack);
 		if (err)
 			return err;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 339781c98de1..4e58d07ececd 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -194,19 +194,18 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_mdb_replay(br, brport_dev, dp,
-			    &dsa_slave_switchdev_blocking_notifier,
-			    extack);
+	err = br_mdb_replay(br, brport_dev, dp, true,
+			    &dsa_slave_switchdev_blocking_notifier, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(br, brport_dev, dp, &dsa_slave_switchdev_notifier);
+	err = br_fdb_replay(br, brport_dev, dp, true,
+			    &dsa_slave_switchdev_notifier);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_vlan_replay(br, brport_dev, dp,
-			     &dsa_slave_switchdev_blocking_notifier,
-			     extack);
+	err = br_vlan_replay(br, brport_dev, dp, true,
+			     &dsa_slave_switchdev_blocking_notifier, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-- 
2.25.1

