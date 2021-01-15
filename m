Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB92F7D5B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbhAONzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:55:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30623 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbhAONzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610718945; x=1642254945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hr9AuL7u5bk7zwSI76zzwPcJuMqfxwQ3B9Etcgu6FFw=;
  b=K3e/DyUY57ZcOJOsEbFueBWptiIDXE16OwRuO9U+bbrE+o+hnA7rvv2v
   nIW7K0iP9GPDoCHIhLYqmipoGDYthUqzQ2BR7LiJLJN+1egAnPAALZOJt
   1p4UALUp0YgSEhgQuTd6wufRrVrLSTlSL2NkFtWBsmkcFumAw3NOhtE/e
   txxkSEQYhE41267b5rFFSbrOs8g60oYtyZ2r2VumMH86tEWohM8zXo1E7
   k1X4THslrn+mJgG08eELc/WGupluKK/vJtWpu4rsevwjovYUQnekmAByZ
   BizmUmCuI1VXFzw2N3qyhNcJ14yx/FaqstURvOeCbFg8LNTK+Q2rUZWDt
   w==;
IronPort-SDR: 75DU5BvZ2WBftTqRfD6lAXZyffjIymcgxYklRRO2H8cdjRRuPGnweBg92dOMhzVRl8Xf4SEgD9
 NvCR7tWTjo/dHm73SgG+lmquQdMT1QzZOOIblJDcFZN+hXsglIjAxjC5JucGRxFWpdJHsShXLb
 Zx1McYfY7RiBhyNEiNfRZGSY8Vt27k3WJSld5pod/WFUzTq3WlKYn3YTVAUhDn34OLuYEselE7
 FsuG37+NDUpOGvxAirGvZ99kIg6d4Sdr56rnwerG02O+Etfwrb4WLJDgnhEFzNdA1J2cCVhYoX
 MMM=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="111177412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 06:54:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 06:54:05 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 06:54:01 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH v3 3/8] net: sparx5: add hostmode with phylink support
Date:   Fri, 15 Jan 2021 14:53:34 +0100
Message-ID: <20210115135339.3127198-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115135339.3127198-1-steen.hegelund@microchip.com>
References: <20210115135339.3127198-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds phylink support for ports and register base injection
and extraction.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |  83 ++++--
 .../ethernet/microchip/sparx5/sparx5_main.h   |  16 +
 .../ethernet/microchip/sparx5/sparx5_netdev.c | 204 +++++++++++++
 .../ethernet/microchip/sparx5/sparx5_packet.c | 277 ++++++++++++++++++
 .../microchip/sparx5/sparx5_phylink.c         | 170 +++++++++++
 6 files changed, 723 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 41a31843d86f..19a593d17f4a 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
-sparx5-switch-objs  := sparx5_main.o
+sparx5-switch-objs  := sparx5_main.o sparx5_packet.o sparx5_netdev.o sparx5_phylink.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 5d07e72ef8a7..6919e673ceb8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -247,9 +247,15 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 			      struct initial_port_config *config)
 {
 	struct sparx5_port *spx5_port;
+	struct net_device *ndev;
 
-	/* netdev creation to be added in later patches */
-	spx5_port = devm_kzalloc(sparx5->dev, sizeof(*spx5_port), GFP_KERNEL);
+	ndev = sparx5_create_netdev(sparx5, config->portno);
+	if (IS_ERR(ndev)) {
+		dev_err(sparx5->dev, "Could not create net device: %02u\n",
+			config->portno);
+		return PTR_ERR(ndev);
+	}
+	spx5_port = netdev_priv(ndev);
 	spx5_port->of_node = config->node;
 	spx5_port->serdes = config->serdes;
 	spx5_port->pvid = NULL_VID;
@@ -259,8 +265,13 @@ static int sparx5_create_port(struct sparx5 *sparx5,
 	spx5_port->max_vlan_tags = SPX5_PORT_MAX_TAGS_NONE;
 	spx5_port->vlan_type = SPX5_VLAN_PORT_TYPE_UNAWARE;
 	spx5_port->custom_etype = 0x8880; /* Vitesse */
+	sparx5->ports[config->portno] = spx5_port;
+
+	spx5_port->conf = config->conf;
+
+	/* VLAN setup to be added in later patches */
 
-	/* PHYLINK support to be added in later patches */
+	/* PHYLINK setup to be added in later patches */
 
 	return 0;
 }
@@ -332,7 +343,9 @@ static int sparx5_init_switchcore(struct sparx5 *sparx5)
 	spx5_wr(ANA_AC_STAT_RESET_RESET_SET(1), sparx5, ANA_AC_STAT_RESET);
 	spx5_wr(ASM_STAT_CFG_STAT_CNT_CLR_SHOT_SET(1), sparx5, ASM_STAT_CFG);
 
-	/* Injection/Extraction to be added in later patches */
+	/* Configure manual injection */
+	sparx5_manual_injection_mode(sparx5);
+
 	/* Enable switch-core and queue system */
 	spx5_wr(HSCH_RESET_CFG_CORE_ENA_SET(1), sparx5, HSCH_RESET_CFG);
 
@@ -524,27 +537,7 @@ static void sparx5_board_init(struct sparx5 *sparx5)
 static int sparx5_start(struct sparx5 *sparx5)
 {
 	u32 idx;
-
-	if (sparx5_create_targets(sparx5))
-		return -ENODEV;
-
-	/* Read chip ID to check CPU interface */
-	sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
-
-	sparx5->target_ct = (enum spx5_target_chiptype)
-		GCB_CHIP_ID_PART_ID_GET(sparx5->chip_id);
-
-	/* Initialize Switchcore and internal RAMs */
-	if (sparx5_init_switchcore(sparx5)) {
-		dev_err(sparx5->dev, "Switchcore initialization error\n");
-		return -EINVAL;
-	}
-
-	/* Initialize the LC-PLL (core clock) and set affected registers */
-	if (sparx5_init_coreclock(sparx5)) {
-		dev_err(sparx5->dev, "LC-PLL initialization error\n");
-		return -EINVAL;
-	}
+	int err;
 
 	/* Setup own UPSIDs */
 	for (idx = 0; idx < 3; idx++) {
@@ -579,13 +572,26 @@ static int sparx5_start(struct sparx5 *sparx5)
 	/* Enable queue limitation watermarks */
 	sparx5_qlim_set(sparx5);
 
-	/* netdev and resource calendar support to be added in later patches */
+	/* Resource calendar support to be added in later patches */
+
+	err = sparx5_register_netdevs(sparx5);
+	if (err)
+		return err;
 
 	sparx5_board_init(sparx5);
 
 	return 0;
 }
 
+static void sparx5_cleanup_ports(struct sparx5 *sparx5)
+{
+	int idx;
+
+	for (idx = 0; idx < SPX5_PORTS; ++idx) {
+		/* Port clean to be added in later patches */
+	}
+}
+
 static int mchp_sparx5_probe(struct platform_device *pdev)
 {
 	struct initial_port_config *configs, *config;
@@ -594,6 +600,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	struct sparx5 *sparx5;
 	int idx = 0, err = 0;
 	const u8 *mac_addr;
+	int irq;
 
 	if (!np && !pdev->dev.platform_data)
 		return -ENODEV;
@@ -696,7 +703,18 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		ether_addr_copy(sparx5->base_mac, mac_addr);
 	}
 
-	/* Inj/Xtr IRQ support to be added in later patches */
+	/* Hook xtr irq */
+	irq = platform_get_irq(sparx5->pdev, 0);
+	if (irq < 0) {
+		err = irq;
+		goto cleanup_config;
+	}
+	err = devm_request_irq(sparx5->dev, irq,
+			       sparx5_xtr_handler, IRQF_SHARED,
+			       "sparx5-xtr", sparx5);
+	if (err)
+		goto cleanup_config;
+
 	/* Read chip ID to check CPU interface */
 	sparx5->chip_id = spx5_rd(sparx5, GCB_CHIP_ID);
 
@@ -736,12 +754,20 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	return err;
 
 cleanup_ports:
-	/* Port cleanup to be added in later patches */
+	sparx5_cleanup_ports(sparx5);
 cleanup_config:
 	kfree(configs);
 	return err;
 }
 
+static int mchp_sparx5_remove(struct platform_device *pdev)
+{
+	struct sparx5 *sparx5 = platform_get_drvdata(pdev);
+
+	sparx5_cleanup_ports(sparx5);
+	return 0;
+}
+
 static const struct of_device_id mchp_sparx5_match[] = {
 	{ .compatible = "microchip,sparx5-switch" },
 	{ }
@@ -750,6 +776,7 @@ MODULE_DEVICE_TABLE(of, mchp_sparx5_match);
 
 static struct platform_driver mchp_sparx5_driver = {
 	.probe = mchp_sparx5_probe,
+	.remove = mchp_sparx5_remove,
 	.driver = {
 		.name = "sparx5-switch",
 		.of_match_table = mchp_sparx5_match,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 6b80e09bcc13..2627af7e023b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -92,6 +92,9 @@ struct sparx5_port {
 	struct device_node         *of_node;
 	struct phy                 *serdes;
 	struct sparx5_port_config  conf;
+	struct phylink_config      phylink_config;
+	struct phylink             *phylink;
+	struct phylink_pcs         phylink_pcs;
 	u16                        portno;
 	/* Ingress default VLAN (pvid) */
 	u16                        pvid;
@@ -132,6 +135,17 @@ struct sparx5 {
 	bool                                  sd_sgpio_remapping;
 };
 
+/* sparx5_packet.c */
+irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
+int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
+void sparx5_manual_injection_mode(struct sparx5 *sparx5);
+
+/* sparx5_netdev.c */
+bool sparx5_netdevice_check(const struct net_device *dev);
+struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
+int sparx5_register_netdevs(struct sparx5 *sparx5);
+void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
@@ -146,6 +160,8 @@ static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 	}
 }
 
+extern const struct phylink_mac_ops sparx5_phylink_mac_ops;
+
 /* Calculate raw offset */
 static inline __pure int spx5_offset(int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
new file mode 100644
index 000000000000..0c3dfffedda4
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+/* The IFH bit position of the first VSTAX bit. This is because the
+ * VSTAX bit positions in Data sheet is starting from zero.
+ */
+#define VSTAX 73
+
+static void ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
+{
+	u8 *ifh_hdr = ifh;
+	/* Calculate the Start IFH byte position of this IFH bit position */
+	u32 byte = (35 - (pos / 8));
+	/* Calculate the Start bit position in the Start IFH byte */
+	u32 bit  = (pos % 8);
+	u64 encode = GENMASK(bit + width - 1, bit) & (value << bit);
+
+	/* Max width is 5 bytes - 40 bits. In worst case this will
+	 * spread over 6 bytes - 48 bits
+	 */
+	compiletime_assert(width <= 40, "Unsupported width, must be <= 40");
+
+	/* The b0-b7 goes into the start IFH byte */
+	if (encode & 0xFF)
+		ifh_hdr[byte] |= (u8)((encode & 0xFF));
+	/* The b8-b15 goes into the next IFH byte */
+	if (encode & 0xFF00)
+		ifh_hdr[byte - 1] |= (u8)((encode & 0xFF00) >> 8);
+	/* The b16-b23 goes into the next IFH byte */
+	if (encode & 0xFF0000)
+		ifh_hdr[byte - 2] |= (u8)((encode & 0xFF0000) >> 16);
+	/* The b24-b31 goes into the next IFH byte */
+	if (encode & 0xFF000000)
+		ifh_hdr[byte - 3] |= (u8)((encode & 0xFF000000) >> 24);
+	/* The b32-b39 goes into the next IFH byte */
+	if (encode & 0xFF00000000)
+		ifh_hdr[byte - 4] |= (u8)((encode & 0xFF00000000) >> 32);
+	/* The b40-b47 goes into the next IFH byte */
+	if (encode & 0xFF0000000000)
+		ifh_hdr[byte - 5] |= (u8)((encode & 0xFF0000000000) >> 40);
+}
+
+static void sparx5_set_port_ifh(void *ifh_hdr, u16 portno)
+{
+	/* VSTAX.RSV = 1. MSBit must be 1 */
+	ifh_encode_bitfield(ifh_hdr, 1, VSTAX + 79,  1);
+	/* VSTAX.INGR_DROP_MODE = Enable. Don't make head-of-line blocking */
+	ifh_encode_bitfield(ifh_hdr, 1, VSTAX + 55,  1);
+	/* MISC.CPU_MASK/DPORT = Destination port */
+	ifh_encode_bitfield(ifh_hdr, portno,   29, 8);
+	/* MISC.PIPELINE_PT */
+	ifh_encode_bitfield(ifh_hdr, 16,       37, 5);
+	/* MISC.PIPELINE_ACT */
+	ifh_encode_bitfield(ifh_hdr, 1,        42, 3);
+	/* FWD.SRC_PORT = CPU */
+	ifh_encode_bitfield(ifh_hdr, SPX5_PORT_CPU, 46, 7);
+	/* FWD.SFLOW_ID (disable SFlow sampling) */
+	ifh_encode_bitfield(ifh_hdr, 124,      57, 7);
+	/* FWD.UPDATE_FCS = Enable. Enforce update of FCS. */
+	ifh_encode_bitfield(ifh_hdr, 1,        67, 1);
+}
+
+static int sparx5_port_open(struct net_device *ndev)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	int err = 0;
+
+	err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
+	if (err) {
+		netdev_err(ndev, "Could not attach to PHY\n");
+		return err;
+	}
+
+	phylink_start(port->phylink);
+
+	if (!ndev->phydev) {
+		/* power up serdes */
+		port->conf.power_down = false;
+		err = phy_power_on(port->serdes);
+		if (err)
+			netdev_err(ndev, "%s failed\n", __func__);
+	}
+
+	return err;
+}
+
+static int sparx5_port_stop(struct net_device *ndev)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	int err = 0;
+
+	phylink_stop(port->phylink);
+	phylink_disconnect_phy(port->phylink);
+
+	if (!ndev->phydev) {
+		port->conf.power_down = true;
+		err = phy_power_off(port->serdes);
+		if (err)
+			netdev_err(ndev, "%s failed\n", __func__);
+	}
+	return 0;
+}
+
+static int sparx5_port_get_phys_port_name(struct net_device *dev,
+					  char *buf, size_t len)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int ret;
+
+	ret = snprintf(buf, len, "p%d", port->portno);
+	if (ret >= len)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int sparx5_set_mac_address(struct net_device *dev, void *p)
+{
+	const struct sockaddr *addr = p;
+
+	/* Record the address */
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
+
+	return 0;
+}
+
+static const struct net_device_ops sparx5_port_netdev_ops = {
+	.ndo_open               = sparx5_port_open,
+	.ndo_stop               = sparx5_port_stop,
+	.ndo_start_xmit         = sparx5_port_xmit_impl,
+	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
+	.ndo_set_mac_address    = sparx5_set_mac_address,
+	.ndo_validate_addr      = eth_validate_addr,
+};
+
+bool sparx5_netdevice_check(const struct net_device *dev)
+{
+	return dev && (dev->netdev_ops == &sparx5_port_netdev_ops);
+}
+
+struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
+{
+	struct net_device *ndev;
+	struct sparx5_port *spx5_port;
+	u64 val;
+
+	ndev = devm_alloc_etherdev(sparx5->dev, sizeof(struct sparx5_port));
+	if (!ndev)
+		return ERR_PTR(-ENOMEM);
+
+	SET_NETDEV_DEV(ndev, sparx5->dev);
+	spx5_port = netdev_priv(ndev);
+	spx5_port->ndev = ndev;
+	spx5_port->sparx5 = sparx5;
+	spx5_port->portno = portno;
+	sparx5_set_port_ifh(spx5_port->ifh, portno);
+	snprintf(ndev->name, IFNAMSIZ, "eth%d", portno);
+
+	ndev->netdev_ops = &sparx5_port_netdev_ops;
+	ndev->features |= NETIF_F_LLTX; /* software tx */
+
+	val = ether_addr_to_u64(sparx5->base_mac) + portno + 1;
+	u64_to_ether_addr(val, ndev->dev_addr);
+
+	return ndev;
+}
+
+int sparx5_register_netdevs(struct sparx5 *sparx5)
+{
+	int portno;
+	int err;
+
+	for (portno = 0; portno < SPX5_PORTS; portno++)
+		if (sparx5->ports[portno]) {
+			err = devm_register_netdev(sparx5->dev,
+						   sparx5->ports[portno]->ndev);
+			if (err) {
+				dev_err(sparx5->dev,
+					"port: %02u: netdev registration failed\n",
+					portno);
+				return err;
+			}
+		}
+	return 0;
+}
+
+void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port)
+{
+	if (port->phylink) {
+		/* Disconnect the phy */
+		rtnl_lock();
+		sparx5_port_stop(port->ndev);
+		phylink_disconnect_phy(port->phylink);
+		rtnl_unlock();
+		phylink_destroy(port->phylink);
+		port->phylink = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
new file mode 100644
index 000000000000..22177134e1cc
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+#define XTR_EOF_0     ntohl((__force __be32)0x80000000u)
+#define XTR_EOF_1     ntohl((__force __be32)0x80000001u)
+#define XTR_EOF_2     ntohl((__force __be32)0x80000002u)
+#define XTR_EOF_3     ntohl((__force __be32)0x80000003u)
+#define XTR_PRUNED    ntohl((__force __be32)0x80000004u)
+#define XTR_ABORT     ntohl((__force __be32)0x80000005u)
+#define XTR_ESCAPE    ntohl((__force __be32)0x80000006u)
+#define XTR_NOT_READY ntohl((__force __be32)0x80000007u)
+
+#define XTR_VALID_BYTES(x)      (4 - ((x) & 3))
+
+#define XTR_QUEUE     0
+#define INJ_QUEUE     0
+
+struct frame_info {
+	int src_port;
+};
+
+static void sparx5_xtr_flush(struct sparx5 *sparx5, u8 grp)
+{
+	/* Start flush */
+	spx5_wr(QS_XTR_FLUSH_FLUSH_SET(BIT(grp)), sparx5, QS_XTR_FLUSH);
+
+	/* Allow to drain */
+	mdelay(1);
+
+	/* All Queues normal */
+	spx5_wr(0, sparx5, QS_XTR_FLUSH);
+}
+
+static void sparx5_ifh_parse(u32 *ifh, struct frame_info *info)
+{
+	u8 *xtr_hdr = (u8 *)ifh;
+
+	/* FWD is bit 45-72 (28 bits), but we only read the 27 LSB for now */
+	u32 fwd =
+		((u32)xtr_hdr[27] << 24) |
+		((u32)xtr_hdr[28] << 16) |
+		((u32)xtr_hdr[29] <<  8) |
+		((u32)xtr_hdr[30] <<  0);
+	fwd = (fwd >> 5);
+	info->src_port = FIELD_GET(GENMASK(7, 1), fwd);
+}
+
+static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
+{
+	int i, byte_cnt = 0;
+	bool eof_flag = false, pruned_flag = false, abort_flag = false;
+	u32 ifh[IFH_LEN];
+	struct sk_buff *skb;
+	struct frame_info fi;
+	struct sparx5_port *port;
+	struct net_device *netdev;
+	u32 *rxbuf;
+
+	/* Get IFH */
+	for (i = 0; i < IFH_LEN; i++)
+		ifh[i] = spx5_rd(sparx5, QS_XTR_RD(grp));
+
+	/* Decode IFH (whats needed) */
+	sparx5_ifh_parse(ifh, &fi);
+
+	/* Map to port netdev */
+	port = fi.src_port < SPX5_PORTS ?
+		sparx5->ports[fi.src_port] : NULL;
+	if (!port || !port->ndev) {
+		dev_err(sparx5->dev, "Data on inactive port %d\n", fi.src_port);
+		sparx5_xtr_flush(sparx5, grp);
+		return;
+	}
+
+	/* Have netdev, get skb */
+	netdev = port->ndev;
+	skb = netdev_alloc_skb(netdev, netdev->mtu + ETH_HLEN);
+	if (!skb) {
+		sparx5_xtr_flush(sparx5, grp);
+		dev_err(sparx5->dev, "No skb allocated\n");
+		return;
+	}
+	rxbuf = (u32 *)skb->data;
+
+	/* Now, pull frame data */
+	while (!eof_flag) {
+		u32 val = spx5_rd(sparx5, QS_XTR_RD(grp));
+		u32 cmp = val;
+
+		if (byte_swap)
+			cmp = ntohl((__force __be32)val);
+
+		switch (cmp) {
+		case XTR_NOT_READY:
+			break;
+		case XTR_ABORT:
+			/* No accompanying data */
+			abort_flag = true;
+			eof_flag = true;
+			break;
+		case XTR_EOF_0:
+		case XTR_EOF_1:
+		case XTR_EOF_2:
+		case XTR_EOF_3:
+			/* This assumes STATUS_WORD_POS == 1, Status
+			 * just after last data
+			 */
+			byte_cnt -= (4 - XTR_VALID_BYTES(val));
+			eof_flag = true;
+			break;
+		case XTR_PRUNED:
+			/* But get the last 4 bytes as well */
+			eof_flag = true;
+			pruned_flag = true;
+			fallthrough;
+		case XTR_ESCAPE:
+			*rxbuf = spx5_rd(sparx5, QS_XTR_RD(grp));
+			byte_cnt += 4;
+			rxbuf++;
+			break;
+		default:
+			*rxbuf = val;
+			byte_cnt += 4;
+			rxbuf++;
+		}
+	}
+
+	if (abort_flag || pruned_flag || !eof_flag) {
+		netdev_err(netdev, "Discarded frame: abort:%d pruned:%d eof:%d\n",
+			   abort_flag, pruned_flag, eof_flag);
+		kfree_skb(skb);
+		return;
+	}
+
+#if defined(CONFIG_DEBUG_KERNEL) /* TODO: Remove before upstreaming */
+	if (!netif_oper_up(netdev)) {
+		netdev_err(netdev, "Discarded frame: Interface not up\n");
+		kfree_skb(skb);
+		return;
+	}
+#endif
+
+	/* Finish up skb */
+	skb_put(skb, byte_cnt - ETH_FCS_LEN);
+	eth_skb_pad(skb);
+	skb->protocol = eth_type_trans(skb, netdev);
+	netif_rx(skb);
+	netdev->stats.rx_bytes += skb->len;
+	netdev->stats.rx_packets++;
+}
+
+static int sparx5_inject(struct sparx5 *sparx5,
+			 u32 *ifh,
+			 struct sk_buff *skb)
+{
+	u32 val, w, count;
+	int grp = INJ_QUEUE;
+	u8 *buf;
+
+	val = spx5_rd(sparx5, QS_INJ_STATUS);
+	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
+		pr_err("Injection: Queue not ready: 0x%lx\n",
+		       QS_INJ_STATUS_FIFO_RDY_GET(val));
+		return -EBUSY;
+	}
+
+	if (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)) {
+		pr_err("Injection: Watermark reached: 0x%lx\n",
+		       QS_INJ_STATUS_WMARK_REACHED_GET(val));
+		return -EBUSY;
+	}
+
+	/* Indicate SOF */
+	spx5_wr(QS_INJ_CTRL_SOF_SET(1) |
+		QS_INJ_CTRL_GAP_SIZE_SET(1),
+		sparx5, QS_INJ_CTRL(grp));
+
+	// Write the IFH to the chip.
+	for (w = 0; w < IFH_LEN; w++)
+		spx5_wr(ifh[w], sparx5, QS_INJ_WR(grp));
+
+	/* Write words, round up */
+	count = ((skb->len + 3) / 4);
+	buf = skb->data;
+	for (w = 0; w < count; w++, buf += 4) {
+		val = get_unaligned((const u32 *)buf);
+		spx5_wr(val, sparx5, QS_INJ_WR(grp));
+	}
+
+	/* Add padding */
+	while (w < (60 / 4)) {
+		spx5_wr(0, sparx5, QS_INJ_WR(grp));
+		w++;
+	}
+
+	/* Indicate EOF and valid bytes in last word */
+	spx5_wr(QS_INJ_CTRL_GAP_SIZE_SET(1) |
+		QS_INJ_CTRL_VLD_BYTES_SET(skb->len < 60 ? 0 : skb->len % 4) |
+		QS_INJ_CTRL_EOF_SET(1),
+		sparx5, QS_INJ_CTRL(grp));
+
+	/* Add dummy CRC */
+	spx5_wr(0, sparx5, QS_INJ_WR(grp));
+	w++;
+
+	return NETDEV_TX_OK;
+}
+
+int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+	struct net_device_stats *stats = &dev->stats;
+	int ret;
+
+	ret = sparx5_inject(sparx5, port->ifh, skb);
+
+	if (ret == NETDEV_TX_OK) {
+		stats->tx_bytes += skb->len;
+		stats->tx_packets++;
+	} else {
+		stats->tx_dropped++;
+	}
+
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+void sparx5_manual_injection_mode(struct sparx5 *sparx5)
+{
+	const int byte_swap = 1;
+	int portno;
+
+	/* Change mode to manual extraction and injection */
+	spx5_wr(QS_XTR_GRP_CFG_MODE_SET(1) |
+		QS_XTR_GRP_CFG_STATUS_WORD_POS_SET(1) |
+		QS_XTR_GRP_CFG_BYTE_SWAP_SET(byte_swap),
+		sparx5, QS_XTR_GRP_CFG(XTR_QUEUE));
+	spx5_wr(QS_INJ_GRP_CFG_MODE_SET(1) |
+		QS_INJ_GRP_CFG_BYTE_SWAP_SET(byte_swap),
+		sparx5, QS_INJ_GRP_CFG(INJ_QUEUE));
+
+	/* CPU ports capture setup */
+	for (portno = SPX5_PORT_CPU_0; portno <= SPX5_PORT_CPU_1; portno++) {
+		/* ASM CPU port: No preamble, IFH, enable padding */
+		spx5_wr(ASM_PORT_CFG_PAD_ENA_SET(1) |
+			ASM_PORT_CFG_NO_PREAMBLE_ENA_SET(1) |
+			ASM_PORT_CFG_INJ_FORMAT_CFG_SET(1), /* 1 = IFH */
+			sparx5, ASM_PORT_CFG(portno));
+	}
+
+	/* Reset WM cnt to unclog queued frames */
+	for (portno = SPX5_PORT_CPU_0; portno <= SPX5_PORT_CPU_1; portno++)
+		spx5_rmw(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR_SET(1),
+			 DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR,
+			 sparx5,
+			 DSM_DEV_TX_STOP_WM_CFG(portno));
+}
+
+irqreturn_t sparx5_xtr_handler(int irq, void *_sparx5)
+{
+	struct sparx5 *s5 = _sparx5;
+	int poll = 64;
+
+	/* Check data in queue */
+	while (spx5_rd(s5, QS_XTR_DATA_PRESENT) & BIT(XTR_QUEUE) && poll-- > 0)
+		sparx5_xtr_grp(s5, XTR_QUEUE, false);
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
new file mode 100644
index 000000000000..6d695994a7b0
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/module.h>
+#include <linux/phylink.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/sfp.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static void sparx5_phylink_validate(struct phylink_config *config,
+				    unsigned long *supported,
+				    struct phylink_link_state *state)
+{
+	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	phylink_set(mask, Autoneg);
+	phylink_set_port_modes(mask);
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_NA:
+		if (port->conf.bandwidth == SPEED_25000 ||
+		    port->conf.bandwidth == SPEED_10000) {
+			phylink_set(mask, 5000baseT_Full);
+			phylink_set(mask, 10000baseT_Full);
+			phylink_set(mask, 10000baseCR_Full);
+			phylink_set(mask, 10000baseSR_Full);
+			phylink_set(mask, 10000baseLR_Full);
+			phylink_set(mask, 10000baseLRM_Full);
+			phylink_set(mask, 10000baseER_Full);
+		}
+		if (port->conf.bandwidth == SPEED_25000) {
+			phylink_set(mask, 25000baseCR_Full);
+			phylink_set(mask, 25000baseSR_Full);
+		}
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			break;
+		fallthrough;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			break;
+		fallthrough;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+		}
+		if (state->interface == PHY_INTERFACE_MODE_2500BASEX ||
+		    state->interface == PHY_INTERFACE_MODE_NA) {
+			phylink_set(mask, 2500baseT_Full);
+			phylink_set(mask, 2500baseX_Full);
+		}
+		break;
+	default:
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static bool port_conf_has_changed(struct sparx5_port_config *a, struct sparx5_port_config *b)
+{
+	if (a->speed != b->speed ||
+	    a->portmode != b->portmode ||
+	    a->autoneg != b->autoneg ||
+	    a->pause != b->pause ||
+	    a->media_type != b->media_type)
+		return true;
+	return false;
+}
+
+static void sparx5_phylink_mac_config(struct phylink_config *config,
+				      unsigned int mode,
+				      const struct phylink_link_state *state)
+{
+	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
+	struct sparx5_port_config conf;
+
+	conf = port->conf;
+	conf.power_down = false;
+	conf.portmode = state->interface;
+	conf.speed = state->speed;
+	conf.autoneg = state->an_enabled;
+	conf.pause = state->pause;
+
+	if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
+		if (state->speed == SPEED_UNKNOWN) {
+			/* When a SFP is plugged in we use capabilities to
+			 * default to the highest supported speed
+			 */
+			if (phylink_test(state->advertising, 25000baseSR_Full) ||
+			    phylink_test(state->advertising, 25000baseCR_Full))
+				conf.speed = SPEED_25000;
+			else if (state->interface == PHY_INTERFACE_MODE_10GBASER)
+				conf.speed = SPEED_10000;
+		} else if (state->speed == SPEED_2500) {
+			conf.portmode = PHY_INTERFACE_MODE_2500BASEX;
+		} else if (state->speed == SPEED_1000) {
+			conf.portmode = PHY_INTERFACE_MODE_1000BASEX;
+		}
+
+		if (phylink_test(state->advertising, FIBRE))
+			conf.media_type = ETH_MEDIA_SR;
+		else
+			conf.media_type = ETH_MEDIA_DAC;
+	}
+
+	if (!port_conf_has_changed(&port->conf, &conf))
+		return;
+}
+
+static void sparx5_phylink_mac_link_up(struct phylink_config *config,
+				       struct phy_device *phy,
+				       unsigned int mode,
+				       phy_interface_t interface,
+				       int speed, int duplex,
+				       bool tx_pause, bool rx_pause)
+{
+	/* Currently not used */
+}
+
+static void sparx5_phylink_mac_link_state(struct phylink_config *config,
+					  struct phylink_link_state *state)
+{
+	state->link = true;
+	state->an_complete = true;
+	state->speed = SPEED_1000;
+	state->duplex = true;
+	state->pause = MLO_PAUSE_AN;
+}
+
+static void sparx5_phylink_mac_aneg_restart(struct phylink_config *config)
+{
+	/* Currently not used */
+}
+
+static void sparx5_phylink_mac_link_down(struct phylink_config *config,
+					 unsigned int mode,
+					 phy_interface_t interface)
+{
+	/* Currently not used */
+}
+
+const struct phylink_mac_ops sparx5_phylink_mac_ops = {
+	.validate = sparx5_phylink_validate,
+	.mac_pcs_get_state = sparx5_phylink_mac_link_state,
+	.mac_config = sparx5_phylink_mac_config,
+	.mac_an_restart = sparx5_phylink_mac_aneg_restart,
+	.mac_link_down = sparx5_phylink_mac_link_down,
+	.mac_link_up = sparx5_phylink_mac_link_up,
+};
-- 
2.29.2

