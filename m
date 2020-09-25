Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC182794BF
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgIYX3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:29:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:29548 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgIYX3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:29:21 -0400
IronPort-SDR: DPq6XAk9XfSAXqYiq+s5VsA1uMbzJrYam/hau3B41bI0mOVH5Xt8O1ICPb+NanLnr0XQmqMw7r
 0tbCAlqI/3/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="149433240"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="149433240"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 16:29:19 -0700
IronPort-SDR: emaB43ZSkGFbD2CV/y90x8RRKbPoRu/tIgFkDgfPCVVRbw3UvqTYyaH3ev1MCWryVxbcZlbrYj
 gTjN15n1S97Q==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="337051741"
Received: from msbergin-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.110.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 16:29:16 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, andre.guedes@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org
Subject: [PATCH next-queue v1 3/3] igc: Add support for PTP getcrosststamp()
Date:   Fri, 25 Sep 2020 16:28:34 -0700
Message-Id: <20200925232834.2704711-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925232834.2704711-1-vinicius.gomes@intel.com>
References: <20200925232834.2704711-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i225 has support for PCIe PTM, which allows us to implement support
for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
the getcrosststamp() function.

Support is added by having a delayed workqueue that checks if the
current PTM cycle has finished and if it has finished, it stores the
needed information to be retrieved by the next execution of the
getcrosststamp() call. This is needed because it might be need to
interpolate the values, which need two set of timestamps (the current
and the historic).

i225 can be configured to send "fake" packets with the PTM
information, adding support for handling these types of packets is
left for the future.

PTM improves the accuracy of time synchronization, for example, using
phc2sys. Before:

phc2sys[67.920]: CLOCK_REALTIME phc offset        13 s2 freq  -11949 delay   2458
phc2sys[68.170]: CLOCK_REALTIME phc offset        21 s2 freq  -11937 delay   2473
phc2sys[68.420]: CLOCK_REALTIME phc offset        22 s2 freq  -11930 delay   2457
phc2sys[68.670]: CLOCK_REALTIME phc offset        18 s2 freq  -11927 delay   2479
phc2sys[68.920]: CLOCK_REALTIME phc offset        12 s2 freq  -11928 delay   2435
phc2sys[69.170]: CLOCK_REALTIME phc offset        -3 s2 freq  -11939 delay   2465
phc2sys[69.421]: CLOCK_REALTIME phc offset        -9 s2 freq  -11946 delay   2466
phc2sys[69.671]: CLOCK_REALTIME phc offset        -7 s2 freq  -11947 delay   2478
phc2sys[69.921]: CLOCK_REALTIME phc offset        -6 s2 freq  -11948 delay   2468
phc2sys[70.171]: CLOCK_REALTIME phc offset        -7 s2 freq  -11951 delay   2463
phc2sys[70.421]: CLOCK_REALTIME phc offset       -12 s2 freq  -11958 delay   2444

After:

phc2sys[224.311]: CLOCK_REALTIME phc offset         6 s2 freq  -11982 delay      0
phc2sys[224.561]: CLOCK_REALTIME phc offset         8 s2 freq  -11978 delay      0
phc2sys[224.811]: CLOCK_REALTIME phc offset         6 s2 freq  -11978 delay      0
phc2sys[225.061]: CLOCK_REALTIME phc offset        -1 s2 freq  -11983 delay      0
phc2sys[225.311]: CLOCK_REALTIME phc offset         3 s2 freq  -11980 delay      0
phc2sys[225.561]: CLOCK_REALTIME phc offset         4 s2 freq  -11978 delay      0
phc2sys[225.811]: CLOCK_REALTIME phc offset        -2 s2 freq  -11982 delay      0
phc2sys[226.061]: CLOCK_REALTIME phc offset        -3 s2 freq  -11984 delay      0
phc2sys[226.311]: CLOCK_REALTIME phc offset         0 s2 freq  -11982 delay      0
phc2sys[226.562]: CLOCK_REALTIME phc offset        -4 s2 freq  -11986 delay      0
phc2sys[226.812]: CLOCK_REALTIME phc offset        -9 s2 freq  -11992 delay      0
phc2sys[227.062]: CLOCK_REALTIME phc offset         1 s2 freq  -11985 delay      0

TODO/Questions:
 1. Using convert_art_ns_to_tsc() is too X86 specific, there should be a
    common way to create a 'system_counterval_t' from a timestamp.

 2. convert_art_ns_to_tsc() says that it should only be used when
    X86_FEATURE_TSC_KNOWN_FREQ is true, but during tests it works even
    when it returns false. Should that check be done?

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |   7 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  22 +++
 drivers/net/ethernet/intel/igc/igc_main.c    |   2 +
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 166 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  23 +++
 5 files changed, 220 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 35baae900c1f..83d59b08e883 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -13,6 +13,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/net_tstamp.h>
+#include <linux/timekeeping.h>
 
 #include "igc_hw.h"
 
@@ -217,6 +218,12 @@ struct igc_adapter {
 	struct timecounter tc;
 	struct timespec64 prev_ptp_time; /* Pre-reset PTP clock */
 	ktime_t ptp_reset_start; /* Reset time in clock mono */
+	struct system_time_snapshot prev_snapshot;
+	struct system_time_snapshot curr_snapshot;
+	struct delayed_work ptm_report;
+	struct mutex ptm_time_lock; /* protects host and device timestamps */
+	ktime_t ptm_device_time;
+	struct system_counterval_t ptm_host_time;
 };
 
 void igc_up(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 21695476b8a5..c7724bf444b5 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -417,6 +417,28 @@
 #define IGC_RXCSUM_CRCOFL	0x00000800   /* CRC32 offload enable */
 #define IGC_RXCSUM_PCSD		0x00002000   /* packet checksum disabled */
 
+/* PCIe PTM Control */
+#define IGC_PTM_CTRL_START_NOW	BIT(29) /* Start PTM Now */
+#define IGC_PTM_CTRL_EN		BIT(30) /* Enable PTM */
+#define IGC_PTM_CTRL_TRIG	BIT(31) /* PTM Cycle trigger */
+#define IGC_PTM_CTRL_SHRT_CYC(usec)	(((usec) & 0x1f) << 2)
+#define IGC_PTM_CTRL_PTM_TO(usec)	(((usec) & 0x1f) << 8)
+
+/* PCIe Digital Delay */
+#define IGC_PCIE_DIG_DELAY_DEFAULT	0x1440000
+
+/* PCIe PHY Delay */
+#define IGC_PCIE_PHY_DELAY_DEFAULT	0x64900000
+
+#define IGC_TIMADJ_ADJUST_METH		0x40000000
+
+/* PCIe PTM Status */
+#define IGC_PTM_STAT_VALID			BIT(0) /* PTM Status */
+
+/* PCIe PTM Cycle Control */
+#define IGC_PTM_CYCLE_CTRL_CYC_TIME(msec)	((msec) & 0x1ff) /* PTM Cycle Time (msec) */
+#define IGC_PTM_CYCLE_CTRL_AUTO_CYC_EN		BIT(31) /* PTM Cycle Control */
+
 /* GPY211 - I225 defines */
 #define GPY_MMD_MASK		0xFFFF0000
 #define GPY_MMD_SHIFT		16
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 56670ce14da8..b92c07338325 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3546,6 +3546,8 @@ static int igc_sw_init(struct igc_adapter *adapter)
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	mutex_init(&adapter->nfc_rule_lock);
+	mutex_init(&adapter->ptm_time_lock);
+
 	INIT_LIST_HEAD(&adapter->nfc_rule_list);
 	adapter->nfc_rule_count = 0;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index ac0b9c85da7c..d73c4aaac610 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -16,6 +16,8 @@
 #define IGC_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 9)
 #define IGC_PTP_TX_TIMEOUT		(HZ * 15)
 
+#define IGC_PTM_CYCLE_TIME_MSECS 50
+
 /* SYSTIM read access for I225 */
 void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts)
 {
@@ -421,6 +423,64 @@ static void igc_ptp_tx_work(struct work_struct *work)
 	igc_ptp_tx_hwtstamp(adapter);
 }
 
+static void igc_ptm_gather_report(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 t2_curr_h, t2_curr_l;
+	ktime_t t1, t2_curr;
+
+	t1 = ktime_set(rd32(IGC_PTM_T1_TIM0_H),
+		       rd32(IGC_PTM_T1_TIM0_L));
+
+	t2_curr_l = rd32(IGC_PTM_CURR_T2_L);
+	t2_curr_h = rd32(IGC_PTM_CURR_T2_H);
+
+	/* FIXME: There's an ambiguity on what endianness some PCIe PTM
+	 * messages should use. Find a more robust way to handle this.
+	 */
+	t2_curr_h = be32_to_cpu(t2_curr_h);
+
+	t2_curr = ((s64)t2_curr_h << 32 | t2_curr_l);
+
+	wr32(IGC_PTM_STAT, IGC_PTM_STAT_VALID);
+
+	mutex_lock(&adapter->ptm_time_lock);
+
+	/* Because get_device_system_crosststamp() requires that the
+	 * historic timestamp is before the PTM device/host
+	 * timestamps, we keep track of the current and previous
+	 * snapshot (historic timestamp).
+	 */
+	memcpy(&adapter->prev_snapshot,
+	       &adapter->curr_snapshot, sizeof(adapter->prev_snapshot));
+	ktime_get_snapshot(&adapter->curr_snapshot);
+
+	adapter->ptm_device_time = t1;
+	adapter->ptm_host_time = convert_art_ns_to_tsc(t2_curr);
+	mutex_unlock(&adapter->ptm_time_lock);
+
+	mod_delayed_work(system_wq, &adapter->ptm_report,
+			 msecs_to_jiffies(IGC_PTM_CYCLE_TIME_MSECS));
+}
+
+static void igc_ptm_report_work(struct work_struct *work)
+{
+	struct igc_adapter *adapter = container_of(to_delayed_work(work),
+						   struct igc_adapter,
+						   ptm_report);
+	struct igc_hw *hw = &adapter->hw;
+	u32 stat;
+
+	stat = rd32(IGC_PTM_STAT);
+
+	if (stat & IGC_PTM_STAT_VALID) {
+		igc_ptm_gather_report(adapter);
+	} else {
+		/* reschedule to check later */
+		mod_delayed_work(system_wq, &adapter->ptm_report, 0);
+	}
+}
+
 /**
  * igc_ptp_set_ts_config - set hardware time stamping config
  * @netdev: network interface device structure
@@ -466,6 +526,53 @@ int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr)
 		-EFAULT : 0;
 }
 
+static int igc_phc_get_syncdevicetime(ktime_t *device,
+				      struct system_counterval_t *system,
+				      void *ctx)
+{
+	struct igc_adapter *adapter = ctx;
+
+	mutex_lock(&adapter->ptm_time_lock);
+
+	*device = adapter->ptm_device_time;
+	*system = adapter->ptm_host_time;
+
+	mutex_unlock(&adapter->ptm_time_lock);
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
+					     adapter, &adapter->prev_snapshot, cts);
+}
+
+static bool igc_is_ptm_supported(struct igc_adapter *adapter)
+{
+#ifdef CONFIG_PCIE_PTM
+	return adapter->pdev->ptm_enabled;
+#endif
+	return false;
+}
+
+static bool igc_ptm_init(struct igc_adapter *adapter)
+{
+	if (!igc_is_ptm_supported(adapter))
+		return false;
+
+	INIT_DELAYED_WORK(&adapter->ptm_report, igc_ptm_report_work);
+
+	/* Get a snapshot of system clocks to use as historic value. */
+	ktime_get_snapshot(&adapter->prev_snapshot);
+	ktime_get_snapshot(&adapter->curr_snapshot);
+
+	return true;
+}
+
 /**
  * igc_ptp_init - Initialize PTP functionality
  * @adapter: Board private structure
@@ -488,6 +595,11 @@ void igc_ptp_init(struct igc_adapter *adapter)
 		adapter->ptp_caps.gettimex64 = igc_ptp_gettimex64_i225;
 		adapter->ptp_caps.settime64 = igc_ptp_settime_i225;
 		adapter->ptp_caps.enable = igc_ptp_feature_enable_i225;
+
+		if (!igc_ptm_init(adapter))
+			break;
+
+		adapter->ptp_caps.getcrosststamp = igc_ptp_getcrosststamp;
 		break;
 	default:
 		adapter->ptp_clock = NULL;
@@ -532,6 +644,47 @@ static void igc_ptp_time_restore(struct igc_adapter *adapter)
 	igc_ptp_write_i225(adapter, &ts);
 }
 
+static void igc_ptm_stop(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	wr32(IGC_PTM_CYCLE_CTRL, 0);
+	wr32(IGC_PTM_CTRL, 0);
+
+	cancel_delayed_work_sync(&adapter->ptm_report);
+}
+
+static void igc_ptm_start(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 cycle_ctrl, ctrl;
+
+	if (!igc_is_ptm_supported(adapter))
+		return;
+
+	wr32(IGC_PCIE_DIG_DELAY, IGC_PCIE_DIG_DELAY_DEFAULT);
+	wr32(IGC_PCIE_PHY_DELAY, IGC_PCIE_PHY_DELAY_DEFAULT);
+
+	ctrl = IGC_PTM_CTRL_EN |
+		IGC_PTM_CTRL_SHRT_CYC(20) |
+		IGC_PTM_CTRL_PTM_TO(110);
+
+	cycle_ctrl = IGC_PTM_CYCLE_CTRL_CYC_TIME(IGC_PTM_CYCLE_TIME_MSECS) |
+		IGC_PTM_CYCLE_CTRL_AUTO_CYC_EN;
+
+	wr32(IGC_PTM_CYCLE_CTRL, cycle_ctrl);
+	wr32(IGC_PTM_CTRL, ctrl);
+
+	/* The cycle only starts "for real" when software notifies
+	 * that it has read the registers, this is done by setting
+	 * VALID bit.
+	 */
+	wr32(IGC_PTM_STAT, IGC_PTM_STAT_VALID);
+
+	schedule_delayed_work(&adapter->ptm_report,
+			      msecs_to_jiffies(IGC_PTM_CYCLE_TIME_MSECS));
+}
+
 /**
  * igc_ptp_suspend - Disable PTP work items and prepare for suspend
  * @adapter: Board private structure
@@ -544,6 +697,8 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
 		return;
 
+	igc_ptm_stop(adapter);
+
 	cancel_work_sync(&adapter->ptp_tx_work);
 	dev_kfree_skb_any(adapter->ptp_tx_skb);
 	adapter->ptp_tx_skb = NULL;
@@ -579,6 +734,10 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
 	unsigned long flags;
+	u32 timadj;
+
+	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
+		return;
 
 	/* reset the tstamp_config */
 	igc_ptp_set_timestamp_mode(adapter, &adapter->tstamp_config);
@@ -587,10 +746,17 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 
 	switch (adapter->hw.mac.type) {
 	case igc_i225:
+		timadj = rd32(IGC_TIMADJ);
+		timadj |= IGC_TIMADJ_ADJUST_METH;
+		wr32(IGC_TIMADJ, timadj);
+
 		wr32(IGC_TSAUXC, 0x0);
 		wr32(IGC_TSSDP, 0x0);
 		wr32(IGC_TSIM, IGC_TSICR_INTERRUPTS);
 		wr32(IGC_IMS, IGC_IMS_TS);
+
+		igc_ptm_start(adapter);
+
 		break;
 	default:
 		/* No work to do. */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index b52dd9d737e8..893f09cf96e2 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -218,6 +218,29 @@
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
2.28.0

