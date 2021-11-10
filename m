Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A51C44BB4B
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhKJFj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:39:28 -0500
Received: from inva020.nxp.com ([92.121.34.13]:49566 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhKJFj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:39:27 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 552451A0B2E;
        Wed, 10 Nov 2021 06:36:39 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E69951A09AA;
        Wed, 10 Nov 2021 06:36:38 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id A4EDD183ACCB;
        Wed, 10 Nov 2021 13:36:37 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 1/3] fec_phy: add new PHY file
Date:   Wed, 10 Nov 2021 11:06:15 +0530
Message-Id: <20211110053617.13497-2-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110053617.13497-1-apeksha.gupta@nxp.com>
References: <20211110053617.13497-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added common file for both fec and fec_uio driver.
fec_phy.h and fec_phy.c have phy related API's.
Now the PHY functions can be used in both FEC and
FEC_UIO driver independently.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 drivers/net/ethernet/freescale/Makefile  |   4 +-
 drivers/net/ethernet/freescale/fec_phy.c | 495 +++++++++++++++++++++++
 drivers/net/ethernet/freescale/fec_phy.h |  33 ++
 3 files changed, 531 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_phy.c
 create mode 100644 drivers/net/ethernet/freescale/fec_phy.h

diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index de7b31842233..61d417694e0e 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -3,8 +3,10 @@
 # Makefile for the Freescale network device drivers.
 #
 
+common-objs := fec_phy.o
+
 obj-$(CONFIG_FEC) += fec.o
-fec-objs :=fec_main.o fec_ptp.o
+fec-objs :=fec_main.o fec_ptp.o $(common-objs)
 
 obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
 ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
diff --git a/drivers/net/ethernet/freescale/fec_phy.c b/drivers/net/ethernet/freescale/fec_phy.c
new file mode 100644
index 000000000000..94513a6b962e
--- /dev/null
+++ b/drivers/net/ethernet/freescale/fec_phy.c
@@ -0,0 +1,495 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 1997 Dan Malek (dmalek@jlc.net)
+ * Copyright 2000 Ericsson Radio Systems AB.
+ * Copyright 2001-2005 Greg Ungerer (gerg@snapgear.com)
+ * Copyright 2004-2006 Macq Electronique SA.
+ * Copyright 2010-2011 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
+ */
+
+#include <linux/pm_runtime.h>
+#include <linux/netdevice.h>
+#include <linux/clk.h>
+#include <linux/mdio.h>
+#include <linux/phy.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+
+#include "fec.h"
+#include "fec_phy.h"
+
+static int mii_cnt;
+
+void fec_enet_adjust_link(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct phy_device *phy_dev = ndev->phydev;
+	int status_change = 0;
+
+	/* If the netdev is down, or is going down, we're not interested
+	 * in link state events, so just mark our idea of the link as down
+	 * and ignore the event.
+	 */
+	if (!netif_running(ndev) || !netif_device_present(ndev)) {
+		fep->link = 0;
+	} else if (phy_dev->link) {
+		if (!fep->link) {
+			fep->link = phy_dev->link;
+			status_change = 1;
+		}
+
+		if (fep->full_duplex != phy_dev->duplex) {
+			fep->full_duplex = phy_dev->duplex;
+			status_change = 1;
+		}
+
+		if (phy_dev->speed != fep->speed) {
+			fep->speed = phy_dev->speed;
+			status_change = 1;
+		}
+
+		/* if any of the above changed restart the FEC */
+		if (status_change) {
+			napi_disable(&fep->napi);
+			netif_tx_lock_bh(ndev);
+			fec_restart(ndev);
+			netif_tx_wake_all_queues(ndev);
+			netif_tx_unlock_bh(ndev);
+			napi_enable(&fep->napi);
+		}
+	} else {
+		if (fep->link) {
+			napi_disable(&fep->napi);
+			netif_tx_lock_bh(ndev);
+			fec_stop(ndev);
+			netif_tx_unlock_bh(ndev);
+			napi_enable(&fep->napi);
+			fep->link = phy_dev->link;
+			status_change = 1;
+		}
+	}
+
+	if (status_change)
+		phy_print_status(phy_dev);
+}
+
+int fec_enet_mdio_wait(struct fec_enet_private *fep)
+{
+	uint ievent;
+	int ret;
+
+	ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
+					ievent & FEC_ENET_MII, 2, 30000);
+
+	if (!ret)
+		writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
+	return ret;
+}
+
+int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+{
+	struct fec_enet_private *fep = bus->priv;
+	struct device *dev = &fep->pdev->dev;
+	int ret = 0, frame_start, frame_addr, frame_op;
+	bool is_c45 = !!(regnum & MII_ADDR_C45);
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
+	if (is_c45) {
+		frame_start = FEC_MMFR_ST_C45;
+
+		/* write address */
+		frame_addr = (regnum >> 16);
+		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
+		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		       FEC_MMFR_TA | (regnum & 0xFFFF),
+		       fep->hwp + FEC_MII_DATA);
+
+		/* wait for end of transfer */
+		ret = fec_enet_mdio_wait(fep);
+		if (ret) {
+			netdev_err(fep->netdev, "MDIO address write timeout\n");
+			goto out;
+		}
+
+		frame_op = FEC_MMFR_OP_READ_C45;
+
+	} else {
+		/* C22 read */
+		frame_op = FEC_MMFR_OP_READ;
+		frame_start = FEC_MMFR_ST;
+		frame_addr = regnum;
+	}
+
+	/* start a read op */
+	writel(frame_start | frame_op |
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
+
+	/* wait for end of transfer */
+	ret = fec_enet_mdio_wait(fep);
+	if (ret) {
+		netdev_err(fep->netdev, "MDIO read timeout\n");
+		goto out;
+	}
+
+	ret = FEC_MMFR_DATA(readl(fep->hwp + FEC_MII_DATA));
+
+out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
+}
+
+int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
+			u16 value)
+{
+	struct fec_enet_private *fep = bus->priv;
+	struct device *dev = &fep->pdev->dev;
+	int ret, frame_start, frame_addr;
+	bool is_c45 = !!(regnum & MII_ADDR_C45);
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
+	if (is_c45) {
+		frame_start = FEC_MMFR_ST_C45;
+
+		/* write address */
+		frame_addr = (regnum >> 16);
+		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
+		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		       FEC_MMFR_TA | (regnum & 0xFFFF),
+		       fep->hwp + FEC_MII_DATA);
+
+		/* wait for end of transfer */
+		ret = fec_enet_mdio_wait(fep);
+		if (ret) {
+			netdev_err(fep->netdev, "MDIO address write timeout\n");
+			goto out;
+		}
+	} else {
+		/* C22 write */
+		frame_start = FEC_MMFR_ST;
+		frame_addr = regnum;
+	}
+
+	/* start a write op */
+	writel(frame_start | FEC_MMFR_OP_WRITE |
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		FEC_MMFR_TA | FEC_MMFR_DATA(value),
+		fep->hwp + FEC_MII_DATA);
+
+	/* wait for end of transfer */
+	ret = fec_enet_mdio_wait(fep);
+	if (ret)
+		netdev_err(fep->netdev, "MDIO write timeout\n");
+
+out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
+}
+
+void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct phy_device *phy_dev = ndev->phydev;
+
+	if (phy_dev) {
+		phy_reset_after_clk_enable(phy_dev);
+	} else if (fep->phy_node) {
+		/* If the PHY still is not bound to the MAC, but there is
+		 * OF PHY node and a matching PHY device instance already,
+		 * use the OF PHY node to obtain the PHY device instance,
+		 * and then use that PHY device instance when triggering
+		 * the PHY reset.
+		 */
+		phy_dev = of_phy_find_device(fep->phy_node);
+		phy_reset_after_clk_enable(phy_dev);
+		put_device(&phy_dev->mdio.dev);
+	}
+}
+
+int fec_enet_mii_probe(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct phy_device *phy_dev = NULL;
+	char mdio_bus_id[MII_BUS_ID_SIZE];
+	char phy_name[MII_BUS_ID_SIZE + 3];
+	int phy_id;
+	int dev_id = fep->dev_id;
+
+	if (fep->phy_node) {
+		phy_dev = of_phy_connect(ndev, fep->phy_node,
+					 &fec_enet_adjust_link, 0,
+					 fep->phy_interface);
+		if (!phy_dev) {
+			netdev_err(ndev, "Unable to connect to phy\n");
+			return -ENODEV;
+		}
+	} else {
+		/* check for attached phy */
+		for (phy_id = 0; (phy_id < PHY_MAX_ADDR); phy_id++) {
+			if (!mdiobus_is_registered_device(fep->mii_bus, phy_id))
+				continue;
+			if (dev_id--)
+				continue;
+			strscpy(mdio_bus_id, fep->mii_bus->id, MII_BUS_ID_SIZE);
+			break;
+		}
+
+		if (phy_id >= PHY_MAX_ADDR) {
+			netdev_info(ndev, "no PHY, assuming direct connection to switch\n");
+			strscpy(mdio_bus_id, "fixed-0", MII_BUS_ID_SIZE);
+			phy_id = 0;
+		}
+
+		snprintf(phy_name, sizeof(phy_name),
+			 PHY_ID_FMT, mdio_bus_id, phy_id);
+		phy_dev = phy_connect(ndev, phy_name, &fec_enet_adjust_link,
+				      fep->phy_interface);
+	}
+
+	if (IS_ERR(phy_dev)) {
+		netdev_err(ndev, "could not attach to PHY\n");
+		return PTR_ERR(phy_dev);
+	}
+
+	/* mask with MAC supported features */
+	if (fep->quirks & FEC_QUIRK_HAS_GBIT) {
+		phy_set_max_speed(phy_dev, 1000);
+		phy_remove_link_mode(phy_dev,
+				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+#if !defined(CONFIG_M5272)
+		phy_support_sym_pause(phy_dev);
+#endif
+	} else {
+		phy_set_max_speed(phy_dev, 100);
+	}
+	fep->link = 0;
+	fep->full_duplex = 0;
+
+	phy_dev->mac_managed_pm = 1;
+
+	phy_attached_info(phy_dev);
+
+	return 0;
+}
+
+int fec_enet_mii_init(struct platform_device *pdev)
+{
+	static struct mii_bus *fec0_mii_bus;
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	bool suppress_preamble = false;
+	struct device_node *node;
+	int err = -ENXIO;
+	u32 mii_speed, holdtime;
+	u32 bus_freq;
+
+	/* The i.MX28 dual fec interfaces are not equal.
+	 * Here are the differences:
+	 *
+	 *  - fec0 supports MII & RMII modes while fec1 only supports RMII
+	 *  - fec0 acts as the 1588 time master while fec1 is slave
+	 *  - external phys can only be configured by fec0
+	 *
+	 * That is to say fec1 can not work independently. It only works
+	 * when fec0 is working. The reason behind this design is that the
+	 * second interface is added primarily for Switch mode.
+	 *
+	 * Because of the last point above, both phys are attached on fec0
+	 * mdio interface in board design, and need to be configured by
+	 * fec0 mii_bus.
+	 */
+	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
+		/* fec1 uses fec0 mii_bus */
+		if (mii_cnt && fec0_mii_bus) {
+			fep->mii_bus = fec0_mii_bus;
+			mii_cnt++;
+			return 0;
+		}
+		return -ENOENT;
+	}
+
+	bus_freq = 2500000; /* 2.5MHz by default */
+	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+	if (node) {
+		of_property_read_u32(node, "clock-frequency", &bus_freq);
+		suppress_preamble = of_property_read_bool(node,
+							  "suppress-preamble");
+	}
+
+	/* Set MII speed (= clk_get_rate() / 2 * phy_speed)
+	 *
+	 * The formula for FEC MDC is 'ref_freq / (MII_SPEED x 2)' while
+	 * for ENET-MAC is 'ref_freq / ((MII_SPEED + 1) x 2)'.  The i.MX28
+	 * Reference Manual has an error on this, and gets fixed on i.MX6Q
+	 * document.
+	 */
+	mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), bus_freq * 2);
+	if (fep->quirks & FEC_QUIRK_ENET_MAC)
+		mii_speed--;
+	if (mii_speed > 63) {
+		dev_err(&pdev->dev,
+			"fec clock (%lu) too fast to get right mii speed\n",
+			clk_get_rate(fep->clk_ipg));
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	/* The i.MX28 and i.MX6 types have another filed in the MSCR (aka
+	 * MII_SPEED) register that defines the MDIO output hold time. Earlier
+	 * versions are RAZ there, so just ignore the difference and write the
+	 * register always.
+	 * The minimal hold time according to IEE802.3 (clause 22) is 10 ns.
+	 * HOLDTIME + 1 is the number of clk cycles the fec is holding the
+	 * output.
+	 * The HOLDTIME bitfield takes values between 0 and 7 (inclusive).
+	 * Given that ceil(clkrate / 5000000) <= 64, the calculation for
+	 * holdtime cannot result in a value greater than 3.
+	 */
+	holdtime = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 100000000) - 1;
+
+	fep->phy_speed = mii_speed << 1 | holdtime << 8;
+
+	if (suppress_preamble)
+		fep->phy_speed |= BIT(7);
+
+	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
+		/* Clear MMFR to avoid to generate MII event by writing MSCR.
+		 * MII event generation condition:
+		 * - writing MSCR:
+		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
+		 *	  mscr_reg_data_in[7:0] != 0
+		 * - writing MMFR:
+		 *	- mscr[7:0]_not_zero
+		 */
+		writel(0, fep->hwp + FEC_MII_DATA);
+	}
+
+	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
+
+	/* Clear any pending transaction complete indication */
+	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
+
+	fep->mii_bus = mdiobus_alloc();
+	if (!fep->mii_bus) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	fep->mii_bus->name = "fec_enet_mii_bus";
+	fep->mii_bus->read = fec_enet_mdio_read;
+	fep->mii_bus->write = fec_enet_mdio_write;
+	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		 pdev->name, fep->dev_id + 1);
+	fep->mii_bus->priv = fep;
+	fep->mii_bus->parent = &pdev->dev;
+
+	err = of_mdiobus_register(fep->mii_bus, node);
+	if (err)
+		goto err_out_free_mdiobus;
+	of_node_put(node);
+
+	mii_cnt++;
+
+	/* save fec0 mii_bus */
+	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO)
+		fec0_mii_bus = fep->mii_bus;
+
+	return 0;
+
+err_out_free_mdiobus:
+	mdiobus_free(fep->mii_bus);
+err_out:
+	of_node_put(node);
+	return err;
+}
+
+void fec_enet_mii_remove(struct fec_enet_private *fep)
+{
+	if (--mii_cnt == 0) {
+		mdiobus_unregister(fep->mii_bus);
+		mdiobus_free(fep->mii_bus);
+	}
+}
+
+#ifdef CONFIG_OF
+int fec_reset_phy(struct platform_device *pdev)
+{
+	int err, phy_reset;
+	bool active_high = false;
+	int msec = 1, phy_post_delay = 0;
+	struct device_node *np = pdev->dev.of_node;
+
+	if (!np)
+		return 0;
+
+	err = of_property_read_u32(np, "phy-reset-duration", &msec);
+	/* A sane reset duration should not be longer than 1s */
+	if (!err && msec > 1000)
+		msec = 1;
+
+	phy_reset = of_get_named_gpio(np, "phy-reset-gpios", 0);
+	if (phy_reset == -EPROBE_DEFER)
+		return phy_reset;
+	else if (!gpio_is_valid(phy_reset))
+		return 0;
+
+	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
+	/* valid reset duration should be less than 1s */
+	if (!err && phy_post_delay > 1000)
+		return -EINVAL;
+
+	active_high = of_property_read_bool(np, "phy-reset-active-high");
+
+	err = devm_gpio_request_one(&pdev->dev, phy_reset,
+				    active_high ? GPIOF_OUT_INIT_HIGH :
+				    GPIOF_OUT_INIT_LOW,	"phy-reset");
+	if (err) {
+		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", err);
+		return err;
+	}
+
+	if (msec > 20)
+		msleep(msec);
+	else
+		usleep_range(msec * 1000, msec * 1000 + 1000);
+
+	gpio_set_value_cansleep(phy_reset, !active_high);
+
+	if (!phy_post_delay)
+		return 0;
+
+	if (phy_post_delay > 20)
+		msleep(phy_post_delay);
+	else
+		usleep_range(phy_post_delay * 1000,
+			     phy_post_delay * 1000 + 1000);
+
+	return 0;
+}
+#else /* CONFIG_OF */
+int fec_reset_phy(struct platform_device *pdev)
+{
+	/* In case of platform probe, the reset has been done
+	 * by machine code.
+	 */
+	return 0;
+}
+#endif /* CONFIG_OF */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("NXP");
+MODULE_DESCRIPTION("i.MX FEC PHY");
diff --git a/drivers/net/ethernet/freescale/fec_phy.h b/drivers/net/ethernet/freescale/fec_phy.h
new file mode 100644
index 000000000000..b7b21b22201b
--- /dev/null
+++ b/drivers/net/ethernet/freescale/fec_phy.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/* Copyright 1997 Dan Malek (dmalek@jlc.net)
+ * Copyright 2000 Ericsson Radio Systems AB.
+ * Copyright 2001-2005 Greg Ungerer (gerg@snapgear.com)
+ * Copyright 2004-2006 Macq Electronique SA.
+ * Copyright 2010-2011 Freescale Semiconductor, Inc.
+ * Copyright 2021 NXP
+ */
+
+/* FEC MII MMFR bits definition */
+#define FEC_MMFR_ST             BIT(30)
+#define FEC_MMFR_ST_C45         (0)
+#define FEC_MMFR_OP_READ        (2 << 28)
+#define FEC_MMFR_OP_READ_C45    (3 << 28)
+#define FEC_MMFR_OP_WRITE       BIT(28)
+#define FEC_MMFR_OP_ADDR_WRITE  (0)
+#define FEC_MMFR_PA(v)          (((v) & 0x1f) << 23)
+#define FEC_MMFR_RA(v)          (((v) & 0x1f) << 18)
+#define FEC_MMFR_TA             (2 << 16)
+#define FEC_MMFR_DATA(v)        ((v) & 0xffff)
+
+#define FEC_MDIO_PM_TIMEOUT	100 /* ms */
+
+void fec_enet_adjust_link(struct net_device *ndev);
+int fec_enet_mdio_wait(struct fec_enet_private *fep);
+int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum);
+int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum, u16 value);
+void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev);
+int fec_enet_mii_probe(struct net_device *ndev);
+int fec_enet_mii_init(struct platform_device *pdev);
+void fec_enet_mii_remove(struct fec_enet_private *fep);
+int fec_reset_phy(struct platform_device *pdev);
-- 
2.17.1

