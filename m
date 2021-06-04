Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8469539C34B
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhFDWME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 18:12:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:24251 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhFDWLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 18:11:55 -0400
IronPort-SDR: y3h0hWzdrlOmY/ZCoyTmCcWgrggccsyHggng1JHGGwu9AU54TNXdTTCC8bv34IHOskx8JGuojm
 kvg8J6Y6JctQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="290007352"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="290007352"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 15:10:07 -0700
IronPort-SDR: SyXVR0zAfMFjQyJvLHIYVCJHGvLzx2Qqohv9LhNRxZv/q0T+6krwG/nLOmEzvUVmtCzOwU+yT1
 tGUkGok+kgnA==
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="439326630"
Received: from lmrivera-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.24.65])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 15:10:06 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com, hch@infradead.org, helgaas@kernel.org
Subject: [PATCH next-queue v4 4/4] igc: Add support for PTP getcrosststamp()
Date:   Fri,  4 Jun 2021 15:09:33 -0700
Message-Id: <20210604220933.3974558-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604220933.3974558-1-vinicius.gomes@intel.com>
References: <20210604220933.3974558-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i225 has support for PCIe PTM, which allows us to implement support
for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
the getcrosststamp() function.

The easiest way to expose the PTM registers would be to configure the PTM
dialogs to run periodically, but the PTP_SYS_OFFSET_PRECISE ioctl()
semantics are more aligned to using a kind of "one-shot" way of retrieving
the PTM timestamps. But this causes a bit more code to be written: the
trigger registers for the PTM dialogs are not cleared automatically.

i225 can be configured to send "fake" packets with the PTM
information, adding support for handling these types of packets is
left for the future.

PTM improves the accuracy of time synchronization, for example, using
phc2sys. Before:

phc2sys[341.511]: CLOCK_REALTIME phc offset       289 s2 freq    +961 delay   2963
phc2sys[342.511]: CLOCK_REALTIME phc offset      -984 s2 freq    -225 delay   3517
phc2sys[343.511]: CLOCK_REALTIME phc offset       427 s2 freq    +891 delay   2312
phc2sys[344.511]: CLOCK_REALTIME phc offset       104 s2 freq    +696 delay   2575
phc2sys[345.511]: CLOCK_REALTIME phc offset       149 s2 freq    +772 delay   2388
phc2sys[346.511]: CLOCK_REALTIME phc offset        33 s2 freq    +701 delay   2359
phc2sys[347.511]: CLOCK_REALTIME phc offset      -216 s2 freq    +462 delay   2706
phc2sys[348.512]: CLOCK_REALTIME phc offset       140 s2 freq    +753 delay   2300
phc2sys[349.512]: CLOCK_REALTIME phc offset       -14 s2 freq    +641 delay   2385
phc2sys[350.512]: CLOCK_REALTIME phc offset      1048 s2 freq   +1699 delay   4303
phc2sys[351.512]: CLOCK_REALTIME phc offset     -1296 s2 freq    -331 delay   2846
phc2sys[352.512]: CLOCK_REALTIME phc offset      -912 s2 freq    -336 delay   4006
phc2sys[353.512]: CLOCK_REALTIME phc offset       880 s2 freq   +1183 delay   2338
phc2sys[354.512]: CLOCK_REALTIME phc offset       358 s2 freq    +925 delay   2348
phc2sys[355.512]: CLOCK_REALTIME phc offset      -211 s2 freq    +463 delay   2941
phc2sys[356.512]: CLOCK_REALTIME phc offset       234 s2 freq    +845 delay   2519
phc2sys[357.512]: CLOCK_REALTIME phc offset        45 s2 freq    +726 delay   2357
phc2sys[358.512]: CLOCK_REALTIME phc offset      -262 s2 freq    +433 delay   2821
phc2sys[359.512]: CLOCK_REALTIME phc offset      -424 s2 freq    +192 delay   3579
phc2sys[360.513]: CLOCK_REALTIME phc offset       134 s2 freq    +623 delay   3269
phc2sys[361.513]: CLOCK_REALTIME phc offset      -213 s2 freq    +316 delay   3999
phc2sys[362.513]: CLOCK_REALTIME phc offset      1023 s2 freq   +1488 delay   2614
phc2sys[363.513]: CLOCK_REALTIME phc offset        57 s2 freq    +829 delay   2332
phc2sys[364.513]: CLOCK_REALTIME phc offset      -126 s2 freq    +663 delay   2315
phc2sys[365.513]: CLOCK_REALTIME phc offset       -85 s2 freq    +666 delay   2449
phc2sys[366.513]: CLOCK_REALTIME phc offset      -193 s2 freq    +533 delay   2336
phc2sys[367.513]: CLOCK_REALTIME phc offset      -645 s2 freq     +23 delay   3870
phc2sys[368.513]: CLOCK_REALTIME phc offset       483 s2 freq    +957 delay   2342
phc2sys[369.513]: CLOCK_REALTIME phc offset      -166 s2 freq    +453 delay   3025
phc2sys[370.513]: CLOCK_REALTIME phc offset       327 s2 freq    +896 delay   2250

After:

phc2sys[617.838]: CLOCK_REALTIME phc offset       -25 s2 freq    +309 delay      0
phc2sys[618.838]: CLOCK_REALTIME phc offset       -43 s2 freq    +284 delay      0
phc2sys[619.838]: CLOCK_REALTIME phc offset       -12 s2 freq    +302 delay      0
phc2sys[620.838]: CLOCK_REALTIME phc offset        -2 s2 freq    +308 delay      0
phc2sys[621.838]: CLOCK_REALTIME phc offset        30 s2 freq    +340 delay      0
phc2sys[622.838]: CLOCK_REALTIME phc offset        14 s2 freq    +333 delay      0
phc2sys[623.839]: CLOCK_REALTIME phc offset        -3 s2 freq    +320 delay      0
phc2sys[624.839]: CLOCK_REALTIME phc offset         9 s2 freq    +331 delay      0
phc2sys[625.839]: CLOCK_REALTIME phc offset        -1 s2 freq    +324 delay      0
phc2sys[626.839]: CLOCK_REALTIME phc offset        -6 s2 freq    +318 delay      0
phc2sys[627.839]: CLOCK_REALTIME phc offset       -10 s2 freq    +313 delay      0
phc2sys[628.839]: CLOCK_REALTIME phc offset         7 s2 freq    +327 delay      0
phc2sys[629.839]: CLOCK_REALTIME phc offset         8 s2 freq    +330 delay      0
phc2sys[630.840]: CLOCK_REALTIME phc offset       -24 s2 freq    +300 delay      0
phc2sys[631.840]: CLOCK_REALTIME phc offset       -49 s2 freq    +268 delay      0
phc2sys[632.840]: CLOCK_REALTIME phc offset         6 s2 freq    +308 delay      0
phc2sys[633.840]: CLOCK_REALTIME phc offset        25 s2 freq    +329 delay      0
phc2sys[634.840]: CLOCK_REALTIME phc offset         5 s2 freq    +316 delay      0
phc2sys[635.840]: CLOCK_REALTIME phc offset        10 s2 freq    +323 delay      0
phc2sys[636.840]: CLOCK_REALTIME phc offset       -13 s2 freq    +303 delay      0
phc2sys[637.841]: CLOCK_REALTIME phc offset         4 s2 freq    +316 delay      0
phc2sys[638.841]: CLOCK_REALTIME phc offset        16 s2 freq    +329 delay      0
phc2sys[639.841]: CLOCK_REALTIME phc offset        31 s2 freq    +349 delay      0
phc2sys[640.841]: CLOCK_REALTIME phc offset       -21 s2 freq    +306 delay      0
phc2sys[641.841]: CLOCK_REALTIME phc offset       -14 s2 freq    +307 delay      0
phc2sys[642.841]: CLOCK_REALTIME phc offset       -24 s2 freq    +293 delay      0
phc2sys[643.841]: CLOCK_REALTIME phc offset        -6 s2 freq    +304 delay      0
phc2sys[644.842]: CLOCK_REALTIME phc offset        12 s2 freq    +320 delay      0
phc2sys[645.842]: CLOCK_REALTIME phc offset        12 s2 freq    +323 delay      0
phc2sys[646.842]: CLOCK_REALTIME phc offset       -12 s2 freq    +303 delay      0

One possible explanation is that when PTM is not enabled, and there's a lot
of traffic in the PCIe fabric, some register reads will take more time than
the others (see the variation in the delay values "before").

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  31 ++++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 182 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  23 +++
 4 files changed, 237 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 71100ee7afbe..e46f81572e4c 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -225,6 +225,7 @@ struct igc_adapter {
 	struct timecounter tc;
 	struct timespec64 prev_ptp_time; /* Pre-reset PTP clock */
 	ktime_t ptp_reset_start; /* Reset time in clock mono */
+	struct system_time_snapshot snapshot;
 
 	char fw_version[32];
 
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 334d28138fc0..a34cb9ef6372 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -477,6 +477,37 @@
 #define IGC_RXCSUM_CRCOFL	0x00000800   /* CRC32 offload enable */
 #define IGC_RXCSUM_PCSD		0x00002000   /* packet checksum disabled */
 
+/* PCIe PTM Control */
+#define IGC_PTM_CTRL_START_NOW	BIT(29) /* Start PTM Now */
+#define IGC_PTM_CTRL_EN		BIT(30) /* Enable PTM */
+#define IGC_PTM_CTRL_TRIG	BIT(31) /* PTM Cycle trigger */
+#define IGC_PTM_CTRL_SHRT_CYC(usec)	(((usec) & 0x2f) << 2)
+#define IGC_PTM_CTRL_PTM_TO(usec)	(((usec) & 0xff) << 8)
+
+#define IGC_PTM_SHORT_CYC_DEFAULT	10  /* Default Short/interrupted cycle interval */
+#define IGC_PTM_CYC_TIME_DEFAULT	5   /* Default PTM cycle time */
+#define IGC_PTM_TIMEOUT_DEFAULT		255 /* Default timeout for PTM errors */
+
+/* PCIe Digital Delay */
+#define IGC_PCIE_DIG_DELAY_DEFAULT	0x01440000
+
+/* PCIe PHY Delay */
+#define IGC_PCIE_PHY_DELAY_DEFAULT	0x40900000
+
+#define IGC_TIMADJ_ADJUST_METH		0x40000000
+
+/* PCIe PTM Status */
+#define IGC_PTM_STAT_VALID		BIT(0) /* PTM Status */
+#define IGC_PTM_STAT_RET_ERR		BIT(1) /* Root port timeout */
+#define IGC_PTM_STAT_BAD_PTM_RES	BIT(2) /* PTM Response msg instead of PTM Response Data */
+#define IGC_PTM_STAT_T4M1_OVFL		BIT(3) /* T4 minus T1 overflow */
+#define IGC_PTM_STAT_ADJUST_1ST		BIT(4) /* 1588 timer adjusted during 1st PTM cycle */
+#define IGC_PTM_STAT_ADJUST_CYC		BIT(5) /* 1588 timer adjusted during non-1st PTM cycle */
+
+/* PCIe PTM Cycle Control */
+#define IGC_PTM_CYCLE_CTRL_CYC_TIME(msec)	((msec) & 0x3ff) /* PTM Cycle Time (msec) */
+#define IGC_PTM_CYCLE_CTRL_AUTO_CYC_EN		BIT(31) /* PTM Cycle Control */
+
 /* GPY211 - I225 defines */
 #define GPY_MMD_MASK		0xFFFF0000
 #define GPY_MMD_SHIFT		16
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 69617d2c1be2..1683b2f7cc8c 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -9,6 +9,8 @@
 #include <linux/ptp_classify.h>
 #include <linux/clocksource.h>
 #include <linux/ktime.h>
+#include <linux/delay.h>
+#include <linux/iopoll.h>
 
 #define INCVALUE_MASK		0x7fffffff
 #define ISGN			0x80000000
@@ -16,6 +18,9 @@
 #define IGC_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 9)
 #define IGC_PTP_TX_TIMEOUT		(HZ * 15)
 
+#define IGC_PTM_STAT_SLEEP		2
+#define IGC_PTM_STAT_TIMEOUT		100
+
 /* SYSTIM read access for I225 */
 void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts)
 {
@@ -752,6 +757,150 @@ int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr)
 		-EFAULT : 0;
 }
 
+/* Support for cross timestamping via PCIe PTM is only supported if
+ * two conditions are met:
+ *
+ * 1. We have an way to convert the timestamps in the PTM messages
+ *    to something related to the system clocks (right now, only
+ *    X86 systems with support for the Always Running Timer allow that);
+ *
+ * 2. We have PTM enabled in the path from the device to the PCIe root port.
+ */
+static bool igc_is_crosststamp_supported(struct igc_adapter *adapter)
+{
+#if IS_ENABLED(CONFIG_X86_TSC)
+	return pcie_ptm_enabled(adapter->pdev);
+#endif
+	return false;
+}
+
+static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
+{
+#if IS_ENABLED(CONFIG_X86_TSC)
+	return convert_art_ns_to_tsc(tstamp);
+#else
+	return (struct system_counterval_t) { };
+#endif
+}
+
+static void igc_ptm_log_error(struct igc_adapter *adapter, u32 ptm_stat)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	switch (ptm_stat) {
+	case IGC_PTM_STAT_RET_ERR:
+		netdev_err(netdev, "PTM Error: Root port timeout\n");
+		break;
+	case IGC_PTM_STAT_BAD_PTM_RES:
+		netdev_err(netdev, "PTM Error: Bad response, PTM Response Data expected\n");
+		break;
+	case IGC_PTM_STAT_T4M1_OVFL:
+		netdev_err(netdev, "PTM Error: T4 minus T1 overflow\n");
+		break;
+	case IGC_PTM_STAT_ADJUST_1ST:
+		netdev_err(netdev, "PTM Error: 1588 timer adjusted during first PTM cycle\n");
+		break;
+	case IGC_PTM_STAT_ADJUST_CYC:
+		netdev_err(netdev, "PTM Error: 1588 timer adjusted during non-first PTM cycle\n");
+		break;
+	default:
+		netdev_err(netdev, "PTM Error: Unknown error (%#x)\n", ptm_stat);
+		break;
+	}
+}
+
+static int igc_phc_get_syncdevicetime(ktime_t *device,
+				      struct system_counterval_t *system,
+				      void *ctx)
+{
+	struct igc_adapter *adapter = ctx;
+	struct igc_hw *hw = &adapter->hw;
+	u32 stat, t2_curr_h, t2_curr_l, ctrl;
+	u32 t4mt1_prev, t3mt2_prev, delay;
+	ktime_t t1, t2_curr;
+	int err;
+
+	/* Get a snapshot of system clocks to use as historic value. */
+	ktime_get_snapshot(&adapter->snapshot);
+
+	do {
+		/* Doing this in a loop because in the event of a
+		 * badly timed (ha!) system clock adjustment, we may
+		 * get PTM Errors from the PCI root, but these errors
+		 * are transitory. Repeating the process returns valid
+		 * data eventually.
+		 */
+
+		/* To "manually" start the PTM cycle we need to clear and
+		 * then set again the TRIG bit.
+		 */
+		ctrl = rd32(IGC_PTM_CTRL);
+		ctrl &= ~IGC_PTM_CTRL_TRIG;
+		wr32(IGC_PTM_CTRL, ctrl);
+		ctrl |= IGC_PTM_CTRL_TRIG;
+		wr32(IGC_PTM_CTRL, ctrl);
+
+		/* The cycle only starts "for real" when software notifies
+		 * that it has read the registers, this is done by setting
+		 * VALID bit.
+		 */
+		wr32(IGC_PTM_STAT, IGC_PTM_STAT_VALID);
+
+		err = readx_poll_timeout(rd32, IGC_PTM_STAT, stat,
+					 stat, IGC_PTM_STAT_SLEEP,
+					 IGC_PTM_STAT_TIMEOUT);
+		if (err < 0)
+			return err;
+
+		if ((stat & IGC_PTM_STAT_VALID) == IGC_PTM_STAT_VALID)
+			break;
+
+		if (stat & ~IGC_PTM_STAT_VALID) {
+			/* An error occurred, log it. */
+			igc_ptm_log_error(adapter, stat);
+			/* The STAT register is write-1-to-clear (W1C),
+			 * so write the previous error status to clear it.
+			 */
+			wr32(IGC_PTM_STAT, stat);
+			continue;
+		}
+	} while (true);
+
+	t1 = ktime_set(rd32(IGC_PTM_T1_TIM0_H),
+		       rd32(IGC_PTM_T1_TIM0_L));
+
+	t2_curr_l = rd32(IGC_PTM_CURR_T2_L);
+	t2_curr_h = rd32(IGC_PTM_CURR_T2_H);
+
+	/* FIXME: When the register that tells the endianness of the
+	 * PTM registers are implemented, check them here and add the
+	 * appropriate conversion.
+	 */
+	t2_curr_h = swab32(t2_curr_h);
+
+	t2_curr = ((s64)t2_curr_h << 32 | t2_curr_l);
+
+	t4mt1_prev = rd32(IGC_PTM_PREV_T4M1);
+	t3mt2_prev = rd32(IGC_PTM_PREV_T3M2);
+
+	delay = (t4mt1_prev - t3mt2_prev) / 2;
+
+	*device = t1 + delay;
+	*system = igc_device_tstamp_to_system(t2_curr);
+
+	return 0;
+}
+
+static int igc_ptp_getcrosststamp(struct ptp_clock_info *ptp,
+				  struct system_device_crosststamp *cts)
+{
+	struct igc_adapter *adapter = container_of(ptp, struct igc_adapter,
+						   ptp_caps);
+
+	return get_device_system_crosststamp(igc_phc_get_syncdevicetime,
+					     adapter, &adapter->snapshot, cts);
+}
+
 /**
  * igc_ptp_init - Initialize PTP functionality
  * @adapter: Board private structure
@@ -788,6 +937,11 @@ void igc_ptp_init(struct igc_adapter *adapter)
 		adapter->ptp_caps.n_per_out = IGC_N_PEROUT;
 		adapter->ptp_caps.n_pins = IGC_N_SDP;
 		adapter->ptp_caps.verify = igc_ptp_verify_pin;
+
+		if (!igc_is_crosststamp_supported(adapter))
+			break;
+
+		adapter->ptp_caps.getcrosststamp = igc_ptp_getcrosststamp;
 		break;
 	default:
 		adapter->ptp_clock = NULL;
@@ -878,7 +1032,9 @@ void igc_ptp_stop(struct igc_adapter *adapter)
 void igc_ptp_reset(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
+	u32 cycle_ctrl, ctrl;
 	unsigned long flags;
+	u32 timadj;
 
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
@@ -887,12 +1043,38 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 
 	switch (adapter->hw.mac.type) {
 	case igc_i225:
+		timadj = rd32(IGC_TIMADJ);
+		timadj |= IGC_TIMADJ_ADJUST_METH;
+		wr32(IGC_TIMADJ, timadj);
+
 		wr32(IGC_TSAUXC, 0x0);
 		wr32(IGC_TSSDP, 0x0);
 		wr32(IGC_TSIM,
 		     IGC_TSICR_INTERRUPTS |
 		     (adapter->pps_sys_wrap_on ? IGC_TSICR_SYS_WRAP : 0));
 		wr32(IGC_IMS, IGC_IMS_TS);
+
+		if (!igc_is_crosststamp_supported(adapter))
+			break;
+
+		wr32(IGC_PCIE_DIG_DELAY, IGC_PCIE_DIG_DELAY_DEFAULT);
+		wr32(IGC_PCIE_PHY_DELAY, IGC_PCIE_PHY_DELAY_DEFAULT);
+
+		cycle_ctrl = IGC_PTM_CYCLE_CTRL_CYC_TIME(IGC_PTM_CYC_TIME_DEFAULT);
+
+		wr32(IGC_PTM_CYCLE_CTRL, cycle_ctrl);
+
+		ctrl = IGC_PTM_CTRL_EN |
+			IGC_PTM_CTRL_START_NOW |
+			IGC_PTM_CTRL_SHRT_CYC(IGC_PTM_SHORT_CYC_DEFAULT) |
+			IGC_PTM_CTRL_PTM_TO(IGC_PTM_TIMEOUT_DEFAULT) |
+			IGC_PTM_CTRL_TRIG;
+
+		wr32(IGC_PTM_CTRL, ctrl);
+
+		/* Force the first cycle to run. */
+		wr32(IGC_PTM_STAT, IGC_PTM_STAT_VALID);
+
 		break;
 	default:
 		/* No work to do. */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 2491d565d758..fe062220a627 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -228,6 +228,29 @@
 #define IGC_TXSTMPL	0x0B618  /* Tx timestamp value Low - RO */
 #define IGC_TXSTMPH	0x0B61C  /* Tx timestamp value High - RO */
 
+#define IGC_TIMADJ	0x0B60C  /* Time Adjustment Offset Register */
+
+/* PCIe Registers */
+#define IGC_PTM_CTRL		0x12540  /* PTM Control */
+#define IGC_PTM_STAT		0x12544  /* PTM Status */
+#define IGC_PTM_CYCLE_CTRL	0x1254C  /* PTM Cycle Control */
+
+/* PTM Time registers */
+#define IGC_PTM_T1_TIM0_L	0x12558  /* T1 on Timer 0 Low */
+#define IGC_PTM_T1_TIM0_H	0x1255C  /* T1 on Timer 0 High */
+
+#define IGC_PTM_CURR_T2_L	0x1258C  /* Current T2 Low */
+#define IGC_PTM_CURR_T2_H	0x12590  /* Current T2 High */
+#define IGC_PTM_PREV_T2_L	0x12584  /* Previous T2 Low */
+#define IGC_PTM_PREV_T2_H	0x12588  /* Previous T2 High */
+#define IGC_PTM_PREV_T4M1	0x12578  /* T4 Minus T1 on previous PTM Cycle */
+#define IGC_PTM_CURR_T4M1	0x1257C  /* T4 Minus T1 on this PTM Cycle */
+#define IGC_PTM_PREV_T3M2	0x12580  /* T3 Minus T2 on previous PTM Cycle */
+#define IGC_PTM_TDELAY		0x12594  /* PTM PCIe Link Delay */
+
+#define IGC_PCIE_DIG_DELAY	0x12550  /* PCIe Digital Delay */
+#define IGC_PCIE_PHY_DELAY	0x12554  /* PCIe PHY Delay */
+
 /* Management registers */
 #define IGC_MANC	0x05820  /* Management Control - RW */
 
-- 
2.31.1

