Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A2323B77
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhBXLtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbhBXLqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:46:23 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73241C06121F
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:20 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id t11so2523866ejx.6
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nfBDHgnDjcsZES8vXUS8aoIStbEt+fjmkG61Meh+ib4=;
        b=P47RXwwEdGcmArkX6q8gMYIqMhh1OPQjJmzW0Gwky44DuQd3vXpuBqR0HuRU6d8ccZ
         IVRZUMYJIOjJY7uqx0nXoSFKLGiViLPwp5vaP0zJfVXtZilkQfUhNvVacM97r8Za/y4m
         cUSYtiLtcR/trCoZBilqktqNQ2NcgtJ8deE8yxEFLxZgg0mTKzVMGzWVHf2xDCrlrESo
         Gbu1xMUOugDemR/0IYdeG7pCCjs4MtNssl1vD8tpcb9q/4iNIircm7h2GApOKKlfxizI
         tk2RU/8WYmNfaU0LYxrY57A7eSB5wasKIwFKXzY4YJJfXQnhIBSGDcNeSEPVePmg8IAs
         jXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nfBDHgnDjcsZES8vXUS8aoIStbEt+fjmkG61Meh+ib4=;
        b=l0WP8T2Pwb5UdKGdUSEvVYLWLT7KQcPiHNGgGTNWQ5CadC7dg3rN2aZXTXwbLGEZ0q
         e2c67R+Wt/tyNFH+ccUQY6Ns96GyrgNTqpCCasPGxDHyMVv/kxG0JgP4VoxOMDScEu+r
         BYFXMNtl/kfNaCCDfHuv+GOgklHT79nz8+WIEvHfJeomghoQSMRtODH08qLHyv1UTHae
         DHea5M+HyR8TqcY4Da7Lxw1tIn9sObUxPLs4ECENNN0oBaFIJXi3Y05yu2IO8J0bMfWB
         aE+l1T/Ra8Ypjy0IKLzJvPkjKFgxzmP3tK2OEJhXftkc22l81XHZX/P/PxV1ipcDK58j
         4iTg==
X-Gm-Message-State: AOAM531oB8URXMF6bQ4uhiD6HfpqkgB6qi49thCmaUR1fl+RRmkrilul
        ZSsuxogVhjjLuhD9rI6ClJ49wmcLyk8=
X-Google-Smtp-Source: ABdhPJzJoUP9gUyS/U5hnpvKUNm9vTUTMe3O04dsV8jOG4JSXFD//9pZGwdxIY3qitBT4ln4EGvBsg==
X-Received: by 2002:a17:906:b214:: with SMTP id p20mr22505839ejz.22.1614167058668;
        Wed, 24 Feb 2021 03:44:18 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:18 -0800 (PST)
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
Subject: [RFC PATCH v2 net-next 16/17] net: bridge: switchdev: let drivers inform which bridge ports are offloaded
Date:   Wed, 24 Feb 2021 13:43:49 +0200
Message-Id: <20210224114350.2791260-17-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On reception of an skb, the bridge checks if it was marked as 'already
forwarded in hardware' (checks if skb->offload_fwd_mark == 1), and if it
is, it puts a mark of its own on that skb, with the switchdev mark of
the ingress port. Then during forwarding, it enforces that the egress
port must have a different switchdev mark than the ingress one (this is
done in nbp_switchdev_allowed_egress).

Non-switchdev drivers don't report any physical switch id (neither
through devlink nor .ndo_get_port_parent_id), therefore the bridge
assigns them a switchdev mark of 0, and packets coming from them will
always have skb->offload_fwd_mark = 0. So there aren't any restrictions.

Problems appear due to the fact that DSA would like to perform software
fallback for bonding and team interfaces that the physical switch cannot
offload.

         +-- br0 -+
        /   / |    \
       /   /  |     \
      /   /   |      \
     /   /    |       \
    /   /     |        \
   /    |     |       bond0
  /     |     |      /    \
 swp0  swp1  swp2  swp3  swp4

There, it is desirable that the presence of swp3 and swp4 under a
non-offloaded LAG does not preclude us from doing hardware bridging
beteen swp0, swp1 and swp2. The bandwidth of the CPU is often times high
enough that software bridging between {swp0,swp1,swp2} and bond0 is not
impractical.

But this creates an impossible paradox given the current way in which
port switchdev marks are assigned. When the driver receives a packet
from swp0 (say, due to flooding), it must set skb->offload_fwd_mark to
something.

- If we set it to 0, then the bridge will forward it towards swp1, swp2
  and bond0. But the switch has already forwarded it towards swp1 and
  swp2 (not to bond0, remember, that isn't offloaded, so as far as the
  switch is concerned, ports swp3 and swp4 are not looking up the FDB,
  and the entire bond0 is a destination that is strictly behind the
  CPU). But we don't want duplicated traffic towards swp1 and swp2, so
  it's not ok to set skb->offload_fwd_mark = 0.

- If we set it to 1, then the bridge will not forward the skb towards
  the ports with the same switchdev mark, i.e. not to swp1, swp2 and
  bond0. Towards swp1 and swp2 that's ok, but towards bond0? It should
  have forwarded the skb there.

So the real issue is that bond0 will be assigned the same switchdev mark
as {swp0,swp1,swp2}, because the function that assigns switchdev marks
to bridge ports, nbp_switchdev_mark_set, recurses through bond0's lower
interfaces until it finds something that implements devlink.

A solution is to give the bridge explicit hints as to what switchdev
mark it should use for each port.

Currently, the bridging offload is very 'silent': a driver registers a
netdevice notifier, which is put on the netns's notifier chain, and
which sniffs around for NETDEV_CHANGEUPPER events where the upper is a
bridge, and the lower is an interface it knows about (one registered by
this driver, normally). Then, from within that notifier, it does a bunch
of stuff behind the bridge's back, without the bridge necessarily
knowing that there's somebody offloading that port. It looks like this:

     ip link set swp0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v
        call_netdevice_notifiers
                  |
                  v
       dsa_slave_netdevice_event
                  |
                  v
        oh, hey! it's for me!
                  |
                  v
           .port_bridge_join

What we do to solve the conundrum is to be less silent, and emit a
notification back. Something like this:

     ip link set swp0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge: Aye! I'll use this
        call_netdevice_notifiers           ^  ppid as the
                  |                        |  switchdev mark for
                  v                        |  this port, and zero
       dsa_slave_netdevice_event           |  if I got nothing.
                  |                        |
                  v                        |
        oh, hey! it's for me!              |
                  |                        |
                  v                        |
           .port_bridge_join               |
                  |                        |
                  +------------------------+
      call_switchdev_notifiers(swp0, SWITCHDEV_BRPORT_OFFLOADED, ppid)

Then stacked interfaces (like bond0 on top of swp3/swp4) would be
treated differently in DSA, depending on whether we can or cannot
offload them.

The offload case:

    ip link set bond0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge: Aye! I'll use this
        call_netdevice_notifiers           ^  ppid as the
                  |                        |  switchdev mark for
                  v                        |        bond0.
       dsa_slave_netdevice_event           | Coincidentally (or not),
                  |                        | bond0 and swp0, swp1, swp2
                  v                        | all have the same switchdev
        hmm, it's not quite for me,        | mark now, since the ASIC
         but my driver has already         | is able to forward towards
           called .port_lag_join           | all these ports in hw.
          for it, because I have           |
      a port with dp->lag_dev == bond0.    |
                  |                        |
                  v                        |
           .port_bridge_join               |
           for swp3 and swp4               |
                  |                        |
                  +------------------------+
      call_switchdev_notifiers(bond0, SWITCHDEV_BRPORT_OFFLOADED, ppid)

And the non-offload case:

    ip link set bond0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge waiting:
        call_netdevice_notifiers           ^  huh, no SWITCHDEV_BRPORT_OFFLOADED
                  |                        |  event, okay, I'll use a switchdev
                  v                        |  mark of zero for this one.
       dsa_slave_netdevice_event           :  Then packets received on swp0 will
                  |                        :  not be forwarded towards swp1, but
                  v                        :  they will towards bond0.
         it's not for me, but
       bond0 is an upper of swp3
      and swp4, but their dp->lag_dev
       is NULL because they couldn't
            offload it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../marvell/prestera/prestera_switchdev.c     |  2 +
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +
 drivers/net/ethernet/mscc/ocelot_net.c        | 43 +++++++++++++++----
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +
 drivers/net/ethernet/ti/cpsw_new.c            |  1 +
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  2 +
 include/net/switchdev.h                       | 16 +++++++
 net/bridge/br.c                               |  8 +++-
 net/bridge/br_if.c                            | 11 ++---
 net/bridge/br_private.h                       |  7 +--
 net/bridge/br_switchdev.c                     | 27 +++++-------
 net/dsa/slave.c                               | 20 +++++----
 net/switchdev/switchdev.c                     | 18 ++++++++
 14 files changed, 116 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index cb564890a3dc..10a6242b7ac1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -443,6 +443,8 @@ static int prestera_port_bridge_join(struct prestera_port *port,
 		goto err_brport_create;
 	}
 
+	switchdev_bridge_port_offload_notify(port->dev);
+
 	if (bridge->vlan_enabled)
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 9aadc29ad777..241276dbe876 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2326,6 +2326,8 @@ int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		goto err_port_join;
 
+	switchdev_bridge_port_offload_notify(brport_dev);
+
 	return 0;
 
 err_port_join:
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 12cb6867a2d0..b8be69ade1bd 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1111,10 +1111,14 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_netdevice_bridge_join(struct ocelot *ocelot, int port,
+static int ocelot_netdevice_bridge_join(struct net_device *dev,
 					struct net_device *bridge)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct switchdev_brport_flags flags;
+	int port = priv->chip_port;
 	int err;
 
 	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
@@ -1124,15 +1128,20 @@ static int ocelot_netdevice_bridge_join(struct ocelot *ocelot, int port,
 	if (err)
 		return err;
 
+	switchdev_bridge_port_offload_notify(dev);
 	ocelot_port_bridge_flags(ocelot, port, flags);
 
 	return 0;
 }
 
-static int ocelot_netdevice_bridge_leave(struct ocelot *ocelot, int port,
+static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 					 struct net_device *bridge)
 {
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct switchdev_brport_flags flags;
+	int port = priv->chip_port;
 	int err;
 
 	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
@@ -1146,7 +1155,8 @@ static int ocelot_netdevice_bridge_leave(struct ocelot *ocelot, int port,
 }
 
 static int ocelot_netdevice_changeupper(struct net_device *dev,
-					struct netdev_notifier_changeupper_info *info)
+					struct netdev_notifier_changeupper_info *info,
+					bool notify)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -1156,11 +1166,11 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
-			err = ocelot_netdevice_bridge_join(ocelot, port,
-							   info->upper_dev);
+			err = ocelot_netdevice_bridge_join(dev, info->upper_dev);
+			if (!err && notify)
+				switchdev_bridge_port_offload_notify(dev);
 		} else {
-			err = ocelot_netdevice_bridge_leave(ocelot, port,
-							    info->upper_dev);
+			err = ocelot_netdevice_bridge_leave(dev, info->upper_dev);
 		}
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
@@ -1182,6 +1192,12 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 	return notifier_from_errno(err);
 }
 
+/* Treat CHANGEUPPER events on an offloaded LAG as individual CHANGEUPPER
+ * events for the lower physical ports of the LAG.
+ * If the LAG upper isn't offloaded, ignore its CHANGEUPPER events.
+ * In case the LAG joined a bridge, notify that we are offloading it and can do
+ * forwarding in hardware towards it.
+ */
 static int
 ocelot_netdevice_lag_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
@@ -1191,11 +1207,20 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 
 	netdev_for_each_lower_dev(dev, lower, iter) {
-		err = ocelot_netdevice_changeupper(lower, info);
+		struct ocelot_port_private *priv = netdev_priv(lower);
+		struct ocelot_port *ocelot_port = &priv->port;
+
+		if (ocelot_port->bond != dev)
+			return NOTIFY_OK;
+
+		err = ocelot_netdevice_changeupper(lower, info, false);
 		if (err)
 			return notifier_from_errno(err);
 	}
 
+	if (info->linking && netif_is_bridge_master(info->upper_dev))
+		switchdev_bridge_port_offload_notify(dev);
+
 	return NOTIFY_DONE;
 }
 
@@ -1230,7 +1255,7 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		struct netdev_notifier_changeupper_info *info = ptr;
 
 		if (ocelot_netdevice_dev_check(dev))
-			return ocelot_netdevice_changeupper(dev, info);
+			return ocelot_netdevice_changeupper(dev, info, true);
 
 		if (netif_is_lag_master(dev))
 			return ocelot_netdevice_lag_changeupper(dev, info);
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 967a634ee9ac..f57c26a24924 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2592,6 +2592,8 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 
 	ofdpa_port->bridge_dev = bridge;
 
+	switchdev_bridge_port_offload_notify(ofdpa_port->dev);
+
 	return ofdpa_port_vlan_add(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
 }
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 638d7b03be4b..7bb1b7b83031 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -27,6 +27,7 @@
 #include <linux/sys_soc.h>
 #include <linux/dma/ti-cppi5.h>
 #include <linux/dma/k3-udma-glue.h>
+#include <net/switchdev.h>
 
 #include "cpsw_ale.h"
 #include "cpsw_sl.h"
@@ -2096,6 +2097,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev, struct net_dev
 	common->br_members |= BIT(priv->port->port_id);
 
 	am65_cpsw_port_offload_fwd_mark_update(common);
+	switchdev_bridge_port_offload_notify(ndev);
 
 	return NOTIFY_DONE;
 }
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 58a64313ac00..e246010db5be 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1522,6 +1522,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 	cpsw->br_members |= BIT(priv->emac_port);
 
 	cpsw_port_offload_fwd_mark_update(cpsw);
+	switchdev_bridge_port_offload_notify(ndev);
 
 	return NOTIFY_DONE;
 }
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index aad212b9b97b..535982be5605 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -1237,6 +1237,8 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	if (!err)
 		port_priv->bridge_dev = upper_dev;
 
+	switchdev_bridge_port_offload_notify(netdev);
+
 	return err;
 }
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 5b63dfd444c6..a3b4cf6ade6c 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -197,6 +197,8 @@ enum switchdev_notifier_type {
 	SWITCHDEV_VXLAN_FDB_ADD_TO_DEVICE,
 	SWITCHDEV_VXLAN_FDB_DEL_TO_DEVICE,
 	SWITCHDEV_VXLAN_FDB_OFFLOADED,
+
+	SWITCHDEV_BRPORT_OFFLOADED,
 };
 
 struct switchdev_notifier_info {
@@ -204,6 +206,11 @@ struct switchdev_notifier_info {
 	struct netlink_ext_ack *extack;
 };
 
+struct switchdev_notifier_brport_info {
+	struct switchdev_notifier_info info; /* must be first */
+	struct netdev_phys_item_id ppid;
+};
+
 struct switchdev_notifier_fdb_info {
 	struct switchdev_notifier_info info; /* must be first */
 	struct list_head list;
@@ -284,6 +291,9 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 			int (*set_cb)(struct net_device *dev,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack));
+
+int switchdev_bridge_port_offload_notify(struct net_device *dev);
+
 #else
 
 static inline void switchdev_deferred_process(void)
@@ -380,6 +390,12 @@ switchdev_handle_port_attr_set(struct net_device *dev,
 {
 	return 0;
 }
+
+static inline int switchdev_bridge_port_offload_notify(struct net_device *dev)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _LINUX_SWITCHDEV_H_ */
diff --git a/net/bridge/br.c b/net/bridge/br.c
index ef743f94254d..72dcd0bc462a 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -151,9 +151,10 @@ static int br_switchdev_event(struct notifier_block *unused,
 			      unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_brport_info *brport_info;
+	struct switchdev_notifier_fdb_info *fdb_info;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
-	struct switchdev_notifier_fdb_info *fdb_info;
 	int err = NOTIFY_DONE;
 
 	p = br_port_get_rtnl_rcu(dev);
@@ -191,6 +192,11 @@ static int br_switchdev_event(struct notifier_block *unused,
 		/* Don't delete static entries */
 		br_fdb_delete_by_port(br, p, fdb_info->vid, 0);
 		break;
+	case SWITCHDEV_BRPORT_OFFLOADED:
+		brport_info = ptr;
+		p->ppid = brport_info->ppid;
+		p->offloaded = true;
+		break;
 	}
 
 out:
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..680fc3bed549 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -643,9 +643,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_mark_set(p);
-	if (err)
-		goto err6;
+	nbp_switchdev_mark_set(p);
 
 	dev_disable_lro(dev);
 
@@ -671,13 +669,13 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 		 */
 		err = dev_pre_changeaddr_notify(br->dev, dev->dev_addr, extack);
 		if (err)
-			goto err7;
+			goto err6;
 	}
 
 	err = nbp_vlan_init(p, extack);
 	if (err) {
 		netdev_err(dev, "failed to initialize vlan filtering on this port\n");
-		goto err7;
+		goto err6;
 	}
 
 	spin_lock_bh(&br->lock);
@@ -700,11 +698,10 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 
 	return 0;
 
-err7:
+err6:
 	list_del_rcu(&p->list);
 	br_fdb_delete_by_port(br, p, 0, 1);
 	nbp_update_port_count(br);
-err6:
 	netdev_upper_dev_unlink(dev, br->dev);
 err5:
 	dev->priv_flags &= ~IFF_BRIDGE_PORT;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4a262dc55e6b..484e23e8bb9d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -328,6 +328,8 @@ struct net_bridge_port {
 #endif
 #ifdef CONFIG_NET_SWITCHDEV
 	int				offload_fwd_mark;
+	bool				offloaded;
+	struct netdev_phys_item_id	ppid;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -1572,7 +1574,7 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_mark_set(struct net_bridge_port *p);
+void nbp_switchdev_mark_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1592,9 +1594,8 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_mark_set(struct net_bridge_port *p)
+static inline void nbp_switchdev_mark_set(struct net_bridge_port *p)
 {
-	return 0;
 }
 
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 9a707da79dfe..c700da5c71e0 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,36 +8,29 @@
 
 #include "br_private.h"
 
-static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
+static int br_switchdev_mark_get(struct net_bridge *br,
+				 struct net_bridge_port *new_nbp)
 {
 	struct net_bridge_port *p;
 
 	/* dev is yet to be added to the port list. */
 	list_for_each_entry(p, &br->port_list, list) {
-		if (netdev_port_same_parent_id(dev, p->dev))
+		if (!p->offloaded)
+			continue;
+
+		if (netdev_phys_item_id_same(&p->ppid, &new_nbp->ppid))
 			return p->offload_fwd_mark;
 	}
 
 	return ++br->offload_fwd_mark;
 }
 
-int nbp_switchdev_mark_set(struct net_bridge_port *p)
+void nbp_switchdev_mark_set(struct net_bridge_port *p)
 {
-	struct netdev_phys_item_id ppid = { };
-	int err;
-
-	ASSERT_RTNL();
+	if (!p->offloaded)
+		return;
 
-	err = dev_get_port_parent_id(p->dev, &ppid, true);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-
-	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p->dev);
-
-	return 0;
+	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p);
 }
 
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5fa5737e622c..bbb7846d6022 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2295,7 +2295,8 @@ static struct notifier_block dsa_slave_switchdev_notifier;
 static struct notifier_block dsa_slave_switchdev_blocking_notifier;
 
 static int dsa_slave_changeupper(struct net_device *dev,
-				 struct netdev_notifier_changeupper_info *info)
+				 struct netdev_notifier_changeupper_info *info,
+				 bool notify)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err = NOTIFY_DONE;
@@ -2305,6 +2306,8 @@ static int dsa_slave_changeupper(struct net_device *dev,
 
 		if (info->linking) {
 			err = dsa_port_bridge_join(dp, bridge_dev);
+			if (!err && notify)
+				switchdev_bridge_port_offload_notify(dev);
 			if (!err) {
 				dsa_bridge_mtu_normalization(dp);
 				br_fdb_replay(bridge_dev, dev,
@@ -2364,22 +2367,23 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 
 		dp = dsa_slave_to_port(lower);
 		if (!dp->lag_dev)
-			/* Software LAG */
-			continue;
+			/* Software LAG, ignore all its CHANGEUPPER events */
+			return NOTIFY_DONE;
 
-		err = dsa_slave_changeupper(lower, info);
+		err = dsa_slave_changeupper(lower, info, false);
 		if (notifier_to_errno(err))
-			break;
+			return err;
 	}
 
-	if (netif_is_bridge_master(info->upper_dev) && !err) {
+	if (info->linking && netif_is_bridge_master(info->upper_dev)) {
+		switchdev_bridge_port_offload_notify(dev);
 		br_fdb_replay(info->upper_dev, dev,
 			      &dsa_slave_switchdev_notifier);
 		br_mdb_replay(info->upper_dev, dev,
 			      &dsa_slave_switchdev_blocking_notifier);
 	}
 
-	return err;
+	return 0;
 }
 
 static int
@@ -2475,7 +2479,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	}
 	case NETDEV_CHANGEUPPER:
 		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+			return dsa_slave_changeupper(dev, ptr, true);
 
 		if (netif_is_lag_master(dev))
 			return dsa_slave_lag_changeupper(dev, ptr);
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 89a36db47ab4..7f48effc1ffb 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -546,3 +546,21 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_handle_port_attr_set);
+
+/* Let the bridge know that this port is offloaded, so that it can use the
+ * port parent id obtained by recursion to determine the bridge port's
+ * switchdev mark.
+ */
+int switchdev_bridge_port_offload_notify(struct net_device *dev)
+{
+	struct switchdev_notifier_brport_info info;
+	int err;
+
+	err = dev_get_port_parent_id(dev, &info.ppid, true);
+	if (err)
+		return err;
+
+	return call_switchdev_notifiers(SWITCHDEV_BRPORT_OFFLOADED, dev,
+					&info.info, NULL);
+}
+EXPORT_SYMBOL(switchdev_bridge_port_offload_notify);
-- 
2.25.1

