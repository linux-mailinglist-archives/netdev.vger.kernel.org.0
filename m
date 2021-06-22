Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D1B3B07A2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhFVOn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbhFVOnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:43:52 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9639CC06175F
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:41:36 -0700 (PDT)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 7E41B82A13;
        Tue, 22 Jun 2021 16:41:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624372894;
        bh=hLQa4xeLXjVcE4A1UCU3uy7RZq155CdCD7VyfSf9IcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONsblKa5EIkgL9eJ1/kltbqUApgeiukoV6UR8Xr5K8/9gKPqKjcbzuA4YR3OVn6Fw
         pyNO4zTjhfNPVgEJUiEJbarq1Rcm4eYrcQ765oj24p8pY954jIKTf1CMNESmegA3MM
         rrMA6qfxB3n+1ikf14ctncQzSFTa1mMm/zm1p/OE14ZM+Odr4kchQQ8eplRUOFQ3xE
         19iSe2izkOpOE+nH1RPNpXI+lL3swr0gi1kOiJkt0VpOoHd6so/6jzlWZ2c6i3CxOi
         UITH/EPkpU8Uf8T+fK4TkB0jqRLTQNbVJdrpCf31ZFrGHL6n2zslASdKNPNQoc4Q88
         RdeTszg5lOKJg==
From:   Lukasz Majewski <lukma@denx.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org, Lukasz Majewski <lukma@denx.de>
Subject: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP L2 switch
Date:   Tue, 22 Jun 2021 16:41:10 +0200
Message-Id: <20210622144111.19647-3-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210622144111.19647-1-lukma@denx.de>
References: <20210622144111.19647-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change provides driver for More Than IP L2 switch IP block to hook
into switchdev subsystem to provide bridging offloading for i.MX28
SoC (imx287 to be precise).

This code is responsible for configuring this device as L2 bridge when
one decides to bridge eth[01] interfaces (so no vlan, filtering table
aging supported).

This driver shall be regarded as a complementary one for NXP's FEC
(fec_main.c). It reuses some code from it.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/ethernet/freescale/Kconfig        |   1 +
 drivers/net/ethernet/freescale/Makefile       |   1 +
 drivers/net/ethernet/freescale/mtipsw/Kconfig |  11 +
 .../net/ethernet/freescale/mtipsw/Makefile    |   3 +
 .../net/ethernet/freescale/mtipsw/fec_mtip.c  | 438 ++++++++++++++++++
 .../net/ethernet/freescale/mtipsw/fec_mtip.h  | 213 +++++++++
 6 files changed, 667 insertions(+)
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/Kconfig
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/Makefile
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/fec_mtip.c
 create mode 100644 drivers/net/ethernet/freescale/mtipsw/fec_mtip.h

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 3f9175bdce77..3cf703aa2a00 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -102,5 +102,6 @@ config GIANFAR
 source "drivers/net/ethernet/freescale/dpaa/Kconfig"
 source "drivers/net/ethernet/freescale/dpaa2/Kconfig"
 source "drivers/net/ethernet/freescale/enetc/Kconfig"
+source "drivers/net/ethernet/freescale/mtipsw/Kconfig"
 
 endif # NET_VENDOR_FREESCALE
diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index 67c436400352..12ed0c13f739 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_FSL_DPAA2_ETH) += dpaa2/
 obj-$(CONFIG_FSL_ENETC) += enetc/
 obj-$(CONFIG_FSL_ENETC_MDIO) += enetc/
 obj-$(CONFIG_FSL_ENETC_VF) += enetc/
+obj-$(CONFIG_FEC_MTIP_L2SW) += mtipsw/
diff --git a/drivers/net/ethernet/freescale/mtipsw/Kconfig b/drivers/net/ethernet/freescale/mtipsw/Kconfig
new file mode 100644
index 000000000000..e7f40dcad0d0
--- /dev/null
+++ b/drivers/net/ethernet/freescale/mtipsw/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config FEC_MTIP_L2SW
+	tristate "MoreThanIP L2 switch support to FEC driver"
+	depends on OF
+	depends on NET_SWITCHDEV
+	depends on BRIDGE
+	depends on ARCH_MXS
+	select FIXED_PHY
+	help
+	  This enables support for the MoreThan IP on i.MX SoCs (e.g. iMX28)
+	  L2 switch.
diff --git a/drivers/net/ethernet/freescale/mtipsw/Makefile b/drivers/net/ethernet/freescale/mtipsw/Makefile
new file mode 100644
index 000000000000..1aac85f92750
--- /dev/null
+++ b/drivers/net/ethernet/freescale/mtipsw/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_FEC_MTIP_L2SW) += fec_mtip.o
diff --git a/drivers/net/ethernet/freescale/mtipsw/fec_mtip.c b/drivers/net/ethernet/freescale/mtipsw/fec_mtip.c
new file mode 100644
index 000000000000..fe4e3fb34295
--- /dev/null
+++ b/drivers/net/ethernet/freescale/mtipsw/fec_mtip.c
@@ -0,0 +1,438 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Lukasz Majewski <lukma@denx.de>
+ * Lukasz Majewski <lukma@denx.de>
+ */
+
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+#include <linux/of_net.h>
+#include <linux/of_platform.h>
+#include <linux/if_bridge.h>
+#include <linux/mdio.h>
+#include <linux/of_mdio.h>
+#include <linux/etherdevice.h>
+
+#include "fec_mtip.h"
+#include "../fec.h"
+
+static void mtipl2_setup_desc_active(struct mtipl2sw_priv *priv, int id)
+{
+	struct fec_enet_private *fec = priv->fep[id];
+
+	fec->rx_queue[0]->bd.reg_desc_active =
+		fec_hwp(fec) + fec_offset_des_active_rxq(fec, 0);
+
+	fec->tx_queue[0]->bd.reg_desc_active =
+		fec_hwp(fec) + fec_offset_des_active_txq(fec, 0);
+}
+
+static int mtipl2_en_rx(struct mtipl2sw_priv *priv)
+{
+	writel(MCF_ESW_RDAR_R_DES_ACTIVE, priv->hwpsw + MCF_ESW_R_RDAR);
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
+static int mtipl2_sw_enable(struct mtipl2sw_priv *priv)
+{
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
+	/* Management port configuration, make port 0 as management port */
+	writel(0, &priv->fecp->ESW_BMPC);
+
+	/*
+	 * Set backpressure threshold to minimize discarded frames
+	 * during due to congestion.
+	 */
+	writel(P0BC_THRESHOLD, &priv->fecp->ESW_P0BCT);
+
+	/* Set the max rx buffer size */
+	writel(L2SW_PKT_MAXBLR_SIZE, priv->hwpsw + MCF_ESW_R_BUFF_SIZE);
+	/* Enable broadcast on all ports */
+	writel(0x7, &priv->fecp->ESW_DBCR);
+
+	/* Enable multicast on all ports */
+	writel(0x7, &priv->fecp->ESW_DMCR);
+
+	esw_clear_atable(priv);
+
+	/* Clear all pending interrupts */
+	writel(0xffffffff, priv->hwpsw + FEC_IEVENT);
+
+	/* Enable interrupts we wish to service */
+	writel(FEC_MTIP_DEFAULT_IMASK, priv->hwpsw + FEC_IMASK);
+	priv->l2sw_on = true;
+
+	return 0;
+}
+
+static void mtipl2_sw_disable(struct mtipl2sw_priv *priv)
+{
+	writel(0, &priv->fecp->ESW_MODE);
+}
+
+static int mtipl2_port_enable (struct mtipl2sw_priv *priv, int port)
+{
+	u32 l2_ports_en;
+
+	pr_err("%s: PORT ENABLE %d\n", __func__, port);
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
+static void mtipl2_port_disable (struct mtipl2sw_priv *priv, int port)
+{
+	u32 l2_ports_en;
+
+	pr_err(" %s: PORT DISABLE %d\n", __func__, port);
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
+irqreturn_t
+mtip_l2sw_interrupt_handler(int irq, void *dev_id)
+{
+	struct mtipl2sw_priv *priv = dev_id;
+	struct fec_enet_private *fep = priv->fep[0];
+	irqreturn_t ret = IRQ_NONE;
+	u32 int_events, int_imask;
+
+	int_events = readl(fec_hwp(fep) + FEC_IEVENT);
+	writel(int_events, fec_hwp(fep) + FEC_IEVENT);
+
+	if ((int_events & FEC_MTIP_DEFAULT_IMASK) && fep->link) {
+		ret = IRQ_HANDLED;
+
+		if (napi_schedule_prep(&fep->napi)) {
+			/* Disable RX interrupts */
+			int_imask = readl(fec_hwp(fep) + FEC_IMASK);
+			int_imask &= ~FEC_MTIP_ENET_RXF;
+			writel(int_imask, fec_hwp(fep) + FEC_IMASK);
+			__napi_schedule(&fep->napi);
+		}
+	}
+
+	return ret;
+}
+
+static int mtipl2_parse_of(struct mtipl2sw_priv *priv, struct device_node *np)
+{
+	struct device_node *port, *p, *fep_np;
+	struct platform_device *pdev;
+	struct net_device *ndev;
+	unsigned int port_num;
+
+	p = of_find_node_by_name(np, "ports");
+
+	for_each_available_child_of_node(p, port) {
+		if (of_property_read_u32(port, "reg", &port_num))
+			continue;
+
+		priv->n_ports = port_num;
+
+		fep_np = of_parse_phandle(port, "phy-handle", 0);
+		pdev = of_find_device_by_node(fep_np);
+		ndev = platform_get_drvdata(pdev);
+		priv->fep[port_num - 1] = netdev_priv(ndev);
+		put_device(&pdev->dev);
+	}
+
+	of_node_put(p);
+
+	return 0;
+}
+
+int mtipl2_ndev_port_link(struct net_device *ndev,
+				 struct net_device *br_ndev)
+{
+	struct fec_enet_private *fec = netdev_priv(ndev);
+	struct mtipl2sw_priv *priv = fec->mtipl2;
+
+	pr_err("%s: ndev: %s br: %s fec: 0x%x 0x%x\n", __func__, ndev->name,
+	       br_ndev->name, (unsigned int) fec, fec->dev_id);
+
+	/* Check if MTIP switch is already enabled */
+	if(!priv->l2sw_on) {
+		/*
+		 * Close running network connections - to safely enable
+		 * support for mtip L2 switching.
+		 */
+		if (netif_oper_up(priv->fep[0]->netdev))
+			fec_enet_close(priv->fep[0]->netdev);
+
+		if (netif_oper_up(priv->fep[1]->netdev))
+			fec_enet_close(priv->fep[1]->netdev);
+
+		/* Configure and enable the L2 switch IP block */
+		mtipl2_sw_enable(priv);
+
+		if(!priv->br_ndev)
+			priv->br_ndev = br_ndev;
+	}
+
+	priv->br_members |= BIT(fec->dev_id);
+
+	/* Enable internal switch port */
+	mtipl2_port_enable(fec->mtipl2, fec->dev_id);
+
+	if (fec->dev_id == 1)
+		return NOTIFY_DONE;
+
+	/*
+	 * Set addresses for DMA0 proper operation to point to L2 switch
+	 * IP block.
+	 *
+	 * The eth1 FEC driver is now only used for controlling the PHY device.
+	 */
+	fec->mtip_l2sw = true;
+
+	mtipl2_setup_desc_active(priv, fec->dev_id);
+	fec_enet_open(priv->fep[fec->dev_id]->netdev);
+
+	mtipl2_en_rx(fec->mtipl2);
+
+	return NOTIFY_DONE;
+}
+
+static void mtipl2_netdevice_port_unlink(struct net_device *ndev)
+{
+	struct fec_enet_private *fec = netdev_priv(ndev);
+	struct mtipl2sw_priv *priv = fec->mtipl2;
+
+	pr_err("%s: ndev: %s id: %d\n", __func__, ndev->name, fec->dev_id);
+
+	/* Disable internal switch port */
+	mtipl2_port_disable(fec->mtipl2, fec->dev_id);
+
+	if (netif_oper_up(priv->fep[fec->dev_id]->netdev))
+		fec_enet_close(priv->fep[fec->dev_id]->netdev);
+
+	priv->br_members &= ~BIT(fec->dev_id);
+
+	fec->mtip_l2sw = false;
+	priv->br_ndev = NULL;
+
+	mtipl2_setup_desc_active(priv, fec->dev_id);
+	fec_enet_open(priv->fep[fec->dev_id]->netdev);
+
+	if (!priv->br_members) {
+		mtipl2_sw_disable(priv);
+		priv->l2sw_on = false;
+	}
+}
+
+bool mtipl2_port_dev_check(const struct net_device *ndev)
+{
+	if(!fec_get_priv(ndev))
+		return false;
+
+	return true;
+}
+
+/* netdev notifier */
+static int mtipl2_netdevice_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info;
+	int ret = NOTIFY_DONE;
+
+	if (!mtipl2_port_dev_check(ndev))
+		return NOTIFY_DONE;
+
+	pr_err("%s: ndev: %s event: 0x%lx\n", __func__, ndev->name, event);
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		info = ptr;
+
+		if (netif_is_bridge_master(info->upper_dev)) {
+			if (info->linking)
+				ret = mtipl2_ndev_port_link(ndev,
+							    info->upper_dev);
+			else
+				mtipl2_netdevice_port_unlink(ndev);
+		}
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block mtipl2_netdevice_nb __read_mostly = {
+	.notifier_call = mtipl2_netdevice_event,
+};
+
+static int mtipl2_register_notifiers(struct mtipl2sw_priv *priv)
+{
+	int ret = 0;
+
+	ret = register_netdevice_notifier(&mtipl2_netdevice_nb);
+	if (ret) {
+		dev_err(priv->dev, "can't register netdevice notifier\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void mtipl2_unregister_notifiers(struct mtipl2sw_priv *priv)
+{
+	unregister_netdevice_notifier(&mtipl2_netdevice_nb);
+}
+
+static int mtipl2_sw_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct mtipl2sw_priv *priv;
+	struct resource *r;
+	int ret;
+
+	pr_err("fec: %s\n", __func__);
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	mtipl2_parse_of(priv, np);
+
+	/* Wait till eth[01] interfaces are up and running */
+	if (!priv->fep[0] || !priv->fep[1] ||
+	    !netif_device_present(priv->fep[0]->netdev) ||
+	    !netif_device_present(priv->fep[1]->netdev))
+		return -EPROBE_DEFER;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->fecp = devm_ioremap_resource(&pdev->dev, r);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	priv->hwentry = devm_ioremap_resource(&pdev->dev, r);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	priv->hwpsw = devm_ioremap_resource(&pdev->dev, r);
+
+	/*
+	 * MAC{01} interrupt and descriptors registers have 4 bytes
+	 * offset when compared to L2 switch IP block.
+	 *
+	 * When L2 switch is added "between" ENET (eth0) and MAC{01}
+	 * the code for interrupts and setting up descriptors is
+	 * reused.
+	 *
+	 * As for example FEC_IMASK are used also on MAC{01} to
+	 * perform MII transmission it is better to subtract the
+	 * offset from the outset and reuse defines.
+	 */
+	priv->hwpsw -= L2SW_CTRL_REG_OFFSET;
+
+	priv->fep[0]->hwpsw = priv->hwpsw;
+	priv->fep[1]->hwpsw = priv->hwpsw;
+
+	priv->fep[0]->mtipl2 = priv;
+	priv->fep[1]->mtipl2 = priv;
+
+	ret = devm_request_irq(&pdev->dev, platform_get_irq(pdev, 0),
+			       mtip_l2sw_interrupt_handler,
+			       0, "mtip_l2sw", priv);
+
+	ret = mtipl2_register_notifiers(priv);
+	if (ret)
+		goto clean_unregister_netdev;
+
+	return 0;
+
+ clean_unregister_netdev:
+	mtipl2_unregister_notifiers(priv);
+
+	return ret;
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
diff --git a/drivers/net/ethernet/freescale/mtipsw/fec_mtip.h b/drivers/net/ethernet/freescale/mtipsw/fec_mtip.h
new file mode 100644
index 000000000000..6f989cde0093
--- /dev/null
+++ b/drivers/net/ethernet/freescale/mtipsw/fec_mtip.h
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 DENX Software Engineering GmbH
+ * Lukasz Majewski <lukma@denx.de>
+ */
+
+#ifndef __MTIP_L2SWITCH_H_
+#define __MTIP_L2SWITCH_H_
+
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
+	struct fec_enet_private *fep[2];
+	void __iomem *hwpsw;
+	struct device *dev;
+	struct net_device *br_ndev;
+
+	/*
+	 * Flag to indicate if L2 switch IP block is initialized and
+	 * running.
+	 */
+	bool l2sw_on;
+
+	/* Number of ports */
+	int n_ports;
+
+	/* Bit field with active members */
+	u8 br_members;
+
+	/* Registers to configure/setup L2 switch IP block */
+	struct l2switch_t *fecp;
+
+	/* Look-up MAC address table start from 0x800FC000 */
+	struct eswAddrTable_t *hwentry;
+};
+
+#define MCF_ESW_RDAR_R_DES_ACTIVE BIT(24)
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
+#define L2SW_PKT_MAXBLR_SIZE         1520
+
+#define L2SW_CTRL_REG_OFFSET         0x4
+
+#endif /* __MTIP_L2SWITCH_H_ */
-- 
2.20.1

