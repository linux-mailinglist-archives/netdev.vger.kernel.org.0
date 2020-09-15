Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB1E269B86
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIOBp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:45:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:12864 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgIOBpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:45:17 -0400
IronPort-SDR: DFIZL8H8jUvrP3YiYK3aqawVa3vGDfqBEduxyKnV4VTkDd24FQFQzsx+NaYVD4hBFSDR7NvcyI
 CHpnW+94bxyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220742444"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220742444"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
IronPort-SDR: iKnyp2pM3FaQxfVKAMVw+z+SYX1nUm+hh3G4MRDHzHzi9GZ+gXVTNchP2HMl2uZj1znnO0TcI+
 rSnUf8Sd0W7g==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482571944"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v2 03/10] intel: handle unused assignments
Date:   Mon, 14 Sep 2020 18:44:48 -0700
Message-Id: <20200915014455.1232507-4-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove variables that were storing a return value from a register
read or other read, where the return value wasn't used. Those
conversions to remove the lvalue of the assignment should be safe
because the readl memory mapped reads are marked volatile and
should not be optimized out without an lvalue (I suspect a very
long time ago this wasn't guaranteed as it is today).

These changes are part of a separate patch to make it easier to review.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/e100.c           |   6 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 139 +++++++++-----------
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c   | 135 +++++++++----------
 3 files changed, 131 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 79c7a92aed16..76bb77b4607a 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2593,7 +2593,7 @@ static void e100_diag_test(struct net_device *netdev,
 {
 	struct ethtool_cmd cmd;
 	struct nic *nic = netdev_priv(netdev);
-	int i, err;
+	int i;
 
 	memset(data, 0, E100_TEST_LEN * sizeof(u64));
 	data[0] = !mii_link_ok(&nic->mii);
@@ -2601,7 +2601,7 @@ static void e100_diag_test(struct net_device *netdev,
 	if (test->flags & ETH_TEST_FL_OFFLINE) {
 
 		/* save speed, duplex & autoneg settings */
-		err = mii_ethtool_gset(&nic->mii, &cmd);
+		mii_ethtool_gset(&nic->mii, &cmd);
 
 		if (netif_running(netdev))
 			e100_down(nic);
@@ -2610,7 +2610,7 @@ static void e100_diag_test(struct net_device *netdev,
 		data[4] = e100_loopback_test(nic, lb_phy);
 
 		/* restore speed, duplex & autoneg settings */
-		err = mii_ethtool_sset(&nic->mii, &cmd);
+		mii_ethtool_sset(&nic->mii, &cmd);
 
 		if (netif_running(netdev))
 			e100_up(nic);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index fb8514078caf..2120dacfd55c 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -378,7 +378,6 @@ s32 e1000_reset_hw(struct e1000_hw *hw)
 {
 	u32 ctrl;
 	u32 ctrl_ext;
-	u32 icr;
 	u32 manc;
 	u32 led_ctrl;
 	s32 ret_val;
@@ -503,7 +502,7 @@ s32 e1000_reset_hw(struct e1000_hw *hw)
 	ew32(IMC, 0xffffffff);
 
 	/* Clear any pending interrupt events. */
-	icr = er32(ICR);
+	er32(ICR);
 
 	/* If MWI was previously enabled, reenable it. */
 	if (hw->mac_type == e1000_82542_rev2_0) {
@@ -2370,16 +2369,13 @@ static s32 e1000_check_for_serdes_link_generic(struct e1000_hw *hw)
  */
 s32 e1000_check_for_link(struct e1000_hw *hw)
 {
-	u32 rxcw = 0;
-	u32 ctrl;
 	u32 status;
 	u32 rctl;
 	u32 icr;
-	u32 signal = 0;
 	s32 ret_val;
 	u16 phy_data;
 
-	ctrl = er32(CTRL);
+	er32(CTRL);
 	status = er32(STATUS);
 
 	/* On adapters with a MAC newer than 82544, SW Definable pin 1 will be
@@ -2388,12 +2384,9 @@ s32 e1000_check_for_link(struct e1000_hw *hw)
 	 */
 	if ((hw->media_type == e1000_media_type_fiber) ||
 	    (hw->media_type == e1000_media_type_internal_serdes)) {
-		rxcw = er32(RXCW);
+		er32(RXCW);
 
 		if (hw->media_type == e1000_media_type_fiber) {
-			signal =
-			    (hw->mac_type >
-			     e1000_82544) ? E1000_CTRL_SWDPIN1 : 0;
 			if (status & E1000_STATUS_LU)
 				hw->get_link_status = false;
 		}
@@ -4675,78 +4668,76 @@ s32 e1000_led_off(struct e1000_hw *hw)
  */
 static void e1000_clear_hw_cntrs(struct e1000_hw *hw)
 {
-	volatile u32 temp;
-
-	temp = er32(CRCERRS);
-	temp = er32(SYMERRS);
-	temp = er32(MPC);
-	temp = er32(SCC);
-	temp = er32(ECOL);
-	temp = er32(MCC);
-	temp = er32(LATECOL);
-	temp = er32(COLC);
-	temp = er32(DC);
-	temp = er32(SEC);
-	temp = er32(RLEC);
-	temp = er32(XONRXC);
-	temp = er32(XONTXC);
-	temp = er32(XOFFRXC);
-	temp = er32(XOFFTXC);
-	temp = er32(FCRUC);
-
-	temp = er32(PRC64);
-	temp = er32(PRC127);
-	temp = er32(PRC255);
-	temp = er32(PRC511);
-	temp = er32(PRC1023);
-	temp = er32(PRC1522);
-
-	temp = er32(GPRC);
-	temp = er32(BPRC);
-	temp = er32(MPRC);
-	temp = er32(GPTC);
-	temp = er32(GORCL);
-	temp = er32(GORCH);
-	temp = er32(GOTCL);
-	temp = er32(GOTCH);
-	temp = er32(RNBC);
-	temp = er32(RUC);
-	temp = er32(RFC);
-	temp = er32(ROC);
-	temp = er32(RJC);
-	temp = er32(TORL);
-	temp = er32(TORH);
-	temp = er32(TOTL);
-	temp = er32(TOTH);
-	temp = er32(TPR);
-	temp = er32(TPT);
-
-	temp = er32(PTC64);
-	temp = er32(PTC127);
-	temp = er32(PTC255);
-	temp = er32(PTC511);
-	temp = er32(PTC1023);
-	temp = er32(PTC1522);
-
-	temp = er32(MPTC);
-	temp = er32(BPTC);
+	er32(CRCERRS);
+	er32(SYMERRS);
+	er32(MPC);
+	er32(SCC);
+	er32(ECOL);
+	er32(MCC);
+	er32(LATECOL);
+	er32(COLC);
+	er32(DC);
+	er32(SEC);
+	er32(RLEC);
+	er32(XONRXC);
+	er32(XONTXC);
+	er32(XOFFRXC);
+	er32(XOFFTXC);
+	er32(FCRUC);
+
+	er32(PRC64);
+	er32(PRC127);
+	er32(PRC255);
+	er32(PRC511);
+	er32(PRC1023);
+	er32(PRC1522);
+
+	er32(GPRC);
+	er32(BPRC);
+	er32(MPRC);
+	er32(GPTC);
+	er32(GORCL);
+	er32(GORCH);
+	er32(GOTCL);
+	er32(GOTCH);
+	er32(RNBC);
+	er32(RUC);
+	er32(RFC);
+	er32(ROC);
+	er32(RJC);
+	er32(TORL);
+	er32(TORH);
+	er32(TOTL);
+	er32(TOTH);
+	er32(TPR);
+	er32(TPT);
+
+	er32(PTC64);
+	er32(PTC127);
+	er32(PTC255);
+	er32(PTC511);
+	er32(PTC1023);
+	er32(PTC1522);
+
+	er32(MPTC);
+	er32(BPTC);
 
 	if (hw->mac_type < e1000_82543)
 		return;
 
-	temp = er32(ALGNERRC);
-	temp = er32(RXERRC);
-	temp = er32(TNCRS);
-	temp = er32(CEXTERR);
-	temp = er32(TSCTC);
-	temp = er32(TSCTFC);
+	er32(ALGNERRC);
+	er32(RXERRC);
+	er32(TNCRS);
+	er32(CEXTERR);
+	er32(TSCTC);
+	er32(TSCTFC);
 
 	if (hw->mac_type <= e1000_82544)
 		return;
 
-	temp = er32(MGTPRC);
-	temp = er32(MGTPDC);
-	temp = er32(MGTPTC);
+	er32(MGTPRC);
+	er32(MGTPDC);
+	er32(MGTPTC);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
index cbaa933ef30d..a430871d1c27 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_hw.c
@@ -98,7 +98,6 @@ bool
 ixgb_adapter_stop(struct ixgb_hw *hw)
 {
 	u32 ctrl_reg;
-	u32 icr_reg;
 
 	ENTER();
 
@@ -142,7 +141,7 @@ ixgb_adapter_stop(struct ixgb_hw *hw)
 	IXGB_WRITE_REG(hw, IMC, 0xffffffff);
 
 	/* Clear any pending interrupt events. */
-	icr_reg = IXGB_READ_REG(hw, ICR);
+	IXGB_READ_REG(hw, ICR);
 
 	return ctrl_reg & IXGB_CTRL0_RST;
 }
@@ -274,7 +273,6 @@ bool
 ixgb_init_hw(struct ixgb_hw *hw)
 {
 	u32 i;
-	u32 ctrl_reg;
 	bool status;
 
 	ENTER();
@@ -286,7 +284,7 @@ ixgb_init_hw(struct ixgb_hw *hw)
 	 */
 	pr_debug("Issuing a global reset to MAC\n");
 
-	ctrl_reg = ixgb_mac_reset(hw);
+	ixgb_mac_reset(hw);
 
 	pr_debug("Issuing an EE reset to MAC\n");
 #ifdef HP_ZX1
@@ -949,8 +947,6 @@ bool ixgb_check_for_bad_link(struct ixgb_hw *hw)
 static void
 ixgb_clear_hw_cntrs(struct ixgb_hw *hw)
 {
-	volatile u32 temp_reg;
-
 	ENTER();
 
 	/* if we are stopped or resetting exit gracefully */
@@ -959,66 +955,66 @@ ixgb_clear_hw_cntrs(struct ixgb_hw *hw)
 		return;
 	}
 
-	temp_reg = IXGB_READ_REG(hw, TPRL);
-	temp_reg = IXGB_READ_REG(hw, TPRH);
-	temp_reg = IXGB_READ_REG(hw, GPRCL);
-	temp_reg = IXGB_READ_REG(hw, GPRCH);
-	temp_reg = IXGB_READ_REG(hw, BPRCL);
-	temp_reg = IXGB_READ_REG(hw, BPRCH);
-	temp_reg = IXGB_READ_REG(hw, MPRCL);
-	temp_reg = IXGB_READ_REG(hw, MPRCH);
-	temp_reg = IXGB_READ_REG(hw, UPRCL);
-	temp_reg = IXGB_READ_REG(hw, UPRCH);
-	temp_reg = IXGB_READ_REG(hw, VPRCL);
-	temp_reg = IXGB_READ_REG(hw, VPRCH);
-	temp_reg = IXGB_READ_REG(hw, JPRCL);
-	temp_reg = IXGB_READ_REG(hw, JPRCH);
-	temp_reg = IXGB_READ_REG(hw, GORCL);
-	temp_reg = IXGB_READ_REG(hw, GORCH);
-	temp_reg = IXGB_READ_REG(hw, TORL);
-	temp_reg = IXGB_READ_REG(hw, TORH);
-	temp_reg = IXGB_READ_REG(hw, RNBC);
-	temp_reg = IXGB_READ_REG(hw, RUC);
-	temp_reg = IXGB_READ_REG(hw, ROC);
-	temp_reg = IXGB_READ_REG(hw, RLEC);
-	temp_reg = IXGB_READ_REG(hw, CRCERRS);
-	temp_reg = IXGB_READ_REG(hw, ICBC);
-	temp_reg = IXGB_READ_REG(hw, ECBC);
-	temp_reg = IXGB_READ_REG(hw, MPC);
-	temp_reg = IXGB_READ_REG(hw, TPTL);
-	temp_reg = IXGB_READ_REG(hw, TPTH);
-	temp_reg = IXGB_READ_REG(hw, GPTCL);
-	temp_reg = IXGB_READ_REG(hw, GPTCH);
-	temp_reg = IXGB_READ_REG(hw, BPTCL);
-	temp_reg = IXGB_READ_REG(hw, BPTCH);
-	temp_reg = IXGB_READ_REG(hw, MPTCL);
-	temp_reg = IXGB_READ_REG(hw, MPTCH);
-	temp_reg = IXGB_READ_REG(hw, UPTCL);
-	temp_reg = IXGB_READ_REG(hw, UPTCH);
-	temp_reg = IXGB_READ_REG(hw, VPTCL);
-	temp_reg = IXGB_READ_REG(hw, VPTCH);
-	temp_reg = IXGB_READ_REG(hw, JPTCL);
-	temp_reg = IXGB_READ_REG(hw, JPTCH);
-	temp_reg = IXGB_READ_REG(hw, GOTCL);
-	temp_reg = IXGB_READ_REG(hw, GOTCH);
-	temp_reg = IXGB_READ_REG(hw, TOTL);
-	temp_reg = IXGB_READ_REG(hw, TOTH);
-	temp_reg = IXGB_READ_REG(hw, DC);
-	temp_reg = IXGB_READ_REG(hw, PLT64C);
-	temp_reg = IXGB_READ_REG(hw, TSCTC);
-	temp_reg = IXGB_READ_REG(hw, TSCTFC);
-	temp_reg = IXGB_READ_REG(hw, IBIC);
-	temp_reg = IXGB_READ_REG(hw, RFC);
-	temp_reg = IXGB_READ_REG(hw, LFC);
-	temp_reg = IXGB_READ_REG(hw, PFRC);
-	temp_reg = IXGB_READ_REG(hw, PFTC);
-	temp_reg = IXGB_READ_REG(hw, MCFRC);
-	temp_reg = IXGB_READ_REG(hw, MCFTC);
-	temp_reg = IXGB_READ_REG(hw, XONRXC);
-	temp_reg = IXGB_READ_REG(hw, XONTXC);
-	temp_reg = IXGB_READ_REG(hw, XOFFRXC);
-	temp_reg = IXGB_READ_REG(hw, XOFFTXC);
-	temp_reg = IXGB_READ_REG(hw, RJC);
+	IXGB_READ_REG(hw, TPRL);
+	IXGB_READ_REG(hw, TPRH);
+	IXGB_READ_REG(hw, GPRCL);
+	IXGB_READ_REG(hw, GPRCH);
+	IXGB_READ_REG(hw, BPRCL);
+	IXGB_READ_REG(hw, BPRCH);
+	IXGB_READ_REG(hw, MPRCL);
+	IXGB_READ_REG(hw, MPRCH);
+	IXGB_READ_REG(hw, UPRCL);
+	IXGB_READ_REG(hw, UPRCH);
+	IXGB_READ_REG(hw, VPRCL);
+	IXGB_READ_REG(hw, VPRCH);
+	IXGB_READ_REG(hw, JPRCL);
+	IXGB_READ_REG(hw, JPRCH);
+	IXGB_READ_REG(hw, GORCL);
+	IXGB_READ_REG(hw, GORCH);
+	IXGB_READ_REG(hw, TORL);
+	IXGB_READ_REG(hw, TORH);
+	IXGB_READ_REG(hw, RNBC);
+	IXGB_READ_REG(hw, RUC);
+	IXGB_READ_REG(hw, ROC);
+	IXGB_READ_REG(hw, RLEC);
+	IXGB_READ_REG(hw, CRCERRS);
+	IXGB_READ_REG(hw, ICBC);
+	IXGB_READ_REG(hw, ECBC);
+	IXGB_READ_REG(hw, MPC);
+	IXGB_READ_REG(hw, TPTL);
+	IXGB_READ_REG(hw, TPTH);
+	IXGB_READ_REG(hw, GPTCL);
+	IXGB_READ_REG(hw, GPTCH);
+	IXGB_READ_REG(hw, BPTCL);
+	IXGB_READ_REG(hw, BPTCH);
+	IXGB_READ_REG(hw, MPTCL);
+	IXGB_READ_REG(hw, MPTCH);
+	IXGB_READ_REG(hw, UPTCL);
+	IXGB_READ_REG(hw, UPTCH);
+	IXGB_READ_REG(hw, VPTCL);
+	IXGB_READ_REG(hw, VPTCH);
+	IXGB_READ_REG(hw, JPTCL);
+	IXGB_READ_REG(hw, JPTCH);
+	IXGB_READ_REG(hw, GOTCL);
+	IXGB_READ_REG(hw, GOTCH);
+	IXGB_READ_REG(hw, TOTL);
+	IXGB_READ_REG(hw, TOTH);
+	IXGB_READ_REG(hw, DC);
+	IXGB_READ_REG(hw, PLT64C);
+	IXGB_READ_REG(hw, TSCTC);
+	IXGB_READ_REG(hw, TSCTFC);
+	IXGB_READ_REG(hw, IBIC);
+	IXGB_READ_REG(hw, RFC);
+	IXGB_READ_REG(hw, LFC);
+	IXGB_READ_REG(hw, PFRC);
+	IXGB_READ_REG(hw, PFTC);
+	IXGB_READ_REG(hw, MCFRC);
+	IXGB_READ_REG(hw, MCFTC);
+	IXGB_READ_REG(hw, XONRXC);
+	IXGB_READ_REG(hw, XONTXC);
+	IXGB_READ_REG(hw, XOFFRXC);
+	IXGB_READ_REG(hw, XOFFTXC);
+	IXGB_READ_REG(hw, RJC);
 }
 
 /******************************************************************************
@@ -1161,18 +1157,13 @@ static void
 ixgb_optics_reset(struct ixgb_hw *hw)
 {
 	if (hw->phy_type == ixgb_phy_type_txn17401) {
-		u16 mdio_reg;
-
 		ixgb_write_phy_reg(hw,
 				   MDIO_CTRL1,
 				   IXGB_PHY_ADDRESS,
 				   MDIO_MMD_PMAPMD,
 				   MDIO_CTRL1_RESET);
 
-		mdio_reg = ixgb_read_phy_reg(hw,
-					     MDIO_CTRL1,
-					     IXGB_PHY_ADDRESS,
-					     MDIO_MMD_PMAPMD);
+		ixgb_read_phy_reg(hw, MDIO_CTRL1, IXGB_PHY_ADDRESS, MDIO_MMD_PMAPMD);
 	}
 }
 
-- 
2.28.0

