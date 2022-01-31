Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2BC4A3FA5
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357938AbiAaJ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:59:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62625 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357905AbiAaJ7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:59:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643623154; x=1675159154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dHz2JBy1pkwE7BP2JSx2Znyg2/LKouPdmQnQ5fIbvKo=;
  b=EN4QJ2egeXNBks+c0hFTOIR+/XonNY6/+UXPEYs7Lv8K6n1/BFpJz0Kw
   G8JFKRk2hWo9S3b4q9N2VPRzBMZvUUIGqfattR53dkESKHVs66fsgfcpE
   bY3iy/nj/shjmgTG4U0zD0adnM3+IYoC4xApRUZkDmydZlrBVOulXpwUT
   avsvm3FRppmeFmUf52YYIZT695rfa7SxeoOmAaRMS/K5yj76lPZ9YHaYR
   W7L5vWGSeBXlY55Q/JukD4Yq9IhrklL5DRWJRsONpsj2jmYTsGPjV95D9
   a4NjaNEITPQ+MiDRTHMqM8uiaPRueV1rFvCEyFQshmN1KUv1/irr8pD5L
   w==;
IronPort-SDR: Y7ULP+tAwibZRqk3euyAlsmdCagTolODI37u1jO/Mp+lZg+UlBHX9H/Sk4dJIkXUzAlyxsxVsC
 ZhcPZhsDdDw6vjbyy465Wdfpk5MM+7xeCEAE5aBQtTTh8ZwLmD2f+aJ93UnHAq+2Fo30/SDnXT
 cKdZY/1xbOL6v+VbayDbHdWrVWReKS3zmHVVov+0zU/iMHm4pTyh9eGhtLWAsVrVKWsRdk0F96
 NeuciSQC2mTTZC5+qDZE0C7AObN32ZOSQYZe8YxqQYc1dUSd1hFUYqhqmfAYtgQMmJ7dfrg1xH
 opzoYs8bPUGt7LTjDDNOl1Rg
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="151958761"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 02:59:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 02:59:13 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 31 Jan 2022 02:59:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 3/7] net: lan966x: Add support for ptp clocks
Date:   Mon, 31 Jan 2022 11:01:18 +0100
Message-ID: <20220131100122.423164-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131100122.423164-1-horatiu.vultur@microchip.com>
References: <20220131100122.423164-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lan966x has 3 PHC. Enable each of them, for now all the
timestamping is happening on the first PHC.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_main.c |   8 +
 .../ethernet/microchip/lan966x/lan966x_main.h |  20 ++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 287 ++++++++++++++++++
 4 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 040cfff9f577..a9ffc719aa0e 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
 lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o \
-			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o
+			lan966x_vlan.o lan966x_fdb.o lan966x_mdb.o \
+			lan966x_ptp.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 2853e8f7fb39..ee3505318c5c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -932,8 +932,15 @@ static int lan966x_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_ports;
 
+	err = lan966x_ptp_init(lan966x);
+	if (err)
+		goto cleanup_fdb;
+
 	return 0;
 
+cleanup_fdb:
+	lan966x_fdb_deinit(lan966x);
+
 cleanup_ports:
 	fwnode_handle_put(portnp);
 
@@ -959,6 +966,7 @@ static int lan966x_remove(struct platform_device *pdev)
 	lan966x_mac_purge_entries(lan966x);
 	lan966x_mdb_deinit(lan966x);
 	lan966x_fdb_deinit(lan966x);
+	lan966x_ptp_deinit(lan966x);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 99c6d0a9f946..c77a91aa24e7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -8,6 +8,7 @@
 #include <linux/jiffies.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
+#include <linux/ptp_clock_kernel.h>
 #include <net/switchdev.h>
 
 #include "lan966x_regs.h"
@@ -50,6 +51,9 @@
 #define LAN966X_SPEED_100		2
 #define LAN966X_SPEED_10		3
 
+#define LAN966X_PHC_COUNT		3
+#define LAN966X_PHC_PORT		0
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -70,6 +74,14 @@ struct lan966x_stat_layout {
 	char name[ETH_GSTRING_LEN];
 };
 
+struct lan966x_phc {
+	struct ptp_clock *clock;
+	struct ptp_clock_info info;
+	struct hwtstamp_config hwtstamp_config;
+	struct lan966x *lan966x;
+	u8 index;
+};
+
 struct lan966x {
 	struct device *dev;
 
@@ -113,6 +125,11 @@ struct lan966x {
 	/* mdb */
 	struct list_head mdb_entries;
 	struct list_head pgid_entries;
+
+	/* ptp */
+	bool ptp;
+	struct lan966x_phc phc[LAN966X_PHC_COUNT];
+	spinlock_t ptp_clock_lock; /* lock for phc */
 };
 
 struct lan966x_port_config {
@@ -228,6 +245,9 @@ int lan966x_handle_port_mdb_del(struct lan966x_port *port,
 void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid);
 void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid);
 
+int lan966x_ptp_init(struct lan966x *lan966x);
+void lan966x_ptp_deinit(struct lan966x *lan966x);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
new file mode 100644
index 000000000000..69d8f43e2b1b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include <linux/ptp_classify.h>
+
+#include "lan966x_main.h"
+
+#define LAN966X_MAX_PTP_ID	512
+
+/* Represents 1ppm adjustment in 2^59 format with 6.037735849ns as reference
+ * The value is calculated as following: (1/1000000)/((2^-59)/6.037735849)
+ */
+#define LAN966X_1PPM_FORMAT		3480517749723LL
+
+/* Represents 1ppb adjustment in 2^29 format with 6.037735849ns as reference
+ * The value is calculated as following: (1/1000000000)/((2^59)/6.037735849)
+ */
+#define LAN966X_1PPB_FORMAT		3480517749LL
+
+#define TOD_ACC_PIN		0x5
+
+enum {
+	PTP_PIN_ACTION_IDLE = 0,
+	PTP_PIN_ACTION_LOAD,
+	PTP_PIN_ACTION_SAVE,
+	PTP_PIN_ACTION_CLOCK,
+	PTP_PIN_ACTION_DELTA,
+	PTP_PIN_ACTION_TOD
+};
+
+static u64 lan966x_ptp_get_nominal_value(void)
+{
+	u64 res = 0x304d2df1;
+
+	res <<= 32;
+	return res;
+}
+
+static int lan966x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+	unsigned long flags;
+	bool neg_adj = 0;
+	u64 tod_inc;
+	u64 ref;
+
+	if (!scaled_ppm)
+		return 0;
+
+	if (scaled_ppm < 0) {
+		neg_adj = 1;
+		scaled_ppm = -scaled_ppm;
+	}
+
+	tod_inc = lan966x_ptp_get_nominal_value();
+
+	/* The multiplication is split in 2 separate additions because of
+	 * overflow issues. If scaled_ppm with 16bit fractional part was bigger
+	 * than 20ppm then we got overflow.
+	 */
+	ref = LAN966X_1PPM_FORMAT * (scaled_ppm >> 16);
+	ref += (LAN966X_1PPM_FORMAT * (0xffff & scaled_ppm)) >> 16;
+	tod_inc = neg_adj ? tod_inc - ref : tod_inc + ref;
+
+	spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+
+	lan_rmw(PTP_DOM_CFG_CLKCFG_DIS_SET(1 << BIT(phc->index)),
+		PTP_DOM_CFG_CLKCFG_DIS,
+		lan966x, PTP_DOM_CFG);
+
+	lan_wr((u32)tod_inc & 0xFFFFFFFF, lan966x,
+	       PTP_CLK_PER_CFG(phc->index, 0));
+	lan_wr((u32)(tod_inc >> 32), lan966x,
+	       PTP_CLK_PER_CFG(phc->index, 1));
+
+	lan_rmw(PTP_DOM_CFG_CLKCFG_DIS_SET(0),
+		PTP_DOM_CFG_CLKCFG_DIS,
+		lan966x, PTP_DOM_CFG);
+
+	spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+
+	return 0;
+}
+
+static int lan966x_ptp_settime64(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+
+	/* Must be in IDLE mode before the time can be loaded */
+	lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_IDLE) |
+		PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+		PTP_PIN_CFG_PIN_SYNC_SET(0),
+		PTP_PIN_CFG_PIN_ACTION |
+		PTP_PIN_CFG_PIN_DOM |
+		PTP_PIN_CFG_PIN_SYNC,
+		lan966x, PTP_PIN_CFG(TOD_ACC_PIN));
+
+	/* Set new value */
+	lan_wr(PTP_TOD_SEC_MSB_TOD_SEC_MSB_SET(upper_32_bits(ts->tv_sec)),
+	       lan966x, PTP_TOD_SEC_MSB(TOD_ACC_PIN));
+	lan_wr(lower_32_bits(ts->tv_sec),
+	       lan966x, PTP_TOD_SEC_LSB(TOD_ACC_PIN));
+	lan_wr(ts->tv_nsec, lan966x, PTP_TOD_NSEC(TOD_ACC_PIN));
+
+	/* Apply new values */
+	lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_LOAD) |
+		PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+		PTP_PIN_CFG_PIN_SYNC_SET(0),
+		PTP_PIN_CFG_PIN_ACTION |
+		PTP_PIN_CFG_PIN_DOM |
+		PTP_PIN_CFG_PIN_SYNC,
+		lan966x, PTP_PIN_CFG(TOD_ACC_PIN));
+
+	spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+
+	return 0;
+}
+
+static int lan966x_ptp_gettime64(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+	unsigned long flags;
+	time64_t s;
+	s64 ns;
+
+	spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+
+	lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_SAVE) |
+		PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+		PTP_PIN_CFG_PIN_SYNC_SET(0),
+		PTP_PIN_CFG_PIN_ACTION |
+		PTP_PIN_CFG_PIN_DOM |
+		PTP_PIN_CFG_PIN_SYNC,
+		lan966x, PTP_PIN_CFG(TOD_ACC_PIN));
+
+	s = lan_rd(lan966x, PTP_TOD_SEC_MSB(TOD_ACC_PIN));
+	s <<= 32;
+	s |= lan_rd(lan966x, PTP_TOD_SEC_LSB(TOD_ACC_PIN));
+	ns = lan_rd(lan966x, PTP_TOD_NSEC(TOD_ACC_PIN));
+	ns &= PTP_TOD_NSEC_TOD_NSEC;
+
+	spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+
+	/* Deal with negative values */
+	if ((ns & 0xFFFFFFF0) == 0x3FFFFFF0) {
+		s--;
+		ns &= 0xf;
+		ns += 999999984;
+	}
+
+	set_normalized_timespec64(ts, s, ns);
+	return 0;
+}
+
+static int lan966x_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
+	struct lan966x *lan966x = phc->lan966x;
+
+	if (delta > -(NSEC_PER_SEC / 2) && delta < (NSEC_PER_SEC / 2)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&lan966x->ptp_clock_lock, flags);
+
+		/* Must be in IDLE mode before the time can be loaded */
+		lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_IDLE) |
+			PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+			PTP_PIN_CFG_PIN_SYNC_SET(0),
+			PTP_PIN_CFG_PIN_ACTION |
+			PTP_PIN_CFG_PIN_DOM |
+			PTP_PIN_CFG_PIN_SYNC,
+			lan966x, PTP_PIN_CFG(TOD_ACC_PIN));
+
+		lan_wr(PTP_TOD_NSEC_TOD_NSEC_SET(delta),
+		       lan966x, PTP_TOD_NSEC(TOD_ACC_PIN));
+
+		/* Adjust time with the value of PTP_TOD_NSEC */
+		lan_rmw(PTP_PIN_CFG_PIN_ACTION_SET(PTP_PIN_ACTION_DELTA) |
+			PTP_PIN_CFG_PIN_DOM_SET(phc->index) |
+			PTP_PIN_CFG_PIN_SYNC_SET(0),
+			PTP_PIN_CFG_PIN_ACTION |
+			PTP_PIN_CFG_PIN_DOM |
+			PTP_PIN_CFG_PIN_SYNC,
+			lan966x, PTP_PIN_CFG(TOD_ACC_PIN));
+
+		spin_unlock_irqrestore(&lan966x->ptp_clock_lock, flags);
+	} else {
+		/* Fall back using lan966x_ptp_settime64 which is not exact */
+		struct timespec64 ts;
+		u64 now;
+
+		lan966x_ptp_gettime64(ptp, &ts);
+
+		now = ktime_to_ns(timespec64_to_ktime(ts));
+		ts = ns_to_timespec64(now + delta);
+
+		lan966x_ptp_settime64(ptp, &ts);
+	}
+
+	return 0;
+}
+
+static struct ptp_clock_info lan966x_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "lan966x ptp",
+	.max_adj	= 200000,
+	.gettime64	= lan966x_ptp_gettime64,
+	.settime64	= lan966x_ptp_settime64,
+	.adjtime	= lan966x_ptp_adjtime,
+	.adjfine	= lan966x_ptp_adjfine,
+};
+
+static int lan966x_ptp_phc_init(struct lan966x *lan966x,
+				int index,
+				struct ptp_clock_info *clock_info)
+{
+	struct lan966x_phc *phc = &lan966x->phc[index];
+
+	phc->info = *clock_info;
+	phc->clock = ptp_clock_register(&phc->info, lan966x->dev);
+	if (IS_ERR(phc->clock))
+		return PTR_ERR(phc->clock);
+
+	phc->index = index;
+	phc->lan966x = lan966x;
+
+	/* PTP Rx stamping is always enabled.  */
+	phc->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+
+	return 0;
+}
+
+int lan966x_ptp_init(struct lan966x *lan966x)
+{
+	u64 tod_adj = lan966x_ptp_get_nominal_value();
+	int err, i;
+
+	if (!lan966x->ptp)
+		return 0;
+
+	for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
+		err = lan966x_ptp_phc_init(lan966x, i, &lan966x_ptp_clock_info);
+		if (err)
+			return err;
+	}
+
+	spin_lock_init(&lan966x->ptp_clock_lock);
+
+	/* Disable master counters */
+	lan_wr(PTP_DOM_CFG_ENA_SET(0), lan966x, PTP_DOM_CFG);
+
+	/* Configure the nominal TOD increment per clock cycle */
+	lan_rmw(PTP_DOM_CFG_CLKCFG_DIS_SET(0x7),
+		PTP_DOM_CFG_CLKCFG_DIS,
+		lan966x, PTP_DOM_CFG);
+
+	for (i = 0; i < LAN966X_PHC_COUNT; ++i) {
+		lan_wr((u32)tod_adj & 0xFFFFFFFF, lan966x,
+		       PTP_CLK_PER_CFG(i, 0));
+		lan_wr((u32)(tod_adj >> 32), lan966x,
+		       PTP_CLK_PER_CFG(i, 1));
+	}
+
+	lan_rmw(PTP_DOM_CFG_CLKCFG_DIS_SET(0),
+		PTP_DOM_CFG_CLKCFG_DIS,
+		lan966x, PTP_DOM_CFG);
+
+	/* Enable master counters */
+	lan_wr(PTP_DOM_CFG_ENA_SET(0x7), lan966x, PTP_DOM_CFG);
+
+	return 0;
+}
+
+void lan966x_ptp_deinit(struct lan966x *lan966x)
+{
+	int i;
+
+	for (i = 0; i < LAN966X_PHC_COUNT; ++i)
+		ptp_clock_unregister(lan966x->phc[i].clock);
+}
-- 
2.33.0

