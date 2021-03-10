Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6133492E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhCJUxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:53:42 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:7081 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhCJUxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:53:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615409599; x=1646945599;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AWvF456SJS1J0zSd4aJXrpNBFWwvVhUG9BmVkFd52Q0=;
  b=CYncQ0F2OPlYyAjQBq97qljmCkTfWJcorGP9n1Rlx58hD3rb6Zc8gyhC
   FLOcCSEuEBOqZleJ1iNQ+0MJ8shpWUhk+bpXlpxVwisJW05O0pC8W+c4c
   2G6xkN40navFWD2ExPYLSfmXw2w9g9BMUGdvHZ2D82ygzPrn8OIr1EMyf
   Bg9e3MidGRh9Ce3q69gkngu1GQEUOOVXmFp5SuZbK86y2vt2XZCjU6jAU
   i2HQsnGeFxizM7KFaKMGkvYh81Y14dSeQqWJQj2D1aXd/dXFuP5fQzWnm
   c9/xz6g5ZfxEW+sWw8GSxCOUWKk7M7IMrxFO56Sb4+C9iBYSEb9BMAav8
   Q==;
IronPort-SDR: BiIaNvCNgdqqZZ8Ruqm5VNwuH2SCb74je2QV17q/7Dc5fIQoiHdVY1OjlZorSzkpHtruev3GcE
 Zb37ORrDHn7Jj+x8fdX8iVXcwxl8TKvQUk+J8nVLgNRWWW4TEA9sYzq0XWf4pZr+lNTpj+s2Y3
 wiPs0UapRwZewjt7RsnNtMCp86KpgS9MybnmbgluyDeIt4TT/N4U8fMxBrAdQs/k7/Is12oUwY
 3pyPVZSia+xXHZPjDdjDwIBwFeOBuRcuC+V26Mq4ZDK6sNcSw99f02x9CEO5h9jGpc+HL8+1dr
 7HI=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="109510053"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:53:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:53:17 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 10 Mar 2021 13:53:15 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: ocelot: Extend MRP
Date:   Wed, 10 Mar 2021 21:51:40 +0100
Message-ID: <20210310205140.1428791-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends MRP support for Ocelot.  It allows to have multiple
rings and when the node has the MRC role it forwards MRP Test frames in
HW. For MRM there is no change.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c     |   6 -
 drivers/net/ethernet/mscc/ocelot_mrp.c | 229 +++++++++++++++++--------
 include/soc/mscc/ocelot.h              |  10 +-
 3 files changed, 158 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 46e5c9136bac..9b79363db17f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -772,12 +772,6 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	if (skb->protocol == cpu_to_be16(ETH_P_MRP) &&
-	    cpuq & BIT(OCELOT_MRP_CPUQ))
-		skb->offload_fwd_mark = 0;
-#endif
-
 	*nskb = skb;
 
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 683da320bfd8..86b36e5d2279 100644
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
@@ -15,13 +12,33 @@
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
-static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
+static const u8 mrp_test_dmac[] = {0x01, 0x15, 0x4e, 0x00, 0x00, 0x01 };
+static const u8 mrp_control_dmac[] = {0x01, 0x15, 0x4e, 0x00, 0x00, 0x02 };
+
+static int ocelot_mrp_find_port(struct ocelot *ocelot, struct ocelot_port *p)
+{
+	int i;
+
+	for (i = 0; i < ocelot->num_phys_ports; ++i) {
+		struct ocelot_port *ocelot_port = ocelot->ports[i];
+
+		if (!ocelot_port || p == ocelot_port)
+			continue;
+
+		if (ocelot_port->mrp_ring_id == p->mrp_ring_id)
+			return i;
+	}
+
+	return 0;
+}
+
+static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int id)
 {
 	struct ocelot_vcap_block *block_vcap_is2;
 	struct ocelot_vcap_filter *filter;
 
 	block_vcap_is2 = &ocelot->block[VCAP_IS2];
-	filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, port,
+	filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, id,
 						     false);
 	if (!filter)
 		return 0;
@@ -29,6 +46,87 @@ static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
 	return ocelot_vcap_filter_del(ocelot, filter);
 }
 
+static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
+					int dst_port)
+{
+	const u8 mrp_test_mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	struct ocelot_vcap_filter *filter;
+	int err;
+
+	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
+	if (!filter)
+		return -ENOMEM;
+
+	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
+	filter->prio = 1;
+	filter->id.cookie = src_port;
+	filter->id.tc_offload = false;
+	filter->block_id = VCAP_IS2;
+	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	filter->ingress_port_mask = BIT(src_port);
+	ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
+	ether_addr_copy(filter->key.etype.dmac.mask, mrp_test_mask);
+	filter->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+	filter->action.port_mask = BIT(dst_port);
+
+	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
+	if (err)
+		kfree(filter);
+
+	return err;
+}
+
+static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port,
+				    int prio, int cookie)
+{
+	const u8 mrp_mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
+	struct ocelot_vcap_filter *filter;
+	int err;
+
+	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
+	if (!filter)
+		return -ENOMEM;
+
+	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
+	filter->prio = prio;
+	filter->id.cookie = cookie;
+	filter->id.tc_offload = false;
+	filter->block_id = VCAP_IS2;
+	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	filter->ingress_port_mask = BIT(port);
+	/* Here is possible to use control or test dmac because the mask
+	 * doesn't cover the LSB
+	 */
+	ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
+	ether_addr_copy(filter->key.etype.dmac.mask, mrp_mask);
+	filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+	filter->action.port_mask = 0x0;
+	filter->action.cpu_copy_ena = true;
+	filter->action.cpu_qu_num = OCELOT_MRP_CPUQ;
+
+	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
+	if (err)
+		kfree(filter);
+
+	return err;
+}
+
+static void ocelot_mrp_save_mac(struct ocelot *ocelot,
+				struct ocelot_port *port)
+{
+	ocelot_mact_learn(ocelot, PGID_MRP, mrp_test_dmac,
+			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+	ocelot_mact_learn(ocelot, PGID_MRP, mrp_control_dmac,
+			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+}
+
+static void ocelot_mrp_del_mac(struct ocelot *ocelot,
+			       struct ocelot_port *port)
+{
+	ocelot_mact_forget(ocelot, mrp_test_dmac, port->pvid_vlan.vid);
+	ocelot_mact_forget(ocelot, mrp_control_dmac, port->pvid_vlan.vid);
+}
+
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp)
 {
@@ -45,18 +143,7 @@ int ocelot_mrp_add(struct ocelot *ocelot, int port,
 	if (mrp->p_port != dev && mrp->s_port != dev)
 		return 0;
 
-	if (ocelot->mrp_ring_id != 0 &&
-	    ocelot->mrp_s_port &&
-	    ocelot->mrp_p_port)
-		return -EINVAL;
-
-	if (mrp->p_port == dev)
-		ocelot->mrp_p_port = dev;
-
-	if (mrp->s_port == dev)
-		ocelot->mrp_s_port = dev;
-
-	ocelot->mrp_ring_id = mrp->ring_id;
+	ocelot_port->mrp_ring_id = mrp->ring_id;
 
 	return 0;
 }
@@ -66,34 +153,31 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
+	int i;
 
 	if (!ocelot_port)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
-	if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
+	if (ocelot_port->mrp_ring_id != mrp->ring_id)
 		return 0;
 
-	if (ocelot->mrp_ring_id == 0 &&
-	    !ocelot->mrp_s_port &&
-	    !ocelot->mrp_p_port)
-		return -EINVAL;
+	ocelot_mrp_del_vcap(ocelot, port);
+	ocelot_mrp_del_vcap(ocelot, port + ocelot->num_phys_ports);
 
-	if (ocelot_mrp_del_vcap(ocelot, priv->chip_port))
-		return -EINVAL;
+	ocelot_port->mrp_ring_id = 0;
 
-	if (ocelot->mrp_p_port == dev)
-		ocelot->mrp_p_port = NULL;
+	for (i = 0; i < ocelot->num_phys_ports; ++i) {
+		ocelot_port = ocelot->ports[i];
 
-	if (ocelot->mrp_s_port == dev)
-		ocelot->mrp_s_port = NULL;
+		if (!ocelot_port)
+			continue;
 
-	ocelot->mrp_ring_id = 0;
+		if (ocelot_port->mrp_ring_id != 0)
+			goto out;
+	}
 
+	ocelot_mrp_del_mac(ocelot, ocelot->ports[port]);
+out:
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_mrp_del);
@@ -102,49 +186,36 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_vcap_filter *filter;
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
+	int dst_port;
 	int err;
 
 	if (!ocelot_port)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
-	if (ocelot->mrp_ring_id != mrp->ring_id)
-		return -EINVAL;
-
-	if (!mrp->sw_backup)
+	if (mrp->ring_role != BR_MRP_RING_ROLE_MRC && !mrp->sw_backup)
 		return -EOPNOTSUPP;
 
-	if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
+	if (ocelot_port->mrp_ring_id != mrp->ring_id)
 		return 0;
 
-	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
-	if (!filter)
-		return -ENOMEM;
+	ocelot_mrp_save_mac(ocelot, ocelot_port);
 
-	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
-	filter->prio = 1;
-	filter->id.cookie = priv->chip_port;
-	filter->id.tc_offload = false;
-	filter->block_id = VCAP_IS2;
-	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
-	filter->ingress_port_mask = BIT(priv->chip_port);
-	*(__be16 *)filter->key.etype.etype.value = htons(ETH_P_MRP);
-	*(__be16 *)filter->key.etype.etype.mask = htons(0xffff);
-	filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
-	filter->action.port_mask = 0x0;
-	filter->action.cpu_copy_ena = true;
-	filter->action.cpu_qu_num = OCELOT_MRP_CPUQ;
+	if (mrp->ring_role != BR_MRP_RING_ROLE_MRC)
+		return ocelot_mrp_copy_add_vcap(ocelot, port, 1, port);
 
-	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
+	dst_port = ocelot_mrp_find_port(ocelot, ocelot_port);
+	err = ocelot_mrp_redirect_add_vcap(ocelot, port, dst_port);
 	if (err)
-		kfree(filter);
+		return err;
 
-	return err;
+	err = ocelot_mrp_copy_add_vcap(ocelot, port, 2,
+				       port + ocelot->num_phys_ports);
+	if (err) {
+		ocelot_mrp_del_vcap(ocelot, port);
+		return err;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(ocelot_mrp_add_ring_role);
 
@@ -152,24 +223,32 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 			     const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	struct ocelot_port_private *priv;
-	struct net_device *dev;
+	int i;
 
 	if (!ocelot_port)
 		return -EOPNOTSUPP;
 
-	priv = container_of(ocelot_port, struct ocelot_port_private, port);
-	dev = priv->dev;
-
-	if (ocelot->mrp_ring_id != mrp->ring_id)
-		return -EINVAL;
-
-	if (!mrp->sw_backup)
+	if (mrp->ring_role != BR_MRP_RING_ROLE_MRC && !mrp->sw_backup)
 		return -EOPNOTSUPP;
 
-	if (ocelot->mrp_p_port != dev && ocelot->mrp_s_port != dev)
+	if (ocelot_port->mrp_ring_id != mrp->ring_id)
 		return 0;
 
-	return ocelot_mrp_del_vcap(ocelot, priv->chip_port);
+	ocelot_mrp_del_vcap(ocelot, port);
+	ocelot_mrp_del_vcap(ocelot, port + ocelot->num_phys_ports);
+
+	for (i = 0; i < ocelot->num_phys_ports; ++i) {
+		ocelot_port = ocelot->ports[i];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->mrp_ring_id != 0)
+			goto out;
+	}
+
+	ocelot_mrp_del_mac(ocelot, ocelot->ports[port]);
+out:
+	return 0;
 }
 EXPORT_SYMBOL(ocelot_mrp_del_ring_role);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 425ff29d9389..c41696d2e82b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -51,6 +51,7 @@
  */
 
 /* Reserve some destination PGIDs at the end of the range:
+ * PGID_MRP: used for not flooding MRP frames to CPU
  * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
  *           of the switch port net devices, towards the CPU port module.
  * PGID_UC: the flooding destinations for unknown unicast traffic.
@@ -59,6 +60,7 @@
  * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
  * PGID_BC: the flooding destinations for broadcast traffic.
  */
+#define PGID_MRP			57
 #define PGID_CPU			58
 #define PGID_UC				59
 #define PGID_MC				60
@@ -611,6 +613,8 @@ struct ocelot_port {
 
 	struct net_device		*bond;
 	bool				lag_tx_active;
+
+	u16				mrp_ring_id;
 };
 
 struct ocelot {
@@ -679,12 +683,6 @@ struct ocelot {
 	/* Protects the PTP clock */
 	spinlock_t			ptp_clock_lock;
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
-
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	u16				mrp_ring_id;
-	struct net_device		*mrp_p_port;
-	struct net_device		*mrp_s_port;
-#endif
 };
 
 struct ocelot_policer {
-- 
2.30.1

