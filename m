Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300161B8A3C
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 02:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgDZAJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 20:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgDZAJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 20:09:01 -0400
X-Greylist: delayed 1472 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Apr 2020 17:09:01 PDT
Received: from wp148.webpack.hosteurope.de (wp148.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:849b::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E901C061A0C;
        Sat, 25 Apr 2020 17:09:01 -0700 (PDT)
Received: from ip1f126570.dynamic.kabel-deutschland.de ([31.18.101.112] helo=localhost.localdomain); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1jSUSw-0001JP-AC; Sun, 26 Apr 2020 01:44:10 +0200
From:   Roelof Berg <rberg@berg-solutions.de>
Cc:     andrew@lunn.ch, rberg@berg-solutions.de,
        "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: Added fixed_phy support
Date:   Sun, 26 Apr 2020 01:43:18 +0200
Message-Id: <20200425234320.32588-1-rberg@berg-solutions.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <rberg@berg-solutions.de>
References: <rberg@berg-solutions.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1587859741;678ab4ff;
X-HE-SMSGID: 1jSUSw-0001JP-AC
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilizing the Linux fixed_phy layer allows a direct MII connection between
the lan7431 and a MII remote peer without any phy in between. We added a
section to .config that allows activating the linux fixed_phy layer in
lan743x. In fixed_phy mode there is no auto-negotiation, therefore the
baud rate and duplex mode needs to be configured by the user in .config
as well. For convenience also the MII mode can be configured now in
.config, independent from the activation of fixed_phy. The default
behavior ist to leave the MII mode unchanged (e.g. EEPROM configured).

Andrew Lunn kindly recommended to use phylink instead of fixed_phy. I
agree that this'd be better, unfortunately I have no test hardware here
that is equipped with a phy. Hence I used fixed_phy because this allows
me to create a patch that is 100%ly free fom side-effects to existing
systems that use a phy, when the new .config items remain untouched.

Test reproduction / application note:

1) The new .config settings baud, duplex and MII-mode need to be mirrored
by the user in the remote MII peer's configuration. For example a
Microchip KSZ9893 switch as a remote peer can be configured by resistors
to use the same baud/duplex/MII-mode as boot default.

2) In our setup (AE-LAN7431-KSZ9893) it was necessary to program the OTP
or EEPROM to activate the 125 MHz Clock of lan743x by:
ethtool -E enp1s0 magic 0x74a5 offset 0x1b value 0x24
ethtool -E enp1s0 magic 0x74a5 offset 0x1c value 0x2e
(Plus full EEPROM/OTP configuration with magic in byte 0.)

Signed-off-by: Roelof Berg <rberg@berg-solutions.de>
---
 drivers/net/ethernet/microchip/Kconfig        |  77 ++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c | 107 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h |   4 +
 3 files changed, 186 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 45fe41f3d9f3..642ef0f5208f 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -42,7 +42,7 @@ config ENCX24J600
       To compile this driver as a module, choose M here. The module will be
       called encx24j600.
 
-config LAN743X
+menuconfig LAN743X
 	tristate "LAN743x support"
 	depends on PCI
 	select PHYLIB
@@ -53,4 +53,79 @@ config LAN743X
 	  To compile this driver as a module, choose M here. The module will be
 	  called lan743x.
 
+# All the following symbols are dependent on LAN743X - do not repeat
+# that for each of the symbols.
+if LAN743X
+
+choice LAN743x_MII_MODE
+	prompt "MII operation mode"
+	default LAN743x_MII_MODE_DEFAULT
+	depends on LAN743X
+	help
+	 Defines the R/G/MII operation mode of the MAC of lan743.
+
+config LAN743x_MII_MODE_DEFAULT
+	bool "Device default"
+	help
+	 The existing internal device configuration, which may have come from
+	 EEPROM or OTP, will remain unchanged.
+
+config LAN743x_MII_MODE_RGMII
+	bool "RGMII"
+	help
+	 RGMII (Reduced GMII) will be enabled when the driver is loaded.
+
+config LAN743x_MII_MODE_GMII
+	bool "G/MII"
+	help
+	 GMII (in case of 100 mbit) or MII (in case of 10 mbit) will be enabled when
+	 the driver is loaded.
+
+endchoice
+
+config LAN743X_FIXED_PHY
+	bool "Direct R/G/MII connection without phy."
+	default n
+	select FIXED_PHY
+	help
+	 Direct R/G/MII connection to a remote MII device wo. any PHY in between.
+	 No mdio bus will be used in this case and no auto-negotiation takes place.
+	 The configuration settings below need to mirror the configuration of the
+	 remote MII device.
+
+choice
+	prompt "Bus speed"
+	default LAN743X_FIXED_PHY_SPEED_1000_MBIT
+	depends on LAN743X_FIXED_PHY
+	help
+	 Speed on the R/G/MII bus. This setting needs to mirror the settings of the
+	 remote MII device.
+
+config LAN743X_FIXED_PHY_SPEED_10_MBIT
+	bool "10 mbit"
+	help
+	 10 mbit speed on the R/G/MII bus.
+
+config LAN743X_FIXED_PHY_SPEED_100_MBIT
+	bool "100 mbit"
+	help
+	 100 mbit speed on the R/G/MII bus.
+
+config LAN743X_FIXED_PHY_SPEED_1000_MBIT
+	bool "1000 mbit"
+	help
+	 1 gbit speed on the R/G/MII bus.
+
+endchoice
+
+config LAN743X_FIXED_PHY_FULL_DUPLEX
+	bool "Full duplex"
+	default y
+	depends on LAN743X_FIXED_PHY
+	help
+	 Duplex mode on the R/G/MII bus. Enabled = full, disabled = half duplex. This
+	 setting needs to mirror the settings of the remote MII device.
+
+endif # LAN743X
+
 endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a43140f7b5eb..02a82b90b389 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -9,6 +9,9 @@
 #include <linux/microchipphy.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
+#ifdef CONFIG_LAN743X_FIXED_PHY
+#include <linux/phy_fixed.h>
+#endif
 #include <linux/rtnetlink.h>
 #include <linux/iopoll.h>
 #include <linux/crc16.h>
@@ -700,6 +703,7 @@ static int lan743x_dp_write(struct lan743x_adapter *adapter,
 	return ret;
 }
 
+#ifndef CONFIG_LAN743X_FIXED_PHY
 static u32 lan743x_mac_mii_access(u16 id, u16 index, int read)
 {
 	u32 ret;
@@ -768,6 +772,7 @@ static int lan743x_mdiobus_write(struct mii_bus *bus,
 	ret = lan743x_mac_mii_wait_till_not_busy(adapter);
 	return ret;
 }
+#endif
 
 static void lan743x_mac_set_address(struct lan743x_adapter *adapter,
 				    u8 *addr)
@@ -800,7 +805,47 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 
 	/* setup auto duplex, and speed detection */
 	data = lan743x_csr_read(adapter, MAC_CR);
+
+#ifdef LAN743x_MII_MODE_RGMII
+	/* RGMII */
+	data &= ~MAC_CR_MII_EN_;
+#endif
+#ifdef LAN743x_MII_MODE_GMII
+	/* Use GMII */
+	data |= MAC_CR_MII_EN_;
+#endif
+
+#ifdef CONFIG_LAN743X_FIXED_PHY
+	/* Disable auto negotiation */
+	data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
+
+	/* Set duplex mode */
+#ifdef CONFIG_LAN743X_FIXED_PHY_FULL_DUPLEX
+	data |= MAC_CR_DPX_;
+#else
+	data &= ~MAC_CR_DPX_;
+#endif
+
+	/* Set bus speed */
+#if defined(CONFIG_LAN743X_FIXED_PHY_SPEED_10_MBIT)
+	data &= ~MAC_CR_CFG_H_;
+	data &= ~MAC_CR_CFG_L_;
+#elif defined(CONFIG_LAN743X_FIXED_PHY_SPEED_100_MBIT)
+	data &= ~MAC_CR_CFG_H_;
+	data |= MAC_CR_CFG_L_;
+#elif defined(CONFIG_LAN743X_FIXED_PHY_SPEED_1000_MBIT)
+	data |= MAC_CR_CFG_H_;
+	data |= MAC_CR_CFG_L_;
+#else
+	#error Unsupported CONFIG_LAN743X_FIXED_PHY_SPEED selection
+#endif
+
+#else
+
+ //Auto negotiation
 	data |= MAC_CR_ADD_ | MAC_CR_ASD_;
+#endif
+
 	data |= MAC_CR_CNTR_RST_;
 	lan743x_csr_write(adapter, MAC_CR, data);
 
@@ -973,7 +1018,11 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 
 	phy_stop(netdev->phydev);
+#ifdef CONFIG_LAN743X_FIXED_PHY
+	fixed_phy_unregister(netdev->phydev);
+#else
 	phy_disconnect(netdev->phydev);
+#endif
 	netdev->phydev = NULL;
 }
 
@@ -982,16 +1031,55 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	struct lan743x_phy *phy = &adapter->phy;
 	struct phy_device *phydev;
 	struct net_device *netdev;
+#ifdef CONFIG_LAN743X_FIXED_PHY
+	struct fixed_phy_status phy_status;
+#endif
 	int ret = -EIO;
 
 	netdev = adapter->netdev;
+
+#ifdef CONFIG_LAN743X_FIXED_PHY
+	phy_status.link = 1;
+	phy_status.speed =
+#if defined(CONFIG_LAN743X_FIXED_PHY_SPEED_10_MBIT)
+		10
+#elif defined(CONFIG_LAN743X_FIXED_PHY_SPEED_100_MBIT)
+		100
+#elif defined(CONFIG_LAN743X_FIXED_PHY_SPEED_1000_MBIT)
+		1000
+#endif
+		;
+	phy_status.duplex =
+#ifdef CONFIG_LAN743X_FIXED_PHY_FULL_DUPLEX
+		DUPLEX_FULL
+#else
+		DUPLEX_HALF
+#endif
+		;
+	phy_status.pause = 0;
+	phy_status.asym_pause = 0;
+
+	phydev = fixed_phy_register(PHY_POLL, &phy_status, 0);
+
+	if (!phydev || IS_ERR(phydev))
+		goto return_error;
+
+#else
+
 	phydev = phy_find_first(adapter->mdiobus);
 	if (!phydev)
 		goto return_error;
 
+#endif
+
 	ret = phy_connect_direct(netdev, phydev,
 				 lan743x_phy_link_status_change,
-				 PHY_INTERFACE_MODE_GMII);
+#ifdef CONFIG_LAN743x_RGMII
+				 PHY_INTERFACE_MODE_RGMII
+#else
+				 PHY_INTERFACE_MODE_GMII
+#endif
+				);
 	if (ret)
 		goto return_error;
 
@@ -1004,7 +1092,9 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	phy->fc_autoneg = phydev->autoneg;
 
 	phy_start(phydev);
+#ifndef CONFIG_LAN743X_FIXED_PHY
 	phy_start_aneg(phydev);
+#endif
 	return 0;
 
 return_error:
@@ -2651,16 +2741,20 @@ static void lan743x_hardware_cleanup(struct lan743x_adapter *adapter)
 	lan743x_csr_write(adapter, INT_EN_CLR, 0xFFFFFFFF);
 }
 
+#ifndef CONFIG_LAN743X_FIXED_PHY
 static void lan743x_mdiobus_cleanup(struct lan743x_adapter *adapter)
 {
 	mdiobus_unregister(adapter->mdiobus);
 }
+#endif
 
 static void lan743x_full_cleanup(struct lan743x_adapter *adapter)
 {
 	unregister_netdev(adapter->netdev);
 
+#ifndef CONFIG_LAN743X_FIXED_PHY
 	lan743x_mdiobus_cleanup(adapter);
+#endif
 	lan743x_hardware_cleanup(adapter);
 	lan743x_pci_cleanup(adapter);
 }
@@ -2710,6 +2804,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 	return 0;
 }
 
+#ifndef CONFIG_LAN743X_FIXED_PHY
 static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 {
 	int ret;
@@ -2740,6 +2835,7 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 return_error:
 	return ret;
 }
+#endif
 
 /* lan743x_pcidev_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -2784,9 +2880,11 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 	if (ret)
 		goto cleanup_pci;
 
+#ifndef CONFIG_LAN743X_FIXED_PHY
 	ret = lan743x_mdiobus_init(adapter);
 	if (ret)
 		goto cleanup_hardware;
+#endif
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
@@ -2798,11 +2896,18 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	ret = register_netdev(adapter->netdev);
 	if (ret < 0)
+#ifdef CONFIG_LAN743X_FIXED_PHY
+		goto cleanup_hardware;
+#else
 		goto cleanup_mdiobus;
+#endif
+
 	return 0;
 
+#ifndef CONFIG_LAN743X_FIXED_PHY
 cleanup_mdiobus:
 	lan743x_mdiobus_cleanup(adapter);
+#endif
 
 cleanup_hardware:
 	lan743x_hardware_cleanup(adapter);
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 3b02eeae5f45..e49f6b6cd440 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -104,10 +104,14 @@
 	((value << 0) & FCT_FLOW_CTL_ON_THRESHOLD_)
 
 #define MAC_CR				(0x100)
+#define MAC_CR_MII_EN_			BIT(19)
 #define MAC_CR_EEE_EN_			BIT(17)
 #define MAC_CR_ADD_			BIT(12)
 #define MAC_CR_ASD_			BIT(11)
 #define MAC_CR_CNTR_RST_		BIT(5)
+#define MAC_CR_DPX_			BIT(3)
+#define MAC_CR_CFG_H_			BIT(2)
+#define MAC_CR_CFG_L_			BIT(1)
 #define MAC_CR_RST_			BIT(0)
 
 #define MAC_RX				(0x104)
-- 
2.20.1

