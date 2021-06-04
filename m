Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA45E39B559
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFDI6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:58:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:9424 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFDI6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622797004; x=1654333004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kAH3usXQtcbpYXZD7uBtYJ8EeILCOCZ2dMokL1T4F5M=;
  b=UEh0kN+unkNGiBsSeCYnkbwXhsQRL0TQ9VmL6RCK1NPbhA65HYT/X1Bd
   9S2cNwDLZBvNAwLKeb3KMp8VOJWWh2eIpZ+ZAxEG1zkFK1V5uhwVwxWqL
   SSg3VNyw27sW8ZZVcB1iI0T3NGinWm6txGzD5QS0A2Ptle3kHt6cyBIkq
   ANx37eoN0Fs7VawuQxkKWvkqO0zZAfv0c8/CLhFadlkN3rUf0rWPtMPAX
   e4uDI0IddcizRrO70EDCQIZcuHOlxCUudWw6xbX3bXR4bPrloGWo4K3Le
   DLIku46XKbdxEx1b3DnBw3QYSMEgnFXHh8x98Vp/AZFdPUKzUvEri+p3C
   A==;
IronPort-SDR: 1qbBZfM8V07rVi65MSJujSeTfYK9qhgS8XgDsxWg29BzTUX+R/K2eMzBDNw+xEr7n0rxJ5rNxZ
 9d7eDxFzAxNcdnrXOfbejt6EfCKLGbqktqN1zHU42Bwy6MEH1YA+VcFB6qtfgGvhu74BO2dnTX
 bTZjg7f2jtNpKgez/PkJbkB+fPQa0qW9hPoond+Nbdon7uljHCtaRMFrAs4W/FvvXMgwyGu+AA
 I7lMkdhUu3hfZt5rcWQgkNt9tRFIj+l8ItFyiQNSUhHLBNp09DDil/WyHnpoRtiHuCz/NpdzjN
 IsI=
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="117630485"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jun 2021 01:56:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 01:56:43 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 4 Jun 2021 01:56:39 -0700
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
Subject: [PATCH net-next v3 08/10] net: sparx5: add calendar bandwidth allocation support
Date:   Fri, 4 Jun 2021 10:55:58 +0200
Message-ID: <20210604085600.3014532-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604085600.3014532-1-steen.hegelund@microchip.com>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This configures the Sparx5 calendars according to the bandwidth
requested in the Device Tree nodes.
It also checks if the total requested bandwidth is within the
specs of the detected Sparx5 models limits.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../microchip/sparx5/sparx5_calendar.c        | 596 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |   9 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |   4 +
 4 files changed, 609 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index d2788e8b7798..e7dea25eb479 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o sparx5_vlan.o \
- sparx5_switchdev.o
+ sparx5_switchdev.o sparx5_calendar.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c b/drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
new file mode 100644
index 000000000000..76a8bb596aec
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
@@ -0,0 +1,596 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+
+#include "sparx5_main_regs.h"
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
+#define SPEED_12500                    12500
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
+	return sparx5_bandwidth_to_calendar(port->conf.bandwidth);
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
+		u64 reg, offset, this_bw;
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
+	spx5_rmw(QSYS_CAL_CTRL_CAL_MODE_SET(10),
+		 QSYS_CAL_CTRL_CAL_MODE,
+		 sparx5, QSYS_CAL_CTRL);
+
+	/* Assign port bandwidth to auto calendar */
+	for (idx = 0; idx < ARRAY_SIZE(cal); idx++)
+		spx5_wr(cal[idx], sparx5, QSYS_CAL_AUTO(idx));
+
+	/* Increase grant rate of all ports to account for
+	 * core clock ppm deviations
+	 */
+	spx5_rmw(QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE_SET(671), /* 672->671 */
+		 QSYS_CAL_CTRL_CAL_AUTO_GRANT_RATE,
+		 sparx5,
+		 QSYS_CAL_CTRL);
+
+	/* Grant idle usage to VD 0-2 */
+	for (idx = 2; idx < 5; idx++)
+		spx5_wr(HSCH_OUTB_SHARE_ENA_OUTB_SHARE_ENA_SET(12),
+			sparx5,
+			HSCH_OUTB_SHARE_ENA(idx));
+
+	/* Enable Auto mode */
+	spx5_rmw(QSYS_CAL_CTRL_CAL_MODE_SET(8),
+		 QSYS_CAL_CTRL_CAL_MODE,
+		 sparx5, QSYS_CAL_CTRL);
+
+	/* Verify successful calendar config */
+	value = spx5_rd(sparx5, QSYS_CAL_CTRL);
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
+	spx5_wr(DSM_TAXI_CAL_CFG_CAL_PGM_ENA_SET(1),
+		sparx5,
+		DSM_TAXI_CAL_CFG(taxi));
+	for (idx = 0; idx < cal_len; idx++) {
+		spx5_rmw(DSM_TAXI_CAL_CFG_CAL_IDX_SET(idx),
+			 DSM_TAXI_CAL_CFG_CAL_IDX,
+			 sparx5,
+			 DSM_TAXI_CAL_CFG(taxi));
+		spx5_rmw(DSM_TAXI_CAL_CFG_CAL_PGM_VAL_SET(data->schedule[idx]),
+			 DSM_TAXI_CAL_CFG_CAL_PGM_VAL,
+			 sparx5,
+			 DSM_TAXI_CAL_CFG(taxi));
+	}
+	spx5_wr(DSM_TAXI_CAL_CFG_CAL_PGM_ENA_SET(0),
+		sparx5,
+		DSM_TAXI_CAL_CFG(taxi));
+	len = DSM_TAXI_CAL_CFG_CAL_CUR_LEN_GET(spx5_rd(sparx5,
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
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 6bfb4f2af87f..dec66776371b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -615,7 +615,14 @@ static int sparx5_start(struct sparx5 *sparx5)
 	/* Enable queue limitation watermarks */
 	sparx5_qlim_set(sparx5);
 
-	/* Resource calendar support to be added in later patches */
+	err = sparx5_config_auto_calendar(sparx5);
+	if (err)
+		return err;
+
+	err = sparx5_config_dsm_calendar(sparx5);
+	if (err)
+		return err;
+
 
 	/* Init mact_sw struct */
 	mutex_init(&sparx5->mact_lock);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 203586cca573..29b969891dfd 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -199,6 +199,10 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 int sparx5_vlan_vid_del(struct sparx5_port *port, u16 vid);
 void sparx5_vlan_port_apply(struct sparx5 *sparx5, struct sparx5_port *port);
 
+/* sparx5_calendar.c */
+int sparx5_config_auto_calendar(struct sparx5 *sparx5);
+int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
+
 /* sparx5_netdev.c */
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
-- 
2.31.1

