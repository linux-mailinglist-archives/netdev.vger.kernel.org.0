Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7331EA93
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 14:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhBRNsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:48:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:43283 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhBRLti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 06:49:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613648977; x=1645184977;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZwkPmjJG1PdO1l08+jLhIA6XO/0lLGVMxamIdskfH3w=;
  b=OijV5FXkkssjrKfArlXuDbNCN5GkEmXYz6qCbYkEHR6oWd5k1B+a0H4+
   jtEtbyoc2Jh2IFo5FkowJxcVYyObOpuMpW5NzOCewkFhkOHVZES9Um4gR
   VThKcQpmnStJY4aEXMs4x+LTem1qtEt9HLjXJYBoAg33Buy5GvenZtH+l
   pXU5VgJ/g7biHTt0U/FcLDrO05NQacjjyLWZbEvy/VXZJLoTSbofr5pzr
   IP2DVp3jGKPrjT2InLKXGJ7Qg6chbGVjFRlIUwZz6FUmCuHsK/PegRF0v
   G7hn0CnjEve2u6rtW2y6vYnGJBJChhuLrojOEJ9g78MjU0M+uDIKB83iL
   Q==;
IronPort-SDR: jGQdAYUA41LJ03PZDcZaAA2lJhVfQRVCMYOvcMOzPtAZ8nZYU1AohiWCRR9uw7W6pIz+eeEZZk
 4cztwbnsSarMfDn2jH71c018Wy88aUNxJCXokMtNlHYpBC0iTUY4Hc20XhaWJO+a5rnmTV04Gi
 ddcj3kLN4iiNBrPPZstJEWLl28cMsdf9ib0Z2bmFumqRN7kRua8RtoqYVLCK3PdMUk8wDPmhHe
 WHKddihCDQUNSW2j0ynA9r0HN08eWXQYMzUkyiCv6bhX5WJ8LzbCZouCh76OsS0zgNQGofOsGj
 uI4=
X-IronPort-AV: E=Sophos;i="5.81,187,1610434800"; 
   d="scan'208";a="110225594"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2021 04:48:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Feb 2021 04:48:10 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 18 Feb 2021 04:48:08 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: mscc: Fix MRP switchdev driver
Date:   Thu, 18 Feb 2021 12:47:26 +0100
Message-ID: <20210218114726.648927-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the ocelot MRP switchdev driver such that also DSA
driver can use these functions. Before the driver presumed that the
net_device uses a 'struct ocelot_port_private' as priv which was wrong.

The only reason for using ocelot_port_private was to access the
net_device, but this can be passed as an argument because we already
have this information. Therefore update the functions to have also the
net_device parameter.

Fixes: a026c50b599fa ("net: dsa: felix: Add support for MRP")
Fixes: d8ea7ff3995ea ("net: mscc: ocelot: Add support for MRP")
Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

---
This was tested using switchdev and only compile tested the DSA driver.
---
 drivers/net/dsa/ocelot/felix.c         | 20 ++++++++---
 drivers/net/ethernet/mscc/ocelot_mrp.c | 49 ++++++++------------------
 drivers/net/ethernet/mscc/ocelot_net.c |  8 ++---
 include/linux/dsa/ocelot.h             |  2 +-
 include/soc/mscc/ocelot.h              | 24 +++++++------
 5 files changed, 49 insertions(+), 54 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 628afb47b579..29a1191b2c5e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1586,16 +1586,22 @@ static int felix_mrp_add(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_mrp *mrp)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct net_device *dev;
 
-	return ocelot_mrp_add(ocelot, port, mrp);
+	dev = felix_port_to_netdev(ocelot, port);
+
+	return ocelot_mrp_add(ocelot, dev, port, mrp);
 }
 
 static int felix_mrp_del(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_mrp *mrp)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct net_device *dev;
+
+	dev = felix_port_to_netdev(ocelot, port);
 
-	return ocelot_mrp_add(ocelot, port, mrp);
+	return ocelot_mrp_add(ocelot, dev, port, mrp);
 }
 
 static int
@@ -1603,8 +1609,11 @@ felix_mrp_add_ring_role(struct dsa_switch *ds, int port,
 			const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct net_device *dev;
 
-	return ocelot_mrp_add_ring_role(ocelot, port, mrp);
+	dev = felix_port_to_netdev(ocelot, port);
+
+	return ocelot_mrp_add_ring_role(ocelot, dev, port, mrp);
 }
 
 static int
@@ -1612,8 +1621,11 @@ felix_mrp_del_ring_role(struct dsa_switch *ds, int port,
 			const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct net_device *dev;
+
+	dev = felix_port_to_netdev(ocelot, port);
 
-	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
+	return ocelot_mrp_del_ring_role(ocelot, dev, port, mrp);
 }
 
 const struct dsa_switch_ops felix_switch_ops = {
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 683da320bfd8..5068512bdc32 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -1,8 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 /* Microsemi Ocelot Switch driver
- *
- * This contains glue logic between the switchdev driver operations and the
- * mscc_ocelot_switch_lib.
  *
  * Copyright (c) 2017, 2019 Microsemi Corporation
  * Copyright 2020-2021 NXP Semiconductors
@@ -29,19 +26,14 @@ static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
 	return ocelot_vcap_filter_del(ocelot, filter);
 }
 
-int ocelot_mrp_add(struct ocelot *ocelot, int port,
+int ocelot_mrp_add(struct ocelot *ocelot, struct net_device *dev, int port,
 		   const struct switchdev_obj_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
 
-	if (!ocelot_port)
+	if (!ocelot_port || !dev)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
 	if (mrp->p_port != dev && mrp->s_port != dev)
 		return 0;
 
@@ -62,19 +54,14 @@ int ocelot_mrp_add(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_mrp_add);
 
-int ocelot_mrp_del(struct ocelot *ocelot, int port,
+int ocelot_mrp_del(struct ocelot *ocelot, struct net_device *dev, int port,
 		   const struct switchdev_obj_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
 
-	if (!ocelot_port)
+	if (!ocelot_port || !dev)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
 	if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
 		return 0;
 
@@ -83,7 +70,7 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
 	    !ocelot->mrp_p_port)
 		return -EINVAL;
 
-	if (ocelot_mrp_del_vcap(ocelot, priv->chip_port))
+	if (ocelot_mrp_del_vcap(ocelot, port))
 		return -EINVAL;
 
 	if (ocelot->mrp_p_port == dev)
@@ -98,21 +85,17 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_mrp_del);
 
-int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
+int ocelot_mrp_add_ring_role(struct ocelot *ocelot, struct net_device *dev,
+			     int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vcap_filter *filter;
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
 	int err;
 
-	if (!ocelot_port)
+	if (!ocelot_port || !dev)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
 	if (ocelot->mrp_ring_id != mrp->ring_id)
 		return -EINVAL;
 
@@ -128,11 +111,11 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 
 	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
 	filter->prio = 1;
-	filter->id.cookie = priv->chip_port;
+	filter->id.cookie = port;
 	filter->id.tc_offload = false;
 	filter->block_id = VCAP_IS2;
 	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
-	filter->ingress_port_mask = BIT(priv->chip_port);
+	filter->ingress_port_mask = BIT(port);
 	*(__be16 *)filter->key.etype.etype.value = htons(ETH_P_MRP);
 	*(__be16 *)filter->key.etype.etype.mask = htons(0xffff);
 	filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
@@ -148,19 +131,15 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_mrp_add_ring_role);
 
-int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
+int ocelot_mrp_del_ring_role(struct ocelot *ocelot, struct net_device *dev,
+			     int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
 
-	if (!ocelot_port)
+	if (!ocelot_port || !dev)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
 	if (ocelot->mrp_ring_id != mrp->ring_id)
 		return -EINVAL;
 
@@ -170,6 +149,6 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 	if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
 		return 0;
 
-	return ocelot_mrp_del_vcap(ocelot, priv->chip_port);
+	return ocelot_mrp_del_vcap(ocelot, port);
 }
 EXPORT_SYMBOL(ocelot_mrp_del_ring_role);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 12cb6867a2d0..57b0a31cfeed 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1018,7 +1018,7 @@ static int ocelot_port_obj_mrp_add(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_mrp_add(ocelot, port, mrp);
+	return ocelot_mrp_add(ocelot, dev, port, mrp);
 }
 
 static int ocelot_port_obj_mrp_del(struct net_device *dev,
@@ -1029,7 +1029,7 @@ static int ocelot_port_obj_mrp_del(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_mrp_del(ocelot, port, mrp);
+	return ocelot_mrp_del(ocelot, dev, port, mrp);
 }
 
 static int
@@ -1041,7 +1041,7 @@ ocelot_port_obj_mrp_add_ring_role(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_mrp_add_ring_role(ocelot, port, mrp);
+	return ocelot_mrp_add_ring_role(ocelot, dev, port, mrp);
 }
 
 static int
@@ -1053,7 +1053,7 @@ ocelot_port_obj_mrp_del_ring_role(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
+	return ocelot_mrp_del_ring_role(ocelot, dev, port, mrp);
 }
 
 static int ocelot_port_obj_add(struct net_device *dev,
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 4265f328681a..e284d56f1ad0 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -162,7 +162,7 @@ static inline void ocelot_xfh_get_src_port(void *extraction, u64 *src_port)
 
 static inline void ocelot_xfh_get_cpuq(void *extraction, u64 *cpuq)
 {
-	packing(extraction, cpuq, 28, 20, OCELOT_TAG_LEN, UNPACK, 0);
+	packing(extraction, cpuq, 27, 20, OCELOT_TAG_LEN, UNPACK, 0);
 }
 
 static inline void ocelot_xfh_get_qos_class(void *extraction, u64 *qos_class)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 425ff29d9389..59d35365edea 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -680,11 +680,9 @@ struct ocelot {
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
 
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	u16				mrp_ring_id;
 	struct net_device		*mrp_p_port;
 	struct net_device		*mrp_s_port;
-#endif
 };
 
 struct ocelot_policer {
@@ -883,36 +881,42 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   u32 *p_cur, u32 *p_max);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-int ocelot_mrp_add(struct ocelot *ocelot, int port,
+int ocelot_mrp_add(struct ocelot *ocelot, struct net_device *dev, int port,
 		   const struct switchdev_obj_mrp *mrp);
-int ocelot_mrp_del(struct ocelot *ocelot, int port,
+int ocelot_mrp_del(struct ocelot *ocelot, struct net_device *dev, int port,
 		   const struct switchdev_obj_mrp *mrp);
-int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
+int ocelot_mrp_add_ring_role(struct ocelot *ocelot, struct net_device *dev,
+			     int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp);
-int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
+int ocelot_mrp_del_ring_role(struct ocelot *ocelot, struct net_device *dev,
+			     int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp);
 #else
-static inline int ocelot_mrp_add(struct ocelot *ocelot, int port,
+static inline int ocelot_mrp_add(struct ocelot *ocelot, struct net_device *dev,
+				 int port,
 				 const struct switchdev_obj_mrp *mrp)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int ocelot_mrp_del(struct ocelot *ocelot, int port,
+static inline int ocelot_mrp_del(struct ocelot *ocelot, struct net_device *dev,
+				 int port,
 				 const struct switchdev_obj_mrp *mrp)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int
-ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
+ocelot_mrp_add_ring_role(struct ocelot *ocelot, struct net_device *dev,
+			 int port,
 			 const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int
-ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
+ocelot_mrp_del_ring_role(struct ocelot *ocelot, struct net_device *dev,
+			 int port,
 			 const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	return -EOPNOTSUPP;
-- 
2.27.0

