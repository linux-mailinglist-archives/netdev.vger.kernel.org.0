Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4A21EDE8D
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgFDHfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:35:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:55327 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgFDHfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 03:35:20 -0400
IronPort-SDR: CUmplpLpTF+CJ9s5CbFQjGVkPpMck/oUhg9GCAU11k7ci37sELXlHxJKCg8gWD7xcI3nzsZpF2
 4vDcQ8WCTDeg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 00:35:20 -0700
IronPort-SDR: 4mtNFICZz/ZPrbQFWLvBIbCUHOHYpY3OAZaaC71w6XpNZAiOLpaY8FFEIDE0tEHYb8JAb6No8E
 v/66O/yA4GnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="348021703"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2020 00:35:16 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v3 08/10] net: eth: altera: add support for ptp and timestamping
Date:   Thu,  4 Jun 2020 15:32:54 +0800
Message-Id: <20200604073256.25702-9-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200604073256.25702-1-joyce.ooi@intel.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

Add support for the ptp clock used with the tse, and update
the driver to support timestamping when enabled.  We also
enable debugfs entries for the ptp clock to allow some user
control and interaction with the ptp clock.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: this patch is added in patch version 2
v3: no change
---
 drivers/net/ethernet/altera/Kconfig              |   1 +
 drivers/net/ethernet/altera/Makefile             |   3 +-
 drivers/net/ethernet/altera/altera_tse.h         |   8 +
 drivers/net/ethernet/altera/altera_tse_ethtool.c |  28 ++
 drivers/net/ethernet/altera/altera_tse_main.c    | 118 +++++++-
 drivers/net/ethernet/altera/intel_fpga_tod.c     | 358 +++++++++++++++++++++++
 drivers/net/ethernet/altera/intel_fpga_tod.h     |  56 ++++
 7 files changed, 570 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.c
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.h

diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
index 2690c398d2b2..6dec7094cb4b 100644
--- a/drivers/net/ethernet/altera/Kconfig
+++ b/drivers/net/ethernet/altera/Kconfig
@@ -3,6 +3,7 @@ config ALTERA_TSE
 	tristate "Altera Triple-Speed Ethernet MAC support"
 	depends on HAS_DMA
 	select PHYLIB
+	imply PTP_1588_CLOCK
 	---help---
 	  This driver supports the Altera Triple-Speed (TSE) Ethernet MAC.
 
diff --git a/drivers/net/ethernet/altera/Makefile b/drivers/net/ethernet/altera/Makefile
index a52db80aee9f..fc2e460926b3 100644
--- a/drivers/net/ethernet/altera/Makefile
+++ b/drivers/net/ethernet/altera/Makefile
@@ -5,4 +5,5 @@
 
 obj-$(CONFIG_ALTERA_TSE) += altera_tse.o
 altera_tse-objs := altera_tse_main.o altera_tse_ethtool.o \
-altera_msgdma.o altera_sgdma.o altera_utils.o
+		   altera_msgdma.o altera_sgdma.o altera_utils.o \
+		   intel_fpga_tod.o
diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index 79d02748c89d..b7c176a808ac 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -28,6 +28,8 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 
+#include "intel_fpga_tod.h"
+
 #define ALTERA_TSE_SW_RESET_WATCHDOG_CNTR	10000
 #define ALTERA_TSE_MAC_FIFO_WIDTH		4	/* TX/RX FIFO width in
 							 * bytes
@@ -417,6 +419,12 @@ struct altera_tse_private {
 	/* TSE Revision */
 	u32	revision;
 
+	/* Shared PTP structure */
+	struct intel_fpga_tod_private ptp_priv;
+	int hwts_tx_en;
+	int hwts_rx_en;
+	u32 ptp_enable;
+
 	/* mSGDMA Rx Dispatcher address space */
 	void __iomem *rx_dma_csr;
 	void __iomem *rx_dma_desc;
diff --git a/drivers/net/ethernet/altera/altera_tse_ethtool.c b/drivers/net/ethernet/altera/altera_tse_ethtool.c
index 420d77f00eab..cec41a2c7b00 100644
--- a/drivers/net/ethernet/altera/altera_tse_ethtool.c
+++ b/drivers/net/ethernet/altera/altera_tse_ethtool.c
@@ -19,6 +19,7 @@
 #include <linux/ethtool.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 
 #include "altera_tse.h"
@@ -222,6 +223,32 @@ static void tse_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 		buf[i] = csrrd32(priv->mac_dev, i * 4);
 }
 
+static int tse_get_ts_info(struct net_device *dev,
+			   struct ethtool_ts_info *info)
+{
+	struct altera_tse_private *priv = netdev_priv(dev);
+
+	if (priv->ptp_enable) {
+		if (priv->ptp_priv.ptp_clock)
+			info->phc_index =
+				ptp_clock_index(priv->ptp_priv.ptp_clock);
+
+		info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+					SOF_TIMESTAMPING_RX_HARDWARE |
+					SOF_TIMESTAMPING_RAW_HARDWARE;
+
+		info->tx_types = (1 << HWTSTAMP_TX_OFF) |
+						 (1 << HWTSTAMP_TX_ON);
+
+		info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+						   (1 << HWTSTAMP_FILTER_ALL);
+
+		return 0;
+	} else {
+		return ethtool_op_get_ts_info(dev, info);
+	}
+}
+
 static const struct ethtool_ops tse_ethtool_ops = {
 	.get_drvinfo = tse_get_drvinfo,
 	.get_regs_len = tse_reglen,
@@ -234,6 +261,7 @@ static const struct ethtool_ops tse_ethtool_ops = {
 	.set_msglevel = tse_set_msglevel,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_ts_info = tse_get_ts_info,
 };
 
 void altera_tse_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 24a1d30c6780..c874b8c1dd48 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -18,14 +18,17 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
+#include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mii.h>
+#include <linux/net_tstamp.h>
 #include <linux/netdevice.h>
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
@@ -40,6 +43,7 @@
 #include "altera_tse.h"
 #include "altera_sgdma.h"
 #include "altera_msgdma.h"
+#include "intel_fpga_tod.h"
 
 static atomic_t instance_count = ATOMIC_INIT(~0);
 /* Module parameters */
@@ -598,7 +602,11 @@ static netdev_tx_t tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (ret)
 		goto out;
 
-	skb_tx_timestamp(skb);
+	if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+		     priv->hwts_tx_en))
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+	else
+		skb_tx_timestamp(skb);
 
 	priv->tx_prod++;
 	dev->stats.tx_bytes += skb->len;
@@ -1238,6 +1246,13 @@ static int tse_open(struct net_device *dev)
 	if (dev->phydev)
 		phy_start(dev->phydev);
 
+	ret = intel_fpga_tod_init(&priv->ptp_priv);
+	if (ret)
+		netdev_warn(dev, "Failed PTP initialization\n");
+
+	priv->hwts_tx_en = 0;
+	priv->hwts_rx_en = 0;
+
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
@@ -1309,6 +1324,83 @@ static int tse_shutdown(struct net_device *dev)
 	return 0;
 }
 
+/* ioctl to configure timestamping */
+static int tse_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct altera_tse_private *priv = netdev_priv(dev);
+	struct hwtstamp_config config;
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (!priv->ptp_enable)	{
+		netdev_alert(priv->dev, "Timestamping not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (cmd == SIOCSHWTSTAMP) {
+		if (copy_from_user(&config, ifr->ifr_data,
+				   sizeof(struct hwtstamp_config)))
+			return -EFAULT;
+
+		if (config.flags)
+			return -EINVAL;
+
+		switch (config.tx_type) {
+		case HWTSTAMP_TX_OFF:
+			priv->hwts_tx_en = 0;
+			break;
+		case HWTSTAMP_TX_ON:
+			priv->hwts_tx_en = 1;
+			break;
+		default:
+			return -ERANGE;
+		}
+
+		switch (config.rx_filter) {
+		case HWTSTAMP_FILTER_NONE:
+			priv->hwts_rx_en = 0;
+			config.rx_filter = HWTSTAMP_FILTER_NONE;
+			break;
+		default:
+			priv->hwts_rx_en = 1;
+			config.rx_filter = HWTSTAMP_FILTER_ALL;
+			break;
+		}
+
+		if (copy_to_user(ifr->ifr_data, &config,
+				 sizeof(struct hwtstamp_config)))
+			return -EFAULT;
+		else
+			return 0;
+	}
+
+	if (cmd == SIOCGHWTSTAMP) {
+		config.flags = 0;
+
+		if (priv->hwts_tx_en)
+			config.tx_type = HWTSTAMP_TX_ON;
+		else
+			config.tx_type = HWTSTAMP_TX_OFF;
+
+		if (priv->hwts_rx_en)
+			config.rx_filter = HWTSTAMP_FILTER_ALL;
+		else
+			config.rx_filter = HWTSTAMP_FILTER_NONE;
+
+		if (copy_to_user(ifr->ifr_data, &config,
+				 sizeof(struct hwtstamp_config)))
+			return -EFAULT;
+		else
+			return 0;
+	}
+
+	if (!dev->phydev)
+		return -EINVAL;
+
+	return phy_mii_ioctl(dev->phydev, ifr, cmd);
+}
+
 static struct net_device_ops altera_tse_netdev_ops = {
 	.ndo_open		= tse_open,
 	.ndo_stop		= tse_shutdown,
@@ -1317,6 +1409,7 @@ static struct net_device_ops altera_tse_netdev_ops = {
 	.ndo_set_rx_mode	= tse_set_rx_mode,
 	.ndo_change_mtu		= tse_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_do_ioctl		= tse_do_ioctl,
 };
 
 /* Probe Altera TSE MAC device
@@ -1568,6 +1661,27 @@ static int altera_tse_probe(struct platform_device *pdev)
 		netdev_err(ndev, "Cannot attach to PHY (error: %d)\n", ret);
 		goto err_init_phy;
 	}
+
+	priv->ptp_enable = of_property_read_bool(pdev->dev.of_node,
+						 "altr,has-ptp");
+	dev_info(&pdev->dev, "PTP Enable: %d\n", priv->ptp_enable);
+
+	if (priv->ptp_enable) {
+		/* MAP PTP */
+		ret = intel_fpga_tod_probe(pdev, &priv->ptp_priv);
+		if (ret) {
+			dev_err(&pdev->dev, "cannot map PTP\n");
+			goto err_init_phy;
+		}
+		ret = intel_fpga_tod_register(&priv->ptp_priv,
+					      priv->device);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to register PTP clock\n");
+			ret = -ENXIO;
+			goto err_init_phy;
+		}
+	}
+
 	return 0;
 
 err_init_phy:
@@ -1595,6 +1709,8 @@ static int altera_tse_remove(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, NULL);
+	if (priv->ptp_enable)
+		intel_fpga_tod_unregister(&priv->ptp_priv);
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
 	free_netdev(ndev);
diff --git a/drivers/net/ethernet/altera/intel_fpga_tod.c b/drivers/net/ethernet/altera/intel_fpga_tod.c
new file mode 100644
index 000000000000..3771597642da
--- /dev/null
+++ b/drivers/net/ethernet/altera/intel_fpga_tod.c
@@ -0,0 +1,358 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Intel FPGA ToD PTP Hardware Clock (PHC) Linux driver
+ * Copyright (C) 2015-2016 Altera Corporation. All rights reserved.
+ * Copyright (C) 2017-2020 Intel Corporation. All rights reserved.
+ *
+ * Author(s):
+ *	Dalon Westergreen <dalon.westergreen@intel.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gcd.h>
+#include <linux/module.h>
+#include <linux/math64.h>
+#include <linux/net_tstamp.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include "altera_utils.h"
+#include "intel_fpga_tod.h"
+
+#define NOMINAL_PPB			1000000000ULL
+#define TOD_PERIOD_MAX			0xfffff
+#define TOD_PERIOD_MIN			0
+#define TOD_DRIFT_ADJUST_FNS_MAX	0xffff
+#define TOD_DRIFT_ADJUST_RATE_MAX	0xffff
+#define TOD_ADJUST_COUNT_MAX		0xfffff
+#define TOD_ADJUST_MS_MAX		(((((TOD_PERIOD_MAX) >> 16) + 1) * \
+					  ((TOD_ADJUST_COUNT_MAX) + 1)) /  \
+					 1000000UL)
+
+/* A fine ToD HW clock offset adjustment.
+ * To perform the fine offset adjustment the AdjustPeriod register is used
+ * to replace the Period register for AdjustCount clock cycles in hardware.
+ */
+static int fine_adjust_tod_clock(struct intel_fpga_tod_private *priv,
+				 u32 adjust_period, u32 adjust_count)
+{
+	int limit;
+
+	csrwr32(adjust_period, priv->tod_ctrl, tod_csroffs(adjust_period));
+	csrwr32(adjust_count, priv->tod_ctrl, tod_csroffs(adjust_count));
+
+	/* Wait for present offset adjustment update to complete */
+	limit = TOD_ADJUST_MS_MAX;
+	while (limit--) {
+		if (!csrrd32(priv->tod_ctrl, tod_csroffs(adjust_count)))
+			break;
+		mdelay(1);
+	}
+	if (limit < 0)
+		return -EBUSY;
+
+	return 0;
+}
+
+/* A coarse ToD HW clock offset adjustment.
+ * The coarse time adjustment performs by adding or subtracting the delta value
+ * from the current ToD HW clock time.
+ */
+static int coarse_adjust_tod_clock(struct intel_fpga_tod_private *priv,
+				   s64 delta)
+{
+	u32 seconds_msb, seconds_lsb, nanosec;
+	u64 seconds, now;
+
+	if (delta == 0)
+		goto out;
+
+	/* Get current time */
+	nanosec = csrrd32(priv->tod_ctrl, tod_csroffs(nanosec));
+	seconds_lsb = csrrd32(priv->tod_ctrl, tod_csroffs(seconds_lsb));
+	seconds_msb = csrrd32(priv->tod_ctrl, tod_csroffs(seconds_msb));
+
+	/* Calculate new time */
+	seconds = (((u64)(seconds_msb & 0x0000ffff)) << 32) | seconds_lsb;
+	now = seconds * NSEC_PER_SEC + nanosec + delta;
+
+	seconds = div_u64_rem(now, NSEC_PER_SEC, &nanosec);
+	seconds_msb = upper_32_bits(seconds) & 0x0000ffff;
+	seconds_lsb = lower_32_bits(seconds);
+
+	/* Set corrected time */
+	csrwr32(seconds_msb, priv->tod_ctrl, tod_csroffs(seconds_msb));
+	csrwr32(seconds_lsb, priv->tod_ctrl, tod_csroffs(seconds_lsb));
+	csrwr32(nanosec, priv->tod_ctrl, tod_csroffs(nanosec));
+
+out:
+	return 0;
+}
+
+static int intel_fpga_tod_adjust_fine(struct ptp_clock_info *ptp,
+				      long scaled_ppm)
+{
+	struct intel_fpga_tod_private *priv =
+		container_of(ptp, struct intel_fpga_tod_private, ptp_clock_ops);
+	u32 tod_period, tod_rem, tod_drift_adjust_fns, tod_drift_adjust_rate;
+	unsigned long flags;
+	unsigned long rate;
+	int ret = 0;
+	u64 ppb;
+
+	rate = clk_get_rate(priv->tod_clk);
+
+	/* From scaled_ppm_to_ppb */
+	ppb = 1 + scaled_ppm;
+	ppb *= 125;
+	ppb >>= 13;
+
+	ppb += NOMINAL_PPB;
+
+	tod_period = div_u64_rem(ppb << 16, rate, &tod_rem);
+	if (tod_period > TOD_PERIOD_MAX) {
+		ret = -ERANGE;
+		goto out;
+	}
+
+	/* The drift of ToD adjusted periodically by adding a drift_adjust_fns
+	 * correction value every drift_adjust_rate count of clock cycles.
+	 */
+	tod_drift_adjust_fns = tod_rem / gcd(tod_rem, rate);
+	tod_drift_adjust_rate = rate / gcd(tod_rem, rate);
+
+	while ((tod_drift_adjust_fns > TOD_DRIFT_ADJUST_FNS_MAX) |
+		(tod_drift_adjust_rate > TOD_DRIFT_ADJUST_RATE_MAX)) {
+		tod_drift_adjust_fns = tod_drift_adjust_fns >> 1;
+		tod_drift_adjust_rate = tod_drift_adjust_rate >> 1;
+	}
+
+	if (tod_drift_adjust_fns == 0)
+		tod_drift_adjust_rate = 0;
+
+	spin_lock_irqsave(&priv->tod_lock, flags);
+	csrwr32(tod_period, priv->tod_ctrl, tod_csroffs(period));
+	csrwr32(0, priv->tod_ctrl, tod_csroffs(adjust_period));
+	csrwr32(0, priv->tod_ctrl, tod_csroffs(adjust_count));
+	csrwr32(tod_drift_adjust_fns, priv->tod_ctrl,
+		tod_csroffs(drift_adjust));
+	csrwr32(tod_drift_adjust_rate, priv->tod_ctrl,
+		tod_csroffs(drift_adjust_rate));
+	spin_unlock_irqrestore(&priv->tod_lock, flags);
+
+out:
+	return ret;
+}
+
+static int intel_fpga_tod_adjust_time(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct intel_fpga_tod_private *priv =
+		container_of(ptp, struct intel_fpga_tod_private, ptp_clock_ops);
+	unsigned long flags;
+	u32 period, diff, rem, rem_period, adj_period;
+	u64 count;
+	int neg_adj = 0, ret = 0;
+
+	if (delta < 0) {
+		neg_adj = 1;
+		delta = -delta;
+	}
+
+	spin_lock_irqsave(&priv->tod_lock, flags);
+
+	/* Get the maximum possible value of the Period register offset
+	 * adjustment in nanoseconds scale. This depends on the current
+	 * Period register setting and the maximum and minimum possible
+	 * values of the Period register.
+	 */
+	period = csrrd32(priv->tod_ctrl, tod_csroffs(period));
+
+	if (neg_adj)
+		diff = (period - TOD_PERIOD_MIN) >> 16;
+	else
+		diff = (TOD_PERIOD_MAX - period) >> 16;
+
+	/* Find the number of cycles required for the
+	 * time adjustment
+	 */
+	count = div_u64_rem(delta, diff, &rem);
+
+	if (neg_adj) {
+		adj_period = period - (diff << 16);
+		rem_period = period - (rem << 16);
+	} else {
+		adj_period = period + (diff << 16);
+		rem_period = period + (rem << 16);
+	}
+
+	/* If count is larger than the maximum count,
+	 * just set the time.
+	 */
+	if (count > TOD_ADJUST_COUNT_MAX) {
+		/* Perform the coarse time offset adjustment */
+		ret = coarse_adjust_tod_clock(priv, delta);
+	} else {
+		/* Adjust the period for count cycles to adjust
+		 * the time.
+		 */
+		if (count)
+			ret = fine_adjust_tod_clock(priv, adj_period, count);
+
+		/* If there is a remainder, adjust the period for an
+		 * additional cycle
+		 */
+		if (rem)
+			ret = fine_adjust_tod_clock(priv, rem_period, 1);
+	}
+
+	spin_unlock_irqrestore(&priv->tod_lock, flags);
+
+	return ret;
+}
+
+static int intel_fpga_tod_get_time(struct ptp_clock_info *ptp,
+				   struct timespec64 *ts)
+{
+	struct intel_fpga_tod_private *priv =
+		container_of(ptp, struct intel_fpga_tod_private, ptp_clock_ops);
+	u32 seconds_msb, seconds_lsb, nanosec;
+	unsigned long flags;
+	u64 seconds;
+
+	spin_lock_irqsave(&priv->tod_lock, flags);
+	nanosec = csrrd32(priv->tod_ctrl, tod_csroffs(nanosec));
+	seconds_lsb = csrrd32(priv->tod_ctrl, tod_csroffs(seconds_lsb));
+	seconds_msb = csrrd32(priv->tod_ctrl, tod_csroffs(seconds_msb));
+	spin_unlock_irqrestore(&priv->tod_lock, flags);
+
+	seconds = (((u64)(seconds_msb & 0x0000ffff)) << 32) | seconds_lsb;
+
+	ts->tv_nsec = nanosec;
+	ts->tv_sec = (__kernel_old_time_t)seconds;
+
+	return 0;
+}
+
+static int intel_fpga_tod_set_time(struct ptp_clock_info *ptp,
+				   const struct timespec64 *ts)
+{
+	struct intel_fpga_tod_private *priv =
+		container_of(ptp, struct intel_fpga_tod_private, ptp_clock_ops);
+	u32 seconds_msb = upper_32_bits(ts->tv_sec) & 0x0000ffff;
+	u32 seconds_lsb = lower_32_bits(ts->tv_sec);
+	u32 nanosec = lower_32_bits(ts->tv_nsec);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tod_lock, flags);
+	csrwr32(seconds_msb, priv->tod_ctrl, tod_csroffs(seconds_msb));
+	csrwr32(seconds_lsb, priv->tod_ctrl, tod_csroffs(seconds_lsb));
+	csrwr32(nanosec, priv->tod_ctrl, tod_csroffs(nanosec));
+	spin_unlock_irqrestore(&priv->tod_lock, flags);
+
+	return 0;
+}
+
+static int intel_fpga_tod_enable_feature(struct ptp_clock_info *ptp,
+					 struct ptp_clock_request *request,
+					 int on)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct ptp_clock_info intel_fpga_tod_clock_ops = {
+	.owner = THIS_MODULE,
+	.name = "intel_fpga_tod",
+	.max_adj = 500000000,
+	.n_alarm = 0,
+	.n_ext_ts = 0,
+	.n_per_out = 0,
+	.pps = 0,
+	.adjfine = intel_fpga_tod_adjust_fine,
+	.adjtime = intel_fpga_tod_adjust_time,
+	.gettime64 = intel_fpga_tod_get_time,
+	.settime64 = intel_fpga_tod_set_time,
+	.enable = intel_fpga_tod_enable_feature,
+};
+
+/* Initialize PTP control block registers */
+int intel_fpga_tod_init(struct intel_fpga_tod_private *priv)
+{
+	struct timespec64 now;
+	int ret = 0;
+
+	ret = intel_fpga_tod_adjust_fine(&priv->ptp_clock_ops, 0l);
+	if (ret != 0)
+		goto out;
+
+	/* Initialize the hardware clock to the system time */
+	ktime_get_real_ts64(&now);
+	intel_fpga_tod_set_time(&priv->ptp_clock_ops, &now);
+
+	spin_lock_init(&priv->tod_lock);
+
+out:
+	return ret;
+}
+
+/* Register the PTP clock driver to kernel */
+int intel_fpga_tod_register(struct intel_fpga_tod_private *priv,
+			    struct device *device)
+{
+	int ret = 0;
+
+	priv->ptp_clock_ops = intel_fpga_tod_clock_ops;
+
+	priv->ptp_clock = ptp_clock_register(&priv->ptp_clock_ops, device);
+	if (IS_ERR(priv->ptp_clock)) {
+		priv->ptp_clock = NULL;
+		ret = -ENODEV;
+	}
+
+	if (priv->tod_clk)
+		ret = clk_prepare_enable(priv->tod_clk);
+
+	return ret;
+}
+
+/* Remove/unregister the ptp clock driver from the kernel */
+void intel_fpga_tod_unregister(struct intel_fpga_tod_private *priv)
+{
+	if (priv->ptp_clock) {
+		ptp_clock_unregister(priv->ptp_clock);
+		priv->ptp_clock = NULL;
+	}
+
+	if (priv->tod_clk)
+		clk_disable_unprepare(priv->tod_clk);
+}
+
+/* Common PTP probe function */
+int intel_fpga_tod_probe(struct platform_device *pdev,
+			 struct intel_fpga_tod_private *priv)
+{
+	struct resource *ptp_res;
+	int ret = -ENODEV;
+
+	priv->dev = (struct net_device *)platform_get_drvdata(pdev);
+
+	/* Time-of-Day (ToD) Clock address space */
+	ret = request_and_map(pdev, "tod_ctrl", &ptp_res,
+			      (void __iomem **)&priv->tod_ctrl);
+	if (ret)
+		goto err;
+
+	dev_info(&pdev->dev, "\tTOD Ctrl at 0x%08lx\n",
+		 (unsigned long)ptp_res->start);
+
+	/* Time-of-Day (ToD) Clock period clock */
+	priv->tod_clk = devm_clk_get(&pdev->dev, "tod_clk");
+	if (IS_ERR(priv->tod_clk)) {
+		dev_err(&pdev->dev, "cannot obtain ToD period clock\n");
+		ret = -ENXIO;
+		goto err;
+	}
+err:
+	return ret;
+}
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/altera/intel_fpga_tod.h b/drivers/net/ethernet/altera/intel_fpga_tod.h
new file mode 100644
index 000000000000..064b97c2bf38
--- /dev/null
+++ b/drivers/net/ethernet/altera/intel_fpga_tod.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Altera PTP Hardware Clock (PHC) Linux driver
+ * Copyright (C) 2015-2016 Altera Corporation. All rights reserved.
+ * Copyright (C) 2017-2020 Intel Corporation. All rights reserved.
+ *
+ * Author(s):
+ *	Dalon Westergreen <dalon.westergreen@intel.com>
+ */
+
+#ifndef __INTEL_FPGA_TOD_H__
+#define __INTEL_FPGA_TOD_H__
+
+#include <linux/debugfs.h>
+#include <linux/netdevice.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+
+/* Altera Time-of-Day (ToD) clock register space. */
+struct intel_fpga_tod {
+	u32 seconds_msb;
+	u32 seconds_lsb;
+	u32 nanosec;
+	u32 reserved1[0x1];
+	u32 period;
+	u32 adjust_period;
+	u32 adjust_count;
+	u32 drift_adjust;
+	u32 drift_adjust_rate;
+};
+
+#define tod_csroffs(a)	(offsetof(struct intel_fpga_tod, a))
+
+struct intel_fpga_tod_private {
+	struct net_device *dev;
+
+	struct ptp_clock_info ptp_clock_ops;
+	struct ptp_clock *ptp_clock;
+
+	/* Time-of-Day (ToD) Clock address space */
+	struct intel_fpga_tod __iomem *tod_ctrl;
+	struct clk *tod_clk;
+
+	/* ToD clock registers protection */
+	spinlock_t tod_lock;
+};
+
+int intel_fpga_tod_init(struct intel_fpga_tod_private *priv);
+void intel_fpga_tod_uinit(struct intel_fpga_tod_private *priv);
+int intel_fpga_tod_register(struct intel_fpga_tod_private *priv,
+			    struct device *device);
+void intel_fpga_tod_unregister(struct intel_fpga_tod_private *priv);
+int intel_fpga_tod_probe(struct platform_device *pdev,
+			 struct intel_fpga_tod_private *priv);
+
+#endif /* __INTEL_FPGA_TOD_H__ */
-- 
2.13.0

