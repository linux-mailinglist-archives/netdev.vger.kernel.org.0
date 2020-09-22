Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9360274C18
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 00:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIVW3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 18:29:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVW3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 18:29:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKqmf-00FofH-9p; Wed, 23 Sep 2020 00:29:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 2/2] net: phy: Document core PHY structures
Date:   Wed, 23 Sep 2020 00:29:03 +0200
Message-Id: <20200922222903.3769629-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200922222903.3769629-1-andrew@lunn.ch>
References: <20200922222903.3769629-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kerneldoc for the core PHY data structures, a few inline functions
and exported functions which are not already documented.

v2
Typos
g/phy/PHY/s

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/kapi.rst |   9 +
 drivers/net/phy/phy-core.c        |  32 ++-
 drivers/net/phy/phy.c             |  69 ++++-
 include/linux/phy.h               | 423 +++++++++++++++++++++---------
 4 files changed, 400 insertions(+), 133 deletions(-)

diff --git a/Documentation/networking/kapi.rst b/Documentation/networking/kapi.rst
index f03ae64be8bc..d198fa5eaacd 100644
--- a/Documentation/networking/kapi.rst
+++ b/Documentation/networking/kapi.rst
@@ -134,6 +134,15 @@ PHY Support
 .. kernel-doc:: drivers/net/phy/phy.c
    :internal:
 
+.. kernel-doc:: drivers/net/phy/phy-core.c
+   :export:
+
+.. kernel-doc:: drivers/net/phy/phy-c45.c
+   :export:
+
+.. kernel-doc:: include/linux/phy.h
+   :internal:
+
 .. kernel-doc:: drivers/net/phy/phy_device.c
    :export:
 
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index de5b869139d7..8d333d3084ed 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -6,6 +6,11 @@
 #include <linux/phy.h>
 #include <linux/of.h>
 
+/**
+ * phy_speed_to_str - Return a string representing the PHY link speed
+ *
+ * @speed: Speed of the link
+ */
 const char *phy_speed_to_str(int speed)
 {
 	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
@@ -52,6 +57,11 @@ const char *phy_speed_to_str(int speed)
 }
 EXPORT_SYMBOL_GPL(phy_speed_to_str);
 
+/**
+ * phy_duplex_to_str - Return string describing the duplex
+ *
+ * @duplex: Duplex setting to describe
+ */
 const char *phy_duplex_to_str(unsigned int duplex)
 {
 	if (duplex == DUPLEX_HALF)
@@ -252,6 +262,16 @@ static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
 	return __set_linkmode_max_speed(max_speed, phydev->supported);
 }
 
+/**
+ * phy_set_max_speed - Set the maximum speed the PHY should support
+ *
+ * @phydev: The phy_device struct
+ * @max_speed: Maximum speed
+ *
+ * The PHY might be more capable than the MAC. For example a Fast Ethernet
+ * is connected to a 1G PHY. This function allows the MAC to indicate its
+ * maximum speed, and so limit what the PHY will advertise.
+ */
 int phy_set_max_speed(struct phy_device *phydev, u32 max_speed)
 {
 	int err;
@@ -308,6 +328,16 @@ void of_set_phy_eee_broken(struct phy_device *phydev)
 	phydev->eee_broken_modes = broken;
 }
 
+/**
+ * phy_resolve_aneg_pause - Determine pause autoneg results
+ *
+ * @phydev: The phy_device struct
+ *
+ * Once autoneg has completed the local pause settings can be
+ * resolved.  Determine if pause and asymmetric pause should be used
+ * by the MAC.
+ */
+
 void phy_resolve_aneg_pause(struct phy_device *phydev)
 {
 	if (phydev->duplex == DUPLEX_FULL) {
@@ -321,7 +351,7 @@ void phy_resolve_aneg_pause(struct phy_device *phydev)
 EXPORT_SYMBOL_GPL(phy_resolve_aneg_pause);
 
 /**
- * phy_resolve_aneg_linkmode - resolve the advertisements into phy settings
+ * phy_resolve_aneg_linkmode - resolve the advertisements into PHY settings
  * @phydev: The phy_device struct
  *
  * Resolve our and the link partner advertisements into their corresponding
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 735a806045ac..4449f0e9ce9e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -456,7 +456,16 @@ int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 EXPORT_SYMBOL(phy_do_ioctl);
 
-/* same as phy_do_ioctl, but ensures that net_device is running */
+/**
+ * phy_do_ioctl_running - generic ndo_do_ioctl implementation but test first
+ *
+ * @dev: the net_device struct
+ * @ifr: &struct ifreq for socket ioctl's
+ * @cmd: ioctl cmd to execute
+ *
+ * Same as phy_do_ioctl, but ensures that net_device is running before
+ * handling the ioctl.
+ */
 int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	if (!netif_running(dev))
@@ -466,6 +475,12 @@ int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 EXPORT_SYMBOL(phy_do_ioctl_running);
 
+/**
+ * phy_queue_state_machine - Trigger the state machine to run soon
+ *
+ * @phydev: the phy_device struct
+ * @jiffies: Run the state machine after these jiffies
+ */
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 {
 	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
@@ -473,6 +488,11 @@ void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 }
 EXPORT_SYMBOL(phy_queue_state_machine);
 
+/**
+ * phy_queue_state_machine - Trigger the state machine to run now
+ *
+ * @phydev: the phy_device struct
+ */
 static void phy_trigger_machine(struct phy_device *phydev)
 {
 	phy_queue_state_machine(phydev, 0);
@@ -489,6 +509,12 @@ static void phy_abort_cable_test(struct phy_device *phydev)
 		phydev_err(phydev, "Error while aborting cable test");
 }
 
+/**
+ * phy_ethtool_get_strings - Get the statistic counter names
+ *
+ * @phydev: the phy_device struct
+ * @data: Where to put the strings
+ */
 int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data)
 {
 	if (!phydev->drv)
@@ -502,6 +528,11 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data)
 }
 EXPORT_SYMBOL(phy_ethtool_get_strings);
 
+/**
+ * phy_ethtool_get_sset_count - Get the number of statistic counters
+ *
+ * @phydev: the phy_device struct
+ */
 int phy_ethtool_get_sset_count(struct phy_device *phydev)
 {
 	int ret;
@@ -523,6 +554,13 @@ int phy_ethtool_get_sset_count(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_ethtool_get_sset_count);
 
+/**
+ * phy_ethtool_get_stats - Get the statistic counters
+ *
+ * @phydev: the phy_device struct
+ * @stats: What counters to get
+ * @data: Where to store the counters
+ */
 int phy_ethtool_get_stats(struct phy_device *phydev,
 			  struct ethtool_stats *stats, u64 *data)
 {
@@ -537,6 +575,12 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_ethtool_get_stats);
 
+/**
+ * phy_start_cable_test - Start a cable test
+ *
+ * @phydev: the phy_device struct
+ * @extack: extack for reporting useful error messages
+ */
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack)
 {
@@ -600,6 +644,13 @@ int phy_start_cable_test(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_start_cable_test);
 
+/**
+ * phy_start_cable_test_tdr - Start a raw TDR cable test
+ *
+ * @phydev: the phy_device struct
+ * @extack: extack for reporting useful error messages
+ * @config: Configuration of the test to run
+ */
 int phy_start_cable_test_tdr(struct phy_device *phydev,
 			     struct netlink_ext_ack *extack,
 			     const struct phy_tdr_config *config)
@@ -1363,6 +1414,12 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 }
 EXPORT_SYMBOL(phy_ethtool_set_eee);
 
+/**
+ * phy_ethtool_set_wol - Configure Wake On LAN
+ *
+ * @phydev: target phy_device struct
+ * @wol: Configuration requested
+ */
 int phy_ethtool_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
 	if (phydev->drv && phydev->drv->set_wol)
@@ -1372,6 +1429,12 @@ int phy_ethtool_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 }
 EXPORT_SYMBOL(phy_ethtool_set_wol);
 
+/**
+ * phy_ethtool_get_wol - Get the current Wake On LAN configuration
+ *
+ * @phydev: target phy_device struct
+ * @wol: Store the current configuration here
+ */
 void phy_ethtool_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
 	if (phydev->drv && phydev->drv->get_wol)
@@ -1405,6 +1468,10 @@ int phy_ethtool_set_link_ksettings(struct net_device *ndev,
 }
 EXPORT_SYMBOL(phy_ethtool_set_link_ksettings);
 
+/**
+ * phy_ethtool_nway_reset - Restart auto negotiation
+ * @ndev: Network device to restart autoneg for
+ */
 int phy_ethtool_nway_reset(struct net_device *ndev)
 {
 	struct phy_device *phydev = ndev->phydev;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4901b2637059..eb3cb1a98b45 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -82,7 +82,39 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
-/* Interface Mode definitions */
+/**
+ * enum phy_interface_t - Interface Mode definitions
+ *
+ * @PHY_INTERFACE_MODE_NA: Not Applicable - don't touch
+ * @PHY_INTERFACE_MODE_INTERNAL: No interface, MAC and PHY combined
+ * @PHY_INTERFACE_MODE_MII: Median-independent interface
+ * @PHY_INTERFACE_MODE_GMII: Gigabit median-independent interface
+ * @PHY_INTERFACE_MODE_SGMII: Serial gigabit media-independent interface
+ * @PHY_INTERFACE_MODE_TBI: Ten Bit Interface
+ * @PHY_INTERFACE_MODE_REVMII: Reverse Media Independent Interface
+ * @PHY_INTERFACE_MODE_RMII: Reduced Media Independent Interface
+ * @PHY_INTERFACE_MODE_RGMII: Reduced gigabit media-independent interface
+ * @PHY_INTERFACE_MODE_RGMII_ID: RGMII with Internal RX+TX delay
+ * @PHY_INTERFACE_MODE_RGMII_RXID: RGMII with Internal RX delay
+ * @PHY_INTERFACE_MODE_RGMII_TXID: RGMII with Internal RX delay
+ * @PHY_INTERFACE_MODE_RTBI: Reduced TBI
+ * @PHY_INTERFACE_MODE_SMII: ??? MII
+ * @PHY_INTERFACE_MODE_XGMII: 10 gigabit media-independent interface
+ * @PHY_INTERFACE_MODE_XLGMII:40 gigabit media-independent interface
+ * @PHY_INTERFACE_MODE_MOCA: Multimedia over Coax
+ * @PHY_INTERFACE_MODE_QSGMII: Quad SGMII
+ * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
+ * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
+ * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
+ * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
+ * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
+ * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
+ * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
+ * @PHY_INTERFACE_MODE_MAX: Book keeping
+ *
+ * Describes the interface between the MAC and PHY.
+ */
 typedef enum {
 	PHY_INTERFACE_MODE_NA,
 	PHY_INTERFACE_MODE_INTERNAL,
@@ -116,8 +148,8 @@ typedef enum {
 } phy_interface_t;
 
 /**
- * phy_supported_speeds - return all speeds currently supported by a phy device
- * @phy: The phy device to return supported speeds of.
+ * phy_supported_speeds - return all speeds currently supported by a PHY device
+ * @phy: The PHY device to return supported speeds of.
  * @speeds: buffer to store supported speeds in.
  * @size: size of speeds buffer.
  *
@@ -134,9 +166,9 @@ unsigned int phy_supported_speeds(struct phy_device *phy,
  * phy_modes - map phy_interface_t enum to device tree binding of phy-mode
  * @interface: enum phy_interface_t value
  *
- * Description: maps 'enum phy_interface_t' defined in this file
+ * Description: maps enum &phy_interface_t defined in this file
  * into the device tree binding of 'phy-mode', so that Ethernet
- * device driver can get phy interface from device tree.
+ * device driver can get PHY interface from device tree.
  */
 static inline const char *phy_modes(phy_interface_t interface)
 {
@@ -215,6 +247,14 @@ struct sfp_bus;
 struct sfp_upstream_ops;
 struct sk_buff;
 
+/**
+ * struct mdio_bus_stats - Statistics counters for MDIO busses
+ * @transfers: Total number of transfers, i.e. @writes + @reads
+ * @errors: Number of MDIO transfers that returned an error
+ * @writes: Number of write transfers
+ * @reads: Number of read transfers
+ * @syncp: Synchronisation for incrementing statistics
+ */
 struct mdio_bus_stats {
 	u64_stats_t transfers;
 	u64_stats_t errors;
@@ -224,7 +264,15 @@ struct mdio_bus_stats {
 	struct u64_stats_sync syncp;
 };
 
-/* Represents a shared structure between different phydev's in the same
+/**
+ * struct phy_package_shared - Shared information in PHY packages
+ * @addr: Common PHY address used to combine PHYs in one package
+ * @refcnt: Number of PHYs connected to this shared data
+ * @flags: Initialization of PHY package
+ * @priv_size: Size of the shared private data @priv
+ * @priv: Driver private data shared across a PHY package
+ *
+ * Represents a shared structure between different phydev's in the same
  * package, for example a quad PHY. See phy_package_join() and
  * phy_package_leave().
  */
@@ -247,7 +295,14 @@ struct phy_package_shared {
 #define PHY_SHARED_F_INIT_DONE  0
 #define PHY_SHARED_F_PROBE_DONE 1
 
-/*
+/**
+ * struct mii_bus - Represents an MDIO bus
+ *
+ * @owner: Who owns this device
+ * @name: User friendly name for this MDIO device, or driver name
+ * @id: Unique identifier for this bus, typical from bus hierarchy
+ * @priv: Driver private data
+ *
  * The Bus class for PHYs.  Devices which provide access to
  * PHYs should register using this structure
  */
@@ -256,49 +311,58 @@ struct mii_bus {
 	const char *name;
 	char id[MII_BUS_ID_SIZE];
 	void *priv;
+	/** @read: Perform a read transfer on the bus */
 	int (*read)(struct mii_bus *bus, int addr, int regnum);
+	/** @write: Perform a write transfer on the bus */
 	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
+	/** @reset: Perform a reset of the bus */
 	int (*reset)(struct mii_bus *bus);
+
+	/** @stats: Statistic counters per device on the bus */
 	struct mdio_bus_stats stats[PHY_MAX_ADDR];
 
-	/*
-	 * A lock to ensure that only one thing can read/write
+	/**
+	 * @mdio_lock: A lock to ensure that only one thing can read/write
 	 * the MDIO bus at a time
 	 */
 	struct mutex mdio_lock;
 
+	/** @parent: Parent device of this bus */
 	struct device *parent;
+	/** @state: State of bus structure */
 	enum {
 		MDIOBUS_ALLOCATED = 1,
 		MDIOBUS_REGISTERED,
 		MDIOBUS_UNREGISTERED,
 		MDIOBUS_RELEASED,
 	} state;
+
+	/** @dev: Kernel device representation */
 	struct device dev;
 
-	/* list of all PHYs on bus */
+	/** @mdio_map: list of all MDIO devices on bus */
 	struct mdio_device *mdio_map[PHY_MAX_ADDR];
 
-	/* PHY addresses to be ignored when probing */
+	/** @phy_mask: PHY addresses to be ignored when probing */
 	u32 phy_mask;
 
-	/* PHY addresses to ignore the TA/read failure */
+	/** @phy_ignore_ta_mask: PHY addresses to ignore the TA/read failure */
 	u32 phy_ignore_ta_mask;
 
-	/*
-	 * An array of interrupts, each PHY's interrupt at the index
+	/**
+	 * @irq: An array of interrupts, each PHY's interrupt at the index
 	 * matching its address
 	 */
 	int irq[PHY_MAX_ADDR];
 
-	/* GPIO reset pulse width in microseconds */
+	/** @reset_delay_us: GPIO reset pulse width in microseconds */
 	int reset_delay_us;
-	/* GPIO reset deassert delay in microseconds */
+	/** @reset_post_delay_us: GPIO reset deassert delay in microseconds */
 	int reset_post_delay_us;
-	/* RESET GPIO descriptor pointer */
+	/** @reset_gpiod: Reset GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
 
-	/* bus capabilities, used for probing */
+	/** @probe_capabilities: bus capabilities, used for probing */
 	enum {
 		MDIOBUS_NO_CAP = 0,
 		MDIOBUS_C22,
@@ -306,15 +370,22 @@ struct mii_bus {
 		MDIOBUS_C22_C45,
 	} probe_capabilities;
 
-	/* protect access to the shared element */
+	/** @shared_lock: protect access to the shared element */
 	struct mutex shared_lock;
 
-	/* shared state across different PHYs */
+	/** @shared: shared state across different PHYs */
 	struct phy_package_shared *shared[PHY_MAX_ADDR];
 };
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
-struct mii_bus *mdiobus_alloc_size(size_t);
+struct mii_bus *mdiobus_alloc_size(size_t size);
+
+/**
+ * mdiobus_alloc - Allocate an MDIO bus structure
+ *
+ * The internal state of the MDIO bus will be set of MDIOBUS_ALLOCATED ready
+ * for the driver to register the bus.
+ */
 static inline struct mii_bus *mdiobus_alloc(void)
 {
 	return mdiobus_alloc_size(0);
@@ -341,40 +412,41 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
 #define PHY_INTERRUPT_DISABLED	false
 #define PHY_INTERRUPT_ENABLED	true
 
-/* PHY state machine states:
+/**
+ * enum phy_state - PHY state machine states:
  *
- * DOWN: PHY device and driver are not ready for anything.  probe
+ * @PHY_DOWN: PHY device and driver are not ready for anything.  probe
  * should be called if and only if the PHY is in this state,
  * given that the PHY device exists.
- * - PHY driver probe function will set the state to READY
+ * - PHY driver probe function will set the state to @PHY_READY
  *
- * READY: PHY is ready to send and receive packets, but the
+ * @PHY_READY: PHY is ready to send and receive packets, but the
  * controller is not.  By default, PHYs which do not implement
  * probe will be set to this state by phy_probe().
  * - start will set the state to UP
  *
- * UP: The PHY and attached device are ready to do work.
+ * @PHY_UP: The PHY and attached device are ready to do work.
  * Interrupts should be started here.
- * - timer moves to NOLINK or RUNNING
+ * - timer moves to @PHY_NOLINK or @PHY_RUNNING
  *
- * NOLINK: PHY is up, but not currently plugged in.
- * - irq or timer will set RUNNING if link comes back
- * - phy_stop moves to HALTED
+ * @PHY_NOLINK: PHY is up, but not currently plugged in.
+ * - irq or timer will set @PHY_RUNNING if link comes back
+ * - phy_stop moves to @PHY_HALTED
  *
- * RUNNING: PHY is currently up, running, and possibly sending
+ * @PHY_RUNNING: PHY is currently up, running, and possibly sending
  * and/or receiving packets
- * - irq or timer will set NOLINK if link goes down
- * - phy_stop moves to HALTED
+ * - irq or timer will set @PHY_NOLINK if link goes down
+ * - phy_stop moves to @PHY_HALTED
  *
- * CABLETEST: PHY is performing a cable test. Packet reception/sending
+ * @PHY_CABLETEST: PHY is performing a cable test. Packet reception/sending
  * is not expected to work, carrier will be indicated as down. PHY will be
  * poll once per second, or on interrupt for it current state.
  * Once complete, move to UP to restart the PHY.
- * - phy_stop aborts the running test and moves to HALTED
+ * - phy_stop aborts the running test and moves to @PHY_HALTED
  *
- * HALTED: PHY is up, but no polling or interrupts are done. Or
+ * @PHY_HALTED: PHY is up, but no polling or interrupts are done. Or
  * PHY is in an error state.
- * - phy_start moves to UP
+ * - phy_start moves to @PHY_UP
  */
 enum phy_state {
 	PHY_DOWN = 0,
@@ -403,34 +475,67 @@ struct phy_c45_device_ids {
 struct macsec_context;
 struct macsec_ops;
 
-/* phy_device: An instance of a PHY
+/**
+ * struct phy_device - An instance of a PHY
  *
- * drv: Pointer to the driver for this PHY instance
- * phy_id: UID for this device found during discovery
- * c45_ids: 802.3-c45 Device Identifers if is_c45.
- * is_c45:  Set to true if this phy uses clause 45 addressing.
- * is_internal: Set to true if this phy is internal to a MAC.
- * is_pseudo_fixed_link: Set to true if this phy is an Ethernet switch, etc.
- * is_gigabit_capable: Set to true if PHY supports 1000Mbps
- * has_fixups: Set to true if this phy has fixups/quirks.
- * suspended: Set to true if this phy has been suspended successfully.
- * suspended_by_mdio_bus: Set to true if this phy was suspended by MDIO bus.
- * sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
- * loopback_enabled: Set true if this phy has been loopbacked successfully.
- * downshifted_rate: Set true if link speed has been downshifted.
- * state: state of the PHY for management purposes
- * dev_flags: Device-specific flags used by the PHY driver.
- * irq: IRQ number of the PHY's interrupt (-1 if none)
- * phy_timer: The timer for handling the state machine
- * sfp_bus_attached: flag indicating whether the SFP bus has been attached
- * sfp_bus: SFP bus attached to this PHY's fiber port
- * attached_dev: The attached enet driver's device instance ptr
- * adjust_link: Callback for the enet controller to respond to
- * changes in the link state.
- * macsec_ops: MACsec offloading ops.
+ * @mdio: MDIO bus this PHY is on
+ * @drv: Pointer to the driver for this PHY instance
+ * @phy_id: UID for this device found during discovery
+ * @c45_ids: 802.3-c45 Device Identifiers if is_c45.
+ * @is_c45:  Set to true if this PHY uses clause 45 addressing.
+ * @is_internal: Set to true if this PHY is internal to a MAC.
+ * @is_pseudo_fixed_link: Set to true if this PHY is an Ethernet switch, etc.
+ * @is_gigabit_capable: Set to true if PHY supports 1000Mbps
+ * @has_fixups: Set to true if this PHY has fixups/quirks.
+ * @suspended: Set to true if this PHY has been suspended successfully.
+ * @suspended_by_mdio_bus: Set to true if this PHY was suspended by MDIO bus.
+ * @sysfs_links: Internal boolean tracking sysfs symbolic links setup/removal.
+ * @loopback_enabled: Set true if this PHY has been loopbacked successfully.
+ * @downshifted_rate: Set true if link speed has been downshifted.
+ * @state: State of the PHY for management purposes
+ * @dev_flags: Device-specific flags used by the PHY driver.
+ * @irq: IRQ number of the PHY's interrupt (-1 if none)
+ * @phy_timer: The timer for handling the state machine
+ * @phylink: Pointer to phylink instance for this PHY
+ * @sfp_bus_attached: Flag indicating whether the SFP bus has been attached
+ * @sfp_bus: SFP bus attached to this PHY's fiber port
+ * @attached_dev: The attached enet driver's device instance ptr
+ * @adjust_link: Callback for the enet controller to respond to changes: in the
+ *               link state.
+ * @phy_link_change: Callback for phylink for notification of link change
+ * @macsec_ops: MACsec offloading ops.
  *
- * speed, duplex, pause, supported, advertising, lp_advertising,
- * and autoneg are used like in mii_if_info
+ * @speed: Current link speed
+ * @duplex: Current duplex
+ * @pause: Current pause
+ * @asym_pause: Current asymmetric pause
+ * @supported: Combined MAC/PHY supported linkmodes
+ * @advertising: Currently advertised linkmodes
+ * @adv_old: Saved advertised while power saving for WoL
+ * @lp_advertising: Current link partner advertised linkmodes
+ * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
+ * @autoneg: Flag autoneg being used
+ * @link: Current link state
+ * @autoneg_complete: Flag auto negotiation of the link has completed
+ * @mdix: Current crossover
+ * @mdix_ctrl: User setting of crossover
+ * @interrupts: Flag interrupts have been enabled
+ * @interface: enum phy_interface_t value
+ * @skb: Netlink message for cable diagnostics
+ * @nest: Netlink nest used for cable diagnostics
+ * @ehdr: nNtlink header for cable diagnostics
+ * @phy_led_triggers: Array of LED triggers
+ * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
+ * @led_link_trigger: LED trigger for link up/down
+ * @last_triggered: last LED trigger for link speed
+ * @master_slave_set: User requested master/slave configuration
+ * @master_slave_get: Current master/slave advertisement
+ * @master_slave_state: Current master/slave configuration
+ * @mii_ts: Pointer to time stamper callbacks
+ * @lock:  Mutex for serialization access to PHY
+ * @state_queue: Work queue for state machine
+ * @shared: Pointer to private data shared by phys in one package
+ * @priv: Pointer to driver private data
  *
  * interrupts currently only supports enabled or disabled,
  * but could be changed in the future to support enabling
@@ -550,9 +655,18 @@ struct phy_device {
 #define to_phy_device(d) container_of(to_mdio_device(d), \
 				      struct phy_device, mdio)
 
-/* A structure containing possible configuration parameters
+/**
+ * struct phy_tdr_config - Configuration of a TDR raw test
+ *
+ * @first: Distance for first data collection point
+ * @last: Distance for last data collection point
+ * @step: Step between data collection points
+ * @pair: Bitmap of cable pairs to collect data for
+ *
+ * A structure containing possible configuration parameters
  * for a TDR cable test. The driver does not need to implement
  * all the parameters, but should report what is actually used.
+ * All distances are in centimeters.
  */
 struct phy_tdr_config {
 	u32 first;
@@ -562,18 +676,20 @@ struct phy_tdr_config {
 };
 #define PHY_PAIR_ALL -1
 
-/* struct phy_driver: Driver structure for a particular PHY type
+/**
+ * struct phy_driver - Driver structure for a particular PHY type
  *
- * driver_data: static driver data
- * phy_id: The result of reading the UID registers of this PHY
+ * @mdiodrv: Data common to all MDIO devices
+ * @phy_id: The result of reading the UID registers of this PHY
  *   type, and ANDing them with the phy_id_mask.  This driver
  *   only works for PHYs with IDs which match this field
- * name: The friendly name of this PHY type
- * phy_id_mask: Defines the important bits of the phy_id
- * features: A mandatory list of features (speed, duplex, etc)
+ * @name: The friendly name of this PHY type
+ * @phy_id_mask: Defines the important bits of the phy_id
+ * @features: A mandatory list of features (speed, duplex, etc)
  *   supported by this PHY
- * flags: A bitfield defining certain other features this PHY
+ * @flags: A bitfield defining certain other features this PHY
  *   supports (like interrupts)
+ * @driver_data: Static driver data
  *
  * All functions are optional. If config_aneg or read_status
  * are not implemented, the phy core uses the genphy versions.
@@ -592,151 +708,178 @@ struct phy_driver {
 	u32 flags;
 	const void *driver_data;
 
-	/*
-	 * Called to issue a PHY software reset
+	/**
+	 * @soft_reset: Called to issue a PHY software reset
 	 */
 	int (*soft_reset)(struct phy_device *phydev);
 
-	/*
-	 * Called to initialize the PHY,
+	/**
+	 * @config_init: Called to initialize the PHY,
 	 * including after a reset
 	 */
 	int (*config_init)(struct phy_device *phydev);
 
-	/*
-	 * Called during discovery.  Used to set
+	/**
+	 * @probe: Called during discovery.  Used to set
 	 * up device-specific structures, if any
 	 */
 	int (*probe)(struct phy_device *phydev);
 
-	/*
-	 * Probe the hardware to determine what abilities it has.
-	 * Should only set phydev->supported.
+	/**
+	 * @get_features: Probe the hardware to determine what
+	 * abilities it has.  Should only set phydev->supported.
 	 */
 	int (*get_features)(struct phy_device *phydev);
 
 	/* PHY Power Management */
+	/** @suspend: Suspend the hardware, saving state if needed */
 	int (*suspend)(struct phy_device *phydev);
+	/** @resume: Resume the hardware, restoring state if needed */
 	int (*resume)(struct phy_device *phydev);
 
-	/*
-	 * Configures the advertisement and resets
+	/**
+	 * @config_aneg: Configures the advertisement and resets
 	 * autonegotiation if phydev->autoneg is on,
 	 * forces the speed to the current settings in phydev
 	 * if phydev->autoneg is off
 	 */
 	int (*config_aneg)(struct phy_device *phydev);
 
-	/* Determines the auto negotiation result */
+	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
-	/* Determines the negotiated speed and duplex */
+	/** @read_status: Determines the negotiated speed and duplex */
 	int (*read_status)(struct phy_device *phydev);
 
-	/* Clears any pending interrupts */
+	/** @ack_interrupt: Clears any pending interrupts */
 	int (*ack_interrupt)(struct phy_device *phydev);
 
-	/* Enables or disables interrupts */
+	/** @config_intr: Enables or disables interrupts */
 	int (*config_intr)(struct phy_device *phydev);
 
-	/*
-	 * Checks if the PHY generated an interrupt.
+	/**
+	 * @did_interrupt: Checks if the PHY generated an interrupt.
 	 * For multi-PHY devices with shared PHY interrupt pin
 	 * Set interrupt bits have to be cleared.
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 
-	/* Override default interrupt handling */
+	/** @handle_interrupt: Override default interrupt handling */
 	irqreturn_t (*handle_interrupt)(struct phy_device *phydev);
 
-	/* Clears up any memory if needed */
+	/** @remove: Clears up any memory if needed */
 	void (*remove)(struct phy_device *phydev);
 
-	/* Returns true if this is a suitable driver for the given
-	 * phydev.  If NULL, matching is based on phy_id and
-	 * phy_id_mask.
+	/**
+	 * @match_phy_device: Returns true if this is a suitable
+	 * driver for the given phydev.	 If NULL, matching is based on
+	 * phy_id and phy_id_mask.
 	 */
 	int (*match_phy_device)(struct phy_device *phydev);
 
-	/* Some devices (e.g. qnap TS-119P II) require PHY register changes to
-	 * enable Wake on LAN, so set_wol is provided to be called in the
-	 * ethernet driver's set_wol function. */
+	/**
+	 * @set_wol: Some devices (e.g. qnap TS-119P II) require PHY
+	 * register changes to enable Wake on LAN, so set_wol is
+	 * provided to be called in the ethernet driver's set_wol
+	 * function.
+	 */
 	int (*set_wol)(struct phy_device *dev, struct ethtool_wolinfo *wol);
 
-	/* See set_wol, but for checking whether Wake on LAN is enabled. */
+	/**
+	 * @get_wol: See set_wol, but for checking whether Wake on LAN
+	 * is enabled.
+	 */
 	void (*get_wol)(struct phy_device *dev, struct ethtool_wolinfo *wol);
 
-	/*
-	 * Called to inform a PHY device driver when the core is about to
-	 * change the link state. This callback is supposed to be used as
-	 * fixup hook for drivers that need to take action when the link
-	 * state changes. Drivers are by no means allowed to mess with the
+	/**
+	 * @link_change_notify: Called to inform a PHY device driver
+	 * when the core is about to change the link state. This
+	 * callback is supposed to be used as fixup hook for drivers
+	 * that need to take action when the link state
+	 * changes. Drivers are by no means allowed to mess with the
 	 * PHY device structure in their implementations.
 	 */
 	void (*link_change_notify)(struct phy_device *dev);
 
-	/*
-	 * Phy specific driver override for reading a MMD register.
-	 * This function is optional for PHY specific drivers.  When
-	 * not provided, the default MMD read function will be used
-	 * by phy_read_mmd(), which will use either a direct read for
-	 * Clause 45 PHYs or an indirect read for Clause 22 PHYs.
-	 *  devnum is the MMD device number within the PHY device,
-	 *  regnum is the register within the selected MMD device.
+	/**
+	 * @read_mmd: PHY specific driver override for reading a MMD
+	 * register.  This function is optional for PHY specific
+	 * drivers.  When not provided, the default MMD read function
+	 * will be used by phy_read_mmd(), which will use either a
+	 * direct read for Clause 45 PHYs or an indirect read for
+	 * Clause 22 PHYs.  devnum is the MMD device number within the
+	 * PHY device, regnum is the register within the selected MMD
+	 * device.
 	 */
 	int (*read_mmd)(struct phy_device *dev, int devnum, u16 regnum);
 
-	/*
-	 * Phy specific driver override for writing a MMD register.
-	 * This function is optional for PHY specific drivers.  When
-	 * not provided, the default MMD write function will be used
-	 * by phy_write_mmd(), which will use either a direct write for
-	 * Clause 45 PHYs, or an indirect write for Clause 22 PHYs.
-	 *  devnum is the MMD device number within the PHY device,
-	 *  regnum is the register within the selected MMD device.
-	 *  val is the value to be written.
+	/**
+	 * @write_mmd: PHY specific driver override for writing a MMD
+	 * register.  This function is optional for PHY specific
+	 * drivers.  When not provided, the default MMD write function
+	 * will be used by phy_write_mmd(), which will use either a
+	 * direct write for Clause 45 PHYs, or an indirect write for
+	 * Clause 22 PHYs.  devnum is the MMD device number within the
+	 * PHY device, regnum is the register within the selected MMD
+	 * device.  val is the value to be written.
 	 */
 	int (*write_mmd)(struct phy_device *dev, int devnum, u16 regnum,
 			 u16 val);
 
+	/** @read_page: Return the current PHY register page number */
 	int (*read_page)(struct phy_device *dev);
+	/** @write_page: Set the current PHY register page number */
 	int (*write_page)(struct phy_device *dev, int page);
 
-	/* Get the size and type of the eeprom contained within a plug-in
-	 * module */
+	/**
+	 * @module_info: Get the size and type of the eeprom contained
+	 * within a plug-in module
+	 */
 	int (*module_info)(struct phy_device *dev,
 			   struct ethtool_modinfo *modinfo);
 
-	/* Get the eeprom information from the plug-in module */
+	/**
+	 * @module_eeprom: Get the eeprom information from the plug-in
+	 * module
+	 */
 	int (*module_eeprom)(struct phy_device *dev,
 			     struct ethtool_eeprom *ee, u8 *data);
 
-	/* Start a cable test */
+	/** @cable_test_start: Start a cable test */
 	int (*cable_test_start)(struct phy_device *dev);
 
-	/* Start a raw TDR cable test */
+	/**  @cable_test_tdr_start: Start a raw TDR cable test */
 	int (*cable_test_tdr_start)(struct phy_device *dev,
 				    const struct phy_tdr_config *config);
 
-	/* Once per second, or on interrupt, request the status of the
-	 * test.
+	/**
+	 * @cable_test_get_status: Once per second, or on interrupt,
+	 * request the status of the test.
 	 */
 	int (*cable_test_get_status)(struct phy_device *dev, bool *finished);
 
-	/* Get statistics from the phy using ethtool */
+	/* Get statistics from the PHY using ethtool */
+	/** @get_sset_count: Number of statistic counters */
 	int (*get_sset_count)(struct phy_device *dev);
+	/** @get_strings: Names of the statistic counters */
 	void (*get_strings)(struct phy_device *dev, u8 *data);
+	/** @get_stats: Return the statistic counter values */
 	void (*get_stats)(struct phy_device *dev,
 			  struct ethtool_stats *stats, u64 *data);
 
 	/* Get and Set PHY tunables */
+	/** @get_tunable: Return the value of a tunable */
 	int (*get_tunable)(struct phy_device *dev,
 			   struct ethtool_tunable *tuna, void *data);
+	/** @set_tunable: Set the value of a tunable */
 	int (*set_tunable)(struct phy_device *dev,
 			    struct ethtool_tunable *tuna,
 			    const void *data);
+	/** @set_loopback: Set the loopback mood of the PHY */
 	int (*set_loopback)(struct phy_device *dev, bool enable);
+	/** @get_sqi: Get the signal quality indication */
 	int (*get_sqi)(struct phy_device *dev);
+	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
@@ -890,6 +1033,24 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
  */
 int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 
+/**
+ * phy_read_mmd_poll_timeout - Periodically poll a PHY register until a
+ *                             condition is met or a timeout occurs
+ *
+ * @phydev: The phy_device struct
+ * @devaddr: The MMD to read from
+ * @regnum: The register on the MMD to read
+ * @val: Variable to read the register into
+ * @cond: Break condition (usually involving @val)
+ * @sleep_us: Maximum time to sleep between reads in us (0
+ *            tight-loops).  Should be less than ~20ms since usleep_range
+ *            is used (see Documentation/timers/timers-howto.rst).
+ * @timeout_us: Timeout in us, 0 means never timeout
+ * @sleep_before_read: if it is true, sleep @sleep_us before read.
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @args is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ */
 #define phy_read_mmd_poll_timeout(phydev, devaddr, regnum, val, cond, \
 				  sleep_us, timeout_us, sleep_before_read) \
 ({ \
@@ -1161,7 +1322,7 @@ static inline bool phy_is_internal(struct phy_device *phydev)
 /**
  * phy_interface_mode_is_rgmii - Convenience function for testing if a
  * PHY interface mode is RGMII (all variants)
- * @mode: the phy_interface_t enum
+ * @mode: the &phy_interface_t enum
  */
 static inline bool phy_interface_mode_is_rgmii(phy_interface_t mode)
 {
@@ -1170,11 +1331,11 @@ static inline bool phy_interface_mode_is_rgmii(phy_interface_t mode)
 };
 
 /**
- * phy_interface_mode_is_8023z() - does the phy interface mode use 802.3z
+ * phy_interface_mode_is_8023z() - does the PHY interface mode use 802.3z
  *   negotiation
  * @mode: one of &enum phy_interface_t
  *
- * Returns true if the phy interface mode uses the 16-bit negotiation
+ * Returns true if the PHY interface mode uses the 16-bit negotiation
  * word as defined in 802.3z. (See 802.3-2015 37.2.1 Config_Reg encoding)
  */
 static inline bool phy_interface_mode_is_8023z(phy_interface_t mode)
@@ -1193,7 +1354,7 @@ static inline bool phy_interface_is_rgmii(struct phy_device *phydev)
 	return phy_interface_mode_is_rgmii(phydev->interface);
 };
 
-/*
+/**
  * phy_is_pseudo_fixed_link - Convenience function for testing if this
  * PHY is the CPU port facing side of an Ethernet switch, or similar.
  * @phydev: the phy_device struct
-- 
2.28.0

