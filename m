Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76340202A63
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgFULqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729945AbgFULqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:46:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00524C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:22 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id y6so11331413edi.3
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=snIEKimqcXyeN5KSvoZfJCvkON3qv4Zsgq2xXrltXgw=;
        b=MB5oFfo2Z9xNxLA/ME+hZY7ktjw9Zb4IjYdWWSOe1SZGw4eHhZrmfxIdkF4ruVpPJJ
         iwtQ/9ISt4qjhtbLsuBvSDfB8riMuD1V2nnUDGEC53LpZHZFyyretytYZwBG30Jv+DsD
         mITPb45JJ6Tj3G/ss0xny0HN1HLqVDaI5UJf9KikYCeUwHC25NK/h9rNr1O4/J10+Lbd
         85xdPagNCwQwQtV3IjhIlFyZPokHGxLX8a69iDBXNBSn+rjizEddKX/qmNUu1UXx9xyy
         YdhMSSxLYbj526irK9rZhYdIYVK4ausKA+ZKAdhTweRMEPiBpAMQtDjhyWFFzjWas5nS
         NMAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=snIEKimqcXyeN5KSvoZfJCvkON3qv4Zsgq2xXrltXgw=;
        b=nt29R5DC4dbXKtmxCK9R2rib1JWjqWDVpyO9qcoJTVeg/QdboGMzDglWJCo1B9bx0+
         yR2pDo+LZB2C5OeRvaiTm5Rh22U8fYgoGkBUgTFwL1C29iJQfwrzfj7l2MXr2GGRgK1X
         zdviNiN5+16gxluKtJenVSywIAm3sqvNI457SvUuKeDxcXyzWoKj+IyQBYCWPGIij4/D
         RHHWkC+nNR1d4L0CPhiwOOZsB7calHsGs7vJYxpfm4O73+RWP4U3YFBZ8Ngjq5Ehge9d
         RG3gpIRX1cDWprdbccjcVOHsxJkr7rxm2mC2O6bFhwVFp8AcX/yYxdB8V1Q0qyxyTsZF
         JBxA==
X-Gm-Message-State: AOAM5329uWRs7OFdLJ6k4iS2tE1p9uxiHsrQVCWF1feGQijBK7fby8y4
        wHFFtqW3wJUVPWP9TJVcc2komhWc
X-Google-Smtp-Source: ABdhPJyikVo/EQU7E+VbaJn/UM06JHctMOjEol9/sREQNl15TP6UqtiujpGuGMhxrn6vG6/Iybcl4g==
X-Received: by 2002:aa7:d2d6:: with SMTP id k22mr12283811edr.109.1592739981746;
        Sun, 21 Jun 2020 04:46:21 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id k23sm9155508ejg.89.2020.06.21.04.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:46:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net-next 3/5] net: dsa: felix: call port mdb operations from ocelot
Date:   Sun, 21 Jun 2020 14:46:01 +0300
Message-Id: <20200621114603.119608-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621114603.119608-1-olteanv@gmail.com>
References: <20200621114603.119608-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This adds the mdb hooks in felix and exports the mdb functions from
ocelot.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 26 ++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c     | 23 ++++++++---------------
 drivers/net/ethernet/mscc/ocelot.h     |  5 -----
 drivers/net/ethernet/mscc/ocelot_net.c | 26 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              |  4 ++++
 5 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 66648986e6e3..25046777c993 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -59,6 +59,29 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
+/* This callback needs to be present */
+static int felix_mdb_prepare(struct dsa_switch *ds, int port,
+			     const struct switchdev_obj_port_mdb *mdb)
+{
+	return 0;
+}
+
+static void felix_mdb_add(struct dsa_switch *ds, int port,
+			  const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_mdb_add(ocelot, port, mdb);
+}
+
+static int felix_mdb_del(struct dsa_switch *ds, int port,
+			 const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_mdb_del(ocelot, port, mdb);
+}
+
 static void felix_bridge_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -771,6 +794,9 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump		= felix_fdb_dump,
 	.port_fdb_add		= felix_fdb_add,
 	.port_fdb_del		= felix_fdb_del,
+	.port_mdb_prepare	= felix_mdb_prepare,
+	.port_mdb_add		= felix_mdb_add,
+	.port_mdb_del		= felix_mdb_del,
 	.port_bridge_join	= felix_bridge_join,
 	.port_bridge_leave	= felix_bridge_leave,
 	.port_stp_state_set	= felix_bridge_stp_state_set,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4aadb65a6af8..468eaf5916e5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -944,16 +944,12 @@ static struct ocelot_multicast *ocelot_multicast_get(struct ocelot *ocelot,
 	return NULL;
 }
 
-int ocelot_port_obj_add_mdb(struct net_device *dev,
-			    const struct switchdev_obj_port_mdb *mdb,
-			    struct switchdev_trans *trans)
+int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
+			const struct switchdev_obj_port_mdb *mdb)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
-	int port = priv->chip_port;
 	u16 vid = mdb->vid;
 	bool new = false;
 
@@ -991,17 +987,14 @@ int ocelot_port_obj_add_mdb(struct net_device *dev,
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
-EXPORT_SYMBOL(ocelot_port_obj_add_mdb);
+EXPORT_SYMBOL(ocelot_port_mdb_add);
 
-int ocelot_port_obj_del_mdb(struct net_device *dev,
-			    const struct switchdev_obj_port_mdb *mdb)
+int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
+			const struct switchdev_obj_port_mdb *mdb)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
-	int port = priv->chip_port;
 	u16 vid = mdb->vid;
 
 	if (port == ocelot->npi)
@@ -1032,7 +1025,7 @@ int ocelot_port_obj_del_mdb(struct net_device *dev,
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
-EXPORT_SYMBOL(ocelot_port_obj_del_mdb);
+EXPORT_SYMBOL(ocelot_port_mdb_del);
 
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 0c23734a87be..be4a41646e5e 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -97,11 +97,6 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
-int ocelot_port_obj_del_mdb(struct net_device *dev,
-			    const struct switchdev_obj_port_mdb *mdb);
-int ocelot_port_obj_add_mdb(struct net_device *dev,
-			    const struct switchdev_obj_port_mdb *mdb,
-			    struct switchdev_trans *trans);
 
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 80cb1873e9d9..1bad146a0105 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -795,6 +795,32 @@ static int ocelot_port_vlan_del_vlan(struct net_device *dev,
 	return 0;
 }
 
+static int ocelot_port_obj_add_mdb(struct net_device *dev,
+				   const struct switchdev_obj_port_mdb *mdb,
+				   struct switchdev_trans *trans)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	return ocelot_port_mdb_add(ocelot, port, mdb);
+}
+
+static int ocelot_port_obj_del_mdb(struct net_device *dev,
+				   const struct switchdev_obj_port_mdb *mdb)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_port_mdb_del(ocelot, port, mdb);
+}
+
 static int ocelot_port_obj_add(struct net_device *dev,
 			       const struct switchdev_obj *obj,
 			       struct switchdev_trans *trans,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index fa2c3904049e..80415b63ccfa 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -641,5 +641,9 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress);
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress);
+int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
+			const struct switchdev_obj_port_mdb *mdb);
+int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
+			const struct switchdev_obj_port_mdb *mdb);
 
 #endif
-- 
2.25.1

