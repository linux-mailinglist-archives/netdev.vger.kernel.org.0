Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7131C07DE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgD3UZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgD3UZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:25:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40376C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:50 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so8800781wrv.10
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dpXI1V5ghMRhSJL8SIXWkXSPLtONjElZBTYDshyr6ZM=;
        b=WsCTqsGjLYccKUjY2fb9LWpK8fpE+bTSz0p48q1AQR5R1/WmMuxxxTbuVdk5ph/r2o
         wErZsvfegW7vP3SUEYXTqTyoxi6Dpau0ItJFUkkmWWP/9p+kKLtWbtil2unKIzjM2ApY
         1cWB5JYbZaEJjgV+O/gAo6401bZsFsfWVFx6ifDSZql40M6j9K/zFMMv1PheZmqFefuA
         qh/wAsi4kOcp3J5geRs9ij9hw4wfaBHuDcjhTzalo4mBc/AC11RvEQgm5NrD2vT8o10I
         0WOP3O3EJMLRDp9IXBaLTKTkDVRWUzVefwbdcza3egpwc0ts/4w+dO3yZ78sJCu/yecm
         +f+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dpXI1V5ghMRhSJL8SIXWkXSPLtONjElZBTYDshyr6ZM=;
        b=icYvcPDfdJZtw9x6Bt2uKm32V6gNHxx6hv/KDdBF7iPMuDLuJJnrGOq9rCQ1GyUqNG
         Fp3+TNa8ZMkptCgLf8GkKRPv2G/BOokWtKMm429VkpPtJ91j5hHv6MxmrNC0J1+BjSNA
         0/Pzvg4WDGEAT1etX1oYYQNMEcc3MwYdUnMv05Q1DnD/lJUq7/dmBPo78gPrm0cLtwK5
         k8fXxlFpipNpe7SiCL60vEln7V5rzlRjQdMlrhYz7cSwaQPFvFtk89eRy4iE9szNneXM
         Xntl3W2SUTJPFe92XsfQxQWj9kMneCFuMU3f6Xo2TqUD4So/7ZpaFw/bwHOt2cd/KRPg
         CNgA==
X-Gm-Message-State: AGi0PuaLAzQTbFqOLS7xJy+C9qE6vp7AFZ6QTc6vdB2b4G7suG1aziOf
        QUK7AHjyeY69/XNHAwI0RMs=
X-Google-Smtp-Source: APiQypLPqqJsOdu05oQ/k6/tewSiLIB1LwDkEhaDfn7giqBX3lwp3800LmW+gX5cf65uqR1suwJPAw==
X-Received: by 2002:adf:f844:: with SMTP id d4mr343325wrq.362.1588278348913;
        Thu, 30 Apr 2020 13:25:48 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id f8sm1188462wrm.14.2020.04.30.13.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 13:25:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 2/4] net: dsa: permit cross-chip bridging between all trees in the system
Date:   Thu, 30 Apr 2020 23:25:40 +0300
Message-Id: <20200430202542.11797-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430202542.11797-1-olteanv@gmail.com>
References: <20200430202542.11797-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

One way of utilizing DSA is by cascading switches which do not all have
compatible taggers. Consider the following real-life topology:

      +---------------------------------------------------------------+
      | LS1028A                                                       |
      |               +------------------------------+                |
      |               |      DSA master for Felix    |                |
      |               |(internal ENETC port 2: eno2))|                |
      |  +------------+------------------------------+-------------+  |
      |  | Felix embedded L2 switch                                |  |
      |  |                                                         |  |
      |  | +--------------+   +--------------+   +--------------+  |  |
      |  | |DSA master for|   |DSA master for|   |DSA master for|  |  |
      |  | |  SJA1105 1   |   |  SJA1105 2   |   |  SJA1105 3   |  |  |
      |  | |(Felix port 1)|   |(Felix port 2)|   |(Felix port 3)|  |  |
      +--+-+--------------+---+--------------+---+--------------+--+--+

+-----------------------+ +-----------------------+ +-----------------------+
|   SJA1105 switch 1    | |   SJA1105 switch 2    | |   SJA1105 switch 3    |
+-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+
|sw1p0|sw1p1|sw1p2|sw1p3| |sw2p0|sw2p1|sw2p2|sw2p3| |sw3p0|sw3p1|sw3p2|sw3p3|
+-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+

The above can be described in the device tree as follows (obviously not
complete):

mscc_felix {
	dsa,member = <0 0>;
	ports {
		port@4 {
			ethernet = <&enetc_port2>;
		};
	};
};

sja1105_switch1 {
	dsa,member = <1 1>;
	ports {
		port@4 {
			ethernet = <&mscc_felix_port1>;
		};
	};
};

sja1105_switch2 {
	dsa,member = <2 2>;
	ports {
		port@4 {
			ethernet = <&mscc_felix_port2>;
		};
	};
};

sja1105_switch3 {
	dsa,member = <3 3>;
	ports {
		port@4 {
			ethernet = <&mscc_felix_port3>;
		};
	};
};

Basically we instantiate one DSA switch tree for every hardware switch
in the system, but we still give them globally unique switch IDs (will
come back to that later). Having 3 disjoint switch trees makes the
tagger drivers "just work", because net devices are registered for the
3 Felix DSA master ports, and they are also DSA slave ports to the ENETC
port. So packets received on the ENETC port are stripped of their
stacked DSA tags one by one.

Currently, hardware bridging between ports on the same sja1105 chip is
possible, but switching between sja1105 ports on different chips is
handled by the software bridge. This is fine, but we can do better.

In fact, the dsa_8021q tag used by sja1105 is compatible with cascading.
In other words, a sja1105 switch can correctly parse and route a packet
containing a dsa_8021q tag. So if we could enable hardware bridging on
the Felix DSA master ports, cross-chip bridging could be completely
offloaded.

Such as system would be used as follows:

ip link add dev br0 type bridge && ip link set dev br0 up
for port in sw0p0 sw0p1 sw0p2 sw0p3 \
	    sw1p0 sw1p1 sw1p2 sw1p3 \
	    sw2p0 sw2p1 sw2p2 sw2p3; do
	ip link set dev $port master br0
done

The above makes switching between ports on the same row be performed in
hardware, and between ports on different rows in software. Now assume
the Felix switch ports are called swp0, swp1, swp2. By running the
following extra commands:

ip link add dev br1 type bridge && ip link set dev br1 up
for port in swp0 swp1 swp2; do
	ip link set dev $port master br1
done

the CPU no longer sees packets which traverse sja1105 switch boundaries
and can be forwarded directly by Felix. The br1 bridge would not be used
for any sort of traffic termination.

For this to work, we need to give drivers an opportunity to listen for
bridging events on DSA trees other than their own, and pass that other
tree index as argument. I have made the assumption, for the moment, that
the other existing DSA notifiers don't need to be broadcast to other
trees. That assumption might turn out to be incorrect. But in the
meantime, introduce a dsa_broadcast function, similar in purpose to
dsa_port_notify, which is used only by the bridging notifiers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 include/net/dsa.h                | 10 ++++++----
 net/dsa/dsa_priv.h               |  1 +
 net/dsa/port.c                   | 23 +++++++++++++++++++++--
 net/dsa/switch.c                 | 21 +++++++++++++++------
 5 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dd8a5666a584..9ecfbe0c4f6c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2233,26 +2233,34 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds, int dev,
+static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
 					   int port, struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (tree_index != ds->dst->index)
+		return 0;
+
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_pvt_map(chip, dev, port);
+	err = mv88e6xxx_pvt_map(chip, sw_index, port);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
 }
 
-static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds, int dev,
+static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
+					     int tree_index, int sw_index,
 					     int port, struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
+	if (tree_index != ds->dst->index)
+		return;
+
 	mv88e6xxx_reg_lock(chip);
-	if (mv88e6xxx_pvt_map(chip, dev, port))
+	if (mv88e6xxx_pvt_map(chip, sw_index, port))
 		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
 	mv88e6xxx_reg_unlock(chip);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3c0ae84156c8..bd5561dacb13 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -574,10 +574,12 @@ struct dsa_switch_ops {
 	/*
 	 * Cross-chip operations
 	 */
-	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int sw_index,
-					 int port, struct net_device *br);
-	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int sw_index,
-					  int port, struct net_device *br);
+	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int tree_index,
+					 int sw_index, int port,
+					 struct net_device *br);
+	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
+					  int sw_index, int port,
+					  struct net_device *br);
 
 	/*
 	 * PTP functionality
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6d9a1ef65fa0..a1a0ae242012 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -35,6 +35,7 @@ struct dsa_notifier_ageing_time_info {
 /* DSA_NOTIFIER_BRIDGE_* */
 struct dsa_notifier_bridge_info {
 	struct net_device *br;
+	int tree_index;
 	int sw_index;
 	int port;
 };
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a58fdd362574..ebc8d6cbd1d4 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -13,6 +13,23 @@
 
 #include "dsa_priv.h"
 
+static int dsa_broadcast(unsigned long e, void *v)
+{
+	struct dsa_switch_tree *dst;
+	int err = 0;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		struct raw_notifier_head *nh = &dst->nh;
+
+		err = raw_notifier_call_chain(nh, e, v);
+		err = notifier_to_errno(err);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 {
 	struct raw_notifier_head *nh = &dp->ds->dst->nh;
@@ -120,6 +137,7 @@ void dsa_port_disable(struct dsa_port *dp)
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
+		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.br = br,
@@ -136,7 +154,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	 */
 	dp->bridge_dev = br;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_BRIDGE_JOIN, &info);
+	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN, &info);
 
 	/* The bridging is rolled back on error */
 	if (err) {
@@ -150,6 +168,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 {
 	struct dsa_notifier_bridge_info info = {
+		.tree_index = dp->ds->dst->index,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.br = br,
@@ -161,7 +180,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dp->bridge_dev = NULL;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_BRIDGE_LEAVE, &info);
+	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index f3c32ff552b3..86c8dc5c32a0 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -89,11 +89,16 @@ static int dsa_switch_mtu(struct dsa_switch *ds,
 static int dsa_switch_bridge_join(struct dsa_switch *ds,
 				  struct dsa_notifier_bridge_info *info)
 {
-	if (ds->index == info->sw_index && ds->ops->port_bridge_join)
+	struct dsa_switch_tree *dst = ds->dst;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_bridge_join)
 		return ds->ops->port_bridge_join(ds, info->port, info->br);
 
-	if (ds->index != info->sw_index && ds->ops->crosschip_bridge_join)
-		return ds->ops->crosschip_bridge_join(ds, info->sw_index,
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_bridge_join)
+		return ds->ops->crosschip_bridge_join(ds, info->tree_index,
+						      info->sw_index,
 						      info->port, info->br);
 
 	return 0;
@@ -103,13 +108,17 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 				   struct dsa_notifier_bridge_info *info)
 {
 	bool unset_vlan_filtering = br_vlan_enabled(info->br);
+	struct dsa_switch_tree *dst = ds->dst;
 	int err, i;
 
-	if (ds->index == info->sw_index && ds->ops->port_bridge_leave)
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_bridge_join)
 		ds->ops->port_bridge_leave(ds, info->port, info->br);
 
-	if (ds->index != info->sw_index && ds->ops->crosschip_bridge_leave)
-		ds->ops->crosschip_bridge_leave(ds, info->sw_index, info->port,
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_bridge_join)
+		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
+						info->sw_index, info->port,
 						info->br);
 
 	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
-- 
2.17.1

