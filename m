Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B725B0E2
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgIBQMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgIBQL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:11:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5769EC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 09:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NQZWGCREQXqloNmUmGeXWyPf5ufH4Q7LZPQYsIJq/Yg=; b=OUw4QBLKnBL8u/+nhdf4GWCYGZ
        rZTUJRwqAesCB3MTowWNCyoCfyNnTFDbihcioTCkEBned8IhwLRaskW79ElkQQFO868SqXW/WiOSg
        HlKtFL6mSVWjg2oEJLEwD4WjjWWYQrmczEFQCtY2fGYwcp41NprQ63VF/jkmdYeC5tY8SYURQUX/9
        /LUGx3hcmwhzDdnLrfECXo1oxGRlDwISxXr+4m9Q6AGt1RRj4Vw4ZCnnoIEkp6yVQCQHinZR7DSLI
        2/pzy/aDZyhckYoDVGB/oaF1Q6w2seAjYiQSQmv0+4xlMrlRIAGW4s1JY6bv+myl96XOhInzuw3cQ
        /ZLINVkg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45138 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMW-0004x2-5y; Wed, 02 Sep 2020 17:11:52 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kDVMV-0000jk-Ux; Wed, 02 Sep 2020 17:11:52 +0100
In-Reply-To: <20200902161007.GN1551@shell.armlinux.org.uk>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/7] net: mvpp2: ptp: add TAI support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kDVMV-0000jk-Ux@rmk-PC.armlinux.org.uk>
Date:   Wed, 02 Sep 2020 17:11:51 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the TAI block in the mvpp2.2 hardware.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/Kconfig          |   6 +
 drivers/net/ethernet/marvell/mvpp2/Makefile   |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    | 109 +++++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   4 +
 .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 416 ++++++++++++++++++
 5 files changed, 537 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index ef4f35ba077d..a599e44a36a8 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -92,6 +92,12 @@ config MVPP2
 	  This driver supports the network interface units in the
 	  Marvell ARMADA 375, 7K and 8K SoCs.
 
+config MVPP2_PTP
+	bool "Marvell Armada 8K Enable PTP support"
+	depends on NETWORK_PHY_TIMESTAMPING
+	depends on (PTP_1588_CLOCK = y && MVPP2 = y) || \
+		   (PTP_1588_CLOCK && MVPP2 = m)
+
 config PXA168_ETH
 	tristate "Marvell pxa168 ethernet support"
 	depends on HAS_IOMEM
diff --git a/drivers/net/ethernet/marvell/mvpp2/Makefile b/drivers/net/ethernet/marvell/mvpp2/Makefile
index 51f65a202c6e..9bd8e7964b40 100644
--- a/drivers/net/ethernet/marvell/mvpp2/Makefile
+++ b/drivers/net/ethernet/marvell/mvpp2/Makefile
@@ -4,4 +4,5 @@
 #
 obj-$(CONFIG_MVPP2) := mvpp2.o
 
-mvpp2-objs := mvpp2_main.o mvpp2_prs.o mvpp2_cls.o mvpp2_debugfs.o
+mvpp2-y := mvpp2_main.o mvpp2_prs.o mvpp2_cls.o mvpp2_debugfs.o
+mvpp2-$(CONFIG_MVPP2_PTP) += mvpp2_tai.o
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 273c46bbf927..b9fae3870393 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -505,6 +505,70 @@
 #define MVPP22_SMI_MISC_CFG_REG			0x1204
 #define     MVPP22_SMI_POLLING_EN		BIT(10)
 
+/* TAI registers, PPv2.2 only, relative to priv->iface_base */
+#define MVPP22_TAI_INT_CAUSE			0x1400
+#define MVPP22_TAI_INT_MASK			0x1404
+#define MVPP22_TAI_CR0				0x1408
+#define MVPP22_TAI_CR1				0x140c
+#define MVPP22_TAI_TCFCR0			0x1410
+#define MVPP22_TAI_TCFCR1			0x1414
+#define MVPP22_TAI_TCFCR2			0x1418
+#define MVPP22_TAI_FATWR			0x141c
+#define MVPP22_TAI_TOD_STEP_NANO_CR		0x1420
+#define MVPP22_TAI_TOD_STEP_FRAC_HIGH		0x1424
+#define MVPP22_TAI_TOD_STEP_FRAC_LOW		0x1428
+#define MVPP22_TAI_TAPDC_HIGH			0x142c
+#define MVPP22_TAI_TAPDC_LOW			0x1430
+#define MVPP22_TAI_TGTOD_SEC_HIGH		0x1434
+#define MVPP22_TAI_TGTOD_SEC_MED		0x1438
+#define MVPP22_TAI_TGTOD_SEC_LOW		0x143c
+#define MVPP22_TAI_TGTOD_NANO_HIGH		0x1440
+#define MVPP22_TAI_TGTOD_NANO_LOW		0x1444
+#define MVPP22_TAI_TGTOD_FRAC_HIGH		0x1448
+#define MVPP22_TAI_TGTOD_FRAC_LOW		0x144c
+#define MVPP22_TAI_TLV_SEC_HIGH			0x1450
+#define MVPP22_TAI_TLV_SEC_MED			0x1454
+#define MVPP22_TAI_TLV_SEC_LOW			0x1458
+#define MVPP22_TAI_TLV_NANO_HIGH		0x145c
+#define MVPP22_TAI_TLV_NANO_LOW			0x1460
+#define MVPP22_TAI_TLV_FRAC_HIGH		0x1464
+#define MVPP22_TAI_TLV_FRAC_LOW			0x1468
+#define MVPP22_TAI_TCV0_SEC_HIGH		0x146c
+#define MVPP22_TAI_TCV0_SEC_MED			0x1470
+#define MVPP22_TAI_TCV0_SEC_LOW			0x1474
+#define MVPP22_TAI_TCV0_NANO_HIGH		0x1478
+#define MVPP22_TAI_TCV0_NANO_LOW		0x147c
+#define MVPP22_TAI_TCV0_FRAC_HIGH		0x1480
+#define MVPP22_TAI_TCV0_FRAC_LOW		0x1484
+#define MVPP22_TAI_TCV1_SEC_HIGH		0x1488
+#define MVPP22_TAI_TCV1_SEC_MED			0x148c
+#define MVPP22_TAI_TCV1_SEC_LOW			0x1490
+#define MVPP22_TAI_TCV1_NANO_HIGH		0x1494
+#define MVPP22_TAI_TCV1_NANO_LOW		0x1498
+#define MVPP22_TAI_TCV1_FRAC_HIGH		0x149c
+#define MVPP22_TAI_TCV1_FRAC_LOW		0x14a0
+#define MVPP22_TAI_TCSR				0x14a4
+#define MVPP22_TAI_TUC_LSB			0x14a8
+#define MVPP22_TAI_GFM_SEC_HIGH			0x14ac
+#define MVPP22_TAI_GFM_SEC_MED			0x14b0
+#define MVPP22_TAI_GFM_SEC_LOW			0x14b4
+#define MVPP22_TAI_GFM_NANO_HIGH		0x14b8
+#define MVPP22_TAI_GFM_NANO_LOW			0x14bc
+#define MVPP22_TAI_GFM_FRAC_HIGH		0x14c0
+#define MVPP22_TAI_GFM_FRAC_LOW			0x14c4
+#define MVPP22_TAI_PCLK_DA_HIGH			0x14c8
+#define MVPP22_TAI_PCLK_DA_LOW			0x14cc
+#define MVPP22_TAI_CTCR				0x14d0
+#define MVPP22_TAI_PCLK_CCC_HIGH		0x14d4
+#define MVPP22_TAI_PCLK_CCC_LOW			0x14d8
+#define MVPP22_TAI_DTC_HIGH			0x14dc
+#define MVPP22_TAI_DTC_LOW			0x14e0
+#define MVPP22_TAI_CCC_HIGH			0x14e4
+#define MVPP22_TAI_CCC_LOW			0x14e8
+#define MVPP22_TAI_ICICE			0x14f4
+#define MVPP22_TAI_ICICC_LOW			0x14f8
+#define MVPP22_TAI_TUC_MSB			0x14fc
+
 #define MVPP22_GMAC_BASE(port)		(0x7000 + (port) * 0x1000 + 0xe00)
 
 #define MVPP2_CAUSE_TXQ_SENT_DESC_ALL_MASK	0xff
@@ -531,6 +595,39 @@
 #define     MVPP22_XPCS_CFG0_PCS_MODE(n)	((n) << 3)
 #define     MVPP22_XPCS_CFG0_ACTIVE_LANE(n)	((n) << 5)
 
+/* PTP registers. PPv2.2 only */
+#define MVPP22_PTP_BASE(port)			(0x7800 + (port * 0x1000))
+#define MVPP22_PTP_INT_CAUSE			0x00
+#define MVPP22_PTP_INT_MASK			0x04
+#define MVPP22_PTP_GCR				0x08
+#define MVPP22_PTP_TX_Q0_R0			0x0c
+#define MVPP22_PTP_TX_Q0_R1			0x10
+#define MVPP22_PTP_TX_Q0_R2			0x14
+#define MVPP22_PTP_TX_Q1_R0			0x18
+#define MVPP22_PTP_TX_Q1_R1			0x1c
+#define MVPP22_PTP_TX_Q1_R2			0x20
+#define MVPP22_PTP_TPCR				0x24
+#define MVPP22_PTP_V1PCR			0x28
+#define MVPP22_PTP_V2PCR			0x2c
+#define MVPP22_PTP_Y1731PCR			0x30
+#define MVPP22_PTP_NTPTSPCR			0x34
+#define MVPP22_PTP_NTPRXPCR			0x38
+#define MVPP22_PTP_NTPTXPCR			0x3c
+#define MVPP22_PTP_WAMPPCR			0x40
+#define MVPP22_PTP_NAPCR			0x44
+#define MVPP22_PTP_FAPCR			0x48
+#define MVPP22_PTP_CAPCR			0x50
+#define MVPP22_PTP_ATAPCR			0x54
+#define MVPP22_PTP_ACTAPCR			0x58
+#define MVPP22_PTP_CATAPCR			0x5c
+#define MVPP22_PTP_CACTAPCR			0x60
+#define MVPP22_PTP_AITAPCR			0x64
+#define MVPP22_PTP_CAITAPCR			0x68
+#define MVPP22_PTP_CITAPCR			0x6c
+#define MVPP22_PTP_NTP_OFF_HIGH			0x70
+#define MVPP22_PTP_NTP_OFF_LOW			0x74
+#define MVPP22_PTP_TX_PIPE_STATUS_DELAY		0x78
+
 /* System controller registers. Accessed through a regmap. */
 #define GENCONF_SOFT_RESET1				0x1108
 #define     GENCONF_SOFT_RESET1_GOP			BIT(6)
@@ -763,6 +860,8 @@ enum mvpp2_prs_l3_cast {
 
 #define MVPP2_DESC_DMA_MASK	DMA_BIT_MASK(40)
 
+struct mvpp2_tai;
+
 /* Definitions */
 struct mvpp2_dbgfs_entries;
 
@@ -798,6 +897,7 @@ struct mvpp2 {
 	/* List of pointers to port structures */
 	int port_count;
 	struct mvpp2_port *port_list[MVPP2_MAX_PORTS];
+	struct mvpp2_tai *tai;
 
 	/* Number of Tx threads used */
 	unsigned int nthreads;
@@ -1253,4 +1353,13 @@ void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name);
 
 void mvpp2_dbgfs_cleanup(struct mvpp2 *priv);
 
+#ifdef CONFIG_MVPP2_PTP
+int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv);
+#else
+static inline int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv)
+{
+	return 0;
+}
+#endif
+
 #endif
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9dc8cf3d0873..d064e4b20df0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6674,6 +6674,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 		goto err_axi_clk;
 	}
 
+	err = mvpp22_tai_probe(&pdev->dev, priv);
+	if (err < 0)
+		goto err_axi_clk;
+
 	/* Initialize ports */
 	fwnode_for_each_available_child_node(fwnode, port_fwnode) {
 		err = mvpp2_port_probe(pdev, port_fwnode, priv);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
new file mode 100644
index 000000000000..d6bc5d3f6110
--- /dev/null
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
@@ -0,0 +1,416 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Marvell PP2.2 TAI support
+ *
+ * Note:
+ *   Do NOT use the event capture support.
+ *   Do Not even set the MPP muxes to allow PTP_EVENT_REQ to be used.
+ *   It will disrupt the operation of this driver, and there is nothing
+ *   that this driver can do to prevent that.  Even using PTP_EVENT_REQ
+ *   as an output will be seen as a trigger input, which can't be masked.
+ *   When ever a trigger input is seen, the action in the TCFCR0_TCF
+ *   field will be performed - whether it is a set, increment, decrement
+ *   read, or frequency update.
+ *
+ * Other notes (useful, not specified in the documentation):
+ * - PTP_PULSE_OUT (PTP_EVENT_REQ MPP)
+ *   It looks like the hardware can't generate a pulse at nsec=0. (The
+ *   output doesn't trigger if the nsec field is zero.)
+ *   Note: when configured as an output via the register at 0xfX441120,
+ *   the input is still very much alive, and will trigger the current TCF
+ *   function.
+ * - PTP_CLK_OUT (PTP_TRIG_GEN MPP)
+ *   This generates a "PPS" signal determined by the CCC registers. It
+ *   seems this is not aligned to the TOD counter in any way (it may be
+ *   initially, but if you specify a non-round second interval, it won't,
+ *   and you can't easily get it back.)
+ * - PTP_PCLK_OUT
+ *   This generates a 50% duty cycle clock based on the TOD counter, and
+ *   seems it can be set to any period of 1ns resolution. It is probably
+ *   limited by the TOD step size. Its period is defined by the PCLK_CCC
+ *   registers. Again, its alignment to the second is questionable.
+ *
+ * Consequently, we support none of these.
+ */
+#include <linux/io.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/slab.h>
+
+#include "mvpp2.h"
+
+#define CR0_SW_NRESET			BIT(0)
+
+#define TCFCR0_PHASE_UPDATE_ENABLE	BIT(8)
+#define TCFCR0_TCF_MASK			(7 << 2)
+#define TCFCR0_TCF_UPDATE		(0 << 2)
+#define TCFCR0_TCF_FREQUPDATE		(1 << 2)
+#define TCFCR0_TCF_INCREMENT		(2 << 2)
+#define TCFCR0_TCF_DECREMENT		(3 << 2)
+#define TCFCR0_TCF_CAPTURE		(4 << 2)
+#define TCFCR0_TCF_NOP			(7 << 2)
+#define TCFCR0_TCF_TRIGGER		BIT(0)
+
+#define TCSR_CAPTURE_1_VALID		BIT(1)
+#define TCSR_CAPTURE_0_VALID		BIT(0)
+
+struct mvpp2_tai {
+	struct ptp_clock_info caps;
+	struct ptp_clock *ptp_clock;
+	void __iomem *base;
+	spinlock_t lock;
+	u64 period;		// nanosecond period in 32.32 fixed point
+};
+
+static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
+{
+	u32 val;
+
+	val = readl_relaxed(reg) & ~mask;
+	val |= set & mask;
+	writel(val, reg);
+}
+
+static void mvpp2_tai_write(u32 val, void __iomem *reg)
+{
+	writel_relaxed(val & 0xffff, reg);
+}
+
+static u32 mvpp2_tai_read(void __iomem *reg)
+{
+	return readl_relaxed(reg) & 0xffff;
+}
+
+static struct mvpp2_tai *ptp_to_tai(struct ptp_clock_info *ptp)
+{
+	return container_of(ptp, struct mvpp2_tai, caps);
+}
+
+static void mvpp22_tai_read_ts(struct timespec64 *ts, void __iomem *base)
+{
+	ts->tv_sec = (u64)mvpp2_tai_read(base + 0) << 32 |
+		     mvpp2_tai_read(base + 4) << 16 |
+		     mvpp2_tai_read(base + 8);
+
+	ts->tv_nsec = mvpp2_tai_read(base + 12) << 16 |
+		      mvpp2_tai_read(base + 16);
+
+	/* Read and discard fractional part */
+	readl_relaxed(base + 20);
+	readl_relaxed(base + 24);
+}
+
+static void mvpp2_tai_write_tlv(const struct timespec64 *ts, u32 frac,
+			        void __iomem *base)
+{
+	mvpp2_tai_write(ts->tv_sec >> 32, base + MVPP22_TAI_TLV_SEC_HIGH);
+	mvpp2_tai_write(ts->tv_sec >> 16, base + MVPP22_TAI_TLV_SEC_MED);
+	mvpp2_tai_write(ts->tv_sec, base + MVPP22_TAI_TLV_SEC_LOW);
+	mvpp2_tai_write(ts->tv_nsec >> 16, base + MVPP22_TAI_TLV_NANO_HIGH);
+	mvpp2_tai_write(ts->tv_nsec, base + MVPP22_TAI_TLV_NANO_LOW);
+	mvpp2_tai_write(frac >> 16, base + MVPP22_TAI_TLV_FRAC_HIGH);
+	mvpp2_tai_write(frac, base + MVPP22_TAI_TLV_FRAC_LOW);
+}
+
+static void mvpp2_tai_op(u32 op, void __iomem *base)
+{
+	/* Trigger the operation. Note that an external unmaskable
+	 * event on PTP_EVENT_REQ will also trigger this action.
+	 */
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
+			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
+			 op | TCFCR0_TCF_TRIGGER);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
+			 TCFCR0_TCF_NOP);
+}
+
+/* The adjustment has a range of +0.5ns to -0.5ns in 2^32 steps, so has units
+ * of 2^-32 ns.
+ *
+ * units(s) = 1 / (2^32 * 10^9)
+ * fractional = abs_scaled_ppm / (2^16 * 10^6)
+ *
+ * What we want to achieve:
+ *  freq_adjusted = freq_nominal * (1 + fractional)
+ *  freq_delta = freq_adjusted - freq_nominal => positive = faster
+ *  freq_delta = freq_nominal * (1 + fractional) - freq_nominal
+ * So: freq_delta = freq_nominal * fractional
+ *
+ * However, we are dealing with periods, so:
+ *  period_adjusted = period_nominal / (1 + fractional)
+ *  period_delta = period_nominal - period_adjusted => positive = faster
+ *  period_delta = period_nominal * fractional / (1 + fractional)
+ *
+ * Hence:
+ *  period_delta = period_nominal * abs_scaled_ppm /
+ *		   (2^16 * 10^6 + abs_scaled_ppm)
+ *
+ * To avoid overflow, we reduce both sides of the divide operation by a factor
+ * of 16.
+ */
+static u64 mvpp22_calc_frac_ppm(struct mvpp2_tai *tai, long abs_scaled_ppm)
+{
+	u64 val = tai->period * abs_scaled_ppm >> 4;
+
+	return div_u64(val, (1000000 << 12) + (abs_scaled_ppm >> 4));
+}
+
+static s32 mvpp22_calc_max_adj(struct mvpp2_tai *tai)
+{
+	return 1000000;
+}
+
+static int mvpp22_tai_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct mvpp2_tai *tai = ptp_to_tai(ptp);
+	unsigned long flags;
+	void __iomem *base;
+	bool neg_adj;
+	s32 frac;
+	u64 val;
+
+	neg_adj = scaled_ppm < 0;
+	if (neg_adj)
+		scaled_ppm = -scaled_ppm;
+
+	val = mvpp22_calc_frac_ppm(tai, scaled_ppm);
+
+	/* Convert to a signed 32-bit adjustment */
+	if (neg_adj) {
+		/* -S32_MIN warns, -val < S32_MIN fails, so go for the easy
+		 * solution.
+		 */
+		if (val > 0x80000000)
+			return -ERANGE;
+
+		frac = -val;
+	} else {
+		if (val > S32_MAX)
+			return -ERANGE;
+
+		frac = val;
+	}
+
+	base = tai->base;
+	spin_lock_irqsave(&tai->lock, flags);
+	mvpp2_tai_write(frac >> 16, base + MVPP22_TAI_TLV_FRAC_HIGH);
+	mvpp2_tai_write(frac, base + MVPP22_TAI_TLV_FRAC_LOW);
+	mvpp2_tai_op(TCFCR0_TCF_FREQUPDATE, base);
+	spin_unlock_irqrestore(&tai->lock, flags);
+
+	return 0;
+}
+
+static int mvpp22_tai_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct mvpp2_tai *tai = ptp_to_tai(ptp);
+	struct timespec64 ts;
+	unsigned long flags;
+	void __iomem *base;
+	u32 tcf;
+
+	/* We can't deal with S64_MIN */
+	if (delta == S64_MIN)
+		return -ERANGE;
+
+	if (delta < 0) {
+		delta = -delta;
+		tcf = TCFCR0_TCF_DECREMENT;
+	} else {
+		tcf = TCFCR0_TCF_INCREMENT;
+	}
+
+	ts = ns_to_timespec64(delta);
+
+	base = tai->base;
+	spin_lock_irqsave(&tai->lock, flags);
+	mvpp2_tai_write_tlv(&ts, 0, base);
+	mvpp2_tai_op(tcf, base);
+	spin_unlock_irqrestore(&tai->lock, flags);
+
+	return 0;
+}
+
+static int mvpp22_tai_gettimex64(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts,
+				 struct ptp_system_timestamp *sts)
+{
+	struct mvpp2_tai *tai = ptp_to_tai(ptp);
+	unsigned long flags;
+	void __iomem *base;
+	u32 tcsr;
+	int ret;
+
+	base = tai->base;
+	spin_lock_irqsave(&tai->lock, flags);
+	/* XXX: the only way to read the PTP time is for the CPU to trigger
+	 * an event. However, there is no way to distinguish between the CPU
+	 * triggered event, and an external event on PTP_EVENT_REQ. So this
+	 * is incompatible with external use of PTP_EVENT_REQ.
+	 */
+	ptp_read_system_prets(sts);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
+			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
+			 TCFCR0_TCF_CAPTURE | TCFCR0_TCF_TRIGGER);
+	ptp_read_system_postts(sts);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
+			 TCFCR0_TCF_NOP);
+
+	tcsr = readl(base + MVPP22_TAI_TCSR);
+	if (tcsr & TCSR_CAPTURE_1_VALID) {
+		mvpp22_tai_read_ts(ts, base + MVPP22_TAI_TCV1_SEC_HIGH);
+		ret = 0;
+	} else if (tcsr & TCSR_CAPTURE_0_VALID) {
+		mvpp22_tai_read_ts(ts, base + MVPP22_TAI_TCV0_SEC_HIGH);
+		ret = 0;
+	} else {
+		/* We don't seem to have a reading... */
+		ret = -EBUSY;
+	}
+	spin_unlock_irqrestore(&tai->lock, flags);
+
+	return ret;
+}
+
+static int mvpp22_tai_settime64(struct ptp_clock_info *ptp,
+				const struct timespec64 *ts)
+{
+	struct mvpp2_tai *tai = ptp_to_tai(ptp);
+	unsigned long flags;
+	void __iomem *base;
+
+	base = tai->base;
+	spin_lock_irqsave(&tai->lock, flags);
+	mvpp2_tai_write_tlv(ts, 0, base);
+
+	/* Trigger an update to load the value from the TLV registers
+	 * into the TOD counter. Note that an external unmaskable event on
+	 * PTP_EVENT_REQ will also trigger this action.
+	 */
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
+			 TCFCR0_PHASE_UPDATE_ENABLE |
+			 TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
+			 TCFCR0_TCF_UPDATE | TCFCR0_TCF_TRIGGER);
+	mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
+			 TCFCR0_TCF_NOP);
+	spin_unlock_irqrestore(&tai->lock, flags);
+
+	return 0;
+}
+
+static long mvpp22_tai_aux_work(struct ptp_clock_info *ptp)
+{
+	return 0;
+}
+
+static void mvpp22_tai_set_step(struct mvpp2_tai *tai)
+{
+	void __iomem *base = tai->base;
+	u32 nano, frac;
+
+	nano = upper_32_bits(tai->period);
+	frac = lower_32_bits(tai->period);
+
+	/* As the fractional nanosecond is a signed offset, if the MSB (sign)
+	 * bit is set, we have to increment the whole nanoseconds.
+	 */
+	if (frac >= 0x80000000)
+		nano += 1;
+
+	mvpp2_tai_write(nano, base + MVPP22_TAI_TOD_STEP_NANO_CR);
+	mvpp2_tai_write(frac >> 16, base + MVPP22_TAI_TOD_STEP_FRAC_HIGH);
+	mvpp2_tai_write(frac, base + MVPP22_TAI_TOD_STEP_FRAC_LOW);
+}
+
+static void mvpp22_tai_set_tod(struct mvpp2_tai *tai)
+{
+	struct timespec64 now;
+
+	ktime_get_real_ts64(&now);
+	mvpp22_tai_settime64(&tai->caps, &now);
+}
+
+static void mvpp22_tai_init(struct mvpp2_tai *tai)
+{
+	void __iomem *base = tai->base;
+
+	mvpp22_tai_set_step(tai);
+
+	/* Release the TAI reset */
+	mvpp2_tai_modify(base + MVPP22_TAI_CR0, CR0_SW_NRESET, CR0_SW_NRESET);
+
+	mvpp22_tai_set_tod(tai);
+}
+
+static void mvpp22_tai_remove(void *priv)
+{
+	struct mvpp2_tai *tai = priv;
+
+	if (!IS_ERR(tai->ptp_clock))
+		ptp_clock_unregister(tai->ptp_clock);
+}
+
+int mvpp22_tai_probe(struct device *dev, struct mvpp2 *priv)
+{
+	struct mvpp2_tai *tai;
+	int ret;
+
+	tai = devm_kzalloc(dev, sizeof(*tai), GFP_KERNEL);
+	if (!tai)
+		return -ENOMEM;
+
+	spin_lock_init(&tai->lock);
+
+	tai->base = priv->iface_base;
+
+	/* The step size consists of three registers - a 16-bit nanosecond step
+	 * size, and a 32-bit fractional nanosecond step size split over two
+	 * registers. The fractional nanosecond step size has units of 2^-32ns.
+	 *
+	 * To calculate this, we calculate:
+	 *   (10^9 + freq / 2) / (freq * 2^-32)
+	 * which gives us the nanosecond step to the nearest integer in 16.32
+	 * fixed point format, and the fractional part of the step size with
+	 * the MSB inverted.  With rounding of the fractional nanosecond, and
+	 * simplification, this becomes:
+	 *   (10^9 << 32 + freq << 31 + (freq + 1) >> 1) / freq
+	 *
+	 * So:
+	 *   div = (10^9 << 32 + freq << 31 + (freq + 1) >> 1) / freq
+	 *   nano = upper_32_bits(div);
+	 *   frac = lower_32_bits(div) ^ 0x80000000;
+	 * Will give the values for the registers.
+	 *
+	 * This is all seems perfect, but alas it is not when considering the
+	 * whole story.  The system is clocked from 25MHz, which is multiplied
+	 * by a PLL to 1GHz, and then divided by three, giving 333333333Hz
+	 * (recurring).  This gives exactly 3ns, but using 333333333Hz with
+	 * the above gives an error of 13*2^-32ns.
+	 *
+	 * Consequently, we use the period rather than calculating from the
+	 * frequency.
+	 */
+	tai->period = 3ULL << 32;
+
+	mvpp22_tai_init(tai);
+
+	tai->caps.owner = THIS_MODULE;
+	strscpy(tai->caps.name, "Marvell PP2.2", sizeof(tai->caps.name));
+	tai->caps.max_adj = mvpp22_calc_max_adj(tai);
+	tai->caps.adjfine = mvpp22_tai_adjfine;
+	tai->caps.adjtime = mvpp22_tai_adjtime;
+	tai->caps.gettimex64 = mvpp22_tai_gettimex64;
+	tai->caps.settime64 = mvpp22_tai_settime64;
+	tai->caps.do_aux_work = mvpp22_tai_aux_work;
+
+	ret = devm_add_action(dev, mvpp22_tai_remove, tai);
+	if (ret)
+		return ret;
+
+	tai->ptp_clock = ptp_clock_register(&tai->caps, dev);
+	if (IS_ERR(tai->ptp_clock))
+		return PTR_ERR(tai->ptp_clock);
+
+	priv->tai = tai;
+
+	return 0;
+}
-- 
2.20.1

