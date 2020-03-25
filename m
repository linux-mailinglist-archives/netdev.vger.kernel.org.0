Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A238192C37
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCYPWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38809 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgCYPWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id l20so3142897wmi.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OFpN5nKaNXjh0T0y/rKbE7gyucXsn8yrY1eh+J8Xdi8=;
        b=hK83mvwBO8qSReraVRQATuQOMyoLtwkk6MZ5oLDzj+lZ69thH0/WGiWGuijCqeIhwo
         ZxOkeysqki8/k0zTZoMIiQFeIrW0/r/FTtgYHUnJFwk5mxDvvJtCdQ0EHShF4NDs9u8l
         tjeE9VQ2VrVafUag+AevPRlZ2LZt3gkm/sHmd07kAek5u9RHiVbcDMY8uwaGZjWQkwp8
         c+BBfiXSsO7bUwXe8W+2XG8BAJsh1vDbAF3wEclH1rRzmacYEiMXT2Gk61pY+l8ND3YY
         sQpJtZmr3KYVjeOlLbbnpe4TqMqh1t2r00Vo/lqN1Qlcwxa9WWTJKdVWG4kMM7uNJRaE
         tX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OFpN5nKaNXjh0T0y/rKbE7gyucXsn8yrY1eh+J8Xdi8=;
        b=do3CJ1lMUAzGN11E2nB635APbne2vWkXuXI1EJFz/wWIZGEeZeW2xS4x9Zosxr5OWU
         92XOqVIcLOlzp/v/91YcqGii4ly7cue5LmSWZ8ON2t22jsZlKGPSyUrUllyUaheFBJnq
         yLNuVSrHUSpQ4M2IaP7ZZUwk9fNn24/XobCb4d8nIz4IuPzUH02MLalxZ+y0DvY8WnhM
         zdf/uxuGnW2gPglY8EwX/HMh4qrbRhNwRFtjph/uFF7gP0qkKK2zQcCpyOlZ6f7IZnKF
         hPODSMFwMXZzC9Fr8hcVqmBG/ZeDpRzTVffhZRKV0UrNjpqBWdkee/Ai63HkwB6f27e1
         Jn/w==
X-Gm-Message-State: ANhLgQ3pXjFrN2guggPinf7g2lmoMzaRhLWTOfcPxoESBWA8jAKPVUas
        OUcsn0TIt24g6TyM88OOWzA=
X-Google-Smtp-Source: ADFU+vvimtseBvK6EeZksiiH/cJMsNxWwqFgGPQQuAL1zk7SCgy1HCC/05ePHUu44OwUb8lKNYR5wg==
X-Received: by 2002:a1c:2d11:: with SMTP id t17mr3984472wmt.89.1585149736202;
        Wed, 25 Mar 2020 08:22:16 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 01/10] net: dsa: configure the MTU for switch ports
Date:   Wed, 25 Mar 2020 17:22:00 +0200
Message-Id: <20200325152209.3428-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It is useful be able to configure port policers on a switch to accept
frames of various sizes:

- Increase the MTU for better throughput from the default of 1500 if it
  is known that there is no 10/100 Mbps device in the network.
- Decrease the MTU to limit the latency of high-priority frames under
  congestion.

For DSA slave ports, this is mostly a pass-through callback, called
through the regular ndo ops and at probe time (to ensure consistency
across all supported switches).

The CPU port is called with an MTU equal to the largest configured MTU
of the slave ports. The assumption is that the user might want to
sustain a bidirectional conversation with a partner over any switch
port.

The DSA master is configured the same as the CPU port, plus the tagger
overhead. Since the MTU is by definition L2 payload (sans Ethernet
header), it is up to each individual driver to figure out if it needs to
do anything special for its frame tags on the CPU port (it shouldn't
except in special cases). So the MTU does not contain the tagger
overhead on the CPU port.
However the MTU of the DSA master, minus the tagger overhead, is used as
a proxy for the MTU of the CPU port, which does not have a net device.
This is to avoid uselessly calling the .change_mtu function on the CPU
port when nothing should change.

So it is safe to assume that the DSA master and the CPU port MTUs are
apart by exactly the tagger's overhead in bytes.

This patch also makes MTU configuration on the DSA master interface
mandatory (errors from dsa_master_set_mtu now really are propagated).
The reasoning is that it's better to be safe than sorry.  With cascaded
DSA setups, things can easily spiral out of control if they're ignored,
since the user is not notified of what went wrong, and large packets
just get lost.

Some inspiration (mainly in the MTU DSA notifier) was taken from a
vaguely similar patch from Murali and Florian, who are credited as
co-developers down below.

Co-developed-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Co-developed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  10 +++++
 net/dsa/dsa_priv.h |  10 +++++
 net/dsa/master.c   |  14 +++---
 net/dsa/port.c     |  11 +++++
 net/dsa/slave.c    | 104 ++++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/switch.c   |  34 +++++++++++++++
 6 files changed, 174 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index beeb81a532e3..1bb1e0852e31 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -579,6 +579,16 @@ struct dsa_switch_ops {
 				     struct devlink_param_gset_ctx *ctx);
 	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
 				     struct devlink_param_gset_ctx *ctx);
+
+	/*
+	 * MTU change functionality. Switches can also adjust their MRU through
+	 * this method. By MTU, one understands the SDU, aka L2 payload length.
+	 * If the switch needs to account for the DSA tag on the CPU port, this
+	 * method needs to to do so privately.
+	 */
+	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
+				   int new_mtu);
+	int	(*port_max_mtu)(struct dsa_switch *ds, int port);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 760e6ea3178a..b43d5713ff90 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -22,6 +22,7 @@ enum {
 	DSA_NOTIFIER_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
+	DSA_NOTIFIER_MTU,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -61,6 +62,13 @@ struct dsa_notifier_vlan_info {
 	int port;
 };
 
+/* DSA_NOTIFIER_MTU */
+struct dsa_notifier_mtu_info {
+	int sw_index;
+	int port;
+	int mtu;
+};
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
@@ -98,6 +106,7 @@ int dsa_legacy_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
+int dsa_master_set_mtu(struct net_device *dev, int mtu);
 
 static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 						       int device, int port)
@@ -127,6 +136,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct switchdev_trans *trans);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
 			 struct switchdev_trans *trans);
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index bd44bde272f4..e37f14d6a8a6 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -314,18 +314,18 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp)
+/* Needs to be called under rtnl_lock */
+int dsa_master_set_mtu(struct net_device *dev, int mtu)
 {
-	unsigned int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
-	int err;
+	int err = -ERANGE;
 
-	rtnl_lock();
 	if (mtu <= dev->max_mtu) {
 		err = dev_set_mtu(dev, mtu);
 		if (err)
-			netdev_dbg(dev, "Unable to set MTU to include for DSA overheads\n");
+			netdev_err(dev, "Unable to set MTU to include for DSA overheads\n");
 	}
-	rtnl_unlock();
+
+	return err;
 }
 
 static void dsa_master_reset_mtu(struct net_device *dev)
@@ -344,8 +344,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	int ret;
 
-	dsa_master_set_mtu(dev,  cpu_dp);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a18e65a474a5..428d02d3c2e7 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -297,6 +297,17 @@ int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 	return ds->ops->port_egress_floods(ds, port, true, mrouter);
 }
 
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
+{
+	struct dsa_notifier_mtu_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mtu = new_mtu,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_MTU, &info);
+}
+
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5f782fa3029f..8d8fc20ce4c6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1218,6 +1218,100 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	return dsa_port_vid_del(dp, vid);
 }
 
+static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_switch *ds = p->dp->ds;
+	struct dsa_port *cpu_dp;
+	int port = p->dp->index;
+	int largest_mtu = 0;
+	int new_master_mtu;
+	int old_master_mtu;
+	int mtu_limit;
+	int cpu_mtu;
+	int err, i;
+
+	if (!ds->ops->port_change_mtu)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		int slave_mtu;
+
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		/* During probe, this function will be called for each slave
+		 * device, while not all of them have been allocated. That's
+		 * ok, it doesn't change what the maximum is, so ignore it.
+		 */
+		if (!dsa_to_port(ds, i)->slave)
+			continue;
+
+		/* Pretend that we already applied the setting, which we
+		 * actually haven't (still haven't done all integrity checks)
+		 */
+		if (i == port)
+			slave_mtu = new_mtu;
+		else
+			slave_mtu = dsa_to_port(ds, i)->slave->mtu;
+
+		if (largest_mtu < slave_mtu)
+			largest_mtu = slave_mtu;
+	}
+
+	cpu_dp = dsa_to_port(ds, port)->cpu_dp;
+
+	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
+	old_master_mtu = master->mtu;
+	new_master_mtu = largest_mtu + cpu_dp->tag_ops->overhead;
+	if (new_master_mtu > mtu_limit)
+		return -ERANGE;
+
+	/* If the master MTU isn't over limit, there's no need to check the CPU
+	 * MTU, since that surely isn't either.
+	 */
+	cpu_mtu = largest_mtu;
+
+	/* Start applying stuff */
+	if (new_master_mtu != old_master_mtu) {
+		err = dsa_master_set_mtu(master, new_master_mtu);
+		if (err < 0)
+			goto out_master_failed;
+
+		err = dsa_port_mtu_change(cpu_dp, cpu_mtu);
+		if (err) {
+			netdev_err(dev, "Failed to change MTU on CPU port\n");
+			goto out_cpu_failed;
+		}
+	}
+
+	err = dsa_port_mtu_change(dp, new_mtu);
+	if (err) {
+		netdev_err(dev, "Failed to change MTU\n");
+		goto out_port_failed;
+	}
+
+	dev->mtu = new_mtu;
+
+	return 0;
+
+out_port_failed:
+	if (new_master_mtu != old_master_mtu) {
+		if (dsa_port_mtu_change(cpu_dp, old_master_mtu -
+					cpu_dp->tag_ops->overhead))
+			dev_err(ds->dev, "Failed to restore MTU on CPU port\n");
+	}
+out_cpu_failed:
+	if (new_master_mtu != old_master_mtu) {
+		if (dsa_master_set_mtu(master, old_master_mtu))
+			netdev_err(master, "Failed to restore MTU\n");
+	}
+out_master_failed:
+	return err;
+}
+
 static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_drvinfo		= dsa_slave_get_drvinfo,
 	.get_regs_len		= dsa_slave_get_regs_len,
@@ -1295,6 +1389,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
 	.ndo_get_devlink_port	= dsa_slave_get_devlink_port,
+	.ndo_change_mtu		= dsa_slave_change_mtu,
 };
 
 static struct device_type dsa_type = {
@@ -1465,7 +1560,10 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	slave_dev->min_mtu = 0;
-	slave_dev->max_mtu = ETH_MAX_MTU;
+	if (ds->ops->port_max_mtu)
+		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
+	else
+		slave_dev->max_mtu = ETH_MAX_MTU;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
@@ -1483,6 +1581,10 @@ int dsa_slave_create(struct dsa_port *port)
 	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
 
+	rtnl_lock();
+	dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
+	rtnl_unlock();
+
 	netif_carrier_off(slave_dev);
 
 	ret = dsa_slave_phy_setup(slave_dev);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index df4abe897ed6..6b0b6f9d219c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -52,6 +52,37 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
+static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
+				 struct dsa_notifier_mtu_info *info)
+{
+	if (ds->index == info->sw_index && port == info->port)
+		return true;
+
+	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+		return true;
+
+	return false;
+}
+
+static int dsa_switch_mtu(struct dsa_switch *ds,
+			  struct dsa_notifier_mtu_info *info)
+{
+	int port, ret;
+
+	if (!ds->ops->port_change_mtu)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_mtu_match(ds, port, info)) {
+			ret = ds->ops->port_change_mtu(ds, port, info->mtu);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int dsa_switch_bridge_join(struct dsa_switch *ds,
 				  struct dsa_notifier_bridge_info *info)
 {
@@ -328,6 +359,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_VLAN_DEL:
 		err = dsa_switch_vlan_del(ds, info);
 		break;
+	case DSA_NOTIFIER_MTU:
+		err = dsa_switch_mtu(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.17.1

