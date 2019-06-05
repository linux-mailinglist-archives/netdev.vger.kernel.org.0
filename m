Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF5D36564
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfFEUYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:24:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:4309 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfFEUXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:49 -0400
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
Subject: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Date:   Wed,  5 Jun 2019 13:23:49 -0700
Message-Id: <20190605202358.2767-7-jeffrey.t.kirsher@intel.com>
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

The function ixgbe_ptp_setup_sdp_X540 attempts to program a software
defined pin, in order to generate a pulse-per-second output on SDP 0.

It does work to generate the output, but does not align the output on
the full second. Additionally, it does not take into account the
cyclecounter multiplier. This leads to somewhat confusing code which is
likely to be incorrect if blindly copied to another hardware type.

Update this code to account for the cyclecounter multiplier, and to
directly use timecounter_read.

This change ensures that the SDP output will align properly on a full
second, and makes the intent of the calculations a bit more clear.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c | 71 ++++++++++++--------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index dbe84a4d2f7f..047767408df0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -74,11 +74,11 @@
 #define IXGBE_OVERFLOW_PERIOD    (HZ * 30)
 #define IXGBE_PTP_TX_TIMEOUT     (HZ)
 
-/* half of a one second clock period, for use with PPS signal. We have to use
- * this instead of something pre-defined like IXGBE_PTP_PPS_HALF_SECOND, in
- * order to force at least 64bits of precision for shifting
+/* We use our own definitions instead of NSEC_PER_SEC because we want to mark
+ * the value as a ULL to force precision when bit shifting.
  */
-#define IXGBE_PTP_PPS_HALF_SECOND 500000000ULL
+#define NS_PER_SEC      1000000000ULL
+#define NS_PER_HALF_SEC  500000000ULL
 
 /* In contrast, the X550 controller has two registers, SYSTIMEH and SYSTIMEL
  * which contain measurements of seconds and nanoseconds respectively. This
@@ -141,23 +141,26 @@
 #define MAX_TIMADJ	0x7FFFFFFF
 
 /**
- * ixgbe_ptp_setup_sdp_x540
+ * ixgbe_ptp_setup_sdp_X540
  * @adapter: private adapter structure
  *
  * this function enables or disables the clock out feature on SDP0 for
- * the X540 device. It will create a 1second periodic output that can
+ * the X540 device. It will create a 1 second periodic output that can
  * be used as the PPS (via an interrupt).
  *
- * It calculates when the systime will be on an exact second, and then
- * aligns the start of the PPS signal to that value. The shift is
- * necessary because it can change based on the link speed.
+ * It calculates when the system time will be on an exact second, and then
+ * aligns the start of the PPS signal to that value.
+ *
+ * This works by using the cycle counter shift and mult values in reverse, and
+ * assumes that the values we're shifting will not overflow.
  */
-static void ixgbe_ptp_setup_sdp_x540(struct ixgbe_adapter *adapter)
+static void ixgbe_ptp_setup_sdp_X540(struct ixgbe_adapter *adapter)
 {
+	struct cyclecounter *cc = &adapter->hw_cc;
 	struct ixgbe_hw *hw = &adapter->hw;
-	int shift = adapter->hw_cc.shift;
 	u32 esdp, tsauxc, clktiml, clktimh, trgttiml, trgttimh, rem;
-	u64 ns = 0, clock_edge = 0;
+	u64 ns = 0, clock_edge = 0, clock_period;
+	unsigned long flags;
 
 	/* disable the pin first */
 	IXGBE_WRITE_REG(hw, IXGBE_TSAUXC, 0x0);
@@ -177,26 +180,36 @@ static void ixgbe_ptp_setup_sdp_x540(struct ixgbe_adapter *adapter)
 	/* enable the Clock Out feature on SDP0, and allow
 	 * interrupts to occur when the pin changes
 	 */
-	tsauxc = IXGBE_TSAUXC_EN_CLK |
-		 IXGBE_TSAUXC_SYNCLK |
-		 IXGBE_TSAUXC_SDP0_INT;
-
-	/* clock period (or pulse length) */
-	clktiml = (u32)(IXGBE_PTP_PPS_HALF_SECOND << shift);
-	clktimh = (u32)((IXGBE_PTP_PPS_HALF_SECOND << shift) >> 32);
+	tsauxc = (IXGBE_TSAUXC_EN_CLK |
+		  IXGBE_TSAUXC_SYNCLK |
+		  IXGBE_TSAUXC_SDP0_INT);
 
-	/* Account for the cyclecounter wrap-around value by
-	 * using the converted ns value of the current time to
-	 * check for when the next aligned second would occur.
+	/* Determine the clock time period to use. This assumes that the
+	 * cycle counter shift is small enough to avoid overflow.
 	 */
-	clock_edge |= (u64)IXGBE_READ_REG(hw, IXGBE_SYSTIML);
-	clock_edge |= (u64)IXGBE_READ_REG(hw, IXGBE_SYSTIMH) << 32;
-	ns = timecounter_cyc2time(&adapter->hw_tc, clock_edge);
+	clock_period = div_u64((NS_PER_HALF_SEC << cc->shift), cc->mult);
+	clktiml = (u32)(clock_period);
+	clktimh = (u32)(clock_period >> 32);
 
-	div_u64_rem(ns, IXGBE_PTP_PPS_HALF_SECOND, &rem);
-	clock_edge += ((IXGBE_PTP_PPS_HALF_SECOND - (u64)rem) << shift);
+	/* Read the current clock time, and save the cycle counter value */
+	spin_lock_irqsave(&adapter->tmreg_lock, flags);
+	ns = timecounter_read(&adapter->hw_tc);
+	clock_edge = adapter->hw_tc.cycle_last;
+	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
-	/* specify the initial clock start time */
+	/* Figure out how many seconds to add in order to round up */
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
 	trgttiml = (u32)clock_edge;
 	trgttimh = (u32)(clock_edge >> 32);
 
@@ -1253,7 +1266,7 @@ static long ixgbe_ptp_create_clock(struct ixgbe_adapter *adapter)
 		adapter->ptp_caps.gettimex64 = ixgbe_ptp_gettimex;
 		adapter->ptp_caps.settime64 = ixgbe_ptp_settime;
 		adapter->ptp_caps.enable = ixgbe_ptp_feature_enable;
-		adapter->ptp_setup_sdp = ixgbe_ptp_setup_sdp_x540;
+		adapter->ptp_setup_sdp = ixgbe_ptp_setup_sdp_X540;
 		break;
 	case ixgbe_mac_82599EB:
 		snprintf(adapter->ptp_caps.name,
-- 
2.21.0

