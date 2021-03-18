Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E560C3410ED
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhCRXTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbhCRXTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:19:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DBDC06174A;
        Thu, 18 Mar 2021 16:19:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id va9so6626718ejb.12;
        Thu, 18 Mar 2021 16:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qxyh4AClHTYwEL9HQLKnyHQngIipKDmc5fqOAnHL3bE=;
        b=O2nQubzDJ3vMTvjojsiv0gBwhw9OXI5vC+LaJNnthyF3hH8mK+uPbq7v7/sjILrKUY
         yEgyHUOWRftCR5gSWOYYkUWnEfZMn0ahgT/nJe9qtlyGSaoSl9i5InVYfd1APXqDWUd5
         txU+4k03VVL4z8gMfl8x8X7BIRY7TxIi3ILmRpPCwU1fO5zabH3/Ylie086Hvq3rGA8g
         7r5APISlGAvtn9nsf1oxAPCTgF5WD7UaTZ198DrRnqWWmPMOpFSqLko+2yNA8m9n9GMn
         2XqupECzgWCLcjFVMIEVG/VTAeFO6yzFcaIK2NIdbha2veqNbmg8wHgXfVuNhsmQMG8h
         38Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qxyh4AClHTYwEL9HQLKnyHQngIipKDmc5fqOAnHL3bE=;
        b=tq2UH+pfQJn8aZsQLW1mqTqj9RpEoYuN8k4zlgI9ZbiCoYGDUTdCub4onQvY80sJuo
         QuCjeWb0Rv6OILi6fyisQYhUNvqdZioxhuDPwqG9yrUyUEjMdAkJLlsKwBEUE0IZuYmp
         gdxnS97Aw849q0ebo4nkzX/lv4JUtdAsSm2M1pyyMq1XoS6hRv7I6SB4Qihq9tOtaM9r
         dMIO3bL4pMOQ/Wy3hkKX28bQC55u8Ynu8geFsRayqOmXy6MWiqx2L6bouzv4+yJcGgsQ
         q8VdiSDXdvkA+7dFxhEHrirTNDRMp0mvpr58MnpzLztCwevbe9VSmGA/AoTQ959bIPJH
         ehpw==
X-Gm-Message-State: AOAM532kDbMm8mdrEVkD3zPzq/fwuDwbpoPoNdJe5j4fXdxK2GucjE4n
        0y7SEonReFfSNMiMYoIn0oE=
X-Google-Smtp-Source: ABdhPJxDh6u7KjYkOBHawaTkGZ14d5HM7yUwHu6ELE8AG66HWXiSYwSRrBtJbaEHLOmXN21IoPAGMw==
X-Received: by 2002:a17:906:6044:: with SMTP id p4mr1141778ejj.82.1616109547343;
        Thu, 18 Mar 2021 16:19:07 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:19:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 16/16] net: bridge: switchdev: let drivers inform which bridge ports are offloaded
Date:   Fri, 19 Mar 2021 01:18:29 +0200
Message-Id: <20210318231829.3892920-17-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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
             switchdev_bridge_port_offload(swp0)

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
            switchdev_bridge_port_offload(bond0)

And the non-offload case:

    ip link set bond0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge waiting:
        call_netdevice_notifiers           ^  huh, switchdev_bridge_port_offload
                  |                        |  wasn't called, okay, I'll use a
                  v                        |  switchdev mark of zero for this one.
       dsa_slave_netdevice_event           :  Then packets received on swp0 will
                  |                        :  not be forwarded towards swp1, but
                  v                        :  they will towards bond0.
         it's not for me, but
       bond0 is an upper of swp3
      and swp4, but their dp->lag_dev
       is NULL because they couldn't
            offload it.

Basically we can draw the conclusion that the lowers of a bridge port
can come and go, so depending on the configuration of lowers for a
bridge port, it can dynamically toggle between offloaded and unoffloaded.
Therefore, we need an equivalent switchdev_bridge_port_unoffload too.

This patch changes the way any switchdev driver interacts with the
bridge. From now on, everybody needs to call switchdev_bridge_port_offload,
otherwise the bridge will treat the port as non-offloaded and allow
software flooding to other ports from the same ASIC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  4 +-
 .../marvell/prestera/prestera_switchdev.c     |  7 ++
 .../mellanox/mlxsw/spectrum_switchdev.c       |  4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  4 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  6 +-
 include/linux/if_bridge.h                     | 16 ++++
 net/bridge/br_if.c                            | 11 +--
 net/bridge/br_private.h                       |  8 +-
 net/bridge/br_switchdev.c                     | 94 ++++++++++++++++---
 11 files changed, 138 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2fd05dd18d46..f20556178e33 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1518,7 +1518,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	if (err)
 		goto err_egress_flood;
 
-	return 0;
+	return switchdev_bridge_port_offload(netdev, NULL);
 
 err_egress_flood:
 	dpaa2_switch_port_set_fdb(port_priv, NULL);
@@ -1552,6 +1552,8 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	switchdev_bridge_port_unoffload(netdev);
+
 	/* First of all, fast age any learn FDB addresses on this switch port */
 	dpaa2_switch_port_fast_age(port_priv);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 49e052273f30..0b0d5db7b85b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -443,6 +443,10 @@ static int prestera_port_bridge_join(struct prestera_port *port,
 		goto err_brport_create;
 	}
 
+	err = switchdev_bridge_port_offload(port->dev, NULL);
+	if (err)
+		goto err_brport_offload;
+
 	if (bridge->vlan_enabled)
 		return 0;
 
@@ -453,6 +457,7 @@ static int prestera_port_bridge_join(struct prestera_port *port,
 	return 0;
 
 err_port_join:
+err_brport_offload:
 	prestera_bridge_port_put(br_port);
 err_brport_create:
 	prestera_bridge_put(bridge);
@@ -520,6 +525,8 @@ static void prestera_port_bridge_leave(struct prestera_port *port,
 	if (!br_port)
 		return;
 
+	switchdev_bridge_port_unoffload(port->dev);
+
 	bridge = br_port->bridge;
 
 	if (bridge->vlan_enabled)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 23b7e8d6386b..7fa0b3653819 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2326,7 +2326,7 @@ int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (err)
 		goto err_port_join;
 
-	return 0;
+	return switchdev_bridge_port_offload(brport_dev, extack);
 
 err_port_join:
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
@@ -2348,6 +2348,8 @@ void mlxsw_sp_port_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_port)
 		return;
 
+	switchdev_bridge_port_unoffload(brport_dev);
+
 	bridge_device->ops->port_leave(bridge_device, bridge_port,
 				       mlxsw_sp_port);
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index d38ffc7cf5f0..b917d9dd8a6a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1213,7 +1213,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	if (err)
 		goto err_switchdev_sync;
 
-	return 0;
+	return switchdev_bridge_port_offload(brport_dev, extack);
 
 err_switchdev_sync:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
@@ -1234,6 +1234,8 @@ static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 	if (err)
 		return err;
 
+	switchdev_bridge_port_unoffload(brport_dev);
+
 	ocelot_port_bridge_leave(ocelot, port, bridge);
 
 	return 0;
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 967a634ee9ac..9b6d7cac112b 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2592,13 +2592,19 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 
 	ofdpa_port->bridge_dev = bridge;
 
-	return ofdpa_port_vlan_add(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
+	err = ofdpa_port_vlan_add(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
+	if (err)
+		return err;
+
+	return switchdev_bridge_port_offload(ofdpa_port->dev, NULL);
 }
 
 static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
 {
 	int err;
 
+	switchdev_bridge_port_unoffload(ofdpa_port->dev);
+
 	err = ofdpa_port_vlan_del(ofdpa_port, OFDPA_UNTAGGED_VID, 0);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 638d7b03be4b..fe2e38971acc 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -7,6 +7,7 @@
 
 #include <linux/clk.h>
 #include <linux/etherdevice.h>
+#include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -2082,6 +2083,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev, struct net_dev
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
+	int err;
 
 	if (!common->br_members) {
 		common->hw_bridge_dev = br_ndev;
@@ -2097,7 +2099,8 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev, struct net_dev
 
 	am65_cpsw_port_offload_fwd_mark_update(common);
 
-	return NOTIFY_DONE;
+	err = switchdev_bridge_port_offload(ndev, NULL);
+	return notifier_to_errno(err);
 }
 
 static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
@@ -2105,6 +2108,8 @@ static void am65_cpsw_netdevice_port_unlink(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(ndev);
 
+	switchdev_bridge_port_unoffload(ndev);
+
 	common->br_members &= ~BIT(priv->port->port_id);
 
 	am65_cpsw_port_offload_fwd_mark_update(common);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 58a64313ac00..6347532fb39d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1508,6 +1508,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
+	int err;
 
 	if (!cpsw->br_members) {
 		cpsw->hw_bridge_dev = br_ndev;
@@ -1523,7 +1524,8 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 
 	cpsw_port_offload_fwd_mark_update(cpsw);
 
-	return NOTIFY_DONE;
+	err = switchdev_bridge_port_offload(ndev, NULL);
+	return notifier_to_errno(err);
 }
 
 static void cpsw_netdevice_port_unlink(struct net_device *ndev)
@@ -1531,6 +1533,8 @@ static void cpsw_netdevice_port_unlink(struct net_device *ndev)
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
 
+	switchdev_bridge_port_unoffload(ndev);
+
 	cpsw->br_members &= ~BIT(priv->emac_port);
 
 	cpsw_port_offload_fwd_mark_update(cpsw);
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index ea176c508c0d..4fbee6d5fc16 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -196,4 +196,20 @@ static inline int br_fdb_replay(struct net_device *br_dev,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_NET_SWITCHDEV)
+int switchdev_bridge_port_offload(struct net_device *dev,
+				  struct netlink_ext_ack *extack);
+int switchdev_bridge_port_unoffload(struct net_device *dev);
+#else
+int switchdev_bridge_port_offload(struct net_device *dev,
+				  struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+int switchdev_bridge_port_unoffload(struct net_device *dev)
+{
+}
+#endif
+
 #endif
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..930a09f27e0d 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -643,10 +643,6 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (err)
 		goto err5;
 
-	err = nbp_switchdev_mark_set(p);
-	if (err)
-		goto err6;
-
 	dev_disable_lro(dev);
 
 	list_add_rcu(&p->list, &br->port_list);
@@ -671,13 +667,13 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
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
@@ -700,11 +696,10 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 
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
index d7d167e10b70..1982b5887d0f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -326,8 +326,10 @@ struct net_bridge_port {
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct netpoll			*np;
 #endif
+	int				offload_count;
 #ifdef CONFIG_NET_SWITCHDEV
 	int				offload_fwd_mark;
+	struct netdev_phys_item_id	ppid;
 #endif
 	u16				group_fwd_mask;
 	u16				backup_redirected_cnt;
@@ -1572,7 +1574,6 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
-int nbp_switchdev_mark_set(struct net_bridge_port *p);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1592,11 +1593,6 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
-static inline int nbp_switchdev_mark_set(struct net_bridge_port *p)
-{
-	return 0;
-}
-
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b89503832fcc..4cf7902f056c 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,37 +8,109 @@
 
 #include "br_private.h"
 
-static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
+static int br_switchdev_mark_get(struct net_bridge *br,
+				 struct net_bridge_port *new_nbp)
 {
 	struct net_bridge_port *p;
 
 	/* dev is yet to be added to the port list. */
 	list_for_each_entry(p, &br->port_list, list) {
-		if (netdev_port_same_parent_id(dev, p->dev))
+		if (!p->offload_count)
+			continue;
+
+		if (netdev_phys_item_id_same(&p->ppid, &new_nbp->ppid))
 			return p->offload_fwd_mark;
 	}
 
 	return ++br->offload_fwd_mark;
 }
 
-int nbp_switchdev_mark_set(struct net_bridge_port *p)
+static int nbp_switchdev_mark_set(struct net_bridge_port *p,
+				  struct netdev_phys_item_id ppid,
+				  struct netlink_ext_ack *extack)
+{
+	if (p->offload_count) {
+		/* Prevent unsupported configurations such as a bridge port
+		 * which is a bonding interface, and the member ports are from
+		 * different hardware switches.
+		 */
+		if (!netdev_phys_item_id_same(&p->ppid, &ppid)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Same bridge port cannot be offloaded by two physical switches");
+			return -EBUSY;
+		}
+		/* Be tolerant with drivers that call SWITCHDEV_BRPORT_OFFLOADED
+		 * more than once for the same bridge port, such as when the
+		 * bridge port is an offloaded bonding/team interface.
+		 */
+		p->offload_count++;
+		return 0;
+	}
+
+	p->ppid = ppid;
+	p->offload_count = 1;
+	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p);
+
+	return 0;
+}
+
+static void nbp_switchdev_mark_clear(struct net_bridge_port *p,
+				     struct netdev_phys_item_id ppid)
+{
+	if (WARN_ON(!netdev_phys_item_id_same(&p->ppid, &ppid)))
+		return;
+	if (WARN_ON(!p->offload_count))
+		return;
+
+	p->offload_count--;
+	if (p->offload_count)
+		return;
+
+	p->offload_fwd_mark = 0;
+}
+
+/* Let the bridge know that this port is offloaded, so that it can use
+ * the port parent id obtained by recursion to determine the bridge
+ * port's switchdev mark.
+ */
+int switchdev_bridge_port_offload(struct net_device *dev,
+				  struct netlink_ext_ack *extack)
 {
-	struct netdev_phys_item_id ppid = { };
+	struct netdev_phys_item_id ppid;
+	struct net_bridge_port *p;
 	int err;
 
-	ASSERT_RTNL();
+	p = br_port_get_rtnl(dev);
+	if (!p)
+		return -ENODEV;
 
-	err = dev_get_port_parent_id(p->dev, &ppid, true);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
+	err = dev_get_port_parent_id(dev, &ppid, true);
+	if (err)
+		return err;
+
+	return nbp_switchdev_mark_set(p, ppid, extack);
+}
+EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
+
+int switchdev_bridge_port_unoffload(struct net_device *dev)
+{
+	struct netdev_phys_item_id ppid;
+	struct net_bridge_port *p;
+	int err;
+
+	p = br_port_get_rtnl(dev);
+	if (!p)
+		return -ENODEV;
+
+	err = dev_get_port_parent_id(dev, &ppid, true);
+	if (err)
 		return err;
-	}
 
-	p->offload_fwd_mark = br_switchdev_mark_get(p->br, p->dev);
+	nbp_switchdev_mark_clear(p, ppid);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
 
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
-- 
2.25.1

