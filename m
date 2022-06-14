Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96CE54AE8A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355850AbiFNKfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242352AbiFNKev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:34:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE374483AB;
        Tue, 14 Jun 2022 03:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655202889; x=1686738889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=awxBFnZdTrqGiMfk6kKWEORK6fwCwt2P3Vhht1teC7o=;
  b=0Mj4yvbDp/tSrHJPYaQ5j4CRexIVc+i9KuxEmfN2Vxx+QE0L/c9/Ght9
   hKgnVjBPdHe96OYT6ic0TGMFanE+9kCQFJfkCyO858yfMFST4bHpqFARX
   MfQ4dsFGzwv/V8K6RSzQYZAig0E5TmxIjZ43Ir43PLqZOThB083bbkqkM
   Lpgv2yt+xZbL7JO/UlmxM53JpzMIBu4zznqqd+q0fXuPpmNtRpwzWImna
   NLXddYhczstvgpPPrxqysWoE2xCK1pBy4ebqmclZtNkCnH4ANBJpNOb2d
   3DlzMF2jCvs/wVxCGP/8xfhftGyw/BntvLQ8PkvrGCatddXBOv+kd/F89
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="177868417"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 03:34:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 03:34:49 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 03:34:45 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 4/5] net: lan743x: Add support to SGMII 1G and 2.5G
Date:   Tue, 14 Jun 2022 16:04:23 +0530
Message-ID: <20220614103424.58971-5-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to SGMII 1G and 2.5G for PCI11010/PCI11414 chips

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  |   6 +-
 drivers/net/ethernet/microchip/lan743x_main.c | 280 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h | 122 ++++++++
 3 files changed, 399 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index b591a7aea937..6562041a1ef9 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -155,8 +155,8 @@ static int lan743x_otp_write(struct lan743x_adapter *adapter, u32 offset,
 	return 0;
 }
 
-static int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter,
-				      u16 timeout)
+int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter,
+			       u16 timeout)
 {
 	u16 timeout_cnt = 0;
 	u32 val;
@@ -192,7 +192,7 @@ static int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter,
 	return 0;
 }
 
-static void lan743x_hs_syslock_release(struct lan743x_adapter *adapter)
+void lan743x_hs_syslock_release(struct lan743x_adapter *adapter)
 {
 	u32 val;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index e496769efb54..5afba2075d9c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -22,20 +22,36 @@
 #define MMD_ACCESS_WRITE	1
 #define MMD_ACCESS_READ		2
 #define MMD_ACCESS_READ_INC	3
+#define PCS_POWER_STATE_DOWN	0x6
+#define PCS_POWER_STATE_UP	0x4
 
 static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 {
 	u32 chip_rev;
+	u32 cfg_load;
+	u32 hw_cfg;
 	u32 strap;
+	int ret;
+
+	/* Timeout = 100 (i.e. 1 sec (10 msce * 100)) */
+	ret = lan743x_hs_syslock_acquire(adapter, 100);
+	if (ret < 0) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "Sys Lock acquire failed ret:%d\n", ret);
+		return;
+	}
 
-	strap = lan743x_csr_read(adapter, STRAP_READ);
-	if (strap & STRAP_READ_USE_SGMII_EN_) {
+	cfg_load = lan743x_csr_read(adapter, ETH_SYS_CONFIG_LOAD_STARTED_REG);
+	lan743x_hs_syslock_release(adapter);
+	hw_cfg = lan743x_csr_read(adapter, HW_CFG);
+
+	if (cfg_load & GEN_SYS_LOAD_STARTED_REG_ETH_ ||
+	    hw_cfg & HW_CFG_RST_PROTECT_) {
+		strap = lan743x_csr_read(adapter, STRAP_READ);
 		if (strap & STRAP_READ_SGMII_EN_)
 			adapter->is_sgmii_en = true;
 		else
 			adapter->is_sgmii_en = false;
-		netif_dbg(adapter, drv, adapter->netdev,
-			  "STRAP_READ: 0x%08X\n", strap);
 	} else {
 		chip_rev = lan743x_csr_read(adapter, FPGA_REV);
 		if (chip_rev) {
@@ -43,12 +59,12 @@ static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 				adapter->is_sgmii_en = true;
 			else
 				adapter->is_sgmii_en = false;
-			netif_dbg(adapter, drv, adapter->netdev,
-				  "FPGA_REV: 0x%08X\n", chip_rev);
 		} else {
 			adapter->is_sgmii_en = false;
 		}
 	}
+	netif_dbg(adapter, drv, adapter->netdev,
+		  "SGMII I/F %sable\n", adapter->is_sgmii_en ? "En" : "Dis");
 }
 
 static bool is_pci11x1x_chip(struct lan743x_adapter *adapter)
@@ -977,6 +993,250 @@ static int lan743x_sgmii_write(struct lan743x_adapter *adapter,
 	return ret;
 }
 
+static int lan743x_sgmii_mpll_set(struct lan743x_adapter *adapter,
+				  u16 baud)
+{
+	int mpllctrl0;
+	int mpllctrl1;
+	int miscctrl1;
+	int ret;
+
+	mpllctrl0 = lan743x_sgmii_read(adapter, MMD_VSPEC2,
+				       VR_MII_GEN2_4_MPLL_CTRL0);
+	if (mpllctrl0 < 0)
+		return mpllctrl0;
+
+	mpllctrl0 &= ~VR_MII_MPLL_CTRL0_USE_REFCLK_PAD_;
+	if (baud == VR_MII_BAUD_RATE_1P25GBPS) {
+		mpllctrl1 = VR_MII_MPLL_MULTIPLIER_100;
+		/* mpll_baud_clk/4 */
+		miscctrl1 = 0xA;
+	} else {
+		mpllctrl1 = VR_MII_MPLL_MULTIPLIER_125;
+		/* mpll_baud_clk/2 */
+		miscctrl1 = 0x5;
+	}
+
+	ret = lan743x_sgmii_write(adapter, MMD_VSPEC2,
+				  VR_MII_GEN2_4_MPLL_CTRL0, mpllctrl0);
+	if (ret < 0)
+		return ret;
+
+	ret = lan743x_sgmii_write(adapter, MMD_VSPEC2,
+				  VR_MII_GEN2_4_MPLL_CTRL1, mpllctrl1);
+	if (ret < 0)
+		return ret;
+
+	return lan743x_sgmii_write(adapter, MMD_VSPEC2,
+				  VR_MII_GEN2_4_MISC_CTRL1, miscctrl1);
+}
+
+static int lan743x_sgmii_2_5G_mode_set(struct lan743x_adapter *adapter,
+				       bool enable)
+{
+	if (enable)
+		return lan743x_sgmii_mpll_set(adapter,
+					      VR_MII_BAUD_RATE_3P125GBPS);
+	else
+		return lan743x_sgmii_mpll_set(adapter,
+					      VR_MII_BAUD_RATE_1P25GBPS);
+}
+
+static int lan743x_is_sgmii_2_5G_mode(struct lan743x_adapter *adapter,
+				      bool *status)
+{
+	int ret;
+
+	ret = lan743x_sgmii_read(adapter, MMD_VSPEC2,
+				 VR_MII_GEN2_4_MPLL_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	if (ret == VR_MII_MPLL_MULTIPLIER_125 ||
+	    ret == VR_MII_MPLL_MULTIPLIER_50)
+		*status = true;
+	else
+		*status = false;
+
+	return 0;
+}
+
+static int lan743x_sgmii_aneg_update(struct lan743x_adapter *adapter)
+{
+	enum lan743x_sgmii_lsd lsd = adapter->sgmii_lsd;
+	int sr_mii_ctrl;
+	int dgt_ctrl;
+	int an_ctrl;
+	int ret;
+
+	if (lsd == LINK_2500_MASTER || lsd == LINK_2500_SLAVE)
+		/* Switch to 2.5 Gbps */
+		ret = lan743x_sgmii_2_5G_mode_set(adapter, true);
+	else
+		/* Switch to 10/100/1000 Mbps clock */
+		ret = lan743x_sgmii_2_5G_mode_set(adapter, false);
+	if (ret < 0)
+		return ret;
+
+	/* Enable SGMII Auto NEG */
+	sr_mii_ctrl = lan743x_sgmii_read(adapter, MMD_VSPEC2, SR_MII_CTRL);
+	if (sr_mii_ctrl < 0)
+		return sr_mii_ctrl;
+
+	an_ctrl = lan743x_sgmii_read(adapter, MMD_VSPEC2, VR_MII_AN_CTRL);
+	if (an_ctrl < 0)
+		return an_ctrl;
+
+	dgt_ctrl = lan743x_sgmii_read(adapter, MMD_VSPEC2, VR_MII_DIG_CTRL1);
+	if (dgt_ctrl < 0)
+		return dgt_ctrl;
+
+	if (lsd == LINK_2500_MASTER || lsd == LINK_2500_SLAVE) {
+		sr_mii_ctrl &= ~(SR_MII_CTRL_AN_ENABLE_ |
+				SR_MII_CTRL_RESTART_AN_);
+		sr_mii_ctrl &= ~SR_MII_CTRL_SS13_;
+		sr_mii_ctrl |= SR_MII_CTRL_SS6_;
+		dgt_ctrl |= VR_MII_DIG_CTRL1_CL37_TMR_OVR_RIDE_;
+		dgt_ctrl &= ~VR_MII_DIG_CTRL1_MAC_AUTO_SW_;
+		/* In order for Auto-Negotiation to operate properly at
+		 * 2.5 Gbps the 1.6ms link timer values must be adjusted
+		 * The VR_MII_LINK_TIMER_CTRL Register must be set to
+		 * 16'h7A1 and The CL37_TMR_OVR_RIDE bit of the
+		 * VR_MII_DIG_CTRL1 Register set to 1
+		 */
+		ret = lan743x_sgmii_write(adapter, MMD_VSPEC2,
+					  VR_MII_LINK_TIMER_CTRL, 0x7A1);
+		if (ret < 0)
+			return ret;
+	} else {
+		sr_mii_ctrl |= (SR_MII_CTRL_AN_ENABLE_ |
+				SR_MII_CTRL_RESTART_AN_);
+		an_ctrl &= ~VR_MII_AN_CTRL_SGMII_LINK_STS_;
+		dgt_ctrl &= ~VR_MII_DIG_CTRL1_CL37_TMR_OVR_RIDE_;
+		dgt_ctrl |= VR_MII_DIG_CTRL1_MAC_AUTO_SW_;
+	}
+
+	ret = lan743x_sgmii_write(adapter, MMD_VSPEC2, SR_MII_CTRL,
+				  sr_mii_ctrl);
+	if (ret < 0)
+		return ret;
+
+	ret = lan743x_sgmii_write(adapter, MMD_VSPEC2,
+				  VR_MII_DIG_CTRL1, dgt_ctrl);
+	if (ret < 0)
+		return ret;
+
+	return lan743x_sgmii_write(adapter, MMD_VSPEC2,
+				  VR_MII_AN_CTRL, an_ctrl);
+}
+
+static int lan743x_pcs_seq_state(struct lan743x_adapter *adapter, u8 state)
+{
+	u8 wait_cnt = 0;
+	u32 dig_sts;
+
+	do {
+		dig_sts = lan743x_sgmii_read(adapter, MMD_VSPEC2, VR_MII_DIG_STS);
+		if (((dig_sts & VR_MII_DIG_STS_PSEQ_STATE_MASK_) >>
+		      VR_MII_DIG_STS_PSEQ_STATE_POS_) == state)
+			break;
+		usleep_range(1000, 2000);
+	} while (wait_cnt++ < 10);
+
+	if (wait_cnt >= 10)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int lan743x_sgmii_config(struct lan743x_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct phy_device *phydev = netdev->phydev;
+	enum lan743x_sgmii_lsd lsd = POWER_DOWN;
+	u32 sr_mii_ctl;
+	bool status;
+	int ret;
+
+	switch (phydev->speed) {
+	case SPEED_2500:
+		if (phydev->master_slave_state ==
+		    MASTER_SLAVE_STATE_MASTER)
+			lsd = LINK_2500_MASTER;
+		else
+			lsd = LINK_2500_SLAVE;
+		break;
+	case SPEED_1000:
+		if (phydev->master_slave_state ==
+		    MASTER_SLAVE_STATE_MASTER)
+			lsd = LINK_1000_MASTER;
+		else
+			lsd = LINK_1000_SLAVE;
+		break;
+	case SPEED_100:
+		if (phydev->duplex)
+			lsd = LINK_100FD;
+		else
+			lsd = LINK_100HD;
+		break;
+	case SPEED_10:
+		if (phydev->duplex)
+			lsd = LINK_10FD;
+		else
+			lsd = LINK_10HD;
+		break;
+	default:
+		netif_err(adapter, drv, adapter->netdev,
+			  "Invalid speed %d\n", phydev->speed);
+		return -EINVAL;
+	}
+
+	adapter->sgmii_lsd = lsd;
+	ret = lan743x_sgmii_aneg_update(adapter);
+	if (ret < 0) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "error %d SGMII cfg failed\n", ret);
+		return ret;
+	}
+
+	ret = lan743x_is_sgmii_2_5G_mode(adapter, &status);
+	if (ret < 0) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "erro %d SGMII get mode failed\n", ret);
+		return ret;
+	}
+
+	if (status)
+		netif_dbg(adapter, drv, adapter->netdev,
+			  "SGMII 2.5G mode enable\n");
+	else
+		netif_dbg(adapter, drv, adapter->netdev,
+			  "SGMII 1G mode enable\n");
+
+	/* SGMII/1000/2500BASE-X PCS power down */
+	sr_mii_ctl = lan743x_sgmii_read(adapter, MMD_VSPEC2, SR_MII_CTRL);
+	sr_mii_ctl |= SR_MII_CTRL_LPM_;
+	ret = lan743x_sgmii_write(adapter, MMD_VSPEC2, SR_MII_CTRL, sr_mii_ctl);
+	if (ret < 0)
+		return ret;
+
+	ret = lan743x_pcs_seq_state(adapter, PCS_POWER_STATE_DOWN);
+	if (ret < 0)
+		return ret;
+
+	/* SGMII/1000/2500BASE-X PCS power up */
+	sr_mii_ctl &= ~SR_MII_CTRL_LPM_;
+	ret = lan743x_sgmii_write(adapter, MMD_VSPEC2, SR_MII_CTRL, sr_mii_ctl);
+	if (ret < 0)
+		return ret;
+
+	ret = lan743x_pcs_seq_state(adapter, PCS_POWER_STATE_UP);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static void lan743x_mac_set_address(struct lan743x_adapter *adapter,
 				    u8 *addr)
 {
@@ -1192,6 +1452,10 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 			data |= MAC_CR_CFG_H_;
 			data &= ~MAC_CR_CFG_L_;
 		break;
+		case SPEED_2500:
+			data |= MAC_CR_CFG_H_;
+			data |= MAC_CR_CFG_L_;
+		break;
 		}
 		lan743x_csr_write(adapter, MAC_CR, data);
 
@@ -1203,6 +1467,10 @@ static void lan743x_phy_link_status_change(struct net_device *netdev)
 		lan743x_phy_update_flowcontrol(adapter, local_advertisement,
 					       remote_advertisement);
 		lan743x_ptp_update_latency(adapter, phydev->speed);
+		if (phydev->interface == PHY_INTERFACE_MODE_SGMII ||
+		    phydev->interface == PHY_INTERFACE_MODE_1000BASEX ||
+		    phydev->interface == PHY_INTERFACE_MODE_2500BASEX)
+			lan743x_sgmii_config(adapter);
 	}
 }
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 4268b1d56090..b6acd628de2b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -97,6 +97,11 @@
 #define CONFIG_REG_ADDR_BASE		(0x0000)
 #define ETH_EEPROM_REG_ADDR_BASE	(0x0E00)
 #define ETH_OTP_REG_ADDR_BASE		(0x1000)
+#define GEN_SYS_CONFIG_LOAD_STARTED_REG	(0x0078)
+#define ETH_SYS_CONFIG_LOAD_STARTED_REG (ETH_SYS_REG_ADDR_BASE + \
+					 CONFIG_REG_ADDR_BASE + \
+					 GEN_SYS_CONFIG_LOAD_STARTED_REG)
+#define GEN_SYS_LOAD_STARTED_REG_ETH_	BIT(4)
 #define SYS_LOCK_REG			(0x00A0)
 #define SYS_LOCK_REG_MAIN_LOCK_		BIT(7)
 #define SYS_LOCK_REG_GEN_PERI_LOCK_	BIT(5)
@@ -304,6 +309,104 @@
 #define SGMII_CTL_LINK_STATUS_SOURCE_	BIT(8)
 #define SGMII_CTL_SGMII_POWER_DN_	BIT(1)
 
+/* MMD Device IDs */
+#define STD_DEVID			(0x0)
+#define MMD_PMAPMD			(0x1)
+#define MMD_PCS				(0x3)
+#define MMD_ANEG			(0x7)
+#define MMD_VSPEC1			(0x1E)
+#define MMD_VSPEC2			(0x1F)
+
+/* Vendor Specific SGMII MMD details */
+#define SR_MII_DEV_ID1			0x0002
+#define SR_MII_DEV_ID2			0x0003
+#define SR_VSMMD_PCS_ID1		0x0004
+#define SR_VSMMD_PCS_ID2		0x0005
+#define SR_VSMMD_STS			0x0008
+#define SR_VSMMD_CTRL			0x0009
+
+#define SR_MII_CTRL			0x0000
+#define SR_MII_CTRL_RST_		BIT(15)
+#define SR_MII_CTRL_LBE_		BIT(14)
+#define SR_MII_CTRL_SS13_		BIT(13)
+#define SR_MII_CTRL_AN_ENABLE_		BIT(12)
+#define SR_MII_CTRL_LPM_		BIT(11)
+#define SR_MII_CTRL_RESTART_AN_		BIT(9)
+#define SR_MII_CTRL_DUPLEX_MODE_	BIT(8)
+#define SR_MII_CTRL_SS6_		BIT(6)
+#define SR_MII_STS			0x0001
+#define SR_MII_STS_ABL100T4_		BIT(15)
+#define SR_MII_STS_FD100ABL_		BIT(14)
+#define SR_MII_STS_HD100ABL_		BIT(13)
+#define SR_MII_STS_FD10ABL_		BIT(12)
+#define SR_MII_STS_HD10ABL_		BIT(11)
+#define SR_MII_STS_FD100T_		BIT(10)
+#define SR_MII_STS_HD100T_		BIT(9)
+#define SR_MII_STS_EXT_STS_ABL_		BIT(8)
+#define SR_MII_STS_UN_DIR_ABL_		BIT(7)
+#define SR_MII_STS_MF_PRE_SUP_		BIT(6)
+#define SR_MII_STS_AN_CMPL_		BIT(5)
+#define SR_MII_STS_RF_			BIT(4)
+#define SR_MII_STS_AN_ABL_		BIT(3)
+#define SR_MII_STS_LINK_STS_		BIT(2)
+#define SR_MII_STS_EXT_REG_CAP_		BIT(0)
+#define SR_MII_AN_ADV			0x0004
+#define SR_MII_LP_BABL			0x0005
+
+#define VR_MII_DIG_CTRL1			0x8000
+#define VR_MII_DIG_CTRL1_VR_RST_		BIT(15)
+#define VR_MII_DIG_CTRL1_R2TLBE_		BIT(14)
+#define VR_MII_DIG_CTRL1_EN_VSMMD1_		BIT(13)
+#define VR_MII_DIG_CTRL1_CS_EN_			BIT(10)
+#define VR_MII_DIG_CTRL1_MAC_AUTO_SW_		BIT(9)
+#define VR_MII_DIG_CTRL1_INIT_			BIT(8)
+#define VR_MII_DIG_CTRL1_DTXLANED_0_		BIT(4)
+#define VR_MII_DIG_CTRL1_CL37_TMR_OVR_RIDE_	BIT(3)
+#define VR_MII_DIG_CTRL1_EN_2_5G_MODE_		BIT(2)
+#define VR_MII_DIG_CTRL1_BYP_PWRUP_		BIT(1)
+#define VR_MII_DIG_CTRL1_PHY_MODE_CTRL_		BIT(0)
+#define VR_MII_AN_CTRL				0x8001
+#define VR_MII_AN_CTRL_MII_CTRL_		BIT(8)
+#define VR_MII_AN_CTRL_SGMII_LINK_STS_		BIT(4)
+#define VR_MII_AN_CTRL_TX_CONFIG_		BIT(3)
+#define VR_MII_AN_CTRL_1000BASE_X_		(0)
+#define VR_MII_AN_CTRL_SGMII_MODE_		(2)
+#define VR_MII_AN_CTRL_QSGMII_MODE_		(3)
+#define VR_MII_AN_CTRL_PCS_MODE_SHIFT_		(1)
+#define VR_MII_AN_CTRL_PCS_MODE_MASK_		GENMASK(2, 1)
+#define VR_MII_AN_CTRL_MII_AN_INTR_EN_		BIT(0)
+#define VR_MII_AN_INTR_STS			0x8002
+#define VR_MII_AN_INTR_STS_LINK_UP_		BIT(4)
+#define VR_MII_AN_INTR_STS_SPEED_MASK_		GENMASK(3, 2)
+#define VR_MII_AN_INTR_STS_1000_MBPS_		BIT(3)
+#define VR_MII_AN_INTR_STS_100_MBPS_		BIT(2)
+#define VR_MII_AN_INTR_STS_10_MBPS_		(0)
+#define VR_MII_AN_INTR_STS_FDX_			BIT(1)
+#define VR_MII_AN_INTR_STS_CL37_ANCMPLT_INTR_	BIT(0)
+
+#define VR_MII_LINK_TIMER_CTRL			0x800A
+#define VR_MII_DIG_STS                          0x8010
+#define VR_MII_DIG_STS_PSEQ_STATE_MASK_         GENMASK(4, 2)
+#define VR_MII_DIG_STS_PSEQ_STATE_POS_          (2)
+#define VR_MII_GEN2_4_MPLL_CTRL0		0x8078
+#define VR_MII_MPLL_CTRL0_REF_CLK_DIV2_		BIT(12)
+#define VR_MII_MPLL_CTRL0_USE_REFCLK_PAD_	BIT(4)
+#define VR_MII_GEN2_4_MPLL_CTRL1		0x8079
+#define VR_MII_MPLL_CTRL1_MPLL_MULTIPLIER_	GENMASK(6, 0)
+#define VR_MII_BAUD_RATE_3P125GBPS		(3125)
+#define VR_MII_BAUD_RATE_1P25GBPS		(1250)
+#define VR_MII_MPLL_MULTIPLIER_125		(125)
+#define VR_MII_MPLL_MULTIPLIER_100		(100)
+#define VR_MII_MPLL_MULTIPLIER_50		(50)
+#define VR_MII_MPLL_MULTIPLIER_40		(40)
+#define VR_MII_GEN2_4_MISC_CTRL1		0x809A
+#define VR_MII_CTRL1_RX_RATE_0_MASK_		GENMASK(3, 2)
+#define VR_MII_CTRL1_RX_RATE_0_SHIFT_		(2)
+#define VR_MII_CTRL1_TX_RATE_0_MASK_		GENMASK(1, 0)
+#define VR_MII_MPLL_BAUD_CLK			(0)
+#define VR_MII_MPLL_BAUD_CLK_DIV_2		(1)
+#define VR_MII_MPLL_BAUD_CLK_DIV_4		(2)
+
 #define INT_STS				(0x780)
 #define INT_BIT_DMA_RX_(channel)	BIT(24 + (channel))
 #define INT_BIT_ALL_RX_			(0x0F000000)
@@ -925,6 +1028,21 @@ struct lan743x_rx {
 	struct sk_buff *skb_head, *skb_tail;
 };
 
+/* SGMII Link Speed Duplex status */
+enum lan743x_sgmii_lsd {
+	POWER_DOWN = 0,
+	LINK_DOWN,
+	ANEG_BUSY,
+	LINK_10HD,
+	LINK_10FD,
+	LINK_100HD,
+	LINK_100FD,
+	LINK_1000_MASTER,
+	LINK_1000_SLAVE,
+	LINK_2500_MASTER,
+	LINK_2500_SLAVE
+};
+
 struct lan743x_adapter {
 	struct net_device       *netdev;
 	struct mii_bus		*mdiobus;
@@ -952,6 +1070,8 @@ struct lan743x_adapter {
 	bool			eth_syslock_en;
 	u32			eth_syslock_acquire_cnt;
 	struct mutex		sgmii_rw_lock;
+	/* SGMII Link Speed & Duplex status */
+	enum			lan743x_sgmii_lsd sgmii_lsd;
 	u8			max_tx_channels;
 	u8			used_tx_channels;
 	u8			max_vector_count;
@@ -1071,5 +1191,7 @@ struct lan743x_rx_buffer_info {
 
 u32 lan743x_csr_read(struct lan743x_adapter *adapter, int offset);
 void lan743x_csr_write(struct lan743x_adapter *adapter, int offset, u32 data);
+int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter, u16 timeout);
+void lan743x_hs_syslock_release(struct lan743x_adapter *adapter);
 
 #endif /* _LAN743X_H */
-- 
2.25.1

