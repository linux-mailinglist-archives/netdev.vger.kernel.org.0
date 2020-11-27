Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5690E2C66F5
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgK0Ndo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 08:33:44 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2984 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgK0Ndi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 08:33:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606484012; x=1638020012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cavFPSBQMyeaykcqsyBh3TgydtHuDv7C7aoFkL2evkA=;
  b=LPUGq+4Gvdgq1BlKfPHXnmCYj5TpWhIygEOyyMIx8yWvFL4vcqVFMWzV
   EJeSyFGOyihfZ8Bw7U6c0vmUZEH6RAs0DLAHH4Bw9y13Xex5o5B1Qbl+A
   dHJthOMWSjGsPjBWsQc9ZaVpExfSjoSLtJXfcJEsdvQYrS360kCVvGWP/
   ufNdii9Cf+ip0g56t+27PuMiTFUK2xv+46tHVNUOr+rhKGEtglvBAqq/C
   7OUjbXjneXydQl2HVX2FMeF9OoVmfSTE8iQK8ZPO+0hi9nIe43u6segaT
   iUhBBSelBIQ5Iz53Mswrdd+zHTVJz4Wu9qPG8AjY94q9RkYX9+/ljXKJJ
   w==;
IronPort-SDR: mo2jXyUfINP78SBbw8rOjPcCJnVOvR3nGQXs51o/7OxNhOLB8Gcnh6jIlur6PbNw2Poif4S4EO
 OAPT/kyVVZ3M4K11hCfS9Mcl12XJXzmrEHEqijItndtMFpM0M5n1saVhWaSIqz394cHahV/SNH
 TfjHNAwC8yjGTOp/Yl4kAKFljRExigB+aHHWkFN47xNzLw2oF9IpSNuMzcJt8iTFe5bphMiJgL
 vGehVmz9Bz78lUoYSkbn+sHErpoCUPTUIZ7LBlQGE+SfBxKZeXcE8fPjM61bE1RhqncKi1D3gL
 SS0=
X-IronPort-AV: E=Sophos;i="5.78,374,1599548400"; 
   d="scan'208";a="95050363"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2020 06:33:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 27 Nov 2020 06:33:30 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 27 Nov 2020 06:33:27 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Date:   Fri, 27 Nov 2020 14:33:06 +0100
Message-ID: <20201127133307.2969817-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127133307.2969817-1-steen.hegelund@microchip.com>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the Microchip Sparx5 switch device driver.

This driver provides the network interfaces and supports
L2 hardware offloaded switching.

It uses the Microchip Sparx5 SerDes driver for configuration
of the physical interfaces.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/Kconfig        |    2 +
 drivers/net/ethernet/microchip/Makefile       |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    8 +
 .../net/ethernet/microchip/sparx5/Makefile    |   11 +
 .../microchip/sparx5/sparx5_calendar.c        |  593 +++
 .../ethernet/microchip/sparx5/sparx5_common.h |  162 +
 .../microchip/sparx5/sparx5_ethtool.c         | 1027 +++++
 .../microchip/sparx5/sparx5_mactable.c        |  510 +++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  851 ++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  236 +
 .../microchip/sparx5/sparx5_main_regs.h       | 3922 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  238 +
 .../ethernet/microchip/sparx5/sparx5_packet.c |  279 ++
 .../microchip/sparx5/sparx5_phylink.c         |  179 +
 .../ethernet/microchip/sparx5/sparx5_port.c   | 1125 +++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |   95 +
 .../microchip/sparx5/sparx5_switchdev.c       |  510 +++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  219 +
 18 files changed, 9969 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_common.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 31f9a82dc113..7ddd6eb04c5d 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -53,4 +53,6 @@ config LAN743X
 	  To compile this driver as a module, choose M here. The module will be
 	  called lan743x.
 
+source "drivers/net/ethernet/microchip/sparx5/Kconfig"
+
 endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/Makefile b/drivers/net/ethernet/microchip/Makefile
index da603540ca57..c77dc0379bfd 100644
--- a/drivers/net/ethernet/microchip/Makefile
+++ b/drivers/net/ethernet/microchip/Makefile
@@ -8,3 +8,5 @@ obj-$(CONFIG_ENCX24J600) += encx24j600.o encx24j600-regmap.o
 obj-$(CONFIG_LAN743X) += lan743x.o
 
 lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o
+
+obj-$(CONFIG_SPARX5_SWITCH) += sparx5/
diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
new file mode 100644
index 000000000000..d2cb84372071
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -0,0 +1,8 @@
+config SPARX5_SWITCH
+	tristate "Sparx5 switch driver"
+	depends on NET_SWITCHDEV
+	depends on HAS_IOMEM
+	select PHYLINK
+	select PHY_SPARX5_SERDES
+	help
+	  This driver supports the Sparx5 network switch device.
diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
new file mode 100644
index 000000000000..de3155cd582c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Microchip Sparx5 network device drivers.
+#
+
+obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
+
+sparx5-switch-objs  := sparx5_main.o sparx5_switchdev.o \
+ sparx5_vlan.o sparx5_mactable.o sparx5_packet.o \
+ sparx5_ethtool.o sparx5_netdev.o sparx5_port.o \
+ sparx5_phylink.o sparx5_calendar.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c b/drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
new file mode 100644
index 000000000000..69b713c16aa7
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
@@ -0,0 +1,593 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+
+#include "sparx5_main.h"
+
+/* QSYS calendar information */
+#define SPX5_PORTS_PER_CALREG          10  /* Ports mapped in a calendar register */
+#define SPX5_CALBITS_PER_PORT          3   /* Bit per port in calendar register */
+
+/* DSM calendar information */
+#define SPX5_DSM_CAL_LEN               64
+#define SPX5_DSM_CAL_EMPTY             0xFFFF
+#define SPX5_DSM_CAL_MAX_DEVS_PER_TAXI 13
+#define SPX5_DSM_CAL_TAXIS             8
+#define SPX5_DSM_CAL_BW_LOSS           553
+
+#define SPX5_TAXI_PORT_MAX             70
+
+/* Maps from taxis to port numbers */
+static u32 sparx5_taxi_ports[SPX5_DSM_CAL_TAXIS][SPX5_DSM_CAL_MAX_DEVS_PER_TAXI] = {
+	{57, 12, 0, 1, 2, 16, 17, 18, 19, 20, 21, 22, 23},
+	{58, 13, 3, 4, 5, 24, 25, 26, 27, 28, 29, 30, 31},
+	{59, 14, 6, 7, 8, 32, 33, 34, 35, 36, 37, 38, 39},
+	{60, 15, 9, 10, 11, 40, 41, 42, 43, 44, 45, 46, 47},
+	{61, 48, 49, 50, 99, 99, 99, 99, 99, 99, 99, 99, 99},
+	{62, 51, 52, 53, 99, 99, 99, 99, 99, 99, 99, 99, 99},
+	{56, 63, 54, 55, 99, 99, 99, 99, 99, 99, 99, 99, 99},
+	{64, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99},
+};
+
+struct sparx5_calendar_data {
+	u32 schedule[SPX5_DSM_CAL_LEN];
+	u32 avg_dist[SPX5_DSM_CAL_MAX_DEVS_PER_TAXI];
+	u32 taxi_ports[SPX5_DSM_CAL_MAX_DEVS_PER_TAXI];
+	u32 taxi_speeds[SPX5_DSM_CAL_MAX_DEVS_PER_TAXI];
+	u32 dev_slots[SPX5_DSM_CAL_MAX_DEVS_PER_TAXI];
+	u32 new_slots[SPX5_DSM_CAL_LEN];
+	u32 temp_sched[SPX5_DSM_CAL_LEN];
+	u32 indices[SPX5_DSM_CAL_LEN];
+	u32 short_list[SPX5_DSM_CAL_LEN];
+	u32 long_list[SPX5_DSM_CAL_LEN];
+};
+
+static u32 sparx5_target_bandwidth(struct sparx5 *sparx5)
+{
+	switch (sparx5->target_ct) {
+	case SPX5_TARGET_CT_7546:
+	case SPX5_TARGET_CT_7546TSN:
+		return 65000;
+	case SPX5_TARGET_CT_7549:
+	case SPX5_TARGET_CT_7549TSN:
+		return 91000;
+	case SPX5_TARGET_CT_7552:
+	case SPX5_TARGET_CT_7552TSN:
+		return 129000;
+	case SPX5_TARGET_CT_7556:
+	case SPX5_TARGET_CT_7556TSN:
+		return 161000;
+	case SPX5_TARGET_CT_7558:
+	case SPX5_TARGET_CT_7558TSN:
+		return 201000;
+	default:
+		return 0;
+	}
+}
+
+/* This is used in calendar configuration */
+enum sparx5_cal_bw {
+	SPX5_CAL_SPEED_NONE = 0,
+	SPX5_CAL_SPEED_1G   = 1,
+	SPX5_CAL_SPEED_2G5  = 2,
+	SPX5_CAL_SPEED_5G   = 3,
+	SPX5_CAL_SPEED_10G  = 4,
+	SPX5_CAL_SPEED_25G  = 5,
+	SPX5_CAL_SPEED_0G5  = 6,
+	SPX5_CAL_SPEED_12G5 = 7
+};
+
+static u32 sparx5_clk_to_bandwidth(enum sparx5_core_clockfreq cclock)
+{
+	switch (cclock) {
+	case SPX5_CORE_CLOCK_250MHZ: return 83000; /* 250000 / 3 */
+	case SPX5_CORE_CLOCK_500MHZ: return 166000; /* 500000 / 3 */
+	case SPX5_CORE_CLOCK_625MHZ: return  208000; /* 625000 / 3 */
+	default: return 0;
+	}
+	return 0;
+}
+
+static u32 sparx5_cal_speed_to_value(enum sparx5_cal_bw speed)
+{
+	switch (speed) {
+	case SPX5_CAL_SPEED_1G:   return 1000;
+	case SPX5_CAL_SPEED_2G5:  return 2500;
+	case SPX5_CAL_SPEED_5G:   return 5000;
+	case SPX5_CAL_SPEED_10G:  return 10000;
+	case SPX5_CAL_SPEED_25G:  return 25000;
+	case SPX5_CAL_SPEED_0G5:  return 500;
+	case SPX5_CAL_SPEED_12G5: return 12500;
+	default: return 0;
+	}
+}
+
+static u32 sparx5_bandwidth_to_calendar(u32 bw)
+{
+	switch (bw) {
+	case SPEED_10:      return SPX5_CAL_SPEED_0G5;
+	case SPEED_100:     return SPX5_CAL_SPEED_0G5;
+	case SPEED_1000:    return SPX5_CAL_SPEED_1G;
+	case SPEED_2500:    return SPX5_CAL_SPEED_2G5;
+	case SPEED_5000:    return SPX5_CAL_SPEED_5G;
+	case SPEED_10000:   return SPX5_CAL_SPEED_10G;
+	case SPEED_12500:   return SPX5_CAL_SPEED_12G5;
+	case SPEED_25000:   return SPX5_CAL_SPEED_25G;
+	case SPEED_UNKNOWN: return SPX5_CAL_SPEED_1G;
+	default:            return SPX5_CAL_SPEED_NONE;
+	}
+}
+
+static enum sparx5_cal_bw sparx5_get_port_cal_speed(struct sparx5 *sparx5,
+						    u32 portno)
+{
+	struct sparx5_port *port;
+
+	if (portno >= SPX5_PORTS) {
+		/* Internal ports */
+		if (portno == SPX5_PORT_CPU_0 || portno == SPX5_PORT_CPU_1) {
+			/* Equals 1.25G */
+			return SPX5_CAL_SPEED_2G5;
+		} else if (portno == SPX5_PORT_VD0) {
+			/* IPMC only idle BW */
+			return SPX5_CAL_SPEED_NONE;
+		} else if (portno == SPX5_PORT_VD1) {
+			/* OAM only idle BW */
+			return SPX5_CAL_SPEED_NONE;
+		} else if (portno == SPX5_PORT_VD2) {
+			/* IPinIP gets only idle BW */
+			return SPX5_CAL_SPEED_NONE;
+		}
+		/* not in port map */
+		return SPX5_CAL_SPEED_NONE;
+	}
+	/* Front ports - may be used */
+	port = sparx5->ports[portno];
+	if (!port)
+		return SPX5_CAL_SPEED_NONE;
+	return sparx5_bandwidth_to_calendar(port->conf.max_speed);
+}
+
+/* Auto configure the QSYS calendar based on port configuration */
+int sparx5_config_auto_calendar(struct sparx5 *sparx5)
+{
+	u32 cal[7], value, idx, portno;
+	u32 max_core_bw;
+	u32 total_bw = 0, used_port_bw = 0;
+	int err = 0;
+	enum sparx5_cal_bw spd;
+
+	memset(cal, 0, sizeof(cal));
+
+	max_core_bw = sparx5_clk_to_bandwidth(sparx5->coreclock);
+	if (max_core_bw == 0) {
+		dev_err(sparx5->dev, "Core clock not supported");
+		return -EINVAL;
+	}
+
+	/* Setup the calendar with the bandwidth to each port */
+	for (portno = 0; portno < SPX5_PORTS_ALL; portno++) {
+		u32 reg, offset, this_bw;
+
+		spd = sparx5_get_port_cal_speed(sparx5, portno);
+		if (spd == SPX5_CAL_SPEED_NONE)
+			continue;
+
+		this_bw = sparx5_cal_speed_to_value(spd);
+		if (portno < SPX5_PORTS)
+			used_port_bw += this_bw;
+		else
+			/* Internal ports are granted half the value */
+			this_bw = this_bw / 2;
+		total_bw += this_bw;
+		reg = portno;
+		offset = do_div(reg, SPX5_PORTS_PER_CALREG);
+		cal[reg] |= spd << (offset * SPX5_CALBITS_PER_PORT);
+	}
+
+	if (used_port_bw > sparx5_target_bandwidth(sparx5)) {
+		dev_err(sparx5->dev,
+			"Port BW %u above target BW %u\n",
+			used_port_bw, sparx5_target_bandwidth(sparx5));
+		return -EINVAL;
+	}
+
+	if (total_bw > max_core_bw) {
+		dev_err(sparx5->dev,
+			"Total BW %u above switch core BW %u\n",
+			total_bw, max_core_bw);
+		return -EINVAL;
+	}
+
+	/* Halt the calendar while changing it */
+	SPX5_RMW(QSYS_CAL_CTRL_CAL_MODE_SET(10),
+		 QSYS_CAL_CTRL_CAL_MODE,
+		 sparx5, QSYS_CAL_CTRL);
+
+	/* Assign port bandwidth to auto calendar */
+	for (idx = 0; idx < ARRAY_SIZE(cal); idx++)
+		SPX5_WR(cal[idx], sparx5, QSYS_CAL_AUTO(idx));
+
+	/* Increase grant rate of all ports to account for
+	 * core clock ppm deviations
+	 */
+	SPX5_RMW(QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE_SET(671), /* 672->671 */
+		 QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE,
+		 sparx5,
+		 QSYS_CAL_CTRL);
+
+	/* Grant idle usage to VD 0-2 */
+	for (idx = 2; idx < 5; idx++)
+		SPX5_WR(HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA_SET(12),
+			sparx5,
+			HSCH_OUTB_SHARE_ENA(idx));
+
+	/* Enable Auto mode */
+	SPX5_RMW(QSYS_CAL_CTRL_CAL_MODE_SET(8),
+		 QSYS_CAL_CTRL_CAL_MODE,
+		 sparx5, QSYS_CAL_CTRL);
+
+	/* Verify successful calendar config */
+	value = SPX5_RD(sparx5, QSYS_CAL_CTRL);
+	if (QSYS_CAL_CTRL_CAL_AUTO_ERROR_GET(value)) {
+		dev_err(sparx5->dev, "QSYS calendar error\n");
+		err = -EINVAL;
+	}
+	return err;
+}
+
+static u32 sparx5_dsm_exb_gcd(u32 a, u32 b)
+{
+	if (b == 0)
+		return a;
+	return sparx5_dsm_exb_gcd(b, a % b);
+}
+
+static u32 sparx5_dsm_cal_len(u32 *cal)
+{
+	u32 idx = 0, len = 0;
+
+	while (idx < SPX5_DSM_CAL_LEN) {
+		if (cal[idx] != SPX5_DSM_CAL_EMPTY)
+			len++;
+		idx++;
+	}
+	return len;
+}
+
+static u32 sparx5_dsm_cp_cal(u32 *sched)
+{
+	u32 idx = 0, tmp;
+
+	while (idx < SPX5_DSM_CAL_LEN) {
+		if (sched[idx] != SPX5_DSM_CAL_EMPTY) {
+			tmp = sched[idx];
+			sched[idx] = SPX5_DSM_CAL_EMPTY;
+			return tmp;
+		}
+		idx++;
+	}
+	return SPX5_DSM_CAL_EMPTY;
+}
+
+static int sparx5_dsm_calendar_calc(struct sparx5 *sparx5, u32 taxi,
+				    struct sparx5_calendar_data *data)
+{
+	bool slow_mode;
+	u32 gcd, idx, sum, min, factor;
+	u32 num_of_slots, slot_spd, empty_slots;
+	u32 taxi_bw, clk_period_ps;
+
+	clk_period_ps = sparx5_clk_period(sparx5->coreclock);
+	taxi_bw = 128 * 1000000 / clk_period_ps;
+	slow_mode = !!(clk_period_ps > 2000);
+	memcpy(data->taxi_ports, &sparx5_taxi_ports[taxi],
+	       sizeof(data->taxi_ports));
+
+	for (idx = 0; idx < SPX5_DSM_CAL_LEN; idx++) {
+		data->new_slots[idx] = SPX5_DSM_CAL_EMPTY;
+		data->schedule[idx] = SPX5_DSM_CAL_EMPTY;
+		data->temp_sched[idx] = SPX5_DSM_CAL_EMPTY;
+	}
+	/* Default empty calendar */
+	data->schedule[0] = SPX5_DSM_CAL_MAX_DEVS_PER_TAXI;
+
+	/* Map ports to taxi positions */
+	for (idx = 0; idx < SPX5_DSM_CAL_MAX_DEVS_PER_TAXI; idx++) {
+		u32 portno = data->taxi_ports[idx];
+
+		if (portno < SPX5_TAXI_PORT_MAX) {
+			data->taxi_speeds[idx] = sparx5_cal_speed_to_value
+				(sparx5_get_port_cal_speed(sparx5, portno));
+		} else {
+			data->taxi_speeds[idx] = 0;
+		}
+	}
+
+	sum = 0;
+	min = 25000;
+	for (idx = 0; idx < ARRAY_SIZE(data->taxi_speeds); idx++) {
+		u32 jdx;
+
+		sum += data->taxi_speeds[idx];
+		if (data->taxi_speeds[idx] && data->taxi_speeds[idx] < min)
+			min = data->taxi_speeds[idx];
+		gcd = min;
+		for (jdx = 0; jdx < ARRAY_SIZE(data->taxi_speeds); jdx++)
+			gcd = sparx5_dsm_exb_gcd(gcd, data->taxi_speeds[jdx]);
+	}
+	if (sum == 0) /* Empty calendar */
+		return 0;
+	/* Make room for overhead traffic */
+	factor = 100 * 100 * 1000 / (100 * 100 - SPX5_DSM_CAL_BW_LOSS);
+
+	if (sum * factor > (taxi_bw * 1000)) {
+		dev_err(sparx5->dev,
+			"Taxi %u, Requested BW %u above available BW %u\n",
+			taxi, sum, taxi_bw);
+		return -EINVAL;
+	}
+	for (idx = 0; idx < 4; idx++) {
+		u32 raw_spd;
+
+		if (idx == 0)
+			raw_spd = gcd / 5;
+		else if (idx == 1)
+			raw_spd = gcd / 2;
+		else if (idx == 2)
+			raw_spd = gcd;
+		else
+			raw_spd = min;
+		slot_spd = raw_spd * factor / 1000;
+		num_of_slots = taxi_bw / slot_spd;
+		if (num_of_slots <= 64)
+			break;
+	}
+
+	num_of_slots = num_of_slots > 64 ? 64 : num_of_slots;
+	slot_spd = taxi_bw / num_of_slots;
+
+	sum = 0;
+	for (idx = 0; idx < ARRAY_SIZE(data->taxi_speeds); idx++) {
+		u32 spd = data->taxi_speeds[idx];
+		u32 adjusted_speed = data->taxi_speeds[idx] * factor / 1000;
+
+		if (adjusted_speed > 0) {
+			data->avg_dist[idx] = (128 * 1000000 * 10) /
+				(adjusted_speed * clk_period_ps);
+		} else {
+			data->avg_dist[idx] = -1;
+		}
+		data->dev_slots[idx] = ((spd * factor / slot_spd) + 999) / 1000;
+		if (spd != 25000 && (spd != 10000 || !slow_mode)) {
+			if (num_of_slots < (5 * data->dev_slots[idx])) {
+				dev_err(sparx5->dev,
+					"Taxi %u, speed %u, Low slot sep.\n",
+					taxi, spd);
+				return -EINVAL;
+			}
+		}
+		sum += data->dev_slots[idx];
+		if (sum > num_of_slots) {
+			dev_err(sparx5->dev,
+				"Taxi %u with overhead factor %u\n",
+				taxi, factor);
+			return -EINVAL;
+		}
+	}
+
+	empty_slots = num_of_slots - sum;
+
+	for (idx = 0; idx < empty_slots; idx++)
+		data->schedule[idx] = SPX5_DSM_CAL_MAX_DEVS_PER_TAXI;
+
+	for (idx = 1; idx < num_of_slots; idx++) {
+		u32 indices_len = 0;
+		u32 slot, jdx, kdx, ts;
+		s32 cnt;
+		u32 num_of_old_slots, num_of_new_slots, tgt_score;
+
+		for (slot = 0; slot < ARRAY_SIZE(data->dev_slots); slot++) {
+			if (data->dev_slots[slot] == idx) {
+				data->indices[indices_len] = slot;
+				indices_len++;
+			}
+		}
+		if (indices_len == 0)
+			continue;
+		kdx = 0;
+		for (slot = 0; slot < idx; slot++) {
+			for (jdx = 0; jdx < indices_len; jdx++, kdx++)
+				data->new_slots[kdx] = data->indices[jdx];
+		}
+
+		for (slot = 0; slot < SPX5_DSM_CAL_LEN; slot++) {
+			if (data->schedule[slot] == SPX5_DSM_CAL_EMPTY)
+				break;
+		}
+
+		num_of_old_slots =  slot;
+		num_of_new_slots =  kdx;
+		cnt = 0;
+		ts = 0;
+
+		if (num_of_new_slots > num_of_old_slots) {
+			memcpy(data->short_list, data->schedule,
+			       sizeof(data->short_list));
+			memcpy(data->long_list, data->new_slots,
+			       sizeof(data->long_list));
+			tgt_score = 100000 * num_of_old_slots /
+				num_of_new_slots;
+		} else {
+			memcpy(data->short_list, data->new_slots,
+			       sizeof(data->short_list));
+			memcpy(data->long_list, data->schedule,
+			       sizeof(data->long_list));
+			tgt_score = 100000 * num_of_new_slots /
+				num_of_old_slots;
+		}
+
+		while (sparx5_dsm_cal_len(data->short_list) > 0 ||
+		       sparx5_dsm_cal_len(data->long_list) > 0) {
+			u32 act = 0;
+
+			if (sparx5_dsm_cal_len(data->short_list) > 0) {
+				data->temp_sched[ts] =
+					sparx5_dsm_cp_cal(data->short_list);
+				ts++;
+				cnt += 100000;
+				act = 1;
+			}
+			while (sparx5_dsm_cal_len(data->long_list) > 0 &&
+			       cnt > 0) {
+				data->temp_sched[ts] =
+					sparx5_dsm_cp_cal(data->long_list);
+				ts++;
+				cnt -= tgt_score;
+				act = 1;
+			}
+			if (act == 0) {
+				dev_err(sparx5->dev,
+					"Error in DSM calendar calculation\n");
+				return -EINVAL;
+			}
+		}
+
+		for (slot = 0; slot < SPX5_DSM_CAL_LEN; slot++) {
+			if (data->temp_sched[slot] == SPX5_DSM_CAL_EMPTY)
+				break;
+		}
+		for (slot = 0; slot < SPX5_DSM_CAL_LEN; slot++) {
+			data->schedule[slot] = data->temp_sched[slot];
+			data->temp_sched[slot] = SPX5_DSM_CAL_EMPTY;
+			data->new_slots[slot] = SPX5_DSM_CAL_EMPTY;
+		}
+	}
+	return 0;
+}
+
+static int sparx5_dsm_calendar_check(struct sparx5 *sparx5,
+				     struct sparx5_calendar_data *data)
+{
+	u32 num_of_slots, idx, port;
+	int cnt, max_dist;
+	u32 slot_indices[SPX5_DSM_CAL_LEN], distances[SPX5_DSM_CAL_LEN];
+	u32 cal_length = sparx5_dsm_cal_len(data->schedule);
+
+	for (port = 0; port < SPX5_DSM_CAL_MAX_DEVS_PER_TAXI; port++) {
+		num_of_slots = 0;
+		max_dist = data->avg_dist[port];
+		for (idx = 0; idx < SPX5_DSM_CAL_LEN; idx++) {
+			slot_indices[idx] = SPX5_DSM_CAL_EMPTY;
+			distances[idx] = SPX5_DSM_CAL_EMPTY;
+		}
+
+		for (idx = 0; idx < cal_length; idx++) {
+			if (data->schedule[idx] == port) {
+				slot_indices[num_of_slots] = idx;
+				num_of_slots++;
+			}
+		}
+
+		slot_indices[num_of_slots] = slot_indices[0] + cal_length;
+
+		for (idx = 0; idx < num_of_slots; idx++) {
+			distances[idx] = (slot_indices[idx + 1] -
+					  slot_indices[idx]) * 10;
+		}
+
+		for (idx = 0; idx < num_of_slots; idx++) {
+			u32 jdx, kdx;
+
+			cnt = distances[idx] - max_dist;
+			if (cnt < 0)
+				cnt = -cnt;
+			kdx = 0;
+			for (jdx = (idx + 1) % num_of_slots;
+			     jdx != idx;
+			     jdx = (jdx + 1) % num_of_slots, kdx++) {
+				cnt =  cnt + distances[jdx] - max_dist;
+				if (cnt < 0)
+					cnt = -cnt;
+				if (cnt > max_dist)
+					goto check_err;
+			}
+		}
+	}
+	return 0;
+check_err:
+	dev_err(sparx5->dev,
+		"Port %u: distance %u above limit %d\n",
+		port, cnt, max_dist);
+	return -EINVAL;
+}
+
+static int sparx5_dsm_calendar_update(struct sparx5 *sparx5, u32 taxi,
+				      struct sparx5_calendar_data *data)
+{
+	u32 idx;
+	u32 cal_len = sparx5_dsm_cal_len(data->schedule), len;
+
+	SPX5_WR(DSM_TAXI_CAL_CFG_CAL_PGM_ENA_SET(1),
+		sparx5,
+		DSM_TAXI_CAL_CFG(taxi));
+	for (idx = 0; idx < cal_len; idx++) {
+		SPX5_RMW(DSM_TAXI_CAL_CFG_CAL_IDX_SET(idx),
+			 DSM_TAXI_CAL_CFG_CAL_IDX,
+			 sparx5,
+			 DSM_TAXI_CAL_CFG(taxi));
+		SPX5_RMW(DSM_TAXI_CAL_CFG_CAL_PGM_VAL_SET(data->schedule[idx]),
+			 DSM_TAXI_CAL_CFG_CAL_PGM_VAL,
+			 sparx5,
+			 DSM_TAXI_CAL_CFG(taxi));
+	}
+	SPX5_WR(DSM_TAXI_CAL_CFG_CAL_PGM_ENA_SET(0),
+		sparx5,
+		DSM_TAXI_CAL_CFG(taxi));
+	len = DSM_TAXI_CAL_CFG_CAL_CUR_LEN_GET(SPX5_RD(sparx5,
+						       DSM_TAXI_CAL_CFG(taxi)));
+	if (len != cal_len - 1)
+		goto update_err;
+	return 0;
+update_err:
+	dev_err(sparx5->dev, "Incorrect calendar length: %u\n", len);
+	return -EINVAL;
+}
+
+/* Configure the DSM calendar based on port configuration */
+int sparx5_config_dsm_calendar(struct sparx5 *sparx5)
+{
+	int taxi;
+	struct sparx5_calendar_data *data;
+	int err = 0;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	for (taxi = 0; taxi < SPX5_DSM_CAL_TAXIS; ++taxi) {
+		err = sparx5_dsm_calendar_calc(sparx5, taxi, data);
+		if (err) {
+			dev_err(sparx5->dev, "DSM calendar calculation failed\n");
+			goto cal_out;
+		}
+		err = sparx5_dsm_calendar_check(sparx5, data);
+		if (err) {
+			dev_err(sparx5->dev, "DSM calendar check failed\n");
+			goto cal_out;
+		}
+		err = sparx5_dsm_calendar_update(sparx5, taxi, data);
+		if (err) {
+			dev_err(sparx5->dev, "DSM calendar update failed\n");
+			goto cal_out;
+		}
+	}
+cal_out:
+	kfree(data);
+	return err;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_common.h b/drivers/net/ethernet/microchip/sparx5/sparx5_common.h
new file mode 100644
index 000000000000..be9e36a1f7b1
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_common.h
@@ -0,0 +1,162 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_COMMON_H__
+#define __SPARX5_COMMON_H__
+
+#include <linux/types.h>
+#include <linux/io.h>
+#include <linux/bug.h>
+
+/* Calculate raw offset */
+static inline __pure
+int spx5_offset(int id, int tinst, int tcnt,
+		int gbase, int ginst,
+		int gcnt, int gwidth,
+		int raddr, int rinst,
+		int rcnt, int rwidth)
+{
+#if defined(CONFIG_DEBUG_KERNEL)
+	WARN_ON((tinst) >= tcnt);
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+#endif
+
+	return gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+/* Read, Write and modify registers content.
+ * The register definition macros start at the id
+ */
+static inline void __iomem *spx5_addr(void __iomem *base[],
+				      int id, int tinst, int tcnt,
+				      int gbase, int ginst,
+				      int gcnt, int gwidth,
+				      int raddr, int rinst,
+				      int rcnt, int rwidth)
+{
+#if defined(CONFIG_DEBUG_KERNEL)
+	WARN_ON((tinst) >= tcnt);
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+#endif
+	return base[id + (tinst)] +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+static inline void __iomem *spx5_inst_addr(void __iomem *base,
+					   int gbase, int ginst,
+					   int gcnt, int gwidth,
+					   int raddr, int rinst,
+					   int rcnt, int rwidth)
+{
+#if defined(CONFIG_DEBUG_KERNEL)
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+#endif
+	return base +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+#define SPX5_RD_(sparx5, id, tinst, tcnt,			\
+		 gbase, ginst, gcnt, gwidth,			\
+		 raddr, rinst, rcnt, rwidth)			\
+	readl(spx5_addr((sparx5)->regs, id, tinst, tcnt,	\
+			gbase, ginst, gcnt, gwidth,             \
+			raddr, rinst, rcnt, rwidth))
+
+#define SPX5_INST_RD_(iomem, id, tinst, tcnt,			\
+		      gbase, ginst, gcnt, gwidth,		\
+		      raddr, rinst, rcnt, rwidth)		\
+	readl(spx5_inst_addr(iomem,				\
+			     gbase, ginst, gcnt, gwidth,	\
+			     raddr, rinst, rcnt, rwidth))
+
+#define SPX5_WR_(val, sparx5, id, tinst, tcnt,			\
+		 gbase, ginst, gcnt, gwidth,			\
+		 raddr, rinst, rcnt, rwidth)			\
+	writel(val, spx5_addr((sparx5)->regs, id, tinst, tcnt,	\
+			      gbase, ginst, gcnt, gwidth,	\
+			      raddr, rinst, rcnt, rwidth))
+
+#define SPX5_INST_WR_(val, iomem, id, tinst, tcnt,		\
+		      gbase, ginst, gcnt, gwidth,		\
+		      raddr, rinst, rcnt, rwidth)		\
+	writel(val, spx5_inst_addr(iomem,			\
+				   gbase, ginst, gcnt, gwidth,	\
+				   raddr, rinst, rcnt, rwidth))
+
+#define SPX5_RMW_(val, mask, sparx5, id, tinst, tcnt,			\
+		  gbase, ginst, gcnt, gwidth,				\
+		  raddr, rinst, rcnt, rwidth)				\
+	do {								\
+		u32 _v_;						\
+		u32 _m_ = mask;						\
+		void __iomem *addr =					\
+			spx5_addr((sparx5)->regs, id, tinst, tcnt,	\
+				  gbase, ginst, gcnt, gwidth,		\
+				  raddr, rinst, rcnt, rwidth);		\
+		_v_ = readl(addr);					\
+		_v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));		\
+		writel(_v_, addr);					\
+	} while (0)
+
+#define SPX5_INST_RMW_(val, mask, iomem, id, tinst, tcnt,		\
+		       gbase, ginst, gcnt, gwidth,			\
+		       raddr, rinst, rcnt, rwidth)			\
+	do {								\
+		u32 _v_;						\
+		u32 _m_ = mask;						\
+		void __iomem *addr =					\
+			spx5_inst_addr(iomem,				\
+				       gbase, ginst, gcnt, gwidth,	\
+				       raddr, rinst, rcnt, rwidth);	\
+		_v_ = readl(addr);					\
+		_v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));		\
+		writel(_v_, addr);					\
+	} while (0)
+
+#define SPX5_REG_RD_(regaddr)			\
+	readl(regaddr)
+
+#define SPX5_REG_WR_(val, regaddr)		\
+	writel(val, regaddr)
+
+#define SPX5_REG_RMW_(val, mask, regaddr)		    \
+	do {						    \
+		u32 _v_;                                    \
+		u32 _m_ = mask;				    \
+		void __iomem *_r_ = regaddr;		    \
+		_v_ = readl(_r_);			    \
+		_v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));   \
+		writel(_v_, _r_);			    \
+	} while (0)
+
+#define SPX5_REG_GET_(sparx5, id, tinst, tcnt,			\
+		      gbase, ginst, gcnt, gwidth,		\
+		      raddr, rinst, rcnt, rwidth)		\
+	spx5_addr((sparx5)->regs, id, tinst, tcnt,		\
+		  gbase, ginst, gcnt, gwidth,			\
+		  raddr, rinst, rcnt, rwidth)
+
+#define SPX5_RD(...)  SPX5_RD_(__VA_ARGS__)
+#define SPX5_WR(...)  SPX5_WR_(__VA_ARGS__)
+#define SPX5_RMW(...) SPX5_RMW_(__VA_ARGS__)
+#define SPX5_INST_RD(...) SPX5_INST_RD_(__VA_ARGS__)
+#define SPX5_INST_WR(...) SPX5_INST_WR_(__VA_ARGS__)
+#define SPX5_INST_RMW(...) SPX5_INST_RMW_(__VA_ARGS__)
+#define SPX5_INST_GET(sparx5, id, tinst) ((sparx5)->regs[(id) + (tinst)])
+#define SPX5_REG_RMW(...) SPX5_REG_RMW_(__VA_ARGS__)
+#define SPX5_REG_WR(...) SPX5_REG_WR_(__VA_ARGS__)
+#define SPX5_REG_RD(...) SPX5_REG_RD_(__VA_ARGS__)
+#define SPX5_REG_GET(...) SPX5_REG_GET_(__VA_ARGS__)
+
+#define SPEED_12500                  12500
+
+#endif
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
new file mode 100644
index 000000000000..a91dd9532f1c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -0,0 +1,1027 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/ethtool.h>
+
+#include "sparx5_main.h"
+#include "sparx5_port.h"
+
+/* Add a potentially wrapping 32 bit value to a 64 bit counter */
+static inline void sparx5_update_counter(u64 *cnt, u32 val)
+{
+	if (val < (*cnt & U32_MAX))
+		*cnt += (u64)1 << 32; /* value has wrapped */
+
+	*cnt = (*cnt & ~(u64)U32_MAX) + val;
+}
+
+/* Get a set of Queue System statistics */
+static void sparx5_xqs_prio_stats(struct sparx5 *sparx5,
+				  u32 addr,
+				  u64 *stats)
+{
+	int idx;
+
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++addr, ++stats)
+		sparx5_update_counter(stats, SPX5_RD(sparx5, XQS_CNT(addr)));
+}
+
+#define SPX5_STAT_GET(sname)        portstats[spx5_stats_##sname]
+#define SPX5_STAT_SUM(sname)        (portstats[spx5_stats_##sname] + \
+				     portstats[spx5_stats_pmac_##sname])
+#define SPX5_STAT_XQS_PRIOS_COUNTER_SUM(sname)    \
+	(portstats[spx5_stats_green_p0_##sname] + \
+	portstats[spx5_stats_green_p1_##sname] +  \
+	portstats[spx5_stats_green_p2_##sname] +  \
+	portstats[spx5_stats_green_p3_##sname] +  \
+	portstats[spx5_stats_green_p4_##sname] +  \
+	portstats[spx5_stats_green_p5_##sname] +  \
+	portstats[spx5_stats_green_p6_##sname] +  \
+	portstats[spx5_stats_green_p7_##sname] +  \
+	portstats[spx5_stats_yellow_p0_##sname] + \
+	portstats[spx5_stats_yellow_p1_##sname] + \
+	portstats[spx5_stats_yellow_p2_##sname] + \
+	portstats[spx5_stats_yellow_p3_##sname] + \
+	portstats[spx5_stats_yellow_p4_##sname] + \
+	portstats[spx5_stats_yellow_p5_##sname] + \
+	portstats[spx5_stats_yellow_p6_##sname] + \
+	portstats[spx5_stats_yellow_p7_##sname])
+
+enum sparx5_stats_entry {
+	spx5_stats_rx_in_bytes,
+	spx5_stats_rx_symbol_err,
+	spx5_stats_rx_pause,
+	spx5_stats_rx_unsup_opcode,
+	spx5_stats_rx_ok_bytes,
+	spx5_stats_rx_bad_bytes,
+	spx5_stats_rx_unicast,
+	spx5_stats_rx_multicast,
+	spx5_stats_rx_broadcast,
+	spx5_stats_rx_crc_err,
+	spx5_stats_rx_undersize,
+	spx5_stats_rx_fragments,
+	spx5_stats_rx_inrangelen_err,
+	spx5_stats_rx_outofrangelen_err,
+	spx5_stats_rx_oversize,
+	spx5_stats_rx_jabbers,
+	spx5_stats_rx_size64,
+	spx5_stats_rx_size65_127,
+	spx5_stats_rx_size128_255,
+	spx5_stats_rx_size256_511,
+	spx5_stats_rx_size512_1023,
+	spx5_stats_rx_size1024_1518,
+	spx5_stats_rx_size1519_max,
+	spx5_stats_pmac_rx_symbol_err,
+	spx5_stats_pmac_rx_pause,
+	spx5_stats_pmac_rx_unsup_opcode,
+	spx5_stats_pmac_rx_ok_bytes,
+	spx5_stats_pmac_rx_bad_bytes,
+	spx5_stats_pmac_rx_unicast,
+	spx5_stats_pmac_rx_multicast,
+	spx5_stats_pmac_rx_broadcast,
+	spx5_stats_pmac_rx_crc_err,
+	spx5_stats_pmac_rx_undersize,
+	spx5_stats_pmac_rx_fragments,
+	spx5_stats_pmac_rx_inrangelen_err,
+	spx5_stats_pmac_rx_outofrangelen_err,
+	spx5_stats_pmac_rx_oversize,
+	spx5_stats_pmac_rx_jabbers,
+	spx5_stats_pmac_rx_size64,
+	spx5_stats_pmac_rx_size65_127,
+	spx5_stats_pmac_rx_size128_255,
+	spx5_stats_pmac_rx_size256_511,
+	spx5_stats_pmac_rx_size512_1023,
+	spx5_stats_pmac_rx_size1024_1518,
+	spx5_stats_pmac_rx_size1519_max,
+	spx5_stats_green_p0_rx_fwd,
+	spx5_stats_green_p1_rx_fwd,
+	spx5_stats_green_p2_rx_fwd,
+	spx5_stats_green_p3_rx_fwd,
+	spx5_stats_green_p4_rx_fwd,
+	spx5_stats_green_p5_rx_fwd,
+	spx5_stats_green_p6_rx_fwd,
+	spx5_stats_green_p7_rx_fwd,
+	spx5_stats_yellow_p0_rx_fwd,
+	spx5_stats_yellow_p1_rx_fwd,
+	spx5_stats_yellow_p2_rx_fwd,
+	spx5_stats_yellow_p3_rx_fwd,
+	spx5_stats_yellow_p4_rx_fwd,
+	spx5_stats_yellow_p5_rx_fwd,
+	spx5_stats_yellow_p6_rx_fwd,
+	spx5_stats_yellow_p7_rx_fwd,
+	spx5_stats_green_p0_rx_port_drop,
+	spx5_stats_green_p1_rx_port_drop,
+	spx5_stats_green_p2_rx_port_drop,
+	spx5_stats_green_p3_rx_port_drop,
+	spx5_stats_green_p4_rx_port_drop,
+	spx5_stats_green_p5_rx_port_drop,
+	spx5_stats_green_p6_rx_port_drop,
+	spx5_stats_green_p7_rx_port_drop,
+	spx5_stats_yellow_p0_rx_port_drop,
+	spx5_stats_yellow_p1_rx_port_drop,
+	spx5_stats_yellow_p2_rx_port_drop,
+	spx5_stats_yellow_p3_rx_port_drop,
+	spx5_stats_yellow_p4_rx_port_drop,
+	spx5_stats_yellow_p5_rx_port_drop,
+	spx5_stats_yellow_p6_rx_port_drop,
+	spx5_stats_yellow_p7_rx_port_drop,
+	spx5_stats_rx_local_drop,
+	spx5_stats_rx_port_policer_drop,
+	spx5_stats_tx_out_bytes,
+	spx5_stats_tx_pause,
+	spx5_stats_tx_ok_bytes,
+	spx5_stats_tx_unicast,
+	spx5_stats_tx_multicast,
+	spx5_stats_tx_broadcast,
+	spx5_stats_tx_size64,
+	spx5_stats_tx_size65_127,
+	spx5_stats_tx_size128_255,
+	spx5_stats_tx_size256_511,
+	spx5_stats_tx_size512_1023,
+	spx5_stats_tx_size1024_1518,
+	spx5_stats_tx_size1519_max,
+	spx5_stats_tx_multi_coll,
+	spx5_stats_tx_late_coll,
+	spx5_stats_tx_xcoll,
+	spx5_stats_tx_defer,
+	spx5_stats_tx_xdefer,
+	spx5_stats_tx_backoff1,
+	spx5_stats_pmac_tx_pause,
+	spx5_stats_pmac_tx_ok_bytes,
+	spx5_stats_pmac_tx_unicast,
+	spx5_stats_pmac_tx_multicast,
+	spx5_stats_pmac_tx_broadcast,
+	spx5_stats_pmac_tx_size64,
+	spx5_stats_pmac_tx_size65_127,
+	spx5_stats_pmac_tx_size128_255,
+	spx5_stats_pmac_tx_size256_511,
+	spx5_stats_pmac_tx_size512_1023,
+	spx5_stats_pmac_tx_size1024_1518,
+	spx5_stats_pmac_tx_size1519_max,
+	spx5_stats_green_p0_tx_port,
+	spx5_stats_green_p1_tx_port,
+	spx5_stats_green_p2_tx_port,
+	spx5_stats_green_p3_tx_port,
+	spx5_stats_green_p4_tx_port,
+	spx5_stats_green_p5_tx_port,
+	spx5_stats_green_p6_tx_port,
+	spx5_stats_green_p7_tx_port,
+	spx5_stats_yellow_p0_tx_port,
+	spx5_stats_yellow_p1_tx_port,
+	spx5_stats_yellow_p2_tx_port,
+	spx5_stats_yellow_p3_tx_port,
+	spx5_stats_yellow_p4_tx_port,
+	spx5_stats_yellow_p5_tx_port,
+	spx5_stats_yellow_p6_tx_port,
+	spx5_stats_yellow_p7_tx_port,
+	spx5_stats_tx_local_drop,
+};
+
+static const char *const sparx5_stats_layout[] = {
+	"rx_in_bytes",
+	"rx_symbol_err",
+	"rx_pause",
+	"rx_unsup_opcode",
+	"rx_ok_bytes",
+	"rx_bad_bytes",
+	"rx_unicast",
+	"rx_multicast",
+	"rx_broadcast",
+	"rx_crc_err",
+	"rx_undersize",
+	"rx_fragments",
+	"rx_inrangelen_err",
+	"rx_outofrangelen_err",
+	"rx_oversize",
+	"rx_jabbers",
+	"rx_size64",
+	"rx_size65_127",
+	"rx_size128_255",
+	"rx_size256_511",
+	"rx_size512_1023",
+	"rx_size1024_1518",
+	"rx_size1519_max",
+	"pmac_rx_symbol_err",
+	"pmac_rx_pause",
+	"pmac_rx_unsup_opcode",
+	"pmac_rx_ok_bytes",
+	"pmac_rx_bad_bytes",
+	"pmac_rx_unicast",
+	"pmac_rx_multicast",
+	"pmac_rx_broadcast",
+	"pmac_rx_crc_err",
+	"pmac_rx_undersize",
+	"pmac_rx_fragments",
+	"pmac_rx_inrangelen_err",
+	"pmac_rx_outofrangelen_err",
+	"pmac_rx_oversize",
+	"pmac_rx_jabbers",
+	"pmac_rx_size64",
+	"pmac_rx_size65_127",
+	"pmac_rx_size128_255",
+	"pmac_rx_size256_511",
+	"pmac_rx_size512_1023",
+	"pmac_rx_size1024_1518",
+	"pmac_rx_size1519_max",
+	"rx_fwd_green_p0_q",
+	"rx_fwd_green_p1_q",
+	"rx_fwd_green_p2_q",
+	"rx_fwd_green_p3_q",
+	"rx_fwd_green_p4_q",
+	"rx_fwd_green_p5_q",
+	"rx_fwd_green_p6_q",
+	"rx_fwd_green_p7_q",
+	"rx_fwd_yellow_p0_q",
+	"rx_fwd_yellow_p1_q",
+	"rx_fwd_yellow_p2_q",
+	"rx_fwd_yellow_p3_q",
+	"rx_fwd_yellow_p4_q",
+	"rx_fwd_yellow_p5_q",
+	"rx_fwd_yellow_p6_q",
+	"rx_fwd_yellow_p7_q",
+	"rx_port_drop_green_p0_q",
+	"rx_port_drop_green_p1_q",
+	"rx_port_drop_green_p2_q",
+	"rx_port_drop_green_p3_q",
+	"rx_port_drop_green_p4_q",
+	"rx_port_drop_green_p5_q",
+	"rx_port_drop_green_p6_q",
+	"rx_port_drop_green_p7_q",
+	"rx_port_drop_yellow_p0_q",
+	"rx_port_drop_yellow_p1_q",
+	"rx_port_drop_yellow_p2_q",
+	"rx_port_drop_yellow_p3_q",
+	"rx_port_drop_yellow_p4_q",
+	"rx_port_drop_yellow_p5_q",
+	"rx_port_drop_yellow_p6_q",
+	"rx_port_drop_yellow_p7_q",
+	"rx_local_drop",
+	"rx_port_policer_drop",
+	"tx_out_bytes",
+	"tx_pause",
+	"tx_ok_bytes",
+	"tx_unicast",
+	"tx_multicast",
+	"tx_broadcast",
+	"tx_size64",
+	"tx_size65_127",
+	"tx_size128_255",
+	"tx_size256_511",
+	"tx_size512_1023",
+	"tx_size1024_1518",
+	"tx_size1519_max",
+	"tx_multi_coll",
+	"tx_late_coll",
+	"tx_xcoll",
+	"tx_defer",
+	"tx_xdefer",
+	"tx_backoff1",
+	"pmac_tx_pause",
+	"pmac_tx_ok_bytes",
+	"pmac_tx_unicast",
+	"pmac_tx_multicast",
+	"pmac_tx_broadcast",
+	"pmac_tx_size64",
+	"pmac_tx_size65_127",
+	"pmac_tx_size128_255",
+	"pmac_tx_size256_511",
+	"pmac_tx_size512_1023",
+	"pmac_tx_size1024_1518",
+	"pmac_tx_size1519_max",
+	"tx_port_green_p0_q",
+	"tx_port_green_p1_q",
+	"tx_port_green_p2_q",
+	"tx_port_green_p3_q",
+	"tx_port_green_p4_q",
+	"tx_port_green_p5_q",
+	"tx_port_green_p6_q",
+	"tx_port_green_p7_q",
+	"tx_port_yellow_p0_q",
+	"tx_port_yellow_p1_q",
+	"tx_port_yellow_p2_q",
+	"tx_port_yellow_p3_q",
+	"tx_port_yellow_p4_q",
+	"tx_port_yellow_p5_q",
+	"tx_port_yellow_p6_q",
+	"tx_port_yellow_p7_q",
+	"tx_local_drop",
+};
+
+/* Device Statistics */
+static void sparx5_get_device_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+	u32 dev = sparx5_to_high_dev(portno);
+	u32 tinst = sparx5_port_dev_index(portno);
+	void __iomem *inst = SPX5_INST_GET(sparx5, dev, tinst);
+
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_IN_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_symbol_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SYMBOL_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_pause],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unsup_opcode],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bad_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_BAD_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_multicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_broadcast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_crc_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_CRC_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_undersize],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_UNDERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_fragments],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_FRAGMENTS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_inrangelen_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_IN_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_outofrangelen_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_OUT_OF_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_jabbers],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_JABBERS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size64],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size65_127],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size128_255],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size256_511],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   DEV5G_RX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_symbol_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SYMBOL_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_pause],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unsup_opcode],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bad_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_BAD_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_multicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_broadcast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_crc_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_CRC_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_undersize],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_UNDERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_fragments],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_FRAGMENTS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_inrangelen_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_IN_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_outofrangelen_err],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_jabbers],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_JABBERS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size64],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size65_127],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size128_255],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size256_511],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_RX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_xqs_prio_stats(sparx5,
+			      0,
+			      &portstats[spx5_stats_green_p0_rx_fwd]);
+	sparx5_xqs_prio_stats(sparx5,
+			      16,
+			      &portstats[spx5_stats_green_p0_rx_port_drop]);
+	sparx5_update_counter(&portstats[spx5_stats_rx_local_drop],
+			      SPX5_RD(sparx5, XQS_CNT(32)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_port_policer_drop],
+			      SPX5_RD(sparx5,
+				      ANA_AC_PORT_STAT_LSB_CNT(portno, 1)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_out_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_OUT_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_pause],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_unicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_broadcast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size64],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size65_127],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size128_255],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size256_511],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   DEV5G_TX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_pause],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_unicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_multicast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_broadcast],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size64],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size65_127],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size128_255],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size256_511],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   DEV5G_PMAC_TX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_xqs_prio_stats(sparx5,
+			      256,
+			      &portstats[spx5_stats_green_p0_tx_port]);
+	sparx5_update_counter(&portstats[spx5_stats_tx_local_drop],
+			      SPX5_RD(sparx5, XQS_CNT(272)));
+}
+
+/* ASM Statistics */
+static void sparx5_get_asm_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+	u32 dev = TARGET_ASM;
+	void __iomem *inst = SPX5_INST_GET(sparx5, dev, 0);
+
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_IN_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_symbol_err],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SYMBOL_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_pause],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unsup_opcode],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_UNSUP_OPCODE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bad_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_BAD_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unicast],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_multicast],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_broadcast],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_crc_err],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_CRC_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_undersize],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_UNDERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_fragments],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_FRAGMENTS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_inrangelen_err],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_IN_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_outofrangelen_err],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_OUT_OF_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_jabbers],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_JABBERS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size64],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size65_127],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size128_255],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size256_511],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   ASM_RX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_symbol_err],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SYMBOL_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_pause],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unsup_opcode],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_UNSUP_OPCODE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bad_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_BAD_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unicast],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_multicast],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_broadcast],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_crc_err],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_CRC_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_undersize],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_UNDERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_fragments],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_FRAGMENTS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_inrangelen_err],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_IN_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_outofrangelen_err],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_jabbers],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_JABBERS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size64],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size65_127],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size128_255],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size256_511],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_RX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_xqs_prio_stats(sparx5,
+			      0,
+			      &portstats[spx5_stats_green_p0_rx_fwd]);
+	sparx5_xqs_prio_stats(sparx5,
+			      16,
+			      &portstats[spx5_stats_green_p0_rx_port_drop]);
+	sparx5_update_counter(&portstats[spx5_stats_rx_local_drop],
+			      SPX5_RD(sparx5, XQS_CNT(32)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_port_policer_drop],
+			      SPX5_RD(sparx5,
+				      ANA_AC_PORT_STAT_LSB_CNT(portno, 1)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_out_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_OUT_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_pause],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_unicast],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multicast],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_broadcast],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size64],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size65_127],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size128_255],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size256_511],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multi_coll],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_MULTI_COLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_late_coll],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_LATE_COLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_xcoll],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_XCOLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_defer],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_DEFER_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_xdefer],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_XDEFER_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_backoff1],
+			      SPX5_INST_RD(inst,
+					   ASM_TX_BACKOFF1_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_pause],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_ok_bytes],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_unicast],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_multicast],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_broadcast],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size64],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size65_127],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size128_255],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size256_511],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size512_1023],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1024_1518],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1519_max],
+			      SPX5_INST_RD(inst,
+					   ASM_PMAC_TX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_xqs_prio_stats(sparx5,
+			      256,
+			      &portstats[spx5_stats_green_p0_tx_port]);
+	sparx5_update_counter(&portstats[spx5_stats_tx_local_drop],
+			      SPX5_RD(sparx5, XQS_CNT(272)));
+}
+
+/* CPU Port Queue Statistics */
+static void sparx5_get_cpu_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+
+	sparx5_xqs_prio_stats(sparx5,
+			      0,
+			      &portstats[spx5_stats_green_p0_rx_fwd]);
+	sparx5_xqs_prio_stats(sparx5,
+			      16,
+			      &portstats[spx5_stats_green_p0_rx_port_drop]);
+	sparx5_update_counter(&portstats[spx5_stats_rx_local_drop],
+			      SPX5_RD(sparx5, XQS_CNT(32)));
+	sparx5_xqs_prio_stats(sparx5,
+			      256,
+			      &portstats[spx5_stats_green_p0_tx_port]);
+	sparx5_update_counter(&portstats[spx5_stats_tx_local_drop],
+			      SPX5_RD(sparx5, XQS_CNT(272)));
+}
+
+static void sparx5_update_port_stats(struct sparx5 *sparx5, int portno)
+{
+	struct sparx5_port *spx5_port = sparx5->ports[portno];
+	bool high_speed_dev = sparx5_is_high_speed_device(&spx5_port->conf);
+
+	/* Set XQS port number */
+	SPX5_WR(XQS_STAT_CFG_STAT_VIEW_SET(portno), sparx5, XQS_STAT_CFG);
+	if (high_speed_dev)
+		sparx5_get_device_stats(sparx5, portno);
+	else
+		sparx5_get_asm_stats(sparx5, portno);
+}
+
+bool sparx5_is_cpuport_stat(struct sparx5 *sparx5, int idx)
+{
+	return ((idx >= spx5_stats_green_p0_rx_fwd &&
+		 idx <= spx5_stats_rx_port_policer_drop) ||
+			(idx >= spx5_stats_green_p0_tx_port &&
+			 idx <= spx5_stats_tx_local_drop));
+}
+
+void sparx5_update_cpuport_stats(struct sparx5 *sparx5, int portno)
+{
+	mutex_lock(&sparx5->stats_lock);
+	/* Set XQS port number */
+	SPX5_WR(XQS_STAT_CFG_STAT_VIEW_SET(portno), sparx5, XQS_STAT_CFG);
+	/* Use XQS counters only */
+	sparx5_get_cpu_stats(sparx5, portno);
+	mutex_unlock(&sparx5->stats_lock);
+}
+
+static void sparx5_update_stats(struct sparx5 *sparx5)
+{
+	int idx;
+
+	mutex_lock(&sparx5->stats_lock);
+	for (idx = 0; idx < SPX5_PORTS; idx++)
+		if (sparx5->ports[idx])
+			sparx5_update_port_stats(sparx5, idx);
+	mutex_unlock(&sparx5->stats_lock);
+}
+
+static void sparx5_check_stats_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct sparx5 *sparx5 = container_of(dwork, struct sparx5,
+					     stats_work);
+
+	sparx5_update_stats(sparx5);
+
+	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
+			   SPX5_STATS_CHECK_DELAY);
+}
+
+static int sparx5_get_sset_count(struct net_device *ndev, int sset)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+	return sparx5->num_stats;
+}
+
+static void sparx5_get_sset_strings(struct net_device *ndev, u32 sset, u8 *data)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+	int idx;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (idx = 0; idx < sparx5->num_stats; idx++)
+		memcpy(data + idx * ETH_GSTRING_LEN,
+		       sparx5->stats_layout[idx], ETH_GSTRING_LEN);
+}
+
+static void sparx5_get_stats(struct net_device *ndev,
+			     struct ethtool_stats *stats, u64 *data)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+	u64 *portstats = &sparx5->stats[port->portno * sparx5->num_stats];
+	int idx;
+
+	/* check and update now (all ports) */
+	sparx5_update_stats(sparx5);
+
+	/* Copy port counters to the ethtool buffer */
+	for (idx = 0; idx < sparx5->num_stats; idx++)
+		*data++ = portstats[idx];
+}
+
+void sparx5_get_stats64(struct net_device *ndev,
+			struct rtnl_link_stats64 *stats)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u64 *portstats;
+
+	if (!sparx5->stats)
+		return;		/* Not initialized yet */
+
+	portstats = &sparx5->stats[port->portno * sparx5->num_stats];
+
+	mutex_lock(&sparx5->stats_lock);
+
+	stats->rx_errors = SPX5_STAT_SUM(rx_crc_err) +
+		SPX5_STAT_SUM(rx_undersize) + SPX5_STAT_SUM(rx_oversize) +
+		SPX5_STAT_SUM(rx_outofrangelen_err) +
+		SPX5_STAT_SUM(rx_symbol_err) + SPX5_STAT_SUM(rx_jabbers) +
+		SPX5_STAT_SUM(rx_fragments);
+
+	stats->rx_bytes = SPX5_STAT_SUM(rx_ok_bytes) +
+		SPX5_STAT_SUM(rx_bad_bytes);
+
+	stats->rx_packets = SPX5_STAT_SUM(rx_unicast) +
+		SPX5_STAT_SUM(rx_multicast) + SPX5_STAT_SUM(rx_broadcast) +
+		stats->rx_errors;
+
+	stats->multicast = SPX5_STAT_SUM(rx_unicast);
+
+	stats->rx_dropped = SPX5_STAT_GET(rx_port_policer_drop) +
+		SPX5_STAT_XQS_PRIOS_COUNTER_SUM(rx_port_drop);
+
+	/* Get Tx stats */
+	stats->tx_bytes = SPX5_STAT_SUM(tx_ok_bytes);
+
+	stats->tx_packets = SPX5_STAT_SUM(tx_unicast) +
+		SPX5_STAT_SUM(tx_multicast) + SPX5_STAT_SUM(tx_broadcast);
+
+	stats->tx_dropped = SPX5_STAT_GET(tx_local_drop);
+
+	stats->collisions = SPX5_STAT_GET(tx_multi_coll) +
+		SPX5_STAT_GET(tx_late_coll) +
+		SPX5_STAT_GET(tx_xcoll) +
+		SPX5_STAT_GET(tx_backoff1);
+
+	mutex_unlock(&sparx5->stats_lock);
+}
+
+static int sparx5_get_link_settings(struct net_device *ndev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(port->phylink, cmd);
+}
+
+static u32 sparx5_get_link(struct net_device *dev)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5_port_status status;
+
+	sparx5_get_port_status(port->sparx5, port, &status);
+	return (status.serdes_link && status.link);
+}
+
+static int sparx5_set_link_settings(struct net_device *ndev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(port->phylink, cmd);
+}
+
+const struct ethtool_ops sparx5_ethtool_ops = {
+	.get_sset_count         = sparx5_get_sset_count,
+	.get_strings            = sparx5_get_sset_strings,
+	.get_ethtool_stats      = sparx5_get_stats,
+	.get_link_ksettings	= sparx5_get_link_settings,
+	.set_link_ksettings	= sparx5_set_link_settings,
+	.get_link               = sparx5_get_link,
+};
+
+int sparx_stats_init(struct sparx5 *sparx5)
+{
+	char queue_name[32];
+	int portno;
+
+	sparx5->stats_layout = sparx5_stats_layout;
+	sparx5->num_stats = ARRAY_SIZE(sparx5_stats_layout);
+	sparx5->stats = devm_kcalloc(sparx5->dev,
+				     SPX5_PORTS_ALL * sparx5->num_stats,
+				     sizeof(u64), GFP_KERNEL);
+	if (!sparx5->stats)
+		return -ENOMEM;
+
+	for (portno = 0; portno < SPX5_PORTS; portno++)
+		if (sparx5->ports[portno]) {
+			/* Clear Queue System counters */
+			SPX5_WR(XQS_STAT_CFG_STAT_VIEW_SET(portno) |
+				XQS_STAT_CFG_STAT_CLEAR_SHOT_SET(3), sparx5, XQS_STAT_CFG);
+		}
+
+	mutex_init(&sparx5->stats_lock);
+	snprintf(queue_name, sizeof(queue_name), "%s-stats",
+		 dev_name(sparx5->dev));
+	sparx5->stats_queue = create_singlethread_workqueue(queue_name);
+	INIT_DELAYED_WORK(&sparx5->stats_work, sparx5_check_stats_work);
+	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
+			   SPX5_STATS_CHECK_DELAY);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
new file mode 100644
index 000000000000..2c207272482a
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -0,0 +1,510 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <net/switchdev.h>
+#include <linux/iopoll.h>
+
+#include "sparx5_main.h"
+
+/* Commands for Mac Table Command register */
+#define MAC_CMD_LEARN         0 /* Insert (Learn) 1 entry */
+#define MAC_CMD_UNLEARN       1 /* Unlearn (Forget) 1 entry */
+#define MAC_CMD_LOOKUP        2 /* Look up 1 entry */
+#define MAC_CMD_READ          3 /* Read entry at Mac Table Index */
+#define MAC_CMD_WRITE         4 /* Write entry at Mac Table Index */
+#define MAC_CMD_SCAN          5 /* Scan (Age or find next) */
+#define MAC_CMD_FIND_SMALLEST 6 /* Get next entry */
+#define MAC_CMD_CLEAR_ALL     7 /* Delete all entries in table */
+
+/* Commands for MAC_ENTRY_ADDR_TYPE */
+#define  MAC_ENTRY_ADDR_TYPE_UPSID_PN         0
+#define  MAC_ENTRY_ADDR_TYPE_UPSID_CPU_OR_INT 1
+#define  MAC_ENTRY_ADDR_TYPE_GLAG             2
+#define  MAC_ENTRY_ADDR_TYPE_MC_IDX           3
+
+#define TABLE_UPDATE_SLEEP_US 10
+#define TABLE_UPDATE_TIMEOUT_US 100000
+
+struct sparx5_mact_entry {
+	struct list_head list;
+	unsigned char mac[ETH_ALEN];
+	u32 flags;
+#define MAC_ENT_ALIVE	BIT(0)
+#define MAC_ENT_MOVED	BIT(1)
+#define MAC_ENT_LOCK	BIT(1)
+	u16 vid;
+	u16 port;
+};
+
+static void sparx5_hw_lock(struct sparx5 *sparx5)
+{
+	mutex_lock(&sparx5->lock);
+}
+
+static void sparx5_hw_unlock(struct sparx5 *sparx5)
+{
+	mutex_unlock(&sparx5->lock);
+}
+
+static inline int sparx5_mact_get_status(struct sparx5 *sparx5)
+{
+	return SPX5_RD(sparx5, LRN_COMMON_ACCESS_CTRL);
+}
+
+static inline int sparx5_mact_wait_for_completion(struct sparx5 *sparx5)
+{
+	u32 val;
+
+	return readx_poll_timeout(sparx5_mact_get_status,
+		sparx5, val,
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_GET(val) == 0,
+		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
+}
+
+static void sparx5_mact_select(struct sparx5 *sparx5,
+			       const unsigned char mac[ETH_ALEN],
+			       u16 vid)
+{
+	u32 macl = 0, mach = 0;
+
+	/* Set the MAC address to handle and the vlan associated in a format
+	 * understood by the hardware.
+	 */
+	mach |= vid    << 16;
+	mach |= mac[0] << 8;
+	mach |= mac[1] << 0;
+	macl |= mac[2] << 24;
+	macl |= mac[3] << 16;
+	macl |= mac[4] << 8;
+	macl |= mac[5] << 0;
+
+	SPX5_WR(mach, sparx5, LRN_MAC_ACCESS_CFG_0);
+	SPX5_WR(macl, sparx5, LRN_MAC_ACCESS_CFG_1);
+}
+
+int sparx5_mact_learn(struct sparx5 *sparx5, int pgid,
+		      const unsigned char mac[ETH_ALEN], u16 vid)
+{
+	int addr, type, ret;
+
+	if (pgid < SPX5_PORTS) {
+		type = MAC_ENTRY_ADDR_TYPE_UPSID_PN;
+		addr = pgid % 32;
+		addr += (pgid / 32) << 5; /* Add upsid */
+	} else {
+		type = MAC_ENTRY_ADDR_TYPE_MC_IDX;
+		addr = pgid - SPX5_PORTS;
+	}
+
+	sparx5_hw_lock(sparx5);
+
+	sparx5_mact_select(sparx5, mac, vid);
+
+	/* MAC entry properties */
+	SPX5_WR(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_SET(addr) |
+		LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_SET(type) |
+		LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_SET(1) |
+		LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED_SET(1),
+		sparx5, LRN_MAC_ACCESS_CFG_2);
+	SPX5_WR(0, sparx5, LRN_MAC_ACCESS_CFG_3);
+
+	/*  Insert/learn new entry */
+	SPX5_WR(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_LEARN) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+
+	sparx5_hw_unlock(sparx5);
+
+	return ret;
+}
+
+int sparx5_mc_unsync(struct net_device *dev, const unsigned char *addr)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	return sparx5_mact_forget(sparx5, addr, port->pvid);
+}
+
+int sparx5_mc_sync(struct net_device *dev, const unsigned char *addr)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	return sparx5_mact_learn(sparx5, PGID_CPU, addr, port->pvid);
+}
+
+static inline int sparx5_mact_get(struct sparx5 *sparx5,
+				  unsigned char mac[ETH_ALEN],
+				  u16 *vid, u32 *pcfg2)
+{
+	u32 mach, macl, cfg2;
+	int ret = -ENOENT;
+
+	cfg2 = SPX5_RD(sparx5, LRN_MAC_ACCESS_CFG_2);
+	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(cfg2)) {
+		mach = SPX5_RD(sparx5, LRN_MAC_ACCESS_CFG_0);
+		macl = SPX5_RD(sparx5, LRN_MAC_ACCESS_CFG_1);
+		mac[0] = ((mach >> 8)  & 0xff);
+		mac[1] = ((mach >> 0)  & 0xff);
+		mac[2] = ((macl >> 24) & 0xff);
+		mac[3] = ((macl >> 16) & 0xff);
+		mac[4] = ((macl >> 8)  & 0xff);
+		mac[5] = ((macl >> 0)  & 0xff);
+		*vid = mach >> 16;
+		*pcfg2 = cfg2;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+bool sparx5_mact_getnext(struct sparx5 *sparx5,
+			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2)
+{
+	int ret;
+	u32 cfg2;
+
+	sparx5_hw_lock(sparx5);
+
+	sparx5_mact_select(sparx5, mac, *vid);
+
+	SPX5_WR(LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA_SET(1) |
+		LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_SET(1),
+		sparx5, LRN_SCAN_NEXT_CFG);
+	SPX5_WR(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET
+		(MAC_CMD_FIND_SMALLEST) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+	if (ret == 0) {
+		ret = sparx5_mact_get(sparx5, mac, vid, &cfg2);
+		if (ret == 0)
+			*pcfg2 = cfg2;
+	}
+
+	sparx5_hw_unlock(sparx5);
+
+	return ret == 0;
+}
+
+static int sparx5_mact_lookup(struct sparx5 *sparx5,
+			      const unsigned char mac[ETH_ALEN],
+			      u16 vid)
+{
+	int ret;
+
+	sparx5_hw_lock(sparx5);
+
+	sparx5_mact_select(sparx5, mac, vid);
+
+	/* Issue a lookup command */
+	SPX5_WR(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_LOOKUP) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+	if (ret)
+		goto out;
+
+	ret = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET
+		(SPX5_RD(sparx5, LRN_MAC_ACCESS_CFG_2));
+
+out:
+	sparx5_hw_unlock(sparx5);
+
+	return ret;
+}
+
+int sparx5_mact_forget(struct sparx5 *sparx5,
+		       const unsigned char mac[ETH_ALEN], u16 vid)
+{
+	int ret;
+
+	sparx5_hw_lock(sparx5);
+
+	sparx5_mact_select(sparx5, mac, vid);
+
+	/* Issue an unlearn command */
+	SPX5_WR(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_UNLEARN) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	ret = sparx5_mact_wait_for_completion(sparx5);
+
+	sparx5_hw_unlock(sparx5);
+
+	return ret;
+}
+
+static struct sparx5_mact_entry *alloc_mact_entry(struct sparx5 *sparx5,
+						  const unsigned char *mac,
+						  u16 vid, u16 port_index)
+{
+	struct sparx5_mact_entry *mact_entry;
+
+	mact_entry = devm_kzalloc(sparx5->dev,
+				  sizeof(*mact_entry), GFP_ATOMIC);
+	if (!mact_entry)
+		return NULL;
+
+	memcpy(mact_entry->mac, mac, ETH_ALEN);
+	mact_entry->vid = vid;
+	mact_entry->port = port_index;
+	return mact_entry;
+}
+
+static struct sparx5_mact_entry *find_mact_entry(struct sparx5 *sparx5,
+						 const unsigned char *mac,
+						 u16 vid, u16 port_index)
+{
+	struct sparx5_mact_entry *mact_entry;
+	struct sparx5_mact_entry *res = NULL;
+
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
+		if (mact_entry->vid == vid &&
+		    ether_addr_equal(mac, mact_entry->mac) &&
+		    mact_entry->port == port_index) {
+			res = mact_entry;
+			break;
+		}
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	return res;
+}
+
+static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
+				      const char *mac, u16 vid,
+				      struct net_device *dev, bool offloaded)
+{
+	struct switchdev_notifier_fdb_info info;
+
+	info.addr = mac;
+	info.vid = vid;
+	info.offloaded = offloaded;
+	call_switchdev_notifiers(type, dev, &info.info, NULL);
+}
+
+int sparx5_add_mact_entry(struct sparx5 *sparx5,
+			  struct sparx5_port *port,
+			  const unsigned char *addr, u16 vid)
+{
+	struct sparx5_mact_entry *mact_entry;
+	int ret;
+
+	ret = sparx5_mact_lookup(sparx5, addr, vid);
+	if (ret)
+		return 0;
+
+	/* In case the entry already exists, don't add it again to SW,
+	 * just update HW, but we need to look in the actual HW because
+	 * it is possible for an entry to be learn by HW and before the
+	 * mact thread to start the frame will reach CPU and the CPU will
+	 * add the entry but without the extern_learn flag.
+	 */
+	mact_entry = find_mact_entry(sparx5, addr, vid, port->portno);
+	if (mact_entry)
+		goto update_hw;
+
+	/* Add the entry in SW MAC table not to get the notification when
+	 * SW is pulling again
+	 */
+	mact_entry = alloc_mact_entry(sparx5, addr, vid, port->portno);
+	if (!mact_entry)
+		return -ENOMEM;
+
+	mutex_lock(&sparx5->mact_lock);
+	list_add_tail(&mact_entry->list, &sparx5->mact_entries);
+	mutex_unlock(&sparx5->mact_lock);
+
+update_hw:
+	ret = sparx5_mact_learn(sparx5, port->portno, addr, vid);
+
+	/* New entry? */
+	if (mact_entry->flags == 0) {
+		mact_entry->flags |= MAC_ENT_LOCK; /* Don't age this */
+		sparx5_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid,
+					  port->ndev, true);
+	}
+
+	return ret;
+}
+
+int sparx5_del_mact_entry(struct sparx5 *sparx5,
+			  const unsigned char *addr,
+			  u16 vid)
+{
+	struct sparx5_mact_entry *mact_entry, *tmp;
+
+	/* Delete the entry in SW MAC table not to get the notification when
+	 * SW is pulling again
+	 */
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry_safe(mact_entry, tmp, &sparx5->mact_entries,
+				 list) {
+		if ((vid == 0 || mact_entry->vid == vid) &&
+		    ether_addr_equal(addr, mact_entry->mac)) {
+			list_del(&mact_entry->list);
+			devm_kfree(sparx5->dev, mact_entry);
+
+			sparx5_mact_forget(sparx5, addr, mact_entry->vid);
+		}
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	return 0;
+}
+
+static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
+				     unsigned char mac[ETH_ALEN],
+				     u16 vid, u32 cfg2)
+{
+	struct sparx5_mact_entry *mact_entry;
+	u16 port;
+	bool found = false;
+
+	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(cfg2) !=
+	    MAC_ENTRY_ADDR_TYPE_UPSID_PN)
+		return;
+
+	port = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(cfg2);
+	if (port >= SPX5_PORTS)
+		return;
+
+	if (!test_bit(port, sparx5->bridge_mask))
+		return;
+
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
+		if (mact_entry->vid == vid &&
+		    ether_addr_equal(mac, mact_entry->mac)) {
+			found = true;
+			mact_entry->flags |= MAC_ENT_ALIVE;
+			if (mact_entry->port != port) {
+				mact_entry->port = port;
+				mact_entry->flags |= MAC_ENT_MOVED;
+			}
+			/* Entry handled */
+			break;
+		}
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	if (found && !(mact_entry->flags & MAC_ENT_MOVED))
+		/* Present, not moved */
+		return;
+
+	if (!found) {
+		/* Entry not found - now add */
+		mact_entry = alloc_mact_entry(sparx5, mac, vid, port);
+		if (!mact_entry)
+			return;
+
+		mact_entry->flags |= MAC_ENT_ALIVE;
+		mutex_lock(&sparx5->mact_lock);
+		list_add_tail(&mact_entry->list, &sparx5->mact_entries);
+		mutex_unlock(&sparx5->mact_lock);
+	}
+
+	/* New or moved entry - notify bridge */
+	sparx5_fdb_call_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+				  mac, vid, sparx5->ports[port]->ndev,
+				  true);
+}
+
+void sparx5_mact_pull_work(struct work_struct *work)
+{
+	struct delayed_work *del_work = to_delayed_work(work);
+	struct sparx5 *sparx5 = container_of(del_work, struct sparx5,
+					     mact_work);
+	struct sparx5_mact_entry *mact_entry, *tmp;
+	unsigned char mac[ETH_ALEN];
+	u16 vid;
+	u32 cfg2;
+	int ret;
+
+	/* Reset MAC entyry flags */
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry(mact_entry, &sparx5->mact_entries, list)
+		mact_entry->flags &= MAC_ENT_LOCK;
+	mutex_unlock(&sparx5->mact_lock);
+
+	/* MAIN mac address processing loop */
+	vid = 0;
+	memset(mac, 0, sizeof(mac));
+	do {
+		sparx5_hw_lock(sparx5);
+		sparx5_mact_select(sparx5, mac, vid);
+		SPX5_WR(LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_SET(1),
+			sparx5, LRN_SCAN_NEXT_CFG);
+		SPX5_WR(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET
+			(MAC_CMD_FIND_SMALLEST) |
+			LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+			sparx5, LRN_COMMON_ACCESS_CTRL);
+		ret = sparx5_mact_wait_for_completion(sparx5);
+		if (ret == 0)
+			ret = sparx5_mact_get(sparx5, mac, &vid, &cfg2);
+		sparx5_hw_unlock(sparx5);
+		if (ret == 0)
+			sparx5_mact_handle_entry(sparx5, mac, vid, cfg2);
+	} while (ret == 0);
+
+	mutex_lock(&sparx5->mact_lock);
+	list_for_each_entry_safe(mact_entry, tmp, &sparx5->mact_entries,
+				 list) {
+		/* If the entry is in HW or permanent, then skip */
+		if (mact_entry->flags & (MAC_ENT_ALIVE | MAC_ENT_LOCK))
+			continue;
+
+		sparx5_fdb_call_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+					  mact_entry->mac, mact_entry->vid,
+					  sparx5->ports[mact_entry->port]->ndev,
+					  true);
+
+		list_del(&mact_entry->list);
+		devm_kfree(sparx5->dev, mact_entry);
+	}
+	mutex_unlock(&sparx5->mact_lock);
+
+	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
+			   SPX5_MACT_PULL_DELAY);
+}
+
+void sparx5_set_ageing(struct sparx5 *sparx5, int msecs)
+{
+	int value = max(1, msecs / 10); /* unit 10 ms */
+
+	SPX5_RMW(LRN_AUTOAGE_CFG_UNIT_SIZE_SET(2) | /* 10 ms */
+		 LRN_AUTOAGE_CFG_PERIOD_VAL_SET(value / 2), /* one bit ageing */
+		 LRN_AUTOAGE_CFG_UNIT_SIZE |
+		 LRN_AUTOAGE_CFG_PERIOD_VAL,
+		 sparx5,
+		 LRN_AUTOAGE_CFG(0));
+}
+
+void sparx5_mact_init(struct sparx5 *sparx5)
+{
+	mutex_init(&sparx5->lock);
+
+	sparx5_hw_lock(sparx5);
+
+	/*  Flush MAC table */
+	SPX5_WR(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(MAC_CMD_CLEAR_ALL) |
+		LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(1),
+		sparx5, LRN_COMMON_ACCESS_CTRL);
+
+	if (sparx5_mact_wait_for_completion(sparx5) != 0)
+		dev_warn(sparx5->dev, "MAC flush error\n");
+
+	sparx5_hw_unlock(sparx5);
+
+	sparx5_set_ageing(sparx5, 10 * MSEC_PER_SEC); /* 10 sec */
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
new file mode 100644
index 000000000000..87f19e8d1fa9
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -0,0 +1,851 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ *
+ * The Sparx5 Chip Register Model can be browsed at this location:
+ * https://github.com/microchip-ung/sparx-5_reginfo
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/of_mdio.h>
+#include <net/switchdev.h>
+#include <linux/etherdevice.h>
+#include <linux/io.h>
+#include <linux/printk.h>
+#include <linux/iopoll.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+#include "sparx5_main.h"
+#include "sparx5_port.h"
+
+/* Switch core reset/protect */
+#define RESET_PROT_STAT		0x84
+#define SYS_RST_PROT_VCORE	BIT(10)
+#define QLIM_WM(fraction) \
+	((SPX5_BUFFER_MEMORY / SPX5_BUFFER_CELL_SZ - 100) * (fraction) / 100)
+
+struct sparx5_io_resource {
+	enum sparx5_target id;
+	char *name;
+};
+
+static struct sparx5_io_resource sparx5_iomap[] =  {
+	{ TARGET_DEV2G5,         "dev2g5_0" },
+	{ TARGET_DEV5G,          "dev5g_0" },
+	{ TARGET_PCS5G_BR,       "pcs5g_br_0" },
+	{ TARGET_DEV2G5 + 1,     "dev2g5_1" },
+	{ TARGET_DEV5G + 1,      "dev5g_1" },
+	{ TARGET_PCS5G_BR + 1,   "pcs5g_br_1" },
+	{ TARGET_DEV2G5 + 2,     "dev2g5_2" },
+	{ TARGET_DEV5G + 2,      "dev5g_2" },
+	{ TARGET_PCS5G_BR + 2,   "pcs5g_br_2" },
+	{ TARGET_DEV2G5 + 6,     "dev2g5_6" },
+	{ TARGET_DEV5G + 6,      "dev5g_6" },
+	{ TARGET_PCS5G_BR + 6,   "pcs5g_br_6" },
+	{ TARGET_DEV2G5 + 7,     "dev2g5_7" },
+	{ TARGET_DEV5G + 7,      "dev5g_7" },
+	{ TARGET_PCS5G_BR + 7,   "pcs5g_br_7" },
+	{ TARGET_DEV2G5 + 8,     "dev2g5_8" },
+	{ TARGET_DEV5G + 8,      "dev5g_8" },
+	{ TARGET_PCS5G_BR + 8,   "pcs5g_br_8" },
+	{ TARGET_DEV2G5 + 9,     "dev2g5_9" },
+	{ TARGET_DEV5G + 9,      "dev5g_9" },
+	{ TARGET_PCS5G_BR + 9,   "pcs5g_br_9" },
+	{ TARGET_DEV2G5 + 10,    "dev2g5_10" },
+	{ TARGET_DEV5G + 10,     "dev5g_10" },
+	{ TARGET_PCS5G_BR + 10,  "pcs5g_br_10" },
+	{ TARGET_DEV2G5 + 11,    "dev2g5_11" },
+	{ TARGET_DEV5G + 11,     "dev5g_11" },
+	{ TARGET_PCS5G_BR + 11,  "pcs5g_br_11" },
+	{ TARGET_DEV2G5 + 12,    "dev2g5_12" },
+	{ TARGET_DEV10G,         "dev10g_0" },
+	{ TARGET_PCS10G_BR,      "pcs10g_br_0" },
+	{ TARGET_DEV2G5 + 14,    "dev2g5_14" },
+	{ TARGET_DEV10G + 2,     "dev10g_2" },
+	{ TARGET_PCS10G_BR + 2,  "pcs10g_br_2" },
+	{ TARGET_DEV2G5 + 15,    "dev2g5_15" },
+	{ TARGET_DEV10G + 3,     "dev10g_3" },
+	{ TARGET_PCS10G_BR + 3,  "pcs10g_br_3" },
+	{ TARGET_DEV2G5 + 16,    "dev2g5_16" },
+	{ TARGET_DEV2G5 + 17,    "dev2g5_17" },
+	{ TARGET_DEV2G5 + 18,    "dev2g5_18" },
+	{ TARGET_DEV2G5 + 19,    "dev2g5_19" },
+	{ TARGET_DEV2G5 + 20,    "dev2g5_20" },
+	{ TARGET_DEV2G5 + 21,    "dev2g5_21" },
+	{ TARGET_DEV2G5 + 22,    "dev2g5_22" },
+	{ TARGET_DEV2G5 + 23,    "dev2g5_23" },
+	{ TARGET_DEV2G5 + 32,    "dev2g5_32" },
+	{ TARGET_DEV2G5 + 33,    "dev2g5_33" },
+	{ TARGET_DEV2G5 + 34,    "dev2g5_34" },
+	{ TARGET_DEV2G5 + 35,    "dev2g5_35" },
+	{ TARGET_DEV2G5 + 36,    "dev2g5_36" },
+	{ TARGET_DEV2G5 + 37,    "dev2g5_37" },
+	{ TARGET_DEV2G5 + 38,    "dev2g5_38" },
+	{ TARGET_DEV2G5 + 39,    "dev2g5_39" },
+	{ TARGET_DEV2G5 + 40,    "dev2g5_40" },
+	{ TARGET_DEV2G5 + 41,    "dev2g5_41" },
+	{ TARGET_DEV2G5 + 42,    "dev2g5_42" },
+	{ TARGET_DEV2G5 + 43,    "dev2g5_43" },
+	{ TARGET_DEV2G5 + 44,    "dev2g5_44" },
+	{ TARGET_DEV2G5 + 45,    "dev2g5_45" },
+	{ TARGET_DEV2G5 + 46,    "dev2g5_46" },
+	{ TARGET_DEV2G5 + 47,    "dev2g5_47" },
+	{ TARGET_DEV2G5 + 57,    "dev2g5_57" },
+	{ TARGET_DEV25G + 1,     "dev25g_1" },
+	{ TARGET_PCS25G_BR + 1,  "pcs25g_br_1" },
+	{ TARGET_DEV2G5 + 59,    "dev2g5_59" },
+	{ TARGET_DEV25G + 3,     "dev25g_3" },
+	{ TARGET_PCS25G_BR + 3,  "pcs25g_br_3" },
+	{ TARGET_DEV2G5 + 60,    "dev2g5_60" },
+	{ TARGET_DEV25G + 4,     "dev25g_4" },
+	{ TARGET_PCS25G_BR + 4,  "pcs25g_br_4" },
+	{ TARGET_DEV2G5 + 64,    "dev2g5_64" },
+	{ TARGET_DEV5G + 12,     "dev5g_64" },
+	{ TARGET_PCS5G_BR + 12,  "pcs5g_br_64" },
+	{ TARGET_PORT_CONF,      "port_conf" },
+	{ TARGET_DEV2G5 + 3,     "dev2g5_3" },
+	{ TARGET_DEV5G + 3,      "dev5g_3" },
+	{ TARGET_PCS5G_BR + 3,   "pcs5g_br_3" },
+	{ TARGET_DEV2G5 + 4,     "dev2g5_4" },
+	{ TARGET_DEV5G + 4,      "dev5g_4" },
+	{ TARGET_PCS5G_BR + 4,   "pcs5g_br_4" },
+	{ TARGET_DEV2G5 + 5,     "dev2g5_5" },
+	{ TARGET_DEV5G + 5,      "dev5g_5" },
+	{ TARGET_PCS5G_BR + 5,   "pcs5g_br_5" },
+	{ TARGET_DEV2G5 + 13,    "dev2g5_13" },
+	{ TARGET_DEV10G + 1,     "dev10g_1" },
+	{ TARGET_PCS10G_BR + 1,  "pcs10g_br_1" },
+	{ TARGET_DEV2G5 + 24,    "dev2g5_24" },
+	{ TARGET_DEV2G5 + 25,    "dev2g5_25" },
+	{ TARGET_DEV2G5 + 26,    "dev2g5_26" },
+	{ TARGET_DEV2G5 + 27,    "dev2g5_27" },
+	{ TARGET_DEV2G5 + 28,    "dev2g5_28" },
+	{ TARGET_DEV2G5 + 29,    "dev2g5_29" },
+	{ TARGET_DEV2G5 + 30,    "dev2g5_30" },
+	{ TARGET_DEV2G5 + 31,    "dev2g5_31" },
+	{ TARGET_DEV2G5 + 48,    "dev2g5_48" },
+	{ TARGET_DEV10G + 4,     "dev10g_4" },
+	{ TARGET_PCS10G_BR + 4,  "pcs10g_br_4" },
+	{ TARGET_DEV2G5 + 49,    "dev2g5_49" },
+	{ TARGET_DEV10G + 5,     "dev10g_5" },
+	{ TARGET_PCS10G_BR + 5,  "pcs10g_br_5" },
+	{ TARGET_DEV2G5 + 50,    "dev2g5_50" },
+	{ TARGET_DEV10G + 6,     "dev10g_6" },
+	{ TARGET_PCS10G_BR + 6,  "pcs10g_br_6" },
+	{ TARGET_DEV2G5 + 51,    "dev2g5_51" },
+	{ TARGET_DEV10G + 7,     "dev10g_7" },
+	{ TARGET_PCS10G_BR + 7,  "pcs10g_br_7" },
+	{ TARGET_DEV2G5 + 52,    "dev2g5_52" },
+	{ TARGET_DEV10G + 8,     "dev10g_8" },
+	{ TARGET_PCS10G_BR + 8,  "pcs10g_br_8" },
+	{ TARGET_DEV2G5 + 53,    "dev2g5_53" },
+	{ TARGET_DEV10G + 9,     "dev10g_9" },
+	{ TARGET_PCS10G_BR + 9,  "pcs10g_br_9" },
+	{ TARGET_DEV2G5 + 54,    "dev2g5_54" },
+	{ TARGET_DEV10G + 10,    "dev10g_10" },
+	{ TARGET_PCS10G_BR + 10, "pcs10g_br_10" },
+	{ TARGET_DEV2G5 + 55,    "dev2g5_55" },
+	{ TARGET_DEV10G + 11,    "dev10g_11" },
+	{ TARGET_PCS10G_BR + 11, "pcs10g_br_11" },
+	{ TARGET_DEV2G5 + 56,    "dev2g5_56" },
+	{ TARGET_DEV25G,         "dev25g_0" },
+	{ TARGET_PCS25G_BR,      "pcs25g_br_0" },
+	{ TARGET_DEV2G5 + 58,    "dev2g5_58" },
+	{ TARGET_DEV25G + 2,     "dev25g_2" },
+	{ TARGET_PCS25G_BR + 2,  "pcs25g_br_2" },
+	{ TARGET_DEV2G5 + 61,    "dev2g5_61" },
+	{ TARGET_DEV25G + 5,     "dev25g_5" },
+	{ TARGET_PCS25G_BR + 5,  "pcs25g_br_5" },
+	{ TARGET_DEV2G5 + 62,    "dev2g5_62" },
+	{ TARGET_DEV25G + 6,     "dev25g_6" },
+	{ TARGET_PCS25G_BR + 6,  "pcs25g_br_6" },
+	{ TARGET_DEV2G5 + 63,    "dev2g5_63" },
+	{ TARGET_DEV25G + 7,     "dev25g_7" },
+	{ TARGET_PCS25G_BR + 7,  "pcs25g_br_7" },
+	{ TARGET_DSM,            "dsm" },
+	{ TARGET_ASM,            "asm" },
+	{ TARGET_GCB,            "gcb" },
+	{ TARGET_QS,             "qs" },
+	{ TARGET_ANA_ACL,        "ana_acl" },
+	{ TARGET_LRN,            "lrn" },
+	{ TARGET_VCAP_SUPER,     "vcap_super" },
+	{ TARGET_QSYS,           "qsys" },
+	{ TARGET_QFWD,           "qfwd" },
+	{ TARGET_XQS,            "xqs" },
+	{ TARGET_CLKGEN,         "clkgen" },
+	{ TARGET_ANA_AC_POL,     "ana_ac_pol" },
+	{ TARGET_QRES,           "qres" },
+	{ TARGET_EACL,           "eacl" },
+	{ TARGET_ANA_CL,         "ana_cl" },
+	{ TARGET_ANA_L3,         "ana_l3" },
+	{ TARGET_HSCH,           "hsch" },
+	{ TARGET_REW,            "rew" },
+	{ TARGET_ANA_L2,         "ana_l2" },
+	{ TARGET_ANA_AC,         "ana_ac" },
+	{ TARGET_VOP,            "vop" },
+};
+
+static int sparx5_create_targets(struct sparx5 *sparx5)
+{
+	int idx;
+
+	/* Check if done previously (deferred by serdes load) */
+	if (sparx5->regs[sparx5_iomap[0].id])
+		return 0;
+
+	for (idx = 0; idx < ARRAY_SIZE(sparx5_iomap); idx++) {
+		struct resource *resource;
+
+		resource = platform_get_resource_byname(sparx5->pdev,
+							IORESOURCE_MEM,
+							sparx5_iomap[idx].name);
+		if (!resource) {
+			dev_err(sparx5->dev,
+				"Unable to get switch registers: %s\n",
+				sparx5_iomap[idx].name);
+			return -ENODEV;
+		}
+
+		sparx5->regs[sparx5_iomap[idx].id] = devm_ioremap(sparx5->dev,
+								  resource->start,
+								  resource->end -
+								  resource->start + 1);
+		if (IS_ERR(sparx5->regs[sparx5_iomap[idx].id])) {
+			dev_err(sparx5->dev,
+				"Unable to map switch registers: %s\n",
+				sparx5_iomap[idx].name);
+			return PTR_ERR(sparx5->regs[sparx5_iomap[idx].id]);
+		}
+	}
+	return 0;
+}
+
+static int sparx5_probe_port(struct sparx5 *sparx5,
+			     struct device_node *portnp,
+			     struct phy *serdes,
+			     u32 portno,
+			     struct sparx5_port_config *conf)
+{
+	phy_interface_t phy_mode = conf->phy_mode;
+	struct sparx5_port *spx5_port;
+	struct net_device *ndev;
+	struct phylink *phylink;
+	int err;
+
+	err = sparx5_create_targets(sparx5);
+	if (err)
+		return err;
+	ndev = sparx5_create_netdev(sparx5, portno);
+	if (IS_ERR(ndev)) {
+		dev_err(sparx5->dev, "Could not create net device: %02u\n", portno);
+		return PTR_ERR(ndev);
+	}
+	spx5_port = netdev_priv(ndev);
+	spx5_port->of_node = portnp;
+	spx5_port->serdes = serdes;
+	spx5_port->pvid = NULL_VID;
+	spx5_port->signd_internal = true;
+	spx5_port->signd_active_high = true;
+	spx5_port->signd_enable = true;
+	spx5_port->flow_control = false;
+	spx5_port->max_vlan_tags = SPX5_PORT_MAX_TAGS_NONE;
+	spx5_port->vlan_type = SPX5_VLAN_PORT_TYPE_UNAWARE;
+	spx5_port->custom_etype = 0x8880; /* Vitesse */
+	conf->portmode = conf->phy_mode;
+	spx5_port->conf.speed = SPEED_UNKNOWN;
+	spx5_port->conf.power_down = true;
+	sparx5->ports[portno] = spx5_port;
+
+	err = sparx5_port_init(sparx5, spx5_port, conf);
+	if (err) {
+		dev_err(sparx5->dev, "port init failed\n");
+		return err;
+	}
+	err = sparx5_port_config(sparx5, spx5_port, conf);
+	if (err) {
+		dev_err(sparx5->dev, "port config failed\n");
+		return err;
+	}
+
+	/* Disable port */
+	sparx5_port_enable(spx5_port, false);
+
+	/* Setup VLAN */
+	sparx5_vlan_port_setup(sparx5, spx5_port->portno);
+
+	/* Create a phylink for PHY management.  Also handles SFPs */
+	spx5_port->phylink_config.dev = &spx5_port->ndev->dev;
+	spx5_port->phylink_config.type = PHYLINK_NETDEV;
+	spx5_port->phylink_config.pcs_poll = true;
+
+	/* phylink needs a valid interface mode to parse dt node */
+	if (phy_mode == PHY_INTERFACE_MODE_NA)
+		phy_mode = PHY_INTERFACE_MODE_10GBASER;
+
+	phylink = phylink_create(&spx5_port->phylink_config,
+				 of_fwnode_handle(portnp),
+				 phy_mode,
+				 &sparx5_phylink_mac_ops);
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
+
+	spx5_port->phylink = phylink;
+
+	return 0;
+}
+
+static int sparx5_init_switchcore(struct sparx5 *sparx5)
+{
+	u32 value, pending, jdx, idx;
+	struct {
+		bool gazwrap;
+		void __iomem *init_reg;
+		u32  init_val;
+	} ram, ram_init_list[] = {
+		{false, SPX5_REG_GET(sparx5, ANA_AC_STAT_RESET),
+		 ANA_AC_STAT_RESET_RESET},
+		{false, SPX5_REG_GET(sparx5, ASM_STAT_CFG),
+		 ASM_STAT_CFG_STAT_CNT_CLR_SHOT},
+		{true,  SPX5_REG_GET(sparx5, QSYS_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, REW_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, VOP_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, ANA_AC_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, ASM_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, EACL_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, VCAP_SUPER_RAM_INIT), 0},
+		{true,  SPX5_REG_GET(sparx5, DSM_RAM_INIT), 0}
+	};
+
+	SPX5_RMW(EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(1),
+		 EACL_POL_EACL_CFG_EACL_FORCE_INIT,
+		 sparx5,
+		 EACL_POL_EACL_CFG);
+
+	SPX5_RMW(EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(0),
+		 EACL_POL_EACL_CFG_EACL_FORCE_INIT,
+		 sparx5,
+		 EACL_POL_EACL_CFG);
+
+	/* Initialize memories, if not done already */
+	value = SPX5_RD(sparx5, HSCH_RESET_CFG);
+
+	if (!(value & HSCH_RESET_CFG_CORE_ENA)) {
+		for (idx = 0; idx < 10; idx++) {
+			pending = ARRAY_SIZE(ram_init_list);
+			for (jdx = 0; jdx < ARRAY_SIZE(ram_init_list); jdx++) {
+				ram = ram_init_list[jdx];
+				if (ram.gazwrap)
+					ram.init_val = QSYS_RAM_INIT_RAM_INIT;
+
+				if (idx == 0) {
+					SPX5_REG_WR(ram.init_val, ram.init_reg);
+				} else {
+					value = SPX5_REG_RD(ram.init_reg);
+					if ((value & ram.init_val) !=
+					    ram.init_val) {
+						pending--;
+					}
+				}
+			}
+			if (!pending)
+				break;
+			usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+		}
+
+		if (pending > 0) {
+			/* Still initializing, should be complete in
+			 * less than 1ms
+			 */
+			dev_err(sparx5->dev, "Memory initialization error\n");
+			return -EINVAL;
+		}
+	}
+
+	/* Reset counters */
+	SPX5_WR(ANA_AC_STAT_RESET_RESET_SET(1), sparx5, ANA_AC_STAT_RESET);
+	SPX5_WR(ASM_STAT_CFG_STAT_CNT_CLR_SHOT_SET(1), sparx5, ASM_STAT_CFG);
+
+	/* Configure manual injection */
+	sparx5_manual_injection_mode(sparx5);
+
+	/* Enable switch-core and queue system */
+	SPX5_WR(HSCH_RESET_CFG_CORE_ENA_SET(1), sparx5, HSCH_RESET_CFG);
+
+	return 0;
+}
+
+static int sparx5_init_coreclock(struct sparx5 *sparx5)
+{
+	u32 clk_div, clk_period, pol_upd_int, idx;
+	enum sparx5_core_clockfreq freq = sparx5->coreclock;
+
+	/* Verify if core clock frequency is supported on target.
+	 * If 'VTSS_CORE_CLOCK_DEFAULT' then the highest supported
+	 * freq. is used
+	 */
+	switch (sparx5->target_ct) {
+	case SPX5_TARGET_CT_7546:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_250MHZ;
+		else if (sparx5->coreclock != SPX5_CORE_CLOCK_250MHZ)
+			freq = 0; /* Not supported */
+		break;
+	case SPX5_TARGET_CT_7549:
+	case SPX5_TARGET_CT_7552:
+	case SPX5_TARGET_CT_7556:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_500MHZ;
+		else if (sparx5->coreclock != SPX5_CORE_CLOCK_500MHZ)
+			freq = 0; /* Not supported */
+		break;
+	case SPX5_TARGET_CT_7558:
+	case SPX5_TARGET_CT_7558TSN:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_625MHZ;
+		else if (sparx5->coreclock != SPX5_CORE_CLOCK_625MHZ)
+			freq = 0; /* Not supported */
+		break;
+	case SPX5_TARGET_CT_7546TSN:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_625MHZ;
+		break;
+	case SPX5_TARGET_CT_7549TSN:
+	case SPX5_TARGET_CT_7552TSN:
+	case SPX5_TARGET_CT_7556TSN:
+		if (sparx5->coreclock == SPX5_CORE_CLOCK_DEFAULT)
+			freq = SPX5_CORE_CLOCK_625MHZ;
+		else if (sparx5->coreclock == SPX5_CORE_CLOCK_250MHZ)
+			freq = 0; /* Not supported */
+		break;
+	default:
+		dev_err(sparx5->dev, "Target (%#04x) not supported\n", sparx5->target_ct);
+		return -ENODEV;
+	}
+
+	switch (freq) {
+	case SPX5_CORE_CLOCK_250MHZ:
+		clk_div = 10;
+		pol_upd_int = 312;
+		break;
+	case SPX5_CORE_CLOCK_500MHZ:
+		clk_div = 5;
+		pol_upd_int = 624;
+		break;
+	case SPX5_CORE_CLOCK_625MHZ:
+		clk_div = 4;
+		pol_upd_int = 780;
+		break;
+	default:
+		dev_err(sparx5->dev, "%s: Frequency (%d) not supported on target (%#04x)\n",
+			__func__,
+			sparx5->coreclock, sparx5->target_ct);
+		return 0;
+	}
+
+	/* Update state with chosen frequency */
+	sparx5->coreclock = freq;
+
+	/* Configure the LCPLL */
+	SPX5_RMW(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV_SET(clk_div) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA_SET(0) |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA_SET(1),
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA |
+		 CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA,
+		 sparx5,
+		 CLKGEN_LCPLL1_CORE_CLK_CFG);
+
+	clk_period = sparx5_clk_period(freq);
+
+	SPX5_RMW(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_SET(clk_period / 100),
+		 HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS,
+		 sparx5,
+		 HSCH_SYS_CLK_PER);
+
+	SPX5_RMW(ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS_SET(clk_period / 100),
+		 ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS,
+		 sparx5,
+		 ANA_AC_POL_BDLB_DLB_CTRL);
+
+	SPX5_RMW(ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS_SET(clk_period / 100),
+		 ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS,
+		 sparx5,
+		 ANA_AC_POL_SLB_DLB_CTRL);
+
+	SPX5_RMW(LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS_SET(clk_period / 100),
+		 LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS,
+		 sparx5,
+		 LRN_AUTOAGE_CFG_1);
+
+	for (idx = 0; idx < 3; idx++) {
+		SPX5_RMW(GCB_SIO_CLOCK_SYS_CLK_PERIOD_SET(clk_period / 100),
+			 GCB_SIO_CLOCK_SYS_CLK_PERIOD,
+			 sparx5,
+			 GCB_SIO_CLOCK(idx));
+	}
+
+	SPX5_RMW(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_SET
+		 ((256 * 1000) / clk_period),
+		 HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY,
+		 sparx5,
+		 HSCH_TAS_STATEMACHINE_CFG);
+
+	SPX5_RMW(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_SET(pol_upd_int),
+		 ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT,
+		 sparx5,
+		 ANA_AC_POL_POL_UPD_INT_CFG);
+
+	return 0;
+}
+
+static int sparx5_qlim_set(struct sparx5 *sparx5)
+{
+	u32 res, dp, prio;
+
+	for (res = 0; res < 2; res++) {
+		for (prio = 0; prio < 8; prio++)
+			SPX5_WR(0xFFF, sparx5, QRES_RES_CFG(prio + 630 + res * 1024));
+
+		for (dp = 0; dp < 4; dp++)
+			SPX5_WR(0xFFF, sparx5, QRES_RES_CFG(dp + 638 + res * 1024));
+	}
+
+	/* Set 80,90,95,100% of memory size for top watermarks */
+	SPX5_WR(QLIM_WM(80), sparx5, XQS_QLIMIT_SHR_QLIM_CFG(0));
+	SPX5_WR(QLIM_WM(90), sparx5, XQS_QLIMIT_SHR_CTOP_CFG(0));
+	SPX5_WR(QLIM_WM(95), sparx5, XQS_QLIMIT_SHR_ATOP_CFG(0));
+	SPX5_WR(QLIM_WM(100), sparx5, XQS_QLIMIT_SHR_TOP_CFG(0));
+
+	return 0;
+}
+
+static int sparx5_init(struct sparx5 *sparx5)
+{
+	u8 broadcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	int irq, ret;
+	u32 idx;
+
+	if (sparx5_create_targets(sparx5))
+		return -ENODEV;
+
+	/* Hook xtr irq */
+	irq = platform_get_irq(sparx5->pdev, 0);
+	if (irq < 0)
+		return irq;
+	ret = devm_request_irq(sparx5->dev, irq,
+			       sparx5_xtr_handler, IRQF_SHARED,
+			       "sparx5-xtr", sparx5);
+	if (ret)
+		return ret;
+
+	/* Read chip ID to check CPU interface */
+	sparx5->chip_id = SPX5_RD(sparx5, GCB_CHIP_ID);
+
+	sparx5->target_ct = (enum spx5_target_chiptype)
+		GCB_CHIP_ID_PART_ID_GET(sparx5->chip_id);
+
+	/* Initialize Switchcore and internal RAMs */
+	if (sparx5_init_switchcore(sparx5)) {
+		dev_err(sparx5->dev, "Switchcore initialization error\n");
+		return -EINVAL;
+	}
+
+	/* Initialize the LC-PLL (core clock) and set affected registers */
+	if (sparx5_init_coreclock(sparx5)) {
+		dev_err(sparx5->dev, "LC-PLL initialization error\n");
+		return -EINVAL;
+	}
+
+	/* Setup own UPSIDs */
+	for (idx = 0; idx < 3; idx++) {
+		SPX5_WR(idx, sparx5, ANA_AC_OWN_UPSID(idx));
+		//SPX5_WR(idx, sparx5, ANA_ACL_OWN_UPSID(idx));
+		SPX5_WR(idx, sparx5, ANA_CL_OWN_UPSID(idx));
+		SPX5_WR(idx, sparx5, ANA_L2_OWN_UPSID(idx));
+		SPX5_WR(idx, sparx5, REW_OWN_UPSID(idx));
+	}
+
+	/* Enable switch ports */
+	for (idx = SPX5_PORTS; idx < SPX5_PORTS_ALL; idx++) {
+		SPX5_RMW(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(1),
+			 QFWD_SWITCH_PORT_MODE_PORT_ENA,
+			 sparx5,
+			 QFWD_SWITCH_PORT_MODE(idx));
+	}
+
+	/* Init masks */
+	sparx5_update_fwd(sparx5);
+
+	/* CPU copy CPU pgids */
+	SPX5_WR(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
+		sparx5, ANA_AC_PGID_MISC_CFG(PGID_CPU));
+	SPX5_WR(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
+		sparx5, ANA_AC_PGID_MISC_CFG(PGID_BCAST));
+
+	/* Recalc injected frame FCS */
+	for (idx = SPX5_PORT_CPU_0; idx <= SPX5_PORT_CPU_1; idx++)
+		SPX5_RMW(ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA_SET(1),
+			 ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA,
+			 sparx5, ANA_CL_FILTER_CTRL(idx));
+
+	/* Init MAC table, ageing */
+	sparx5_mact_init(sparx5);
+
+	/* Setup VLANs */
+	sparx5_vlan_init(sparx5);
+
+	/* Add host mode BC address (points only to CPU) */
+	sparx5_mact_learn(sparx5, PGID_CPU, broadcast, NULL_VID);
+
+	/* Enable queue limitation watermarks */
+	sparx5_qlim_set(sparx5);
+
+	return 0;
+}
+
+/* Some boards needs to map the SGPIO for signal detect explicitly to the
+ * port module
+ */
+static void sparx5_board_init(struct sparx5 *sparx5)
+{
+	int idx;
+
+	if (!sparx5->sd_sgpio_remapping)
+		return;
+
+	/* Enable SGPIO Signal Detect remapping */
+	SPX5_RMW(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
+		 GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL,
+		 sparx5,
+		 GCB_HW_SGPIO_SD_CFG);
+
+	/* Refer to LOS SGPIO */
+	for (idx = 0; idx < SPX5_PORTS; idx++) {
+		if (sparx5->ports[idx]) {
+			if (sparx5->ports[idx]->conf.sd_sgpio != ~0) {
+				SPX5_WR(sparx5->ports[idx]->conf.sd_sgpio,
+					sparx5,
+					GCB_HW_SGPIO_TO_SD_MAP_CFG(idx));
+			}
+		}
+	}
+}
+
+static void sparx5_cleanup_ports(struct sparx5 *sparx5)
+{
+	int idx;
+
+	for (idx = 0; idx < SPX5_PORTS; ++idx) {
+		struct sparx5_port *port = sparx5->ports[idx];
+
+		if (port && port->ndev)
+			sparx5_destroy_netdev(sparx5, port);
+	}
+}
+
+static int mchp_sparx5_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct sparx5 *sparx5;
+	struct device_node *ports, *portnp;
+	const u8 *mac_addr;
+	int err = 0;
+	char queue_name[32];
+
+	if (!np && !pdev->dev.platform_data)
+		return -ENODEV;
+
+	sparx5 = devm_kzalloc(&pdev->dev, sizeof(*sparx5), GFP_KERNEL);
+	if (!sparx5)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, sparx5);
+	sparx5->pdev = pdev;
+	sparx5->dev = &pdev->dev;
+
+	/* Default values, some from DT */
+	sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
+
+	mac_addr = of_get_mac_address(np);
+	if (IS_ERR_OR_NULL(mac_addr)) {
+		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
+		eth_random_addr(sparx5->base_mac);
+		sparx5->base_mac[5] = 0;
+	} else {
+		ether_addr_copy(sparx5->base_mac, mac_addr);
+	}
+
+	if (sparx5_init(sparx5)) {
+		dev_err(sparx5->dev, "Init failed\n");
+		return -ENODEV;
+	}
+	ports = of_get_child_by_name(np, "ethernet-ports");
+	if (!ports) {
+		dev_err(sparx5->dev, "no ethernet-ports child node found\n");
+		return -ENODEV;
+	}
+	sparx5->port_count = of_get_child_count(ports);
+
+	for_each_available_child_of_node(ports, portnp) {
+		struct sparx5_port_config config = {};
+		u32 portno;
+		struct phy *serdes;
+
+		err = of_property_read_u32(portnp, "reg", &portno);
+		if (err) {
+			dev_err(sparx5->dev, "port reg property error\n");
+			continue;
+		}
+		err = of_property_read_u32(portnp, "max-speed",
+					   &config.max_speed);
+		if (err) {
+			dev_err(sparx5->dev, "port max-speed property error\n");
+			continue;
+		}
+		config.speed = config.max_speed;
+		err = of_property_read_u32(portnp, "sd_sgpio", &config.sd_sgpio);
+		if (err)
+			config.sd_sgpio = ~0;
+		else
+			sparx5->sd_sgpio_remapping = true;
+		serdes = devm_of_phy_get(sparx5->dev, portnp, NULL);
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			if (err != -EPROBE_DEFER)
+				dev_err(sparx5->dev,
+					"missing SerDes phys for port%d\n",
+					portno);
+			return err;
+		}
+
+		err = of_get_phy_mode(portnp, &config.phy_mode);
+		if (err)
+			config.power_down = true;
+		config.media_type = ETH_MEDIA_DAC;
+		config.serdes_reset = true;
+		config.portmode = config.phy_mode;
+		err = sparx5_probe_port(sparx5, portnp, serdes, portno, &config);
+		if (err) {
+			dev_err(sparx5->dev, "port probe error\n");
+			goto cleanup_ports;
+		}
+	}
+	err = sparx5_config_auto_calendar(sparx5);
+	if (err)
+		goto cleanup_ports;
+
+	err = sparx5_config_dsm_calendar(sparx5);
+	if (err)
+		goto cleanup_ports;
+
+	/* Init stats */
+	err = sparx_stats_init(sparx5);
+	if (err)
+		goto cleanup_ports;
+
+	/* Init mact_sw struct */
+	mutex_init(&sparx5->mact_lock);
+	INIT_LIST_HEAD(&sparx5->mact_entries);
+	snprintf(queue_name, sizeof(queue_name), "%s-mact",
+		 dev_name(sparx5->dev));
+	sparx5->mact_queue = create_singlethread_workqueue(queue_name);
+	INIT_DELAYED_WORK(&sparx5->mact_work, sparx5_mact_pull_work);
+	queue_delayed_work(sparx5->mact_queue, &sparx5->mact_work,
+			   SPX5_MACT_PULL_DELAY);
+
+	sparx5_board_init(sparx5);
+	err = sparx5_register_notifier_blocks(sparx5);
+	if (err)
+		goto cleanup_ports;
+
+	return err;
+
+cleanup_ports:
+	sparx5_cleanup_ports(sparx5);
+	return err;
+}
+
+static int mchp_sparx5_remove(struct platform_device *pdev)
+{
+	struct sparx5 *sparx5 = platform_get_drvdata(pdev);
+
+	sparx5_cleanup_ports(sparx5);
+	/* Unregister netdevs */
+	sparx5_unregister_notifier_blocks(sparx5);
+
+	return 0;
+}
+
+static const struct of_device_id mchp_sparx5_match[] = {
+	{ .compatible = "microchip,sparx5-switch" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, mchp_sparx5_match);
+
+static struct platform_driver mchp_sparx5_driver = {
+	.probe = mchp_sparx5_probe,
+	.remove = mchp_sparx5_remove,
+	.driver = {
+		.name = "sparx5-switch",
+		.of_match_table = mchp_sparx5_match,
+	},
+};
+
+module_platform_driver(mchp_sparx5_driver);
+
+static inline u32 sparx5_read_gcb_soft_rst(struct regmap *gcb_ctrl)
+{
+	u32 val;
+
+	regmap_read(gcb_ctrl, spx5_offset(GCB_SOFT_RST), &val);
+	return val;
+}
+
+static int __init sparx5_switch_reset(void)
+{
+	const char *syscon_cpu = "microchip,sparx5-cpu-syscon",
+		*syscon_gcb = "microchip,sparx5-gcb-syscon";
+	struct regmap *cpu_ctrl, *gcb_ctrl;
+	u32 val;
+
+	cpu_ctrl = syscon_regmap_lookup_by_compatible(syscon_cpu);
+	if (IS_ERR(cpu_ctrl)) {
+		pr_err("No '%s' syscon map\n", syscon_cpu);
+		return PTR_ERR(cpu_ctrl);
+	}
+
+	gcb_ctrl = syscon_regmap_lookup_by_compatible(syscon_gcb);
+	if (IS_ERR(gcb_ctrl)) {
+		pr_err("No '%s' syscon map\n", syscon_gcb);
+		return PTR_ERR(gcb_ctrl);
+	}
+
+	/* Make sure the core is PROTECTED from reset */
+	regmap_update_bits(cpu_ctrl, RESET_PROT_STAT,
+			   SYS_RST_PROT_VCORE, SYS_RST_PROT_VCORE);
+
+	regmap_write(gcb_ctrl, spx5_offset(GCB_SOFT_RST),
+		     GCB_SOFT_RST_SOFT_SWC_RST_SET(1));
+
+	return readx_poll_timeout(sparx5_read_gcb_soft_rst, gcb_ctrl, val,
+				  GCB_SOFT_RST_SOFT_SWC_RST_GET(val) == 0,
+				  1, 100);
+}
+postcore_initcall(sparx5_switch_reset);
+
+MODULE_DESCRIPTION("Microchip Sparx5 switch driver");
+MODULE_AUTHOR("Steen Hegelund <steen.hegelund@microchip.com>");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
new file mode 100644
index 000000000000..eea64d7be6f2
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -0,0 +1,236 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_MAIN_H__
+#define __SPARX5_MAIN_H__
+
+#include <linux/types.h>
+#include <linux/phy/phy.h>
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/if_vlan.h>
+#include <linux/bitmap.h>
+#include <linux/phylink.h>
+
+#include "sparx5_common.h"
+#include "sparx5_main_regs.h"
+
+/* Target chip type */
+enum spx5_target_chiptype {
+	SPX5_TARGET_CT_7546    = 0x7546,  /* SparX-5-64  Enterprise */
+	SPX5_TARGET_CT_7549    = 0x7549,  /* SparX-5-90  Enterprise */
+	SPX5_TARGET_CT_7552    = 0x7552,  /* SparX-5-128 Enterprise */
+	SPX5_TARGET_CT_7556    = 0x7556,  /* SparX-5-160 Enterprise */
+	SPX5_TARGET_CT_7558    = 0x7558,  /* SparX-5-200 Enterprise */
+	SPX5_TARGET_CT_7546TSN = 0x47546, /* SparX-5-64i Industrial */
+	SPX5_TARGET_CT_7549TSN = 0x47549, /* SparX-5-90i Industrial */
+	SPX5_TARGET_CT_7552TSN = 0x47552, /* SparX-5-128i Industrial */
+	SPX5_TARGET_CT_7556TSN = 0x47556, /* SparX-5-160i Industrial */
+	SPX5_TARGET_CT_7558TSN = 0x47558, /* SparX-5-200i Industrial */
+};
+
+enum sparx5_port_max_tags {
+	SPX5_PORT_MAX_TAGS_NONE,  /* No extra tags allowed */
+	SPX5_PORT_MAX_TAGS_ONE,   /* Single tag allowed */
+	SPX5_PORT_MAX_TAGS_TWO    /* Single and double tag allowed */
+};
+
+enum sparx5_vlan_port_type {
+	SPX5_VLAN_PORT_TYPE_UNAWARE, /* VLAN unaware port */
+	SPX5_VLAN_PORT_TYPE_C,       /* C-port */
+	SPX5_VLAN_PORT_TYPE_S,       /* S-port */
+	SPX5_VLAN_PORT_TYPE_S_CUSTOM /* S-port using custom type */
+};
+
+#define SPX5_PORTS             65
+#define SPX5_PORT_CPU          (SPX5_PORTS)  /* Next port is CPU port */
+#define SPX5_PORT_CPU_0        (SPX5_PORT_CPU + 0) /* CPU Port 65 */
+#define SPX5_PORT_CPU_1        (SPX5_PORT_CPU + 1) /* CPU Port 66 */
+#define SPX5_PORT_VD0          (SPX5_PORT_CPU + 2) /* VD0/Port 67 used for IPMC */
+#define SPX5_PORT_VD1          (SPX5_PORT_CPU + 3) /* VD1/Port 68 used for AFI/OAM */
+#define SPX5_PORT_VD2          (SPX5_PORT_CPU + 4) /* VD2/Port 69 used for IPinIP*/
+#define SPX5_PORTS_ALL         (SPX5_PORT_CPU + 5) /* Total number of ports */
+
+#define PGID_BASE              SPX5_PORTS /* Starts after port PGIDs */
+#define PGID_UC_FLOOD          (PGID_BASE + 0)
+#define PGID_MC_FLOOD          (PGID_BASE + 1)
+#define PGID_IPV4_MC_DATA      (PGID_BASE + 2)
+#define PGID_IPV4_MC_CTRL      (PGID_BASE + 3)
+#define PGID_IPV6_MC_DATA      (PGID_BASE + 4)
+#define PGID_IPV6_MC_CTRL      (PGID_BASE + 5)
+#define PGID_BCAST	       (PGID_BASE + 6)
+#define PGID_CPU	       (PGID_BASE + 7)
+
+#define IFH_LEN                9 /* 36 bytes */
+#define NULL_VID               0
+#define SPX5_MACT_PULL_DELAY   (2 * HZ)
+#define SPX5_STATS_CHECK_DELAY (2 * HZ)
+#define SPX5_PRIOS             8     /* Number of priority queues */
+#define SPX5_BUFFER_CELL_SZ    184   /* Cell size  */
+#define SPX5_BUFFER_MEMORY     4194280 /* 22795 words * 184 bytes */
+
+struct sparx5;
+
+struct sparx5_port_config      {
+	phy_interface_t          portmode;
+	u32                      max_speed;
+	u32                      speed;
+	int                      duplex;
+	enum ethernet_media_type media_type;
+	bool                     power_down;
+	bool                     autoneg;
+	u32                      pause;
+	bool                     serdes_reset;
+	phy_interface_t          phy_mode;
+	u32                      sd_sgpio;
+};
+
+struct sparx5_port {
+	struct net_device          *ndev;
+	struct sparx5              *sparx5;
+	struct device_node         *of_node;
+	struct phy                 *serdes;
+	struct sparx5_port_config  conf;
+	struct phylink_config      phylink_config;
+	struct phylink             *phylink;
+	struct phylink_pcs         phylink_pcs;
+	u16                        portno;
+	/* Ingress default VLAN (pvid) */
+	u16                        pvid;
+	/* Egress default VLAN (vid) */
+	u16                        vid;
+	bool                       signd_internal;
+	bool                       signd_active_high;
+	bool                       signd_enable;
+	bool                       flow_control;
+	enum sparx5_port_max_tags  max_vlan_tags;
+	enum sparx5_vlan_port_type vlan_type;
+	u32                        custom_etype;
+	u32                        ifh[IFH_LEN];
+	bool                       vlan_aware;
+};
+
+enum sparx5_core_clockfreq {
+	SPX5_CORE_CLOCK_DEFAULT,  /* Defaults to the highest supported frequency */
+	SPX5_CORE_CLOCK_250MHZ,   /* 250MHZ core clock frequency */
+	SPX5_CORE_CLOCK_500MHZ,   /* 500MHZ core clock frequency */
+	SPX5_CORE_CLOCK_625MHZ,   /* 625MHZ core clock frequency */
+};
+
+struct sparx5 {
+	struct platform_device                *pdev;
+	struct device                         *dev;
+	u32                                   chip_id;
+	enum spx5_target_chiptype             target_ct;
+	void __iomem                          *regs[NUM_TARGETS];
+	int                                   port_count;
+	struct mutex                          lock;      /* MAC reg lock */
+	/* port structures are in net device */
+	struct sparx5_port                    *ports[SPX5_PORTS];
+	enum sparx5_core_clockfreq            coreclock;
+	/* Statistics */
+	u32                                   num_stats;
+	const char * const                    *stats_layout;
+	u64                                   *stats;
+	/* Workqueue for reading stats */
+	struct mutex                          stats_lock;
+	struct delayed_work                   stats_work;
+	struct workqueue_struct               *stats_queue;
+	/* Notifiers */
+	struct notifier_block                 netdevice_nb;
+	struct notifier_block                 switchdev_nb;
+	struct notifier_block                 switchdev_blocking_nb;
+	/* Switch state */
+	u8                                    base_mac[ETH_ALEN];
+	/* Associated bridge device (when bridged) */
+	struct net_device                     *hw_bridge_dev;
+	/* Bridged interfaces */
+	DECLARE_BITMAP(bridge_mask,           SPX5_PORTS);
+	DECLARE_BITMAP(bridge_fwd_mask,       SPX5_PORTS);
+	DECLARE_BITMAP(vlan_mask[VLAN_N_VID], SPX5_PORTS);
+	/* SW MAC table */
+	struct list_head                      mact_entries;
+	/* mac table list (mact_entries) mutex */
+	struct mutex                          mact_lock;
+	struct delayed_work                   mact_work;
+	struct workqueue_struct               *mact_queue;
+	/* Board specifics */
+	bool                                  sd_sgpio_remapping;
+};
+
+/* sparx5_main.c */
+void sparx5_update_cpuport_stats(struct sparx5 *sparx5, int portno);
+bool sparx5_is_cpuport_stat(struct sparx5 *sparx5, int idx);
+
+/* sparx5_switchdev.c */
+int sparx5_register_notifier_blocks(struct sparx5 *sparx5);
+void sparx5_unregister_notifier_blocks(struct sparx5 *sparx5);
+
+/* sparx5_packet.c */
+irqreturn_t sparx5_xtr_handler(int irq, void *_priv);
+int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev);
+void sparx5_manual_injection_mode(struct sparx5 *sparx5);
+
+/* sparx5_mactable.c */
+void sparx5_mact_pull_work(struct work_struct *work);
+int sparx5_mact_learn(struct sparx5 *sparx5, int port,
+		      const unsigned char mac[ETH_ALEN], u16 vid);
+bool sparx5_mact_getnext(struct sparx5 *sparx5,
+			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2);
+int sparx5_mact_forget(struct sparx5 *sparx5,
+		       const unsigned char mac[ETH_ALEN], u16 vid);
+int sparx5_add_mact_entry(struct sparx5 *sparx5,
+			  struct sparx5_port *port,
+			  const unsigned char *addr, u16 vid);
+int sparx5_del_mact_entry(struct sparx5 *sparx5,
+			  const unsigned char *addr,
+			  u16 vid);
+int sparx5_mc_sync(struct net_device *dev, const unsigned char *addr);
+int sparx5_mc_unsync(struct net_device *dev, const unsigned char *addr);
+void sparx5_set_ageing(struct sparx5 *sparx5, int msecs);
+void sparx5_mact_init(struct sparx5 *sparx5);
+
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
+/* sparx5_calendar.c */
+int sparx5_config_auto_calendar(struct sparx5 *sparx5);
+int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
+
+/* sparx5_ethtool.c */
+void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
+int sparx_stats_init(struct sparx5 *sparx5);
+
+/* sparx5_netdev.c */
+bool sparx5_netdevice_check(const struct net_device *dev);
+struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
+void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port);
+
+/* Clock period in picoseconds */
+static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
+{
+	switch (cclock) {
+	case SPX5_CORE_CLOCK_250MHZ:
+		return 4000;
+	case SPX5_CORE_CLOCK_500MHZ:
+		return 2000;
+	case SPX5_CORE_CLOCK_625MHZ:
+	default:
+		return 1600;
+	}
+}
+
+extern const struct phylink_mac_ops sparx5_phylink_mac_ops;
+extern const struct ethtool_ops sparx5_ethtool_ops;
+
+#endif	/* __SPARX5_MAIN_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
new file mode 100644
index 000000000000..cad13b8290ca
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
@@ -0,0 +1,3922 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ * Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc.
+ */
+
+/* This file is autogenerated by cml-utils 2020-11-19 10:41:34 +0100.
+ * Commit ID: f34790e69dc252103e2cc3e85b1a5e4d9e3aa190
+ */
+
+#ifndef _SPARX5_MAIN_REGS_H_
+#define _SPARX5_MAIN_REGS_H_
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+#include <linux/bug.h>
+
+enum sparx5_target {
+	TARGET_ANA_AC = 1,
+	TARGET_ANA_ACL = 2,
+	TARGET_ANA_AC_POL = 4,
+	TARGET_ANA_CL = 6,
+	TARGET_ANA_L2 = 7,
+	TARGET_ANA_L3 = 8,
+	TARGET_ASM = 9,
+	TARGET_CLKGEN = 11,
+	TARGET_DEV10G = 17,
+	TARGET_DEV25G = 29,
+	TARGET_DEV2G5 = 37,
+	TARGET_DEV5G = 102,
+	TARGET_DSM = 115,
+	TARGET_EACL = 116,
+	TARGET_GCB = 118,
+	TARGET_HSCH = 119,
+	TARGET_LRN = 122,
+	TARGET_PCS10G_BR = 132,
+	TARGET_PCS25G_BR = 144,
+	TARGET_PCS5G_BR = 160,
+	TARGET_PORT_CONF = 173,
+	TARGET_QFWD = 175,
+	TARGET_QRES = 176,
+	TARGET_QS = 177,
+	TARGET_QSYS = 178,
+	TARGET_REW = 179,
+	TARGET_VCAP_SUPER = 326,
+	TARGET_VOP = 327,
+	TARGET_XQS = 331,
+	NUM_TARGETS = 332
+};
+
+#define __REG(...)    __VA_ARGS__
+
+/*      ANA_AC:RAM_CTRL:RAM_INIT */
+#define ANA_AC_RAM_INIT           __REG(TARGET_ANA_AC, 0, 1, 839108, 0, 1, 4, 0, 0, 1, 4)
+
+#define ANA_AC_RAM_INIT_RAM_INIT                 BIT(1)
+#define ANA_AC_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(ANA_AC_RAM_INIT_RAM_INIT, x)
+#define ANA_AC_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(ANA_AC_RAM_INIT_RAM_INIT, x)
+
+#define ANA_AC_RAM_INIT_RAM_CFG_HOOK             BIT(0)
+#define ANA_AC_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(ANA_AC_RAM_INIT_RAM_CFG_HOOK, x)
+#define ANA_AC_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(ANA_AC_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      ANA_AC:PS_COMMON:OWN_UPSID */
+#define ANA_AC_OWN_UPSID(r)       __REG(TARGET_ANA_AC, 0, 1, 894472, 0, 1, 352, 52, r, 3, 4)
+
+#define ANA_AC_OWN_UPSID_OWN_UPSID               GENMASK(4, 0)
+#define ANA_AC_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_AC_OWN_UPSID_OWN_UPSID, x)
+#define ANA_AC_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_AC_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_AC:SRC:SRC_CFG */
+#define ANA_AC_SRC_CFG(g)         __REG(TARGET_ANA_AC, 0, 1, 849920, g, 102, 16, 0, 0, 1, 4)
+
+/*      ANA_AC:SRC:SRC_CFG1 */
+#define ANA_AC_SRC_CFG1(g)        __REG(TARGET_ANA_AC, 0, 1, 849920, g, 102, 16, 4, 0, 1, 4)
+
+/*      ANA_AC:SRC:SRC_CFG2 */
+#define ANA_AC_SRC_CFG2(g)        __REG(TARGET_ANA_AC, 0, 1, 849920, g, 102, 16, 8, 0, 1, 4)
+
+#define ANA_AC_SRC_CFG2_PORT_MASK2               BIT(0)
+#define ANA_AC_SRC_CFG2_PORT_MASK2_SET(x)\
+	FIELD_PREP(ANA_AC_SRC_CFG2_PORT_MASK2, x)
+#define ANA_AC_SRC_CFG2_PORT_MASK2_GET(x)\
+	FIELD_GET(ANA_AC_SRC_CFG2_PORT_MASK2, x)
+
+/*      ANA_AC:PGID:PGID_CFG */
+#define ANA_AC_PGID_CFG(g)        __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 0, 0, 1, 4)
+
+/*      ANA_AC:PGID:PGID_CFG1 */
+#define ANA_AC_PGID_CFG1(g)       __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 4, 0, 1, 4)
+
+/*      ANA_AC:PGID:PGID_CFG2 */
+#define ANA_AC_PGID_CFG2(g)       __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 8, 0, 1, 4)
+
+#define ANA_AC_PGID_CFG2_PORT_MASK2              BIT(0)
+#define ANA_AC_PGID_CFG2_PORT_MASK2_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_CFG2_PORT_MASK2, x)
+#define ANA_AC_PGID_CFG2_PORT_MASK2_GET(x)\
+	FIELD_GET(ANA_AC_PGID_CFG2_PORT_MASK2, x)
+
+/*      ANA_AC:PGID:PGID_MISC_CFG */
+#define ANA_AC_PGID_MISC_CFG(g)   __REG(TARGET_ANA_AC, 0, 1, 786432, g, 3290, 16, 12, 0, 1, 4)
+
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_QU         GENMASK(6, 4)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_QU_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_MISC_CFG_PGID_CPU_QU, x)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_QU_GET(x)\
+	FIELD_GET(ANA_AC_PGID_MISC_CFG_PGID_CPU_QU, x)
+
+#define ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA      BIT(1)
+#define ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA, x)
+#define ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA_GET(x)\
+	FIELD_GET(ANA_AC_PGID_MISC_CFG_STACK_TYPE_ENA, x)
+
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA   BIT(0)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, x)
+#define ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_GET(x)\
+	FIELD_GET(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, x)
+
+/*      ANA_AC:STAT_GLOBAL_CFG_PORT:STAT_RESET */
+#define ANA_AC_STAT_RESET         __REG(TARGET_ANA_AC, 0, 1, 851552, 0, 1, 20, 16, 0, 1, 4)
+
+#define ANA_AC_STAT_RESET_RESET                  BIT(0)
+#define ANA_AC_STAT_RESET_RESET_SET(x)\
+	FIELD_PREP(ANA_AC_STAT_RESET_RESET, x)
+#define ANA_AC_STAT_RESET_RESET_GET(x)\
+	FIELD_GET(ANA_AC_STAT_RESET_RESET, x)
+
+/*      ANA_AC:STAT_CNT_CFG_PORT:STAT_LSB_CNT */
+#define ANA_AC_PORT_STAT_LSB_CNT(g, r) __REG(TARGET_ANA_AC, 0, 1, 843776, g, 70, 64, 20, r, 4, 4)
+
+/*      ANA_ACL:COMMON:OWN_UPSID */
+#define ANA_ACL_OWN_UPSID(r)      __REG(TARGET_ANA_ACL, 0, 1, 32768, 0, 1, 592, 580, r, 3, 4)
+
+#define ANA_ACL_OWN_UPSID_OWN_UPSID              GENMASK(4, 0)
+#define ANA_ACL_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_ACL_OWN_UPSID_OWN_UPSID, x)
+#define ANA_ACL_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_ACL_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_AC_POL:POL_ALL_CFG:POL_UPD_INT_CFG */
+#define ANA_AC_POL_POL_UPD_INT_CFG __REG(TARGET_ANA_AC_POL, 0, 1, 75968, 0, 1, 1160, 1148, 0, 1, 4)
+
+#define ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT   GENMASK(9, 0)
+#define ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_SET(x)\
+	FIELD_PREP(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT, x)
+#define ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT_GET(x)\
+	FIELD_GET(ANA_AC_POL_POL_UPD_INT_CFG_POL_UPD_INT, x)
+
+/*      ANA_AC_POL:COMMON_BDLB:DLB_CTRL */
+#define ANA_AC_POL_BDLB_DLB_CTRL  __REG(TARGET_ANA_AC_POL, 0, 1, 79048, 0, 1, 8, 0, 0, 1, 4)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS GENMASK(26, 19)
+#define ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT   GENMASK(18, 4)
+#define ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_BASE_TICK_CNT, x)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA        BIT(1)
+#define ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_LEAK_ENA, x)
+
+#define ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA     BIT(0)
+#define ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA, x)
+#define ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_BDLB_DLB_CTRL_DLB_ADD_ENA, x)
+
+/*      ANA_AC_POL:COMMON_BUM_SLB:DLB_CTRL */
+#define ANA_AC_POL_SLB_DLB_CTRL   __REG(TARGET_ANA_AC_POL, 0, 1, 79056, 0, 1, 20, 0, 0, 1, 4)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS  GENMASK(26, 19)
+#define ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_CLK_PERIOD_01NS, x)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT    GENMASK(18, 4)
+#define ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_BASE_TICK_CNT, x)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA         BIT(1)
+#define ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_LEAK_ENA, x)
+
+#define ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA      BIT(0)
+#define ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA_SET(x)\
+	FIELD_PREP(ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA, x)
+#define ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA_GET(x)\
+	FIELD_GET(ANA_AC_POL_SLB_DLB_CTRL_DLB_ADD_ENA, x)
+
+/*      ANA_CL:PORT:FILTER_CTRL */
+#define ANA_CL_FILTER_CTRL(g)     __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 4, 0, 1, 4)
+
+#define ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS    BIT(2)
+#define ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS, x)
+#define ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS_GET(x)\
+	FIELD_GET(ANA_CL_FILTER_CTRL_FILTER_SMAC_MC_DIS, x)
+
+#define ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS   BIT(1)
+#define ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS, x)
+#define ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS_GET(x)\
+	FIELD_GET(ANA_CL_FILTER_CTRL_FILTER_NULL_MAC_DIS, x)
+
+#define ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA  BIT(0)
+#define ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA, x)
+#define ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA_GET(x)\
+	FIELD_GET(ANA_CL_FILTER_CTRL_FORCE_FCS_UPDATE_ENA, x)
+
+/*      ANA_CL:PORT:VLAN_FILTER_CTRL */
+#define ANA_CL_VLAN_FILTER_CTRL(g, r) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 8, r, 3, 4)
+
+#define ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA BIT(10)
+#define ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA, x)
+#define ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS    BIT(9)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS         BIT(8)
+#define ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CTAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS    BIT(7)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS BIT(6)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST1_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS BIT(5)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST2_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS BIT(4)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_PRIO_CUST3_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_STAG_DIS         BIT(3)
+#define ANA_CL_VLAN_FILTER_CTRL_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS   BIT(2)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CUST1_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS   BIT(1)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CUST2_STAG_DIS, x)
+
+#define ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS   BIT(0)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS, x)
+#define ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_FILTER_CTRL_CUST3_STAG_DIS, x)
+
+/*      ANA_CL:PORT:ETAG_FILTER_CTRL */
+#define ANA_CL_ETAG_FILTER_CTRL(g) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 20, 0, 1, 4)
+
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA BIT(1)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA, x)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA_GET(x)\
+	FIELD_GET(ANA_CL_ETAG_FILTER_CTRL_ETAG_REQUIRED_ENA, x)
+
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS         BIT(0)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS, x)
+#define ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS_GET(x)\
+	FIELD_GET(ANA_CL_ETAG_FILTER_CTRL_ETAG_DIS, x)
+
+/*      ANA_CL:PORT:VLAN_CTRL */
+#define ANA_CL_VLAN_CTRL(g)       __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 32, 0, 1, 4)
+
+#define ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS GENMASK(30, 26)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS, x)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VOE_TPID_AWARE_DIS, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP    GENMASK(25, 23)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP, x)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_PCP, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI    BIT(22)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI, x)
+#define ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VOE_DEFAULT_DEI, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA  BIT(21)
+#define ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA, x)
+#define ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_PCP_DEI_TRANS_ENA, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_TAG_SEL            BIT(20)
+#define ANA_CL_VLAN_CTRL_VLAN_TAG_SEL_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_TAG_SEL, x)
+#define ANA_CL_VLAN_CTRL_VLAN_TAG_SEL_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_TAG_SEL, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA          BIT(19)
+#define ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA, x)
+#define ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA, x)
+
+#define ANA_CL_VLAN_CTRL_VLAN_POP_CNT            GENMASK(18, 17)
+#define ANA_CL_VLAN_CTRL_VLAN_POP_CNT_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_VLAN_POP_CNT, x)
+#define ANA_CL_VLAN_CTRL_VLAN_POP_CNT_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_VLAN_POP_CNT, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_TAG_TYPE           BIT(16)
+#define ANA_CL_VLAN_CTRL_PORT_TAG_TYPE_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_TAG_TYPE, x)
+#define ANA_CL_VLAN_CTRL_PORT_TAG_TYPE_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_TAG_TYPE, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_PCP                GENMASK(15, 13)
+#define ANA_CL_VLAN_CTRL_PORT_PCP_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_PCP, x)
+#define ANA_CL_VLAN_CTRL_PORT_PCP_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_PCP, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_DEI                BIT(12)
+#define ANA_CL_VLAN_CTRL_PORT_DEI_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_DEI, x)
+#define ANA_CL_VLAN_CTRL_PORT_DEI_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_DEI, x)
+
+#define ANA_CL_VLAN_CTRL_PORT_VID                GENMASK(11, 0)
+#define ANA_CL_VLAN_CTRL_PORT_VID_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_PORT_VID, x)
+#define ANA_CL_VLAN_CTRL_PORT_VID_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_PORT_VID, x)
+
+/*      ANA_CL:PORT:VLAN_CTRL_2 */
+#define ANA_CL_VLAN_CTRL_2(g)     __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 36, 0, 1, 4)
+
+#define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT         GENMASK(1, 0)
+#define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT_SET(x)\
+	FIELD_PREP(ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT, x)
+#define ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT_GET(x)\
+	FIELD_GET(ANA_CL_VLAN_CTRL_2_VLAN_PUSH_CNT, x)
+
+/*      ANA_CL:PORT:CAPTURE_BPDU_CFG */
+#define ANA_CL_CAPTURE_BPDU_CFG(g) __REG(TARGET_ANA_CL, 0, 1, 131072, g, 70, 512, 196, 0, 1, 4)
+
+/*      ANA_CL:COMMON:OWN_UPSID */
+#define ANA_CL_OWN_UPSID(r)       __REG(TARGET_ANA_CL, 0, 1, 166912, 0, 1, 756, 0, r, 3, 4)
+
+#define ANA_CL_OWN_UPSID_OWN_UPSID               GENMASK(4, 0)
+#define ANA_CL_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_CL_OWN_UPSID_OWN_UPSID, x)
+#define ANA_CL_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_CL_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_L2:COMMON:AUTO_LRN_CFG */
+#define ANA_L2_AUTO_LRN_CFG       __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 24, 0, 1, 4)
+
+/*      ANA_L2:COMMON:AUTO_LRN_CFG1 */
+#define ANA_L2_AUTO_LRN_CFG1      __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 28, 0, 1, 4)
+
+/*      ANA_L2:COMMON:AUTO_LRN_CFG2 */
+#define ANA_L2_AUTO_LRN_CFG2      __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 32, 0, 1, 4)
+
+#define ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2       BIT(0)
+#define ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2_SET(x)\
+	FIELD_PREP(ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2, x)
+#define ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2_GET(x)\
+	FIELD_GET(ANA_L2_AUTO_LRN_CFG2_AUTO_LRN_ENA2, x)
+
+/*      ANA_L2:COMMON:OWN_UPSID */
+#define ANA_L2_OWN_UPSID(r)       __REG(TARGET_ANA_L2, 0, 1, 566024, 0, 1, 700, 672, r, 3, 4)
+
+#define ANA_L2_OWN_UPSID_OWN_UPSID               GENMASK(4, 0)
+#define ANA_L2_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(ANA_L2_OWN_UPSID_OWN_UPSID, x)
+#define ANA_L2_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(ANA_L2_OWN_UPSID_OWN_UPSID, x)
+
+/*      ANA_L3:COMMON:VLAN_CTRL */
+#define ANA_L3_VLAN_CTRL          __REG(TARGET_ANA_L3, 0, 1, 493632, 0, 1, 184, 4, 0, 1, 4)
+
+#define ANA_L3_VLAN_CTRL_VLAN_ENA                BIT(0)
+#define ANA_L3_VLAN_CTRL_VLAN_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CTRL_VLAN_ENA, x)
+#define ANA_L3_VLAN_CTRL_VLAN_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CTRL_VLAN_ENA, x)
+
+/*      ANA_L3:VLAN:VLAN_CFG */
+#define ANA_L3_VLAN_CFG(g)        __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 8, 0, 1, 4)
+
+#define ANA_L3_VLAN_CFG_VLAN_MSTP_PTR            GENMASK(30, 24)
+#define ANA_L3_VLAN_CFG_VLAN_MSTP_PTR_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_MSTP_PTR, x)
+#define ANA_L3_VLAN_CFG_VLAN_MSTP_PTR_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_MSTP_PTR, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_FID                 GENMASK(20, 8)
+#define ANA_L3_VLAN_CFG_VLAN_FID_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_FID, x)
+#define ANA_L3_VLAN_CFG_VLAN_FID_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_FID, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA      BIT(6)
+#define ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_IGR_FILTER_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA         BIT(5)
+#define ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_SEC_FWD_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS           BIT(4)
+#define ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS, x)
+#define ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_FLOOD_DIS, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_LRN_DIS             BIT(3)
+#define ANA_L3_VLAN_CFG_VLAN_LRN_DIS_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_LRN_DIS, x)
+#define ANA_L3_VLAN_CFG_VLAN_LRN_DIS_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_LRN_DIS, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_RLEG_ENA            BIT(2)
+#define ANA_L3_VLAN_CFG_VLAN_RLEG_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_RLEG_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_RLEG_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_RLEG_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA         BIT(1)
+#define ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_PRIVATE_ENA, x)
+
+#define ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA          BIT(0)
+#define ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA, x)
+#define ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_CFG_VLAN_MIRROR_ENA, x)
+
+/*      ANA_L3:VLAN:VLAN_MASK_CFG */
+#define ANA_L3_VLAN_MASK_CFG(g)   __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 16, 0, 1, 4)
+
+/*      ANA_L3:VLAN:VLAN_MASK_CFG1 */
+#define ANA_L3_VLAN_MASK_CFG1(g)  __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 20, 0, 1, 4)
+
+/*      ANA_L3:VLAN:VLAN_MASK_CFG2 */
+#define ANA_L3_VLAN_MASK_CFG2(g)  __REG(TARGET_ANA_L3, 0, 1, 0, g, 5120, 64, 24, 0, 1, 4)
+
+#define ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2    BIT(0)
+#define ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2_SET(x)\
+	FIELD_PREP(ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2, x)
+#define ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2_GET(x)\
+	FIELD_GET(ANA_L3_VLAN_MASK_CFG2_VLAN_PORT_MASK2, x)
+
+/*      ASM:DEV_STATISTICS:RX_IN_BYTES_CNT */
+#define ASM_RX_IN_BYTES_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 0, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SYMBOL_ERR_CNT */
+#define ASM_RX_SYMBOL_ERR_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 4, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_PAUSE_CNT */
+#define ASM_RX_PAUSE_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 8, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_OK_BYTES_CNT */
+#define ASM_RX_OK_BYTES_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 16, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_BAD_BYTES_CNT */
+#define ASM_RX_BAD_BYTES_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 20, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_UC_CNT */
+#define ASM_RX_UC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 24, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_MC_CNT */
+#define ASM_RX_MC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 28, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_BC_CNT */
+#define ASM_RX_BC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 32, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_CRC_ERR_CNT */
+#define ASM_RX_CRC_ERR_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 36, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_UNDERSIZE_CNT */
+#define ASM_RX_UNDERSIZE_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 40, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_FRAGMENTS_CNT */
+#define ASM_RX_FRAGMENTS_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 44, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_IN_RANGE_LEN_ERR_CNT */
+#define ASM_RX_IN_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 48, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define ASM_RX_OUT_OF_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 52, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_OVERSIZE_CNT */
+#define ASM_RX_OVERSIZE_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 56, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_JABBERS_CNT */
+#define ASM_RX_JABBERS_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 60, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE64_CNT */
+#define ASM_RX_SIZE64_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 64, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE65TO127_CNT */
+#define ASM_RX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 68, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE128TO255_CNT */
+#define ASM_RX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 72, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE256TO511_CNT */
+#define ASM_RX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 76, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE512TO1023_CNT */
+#define ASM_RX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 80, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE1024TO1518_CNT */
+#define ASM_RX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 84, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:RX_SIZE1519TOMAX_CNT */
+#define ASM_RX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 88, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_OUT_BYTES_CNT */
+#define ASM_TX_OUT_BYTES_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 96, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_PAUSE_CNT */
+#define ASM_TX_PAUSE_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 100, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_OK_BYTES_CNT */
+#define ASM_TX_OK_BYTES_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 104, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_UC_CNT */
+#define ASM_TX_UC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 108, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_MC_CNT */
+#define ASM_TX_MC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 112, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_BC_CNT */
+#define ASM_TX_BC_CNT(g)          __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 116, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE64_CNT */
+#define ASM_TX_SIZE64_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 120, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE65TO127_CNT */
+#define ASM_TX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 124, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE128TO255_CNT */
+#define ASM_TX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 128, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE256TO511_CNT */
+#define ASM_TX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 132, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE512TO1023_CNT */
+#define ASM_TX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 136, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE1024TO1518_CNT */
+#define ASM_TX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 140, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_SIZE1519TOMAX_CNT */
+#define ASM_TX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 144, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SYMBOL_ERR_CNT */
+#define ASM_PMAC_RX_SYMBOL_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 168, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_PAUSE_CNT */
+#define ASM_PMAC_RX_PAUSE_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 172, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_UNSUP_OPCODE_CNT */
+#define ASM_PMAC_RX_UNSUP_OPCODE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 176, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OK_BYTES_CNT */
+#define ASM_PMAC_RX_OK_BYTES_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 180, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_BAD_BYTES_CNT */
+#define ASM_PMAC_RX_BAD_BYTES_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 184, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_UC_CNT */
+#define ASM_PMAC_RX_UC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 188, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_MC_CNT */
+#define ASM_PMAC_RX_MC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 192, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_BC_CNT */
+#define ASM_PMAC_RX_BC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 196, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_CRC_ERR_CNT */
+#define ASM_PMAC_RX_CRC_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 200, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_UNDERSIZE_CNT */
+#define ASM_PMAC_RX_UNDERSIZE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 204, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_FRAGMENTS_CNT */
+#define ASM_PMAC_RX_FRAGMENTS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 208, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_IN_RANGE_LEN_ERR_CNT */
+#define ASM_PMAC_RX_IN_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 212, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define ASM_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 216, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_OVERSIZE_CNT */
+#define ASM_PMAC_RX_OVERSIZE_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 220, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_JABBERS_CNT */
+#define ASM_PMAC_RX_JABBERS_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 224, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE64_CNT */
+#define ASM_PMAC_RX_SIZE64_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 228, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE65TO127_CNT */
+#define ASM_PMAC_RX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 232, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE128TO255_CNT */
+#define ASM_PMAC_RX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 236, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE256TO511_CNT */
+#define ASM_PMAC_RX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 240, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE512TO1023_CNT */
+#define ASM_PMAC_RX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 244, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE1024TO1518_CNT */
+#define ASM_PMAC_RX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 248, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_RX_SIZE1519TOMAX_CNT */
+#define ASM_PMAC_RX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 252, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_PAUSE_CNT */
+#define ASM_PMAC_TX_PAUSE_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 256, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_OK_BYTES_CNT */
+#define ASM_PMAC_TX_OK_BYTES_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 260, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_UC_CNT */
+#define ASM_PMAC_TX_UC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 264, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_MC_CNT */
+#define ASM_PMAC_TX_MC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 268, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_BC_CNT */
+#define ASM_PMAC_TX_BC_CNT(g)     __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 272, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE64_CNT */
+#define ASM_PMAC_TX_SIZE64_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 276, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE65TO127_CNT */
+#define ASM_PMAC_TX_SIZE65TO127_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 280, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE128TO255_CNT */
+#define ASM_PMAC_TX_SIZE128TO255_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 284, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE256TO511_CNT */
+#define ASM_PMAC_TX_SIZE256TO511_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 288, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE512TO1023_CNT */
+#define ASM_PMAC_TX_SIZE512TO1023_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 292, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE1024TO1518_CNT */
+#define ASM_PMAC_TX_SIZE1024TO1518_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 296, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:PMAC_TX_SIZE1519TOMAX_CNT */
+#define ASM_PMAC_TX_SIZE1519TOMAX_CNT(g) __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 300, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_MULTI_COLL_CNT */
+#define ASM_TX_MULTI_COLL_CNT(g)  __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 328, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_LATE_COLL_CNT */
+#define ASM_TX_LATE_COLL_CNT(g)   __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 332, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_XCOLL_CNT */
+#define ASM_TX_XCOLL_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 336, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_DEFER_CNT */
+#define ASM_TX_DEFER_CNT(g)       __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 340, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_XDEFER_CNT */
+#define ASM_TX_XDEFER_CNT(g)      __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 344, 0, 1, 4)
+
+/*      ASM:DEV_STATISTICS:TX_BACKOFF1_CNT */
+#define ASM_TX_BACKOFF1_CNT(g)    __REG(TARGET_ASM, 0, 1, 0, g, 65, 512, 348, 0, 1, 4)
+
+/*      ASM:CFG:STAT_CFG */
+#define ASM_STAT_CFG              __REG(TARGET_ASM, 0, 1, 33280, 0, 1, 1088, 0, 0, 1, 4)
+
+#define ASM_STAT_CFG_STAT_CNT_CLR_SHOT           BIT(0)
+#define ASM_STAT_CFG_STAT_CNT_CLR_SHOT_SET(x)\
+	FIELD_PREP(ASM_STAT_CFG_STAT_CNT_CLR_SHOT, x)
+#define ASM_STAT_CFG_STAT_CNT_CLR_SHOT_GET(x)\
+	FIELD_GET(ASM_STAT_CFG_STAT_CNT_CLR_SHOT, x)
+
+/*      ASM:CFG:PORT_CFG */
+#define ASM_PORT_CFG(r)           __REG(TARGET_ASM, 0, 1, 33280, 0, 1, 1088, 540, r, 67, 4)
+
+#define ASM_PORT_CFG_CSC_STAT_DIS                BIT(12)
+#define ASM_PORT_CFG_CSC_STAT_DIS_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_CSC_STAT_DIS, x)
+#define ASM_PORT_CFG_CSC_STAT_DIS_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_CSC_STAT_DIS, x)
+
+#define ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA      BIT(11)
+#define ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA, x)
+#define ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_HIH_AFTER_PREAMBLE_ENA, x)
+
+#define ASM_PORT_CFG_IGN_TAXI_ABORT_ENA          BIT(10)
+#define ASM_PORT_CFG_IGN_TAXI_ABORT_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_IGN_TAXI_ABORT_ENA, x)
+#define ASM_PORT_CFG_IGN_TAXI_ABORT_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_IGN_TAXI_ABORT_ENA, x)
+
+#define ASM_PORT_CFG_NO_PREAMBLE_ENA             BIT(9)
+#define ASM_PORT_CFG_NO_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_NO_PREAMBLE_ENA, x)
+#define ASM_PORT_CFG_NO_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_NO_PREAMBLE_ENA, x)
+
+#define ASM_PORT_CFG_SKIP_PREAMBLE_ENA           BIT(8)
+#define ASM_PORT_CFG_SKIP_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_SKIP_PREAMBLE_ENA, x)
+#define ASM_PORT_CFG_SKIP_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_SKIP_PREAMBLE_ENA, x)
+
+#define ASM_PORT_CFG_FRM_AGING_DIS               BIT(7)
+#define ASM_PORT_CFG_FRM_AGING_DIS_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_FRM_AGING_DIS, x)
+#define ASM_PORT_CFG_FRM_AGING_DIS_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_FRM_AGING_DIS, x)
+
+#define ASM_PORT_CFG_PAD_ENA                     BIT(6)
+#define ASM_PORT_CFG_PAD_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_PAD_ENA, x)
+#define ASM_PORT_CFG_PAD_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_PAD_ENA, x)
+
+#define ASM_PORT_CFG_INJ_DISCARD_CFG             GENMASK(5, 4)
+#define ASM_PORT_CFG_INJ_DISCARD_CFG_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_INJ_DISCARD_CFG, x)
+#define ASM_PORT_CFG_INJ_DISCARD_CFG_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_INJ_DISCARD_CFG, x)
+
+#define ASM_PORT_CFG_INJ_FORMAT_CFG              GENMASK(3, 2)
+#define ASM_PORT_CFG_INJ_FORMAT_CFG_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_INJ_FORMAT_CFG, x)
+#define ASM_PORT_CFG_INJ_FORMAT_CFG_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_INJ_FORMAT_CFG, x)
+
+#define ASM_PORT_CFG_VSTAX2_AWR_ENA              BIT(1)
+#define ASM_PORT_CFG_VSTAX2_AWR_ENA_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_VSTAX2_AWR_ENA, x)
+#define ASM_PORT_CFG_VSTAX2_AWR_ENA_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_VSTAX2_AWR_ENA, x)
+
+#define ASM_PORT_CFG_PFRM_FLUSH                  BIT(0)
+#define ASM_PORT_CFG_PFRM_FLUSH_SET(x)\
+	FIELD_PREP(ASM_PORT_CFG_PFRM_FLUSH, x)
+#define ASM_PORT_CFG_PFRM_FLUSH_GET(x)\
+	FIELD_GET(ASM_PORT_CFG_PFRM_FLUSH, x)
+
+/*      ASM:RAM_CTRL:RAM_INIT */
+#define ASM_RAM_INIT              __REG(TARGET_ASM, 0, 1, 34832, 0, 1, 4, 0, 0, 1, 4)
+
+#define ASM_RAM_INIT_RAM_INIT                    BIT(1)
+#define ASM_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(ASM_RAM_INIT_RAM_INIT, x)
+#define ASM_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(ASM_RAM_INIT_RAM_INIT, x)
+
+#define ASM_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define ASM_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(ASM_RAM_INIT_RAM_CFG_HOOK, x)
+#define ASM_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(ASM_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      CLKGEN:LCPLL1:LCPLL1_CORE_CLK_CFG */
+#define CLKGEN_LCPLL1_CORE_CLK_CFG __REG(TARGET_CLKGEN, 0, 1, 12, 0, 1, 36, 0, 0, 1, 4)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV  GENMASK(7, 0)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_DIV, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV  GENMASK(10, 8)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_PRE_DIV, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR  BIT(11)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_DIR, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL  GENMASK(13, 12)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_SEL, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA  BIT(14)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_ROT_ENA, x)
+
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA  BIT(15)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA_SET(x)\
+	FIELD_PREP(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA, x)
+#define CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA_GET(x)\
+	FIELD_GET(CLKGEN_LCPLL1_CORE_CLK_CFG_CORE_CLK_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV10G_MAC_ENA_CFG(t)     __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 0, 0, 1, 4)
+
+#define DEV10G_MAC_ENA_CFG_RX_ENA                BIT(4)
+#define DEV10G_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ENA_CFG_RX_ENA, x)
+#define DEV10G_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV10G_MAC_ENA_CFG_TX_ENA                BIT(0)
+#define DEV10G_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ENA_CFG_TX_ENA, x)
+#define DEV10G_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV10G_MAC_MAXLEN_CFG(t)  __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 8, 0, 1, 4)
+
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK    BIT(16)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(x)\
+	FIELD_PREP(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_GET(x)\
+	FIELD_GET(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN            GENMASK(15, 0)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV10G_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV10G_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV10G_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_NUM_TAGS_CFG */
+#define DEV10G_MAC_NUM_TAGS_CFG(t) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 12, 0, 1, 4)
+
+#define DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS         GENMASK(1, 0)
+#define DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS_SET(x)\
+	FIELD_PREP(DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS, x)
+#define DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS_GET(x)\
+	FIELD_GET(DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_TAGS_CFG */
+#define DEV10G_MAC_TAGS_CFG(t, r) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 16, r, 3, 4)
+
+#define DEV10G_MAC_TAGS_CFG_TAG_ID               GENMASK(31, 16)
+#define DEV10G_MAC_TAGS_CFG_TAG_ID_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TAGS_CFG_TAG_ID, x)
+#define DEV10G_MAC_TAGS_CFG_TAG_ID_GET(x)\
+	FIELD_GET(DEV10G_MAC_TAGS_CFG_TAG_ID, x)
+
+#define DEV10G_MAC_TAGS_CFG_TAG_ENA              BIT(4)
+#define DEV10G_MAC_TAGS_CFG_TAG_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TAGS_CFG_TAG_ENA, x)
+#define DEV10G_MAC_TAGS_CFG_TAG_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_TAGS_CFG_TAG_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV10G_MAC_ADV_CHK_CFG(t) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 28, 0, 1, 4)
+
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA   BIT(24)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA   BIT(20)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA       BIT(16)
+#define DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS   BIT(12)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA       BIT(8)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA       BIT(4)
+#define DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+
+#define DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA       BIT(0)
+#define DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+#define DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV10G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_TX_MONITOR_STICKY */
+#define DEV10G_MAC_TX_MONITOR_STICKY(t) __REG(TARGET_DEV10G, t, 12, 0, 0, 1, 60, 48, 0, 1, 4)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY BIT(4)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_LOCAL_ERR_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY BIT(3)
+#define DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_REMOTE_ERR_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY BIT(2)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_LINK_INTERRUPTION_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY BIT(1)
+#define DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY, x)
+
+#define DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY BIT(0)
+#define DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY_SET(x)\
+	FIELD_PREP(DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY, x)
+#define DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY_GET(x)\
+	FIELD_GET(DEV10G_MAC_TX_MONITOR_STICKY_DIS_STATE_STICKY, x)
+
+/*      DEV10G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV10G_DEV_RST_CTRL(t)    __REG(TARGET_DEV10G, t, 12, 436, 0, 1, 52, 0, 0, 1, 4)
+
+#define DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA      BIT(28)
+#define DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+#define DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+
+#define DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(27)
+#define DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS GENMASK(26, 25)
+#define DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+#define DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+
+#define DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL     GENMASK(24, 23)
+#define DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+#define DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+
+#define DEV10G_DEV_RST_CTRL_SPEED_SEL            GENMASK(22, 20)
+#define DEV10G_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV10G_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV10G_DEV_RST_CTRL_PCS_TX_RST           BIT(12)
+#define DEV10G_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV10G_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV10G_DEV_RST_CTRL_PCS_RX_RST           BIT(8)
+#define DEV10G_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV10G_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV10G_DEV_RST_CTRL_MAC_TX_RST           BIT(4)
+#define DEV10G_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV10G_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV10G_DEV_RST_CTRL_MAC_RX_RST           BIT(0)
+#define DEV10G_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV10G_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV10G_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV10G_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DEV10G:PCS25G_CFG_STATUS:PCS25G_CFG */
+#define DEV10G_PCS25G_CFG(t)      __REG(TARGET_DEV10G, t, 12, 488, 0, 1, 32, 0, 0, 1, 4)
+
+#define DEV10G_PCS25G_CFG_PCS25G_ENA             BIT(0)
+#define DEV10G_PCS25G_CFG_PCS25G_ENA_SET(x)\
+	FIELD_PREP(DEV10G_PCS25G_CFG_PCS25G_ENA, x)
+#define DEV10G_PCS25G_CFG_PCS25G_ENA_GET(x)\
+	FIELD_GET(DEV10G_PCS25G_CFG_PCS25G_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV25G_MAC_ENA_CFG(t)     __REG(TARGET_DEV25G, t, 8, 0, 0, 1, 60, 0, 0, 1, 4)
+
+#define DEV25G_MAC_ENA_CFG_RX_ENA                BIT(4)
+#define DEV25G_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ENA_CFG_RX_ENA, x)
+#define DEV25G_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV25G_MAC_ENA_CFG_TX_ENA                BIT(0)
+#define DEV25G_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ENA_CFG_TX_ENA, x)
+#define DEV25G_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV25G_MAC_MAXLEN_CFG(t)  __REG(TARGET_DEV25G, t, 8, 0, 0, 1, 60, 8, 0, 1, 4)
+
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK    BIT(16)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(x)\
+	FIELD_PREP(DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_GET(x)\
+	FIELD_GET(DEV25G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN            GENMASK(15, 0)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV25G_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV25G_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV25G_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV25G_MAC_ADV_CHK_CFG(t) __REG(TARGET_DEV25G, t, 8, 0, 0, 1, 60, 28, 0, 1, 4)
+
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA   BIT(24)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA   BIT(20)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA       BIT(16)
+#define DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS   BIT(12)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA       BIT(8)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA       BIT(4)
+#define DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+
+#define DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA       BIT(0)
+#define DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+#define DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV25G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+
+/*      DEV10G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV25G_DEV_RST_CTRL(t)    __REG(TARGET_DEV25G, t, 8, 436, 0, 1, 52, 0, 0, 1, 4)
+
+#define DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA      BIT(28)
+#define DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+#define DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+
+#define DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(27)
+#define DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS GENMASK(26, 25)
+#define DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+#define DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+
+#define DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL     GENMASK(24, 23)
+#define DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+#define DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+
+#define DEV25G_DEV_RST_CTRL_SPEED_SEL            GENMASK(22, 20)
+#define DEV25G_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV25G_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV25G_DEV_RST_CTRL_PCS_TX_RST           BIT(12)
+#define DEV25G_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV25G_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV25G_DEV_RST_CTRL_PCS_RX_RST           BIT(8)
+#define DEV25G_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV25G_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV25G_DEV_RST_CTRL_MAC_TX_RST           BIT(4)
+#define DEV25G_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV25G_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV25G_DEV_RST_CTRL_MAC_RX_RST           BIT(0)
+#define DEV25G_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV25G_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV25G_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV25G_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DEV10G:PCS25G_CFG_STATUS:PCS25G_CFG */
+#define DEV25G_PCS25G_CFG(t)      __REG(TARGET_DEV25G, t, 8, 488, 0, 1, 32, 0, 0, 1, 4)
+
+#define DEV25G_PCS25G_CFG_PCS25G_ENA             BIT(0)
+#define DEV25G_PCS25G_CFG_PCS25G_ENA_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_CFG_PCS25G_ENA, x)
+#define DEV25G_PCS25G_CFG_PCS25G_ENA_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_CFG_PCS25G_ENA, x)
+
+/*      DEV10G:PCS25G_CFG_STATUS:PCS25G_SD_CFG */
+#define DEV25G_PCS25G_SD_CFG(t)   __REG(TARGET_DEV25G, t, 8, 488, 0, 1, 32, 4, 0, 1, 4)
+
+#define DEV25G_PCS25G_SD_CFG_SD_SEL              BIT(8)
+#define DEV25G_PCS25G_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_SD_CFG_SD_SEL, x)
+#define DEV25G_PCS25G_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_SD_CFG_SD_SEL, x)
+
+#define DEV25G_PCS25G_SD_CFG_SD_POL              BIT(4)
+#define DEV25G_PCS25G_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_SD_CFG_SD_POL, x)
+#define DEV25G_PCS25G_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_SD_CFG_SD_POL, x)
+
+#define DEV25G_PCS25G_SD_CFG_SD_ENA              BIT(0)
+#define DEV25G_PCS25G_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV25G_PCS25G_SD_CFG_SD_ENA, x)
+#define DEV25G_PCS25G_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV25G_PCS25G_SD_CFG_SD_ENA, x)
+
+/*      DEV1G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV2G5_DEV_RST_CTRL(t)    __REG(TARGET_DEV2G5, t, 65, 0, 0, 1, 36, 0, 0, 1, 4)
+
+#define DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(23)
+#define DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV2G5_DEV_RST_CTRL_SPEED_SEL            GENMASK(22, 20)
+#define DEV2G5_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV2G5_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST       BIT(17)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_USX_PCS_TX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST       BIT(16)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_USX_PCS_RX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_PCS_TX_RST           BIT(12)
+#define DEV2G5_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_PCS_RX_RST           BIT(8)
+#define DEV2G5_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_MAC_TX_RST           BIT(4)
+#define DEV2G5_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV2G5_DEV_RST_CTRL_MAC_RX_RST           BIT(0)
+#define DEV2G5_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV2G5_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV2G5_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV2G5_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV2G5_MAC_ENA_CFG(t)     __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 0, 0, 1, 4)
+
+#define DEV2G5_MAC_ENA_CFG_RX_ENA                BIT(4)
+#define DEV2G5_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_ENA_CFG_RX_ENA, x)
+#define DEV2G5_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV2G5_MAC_ENA_CFG_TX_ENA                BIT(0)
+#define DEV2G5_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_ENA_CFG_TX_ENA, x)
+#define DEV2G5_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_MODE_CFG */
+#define DEV2G5_MAC_MODE_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 4, 0, 1, 4)
+
+#define DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA     BIT(8)
+#define DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA, x)
+#define DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MODE_CFG_FC_WORD_SYNC_ENA, x)
+
+#define DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA        BIT(4)
+#define DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA, x)
+#define DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA, x)
+
+#define DEV2G5_MAC_MODE_CFG_FDX_ENA              BIT(0)
+#define DEV2G5_MAC_MODE_CFG_FDX_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MODE_CFG_FDX_ENA, x)
+#define DEV2G5_MAC_MODE_CFG_FDX_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MODE_CFG_FDX_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV2G5_MAC_MAXLEN_CFG(t)  __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 8, 0, 1, 4)
+
+#define DEV2G5_MAC_MAXLEN_CFG_MAX_LEN            GENMASK(15, 0)
+#define DEV2G5_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV2G5_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV2G5_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_TAGS_CFG */
+#define DEV2G5_MAC_TAGS_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 12, 0, 1, 4)
+
+#define DEV2G5_MAC_TAGS_CFG_TAG_ID               GENMASK(31, 16)
+#define DEV2G5_MAC_TAGS_CFG_TAG_ID_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_TAG_ID, x)
+#define DEV2G5_MAC_TAGS_CFG_TAG_ID_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_TAG_ID, x)
+
+#define DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA     BIT(3)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA, x)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA, x)
+
+#define DEV2G5_MAC_TAGS_CFG_PB_ENA               GENMASK(2, 1)
+#define DEV2G5_MAC_TAGS_CFG_PB_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_PB_ENA, x)
+#define DEV2G5_MAC_TAGS_CFG_PB_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_PB_ENA, x)
+
+#define DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA         BIT(0)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+#define DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_TAGS_CFG2 */
+#define DEV2G5_MAC_TAGS_CFG2(t)   __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 16, 0, 1, 4)
+
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID3             GENMASK(31, 16)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID3_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG2_TAG_ID3, x)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID3_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG2_TAG_ID3, x)
+
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID2             GENMASK(15, 0)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID2_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_TAGS_CFG2_TAG_ID2, x)
+#define DEV2G5_MAC_TAGS_CFG2_TAG_ID2_GET(x)\
+	FIELD_GET(DEV2G5_MAC_TAGS_CFG2_TAG_ID2, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV2G5_MAC_ADV_CHK_CFG(t) __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 20, 0, 1, 4)
+
+#define DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA      BIT(0)
+#define DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA, x)
+#define DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_ADV_CHK_CFG_LEN_DROP_ENA, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_IFG_CFG */
+#define DEV2G5_MAC_IFG_CFG(t)     __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 24, 0, 1, 4)
+
+#define DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK BIT(17)
+#define DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK, x)
+#define DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_RESTORE_OLD_IPG_CHECK, x)
+
+#define DEV2G5_MAC_IFG_CFG_TX_IFG                GENMASK(12, 8)
+#define DEV2G5_MAC_IFG_CFG_TX_IFG_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_TX_IFG, x)
+#define DEV2G5_MAC_IFG_CFG_TX_IFG_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_TX_IFG, x)
+
+#define DEV2G5_MAC_IFG_CFG_RX_IFG2               GENMASK(7, 4)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG2_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_RX_IFG2, x)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG2_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_RX_IFG2, x)
+
+#define DEV2G5_MAC_IFG_CFG_RX_IFG1               GENMASK(3, 0)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG1_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_IFG_CFG_RX_IFG1, x)
+#define DEV2G5_MAC_IFG_CFG_RX_IFG1_GET(x)\
+	FIELD_GET(DEV2G5_MAC_IFG_CFG_RX_IFG1, x)
+
+/*      DEV1G:MAC_CFG_STATUS:MAC_HDX_CFG */
+#define DEV2G5_MAC_HDX_CFG(t)     __REG(TARGET_DEV2G5, t, 65, 52, 0, 1, 36, 28, 0, 1, 4)
+
+#define DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC       BIT(26)
+#define DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC, x)
+#define DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_BYPASS_COL_SYNC, x)
+
+#define DEV2G5_MAC_HDX_CFG_SEED                  GENMASK(23, 16)
+#define DEV2G5_MAC_HDX_CFG_SEED_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_SEED, x)
+#define DEV2G5_MAC_HDX_CFG_SEED_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_SEED, x)
+
+#define DEV2G5_MAC_HDX_CFG_SEED_LOAD             BIT(12)
+#define DEV2G5_MAC_HDX_CFG_SEED_LOAD_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_SEED_LOAD, x)
+#define DEV2G5_MAC_HDX_CFG_SEED_LOAD_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_SEED_LOAD, x)
+
+#define DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA BIT(8)
+#define DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA, x)
+#define DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_RETRY_AFTER_EXC_COL_ENA, x)
+
+#define DEV2G5_MAC_HDX_CFG_LATE_COL_POS          GENMASK(6, 0)
+#define DEV2G5_MAC_HDX_CFG_LATE_COL_POS_SET(x)\
+	FIELD_PREP(DEV2G5_MAC_HDX_CFG_LATE_COL_POS, x)
+#define DEV2G5_MAC_HDX_CFG_LATE_COL_POS_GET(x)\
+	FIELD_GET(DEV2G5_MAC_HDX_CFG_LATE_COL_POS, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_CFG */
+#define DEV2G5_PCS1G_CFG(t)       __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 0, 0, 1, 4)
+
+#define DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE        BIT(4)
+#define DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE, x)
+#define DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_CFG_LINK_STATUS_TYPE, x)
+
+#define DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA        BIT(1)
+#define DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA, x)
+#define DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_CFG_AN_LINK_CTRL_ENA, x)
+
+#define DEV2G5_PCS1G_CFG_PCS_ENA                 BIT(0)
+#define DEV2G5_PCS1G_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_CFG_PCS_ENA, x)
+#define DEV2G5_PCS1G_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_CFG_PCS_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_MODE_CFG */
+#define DEV2G5_PCS1G_MODE_CFG(t)  __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 4, 0, 1, 4)
+
+#define DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA    BIT(4)
+#define DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA, x)
+#define DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_MODE_CFG_UNIDIR_MODE_ENA, x)
+
+#define DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA  BIT(1)
+#define DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA, x)
+#define DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA, x)
+
+#define DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA     BIT(0)
+#define DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA, x)
+#define DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_SD_CFG */
+#define DEV2G5_PCS1G_SD_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 8, 0, 1, 4)
+
+#define DEV2G5_PCS1G_SD_CFG_SD_SEL               BIT(8)
+#define DEV2G5_PCS1G_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_SD_CFG_SD_SEL, x)
+#define DEV2G5_PCS1G_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_SD_CFG_SD_SEL, x)
+
+#define DEV2G5_PCS1G_SD_CFG_SD_POL               BIT(4)
+#define DEV2G5_PCS1G_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_SD_CFG_SD_POL, x)
+#define DEV2G5_PCS1G_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_SD_CFG_SD_POL, x)
+
+#define DEV2G5_PCS1G_SD_CFG_SD_ENA               BIT(0)
+#define DEV2G5_PCS1G_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_SD_CFG_SD_ENA, x)
+#define DEV2G5_PCS1G_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_SD_CFG_SD_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_ANEG_CFG */
+#define DEV2G5_PCS1G_ANEG_CFG(t)  __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 12, 0, 1, 4)
+
+#define DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY        GENMASK(31, 16)
+#define DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY, x)
+#define DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY, x)
+
+#define DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA     BIT(8)
+#define DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA, x)
+#define DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA, x)
+
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT BIT(1)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT, x)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT, x)
+
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA           BIT(0)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA, x)
+#define DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_LB_CFG */
+#define DEV2G5_PCS1G_LB_CFG(t)    __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 20, 0, 1, 4)
+
+#define DEV2G5_PCS1G_LB_CFG_RA_ENA               BIT(4)
+#define DEV2G5_PCS1G_LB_CFG_RA_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LB_CFG_RA_ENA, x)
+#define DEV2G5_PCS1G_LB_CFG_RA_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LB_CFG_RA_ENA, x)
+
+#define DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA      BIT(1)
+#define DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA, x)
+#define DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LB_CFG_GMII_PHY_LB_ENA, x)
+
+#define DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA      BIT(0)
+#define DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA, x)
+#define DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LB_CFG_TBI_HOST_LB_ENA, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_ANEG_STATUS */
+#define DEV2G5_PCS1G_ANEG_STATUS(t) __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 32, 0, 1, 4)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY  GENMASK(31, 16)
+#define DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY, x)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_PR              BIT(4)
+#define DEV2G5_PCS1G_ANEG_STATUS_PR_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_PR, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_PR_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_PR, x)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY  BIT(3)
+#define DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_PAGE_RX_STICKY, x)
+
+#define DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE   BIT(0)
+#define DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE, x)
+#define DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_LINK_STATUS */
+#define DEV2G5_PCS1G_LINK_STATUS(t) __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 40, 0, 1, 4)
+
+#define DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR       GENMASK(15, 12)
+#define DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR, x)
+#define DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_DELAY_VAR, x)
+
+#define DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT   BIT(8)
+#define DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT, x)
+#define DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_SIGNAL_DETECT, x)
+
+#define DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS     BIT(4)
+#define DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS, x)
+#define DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS, x)
+
+#define DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS     BIT(0)
+#define DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS, x)
+#define DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS, x)
+
+/*      DEV1G:PCS1G_CFG_STATUS:PCS1G_STICKY */
+#define DEV2G5_PCS1G_STICKY(t)    __REG(TARGET_DEV2G5, t, 65, 88, 0, 1, 68, 48, 0, 1, 4)
+
+#define DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY     BIT(4)
+#define DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY, x)
+#define DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY, x)
+
+#define DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY   BIT(0)
+#define DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY, x)
+#define DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS1G_STICKY_OUT_OF_SYNC_STICKY, x)
+
+/*      DEV1G:PCS_FX100_CONFIGURATION:PCS_FX100_CFG */
+#define DEV2G5_PCS_FX100_CFG(t)   __REG(TARGET_DEV2G5, t, 65, 164, 0, 1, 4, 0, 0, 1, 4)
+
+#define DEV2G5_PCS_FX100_CFG_SD_SEL              BIT(26)
+#define DEV2G5_PCS_FX100_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SD_SEL, x)
+#define DEV2G5_PCS_FX100_CFG_SD_SEL_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SD_SEL, x)
+
+#define DEV2G5_PCS_FX100_CFG_SD_POL              BIT(25)
+#define DEV2G5_PCS_FX100_CFG_SD_POL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SD_POL, x)
+#define DEV2G5_PCS_FX100_CFG_SD_POL_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SD_POL, x)
+
+#define DEV2G5_PCS_FX100_CFG_SD_ENA              BIT(24)
+#define DEV2G5_PCS_FX100_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SD_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_SD_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SD_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA        BIT(20)
+#define DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_LOOPBACK_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA        BIT(16)
+#define DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SWAP_MII_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_RXBITSEL            GENMASK(15, 12)
+#define DEV2G5_PCS_FX100_CFG_RXBITSEL_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_RXBITSEL, x)
+#define DEV2G5_PCS_FX100_CFG_RXBITSEL_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_RXBITSEL, x)
+
+#define DEV2G5_PCS_FX100_CFG_SIGDET_CFG          GENMASK(10, 9)
+#define DEV2G5_PCS_FX100_CFG_SIGDET_CFG_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_SIGDET_CFG, x)
+#define DEV2G5_PCS_FX100_CFG_SIGDET_CFG_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_SIGDET_CFG, x)
+
+#define DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA     BIT(8)
+#define DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_LINKHYST_TM_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER       GENMASK(7, 4)
+#define DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER, x)
+#define DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_LINKHYSTTIMER, x)
+
+#define DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA     BIT(3)
+#define DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_UNIDIR_MODE_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_FEFCHK_ENA          BIT(2)
+#define DEV2G5_PCS_FX100_CFG_FEFCHK_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_FEFCHK_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_FEFCHK_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_FEFCHK_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_FEFGEN_ENA          BIT(1)
+#define DEV2G5_PCS_FX100_CFG_FEFGEN_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_FEFGEN_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_FEFGEN_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_FEFGEN_ENA, x)
+
+#define DEV2G5_PCS_FX100_CFG_PCS_ENA             BIT(0)
+#define DEV2G5_PCS_FX100_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_CFG_PCS_ENA, x)
+#define DEV2G5_PCS_FX100_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_CFG_PCS_ENA, x)
+
+/*      DEV1G:PCS_FX100_STATUS:PCS_FX100_STATUS */
+#define DEV2G5_PCS_FX100_STATUS(t) __REG(TARGET_DEV2G5, t, 65, 168, 0, 1, 4, 0, 0, 1, 4)
+
+#define DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP     GENMASK(11, 8)
+#define DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP, x)
+#define DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_EDGE_POS_PTP, x)
+
+#define DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY BIT(7)
+#define DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY BIT(6)
+#define DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY BIT(5)
+#define DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY BIT(4)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY, x)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY, x)
+
+#define DEV2G5_PCS_FX100_STATUS_FEF_STATUS       BIT(2)
+#define DEV2G5_PCS_FX100_STATUS_FEF_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_FEF_STATUS, x)
+#define DEV2G5_PCS_FX100_STATUS_FEF_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_FEF_STATUS, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT    BIT(1)
+#define DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT, x)
+#define DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SIGNAL_DETECT, x)
+
+#define DEV2G5_PCS_FX100_STATUS_SYNC_STATUS      BIT(0)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_STATUS_SET(x)\
+	FIELD_PREP(DEV2G5_PCS_FX100_STATUS_SYNC_STATUS, x)
+#define DEV2G5_PCS_FX100_STATUS_SYNC_STATUS_GET(x)\
+	FIELD_GET(DEV2G5_PCS_FX100_STATUS_SYNC_STATUS, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ENA_CFG */
+#define DEV5G_MAC_ENA_CFG(t)      __REG(TARGET_DEV5G, t, 13, 0, 0, 1, 60, 0, 0, 1, 4)
+
+#define DEV5G_MAC_ENA_CFG_RX_ENA                 BIT(4)
+#define DEV5G_MAC_ENA_CFG_RX_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ENA_CFG_RX_ENA, x)
+#define DEV5G_MAC_ENA_CFG_RX_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ENA_CFG_RX_ENA, x)
+
+#define DEV5G_MAC_ENA_CFG_TX_ENA                 BIT(0)
+#define DEV5G_MAC_ENA_CFG_TX_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ENA_CFG_TX_ENA, x)
+#define DEV5G_MAC_ENA_CFG_TX_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ENA_CFG_TX_ENA, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_MAXLEN_CFG */
+#define DEV5G_MAC_MAXLEN_CFG(t)   __REG(TARGET_DEV5G, t, 13, 0, 0, 1, 60, 8, 0, 1, 4)
+
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK     BIT(16)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(x)\
+	FIELD_PREP(DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_GET(x)\
+	FIELD_GET(DEV5G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK, x)
+
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN             GENMASK(15, 0)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_SET(x)\
+	FIELD_PREP(DEV5G_MAC_MAXLEN_CFG_MAX_LEN, x)
+#define DEV5G_MAC_MAXLEN_CFG_MAX_LEN_GET(x)\
+	FIELD_GET(DEV5G_MAC_MAXLEN_CFG_MAX_LEN, x)
+
+/*      DEV10G:MAC_CFG_STATUS:MAC_ADV_CHK_CFG */
+#define DEV5G_MAC_ADV_CHK_CFG(t)  __REG(TARGET_DEV5G, t, 13, 0, 0, 1, 60, 28, 0, 1, 4)
+
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA    BIT(24)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_EXT_EOP_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA    BIT(20)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_EXT_SOP_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA        BIT(16)
+#define DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_SFD_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS    BIT(12)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_PRM_SHK_CHK_DIS, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA        BIT(8)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_PRM_CHK_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA        BIT(4)
+#define DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_OOR_ERR_ENA, x)
+
+#define DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA        BIT(0)
+#define DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA_SET(x)\
+	FIELD_PREP(DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+#define DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA_GET(x)\
+	FIELD_GET(DEV5G_MAC_ADV_CHK_CFG_INR_ERR_ENA, x)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SYMBOL_ERR_CNT */
+#define DEV5G_RX_SYMBOL_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 0, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_PAUSE_CNT */
+#define DEV5G_RX_PAUSE_CNT(t)     __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 4, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_UC_CNT */
+#define DEV5G_RX_UC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 12, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_MC_CNT */
+#define DEV5G_RX_MC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 16, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_BC_CNT */
+#define DEV5G_RX_BC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 20, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_CRC_ERR_CNT */
+#define DEV5G_RX_CRC_ERR_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 24, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_UNDERSIZE_CNT */
+#define DEV5G_RX_UNDERSIZE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 28, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_FRAGMENTS_CNT */
+#define DEV5G_RX_FRAGMENTS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 32, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_IN_RANGE_LEN_ERR_CNT */
+#define DEV5G_RX_IN_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 36, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define DEV5G_RX_OUT_OF_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 40, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_OVERSIZE_CNT */
+#define DEV5G_RX_OVERSIZE_CNT(t)  __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 44, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_JABBERS_CNT */
+#define DEV5G_RX_JABBERS_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 48, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE64_CNT */
+#define DEV5G_RX_SIZE64_CNT(t)    __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 52, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE65TO127_CNT */
+#define DEV5G_RX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 56, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE128TO255_CNT */
+#define DEV5G_RX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 60, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE256TO511_CNT */
+#define DEV5G_RX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 64, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE512TO1023_CNT */
+#define DEV5G_RX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 68, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE1024TO1518_CNT */
+#define DEV5G_RX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 72, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:RX_SIZE1519TOMAX_CNT */
+#define DEV5G_RX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 76, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_PAUSE_CNT */
+#define DEV5G_TX_PAUSE_CNT(t)     __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 84, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_UC_CNT */
+#define DEV5G_TX_UC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 88, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_MC_CNT */
+#define DEV5G_TX_MC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 92, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_BC_CNT */
+#define DEV5G_TX_BC_CNT(t)        __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 96, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE64_CNT */
+#define DEV5G_TX_SIZE64_CNT(t)    __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 100, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE65TO127_CNT */
+#define DEV5G_TX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 104, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE128TO255_CNT */
+#define DEV5G_TX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 108, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE256TO511_CNT */
+#define DEV5G_TX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 112, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE512TO1023_CNT */
+#define DEV5G_TX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 116, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE1024TO1518_CNT */
+#define DEV5G_TX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 120, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:TX_SIZE1519TOMAX_CNT */
+#define DEV5G_TX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 124, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SYMBOL_ERR_CNT */
+#define DEV5G_PMAC_RX_SYMBOL_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 148, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_PAUSE_CNT */
+#define DEV5G_PMAC_RX_PAUSE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 152, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_UNSUP_OPCODE_CNT */
+#define DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 156, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_UC_CNT */
+#define DEV5G_PMAC_RX_UC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 160, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_MC_CNT */
+#define DEV5G_PMAC_RX_MC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 164, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_BC_CNT */
+#define DEV5G_PMAC_RX_BC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 168, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_CRC_ERR_CNT */
+#define DEV5G_PMAC_RX_CRC_ERR_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 172, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_UNDERSIZE_CNT */
+#define DEV5G_PMAC_RX_UNDERSIZE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 176, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_FRAGMENTS_CNT */
+#define DEV5G_PMAC_RX_FRAGMENTS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 180, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_IN_RANGE_LEN_ERR_CNT */
+#define DEV5G_PMAC_RX_IN_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G,\
+					t, 13, 60, 0, 1, 312, 184, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT */
+#define DEV5G_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(t) __REG(TARGET_DEV5G,\
+					t, 13, 60, 0, 1, 312, 188, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_OVERSIZE_CNT */
+#define DEV5G_PMAC_RX_OVERSIZE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 192, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_JABBERS_CNT */
+#define DEV5G_PMAC_RX_JABBERS_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 196, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE64_CNT */
+#define DEV5G_PMAC_RX_SIZE64_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 200, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE65TO127_CNT */
+#define DEV5G_PMAC_RX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 204, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE128TO255_CNT */
+#define DEV5G_PMAC_RX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 208, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE256TO511_CNT */
+#define DEV5G_PMAC_RX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 212, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE512TO1023_CNT */
+#define DEV5G_PMAC_RX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 216, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE1024TO1518_CNT */
+#define DEV5G_PMAC_RX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 220, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_RX_SIZE1519TOMAX_CNT */
+#define DEV5G_PMAC_RX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 224, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_PAUSE_CNT */
+#define DEV5G_PMAC_TX_PAUSE_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 228, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_UC_CNT */
+#define DEV5G_PMAC_TX_UC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 232, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_MC_CNT */
+#define DEV5G_PMAC_TX_MC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 236, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_BC_CNT */
+#define DEV5G_PMAC_TX_BC_CNT(t)   __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 240, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE64_CNT */
+#define DEV5G_PMAC_TX_SIZE64_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 244, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE65TO127_CNT */
+#define DEV5G_PMAC_TX_SIZE65TO127_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 248, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE128TO255_CNT */
+#define DEV5G_PMAC_TX_SIZE128TO255_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 252, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE256TO511_CNT */
+#define DEV5G_PMAC_TX_SIZE256TO511_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 256, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE512TO1023_CNT */
+#define DEV5G_PMAC_TX_SIZE512TO1023_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 260, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE1024TO1518_CNT */
+#define DEV5G_PMAC_TX_SIZE1024TO1518_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 264, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_32BIT:PMAC_TX_SIZE1519TOMAX_CNT */
+#define DEV5G_PMAC_TX_SIZE1519TOMAX_CNT(t) __REG(TARGET_DEV5G, t, 13, 60, 0, 1, 312, 268, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_IN_BYTES_CNT */
+#define DEV5G_RX_IN_BYTES_CNT(t)  __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 0, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_OK_BYTES_CNT */
+#define DEV5G_RX_OK_BYTES_CNT(t)  __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 8, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:RX_BAD_BYTES_CNT */
+#define DEV5G_RX_BAD_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 16, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:TX_OUT_BYTES_CNT */
+#define DEV5G_TX_OUT_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 24, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:TX_OK_BYTES_CNT */
+#define DEV5G_TX_OK_BYTES_CNT(t)  __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 32, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_RX_OK_BYTES_CNT */
+#define DEV5G_PMAC_RX_OK_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 40, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_RX_BAD_BYTES_CNT */
+#define DEV5G_PMAC_RX_BAD_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 48, 0, 1, 4)
+
+/*      DEV10G:DEV_STATISTICS_40BIT:PMAC_TX_OK_BYTES_CNT */
+#define DEV5G_PMAC_TX_OK_BYTES_CNT(t) __REG(TARGET_DEV5G, t, 13, 372, 0, 1, 64, 56, 0, 1, 4)
+
+/*      DEV10G:DEV_CFG_STATUS:DEV_RST_CTRL */
+#define DEV5G_DEV_RST_CTRL(t)     __REG(TARGET_DEV5G, t, 13, 436, 0, 1, 52, 0, 0, 1, 4)
+
+#define DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA       BIT(28)
+#define DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+#define DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_PARDET_MODE_ENA, x)
+
+#define DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS BIT(27)
+#define DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+#define DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_USXGMII_OSET_FILTER_DIS, x)
+
+#define DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS GENMASK(26, 25)
+#define DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+#define DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_MUXED_USXGMII_NETWORK_PORTS, x)
+
+#define DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL      GENMASK(24, 23)
+#define DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+#define DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_SERDES_SPEED_SEL, x)
+
+#define DEV5G_DEV_RST_CTRL_SPEED_SEL             GENMASK(22, 20)
+#define DEV5G_DEV_RST_CTRL_SPEED_SEL_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_SPEED_SEL, x)
+#define DEV5G_DEV_RST_CTRL_SPEED_SEL_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_SPEED_SEL, x)
+
+#define DEV5G_DEV_RST_CTRL_PCS_TX_RST            BIT(12)
+#define DEV5G_DEV_RST_CTRL_PCS_TX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_PCS_TX_RST, x)
+#define DEV5G_DEV_RST_CTRL_PCS_TX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_PCS_TX_RST, x)
+
+#define DEV5G_DEV_RST_CTRL_PCS_RX_RST            BIT(8)
+#define DEV5G_DEV_RST_CTRL_PCS_RX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_PCS_RX_RST, x)
+#define DEV5G_DEV_RST_CTRL_PCS_RX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_PCS_RX_RST, x)
+
+#define DEV5G_DEV_RST_CTRL_MAC_TX_RST            BIT(4)
+#define DEV5G_DEV_RST_CTRL_MAC_TX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_MAC_TX_RST, x)
+#define DEV5G_DEV_RST_CTRL_MAC_TX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_MAC_TX_RST, x)
+
+#define DEV5G_DEV_RST_CTRL_MAC_RX_RST            BIT(0)
+#define DEV5G_DEV_RST_CTRL_MAC_RX_RST_SET(x)\
+	FIELD_PREP(DEV5G_DEV_RST_CTRL_MAC_RX_RST, x)
+#define DEV5G_DEV_RST_CTRL_MAC_RX_RST_GET(x)\
+	FIELD_GET(DEV5G_DEV_RST_CTRL_MAC_RX_RST, x)
+
+/*      DSM:RAM_CTRL:RAM_INIT */
+#define DSM_RAM_INIT              __REG(TARGET_DSM, 0, 1, 0, 0, 1, 4, 0, 0, 1, 4)
+
+#define DSM_RAM_INIT_RAM_INIT                    BIT(1)
+#define DSM_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(DSM_RAM_INIT_RAM_INIT, x)
+#define DSM_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(DSM_RAM_INIT_RAM_INIT, x)
+
+#define DSM_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define DSM_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(DSM_RAM_INIT_RAM_CFG_HOOK, x)
+#define DSM_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(DSM_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      DSM:CFG:BUF_CFG */
+#define DSM_BUF_CFG(r)            __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 0, r, 67, 4)
+
+#define DSM_BUF_CFG_CSC_STAT_DIS                 BIT(13)
+#define DSM_BUF_CFG_CSC_STAT_DIS_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_CSC_STAT_DIS, x)
+#define DSM_BUF_CFG_CSC_STAT_DIS_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_CSC_STAT_DIS, x)
+
+#define DSM_BUF_CFG_AGING_ENA                    BIT(12)
+#define DSM_BUF_CFG_AGING_ENA_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_AGING_ENA, x)
+#define DSM_BUF_CFG_AGING_ENA_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_AGING_ENA, x)
+
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS       BIT(11)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS, x)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_DIS, x)
+
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT   GENMASK(10, 0)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT_SET(x)\
+	FIELD_PREP(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT, x)
+#define DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT_GET(x)\
+	FIELD_GET(DSM_BUF_CFG_UNDERFLOW_WATCHDOG_TIMEOUT, x)
+
+/*      DSM:CFG:DEV_TX_STOP_WM_CFG */
+#define DSM_DEV_TX_STOP_WM_CFG(r) __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 1360, r, 67, 4)
+
+#define DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA  BIT(9)
+#define DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA, x)
+#define DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_FAST_STARTUP_ENA, x)
+
+#define DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA BIT(8)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA, x)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA, x)
+
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM    GENMASK(7, 1)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM, x)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM, x)
+
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR    BIT(0)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR_SET(x)\
+	FIELD_PREP(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR, x)
+#define DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR_GET(x)\
+	FIELD_GET(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR, x)
+
+/*      DSM:CFG:RX_PAUSE_CFG */
+#define DSM_RX_PAUSE_CFG(r)       __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 1628, r, 67, 4)
+
+#define DSM_RX_PAUSE_CFG_RX_PAUSE_EN             BIT(1)
+#define DSM_RX_PAUSE_CFG_RX_PAUSE_EN_SET(x)\
+	FIELD_PREP(DSM_RX_PAUSE_CFG_RX_PAUSE_EN, x)
+#define DSM_RX_PAUSE_CFG_RX_PAUSE_EN_GET(x)\
+	FIELD_GET(DSM_RX_PAUSE_CFG_RX_PAUSE_EN, x)
+
+#define DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL           BIT(0)
+#define DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL_SET(x)\
+	FIELD_PREP(DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL, x)
+#define DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL_GET(x)\
+	FIELD_GET(DSM_RX_PAUSE_CFG_FC_OBEY_LOCAL, x)
+
+/*      DSM:CFG:MAC_CFG */
+#define DSM_MAC_CFG(r)            __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 2432, r, 67, 4)
+
+#define DSM_MAC_CFG_TX_PAUSE_VAL                 GENMASK(31, 16)
+#define DSM_MAC_CFG_TX_PAUSE_VAL_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_TX_PAUSE_VAL, x)
+#define DSM_MAC_CFG_TX_PAUSE_VAL_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_TX_PAUSE_VAL, x)
+
+#define DSM_MAC_CFG_HDX_BACKPREASSURE            BIT(2)
+#define DSM_MAC_CFG_HDX_BACKPREASSURE_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_HDX_BACKPREASSURE, x)
+#define DSM_MAC_CFG_HDX_BACKPREASSURE_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_HDX_BACKPREASSURE, x)
+
+#define DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE         BIT(1)
+#define DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE, x)
+#define DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_SEND_PAUSE_FRM_TWICE, x)
+
+#define DSM_MAC_CFG_TX_PAUSE_XON_XOFF            BIT(0)
+#define DSM_MAC_CFG_TX_PAUSE_XON_XOFF_SET(x)\
+	FIELD_PREP(DSM_MAC_CFG_TX_PAUSE_XON_XOFF, x)
+#define DSM_MAC_CFG_TX_PAUSE_XON_XOFF_GET(x)\
+	FIELD_GET(DSM_MAC_CFG_TX_PAUSE_XON_XOFF, x)
+
+/*      DSM:CFG:MAC_ADDR_BASE_HIGH_CFG */
+#define DSM_MAC_ADDR_BASE_HIGH_CFG(r) __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 2700, r, 65, 4)
+
+#define DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH GENMASK(23, 0)
+#define DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH_SET(x)\
+	FIELD_PREP(DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH, x)
+#define DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH_GET(x)\
+	FIELD_GET(DSM_MAC_ADDR_BASE_HIGH_CFG_MAC_ADDR_HIGH, x)
+
+/*      DSM:CFG:MAC_ADDR_BASE_LOW_CFG */
+#define DSM_MAC_ADDR_BASE_LOW_CFG(r) __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 2960, r, 65, 4)
+
+#define DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW   GENMASK(23, 0)
+#define DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW_SET(x)\
+	FIELD_PREP(DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW, x)
+#define DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW_GET(x)\
+	FIELD_GET(DSM_MAC_ADDR_BASE_LOW_CFG_MAC_ADDR_LOW, x)
+
+/*      DSM:CFG:TAXI_CAL_CFG */
+#define DSM_TAXI_CAL_CFG(r)       __REG(TARGET_DSM, 0, 1, 20, 0, 1, 3528, 3224, r, 9, 4)
+
+#define DSM_TAXI_CAL_CFG_CAL_IDX                 GENMASK(20, 15)
+#define DSM_TAXI_CAL_CFG_CAL_IDX_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_IDX, x)
+#define DSM_TAXI_CAL_CFG_CAL_IDX_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_IDX, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_CUR_LEN             GENMASK(14, 9)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_LEN_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_CUR_LEN, x)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_LEN_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_CUR_LEN, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_CUR_VAL             GENMASK(8, 5)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_VAL_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_CUR_VAL, x)
+#define DSM_TAXI_CAL_CFG_CAL_CUR_VAL_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_CUR_VAL, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_PGM_VAL             GENMASK(4, 1)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_VAL_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_PGM_VAL, x)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_VAL_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_PGM_VAL, x)
+
+#define DSM_TAXI_CAL_CFG_CAL_PGM_ENA             BIT(0)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_ENA_SET(x)\
+	FIELD_PREP(DSM_TAXI_CAL_CFG_CAL_PGM_ENA, x)
+#define DSM_TAXI_CAL_CFG_CAL_PGM_ENA_GET(x)\
+	FIELD_GET(DSM_TAXI_CAL_CFG_CAL_PGM_ENA, x)
+
+/*      EACL:POL_CFG:POL_EACL_CFG */
+#define EACL_POL_EACL_CFG         __REG(TARGET_EACL, 0, 1, 150608, 0, 1, 780, 768, 0, 1, 4)
+
+#define EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED BIT(5)
+#define EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED, x)
+#define EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_CNT_MARKED_AS_DROPPED, x)
+
+#define EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY     BIT(4)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY, x)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_ALLOW_FP_COPY, x)
+
+#define EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY    BIT(3)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY, x)
+#define EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_ALLOW_CPU_COPY, x)
+
+#define EACL_POL_EACL_CFG_EACL_FORCE_CLOSE       BIT(2)
+#define EACL_POL_EACL_CFG_EACL_FORCE_CLOSE_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_FORCE_CLOSE, x)
+#define EACL_POL_EACL_CFG_EACL_FORCE_CLOSE_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_CLOSE, x)
+
+#define EACL_POL_EACL_CFG_EACL_FORCE_OPEN        BIT(1)
+#define EACL_POL_EACL_CFG_EACL_FORCE_OPEN_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_FORCE_OPEN, x)
+#define EACL_POL_EACL_CFG_EACL_FORCE_OPEN_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_OPEN, x)
+
+#define EACL_POL_EACL_CFG_EACL_FORCE_INIT        BIT(0)
+#define EACL_POL_EACL_CFG_EACL_FORCE_INIT_SET(x)\
+	FIELD_PREP(EACL_POL_EACL_CFG_EACL_FORCE_INIT, x)
+#define EACL_POL_EACL_CFG_EACL_FORCE_INIT_GET(x)\
+	FIELD_GET(EACL_POL_EACL_CFG_EACL_FORCE_INIT, x)
+
+/*      EACL:RAM_CTRL:RAM_INIT */
+#define EACL_RAM_INIT             __REG(TARGET_EACL, 0, 1, 118736, 0, 1, 4, 0, 0, 1, 4)
+
+#define EACL_RAM_INIT_RAM_INIT                   BIT(1)
+#define EACL_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(EACL_RAM_INIT_RAM_INIT, x)
+#define EACL_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(EACL_RAM_INIT_RAM_INIT, x)
+
+#define EACL_RAM_INIT_RAM_CFG_HOOK               BIT(0)
+#define EACL_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(EACL_RAM_INIT_RAM_CFG_HOOK, x)
+#define EACL_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(EACL_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:CHIP_ID */
+#define GCB_CHIP_ID               __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 0, 0, 1, 4)
+
+#define GCB_CHIP_ID_REV_ID                       GENMASK(31, 28)
+#define GCB_CHIP_ID_REV_ID_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_REV_ID, x)
+#define GCB_CHIP_ID_REV_ID_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_REV_ID, x)
+
+#define GCB_CHIP_ID_PART_ID                      GENMASK(27, 12)
+#define GCB_CHIP_ID_PART_ID_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_PART_ID, x)
+#define GCB_CHIP_ID_PART_ID_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_PART_ID, x)
+
+#define GCB_CHIP_ID_MFG_ID                       GENMASK(11, 1)
+#define GCB_CHIP_ID_MFG_ID_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_MFG_ID, x)
+#define GCB_CHIP_ID_MFG_ID_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_MFG_ID, x)
+
+#define GCB_CHIP_ID_ONE                          BIT(0)
+#define GCB_CHIP_ID_ONE_SET(x)\
+	FIELD_PREP(GCB_CHIP_ID_ONE, x)
+#define GCB_CHIP_ID_ONE_GET(x)\
+	FIELD_GET(GCB_CHIP_ID_ONE, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:SOFT_RST */
+#define GCB_SOFT_RST              __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 8, 0, 1, 4)
+
+#define GCB_SOFT_RST_SOFT_NON_CFG_RST            BIT(2)
+#define GCB_SOFT_RST_SOFT_NON_CFG_RST_SET(x)\
+	FIELD_PREP(GCB_SOFT_RST_SOFT_NON_CFG_RST, x)
+#define GCB_SOFT_RST_SOFT_NON_CFG_RST_GET(x)\
+	FIELD_GET(GCB_SOFT_RST_SOFT_NON_CFG_RST, x)
+
+#define GCB_SOFT_RST_SOFT_SWC_RST                BIT(1)
+#define GCB_SOFT_RST_SOFT_SWC_RST_SET(x)\
+	FIELD_PREP(GCB_SOFT_RST_SOFT_SWC_RST, x)
+#define GCB_SOFT_RST_SOFT_SWC_RST_GET(x)\
+	FIELD_GET(GCB_SOFT_RST_SOFT_SWC_RST, x)
+
+#define GCB_SOFT_RST_SOFT_CHIP_RST               BIT(0)
+#define GCB_SOFT_RST_SOFT_CHIP_RST_SET(x)\
+	FIELD_PREP(GCB_SOFT_RST_SOFT_CHIP_RST, x)
+#define GCB_SOFT_RST_SOFT_CHIP_RST_GET(x)\
+	FIELD_GET(GCB_SOFT_RST_SOFT_CHIP_RST, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:HW_SGPIO_SD_CFG */
+#define GCB_HW_SGPIO_SD_CFG       __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 20, 0, 1, 4)
+
+#define GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA          BIT(1)
+#define GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA_SET(x)\
+	FIELD_PREP(GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA, x)
+#define GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA_GET(x)\
+	FIELD_GET(GCB_HW_SGPIO_SD_CFG_SD_HIGH_ENA, x)
+
+#define GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL           BIT(0)
+#define GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL_SET(x)\
+	FIELD_PREP(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL, x)
+#define GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL_GET(x)\
+	FIELD_GET(GCB_HW_SGPIO_SD_CFG_SD_MAP_SEL, x)
+
+/*      DEVCPU_GCB:CHIP_REGS:HW_SGPIO_TO_SD_MAP_CFG */
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG(r) __REG(TARGET_GCB, 0, 1, 0, 0, 1, 424, 24, r, 65, 4)
+
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL GENMASK(8, 0)
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL_SET(x)\
+	FIELD_PREP(GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL, x)
+#define GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL_GET(x)\
+	FIELD_GET(GCB_HW_SGPIO_TO_SD_MAP_CFG_SGPIO_TO_SD_SEL, x)
+
+/*      DEVCPU_GCB:SIO_CTRL:SIO_CLOCK */
+#define GCB_SIO_CLOCK(g)          __REG(TARGET_GCB, 0, 1, 876, g, 3, 280, 20, 0, 1, 4)
+
+#define GCB_SIO_CLOCK_SIO_CLK_FREQ               GENMASK(19, 8)
+#define GCB_SIO_CLOCK_SIO_CLK_FREQ_SET(x)\
+	FIELD_PREP(GCB_SIO_CLOCK_SIO_CLK_FREQ, x)
+#define GCB_SIO_CLOCK_SIO_CLK_FREQ_GET(x)\
+	FIELD_GET(GCB_SIO_CLOCK_SIO_CLK_FREQ, x)
+
+#define GCB_SIO_CLOCK_SYS_CLK_PERIOD             GENMASK(7, 0)
+#define GCB_SIO_CLOCK_SYS_CLK_PERIOD_SET(x)\
+	FIELD_PREP(GCB_SIO_CLOCK_SYS_CLK_PERIOD, x)
+#define GCB_SIO_CLOCK_SYS_CLK_PERIOD_GET(x)\
+	FIELD_GET(GCB_SIO_CLOCK_SYS_CLK_PERIOD, x)
+
+/*      HSCH:HSCH_MISC:SYS_CLK_PER */
+#define HSCH_SYS_CLK_PER          __REG(TARGET_HSCH, 0, 1, 163104, 0, 1, 648, 640, 0, 1, 4)
+
+#define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS       GENMASK(7, 0)
+#define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_SET(x)\
+	FIELD_PREP(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS, x)
+#define HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS_GET(x)\
+	FIELD_GET(HSCH_SYS_CLK_PER_SYS_CLK_PER_100PS, x)
+
+/*      HSCH:SYSTEM:FLUSH_CTRL */
+#define HSCH_FLUSH_CTRL           __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 4, 0, 1, 4)
+
+#define HSCH_FLUSH_CTRL_FLUSH_ENA                BIT(27)
+#define HSCH_FLUSH_CTRL_FLUSH_ENA_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_ENA, x)
+#define HSCH_FLUSH_CTRL_FLUSH_ENA_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_ENA, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_SRC                BIT(26)
+#define HSCH_FLUSH_CTRL_FLUSH_SRC_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_SRC, x)
+#define HSCH_FLUSH_CTRL_FLUSH_SRC_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_SRC, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_DST                BIT(25)
+#define HSCH_FLUSH_CTRL_FLUSH_DST_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_DST, x)
+#define HSCH_FLUSH_CTRL_FLUSH_DST_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_DST, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_PORT               GENMASK(24, 18)
+#define HSCH_FLUSH_CTRL_FLUSH_PORT_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_PORT, x)
+#define HSCH_FLUSH_CTRL_FLUSH_PORT_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_PORT, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_QUEUE              BIT(17)
+#define HSCH_FLUSH_CTRL_FLUSH_QUEUE_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_QUEUE, x)
+#define HSCH_FLUSH_CTRL_FLUSH_QUEUE_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_QUEUE, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_SE                 BIT(16)
+#define HSCH_FLUSH_CTRL_FLUSH_SE_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_SE, x)
+#define HSCH_FLUSH_CTRL_FLUSH_SE_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_SE, x)
+
+#define HSCH_FLUSH_CTRL_FLUSH_HIER               GENMASK(15, 0)
+#define HSCH_FLUSH_CTRL_FLUSH_HIER_SET(x)\
+	FIELD_PREP(HSCH_FLUSH_CTRL_FLUSH_HIER, x)
+#define HSCH_FLUSH_CTRL_FLUSH_HIER_GET(x)\
+	FIELD_GET(HSCH_FLUSH_CTRL_FLUSH_HIER, x)
+
+/*      HSCH:SYSTEM:PORT_MODE */
+#define HSCH_PORT_MODE(r)         __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 8, r, 70, 4)
+
+#define HSCH_PORT_MODE_DEQUEUE_DIS               BIT(4)
+#define HSCH_PORT_MODE_DEQUEUE_DIS_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_DEQUEUE_DIS, x)
+#define HSCH_PORT_MODE_DEQUEUE_DIS_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_DEQUEUE_DIS, x)
+
+#define HSCH_PORT_MODE_AGE_DIS                   BIT(3)
+#define HSCH_PORT_MODE_AGE_DIS_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_AGE_DIS, x)
+#define HSCH_PORT_MODE_AGE_DIS_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_AGE_DIS, x)
+
+#define HSCH_PORT_MODE_TRUNC_ENA                 BIT(2)
+#define HSCH_PORT_MODE_TRUNC_ENA_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_TRUNC_ENA, x)
+#define HSCH_PORT_MODE_TRUNC_ENA_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_TRUNC_ENA, x)
+
+#define HSCH_PORT_MODE_EIR_REMARK_ENA            BIT(1)
+#define HSCH_PORT_MODE_EIR_REMARK_ENA_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_EIR_REMARK_ENA, x)
+#define HSCH_PORT_MODE_EIR_REMARK_ENA_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_EIR_REMARK_ENA, x)
+
+#define HSCH_PORT_MODE_CPU_PRIO_MODE             BIT(0)
+#define HSCH_PORT_MODE_CPU_PRIO_MODE_SET(x)\
+	FIELD_PREP(HSCH_PORT_MODE_CPU_PRIO_MODE, x)
+#define HSCH_PORT_MODE_CPU_PRIO_MODE_GET(x)\
+	FIELD_GET(HSCH_PORT_MODE_CPU_PRIO_MODE, x)
+
+/*      HSCH:SYSTEM:OUTB_SHARE_ENA */
+#define HSCH_OUTB_SHARE_ENA(r)    __REG(TARGET_HSCH, 0, 1, 184000, 0, 1, 312, 288, r, 5, 4)
+
+#define HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA       GENMASK(7, 0)
+#define HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA_SET(x)\
+	FIELD_PREP(HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA, x)
+#define HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA_GET(x)\
+	FIELD_GET(HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA, x)
+
+/*      HSCH:MMGT:RESET_CFG */
+#define HSCH_RESET_CFG            __REG(TARGET_HSCH, 0, 1, 162368, 0, 1, 16, 8, 0, 1, 4)
+
+#define HSCH_RESET_CFG_CORE_ENA                  BIT(0)
+#define HSCH_RESET_CFG_CORE_ENA_SET(x)\
+	FIELD_PREP(HSCH_RESET_CFG_CORE_ENA, x)
+#define HSCH_RESET_CFG_CORE_ENA_GET(x)\
+	FIELD_GET(HSCH_RESET_CFG_CORE_ENA, x)
+
+/*      HSCH:TAS_CONFIG:TAS_STATEMACHINE_CFG */
+#define HSCH_TAS_STATEMACHINE_CFG __REG(TARGET_HSCH, 0, 1, 162384, 0, 1, 12, 8, 0, 1, 4)
+
+#define HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY    GENMASK(7, 0)
+#define HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_SET(x)\
+	FIELD_PREP(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY, x)
+#define HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY_GET(x)\
+	FIELD_GET(HSCH_TAS_STATEMACHINE_CFG_REVISIT_DLY, x)
+
+/*      LRN:COMMON:COMMON_ACCESS_CTRL */
+#define LRN_COMMON_ACCESS_CTRL    __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 0, 0, 1, 4)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL GENMASK(21, 20)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_COL, x)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE BIT(19)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_TYPE, x)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW GENMASK(18, 5)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_DIRECT_ROW, x)
+
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD    GENMASK(4, 1)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD, x)
+#define LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_CPU_ACCESS_CMD, x)
+
+#define LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT BIT(0)
+#define LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_SET(x)\
+	FIELD_PREP(LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT, x)
+#define LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT_GET(x)\
+	FIELD_GET(LRN_COMMON_ACCESS_CTRL_MAC_TABLE_ACCESS_SHOT, x)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_0 */
+#define LRN_MAC_ACCESS_CFG_0      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 4, 0, 1, 4)
+
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID       GENMASK(28, 16)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID, x)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_FID, x)
+
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB   GENMASK(15, 0)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB, x)
+#define LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_0_MAC_ENTRY_MAC_MSB, x)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_1 */
+#define LRN_MAC_ACCESS_CFG_1      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 8, 0, 1, 4)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_2 */
+#define LRN_MAC_ACCESS_CFG_2      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 12, 0, 1, 4)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD BIT(28)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_SRC_KILL_FWD, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL BIT(27)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_NXT_LRN_ALL, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU    GENMASK(26, 24)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_QU, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY  BIT(23)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_CPU_COPY, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE BIT(22)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLAN_IGNORE, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR    BIT(21)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_MIRROR, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG  GENMASK(20, 19)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_FLAG, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL GENMASK(18, 17)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_AGE_INTERVAL, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED    BIT(16)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_LOCKED, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD       BIT(15)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_VLD, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE GENMASK(14, 12)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE, x)
+
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR      GENMASK(11, 0)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR, x)
+#define LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR, x)
+
+/*      LRN:COMMON:MAC_ACCESS_CFG_3 */
+#define LRN_MAC_ACCESS_CFG_3      __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 16, 0, 1, 4)
+
+#define LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX GENMASK(10, 0)
+#define LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX_SET(x)\
+	FIELD_PREP(LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX, x)
+#define LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX_GET(x)\
+	FIELD_GET(LRN_MAC_ACCESS_CFG_3_MAC_ENTRY_ISDX_LIMIT_IDX, x)
+
+/*      LRN:COMMON:SCAN_NEXT_CFG */
+#define LRN_SCAN_NEXT_CFG         __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 20, 0, 1, 4)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL GENMASK(21, 19)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_AGE_FLAG_UPDATE_SEL, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL GENMASK(18, 17)
+#define LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NXT_LRN_ALL_UPDATE_SEL, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL    GENMASK(16, 15)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_AGE_FILTER_SEL, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA BIT(14)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_MOVE_FOUND_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA BIT(13)
+#define LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_NXT_LRN_ALL_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA BIT(12)
+#define LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_USE_PORT_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA BIT(11)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_REMOVE_FOUND_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA BIT(10)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_UNTIL_FOUND_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA BIT(9)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_INC_AGE_BITS_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA BIT(8)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_AGED_ONLY_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA BIT(7)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_NEXT_IGNORE_LOCKED_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK GENMASK(6, 3)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK, x)
+#define LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_SCAN_AGE_INTERVAL_MASK, x)
+
+#define LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA BIT(2)
+#define LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_ISDX_LIMIT_IDX_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_FID_FILTER_ENA         BIT(1)
+#define LRN_SCAN_NEXT_CFG_FID_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_FID_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_FID_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_FID_FILTER_ENA, x)
+
+#define LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA        BIT(0)
+#define LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA, x)
+#define LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_ADDR_FILTER_ENA, x)
+
+/*      LRN:COMMON:SCAN_NEXT_CFG_1 */
+#define LRN_SCAN_NEXT_CFG_1       __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 24, 0, 1, 4)
+
+#define LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR   GENMASK(30, 16)
+#define LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR, x)
+#define LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_1_PORT_MOVE_NEW_ADDR, x)
+
+#define LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK GENMASK(14, 0)
+#define LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK_SET(x)\
+	FIELD_PREP(LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK, x)
+#define LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK_GET(x)\
+	FIELD_GET(LRN_SCAN_NEXT_CFG_1_SCAN_ENTRY_ADDR_MASK, x)
+
+/*      LRN:COMMON:AUTOAGE_CFG */
+#define LRN_AUTOAGE_CFG(r)        __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 36, r, 4, 4)
+
+#define LRN_AUTOAGE_CFG_UNIT_SIZE                GENMASK(29, 28)
+#define LRN_AUTOAGE_CFG_UNIT_SIZE_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_UNIT_SIZE, x)
+#define LRN_AUTOAGE_CFG_UNIT_SIZE_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_UNIT_SIZE, x)
+
+#define LRN_AUTOAGE_CFG_PERIOD_VAL               GENMASK(27, 0)
+#define LRN_AUTOAGE_CFG_PERIOD_VAL_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_PERIOD_VAL, x)
+#define LRN_AUTOAGE_CFG_PERIOD_VAL_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_PERIOD_VAL, x)
+
+/*      LRN:COMMON:AUTOAGE_CFG_1 */
+#define LRN_AUTOAGE_CFG_1         __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 52, 0, 1, 4)
+
+#define LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA     BIT(25)
+#define LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA, x)
+#define LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_PAUSE_AUTO_AGE_ENA, x)
+
+#define LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN GENMASK(24, 15)
+#define LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN, x)
+#define LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_CELLS_BETWEEN_ENTRY_SCAN, x)
+
+#define LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS        GENMASK(14, 7)
+#define LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS, x)
+#define LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_CLK_PERIOD_01NS, x)
+
+#define LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA    BIT(6)
+#define LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA, x)
+#define LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_USE_PORT_FILTER_ENA, x)
+
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT     GENMASK(5, 2)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT, x)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_SHOT, x)
+
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT BIT(1)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT, x)
+#define LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_FORCE_HW_SCAN_STOP_SHOT, x)
+
+#define LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA         BIT(0)
+#define LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA, x)
+#define LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_1_FORCE_IDLE_ENA, x)
+
+/*      LRN:COMMON:AUTOAGE_CFG_2 */
+#define LRN_AUTOAGE_CFG_2         __REG(TARGET_LRN, 0, 1, 0, 0, 1, 72, 56, 0, 1, 4)
+
+#define LRN_AUTOAGE_CFG_2_NEXT_ROW               GENMASK(17, 4)
+#define LRN_AUTOAGE_CFG_2_NEXT_ROW_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_2_NEXT_ROW, x)
+#define LRN_AUTOAGE_CFG_2_NEXT_ROW_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_2_NEXT_ROW, x)
+
+#define LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS    GENMASK(3, 0)
+#define LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS_SET(x)\
+	FIELD_PREP(LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS, x)
+#define LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS_GET(x)\
+	FIELD_GET(LRN_AUTOAGE_CFG_2_SCAN_ONGOING_STATUS, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_CFG */
+#define PCS10G_BR_PCS_CFG(t)      __REG(TARGET_PCS10G_BR, t, 12, 0, 0, 1, 56, 0, 0, 1, 4)
+
+#define PCS10G_BR_PCS_CFG_PCS_ENA                BIT(31)
+#define PCS10G_BR_PCS_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_PCS_ENA, x)
+#define PCS10G_BR_PCS_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_PCS_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA       BIT(30)
+#define PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+#define PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_SH_CNT_MAX             GENMASK(29, 24)
+#define PCS10G_BR_PCS_CFG_SH_CNT_MAX_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_SH_CNT_MAX, x)
+#define PCS10G_BR_PCS_CFG_SH_CNT_MAX_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_SH_CNT_MAX, x)
+
+#define PCS10G_BR_PCS_CFG_RX_DATA_FLIP           BIT(18)
+#define PCS10G_BR_PCS_CFG_RX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RX_DATA_FLIP, x)
+#define PCS10G_BR_PCS_CFG_RX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RX_DATA_FLIP, x)
+
+#define PCS10G_BR_PCS_CFG_RESYNC_ENA             BIT(15)
+#define PCS10G_BR_PCS_CFG_RESYNC_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RESYNC_ENA, x)
+#define PCS10G_BR_PCS_CFG_RESYNC_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RESYNC_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_LF_GEN_DIS             BIT(14)
+#define PCS10G_BR_PCS_CFG_LF_GEN_DIS_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_LF_GEN_DIS, x)
+#define PCS10G_BR_PCS_CFG_LF_GEN_DIS_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_LF_GEN_DIS, x)
+
+#define PCS10G_BR_PCS_CFG_RX_TEST_MODE           BIT(13)
+#define PCS10G_BR_PCS_CFG_RX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RX_TEST_MODE, x)
+#define PCS10G_BR_PCS_CFG_RX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RX_TEST_MODE, x)
+
+#define PCS10G_BR_PCS_CFG_RX_SCR_DISABLE         BIT(12)
+#define PCS10G_BR_PCS_CFG_RX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+#define PCS10G_BR_PCS_CFG_RX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+
+#define PCS10G_BR_PCS_CFG_TX_DATA_FLIP           BIT(7)
+#define PCS10G_BR_PCS_CFG_TX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_TX_DATA_FLIP, x)
+#define PCS10G_BR_PCS_CFG_TX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_TX_DATA_FLIP, x)
+
+#define PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA       BIT(6)
+#define PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+#define PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+
+#define PCS10G_BR_PCS_CFG_TX_TEST_MODE           BIT(4)
+#define PCS10G_BR_PCS_CFG_TX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_TX_TEST_MODE, x)
+#define PCS10G_BR_PCS_CFG_TX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_TX_TEST_MODE, x)
+
+#define PCS10G_BR_PCS_CFG_TX_SCR_DISABLE         BIT(3)
+#define PCS10G_BR_PCS_CFG_TX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+#define PCS10G_BR_PCS_CFG_TX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_SD_CFG */
+#define PCS10G_BR_PCS_SD_CFG(t)   __REG(TARGET_PCS10G_BR, t, 12, 0, 0, 1, 56, 4, 0, 1, 4)
+
+#define PCS10G_BR_PCS_SD_CFG_SD_SEL              BIT(8)
+#define PCS10G_BR_PCS_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_SD_CFG_SD_SEL, x)
+#define PCS10G_BR_PCS_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_SD_CFG_SD_SEL, x)
+
+#define PCS10G_BR_PCS_SD_CFG_SD_POL              BIT(4)
+#define PCS10G_BR_PCS_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_SD_CFG_SD_POL, x)
+#define PCS10G_BR_PCS_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_SD_CFG_SD_POL, x)
+
+#define PCS10G_BR_PCS_SD_CFG_SD_ENA              BIT(0)
+#define PCS10G_BR_PCS_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(PCS10G_BR_PCS_SD_CFG_SD_ENA, x)
+#define PCS10G_BR_PCS_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(PCS10G_BR_PCS_SD_CFG_SD_ENA, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_CFG */
+#define PCS25G_BR_PCS_CFG(t)      __REG(TARGET_PCS25G_BR, t, 8, 0, 0, 1, 56, 0, 0, 1, 4)
+
+#define PCS25G_BR_PCS_CFG_PCS_ENA                BIT(31)
+#define PCS25G_BR_PCS_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_PCS_ENA, x)
+#define PCS25G_BR_PCS_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_PCS_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA       BIT(30)
+#define PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+#define PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_SH_CNT_MAX             GENMASK(29, 24)
+#define PCS25G_BR_PCS_CFG_SH_CNT_MAX_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_SH_CNT_MAX, x)
+#define PCS25G_BR_PCS_CFG_SH_CNT_MAX_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_SH_CNT_MAX, x)
+
+#define PCS25G_BR_PCS_CFG_RX_DATA_FLIP           BIT(18)
+#define PCS25G_BR_PCS_CFG_RX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RX_DATA_FLIP, x)
+#define PCS25G_BR_PCS_CFG_RX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RX_DATA_FLIP, x)
+
+#define PCS25G_BR_PCS_CFG_RESYNC_ENA             BIT(15)
+#define PCS25G_BR_PCS_CFG_RESYNC_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RESYNC_ENA, x)
+#define PCS25G_BR_PCS_CFG_RESYNC_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RESYNC_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_LF_GEN_DIS             BIT(14)
+#define PCS25G_BR_PCS_CFG_LF_GEN_DIS_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_LF_GEN_DIS, x)
+#define PCS25G_BR_PCS_CFG_LF_GEN_DIS_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_LF_GEN_DIS, x)
+
+#define PCS25G_BR_PCS_CFG_RX_TEST_MODE           BIT(13)
+#define PCS25G_BR_PCS_CFG_RX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RX_TEST_MODE, x)
+#define PCS25G_BR_PCS_CFG_RX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RX_TEST_MODE, x)
+
+#define PCS25G_BR_PCS_CFG_RX_SCR_DISABLE         BIT(12)
+#define PCS25G_BR_PCS_CFG_RX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+#define PCS25G_BR_PCS_CFG_RX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+
+#define PCS25G_BR_PCS_CFG_TX_DATA_FLIP           BIT(7)
+#define PCS25G_BR_PCS_CFG_TX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_TX_DATA_FLIP, x)
+#define PCS25G_BR_PCS_CFG_TX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_TX_DATA_FLIP, x)
+
+#define PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA       BIT(6)
+#define PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+#define PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+
+#define PCS25G_BR_PCS_CFG_TX_TEST_MODE           BIT(4)
+#define PCS25G_BR_PCS_CFG_TX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_TX_TEST_MODE, x)
+#define PCS25G_BR_PCS_CFG_TX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_TX_TEST_MODE, x)
+
+#define PCS25G_BR_PCS_CFG_TX_SCR_DISABLE         BIT(3)
+#define PCS25G_BR_PCS_CFG_TX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+#define PCS25G_BR_PCS_CFG_TX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_SD_CFG */
+#define PCS25G_BR_PCS_SD_CFG(t)   __REG(TARGET_PCS25G_BR, t, 8, 0, 0, 1, 56, 4, 0, 1, 4)
+
+#define PCS25G_BR_PCS_SD_CFG_SD_SEL              BIT(8)
+#define PCS25G_BR_PCS_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_SD_CFG_SD_SEL, x)
+#define PCS25G_BR_PCS_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_SD_CFG_SD_SEL, x)
+
+#define PCS25G_BR_PCS_SD_CFG_SD_POL              BIT(4)
+#define PCS25G_BR_PCS_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_SD_CFG_SD_POL, x)
+#define PCS25G_BR_PCS_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_SD_CFG_SD_POL, x)
+
+#define PCS25G_BR_PCS_SD_CFG_SD_ENA              BIT(0)
+#define PCS25G_BR_PCS_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(PCS25G_BR_PCS_SD_CFG_SD_ENA, x)
+#define PCS25G_BR_PCS_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(PCS25G_BR_PCS_SD_CFG_SD_ENA, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_CFG */
+#define PCS5G_BR_PCS_CFG(t)       __REG(TARGET_PCS5G_BR, t, 13, 0, 0, 1, 56, 0, 0, 1, 4)
+
+#define PCS5G_BR_PCS_CFG_PCS_ENA                 BIT(31)
+#define PCS5G_BR_PCS_CFG_PCS_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_PCS_ENA, x)
+#define PCS5G_BR_PCS_CFG_PCS_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_PCS_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA        BIT(30)
+#define PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+#define PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_PMA_LOOPBACK_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_SH_CNT_MAX              GENMASK(29, 24)
+#define PCS5G_BR_PCS_CFG_SH_CNT_MAX_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_SH_CNT_MAX, x)
+#define PCS5G_BR_PCS_CFG_SH_CNT_MAX_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_SH_CNT_MAX, x)
+
+#define PCS5G_BR_PCS_CFG_RX_DATA_FLIP            BIT(18)
+#define PCS5G_BR_PCS_CFG_RX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RX_DATA_FLIP, x)
+#define PCS5G_BR_PCS_CFG_RX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RX_DATA_FLIP, x)
+
+#define PCS5G_BR_PCS_CFG_RESYNC_ENA              BIT(15)
+#define PCS5G_BR_PCS_CFG_RESYNC_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RESYNC_ENA, x)
+#define PCS5G_BR_PCS_CFG_RESYNC_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RESYNC_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_LF_GEN_DIS              BIT(14)
+#define PCS5G_BR_PCS_CFG_LF_GEN_DIS_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_LF_GEN_DIS, x)
+#define PCS5G_BR_PCS_CFG_LF_GEN_DIS_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_LF_GEN_DIS, x)
+
+#define PCS5G_BR_PCS_CFG_RX_TEST_MODE            BIT(13)
+#define PCS5G_BR_PCS_CFG_RX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RX_TEST_MODE, x)
+#define PCS5G_BR_PCS_CFG_RX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RX_TEST_MODE, x)
+
+#define PCS5G_BR_PCS_CFG_RX_SCR_DISABLE          BIT(12)
+#define PCS5G_BR_PCS_CFG_RX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+#define PCS5G_BR_PCS_CFG_RX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_RX_SCR_DISABLE, x)
+
+#define PCS5G_BR_PCS_CFG_TX_DATA_FLIP            BIT(7)
+#define PCS5G_BR_PCS_CFG_TX_DATA_FLIP_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_TX_DATA_FLIP, x)
+#define PCS5G_BR_PCS_CFG_TX_DATA_FLIP_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_TX_DATA_FLIP, x)
+
+#define PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA        BIT(6)
+#define PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+#define PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_AN_LINK_CTRL_ENA, x)
+
+#define PCS5G_BR_PCS_CFG_TX_TEST_MODE            BIT(4)
+#define PCS5G_BR_PCS_CFG_TX_TEST_MODE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_TX_TEST_MODE, x)
+#define PCS5G_BR_PCS_CFG_TX_TEST_MODE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_TX_TEST_MODE, x)
+
+#define PCS5G_BR_PCS_CFG_TX_SCR_DISABLE          BIT(3)
+#define PCS5G_BR_PCS_CFG_TX_SCR_DISABLE_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+#define PCS5G_BR_PCS_CFG_TX_SCR_DISABLE_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_CFG_TX_SCR_DISABLE, x)
+
+/*      PCS_10GBASE_R:PCS_10GBR_CFG:PCS_SD_CFG */
+#define PCS5G_BR_PCS_SD_CFG(t)    __REG(TARGET_PCS5G_BR, t, 13, 0, 0, 1, 56, 4, 0, 1, 4)
+
+#define PCS5G_BR_PCS_SD_CFG_SD_SEL               BIT(8)
+#define PCS5G_BR_PCS_SD_CFG_SD_SEL_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_SD_CFG_SD_SEL, x)
+#define PCS5G_BR_PCS_SD_CFG_SD_SEL_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_SD_CFG_SD_SEL, x)
+
+#define PCS5G_BR_PCS_SD_CFG_SD_POL               BIT(4)
+#define PCS5G_BR_PCS_SD_CFG_SD_POL_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_SD_CFG_SD_POL, x)
+#define PCS5G_BR_PCS_SD_CFG_SD_POL_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_SD_CFG_SD_POL, x)
+
+#define PCS5G_BR_PCS_SD_CFG_SD_ENA               BIT(0)
+#define PCS5G_BR_PCS_SD_CFG_SD_ENA_SET(x)\
+	FIELD_PREP(PCS5G_BR_PCS_SD_CFG_SD_ENA, x)
+#define PCS5G_BR_PCS_SD_CFG_SD_ENA_GET(x)\
+	FIELD_GET(PCS5G_BR_PCS_SD_CFG_SD_ENA, x)
+
+/*      PORT_CONF:HW_CFG:DEV5G_MODES */
+#define PORT_CONF_DEV5G_MODES     __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 0, 0, 1, 4)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE      BIT(0)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D0_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE      BIT(1)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D1_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE      BIT(2)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D2_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE      BIT(3)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D3_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE      BIT(4)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D4_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE      BIT(5)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D5_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE      BIT(6)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D6_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE      BIT(7)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D7_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE      BIT(8)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D8_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE      BIT(9)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D9_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE     BIT(10)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D10_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE     BIT(11)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D11_MODE, x)
+
+#define PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE     BIT(12)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE, x)
+#define PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV5G_MODES_DEV5G_D64_MODE, x)
+
+/*      PORT_CONF:HW_CFG:DEV10G_MODES */
+#define PORT_CONF_DEV10G_MODES    __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 4, 0, 1, 4)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE   BIT(0)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D12_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE   BIT(1)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D13_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE   BIT(2)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D14_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE   BIT(3)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D15_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE   BIT(4)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D48_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE   BIT(5)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D49_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE   BIT(6)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D50_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE   BIT(7)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D51_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE   BIT(8)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D52_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE   BIT(9)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D53_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE   BIT(10)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D54_MODE, x)
+
+#define PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE   BIT(11)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE, x)
+#define PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV10G_MODES_DEV10G_D55_MODE, x)
+
+/*      PORT_CONF:HW_CFG:DEV25G_MODES */
+#define PORT_CONF_DEV25G_MODES    __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 8, 0, 1, 4)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE   BIT(0)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D56_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE   BIT(1)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D57_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE   BIT(2)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D58_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE   BIT(3)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D59_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE   BIT(4)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D60_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE   BIT(5)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D61_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE   BIT(6)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D62_MODE, x)
+
+#define PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE   BIT(7)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE, x)
+#define PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_DEV25G_MODES_DEV25G_D63_MODE, x)
+
+/*      PORT_CONF:HW_CFG:QSGMII_ENA */
+#define PORT_CONF_QSGMII_ENA      __REG(TARGET_PORT_CONF, 0, 1, 0, 0, 1, 24, 12, 0, 1, 4)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_0        BIT(0)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_0_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_0, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_0_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_0, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_1        BIT(1)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_1_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_1, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_1_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_1, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_2        BIT(2)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_2_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_2, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_2_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_2, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_3        BIT(3)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_3_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_3, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_3_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_3, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_4        BIT(4)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_4_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_4, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_4_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_4, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_5        BIT(5)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_5_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_5, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_5_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_5, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_6        BIT(6)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_6_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_6, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_6_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_6, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_7        BIT(7)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_7_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_7, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_7_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_7, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_8        BIT(8)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_8_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_8, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_8_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_8, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_9        BIT(9)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_9_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_9, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_9_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_9, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_10       BIT(10)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_10_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_10, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_10_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_10, x)
+
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_11       BIT(11)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_11_SET(x)\
+	FIELD_PREP(PORT_CONF_QSGMII_ENA_QSGMII_ENA_11, x)
+#define PORT_CONF_QSGMII_ENA_QSGMII_ENA_11_GET(x)\
+	FIELD_GET(PORT_CONF_QSGMII_ENA_QSGMII_ENA_11, x)
+
+/*      PORT_CONF:USGMII_CFG_STAT:USGMII_CFG */
+#define PORT_CONF_USGMII_CFG(g)   __REG(TARGET_PORT_CONF, 0, 1, 72, g, 6, 8, 0, 0, 1, 4)
+
+#define PORT_CONF_USGMII_CFG_BYPASS_SCRAM        BIT(9)
+#define PORT_CONF_USGMII_CFG_BYPASS_SCRAM_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_BYPASS_SCRAM, x)
+#define PORT_CONF_USGMII_CFG_BYPASS_SCRAM_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_BYPASS_SCRAM, x)
+
+#define PORT_CONF_USGMII_CFG_BYPASS_DESCRAM      BIT(8)
+#define PORT_CONF_USGMII_CFG_BYPASS_DESCRAM_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_BYPASS_DESCRAM, x)
+#define PORT_CONF_USGMII_CFG_BYPASS_DESCRAM_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_BYPASS_DESCRAM, x)
+
+#define PORT_CONF_USGMII_CFG_FLIP_LANES          BIT(7)
+#define PORT_CONF_USGMII_CFG_FLIP_LANES_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_FLIP_LANES, x)
+#define PORT_CONF_USGMII_CFG_FLIP_LANES_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_FLIP_LANES, x)
+
+#define PORT_CONF_USGMII_CFG_SHYST_DIS           BIT(6)
+#define PORT_CONF_USGMII_CFG_SHYST_DIS_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_SHYST_DIS, x)
+#define PORT_CONF_USGMII_CFG_SHYST_DIS_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_SHYST_DIS, x)
+
+#define PORT_CONF_USGMII_CFG_E_DET_ENA           BIT(5)
+#define PORT_CONF_USGMII_CFG_E_DET_ENA_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_E_DET_ENA, x)
+#define PORT_CONF_USGMII_CFG_E_DET_ENA_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_E_DET_ENA, x)
+
+#define PORT_CONF_USGMII_CFG_USE_I1_ENA          BIT(4)
+#define PORT_CONF_USGMII_CFG_USE_I1_ENA_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_USE_I1_ENA, x)
+#define PORT_CONF_USGMII_CFG_USE_I1_ENA_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_USE_I1_ENA, x)
+
+#define PORT_CONF_USGMII_CFG_QUAD_MODE           BIT(1)
+#define PORT_CONF_USGMII_CFG_QUAD_MODE_SET(x)\
+	FIELD_PREP(PORT_CONF_USGMII_CFG_QUAD_MODE, x)
+#define PORT_CONF_USGMII_CFG_QUAD_MODE_GET(x)\
+	FIELD_GET(PORT_CONF_USGMII_CFG_QUAD_MODE, x)
+
+/*      QFWD:SYSTEM:SWITCH_PORT_MODE */
+#define QFWD_SWITCH_PORT_MODE(r)  __REG(TARGET_QFWD, 0, 1, 0, 0, 1, 340, 0, r, 70, 4)
+
+#define QFWD_SWITCH_PORT_MODE_PORT_ENA           BIT(19)
+#define QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_PORT_ENA, x)
+#define QFWD_SWITCH_PORT_MODE_PORT_ENA_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_PORT_ENA, x)
+
+#define QFWD_SWITCH_PORT_MODE_FWD_URGENCY        GENMASK(18, 10)
+#define QFWD_SWITCH_PORT_MODE_FWD_URGENCY_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_FWD_URGENCY, x)
+#define QFWD_SWITCH_PORT_MODE_FWD_URGENCY_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_FWD_URGENCY, x)
+
+#define QFWD_SWITCH_PORT_MODE_YEL_RSRVD          GENMASK(9, 6)
+#define QFWD_SWITCH_PORT_MODE_YEL_RSRVD_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_YEL_RSRVD, x)
+#define QFWD_SWITCH_PORT_MODE_YEL_RSRVD_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_YEL_RSRVD, x)
+
+#define QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE  BIT(5)
+#define QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE, x)
+#define QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_INGRESS_DROP_MODE, x)
+
+#define QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING     BIT(4)
+#define QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING, x)
+#define QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_IGR_NO_SHARING, x)
+
+#define QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING     BIT(3)
+#define QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING, x)
+#define QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_EGR_NO_SHARING, x)
+
+#define QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE   BIT(2)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE, x)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_EGRESS_DROP_MODE, x)
+
+#define QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS    BIT(1)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS, x)
+#define QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_EGRESS_RSRV_DIS, x)
+
+#define QFWD_SWITCH_PORT_MODE_LEARNALL_MORE      BIT(0)
+#define QFWD_SWITCH_PORT_MODE_LEARNALL_MORE_SET(x)\
+	FIELD_PREP(QFWD_SWITCH_PORT_MODE_LEARNALL_MORE, x)
+#define QFWD_SWITCH_PORT_MODE_LEARNALL_MORE_GET(x)\
+	FIELD_GET(QFWD_SWITCH_PORT_MODE_LEARNALL_MORE, x)
+
+/*      QRES:RES_CTRL:RES_CFG */
+#define QRES_RES_CFG(g)           __REG(TARGET_QRES, 0, 1, 0, g, 5120, 16, 0, 0, 1, 4)
+
+#define QRES_RES_CFG_WM_HIGH                     GENMASK(11, 0)
+#define QRES_RES_CFG_WM_HIGH_SET(x)\
+	FIELD_PREP(QRES_RES_CFG_WM_HIGH, x)
+#define QRES_RES_CFG_WM_HIGH_GET(x)\
+	FIELD_GET(QRES_RES_CFG_WM_HIGH, x)
+
+/*      QRES:RES_CTRL:RES_STAT */
+#define QRES_RES_STAT(g)          __REG(TARGET_QRES, 0, 1, 0, g, 5120, 16, 4, 0, 1, 4)
+
+#define QRES_RES_STAT_MAXUSE                     GENMASK(20, 0)
+#define QRES_RES_STAT_MAXUSE_SET(x)\
+	FIELD_PREP(QRES_RES_STAT_MAXUSE, x)
+#define QRES_RES_STAT_MAXUSE_GET(x)\
+	FIELD_GET(QRES_RES_STAT_MAXUSE, x)
+
+/*      QRES:RES_CTRL:RES_STAT_CUR */
+#define QRES_RES_STAT_CUR(g)      __REG(TARGET_QRES, 0, 1, 0, g, 5120, 16, 8, 0, 1, 4)
+
+#define QRES_RES_STAT_CUR_INUSE                  GENMASK(20, 0)
+#define QRES_RES_STAT_CUR_INUSE_SET(x)\
+	FIELD_PREP(QRES_RES_STAT_CUR_INUSE, x)
+#define QRES_RES_STAT_CUR_INUSE_GET(x)\
+	FIELD_GET(QRES_RES_STAT_CUR_INUSE, x)
+
+/*      DEVCPU_QS:XTR:XTR_GRP_CFG */
+#define QS_XTR_GRP_CFG(r)         __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 0, r, 2, 4)
+
+#define QS_XTR_GRP_CFG_MODE                      GENMASK(3, 2)
+#define QS_XTR_GRP_CFG_MODE_SET(x)\
+	FIELD_PREP(QS_XTR_GRP_CFG_MODE, x)
+#define QS_XTR_GRP_CFG_MODE_GET(x)\
+	FIELD_GET(QS_XTR_GRP_CFG_MODE, x)
+
+#define QS_XTR_GRP_CFG_STATUS_WORD_POS           BIT(1)
+#define QS_XTR_GRP_CFG_STATUS_WORD_POS_SET(x)\
+	FIELD_PREP(QS_XTR_GRP_CFG_STATUS_WORD_POS, x)
+#define QS_XTR_GRP_CFG_STATUS_WORD_POS_GET(x)\
+	FIELD_GET(QS_XTR_GRP_CFG_STATUS_WORD_POS, x)
+
+#define QS_XTR_GRP_CFG_BYTE_SWAP                 BIT(0)
+#define QS_XTR_GRP_CFG_BYTE_SWAP_SET(x)\
+	FIELD_PREP(QS_XTR_GRP_CFG_BYTE_SWAP, x)
+#define QS_XTR_GRP_CFG_BYTE_SWAP_GET(x)\
+	FIELD_GET(QS_XTR_GRP_CFG_BYTE_SWAP, x)
+
+/*      DEVCPU_QS:XTR:XTR_RD */
+#define QS_XTR_RD(r)              __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 8, r, 2, 4)
+
+/*      DEVCPU_QS:XTR:XTR_FLUSH */
+#define QS_XTR_FLUSH              __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 24, 0, 1, 4)
+
+#define QS_XTR_FLUSH_FLUSH                       GENMASK(1, 0)
+#define QS_XTR_FLUSH_FLUSH_SET(x)\
+	FIELD_PREP(QS_XTR_FLUSH_FLUSH, x)
+#define QS_XTR_FLUSH_FLUSH_GET(x)\
+	FIELD_GET(QS_XTR_FLUSH_FLUSH, x)
+
+/*      DEVCPU_QS:XTR:XTR_DATA_PRESENT */
+#define QS_XTR_DATA_PRESENT       __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 28, 0, 1, 4)
+
+#define QS_XTR_DATA_PRESENT_DATA_PRESENT         GENMASK(1, 0)
+#define QS_XTR_DATA_PRESENT_DATA_PRESENT_SET(x)\
+	FIELD_PREP(QS_XTR_DATA_PRESENT_DATA_PRESENT, x)
+#define QS_XTR_DATA_PRESENT_DATA_PRESENT_GET(x)\
+	FIELD_GET(QS_XTR_DATA_PRESENT_DATA_PRESENT, x)
+
+/*      DEVCPU_QS:INJ:INJ_GRP_CFG */
+#define QS_INJ_GRP_CFG(r)         __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 0, r, 2, 4)
+
+#define QS_INJ_GRP_CFG_MODE                      GENMASK(3, 2)
+#define QS_INJ_GRP_CFG_MODE_SET(x)\
+	FIELD_PREP(QS_INJ_GRP_CFG_MODE, x)
+#define QS_INJ_GRP_CFG_MODE_GET(x)\
+	FIELD_GET(QS_INJ_GRP_CFG_MODE, x)
+
+#define QS_INJ_GRP_CFG_BYTE_SWAP                 BIT(0)
+#define QS_INJ_GRP_CFG_BYTE_SWAP_SET(x)\
+	FIELD_PREP(QS_INJ_GRP_CFG_BYTE_SWAP, x)
+#define QS_INJ_GRP_CFG_BYTE_SWAP_GET(x)\
+	FIELD_GET(QS_INJ_GRP_CFG_BYTE_SWAP, x)
+
+/*      DEVCPU_QS:INJ:INJ_WR */
+#define QS_INJ_WR(r)              __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 8, r, 2, 4)
+
+/*      DEVCPU_QS:INJ:INJ_CTRL */
+#define QS_INJ_CTRL(r)            __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 16, r, 2, 4)
+
+#define QS_INJ_CTRL_GAP_SIZE                     GENMASK(24, 21)
+#define QS_INJ_CTRL_GAP_SIZE_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_GAP_SIZE, x)
+#define QS_INJ_CTRL_GAP_SIZE_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_GAP_SIZE, x)
+
+#define QS_INJ_CTRL_ABORT                        BIT(20)
+#define QS_INJ_CTRL_ABORT_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_ABORT, x)
+#define QS_INJ_CTRL_ABORT_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_ABORT, x)
+
+#define QS_INJ_CTRL_EOF                          BIT(19)
+#define QS_INJ_CTRL_EOF_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_EOF, x)
+#define QS_INJ_CTRL_EOF_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_EOF, x)
+
+#define QS_INJ_CTRL_SOF                          BIT(18)
+#define QS_INJ_CTRL_SOF_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_SOF, x)
+#define QS_INJ_CTRL_SOF_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_SOF, x)
+
+#define QS_INJ_CTRL_VLD_BYTES                    GENMASK(17, 16)
+#define QS_INJ_CTRL_VLD_BYTES_SET(x)\
+	FIELD_PREP(QS_INJ_CTRL_VLD_BYTES, x)
+#define QS_INJ_CTRL_VLD_BYTES_GET(x)\
+	FIELD_GET(QS_INJ_CTRL_VLD_BYTES, x)
+
+/*      DEVCPU_QS:INJ:INJ_STATUS */
+#define QS_INJ_STATUS             __REG(TARGET_QS, 0, 1, 36, 0, 1, 40, 24, 0, 1, 4)
+
+#define QS_INJ_STATUS_WMARK_REACHED              GENMASK(5, 4)
+#define QS_INJ_STATUS_WMARK_REACHED_SET(x)\
+	FIELD_PREP(QS_INJ_STATUS_WMARK_REACHED, x)
+#define QS_INJ_STATUS_WMARK_REACHED_GET(x)\
+	FIELD_GET(QS_INJ_STATUS_WMARK_REACHED, x)
+
+#define QS_INJ_STATUS_FIFO_RDY                   GENMASK(3, 2)
+#define QS_INJ_STATUS_FIFO_RDY_SET(x)\
+	FIELD_PREP(QS_INJ_STATUS_FIFO_RDY, x)
+#define QS_INJ_STATUS_FIFO_RDY_GET(x)\
+	FIELD_GET(QS_INJ_STATUS_FIFO_RDY, x)
+
+#define QS_INJ_STATUS_INJ_IN_PROGRESS            GENMASK(1, 0)
+#define QS_INJ_STATUS_INJ_IN_PROGRESS_SET(x)\
+	FIELD_PREP(QS_INJ_STATUS_INJ_IN_PROGRESS, x)
+#define QS_INJ_STATUS_INJ_IN_PROGRESS_GET(x)\
+	FIELD_GET(QS_INJ_STATUS_INJ_IN_PROGRESS, x)
+
+/*      QSYS:PAUSE_CFG:PAUSE_CFG */
+#define QSYS_PAUSE_CFG(r)         __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 0, r, 70, 4)
+
+#define QSYS_PAUSE_CFG_PAUSE_START               GENMASK(25, 14)
+#define QSYS_PAUSE_CFG_PAUSE_START_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_PAUSE_START, x)
+#define QSYS_PAUSE_CFG_PAUSE_START_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_PAUSE_START, x)
+
+#define QSYS_PAUSE_CFG_PAUSE_STOP                GENMASK(13, 2)
+#define QSYS_PAUSE_CFG_PAUSE_STOP_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_PAUSE_STOP, x)
+#define QSYS_PAUSE_CFG_PAUSE_STOP_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_PAUSE_STOP, x)
+
+#define QSYS_PAUSE_CFG_PAUSE_ENA                 BIT(1)
+#define QSYS_PAUSE_CFG_PAUSE_ENA_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_PAUSE_ENA, x)
+#define QSYS_PAUSE_CFG_PAUSE_ENA_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_PAUSE_ENA, x)
+
+#define QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA   BIT(0)
+#define QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA_SET(x)\
+	FIELD_PREP(QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA, x)
+#define QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA_GET(x)\
+	FIELD_GET(QSYS_PAUSE_CFG_AGGRESSIVE_TAILDROP_ENA, x)
+
+/*      QSYS:PAUSE_CFG:ATOP */
+#define QSYS_ATOP(r)              __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 284, r, 70, 4)
+
+#define QSYS_ATOP_ATOP                           GENMASK(11, 0)
+#define QSYS_ATOP_ATOP_SET(x)\
+	FIELD_PREP(QSYS_ATOP_ATOP, x)
+#define QSYS_ATOP_ATOP_GET(x)\
+	FIELD_GET(QSYS_ATOP_ATOP, x)
+
+/*      QSYS:PAUSE_CFG:FWD_PRESSURE */
+#define QSYS_FWD_PRESSURE(r)      __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 564, r, 70, 4)
+
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE           GENMASK(11, 1)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_SET(x)\
+	FIELD_PREP(QSYS_FWD_PRESSURE_FWD_PRESSURE, x)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_GET(x)\
+	FIELD_GET(QSYS_FWD_PRESSURE_FWD_PRESSURE, x)
+
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS       BIT(0)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS_SET(x)\
+	FIELD_PREP(QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS, x)
+#define QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS_GET(x)\
+	FIELD_GET(QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS, x)
+
+/*      QSYS:PAUSE_CFG:ATOP_TOT_CFG */
+#define QSYS_ATOP_TOT_CFG         __REG(TARGET_QSYS, 0, 1, 544, 0, 1, 1128, 844, 0, 1, 4)
+
+#define QSYS_ATOP_TOT_CFG_ATOP_TOT               GENMASK(11, 0)
+#define QSYS_ATOP_TOT_CFG_ATOP_TOT_SET(x)\
+	FIELD_PREP(QSYS_ATOP_TOT_CFG_ATOP_TOT, x)
+#define QSYS_ATOP_TOT_CFG_ATOP_TOT_GET(x)\
+	FIELD_GET(QSYS_ATOP_TOT_CFG_ATOP_TOT, x)
+
+/*      QSYS:CALCFG:CAL_AUTO */
+#define QSYS_CAL_AUTO(r)          __REG(TARGET_QSYS, 0, 1, 2304, 0, 1, 40, 0, r, 7, 4)
+
+#define QSYS_CAL_AUTO_CAL_AUTO                   GENMASK(29, 0)
+#define QSYS_CAL_AUTO_CAL_AUTO_SET(x)\
+	FIELD_PREP(QSYS_CAL_AUTO_CAL_AUTO, x)
+#define QSYS_CAL_AUTO_CAL_AUTO_GET(x)\
+	FIELD_GET(QSYS_CAL_AUTO_CAL_AUTO, x)
+
+/*      QSYS:CALCFG:CAL_CTRL */
+#define QSYS_CAL_CTRL             __REG(TARGET_QSYS, 0, 1, 2304, 0, 1, 40, 36, 0, 1, 4)
+
+#define QSYS_CAL_CTRL_CAL_MODE                   GENMASK(14, 11)
+#define QSYS_CAL_CTRL_CAL_MODE_SET(x)\
+	FIELD_PREP(QSYS_CAL_CTRL_CAL_MODE, x)
+#define QSYS_CAL_CTRL_CAL_MODE_GET(x)\
+	FIELD_GET(QSYS_CAL_CTRL_CAL_MODE, x)
+
+#define QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE        GENMASK(10, 1)
+#define QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE_SET(x)\
+	FIELD_PREP(QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE, x)
+#define QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE_GET(x)\
+	FIELD_GET(QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE, x)
+
+#define QSYS_CAL_CTRL_CAL_AUTO_ERROR             BIT(0)
+#define QSYS_CAL_CTRL_CAL_AUTO_ERROR_SET(x)\
+	FIELD_PREP(QSYS_CAL_CTRL_CAL_AUTO_ERROR, x)
+#define QSYS_CAL_CTRL_CAL_AUTO_ERROR_GET(x)\
+	FIELD_GET(QSYS_CAL_CTRL_CAL_AUTO_ERROR, x)
+
+/*      QSYS:RAM_CTRL:RAM_INIT */
+#define QSYS_RAM_INIT             __REG(TARGET_QSYS, 0, 1, 2344, 0, 1, 4, 0, 0, 1, 4)
+
+#define QSYS_RAM_INIT_RAM_INIT                   BIT(1)
+#define QSYS_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(QSYS_RAM_INIT_RAM_INIT, x)
+#define QSYS_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(QSYS_RAM_INIT_RAM_INIT, x)
+
+#define QSYS_RAM_INIT_RAM_CFG_HOOK               BIT(0)
+#define QSYS_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(QSYS_RAM_INIT_RAM_CFG_HOOK, x)
+#define QSYS_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(QSYS_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      REW:COMMON:OWN_UPSID */
+#define REW_OWN_UPSID(r)          __REG(TARGET_REW, 0, 1, 387264, 0, 1, 1232, 0, r, 3, 4)
+
+#define REW_OWN_UPSID_OWN_UPSID                  GENMASK(4, 0)
+#define REW_OWN_UPSID_OWN_UPSID_SET(x)\
+	FIELD_PREP(REW_OWN_UPSID_OWN_UPSID, x)
+#define REW_OWN_UPSID_OWN_UPSID_GET(x)\
+	FIELD_GET(REW_OWN_UPSID_OWN_UPSID, x)
+
+/*      REW:PORT:PORT_VLAN_CFG */
+#define REW_PORT_VLAN_CFG(g)      __REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 0, 0, 1, 4)
+
+#define REW_PORT_VLAN_CFG_PORT_PCP               GENMASK(15, 13)
+#define REW_PORT_VLAN_CFG_PORT_PCP_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_PCP, x)
+#define REW_PORT_VLAN_CFG_PORT_PCP_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_PCP, x)
+
+#define REW_PORT_VLAN_CFG_PORT_DEI               BIT(12)
+#define REW_PORT_VLAN_CFG_PORT_DEI_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_DEI, x)
+#define REW_PORT_VLAN_CFG_PORT_DEI_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_DEI, x)
+
+#define REW_PORT_VLAN_CFG_PORT_VID               GENMASK(11, 0)
+#define REW_PORT_VLAN_CFG_PORT_VID_SET(x)\
+	FIELD_PREP(REW_PORT_VLAN_CFG_PORT_VID, x)
+#define REW_PORT_VLAN_CFG_PORT_VID_GET(x)\
+	FIELD_GET(REW_PORT_VLAN_CFG_PORT_VID, x)
+
+/*      REW:PORT:TAG_CTRL */
+#define REW_TAG_CTRL(g)           __REG(TARGET_REW, 0, 1, 360448, g, 70, 256, 132, 0, 1, 4)
+
+#define REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED     BIT(13)
+#define REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED, x)
+#define REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_CFG_OBEY_WAS_TAGGED, x)
+
+#define REW_TAG_CTRL_TAG_CFG                     GENMASK(12, 11)
+#define REW_TAG_CTRL_TAG_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_CFG, x)
+#define REW_TAG_CTRL_TAG_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_CFG, x)
+
+#define REW_TAG_CTRL_TAG_TPID_CFG                GENMASK(10, 8)
+#define REW_TAG_CTRL_TAG_TPID_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_TPID_CFG, x)
+#define REW_TAG_CTRL_TAG_TPID_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_TPID_CFG, x)
+
+#define REW_TAG_CTRL_TAG_VID_CFG                 GENMASK(7, 6)
+#define REW_TAG_CTRL_TAG_VID_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_VID_CFG, x)
+#define REW_TAG_CTRL_TAG_VID_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_VID_CFG, x)
+
+#define REW_TAG_CTRL_TAG_PCP_CFG                 GENMASK(5, 3)
+#define REW_TAG_CTRL_TAG_PCP_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_PCP_CFG, x)
+#define REW_TAG_CTRL_TAG_PCP_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_PCP_CFG, x)
+
+#define REW_TAG_CTRL_TAG_DEI_CFG                 GENMASK(2, 0)
+#define REW_TAG_CTRL_TAG_DEI_CFG_SET(x)\
+	FIELD_PREP(REW_TAG_CTRL_TAG_DEI_CFG, x)
+#define REW_TAG_CTRL_TAG_DEI_CFG_GET(x)\
+	FIELD_GET(REW_TAG_CTRL_TAG_DEI_CFG, x)
+
+/*      REW:RAM_CTRL:RAM_INIT */
+#define REW_RAM_INIT              __REG(TARGET_REW, 0, 1, 378696, 0, 1, 4, 0, 0, 1, 4)
+
+#define REW_RAM_INIT_RAM_INIT                    BIT(1)
+#define REW_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(REW_RAM_INIT_RAM_INIT, x)
+#define REW_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(REW_RAM_INIT_RAM_INIT, x)
+
+#define REW_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define REW_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(REW_RAM_INIT_RAM_CFG_HOOK, x)
+#define REW_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(REW_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      VCAP_SUPER:RAM_CTRL:RAM_INIT */
+#define VCAP_SUPER_RAM_INIT       __REG(TARGET_VCAP_SUPER, 0, 1, 1120, 0, 1, 4, 0, 0, 1, 4)
+
+#define VCAP_SUPER_RAM_INIT_RAM_INIT             BIT(1)
+#define VCAP_SUPER_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(VCAP_SUPER_RAM_INIT_RAM_INIT, x)
+#define VCAP_SUPER_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(VCAP_SUPER_RAM_INIT_RAM_INIT, x)
+
+#define VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK         BIT(0)
+#define VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK, x)
+#define VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(VCAP_SUPER_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      VOP:RAM_CTRL:RAM_INIT */
+#define VOP_RAM_INIT              __REG(TARGET_VOP, 0, 1, 279176, 0, 1, 4, 0, 0, 1, 4)
+
+#define VOP_RAM_INIT_RAM_INIT                    BIT(1)
+#define VOP_RAM_INIT_RAM_INIT_SET(x)\
+	FIELD_PREP(VOP_RAM_INIT_RAM_INIT, x)
+#define VOP_RAM_INIT_RAM_INIT_GET(x)\
+	FIELD_GET(VOP_RAM_INIT_RAM_INIT, x)
+
+#define VOP_RAM_INIT_RAM_CFG_HOOK                BIT(0)
+#define VOP_RAM_INIT_RAM_CFG_HOOK_SET(x)\
+	FIELD_PREP(VOP_RAM_INIT_RAM_CFG_HOOK, x)
+#define VOP_RAM_INIT_RAM_CFG_HOOK_GET(x)\
+	FIELD_GET(VOP_RAM_INIT_RAM_CFG_HOOK, x)
+
+/*      XQS:SYSTEM:STAT_CFG */
+#define XQS_STAT_CFG              __REG(TARGET_XQS, 0, 1, 6768, 0, 1, 872, 860, 0, 1, 4)
+
+#define XQS_STAT_CFG_STAT_CLEAR_SHOT             GENMASK(21, 18)
+#define XQS_STAT_CFG_STAT_CLEAR_SHOT_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_CLEAR_SHOT, x)
+#define XQS_STAT_CFG_STAT_CLEAR_SHOT_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_CLEAR_SHOT, x)
+
+#define XQS_STAT_CFG_STAT_VIEW                   GENMASK(17, 5)
+#define XQS_STAT_CFG_STAT_VIEW_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_VIEW, x)
+#define XQS_STAT_CFG_STAT_VIEW_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_VIEW, x)
+
+#define XQS_STAT_CFG_STAT_SRV_PKT_ONLY           BIT(4)
+#define XQS_STAT_CFG_STAT_SRV_PKT_ONLY_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_SRV_PKT_ONLY, x)
+#define XQS_STAT_CFG_STAT_SRV_PKT_ONLY_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_SRV_PKT_ONLY, x)
+
+#define XQS_STAT_CFG_STAT_WRAP_DIS               GENMASK(3, 0)
+#define XQS_STAT_CFG_STAT_WRAP_DIS_SET(x)\
+	FIELD_PREP(XQS_STAT_CFG_STAT_WRAP_DIS, x)
+#define XQS_STAT_CFG_STAT_WRAP_DIS_GET(x)\
+	FIELD_GET(XQS_STAT_CFG_STAT_WRAP_DIS, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_TOP_CFG */
+#define XQS_QLIMIT_SHR_TOP_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 0, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP    GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP, x)
+#define XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_TOP_CFG_QLIMIT_SHR_TOP, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_ATOP_CFG */
+#define XQS_QLIMIT_SHR_ATOP_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 4, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP  GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP, x)
+#define XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_ATOP_CFG_QLIMIT_SHR_ATOP, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_CTOP_CFG */
+#define XQS_QLIMIT_SHR_CTOP_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 8, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP  GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP, x)
+#define XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_CTOP_CFG_QLIMIT_SHR_CTOP, x)
+
+/*      XQS:QLIMIT_SHR:QLIMIT_SHR_QLIM_CFG */
+#define XQS_QLIMIT_SHR_QLIM_CFG(g) __REG(TARGET_XQS, 0, 1, 7936, g, 4, 48, 12, 0, 1, 4)
+
+#define XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM  GENMASK(14, 0)
+#define XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM_SET(x)\
+	FIELD_PREP(XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM, x)
+#define XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM_GET(x)\
+	FIELD_GET(XQS_QLIMIT_SHR_QLIM_CFG_QLIMIT_SHR_QLIM, x)
+
+/*      XQS:STAT:CNT */
+#define XQS_CNT(g)                __REG(TARGET_XQS, 0, 1, 0, g, 1024, 4, 0, 0, 1, 4)
+
+#endif /* _SPARX5_MAIN_REGS_H_ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
new file mode 100644
index 000000000000..e3797986d4c2
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main.h"
+#include "sparx5_port.h"
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
+	sparx5_port_enable(port, true);
+	if (port->conf.phy_mode != PHY_INTERFACE_MODE_NA) {
+		err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
+		if (err) {
+			netdev_err(ndev, "Could not attach to PHY\n");
+			return err;
+		}
+	}
+	if (!ndev->phydev) {
+		/* power up serdes */
+
+		port->conf.power_down = false;
+		if (port->conf.serdes_reset)
+			err = sparx5_serdes_set(port->sparx5, port, &port->conf);
+		else
+			err = phy_power_on(port->serdes);
+		if (err)
+			netdev_err(ndev, "%s failed\n", __func__);
+	}
+	phylink_start(port->phylink);
+	return err;
+}
+
+static int sparx5_port_stop(struct net_device *ndev)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	int err = 0;
+
+	sparx5_port_enable(port, false);
+	phylink_stop(port->phylink);
+	phylink_disconnect_phy(port->phylink);
+
+	if (!ndev->phydev) {
+		/* power down serdes */
+		port->conf.power_down = true;
+		if (port->conf.serdes_reset)
+			err = sparx5_serdes_set(port->sparx5, port, &port->conf);
+		else
+			err = phy_power_off(port->serdes);
+		if (err)
+			netdev_err(ndev, "%s failed\n", __func__);
+	}
+	return 0;
+}
+
+static void sparx5_set_rx_mode(struct net_device *dev)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!test_bit(port->portno, sparx5->bridge_mask))
+		__dev_mc_sync(dev, sparx5_mc_sync, sparx5_mc_unsync);
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
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+	const struct sockaddr *addr = p;
+
+	/* Remove current */
+	sparx5_mact_forget(sparx5, dev->dev_addr,  port->pvid);
+
+	/* Add new */
+	sparx5_mact_learn(sparx5, PGID_CPU, addr->sa_data, port->pvid);
+
+	/* Record the address */
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
+
+	return 0;
+}
+
+static int sparx5_get_port_parent_id(struct net_device *dev,
+				     struct netdev_phys_item_id *ppid)
+{
+	struct sparx5_port *sparx5_port = netdev_priv(dev);
+	struct sparx5 *sparx5 = sparx5_port->sparx5;
+
+	ppid->id_len = sizeof(sparx5->base_mac);
+	memcpy(&ppid->id, &sparx5->base_mac, ppid->id_len);
+
+	return 0;
+}
+
+static const struct net_device_ops sparx5_port_netdev_ops = {
+	.ndo_open               = sparx5_port_open,
+	.ndo_stop               = sparx5_port_stop,
+	.ndo_start_xmit         = sparx5_port_xmit_impl,
+	.ndo_set_rx_mode        = sparx5_set_rx_mode,
+	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
+	.ndo_set_mac_address    = sparx5_set_mac_address,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_get_stats64        = sparx5_get_stats64,
+	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
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
+	int err;
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
+	ether_setup(ndev);
+	ndev->netdev_ops = &sparx5_port_netdev_ops;
+	ndev->ethtool_ops = &sparx5_ethtool_ops;
+	ndev->features |= NETIF_F_LLTX; /* software tx */
+
+	ether_addr_copy(ndev->dev_addr, sparx5->base_mac);
+	ndev->dev_addr[ETH_ALEN - 1] += portno + 1;
+
+	err = register_netdev(ndev);
+	if (err) {
+		dev_err(sparx5->dev, "netdev registration failed\n");
+		return ERR_PTR(err);
+	}
+
+	return ndev;
+}
+
+void sparx5_destroy_netdev(struct sparx5 *sparx5, struct sparx5_port *port)
+{
+	if (port->phylink) {
+		/* Disconnect the phy */
+		if (rtnl_trylock()) {
+			sparx5_port_stop(port->ndev);
+			phylink_disconnect_phy(port->phylink);
+			rtnl_unlock();
+		}
+		phylink_destroy(port->phylink);
+		port->phylink = NULL;
+	}
+	if (port->ndev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(port->ndev);
+	free_netdev(port->ndev);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
new file mode 100644
index 000000000000..539b960478e7
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
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
+	SPX5_WR(QS_XTR_FLUSH_FLUSH_SET(BIT(grp)), sparx5, QS_XTR_FLUSH);
+
+	/* Allow to drain */
+	mdelay(1);
+
+	/* All Queues normal */
+	SPX5_WR(0, sparx5, QS_XTR_FLUSH);
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
+		ifh[i] = SPX5_RD(sparx5, QS_XTR_RD(grp));
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
+		u32 val = SPX5_RD(sparx5, QS_XTR_RD(grp));
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
+			*rxbuf = SPX5_RD(sparx5, QS_XTR_RD(grp));
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
+	if (!netif_oper_up(netdev)) {
+		netdev_err(netdev, "Discarded frame: Interface not up\n");
+		kfree_skb(skb);
+		return;
+	}
+
+	/* Everything we see on an interface that is in the HW bridge
+	 * has already been forwarded
+	 */
+	if (test_bit(port->portno, sparx5->bridge_mask))
+		skb->offload_fwd_mark = 1;
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
+	val = SPX5_RD(sparx5, QS_INJ_STATUS);
+	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
+		pr_err("Injection: Queue not ready: 0x%lx\n",
+		       QS_INJ_STATUS_FIFO_RDY_GET(val));
+		return -1;
+	}
+
+	if (QS_INJ_STATUS_WMARK_REACHED_GET(val) & BIT(grp)) {
+		pr_err("Injection: Watermark reached: 0x%lx\n",
+		       QS_INJ_STATUS_WMARK_REACHED_GET(val));
+		return -1;
+	}
+
+	/* Indicate SOF */
+	SPX5_WR(QS_INJ_CTRL_SOF_SET(1) |
+		QS_INJ_CTRL_GAP_SIZE_SET(1),
+		sparx5, QS_INJ_CTRL(grp));
+
+	// Write the IFH to the chip.
+	for (w = 0; w < IFH_LEN; w++)
+		SPX5_WR(ifh[w], sparx5, QS_INJ_WR(grp));
+
+	/* Write words, round up */
+	count = ((skb->len + 3) / 4);
+	buf = skb->data;
+	for (w = 0; w < count; w++, buf += 4) {
+		val = get_unaligned((const u32 *)buf);
+		SPX5_WR(val, sparx5, QS_INJ_WR(grp));
+	}
+
+	/* Add padding */
+	while (w < (60 / 4)) {
+		SPX5_WR(0, sparx5, QS_INJ_WR(grp));
+		w++;
+	}
+
+	/* Indicate EOF and valid bytes in last word */
+	SPX5_WR(QS_INJ_CTRL_GAP_SIZE_SET(1) |
+		QS_INJ_CTRL_VLD_BYTES_SET(skb->len < 60 ? 0 : skb->len % 4) |
+		QS_INJ_CTRL_EOF_SET(1),
+		sparx5, QS_INJ_CTRL(grp));
+
+	/* Add dummy CRC */
+	SPX5_WR(0, sparx5, QS_INJ_WR(grp));
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
+	SPX5_WR(QS_XTR_GRP_CFG_MODE_SET(1) |
+		QS_XTR_GRP_CFG_STATUS_WORD_POS_SET(1) |
+		QS_XTR_GRP_CFG_BYTE_SWAP_SET(byte_swap),
+		sparx5, QS_XTR_GRP_CFG(XTR_QUEUE));
+	SPX5_WR(QS_INJ_GRP_CFG_MODE_SET(1) |
+		QS_INJ_GRP_CFG_BYTE_SWAP_SET(byte_swap),
+		sparx5, QS_INJ_GRP_CFG(INJ_QUEUE));
+
+	/* CPU ports capture setup */
+	for (portno = SPX5_PORT_CPU_0; portno <= SPX5_PORT_CPU_1; portno++) {
+		/* ASM CPU port: No preamble, IFH, enable padding */
+		SPX5_WR(ASM_PORT_CFG_PAD_ENA_SET(1) |
+			ASM_PORT_CFG_NO_PREAMBLE_ENA_SET(1) |
+			ASM_PORT_CFG_INJ_FORMAT_CFG_SET(1), /* 1 = IFH */
+			sparx5, ASM_PORT_CFG(portno));
+	}
+
+	/* Reset WM cnt to unclog queued frames */
+	for (portno = SPX5_PORT_CPU_0; portno <= SPX5_PORT_CPU_1; portno++)
+		SPX5_RMW(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR_SET(1),
+			 DSM_DEV_TX_STOP_WM_CFG_DEV_TX_CNT_CLR,
+			 sparx5,
+			 DSM_DEV_TX_STOP_WM_CFG(portno));
+}
+
+irqreturn_t sparx5_xtr_handler(int irq, void *_sparx5)
+{
+	struct sparx5 *sparx5 = _sparx5;
+
+	/* Check data in queue */
+	while (SPX5_RD(sparx5, QS_XTR_DATA_PRESENT) & BIT(XTR_QUEUE))
+		sparx5_xtr_grp(sparx5, XTR_QUEUE, false);
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
new file mode 100644
index 000000000000..2b1724e641d8
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -0,0 +1,179 @@
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
+#include "sparx5_main.h"
+#include "sparx5_port.h"
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
+		if (port->conf.max_speed == SPEED_25000 ||
+		    port->conf.max_speed == SPEED_10000) {
+			phylink_set(mask, 5000baseT_Full);
+			phylink_set(mask, 10000baseT_Full);
+			phylink_set(mask, 10000baseCR_Full);
+			phylink_set(mask, 10000baseSR_Full);
+			phylink_set(mask, 10000baseLR_Full);
+			phylink_set(mask, 10000baseLRM_Full);
+			phylink_set(mask, 10000baseER_Full);
+		}
+		if (port->conf.max_speed == SPEED_25000) {
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
+	    a->pause != b->pause ||
+	    a->duplex != b->duplex ||
+	    a->portmode != b->portmode ||
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
+	int err = 0;
+
+	conf = port->conf;
+	conf.autoneg = state->an_enabled;
+	conf.pause = state->pause;
+	conf.duplex = state->duplex;
+	conf.power_down = false;
+	conf.portmode = state->interface;
+
+	if (state->speed == SPEED_UNKNOWN) {
+		/* When a SFP is plugged in we use capabilities to
+		 * default to the highest supported speed
+		 */
+		if ((phylink_test(state->advertising, 25000baseSR_Full) ||
+		     phylink_test(state->advertising, 25000baseCR_Full)) &&
+		     state->interface == PHY_INTERFACE_MODE_10GBASER)
+			conf.speed = SPEED_25000;
+		else if (state->interface == PHY_INTERFACE_MODE_10GBASER)
+			conf.speed = SPEED_10000;
+		else if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+			conf.speed = SPEED_2500;
+		else
+			conf.speed = SPEED_1000;
+	} else {
+		conf.speed = state->speed;
+	}
+
+	if (phylink_test(state->advertising, FIBRE))
+		conf.media_type = ETH_MEDIA_SR;
+	else
+		conf.media_type = ETH_MEDIA_DAC;
+
+	if (port_conf_has_changed(&port->conf, &conf)) {
+		err = sparx5_port_config(port->sparx5, port, &conf);
+		if (err)
+			netdev_err(port->ndev, "port config failed: %d\n", err);
+	}
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
+	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
+	struct sparx5_port_status status;
+
+	sparx5_get_port_status(port->sparx5, port, &status);
+	state->link = status.serdes_link && status.link;
+	state->an_complete = status.an_complete;
+	state->speed = status.speed;
+	state->duplex = status.duplex;
+	state->pause = status.pause;
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
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
new file mode 100644
index 000000000000..52dad16a1811
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -0,0 +1,1125 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/module.h>
+#include <linux/phy/phy.h>
+
+#include "sparx5_main.h"
+#include "sparx5_port.h"
+
+#define SPX5_ETYPE_TAG_C     0x8100
+#define SPX5_ETYPE_TAG_S     0x88a8
+
+#define SPX5_WAIT_US         1000
+#define SPX5_WAIT_MAX_US     2000
+
+enum port_error {
+	SPX5_PERR_SPEED,
+	SPX5_PERR_IFTYPE,
+};
+
+static int sparx5_get_1000basex_status(struct sparx5 *sparx5,
+				       struct sparx5_port *port,
+				       struct sparx5_port_status *status)
+{
+	u32 value;
+	u32 lp_abil;
+	u32 portno = port->portno;
+
+	/* Get PCS Link down sticky */
+	value = SPX5_RD(sparx5, DEV2G5_PCS1G_STICKY(portno));
+	status->link_down = DEV2G5_PCS1G_STICKY_LINK_DOWN_STICKY_GET(value);
+	if (status->link_down)	/* Clear the sticky */
+		SPX5_WR(value, sparx5, DEV2G5_PCS1G_STICKY(portno));
+
+	/* Get current Link status */
+	value = SPX5_RD(sparx5, DEV2G5_PCS1G_LINK_STATUS(portno));
+	status->link = DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(value) |
+		       DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(value);
+
+	status->speed = port->conf.speed;
+	status->duplex = DUPLEX_FULL;
+	/* Get PCS ANEG status register */
+	value = SPX5_RD(sparx5, DEV2G5_PCS1G_ANEG_STATUS(portno));
+	lp_abil = DEV2G5_PCS1G_ANEG_STATUS_LP_ADV_ABILITY_GET(value);
+
+	/* Aneg complete provides more information  */
+	if (DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(value)) {
+		if (port->conf.portmode == PHY_INTERFACE_MODE_SGMII) {
+			/* SGMII cisco aneg */
+			u32 spdvalue = ((lp_abil >> 10) & 3);
+
+			status->link = !!((lp_abil >> 15) == 1) && status->link;
+			status->an_complete = true;
+			status->duplex = (lp_abil >> 12) & 0x1 ?  DUPLEX_FULL : DUPLEX_HALF;
+			if (spdvalue == 0)
+				status->speed = SPEED_10;
+			else if (spdvalue == 1)
+				status->speed = SPEED_100;
+			else
+				status->speed = SPEED_1000;
+		} else {
+			/* Clause 37 Aneg */
+			status->link = !((lp_abil >> 12) & 3) && status->link;
+			status->an_complete = true;
+			status->duplex = ((lp_abil >> 5) & 1) ? DUPLEX_FULL : DUPLEX_UNKNOWN;
+			if ((lp_abil >> 8) & 1) /* symmetric pause */
+				status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
+			if (lp_abil & (1 << 7)) /* asymmetric pause */
+				status->pause |= MLO_PAUSE_RX;
+		}
+	}
+	return 0;
+}
+
+static int sparx5_get_100fx_status(struct sparx5 *sparx5,
+				   struct sparx5_port *port,
+				   struct sparx5_port_status *status)
+{
+	u32 value, portno = port->portno;
+
+	/* Get the PCS status  */
+	value = SPX5_RD(sparx5, DEV2G5_PCS_FX100_STATUS(portno));
+
+	/* Link has been down if the are any error stickies */
+	status->link_down =
+		DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY_GET(value) ||
+		DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY_GET(value) ||
+		DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY_GET(value) ||
+		DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY_GET(value) ||
+		DEV2G5_PCS_FX100_STATUS_FEF_STATUS_GET(value);
+
+	if (status->link_down) {
+		/* Clear the stickies and re-read */
+		SPX5_WR(value, sparx5, DEV2G5_PCS_FX100_STATUS(portno));
+		usleep_range(SPX5_WAIT_US, SPX5_WAIT_MAX_US);
+		value = SPX5_RD(sparx5, DEV2G5_PCS_FX100_STATUS(portno));
+	}
+	/* Link=1 if sync status=1 and no error stickies after a clear */
+	status->link =
+		DEV2G5_PCS_FX100_STATUS_SYNC_STATUS_GET(value) &&
+		!DEV2G5_PCS_FX100_STATUS_SYNC_LOST_STICKY_GET(value) &&
+		!DEV2G5_PCS_FX100_STATUS_FEF_FOUND_STICKY_GET(value) &&
+		!DEV2G5_PCS_FX100_STATUS_PCS_ERROR_STICKY_GET(value) &&
+		!DEV2G5_PCS_FX100_STATUS_SSD_ERROR_STICKY_GET(value) &&
+		!DEV2G5_PCS_FX100_STATUS_FEF_STATUS_GET(value);
+	status->speed = SPEED_100;
+	status->duplex = DUPLEX_FULL;
+	return 0;
+}
+
+static int sparx5_get_sfi_status(struct sparx5 *sparx5,
+				 struct sparx5_port *port,
+				 struct sparx5_port_status *status)
+{
+	bool high_speed_dev = sparx5_is_high_speed_device(&port->conf);
+	u32 portno = port->portno;
+	u32 value, dev, tinst;
+	void __iomem *inst;
+
+	if (!high_speed_dev) {
+		netdev_err(port->ndev, "error: low speed and SFI mode\n");
+		return -EINVAL;
+	}
+
+	dev = sparx5_to_high_dev(portno);
+	tinst = sparx5_port_dev_index(portno);
+	inst = SPX5_INST_GET(sparx5, dev, tinst);
+
+	value = SPX5_INST_RD(inst, DEV10G_MAC_TX_MONITOR_STICKY(0));
+	if (value != DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY) {
+		/* The link is or has been down. Clear the sticky bit */
+		status->link_down = 1;
+		SPX5_INST_WR(0xffffffff, inst, DEV10G_MAC_TX_MONITOR_STICKY(0));
+		value = SPX5_INST_RD(inst, DEV10G_MAC_TX_MONITOR_STICKY(0));
+	}
+	status->link = (value == DEV10G_MAC_TX_MONITOR_STICKY_IDLE_STATE_STICKY);
+	status->speed = port->conf.speed;
+	status->duplex = DUPLEX_FULL;
+	return 0;
+}
+
+/* Get link status of 100FX, 1000Base-X/in-band and SFI ports.
+ * Status for SGMII is retrieved from the Phy
+ */
+int sparx5_get_port_status(struct sparx5 *sparx5,
+			   struct sparx5_port *port,
+			   struct sparx5_port_status *status)
+{
+	memset(status, 0, sizeof(*status));
+	status->speed = port->conf.speed;
+	status->serdes_link = !phy_validate(port->serdes, PHY_MODE_ETHERNET,
+					    port->conf.portmode, NULL);
+	if (port->conf.power_down) {
+		status->link = false;
+		return 0;
+	}
+	switch (port->conf.portmode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+		if (port->conf.phy_mode == PHY_INTERFACE_MODE_NA)
+			return sparx5_get_1000basex_status(sparx5, port,
+								status);
+		if (port->ndev && port->ndev->phydev)
+			status->link = port->ndev->phydev->link;
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if (port->conf.speed == SPEED_100)
+			return sparx5_get_100fx_status(sparx5, port, status);
+
+		return sparx5_get_1000basex_status(sparx5, port, status);
+	case PHY_INTERFACE_MODE_10GBASER:
+		return sparx5_get_sfi_status(sparx5, port, status);
+	case PHY_INTERFACE_MODE_NA:
+		return 0;
+	default:
+		netdev_err(port->ndev, "Status not supported");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int sparx5_port_error(struct sparx5_port *port,
+			     struct sparx5_port_config *conf,
+			     enum port_error errtype)
+{
+	switch (errtype) {
+	case SPX5_PERR_SPEED:
+		netdev_err(port->ndev,
+			   "Interface does not support speed: %u: for %s\n",
+			   conf->speed, phy_modes(conf->portmode));
+		break;
+	case SPX5_PERR_IFTYPE:
+		netdev_err(port->ndev,
+			   "Switch port does not support interface type: %s\n",
+			   phy_modes(conf->portmode));
+		break;
+	default:
+		netdev_err(port->ndev,
+			   "Interface configuration error\n");
+	}
+
+	return -EINVAL;
+}
+
+static int sparx5_port_verify_speed(struct sparx5 *sparx5,
+				    struct sparx5_port *port,
+				    struct sparx5_port_config *conf)
+{
+	if ((sparx5_port_is_2g5(port->portno) &&
+	     conf->speed > SPEED_2500) ||
+	    (sparx5_port_is_5g(port->portno)  &&
+	     conf->speed > SPEED_5000) ||
+	    (sparx5_port_is_10g(port->portno) &&
+	     conf->speed > SPEED_10000))
+		return sparx5_port_error(port, conf, SPX5_PERR_SPEED);
+
+	switch (conf->portmode) {
+	case PHY_INTERFACE_MODE_NA:
+		return -EINVAL;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if ((conf->speed != SPEED_100 && /* This is for 100BASE-FX */
+		     conf->speed != SPEED_1000 &&
+		     conf->speed != SPEED_2500) ||
+		    sparx5_port_is_2g5(port->portno))
+			return sparx5_port_error(port, conf, SPX5_PERR_SPEED);
+		if (sparx5_port_is_2g5(port->portno))
+			return sparx5_port_error(port, conf, SPX5_PERR_IFTYPE);
+		break;
+	case PHY_INTERFACE_MODE_QSGMII:
+		if (port->portno > 47)
+			return sparx5_port_error(port, conf, SPX5_PERR_IFTYPE);
+		fallthrough;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (conf->speed != SPEED_1000 &&
+		    conf->speed != SPEED_100 &&
+		    conf->speed != SPEED_10 &&
+		    conf->speed != SPEED_2500)
+			return sparx5_port_error(port, conf, SPX5_PERR_SPEED);
+		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+		if ((conf->speed != SPEED_5000 &&
+		     conf->speed != SPEED_10000 &&
+		     conf->speed != SPEED_25000))
+			return sparx5_port_error(port, conf, SPX5_PERR_SPEED);
+		break;
+	default:
+		return sparx5_port_error(port, conf, SPX5_PERR_IFTYPE);
+	}
+	return 0;
+}
+
+static bool sparx5_port_change_device(struct sparx5 *sparx5,
+				      struct sparx5_port *port,
+				      struct sparx5_port_config *conf)
+{
+	if (sparx5_port_is_2g5(port->portno))
+		return false;
+
+	if (port->conf.speed == SPEED_UNKNOWN ||
+	    (port->conf.speed <= 2500 && conf->speed > 2500) ||
+	    (port->conf.speed > 2500 && conf->speed <= 2500)) {
+		return true;
+	}
+
+	return false;
+}
+
+static int sparx5_port_flush_poll(struct sparx5 *sparx5, u32 portno)
+{
+	u32  value, resource, prio, delay_cnt = 0;
+	char *mem = "";
+	bool poll_src = true;
+
+	/* Resource == 0: Memory tracked per source (SRC-MEM)
+	 * Resource == 1: Frame references tracked per source (SRC-REF)
+	 * Resource == 2: Memory tracked per destination (DST-MEM)
+	 * Resource == 3: Frame references tracked per destination. (DST-REF)
+	 */
+	while (1) {
+		bool empty = true;
+
+		for (resource = 0; resource < (poll_src ? 2 : 1); resource++) {
+			u32 base;
+
+			base = (resource == 0 ? 2048 : 0) + SPX5_PRIOS * portno;
+			for (prio = 0; prio < SPX5_PRIOS; prio++) {
+				value = SPX5_RD(sparx5,
+						QRES_RES_STAT(base + prio));
+				if (value) {
+					mem = resource == 0 ?
+						"DST-MEM" : "SRC-MEM";
+					empty = false;
+				}
+			}
+		}
+
+		if (empty)
+			break;
+
+		if (delay_cnt++ == 2000) {
+			dev_err(sparx5->dev,
+				"Flush timeout port %u. %s queue not empty\n",
+				portno, mem);
+			return -EINVAL;
+		}
+
+		usleep_range(SPX5_WAIT_US, SPX5_WAIT_MAX_US);
+	}
+	return 0;
+}
+
+static int sparx5_port_flush(struct sparx5 *sparx5, struct sparx5_port *port, bool high_spd_dev)
+{
+	u32 dev               = high_spd_dev ? sparx5_to_high_dev(port->portno) : TARGET_DEV2G5;
+	u32 tinst             = high_spd_dev ? sparx5_port_dev_index(port->portno) : port->portno;
+	void __iomem *devinst = SPX5_INST_GET(sparx5, dev, tinst);
+	u32 spd               = port->conf.speed;
+	u32 spd_prm;
+	int err;
+
+	if (high_spd_dev) {
+		/* 1: Reset the PCS Rx clock domain  */
+		SPX5_INST_RMW(DEV10G_DEV_RST_CTRL_PCS_RX_RST,
+			      DEV10G_DEV_RST_CTRL_PCS_RX_RST,
+			      devinst,
+			      DEV10G_DEV_RST_CTRL(0));
+
+		/* 2: Disable MAC frame reception */
+		SPX5_INST_RMW(0,
+			      DEV10G_MAC_ENA_CFG_RX_ENA,
+			      devinst,
+			      DEV10G_MAC_ENA_CFG(0));
+	} else {
+		/* 1: Reset the PCS Rx clock domain  */
+		SPX5_INST_RMW(DEV2G5_DEV_RST_CTRL_PCS_RX_RST,
+			      DEV2G5_DEV_RST_CTRL_PCS_RX_RST,
+			      devinst,
+			      DEV2G5_DEV_RST_CTRL(0));
+		/* 2: Disable MAC frame reception */
+		SPX5_INST_RMW(0,
+			      DEV2G5_MAC_ENA_CFG_RX_ENA,
+			      devinst,
+			      DEV2G5_MAC_ENA_CFG(0));
+	}
+	/* 3: Disable traffic being sent to or from switch port->portno */
+	SPX5_RMW(0,
+		 QFWD_SWITCH_PORT_MODE_PORT_ENA,
+		 sparx5,
+		 QFWD_SWITCH_PORT_MODE(port->portno));
+
+	/* 4: Disable dequeuing from the egress queues  */
+	SPX5_RMW(HSCH_PORT_MODE_DEQUEUE_DIS,
+		 HSCH_PORT_MODE_DEQUEUE_DIS,
+		 sparx5,
+		 HSCH_PORT_MODE(port->portno));
+	/* 5: Disable Flowcontrol */
+	SPX5_RMW(0,
+		 QSYS_PAUSE_CFG_PAUSE_ENA,
+		 sparx5,
+		 QSYS_PAUSE_CFG(port->portno));
+
+	spd_prm = spd == SPEED_10 ? 1000 : spd == SPEED_100 ? 100 : 10;
+	/* 6: Wait while the last frame is exiting the queues */
+	usleep_range(8 * spd_prm, 10 * spd_prm);
+
+	/* 7: Flush the queues accociated with the port->portno */
+	SPX5_RMW(HSCH_FLUSH_CTRL_FLUSH_PORT_SET(port->portno) |
+		 HSCH_FLUSH_CTRL_FLUSH_DST_SET(1) |
+		 HSCH_FLUSH_CTRL_FLUSH_SRC_SET(1) |
+		 HSCH_FLUSH_CTRL_FLUSH_ENA_SET(1),
+		 HSCH_FLUSH_CTRL_FLUSH_PORT |
+		 HSCH_FLUSH_CTRL_FLUSH_DST |
+		 HSCH_FLUSH_CTRL_FLUSH_SRC |
+		 HSCH_FLUSH_CTRL_FLUSH_ENA,
+		 sparx5,
+		 HSCH_FLUSH_CTRL);
+
+	/* 8: Enable dequeuing from the egress queues */
+	SPX5_RMW(0,
+		 HSCH_PORT_MODE_DEQUEUE_DIS,
+		 sparx5,
+		 HSCH_PORT_MODE(port->portno));
+
+	/* 9: Wait until flushing is complete */
+	err = sparx5_port_flush_poll(sparx5, port->portno);
+	if (err)
+		return err;
+
+	/* 10: Reset the  MAC clock domain */
+	if (high_spd_dev) {
+		SPX5_INST_RMW(DEV10G_DEV_RST_CTRL_PCS_TX_RST_SET(1) |
+			      DEV10G_DEV_RST_CTRL_MAC_RX_RST_SET(1) |
+			      DEV10G_DEV_RST_CTRL_MAC_TX_RST_SET(1),
+			      DEV10G_DEV_RST_CTRL_PCS_TX_RST |
+			      DEV10G_DEV_RST_CTRL_MAC_RX_RST |
+			      DEV10G_DEV_RST_CTRL_MAC_TX_RST,
+			      devinst,
+			      DEV10G_DEV_RST_CTRL(0));
+
+	} else {
+		SPX5_INST_RMW(DEV2G5_DEV_RST_CTRL_SPEED_SEL_SET(3)    |
+			      DEV2G5_DEV_RST_CTRL_PCS_TX_RST_SET(1) |
+			      DEV2G5_DEV_RST_CTRL_PCS_RX_RST_SET(1) |
+			      DEV2G5_DEV_RST_CTRL_MAC_TX_RST_SET(1) |
+			      DEV2G5_DEV_RST_CTRL_MAC_RX_RST_SET(1),
+			      DEV2G5_DEV_RST_CTRL_SPEED_SEL |
+			      DEV2G5_DEV_RST_CTRL_PCS_TX_RST |
+			      DEV2G5_DEV_RST_CTRL_PCS_RX_RST |
+			      DEV2G5_DEV_RST_CTRL_MAC_TX_RST |
+			      DEV2G5_DEV_RST_CTRL_MAC_RX_RST,
+			      devinst,
+			      DEV2G5_DEV_RST_CTRL(0));
+	}
+	/* 11: Clear flushing */
+	SPX5_RMW(HSCH_FLUSH_CTRL_FLUSH_PORT_SET(port->portno) |
+		 HSCH_FLUSH_CTRL_FLUSH_ENA_SET(0),
+		 HSCH_FLUSH_CTRL_FLUSH_PORT |
+		 HSCH_FLUSH_CTRL_FLUSH_ENA,
+		 sparx5,
+		 HSCH_FLUSH_CTRL);
+
+	if (high_spd_dev) {
+		u32 pcs = sparx5_to_pcs_dev(port->portno);
+		void __iomem *pcsinst = SPX5_INST_GET(sparx5, pcs, tinst);
+
+		/* 12: Disable 5G/10G/25 BaseR PCS */
+		SPX5_INST_RMW(PCS10G_BR_PCS_CFG_PCS_ENA_SET(0),
+			      PCS10G_BR_PCS_CFG_PCS_ENA,
+			      pcsinst,
+			      PCS10G_BR_PCS_CFG(0));
+
+		if (sparx5_port_is_25g(port->portno))
+			/* Disable 25G PCS */
+			SPX5_RMW(DEV25G_PCS25G_CFG_PCS25G_ENA_SET(0),
+				 DEV25G_PCS25G_CFG_PCS25G_ENA,
+				 sparx5,
+				 DEV25G_PCS25G_CFG(tinst));
+	} else {
+		/* 12: Disable 1G/100fx PCS */
+		SPX5_RMW(DEV2G5_PCS1G_CFG_PCS_ENA_SET(0),
+			 DEV2G5_PCS1G_CFG_PCS_ENA,
+			 sparx5,
+			 DEV2G5_PCS1G_CFG(port->portno));
+		SPX5_RMW(DEV2G5_PCS_FX100_CFG_PCS_ENA_SET(0),
+			 DEV2G5_PCS_FX100_CFG_PCS_ENA,
+			 sparx5,
+			 DEV2G5_PCS_FX100_CFG(port->portno));
+	}
+
+	/* The port is now flushed and disabled  */
+	return 0;
+}
+
+static int sparx5_port_get_fifo_size(struct sparx5 *sparx5,
+				     u32 portno, u32 speed)
+{
+	u32 sys_clk    = sparx5_clk_period(sparx5->coreclock);
+	u32 mac_width  = 8;
+	u32 fifo_width = 16;
+	u32 addition   = 0;
+	u32 mac_per    = 6400, tmp1, tmp2, tmp3;
+	u32 taxi_dist[SPX5_PORTS_ALL] = {
+		6, 8, 10, 6, 8, 10, 6, 8, 10, 6, 8, 10,
+		4, 4, 4, 4,
+		11, 12, 13, 14, 15, 16, 17, 18,
+		11, 12, 13, 14, 15, 16, 17, 18,
+		11, 12, 13, 14, 15, 16, 17, 18,
+		11, 12, 13, 14, 15, 16, 17, 18,
+		4, 6, 8, 4, 6, 8, 6, 8,
+		2, 2, 2, 2, 2, 2, 2, 4, 2
+	};
+
+	switch (speed) {
+	case SPEED_25000:
+		return 0;
+	case SPEED_10000:
+		mac_per = 6400;
+		mac_width = 8;
+		addition = 1;
+		break;
+	case SPEED_5000:
+		mac_per = 12800;
+		mac_width = 8;
+		addition = 0;
+		break;
+	case SPEED_2500:
+		mac_per = 3200;
+		mac_width = 1;
+		addition = 0;
+		break;
+	case SPEED_1000:
+		mac_per =  8000;
+		mac_width = 1;
+		addition = 0;
+		break;
+	case SPEED_100:
+	case SPEED_10:
+		return 1;
+	default:
+		break;
+	}
+
+	tmp1 = 1000 * mac_width / fifo_width;
+	tmp2 = 3000 + ((12000 + 2 * taxi_dist[portno] * 1000)
+		       * sys_clk / mac_per);
+	tmp3 = tmp1 * tmp2 / 1000;
+	return  (tmp3 + 2000 + 999) / 1000 + addition;
+}
+
+/* Configure port muxing:
+ * QSGMII:     4x2G5 devices
+ */
+static int sparx5_port_mux_set(struct sparx5 *sparx5,
+			       struct sparx5_port *port,
+			       struct sparx5_port_config *conf)
+{
+	u32 inst;
+	u32 portno = port->portno;
+
+	if (port->conf.portmode == conf->portmode)
+		return 0; /* Nothing to do */
+
+	switch (conf->portmode) {
+	case PHY_INTERFACE_MODE_QSGMII: /* QSGMII: 4x2G5 devices. Mode Q'  */
+		inst = (portno - portno % 4) / 4;
+		SPX5_RMW(BIT(inst),
+			 BIT(inst),
+			 sparx5,
+			 PORT_CONF_QSGMII_ENA);
+
+		if ((portno / 4 % 2) == 0) {
+			/* Affects d0-d3,d8-d11..d40-d43 */
+			SPX5_RMW(PORT_CONF_USGMII_CFG_BYPASS_SCRAM_SET(1) |
+				 PORT_CONF_USGMII_CFG_BYPASS_DESCRAM_SET(1) |
+				 PORT_CONF_USGMII_CFG_QUAD_MODE_SET(1),
+				 PORT_CONF_USGMII_CFG_BYPASS_SCRAM |
+				 PORT_CONF_USGMII_CFG_BYPASS_DESCRAM |
+				 PORT_CONF_USGMII_CFG_QUAD_MODE,
+				 sparx5,
+				 PORT_CONF_USGMII_CFG((portno / 8)));
+		}
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int sparx5_port_max_tags_set(struct sparx5 *sparx5,
+				    struct sparx5_port *port)
+{
+	u32 etype;
+	enum sparx5_port_max_tags max_tags    = port->max_vlan_tags;
+	enum sparx5_vlan_port_type vlan_type  = port->vlan_type;
+	bool dotag          = max_tags != SPX5_PORT_MAX_TAGS_NONE;
+	int tag_ct          = max_tags == SPX5_PORT_MAX_TAGS_ONE ? 1 :
+			      max_tags == SPX5_PORT_MAX_TAGS_TWO ? 2 : 0;
+	bool dtag           = max_tags == SPX5_PORT_MAX_TAGS_TWO;
+	u32 dev             = sparx5_to_high_dev(port->portno);
+	u32 tinst           = sparx5_port_dev_index(port->portno);
+	void __iomem *inst  = SPX5_INST_GET(sparx5, dev, tinst);
+
+	etype = (vlan_type == SPX5_VLAN_PORT_TYPE_S_CUSTOM ?
+		 port->custom_etype :
+		 vlan_type == SPX5_VLAN_PORT_TYPE_C ?
+		 SPX5_ETYPE_TAG_C : SPX5_ETYPE_TAG_S);
+
+	SPX5_WR(DEV2G5_MAC_TAGS_CFG_TAG_ID_SET(etype) |
+		DEV2G5_MAC_TAGS_CFG_PB_ENA_SET(dtag) |
+		DEV2G5_MAC_TAGS_CFG_VLAN_AWR_ENA_SET(dotag) |
+		DEV2G5_MAC_TAGS_CFG_VLAN_LEN_AWR_ENA_SET(dotag),
+		sparx5,
+		DEV2G5_MAC_TAGS_CFG(port->portno));
+
+	if (sparx5_port_is_2g5(port->portno))
+		return 0;
+
+	SPX5_INST_RMW(DEV10G_MAC_TAGS_CFG_TAG_ID_SET(etype) |
+		      DEV10G_MAC_TAGS_CFG_TAG_ENA_SET(dotag),
+		      DEV10G_MAC_TAGS_CFG_TAG_ID |
+		      DEV10G_MAC_TAGS_CFG_TAG_ENA,
+		      inst,
+		      DEV10G_MAC_TAGS_CFG(0, 0));
+
+	SPX5_INST_RMW(DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS_SET(tag_ct),
+		      DEV10G_MAC_NUM_TAGS_CFG_NUM_TAGS,
+		      inst,
+		      DEV10G_MAC_NUM_TAGS_CFG(0));
+
+	SPX5_INST_RMW(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK_SET(dotag),
+		      DEV10G_MAC_MAXLEN_CFG_MAX_LEN_TAG_CHK,
+		      inst,
+		      DEV10G_MAC_MAXLEN_CFG(0));
+	return 0;
+}
+
+static int sparx5_port_fwd_urg(struct sparx5 *sparx5, u32 speed)
+{
+	u32 clk_period_ps = 1600; /* 625Mhz for now */
+	u32 urg = 672000;
+
+	switch (speed) {
+	case SPEED_10:
+	case SPEED_100:
+	case SPEED_1000:
+		urg = 672000;
+		break;
+	case SPEED_2500:
+		urg = 270000;
+		break;
+	case SPEED_5000:
+		urg = 135000;
+		break;
+	case SPEED_10000:
+		urg = 67200;
+		break;
+	case SPEED_25000:
+		urg = 27000;
+		break;
+	}
+	return urg / clk_period_ps - 1;
+}
+
+static u16 wm_enc(u16 value)
+{
+	if (value >= 2048)
+		return 2048 + value / 16;
+
+	return value;
+}
+
+static int sparx5_port_fc_setup(struct sparx5 *sparx5,
+				struct sparx5_port *port,
+				struct sparx5_port_config *conf)
+{
+	bool fc_obey = conf->pause & MLO_PAUSE_RX ? 1 : 0;
+	u32 pause_stop = 0xFFF - 1; /* FC generate disabled */
+
+	if (conf->pause & MLO_PAUSE_TX) {
+		int maxlen = ETH_DATA_LEN + ETH_HLEN + ETH_FCS_LEN;
+
+		pause_stop = wm_enc(4  * (maxlen / SPX5_BUFFER_CELL_SZ));
+	}
+
+	/* Set HDX flowcontrol */
+	SPX5_RMW(DSM_MAC_CFG_HDX_BACKPREASSURE_SET(conf->duplex == DUPLEX_HALF),
+		 DSM_MAC_CFG_HDX_BACKPREASSURE,
+		 sparx5,
+		 DSM_MAC_CFG(port->portno));
+
+	/* Obey flowcontrol  */
+	SPX5_RMW(DSM_RX_PAUSE_CFG_RX_PAUSE_EN_SET(fc_obey),
+		 DSM_RX_PAUSE_CFG_RX_PAUSE_EN,
+		 sparx5,
+		 DSM_RX_PAUSE_CFG(port->portno));
+
+	/* Disable forward pressure */
+	SPX5_RMW(QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS_SET(fc_obey),
+		 QSYS_FWD_PRESSURE_FWD_PRESSURE_DIS,
+		 sparx5,
+		 QSYS_FWD_PRESSURE(port->portno));
+
+	/* Generate pause frames */
+	SPX5_RMW(QSYS_PAUSE_CFG_PAUSE_STOP_SET(pause_stop),
+		 QSYS_PAUSE_CFG_PAUSE_STOP,
+		 sparx5,
+		 QSYS_PAUSE_CFG(port->portno));
+
+	return 0;
+}
+
+static u16 get_aneg_word(struct sparx5_port_config *conf)
+{
+	if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX) /* cl-37 aneg */
+		return ((1 << 14) | /* ack */
+		((conf->pause ? 1 : 0) << 8) | /* asymmetric pause */
+		((conf->pause ? 1 : 0) << 7) | /* symmetric pause */
+		(1 << 5)); /* FDX only */
+
+	return 1; /* Enable SGMII Aneg */
+}
+
+int sparx5_serdes_set(struct sparx5 *sparx5,
+		      struct sparx5_port *port,
+		      struct sparx5_port_config *conf)
+{
+	union phy_configure_opts opts = {
+		.eth_serdes.speed = conf->speed,
+		.eth_serdes.media_type = conf->media_type,
+	};
+	int err;
+
+	if (conf->portmode == PHY_INTERFACE_MODE_QSGMII &&
+	    ((port->portno % 4) != 0)) {
+		return 0;
+	}
+	err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET, conf->portmode);
+	if (err)
+		return err;
+
+	if (conf->serdes_reset) {
+		err = phy_reset(port->serdes);
+		if (err)
+			return err;
+	}
+	/* Configure SerDes with port parameters */
+	err = phy_configure(port->serdes, &opts);
+	if (err)
+		return err;
+	conf->serdes_reset = false;
+	return err;
+}
+
+static int sparx5_port_config_low_set(struct sparx5 *sparx5,
+				      struct sparx5_port *port,
+				      struct sparx5_port_config *conf)
+{
+	int err;
+	bool sgmii    = false, pcs_100fx = false, in_band_aneg = false;
+	bool fdx      = conf->duplex == DUPLEX_FULL;
+	int spd       = conf->speed;
+	u32 clk_spd   = spd == SPEED_10 ? 0 : spd == SPEED_100 ? 1 : 2;
+	u32 gig_mode  = spd == SPEED_1000 || spd == SPEED_2500;
+	u32 tx_gap    = spd == SPEED_1000 ? 4 : fdx ? 6 : 5;
+	u32 hdx_gap_1 = spd == SPEED_1000 ? 0 : spd == SPEED_100 ? 1 : 2;
+	u32 hdx_gap_2 = spd == SPEED_1000 ? 0 : spd == SPEED_100 ? 4 : 1;
+
+	if (conf->phy_mode  == PHY_INTERFACE_MODE_SGMII ||
+	    conf->phy_mode == PHY_INTERFACE_MODE_QSGMII) {
+		sgmii = true; /* Phy is connnceted to the MAC */
+	} else {
+		if (conf->portmode == PHY_INTERFACE_MODE_SGMII ||
+		    conf->portmode == PHY_INTERFACE_MODE_QSGMII)
+			in_band_aneg = true; /* Cisco-SGMII in-band-aneg */
+		else if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX &&
+			 spd == SPEED_100) /* 100FX forced */
+			pcs_100fx = true;
+		else if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX &&
+			 conf->autoneg)
+			in_band_aneg = true; /* Clause-37 in-band-aneg */
+	}
+
+	/* Configure the serdes with the new parameters */
+	err = sparx5_serdes_set(sparx5, port, conf);
+	if (err)
+		return -EINVAL;
+
+	/* Disabling frame aging when in HDX (due to HDX issue) */
+	SPX5_RMW(HSCH_PORT_MODE_AGE_DIS_SET(fdx == 0),
+		 HSCH_PORT_MODE_AGE_DIS,
+		 sparx5,
+		 HSCH_PORT_MODE(port->portno));
+
+	/* GIG/FDX mode */
+	SPX5_RMW(DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA_SET(gig_mode) |
+		 DEV2G5_MAC_MODE_CFG_FDX_ENA_SET(fdx),
+		 DEV2G5_MAC_MODE_CFG_GIGA_MODE_ENA |
+		 DEV2G5_MAC_MODE_CFG_FDX_ENA,
+		 sparx5,
+		 DEV2G5_MAC_MODE_CFG(port->portno));
+
+	/* Set MAC IFG Gaps */
+	SPX5_WR(DEV2G5_MAC_IFG_CFG_TX_IFG_SET(tx_gap) |
+		DEV2G5_MAC_IFG_CFG_RX_IFG1_SET(hdx_gap_1) |
+		DEV2G5_MAC_IFG_CFG_RX_IFG2_SET(hdx_gap_2),
+		sparx5,
+		DEV2G5_MAC_IFG_CFG(port->portno));
+
+	/* PCS settings for 100fx/SGMII/SERDES */
+	if (pcs_100fx) {
+		/* Enable 100FX PCS*/
+		SPX5_RMW(DEV2G5_PCS_FX100_CFG_PCS_ENA_SET(1),
+			 DEV2G5_PCS_FX100_CFG_PCS_ENA,
+			 sparx5,
+			 DEV2G5_PCS_FX100_CFG(port->portno));
+	} else {
+		/* Choose SGMII or 1000BaseX PCS mode */
+		SPX5_RMW(DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(sgmii),
+			 DEV2G5_PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			 sparx5,
+			 DEV2G5_PCS1G_MODE_CFG(port->portno));
+
+		/* Enable PCS */
+		SPX5_WR(DEV2G5_PCS1G_CFG_PCS_ENA_SET(1),
+			sparx5,
+			DEV2G5_PCS1G_CFG(port->portno));
+
+		if (in_band_aneg) {
+			u16 abil = get_aneg_word(conf);
+
+			/* Enable in-band aneg */
+			SPX5_WR(DEV2G5_PCS1G_ANEG_CFG_ADV_ABILITY_SET(abil) |
+				DEV2G5_PCS1G_ANEG_CFG_SW_RESOLVE_ENA_SET(1) |
+				DEV2G5_PCS1G_ANEG_CFG_ANEG_ENA_SET(1) |
+				DEV2G5_PCS1G_ANEG_CFG_ANEG_RESTART_ONE_SHOT_SET
+				(1),
+				sparx5,
+				DEV2G5_PCS1G_ANEG_CFG(port->portno));
+
+			/* Clear the PCS sticky bits */
+			SPX5_WR(0xFF, sparx5,
+				DEV2G5_PCS1G_STICKY(port->portno));
+		} else {
+			SPX5_WR(0, sparx5, DEV2G5_PCS1G_ANEG_CFG(port->portno));
+		}
+	}
+
+	/* Enable MAC module */
+	SPX5_WR(DEV2G5_MAC_ENA_CFG_RX_ENA |
+		DEV2G5_MAC_ENA_CFG_TX_ENA,
+		sparx5,
+		DEV2G5_MAC_ENA_CFG(port->portno));
+
+	/* Take MAC and PCS clock out of reset */
+	SPX5_RMW(DEV2G5_DEV_RST_CTRL_SPEED_SEL_SET(clk_spd) |
+		 DEV2G5_DEV_RST_CTRL_PCS_TX_RST_SET(0) |
+		 DEV2G5_DEV_RST_CTRL_PCS_RX_RST_SET(0) |
+		 DEV2G5_DEV_RST_CTRL_MAC_TX_RST_SET(0) |
+		 DEV2G5_DEV_RST_CTRL_MAC_RX_RST_SET(0),
+		 DEV2G5_DEV_RST_CTRL_SPEED_SEL |
+		 DEV2G5_DEV_RST_CTRL_PCS_TX_RST |
+		 DEV2G5_DEV_RST_CTRL_PCS_RX_RST |
+		 DEV2G5_DEV_RST_CTRL_MAC_TX_RST |
+		 DEV2G5_DEV_RST_CTRL_MAC_RX_RST,
+		 sparx5,
+		 DEV2G5_DEV_RST_CTRL(port->portno));
+
+	return 0;
+}
+
+static int sparx5_port_config_high_set(struct sparx5 *sparx5,
+				       struct sparx5_port *port,
+				       struct sparx5_port_config *conf)
+{
+	int err;
+	u32 dev               = sparx5_to_high_dev(port->portno);
+	u32 pix               = sparx5_port_dev_index(port->portno);
+	void __iomem *devinst = SPX5_INST_GET(sparx5, dev, pix);
+	u32 pcs               = sparx5_to_pcs_dev(port->portno);
+	void __iomem *pcsinst = SPX5_INST_GET(sparx5, pcs, pix);
+	u32 clk_spd           = conf->speed == SPEED_5000 ? 1 : 0;
+
+	/*  SFI : No in-band-aneg. Speeds 5G/10G/25G */
+
+	err = sparx5_serdes_set(sparx5, port, conf);
+	if (err)
+		return -EINVAL;
+
+	if (conf->speed == SPEED_25000) {
+		/* Enable PCS for 25G device, speed 25G */
+		SPX5_RMW(DEV25G_PCS25G_CFG_PCS25G_ENA_SET(1),
+			 DEV25G_PCS25G_CFG_PCS25G_ENA,
+			 sparx5,
+			 DEV25G_PCS25G_CFG(pix));
+	} else {
+		/* Enable PCS for 5G/10G/25G devices, speed 5G/10G */
+		SPX5_INST_RMW(PCS10G_BR_PCS_CFG_PCS_ENA_SET(1),
+			      PCS10G_BR_PCS_CFG_PCS_ENA,
+			      pcsinst,
+			      PCS10G_BR_PCS_CFG(0));
+	}
+
+	/* Enable 5G/10G/25G MAC module */
+	SPX5_INST_WR(DEV10G_MAC_ENA_CFG_RX_ENA_SET(1) |
+		     DEV10G_MAC_ENA_CFG_TX_ENA_SET(1),
+		     devinst,
+		     DEV10G_MAC_ENA_CFG(0));
+
+	/* Take the device out of reset */
+	SPX5_INST_RMW(DEV10G_DEV_RST_CTRL_PCS_RX_RST_SET(0) |
+		      DEV10G_DEV_RST_CTRL_PCS_TX_RST_SET(0) |
+		      DEV10G_DEV_RST_CTRL_MAC_RX_RST_SET(0) |
+		      DEV10G_DEV_RST_CTRL_MAC_TX_RST_SET(0) |
+		      DEV10G_DEV_RST_CTRL_SPEED_SEL_SET(clk_spd),
+		      DEV10G_DEV_RST_CTRL_PCS_RX_RST |
+		      DEV10G_DEV_RST_CTRL_PCS_TX_RST |
+		      DEV10G_DEV_RST_CTRL_MAC_RX_RST |
+		      DEV10G_DEV_RST_CTRL_MAC_TX_RST |
+		      DEV10G_DEV_RST_CTRL_SPEED_SEL,
+		      devinst,
+		      DEV10G_DEV_RST_CTRL(0));
+
+	return 0;
+}
+
+int sparx5_port_config(struct sparx5 *sparx5,
+		       struct sparx5_port *port,
+		       struct sparx5_port_config *conf)
+{
+	int err;
+	u32 bt_indx;
+	bool use_primary_dev = sparx5_is_high_speed_device(conf);
+	u32 spd              = conf->speed;
+	u32 urgency          = sparx5_port_fwd_urg(sparx5, spd);
+	u32 stop_wm          = sparx5_port_get_fifo_size(sparx5, port->portno, spd);
+
+	/* PHY_INTERFACE_MODE_10GBASER  : 25G/10G/5G
+	 * PHY_INTERFACE_MODE_1000BASEX : 1G/2G5
+	 * PHY_INTERFACE_MODE_SGMII     : 1G/100M/10M
+	 */
+	if (conf->portmode == PHY_INTERFACE_MODE_10GBASER  ||
+	    conf->portmode == PHY_INTERFACE_MODE_NA) {
+		if (spd <= SPEED_2500)
+			conf->portmode = PHY_INTERFACE_MODE_1000BASEX;
+		else
+			conf->portmode = PHY_INTERFACE_MODE_10GBASER;
+	}
+
+	err = sparx5_port_verify_speed(sparx5, port, conf);
+	if (err)
+		return err;
+
+	/* All high speed (>2G5) devices have an additional 2G5 (shadow) device.
+	 * Only one of them can be active and attached to the switch core at a time.
+	 * Which device to use depends on the given port speed.
+	 */
+	if (sparx5_port_change_device(sparx5, port, conf)) {
+		/* Shutdown the not-in-use device */
+		err = sparx5_port_flush(sparx5, port, !use_primary_dev);
+		if (err)
+			return err;
+
+		/* Enable/disable primary (5G/10G/25G) device */
+		bt_indx = BIT(sparx5_port_dev_index(port->portno));
+		if (sparx5_port_is_5g(port->portno)) {
+			SPX5_RMW(use_primary_dev ? 0 : bt_indx,
+				 bt_indx,
+				 sparx5,
+				 PORT_CONF_DEV5G_MODES);
+		} else if (sparx5_port_is_10g(port->portno)) {
+			SPX5_RMW(use_primary_dev ? 0 : bt_indx,
+				 bt_indx,
+				 sparx5,
+				 PORT_CONF_DEV10G_MODES);
+		} else if (sparx5_port_is_25g(port->portno)) {
+			SPX5_RMW(use_primary_dev ? 0 : bt_indx,
+				 bt_indx,
+				 sparx5,
+				 PORT_CONF_DEV25G_MODES);
+		}
+	}
+
+	if (!conf->power_down) {
+		/* Disable the port before re-configuring */
+		err = sparx5_port_flush(sparx5, port, use_primary_dev);
+		if (err)
+			return err;
+
+		/* Enable/disable 1G counters in ASM */
+		SPX5_RMW(ASM_PORT_CFG_CSC_STAT_DIS_SET(use_primary_dev),
+			 ASM_PORT_CFG_CSC_STAT_DIS,
+			 sparx5,
+			 ASM_PORT_CFG(port->portno));
+
+		/* Enable/disable 1G counters in DSM */
+		SPX5_RMW(DSM_BUF_CFG_CSC_STAT_DIS_SET(use_primary_dev),
+			 DSM_BUF_CFG_CSC_STAT_DIS,
+			 sparx5,
+			 DSM_BUF_CFG(port->portno));
+
+		/* Setup PCS and MAC */
+		err = use_primary_dev ?
+			sparx5_port_config_high_set(sparx5, port, conf) :
+			sparx5_port_config_low_set(sparx5, port, conf);
+		if (err)
+			return err;
+
+		/* Set the DSM stop watermark */
+		SPX5_RMW(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_SET(stop_wm) |
+			 DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA_SET(use_primary_dev == 0),
+			 DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM |
+			 DSM_DEV_TX_STOP_WM_CFG_DEV10G_SHADOW_ENA,
+			 sparx5,
+			 DSM_DEV_TX_STOP_WM_CFG(port->portno));
+
+		/* Configure flow control */
+		err = sparx5_port_fc_setup(sparx5, port, conf);
+		if (err)
+			return err;
+
+		/* Set the switching speed and enable port forwarding */
+		SPX5_RMW(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(1) |
+			 QFWD_SWITCH_PORT_MODE_FWD_URGENCY_SET(urgency),
+			 QFWD_SWITCH_PORT_MODE_PORT_ENA |
+			 QFWD_SWITCH_PORT_MODE_FWD_URGENCY,
+			 sparx5,
+			 QFWD_SWITCH_PORT_MODE(port->portno));
+	} else {
+		/* Disable port link */
+		SPX5_RMW(DEV2G5_DEV_RST_CTRL_PCS_RX_RST,
+			 DEV2G5_DEV_RST_CTRL_PCS_RX_RST,
+			 sparx5,
+			 DEV2G5_DEV_RST_CTRL(port->portno));
+
+		if (!sparx5_port_is_2g5(port->portno)) {
+			u32 dev = sparx5_to_high_dev(port->portno);
+			void __iomem *inst;
+
+			inst = SPX5_INST_GET(sparx5, dev, port->portno);
+			SPX5_INST_RMW(DEV10G_DEV_RST_CTRL_PCS_RX_RST,
+				      DEV10G_DEV_RST_CTRL_PCS_RX_RST,
+				      inst,
+				      DEV10G_DEV_RST_CTRL(0));
+		}
+	}
+
+	/* Save the new values */
+	port->conf = *conf;
+
+	return err;
+}
+
+/* Initialize port config to default */
+int sparx5_port_init(struct sparx5 *sparx5,
+		     struct sparx5_port *port,
+		     struct sparx5_port_config *conf)
+{
+	int err;
+	u32 devhigh           = sparx5_to_high_dev(port->portno);
+	u32 pix               = sparx5_port_dev_index(port->portno);
+	void __iomem *devinst = SPX5_INST_GET(sparx5, devhigh, pix);
+	u32 pcs               = sparx5_to_pcs_dev(port->portno);
+	void __iomem *pcsinst = SPX5_INST_GET(sparx5, pcs, pix);
+	int maxlen            = ETH_DATA_LEN + ETH_HLEN + ETH_FCS_LEN;
+	bool sd_pol           = port->signd_active_high;
+	bool sd_ena           = port->signd_enable;
+	bool sd_sel           = !port->signd_internal;
+	u32 atop              = wm_enc(20 * (maxlen / SPX5_BUFFER_CELL_SZ));
+	u32 pause_start       = wm_enc(6  * (maxlen / SPX5_BUFFER_CELL_SZ));
+	u32 pause_stop        = 0xFFF - 1; /* FC generate disabled */
+
+	/* Set the mux port mode */
+	err = sparx5_port_mux_set(sparx5, port, conf);
+	if (err)
+		return err;
+
+	/* Configure MAC vlan awareness */
+	err = sparx5_port_max_tags_set(sparx5, port);
+	if (err)
+		return err;
+
+	/* Set Max Length */
+	SPX5_RMW(DEV2G5_MAC_MAXLEN_CFG_MAX_LEN_SET(maxlen),
+		 DEV2G5_MAC_MAXLEN_CFG_MAX_LEN,
+		 sparx5,
+		 DEV2G5_MAC_MAXLEN_CFG(port->portno));
+
+	/* 1G/2G5: Signal Detect configuration */
+	SPX5_WR(DEV2G5_PCS1G_SD_CFG_SD_POL_SET(sd_pol) |
+		DEV2G5_PCS1G_SD_CFG_SD_SEL_SET(sd_sel) |
+		DEV2G5_PCS1G_SD_CFG_SD_ENA_SET(sd_ena),
+		sparx5,
+		DEV2G5_PCS1G_SD_CFG(port->portno));
+
+	/* 100fx: Signal Detect configuration */
+	SPX5_RMW(DEV2G5_PCS_FX100_CFG_SD_POL_SET(sd_pol) |
+		 DEV2G5_PCS_FX100_CFG_SD_SEL_SET(sd_sel) |
+		 DEV2G5_PCS_FX100_CFG_SD_ENA_SET(sd_ena),
+		 DEV2G5_PCS_FX100_CFG_SD_POL |
+		 DEV2G5_PCS_FX100_CFG_SD_SEL |
+		 DEV2G5_PCS_FX100_CFG_SD_ENA,
+		 sparx5,
+		 DEV2G5_PCS_FX100_CFG(port->portno));
+
+	/* Set Pause WM hysteresis */
+	SPX5_RMW(QSYS_PAUSE_CFG_PAUSE_START_SET(pause_start) |
+		 QSYS_PAUSE_CFG_PAUSE_STOP_SET(pause_stop) |
+		 QSYS_PAUSE_CFG_PAUSE_ENA_SET(1),
+		 QSYS_PAUSE_CFG_PAUSE_START |
+		 QSYS_PAUSE_CFG_PAUSE_STOP |
+		 QSYS_PAUSE_CFG_PAUSE_ENA,
+		 sparx5,
+		 QSYS_PAUSE_CFG(port->portno));
+
+	/* Port ATOP. Frames are tail dropped when this WM is hit */
+	SPX5_WR(QSYS_ATOP_ATOP_SET(atop),
+		sparx5,
+		QSYS_ATOP(port->portno));
+
+	/* Discard pause frame 01-80-C2-00-00-01 */
+	SPX5_WR(0xC, sparx5, ANA_CL_CAPTURE_BPDU_CFG(port->portno));
+
+	if (sparx5_port_is_2g5(port->portno))
+		return 0;
+
+	/* Now setup the high speed device */
+
+	/* Set Max Length */
+	SPX5_INST_RMW(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_SET(maxlen),
+		      DEV10G_MAC_MAXLEN_CFG_MAX_LEN,
+		      devinst,
+		      DEV10G_MAC_ENA_CFG(0));
+
+	/* Handle Signal Detect in 10G PCS */
+	SPX5_INST_WR(PCS10G_BR_PCS_SD_CFG_SD_POL_SET(sd_pol) |
+		     PCS10G_BR_PCS_SD_CFG_SD_SEL_SET(sd_sel) |
+		     PCS10G_BR_PCS_SD_CFG_SD_ENA_SET(sd_ena),
+		     pcsinst,
+		     PCS10G_BR_PCS_SD_CFG(0));
+
+	if (sparx5_port_is_25g(port->portno)) {
+		/* Handle Signal Detect in 25G PCS */
+		SPX5_WR(DEV25G_PCS25G_SD_CFG_SD_POL_SET(sd_pol) |
+			DEV25G_PCS25G_SD_CFG_SD_SEL_SET(sd_sel) |
+			DEV25G_PCS25G_SD_CFG_SD_ENA_SET(sd_ena),
+			sparx5,
+			DEV25G_PCS25G_SD_CFG(pix));
+	}
+
+	return 0;
+}
+
+void sparx5_port_enable(struct sparx5_port *port, bool enable)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	/* Enable port for frame transfer? */
+	SPX5_RMW(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(enable),
+		 QFWD_SWITCH_PORT_MODE_PORT_ENA,
+		 sparx5,
+		 QFWD_SWITCH_PORT_MODE(port->portno));
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
new file mode 100644
index 000000000000..a248df4b8c58
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_PORT_H__
+#define __SPARX5_PORT_H__
+
+#include "sparx5_main.h"
+
+static inline bool sparx5_port_is_2g5(int portno)
+{
+	return portno >= 16 && portno <= 47;
+}
+
+static inline bool sparx5_port_is_5g(int portno)
+{
+	return portno <= 11 || portno == 64;
+}
+
+static inline bool sparx5_port_is_10g(int portno)
+{
+	return (portno >= 12 && portno <= 15) || (portno >= 48 && portno <= 55);
+}
+
+static inline bool sparx5_port_is_25g(int portno)
+{
+	return portno >= 56 && portno <= 63;
+}
+
+static inline u32 sparx5_to_high_dev(int port)
+{
+	if (sparx5_port_is_5g(port))
+		return TARGET_DEV5G;
+	if (sparx5_port_is_10g(port))
+		return TARGET_DEV10G;
+	return TARGET_DEV25G;
+}
+
+static inline u32 sparx5_to_pcs_dev(int port)
+{
+	if (sparx5_port_is_5g(port))
+		return TARGET_PCS5G_BR;
+	if (sparx5_port_is_10g(port))
+		return TARGET_PCS10G_BR;
+	return TARGET_PCS25G_BR;
+}
+
+static inline int sparx5_port_dev_index(int port)
+{
+	if (sparx5_port_is_2g5(port))
+		return port;
+	if (sparx5_port_is_5g(port))
+		return (port <= 11 ? port : 12);
+	if (sparx5_port_is_10g(port))
+		return (port >= 12 && port <= 15) ?
+			port - 12 : port - 44;
+	return (port - 56);
+}
+
+static inline bool sparx5_is_high_speed_device(struct sparx5_port_config *conf)
+{
+	return conf->speed > SPEED_2500;
+}
+
+int sparx5_port_init(struct sparx5 *sparx5,
+		     struct sparx5_port *spx5_port,
+		     struct sparx5_port_config *conf);
+
+int sparx5_port_config(struct sparx5 *sparx5,
+		       struct sparx5_port *spx5_port,
+		       struct sparx5_port_config *conf);
+
+int sparx5_serdes_set(struct sparx5 *sparx5,
+		      struct sparx5_port *spx5_port,
+		      struct sparx5_port_config *conf);
+
+struct sparx5_port_status {
+	bool link;
+	bool link_down;
+	int  speed;
+	bool an_complete;
+	int  duplex;
+	int  pause;
+	int  serdes_link;
+};
+
+int sparx5_get_port_status(struct sparx5 *sparx5,
+			   struct sparx5_port *port,
+			   struct sparx5_port_status *status);
+
+void sparx5_port_enable(struct sparx5_port *port, bool enable);
+
+#endif	/* __SPARX5_PORT_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
new file mode 100644
index 000000000000..6cb6311d9a8d
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -0,0 +1,510 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/if_bridge.h>
+#include <net/switchdev.h>
+
+#include "sparx5_main.h"
+
+static struct workqueue_struct *sparx5_owq;
+
+struct sparx5_switchdev_event_work {
+	struct work_struct work;
+	struct switchdev_notifier_fdb_info fdb_info;
+	struct net_device *dev;
+	unsigned long event;
+};
+
+static void sparx5_port_attr_bridge_flags(struct sparx5_port *port,
+					  unsigned long flags)
+{
+	sparx5_pgid_update_mask(port, PGID_MC_FLOOD, flags & BR_MCAST_FLOOD);
+}
+
+static void sparx5_attr_stp_state_set(struct sparx5_port *port,
+				      struct switchdev_trans *trans,
+				      u8 state)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (!test_bit(port->portno, sparx5->bridge_mask)) {
+		netdev_err(port->ndev,
+			   "Controlling non-bridged port %d?\n", port->portno);
+		return;
+	}
+
+	switch (state) {
+	case BR_STATE_FORWARDING:
+		set_bit(port->portno, sparx5->bridge_fwd_mask);
+		break;
+	default:
+		clear_bit(port->portno, sparx5->bridge_fwd_mask);
+		break;
+	}
+
+	/* apply the bridge_fwd_mask to all the ports */
+	sparx5_update_fwd(sparx5);
+}
+
+static void sparx5_port_attr_ageing_set(struct sparx5_port *port,
+					unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
+
+	sparx5_set_ageing(port->sparx5, ageing_time);
+}
+
+static int sparx5_port_attr_set(struct net_device *dev,
+				const struct switchdev_attr *attr,
+				struct switchdev_trans *trans)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		sparx5_port_attr_bridge_flags(port, attr->u.brport_flags);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		sparx5_attr_stp_state_set(port, trans, attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		sparx5_port_attr_ageing_set(port, attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		port->vlan_aware = attr->u.vlan_filtering;
+		sparx5_vlan_port_apply(port->sparx5, port);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int sparx5_port_bridge_join(struct sparx5_port *port,
+				   struct net_device *bridge)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
+		/* First bridged port */
+		sparx5->hw_bridge_dev = bridge;
+	else
+		if (sparx5->hw_bridge_dev != bridge)
+			/* This is adding the port to a second bridge, this is
+			 * unsupported
+			 */
+			return -ENODEV;
+
+	set_bit(port->portno, sparx5->bridge_mask);
+
+	/* Port enters in bridge mode therefor don't need to copy to CPU
+	 * frames for multicast in case the bridge is not requesting them
+	 */
+	__dev_mc_unsync(port->ndev, sparx5_mc_unsync);
+
+	return 0;
+}
+
+static void sparx5_port_bridge_leave(struct sparx5_port *port,
+				     struct net_device *bridge)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+
+	clear_bit(port->portno, sparx5->bridge_mask);
+	if (bitmap_empty(sparx5->bridge_mask, SPX5_PORTS))
+		sparx5->hw_bridge_dev = NULL;
+
+	/* Clear bridge vlan settings before updating the port settings */
+	port->vlan_aware = 0;
+	port->pvid = NULL_VID;
+	port->vid = NULL_VID;
+
+	/* Port enters in host more therefore restore mc list */
+	__dev_mc_sync(port->ndev, sparx5_mc_sync, sparx5_mc_unsync);
+}
+
+static int sparx5_port_changeupper(struct net_device *dev,
+				   struct netdev_notifier_changeupper_info *info)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int err = 0;
+
+	if (netif_is_bridge_master(info->upper_dev)) {
+		if (info->linking)
+			err = sparx5_port_bridge_join(port, info->upper_dev);
+		else
+			sparx5_port_bridge_leave(port, info->upper_dev);
+
+		sparx5_vlan_port_apply(port->sparx5, port);
+	}
+
+	return err;
+}
+
+static int sparx5_port_add_addr(struct net_device *dev, bool up)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u16 vid = port->pvid;
+
+	if (up)
+		sparx5_mact_learn(sparx5, PGID_CPU, port->ndev->dev_addr, vid);
+	else
+		sparx5_mact_forget(sparx5, port->ndev->dev_addr, vid);
+
+	return 0;
+}
+
+static int sparx5_netdevice_port_event(struct net_device *dev,
+				       struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	int err = 0;
+
+	if (!sparx5_netdevice_check(dev))
+		return 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		err = sparx5_port_changeupper(dev, ptr);
+		break;
+	case NETDEV_PRE_UP:
+		err = sparx5_port_add_addr(dev, true);
+		break;
+	case NETDEV_DOWN:
+		err = sparx5_port_add_addr(dev, false);
+		break;
+	}
+
+	return err;
+}
+
+static int sparx5_netdevice_event(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int ret = 0;
+
+	ret = sparx5_netdevice_port_event(dev, nb, event, ptr);
+
+	return notifier_from_errno(ret);
+}
+
+static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
+{
+	struct sparx5_switchdev_event_work *switchdev_work =
+		container_of(work, struct sparx5_switchdev_event_work, work);
+	struct net_device *dev = switchdev_work->dev;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct sparx5_port *port;
+	struct sparx5 *sparx5;
+
+	rtnl_lock();
+	if (!sparx5_netdevice_check(dev))
+		goto out;
+
+	port = netdev_priv(dev);
+	sparx5 = port->sparx5;
+
+	fdb_info = &switchdev_work->fdb_info;
+
+	switch (switchdev_work->event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		sparx5_add_mact_entry(sparx5, port, fdb_info->addr,
+				      fdb_info->vid);
+		break;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		sparx5_del_mact_entry(sparx5, fdb_info->addr, fdb_info->vid);
+		break;
+	}
+
+out:
+	rtnl_unlock();
+	kfree(switchdev_work->fdb_info.addr);
+	kfree(switchdev_work);
+	dev_put(dev);
+}
+
+static void sparx5_schedule_work(struct work_struct *work)
+{
+	queue_work(sparx5_owq, work);
+}
+
+static int sparx5_switchdev_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct sparx5_switchdev_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     sparx5_netdevice_check,
+						     sparx5_port_attr_set);
+		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		fallthrough;
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
+
+		switchdev_work->dev = dev;
+		switchdev_work->event = event;
+
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+		INIT_WORK(&switchdev_work->work,
+			  sparx5_switchdev_bridge_fdb_event_work);
+		memcpy(&switchdev_work->fdb_info, ptr,
+		       sizeof(switchdev_work->fdb_info));
+		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+		if (!switchdev_work->fdb_info.addr)
+			goto err_addr_alloc;
+
+		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+				fdb_info->addr);
+		dev_hold(dev);
+
+		sparx5_schedule_work(&switchdev_work->work);
+		break;
+	}
+
+	return NOTIFY_DONE;
+err_addr_alloc:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
+static void sparx5_sync_port_dev_addr(struct sparx5 *sparx5,
+				      struct sparx5_port *port,
+				      u16 vid, bool add)
+{
+	if (!port ||
+	    !test_bit(port->portno, sparx5->bridge_mask))
+		return; /* Skip null/host interfaces */
+
+	/* Bridge connects to vid? */
+	if (add) {
+		/* Add port MAC address from the VLAN */
+		sparx5_mact_learn(sparx5, PGID_CPU,
+				  port->ndev->dev_addr, vid);
+	} else {
+		/* Control port addr visibility depending on
+		 * port VLAN connectivity.
+		 */
+		if (test_bit(port->portno, sparx5->vlan_mask[vid]))
+			sparx5_mact_learn(sparx5, PGID_CPU,
+					  port->ndev->dev_addr, vid);
+		else
+			sparx5_mact_forget(sparx5,
+					   port->ndev->dev_addr, vid);
+	}
+}
+
+static void sparx5_sync_bridge_dev_addr(struct net_device *dev,
+					struct sparx5 *sparx5,
+					u16 vid, bool add)
+{
+	int i;
+
+	/* First, handle bridge address'es */
+	if (add) {
+		sparx5_mact_learn(sparx5, PGID_CPU, dev->dev_addr,
+				  vid);
+		sparx5_mact_learn(sparx5, PGID_BCAST, dev->broadcast,
+				  vid);
+	} else {
+		sparx5_mact_forget(sparx5, dev->dev_addr, vid);
+		sparx5_mact_forget(sparx5, dev->broadcast, vid);
+	}
+
+	/* Now look at bridged ports */
+	for (i = 0; i < SPX5_PORTS; i++)
+		sparx5_sync_port_dev_addr(sparx5, sparx5->ports[i], vid, add);
+}
+
+static int sparx5_handle_port_vlan_add(struct net_device *dev,
+				       struct notifier_block *nb,
+				       const struct switchdev_obj_port_vlan *v,
+				       struct switchdev_trans *trans)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int ret;
+	u16 vid;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (netif_is_bridge_master(dev)) {
+		if (v->flags & BRIDGE_VLAN_INFO_BRENTRY) {
+			struct sparx5 *sparx5 =
+				container_of(nb, struct sparx5,
+					     switchdev_blocking_nb);
+
+			for (vid = v->vid_begin; vid <= v->vid_end; vid++)
+				sparx5_sync_bridge_dev_addr(dev, sparx5, vid, true);
+		}
+		return 0;
+	}
+
+	for (vid = v->vid_begin; vid <= v->vid_end; vid++) {
+		ret = sparx5_vlan_vid_add(port, vid,
+					  v->flags & BRIDGE_VLAN_INFO_PVID,
+					  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sparx5_handle_port_obj_add(struct net_device *dev,
+				      struct notifier_block *nb,
+				      struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = sparx5_handle_port_vlan_add(dev, nb,
+						  SWITCHDEV_OBJ_PORT_VLAN(obj),
+						  info->trans);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int sparx5_handle_port_vlan_del(struct net_device *dev,
+				       struct notifier_block *nb,
+				       const struct switchdev_obj_port_vlan *v,
+				       struct switchdev_trans *trans)
+{
+	struct sparx5_port *port = netdev_priv(dev);
+	int ret;
+	u16 vid;
+
+	/* Master bridge? */
+	if (netif_is_bridge_master(dev)) {
+		struct sparx5 *sparx5 = container_of(nb, struct sparx5,
+						     switchdev_blocking_nb);
+
+		for (vid = v->vid_begin; vid <= v->vid_end; vid++)
+			sparx5_sync_bridge_dev_addr(dev, sparx5, vid, false);
+		return 0;
+	}
+
+	for (vid = v->vid_begin; vid <= v->vid_end; vid++) {
+		ret = sparx5_vlan_vid_del(port, vid);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int sparx5_handle_port_obj_del(struct net_device *dev,
+				      struct notifier_block *nb,
+				      struct switchdev_notifier_port_obj_info *info)
+{
+	const struct switchdev_obj *obj = info->obj;
+	int err;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		err = sparx5_handle_port_vlan_del(dev, nb,
+						  SWITCHDEV_OBJ_PORT_VLAN(obj),
+						  info->trans);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	info->handled = true;
+	return err;
+}
+
+static int sparx5_switchdev_blocking_event(struct notifier_block *nb,
+					   unsigned long event,
+					   void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = sparx5_handle_port_obj_add(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = sparx5_handle_port_obj_del(dev, nb, ptr);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     sparx5_netdevice_check,
+						     sparx5_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
+}
+
+int sparx5_register_notifier_blocks(struct sparx5 *s5)
+{
+	int err;
+
+	s5->netdevice_nb.notifier_call = sparx5_netdevice_event;
+	err = register_netdevice_notifier(&s5->netdevice_nb);
+	if (err)
+		return err;
+
+	s5->switchdev_nb.notifier_call = sparx5_switchdev_event;
+	err = register_switchdev_notifier(&s5->switchdev_nb);
+	if (err)
+		goto err_switchdev_nb;
+
+	s5->switchdev_blocking_nb.notifier_call = sparx5_switchdev_blocking_event;
+	err = register_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
+	if (err)
+		goto err_switchdev_blocking_nb;
+
+	sparx5_owq = alloc_ordered_workqueue("sparx5_order", 0);
+	if (!sparx5_owq)
+		goto err_switchdev_blocking_nb;
+
+	return 0;
+
+err_switchdev_blocking_nb:
+	unregister_switchdev_notifier(&s5->switchdev_nb);
+err_switchdev_nb:
+	unregister_netdevice_notifier(&s5->netdevice_nb);
+
+	return err;
+}
+
+void sparx5_unregister_notifier_blocks(struct sparx5 *s5)
+{
+	destroy_workqueue(sparx5_owq);
+
+	unregister_switchdev_blocking_notifier(&s5->switchdev_blocking_nb);
+	unregister_switchdev_notifier(&s5->switchdev_nb);
+	unregister_netdevice_notifier(&s5->netdevice_nb);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
new file mode 100644
index 000000000000..f009b53a10e1
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ */
+
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
+	SPX5_WR(mask[0], sparx5, ANA_L3_VLAN_MASK_CFG(vid));
+	SPX5_WR(mask[1], sparx5, ANA_L3_VLAN_MASK_CFG1(vid));
+	SPX5_WR(mask[2], sparx5, ANA_L3_VLAN_MASK_CFG2(vid));
+
+	return 0;
+}
+
+void sparx5_vlan_init(struct sparx5 *sparx5)
+{
+	u16 vid;
+
+	SPX5_RMW(ANA_L3_VLAN_CTRL_VLAN_ENA_SET(1),
+		 ANA_L3_VLAN_CTRL_VLAN_ENA,
+		 sparx5,
+		 ANA_L3_VLAN_CTRL);
+
+	/* Map VLAN = FID */
+	for (vid = NULL_VID; vid < VLAN_N_VID; vid++)
+		SPX5_RMW(ANA_L3_VLAN_CFG_VLAN_FID_SET(vid),
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
+	SPX5_RMW(ANA_CL_VLAN_CTRL_VLAN_AWARE_ENA_SET(0) |
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
+	/* Untagged egress vlan clasification */
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
+		SPX5_RMW(val, mask, sparx5, ANA_AC_PGID_CFG(pgid));
+	} else if (port->portno < 64) {
+		mask = BIT(port->portno - 32);
+		val = enable ? mask : 0;
+		SPX5_RMW(val, mask, sparx5, ANA_AC_PGID_CFG1(pgid));
+	} else if (port->portno < SPX5_PORTS) {
+		mask = BIT(port->portno - 64);
+		val = enable ? mask : 0;
+		SPX5_RMW(val, mask, sparx5, ANA_AC_PGID_CFG2(pgid));
+	} else {
+		netdev_err(port->ndev, "Invalid port no: %d\n", port->portno);
+	}
+}
+
+void sparx5_update_fwd(struct sparx5 *sparx5)
+{
+	u32 mask[3];
+	DECLARE_BITMAP(srcmask, SPX5_PORTS);
+	int port;
+
+	/* Divide up mask in 32 bit words */
+	bitmap_to_arr32(mask, sparx5->bridge_fwd_mask, SPX5_PORTS);
+
+	/* Update flood masks */
+	for (port = PGID_UC_FLOOD; port <= PGID_BCAST; port++) {
+		SPX5_WR(mask[0], sparx5, ANA_AC_PGID_CFG(port));
+		SPX5_WR(mask[1], sparx5, ANA_AC_PGID_CFG1(port));
+		SPX5_WR(mask[2], sparx5, ANA_AC_PGID_CFG2(port));
+	}
+
+	/* Only bridged ports have learning */
+	SPX5_WR(mask[0], sparx5, ANA_L2_AUTO_LRN_CFG);
+	SPX5_WR(mask[1], sparx5, ANA_L2_AUTO_LRN_CFG1);
+	SPX5_WR(mask[2], sparx5, ANA_L2_AUTO_LRN_CFG2);
+
+	/* Update SRC masks */
+	for (port = 0; port < SPX5_PORTS; port++) {
+		if (test_bit(port, sparx5->bridge_fwd_mask)) {
+			/* Allow to send to all bridged but self */
+			bitmap_copy(srcmask, sparx5->bridge_fwd_mask,
+				    SPX5_PORTS);
+			clear_bit(port, srcmask);
+			bitmap_to_arr32(mask, srcmask, SPX5_PORTS);
+			SPX5_WR(mask[0], sparx5, ANA_AC_SRC_CFG(port));
+			SPX5_WR(mask[1], sparx5, ANA_AC_SRC_CFG1(port));
+			SPX5_WR(mask[2], sparx5, ANA_AC_SRC_CFG2(port));
+		} else {
+			SPX5_WR(0, sparx5, ANA_AC_SRC_CFG(port));
+			SPX5_WR(0, sparx5, ANA_AC_SRC_CFG1(port));
+			SPX5_WR(0, sparx5, ANA_AC_SRC_CFG2(port));
+		}
+	}
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
+	SPX5_WR(val, sparx5, ANA_CL_VLAN_CTRL(port->portno));
+
+	val = 0;
+	if (port->vlan_aware && !port->pvid)
+		/* If port is vlan-aware and tagged, drop untagged and
+		 * priority tagged frames.
+		 */
+		val = ANA_CL_VLAN_FILTER_CTRL_TAG_REQUIRED_ENA_SET(1) |
+			ANA_CL_VLAN_FILTER_CTRL_PRIO_CTAG_DIS_SET(1) |
+			ANA_CL_VLAN_FILTER_CTRL_PRIO_STAG_DIS_SET(1);
+	SPX5_WR(val, sparx5,
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
+	SPX5_WR(val, sparx5, REW_TAG_CTRL(port->portno));
+
+	/* Egress VID */
+	SPX5_RMW(REW_PORT_VLAN_CFG_PORT_VID_SET(port->vid),
+		 REW_PORT_VLAN_CFG_PORT_VID,
+		 sparx5,
+		 REW_PORT_VLAN_CFG(port->portno));
+}
-- 
2.29.2

