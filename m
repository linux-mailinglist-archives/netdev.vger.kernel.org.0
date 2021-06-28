Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E66A3B6AB1
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbhF1WDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbhF1WDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03453C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id j11so2729147edq.6
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sTAjQO9IaYT8e3/0zMpKI01AkicXUpBmuTdj9mnded8=;
        b=QhAMUHITugw8VkzicNQ7UA5p+GDo/gxCA6eemwNq4wmXtp6/QP15XuaywDghlD1bt4
         Ia5MCawH10FiwO3dEUWyAx2nTDTh7V52QRkhI5cw9FMIt5kwT1g8SvGOMCsM1weLjAHn
         FYAezK0oC0ypdcxQI9HtN9xHCzjGiDEuhbgykGkiElf1PedbaNmbTj/36iisfngxPxR9
         37Oz5RSM426ZWSKw6iM0NjStDpXwp18wkoQQpI1nxspZl+zB9Fq30WKGSrevGbt2FJPN
         hD4x0wp0qKEnt8aXMqC+2Skvma1LLY2jdvySLTFE8h9RUSnC087tPF6TAFrA4xJXPLms
         xuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sTAjQO9IaYT8e3/0zMpKI01AkicXUpBmuTdj9mnded8=;
        b=rI2qdq/RiQzQvwia7wZDQVHYL1jP4UEIhdRwYRCyM5HBF15fsE3/MheajkewOz4WDW
         kJhefHFu6id5o9sKjLKhMjBB2ImpkfgnPjvgBn4fhGNAHtThT2iExcMFLDQ3e6g1AExU
         nF3nlSmNGJbytLAbPh5tdPdV76ETRrvFgAgjXyb6Z7aCzUP9o84cGFB/pQ+n1x9mK1Cw
         Wj7zEUz4lXYRMiViQ77WTq3hEjY2PY6sfacNnfc59/m9ASprJWVBzGw9+1/cnqT4oJxX
         DbefJLjM79VTC3wo06l9LeIgCRxH9BIWWtDysw3RU38D7dHV0RdKmeewCAD7rUl0FfFr
         YIxQ==
X-Gm-Message-State: AOAM530TOAbNVzBrD2c90xSM5d5GcJBkoOPqabIEe7abhUacHg1i1OHz
        TIHWqSTfHLKi/MsSPjEiG96Ke5ZYL98=
X-Google-Smtp-Source: ABdhPJy7zou+ZOGgQXLNc31TK7MdcRzCukpfLWWby2jNnrkv5W8LHrO3UsmYQ4T6AGnuaWUerqebgQ==
X-Received: by 2002:a50:a6db:: with SMTP id f27mr36471301edc.18.1624917639422;
        Mon, 28 Jun 2021 15:00:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:39 -0700 (PDT)
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
Subject: [PATCH v4 net-next 05/14] net: dsa: introduce a separate cross-chip notifier type for host MDBs
Date:   Tue, 29 Jun 2021 01:00:02 +0300
Message-Id: <20210628220011.1910096-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Commit abd49535c380 ("net: dsa: execute dsa_switch_mdb_add only for
routing port in cross-chip topologies") does a surprisingly good job
even for the SWITCHDEV_OBJ_ID_HOST_MDB use case, where DSA simply
translates a switchdev object received on dp into a cross-chip notifier
for dp->cpu_dp.

To visualize how that works, imagine the daisy chain topology below and
consider a SWITCHDEV_OBJ_ID_HOST_MDB object emitted on sw2p0. How does
the cross-chip notifier know to match on all the right ports (sw0p4, the
dedicated CPU port, sw1p4, an upstream DSA link, and sw2p4, another
upstream DSA link)?

                                                |
       sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
    [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
    [       ] [       ] [       ] [       ] [   x   ]
                                      |
                                      +---------+
                                                |
       sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
    [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
    [       ] [       ] [       ] [       ] [   x   ]
                                      |
                                      +---------+
                                                |
       sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
    [  user ] [  user ] [  user ] [  user ] [  dsa  ]
    [       ] [       ] [       ] [       ] [   x   ]

The answer is simple: the dedicated CPU port of sw2p0 is sw0p4, and
dsa_routing_port returns the upstream port for all switches.

That is fine, but there are other topologies where this does not work as
well. There are trees with "H" topologies in the wild, where there are 2
or more switches with DSA links between them, but every switch has its
dedicated CPU port. For these topologies, it seems stupid for the neighbor
switches to install an MDB entry on the routing port, since these
multicast addresses are fundamentally different than the usual ones we
support (and that is the justification for this patch, to introduce the
concept of a termination plane multicast MAC address, as opposed to a
forwarding plane multicast MAC address).

For example, when a SWITCHDEV_OBJ_ID_HOST_MDB would get added to sw0p0,
without this patch, it would get treated as a regular port MDB on sw0p2
and it would match on the ports below (including the sw1p3 routing port).

                         |                                  |
    sw0p0     sw0p1     sw0p2     sw0p3          sw1p3     sw1p2     sw1p1     sw1p0
 [  user ] [  user ] [  cpu  ] [  dsa  ]      [  dsa  ] [  cpu  ] [  user ] [  user ]
 [       ] [       ] [   x   ] [       ] ---- [   x   ] [       ] [       ] [       ]

With the patch, the host MDB notifier on sw0p0 matches only on the local
switch, which is what we want for a termination plane address.

                         |                                  |
    sw0p0     sw0p1     sw0p2     sw0p3          sw1p3     sw1p2     sw1p1     sw1p0
 [  user ] [  user ] [  cpu  ] [  dsa  ]      [  dsa  ] [  cpu  ] [  user ] [  user ]
 [       ] [       ] [   x   ] [       ] ---- [       ] [       ] [       ] [       ]

Name this new matching function "dsa_switch_host_address_match" since we
will be reusing it soon for host FDB entries as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  6 +++++
 net/dsa/port.c     | 24 ++++++++++++++++++
 net/dsa/slave.c    | 10 ++------
 net/dsa/switch.c   | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c8712942002f..cd65933d269b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -27,6 +27,8 @@ enum {
 	DSA_NOTIFIER_LAG_LEAVE,
 	DSA_NOTIFIER_MDB_ADD,
 	DSA_NOTIFIER_MDB_DEL,
+	DSA_NOTIFIER_HOST_MDB_ADD,
+	DSA_NOTIFIER_HOST_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
@@ -214,6 +216,10 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_host_mdb_add(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_host_mdb_del(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 			      struct switchdev_brport_flags flags,
 			      struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 46089dd2b2ec..47f45f795f44 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -681,6 +681,30 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
 }
 
+int dsa_port_host_mdb_add(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_notifier_mdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mdb = mdb,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+}
+
+int dsa_port_host_mdb_del(const struct dsa_port *dp,
+			  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_notifier_mdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.mdb = mdb,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+}
+
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct netlink_ext_ack *extack)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 64acb1e11cd7..4b1d738bc3bc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -418,10 +418,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		/* DSA can directly translate this to a normal MDB add,
-		 * but on the CPU port.
-		 */
-		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
@@ -495,10 +492,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		if (!dsa_port_offloads_bridge(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		/* DSA can directly translate this to a normal MDB add,
-		 * but on the CPU port.
-		 */
-		err = dsa_port_mdb_del(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c1e5afafe633..7c5fe60a3763 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -154,6 +154,30 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	return 0;
 }
 
+/* Matches for all upstream-facing ports (the CPU port and all upstream-facing
+ * DSA links) that sit between the targeted port on which the notifier was
+ * emitted and its dedicated CPU port.
+ */
+static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
+					  int info_sw_index, int info_port)
+{
+	struct dsa_port *targeted_dp, *cpu_dp;
+	struct dsa_switch *targeted_ds;
+
+	targeted_ds = dsa_switch_find(ds->dst->index, info_sw_index);
+	if (WARN_ON(!targeted_ds))
+		return false;
+
+	targeted_dp = dsa_to_port(targeted_ds, info_port);
+	cpu_dp = targeted_dp->cpu_dp;
+
+	if (dsa_switch_is_upstream_of(ds, targeted_ds))
+		return port == dsa_towards_port(ds, cpu_dp->ds->index,
+						cpu_dp->index);
+
+	return false;
+}
+
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
@@ -258,6 +282,39 @@ static int dsa_switch_mdb_del(struct dsa_switch *ds,
 	return 0;
 }
 
+static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
+				   struct dsa_notifier_mdb_info *info)
+{
+	int err = 0;
+	int port;
+
+	if (!ds->ops->port_mdb_add)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = ds->ops->port_mdb_add(ds, port, info->mdb);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
+static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
+				   struct dsa_notifier_mdb_info *info)
+{
+	if (!ds->ops->port_mdb_del)
+		return -EOPNOTSUPP;
+
+	if (ds->index == info->sw_index)
+		return ds->ops->port_mdb_del(ds, info->port, info->mdb);
+
+	return 0;
+}
+
 static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 				  struct dsa_notifier_vlan_info *info)
 {
@@ -441,6 +498,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_MDB_DEL:
 		err = dsa_switch_mdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HOST_MDB_ADD:
+		err = dsa_switch_host_mdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_HOST_MDB_DEL:
+		err = dsa_switch_host_mdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_VLAN_ADD:
 		err = dsa_switch_vlan_add(ds, info);
 		break;
-- 
2.25.1

