Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B37A195F59
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgC0T4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:56:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44727 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgC0T4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:56:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id m17so12921786wrw.11
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vGWyHR5PnoK0QK8EGZLV0dLpAQtyOrVuB3SIkacZcYs=;
        b=q7RkjNdfDTJ3fYblwLU002ZLmCZBHcFLu/SroA1Rc9SgKLmELYi0YAqPk2GIO5yBeR
         dh18QKIwzXvilqM7QoqTBgpQ+hv1OVJvB9udq/XOs5xIXc7T+P6vauDukQa52aVf7fWm
         dW6FYjpG8gHcMvhKUoCokyzAbOe4SryfUl7pH74lyBVYcJQcfEdMDQjwAIuA08wbd9BD
         hgc4ZzCbWBD78rPUBKpP4l//s2KGmguGa6lsKT8fXZ59IBWd8dXgUKZ9hQ+I4L6TAtJQ
         Ty4woL230oteHEXzEIBwtM0IRjF28nP5O0Xi+hYfkxjAD59iY+jJmXCYH/mixEcFxnoS
         2YWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vGWyHR5PnoK0QK8EGZLV0dLpAQtyOrVuB3SIkacZcYs=;
        b=H5riy9awY8E1+Bohq9D7Wv/ieO0CHHT1h5RREWXxkOwWgWOGYeAmEL8lcJZlnYrT1x
         WfiVxsOr8WiHadHQcvOJgmWRrs522dSc65mo40FTPI/qFvwWHQsJNxSoo2byPbvUbUjj
         3qXRSbbMbetUCh18qiGmyDuFeNHoOglRo0TFAoXfzN3A4soE2uZ0kWFn4m15k0pfRLqO
         5OS550F+xkZB17w9rNA8UiGmmpXDQ9sK5I5GZShoNzSManPd3hr5rmOXIy0EZWQlZW7D
         6HKllvZjGxNQ8pDtv7LEtirhvdZ7b8CzPthpC+eV2JIK/o8lV/Z2sFjM3P1FfI9STs82
         UunQ==
X-Gm-Message-State: ANhLgQ3B7CNmRrW0iqS9ntyoa3qCG3VE3NUUHuRXoRY/kEC/gSG/gy68
        2zV9fCf5UPWNmg94I2gKP4Q=
X-Google-Smtp-Source: ADFU+vvJxXp2JqkZyvSSLmxSkrWTBHMosexHI68GiefDrOg5PNsVDaiXAJ21w5x3h5exBS0H9hA/RQ==
X-Received: by 2002:a05:6000:4e:: with SMTP id k14mr1077373wrx.267.1585338957019;
        Fri, 27 Mar 2020 12:55:57 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:55:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 3/8] net: dsa: configure the MTU for switch ports
Date:   Fri, 27 Mar 2020 21:55:42 +0200
Message-Id: <20200327195547.11583-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
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
  congestion, or work around various network segments that add extra
  headers to packets which can't be fragmented.

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

Some changes were made around dsa_master_set_mtu(), function which was
now removed, for 2 reasons:
  - dev_set_mtu() already calls dev_validate_mtu(), so it's redundant to
    do the same thing in DSA
  - __dev_set_mtu() returns 0 if ops->ndo_change_mtu is an absent method
That is to say, there's no need for this function in DSA, we can safely
call dev_set_mtu() directly, take the rtnl lock when necessary, and just
propagate whatever errors get reported (since the user probably wants to
be informed).

Some inspiration (mainly in the MTU DSA notifier) was taken from a
vaguely similar patch from Murali and Florian, who are credited as
co-developers down below.

Co-developed-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Co-developed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Made the dev_set_mtu on the master port non-fatal initially (when called
from outside dsa_slave_change_mtu, for drivers that do not support the
.port_change_mtu method).

Changes in v3:
- Introduced the propagate_upstream variable in the notifier structure
  to prevent intermediate MTU configuration to be propagated upstream
  when it is going to be overwritten anyway by the MTU setting on the
  CPU port.
- Refined the dsa_switch_mtu_match such that the CPU port on the local
  switch does not match (it is explicitly programmed).
- Removed the dsa_master_set_mtu function (explanation in commit
  message).

Changes in v2:
Introduced a DSA switch notifier for propagating the MTU setting towards
upstream switches.

 include/net/dsa.h  |  10 +++++
 net/dsa/dsa_priv.h |  11 +++++
 net/dsa/master.c   |  21 +++------
 net/dsa/port.c     |  13 ++++++
 net/dsa/slave.c    | 105 ++++++++++++++++++++++++++++++++++++++++++++-
 net/dsa/switch.c   |  37 ++++++++++++++++
 6 files changed, 181 insertions(+), 16 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index beeb81a532e3..8fc34d70a77d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -579,6 +579,16 @@ struct dsa_switch_ops {
 				     struct devlink_param_gset_ctx *ctx);
 	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
 				     struct devlink_param_gset_ctx *ctx);
+
+	/*
+	 * MTU change functionality. Switches can also adjust their MRU through
+	 * this method. By MTU, one understands the SDU (L2 payload) length.
+	 * If the switch needs to account for the DSA tag on the CPU port, this
+	 * method needs to to do so privately.
+	 */
+	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
+				   int new_mtu);
+	int	(*port_max_mtu)(struct dsa_switch *ds, int port);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 760e6ea3178a..da3be60beefe 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -22,6 +22,7 @@ enum {
 	DSA_NOTIFIER_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
+	DSA_NOTIFIER_MTU,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -61,6 +62,14 @@ struct dsa_notifier_vlan_info {
 	int port;
 };
 
+/* DSA_NOTIFIER_MTU */
+struct dsa_notifier_mtu_info {
+	bool propagate_upstream;
+	int sw_index;
+	int port;
+	int mtu;
+};
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
@@ -127,6 +136,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct switchdev_trans *trans);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
 			 struct switchdev_trans *trans);
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
+			bool propagate_upstream);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index bd44bde272f4..b5c535af63a3 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -314,20 +314,6 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp)
-{
-	unsigned int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
-	int err;
-
-	rtnl_lock();
-	if (mtu <= dev->max_mtu) {
-		err = dev_set_mtu(dev, mtu);
-		if (err)
-			netdev_dbg(dev, "Unable to set MTU to include for DSA overheads\n");
-	}
-	rtnl_unlock();
-}
-
 static void dsa_master_reset_mtu(struct net_device *dev)
 {
 	int err;
@@ -344,7 +330,12 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
 	int ret;
 
-	dsa_master_set_mtu(dev,  cpu_dp);
+	rtnl_lock();
+	ret = dev_set_mtu(dev, ETH_DATA_LEN + cpu_dp->tag_ops->overhead);
+	rtnl_unlock();
+	if (ret)
+		netdev_warn(dev, "error %d setting MTU to include DSA overhead\n",
+			    ret);
 
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a18e65a474a5..231b2d494f1c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -297,6 +297,19 @@ int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 	return ds->ops->port_egress_floods(ds, port, true, mrouter);
 }
 
+int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
+			bool propagate_upstream)
+{
+	struct dsa_notifier_mtu_info info = {
+		.sw_index = dp->ds->index,
+		.propagate_upstream = propagate_upstream,
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
index 5f782fa3029f..1a99bbab0722 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1218,6 +1218,96 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
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
+		err = dev_set_mtu(master, new_master_mtu);
+		if (err < 0)
+			goto out_master_failed;
+
+		/* We only need to propagate the MTU of the CPU port to
+		 * upstream switches.
+		 */
+		err = dsa_port_mtu_change(cpu_dp, cpu_mtu, true);
+		if (err)
+			goto out_cpu_failed;
+	}
+
+	err = dsa_port_mtu_change(dp, new_mtu, false);
+	if (err)
+		goto out_port_failed;
+
+	dev->mtu = new_mtu;
+
+	return 0;
+
+out_port_failed:
+	if (new_master_mtu != old_master_mtu)
+		dsa_port_mtu_change(cpu_dp, old_master_mtu -
+				    cpu_dp->tag_ops->overhead,
+				    true);
+out_cpu_failed:
+	if (new_master_mtu != old_master_mtu)
+		dev_set_mtu(master, old_master_mtu);
+out_master_failed:
+	return err;
+}
+
 static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.get_drvinfo		= dsa_slave_get_drvinfo,
 	.get_regs_len		= dsa_slave_get_regs_len,
@@ -1295,6 +1385,7 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
 	.ndo_get_devlink_port	= dsa_slave_get_devlink_port,
+	.ndo_change_mtu		= dsa_slave_change_mtu,
 };
 
 static struct device_type dsa_type = {
@@ -1465,7 +1556,10 @@ int dsa_slave_create(struct dsa_port *port)
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
@@ -1483,6 +1577,15 @@ int dsa_slave_create(struct dsa_port *port)
 	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
 
+	rtnl_lock();
+	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
+	rtnl_unlock();
+	if (ret && ret != -EOPNOTSUPP) {
+		dev_err(ds->dev, "error %d setting MTU on port %d\n",
+			ret, port->index);
+		goto out_free;
+	}
+
 	netif_carrier_off(slave_dev);
 
 	ret = dsa_slave_phy_setup(slave_dev);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index df4abe897ed6..f3c32ff552b3 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -52,6 +52,40 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
+static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
+				 struct dsa_notifier_mtu_info *info)
+{
+	if (ds->index == info->sw_index)
+		return (port == info->port) || dsa_is_dsa_port(ds, port);
+
+	if (!info->propagate_upstream)
+		return false;
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
@@ -328,6 +362,9 @@ static int dsa_switch_event(struct notifier_block *nb,
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

