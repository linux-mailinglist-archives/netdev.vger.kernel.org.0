Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3725320EAEB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgF3B2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:28:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:52168 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgF3B1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:54 -0400
IronPort-SDR: JVEYe+KLvmvSg826mFa1Y5jxfoO5mSGHT9iAd8PCVkLKKSlZr+Nhvm4oc6dP6gHutGuV4QR8GT
 UYHhJ8t70qfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144305921"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144305921"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:50 -0700
IronPort-SDR: 2kJLTCR6AR6ixnA2JOHzLWalc/bbUXDJtDdSIe8fyeLI1L4SXZLV5rKB5ioV2uPdAJQdrOY10R
 +rk7f6DER5/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017693"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andre Guedes <andre.guedes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 01/13] igc: Add initial EEE support
Date:   Mon, 29 Jun 2020 18:27:36 -0700
Message-Id: <20200630012748.518705-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

IEEE802.3az-2010 Energy Efficient Ethernet has been
approved as standard (September 2010) and the driver
can enable and disable it via ethtool.
Disable the feature by default on parts which support it.
Add enable/disable eee options.
tx-lpi, tx-timer and advertise not supported yet.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Reviewed-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  4 +
 drivers/net/ethernet/intel/igc/igc_defines.h | 10 +++
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 95 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_hw.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_i225.c    | 56 ++++++++++++
 drivers/net/ethernet/intel/igc/igc_i225.h    |  2 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 16 ++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  5 ++
 8 files changed, 189 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index a2d260165df3..9c57afad6afe 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -117,6 +117,9 @@ struct igc_ring {
 struct igc_adapter {
 	struct net_device *netdev;
 
+	struct ethtool_eee eee;
+	u16 eee_advert;
+
 	unsigned long state;
 	unsigned int flags;
 	unsigned int num_q_vectors;
@@ -255,6 +258,7 @@ extern char igc_driver_name[];
 #define IGC_FLAG_MEDIA_RESET		BIT(10)
 #define IGC_FLAG_MAS_ENABLE		BIT(12)
 #define IGC_FLAG_HAS_MSIX		BIT(13)
+#define IGC_FLAG_EEE			BIT(14)
 #define IGC_FLAG_VLAN_PROMISC		BIT(15)
 #define IGC_FLAG_RX_LEGACY		BIT(16)
 #define IGC_FLAG_TSN_QBV_ENABLED	BIT(17)
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 186deb1d9375..ee7fa1c062a0 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -511,4 +511,14 @@
 /* Maximum size of the MTA register table in all supported adapters */
 #define MAX_MTA_REG			128
 
+/* EEE defines */
+#define IGC_IPCNFG_EEE_2_5G_AN		0x00000010 /* IPCNFG EEE Ena 2.5G AN */
+#define IGC_IPCNFG_EEE_1G_AN		0x00000008 /* IPCNFG EEE Ena 1G AN */
+#define IGC_IPCNFG_EEE_100M_AN		0x00000004 /* IPCNFG EEE Ena 100M AN */
+#define IGC_EEER_EEE_NEG		0x20000000 /* EEE capability nego */
+#define IGC_EEER_TX_LPI_EN		0x00010000 /* EEER Tx LPI Enable */
+#define IGC_EEER_RX_LPI_EN		0x00020000 /* EEER Rx LPI Enable */
+#define IGC_EEER_LPI_FC			0x00040000 /* EEER Ena on Flow Cntrl */
+#define IGC_EEE_SU_LPI_CLK_STP		0x00800000 /* EEE LPI Clock Stop */
+
 #endif /* _IGC_DEFINES_H_ */
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 735f3fb47dca..ac331116ea08 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -4,6 +4,7 @@
 /* ethtool support for igc */
 #include <linux/if_vlan.h>
 #include <linux/pm_runtime.h>
+#include <linux/mdio.h>
 
 #include "igc.h"
 #include "igc_diag.h"
@@ -1548,6 +1549,98 @@ static int igc_ethtool_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 	return 0;
 }
 
+static int igc_ethtool_get_eee(struct net_device *netdev,
+			       struct ethtool_eee *edata)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	u32 eeer;
+
+	if (hw->dev_spec._base.eee_enable)
+		edata->advertised =
+			mmd_eee_adv_to_ethtool_adv_t(adapter->eee_advert);
+
+	*edata = adapter->eee;
+	edata->supported = SUPPORTED_Autoneg;
+
+	eeer = rd32(IGC_EEER);
+
+	/* EEE status on negotiated link */
+	if (eeer & IGC_EEER_EEE_NEG)
+		edata->eee_active = true;
+
+	if (eeer & IGC_EEER_TX_LPI_EN)
+		edata->tx_lpi_enabled = true;
+
+	edata->eee_enabled = hw->dev_spec._base.eee_enable;
+
+	edata->advertised = SUPPORTED_Autoneg;
+	edata->lp_advertised = SUPPORTED_Autoneg;
+
+	/* Report correct negotiated EEE status for devices that
+	 * wrongly report EEE at half-duplex
+	 */
+	if (adapter->link_duplex == HALF_DUPLEX) {
+		edata->eee_enabled = false;
+		edata->eee_active = false;
+		edata->tx_lpi_enabled = false;
+		edata->advertised &= ~edata->advertised;
+	}
+
+	return 0;
+}
+
+static int igc_ethtool_set_eee(struct net_device *netdev,
+			       struct ethtool_eee *edata)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	struct ethtool_eee eee_curr;
+	s32 ret_val;
+
+	memset(&eee_curr, 0, sizeof(struct ethtool_eee));
+
+	ret_val = igc_ethtool_get_eee(netdev, &eee_curr);
+	if (ret_val) {
+		netdev_err(netdev,
+			   "Problem setting EEE advertisement options\n");
+		return -EINVAL;
+	}
+
+	if (eee_curr.eee_enabled) {
+		if (eee_curr.tx_lpi_enabled != edata->tx_lpi_enabled) {
+			netdev_err(netdev,
+				   "Setting EEE tx-lpi is not supported\n");
+			return -EINVAL;
+		}
+
+		/* Tx LPI timer is not implemented currently */
+		if (edata->tx_lpi_timer) {
+			netdev_err(netdev,
+				   "Setting EEE Tx LPI timer is not supported\n");
+			return -EINVAL;
+		}
+	} else if (!edata->eee_enabled) {
+		netdev_err(netdev,
+			   "Setting EEE options are not supported with EEE disabled\n");
+		return -EINVAL;
+	}
+
+	adapter->eee_advert = ethtool_adv_to_mmd_eee_adv_t(edata->advertised);
+	if (hw->dev_spec._base.eee_enable != edata->eee_enabled) {
+		hw->dev_spec._base.eee_enable = edata->eee_enabled;
+		adapter->flags |= IGC_FLAG_EEE;
+
+		/* reset link */
+		if (netif_running(netdev))
+			igc_reinit_locked(adapter);
+		else
+			igc_reset(adapter);
+	}
+
+	return 0;
+}
+
 static int igc_ethtool_begin(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1829,6 +1922,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.set_channels		= igc_ethtool_set_channels,
 	.get_priv_flags		= igc_ethtool_get_priv_flags,
 	.set_priv_flags		= igc_ethtool_set_priv_flags,
+	.get_eee		= igc_ethtool_get_eee,
+	.set_eee		= igc_ethtool_set_eee,
 	.begin			= igc_ethtool_begin,
 	.complete		= igc_ethtool_complete,
 	.get_link_ksettings	= igc_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index af34ae310327..2ab7d9fab6af 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -191,6 +191,7 @@ struct igc_fc_info {
 
 struct igc_dev_spec_base {
 	bool clear_semaphore_once;
+	bool eee_enable;
 };
 
 struct igc_hw {
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index c25f555aaf82..3a4e982edb67 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -488,3 +488,59 @@ s32 igc_init_nvm_params_i225(struct igc_hw *hw)
 	}
 	return 0;
 }
+
+/**
+ *  igc_set_eee_i225 - Enable/disable EEE support
+ *  @hw: pointer to the HW structure
+ *  @adv2p5G: boolean flag enabling 2.5G EEE advertisement
+ *  @adv1G: boolean flag enabling 1G EEE advertisement
+ *  @adv100M: boolean flag enabling 100M EEE advertisement
+ *
+ *  Enable/disable EEE based on setting in dev_spec structure.
+ **/
+s32 igc_set_eee_i225(struct igc_hw *hw, bool adv2p5G, bool adv1G,
+		     bool adv100M)
+{
+	u32 ipcnfg, eeer;
+
+	ipcnfg = rd32(IGC_IPCNFG);
+	eeer = rd32(IGC_EEER);
+
+	/* enable or disable per user setting */
+	if (hw->dev_spec._base.eee_enable) {
+		u32 eee_su = rd32(IGC_EEE_SU);
+
+		if (adv100M)
+			ipcnfg |= IGC_IPCNFG_EEE_100M_AN;
+		else
+			ipcnfg &= ~IGC_IPCNFG_EEE_100M_AN;
+
+		if (adv1G)
+			ipcnfg |= IGC_IPCNFG_EEE_1G_AN;
+		else
+			ipcnfg &= ~IGC_IPCNFG_EEE_1G_AN;
+
+		if (adv2p5G)
+			ipcnfg |= IGC_IPCNFG_EEE_2_5G_AN;
+		else
+			ipcnfg &= ~IGC_IPCNFG_EEE_2_5G_AN;
+
+		eeer |= (IGC_EEER_TX_LPI_EN | IGC_EEER_RX_LPI_EN |
+			 IGC_EEER_LPI_FC);
+
+		/* This bit should not be set in normal operation. */
+		if (eee_su & IGC_EEE_SU_LPI_CLK_STP)
+			hw_dbg("LPI Clock Stop Bit should not be set!\n");
+	} else {
+		ipcnfg &= ~(IGC_IPCNFG_EEE_2_5G_AN | IGC_IPCNFG_EEE_1G_AN |
+			    IGC_IPCNFG_EEE_100M_AN);
+		eeer &= ~(IGC_EEER_TX_LPI_EN | IGC_EEER_RX_LPI_EN |
+			  IGC_EEER_LPI_FC);
+	}
+	wr32(IGC_IPCNFG, ipcnfg);
+	wr32(IGC_EEER, eeer);
+	rd32(IGC_IPCNFG);
+	rd32(IGC_EEER);
+
+	return IGC_SUCCESS;
+}
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.h b/drivers/net/ethernet/intel/igc/igc_i225.h
index 7b66e1f9c0e6..04759e076a9e 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.h
+++ b/drivers/net/ethernet/intel/igc/igc_i225.h
@@ -9,5 +9,7 @@ void igc_release_swfw_sync_i225(struct igc_hw *hw, u16 mask);
 
 s32 igc_init_nvm_params_i225(struct igc_hw *hw);
 bool igc_get_flash_presence_i225(struct igc_hw *hw);
+s32 igc_set_eee_i225(struct igc_hw *hw, bool adv2p5G, bool adv1G,
+		     bool adv100M);
 
 #endif
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c2f41a558fd6..7e4d56c7b4c4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -102,6 +102,9 @@ void igc_reset(struct igc_adapter *adapter)
 	if (hw->mac.ops.init_hw(hw))
 		netdev_err(dev, "Error on hardware initialization\n");
 
+	/* Re-establish EEE setting */
+	igc_set_eee_i225(hw, true, true, true);
+
 	if (!netif_running(adapter->netdev))
 		igc_power_down_link(adapter);
 
@@ -4252,6 +4255,15 @@ static void igc_watchdog_task(struct work_struct *work)
 				    (ctrl & IGC_CTRL_RFCE) ?  "RX" :
 				    (ctrl & IGC_CTRL_TFCE) ?  "TX" : "None");
 
+			/* disable EEE if enabled */
+			if ((adapter->flags & IGC_FLAG_EEE) &&
+			    adapter->link_duplex == HALF_DUPLEX) {
+				netdev_info(netdev,
+					    "EEE Disabled: unsupported at half duplex. Re-enable using ethtool when at full duplex\n");
+				adapter->hw.dev_spec._base.eee_enable = false;
+				adapter->flags &= ~IGC_FLAG_EEE;
+			}
+
 			/* check if SmartSpeed worked */
 			igc_check_downshift(hw);
 			if (phy->speed_downgraded)
@@ -5182,6 +5194,10 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);
 
 	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NO_DIRECT_COMPLETE);
+	/* Disable EEE for internal PHY devices */
+	hw->dev_spec._base.eee_enable = false;
+	adapter->flags &= ~IGC_FLAG_EEE;
+	igc_set_eee_i225(hw, false, false, false);
 
 	pm_runtime_put_noidle(&pdev->dev);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 232e82dec62e..75e040a5d46f 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -248,6 +248,11 @@
 /* Wake Up packet memory */
 #define IGC_WUPM_REG(_i)	(0x05A00 + ((_i) * 4))
 
+/* Energy Efficient Ethernet "EEE" registers */
+#define IGC_EEER	0x0E30 /* Energy Efficient Ethernet "EEE"*/
+#define IGC_IPCNFG	0x0E38 /* Internal PHY Configuration */
+#define IGC_EEE_SU	0x0E34 /* EEE Setup */
+
 /* forward declaration */
 struct igc_hw;
 u32 igc_rd32(struct igc_hw *hw, u32 reg);
-- 
2.26.2

