Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E73B539E
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhF0ONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhF0OMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECDFC061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gn32so24481533ejc.2
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sTAjQO9IaYT8e3/0zMpKI01AkicXUpBmuTdj9mnded8=;
        b=NXB4oFiVQUcKWoxwdMdNUq0DmIfXE9tBmSCxDD1b0gswIdqJe5gOLW1I0dXMpv1xrZ
         +UW99sQI+VguGrW1BzZ6fU2cIxP3zE51mGF04APHOVjkNnvaiA2RGa7R2abKC3sLrZoV
         RVkN4L9PPQdL4HapzcCVbcf5gjTFdUaDg+SC4JaDXiyLQ5Q1y8yl5MZgE8EB63qmPeb8
         ztql/LfCGt/zu8NLvSjO7yJQ9KKwg9UCa0/flKN6Ri4qxJMmDRsfVHwxQTDUhnHGZpBI
         rH2q4l8Fnaahp/DiDx/iOab1AyV34WI5djFKoq5L5y21s1bH3JY++liJr2FkO5hDtEgd
         Pv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sTAjQO9IaYT8e3/0zMpKI01AkicXUpBmuTdj9mnded8=;
        b=KS4yDnplJWX4mgyZ1dS5ZQWa2b5gZ8sQbsd3JRgHyandpFs6wcIQimGHhHJTi5SQUk
         kyFs1rBHEQsymRIGISQ4TUTp7gp/aFC8VdSoo0mxKyaa/mIRtkw6oZY99Vx+X/RpH/T+
         OX9mKefXRIrlN1RseoKguTNR0YKxQ0ZfX4QdamvA8o2LgVoFKnpf3UkfSCaSUeW+HCaS
         TXjsN5ZiqtcyD4Bqj9LrDadab/D4kmA7z6DU9JwhoeseUb0Z3+qgXJ4ZJmDUix0wslwp
         9/inw2EA3qljtgZt6G+tOCsjAQTHjGH0H+CsZh20SsxsdlC6YyMxyJuQNhRa40PAHNJc
         F6zw==
X-Gm-Message-State: AOAM531oTgBzQhaaIPo7DRdFyBNOj6TLQN8n0sQx6KqQDLmo+t5NAXoR
        mfi9aW3HqxDpZU7hTvULLPIjhmvUbRU=
X-Google-Smtp-Source: ABdhPJxeX8cg3CkDBdhWqIn3br2nfB9/GzlXZ1iHAS8p3xjw3R8Zob8RIFuLncbI5enkOvKANe5t9w==
X-Received: by 2002:a17:906:f289:: with SMTP id gu9mr19805660ejb.157.1624803027031;
        Sun, 27 Jun 2021 07:10:27 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:26 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 06/15] net: dsa: introduce a separate cross-chip notifier type for host MDBs
Date:   Sun, 27 Jun 2021 17:10:04 +0300
Message-Id: <20210627141013.1273942-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
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

