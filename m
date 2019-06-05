Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB9A36560
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfFEUXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:23:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:4309 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfFEUXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:23:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2019 13:23:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ixgbe: implement support for SDP/PPS output on X550 hardware
Date:   Wed,  5 Jun 2019 13:23:57 -0700
Message-Id: <20190605202358.2767-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Similar to the X540 hardware, enable support for generating a 1pps
output signal on SDP0.

This support is slightly different to the X540 hardware, because of the
register layout changes. First, the system time register is now
represented in 'cycles' and 'billions of cycles'. Second, we need to
also program the TSSDP register, as well as the ESDP register. Third,
the clock output uses only FREQOUT, instead of a full 64bit value for
the output clock period. Finally, we have to use the ST0 bit instead of
the SYNCLK bit in the TSAUXC register.

This support should work even for the hardware with a higher frequency
clock, as it carefully takes into account the multiply and shift of the
cycle counter used.

We also set the pps configuration to 1, since we now support generating
a pulse per second output.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 99 ++++++++++++++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 14 ++-
 2 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 376ad91d6a8d..2c4d327fcc2e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -224,6 +224,101 @@ static void ixgbe_ptp_setup_sdp_X540(struct ixgbe_adapter *adapter)
 	IXGBE_WRITE_FLUSH(hw);
 }
 
+/**
+ * ixgbe_ptp_setup_sdp_X550
+ * @adapter: private adapter structure
+ *
+ * Enable or disable a clock output signal on SDP 0 for X550 hardware.
+ *
+ * Use the target time feature to align the output signal on the next full
+ * second.
+ *
+ * This works by using the cycle counter shift and mult values in reverse, and
+ * assumes that the values we're shifting will not overflow.
+ */
+static void ixgbe_ptp_setup_sdp_X550(struct ixgbe_adapter *adapter)
+{
+	u32 esdp, tsauxc, freqout, trgttiml, trgttimh, rem, tssdp;
+	struct cyclecounter *cc = &adapter->hw_cc;
+	struct ixgbe_hw *hw = &adapter->hw;
+	u64 ns = 0, clock_edge = 0;
+	struct timespec64 ts;
+	unsigned long flags;
+
+	/* disable the pin first */
+	IXGBE_WRITE_REG(hw, IXGBE_TSAUXC, 0x0);
+	IXGBE_WRITE_FLUSH(hw);
+
+	if (!(adapter->flags2 & IXGBE_FLAG2_PTP_PPS_ENABLED))
+		return;
+
+	esdp = IXGBE_READ_REG(hw, IXGBE_ESDP);
+
+	/* enable the SDP0 pin as output, and connected to the
+	 * native function for Timesync (ClockOut)
+	 */
+	esdp |= IXGBE_ESDP_SDP0_DIR |
+		IXGBE_ESDP_SDP0_NATIVE;
+
+	/* enable the Clock Out feature on SDP0, and use Target Time 0 to
+	 * enable generation of interrupts on the clock change.
+	 */
+#define IXGBE_TSAUXC_DIS_TS_CLEAR 0x40000000
+	tsauxc = (IXGBE_TSAUXC_EN_CLK | IXGBE_TSAUXC_ST0 |
+		  IXGBE_TSAUXC_EN_TT0 | IXGBE_TSAUXC_SDP0_INT |
+		  IXGBE_TSAUXC_DIS_TS_CLEAR);
+
+	tssdp = (IXGBE_TSSDP_TS_SDP0_EN |
+		 IXGBE_TSSDP_TS_SDP0_CLK0);
+
+	/* Determine the clock time period to use. This assumes that the
+	 * cycle counter shift is small enough to avoid overflowing a 32bit
+	 * value.
+	 */
+	freqout = div_u64(NS_PER_HALF_SEC << cc->shift,  cc->mult);
+
+	/* Read the current clock time, and save the cycle counter value */
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	ns = timecounter_read(&adapter->hw_tc);
+	clock_edge = adapter->hw_tc.cycle_last;
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+
+	/* Figure out how far past the next second we are */
+	div_u64_rem(ns, NS_PER_SEC, &rem);
+
+	/* Figure out how many nanoseconds to add to round the clock edge up
+	 * to the next full second
+	 */
+	rem = (NS_PER_SEC - rem);
+
+	/* Adjust the clock edge to align with the next full second. This
+	 * assumes that the cycle counter shift is small enough to avoid
+	 * overflowing when shifting the remainder.
+	 */
+	clock_edge += div_u64((rem << cc->shift), cc->mult);
+
+	/* X550 hardware stores the time in 32bits of 'billions of cycles' and
+	 * 32bits of 'cycles'. There's no guarantee that cycles represents
+	 * nanoseconds. However, we can use the math from a timespec64 to
+	 * convert into the hardware representation.
+	 *
+	 * See ixgbe_ptp_read_X550() for more details.
+	 */
+	ts = ns_to_timespec64(clock_edge);
+	trgttiml = (u32)ts.tv_nsec;
+	trgttimh = (u32)ts.tv_sec;
+
+	IXGBE_WRITE_REG(hw, IXGBE_FREQOUT0, freqout);
+	IXGBE_WRITE_REG(hw, IXGBE_TRGTTIML0, trgttiml);
+	IXGBE_WRITE_REG(hw, IXGBE_TRGTTIMH0, trgttimh);
+
+	IXGBE_WRITE_REG(hw, IXGBE_ESDP, esdp);
+	IXGBE_WRITE_REG(hw, IXGBE_TSSDP, tssdp);
+	IXGBE_WRITE_REG(hw, IXGBE_TSAUXC, tsauxc);
+
+	IXGBE_WRITE_FLUSH(hw);
+}
+
 /**
  * ixgbe_ptp_read_X550 - read cycle counter value
  * @cc: cyclecounter structure
@@ -1302,13 +1397,13 @@ static long ixgbe_ptp_create_clock(struct ixgbe_adapter *adapter)
 		adapter->ptp_caps.n_alarm = 0;
 		adapter->ptp_caps.n_ext_ts = 0;
 		adapter->ptp_caps.n_per_out = 0;
-		adapter->ptp_caps.pps = 0;
+		adapter->ptp_caps.pps = 1;
 		adapter->ptp_caps.adjfreq = ixgbe_ptp_adjfreq_X550;
 		adapter->ptp_caps.adjtime = ixgbe_ptp_adjtime;
 		adapter->ptp_caps.gettimex64 = ixgbe_ptp_gettimex;
 		adapter->ptp_caps.settime64 = ixgbe_ptp_settime;
 		adapter->ptp_caps.enable = ixgbe_ptp_feature_enable;
-		adapter->ptp_setup_sdp = NULL;
+		adapter->ptp_setup_sdp = ixgbe_ptp_setup_sdp_X550;
 		break;
 	default:
 		adapter->ptp_clock = NULL;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 84f2dba39e36..2be1c4c72435 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -1067,6 +1067,7 @@ struct ixgbe_nvm_version {
 #define IXGBE_AUXSTMPL1  0x08C44 /* Auxiliary Time Stamp 1 register Low - RO */
 #define IXGBE_AUXSTMPH1  0x08C48 /* Auxiliary Time Stamp 1 register High - RO */
 #define IXGBE_TSIM       0x08C68 /* TimeSync Interrupt Mask Register - RW */
+#define IXGBE_TSSDP      0x0003C /* TimeSync SDP Configuration Register - RW */
 
 /* Diagnostic Registers */
 #define IXGBE_RDSTATCTL   0x02C20
@@ -2240,11 +2241,18 @@ enum {
 #define IXGBE_RXDCTL_RLPML_EN   0x00008000
 #define IXGBE_RXDCTL_VME        0x40000000  /* VLAN mode enable */
 
-#define IXGBE_TSAUXC_EN_CLK   0x00000004
-#define IXGBE_TSAUXC_SYNCLK   0x00000008
-#define IXGBE_TSAUXC_SDP0_INT 0x00000040
+#define IXGBE_TSAUXC_EN_CLK		0x00000004
+#define IXGBE_TSAUXC_SYNCLK		0x00000008
+#define IXGBE_TSAUXC_SDP0_INT		0x00000040
+#define IXGBE_TSAUXC_EN_TT0		0x00000001
+#define IXGBE_TSAUXC_EN_TT1		0x00000002
+#define IXGBE_TSAUXC_ST0		0x00000010
 #define IXGBE_TSAUXC_DISABLE_SYSTIME	0x80000000
 
+#define IXGBE_TSSDP_TS_SDP0_SEL_MASK	0x000000C0
+#define IXGBE_TSSDP_TS_SDP0_CLK0	0x00000080
+#define IXGBE_TSSDP_TS_SDP0_EN		0x00000100
+
 #define IXGBE_TSYNCTXCTL_VALID		0x00000001 /* Tx timestamp valid */
 #define IXGBE_TSYNCTXCTL_ENABLED	0x00000010 /* Tx timestamping enabled */
 
-- 
2.21.0

