Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C239B553
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhFDI6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:58:24 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5454 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFDI6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622796996; x=1654332996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yadSLe1vY4qjQTkBCCPACDHsaP+szqGAjMt1HO2skxg=;
  b=oRonsHsnScXmYG6pPvhYMcIQRnMqCAVq//3CyIQBYQ15Um3e8SgdbOu7
   avKmvFYuuiTp274SKU06ybbBqs6XYVjHThS1hYGSyrdenXAQBFHAVUGm0
   IJAHSRo5WBQ8iT6UYQ3DkBP89XY+HVhO1POHOE4Sxr9UMNbl89/2Ejclm
   ekYLgcEyWqEvt9nkrd7dtSIMXhYfgMiUGWAJFe2TCgbr9yxOm1OHk4vWE
   u7BrSw0/cdqZOns9AMBR+6JTxDatZhaZBsh4I//RPUdpK4pUx7p4BNXGu
   N85YxoReedtWqIdlPjfg+ss7h/xhr555zWXjcw0uhSa1ftiGik8iGfPUA
   Q==;
IronPort-SDR: CEQxSjrO0ECqh3Gx7Zv6wM+H+gdtMjShUH9/dk0l0tFQ0mJFZeP7NoxTeomogzFzBQIDq7OP5y
 766P9eNOm/tDcjbax+u/GbcKePxOH5+WHZl4ZcDEtWDSvnm9PfrMcQD38GbH5tcOHrkEwhg9m1
 qPOVjJvc2tpGY2S527cc1dzcSrn4X/i/sNoUoAI2TmFkcxlf71XhHmY3n9NuBJdwgfQREUc4Qw
 8vBlDxk9KkPCwG6PkH/xhk5LnfeOlBKHOwx2QmImclqoRfyFkKIvnq42Iic6c1/gOZ7p5is3Ed
 lPs=
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="120209957"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jun 2021 01:56:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 01:56:35 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 4 Jun 2021 01:56:31 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v3 06/10] net: sparx5: add vlan support
Date:   Fri, 4 Jun 2021 10:55:56 +0200
Message-ID: <20210604085600.3014532-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604085600.3014532-1-steen.hegelund@microchip.com>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds Sparx5 VLAN support.

Sparx5 has more VLAN features than provided here, but these will be added
in later series. For now we only add the basic L2 features.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |  10 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  14 ++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   | 224 ++++++++++++++++++
 4 files changed, 246 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 4ccb09d275bc..81685c3f428e 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
- sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o
+ sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o sparx5_vlan.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 8743e1cdc524..0745fca063ef 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -280,7 +280,8 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	}
 	spx5_port->conf = config->conf;
 
-	/* VLAN support to be added in later patches */
+	/* Setup VLAN */
+	sparx5_vlan_port_setup(sparx5, spx5_port->portno);
 
 	/* Create a phylink for PHY management.  Also handles SFPs */
 	spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
@@ -587,7 +588,9 @@ static int sparx5_start(struct sparx5 *sparx5)
 			 sparx5,
 			 QFWD_SWITCH_PORT_MODE(idx));
 
-	/* Forwarding masks to be added in later patches */
+	/* Init masks */
+	sparx5_update_fwd(sparx5);
+
 	/* CPU copy CPU pgids */
 	spx5_wr(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
 		sparx5, ANA_AC_PGID_MISC_CFG(PGID_CPU));
@@ -603,7 +606,8 @@ static int sparx5_start(struct sparx5 *sparx5)
 	/* Init MAC table, ageing */
 	sparx5_mact_init(sparx5);
 
-	/* VLAN support to be added in later patches */
+	/* Setup VLANs */
+	sparx5_vlan_init(sparx5);
 
 	/* Add host mode BC address (points only to CPU) */
 	sparx5_mact_learn(sparx5, PGID_CPU, broadcast, NULL_VID);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index ac715c9e42e3..87be3a2c5f8c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -137,6 +137,10 @@ struct sparx5 {
 	enum sparx5_core_clockfreq coreclock;
 	/* Switch state */
 	u8 base_mac[ETH_ALEN];
+	/* Bridged interfaces */
+	DECLARE_BITMAP(bridge_fwd_mask, SPX5_PORTS);
+	DECLARE_BITMAP(bridge_lrn_mask, SPX5_PORTS);
+	DECLARE_BITMAP(vlan_mask[VLAN_N_VID], SPX5_PORTS);
 	/* SW MAC table */
 	struct list_head mact_entries;
 	/* mac table list (mact_entries) mutex */
@@ -174,6 +178,16 @@ int sparx5_mc_unsync(struct net_device *dev, const unsigned char *addr);
 void sparx5_set_ageing(struct sparx5 *sparx5, int msecs);
 void sparx5_mact_init(struct sparx5 *sparx5);
 
+/* sparx5_vlan.c */
+void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable);
+void sparx5_update_fwd(struct sparx5 *sparx5);
+void sparx5_vlan_init(struct sparx5 *sparx5);
+void sparx5_vlan_port_setup(struct sparx5 *sparx5, int portno);
+int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
+			bool untagged);
+int sparx5_vlan_vid_del(struct sparx5_port *port, u16 vid);
+void sparx5_vlan_port_apply(struct sparx5 *sparx5, struct sparx5_port *port);
+
 /* sparx5_netdev.c */
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
new file mode 100644
index 000000000000..4ce490a25f33
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static int sparx5_vlant_set_mask(struct sparx5 *sparx5, u16 vid)
+{
+	u32 mask[3];
+
+	/* Divide up mask in 32 bit words */
+	bitmap_to_arr32(mask, sparx5->vlan_mask[vid], SPX5_PORTS);
+
+	/* Output mask to respective registers */
+	spx5_wr(mask[0], sparx5, ANA_L3_VLAN_MASK_CFG(vid));
+	spx5_wr(mask[1], sparx5, ANA_L3_VLAN_MASK_CFG1(vid));
+	spx5_wr(mask[2], sparx5, ANA_L3_VLAN_MASK_CFG2(vid));
+
+	return 0;
+}
+
+void sparx5_vlan_init(struct sparx5 *sparx5)
+{
+	u16 vid;
+
+	spx5_rmw(ANA_L3_VLAN_CTRL_VLAN_ENA_SET(1),
+		 ANA_L3_VLAN_CTRL_VLAN_ENA,
+		 sparx5,
+		 ANA_L3_VLAN_CTRL);
+
+	/* Map VLAN = FID */
+	for (vid = NULL_VID; vid < VLAN_N_VID; vid++)
+		spx5_rmw(ANA_L3_VLAN_CFG_VLAN_FID_SET(vid),
+			 ANA_L3_VLAN_CFG_VLAN_FID,
+			 sparx5,
+			 ANA_L3_VLAN_CFG(vid));
+}
+
+void sparx5_vlan_port_setup(struct sparx5 *sparx5, int portno)
+{
+	struct sparx5_port *port = sparx5->ports[portno];
+
+	/* Configure PVID */
+	spx5_rmw(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(0) |
+		 ANA_CL_VLAN_CTRL_PORT_VID_SET(port->pvid),
+		 ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA |
+		 ANA_CL_VLAN_CTRL_PORT_VID,
+		 sparx5,
+		 ANA_CL_VLAN_CTRL(port->portno));
+}
+
+int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
+			bool untagged)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	int ret;
+
+	/* Make the port a member of the VLAN */
+	set_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Default ingress vlan classification */
+	if (pvid)
+		port->pvid = vid;
+
+	/* Untagged egress vlan classification */
+	if (untagged && port->vid != vid) {
+		if (port->vid) {
+			netdev_err(port->ndev,
+				   "Port already has a native VLAN: %d\n",
+				   port->vid);
+			return -EBUSY;
+		}
+		port->vid = vid;
+	}
+
+	sparx5_vlan_port_apply(sparx5, port);
+
+	return 0;
+}
+
+int sparx5_vlan_vid_del(struct sparx5_port *port, u16 vid)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	int ret;
+
+	/* 8021q removes VID 0 on module unload for all interfaces
+	 * with VLAN filtering feature. We need to keep it to receive
+	 * untagged traffic.
+	 */
+	if (vid == 0)
+		return 0;
+
+	/* Stop the port from being a member of the vlan */
+	clear_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Ingress */
+	if (port->pvid == vid)
+		port->pvid = 0;
+
+	/* Egress */
+	if (port->vid == vid)
+		port->vid = 0;
+
+	sparx5_vlan_port_apply(sparx5, port);
+
+	return 0;
+}
+
+void sparx5_pgid_update_mask(struct sparx5_port *port, int pgid, bool enable)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	u32 val, mask;
+
+	/* mask is spread across 3 registers x 32 bit */
+	if (port->portno < 32) {
+		mask = BIT(port->portno);
+		val = enable ? mask : 0;
+		spx5_rmw(val, mask, sparx5, ANA_AC_PGID_CFG(pgid));
+	} else if (port->portno < 64) {
+		mask = BIT(port->portno - 32);
+		val = enable ? mask : 0;
+		spx5_rmw(val, mask, sparx5, ANA_AC_PGID_CFG1(pgid));
+	} else if (port->portno < SPX5_PORTS) {
+		mask = BIT(port->portno - 64);
+		val = enable ? mask : 0;
+		spx5_rmw(val, mask, sparx5, ANA_AC_PGID_CFG2(pgid));
+	} else {
+		netdev_err(port->ndev, "Invalid port no: %d\n", port->portno);
+	}
+}
+
+void sparx5_update_fwd(struct sparx5 *sparx5)
+{
+	DECLARE_BITMAP(workmask, SPX5_PORTS);
+	u32 mask[3];
+	int port;
+
+	/* Divide up fwd mask in 32 bit words */
+	bitmap_to_arr32(mask, sparx5->bridge_fwd_mask, SPX5_PORTS);
+
+	/* Update flood masks */
+	for (port = PGID_UC_FLOOD; port <= PGID_BCAST; port++) {
+		spx5_wr(mask[0], sparx5, ANA_AC_PGID_CFG(port));
+		spx5_wr(mask[1], sparx5, ANA_AC_PGID_CFG1(port));
+		spx5_wr(mask[2], sparx5, ANA_AC_PGID_CFG2(port));
+	}
+
+	/* Update SRC masks */
+	for (port = 0; port < SPX5_PORTS; port++) {
+		if (test_bit(port, sparx5->bridge_fwd_mask)) {
+			/* Allow to send to all bridged but self */
+			bitmap_copy(workmask, sparx5->bridge_fwd_mask, SPX5_PORTS);
+			clear_bit(port, workmask);
+			bitmap_to_arr32(mask, workmask, SPX5_PORTS);
+			spx5_wr(mask[0], sparx5, ANA_AC_SRC_CFG(port));
+			spx5_wr(mask[1], sparx5, ANA_AC_SRC_CFG1(port));
+			spx5_wr(mask[2], sparx5, ANA_AC_SRC_CFG2(port));
+		} else {
+			spx5_wr(0, sparx5, ANA_AC_SRC_CFG(port));
+			spx5_wr(0, sparx5, ANA_AC_SRC_CFG1(port));
+			spx5_wr(0, sparx5, ANA_AC_SRC_CFG2(port));
+		}
+	}
+
+	/* Learning enabled only for bridged ports */
+	bitmap_and(workmask, sparx5->bridge_fwd_mask,
+		   sparx5->bridge_lrn_mask, SPX5_PORTS);
+	bitmap_to_arr32(mask, workmask, SPX5_PORTS);
+
+	/* Apply learning mask */
+	spx5_wr(mask[0], sparx5, ANA_L2_AUTO_LRN_CFG);
+	spx5_wr(mask[1], sparx5, ANA_L2_AUTO_LRN_CFG1);
+	spx5_wr(mask[2], sparx5, ANA_L2_AUTO_LRN_CFG2);
+}
+
+void sparx5_vlan_port_apply(struct sparx5 *sparx5,
+			    struct sparx5_port *port)
+
+{
+	u32 val;
+
+	/* Configure PVID, vlan aware */
+	val = ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(port->vlan_aware) |
+		ANA_CL_VLAN_CTRL_VLAN_POP_CNT_SET(port->vlan_aware) |
+		ANA_CL_VLAN_CTRL_PORT_VID_SET(port->pvid);
+	spx5_wr(val, sparx5, ANA_CL_VLAN_CTRL(port->portno));
+
+	val = 0;
+	if (port->vlan_aware && !port->pvid)
+		/* If port is vlan-aware and tagged, drop untagged and
+		 * priority tagged frames.
+		 */
+		val = ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_SET(1) |
+			ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_SET(1) |
+			ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_SET(1);
+	spx5_wr(val, sparx5,
+		ANA_CL_VLAN_FILTER_CTRL(port->portno, 0));
+
+	/* Egress configuration (REW_TAG_CFG): VLAN tag type to 8021Q */
+	val = REW_TAG_CTRL_TAG_TPID_CFG_SET(0);
+	if (port->vlan_aware) {
+		if (port->vid)
+			/* Tag all frames except when VID == DEFAULT_VLAN */
+			val |= REW_TAG_CTRL_TAG_CFG_SET(1);
+		else
+			val |= REW_TAG_CTRL_TAG_CFG_SET(3);
+	}
+	spx5_wr(val, sparx5, REW_TAG_CTRL(port->portno));
+
+	/* Egress VID */
+	spx5_rmw(REW_PORT_VLAN_CFG_PORT_VID_SET(port->vid),
+		 REW_PORT_VLAN_CFG_PORT_VID,
+		 sparx5,
+		 REW_PORT_VLAN_CFG(port->portno));
+}
-- 
2.31.1

