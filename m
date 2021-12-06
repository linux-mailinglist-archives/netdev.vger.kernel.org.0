Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0006468FE7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 05:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhLFE7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 23:59:40 -0500
Received: from inva020.nxp.com ([92.121.34.13]:50070 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhLFE7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 23:59:37 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F1C041A056F;
        Mon,  6 Dec 2021 05:56:07 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8DA6D1A1272;
        Mon,  6 Dec 2021 05:56:07 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 6F9AA183ACDD;
        Mon,  6 Dec 2021 12:56:06 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        arnd@arndb.de
Cc:     linux-kernel@vger.kernel.org, linux-devel@linux.nxdi.nxp.com,
        LnxRevLi@nxp.com, sachin.saxena@nxp.com, hemant.agrawal@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH v2 2/3] fec_main: removed PHY functions
Date:   Mon,  6 Dec 2021 10:25:35 +0530
Message-Id: <20211206045536.8690-3-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211206045536.8690-1-apeksha.gupta@nxp.com>
References: <20211206045536.8690-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moved the PHY related API's in separate 'fec_phy.c' file.
Splitting the PHY functionality from main FEC driver.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 371 +---------------------
 1 file changed, 4 insertions(+), 367 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bc418b910999..ea29af5b847f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -20,6 +20,9 @@
  * Copyright (c) 2004-2006 Macq Electronique SA.
  *
  * Copyright (C) 2010-2011 Freescale Semiconductor, Inc.
+ *
+ * Moved the PHY code to fec_phy.c
+ * Copyright 2021 NXP
  */
 
 #include <linux/module.h>
@@ -70,6 +73,7 @@
 #include <asm/cacheflush.h>
 
 #include "fec.h"
+#include "fec_phy.h"
 
 static void set_multicast_list(struct net_device *ndev);
 static void fec_enet_itr_coal_init(struct net_device *ndev);
@@ -85,7 +89,6 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
 #define FEC_ENET_RAEM_V	0x8
 #define FEC_ENET_RAFL_V	0x8
 #define FEC_ENET_OPD_V	0xFFF0
-#define FEC_MDIO_PM_TIMEOUT  100 /* ms */
 
 struct fec_devinfo {
 	u32 quirks;
@@ -273,17 +276,6 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define	OPT_FRAME_SIZE	0
 #endif
 
-/* FEC MII MMFR bits definition */
-#define FEC_MMFR_ST		(1 << 30)
-#define FEC_MMFR_ST_C45		(0)
-#define FEC_MMFR_OP_READ	(2 << 28)
-#define FEC_MMFR_OP_READ_C45	(3 << 28)
-#define FEC_MMFR_OP_WRITE	(1 << 28)
-#define FEC_MMFR_OP_ADDR_WRITE	(0)
-#define FEC_MMFR_PA(v)		((v & 0x1f) << 23)
-#define FEC_MMFR_RA(v)		((v & 0x1f) << 18)
-#define FEC_MMFR_TA		(2 << 16)
-#define FEC_MMFR_DATA(v)	(v & 0xffff)
 /* FEC ECR bits definition */
 #define FEC_ECR_MAGICEN		(1 << 2)
 #define FEC_ECR_SLEEP		(1 << 3)
@@ -309,8 +301,6 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 	((addr >= txq->tso_hdrs_dma) && \
 	(addr < txq->tso_hdrs_dma + txq->bd.ring_size * TSO_HEADER_SIZE))
 
-static int mii_cnt;
-
 static struct bufdesc *fec_enet_get_nextdesc(struct bufdesc *bdp,
 					     struct bufdesc_prop *bd)
 {
@@ -1833,151 +1823,6 @@ static void fec_enet_adjust_link(struct net_device *ndev)
 		phy_print_status(phy_dev);
 }
 
-static int fec_enet_mdio_wait(struct fec_enet_private *fep)
-{
-	uint ievent;
-	int ret;
-
-	ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
-					ievent & FEC_ENET_MII, 2, 30000);
-
-	if (!ret)
-		writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
-
-	return ret;
-}
-
-static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
-{
-	struct fec_enet_private *fep = bus->priv;
-	struct device *dev = &fep->pdev->dev;
-	int ret = 0, frame_start, frame_addr, frame_op;
-	bool is_c45 = !!(regnum & MII_ADDR_C45);
-
-	ret = pm_runtime_resume_and_get(dev);
-	if (ret < 0)
-		return ret;
-
-	if (is_c45) {
-		frame_start = FEC_MMFR_ST_C45;
-
-		/* write address */
-		frame_addr = (regnum >> 16);
-		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
-		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		       FEC_MMFR_TA | (regnum & 0xFFFF),
-		       fep->hwp + FEC_MII_DATA);
-
-		/* wait for end of transfer */
-		ret = fec_enet_mdio_wait(fep);
-		if (ret) {
-			netdev_err(fep->netdev, "MDIO address write timeout\n");
-			goto out;
-		}
-
-		frame_op = FEC_MMFR_OP_READ_C45;
-
-	} else {
-		/* C22 read */
-		frame_op = FEC_MMFR_OP_READ;
-		frame_start = FEC_MMFR_ST;
-		frame_addr = regnum;
-	}
-
-	/* start a read op */
-	writel(frame_start | frame_op |
-		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
-
-	/* wait for end of transfer */
-	ret = fec_enet_mdio_wait(fep);
-	if (ret) {
-		netdev_err(fep->netdev, "MDIO read timeout\n");
-		goto out;
-	}
-
-	ret = FEC_MMFR_DATA(readl(fep->hwp + FEC_MII_DATA));
-
-out:
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
-
-	return ret;
-}
-
-static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
-			   u16 value)
-{
-	struct fec_enet_private *fep = bus->priv;
-	struct device *dev = &fep->pdev->dev;
-	int ret, frame_start, frame_addr;
-	bool is_c45 = !!(regnum & MII_ADDR_C45);
-
-	ret = pm_runtime_resume_and_get(dev);
-	if (ret < 0)
-		return ret;
-
-	if (is_c45) {
-		frame_start = FEC_MMFR_ST_C45;
-
-		/* write address */
-		frame_addr = (regnum >> 16);
-		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
-		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		       FEC_MMFR_TA | (regnum & 0xFFFF),
-		       fep->hwp + FEC_MII_DATA);
-
-		/* wait for end of transfer */
-		ret = fec_enet_mdio_wait(fep);
-		if (ret) {
-			netdev_err(fep->netdev, "MDIO address write timeout\n");
-			goto out;
-		}
-	} else {
-		/* C22 write */
-		frame_start = FEC_MMFR_ST;
-		frame_addr = regnum;
-	}
-
-	/* start a write op */
-	writel(frame_start | FEC_MMFR_OP_WRITE |
-		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		FEC_MMFR_TA | FEC_MMFR_DATA(value),
-		fep->hwp + FEC_MII_DATA);
-
-	/* wait for end of transfer */
-	ret = fec_enet_mdio_wait(fep);
-	if (ret)
-		netdev_err(fep->netdev, "MDIO write timeout\n");
-
-out:
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
-
-	return ret;
-}
-
-static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
-{
-	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct phy_device *phy_dev = ndev->phydev;
-
-	if (phy_dev) {
-		phy_reset_after_clk_enable(phy_dev);
-	} else if (fep->phy_node) {
-		/*
-		 * If the PHY still is not bound to the MAC, but there is
-		 * OF PHY node and a matching PHY device instance already,
-		 * use the OF PHY node to obtain the PHY device instance,
-		 * and then use that PHY device instance when triggering
-		 * the PHY reset.
-		 */
-		phy_dev = of_phy_find_device(fep->phy_node);
-		phy_reset_after_clk_enable(phy_dev);
-		put_device(&phy_dev->mdio.dev);
-	}
-}
-
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -2134,148 +1979,6 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	return 0;
 }
 
-static int fec_enet_mii_init(struct platform_device *pdev)
-{
-	static struct mii_bus *fec0_mii_bus;
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct fec_enet_private *fep = netdev_priv(ndev);
-	bool suppress_preamble = false;
-	struct device_node *node;
-	int err = -ENXIO;
-	u32 mii_speed, holdtime;
-	u32 bus_freq;
-
-	/*
-	 * The i.MX28 dual fec interfaces are not equal.
-	 * Here are the differences:
-	 *
-	 *  - fec0 supports MII & RMII modes while fec1 only supports RMII
-	 *  - fec0 acts as the 1588 time master while fec1 is slave
-	 *  - external phys can only be configured by fec0
-	 *
-	 * That is to say fec1 can not work independently. It only works
-	 * when fec0 is working. The reason behind this design is that the
-	 * second interface is added primarily for Switch mode.
-	 *
-	 * Because of the last point above, both phys are attached on fec0
-	 * mdio interface in board design, and need to be configured by
-	 * fec0 mii_bus.
-	 */
-	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
-		/* fec1 uses fec0 mii_bus */
-		if (mii_cnt && fec0_mii_bus) {
-			fep->mii_bus = fec0_mii_bus;
-			mii_cnt++;
-			return 0;
-		}
-		return -ENOENT;
-	}
-
-	bus_freq = 2500000; /* 2.5MHz by default */
-	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
-	if (node) {
-		of_property_read_u32(node, "clock-frequency", &bus_freq);
-		suppress_preamble = of_property_read_bool(node,
-							  "suppress-preamble");
-	}
-
-	/*
-	 * Set MII speed (= clk_get_rate() / 2 * phy_speed)
-	 *
-	 * The formula for FEC MDC is 'ref_freq / (MII_SPEED x 2)' while
-	 * for ENET-MAC is 'ref_freq / ((MII_SPEED + 1) x 2)'.  The i.MX28
-	 * Reference Manual has an error on this, and gets fixed on i.MX6Q
-	 * document.
-	 */
-	mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), bus_freq * 2);
-	if (fep->quirks & FEC_QUIRK_ENET_MAC)
-		mii_speed--;
-	if (mii_speed > 63) {
-		dev_err(&pdev->dev,
-			"fec clock (%lu) too fast to get right mii speed\n",
-			clk_get_rate(fep->clk_ipg));
-		err = -EINVAL;
-		goto err_out;
-	}
-
-	/*
-	 * The i.MX28 and i.MX6 types have another filed in the MSCR (aka
-	 * MII_SPEED) register that defines the MDIO output hold time. Earlier
-	 * versions are RAZ there, so just ignore the difference and write the
-	 * register always.
-	 * The minimal hold time according to IEE802.3 (clause 22) is 10 ns.
-	 * HOLDTIME + 1 is the number of clk cycles the fec is holding the
-	 * output.
-	 * The HOLDTIME bitfield takes values between 0 and 7 (inclusive).
-	 * Given that ceil(clkrate / 5000000) <= 64, the calculation for
-	 * holdtime cannot result in a value greater than 3.
-	 */
-	holdtime = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 100000000) - 1;
-
-	fep->phy_speed = mii_speed << 1 | holdtime << 8;
-
-	if (suppress_preamble)
-		fep->phy_speed |= BIT(7);
-
-	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
-		/* Clear MMFR to avoid to generate MII event by writing MSCR.
-		 * MII event generation condition:
-		 * - writing MSCR:
-		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
-		 *	  mscr_reg_data_in[7:0] != 0
-		 * - writing MMFR:
-		 *	- mscr[7:0]_not_zero
-		 */
-		writel(0, fep->hwp + FEC_MII_DATA);
-	}
-
-	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
-
-	/* Clear any pending transaction complete indication */
-	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
-
-	fep->mii_bus = mdiobus_alloc();
-	if (fep->mii_bus == NULL) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-	fep->mii_bus->name = "fec_enet_mii_bus";
-	fep->mii_bus->read = fec_enet_mdio_read;
-	fep->mii_bus->write = fec_enet_mdio_write;
-	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
-		pdev->name, fep->dev_id + 1);
-	fep->mii_bus->priv = fep;
-	fep->mii_bus->parent = &pdev->dev;
-
-	err = of_mdiobus_register(fep->mii_bus, node);
-	if (err)
-		goto err_out_free_mdiobus;
-	of_node_put(node);
-
-	mii_cnt++;
-
-	/* save fec0 mii_bus */
-	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO)
-		fec0_mii_bus = fep->mii_bus;
-
-	return 0;
-
-err_out_free_mdiobus:
-	mdiobus_free(fep->mii_bus);
-err_out:
-	of_node_put(node);
-	return err;
-}
-
-static void fec_enet_mii_remove(struct fec_enet_private *fep)
-{
-	if (--mii_cnt == 0) {
-		mdiobus_unregister(fep->mii_bus);
-		mdiobus_free(fep->mii_bus);
-	}
-}
-
 static void fec_enet_get_drvinfo(struct net_device *ndev,
 				 struct ethtool_drvinfo *info)
 {
@@ -3587,72 +3290,6 @@ static int fec_enet_init(struct net_device *ndev)
 	return ret;
 }
 
-#ifdef CONFIG_OF
-static int fec_reset_phy(struct platform_device *pdev)
-{
-	int err, phy_reset;
-	bool active_high = false;
-	int msec = 1, phy_post_delay = 0;
-	struct device_node *np = pdev->dev.of_node;
-
-	if (!np)
-		return 0;
-
-	err = of_property_read_u32(np, "phy-reset-duration", &msec);
-	/* A sane reset duration should not be longer than 1s */
-	if (!err && msec > 1000)
-		msec = 1;
-
-	phy_reset = of_get_named_gpio(np, "phy-reset-gpios", 0);
-	if (phy_reset == -EPROBE_DEFER)
-		return phy_reset;
-	else if (!gpio_is_valid(phy_reset))
-		return 0;
-
-	err = of_property_read_u32(np, "phy-reset-post-delay", &phy_post_delay);
-	/* valid reset duration should be less than 1s */
-	if (!err && phy_post_delay > 1000)
-		return -EINVAL;
-
-	active_high = of_property_read_bool(np, "phy-reset-active-high");
-
-	err = devm_gpio_request_one(&pdev->dev, phy_reset,
-			active_high ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
-			"phy-reset");
-	if (err) {
-		dev_err(&pdev->dev, "failed to get phy-reset-gpios: %d\n", err);
-		return err;
-	}
-
-	if (msec > 20)
-		msleep(msec);
-	else
-		usleep_range(msec * 1000, msec * 1000 + 1000);
-
-	gpio_set_value_cansleep(phy_reset, !active_high);
-
-	if (!phy_post_delay)
-		return 0;
-
-	if (phy_post_delay > 20)
-		msleep(phy_post_delay);
-	else
-		usleep_range(phy_post_delay * 1000,
-			     phy_post_delay * 1000 + 1000);
-
-	return 0;
-}
-#else /* CONFIG_OF */
-static int fec_reset_phy(struct platform_device *pdev)
-{
-	/*
-	 * In case of platform probe, the reset has been done
-	 * by machine code.
-	 */
-	return 0;
-}
-#endif /* CONFIG_OF */
-
 static void
 fec_enet_get_queue_num(struct platform_device *pdev, int *num_tx, int *num_rx)
 {
-- 
2.17.1

