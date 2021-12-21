Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6EE47C5D2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhLUSI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:08:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:51709 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240858AbhLUSIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110105; x=1671646105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=efBLSd3OsOMmQYjP8U3tNwlBwu25Q5aDA85N0l8NJr8=;
  b=OYj3KZs6LShb0arY8XzFP9JcmpizO2hOxcncJmuvOT3f+ZuadexRbUc4
   KvsWcph7gOpCUlQPBeg2kO5TAsT15J2GoyEj/8Zx6w5C4eI/ad5d6BgxT
   1tJCH++hoZXkw3kbC9Rc1JjNQotuRhcIvma6e+K6qITi64fSP2EOj3fJr
   1A32FNroYgh+Tl1Qh1/FA6b/e0hp0XItR2A20Lkx0A0Wg3Sntdjlqc8Uw
   2SnCRi2Y4zo2fqskqexeZZP0d0yy2a17Np/kXtVPoupzfSv95a/V5C8s/
   3b5n7t5bWi5k08Z+R8PhUFBUnVpby1eUNl0ewFxG95vvuaTYaF+tj5Ie9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="301225605"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="301225605"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342505"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 10/10] ice: support crosstimestamping on E822 devices if supported
Date:   Tue, 21 Dec 2021 09:48:45 -0800
Message-Id: <20211221174845.3063640-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

E822 devices on supported platforms can generate a cross timestamp
between the platform ART and the device time. This process allows for
very precise measurement of the difference between the PTP hardware
clock and the platform time.

This is only supported if we know the TSC frequency relative to ART, so
we do not enable this unless the boot CPU has a known TSC frequency (as
required by convert_art_ns_to_tsc).

Because PCIe PTM support is not available on all platforms, introduce
CONFIG_ICE_HWTS and make it depend on X86 where we know the support
exists.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |  10 ++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   8 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 117 ++++++++++++++++++
 3 files changed, 135 insertions(+)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 0b274d8fa45b..3facb55b7161 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -327,6 +327,16 @@ config ICE_SWITCHDEV
 
 	  If unsure, say N.
 
+config ICE_HWTS
+	bool "Support HW cross-timestamp on platforms with PTM support"
+	default y
+	depends on ICE && X86
+	help
+	  Say Y to enable hardware supported cross-timestamping on platforms
+	  with PCIe PTM support. The cross-timestamp is available through
+	  the PTP clock driver precise cross-timestamp ioctl
+	  (PTP_SYS_OFFSET_PRECISE).
+
 config FM10K
 	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
 	default n
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 7bff0450b76c..d16738a3d3a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -441,6 +441,10 @@
 #define GLV_UPRCL(_i)				(0x003B2000 + ((_i) * 8))
 #define GLV_UPTCL(_i)				(0x0030A000 + ((_i) * 8))
 #define PRTRPB_RDPC				0x000AC260
+#define GLHH_ART_CTL				0x000A41D4
+#define GLHH_ART_CTL_ACTIVE_M			BIT(0)
+#define GLHH_ART_TIME_H				0x000A41D8
+#define GLHH_ART_TIME_L				0x000A41DC
 #define GLTSYN_AUX_IN_0(_i)			(0x000889D8 + ((_i) * 4))
 #define GLTSYN_AUX_IN_0_INT_ENA_M		BIT(4)
 #define GLTSYN_AUX_OUT_0(_i)			(0x00088998 + ((_i) * 4))
@@ -453,6 +457,8 @@
 #define GLTSYN_ENA_TSYN_ENA_M			BIT(0)
 #define GLTSYN_EVNT_H_0(_i)			(0x00088970 + ((_i) * 4))
 #define GLTSYN_EVNT_L_0(_i)			(0x00088968 + ((_i) * 4))
+#define GLTSYN_HHTIME_H(_i)			(0x00088900 + ((_i) * 4))
+#define GLTSYN_HHTIME_L(_i)			(0x000888F8 + ((_i) * 4))
 #define GLTSYN_INCVAL_H(_i)			(0x00088920 + ((_i) * 4))
 #define GLTSYN_INCVAL_L(_i)			(0x00088918 + ((_i) * 4))
 #define GLTSYN_SHADJ_H(_i)			(0x00088910 + ((_i) * 4))
@@ -469,6 +475,8 @@
 #define GLTSYN_TGT_L_0(_i)			(0x00088928 + ((_i) * 4))
 #define GLTSYN_TIME_H(_i)			(0x000888D8 + ((_i) * 4))
 #define GLTSYN_TIME_L(_i)			(0x000888D0 + ((_i) * 4))
+#define PFHH_SEM				0x000A4200 /* Reset Source: PFR */
+#define PFHH_SEM_BUSY_M				BIT(0)
 #define PFTSYN_SEM				0x00088880
 #define PFTSYN_SEM_BUSY_M			BIT(0)
 #define VSIQF_FD_CNT(_VSI)			(0x00464000 + ((_VSI) * 4))
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 14b371a8f301..d3f65e061a62 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1589,6 +1589,101 @@ static int ice_ptp_adjtime(struct ptp_clock_info *info, s64 delta)
 	return 0;
 }
 
+#ifdef CONFIG_ICE_HWTS
+/**
+ * ice_ptp_get_syncdevicetime - Get the cross time stamp info
+ * @device: Current device time
+ * @system: System counter value read synchronously with device time
+ * @ctx: Context provided by timekeeping code
+ *
+ * Read device and system (ART) clock simultaneously and return the corrected
+ * clock values in ns.
+ */
+static int
+ice_ptp_get_syncdevicetime(ktime_t *device,
+			   struct system_counterval_t *system,
+			   void *ctx)
+{
+	struct ice_pf *pf = (struct ice_pf *)ctx;
+	struct ice_hw *hw = &pf->hw;
+	u32 hh_lock, hh_art_ctl;
+	int i;
+
+	/* Get the HW lock */
+	hh_lock = rd32(hw, PFHH_SEM + (PFTSYN_SEM_BYTES * hw->pf_id));
+	if (hh_lock & PFHH_SEM_BUSY_M) {
+		dev_err(ice_pf_to_dev(pf), "PTP failed to get hh lock\n");
+		return -EFAULT;
+	}
+
+	/* Start the ART and device clock sync sequence */
+	hh_art_ctl = rd32(hw, GLHH_ART_CTL);
+	hh_art_ctl = hh_art_ctl | GLHH_ART_CTL_ACTIVE_M;
+	wr32(hw, GLHH_ART_CTL, hh_art_ctl);
+
+#define MAX_HH_LOCK_TRIES 100
+
+	for (i = 0; i < MAX_HH_LOCK_TRIES; i++) {
+		/* Wait for sync to complete */
+		hh_art_ctl = rd32(hw, GLHH_ART_CTL);
+		if (hh_art_ctl & GLHH_ART_CTL_ACTIVE_M) {
+			udelay(1);
+			continue;
+		} else {
+			u32 hh_ts_lo, hh_ts_hi, tmr_idx;
+			u64 hh_ts;
+
+			tmr_idx = hw->func_caps.ts_func_info.tmr_index_assoc;
+			/* Read ART time */
+			hh_ts_lo = rd32(hw, GLHH_ART_TIME_L);
+			hh_ts_hi = rd32(hw, GLHH_ART_TIME_H);
+			hh_ts = ((u64)hh_ts_hi << 32) | hh_ts_lo;
+			*system = convert_art_ns_to_tsc(hh_ts);
+			/* Read Device source clock time */
+			hh_ts_lo = rd32(hw, GLTSYN_HHTIME_L(tmr_idx));
+			hh_ts_hi = rd32(hw, GLTSYN_HHTIME_H(tmr_idx));
+			hh_ts = ((u64)hh_ts_hi << 32) | hh_ts_lo;
+			*device = ns_to_ktime(hh_ts);
+			break;
+		}
+	}
+	/* Release HW lock */
+	hh_lock = rd32(hw, PFHH_SEM + (PFTSYN_SEM_BYTES * hw->pf_id));
+	hh_lock = hh_lock & ~PFHH_SEM_BUSY_M;
+	wr32(hw, PFHH_SEM + (PFTSYN_SEM_BYTES * hw->pf_id), hh_lock);
+
+	if (i == MAX_HH_LOCK_TRIES)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+/**
+ * ice_ptp_getcrosststamp_e822 - Capture a device cross timestamp
+ * @info: the driver's PTP info structure
+ * @cts: The memory to fill the cross timestamp info
+ *
+ * Capture a cross timestamp between the ART and the device PTP hardware
+ * clock. Fill the cross timestamp information and report it back to the
+ * caller.
+ *
+ * This is only valid for E822 devices which have support for generating the
+ * cross timestamp via PCIe PTM.
+ *
+ * In order to correctly correlate the ART timestamp back to the TSC time, the
+ * CPU must have X86_FEATURE_TSC_KNOWN_FREQ.
+ */
+static int
+ice_ptp_getcrosststamp_e822(struct ptp_clock_info *info,
+			    struct system_device_crosststamp *cts)
+{
+	struct ice_pf *pf = ptp_info_to_pf(info);
+
+	return get_device_system_crosststamp(ice_ptp_get_syncdevicetime,
+					     pf, NULL, cts);
+}
+#endif /* CONFIG_ICE_HWTS */
+
 /**
  * ice_ptp_get_ts_config - ioctl interface to read the timestamping config
  * @pf: Board private structure
@@ -1809,6 +1904,26 @@ static void ice_ptp_setup_pins_e810(struct ptp_clock_info *info)
 	info->n_ext_ts = N_EXT_TS_E810;
 }
 
+/**
+ * ice_ptp_set_funcs_e822 - Set specialized functions for E822 support
+ * @pf: Board private structure
+ * @info: PTP info to fill
+ *
+ * Assign functions to the PTP capabiltiies structure for E822 devices.
+ * Functions which operate across all device families should be set directly
+ * in ice_ptp_set_caps. Only add functions here which are distinct for E822
+ * devices.
+ */
+static void
+ice_ptp_set_funcs_e822(struct ice_pf *pf, struct ptp_clock_info *info)
+{
+#ifdef CONFIG_ICE_HWTS
+	if (boot_cpu_has(X86_FEATURE_ART) &&
+	    boot_cpu_has(X86_FEATURE_TSC_KNOWN_FREQ))
+		info->getcrosststamp = ice_ptp_getcrosststamp_e822;
+#endif /* CONFIG_ICE_HWTS */
+}
+
 /**
  * ice_ptp_set_funcs_e810 - Set specialized functions for E810 support
  * @pf: Board private structure
@@ -1850,6 +1965,8 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 
 	if (ice_is_e810(&pf->hw))
 		ice_ptp_set_funcs_e810(pf, info);
+	else
+		ice_ptp_set_funcs_e822(pf, info);
 }
 
 /**
-- 
2.31.1

