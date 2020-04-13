Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211941A661E
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 14:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgDMMBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 08:01:40 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:44228 "EHLO julia1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgDMMBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 08:01:39 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrvdelgdeglecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfupfevtfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtsehmtderredtfeejnecuhfhrohhmpefnrghurhhiucflrghkkhhuuceolhgruhhrihdrjhgrkhhkuhesphhprdhinhgvthdrfhhiqeenucfkphepkeegrddvgeekrdeftddrudelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedruddrudefgegnpdhinhgvthepkeegrddvgeekrdeftddrudelhedpmhgrihhlfhhrohhmpeeolhgruhhjrghkqdefsehmsghogidrihhnvghtrdhfihequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoehhkhgrlhhlfigvihhtudesghhmrghilhdrtghomheqpdhrtghpthhtohepoehlvghonheskhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhhitggpshifshgusehrvggrlhhtvghkrdgtohhmqe
Received: from [192.168.1.134] (84.248.30.195) by julia1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E93CD2F0002757C; Mon, 13 Apr 2020 15:01:24 +0300
Subject: Re: NET: r8168/r8169 identifying fix
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Message-ID: <06489204-2bec-fe64-4dbd-7abe4c585c23@pp.inet.fi>
Date:   Mon, 13 Apr 2020 15:01:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200413113430.GM334007@unreal>
Content-Type: multipart/mixed;
 boundary="------------682D0E56722D4FBBD808EED3"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------682D0E56722D4FBBD808EED3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

I've tought that the debug's are worth to save behind an definition/commented out, so they can be enabled if needed.


Latest version:

From 1a75f6f9065a58180de1fa3c48fd80418af6c347 Mon Sep 17 00:00:00 2001
From: Lauri Jakku <lja@iki.fi>
Date: Mon, 13 Apr 2020 13:18:35 +0300
Subject: [PATCH] NET: r8168/r8169 identifying fix

The driver installation determination made properly by
checking PHY vs DRIVER id's.
---
 drivers/net/ethernet/realtek/r8169_main.c | 114 ++++++++++++++++++++--
 drivers/net/phy/mdio_bus.c                |  15 ++-
 2 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bf5bf05970a2..5e992f285527 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -61,6 +61,11 @@
 #define R8169_MSG_DEFAULT \
 	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
 
+
+/*
+#define R8169_PROBE_DEBUG
+*/
+	
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
 #define	MC_FILTER_LIMIT	32
@@ -5149,6 +5154,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 {
 	struct pci_dev *pdev = tp->pci_dev;
 	struct mii_bus *new_bus;
+	u32 phydev_id = 0;
+	u32 phydrv_id = 0;
+	u32 phydrv_id_mask = 0;
 	int ret;
 
 	new_bus = devm_mdiobus_alloc(&pdev->dev);
@@ -5165,20 +5173,69 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->write = r8169_mdio_write_reg;
 
 	ret = mdiobus_register(new_bus);
+
+#ifdef R8169_PROBE_DEBUG
+	dev_info(&pdev->dev,
+		 "mdiobus_register: %s, %d\n",
+		 new_bus->id, ret);
+#endif
 	if (ret)
 		return ret;
 
 	tp->phydev = mdiobus_get_phy(new_bus, 0);
+
 	if (!tp->phydev) {
 		mdiobus_unregister(new_bus);
 		return -ENODEV;
-	} else if (!tp->phydev->drv) {
-		/* Most chip versions fail with the genphy driver.
-		 * Therefore ensure that the dedicated PHY driver is loaded.
-		 */
-		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
-		mdiobus_unregister(new_bus);
-		return -EUNATCH;
+	} else {
+		/* tp -> phydev ok */
+		int everything_OK = 0;
+
+		/* Check driver id versus phy */
+
+		if (tp->phydev->drv) {
+			u32 phydev_masked = 0xBEEFDEAD;
+			u32 drv_masked = ~0;
+			u32 phydev_match = ~0;
+			u32 drv_match = 0xDEADBEEF;
+
+			phydev_id = tp->phydev->phy_id;
+			phydrv_id = tp->phydev->drv->phy_id;
+			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
+
+			drv_masked = phydrv_id & phydrv_id_mask;
+			phydev_masked = phydev_id & phydrv_id_mask;
+		
+#ifdef R8169_PROBE_DEBUG
+			dev_debug(&pdev->dev,
+				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
+				new_bus->id, phydev_id, phydev_masked,
+				phydrv_id, drv_masked);
+#endif
+
+			phydev_match = phydev_masked & drv_masked;
+			phydev_match = phydev_match == phydev_masked;
+
+			drv_match = phydev_masked & drv_masked;
+			drv_match = drv_match == drv_masked;
+
+#ifdef R8169_PROBE_DEBUG
+			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
+				  new_bus->id, phydev_match, drv_match);
+#endif
+
+			everything_OK = (phydev_match == drv_match);
+		}
+
+		if (!everything_OK) {
+			/* Most chip versions fail with the genphy driver.
+			 * Therefore ensure that the dedicated PHY driver
+			 * is loaded.
+			 */
+			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+			mdiobus_unregister(new_bus);
+			return -EUNATCH;
+		}
 	}
 
 	/* PHY will be woken up in rtl_open() */
@@ -5435,6 +5492,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u64_stats_init(&tp->rx_stats.syncp);
 	u64_stats_init(&tp->tx_stats.syncp);
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: MAC\n");
+#endif
+
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
@@ -5483,29 +5544,64 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXFCS;
 
 	jumbo_max = rtl_jumbo_max(tp);
+
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
+#endif
+
 	if (jumbo_max)
 		dev->max_mtu = jumbo_max;
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: irq mask\n");
+#endif
+	
 	rtl_set_irq_mask(tp);
 
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
+#endif
+
 	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
 					    &tp->counters_phys_addr,
 					    GFP_KERNEL);
 	if (!tp->counters)
 		return -ENOMEM;
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: set driver data\n");
+#endif
+
 	pci_set_drvdata(pdev, dev);
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: register mdio\n");
+#endif
+
 	rc = r8169_mdio_register(tp);
+
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
+#endif
+
 	if (rc)
 		return rc;
 
 	/* chip gets powered up in rtl_open() */
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: pll pwr down\n");
+#endif
+
 	rtl_pll_power_down(tp);
 
 	rc = register_netdev(dev);
+
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
+#endif
+
 	if (rc)
 		goto err_mdio_unregister;
 
@@ -5525,6 +5621,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_sync(&pdev->dev);
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
+#endif
+
 	return 0;
 
 err_mdio_unregister:
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 522760c8bca6..41777f379a57 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -112,14 +112,22 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
-
+	struct phy_device *rv = NULL;
+/*
+	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
+*/
 	if (!mdiodev)
 		return NULL;
 
 	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
 		return NULL;
 
-	return container_of(mdiodev, struct phy_device, mdio);
+	rv = container_of(mdiodev, struct phy_device, mdio);
+/*
+ 	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
+		 bus->id, addr, mdiodev, rv);
+*/
+	return rv;
 }
 EXPORT_SYMBOL(mdiobus_get_phy);
 
@@ -645,10 +653,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	pr_info("%s: probed (mdiobus_register)\n", bus->name);
 	return 0;
 
 error:
+	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
 	while (--i >= 0) {
 		mdiodev = bus->mdio_map[i];
 		if (!mdiodev)
-- 
2.26.0




On 2020-04-13 14:34, Leon Romanovsky wrote:
> On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote:
>> Hi,
>>
>> Comments inline.
>>
>> On 2020-04-13 13:58, Leon Romanovsky wrote:
>>> On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
>>>> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
>>>> From: Lauri Jakku <lja@iki.fi>
>>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
>>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>
>>>> The driver installation determination made properly by
>>>> checking PHY vs DRIVER id's.
>>>> ---
>>>>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>>>>  drivers/net/phy/mdio_bus.c                | 11 +++-
>>>>  2 files changed, 72 insertions(+), 9 deletions(-)
>>>
>>> I would say that most of the code is debug prints.
>>>
>>
>> I tought that they are helpful to keep, they are using the debug calls, so
>> they are not visible if user does not like those.
> 
> You are missing the point of who are your users.
> 
> Users want to have working device and the code. They don't need or like
> to debug their kernel.
> 
> Thanks
> 

-- 
Br,
Lauri J.

--------------682D0E56722D4FBBD808EED3
Content-Type: text/x-patch; charset=UTF-8;
 name="NET-r8169-module-enchansments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="NET-r8169-module-enchansments.patch"

From 1a75f6f9065a58180de1fa3c48fd80418af6c347 Mon Sep 17 00:00:00 2001
From: Lauri Jakku <lja@iki.fi>
Date: Mon, 13 Apr 2020 13:18:35 +0300
Subject: [PATCH] NET: r8168/r8169 identifying fix

The driver installation determination made properly by
checking PHY vs DRIVER id's.
---
 drivers/net/ethernet/realtek/r8169_main.c | 114 ++++++++++++++++++++--
 drivers/net/phy/mdio_bus.c                |  15 ++-
 2 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bf5bf05970a2..5e992f285527 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -61,6 +61,11 @@
 #define R8169_MSG_DEFAULT \
 	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
 
+
+/*
+#define R8169_PROBE_DEBUG
+*/
+	
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
 #define	MC_FILTER_LIMIT	32
@@ -5149,6 +5154,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 {
 	struct pci_dev *pdev = tp->pci_dev;
 	struct mii_bus *new_bus;
+	u32 phydev_id = 0;
+	u32 phydrv_id = 0;
+	u32 phydrv_id_mask = 0;
 	int ret;
 
 	new_bus = devm_mdiobus_alloc(&pdev->dev);
@@ -5165,20 +5173,69 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->write = r8169_mdio_write_reg;
 
 	ret = mdiobus_register(new_bus);
+
+#ifdef R8169_PROBE_DEBUG
+	dev_info(&pdev->dev,
+		 "mdiobus_register: %s, %d\n",
+		 new_bus->id, ret);
+#endif
 	if (ret)
 		return ret;
 
 	tp->phydev = mdiobus_get_phy(new_bus, 0);
+
 	if (!tp->phydev) {
 		mdiobus_unregister(new_bus);
 		return -ENODEV;
-	} else if (!tp->phydev->drv) {
-		/* Most chip versions fail with the genphy driver.
-		 * Therefore ensure that the dedicated PHY driver is loaded.
-		 */
-		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
-		mdiobus_unregister(new_bus);
-		return -EUNATCH;
+	} else {
+		/* tp -> phydev ok */
+		int everything_OK = 0;
+
+		/* Check driver id versus phy */
+
+		if (tp->phydev->drv) {
+			u32 phydev_masked = 0xBEEFDEAD;
+			u32 drv_masked = ~0;
+			u32 phydev_match = ~0;
+			u32 drv_match = 0xDEADBEEF;
+
+			phydev_id = tp->phydev->phy_id;
+			phydrv_id = tp->phydev->drv->phy_id;
+			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
+
+			drv_masked = phydrv_id & phydrv_id_mask;
+			phydev_masked = phydev_id & phydrv_id_mask;
+		
+#ifdef R8169_PROBE_DEBUG
+			dev_debug(&pdev->dev,
+				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
+				new_bus->id, phydev_id, phydev_masked,
+				phydrv_id, drv_masked);
+#endif
+
+			phydev_match = phydev_masked & drv_masked;
+			phydev_match = phydev_match == phydev_masked;
+
+			drv_match = phydev_masked & drv_masked;
+			drv_match = drv_match == drv_masked;
+
+#ifdef R8169_PROBE_DEBUG
+			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
+				  new_bus->id, phydev_match, drv_match);
+#endif
+
+			everything_OK = (phydev_match == drv_match);
+		}
+
+		if (!everything_OK) {
+			/* Most chip versions fail with the genphy driver.
+			 * Therefore ensure that the dedicated PHY driver
+			 * is loaded.
+			 */
+			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+			mdiobus_unregister(new_bus);
+			return -EUNATCH;
+		}
 	}
 
 	/* PHY will be woken up in rtl_open() */
@@ -5435,6 +5492,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u64_stats_init(&tp->rx_stats.syncp);
 	u64_stats_init(&tp->tx_stats.syncp);
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: MAC\n");
+#endif
+
 	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
@@ -5483,29 +5544,64 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXFCS;
 
 	jumbo_max = rtl_jumbo_max(tp);
+
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
+#endif
+
 	if (jumbo_max)
 		dev->max_mtu = jumbo_max;
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: irq mask\n");
+#endif
+	
 	rtl_set_irq_mask(tp);
 
 	tp->fw_name = rtl_chip_infos[chipset].fw_name;
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
+#endif
+
 	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
 					    &tp->counters_phys_addr,
 					    GFP_KERNEL);
 	if (!tp->counters)
 		return -ENOMEM;
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: set driver data\n");
+#endif
+
 	pci_set_drvdata(pdev, dev);
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: register mdio\n");
+#endif
+
 	rc = r8169_mdio_register(tp);
+
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
+#endif
+
 	if (rc)
 		return rc;
 
 	/* chip gets powered up in rtl_open() */
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: pll pwr down\n");
+#endif
+
 	rtl_pll_power_down(tp);
 
 	rc = register_netdev(dev);
+
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
+#endif
+
 	if (rc)
 		goto err_mdio_unregister;
 
@@ -5525,6 +5621,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_sync(&pdev->dev);
 
+#ifdef R816X_PROBE_DEBUG
+	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
+#endif
+
 	return 0;
 
 err_mdio_unregister:
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 522760c8bca6..41777f379a57 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -112,14 +112,22 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
 	struct mdio_device *mdiodev = bus->mdio_map[addr];
-
+	struct phy_device *rv = NULL;
+/*
+	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
+*/
 	if (!mdiodev)
 		return NULL;
 
 	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
 		return NULL;
 
-	return container_of(mdiodev, struct phy_device, mdio);
+	rv = container_of(mdiodev, struct phy_device, mdio);
+/*
+ 	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
+		 bus->id, addr, mdiodev, rv);
+*/
+	return rv;
 }
 EXPORT_SYMBOL(mdiobus_get_phy);
 
@@ -645,10 +653,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	pr_info("%s: probed (mdiobus_register)\n", bus->name);
 	return 0;
 
 error:
+	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
 	while (--i >= 0) {
 		mdiodev = bus->mdio_map[i];
 		if (!mdiodev)
-- 
2.26.0


--------------682D0E56722D4FBBD808EED3--
