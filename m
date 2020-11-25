Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E452C4BA3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgKYXZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:25:53 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:53264 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbgKYXZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 18:25:52 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChH7c6Sjlz1qs3T;
        Thu, 26 Nov 2020 00:25:48 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChH7c4fPPz1vdfr;
        Thu, 26 Nov 2020 00:25:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id g3MDGMLJmW-c; Thu, 26 Nov 2020 00:25:45 +0100 (CET)
X-Auth-Info: IeiHtiPYoFdCUa+1+vvG45H4aIS8SmrvEwdzEGWEk6I=
Received: from localhost.localdomain (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Nov 2020 00:25:45 +0100 (CET)
From:   Lukasz Majewski <lukma@denx.de>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Lukasz Majewski <lukma@denx.de>
Subject: [RFC 2/4] net: dsa: Provide DSA driver for NXP's More Than IP L2 switch
Date:   Thu, 26 Nov 2020 00:24:57 +0100
Message-Id: <20201125232459.378-3-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125232459.378-1-lukma@denx.de>
References: <20201125232459.378-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change provides driver for DSA (Distributed Switch Architecture)
subsystem for i.MX28 SoC (imx287 to be precise).

This code just is responsible for configuring this device as L2 bridge
(no vlan, port separation supported).

This driver shall be regarded as a complementary one for NXP's FEC
(fec_main.c).

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/dsa/Kconfig         |  11 +
 drivers/net/dsa/Makefile        |   1 +
 drivers/net/dsa/mtip-l2switch.c | 399 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mtip-l2switch.h | 239 +++++++++++++++++++
 4 files changed, 650 insertions(+)
 create mode 100644 drivers/net/dsa/mtip-l2switch.c
 create mode 100644 drivers/net/dsa/mtip-l2switch.h

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 468b3c4273c5..52013eb5afb3 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -132,4 +132,15 @@ config NET_DSA_VITESSE_VSC73XX_PLATFORM
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
 	  and VSC7398 SparX integrated ethernet switches, connected over
 	  a CPU-attached address bus and work in memory-mapped I/O mode.
+
+config NET_DSA_MTIP_L2SW
+	tristate "MoreThanIP L2 switch support (IMX)"
+	depends on OF
+	depends on NET_DSA
+	depends on ARCH_MXS
+	select FIXED_PHY
+	help
+	  This enables support for the MoreThan IP on i.MX SoCs (e.g. iMX28)
+	  L2 switch.
+
 endmenu
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 4a943ccc2ca4..b947dc54db09 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
+obj-$(CONFIG_NET_DSA_MTIP_L2SW) += mtip-l2switch.o
 obj-y				+= b53/
 obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
diff --git a/drivers/net/dsa/mtip-l2switch.c b/drivers/net/dsa/mtip-l2switch.c
new file mode 100644
index 000000000000..2ecdf82ccd6c
--- /dev/null
+++ b/drivers/net/dsa/mtip-l2switch.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Lukasz Majewski <lukma@denx.de>
+ */
+
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+#include <net/dsa.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/if_bridge.h>
+#include <linux/mdio.h>
+#include <linux/of_mdio.h>
+#include <linux/etherdevice.h>
+
+#include "mtip-l2switch.h"
+#include "../ethernet/freescale/fec.h"
+
+static int mtipl2_en_rx(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	if (!fep->hwpsw)
+		return -ENODEV;
+
+	writel(MCF_ESW_RDAR_R_DES_ACTIVE, fep->hwpsw + MCF_ESW_R_RDAR);
+
+	return 0;
+}
+
+static int mtipl2_set_rx_buf_size(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	if (!fep->hwpsw)
+		return -ENODEV;
+
+	/* Set the max rx buffer size */
+	writel(L2SW_PKT_MAXBLR_SIZE, fep->hwpsw + MCF_ESW_R_BUFF_SIZE);
+
+	return 0;
+}
+
+static int mtipl2_set_ints(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	if (!fep->hwpsw)
+		return -ENODEV;
+
+	/* Clear all pending interrupts */
+	writel(0xffffffff, fep->hwpsw + FEC_IEVENT);
+
+	/* Enable interrupts we wish to service */
+	writel(MCF_ESW_IMR_TXF | MCF_ESW_IMR_RXB | MCF_ESW_IMR_TXB,
+	       fep->hwpsw + FEC_IMASK);
+
+	return 0;
+}
+
+static void read_atable(struct mtipl2sw_priv *priv, int index,
+	unsigned long *read_lo, unsigned long *read_hi)
+{
+	unsigned long atable_base = (unsigned long)priv->hwentry;
+
+	*read_lo = readl((const volatile void*)atable_base + (index << 3));
+	*read_hi = readl((const volatile void*)atable_base + (index << 3) + 4);
+}
+
+static void write_atable(struct mtipl2sw_priv *priv, int index,
+	unsigned long write_lo, unsigned long write_hi)
+{
+	unsigned long atable_base = (unsigned long)priv->hwentry;
+
+	writel(write_lo, (volatile void *)atable_base + (index << 3));
+	writel(write_hi, (volatile void *)atable_base + (index << 3) + 4);
+}
+
+/*
+ * Clear complete MAC Look Up Table
+ */
+static void esw_clear_atable(struct mtipl2sw_priv *priv)
+{
+	int index;
+	for (index = 0; index < 2048; index++)
+		write_atable(priv, index, 0, 0);
+}
+
+static void l2_enet_set_mac(struct net_device *ndev, void __iomem *hwp)
+{
+	writel(ndev->dev_addr[3] |
+	       ndev->dev_addr[2] << 8 |
+	       ndev->dev_addr[1] << 16 |
+	       ndev->dev_addr[0] << 24,
+	       hwp + FEC_ADDR_LOW);
+
+	writel(ndev->dev_addr[5] << 16 |
+	       (ndev->dev_addr[4] + (unsigned char)(0)) << 24,
+	       hwp + FEC_ADDR_HIGH);
+}
+
+static void l2_enet_reset(struct net_device *ndev, int port,
+			  struct phy_device *phy)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	void __iomem *hwp = fep->hwp;
+
+	if (port == 1)
+		hwp += ENET_L2_SW_PORT1_OFFSET;
+
+	/* ECR */
+	writel(FEC_ECR_MAGICEN, hwp + FEC_ECNTRL);
+	/* EMRBR */
+	writel(L2SW_PKT_MAXBLR_SIZE, hwp + MCF_FEC_EMRBR);
+
+	/*
+	 * PHY speed for both MACs (via mac0 adjustement is setup
+	 * in fec_restart()
+	 */
+
+	/* EIR */
+	writel(0, hwp + FEC_IEVENT);
+	/* IAUR */
+	writel(0, hwp + FEC_HASH_TABLE_HIGH);
+	/* IALR */
+	writel(0, hwp + FEC_HASH_TABLE_LOW);
+	/* GAUR */
+	writel(0, hwp + FEC_GRP_HASH_TABLE_HIGH);
+	/* GALR */
+	writel(0, hwp + FEC_GRP_HASH_TABLE_LOW);
+	/* EMRBR */
+	writel(L2SW_PKT_MAXBLR_SIZE, hwp + MCF_FEC_EMRBR);
+
+	/* Set the MAC address for the LAN{12} net device */
+	l2_enet_set_mac(ndev, hwp);
+
+	/* RCR */
+	if (phy && phy->speed == SPEED_100) {
+		if (phy->duplex == DUPLEX_FULL) {
+			/* full duplex mode */
+			writel((readl(hwp + FEC_R_CNTRL)
+				| MCF_FEC_RCR_FCE | MCF_FEC_RCR_PROM)
+			       & ~(MCF_FEC_RCR_RMII_10BASET |
+				   MCF_FEC_RCR_DRT),
+			       hwp + FEC_R_CNTRL);
+		} else {
+			/* half duplex mode */
+			writel((readl(hwp + FEC_R_CNTRL)
+				| MCF_FEC_RCR_FCE | MCF_FEC_RCR_PROM
+				| MCF_FEC_RCR_DRT)
+			       & ~(MCF_FEC_RCR_RMII_10BASET),
+			       hwp + FEC_R_CNTRL);
+		}
+	} else {
+		if (phy->duplex == DUPLEX_FULL) {
+			/* full duplex mode */
+			writel((readl(hwp + FEC_R_CNTRL)
+				| MCF_FEC_RCR_FCE | MCF_FEC_RCR_PROM
+				| MCF_FEC_RCR_RMII_10BASET) &
+			       ~(MCF_FEC_RCR_DRT),
+			       hwp + FEC_R_CNTRL);
+		} else {
+			/* half duplex mode */
+			writel(readl(hwp + FEC_R_CNTRL)
+			       | MCF_FEC_RCR_FCE | MCF_FEC_RCR_PROM
+			       | MCF_FEC_RCR_RMII_10BASET | MCF_FEC_RCR_DRT,
+			       hwp + FEC_R_CNTRL);
+		}
+	}
+
+	/*
+	 * MII Gasket configuration is performed for MAC0 (which shall be
+	 * correct for both MACs) in fec_restart().
+	 *
+	 * Configuration: RMII, 50 MHz, no loopback, no echo
+	 */
+
+	/* TCR */
+	if (phy->duplex == DUPLEX_FULL)
+		writel(0x1c, hwp + FEC_X_CNTRL);
+	else
+		writel(0x18, hwp + FEC_X_CNTRL);
+
+	/* ECR */
+	writel(readl(hwp + FEC_ECNTRL) | FEC_ECNTRL_ETHER_EN,
+	       hwp + FEC_ECNTRL);
+}
+
+static enum dsa_tag_protocol
+mtipl2_get_tag_protocol(struct dsa_switch *ds, int port,
+			enum dsa_tag_protocol mp)
+{
+	return DSA_TAG_PROTO_NONE;
+}
+
+static int mtip_sw_config(struct dsa_switch *ds)
+{
+	struct mtipl2sw_priv *priv = (struct mtipl2sw_priv *)ds->priv;
+	const struct dsa_port *pm = dsa_to_port(ds, priv->cpu_port);
+
+	/*
+	 * L2 switch - reset
+	 */
+	writel(MCF_ESW_MODE_SW_RST, &priv->fecp->ESW_MODE);
+	udelay(10);
+
+	/* Configure switch*/
+	writel(MCF_ESW_MODE_STATRST, &priv->fecp->ESW_MODE);
+	writel(MCF_ESW_MODE_SW_EN, &priv->fecp->ESW_MODE);
+
+	/*
+	 * Transmit/Receive on ports 1,2 (including port 0)
+	 * will be enabled when DSA port is enabled
+	 */
+
+	/* Management port configuration, make port 0 as management port */
+	writel(0, &priv->fecp->ESW_BMPC);
+
+	/*
+	 * Set backpressure threshold to minimize discarded frames
+	 * during due to congestion.
+	 */
+	writel(P0BC_THRESHOLD, &priv->fecp->ESW_P0BCT);
+
+	mtipl2_set_rx_buf_size(pm->master);
+
+	/* Enable broadcast on all ports */
+	writel(0x7, &priv->fecp->ESW_DBCR);
+
+	/* Enable multicast on all ports */
+	writel(0x7, &priv->fecp->ESW_DMCR);
+
+	esw_clear_atable(priv);
+	mtipl2_set_ints(pm->master);
+
+	return 0;
+}
+
+static int mtipl2_setup(struct dsa_switch *ds)
+{
+	struct mtipl2sw_priv *priv = (struct mtipl2sw_priv *)ds->priv;
+
+	/* Make sure that port 2 is the cpu port */
+	if (dsa_is_cpu_port(ds, 2))
+		priv->cpu_port = 2;
+	else
+		return -EINVAL;
+
+	mtip_sw_config(ds);
+	return 0;
+}
+
+void mtipl2_adjust_link (struct dsa_switch *ds, int port,
+			 struct phy_device *phy)
+{
+	struct mtipl2sw_priv *priv = (struct mtipl2sw_priv *)ds->priv;
+	const struct dsa_port *pm = dsa_to_port(ds, priv->cpu_port);
+
+	/* Set port speed */
+	switch (phy->speed) {
+	case 10:
+		pr_err("fec: %s: PHY speed 10 [%d]\n", __func__, port);
+		break;
+	case 100:
+		pr_err("fec: %s: PHY speed 100 [%d]\n", __func__, port);
+		break;
+	default:
+		pr_err("port%d link speed %dMbps not supported.\n", port,
+		       phy->speed);
+		return;
+	}
+
+	/* Set duplex mode */
+	if (phy->duplex == DUPLEX_FULL)
+		pr_err("fec: %s: LINK UPDATE DUPLEX_FULL [%d]\n", __func__,
+		       port);
+
+	/* Reset and configure L2 switch port */
+	l2_enet_reset(pm->master, port, phy);
+
+	/*
+	 * The L2 switch R_RDAR register needs to be updated
+	 * after the port is enabled.
+	 */
+	mtipl2_en_rx(pm->master);
+}
+
+int mtipl2_port_enable (struct dsa_switch *ds, int port,
+			struct phy_device *phydev)
+{
+	struct mtipl2sw_priv *priv = (struct mtipl2sw_priv *)ds->priv;
+	struct dsa_port *pm = dsa_to_port(ds, priv->cpu_port);
+	u32 l2_ports_en;
+
+	pr_err("fec: %s: PORT ENABLE %d\n", __func__, port);
+
+	/* The CPU port shall be always enabled - as it is a "fixed-link" one */
+	if (port == priv->cpu_port || priv->cpu_port == -1)
+		return 0;
+
+	/* Enable tx/rx on L2 switch ports */
+	l2_ports_en = readl(&priv->fecp->ESW_PER);
+	if (!(l2_ports_en & MCF_ESW_ENA_PORT_0))
+		l2_ports_en = MCF_ESW_ENA_PORT_0;
+
+	if (port == 0 && !(l2_ports_en & MCF_ESW_ENA_PORT_1))
+		l2_ports_en |= MCF_ESW_ENA_PORT_1;
+
+	if (port == 1 && !(l2_ports_en & MCF_ESW_ENA_PORT_2))
+		l2_ports_en |= MCF_ESW_ENA_PORT_2;
+
+	writel(l2_ports_en, &priv->fecp->ESW_PER);
+
+	/*
+	 * Check if MAC IP block is already enabled (after switch initializtion)
+	 * or if we need to enable it after mtipl2_port_disable was called.
+	 */
+
+	return 0;
+}
+
+static void mtipl2_port_disable (struct dsa_switch *ds, int port)
+{
+	struct mtipl2sw_priv *priv = (struct mtipl2sw_priv *)ds->priv;
+	struct dsa_port *pm = dsa_to_port(ds, priv->cpu_port);
+	u32 l2_ports_en;
+
+	pr_err("fec: %s: PORT DISABLE %d\n", __func__, port);
+
+	l2_ports_en = readl(&priv->fecp->ESW_PER);
+	if (port == 0)
+		l2_ports_en &= ~MCF_ESW_ENA_PORT_1;
+
+	if (port == 1)
+		l2_ports_en &= ~MCF_ESW_ENA_PORT_2;
+
+	/* Finally disable tx/rx on port 0 */
+	if (!(l2_ports_en & MCF_ESW_ENA_PORT_1) &&
+	    !(l2_ports_en & MCF_ESW_ENA_PORT_2))
+		l2_ports_en &= ~MCF_ESW_ENA_PORT_0;
+
+	writel(l2_ports_en, &priv->fecp->ESW_PER);
+}
+
+static const struct dsa_switch_ops mtipl2_switch_ops = {
+	.get_tag_protocol	= mtipl2_get_tag_protocol,
+	.setup			= mtipl2_setup,
+	.adjust_link            = mtipl2_adjust_link,
+	.port_enable		= mtipl2_port_enable,
+	.port_disable		= mtipl2_port_disable,
+};
+
+static int mtipl2_sw_probe(struct platform_device *pdev)
+{
+	struct mtipl2sw_priv *priv;
+	struct resource *r;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->fecp = devm_ioremap_resource(&pdev->dev, r);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	priv->hwentry = devm_ioremap_resource(&pdev->dev, r);
+
+	priv->ds = devm_kzalloc(&pdev->dev, sizeof(*priv->ds), GFP_KERNEL);
+	if (!priv->ds)
+		return -ENOMEM;
+
+	priv->ds->dev = &pdev->dev;
+	priv->ds->num_ports = MTIPL2SW_NUM_PORTS;
+	priv->ds->priv = priv;
+	priv->ds->ops = &mtipl2_switch_ops;
+
+	return dsa_register_switch(priv->ds);
+}
+
+static const struct of_device_id mtipl2_of_match[] = {
+	{ .compatible = "imx,mtip-l2switch" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver mtipl2plat_driver = {
+	.probe  = mtipl2_sw_probe,
+	.driver = {
+		.name = "mtipl2sw",
+		.of_match_table = mtipl2_of_match,
+	},
+};
+
+module_platform_driver(mtipl2plat_driver);
+
+MODULE_AUTHOR("Lukasz Majewski <lukma@denx.de>");
+MODULE_DESCRIPTION("Driver for MTIP L2 on SOC switch");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:mtipl2sw");
diff --git a/drivers/net/dsa/mtip-l2switch.h b/drivers/net/dsa/mtip-l2switch.h
new file mode 100644
index 000000000000..ea354ae99ecd
--- /dev/null
+++ b/drivers/net/dsa/mtip-l2switch.h
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 DENX Software Engineering GmbH
+ * Lukasz Majewski <lukma@denx.de>
+ */
+
+#ifndef __MTIP_L2SWITCH_H_
+#define __MTIP_L2SWITCH_H_
+
+#define MTIPL2SW_NUM_PORTS 3
+
+#define ENET_SWI_PHYS_ADDR_OFFSET 0x8000
+#define ENET_L2_SW_PORT1_OFFSET 0x4000
+/* Bit definitions and macros for MCF_ESW_MODE */
+#define MCF_ESW_MODE_SW_RST BIT(0)
+#define MCF_ESW_MODE_SW_EN  BIT(1)
+#define MCF_ESW_MODE_STATRST BIT(31)
+
+/* Port 0 backpressure congestion threshold */
+#define P0BC_THRESHOLD		0x40
+
+struct esw_output_queue_status {
+	unsigned long ESW_MMSR;
+	unsigned long ESW_LMT;
+	unsigned long ESW_LFC;
+	unsigned long ESW_PCSR;
+	unsigned long ESW_IOSR;
+	unsigned long ESW_QWT;
+	unsigned long esw_reserved;
+	unsigned long ESW_P0BCT;
+};
+struct esw_statistics_status {
+	/*
+	 * Total number of incoming frames processed
+	 * but discarded in switch
+	 */
+	unsigned long ESW_DISCN;
+	/*Sum of bytes of frames counted in ESW_DISCN*/
+	unsigned long ESW_DISCB;
+	/*
+	 * Total number of incoming frames processed
+	 * but not discarded in switch
+	 */
+	unsigned long ESW_NDISCN;
+	/*Sum of bytes of frames counted in ESW_NDISCN*/
+	unsigned long ESW_NDISCB;
+};
+
+struct esw_port_statistics_status {
+	/*outgoing frames discarded due to transmit queue congestion*/
+	unsigned long MCF_ESW_POQC;
+	/*incoming frames discarded due to VLAN domain mismatch*/
+	unsigned long MCF_ESW_PMVID;
+	/*incoming frames discarded due to untagged discard*/
+	unsigned long MCF_ESW_PMVTAG;
+	/*incoming frames discarded due port is in blocking state*/
+	unsigned long MCF_ESW_PBL;
+};
+
+struct l2switch_t {
+	unsigned long ESW_REVISION;
+	unsigned long ESW_SCRATCH;
+	unsigned long ESW_PER;
+	unsigned long reserved0[1];
+	unsigned long ESW_VLANV;
+	unsigned long ESW_DBCR;
+	unsigned long ESW_DMCR;
+	unsigned long ESW_BKLR;
+	unsigned long ESW_BMPC;
+	unsigned long ESW_MODE;
+	unsigned long ESW_VIMSEL;
+	unsigned long ESW_VOMSEL;
+	unsigned long ESW_VIMEN;
+	unsigned long ESW_VID;/*0x34*/
+	/*from 0x38 0x3C*/
+	unsigned long esw_reserved0[2];
+	unsigned long ESW_MCR;/*0x40*/
+	unsigned long ESW_EGMAP;
+	unsigned long ESW_INGMAP;
+	unsigned long ESW_INGSAL;
+	unsigned long ESW_INGSAH;
+	unsigned long ESW_INGDAL;
+	unsigned long ESW_INGDAH;
+	unsigned long ESW_ENGSAL;
+	unsigned long ESW_ENGSAH;
+	unsigned long ESW_ENGDAL;
+	unsigned long ESW_ENGDAH;
+	unsigned long ESW_MCVAL;/*0x6C*/
+	/*from 0x70--0x7C*/
+	unsigned long esw_reserved1[4];
+	unsigned long ESW_MMSR;/*0x80*/
+	unsigned long ESW_LMT;
+	unsigned long ESW_LFC;
+	unsigned long ESW_PCSR;
+	unsigned long ESW_IOSR;
+	unsigned long ESW_QWT;/*0x94*/
+	unsigned long esw_reserved2[1];/*0x98*/
+	unsigned long ESW_P0BCT;/*0x9C*/
+	/*from 0xA0-0xB8*/
+	unsigned long esw_reserved3[7];
+	unsigned long ESW_P0FFEN;/*0xBC*/
+	unsigned long ESW_PSNP[8];
+	unsigned long ESW_IPSNP[8];
+	unsigned long ESW_PVRES[3];
+	/*from 0x10C-0x13C*/
+	unsigned long esw_reserved4[13];
+	unsigned long ESW_IPRES;/*0x140*/
+	/*from 0x144-0x17C*/
+	unsigned long esw_reserved5[15];
+	unsigned long ESW_PRES[3];
+	/*from 0x18C-0x1FC*/
+	unsigned long esw_reserved6[29];
+	unsigned long ESW_PID[3];
+	/*from 0x20C-0x27C*/
+	unsigned long esw_reserved7[29];
+	unsigned long ESW_VRES[32];
+	unsigned long ESW_DISCN;/*0x300*/
+	unsigned long ESW_DISCB;
+	unsigned long ESW_NDISCN;
+	unsigned long ESW_NDISCB;/*0xFC0DC30C*/
+	struct esw_port_statistics_status port_statistics_status[3];
+	/*from 0x340-0x400*/
+	unsigned long esw_reserved8[48];
+
+	/*0xFC0DC400---0xFC0DC418*/
+	/*unsigned long MCF_ESW_ISR;*/
+	unsigned long   switch_ievent;             /* Interrupt event reg */
+	/*unsigned long MCF_ESW_IMR;*/
+	unsigned long   switch_imask;              /* Interrupt mask reg */
+	/*unsigned long MCF_ESW_RDSR;*/
+	unsigned long   fec_r_des_start;        /* Receive descriptor ring */
+	/*unsigned long MCF_ESW_TDSR;*/
+	unsigned long   fec_x_des_start;        /* Transmit descriptor ring */
+	/*unsigned long MCF_ESW_MRBR;*/
+	unsigned long   fec_r_buff_size;        /* Maximum receive buff size */
+	/*unsigned long MCF_ESW_RDAR;*/
+	unsigned long   fec_r_des_active;       /* Receive descriptor reg */
+	/*unsigned long MCF_ESW_TDAR;*/
+	unsigned long   fec_x_des_active;       /* Transmit descriptor reg */
+	/*from 0x420-0x4FC*/
+	unsigned long esw_reserved9[57];
+
+	/*0xFC0DC500---0xFC0DC508*/
+	unsigned long ESW_LREC0;
+	unsigned long ESW_LREC1;
+	unsigned long ESW_LSR;
+};
+
+struct  AddrTable64bEntry {
+	unsigned int lo;  /* lower 32 bits */
+	unsigned int hi;  /* upper 32 bits */
+};
+
+struct  eswAddrTable_t {
+	struct AddrTable64bEntry  eswTable64bEntry[2048];
+};
+
+struct mtipl2sw_priv {
+	struct dsa_switch *ds;
+	struct device *dev;
+
+	/* CPU port number */
+	int cpu_port;
+	/* Registers to configure/setup L2 switch IP block */
+	struct l2switch_t *fecp;
+
+	/* Look-up MAC address table start from 0x800FC000 */
+	struct eswAddrTable_t *hwentry;
+};
+
+
+#define MCF_ESW_RDAR_R_DES_ACTIVE BIT(24)
+#define FEC_MIIGSK_EN BIT(2)
+
+/* Bit definitions and macros for MCF_ESW_IMR */
+#define MCF_ESW_IMR_EBERR                      (0x00000001)
+#define MCF_ESW_IMR_RXB                        (0x00000002)
+#define MCF_ESW_IMR_RXF                        (0x00000004)
+#define MCF_ESW_IMR_TXB                        (0x00000008)
+#define MCF_ESW_IMR_TXF                        (0x00000010)
+#define MCF_ESW_IMR_QM                         (0x00000020)
+#define MCF_ESW_IMR_OD0                        (0x00000040)
+#define MCF_ESW_IMR_OD1                        (0x00000080)
+#define MCF_ESW_IMR_OD2                        (0x00000100)
+#define MCF_ESW_IMR_LRN                        (0x00000200)
+
+/* HW_ENET_SWI_PORT_ENA */
+#define MCF_ESW_ENA_TRANSMIT_0 BIT(0)
+#define MCF_ESW_ENA_TRANSMIT_1 BIT(1)
+#define MCF_ESW_ENA_TRANSMIT_2 BIT(2)
+
+#define MCF_ESW_ENA_RECEIVE_0 BIT(16)
+#define MCF_ESW_ENA_RECEIVE_1 BIT(17)
+#define MCF_ESW_ENA_RECEIVE_2 BIT(18)
+
+#define MCF_ESW_ENA_PORT_0 (MCF_ESW_ENA_TRANSMIT_0 | MCF_ESW_ENA_RECEIVE_0)
+#define MCF_ESW_ENA_PORT_1 (MCF_ESW_ENA_TRANSMIT_1 | MCF_ESW_ENA_RECEIVE_1)
+#define MCF_ESW_ENA_PORT_2 (MCF_ESW_ENA_TRANSMIT_2 | MCF_ESW_ENA_RECEIVE_2)
+
+#define MCF_FEC_RCR_DRT	(0x00000002)
+#define MCF_FEC_RCR_PROM       (0x00000008)
+#define MCF_FEC_RCR_FCE	(0x00000020)
+#define MCF_FEC_RCR_RMII_MODE  (0x00000100)
+#define MCF_FEC_RCR_RMII_10BASET  (0x00000200)
+#define MCF_FEC_RCR_MAX_FL(x)  (((x)&0x00003FFF)<<16)
+#define MCF_FEC_RCR_CRC_FWD    (0x00004000)
+#define MCF_FEC_RCR_NO_LGTH_CHECK (0x40000000)
+#define MCF_FEC_TCR_FDEN       (0x00000004)
+
+#define MCF_FEC_ECR_RESET      (0x00000001)
+#define MCF_FEC_ECR_ETHER_EN   (0x00000002)
+#define MCF_FEC_ECR_MAGIC_ENA  (0x00000004)
+#define MCF_FEC_ECR_ENA_1588   (0x00000010)
+
+/* L2 switch Maximum receive buff size */
+#define MCF_ESW_R_BUFF_SIZE	0x14
+/* L2 switch Receive Descriptor Active Register */
+#define MCF_ESW_R_RDAR          0x18
+
+/*
+ * MCF_FEC_EMRBR corresponds to FEC_R_BUFF_SIZE_0 in fec main driver.
+ * It is duplicated as for L2 switch FEC_R_BUFF_SIZE_0 is aliased
+ * to different offset in switch IC. Hence the need to introduce new
+ * #define.
+ */
+#define MCF_FEC_EMRBR          (0x188)
+
+#define MCF_FEC_ERDSR(x)       ((x) << 2)
+
+#define MCF_ECR_ETHER_EN 1
+#define FEC_ECNTRL_ETHER_EN BIT(1)
+/*
+ * The Switch stores dest/src/type, data, and checksum for receive packets.
+ */
+#define L2SW_PKT_MAXBUF_SIZE         1518
+#define L2SW_PKT_MINBUF_SIZE         64
+#define L2SW_PKT_MAXBLR_SIZE         1520
+
+#endif /* __MTIP_L2SWITCH_H_ */
-- 
2.20.1

