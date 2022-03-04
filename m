Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49704CD305
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238566AbiCDLHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiCDLHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54A11AF8FD;
        Fri,  4 Mar 2022 03:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392007; x=1677928007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r0K16Of6jgoE3JqMivWSojZpKje6WIvgbEVRnTIvJmk=;
  b=QkQr77O+BJYaAD+kmcP6ACa9VsECu/sl2odUdLwLVeSLAAO/UaokSoaH
   i3BryAwqRqLXh3No25jX0m6htlM9LapWwPQ8whWFqrf5i/CNwv9JmSo8w
   NC9jlmAoJy61TuwzSf9Dzy64iGvE00ZPjjj1fO/H3IJeM3Awx7yTYTua4
   9F/9by5OmZDOxaDrOfzldKjAZdhhAyIXKZn6l5bsF0l/LTDB9ZXT1Q2uS
   u3c825pOKOIcdkCK30rnJ44iA+Oq9MVhJs1qEi2eRzPCHxgQ/VtzwLDOn
   EXCC1mBAhuURE6ODbsUFsPD98umgH6JLFIZoieziDLrh8o2xVCK6u+g29
   A==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="148088263"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:45 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:43 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 5/9] net: sparx5: Add support for ptp clocks
Date:   Fri, 4 Mar 2022 12:08:56 +0100
Message-ID: <20220304110900.3199904-6-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparx5 has 3 PHC. Enable each of them, for now all the
timestamping is happening on the first PHC.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   3 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |   7 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  21 ++
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 326 ++++++++++++++++++
 4 files changed, 356 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index c271e86ee292..e9dd348a6ebb 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
- sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o
+ sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
+ sparx5_ptp.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index e8d26b330945..f72da757d0fa 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -847,6 +847,12 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		dev_err(sparx5->dev, "Start failed\n");
 		goto cleanup_ports;
 	}
+
+	err = sparx5_ptp_init(sparx5);
+	if (err) {
+		dev_err(sparx5->dev, "PTP failed\n");
+		goto cleanup_ports;
+	}
 	goto cleanup_config;
 
 cleanup_ports:
@@ -870,6 +876,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 		disable_irq(sparx5->fdma_irq);
 		sparx5->fdma_irq = -ENXIO;
 	}
+	sparx5_ptp_deinit(sparx5);
 	sparx5_fdma_stop(sparx5);
 	sparx5_cleanup_ports(sparx5);
 	/* Unregister netdevs */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 6f0b6e60ceb8..cf68b3f90834 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -14,6 +14,8 @@
 #include <linux/if_vlan.h>
 #include <linux/bitmap.h>
 #include <linux/phylink.h>
+#include <linux/net_tstamp.h>
+#include <linux/ptp_clock_kernel.h>
 #include <linux/hrtimer.h>
 
 #include "sparx5_main_regs.h"
@@ -79,6 +81,9 @@ enum sparx5_vlan_port_type {
 #define FDMA_RX_DCB_MAX_DBS		15
 #define FDMA_TX_DCB_MAX_DBS		1
 
+#define SPARX5_PHC_COUNT		3
+#define SPARX5_PHC_PORT			0
+
 struct sparx5;
 
 struct sparx5_db_hw {
@@ -178,6 +183,14 @@ enum sparx5_core_clockfreq {
 	SPX5_CORE_CLOCK_625MHZ,   /* 625MHZ core clock frequency */
 };
 
+struct sparx5_phc {
+	struct ptp_clock *clock;
+	struct ptp_clock_info info;
+	struct hwtstamp_config hwtstamp_config;
+	struct sparx5 *sparx5;
+	u8 index;
+};
+
 struct sparx5 {
 	struct platform_device *pdev;
 	struct device *dev;
@@ -225,6 +238,10 @@ struct sparx5 {
 	int fdma_irq;
 	struct sparx5_rx rx;
 	struct sparx5_tx tx;
+	/* PTP */
+	bool ptp;
+	struct sparx5_phc phc[SPARX5_PHC_COUNT];
+	spinlock_t ptp_clock_lock; /* lock for phc */
 };
 
 /* sparx5_switchdev.c */
@@ -294,6 +311,10 @@ int sparx5_register_netdevs(struct sparx5 *sparx5);
 void sparx5_destroy_netdevs(struct sparx5 *sparx5);
 void sparx5_unregister_netdevs(struct sparx5 *sparx5);
 
+/* sparx5_ptp.c */
+int sparx5_ptp_init(struct sparx5 *sparx5);
+void sparx5_ptp_deinit(struct sparx5 *sparx5);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
new file mode 100644
index 000000000000..0203d872929c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ *
+ * The Sparx5 Chip Register Model can be browsed at this location:
+ * https://github.com/microchip-ung/sparx-5_reginfo
+ */
+#include <linux/ptp_classify.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+#define SPARX5_MAX_PTP_ID	512
+
+#define TOD_ACC_PIN		0x4
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
+static u64 sparx5_ptp_get_1ppm(struct sparx5 *sparx5)
+{
+	/* Represents 1ppm adjustment in 2^59 format with 1.59687500000(625)
+	 * 1.99609375000(500), 3.99218750000(250) as reference
+	 * The value is calculated as following:
+	 * (1/1000000)/((2^-59)/X)
+	 */
+
+	u64 res;
+
+	switch (sparx5->coreclock) {
+	case SPX5_CORE_CLOCK_250MHZ:
+		res = 2301339409586;
+		break;
+	case SPX5_CORE_CLOCK_500MHZ:
+		res = 1150669704793;
+		break;
+	case SPX5_CORE_CLOCK_625MHZ:
+		res =  920535763834;
+		break;
+	default:
+		WARN_ON("Invalid core clock");
+		break;
+	}
+
+	return res;
+}
+
+static u64 sparx5_ptp_get_nominal_value(struct sparx5 *sparx5)
+{
+	u64 res;
+
+	switch (sparx5->coreclock) {
+	case SPX5_CORE_CLOCK_250MHZ:
+		res = 0x1FF0000000000000;
+		break;
+	case SPX5_CORE_CLOCK_500MHZ:
+		res = 0x0FF8000000000000;
+		break;
+	case SPX5_CORE_CLOCK_625MHZ:
+		res = 0x0CC6666666666666;
+		break;
+	default:
+		WARN_ON("Invalid core clock");
+		break;
+	}
+
+	return res;
+}
+
+static int sparx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
+	struct sparx5 *sparx5 = phc->sparx5;
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
+	tod_inc = sparx5_ptp_get_nominal_value(sparx5);
+
+	/* The multiplication is split in 2 separate additions because of
+	 * overflow issues. If scaled_ppm with 16bit fractional part was bigger
+	 * than 20ppm then we got overflow.
+	 */
+	ref = sparx5_ptp_get_1ppm(sparx5) * (scaled_ppm >> 16);
+	ref += (sparx5_ptp_get_1ppm(sparx5) * (0xffff & scaled_ppm)) >> 16;
+	tod_inc = neg_adj ? tod_inc - ref : tod_inc + ref;
+
+	spin_lock_irqsave(&sparx5->ptp_clock_lock, flags);
+
+	spx5_rmw(PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS_SET(1 << BIT(phc->index)),
+		 PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS,
+		 sparx5, PTP_PTP_DOM_CFG);
+
+	spx5_wr((u32)tod_inc & 0xFFFFFFFF, sparx5,
+		PTP_CLK_PER_CFG(phc->index, 0));
+	spx5_wr((u32)(tod_inc >> 32), sparx5,
+		PTP_CLK_PER_CFG(phc->index, 1));
+
+	spx5_rmw(PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS_SET(0),
+		 PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS, sparx5,
+		 PTP_PTP_DOM_CFG);
+
+	spin_unlock_irqrestore(&sparx5->ptp_clock_lock, flags);
+
+	return 0;
+}
+
+static int sparx5_ptp_settime64(struct ptp_clock_info *ptp,
+				const struct timespec64 *ts)
+{
+	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
+	struct sparx5 *sparx5 = phc->sparx5;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sparx5->ptp_clock_lock, flags);
+
+	/* Must be in IDLE mode before the time can be loaded */
+	spx5_rmw(PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(PTP_PIN_ACTION_IDLE) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(phc->index) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(0),
+		 PTP_PTP_PIN_CFG_PTP_PIN_ACTION |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC,
+		 sparx5, PTP_PTP_PIN_CFG(TOD_ACC_PIN));
+
+	/* Set new value */
+	spx5_wr(PTP_PTP_TOD_SEC_MSB_PTP_TOD_SEC_MSB_SET(upper_32_bits(ts->tv_sec)),
+		sparx5, PTP_PTP_TOD_SEC_MSB(TOD_ACC_PIN));
+	spx5_wr(lower_32_bits(ts->tv_sec),
+		sparx5, PTP_PTP_TOD_SEC_LSB(TOD_ACC_PIN));
+	spx5_wr(ts->tv_nsec, sparx5, PTP_PTP_TOD_NSEC(TOD_ACC_PIN));
+
+	/* Apply new values */
+	spx5_rmw(PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(PTP_PIN_ACTION_LOAD) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(phc->index) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(0),
+		 PTP_PTP_PIN_CFG_PTP_PIN_ACTION |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC,
+		 sparx5, PTP_PTP_PIN_CFG(TOD_ACC_PIN));
+
+	spin_unlock_irqrestore(&sparx5->ptp_clock_lock, flags);
+
+	return 0;
+}
+
+static int sparx5_ptp_gettime64(struct ptp_clock_info *ptp,
+				struct timespec64 *ts)
+{
+	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
+	struct sparx5 *sparx5 = phc->sparx5;
+	unsigned long flags;
+	time64_t s;
+	s64 ns;
+
+	spin_lock_irqsave(&sparx5->ptp_clock_lock, flags);
+
+	spx5_rmw(PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(PTP_PIN_ACTION_SAVE) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(phc->index) |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(0),
+		 PTP_PTP_PIN_CFG_PTP_PIN_ACTION |
+		 PTP_PTP_PIN_CFG_PTP_PIN_DOM |
+		 PTP_PTP_PIN_CFG_PTP_PIN_SYNC,
+		 sparx5, PTP_PTP_PIN_CFG(TOD_ACC_PIN));
+
+	s = spx5_rd(sparx5, PTP_PTP_TOD_SEC_MSB(TOD_ACC_PIN));
+	s <<= 32;
+	s |= spx5_rd(sparx5, PTP_PTP_TOD_SEC_LSB(TOD_ACC_PIN));
+	ns = spx5_rd(sparx5, PTP_PTP_TOD_NSEC(TOD_ACC_PIN));
+	ns &= PTP_PTP_TOD_NSEC_PTP_TOD_NSEC;
+
+	spin_unlock_irqrestore(&sparx5->ptp_clock_lock, flags);
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
+static int sparx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
+	struct sparx5 *sparx5 = phc->sparx5;
+
+	if (delta > -(NSEC_PER_SEC / 2) && delta < (NSEC_PER_SEC / 2)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&sparx5->ptp_clock_lock, flags);
+
+		/* Must be in IDLE mode before the time can be loaded */
+		spx5_rmw(PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(PTP_PIN_ACTION_IDLE) |
+			 PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(phc->index) |
+			 PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(0),
+			 PTP_PTP_PIN_CFG_PTP_PIN_ACTION |
+			 PTP_PTP_PIN_CFG_PTP_PIN_DOM |
+			 PTP_PTP_PIN_CFG_PTP_PIN_SYNC,
+			 sparx5, PTP_PTP_PIN_CFG(TOD_ACC_PIN));
+
+		spx5_wr(PTP_PTP_TOD_NSEC_PTP_TOD_NSEC_SET(delta),
+			sparx5, PTP_PTP_TOD_NSEC(TOD_ACC_PIN));
+
+		/* Adjust time with the value of PTP_TOD_NSEC */
+		spx5_rmw(PTP_PTP_PIN_CFG_PTP_PIN_ACTION_SET(PTP_PIN_ACTION_DELTA) |
+			 PTP_PTP_PIN_CFG_PTP_PIN_DOM_SET(phc->index) |
+			 PTP_PTP_PIN_CFG_PTP_PIN_SYNC_SET(0),
+			 PTP_PTP_PIN_CFG_PTP_PIN_ACTION |
+			 PTP_PTP_PIN_CFG_PTP_PIN_DOM |
+			 PTP_PTP_PIN_CFG_PTP_PIN_SYNC,
+			 sparx5, PTP_PTP_PIN_CFG(TOD_ACC_PIN));
+
+		spin_unlock_irqrestore(&sparx5->ptp_clock_lock, flags);
+	} else {
+		/* Fall back using sparx5_ptp_settime64 which is not exact */
+		struct timespec64 ts;
+		u64 now;
+
+		sparx5_ptp_gettime64(ptp, &ts);
+
+		now = ktime_to_ns(timespec64_to_ktime(ts));
+		ts = ns_to_timespec64(now + delta);
+
+		sparx5_ptp_settime64(ptp, &ts);
+	}
+
+	return 0;
+}
+
+static struct ptp_clock_info sparx5_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "sparx5 ptp",
+	.max_adj	= 200000,
+	.gettime64	= sparx5_ptp_gettime64,
+	.settime64	= sparx5_ptp_settime64,
+	.adjtime	= sparx5_ptp_adjtime,
+	.adjfine	= sparx5_ptp_adjfine,
+};
+
+static int sparx5_ptp_phc_init(struct sparx5 *sparx5,
+			       int index,
+			       struct ptp_clock_info *clock_info)
+{
+	struct sparx5_phc *phc = &sparx5->phc[index];
+
+	phc->info = *clock_info;
+	phc->clock = ptp_clock_register(&phc->info, sparx5->dev);
+	if (IS_ERR(phc->clock))
+		return PTR_ERR(phc->clock);
+
+	phc->index = index;
+	phc->sparx5 = sparx5;
+
+	/* PTP Rx stamping is always enabled.  */
+	phc->hwtstamp_config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+
+	return 0;
+}
+
+int sparx5_ptp_init(struct sparx5 *sparx5)
+{
+	u64 tod_adj = sparx5_ptp_get_nominal_value(sparx5);
+	int err, i;
+
+	if (!sparx5->ptp)
+		return 0;
+
+	for (i = 0; i < SPARX5_PHC_COUNT; ++i) {
+		err = sparx5_ptp_phc_init(sparx5, i, &sparx5_ptp_clock_info);
+		if (err)
+			return err;
+	}
+
+	spin_lock_init(&sparx5->ptp_clock_lock);
+
+	/* Disable master counters */
+	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0), sparx5, PTP_PTP_DOM_CFG);
+
+	/* Configure the nominal TOD increment per clock cycle */
+	spx5_rmw(PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS_SET(0x7),
+		 PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS,
+		 sparx5, PTP_PTP_DOM_CFG);
+
+	for (i = 0; i < SPARX5_PHC_COUNT; ++i) {
+		spx5_wr((u32)tod_adj & 0xFFFFFFFF, sparx5,
+			PTP_CLK_PER_CFG(i, 0));
+		spx5_wr((u32)(tod_adj >> 32), sparx5,
+			PTP_CLK_PER_CFG(i, 1));
+	}
+
+	spx5_rmw(PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS_SET(0),
+		 PTP_PTP_DOM_CFG_PTP_CLKCFG_DIS,
+		 sparx5, PTP_PTP_DOM_CFG);
+
+	/* Enable master counters */
+	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
+
+	return 0;
+}
+
+void sparx5_ptp_deinit(struct sparx5 *sparx5)
+{
+	int i;
+
+	for (i = 0; i < SPARX5_PHC_COUNT; ++i)
+		ptp_clock_unregister(sparx5->phc[i].clock);
+}
-- 
2.33.0

