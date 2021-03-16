Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBF033DE78
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCPUPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:15:47 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20095 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhCPUPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 16:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615925721; x=1647461721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v6OfGmH7Ol/OvT2UAlrfLMCdI9hzrx3hUUKPBTxatq4=;
  b=mGAKxalULnD9/5+54QGDdAceochedduC40zI8r9Uv/0In9sL7s3ASLbr
   ek8/bpryoVTo6NOG/oLCUYS1Si41V+cA2LipBTlGddjVj/+r6AvCQQzD0
   LnqpTpbV2Ft+QV+Dz69174S87hqz2cgULbRmsRnCMIFzceasXNicQbWSF
   Y/Ev9u8vtSn2B8GbZRGDhz1aN9o46O/nmCvdULzT+YsycjZgLfALU0lh1
   wyDxTLFEkBgh5sjWgZU/sMoZGmJzF/4bnC5rlw9potYx9ptlK5EZWOU9K
   4OiMpfk/Nwgq7sXaQL7SUZHbyGIjWBHWTBnzNuWUrriMdVX3hMCiG58Bq
   Q==;
IronPort-SDR: PBNHWnW1i65G5du+2RWf5kTmFdGRJwx0wtfpEjaMotzLJTQlElrlY3OSclUDdXyjUElCkSYjKc
 r4qIypJZF0obv6ERfrvpA66I5LaPA8PTyCQPfYw64VQOQ/EhC4Y9cipPVS09wVxfJ4e5VRaGeI
 LUTkBQRyvFOFlDLj1NBpr8MeD6IVJnekskfnyIGoP6xwz8AerPoj7JM5g9WP3e/xXaYpAfRSaU
 9CFE84CbUzh6EMkUOEy7iSxp6STgl/Rk15a0dZvMyUXn05xPLrFL+WCNDPF5Is5Nn/VVWUFutN
 Bk0=
X-IronPort-AV: E=Sophos;i="5.81,254,1610434800"; 
   d="scan'208";a="107434274"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 13:15:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 13:15:12 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 16 Mar 2021 13:15:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/3] net: ocelot: Extend MRP
Date:   Tue, 16 Mar 2021 21:10:18 +0100
Message-ID: <20210316201019.3081237-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends MRP support for Ocelot. It allows to have multiple
rings and when the node has the MRC role it forwards MRP Test frames in
HW. For MRM there is no change.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c     |   6 -
 drivers/net/ethernet/mscc/ocelot_mrp.c | 233 +++++++++++++++++--------
 include/soc/mscc/ocelot.h              |   8 +-
 net/dsa/tag_ocelot.c                   |   6 -
 4 files changed, 160 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index f74d7cf002a5..9cc9378157e4 100644
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
index 683da320bfd8..439129a65b71 100644
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
@@ -15,13 +12,34 @@
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
-static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
+static const u8 mrp_test_dmac[] = { 0x01, 0x15, 0x4e, 0x00, 0x00, 0x01 };
+static const u8 mrp_control_dmac[] = { 0x01, 0x15, 0x4e, 0x00, 0x00, 0x02 };
+
+static int ocelot_mrp_find_partner_port(struct ocelot *ocelot,
+					struct ocelot_port *p)
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
+	return -1;
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
@@ -29,6 +47,87 @@ static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
 	return ocelot_vcap_filter_del(ocelot, filter);
 }
 
+static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
+					int dst_port)
+{
+	const u8 mrp_test_mask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	struct ocelot_vcap_filter *filter;
+	int err;
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
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
+				    int prio, unsigned long cookie)
+{
+	const u8 mrp_mask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
+	struct ocelot_vcap_filter *filter;
+	int err;
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
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
+	ocelot_mact_learn(ocelot, PGID_BLACKHOLE, mrp_test_dmac,
+			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+	ocelot_mact_learn(ocelot, PGID_BLACKHOLE, mrp_control_dmac,
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
@@ -45,18 +144,7 @@ int ocelot_mrp_add(struct ocelot *ocelot, int port,
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
@@ -66,34 +154,31 @@ int ocelot_mrp_del(struct ocelot *ocelot, int port,
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
 
+	ocelot_mrp_del_mac(ocelot, ocelot_port);
+out:
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_mrp_del);
@@ -102,49 +187,39 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
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
+	dst_port = ocelot_mrp_find_partner_port(ocelot, ocelot_port);
+	if (dst_port == -1)
+		return -EINVAL;
+
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
 
@@ -152,24 +227,32 @@ int ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
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
+	ocelot_mrp_del_mac(ocelot, ocelot_port);
+out:
+	return 0;
 }
 EXPORT_SYMBOL(ocelot_mrp_del_ring_role);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4d10ccc8e7b5..0a0751bf97dd 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -613,6 +613,8 @@ struct ocelot_port {
 
 	struct net_device		*bond;
 	bool				lag_tx_active;
+
+	u16				mrp_ring_id;
 };
 
 struct ocelot {
@@ -681,12 +683,6 @@ struct ocelot {
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
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 743809b5806b..157f95689d8d 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -128,12 +128,6 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	skb->offload_fwd_mark = 1;
 	skb->priority = qos_class;
 
-#if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	if (eth_hdr(skb)->h_proto == cpu_to_be16(ETH_P_MRP) &&
-	    cpuq & BIT(OCELOT_MRP_CPUQ))
-		skb->offload_fwd_mark = 0;
-#endif
-
 	/* Ocelot switches copy frames unmodified to the CPU. However, it is
 	 * possible for the user to request a VLAN modification through
 	 * VCAP_IS1_ACT_VID_REPLACE_ENA. In this case, what will happen is that
-- 
2.30.1

