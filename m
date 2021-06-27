Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47DA3B5332
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 13:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhF0L5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 07:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhF0L5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 07:57:06 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD89C061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:41 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i24so20894167edx.4
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 04:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8TkAsqOeKnMhY2yKN8Z193brKKb4tTAjtYMTNGSxg/w=;
        b=vcSG+wcMfVLbMYYdPAGbsmVbqs0otGO/xUShpYi9w58lA+HLJ2EdisQEXLxwiO8atJ
         z7r5aQuhFYBV42JkMxCTKYWALdw0acli/+BZsXYbsAMc07N6cS94SZGGevDSjhwZX0oo
         qKYFJKg61OFQEvCNH6wjo2Adxn5gbRxWgSAe95LuuP6ZNl8gHXj6eMfrrK+GXHhBJAd/
         CPS8+DlBj0DVSZkx6q14GRfV6nnEWIAQRg7CeUwLYkq8hrKHFu4a00FXn4P2DKQ/OseY
         8lEg6rJ5RyiWsmxfWNvK+De4GZtMXIGXohZhr9/yohHEvl8sxXWM3/yeDxBSwdIDDzmq
         wCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8TkAsqOeKnMhY2yKN8Z193brKKb4tTAjtYMTNGSxg/w=;
        b=ESue0NuTxHTAXVRj72A7GnWOk8TfRtwvrc9bFqnJdkYM9HXFhWZuuVRcnbQ0YJKekw
         XPurlIMtj7ocNZgaKRgXraFnk/CHOvwF8t9Ludhklxtt72HBXv4ZSyNssjLnBvO6UQpK
         bxIDdRk12gDvtvFd0f5qgGY/VPmvuBlGEY/u3Y+8zxREgsqTzUgsaO5SS24PVj9Gw+yy
         oBCE8Y/EubcgsyEVMuuA2RAFXLoozemIZ2LDf0x+EQhMhAkpn7fdaT9a1C22u3kgQYZO
         TvKMAe1DLbx6vRbqYELhgAmKG0sEwUHp7ox0Ggo1fJlB/mmruHz9TeZbk2KCT29h2/Bw
         T0qw==
X-Gm-Message-State: AOAM530ua/YyvFGDcQv3yJP6k4x09+30KWhRt1MfTr2ddBAGxmA2Gw9X
        okB/tAAu+dwSQiik4mJNcZc=
X-Google-Smtp-Source: ABdhPJyhcVBif4toFrrbZpc6Gsai7HcqzA1r1vqDT6zt1jZ462QW4mcdgpi58wbiwyFlJJyx383Q+Q==
X-Received: by 2002:a05:6402:1d2d:: with SMTP id dh13mr13874262edb.282.1624794879615;
        Sun, 27 Jun 2021 04:54:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7683688edu.49.2021.06.27.04.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 04:54:39 -0700 (PDT)
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
Subject: [PATCH v2 net-next 3/8] net: switchdev: add a context void pointer to struct switchdev_notifier_info
Date:   Sun, 27 Jun 2021 14:54:24 +0300
Message-Id: <20210627115429.1084203-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627115429.1084203-1-olteanv@gmail.com>
References: <20210627115429.1084203-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the case where the driver asks for a replay of a certain type of
event (port object or attribute) for a bridge port that is a LAG, it may
do so because this port has just joined the LAG.

But there might already be other switchdev ports in that LAG, and it is
preferable that those preexisting switchdev ports do not act upon the
replayed event.

The solution is to add a context to switchdev events, which is NULL most
of the time (when the bridge layer initiates the call) but which can be
set to a value controlled by the switchdev driver when a replay is
requested. The driver can then check the context to figure out if all
ports within the LAG should act upon the switchdev event, or just the
ones that match the context.

We have to modify all switchdev_handle_* helper functions as well as the
prototypes in the drivers that use these helpers too, because these
helpers hide the underlying struct switchdev_notifier_info from us and
there is no way to retrieve the context otherwise.

The context structure will be populated and used in later patches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 +-
 .../marvell/prestera/prestera_switchdev.c     |  6 ++---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  3 +++
 .../mellanox/mlxsw/spectrum_switchdev.c       |  6 ++---
 .../microchip/sparx5/sparx5_switchdev.c       |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  6 ++---
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  6 ++---
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  6 ++---
 include/net/switchdev.h                       | 13 +++++-----
 net/dsa/slave.c                               |  6 ++---
 net/switchdev/switchdev.c                     | 25 +++++++++++--------
 11 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 05de37c3b64c..f3d12d0714fb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1625,7 +1625,7 @@ static int dpaa2_switch_port_bridge_flags(struct net_device *netdev,
 	return 0;
 }
 
-static int dpaa2_switch_port_attr_set(struct net_device *netdev,
+static int dpaa2_switch_port_attr_set(struct net_device *netdev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 74b81b4fbb97..0b3e8f2db294 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -708,7 +708,7 @@ static int prestera_port_attr_stp_state_set(struct prestera_port *port,
 	return err;
 }
 
-static int prestera_port_obj_attr_set(struct net_device *dev,
+static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack)
 {
@@ -1040,7 +1040,7 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 					     flag_pvid, extack);
 }
 
-static int prestera_port_obj_add(struct net_device *dev,
+static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj,
 				 struct netlink_ext_ack *extack)
 {
@@ -1078,7 +1078,7 @@ static int prestera_port_vlans_del(struct prestera_port *port,
 	return 0;
 }
 
-static int prestera_port_obj_del(struct net_device *dev,
+static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj)
 {
 	struct prestera_port *port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 7f5efc1b4392..3c0032c9647c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -76,6 +76,7 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 }
 
 static int mlx5_esw_bridge_port_obj_add(struct net_device *dev,
+					const void *ctx,
 					const struct switchdev_obj *obj,
 					struct netlink_ext_ack *extack)
 {
@@ -107,6 +108,7 @@ static int mlx5_esw_bridge_port_obj_add(struct net_device *dev,
 }
 
 static int mlx5_esw_bridge_port_obj_del(struct net_device *dev,
+					const void *ctx,
 					const struct switchdev_obj *obj)
 {
 	const struct switchdev_obj_port_vlan *vlan;
@@ -136,6 +138,7 @@ static int mlx5_esw_bridge_port_obj_del(struct net_device *dev,
 }
 
 static int mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
+					     const void *ctx,
 					     const struct switchdev_attr *attr,
 					     struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 0cfba2986841..c5ef9aa64efe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -898,7 +898,7 @@ mlxsw_sp_port_attr_br_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
-static int mlxsw_sp_port_attr_set(struct net_device *dev,
+static int mlxsw_sp_port_attr_set(struct net_device *dev, const void *ctx,
 				  const struct switchdev_attr *attr,
 				  struct netlink_ext_ack *extack)
 {
@@ -1766,7 +1766,7 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-static int mlxsw_sp_port_obj_add(struct net_device *dev,
+static int mlxsw_sp_port_obj_add(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj,
 				 struct netlink_ext_ack *extack)
 {
@@ -1916,7 +1916,7 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-static int mlxsw_sp_port_obj_del(struct net_device *dev,
+static int mlxsw_sp_port_obj_del(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 19c7cb795b4b..246eba711f15 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -65,7 +65,7 @@ static void sparx5_port_attr_ageing_set(struct sparx5_port *port,
 	sparx5_set_ageing(port->sparx5, ageing_time);
 }
 
-static int sparx5_port_attr_set(struct net_device *dev,
+static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
 				const struct switchdev_attr *attr,
 				struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 4fc74ee4aaab..456541640feb 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -939,7 +939,7 @@ static void ocelot_port_attr_mc_set(struct ocelot *ocelot, int port, bool mc)
 		       ANA_PORT_CPU_FWD_CFG, port);
 }
 
-static int ocelot_port_attr_set(struct net_device *dev,
+static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 				const struct switchdev_attr *attr,
 				struct netlink_ext_ack *extack)
 {
@@ -1058,7 +1058,7 @@ ocelot_port_obj_mrp_del_ring_role(struct net_device *dev,
 	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
 }
 
-static int ocelot_port_obj_add(struct net_device *dev,
+static int ocelot_port_obj_add(struct net_device *dev, const void *ctx,
 			       const struct switchdev_obj *obj,
 			       struct netlink_ext_ack *extack)
 {
@@ -1086,7 +1086,7 @@ static int ocelot_port_obj_add(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_port_obj_del(struct net_device *dev,
+static int ocelot_port_obj_del(struct net_device *dev, const void *ctx,
 			       const struct switchdev_obj *obj)
 {
 	int ret = 0;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 23cfb91e9c4d..9c29b363e9ae 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -84,7 +84,7 @@ static int am65_cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
 	return 0;
 }
 
-static int am65_cpsw_port_attr_set(struct net_device *ndev,
+static int am65_cpsw_port_attr_set(struct net_device *ndev, const void *ctx,
 				   const struct switchdev_attr *attr,
 				   struct netlink_ext_ack *extack)
 {
@@ -302,7 +302,7 @@ static int am65_cpsw_port_mdb_del(struct am65_cpsw_port *port,
 	return 0;
 }
 
-static int am65_cpsw_port_obj_add(struct net_device *ndev,
+static int am65_cpsw_port_obj_add(struct net_device *ndev, const void *ctx,
 				  const struct switchdev_obj *obj,
 				  struct netlink_ext_ack *extack)
 {
@@ -329,7 +329,7 @@ static int am65_cpsw_port_obj_add(struct net_device *ndev,
 	return err;
 }
 
-static int am65_cpsw_port_obj_del(struct net_device *ndev,
+static int am65_cpsw_port_obj_del(struct net_device *ndev, const void *ctx,
 				  const struct switchdev_obj *obj)
 {
 	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 05a64fb7a04f..f7fb6e17dadd 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -86,7 +86,7 @@ static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
 	return 0;
 }
 
-static int cpsw_port_attr_set(struct net_device *ndev,
+static int cpsw_port_attr_set(struct net_device *ndev, const void *ctx,
 			      const struct switchdev_attr *attr,
 			      struct netlink_ext_ack *extack)
 {
@@ -310,7 +310,7 @@ static int cpsw_port_mdb_del(struct cpsw_priv *priv,
 	return err;
 }
 
-static int cpsw_port_obj_add(struct net_device *ndev,
+static int cpsw_port_obj_add(struct net_device *ndev, const void *ctx,
 			     const struct switchdev_obj *obj,
 			     struct netlink_ext_ack *extack)
 {
@@ -338,7 +338,7 @@ static int cpsw_port_obj_add(struct net_device *ndev,
 	return err;
 }
 
-static int cpsw_port_obj_del(struct net_device *ndev,
+static int cpsw_port_obj_del(struct net_device *ndev, const void *ctx,
 			     const struct switchdev_obj *obj)
 {
 	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index f1a5a9a3634d..e4cac9218ce1 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -202,6 +202,7 @@ enum switchdev_notifier_type {
 struct switchdev_notifier_info {
 	struct net_device *dev;
 	struct netlink_ext_ack *extack;
+	const void *ctx;
 };
 
 struct switchdev_notifier_fdb_info {
@@ -268,19 +269,19 @@ void switchdev_port_fwd_mark_set(struct net_device *dev,
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*add_cb)(struct net_device *dev,
+			int (*add_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack));
 int switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*del_cb)(struct net_device *dev,
+			int (*del_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj));
 
 int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*set_cb)(struct net_device *dev,
+			int (*set_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack));
 #else
@@ -352,7 +353,7 @@ static inline int
 switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*add_cb)(struct net_device *dev,
+			int (*add_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack))
 {
@@ -363,7 +364,7 @@ static inline int
 switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*del_cb)(struct net_device *dev,
+			int (*del_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj))
 {
 	return 0;
@@ -373,7 +374,7 @@ static inline int
 switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*set_cb)(struct net_device *dev,
+			int (*set_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack))
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5e668e529575..3692259a025f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -271,7 +271,7 @@ static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return phylink_mii_ioctl(p->dp->pl, ifr, cmd);
 }
 
-static int dsa_slave_port_attr_set(struct net_device *dev,
+static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 				   const struct switchdev_attr *attr,
 				   struct netlink_ext_ack *extack)
 {
@@ -394,7 +394,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	return vlan_vid_add(master, htons(ETH_P_8021Q), vlan.vid);
 }
 
-static int dsa_slave_port_obj_add(struct net_device *dev,
+static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 				  const struct switchdev_obj *obj,
 				  struct netlink_ext_ack *extack)
 {
@@ -469,7 +469,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	return 0;
 }
 
-static int dsa_slave_port_obj_del(struct net_device *dev,
+static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 				  const struct switchdev_obj *obj)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 89a36db47ab4..070698dd19bc 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -381,19 +381,20 @@ EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
 static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*add_cb)(struct net_device *dev,
+			int (*add_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack))
 {
+	struct switchdev_notifier_info *info = &port_obj_info->info;
 	struct netlink_ext_ack *extack;
 	struct net_device *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
-	extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
+	extack = switchdev_notifier_info_to_extack(info);
 
 	if (check_cb(dev)) {
-		err = add_cb(dev, port_obj_info->obj, extack);
+		err = add_cb(dev, info->ctx, port_obj_info->obj, extack);
 		if (err != -EOPNOTSUPP)
 			port_obj_info->handled = true;
 		return err;
@@ -422,7 +423,7 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*add_cb)(struct net_device *dev,
+			int (*add_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack))
 {
@@ -439,15 +440,16 @@ EXPORT_SYMBOL_GPL(switchdev_handle_port_obj_add);
 static int __switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*del_cb)(struct net_device *dev,
+			int (*del_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj))
 {
+	struct switchdev_notifier_info *info = &port_obj_info->info;
 	struct net_device *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		err = del_cb(dev, port_obj_info->obj);
+		err = del_cb(dev, info->ctx, port_obj_info->obj);
 		if (err != -EOPNOTSUPP)
 			port_obj_info->handled = true;
 		return err;
@@ -476,7 +478,7 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 int switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*del_cb)(struct net_device *dev,
+			int (*del_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_obj *obj))
 {
 	int err;
@@ -492,19 +494,20 @@ EXPORT_SYMBOL_GPL(switchdev_handle_port_obj_del);
 static int __switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*set_cb)(struct net_device *dev,
+			int (*set_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack))
 {
+	struct switchdev_notifier_info *info = &port_attr_info->info;
 	struct netlink_ext_ack *extack;
 	struct net_device *lower_dev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
-	extack = switchdev_notifier_info_to_extack(&port_attr_info->info);
+	extack = switchdev_notifier_info_to_extack(info);
 
 	if (check_cb(dev)) {
-		err = set_cb(dev, port_attr_info->attr, extack);
+		err = set_cb(dev, info->ctx, port_attr_info->attr, extack);
 		if (err != -EOPNOTSUPP)
 			port_attr_info->handled = true;
 		return err;
@@ -533,7 +536,7 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
-			int (*set_cb)(struct net_device *dev,
+			int (*set_cb)(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack))
 {
-- 
2.25.1

